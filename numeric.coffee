_ = require('underscore-plus')
{ o, Base } = require('./base.coffee')
{ Class } = require('./kaffa.coffee')

Numeric = Class 'Numeric',
  extends: Base

  constructor: (value = 0) ->
    if _.isFunction(value) and value instanceof Numeric
      @super(value.value)
    else if _.isNumber(value)
      @super(value)
    else if _.isString(value)
      @super(_.toNumber(value))
    else
      @super(0)

  add: (args...) ->
    r = @value
    r += a for a in args
    n r

  sub: (args...) ->
    r = @value
    r -= a for a in args
    n r

  mul: (args...) ->
    r = @value
    r *= a for a in args
    n r

  div: (args...) ->
    r = @value
    r /= a for a in args
    n r


module.exports =

  Numeric: Numeric

  n: (value) -> new Numeric(value)

