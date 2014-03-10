require 'controller'

world =
    width: 20
    height: 15

export collisionMap = [ [false for j = 1, world.height] for i = 1, world.width ]

markCollision = (x, y, id) ->
    if id
        if collisionMap[x + 1][y + 1] == false or collisionMap[x + 1][y + 1][1] != id
            collisionMap[x + 1][y + 1] = {id, 1}
        else
            collisionMap[x + 1][y + 1][2] = collisionMap[x + 1][y + 1][2] + 1
    else
        if collisionMap[x + 1][y + 1] != false
            v = collisionMap[x + 1][y + 1][2]
            if v == 1
                collisionMap[x + 1][y + 1] = false
            else
                collisionMap[x + 1][y + 1][2] = v - 1

checkAvailable = (x, y, id) ->
    x >= 0 and y >= 0 and x < world.width and y < world.height and ((not collisionMap[x + 1][y + 1]) or collisionMap[x + 1][y + 1][1] == id)

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
        new: (x, y, c, id)=>
            super x, y
            markCollision @x, @y, id
            @color = c
        color: {128, 180, 255}
    count = 0
    controller: ArrowController!
    new: (x, y, fx, fy, color)=>
        @color = color
        @length = 6
        @dir = {0, 1}

        @id = count
        count = count + 1

        @segs = [Seg x, y - i, color, @id for i = 0, @length - 1]
        @segs[1].color = {color[1] * 0.7, color[2] * 0.7, color[3] * 0.7}

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

        if checkAvailable head.x + @dir[1], head.y + @dir[2], @id
            @go @dir[1], @dir[2]
        else if @oldDir and checkAvailable head.x + @oldDir[1], head.y + @oldDir[2], @id
            @dir = @oldDir
            @go @oldDir[1], @oldDir[2]
        @oldDir = @dir
    go: (dx, dy) =>
        head = @segs[1]
        l = #@segs
        tail =
            x: @segs[l].x
            y: @segs[l].y
        for i = l, 2, -1
            @segs[i].x = @segs[i - 1].x
            @segs[i].y = @segs[i - 1].y
        head.x += dx
        head.y += dy

        if head.x == @food.x and head.y == @food.y
            @food\redist!
            table.insert @segs, (Seg tail.x, tail.y, @color)
        else
            markCollision tail.x, tail.y, false
        markCollision head.x, head.y, @id

export class Food extends Square
    color: {80, 100, 255}
    redist: (x, y)=>
        @x = x or (math.random(world.width) - 1)
        @y = y or (math.random(world.height) - 1)

export snakes

player2 = ->
    snake1 = Snake(5, 10, 15, 5, {80, 100, 255})
    snake1.controller = ArrowController!
    snake2 = Snake(15, 10, 5, 5, {255, 100, 80})
    snake2.controller = WASDController!
    snakes = {snake1, snake2}

player3 = ->
    player2!
    snake3 = Snake(10, 5, 10, 2, {100, 255, 80})
    snake3.controller = GVBNController!
    snakes = {snakes[1], snakes[2], snake3}

player3!

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