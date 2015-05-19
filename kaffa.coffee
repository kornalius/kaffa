_ = require('underscore-plus')
{ ArrayObserver, PathObserver, ObjectObserver } = require('observe-js')
raf = require('raf')

_classes = []
_observers = []
_delivering = false


raf _deliverChanges = ->
  _delivering = true
  for o in _observers
    o.deliver()
  _delivering = false
  raf(_deliverChanges)


_isEvent = (name) ->
  name.startsWith('@')


_classify = (name) ->
  _.capitalize(_.camelize(name))


ctor = (name, fn) ->
  if !name? or fn.name == name
    return fn
  try
    func = Function('fn', 'return function ' + name + '() { return fn.apply(this, arguments); }')(fn)
  catch err
    try
      func = Function('fn', 'return function ' + name + '_() { return fn.apply(this, arguments); }')(fn)
    catch err
      return fn
  return func


superWrapper = (fn, superFn) ->
  () ->
    r = null
    tmp = @super
    @super = if superFn? then superFn.bind(@) else null
    r = fn.apply(@, arguments)
    @super = tmp
    # console.log "SUPER CALL", fn, "->", superFn
    return r


Class = (name, def) ->
  parent = if def.extends? then def.extends else ->

  if def.hasOwnProperty('constructor')
    fn = def.constructor
  else if parent?
    fn = -> parent.apply(@, arguments)
  else
    fn = ->

  child = ctor(name, superWrapper(fn, parent))

  for k, v of parent
    if parent.hasOwnProperty(k)
      child[k] = v

  if def.static?
    for k, v of def.static
      child[k] = v

  child.prototype = Object.create(parent.prototype,
    constructor:
      value: child
      enumerable: false
      writable: true
      configurable: true
  )

  child.prototype._superclass = parent.prototype

  if def.with?
    for m in def.with
      for k, v of m.prototype
        if !(k in ['extends', 'with', 'static', 'constructor'])
          if def[k]?
            def[k + '.' + _classify(m.name)] = v
          else
            def[k] = v
      if m.prototype.load?
        m.prototype.load.call(@, def, child.prototype)
    child.prototype._mixins = _.clone(def.with)

  for k, v of def
    if !(k in ['extends', 'with', 'static', 'constructor'])
      if !_isEvent(k) and _.isFunction(v) and _.isFunction(parent?.prototype[k])
        child.prototype[k] = ctor(k, superWrapper(v, parent.prototype[k]))
      else
        child.prototype[k] = v

  _classes.push(child)

  return child


module.exports =

  Class: Class
  ctor: ctor
  observers: _observers
  classes: _classes

  observe: (obj, path, fn) ->
    if path?
      observer = new PathObserver(obj, path)
      observer.open (newValue, oldValue) ->
        console.log "OBSERVE: #{path} changed from #{oldValue} to #{newValue}"
        fn.call(obj, {observer: observer, path: path, newValue: newValue, oldValue: oldValue}) if fn?

    else if _.isArray(obj)
      observer = new ArrayObserver(obj)
      observer.open (splices) ->
        for splice in splices
          if splice.removed?
            console.log "OBSERVE: #{cson.stringify(removed)} removed at #{splice.index}"
          else
            console.log "OBSERVE: #{cson.stringify(obj.slice(splice.index, splice.addedCount))} added at #{splice.index}"
          fn.call(obj, {observer: observer, path: path, slices: splices}) if fn?

    else if _.isObject(obj) and _.keys(obj).length
      observer = new ObjectObserver(obj)
      observer.open (added, removed, changed, getOldValueFn) ->
        for k, v of added
          console.log "OBSERVE: #{k} = #{v} added"
        for k, v of removed
          console.log "OBSERVE: #{k} removed (#{getOldValueFn(k)})"
        for k, v of changed
          console.log "OBSERVE: #{k} = #{v} changed (#{getOldValueFn(k)})"
        fn.call(obj, {observer: observer, path: path, added: added, removed: removed, changed: changed, getOldValueFn: getOldValueFn}) if fn?

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
