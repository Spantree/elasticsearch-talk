// make sure all of ace is loaded first.
require(['require','ace'], function (require) { require(['app'], function() {
  RegExp.quote = function(str) {
      return (str+'').replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1");
  };

  var getEditor = function() {
    var ace = require('ace');
    return ace.edit('editor');
  }

  // replaces the ACE editor contents with a given string
  var replaceEditorContents = function(contents) {
    var editor = getEditor();
    var session = editor.getSession();
    var doc = session.getDocument();
    doc.setValue(contents);
    gotoLineNumber();
  }

  var gotoLineNumber = function() {
    var editor = getEditor();
    var lineNumber = window.location.hash.split(',L')[1];
    var sectionNumber = window.location.hash.split(',S')[1];
    if(sectionNumber) {
      var regex = new RegExp("^[#\\s]+" + RegExp.quote(sectionNumber + ":"));
      var lines = editor.getSession().getDocument().$lines;
      for(var i = 0; i<lines.length; i++) {
        var line = lines[i];
        if(regex.test(line)) {
          lineNumber = i+1;
          break;
        }
      }
    }
    if(lineNumber) {
      var lineInt = parseInt(lineNumber);
      editor.gotoLine(lineInt);
      editor.scrollToLine(Math.max(lineInt-1, 1), false, true);
    }
  }

  window.onhashchange = gotoLineNumber

  var doReplace = function() {
    // read the hash of the url
    var hash = window.location.hash;
    if(hash) {
      var senseName = hash.replace(/^#/, '').split(',L')[0].split(',S')[0];
      // if the hash exists, retrieve the corresponding `.sense` file
      // from the nginx server running on port 80
      var url = "http://" + window.location.hostname + "/" + senseName + ".sense";
      var req = $.get(url);

      document.title = senseName.replace(/-/, ' ');

      // if successful, replace the ace editor contents with the response
      // body
      req.done(replaceEditorContents);
    }
  }();
})});