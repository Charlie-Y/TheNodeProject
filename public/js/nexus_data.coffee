# console.log("nexus_data.coffee")
# 

###

This will be the information architexture for the nodes etc..
not sure if this is necessary. maybe. I think that they can be used as 
entities and something else...

Yeha they will extend entities and collections. of course.... maybe

###



###

Template 

class ClassName 
    # === Class Properties === #
    # === Class Methods === #
    # ==== Constructor === #

    constructor: () ->

    # === Instance Properties === #
    # === Instance Methods === #

    # toString: () ->

###

NODE_RADIUS = 10

NODE_PATH_RADIUS = 5

PLAYER_RADIUS = 8 #because the player is a sphere... sigh


###

=== NexusNode ===

- a specific node in a graph of nodes. 
- I think this is necessary. hmm. 
- Does this need to be as botha n entity and the data structure?

###
class ENGINE.NexusNode extends ENGINE.Entity
    # === Class Properties === #

    # === Class Methods === #

    # ==== Constructor === #

    constructor: (args) ->
        super(args);
        @paths = []

    # === Instance Properties === #

    nodeId: undefined
    label: undefined
    paths: [] #array of paths

    # === Instance Methods === #

    toString: () -> 
        return "(#{@x}, #{@z}) - #{@index}"

    step: (delta) ->
        # console.log("NexusNode step")
        # val = delta * 20
        # if Math.round( Math.random()) == 1
        #     val *= -1
        # # @x += val
        # @y += val
        # @z += val

    render: (delta) ->
        if !@model?
            geometry = new THREE.SphereGeometry( NODE_RADIUS, 32, 16 );
            material = new THREE.MeshLambertMaterial( { color: 0x2ecfca } );
            mesh = new THREE.Mesh( geometry, material );
            @model = mesh
            @label = ENGINE.HelperSprite.makeTextSprite(" " + @index + " ")

            ENGINE.threeScene.add(@label)
            ENGINE.threeScene.add(@model);

        @updateModelPosition();
        # console.log("NexusNode ready")
        #

    updateModelPosition: ->
        super();
        # console.log('foo')
        @label.position = @model.position.clone()
        # @label.position.x = @model.position.x + 100
        # @label.position.z = @model.position.z + 100
        # @label.position.y = @model.position.y + 50
    

    getNeighbors: =>
        neighbors = []
        # console.log("getNeighbors")
        for path in @paths
            neighbors.push(path.otherNode(@))
        return neighbors

###

=== NexusPath ===
- Connects two NexusNodes to each other
- There can be things on the path on their way to a node

###

class ENGINE.NexusPath extends ENGINE.Entity
    # === Class Properties === #

    # === Class Methods === #

    # ==== Constructor === #

    constructor: (args, @nodeA, @nodeB) ->
        super(args)
        if @hasNodes()
            @nodeA.paths.push(@)
            @nodeB.paths.push(@)

    # === Instance Properties === #

    nodeA: undefined
    nodeB: undefined
    pathId: undefined # used by NexusGrid to get path

    # === Instance Methods === #

    step: (delta) ->

    render: (delta) ->
        if !@model?

            material = new THREE.LineBasicMaterial({
                color: 0x0000ff
            });

            geometry = new THREE.Geometry();
            geometry.vertices.push( @nodeA.positionFromData() );
            geometry.vertices.push( @nodeB.positionFromData());

            line = new THREE.Line( geometry, material );
            ENGINE.threeScene.add( line );
            @model = line

            # geometry = new THREE.CylinderGeometry( NODE_PATH_RADIUS, NODE_PATH_RADIUS, 50 , 32, 16, false );
            # geometry = new THREE.SphereGeometry( 5, 32, 16 );
            # material = new THREE.MeshLambertMaterial( { color: 0x26af2d } );
            # mesh = new THREE.Mesh( geometry, material );
            # ENGINE.threeScene.add(mesh);
            # @model = mesh
        @updateModelPosition();

    hasNodes: ->
        return @nodeA? and @nodeB?

    setModelPositionFromNodes: ->
        if @model?
            newPosA = @nodeA.positionFromData();
            newPosB = @nodeB.positionFromData();

            if !@model.geometry.vertices[0].equals(newPosA)
                @model.geometry.vertices[0] = newPosA
                @model.geometry.verticesNeedUpdate = true;

            if !@model.geometry.vertices[1].equals(newPosB)
                @model.geometry.vertices[1] = newPosB
                @model.geometry.verticesNeedUpdate = true;

            # if @model.geometry.verticesNeedUpdate is true
                # console.log("foo")


            # when it was represented by a sphere
            # @x = ( @nodeA.x + @nodeB.x ) / 2
            # @y = ( @nodeA.y + @nodeB.y )/ 2
            # @z = ( @nodeA.z + @nodeB.z ) / 2

    updateModelPosition: ->
        @setModelPositionFromNodes();
        # super();


    otherNode: (node) =>
        return @nodeB if @nodeA is node 
        return @nodeA if @nodeB is node 

    toString: () ->
        return @nodeA.toString() + " - " + @nodeB.toString()

