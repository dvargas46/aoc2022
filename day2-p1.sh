#!/bin/bash
# day2 - part1

# pass input via stdin with trailing line

# staging the point system
let "A = X = rock = 1"
let "B = Y = paper = 2"
let "C = Z = scissors = 3"

while read their_hand my_hand
do
  # add points for winning
  let "score += 6*(
    (my_hand == rock && their_hand == scissors)  ||
    (my_hand == paper && their_hand == rock)     ||
    (my_hand == scissors && their_hand == paper)
  )"
  
  # add points for a draw
  let "score += 3*(my_hand == their_hand)"

  # add points for the shape
  let "score += my_hand"
done

echo $score