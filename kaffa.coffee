_ = require('underscore-plus')
{ ArrayObserver, PathObserver, ObjectObserver } = require('observe-js')
PropertyAccessors = require 'property-accessors'
raf = require('raf')

_observers = []

raf _deliverChanges = ->
  for o in _observers
    o.deliver()
  raf(_deliverChanges)

exposeDef = (o, name, def) ->
  PropertyAccessors.includeInto(o)

  e = _.clone(def)
  if !o._exposed?
    o._exposed = {}
  o._exposed[name] = e

  if e.fn?
    o::[name] = e.fn
    e._args = e.fn.arguments
  else
    o::[name] = if e.value? then e.value else null
    if e.get? or e.set?
      o.accessor name,
        get: e.get if e.get?
        set: e.set if e.set?

unexposeDef = (o, name) ->
  if o._exposed?
    e = o._exposed[name]

    if e.fn?
      delete o::[name]
    else
      delete o::[name]
      # if e.get? or e.set?
      #   o.accessor name,
      #     get: e.get if e.get?
      #     set: e.set if e.set?

    delete o._exposed[name]

    if _.keys(o._exposed).length == 0
      delete o._exposed


module.exports =

  observers: _observers

  expose: (o, name, def) ->
    if _.isObject(name)
      exposeDef(o, k, v) for k, v of name
    else
      exposeDef(o, name, def)

  unexpose: (o, name) ->
    if _.isObject(name)
      unexposeDef(o, k) for k of name
    else
      unexposeDef(o, name)

  observe: (obj, path) ->
    if path?
      observer = new PathObserver(obj, path)
      observer.open (newValue, oldValue) ->
        console.log "OBSERVE: #{path} changed from #{oldValue} to #{newValue}"

    else if _.isArray(obj)
      observer = new ArrayObserver(obj)
      observer.open (splices) ->
        for splice in splices
          if splice.removed?
            console.log "OBSERVE: #{cson.stringify(removed)} removed at #{splice.index}"
          else
            console.log "OBSERVE: #{cson.stringify(obj.slice(splice.index, splice.addedCount))} added at #{splice.index}"

    else if _.isObject(obj) and _.keys(obj).length
      observer = new ObjectObserver(obj)
      observer.open (added, removed, changed, getOldValueFn) ->
        for k, v of added
          console.log "OBSERVE: #{k} = #{v} added"
        for k, v of removed
          console.log "OBSERVE: #{k} removed (#{getOldValueFn(k)})"
        for k, v of changed
          console.log "OBSERVE: #{k} = #{v} changed (#{getOldValueFn(k)})"

    _observers.push observer

    return observer

  shutKaffa: ->
    for o in _observers
      o.close()

_.extend module.exports,
  require('./base.coffee')
  require('./bool.coffee')
  require('./numeric.coffee')
  require('./text.coffee')
  require('./list.coffee')
