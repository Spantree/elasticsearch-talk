var fs = require('fs');
var file = __dirname + '/Packerfile';

fs.readFile(file, 'utf8', function (err, data) {
  if (err) {
    console.log('Error: ' + err);
    return;
  }

  var config = JSON.parse(data);
  var vars = config.variables;
  console.log(vars.box_name + "-" + vars.version + "-virtualbox.box");
});