### 

=== Nexon ===
- # a nexon is an entity that inhabits a path or a node 
- can be the main character
- name still up for grabs. sounds like Nixon. 

###

class ENGINE.Nexon extends ENGINE.Entity 
    # === Class Properties === #

    # === Class Methods === #

    # ==== Constructor === #

    constructor: (args) ->
        super(args)

    # === Instance Properties === #

    gridPos: undefined # which node or path the person is inhabiting
    direction: undefined # which node or path the thing is looking at
    position: undefined # location in 3D. should be on the node...
    label: undefined
    names: undefined
    health: undefined
    type: undefined 

    # === Instance Methods === #

    step: (delta) =>
        #just float up and down for now
        #

    render: (delta) =>
        if !@model?
            geometry = new THREE.SphereGeometry( PLAYER_RADIUS, 32, 16 );
            material = new THREE.MeshLambertMaterial( { color: 0x880000 } );
            mesh = new THREE.Mesh( geometry, material );
            @model = mesh
            ENGINE.threeScene.add(@model)

        @updateModelPosition();

    updateModelPosition: () =>
        # sets x y and z from location
        @x = @gridPos.x
        @y = @gridPos.y + 10
        @z = @gridPos.z
        super()

    # ignores timing, for whatever purposes
    jumpToRandomNode: (delta) ->
        # console.log("jumpToRandomNode")
        if @onNode()
            @gridPos = _.sample(@gridPos.getNeighbors())
        @updateModelPosition();

            # console.log("new gridPos: #{@gridPos.toString()}")

    onNode: () =>
        ENGINE.NexusNode.prototype.isPrototypeOf(@gridPos)

    onPath: () =>
        ENGINE.NexusPath.prototype.isPrototypeOf(@gridPos)


    # toString: () ->


### 

=== NexusGrid ===
- Paths and Nodes combined in a structure for better querying 
- also holds players etc.

###

class ENGINE.NexusGrid extends ENGINE.Collection
    # === Class Properties === #

    # === Class Methods === #

    # ==== Constructor === #

    # Creates a X by Y number of NodeGrids properly connected by Node Paths
    # centered around (0,0), for ease of use

    constructor: (args) ->
        super(args)
        console.log("new NexusGrid")

        # add random nodes
        # for i in [0..9]
            # @randomNode();

        # add nodes in a square around the center
        xDim = 4
        zDim = 4

        centerOnZero = (val, max) ->
            return ( val - ((max - 1) / 2) ) 

        spacing = 200

        for x in [0..xDim - 1]
            for z in [0..zDim - 1]
                newX = centerOnZero(x, xDim) * spacing
                newY = 100 
                newZ = centerOnZero(z, zDim) * spacing
                newestNode = @add(ENGINE.NexusNode, {
                    x: newX
                    y: newY
                    z: newZ
                    })


        for index in [0..@length - 1]
            # node = @[index]
            # get array of valid other nodes
            # console.log(node.toString())
            if (index + 1) % zDim > 0
                @add(ENGINE.NexusPath, {
                    nodeA: @[index]
                    nodeB: @[index + 1]
                    })

            if index <= ( zDim * (xDim - 1) - 1) 
                @add(ENGINE.NexusPath, {
                    nodeA: @[index]
                    nodeB: @[index + zDim]
                    })

        @playerNexon = @add(ENGINE.Nexon, {
            gridPos: @[0] # assumes node added first
            })

    # === Instance Properties === #

    playerNexon: undefined # which nexon the player is 


    # === Instance Methods === #
    
    getPathByNodes: (nodeA, nodeB) ->
        # returns the nexusPath from nodeA to nodeB

    getNode: (index) ->

    getPath: (index) ->

    randomNode: ->
        @add(ENGINE.NexusNode, {
            x: Math.round( Math.random() * 100)
            # y: Math.round( Math.random() * 200)
            y: 30
            z: Math.round( Math.random() * 300)
            })


    # toString: () ->





