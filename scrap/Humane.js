var hl = require("humane_list").Humane_List;


var j = function (){

  this.forward_able = { all: true }
  
  this.on_init = function () {
    this._v_ = ["a"];
    return  this._v_;
  }
  
  this.vals = function() {
    return this._v_;
  }
  
  this.values = function() {
    return this.vals();
  }

};

var k = function () {

  this.forward_able = { all: true }
  this.keys = function () {
    if (!this._keys_)
      this._keys_ = ["k"];
    return this._keys_;
  };


};

var l = function () {
  
  this.forward_able = { all: true }
  this.leys = function () {
    if (!this._leys_)
      this._leys_ = ["l"];
    return this._leys_;
  };




};

function test_new (func) {
  var i = 0
    var start = new Date().getTime();
  while (i < 10000) {

    func()
    ++i;
    
  // if (i % 1000000 == 0)
    // console.log(i);
      
    
  };
  var elapsed = new Date().getTime() - start;
  console.log(elapsed);
}


Send_Message = function (obj, name) {
  
  if (obj.hasOwnProperty(name))
    return obj[name]();
  
  var i = obj.Nouns.length;
  while( --i > -1 ) {
    var o = obj.Nouns[i];
    if (o[name] && o.forward_able.all)
      return obj["Nouns"][i][name]();
  }
  
  
  throw(new Error("Unknown: "+ name))
}

New_Obj = function (o) {
  var obj = new o()
  if ( obj.on_init )
    obj.on_init()
  return obj
}

test_new( function () {
    
  var a = { "Nouns": [ New_Obj(j), New_Obj(k), New_Obj(l)], "yo": function() { return "hi"} }

  Send_Message( a, 'yo'  );
  Send_Message( a, 'values'  );
  Send_Message( a, 'keys'  );
  Send_Message( a, 'leys'  );
  
});

test_new( function () {
  var l = new hl([1,2,3]);
  l.values();
  l.has_key("2");
  l.at_position(2);
});
// test_new( function () {
  
    // var a = Object.create(h.prototype, j)
    // a.on_init();
    // a.values()

// } );


    // var a = Object.create(j);
    // a.on_init();
    // console.log(a.values());

    
    
    
    
