$(document).ready(function () {
    $("body").on("submit", ".plain-tag-form", function () {
        var content = $("#tag", $(this)).val();
        if (content == "") {
            alert("请输入标签！");
            return false;
        } else {
            // commit
        }
    });
});