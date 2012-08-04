
humane\_list
============

Combining arrays with kv structures.  It is meant to act the 
way non-programmers (ie humans) expect lists to act (ie usability).

* There is no 0 index.
* This is no `shift` or `unshift`.
* `.pop( 'first' )` and `.push('first', vals)` to attach before first element. 
* `.pop( 'last'  )` and `.push('last',  vals)` to pop/insert after last element.
* `.first()` and `.last()` are there. For now, they accept 
  *no* arguments.

Usage: Inserting
=====

    var ha = require('humane_list');
    var stuff = new ha.Humane_List();
    stuff.push( "last", "red" );
    stuff.push( "last", "blue" );
    stuff.last(); 
    // => "blue"
    
Remember, index starts with 1, not 0.

    stuff.alias( 1, "favorite" );
    stuff.alias( "favorite", "fire_color" );
    stuff.get( "favorite" );
    // => "red"
    
    stuff.get( "fire_color" );
    // => "red"

Usage: Investigatations
================

    stuff.has_key( "favorite" );
    // => true


Usage: Deleting
=============

    stuff.delete( "fire_color");
    stuff.delete( 2 ); 
    // This deletes value at index 2.

No shift or unshift.

    stuff.pop('first');
    // => "red"
    
    stuff.insert( 'first', "red" );
    // => "red"
    

Installation
============

    npm install humane_list


