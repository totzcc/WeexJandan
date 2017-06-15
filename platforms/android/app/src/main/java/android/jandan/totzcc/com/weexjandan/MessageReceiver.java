package android.jandan.totzcc.com.weexjandan;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;

import com.alibaba.fastjson.JSON;
import com.alibaba.sdk.android.push.notification.CPushMessage;
import com.taobao.weex.WXEnvironment;

import org.jsoup.helper.StringUtil;

import java.util.Map;

/**
 * Created by Administrator on 2017/6/12.
 */

public class MessageReceiver extends com.alibaba.sdk.android.push.MessageReceiver {
//    public static List<MessageReceiverData> receiverDatas = new ArrayList<>();
    public static MessageReceiverData recentNotification;
    // 消息接收部分的LOG_TAG
    public static final String REC_TAG = "receiver";
    @Override
    public void onNotification(Context context, String title, String summary, Map<String, String> extraMap) {
        // TODO 处理推送通知
        LogUtil.i("Receive notification, title: " + title + ", summary: " + summary + ", extraMap: " + extraMap);
        if (extraMap.get("target") == null) {
            LogUtil.w("extraMap 没有 target，不记录推送");
            return;
        }
        recentNotification = new MessageReceiverData(title, summary, extraMap);
    }
    @Override
    public void onMessage(Context context, CPushMessage cPushMessage) {
        LogUtil.i("onMessage, messageId: " + cPushMessage.getMessageId() + ", title: " + cPushMessage.getTitle() + ", content:" + cPushMessage.getContent());
    }
    @Override
    public void onNotificationOpened(Context context, String title, String summary, String extraMap) {
        LogUtil.i("onNotificationOpened, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap);
        Map map = JSON.parseObject(extraMap, Map.class);
        if (map.get("target") == null) {
            LogUtil.w("extraMap 没有 target，不打开页面");
            return;
        }
        String weexMainUrl;
        if (WXEnvironment.isApkDebugable()) {
            weexMainUrl = context.getString(R.string.weex_main_url_debug);
        } else {
            weexMainUrl = context.getString(R.string.weex_main_url_release);
        }
        String middlePage = context.getString(R.string.weex_message_middle_page);
        middlePage = weexMainUrl.replace("index.js", middlePage);

        recentNotification = new MessageReceiverData(title, summary, map);
        Intent intent = new Intent(context, WeexPageActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.setData(Uri.parse(middlePage));
        context.startActivity(intent);
    }
    @Override
    protected void onNotificationClickedWithNoAction(Context context, String title, String summary, String extraMap) {
        LogUtil.i("onNotificationClickedWithNoAction, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap);
    }
    @Override
    protected void onNotificationReceivedInApp(Context context, String title, String summary, Map<String, String> extraMap, int openType, String openActivity, String openUrl) {
        LogUtil.i("onNotificationReceivedInApp, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap + ", openType:" + openType + ", openActivity:" + openActivity + ", openUrl:" + openUrl);
    }
    @Override
    protected void onNotificationRemoved(Context context, String messageId) {
        LogUtil.i("onNotificationRemoved");
    }
    public static class MessageReceiverData {
        public String title;
        public String summary;
        public Map<String, String> extraMap;
        public MessageReceiverData(String title, String summary, Map<String, String> extraMap) {
            this.title = title;
            this.summary = summary;
            this.extraMap = extraMap;
        }
    }
}
