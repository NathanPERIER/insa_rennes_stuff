package fr.insarennes.nperier.pm.tp3;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentManager;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import fr.insarennes.nperier.pm.tp3.data.Category;
import fr.insarennes.nperier.pm.tp3.data.Task;
import fr.insarennes.nperier.pm.tp3.detail.DetailActivity;
import fr.insarennes.nperier.pm.tp3.detail.DetailFragment;
import fr.insarennes.nperier.pm.tp3.data.TaskInterface;
import fr.insarennes.nperier.pm.tp3.tasks.TasksFragment;

@RequiresApi(api = Build.VERSION_CODES.N)
public class MainActivity extends AppCompatActivity implements TaskInterface {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // On first instantiation only
        if(savedInstanceState == null) {
            FragmentManager fm = getSupportFragmentManager();
            TasksFragment fragment = (TasksFragment) fm.findFragmentById(R.id.tasks_fragment);
            fragment.addTask(new Task("Aller cueillir des choux-fleurs", Category.Sport, 30, "C'est pour offrir"));
        }
    }

    public void taskSelected(Task t) {
        FragmentManager fm = getSupportFragmentManager();
        DetailFragment fragment = (DetailFragment) fm.findFragmentById(R.id.detail_fragment);
        if(fragment != null && fragment.isInLayout()) {     // When in landscape mode, the fragment is already there
            fragment.setContent(t);
        } else {                                            // When in portait mode, we have to create a new activity
            Intent intent = new Intent(getApplicationContext(), DetailActivity.class);
            intent.putExtra(DetailActivity.TASK_EXTRA, t);
            startActivity(intent);
        }
    }

}