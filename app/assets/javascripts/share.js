$(document).ready(function () {
    var href = window.location.href;
    if (href.indexOf("my_shares") != -1 || href.indexOf("dashboard") != -1) {
        $('.item_block .item_left').mouseover(
            function () {
                $(this).find('.item_actions').css('display', 'block');
            }).mouseout(function () {
                $(this).find('.item_actions').css('display', 'none');
            });
    }
});