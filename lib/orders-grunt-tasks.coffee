_ = require('underscore')
_.mixin(require('./ext/underscore'))

module.exports =
  order: (taskTargets, buildRules) ->
    gruntTasks = _(taskTargets).chain().map (taskTarget) ->
      _(taskTarget.targets).map (target) ->
        "#{taskTarget.task}:#{target}"
    .flatten().value()

    _(buildRules).chain()
      .unzipProperty("iWant")
      .unzipProperty("these")
      .expandTasks("iWant", gruntTasks)
      .expandTasks("these", gruntTasks)
      .reduce((memo, buildRule) ->
        switch buildRule.toBe
          when "removed"
            _(memo).without(buildRule.iWant)
          when "after"
            _(memo).insertedAfter(buildRule.iWant, buildRule.these)
          else
            memo
      , gruntTasks)
    .value()

arrayWrap = (thing) ->
  if _(thing).isArray() then thing else [thing]
