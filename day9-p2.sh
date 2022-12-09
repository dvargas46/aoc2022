#!/bin/bash
# day9 - part2 - slightly modified from part1
# main difference is to use an array where the head is at index 0 and the tail at index 9

# pass input via stdin with trailing line

# dictionary array for looking up movement values based on direction letter
# also an associative array, tv, for capturing tail visited positions
declare -A x[R]=1 x[L]=-1 y[U]=1 y[D]=-1 tv[0,0]=1

# head increments based on input line direction
move_head() {
  let kx[0]+=xm ky[0]+=ym
}

# tail moves based on the relative position of the head
# and tail position is captured in array, tv
move_tail() {
  for((i=1; i<10; i++)) {
    (( (kx[i-1]-kx[i]==2 && ky[i-1]-ky[i]==1) || (kx[i-1]-kx[i]==1 && ky[i-1]-ky[i]==2) )) && let kx[i]+=1 ky[i]+=1
    (( (kx[i]-kx[i-1]==2 && ky[i-1]-ky[i]==1) || (kx[i]-kx[i-1]==1 && ky[i-1]-ky[i]==2) )) && let kx[i]-=1 ky[i]+=1
    (( (kx[i-1]-kx[i]==2 && ky[i]-ky[i-1]==1) || (kx[i-1]-kx[i]==1 && ky[i]-ky[i-1]==2) )) && let kx[i]+=1 ky[i]-=1
    (( (kx[i]-kx[i-1]==2 && ky[i]-ky[i-1]==1) || (kx[i]-kx[i-1]==1 && ky[i]-ky[i-1]==2) )) && let kx[i]-=1 ky[i]-=1
    (( kx[i-1]-kx[i]==2 )) && let kx[i]+=1
    (( kx[i]-kx[i-1]==2 )) && let kx[i]-=1
    (( ky[i-1]-ky[i]==2 )) && let ky[i]+=1
    (( ky[i]-ky[i-1]==2 )) && let ky[i]-=1
  }

  tv[$((kx[9])),$((ky[9]))]=1
}

while read next
do
  dir=${next// *}
  val=${next//* }

  xm=$(( ${x[$dir]} ))
  ym=$(( ${y[$dir]} ))

  # move the head the amount specified in the input and track the tails
  for((m=0; m<val; m++)){
    move_head
    move_tail
  }
done

echo ${#tv[@]}