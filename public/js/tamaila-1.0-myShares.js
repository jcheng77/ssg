$(document).ready(function () {
	var selected_tab = "ms_menu_item_0";
	$('.ms_menu_item').click(
		function() {
			$('#' + selected_tab).removeClass("selected_m");
			$(this).addClass("selected_m");
			selected_tab = $(this).attr("id");
		}
	)

});