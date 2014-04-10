// Generated by CoffeeScript 1.7.1
(function() {
  var ENGINE,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  console.log("nexus_engine.js");


  /*
  
  Here I will outline th things that i need for this to work. 
  
  Firs i
   */


  /* === Template ===
  
  
  class ENGINE.CLASS_NAME 
       * === Class Properties === #
  
       * === Class Methods === #
  
       * ==== Constructor === #
  
      constructor: (args) ->
          _.extend(@, args)
  
          if @oncreate
              @oncreate()
  
       * === Instance Properties === #
  
       * === Instance Methods === #
  
       * toString: () ->
   */

  ENGINE = {};

  window.ENGINE = ENGINE;

  ENGINE.Scene = (function() {
    function Scene(args) {
      _.extend(this, args);
      if (this.oncreate) {
        this.oncreate();
      }
    }

    Scene.prototype.onenter = function() {};

    Scene.prototype.onleave = function() {};

    Scene.prototype.onrender = function() {};

    Scene.prototype.onstep = function() {};

    return Scene;

  })();

  ENGINE.Application = (function() {
    function Application(args) {
      this.dblclick = __bind(this.dblclick, this);
      this.onmouseup = __bind(this.onmouseup, this);
      this.onmousedown = __bind(this.onmousedown, this);
      this.onkeyup = __bind(this.onkeyup, this);
      this.onkeydown = __bind(this.onkeydown, this);
      var app;
      _.extend(this, args);
      app = this;
      this.loader = new ENGINE.Loader();
      this.assets = new ENGINE.Assets(this.loader);
      if (this.oncreate) {
        this.oncreate();
      }
      this.loader.ready(function() {
        return app.onready();
      });
      this.bindEvents();
    }

    Application.prototype.scene = {};

    Application.prototype.loader = {};

    Application.prototype.assets = {};

    Application.prototype.dispatch = function(method) {
      if (this.scene && this.scene[arguments[0]]) {
        return this.scene[arguments[0]].apply(this.scene, Array.prototype.slice.call(arguments, 1));
      }
    };

    Application.prototype.selectScene = function(scene) {
      this.dispatch("onleave");
      this.scene = scene;
      return this.dispatch("onenter");
    };

    Application.prototype.onstep = function(delta) {
      return this.dispatch("onstep", delta);
    };

    Application.prototype.onrender = function(delta) {
      return this.dispatch("onrender", delta);
    };

    Application.prototype.bindEvents = function() {
      var eventName, events, fn, _i, _len, _results;
      events = ["mousedown", "mouseup", "dblclick", "keydown", "keyup"];
      console.log('bound');
      _results = [];
      for (_i = 0, _len = events.length; _i < _len; _i++) {
        eventName = events[_i];
        fn = this[eventName] ? this[eventName] : this["on" + eventName];
        _results.push(document.addEventListener(eventName, fn, false));
      }
      return _results;
    };

    Application.prototype.onkeydown = function(event) {
      return this.dispatch("onkeydown", event);
    };

    Application.prototype.onkeyup = function(event) {
      return this.dispatch("onkeyup", event);
    };

    Application.prototype.onmousedown = function(event) {
      return this.dispatch("onmousedown", event);
    };

    Application.prototype.onmouseup = function(event) {
      return this.dispatch("onmouseup", event);
    };

    Application.prototype.dblclick = function(event) {
      return this.dispatch("dblclick", event);
    };

    return Application;

  })();

  ENGINE.Entity = (function() {
    function Entity(args) {
      _.extend(this, args);
      if (this.oncreate) {
        this.oncreate();
      }
    }

    Entity.prototype.x = void 0;

    Entity.prototype.y = void 0;

    Entity.prototype.z = void 0;

    Entity.prototype.pos = void 0;

    Entity.prototype._remove = false;

    Entity.prototype.collection = void 0;

    Entity.prototype.model = void 0;

    Entity.prototype.step = function(delta) {
      return console.log("Entity step() needs to be defined");
    };

    Entity.prototype.render = function(delta) {
      return console.log("Entity render() needs to be defined");
    };

    Entity.prototype.updateModelPosition = function() {
      if (this.model != null) {
        return this.model.position.set(this.x, this.y, this.z);
      }
    };

    Entity.prototype.positionFromData = function() {
      return new THREE.Vector3(this.x, this.y, this.z);
    };

    Entity.prototype.remove = function() {
      this._remove = true;
      return this.collection.dirty = true;
    };

    return Entity;

  })();

  ENGINE.Collection = (function(_super) {
    __extends(Collection, _super);

    function Collection(parent) {
      this.parent = parent;
      this.index = 0;
      this.dirty = false;
      if (this.oncreate) {
        this.oncreate();
      }
    }

    Collection.prototype.parent = void 0;

    Collection.prototype.index = void 0;

    Collection.prototype.dirty = false;

    Collection.prototype.add = function(constructor, args) {
      var entity;
      entity = new constructor(_.extend({
        collection: this,
        index: this.index++
      }, args));
      this.push(entity);
      return entity;
    };

    Collection.prototype.clean = function() {
      var len, _results;
      len = this.length;
      _results = [];
      while (i < len) {
        if (this[i]._remove) {
          this.splice(i--, 1);
          len--;
        }
        _results.push(i++);
      }
      return _results;
    };

    Collection.prototype.step = function(delta) {
      if (this.dirty) {
        this.dirty = false;
        this.clean();
        return this.sort(function(a, b) {
          return (a.zIndex | 0) - (b.zIndex | 0);
        });
      }
    };

    Collection.prototype.call = function(method) {
      var args, i, len, _results;
      args = Array.prototype.slice.call(arguments, 1);
      i = 0;
      len = this.length;
      _results = [];
      while (i < len) {
        if (this[i][method]) {
          this[i][method].apply(this[i], args);
        }
        _results.push(i++);
      }
      return _results;
    };

    Collection.prototype.apply = function(method, args) {
      var i, len, _results;
      i = 0;
      len = this.length;
      _results = [];
      while (i < len) {
        if (this[i][method]) {
          this[i][method].apply(this[i], args);
        }
        _results.push(i++);
      }
      return _results;
    };

    return Collection;

  })(Array);

  ENGINE.Loader = (function() {
    function Loader() {
      this.total = 0;
      this.count = 0;
      this.progress = 0;
      this.callbacks = [];
      this.loading = false;
    }

    Loader.prototype.add = function() {
      this.loading = true;
      this.count++;
      return this.total++;
    };

    Loader.prototype.image = function(image) {
      var loader;
      loader = this;
      image.addEventListener("load", function() {
        return loader.onItemReady();
      });
      image.addEventListener("error", function() {
        return loader.onItemError(this.src);
      });
      return this.add();
    };

    Loader.prototype.foo = function(duration) {
      var loader;
      loader = this;
      setTimeout(function() {
        return loader.onItemReady();
      }, duration);
      return this.add();
    };

    Loader.prototype.ready = function(callback) {
      if (!this.loading) {
        return callback();
      } else {
        return this.callbacks.push(callback);
      }
    };

    Loader.prototype.onItemReady = function() {
      var callback, _i, _len, _ref;
      this.count--;
      this.progress = (this.total - this.count) / this.total;
      if (this.count <= 0) {
        this.loading = false;
        _ref = this.callbacks;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          callback = _ref[_i];
          callback();
        }
      }
      this.callbacks = [];
      return this.total = 0;
    };

    Loader.prototype.onItemError = function(source) {
      return console.log("unable to load ", source);
    };

    return Loader;

  })();

  ENGINE.Assets = (function() {
    function Assets(loader) {
      this.loader = loader;
      this.addImage = __bind(this.addImage, this);
      this.addImages = __bind(this.addImages, this);
      this.image = __bind(this.image, this);
      this.paths = {
        images: "images/"
      };
      this.data = {
        images: []
      };
    }

    Assets.prototype.paths = void 0;

    Assets.prototype.data = void 0;

    Assets.prototype.image = function(key) {
      return this.data.images[key];
    };

    Assets.prototype.addImages = function(filenames) {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = filenames.length; _i < _len; _i++) {
        filenames = filenames[_i];
        _results.push(this.addImage(filename));
      }
      return _results;
    };

    Assets.prototype.addImage = function(filename) {
      var image, key;
      image = new Image;
      this.loader.image(image);
      key = filename.match(/(.*)\..*/)[1];
      this.data.images[key] = image;
      return image.src = this.paths.images + filename;
    };

    return Assets;

  })();


  /*
  
  === ENGINE THREE.js interface ===
  - various helper fns for dealing with the stuff
  - should be used by an ENGINE.Scene for specific things
   */

  ENGINE.CameraCtrl = {
    goal: void 0,
    state: void 0,
    camera: void 0,
    AT_GOAL: 1,
    MOVING_TO_GOAL: 2,
    step: function(delta) {
      var currentPos, foo;
      if (this.state === this.AT_GOAL) {
        console.log("foo");
        return;
      }
      if (this.state === this.MOVING_TO_GOAL) {
        currentPos = this.camera.position.clone();
        currentPos.sub(this.goal).multiplyScalar(delta);
        foo = this.camera.position.clone().add(currentPos);
        this.setEntityViewPosition(foo);
        return this.watchPosition(foo);
      }
    },
    setup: function() {
      return this.camera = ENGINE.threeCamera;
    },
    setGoal: function(goal) {
      return this.goal = goal;
    },
    setState: function(state) {
      return this.state = state;
    },
    setEntityViewPosition: function(position) {
      return this.camera.position.set(position.x, 400 + position.y, 150 + position.z);
    },
    setTopDown: function() {
      var camera;
      camera = ENGINE.threeCamera;
      return camera.position.set(0, 800, 0);
    },
    watchScene: function() {
      return this.watchPosition(ENGINE.threeScene);
    },
    watchEntity: function(entity) {
      this.setGoal(entity.positionFromData());
      return this.setState(this.MOVING_TO_GOAL);
    },
    watchPosition: function(position) {
      var camera;
      camera = ENGINE.threeCamera;
      return camera.lookAt(position);
    }
  };

}).call(this);