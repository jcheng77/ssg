;(function($){

  var $collectInput;
  var $collectInputBtn
  var $collectInputIcon;
  var $collectDropDown;
  var $collectDropDownTrigger;
  var $collectLoading;
  var securityToken; // String
  var utf8; //String
  var collectUrl = '/collect';
  var itemTpl = [
    '<li class="item" data-data="{{data}}">',
      '<a>',
      '<img width="50" src="{{img}}" class="pic" />',
      '<div class="abstract">',
        '<div>',
          '<span class="name">{{name}}</span>',
          '<span class="price"> &yen;{{price}}</span>',
        '</div>',
        '<div><span class="cat">{{cat}}</span></div>',
      '</div>',
      '</a>',
    '</li>'
  ].join('');

  var itemLoadingTpl = [
    '<li>',
      '<div class="search-loading">',
        '<img class="loading-icon" src="/assets/loading.gif" />',
        '<span class="loading-text">正在搜索...</span>',
      '</div>',
    '</li>'
  ].join('');

  var shouldDropDownHide = true;

  var mockData;

  function isUrl(url){
    return /^http[s]?:\/\//.test(url);
  }

  function showEnterIcon(){
    $collectInputIcon.removeClass('icon-search') &&
      !$collectInputIcon.hasClass('icon-arrow-right') &&
      $collectInputIcon.addClass('icon-arrow-right');
  };

  function showSearchIcon(){
    $collectInputIcon.removeClass('icon-arrow-right') &&
      $collectInputIcon.addClass('icon-search');
  };

  function hideCollectDropDown(){
    var $parent = $collectDropDownTrigger.parent();
    $parent.removeClass('open');
  };

  function showCollectDropDown(){
    var $parent = $collectDropDownTrigger.parent();
    if(!shouldDropDownHide){
      !$parent.hasClass('open') && $parent.addClass('open');
    }
  };

  function showCollectLoading(){
    $collectLoading.show();
  };

  function hideCollectLoading(){
    $collectLoading.hide();
  };

  function showSearchLoading(){
    $collectDropDown.html(itemLoadingTpl);
    showCollectDropDown();
  };


  function showSearchResult(items){
    var itemsArr = [];
    var itemStr;
    var data;

    for(var i = 0, l = items.length, item; i < l; i++){
      item = items[i];
      data = [
        'title=' + item[0],
        'img=' + item[1],
        'url=' + item[2],
        'cat=' + item[3],
        'price=' + item[4]
      ].join(';');

      itemStr = itemTpl.replace('{{img}}', item[1])
                       .replace('{{name}}', item[0])
                       .replace('{{data}}', data)
                       .replace('{{price}}', item[4])
                       .replace('{{cat}}', item[3]);

      itemsArr.push(itemStr);
    }

    $collectDropDown.html(itemsArr.join(''));
    $collectDropDown.find('a').on('click', function(evt){
      handleItemClicked($(this));
    });

    showCollectDropDown();
  }

  function collect(url){
    var data = {
      authenticity_token: securityToken,
      utf8: utf8,
      url: url,
      format: 'js'
    };

    $.post(collectUrl, data);
  };  

  function search(keyword){
    var data = {
      authenticity_token: securityToken,
      utf8: utf8,
      url: keyword,
      format: 'json'
    };

    $.post(collectUrl, data, function(data){
      showSearchResult(data);
    });
  };

  function showItem(item){
    var url = item.url;
    collect(url);
  };

  function handleItemClicked($item){
    var data = $item.parent().attr('data-data');
    var itemObj = {};

    $.each(data.split(';'), function(i, d){
      var pair = d.split('=');
      itemObj[pair[0]] = pair[1];
    });
    
    showItem(itemObj);
  }

  function init(){
    $collectInput = $('#collectInput');
    $collectInputBtn = $('#collectInputBtn');
    $collectInputIcon = $('#collect-input-icon');
    $collectDropDown = $('#collect-search-result');
    $collectDropDownTrigger = $('#dropDownTrigger');
    $collectLoading = $('.loading-mask');
    securityToken = $('#collect_item_form input[name=authenticity_token]').val();
    utf8 = $('#collect_item_form input[name=utf8]').val();
  }

  function bindEvents(){
    var contentCache = '';

    $collectInput.keyup(function(evt){
      setTimeout(function(){
        var content = $collectInput.val();

        if(content.length === 0){
          showEnterIcon();
          shouldDropDownHide = true;
          hideCollectDropDown();
          return;
        }

        shouldDropDownHide = false;

        // Enter
        if(evt.which === 13){
          if(isUrl(content)){
            collect(content);
            showCollectLoading();
          }
        }else{
          if(isUrl(content)){
            showEnterIcon();
          }else if(content !== contentCache && !shouldDropDownHide){
            showSearchIcon();
            search(content);
            showSearchLoading();
          }
        }

        contentCache = content;
      },400);
    });

    $collectInputBtn.click(function(evt){
      var content = $collectInput.val();
      
      if(isUrl(content)){
        collect(content);
        showCollectLoading();
      }
    });

    $collectDropDownTrigger.dropdown();

    $('#bookmarklet_container #collect-item').click(function () {
      if ($('#item_category').find("option:selected").text() == '请选择') {
        alert('请选择商品分类');
        return false;
      };
      if ($('#desc').val().length == 0) {
        alert('请输入收藏评论');
        return false;
      }
    });
  }

  $(document).ready(function () {
    init();
    bindEvents();
  });

})($);
