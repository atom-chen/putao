package ppasist.utils;

import android.Manifest;
import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.hardware.Camera;
import android.hardware.Camera.CameraInfo;
import android.hardware.Camera.Parameters;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;

import ppasist.config.Constans;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxHelper;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;


public class CameraUtils {

	private static CameraUtils mInstance = null;

	private Camera camera = null;

	private static int mHandler = 0; // 回调
	private static String mCaptureName = null; // 捕捉相片名字

	public static String TMP_CAMERA_FILENAME = "tmp_photo.jpg";
	private File mTempCameraFile;
	public static String TMP_CROP_FILENAME = "tmp_crop.jpg";
	private File mTempCropFile;

	public String returnPath = "";

	public static CameraUtils getInstance() {
		if (mInstance == null)
			mInstance = new CameraUtils();
		return mInstance;
	}

	/**
	 * 开启闪光灯
	 */
	@SuppressWarnings("deprecation")
	public void openFlashLight() {
		if (camera == null) {
			try{
				camera = Camera.open();
				Parameters mParameters = camera.getParameters();
				mParameters.setFlashMode(Camera.Parameters.FLASH_MODE_TORCH);// 打开Camera.Parameters.FLASH_MODE_OFF则为关闭
				camera.setParameters(mParameters);
				camera.startPreview();
			} catch(Exception ex){}
		}else
		{
			Parameters mParameters = camera.getParameters();
			mParameters.setFlashMode(Camera.Parameters.FLASH_MODE_TORCH);// 打开Camera.Parameters.FLASH_MODE_OFF则为关闭
			camera.setParameters(mParameters);
			camera.startPreview();
		}
	}

	/**
	 * 关闭闪关灯
	 */
	@SuppressWarnings("deprecation")
	public void closeFlashLight() {
		if (camera != null) {
			try{
				Parameters parameter = camera.getParameters();
				parameter.setFlashMode(Parameters.FLASH_MODE_OFF);
				camera.setParameters(parameter);
				camera.stopPreview();
				camera.release();
				camera = null;
			} catch(Exception ex){}
		}
	}

	// 保存图片到相册
	public void saveImageToPhotos(Activity context, int handler, String captureName) {
		mCaptureName = captureName;
		setHandler(handler);

		returnPath = "success";

		Bitmap bitmap = BitmapFactory.decodeFile(captureName);
		if (bitmap == null) returnPath = "failed";

		Uri uri = Uri.parse(MediaStore.Images.Media.insertImage(context.getContentResolver(), bitmap, null, null));
		if (uri == null) returnPath = "failed";

		Cursor cursor = context.getContentResolver().query(uri, null, null, null, null);
		if (cursor == null) returnPath = "failed";

		cursor.moveToFirst();
		cursor.close();
		bitmap.recycle();

		notifyLuaCallBack();
	}

	//拍照
	public void captureImage(Activity context, int handler, String captureName) {
		mCaptureName = captureName;
		mHandler = handler;
		Cocos2dxLuaJavaBridge.retainLuaFunction(mHandler); // 保证不会自动回收

		//申请外部存储权限
		if(!AuthorUtils.CheckCamera()){
			Cocos2dxLuaJavaBridge.releaseLuaFunction(mHandler);
			return;
		}

		//跳转拍照
		Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

		List resInfoList = context.getPackageManager().queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY);
		if (resInfoList.size() == 0) {
			Log.e("CameraUtils", "没有合适的相机应用程序");
			Cocos2dxLuaJavaBridge.releaseLuaFunction(mHandler);
			return;
		}

