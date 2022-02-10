//대분류 등록
	function categoryMainCheck(){
		var categoryMainCode = cateMainInputForm.categoryMainCode.value;
		var categoryMainName = cateMainInputForm.categoryMainName.value;
		if(categoryMainCode == ""){
			alert("대분류 코드를 입력하세요");
			cateMainInputForm.categoryMainCode.focus();
			return false;
		}
		if(categoryMainName == ""){
			alert("대분류명을 입력하세요");
			cateMainInputForm.categoryMainName.focus();
			return false;
		}
		$.ajax({
			type : "post",
			url : "${ctp}/admin/cateMainInput",
			data : {
				categoryMainCode : categoryMainCode,
				categoryMainName : categoryMainName
			},
			success:function(data){
				if(data == "0") alert("이미 등록된 대분류입니다."); location.reload();
				if(data == "1") alert("대분류가 등록되었습니다."); location.reload();
			}
		});
	}
	
	//중분류 등록
	function categoryMidCheck(){
		var categoryMainCode = cateMiddleInputForm.categoryMainCode.value;
		var categoryMiddleCode = cateMiddleInputForm.categoryMiddleCode.value;
		var categoryMiddleName = cateMiddleInputForm.categoryMiddleName.value;
		if(categoryMainCode == ""){
			alert("대분류명을 선택하세요");
			return false;
		}
		if(categoryMiddleCode == ""){
			alert("중분류 코드를 입력하세요");
			cateMiddleInputForm.categoryMiddleCode.focus();
			return false;
		}
		if(categoryMiddleName == ""){
			alert("중분류명을 입력하세요");
			cateMiddleInputForm.categoryMiddleName.focus();
			return false;
		}
		$.ajax({
			type : "post",
			url : "${ctp}/admin/cateMidInput",
			data : {
				categoryMainCode : categoryMainCode,
				categoryMiddleCode : categoryMiddleCode,
				categoryMiddleName : categoryMiddleName
			}, 
			success : function(data){
				if(data == "0"){
					alert("이미 등록된 중분류입니다.");
				}
				else{
					alert("중분류가 등록되었습니다.");
				}
				location.reload();
			}
		});
	}
	
	//대분류 삭제
	function cateMainDel(categoryMainCode) {
	   	var ans = confirm("해당 대분류를 삭제하시겠습니까?");
	   	if(!ans) return false;
	   	$.ajax({
	   		type : "post",
	   		url  : "${ctp}/admin/cateMainDel",
	   		data : {categoryMainCode : categoryMainCode},
	   		success:function(data) {
	   			if(data == 0) {
	   				alert("하위 항목을 먼저 삭제하세요.");
	   			}
	   			else {
	   				alert("해당 대분류 항목이 삭제되었습니다.");
	   				location.reload();
	   			}
	   		}
	   	});
	}
	
	 // 중분류 삭제
    function cateMidDel(categoryMiddleCode) {
    	var ans = confirm("해당 중분류를 삭제하시겠습니까?");
    	if(!ans) return false;
    	$.ajax({
    		type : "post",
    		url  : "${ctp}/admin/cateMidDel",
    		data : {categoryMiddleCode : categoryMiddleCode},
    		success:function(data) {
    			if(data == 0){
    				alert("하위 항목을 먼저 삭제하세요");
    			}
    			else{
    				alert("해당 중분류 항목이 삭제되었습니다");
    				location.reload();
    			}
    		}
    	});
    }