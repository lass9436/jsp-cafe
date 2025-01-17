<%@ page contentType="text/html; charset=UTF-8" pageEncoding="utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="kr">
<head>
    <title>질문 상세 페이지</title>
    <%@include file="/WEB-INF/includes/head.jsp"%>
</head>
<body>

<%@include file="/WEB-INF/includes/navbar-fixed-top.jsp"%>
<%@include file="/WEB-INF/includes/navbar-default.jsp"%>

<div class="container" id="main">
    <div class="col-md-12 col-sm-12 col-lg-12">
        <div class="panel panel-default">
            <header class="qna-header">
                <h2 class="qna-title">${question.title}</h2>
            </header>
            <div class="content-main">
                <article class="article">
                    <div class="article-header">
                        <div class="article-header-thumb">
                            <img src="https://graph.facebook.com/v2.3/100000059371774/picture" class="article-author-thumb" alt="">
                        </div>
                        <div class="article-header-text">
                            <a href="/userPage?action=detail&seq=${question.userSeq}" class="article-author-name">${question.writer}</a>
                            <a href="/questionPage?action=detail&seq=${question.questionSeq}" class="article-header-time" title="퍼머링크">
                                <i class="icon-link"></i>
                            </a>
                        </div>
                    </div>
                    <div class="article-doc">
                        <p>${question.contents}</p>
                    </div>
                    <div class="article-util">
                        <ul class="article-util-list">
                            <c:if test="${question.userSeq == sessionScope.userSeq}">
                            <li>
                                <a class="link-modify-article" href="/questionPage?action=update&seq=${question.questionSeq}">수정</a>
                            </li>
                            <li>
                                <form class="form-delete" id="form-delete">
                                    <input type="hidden" name="_method" value="DELETE">
                                    <button class="link-delete-article" type="button" onclick="deleteQuestion()">삭제</button>
                                </form>
                            </li>
                            </c:if>
                            <li>
                                <a class="link-modify-article" href="/">목록</a>
                            </li>
                        </ul>
                    </div>
                </article>

                <div class="qna-comment">
                    <div class="qna-comment-slipp">
                        <p class="qna-comment-count"><strong>${count}</strong>개의 의견</p>
                        <div class="qna-comment-slipp-articles">
                            <c:forEach var="comment" items="${comments}" varStatus="status">
                            <article class="article" id="comment-${comment.commentSeq}">
                                <div class="article-header">
                                    <div class="article-header-thumb">
                                        <img src="https://graph.facebook.com/v2.3/1324855987/picture" class="article-author-thumb" alt="">
                                    </div>
                                    <div class="article-header-text">
                                        <a href="/userPage?action=detail&seq=${comment.userSeq}" class="article-author-name">${comment.writer}</a>
                                    </div>
                                </div>
                                <div class="article-doc comment-doc">
                                    <p>${comment.contents}</p>
                                </div>
                                <div class="article-util">
                                    <c:if test="${sessionScope.userSeq == comment.userSeq}">
                                    <ul class="article-util-list">
                                        <li>
                                            <a class="link-modify-article" href="#">수정</a>
                                        </li>
                                        <li>
                                            <form id="delete-comment-form" class="delete-answer-form" action="#" method="POST">
                                                <input type="hidden" name="_method" value="DELETE">
                                                <input type="hidden" name="seq" value="${comment.commentSeq}">
                                                <button type="button" class="delete-answer-button" onclick="deleteComment(${comment.commentSeq})">삭제</button>
                                            </form>
                                        </li>
                                    </ul>
                                    </c:if>
                                </div>
                            </article>
                            </c:forEach>
                        </div>
                        <c:if test="${count > 5}">
                            <button id="load-more-comments" type="button" onclick="getMoreComments()">
                                댓글 더보기
                            </button>
                        </c:if>
                        <form class="submit-write" id="post-comment-form">
                            <div class="form-group" style="padding:14px;">
                                <textarea id="post-comment-text" name="contents" class="form-control" placeholder="Update your status"></textarea>
                            </div>
                            <button class="btn btn-success pull-right" type="button" onclick="postComment()">답변하기</button>
                            <div class="clearfix" />
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/template" id="answerTemplate">
    <article class="article">
        <div class="article-header">
            <div class="article-header-thumb">
                <img src="https://graph.facebook.com/v2.3/1324855987/picture" class="article-author-thumb" alt="">
            </div>
            <div class="article-header-text">
                <a href="#" class="article-author-name">{0}</a>
                <div class="article-header-time">{1}</div>
            </div>
        </div>
        <div class="article-doc comment-doc">
            {2}
        </div>
        <div class="article-util">
            <ul class="article-util-list">
                <li>
                    <a class="link-modify-article" href="/api/qna/updateAnswer/{3}">수정</a>
                </li>
                <li>
                    <form class="delete-answer-form" action="/api/questions/{3}/answers/{4}" method="POST">
                        <input type="hidden" name="_method" value="DELETE">
                        <button type="submit" class="delete-answer-button">삭제</button>
                    </form>
                </li>
            </ul>
        </div>
    </article>
</script>

