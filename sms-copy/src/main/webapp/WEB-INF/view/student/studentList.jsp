<%--
  Created by IntelliJ IDEA.
  User: dmsWide
  Date: 2022/9/14
  Time: 20:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%--use EL-Expression--%>
<%@ page isELIgnored="false" %>
<%--use JSTL--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta charset="UTF-8" content="#">
        <title>学生信息管理页面</title>

        <%--引入css--%>
        <link href="${pageContext.request.contextPath}/static/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css">
        <link href="${pageContext.request.contextPath}/static/easyui/themes/icon.css" rel="stylesheet" type="text/css">
        <link href="${pageContext.request.contextPath}/static/easyui/css/demo.css" rel="stylesheet" type="text/css">

        <%--引入js--%>
        <script src="${pageContext.request.contextPath}/static/easyui/jquery.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/static/easyui/jquery.easyui.min.js" type="text/javascript"></script>

        <script src="${pageContext.request.contextPath}/static/easyui/themes/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/static/easyui/js/validateExtends.js" type="text/javascript"></script>

        <script type="text/javascript">
            //页面加载完成执行的函数
            $(function(){
                var table;
                //初始化datagrid
                $('#dataList').datagrid({
                    iconCls:'icon-more',//竖着的三个点组成的icon
                    border:true,
                    collapsible: false,//是否可折叠设置为false
                    fit: true,//自动大小
                    method: "post",
                    url: "getStudentList?t=" + new Date().getTime(),
                    idField:'id',
                    singleSelect:false,//是否单选
                    rownumbers: true,//行号
                    pagination: true,//分页控件
                    sortName: 'id',
                    sortOrder: 'DESC',
                    remoteSort: false,
                    columns: [[
                        {field:'chk',checkbox:true,width:50},
                        {field:'id',title:'ID',width:50,sortable: true},
                        {field:'clazzName',title:'所属班级',width:150},
                        {field:'name',title:'姓名',width:150},
                        {field:'sno',title:'学号',width:150},
                        {field:'gender',title:'性别',width:150},
                        {field:'email',title:'邮箱',width:150},
                        {field:'telephone',title:'电话',width:150},
                        {field:'address',title:'住址',width:150},
                        {field:'introduction',title:'简介',width:220}
                    ]],
                    toolbar:"#toolbar"
                });

                /*设置分页控件*/
                var p = $('#dataList').datagrid('getPager');
                $(p).pagination({
                    pageSize: 10,//设置每页显示的记录条数，默认为10
                    pageList:[10, 20, 30, 50, 100],//每页记录的条数
                    beforePageText:'第',
                    afterPageText:'页    共 {pages} 页',
                    displayMsg:'当前显示 {from} - {to} 条记录   共 {total} 条记录',
                });

                /*信息添加按钮事件*/
                $("#add").click(function(){
                    table = $("#addTable");
                    $("#addTable").form("clear");//清空表单数据
                    $("#add-portrait").attr("src","${pageContext.request.contextPath}/image/portrait/default_student_portrait.png");
                    $("#addDialog").dialog("open");//打开添加窗口
                });

                /*信息修改按钮事件*/
                $("#edit").click(function () {
                    table = $("#editTable");
                    var selectRows = $("#dataList").datagrid("getSelections");
                    if(selectRows.length !== 1){
                        $.messager.alert("提醒消息","请单条选择想要修改的数据","warning");
                    }else{
                        $("#editDialog").dialog("open");
                    }
                });

                /*信息删除按钮事件*/
                $("#delete").click(function () {
                    //返回所有选中的列，没有选中时返回空数组
                    var selectRows = $("#dataList").datagrid("getSelections");
                    var selectLength = selectRows.length;
                    if(selectLength === 0){
                        $.messager.alert("提醒消息","亲选择想要删除的数据","warning");
                    }else{
                        var ids = [];
                        $(selectRows).each(function (i,row) {
                            //将要删除的行的Id存入数组中
                            ids[i] = row.id;
                        });
                        /*确认后执行后执行回调函数*/
                        $.messager.confirm("提醒消息","删除后将无法回复该学生信息！确定还要继续？",function (r) {
                            if(r){
                                $.ajax({
                                    type: "post",
                                    url: "deleteStudent?t=" + new Date().getTime(),
                                    data:{ids:ids},
                                    dataType: "json",
                                    success: function (data) {
                                        if(data.success){
                                            $.messager.alert("提醒消息","成功删除","info");
                                            $("#dataList").datagrid("reload");//刷新表格
                                            $("#dataList").datagrid("uncheckAll");//取消候选
                                        }else{
                                            $.messager.alert("提醒消息","服务端发生错误！删除失败","warning");
                                        }
                                    }
                                });
                            }
                        });
                    }
                });

                /*添加学生信息*/
                $("#addDialog").dialog({
                    title:"添加学生信息窗口",
                    width:660,
                    height:530,
                    iconCls: "icon-house",
                    modal: true,
                    collapsible: false,
                    minimizable: false,
                    maximizable: false,
                    draggable:true,
                    closed:true,
                    buttons:[
                        {
                            text:"添加",
                            plain: true,
                            iconCls: 'icon-add',
                            handler: function(){
                                var validate = $("#addForm").form("validate");
                                if(!validate){
                                    $.messager.alert("提醒消息","请检查输入的数据","warning");
                                }else{
                                    var data = $("#addForm").serialize();//序列化表单信息
                                    $.ajax({
                                        type: "post",
                                        url: "addStudent?t=" + new Date().getTime(),
                                        data: data,
                                        dataType: "json",
                                        success: function (data) {
                                            if(data.success){
                                                $("#addDialog").dialog("close");//关闭窗口
                                                $("#dataList").datagrid("reload");//重新刷新页面数据
                                                $.messager.alert("提醒消息","学生添加成功","info");
                                            }else{
                                                $.messager.alert("提醒消息",data.msg,"warning");
                                            }
                                        }
                                    });
                                }
                            }
                        },
                        {
                            text: "重置",
                            plain: true,
                            iconCls: 'icon-reload',
                            handler: function () {
                                $("#add_sno").textbox("setValue","");
                                $("#add_name").textbox("setValue","");
                                $("#add_gender").textbox("setValue","");
                                $("#add_password").textbox("setValue","");
                                $("#add_email").textbox("setValue","");
                                $("#add_telephone").textbox("setValue","");
                                $("#add_address").textbox("setValue","");
                                $("#add_introduction").textbox("setValue","");
                            }
                        }
                    ]
                });

                /*编辑学生信息窗口*/
                $("#editDialog").dialog({
                    title:"编辑学生信息窗口",
                    width:660,
                    height:500,
                    iconCls: "icon-house",
                    modal: true,
                    collapsible: false,
                    minimizable: false,
                    maximizable: false,
                    draggable:true,
                    closed:true,
                    buttons:[
                        {
                            text:"提交",
                            plain: true,
                            iconCls: 'icon-edit',
                            handler: function(){
                                var validate = $("#editForm").form("validate");
                                if(!validate){
                                    $.messager.alert("提醒消息","请检查输入的数据","warning");
                                }else{
                                    var data = $("#editForm").serialize();//序列化表单信息
                                    $.ajax({
                                        type: "post",
                                        url: "editStudent?t=" + new Date().getTime(),
                                        data: data,
                                        dataType: "json",
                                        success: function (data) {
                                            if(data.success){
                                                $("#editDialog").dialog("close");//关闭窗口
                                                $("#dataList").datagrid("reload");//重新刷新页面数据
                                                $("#dataList").datagrid("uncheckAll");
                                                $.messager.alert("提醒消息","学生添加成功","info");
                                            }else{
                                                $.messager.alert("提醒消息",data.msg,"warning");
                                            }
                                        }
                                    });
                                }
                            }
                        },
                        {
                            text: "重置",
                            plain: true,
                            iconCls: 'icon-reload',
                            handler: function () {
                                $("#edit_name").textbox("setValue","");
                                $("#edit_gender").textbox("setValue","");
                                $("#edit_password").textbox("setValue","");
                                $("#edit_email").textbox("setValue","");
                                $("#edit_telephone").textbox("setValue","");
                                $("#edit_address").textbox("setValue","");
                                $("#edit_introduction").textbox("setValue","");
                            }
                        }
                    ],
                    /*打开窗口前先初始化表单数据 表单数据*/
                    onBeforeOpen:function(){
                        var selectRow = $("#dataList").datagrid("getSelected");
                        $("#edit_id").val(selectRow.id);//初始化id值，需要根据id更新学生信息
                        $("#edit_sno").textbox('setValue',selectRow.sno);
                        $("#edit_name").textbox('setValue',selectRow.name);
                        $("#edit_gender").textbox('setValue',selectRow.gender);
                        $("#edit_password").textbox('setValue',selectRow.password);
                        $("#edit_email").textbox('setValue',selectRow.email);
                        $("#edit_telephone").textbox('setValue',selectRow.telephone);
                        $("#edit_address").textbox('setValue',selectRow.address);
                        $("#edit_introduction").textbox('setValue',selectRow.introduction);
                        $("#edit-portrait").attr('src',selectRow.portraitPath);
                    }
                });

                /*学生姓名和班级名称搜索按钮的监听事件(返回值给Controller)*/
                $("#search-btn").click(function () {
                    $('#dataList').datagrid('load',{
                        //获取学生姓名
                        studentname: $("#search-studentname").val(),
                        //获取年级名称
                        clazzname: $("#search-clazzname").combobox("getValue")
                    });
                });

                /*添加信息窗口中上传头像的按钮事件*/
                $("#add-upload-btn").click(function () {
                    if($("#choose-portrait").filebox("getValue") === ''){
                        $.messager.alert("提示信息","请选择图片","warning");
                        return;
                    }
                    $("#add-uploadForm").submit();
                });

                /*修改信息中上传头像的按钮事件*/
                $("#edit-upload-btn").click(function () {
                    if($("#edit-choose-portrait").filebox("getValue") === ''){
                        $.messager.alert("提示信息","请选择图片","warning");
                        return;
                    }
                    $("#edit-uploadForm").submit();
                });
            });

            /*上传头像按钮事件*/
            function uploaded(){
                var data = $(window.frames["photo_target"].document).find("body pre").text();
                //将data转换为JSON对象
                data = JSON.parse(data);
                if(data.success){
                    $.messager.alert("提示信息","图片上传成功","info");
                    //切换头像
                    $("#add-portrait").attr("src",data.portraitPath);
                    $("#edit-portrait").attr("src",data.portraitPath);
                    /*将头像路径存储到学生信息表单当中(从用户信息中读取头像路径来显示头像)*/
                    $("#add_portrait-path").val(data.portraitPath);
                    $("#edit_portrait-path").val(data.portraitPath);
                }else{
                    $.messager.alert("提示信息",data.msg,"warning");
                }
            }
        </script>
    </head>

    <body>
        <table id="dataList" cellspacing="0" cellpadding="0"></table>
        <%--工具栏:添加 编辑 删除 查找等功能按钮--%>
        <div id="toolbar">
            <div style="float:left;">
                <a id="add" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">
                  添加
                </a>
            </div>
            <%--datagrid数据网格按钮的 分隔符--%>
            <div style="float: left" class=""datagrid-btn-separator></div>

            <%--jstl设置用户操作权限：将编辑和删除按钮设置为仅管理员和教师可见--%>
            <c:if test="${userType == 1 || userType == 3}">
                <div style="float: left">
                    <a id="edit" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">
                        修改
                    </a>
                </div>
                <div style="float: left;" class="datagrid-btn-separator"></div>
                <div style="float: left;">
                    <a id="delete" href="javascript:vpod(0)" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">
                        删除
                    </a>
                </div>
            </c:if>
            <%--学生 班级名 搜索域--%>
            <div style="margin-left: 10px;">
                <div style="float: left;" class="datagrid-btn-separator"></div>
                <%--班级名称下拉列表--%>
                <a href="javascript:(0)" class="easyui-linkbutton" data-options="inconCls:'icon-class',plain:true">
                    班级名称
                </a>
                <select id="search-clazzname" name = "clazzname" style="width: 155px;" class="easyui-combobox">
                    <%--通过jstl遍历显示年级信息，clazzList为Controller传递来的域对象 存储着Clazz的List对象--%>
                    <option value="">未选择班级</option>
                    <c:forEach items="${clazzList}" var="clazz">
                        <option value="${clazz.name}">${clazz.name}</option>
                    </c:forEach>
                </select>
                <%--学生姓名搜索框--%>
                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-user-student',plain:true">
                    学生姓名
                </a>

                <input id="search-studentname" name ="studentname" class="easyui-textbox"/>

                <%--搜索按钮--%>
                <a id="search-btn" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">
                    搜素
                </a>
            </div>
        </div>

        <%--添加信息窗口--%>
        <div id="addDialog" style="padding: 15px 0 0 55px;">
            <%--设置添加头像功能--%>
            <div id = "add-photo" style="float: right;margin:15px 40px 0 0;width: 250px;border: 1px solid #EEF4FF">
                <img id="add-portrait" alt="照片" style="max-width: 250px;max-height: 300px;" title="照片"
                    src="${pageContext.request.contextPath}/image/portrait/default_student_portrait.png"/>
                <%--设置上传图片按钮--%>
                <form id="add-uploadForm" method="post" enctype="multipart/form-data" action="uploadPhoto" target="photo_target">
                    <input id="choose-portrait" name = "photo" class="easyui-filebox" data-options="prompt:'选择头像'" style="width: 200px;">
                    <input id="add-upload-btn" class="easyui-linkbutton" style="width: 50px;height: 24px;float: right;" type="button" value="上传"/>
                </form>
            </div>
            <%--学生信息表单--%>
            <form id="addForm" method="post" action="#">
                <table id="addTable" style="border-collapse: separate;border-spacing: 0 3px;" cellpadding="6">
                    <%--存储上传头像的路径--%>
                    <input id="add_portrait-path" name="portraitPath" type="hidden"/>
                    <tr>
                        <td>班级</td>
                        <td colspan="1">
                            <select id="add_clazz_name" name ="clazzName" style="width:200px;height: 30px"
                                    class="easyui-combobox" data-options="required:true,missingMessage:'请选择所属班级'">

                                <c:forEach items="${clazzList}" var="clazz">
                                    <option value=${clazz.name}>${clazz.name}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>姓名</td>
                        <td colspan="1">
                            <input id="add_name" name ="name" style="width: 200px;height: 30px;"
                                   class="easyui-textbox" type="text" data-options="required:true,missingMessage:'请填写姓名'"/>
                        </td>
                    </tr>
                    <tr>
                        <td>性别</td>
                        <td>
                            <select id="add_gender" name = "gender" class="easyui-combobox"
                                    data-options="editable: false,panelHeight: 50,width: 60,height: 30">

                                <option value="男">男</option>
                                <option value="女">女</option>

                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>学号</td>
                        <td colspan="1">
                            <input id="add_sno" name="sno" style="width: 200px;height: 30px;"
                                   class="easyui-textbox" type="text" data-options="required:true,missingMessage:'请填写学号'" />
                        </td>
                    </tr>
                    <tr>
                        <td>密码</td>
                        <td colspan="1">
                            <input id="add_password" name = "password" class="easyui-textbox" style = "width: 200px;height: 30px"
                            type="password" data-options="required:true,missingMessage:'请填写密码'"/>
                        </td>
                    </tr>
                    <tr>
                        <td>邮箱</td>
                        <td colspan="1">
                            <input id="add_email" name ="email" style="width: 200px;height: 30px;"
                                   class="easyui-textbox" type="text" validType="email"
                                   data-options="required:true,missingMessage:'请填写邮箱'"/>
                        </td>
                    </tr>
                    <tr>
                       <td>电话</td>
                       <td colspan="4">
                           <input id="add_telephone" name ="telephone" style="width: 200px;height: 30px;"
                                  class="easyui-textbox" type="text" validType="mobile"
                                  data-options="required:true,missingMessage:'请填写电话号码'">
                       </td>
                    </tr>
                    <tr>
                       <td>住址</td>
                       <td colspan="1">
                           <input id="add_address" name="address" style="width: 200px;height: 30px;"
                                  class="easyui-textbox" type="text"
                                  data-options="required:true,missingMessage:'请填写家庭地址'"/>
                       </td>
                    </tr>
                    <tr>
                       <td>简介</td>
                       <td colspan="4">
                           <input id="add_introduction" name="introduction" style="width: 200px;height: 60px;"
                                  class="easyui-textbox" type="text"
                                  data-options="multiline:true,required:true,missingMessage:'请填写个人简介'"/>
                       </td>
                    </tr>
                </table>
            </form>
        </div>
        <%--修改信息窗口--%>
        <div id="editDialog" style="padding: 20px 0 0 65px">
            <%--设置修改头像功能--%>
            <div id = "edit-photo" style="float:right;margin: 15px 40px 0 0;width: 250px;border:1px solid #EEF4FF">
                <img id="edit-portrait" alt="照片" style="max-width: 250px;max-height: 300px;" title="照片"
                src = "${pageContext.request.contextPath}/image/portrait/default_student_portrait.png">

                <%--设置上传图片按钮--%>
                <form id="edit-uploadForm" method="post" enctype="multipart/form-data" action="uploadPhoto" target="photo_target">
                    <input id="edit-choose-portrait" name="photo" class="easyui-filebox"
                           data-options="prompt:'选择照片'" style="width: 200px"/>
                    <input id="edit-upload-btn" class="easyui-linkbutton" style="width: 50px;height: 24px;float:right;"
                           type="button" value="上传"/>
                </form>
            </div>
            <%--学生信息表单--%>
            <form id="editForm" method="post" action="#">
                <%--获取被修改学生的id--%>
                <input id="edit_id" name="id" type="hidden"/>
                <table id="editTable" style="border-collapse: separate;border-spacing:0 3px;" cellpadding="6">
                    <%--存储上传头像路径--%>
                    <input id="edit_portrait-path" name="portraitPath" type="hidden"/>
                    <tr>
                        <td>班级</td>
                        <td colspan="1">
                            <select id="edit_clazz_name" name="clazzName" style="width: 200px;height: 30px;" class="easyui-combobox">
                                <c:forEach items="${clazzList}" var = "clazz">
                                    <option value="${clazz.name}">${clazz.name}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>姓名</td>
                        <td colspan="1">
                            <input id="edit_name" name="name" style="width: 200px;height: 30px" class="easyui-textbox" type="text"
                                   data-options="required:true,missingMessage:'请填写姓名'"/>
                        </td>
                    </tr>
                    <tr>
                        <td>性别</td>
                        <td>
                            <select id="edit_gender" class="easyui-combobox"
                                    data-options="editable:false,panelHeight: 50,width: 60,height:30" name="gender">

                                <option value="男">男</option>
                                <option value="女">女</option>

                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>学号</td>
                        <td colspan="1">
                            <%--设置为只读--%>
                            <input id="edit_sno" data-options="readonly:true" style="width: 200px;height: 30px;"
                                   class="easyui-textbox" type="text"/>
                        </td>
                    </tr>
                   <tr>
                        <td>邮箱</td>
                        <td colspan="1">
                            <input id="edit_email" name ="email" style="width: 200px;height: 30px;"
                                   class="easyui-textbox" type="text" validType="email"
                                   data-options="required:true,missingMessage:'请填写邮箱'"/>
                        </td>
                   </tr>
                   <tr>
                       <td>电话</td>
                       <td colspan="4">
                           <input id="edit_telephone" name ="telephone" style="width: 200px;height: 30px;"
                                  class="easyui-textbox" type="text" validType="mobile"
                                  data-options="required:true,missingMessage:'请填写电话号码'">
                       </td>
                   </tr>
                   <tr>
                       <td>住址</td>
                       <td colspan="1">
                           <input id="edit_address" name="address" style="width: 200px;height: 30px;"
                                  class="easyui-textbox" type="text"
                                  data-options="required:true,missingMessage:'请填写家庭地址'"/>
                       </td>
                   </tr>
                   <tr>
                       <td>简介</td>
                       <td colspan="4">
                           <input id="edit_introduction" name="introduction" style="width: 200px;height: 60px;"
                                  class="easyui-textbox" type="text"
                                  data-options="multiline:true,required:true,missingMesage:'请填写个人简介'"/>
                       </td>
                   </tr>
                </table>
            </form>
        </div>
        <%--表单处理--%>
        <iframe id="photo_target" name="photo_target" onload="uploaded(this)"></iframe>
    </body>
</html>
