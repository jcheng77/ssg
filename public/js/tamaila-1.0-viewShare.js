var tmout = null;
var selected_cycle_num = 0;
$(document).ready(function () {
	
	$('div#item_rating').raty({
		readOnly:  true,
		start: $('div#item_rating').attr("stars"),
		path: '/images/smallStars',
		hintList:     ['', '', '', '', '']
	});
	
	$('.the_same_shares_item_img').hover(
		function() {
			$(this).addClass("img_hover");
			
		},

		function() {
			$(this).removeClass("img_hover");
		}
	);
	
	$('.add_like_btn').click(
		function() {
			//TODO: Ajax call to save like info
			$('#comment_content_text').val("I like this shirt. The style and color both looks great!");
			
		}
	);
	
	$('.add_wish_btn').click(
		function() {
			//TODO: Ajax call to save wish info
			var text = $('#comment_content_text').val() + " ";
			$('#comment_content_text').val(text + "I love this one! Will you send it to me as my birthday present?");
			
		}
	);
	

});
