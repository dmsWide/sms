package com.dmswide.controller;

import com.dmswide.bean.Admin;
import com.dmswide.service.AdminService;
import com.dmswide.util.UploadFile;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {
    @Autowired
    private AdminService adminService;

    private Map<String,Object> result = new HashMap<>();

    /**
     * 跳转管理员 信息管理页面
     * @return
     */
    @GetMapping("/goAdminListView")
    public String getAdminList(){
        return "admin/adminList";
    }

    /**
     * 分页查询 根据管理员的姓名查询指定管理员或者所有管理员信息
     * @param pageNum 当前开始的页码
     * @param pageSize 每页显示记录的行数
     * @param username 管理员姓名
     * @return
     */
    @PostMapping("/getAdminList")
    @ResponseBody
    public Map<String,Object> getAdminList(Integer pageNum,Integer pageSize,String username){
        Admin admin = new Admin();
        admin.setName(username);
        //设置每页的记录数
        PageHelper.startPage(pageNum,pageSize);
        //获取到的管理员
        List<Admin> admins = adminService.selectList(admin);
        //封装查询及过
        PageInfo<Admin> adminPageInfo = new PageInfo<>(admins);
        //总记录数
        long total = adminPageInfo.getTotal();
        //获取当前页数据列表
        List<Admin> adminList = adminPageInfo.getList();
        //存储数据
        result.put("total",total);
        result.put("rows",adminList);
        return result;
    }

    /**
     * 添加管理员
     * @param admin
     * @return
     */
    @PostMapping("/addAdmin")
    @ResponseBody
    public Map<String,Object> addAdmin(Admin admin){
        //判断用户是否存爱
        Admin user = adminService.findByName(admin.getName());
        if(user == null){
            if(adminService.insert(admin) > 0){
                result.put("success",true);
            }else{
                result.put("success",false);
                result.put("msg","添加失败 服务端异常");
            }
        }else{
            result.put("success",false);
            result.put("msg","用户名已存在！请修改用户名后重试");
        }
        return result;
    }


    /**
     * 根据Id修改指定管理员信息
     * @param admin
     * @return
     */
    @PostMapping("/editAdmin")
    @ResponseBody
    public Map<String,Object> editAdmin(Admin admin){
        Admin user = adminService.findByName(admin.getName());
        //重名判断
        if(user != null){
            if(!(admin.getName().equals(user.getName()))){
                result.put("success",false);
                result.put("msg","用户名已经存在，修改用户名后重试");
                return result;
            }
        }
        //编辑
        if(adminService.update(admin) > 0){
            result.put("success",true);
        }else{
            result.put("success",false);
            result.put("msg","添加失败 服务端发生错误");
        }
        return result;
    }

    /**
     * 删除指定id的管理员信息
     * @param ids
     * @return
     */
    @PostMapping("/deleteAdmin")
    @ResponseBody
    public Map<String,Object> deleteAdmin(@RequestParam(value = "ids[]") Integer[] ids){
        if(adminService.deleteById((ids)) > 0){
            result.put("success",true);
        }else{
            result.put("success",false);
        }
        return result;
    }

    /**
     * 上传头像：将头像上传到项目发布目录，读取数据库中的头像路径来获取头像
     * @param photo
     * @param request
     * @return
     */
    @PostMapping("/uploadPhoto")
    @ResponseBody
    public Map<String,Object> uploadPhoto(MultipartFile photo, HttpServletRequest request){
        //存储头像的本地目录
        String dirPath = request.getServletContext().getRealPath("/upload/admin_portrait/");
        //存储头像的发布目录
        String portraitPath = request.getServletContext().getContextPath() + "/upload/admin_portrait/";
        return UploadFile.getUploadResult(photo,dirPath,portraitPath);
    }
}
