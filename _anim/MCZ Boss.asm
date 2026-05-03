; off_3160A: Obj57_AnimIndex:
Ani_obj57:	offsetTable
		offsetTableEntry.w byte_31628 ; 0 - main vehicle
		offsetTableEntry.w byte_3162E ; 1 - digger diagonal
		offsetTableEntry.w byte_31631 ; 2 - hover fire thingies to keep boss in air
		offsetTableEntry.w byte_31638 ; 3 - digger vertical animated 1 -> (4)
		offsetTableEntry.w byte_31649 ; 4 - digger vertical animated 2 -> (5)
		offsetTableEntry.w byte_3165A ; 5 - digger vertical animated 3 (loop)
		offsetTableEntry.w byte_31661 ; 6 - digger vertical animated 4 -> (7)
		offsetTableEntry.w byte_31673 ; 7 - digger vertical + diagonal transition -> (8)
		offsetTableEntry.w byte_31684 ; 8 - digger horizontal animated 1 -> (9)
		offsetTableEntry.w byte_31695 ; 9 - digger horizontal animated 2 -> (A)
		offsetTableEntry.w byte_316A6 ; A - digger horizontal animated 3 (loop)
		offsetTableEntry.w byte_316AD ; B - digger horizontal animated 4 -> (C)
		offsetTableEntry.w byte_316BF ; C - digger horizontal + diagonal transition -> (3)
		offsetTableEntry.w byte_316D1 ; D - center vehicle, Robotnik's face normal
		offsetTableEntry.w byte_316E8 ; E - center vehicle, Robotnik's face when hit
byte_31628:	dc.b  $F,  1,$FF	; light off
		dc.b	   0,$FC,  2	; light on; (3) subanimation
	rev02even
byte_3162E:	dc.b   5,  8,$FF
	rev02even
byte_31631:	dc.b   1,  5,  6,$FF	; fire on
		dc.b	   7,$FC,  3	; fire off; (4) subanimation
	rev02even
byte_31638:	dc.b   1,  2,  2,  2,  2,  2,  3,  3,  3,  3,  3,  4,  4,  4,  4,$FD,  4
	rev02even
byte_31649:	dc.b   1,  2,  2,  2,  2,  3,  3,  3,  4,  4,  4,  2,  2,  3,  3,$FD,  5
	rev02even
byte_3165A:	dc.b   1,  4,  2,  3,  4,$FC,  1
	rev02even
byte_31661:	dc.b   1,  2,  3,  4,  4,  2,  2,  3,  3,  3,  4,  4,  4,  2,  2,  2,$FD,  7
	rev02even
byte_31673:	dc.b   1,  2,  3,  3,  3,  3,  4,  4,  4,  4,  4,  2,  8,  8,  8,$FD,  8
	rev02even
byte_31684:	dc.b   1,  9,  9,  9,  9,  9, $A, $A, $A, $A, $A, $B, $B, $B, $B,$FD,  9
	rev02even
byte_31695:	dc.b   1,  9,  9,  9,  9, $A, $A, $A, $B, $B, $B,  9,  9, $A, $A,$FD, $A
	rev02even
byte_316A6:	dc.b   1, $B,  9, $A, $B,$FC,  1
	rev02even
byte_316AD:	dc.b   1,  9, $A, $B, $B,  9,  9, $A, $A, $A, $B, $B, $B,  9,  9,  9,$FD, $C
	rev02even
byte_316BF:	dc.b   1,  9, $A, $A, $A, $A, $B, $B, $B, $B, $B,  9,  8,  8,  8,  8,$FD,  3
	rev02even
byte_316D1:	dc.b   7, $E, $F,$FF
		dc.b	 $10,$11,$10,$11,$10,$11,$10,$11,$FF		; (4) subanimation (grin after hurting Sonic)
		dc.b	 $12,$12,$12,$12,$12,$12,$12,$12,$12,$FF	; (D) subanimation (grin when hit)
	rev02even
byte_316E8:	dc.b   7,$12,$FF
	even
