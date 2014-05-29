describe 'ordersGruntTasks', ->
  Given -> @subject = requireSubject 'lib/orders-grunt-tasks'
  When -> @subject()
  Then ->
