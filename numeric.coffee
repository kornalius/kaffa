_ = require('underscore-plus')
{ o, Base } = require('./base.coffee')

n = (value) ->
  new Numeric(value)

module.exports =

  n: n

  Numeric: class Numeric extends Base
    constructor: (value = 0) ->
      if value instanceof Numeric
        super(value.value)
      else
        super(_.toNumber(value))

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
