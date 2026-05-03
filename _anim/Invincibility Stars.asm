; Animation script
		dc.w   $F00,  $F03,  $E06,  $D08,  $B0B,  $80D,  $60E,  $30F
		dc.w    $10, -$3F1, -$6F2, -$8F3, -$BF5, -$DF8, -$EFA, -$FFD
		dc.w  $F000, -$F04, -$E07, -$D09, -$B0C, -$80E, -$60F, -$310
		dc.w   -$10,  $3F0,  $6F1,  $8F2,  $BF4,  $DF7,  $EF9,  $FFC

byte_1DB82:	dc.b   8,  5,  7,  6,  6,  7,  5,  8,  6,  7,  7,  6,$FF
	rev02even
byte_1DB8F:	dc.b   8,  7,  6,  5,  4,  3,  4,  5,  6,  7,$FF
		dc.b   3,  4,  5,  6,  7,  8,  7,  6,  5,  4
	rev02even
byte_1DBA4:	dc.b   8,  7,  6,  5,  4,  3,  2,  3,  4,  5,  6,  7,$FF
		dc.b   2,  3,  4,  5,  6,  7,  8,  7,  6,  5,  4,  3
	rev02even
byte_1DBBD:	dc.b   7,  6,  5,  4,  3,  2,  1,  2,  3,  4,  5,  6,$FF
		dc.b   1,  2,  3,  4,  5,  6,  7,  6,  5,  4,  3,  2
	even
