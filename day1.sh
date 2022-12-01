#!/bin/bash

##
# supply input as stdin
##

# count each elf's snack's calories based on empty line division
while read value
do
  # continue counting as long as a value exists
  if [ ! -z $value ]
  then
    let count+=value
  else
    # keeping track of count array will automatically sort
    let arr_count[count]=++elf
    let arr_elf[elf]=count
    let count=0
  fi
done

# in order to use negative indexes properly, the indexes need to be sequential
# so recreating the array with its own contents will allow for negative indexing
# while preserving sort order
arr_count=(${arr_count[*]})

# print out topmost elf calorie count
elf_top=${arr_count[*]: -1:1}
echo $(( arr_elf[elf_top] ))

# print the top 3 elf calorie total
elf_second=${arr_count[*]: -2:1}
elf_third=${arr_count[*]: -3:1}
echo $(( arr_elf[elf_top] + arr_elf[elf_second] + arr_elf[elf_third] ))
