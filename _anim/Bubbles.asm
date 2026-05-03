; animation script for the bubbles
; off_1D860:
Ani_obj0A:	offsetTable
		offsetTableEntry.w byte_1D87E	;  0
		offsetTableEntry.w byte_1D887	;  1
		offsetTableEntry.w byte_1D890	;  2
		offsetTableEntry.w byte_1D899	;  3
		offsetTableEntry.w byte_1D8A2	;  4
		offsetTableEntry.w byte_1D8AB	;  5
		offsetTableEntry.w byte_1D8B4	;  6
		offsetTableEntry.w byte_1D8B9	;  7
		offsetTableEntry.w byte_1D8C1	;  8
		offsetTableEntry.w byte_1D8C9	;  9
		offsetTableEntry.w byte_1D8D1	; $A
		offsetTableEntry.w byte_1D8D9	; $B
		offsetTableEntry.w byte_1D8E1	; $C
		offsetTableEntry.w byte_1D8E9	; $D
		offsetTableEntry.w byte_1D8EB	; $E
byte_1D87E:	dc.b   5,  0,  1,  2,  3,  4,  8,  8,$FC
	rev02even
byte_1D887:	dc.b   5,  0,  1,  2,  3,  4,  9,  9,$FC
	rev02even
byte_1D890:	dc.b   5,  0,  1,  2,  3,  4, $A, $A,$FC
	rev02even
byte_1D899:	dc.b   5,  0,  1,  2,  3,  4, $B, $B,$FC
	rev02even
byte_1D8A2:	dc.b   5,  0,  1,  2,  3,  4, $C, $C,$FC
	rev02even
byte_1D8AB:	dc.b   5,  0,  1,  2,  3,  4, $D, $D,$FC
	rev02even
byte_1D8B4:	dc.b  $E,  0,  1,  2,$FC
	rev02even
byte_1D8B9:	dc.b   7,$10,  8,$10,  8,$10,  8,$FC
	rev02even
byte_1D8C1:	dc.b   7,$10,  9,$10,  9,$10,  9,$FC
	rev02even
byte_1D8C9:	dc.b   7,$10, $A,$10, $A,$10, $A,$FC
	rev02even
byte_1D8D1:	dc.b   7,$10, $B,$10, $B,$10, $B,$FC
	rev02even
byte_1D8D9:	dc.b   7,$10, $C,$10, $C,$10, $C,$FC
	rev02even
byte_1D8E1:	dc.b   7,$10, $D,$10, $D,$10, $D,$FC
	rev02even
byte_1D8E9:	dc.b  $E,$FC
	rev02even
byte_1D8EB:	dc.b  $E,  1,  2,  3,  4,$FC
	even
