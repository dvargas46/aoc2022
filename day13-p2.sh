# will clean up later

is_pair_done() { 
  [[ ! -z $ordered ]]
}

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

get_next_value() {
  local next_arr
  local index=$1
  local word=$2

  if is_list $word; then
    local list=$(get_next_list $word)
    inner_word=${inner_word/"$list"}
    [[ ${inner_word::1} == , ]] && inner_word=${inner_word:1}
    next_arr=${!arr}_$index
    #echo parsing inner array as '"'$next_arr'"': $list
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
  
  echo BUG && exit 1
}

is_list() {
  local word=$1
  [[ ${word:0:1} == '[' ]] && return
  false
}

is_int() {
  local word=$1
  [[ ${word:0:1} == [0-9] ]] && return
  false
}

get_next_int() {
  local word=$1
  local build=""
  for((i=0; i<=${#word}; i++)) {
    char=${word:i:1}
    [[ $char =~ [0-9] ]] && build+=$char || { echo "${build}"; return;}
  }
}

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

compare() {
  local -n larr=$1
  local -n rarr=$2

  local ls=${#larr[@]}
  local rs=${#rarr[@]}
  local size
  local i

  #echo $pair_index -- ${!larr}:[${larr[@]/#/,}] ... ${!rarr}:[${rarr[@]/#/,}]

  let "size = ls > rs ? ls : rs"
  for((i=0; i<size; i++)) {
    nl=${larr[i]}
    nr=${rarr[i]}

    (( i >= ls )) && ordered=1 #&& echo ordered
    (( i >= rs )) && ordered=0 #&& echo unordered

    is_pair_done && return

    if is_int $nl && is_int $nr; then
      #echo comparing ints $nl $nr
      compare_ints $nl $nr
    elif is_int $nl && ! is_int $nr; then
      temparr=($nl)
      #echo  compare temparr $nr
      compare temparr $nr
    elif ! is_int $nl && is_int $nr; then
      temparr=($nr)
      #echo  compare $nl temparr
      compare $nl temparr
    elif ! is_int $nl && ! is_int $nr; then
      #echo comparing lists $nl $nr
      compare $nl $nr
    fi

    is_pair_done && return
  }
}

compare_ints() {
    (( $1 < $2 )) && ordered=1 #&& echo ordered
    (( $1 > $2 )) && ordered=0 #&& echo unordered
}

marker0=(marker01)
marker01=(2)
marker1=(marker11)
marker11=(6)

main+=(marker0 marker1)

while read left
do
  read right
  read blank_line

  let pair_index++
  parse_array left_$pair_index $left
  parse_array right_$pair_index $right
 
  main+=(left_$pair_index right_$pair_index)
done

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
#echo prev: ${prev_a[@]}
#echo new:  ${main[@]}
#echo
done

#echo ${main[@]}
#declare -n ele
#for ele in ${main[@]}; { echo ${ele[@]};}

index=1
product=1
for list_name in ${main[@]};{
  [[ $list_name =~ marker* ]] && let product*=index
  let index++
}

echo $product
