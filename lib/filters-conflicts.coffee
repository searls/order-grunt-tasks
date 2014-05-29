_ = require('underscore')

module.exports =
  filter: (previousRules, newRule) ->
    filteredConflicts(previousRules, newRule).concat(newRule)

filteredConflicts = (previousRules, newRule) ->
  _(previousRules).chain().map (oldRule) ->
    overriddenRule(oldRule, newRule)
  .compact().value()

overriddenRule = (oldRule, newRule) ->
  console.log 'hi', dependencyPairs(oldRule)
  survivingPairs = _(dependencyPairs(oldRule)).reject (oldPair) ->
    _(dependencyPairs(newRule)).include(oldPair)

  console.log("JUICE", survivingPairs)

  true

dependencyPairs = (r) ->
  rule = normalize(r)
  _(rule.left).chain().map (l) ->
    _(rule.right).map (r) ->
      [l, r]
  .flatten().uniq().value()


normalize = (rule) ->
  if rule.is == "before"
    leftRightRule(rule.ensure, rule.taskTargets, rule.is)
  else if rule.is == "after"
    leftRightRule(rule.taskTargets, rule.ensure, rule.is)

leftRightRule = (left, right, type) ->
  left: _([].concat(left)).flatten()
  right: _([].concat(right)).flatten()
  is: type
