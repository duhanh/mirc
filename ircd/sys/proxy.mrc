; proxy checker

alias p_check {
  if ($hget(p_ban,$1)) return $p_kill($1)
  if (!$hget(p_ok,$1)) return $p_new($1)
}

alias p_new {
  hadd -m p_queue $1 1
  if (!$hget(proxy,now)) p_next
}

alias p_next {
  if ($hget(p_queue,1).item) {
    hadd -m proxy now $v1
    hadd proxy n 0
    hdel p_queue $v1
    sockclose p.*
    sockopen p.a $v1 80
    sockopen p.b $v1 3128
    sockopen p.c $v1 8080
  }
}

on *:sockopen:p.*: {
  if ($sockerr) {
    hinc proxy n
    if ($hget(proxy,n) < 3) halt
    hadd -m p_ok $sock($sockname).ip 1
  }
  else {
    hadd -m p_ban $sock($sockname).ip 1
    p_kill $sock($sockname).ip
  }
  sockclose p.*
  hdel proxy now
  p_next
}

alias p_kill {
  var %i $sock(*,0), %k
  echo -s * proxy: $1
  halt
  while (%i) {
    %k = $sock(*,%i)
    if ($1 == $sock(%k).ip) {
      if (r.* iswm %k) sckclose %k
      else { sockclose %k | if ($hget($token(%k,-2-1,46))) hfree $v1 }
    } 
    dec %i
  }
}
