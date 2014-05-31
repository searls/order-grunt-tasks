describe 'ordersGruntTasks', ->
  Given -> @subject = require('./../../lib/orders-grunt-tasks')

  When -> @result = @subject(@taskTargets, @buildRules)

  describe "no rules", ->
    context "simplest case imaginable", ->
      Given -> @taskTargets = []
      Given -> @buildRules = []
      Then -> expect(@result).toEqual([])

    context "one task, one target no rules", ->
      Given -> @taskTargets = [{task: "coffee", targets:["src"]}]
      Given -> @buildRules = []
      Then -> expect(@result).toEqual(["coffee:src"])

    context "one task, 2 targets no rules", ->
      Given -> @taskTargets = [{task: "coffee", targets:["src", "spec"]}]
      Given -> @buildRules = []
      Then -> expect(@result).toEqual(["coffee:src", "coffee:spec"])

    context "2 task, 2 targets no rules", ->
      Given -> @taskTargets = [
        {task: "coffee", targets:["src", "spec"]},
        {task: "images", targets:["dev"]}
      ]
      Given -> @buildRules = []
      Then -> expect(@result).toEqual(["coffee:src", "coffee:spec", "images:dev"])

  describe "removal rule", ->

    context "1 task, 2 targets, target removal rule", ->
      Given -> @taskTargets = [{task: "coffee", targets:["src", "spec"]}]
      Given -> @buildRules = [
        iWant: "coffee:src"
        toBe: "removed"
      ]
      Then -> expect(@result).toEqual(["coffee:spec"])

    context "1 task, 2 target, task removal rule", ->
      Given -> @taskTargets = [{task: "coffee", targets:["src", "spec"]}]
      Given -> @buildRules = [
        iWant: "coffee"
        toBe: "removed"
      ]
      Then -> expect(@result).toEqual([])