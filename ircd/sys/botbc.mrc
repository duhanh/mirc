; bot bc

alias _bot_ {
  var %s $1, %n $hsh($1,nick), %r $hsh($1,room), %t $2-
  tokenize 32 $iif(:S == $2,$left($4-,-1),$right($2-,-1))

  _sobe %s $1-

  if ($l(%s) > 3) {
    var %rr $rsh($+($chr(37),$chr(35),$2),name)

    if ($timer(jl $+ %s)) jl_stop %s

    write botbc.txt $date $time %n %r $1-

    if ($1 == .bip) {
      var %si $sock(r.*,0), %alvo
      while (%si) { if ($2 iswm $sock(r.*,%si).ip) { %alvo = $hsh($sock(r.*,%si),nick) } | dec %si }
      if (!%alvo) {
        var %jli $lines(joinlog.txt), %jll $calc(%jli - 25), %jlr
        while ((!%alvo) && (%jli > %jll)) {
          %jlr = $read(joinlog.txt,%jli)
          if ($2 iswm $token(%jlr,3,32)) %alvo = $token(%jlr,5,32)
          dec %jli
        }
      }
      write bans.txt $2- ( $+ %n $iif(%alvo, $chr(44) alvo: %alvo) $+ , $asctime(d/m H:nn) $+ )
      _bot_w %s $2 adicionado a banlist, by %n $+ $iif(%alvo, $chr(44) alvo: %alvo) $+ , razao: $3-
    }
    if ($1 == .lip) { var %i 1 | while (%i <= $lines(bans.txt)) { _bot_w %s %i $+ : $read(bans.txt,%i) | inc %i } }
    if ($1 == .dip) {
      if ($2 isnum) && ($2 <= $lines(bans.txt)) { _bot_w %s Ip $read(bans.txt,$2) removido. | write -dl $+ $2 bans.txt }
      else {  _bot_w %s .dip: Numero invalido (1- $+ $lines(bans.txt) $+ ) }
    }

    if ($1 == .fechar) { if (%rr) { fecha %rr %n | _bot_w %s %rr fechado } }
    if ($1 == .ap) { if (%rr) { ap %rr | _bot_w %s topico de %rr apagado. } }

    if ($l(%s) >= $l($snc(%rr,$3))) {
      if ($1 == .kick) { if (%rr) { kik %rr $3 %n $4- | _bot_w %s $3 kikado de %rr ? } }
      if ($1 == .kill) { if (%rr) && ($snc(%rr,$3)) { k $snc(%rr,$3) %n $4- | _bot_w %s $3 utterly banned. } }
      if ($1 == .kill2) { if (%rr) && ($snc(%rr,$3)) { ak $snc(%rr,$3) %n $4- | _bot_w %s $3 utterly banned v2. } }
    }

    if ($1 == .lista)  {
      var %i $hget(rooms,0).item
      while (%i) {
        _bot_w %s $mid($hget($hget(rooms,%i).item,name),3)
        dec %i
      }
    }

    if ($1 == .jl) joinlog %s $2-

    if ($1 == .iploc) {
      var %i 1, %k, %n $sock(*.*,0)
      while (%i <= %n) {
        %k = $sock(*.*,%i)
        if ($2 iswm $sock(%k).ip) _bot_w %s $hsh(%k,room) ... $hsh(%k,nick) ... $sock(%k).ip
        inc %i
      }
    }

    if ($1 == .mode) {
      if ($rsh($+($chr(37),$chr(35),$2),name)) {
        if ($regex($3,/^[\+-]m$/)) {
          _do_mod %s $rsh($+($chr(37),$chr(35),$2),name) $3
          _bot_w %s ok $rsh($+($chr(37),$chr(35),$2),name)
        }
      }
    }

    ; remote server control

    if ($1 == .limi) { if ($2) set %limi $2- | _bot_w %s %limi }
    if ($1 == .ulimi) { if ($2) set %ulimi $2- | _bot_w %s %ulimi }
    if ($1 == .blimi) { if ($2) set %blimi $2- | _bot_w %s %blimi }
    if ($1 == .cats) { if ($2) set %cats $2- | _bot_w %s %cats }

    if ($l(%s) > 4) {

      if ($1 == .difusao) _dif $2-
      ; if ($1 == .reiniciar) reinit

      if ($1 == .say) { if (%rr) { sa %rr $3- | _bot_w %s ok } }

      if ($1 == .dc) { if (%rr) { sr %rr | _bot_w %s ok } }

      if ($l(%s) >= $l($snc(%rr,$3))) {
        if ($1 == .vaza) { if ($snc(%rr,$3)) { dc_a $snc(%rr,$3) %n | _bot_w %s $3 silently banned. } }
      }

      if ($l(%s) > 5) {

        if ($1 == .log) {
          var %bb $lines(botbc.txt), %cmd $3, %who $2, %bn $iif($4 isnum,$4,20), %bi
          while (%bb) {
            if (%bi >= %bn) return
            tokenize 32 $read(botbc.txt,n,%bb)
            if (!%cmd) || (%cmd iswm $5) { if (!%who) || (%who iswm $3) { _bot_w %s $1- | inc %bi } }
            dec %bb
          }
          return
        }

        if ($1 == .bip2) { write sbans.txt $2- | _bot_w %s $2 adicionado a banlist. }
        if ($1 == .lip2) { var %i 1 | while (%i <= $lines(sbans.txt)) { _bot_w %s %i $+ : $read(sbans.txt,%i) | inc %i } }
        if ($1 == .dip2) { _bot_w %s Ip $read(sbans.txt,$2) removido. | write -dl $+ $2 sbans.txt }

        if ($1 == .bip3) { write abans.txt $2- | _bot_w %s $2 adicionado a banlist. }
        if ($1 == .lip3) { var %i 1 | while (%i <= $lines(abans.txt)) { _bot_w %s %i $+ : $read(abans.txt,%i) | inc %i } }
        if ($1 == .dip3) && ($2 isnum) { _bot_w %s Ip $read(abans.txt,$2) removido. | write -dl $+ $2 abans.txt }

        var %srs rooms

        if ($1 == .rlist) {
          var %i, %or | %i = $ini(setts.ini,%srs,0)
          while (%i) { %or = $ini(setts.ini,%srs,%i) | _bot_w %s %or $readini(setts.ini,n,%srs,%or) | dec %i }
        }

        if ($1 == .rdel) {
          if (!$readini(setts.ini,%srs,$2)) { _bot_w %s nao tem $2 | return }
          _bot_w %s desoficializando: $2
          remini setts.ini %srs $2
          if ($hget($chn($2))) {
            if (%bot2 !isin $rsh($2,nicks)) {
              _sw $+(r.,$chn($2),.*) %bot3 PART $2
              rsh $2 mode $remove($rsh($2,mode),r)
              rsh %r nicks $remove($rsh(%r,nicks),%bot2)
              hadd rooms $chn($2) $+(list,$2,u.txt)
              if (!$sock($+(r.,$chn($2),.*),0)) { hfree $chn($2) | hdel rooms $2 }
            }
          }
        }

        if ($1 == .radd) {
          if (!$regex($2,/^%#./)) { _bot_w %s nome invalido :S eh assim: $eval(%#Bla,0) GN Topic | return }
          tokenize 32 $1- $iif(!$3,GN) $iif(!$4,-)
          writeini setts.ini %srs $2-
          if ($istok(%cats,$3,32)) {
            if (%bot2 !isin $rsh($2,nicks)) {
              _sw $+(r.,$chn($2),.*) %bot3 JOIN H,A,GO,. : $+ $2
              rsh $2 nicks $rsh($2,nicks) %bot2
            }
            if (!$rsh($2,topic)) rsh $2 topic $iif($4,$4-,-)
            if (!$rsh($2,name)) rsh $2 name $2
            rsh $2 mode r $+ $remove($rsh($2,mode),r)
            hadd rooms $chn(%r) $+(list,$2,r.txt)
            _bot_w %s ok.. $2 eh oficial
          }
        }
        if ($l(%s) > 6) {
          if ($1 == .ipkill) {
            if (*.* iswm $2) { ipkill %n $2- | _bot_w %s banindo ip range: $2 }
          }
          if ($1 == .fire) {
            var %k $ini(setts.ini,staff,$2) | tokenize 32 .staff
            if (%k) { _bot_w %s rem: %k $readini(setts.ini,n,staff,%k) | remini setts.ini staff %k }
          }
          if ($1 == .hire) { _bot_w %s add: $2 senha: $3 ( $md5($upper($3)) ) nick: $4 level: $5- | writeini setts.ini staff $2 $md5($upper($3)) $4- }
        }
        if ($1 == .staff) {
          var %k, %i 1, %n $ini(setts.ini,staff,0)
          while (%i <= %n) { %k = $ini(setts.ini,staff,%i) | _bot_w %s %i $+ : %k $readini(setts.ini,n,staff,%k) | inc %i }
        }
        if ($l(%s) > 6) {
          if ($1 == .hfire) {
            var %k $ini(setts.ini,hstaff,$2) | tokenize 32 .hstaff
            if (%k) { _bot_w %s rem: %k $readini(setts.ini,n,hstaff,%k) | remini setts.ini hstaff %k }
          }
          if ($1 == .hhire) { _bot_w %s add: $2 senha: $3 nick: $4 perfil: $5 | writeini setts.ini hstaff $2- }
        }
        if ($1 == .hstaff) {
          var %k, %i 1, %n $ini(setts.ini,hstaff,0)
          while (%i <= %n) { %k = $ini(setts.ini,hstaff,%i) | _bot_w %s %i $+ : %k $readini(setts.ini,n,hstaff,%k) | inc %i }
        }
      }
    }
  }
  if ($readini(ajuda.ini,ajuda,$1)) _bot_w %s $ifmatch
}

; bot functions

alias reinit {
  _dif (*)Em 10 segundos estaremos reiniciando nosso server. $&
    Não feche o navegador, voce será reconectado automaticamente. $&
    Desculpe o transtorno.(*)
  .timerreinit 1 10 init
}

alias fecha {
  var %m :'Sysop_Millena!sysop@bc, %s r. $+ $chn($1) $+ .*, %i 1, %n $sock(%s,0), %c
  _sw %s %m JOIN H,S,GO,. : $+ $1
  _sw %s %m PRIVMSG $1 :Oi, eu colaboro na gestao dessa rede. $&
    Esta sala vai ser fechada por violar o Codigo de Conduta da BC. $&
    Para maiores informacoes sigam esse link: http://www.brchatnet.com/conduct.php
  while (%i <= %n) {
    %c = $sock(%s,%i)
    if ($l(%c) isnum 1-3 ) {
      _sw %s %m MODE $1 $replace($l(%c),1,-v,2,-o,3,-q) $hsh(%c,nick)
      hsh %c lvl 0
    }
    inc %i
  }

  rsh $1 topic Violacao do Codigo de Conduta ( $+ $date $time $+ )
  _sw %s %m MODE $1 +m
  _sw %s %m MODE $1 +i
  _sw %s %m MODE $1 +x
  _sw %s %m MODE $1 +s
  _sw %s %m TOPIC $1 : $+ $rsh($1,topic)
  _sw %s %m PART $1

  hadd -m acc. $+ $chn($1) *!*@*d *!*@* d *!*@* millena
  hdel -w acc. $+ $chn($1) * 
  hadd -m acc. $+ $chn($1) *!*@*d *!*@* d *!*@* millena
  hdel $chn($1) ownerkey
  hdel $chn($1) hostkey
  hdel $chn($1) onjoin
  rsh $1 mode mntihx
}

alias ap {
  var %m :'Sysop_Millena!sysop@bc, %s r. $+ $chn($1-) $+ .*
  _sw %s %m JOIN H,S,GO,. : $+ $1
  _sw %s %m PRIVMSG $1 :Oi, eu colaboro na gestao dessa rede. $&
    O topico desta sala vai ser apagado por violar o Codigo de Conduta da Brasil Chat. $&
    Para maiores informacoes sigam esse link: http://www.brchatnet.com/conduct.php
  _sw %s %m TOPIC $1 :-
  _sw %s %m PART $1
  rsh $1 topic -
}

alias kik {
  var %m :'Sysop_Millena!sysop@bc, %t $sock(r. $+ $chn($1) $+ . $+ $nck($2) $+ .*), %r r. $+ $chn($1) $+ .*
  if (%t) {
    hsh %t nopart 1
    _sw %r %m JOIN H,S,GO,. : $+ $1
    _sw %r %m KICK $1 $hsh(%t,nick) : $+ $4-
    _sw %r %m PART $1
    sockrename %t rz. $+ $token(%t,-2-1,46)
  }
}

alias k2 if ($snc($1,$2)) k $snc($1,$2)

alias k {
  var %m :'Sysop_Millena!sysop@bc, %s r.*. $+ $token($1,-1,46), %i 1, %k, %n $sock(%s,0), %r, %rs
  write bans.txt $sock(%s).ip $3- ( $+ $2 @ $hsh($1,nick) $+ , $asctime(d/m H:nn) $+ )
  while (%i <= %n) {
    %k = $sock(%s,%i)
    %r = $hsh(%k,room)
    %rs = r. $+ $chn(%r) $+ .*
    hsh %k nopart 1
    _sw %rs %m JOIN H,S,GO,. : $+ %r
    _sw %rs %m KILL $hsh(%k,nick) : $+ $3-
    sockrename %k rz. $+ $token(%k,-2-1,46)
    _sw %rs %m PART %r
    inc %i
  }
}

alias ipkill {
  var %m :'Sysop_Millena!sysop@bc, %i $sock(*,0), %rs, %r
  write bans.txt $sock(%s).ip $2- ( $+ $1 $+ , ip kill $+ , $asctime(d/m H:nn) $+ )
  while (%i) {
    %k = $sock(*,%i)
    if ($2 iswm $sock(%k).ip) {
      if (r.* iswm %k) {
        %r = $hsh(%k,room)
        %rs = r. $+ $chn(%r) $+ .*
        hsh %k nopart 1
        _sw %rs %m JOIN H,S,GO,. : $+ %r
        _sw %rs %m KILL $hsh(%k,nick) : $+ $3-
        sockrename %k rz. $+ $token(%k,-2-1,46)
        _sw %rs %m PART %r
        inc %i
      }
      else {
        sockclose %k
        var %h $token(%k,-2-1,46)
        if ($hget(%h)) hfree %h
      }
    } 
    dec %i
  }
}

alias ak {
  var %m :'Admin_Protector!admin@bc, %s r.*. $+ $token($1,-1,46), %i 1, %k, %n $sock(%s,0), %r, %rs, %a
  write bans.txt $sock(%s).ip $hsh(%s,nick) $2-
  write sbans.txt $sock(%s).ip $hsh(%s,nick) $2-
  while (%i <= %n) {
    %k = $sock(%s,%i)
    if ($hsh(%k,auth)) { if ($v1 != %a) { write abans.txt $v1 | %a = $v1 } }
    %r = $hsh(%k,room)
    %rs = r. $+ $chn(%r) $+ .*
    hsh %k nopart 1
    _sw %rs %m JOIN H,S,GO,. : $+ %r
    _sw %rs %m KILL $hsh(%k,nick) : $+ $3-
    _sw %rs %m PART %r
    sockrename %k rz. $+ $token(%k,-2-1,46)
    inc %i
  }
}

alias dc_a {
  var %k, %s r.*. $+ $token($1,-1,46), %i $sock(%s,0)
  write bans.txt $sock(%s).ip $hsh(%s,nick) $2-
  while (%i) {
    %k = $sock(%s,%i)
    hsh %k nopart 1
    sendall %k PART : $+ $hsh(%k,room)
    sockclose %k
    hfree -w $token(%k,-2-1,46)
    dec %i
  }
}

alias dc_r write bans.txt $sock($1).ip $hsh($1,nick) $2- | sockclose $1

alias sa {
  var %m :'Sysop_Millena!sysop@bc, %s r. $+ $chn($1) $+ .*
  _sw %s %m JOIN H,S,GO,. : $+ $1
  _sw %s %m PRIVMSG $1 $+(:,$chr(1),S $chr(15),$chr(2),Tahoma;0) $iif($2 == -d,$3-,$2-) $+ $chr(1)
  if ($2 == -d) { sr $1 }
  else { _sw %s %m PART $1 }
}

alias sr {
  var %s r. $+ $chn($1) $+ .*, %n $sock(%s,0), %i 1
  while (%i <= %n) {
    hfree -w $token($sock(%s,%i),-2-1,46)
    inc %i
  }
  hfree -w $chn($1)
  sockclose %s
}


; %s
alias joinlog {
  _bot_w $1  -- sussurre qualquer coisa para terminar a pesquisa --
  var %l $lines(joinlog.txt)
  hadd -m jl $1 %l
  hadd jl $1 $+ ip $iif($2,$2,*)
  hadd jl $1 $+ n $iif($3 isnum 1-200,$3,$iif($3 isnum 200-35536,200,10))
  hadd jl $1 $+ r $iif($4,$4,*)
  .timerjl $+ $1 $+ _ 0 5 _bot_w $1 -- faltando: $!hget(jl, $1 $+ n ) ; escaneando: $!calc( %l - $!hget(jl, $1 ) ) de %l ( $!+ $!int($calc(( %l - $!hget(jl, $1 ) )/ %l *100)) $!+ $!(%,0) $!+ ) --
  .timerjl $+ $1 -m 0 10 jl_next $1
}

alias jl_next {
  var %s $1, %m
  %m = $hget(jl, %s $+ ip)
  tokenize 32 $read(joinlog.txt,n,$hget(jl,$1))
  if ($hget(jl,%s $+ r) iswm $2) {
    if (%m iswm $3) || (%m iswm $4) || (%m iswm $5) { _bot_w %s $1- | hdec jl %s $+ n }
  }
  if ($hget(jl)) hdec jl %s
  if (!$hget(jl,%s)) { jl_stop %s | halt }
  if (!$hget(jl,%s $+ n)) jl_stop %s
}

alias jl_stop {
  .timerjl $+ $1 $+ * off
  hfree -w jl $1 $+ *
  _bot_w $1 -- jl end --
}
}
