$(document).ready(function () {
    $("body").on("submit", ".plain-tag-form", function () {
        var tag = $("#tag", $(this));
        var content = tag.val();
        if (content == "") {
            alert("请输入标签！");
            return false;
        }
    });
});