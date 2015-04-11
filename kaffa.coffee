_ = require('underscore-plus')
{ ArrayObserver, PathObserver, ObjectObserver } = require('observe-js')
PropertyAccessors = require 'property-accessors'

exposeDef: (proto, def) ->
  PropertyAccessors.includeInto(proto)

  e = _.clone(def)
  proto._exposed = e

  if e.fn?
    proto[e.name] = e.fn
    e._args = e.fn.arguments
  else
    proto[e.name] = if e.value? then e.value else null
    if e.get? or e.set?
      proto.accessor e.name,
        get: e.get if e.get?
        set: e.set if e.set?

observers = []

module.exports =

  expose: (proto, def) ->
    if _.isArray(def)
      exposeDef(proto, d) for d in def
    else
      exposeDef(proto, def)

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

    observers.push observer

    return observer

  processObservers: ->
    for o in observers
      o.deliver()

  closeObservers: ->
    for o in observers
      o.close()

