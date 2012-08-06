
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
    @data = {}
    @data.core = []
    
    if vals && vals.shift
      @push('end', v) for v in vals
        
        
    else if vals
      @push('end', k, v) for k, v of vals
        
  pop: (pos) ->
    arr = if pos.toString() is 'front'
      @data.core.shift()
    else
      @data.core.pop()
      
    return arr unless arr
    arr.val

  push: () ->
    args = arguments
    pos = args[0]
    num_pos = if typeof(pos) is "number"
      pos
    else
      if pos is 'front'
        1
      else
        last = @positions().pop()
        (last && (last + 1)) || @data.core.length + 1

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
        
      
    # Insert new element at front.
    @data.core.unshift e
    
    # Sort based on human position.
    @data.core = @data.core.sort (a,b) ->
      a.pos > b.pos
      
    # Update positions.
    if @data.core.length > 1
      for last_v, i in @data.core
        v = @data.core[i+1]
        if v
          if last_v.pos >= v.pos
            v.pos += 1
      

    e.pos

  front: () ->
    @data.core[0] and @data.core[0].val

  end: () ->
    row = @data.core[@data.core.length - 1]
    row and row.val

  at_key: (k) ->
    v = ele.val for ele in @data.core when k in ele.keys
    v
    
  at_position: (n) ->
    comp_pos = @to_key_or_computer_position(n)
    @data.core[comp_pos] && @data.core[comp_pos].val

  has_key: (k) ->
    found = (v.keys for v in @data.core when k in v.keys)
    found.length > 0

  positions: () ->
    (v.pos for v in @data.core)

  keys: () ->
    (ele.keys for ele in @data.core)
    
  values: () ->
    (v.val for v in @data.core)

  concat: (pos, o) ->
    if o.shift
      positions = (i for v, i in o)
      positions = positions.reverse() if pos is 'front'
      @push(pos, o[i]) for i in positions
    else
      keys = (key for key, val of o)
      keys = keys.reverse() if pos is 'front'
      @push(pos, key, o[key]) for key in keys

  to_key_or_computer_position: (key_or_human_pos) ->
    if typeof(key_or_human_pos) is 'number'
      return key_or_human_pos - 1
    key_or_human_pos

  get_computer_position: (key_or_human_pos) ->
    key_or_pos = @to_key_or_computer_position(key_or_human_pos)
    return key_or_pos unless key_or_pos
    pos = k for v, k in @data.core when (k is key_or_pos ) or ( key_or_pos in v.keys )
    pos

  get_computer_position_or_throw: (key_or_human_pos) ->
    pos  = @get_computer_position(key_or_human_pos)
    if !pos
      throw new Error("Key/pos is not defined: #{key_or_human_pos}")
    pos
    
  alias: (key_or_pos, nickname) ->
    pos = @get_computer_position_or_throw(key_or_pos)
    keys = @data.core[pos].keys
    return nickname if nickname in keys
    keys.push nickname
    
  remove_alias: (nickname) ->
    for ele in @data.core
      ele.remove_alias nickname
    nickname

  delete_at: (target_k) ->
    pos = @get_computer_position(target_k)
    row = @data.core[pos]
    return row unless row
    
    old = @at_position(pos)
    @data.core = (v for v,k in @data.core when k != pos)
    old


exports.Humane_List = Humane_List



