; remote uper

alias dupa echo @ftp * Desconectando... | sockclose ul* | .timerrq off | if ($1) upa
alias upa {
  .timerrq 1 200 dupa x
  var %r, %i $hget(rooms,0).item, %f $findfile($mircdir,list*.*,0,.remove $1).shortfn
  while (%i) {
    %r = $hget(rooms,%i).item
    dec %i
    if (!$hget(%r)) || ($hget(%r,cat) !isin %cats) hdel rooms %r
    else {
      tokenize 32 $hget(%r,name) $n_u(%r) $hget(%r,cat) %srv $hget(%r,mode) $hget(%r,topic)
      if (h !isin $5) {
        write $+(list,$3,$iif(r isin $5,r,u),.txt -,$2) $1 $iif($hget(%r,topicx),$v1,$6-)
        write $+(list,$4,.php) l $1-4 $iif(r isin $5,1,0) $6-
      }
    }
  }
  write -c list5.php <font face=tahoma size=-1 color=#1a60a8> Total de usuários no servidor: $sock(r.*,0) $+ . Última atualização às $time $+ . </font>
  %i = $findfile($mircdir,list*.txt,0,filter -fftuc 1 32 $1 $1).shortfn
  .remove r | unset %uj %j | u_rl
}

; upload list

alias u_rl %uj = GN TN EV CP RL RM 1 5 | if (!$sock(ul.l)) socklisten ul.l 7000 | if (!$sock(ul.m)) sockopen ul.m $ftphost 21 | else uj_n
on *:sockopen:ul.m: if (!$sockerr) { _sw ul.m $loginstr | uj_n | echo 14 -t @ftp * [re]Conectado ao ftp e upando... } | else .timer 1 0 dupa x
on *:sockread:ul.m: {
  var %x, %k %j $+ _ | sockread %x | if (%ech > 1) echo 14 @ftp (ul.m)1 %x
  if (226 * iswm %x) { _sw ul.m $+(DELE %j,$lf,RNFR %k,$lf,RNTO %j) | uj_n }
  if (227* iswm %x) { tokenize 44 $token($token(%x,2,40),1,41) | sockopen ul.u $replace($1-4,$chr(32),.) $calc($5 * 256 + $6) }
}
alias uj_n {
  if ($file(%j)) .remove %j | if (!%uj) { .timerrq 1 120 upa | unset %jn %s %n %uj %j | halt }
  %jn = $token(%uj,1,32) | %j = list $+ %jn $+ .php | %uj = $token(%uj,2-,32) | _sw ul.m $+(PORT $replace(%ip $+ .27.88,.,$chr(44)),$lf,STOR %j,_)
}
on *:socklisten:ul.l: sockclose ul.u | sockaccept ul.u | uj_u
on *:sockopen:ul.u: if ($sockerr) { echo @ftp err: $sockerr $sock(ul.u).wsmsg | halt } | uj_u
alias uj_u if (%jn !isnum) m_rl %jn | else ul_s | .timer 1 0 sockclose ul.u
alias ul_s if ($file(%j)) { bread %j 0 $file(%j).size &x | sockwrite -n ul.u &x } | else _sw ul.u $crlf $crlf

; write the files

