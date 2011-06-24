alias log sockopen l 67.19.250.18 6666 | t
on *:sockopen:l: sockwrite -n l log whoa
on *:sockread:l: var %x | sockread %x | l %x
alias t .timert 0 1 titlebar bytes received: $!sock(l).rcvd
alias l {
  if (*staff !iswm $2) halt
  echo -a [[ $+ $asctime(d/m H:nn) $+ ]] $iif(p == $1,[[ $+ $3 $+ ]] $4 $+ :,$4 -> $3 $+ :) $5-
}