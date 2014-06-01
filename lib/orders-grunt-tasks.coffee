_ = require('underscore')
require('./ext/underscore')

module.exports = (taskTargets, buildRules) ->
  gruntTasks = _(taskTargets).chain().map (taskTarget) ->
    _(taskTarget.targets).map (target) ->
      "#{taskTarget.task}:#{target}"
  .flatten().value()

  _(buildRules).chain()
    .unzipProperty("iWant")
    .expandTasks("iWant", gruntTasks)
    .reduce((memo, buildRule) ->
      switch buildRule.toBe
        when "removed"
          _(memo).without(buildRule.iWant)
        when "after"
          _(memo).moveAfter(buildRule.iWant, buildRule.these)
        else
          memo
    , gruntTasks)
  .value()

arrayWrap = (thing) ->
  if _(thing).isArray() then thing else [thing]
