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

  $('#input_buy_url_next').click(
    function() {
    //TODO: Ajax call to get taobao item infomation
    //$('#select_view').hide();

    //$('#select_share_btn').show();
    //$('#create_view').show();

    // get the id from taobao url

    var url = $('#taobao_url')[0].value;
    var regTaobaoId = new RegExp('.*[?&]id=(\\d+).*');
    var regNumber = new RegExp('^\\d+$');

    if(url.match(regTaobaoId)){
      //location.href='/items/new?id=' + url.replace(regTaobaoId, "$1");
      location.href='/collect?url=' + url;
    }else if(url.match(regNumber)){
      //location.href='/items/new?id=' + url;
      location.href='/collect?url=' + url;
    }else{
      alert ('请输入有效的宝贝链接或商品ID')
    }
  }
  )

  $('#select_from_sys_next').click(
    function() {
    //TODO: Ajax call to get searched item infomation
    $('#select_view').hide();

    $('#select_share_btn').show();
    $('#create_view').show();
  }
  )

  $('#select_again_btn').click(
    function() {
    //TODO: Ajax call to get searched item infomation
    $('#select_view').show();

    $('#select_share_btn').hide();
    $('#create_view').hide();
  }
  )

  $('.searched_item').click(
    function() {
    var text = $(this).children('div:last').html();
    //alert(text);
    $('#search_item_input').val(jQuery.trim(text));
  }
  )

  $('.searched_item').hover(
    function() {
    $(this).addClass("hover_item_bg");
  }, function() {
    $(this).removeClass("hover_item_bg");

  }
  )


  $(function() {
    if($("#search_item_input").length > 0) {
      if($.browser.msie) { // IE
        $("#search_item_input").get(0).onpropertychange = handleSearch;
      } else {    // others

        $("#search_item_input").get(0).addEventListener("input", handleSearch, false);

        $("#search_item_input").blur(function() {
          setTimeout(function(){$('#searched_results').slideUp(100)}, 100);
        });
      }
    }

    function handleSearch() {
      var inputVal = $("#search_item_input").val();
      //TODO: Ajax call to search the result
      $('#searched_results').slideDown(200);
    }
  });

  $('div#rating_comp').raty({
    readOnly:  false,
    start: $('div#rating_comp').attr("stars"),
    scoreName: $('div#rating_comp').attr("scoreName"),
    path: '/images/smallStars',
    hintList:     ['', '', '', '', '']
  });

  $('.img_others_item').hover(
    function() {
    $(this).addClass("hover_img_bg");
  }, function() {
    $(this).removeClass("hover_img_bg");

  }
  )

  $('.img_others_item').click(
    function() {
    var s_img_url = $(this).children('img:last').attr("src");
    var b_img_url = s_img_url.replace('40x40', '310x310');

    $('#share_img_src').attr("src", b_img_url);
  }
  )
});
