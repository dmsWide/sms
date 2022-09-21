package com.dmswide.dao;

import com.dmswide.bean.LoginForm;
import com.dmswide.bean.Student;
import com.dmswide.bean.Teacher;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TeacherMapper {
    // TODO: 2022/9/13 dmsWide 验证老师登录信息
    Teacher login(LoginForm loginForm);

    // TODO: 2022/9/13 dmsWide 根据班级和老师名获取指定/全部老师信息
    List<Teacher> selectList(Teacher teacher);

    // TODO: 2022/9/13 dmsWide 根据工号查询指定的老师信息
    Teacher findByTno(Teacher teacher);

    // TODO: 2022/9/13 dmsWide 添加老师信息
    int insert(Teacher teacher);

    // TODO: 2022/9/13 dmsWide 根据id修改指定老师信息
    int update(Teacher teacher);

    // TODO: 2022/9/13 dmsWide 根据id修改指定老师密码
    int updatePassword(Teacher teacher);

    // TODO: 2022/9/13 dmsWide 根据id批量删除
    int deleteById(@Param("ids") Integer[] ids);
}
