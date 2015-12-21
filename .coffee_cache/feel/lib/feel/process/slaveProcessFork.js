
/*
 * Стартовый класс при форке потока
 */

(function() {
  var Messanger, Service, SlaveProcessFork, SlaveServiceManager, error, log,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  Service = require('../service/service');

  SlaveServiceManager = require('../service/slaveServiceManager');

  Messanger = require('./slaveProcessMessanger');

  SlaveProcessFork = (function() {
    function SlaveProcessFork() {
      this.service = bind(this.service, this);
      this.init = bind(this.init, this);
      Wrap(this);
    }

    SlaveProcessFork.prototype.init = function*() {
      var i, len, name, qs, ref;
      this.conf = JSON.parse(process.env.FORK);
      this.processId = this.conf.processId;
      this.name = this.conf.name;
      this.log();
      this.messanger = new Messanger();
      (yield this.messanger.init());
      this.messanger.send('ready');
      this.serviceManager = new SlaveServiceManager();
      (yield this.serviceManager.init());
      qs = [];
      qs.push(this.serviceManager.run());
      if (this.conf.services) {
        ref = this.conf.services;
        for (i = 0, len = ref.length; i < len; i++) {
          name = ref[i];
          qs.push(this.serviceManager.start(name));
        }
      }
      (yield Q.all(qs));
      return this.messanger.send('run');
    };

    SlaveProcessFork.prototype.service = function(name) {
      return this.serviceManager.nearest(name);
    };

    return SlaveProcessFork;

  })();

  module.exports = SlaveProcessFork;

  log = (function(_this) {
    return function(msg) {
      return console.log.apply(console, ["process:".cyan + ("" + Main.conf.name).blue + (":" + Main.conf.processId + ":" + process.pid).grey].concat(slice.call(arguments)));
    };
  })(this);

  error = (function(_this) {
    return function(msg) {
      console.log("********************************************************".red);
      console.log.apply(console, ["ERROR".red + ":process:".cyan + ("" + Main.conf.name).blue + (":" + Main.conf.processId + ":" + process.pid).grey].concat(slice.call(arguments)));
      return console.log("********************************************************".red);
    };
  })(this);

  process.on('uncaughtException', (function(_this) {
    return function(e) {
      error("uncaughtException".red, Exception(e));
      return process.exit(1);
    };
  })(this));

  process.on('exit', (function(_this) {
    return function(code) {
      return log("exit with code".yellow + (" " + code).red);
    };
  })(this));

  process.on('SIGINT', (function(_this) {
    return function() {
      log("SIGINT".red);
      return process.exit(0);
    };
  })(this));

  process.on('SIGTERM', (function(_this) {
    return function() {
      log("SIGTERM".red);
      return process.exit(0);
    };
  })(this));


  /*
  class Messenger extends EE
    constructor : ->
      @eemit  = => Messenger::emit.apply @,arguments
      @emit   = => @memit.apply @,arguments
      process.on 'message', @msg
    memit : (name,args...)=>
      process.send {
        msg   : name
        args  : args
      }
    msg : (o)=>
      return unless o.msg?
      args = o.args
      args?= []
      @eemit o.msg, args...
  class Fork
    constructor : ->
      Wrap @
    init : ->
      Lib.init()
      .then =>
        Main_class = require "../services/#{process.env.name}/main"
        @main     = new Main_class()
        @main.DB  = new (require("../db/main"))()
        @main.parent = new Messenger()
        @main.domain = require 'domain'
        Services = require '../services'
        @main.services = new Services()
        global.Main   = @main
        @domain = @main.domain.create()
        #@domain.add @main
        @main.context = @main.domain.create()
        @domain.on 'error', (err)=>
          try
            error 'main domain handle',Exception err
            @main.onerror? err
          catch e
            error '@main.onerror?(err) error from main domain handle',Exception e
          process.exit 1
      .then =>
        @domain.run =>
          Q().then  =>
            @main.DB.init()
          .then     =>
            @main.DB.connect 'feel'
          .then (db)=>
            @main.db = db
      .then =>
        @domain.run =>
          @main.init?()
      .then =>
        @domain.run =>
          @main.parent.emit 'init'
          @main.parent.emit 'restart'
      .then =>
        @domain.run =>
          @main.run?()
      .catch (e)=>
        error "end exception",Exception e
        process.exit 1
  
  module.exports = Fork
   */

}).call(this);
