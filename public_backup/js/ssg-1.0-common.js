$(document).ready(function () {
	var account_menu_opened = false;
	$('.my_li').click(
		function() {
			if(!account_menu_opened) {
				$('.my_menu').slideDown(200);
				setTimeout(function(){account_menu_opened = true;},100)
			}
		}
	)
	
	$('.my_ul').hover(
		function() {
			
		}, function() {
			if(account_menu_opened) {
				$('.my_menu').slideUp(100);
				setTimeout(function(){account_menu_opened = false;},100)
			}
			
		}
	)
	
	$('.my_menu_item').hover(
		function() {
			$(this).addClass("hover_item");
		}, function() {
			$(this).removeClass("hover_item");
		}
	)
	
	$('.my_menu_item').click(
		function() {
			if(account_menu_opened) {
				$('.my_menu').slideUp(100);
				setTimeout(function(){account_menu_opened = false;},100)
			}
			
		}
	)

});

