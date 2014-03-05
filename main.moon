require 'controller'

world =
    width: 20
    height: 15

export collisionMap = [ [false for j = 1, world.height] for i = 1, world.width ]

markCollision = (x, y, b) ->
    collisionMap[x + 1][y + 1] = b

checkCollision = (x, y) ->
    x >= 0 and y >= 0 and x < world.width and y < world.height and not collisionMap[x + 1][y + 1]

export class Square
    new: (x, y)=>
        @x = x
        @y = y

    draw: =>
        with love.graphics
            .setColor @color
            .rectangle "fill", @x * 40, @y * 40, 40, 40

export class Snake
    class Seg extends Square
        new: (x, y, c)=>
            super x, y
            markCollision @x, @y, true
            @color = c
        color: {128, 180, 255}
    controller: ArrowController!
    new: (x, y, fx, fy, color)=>
        @color = color
        @length = 6
        @dir = {0, 1}

        @segs = [Seg x, y - i, color for i = 0, @length - 1]

        @food = Food(fx, fy)
        @food.color = {color[1] * 2, color[2] * 2, color[3] * 2}

        @timer = 0
    draw: =>
        for s in *@segs
            s\draw!
    drawFood: =>
        @food\draw!
    update: =>
        @timer += 1
        @timer += 1 if @controller.speedup!

        if @controller\left!
            @dir = {-1, 0}
        if @controller\right!
            @dir = {1, 0}
        if @controller\up!
            @dir = {0, -1}
        if @controller\down!
            @dir = {0, 1}

        if @timer >= 6
            @timer = 0
            @onCrossGrid!
    onCrossGrid: =>

        head = @segs[1]

        if checkCollision head.x + @dir[1], head.y + @dir[2]
            l = #@segs
            tail =
                x: @segs[l].x
                y: @segs[l].y
            for i = l, 2, -1
                @segs[i].x = @segs[i - 1].x
                @segs[i].y = @segs[i - 1].y
            head.x += @dir[1]
            head.y += @dir[2]

            if head.x == @food.x and head.y == @food.y
                @food\redist!
                table.insert @segs, (Seg tail.x, tail.y, @color)
            else
                markCollision tail.x, tail.y, false
            markCollision head.x, head.y, true

export class Food extends Square
    color: {80, 100, 255}
    redist: (x, y)=>
        @x = x or (math.random(world.width) - 1)
        @y = y or (math.random(world.height) - 1)

snake1 = Snake(5, 10, 15, 5, {80, 100, 255})
snake1.controller = ArrowController!
snake2 = Snake(15, 10, 5, 5, {255, 100, 80})
snake2.controller = WASDController!
--snake3 = Snake(10, 5, 10, 2, {100, 255, 80})
--snake3.controller = GVBNController!

snakes = {snake1, snake2}

math.randomseed(os.time())

love.load = ->
love.update = ->
    for s in *snakes
        s\update!
love.draw = ->
    with love.graphics
        .setColor {255, 255, 255}
        .printf 'SNAKE4 Blockhead', 20, 20, 100, 'left'
    for s in *snakes
        s\draw!

    for s in *snakes
        s\drawFood!