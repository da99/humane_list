
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
    target
    
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

  to_key_or_computer_position: (key_or_human_pos) ->
    if typeof(key_or_human_pos) is 'number'
      return key_or_human_pos - 1
    key_or_human_pos

  get_computer_position: (key_or_human_pos) ->
    key_or_pos = @to_key_or_computer_position(key_or_human_pos)
    return key_or_pos unless key_or_pos
    pos = k for v, k in @core when (k is key_or_pos ) or ( key_or_pos in v[0] )
    pos

  get_computer_position_or_throw: (key_or_human_pos) ->
    pos  = @get_computer_position(key_or_human_pos)
    if !pos
      throw new Error("Key/pos is not defined: #{key_or_human_pos}")
    pos
    
  alias: (key_or_pos, nickname) ->
    pos = @get_computer_position_or_throw(key_or_pos)
    keys = @core[pos][0]
    return nickname if nickname in keys
    keys.push nickname
    
  remove_alias: (nickname) ->
    pos  = @get_computer_position(nickname)
    return pos unless pos
    row  = @core[pos]
    keys = row[0]
    new_keys = v for v in keys when v != nickname
    row[0] = new_keys
    nickname

  delete_at: (target_k) ->
    pos = @get_computer_position(target_k)
    row = @core[pos]
    return row unless row
    
    @core[pos] = [ [], @core.undefined ]
    return( @at_position(pos) )


exports.Humane_List = Humane_List



