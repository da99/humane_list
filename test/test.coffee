assert = require "assert"
hl = require "humane_list"


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
describe 'Investigations', () ->
  
  it 'retrieves first value', () ->
    l = new hl.Humane_List( [3,4,5] )
    assert.equal l.left(), 3

  it 'retrieves last value', () ->
    l = new hl.Humane_List( [6, 7, 8] )
    assert.equal l.right(), 8

  it 'returns false if not .has_key', () ->
    l = new hl.Humane_List uno: 1, two: 2, three: 3, four: 4
    assert.equal l.has_key('one'), false

  it 'returns true if .has_key', () ->
    l = new hl.Humane_List one: 1, two: 2, three: 3, four: 4
    assert.equal l.has_key('one'), true

  it '.keys() returns keys in original order', () ->
    l = new hl.Humane_List( one: 1, two: 2, three: 3)
    assert.deepEqual l.keys(), [ ['one'], ['two'], ['three'] ]

  it '.at_key() returns undefined if key not found.', () ->
    l = new hl.Humane_List( one: 1, two: 2, three: 3)
    assert_undef l.at_key('uno')

# ============================================================================
describe 'Inserting', () ->

  it 'can insert to the top', () ->
    l = new hl.Humane_List()
    l.push 'first', "def"
    l.push 'first', "abc"
    assert.equal l.left(), "abc"

  it 'can insert at end', () ->
    l = new hl.Humane_List()
    l.push 'last', "second"
    l.push 'last', "first"
    l.push 'last', "third"
    assert.equal l.right(), "third"

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

  it 'can merge an array before first element', () ->
    l = new hl.Humane_List([1,2,3])
    l.merge 'first', [-2, -1, 0]
    assert.deepEqual l.values(), [-2, -1, 0, 1, 2, 3]

  it 'can merge an object after last element', () ->
    l = new hl.Humane_List( one: 1, two: 2 )
    l.merge 'last', three: 3, four: 4
    assert.deepEqual l.values(), [1, 2, 3, 4]

  it 'keeps order of keys when merging objects', () ->
    l = new hl.Humane_List( uno: 1, dos: 2 )
    l.merge 'first', neg_one: -1, zero: 0
    assert.deepEqual l.keys(), [ ["neg_one"], ["zero"], ["uno"], ["dos"] ]
    
# ============================================================================
describe 'Popping', () ->

  it 'can pop from the top', () ->
    l = new hl.Humane_List ['h', 'j', 'k', 'l']
    l.pop('first')
    assert.deepEqual l.values(), ['j', 'k', 'l']
    
  it 'returns value from the top', () ->
    l = new hl.Humane_List ['h', 'j', 'k', 'l']
    assert.equal l.pop('first'), 'h'

  it 'can pop from the end', () ->
    l = new hl.Humane_List ['h', 'j', 'k', 'l']
    l.pop('last')
    assert.deepEqual l.values(), ['h', 'j', 'k']
    
  it 'returns value from the end', () ->
    l = new hl.Humane_List ['h', 'j', 'k', 'l']
    assert.equal l.pop('last'), 'l'


# ============================================================================
describe 'Retrieving values using keys', () ->

  it 'returns value', () ->
    l = new hl.Humane_List one: 1, dos: 2, three: 3, four: 4
    assert.equal l.at_key("dos"), 2
    

