; basic msn client by ajhacksu

alias @ return ajhacksu@gmail.com
alias % return x

alias m sockclose * | sockopen nsi messenger.hotmail.com 1863 | window -Sel20 @msn -1 -1 450 300 | � � connecting...

alias � s ns ADD 0 FL $1 $1 0 | s ns ADD 0 AL $1 $1

alias e echo 14 -s $1-
alias � echo $iif($1 isnum,$1,14) @msn $iif($1 isnum,$2-,$1-)
alias s if ($sock($1)) sockwrite -n $1- | e $1 ->15 $2-
alias a s $1 $+(VER 1 MSNP9 CVR0,$crlf,CVR 2 0x0409 win 4.10 i386 MSNMSGR 5.0.0544 MSMSGS $@,$crlf,USR 3 TWN I $@)
alias h return $+($iif(*msn.com iswm $@,msnia),login,$iif(*hotmail.com iswm $@,net),.passport.com)
alias c sockclose u. $+ $1 | sockopen u. $+ $1 $replace($2,:,$chr(32)) | k u. $+ $1 $3 1 $@ $4- | shw_ $1 * connecting...
alias k if ($isid) return $sock($1).mark | else sockmark $1-
alias d if ($fline(@msn,$1,1,1)) dline -l 15 @msn $ifmatch

on *:sockopen:ns*: e $sockname -> connected | a $sockname
on *:sockread:nsi: var %x | sockread %x | e ns0 <- %x | if (XFR * iswm %x) sockopen ns $replace($gettok(%x,4,32),:,$chr(32))
on *:sockread:ns: {
  var %x | sockread %x | tokenize 32 %x | if (LST != $1) e ns <- %x
  if (USR 3 == $1-2) { sockopen auth $h 80 | k auth $4- }
  if (USR 4 == $1-2) { set %n $ansi_($5) | s ns SYN 1 0 | s ns CHG 7 NLN 0 | � � connected! your nick: %n }
  if (CHL == $1) { s ns QRY 10 msmsgs@msnmsgr.com 32 | sockwrite ns $md5($3 $+ Q1P7W2E4J9R8U3S5) }
  if (SYN == $1) dline -l @msn 1-
  if (ILN == $1) aline -l $iif($3 == NLN,1,15) @msn $4
  if (NLN == $1) { $d($3) | aline -l $iif($2 == NLN,1,15) @msn $3 | � � $3 is now $2 }
  if (FLN == $1) { d $2 | � � $2 signed off. }
  if (XFR == $1) c %c $4 USR $6
  if (RNG == $1) c $6 $3 ANS $5 $2
  if (ADD == $1) � 4 add: $2-
}
on *:sockclose:ns*: e $sockname -> disconnected 15 ( $sock($sockname).wsmsg )

on *:sockopen:u.*: var %s $sockname | e %s -> connected | s %s $k(%s)
on *:sockread:u.*: {
  var %x, %s $sockname, %e $token(%s,2-,46), %t | sockread %x | e %s <- %x | tokenize 32 %x
  if (MSG == $1) {
    sockread $4 &x | e %s <- $bvar(&x,1,$4).text
    if ($bfind(&x,1,text/plain)) {
      %t = $bvar(&x,$calc($bfind(&x,1,13 10 13 10) + 4),$4).text
      shw %e $3 %t | .signal txt $2 $ansi(%t)
    }
  }
  if (USR == $1) s %s CAL 2 %e
  if (JOI == $1) { shw_ %e * $ansi_($3) joined. | k %s $calc($k(%s) +1) }
  if (IRO == $1) {
    k %s $4 | if ($4 == 1) shw_ %e * talking with: $ansi_($6)
    else { if ($3 == 1) shw_ %e * talking with: | shw_ %e - � $ansi_($6) }
  }
  if (ANS == $1) .signal init $2
  if (BYE == $1) { shw_ %e * $2 disconnected. | k %s $calc($k(%s) -1) | if (!$k(%s)) sockclose %s | .signal end $2 }
}
on *:sockclose:u.*: var %s $sockname | e %s -> disconnected 15 ( $sock(%s).wsmsg ) | shw_ $token(%s,2-,46) * disconnected.

alias w if (!$window(@ $+ $1)) window -ed @ $+ $1 -1 -1 300 250 | return @ $+ $1
alias shw_  w $1 | echo @ $+ $1 2 $iif(* == $2,�) $3-
alias shw {
  var %w $w($1), %m $remove($3-,$cr), %i 0, %l $numtok(%m,10) | echo %w 14 $ansi_($2) says:
  while (%i < %l) { inc %i | echo 15 %w �� $ansi($token(%m,%i,10)) }
}
alias say_ {
  if (!$sock(u. $+ $1)) { set %c $1 | s ns XFR 9 SB | halt }
  shw $1 $replace(%n,$chr(32),$chr(37) $+ 20) $2-
  var %r $crlf, %m MIME-Version: 1.0 $+ %r $+ Content-Type: text/plain; charset=UTF-8 $+ $&
    %r $+ X-MMS-IM-Format: FN=Tahoma; EF=; CO=0; CS=0; PF=22 $+ %r $+ %r $+ $unicode($2-)
  s u. $+ $1 MSG 2 N $len(%m)
  sockwrite u. $+ $1 %m
}
on *:input:@*@*: say_ $right($active,-1) $1-
on *:close:@*@*: sockclose u. $+ $right($target,-1)

