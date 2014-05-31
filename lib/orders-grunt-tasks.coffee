_ = require('underscore')

module.exports = (taskTargets, buildRules) ->
  gruntTasks = _(taskTargets).chain().map (taskTarget) ->
    _(taskTarget.targets).map (target) ->
      "#{taskTarget.task}:#{target}"
  .flatten().value()

  _(buildRules).reduce (memo, buildRule) ->
    switch buildRule.toBe
      when "removed"
        if buildRule.iWant.match(/\:/)
          _(memo).without(buildRule.iWant)
        else
          _(memo).reject (target) ->
            target.match(new RegExp("^#{buildRule.iWant}:"))
      else
        memo
  , gruntTasks