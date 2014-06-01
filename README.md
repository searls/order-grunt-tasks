# order-grunt-tasks

**We're building this to provide a sane API for ordering build tasks
to [Lineman](https://github.com/linemanjs/lineman).**

## Background

Say you have a grunt config with some tasks and targets:

``` coffee
images: #<-- "images" task
  dev: {} #<-- "dev" target
  dist: {} #<-- "dist" target
```

In grunt, you could run "images" to run both tasks (in definition order),
or you could run "images:dev" to run just one target.

Let's suppose you have a build system that defines a default task-order:

```
tasks: ["coffee", "images:dev", "concat:dev"]
```

But suppose you discover that (for some reason), "images:dev" needs to
run after "concat:dev". You could, of course, just change the array.

But if you were somehow constrained to not modify the array directly,
but instead modify it dynamically, you'd be stuck reordering the array:

```
tasks: _(originalTasks).without("images:dev").concat("images:dev")
```

This gets hairy, though, if the difference between "images:dev" and "images"
is left to an only semi-meaningful string suffix. (Imagine dealing with
  multiple levels of task mutators)

What if, instead, it was initially assumed that all tasks were order-independent?
Then, rules could be added to an ordered list to describe ordering
requirements. So long as the task-mutator-manager (okay, conceit over: it's
Lineman) applies all the rules in order, then we're cool.

Some values:

taskTargets:
``` coffeescript
[
  { taskName: "coffee", targets: ["compile"] },
  { taskName: "images", targets: ["dev", "dist"] }
]
```

rules:
``` coffeescript
[
  {
    iWant: "images:dev"
    toBe: "after"
    these: "coffee"
  },
  {
    iWant: "coffee:compile"
    toBe: "before"
    these: ["images:dev","images:dist"]
  },
  {
    iWant: "coffee"
    toBe: "removed"
  }

]
```
