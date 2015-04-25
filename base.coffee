_ = require('underscore-plus')
cson = require('cson-parser')

o = (value) ->
  new Base(value)

module.exports =

  o: o

  Base: class Base
    constructor: (@value = null) ->

    @cast: (value) ->
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

