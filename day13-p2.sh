#!/bin/bash
# day13 - part2
# some modifications were needed from part1, but most of it was the same
#
# pass input via stdin with trailing line
#

# checks if the current results has been added to the ordered var
# which can be used to determine if we can stop comparing further values
is_compare_done() { 
  [[ ! -z $ordered ]]
}

# parses the passed in array list, e.g. "[1,2,3]"
parse_array() {
  local -n arr=${1}
  local next_value
  local word=$2
  local inner_word=${word:1}
  local index=0
  inner_word=${inner_word::${#inner_word}-1}

  while [[ ! -z $inner_word ]]
  do
    #echo step ${!arr} $index: $inner_word :: ${arr[@]}
    get_next_value $index $inner_word
    arr+=( $next_val )
    let index++
  done
}

# parses the next value in the list
# NOTE: this mutates $inner_word from the caller's scope
get_next_value() {
  local next_arr
  local index=$1
  local word=$2

  if is_list $word; then
    local list=$(get_next_list $word)
    inner_word=${inner_word/"$list"}
    [[ ${inner_word::1} == , ]] && inner_word=${inner_word:1}
    next_arr=${!arr}_$index
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
    (( $1 < $2 )) && ordered=1 #&& echo ordered
    (( $1 > $2 )) && ordered=0 #&& echo unordered
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

    (( i >= ls )) && ordered=1
    (( i >= rs )) && ordered=0

    is_compare_done && return

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

    is_compare_done && return
  }
}

# setup divider packets and add to main array
divider0=(divider01)
divider01=(2)
divider1=(divider11)
divider11=(6)
main+=(divider0 divider1)

# read input, parse arrays, and add to main array
while read left
do
  read right
  read blank_line

  let pair_index++
  parse_array left_$pair_index $left
  parse_array right_$pair_index $right
 
  main+=(left_$pair_index right_$pair_index)
done

# slow and dirty bubble sort, but it gets the job done in less than a minute still
prev=false
while [[ ${prev_a[@]} != ${main[@]} ]]
do
  prev_a=(${main[@]})
  size=${#main[@]}
  prev=${main[0]}
  for curr in ${main[@]:1};{
    unset ordered
    [[ size -eq ${#main[@]} ]] && unset main
    
    compare $prev $curr
    [[ ordered -eq 1 ]] && { next=$prev; prev=$curr;} || { next=$curr;}
    main+=($next)
  }
  main+=($prev)
done

# calculate the product based on divider packet indices
index=1
product=1
for list_name in ${main[@]};{
  [[ $list_name =~ divider* ]] && let product*=index
  let index++
}
echo $product
