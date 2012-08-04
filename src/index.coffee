
class Humane_List

  constructor: ( vals ) ->
    @core = if vals && vals.length
      [ [], v ] for v in vals
    else if vals
      [ [k], v ] for k, v of vals
    else
      (vals || [])

  pop_top: () ->
    arr = @core.shift()
    return arr unless arr
    arr[1]

  pop_end: () ->
    arr = @core.pop()
    return arr unless arr
    arr[1]

  insert_top: ( v ) ->
    @core.unshift [ [] , v ]

  insert_end: ( v ) ->
    @core.push [ [] , v ]

  first: () ->
    @at_position(1)

  last: () ->
    @at_position(@core.length)

  alias: (key, val) ->

  get: (k) ->
    target = v[1] for v in @core when v[0].indexOf(k) > -1

  has_key: (k) ->

    
  delete: (k) ->

  merge_top: () ->
  merge_end: () ->

  values: () ->
    v[1] for v in @core
    
  at_position: (n) ->
    prog_index = (n or 1) - 1
    arr = @core[prog_index]
    return arr unless arr
    arr[1]




exports.Humane_List = Humane_List
