describe 'ordersTaskTargets', ->
  Given -> @tasks = 'some task-targets []'
  Given -> @rules = 'some rules []'
  Given -> @subject = requireSubject "lib/orders-task-targets",
    "./expands-task-targets": @expandsTaskTargets = expand: jasmine.createSpy('expand').when(@tasks).thenReturn('expanded tasks')
    "./expands-task-references-in-rules": @expandsTaskReferencesInRules = expand: jasmine.createSpy('expand').when(@tasks, @rules).thenReturn('expanded rules')
    "./condenses-rules": @condensesRules = condense: jasmine.createSpy('condense').when('expanded rules').thenReturn('condensed rules')
    "./applies-rules": @appliesRules = apply: jasmine.createSpy('apply').when('expanded tasks', 'condensed rules').thenReturn('ordered task targets')
  When -> @result = @subject.order(@tasks, @rules)
  Then -> @result == "ordered task targets"
