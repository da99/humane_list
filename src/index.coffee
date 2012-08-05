
class Humane_List

  Element: class Element

    constructor: () ->

      switch arguments.length
        when 1
          @keys = []
          @val = arguments[0]
        when 2
          @keys = arguments[0]
          @val  = arguments[1]
        when 3
          @pos  = arguments[0]
          @keys = arguments[1]
          @val  = arguments[2]
          
        else
          throw new Error("Unknown quantity of arguments: #{arguments}")
        
      @keys = if @keys.shift
        @keys
      else
        [@keys]

    to_array: () ->
      [ @keys, @val ]

    remove_alias: (alias) ->
      @keys = (k for k in @keys when k != alias)
      
  constructor: ( vals ) ->

    @core = if vals && vals.shift
      ( (new @Element v) for v in vals )
    else if vals
      ( (new @Element k, v) for k, v of vals )
    else
      []

  pop: (pos) ->
    arr = if pos.toString() is 'first'
      @core.shift()
    else
      @core.pop()
      
    return arr unless arr
    arr.val

  push: (pos, v) ->
    e = ( new @Element v )
    if pos.toString() is 'first'
      @core.unshift e
    else
      @core.push e

  left: () ->
    @core[0] and @core[0].val

  right: () ->
    row = @core[@core.length - 1]
    row and row.val

  at_key: (k) ->
    v = ele.val for ele in @core when k in ele.keys
    v
    
  at_position: (n) ->
    comp_pos = @to_key_or_computer_position(n)
    @core[comp_pos] && @core[comp_pos].val

  has_key: (k) ->
    found = (v.keys for v in @core when k in v.keys)
    found.length > 0

  keys: () ->
    (ele.keys for ele in @core)
    
  values: () ->
    (v.val for v in @core)

  merge: (pos, o) ->
    new_core = if o && o.shift
      (new @Element( val)) for val in o
    else
      (new @Element( key,  val)) for key, val of o
      
    @core = if pos.toString() is "first"
      new_core.concat @core
    else
      @core.concat new_core

  to_key_or_computer_position: (key_or_human_pos) ->
    if typeof(key_or_human_pos) is 'number'
      return key_or_human_pos - 1
    key_or_human_pos

  get_computer_position: (key_or_human_pos) ->
    key_or_pos = @to_key_or_computer_position(key_or_human_pos)
    return key_or_pos unless key_or_pos
    pos = k for v, k in @core when (k is key_or_pos ) or ( key_or_pos in v.keys )
    pos

  get_computer_position_or_throw: (key_or_human_pos) ->
    pos  = @get_computer_position(key_or_human_pos)
    if !pos
      throw new Error("Key/pos is not defined: #{key_or_human_pos}")
    pos
    
  alias: (key_or_pos, nickname) ->
    pos = @get_computer_position_or_throw(key_or_pos)
    keys = @core[pos].keys
    return nickname if nickname in keys
    keys.push nickname
    
  remove_alias: (nickname) ->
    for ele in @core
      ele.remove_alias nickname
    nickname

  delete_at: (target_k) ->
    pos = @get_computer_position(target_k)
    row = @core[pos]
    return row unless row
    
    old = @at_position(pos)
    @core = (v for v,k in @core when k != pos)
    old


exports.Humane_List = Humane_List



