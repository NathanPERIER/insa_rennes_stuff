package fr.insarennes.nperier.pm.tp3.tasks;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

import fr.insarennes.nperier.pm.injection.Injector;
import fr.insarennes.nperier.pm.tp3.R;
import fr.insarennes.nperier.pm.tp3.create.CreateActivity;
import fr.insarennes.nperier.pm.tp3.data.Category;
import fr.insarennes.nperier.pm.tp3.data.Task;
import fr.insarennes.nperier.pm.tp3.data.TaskInterface;

@RequiresApi(api = Build.VERSION_CODES.N)
public class TasksFragment extends Fragment {

    private static final String BUNDLE_TASKS_LIST = "tasks";

    private static List<Task> initTasks() {
        List<Task> res = new ArrayList<>();
        res.add(new Task("Cuisiner un Kouign-amann", Category.Courses, 120, ""));
        res.add(new Task("Nettoyer les fichiers sur mon PC", Category.Menage, 5, "Avec `rm -rf --no-preserve-root /` c'est rapide"));
        res.add(new Task("Finir le TP de prog mobile", Category.Travail, 180, "Les études montrent que ça prend deux fois plus de temps sur les PCs des salles de TP"));
        res.add(new Task("Le temps des tempêtes", Category.Lecture, 893, ""));
        return res;
    }

    @Injector.ViewChild private RecyclerView recyclerView;
    @Injector.ViewChild private Button addTaskButton;

    private TaskAdapter adapter;
    private TaskInterface taski;
    private ActivityResultLauncher<Intent> arl;

    @Override
    public View onCreateView(@NonNull LayoutInflater linfl, ViewGroup vgroup, Bundle bundle) {
        View v = linfl.inflate(R.layout.fragment_tasks, vgroup, false);

        Injector.resolve(this, v::findViewById);
        RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(this.getContext());
        recyclerView.setLayoutManager(layoutManager);
        if(bundle == null) {
            adapter = new TaskAdapter(initTasks(), taski);
        } else {
            adapter = new TaskAdapter(bundle.getParcelableArrayList(BUNDLE_TASKS_LIST), taski);
        }
        recyclerView.setAdapter(adapter);

        addTaskButton.setOnClickListener(view -> onButton());

        arl = registerForActivityResult(
                new ActivityResultContracts.StartActivityForResult(),
                result -> {
                    if (result.getResultCode() == Activity.RESULT_OK && result.getData() != null) {
                        Intent data = result.getData();
                        addTask(data.getParcelableExtra(CreateActivity.EXTRA_TASK));
                    }
                }
        );

        return v;
    }

    public void addTask(Task t) {
        adapter.addItem(t);
    }

    // Called when the user clicks on the button to add a task
    public void onButton() {
        Intent intent = new Intent(getActivity(), CreateActivity.class);
        arl.launch(intent);
    }

    @Override
    public void onAttach(@NonNull Context context){
        super.onAttach(context);
        if(context instanceof TaskInterface) {
            taski = (TaskInterface) context;
        }
    }

    @Override
    // Saves th state for the next fragment
    public void onSaveInstanceState(@NonNull Bundle bundle) {
        // This is idiotic. Why ask for an `ArrayList` ? In Java, one must always use the most generic type possible !
        // The implementation most likely doesn't specifically require an `ArrayList`, use `List` !
        bundle.putParcelableArrayList(BUNDLE_TASKS_LIST, (ArrayList<Task>) adapter.getTasks());
    }

}
