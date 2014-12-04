// Modified version of
// https://gist.github.com/irae/1042167

// Prevents links from being opened in mobile safari from web app

(function(document,navigator,standalone) {
  // prevents links from apps from oppening in mobile safari
  // this javascript must be the first script in your <head>
  if ((standalone in navigator) && navigator[standalone]) {
    var curnode, location=document.location, stop=/^(a|html)$/i;
    document.addEventListener('click', function(e) {
      curnode=e.target;
      while (!(stop).test(curnode.nodeName)) {
        curnode=curnode.parentNode;
      }
      // Condidions to do this only on links to your own app
      // if you want all links, use if('href' in curnode) instead.
      if(
        'href' in curnode && // is a link
        (chref=curnode.href).replace(location.href,'').indexOf('#')
      ) {
        e.preventDefault();
        location.href = curnode.href;
      }
    },false);
  }
})(document,window.navigator,'standalone');
