# console.log("nexus_engine.js")


###

Here I will outline th things that i need for this to work. 

Firs i

###

### === Template ===


class ENGINE.CLASS_NAME 
    # === Class Properties === #

    # === Class Methods === #

    # ==== Constructor === #

    constructor: (args) ->
        _.extend(@, args)

        if @oncreate
            @oncreate()

    # === Instance Properties === #

    # === Instance Methods === #

    # toString: () ->

###


ENGINE = {}
window.ENGINE = ENGINE;


class ENGINE.Scene 
    # === Class methods === #

    # ==== Constructor === #

    constructor: (args) ->
        _.extend(@, args)

        if @oncreate
            @oncreate()

    # === Instance Methods === #

    onenter: ->
    onleave: ->
    onrender: ->
    onstep: ->


class ENGINE.Application 
    # === Class Properties === #

    # === Class methods === #

    # ==== Constructor === #

    constructor: (args) ->
        #todo get language full startup 
        _.extend(@, args)
        app = @;
        @loader = new ENGINE.Loader();
        @assets = new ENGINE.Assets(@loader);

        if this.oncreate
            this.oncreate()

        @loader.ready( ->
            app.onready();
            )

        @bindEvents()

    # === Instance Properties === #

    scene: {} #threejs scene
    loader: {}
    assets: {} #defined in constructor

    # === Instance Methods === #


    dispatch: (method) ->
        if @scene and @scene[arguments[0]]
            # console.log("bar")
            @scene[arguments[0]].apply @scene, Array::slice.call(arguments, 1)  

    selectScene: (scene) ->
        @dispatch("onleave")
        @scene = scene
        @dispatch("onenter")

    onstep: (delta) ->
        # console.log("dispatching with delta: #{delta}")
        @dispatch("onstep", delta)

    onrender: (delta) ->
        @dispatch("onrender", delta)

    bindEvents: () ->
        events = ["mousedown", "mouseup", "dblclick", "keydown", "keyup"]
        # console.log('bound')
        for eventName in events
            fn = if @[eventName] then @[eventName] else @["on" + eventName]
            document.addEventListener(eventName, fn, false)

    onkeydown:(event) => 
        # console.log("onkeydown")
        @dispatch("onkeydown", event)

    onkeyup:(event) => 
        # console.log("onkeyup")
        @dispatch("onkeyup", event)

    onmousedown:(event) =>
        # console.log("onmousedown")
        @dispatch("onmousedown", event)

    onmouseup:(event) =>
        # console.log("mouseup")
        @dispatch("onmouseup", event)

    dblclick:(event) =>
        # console.log("dblclick")
        @dispatch("dblclick", event)



    # todo rest of events



class ENGINE.Entity 
    # === Class Properties === #

    # === Class Methods === #

    # ==== Constructor === #

    constructor: (args) ->
        _.extend(@, args)

        if @oncreate
            @oncreate()

    # === Instance Properties === #
    x: undefined
    y: undefined
    z: undefined
    pos: undefined #position as a node or position as something else
    _remove: false # if it should be removed by a collection
    collection: undefined # what collection it belongs to, added later
    model: undefined # the scene model

    # === Instance Methods === #

    # -- Step --
    # updates the inner data in a meaningful way
    step: (delta) ->
        console.log("Entity step() needs to be defined");

    # -- Render --
    # updates the scene and all the scene related variables
    render: (delta) ->
        console.log("Entity render() needs to be defined");

    updateModelPosition: () ->
        if @model?
            @model.position.set(@x,@y,@z)

    # returns a THREE.Vector3 based on the obj data
    positionFromData: () ->
        return new THREE.Vector3(@x, @y, @z)

    remove: ->
        this._remove = true;
        this.collection.dirty = true;


# Collections are arrays with some extra entity management
class ENGINE.Collection  extends Array
    # === Class Properties === #

    # === Class Methods === #

    # ==== Constructor === #

    constructor: (@parent) ->
        @index = 0
        @dirty = false;

        if this.oncreate
            this.oncreate()

    # === Instance Properties === #

    parent: undefined # something that manages the collection, a scene or something
    index: undefined
    dirty: false

    # === Instance Methods === #

    # Add an entity with the given args
    add: (constructor, args) ->
        entity = new constructor(_.extend({
            collection: @,
            index: this.index++
            }, args))
        @push(entity)
        return entity;

    clean: ->
        len = @length
        while i < len
          if this[i]._remove
            @splice i--, 1
            len--
          i++

    step: (delta) ->
        if (@dirty)
            @dirty = false
            @clean();
            @.sort( (a,b) ->
                return (a.zIndex | 0) - (b.zIndex | 0)
                )

    # call methods on all entities without args
    call: (method) ->
        args = Array.prototype.slice.call(arguments, 1);
        i = 0
        len = @length

        while i < len
          this[i][method].apply this[i], args  if this[i][method]
          i++

    apply: (method, args) ->
        i = 0
        len = @length

        while i < len
          this[i][method].apply this[i], args  if this[i][method]
          i++



