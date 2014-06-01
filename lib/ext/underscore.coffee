_ = require('underscore')

module.exports =
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
    _(list).chain().map (item) ->
      property = item[propertyName]
      if _(property).isArray()
        _(property).map (value) ->
          obj = {}
          obj[propertyName] = value
          _({}).extend(item, obj)
      else
        item
    .flatten().value()

  # This is a domain-specific higher-order function
  #
  # Say we have:
  #
  # [{iWant: "coffee", toBe: "removed"}]
  #
  # And we want all user-supplied tasks to be expanded into
  # fully qualified task-targets so that downstream behavior can
  # just trust that it will always get "coffee:foo" or "coffee:bar"
  #
  # If we had an array of known fully-qualified names like
  # ["coffee:src", "coffee:space"], then we could produce:
  #
  # [
  #   {iWant: "coffee:src", toBe: "removed"}
  #   {iWant: "coffee:spec", toBe: "removed"}
  # ]
  #
  # Just invoke `_(list).expandTasks("iWant", ["coffee:src", "coffee:space"])`
  expandTasks: (list, propertyName, knownTasks) ->
    _(list).chain().map (item) ->
      value = item[propertyName]
      if !value? || value.match(/\:/)
        item
      else
        _(knownTasks).chain().select (target) ->
          target.match(new RegExp("^#{value}:"))
        .map (target) ->
          obj = {}
          obj[propertyName] = target
          _({}).extend(item, obj)
        .value()
    .flatten().value()

  #
  # Say I have an array:
  # ["a", "b", "c"]
  #
  # And I want a new array with "a" after "b":
  # ["b", "a", "c"]
  #
  # I would invoke it _(["a","b","c"]).moveAfter("a", "b")
  moveAfter: (list, itemToMove, itemToMoveOtherOneAfter)->
    _(list).chain().clone()
      .without(itemToMove)
      .tap (list) ->
        list.splice(_(list).indexOf(itemToMoveOtherOneAfter)+1, 0, itemToMove)
      .value()
