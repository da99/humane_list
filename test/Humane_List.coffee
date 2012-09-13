assert = require "assert"
hl = require "humane_list"
_  = require "underscore"


must_equal = (a, e) ->
  assert.deepEqual a, e

assert_undef = (v) ->
  assert.equal typeof(v), 'undefined'
  
# ============================================================================
describe 'Initialization', () ->

  it 'accepts an array', () ->
    l = new hl.Humane_List [1,2,3]
    assert.deepEqual l.values(), [1,2,3]

  it 'accepts a k/v object', () ->
    l = new hl.Humane_List one: 1, two: 2, three: 3, four: 4
    assert.deepEqual l.values(), [1,2,3,4]

# ============================================================================
describe 'Navigation', () ->

  describe '.position()', () ->

    it 'has a default of undefined if no array passed to it', () ->
      l = new hl.Humane_List
      assert.equal l.position(), undefined

    it 'has a default of 1', () ->
      l = new hl.Humane_List [1,2,3]
      assert.equal l.position(), 1
  
  describe '.downward()', () ->

    it 'moves position downward by one', () ->
      l = new hl.Humane_List [1,2,3]
      l.downward()
      assert.equal l.position(), 2

    it 'raises an error if length is 0', () ->
      l = new hl.Humane_List
      try 
        l.downward()
      catch e
        err = e
      assert.equal err.message, "Position can't be, NaN, because length is: 0."
  
    it 'raises an error if past length', () ->
      l = new hl.Humane_List [1,2,3]
      l.downward()
      l.downward()
      try
        l.downward()
      catch e
        err = e 
        
      assert.equal err.message, "Position can't be, 4, because length is: 3."
      
  describe '.upward()', () ->

    it 'moves position upward by one', () ->
      l = new hl.Humane_List [1,2,3]
      l.downward()
      l.downward()
      l.upward()
      assert.equal l.position(), 2

    it 'raises an error if length is 0', () ->
      l = new hl.Humane_List
      try 
        l.upward()
      catch e
        err = e
      assert.equal err.message, "Position can't be, NaN, because length is: 0."

    it 'raises an error if position is 1', () ->
      l = new hl.Humane_List [1,2,3]
      try 
        l.upward()
      catch e
        err = e
      assert.equal err.message, "Position can't be, 0, because starting position is: 1."


  describe '.to(N)', () ->
    
    it 'moves position to N', () ->
      l = new hl.Humane_List [0,2,4]
      l.to(3)
      assert.equal l.position(), 3
  
  describe '.to_top()', () ->
    
    it 'moves position to 0', () ->
      l = new hl.Humane_List [0,2,4]
      l.to_top()
      assert.equal l.position(), 1

    it "raises an error if length is 0", () ->
      l = new hl.Humane_List
      try
        l.to_top()
      catch e
        err = e
      assert.equal err.message, "Position can't be, 0, because length is: 0."
  
  describe '.to_bottom()', () ->
    
    it 'moves position to length-1', () ->
      l = new hl.Humane_List [0,2,4]
      l.to_bottom()
      assert.equal l.position(), 3

    it "raises an error if length is 0", () ->
      l = new hl.Humane_List
      try
        l.to_bottom()
      catch e
        err = e
      assert.equal err.message, "Position can't be, 0, because length is: 0."
    
  describe '.is_at_top()', () ->

    it 'returns true if at first position', () ->
      l = new hl.Humane_List [0,2,4,6]
      assert.equal l.is_at_top(), true

    it 'returns false if not first position', () ->
      l = new hl.Humane_List [0,2,4,6]
      l.to(2)
      assert.equal l.is_at_top(), false

  describe '.is_at_bottom()', () ->

    it 'returns true if at last position', () ->
      l = new hl.Humane_List [0,2,4,6]
      l.to_bottom()
      assert.equal l.is_at_bottom(), true

    it 'returns false if not at last position', () ->
      l = new hl.Humane_List [0,2,4,6]
      assert.equal l.is_at_bottom(), false

  describe '.value()', () ->

    it 'returns value at current position', () ->
      l = new hl.Humane_List [0,2,4,6,8]
      l.to(4)
      assert.equal l.value(), 6

  describe '.next()', () ->

    it 'returns the next value', () ->
      l = new hl.Humane_List [0,2,4,6,8]
      l.to(2)
      assert.equal l.next(), 4

    it 'does not alter position', () ->
      l = new hl.Humane_List [0,2,4,6,8]
      l.to(2)
      l.next()
      assert.equal l.position(), 2

  describe '.previous()', () ->

    it 'returns the previous value', () ->
      l = new hl [0,2,4,6,8]
      l.to(3)
      assert.equal l.previous(), 2

    it 'does not alter position', () ->
      l = new hl [0,2,4,6,8]
      l.to(3)
      l.previous()
      assert.equal l.position(), 3

    
