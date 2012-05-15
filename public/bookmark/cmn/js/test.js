// JavaScript Document

(function() {
    function k(a, b, g) {
        a.attachEvent ? (a["e" + b + g] = g, a[b + g] = function() {
            a["e" + b + g](window.event)
        },
        a.attachEvent("on" + b, a[b + g])) : a.addEventListener(b, g, !1)
    }
    function l(a, b) {
        return a.className.match(RegExp("(\\s|^)" + b + "(\\s|$)"))
    }
    var c = !!window.ActiveXObject,
    n = c && !window.XMLHttpRequest,
    h = function(a) {
        for (var a = a.split(","), b = a.length, g = [], o = 0; o < b; o++) {
            var c = document.getElementById(a[o]);
            c && g.push(c)
        }
        return g
    },
    i = function(a, b) {
        if (document.getElementsByClassName) return (b || document).getElementsByClassName(a);
        else {
            b = b || document;
            tag = "*";
            for (var g = [], c = tag === "*" && b.all ? b.all: b.getElementsByTagName(tag), d = c.length, a = a.replace(/\-/g, "\\-"), e = RegExp("(^|\\s)" + a + "(\\s|$)"); --d >= 0;) e.test(c[d].className) && g.push(c[d]);
            return g
        }
    },
    m = function() {
        for (var a = h("testShareBg,testShareToolBar,testShareContent,testShareScript,testShareStyle"), b = a.length, c = 0; c < b; c++) {
            var d = a[c],
            e = d.parentNode;
            e && e.removeChild(d)
        }
    };
    if (h("testShareToolBar").length != 0) m();
     else if (!/taobao.com/i.test(location.hostname) && !/tmall.com/i.test(location.hostname)) alert("\u4e0d\u80fd\u5206\u4eab\u672c\u7ad9\u56fe\u7247\u54e6\u3002");
	
    else if (function(a) {
        var b = /tmall.com/i,
        c = /auction\d?.paipai.com/i,
        d = /buy.caomeipai.com\/goods/i,
        e = /www.360buy.com\/product/i,
        h = /product.dangdang.com\/Product.aspx\?product_id=/i,
        i = /book.360buy.com/i,
        j = /www.vancl.com\/StyleDetail/i,
        k = /www.vancl.com\/Product/i,
        l = /vt.vancl.com\/item/i,
        m = /item.vancl.com\/\d+/i,
        n = /mbaobao.com\/pshow/i,
        p = /[www|us].topshop.com\/webapp\/wcs\/stores\/servlet\/ProductDisplay/i,
        q = /quwan.com\/goods/i,
        r = /nala.com.cn\/product/i,
        s = /maymay.cn\/pitem/i,
        t = /asos.com/i;
        return /item(.lp)?.taobao.com\/(.?)[item.htm|item_num_id|item_detail|itemID|item_id|default_item_id]/i.test(a) || b.test(a) || i.test(a) || e.test(a) || c.test(a) || d.test(a) || h.test(a) || j.test(a) || k.test(a) || l.test(a) || m.test(a) || n.test(a) || p.test(a) || q.test(a) || r.test(a) || s.test(a) || t.test(a)
    } (location.href)) c = [],
    c.push("http://localhost/bookmarklet.html"),
    c.push("?"),
    c.push("type=goods&"),
    c.push("goods=" + encodeURIComponent(location.href)),
    location.href = c.join("");
    else {
        for (var j = [], p = function(a) {
            var b = new Image;
            b.src = a.src;
            return {
                w: b.width,
                h: b.height,
                src: b.src
            }
        },
        q = function(a) {
            var b = "";
            n && (b += "width:" + a.w + "px;height:" + a.h + "px;");
            Math.max(a.h, a.w) > 199 ? a.h < a.w && (b += "margin-top: " + parseInt(100 - 100 * (a.h / a.w)) + "px;") : b += "margin-top: " + parseInt(100 - a.h / 2) + "px;";
            return b
        },
        e = 0; e < document.images.length; e++) {
            var d = document.images[e],
            d = p(d);
            if (d.w > 80 && d.h > 80 && (d.h > 109 || d.w > 109)) d = '<div class="mgsFeed"><img class="mgsPic" style="{style}" src="{picUrl}"><div class="mgsSize"><span>{width}x{height}</span></div></div>'.replace(/{style}/, q(d)).replace(/{picUrl}/, d.src).replace(/{width}/, d.w).replace(/{height}/, d.h),
            j.push(d)
        }
        e = '<div id="testShareBg"></div><div id="testShareToolBar"><a class="testPub" href="javascript:;"></a><a class="testCancel" href="javascript:;"></a><span class="testNotice">\u8bf7\u9009\u62e9\u8981\u53d1\u8868\u7684\u56fe\u7247\uff08\u53ef\u591a\u9009\uff09</span><a href="####"><img class="testLogo" src="http://localhost/cmn/img/logo_20110712.png"></a><div class="testShadow"></div></div>' + '<div id="testShareContent">{content}</div>'.replace(/{content}/, j.join(""));
        j = document.createElement("div");
        j.innerHTML = e;
        document.body.appendChild(j);
        c ? (f = document.createElement("style"), f.type = "text/css", f.media = "screen", f.id = "testShareStyle", f.styleSheet.cssText = n ? 'body{background-attachment:fixed; background-image:url("about:blank");}#testShareBg {background-color:#f2f2f2; height:expression(document.body.clientHeight); width:100%; left:0px; zoom:1; z-index:100000; FILTER:alpha(opacity=80); position:absolute; top:expression(document.compatMode && document.compatMode=="CSS1Compat" ? documentElement.scrollTop:document.body.scrollTop ); } #testShareContent {position:absolute; top:66px; left:0; z-index:100001; } #testShareContent .mgsFeed {width:200px; height:200px; border-right:1px solid #e7e7e7; border-bottom:1px solid #e7e7e7; float:left; cursor:pointer; text-align:center; background-color:#FFF; overflow:hidden; position:relative; } #testShareContent .mgsPic {max-height:200px; max-width:200px; } #testShareContent .mgsSize {position:absolute; bottom:5px; left:0; width:200px; text-align:center; } #testShareContent .mgsSize span {display:inline-block; background-color:#FFF; border-radius:4px; padding:0 2px; } #testShareContent .mgsSelect {position:absolute; right:0px; bottom:0px; width:61px; height:60px; FILTER:progid:DXImageTransform.Microsoft.AlphaImageLoader(src="http://localhost/cmn/img/bar_select.png",sizingMethod="image"); background-image:none } #testShareToolBar {position:absolute; top:expression(document.compatMode && document.compatMode=="CSS1Compat" ? documentElement.scrollTop:document.body.scrollTop ); left:0; z-index:100002; height:75px; width:100%; overflow:hidden; background:url(http://localhost/cmn/img/bar_bg.png) top repeat-x; } #testShareToolBar .testShadow {position:absolute; width:100%; height:9px; overflow:hidden; top:65px; left:0; FILTER:progid:DXImageTransform.Microsoft.AlphaImageLoader(src="http://localhost/cmn/img/bar_bg_sd.png",sizingMethod="scale"); background-image:none } #testShareToolBar .testLogo {position:absolute; right:25px; top:15px; } #testShareToolBar .testPub {position:absolute; left:25px; top:8px; width:156px; height:49px; background:url(http://localhost/cmn/img/bar_pub.png) no-repeat; } #testShareToolBar .testCancel {position:absolute; left:185px; top:22px; width:72px; height:21px; background:url(http://localhost/cmn/img/bar_cancel.png) no-repeat; }#testShareToolBar .testNotice{position: absolute;font-size:14px;top:23px;left:270px;color:#fff}': "#testShareBg {background-color:#f2f2f2; height:100%; width:100%; left:0px; top:0px; zoom:1; position:fixed; z-index:100000; opacity:0.8; FILTER:alpha(opacity=80); } #testShareContent {position:absolute; top:66px; left:0; z-index:100001; } #testShareContent .mgsFeed {width:200px; height:200px; border-right:1px solid #e7e7e7; border-bottom:1px solid #e7e7e7; float:left; cursor:pointer; text-align:center; background-color:#FFF; overflow:hidden; position:relative; } #testShareContent .mgsPic {max-height:200px; max-width:200px; } #testShareContent .mgsSize {position:absolute; bottom:5px; left:0; width:200px; text-align:center; } #testShareContent .mgsSize span {display:inline-block; background-color:#FFF; border-radius:4px; padding:0 2px; } #testShareContent .mgsSelect {position:absolute; right:0px; bottom:0px; width:61px; height:60px; background:url(http://localhost/cmn/img/bar_select.png) 0 0 no-repeat; } #testShareToolBar {position:fixed; top:0; left:0; z-index:100002; height:75px; width:100%; overflow:hidden; background:url(http://localhost/cmn/img/bar_bg.png) top repeat-x; } #testShareToolBar .testShadow {position:absolute; width:100%; height:9px; overflow:hidden; top:65px; left:0; background:url(http://localhost/cmn/img/bar_bg_sd.png) repeat-x; } #testShareToolBar .testLogo {position:absolute; right:25px; top:15px; } #testShareToolBar .testPub {position:absolute; left:25px; top:8px; width:156px; height:49px; background:url(http://localhost/cmn/img/bar_pub.png) no-repeat; } #testShareToolBar .testCancel {position:absolute; left:185px; top:22px; width:72px; height:21px; background:url(http://localhost/cmn/img/bar_cancel.png) no-repeat; }#testShareToolBar .testNotice{position: absolute;font-size:14px;top:23px;left:270px;color:#fff}", document.getElementsByTagName("head")[0].appendChild(f)) : (f = document.createElement("style"), f.id = "testShareStyle", f.innerHTML = "#testShareBg {background-color:#f2f2f2; height:100%; width:100%; left:0px; top:0px; zoom:1; position:fixed; z-index:100000; opacity:0.8; FILTER:alpha(opacity=80); } #testShareContent {position:absolute; top:66px; left:0; z-index:100001; } #testShareContent .mgsFeed {width:200px; height:200px; border-right:1px solid #e7e7e7; border-bottom:1px solid #e7e7e7; float:left; cursor:pointer; text-align:center; background-color:#FFF; overflow:hidden; position:relative; } #testShareContent .mgsPic {max-height:200px; max-width:200px; } #testShareContent .mgsSize {position:absolute; bottom:5px; left:0; width:200px; text-align:center; } #testShareContent .mgsSize span {display:inline-block; background-color:#FFF; border-radius:4px; padding:0 2px; } #testShareContent .mgsSelect {position:absolute; right:0px; bottom:0px; width:61px; height:60px; background:url(http://localhost/cmn/img/bar_select.png) 0 0 no-repeat; } #testShareToolBar {position:fixed; top:0; left:0; z-index:100002; height:75px; width:100%; overflow:hidden; background:url(http://localhost/cmn/img/bar_bg.png) top repeat-x; } #testShareToolBar .testShadow {position:absolute; width:100%; height:9px; overflow:hidden; top:65px; left:0; background:url(http://localhost/cmn/img/bar_bg_sd.png) repeat-x; } #testShareToolBar .testLogo {position:absolute; right:25px; top:15px; } #testShareToolBar .testPub {position:absolute; left:25px; top:8px; width:156px; height:49px; background:url(http://localhost/cmn/img/bar_pub.png) no-repeat; } #testShareToolBar .testCancel {position:absolute; left:185px; top:22px; width:72px; height:21px; background:url(http://localhost/cmn/img/bar_cancel.png) no-repeat; }#testShareToolBar .testNotice{position: absolute;font-size:14px;top:23px;left:270px;color:#fff}", document.body.appendChild(f));
        window.scrollTo(0, 0);
        c = i("testCancel", h("testShareToolBar")[0], "a");
        k(c[0], "click",
        function() {
            m()
        });
        for (var c = i("mgsFeed", h("testShareContent")[0]), j = c.length, e = 0; e < j; e++) k(c[e], "click",
        function() {
            if (l(this, "checked")) {
                var a = i("mgsSelect", this),
                a = a[0],
                b = a.parentNode;
                b && b.removeChild(a);
                if (l(this, "checked")) this.className = this.className.replace(/(\s|^)checked(\s|$)/, " ")
            } else l(this, "checked") || (this.className += " checked"),
            a = document.createElement("i"),
            a.className = "mgsSelect",
            this.appendChild(a);
            a = i("checked", h("testShareContent")[0]).length;
            i("testNotice", h("testShareToolBar")[0])[0].innerHTML = a == 0 ? "\u8bf7\u9009\u62e9\u8981\u53d1\u8868\u7684\u56fe\u7247\uff08\u53ef\u591a\u9009\uff09": '\u5df2\u9009\u62e9<em style="color:#690;font-weight: bold;padding:0 2px;">' + a + "</em>\u5f20\u56fe\u7247"
        });
        c = i("testPub", h("testShareToolBar")[0]);
        k(c[0], "click",
        function() {
            var a = [];
            a.push("http://localhost/bookmarklet.html");
            a.push("?");
            var b = i("checked", h("testShareContent")[0]),
            c = b.length;
            if (c < 1) alert("\u8bf7\u9009\u62e9\u81f3\u5c11\u4e00\u5f20\u56fe\u7247\u3002");
            else if (c > 50) alert("\u4e00\u6b21\u6700\u591a\u53ea\u80fd\u5206\u4eab50\u5f20\u56fe\u7247\u3002");
            else {
                for (var d = 0; d < c; d++) {
                    var e = i("mgsPic", b[d])[0].src;
                    a.push("pics[]=" + encodeURIComponent(e) + "&")
                }
                a.push("type=img");
                window.open(a.join(""), "testShare" + (new Date).getTime(), "status=no,resizable=no,scrollbars=yes,personalbar=no,directories=no,location=no,toolbar=no,menubar=no,left=0,top=0");
                m()
            }
        })
    }
})();