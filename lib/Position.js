
var rw = require('rw_ize'),
    forward = require('forward_these_functions'),
    _ = require('underscore');

var Position = function (list) {
  
  this.rw('list', list);
  
  if (this.list().is_empty())
    this.rw('position', this.list().first_position() );
  
  else
    this.to( this.list().first_position() );
  
};

rw.ize(Position);
forward(Position.prototype, "list");

Position.read_able('list', 'position', 'object_id_at_position');

Position.prototype.value = function () {
  this.throw_if_position_has_changed() ;
  return this.list().at_position( this.position() ) ;
}; 

Position.prototype.throw_if_position_has_changed = function () {
  if ( unless _.isNumber( this.object_id_at_position() ) )
    return null ;

  pos_desc = this.list().describe_position( this.position() ) ;
  id_desc  = this.list().describe_object_id( this.object_id_at_position() ) ;
  if ( ! ( pos_desc.object_id is this.object_id_at_position() ) )
    throw new Error("Position of element has changed from " + 
        this.position().toStrint() + 
        " to " + 
        id_desc.position.toString() 
        );

};

  // ===============================
  //          Questions 
  // ===============================
    
  is_at_top: () ->
    this.position() is this.list().first_position()

  is_at_bottom: () ->
    this.position() is this.list().last_position()
    
  // ===============================
  //          Increments of 1
  // ===============================
  
  downward: () ->
    this.throw_if_position_has_changed() 
      
    if this.position() is this.list().last_position()
      throw new Error("Position already at end: #{this.position()}.")
    this.to this.list().position_after( this.position() )
    
  upward: () ->
    this.throw_if_position_has_changed() 
    
    prev = this.list().position_before( this.position() )
    if not _.isNumber(prev)
      throw new Error("No valid position before: #{this.position()}.")
    this.to prev
    
  next: () ->
    this.throw_if_position_has_changed() 
    
    next = this.list().position_after( this.position() ) 
    if not _.isNumber(next)
      throw new Error "No valid position after: #{this.position()}."
    this.list().at_position next

  previous: () ->
    this.throw_if_position_has_changed() 
    
    prev = this.list().position_before( this.position() )
    if not _.isNumber(prev)
      throw new Error "No valid position before: #{this.position()}."
    this.list().at_position prev
    
  // ===============================
  //          Leaping
  // ===============================
  
  to_top: () ->
    this.to this.list().first_position()
      
  to_bottom: () ->
    this.to this.list().last_position()
  
  to: (n) ->
    if n < this.list().first_position()
      throw new Error("Position can't be, #{n}, because starting position is: #{this.list().first_position()}.")
    if this.list().is_empty() and n isnt 0
      throw new Error("Position can't be, #{n}, because length is: #{this.list().length()}.")
    if n > this.list().last_position()
      throw new Error("Position can't be, #{n}, because length is: #{this.list().length()}.")
    
    this.rw 'position', n
    if not this.list().is_empty()
      this.rw 'object_id_at_position', (this.list().describe_position(n)).object_id 


module.exports = Position
