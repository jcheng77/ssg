$(document).ready(function () {
    $('.items').on({
        mouseover:function () {
            var horPos = $(this).width()/2 - $('.item_actions').width()/2;
            $('.item_actions').css('left', horPos);
            $(this).find('.item_actions').show();
        },
        mouseout:function () {
            $(this).find('.item_actions').hide();
        }
    }, '.item_block .item_left, .browse_item');

    $('.auto_expand').focus(function () {
        var comment = $(this).attr('rows', 2);
        if (comment.parent().find('.auto_show').length == 0) {
            comment.after('<input type="submit" value="评论" name="commit" class="btn btn-primary auto_show">');
        }
    });

    $('#select_from_sys_next').click(
        function () {
            //TODO: Ajax call to get searched item infomation
            $('#select_view').hide();

            $('#select_share_btn').show();
            $('#create_view').show();
        }
    )

    $('#select_again_btn').click(
        function () {
            //TODO: Ajax call to get searched item infomation
            $('#select_view').show();

            $('#select_share_btn').hide();
            $('#create_view').hide();
        }
    )

    $('.searched_item').click(
        function () {
            var text = $(this).children('div:last').html();
            //alert(text);
            $('#search_item_input').val(jQuery.trim(text));
        }
    )

    $('.searched_item').hover(
        function () {
            $(this).addClass("hover_item_bg");
        }, function () {
            $(this).removeClass("hover_item_bg");

        }
    )


    $(function () {
        if ($("#search_item_input").length > 0) {
            if ($.browser.msie) { // IE
                $("#search_item_input").get(0).onpropertychange = handleSearch;
            } else {    // others

                $("#search_item_input").get(0).addEventListener("input", handleSearch, false);

                $("#search_item_input").blur(function () {
                    setTimeout(function () {
                        $('#searched_results').slideUp(100)
                    }, 100);
                });
            }
        }

        function handleSearch() {
            var inputVal = $("#search_item_input").val();
            //TODO: Ajax call to search the result
            $('#searched_results').slideDown(200);
        }
    });

    $('.img_others_item').hover(
        function () {
            $(this).addClass("hover_img_bg");
        }, function () {
            $(this).removeClass("hover_img_bg");

        }
    );

    $('.img_others_item').click(
        function () {
            var s_img_url = $(this).children('img:last').attr("src");
            var b_img_url = s_img_url.replace('40x40', '310x310');

            $('#share_img_src').attr("src", b_img_url);
        }
    );

    $("form ul.tags").bind("keypress", function (e) {
        if (e.keyCode == 13) return false;
    });


    // /**
    // * Function Series for item sharing
    // */
    // $("#share-btn").overlay(
    //     {
    //         fixed : false,
    //         onBeforeLoad : function(){
    //             $(document).mask({
    //                 closeOnClick: false,
    //                 color: "#ccc"
    //             });
    //         },
    //         onClose : function() {
    //             $.mask.close();
    //             $('#url').attr("value", "");
    //             $('#overlay-detail').hide();
    //             $('#overlay-detail-mock').show();
    //             $('.loading-mask').hide();
    //             $('#collectInput').attr("value", "");
    //         }
    //     }
    // );

    // use UJS ajax call event: https://github.com/rails/jquery-ujs/wiki/ajax
    $('#collect_item_form').on('ajax:before',function () {
        var parseUrl = $('#url').attr("value");
        if(!parseUrl || parseUrl.trim() == ""){
            return false;
        }
                    
        $('#overlay-detail').hide();
        $('#overlay-detail-mock').show();
        $('.loading-mask').show()
            .height($('form#share-form-mock').height())
            .width($('form#share-form-mock').width());
    }).on('ajax:error', function (xhr, status, error) {
        $('.loading-mask').hide();
        alert("出错啦！");
    });

});
