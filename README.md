
humane\_list
============

Combining arrays with kv structures.  It is meant to act the 
way non-programmers (ie humans) expect lists to act (ie usability).

* There is no 0 index.
* This is no `shift` or `unshift`.
* `.pop\_top()` and `.insert\_top()` is for the top. 
* `.pop\_end()` and `.insert\_end()` is for the end of the list.
* `.first()` and `.last()` are there. For now, they accept 
  *no* arguments.

Usage: Inserting
=====

    var ha = require('humane_list');
    var stuff = new ha.Humane_List();
    stuff.insert_end( "red" );
    stuff.insert_end( "blue" );
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

    stuff.insert(  15, "green" );
    stuff.has_key( 15 );
    // => true

    stuff.has_key( 14 );
    // => false, because we never set anything index 14.

Usage: Deleting
=============

    stuff.delete( "fire_color");
    stuff.delete( 2 ); 
    // This deletes value at index 2.

No shift or unshift.

    stuff.pop_top();
    // => "red"
    
    stuff.insert_top( "red" );
    // => "red"
    

Installation
============

    npm install humane_list


