package fr.insarennes.nperier.pm.tp3.tasks;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.recyclerview.widget.RecyclerView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import fr.insarennes.nperier.pm.tp3.R;
import fr.insarennes.nperier.pm.tp3.data.Category;
import fr.insarennes.nperier.pm.tp3.data.Task;
import fr.insarennes.nperier.pm.tp3.data.TaskInterface;


@RequiresApi(api = Build.VERSION_CODES.N)
public class TaskAdapter extends RecyclerView.Adapter<TaskViewHolder> {

    private static final Map<Category, Integer> IMAGE_IDS = new HashMap<>();

    static {
        IMAGE_IDS.put(Category.Travail, R.drawable.travail);
        IMAGE_IDS.put(Category.Courses, R.drawable.courses);
        IMAGE_IDS.put(Category.Lecture, R.drawable.lecture);
        IMAGE_IDS.put(Category.Menage, R.drawable.menage);
        IMAGE_IDS.put(Category.Sport, R.drawable.sport);
        IMAGE_IDS.put(Category.Enfants, R.drawable.enfants);
        IMAGE_IDS.put(Category.Autre, R.drawable.point_interro_);
    }

    private final List<Task> tasks;
    private final TaskInterface taski;

    public TaskAdapter(List<Task> lt, TaskInterface ti) {
        tasks = lt;
        taski = ti;
    }

    @NonNull
    @Override
    public TaskViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        LayoutInflater linfl = LayoutInflater.from(parent.getContext());
        View v = linfl.inflate(R.layout.view_task, parent, false);
        return new TaskViewHolder(v);
    }

    // Retireves the ID of an image based on the category
    public static int imageIdForCategory(Category cat) {
        // The warning is useless, null pointer exception cannot actually happen
        return IMAGE_IDS.getOrDefault(cat, R.drawable.point_interro_);
    }

    @SuppressLint("SetTextI18n")
    @Override
    public void onBindViewHolder(@NonNull TaskViewHolder holder, int position) {
        Task t = tasks.get(position);
        holder.nameText.setText(t.getName());
        holder.durationText.setText(t.formattedDuration());
        holder.categoryImage.setImageResource(imageIdForCategory(t.getCategory()));
        // When we click on the task, use the method of the `TaskInterface`
        holder.taskLayout.setOnClickListener(v -> taski.taskSelected(t));
        // For a long click, demand confirmation for deletion
        holder.itemView.setOnLongClickListener((View.OnLongClickListener) v -> {
            AlertDialog.Builder builder = new AlertDialog.Builder(v.getContext());
            builder.setMessage(R.string.confirm_message)
                    .setPositiveButton(R.string.confirm_ok, (dialog, id) -> {
                        tasks.remove(position);
                        notifyItemRemoved(position);
                    })
                    .setNegativeButton(R.string.confirm_cancel, (DialogInterface.OnClickListener) (dialog, id) -> { });
            builder.create().show();
            return true; // The click has been consumed
        });
    }

    // Adds an item at the end of the list and updates the display
    public void addItem(Task t) {
        tasks.add(t);
        notifyItemInserted(tasks.size() - 1);
    }

    public List<Task> getTasks() {
        return tasks;
    }

    @Override
    public int getItemCount() {
        return tasks.size();
    }

}
