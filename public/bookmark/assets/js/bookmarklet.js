/*
TEST-collect-tool produced by TEST.com
author balibell
*/
(function(c, t) {
    if (t.TEST_COLLECT) {
        return
    }
    t.TEST_COLLECT = 1;
    var n = c.location,
    e = n.href,
    x = navigator.userAgent,
    v = t.body,
    q = v.parentNode,
    V = x.indexOf("MSIE") >= 0 && x.indexOf("Opera") < 0,
    P = V ? navigator.appVersion.split(";")[1].replace(/[ ]/g, "") : "",
    C = P == "MSIE6.0",
    w = P == "MSIE7.0",
    u = P == "MSIE8.0",
    Y = x.indexOf("Opera") >= 0 ? true: false,
    h = /(webkit)[ \/]([\w.]+)/.exec(x.toLowerCase()),
    af = "http://www.TEST.com/collect/",
    s;
    function m(i, b, d) {
        if (i.addEventListener) {
            i.addEventListener(b, d, false)
        } else {
            if (i.attachEvent) {
                i.attachEvent("on" + b, d)
            } else {
                i["on" + b] = d
            }
        }
    }
    function I() {
        var b = window,
        d = document;
        if (b.getSelection) {
            return b.getSelection().toString()
        } else {
            if (d.getSelection) {
                return d.getSelection()
            } else {
                if (d.selection) {
                    return d.selection.createRange().text
                }
            }
        }
    }
    function N(D, H) {
        var A = D.slice(0, H),
        B = A.replace(/[^\x00-\xff]/g, "**").length;
        if (B <= H) {
            return A
        }
        B -= A.length;
        switch (B) {
        case 0:
            return A;
        case H:
            return D.slice(0, H >> 1);
        default:
            var d = H - B,
            b = D.slice(d, H),
            z = b.replace(/[\x00-\xff]/g, "").length;
            return z ? D.slice(0, d) + N(b, z) : D.slice(0, d)
        }
    }
    function j(z, B, i, d) {
        var A = d ? z.substr(0, B) : N(z, B);
        return A == z ? A: A + (typeof i === "undefined" ? "…": i)
    }
    function S() {
        var i, b, d, A, z = t.documentElement;
        if (c.innerHeight && c.scrollMaxY) {
            i = v.scrollWidth;
            b = c.innerHeight + c.scrollMaxY
        } else {
            if (v.scrollHeight > v.offsetHeight) {
                i = v.scrollWidth;
                b = v.scrollHeight
            } else {
                i = v.offsetWidth;
                b = v.offsetHeight
            }
        }
        if (self.innerHeight) {
            d = self.innerWidth;
            A = self.innerHeight
        } else {
            if (z && z.clientHeight) {
                d = z.clientWidth;
                A = z.clientHeight
            } else {
                if (v) {
                    d = v.clientWidth;
                    A = v.clientHeight
                }
            }
        }
        if (b < A) {
            pageHeight = A;
            y = pageHeight
        } else {
            pageHeight = b;
            y = pageHeight
        }
        if (i < d) {
            pageWidth = d
        } else {
            pageWidth = i
        }
        return [pageWidth, pageHeight, d, A]
    }
    function k(i, d) {
        if (i[0] && i[1] && d[0]) {
            if (!d[1]) {
                d[1] = d[0]
            }
            if (i[0] > d[0] || i[1] > d[1]) {
                var A = i[0] / i[1],
                z = A >= d[0] / d[1];
                return z ? [d[0], parseInt(d[0] / A)] : [parseInt(d[1] * A), d[1]]
            }
        }
        return i
    }
    function G(d, b) {
        b = b || 100000000;
        if (d[0].w && d[0].h) {
            for (var D = 0,
            B = d.length; D < B; D++) {
                d[D].power = -1 / b * Math.abs(d[D].w * d[D].h - b) + 1
            }
        } else {
            var A, H, z;
            for (var D = 0,
            B = d.length; D < B; D++) {
                A = new Image();
                A.src = d[D].src;
                H = A.width;
                z = A.height;
                d[D].power = -1 / b * Math.abs(H * z - b) + 1
            }
        }
        d.sort(function(L, i) {
            if (L.power > i.power) {
                return - 1
            } else {
                return 1
            }
        });
        return d
    }
    function F(A) {
        var z = A.width,
        U = A.height;
        A.removeAttribute("width");
        A.removeAttribute("height");
        var L = A.width,
        D = A.height;
        A.setAttribute("width", z);
        A.setAttribute("height", U);
        var A = A.cloneNode(true),
        W = A.getAttribute("data-src"),
        b = W ? W: A.src,
        H = [150, 150],
        B = [200, 200];
        var d = k([L, D], B),
        i = k([L, D], H);
        return {
            w: L,
            h: D,
            sw: d[0],
            sh: d[1],
            ssw: i[0],
            ssh: i[1],
            st: (B[1] - d[1]) / 2,
            sst: (H[1] - i[1]) / 2,
            src: b,
            img: A,
            alt: A.alt
        }
    }
    function Q() {
        var A = [],
        z = document.images;
        for (var d = 0; d < z.length; d++) {
            var b = F(z[d]);
            if (b.w >= 80 && b.h >= 80) {
                A.push(b)
            }
        }
        if (A.length) {
            return G(A)
        } else {
            return []
        }
    }
    function g(i, d) {
        var b = af;
        b += "?img=" + encodeURIComponent(i) + "&url=" + encodeURIComponent((i == e ? t.referrer || e: e).replace(/&ref=[^&]+/ig, "").replace(/&ali_trackid=[^&]+/ig, "")) + "&alt=" + encodeURI(j(d, 60)) + "&title=" + encodeURI(j(t.title, 80)) + "&desc=" + encodeURI(j(I(), 100));
        c.open(b, "TEST" + new Date().getTime(), "status=no,resizable=no,scrollbars=no,personalbar=no,directories=no,location=no,toolbar=no,menubar=no,width=830,height=530,left=60,top=80")
    }
    function Z() {
        var b = [[/^https?:\/\/.*?\.?TEST\.com\//, "很抱歉，不能抓取本站的图片噢，请到其他网站抓取吧~"], [/^file/, "本地电脑里的图片是不能抓取的，去网页上抓取图片吧~"]];
        for (var d = 0; d < b.length; d++) {
            if (b[d][0].test(e)) {
                alert(b[d][1]);
                return false
            }
        }
        return true
    }
    if (!Z()) {
        t.TEST_COLLECT = 0;
        return
    }
    var R = Q();
    if (R.length <= 0) {
        alert("本页面没有适合的图片，请换一个页面试试吧~");
        t.TEST_COLLECT = 0;
        return
    }
    function ai() {
        var b = aj.parentNode;
        b.removeChild(aj);
        b.removeChild(ae);
        t.TEST_COLLECT = 0;
        if (!C) {
            v.style.paddingRight = J;
            q.style.overflowX = X;
            q.style.overflowY = T;
            v.style.overflowX = ad;
            v.style.overflowY = ac
        }
        return false
    }
    var ao = "TEST_",
    o = "#" + ao + "main",
    ap = "background",
    r = "position:relative",
    aq = ap + "-color:",
    p = "url(http://www.TEST.com/img/0/collout.gif?123)",
    aa = "z-index:90000000",
    ah = [" #", ao, "mask{position:fixed;", aa, "0;top:0;right:0;bottom:0;left:0;", aq, " #000;opacity:.7;filter:alpha(opacity=70);} ", o, "{position: absolute;width:100%;line-height:1.2;padding:0;", aa, "1;top:0;left:0;", aq, "transparent;} #", ao, "container{zoom:1;width:904px;margin:0 auto;padding-bottom:24px;color:#666} #", ao, "container:after{content:'\\0020';display:block;height:0;overflow:hidden;clear:both;} #", ao, "panel{", r, ";float:right;", aa, "4;height:0px;width:0px;} #", ao, "panel a:link,#", ao, "panel a:visited{position:fixed;_position:absolute;top:12px;right:30px;_right:12px;width:80px;height:80px;padding:0;margin:0;", aq, "transparent;", ap, "-image:", p, "} #", ao, "panel a:hover{", ap, "-position:0 -80px} ", o, " .", ao, "unit{", r, ";float:left;+display:inline;padding:0;margin:0;height:200px;width:200px;overflow:hidden;margin:24px 12px 0;", aa, "2;border:1px solid #e7e7e7;text-align: center;", aq, "#fff;} ", o, " .", ao, "unit .tpmImg{", r, ";width:100%;height:100%;margin:0;padding:0;} ", o, " .", ao, "unit a{display:block;overflow:hidden;width:200px;height:200px;margin:0;padding:0;text-align:center;", ap, ":none !important} ", o, " .", ao, "unit img{display:block;padding:0;margin:0 auto;border:0 none;vertical-align:top;} ", o, " .", ao, "unit a *{cursor:pointer} ", o, " .", ao, "unit_sm,", o, " .", ao, "unit_sm a{width:150px;height:150px;} ", o, " .", ao, "dimen{", r, ";width:56px;margin:-16px auto 0;padding:0 2px 1px;text-align:center;font-size:10px;font-family:tahoma,arial,sans-serif;", aa, "3;", ap, ":#000;opacity:.9;filter:alpha(opacity=90);border-radius:3px;color:#fff} ", o, " .", ao, "cover{position:absolute;width:200px;height:200px;top:0;left:0;", aq, "#000;opacity:.15;filter:alpha(opacity=15);display:none} ", o, " .", ao, "cross{position:absolute;width:100px;height:59px;line-height:16px;padding:41px 0 0;top:50px;left:50px;", ap, ":", p, " no-repeat 0 -160px;border:0 none;} ", o, " .", ao, "action:link .", ao, "cross,", o, " .", ao, "action:visited .", ao, "cross{display:none;} ", o, " .", ao, "action:hover .", ao, "cross,", o, " .", ao, "action:hover .", ao, "cover{display:block;} ", o, " .", ao, "unit_sm .", ao, "cross{top:25px;left:25px;} ", o, " .", ao, "seper{float:left;border-top:1px solid #eaeaea;padding:24px 0 0;margin:24px 0 0;color:#ebebeb;font:normal 16px/20px tahoma;} ", o, " img{margin:0 auto} "].join(""),
    l = S(),
    al = (l[0] - 904) / 2,
    a = "TESTSHEET",
    M = t.getElementById(a),
    aj = t.createElement("div"),
    ae = t.createElement("div"),
    an = t.createElement("div"),
    K = t.createElement("div");
    ah += "#TEST_main{width:auto}#TEST_main .TEST_seper{width:" + l[0] + "px;margin-left:-" + al + "px;padding-left:" + (al + 12) + "px}";
    if (C) {
        ah += "#TEST_mask{position:absolute;width:" + l[0] + "px;height:" + l[1] + "px;}"
    }
    if (!M || M.tagName.toLowerCase() !== "style") {
        M = t.createElement("style");
        M.id = "TESTSHEET";
        if (V) {
            M.type = "text/css";
            M.styleSheet.cssText = ah;
            t.getElementsByTagName("head")[0].appendChild(M)
        } else {
            if ((x.lastIndexOf("Safari/") > 0) && parseInt(x.substr(x.lastIndexOf("Safari/") + 7, 7)) < 533) {
                M.innerText = ah;
                v.appendChild(M)
            } else {
                M.innerHTML = ah;
                v.appendChild(M)
            }
        }
    }
    aj.setAttribute("id", "TEST_mask");
    m(aj, "click", ai);
    v.appendChild(aj);
    if (t.defaultView) {
        var J = t.defaultView.getComputedStyle(v).paddingRight,
        X = t.defaultView.getComputedStyle(q).overflowX,
        T = t.defaultView.getComputedStyle(q).overflowY,
        ad = t.defaultView.getComputedStyle(v).overflowX,
        ac = t.defaultView.getComputedStyle(v).overflowY
    } else {
        if (q.currentStyle) {
            var J = v.currentStyle.paddingRight,
            X = q.currentStyle.overflowX,
            T = q.currentStyle.overflowY,
            ad = v.currentStyle.overflowX,
            ac = v.currentStyle.overflowY
        }
    }
    if (!C) {
        var O = ae.style;
        v.style.paddingRight = "17px";
        v.style.overflowY = v.style.overflowX = O.overflowX = "hidden";
        if (V || Y) {
            q.style.overflowY = q.style.overflowX = "hidden"
        }
        O.overflowY = "scroll";
        O.top = Math.max(v.scrollTop || 0, t.documentElement.scrollTop || 0) + "px";
        O.width = (l[0] + (w ? 17 : u ? 17 : 0)) + "px";
        O.height = l[3] + "px"
    }
    ae.setAttribute("id", "TEST_main");
    m(ae, "click",
    function(z) {
        var i = z.srcElement || z.target,
        b = i.tagName.toLowerCase(),
        d = i.parentNode.tagName.toLowerCase();
        if (b !== "a" && b !== "img" && d !== "a" && i.className !== "TEST_dimen") {
            ai()
        }
    });
    v.appendChild(ae);
    an.setAttribute("id", "TEST_container");
    ae.appendChild(an);
    var f = {},
    ag = "",
    ak = "",
    E = 0,
    ab = 0;
    for (var am = 0; am < R.length; am++) {
        if (!f[R[am].src]) {
            if (R[am].power < 0.00015) {
                ak = "TEST_unit_sm";
                E = R[am].sst;
                imw = R[am].ssw;
                imh = R[am].ssh;
                if (typeof ab != "string") {
                    ab = '<div class="TEST_seper" ' + (ab == s ? "": 'style="border-top:0 none;margin-top:0;"') + ">喂！↓_↓这些图片太小啦，你确定要收集到堆糖吗？</div>"
                }
            } else {
                ab = s;
                E = R[am].st;
                imw = R[am].sw;
                imh = R[am].sh
            }
            ag += [ab, '<div class="TEST_unit ', ak, '"><div class="tpmImg"><a class="TEST_action" href="javascript:;"><img style="margin-top:', E, 'px" width="', imw, '" height="', imh, '" src="', R[am].src, '" alt="', R[am].alt, '" /><div class="TEST_cover"></div><div class="TEST_cross"></div></a></div><div class="TEST_dimen">', R[am].w, "x", R[am].h, "</div></div>"].join("");
            f[R[am].src] = 1;
            if (ab) {
                ab = ""
            }
        }
    }
    an.innerHTML = ag;
    m(an, "click",
    function(A) {
        A = A || c.event;
        var z = A.srcElement || A.target,
        b = z.tagName.toLowerCase(),
        i = z.parentNode.tagName.toLowerCase(),
        d;
        if (i === "a" || b === "a") {
            if (i === "a") {
                z = z.parentNode
            }
            d = z.getElementsByTagName("img")[0];
            if (d) {
                g(d.src, d.getAttribute("alt"))
            }
        }
    });
    K.id = "TEST_panel";
    K.innerHTML = '<a id="TEST_closelink" href="javascript:;" target="_self" title="关闭"></a>';
    ae.insertBefore(K, an);
    t.getElementById("TEST_closelink").onclick = ai
})(window, document);