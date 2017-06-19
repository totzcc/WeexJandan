package android.jandan.totzcc.com.weexjandan;

import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;
import android.jandan.totzcc.com.weexjandan.weex.WXAppModule;
import android.jandan.totzcc.com.weexjandan.weex.WXBrowserModule;
import android.jandan.totzcc.com.weexjandan.weex.WXHTMLModule;
import android.jandan.totzcc.com.weexjandan.weex.WXImageAdapter;
import android.jandan.totzcc.com.weexjandan.weex.WXLogModule;
import android.jandan.totzcc.com.weexjandan.weex.WXShareModule;

import com.alibaba.sdk.android.push.CloudPushService;
import com.alibaba.sdk.android.push.CommonCallback;
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
import com.alibaba.sdk.android.push.register.HuaWeiRegister;
import com.alibaba.sdk.android.push.register.MiPushRegister;
import com.baidu.mobstat.StatService;
import com.facebook.drawee.backends.pipeline.Fresco;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.pgyersdk.Pgy;
import com.taobao.weex.InitConfig;
import com.taobao.weex.WXEnvironment;
import com.taobao.weex.WXSDKEngine;
import com.taobao.weex.common.WXException;
import com.taobao.weex.utils.LogLevel;

/**
 * Created by zhoucheng on 2017/5/17.
 */

public class App extends Application {
    private static SharedPreferences sharedPreferences = null;
    @Override
    public void onCreate() {
        super.onCreate();
        sharedPreferences = getSharedPreferences("jandan", Context.MODE_PRIVATE);
        Fresco.initialize(this);
        InitConfig weexConfig = new InitConfig.Builder().setImgAdapter(new WXImageAdapter()).build();
        WXSDKEngine.initialize(this, weexConfig);
        if (!WXEnvironment.isApkDebugable()) {
            WXEnvironment.sLogLevel = LogLevel.WARN;
        }
        try {
            WXSDKEngine.registerModule("html", WXHTMLModule.class);
            WXSDKEngine.registerModule("log", WXLogModule.class);
            WXSDKEngine.registerModule("share", WXShareModule.class);
            WXSDKEngine.registerModule("browser", WXBrowserModule.class);
            WXSDKEngine.registerModule("app", WXAppModule.class);
        } catch (WXException e) {
            LogUtil.e(e.getMessage(), e);
        }
        ImageLoaderConfiguration imageLoaderConfiguration = ImageLoaderConfiguration.createDefault(this);
        ImageLoader.getInstance().init(imageLoaderConfiguration);
        initBaiduStat();
        initCloudChannel(this);
        Pgy.init(this, "c9d38faacab3e0dbbabbd94e5faceee6");
        MiPushRegister.register(this, "2882303761517586258", "5661758611258");
        HuaWeiRegister.register(this);
    }

    public void initBaiduStat() {
        StatService.setAppKey("fd9494003d");
        StatService.setOn(this, StatService.EXCEPTION_LOG);
        StatService.autoTrace(this, true, false);
    }
    /**
     * 初始化云推送通道
     * @param applicationContext
     */
    private void initCloudChannel(Context applicationContext) {
        PushServiceFactory.init(applicationContext);
        final CloudPushService pushService = PushServiceFactory.getCloudPushService();
        pushService.register(applicationContext, new CommonCallback() {
            @Override
            public void onSuccess(String response) {
                LogUtil.d("init cloudchannel success");
                LogUtil.d("DeviceId:"+pushService.getDeviceId());
            }
            @Override
            public void onFailed(String errorCode, String errorMessage) {
                LogUtil.d("init cloudchannel failed -- errorcode:" + errorCode + " -- errorMessage:" + errorMessage);
            }
        });
    }
    public static SharedPreferences getSharedPreferences(){
        return sharedPreferences;
    }
}
