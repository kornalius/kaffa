_ = require('underscore-plus')
_.extend(_, require('underscore-contrib'))
_.array = require('underscore.array')
{ o, Base } = require('./base.coffee')
{ Class } = require('./kaffa.coffee')

List = Class 'List',
  extends: Base

  constructor: (value = []) ->
    if _.isFunction(value) and value instanceof List
      @super(_.clone(value.value))
    else
      @super(_.clone(value))

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


module.exports =

  List: List

  l: (value) -> new List(value)
