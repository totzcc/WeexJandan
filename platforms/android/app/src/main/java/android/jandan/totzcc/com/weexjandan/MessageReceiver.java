package android.jandan.totzcc.com.weexjandan;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.alibaba.sdk.android.push.notification.CPushMessage;
import com.taobao.weex.WXEnvironment;

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
        Log.i("MyMessageReceiver", "Receive notification, title: " + title + ", summary: " + summary + ", extraMap: " + extraMap);
        recentNotification = new MessageReceiverData(title, summary, extraMap);
    }
    @Override
    public void onMessage(Context context, CPushMessage cPushMessage) {
        Log.i("MyMessageReceiver", "onMessage, messageId: " + cPushMessage.getMessageId() + ", title: " + cPushMessage.getTitle() + ", content:" + cPushMessage.getContent());
    }
    @Override
    public void onNotificationOpened(Context context, String title, String summary, String extraMap) {
        Log.i("MyMessageReceiver", "onNotificationOpened, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap);
        String weexMainUrl;
        if (WXEnvironment.isApkDebugable()) {
            weexMainUrl = context.getString(R.string.weex_main_url_debug);
        } else {
            weexMainUrl = context.getString(R.string.weex_main_url_release);
        }
        String middlePage = context.getString(R.string.weex_message_middle_page);
        middlePage = weexMainUrl.replace("index.js", middlePage);
        Map map = JSON.parseObject(extraMap, Map.class);
        recentNotification = new MessageReceiverData(title, summary, map);
        Intent intent = new Intent(context, WeexPageActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.setData(Uri.parse(middlePage));
        context.startActivity(intent);
    }
    @Override
    protected void onNotificationClickedWithNoAction(Context context, String title, String summary, String extraMap) {
        Log.i("MyMessageReceiver", "onNotificationClickedWithNoAction, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap);
    }
    @Override
    protected void onNotificationReceivedInApp(Context context, String title, String summary, Map<String, String> extraMap, int openType, String openActivity, String openUrl) {
        Log.i("MyMessageReceiver", "onNotificationReceivedInApp, title: " + title + ", summary: " + summary + ", extraMap:" + extraMap + ", openType:" + openType + ", openActivity:" + openActivity + ", openUrl:" + openUrl);
    }
    @Override
    protected void onNotificationRemoved(Context context, String messageId) {
        Log.i("MyMessageReceiver", "onNotificationRemoved");
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
