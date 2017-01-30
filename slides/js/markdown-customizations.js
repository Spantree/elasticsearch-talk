/* jslint browser: true, asi: true, semi: false */
(function() {
  'use strict';

  var customizeMarkdown = function (marked) {
    var md = marked.Renderer.prototype;

    md.image = function (href, title, text) {
      var split = href.split('#');
      var classes = split[1] ? split[1].replace(/[\s,]/, ' ') : '';
      var strippedHref = split[0];
      var out = '<img src="' + strippedHref + '" alt="' + text + '"';
      if (title) {
        out += ' title="' + title + '"';
      }
      if (classes) {
        out += ' class="' + classes + '"';
      }
      out += this.options.xhtml ? '/>' : '>';
      return out;
    };

    md.link = function(href, title, text) {
      var activeProtocol = '';
      if(window.mdProtocols) {
        for(var protocol in window.mdProtocols) {
          if(href.startsWith(protocol)) {
            activeProtocol = protocol;
            href = href.replace(protocol, window.mdProtocols[protocol]);
            break;
          }
        }
      }
      var out = '<a href="' + href + '"';
      if (title) {
        out += ' title="' + title + '"';
      }
      var target = activeProtocol || 'blank';
      out += ' target="_' + target + '"';
      out += '>' + text + '</a>';
      return out;
    }
  };

  customizeMarkdown(window.marked);
}());
