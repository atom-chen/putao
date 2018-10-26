package ppasist.utils;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;
import android.util.Log;


/**
 *  系统信息相关
 */
public class OSInfoUtils {
	private static OSInfoUtils mInstance = null;
	public static OSInfoUtils getInstance()
	{
		if(mInstance == null)
			mInstance = new OSInfoUtils();
		return mInstance;
	}
	
	public OSInfoUtils()
	{

	}
	
	public void test()
	{
		Log.i("11111111111111111111", getPhoneModel());
		Log.i("22222222222222222222", getSerialNumber());
		Log.i("33333333333333333333", getPhoneSDKVersion());
		Log.i("44444444444444444444", getPhoneOSVersion());
		Log.i("55555555555555555555", getPhoneNumber());
		Log.i("66666666666666666666", getPhoneIMEI());
		Log.i("77777777777777777777", getPhoneIMSI());
//		getPhoneModel();
//		getSerialNumber();
//		getPhoneSDKVersion();
//		getPhoneOSVersion();
//		getPhoneNumber();
//		getPhoneIMEI();
//		getPhoneIMSI();
	}
	
	public static String getPhoneModel()
	{
		String model = Build.MODEL; //手机型号
		return model;
	}
	
	public String getSerialNumber()
	{
		String androidId = Secure.getString( SalmonUtils.getInstance().getActivity().getContentResolver(), Secure.ANDROID_ID);
		return androidId;
	}
	
	public String getPhoneSDKVersion()
	{
		String sdkVersion = Build.VERSION.SDK;
		return sdkVersion;
	}
	
	public static String getPhoneOSVersion()
	{
		String osVersion = Build.VERSION.RELEASE;//SDK版本号
		return osVersion;
	}
	
	public String getPhoneNumber()
	{
		TelephonyManager phoneMgr=(TelephonyManager)SalmonUtils.getInstance().getActivity().getSystemService(Context.TELEPHONY_SERVICE);      
		String phoneNum = phoneMgr.getLine1Number();//本机电话号码
		return phoneNum;
	}
	
	public static String getPhoneIMEI()
	{
		TelephonyManager phoneMgr=(TelephonyManager)SalmonUtils.getInstance().getActivity().getSystemService(Context.TELEPHONY_SERVICE);      
		String imei = phoneMgr.getDeviceId();//获取手机IMSI号
		return imei;
	}
	
	public static String getPhoneIMSI()
	{
		TelephonyManager phoneMgr=(TelephonyManager)SalmonUtils.getInstance().getActivity().getSystemService(Context.TELEPHONY_SERVICE);      
		String imsi = phoneMgr.getSubscriberId();//获取手机IMSI号
		return imsi;
	}
	
	public static String getPhoneBrand()
	{
		String brand = android.os.Build.BRAND;//获取手机品牌
		return brand;
	}

	public boolean isEmulator(Context context){
        try{
            TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
            String imei = tm.getDeviceId();
            if (imei != null && imei.equals("000000000000000")){
                return true;
            }
            return  (Build.MODEL.equals("sdk")) || (Build.MODEL.equals("google_sdk"));
        }catch (Exception ioe) { 
 
        }
        return false;
        
        
        // 下面怠慢是另一种实现，据说上面的办法由于当前很多模拟器都可以任意修改mac地址，所以不可以尝试下面的方式
//        String result="";
//        try{
//        String[] args = {"/system/bin/cat", "/proc/cpuinfo"};
//        ProcessBuilder cmd = new ProcessBuilder(args);
//         
//        Process process = cmd.start();
//        StringBuffer sb = new StringBuffer();
//        String readLine="";
//        BufferedReader responseReader = new BufferedReader(new InputStreamReader(process.getInputStream(),"utf-8"));
//        while ((readLine = responseReader.readLine()) != null) {
//           sb.append(readLine);
//        }
//        responseReader.close();
//        result=sb.toString().toLowerCase();
//        } catch(IOException ex){
//        }
//        return (!result.contains("arm")) || (result.contains("intel")) || (result.contains("amd"));

    }
	
	
	public static String intToIpAddress(long ipInt) {
        StringBuffer sb = new StringBuffer();
        sb.append(ipInt & 0xFF).append(".");
        sb.append((ipInt >> 8) & 0xFF).append(".");
        sb.append((ipInt >> 16) & 0xFF).append(".");
        sb.append((ipInt >> 24) & 0xFF);
        return sb.toString();
    }
	
	public static String getDeviceInfo()
	{
		String model = OSInfoUtils.getPhoneModel();
		String sysVersion = OSInfoUtils.getPhoneOSVersion();
		String versionName = SalmonUtils.getVersionName();
		String ipAddress = null;
		String macAddr = null;
		//String isp = null;
		String brand = OSInfoUtils.getPhoneBrand();
//		if (IMSI.startsWith("46000") || IMSI.startsWith("46002")) {
//			isp = "China Mobile";
//		} else if (IMSI.startsWith("46001")) {
//			isp = "China Unicom";
//		} else if (IMSI.startsWith("46003")) {
//			isp = "China Telecom";
//		}
		JSONObject jobj = new JSONObject();
		
		WifiManager wifiManager = (WifiManager) SalmonUtils.getInstance().getActivity().getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        WifiInfo info = null;
        if (null != wifiManager) {
            info = wifiManager.getConnectionInfo();
            if (info != null)
            {
            	ipAddress = intToIpAddress(info.getIpAddress());
            	macAddr = info.getMacAddress();
            }
        }
		try {
			if (model != null && sysVersion != null)
			{
				jobj.put("deviceModel", model);
				jobj.put("deviceVersion", sysVersion);
			}
			if(macAddr != null && ipAddress != null)
			{
				jobj.put("macAddr", macAddr);
				jobj.put("ipAddr", ipAddress);
			}	
			if(versionName != null)
			{
				jobj.put("versionName", versionName);
			}
			if(brand != null)
			{
				jobj.put("isp", brand);
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return jobj.toString();
	}
	
	public static String getChannelId()
	{
		ApplicationInfo ai = null;       
		try {
			Context con = SalmonUtils.getInstance().getActivity();
			ai = con.getPackageManager().getApplicationInfo(con.getPackageName(), PackageManager.GET_META_DATA);       
			} catch (PackageManager.NameNotFoundException e) 
			{           
				e.printStackTrace();       
			}        
		Bundle bundle = ai.metaData;    
		return bundle.getString("ChannelID");
	}
}
