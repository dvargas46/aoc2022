# clean up later

shopt -s extglob

declare -A sensors beacons
declare -a extremes
declare loi_y=2000000

map_grid() {
  let xs=$1 ys=$2 xb=$3 yb=$4
  
  let "xd = xb-xs, xd = xd < 0 ? -xd : xd"
  let "yd = yb-ys, yd = yd < 0 ? -yd : yd"
  let "range = xd + yd"
  
  (( loi_y > ys-range && loi_y < ys+range )) && update_extremes

  sensors[$xs,$ys]=1
  beacons[$xb,$yb]=1
}

update_extremes() {

  let "loi_yd = loi_y - ys, loi_yd = loi_yd < 0 ? -loi_yd : loi_yd"
  let "loi_xd = range - loi_yd, loi_xd = loi_xd < 0 ? -loi_xd : loi_xd"
  let "local_min = xs - loi_xd"
  let "local_max = xs + loi_xd"

  extremes+=( $local_min,$local_max )
}

merge_overlaps() {
  while (( !finished ))
  do
    finished=0
    for i in ${!extremes[@]};{
      e1=${extremes[i]}
      e1min=${e1/,*}
      e1max=${e1/*,}
      for j in ${!extremes[@]};{
        (( i == j )) && continue
        e2=${extremes[j]}
        e2min=${e2/,*}
        e2max=${e2/*,}
        
        (( e2max >= e1max && e1max >= e2min && e2min >= e1min )) && extremes[j]=$e1min,$e2max && unset extremes[i] && continue 3
        (( e1max >= e2max && e2max >= e1min && e1min >= e2min )) && extremes[j]=$e2min,$e1max && unset extremes[i] && continue 3
        (( e1max >= e2max && e2min >= e1min )) && extremes[j]=$e1min,$e1max && unset extremes[i] && continue 3
        (( e2max >= e1max && e1min >= e2min )) && extremes[j]=$e2min,$e2max && unset extremes[i] && continue 3
      }
    }
    finished=1
  done
}

while read line
do
  map_grid ${line//+([^0-9 -])}
done

for beacon in ${!beacons[@]};{
  beacon_y=${beacon/*,}
  (( beacon_y == loi_y )) && let beacons_on_loi++
}

merge_overlaps

for extreme in ${extremes[@]};{
  min=${extreme/,*}
  max=${extreme/*,}
  let "loi_spots += max - min + 1"
}

echo $(( loi_spots - beacons_on_loi ))
