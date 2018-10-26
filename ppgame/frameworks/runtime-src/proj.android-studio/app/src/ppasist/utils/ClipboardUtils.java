package ppasist.utils;

import android.annotation.SuppressLint;
import android.content.ClipboardManager;
import android.content.Context;

public class ClipboardUtils {
	
	public static ClipboardUtils mInstance = null;
	
	public static ClipboardUtils getInstance()
	{
		if(mInstance == null)
			mInstance = new ClipboardUtils();
		return mInstance;
	}
	
	/**
	 * 实现文本复制功能 ，为了兼容旧版本的复制黏贴
	 * @param content
	 */
	@SuppressLint("NewApi")
	public void copy(String content, Context context) {
		// 得到剪贴板管理器
		ClipboardManager cmb = (ClipboardManager) context
				.getSystemService(Context.CLIPBOARD_SERVICE);
		cmb.setText(content.trim());
	}

	/**
	 * 实现粘贴功能
	 * @param context
	 * @return
	 */
	@SuppressLint("NewApi")
	public String paste(Context context) {
		// 得到剪贴板管理器
		ClipboardManager cmb = (ClipboardManager) context
				.getSystemService(Context.CLIPBOARD_SERVICE);
		return cmb.getText().toString().trim();
	}
}
