; ----------------------------------------------------------------------------
; Object C0 - Speed launcher from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BF04:
ObjC0:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC0_Index(pc,d0.w),d1
	jmp	ObjC0_Index(pc,d1.w)
; ===========================================================================
; off_3BF12:
ObjC0_Index:	offsetTable
		offsetTableEntry.w ObjC0_Init	; 0
		offsetTableEntry.w ObjC0_Main	; 2
; ===========================================================================
; loc_3BF16:
ObjC0_Init:
	move.w	#($43<<1),d0
	bsr.w	LoadSubObject_Part2
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#4,d0
	btst	#status.npc.x_flip,status(a0)
	bne.s	+
	neg.w	d0
+
	move.w	x_pos(a0),d1
	move.w	d1,objoff_34(a0)
	add.w	d1,d0
	move.w	d0,objoff_32(a0)
; loc_3BF3E:
ObjC0_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3BF60(pc,d0.w),d1
	jsr	off_3BF60(pc,d1.w)
	move.w	#$10,d1
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	jsrto	JmpTo9_PlatformObject
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3BF60:	offsetTable
		offsetTableEntry.w loc_3BF66
		offsetTableEntry.w loc_3BFD8
		offsetTableEntry.w loc_3C062
; ===========================================================================

loc_3BF66:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	+++	; rts
	addq.b	#2,routine_secondary(a0)
	move.w	#$C00,x_vel(a0)
	move.w	#$80,objoff_30(a0)
	btst	#status.npc.x_flip,status(a0)
	bne.s	+
	neg.w	x_vel(a0)
	neg.w	objoff_30(a0)
+
	jsrto	JmpTo26_ObjectMove
	move.b	status(a0),d0
	move.b	d0,d1
	andi.b	#p1_standing,d1
	beq.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_3BFB4
+
	andi.b	#p2_standing,d0
	beq.s	+	; rts
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	loc_3BFB4
+
	rts
; ===========================================================================

loc_3BFB4:
	clr.w	inertia(a1)
	clr.w	x_vel(a1)
	move.w	x_pos(a0),x_pos(a1)
	bclr	#status.player.x_flip,status(a1)
	btst	#status.npc.x_flip,status(a0)
	bne.s	+
	bset	#status.player.x_flip,status(a1)
+
	rts
; ===========================================================================

loc_3BFD8:
	move.w	objoff_30(a0),d0
	add.w	d0,x_vel(a0)
	jsrto	JmpTo26_ObjectMove
	move.w	objoff_32(a0),d0
	sub.w	x_pos(a0),d0
	btst	#status.npc.x_flip,status(a0)
	beq.s	+
	neg.w	d0
+
	tst.w	d0
	bpl.s	loc_3C034
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	return_3C01E
	move.b	d0,d1
	andi.b	#p1_standing,d1
	beq.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_3BFB4
+
	andi.b	#p2_standing,d0
	beq.s	return_3C01E
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	loc_3BFB4

return_3C01E:
	rts
; ===========================================================================

loc_3C020:
	move.w	x_vel(a0),x_vel(a1)
	move.w	#-$400,y_vel(a1)
	bset	#status.player.in_air,status(a1)
	rts
; ===========================================================================

loc_3C034:
	addq.b	#2,routine_secondary(a0)
	move.w	objoff_32(a0),x_pos(a0)
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	loc_3C062
	move.b	d0,d1
	andi.b	#p1_standing,d1
	beq.s	loc_3C056
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_3C020

loc_3C056:
	andi.b	#p2_standing,d0
	beq.s	loc_3C062
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	loc_3C020

loc_3C062:
	move.w	x_pos(a0),d0
	moveq	#4,d1
	tst.w	objoff_30(a0)	; if objoff_30(a0) is positive,
	spl	d2		; then set d2 to $FF, else set d2 to $00
	bmi.s	+
	neg.w	d1
+
	add.w	d1,d0
	cmp.w	objoff_34(a0),d0
	bhs.s	+
	not.b	d2
+
	tst.b	d2
	bne.s	+
	clr.b	routine_secondary(a0)
	move.w	objoff_34(a0),d0
+
	move.w	d0,x_pos(a0)
	rts
; ===========================================================================
; off_3C08E:
ObjC0_SubObjData:
	subObjData ObjC0_MapUnc_3C098,make_art_tile(ArtTile_ArtNem_WfzLaunchCatapult,1,0),1<<render_flags.level_fg,4,$10,0
