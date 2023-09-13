; ===========================================================================
; ----------------------------------------------------------------------------
; Object 33 - Green platform from OOZ
; ----------------------------------------------------------------------------
; Sprite_23AF4:
Obj33:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj33_Index(pc,d0.w),d1
	jmp	Obj33_Index(pc,d1.w)
; ===========================================================================
; off_23B02:
Obj33_Index:	offsetTable
		offsetTableEntry.w Obj33_Init	; 0
		offsetTableEntry.w Obj33_Main	; 2
		offsetTableEntry.w Obj33_Flame	; 4
; ===========================================================================
; loc_23B08:
Obj33_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj33_MapUnc_23DDC,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_BurnerLid,3,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	move.b	#$18,width_pixels(a0)
	move.w	y_pos(a0),objoff_30(a0)
	addq.b	#2,routine_secondary(a0)
	move.w	#$78,objoff_36(a0)
	tst.b	subtype(a0)
	beq.s	+
	move.b	#4,routine_secondary(a0)
+
	jsrto	AllocateObjectAfterCurrent, JmpTo7_AllocateObjectAfterCurrent
	bne.s	Obj33_Main
	_move.b	id(a0),id(a1) ; load obj33
	move.b	#4,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	subi.w	#$10,y_pos(a1)
	move.l	#Obj33_MapUnc_23DF0,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_OOZBurn,3,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#4,priority(a1)
	move.b	#$10,width_pixels(a1)
	move.l	a0,objoff_3C(a1)
; loc_23B90:
Obj33_Main:
	move.w	x_pos(a0),-(sp)
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj33_Modes(pc,d0.w),d1
	jsr	Obj33_Modes(pc,d1.w)
	move.w	(sp)+,d4
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#8,d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	SolidObject, JmpTo4_SolidObject
	jmpto	MarkObjGone, JmpTo10_MarkObjGone
; ===========================================================================
; off_23BBC:
Obj33_Modes:	offsetTable
		offsetTableEntry.w loc_23BC6	; 0
		offsetTableEntry.w loc_23BEA	; 2
		offsetTableEntry.w loc_23C26	; 4
		offsetTableEntry.w loc_23D20	; 6
		offsetTableEntry.w return_23D98	; 8
; ===========================================================================

loc_23BC6:
	subq.w	#1,objoff_36(a0)
	bpl.s	+	; rts
	move.w	#$78,objoff_36(a0)
	move.l	#-$96800,objoff_32(a0)
	addq.b	#2,routine_secondary(a0)
	move.w	#SndID_OOZLidPop,d0
	jsr	(PlaySoundLocal).l
+
	rts
; ===========================================================================

loc_23BEA:
	move.l	y_pos(a0),d1
	add.l	objoff_32(a0),d1
	move.l	d1,y_pos(a0)
	addi.l	#$3800,objoff_32(a0)
	swap	d1
	cmp.w	objoff_30(a0),d1
	blo.s	++	; rts
	move.l	objoff_32(a0),d0
	cmpi.l	#$10000,d0
	bhs.s	+
	subq.b	#2,routine_secondary(a0)
+
	lsr.l	#2,d0
	neg.l	d0
	move.l	d0,objoff_32(a0)
	move.w	objoff_30(a0),y_pos(a0)
+
	rts
; ===========================================================================

loc_23C26:
	move.w	x_pos(a0),d2
	move.w	d2,d3
	subi.w	#$10,d2
	addi.w	#$10,d3
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	++	; rts
	cmpi.b	#standing_mask,d0
	beq.s	loc_23CA0
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	bsr.s	+
	lea	(Sidekick).w,a1 ; a1=character
	addq.b	#1,d6
