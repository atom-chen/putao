package ppasist.utils;

import android.Manifest;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.PermissionChecker;
import org.cocos2dx.lua.AppActivity;

public class AuthorUtils {
    public static final int AUTH_CODE_INSTALL = 2;
    public static final int AUTH_CODE_CAMERA = 1;

    public static int getTargetSkdVersion() {
        int targetSdkVersion = 0;

        try {
            final PackageInfo info = AppActivity.mInstance.getPackageManager().getPackageInfo(AppActivity.mInstance.getPackageName(), 0);
            targetSdkVersion = info.applicationInfo.targetSdkVersion;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        return targetSdkVersion;
    }

    public static boolean CheckInstall() {
        int targetSdkVersion = AuthorUtils.getTargetSkdVersion();
        boolean ret = false;

        // 兼容 8.0
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            boolean haveInstallPermission = AppActivity.mInstance.getPackageManager().canRequestPackageInstalls();
            return haveInstallPermission;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (targetSdkVersion >= Build.VERSION_CODES.M) {
                ret = AppActivity.mInstance.checkSelfPermission(Manifest.permission.REQUEST_INSTALL_PACKAGES) == PackageManager.PERMISSION_GRANTED;
            } else {
                ret = PermissionChecker.checkSelfPermission(AppActivity.mInstance, Manifest.permission.REQUEST_INSTALL_PACKAGES) == PermissionChecker.PERMISSION_GRANTED;
            }
        }else{
            ret = true;
        }

        if(!ret) {
            SalmonUtils.showToast("请授予安装权限");
            ActivityCompat.requestPermissions(AppActivity.mInstance, new String[]{Manifest.permission.REQUEST_INSTALL_PACKAGES},AUTH_CODE_INSTALL);
        }

        return ret;
    }

    public static boolean CheckCamera() {
        int targetSdkVersion = AuthorUtils.getTargetSkdVersion();
        boolean ret = false;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (targetSdkVersion >= Build.VERSION_CODES.M) {
                ret = (AppActivity.mInstance.checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED)
                        && (AppActivity.mInstance.checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED)
                        && (AppActivity.mInstance.checkSelfPermission(Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED);
            } else {
                ret = (PermissionChecker.checkSelfPermission(AppActivity.mInstance, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PermissionChecker.PERMISSION_GRANTED)
                        &&(PermissionChecker.checkSelfPermission(AppActivity.mInstance, Manifest.permission.READ_EXTERNAL_STORAGE) == PermissionChecker.PERMISSION_GRANTED)
                        &&(PermissionChecker.checkSelfPermission(AppActivity.mInstance, Manifest.permission.CAMERA) == PermissionChecker.PERMISSION_GRANTED);
            }
        }else{
           ret = true;
        }

        if(!ret) {
            ActivityCompat.requestPermissions(AppActivity.mInstance,
                    new String[]{ Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE },
                    AUTH_CODE_CAMERA);
        }

        return ret;
    }
}
