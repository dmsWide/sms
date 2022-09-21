<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%--use EL-Expression --%>
<%@ page isELIgnored="false" %>
<%--use jstl--%>
<%--引入core文件 前缀是c--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/Xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
        <title>学生管理系统</title>
        <%--引入css--%>
        <link href="${pageContext.request.contextPath}/static/easyui/css/default.css" type="text/css" rel="stylesheet"/>
        <link href="${pageContext.request.contextPath}/static/easyui/themes/metro/easyui.css" type="text/css" rel="stylesheet"/>
        <link href="${pageContext.request.contextPath}/static/easyui/themes/icon.css" type="text/css" rel="stylesheet"/>
        <%--引入JS--%>
        <script src="${pageContext.request.contextPath}/static/easyui/jquery.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/static/easyui/jquery.easyui.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/static/easyui/js/outlook2.js"></script>

        <%--页面事件--%>
        <script type="text/javascript">
            $(function () {
                //推送窗口
                $.messager.show({
                    width: 360,
                    height: 50,
                    title: '推送',
                    msg:'这是设置的推送功能',
                    showSpeed: 1500,
                    timeout: 0,
                    showType: 'slide'
                });
            });

            //设置系统功能菜单览
            var _menus = {
                "menus":[
                    {
                        "menuid":"1",
                        "icon":"",
                        "menuname":"学生信息管理",
                        "menus":[
                            {
                                "munuid": "21",
                                "menuname": "学生列表",
                                "icon": "icon-student",
                                "url": "../student/goStudentListView"
                            }
                        ]
                    },
                    /*设置用户查看权限:仅管理员和教师可以查看教师列表*/
                    <c:if test="${userType == 1 || userType == 3}">
                    {
                        "menuid": "2",
                        "icon": "",
                        "menuname": "教师信息管理",
                        "menus": [
                            {
                                "munuid": "22",
                                "menuname": "教师列表",
                                "icon": "icon-teacher",
                                "url": "../teacher/goTeacherListView"
                            }
                        ]
                    },
                    </c:if>
                    /*jstl设置权限 仅管理员可以查看看年级 班级 管理员信息列表*/
                    <c:if test="${userType == 1}">
                    {
                        "menuid": "3",
                        "icon": "",
                        "menuname": "班级信息管理",
                        "menus": [
                            {
                                "munuid": "23",
                                "menuname": "班级列表",
                                "icon": "icon-class",
                                "url": "../clazz/goClazzListView"
                            }
                        ]
                    },
                    {
                        "menuid": "4",
                        "icon": "",
                        "menuname": "年级信息管理",
                        "menus": [
                            {
                                "munuid": "24",
                                "menuname": "年级列表",
                                "icon": "icon-grade",
                                "url": "../grade/goGradeListView"
                            }
                        ]
                    },
                    {
                        "menuid": "5",
                        "icon": "",
                        "menuname": "管理员用户信息",
                        "menus": [
                            {
                                "munuid": "25",
                                "menuname": "管理员列表",
                                "icon": "icon-admin",
                                "url": "../admin/goAdminListView"
                            }
                        ]
                    },
                    </c:if>
                    {
                        "menuid": "6",
                        "icon": "",
                        "menuname": "个人信息管理",
                        "menus": [
                            {
                                "munuid": "26",
                                "menuname": "修改列表",
                                "icon": "icon-settings",
                                "url": "../common/goSettingView"
                            }
                        ]
                    }
                ]
            };
        </script>
    </head>

    <body class="easyui-layout" style="overflow-y: hidden" scroll="no">

        <%--页面顶部--%>
        <div region="north" split="true" border="false" style="overflow: hidden;height: 30px; line-height: 20px;color: #fff;font-family: Verdana,微软雅黑,黑体,'Lucida Console',serif">
            <span style="float:right;padding-right: 20px;" class=""head>
                <span style="color: blue;" class="easyui-linkbutton" data-options="iconCls:'icon-user',plain:true">
                    <%--获取用户类型--%>
                    <c:choose>
                        <c:when test="${userType == 1}">管理员:</c:when>
                        <c:when test="${userType == 2}">学生:</c:when>
                        <c:when test="${userType == 3}">教师:</c:when>
                    </c:choose>
                </span>
                <%--从session中获取登录用户的用户名--%>
                <span style="color: red;font-weight: bold;">${userInfo.name}</span>
                <a id = "logout" href="logout" style="color: darkgray;" class="easyui-linkbutton" data-options="iconCls:'icon-exit',plain:true">
                    [安全退出]
                </a>
            </span>
            <span style="padding-left: 10px;font-size: 20px;color: darkgray;font-weight: bold">学生信息管理系统</span>
        </div>

        <%--页面底部--%>
        <div region="south" split=""true style="height: 30px;">
            <div class="footer"></div>
        </div>

        <%--导航栏菜单--%>
        <div id = "west" region="west" hide="true" split="true" title="[ 导航菜单 ]" style="width: 180px">
            <%--引入手风琴样式图标--%>
            <div id="nav" class="easyui-accordion" fit="true">

            </div>
        </div>

        <%--引入欢迎页面--%>
        <div id="mainPanel" region="center" style="background: #eee;overflow-y: hidden">
            <%--引入欢迎页面的tab--%>
            <div id="tabs" class="easyui-tabs" fit="true">
                <jsp:include page="/WEB-INF/view/system/intro.jsp"/>
            </div>
        </div>
    </body>
</html>
