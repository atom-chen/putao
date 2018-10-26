package ppasist.utils;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.AssetManager;
import android.content.res.Configuration;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Camera;
import android.graphics.Rect;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.NetworkInfo.State;
import android.net.TrafficStats;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.provider.Settings;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Toast;

//import com.imay.capturefilter.activity.CameraActivity;
import ppasist.config.Constans;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxEditBox;
import org.cocos2dx.lib.Cocos2dxHelper;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.Date;

public class SalmonUtils {

	private static Activity mActivity;
	protected static Handler mHandler;
	private static AssetManager assetMgr = null;

	private static SalmonUtils mInstance;
	public static int REQUEST_THIRD_IMAGEPHOTO = 10001;
	public static int REQUEST_PICK_VIDEO = 10002;

	private ScreenUtils screenUtils = null;
	
	private int networkChangeHandler = 0; // lua网络状态改变回调函数

	public static Activity  getAcitivity(){return mActivity;}

	private int connectType = -1; // 连接类型：无连接 wifi 移动网络
	private int networkType = -1; // 仅移动网络有效，表示2g，3g 4g

	public static void showToast(final String cont){
		mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Toast.makeText(mActivity, cont, Toast.LENGTH_LONG).show();
			}
		});
	}
	
	public SalmonUtils() {
		// TODO Auto-generated constructor stub
		screenUtils = new ScreenUtils();
	}
	
	public Activity getActivity()
	{
		return mActivity;
	}

	public static SalmonUtils getInstance() {
		if (mInstance == null)
			mInstance = new SalmonUtils();
		return mInstance;
	}

	public static void init(Activity _activity, Handler _handler) {
		SalmonUtils.mActivity = _activity;
		SalmonUtils.mHandler = _handler;
		MediaHelper.getInstance().init(_activity);
	//	AuthUtils.getIntance();
		assetMgr = _activity.getResources().getAssets();
		getInstance();
		
		setStatusBarVisible(true, 0);
		doSetTransparentStatusBar();
//		setTransparentStatusBar();
//		 btutmain(assetMgr);
	}

	public String getTotalRxBytes() {
		TrafficStats.getUidRxBytes((int) ((mActivity.getApplicationInfo().uid == TrafficStats.UNSUPPORTED) ? 0 : (TrafficStats.getTotalRxBytes() / 1024)));
		return "";
	}

	public static void dealloc() {
		// TODO: 可能需要做一些释放处理
	}

	public static int getEditBoxSelectionStart(final Cocos2dxEditBox editBox ){
    	return editBox.getSelectionStart();
    }

	// 设置声音大小
	public static void setVolume(float percent) {
		MediaHelper.getInstance().setVolume(percent);
	}

	// 设置屏幕亮度
	public static void setBrightness(float percent) {
		// MediaHelper.getInstance().setBrightness(percent);
		Bundle bundle = new Bundle();
		bundle.putFloat("percent", percent);
		Message msg = new Message();
		msg.setData(bundle);
		msg.what = Constans.HANDLER_TYPE_SET_BRIGHTNESS;
		mHandler.sendMessage(msg);
	}
	
	public static float getVolume()
	{
		return MediaHelper.getInstance().getVolume();
	}
	
	public static float getBrightness()
	{
		return MediaHelper.getInstance().getBrightness();
	}

	public static void setBrightnessInRightThread(float percent) {
		MediaHelper.getInstance().setBrightness(percent);
	}
	
	//获取版本名称
	public static String getVersionName()
	{
		try {
 			String pkName = SalmonUtils.mActivity.getPackageName();
 			String versionName = SalmonUtils.mActivity.getPackageManager().getPackageInfo(pkName, 0).versionName;
 			return versionName == null ? "":versionName;
 		} catch (Exception e) {
 		}
 		return null;
	}

	public static int getVersionIntName1()
	{
		String versionName = getVersionName();
		String[] strList = versionName.split(".");
		int v1 = Integer.parseInt(strList[0]);
		return v1;
	}
	public static int getVersionIntName2()
	{
		String versionName = getVersionName();
		String[] strList = versionName.split(".");
		int v2 = Integer.parseInt(strList[1]);
		return v2;
	}
	public static int getVersionIntName3()
	{
		String versionName = getVersionName();
		String[] strList = versionName.split(".");
		int v3 = Integer.parseInt(strList[2]);
		return v3;
	}
	
	public static String getVersionCode()
	{
		try {
 			String pkName = SalmonUtils.mActivity.getPackageName();
 			int versionCode = SalmonUtils.mActivity.getPackageManager().getPackageInfo(
 					pkName, 0).versionCode;
 			
 			return String.valueOf(versionCode);
 		} catch (Exception e) {
 		}
 		return null;
	}

	private static File createImageFile() throws IOException {
		String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
		String imageFileName = "JPEG_" + timeStamp + "_";
		File image = File.createTempFile(imageFileName, ".jpg", Environment.getExternalStorageDirectory());
		return image;
	}
	
	// 保存图片到相册
	public static void saveImageToPhotos(String captureName, int handler) {
		CameraUtils.getInstance().saveImageToPhotos(mActivity, handler, captureName);
	}
	
	// 打开图库
	public static void openGallery(String captureName, int handler) {
		CameraUtils.getInstance().openGallery(mActivity, handler, captureName);
	}

	// 拍一张照
	public static void captureImage(String captureName, int handler) {
		CameraUtils.getInstance().captureImage(mActivity, handler, captureName);
	}


	// 来自activity的回调
	public static void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (resultCode == Activity.RESULT_OK) {
			switch (requestCode) {
			case Constans.EVENT_OPEN_GALLERY:
				if (data != null) {
					Uri uriGallery = data.getData();
					CameraUtils.getInstance().crop(mActivity, uriGallery);
				}
				break;
			case Constans.EVENT_CAPTURE_IMAGE:
				Uri uriCamera = Uri.fromFile(CameraUtils.getInstance().getTempCameraFile());
				CameraUtils.getInstance().crop(mActivity, uriCamera);
				break;
			case Constans.CUT_PHOTO:
				Bitmap bitmapCut = BitmapFactory.decodeFile(CameraUtils.getInstance().getTempCropFile().getAbsolutePath());
				CameraUtils.getInstance().saveAndCallback(bitmapCut);
				break;
			default:
				break;
			}
		} else if (resultCode == Activity.RESULT_CANCELED) {
			switch (requestCode) {
			case Constans.EVENT_OPEN_GALLERY:
				CameraUtils.getInstance().notifySelectedImg("");
				break;
			case Constans.EVENT_CAPTURE_IMAGE:
				CameraUtils.getInstance().notifySelectedImg("");
				break;
			case Constans.CUT_PHOTO:
				CameraUtils.getInstance().notifySelectedImg("");
			default:
				break;
			}
		}
	}
	
	public static void onWindowFocusChanged(boolean hasFocus)
	{
		
	}
	
	public static void onConfigurationChanged(Configuration newConfig) {  
		Rect rect = new Rect();
		Window window = ((Activity) mActivity).getWindow();
		window.getDecorView().getWindowVisibleDisplayFrame(rect);
		mInstance.screenUtils.luaCallBack(newConfig, rect);
	}

	public static void handleMessage(Message msg) {
		switch (msg.what) {
		case Constans.HANDLER_TYPE_SET_BRIGHTNESS:
			Bundle bundle = msg.getData();
			float percent = bundle.getFloat("percent");
			SalmonUtils.setBrightnessInRightThread(percent);
			break;
		case Constans.HANDLER_TYPE_COPY_TEXT:
			Bundle bundle1 = msg.getData();
			String content = bundle1.getString("content");
			SalmonUtils.copyByHandler(content);
			break;
		case Constans.HANDLER_TYPE_LOCATION:
			SalmonUtils.getCNByHandler();
			break;
		case Constans.HANDLER_TYPE_STATUS:
			Bundle bundle11 = msg.getData();
			int type = bundle11.getInt("type");
			SalmonUtils.doSetStatus(type);
			break;
		case Constans.HANDLER_TYPE_STATUS_BAR_TRANSPARENT:
			SalmonUtils.doSetTransparentStatusBar();
			break;
		default:
			break;
		}
	}

	/**
	 * 获取内外缓存
	 * 
	 * @return 缓存大小 eg. 1.9KB
	 */
	public static String getTotalCacheSize() {
		try {
			return DataCleanManager.getTotalCacheSize(mActivity);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "0.0KB";
	}

	/**
	 * 清除所有缓存
	 */
	public static void clearAllCache() {
		DataCleanManager.clearAllCache(mActivity);
	}

	public static String getCNBylocation(int handler) {
	//	LocationUtils.getIntance().setLuaHandler(handler);
		Bundle bundle = new Bundle();
		Message msg = new Message();
		msg.setData(bundle);
		msg.what = Constans.HANDLER_TYPE_LOCATION;
		mHandler.sendMessage(msg);
		return "";
	}

	private static void getCNByHandler() {
	//	LocationUtils.getIntance().getCNBylocation(mActivity);
	}

	/**
	 * 复制文件，TODO:最好是开一个线程，完成后jni回调
	 * 
	 * @param saveDir
	 *            保存文件的相对路径
	 * @param filename
	 *            保存的文件名
	 * @param fromFile
	 *            asset中的文件路径
	 * @param context
	 *            上下文
	 */
	public static void copyFileToSD(String saveDir, String filename,
			String fromFile, Context context) {
		try {
			FileUtils.getInstance().copyFileToSD(saveDir, filename, fromFile, mActivity);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * 复制文本
	 * 
	 * @param content
	 *            文本内容
	 */
	public static void copy(String content) {
		// ClipboardUtils.getInstance().copy(content, mActivity);
		Bundle bundle = new Bundle();
		bundle.putString("content", content);
		Message msg = new Message();
		msg.setData(bundle);
		msg.what = Constans.HANDLER_TYPE_COPY_TEXT;
		mHandler.sendMessage(msg);
	}

	private static void copyByHandler(String content) {
		ClipboardUtils.getInstance().copy(content, mActivity);
	}

	/**
	 * 黏贴
	 * 
	 * @return 文本
	 */
	public static String paste() {
		return ClipboardUtils.getInstance().paste(mActivity);
	}

	/**
	 * wifi是否开启
	 * 
	 * @return
	 */
//	public static boolean isWifiOpened() {
//		return NetworkUtils.isNetworkConnected(mActivity);
//	}

	/**
	 * GPS 是否开启
	 * 
	 * @return
	 */
//	public static boolean isGpsEnable() {
//		return NetworkUtils.isGpsEnable(mActivity);
//	}

	/**
	 * 开启闪光灯
	 */
	public static void openFlashLight() {
		// CameraUtils.getInstance().openFlashLight();
		Bundle bundle = new Bundle();
		Message msg = new Message();
		msg.setData(bundle);
		msg.what = Constans.HANDLER_TYPE_OPEN_FLASHLIGHT;
		mHandler.sendMessage(msg);
	}

	private static void openFlashLightByHandler() {
		CameraUtils.getInstance().openFlashLight();
	}

	/**
	 * 关闭闪光灯
	 */
	public static void closeFlashLight() {
		// CameraUtils.getInstance().closeFlashLight();
		Bundle bundle = new Bundle();
		Message msg = new Message();
		msg.setData(bundle);
		msg.what = Constans.HANDLER_TYPE_CLOSE_FLASHLIGHT;
		mHandler.sendMessage(msg);
	}

	private static void closeFlashLightByHandler() {
		CameraUtils.getInstance().closeFlashLight();
	}

	public static String getAllPhoneNums() {
		try {
			return ContactUtils.getInstance().getAllPhoneNums(mActivity);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}



	public static void copyToWritablePath(String dir) {
		String dest = Cocos2dxHelper.getCocos2dxWritablePath();
		AssetCopyer cp = new AssetCopyer(mActivity);
		cp.CopyAssetsDir(mActivity, dir, dest);
		// FileUtils.getInstance().copyToWritablePath(mActivity, dir);
	}

	/**
	 * 切换横竖屏
	 * 
	 * @param type
	 *            2横屏 1竖
	 */
	public static void setOrientation(int type) {
		switch (type) {
		case 2:
			mActivity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
			break;
		case 1:
			mActivity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
			break;

		default:
			break;
		}
	}

	public static void setStatusBarVisible(boolean isShow, int handler) {
		mInstance.screenUtils.setLuaHadler(handler);
		int type = isShow ? 1 : 2;
		Bundle bundle = new Bundle();
		bundle.putInt("type", type);
		Message msg = new Message();
		msg.setData(bundle);
		msg.what = Constans.HANDLER_TYPE_STATUS;
		mHandler.sendMessage(msg);
	}

	// 不要直接调用这个函数，请调用 setStatusBarVisible
	public static void doSetStatus(int type) {
		mInstance.screenUtils.setStatusBarVisible(mActivity, type);
	}

	public static void openGpsSetting() {
		Intent intent = new Intent();
		intent.setAction(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		try {
			mActivity.startActivity(intent);

		} catch (ActivityNotFoundException ex) {

			// The Android SDK doc says that the location settings activity
			// may not be found. In that case show the general settings.

			// General settings activity
			intent.setAction(Settings.ACTION_SETTINGS);
			try {
				mActivity.startActivity(intent);
			} catch (Exception e) {
			}
		}
	}

	// 设置状态栏透明
	public static void setTransparentStatusBar()
	{
		Message msg = new Message();
		msg.what = Constans.HANDLER_TYPE_STATUS_BAR_TRANSPARENT;
		mHandler.sendMessage(msg);
	}
	
	public static void doSetTransparentStatusBar()
	{
//        Window window = mActivity.getWindow();
//        WindowManager.LayoutParams params = window.getAttributes();
//        final int bits = WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS;  
//        params.flags |= bits;
//        window.setAttributes(params);
//        window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
//        //透明导航栏
//        window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
     }
	
	//设置屏幕工具lua回调
	public static void setScreenHandler(int handler)
	{
		mInstance.screenUtils.setLuaHadler(handler);
	}
	
	public static String getWindowRect()
	{
		Rect rectangle = new Rect();
		Window window = ((Activity) mActivity).getWindow();
		window.getDecorView().getWindowVisibleDisplayFrame(rectangle);
		JSONObject jObj = new JSONObject();
		try {
			jObj.put("left", rectangle.left);
			jObj.put("top", rectangle.top);
			jObj.put("right", rectangle.right);
			jObj.put("bottom", rectangle.bottom);
			jObj.put("width", rectangle.width());
			jObj.put("height", rectangle.height());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return jObj.toString();
	}
	
	public static int getStatusBarHeight()
	{
//		Rect rectangle = new Rect();
//		Window window = ((Activity)mActivity).getWindow();
//		window.getDecorView().getWindowVisibleDisplayFrame(rectangle);
////		int height = rectangle.bottom - rectangle.top;
//		return rectangle.top;
		Class<?> c = null;  
		  
        Object obj = null;  
  
        Field field = null;  
  
        int x = 0, sbar = 0;  
  
        try {  
  
            c = Class.forName("com.android.internal.R$dimen");  
  
            obj = c.newInstance();  
  
            field = c.getField("status_bar_height");  
  
            x = Integer.parseInt(field.get(obj).toString());  
  
            sbar = ((Cocos2dxActivity) mActivity).getContext().getResources().getDimensionPixelSize(x);  
  
        } catch (Exception e1) {  
  
            e1.printStackTrace();  
  
        }  
  
        return sbar; 
        
	}
	
	private void releaseNetworkChangeHandler()
	{
		if(networkChangeHandler != 0)
		{
			Cocos2dxLuaJavaBridge.releaseLuaFunction(networkChangeHandler);
			networkChangeHandler = 0;
		}
	}
	
	public static void setNetworkChangeEvent(int handler)
	{
		if(mInstance == null) return; 
		mInstance.releaseNetworkChangeHandler();
		mInstance.networkChangeHandler = handler;
	}
	
	public static void notifyNetworkStatus(int type, int mobileType)
	{
		if(mInstance == null || mInstance.networkChangeHandler == 0) return;
		mInstance.connectType = type;
		mInstance.networkType = mobileType;
		((Cocos2dxActivity)mActivity).runOnGLThread(new Runnable() {
			
			@Override
			public void run() {
				JSONObject jobj = new JSONObject();
				try {
					jobj.put("status", mInstance.connectType);
					jobj.put("networkType", mInstance.networkType);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(mInstance.networkChangeHandler, jobj.toString());
			}
		});
		
	}
	
	// 0 无连接  1wif 2移动网络
	public static int getConnectedType()
	{
        State wifiState = null;  
        State mobileState = null;  
        ConnectivityManager cm = (ConnectivityManager) mActivity.getSystemService(Context.CONNECTIVITY_SERVICE);  
        wifiState = cm.getNetworkInfo(ConnectivityManager.TYPE_WIFI).getState();  
        
        NetworkInfo mobileInfo = cm.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
        mobileState = mobileInfo.getState();
        
        if (wifiState != null && mobileState != null  
                && State.CONNECTED != wifiState  
                && State.CONNECTED == mobileState) {  
            // 手机网络连接成功  
        	Log.d("NetwrokBroadcast", "mobile network connect success");
        	return 2;
        } else if (wifiState != null && mobileState != null  
                && State.CONNECTED != wifiState  
                && State.CONNECTED != mobileState) {  
            // 手机没有任何的网络  
        	Log.d("NetwrokBroadcast", "not network connectted");
        	return 0;
        } else if (wifiState != null && State.CONNECTED == wifiState) {  
            // 无线网络连接成功  
        	Log.d("NetwrokBroadcast", "wifi network connect success");
        	return 1;
        }
		
		return 0;
	}

	// 返回值参照ios以保持lua一致处理
	public static int cameraAuthorization()
	{
		PackageManager pkm = mActivity.getPackageManager();
		boolean pm = (PackageManager.PERMISSION_GRANTED == pkm.checkPermission("android.permission.CAMERA", mActivity.getPackageName()));
		if(pm) return 3;
		return 2;
	}

	// 获取配置中的属性
    public static String getInfoDataByKey(String key) {
        try {
            if (mActivity == null || mActivity.getPackageManager() == null || mActivity.getPackageName() == null || mActivity.getPackageName().equals("")) {
                return ""+0;
            }
            ApplicationInfo appInfo = mActivity.getPackageManager().getApplicationInfo(mActivity.getPackageName(),
                    PackageManager.GET_META_DATA);
            Log.i("update","key == "+key);
            String value = appInfo.metaData.getString(key);
            Log.i("update","value == "+value);

            return ""+value;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        return ""+0;
    }
	
	public static int numberOfCameras()
	{
		return CameraUtils.getInstance().numberOfCameras();
	}
	
	public static int audioAuthorization()
	{
		PackageManager pkm = mActivity.getPackageManager();
		boolean pm = (PackageManager.PERMISSION_GRANTED == pkm.checkPermission("android.permission.RECORD_AUDIO", mActivity.getPackageName()));
		if(pm) return 3;
		return 2;
	}
	
	public static void setIsKeepWake(boolean isKeepWake)
	{
		if (isKeepWake) {
			mActivity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		}else
			mActivity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TOUCHABLE_WHEN_WAKING);
	}

	public static void openAnotherApp(String packname, String appname) {
		final String tipName = appname;
		try {
			Intent intent = mActivity.getPackageManager().getLaunchIntentForPackage(packname);
			// intent.putExtra("LauncherUI.From.Scaner.Shortcut", true);
			mActivity.startActivity(intent);

		} catch (Exception e) {
			mActivity.runOnUiThread(new Runnable() {
				@Override
				public void run() {
					Toast.makeText(mActivity, "没有安装" + tipName, Toast.LENGTH_LONG).show();
				}
			});
		}
	}

	public static boolean isEmulator()
	{
		return OSInfoUtils.getInstance().isEmulator(mActivity);
	}

}