		mTempCameraFile = new File(Environment.getExternalStorageDirectory(),TMP_CAMERA_FILENAME);
		Uri uri;
		if(android.os.Build.VERSION.SDK_INT<24){
			uri = Uri.fromFile(mTempCameraFile);
		}else {
			ContentValues contentValues = new ContentValues(1);
			contentValues.put(MediaStore.Images.Media.DATA, Environment.getExternalStorageDirectory()+"/"+TMP_CAMERA_FILENAME);
			uri = context.getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,contentValues);
		}

	//	Iterator resInfoIterator = resInfoList.iterator();
	//	while (resInfoIterator.hasNext()) {
	//		ResolveInfo resolveInfo = (ResolveInfo) resInfoIterator.next();
	//		String packageName = resolveInfo.activityInfo.packageName;
	//		context.grantUriPermission(packageName, uri, Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
	//	}

		intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
		context.startActivityForResult(intent, Constans.EVENT_CAPTURE_IMAGE);              
	}
	public File getTempCameraFile() {
		return mTempCameraFile;
	}
	public File getTempCropFile() {
		return mTempCropFile;
	}

	//相冊
	public void openGallery(Activity context, int handler, String captureName) {
		//申请外部存储权限
		if(!AuthorUtils.CheckCamera()){
			Cocos2dxLuaJavaBridge.releaseLuaFunction(mHandler);
			return;
		}

		mCaptureName = captureName;
		Intent picture = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
		context.startActivityForResult(picture, Constans.EVENT_OPEN_GALLERY);
		setHandler(handler);
	}

	//裁剪
	public void crop(Activity context, Uri uri) {
		Intent intent = new Intent("com.android.camera.action.CROP");
		intent.setDataAndType(uri, "image/*");
		intent.putExtra("crop", "true");
		intent.putExtra("aspectX", 1);
		intent.putExtra("outputX", 300);
		intent.putExtra("outputY", 300);
		intent.putExtra("return-data", false);
		mTempCropFile = new File(Environment.getExternalStorageDirectory(),TMP_CROP_FILENAME);
		intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(mTempCropFile));
		intent.putExtra("outputFormat", Bitmap.CompressFormat.JPEG.toString());
		intent.putExtra("noFaceDetection", true);
		context.startActivityForResult(intent, Constans.CUT_PHOTO);
	}

	public void saveAndCallback(Bitmap bitmap) {
		saveBm(bitmap);
	}

	private void saveBm(Bitmap bm) {
		if(bm==null) {
			callback(false);
			return;
		}
		String writablePath = Cocos2dxHelper.getCocos2dxWritablePath();
		// String savePath = writablePath + mCaptureName;
		if (mCaptureName == null)
			mCaptureName = "image.jpg";
		File f = new File(writablePath, mCaptureName);
		if (f.exists())
			f.delete();
		try {
			FileOutputStream out = new FileOutputStream(f);
			bm.compress(Bitmap.CompressFormat.JPEG, 100, out);
			bm.recycle();
			out.flush();
			out.close();
			callback(true);
			// Log.i(TAG, "已经保存");
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			callback(false);
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			callback(false);
			e.printStackTrace();
		}
	}

	private void callback(boolean bSucc) {
		if( mHandler <=0 )
			return ;
		returnPath = "";
		if (bSucc) {
			returnPath = Cocos2dxHelper.getCocos2dxWritablePath() + "/" + mCaptureName;
		}
		notifyLuaCallBack();
	}

	private void releaseHandler()
	{
		if(mHandler > 0)
			Cocos2dxLuaJavaBridge.releaseLuaFunction(mHandler);
	}
	
	private void setHandler(int handler)
	{
		releaseHandler();
		mHandler = handler;
		Cocos2dxLuaJavaBridge.retainLuaFunction(mHandler);
	}
	
	
	public void notifySelectedImg(String path)
	{		
		if( mHandler <=0 )
			return ;
		returnPath = path;
		
		notifyLuaCallBack();
	}
	
	public void notifyLuaCallBack()
	{
		Activity activity = SalmonUtils.getAcitivity();
		((Cocos2dxActivity)activity).runOnGLThread(new Runnable() {
			@Override
			public void run() {
				Log.d("CameraUtils", "照片路径：" + CameraUtils.getInstance().returnPath);
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(mHandler, CameraUtils.getInstance().returnPath);
				Cocos2dxLuaJavaBridge.releaseLuaFunction(mHandler);
				Cocos2dxLuaJavaBridge.releaseLuaFunction(mHandler);// 保证彻底释放
				mHandler = 0;
			}
		});
	}
	
	public int numberOfCameras(){
		return Camera.getNumberOfCameras();
	}
	
	private static boolean checkCameraFacing(final int facing) {
	    if (getSdkVersion() < Build.VERSION_CODES.GINGERBREAD) {
	        return false;
	    }
	    final int cameraCount = Camera.getNumberOfCameras();
	    CameraInfo info = new CameraInfo();
	    for (int i = 0; i < cameraCount; i++) {
	        Camera.getCameraInfo(i, info);
	        if (facing == info.facing) {
	            return true;
	        }
	    }
	    return false;
	}
	public static boolean hasBackFacingCamera() {
	    final int CAMERA_FACING_BACK = 0;
	    return checkCameraFacing(CAMERA_FACING_BACK);
	}
	public static boolean hasFrontFacingCamera() {
	    final int CAMERA_FACING_BACK = 1;
	    return checkCameraFacing(CAMERA_FACING_BACK);
	}
	public static int getSdkVersion() {
	    return android.os.Build.VERSION.SDK_INT;
	}
}
