package android.jandan.totzcc.com.weexjandan;

import android.app.Application;
import android.content.Context;

import com.taobao.weex.utils.WXLogUtils;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import fi.iki.elonen.NanoHTTPD;

/**
 * Created by zhoucheng on 2017/5/19.
 */

public class JandanWebService extends NanoHTTPD {
    private Context context;
    private static final int PORT = 9090;
    private static JandanWebService instance = new JandanWebService();
    private JandanWebService(){
        super(PORT);
    }
    public static JandanWebService getInstance(Context context){
        instance.context = context;
        return instance;
    }

    @Override
    public Response serve(IHTTPSession session) {
        List<String> urls = session.getParameters().get("url");

        if (urls != null && urls.size() > 0) {
            String url = urls.get(0);
            url = url.replace("http://www.jandan.net","http://i.jandan.net");
            url = url.replace("http://jandan.net","http://i.jandan.net");
            try {

                File filesDir = context.getApplicationContext().getFilesDir();
                File htmlFileDir = new File(filesDir.getAbsolutePath() + "/html");
                if (!htmlFileDir.exists()) {
                    htmlFileDir.mkdirs();
                }
                String md5 = MD5Tools.MD5(url);
                File htmlFile = new File(htmlFileDir.getAbsolutePath() + "/" + md5);
                if (htmlFile.exists()) {
                    Long length = htmlFile.length();
                    byte[] fileContent = new byte[length.intValue()];
                    FileInputStream fileInputStream = new FileInputStream(htmlFile);
                    fileInputStream.read(fileContent);
                    fileInputStream.close();
                    String html = new String(fileContent, "utf-8");
                    return newFixedLengthResponse(html);
                }

                StringBuffer sb = new StringBuffer();
                sb.append("<!DOCTYPE html>\n");
                sb.append("<html>\n");
                sb.append("<head>\n");
                sb.append("<meta charset=\"UTF-8\">\n");
                sb.append("<meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=yes;\">\n");
                sb.append("<link rel=\"stylesheet\" href=\"http://images-file.oss-cn-hangzhou.aliyuncs.com/weex/jandan/1.0.1/resources/read.css\" />\n");
                sb.append("<script src=\"https://lib.sinaapp.com/js/jquery/2.0.3/jquery-2.0.3.min.js\"></script>\n");
                sb.append("<script src=\"//cdn.jandan.net/static/js/jquery.lazyload.min.js?v=201603020\"></script>\n");
                sb.append("</head>\n");
                sb.append("<body>\n");


                Document document = Jsoup.connect(url).get();
                Element postinfo = document.select(".postinfo").get(0);
                Element entry = document.select(".entry").get(0);
                sb.append(postinfo.html());
                sb.append(entry.html());

                sb.append("\n");
                sb.append("<script src=\"http://images-file.oss-cn-hangzhou.aliyuncs.com/weex/jandan/1.0.1/resources/read.js\"></script>\n");
                sb.append("</body>\n");
                sb.append("</html>\n");
                FileOutputStream fos = new FileOutputStream(htmlFile);
                fos.write(sb.toString().getBytes("utf-8"));
                fos.close();
                return newFixedLengthResponse(sb.toString());
            } catch (IOException e) {
                WXLogUtils.e("获取文章详情失败", e);
                return newFixedLengthResponse("获取文章详情失败");
            }
        } else {
            return newFixedLengthResponse("");
        }
    }
    public void onActivityStart() throws IOException {
        if (!this.isAlive()) {
            WXLogUtils.i("启动Web服务：   http://127.0.0.1:" + PORT);
            this.start(NanoHTTPD.SOCKET_READ_TIMEOUT, false);
        }
    }
    public void onActivityPause(){
        if (this.isAlive()) {
            this.stop();
            WXLogUtils.i("关闭Web服务");
        }
    }
}
