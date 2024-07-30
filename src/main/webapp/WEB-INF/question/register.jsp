<%@ page contentType="text/html; charset=UTF-8" pageEncoding="utf-8" language="java" %>
<!DOCTYPE html>
<html lang="kr">
<head>
    <title>질문 등록 페이지</title>
    <%@include file="/WEB-INF/includes/head.jsp"%>
</head>
<body>

<%@include file="/WEB-INF/includes/navbar-fixed-top.jsp"%>
<%@include file="/WEB-INF/includes/navbar-default.jsp"%>

<div class="container" id="main">
   <div class="col-md-12 col-sm-12 col-lg-10 col-lg-offset-1">
      <div class="panel panel-default content-main">
          <form name="question" method="post" action="/questions">
              <div class="form-group">
                  <label for="writer">글쓴이</label>
                  <input readonly class="form-control" id="writer" name="writer" placeholder="글쓴이" value="${sessionScope.userName}"/>
              </div>
              <div class="form-group">
                  <label for="title">제목</label>
                  <input type="text" class="form-control" id="title" name="title" placeholder="제목"/>
              </div>
              <div class="form-group">
                  <label for="contents">내용</label>
                  <textarea name="contents" id="contents" rows="5" class="form-control"></textarea>
              </div>
              <button type="submit" class="btn btn-success clearfix pull-right">질문하기</button>
              <div class="clearfix" />
          </form>
        </div>
    </div>
</div>

<!-- script references -->
<!-- script references -->
<%@include file="/WEB-INF/includes/script-references.jsp"%>
	</body>
</html>
