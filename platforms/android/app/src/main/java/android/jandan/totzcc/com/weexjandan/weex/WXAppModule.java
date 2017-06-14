package android.jandan.totzcc.com.weexjandan.weex;

import android.jandan.totzcc.com.weexjandan.MessageReceiver;

import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;

/**
 * Created by Administrator on 2017/6/12.
 */

public class WXAppModule extends WXModule {
    /**
     * 获得设备唯一标识
     * @param callback
     */
    @JSMethod
    public void getDeviceId(JSCallback callback){
        String deviceId = PushServiceFactory.getCloudPushService().getDeviceId();
        callback.invoke(deviceId);
    }

    /**
     * 获得最近通知
     * @param callback
     */
    @JSMethod
    public void getRecentNotification(JSCallback callback){
        callback.invoke(MessageReceiver.recentNotification);
        MessageReceiver.recentNotification = null;
    }
}
