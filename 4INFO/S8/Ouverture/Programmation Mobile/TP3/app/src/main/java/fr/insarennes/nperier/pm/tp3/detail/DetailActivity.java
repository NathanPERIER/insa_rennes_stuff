package fr.insarennes.nperier.pm.tp3.detail;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.RequiresApi;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;

import fr.insarennes.nperier.pm.tp3.R;
import fr.insarennes.nperier.pm.tp3.data.Task;

public class DetailActivity extends FragmentActivity {

    public static final String TASK_EXTRA = "task";

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);

        Intent data = getIntent();

        Task t = data.getParcelableExtra(TASK_EXTRA);

        FragmentManager fm = getSupportFragmentManager();
        DetailFragment fragment = (DetailFragment) fm.findFragmentById(R.id.detail_fragment);
        fragment.setContent(t);
    }

}
