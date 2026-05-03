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
	jmpto	JmpTo23_DeleteObject
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
    if removeJmpTos
	beq.s	JmpTo2_MarkObjGone3
    else
	beq.w	JmpTo2_MarkObjGone3
    endif
	rts

    if removeJmpTos
JmpTo2_MarkObjGone3 ; JmpTo
	jmp	(MarkObjGone3).l
    endif
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
	jsrto	JmpTo_SolidObject_Always
	jmpto	JmpTo_DropOnFloor
; ===========================================================================

loc_2398A:
	move.w	#$CB,d1
	move.w	#$78,d2
	move.w	#$79,d3
	move.w	x_pos(a0),d4
	jsrto	JmpTo_SolidObject_Always
	jsrto	JmpTo_DropOnFloor
; loc_239A2:
Obj30_HurtSupportedPlayers:
	btst	#p1_standing_bit,status(a0)
	beq.s	+
	move.l	a0,-(sp)
	movea.l	a0,a1
	lea	(MainCharacter).w,a0 ; a0=character
	jsrto	JmpTo_Touch_ChkHurt
	movea.l	(sp)+,a0 ; load 0bj address
+
	btst	#p2_standing_bit,status(a0)
	beq.s	+
	move.l	a0,-(sp)
	movea.l	a0,a1
	lea	(Sidekick).w,a0 ; a0=character
	jsrto	JmpTo_Touch_ChkHurt
	movea.l	(sp)+,a0 ; load 0bj address
+
	rts
; ===========================================================================

loc_239D0:
	move.w	#$EB,d1
	move.w	#$78,d2
	move.w	#$79,d3
	move.w	x_pos(a0),d4
	jsrto	JmpTo_SolidObject_Always
	jsrto	JmpTo_DropOnFloor
	bra.s	Obj30_HurtSupportedPlayers
; ===========================================================================

loc_239EA:
	move.w	#Obj30_SlopeData.end-Obj30_SlopeData-1,d1
	move.w	#$2E,d2
	move.w	x_pos(a0),d4
	lea	(Obj30_SlopeData).l,a2
	jsrto	JmpTo_SlopedSolid
	jmpto	JmpTo_DropOnFloor
; ===========================================================================
;byte_23A04:
Obj30_SlopeData:
	dc.b  48, 48, 48, 48, 48, 48, 48, 48, 47, 47, 46, 46
	dc.b  45, 45, 44, 44, 43, 43, 42, 42, 41, 41, 40, 40
	dc.b  39, 39, 38, 38, 37, 37, 36, 36, 35, 35, 34, 34
	dc.b  33, 33, 32, 32, 31, 31, 30, 30, 29, 29, 28, 28
	dc.b  27, 27, 26, 26, 25, 25, 24, 24, 23, 23, 22, 22
	dc.b  21, 21, 20, 20, 19, 19, 18, 18, 17, 17, 16, 16
	dc.b  15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10
	dc.b   9,  9,  8,  8,  7,  7,  6,  6,  5,  5,  4,  4
	dc.b   3,  3,  2,  2,  1,  1,  0,  0, -1, -1, -2, -2
	dc.b  -3, -3, -4, -4, -5, -5, -6, -6, -7, -7, -8, -8
	dc.b  -9, -9,-10,-10,-11,-11,-12,-12,-13,-13,-14,-14
	dc.b -15,-15,-16,-16,-17,-17,-18,-18,-19,-19,-20,-20
	dc.b -21,-21,-22,-22,-23,-23,-24,-24,-25,-25,-26,-26
	dc.b -27,-27,-28,-28,-29,-29,-30,-30,-31,-31,-32,-32
	dc.b -33,-33,-34,-34,-35,-35,-36,-36,-37,-37,-38,-38
	dc.b -39,-39,-40,-40,-41,-41,-42,-42,-43,-43,-44,-44
	dc.b -45,-45,-46,-46,-47,-47,-48,-48,-48,-48,-48,-48
.end:
	even
