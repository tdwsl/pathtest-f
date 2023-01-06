\ pathfind in forth

create dirs
1 c, 0 c,
2 c, 1 c,
1 c, 2 c,
0 c, 1 c,
create map
1 c, 1 c, 1 c, 1 c, 1 c, 1 c, 1 c, 1 c, 1 c, 1 c,
1 c, 0 c, 1 c, 0 c, 0 c, 0 c, 1 c, 0 c, 0 c, 1 c,
1 c, 0 c, 1 c, 0 c, 0 c, 0 c, 1 c, 0 c, 0 c, 1 c,
1 c, 0 c, 1 c, 0 c, 1 c, 0 c, 1 c, 1 c, 0 c, 1 c,
1 c, 0 c, 0 c, 0 c, 1 c, 0 c, 1 c, 0 c, 0 c, 1 c,
1 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 0 c, 1 c,
1 c, 1 c, 1 c, 0 c, 1 c, 0 c, 1 c, 1 c, 0 c, 1 c,
1 c, 0 c, 0 c, 0 c, 0 c, 0 c, 1 c, 0 c, 0 c, 1 c,
1 c, 0 c, 0 c, 0 c, 1 c, 0 c, 0 c, 0 c, 0 c, 1 c,
1 c, 1 c, 1 c, 1 c, 1 c, 1 c, 1 c, 1 c, 1 c, 1 c,
10 constant mapw
10 constant maph
mapw maph * constant mapsz
create path-map mapsz allot
create map-buf mapsz allot

: in-bounds ( x y -- )
  2dup 0>= swap 0>= and >r maph < swap mapw < and r> and ;

: mapi ( x y -- i )
  mapw * + ;

: dir+ ( x y i -- x y )
  2* dirs + dup 1+ c@ 1- rot + rot rot c@ 1- + swap ;

: generate-path ( x y -- )
  mapsz 0 do map i + c@ 0<> path-map i + c! loop
  mapi path-map + 1 swap c!
  255 1 do
    mapsz 0 do path-map i + c@ j = if
      4 0 do j mapw /mod i dir+
        2dup in-bounds if
          mapi path-map + dup c@ 0= if k 1+ swap c! else drop then
      else 2drop then loop
  then loop loop ;

: print-pathmap ( -- )
  mapsz 0 do path-map i + c@ . i 1+ mapw mod 0= if cr then loop ;

: draw-path ( x1 y1 x2 y2 -- )
  mapsz 0 do map i + c@ if [char] # else [char] . then map-buf i + c! loop
  generate-path
  2dup mapi map-buf + [char] @ swap c!
  begin
    4 0 do 2dup i dir+
      2dup in-bounds if
        mapi path-map + c@ dup 2over mapi path-map + c@ 1- nip = if
          i dir+ leave
        then
    else 2drop then loop
    2dup mapi map-buf + [char] " swap c!
  2dup mapi path-map + c@ 1 = until 2drop
  mapsz 0 do map-buf i + c@ emit i 1+ mapw mod 0= if cr then loop ;

1 1 generate-path
1 1 7 1 draw-path
key bye
