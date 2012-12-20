$(document).ready(function () {
	// $("#help_howtouse-btn").overlay({ 
	// 		fixed : false,
	//         onBeforeLoad : function(){
	//             $(document).mask({
	//                 closeOnClick: false,
	//                 color: "#ccc"
	//             });
	//         },
	//         onClose : function() {
 //                $.mask.close();
 //            }
	//     });

	// $("#help_howtoinst-btn").overlay({ 
	// 		fixed : false,
	//         onBeforeLoad : function(){
	//             $(document).mask({
	//                 closeOnClick: false,
	//                 color: "#ccc"
	//             });
	//             var activeInd = getBrowserHelpIndex();
	//             $('#helpTab a:eq(' + activeInd + ')').tab('show');
	//         },
	//         onClose : function() {
 //                $.mask.close();
 //            }
	//     });

	$('#helpTab a').click(function (e) {
		e.preventDefault();
		$(this).tab('show');
	});

	var getBrowserHelpIndex = function(){
		var ind = 0;
		var supBrows = { 
							'ie' : ind ++, 
							'ff' : ind ++, 
							'safari' : ind++,
							'chrome' : ind++
						}
		var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1;
		if(isChrome){
			return supBrows.chrome;
		} else if ($.browser.msie){
			return supBrows.ie;
		} else if ($.browser.mozilla) {
			return supBrows.ff;
		} else if ($.browser.safari) {
			return supBrows.safari;
		} 
	}
});