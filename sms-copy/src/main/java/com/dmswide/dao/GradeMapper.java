package com.dmswide.dao;

import com.dmswide.bean.Grade;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface GradeMapper {
    // TODO: 2022/9/13 dmsWide 根据年级名称查询指定/全部年级信息列表
    List<Grade> selectList(Grade gradeName);

    // TODO: 2022/9/13 dmsWide 查询所有年级信息
    List<Grade> selectAll();

    // TODO: 2022/9/13 dmsWide 根据名字查年级信息
    Grade findByName(String gradeName);

    // TODO: 2022/9/13 dmsWide 添加年级信息
    int insert(Grade grade);

    // TODO: 2022/9/13 dmsWide 更新年级信息
    int update(Grade grade);

    // TODO: 2022/9/13 dmsWide 根据Id删除批量删除年级信息
    int deleteById(@Param("ids") Integer[] ids);
}
