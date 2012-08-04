assert = require "assert"
hl = require "humane_list"


must_equal = (a, e) ->
  assert.deepEqual a, e

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
    assert.equal l.first(), 3

  it 'retrieves last value', () ->
    l = new hl.Humane_List( [6, 7, 8] )
    assert.equal l.last(), 8

  it 'returns false if not .has_key', () ->
    l = new hl.Humane_List uno: 1, two: 2, three: 3, four: 4
    assert.equal l.has_key('one'), false

  it 'returns true if .has_key', () ->
    l = new hl.Humane_List one: 1, two: 2, three: 3, four: 4
    assert.equal l.has_key('one'), true


# ============================================================================
describe 'Inserting', () ->

  it 'can insert to the top', () ->
    l = new hl.Humane_List()
    l.insert 'first', "def"
    l.insert 'first', "abc"
    assert.equal l.first(), "abc"

  it 'can insert at end', () ->
    l = new hl.Humane_List()
    l.insert 'last', "second"
    l.insert 'last', "first"
    l.insert 'last', "third"
    assert.equal l.last(), "third"


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
    