#todo Loader and onwardsw
class ENGINE.Loader

    # === Class Properties === #

    # === Class Methods === #

    # ==== Constructor === #

    constructor: () ->
        @total = 0
        @count = 0
        @progress = 0
        @callbacks = []
        @loading = false

        # @ready()

    # === Instance Properties === #

    # === Instance Methods === #

    add: ->
        @loading = true;
        @count++
        @total++

    image: (image) ->
        loader = @

        image.addEventListener("load", ->
            loader.onItemReady();
            )

        image.addEventListener("error", ->
            loader.onItemError(@.src)
            )

        @add()

    foo: (duration) ->
        loader = @
        setTimeout( -> 
            loader.onItemReady()
        , duration)
        @add()

    ready: (callback) ->
        if (!@loading)
            callback();
        else 
            this.callbacks.push(callback)

    onItemReady: ->
        @count--
        @progress = (@total - @count) / @total;
        if (@count <= 0)
            @loading = false
            for callback in @callbacks
                callback()

        @callbacks = []
        @total = 0

    onItemError: (source) ->
        console.log("unable to load ", source)



    # toString: () ->

class ENGINE.Assets
    # === Class Properties === #

    # === Class Methods === #

    # ==== Constructor === #

    constructor: (@loader) ->
        @paths = {
            images: "images/"
        }

        @data = {
            images: []
        }

    # === Instance Properties === #

    paths: undefined #lookups
    data: undefined #actual images

    # === Instance Methods === #

    image: (key) =>
        return this.data.images[key];

    addImages: (filenames) =>
        for filenames in filenames
            @addImage(filename)

    addImage: (filename) =>
        image = new Image
        @loader.image(image)
        key = filename.match(/(.*)\..*/)[1];
        @data.images[key] = image
        image.src = @paths.images + filename;

    # toString: () ->



###

=== ENGINE THREE.js interface ===
- various helper fns for dealing with the stuff
- should be used by an ENGINE.Scene for specific things

###

# ==== ENGINE.threeScene  ==== #
# - the three.js scene object

# ENGINE.threeScene.add(mesh)

# ==== ENGINE.threeCamera  ==== #
# - the three.js camera object



ENGINE.CameraCtrl = {

    goal: undefined # THREE.Vector3 position - where its going
    prevGoal: undefined # previous vector goal

    state: undefined #what its doing
    camera: undefined

    AT_GOAL: 1
    MOVING_TO_GOAL: 2

    step: (delta) ->
        if @state is @AT_GOAL
            # hover a bit or something 
            console.log("foo")
            return
        if @state is @MOVING_TO_GOAL
            # console.log("bar"`)

            currentPos = @getEntityViewPosition()
            
            foo = currentPos.add(@goal.clone().sub(currentPos).multiplyScalar(delta))

            
            @setEntityViewPosition( foo)
            @watchPosition(foo)

            # @setEntityViewPosition( @goal)
            # @watchPosition(@goal)

    setup: ->
        @camera = ENGINE.threeCamera

    setGoal: (goal) ->
        @goal = goal

    setState: (state) ->
        @state = state

    setEntityViewPosition: (position) ->
        @camera.position.set(position.x ,400 + position.y ,150 + position.z)

    getEntityViewPosition: ->
        position = @camera.position
        return new THREE.Vector3(position.x ,position.y - 400, position.z - 150)

    setTopDown: ->
        camera = ENGINE.threeCamera
        camera.position.set(0,800,0)

    watchScene: ->
        @watchPosition(ENGINE.threeScene)

    watchEntity: (entity) ->
        # look at its model or look at it?
        # camera = ENGINE.threeCamera
        # camera.position.set(entity.x ,400 + entity.y ,150 + entity.z)
        # @watchPosition(new THREE.Vector3(entity.x, entity.y, entity.z))
        
        # @setEntityViewPosition(entity.positionFromData())
        # @watchPosition(entity.positionFromData())

        @setGoal(entity.positionFromData())
        # @setGoal(entity.positionFromData())
        @setState(@MOVING_TO_GOAL)

    watchPosition: (position) ->
        camera = ENGINE.threeCamera
        camera.lookAt(position)

}   

# ==== ENGINE.threeRenderer ==== #
# - the three.js renderer obj

# ==== ENGINE.threeControls ==== #
# - the three.js controls obj
