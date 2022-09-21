package com.dmswide.controller;

import com.dmswide.bean.Clazz;
import com.dmswide.service.ClazzService;
import com.dmswide.service.GradeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/clazz")
public class ClazzController {
    @Autowired
    private ClazzService clazzService;
    @Autowired
    private GradeService gradeService;
    private Map<String,Object> result = new HashMap<>();

    /**
     * 跳转到班级信息管理页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/goClazzListView")
    public ModelAndView goClazzListPage(ModelAndView modelAndView){
        //向页面发送一个存储Grade的List对象
        modelAndView.addObject("gradeList",gradeService.selectAll());
        modelAndView.setViewName("clazz/clazzList");
        return modelAndView;
    }

    /**
     * 分页查询班级信息列表 根据班级和年级查询指定班级或者全部班级信息
     * @param pageNum
     * @param pageSize
     * @param clazzName
     * @param gradeName
     * @return
     */
    @PostMapping("/getClazzList")
    @ResponseBody
    public Map<String,Object> getClazzList(Integer pageNum,Integer pageSize,String clazzName,String gradeName){
        //存储拆线呢的clazzName 和 gradeName信息
        Clazz clazz = new Clazz(clazzName,gradeName);
        //设置每页记录数
        PageHelper.startPage(pageNum,pageSize);
        //根据班级和年纪名获取指定或者全部班级信息
        List<Clazz> clazzes = clazzService.selectList(clazz);
        //PageInfo封装查询结果
        PageInfo<Clazz> clazzPageInfo = new PageInfo<>(clazzes);

        //获取记录数
        long total = clazzPageInfo.getTotal();
        //获取当前页数据列表
        List<Clazz> clazzList = clazzPageInfo.getList();

        result.put("total",total);
        result.put("rows",clazzList);
        return result;
    }

    /**
     * 添加班级
     * @param clazz
     * @return
     */
    @PostMapping("/addClazz")
    @ResponseBody
    public Map<String,Object> addClazz(Clazz clazz){
        Clazz name = clazzService.findByName(clazz.getName());
        if(name == null){
            if(clazzService.insert(clazz) > 0){
                result.put("success",true);
            }else{
                result.put("success",false);
                result.put("msg","添加失败，服务端错误");
            }
        }else{
            result.put("success",false);
            result.put("msg","班级名已经存在，修改后重试");
        }
        return result;
    }

    /**
     * 修改指定id的班级信息
     * @param clazz
     * @return
     */
    @PostMapping("/editClazz")
    @ResponseBody
    public Map<String,Object> editClazz(Clazz clazz){
        //防止重名
        Clazz clz = clazzService.findByName(clazz.getName());
        if(clz != null){
            if(!(clz.getId().equals(clazz.getId()))){
                result.put("success",false);
                result.put("msg","班级名称重复，修改后重试");
                return result;
            }
        }
        //修改
        if(clazzService.update(clazz) > 0){
            result.put("success",true);
        }else{
            result.put("success",false);
            result.put("msg","添加失败，服务器端出现错误");
        }
        return result;
    }

    /**
     * 删除班级
     * @return
     */
    @PostMapping("/deleteClazz")
    @ResponseBody
    public Map<String,Object> deleteClazz(@RequestParam(value = "ids[]")Integer[] ids){
        if(clazzService.deleteById(ids) > 0){
            result.put("success",true);
        }else{
            result.put("success",false);
        }
        return result;
    }
}
