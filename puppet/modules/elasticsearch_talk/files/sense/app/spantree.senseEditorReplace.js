// make sure all of ace is loaded first.
require(['require','ace'], function (require) { require(['app'], function() {
  // replaces the ACE editor contents with a given string
  var replaceEditorContents = function(contents) {
    var ace = require('ace');
    console.log('ace', ace);
    var session = ace.edit('editor').getSession();
    var doc = session.getDocument();
    doc.setValue(contents);
  }

  var doReplace = function() {
    // read the hash of the url
    var hash = window.location.hash;
    if(hash) {
      // if the hash exists, retrieve the corresponding `.sense` file
      // from the nginx server running on port 80
      var url = "http://" + window.location.hostname + "/" + hash.replace(/^#/, '') + ".sense";
      var req = $.get(url)

      document.title = hash.replace(/^#/, '').replace(/-/, ' ');

      // if successful, replace the ace editor contents with the response
      // body
      req.done(replaceEditorContents);
    }
  }();
})});