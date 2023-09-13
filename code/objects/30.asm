; ===========================================================================
; ----------------------------------------------------------------------------
; Object 30 - Large rising lava during earthquake in HTZ
; ----------------------------------------------------------------------------
; Sprite_238DC:
Obj30:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj30_Index(pc,d0.w),d1
	jmp	Obj30_Index(pc,d1.w)
; ===========================================================================
; off_238EA:
Obj30_Index:	offsetTable
		offsetTableEntry.w Obj30_Init	; 0
		offsetTableEntry.w Obj30_Main	; 2
; ===========================================================================
; byte_238EE:
Obj30_Widths:
	dc.b $C0
	dc.b   0	; 1
	dc.b $C0	; 2
	dc.b   0	; 3
	dc.b $C0	; 4
	dc.b   0	; 5
	dc.b $E0	; 6
	dc.b   0	; 7
	dc.b $C0	; 8
	dc.b   0	; 9
	even
; ===========================================================================
; loc_238F8:
Obj30_Init:
	addq.b	#2,routine(a0)
	move.w	y_pos(a0),objoff_32(a0)
	move.w	x_pos(a0),objoff_30(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	move.b	Obj30_Widths(pc,d0.w),width_pixels(a0)
	cmpi.b	#6,d0
	blo.s	Obj30_Main
	bne.s	+
	cmpi.w	#$380,(Camera_Y_pos).w
	bhs.s	Obj30_Main
	bra.s	++
; ===========================================================================
+
	cmpi.w	#$380,(Camera_Y_pos).w
	blo.s	Obj30_Main
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
+
	jmpto	DeleteObject, JmpTo23_DeleteObject
; ===========================================================================
; loc_23944:
Obj30_Main:
	move.w	objoff_32(a0),d0
	add.w	(Camera_BG_Y_offset).w,d0
	move.w	d0,y_pos(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	move.w	Obj30_Modes(pc,d0.w),d1
	jsr	Obj30_Modes(pc,d1.w)
	tst.b	(Screen_Shaking_Flag_HTZ).w
	beq.w	JmpTo2_MarkObjGone3
	rts
; ===========================================================================
; off_23968:
Obj30_Modes:	offsetTable
		offsetTableEntry.w loc_23972	; 0
		offsetTableEntry.w loc_23972	; 2
		offsetTableEntry.w loc_2398A	; 4
		offsetTableEntry.w loc_239D0	; 6
		offsetTableEntry.w loc_239EA	; 8
; ===========================================================================

loc_23972:
	move.w	#$CB,d1
	move.w	#$80,d2
	move.w	#$81,d3
	move.w	x_pos(a0),d4
	jsrto	SolidObject_Always, JmpTo_SolidObject_Always
	jmpto	DropOnFloor, JmpTo_DropOnFloor
; ===========================================================================

loc_2398A:
	move.w	#$CB,d1
	move.w	#$78,d2
	move.w	#$79,d3
	move.w	x_pos(a0),d4
	jsrto	SolidObject_Always, JmpTo_SolidObject_Always
	jsrto	DropOnFloor, JmpTo_DropOnFloor
; loc_239A2:
Obj30_HurtSupportedPlayers:
	btst	#p1_standing_bit,status(a0)
	beq.s	+
	move.l	a0,-(sp)
	movea.l	a0,a1
	lea	(MainCharacter).w,a0 ; a0=character
	jsrto	Touch_ChkHurt, JmpTo_Touch_ChkHurt
	movea.l	(sp)+,a0 ; load 0bj address
+
	btst	#p2_standing_bit,status(a0)
	beq.s	+
	move.l	a0,-(sp)
	movea.l	a0,a1
	lea	(Sidekick).w,a0 ; a0=character
	jsrto	Touch_ChkHurt, JmpTo_Touch_ChkHurt
	movea.l	(sp)+,a0 ; load 0bj address
+
	rts
; ===========================================================================

loc_239D0:
	move.w	#$EB,d1
	move.w	#$78,d2
	move.w	#$79,d3
	move.w	x_pos(a0),d4
	jsrto	SolidObject_Always, JmpTo_SolidObject_Always
	jsrto	DropOnFloor, JmpTo_DropOnFloor
	bra.s	Obj30_HurtSupportedPlayers
; ===========================================================================

loc_239EA:
	move.w	#$CB,d1
	move.w	#$2E,d2
	move.w	x_pos(a0),d4
	lea	(Obj30_SlopeData).l,a2
	jsrto	SlopedSolid, JmpTo_SlopedSolid
	jmpto	DropOnFloor, JmpTo_DropOnFloor
; ===========================================================================
;byte_23A04:
Obj30_SlopeData:
	dc.b $30,$30,$30,$30,$30,$30,$30,$30,$2F,$2F,$2E,$2E,$2D,$2D,$2C,$2C
	dc.b $2B,$2B,$2A,$2A,$29,$29,$28,$28,$27,$27,$26,$26,$25,$25,$24,$24; 16
	dc.b $23,$23,$22,$22,$21,$21,$20,$20,$1F,$1F,$1E,$1E,$1D,$1D,$1C,$1C; 32
	dc.b $1B,$1B,$1A,$1A,$19,$19,$18,$18,$17,$17,$16,$16,$15,$15,$14,$14; 48
	dc.b $13,$13,$12,$12,$11,$11,$10,$10, $F, $F, $E, $E, $D, $D, $C, $C; 64
	dc.b  $B, $B, $A, $A,  9,  9,  8,  8,  7,  7,  6,  6,  5,  5,  4,  4; 80
	dc.b   3,  3,  2,  2,  1,  1,  0,  0,$FF,$FF,$FE,$FE,$FD,$FD,$FC,$FC; 96
	dc.b $FB,$FB,$FA,$FA,$F9,$F9,$F8,$F8,$F7,$F7,$F6,$F6,$F5,$F5,$F4,$F4; 112
	dc.b $F3,$F3,$F2,$F2,$F1,$F1,$F0,$F0,$EF,$EF,$EE,$EE,$ED,$ED,$EC,$EC; 128
	dc.b $EB,$EB,$EA,$EA,$E9,$E9,$E8,$E8,$E7,$E7,$E6,$E6,$E5,$E5,$E4,$E4; 144
	dc.b $E3,$E3,$E2,$E2,$E1,$E1,$E0,$E0,$DF,$DF,$DE,$DE,$DD,$DD,$DC,$DC; 160
	dc.b $DB,$DB,$DA,$DA,$D9,$D9,$D8,$D8,$D7,$D7,$D6,$D6,$D5,$D5,$D4,$D4; 176
	dc.b $D3,$D3,$D2,$D2,$D1,$D1,$D0,$D0,$D0,$D0,$D0,$D0; 192
	even
; ===========================================================================

    if ~~removeJmpTos
JmpTo23_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo_Touch_ChkHurt ; JmpTo
	jmp	(Touch_ChkHurt).l
JmpTo2_MarkObjGone3 ; JmpTo
	jmp	(MarkObjGone3).l
JmpTo_DropOnFloor ; JmpTo
	jmp	(DropOnFloor).l
JmpTo_SolidObject_Always ; JmpTo
	jmp	(SolidObject_Always).l
JmpTo_SlopedSolid ; JmpTo
	jmp	(SlopedSolid).l

	align 4
    else
JmpTo2_MarkObjGone3 ; JmpTo
	jmp	(MarkObjGone3).l
    endif