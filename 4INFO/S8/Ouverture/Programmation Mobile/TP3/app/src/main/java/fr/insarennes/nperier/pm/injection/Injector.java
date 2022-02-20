package fr.insarennes.nperier.pm.injection;

import android.annotation.TargetApi;
import android.app.Activity;
import android.os.Build;
import android.util.Log;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.Arrays;
import java.util.function.Function;

import fr.insarennes.nperier.pm.tp3.R;

// This is an utility for injecting a View in a class via annotations
// Don't try to figure out how it works, just know that it does

public class Injector {

    private static final Class<?> source = R.id.class;

    private Injector() {} // Disable constructor for this utility class

    public static void resolve(Activity activity) {
        resolve(activity, activity::findViewById);
    }

    @TargetApi(Build.VERSION_CODES.N)
    public static void resolve(Object view, Function<Integer, Object> finder) {
        Log.i("INJECT", "view");
        Class<?> clazz = view.getClass();
        Log.i("INJECT", clazz.getCanonicalName());
        Arrays.stream(clazz.getDeclaredFields())
                .filter(f -> f.isAnnotationPresent(ViewChild.class))
                .forEach(f -> {
                    ViewChild inject = f.getAnnotation(ViewChild.class);
                    String varname = inject.value();
                    if(varname.length() == 0) {
                        varname = f.getName();
                    }
                    Log.i("INJECT", "varname = " + varname);
                    try {
                        Field fi = source.getField(varname);
                        if(!Modifier.isStatic(fi.getModifiers())) {
                            throw new InjectionException("Field " + varname + " from class " + source.getName() + " is not statically injectible");
                        }
                        try {
                            int id = (Integer) fi.get(null);
                            Log.i("INJECT", "id = " + id);
                            Object data = finder.apply(id);
                            if(data == null) {
                                throw new InjectionException("Object " + varname + " of id " + id + " does not exist in the context of " + clazz.getCanonicalName());
                            }
                            Log.i("INJECT", "data = " + data);
                            if(!f.isAccessible()) {
                                f.setAccessible(true);
                            }
                            if(!f.getType().isAssignableFrom(data.getClass())) {
                                Log.e("INJECT", "not assignable");
                                throw new InjectionException("Object of type " + data.getClass().getName() + " is not assignable to field \"" + varname + "\" of type " + f.getType().getName() + " in class " + f.getDeclaringClass().getName());
                            }
                            f.set(view, data);
                        } catch (IllegalAccessException e) {
                            throw new InjectionException("Field " + varname + " from class " + source.getName() + " is not accessible");
                        }
                    } catch (NoSuchFieldException e) {
                        throw new InjectionException("No injectible field " + varname + " in class " + source.getName());
                    }
                });
    }


    private static class InjectionException extends RuntimeException {
        public InjectionException(String message) {
            super(message);
        }
    }


    @Retention(RetentionPolicy.RUNTIME)
    public @interface ViewChild {
        String value() default "";
    }

}
