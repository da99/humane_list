
rw = require 'rw_ize'
forward = require 'forward_these_functions'
_  = require 'underscore'

class Position

  rw.ize(this)
  forward @prototype, "list"

  @read_able 'list', 'position'

  constructor: ( list ) ->
    @rw_data 'list', list
    @rw_data 'position', @list().first_position()

  value: () ->
    @list().at_position( @position() )
    
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
    if @position() is @list().last_position()
      throw new Error("Position already at end: #{@position()}.")
    @to @list().position_after( @position() )
    
  upward: () ->
    prev = @list().position_before( @position() )
    if not _.isNumber(prev)
      throw new Error("No valid position before: #{@position()}.")
    @to prev
    
  next: () ->
    next = @list().position_after( @position() ) 
    if not _.isNumber(next)
      throw new Error "No valid position after: #{@position()}."
    @list().at_position next

  previous: () ->
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


module.exports = Position
