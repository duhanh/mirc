; small aliases

alias bc return :bc $+ %srv
alias bc2 return @bc

alias loginstr return $+(USER server@brchatnet.com,$lf,PASS r9w1s3w6) | ; ,$lf,CWD /home/brchat/public_html/server)
alias ftphost return 69.93.61.210
alias httphost return brchatnet.com

alias _sw {

  var %i $sock($1,0)
  while (%i) {
    if ($sock($1,%i).sq < 10000) sockwrite -n $sock($1,%i) $2-
    goto end
    :error
    echo -s error: $error
    reseterror
    :end
    dec %i
  }

  ; sockwrite -n  $1-
  if (%ech > 2) echo @debug $+(1[15,$1,1]15) $2-
}

; alias __sw if ($sock($1)) { sockwrite -n $1 $decode($2-,m) }

alias h var %i = 1 | while (%i <= $hget($1,0).data) { echo 3 -a %i ;3 $hget($1,%i).item ;1 $hget($1,%i).data | inc %i }
alias dump socklist | var %i = 1 | while (%i <= $hget(0)) { echo 2 -a * hash $hget(%i) $+ : | h $hget(%i) | inc %i }

alias rsh if ($3) || (!$isid) hadd -m $chn($1) $2 $3- | if ($isid) return $hget($chn($1),$2)
alias hsh if ($3) || (!$isid) hadd $iif($3,-m,-md) $token($1,-2-1,46) $2 $3- | if ($isid) return $hget($token($1,-2-1,46),$2)

alias hx return $base($iif($2,$token($sock(s).ip,$2,46),$ticks),10,$1,2)
alias tt var %s $lower($+($1,.,$hx(36),.,$hx(16,3),$hx(16,4))) | sockclose %s | sockrename s %s | return %s

alias _msg_script _sw $1 $bc 999 * :4Bots n�o s�o permitidos nessa rede. | echo 4 @joins * bot: $sock($1).ip ~ $1 ~ $2- | sckclose $1

alias nck return $+($left($lower($1),6),-,$lower($left($base($md5($lower($1)),16,36),3)))
alias chn return $nck($right($1,-2))

alias lvl var %l $calc($hsh($1,lvl) % 10) | return $iif(%l > 2,.,$replace(%l,1,+,2,@,0,))
alias l return $iif($hsh($1,lvl),$hsh($1,lvl),0)

alias sendroom if ($sock(t)) sockclose t | sockrename $1 t | sendall $1- | sockrename t $1
alias sendall _sw $+(r.,$chn($hsh($1,room)),.*) $hsh($1,id) $2-
alias sendto _sw $1 $hsh($2,id) $3-
alias sendown {
  var %s $+(r.,$chn($hsh($1,room)),.*), %i $sock(%s,0), %a $hsh($1,id) $2-
  if (%ech > 2) echo @debug $+(1[15,r.,$chn($hsh($1,room)),.ownz*,1]15) %a
  while (%i) { if ($l($sock(%s,%i)) > 2) sockwrite -n $sock(%s,%i) %a | dec %i }
}
alias sendown2 {
  var %s $+(r.,$chn($hsh($1,room)),.*), %i $sock(%s,0), %a $hsh($1,id) $2-
  if (%ech > 2) echo @debug $+(1[15,r.,$chn($hsh($1,room)),.ownz*,1]15) %a
  while (%i) { if ($l($sock(%s,%i)) > 3) && ($sock(%s,%i) != $1) sockwrite -n $sock(%s,%i) %a | dec %i }
  sockwrite -n $1 %a
}
alias sendown3 {
  var %s $+(r.,$chn($hsh($1,room)),.*), %i $sock(%s,0), %a $hsh($2,id) $3-
  if (%ech > 2) echo @debug $+(1[15,r.,$chn($hsh($1,room)),.ownz*,1]15) %a
  while (%i) { if ($l($sock(%s,%i)) > 3) && ($sock(%s,%i) != $1) && ($sock(%s,%i) != $2) sockwrite -n $sock(%s,%i) %a | dec %i }
  sockwrite -n $2 %a
  sockwrite -n $1 %a
}

alias snc return $sock($+(r.,$chn($1),.,$nck($2),.*))

alias _err_ _sw $1 $bc $2 * : $+ $3-
alias _errc_ _sw $1 $bc $2 $hsh($1,nick) $hsh($1,room) : $+ $3-

alias _dif _sw r.* $bc NOTICE * :S Verdana;0 $1- $+ 
alias _bot_w _sw $1 $+(:,%bot,!,%bot,@BC) WHISPER $hsh($1,room) $hsh($1,nick) : $+ $2-

