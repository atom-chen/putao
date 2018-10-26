package ppasist.utils;

import android.util.Log;

import org.cocos2dx.lua.AppActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSession;

import okhttp3.Call;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import ppasist.config.Constans;
import ppasist.okhttp.OkHttpUtils;
import ppasist.okhttp.callback.StringCallback;
import ppasist.okhttp.https.HttpsUtils;

/**
 * Created by Administrator on 2018/7/27.
 */

public final class HttpHelper {
    private static final String TAG = "HttpHelper";
    private static String mBaseUrl = "https://agentapiuser.guocaiapi.com/";
    private static long mConnectTimeout = 5000L;
    private static long mReadTimeout = 5000L;
    private static long mWriteTimeout = 5000L;

    private static HttpHelper mInstance;
    private static Map<String, String> mHeaders = new HashMap<>();

    public static void setTimeouts(long connectTimeout, long readTimeout, long writeTimeout){
        mConnectTimeout = connectTimeout;
        mReadTimeout = readTimeout;
        mWriteTimeout = writeTimeout;
    }
    public static void setBaseUrl(String baseUrl){
        mBaseUrl = baseUrl;
    }

    private HttpHelper(){
    //    ClearableCookieJar cookieJar1 = new PersistentCookieJar(new SetCookieCache(), new SharedPrefsCookiePersistor(getApplicationContext()));
        HttpsUtils.SSLParams sslParams = HttpsUtils.getSslSocketFactory(null, null, null);
        OkHttpClient okHttpClient = new OkHttpClient.Builder()
                .connectTimeout(mConnectTimeout, TimeUnit.MILLISECONDS)
                .readTimeout(mReadTimeout, TimeUnit.MILLISECONDS)
                .hostnameVerifier(new HostnameVerifier()
                {
                    @Override
                    public boolean verify(String hostname, SSLSession session) {
                        // TODO Auto-generated method stub
                        return true;
                    }
                })
        //        .sslSocketFactory(sslParams.sSLSocketFactory, sslParams.trustManager)
                .build();
        OkHttpUtils.initClient(okHttpClient);
    }
    public static HttpHelper getInstance(){
        if(mInstance == null){ mInstance = new HttpHelper(); }
        return mInstance;
    }

    public static void setHeader(String key, String value){
        mHeaders.clear();
        Log.d(TAG, "header:  " + key + "  " + value);
        mHeaders.put(key, value);
    }

    public static void addHeader(String key, String value){
        mHeaders.put(key, value);
    }

    public static void clearHeader(){
        mHeaders.clear();
    }

    //-------------------------------------------------------------------------------------------

    public class MyStringCallback extends StringCallback
    {
        private int _luaSuccCallback = 0;
        private int _luaFailCallback = 0;
        private int _luaLoadingCallback = 0;

        public MyStringCallback(int luaSuccCallback, int luaFailCallback, int luaLoadingCallback){
            super();
            _luaSuccCallback = luaSuccCallback;
            _luaFailCallback = luaFailCallback;
            _luaLoadingCallback = luaLoadingCallback;
        }
        @Override
        public void onBefore(Request request, int id)
        {
            Log.d(TAG,"onBefore");
        }

        @Override
        public void onAfter(int id)
        {
            Log.d(TAG,"onAfter");
        }

        @Override
        public void onError(Call call, Exception e, int id)
        {
            e.printStackTrace();
            final String errMsg = e.getMessage();
            Log.d(TAG,"onError:" + e.getMessage());
            AppActivity.mInstance.runOnGLThread(new Runnable() {
                @Override
                public void run() {
                    if(_luaSuccCallback != 0) {
                        Cocos2dxLuaJavaBridge.releaseLuaFunction(_luaSuccCallback);
                        _luaSuccCallback = 0;
                    }
                    if(_luaLoadingCallback != 0) {
                        Cocos2dxLuaJavaBridge.releaseLuaFunction(_luaLoadingCallback);
                        _luaLoadingCallback = 0;
                    }
                    if(_luaFailCallback != 0) {
                        Cocos2dxLuaJavaBridge.callLuaFunctionWithString(_luaFailCallback, errMsg);
                        Cocos2dxLuaJavaBridge.releaseLuaFunction(_luaFailCallback);
                        _luaFailCallback = 0;
                    }
                }
            });
        }

        @Override
        public void onResponse(String response, int id)
        {
            final String resp_data = response;
            Log.e(TAG, "onResponse：" + resp_data);
            AppActivity.mInstance.runOnGLThread(new Runnable() {
                @Override
                public void run() {
                    if(_luaFailCallback != 0) {
                        Cocos2dxLuaJavaBridge.releaseLuaFunction(_luaFailCallback);
                        _luaFailCallback = 0;
                    }
                    if(_luaLoadingCallback != 0) {
                        Cocos2dxLuaJavaBridge.releaseLuaFunction(_luaLoadingCallback);
                        _luaLoadingCallback = 0;
                    }
                    if(_luaSuccCallback != 0) {
                        Cocos2dxLuaJavaBridge.callLuaFunctionWithString(_luaSuccCallback, resp_data);
                        Cocos2dxLuaJavaBridge.releaseLuaFunction(_luaSuccCallback);
                        _luaSuccCallback = 0;
                    }
                }
            });
        }

