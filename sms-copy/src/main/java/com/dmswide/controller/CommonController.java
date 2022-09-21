package com.dmswide.controller;

import com.dmswide.bean.Admin;
import com.dmswide.bean.Student;
import com.dmswide.bean.Teacher;
import com.dmswide.service.AdminService;
import com.dmswide.service.StudentService;
import com.dmswide.service.TeacherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/common")
public class CommonController {
    @Autowired
    private AdminService adminService;
    @Autowired
    private TeacherService teacherService;
    @Autowired
    private StudentService studentService;

    private Map<String,Object> result = new HashMap<>();

    /**
     * 跳转到个人信息管理页面
     * @return
     */
    @GetMapping("/goSettingView")
    public String getAdminList(){
        return "common/settings";
    }

    /**
     * 判断用户类型修改密码
     * @param oldPassword
     * @param newPassword
     * @param request
     * @return
     */

    @PostMapping("/editPassword")
    @ResponseBody
    public Map<String,Object> editPassword(String oldPassword, String newPassword, HttpServletRequest request){
        //判断用户类型
        int userType = Integer.parseInt(request.getSession().getAttribute("userType").toString());
        //admin
        if(userType == 1){
            Admin admin = (Admin) request.getSession().getAttribute("userInfo");
            if(!admin.getPassword().equals(oldPassword)){
                result.put("success",false);
                result.put("msg","原始密码错误");
                return result;
            }
            //向数据库中存储新密码
            try{
                admin.setPassword(newPassword);
                if(adminService.updatePassword(admin) > 0){
                    result.put("success",true);
                }
            }catch(Exception e){
                e.printStackTrace();
                result.put("success",false);
                result.put("msg","修改失败！服务端发生异常");
            }
        }
        //admin
        if(userType == 2){
            Student student = (Student) request.getSession().getAttribute("userInfo");
            if(!student.getPassword().equals(oldPassword)){
                result.put("success",false);
                result.put("msg","原始密码错误");
                return result;
            }
            //向数据库中存储新密码
            try{
                student.setPassword(newPassword);
                if(studentService.updatePassword(student) > 0){
                    result.put("success",true);
                }
            }catch(Exception e){
                e.printStackTrace();
                result.put("success",false);
                result.put("msg","修改失败！服务端发生异常");
            }
        }
        //admin
        if(userType == 3){
            Teacher techer = (Teacher) request.getSession().getAttribute("userInfo");
            if(!techer.getPassword().equals(oldPassword)){
                result.put("success",false);
                result.put("msg","原始密码错误");
                return result;
            }
            //向数据库中存储新密码
            try{
                techer.setPassword(newPassword);
                if(teacherService.updatePassword(techer) > 0){
                    result.put("success",true);
                }
            }catch(Exception e){
                e.printStackTrace();
                result.put("success",false);
                result.put("msg","修改失败！服务端发生异常");
            }
        }
        return result;
    }
}
