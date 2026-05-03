; animation script
; off_18FE2:
Ani_obj41:	offsetTable
		offsetTableEntry.w byte_18FEE	; 0
		offsetTableEntry.w byte_18FF1	; 1
		offsetTableEntry.w byte_18FFD	; 2
		offsetTableEntry.w byte_19000	; 3
		offsetTableEntry.w byte_1900C	; 4
		offsetTableEntry.w byte_1900F	; 5
byte_18FEE:
	dc.b  $F
	dc.b   0	; 1
	dc.b $FF	; 2
	rev02even
byte_18FF1:
	dc.b   0
	dc.b   1	; 1
	dc.b   0	; 2
	dc.b   0	; 3
	dc.b   2	; 4
	dc.b   2	; 5
	dc.b   2	; 6
	dc.b   2	; 7
	dc.b   2	; 8
	dc.b   2	; 9
	dc.b $FD	; 10
	dc.b   0	; 11
	rev02even
byte_18FFD:
	dc.b  $F
	dc.b   3	; 1
	dc.b $FF	; 2
	rev02even
byte_19000:
	dc.b   0
	dc.b   4	; 1
	dc.b   3	; 2
	dc.b   3	; 3
	dc.b   5	; 4
	dc.b   5	; 5
	dc.b   5	; 6
	dc.b   5	; 7
	dc.b   5	; 8
	dc.b   5	; 9
	dc.b $FD	; 10
	dc.b   2	; 11
	rev02even
byte_1900C:
	dc.b  $F
	dc.b   7	; 1
	dc.b $FF	; 2
	rev02even
byte_1900F:
	dc.b   0
	dc.b   8	; 1
	dc.b   7	; 2
	dc.b   7	; 3
	dc.b   9	; 4
	dc.b   9	; 5
	dc.b   9	; 6
	dc.b   9	; 7
	dc.b   9	; 8
	dc.b   9	; 9
	dc.b $FD	; 10
	dc.b   4	; 11
	even
