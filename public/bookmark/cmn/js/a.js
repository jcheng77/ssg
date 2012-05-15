(function() {
    ImportJavscript = {
        url: function(a) {
            document.write('<script type="text/javascript" src="' + a + '"><\/script>')
        }
    }
})();
function aaa(a) {}
function getUSERID() {
    if (typeof USER !== "undefined" && USER.ID) {
        return USER.ID
    } else {
        return ""
    }
}
function isSTAFF() {
    if (typeof USER !== "undefined" && USER.ISSTAFF) {
        return true
    } else {
        return false
    }
}
if (!Array.prototype.indexOf) {
    Array.prototype.indexOf = function(c, b) {
        if (b == null) {
            b = 0
        } else {
            if (b < 0) {
                b = Math.max(0, this.length + b)
            }
        }
        for (var a = b; a < this.length; a++) {
            if (this[a] === c) {
                return a
            }
        }
        return - 1
    }
}
if (!String.prototype.lenB) {
    String.prototype.lenB = function() {
        return this.replace(/[^\x00-\xff]/g, "**").length
    }
}
if (!String.prototype.leftB) {
    String.prototype.leftB = function(h) {
        var g = this,
        d = g.slice(0, h),
        f = d.replace(/[^\x00-\xff]/g, "**").length;
        if (f <= h) {
            return d
        }
        f -= d.length;
        switch (f) {
        case 0:
            return d;
        case h:
            return g.slice(0, h >> 1);
        default:
            var b = h - f,
            a = g.slice(b, h),
            c = a.replace(/[\x00-\xff]/g, "").length;
            return c ? g.slice(0, b) + a.leftB(c) : g.slice(0, b)
        }
    }
}
if (!String.prototype.cut) {
    String.prototype.cut = function(g, d, c) {
        var f = this;
        r = c ? f.substr(0, g) : f.leftB(g);
        return r == f ? r: r + (typeof d === "undefined" ? "…": d)
    }
}
function blinkIt(d, b, a, f, c) {
    c = c || 1000;
    if (f === 0) {
        a();
        return
    }
    if ($.isFunction(d)) {
        d()
    }
    window.setTimeout(function() {
        blinkIt(b, d, a, --f, c)
    },
    c)
}
function refresh() {
    window.location.href = window.location.href.replace(/#.*$/ig, "")
}
function addURLParam(c, f) {
    var b = c.indexOf("?") == -1 ? "?": "&";
    c += b;
    for (var d in f) {
        c += d.toString() + "=" + encodeURIComponent(f[d]) + "&"
    }
    return c.slice(0, -1)
}
function fromSelector(h, c) {
    var d = h.split(" "),
    g = d[d.length - 1],
    i = g.match(/^[a-z]+/ig) || "div",
    j = (g.match(/\.[a-z_-]+/ig) || "").toString().substr(1),
    f = (g.match(/#[a-z_-]+/ig) || "").toString().substr(1);
    return c ? {
        tagName: i,
        id: f,
        "class": j
    }: $("<" + i + ">").attr({
        "class": j,
        id: f
    })
}
function getNum(a) {
    return a ? parseInt(a.replace(/^([^\d]*)/g, "")) || 0 : 0
}
function getFitSize(d, c) {
    if (d[0] && d[1] && c[0]) {
        if (!c[1]) {
            c[1] = c[0]
        }
        if (d[0] > c[0] || d[1] > c[1]) {
            var g = d[0] / d[1],
            f = g >= c[0] / c[1];
            return f ? [c[0], parseInt(c[0] / g)] : [parseInt(c[1] * g), c[1]]
        }
    }
    return d
}
function setImgSize(b, a, f) {
    b.onload = null;
    b.removeAttribute("width");
    b.removeAttribute("height");
    var c = b;
    if (c && c.width && c.height && a) {
        if (!f) {
            f = a
        }
        if (c.width > a || c.height > f) {
            var g = c.width / c.height,
            d = g >= a / f;
            b[d ? "width": "height"] = d ? a: f;
            if (document.all) {
                b[d ? "height": "width"] = (d ? a: f) * (d ? 1 / g: g)
            }
        }
    }
    b.style.visibility = "visible"
}
function setImgSizeByAncestor(f, b) {
    f.onload = null;
    var d = $(f).parent(b)[0];
    if (d) {
        var c = parseInt($(d).css("width"));
        c = c ? c: d.offsetWidth;
        setImgSize(f, c)
    }
}
function getCursorPosition(b) {
    var a = {
        text: "",
        start: 0,
        end: 0
    };
    b.focus();
    if (b.setSelectionRange) {
        a.start = b.selectionStart;
        a.end = b.selectionEnd;
        a.text = (a.start != a.end) ? b.value.substring(a.start, a.end) : ""
    } else {
        if (document.selection) {
            var c, d = document.selection.createRange(),
            f = document.body.createTextRange();
            f.moveToElementText(b);
            a.text = d.text;
            a.bookmark = d.getBookmark();
            for (c = 0; f.compareEndPoints("StartToStart", d) < 0 && d.moveStart("character", -1) !== 0; c++) {
                if (b.value.charAt(c) == "\n") {
                    c++
                }
            }
            a.start = c;
            a.end = a.text.length + a.start
        }
    }
    return a
}
function setCursorPosition(b, a) {
    if (!a) {
        alert("You must get cursor position first.")
    }
    if (b.setSelectionRange) {
        b.focus();
        b.setSelectionRange(a.start, a.end)
    } else {
        if (b.createTextRange) {
            var c = b.createTextRange();
            if (b.value.length === a.start) {
                c.collapse(false);
                c.select()
            } else {
                c.moveToBookmark(a.bookmark);
                c.select()
            }
        }
    }
}
function simpleMarqueeW(b, f, i, d) {
    var j = $(b),
    h = j.parent();
    if (j.children().length) {
        var f = f || 4000,
        i = i || 2,
        d = d || 20,
        l, m = false,
        c, k;
        var a = function() {
            c = j.children().first();
            k = c.outerWidth(true);
            clearInterval(l);
            l = setInterval(g, d)
        };
        var g = function() {
            if (m) {
                return
            }
            if (h.scrollLeft() + i >= k) {
                clearInterval(l);
                j.append(c);
                h.scrollLeft(0);
                setTimeout(a, f)
            } else {
                h.scrollLeft(h.scrollLeft() + i)
            }
        };
        j.mouseover(function() {
            m = true
        });
        j.mouseout(function() {
            m = false
        });
        setTimeout(a, f)
    }
}
function simpleMarqueeH(b, f, h, d) {
    var i = $(b);
    if (i.children().length) {
        var f = f || 4000,
        h = h || 2,
        d = d || 20,
        k, l = false,
        c, j;
        var a = function() {
            c = i.children().first();
            j = c.outerHeight(true);
            clearInterval(k);
            k = setInterval(g, d)
        };
        var g = function() {
            if (l) {
                return
            }
            if (i.scrollTop() + h >= j) {
                clearInterval(k);
                i.append(c);
                i.scrollTop(0);
                setTimeout(a, f)
            } else {
                i.scrollTop(i.scrollTop() + h)
            }
        };
        i.mouseover(function() {
            l = true
        });
        i.mouseout(function() {
            l = false
        });
        setTimeout(a, f)
    }
}
function bindChecks(g, b, c) {
    var a = $("input[type=checkbox]", b);
    $id = $(g);
    function d(f) {
        var h = [];
        if (f.prop("checked")) {
            a.each(function(k, j) {
                $(j).prop("checked", true);
                h.push(j.value)
            })
        } else {
            a.each(function(k, j) {
                $(j).prop("checked", false)
            })
        }
        f.val(h.join())
    }
    if (c) {
        $id.prop("checked", true)
    } else {
        if (c !== undefined) {
            $id.prop("checked", false)
        }
    }
    d($id);
    $id.click(function() {
        d($(this))
    });
    a.click(function() {
        var f = $.trim($id.val()) ? $id.val().split(",") : [],
        h = this.value;
        f = $(f).filter(function(k, j) {
            return j !== h
        }).get();
        if (this.checked) {
            f.push(h)
        }
        $id.val(f.join())
    })
}
function checkLink(f, j) {
    var h = /^http(?:s)?:\/\/[^\n\s\t]+$/i;
    var d = $.trim(f).match(h);
    if (d) {
        if (j) {
            var c = false;
            for (var g = 0; g < j.length; g++) {
                var k;
                if (d[1] && (k = d[1].split(j[g])) && k[1] === "") {
                    c = true
                }
            }
            return c
        } else {
            return true
        }
    }
    return false
}
function hashAnalize(a) {
    var b = window.location.hash.substr(1),
    c;
    c = a.indexOf(b);
    return c = c < 0 ? -1 : c
}
function getSelectedText() {
    var a = window,
    b = document;
    if (a.getSelection) {
        return a.getSelection().toString()
    } else {
        if (b.getSelection) {
            return b.getSelection()
        } else {
            if (b.selection) {
                return b.selection.createRange().text
            }
        }
    }
}
function getToken(d) {
    var b = {},
    a = "",
    c = "",
    h = "",
    g = $("input", "#form-token");
    if (a = $.Bom.getCookie("csrftoken")) {
        c = "csrfmiddlewaretoken=" + a;
        b.csrfmiddlewaretoken = a
    } else {
        if (g.length) {
            a = g.val();
            b[g.attr("name")] = a;
            c = $.param(b)
        }
    }
    h = '<input type="hidden" name="csrfmiddlewaretoken" value="' + a + '" />';
    return d ? d == 3 ? h: d == 2 ? b: a: c
}
function mergeServerMessage(c) {
    var b = "";
    if ($.isArray(c)) {
        for (var a = 0; a < c.length; a++) {
            b += c[a][1] + ","
        }
        b = b.slice(0, -1)
    } else {
        if ($.isPlainObject(c)) {
            for (e in c) {
                b += c[e].join(",") + ";"
            }
            b = b.slice(0, -1)
        } else {
            b = c
        }
    }
    return b
}
function dtImageTrans(b, d, a, f, g) {
    if (!b) {
        return ""
    }
    if (d) {
        a = a || 0;
        f = f || 0;
        g = g ? "_c": "";
        return b.replace(/(\.[a-z]+)$/ig, ".thumb." + a + "_" + f + g + "$1")
    } else {
        return b.replace(/(?:\.thumb\.\w+|\.[a-z]+!\w+)(\.[a-z]+)$/ig, "$1")
    }
}
function recurseDo(c, a, f, b, d) {
    if (f == 0) {
        if ($.isFunction(d)) {
            d()
        }
        return
    }
    a = c.apply(null, a);
    if (a[0].length) {
        setTimeout(function() {
            recurseDo(c, a, --f, b, d)
        },
        b)
    } else {
        if ($.isFunction(d)) {
            d()
        }
    }
} (function() {
    ImportJavscript = {
        url: function(a) {
            document.write('<script type="text/javascript" src="' + a + '"><\/script>')
        }
    }
})(); (function(a) {
    a.fn.at = function(l, d, b) {
        if (!getUSERID()) {
            return this
        }
        var g;
        if (typeof l !== "function") {
            b = d;
            d = l;
            l = a.noop
        }
        if (typeof d !== "string") {
            b = d;
            d = ""
        }
        b = a.extend({},
        a.fn.at.defaults, b);
        function i() {
            g.css({
                display: "block"
            })
        }
        function c() {
            g.css({
                display: "none"
            })
        }
        function j(q, u) {
            var A = q.offset(),
            s = [];
            if (b.position == 0) {
                s = [A.top + q.outerHeight(true), A.left]
            } else {
                if (b.position == 1) {
                    var z = q.val().replace(/ /ig, "f"),
                    x = g.data("cursor").pos,
                    w = z.substr(0, x),
                    x = w.lastIndexOf("@") + 1,
                    w = z.substr(0, x),
                    t = z.slice(x),
                    p;
                    var y = a("#testdiv");
                    if (!y.length) {
                        y = a('<div id="testdiv"></div>').css({
                            position: "relative",
                            width: q.css("width"),
                            height: q.css("height"),
                            lineHeight: q.css("lineHeight"),
                            paddingLeft: q.css("paddingLeft"),
                            paddingRight: q.css("paddingRight"),
                            paddingTop: q.css("paddingTop"),
                            paddingBottom: q.css("paddingBottom"),
                            fontSize: q.css("fontSize"),
                            fontFamily: q.css("fontFamily")
                        }).insertAfter(q)
                    }
                    y.html((w + '<span id="at-cursor"></span>' + t).replace(/\n/ig, "<br/>"));
                    var o = a("#at-cursor").position();
                    s = [o.top + q.offset().top + 20, o.left + q.offset().left];
                    if (b.upper) {
                        s[0] -= 22 + g.outerHeight()
                    }
                    y.remove()
                }
            }
            return s
        }
        function k(s, p) {
            var o = j(s, p),
            q;
            if (a.browser.msie && a.browser.version === "6.0" || !b.isFixed) {
                g.css({
                    position: "absolute",
                    top: o[0],
                    left: o[1]
                })
            } else {
                g.css({
                    position: "fixed",
                    top: o[0] - a(window).scrollTop(),
                    left: o[1] - a(window).scrollLeft()
                })
            }
        }
        function m(q) {
            var s = g.data("atlist"),
            p = g.data("pglist"),
            u = a.isArray(p),
            o = [],
            t = [],
            v = b.pCounts;
            if (!q && (!p || !p.length)) {
                g.html('<div class="zero">@礼友 TA能收到你的消息</div>');
                return true
            }
            if (u && !q) {
                s = p
            } else {
                if (u) {
                    s = s.concat(p)
                }
            }
            if (s && s.length) {
                a(s).each(function(x, z) {
                    var y = new RegExp("^" + q, "ig"),
                    w = "<li>" + z.name + "</li>";
                    if (z.name.match(y) && a.inArray(w, o) === -1) {
                        o.push(w)
                    } else {
                        if (a.inArray(w, o) === -1) {
                            t.push(z)
                        }
                    }
                });
                if (o.length < v) {
                    a(t).each(function(x, z) {
                        var y = new RegExp("^" + q, "ig");
                        var w = z.search_str.split(" ");
                        if (w[1] && w[1].match(y)) {
                            o.push("<li>" + z.name + "</li>");
                            t.splice(x, 1)
                        }
                    })
                }
                if (o.length < v) {
                    a(t).each(function(x, z) {
                        var y = new RegExp(q, "ig");
                        var w = z.search_str.split(" ");
                        if (z.name.match(y) || q.length > 1 && w[0].match(y)) {
                            o.push("<li>" + z.name + "</li>")
                        }
                    })
                }
                if (o.length) {
                    o[0] = o[0].replace("<li>", '<li class="cur">');
                    g.html('<div>想@谁？<span class="gray f12">(最多10次)</span></div><ul>' + o.slice(0, v).join("") + "</ul>");
                    return true
                }
            }
            return false
        }
        function f(y) {
            var u = a(this).filter("textarea,input");
            if (!u.length) {
                return
            }
            if (!g) {
                n()
            }
            if (y.type == "blur" || y.type == "focusout") {
                g.delay(150).queue(function() {
                    c();
                    a(this).dequeue()
                });
                g.removeData("pglist");
                return
            }
            if (y.type === "keydown" && g.css("display") !== "none" && y.keyCode === 13) {
                y.preventDefault();
                a("li:first", g).click();
                return
            } else {
                if (y.type === "keydown" && g.css("display") !== "none" && (y.keyCode === 38 || y.keyCode === 40)) {
                    y.preventDefault();
                    var w = a("li", g),
                    x = w.length,
                    B = w.index(a(".cur", g).removeClass("cur")),
                    E = y.keyCode - 39,
                    s;
                    B += E;
                    B = B < 0 ? 0 : B > x ? x: B;
                    g.find("li").eq(B).addClass("cur");
                    return
                } else {
                    if (y.type === "keydown" && y.keyCode === 8) {
                        var t = u.val(),
                        z = getCursorPosition(this).end || 0,
                        p = t.charAt(z - 1);
                        if (p === " ") {
                            var C = t.substr(0, z - 1),
                            D = C.match(/@[\u4e00-\u9fa5_a-zA-Z0-9-]*$/ig),
                            o = D ? D.toString().length: 0;
                            if (o && o <= b.nameLen) {
                                y.preventDefault();
                                u.val(t.slice(0, z - o) + t.slice(z - 1));
                                setCursorPosition(this, {
                                    start: z - o,
                                    end: z - o
                                })
                            }
                        }
                    }
                }
            }
            if (y.type == "keyup" && y.keyCode != 13 && y.keyCode != 38 && y.keyCode != 40 || y.type == "click") {
                var z = getCursorPosition(this).end || 0,
                C = u.val().substr(0, z),
                D = C.match(/@[\u4e00-\u9fa5_a-zA-Z0-9-]*$/ig),
                o = D ? D.toString().length: 0,
                A,
                q;
                if (C.split("@").length > b.aNumber) {
                    c();
                    return
                }
                g.data("cursor", {
                    target: this,
                    pos: z
                });
                if (o && o <= b.nameLen) {
                    h();
                    D = D ? D.toString().substr(1) : "";
                    if (m(D)) {
                        k(u, y);
                        i()
                    } else {
                        c()
                    }
                } else {
                    c()
                }
            }
        }
        function h() {
            var p = "",
            o = [];
            if ((p = b.pageMembers) && !g.data("pglist")) {
                a(p).each(function(q, t) {
                    var s = a.trim(a(t).text());
                    if (a.inArray(s, o) === -1 && s !== "我") {
                        o.push(s)
                    }
                });
                g.data("pglist", a.map(o,
                function(s, q) {
                    return {
                        name: s,
                        search_str: ""
                    }
                }))
            }
        }
        function n() {
            g = a("#PL-at");
            if (!g.length) {
                g = a('<div id="PL-at" class="PL-at"></div>').appendTo("body");
                g.delegate("li", "mouseover",
                function(o) {
                    var p = a(this);
                    p.parent().find(".cur").removeClass("cur");
                    p.addClass("cur")
                });
                g.delegate("li", "click",
                function(u) {
                    g.clearQueue();
                    var y = g.data("cursor"),
                    q = y.target,
                    z = q.value,
                    x = y.pos,
                    o = a(".cur", g).text(),
                    w = z.slice(0, x),
                    t = z.slice(x),
                    s = w.replace(/@[^@]*$/ig, "@" + o + " ") + t,
                    A = s.length - t.length,
                    p;
                    a(q).val(s);
                    setCursorPosition(q, {
                        start: A,
                        end: A
                    });
                    c()
                })
            }
            if (!a.isArray(g.data("atlist"))) {
                g.data("atlist", []);
                a.ajax({
                    type: "GET",
                    cache: true,
                    url: "/mention/complete/",
                    timeout: 20000,
                    success: function(p) {
                        var o = a.isPlainObject(p) ? p: a.parseJSON(p);
                        if (!o) {
                            return
                        }
                        if (o.success) {
                            g.data("atlist", o.data)
                        } else {
                            g.removeData("atlist");
                            SUGAR.PopOut.alert('<div class="prompt prompt-fail"><h3>' + o.message + "</h3></div>")
                        }
                    }
                })
            }
        }
        if (d) {
            this.delegate(d, "keydown keyup click blur", f)
        } else {
            this.bind("keydown keyup click blur", f)
        }
        return this
    };
    a.fn.at.defaults = {
        upper: false,
        isFixed: false,
        pCounts: 10,
        nameLen: 20,
        position: 1,
        pageMembers: "",
        aNumber: 10
    }
})(jQuery);
var UPTOKEN;
function upPicCallBack(d) {
    var h = $("#al-mblog"),
    f = $("#al-pics"),
    a = $("#al-mbimg"),
    i;
    $("input[type=file]", "#al-upbtn").val("");
    if (d.tid == UPTOKEN) {
        if (d.success) {
            a.val(d.picid);
            Coll.reset("al-uloaded");
            f.addClass("loading");
            $('<img id="up-img"/>').css("display", "none").bind("load",
            function() {
                setImgSize(this, 620, 278);
                $(this).css("display", "inline");
                f.removeClass("loading")
            }).attr("src", dtImageTrans(d.src, 1, 180, 180, 1)).appendTo("#al-pics")
        } else {
            Coll.reset();
            var b = $(".al-size", "#al-mblog"),
            c = b.html(),
            g = new RegExp(d.message, "ig");
            b.html(c.replace(g,
            function(j) {
                return '<span class="red">' + j + "</span>"
            }))
        }
    }
}
Coll = function() {
    var o, l, h = "#al-tagsipt",
    f = "#al-tagssel",
    d, m, t = "#al-fipt",
    c = "#al-fchk",
    g = "#form-al-fetchpic",
    u, i, s, q, p, j, a = "#al-albu",
    n = "#form-al-upic",
    b = 300,
    k;
    return {
        init: function(D, y) {
            if (Coll.inited) {
                return
            }
            Coll.inited = true;
            var z = '<div id="al-mblog"><div class="al-head"><a class="al-close" href="javascript:;">close</a><h1>友礼享工具抓取</h1></div><div class="al-prepost"><div class="al-covb"></div><div class="al-covh"></div><div class="clr al-covv"><div class="al-updv"><a id="al-upbtn" href="javascript:;" class="abtn abtn-i dib al-upbtn"><u>上传图片</u><form id="form-al-upic" target="alupifr" enctype="multipart/form-data" method="POST" action="/upload/photo/"><input name="img" hidefoucs="true" type="file"><input type="hidden" name="tid" value=""/><iframe name="alupifr" src="about:blank" class="dn" scrolling="no" frameborder="0" height="0" width="0"></iframe><input type="hidden" name="type" value="blog"/></form></a></div><div class="al-size gray">· 仅支持jpg、gif、png图片格式 <br />· 文件要小于2M <br />· 图片分辨率要大于80x80 <br />· 如果有图片来源，<br /><span class="vh">· </span>请务必标注来源和原创作者</div><div class="al-fedv"><div class="al-fchk gray" id="al-fchk">拷贝完整的网址，我们将帮你保存网页的图片和地址。</div><form action="/mblog/fetch/" method="post" target="_self" id="form-al-fetchpic"><input type="text" value="http://" autocomplete="off" class="ipt" name="url" id="al-fipt"><div class="tc"><a target="_self" href="javascript:;" class="abtn abtn-s dib" id="al-fchab"><button type="submit"><u>确定</u></button></a></div></form></div><div id="al-loading"></div></div></div><form id="form-al-poststatus" action="/people/mblog/add/" method="post" target="_blank" ><div id="al-bepost" class="al-bepost clr"><div class="al-part-lf"><a class="r dn" style="margin-right:-20px" href="javascript:Coll.reset();">取消</a><div id="al-source"><div id="al-fesour">来源：<span></span></div> <input type="text" autocomplete="off" id="sourcelink-ed" class="ipt" value=""><input type="hidden" id="sourcetitle" name="source_title" value=""/><input type="hidden" id="sourcelink"  name="source_link" value=""/><div id="bindsourcelink" class="al-lkwd" >链接：<span>暂无链接</span></div><p id="sourcelinkcheck" class="red" ></p></div><div id="al-pics"></div><!-- 输入框 --><div class="al-cxa"><textarea name="content" class="txa" id="al-txa"></textarea><span class="alrmn dn"><b id="al-rmn">140</b> 字</span><label for="al-txa" id="al-txa-lb">写点有营养的介绍吧，使这次收集更加有意义。</label></div><div class="u-chk al-subbtn clr"><a class="abtn abtn-s l" href="javascript:;" target="_self"><button id="al-abtnpost" type="submit"><u>发布</u></button></a><input type="checkbox" checked name="syncpost" class="chk s-sina" value="sina" id="al-sync"><label for="al-sync" title="同步到新浪微博" class="s-sina" >同步</label><div class="al-mbsite s-sina">新浪</div><a class="l" id="al-lastset" href="javascript:;">上次设置</a><div id="al-poststat"></div></div></div><!-- lfpart end --><div class="al-part-rg"><!-- 专辑区域 --><div class="al-album"><h6>选择专辑</h6><div id="al-albumsel" class="al-albumsel"><input type="text" name="album" value="" data-optional="1"/><a class="al-shw" href="javascript:;">未分类</a></div></div><!-- 标签区域 --><div class="al-subtag"><h6>添加标签</h6><textarea id="al-tagsipt" data-optional="1" class="txa" name="tags" autocomplete="off"></textarea><label style="display: inline;" for="al-tagsipt" id="al-tagsipt-lb">多个标签用空格隔开</label></div><h6>常用标签</h6><div id="al-tagssel" class="usetag clr"></div><!-- 友礼享工具 --><div class="al-ftip">亲爱的礼友：强烈建议5秒钟设置浏览器 <a target="_blank" href="/about/collectit/">【收集工具】</a> 插件，超快捷保存任何网站的图片和地址。</div><input id="al-sourcetype" type="hidden" name="source" value=""/><input id="al-grpid" type="hidden" name="group" value/><input type="hidden" value="" name="photo_id" id="al-mbimg" /><input type="hidden" value="" name="" id="al-picinpt" /></div></div></form></div><form id="form-myalbumlist" method="post" action="/album/collect/list/"><input type="hidden" name="user_id" value="' + getUSERID() + '"/><input type="hidden" name="count" value="0"/></form>';
            var x = $("#win-house");
            x = x.length ? x: $('<div id="win-house" class="h0"></div>').appendTo("body");
            x.append(z);
            $(f).append($("#al-statusetag").html());
            $("#al-grpid").val($("#al-grpid-avanat").val());
            o = $("#al-mblog");
            l = $("#al-txa");
            s = $("#al-upbtn");
            q = $("#al-albumsel");
            u = $("#al-picinpt");
            i = $("#al-mbimg");
            j = $("#al-pics");
            d = $("#form-al-poststatus");
            m = $("#al-abtnpost");
            l.at({
                isFixed: true,
                upper: true
            });
            p = q.find("a").myalbums({
                sel_valueipt: q.find("input[name=album]"),
                sel_holder: o
            });
            $("#al-enup,#al-enfe,#mynavtools-src,#mynavtools-local").click(function(v) {
                v.stopPropagation();
                v.preventDefault();
                $.blockUI({
                    message: o,
                    baseZ: 9000,
                    css: {
                        top: "50%",
                        left: "50%",
                        textAlign: "left",
                        marginLeft: "-480px",
                        marginTop: "-273px",
                        width: "960px",
                        height: "546px",
                        border: "none",
                        background: "none"
                    }
                });
                var H = this.id,
                G = 0;
                if (H == "al-enup" || H == "mynavtools-local") {
                    G = 1
                } else {
                    if (H == "al-enfe" || H == "mynavtools-src") {
                        G = 2
                    }
                }
                Coll.switchType(G)
            });
            o.find("a.al-close").click($.unblockUI);
            $(t).focus(function(G) {
                var v = this;
                if ($.browser.webkit) {
                    setTimeout(function() {
                        v.select()
                    },
                    10)
                } else {
                    v.select()
                }
                $(c).removeClass("red").addClass("gray").html("拷贝完整的网址，我们将帮你保存网页的图片和地址。")
            });
            var w = s.find("input[type=file]");
            s.mousemove(function(G) {
                var H = $(this),
                v = H.offset();
                w.css({
                    left: G.pageX - v.left - 70,
                    top: G.pageY - v.top - 10
                })
            });
            w.change(function() {
                Coll.upLoadSubmit()
            });
            $(g).submit(function(v) {
                v.preventDefault();
                Coll.doFetchPic($(this))
            });
            if (typeof BIND_SITES == "undefined" || !BIND_SITES.sina) {
                o.find(".s-sina").remove()
            }
            $(h).focus(function(v) {
                Coll.showLabel(this, "#al-tagsipt-lb", true)
            }).blur(function() {
                Coll.showLabel(this, "#al-tagsipt-lb")
            });
            l.bind("focus click",
            function(v) {
                v.stopPropagation();
                Coll.showLabel(this, "#al-txa-lb", true)
            }).blur(function() {
                Coll.showLabel(this, "#al-txa-lb")
            });
            var E = l.val();
            if (!E) {
                $("#al-txa-lb").css("display", "inline")
            }
            E = $(h).val();
            if (!E) {
                $("#al-tagsipt-lb").css("display", "inline")
            }
            setDefaultTags(f);
            showSelectTags(f, h,
            function(G, v, H) {
                if (H) {
                    $(G).addClass("usetagpop").removeData("mouselock")
                } else {
                    $(G).removeClass("usetagpop").data("mouselock", 1)
                }
            });
            tagSelectBind(f, h, 5);
            $("#al-sync").prop("checked", $.Bom.getSubCookie("sgy", "sync").indexOf("sina") === -1 ? true: false).change(function() {
                var I = $(this),
                G = I.attr("value"),
                H = $.Bom.getSubCookie("sgy", "sync");
                if (!I.prop("checked") && H.indexOf(G) === -1) {
                    $.Bom.setSubCookie("sgy", "sync", H + "," + G, {
                        expires: 365
                    })
                } else {
                    if (I.prop("checked")) {
                        $.Bom.setSubCookie("sgy", "sync", H.replace("," + G, ""), {
                            expires: 365
                        })
                    }
                }
            });
            j.delegate("img#up-img", "mouseover",
            function(G) {
                G.stopPropagation();
                G.preventDefault();
                var H = dtImageTrans(this.src),
                v = $("#al-fullpic");
                if (!v.length) {
                    v = $('<img id="al-fullpic"/>').css("visibility", "hidden").load(function() {
                        $("#up-img").css("visibility", "hidden").attr("src", H);
                        $(this).remove();
                        j.undelegate("img#up-img", "mouseover")
                    }).appendTo("#al-pics")
                }
                v.attr("src", H)
            });
            function A(v) {
                keyupLenLimitForU(v.currentTarget, b, "", "", 1)
            }
            l.keyup(A).blur(A).focus(A);
            keyupLenLimitForU(l[0], b, "", "", 1);
            var B = $("#bindsourcelink"),
            F = $("#sourcelink"),
            C = $("#sourcelink-ed");
            B.click(function(v) {
                v.stopPropagation();
                v.preventDefault();
                C.css("display", "block").attr("value", F.attr("value")).focus();
                B.css("display", "none")
            });
            C.blur(function() {
                var G = $.trim(C.val());
                if (G !== "") {
                    G = G.match(/^http(?:s)?:\/\//ig) ? G: "http://" + G;
                    F.val(G);
                    B.find("span").html(G.cut(38, "…") || "暂无链接");
                    C.css("display", "none");
                    B.css("display", "block");
                    $("#sourcelinkcheck").html("")
                } else {
                    $("#sourcelinkcheck").html("请输入内容")
                }
            });
            d.safeSubmit(function(v) {
                Coll.doPost(D, y)
            },
            function(v) {
                blinkIt(function() {
                    l.css({
                        backgroundColor: "#d7ebf7"
                    });
                    $("#al-txa-lb").css("display", "none")
                },
                function() {
                    l.css({
                        backgroundColor: "transparent"
                    })
                },
                function() {
                    l.focus()
                },
                4, 200)
            });
            l.keydown(function(v) {
                if (v.metaKey && v.which == 13) {
                    m.click()
                }
            })
        },
        switchType: function(v) {
            if (v == 1 || !v && o.hasClass("al-fetch")) {
                o.removeClass("al-fetch").addClass("al-upload").find(".al-head h1").html('本地上传图片<a class="al-swbtn" href="javascript:Coll.switchType();">切换至[粘贴网址抓取]</a>')
            } else {
                if (v == 2 || !v && o.hasClass("al-upload")) {
                    o.addClass("al-fetch").removeClass("al-upload").find(".al-head h1").html('粘贴网址抓取<a class="al-swbtn" href="javascript:Coll.switchType();">切换至[本地上传图片]</a>')
                }
            }
            Coll.initReset();
            var w = $.Bom.getSubCookie("sgm", "postalbumid-" + getUSERID()) || 0,
            x = $.Bom.getSubCookie("sgm", "postalbumnm-" + getUSERID()) || "未分类";
            Coll.setAlbum(w, x)
        },
        setSubmitNo: function() {
            m.parent().addClass("abtn-no").add(d.find(".al-subbtn [type=checkbox]")).prop("disabled", true);
            d.find(".al-subbtn .s-sina").css({
                opacity: 0.5,
                color: "#aaa"
            })
        },
        setSubmitYes: function() {
            m.parent().removeClass("abtn-no").add(d.find(".al-subbtn [type=checkbox]")).removeProp("disabled");
            d.find(".al-subbtn .s-sina").css({
                opacity: 1,
                color: "#333"
            })
        },
        upLoadSubmit: function() {
            var v = o.find(".al-size");
            v.find("span").replaceWith(function() {
                return $(this).text()
            });
            j.html("");
            UPTOKEN = parseInt(Math.random() * 10000000000);
            var w = $(getToken(3));
            $(n).find("input[name=tid]").val(UPTOKEN).end().append(w).submit();
            w.remove();
            u.attr("name", "");
            i.attr("name", "photo_id");
            $("#bindsourcelink").css("visibility", "hidden");
            $("span", "#bindsourcelink").html("暂无链接");
            $("#sourcelink").attr("value", "");
            $("#sourcetitle").attr("value", "");
            $("#al-fesour span").html("");
            $("#al-sourcetype").attr("value", "upload");
            $("#al-loading").html('<u>正在上传，请稍候</u><br/><a class="graylk lkl" href="javascript:Coll.reset();">取消</a>');
            Coll.reset("al-uloading")
        },
        doPost: function(v, w) {
            Coll.setSubmitNo();
            Coll.setPostStat("al-inpost", "正在提交，请稍候");
            $.ajax({
                type: "POST",
                cache: false,
                url: d.getFormAction(),
                data: d.paramForm(getToken(2)),
                timeout: 20000,
                success: function(z) {
                    var x = $.isPlainObject(z) ? z: $.parseJSON(z);
                    if (!x || typeof x != "object") {
                        Coll.setPostError("出现异常，请刷新页面查看");
                        return
                    }
                    if (x.success) {
                        var B = q.find("[name=album]").val(),
                        C = q.find(".al-shw").html(),
                        y = $(h).val();
                        if (B) {
                            $.Bom.setSubCookie("sgm", "postalbumid-" + getUSERID(), B, {
                                expires: 30
                            });
                            $.Bom.setSubCookie("sgm", "postalbumnm-" + getUSERID(), C, {
                                expires: 30
                            })
                        }
                        l.val("").blur();
                        setUsedTags(f, h);
                        $(h).val("").blur();
                        $(t).val("http://");
                        j.html("");
                        blinkIt(function() {
                            Coll.reset();
                            Coll.setPostStat("al-postsuc", "发布成功！")
                        },
                        null,
                        function() {
                            Coll.setPostStat("al-nogoodimg", "先找到合适的图片，再发布")
                        },
                        1, 3000);
                        if ($.isFunction(v)) {
                            v(x, w)
                        } else {
                            if ($("#dymcare").length) {
                                var A = $.History.getHash();
                                if (A != "" && A != "dym") {
                                    $.History.setHash("dym")
                                } else {
                                    $("#dymcare").click()
                                }
                            }
                        }
                    } else {
                        Coll.setPostError(x.message)
                    }
                },
                error: function() {
                    u.val("");
                    i.val("");
                    Coll.setPostError("网络原因导致失败，请稍候再试。")
                }
            }).always(function() {
                if (u.val() || i.val()) {
                    Coll.setSubmitYes()
                } else {
                    Coll.setSubmitNo()
                }
            })
        },
        showLabel: function(y, w, v) {
            var z = $(y),
            x = $(w),
            A = x.css("display");
            x.css("display", $.trim(z.val()) !== "" || v ? "none": "block")
        },
        initReset: function() {
            $(t).val("http://");
            s.find("input[type=file]").val("");
            i.val("");
            u.val("");
            q.find("input").val("");
            q.find("a").html("未分类");
            $("#al-poststat").html("");
            j.html("");
            l.val("").blur();
            Coll.reset();
            Coll.setSubmitNo()
        },
        reset: function(v) {
            o.removeClass("al-floaded al-fzero al-uloading al-uloaded al-uzero al-error");
            $("#al-fullpic").remove();
            if (v && (v === "al-uzero") || !v) {
                UPTOKEN = null;
                s.find("input[type=file]").val("");
                i.val("");
                j.html("")
            }
            if (v) {
                o.addClass(v)
            }
            if (u.val() || i.val()) {
                Coll.setSubmitYes()
            } else {
                Coll.setSubmitNo()
            }
        },
        setPostStat: function(w, v) {
            $("#al-poststat").html(v).attr("class", w)
        },
        setPostError: function(v) {
            o.addClass("al-error");
            Coll.setPostStat("al-posterror", v)
        },
        checkFetchUrl: function(y, w) {
            var x = $(w),
            v = $.trim(x.val());
            if (!v) {
                $({}).delay(300).queue(function() {
                    $(c).addClass("red").removeClass("gray").html("请输入正确的链接地址")
                });
                return false
            } else {
                if (v.match(/duitang\.com/ig)) {
                    $({}).delay(300).queue(function() {
                        $(c).addClass("red").removeClass("gray").html("不能抓取友礼享网站的图片，请使用其他网址")
                    });
                    return false
                } else {
                    $(c).addClass("gray").removeClass("red").html("拷贝完整的网址，我们将帮你保存网页的图片和地址");
                    return true
                }
            }
        },
        setAlbum: function(w, x) {
            q.find("input:first").val(w).end().find("a:first").html(x);
            if (p.length) {
                p.css("display", "none")
            }
        },
        doFetchPic: function(v) {
            if (!Coll.checkFetchUrl(null, t)) {
                return
            }
            u.attr("name", "image_src");
            i.attr("name", "");
            $("#al-sourcetype").attr("value", "fetch");
            var w = $.trim($(t).val());
            if (!w.match(/^http(?:s)?:\/\//ig)) {
                $(t).val("http://" + w)
            }
            $("#bindsourcelink").css("visibility", "hidden");
            Coll.reset("al-uloading");
            $("#al-loading").html("<u>正在抓取，请稍候</u>");
            $.ajax({
                type: "POST",
                cache: false,
                url: v.getFormAction(),
                data: v.paramForm(getToken(2)),
                timeout: 30000,
                success: function(A) {
                    if (o.hasClass("al-fzero") || o.hasClass("al-floaded")) {
                        return
                    }
                    var z = $.isPlainObject(A) ? A: $.parseJSON(A);
                    if (!z) {
                        return
                    }
                    if (z.success && z.data) {
                        var B = z.data.images;
                        if (B.length) {
                            if (!j.data("choose")) {
                                j.data("choose", true).delegate(".vm", "click",
                                function(C) {
                                    C.stopPropagation();
                                    C.preventDefault();
                                    $(".cur", "#al-pics").removeClass("cur");
                                    $(this).addClass("cur");
                                    u.val($(this).find("img")[0].src)
                                })
                            }
                            var y = $.trim($(t).val());
                            $("#bindsourcelink").css("visibility", "visible");
                            $("span", "#bindsourcelink").html(y.cut(38, "…") || "暂无链接");
                            $("#sourcelink").val(y);
                            $("#sourcetitle").val(z.data.title);
                            $("#al-fesour span").html(z.data.title);
                            var x = B.length < 10 ? B.length: 10;
                            j.html(['<div id="al-picselect" class="al-picselect" ', (x > 3 ? 'style="overflow-x:scroll;"': ""), '><div class="al-piclist clr" style="width:', (210 * x - 8), 'px;"><!-- 循环单元开始 -->', (function() {
                                var D = "";
                                for (var C = 0; C < x; C++) {
                                    D += '<div class="vm ct l ' + (C === x - 1 ? "last": "") + " " + (C === 0 ? "cur": "") + '"><div class="vma"><div class="vmb"> <img src="' + B[C] + '" onload="setImgSize(this,198,198)"/></div></div></div>'
                                }
                                return D
                            })(), "<!-- 循环单元结束 --></div></div>", ].join(""));
                            u.val($("img", "#al-pics")[0].src);
                            Coll.reset("al-floaded");
                            $("#al-picselect").scrollTop(0)
                        } else {
                            Coll.reset("al-fzero")
                        }
                    } else {
                        $(c).addClass("red").removeClass("gray").html(z.message);
                        Coll.reset("al-fzero")
                    }
                },
                error: function() {
                    $(c).addClass("red").removeClass("gray").html("服务器繁忙，稍后再试试。");
                    Coll.reset("al-fzero")
                }
            })
        }
    }
} ();
$(function() {
    tagSelectBind("#popal-mbaddtagsel", "#popal-mbaddtagipt");
    setLabelIptFocus("#popal-mbaddtagipt", "#popal-mbaddtag-lb");
    $("#popal-editname,#form-popcreatealbum textarea").lengthLimit();
    $("#mynavtools-create,#createalbum-pp,#createalbum").click(function() {
        $("#popal-editname").val("");
        $(".txa[name=desc]").val("");
        SUGAR.PopOut.alert(["创建专辑", $("#popcreatealbum")[0], ""], 2)
    });
    $("#form-popcreatealbum").safeSubmit(function(c) {
        if (!getUSERID()) {
            return
        }
        var b = this;
        $(".abtn", b).addClass("abtn-no");
        $(b).add("[type=submit]", b).attr("disabled", "ture");
        $.ajax({
            type: "POST",
            cache: false,
            url: $(b).getFormAction(),
            data: $(b).paramForm(getToken(2)),
            timeout: 20000,
            success: function(f) {
                var d = $.isPlainObject(f) ? f: $.parseJSON(f);
                if (!d) {
                    return
                }
                if (d.success) {
                    SUGAR.PopOut.alert('<div class="prompt prompt-success"><h3>创建成功</h3><p>去 <a href="/album/' + d.data.id + '/">新专辑</a> 看看，或者去 <a href="/people/' + getUSERID() + '/">我的个人主页</a> 查看全部专辑</p></div>');
                    $({}).delay(3000).queue(function() {
                        SUGAR.PopOut.closeMask(0)
                    });
                    $("#editname").attr("value", "");
                    $("textarea", b).attr("value", "")
                } else {
                    SUGAR.PopOut.alert('<div class="prompt prompt-fail"><h3>' + d.message + "</h3></div>")
                }
            },
            error: function() {
                SUGAR.PopOut.alert('<div class="prompt prompt-fail"><h3>服务器出错或网络问题。</h3><p>喝杯茶，浏览<a class="lkl" href="/recommend/">其他页面</a>吧。</p></div>')
            }
        }).always(function() {
            $(".abtn", b).removeClass("abtn-no");
            $(b).add("[type=submit]", b).removeAttr("disabled")
        })
    });
    var a = null;
    $("#dym-area").delegate("a.delthisalbum", "click",
    function(b) {
        b.preventDefault();
        SUGAR.PopOut.alert(["", $("#popalbumdel")[0], ""]);
        a = this
    });
    $("#albumdelbtn").click(function(b) {
        b.preventDefault();
        SUGAR.PopOut.alert(["", $("#popalbumdel")[0], ""]);
        a = this
    });
    $("#form-albumdel").safeSubmit(function(c) {
        if (!getUSERID()) {
            return
        }
        var b = this;
        $(".abtn", b).addClass("abtn-no");
        $(b).add("[type=submit]", b).attr("disabled", "ture");
        $.ajax({
            type: "POST",
            cache: false,
            url: $(b).getFormAction() + a.title + "/",
            data: $(b).paramForm(getToken(2)),
            timeout: 20000,
            success: function(f) {
                var d = $.isPlainObject(f) ? f: $.parseJSON(f);
                if (!d) {
                    return
                }
                if (d.success) {
                    SUGAR.PopOut.alert('<div class="prompt prompt-success"><h3>删除成功！</h3></div>');
                    if ($("#albumdelbtn").length && a.title == $("#albumdelbtn").attr("title")) {
                        $({}).delay(800).queue(function() {
                            SUGAR.PopOut.closeMask(0);
                            window.location.href = "/people/" + getUSERID() + "/#album"
                        })
                    } else {
                        $({}).delay(800).queue(function() {
                            SUGAR.PopOut.closeMask(0)
                        });
                        $(a).closest("div.dym").remove()
                    }
                } else {
                    SUGAR.PopOut.alert('<div class="prompt prompt-fail"><h3>' + d.message + "</h3></div>")
                }
            },
            error: function() {
                SUGAR.PopOut.alert('<div class="prompt prompt-fail"><h3>服务器出错或网络问题。</h3><p>喝杯茶，浏览<a class="lkl" href="/recommend/">其他页面</a>吧。</p></div>')
            }
        }).always(function() {
            $(".abtn", b).removeClass("abtn-no");
            $(b).add("[type=submit]", b).removeAttr("disabled")
        })
    })
});
$(function() {
    if (!getUSERID()) {
        return
    }
    function a() {
        $.get("/blog/unread/?" + (Math.random() * 99999999),
        function(j) {
            var f = $.isPlainObject(j) ? j: $.parseJSON(j);
            if (!f) {
                return
            }
            if (f.success) {
                var m = f.data;
                var d = $("#mymess");
                if (d.length) {
                    var k = m.stars + m.comments + m.followers + m.notices + m.mentions;
                    if (k >= 1000) {
                        k = "999+"
                    }
                    var p = "",
                    l = "";
                    if (k >= 1 || k == "999+") {
                        p = ' style="width:auto"'
                    }
                    if (m.new_inbox_msg_count >= 1) {
                        l = ' style="width:auto"'
                    }
                    var o = [["提醒", k, '<a href="/comments/list/1/20/" title="提醒"><u class="warntag-count">' + k + "</u></a>", "/blog/unread/clean/", ".mymsgwarn", "#mynews"], ["私信", m.new_inbox_msg_count, '<a href="/letter/thread/" title="私信" style="width:auto"><u class="warntag-count">' + m.new_inbox_msg_count + "</u></a>", "/people/msg/read/?flag=1", ".mymsgletter", "#mymess"]];
                    for (var g = 0; g < o.length; g++) {
                        var t = o[g][2],
                        n = o[g][0],
                        c = $(t).attr("href"),
                        b = "系统消息",
                        q = $(o[g][5]),
                        v = o[g][1];
                        if (v) {
                            var s = 24;
                            if (v < 10) {
                                s = 36
                            } else {
                                if (9 < parseInt(v) && parseInt(v) < 100) {
                                    s = 41
                                } else {
                                    if (99 < parseInt(v) && parseInt(v) < 1000) {
                                        s = 49
                                    } else {
                                        s = 60
                                    }
                                }
                            }
                            q.css("width", s);
                            var u = [t];
                            if (n === "提醒") {
                                u.push('<div id="mynewsin"><p class="arr"></p>');
                                if (m.new_system_msg_count > 0 && 0) {
                                    c = "/people/msg/4/list/1/20/";
                                    u.push('<a class="rvta" class="rvta" href="' + c + '">您有 <u class="rvtu">' + m.new_system_msg_count + '</u> 个系统消息</a><p class="sep"></p>')
                                }
                                if (m.stars > 0) {
                                    c = "/star/list/1/20/";
                                    b = "收到的提醒";
                                    u.push('<a class="rvta" href="' + c + '">您收到 <u class="rvtu">' + m.stars + '</u> 个提醒</a><p class="sep"></p>')
                                }
                                if (m.comments > 0) {
                                    c = "/comments/list/1/20/";
                                    b = "收到的回复";
                                    u.push('<a class="rvta" href="' + c + '">您有 <u class="rvtu">' + m.comments + '</u> 个新回复</a><p class="sep"></p>')
                                }
                                if (m.followers > 0) {
                                    c = "/people/" + getUSERID() + "/fans/list/1/20/";
                                    b = "新的粉丝";
                                    u.push('<a class="rvta" href="' + c + '">您有 <u class="rvtu">' + m.followers + '</u> 个新粉丝</a><p class="sep"></p>')
                                }
                                if (m.notices > 0) {
                                    c = "/systemnotice/";
                                    b = "新的通知";
                                    u.push('<a class="rvta" href="' + c + '">您有 <u class="rvtu">' + m.notices + '</u> 个新通知</a><p class="sep"></p>')
                                }
                                if (m.mentions > 0) {
                                    c = "/mentions/";
                                    b = "收到的@消息";
                                    u.push('<a class="rvta" href="' + c + '">您有 <u class="rvtu">' + m.mentions + '</u> 个@消息</a><p class="sep"></p>')
                                }
                            } else {
                                u.push('<div id="mymessin"><p class="arr"></p>');
                                u.push('<a class="rvta" href="' + c + '">您有 <u class="rvtu">' + v + "</u> 条" + o[g][0] + '</a><p class="sep"></p>')
                            }
                            u.push('<a class="SG-close-e" data-read=\'{"index":' + g + ',"url":"' + o[g][3] + '"}\' href="javascript:;">知道了</a>');
                            u.push("</div>");
                            u = u.join("");
                            $(o[g][5]).empty().append($(u)).find(".SG-close-e").click(function() {
                                var i = $(this).data("read");
                                var h = $(this).parents();
                                this_par0 = h[0];
                                this_par1 = h[1];
                                $(this_par1).find("u").remove().end().css("width", "36px");
                                $(this_par0).remove();
                                $.ajax({
                                    type: "GET",
                                    url: i.url,
                                    timeout: 20000,
                                    success: function(w) {}
                                }).always(function() {})
                            });
                            q.find("div").css({
                                right: s - 40
                            });
                            if ($(".oldnav").length) {
                                q.find("div").css({
                                    right: s - 14
                                })
                            }
                            $(t).filter("a").attr("href", c).click(function() {
                                _gaq.push(["_trackPageview", "/_trc/topnav/icoclick"])
                            });
                            $(o[g][4]).find("u").remove().end().replaceWith($(t))
                        }
                    }
                }
            }
        })
    }
    a();
    if (window.location.href.toString().match(/duitang\.com\/myhome/ig)) {
        window.setInterval(a, 20000)
    }
    $(".nico").one("mouseover",
    function() {
        Coll.init()
    })
});
$(function() {
    $("#menucat").hover(function() {
        if (document.all) {
            $(this).css("border-color", "#DBDBDB")
        }
        $(this).addClass("menucat_hover");
        $("#menucat div").css("display", "block");
        clearTimeout($("#menucat div").data("timer"))
    },
    function() {
        if (document.all) {
            $(this).css("border-color", "#F7F7F7")
        }
        $("#menucat div").data("timer", setTimeout(function() {
            $("#menucat div").css("display", "none");
            $("#menucat").removeClass("menucat_hover")
        },
        50))
    });
    $("#myselect").hover(function() {
        $(this).addClass("myslt");
        $("#mytool,#mynews,#mymess").find("div").css({
            display: "none"
        });
        if (document.all) {
            $("#myselect div a").css("width", $(".oldnav").length ? $(this).width() - 32 : $(this).width() - 23)
        }
        $(".nvlist").css({
            display: "block",
            width: $(".oldnav").length ? $("#myselect").width() : $("#myselect").width() + 13
        });
        clearTimeout($(".nvlist").data("timer"))
    },
    function() {
        $(".nvlist").data("timer", setTimeout(function() {
            $("#myselect").removeClass("myslt");
            $(".nvlist").css({
                display: "none"
            })
        },
        $(".oldnav").length ? 100 : 500))
    });
    $("#mytool,#mynews,#mymess").hover(function() {
        $("#mytool,#mynews,#mymess,#myselect").find("div").css({
            display: "none"
        });
        var a = $(this).find("div")[0];
        $(a).css({
            display: "block"
        });
        clearTimeout($(a).data("timer"))
    },
    function() {
        var a = $(this).find("div")[0];
        $(a).data("timer", setTimeout(function() {
            $(a).css("display", "none")
        },
        500))
    })
});
$(function() {
    if ($("#myselect").width() <= 100 && $("#myselect").width() != 0) {
        $("#myselect").width(100)
    }
});
$(function() {
    var h = $("#navsch"),
    k = h.find("input[name=kw]"),
    g = h.find("input[name=type]"),
    a = h.find("button[type=submit]"),
    l = $('<div class="srchsel srchsel-0"></div>').appendTo(h.find(".srch")),
    j = "srchsel",
    b = "srchtyp",
    f = [{
        name: "内容",
        type: "feed"
    },
    {
        name: "专辑",
        type: "album"
    },
    {
        name: "礼友",
        type: "people"
    }],
    i,
    c;
    $("#mynavlogin").click(function(m) {
        m.preventDefault();
        SUGAR.PopOut.login()
    });
    h.submit(function() {
        if (k.val() == "内容 / 专辑 / 礼友" || $.trim(k.val()) == "") {
            return false
        }
    });
    k.focus(function() {
        if (this.value == "内容 / 专辑 / 礼友") {
            this.value = ""
        }
        this.select()
    }).blur(function() {
        if ($.trim(this.value) == "") {
            this.value = "内容 / 专辑 / 礼友"
        }
    });
    function d(m) {
        g.attr("value", f[m].type);
        l.addClass(function(n, o) {
            this.className = j + " " + j + "-" + m;
            return ""
        })
    }
    k.bind("keyup click",
    function() {
        var n = this,
        m = $.trim(n.value);
        c;
        if (!m) {
            return
        }
        var o = (function() {
            for (var q = 0,
            p = f.length,
            s = ""; q < p; q++) {
                s += '<div class="' + b + " " + b + "-" + q + '">搜索含 <span class="red">' + m.cut(16, "…") + "</span> 的" + f[q].name + "</div>"
            }
            return s
        })();
        $(".srch").addClass("srch-nobd");
        l.html(o).show()
    }).bind("blur",
    function() {
        var m = $(".oldnav"); ! m.length && $(".srch").removeClass("srch-nobd");
        i = window.setTimeout(function() {
            l.hide();
            m.length && $(".srch").removeClass("srch-nobd")
        },
        500)
    }).bind("focus",
    function() { ! $(".oldnav").length && $(".srch").addClass("srch-nobd")
    });
    l.click(function(m) {
        window.clearTimeout(i)
    });
    l.delegate("." + b, "click",
    function(n) {
        n.preventDefault();
        var m = this;
        nm = getNum(m.className);
        d(nm);
        a.click()
    });
    l.delegate("." + b, "mouseover",
    function(n) {
        var m = this;
        nm = getNum(m.className);
        d(nm)
    });
    $(document).bind("keydown",
    function(p) {
        if (l.css("display") != "none") {
            var s = p.keyCode,
            m = getNum(l.attr("class")),
            o = f.length,
            q = (m - 1) % o,
            n = (m + 1) % o,
            q = q < 0 ? 0 : q,
            n = n > o ? o: n;
            if (s == 38) {
                d(q)
            } else {
                if (s == 40) {
                    d(n)
                }
            }
        }
    });
    if ($(".oldnav").length) {
        $("#navdv").minibar()
    }
    $('<div id="changenav"><a id="chnv-trig" href="#">喜欢这次导航的改版吗？<i></i></a></div>').appendTo("#header").SGreport({
        cont: "#changenav",
        trigger: "#chnv-trig",
        cookiename: "headv",
        words: "喜欢这次导航的改版吗？",
        voteid: 3,
        votechoices: [{
            id: 27,
            wds: "新版黑色导航很好，喜欢"
        },
        {
            id: 28,
            wds: "以前白色好，不喜欢黑色导航"
        }]
    })
}); (function(a) {
    a.fn.minibar = function(d) {
        var c = this.css("position", "relative"),
        f = a("<div/>").appendTo(c);
        d = a.extend({},
        a.fn.minibar.defaults, d);
        c.find("li").hover(function() {
            var g = this;
            clearTimeout(f.data("timer"));
            b(g)
        },
        function() {
            var g = this;
            f.data("timer", setTimeout(function() {
                b(c.find("." + d.cur), g)
            },
            300))
        });
        d.idx && b(c.find("li").eq(d.idx < 0 ? 0 : d.idx).addClass(d.cur));
        function b(k, l) {
            var g = a(k),
            j = a(l);
            if (g.length) {
                var i = g.outerWidth(),
                h = g.position().left;
                if (f.css("position") !== "absolute") {
                    f.css({
                        position: "absolute",
                        height: 4,
                        top: 0,
                        overflow: "hidden",
                        backgroundColor: "#F21664",
                        width: 0,
                        left: h + i / 2,
                        "z-index": 2001
                    })
                }
                f.stop().animate({
                    width: i,
                    left: h
                },
                300)
            } else {
                if (j.length) {
                    var i = j.outerWidth(),
                    h = j.position().left;
                    f.stop().animate({
                        width: 0,
                        left: h + i / 2
                    },
                    300)
                }
            }
        }
        return c
    };
    a.fn.minibar.defaults = {
        idx: null,
        cur: "cur"
    }
})(jQuery);
SUGAR = function() {
    var g = $.browser.msie,
    f = $.browser.mozilla,
    d = g && $.browser.version === "6.0",
    c = g && $.browser.version === "7.0",
    a = g && $.browser.version === "8.0",
    h = g && $.browser.version === "9.0",
    b = $.browser.opera;
    return {
        PopOut: function() {
            return {
                fnCloseMask: function() {
                    this.closeMask()
                },
                pops: [{},
                {}],
                STR: ['<a href="javascript:;" target="_self" class="abtn l" onclick="SUGAR.PopOut.closeMask();"><button type="button"><u>关闭</u></button></a>', '<a href="javascript:;" target="_self" class="abtn l" onclick="SUGAR.PopOut.closeMask();"><button type="button"><u>取消</u></button></a>'],
                alert: function(m, j) {
                    var s = this,
                    j = j || 1,
                    k = [300, 400, 660],
                    i = $("#win-house");
                    if (!i.length) {
                        i = $('<div id="win-house" class="h0"></div>').appendTo("body")
                    }
                    if ($.type(m) === "string" || $.type(m) === "number") {
                        m = ["", m + ""]
                    }
                    m[0] = m[0];
                    m[1] = m[1] || "";
                    var p = $.type(m[1]) === "string",
                    o = m[0] === null ? "": $('<div class="tt-s"><a class="mask-close" target="_self" href="javascript:;" onclick="SUGAR.PopOut.closeMask();">关闭</a>' + m[0] + "</div>"),
                    q = $('<div class="mask-body"></div>').css("width", k[j]).appendTo(i);
                    q.append(o).append($('<div class="mask-cont"></div>').append(m[1]));
                    var l = q.outerHeight();
                    if (p) {
                        q.remove();
                        q = '<div class="mask-body">' + q.html() + "</div>"
                    }
                    $.blockUI({
                        message: q,
                        baseZ: 9000,
                        focusInput: true,
                        css: {
                            top: "50%",
                            left: "50%",
                            textAlign: "left",
                            marginLeft: -(k[j] / 2),
                            marginTop: -(l / 2),
                            width: k[j],
                            height: l,
                            border: "none",
                            background: "none"
                        }
                    });
                    s.setOverLay()
                },
                setOverLay: function() {
                    if (d) {
                        return
                    }
                    var k = $("div.blockPage"),
                    i = k.outerWidth(),
                    m = k.outerHeight(),
                    l = parseInt(k.css("marginTop")),
                    j = parseInt(k.css("marginLeft"));
                    $("div.blockOverlay").css({
                        width: i + 24,
                        height: m + 24,
                        top: "50%",
                        left: "50%",
                        marginTop: l - 12,
                        marginLeft: j - 12,
                        "border-radius": "8px",
                        "-moz-border-radius": "8px",
                        "-webkit-border-radius": "8px"
                    })
                },
                login: function(i) {
                    var k = this;
                    var l = $("#poplogin"),
                    j = $("#win-house");
                    l.find("[name=next]").val(i ? i: window.location.href);
                    if (!j.length) {
                        j = $('<div id="win-house" class="h0"></div>').appendTo("body")
                    }
                    if (!l.length) {
                        l = $('<div id="poplogin" class="win-wraper clr"> <form action="/login/" method="POST"> <input type="hidden" name="next" value="' + (i ? i: window.location.href) + '"/> <table class="tableform poplogin" cellspacing="0" cellpadding="0"> <tr> <td align="right">用户名或邮箱</td> <td><input id="p-username" class="ipt" type="text" name="login_name" value=""/></td> </tr> <tr> <td align="right">密码</td> <td><input id="p-password" class="ipt" type="password" name="pswd" value=""/> <div class="clr u-chk"> <input id="poplogin-rem"  class="chk" type="checkbox" name="remember" checked/><label for="poplogin-rem">记住登录状态</label> </div> </td> </tr> <tr> <td></td> <td class="subtd clr" ><a href="javascript:;" class="abtn l"><button type="submit"><u>登录</u></button></a><a class="lkl" href="/getpasswd/">忘记密码？</a></td> </tr> </table> ' + $("#form-token").html() + '</form> <div class="popreg"> 还没有注册帐号？ <div class="clr"><a class="popregbtn" href="/reg/">立即注册</a></div> 或者 <div class="popoutlogin social clr"> <a class="sina" href="/connect/sina/">用新浪微博登录</a> <a class="qweibo" href="/connect/qweibo/">用腾讯微博登录</a> <a class="douban" href="/connect/douban/">用豆瓣登录</a> <a class="oicq" href="/connect/qq/">用QQ帐号登录</a> </div> </div> </div>');
                        j.append(l)
                    }
                    k.alert(["登录", l, ""], 2);
                    $({}).delay(100).queue(function() {
                        var m;
                        if ((m = $("#p-username")[0])) {
                            m.focus()
                        }
                    })
                },
                loading: function(j) {
                    var k = this,
                    j = j || "";
                    k.closePops();
                    k.jumpOutMask();
                    var i = document.createElement("div");
                    i.className = "mask-pop";
                    $(i).css("display", "block");
                    i.innerHTML = j;
                    $("#mask-tmp")[0].appendChild(i)
                },
                closePops: function() {
                    var k = this,
                    l = k.pops,
                    i = l.length;
                    while (i-->0) {
                        $(l[i].dom).css("display", "none")
                    }
                },
                closePopN: function(o) {
                    var l = this,
                    m = l.pops,
                    j = m.length,
                    k = true;
                    if ($.type(o) === "number" && o < m.length) {
                        $(m[o].dom).css("display", "none");
                        while (j-->0) {
                            if ($(m[j].dom).css("display") != "none") {
                                k = false
                            }
                        }
                    }
                    return k
                },
                setFnCloseMask: function(j) {
                    var i = this;
                    if (typeof j === "function") {
                        i.fnCloseMask = j
                    }
                },
                closeMask: function() {
                    $.unblockUI()
                },
                jumpOutMask: function() {
                    var l = this,
                    j = $(document).width(),
                    n = $(document).height(),
                    m = $("#mask"),
                    i = $("#mask-bg"),
                    k = $("#mask-fm");
                    i.unbind("click");
                    $({}).delay(800).queue(function() {
                        i.click(function() {
                            l.fnCloseMask()
                        })
                    });
                    if (a || h) {
                        j -= 21
                    }
                    if (m.css("display") === "none") {
                        k.css({
                            width: j,
                            height: n
                        });
                        i.css({
                            height: n
                        });
                        m.css({
                            width: j,
                            display: "block"
                        })
                    }
                    $("#mask-tmp").html("")
                }
            }
        } ()
    }
} ();
/*
* jQuery blockUI plugin
* Version 2.39 (23-MAY-2011)
* @requires jQuery v1.2.3 or later
*
* Examples at: http://malsup.com/jquery/block/
* Copyright (c) 2007-2010 M. Alsup
* Dual licensed under the MIT and GPL licenses:
* http://www.opensource.org/licenses/mit-license.php
* http://www.gnu.org/licenses/gpl.html
*
* Thanks to Amir-Hossein Sobhi for some excellent contributions!
*/
(function(j) {
    if (/1\.(0|1|2)\.(0|1|2)/.test(j.fn.jquery) || /^1.1/.test(j.fn.jquery)) {
        alert("blockUI requires jQuery v1.2.3 or later!  You are using v" + j.fn.jquery);
        return
    }
    j.fn._fadeIn = j.fn.fadeIn;
    var c = function() {};
    var k = document.documentMode || 0;
    var f = j.browser.msie && ((j.browser.version < 8 && !k) || k < 8);
    var g = j.browser.msie && /MSIE 6.0/.test(navigator.userAgent) && !k;
    j.blockUI = function(q) {
        d(window, q)
    };
    j.unblockUI = function(q) {
        i(window, q)
    };
    j.growlUI = function(v, t, u, q) {
        var s = j('<div class="growlUI"></div>');
        if (v) {
            s.append("<h1>" + v + "</h1>")
        }
        if (t) {
            s.append("<h2>" + t + "</h2>")
        }
        if (u == undefined) {
            u = 3000
        }
        j.blockUI({
            message: s,
            fadeIn: 700,
            fadeOut: 1000,
            centerY: false,
            timeout: u,
            showOverlay: false,
            onUnblock: q,
            css: j.blockUI.defaults.growlCSS
        })
    };
    j.fn.block = function(q) {
        return this.unblock({
            fadeOut: 0
        }).each(function() {
            if (j.css(this, "position") == "static") {
                this.style.position = "relative"
            }
            if (j.browser.msie) {
                this.style.zoom = 1
            }
            d(this, q)
        })
    };
    j.fn.unblock = function(q) {
        return this.each(function() {
            i(this, q)
        })
    };
    j.blockUI.version = 2.39;
    j.blockUI.defaults = {
        message: "<h1>Please wait...</h1>",
        title: null,
        draggable: true,
        theme: false,
        css: {
            padding: 0,
            margin: 0,
            width: "30%",
            top: "40%",
            left: "35%",
            textAlign: "center",
            color: "#000",
            border: "none",
            backgroundColor: "#fff"
        },
        themedCSS: {
            width: "30%",
            top: "40%",
            left: "35%"
        },
        overlayCSS: {
            backgroundColor: "#000",
            opacity: 0.4
        },
        growlCSS: {
            width: "350px",
            top: "10px",
            left: "",
            right: "10px",
            border: "none",
            padding: "5px",
            opacity: 0.6,
            cursor: "default",
            color: "#fff",
            backgroundColor: "#000",
            "-webkit-border-radius": "10px",
            "-moz-border-radius": "10px",
            "border-radius": "10px"
        },
        iframeSrc: /^https/i.test(window.location.href || "") ? "javascript:false": "about:blank",
        forceIframe: false,
        baseZ: 1000,
        centerX: true,
        centerY: true,
        allowBodyStretch: true,
        bindEvents: true,
        constrainTabKey: true,
        fadeIn: 200,
        fadeOut: 200,
        timeout: 0,
        showOverlay: true,
        focusInput: false,
        applyPlatformOpacityRules: true,
        onBlock: null,
        onUnblock: null,
        quirksmodeOffsetHack: 4,
        blockMsgClass: "blockMsg"
    };
    var b = null;
    var h = [];
    function d(v, H) {
        var C = (v == window);
        var y = H && H.message !== undefined ? H.message: undefined;
        H = j.extend({},
        j.blockUI.defaults, H || {});
        H.overlayCSS = j.extend({},
        j.blockUI.defaults.overlayCSS, H.overlayCSS || {});
        var E = j.extend({},
        j.blockUI.defaults.css, H.css || {});
        var P = j.extend({},
        j.blockUI.defaults.themedCSS, H.themedCSS || {});
        y = y === undefined ? H.message: y;
        if (C && b) {
            i(window, {
                fadeOut: 0
            })
        }
        if (y && typeof y != "string" && (y.parentNode || y.jquery)) {
            var K = y.jquery ? y[0] : y;
            var R = {};
            j(v).data("blockUI.history", R);
            R.el = K;
            R.parent = K.parentNode;
            R.display = K.style.display;
            R.position = K.style.position;
            if (R.parent) {
                R.parent.removeChild(K)
            }
        }
        j(v).data("blockUI.onUnblock", H.onUnblock);
        var D = H.baseZ;
        var O = (j.browser.msie || H.forceIframe) ? j('<iframe class="blockUI" style="z-index:' + (D++) + ';display:none;border:none;margin:0;padding:0;position:absolute;width:100%;height:100%;top:0;left:0" src="' + H.iframeSrc + '"></iframe>') : j('<div class="blockUI" style="display:none"></div>');
        var N = H.theme ? j('<div class="blockUI blockOverlay ui-widget-overlay" style="z-index:' + (D++) + ';display:none"></div>') : j('<div class="blockUI blockOverlay" style="z-index:' + (D++) + ';display:none;border:none;margin:0;padding:0;width:100%;height:100%;top:0;left:0"></div>');
        var M, I;
        if (H.theme && C) {
            I = '<div class="blockUI ' + H.blockMsgClass + ' blockPage ui-dialog ui-widget ui-corner-all" style="z-index:' + (D + 10) + ';display:none;position:fixed"><div class="ui-widget-header ui-dialog-titlebar ui-corner-all blockTitle">' + (H.title || "&nbsp;") + '</div><div class="ui-widget-content ui-dialog-content"></div></div>'
        } else {
            if (H.theme) {
                I = '<div class="blockUI ' + H.blockMsgClass + ' blockElement ui-dialog ui-widget ui-corner-all" style="z-index:' + (D + 10) + ';display:none;position:absolute"><div class="ui-widget-header ui-dialog-titlebar ui-corner-all blockTitle">' + (H.title || "&nbsp;") + '</div><div class="ui-widget-content ui-dialog-content"></div></div>'
            } else {
                if (C) {
                    I = '<div class="blockUI ' + H.blockMsgClass + ' blockPage" style="z-index:' + (D + 10) + ';display:none;position:fixed"></div>'
                } else {
                    I = '<div class="blockUI ' + H.blockMsgClass + ' blockElement" style="z-index:' + (D + 10) + ';display:none;position:absolute"></div>'
                }
            }
        }
        M = j(I);
        if (y) {
            if (H.theme) {
                M.css(P);
                M.addClass("ui-widget-content")
            } else {
                M.css(E)
            }
        }
        if (!H.theme && (!H.applyPlatformOpacityRules || !(j.browser.mozilla && /Linux/.test(navigator.platform)))) {
            N.css(H.overlayCSS)
        }
        N.css("position", C ? "fixed": "absolute");
        if (j.browser.msie || H.forceIframe) {
            O.css("opacity", 0)
        }
        var B = [O, N, M],
        Q = C ? j("body") : j(v);
        j.each(B,
        function() {
            this.appendTo(Q)
        });
        if (H.theme && H.draggable && j.fn.draggable) {
            M.draggable({
                handle: ".ui-dialog-titlebar",
                cancel: "li"
            })
        }
        var x = f && (!j.boxModel || j("object,embed", C ? null: v).length > 0);
        if (g || x) {
            if (C && H.allowBodyStretch && j.boxModel) {
                j("html,body").css("height", "100%")
            }
            if ((g || !j.boxModel) && !C) {
                var G = n(v, "borderTopWidth"),
                L = n(v, "borderLeftWidth");
                var A = G ? "(0 - " + G + ")": 0;
                var F = L ? "(0 - " + L + ")": 0
            }
            j.each([O, N, M],
            function(t, U) {
                var z = U[0].style;
                z.position = "absolute";
                if (t < 2) {
                    C ? z.setExpression("height", "Math.max(document.body.scrollHeight, document.body.offsetHeight) - (jQuery.boxModel?0:" + H.quirksmodeOffsetHack + ') + "px"') : z.setExpression("height", 'this.parentNode.offsetHeight + "px"');
                    C ? z.setExpression("width", 'jQuery.boxModel && document.documentElement.clientWidth || document.body.clientWidth + "px"') : z.setExpression("width", 'this.parentNode.offsetWidth + "px"');
                    if (F) {
                        z.setExpression("left", F)
                    }
                    if (A) {
                        z.setExpression("top", A)
                    }
                } else {
                    if (H.centerY) {
                        if (C) {
                            z.setExpression("top", '(document.documentElement.clientHeight || document.body.clientHeight) / 2 - (this.offsetHeight / 2) + (blah = document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop) + "px"')
                        }
                        z.marginTop = 0
                    } else {
                        if (!H.centerY && C) {
                            var S = (H.css && H.css.top) ? parseInt(H.css.top) : 0;
                            var T = "((document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop) + " + S + ') + "px"';
                            z.setExpression("top", T)
                        }
                    }
                }
            })
        }
        if (y) {
            if (H.theme) {
                M.find(".ui-widget-content").append(y)
            } else {
                M.append(y)
            }
            if (y.jquery || y.nodeType) {
                j(y).show()
            }
        }
        if ((j.browser.msie || H.forceIframe) && H.showOverlay) {
            O.show()
        }
        if (H.fadeIn) {
            var J = H.onBlock ? H.onBlock: c;
            var u = (H.showOverlay && !y) ? J: c;
            var q = y ? J: c;
            if (H.showOverlay) {
                N._fadeIn(H.fadeIn, u)
            }
            if (y) {
                M._fadeIn(H.fadeIn, q)
            }
        } else {
            if (H.showOverlay) {
                N.show()
            }
            if (y) {
                M.show()
            }
            if (H.onBlock) {
                H.onBlock()
            }
        }
        m(1, v, H);
        if (C) {
            b = M[0];
            h = j(":input:enabled:visible", b);
            if (H.focusInput) {
                setTimeout(p, 20)
            }
        } else {
            a(M[0], H.centerX, H.centerY)
        }
        if (H.timeout) {
            var w = setTimeout(function() {
                C ? j.unblockUI(H) : j(v).unblock(H)
            },
            H.timeout);
            j(v).data("blockUI.timeout", w)
        }
    }
    function i(u, v) {
        var t = (u == window);
        var s = j(u);
        var w = s.data("blockUI.history");
        var x = s.data("blockUI.timeout");
        if (x) {
            clearTimeout(x);
            s.removeData("blockUI.timeout")
        }
        v = j.extend({},
        j.blockUI.defaults, v || {});
        m(0, u, v);
        if (v.onUnblock === null) {
            v.onUnblock = s.data("blockUI.onUnblock");
            s.removeData("blockUI.onUnblock")
        }
        var q;
        if (t) {
            q = j("body").children().filter(".blockUI").add("body > .blockUI")
        } else {
            q = j(".blockUI", u)
        }
        if (t) {
            b = h = null
        }
        if (v.fadeOut) {
            q.fadeOut(v.fadeOut);
            setTimeout(function() {
                l(q, w, v, u)
            },
            v.fadeOut)
        } else {
            l(q, w, v, u)
        }
    }
    function l(q, u, t, s) {
        q.each(function(v, w) {
            if (this.parentNode) {
                this.parentNode.removeChild(this)
            }
        });
        if (u && u.el) {
            u.el.style.display = u.display;
            u.el.style.position = u.position;
            if (u.parent) {
                u.parent.appendChild(u.el)
            }
            j(s).removeData("blockUI.history")
        }
        if (typeof t.onUnblock == "function") {
            t.onUnblock(s, t)
        }
    }
    function m(q, v, w) {
        var u = v == window,
        t = j(v);
        if (!q && (u && !b || !u && !t.data("blockUI.isBlocked"))) {
            return
        }
        if (!u) {
            t.data("blockUI.isBlocked", q)
        }
        if (!w.bindEvents || (q && !w.showOverlay)) {
            return
        }
        var s = "mousedown mouseup keydown keypress";
        q ? j(document).bind(s, w, o) : j(document).unbind(s, o)
    }
    function o(v) {
        if (v.keyCode && v.keyCode == 9) {
            if (b && v.data.constrainTabKey) {
                var t = h;
                var s = !v.shiftKey && v.target === t[t.length - 1];
                var q = v.shiftKey && v.target === t[0];
                if (s || q) {
                    setTimeout(function() {
                        p(q)
                    },
                    10);
                    return false
                }
            }
        }
        var u = v.data;
        if (j(v.target).parents("div." + u.blockMsgClass).length > 0) {
            return true
        }
        return j(v.target).parents().children().filter("div.blockUI").length == 0
    }
    function p(q) {
        if (!h) {
            return
        }
        var s = h[q === true ? h.length - 1 : 0];
        if (s) {
            s.focus()
        }
    }
    function a(z, q, B) {
        var A = z.parentNode,
        w = z.style;
        var u = ((A.offsetWidth - z.offsetWidth) / 2) - n(A, "borderLeftWidth");
        var v = ((A.offsetHeight - z.offsetHeight) / 2) - n(A, "borderTopWidth");
        if (q) {
            w.left = u > 0 ? (u + "px") : "0"
        }
        if (B) {
            w.top = v > 0 ? (v + "px") : "0"
        }
    }
    function n(q, s) {
        return parseInt(j.css(q, s)) || 0
    }
})(jQuery);
document.cookie = "js=1; path=/";
if ($.Bom.getCookie("referer") === "qplus") {
    $("head").append('<style type="text/css"> .dt-smplogin .popoutlogin,.idxreg .social a,.idxreg .social div,#popreg .part3,.loreg-r{display:none;} .idxreg .social .imdreg{display:block} #poplogin .popreg{height:94px;overflow:hidden;margin-top:24px;} #poplogin .popregbtn:link,#poplogin .popregbtn:visited{width:150px;height:50px;margin:12px 10px 0 0;padding:0;overflow:hidden;line-height:48px;background-image:url(../../../../img/0/dtbutton.gif?20120106);background-repeat:no-repeat;background-position:0 -450px;letter-spacing:2px;text-align:center;font-size:24px;color:#fff;text-indent:0;text-align:center;} #poplogin .popregbtn:hover{background-position:0 -510px;color:#fff;text-decoration:none;} </style>')
} (function(d) {
    var b = d.event,
    a = b.special;
    function c(f) {
        f.preventDefault();
        f.type = "safeSubmit";
        b.handle.apply(this, arguments)
    }
    b.special.safeSubmit = {
        setup: function() {
            var f = this,
            g = d(f);
            b.add(f, "submit", c)
        },
        teardown: function() {
            var f = this,
            g = d(f);
            b.remove(f, "submit", c)
        }
    };
    d.fn.safeSubmit = function(h, g, f) {
        if (typeof f !== "function") {
            f = g;
            g = h;
            h = null
        }
        f = f ||
        function() {
            alert("请输入内容")
        };
        return arguments.length > 0 ? this.unbind("safeSubmit").bind("safeSubmit", h,
        function(l) {
            var j = this,
            m = d(j),
            k = d("input[type=text],textarea", m).not("[name=]").not("[data-optional]"),
            i = d("[type=submit]", m);
            safe = true;
            k.each(function(n, o) {
                if (d.trim(d(o).val()) === "" && safe) {
                    safe = false
                }
            });
            i.each(function(n, o) {
                if (d(o).prop("disabled") && safe) {
                    safe = false
                }
            });
            if (safe) {
                g.call(this, arguments)
            } else {
                f.call(this, arguments)
            }
        }) : this.trigger("safeSubmit")
    }
})(jQuery); (function(a) {
    a.fn.getFormAction = function() {
        var c = this,
        b = c[0];
        if (b && b.tagName.toLowerCase() === "form") {
            return encodeURI(c.attr("action"))
        }
        return null
    };
    a.fn.paramForm = function(d) {
        var c = this[0];
        var b = {};
        a("input,select,textarea,", c).not("[type=submit]").filter("[name]").each(function(g, f) {
            if ((a(f).attr("type") === "checkbox" || a(f).attr("type") === "radio") && a(f).prop("checked") === true || (a(f).attr("type") !== "checkbox" && a(f).attr("type") !== "radio")) {
                if (a.type(b[f.name]) !== "undefined") {
                    b[f.name] += "," + f.value
                } else {
                    b[f.name] = f.value
                }
            }
        });
        if (a.isPlainObject(d)) {
            a.extend(b, d)
        }
        return a.param(b)
    };
    a.fn.lengthLimit = function(b) {
        this.filter("textarea,input[type=text]").each(function() {
            var f = a(this),
            d = f.attr("maxlength");
            var c = function(j) {
                var i = j ? j.keyCode: null;
                if (!i || i === 8 || i === 13 || i > 36 && i < 41) {
                    return
                }
                var h = this,
                g = h.value,
                k = g.cut(d, "");
                if (k.length < g.length) {
                    h.value = k;
                    h.scrollTop = h.scrollHeight
                }
            };
            a(this).change(function(g) {
                c.call(this, g)
            }).keyup(function(g) {
                c.call(this, g)
            });
            c.apply(this)
        });
        return this
    };
    a.fn.inputTagLimit = function(b) {
        var c = a.extend(true, {},
        {
            invalid: new RegExp("/"),
            taglen: 20
        },
        b);
        this.filter("textarea,input[type=text]").each(function() {
            var h = a(this),
            g = c.taglen,
            d;
            var f = function(n) {
                var l = n ? n.keyCode: null;
                if (!l || l === 8 || l === 13 || l > 36 && l < 41) {
                    return
                }
                var k = h.val(),
                i = k.split(" "),
                i = i[i.length - 1],
                j = k.substring(0, k.length - i.length);
                if (k[k.length - 1] != " " && i && i.lenB() > g) {
                    i = i.cut(g, "");
                    k = j + i
                }
                h.val(k.replace(c.invalid, ""));
                vl = h.val().length;
                setCursorPosition(h[0], {
                    start: vl,
                    end: vl
                })
            };
            a(this).change(function(i) {
                f.call(this, i)
            }).keyup(function(i) {
                f.call(this, i)
            });
            f.apply(this)
        });
        return this
    };
    a.fn.pagelimit = function(f) {
        var g = a(this),
        d = f.length || 0;
        function b() {
            var h = parseInt(this.value) || 0;
            var i = d || 0;
            if (h > i) {
                this.value = i
            } else {
                if (h < 1) {
                    this.value = 1
                } else {
                    this.value = h
                }
            }
        }
        function c(h) {
            if (! (h.keyCode >= 37 && h.keyCode <= 40 || h.keyCode == 46 || h.keyCode == 8)) {
                b.call(this)
            }
        }
        g.change(c).keyup(c);
        b.call(this)
    };
    a.fn.setCursorPosition = function(b) {
        this.each(function(d, f) {
            if (f.setSelectionRange) {
                f.setSelectionRange(b, b)
            } else {
                if (f.createTextRange) {
                    var c = f.createTextRange();
                    c.collapse(true);
                    c.moveEnd("character", b);
                    c.moveStart("character", b);
                    c.select()
                }
            }
        });
        return this
    }
})(jQuery); (function(a) {
    function b(c, g) {
        for (var d = 0,
        f = ""; d < g; d++) {
            f += c
        }
        return f
    }
    a.fn.autogrow = function(c) {
        this.filter("textarea").each(function() {
            this.timeoutId = null;
            var i = a(this),
            f = i.height();
            var h = a("<div></div>").css({
                position: "absolute",
                wordWrap: "break-word",
                top: 0,
                left: -9999,
                display: "none",
                width: i.width(),
                fontSize: i.css("fontSize"),
                fontFamily: i.css("fontFamily"),
                lineHeight: i.css("lineHeight")
            }).appendTo(document.body);
            var g = function() {
                var j = this.value.replace(/</g, "<").replace(/>/g, ">").replace(/&/g, "&").replace(/\n$/, "<br/>&nbsp;").replace(/\n/g, "<br/>").replace(/ {2,}/g,
                function(k) {
                    return b("&nbsp;", k.length - 1) + " "
                });
                h.html(j);
                a(this).css("overflow", "hidden").css("height", Math.max(h.height() + (parseInt(i.css("lineHeight")) || 0), f))
            };
            var d = function() {
                clearTimeout(this.timeoutId);
                var j = this;
                this.timeoutId = setTimeout(function() {
                    g.apply(j)
                },
                100)
            };
            a(this).change(g).keyup(d).keydown(d);
            g.apply(this)
        });
        return this
    }
})(jQuery);
function setIptFocus(a) {
    function b(d) {
        var c = d.target;
        c.style.color = "#333";
        c.value = "";
        $(a).unbind("focus", arguments.callee)
    }
    $(a).focus(b)
}
function setLabelIptFocus(c, b) {
    function a() {
        if ($.trim($(c).val()) !== "") {
            clearTimeout($(b).data("timer"));
            $(b).css("display", "none")
        } else {
            $(b).data("timer", setTimeout(function() {
                $(b).css("display", "block")
            },
            150))
        }
    }
    $(c).bind("blur",
    function(d) {
        a()
    }).bind("focus click",
    function() {
        clearTimeout($(b).data("timer"));
        $(b).css("display", "none")
    });
    a()
}
function resetTags(a, c) {
    var b = $(c).val();
    $("a", a).each(function(f, d) {
        if ((" " + b + " ").match(new RegExp("\\s" + d.innerHTML + "\\s", "ig"))) {
            $(d).addClass("added")
        } else {
            $(d).removeClass("added")
        }
    })
}
function tagSelectBind(a, b, c) {
    $(a).click(function(g) {
        g.preventDefault();
        var f = g.target;
        if (f.tagName.toLowerCase() == "a" && !f.className.match("added")) {
            var h = $(b),
            d = $.trim(h.val());
            vv = $.trim(d.replace(/,/ig, " ").replace(/\s{2,}/ig, " ")),
            arr = vv.split(" "),
            len = arr.length;
            if (len >= c) {
                alert("最多只能添加5个标签哦");
                return false
            }
            h.focus();
            h.val(h.val() + (d == "" || d.charAt(d.length - 1) == " " ? f.innerHTML + " ": " " + f.innerHTML + " "));
            f.className += "added"
        }
    });
    $(b).keyup(function(i) {
        i.stopPropagation();
        var g = $.trim(this.value),
        h = $.trim(g.replace(/,/ig, " ").replace(/\s{2,}/ig, " ")),
        f = h.split(" "),
        d = f.length;
        if (d > c) {
            this.value = g.replace(/([ ,])+?[^ ,]*$/ig,
            function(k, j) {
                return j
            });
            i.preventDefault();
            return false
        }
        resetTags(a, this)
    })
}
function setTagsHTML(b, a) {
    var c = [];
    if ($.isArray(a)) {
        $(a).each(function(f, d) {
            if (d !== "|") {
                c.push(' <a href="#">' + d + "</a>")
            }
        });
        $(b).html(c.slice(0, 20).join(""))
    }
}
function setDefaultTags(m) {
    var g = $("a", m),
    f = $.Bom.getSubCookie("sgm", "usedtags"),
    h = f ? f.split(";") : [];
    var a = [];
    for (var d = 0; d < g.length && d < 12; d++) {
        var l = $.trim(g[d].innerHTML);
        a.push(l)
    }
    a.push("|");
    for (var c = 0,
    b = 0; c < h.length; c++) {
        if ($.inArray(h[c], a) === -1) {
            a.push(h[c])
        }
    }
    for (var d = 12; d < g.length; d++) {
        var l = $.trim(g[d].innerHTML);
        a.push(l)
    }
    $.Bom.setSubCookie("sgm", "usedtags", a.join(";"), {
        expires: 30
    });
    setTagsHTML(m, a)
}
function setUsedTags(c, h) {
    var i = $(h);
    var g = $.trim(i.val());
    if (g) {
        var b = $.trim(g.replace(/\s{2,}/g, " ")).split(" "),
        f = $.Bom.getSubCookie("sgm", "usedtags"),
        a = f.split(";"),
        d = $.inArray("|", a);
        $(b).each(function(k, j) {
            if ($.inArray(j, a) === -1) {
                a = $.grep(a,
                function(l) {
                    return l !== j && $.trim(l) !== ""
                });
                a = a.slice(0, d).concat([j], a.slice(d))
            }
        });
        a = a.slice(0, 20);
        $.Bom.setSubCookie("sgm", "usedtags", a.join(";"), {
            expires: 30
        });
        setTagsHTML(c, a)
    }
}
function showSelectTags(a, d, c) {
    var f;
    function g() {
        if ($(this).data("mouselock")) {
            return
        }
        window.clearTimeout(f);
        if ($.isFunction(c)) {
            c(a, d, 1)
        } else {
            $(a).css("display", "block")
        }
    }
    function b() {
        if ($(this).data("mouselock")) {
            return
        }
        f = window.setTimeout(function() {
            if ($.isFunction(c)) {
                c(a, d)
            } else {
                $(a).css("display", "none")
            }
        },
        200)
    }
    $(d).bind("click focus mouseenter", g).blur(b);
    $(a).bind("mouseenter", g);
    $(a).bind("mouseleave", b)
}
function keyupLenLimitForU(b, v, c, m, s, k) {
    if (!b || typeof b.value == "undefined") {
        return
    }
    var n = /http(?:s)?:\/\/(?:[\w-]+\.)+[\w-]+(?:\:\d+)?(?:\/[\w-\.\/%]*)?(?:[?#][\w-\.%&=]*)?/g,
    t = [],
    a = [],
    v = v || 300,
    m = m || "",
    s = s || 0,
    k = $(k),
    q = b.value.replace(n,
    function(j, i, l) {
        t.push(j + "");
        a.push(i);
        return ""
    });
    k.html(v - q.length < 0 ? 0 : v - q.length);
    if (!s && q.lenB() >= v) {
        return true
    } else {
        if (s && q.length >= v) {
            q = q.substr(0, v);
            var f = [];
            for (var h = 0,
            g = 0,
            d = t.length; h < d && h < 8; h++) {
                f.push(q.slice(g, a[h]));
                f.push(t[h]);
                g = a[h]
            }
            f.push(q.slice(g, q.length));
            b.value = f.join("");
            $(b).scrollTop(1000);
            return true
        } else {
            return false
        }
    }
} (function(c) {
    var b = c.browser.msie && c.browser.version === "6.0",
    a = c.browser.opera;
    c.fn.sidepop = function(d) {
        var g = {
            _create: function(k, n) {
                var m = n.id,
                j = k.$pop;
                var l = ["none", "none", "none"];
                if (n.btnset == 1) {
                    l[2] = ""
                } else {
                    if (n.btnset == 2) {
                        l[0] = ""
                    } else {
                        if (n.btnset == 3) {
                            l[2] = "";
                            l[0] = ""
                        }
                    }
                }
                k.$dom = c('<div class="' + m + '"></div>').append(c(n.btnset ? ['<div class="', n.btnClass.bars, '"><a  class="', n.btnClass.min, '" style="display:', l[0], '" href="javascript:;" target="_self">-</a><a class="', n.btnClass.max, '" style="display:', l[1], '" href="javascript:;" target="_self">+</a><a class="', n.btnClass.close, '" style="display:', l[2], '" href="javascript:;" target="_self">X</a></div>'].join("") : "")).append(c('<div class="' + n.btnClass.cont + '"></div>').append(j)).appendTo(n.position)
            },
            _feature: function(n, p) {
                var m = n.$pop,
                k = n.$dom,
                o = c(window).width(),
                l = c(window).height(),
                j = c(window).scrollTop();
                n.size = [p.width === null ? c("." + p.btnClass.cont, k).outerWidth() : p.width, p.height === null ? c("." + p.btnClass.cont, k).outerHeight() : p.height];
                k.css({
                    position: "absolute",
                    bottom: "auto",
                    zIndex: p.zIndex,
                    width: n.size[0],
                    height: n.size[1]
                });
                n.bias = p.bias === "middle" ? (l - n.size[1]) / 2 : p.bias;
                n.departure = p.departure === "center" ? (o - n.size[0]) / 2 : p.departure;
                if (b && p.baseline == "bottom" || a && p.baseline == "bottom") {
                    n.bias -= 2
                }
                k.css({
                    left: p.dockSide === "right" ? "auto": n.departure,
                    right: p.dockSide === "left" ? "auto": n.departure
                });
                if (p.baseline == "bottom") {
                    if (!b && p.isFixed == 1) {
                        k.css({
                            position: "fixed",
                            top: "auto",
                            bottom: n.bias
                        })
                    }
                } else {
                    if (p.baseline == "top") {
                        if (!b && p.isFixed == 1) {
                            k.css({
                                position: "fixed",
                                bottom: "auto",
                                top: n.bias
                            })
                        }
                    }
                }
            },
            _bindBars: function(k, m) {
                var j = k.$dom,
                l = m.btnClass;
                c("." + l.bars, j).click(function(n) {
                    var o = c(n.target);
                    if (o.hasClass(l.close)) {
                        g.close(k, m)
                    } else {
                        if (o.hasClass(l.show)) {
                            g.show(k, m)
                        } else {
                            if (o.hasClass(l.min)) {
                                g.min(k, m)
                            } else {
                                if (o.hasClass(l.max)) {
                                    g.max(k, m)
                                }
                            }
                        }
                    }
                })
            },
            _scrollAnim: function(j, k) {
                if (k.scroll === 2) {
                    j.$dom.stop().css({
                        opacity: 0,
                        top: g._getTop(j, k)
                    }).animate({
                        opacity: 1
                    },
                    k.fadeSpeed)
                } else {
                    j.$dom.animate({
                        top: g._getTop(j, k)
                    },
                    k.floatSpeed)
                }
            },
            _eventScroll: function(k) {
                var j = k.data.props,
                l = k.data.c;
                if (l.scroll === 2) {
                    j.$dom.not(":animated").css({
                        opacity: 0
                    })
                }
                window.clearTimeout(j.scrollTimer);
                j.scrollTimer = window.setTimeout(function() {
                    g._scrollAnim(j, l)
                },
                l.scrollDelayTime)
            },
            _bindScroll: function(j, k) {
                if (!b && k.isFixed == 1 || k.scroll === 0) {
                    return
                }
                c(window).scroll({
                    props: j,
                    c: k
                },
                g._eventScroll);
                g._scrollAnim(j, k)
            },
            _unbindScroll: function() {
                c(window).unbind("scroll", g._eventScroll)
            },
            _getTop: function(o, n) {
                var p = o.bias,
                s = o.$dom,
                q = s.outerHeight(true),
                l = c(window).width(),
                j = c(window).height(),
                m = c(window).scrollTop(),
                k = q + p - j;
                k = k < 0 ? 0 : k;
                switch (n.baseline) {
                case "top":
                    return m + p - k;
                case "bottom":
                    return m + j - q - p + k
                }
            },
            close: function(l, n) {
                var j = l.$dom,
                m = n.btnClass;
                j.css("display", "none");
                g._unbindScroll(l, n);
                var k = m.close;
                c("." + k, j).removeClass(k).addClass(m.show);
                if (c.isFunction(n.fnAfterClose)) {
                    n.fnAfterClose.call(g, l, n)
                }
            },
            show: function(l, n) {
                var j = l.$dom,
                m = n.btnClass;
                j.css("display", "block");
                g._bindScroll(l, n);
                var k = m.show;
                c("." + k, j).removeClass(k).addClass(m.close)
            },
            min: function(l, o) {
                var k = l.$dom,
                m = o.btnClass,
                n = o.expandDir === "left-right",
                j = n ? {
                    width: o.remainArea
                }: {
                    height: o.remainArea
                };
                if (!n && o.baseline === "bottom") {
                    j.marginTop = l.size[1] - o.remainArea
                }
                k.animate(j,
                function() {
                    c("." + m.min, k).css("display", "none");
                    c("." + m.max, k).css("display", "inline")
                })
            },
            max: function(l, o) {
                var k = l.$dom,
                m = o.btnClass,
                n = o.expandDir === "left-right",
                j = n ? {
                    width: l.size[0]
                }: {
                    height: l.size[1]
                };
                if (!n && o.baseline === "bottom") {
                    j.marginTop = 0
                }
                k.animate(j,
                function() {
                    c("." + m.min, k).css("display", "inline");
                    c("." + m.max, k).css("display", "none")
                })
            },
            _noop: c.noop
        };
        var i = c.extend(true, {},
        c.fn.sidepop.defaults, d);
        var f = c(this),
        h = {};
        h.$pop = f;
        g._create(h, i);
        g._feature(h, i);
        g._bindBars(h, i);
        g._bindScroll(h, i);
        if (c.isFunction(i.fnInitExe)) {
            i.fnInitExe.call(g, h, i)
        }
        return this
    };
    c.fn.sidepop.defaults = {
        id: "",
        position: "body",
        width: null,
        height: null,
        remainArea: 25,
        initTop: null,
        btnClass: {
            min: "SG-sidemin",
            max: "SG-sidemax",
            close: "SG-sideclose",
            show: "SG-sideshow",
            bars: "SG-sidebar",
            cont: "SG-sidecont"
        },
        btnset: 1,
        scroll: 2,
        fnInitExe: null,
        fnAfterClose: null,
        dockSide: "left",
        departure: 0,
        baseline: "bottom",
        popregion: 300,
        isFixed: 0,
        bias: 100,
        expandDir: "top-down",
        floatSpeed: 150,
        fadeSpeed: 250,
        scrollDelayTime: 350,
        zIndex: 1000
    }
})(jQuery); (function(b) {
    var a = 1;
    b.fn.tippop = function(c) {
        var d = {
            _create: function(h, j) {
                var i = j.id,
                g = h.$pop;
                h.$dom = b('<div class="' + i + ' SG-tippop"></div>').append(b('<div class="pr"><u></u></div>')).append(g).appendTo("body");
                h.size = [j.width, j.height];
                a = Math.max(a, j.zIndex);
                h.$dom.css({
                    position: "absolute",
                    bottom: "auto",
                    zIndex: j.zIndex,
                    width: h.size[0],
                    height: h.size[1],
                    display: "none"
                })
            },
            _bind: function(j, k) {
                var g = j.$dom,
                h = b(k.triger),
                i = k.delegateSelector;
                b(".SG-close", g).click(function(l) {
                    l.preventDefault();
                    d.close(j)
                });
                b(".SG-close-e", g).click(function(l) {
                    l.preventDefault();
                    d.close(j);
                    h.unbind(k.eventType);
                    g.remove()
                });
                g.bind("mouseenter",
                function(l) {
                    clearTimeout(g.data("timer"));
                    g.css({
                        zIndex: ++a
                    })
                }).bind("mouseleave",
                function(l) {
                    g.data("timer", setTimeout(function() {
                        d.close(j)
                    },
                    k.holdon))
                });
                if (i === null) {
                    h.bind(k.eventType,
                    function(l) {
                        d._show.call(this, j, k)
                    }).bind("mouseleave",
                    function() {
                        g.mouseleave()
                    })
                } else {
                    h.delegate(i, k.eventType,
                    function(l) {
                        d._show.call(this, j, k)
                    }).delegate(i, "mouseleave",
                    function() {
                        g.mouseleave()
                    })
                }
            },
            close: function(g, h) {
                g.$dom.css("display", "none")
            },
            _show: function(s, p) {
                var l = s.$pop,
                v = s.$dom,
                i = v.outerWidth(),
                u = v.outerHeight(),
                g = b(document).width(),
                q = b(document).height(),
                o = this === d || p.triger0 ? b(p.triger) : b(this),
                t = o.offset(),
                m = o.outerWidth(),
                h = o.outerHeight(),
                j;
                clearTimeout(v.data("timer"));
                s.offset = [t.left + p.biasX, t.top + p.biasY];
                var n = s.offset[0],
                k = s.offset[1];
                s.offset[0] = n + i > g ? g - i - 20 : n;
                s.offset[1] = k + u > q ? q - u - 20 : k;
                v.css({
                    left: s.offset[0],
                    top: s.offset[1],
                    zIndex: ++a,
                    display: "block"
                })
            },
            _noop: b.noop
        };
        var f = b.extend(true, {},
        b.fn.tippop.defaults, c);
        return this.each(function() {
            var g = b(this),
            h = {};
            if (!g.data("tippop")) {
                h.$pop = g;
                d._create(h, f);
                d._bind(h, f);
                if (f.loadShow) {
                    d._show(h, f)
                }
                if (b.isFunction(f.fnInitExe)) {
                    f.fnInitExe.call(d, h, f)
                }
                g.data("tippop", true)
            }
        }).closest("." + f.id)
    };
    b.fn.tippop.defaults = {
        id: "",
        triger: null,
        triger0: false,
        eventType: "mouseover",
        holdon: 1000,
        delegateSelector: null,
        width: "auto",
        height: "auto",
        biasX: 0,
        biasY: 0,
        loadShow: false,
        fnInitExe: null,
        zIndex: 3000
    }
})(jQuery); (function(c) {
    function a() {
        var f = this,
        d = f.data("albumlike");
        d.cancel = 1;
        if (f.siblings("i").length >= 1 && parseInt(f.siblings("i").html()) >= 0) {
            f.siblings("i").html(parseInt(f.siblings("i").html()) + 1 + "人喜欢")
        }
        if (f.siblings("span").length >= 1 && parseInt(f.siblings("span").html()) >= 0) {
            f.siblings("span").html(parseInt(f.siblings("span").html()) + 1 + "人喜欢")
        }
        f.addClass("albumliked").removeClass("abtn abtn-it").html("取消喜欢")
    }
    function b() {
        var f = this,
        d = f.data("albumlike");
        d.cancel = 0;
        if (f.siblings("i").length >= 1 && parseInt(f.siblings("i").html()) >= 0) {
            f.siblings("i").html(parseInt(f.siblings("i").html()) - 1 + "人喜欢")
        }
        if (f.siblings("span").length >= 1 && parseInt(f.siblings("span").html()) >= 0) {
            f.siblings("span").html(parseInt(f.siblings("span").html()) - 1 + "人喜欢")
        }
        f.removeClass("albumliked").addClass("abtn abtn-it").html("<u>喜欢</u>")
    }
    c.fn.SGalbumlike = function(h, f, g) {
        if (typeof h !== "function") {
            g = f;
            f = h;
            h = c.noop
        }
        if (typeof f !== "string") {
            g = f;
            f = ""
        }
        g = c.extend({},
        g);
        function d(k) {
            k.preventDefault();
            if (!getUSERID()) {
                SUGAR.PopOut.login();
                return
            }
            var n = c(k.target).closest("a"),
            j = n.data("albumlike"),
            m = j.id,
            i = "/album/unlike/",
            l = "/album/like/";
            if (n.data("locked")) {
                return
            }
            n.data("locked", 1);
            if (j.cancel) {
                c.get(i + m + "/",
                function() {
                    b.call(n);
                    n.removeData("locked")
                })
            } else {
                c.ajax({
                    type: "GET",
                    cache: false,
                    url: l + m + "/",
                    timeout: 20000,
                    success: function(p) {
                        var o = c.isPlainObject(p) ? p: c.parseJSON(p);
                        if (!o) {
                            return
                        }
                        if (o.success) {
                            a.call(n)
                        } else {
                            SUGAR.PopOut.alert('<div class="prompt prompt-fail"><h3>' + o.message + "</h3></div>")
                        }
                    }
                }).always(function() {
                    n.removeData("locked")
                })
            }
        }
        if (f) {
            this.delegate(f, "click", d)
        } else {
            this.click(d)
        }
        return this
    }
})(jQuery);
$(function() {
    $(document).SGalbumlike(".albumlikebtn", {})
}); (function(a) {
    a.fn.myalbums = function(m, h, j) {
        var i = this;
        if (i.length <= 0) {
            return
        }
        if (typeof m !== "function") {
            j = h;
            h = m;
            m = a.noop
        }
        if (typeof h !== "string") {
            j = h;
            h = ""
        }
        var b = a.extend({},
        a.fn.myalbums.defaults, j),
        p = !!h,
        f = p ? a(h, i) : i,
        k,
        o,
        c,
        g;
        b.fn = m;
        l();
        function d(q) {
            if (!getUSERID()) {
                return
            }
            if (a(b.sel_holder) != a("body")) {
                k.appendTo(b.sel_holder)
            } else {
                k.css({
                    position: "absolute",
                    zIndex: 30001,
                    left: q.left + b.biasleft,
                    top: q.top + b.biasleft
                })
            }
            k.css("display", k.css("display") == "block" ? "none": "block");
            if (a("a", c).length <= 1) {
                c.addClass("loading");
                a.ajax({
                    type: "GET",
                    cache: false,
                    url: "/album/collect/list/?count=0",
                    timeout: 20000,
                    success: function(x) {
                        c.removeClass("loading");
                        var u = a.isPlainObject(x) ? x: a.parseJSON(x);
                        if (!u) {
                            return
                        }
                        if (u.success) {
                            var y = u.data.albums,
                            t = o.val();
                            if (y && y.length) {
                                for (var w = 0,
                                s = y.length; w < s; w++) {
                                    a("<a " + (t == y[w].id ? 'class="cur"': "") + ' href="#" data-albumid="' + y[w].id + '">' + y[w].name.cut(40, "…") + "</a>").appendTo(c)
                                }
                                if (t == 0) {
                                    c.find("a").eq(0).addClass("cur")
                                }
                            }
                        } else {
                            SUGAR.PopOut.alert('<div class="prompt prompt-fail"><h3>' + u.message + "</h3></div>")
                        }
                    }
                })
            } else {
                k.find(".cur").removeClass("cur").end().find("a[data-albumid=" + o.val() + "]").addClass("cur")
            }
        }
        function n(q, s) {
            o.val(q);
            i.html(s);
            c.find(".cur").removeClass("cur").end().find("a[data-albumid=" + q + "]").addClass("cur").prependTo(c);
            c.scrollTop(0);
            k.css("display", "none")
        }
        function l() {
            o = a(b.sel_valueipt);
            if (!o.length) {
                o = a('<input class="dn" type="text" value="">').appendTo(i)
            }
            k = a("#myalbums-wrap");
            if (!k.length) {
                k = a('<div id="myalbums-wrap" style="display:none"><div id="myalbums-albs"><a data-albumid="0" href="javascript:;">未分类</a></div><div class="clr"><form action="/album/add/" method="post"><input type="text" value="" name="name" class="ipt l" maxlength="40"><a target="_self" href="javascript:;" class="abtn abtn-s l"><button type="submit"><u>创建</u></button></a></form></div></div>').click(function(q) {
                    q.stopPropagation()
                }).appendTo("body");
                k.find("input").lengthLimit()
            }
            a(document).click(function(q) {
                k.css("display", "none")
            });
            c = a("#myalbums-albs");
            c.delegate("a", "click",
            function(t) {
                t.preventDefault();
                var s = this.innerHTML,
                q = a(this).data("albumid") || 0;
                n(q, s)
            });
            k.find("input").click(function() {
                a(this).focus()
            });
            k.find("form").safeSubmit(function(t) {
                var s = this,
                q = a(s);
                q.find(".abtn").addClass("abtn-no").find("[type=submit]").add(q).prop("disabled", true);
                a.ajax({
                    type: "POST",
                    url: q.getFormAction(),
                    data: q.paramForm(),
                    timeout: 20000,
                    success: function(x) {
                        var w = a.isPlainObject(x) ? x: a.parseJSON(x);
                        if (!w) {
                            return
                        }
                        if (w.success) {
                            var y = q.find("input"),
                            u = a.trim(y.val());
                            y.val("");
                            c.prepend(a('<a href="#" data-albumid="' + w.data.id + '">' + u.cut(40, "…") + "</a>")).scrollTop(0);
                            n(w.data.id, u)
                        } else {
                            SUGAR.PopOut.alert('<div class="prompt prompt-fail"><h3>' + w.message + "</h3></div>")
                        }
                    },
                    error: function() {
                        SUGAR.PopOut.alert('<div class="prompt prompt-fail"><h3>服务器出错或网络问题。</h3><p>喝杯茶，浏览<a class="lkl" href="/recommend/">其他页面</a>吧。</p></div>')
                    }
                }).always(function() {
                    q.find(".abtn").removeClass("abtn-no").find("[type=submit]").add(q).removeProp("disabled")
                })
            });
            f.bind(b.event,
            function(q) {
                q.stopPropagation();
                q.preventDefault();
                var s = a(this).offset();
                d(s)
            })
        }
        return k
    };
    a.fn.myalbums.defaults = {
        sel_holder: "body",
        sel_valueipt: "",
        event: "click",
        biastop: 0,
        biasleft: 0
    }
})(jQuery); (function(l) {
    var i, k = false,
    d, o, w, a, s, g, f, n;
    function p(x) {
        SUGAR.PopOut.alert([null, d, ""], 2)
    }
    function m() {
        g.find("a.abtn").addClass("abtn-no");
        g.find("a.abtn [type=submit]").add(l("#re-sycn-sina")).prop("disabled", true);
        g.find(".s-sina").css({
            opacity: 0.5,
            color: "#aaa"
        })
    }
    function q() {
        g.find("a.abtn,").removeClass("abtn-no");
        g.find("a.abtn [type=submit]").add(l("#re-sycn-sina")).removeProp("disabled");
        g.find(".s-sina").css({
            opacity: 1,
            color: "#333"
        })
    }
    function c(x, y) {
        s.find("input[name=album]").val(x).end().find("a").html(y)
    }
    function j(y, x) {
        f.html(x).attr("class", y)
    }
    function u() {
        o.val("");
        j("", "")
    }
    function v(z, x, A, B) {
        blinkIt(function() {
            j("re-postsuc", A[0] + "成功！")
        },
        null,
        function() {
            SUGAR.PopOut.closeMask();
            l.isFunction(B) && B(z);
            u()
        },
        1, 800);
        if (z && z.blog) {
            var C = l(i);
            C.addClass("re-done").attr("href", "/people/mblog/" + z.blog + "/detail/").attr("target", "_blank").attr("title", "去看看我收集好的");
            if (x) {
                var y = parseInt(C.find("u").text()) || 0;
                C.find("u").html(y + 1)
            }
        }
    }
    function t(E, A, C, D) {
        b("/people/mblog/forward/", ["收集", "收集到", "收集"], D);
        d.css("display", "block");
        u();
        q();
        var y = E.closest(".js-favorite-blog");
        o.val(y.length ? y.find(".js-favorite-blogtit").text() : E.closest(".dym").find("div.g").text());
        l("#re-inp-parent").attr("name", "parent").val(A);
        w.empty().scrollTop(0);
        var z = y.find("img.js-favorite-blogimg");
        if (z.length) {
            var x = z.data("height"),
            B = z.data("width"),
            x = x * 200 / B,
            F = l("<img />").attr("src", z.attr("src")).appendTo(w)
        } else {
            z = E.closest("div.dym").find("div.mbpho img");
            var x = parseInt(z.attr("height")),
            F = l("<img />").attr("src", z.attr("src")).appendTo(w)
        }
        F.css({
            width: 200,
            marginTop: x <= 200 ? (200 - x) / 2 : 0,
            cursor: x <= 200 ? "default": "move"
        });
        l.data(w[0], "imgProp", {
            height: x
        });
        p(E)
    }
    function h(H, A, F, G, E, D, B) {
        b("/blog/edit/", ["编辑", "转移到", "提交"], G, E, D, B);
        d.css("display", "block");
        u();
        q();
        var y = H.closest(".js-favorite-blog");
        o.val(y.length ? y.find(".js-favorite-blogtit").text() : H.closest(".dym").find("div.g").text());
        l("#re-inp-parent").attr("name", "blog").val(A);
        w.empty().scrollTop(0);
        var z = y.find("img.js-favorite-blogimg");
        if (z.length) {
            var x = z.data("height"),
            C = z.data("width"),
            x = x * 200 / C,
            I = l("<img />").attr("src", z.attr("src")).appendTo(w)
        } else {
            z = H.closest("div.dym").find("div.mbpho img");
            var x = parseInt(z.attr("height")),
            I = l("<img />").attr("src", z.attr("src")).appendTo(w)
        }
        I.css({
            width: 200,
            marginTop: x < 200 ? (200 - x) / 2 : 0,
            cursor: x <= 200 ? "default": "move"
        });
        l.data(w[0], "imgProp", {
            height: x
        });
        p(H)
    }
    function b(y, x, D, C, B, z) {
        if (!d || !d.length) {
            d = l('<div id="re-favorite"><form action="' + y + '" target="_self"><div id="re-head"><a id="re-close" target="_self" href="javascript:;" onclick="SUGAR.PopOut.closeMask();">关闭</a><h1>' + x[0] + '</h1></div><div id="re-cont" class="clr"><div id="re-left" class="l"></div> <div id="re-right" class="r"> <p>' + x[1] + '</p> <div id="re-albumsel"><input class="dn" type="text" data-optional="1" value="0" name="album"><a id="re-albumtrig" href="javascript:;">未分类</a></div><textarea name="content" class="txa"></textarea> <div id="re-subpan" class="u-chk clr"> <a href="javascript:;" class="abtn abtn-s l "><button type="submit"><u>' + x[2] + "</u></button></a>" + (typeof BIND_SITES != n && BIND_SITES.sina ? '<input id="re-sycn-sina" type="checkbox" value="sina" class="chk s-sina" name="syncpost" ' + (l.Bom.getSubCookie("sgy", "sync").indexOf("sina") === -1 ? "checked": "") + '/><label class="s-sina" title="同步到新浪微博" for="re-sycn-sina">同步</label><div class="re-mbsite s-sina">新浪</div>': "") + '<div id="re-poststat"></div></div></div></div><input id="re-inp-parent" type="hidden" name="parent" value="" data-optional="1" /></form></div>').appendTo("#win-house");
            l("#re-sycn-sina").change(function() {
                var I = l(this),
                G = I.attr("value"),
                H = l.Bom.getSubCookie("sgy", "sync");
                if (!I.prop("checked") && H.indexOf(G) === -1) {
                    l.Bom.setSubCookie("sgy", "sync", H + "," + G, {
                        expires: 365
                    })
                } else {
                    if (I.prop("checked")) {
                        l.Bom.setSubCookie("sgy", "sync", H.replace("," + G, ""), {
                            expires: 365
                        })
                    }
                }
            });
            f = l("#re-poststat");
            s = d.find("#re-albumsel");
            if (z) {
                s.addClass("re-onlyedit")
            } else {
                s.removeClass("re-onlyedit").find("a").myalbums({
                    sel_valueipt: s.find("input[name=album]"),
                    sel_holder: d
                })
            }
            if (typeof C != "undefined") {
                C = C || "";
                B = B || "未分类";
                c(C, B)
            } else {
                var F = l.Bom.getSubCookie("sgm", "postalbumid-" + getUSERID()) || "",
                E = l.Bom.getSubCookie("sgm", "postalbumnm-" + getUSERID()) || "未分类";
                c(F, E)
            }
            w = l("#re-left").mousemove(function(K) {
                K.stopPropagation();
                if (l.data(this, "movelock")) {
                    return
                }
                var N = l(this),
                J = l.data(this, "imgProp") || {},
                I = J.height;
                if (I > 200) {
                    var M = K.pageY,
                    H = w.offset().top,
                    G = M - H - 50,
                    G = G < 0 ? 0 : G,
                    L;
                    l.data(this, "movelock", true);
                    N.stop().animate({
                        scrollTop: G * (I - 200) * 2 / 200
                    },
                    50, "linear",
                    function() {
                        l.data(N[0], "movelock", false)
                    })
                }
            });
            o = d.find("textarea.txa");
            function A(G) {
                keyupLenLimitForU(G.currentTarget, null, "", "", 1)
            }
            o.keyup(A).blur(A).focus(A);
            keyupLenLimitForU(o[0], null, "", "", 1);
            o.at({
                isFixed: true
            });
            g = d.find("form").safeSubmit(function(I) {
                var H = l(this),
                K = o.val(),
                G = s.find("input").val(),
                J = l("#re-albumtrig").text();
                m();
                j("re-inpost", "正在提交，请稍候");
                l.ajax({
                    type: "POST",
                    cache: false,
                    url: H.getFormAction(),
                    data: H.paramForm(getToken(2)),
                    timeout: 20000,
                    success: function(M) {
                        var L = l.isPlainObject(M) ? M: l.parseJSON(M);
                        if (!L || typeof L != "object") {
                            j("re-posterr", "出现异常，请刷新页面试试");
                            return
                        }
                        if (!L.data) {
                            L.data = {}
                        }
                        L.data.content = K;
                        L.data.albumid = G;
                        L.data.albumname = J;
                        if (L.success) {
                            var N = s.find("[name=album]").val(),
                            O = s.find("a").html();
                            if (N) {
                                l.Bom.setSubCookie("sgm", "postalbumid-" + getUSERID(), N, {
                                    expires: 30
                                });
                                l.Bom.setSubCookie("sgm", "postalbumnm-" + getUSERID(), O, {
                                    expires: 30
                                })
                            }
                            v(L.data, 1, x, D)
                        } else {
                            if (l.trim(mergeServerMessage(L.message)) == "你已经收集了该分享") {
                                v(L.data, null, x, D)
                            } else {
                                j("re-posterr", mergeServerMessage(L.message));
                                q()
                            }
                        }
                    },
                    error: function() {
                        j("re-posterr", "网络原因导致失败，请稍候再试");
                        q()
                    }
                }).always(function() {})
            },
            function(G) {
                blinkIt(function() {
                    o.css({
                        backgroundColor: "#d7ebf7"
                    })
                },
                function() {
                    o.css({
                        backgroundColor: "#fff"
                    })
                },
                function() {
                    o.focus()
                },
                4, 200)
            })
        }
        g.attr("action", y);
        d.find("h1").html(x[0]).end().find("#re-right p").eq(0).html(x[1]).end().find(".abtn-s u").html(x[2])
    }
    l.fn.SGfavorite = function(y) {
        y = y || {};
        var A = y.etype || "click",
        z = y.callback;
        function x(E) {
            if (l(this).hasClass("re-done")) {
                return true
            }
            E.stopPropagation();
            E.preventDefault();
            var H = l(this),
            C = H.data("favorite"),
            C = C ? C: H.closest(".d").data("favorite"),
            B = C ? C.id: 0,
            D = getUSERID(),
            G = C.owner,
            F;
            i = this;
            if (C.edit == true && (G == D || isSTAFF())) {
                h(H, B, G, z, C.belongalbumid, C.belongalbumname, C.onlyedit)
            } else {
                if (G == D) {
                    alert("自己发布的不能再收集哦~");
                    return
                }
                t(H, B, G, z)
            }
        }
        if (!getUSERID()) {
            this.attr("title", "登录才能进行操作哦，点击就可以登录啦");
            this.live("click",
            function(B) {
                B.stopPropagation();
                B.preventDefault();
                SUGAR.PopOut.login();
                return
            })
        } else {
            this.live(A, x)
        }
        return this
    };
    l.fn.SGcomment = function(z) {
        z = z || {};
        function y(D, C, J, I, H, G, F, E) {
            I.stop().clearQueue().animate({
                height: 32
            },
            200).queue(function() {
                reposCol( - 90, G, F, E);
                l.data(I[0], "comment", -1)
            });
            l.data(I[0], "comment", 0)
        }
        function B(K, E, H, D, F, G, I, J) {
            if (typeof l.data(D[0], "comment") == "undefined") {
                var C = l('<div class="re-comt c"><form action="/comment/add/"><textarea class="txa" name="content"></textarea><a class="abtn abtn-s l" href="#">评论</a><input type="hidden" name="_type" value=""/><input type="hidden" value="' + E + '" name="comment_message_id"></form></div>').appendTo(D);
                C.find("textarea").at({
                    pageMembers: F.find("li p a")
                });
                C.find("a.abtn-s").click(function(O) {
                    O.stopPropagation();
                    O.preventDefault();
                    var P = l(this),
                    N = P.closest("form"),
                    L = N.find("textarea"),
                    M = l.trim(L.val());
                    if (!M) {
                        alert("请输入内容！");
                        return
                    }
                    if (P.hasClass("abtn-no")) {
                        return
                    }
                    P.addClass("abtn-no");
                    l.ajax({
                        type: "POST",
                        cache: true,
                        url: "/comment/add/",
                        data: N.paramForm(getToken(2)),
                        timeout: 20000,
                        success: function(S) {
                            var R = l.isPlainObject(S) ? S: l.parseJSON(S);
                            if (!R || typeof R != "object") {
                                return
                            }
                            if (R.success) {
                                var Q = l(['<li><a href="/myhome/" target="_blank"><img src="', R.data.replyerImg, '" width="24" height="24"></a><p><a href="/myhome/" target="_blank">我</a> ', R.data.content.replace(/<br\s*\/?>/i, " ").replace(/@[\u2E80-\u9FFF\d\w]{1,20}/ig, ""), "</p></li>"].join(""));
                                P.closest(".d").after(Q.css("display", "none"));
                                L.val("");
                                Q.slideDown(200,
                                function() {
                                    reposCol(Q.outerHeight(true), G, I, J)
                                });
                                var U = P.closest(".d").find(".x u"),
                                T = parseInt(U.text()) || 0;
                                U.html(++T)
                            } else {
                                SUGAR.PopOut.alert('<div class="prompt"><h3>' + mergeServerMessage(R.message) + "</h3></div>");
                                l({}).delay(800).queue(function() {
                                    SUGAR.PopOut.closeMask()
                                })
                            }
                        },
                        error: function() {
                            SUGAR.PopOut.alert('<div class="prompt prompt-fail"><h3>服务器出错或网络问题。</h3><p>喝杯茶，浏览<a class="lkl" href="/recommend/">其他页面</a>吧。</p></div>')
                        }
                    }).always(function() {
                        P.removeClass("abtn-no")
                    })
                })
            }
            D.stop().clearQueue().animate({
                height: 122
            },
            200).queue(function() {
                reposCol(90, G, I, J);
                l.data(D[0], "comment", 1)
            });
            l.data(D[0], "comment", 0)
        }
        function x(G) {
            G.stopPropagation();
            G.preventDefault();
            var E = l(G.target).closest("a"),
            C = E.closest(".d"),
            M = l.data(C[0], "comment");
            if (M === 0) {
                return
            }
            var F = C.closest(".dym"),
            O = E.data("favorite"),
            O = O ? O: C.data("favorite"),
            D = O.id,
            J = O.owner,
            N = l.data(l("#dym-area")[0], "zindex") || 10,
            M = M == n || M < 0 ? false: true,
            L = F[0].className,
            H = getNum(L.match(/\bsc\d+\b/ig).toString()),
            I = getNum(L.match(/\bco\d+\b/ig).toString()),
            K = parseInt(F.css("top")) || 0;
            F.css("zIndex", ++N);
            l.data(l("#dym-area")[0], "zindex", N);
            if (M) {
                y(E, D, J, C, F, H, I, K)
            } else {
                B(E, D, J, C, F, H, I, K)
            }
        }
        var A = "click";
        if (!getUSERID()) {
            this.attr("title", "登录才能评论，点击下就可以登录啦");
            this.live("click",
            function(C) {
                C.stopPropagation();
                C.preventDefault();
                SUGAR.PopOut.login();
                return
            })
        } else {
            this.live(A, x)
        }
        return this
    }
})(jQuery);
function callFavorite() {
    $("div.dym .d .y").SGfavorite();
    $("div.dym .d .x").SGcomment()
} (function(a) {
    a.fn.SGfollow = function(g, c, f) {
        if (typeof g !== "function") {
            f = c;
            c = g;
            g = a.noop
        }
        if (typeof c !== "string") {
            f = c;
            c = ""
        }
        f = a.extend({},
        f);
        var h = function() {
            var j = this,
            i = j.data("follow");
            if (i.rel > 1) {
                j.addClass("follow followed").removeClass("unfollow followeo")
            } else {
                j.addClass("follow").removeClass("unfollow")
            }
            j.html("加关注");
            i.rel += -1
        };
        var d = function() {
            var j = this,
            i = j.data("follow");
            if (i.rel > 1) {
                j.addClass("unfollow followeo").removeClass("follow followed")
            } else {
                j.addClass("unfollow").removeClass("follow")
            }
            i.rel += 1
        };
        var b = function(k) {
            k.preventDefault();
            if (!getUSERID()) {
                SUGAR.PopOut.login();
                return
            }
            var o = a(this),
            j = o.data("follow"),
            n = j.id,
            i = "/people/follow/del/",
            m = "/people/follow/add/",
            l;
            if (o.data("locked")) {
                return
            }
            o.data("locked", 1);
            a.ajax({
                type: "POST",
                cache: false,
                url: j.rel % 2 ? i + n + "/": m + n + "/",
                data: getToken(),
                timeout: 20000,
                success: function(q) {
                    var p = a.isPlainObject(q) ? q: a.parseJSON(q);
                    if (!p) {
                        return
                    }
                    if (p.success) {
                        j.rel % 2 ? h.call(o) : d.call(o)
                    } else {
                        SUGAR.PopOut.alert('<div class="prompt prompt-fail"><h3>' + p.message + "</h3></div>")
                    }
                }
            }).always(function() {
                o.removeData("locked")
            })
        };
        if (c) {
            this.delegate(c, "click", b)
        } else {
            this.click(b)
        }
        return this
    }
})(jQuery);
$(function() {
    if (getUSERID()) {
        return
    }
    var a = $.browser.msie && $.browser.version === "6.0",
    f;
    var d = $('<div id="popreg" class="clr"><a class="part1" href="/reg/">立即注册</a><div class="part2">登陆后才可记录喜好，找到对口味的内容^^ <br/> <span class="gray">已经有帐号？</span> <a onclick="SUGAR.PopOut.login();return false;" href="/login/">[登录]</a></div><div class="part3"><dl><dt>合作网站帐号登录</dt><dd id="weibo"><a href="/connect/sina/">新浪微博</a></dd><dd id="qq"><a href="/connect/qq/">QQ</a></dd><dd id="tq"><a href="/connect/qweibo/">腾讯微博</a></dd><dd id="douban"><a href="/connect/douban/">豆瓣</a></dd></dl></div></div>').sidepop({
        id: "side-popreg",
        dockSide: "left",
        width: "100%",
        scroll: 2,
        departure: 0,
        baseline: "top",
        bias: 0,
        isFixed: true,
        zIndex: 800,
        btnset: 0
    }).closest(".side-popreg");
    if (a && !$.Bom.getSubCookie("sg", "ie6updated")) {
        var c = $('<div id="pop-ie6update">想获得更好的浏览体验，友礼享建议你更新浏览器。推荐使用：<div class="clr ie6browser"><a target="_blank" class="chrome" href="http://www.google.cn/chrome/intl/zh-CN/landing_chrome.html?hl=zh-cn">Chrome</a><a target="_blank" class="jisu360" href="http://chrome.360.cn/">360极速</a><a target="_blank" class="ie9" href=" http://view.atdmt.com/action/mrtiex_FY12IE9StaPrdIE8WWpageforXPFNL_1?href=http://view.atdmt.com/action/mrtiex_FY12IE9StaPrdIE8WWpageforXPFNL_1?href=http://download.microsoft.com/download/1/6/1/16174D37-73C1-4F76-A305-902E9D32BAC9/IE8-WindowsXP-x86-CHS.exe">IE8</a><a target="_blank" class="firefox" href="http://firefox.com.cn/download/">Firefox</a></div><div class="tr SG-sidebar mt8"><a href="javascript:;" class="SG-sideclose r graylk">知道了</a></div></div>').sidepop({
            id: "side-ie6update",
            dockSide: "left",
            width: "auto",
            scroll: 2,
            departure: -4,
            baseline: "bottom",
            bias: -4,
            isFixed: true,
            zIndex: 800,
            btnset: 0
        }).closest(".side-ie6update");
        c.find(".SG-sideclose").click(function(g) {
            $.Bom.setSubCookie("sg", "ie6updated", 1)
        })
    }
    var b = function() {
        var i = $(window).scrollTop(),
        g = $(window).height(),
        h;
        d.css("visibility", i > 1000 ? "visible": "hidden");
        if (a) {
            c.css("visibility", i > 1000 ? "visible": "hidden")
        }
    };
    $(window).scroll(b);
    b()
}); (function(a) {
    a.fn.SGreport = function(h) {
        h = a.extend(a.fn.SGreport.defaults, h);
        var g = this,
        f, c = a.Bom.getSubCookie("sgm", "hasvoted"),
        d = getUSERID(),
        j = a.Bom.getCookie(h.cookiename);
        if (d && h.voteid && !c) {
            a.get("/vote/" + h.voteid + "/",
            function(l) {
                var k = a.isPlainObject(l) ? l: a.parseJSON(l);
                if (k.success) {
                    c = k.data.voted
                }
                if (c) {
                    i(j)
                }
                g.css("visibility", "visible")
            })
        } else {
            if (c) {
                i(j)
            }
            g.css("visibility", "visible")
        }
        this.delegate("a.SGrev-1", "click",
        function(k) {
            a.Bom.setCookie(h.cookiename, "1", {
                expires: 30
            });
            _gaq.push(["_trackPageview", "/_trc/swnav/oldnav"]);
            window.location.reload()
        }).delegate("a.SGrev-2", "click",
        function(k) {
            a.Bom.setCookie(h.cookiename, "2", {
                expires: 30
            });
            _gaq.push(["_trackPageview", "/_trc/swnav/newnav"]);
            window.location.reload()
        });
        function i(k) {
            g.html(k == "2" || !k ? '<a class="SGrev-1 SGreonlyv" href="#" class="lkl">回旧版 ></a>': '<a class="SGrev-2 SGreonlyv" href="#" class="lkl">去新版 ></a>')
        }
        function b(l) {
            l.preventDefault();
            l.stopPropagation();
            if (f) {
                f.remove()
            }
            var k = d && !c;
            f = a('<div id="SGreport">' + (k ? "<h3>" + h.words + '</h3><div class="SGrechoose"><form action="/vote/' + h.voteid + '/choose/"><ul><li><input id="SGrelove" type="radio" name="choice" value="' + h.votechoices[0].id + '"/> <label for="SGrelove">' + h.votechoices[0].wds + '</label></li> <li><input id="SGredislike" type="radio" name="choice" value="' + h.votechoices[1].id + '"/> <label for="SGredislike">' + h.votechoices[1].wds + '</label></li><li class="SGremore"><div><textarea data-optional="1" id="SGretxa" class="txa" name="content"></textarea><label for="SGretxa">写下你的反馈意见</label></div></li><li id="SGresub" class="clr"><a id="SGreabtn" href="#" class="l abtn abtn-s abtn-no"><button type="submit"><u>提交</u></button></a></li></ul></form></div>': "") + '<div class="SGreturn">' + (j == "2" || !j ? '不喜欢新版，<a class="SGrev-1" href="#" class="lkl">切换回旧版</a>': '<a class="SGrev-2" href="#" class="lkl">想尝试新版，切换到新版</a>') + '</div><div class="mt8 tr"><a id="SGreclose" href="#" class="lkl">关闭</a></div></div>').appendTo(a(h.cont));
            setLabelIptFocus(f.find("#SGretxa")[0], f.find("li.SGremore label")[0]);
            a("#SGreclose").click(function(m) {
                m.preventDefault();
                m.stopPropagation();
                f.remove();
                a.Bom.setSubCookie("sgm", "hasvoted", 1, {
                    expires: 30
                });
                i(a.Bom.getCookie(h.cookiename))
            });
            a("#SGrelove,#SGredislike").click(function(m) {
                a("#SGreabtn").removeClass("abtn-no")
            });
            f.find("form").safeSubmit(function() {
                var m = a(this),
                n = a("#SGreabtn"),
                o = a.trim(m.find("textarea.txa").val());
                if (n.hasClass("abtn-no")) {
                    return
                }
                n.addClass("abtn-no");
                a.ajax({
                    type: "GET",
                    cache: true,
                    url: m.getFormAction(),
                    data: m.paramForm(getToken(2)),
                    timeout: 20000000,
                    success: function(q) {
                        var p = a.isPlainObject(q) ? q: a.parseJSON(q);
                        if (!p || typeof p != "object") {
                            return
                        }
                        if (p.success) {
                            a("#SGresub").addClass("red").html("友礼享谢谢你的意见");
                            a.Bom.setSubCookie("sgm", "hasvoted", 1, {
                                expires: 30
                            })
                        } else {
                            var s = mergeServerMessage(p.message);
                            SUGAR.PopOut.alert('<div class="prompt"><h3>' + s + "</h3></div>")
                        }
                    },
                    error: function() {
                        SUGAR.PopOut.alert('<div class="prompt"><h3>' + mergeServerMessage(jsn.message) + "</h3></div>")
                    }
                }).always(function() {
                    n.removeClass("abtn-no")
                })
            })
        }
        if (h.trigger) {
            this.delegate(h.trigger, "click", b)
        }
        return this
    };
    a.fn.SGreport.defaults = {
        cont: document,
        trigger: "",
        cookiename: "",
        words: "",
        votechoices: [],
        voteid: undefined
    }
})(jQuery);
var _gaq = _gaq || [];
_gaq.push(["_setAccount", "UA-19056403-7"]);
_gaq.push(["_setDomainName", "duitang.com"]);
_gaq.push(["_trackPageview"]); (function() {
    var b = document.createElement("script");
    b.type = "text/javascript";
    b.async = true;
    b.src = ("https:" == document.location.protocol ? "https://ssl": "http://www") + ".google-analytics.com/ga.js";
    var a = document.getElementsByTagName("script")[0];
    a.parentNode.insertBefore(b, a)
})();