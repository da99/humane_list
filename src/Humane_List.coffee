Position = require 'humane_list/lib/Position'
Element  = require "humane_list/lib/Element"
_        = require "underscore"

class Humane_List

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
    new Position(this)

  position_after: (n) ->
    _.find @positions(), (p) ->
      p > n

  position_before: (n) ->
    _.find @positions().reverse(), (p) ->
      p < n

  first_position: (n) ->

  first_position: () ->
    return 0 if @is_empty()
    _.first( @d.core ).position()

  last_position: () ->
    return 0 if @is_empty()
    _.last( @d.core ).position()

  is_empty: () -> 
    @d.core.length is 0

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
    num_pos = if _.isNumber(pos) 
      pos
    else
      if pos is 'top'
        if @is_empty() 
          1
        else
          @first_position() - 1

      else if pos is 'bottom'
        last = @positions().pop()
        (last && (last + 1)) || @d.core.length + 1
      else
        throw new Error "Unknown position: #{pos}"

    # Create new element.
    switch args.length
      when 2
        e = ( new Element num_pos, [], args[1] )
          
      when 3
        e = ( new Element num_pos, args[1], args[2] )
          
      else
        throw( new Error("Invalid arguments: #{arguments}") )
        
      
    # Insert new element at top.
    if pos is 'bottom'
      @d.core.push e
    else
      @d.core.unshift e
    
    # Sort based on human position.
    @d.core = @d.core.sort (a,b) ->
      a.position() - b.position()
      
    # Update positions.
    if @d.core.length > 1
      for v, i in @d.core
        next_v = @d.core[i+1]
        if next_v
          if v.position() >= next_v.position()
            next_v.update_position( next_v.position() + 1 )
      


  # =============================================
  #               Inspecting keys
  # =============================================
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



