package ppasist.utils;

public class HttpLua {
    public static void setTimeouts(long connectTimeout, long readTimeout, long writeTimeout){
        HttpHelper.setTimeouts(connectTimeout, readTimeout, writeTimeout);
    }
    public static void setBaseUrl(String baseUrl){
        HttpHelper.setBaseUrl(baseUrl);
    }

    public static void setHeader(String key, String value) { HttpHelper.getInstance().setHeader(key, value); }
    public static void clearHeader() {
        HttpHelper.getInstance().clearHeader();
    }
    public static void addHeader(String key, String value) { HttpHelper.getInstance().addHeader(key, value); }

    public static void httpGet(String url, int luaSuccCallback, int luaFailCallback, int luaLoadingCallback) {
        HttpHelper.getInstance().httpGet(url, luaSuccCallback, luaFailCallback, luaLoadingCallback);
    }

    public static void httpPost(String url, String cont, int luaSuccCallback, int luaFailCallback, int luaLoadingCallback) {
        HttpHelper.getInstance().httpPost(url, cont, luaSuccCallback, luaFailCallback, luaLoadingCallback);
    }

    public static void uploadHeadImg(String url, String filepath, int luaSuccCallback, int luaFailCallback, int luaLoadingCallback){
        HttpHelper.getInstance().uploadHeadImg(url, filepath, luaSuccCallback, luaFailCallback, luaLoadingCallback);
    }

    public static void bindWxZfb(String url, String filepath, String strParam, int luaSuccCallback, int luaFailCallback, int luaLoadingCallback){
        HttpHelper.getInstance().bindWxZfb(url, filepath, strParam, luaSuccCallback, luaFailCallback, luaLoadingCallback);
    }
}
