/****************************************************************************
 Copyright (c) 2008-2010 Ricardo Quesada
 Copyright (c) 2010-2016 cocos2d-x.org
 Copyright (c) 2013-2017 Chukong Technologies Inc.

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/
package org.cocos2dx.lua;

import android.Manifest;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.Vibrator;
import android.support.v4.app.ActivityCompat;
import android.telephony.TelephonyManager;
import android.text.TextUtils;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import ppasist.utils.SalmonUtils;

public class AppActivity extends Cocos2dxActivity {
    public static AppActivity mInstance = null;
    public static TelephonyManager mTm = null;
    public static Vibrator mVibrator =  null;


    //支付分享统一回调
    public static Handler mHandler = new Handler() {
        public void handleMessage(final Message msg) {
            SalmonUtils.handleMessage(msg);
        }
    };

    //----------------------------------------------------------------------------------------------
    // overrides
    //----------------------------------------------------------------------------------------------
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.setEnableVirtualButton(false);
        super.onCreate(savedInstanceState);
        mInstance = this;
        // Workaround in https://stackoverflow.com/questions/16283079/re-launch-of-activity-on-home-button-but-only-the-first-time/16447508
        if (!isTaskRoot()) {
            // Android launched another instance of the root activity into an existing task
            //  so just quietly finish and go away, dropping the user back into the activity
            //  at the top of the stack (ie: the last state of this task)
            // Don't need to finish it again since it's finished in super.onCreate .
            return;
        }

        // DO OTHER INITIALIZATION BELOW
        SalmonUtils.init(this, mHandler);
    }

    //----------------------------------------------------------------------------------------------
    // methods
    //----------------------------------------------------------------------------------------------
    //游戏启动完成回调
    public static void onGameLauch() {
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(ConnectivityManager.CONNECTIVITY_ACTION);
        try {
            mInstance.registerReceiver(connectionReceiver, intentFilter);
        } catch (Exception e) {
            e.printStackTrace();
        }

        intentFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        try {
            mInstance.registerReceiver(batteryReceiver, intentFilter);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 网络连接监听
    public static BroadcastReceiver connectionReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {
            ConnectivityManager connectMgr = (ConnectivityManager) mInstance.getSystemService(CONNECTIVITY_SERVICE);
            NetworkInfo mobNetInfo = connectMgr.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
            NetworkInfo wifiNetInfo = connectMgr.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
            mInstance.runOnGLThread(new Runnable() {
                @Override
                public void run() {
                    int ret = Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("networkStateChange", "");
                }
            });
        }
    };

    // 电量变化监听
    public static BroadcastReceiver batteryReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(Intent.ACTION_BATTERY_CHANGED)) {
                //得到系统当前电量
                int level = intent.getIntExtra("level", 0);
                //取得系统总电量
                int total = intent.getIntExtra("scale", 100);
                final String battery = (level * 100) / total + "";
                mInstance.runOnGLThread(new Runnable() {
                    @Override
                    public void run() {
                        int ret = Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("batteryChange", battery);
                    }
                });
            }

        }
    };

    //检测网络状态
    public static boolean isNetworkConnected() {
        ConnectivityManager mConnectivityManager = (ConnectivityManager) mInstance.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo mNetworkInfo = mConnectivityManager.getActiveNetworkInfo();
        if (mNetworkInfo != null) {
            return mNetworkInfo.isAvailable();
        }
        return false;
    }

    //获取剩余电量
    public static int getBattery() {
//		if(Build.VERSION.SDK_INT > 21){
//			BatteryManager batteryManager = (BatteryManager)mInstance.getSystemService(Context.BATTERY_SERVICE);
//			int battery = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_AVERAGE);
//			return battery;
//		}else{
//			return 100;
//		}
        return 100;
    }

    public static String getImei() {
        if (ActivityCompat.checkSelfPermission(mInstance, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            return "";
        }
        String imei = mTm.getDeviceId();
        return imei == null ? "" : imei;
    }

    public static String getImsi() {
        if (ActivityCompat.checkSelfPermission(mInstance, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            return "";
        }
        String imsi = mTm.getSubscriberId();
        return imsi == null ? "" : imsi;
    }

    public static String getModel() {
        String model = android.os.Build.MODEL;
        return model == null ? "" : model;
    }

    public static String getAppMetaData(String key) {
        if (mInstance == null || TextUtils.isEmpty(key)) {
            return "";
        }
        String resultData = "";
        try {
            PackageManager packageManager = mInstance.getPackageManager();
            if (packageManager != null) {
                ApplicationInfo applicationInfo = packageManager.getApplicationInfo(mInstance.getPackageName(), PackageManager.GET_META_DATA);
                if (applicationInfo != null) {
                    if (applicationInfo.metaData != null) {
                        resultData = applicationInfo.metaData.getString(key);
                    }
                }

            }
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        return resultData;
    }

    public static String getVersion() {
        try {
            PackageManager manager = mInstance.getPackageManager();
            PackageInfo info = manager.getPackageInfo(mInstance.getPackageName(), 0);
            String version = info.versionName;
            return version == null ? "" :version;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    public static String getChannel(){
        SharedPreferences sp = mInstance.getSharedPreferences("open_install",MODE_PRIVATE);
        String channel = sp.getString("channel_code","");
        if(channel != null && channel != ""){
            return channel;
        }
        channel = getAppMetaData("CUSTOM_CHANNEL");
        return channel == null ? "" : channel;
    }

}
