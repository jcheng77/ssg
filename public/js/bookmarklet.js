var BLM;
var BM;

BLM = typeof BLM === 'undefined' ? {} : BLM;
BM = BLM.BM = typeof BLM.BM === 'undefined' ? {} : BLM.BM;

BM.otherData = {};
BM.rootUrl = 'http://boluo.me'

BM.init = function(){
  var other = document.getElementById('blm-bm-action-other');
  var login = document.getElementById('blm-bm-action-login');
  var msg = document.getElementById('bm-popup-msg');

  BM.otherData = {
    isShare: true
  };
  BM.shareId = null;

  other && (other.className = 'blm-bm-action-other hide');
  login && (login.className = 'hide');
  msg && (msg.innerHTML = '\u6b63\u5728\u6536\u85cf\u2026\u2026');
}

BM.createPopup = function(){
  var popup = document.getElementById('blm-bm-popup');
  var popupStyle;
  var styleText;
  var rootUrl = BM.rootUrl;

  var blmPrivate;
  var blmShare;
  var blmSubmit;
  var blmComment;

  if(popup){ return };

  styleText = [
    'body{',
      'margin: 0 !important;',
      'padding: 0 !important;',
      'width: 100% !important;',
    '}',
    '.blm-bm-popup .hide{',
      'display: none;',
    '}',
    '.blm-bm-popup{',
      '-webkit-transition: all 1s;',
      '-ms-transition: all 1s;',
      'transition: all 1s;',
      'position: fixed;',
      'width: 100%;',
      'top: 0;',
      'background: #FFFFFF;',
      'zoom: 1;',
      'color: #000;',
      'z-index: 999999',
    '}',
    '.blm-bm-popup img{',
      'border: 0;',
    '}',
    '.blm-bm-popup-hide{',
      'top: -130px;',
    '}',
    '.blm-bm-popup .blm-bm-head{',
      'height: 5px;',
      'overflow: hidden;',
    '}',
    '.blm-bm-popup .blm-bm-head .head-section{',
      'width: 25%;',
      'height: 100%;',
      'float: left;',
    '}',
    '.blm-bm-popup .blm-bm-head .first{',
      'background-color: #F2F2F2;',
    '}',
    '.blm-bm-popup .blm-bm-head .second{',
      'background-color: #F66;',
    '}',
    '.blm-bm-popup .blm-bm-head .third{',
      'background-color: yellow;',
    '}',
    '.blm-bm-popup .blm-bm-head .fourth{',
      'background-color: #65B8FD;',
    '}',
    '.blm-bm-popup .blm-bm-body{',
      'padding: 20px 0;',
      'position: relative;',
    '}',
    '.blm-bm-popup .blm-bm-body-left{',
      'float: left;',
      'margin-left: 5%;',
    '}',
    '.blm-bm-popup .blm-logo .blm-logo-img{',
      'width: 45px;',
      'float: left;',
    '}',
    '.blm-bm-popup .blm-logo .blm-logo-text{',
      'line-height: 45px;',
      'vertical-align: middle;',
      'font-size: 20px;',
      'padding-left:5px;',
      'color: #65B8FD;',
    '}',
    '.blm-bm-popup .blm-bm-body-middle{',
      'width: 35%;',
      'margin: 0 auto;',
      'line-height: 45px;',
      'font-size: 20px;',
      'zoom: 1;',
      '*margin-left: 5px;',
      '*text-align: center;',
    '}',
    '.blm-bm-popup .blm-bm-body-right{',
      'float: right;',
      'margin-top: -43px;',
      'margin-right: 5%;',
      'width: 300px',
    '}',
    '.blm-bm-popup .blm-bm-action-other label{',
      'font-size: 16px;',
    '}',
    '.blm-bm-popup .blm-bm-action-other span{',
      'float: left;',
      'margin-top: 5px;',
    '}',
    '.blm-bm-popup .blm-bm-comment{',
      'position: relative;',
    '}',
    '.blm-bm-popup .blm-bm-comment label{',
      'position: absolute;',
      'left: -320px;',
      'width: 70px;',
      'line-height: 33px',
    '}',
    '.blm-bm-popup .blm-bm-comment img{',
      'height: 33px;',
      'position: absolute;',
      'top: 0px;',
      'left: -250px;',
    '}',
    '.blm-bm-popup .blm-bm-comment input{',
      'position: absolute;',
      'width: 218px;',
      'left: -243px;',
      'top: 6px;',
      'font-size: 11px',
    '}',
    '.blm-bm-popup .blm-bm-social label{',
      'margin-left: 4px;',
    '}',
    '.blm-bm-popup .blm-bm-social img{',
      'width: 18px;',
      'vertical-align: middle;',
      'margin-left: 8px;',
    '}',
    '.blm-bm-popup .blm-bm-submit-wrapper img{',
      'height: 30px;',
      'float: right;',
      'margin-top: 5px;',
      'margin-bottom: 10px;',
      'cursor: pointer;',
    '}'
  ].join('');

  popupStyle = document.createElement('style');
  popupStyle.type = 'text/css';
  if(popupStyle.styleSheet){
    popupStyle.styleSheet.cssText = styleText;
  }else{
    popupStyle.innerHTML = styleText;
  }

  popup = document.createElement('div');
  popup.id = 'blm-bm-popup';
  popup.className = 'blm-bm-popup blm-bm-popup-hide';
  popup.innerHTML = [
    '<div class="blm-bm-head">',
      '<div class="first head-section"></div>',
      '<div class="second head-section"></div>',
      '<div class="third head-section"></div>',
      '<div class="fourth head-section"></div>',
    '</div>',
    '<div class="blm-bm-body">',
      '<div class="blm-bm-body-left">',
        '<div class="blm-logo">',
          '<img class="blm-logo-img" src="' + rootUrl + '/img/bm_logo.jpg">',
          '<span class="blm-logo-text">\u83e0\u841d\u871c</span>',
        '</div>',
      '</div>',
      '<div class="blm-bm-body-middle">',
        '<div id="bm-popup-msg">\u6b63\u5728\u6536\u85cf\u2026\u2026</div>',
      '</div>',
      '<div class="blm-bm-body-right">',
        '<div id="blm-bm-action-login" class="hide">',
          '<a href="' + rootUrl + '" class="login" target="_blank">',
            '<img src="' + rootUrl + '/img/bm_login_btn.png" />',
          '</a>',
        '</div>',
        '<div id="blm-bm-action-other" class="blm-bm-action-other hide">',
          '<span class="blm-bm-comment">',
            '<label>\u8bf4\u4e24\u53e5\uff1a</label>',
            '<input type="text" id="blm-bm-comment" />',
          '</span>',
          '<span class="blm-bm-social">',
            '<img id="blm-bm-private" src="' + rootUrl + '/img/checkbox.jpg" />',
            '<label>\u79c1\u85cf</label>',
            '<img id="blm-bm-share" src="' + rootUrl + '/img/checkbox.png" />',
            '<label>\u5206\u4eab\u5230\u5fae\u535a</label>',
          '</span>',
          '<div class="blm-bm-submit-wrapper">',
            '<img id="blm-bm-submit" src="' + rootUrl + '/img/done.png" />',
          '</div>',
        '</div>',
      '</div>',
    '</div>'
  ].join('');

  document.body.insertBefore(popup, document.body.firstChild);
  document.body.insertBefore(popupStyle, document.body.firstChild);

  //bind events
  blmPrivate = document.getElementById('blm-bm-private');
  blmShare = document.getElementById('blm-bm-share');
  blmSubmit = document.getElementById('blm-bm-submit');
  blmComment = document.getElementById('blm-bm-comment');

  blmComment.onfocus = function(){
    BM.clear();
  };

  blmComment.onblur = function(){
    BM.autoHideTimer = setTimeout(function(){
      BM.hidePopup();
    }, 5000);
  };

  blmPrivate.onclick = function(){
    BM.clear();
    if(!BM.otherData.isPublic){
      blmPrivate.src = rootUrl + '/img/checkbox.jpg';
    }else{
      blmPrivate.src = rootUrl + '/img/checkbox_checked.png';
    }

    BM.otherData.isPublic = !BM.otherData.isPublic;
  }

  blmShare.onclick = function(){
    BM.clear();
    if(BM.otherData.isShare){
      blmShare.src = rootUrl + '/img/checkbox.jpg';
    }else{
      blmShare.src = rootUrl + '/img/checkbox_checked.png';
    }

    BM.otherData.isShare = !BM.otherData.isShare; 
  };

  blmSubmit.onclick = function(){
    BM.clear();

    BM.otherData.comment = blmComment.value;
    BM.submitComment();
  }
};

