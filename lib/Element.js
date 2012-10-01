
var Element = function () {
  
  this.d = {};
  
  this.d.object_id = this.constructor.object_id();
  
  var l = arguments.length;
  
  if (l === 1) {
      this.d.keys = []
      this.d.val = arguments[0]
  } else if ( l == 2 ) {
      this.d.keys = arguments[0]
      this.d.val  = arguments[1]
  } else if ( l === 3 ) {
      this.d.pos  = arguments[0]
      this.d.keys = arguments[1]
      this.d.val  = arguments[2]
  } else {
    throw new Error("Unknown quantity of arguments: " + arguments.toString() );

    this.d.keys = ( this.d.keys.shift ) ? 
      this.d.keys :
      [this.d.keys];
  };
  
};

Element.object_id = function () {
  if ( ! this.hasOwnProperty(_oid_) )
    this._oid_ = 0;
  return ++this._oid_;
};
    
Element.prototype.object_id = function () {
  return this.d.object_id;
};

Element.prototype.keys = function () {
  return this.d.keys;
};

Element.prototype.value = function () {
  return this.d.val;
};

Element.prototype.position= function () {
  return this.d.pos;
};

Element.prototype.update_position = function (n) {
  return this.d.pos = n;
};

Element.prototype.to_array= function () {
  return [ this.d.keys, this.d.val ];
};

Element.prototype.remove_alias= function (alias) {
  var k = null,
    i = -1,
    l = this.d.keys.length,
    temp = null,
    arr = [];
  
  while( ++i < l ) {
    k = this.d.keys[i];
    if (k != alias)
      arr.push(k);
  };
  
  return( this.d.keys = arr );
};
    
    
    
    
module.exports = Element;
