$(document).ready(function () {
	$('.showitem-page .thumbnail').on({
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