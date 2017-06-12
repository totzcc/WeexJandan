package android.jandan.totzcc.com.weexjandan.weex;

import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;

/**
 * Created by Administrator on 2017/6/12.
 */

public class WXAppModule extends WXModule {
    @JSMethod
    public void getDeviceId(JSCallback callback){
        String deviceId = PushServiceFactory.getCloudPushService().getDeviceId();
        callback.invoke(deviceId);
    }
}
