
humane\_list
============

Combining arrays with kv structures.  It is meant to act the 
way non-programmers (ie humans) expect lists to act (ie usability). Think of
shopping lists: top to bottom.

* Default index is 1, not 0.
* This is no `shift` or `unshift`.
* `.pop( 'top' )` and `.push('top', vals)` to attach before first element. 
* `.pop( 'bottom'  )`  and `.push('bottom',  vals)` to pop/insert after last element.
* `.top()` and `.bottom()` instead of `.first()` and `.last()`
* Instead of index, you have positions. 
  * Why?! Because non-programmers might confuse keys with indexes.  Think of a 
    book with an index.

Installation and Usage
=====

On your shell:

    npm install humane_list

In your script:

    var hl = require('humane_list');
    var empty   = new hl();
    var w_array = new hl( [1,2,3] );
    var w_obj   = new hl( { one: 1, two: 2, three: 3 } );


Usage: Inserting
=====

    stuff.push( "bottom", "red" );
    stuff.push( "bottom", "blue" );
    stuff.bottom(); 
    // => "blue"
    
Remember, index starts with 1, not 0.

    stuff.alias( 1, "favorite" );
    stuff.alias( "favorite", "fire_color" );
    stuff.at_key( "favorite" );
    // => "red"
    
    stuff.at_key( "fire_color" );
    // => "red"

Usage: Inspect
================

    stuff.has_key( "favorite" );
    // => true

    stuff.positions();
    // => [ 1, 2 ]

    stuff.keys();
    // => [ ['favorite', 'fire_color'], [] ]
    
    stuff.values();
    // => [ 'red', 'blue' ]


Usage: Deleting
=============

    stuff.delete_at( "fire_color");
    stuff.delete_at( 2 ); 
    // This deletes value at index 2.

No shift or unshift.

    stuff.pop('top');
    // => "red"
    
    stuff.push( 'top', "red" );
    // => "red"
    




