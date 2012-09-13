
class Element

  constructor: () ->

    @d = {}

    switch arguments.length

      when 1
        @d.keys = []
        @d.val = arguments[0]
      when 2
        @d.keys = arguments[0]
        @d.val  = arguments[1]
      when 3
        @d.pos  = arguments[0]
        @d.keys = arguments[1]
        @d.val  = arguments[2]
        
      else
        throw new Error("Unknown quantity of arguments: #{arguments}")
      
    @d.keys = if @d.keys.shift
      @d.keys
    else
      [@d.keys]

  keys: () ->
    @d.keys

  value: () ->
    @d.val

  position: () ->
    @d.pos

  update_position: (n) ->
    @d.pos = n

  to_array: () ->
    [ @d.keys, @d.val ]

  remove_alias: (alias) ->
    @d.keys = (k for k in @d.keys when k != alias)
    
    
    
    
module.exports = Element
