// make sure all of ace is loaded first.
require(['require','ace'], function (require) { require(['app'], function() {
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
    if(lineNumber) {
      var lineInt = parseInt(lineNumber)
      editor.gotoLine(lineInt);
      editor.scrollToLine(Math.max(lineInt-1, 1), false, true);
    }
  }

  window.onhashchange = gotoLineNumber

  var doReplace = function() {
    // read the hash of the url
    var hash = window.location.hash;
    if(hash) {
      var senseName = hash.replace(/^#/, '').split(',L')[0];
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