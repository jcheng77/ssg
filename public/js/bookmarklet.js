var BLM;
var BM;

BLM = typeof BLM === 'undefined' ? {} : BLM;
BM = BLM.BM = typeof BLM.BM === 'undefined' ? {} : BLM.BM;

BM.createPopup = function(){
  var popup = document.getElementById('blm-bm-popup');
  var popupStyle;
  var styleText;
  var rootUrl = 'http://127.0.0.1:3000';
  if(popup){ return };

  styleText = [
    'body{',
      'margin: 0;',
      'padding: 0;',
    '}',
    '.blm-bm-popup{',
      '-webkit-transition: all 1s;',
      '-ms-transition: all 1s;',
      'transition: all 1s;',
      'position: fixed;',
      'width: 100%;',
      'top: 0;',
      'background: transparent url(' + rootUrl + '/img/bm_bg.png) repeat scroll 0 0;',
      '-webkit-box-shadow:  0px 1px 3px 0px rgba(0, 0, 0, 0.75);',
      'box-shadow:  0px 1px 3px 0px rgba(0, 0, 0, 0.75);',
      'filter: progid:DXImageTransform.Microsoft.Shadow(color="#969696", Direction=180, Strength=3);',
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
      'background-color: #7BCADD;',
    '}',
    '.blm-bm-popup .blm-bm-head .second{',
      'background-color: #FFDC8B;',
    '}',
    '.blm-bm-popup .blm-bm-head .third{',
      'background-color: #FF988B;',
    '}',
    '.blm-bm-popup .blm-bm-head .fourth{',
      'background-color: #287C90;',
    '}',
    '.blm-bm-popup .blm-bm-body{',
      'padding: 20px 0;',
      'position: relative;',
    '}',
    '.blm-bm-popup .blm-bm-body-left{',
      'float: left;',
      'margin-left: 15%;',
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
      'font-weight: bold;',
    '}',
    '.blm-bm-popup .blm-bm-body-middle{',
      'width: 50%;',
      'margin: 0 auto;',
      'line-height: 45px;',
      'font-size: 20px;',
      'text-align: center;',
      'zoom: 1;',
      '*margin-left: 5px;',
    '}',
    '.blm-bm-popup .blm-bm-body-right{',
      'float: right;',
      'margin-top: -43px;',
      'margin-right: 15%;',
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
        '<div id="bm-popup-msg">Collecting</div>',
      '</div>',
      '<div class="blm-bm-body-right">',
        '<a href="#" class="login">',
          '<img src="' + rootUrl + '/img/bm_login_btn.png" />',
        '</a>',
      '</div>',
    '</div>'
  ].join('');

  document.body.insertBefore(popup, document.body.firstChild);
  document.body.insertBefore(popupStyle, document.body.firstChild);
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

BM.showPopupResult = function(status){
  var popupMsg = document.getElementById('bm-popup-msg');

  switch(status){
    case 1: // Success
      break;

    case 2: // Fail Error
      break;

    case 3: // Fail and Need Login
      popupMsg.innerHTML = 'Need Login';
      break;

  }

  // close the popup in the next 5 minutes
  BM.clear();
  BM.autoHideTimer = setTimeout(function(){
    BM.hidePopup();
  }, 3000);
};

BM.clear = function(){
  if(BM.autoHideTimer){
    clearTimeout(BM.timer);
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
}

BM.collect = function(result){
  console.log(result);
  var BM = BLM.BM;

  if(result.isSuccess){
    
  }else{
    if(result.isLogin ===  false){
      BM.showPopupResult(3);
    }
  }

  BM.isProcessing = false;
};


;(function(win){
  var doc = win.document;
  var url = win.location.href;
  var collectUrl = 'http://127.0.0.1:3000/collect.jsonp?callback=BLM.BM.collect&url=' +
      encodeURIComponent(url);
  var BM = BLM.BM;

  if(BM.isProcessing){
    return;
  }

  function loadScript(scriptUrl){
    var newScript = doc.createElement('script');
    newScript.src = scriptUrl;
    newScript.type = 'text/javascript';

    doc.head.appendChild(newScript);
  };

  BM.createPopup();
  BM.showPopup();

  loadScript(collectUrl);

  BM.isProcessing = true;

})(window);