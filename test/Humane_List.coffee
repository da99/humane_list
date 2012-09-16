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
describe '.position()', () ->

  it 'returns a Position', () ->
    l = new hl.Humane_List [1,2,3]
    assert.equal l.position().next, (new hl.Position(l)).next
describe 'Navigation', () ->

    
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

  it 'can insert at a specified position', () ->
    l = new hl [1, 3, 4]
    l.push 2, "dos"
    assert.deepEqual l.values(), [1, "dos", 3, 4]

  it 'raises error if non-numerical position is not "top" or "bottom"', () ->
    err = null
    try
      l = new hl()
      l.push 'middled', 3
    catch e
      err = e
    assert.equal err.message, "Unknown position: middled"

  it 'adds one to all succeeding positions until positions are unique', () ->
    l = new hl [1, 2, 3]
    l.push 2.1, "2.1"
    l.push 2, "dos"
    l.push 5, "five"
    assert.deepEqual l.positions(), [ 1,  2, 3, 3.1, 4, 5]
    assert.deepEqual l.values(),    [ 1, "dos", 2, 2.1, 3, 'five']

  it 'sorts elements using numerical sorting of position: 1..20', () ->
    arr = _.range(1,21)
    l = new hl(arr)
    assert.deepEqual l.values(), arr

describe 'Pushing "top"', () ->
    
  it 'can insert to the top', () ->
    l = new hl()
    l.push 'top', "1"
    l.push 'top', "2"
    l.push 'top', "3"
    assert.deepEqual l.values(), ['3', '2', '1']
  
  it 'sets new position to less than one of top value', () ->
    l = new hl()
    l.push 2, 2
    l.push 3, 3
    l.push 'top', 1
    assert.deepEqual l.positions(), [ 1, 2, 3]

  it "sets new position to one if original first position is 1", () ->
    l = new hl [1,2,3]
    l.push 'top', 0
    assert.deepEqual l.positions(), [ 1, 2, 3, 4 ]

  it "sets new position to newest whole number minus 1 if original first position is less than one.", () ->
    l = new hl 
    l.push -1.1, "-1.1"
    l.push 0.8, "0.8"
    l.push 0.9, "0.9"
    l.push 'top', "-2"
    assert.deepEqual l.positions(), [ -2, -1.1, 0.8, 0.9 ]

  it 'sets a default position of 1 for first element w/o defined position', () ->
    l = new hl
    l.push 'top', "one"
    assert.deepEqual l.positions(), [1]
    
  it 'can insert both a key and value', () ->
    l = new hl()
    l.push 'top', "three", 3
    l.push 'top', "two", 2
    l.push 'top', "one", 1

    assert.deepEqual l.values(), [1, 2, 3]
    assert.deepEqual l.keys(),   [ ['one'], ['two'], ['three'] ]


describe 'Pushing "bottom"', () ->
  
  it 'can insert at bottom', () ->
    l = new hl()
    l.push 'bottom', "second"
    l.push 'bottom', "first"
    l.push 'bottom', "third"
    assert.deepEqual l.values(), ["second", "first", "third"]

  it 'sets a default position of .length+1 for pushing to bottom', () ->
    l = new hl [1,2,3]
    l.push 'bottom', "four"
    assert.deepEqual l.positions(), [1,2,3,4]

  it 'sets the next whole number for fractional positions', () ->
    l = new hl()
    l.push 3.1, "3.1"
    l.push 4.8, "4.8"
    l.push 'bottom', "5"
    assert.deepEqual l.positions(), [3.1, 4.8, 5]


    
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
    

