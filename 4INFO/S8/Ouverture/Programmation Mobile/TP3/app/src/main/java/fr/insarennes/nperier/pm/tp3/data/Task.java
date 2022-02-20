package fr.insarennes.nperier.pm.tp3.data;

import android.os.Parcel;
import android.os.Parcelable;

public class Task implements Parcelable {

    private final String name;
    private final int duration;
    private final String description;
    private final Category category;

    public Task(String n, Category cat, int d, String desc) {
        name = n;
        category = cat;
        duration = d;
        description = desc;
    }

    public Task(String n, String cat, String d, String desc) {
        this(n, Category.valueOf(cat), Integer.parseInt(d), desc);
    }

    public Task(String n) {
        this(n, Category.Autre, 0, null);
    }

    public Task(Parcel p) {
        this(p.readString(), p.readString(), p.readString(), p.readString());
    }

    public String getName() {
        return name;
    }

    public Category getCategory() {
        return category;
    }

    public int getDuration() {
        return duration;
    }

    public String formattedDuration() {
        if(duration <= 0) {
            return "0 min";
        }
        int min = duration % 60;
        int hrs = duration / 60;
        if(hrs > 0) {
            return hrs + " h" + (min > 0 ? (" " + min + " min") : "");
        }
        return min + " min";
    }

    public String getDescription() {
        return description;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeString(name);
        parcel.writeString(category.toString());
        parcel.writeString(String.valueOf(duration));
        parcel.writeString(description);
    }

    public static final Creator<Task> CREATOR = new Creator<Task>() {
        @Override
        public Task createFromParcel(Parcel in) {
            return new Task(in);
        }

        @Override
        public Task[] newArray(int size) {
            return new Task[size];
        }
    };
}
