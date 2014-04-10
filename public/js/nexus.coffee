console.log("nexus.js")



# // standard global variables
keyboard = new THREEx.KeyboardState();
clock = new THREE.Clock();
container = undefined
scene = undefined
camera = undefined
renderer = undefined
controls = undefined


# // custom global variables


init = () -> 
    # // SCENE
    scene = new THREE.Scene();
    ENGINE.threeScene = scene;
    # // CAMERA
    SCREEN_WIDTH = window.innerWidth
    SCREEN_HEIGHT = window.innerHeight;
    VIEW_ANGLE = 45
    ASPECT = SCREEN_WIDTH / SCREEN_HEIGHT
    NEAR = 0.1
    FAR = 20000
    camera = new THREE.PerspectiveCamera( VIEW_ANGLE, ASPECT, NEAR, FAR);
    ENGINE.threeCamera = camera
    scene.add(camera);
    camera.position.set(0,800,0);
    # camera.position.set(0,150,400);

    camera.lookAt(scene.position);  
    renderer = new THREE.WebGLRenderer( {antialias:true} );
    ENGINE.threeRenderer = renderer
    renderer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    container = document.getElementById( 'ThreeJS' );
    container.appendChild( renderer.domElement );
    # // EVENTS
    THREEx.WindowResize(renderer, camera);
    THREEx.FullScreen.bindKey({ charCode : 'm'.charCodeAt(0) });
    # // CONTROLS
    controls = new THREE.OrbitControls( camera, renderer.domElement );
    ENGINE.threeControls = controls
    # // LIGHT
    light = new THREE.PointLight(0xffffff);
    light.position.set(100,250,100);
    scene.add(light);
    # // FLOOR
    # floorTexture = new THREE.ImageUtils.loadTexture( 'images/blank.png' );
    # floorTexture = new THREE.ImageUtils.loadTexture( 'images/checkerboard.jpg' );
    # floorTexture.wrapS = floorTexture.wrapT = THREE.RepeatWrapping; 
    # floorTexture.repeat.set( 10, 10 );
    floorMaterial = new THREE.MeshBasicMaterial( { color: 0x0e0f1a, side: THREE.DoubleSide } );
    # floorMaterial = new THREE.MeshBasicMaterial( { map: floorTexture, side: THREE.DoubleSide } );
    floorGeometry = new THREE.PlaneGeometry(1000, 1000, 10, 10);
    floor = new THREE.Mesh(floorGeometry, floorMaterial);
    floor.position.y = -0.5;
    floor.rotation.x = Math.PI / 2;
    scene.add(floor);
    # // SKYBOX
    skyBoxGeometry = new THREE.CubeGeometry( 10000, 10000, 10000 );
    skyBoxMaterial = new THREE.MeshBasicMaterial( { color: 0x222241, side: THREE.BackSide } );
    # skyBoxMaterial = new THREE.MeshBasicMaterial( { color: 0x9999ff, side: THREE.BackSide } );
    skyBox = new THREE.Mesh( skyBoxGeometry, skyBoxMaterial );
    scene.add(skyBox);
    
    # ////////////
    # // CUSTOM //
    # ////////////

    axisHelper = new THREE.AxisHelper( 5000 );
    scene.add( axisHelper );
    
    # geometry = new THREE.SphereGeometry( 30, 32, 16 );
    # material = new THREE.MeshLambertMaterial( { color: 0x000088 } );
    # mesh = new THREE.Mesh( geometry, material );
    # mesh.position.set(0,0,0);
    # scene.add(mesh);
    

animate = () ->
    requestAnimationFrame( animate );
    render();       
    update();
    delta = clock.getDelta();

    nodeApp.onstep(delta)
    nodeApp.onrender(delta)

singleAnimate = ->
    render()
    update()
    nodeApp.onrender()
    render()
    update()
    nodeApp.onrender()

update = () ->
    # controls.update();

render = () ->
    renderer.render( scene, camera );


# main

nodeApp = new ENGINE.Application({
    oncreate: ->
        init();
        @loader.foo(500);
        ENGINE.CameraCtrl.setup();
    onready: -> 
        # console.log("ready")
        nodeApp.selectScene(nodeApp.game)
        animate()
        # singleAnimate()
    })

nodeApp.game = new ENGINE.Scene({
    oncreate: ->
        console.log("create")
        @entities = new ENGINE.NexusGrid(@)
        @player = @entities.playerNexon
    onstep: (delta) ->
        # console.log("step")
        @entities.step(delta)
        @entities.call("step", delta)
        ENGINE.CameraCtrl.step(delta)

    onrender: (delta) ->
        @entities.call("render", delta)

    onmousedown: (event) ->
        # console.log("Scene mousedown")
        # @player.jumpToRandomNode()
        # ENGINE.CameraCtrl.watchEntity(@player)

    onkeyup: (event) ->
        @player.jumpToRandomNode()
        ENGINE.CameraCtrl.watchEntity(@player)
    })


window.nodeApp = nodeApp






