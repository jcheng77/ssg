$(document).ready(function () {
    var selectCatHandler = function () {
        var anchorVal = $(this).attr("value");
        if (anchorVal == "expend") {
            $("ul.category:eq(1)").fadeIn(500);
            $(this).attr("value", "collapse").html("&lt;");
        } else if (anchorVal == "collapse") {
            $("ul.category:eq(1)").hide();
            $(this).attr("value", "expend").html("&gt;");
        } else if ('extra' == $(this).attr("cat-type")) {
            $("ul.category:eq(0)").append("<li></li>");
            var newAddCat = $(this).clone();
            newAddCat.attr("href", newAddCat.attr("path-cat"));
            newAddCat.attr("cat-type", "");
            newAddCat.click(selectCatHandler);
            $("ul.category:eq(0) li:last").append(newAddCat);
            $(this).detach();

            if ($("ul.category:eq(1) a").size() > 0) {
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
            if (toggleClass) {
                return false;
            }
        }
    };

    var selectTagHandler = function () {
        var link = $(this);
        var tags = "";
        link.parent().toggleClass("active");
        $("ul.category-tags li").each(function () {
            var el = $(this);
            if (el.hasClass("active")) {
                tags += $("a:first", el).attr("tag") + " ";
            }
        });
        var href = link.attr("path") + "?category=" + encodeURIComponent(link.attr("categories")) + "&tag=" + encodeURIComponent(tags);
        link.attr("href", href);
    };

    $(".category li a").click(selectCatHandler);
    $("#hot_tags").on("click", ".category-tags li a", selectTagHandler);
    $(".category li a:first").click();
});
