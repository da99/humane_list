
rw = require 'rw_ize'
forward = require 'forward_these_functions'
_  = require 'underscore'

class Position

  rw.ize(this)
  forward @prototype, "list"

  @read_able 'list', 'position', 'object_id_at_position'

  constructor: ( list ) ->
    @rw_data 'list', list
    if @list().is_empty()
      @rw_data 'position', @list().first_position()
    else
      @to @list().first_position()

  value: () ->
    @throw_if_position_has_changed() 
    @list().at_position( @position() )
    
  throw_if_position_has_changed: () ->
    return null unless _.isNumber( @object_id_at_position() )
    pos_desc = @list().describe_position( @position() )
    id_desc  = @list().describe_object_id( @object_id_at_position() )
    if not ( pos_desc.object_id is @object_id_at_position() )
      throw new Error "Position of element has changed from #{@position()} to #{id_desc.position}"

  # ===============================
  #          Questions 
  # ===============================
    
  is_at_top: () ->
    @position() is @list().first_position()

  is_at_bottom: () ->
    @position() is @list().last_position()
    
  # ===============================
  #          Increments of 1
  # ===============================
  
  downward: () ->
    @throw_if_position_has_changed() 
      
    if @position() is @list().last_position()
      throw new Error("Position already at end: #{@position()}.")
    @to @list().position_after( @position() )
    
  upward: () ->
    @throw_if_position_has_changed() 
    
    prev = @list().position_before( @position() )
    if not _.isNumber(prev)
      throw new Error("No valid position before: #{@position()}.")
    @to prev
    
  next: () ->
    @throw_if_position_has_changed() 
    
    next = @list().position_after( @position() ) 
    if not _.isNumber(next)
      throw new Error "No valid position after: #{@position()}."
    @list().at_position next

  previous: () ->
    @throw_if_position_has_changed() 
    
    prev = @list().position_before( @position() )
    if not _.isNumber(prev)
      throw new Error "No valid position before: #{@position()}."
    @list().at_position prev
    
  # ===============================
  #          Leaping
  # ===============================
  
  to_top: () ->
    @to @list().first_position()
      
  to_bottom: () ->
    @to @list().last_position()
  
  to: (n) ->
    if n < @list().first_position()
      throw new Error("Position can't be, #{n}, because starting position is: #{@list().first_position()}.")
    if @list().is_empty() and n isnt 0
      throw new Error("Position can't be, #{n}, because length is: #{@list().length()}.")
    if n > @list().last_position()
      throw new Error("Position can't be, #{n}, because length is: #{@list().length()}.")
    
    @rw_data 'position', n
    if not @list().is_empty()
      @rw_data 'object_id_at_position', (@list().describe_position(n)).object_id 


module.exports = Position
