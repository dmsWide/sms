<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 6/9/2019
  Time: 3:09 PM
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%-- 重定向到用户登录页面 在SystemController中有对应的处理器方法--%>
<% response.sendRedirect("system/goLogin"); %>