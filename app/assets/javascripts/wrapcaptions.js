/* 
 $name:		JQ Captions
 $version:	1.0
 $filename:	jq.captions.js
 $author:	ben@igoo
 $modified:	2008/07/04 17:10
 */

$(document).ready(function () {
    $("img.captionme").each(function (i) {
        var captiontext = $(this).attr('title');
        var captiontype = $(this).attr('type');
        $(this).wrap("<div class='imgpost'></div>");
        $(this).parent().append("<div class='thecaption " + captiontype + "'>" + captiontext + "</div>");
    });
});