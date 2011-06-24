alias getHex var %z 8 ^ 8 | while (%z > 1) var %z %z / 16,%r %r $+ $chr($calc($iif($calc($rgb($3,$2,$1)% $v1 /%z) < 10,48,55)+$v1)) | return %r

; code evolution lol
;alias getHex var %z 8 ^ 8 | while (%z > 1) var %z %z / 16,%m $calc($rgb($3,$2,$1)% $v1 /%z),%r %r $+ $chr($calc($len($or(%m))*7+41+%m)) | return %r
;alias getHex var %z 8 ^ 8 | while (%z > 1) var %n $rgb($3,$2,$1) % %z,%z %z / 16,%m %n / %z,%r %r $+ $chr($calc($len($or(%m))*7+41+%m)) | return %r
;alias getHex var %z 8 ^ 8 | while (%z > 1) var %n $rgb($3,$2,$1) % %z,%z %z / 16,%m %n / %z,%r %r $+ $chr($calc($iif(%m < 10,48,55)+%m)) | return %r
;alias getHex var %z 16777216 | while (%z > 1) var %n $rgb($3,$2,$1) % %z,%z %z / 16,%m %n / %z,%r %r $+ $chr($calc($iif(%m > 9,55,48)+%m)) | return %r
;alias getHex var %n $rgb($3,$2,$1),%z 1048576 | while ($int(%z)) var %m %n / %z,%n %n % %z,%z %z / 16,%r %r $+ $chr($calc($iif(%m > 9,55,48)+%m)) | return %r
;alias getHex var %n $rgb($3,$2,$1),%z 1048576 | while ($int(%z)) var %r %r $+ $chr($calc($len($int($calc(%n /%z)))*7+41+%n /%z)),%n %n % %z,%z %z / 16 | return %r
;alias getHex var %n $rgb($3,$2,$1),%z 1048576 | while ($int(%z)) var %m %n / %z,%n %n % %z,%m %m - %n,%m %m / %z,%z %z / 16,%r %r $+ $chr($calc($len($int(%m))*7+41+%m) | return %r
;alias getHex var %r,%n $rgb($3,$2,$1),%z 1048576 | while ($int(%z)) var %m %n / %z,%n %n % %z,%z %z / 16,%m $iif(%m > 9,55,48) + %m,%r %r $+ $chr(%m) | return %r
;alias getHex var %r,%n $rgb($3,$2,$1),%z 1048576 | while ($int(%z)) var %m %n / %z,%n %n % %z,%z %z / 16,%r %r $+ $chr($calc($len($int(%m))*7+41+%m)) | return %r
;alias getHex var %r,%n $rgb($3,$2,$1) | while $int(%n) { var %m $v1 % 16,%n $v1 / 16 | %r = $iif(%m > 9,$chr($calc(55+%m)),%m) $+ %r } | return $str(0,$calc(6-$len(%r))) $+ %r
;alias getHex var %r,%n $rgb($3,$2,$1) | while ($int(%n)) var %m $v1 % 16,%n $v1 / 16,%r $replace(%m,10,A,11,B,12,C,13,D,14,E,15,F) $+ %r | return $str(0,$calc(6-$len(%r))) $+ %r
;alias getHex var %r,%n $rgb($3,$2,$1) | while %n { var %m %n % 16,%n $calc((%n -%m)/16) | %r = $iif(%m > 9,$chr($calc(55+%m)),%m) $+ %r } | return $str(0,$calc(6-$len(%r))) $+ %r
; by lzm ;D
