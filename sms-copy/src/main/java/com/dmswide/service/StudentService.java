package com.dmswide.service;

import com.dmswide.bean.LoginForm;
import com.dmswide.bean.Student;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface StudentService {
    // TODO: 2022/9/13 dmsWide 验证学生登录信息
    Student login(LoginForm loginForm);

    // TODO: 2022/9/13 dmsWide 根据班级和学生名获取指定/全部学生信息
    List<Student> selectList(Student student);

    // TODO: 2022/9/13 dmsWide 根据学号查询指定的学生信息
    Student findBySno(Student student);

    // TODO: 2022/9/13 dmsWide 添加学生信息
    int insert(Student student);

    // TODO: 2022/9/13 dmsWide 根据id修改指定学生信息
    int update(Student student);

    // TODO: 2022/9/13 dmsWide 根据id修改学生密码
    int updatePassword(Student student);

    // TODO: 2022/9/13 dmsWide 根据id批量删除
    int deleteById(@Param("ids") Integer[] ids);
}

