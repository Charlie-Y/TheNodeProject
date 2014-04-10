### 

=== NexusTHREE

In control of most of the drawing things that are in the 


###

class ENGINE.NexusNodeModel


class ENGINE.HelperSprite
    @makeTextSprite: (message, parameters) ->
        parameters = {}  if parameters is `undefined`
        fontface = (if parameters.hasOwnProperty("fontface") then parameters["fontface"] else "Arial")
        fontsize = (if parameters.hasOwnProperty("fontsize") then parameters["fontsize"] else 62)
        borderThickness = (if parameters.hasOwnProperty("borderThickness") then parameters["borderThickness"] else 4)
        borderColor = (if parameters.hasOwnProperty("borderColor") then parameters["borderColor"] else
            r: 0
            g: 0
            b: 0
            a: 1.0
            )
        backgroundColor = (if parameters.hasOwnProperty("backgroundColor") then parameters["backgroundColor"] else
            r: 255
            g: 255
            b: 255
            a: 1.0
            )
        # spriteAlignment = if parameters.hasOwnProperty("alignment") then parameters["alignment"] else THREE.SpriteAlignment.topLeft;
        # spriteAlignment = THREE.SpriteAlignment.topLeft;

        canvas = document.createElement("canvas")
        context = canvas.getContext("2d")
        context.font = "Bold " + fontsize + "px " + fontface

        # get size data (height depends only on font size)
        metrics = context.measureText(message)
        textWidth = metrics.width

        # background color
        context.fillStyle = "rgba(" + backgroundColor.r + "," + backgroundColor.g + "," + backgroundColor.b + "," + backgroundColor.a + ")"

        # border color
        context.strokeStyle = "rgba(" + borderColor.r + "," + borderColor.g + "," + borderColor.b + "," + borderColor.a + ")"
        context.lineWidth = borderThickness

        ENGINE.HelperSprite.roundRect(context, borderThickness / 2, borderThickness / 2, textWidth + borderThickness, fontsize * 1.4 + borderThickness, 40)

        # 1.4 is extra height factor for text below baseline: g,j,p,q.

        # text color
        context.fillStyle = "rgba(0, 0, 0, 1.0)"
        context.fillText message, borderThickness, fontsize + borderThickness

        # canvas contents will be used for a texture
        texture = new THREE.Texture(canvas)
        texture.needsUpdate = true
        spriteMaterial = new THREE.SpriteMaterial(
            map: texture
            useScreenCoordinates: false
        )
        sprite = new THREE.Sprite(spriteMaterial)
        sprite.scale.set 50, 25, 1
        return sprite

    # function for drawing rounded rectangles
    @roundRect:(ctx, x, y, w, h, r) ->
        ctx.beginPath()
        ctx.moveTo x + r, y
        ctx.lineTo x + w - r, y
        ctx.quadraticCurveTo x + w, y, x + w, y + r
        ctx.lineTo x + w, y + h - r
        ctx.quadraticCurveTo x + w, y + h, x + w - r, y + h
        ctx.lineTo x + r, y + h
        ctx.quadraticCurveTo x, y + h, x, y + h - r
        ctx.lineTo x, y + r
        ctx.quadraticCurveTo x, y, x + r, y
        ctx.closePath()
        ctx.fill()

