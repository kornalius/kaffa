_ = require('underscore-plus')
_.extend(_, require('underscore.string').exports())
{ Class } = require('./kaffa.coffee')

{ o, Base } = require('./base.coffee')
{ n, Numeric } = require('./numeric.coffee')
{ l, List } = require('./list.coffee')

Text = Class 'Text',
  extends: Base

  static:
    join: (separator, args...) ->
      t _.join(separator, args...)

    fromCharCode: (code) ->
      t String.fromCharCode(code)

    fromCodePoint: (code) ->
      t String.fromCodePoint(code)

  constructor: (value = '') ->
    if _.isFunction(value) and value instanceof Text
      @super(value.value)
    else if _.isString(value)
      @super(value)
    else
      @super(_.toString(value))

  camelize: ->
    t _.camelize(@value)

  capitalize: ->
    t _.capitalize(@value)

  charAt: (i) ->
    t @value.charAt(i)

  charCodeAt: (i) ->
    n @value.charCodeAt(i)

  charCodePointAt: (i) ->
    n @value.charCodePointAt(i)

  chars: ->
    l _.chars(@value)

  chop: (step) ->
    l _.chop(@value, step)

  classify: ->
    t _.classify(@value)

  clean: ->
    t _.clean(@value)

  concat: (str) ->
    n @value.concat(str)

  count: (substr) ->
    n _.count(@value, substr)

  dasherize: ->
    t _.dasherize(@value)

  decapitalize: ->
    t _.uncapitalize(@value)

  dedent: (pattern) ->
    t _.dedent(@value, pattern)

  endsWith: (substr) ->
    t _.endsWith(@value, substr)

  escapeAttribute: ->
    t _.escapeAttribute(@value)

  escapeHTML: ->
    t _.escapeHTML(@value)

  escapeRegExp: ->
    t _.escapeRegExp(@value)

  humanize: ->
    t _.humanize(@value)

  includes: (substr) ->
    t @value.includes(substr)

  indexOf: (str) ->
    n @value.indexOf(str)

  insert: (i, substr) ->
    t _.insert(@value, i, substr)

  isBlank: ->
    t _.isBlank(@value)

  lastIndexOf: (str) ->
    n @value.lastIndexOf(str)

  length: ->
    n @value.length

  levenshtein: (str) ->
    n _.levenshtein(@value, str)

  lines: ->
    l _.lines(@value)

  lower: ->
    t @value.toLowerCase()

  lpad: (length, padstr) ->
    t _.lpad(@value, length, padstr)

  lrpad: (length, padstr) ->
    t _.lrpad(@value, length, padstr)

  ltrim: (characters) ->
    t _.ltrim(@value, characters)

  multiply: (n) ->
    t _.multiplyString(@value, n)

  naturalCmp: (str) ->
    n _.naturalCmp(@value, str)

  pad: (length, padstr, type) ->
    t _.pad(@value, length, padstr, type)

  pluralize: ->
    t _.pluralize(@value)

  replace: (find, replace, ignorecase) ->
    t @value.replace(find, replace, (if ignorecase then 'i' else ''))

  replaceAll: (find, replace, ignorecase) ->
    t _.replaceAll(@value, find, replace, ignorecase)

  reverse: ->
    t @value.reverse()

  rpad: (length, padstr) ->
    t _.rpad(@value, length, padstr)

  rtrim: (characters) ->
    t _.rtrim(@value, characters)

  slugify: ->
    t _.slugify(@value)

  split: (delimiter) ->
    l @value.split(delimiter)

  sprintf: (fmt, args...) ->
    t _.sprintf(@value, fmt, args...)

  startWith: (substr) ->
    t _.startWith(@value, substr)

  substr: (start, length) ->
    t @value.substr(start, length)

  substring: (start, end) ->
    t @value.substring(start, end)

  surround: (wrapper) ->
    t _.surround(@value, wrapper)

  swapCase: ->
    t _.swapCase(@value)

  template: (data, settings) ->
    t _.template(@value, data, settings)

  titleize: ->
    t _.titleize(@value)

  trim: (characters) ->
    t _.trim(@value, characters)

  truncate: (length, truncate_str) ->
    t _.truncate(@value, length, truncate_str)

  uncamelcase: ->
    t _.uncamelcase(@value)

  undasherize: ->
    t _.undasherize(@value)

  unescapeHTML: ->
    t _.unescapeHTML(@value)

  underscore: ->
    t _.underscore(@value)

  unsurround: (wrapper) ->
    if @value[0...wrapper.length] == wrapper and @value[-wrapper.length] == wrapper
      t @value[wrapper.length...@value.length - wrapper.length]
    else
      @

  upper: ->
    t @value.toUpperCase()

  words: ->
    l _.words(@value)


module.exports =

  Text: Text

  t: (value) -> new Text(value)

