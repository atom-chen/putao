package ppasist.utils;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.cocos2dx.lib.Cocos2dxHelper;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import android.content.Context;

/**
 * 文件处理工具，复制粘贴
 * 
 * @author Administrator
 * 
 */
public class FileUtils {

	private static FileUtils mInstance = null;
	
	public static FileUtils getInstance()
	{
		if(mInstance == null)
			mInstance = new FileUtils();
		return mInstance;
	}
	
	// 文件拷贝
	// 要复制的目录下的所有非子目录(文件夹)文件拷贝
	public int CopySdcardFile(String fromFile, String toFile) {

		try {
			InputStream fosfrom = new FileInputStream(fromFile);
			OutputStream fosto = new FileOutputStream(toFile);
			byte bt[] = new byte[1024];
			int c;
			while ((c = fosfrom.read(bt)) > 0) {
				fosto.write(bt, 0, c);
			}
			fosfrom.close();
			fosto.close();
			return 0;

		} catch (Exception ex) {
			return -1;
		}
	}

	public void copyFileToSD(String saveDir, String filename,
			String fromFile, Context context) throws IOException {
		
		filename = context.getFilesDir().getAbsolutePath() + "/" + filename;
		String savePath = context.getFilesDir().getAbsolutePath() + "/" + saveDir ;
		File dir = new File(savePath);
		// 如果目录不中存在，创建这个目录
		if (!dir.exists())
			dir.mkdir();
		try {
			if (!(new File(filename)).exists()) {
				InputStream is = context.getResources()
						.getAssets().open(fromFile);
				FileOutputStream fos = new FileOutputStream(filename);
				byte[] buffer = new byte[7168];
				int count = 0;
				while ((count = is.read(buffer)) > 0) {
					fos.write(buffer, 0, count);
				}
				fos.close();
				is.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 讲文件夹复制到可写目录中
	 * @param directory 目录路径
	 */
	public void copyToWritablePath(Context context, String directory)
	{
		String writablePath = Cocos2dxHelper.getCocos2dxWritablePath() + "/" + directory;
		directory = context.getFilesDir().getAbsolutePath() + "/" + directory;
	    // 创建目标文件夹
        (new File(writablePath)).mkdirs();  
        // 获取源文件夹当前下的文件或目录  
        File[] file = (new File(directory)).listFiles();  
        for (int i = 0; i < file.length; i++) {  
            if (file[i].isFile()) {  
                // 复制文件  
                try {
					copyFile(file[i],new File(writablePath+file[i].getName()));
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}  
            }  
            if (file[i].isDirectory()) {  
                // 复制目录
                String sourceDir=writablePath+File.separator+file[i].getName();  
                String targetDir=writablePath+File.separator+file[i].getName();  
                try {
					copyDirectiory(sourceDir, targetDir);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}  
            }  
        }  
		
		
	}
	
	   public boolean copyFolder(Context context, String oldPath) { 
		   String newPath = Cocos2dxHelper.getCocos2dxWritablePath() + "/" + oldPath;
		   oldPath = context.getFilesDir().getAbsolutePath() + "/" + oldPath;
	       boolean isok = true;
	       try { 
	           (new File(newPath)).mkdirs(); //如果文件夹不存在 则建立新文件夹 
	           File a=new File(oldPath); 
	           String[] file=a.list(); 
	           File temp=null; 
	           for (int i = 0; i < file.length; i++) { 
	               if(oldPath.endsWith(File.separator)){ 
	                   temp=new File(oldPath+file[i]); 
	               } 
	               else
	               { 
	                   temp=new File(oldPath+File.separator+file[i]); 
	               } 
	 
	               if(temp.isFile()){ 
	                   FileInputStream input = new FileInputStream(temp); 
	                   FileOutputStream output = new FileOutputStream(newPath + "/" + 
	                           (temp.getName()).toString()); 
	                   byte[] b = new byte[1024 * 5]; 
	                   int len; 
	                   while ( (len = input.read(b)) != -1) { 
	                       output.write(b, 0, len); 
	                   } 
	                   output.flush(); 
	                   output.close(); 
	                   input.close(); 
	               } 
	               if(temp.isDirectory()){//如果是子文件夹 
//	                   copyFolder(oldPath+"/"+file[i],newPath+"/"+file[i]); 
	            	   copyFolder(context, oldPath+"/"+file[i]);
	               } 
	           } 
	       } 
	       catch (Exception e) { 
	            isok = false;
	       } 
	       return isok;
	   }
	
	public static void copyFile(File sourceFile,File targetFile)   
			throws IOException{
        // 新建文件输入流并对它进行缓冲  
        FileInputStream input = new FileInputStream(sourceFile);  
        BufferedInputStream inBuff=new BufferedInputStream(input);  
  
        // 新建文件输出流并对它进行缓冲   
        FileOutputStream output = new FileOutputStream(targetFile);  
        BufferedOutputStream outBuff=new BufferedOutputStream(output);  
          
        // 缓冲数组
        byte[] b = new byte[1024 * 5];  
        int len;  
        while ((len =inBuff.read(b)) != -1) {  
            outBuff.write(b, 0, len);  
        }  
        // 刷新此缓冲的输出流 
        outBuff.flush();  
          
        //关闭流  
        inBuff.close();  
        outBuff.close();  
        output.close();  
        input.close();  
    }
	// 复制文件夹
	public static void copyDirectiory(String sourceDir, String targetDir)  
	            throws IOException {

        (new File(targetDir)).mkdirs();  
        
        File[] file = (new File(sourceDir)).listFiles();  
        for (int i = 0; i < file.length; i++) {  
            if (file[i].isFile()){
                
                File sourceFile=file[i];  
                
                File targetFile=new File(new File(targetDir).getAbsolutePath() +File.separator+file[i].getName());  
                copyFile(sourceFile,targetFile);
            }
            if (file[i].isDirectory()) {
                
                String dir1=sourceDir + "/" + file[i].getName();  
                
                String dir2=targetDir + "/"+ file[i].getName();  
                copyDirectiory(dir1, dir2);  
            }
	    }  
	} 
	
}
