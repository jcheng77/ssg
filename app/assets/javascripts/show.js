$(document).ready(function () {
    var calcActionListPosFunc = function(){
            var verPos = $('.thumbnail').height() - $('.action-list').height() - 12;
            var horPos = $('.thumbnail').width()/2 - $('.action-list').width()/2 - 20;
            $('.action-list').css('top', verPos);
            $('.action-list').css('left', horPos);
        };

    $('.showitem-page .thumbnail img').on({load: calcActionListPosFunc});
    $(window).resize(calcActionListPosFunc);
});