        @Override
        public void inProgress(float progress, long total, int id)
        {
            Log.e(TAG, "inProgress:" + progress);
            final String progStr = progress + "," + total + "," + id;
            AppActivity.mInstance.runOnGLThread(new Runnable() {
                @Override
                public void run() {
                    if (_luaLoadingCallback !=0 ){
                        Cocos2dxLuaJavaBridge.callLuaFunctionWithString(_luaSuccCallback, progStr);
                    }
                }
            });
        }
    }

    //-------------------------------------------------------------------------------------------

    public void httpGet(String url, int luaSuccCallback, int luaFailCallback, int luaLoadingCallback)
    {
        if(luaSuccCallback != 0) { Cocos2dxLuaJavaBridge.retainLuaFunction(luaSuccCallback); }
        if(luaFailCallback != 0) { Cocos2dxLuaJavaBridge.retainLuaFunction(luaFailCallback); }
        if(luaLoadingCallback != 0) { Cocos2dxLuaJavaBridge.retainLuaFunction(luaLoadingCallback); }

        OkHttpUtils.get()
                .url(url)
                .id(100)
                .headers(mHeaders)
                .build()
                .execute(new MyStringCallback(luaSuccCallback, luaFailCallback, luaLoadingCallback));
    }

    public void httpPost(String url, String cont, int luaSuccCallback, int luaFailCallback, int luaLoadingCallback)
    {
        if(luaSuccCallback != 0) { Cocos2dxLuaJavaBridge.retainLuaFunction(luaSuccCallback); }
        if(luaFailCallback != 0) { Cocos2dxLuaJavaBridge.retainLuaFunction(luaFailCallback); }
        if(luaLoadingCallback != 0) { Cocos2dxLuaJavaBridge.retainLuaFunction(luaLoadingCallback); }

        Map<String, String> params = new HashMap<>();

        if(cont.equals("")){

        } else {
            String[] strKV = cont.split("&");
            for(int i=0; i<strKV.length; i++){
                String[] kv = strKV[i].split("=");
                if(kv.length == 1){
                    params.put(kv[0].substring(0,kv[0].length()), "");
                } else {
                    params.put(kv[0], kv[1]);
                }
            }
        }

        OkHttpUtils.post()
                .url(url)
                .params(params)
                .headers(mHeaders)
                .build()
                .execute(new MyStringCallback(luaSuccCallback,luaFailCallback,luaLoadingCallback));
    }

    public void uploadHeadImg(String url, String filepath, int luaSuccCallback, int luaFailCallback, int luaLoadingCallback)
    {
        File file = new File(filepath);
        if (!file.exists())
        {
            Log.e(TAG, "文件不存在："+filepath);
            return;
        }

        if(luaSuccCallback != 0) { Cocos2dxLuaJavaBridge.retainLuaFunction(luaSuccCallback); }
        if(luaFailCallback != 0) { Cocos2dxLuaJavaBridge.retainLuaFunction(luaFailCallback); }
        if(luaLoadingCallback != 0) { Cocos2dxLuaJavaBridge.retainLuaFunction(luaLoadingCallback); }

        OkHttpUtils.post()
                .addFile("file", filepath, file)
                .url(url)
                .headers(mHeaders)
                .build()
                .execute(new MyStringCallback(luaSuccCallback, luaFailCallback, luaLoadingCallback));
    }


    public void bindWxZfb(String url, String filepath, String strParam, int luaSuccCallback, int luaFailCallback, int luaLoadingCallback){
        File file = new File(filepath);
        if (!file.exists())
        {
            Log.e(TAG, "文件不存在："+filepath);
            return;
        }

        if(luaSuccCallback != 0) { Cocos2dxLuaJavaBridge.retainLuaFunction(luaSuccCallback); }
        if(luaFailCallback != 0) { Cocos2dxLuaJavaBridge.retainLuaFunction(luaFailCallback); }
        if(luaLoadingCallback != 0) { Cocos2dxLuaJavaBridge.retainLuaFunction(luaLoadingCallback); }

        Map<String, String> params = new HashMap<>();

        if(strParam.equals("")){

        } else {
            String[] strKV = strParam.split("&");
            for(int i=0; i<strKV.length; i++){
                String[] kv = strKV[i].split("=");
                if(kv.length == 1){
                    params.put(kv[0].substring(0,kv[0].length()), "");
                } else {
                    params.put(kv[0], kv[1]);
                }
            }
        }

        OkHttpUtils.post()
                .addFile("file", filepath, file)
                .url(url)
                .params(params)
                .headers(mHeaders)
                .build()
                .execute(new MyStringCallback(luaSuccCallback, luaFailCallback, luaLoadingCallback));
    }
}
