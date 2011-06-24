; room sockwork

on *:sockread:r.*: {
  if ($sockerr) { echo 4 -a $sock($sockname).wsmsg }
  var %x, %s $sockname | sockread %x | tokenize 32 %x
  if (%ech > 2) echo 14 @debug ( $+ %s $+ )1 $1-

  var %n $hsh(%s,nick), %r $hsh(%s,room), %i $hsh(%s,i)

  if ($count(%x,-,:,$chr(40),$chr(41),$chr(124),$chr(1),ï€‹) > 150) halt
  if ($len(%x) > 450) { %x = $left(%x,450) $+ $iif(:* iswm $3,,$iif(:* iswm $4,)) | tokenize 32 %x }

  if ($1 == PRIVMSG) || ($1 == NOTICE) {
    var %t $iif($3 == :S,$left($5-,-1),$right($3-,-1))
    if (%ech > 1) echo 15 @chans [[ $+ %r $+ ]1 %n $+ :14 %t
    if ($sock(log*)) && (r isin $rsh(%r,mode)) sockwrite -n log* p %r $2 %n %t
    if ($cmmd(%s,%t)) {
      if (!$3) halt
      if ($2 == %r) {
        if ($l(%s)) || (m !isin $rsh(%r,mode)) {
          if (f isin $rsh(%r,mode)) {
            var %f $msglimpa($3-)
            if (!%f) || ($l(%s) > 1) sendroom %s $1-
            else _sw %s $bc 932 %n %r %f
          }
          else sendroom %s $1-
        }
      }
      if ($snc(%r,$2)) {
        var %alv $ifmatch
        if (w isin $rsh(%r,mode)) { if (($l(%s) > 0) || ($lvl(%alv) > 0)) sendto %alv %s $1 $hsh(%alv,nick) $3- }
        else sendto %alv %s $1 $hsh(%alv,nick) $3-
      }
      if ($l(%s) > 3) && ($3 == :TIME) scan $snc(%r,$2) %s
    }
  }
  if ($1 == AWAY) && (!%i) {
    hsh %s ui $+($iif($2,G,H),$right($hsh(%s,ui),-1))
    _sw %s $bc $iif($2,306,305) %n $2
    sendroom %s $iif($2,822,821) $2
  }
  if ($1 == WHOIS) {
    if ($snc(%r,$2)) {
      var %t $ifmatch
      _sw %s $bc 311 %n $hsh(%t,nick) $token($token($hsh(%t,id),1,64),2,33) $iif($hsh(%t,bot),bot,bc) * :
    }
  }
  if ($1 == MODE) {
    if ($2 == %r) {
      if (!$3) _sw %s $bc 324 %n %r $rsh(%r,mode) $rsh(%r,limit)
      if ($regex($3,/^[\+-][oqv]$/i)) && (!%i) _do_umode %s %r $1-
      if ($regex($3,/^[\+-][mhintsuwfp]$/i)) _do_cmode %s %r $lower($3)
      if ($regex($3,/^[\+-]x$/i)) && ($l(%s) > 3) _do_cmode %s %r $lower($3)
      if ($regex($3,/^[\+-]l$/i)) _do_limit %s %r $3-
      if ($3 == +b) _sw %s $bc 368 %n %r :
    }
    if ($2-3 == %n +h) _sobe %s $4-
  }
  if ($1 == PASS) _sobe %s $2-

  if ($1 == PART) { sendall %s PART %r | _unroom %s }

  if ($1 == QUIT) sckclose %s

  if ($1 == NICK) chgnk %s $2

  if ($1 == PONG) { var %pin $calc($ticks - $hsh(%s,ping)) | _cmd_fb %s -- seu ping eh: $duration($left(%pin,-3)) $right(%pin,3) $+ msecs }

  if ($1 == PROP) _prop %s $1-

  if ($1 == WHISPER) || ($1 == MESSAGE) {
    if (%ech > 1) echo 14 @chans [[ $+ %r $+ ]1 %n 15->1 $3 $+ :15 $iif($4 == :S,$left($6-,-1),$right($4-,-1))
    if ($sock(log*)) && (r isin $rsh(%r,mode)) sockwrite -n log* w %r $3 %n $iif($4 == :S,$left($6-,-1),$right($4-,-1))
    if ($snc(%r,$3)) {
      var %alv $ifmatch
      if (w isin $rsh(%r,mode)) {
        if (($l(%s) > 0) || ($lvl(%alv) > 0)) sendto %alv %s $1-
      }
      else sendto %alv %s $iif(w* iswm $1,WHISPER,PRIVMSG) %r $iif(w* iswm $1,$hsh(%alv,nick)) $4-
    }
    elseif ($3 == %bot) _bot_ %s $4-
    elseif ($3 == 'baby) _bb %s $4-
  }

  if ($1 == TOPIC) {
    if ($l(%s) > 1) || (t !isin $rsh(%r,mode)) {
      var %p $iif(:* iswm $3,$right($3-,-1),$3)
      topics %r 1 $iif(%p,%p,-)
      sendall %s TOPIC %r $+(:,$rsh(%r,topic))
    }
  }

  if ($1 == TOPIC2) {
    if ($l(%s) > 1) || (t !isin $rsh(%r,mode)) {
      var %p $iif(:* iswm $3,$right($3-,-1),$3)
      topics %r 2 $iif(%p,%p,-)
      sendall %s TOPIC %r $+(:,$rsh(%r,topic))
    }
  }

  if ($l(%s) > 1) {
    if ($1 == KICK) {
      var %t $snc(%r,$3)
      if (%t) && ($l(%s) >= $l(%t)) {
        var %th $token(%t,-2-1,46)
        if (!%i) .timer -m 1 300 _unroom2 $encode(%s %t : $+ $iif(:* iswm $4-,$right($4-,-1),$4-),m)
        else sckclose %t
      }
    }
    ; access add deny *mask* 0 :reason
    if ($1 == ACCESS) {
      var %c acc. $+ $chn(%r), %i $hget(%c,0).item, %m $token($5,1,36), %w $left($4,1), %id $token($hsh(%s,id),2-,33)
      if ($istok(owner.host.voice.grant.deny,$4,46)) {
        if ($4 == owner) && ($l(%s) < 3) return
        if ($3 == ADD) {
          if ($6 isnum) hadd -mu $+ $calc($abs($6) * 60) %c %m $+ %w %m %w %id $nodot($7-) (by %n $+ )
          else hadd -m %c %m $+ %w %m %w %id $nodot($6-) (by %n $+ )
          _sw %s $bc 801 %n %r $upper($4) %m $iif($6 isnum,$abs($6),0) %id : $+ $nodot($7-)
        }
        if ($3 == DELETE) { if ($hget(%c,$5 $+ %w)) { hdel %c $5 $+ %w | _sw %s $bc 802 %n %r $upper($4) %m } }
        if ($3 == CLEAR) { while (%i) { if (* $+ %w iswm $hget(%c,%i).item) { hdel %c $hget(%c,%i).item | _sw %s $bc 820 %n %r $upper($4) } | dec %i } }
      }
      if ($3- == CLEAR) { hfree -w %c | _sw %s $bc 820 %r }
      if ($3 == LIST) || (!$3) {
        var %c acc. $+ $chn(%r), %i $hget(%c,0).item
        _sw %s $bc 803 %n %r :Start of access entries
        while (%i) {
          tokenize 32 $int($calc($hget(%c,$hget(%c,%i).item).unset  / 60)) $hget(%c,%i).data
          _sw %s $bc 804 %n %r $replace($3,o,OWNER,h,HOST,v,VOICE,g,GRANT,d,DENY) $2 $1 $4 : $+ $nodot($5-)
          dec %i
        }
        _sw %s $bc 805 %n %r :End of access entries
      }
    }
  }
}

alias nodot return $iif(:* iswm $1,$right($1-,-1),$1-)

alias _unroom2 { tokenize 32 $decode($1-,m) | sendall $1 KICK $hsh($1,room) $hsh($2,nick) $3- | hsh $2 nopart 1 | _unroom $2 }
alias _unroom { if ($sock($1)) sockrename $1 a $+ $iif($hsh($1,bot),.z) $+ . $+ $token($1,-2-1,46) | hsh $1 lvl 0 | hsh $1 v 0 }

alias _prop {
  var %s $1, %n $hsh($1,nick), %r $hsh($1,room), %t $snc(%r,$3), %p $iif(:* iswm $5,$right($5-,-1),$5)
  tokenize 32 $2-
  if (%t) {
    if ($3 == msnprofile) _sw %s $bc 818 %n $2-3 : $+ $replace($hsh(%t,pp),PX,1,MX,3,FX,5,PY,9,MY,11,FY,13,G,0)
    if ($3 == puid) _sw %s $bc 818 %n $2-3 : $+ $hsh(%t,prop)
  }
  if ($2 == %r) {
    if ($3 == topic) && (($l(%s) > 1) || (t !isin $rsh(%r,mode))) { topics %r 1 $iif(%p,%p,-) | sendall %s TOPIC %r $+(:,$rsh(%r,topic)) }
    if ($istok(onjoin,$3,32)) && ($l(%s) > 1) { rsh %r $3 %p | sendall %s PROP %r $3 $+(:,%p) }
    if ($istok(ownerkey hostkey,$3,32)) && ($l(%s) > 2) {
      if (%p) _chg_prp %s %r $3 %p | else _sw %s $bc PROP %r $3 : $+ $rsh(%r,$3)
    }
  }
}

alias _chg_prp rsh $2- | sendown $1 PROP $2-3 : $+ $4-

alias _do_umode {
  var %s $1, %t $snc($4,$6), %r $2
  tokenize 32 $3 $hsh(%s,room) $5 $hsh(%t,nick) | ; fix case sensitivity crashs
  var %ls $l(%s), %lt $l(%t), %sn $iif(x isin $rsh(%r,mode),sendown3 %t,sendall) %s
  ; t - target , s - source , ?l - level

  ; se t existe , se s owna , se s owna t
  if (%t) && (%ls > 1) && (%ls >= %lt) {
    ; +/-/q/o
    if ($regex($3,[\+-][qo])) {
      var %m $iif(?q iswm $3,3,2)
      if (%ls < %m) return
      if (+? iswm $3) && (%lt < %m) {
        if (%lt) %sn $1-2 $replace(%lt,1,-v,2,-o) $4
        hsh %t lvl %m
        %sn $1-
      }
      if (-? iswm $3) && (%lt == %m) {
        hsh %t lvl $hsh(%t,v)
        if ($hsh(%t,v)) %sn $1-2 +v $4
        %sn $1-
      }
    }
    ; -/+v
    if (?v iswm $3) {
      var %v $iif(+v == $3,1,0)
      hsh %t v %v
      if (%lt != %v) && (%lt < 2) { hsh %t lvl %v | %sn $1- }
    }
  }
}

on *:sockclose:r.*: sckclose $sockname

alias sckclose {
  if (!$hsh($1,nopart)) && (!$hsh($1,i)) && ($hsh($1,room)) sendall $1 PART $hsh($1,room)
  if ($sock($1)) sockclose $1
  var %r $hsh($1,room)
  if ($hget($token($1,-2-1,46))) hfree $ifmatch
  if (!$rsh(%r,nicks)) && (!$sock($+(r.,$chn(%r),.*),0)) && (r !isin $rsh(%r,mode)) { hfree -w $chn(%r) | hdel rooms $chn(%r) }
}

alias msglimpa {
  var %i $lines(badwords.txt)
  while (%i) {
    if ($read(badwords.txt,n,%i) isin $1-) return $v1
    dec %i
  } 
  return 0
}
alias topics {
  var %t $3-, %n, %x, %l $len(%t), %¹ 0, %r, %b 0, %c 0, %w 0, %z 0, %m, %o, %1, %2 | hfree -w t | hmake t 2
  var %ci /^<c(?:olor)? (#[a-f0-9]{6})>/i, %ce /^</c(olor)?>/i, %ti /^<([bius])>/i, %te /^</([bius])>/i
  while (%¹ < %l) && ($len(%x) < 800) && ($len(%n) < 400) {
    inc %¹ | %r = $mid(%t,%¹)

    if ($regex(%r,%ci)) {
      %x = $+(%x,$iif(%z,$chr(32)),$iif(%c,</font>),<font color=",$regml(1),">)
      inc %¹ $calc($pos(%r,>,1) -1) | %c = 1 | %z = 0
    }
    elseif ($regex(%r,%ce)) {
      if (%c) { %x = $+(%x,$iif(%z,$chr(32)),</font>) | %z = 0 }
      inc %¹ $calc($pos(%r,>,1) -1) | %c = 0
    }
    elseif ($regex(%r,%ti)) {
      %m = $lower($regml(1))
      if (!$hget(t,%m)) %x = $+(%x,$iif(%z,$chr(32)),<,%m,>)
      inc %¹ 2 | %z = 0 | hadd t %m 1
    }
    elseif ($regex(%r,%te)) {
      %m = $lower($regml(1))
      if ($hget(t,%m)) %x = $+(%x,$iif(%z,$chr(32)),</,%m,>)
      inc %¹ 3 | %z = 0 | hadd t %m 0
    }
    elseif ($mid(%r,1,1) isin ) {
      %m = $replace($v1,,b,,u)
      %x = $+(%x,$iif(%z,$chr(32)),<,$iif($hget(t,%m),/),%m,>)
      %z = 0 | hadd t %m $iif($hget(t,%m),0,1)
    }
    elseif (* iswm %r) {
      %1 = $mid(%r,2,1) | %2 = $mid(%r,3,1)
      if ((%1 == 0) && (%2 isnum 0-9)) || ((%1 == 1) && (%2 isnum 0-5)) { %o = %1 $+ %2 | inc %¹ 2 }
      elseif (%1 isnum 0-9) { %o = %1 | inc %¹ 1 } | else %o = -1
      %x = %x $+ $iif(%z,$chr(32)) $+ $iif(%c,</font>) $+ $iif(%o != -1,$+(<font color=",$mclr(%o),">))
      %c = $iif(%o == -1,0,1) | %z = 0
      if ($mid(%t,$calc(%¹ +1),1) == $chr(44)) {
        inc %¹ 1 | %1 = $mid(%t,$calc(%¹ +1),1) | %2 = $mid(%t,$calc(%¹ +2),1)
        if ((%1 == 0) && (%2 isnum 0-9)) || ((%1 == 1) && (%2 isnum 0-5)) { %o = %1 $+ %2 | inc %¹ 2 }
        elseif (%1 isnum 0-9) { %o = %1 | inc %¹ 1 } | else %o = -1
        %x = %x $+ $iif(%b,</span>) $+ $iif(%o != -1,$+(<span style="background-color:,$mclr(%o),">))
        %b = $iif(%o == -1,0,1)
      }
    }
    elseif ($chr(32) == $mid(%r,1,1)) { %w = 1 | %z = 1 }
    else {
      %x = $+(%x,$iif(%z,$chr(32)),$replace($mid(%t,%¹,1),&,&amp;,<,&lt;))
      %n = $+(%n,$iif(%w,$chr(32)),$mid(%t,%¹,1))
      %w = 0 | %z = 0
    }
  }

  %x = $+(%x,$iif($hget(t,b),</b>),$iif($hget(t,i),</i>),$iif($hget(t,u),</u>),$iif($hget(t,s),</s>),$iif(%c,</font>),$iif(%b,</span>))

  rsh $1 topicx %x
  rsh $1 topic $iif($2 == 2,%t,%n)

  hfree t
}


alias mclr {
  var %x 9zldr:0:3j:t1c:9y6tc:4ye4g:634po:9uo74:9zl6o:1ds0:t5f:1ekf:70:9y70f:4z3b3:884wi
  return $(#,0) $+ $base($token(%x,$calc($1 +1),58),36,16,6)
}
