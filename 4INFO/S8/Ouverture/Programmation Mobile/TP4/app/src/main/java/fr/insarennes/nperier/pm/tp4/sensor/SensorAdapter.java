package fr.insarennes.nperier.pm.tp4.sensor;

import android.hardware.Sensor;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;
import java.util.function.Consumer;

import fr.insarennes.nperier.pm.tp4.R;

public class SensorAdapter extends RecyclerView.Adapter<SensorViewHolder> {

    private final List<Sensor> sensors;
    private final Consumer<Sensor> onClick;

    public SensorAdapter(List<Sensor> l, Consumer<Sensor> c) {
        sensors = l;
        onClick = c;
    }

    @NonNull
    @Override
    public SensorViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        LayoutInflater linfl = LayoutInflater.from(parent.getContext());
        View v = linfl.inflate(R.layout.view_sensor, parent, false);
        return new SensorViewHolder(v);
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void onBindViewHolder(@NonNull SensorViewHolder holder, int position) {
        Sensor sensor = sensors.get(position);
        holder.setContent(sensor);
        holder.itemView.setOnClickListener(v -> onClick.accept(sensor));
    }

    @Override
    public int getItemCount() {
        return sensors.size();
    }
}
