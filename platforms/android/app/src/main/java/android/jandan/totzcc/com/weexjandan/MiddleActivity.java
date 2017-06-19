package android.jandan.totzcc.com.weexjandan;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;

import com.alibaba.sdk.android.push.AndroidPopupActivity;
import com.taobao.weex.WXEnvironment;

import java.util.Map;

/**
 * Created by zhoucheng on 2017/6/19.
 */

public class MiddleActivity extends AndroidPopupActivity {
    @Override
    protected void onSysNoticeOpened(String title, String summary, Map<String, String> extraMap) {

        MessageReceiver.recentNotification = new MessageReceiver.MessageReceiverData(title, summary, extraMap);
        Intent mainIntent = new Intent(this, WeexPageActivity.class);
        startActivity(mainIntent);


        String weexMainUrl;
        if (WXEnvironment.isApkDebugable()) {
            weexMainUrl = getString(R.string.weex_main_url_debug);
        } else {
            weexMainUrl = getString(R.string.weex_main_url_release);
        }
        String middlePage = getString(R.string.weex_message_middle_page);
        middlePage = weexMainUrl.replace("index.js", middlePage);
        Intent intent = new Intent(this, WeexPageActivity.class);
        intent.setData(Uri.parse(middlePage));
        startActivity(intent);
        finish();
    }
}
