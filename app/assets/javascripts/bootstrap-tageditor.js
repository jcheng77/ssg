!function( $ ){

  "use strict"

    var Tageditor = function ( element, options ) {
        this.$element = $(element)
        this.input = this.$element.find('ul.tags li input');
        this.options = $.extend({}, $.fn.tageditor.defaults, options)
        this.matcher = this.options.matcher || this.matcher
        this.sorter = this.options.sorter || this.sorter
        this.highlighter = this.options.highlighter || this.highlighter
        this.$menu = $(this.options.menu).appendTo('body')
        this.source = this.options.source
        this.shown = false
        this.listen()
    }

    Tageditor.prototype = {

        constructor: Tageditor

        , select: function () {
            var val;
            if(this.shown){
                val = this.$menu.find('.active').attr('data-value')
                this.hide();
            }else{
                val = $.trim(this.input.val());
            }
            if(val){
                this.appendTag(val);
            }
        }
        , getValue: function(){
            var a = [];
            this.$element.find('ul.tags li.tag span').each(function(){
                a.push($(this).html());
            });
            return a.join(' ');
        }

        , appendTag: function(val) {
            var insert = this.options.insert.replace('{0}',val);
            $(insert).insertBefore(this.$element.find('ul.tags li').filter(':last'));
            this.input.val('');
        }

        , deleteTag: function(event) {
            var target = event.target;
            $(target.parentNode).remove();
        }

        , deleteLastTag: function(){
            var val = this.input.val();
            if(val.length == 0){
                this.$element.find('ul.tags li.tag').filter(':last').remove();
            }
        }

        , show: function () {
            var pos = $.extend({}, this.$element.offset(), {
                height: this.$element[0].offsetHeight
            })

            this.$menu.css({
                top: pos.top + pos.height
                , left: pos.left
            })

            this.$menu.show()
            this.shown = true
            return this
        }

        , hide: function () {
            this.$menu.hide()
            this.shown = false
            return this
        }

        , lookup: function (event) {
            var that = this
                , items
                , q

            this.query = this.input.val()

            if (!this.query) {
                return this.shown ? this.hide() : this
            }

            items = $.grep(this.source, function (item) {
                if (that.matcher(item)) return item
            })

            items = this.sorter(items)

            if (!items.length) {
                return this.shown ? this.hide() : this
            }

            return this.render(items.slice(0, this.options.items)).show()
        }

        , matcher: function (item) {
            return ~item.toLowerCase().indexOf(this.query.toLowerCase())
        }

        , sorter: function (items) {
            var beginswith = []
                , caseSensitive = []
                , caseInsensitive = []
                , item

            while (item = items.shift()) {
                if (!item.toLowerCase().indexOf(this.query.toLowerCase())) beginswith.push(item)
                else if (~item.indexOf(this.query)) caseSensitive.push(item)
                else caseInsensitive.push(item)
            }

            return beginswith.concat(caseSensitive, caseInsensitive)
        }

        , highlighter: function (item) {
            return item.replace(new RegExp('(' + this.query + ')', 'ig'), function ($1, match) {
                return '<strong>' + match + '</strong>'
            })
        }

        , render: function (items) {
            var that = this

            items = $(items).map(function (i, item) {
                i = $(that.options.item).attr('data-value', item)
                i.find('a').html(that.highlighter(item))
                return i[0]
            })

            items.first().addClass('active')
            this.$menu.html(items)
            return this
        }

        , next: function (event) {
            var active = this.$menu.find('.active').removeClass('active')
                , next = active.next()

            if (!next.length) {
                next = $(this.$menu.find('li')[0])
            }

            next.addClass('active')
        }

        , prev: function (event) {
            var active = this.$menu.find('.active').removeClass('active')
                , prev = active.prev()

            if (!prev.length) {
                prev = this.$menu.find('li').last()
            }

            prev.addClass('active')
        }

        , listen: function () {
            var that = this;
            this.$element.focus(function(){
                that.input.focus();
            });
            this.input
                .on('blur',     $.proxy(this.blur, this))
                .on('keypress', $.proxy(this.keypress, this))
                .on('keyup',    $.proxy(this.keyup, this))

            if ($.browser.webkit || $.browser.msie) {
                this.input.on('keydown', $.proxy(this.keypress, this))
            }

            this.$menu
                .on('click', $.proxy(this.click, this))
                .on('mouseenter', 'li', $.proxy(this.mouseenter, this))

            this.$element.on('click', 'li.tag a' , $.proxy(this.deleteTag, this))
        }

        , updateWidth: function(){
            var val = $.trim(this.input.val()).length;
            this.input.width(val * 10 + 30);
        }

        , keyup: function (e) {
            e.stopPropagation()
            e.preventDefault()
            this.updateWidth();
            switch(e.keyCode) {
                case 40: // down arrow
                case 38: // up arrow
                    break

                case 9: // tab
                case 13: // enter
                    this.select()
                    break

                case 27: // escape
                    this.hide()
                    break

                default:
                    this.lookup()
            }

        }

        , keypress: function (e) {
            e.stopPropagation()
            //if (!this.shown) return

            switch(e.keyCode) {
                case 9: // tab
                case 13: // enter
                case 27: // escape
                    e.preventDefault()
                    break

                case 38: // up arrow
                    e.preventDefault()
                    this.prev()
                    break

                case 40: // down arrow
                    e.preventDefault()
                    this.next()
                    break

                case 8: //backspace
                    this.deleteLastTag();
                    break;
            }
        }

        , blur: function (e) {
            var that = this
            e.stopPropagation()
            e.preventDefault()
            setTimeout(function () { that.hide() }, 150)
        }

        , click: function (e) {
            e.stopPropagation()
            e.preventDefault()
            this.select()
        }

        , mouseenter: function (e) {
            this.$menu.find('.active').removeClass('active')
            $(e.currentTarget).addClass('active')
        }

    }


    /* TYPEAHEAD PLUGIN DEFINITION
     * =========================== */

    $.fn.tageditor = function ( option ) {
        return this.each(function () {
            var $this = $(this)
                , data = $this.data('tageditor')
                , options = typeof option == 'object' && option
            if (!data) $this.data('tageditor', (data = new Tageditor(this, options)))
            if (typeof option == 'string') data[option]()
        })
    }

    $.fn.tageditor.defaults = {
        source: []
        , items: 8
        , menu: '<ul class="tagsmenu dropdown-menu"></ul>'
        , item: '<li><a href="#"></a></li>'
        , insert: '<li class="tag" value="0"><span class="uppercase">#{0}</span><a>x</a></li>'
    }

    $.fn.tageditor.Constructor = Tageditor


    /* TYPEAHEAD DATA-API
     * ================== */

    $(function () {
        $('body').on('focus.tageditor.data-api', '[data-provide="tageditor"]', function (e) {
            var $this = $(this)
            if ($this.data('tageditor')) return
            e.preventDefault()
            $this.tageditor($this.data())
        })
    })

}( window.jQuery );
