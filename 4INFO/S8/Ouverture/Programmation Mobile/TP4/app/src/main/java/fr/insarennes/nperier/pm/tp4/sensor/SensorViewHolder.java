package fr.insarennes.nperier.pm.tp4.sensor;

import android.hardware.Sensor;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import fr.insarennes.nperier.pm.injection.Injector;

public class SensorViewHolder extends RecyclerView.ViewHolder {

    @Injector.ViewChild private TextView sensorName;

    public SensorViewHolder(@NonNull View itemView) {
        super(itemView);
        Injector.resolve(this, itemView::findViewById);
    }

    public void setContent(Sensor s) {
        sensorName.setText(s.getName());
    }

}
