_ = require('underscore-plus')
{ o, Base } = require('./base.coffee')

l = (value) ->
  new Numeric(value)

module.exports =

  l: l

  List: class List extends Base
    constructor: (value = []) ->
      if value instanceof List
        super(_.clone(value.value))
      else
        super(_.clone(value))

    push: (args...) ->
      for a in args
        if _.isArray(a)
          for i in a
            @push(i)
        else
          o = Base.cast(a)
          if !(o instanceof Base)
            throw "List type only accepts Base classes"
          value.push(o)

    pull: ->
      @value.unshift()

    each: (fn) ->
      _.each(@value, fn)
      @

    map: (fn) ->
      _.each(@value, fn)
      l _.map(@value, fn)

    join: (separator) ->
      t @value.join(separator)

    sum: ->
      r = 0
      @each (v) -> r += v.toNumeric()
      n r

    avg: ->
      r = 0
      @each (v) -> r += v.toNumeric()
      n r
