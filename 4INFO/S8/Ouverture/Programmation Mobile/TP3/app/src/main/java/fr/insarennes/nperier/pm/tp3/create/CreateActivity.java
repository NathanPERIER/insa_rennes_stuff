package fr.insarennes.nperier.pm.tp3.create;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;

import androidx.annotation.RequiresApi;

import java.util.Arrays;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import fr.insarennes.nperier.pm.injection.Injector;
import fr.insarennes.nperier.pm.tp3.R;
import fr.insarennes.nperier.pm.tp3.data.Category;
import fr.insarennes.nperier.pm.tp3.data.Task;

public class CreateActivity extends Activity {

    public static final String EXTRA_TASK = "task";

    private static final Pattern pattern = Pattern.compile("[0-9]+");

    @Injector.ViewChild public EditText nameEdit;
    @Injector.ViewChild public EditText durationEdit;
    @Injector.ViewChild public EditText descriptionEdit;
    @Injector.ViewChild public Spinner categorySpinner;
    @Injector.ViewChild public Button addButton;

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create);

        Injector.resolve(this);

        addButton.setOnClickListener(this::onClick);

        // Put the values of the enum in the spinner
        categorySpinner.setAdapter(new ArrayAdapter<>(
                this,
                android.R.layout.simple_spinner_item,
                Arrays.stream(Category.values()).map(Enum::toString).collect(Collectors.toList()))
        );
    }

    // Called when the user clicks on the button to validate the creation of the task
    private void onClick(View view) {
        Intent data = new Intent();
        String duration = durationEdit.getText().toString();
        if(!pattern.matcher(duration).matches()) {
            durationEdit.setText("");
            return;
        }
        Task t = new Task(
                nameEdit.getText().toString(),
                categorySpinner.getSelectedItem().toString(),
                duration,
                descriptionEdit.getText().toString()
        );
        data.putExtra(EXTRA_TASK, t);           // This is fine because the task is a `Parcelable`
        setResult(Activity.RESULT_OK, data);
        finish();
    }

}
