
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <%--引入css--%>
        <link href="${pageContext.request.contextPath}/static/h-ui/css/H-ui.min.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/static/h-ui/css/H-ui.login.css" rel="stylesheet" type ="text/css"/>
        <link href="${pageContext.request.contextPath}/static/h-ui/lib/icheck/icheck.css" rel = "stylesheet" type = "text/css"/>
        <link href="${pageContext.request.contextPath}/static/h-ui/lib/Hui-iconfont/1.0.1/iconfont.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/static/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/static/easyui/themes/icon.css">
        <%--引入js--%>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/h-ui/js/H-ui.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/easyui/jquery.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/easyui/jquery.easyui.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/static/h-ui/lib/icheck/jquery.icheck.min.js"></script>

            <script type="text/javascript">
                $(function () {
                    //点击切换验证码图片
                    $("#verificationImg").click(function(){
                        this.src = "getVerificationCodeImage?t=" + new Date().getTime();
                    });
                    //登录按钮事件
                    $("#submitBtn").click(function(){
                        //检查信息提交
                        if($("#username").val() === ''){
                            $.messager.alert("提示","请输入用户名！","warning");
                        }else if($("#password").val() === ''){
                            $.messager.alert("提示","请输入密码！","warning");
                        }else if($("#verificationCode").val() === ''){
                            $.messager.alert("提示","请输入验证码！","warning");
                        }else{
                            //提交用户登录的表单信息
                            var data = $("#form").serialize();
                            $.ajax({
                                type: "post",
                                url: "login?t=" + new Date().getTime(),
                                data: data,
                                dataType: "json",
                                success: function(data){
                                    if(data.success){
                                        window.location.href = "goSystemMainView";
                                    }else{
                                        $.messager.alert("提示",data.msg,"warning");
                                        $("#verificationImg").click();
                                        //清空验证码输入框
                                        $("input[name='verificationCode']").val("");
                                    }
                                }
                            });
                        }
                    });

                    $(".skin-minimal input").iCheck({
                        radioClass:'iradio-blue',
                        increaseArea: '25%'
                    });
                })
            </script>
        <title>学生管理系统 | 登录页面</title>
        <meta name = "keywords" content = "学生信息管理系统">
    </head>
    <body style = "font-weight: lighter;">
        <div class = "header" style = "padding: 0;">
            <h3 style = "font-weight: lighter;color: white;width: 550px;height: 60px;line-height: 60px;margin:0 0 0 30px;padding: 0;">
                学生管理系统
            </h3>
        </div>
        <div class = "loginWraper">
            <div id = "loginform" class = "loginBox">

                <form id = "form" class = "form form-horizontal" method = "post" action="#">
                    <%--用户身份信息--%>
                    <%--账号--%>
                    <div class = "row cl">
                        <label class = "form-label col-3"><i class="Hui-iconfont">&#xe60a;</i></label>
                        <div class = "formControls col-8">
                            <input id = "username" name = "username" type="text" placeholder = "账户" class="input-text radius size-L"/>
                        </div>
                    </div>
                    <%--密码--%>
                    <div class = "row cl">
                        <label class = "form-label col-3"><i class="Hui-iconfont">&#xe63f;</i></label>
                        <div class = "formControls col-8">
                            <input id = "password" name = "password" type="password" placeholder = "密码" class="input-text radius size-L"/>
                        </div>
                    </div>
                    <%--验证码--%>
                    <div class = "row cl">
                        <label class="form-label col-3"><i class="Hui-iconfont">&#xe647;</i></label>/
                        <div class="formControls col-8">
                            <input id = "verificationCode" name ="verificationCode" class="input-text radius size-L" type = "text" placeholder = "验证码" style="width: 200px;">
                            <img id = "verificationImg" src = "getVerificationCodeImage" title="点击图片切换验证码" alt="#"/>
                        </div>
                    </div>
                    <%--用户类型--%>
                    <div class="mt-20 skin-minimal" style="text-align:center;">
                        <div class="radio-box">
                            <input type="radio" id = "radio-1" name="userType" value = "1"/>
                            <label for = "radio-3">管理员</label>
                        </div>
                        <div class="radio-box">
                            <input type="radio" id = "radio-3" name="userType" value = "3"/>
                            <label for = "radio-2">老师</label>
                        </div>
                        <div class="radio-box">
                            <input type="radio" id = "radio-2" name="userType" checked value = "2"/>
                            <label for = "radio-1">学生</label>
                        </div>
                    </div>
                    <%--登录按钮--%>
                    <div class="row">
                        <div class="formControls col-8 col-offset-3">
                            <input id="submitBtn" type="button" class="btn btn-primary radius" value="&nbsp;
                            登&nbsp;&nbsp;&nbsp;&nbsp;录&nbsp;"/>
                        </div>
                    </div>
                </form>

            </div>
        </div>

        <%--页面底部版权声明--%>
        <div class="footer"></div>
    </body>
</html>
