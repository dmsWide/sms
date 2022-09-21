package com.dmswide.service;

import com.dmswide.bean.Clazz;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ClazzService {
    // TODO: 2022/9/12 dmsWide 根据班级名称获取获取指定/全部班级信息列表
    List<Clazz> selectList(Clazz clazz);

    // TODO: 2022/9/12 dmsWide 查询所有班级列表信息（用于在学生管理页面中获取全部班级信息）
    List<Clazz> selectAll();

    // TODO: 2022/9/12 dmsWide 查询指定班级名称的班级
    Clazz findByName(String name);

    // TODO: 2022/9/12 dmsWide 添加班级
    int insert(Clazz clazz);

    // TODO: 2022/9/12 dmsWide 删除班级
    int deleteById(@Param("ids") Integer[] ids);

    // TODO: 2022/9/12 dmsWide 根据Id修改指定班级的信息
    int update(Clazz clazz);
}

