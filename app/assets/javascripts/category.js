$(document).ready(function () {
    var selectCatHandler = function () {
        var anchorVal = $(this).attr("value");
        if(anchorVal == "expend"){
            $("ul.category:eq(1)").fadeIn(500);
            $(this).attr("value", "collapse").html("&lt;");
        } else if (anchorVal == "collapse") {
            $("ul.category:eq(1)").hide();
            $(this).attr("value", "expend").html("&gt;");
        } else if('extra' == $(this).attr("cat-type")){
            $("ul.category:eq(0)").append("<li></li>");
            var newAddCat = $(this).clone();
            newAddCat.attr("href", newAddCat.attr("path-cat"));
            newAddCat.attr("cat-type", "");
            newAddCat.click(selectCatHandler);
            $("ul.category:eq(0) li:last").append(newAddCat);
            $(this).detach();
            
            if($("ul.category:eq(1) a").size() > 0) {
                $("ul.category:eq(1)").hide();
                $(".category li a[value=collapse]").attr("value", "expend").html("&gt;");    
            } else {
                $("ul.category:last").detach();
            }
        } else {
            var el = $(this);
            var toggleClass = el.hasClass("checked");
            $("ul.category:eq(0) a.checked").removeClass("checked");
            if(!toggleClass) {
                el.attr("href", el.attr("path-cat"));
                el.addClass("checked");
            } else {
                el.attr("href", el.attr("path-all"));
            }
        }

        var param = "?category_action=" + action + "&category=" + encodeURIComponent($(this).attr("value"));
        $(location).attr("href", url + param);
    });
});
