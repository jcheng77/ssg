$(function() {
    var b = "#al-mblog",
    a = "#ps-profilemb";
    var c = $.Bom.getSubCookie("sgm", "postalbumid-" + getUSERID()) || 0,
    d = $.Bom.getSubCookie("sgm", "postalbumnm-" + getUSERID()) || "默认专辑";
    $("#al-albumsel").find("input:first").val(c).end().find("a:first").html(d);
    $(b).addClass("al-fetch al-floaded");
    $(a).removeClass("al-fetch al-floaded");
    $("#al-fchk").parent().addClass("tc").html('<div id="al-afterguide" class="f14">啊哦，这张图片好像抓取不到。≡￣﹏￣≡ <br /> 不如换张图片吧，或者<a target="_blank" href="http://www.duitang.com/leave/message/">报错</a>给友礼享！</div>');
    Coll.init(function(e) {
        $("#al-afterguide").html('查看 <a target="_blank" href="/people/mblog/' + e.data.id + '/detail/">我刚收集的</a> <br /><br /> 或者 <a target="_blank" href="/myhome/" style="font-weight:normal;">去我的首页</a> ');
        $({}).delay(3000).queue(function() {
            window.close()
        })
    });
    $("#groupselect").delegate("input[type=radio]", "click",
    function(h) {
        var g = this,
        f = parseInt(g.value);
        $("#al-grpid").attr("value", f)
    })
});