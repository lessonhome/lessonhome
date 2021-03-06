
module.exports.make = function (cb){
  var sp = (function(cmd,arg,cb){
    var spawn = require('child_process').spawn,
        npm  = spawn(cmd, arg);
    npm.stdout.pipe(process.stdout);
    npm.stderr.pipe(process.stderr);
    npm.on('close', cb);
  });

  var fs = require ('fs');
  var sha1 = require('crypto').createHash('sha1');  
  var hash="",sum,fsave = "feel/.npmversion",fpac = "package.json";
  if (fs.existsSync(fsave))
    hash = fs.readFileSync(fsave).toString();
  sha1.update(fs.readFileSync(fpac));
  sum = sha1.digest('hex');
  if (sum == hash)return cb();
  console.log('npm i');
  sp('npm',['i'], function(){
    //console.log('npm update');
    //sp('npm',['update'],function(){
      fs.writeFileSync(fsave,sum);
      cb();
    //});
  });
}



