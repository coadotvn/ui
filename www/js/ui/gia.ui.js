(function() {
  if (typeof FastClick === 'function') {
    FastClick.attach(document.body);
  }

  if (typeof Rainbow === 'object') {
    Rainbow.onHighlight(function(block, language) {
      return $(block).show();
    });
  }

}).call(this);
