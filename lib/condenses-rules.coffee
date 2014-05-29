_ = require('underscore')
filtersConflicts = require('./filters-conflicts')

module.exports =
  condense: (rules) ->
    _(rules).reduce (memo, rule) ->
      filtersConflicts.filter(memo, rule)
    , []
