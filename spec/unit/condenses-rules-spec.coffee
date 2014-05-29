describe 'condensesRules', ->
  Given -> @rules = ['A', 'B', 'C']
  Given -> @subject = requireSubject "lib/condenses-rules",
    "./filters-conflicts": @filtersConflicts = filter: jasmine.createSpy()
  Given -> @filtersConflicts.filter.when([], 'A').thenReturn(['A1'])
  Given -> @filtersConflicts.filter.when(['A1'], 'B').thenReturn(['A2', 'B1'])
  Given -> @filtersConflicts.filter.when(['A2', 'B1'], 'C').thenReturn(['A3', 'B2', 'C1'])
  When -> @result = @subject.condense(@rules)
  Then -> expect(@result).toEqual(['A3', 'B2', 'C1'])
