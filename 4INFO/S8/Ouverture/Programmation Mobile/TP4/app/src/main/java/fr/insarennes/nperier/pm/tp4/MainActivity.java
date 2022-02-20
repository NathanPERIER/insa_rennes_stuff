package fr.insarennes.nperier.pm.tp4;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import fr.insarennes.nperier.pm.injection.Injector;
import fr.insarennes.nperier.pm.tp4.sensor.SensorActivity;
import fr.insarennes.nperier.pm.tp4.sensor.SensorAdapter;

public class MainActivity extends AppCompatActivity {

    @Injector.ViewChild  private RecyclerView sensorsView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Injector.resolve(this);

        RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(this);
        sensorsView.setLayoutManager(layoutManager);
        SensorManager manager = (SensorManager) this.getSystemService(Context.SENSOR_SERVICE);
        SensorAdapter adapter = new SensorAdapter(manager.getSensorList(Sensor.TYPE_ALL), this::onSelectSensor);
        sensorsView.setAdapter(adapter);
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public void onSelectSensor(Sensor s) {
        Intent intent = new Intent(this, SensorActivity.class);
        intent.putExtra(SensorActivity.SENSOR_ID_EXTRA, s.getName());
        startActivity(intent);
    }
}