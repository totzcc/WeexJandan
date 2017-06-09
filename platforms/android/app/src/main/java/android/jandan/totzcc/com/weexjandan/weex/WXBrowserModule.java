package android.jandan.totzcc.com.weexjandan.weex;

import android.content.Intent;
import android.net.Uri;

import com.facebook.imagepipeline.request.ImageRequest;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.stfalcon.frescoimageviewer.ImageViewer;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.common.WXModule;

/**
 * Created by leo on 17/5/20.
 */

public class WXBrowserModule extends WXModule {
    @JSMethod
    public void browserImages(String[] images, int selectedIndex) {
        for (int i = 0; i < images.length; i++) {
            if (images[i].startsWith("//")) {
                images[i] = "http:" + images[i];
            }
        }
        ImageRequestBuilder requestBuilder = ImageRequestBuilder.newBuilderWithSource(Uri.parse(""))
                .setProgressiveRenderingEnabled(true)
                .setAutoRotateEnabled(true)
                .setCacheChoice(ImageRequest.CacheChoice.DEFAULT);
        new ImageViewer.Builder<String>(mWXSDKInstance.getContext(), images)
                .setCustomImageRequestBuilder(requestBuilder)
                .setStartPosition(selectedIndex)
                .show();
    }
    @JSMethod
    public void browserWeb(String url) {
        Intent intent = new Intent("android.intent.action.VIEW");
        intent.setData(Uri.parse(url));
        mWXSDKInstance.getContext().startActivity(intent);
    }
}
