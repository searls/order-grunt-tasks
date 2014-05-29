describe 'filtersConflicts', ->
  Given -> @subject = requireSubject('/lib/filters-conflicts')

  When -> @result =  @subject.filter([@rule1], @rule2)

  context 'delete me', ->
    Given -> @rule1 =
      ensure: ['a:a', 'b:b', 'e:e']
      is: 'after'
      taskTargets: ['c:c', 'd:d']
    Given -> @rule2 =
      ensure: ['e:e', 'f:f', 'b:b']
      is: 'before'
      taskTargets: ['g:g', 'h:h', 'd:d']
    # -> (a,c),(a,d),(b,c),(b,d)
    # -> (e,g)(e,h)(f,g)(f,h)

    Then -> expect(@result).toEqual([@rule1, @rule2])


  context 'no-conflicts', ->
    Given -> @rule1 =
      ensure: 'foo:foo'
      is: 'after'
      taskTargets: 'bar:bar'
    Given -> @rule2 =
      ensure: 'baz:baz'
      is: 'before'
      taskTargets: 'bar:bar'
    Then -> expect(@result).toEqual([@rule1, @rule2])

  context "identity conflicts", ->
    context "identical", ->
      Given -> @rule1 =
        ensure: 'foo:foo'
        is: 'before'
        taskTargets: 'bar:bar'
      Given -> @rule2 =
        ensure: 'foo:foo'
        is: 'before'
        taskTargets: 'bar:bar'
      Then -> expect(@result).toEqual([@rule2])

    context "partial", ->
      Given -> @rule1 =
        ensure: ['foo:foo', 'baz:baz']
        is: 'before'
        taskTargets: 'bar:bar'
      Given -> @rule2 =
        ensure: 'foo:foo'
        is: 'before'
        taskTargets: 'bar:bar'
      Then -> expect(@result).toEqual([
          ensure: ['baz:baz']
          is: 'before'
          taskTargets: 'bar:bar'
        ,
          @rule2
      ])


  context "simple occluding conflicts", ->
    context "after+before", ->
      Given -> @rule1 =
        ensure: 'foo:foo'
        is: 'after'
        taskTargets: 'bar:bar'
      Given -> @rule2 =
        ensure: 'foo:foo'
        is: 'before'
        taskTargets: 'bar:bar'
      Then -> expect(@result).toEqual([@rule2])

    context "before+after", ->
      Given -> @rule1 =
        ensure: 'foo:foo'
        is: 'before'
        taskTargets: 'bar:bar'
      Given -> @rule2 =
        ensure: 'foo:foo'
        is: 'after'
        taskTargets: 'bar:bar'
      Then -> expect(@result).toEqual([@rule2])
