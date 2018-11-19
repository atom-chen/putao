package ppasist.utils;

import org.cocos2dx.lua.AppActivity;
import org.json.JSONException;
import org.json.JSONObject;

import android.Manifest;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings.Secure;
import android.support.v4.app.ActivityCompat;
import android.telephony.TelephonyManager;


/**
 *  系统信息相关
 */
public class OSInfoUtils {
	private static OSInfoUtils mInstance = null;

	public static OSInfoUtils getInstance() {
		if (mInstance == null)
			mInstance = new OSInfoUtils();
		return mInstance;
	}

	public OSInfoUtils() {

	}

	public static String getPhoneModel() {
		String model = Build.MODEL; //手机型号
		return model;
	}

	public String getSerialNumber() {
		String androidId = Secure.getString(SalmonUtils.getInstance().getActivity().getContentResolver(), Secure.ANDROID_ID);
		return androidId;
	}

	public String getPhoneSDKVersion() {
		String sdkVersion = Build.VERSION.SDK;
		return sdkVersion;
	}

	public static String getPhoneOSVersion() {
		String osVersion = Build.VERSION.RELEASE;//SDK版本号
		return osVersion;
	}

	//本机电话号码
	public String getPhoneNumber() {
		TelephonyManager phoneMgr = (TelephonyManager) SalmonUtils.getInstance().getActivity().getSystemService(Context.TELEPHONY_SERVICE);
		if (ActivityCompat.checkSelfPermission(AppActivity.mInstance,
				Manifest.permission.READ_SMS) != PackageManager.PERMISSION_GRANTED
				&& ActivityCompat.checkSelfPermission(AppActivity.mInstance, Manifest.permission.READ_PHONE_NUMBERS) != PackageManager.PERMISSION_GRANTED
				&& ActivityCompat.checkSelfPermission(AppActivity.mInstance, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED)
		{
			return "";
		}
		String phoneNum = phoneMgr.getLine1Number();
		return phoneNum;
	}

	//获取手机IMSI号
	public static String getPhoneIMEI() {
		TelephonyManager phoneMgr = (TelephonyManager) SalmonUtils.getInstance().getActivity().getSystemService(Context.TELEPHONY_SERVICE);
		if (ActivityCompat.checkSelfPermission(AppActivity.mInstance, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
			return "";
		}
		String imei = phoneMgr.getDeviceId();
		return imei;
	}

	//获取手机IMSI号
	public static String getPhoneIMSI() {
		TelephonyManager phoneMgr = (TelephonyManager) SalmonUtils.getInstance().getActivity().getSystemService(Context.TELEPHONY_SERVICE);
		if (ActivityCompat.checkSelfPermission(AppActivity.mInstance, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
			return "";
		}
		String imsi = phoneMgr.getSubscriberId();
		return imsi;
	}

	//获取手机品牌
	public static String getPhoneBrand() {
		String brand = android.os.Build.BRAND;
		return brand;
	}

	public boolean isEmulator(Context context) {
		try {
			TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
			if (ActivityCompat.checkSelfPermission(AppActivity.mInstance, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
				return false;
			}
			String imei = tm.getDeviceId();
			if (imei != null && imei.equals("000000000000000")){
				return true;
			}
			return  (Build.MODEL.equals("sdk")) || (Build.MODEL.equals("google_sdk"));
		}catch (Exception ioe) {

		}
		return false;
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
