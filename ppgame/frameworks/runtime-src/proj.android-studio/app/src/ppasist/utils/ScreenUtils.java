package ppasist.utils;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;
import org.json.JSONException;
import org.json.JSONObject;

import ppasist.config.Constans;

import android.app.Activity;
import android.content.Context;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Rect;
import android.os.Bundle;
import android.os.Message;
import android.view.Window;
import android.view.WindowManager;
import android.view.WindowManager.LayoutParams;

import java.lang.reflect.Method;

/*屏幕*/
public class ScreenUtils {

	private int luaHandler = 0;
	private static Rect rect;
	private static Configuration config;

	public void luaCallBack(Configuration config, Rect rect) {
		ScreenUtils.rect = rect;
		if (luaHandler == 0) {
			System.out.println("ScreenUtils¡£luaCallBack have not reg lua handler");
			return;
		}
		
		Cocos2dxActivity activity = (Cocos2dxActivity) SalmonUtils.getAcitivity();
		activity.runOnGLThread(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				Rect rect = ScreenUtils.rect;
				Configuration config = ScreenUtils.config;
				int width = rect.right;
				int height = rect.bottom;
				int x = rect.left;
				int y = rect.top;
				JSONObject obj = new JSONObject();

				try {
					obj.put("orientation", config.orientation);
					obj.put("width", width);
					obj.put("height", height);
					obj.put("x", x);
					obj.put("y", y);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaHandler, obj.toString());
			}
		});
	}

	private void releaseLuaHandler() {
		if (luaHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(luaHandler);
			luaHandler = 0;
		}
	}

	public void setLuaHadler(int handler) {
		releaseLuaHandler();
		luaHandler = handler;
	}

	public void setStatusBarVisible(Context context, int type) {
		switch (type) {
		case 1:
			((Activity) context).getWindow().clearFlags(
					WindowManager.LayoutParams.FLAG_FULLSCREEN);
			break;
		case 2:
			((Activity) context).getWindow().setFlags(
					WindowManager.LayoutParams.FLAG_FULLSCREEN,
					WindowManager.LayoutParams.FLAG_FULLSCREEN);
			break;
		default:
			break;
		}
//		Rect rectangle = new Rect();
//		Window window = ((Activity) context).getWindow();
//		window.getDecorView().getWindowVisibleDisplayFrame(rectangle);
//		luaCallBack(rectangle);
	}

	
	public int getOrientation(Activity activity)
	{
		Window window = activity.getWindow();
		WindowManager.LayoutParams params = window.getAttributes();
		return params.screenOrientation;
	}

	/**
	 //透明状态栏
	 getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
	 //透明导航栏
	 getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);

	 * 获取状态栏高度
	 */
	public static int getStatusBarHeight() {
		int result = 0;
		int resourceId = AppActivity.mInstance.getResources().getIdentifier("status_bar_height", "dimen", "android");
		if (resourceId > 0) {
			result = AppActivity.mInstance.getResources().getDimensionPixelSize(resourceId);
		}
		return result;
	}

	public static void showStatusBar(boolean bShow) {

	}
	public static void showNavagationBar(boolean bShow) {

	}
	public static void showActionBar(boolean bShow) {

	}

	/**
	 * 获取导航栏高度
	 */
	public static int getNavagationBarHeight() {
		int result = 0;
		int resourceId=0;
		int rid = AppActivity.mInstance.getResources().getIdentifier("config_showNavigationBar", "bool", "android");
		if (rid!=0){
			resourceId = AppActivity.mInstance.getResources().getIdentifier("navigation_bar_height", "dimen", "android");
			return AppActivity.mInstance.getResources().getDimensionPixelSize(resourceId);
		}else
			return 0;
	}

	//判断是否存在NavigationBar
	public static boolean hasNavigationBar() {
		boolean hasNavigationBar = false;
		Resources rs = AppActivity.mInstance.getResources();
		int id = rs.getIdentifier("config_showNavigationBar", "bool", "android");
		if (id > 0) {
			hasNavigationBar = rs.getBoolean(id);
		}
		try {
			//反射获取SystemProperties类，并调用它的get方法
			Class systemPropertiesClass = Class.forName("android.os.SystemProperties");
			Method m = systemPropertiesClass.getMethod("get", String.class);
			String navBarOverride = (String) m.invoke(systemPropertiesClass, "qemu.hw.mainkeys");
			if ("1".equals(navBarOverride)) {
				hasNavigationBar = false;
			} else if ("0".equals(navBarOverride)) {
				hasNavigationBar = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return hasNavigationBar;
	}

}
