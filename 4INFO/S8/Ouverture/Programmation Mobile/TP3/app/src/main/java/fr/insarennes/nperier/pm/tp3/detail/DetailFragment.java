package fr.insarennes.nperier.pm.tp3.detail;

import android.os.Build;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.fragment.app.Fragment;

import fr.insarennes.nperier.pm.injection.Injector;
import fr.insarennes.nperier.pm.tp3.R;
import fr.insarennes.nperier.pm.tp3.tasks.TaskAdapter;
import fr.insarennes.nperier.pm.tp3.data.Category;
import fr.insarennes.nperier.pm.tp3.data.Task;


@RequiresApi(api = Build.VERSION_CODES.N)
public class DetailFragment extends Fragment {

    @Injector.ViewChild public TextView detailTitleText;
    @Injector.ViewChild public TextView detailDurationText;
    @Injector.ViewChild public TextView detailDescriptionText;
    @Injector.ViewChild public ImageView detailCategoryImage;

    @Override
    public View onCreateView(@NonNull LayoutInflater linfl, ViewGroup vgroup, Bundle bundle) {
        View v = linfl.inflate(R.layout.fragment_detail, vgroup, false);

        Injector.resolve(this, v::findViewById);

        return v;
    }

    public void setContent(Task t) {
        setTitle(t.getName());
        setDuration(t.formattedDuration());
        setDescription(t.getDescription());
        setCategory(t.getCategory());
    }

    public void setTitle(String title) {
        detailTitleText.setText(title);
    }

    public void setDuration(String duration) {
        detailDurationText.setText(duration);
    }

    public void setDescription(String description) {
        detailDescriptionText.setText(description);
    }

    public void setCategory(Category category) {
        detailCategoryImage.setImageResource(TaskAdapter.imageIdForCategory(category));
    }
}