+
	btst	d6,status(a0)
	beq.s	+	; rts
	move.w	x_pos(a1),d0
	cmp.w	d2,d0
	blo.s	+	; rts
	cmp.w	d3,d0
	bhs.s	+	; rts

	move.b	#1,obj_control(a1)
	move.w	#0,inertia(a1)
	move.w	#0,x_vel(a1)
	move.w	#0,y_vel(a1)
	bclr	#5,status(a1)
	bclr	#high_priority_bit,art_tile(a1)
	move.l	#-$96800,objoff_32(a0)
	addq.b	#2,routine_secondary(a0)
	move.w	#SndID_OOZLidPop,d0
	jsr	(PlaySoundLocal).l
+
	rts
; ===========================================================================

loc_23CA0:
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),d0
	cmp.w	d2,d0
	blo.s	+	; rts
	cmp.w	d3,d0
	bhs.s	+	; rts
	lea	(Sidekick).w,a2 ; a2=character
	move.w	x_pos(a2),d0
	cmp.w	d2,d0
	blo.s	+	; rts
	cmp.w	d3,d0
	bhs.s	+	; rts

	move.b	#1,obj_control(a1)
	move.w	#0,inertia(a1)
	move.w	#0,x_vel(a1)
	move.w	#0,y_vel(a1)
	bclr	#5,status(a1)
	bclr	#high_priority_bit,art_tile(a1)
	move.b	#1,obj_control(a2)
	move.w	#0,inertia(a2)
	move.w	#0,x_vel(a2)
	move.w	#0,y_vel(a2)
	bclr	#5,status(a2)
	bclr	#high_priority_bit,art_tile(a2)
	move.l	#-$96800,objoff_32(a0)
	addq.b	#2,routine_secondary(a0)
	move.w	#SndID_OOZLidPop,d0
	jsr	(PlaySoundLocal).l
+
	rts
; ===========================================================================

loc_23D20:
	move.l	y_pos(a0),d1
	add.l	objoff_32(a0),d1
	move.l	d1,y_pos(a0)
	addi.l	#$3800,objoff_32(a0)
	swap	d1
	move.w	objoff_30(a0),d0
	subi.w	#$7D,d0
	cmp.w	d0,d1
	bne.s	+	; rts
	addq.b	#2,routine_secondary(a0)
	lea	(MainCharacter).w,a1 ; a1=character
	move.b	status(a0),d0
	andi.b	#p1_standing,d0
	bsr.s	loc_23D60
	lea	(Sidekick).w,a1 ; a1=character
	move.b	status(a0),d0
	andi.b	#p2_standing,d0

loc_23D60:
	beq.s	+	; rts
	move.w	x_pos(a0),x_pos(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	move.w	#$800,inertia(a1)
	bset	#1,status(a1)
	move.w	#-$1000,y_vel(a1)
	bclr	#3,status(a1)
	move.b	#0,obj_control(a1)
	move.w	#SndID_Spring,d0
	jsr	(PlaySoundLocal).l
+
	rts
; ===========================================================================

return_23D98:
	rts
; ===========================================================================
; loc_23D9A:
Obj33_Flame:
	movea.l	objoff_3C(a0),a1 ; a1=object
	move.w	y_pos(a0),d0
	sub.w	y_pos(a1),d0
	cmpi.w	#$14,d0
	blt.s	Obj33_FlameOff
	move.b	#$9B,collision_flags(a0)
	lea	(Ani_obj33).l,a1
	jsr	(AnimateSprite).l
	jmpto	MarkObjGone, JmpTo10_MarkObjGone
; ===========================================================================
; loc_23DC2:
Obj33_FlameOff:
	move.b	#0,collision_flags(a0)
	move.b	#0,anim_frame(a0)
	rts
; ===========================================================================
; animation script
; off_23DD0:
Ani_obj33:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   2,  2,  0,  2,  0,  2,  0,  1,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj33_MapUnc_23DDC:	include "mappings/sprite/obj33_a.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj33_MapUnc_23DF0:	include "mappings/sprite/obj33_b.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo10_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo7_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo4_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif
