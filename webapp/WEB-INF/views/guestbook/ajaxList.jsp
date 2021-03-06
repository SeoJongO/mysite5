<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/assets/js/jquery/jquery-1.12.4.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/assets/bootstrap/js/bootstrap.js"></script>
<link href="${pageContext.request.contextPath}/assets/bootstrap/css/bootstrap.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/assets/css/mysite.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/assets/css/guestbook.css" rel="stylesheet" type="text/css">

</head>

<body>
	<div id="wrap">

		<!-- 헤더, 네비 -->
		<c:import url="/WEB-INF/views/includes/header.jsp"></c:import>
		<!-- //헤더, 네비 -->

		<div id="container" class="clearfix">
			<c:import url="/WEB-INF/views/includes/asideGuestbook.jsp"></c:import>
			<!-- //aside -->

			<div id="content">

				<div id="content-head" class="clearfix">
					<h3>ajax방명록</h3>
					<div id="location">
						<ul>
							<li>홈</li>
							<li>방명록</li>
							<li class="last">ajax방명록</li>
						</ul>
					</div>
				</div>
				<!-- //content-head -->

				<div id="guestbook">
					<form action="" method="">
						<table id="guestAdd">
							<colgroup>
								<col style="width: 70px;">
								<col>
								<col style="width: 70px;">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th><label class="form-text" for="input-uname">이름</label>
									</td>
									<td><input id="input-uname" type="text" name="name"></td>
									<th><label class="form-text" for="input-pass">패스워드</label>
									</td>
									<td><input id="input-pass" type="password" name="password"></td>
								</tr>
								<tr>
									<td colspan="4"><textarea name="content" cols="72" rows="5"></textarea></td>
								</tr>
								<tr class="button-area">
									<td colspan="4" class="text-center"><button id="btnSubmit" type="submit">등록</button></td>
								</tr>
							</tbody>

						</table>
						<!-- //guestWrite -->

					</form>

					<div id="listArea">
						<!-- jquery 리스트 그리는 영역 -->
						
					</div>

				</div>
				<!-- //guestbook -->

			</div>
			<!-- //content  -->
		</div>
		<!-- //container  -->

		<c:import url="/WEB-INF/views/includes/footer.jsp"></c:import>
		<!-- //footer -->
	</div>
	<!-- //wrap -->
	
	<!-- 삭제 모달창 -->
	<div id="delModal" class="modal fade">
  	 <div class="modal-dialog">
      <div class="modal-content">
       <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
         <h4 class="modal-title">방명록 삭제</h4>
          </div>
           <div class="modal-body">
           	<label for="modalPassword">비밀번호</label>
            <input id="modalPassword" type="password" name="password" value="">
            <input type="hidden" name="no" value=""> 
           </div>
          <div class="modal-footer">
        <button id="modalDelete" type="button" class="btn btn-primary">삭제</button>
       </div>
      </div><!-- /.modal-content -->
  	 </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->

</body>

<script type="text/javascript">
	$(document).ready(function() {
		fetchList();
	});
	
	// 로딩이 끝난후
	// 등록 버튼 클릭
	$("#btnSubmit").on("click", function() {
		event.preventDefault();
		
			//var userName = $("#input-uname").val();
			//var password = $("#input-pass").val();
			//var content = $("[name='content']").val();
		
		var guestbookVo = {
				name: $("#input-uname").val(),
				password: $("#input-pass").val(),
				content: $("[name='content']").val()
		};
		
		// 데이터 ajax방식으로 서버에 전송
		$.ajax({
			url : "${pageContext.request.contextPath }/api/guestbook/write",
			type : "post",
			//contentType : "application/json",
			//data : {name: userName, password: password, content: content},
			data : guestbookVo,
			
			dataType : "json",
			success : function(guestbookVo) {
				render(guestbookVo, "up");
				$("#input-uname").val("");
				$("#input-pass").val("");
				$("[name='content']").val("");
			},
			error : function(XHR, status, error) {
				console.error(status + " : " + error);
			}
		});
	});
	
	// 리스트 삭제 버튼 클릭
	$("#listArea").on("click", ".btnDel", function() {
		// 비밀번호 초기화
		$("[name=no]").val("");
		$("#modalPassword").val("");
		// hidden no 입력
		var no = $(this).data("no");
		$("[name=no]").val(no);
		// 모달창 보이기
		$("#delModal").modal();
	});
	
	// 모달 삭제 버튼 클릭
	$("#modalDelete").on("click", function() {
		// 서버에 삭제요청 (no, password 전달)
		var guestbookVo = {
				no: $("[name='no']").val(),
				password: $("#modalPassword").val()
			};
		
		console.log(guestbookVo);
		
		$("button").click(function(){

		$.ajax({
			url : "${pageContext.request.contextPath }/api/guestbook/delete",
			type : "post",
			//contentType : "application/json",
			data : guestbookVo,
			dataType : "json",
			
			success : function(count){
				if(count === 1) {
					$("#delModal").modal("hide");
					$("#t-"+ $("[name='no']").val() +"").remove();
				} else {
					$("#delModal").modal("hide");
				}
			},
			error : function(XHR, status, error) {
				console.error(status + " : " + error);
			}
			});
		});
	});
	
	// 리스트 가져오기
	function fetchList() {
		$.ajax({
			url : "${pageContext.request.contextPath }/api/guestbook/list",
			type : "post",
			//contentType : "application/json",
			//data : {name: ”홍길동"},
			//dataType : "json",
	
			success : function(guestList) {
				for(var i=0; i<guestList.length;i++) {
					render(guestList[i], "down");
				}
			},
			error : function(XHR, status, error) {
				console.error(status + " : " + error);
			}
		});
	} ;
	
	// 방명록 1개씩 렌더링
	function render(guestbookVo, type) {
		var str = "";
		str += '<table id="t-' + guestbookVo.no + '" class="guestRead">';
		str += '	<colgroup>';
		str += '		<col style="width: 10%;">';
		str += '		<col style="width: 40%;">';
		str += '		<col style="width: 40%;">';
		str += '		<col style="width: 10%;">';
		str += '	</colgroup>';
		str += '	<tr>';
		str += '		<td>'+ guestbookVo.no +'</td>';
		str += '		<td>'+ guestbookVo.name +'</td>';
		str += '		<td>'+ guestbookVo.regDate +'</td>';
		str += '		<td><button class="btnDel" data-no="'+ guestbookVo.no +'">삭제</button></td>';
		str += '	</tr>';
		str += '	<tr>';
		str += '		<td colspan=4 class="text-left">'+ guestbookVo.content +'</td>';
		str += '	</tr>';
		str += '</table>';
		
		if(type == "down") {
			$("#listArea").append(str);
		} else if(type == "up") {
			$("#listArea").prepend(str);
		} else {
			console.log("방향을 지정해 주세요");
		}
	}		
</script>
</html>