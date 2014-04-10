// Generated by CoffeeScript 1.7.1
(function() {
  var animate, camera, clock, container, controls, init, keyboard, nodeApp, render, renderer, scene, singleAnimate, update;

  console.log("nexus.js");

  keyboard = new THREEx.KeyboardState();

  clock = new THREE.Clock();

  container = void 0;

  scene = void 0;

  camera = void 0;

  renderer = void 0;

  controls = void 0;

  init = function() {
    var ASPECT, FAR, NEAR, SCREEN_HEIGHT, SCREEN_WIDTH, VIEW_ANGLE, axisHelper, floor, floorGeometry, floorMaterial, light, skyBox, skyBoxGeometry, skyBoxMaterial;
    scene = new THREE.Scene();
    ENGINE.threeScene = scene;
    SCREEN_WIDTH = window.innerWidth;
    SCREEN_HEIGHT = window.innerHeight;
    VIEW_ANGLE = 45;
    ASPECT = SCREEN_WIDTH / SCREEN_HEIGHT;
    NEAR = 0.1;
    FAR = 20000;
    camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);
    ENGINE.threeCamera = camera;
    scene.add(camera);
    camera.position.set(0, 800, 0);
    camera.lookAt(scene.position);
    renderer = new THREE.WebGLRenderer({
      antialias: true
    });
    ENGINE.threeRenderer = renderer;
    renderer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    container = document.getElementById('ThreeJS');
    container.appendChild(renderer.domElement);
    THREEx.WindowResize(renderer, camera);
    THREEx.FullScreen.bindKey({
      charCode: 'm'.charCodeAt(0)
    });
    controls = new THREE.OrbitControls(camera, renderer.domElement);
    ENGINE.threeControls = controls;
    light = new THREE.PointLight(0xffffff);
    light.position.set(100, 250, 100);
    scene.add(light);
    floorMaterial = new THREE.MeshBasicMaterial({
      color: 0x0e0f1a,
      side: THREE.DoubleSide
    });
    floorGeometry = new THREE.PlaneGeometry(1000, 1000, 10, 10);
    floor = new THREE.Mesh(floorGeometry, floorMaterial);
    floor.position.y = -0.5;
    floor.rotation.x = Math.PI / 2;
    scene.add(floor);
    skyBoxGeometry = new THREE.CubeGeometry(10000, 10000, 10000);
    skyBoxMaterial = new THREE.MeshBasicMaterial({
      color: 0x222241,
      side: THREE.BackSide
    });
    skyBox = new THREE.Mesh(skyBoxGeometry, skyBoxMaterial);
    scene.add(skyBox);
    axisHelper = new THREE.AxisHelper(5000);
    return scene.add(axisHelper);
  };

  animate = function() {
    var delta;
    requestAnimationFrame(animate);
    render();
    update();
    delta = clock.getDelta();
    nodeApp.onstep(delta);
    return nodeApp.onrender(delta);
  };

  singleAnimate = function() {
    render();
    update();
    nodeApp.onrender();
    render();
    update();
    return nodeApp.onrender();
  };

  update = function() {};

  render = function() {
    return renderer.render(scene, camera);
  };

  nodeApp = new ENGINE.Application({
    oncreate: function() {
      init();
      this.loader.foo(500);
      return ENGINE.CameraCtrl.setup();
    },
    onready: function() {
      nodeApp.selectScene(nodeApp.game);
      return animate();
    }
  });

  nodeApp.game = new ENGINE.Scene({
    oncreate: function() {
      console.log("create");
      this.entities = new ENGINE.NexusGrid(this);
      return this.player = this.entities.playerNexon;
    },
    onstep: function(delta) {
      this.entities.step(delta);
      this.entities.call("step", delta);
      return ENGINE.CameraCtrl.step(delta);
    },
    onrender: function(delta) {
      return this.entities.call("render", delta);
    },
    onmousedown: function(event) {},
    onkeyup: function(event) {
      this.player.jumpToRandomNode();
      return ENGINE.CameraCtrl.watchEntity(this.player);
    }
  });

  window.nodeApp = nodeApp;

}).call(this);