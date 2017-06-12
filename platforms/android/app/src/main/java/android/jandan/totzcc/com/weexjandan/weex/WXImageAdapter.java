package android.jandan.totzcc.com.weexjandan.weex;

import android.widget.ImageView;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.display.RoundedBitmapDisplayer;
import com.taobao.weex.adapter.IWXImgLoaderAdapter;
import com.taobao.weex.common.WXImageStrategy;
import com.taobao.weex.dom.WXImageQuality;

/**
 * Created by zhoucheng on 2017/5/17.
 */

public class WXImageAdapter implements IWXImgLoaderAdapter {
    static DisplayImageOptions options = new DisplayImageOptions.Builder()
            .cacheInMemory(true)                               //启用内存缓存
            .cacheOnDisk(true)                                 //启用外存缓存
            .considerExifParams(true)                          //启用EXIF和JPEG图像格式
            .displayer(new RoundedBitmapDisplayer(20))         //设置显示风格这里是圆角矩形
            .build();
    @Override
    public void setImage(String url, final ImageView imageView, WXImageQuality quality, WXImageStrategy strategy) {
        ImageLoader.getInstance().displayImage(url, imageView, options);
    }
}
