package fr.insarennes.nperier.pm.tp4.sensor.proximity;

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

public class ProximityFragment extends Fragment implements SensorUpdate {

    @Injector.ViewChild public TextView distanceText;

    private MediaPlayer mp;
    private long lastUpdate;

    @Override
    public View onCreateView(@NonNull LayoutInflater linfl, ViewGroup vgroup, Bundle bundle) {
        View v = linfl.inflate(R.layout.fragment_proximity, vgroup, false);

        Injector.resolve(this, v::findViewById);

        lastUpdate = System.currentTimeMillis();

        mp = MediaPlayer.create(this.getContext(), R.raw.sabreclash);

        return v;
    }

    @SuppressLint("SetTextI18n")
    public void setContent(SensorEvent e) {
        float d = e.values[0];

        distanceText.setText("Distance: " + d + " cm");

        long curTime = System.currentTimeMillis();
        if ((curTime - lastUpdate) > 100L) {
            if (d < 8.0) {
                mp.start();
            }
            lastUpdate = curTime;
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        mp.release();
    }

}
