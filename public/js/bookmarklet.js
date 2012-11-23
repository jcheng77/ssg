var BLM;
var BM;

BLM = typeof BLM === 'undefined' ? {} : BLM;
BM = typeof BLM.BM === 'undefined' ? {} : BLM.BM;

BM.createCallout = function(){
  var calloutTpl = [
    '<style type="text/css">',
    '</style>',
    '<div class="blm-callout">',
    '</div>'
  ]
};

BM.showCallout = function(msg){
  var callout = document.getElementById('blm-callout');
  if(callout)
};

BM.collect = function(item){

  if(item === null){
    return;
  }

};


;(function(win){
  var doc = win.document;
  var url = win.location.href;
  var collectUrl = 'http://127.0.0.1:3000/collect?callback=BLM.BM.collect&url=' +
      encodeURIComponent(url);

  function loadScript(scriptUrl){
    var newScript = doc.createElement('script');
    newScript.src = scriptUrl;
    newScript.type = 'text/javascript';

    doc.head.appendChild(newScript);
  };

  loadScript(collectUrl);

})(window);