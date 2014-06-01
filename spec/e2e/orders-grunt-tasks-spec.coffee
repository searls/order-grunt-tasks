describe 'ordersGruntTasks', ->
  Given -> @subject = require('./../../lib/orders-grunt-tasks')

  When -> @result = @subject.order(@taskTargets, @buildRules)

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

    context "1 task, 2 targets, 1 removal", ->
      Given -> @taskTargets = [{task: "coffee", targets:["src", "spec"]}]
      Given -> @buildRules = [
        iWant: "coffee:src"
        toBe: "removed"
      ]
      Then -> expect(@result).toEqual(["coffee:spec"])

    context "1 task, 2 target, 1 task-level removal", ->
      Given -> @taskTargets = [{task: "coffee", targets:["src", "spec"]}]
      Given -> @buildRules = [
        iWant: "coffee"
        toBe: "removed"
      ]
      Then -> expect(@result).toEqual([])

    context "2 removals", ->
      Given -> @taskTargets = [
        {task: "coffee", targets:["src", "spec"]}
        {task: "images", targets:["dev"]}
      ]
      Given -> @buildRules = [
        iWant: ["coffee:src", "images:dev"]
        toBe: "removed"
      ]
      Then -> expect(@result).toEqual(["coffee:spec"])

  describe "after rule", ->
    context "1 rule, 2 tasks, 1 target", ->
      Given -> @taskTargets = [
        {task: "coffee", targets:["src"]}
        {task: "images", targets:["dev"]}
      ]
      Given -> @buildRules = [
        iWant: "coffee:src"
        toBe: "after"
        these: "images:dev"
      ]
      Then -> expect(@result).toEqual(["images:dev","coffee:src"])

    context "1 rule, 2 tasks, 1 target, arrayified 'these'", ->
      Given -> @taskTargets = [
        {task: "coffee", targets:["src"]}
        {task: "images", targets:["dev"]}
      ]
      Given -> @buildRules = [
        iWant: "coffee:src"
        toBe: "after"
        these: ["images:dev"]
      ]
      Then -> expect(@result).toEqual(["images:dev","coffee:src"])

    context "1 rule, 2 tasks, 1 target, generalized 'these'", ->
      Given -> @taskTargets = [
        {task: "coffee", targets:["src"]}
        {task: "images", targets:["dev", "dist"]}
      ]
      Given -> @buildRules = [
        iWant: "coffee:src"
        toBe: "after"
        these: "images"
      ]
      Then -> expect(@result).toEqual(["images:dev", "images:dist","coffee:src"])

  describe "edge cases", ->
    context "an undefined task as an iWant", ->
      Given -> @taskTargets = [{task: "coffee", targets:["src"]}]
      Given -> @buildRules = [
        iWant: "wat"
        toBe: "removed"
      ]
      Then -> expect(@result).toEqual(["coffee:src"])

    context "an undefined task as a 'these'", ->
      Given -> @taskTargets = [{task: "coffee", targets:["src"]}]
      Given -> @buildRules = [
        iWant: "coffee:src"
        toBe: "after"
        these: 'wat'
      ]
      Then -> expect(@result).toEqual(["coffee:src"])
