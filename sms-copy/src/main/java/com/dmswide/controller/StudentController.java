package com.dmswide.controller;

import com.dmswide.bean.Student;
import com.dmswide.service.ClazzService;
import com.dmswide.service.StudentService;
import com.dmswide.util.UploadFile;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.ibatis.logging.stdout.StdOutImpl;
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
@RequestMapping("/student")
public class StudentController {
    @Autowired
    private StudentService studentService;
    @Autowired
    private ClazzService clazzService;

    private Map<String,Object> result = new HashMap<>();

    /**
     * 跳转至学生信息管理页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/goStudentListView")
    public ModelAndView goStudentListView(ModelAndView modelAndView){
        //向studentList页面发送一个存储clazz的list
        modelAndView.addObject("clazzList",clazzService.selectAll());
        modelAndView.setViewName("student/studentList");
        return modelAndView;
    }

    /**
     * 分页查询学生信息列表：根据学生与班级信息查询指定学生或者全部学生信息列表
     * @return
     */
    @PostMapping("/getStudentList")
    @ResponseBody
    public Map<String,Object> getStudentList(@RequestParam(value = "page") Integer pageNum,
                                             @RequestParam(value = "rows") Integer pageSize,
                                             @RequestParam(value = "studentname",required = false)String studentName,
                                             @RequestParam(value = "clazzname",required = false)String clazzName){

        Student student = new Student(studentName,clazzName);
        PageHelper.startPage(pageNum,pageSize);
        List<Student> students = studentService.selectList(student);
        PageInfo<Student> studentPageInfo = new PageInfo<>(students);
        long total = studentPageInfo.getTotal();
        List<Student> studentList = studentPageInfo.getList();
        result.put("total",total);
        result.put("rows",studentList);
        return result;
    }

    /**
     * 添加学生信息
     * @param student
     * @return
     */
    @PostMapping("/addStudent")
    @ResponseBody
    public Map<String,Object> addStudent(Student student){
        //判断是否存在
        if(studentService.findBySno(student) != null){
            result.put("success",false);
            result.put("msg","学号已经存在！修改后重试");
            return result;
        }
        //添加学生信息
        if(studentService.insert(student) > 0){
            result.put("success",true);
        }else{
            result.put("success",false);
            result.put("msg","添加失败！服务端发生错误");
        }
        return result;
    }


    /**
     * 根据Id修改学生信息
     * @param student
     * @return
     */
    @PostMapping("/editStudent")
    @ResponseBody
    public Map<String,Object> editStudent(Student student){
        if(studentService.update(student) > 0){
            result.put("success",true);
        }else{
            result.put("success",false);
            result.put("msg","修改失败!服务器发生异常");
        }
        return result;
    }

    /**
     * 批量删除学生信息
     * @param ids
     * @return
     */
    @PostMapping("/deleteStudent")
    @ResponseBody
    public Map<String,Object> deleteStudent(@RequestParam(value = "ids[]") Integer[] ids){
        if(studentService.deleteById(ids) > 0){
            result.put("success",true);
        }else{
            result.put("success",false);
        }
        return result;
    }

    /**
     * 上传学生头像：本地头像上传至项目发布目录中 通过读取数据库中头像路径来获取头像
     * @param multipartFile
     * @param request
     * @return
     */
    @PostMapping("/uploadPhoto")
    @ResponseBody
    public Map<String,Object> uploadPhoto(@RequestParam(value = "photo") MultipartFile multipartFile,
                                          HttpServletRequest request){

        //存储头像本地目录
        final String dirPath = request.getServletContext().getRealPath("/upload/student_portrait/");
        //存储头像的发布目录
        final String portraitPath = request.getServletContext().getContextPath() + "/upload/student_portrait/";
        return UploadFile.getUploadResult(multipartFile,dirPath,portraitPath);
    }
}
