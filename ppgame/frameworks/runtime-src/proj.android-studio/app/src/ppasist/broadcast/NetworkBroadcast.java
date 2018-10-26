package ppasist.broadcast;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.NetworkInfo.State;
import android.telephony.TelephonyManager;
import android.util.Log;

import ppasist.utils.SalmonUtils;

//网络

@SuppressLint("ServiceCast")
public class NetworkBroadcast extends BroadcastReceiver {

	
	enum NetworkStatus{
		UNVALID(0),
		WIFI(1),
		MOBILE(2);
		
		private int value = 0;
		
		private NetworkStatus(int value)
		{
			this.value = value;
		}
		
		public int value()
		{
			return value;
		}
	};
	
	@Override
	public void onReceive(Context context, Intent intent) {
		
        State wifiState = null;  
        State mobileState = null;  
        ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);  
        wifiState = cm.getNetworkInfo(ConnectivityManager.TYPE_WIFI).getState();  
        
        NetworkInfo mobileInfo = cm.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
        mobileState = mobileInfo.getState();
        
        TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        mobileInfo.getSubtype();
        
        if (wifiState != null && mobileState != null  
                && State.CONNECTED != wifiState  
                && State.CONNECTED == mobileState) {  
            
        	Log.d("NetwrokBroadcast", "mobile network connect success");
        	SalmonUtils.notifyNetworkStatus(NetworkStatus.MOBILE.value(), tm.getNetworkType());
        } else if (wifiState != null && mobileState != null  
                && State.CONNECTED != wifiState  
                && State.CONNECTED != mobileState) {  
            
        	Log.d("NetwrokBroadcast", "not network connectted");
        	SalmonUtils.notifyNetworkStatus(NetworkStatus.UNVALID.value(), 0);
        } else if (wifiState != null && State.CONNECTED == wifiState) {  
            
        	Log.d("NetwrokBroadcast", "wifi network connect success");
        	SalmonUtils.notifyNetworkStatus(NetworkStatus.WIFI.value(), 0);
        }  
	}

}
