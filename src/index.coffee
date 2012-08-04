
class Humane_List

  constructor: ( vals ) ->
    @core = if vals && vals.length
      [ [], v ] for v in vals
    else if vals
      [ [k], v ] for k, v of vals
    else
      (vals || [])

  pop: (pos) ->
    if pos.toString() is 'first'
      arr = @core.shift()
      return arr unless arr
      arr[1]
    else
      arr = @core.pop()
      return arr unless arr
      arr[1]

  push: (pos, v) ->
    if pos.toString() is 'first'
      @core.unshift [ [] , v ]
    else
      @core.push [ [] , v ]

  first: () ->
    @at_position(1)

  last: () ->
    @at_position(@core.length)

  at_key: (k) ->
    target = v[1] for v in @core when v[0].indexOf(k) > -1
    
  at_position: (n) ->
    prog_index = (n or 1) - 1
    arr = @core[prog_index]
    return arr unless arr
    arr[1]

  has_key: (k) ->
    target = true for v in @core when k in v[0]
    target or false

  keys: () ->
    arr[0] for arr in @core

  merge: (pos, o) ->
    new_core = if o && o.length
      [ [], val ] for val in o
    else
      [ [key], val ] for key, val of o
      
    @core = if pos.toString() is "first"
      new_core.concat @core
    else
      @core.concat new_core

  values: () ->
    v[1] for v in @core

  alias: (key, val) ->

  delete_at: (target_k) ->
    if typeof(target_k) is "number"
      target_k -= 1
      
    pos = k for v, k in @core when (k is target_k ) or ( target_k in v[0] )
    return pos if typeof(pos) is "undefined"
    
    @core[pos] = [ [], @core.undefined ]
    return( @at_position(pos) )


exports.Humane_List = Humane_List



