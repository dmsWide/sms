<%--
  Created by IntelliJ IDEA.
  User: dmsWide
  Date: 2022/9/14
  Time: 22:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="utf-8" %>
<%--use el expression--%>
<%@ page isELIgnored="false" %>
<%--use jstl--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta charset = "UTF-8" content="#">
        <title>教师信息管理里页面</title>
        <%--引入css--%>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/easyui/css/demo.css">

        <%--引入js--%>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/easyui/jquery.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/easyui/jquery.easyui.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/easyui/themes/locale/easyui-lang-zh_CN.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/easyui/js/validateExtends.js"></script>

        <script type="text/javascript">
            /*回调函数*/
            $(function () {
                var table;
                $("#dataList").datagrid({
                    iconCls: 'icon-more',
                    border: true,
                    collapsible:false,
                    fit:true,
                    method:"post",
                    url:"getTeacherList?t=" + new Date().getTime(),
                    idField: 'id',
                    singleSelect:false,/*取消单选*/
                    rownumbers:true,
                    pagination:true,
                    sortName:'id',
                    sortOrder:'DESC',
                    remoteSort: false,
                    columns:[[
                        {field:'chk',checkbox:true,width:50},
                        {field:'id',title:'ID',width:50,sortable:true},
                        {field:'clazzName',title:'任课班级',width:150},
                        {field:'name',title:'姓名',width:150},
                        {field:'tno',title:'工号',width:150},
                        {field:'gender',title:'性别',width:50},
                        {field:'email',title:'邮箱',width:150},
                        {field:'telephone',title:'电话',width:150},
                        {field:'address',title:'住址',width:150}
                    ]],
                    toolbar:"#toolbar"
                });

                /*分页控件*/
                var p = $("#dataList").datagrid("getPager");
                $(p).pagination({
                    pagination: 10,
                    pageSize:[10,20,30,50,100],
                    beforePageText:'第',
                    afterPageText:'页    共{pages}页',
                    displayMsg:'当前显示{from} - {to}条记录 共{total}条记录',
                });

                /*信息添加按钮事件*/
                $("#add").click(function () {
                    table = $("#addTable");
                    $("#addTable").form("clear");
                    $("#add-portrait").attr("src","${pageContext.request.contextPath}/image/portrait/default_teacher_portrait.png");
                    $("#addDialog").dialog("open");
                });

                /*信息修改按钮事件*/
                $("#edit").click(function () {
                    table = $("#editTable");
                    var selectRows = $("#dataList").datagrid("getSelections");
                    if(selectRows.length !== 1){
                        $.messager.alert("消息提醒","请选择单挑数据","warning");
                    }else{
                        $("#editDialog").dialog("open");
                    }
                });

                /*信息删除按钮事件*/
                $("#delete").click(function () {
                    /*返回所有选中的行 或者返回空*/
                    var selectRows = $("#dataList").datagrid("getSelections");
                    var selectLength = selectRows.length;
                    if(selectLength === 0){
                        $.messager.alert("消息提醒","请选择想要删除的数据","warning");
                    }else{
                        var ids = [];
                        $(selectRows).each(function (i,row) {
                            ids[i] = row.id;
                        });
                        $.messager.confirm("消息提醒","删除后无法恢复！确定继续？",function (r) {
                            if(r){
                                $.ajax({
                                    type: "post",
                                    url:"deleteTeacher?t=" + new Date().getTime(),
                                    data:{ids:ids},
                                    dataType:'json',
                                    success: function (data) {
                                        if(data.success){
                                            $.messager.alert("消息提醒","成功删除","info");
                                            $("#dataList").datagrid("reload");
                                            $("#dataList").datagrid("uncheckAll");
                                        }else{
                                            $.messager.alert("消息提醒","服务器端发生异常!删除失败","warning");
                                        }
                                    }
                                });
                            }
                        });
                    }
                });

                /*设置添加教师信息窗口*/
                $("#addDialog").dialog({
                    title:"添加教师信息窗口",
                    width:660,
                    height:470,
                    iconCls: "icon-house",
                    modal:true,
                    collapsedSize:false,
                    minimizable:false,
                    maximizable:false,
                    draggable:true,
                    closed:true,
                    buttons:[
                        {
                            text:"添加",
                            plain: true,
                            iconCls:"icon-add",
                            handler:function () {
                                var validate = $("#addForm").form("validate");
                                if(!validate){
                                    $.messager.alert("消息提醒","请检查输入的数据","warning");
                                }else{
                                    /*发送数据接收响应*/
                                    var data = $("#addForm").serialize();
                                    $.ajax({
                                        type: "post",
                                        url: "addTeacher?t=" + new Date().getTime(),
                                        data:data,
                                        dataType: "json",
                                        success:function(data){
                                            if(data.success){
                                                $("#addDialog").dialog("close");
                                                $("#dataList").datagrid("reload");
                                                $.messager.alert("提醒消息","成功添加教师信息","info");
                                            }else{
                                                $.messager.alert("提醒消息",data.msg,"warning");
                                            }
                                        }
                                    });
                                }
                            }
                        },
                        {
                            text:"重置",
                            plain:true,
                            iconCls: "icon-reload",
                            handler: function () {
                                $("#add_address").textbox("setValue","");
                                $("#add_telephone").textbox("setValue","");
                                $("#add_email").textbox("setValue","");
                                $("#add_password").textbox("setValue","");
                                $("#add_tno").textbox("setValue","");
                                $("#add_gender").textbox("setValue","男");
                                $("#add_name").textbox("setValue","");
                            }
                        }
                    ]
                });

                /*设置修改教师信息窗口*/
                $("#editDialog").dialog({
                    title:"修改教师信息窗口",
                    width:660,
                    height:470,
                    iconCls: "icon-house",
                    modal:true,
                    collapsedSize:false,
                    minimizable:false,
                    maximizable:false,
                    draggable:true,
                    closed:true,
                    buttons:[
                        {
                            text:"提交",
                            plain: true,
                            iconCls:"icon-edit",
                            handler:function () {
                                var validate = $("#editForm").form("validate");
                                if(!validate){
                                    $.messager.alert("消息提醒","请检查输入的数据","warning");
                                }else{
                                    /*发送数据接收响应*/
                                    /*序列化表单数据*/
                                    var data = $("#editForm").serialize();
                                    $.ajax({
                                        type: "post",
                                        url: "editTeacher?t=" + new Date().getTime(),
                                        data:data,
                                        dataType: "json",
                                        success:function(data){
                                            if(data.success){
                                                $("#editDialog").dialog("close");
                                                $("#dataList").datagrid("reload");
                                                $("#dataList").datagrid("uncheckAll");
                                                $.messager.alert("提醒消息","成功修改教师信息","info");
                                            }else{
                                                $.messager.alert("提醒消息",data.msg,"warning");
                                            }
                                        }
                                    });
                                }
                            }
                        },
                        {
                            text:"重置",
                            plain:true,
                            iconCls: "icon-reload",
                            handler: function () {
                                $("#edit_address").textbox("setValue","");
                                $("#edit_telephone").textbox("setValue","");
                                $("#edit_email").textbox("setValue","");
                                $("#edit_password").textbox("setValue","");
                                $("#edit_gender").textbox("setValue","男");
                                $("#edit_name").textbox("setValue","");
                            }
                        }
                    ],
                    /*打开修改信息窗口之前初始化表单数据*/
                    onBeforeOpen:function () {
                        var selectRow = $("#dataList").datagrid("getSelected");
                        /*后端数据进行初始化*/
                        $("#edit_id").val(selectRow.id);
                        $("#edit_tno").textbox("setValue",selectRow.tno);
                        $("#edit_clazz_name").textbox("setValue",selectRow.clazzName);
                        $("#edit_name").textbox("setValue",selectRow.name);
                        $("#edit_gender").textbox("setValue",selectRow.gender);
                        $("#edit_password").textbox("setValue",selectRow.password);
                        $("#edit_email").textbox("setValue",selectRow.email);
                        $("#edit_telephone").textbox("setValue",selectRow.telephone);
                        $("#edit_address").textbox("setValue",selectRow.address);
                        $("#edit-portrait").attr("src",selectRow.portraitPath);
                    }
                });

                /*搜索教师按钮*/
                $("#search-btn").click(function(){
                    $("#dataList").datagrid("load",{
                        teachername:$("#search-teachername").val(),
                        clazzname:$("#search-clazzname").combobox("getValue")
                    });
                });

                /*添加信息窗口种上传头像的按钮事件*/
                $("#add-upload-btn").click(function () {
                    if($("#add-choose-portrait").filebox("getValue") === ''){
                        $.messager.alert("提示","请选择图片!","warning");
                        return;
                    }
                    $("#add-uploadForm").submit();
                });

                /*修改信息窗口中上传头像按钮事件*/
                $("#edit-upload-btn").click(function () {
                    if($("#edit-choose-portrait").filebox("getValue") === ''){
                        $.messager.alert("提示信息","请选择图片","warning");
                        return;
                    }
                    $("#edit-uploadForm").submit();
                });
            });

            /*上传头像按钮事件*/
            function uploaded() {
                var data = $(window.frames["photo_target"].document).find("body pre").text();
                data = JSON.parse(data);
                if(data.success){
                    $.messager.alert("提示信息","图片上传成功","info");
                    /*alert(data.portraitPath);*/
                    $("#add-portrait").attr("src",data.portraitPath);
                    $("#edit-portrait").attr("src",data.portraitPath);
                    $("#add_portrait-path").val(data.portraitPath);
                    $("#edit_portrait-path").val(data.portraitPath);
                }else{
                    $.messager.alert("提示信息",data.msg,"warning");
                }
            }

        </script>
    </head>
    <body>
        <%--教师信息列表--%>
        <table id="dataList" cellspacing="0" cellpadding="0"></table>
        <%--工具栏--%>
        <div id = "toolbar">
            <div style="float: left;">
                <a id="add" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">
                    添加
                </a>
            </div>
            <%--jstl设置用户操作权限--%>
            <c:if test="${userType == 1}">
                <div style="float: left;">
                    <a id="edit" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">
                        修改
                    </a>
                </div>
                <div style="float: left;" class="datagrid-btn-separator"></div>
                <div style="float: left;">
                    <a id="delete" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">
                        删除
                    </a>
                </div>
            </c:if>
            <%--教师 班级名搜索域--%>
            <div style="margin-left: 10px;">
                <div style="float: left;" class="datagrid-btn-separator"></div>
                <%--班级名称下拉框--%>
                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-class',plain:true">
                    班级名称
                </a>
                <select id="search-clazzname" name = "clazzname" style="width: 155px;" class="easyui-combobox" >
                    <%--jstl遍历显示年级信息 clazzList为controller传递过来的存在clazz的List--%>
                    <option value="">未选择班级</option>
                    <c:forEach items="${clazzList}" var="clazz">
                        <option value="${clazz.name}">${clazz.name}</option>
                    </c:forEach>
                </select>
                <%--教师名搜索域--%>
                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-user-teacher',plain:true">
                    教师姓名
                </a>
                <input id="search-teachername" name = "teachertname" class="easyui-textbox"/>
                <%--搜索按钮--%>
                <a id="search-btn" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">
                    搜索
                </a>
            </div>
        </div>

        <%--添加信息窗口--%>
        <div id="addDialog" style="padding: 15px 0 0 55px;">
            <%--设置添加头像功能 上右下左--%>
            <div id="add-photo" style="float: right;margin: 15px 40px 0 0;width: 250px;border:1px solid #EEF4FF">
                <img id="add-portrait" alt="照片" style="max-width: 250px;max-height: 300px;" title="照片"
                     src="${pageContext.request.contextPath}/image/portrait/default_teacher_portrait.png"/>
                <%--头像信息表单--%>
                <form id="add-uploadForm" method="post" enctype="multipart/form-data" action="uploadPhoto" target="photo_target">
                    <input id="add-choose-portrait" name="photo" class="easyui-filebox" data-options="prompt:'选择照片'" style="width:200px"/>
                    <input id="add-upload-btn" type="button" value="上传" class="easyui-linkbutton" style="width: 50px;height: 24px;float: right;">
                </form>
            </div>
            <%--教师信息列表--%>
            <form id="addForm" method="post" action="#">
                <table id="addTable" style="border-collapse: separate;border-spacing: 0 3px;" cellpadding="6">
                    <%--存储头像上传路径--%>
                    <input id="add_portrait-path" name="portraitPath" type="hidden"/>
                    <tr>
                        <td>班级</td>
                        <td colspan="1">
                            <select id="add_clazz_name" name = "clazzName" style="width: 200px;height: 30px;" class="easyui-combobox"
                                    data-options="required:true,missingMessage:'请选择所属班级'">
                                <c:forEach items="${clazzList}" var="clazz">
                                    <option value="${clazz.name}">${clazz.name}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>姓名</td>
                        <td colspan="1">
                            <input id="add_name" name="name" type="text" style="width: 200px;height: 30px;" class="easyui-textbox"
                                    data-options="required:true,missingMessage:'请填写姓名'"/>
                        </td>
                    </tr>
                    <tr>
                        <td>性别</td>
                        <td>
                            <select id="add_gender" name="gender" class="easyui-combobox"
                                    data-options="editable:false,panelHeight:50,width:60,height :30,required:true,missingMessage:'请选择性别'">
                                <option value="男">男</option>
                                <option value="女">女</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>工号</td>
                        <td colspan="1">
                            <input id="add_tno" name="tno" type="text" style="width: 200px;height: 30px;" class="easyui-textbox"
                                    data-options="required:true,missingMessage:'请填写工号'"/>
                        </td>
                    </tr>
                    <tr>
                        <td>密码</td>
                        <td colspan="1">
                            <input id="add_password" name="password" type="password" style="width: 200px;height: 30px;" class="easyui-textbox"
                                    data-options="required:true,missingMessage:'请填写密码'"/>
                        </td>
                    </tr>
                    <tr>
                        <td>邮箱</td>
                        <td colspan="1">
                            <input id="add_email" name="email" type="text" style="width: 200px;height: 30px;" class="easyui-textbox"
                                    validType="email" data-options="required:true,missingMessage:'请填写邮箱'"/>
                        </td>
                    </tr>
                    <tr>
                        <td>电话</td>
                        <td colspan="4">
                            <input id="add_telephone" name="telephone" type="text" style="width: 200px;height: 30px;" class="easyui-textbox"
                                    validType="mobile" data-options="required:true,missingMessage:'请填写电话'"/>
                        </td>
                    </tr>
                    <tr>
                        <td>住址</td>
                        <td colspan="1">
                            <input id="add_address" name="address" type="text" style="width: 200px;height: 30px;" class="easyui-textbox"
                                    data-options="required:true,missingMessage:'请填写家庭住址'"/>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <%--修改信息窗口--%>
        <div id="editDialog" style="padding: 20px 0 0 65px">
            <%--设置修改头像功能--%>
            <div id = "edit-photo" style="float: right;margin:15px 40px 0 0;width: 250px;border: 1px solid #EEF4FF">
               <img id = "edit-portrait" alt="照片" style="max-width: 250px;max-height: 300px;" title="照片"
                    src="${pageContext.request.contextPath}/image/portrait/default_teacher_portrait.png"/>
                <%--头像信息表单--%>
                <form id="edit-uploadForm" method="post" enctype="multipart/form-data" action="uploadPhoto" target="photo_target">
                    <input id="edit-choose-portrait" name="photo" class="easyui-filebox" data-options="prompt:'请选择照片'" style="width: 200px;"/>
                    <input id="edit-upload-btn" class="easyui-linkbutton" style="width: 50px;height: 24px;float:right;" type="button" value="上传">
                </form>
            </div>
            <%--教师信息表单--%>
            <form id="editForm" method="post" action="#">
                <%--获取被修改信息的教师Id--%>
                <input id="edit_id" name="id" type="hidden"/>
                <table id="editTable" style="border-collapse: separate;border-spacing: 0 3px;" cellpadding="6">
                    <%--存储头像上传路径--%>
                    <input id="edit_portrait-path" name="portraitPath" type="hidden"/>
                    <tr>
                        <td>班级</td>
                        <td colspan="1">
                            <select id="edit_clazz_name" name = "clazzName" style="width: 200px;height: 30px;" class="easyui-combobox"
                                    data-options="required:true,missingMessage:'请选择所属班级'">
                                <c:forEach items="${clazzList}" var="clazz">
                                    <option value="${clazz.name}">${clazz.name}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>姓名</td>
                        <td colspan="1">
                            <input id="edit_name" name="name" type="text" style="width: 200px;height: 30px;" class="easyui-textbox"
                                    data-options="required:true,missingMessage:'请填写姓名'"/>
                        </td>
                    </tr>
                    <tr>
                        <td>性别</td>
                        <td>
                            <select id="edit_gender" name="gender" class="easyui-combobox"
                                    data-options="editable:false,panelHeight:50,width:60,height :30,required:true,missingMessage:'请选择性别'">
                                <option value="男">男</option>
                                <option value="女">女</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>工号</td>
                        <td colspan="1">
                            <%--设为只读--%>
                            <input id="edit_tno" type="text" style="width: 200px;height: 30px;" class="easyui-textbox"
                                    data-options="readonly:true"/>
                        </td>
                    </tr>
                    <tr>
                        <td>邮箱</td>
                        <td colspan="1">
                            <input id="edit_email" name="email" type="text" style="width: 200px;height: 30px;" class="easyui-textbox"
                                    validType="email" data-options="required:true,missingMessage:'请填写邮箱'"/>
                        </td>
                    </tr>
                    <tr>
                        <td>电话</td>
                        <td colspan="4">
                            <input id="edit_telephone" name="telephone" type="text" style="width: 200px;height: 30px;" class="easyui-textbox"
                                    validType="mobile" data-options="required:true,missingMessage:'请填写电话'"/>
                        </td>
                    </tr>
                    <tr>
                        <td>住址</td>
                        <td colspan="1">
                            <input id="edit_address" name="address" type="text" style="width: 200px;height: 30px;" class="easyui-textbox"
                                    data-options="required:true,missingMessage:'请填写家庭住址'"/>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <%--表单处理--%>
        <iframe id="photo_target" name="photo_target" onload="uploaded(this)"></iframe>
    </body>
</html>
