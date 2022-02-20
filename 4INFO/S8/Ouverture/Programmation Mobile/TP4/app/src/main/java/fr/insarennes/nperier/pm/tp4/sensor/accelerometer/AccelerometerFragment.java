package fr.insarennes.nperier.pm.tp4.sensor.accelerometer;

import android.annotation.SuppressLint;
import android.hardware.SensorEvent;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import fr.insarennes.nperier.pm.injection.Injector;
import fr.insarennes.nperier.pm.tp4.R;
import fr.insarennes.nperier.pm.tp4.sensor.SensorUpdate;

public class AccelerometerFragment extends Fragment implements SensorUpdate {

    @Injector.ViewChild public TextView xText;
    @Injector.ViewChild public TextView yText;
    @Injector.ViewChild public TextView zText;

    private long lastUpdate;
    private float lastX;
    private float lastY;
    private float lastZ;

    private MediaPlayer mp;

    @Override
    public View onCreateView(@NonNull LayoutInflater linfl, ViewGroup vgroup, Bundle bundle) {
        View v = linfl.inflate(R.layout.fragment_accelerometer, vgroup, false);

        Injector.resolve(this, v::findViewById);

        mp = MediaPlayer.create(this.getContext(), R.raw.lightsabre);

        lastUpdate = 0L;
        lastX = 0;
        lastY = 0;
        lastZ = 0;

        return v;
    }

    @SuppressLint("SetTextI18n")
    public void setContent(SensorEvent e) {
        float x = e.values[0];
        float y = e.values[1];
        float z = e.values[2];

        xText.setText("ForceX: " + x);
        yText.setText("ForceY: " + y);
        zText.setText("ForceZ: " + z);

        long curTime = System.currentTimeMillis();
        if ((curTime - lastUpdate) > 100L) {
            float speed = Math.abs(x + y + z - lastX - lastY - lastZ) / (curTime - lastUpdate) * 10000f;
            if (speed > 500.0) {
                Log.i("SPEED", String.valueOf(speed));
                mp.start();
            }
            lastUpdate = curTime;
            lastX = x;
            lastY = y;
            lastZ = z;
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        mp.release();
    }
}