# ============================================================================
describe 'Inspecting', () ->
  
  describe '.top()', () ->
    it 'retrieves first value', () ->
      l = new hl( [3,4,5] )
      assert.equal l.top(), 3

  describe '.bottom()', () ->
    it 'retrieves last value', () ->
      l = new hl( [6, 7, 8] )
      assert.equal l.bottom(), 8

  describe '.has_key(k)', () ->
    it 'returns false if key not found', () ->
      l = new hl.Humane_List uno: 1, two: 2, three: 3, four: 4
      assert.equal l.has_key('one'), false

    it 'returns true if key found', () ->
      l = new hl.Humane_List one: 1, two: 2, three: 3, four: 4
      assert.equal l.has_key('one'), true

  describe '.keys()', () ->
    it '.keys() returns keys in original order', () ->
      l = new hl.Humane_List( one: 1, two: 2, three: 3)
      assert.deepEqual l.keys(), [ ['one'], ['two'], ['three'] ]

  describe '.at_key(l)', () ->
    it '.at_key() returns undefined if key not found.', () ->
      l = new hl.Humane_List( one: 1, two: 2, three: 3)
      assert_undef l.at_key('uno')

# ============================================================================
describe 'Pushing', () ->

  it 'can insert to the top', () ->
    l = new hl()
    l.push 'top', "def"
    l.push 'top', "abc"
    assert.equal l.top(), "abc"

  it 'can insert at bottom', () ->
    l = new hl()
    l.push 'bottom', "second"
    l.push 'bottom', "first"
    l.push 'bottom', "third"
    assert.equal l.bottom(), "third"

  it 'can insert at a specified position', () ->
    l = new hl [1, 3, 4]
    l.push 2, "dos"
    assert.deepEqual l.values(), [1, "dos", 3, 4]

  it 'sets a default position of 1 for first element w/o defined position', () ->
    l = new hl
    l.push 'top', "one"
    assert.deepEqual l.positions(), [1]

  it 'sets a default position of .length+1 for pushing to bottom', () ->
    l = new hl [1,2,3]
    l.push 'bottom', "four"
    assert.deepEqual l.positions(), [1,2,3,4]

  it 'adds one to all succeeding positions until positions are unique', () ->
    l = new hl [1, 2, 3]
    l.push 2.1, "2.1"
    l.push 2, "dos"
    l.push 5, "five"
    assert.deepEqual l.values(),    [ 1, "dos", 2, 2.1, 3, 'five']
    assert.deepEqual l.positions(), [ 1,  2, 3, 3.1, 4, 5]

  it 'can insert both a key and value', () ->
    l = new hl()
    l.push 'top', "three", 3
    l.push 'top', "two", 2
    l.push 'top', "one", 1

    assert.deepEqual l.values(), [1, 2, 3]
    assert.deepEqual l.keys(),   [ ['one'], ['two'], ['three'] ]

  it 'sorts elements using numerical sorting of position: 1..20', () ->
    arr = _.range(1,21)
    l = new hl(arr)
    assert.deepEqual l.values(), arr

