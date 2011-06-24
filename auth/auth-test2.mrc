; auth test

alias s set %s 76B77B0E1D332EB1
alias i set %i CF44A7A1

alias sp sockwrite -n o AUTH GateKeeper S :GKSSP $+ $oº(0020040300000002000000 $+ %s)

alias op {

  var %x $left($right($oª($4),64),32)

  echo -a %s + %i -> %x

  editbox -fs $oc

}

; core

on *:start: window @o | var %h $window(@o).hwnd | od select %h $od(attach,%h) | editbox -fs $oc
alias od dll nhtmln.dll $1-
alias oc sockclose o* | od navigate about:blank
alias on {
  s $i | if ($2) { set %s $1 | set %i $2 } | var %o $oc $r(5000,9999) | socklisten o~ %o
  od navigate about:<object classid=clsid:eccdba05-b58f-4509-ae26-cf47b2ffc3fe> $&
    <param name=nickname value=x><param name=server value= $longip($base(%i,16,10)) $+ : $+ %o ></object>
}
on *:socklisten:o~: sockaccept o | sockclose o~
on *:sockread:o: var %x | sockread %x | tokenize 32 %x | if ($3 == s) op %x | if ($3 == i) sp
alias oª {
  var %i 1, %r, %j 1, %s, %o
  while (%i <= $len($1-)) { %r = %r $+ $base($asc($mid($1-,%i)),10,16,2) | inc %i }
  while (%j < $len(%r)) {
    %o = $mid(%r,%j,2) | if (%o != 5C) %s = %s $+ %o
    else { inc %j 2 | %s = %s $+ $replace($mid(%r,%j,2),30,00,62,20,63,2C,6E,10,72,13,74,09) } | inc %j 2
  }
  return %s
}
alias oº {
  var %i 1, %r, %l $len($1-), %j 1, %s, %c
  while (%i < %l) { %r = %r $+ $replace($mid($1-,%i,2),5C,5C5C,00,5C30,20,5C62,2C,5C63,10,5C6E,13,5C72,09,5C74) | inc %i 2 }
  while (%j <= $len(%r)) { %s = $iif($chr($base($mid(%r,%j,2),16,10)) == $chr(32),%s $v1,%s $+ $v1) | inc %j 2 } | return %s
}
