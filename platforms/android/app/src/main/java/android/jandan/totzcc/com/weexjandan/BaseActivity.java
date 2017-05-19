package android.jandan.totzcc.com.weexjandan;

import android.support.v7.app.AppCompatActivity;

import com.taobao.weex.utils.WXLogUtils;

import java.io.IOException;

/**
 * Created by zhoucheng on 2017/5/19.
 */

public class BaseActivity extends AppCompatActivity{
    @Override
    protected void onStart() {
        super.onStart();
        try {
            JandanWebService.getInstance(this).onActivityStart();
        } catch (IOException e) {
            WXLogUtils.e("启动Web服务失败", e);
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        JandanWebService.getInstance(this).onActivityPause();
    }
}