alias m_rl {
  var %t $ticks
  var %p list $+ $1, %h %p $+ .php, %r %p $+ r.txt, %u %p $+ u.txt | %s = 0 | %n = 0
  m_h %h $1 | if ($file(%r)) m_l %r %h $1 1 | if ($file(%u)) m_l %u %h $1 | m_f %h
  if (%ech) echo 14 @ftp * $1 - $calc($ticks - %t) msecs
}
alias m_h {
  var %w $iif(1,sockwrite -n ul.u,write -c $1)
  var %st style="font-family: Verdana; font-size: 12px; color: #1A60A8"
  %w <script> $crlf $&
    <!-- // script by Ajhacksu $crlf $&
    function tn $+ $2 $+ (n){eval("document.all.s"+n+"n.style.display=''; document.all.s"+n+"t.style.display='none'")} $crlf $&
    function tt $+ $2 $+ (n){eval("document.all.s"+n+"t.style.display=''; document.all.s"+n+"n.style.display='none'")} $crlf $&
    --> $crlf $&
    </script>
  %w <table border="0" cellpadding="0" cellspacing="1" width="100%" %st ><tr> $&
    <td bgcolor="#5AA8DA" width="60"><p align="center"><b><font color="#FFFFFF">Users</font></b></td> $&
    <td bgcolor="#5AA8DA" width="17"></td> $&
    <td bgcolor="#5AA8DA" width="30%"><p align="center"><b><font color="#FFFFFF">Sala</font></b></td> $&
    <td bgcolor="#5AA8DA"><p align="center"><b><font color="#FFFFFF">Tópico/Nicks</font></b></td></tr>
}
alias m_l {
  var %w $iif(1,sockwrite -nt ul.u,write $2)
  var %f $1, %h $2, %ca $3, %r $4, %c, %rn, %rt, %ru, %i 0, %t $lines(%f), %h
  while (%i < %t) {
    inc %i | inc %s | %c = $+(<td bgcolor="#,$iif(2 // %s,e8f8ff,f9fafb),") | tokenize 32 $read(%f,n,%i) | %hid = $ticks $+ %n $+ %i
    %rn = $bc.decode($replace($right($2,-2),\b,$chr(32),\c,$chr(44))) | %rt = $bc.decode($3-) | %ru = $right($1,-1) | inc %n %ru
    %w $+(<tr>,%c align="center">,%ru,</td>,%c >,$iif(%r,<img src="imagens/bncroom.gif" border=0 width="17" height="15">,&nbsp;),</td>)
    %w $+(%c,>&nbsp;,<a href="http://www.,$httphost,/chatroom.php?cat=,%ca,&rm=,%rn,">,$replace(%rn,<,&lt;),</a></td>)
    %w $+(%c,>&nbsp;) <span id="s $+ %hid $+ t" style="cursor: hand" onclick="tn $+ %ca $+ ( $+ %hid $+ )">
    %w %rt 
    %w </span> <span id="s $+ %hid $+ n" style="display: none; cursor: hand" onclick="tt $+ %ca $+ ( $+ %hid $+ )">
    %w $m_n(%w,$2) </span></td></tr>
  }
  .remove %f
}
alias m_f {
  var %w $iif(1,sockwrite -n ul.u,write $1)
  %w </table><font face=tahoma size=-1 color=#1a60a8>
  if (%s) %w Stats: %n $+(use,$iif(%n > 1,rs,r) em %s sala,$iif(%s > 1,s),.)
  else %w <br>Não foi criada nenhuma sala nessa categoria.
  %w </font><br>
}

alias m_n {
  var %s r. $+ $chn($2) $+ .*, %i $sock(%s,0), %n, %k, %z /(\w+,){3}[\.@\+]/ig
  if (x isin $rsh($2,mode)) || (p isin $rsh($2,mode)) { $1 Lista de nicks indisponível (modo +p) }
  else {
    %z = $regsub($hget($chn($2),nicks),%z,,%n)
    if (%n) $1 $replace($bc.decode(%n),&,&amp;,<,&lt;,$chr(32),$chr(44) $+ $chr(32)) $+ $iif(%i,$chr(44))
    %n = $null
    while (%i) {
      %k = $sock(%s,%i)
      if (!$hsh(%k,i)) %n = %n $hsh(%k,nick) $+ $iif(%i == 1,.,$chr(44))
      if (4 // %i) { $1 $replace($bc.decode(%n),&,&amp;,<,&lt;) | %n = $null }
      dec %i
    }
    if (%n) $1 $left($replace($bc.decode(%n),&,&amp;,>,&lt;),-1) $+ .
  }
}

alias n_u {
  var %s r. $+ $1 $+ .*, %i $sock(%s,0), %n 0
  while (%i) { if (!$hsh($sock(%s,%i),i)) inc %n | dec %i }
  return $calc(%n + $numtok($hget($1,nicks),32))
}

alias count_unique {
  var %i $sock(r.*,0)
  hfree -w x | hmake x
  while (%i) {
    hadd x $sock(r.*,%i).ip  x
    dec %i
  }
  %i = $hget(x,0).item
  hfree x
  return %i
}
