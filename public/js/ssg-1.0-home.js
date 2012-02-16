var tmout = null;
var selected_cycle_num = 0;
$(document).ready(function () {

	// transition effect
	style = 'easeOutQuart';

	// if the mouse hover the image
	$('.inner_border').hover(
		function() {
			//display heading and caption
			var self = this;
			$(self).parent().addClass("hoverItem");
			tmout = setTimeout(function(){
				$(self).children('div:last').stop(false,true).animate({bottom:0},{duration:200, easing: style});
				}, 200)
			
		},

		function() {
			//hide heading and caption
			if(tmout) {
				clearTimeout(tmout);
				tmout = null;
			}
			$(this).children('div:last').stop(false,true).animate({bottom:-85},{duration:200, easing: style});
			$(this).parent().removeClass("hoverItem");
		}
	);
	
	$('div#fixed_rating_star').raty({
		readOnly:  true,
		start: $('div#fixed_rating_star').attr("stars"),
		path: '/images/smallStars',
		hintList:     ['', '', '', '', '']
	});
	
	var cycles_opened = false;
	$('.cycles_selected').click(
		function() {
			if(selected_cycle_num == 0) {
				$("li.c_first").hide();
			}
			if(!cycles_opened) {
				$(this).addClass("white_bg");
				$('#cycle_f_i').focus();
				$('.cycles_all').slideDown(200);
				setTimeout(function(){cycles_opened = true;},100)
			}
		}
	)
	
	$('.cycles_selected').hover(
		function() {
			
		}, function() {
			if(selected_cycle_num == 0) {
				$("li.c_first").show();
			}
			
			if(cycles_opened) {
				$('.cycles_all').slideUp(100);
				$('.cycles_selected').removeClass("white_bg");
				setTimeout(function(){cycles_opened = false;},100)
			}
			
		}
	)
	
	$('.cycle_item').hover(
		function() {
			$(this).addClass("hover_item");
		}, function() {
			$(this).removeClass("hover_item");
		}
	)
	
	$('.cycle_item').click(
		function() {
			if(cycles_opened) {
				$('.cycles_selected').children('li:last').before('<li class="c_selected"><span>' + $('a', this).html() + ' </span><a href="#" onclick="removeme(event);return false;" class="remove_cycle">x</a></li>');
				selected_cycle_num++;
				$('.cycles_all').slideUp(100);
				$('.cycles_selected').removeClass("white_bg");
				setTimeout(function(){cycles_opened = false;},100)
			}
			
		}
	)
	
	var previous_tags_id = null;
	var selected_tags_id = null;
	var previous_obj = $('#my_favor_categories');
	$('#my_favor_categories').click(
		function() {
			if(selected_tags_id) {
				var _id  = '#' + selected_tags_id;
				$(_id).slideUp(200);
				previous_tags_id = null;
				selected_tags_id = null;
			}
			
			if(previous_obj) {
				$(previous_obj).removeClass("secondary_color");
				$(previous_obj).children('div:first').removeClass("category_right_icon");
			}
			
			$(this).addClass("secondary_color");
			$(this).children('div:first').addClass("category_right_icon");
			previous_obj = this;
		}
	)
	
	$('.category_title').click(
		function() {
			previous_tags_id = selected_tags_id;
			selected_tags_id = $(this).attr("tId");
			if(previous_obj) {
				$(previous_obj).removeClass("secondary_color");
				$(previous_obj).children('div:first').removeClass("category_right_icon");
			}
			$(this).addClass("secondary_color");
			$(this).children('div:first').addClass("category_right_icon");
			previous_obj = this;
			if(previous_tags_id != selected_tags_id) {
				var _id  = '#' + previous_tags_id;
				$(_id).slideUp(200);
			}
			
			if(selected_tags_id != previous_tags_id) {
				var _id  = '#' + selected_tags_id;
				$(_id).slideDown(200);
			}
			
		}
	)
	
	$('#other_categories_title').click(
		function() {
			if(selected_tags_id) {
				var _id  = '#' + selected_tags_id;
				$(_id).slideUp(200);
				previous_tags_id = null;
				selected_tags_id = null;
			}
			
			if(previous_obj) {
				$(previous_obj).removeClass("secondary_color");
				$(previous_obj).children('div:first').removeClass("category_right_icon");
			}
			
			$(this).addClass("secondary_color");
			$(this).children('div:first').addClass("category_right_icon");
			previous_obj = this;
			
			$('#other_categories_separator').show();
			$('#categories_others').slideDown(200);
		}
	)
	
	var selected_tab = "ms_menu_item_0";
	$('.ms_menu_item').click(
		function() {
			$('#' + selected_tab).removeClass("selected_m");
			$(this).addClass("selected_m");
			selected_tab = $(this).attr("id");
		}
	)

});

function removeme(event) {
	var evt=event?event:window.event;
        evt.stopPropagation();
	
	var p = evt.target.parentNode;
	var p_p = p.parentNode;
	p_p.removeChild(p);
	
	selected_cycle_num--;
	
	if(selected_cycle_num == 0) {
		$("li.c_first").show();
	}
}