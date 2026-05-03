; ----------------------------------------------------------------------------
; Object B5 - Horizontal propeller from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B3FA:
ObjB5:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB5_Index(pc,d0.w),d1
	jmp	ObjB5_Index(pc,d1.w)
; ===========================================================================
; off_3B408:
ObjB5_Index:	offsetTable
		offsetTableEntry.w ObjB5_Init		; 0
		offsetTableEntry.w ObjB5_Main		; 2 - used in WFZ
		offsetTableEntry.w ObjB5_Animate	; 4 - used in SCZ, no effect on players
; ===========================================================================
; loc_3B40E:
ObjB5_Init:
	bsr.w	LoadSubObject
	move.b	#4,anim(a0)
	move.b	subtype(a0),d0
	subi.b	#$64,d0
	move.b	d0,routine(a0)
	rts
; ===========================================================================
; loc_3B426:
ObjB5_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B442(pc,d0.w),d1
	jsr	off_3B442(pc,d1.w)
	lea	(Ani_objB5).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3B442:	offsetTable
		offsetTableEntry.w +	; 0
; ===========================================================================
+	bra.w	ObjB5_CheckPlayers
; ===========================================================================
; loc_3B448:
ObjB5_Animate:
	lea	(Ani_objB5).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; loc_3B456:
ObjB5_CheckPlayers:
	cmpi.b	#4,anim(a0)
	bne.s	++	; rts
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.w	ObjB5_CheckPlayer
	lea	(Sidekick).w,a1 ; a1=character
; loc_3B46A:
ObjB5_CheckPlayer:
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$40,d0
	cmpi.w	#$80,d0
	bhs.s	++	; rts
	moveq	#0,d1
	move.b	(Oscillating_Data+$14).w,d1
	add.w	y_pos(a1),d1
	addi.w	#$60,d1
	sub.w	y_pos(a0),d1
	bcs.s	++	; rts
	cmpi.w	#$90,d1
	bhs.s	++	; rts
	subi.w	#$60,d1
	bcs.s	+
	not.w	d1
	add.w	d1,d1
+
	addi.w	#$60,d1
	neg.w	d1
	asr.w	#4,d1
	add.w	d1,y_pos(a1)
	bset	#status.player.in_air,status(a1)
	move.w	#0,y_vel(a1)
	move.w	#1,inertia(a1)
	tst.b	flip_angle(a1)
	bne.s	+	; rts
	move.b	#1,flip_angle(a1)
	move.b	#AniIDSonAni_Float2,anim(a1)
	move.b	#$7F,flips_remaining(a1)
	move.b	#8,flip_speed(a1)
+
	rts
; ===========================================================================
; off_3B4DE:
ObjB5_SubObjData:
	subObjData ObjB5_MapUnc_3B548,make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1),1<<render_flags.level_fg,4,$40,0
