package com.dmswide.util;

import org.apache.commons.io.filefilter.SuffixFileFilter;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOError;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class UploadFile {
    //文件上传失败的信息
    private static Map<String,Object> errorResult = new HashMap<>();
    //上传成功的结果信息
    private static Map<String,Object> uploadResult = new HashMap<>();

    /**
     * 校验头像大小和格式
     */
    public static Map<String,Object> uploadPortrait(MultipartFile multipartFile,String path){
        //限制头像大小 20M
        int MAX_SIZE = 20971520;
        //头像原始名称
        String originalName = multipartFile.getOriginalFilename();
        File filePath = new File(path);
        if(!filePath.exists()){
            filePath.mkdirs();
        }

        if(multipartFile.getSize() > MAX_SIZE){
            errorResult.put("success",false);
            errorResult.put("msg","文件头像过大");
            return errorResult;
        }
        String[] suffixes = new String[]{".png",".PNG",".jpg",".JPG",".jpeg",".jpeg",".gif",".GIF",".bmp",".BMP"};
        SuffixFileFilter suffixFileFilter = new SuffixFileFilter(suffixes);
        if(!suffixFileFilter.accept(new File(path + originalName))){
            errorResult.put("success",false);
            errorResult.put("msg","不支持该头像后缀格式");
            return errorResult;
        }
        return null;
    }

    public static Map<String,Object> getUploadResult(MultipartFile multipartFile,String dirPath,String portraitPath){
        if(!multipartFile.isEmpty() && multipartFile.getSize() > 0){
            String originalName = multipartFile.getOriginalFilename();
            Map<String,Object> err = UploadFile.uploadPortrait(multipartFile,dirPath);
            if(err != null){
                return err;
            }
            //UUID + __ + 原始图片名称 重命名图片
            String newPhotoName = UUID.randomUUID() + "__" + originalName;

            //将上传的文件保存到目标文件加下
            try{
                multipartFile.transferTo(new File(dirPath + newPhotoName));
                uploadResult.put("success",true);
                //将存储头像的项目路径返回给页面
                uploadResult.put("portraitPath",portraitPath + newPhotoName);
            }catch (IOException e){
                e.printStackTrace();
                uploadResult.put("success",false);
                uploadResult.put("msg","头像上传失败！服务端发生异常！");
                return uploadResult;
            }
        }else{
            uploadResult.put("success",false);
            uploadResult.put("msg","请指定要上传的头像");
        }
        return uploadResult;
    }
}
