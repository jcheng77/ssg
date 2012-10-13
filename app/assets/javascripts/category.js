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
            newAddCat.click();

            var allBtn = $(".category li a:first");
            var newCat = " " + newAddCat.attr("value");
            allBtn.attr("value", allBtn.attr("value") + newCat);
            allBtn.attr("href", allBtn.attr("href") + encodeURIComponent(newCat));
        } else {
            var el = $(this);
            var toggleClass = el.hasClass("checked");
            $("ul.category:eq(0) a.checked").removeClass("checked");
            el.addClass("checked");
            if(toggleClass) {
                return false;
            }
        }
        //TODO: 根据选中category加载tags和items, 未选中则加载第一个category列表中所有类别对应的tags和items

        // var url = $(location).attr("href");
        // var index = url.indexOf('?');
        // if (index != -1) {
        //     url = url.substring(0, index);
        // }

        // var action;
        // if ($(this).hasClass("checked")) {
        //     action = "delete"
        // } else {
        //     action = "add"
        // }

        // var param = "?category_action=" + action + "&category=" + encodeURIComponent($(this).attr("value"));
        // $(location).attr("href", url + param);
    };

    $(".category li a").click(selectCatHandler);
    $(".category li a:first").click();
});