# ============================================================================
describe 'Popping', () ->

  it 'can pop from the top', () ->
    l = new hl.Humane_List ['h', 'j', 'k', 'l']
    l.pop('top')
    assert.deepEqual l.values(), ['j', 'k', 'l']
    
  it 'returns value from the top', () ->
    l = new hl.Humane_List ['h', 'j', 'k', 'l']
    assert.equal l.pop('top'), 'h'

  it 'can pop from the bottom', () ->
    l = new hl.Humane_List ['h', 'j', 'k', 'l']
    l.pop('bottom')
    assert.deepEqual l.values(), ['h', 'j', 'k']
    
  it 'returns value from the bottom', () ->
    l = new hl.Humane_List ['h', 'j', 'k', 'l']
    assert.equal l.pop('bottom'), 'l'

# ============================================================================
describe 'Aliasing:', () ->

  describe '.alias(k, alias):', () ->

    it 'can add an alias based on numbered position', () ->
      l = new hl.Humane_List [1, 2, 3]
      l.alias 2, "TWO"
      assert.equal l.at_key("TWO"), 2

    it 'can add an alias based on key', () ->
      l = new hl.Humane_List one: 1, two: 2, three: 3, four: 4
      l.alias "three", "trey"
      assert.equal l.at_key("trey"), 3

    it 'does not add alias if duplicate key', () ->
      l = new hl.Humane_List one: 1, two: 2
      l.alias "two", "dos"
      l.alias "two", "dos"
      assert.deepEqual l.keys(), [["one"], ["two", "dos"]]
      
    it 'raises error if key/pos does not exist', () ->
      err = null
      try
        l = new hl.Humane_List one: 1, two: 2, three: 3, five: 5
        l.alias "four", "quad"
      catch e
        err = e

      assert.equal err.message, "Key/pos is not defined: four"

  describe '.at_key(k):', () ->

    it 'returns undefined if no alias is found', () ->
      l = new hl.Humane_List one: 1, two: 2, three: 3, four: 4
      assert_undef l.at_key("trey")

  describe '.remove_alias(k):', () ->
    
    it 'removes alias, but not the value.', () ->
      alias = "trey"
      l = new hl.Humane_List one: 1, two: 2, three: 3, four: 4
      l.alias "three", alias
      l.remove_alias alias
      assert_undef(l.at_key alias)
      assert.equal l.at_key('three'), 3
    
# ============================================================================
describe 'Deleting', () ->

  it 'removes value at a given position', () ->
    l = new hl.Humane_List [1, 2, 3]
    l.delete_at 2
    assert.deepEqual l.values(), [1, 3]

  it 'removes value by given key', () ->
    l = new hl.Humane_List one: 1, dos: 2, trey: 3
    l.delete_at "trey"
    assert.deepEqual l.values(), [1, 2]

# ============================================================================
describe 'Merging', () ->

  it 'can concat an array before first element', () ->
    l = new hl.Humane_List([1,2,3])
    l.concat 'top', [-2, -1, 0]
    assert.deepEqual l.values(), [-2, -1, 0, 1, 2, 3]

  it 'can concat an object after last element', () ->
    l = new hl.Humane_List( one: 1, two: 2 )
    l.concat 'bottom', three: 3, four: 4
    assert.deepEqual l.values(), [1, 2, 3, 4]

  it 'keeps order of keys when merging objects', () ->
    l = new hl.Humane_List( uno: 1, dos: 2 )
    l.concat 'top', neg_one: -1, zero: 0
    assert.deepEqual l.keys(), [ ["neg_one"], ["zero"], ["uno"], ["dos"] ]
    

# ============================================================================
describe 'Retrieving values using keys', () ->

  it 'returns value', () ->
    l = new hl.Humane_List one: 1, dos: 2, three: 3, four: 4
    assert.equal l.at_key("dos"), 2
    