BM.submitComment = function(){
  var commitUrl = BM.rootUrl;
  var blmComment = document.getElementById('blm-bm-comment');
  var blmMsg = document.getElementById('bm-popup-msg');

  if(BM.isSendingOtherData){
    return;
  }

  if(!BM.shareId){
    return;
  }

  commitUrl = commitUrl + '/shares/' + BM.shareId + '/update_attr.jsonp?' + 
    'callback=BLM.BM.handleCommentResult&comment=' + 
    encodeURIComponent(blmComment.value) + '&is_public=' + BM.otherData.isPublic +
    '&to_weibo=' + BM.otherData.isShare;

  BM.loadScript(commitUrl);
  BM.isSendingOtherData = true;
  blmMsg.innerHTML = '\u6b63\u5728\u63d0\u4ea4\u2026\u2026';

}

BM.handleCommentResult = function(data){
  var blmMsg = document.getElementById('bm-popup-msg');

  BM.isSendingOtherData = false;

  if(data.isSuccess){
    blmMsg.innerHTML = '\u63d0\u4ea4\u6210\u529f';
  }else{
    blmMsg.innerHTML = '\u63d0\u4ea4\u5931\u8d25';
  }

  BM.clear();
  BM.autoHideTimer = setTimeout(function(){
    BM.hidePopup();
  }, 3000);
};

