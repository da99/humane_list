
assert = require "assert"
hl = require "humane_list"
Position = hl.Position

describe 'Position position()', () ->

  it 'has a default position of 1', () ->

    p = new Position( new hl [] )
    assert.equal p.position(), 0

describe 'Position value()', () ->

  it 'returns the value of current position', () ->

    p = new Position( new hl [1,2,3] )
    p.downward()
    assert.equal p.value(), 2
