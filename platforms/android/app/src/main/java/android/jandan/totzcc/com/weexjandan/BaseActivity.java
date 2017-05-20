package android.jandan.totzcc.com.weexjandan;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;

import com.pgyersdk.update.PgyUpdateManager;

/**
 * Created by leo on 17/5/20.
 */

public class BaseActivity extends AppCompatActivity {
    private static boolean isFirstRun = true;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (isFirstRun) {
            PgyUpdateManager.register(this, "jandan");
            isFirstRun = false;
        }
    }
}
