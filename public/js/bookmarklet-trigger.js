(function(win){
  var d = win.document;
  var s = d.createElement('script');
  var u = 'http://127.0.0.1:3000/js/bookmarklet.js?t=' + new Date().getTime();
  s.type = 'text/javascript';
  s.src = u + '?t=' + new Date().getTime();
  d.head.appendChild(s);
})(window);