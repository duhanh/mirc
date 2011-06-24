; room commands

alias cmmd {
  var %s $1, %r $hsh($1,room) | tokenize 32 $2

  var %l $iif($l(%s) > 1,$l(%s),0)

  if ($1 == .mode) {
    if (%l > 2) {
      if ($regex($2,/^[\+-][mhintsuwfp]$/i)) _do_cmode %s %r $lower($2)
      elseif ($regex($2,/^[\+-]x$/i)) && ($l(%s) > 3) _do_cmode %s %r $lower($2)
      elseif ($regex($2,/^[\+-]l$/i)) _do_limit %s %r $2-
      _cmd_fb %s -- room mode: $rsh(%r,mode) $rsh(%r,limit)
    }
    else _cmd_fb %s -- room mode: $rsh(%r,mode) $rsh(%r,limit)
    return 0
  }
  if ($1 == .cat) {
    if (%l > 2) {
      if ($istok(%cats,$2,32)) { hadd rooms $chn(%r) list $+ $upper($2) $+ $iif(r isin $rsh(%r,mode),r,u) $+ .txt | rsh %r cat $upper($2) } 
      _cmd_fb %s -- room category: $rsh(%r,cat)
    }
    else _cmd_fb %s -- room category: $rsh(%r,cat)
    return 0
  }
  if ($1 == .chgpass) || ($1 == .pass) || ($1 == .owner) || ($1 == .ownerkey) {
    if (%l > 2) { _chg_prp %s %r ownerkey $2- | _cmd_fb %s -- vc mudo a senha da sala para: $2- }
    else _cmd_fb %s -- vc precisa de telo dourado para mudar a senha!
    return 0
  }
  if ($1 == .oppass) || ($1 == .host) || ($1 == .hostkey) {
    if (%l > 2) { _chg_prp %s %r hostkey $2- | _cmd_fb %s -- vc mudo a senha de op da sala para: $2- }
    else _cmd_fb %s -- vc precisa de telo dourado para mudar a senha!
    return 0
  }
  if ($1 == .boasvindas) || ($1 == .onjoin) {
    if (%l) { sendall %s PROP %r OnJoin $+(:,$2-) | rsh %r onjoin $2- | _cmd_fb %s -- a mensagem de boas vindas foi mudada para: $2- }
    else { _cmd_fb %s -- vc precisa de telo para mudar as boas vindas! }
    return 0
  }
  if ($1 == .clear) {
    if (%l) { hfree -w acc. $+ $chn(%r) | _cmd_fb %s -- voce limpou a lista de acesso. }
    else _cmd_fb %s -- vc precisa de telo para limpa a lista de acesso!
    return 0
  }
  if ($1 == .ban) {
    if (%l) {
      hadd -m %h acc. $+ $chn(%r) $2 $+ d $2 d $hsh(%s,gate) $3-
      _cmd_fb %s -- adicionado: $2 $+ . $iif($3,razao: $3-)
    }
    else { _cmd_fb %s -- vc precisa de telo para adicoinar um ban. | return 0 }
  }
  if ($1 == .unban) || ($1 == .del) {
    if (%l) {
      var %h acc. $+ $chn(%r), %b $hget(%h,$2).item
      if (%b) { _cmd_fb %s -- removendo $left(%b,-1) | hdel %h %b | tokenize 32 .list }
      else _cmd_fb %s -- use: .del N
    }
    else { _cmd_fb %s -- vc precisa de telo para remover um acesso. | return 0 }
  }
  if ($1 == .list) || ($1 == .bans) {
    if (%l) {
      var %h acc. $+ $chn(%r), %i 0, %n $hget(%h,0).item, %v
      _cmd_fb %s -- listando %n acessos:
      while (%i < %n) {
        inc %i | %v = $hget(%h,%i).item | tokenize 32 $hget(%h,%v)
        _cmd_fb %s -- %i $+ : $replace($2,o,OWNER,h,HOST,v,VOICE,g,GRANT,d,DENY) - $1 - $duration($hget(%h,%v).unset) - $4-
      }
      _cmd_fb %s -- digite .clear para limpar essa lista.
    }
    else _cmd_fb %s -- vc precisa de telo para ver a lista de acesso.
    return 0
  }
  if ($1 == .info) {
    if (%l > 2) {
      _cmd_fb %s -- room ownerkey: $rsh(%r,ownerkey)
      _cmd_fb %s -- room hostkey: $rsh(%r,hostkey)
    }
    _cmd_fb %s -- room category: $rsh(%r,cat)
    _cmd_fb %s -- room topic: $rsh(%r,topic)
    _cmd_fb %s -- room onjoin: $rsh(%r,onjoin)
    _cmd_fb %s -- room mode: $rsh(%r,mode) $rsh(%r,limit)
    return 0
  }
  if ($1 == .who) {
    if ($l(%s) > 3) {
      var %sn, %i $sock($+(r.,$chn(%r),.*),0)
      while (%i) {
        %sn = $sock($+(r.,$chn(%r),.*),%i)
        _cmd_fb %s -- $sock(%sn).ip - $hsh(%sn,nick) $iif($hsh(%sn,bot),- eh um bot)
        dec %i
      }
    }
    return 0
  }
  if ($1 == .stats) {
    _cmd_fb %s -- Versao do server: 2.5b (12-oct-04). Uptime: $uptime(mirc,2)
    _cmd_fb %s -- Existem $iif($2 ,$count_unique /) $sock(r.*,0) usuarios em $hget(rooms,0).item salas neste momento.
    _cmd_fb %s -- Recorde: %rec usuarios as %rectime $+ .
    return 0
  }
  if ($1 == .ping) { _sw %s PING | hsh %s ping $ticks | return 0 }
  if ($1 == .loc) {
    if (!$2) tokenize 32 $1 *
    _cmd_fb %s -- procurando $2 ....
    var %ts, %i $sock(r.*,0), %n $iif($3 isnum 1-65536,$iif($l(%s) > 3,$3,$iif($3 > 10,10,$3)),5), %a $iif(%l > 3,1,0)
    while (%i) && (%n) {
      %ts = $sock(r.*,%i) | dec %i
      if (%a) || ((h !isin $rsh($hsh(%ts,room),mode)) && (!$hsh(%ts,i))) {
        if ($2 iswm $hsh(%ts,nick)) && (!$hsh(%ts,i)) { _cmd_fb %s -- $hsh(%ts,room) : $hsh(%ts,nick) | dec %n }
      }
    }
    _cmd_fb %s -- end --
    return 0
  }
  if ($1-2 == vem bot) && ($l(%s) > 3) {
    if (%bot2 !isin $rsh(%r,nicks)) {
      .timer 1 0 _sw $+(r.,$chn(%r),.*) %bot3 JOIN H,A,GO,. $+(:,%r)
      rsh %r nicks $rsh(%r,nicks) %bot2
    }
  }
  if ($1-2 == sai bot) && ($l(%s) > 3) {
    .timer 1 0 _sw $+(r.,$chn(%r),.*) %bot3 PART $!chr(37) $!+ $right(%r,-1)
    rsh %r nicks $remove($rsh(%r,nicks),%bot2)
  }
  if ($1-2 == late bot) && ($l(%s) > 3) {
    .timer 1 0 _sw $+(r.,$chn(%r),.*) %bot3 PRIVMSG $!chr(37) $!+ $right(%r,-1) :AU AU (&)
  }
  if ($1 == .prop) || ($1 == .coord) { _coord %s $iif($1 == .prop,.,@) $2- | return 0 }
  if ($1 == .nick) { chgnk %s $2- | return 0 }

  return 1
}

alias _coord {
  var %r $hsh($1,room), %x $2 $+ %r, %i 1, %j, %n
  if ($l($1) < 4) || (r !isin $rsh(%r,mode)) { _cmd_fb $1 -- voce nao tem permissao para cadastrar nicks ou a sala nao eh oficial. | return }
  if ($4) writeini setts.ini %x $3-
  elseif ($3 isnum) && ($ini(setts.ini,%x,$3)) remini setts.ini %x $ifmatch
  %j = $ini(setts.ini,%x,0)
  _cmd_fb $1 -- listando %j nicks da lista de $iif($2 == .,propietarios,coordenadores) ...
  while (%i  <= %j) { %n = $ini(setts.ini,%x,%i) | _cmd_fb $1 -- %i - %n $readini(setts.ini,n,%x,%n) | inc %i }
}

alias _cmd_fb _sw $1 $hsh($1,id) PRIVMSG $hsh($1,room) :ACTION $2- $+ 