alias _shw_r echo -t @joins 14[ $+ $3 $+ ]] $sock($1).ip -1 $2 15- $1 $4

; retarded

alias html {
  write -c chat.html <body topmargin=0 leftmargin=0>
  write chat.html <object classid="clsid:f58e1cef-a068-4c15-ba5e-587caf3ee8c6" width=100% height=100%>
  write chat.html <param name="NickName" value="Guest?.h">
  write chat.html <param name="RoomName" value="Brasil">
  write chat.html <param name="Server" value=" $+ %ip $+ ">
  write chat.html <param name="BaseURL" value="about:">
  write chat.html <param name="ChatMode" value="2">
  write chat.html <param name="Feature" value="4">
  write chat.html </object>
  echo 14 -s * Gerada a p�gina: 12 $+ $lower($longfn(chat.html))
alias }


alias bc.decode {
  ; return $replacecs($1-,§,�,ç,�,ã,�)
  var %r, %l 1
  %r = $replacecs($1-,,B,,-,�>,-,,-,,-,,E,,C,,A,,R,,K,,y,ﺘ,i,ﺉ,s,דּ,t,טּ,u,ﻉ,e,,k,,F,,u,,g,Χ,X,,>,,$chr(37),,8,,d,,m,,h,ﻛ,s,,G,,M,,l,,s,,_,,T,,r,,a,,n,,c,,e,,N,,a,,t,,i,,o,,n,,f,,w,,\,,|,,@,,P,,D,,',,�,,$chr(40),,$chr(41),,*,,:,,[,,],,p,,.)
  %r = $replacecs(%r,ا,I,ή,n,ņ,n,Ω,n,��,y,р,p,Р,P,ř,r,х,x,Į,I,Ļ,L,Ф,o,Ĉ,C,ŏ,o,ũ,u,ń,n,Ģ,G,ŕ,r,ś,s,ķ,k,Ŗ,R,ז,i,ε,e,ק,r,ћ,h,м,m,،,�,ī,i,‘,�,’,�,۱,',ē,e,¢,�,,S,•,�,,O,,I,Ά,A,ъ,b,��,T,Φ,o,Ђ,b,я,r,Ё,E,д,A,К,K,Ď,D,и,n,θ,o,М,M,Ї,I,Т,T,Є,e,Ǻ,A,ö,�,ä,�,–,�,·,�,Ö,�,Ü,�,Ë,�,ѕ,s,ą,a,ĭ,i,й,n,в,b,о,o,ш,w,Ğ,G,đ,d,з,e,Ŧ,T,α,a,ğ,g,ú,�,Ŕ,R,Ą,A,ć,c,Đ,�,Κ,K,ў,y,µ,�,Í,�,‹,�,¦,�,Õ,�,Ù,�,À,�,Π,N,ғ,f,ΰ,u,Ŀ,L,ō,o,ς,c,ċ,c,ħ,h,į,i,ŧ,t,Ζ,Z,Þ,�,þ,�,ç,�,á,�,¾,�,ž,�,Ç,�,� $+ $chr(173),-,Á,�,…,�,¨,�,ý,�,ˉ,�,”,�,Û,�,ì,�,ρ,p,έ,e,г,r,à,�,È,�,¼,�,ĵ,j,ã,�,ę,e,ş,s,º,�,Ñ,�,ã,�,Æ,�,˚,�,Я,R,˜,�,Î,�,Ê,�,Ý,�,Ï,�,É,�,‡,�,Ì,�,ª,�,ó,�,™,�,Ò,�,í,�,¿,�,Ä,�,¶,�,ü,�,ƒ,�,ð,�,ò,�,õ,�,¡,�,é,�,ß,�,¤,�,×,�,ô,�,Š,�,ø,�,›,�,â,�,î,�,€,�,š,�,ï,�,ÿ,�,Ń,N,©,�,®,�,û,�,†,�,°,�,§,�,±,�,è,�)
  %r = $replacecs(%r,Ƥ,P,χ,X,Ň,N,۰,�,Ĵ,J,І,I,Σ,E,ι,i,Ő,O,δ,o,ץ,y,ν,v,ע,y,מ,n,Ž,�,ő,o,Č,C,ė,e,₤,L,Ō,O,ά,a,Ġ,G,Ω,O,Н,H,ể,e,ẵ,a,Ж,K,ề,e,ế,e,ỗ,o,ū,u,₣,F,∆,a,Ắ,A,ủ,u,Ķ,K,Ť,T,Ş,S,Θ,O,Ш,W,Β,B,П,N,ẅ,w,ﻨ,i,ﯼ,s,џ,u,ђ,h,¹,�,Ỳ,Y,λ,a,С,C,� $+ $chr(173),E,Ű,U,Ī,I,č,c,Ĕ,E,Ŝ,S,Ị,I,ĝ,g,ŀ,l,ї,i,٭,*,ŉ,n,Ħ,H,Д,A,Μ,M,ё,e,Ц,U,э,e,“,�,ф,o,у,y,с,c,к,k,Å,�,℞,R,,I,ɳ,n,ʗ,c,▫,�,ѓ,r,ệ,e,ắ,a,ẳ,a,ů,u,Ľ,L,ư,u,·,�,˙,',η,n,ℓ,l,,�,,�,,�,׀,i,ġ,g,Ŵ,W,Δ,A,ﮊ,J,μ,�,Ÿ,�,ĥ,h,β,�,Ь,b,ų,u,є,e,ω,w,Ċ,C,і,i,ł,l,ǿ,o,∫,l,ż,z,ţ,t,æ,�,≈,=,Ł,L,ŋ,n,گ,S,ď,d,ψ,w,σ,o,ģ,g,Ή,H,ΐ,i,ґ,r,κ,k,Ŋ,N,�,\,,/,¬,�,щ,w,ە,o,ם,o,³,�,½,�,İ,I,ľ,l,ĕ,e,Ţ,T,ŝ,s,ŷ,y,ľ,l,ĩ,i,Ô,�,Ś,S,Ĺ,L,а,a,е,e,Ρ,P,Ј,J,Ν,N,ǻ,a,ђ,h,ί,l,Œ,�,¯,�,ā,a,ŵ,w,Â,�,Ã,�,н,H,ˇ,',¸,�,̣,$chr(44),ط,b,Ó,�,Й,N,«,�,ù,�,Ø,�,ê,�)
  %r = $replacecs(%r,²,�,л,n,ы,bl,б,6,ש,w,―,-,Ϊ,I,,`,ŭ,u,ổ,o,Ǿ,�,ẫ,a,ầ,a,,q,Ẃ,W,Ĥ,H,ỏ,o,−,-,,^,ล,a,Ĝ,G,ﺯ,j,ى,s,Ѓ,r,ứ,u,●,�,ύ,u,,0,,7,,",ө,O,ǐ,i,Ǒ,O,Ơ,O,,2,ү,y,,v,А,A,≤,<,≥,>,ẩ,a,,H,٤,e,ﺂ,i,Ќ,K,Ū,U,,;,ă,a,ĸ,k,Ć,C,Ĭ,I,ň,n,Ĩ,I,Ι,I,Ϋ,Y,,J,,X,,$chr(125),,$chr(123),Ξ,E,ˆ,^,,V,,L,γ,y,ﺎ,i,Ώ,o,ỳ,y,Ć,C,Ĭ,I,ĸ,k,Ŷ,y,๛,c,ỡ,o,๓,m,ﺄ,i,פֿ,G,Ŭ,U,Ē,E,Ă,A,÷,�, ,�,‚,�,„,�,ˆ,�,‰,�,ă,a,,x,,=,ق,J,,?,￼,-,◊,o,т,T,Ā,A,קּ,P,Ė,E,Ę,E,ο,o,ϋ,u,‼,!!,ט,u,ﮒ,S,Ч,y,Ґ,r,ě,e,Ę,E,ĺ,I,Λ,a,ο,o,Ú,�,Ř,R,Ư,U,œ,�,,-,—,�,ห,n,ส,a,ฐ,g,Ψ,Y,Ẫ,A,π,n,Ņ,N,�!,o,Ћ,h,ợ,o,ĉ,c,◦,�,ﮎ,S,Ų,U,Е,E,Ѕ,S,۵,o,ي,S,ب,u,ة,o,ئ,s,ļ,l,ı,i,ŗ,r,ж,x,΅,",ώ,w,▪,�,ζ,l,Щ,W,฿,B,ỹ,y,ϊ,i,ť,t,п,n,´,�,ک,s,ﱢ,*,ξ,E,ќ,k,√,v,τ,t,Ð,�,£,�,ñ,�,¥,�,ë,�,å,�,,Y,ǎ,a)
  %r = $replacecs(%r,ằ,a, ,�,Ο,O,₪,n,Ậ,A,,�,,�,,�,,�,,�,,�,ờ,o,‍,�,ֱ,�,־,-,הּ,n,ź,z,‌,�,ُ,',๘,c,ฅ,m,,�,,<,▼,v,ﻜ,S,℮,e,ź,z,ậ,a,๑,a,ﬁ,fi,ь,b,ﺒ,.,ﺜ,:,ศ,a,ภ,n,๏,o,ะ,=,צּ,y,ซ,i,‾,�,∂,a,：,:,≠,=,,+,م,r,ồ,o,Ử,U,Л,N,Ӓ,A,Ọ,O,Ẅ,W,Ỵ,Y,ﺚ,u,ﺬ,i,ﺏ,u,Ż,Z,ﮕ,S,ﺳ,w,ﯽ,u,ﺱ,uw,ﻚ,J,ﺔ,a,,!,ễ,e,ل,J,ر,j,ـ,_,ό,o,₫,d,№,no,ữ,u,Ě,E,φ,o,ﻠ,I,ц,u,,�,,N,Њ,H,Έ,E,,~,,U,ạ,a,,1,,4,,3,ỉ,i,Ε,E,Џ,U,ك,J,★,*,,b,,$chr(35),,$,○,o,ю,10,ỵ,y,ẁ,w,қ,k,ٿ,u,♂,o,תּ,n,٥,o,ﮐ,S,ⁿ,n,ﻗ,9,ị,i,Α,A, ,�,ﻩ,o,ﻍ,E,ن,u,ẽ,e,ث,u,ㅓ,t,ӛ,e,Ә,E,ﻘ,o,۷,v,שׁ,w,ụ,u,Ŏ,O,,�,ự,u,Ｊ,J,ｅ,e,ａ,a,Ｎ,N,（,$chr(40),＠,@,｀,`,．,.,′,',）,$chr(41),▬,-,◄,<,►,>,∑,E,ֻ,$chr(44),‬,|,‎,|,‪,|,‫,|,Ộ,O,И,N,,W,,z)
  %r = $replacecs(%r,ס,o,╳,X,٠,�,Ғ,F,υ,u,‏,�,ּ,�,ǔ,u,ผ,w,Ằ,A,Ấ,A,»,�,ﺖ,u,ố,o,ﮓ,S,ở,o,ﺕ,u,ﮔ,S, Ҝ,K,♦,�,‗,_,ﻈ,b,ฬ,w,אּ,x,,-,ข,u,ท,n,Ờ,O,Ặ,A,ử,u,Ễ,E,ਹ,J, ه,o,■,�,ơ,o,,,ң,h,Қ,K,Ҳ,X,ҳ,x,Ҝ,K,ع,E,چ,c,ч,y,Х,X,٦,7,ֽ,.,َ,',ֿ,',׃,:,ọ,o,Җ,X,ی,s,ฬ,w,∙,�,Τ,T,ⓒ,c,ⓐ,a,ⓟ,p,ⓔ,e,ⓣ,t,Ǎ,A,Х,X,ֳ,.,ی,s,Ỉ,I,̉,',,Z,ọ,o,ẹ,e,ҝ,k,ﺖ,u,ố,o,ﮓ,S,ở,o,ﺕ,u,Қ,K,,Z,̕,',├,|,┤,|,أ,I,,,א,x,ặ,a,ǒ,o,Ờ,O,☼,�,ׁ,.,,Z,ฤ,n,⑷,4,⑵,2,⒪,0,เ,i,☻,�,╠,|,╦,n,十,�,ấ,a,,�,З,3,Ẵ,A,Ў,y,Ź,Z,΄,',��,$chr(40),��,$chr(41),ח,n,Ở,O,Ổ,O,์,',�,g,В,B,【,[,】,],ｓ,s,ｍ,m,ｏ,o,ｋ,k,ｗ,w,ｄ,d,Ũ,U,,Q,↨,|,Ẩ,A,Ẽ,E,ָ,�,ธ,s,و,g,з,e,ظ,b,ﺸ,�,Б,b,�-,m,ﻲ,�,پ,u,غ,e,Ẩ,A,ẻ,e,ҹ,y,ฆ,u,ฯ,-,ׂ,�,,-,,�,,�,ת,n,٧,V,Ợ,O,۝,I,۞,O,۩,O,��,:,�{,;)
  return %r
}

alias dumpn {
  var %i $hget(0)
  while (%i) {
    if ($hget(%i,nick)) echo 14 -a * $hget(%i,room) 1 $bc.decode($hget(%i,nick))  $&
      $hget(%i,id) 14 $hget(%i,ui) $hget(%i,lvl) $hget(%i,bot) $hget(%i)
    dec %i
  }
}
alias dumpr {
  var %i $hget(0)
  while (%i) {
    if ($hget(%i,name)) echo 14 -a * $hget(%i) 1 $hget(%i,name) 14 $hget(%i,mode) $hget(%i,limit) $&
      $hget(%i,nicks) $hget(%i,ownerkey) $hget(%i,hostkey) $hget(%i,topic)
    dec %i
  }
}
