#!/bin/bash
# day13 - part1
#
# pass input via stdin with trailing line
#

# checks if the current pair index has been added to the ordered pair list
# which can be used to determine if we can stop comparing further values
is_pair_done() { 
  (( ordered_pairs[pair_index] || unordered_pairs[pair_index] ))
}

# parses the passed in array list, e.g. "[1,2,3]"
parse_array() {
  local -n arr=${1}
  local next_value
  local word=$2
  local inner_word=${word:1}
  local index=0
  inner_word=${inner_word::${#inner_word}-1}

  # continue parsing each value until $inner_word empty (array values)
  while [[ ! -z $inner_word ]]
  do
    parse_next_value $index $inner_word # mutates $next_val and $inner_word
    arr+=( $next_val )
    let index++
  done
}

# parses the next value in the list
# NOTE: this mutates $inner_word from the caller's scope
parse_next_value() {
  local next_arr
  local index=$1
  local word=$2

  if is_list $word; then
    local list=$(get_next_list $word)
    inner_word=${inner_word/"$list"}
    [[ ${inner_word::1} == , ]] && inner_word=${inner_word:1}
    next_arr=${!arr}$index
    parse_array $next_arr $list
    next_val=$next_arr
    return

  elif is_int $word; then
    local int=$(get_next_int $word)
    inner_word=${inner_word/$int}
    [[ ${inner_word::1} == , ]] && inner_word=${inner_word:1}
    next_val=$int
    return
    
  fi
}

# returns true/false on whether the passed in arg is a list
is_list() {
  local word=$1
  [[ ${word:0:1} == '[' ]] && return
  false
}

# parses the next list in the passed in arg
get_next_list() {
  local word=$1
  local bracket_count=0
  
  for((i=1; i<${#word}; i++)) {
    char=${word:i:1}
    [[ $char == '[' ]] && let bracket_count++
    [[ $char == ']' ]] &&  (( !bracket_count-- )) && echo "${word::i+1}" && return
  }
  false
}

# returns true/false on whether the passed in arg is an integer
is_int() {
  local word=$1
  [[ ${word:0:1} == [0-9] ]] && return
  false
}

# parses the next integer in the passed in arg
get_next_int() {
  local word=$1
  local build=""
  for((i=0; i<=${#word}; i++)) {
    char=${word:i:1}
    [[ $char =~ [0-9] ]] && build+=$char || { echo "${build}"; return;}
  }
}

# compares 2 integers based on challenge rules
compare_ints() {
    (( $1 < $2 )) && ordered_pairs[pair_index]=1
    (( $1 > $2 )) && unordered_pairs[pair_index]=1
}

# primary function to compare the 2 arrays by the names passed in as args
compare() {
  local -n larr=$1
  local -n rarr=$2

  local ls=${#larr[@]}
  local rs=${#rarr[@]}
  local size
  local i

  let "size = ls > rs ? ls : rs"
  for((i=0; i<size; i++)) {
    nl=${larr[i]}
    nr=${rarr[i]}

    (( i >= ls )) && ordered_pairs[pair_index]=1
    (( i >= rs )) && unordered_pairs[pair_index]=1

    is_pair_done && return

    if is_int $nl && is_int $nr; then
      compare_ints $nl $nr

    elif is_int $nl && ! is_int $nr; then
      temparr=($nl)
      compare temparr $nr

    elif ! is_int $nl && is_int $nr; then
      temparr=($nr)
      compare $nl temparr

    elif ! is_int $nl && ! is_int $nr; then
      compare $nl $nr

    fi

    is_pair_done && return
  }
}

# read input, parse arrays, and compare
while read left
do
  read right
  read blank_line

  unset ${!left_*} ${!right_*}
  let pair_index++

  parse_array left_ $left
  parse_array right_ $right

  compare left_ right_
done

# retrieve ordered pair indices and sum
indices=(${!ordered_pairs[@]})
echo $(( ${indices[@]/#/+} ))
