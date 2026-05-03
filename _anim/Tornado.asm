; animation script
; off_3AFDC:
Ani_objB2_a:	offsetTable
		offsetTableEntry.w byte_3AFE0	; 0
		offsetTableEntry.w byte_3AFE6	; 1
byte_3AFE0:	dc.b   0,  0,  1,  2,  3,$FF
byte_3AFE6:	dc.b   0,  4,  5,  6,  7,$FF
		even
; animation script
; off_3AFEC:
Ani_objB2_b:	offsetTable
		offsetTableEntry.w +	; 0
; byte_3AFEE:
+		dc.b   0,  1,  2,$FF
		even
