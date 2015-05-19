_ = require('underscore-plus')
{ o, Base } = require('./base.coffee')
{ Class } = require('./kaffa.coffee')

Bool = Class 'Bool',
  extends: Base

  constructor: (value = false) ->
    console.log "Bool.constructor", value
    if _.isFunction(value) and value instanceof Bool
      @super(value.value)
    else if _.isBoolean(value)
      @super(value)
    else if _.isString(value)
      @super(_.toBoolean(value))
    else
      @super(false)

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


module.exports =

  Bool: Bool

  b: (value) -> new Bool(value)
