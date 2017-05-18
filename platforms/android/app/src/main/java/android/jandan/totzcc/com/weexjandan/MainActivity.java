package android.jandan.totzcc.com.weexjandan;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

import com.taobao.weex.IWXRenderListener;
import com.taobao.weex.WXSDKInstance;
import com.taobao.weex.common.WXRenderStrategy;

public class MainActivity extends AppCompatActivity implements IWXRenderListener{

    WXSDKInstance instance;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        String weexURL = getIntent().getDataString();
        setContentView(R.layout.activity_main);
        instance = new WXSDKInstance(this);
        instance.registerRenderListener(this);
        if (weexURL != null) {
            instance.renderByUrl(getString(R.string.app_name), weexURL ,null, null, WXRenderStrategy.APPEND_ASYNC);
        } else {
            instance.renderByUrl(getString(R.string.app_name), getString(R.string.weex_main_url) ,null, null, WXRenderStrategy.APPEND_ASYNC);
        }
    }

    @Override
    public void onViewCreated(WXSDKInstance instance, View view) {
        setContentView(view);
    }

    @Override
    public void onRenderSuccess(WXSDKInstance instance, int width, int height) {

    }

    @Override
    public void onRefreshSuccess(WXSDKInstance instance, int width, int height) {

    }

    @Override
    public void onException(WXSDKInstance instance, String errCode, String msg) {

    }

    @Override
    protected void onStart() {
        super.onStart();
        instance.onActivityStart();
    }

    @Override
    protected void onResume() {
        super.onResume();
        instance.onActivityResume();
    }

    @Override
    protected void onStop() {
        super.onStop();
        instance.onActivityStop();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        instance.onActivityDestroy();
    }

    @Override
    protected void onPause() {
        super.onPause();
        instance.onActivityPause();
    }
}
