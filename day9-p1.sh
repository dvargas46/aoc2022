#!/bin/bash
# day9 - part1

# pass input via stdin with trailing line

# dictionary array for looking up movement values based on direction letter
# also an associative array, tv, for capturing tail visited positions
declare -A x[R]=1 x[L]=-1 y[U]=1 y[D]=-1 tv[0,0]=1

# head increments based on input line direction
move_head() {
  let hx+=xm hy+=ym
}

# tail moves based on the relative position of the head
# and tail position is captured in array, tv
track_tail() {
  (( (hx-tx==2 && hy-ty==1) || (hx-tx==1 && hy-ty==2) )) && let tx+=1 ty+=1
  (( (tx-hx==2 && hy-ty==1) || (tx-hx==1 && hy-ty==2) )) && let tx-=1 ty+=1
  (( (hx-tx==2 && ty-hy==1) || (hx-tx==1 && ty-hy==2) )) && let tx+=1 ty-=1
  (( (tx-hx==2 && ty-hy==1) || (tx-hx==1 && ty-hy==2) )) && let tx-=1 ty-=1
  (( hx-tx==2 )) && let tx+=1
  (( tx-hx==2 )) && let tx-=1
  (( hy-ty==2 )) && let ty+=1
  (( ty-hy==2 )) && let ty-=1
  
  tv[$((tx)),$((ty))]=1
}

while read next
do
  dir=${next// *}
  val=${next//* }

  xm=$(( ${x[$dir]} ))
  ym=$(( ${y[$dir]} ))

  # move the head the amount specified in the input and track the tail
  for((m=0; m<val; m++)){
    move_head
    track_tail
  }
done

echo ${#tv[@]}
