#!/bin/bash
# day11 - part1 and part2
#
# pass input via stdin with trailing line
#

# input parsing
while read monkey_statement
do
  read m_items_statement
  read m_op_statement
  read m_test_statement
  read m_truth_route_statement
  read m_false_route_statement
  read blank_line

  m_index=${monkey_statement//[^0-9]}
  m_items=${m_items_statement//*: }
  m_op=${m_op_statement//*= }
  m_test=${m_test_statement//[^0-9]}
  m_truth_route=${m_truth_route_statement//[^0-9]}
  m_false_route=${m_false_route_statement//[^0-9]}

  item_lists[m_index]="${m_items//,} "
  operations[m_index]=$m_op
  tests[m_index]=$m_test
  truth_routes[m_index]=$m_truth_route
  false_routes[m_index]=$m_false_route
done

# monkey in the middle rounds
monkey_in_the_middle() {
  # reset each game
  unset m_item_lists
  unset totals
  unset t_totals
  for i in ${!item_lists[@]};{ m_item_lists[i]="${item_lists[i]}";}

  # play rounds and watch activity
  for((round=0; round<$1; round++)) {
    for index in ${!m_item_lists[@]};{
      for old in ${m_item_lists[index]};{
        let "totals[index]++"
        let "worry_level = operations[index] / div_v"
        let "next = worry_level % tests[index] ? false_routes[index] : truth_routes[index]"
        (( mod_v )) && let "worry_level %= mod_v"

        m_item_lists[index]="${m_item_lists[index]/* }"
        m_item_lists[next]+="$worry_level "
      }
    }
  }

  # simple way to sort an array using indices of a temp array
  for total in ${totals[@]};{ t_totals[total]=$total;}
  totals=(${t_totals[@]})

  echo $(( totals[-2] * totals[-1] ))
}

# part 1
div_v=3
mod_v=0
monkey_in_the_middle 20

# part 2
div_v=1
mod_v=$(( 1${tests[@]/#/*} )) # product reduction, trust me
monkey_in_the_middle 10000
