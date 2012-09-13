
assert = require "assert"
hl = require "humane_list"
Position = hl.Position

describe "Position", () ->
  
  describe '.position()', () ->
    
    it 'has a default of 0 if list is empty', () ->
      l = new Position( new hl []  )
      assert.equal l.position(), 0

    it 'has a default position of 1', () ->

      p = new Position( new hl [] )
      assert.equal p.position(), 0

  describe '.value()', () ->

    it 'returns the value of current position', () ->

      p = new Position( new hl [1,2,3] )
      p.downward()
      assert.equal p.value(), 2
      
  describe '.downward()', () ->

    it 'moves position downward by one', () ->
      p = new Position( new hl.Humane_List [1,2,3] )
      p.downward()
      assert.equal p.position(), 2

    it 'moves position downward, even for non-consencutive positions', () ->
      list = ( new hl.Humane_List )
      list.push 2, "two"
      list.push 4, "two"
      list.push 6, "two"

      p = list.position()
      p.downward()
      assert.equal p.position(), 4

    it 'raises an error if length is 0', () ->
      p = new Position( new hl.Humane_List )
      try 
        p.downward()
      catch e
        err = e
      assert.equal err.message, "Position already at end: 0."

    it 'raises an error if past length', () ->
      p = new Position( new hl.Humane_List [1,2,3] )
      p.downward()
      p.downward()
      try
        p.downward()
      catch e
        err = e 
        
      assert.equal err.message, "Position already at end: 3."
      
  describe '.upward()', () ->

    it 'moves position upward by one', () ->
      p = new Position( new hl.Humane_List [1,2,3] )
      p.downward()
      p.downward()
      p.upward()
      assert.equal p.position(), 2

    it 'moves position upward, even for non-consencutive positions', () ->
      list = ( new hl.Humane_List )
      list.push 2, "two"
      list.push 4, "two"
      list.push 6, "two"

      p = list.position()
      p.to_bottom()
      p.upward()
      assert.equal p.position(), 4
      
    it 'raises an error if length is 0', () ->
      p = new Position( new hl.Humane_List )
      try 
        p.upward()
      catch e
        err = e
      assert.equal err.message, "No valid position before: 0."

    it 'raises an error if position is 1', () ->
      p = new Position( new hl.Humane_List [1,2,3] )
      try 
        p.upward()
      catch e
        err = e
      assert.equal err.message, "No valid position before: 1."


  describe '.to(N)', () ->
    
    it 'moves position to N', () ->
      p = new Position( new hl.Humane_List [0,2,4] )
      p.to(3)
      assert.equal p.value(), 4

  describe '.to_top()', () ->
    
    it 'moves position to 0', () ->
      p = new Position( new hl.Humane_List [0,2,4] )
      p.to_top()
      assert.equal p.position(), 1

    it "does not raise an error if length is 0", () ->
      p = new Position( new hl.Humane_List )
      p.to_top()
      assert.equal p.position(), 0

  describe '.to_bottom()', () ->
    
    it 'moves position to length-1', () ->
      p = new Position( new hl.Humane_List [0,2,4] )
      p.to_bottom()
      assert.equal p.position(), 3

    it "does not raise an error if length is 0", () ->
      p = new Position( new hl.Humane_List )
      p.to_bottom()
      assert.equal p.position(), 0
    
  describe '.is_at_top()', () ->

    it 'returns true if at first position', () ->
      p = new Position( new hl.Humane_List [0,2,4,6] )
      assert.equal p.is_at_top(), true

    it 'returns false if not first position', () ->
      p = new Position( new hl.Humane_List [0,2,4,6] )
      p.to(2)
      assert.equal p.is_at_top(), false

  describe '.is_at_bottom()', () ->

    it 'returns true if at last position', () ->
      p = new Position( new hl.Humane_List [0,2,4,6] )
      p.to_bottom()
      assert.equal p.is_at_bottom(), true

    it 'returns false if not at last position', () ->
      p = new Position( new hl.Humane_List [0,2,4,6] )
      assert.equal p.is_at_bottom(), false

  describe '.value()', () ->

    it 'returns value at current position', () ->
      p = ( new hl.Humane_List [0,2,4,6,8] ).position()
      p.to(4)
      assert.equal p.value(), 6

  describe '.next()', () ->

    it 'returns the next value', () ->
      l = (new hl.Humane_List [0,2,4,6,8]).position()
      l.to(2)
      assert.equal l.next(), 4

    it 'does not alter position', () ->
      l = (new hl.Humane_List [0,2,4,6,8]).position()
      l.to(2)
      l.next()
      assert.equal l.position(), 2

    it 'raises an error if at last position', () ->
      p = (new hl.Humane_List [1]).position()
      p.to_bottom()
      try
        p.next()
      catch e
        err = e
      assert.equal err.message, "No valid position after: 1."

  describe '.previous()', () ->

    it 'returns the previous value', () ->
      l = (new hl [0,2,4,6,8]).position()
      l.to(3)
      assert.equal l.previous(), 2

    it 'does not alter position', () ->
      l = (new hl [0,2,4,6,8]).position()
      l.to(3)
      l.previous()
      assert.equal l.position(), 3

    it 'raises an error if at first position', () ->
      p = (new hl.Humane_List [1]).position()
      try
        p.previous()
      catch e
        err = e
      assert.equal err.message, "No valid position before: 1."

