package fr.nperier.ppd.tp2;

import java.io.Serializable;
import java.util.Date;

public class UserStampedMessage implements Message, Serializable {

    private static final long serialVersionUID = -7030360067801419072L;

    private final String msg;
    private final String user;
    private final long timestamp;

    public UserStampedMessage(String s, String u) {
        msg = s;
        user = u;
        timestamp = System.currentTimeMillis();
    }

    public String toString() {
        return new Date(timestamp) + " [" + user + "] " + msg;
    }

}