<script>
    let lastCommentSeq = ${lastCommentSeq}; // 초기값을 가장 큰 수로 설정
    let count = ${count};
    let remainCount = count - 5;

    function getMoreComments() {
        const questionSeq = "${question.questionSeq}";

        fetch(`/comment?questionSeq=${question.questionSeq}&startCommentSeq=`+ lastCommentSeq, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        })
            .then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error('Network response was not ok.');
            })
            .then(comments => {
                const commentContainer = document.querySelector('.qna-comment-slipp-articles');

                comments.forEach(comment => {
                    const article = document.createElement('article');
                    lastCommentSeq = Math.min(lastCommentSeq, comment.commentSeq);
                    article.className = 'article';
                    article.id = 'comment-' + comment.commentSeq;
                    article.innerHTML =
                        '<div class="article-header">' +
                        '<div class="article-header-thumb">' +
                        '<img src="https://graph.facebook.com/v2.3/1324855987/picture" class="article-author-thumb" alt="">' +
                        '</div>' +
                        '<div class="article-header-text">' +
                        '<a href="/userPage?action=detail&seq=' + comment.userSeq + '" class="article-author-name">' + comment.writer + '</a>' +
                        '</div>' +
                        '</div>' +
                        '<div class="article-doc comment-doc">' +
                        '<p>' + comment.contents + '</p>' +
                        '</div>' +
                        '<div class="article-util">' +
                        '<ul class="article-util-list">' +
                        (${sessionScope.userSeq} === comment.userSeq ?
                            '<li>' +
                            '<a class="link-modify-article" href="#">수정</a>' +
                            '</li>' +
                            '<li>' +
                            '<form class="delete-answer-form" action="#" method="POST">' +
                            '<input type="hidden" name="_method" value="DELETE">' +
                            '<button type="button" class="delete-answer-button" onclick="deleteComment(' + comment.commentSeq + ')">삭제</button>' +
                            '</form>' +
                            '</li>'
                            : '') +
                        '</ul>' +
                    '</div>';

                    commentContainer.appendChild(article);
                });

                remainCount -= comments.length;

                // 더 보여줄 댓글이 없으면 '더보기' 버튼 숨기기
                if (remainCount <= 0) {
                    document.querySelector('#load-more-comments').style.display = 'none';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                // 에러 처리
            });
    }
function deleteComment(commentSeq) {
    fetch(`/comment?seq=` + commentSeq, {
        method: 'DELETE'
    })
        .then(response => {
            if (response.ok) {
                // Remove the article element
                const article = document.getElementById('comment-' + commentSeq);
                if (article) {
                    article.remove();
                }

                // Update the comment count
                const commentCountElement = document.querySelector('.qna-comment-count strong');
                const currentCount = parseInt(commentCountElement.textContent);
                commentCountElement.textContent = currentCount - 1;
            } else {
                throw new Error('Failed to delete comment.');
            }
        })
        .catch(error => {
            console.error('There was a problem with the fetch operation:', error);
        });
}
function postComment() {
    const form = document.querySelector('#post-comment-form');
    const contents = form.querySelector('#post-comment-text').value;
    const questionSeq = "${question.questionSeq}";

    const data = new URLSearchParams();
    data.append('contents', contents);
    data.append('questionSeq', questionSeq);

    fetch(`/comment`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: data.toString()
    })
        .then(response => {
            if (response.ok) {
                return response.json(); // or response.text() or response.blob() depending on what the server returns
            }
            throw new Error('Network response was not ok.');
        })
        .then(comment => {
            const article = document.createElement('article');
            article.className = 'article';
            article.id = 'comment-' + comment.commentSeq;
            article.innerHTML =
                '<div class="article-header">' +
                '<div class="article-header-thumb">' +
                '<img src="https://graph.facebook.com/v2.3/1324855987/picture" class="article-author-thumb" alt="">' +
                '</div>' +
                '<div class="article-header-text">' +
                '<a href="/userPage?action=detail&seq=' + comment.userSeq + '" class="article-author-name">' + comment.writer + '</a>' +
                '</div>' +
                '</div>' +
                '<div class="article-doc comment-doc">' +
                '<p>' + comment.contents + '</p>' +
                '</div>' +
                '<div class="article-util">' +
                '<ul class="article-util-list">' +
                '<li>' +
                '<a class="link-modify-article" href="#">수정</a>' +
                '</li>' +
                '<li>' +
                '<form class="delete-answer-form" action="#" method="POST">' +
                '<input type="hidden" name="_method" value="DELETE">' +
                `<button type="button" class="delete-answer-button" onclick="deleteComment(`+comment.commentSeq+`)">삭제</button>` +
                '</form>' +
                '</li>' +
                '</ul>' +
                '</div>';

            // Append the new article to the div with class 'qna-comment-slipp-articles'
            const commentContainer = document.querySelector('.qna-comment-slipp-articles');
            commentContainer.insertBefore(article, commentContainer.firstChild);
            const commentCountElement = document.querySelector('.qna-comment-count strong');
            const currentCount = parseInt(commentCountElement.textContent);
            commentCountElement.textContent = currentCount + 1;
        })
        .catch(error => {
            console.error('Error:', error);
            // Handle error
        });
}

function deleteQuestion() {
    const jsonData = {
        "seq": "${question.questionSeq}"
    };

    fetch(`/questions`, {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(jsonData)
    }).then(response => {
        if (response.ok) {
            window.location.href = "/"; // 질문 목록 페이지로 리디렉트
        } else {
            // 오류 처리
            alert("다른 사람이 쓴 댓글이 있어서 삭제할 수 없습니다.");
        }
    }).catch(error => {
        console.error("Error:", error);
        alert("질문 삭제 중 오류가 발생했습니다.");
    });
}
</script>
<!-- script references -->
<%@include file="/WEB-INF/includes/script-references.jsp"%>
</body>
</html>
