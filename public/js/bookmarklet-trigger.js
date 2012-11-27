(function(win){
  var doc = win.document;

  var bookmarkletScriptUrl = 'http://127.0.0.1:3000/js/bookmarklet.js?t=' + new Date().getTime();
  var newScript = document.createElement('script');
  newScript.type = 'text/javascript';
  newScript.src = bookmarkletScriptUrl + '?t=' + new Date().getTime();

  doc.head.appendChild(newScript);
})(window);