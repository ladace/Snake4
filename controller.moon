
export class ArrowController
    left: => love.keyboard.isDown 'left'
    right: => love.keyboard.isDown 'right'
    up: => love.keyboard.isDown 'up'
    down: => love.keyboard.isDown 'down'
    speedup: => love.keyboard.isDown 'rshift'

export class WASDController
    left: => love.keyboard.isDown 'a'
    right: => love.keyboard.isDown 'd'
    up: => love.keyboard.isDown 'w'
    down: => love.keyboard.isDown 's'
    speedup: => love.keyboard.isDown 'lshift'

export class GVBNController
    left: => love.keyboard.isDown 'v'
    right: => love.keyboard.isDown 'n'
    up: => love.keyboard.isDown 'g'
    down: => love.keyboard.isDown 'b'
    speedup: => love.keyboard.isDown ' '