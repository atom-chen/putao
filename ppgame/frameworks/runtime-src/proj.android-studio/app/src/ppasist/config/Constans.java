package ppasist.config;

public class Constans {
	public static final long HTTP_CONNECT_TIMEOUT = 5000L;
	public static final long HTTP_READ_TIMEOUT = 5000L;
	public static final long HTTP_WRITE_TIMEOUT = 5000L;

	//打开拍照
	public static final int THIRD_OPEN_PHOTO = 10001;
	//打开拍思视频
	public static final int THIRD_OPEN_VIDEO = 10002;

	/** 打开图库并选择一张图片返回 */
	public static final int EVENT_OPEN_GALLERY = 100;
	
	/** 打开相机拍照获取一张图片 */
	public static final int EVENT_CAPTURE_IMAGE = 101;

	// 裁剪图片
	public static final int CUT_PHOTO = 102;
	
	///////////////////////// handler type ///////////////////
	public static final int HANDLER_TYPE_SET_BRIGHTNESS = 1;
	
	public static final int HANDLER_TYPE_COPY_TEXT = 2;
	
	public static final int HANDLER_TYPE_OPEN_FLASHLIGHT = 3;
	public static final int HANDLER_TYPE_CLOSE_FLASHLIGHT = 4;
	
	public static final int HANDLER_TYPE_LOCATION = 5;
	
	// 状态栏
	public static final int HANDLER_TYPE_STATUS = 6;
	
	public static final int HANDLER_TYPE_STATUS_BAR_TRANSPARENT = 7;
	
}
