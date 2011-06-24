; msn_

on *:signal:end: { }

on *:signal:init: { }

on *:signal:txt: {
  var %e $1 | tokenize 32 $2-

  if (0) { _mod_dutch %e $1- | halt }

  if (0) && (mister_bolonhas* iswm %e) { _mod_mb %e $1- | halt }

}

alias r say_ $1- | halt

alias _mod_mb {
  var %9 $chr(40), %0 $chr(41), %? $chr(63)

  var %e r $1, %a $2-
  tokenize 32 %a

  if (ae == %a) %e dae..
  if (ow == %a) %e q?
  if ($+(%9,y,%0) == %a) %e (y)
  if (rlz == %a) %e eh
  if (flw == %a) %e flw
  if (t+ == %a) %e flw ae
  if (fui* iswm %a) %e flw
  if (rlz:? iswm %a) %e eh : $+ $right(%a,1)
  if (ow $+(*,%?,*) iswm %a) %e sei la
  if (eh * neh*  iswm %a) %e deve ser
  if (q preula * iswm %a) %e sei la po
  if (q * eh ess* iswm %a) %e sei la po
  if (como eu $+(*, %?,*) iswm %a) %e se vira kct
  if (*:^ $+ %0 iswm %a) %e eh:^)
  if (mau * iswm %a) %e eh nada
  if (q * :o iswm %a) %e sei la
  if (:d == %a) %e uahuah
  if (*:d iswm %a) %e eh:P
  if (*:p iswm %a) %e eh:P
  if (:d* iswm %a) %e soh ;D
  if (:p == %a) %e bah :p
  if (*:| iswm %a) %e :|
  if (*nao*fun?a* iswm %a) %e aff:s
  if (*sux* iswm %a) %e aff:s eh
  if (aé* iswm %a) %e tanso
  if (* $+ %? iswm %a) %e sei la
  if (*:s* iswm %a) %e aff:s
  if (*fodz* iswm %a) %e eh
  if (neh $+ %? iswm %a) %e eh^o)
}

alias _mod_dutch {
  var %x | %x = $token(%t,%2,9)

  if (*- iswm $2-) || (* $+ %x $+ * iswm $2-) {
    set %t $read(c:\windows\desktop\dutch\les vier fmt.txt)
    say_ $1 $iif(%x $+ * iswm $2-,goed!,het echt antwoord was:) $+(%x,$crlf,$crlf,$token(%t,%1,9))
  }
  if (x == $2) {
    if ($3 == a) set %1 $4
    if ($3 == b) set %2 $4
    say_ $1 a: %1 b: %2
  }
}
