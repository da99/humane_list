Position = require 'humane_list/lib/Position'

class Humane_List

  Element: class Element

    constructor: () ->

      @d = {}

      switch arguments.length

        when 1
          @d.keys = []
          @d.val = arguments[0]
        when 2
          @d.keys = arguments[0]
          @d.val  = arguments[1]
        when 3
          @d.pos  = arguments[0]
          @d.keys = arguments[1]
          @d.val  = arguments[2]
          
        else
          throw new Error("Unknown quantity of arguments: #{arguments}")
        
      @d.keys = if @d.keys.shift
        @d.keys
      else
        [@d.keys]

    keys: () ->
      @d.keys

    value: () ->
      @d.val

    position: () ->
      @d.pos

    update_position: (n) ->
      @d.pos = n

    to_array: () ->
      [ @d.keys, @d.val ]

    remove_alias: (alias) ->
      @d.keys = (k for k in @d.keys when k != alias)
      
  constructor: ( vals ) ->
    @d = {}
    @d.core = []

    if vals 
      if vals.shift
        @push('bottom', v) for v in vals
      else
        @push('bottom', k, v) for k, v of vals
        
  # =============== Navigation
  position: () ->
    @d.pos

  downward: () ->
    @to( @position() + 1 )
    
  upward: () ->
    @to( @position() - 1 )
    
  forward: this.prototype.downward
  backward: this.prototype.upward
  
  to: (n) ->
    if n < 1 and @length() > 0
      throw new Error("Position can't be, #{n}, because starting position is: 1.")
    if @length() is 0
      throw new Error("Position can't be, #{n}, because length is: #{@length()}.")
    if n > @length()
      throw new Error("Position can't be, #{n}, because length is: #{@length()}.")
    
    @d.pos = n

  to_top: () ->
    if @length() > 0
      @to 1
    else
      @to 0

  to_bottom: () ->
    @to @length()

  is_at_top: () ->
    @position() is 1

  is_at_bottom: () ->
    @position() is @length()

  value: () ->
    @at_position( @position() )

  next: () ->
    @at_position( @position() + 1 )

  previous: () ->
    @at_position( @position() - 1 )

  # ================ Create, Read, Update, Delete
  
  length: () ->
    @d.core.length
    
  keys: () ->
    @d.keys

  pop: (pos) ->
    ele = if pos.toString() is 'top'
      @d.core.shift()
    else
      @d.core.pop()
      
    return ele unless ele
    ele.value()

  push: () ->
    args = arguments
    pos = args[0]
    num_pos = if typeof(pos) is "number"
      pos
    else
      if pos is 'top'
        1
      else
        last = @positions().pop()
        (last && (last + 1)) || @d.core.length + 1

    # Create new element.
    switch args.length
      when 2
        e = if num_pos
          ( new @Element num_pos, [], args[1] )
        else
          ( new @Element args[1] )
          
      when 3
        e = if num_pos
          ( new @Element num_pos, args[1], args[2] )
        else
          ( new @Element args[1], args[2] )
          
      else
        throw( new Error("Invalid arguments: #{arguments}") )
        
      
    # Insert new element at top.
    @d.core.unshift e
    
    # Sort based on human position.
    @d.core = @d.core.sort (a,b) ->
      a.position() - b.position()
      
    # Update positions.
    if @d.core.length > 1
      for last_v, i in @d.core
        v = @d.core[i+1]
        if v
          if last_v.position() >= v.position()
            v.update_position( v.position() + 1 )
      

    if @length() > 0 and (@position() is 0 or @position() is undefined)
      @to(1)

    e.position()

  top: () ->
    @d.core[0] and @d.core[0].value()

  bottom: () ->
    row = @d.core[@d.core.length - 1]
    row and row.value()

  at_key: (k) ->
    v = ele.value() for ele in @d.core when k in ele.keys()
    v
    
  at_position: (n) ->
    comp_pos = @to_key_or_computer_position(n)
    @d.core[comp_pos] && @d.core[comp_pos].value()

  has_key: (k) ->
    found = (v.keys() for v in @d.core when k in v.keys())
    found.length > 0

  positions: () ->
    (v.position() for v in @d.core)

  keys: () ->
    (ele.keys() for ele in @d.core)
    
  values: () ->
    (v.value() for v in @d.core)

  concat: (pos, o) ->
    if o.shift
      positions = (i for v, i in o)
      positions = positions.reverse() if pos is 'top'
      @push(pos, o[i]) for i in positions
    else
      keys = (key for key, val of o)
      keys = keys.reverse() if pos is 'top'
      @push(pos, key, o[key]) for key in keys

  to_key_or_computer_position: (key_or_human_pos) ->
    if typeof(key_or_human_pos) is 'number'
      return key_or_human_pos - 1
    key_or_human_pos

  get_computer_position: (key_or_human_pos) ->
    key_or_pos = @to_key_or_computer_position(key_or_human_pos)
    return key_or_pos unless key_or_pos
    pos = k for v, k in @d.core when (k is key_or_pos ) or ( key_or_pos in v.keys() )
    pos

  get_computer_position_or_throw: (key_or_human_pos) ->
    pos  = @get_computer_position(key_or_human_pos)
    if !pos
      throw new Error("Key/pos is not defined: #{key_or_human_pos}")
    pos
    
  alias: (key_or_pos, nickname) ->
    pos = @get_computer_position_or_throw(key_or_pos)
    keys = @d.core[pos].keys()
    return nickname if nickname in keys
    keys.push nickname
    
  remove_alias: (nickname) ->
    for ele in @d.core
      ele.remove_alias nickname
    nickname

  delete_at: (target_k) ->
    pos = @get_computer_position(target_k)
    row = @d.core[pos]
    return row unless row
    
    old = @at_position(pos)
    @d.core = (v for v,k in @d.core when k != pos)
    old


module.exports = Humane_List
module.exports.Humane_List = Humane_List
module.exports.Position = Position


