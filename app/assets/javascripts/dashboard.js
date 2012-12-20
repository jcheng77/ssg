$(document).ready(function(){
    var $shareLink = $('#share-link');
    var $findUserLink = $('#finduser-link');
    var $inviteLink = $('#invite-link');

    // $shareLink.overlay(
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
    //         }
    //     }
    // );

    // $findUserLink.overlay(
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
    //         }
    //     }
    // );

    // $inviteLink.overlay(
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
    //         }
    //     }
    // );

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

    var moreBtn = $("#more");
    var noticeBar = $("#notice");
    var progressBar = $("#progress_more");
    var sharePanel = $("#shares");

    var ShareController = {
        clearNotice:function () {
            noticeBar.hide().empty();
        },
        appendShare:function (html) {
            sharePanel.append(html).children("li:last").hide().fadeIn(2000);
        },
        notFound:function () {
            noticeBar.html("没有新的愿望动态。").show();
        },
        noMore:function () {
            moreBtn.addClass("finished");
            moreBtn.hide();
        },
        hasMore:function () {
            if (!this.autoLoad()) {
                moreBtn.show();
            }
        },
        autoLoad:function () {
            var page = parseInt(moreBtn.attr("page"));
            return page < 5 ? true : false
        }
    };

    $(function () {
        var arrivedAtBottom = function () {
            return $(document).scrollTop() + $(window).height() == $(document).height();
        }

        $(window).scroll(function () {
            if (arrivedAtBottom()) {
                if (!moreBtn.hasClass("finished")) {
                    if (ShareController.autoLoad()) {
                        moreBtn.click();
                    } else {
                        moreBtn.show();
                    }
                }
            }
        });

        moreBtn.click(function () {
            var page = parseInt(moreBtn.attr("page")) + 1;
            moreBtn.attr("page", page);
            var href = window.location.href + "?page=" + page;
            moreBtn.attr("href", href);
        });

        moreBtn.on("ajax:before",
                function () {
                    moreBtn.hide();
                    progressBar.show();
                }
        ).on("ajax:complete",
                function () {
                    progressBar.hide();
                }
        );

        moreBtn.click();
    });
});