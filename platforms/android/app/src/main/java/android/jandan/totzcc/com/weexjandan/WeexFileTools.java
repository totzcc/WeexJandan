package android.jandan.totzcc.com.weexjandan;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;


import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.text.MessageFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.zip.GZIPInputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import static com.alibaba.fastjson.util.IOUtils.close;

/**
 * Created by zhoucheng on 2017/6/14.
 */

public class WeexFileTools {
    private static final String ZIP_FILE_CONTENT_LENGTH = "ZIP_FILE_CONTENT_LENGTH";
    public static void initWeexServive(Context context) {
        if (!unzipAssetsZip(context)) {
            checkDownloadZipFromInternet(context);
        }
    }

    private static void checkDownloadZipFromInternet(final Context context) {
        LogUtil.d("检查远程资源包大小");
        OkHttpClient client = new OkHttpClient.Builder().build();
        Request request = new Request.Builder().head().url(context.getString(R.string.weex_zip_file)).build();
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                LogUtil.e("检查远程资源包大小失败", e);
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                long remoteContentLength = response.body().contentLength();
                long localContentLength = App.getSharedPreferences().getLong(ZIP_FILE_CONTENT_LENGTH, 0);
                LogUtil.d(MessageFormat.format("本地文件大小：{0}，远程文件大小：{1}", remoteContentLength, localContentLength));
                if (localContentLength != remoteContentLength) {
                    LogUtil.d("需要更新本地zip文件");
                    downloadZipFromInternetAndUnZip(context);
                }
            }
        });
    }

    private static void downloadZipFromInternetAndUnZip(final Context context) {
        LogUtil.d("开始下载资源包");
        OkHttpClient client = new OkHttpClient.Builder().build();
        Request request = new Request.Builder().get().url(context.getString(R.string.weex_zip_file)).build();
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                LogUtil.e("下载文件失败", e);
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {

                String tmpFile = context.getCacheDir().getAbsolutePath() + "/" + new Date().getTime() + ".zip";
                FileOutputStream fos = new FileOutputStream(tmpFile);
                fos.write(response.body().bytes());
                fos.flush();
                fos.close();
                LogUtil.d("下载文件成功:" + tmpFile);
                if (unpackZip(new FileInputStream(tmpFile), new File(context.getFilesDir() + "/weexFile"))) {
                    SharedPreferences.Editor edit = App.getSharedPreferences().edit();
                    edit.putLong(ZIP_FILE_CONTENT_LENGTH, response.body().contentLength());
                    edit.apply();
                }

            }
        });
    }

    public static boolean unzipAssetsZip(Context context) {
        File weexFileDir = new File(context.getFilesDir() + "/weexFile");
        if (!weexFileDir.exists()) {
            try {
                InputStream in = context.getAssets().open("jandan.zip");
                boolean success = unpackZip(in, weexFileDir);
                LogUtil.d("解压Assets文件结果：" + success);
                return true;
            } catch (Exception e) {
                LogUtil.e("解压Assets失败：", e);
            }
        }
        LogUtil.d("已解压Assets zip文件，不重复解压");
        return false;
    }

    private static boolean unpackZip(InputStream in, File outputDir)
    {
        if (outputDir.exists()) {
            deleteFileAndDir(outputDir);
        }
        outputDir.mkdirs();
        ZipInputStream zis;
        try
        {
            String filename;
            zis = new ZipInputStream(new BufferedInputStream(in));
            ZipEntry ze;
            byte[] buffer = new byte[1024];
            int count;

            while ((ze = zis.getNextEntry()) != null)
            {
                // zapis do souboru
                filename = ze.getName();
                if (ze.isDirectory()) {
                    File fmd = new File(outputDir + "/" + filename);
                    fmd.mkdirs();
                    continue;
                }
                FileOutputStream fout = new FileOutputStream(outputDir + "/" +filename);
                // cteni zipu a zapis
                while ((count = zis.read(buffer)) != -1)
                {
                    fout.write(buffer, 0, count);
                }

                fout.close();
                zis.closeEntry();
            }

            zis.close();
        }
        catch(IOException e)
        {
            LogUtil.e("解压文件失败", e);
            return false;
        }
        LogUtil.d("解压文件成功:" + outputDir.getAbsolutePath());
        return true;
    }
    private static void deleteFileAndDir(File file) {
        if (file.isDirectory()) {
            File[] subFiles = file.listFiles();
            for (File subFile : subFiles) {
                deleteFileAndDir(subFile);
            }
        }
        file.delete();
    }
}