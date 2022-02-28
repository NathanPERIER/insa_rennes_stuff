package fr.insarennes.nperier.pm.tp4.sensor;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Bundle;
import android.widget.TextView;

import androidx.annotation.RequiresApi;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import fr.insarennes.nperier.pm.injection.Injector;
import fr.insarennes.nperier.pm.tp4.R;
import fr.insarennes.nperier.pm.tp4.sensor.accelerometer.AccelerometerFragment;
import fr.insarennes.nperier.pm.tp4.sensor.proximity.ProximityFragment;

public class SensorActivity extends FragmentActivity implements SensorEventListener {

    private static final Map<Integer, Class<? extends Fragment>> UPDATERS = new HashMap<>();

    static {
        UPDATERS.put(Sensor.TYPE_ACCELEROMETER, AccelerometerFragment.class);
        UPDATERS.put(Sensor.TYPE_PROXIMITY, ProximityFragment.class);
    }


    @RequiresApi(api = Build.VERSION_CODES.O)
    private static void createFragment(Sensor s, FragmentManager fm) {
        if(fm.findFragmentById(R.id.detailsLayout) == null && UPDATERS.containsKey(s.getType())) {
            Class<? extends Fragment> clazz = UPDATERS.get(s.getType());
            Optional<Constructor<?>> opt = Arrays.stream(clazz.getConstructors())
                    .filter(c -> c.getParameters().length == 0)
                    .findFirst();
            if(!opt.isPresent()) {
                throw new RuntimeException("Class " + clazz.getCanonicalName() + " has no empty constructor");
            }
            FragmentTransaction ft = fm.beginTransaction();
            try {
                ft.add(R.id.detailsLayout, (Fragment) opt.get().newInstance());
            } catch (IllegalAccessException | InstantiationException | InvocationTargetException e) {
                throw new RuntimeException(e);
            }
            ft.commit();
        }
    }

    public static String SENSOR_ID_EXTRA = "sensor_id";

    @Injector.ViewChild private TextView nameText;
    @Injector.ViewChild private TextView typeText;
    @Injector.ViewChild private TextView vendorText;
    @Injector.ViewChild private TextView versionText;
    @Injector.ViewChild private TextView powerText;
    @Injector.ViewChild private TextView resolutionText;

    private Sensor sensor;
    private FragmentManager fm;
    private SensorManager sm;

    @RequiresApi(api = Build.VERSION_CODES.O)
    @SuppressLint("SetTextI18n")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sensor);

        Injector.resolve(this);

        fm = getSupportFragmentManager();
        sm = (SensorManager) this.getSystemService(Context.SENSOR_SERVICE);

        Intent data = getIntent();
        String sensorName = data.getStringExtra(SENSOR_ID_EXTRA);
        Optional<Sensor> opt = sm.getSensorList(Sensor.TYPE_ALL)
                .stream()
                .filter(s -> s.getName().equals(sensorName))
                .findFirst();
        if(!opt.isPresent()) {
            throw new RuntimeException("No sensor found with name " + sensorName);
        }
        sensor = opt.get();

        nameText.setText(sensor.getName());
        typeText.setText("Type: " + sensor.getStringType());
        vendorText.setText("Vendor: " + sensor.getVendor());
        versionText.setText("Version: " + sensor.getVersion());
        powerText.setText("Power: " + sensor.getPower());
        resolutionText.setText("Resolution: " + sensor.getResolution());

//        if(sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
//            if(fm.findFragmentById(R.id.detailsLayout) == null) {
//                FragmentTransaction ft = fm.beginTransaction();
//                ft.add(R.id.detailsLayout, new AccelerometerFragment());
//                ft.commit();
//            }
//        } else if(sensor.getType() == Sensor.TYPE_PROXIMITY) {
//            if(fm.findFragmentById(R.id.detailsLayout) == null) {
//                FragmentTransaction ft = fm.beginTransaction();
//                ft.add(R.id.detailsLayout, new ProximityFragment());
//                ft.commit();
//            }
//        }
        createFragment(sensor, fm);
    }


    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {
        SensorUpdate su = (SensorUpdate) fm.findFragmentById(R.id.detailsLayout);
        if(su != null) {
            su.setContent(sensorEvent);
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int i) { }

    @Override
    protected void onResume() {
        super.onResume();
        if(UPDATERS.containsKey(sensor.getType())) {
            sm.registerListener(this, sm.getDefaultSensor(sensor.getType()), SensorManager.SENSOR_DELAY_NORMAL);
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if(UPDATERS.containsKey(sensor.getType())) {
            sm.unregisterListener(this);
        }
    }
}
