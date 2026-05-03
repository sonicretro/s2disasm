; animation script
; off_1958E:
Ani_obj0D:	offsetTable
		offsetTableEntry.w byte_19598	; 0
		offsetTableEntry.w byte_1959B	; 1
		offsetTableEntry.w byte_195A9	; 2
		offsetTableEntry.w byte_195B7	; 3
		offsetTableEntry.w byte_195BA	; 4
byte_19598:	dc.b	$0F, $02, $FF
	rev02even
byte_1959B:	dc.b	$01, $02, $03, $04, $05, $01, $03, $04, $05, $00, $03, $04, $05, $FF
	rev02even
byte_195A9:	dc.b	$01, $02, $03, $04, $05, $01, $03, $04, $05, $00, $03, $04, $05, $FF
	rev02even
byte_195B7:	dc.b	$0F, $00, $FF
	rev02even
byte_195BA:	dc.b	$0F, $01, $FF
	even
