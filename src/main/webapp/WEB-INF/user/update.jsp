<%@ page contentType="text/html; charset=UTF-8" pageEncoding="utf-8" language="java" %>
<!DOCTYPE html>
<html lang="kr">
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <title>SLiPP Java Web Programming</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link href="../../css/bootstrap.min.css" rel="stylesheet">
    <!--[if lt IE 9]>
    <script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
    <link href="../../css/styles.css" rel="stylesheet">
</head>
<body>

<%@include file="/WEB-INF/includes/navbar-fixed-top.jsp"%>
<%@include file="/WEB-INF/includes/navbar-default.jsp"%>

<div class="container" id="main">
    <div class="col-md-6 col-md-offset-3">
        <div class="panel panel-default content-main">
            <form name="question" method="post" action="/users/update/${user.userSeq}">
                <div class="form-group">
                    <label for="userId">아이디</label>
                    <input class="form-control" disabled id="userId" name="userId" placeholder="User ID" value="${user.userId}">
                </div>
                <div class="form-group">
                    <label for="password">현재 비밀번호</label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password">
                </div>
                <div class="form-group">
                    <label for="new-password">새로운 비밀번호</label>
                    <input type="password" class="form-control" id="new-password" name="new-password" placeholder="Password">
                </div>
                <div class="form-group">
                    <label for="name">이름</label>
                    <input class="form-control" id="name" name="name" placeholder="Name">
                </div>
                <div class="form-group">
                    <label for="email">이메일</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="Email">
                </div>
                <button type="submit" class="btn btn-success clearfix pull-right">수정</button>
                <div class="clearfix" />
            </form>
        </div>
    </div>
</div>

<!-- script references -->
<%@include file="/WEB-INF/includes/script-references.jsp"%>
</body>
</html>