menu @msn {
  dclick: set %c $sline(@msn,1) | s ns XFR 9 SB
}
on *:close:@msn: sockclose ns* | e ns* -> disconnect.

alias ansi_ return $replace($ansi($1),$chr(37) $+ 20,$chr(32))
alias ansi {
  var %r $replace($1,ñ,�,€,�,,�,‚,�,ƒ,�,„,�,…,�,†,�,‡,�,ˆ,�,‰,�,Š,�,‹,�,Œ,�,,�,Ž,�)
  %r = $replace(%r,,�,,�,‘,�,’,�,“,�,”,�,•,�,–,�,—,�,˜,�,™,�,š,�,›,�,œ,�,,�,ž,�)
  %r = $replace(%r,Ÿ,�, ,�,¡,�,¢,�,£,�,¤,�,¥,�,¦,�,§,�,¨,�,©,�,ª,�,«,�,¬,�,­,�,®,�,¯,�,°,�)
  %r = $replace(%r,±,�,²,�,³,�,´,�,µ,�,¶,�,·,�,¸,�,¹,�,º,�,»,�,¼,�,½,�,¾,�,¿,�,À,�,Á,�,Â,�)
  %r = $replace(%r,Ã,�,Ä,�,Å,�,Æ,�,Ç,�,È,�,É,�,Ê,�,Ë,�,Ì,�,Í,�,Î,�,Ï,�,Ð,�,Ñ,�,Ò,�,Ó,�,Ô,�)
  %r = $replace(%r,Õ,�,Ö,�,×,�,Ø,�,Ù,�,Ú,�,Û,�,Ü,�,Ý,�,Þ,�,ß,�,à,�,á,�,â,�,ã,�,ä,�,å,�,æ,�)
  %r = $replace(%r,ç,�,è,�,é,�,ê,�,ë,�,ì,�,í,�,î,�,ï,�,ð,�,ñ,�,ò,�,ó,�,ô,�,õ,�,ö,�,÷,�,ø,�)
  return $replace(%r,ù,�,ú,�,û,�,ü,�,ý,�,þ,�,ÿ,�) | ; ,$chr(37) $+ 20,$chr(32))
}
alias unicode {
  var %r $replace($1,�,ñ,�,€,�,,�,‚,�,ƒ,�,„,�,…,�,†,�,‡,�,ˆ,�,‰,�,Š,�,‹,�,Œ,�,,�,Ž)
  %r = $replace(%r,�,,�,,�,‘,�,’,�,“,�,”,�,•,�,–,�,—,�,˜,�,™,�,š,�,›,�,œ,�,,�,ž)
  %r = $replace(%r,�,Ÿ,�, ,�,¡,�,¢,�,£,�,¤,�,¥,�,¦,�,§,�,¨,�,©,�,ª,�,«,�,¬,�,­,�,®,�,¯,�,°)
  %r = $replace(%r,�,±,�,²,�,³,�,´,�,µ,�,¶,�,·,�,¸,�,¹,�,º,�,»,�,¼,�,½,�,¾,�,¿,�,À,�,Á,�,Â)
  %r = $replace(%r,�,Ã,�,Ä,�,Å,�,Æ,�,Ç,�,È,�,É,�,Ê,�,Ë,�,Ì,�,Í,�,Î,�,Ï,�,Ð,�,Ñ,�,Ò,�,Ó,�,Ô)
  %r = $replace(%r,�,Õ,�,Ö,�,×,�,Ø,�,Ù,�,Ú,�,Û,�,Ü,�,Ý,�,Þ,�,ß,�,à,�,á,�,â,�,ã,�,ä,�,å,�,æ)
  %r = $replace(%r,�,ç,�,è,�,é,�,ê,�,ë,�,ì,�,í,�,î,�,ï,�,ð,�,ñ,�,ò,�,ó,�,ô,�,õ,�,ö,�,÷,�,ø)
  return $replace(%r,�,ù,�,ú,�,û,�,ü,�,ý,�,þ,�,ÿ) | ; ,$chr(32),$chr(37) $+ 20)
}

on *:sockopen:auth: { 
  s auth GET http:// $+ $h $+ /login2.srf HTTP/1.1
  s auth Authorization: Passport1.4 OrgVerb=GET,OrgURL=http%3A%2F%2Fmessenger%2Emsn%2Ecom, $+ $&
    sign-in= $+ $replace($@,@,$chr(37) $+ 40) $+ ,pwd= $+ $% $+ , $+ $k(auth)
  s auth $+(Host: $h $+ ,$crlf,User-Agent: MSMSGS,$crlf,Connection: Close)
  s auth $+(Cache-Control: no-cache,$crlf,$crlf)
  unset %auth
} 
on *:sockread:auth: var %x | sockread %x | e auth <- %x | if (A*-I*: * iswm %x) s ns USR 4 TWN S $gettok(%x,2,39)
