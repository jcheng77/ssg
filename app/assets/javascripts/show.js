$(document).ready(function () {
    
    var calcActionListPosFunc = function(){
        var verPos = $('.thumbnail').height() - $('.count-list').height() - 12;
        var horPos = $('.thumbnail').width()/2 - $('.count-list').width()/2 - 20;
        $('.count-list').css('top', verPos);
        $('.count-list').css('left', horPos);
    };

    $('.showitem-page .thumbnail img').load(calcActionListPosFunc);
    $(window).resize(calcActionListPosFunc);

    $('.thumbnail').on({
        mouseover:function () {
            var horPos = $(this).width()/2 - $('.item_actions').width()/2;
            $('.item_actions').css('left', horPos);
            $(this).find('.item_actions').show();
        },
        mouseout:function () {
            $(this).find('.item_actions').hide();
        }
    });
});