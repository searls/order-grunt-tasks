expandsTaskTargets = require("./expands-task-targets")
expandsTaskReferencesInRules = require("./expands-task-references-in-rules")
condensesRules = require("./condenses-rules")
appliesRules = require("./applies-rules")

module.exports =
  order: (taskTargets, rules) ->
    appliesRules.apply(
      expandsTaskTargets.expand(taskTargets),
      condensesRules.condense(expandsTaskReferencesInRules.expand(taskTargets, rules))
    )
