package android.jandan.totzcc.com.weexjandan.weex;

import android.widget.ImageView;

import com.nostra13.universalimageloader.core.ImageLoader;
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
