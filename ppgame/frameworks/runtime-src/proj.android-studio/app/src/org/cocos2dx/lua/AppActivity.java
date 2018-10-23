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

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

public class AppActivity extends Cocos2dxActivity{
    public static AppActivity mInstance = null;


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
        
    }

    //----------------------------------------------------------------------------------------------
    // methods
    //----------------------------------------------------------------------------------------------
    //游戏启动完成回调
    public static void onGameLauch(){
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(ConnectivityManager.CONNECTIVITY_ACTION);
        try{
            mInstance.registerReceiver(connectionReceiver, intentFilter);
        }catch (Exception e){
            e.printStackTrace();
        }

        intentFilter=new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        try{
            mInstance.registerReceiver(batteryReceiver, intentFilter);
        }catch (Exception e){
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
            if(intent.getAction().equals(Intent.ACTION_BATTERY_CHANGED)){
                //得到系统当前电量
                int level=intent.getIntExtra("level", 0);
                //取得系统总电量
                int total=intent.getIntExtra("scale", 100);
                final String battery = (level*100)/total + "";
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
//		if(Build.VERSION.SDK_INT >21){
//			BatteryManager batteryManager=(BatteryManager)mInstance.getSystemService(Context.BATTERY_SERVICE);
//			int battery = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_AVERAGE);
//			return battery;
//		}else{
//			return 100;
//		}
        return 100;
    }


}
