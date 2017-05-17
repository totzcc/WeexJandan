package android.jandan.totzcc.com.weexjandan;

import android.graphics.Bitmap;
import android.view.View;
import android.widget.ImageView;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;
import com.taobao.weex.adapter.IWXImgLoaderAdapter;
import com.taobao.weex.common.WXImageStrategy;
import com.taobao.weex.dom.WXImageQuality;

/**
 * Created by zhoucheng on 2017/5/17.
 */

public class WXImageAdapter implements IWXImgLoaderAdapter {
    @Override
    public void setImage(String url, final ImageView imageView, WXImageQuality quality, WXImageStrategy strategy) {
        ImageLoader.getInstance().displayImage(url, imageView);
    }
}
