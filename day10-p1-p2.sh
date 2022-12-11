#!/bin/bash
# day10 - part1 and part2
#
# pass input via stdin with trailing line
#

let cycle[C=1]=V=1

update_pixel() {
    let cp=C-1
    let cp%=40
    (( V-cp==1 || V-cp==0 || V-cp==-1 )) && scr="#" || scr="."
    crt[(C-1)/40]+=$scr
}

read_instr() {
  set $*
  val=$(( $3 ))
  update_pixel
  let cycle[++C]=V

  if (( val )); then
    update_pixel
    let V+=val
    let cycle[++C]=V
  fi
}

mapfile -tc1 -C'read_instr' instrs

# part 1
let cn={20,60,100,140,180,220},sum+=cycle[cn]*cn
echo $sum

# part 2
for((;i<9;i++)){ echo ${crt[i]};}
