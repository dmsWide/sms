package com.dmswide.controller;

import com.dmswide.bean.Admin;
import com.dmswide.bean.LoginForm;
import com.dmswide.bean.Student;
import com.dmswide.bean.Teacher;
import com.dmswide.service.AdminService;
import com.dmswide.service.StudentService;
import com.dmswide.service.TeacherService;
import com.dmswide.util.CreateVerificationCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/system")
public class SystemController {
    @Autowired
    private AdminService adminService;
    @Autowired
    private TeacherService teacherService;
    @Autowired
    private StudentService studentService;

    //返回值表示
    private Map<String,Object> result = new HashMap<>();

    /**
     * 跳转到登录页面
     * @return
     */
    @GetMapping("/goLogin")
    public String goLogin(){
        return "system/login";
    }

    /**
     * 获取并显示验证码
     * @param request
     * @param response
     */
    @GetMapping("/getVerificationCodeImage")
    public void getVerificationCodeImage(HttpServletRequest request, HttpServletResponse response){
        BufferedImage verificationCodeImage = CreateVerificationCode.generateVerificationCodeImage();
        //随机生成的验证码字符
        String verificationCode = String.valueOf(CreateVerificationCode.getVerificationCode());
        //验证码图片输出到登录页面
        try{
            ImageIO.write(verificationCodeImage,"JPEG",response.getOutputStream());
        }catch(IOException e){
            e.printStackTrace();
        }
        //将验证码字符数组存到session中
        request.getSession().setAttribute("verificationCode",verificationCode);
    }

    /**
     * 验证用户登录信息
     * @param loginForm
     * @param request
     * @returni
     */
    @PostMapping("/login")
    @ResponseBody
   public Map<String,Object> login(LoginForm loginForm,HttpServletRequest request){
        String code = (String)request.getSession().getAttribute("verificationCode");
        if("".equals(code)){
            result.put("success",false);
            result.put("msg","长时间未操作，会话失效，请刷新页面重试");
            return result;
        }else if(!loginForm.getVerificationCode().equalsIgnoreCase(code)){
            result.put("success",false);
            result.put("msg","验证码错误！");
            return result;
        }
        request.getSession().removeAttribute("verificationCode");

        //验证用户的类型
        switch (loginForm.getUserType()){
            //admin
            case 1:
                try{
                    Admin admin = adminService.login(loginForm);
                    if(admin != null){
                        HttpSession session = request.getSession();
                        session.setAttribute("userInfo",admin);
                        session.setAttribute("userType",loginForm.getUserType());
                        result.put("success",true);
                        return result;
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    result.put("success",false);
                    result.put("msg","登录失败！服务端发生异常");
                    return result;
                }
                break;
            //student
            case 2:
                try{
                    Student student = studentService.login(loginForm);
                    if(student != null){
                        HttpSession session = request.getSession();
                        session.setAttribute("userInfo",student);
                        session.setAttribute("userType",loginForm.getUserType());
                        result.put("success",true);
                        return result;
                    }
                }catch(Exception e){
                    e.printStackTrace();
                    result.put("success",false);
                    result.put("msg","登录失败！服务端发生异常");
                    return result;
                }
                break;
            //teacher
            case 3:
                try{
                    Teacher teacher = teacherService.login(loginForm);
                    if(teacher != null){
                        HttpSession session = request.getSession();
                        session.setAttribute("userInfo",teacher);
                        session.setAttribute("userType",loginForm.getUserType());
                        result.put("success",true);
                        return result;
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    result.put("success",false);
                    result.put("msg","登陆失败！服务器端发生异常！");
                    return result;
                }
                break;
        }
        //登录失败
        result.put("success",false);
        result.put("msg","用户名或者密码错误，请仔细查验");
        return result;
   }

    /**
     * 跳转系统主界面
     * @return
     */
   @GetMapping("/goSystemMainView")
   public String goSystemMainView(){
       return "system/main";
   }

   @GetMapping("/logout")
   public void logout(HttpServletRequest request,HttpServletResponse response){
       //删除session中的用户信息和类型（关于用户的数据） + 重定向到index.jsp进行登录
       request.getSession().removeAttribute("userInfo");
        request.getSession().removeAttribute("userType");

        //退出系统后到登录界面
       try{
           response.sendRedirect("../index.jsp");
       }catch (Exception e){
           e.printStackTrace();
       }
   }
}
