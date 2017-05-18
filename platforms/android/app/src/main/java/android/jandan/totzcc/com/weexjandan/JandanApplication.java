package android.jandan.totzcc.com.weexjandan;

import android.app.Application;
import android.jandan.totzcc.com.weexjandan.weex.WXHTMLModule;
import android.jandan.totzcc.com.weexjandan.weex.WXImageAdapter;
import android.jandan.totzcc.com.weexjandan.weex.WXLogModule;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.taobao.weex.InitConfig;
import com.taobao.weex.WXSDKEngine;
import com.taobao.weex.common.WXException;
import com.taobao.weex.utils.WXLogUtils;

/**
 * Created by zhoucheng on 2017/5/17.
 */

public class JandanApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        InitConfig config = new InitConfig.Builder().setImgAdapter(new WXImageAdapter()).build();
        WXSDKEngine.initialize(this, config);
        try {
            WXSDKEngine.registerModule("html", WXHTMLModule.class);
            WXSDKEngine.registerModule("log", WXLogModule.class);
        } catch (WXException e) {
            WXLogUtils.e(e.getMessage(), e);
        }
        ImageLoaderConfiguration imageLoaderConfiguration = ImageLoaderConfiguration.createDefault(this);
        ImageLoader.getInstance().init(imageLoaderConfiguration);
    }
}
