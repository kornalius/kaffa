_ = require('underscore-plus')
_.extend(_, require('underscore-contrib'))
_.is = require('is')
cson = require('cson-parser')
{ Class } = require('./kaffa.coffee')

Base = Class 'Base',

  static:
    cast: (value) ->
      if _.isNumber(value)
        { n } = require('./numeric.coffee')
        n value
      else if _.isBoolean(value)
        { b } = require('./bool.coffee')
        b value
      else if _.isString(value)
        { t } = require('./text.coffee')
        t value
      else if _.isArray(value)
        { l } = require('./list.coffee')
        l value
      else
        o value

  constructor: (value = null) ->
    @value = value
    console.log "Base.constructor", @

  toBool: ->
    { b } = require('./bool.coffee')
    b @value

  toNumeric: ->
    { n } = require('./numeric.coffee')
    n @value

  toList: ->
    { l } = require('./list.coffee')
    l @value

  toText: ->
    { t } = require('./text.coffee')
    t @value

  parse: (value) ->
    @value = cson.parse(value)

  stringify: ->
    @toString()

  toString: ->
    cson.stringify(_.toString(@value))


module.exports =

  Base: Base

  o: (value) -> new Base(value)
