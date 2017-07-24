package android.jandan.totzcc.com.weexjandan.weex;

import android.content.Intent;
import android.jandan.totzcc.com.weexjandan.WeexPageActivity;
import android.net.Uri;
import android.text.TextUtils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.taobao.weex.WXSDKEngine;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.appfram.navigator.WXNavigatorModule;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.Constants;
import com.taobao.weex.utils.WXLogUtils;

/**
 * Created by Administrator on 2017/7/19 0019.
 */

public class WXNavigatorConstomerModule extends WXNavigatorModule {
    public static final String MSG_SUCCESS = "WX_SUCCESS";
    public static final String MSG_FAILED = "WX_FAILED";

    private final static String INSTANCE_ID = "instanceId";
    private final static String TAG = "Navigator";
    private final static String WEEX = "com.taobao.android.intent.category.WEEX";
    private final static String WEEX_ACTION = "com.taobao.android.intent.action.WEEX";
    private final static String URL = "url";
    public WXNavigatorConstomerModule(){
        super();
    }
    @JSMethod
    @Override
    public void push(String param, JSCallback callback) {
        if (!TextUtils.isEmpty(param)) {
            if (WXSDKEngine.getActivityNavBarSetter() != null) {
                if (WXSDKEngine.getActivityNavBarSetter().push(param)) {
                    if (callback != null) {
                        callback.invoke(MSG_SUCCESS);
                    }
                    return;
                }
            }

            try {
                JSONObject jsonObject = JSON.parseObject(param);
                String url = jsonObject.getString(URL);
                if (!TextUtils.isEmpty(url)) {
                    Intent intent = new Intent(mWXSDKInstance.getContext(), WeexPageActivity.class);
                    intent.putExtra(INSTANCE_ID, mWXSDKInstance.getInstanceId());
                    intent.setData(Uri.parse(url));
                    mWXSDKInstance.getContext().startActivity(intent);
                    if (callback != null) {
                        callback.invoke(MSG_SUCCESS);
                    }
                }
            } catch (Exception e) {
                WXLogUtils.eTag(TAG, e);
                if (callback != null) {
                    callback.invoke(MSG_FAILED);
                }
            }
        }

        if (callback != null) {
            callback.invoke(MSG_FAILED);
        }
    }
}
