package android.jandan.totzcc.com.weexjandan.weex;

import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;
import com.taobao.weex.utils.WXLogUtils;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Attribute;
import org.jsoup.nodes.Attributes;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

/**
 * Created by zhoucheng on 2017/5/18.
 */

public class WXHTMLModule extends WXModule {
    @JSMethod(uiThread = true)
    public void css(String html, String css, JSCallback callback) {
        if (html == null || html.isEmpty()) {
            callback.invoke(new ArrayList<>());
            return;
        }
        Document document = Jsoup.parse(html);
        Elements elements = document.select(css);
        ArrayList<String> strings = new ArrayList<String>(elements.size());
        for (Element element : elements) {
            strings.add(element.outerHtml());
        }
        callback.invoke(strings);
    }
    @JSMethod(uiThread = true)
    public void parse(String html, JSCallback callback) {
        if (html == null || html.isEmpty()) {
            callback.invoke(new HashMap<String,String>());
            return;
        }
        Elements elements = Jsoup.parse(html).body().children();
        if (elements.size() == 0) {
            callback.invoke(new HashMap<String,String>());
            return;
        } else {
            Element element = Jsoup.parse(html).body().child(0);
            Attributes attributes = element.attributes();
            Iterator<Attribute> iterator = attributes.iterator();
            HashMap<String, String> attrMaps = new HashMap<>();
            while (iterator.hasNext()) {
                Attribute attribute =  iterator.next();
                attrMaps.put(attribute.getKey(), attribute.getValue());
            }
            attrMaps.put("text", element.text());
            callback.invoke(attrMaps);
        }
    }
}
