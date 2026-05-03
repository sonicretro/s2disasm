; ----------------------------------------------------------------------------
; Object B6 - Tilting platform from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B5D0:
ObjB6:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB6_Index(pc,d0.w),d1
	jmp	ObjB6_Index(pc,d1.w)
; ===========================================================================
; off_3B5DE:
ObjB6_Index:	offsetTable
		offsetTableEntry.w ObjB6_Init	; 0
		offsetTableEntry.w loc_3B602	; 2
		offsetTableEntry.w loc_3B65C	; 4
		offsetTableEntry.w loc_3B6C8	; 6
		offsetTableEntry.w loc_3B73C	; 8
; ===========================================================================
; loc_3B5E8:
ObjB6_Init:
	moveq	#0,d0
	move.b	#($35<<1),d0
	bsr.w	LoadSubObject_Part2
	move.b	subtype(a0),d0
	andi.b	#6,d0
	addq.b	#2,d0
	move.b	d0,routine(a0)
	rts
; ===========================================================================

loc_3B602:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B614(pc,d0.w),d1
	jsr	off_3B614(pc,d1.w)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3B614:	offsetTable
		offsetTableEntry.w loc_3B61C	; 0
		offsetTableEntry.w loc_3B624	; 2
		offsetTableEntry.w loc_3B644	; 4
		offsetTableEntry.w loc_3B64E	; 6
; ===========================================================================

loc_3B61C:
	addq.b	#2,routine_secondary(a0)
	bra.w	loc_3B77E
; ===========================================================================

loc_3B624:
	bsr.w	loc_3B790
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$F0,d0
	cmp.b	subtype(a0),d0
	beq.s	loc_3B638
	rts
; ===========================================================================

loc_3B638:
	addq.b	#2,routine_secondary(a0)
	clr.b	anim(a0)
	bra.w	loc_3B7BC
; ===========================================================================

loc_3B644:
	lea	(Ani_objB6).l,a1
	jmpto	JmpTo25_AnimateSprite
; ===========================================================================

loc_3B64E:
	move.b	#2,routine_secondary(a0)
	move.w	#$C0,objoff_2A(a0)
	rts
; ===========================================================================

loc_3B65C:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B66E(pc,d0.w),d1
	jsr	off_3B66E(pc,d1.w)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3B66E:	offsetTable
		offsetTableEntry.w loc_3B61C
		offsetTableEntry.w loc_3B674
		offsetTableEntry.w loc_3B6A6
; ===========================================================================

loc_3B674:
	bsr.w	loc_3B790
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.b	#$20,objoff_2A(a0)
	move.b	#3,anim(a0)
	clr.b	anim_frame(a0)
	clr.b	anim_frame_duration(a0)
	bsr.w	loc_3B7BC
	bsr.w	loc_3B7F8
	moveq	#signextendB(SndID_Fire),d0
	jmpto	JmpTo12_PlaySound
; ===========================================================================

loc_3B6A6:
	subq.b	#1,objoff_2A(a0)
	bmi.s	+
	lea	(Ani_objB6).l,a1
	jmpto	JmpTo25_AnimateSprite
; ===========================================================================
+
	move.b	#2,routine_secondary(a0)
	clr.b	mapping_frame(a0)
	move.w	#$C0,objoff_2A(a0)
	rts
; ===========================================================================

loc_3B6C8:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B6DA(pc,d0.w),d1
	jsr	off_3B6DA(pc,d1.w)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3B6DA:	offsetTable
		offsetTableEntry.w loc_3B6E2	; 0
		offsetTableEntry.w loc_3B6FE	; 2
		offsetTableEntry.w loc_3B72C	; 4
		offsetTableEntry.w loc_3B736	; 6
; ===========================================================================

loc_3B6E2:
	bsr.w	loc_3B790
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$10,objoff_2A(a0)
	rts
; ===========================================================================

loc_3B6FE:
	bsr.w	loc_3B790
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.b	#0,anim(a0)
	bsr.w	Obj_GetOrientationToPlayer
	bclr	#status.npc.x_flip,status(a0)
	tst.w	d0
	bne.s	+
	bset	#status.npc.x_flip,status(a0)
+
	bra.w	loc_3B7BC
; ===========================================================================

loc_3B72C:
	lea	(Ani_objB6).l,a1
	jmpto	JmpTo25_AnimateSprite
; ===========================================================================

loc_3B736:
	clr.b	routine_secondary(a0)
	rts
; ===========================================================================

loc_3B73C:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B74E(pc,d0.w),d1
	jsr	off_3B74E(pc,d1.w)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3B74E:	offsetTable
		offsetTableEntry.w loc_3B756	; 0
		offsetTableEntry.w loc_3B764	; 2
		offsetTableEntry.w loc_3B644	; 4
		offsetTableEntry.w loc_3B64E	; 6
; ===========================================================================

loc_3B756:
	addq.b	#2,routine_secondary(a0)
	move.b	#2,mapping_frame(a0)
	bra.w	loc_3B77E
; ===========================================================================

loc_3B764:
	bsr.w	loc_3B7A6
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3B770
	rts
; ===========================================================================

loc_3B770:
	addq.b	#2,routine_secondary(a0)
	move.b	#4,anim(a0)
	bra.w	loc_3B7BC
; ===========================================================================

loc_3B77E:
	move.b	subtype(a0),d0
	andi.w	#$F0,d0
	move.b	d0,subtype(a0)
	move.w	d0,objoff_2A(a0)
	rts
; ===========================================================================

loc_3B790:
	move.w	x_pos(a0),-(sp)
	move.w	#$23,d1
	move.w	#4,d2
	move.w	#4,d3
	move.w	(sp)+,d4
	jmpto	JmpTo27_SolidObject
; ===========================================================================

loc_3B7A6:
	move.w	x_pos(a0),-(sp)
	move.w	#$F,d1
	move.w	#$18,d2
	move.w	#$18,d3
	move.w	(sp)+,d4
	jmpto	JmpTo27_SolidObject
; ===========================================================================

loc_3B7BC:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	return_3B7F6
	bclr	#p1_standing_bit,status(a0)
	beq.s	loc_3B7DE
	lea	(MainCharacter).w,a1 ; a1=character
    if fixBugs
	bclr	#status.player.on_object,status(a1)
    else
	; This is the wrong constant; it is for NPCs, not the player!
	bclr	#status.npc.p1_standing,status(a1)
    endif
	bset	#status.player.in_air,status(a1)

loc_3B7DE:
	bclr	#p2_standing_bit,status(a0)
	beq.s	return_3B7F6
	lea	(Sidekick).w,a1 ; a1=character
    if fixBugs
	bclr	#status.player.on_object,status(a1)
    else
	; This is the wrong constant; it is for NPCs, not the player!
	bclr	#status.npc.p2_standing,status(a1)
    endif
	bset	#status.player.in_air,status(a1)

return_3B7F6:
	rts
; ===========================================================================

loc_3B7F8:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	+
	_move.b	#ObjID_VerticalLaser,id(a1) ; load objB7 (huge unused vertical laser!)
	move.b	#$72,subtype(a1) ; <== ObjB7_SubObjData
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
+
	rts
; ===========================================================================
; off_3B818:
ObjB6_SubObjData:
	subObjData ObjB6_MapUnc_3B856,make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1),1<<render_flags.level_fg,4,$10,0
