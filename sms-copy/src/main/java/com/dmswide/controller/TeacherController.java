package com.dmswide.controller;

import com.dmswide.bean.Teacher;
import com.dmswide.service.ClazzService;
import com.dmswide.service.TeacherService;
import com.dmswide.util.UploadFile;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/teacher")
public class TeacherController {
    @Autowired
    private ClazzService clazzService;
    @Autowired
    private TeacherService teacherService;

    private Map<String,Object> result = new HashMap<>();

    @GetMapping("/goTeacherListView")
    public ModelAndView goTeacherListView(ModelAndView modelAndView){
        //向网页中传一个存储clazz的list
        modelAndView.addObject("clazzList",clazzService.selectAll());
        modelAndView.setViewName("teacher/teacherList");
        return modelAndView;
    }

    /**
     * 分页查询学生信息列表：根据老师名和班级名查询指定/全部老师信息列表
     * @param pageNum
     * @param pageSize
     * @param teacherName
     * @param clazzName
     * @return
     */
    @PostMapping("/getTeacherList")
    @ResponseBody
    public Map<String,Object> getTeacherList(@RequestParam(value = "page") Integer pageNum,
                                             @RequestParam(value = "rows") Integer pageSize,
                                             @RequestParam(value = "teachername",required = false) String teacherName,
                                             @RequestParam(value = "clazzname",required = false) String clazzName){

        Teacher teacher = new Teacher(teacherName, clazzName);
        PageHelper.startPage(pageNum,pageSize);
        //查询全部老师信息
        List<Teacher> teachers = teacherService.selectList(teacher);
        //封装teacher信息
        PageInfo<Teacher> teacherPageInfo = new PageInfo<>(teachers);

        long total = teacherPageInfo.getTotal();
        List<Teacher> teacherList = teacherPageInfo.getList();

        result.put("total",total);
        result.put("rows",teacherList);

        return result;
    }

    @PostMapping("/addTeacher")
    @ResponseBody
    public Map<String,Object> addTeacher(Teacher teacher){
        //判断工号是否已经存在
        if(teacherService.findByTno(teacher) != null){
            result.put("success",false);
            result.put("msg","添加失败！工号已经存在！请修改后重试");
            return result;
        }
        //添加
        System.out.println("****" + teacher);
        if(teacherService.insert(teacher) > 0){
            result.put("success",true);
        }else{
            result.put("success",false);
            result.put("msg","添加失败！服务端出错！");
        }
        return result;
    }

    /**
     * 根据id修改指定老师信息
     * @param teacher
     * @return
     */
    @PostMapping("/editTeacher")
    @ResponseBody
    public Map<String,Object> editTeacher(Teacher teacher){
        System.out.println("++++" + teacher);
        if(teacherService.update(teacher) > 0){
            result.put("success",true);
        }else{
            result.put("success",false);
            result.put("msg","修改失败！服务端发生异常");
        }
        return result;
    }

    /**
     * 根据Id数组 批量删除老师
     * @param ids
     * @return
     */
    @PostMapping("/deleteTeacher")
    @ResponseBody
    public Map<String,Object> deleteTeacher(@RequestParam(value = "ids[]",required = true) Integer[] ids){
        System.out.println("正在删除老师");
        if(teacherService.deleteById(ids) > 0){
            result.put("success",true);
        }else{
            result.put("success",false);
            result.put("msg","删除失败！服务端发生异常");
        }
        return result;
    }

    @PostMapping("/uploadPhoto")
    @ResponseBody
    public Map<String,Object> uploadPhoto(@RequestParam(value = "photo") MultipartFile multipartFile,
                                          HttpServletRequest request){

        //存储头像的本地目录
        final String dirPath = request.getServletContext().getRealPath("/upload/teacher_portrait/");
        final String portraitPath = request.getServletContext().getContextPath() + "/upload/teacher_portrait/";
        return UploadFile.getUploadResult(multipartFile,dirPath,portraitPath);
    }
}
