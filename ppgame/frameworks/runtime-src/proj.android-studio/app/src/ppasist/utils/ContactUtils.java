package ppasist.utils;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.util.JsonReader;
import android.util.JsonWriter;
import android.util.Log;

/*联系人*/
public class ContactUtils {
	private static ContactUtils mInstance = null;

	public static ContactUtils getInstance() {
		if (mInstance == null)
			mInstance = new ContactUtils();
		return mInstance;
	}

	public String getAllPhoneNums(Context context) throws JSONException {
		Uri uri = Uri.parse("content://com.android.contacts/contacts");
		ContentResolver resolver = context.getContentResolver();
		Cursor cursor = resolver.query(uri, new String[] { "_id" }, null, null,
				null);
		JSONObject jObj = new JSONObject();
		int idx = 1;
		StringBuilder sb = new StringBuilder();
		sb.append("{");
		while (cursor.moveToNext()) {
			int contactsId = cursor.getInt(0);
//			sb.append(contactsId);
			uri = Uri.parse("content://com.android.contacts/contacts/"
					+ contactsId + "/data"); // 某个联系人下面的所有数据
			Cursor dataCursor = resolver.query(uri, new String[] { "mimetype",
					"data1", "data2" }, null, null, null);
//			JSONObject pObj = new JSONObject();
			boolean isPushBack = false;
			while (dataCursor.moveToNext()) {
				String data = dataCursor.getString(dataCursor
						.getColumnIndex("data1"));
				String type = dataCursor.getString(dataCursor
						.getColumnIndex("mimetype"));
//				if ("vnd.android.cursor.item/name".equals(type)) { // 如果他的mimetype类型是name
//					sb.append(", name=" + data);
//					pObj.put("name", data);
//				} else if ("vnd.android.cursor.item/email_v2".equals(type)) { // 如果他的mimetype类型是email
//					sb.append(", email=" + data);
				if ("vnd.android.cursor.item/phone_v2".equals(type) && data.length() > 0) { // 如果他的mimetype类型是phone
					jObj.put(idx++ +"", data);
					sb.append(data+",");
				}
			}
//			if(isPushBack)
//				jObj.put(idx++ + "", pObj.toString());
			
			dataCursor.close();
//			Log.i("phone", sb.toString());
		}
		cursor.close();
		sb.append("}");
//		Log.i("all data:", jObj.toString());
		return sb.toString();
	}

}
