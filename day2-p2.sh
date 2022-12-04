#!/bin/bash
# day2 - part2

# pass input via stdin with trailing line

# staging the point system
let "X = lose = 0"
let "Y = draw = 3"
let "Z = win = 6"
let "A = rock = 1"
let "B = paper = 2"
let "C = scissors = 3"

while read their_hand outcome
do
  # determine hand from outcome
  [[ outcome -eq lose ]] && let "my_hand = their_hand == rock ? scissors : their_hand == paper ? rock : paper"
  [[ outcome -eq draw ]] && let "my_hand = their_hand"
  [[ outcome -eq win ]]  && let "my_hand = their_hand == rock ? paper : their_hand == paper ? scissors : rock"

  # add points
  let "score += outcome + my_hand"
done

echo $score