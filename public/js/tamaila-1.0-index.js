var IMAGES_TEST = ["http://img04.taobaocdn.com/bao/uploaded/i4/T1g61EXjRiXXXjaoA._083645.jpg_310x310.jpg",
				   "http://img02.taobaocdn.com/tps/i4/T1aTqFXnNaXXXXXXXX-300-278.jpg",
				   "http://img03.taobaocdn.com/bao/uploaded/i3/T1NtumXchBXXbjEKHX_085034.jpg_310x310.jpg",
				   "http://img04.taobaocdn.com/bao/uploaded/i4/T1cm5yXftfXXccOQUV_021431.jpg_310x310.jpg",
				   "http://img02.taobaocdn.com/bao/uploaded/i2/T1oROsXhdEXXcFlxHX_115421.jpg_310x310.jpg"
					];

function Tamaile() {
}

Tamaile.isInLogin = false;

Tamaile.initPage = function() {
	/*$('#login_btn').click(function() {
		if(!Tamaile.isInLogin) {
			$('#home_main').hide();
		}
		$('#loginContainer').slideToggle('slow', function() {
			if(!Tamaile.isInLogin) {
				Tamaile.isInLogin = true;
			} else {
				$('#home_main').show();
				Tamaile.isInLogin = false;
			}
		});
	});*/
	
	
}

$(document).ready(function() {
	$('#img_1').attr("src", IMAGES_TEST[0]);
	$('#img_2').attr("src", IMAGES_TEST[1]);
	$('#img_3').attr("src", IMAGES_TEST[2]);
	$('#img_4').attr("src", IMAGES_TEST[3]);
	
	
	$("#loginBox").dialog({
				autoOpen: false,
				height: 260,
				width: 550,
				modal: true,
				resizable: false,
				/*buttons: {
					"Login": function() {
						 $('#spx_user_registration').submit();
						 alert("Login");
					},
					"Cancel": function() {
						$( this ).dialog( "close" );
					}
				},*/
				close: function() {
					
				}
			});
	
	$( "#index_login" ).click(function() {
					$("#loginBox").dialog("open");	
				})
	
	$(function(){
		$(".why_existing_login").tipTip();
	});
	
})