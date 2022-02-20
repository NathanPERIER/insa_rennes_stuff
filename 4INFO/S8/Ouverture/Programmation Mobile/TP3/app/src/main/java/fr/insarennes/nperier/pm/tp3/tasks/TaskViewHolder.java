package fr.insarennes.nperier.pm.tp3.tasks;

import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import fr.insarennes.nperier.pm.injection.Injector;

public class TaskViewHolder extends RecyclerView.ViewHolder {

    @Injector.ViewChild public TextView durationText;
    @Injector.ViewChild public TextView nameText;
    @Injector.ViewChild public ImageView categoryImage;
    @Injector.ViewChild public LinearLayout taskLayout;

    public TaskViewHolder(@NonNull View itemView) {
        super(itemView);
        Injector.resolve(this, itemView::findViewById);
        durationText.setHeight(45);
    }
    
}
