alias x sockclose * | sockopen x 200.185.63.19 5740 | set %a 'RPGChat | set %r $(%#RPG,0) | set %n Merry
alias s echo -a $1- | sockwrite -n x $1-
alias z s join %r | set %l $iif($1,$1,20)
on *:sockopen:x: s auth - -
on *:sockread:x: {
  var %x | sockread %x | echo 14 -a %x | tokenize 32 %x
  if ($1 == auth) {
    %x = $token($read($scriptdir $+ auth.dat,s,$mid($unescap($tohex($mid($4,7))),3,4)),2,32)
    if ($3 == s) s auth - s xxxxxx $+ $unhex($escap($str(0,22) $+ %x))
    else s nick %n
  }
  if (join == $2) s whisper %r %a : $+ !login tolkien
  if (mode == $2) s privmsg %r :!desafiar Frodo $lf part %r
  if (part == $2) { if (%l) { s join %r | dec %l } }
}
alias tohex { var %l 1, %r | while (%l <= $len($1-)) { %r = %r $+ $base($asc($mid($1-,%l,1)),10,16,2) | inc %l 1 } | return %r }
alias unhex { var %l 1, %r, %c | while (%l <= $len($1-)) { %c = $chr($base($mid($1-,%l,2),16,10)) | %r = $iif(%c == $chr(32),%r %c,%r $+ %c) | inc %l 2 } | return %r }
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
