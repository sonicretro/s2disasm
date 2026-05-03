; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_C258:
InitCameraValues:
	tst.b	(Last_star_pole_hit).w	; was a star pole hit yet?
	bne.s	+			; if yes, branch
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	d0,(Camera_BG2_Y_pos).w
	move.w	d1,(Camera_BG_X_pos).w
	move.w	d1,(Camera_BG2_X_pos).w
	move.w	d1,(Camera_BG3_X_pos).w
	move.w	d0,(Camera_BG_Y_pos_P2).w
	move.w	d0,(Camera_BG2_Y_pos_P2).w
	move.w	d1,(Camera_BG_X_pos_P2).w
	move.w	d1,(Camera_BG2_X_pos_P2).w
	move.w	d1,(Camera_BG3_X_pos_P2).w
+
	moveq	#0,d2
	move.b	(Current_Zone).w,d2
	add.w	d2,d2
	move.w	InitCam_Index(pc,d2.w),d2
	jmp	InitCam_Index(pc,d2.w)
; End of function InitCameraValues

; ===========================================================================
; off_C296:
InitCam_Index: zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w InitCam_EHZ	; EHZ
	zoneOffsetTableEntry.w InitCam_Null0	; Zone 1
	zoneOffsetTableEntry.w InitCam_WZ	; WZ
	zoneOffsetTableEntry.w InitCam_Null0	; Zone 3
	zoneOffsetTableEntry.w InitCam_Std	; MTZ1,2
	zoneOffsetTableEntry.w InitCam_Std	; MTZ3
	zoneOffsetTableEntry.w InitCam_Null1	; WFZ
	zoneOffsetTableEntry.w InitCam_HTZ	; HTZ
	zoneOffsetTableEntry.w InitCam_HPZ	; HPZ
	zoneOffsetTableEntry.w InitCam_Null2	; Zone 9
	zoneOffsetTableEntry.w InitCam_OOZ	; OOZ
	zoneOffsetTableEntry.w InitCam_MCZ	; MCZ
	zoneOffsetTableEntry.w InitCam_CNZ	; CNZ
	zoneOffsetTableEntry.w InitCam_CPZ	; CPZ
	zoneOffsetTableEntry.w InitCam_Null3	; DEZ
	zoneOffsetTableEntry.w InitCam_ARZ	; ARZ
	zoneOffsetTableEntry.w InitCam_SCZ	; SCZ
    zoneTableEnd
; ===========================================================================
;loc_C2B8:
InitCam_EHZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_Y_pos).w
	clr.l	(Camera_BG2_Y_pos).w
	clr.l	(Camera_BG3_Y_pos).w
	lea	(TempArray_LayerDef).w,a2
	clr.l	(a2)+
	clr.l	(a2)+
	clr.l	(a2)+
	clr.l	(Camera_BG_X_pos_P2).w
	clr.l	(Camera_BG_Y_pos_P2).w
	clr.l	(Camera_BG2_Y_pos_P2).w
	clr.l	(Camera_BG3_Y_pos_P2).w
	rts
; ===========================================================================
; wtf:
InitCam_Null0:
    if gameRevision=0
	rts
    endif
; ===========================================================================
; Wood_Zone_BG:
InitCam_WZ:
    if gameRevision=0
	asr.w	#2,d0
	addi.w	#$400,d0
	move.w	d0,(Camera_BG_Y_pos).w
	asr.w	#3,d1
	move.w	d1,(Camera_BG_X_pos).w
	rts
    endif
; ===========================================================================
;loc_C2E4:
InitCam_Std:
	asr.w	#2,d0
	move.w	d0,(Camera_BG_Y_pos).w
	asr.w	#3,d1
	move.w	d1,(Camera_BG_X_pos).w
	rts
; ===========================================================================
;return_C2F2:
InitCam_Null1:
	rts
; ===========================================================================
;loc_C2F4:
InitCam_HTZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_Y_pos).w
	clr.l	(Camera_BG2_Y_pos).w
	clr.l	(Camera_BG3_Y_pos).w
	lea	(TempArray_LayerDef).w,a2
	clr.l	(a2)+
	clr.l	(a2)+
	clr.l	(a2)+
	clr.l	(Camera_BG_X_pos_P2).w
	clr.l	(Camera_BG_Y_pos_P2).w
	clr.l	(Camera_BG2_Y_pos_P2).w
	clr.l	(Camera_BG3_Y_pos_P2).w
	rts
; ===========================================================================
; Hidden_Palace_Zone_BG:
InitCam_HPZ:
    if gameRevision=0
	asr.w	#1,d0
	move.w	d0,(Camera_BG_Y_pos).w
	clr.l	(Camera_BG_X_pos).w
	rts
    endif
; ===========================================================================
; Leftover Spring Yard Zone code from Sonic 1

; Unknown_Zone_BG:
;InitCam_SYZ:
    if gameRevision=0
	asl.l	#4,d0
	move.l	d0,d2
	asl.l	#1,d0
	add.l	d2,d0
	asr.l	#8,d0
	addq.w	#1,d0
	move.w	d0,(Camera_BG_Y_pos).w
	clr.l	(Camera_BG_X_pos).w
	rts
    endif

; ===========================================================================
;return_C320:
InitCam_Null2:
	rts
; ===========================================================================
;loc_C322:
InitCam_OOZ:
	lsr.w	#3,d0
	addi.w	#$50,d0
	move.w	d0,(Camera_BG_Y_pos).w
	clr.l	(Camera_BG_X_pos).w
	rts
; ===========================================================================
;loc_C332:
InitCam_MCZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_X_pos_P2).w
	tst.b	(Current_Act).w
	bne.s	+
	divu.w	#3,d0
	subi.w	#$140,d0
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	d0,(Camera_BG_Y_pos_P2).w
	rts
; ===========================================================================
+
	divu.w	#6,d0
	subi.w	#$10,d0
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	d0,(Camera_BG_Y_pos_P2).w
	rts
; ===========================================================================
;loc_C364:
InitCam_CNZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_Y_pos).w
	clr.l	(Camera_BG_Y_pos_P2).w
	rts
; ===========================================================================
;loc_C372:
InitCam_CPZ:
	lsr.w	#2,d0
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	d0,(Camera_BG_Y_pos_P2).w
	lsr.w	#1,d1
	move.w	d1,(Camera_BG2_X_pos).w
	lsr.w	#2,d1
	move.w	d1,(Camera_BG_X_pos).w
	rts
; ===========================================================================
;return_C38A:
InitCam_Null3:
	rts
; ===========================================================================
;loc_C38C:
InitCam_ARZ:
	tst.b	(Current_Act).w
	beq.s	+
	subi.w	#$E0,d0
	lsr.w	#1,d0
	move.w	d0,(Camera_BG_Y_pos).w
	bra.s	loc_C3A6
; ===========================================================================
+
	subi.w	#$180,d0
	move.w	d0,(Camera_BG_Y_pos).w

loc_C3A6:
	muls.w	#$119,d1
	asr.l	#8,d1
	move.w	d1,(Camera_BG_X_pos).w
	move.w	d1,(Camera_ARZ_BG_X_pos).w
	clr.w	(Camera_BG_X_pos+2).w
	clr.w	(Camera_ARZ_BG_X_pos+2).w
	clr.l	(Camera_BG2_Y_pos).w
	clr.l	(Camera_BG3_Y_pos).w
	rts
; ===========================================================================
;loc_C3C6:
InitCam_SCZ:
	clr.l	(Camera_BG_X_pos).w
	clr.l	(Camera_BG_Y_pos).w
	rts
