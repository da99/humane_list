
rw = require 'rw_ize'
forward = require 'forward_these_functions'

class Position

  rw.ize(this)
  forward @prototype, "list"

  @read_able 'list', 'position'

  constructor: ( list ) ->
    @rw_data 'list', list
    if @list().is_empty()
      @rw_data 'position', 0
    else
      @rw_data 'position', 1

  is_a_position: () ->
    true

  is_at_top: () ->
    if @list().is_empty()
      @position() is 0
    else
      @position() is 1

  is_at_bottom: () ->
    if @list().is_empty()
      @position() is 0
    else 
      @position() is @list().last_position()

  downward: ( list ) ->
    return @value() if @position() is @list().last_position()
    @rw_data 'position', @list().position_after( @position() )
    @value()

  forward: @prototype.downwward
  backward: @prototype.upward


module.exports = Position
