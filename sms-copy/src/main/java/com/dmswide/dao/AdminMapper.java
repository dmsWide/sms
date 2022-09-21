package com.dmswide.dao;

import com.dmswide.bean.Admin;
import com.dmswide.bean.LoginForm;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface AdminMapper {
    // TODO: 2022/9/13 dmsWide 验证登录信息
    Admin login(LoginForm loginForm);

    // TODO: 2022/9/13 dmsWide 通过姓名查询管理员
    Admin findByName(String name);

    // TODO: 2022/9/13 dmsWide 添加管理员
    int insert(Admin admin);

    // TODO: 2022/9/13 dmsWide 通过姓名查询管理员
    List<Admin> selectList(Admin admin);

    // TODO: 2022/9/13 dmsWide 根据Id更新指定的管理员
    int update(Admin admin);

    // TODO: 2022/9/13 dmsWide 修改密码
    int updatePassword(Admin admin);

    // TODO: 2022/9/13 dmsWide 根据id批量删除管理员
    int deleteById(@Param("ids") Integer[] ids);
}
