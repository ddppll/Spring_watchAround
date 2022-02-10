

//네비바 고정 설정
$(document).ready(function(){
    $(window).scroll(function(){
        var scroll = $(window).scrollTop();
        if (scroll > 1) {
            $(".navbar").css("background", "unset");
            $(".navbar").css("color","white");
            $(".collapse .nav-link").css("color","white");  
            $("#fas").css("color","white"); 
            
            
        }
        else{
            
            $(".navbar").css("background","#000000");
            $(".navbar").css("opacity","0.8");
            $(".collapse .nav-link").css("color","white");
            $(".fas").css("color","unset");
        }
    })
})

