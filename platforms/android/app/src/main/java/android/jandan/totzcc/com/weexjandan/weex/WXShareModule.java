package android.jandan.totzcc.com.weexjandan.weex;

import android.content.Intent;

import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.common.WXModule;

/**
 * Created by leo on 17/5/20.
 */

public class WXShareModule extends WXModule {
    @JSMethod
    public void share(String href, String title){
        Intent sendIntent = new Intent();
        sendIntent.setAction(Intent.ACTION_SEND);
        sendIntent.putExtra(Intent.EXTRA_TEXT, title + "\n" + href);
        sendIntent.setType("text/plain");
        mWXSDKInstance.getContext().startActivity(sendIntent);
    }
}
