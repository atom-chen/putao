package ppasist.utils;

import org.cocos2dx.lib.Cocos2dxActivity;

import android.app.Activity;
import android.content.Context;
import android.media.AudioManager;
import android.media.MediaRecorder;
import android.os.Environment;
import android.provider.Settings;
import android.provider.Settings.SettingNotFoundException;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.Window;
import android.view.WindowManager;

// 多媒体
public class MediaHelper/* implements SurfaceHolder.Callback*/ {
	
	public static MediaHelper m_instance;
	
	private static Activity activity;
	
	private AudioManager mAudioManager;
	
	private MediaRecorder mRecoder;
	
	private boolean isRecording = false;
	
	private SurfaceView mSurefaceView = null;
	
	private SurfaceHolder holder = null;
	
	private static Cocos2dxActivity mCcoos2dxActivity;
	
	
	private int mMaxVolume = 0;
	private int mMaxBrightness = 0;
	
	private float mVolume = 0f;
    
    private float mBrightness = -1f;
    
	public static MediaHelper getInstance()
	{
		if(m_instance == null){
			m_instance = new MediaHelper();
		}
		return m_instance;
	}
	
	public void init(Activity _activity)
	{
		this.activity = _activity;
		mAudioManager = (AudioManager)activity.getSystemService(Context.AUDIO_SERVICE);
		mMaxVolume = mAudioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
		mVolume = mAudioManager.getStreamVolume(AudioManager.STREAM_MUSIC)/mMaxVolume; // 0 - 1
	}
	
	public void setVolume(float percent)
	{
//		int index = 0;
//		index = (int) Math.ceil(mMaxVolume * percent);
		mVolume = percent;
		mVolume = Math.min(mVolume, 1);
		mVolume = Math.max(mVolume, 0);
		int index = (int) Math.ceil(mVolume*mMaxVolume);
		mAudioManager.setStreamVolume(AudioManager.STREAM_MUSIC, index, 0);
	}
	
	public float getVolume()
	{
//		float curVolume = mAudioManager.getStreamVolume(AudioManager.STREAM_MUSIC);
//		return curVolume/mMaxVolume;
		return mVolume;
	}
	
	public void setBrightness(float percent)
	{
		percent = Math.min(percent, 1);
		percent = Math.max(percent, 0);
		try {
			Settings.System.putFloat(activity.getContentResolver(), Settings.System.SCREEN_BRIGHTNESS, 255f*percent);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		Window localWindow = activity.getWindow();
		WindowManager.LayoutParams localLayoutParams = localWindow.getAttributes();
		localLayoutParams.screenBrightness = percent;
		localWindow.setAttributes(localLayoutParams);
	}
	
	// 0 - 1
	public float getBrightness()
	{
		try {
			float brightness = Settings.System.getFloat(activity.getContentResolver(), Settings.System.SCREEN_BRIGHTNESS);
			float curBrightennes = brightness/255f;
			return curBrightennes;
		} catch (SettingNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0.0f;
//		Window window = activity.getWindow();
//		WindowManager.LayoutParams layoutParams = window.getAttributes();
//		float curBrightness = layoutParams.screenBrightness;
//		return curBrightness;
	}

	public void startRecode()
	{
		if(mRecoder == null)
			mRecoder = new MediaRecorder();
	}
	
	public void stopRecode()
	{
		
	}
	
//	@Override
//	public void surfaceChanged(SurfaceHolder holder, int format, int width,
//			int height) {
//		// TODO Auto-generated method stub
//		
//	}
//
//	@Override
//	public void surfaceCreated(SurfaceHolder holder) {
//		// TODO Auto-generated method stub
//		
//	}
//
//	@Override
//	public void surfaceDestroyed(SurfaceHolder holder) {
//		// TODO Auto-generated method stub
//		
//	}
	
}
