$(document).ready(function(){
    var $shareLink = $('#share-link');
    var $findUserLink = $('#finduser-link');
    var $inviteLink = $('#invite-link');

    $shareLink.overlay(
        {
            fixed : false,
            onBeforeLoad : function(){
                $(document).mask({
                    closeOnClick: false,
                    color: "#ccc"
                });
            },
            onClose : function() {
                $.mask.close();
                $('#url').attr("value", "");
                $('#overlay-detail').hide();
                $('#overlay-detail-mock').show();
                $('.loading-mask').hide();
            }
        }
    );

    $findUserLink.overlay(
        {
            fixed : false,
            onBeforeLoad : function(){
                $(document).mask({
                    closeOnClick: false,
                    color: "#ccc"
                });
            },
            onClose : function() {
                $.mask.close();
            }
        }
    );

    $inviteLink.overlay(
        {
            fixed : false,
            onBeforeLoad : function(){
                $(document).mask({
                    closeOnClick: false,
                    color: "#ccc"
                });
            },
            onClose : function() {
                $.mask.close();
            }
        }
    );

    // Tracking events
    $shareLink.click(function(){
      _gaq.push(['_trackEvent', 'User', 'Share wish', 'click the share link in dashboard']);
    });

    $findUserLink.click(function(){
      _gaq.push(['_trackEvent', 'User', 'Find friends', 'click the find link in dashboard']);
    });

    $inviteLink.click(function(){
      _gaq.push(['_trackEvent', 'User', 'Invite friends', 'click the invite link in dashboard']);
    });

    // $("ul.myActions").tabs("div.myActions-panel > div");
    // var tabHandler = $("ul.myActions").data("tabs");
    // if(tabHandler){
    //     tabHandler.onBeforeClick(function(){
    //         $('div.myActions-panel').show();
    //     });    
    // }
    
    // $("ul.myActions li").click(function(){
    //     $('div.myActions-panel').show();
    // });
    // var toggleActionPanel = function(event){
    //     if(!$.contains($('div.myActions-panel').get(0), event.toElement?event.toElement:event.target)
    //         && !$.contains($('ul.myActions').get(0), event.toElement?event.toElement:event.target)) {
    //         $('div.myActions-panel').hide();    
    //     }
    // };
    // $(document).click(toggleActionPanel);
    // //$("ul.myActions li").mouseout(toggleActionPanel);
    // //$("div.myActions-panel").mouseout(toggleActionPanel);

    // $("#parseUrl-btn-dash").click(function(){
    //     $("#share-btn").click();
    //     $("input.#url").val($("input.#url-dash").val());
    //     $("input.#url-dash").val("");
    //     $("#collect_item_form").submit();
    // });
});