<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>adminMain.jsp</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
<jsp:include page="/WEB-INF/views/include/nav.jsp"/>
<jsp:include page="/WEB-INF/views/include/adminNav.jsp"/>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type='text/javascript' src='http://www.google.com/jsapi'></script>
<script>
	google.charts.load('current', {packages: ['calendar','corechart']});
	google.charts.setOnLoadCallback(drawCalendarChart);
	google.charts.setOnLoadCallback(drawChart);
	
	function drawCalendarChart() {

        var data = new google.visualization.DataTable();
        data.addColumn({ type: 'date', id: 'Date'});    //x축 타입 date
        data.addColumn({ type: 'number', id: 'Visitant'});            

        // 옵션
        var options = {        
             title: "일별 판매량", 
             height: 350,
             colors: ['#a52714', '#097138']

        };

        var myData = [];    // ajax로 받은 값 넣을 빈 배열

        $.ajax({
               type: "post", 
               url : "${ctp}/admin/saleChart", 
               data : {range:'date'}, 

               success : function(dt){
                   for(let i=0;i<dt.length; i++) {
                       myData.push([new Date(dt[i].wdate), dt[i].count]);    // 배열에 넣기 [new Date('날짜2022-02-10'), 방문수10]
                   }
                   data.addRows(myData);

                var chart = new google.visualization.Calendar(document.getElementById('VisitantCalendarChart')); //VisitantCalendarChart : 빈 div의 아이디
                chart.draw(data, options);
               },

            error : function() {
                alert("전송오류!");
            }
        });
    }
	
	function drawChart() {
        let data = new google.visualization.DataTable();
	    data.addColumn({ type: 'date', id: 'Date'});    //x축 타입 date
	    data.addColumn({ type: 'number', id: 'amount'});
     //옵션
        let chart_options = {
              title : '일별 판매액',
              height : 300,
              bar : {
                 groupWidth : '80%'
              },
              legend : {
                 position : 'none' 
              },
              colors:['#2a9d8f']
        };
        let myData = [];    // ajax로 받은 값 넣을 빈 배열
     $.ajax({
          type: "post", 
          url : "${ctp}/admin/amountChart", 
          data : {range:'date'}, 
          success : function(dt){
              for(let i=0;i<dt.length; i++) {
                myData.push([new Date(dt[i].wdate), dt[i].totalPriceSum]);
              }
              data.addRows(myData);
             let chart = new google.visualization.ColumnChart(document.getElementById('dateAmount'));     
           chart.draw(data, chart_options);
          },
       error : function() {
           alert("전송오류!");
       }
     });
     }
</script>
</head>
<body style="background-color : #171721;">
<div class="container" style="background-color:white; width:1110px;">
<br/><br/>
	<div id="VisitantCalendarChart" class="text-center" style="text-align:center;"></div>
	<div id="dateAmount" class="text-center"></div>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>