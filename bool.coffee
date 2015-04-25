_ = require('underscore-plus')
{ o, Base } = require('./base.coffee')

b = (value) ->
  new Bool(value)

module.exports =

  b: b

  Bool: class Bool extends Base
    constructor: (value = false) ->
      if value instanceof Bool
        super(value.value)
      else
        super(_.toBoolean(value))

    not: ->
      b !@value

    or: (args...) ->
      r = @value
      for a in args
        r = r or _.toBoolean(a)
      b r

    xor: (args...) ->
      r = @value
      for a in args
        r = r ^ _.toBoolean(a)
      b r


    and: (args...) ->
      r = @value
      for a in args
        r = r and _.toBoolean(a)
      b r

