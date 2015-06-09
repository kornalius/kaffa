_ = require('underscore-plus')
_.extend(_, require('underscore-contrib'))
moment = require('moment')
{ o, Base } = require('./base.coffee')
{ Class } = require('./kaffa.coffee')

DateTime = Class 'DateTime',
  extends: Base

  constructor: (value = false) ->
    console.log "DateTime.constructor", value
    if _.isFunction(value) and value instanceof DateTime
      @super(value.value)
    else if _.isDate(value)
      @super(value)
    else if _.isString(value)
      @super(_.toBoolean(value))
    else
      @super(false)


module.exports =

  DateTime: DateTime

  d: (value) -> new DateTime(value)
