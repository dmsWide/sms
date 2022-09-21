package com.dmswide.controller;

import com.dmswide.bean.Grade;
import com.dmswide.service.GradeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequestMapping("/grade")
public class GradeController {
    @Autowired
    private GradeService gradeService;

    private Map<String,Object> result = new HashMap<>();

    /**
     * 跳转到年级信息管理页面
     * @return
     */
    @GetMapping("/goGradeListView")
    public String goGradeListPage(){
        return "grade/gradeList";
    }

    /**
     * 分页查询根据年纪名称获取指定或者所有年级信息
     * @param pageNum
     * @param pageSize
     * @param gradeName
     * @return
     */
    @PostMapping("/getGradeList")
    @ResponseBody
    public Map<String,Object> getGradeList(Integer pageNum,Integer pageSize,String gradeName){
        Grade grade = new Grade();
        grade.setName(gradeName);
        //设置每页记录数
        PageHelper.startPage(pageNum,pageSize);
        //根据年纪名查询指定或者全部年级信息
        List<Grade> grades = gradeService.selectList(grade);
        PageInfo<Grade> gradePageInfo = new PageInfo<>(grades);
        long total = gradePageInfo.getTotal();
        List<Grade> gradeList = gradePageInfo.getList();
        result.put("total",total);
        result.put("rows",gradeList);
        return result;
    }

    /**
     * 添加年级
     * @param grade
     * @return
     */
    @PostMapping("/addGrade")
    @ResponseBody
    public Map<String,Object> addGrade(Grade grade){
        //判断是否存在
        Grade name = gradeService.findByName(grade.getName());
        if(name == null){
            if(gradeService.insert(grade) > 0){
                result.put("success",true);
            }else{
                result.put("success",false);
                result.put("msg","添加失败！服务器端发生异常！");
            }
        }else{
            result.put("success",false);
            result.put("msg","年纪名重复了，请修改后重试！");
        }
        return result;
    }

    /**
     * 根据Id更新年级信息
     * @param grade
     * @return
     */
    @PostMapping("/editGrade")
    @ResponseBody
    public Map<String,Object> editGrade(Grade grade){
        Grade name = gradeService.findByName(grade.getName());
        if(name != null){
            if(!(name.getId()).equals(grade.getId())){
                result.put("success",false);
                result.put("msg","修改失败！该年级名称已经存在修改后重试");
                return result;
            }
        }
        //编辑
        if(gradeService.update(grade) > 0){
            result.put("success",true);
        }else{
            result.put("msg","服务端发生错误");
        }
        return result;
    }

    @PostMapping("/deleteGrade")
    @ResponseBody
    public Map<String,Object> deleteGrade(@RequestParam(value = "ids[]",required = true) Integer[] ids){
        if(gradeService.deleteById(ids) > 0){
            result.put("success",true);
        }else{
            result.put("success",false);
        }
        return result;
    }

}
