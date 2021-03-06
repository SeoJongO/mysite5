<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/jquery/jquery-1.12.4.js"></script>
<link href="${pageContext.request.contextPath }/assets/css/mysite.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath }/assets/css/user.css" rel="stylesheet" type="text/css">

</head>

<body>
	<div id="wrap">

		<c:import url="/WEB-INF/views/includes/header.jsp"></c:import>

		<div id="container" class="clearfix">
			<c:import url="/WEB-INF/views/includes/asideUser.jsp"></c:import>
			<!-- //aside -->

			<div id="content">

				<div id="content-head">
					<h3>회원가입</h3>
					<div id="location">
						<ul>
							<li>홈</li>
							<li>회원</li>
							<li class="last">회원가입</li>
						</ul>
					</div>
					<div class="clear"></div>
				</div>
				<!-- //content-head -->

				<div id="user">
					<div>
						<form id="joinForm" action="${pageContext.request.contextPath }/user/join" method="post">
							<!-- 아이디 -->
							<div class="form-group">
								<label class="form-text" for="input-uid">아이디</label>
								<input type="text" id="input-uid" name="id" value="" placeholder="아이디를 입력하세요">
								<button type="button" id="btnIdCheck">중복체크</button>
								<p class="form-text" id="idCheckMsg"></p>
							</div>

							<!-- 비밀번호 -->
							<div class="form-group">
								<label class="form-text" for="input-pass">패스워드</label> 
								<input type="text" id="input-pass" name="password" value="" placeholder="비밀번호를 입력하세요">
							</div>

							<!-- 이름 -->
							<div class="form-group">
								<label class="form-text" for="input-name">이름</label> 
								<input type="text" id="input-name" name="name" value="" placeholder="이름을 입력하세요">
							</div>

							<!-- 나이 -->
							<div class="form-group">
								<span class="form-text">성별</span> 
									<label for="rdo-male">남</label> 
										<input type="radio" id="rdo-male" name="gender" value="male"> 
									<label for="rdo-female">여</label> 
										<input type="radio" id="rdo-female" name="gender" value="female">
							</div>

							<!-- 약관동의 -->
							<div class="form-group">
								<span class="form-text">약관동의</span> 
								<input type="checkbox" id="chk-agree" name="" value=""> 
								<label for="chk-agree">서비스 약관에 동의합니다.</label>
							</div>

							<!-- 버튼영역 -->
							<div class="button-area">
								<button type="submit" id="btn-submit">회원가입</button>
							</div>

						</form>
					</div>
					<!-- //joinForm -->
				</div>
				<!-- //user -->
			</div>
			<!-- //content  -->
		</div>
		<!-- //container  -->

	<c:import url="/WEB-INF/views/includes/footer.jsp"></c:import>
	<!-- //footer -->

	</div>
	<!-- //wrap -->

</body>

<script type="text/javascript">

	
	$("#btn-submit").on("click", function() {
		event.preventDefault();
		
		var userVo = {
				id: $("#input-uid").val(),
				password: $("#input-pass").val(),
				name: $("#input-name").val(),
				gender: $("[name=gender]").val()
		}
		
		//userVo.gender = $("[name=gender]").val()
		
		console.log(userVo);
		console.log(JSON.stringify(userVo));
		
		$.ajax({
			url : "${pageContext.request.contextPath }/user/join2",
			type : "post",
			contentType : "application/json",
			data : JSON.stringify(userVo),
			dataType : "json",
			
			success : function(count){
				if( count == 1 ) {
					console.log(count);
					console.log("성공");
				} else {
					console.log(count);
					console.log("실패");
				}
			},
			error : function(XHR, status, error) {
				console.error(status + " : " + error);
			}
		});
		
	});



/*
	$("#joinForm").on("submit", function() {
		
		
		var password = $("#input-pass").val();
		
		if( password.length <= 8) {
			alert("패스워드를 8글자 이상 입력해 주세요");
			return false;
		}
		
		var name = $("#input-name").val();
		
		if( name.length < 1) {
			alert("이름을 입력해 주세요");
			return false;
		}

		var agree = $("#chk-agree").id(":checked");
		
		if( agree == false ) {
			alert("약관에 동의해 주세요");
			return false;
		}
		
		return true;
	});
*/

	$("#btnIdCheck").on("click", function(){
		
		var id = $("#input-uid").val();
		
		$.ajax({
			url : "${pageContext.request.contextPath }/user/idcheck",
			type : "post",
			//contentType : "application/json",
			data : {id: id},
			dataType : "json",
			
			success : function(state){
				console.log(state);
				
				if(state == true) {
					$("#idCheckMsg").html("사용가능한 ID입니다.")
				} else {
					$("#idCheckMsg").html("사용중인 ID입니다.")
				}
			},
			error : function(XHR, status, error) {
				console.error(status + " : " + error);
			}
			});
	});
</script>

</html>