BM.showPopup = function(msg){
  var isIE = window.navigator.appName === 'Microsoft Internet Explorer';
  var bmPopup = document.getElementById('blm-bm-popup');

  var timer;
  if(!isIE){
    setTimeout(function(){
      bmPopup.className = 'blm-bm-popup';
    },100);
    return;
  }

  bmPopup.style.top = '-130px';
  if(timer){ clearInterval(timer); }
  timer = setInterval(function(){
    var bmTop = bmPopup.style.top;
    bmTop = parseInt(bmTop.substring(0, bmTop.length-2));
    if(bmTop >= -20){
      bmPopup.style.top = '0px';
      clearInterval(timer);
      return;
    }

    bmPopup.style.top = (bmTop + 20) + 'px';
  }, 100);
};

BM.showPopupResult = function(status, data){
  var popupMsg = document.getElementById('bm-popup-msg');
  var other = document.getElementById('blm-bm-action-other');
  var login = document.getElementById('blm-bm-action-login');
  var TIMEOUT = 3000;

  switch(status){
    case 1: // Success
      popupMsg.innerHTML = '\u6536\u85cf\u6210\u529f';
      other.className = 'blm-bm-action-other';
      login.className = 'hide';
      TIMEOUT = 8000;
      BM.shareId = data.shareId;
      break;

    case 2: // Fail Error
      popupMsg.innerHTML = '\u6536\u85cf\u5546\u54c1\u51fa\u9519\u4e86\uff01';
      other.className = 'blm-bm-action-other hide';
      login.className = 'hide';
      break;

    case 3: // Fail and Need Login
      popupMsg.innerHTML = '\u60a8\u8fd8\u672a\u767b\u5f55';
      other.className = 'blm-bm-action-other hide';
      login.className = '';
      // close the popup in the next 5 minutes
      BM.clear();
      BM.autoHideTimer = setTimeout(function(){
        BM.hidePopup();
      }, 3000);
      break;
  }

  BM.clear();
  BM.autoHideTimer = setTimeout(function(){
    BM.hidePopup();
  }, TIMEOUT);

};

BM.clear = function(){
  if(BM.autoHideTimer){
    clearTimeout(BM.autoHideTimer);
  }
}

BM.hidePopup = function(){
  var timer;
  var bmPopup = document.getElementById('blm-bm-popup');
  var isIE = window.navigator.appName === 'Microsoft Internet Explorer';

  if(!isIE){
    setTimeout(function(){
      bmPopup.className = 'blm-bm-popup blm-bm-popup-hide';
    }, 100);
    BM.isProcessing = false;
    return;
  }

  if(timer){ clearInterval(timer); }
  setInterval(function(){
    var bmTop = bmPopup.style.top;
    bmTop = parseInt(bmTop.substring(0, bmTop.length-2));

    if(bmTop < -110){
      bmPopup.style.top = '-130px';
      clearInterval(timer);
      return;
    }

    bmPopup.style.top = (bmTop - 20) + 'px';

  }, 100);

  BM.isProcessing = false;
}

BM.collect = function(result){
  var BM = BLM.BM;

  if(result.isSuccess){
    BM.showPopupResult(1, {shareId: result.shareId});
  }else{
    if(result.isLogin ===  false){
      BM.showPopupResult(3);
    }else{
      BM.showPopupResult(2);
    }
  }
};

BM.loadScript = function(scriptUrl){
  var doc = document;
  var newScript = doc.createElement('script');
  newScript.src = scriptUrl;
  newScript.type = 'text/javascript';

  doc.head.appendChild(newScript);
}

;(function(win){
  var doc = win.document;
  var url = win.location.href;
  var BM = BLM.BM;
  var collectUrl = BM.rootUrl + '/collect.jsonp?callback=BLM.BM.collect&url=' +
      encodeURIComponent(url);


  if(BM.isProcessing){
    return;
  }


  BM.init();
  BM.createPopup();
  BM.showPopup();

  BM.loadScript(collectUrl);

  BM.isProcessing = true;

})(window);
