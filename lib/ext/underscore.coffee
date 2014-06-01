_ = require('underscore')

_.mixin
  # This guy is a little nutty.
  # Say you have this:
  # [
  #   foo:
  #     bar: ["a", "b"]
  # ]
  # And what you want is:
  # [
  #     foo:
  #       bar: "a"
  #   ,
  #     foo:
  #       bar: "b"
  # ]
  #
  # Then you would call `_(list).unzipProperty("bar")`
  unzipProperty: (list, propertyName) ->
    _(list).chain().map (r) ->
      property = r[propertyName]
      if _(property).isArray()
        _(property).map (value) ->
          obj = {}
          obj[propertyName] = value
          _({}).extend(r, obj)
      else
        r
    .flatten().value()
