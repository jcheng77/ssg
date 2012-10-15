$(document).ready(function () {
    $(".category li a").click(function () {
        var url = $(location).attr("href");
        var index = url.indexOf('?');
        if (index != -1) {
            url = url.substring(0, index);
        }

        var action;
        if ($(this).hasClass("checked")) {
            action = "delete"
        } else {
            action = "add"
        }

        var param = "?category_action=" + action + "&category=" + encodeURIComponent($(this).attr("value"));
        $(location).attr("href", url + param);
    });
});
