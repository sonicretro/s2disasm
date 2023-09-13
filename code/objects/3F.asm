; ===========================================================================
; ----------------------------------------------------------------------------
; Object 3F - Fan from OOZ
; ----------------------------------------------------------------------------
; Sprite_2A7B0:
Obj3F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj3F_Index(pc,d0.w),d1
	jmp	Obj3F_Index(pc,d1.w)
; ===========================================================================
; off_2A7BE:
Obj3F_Index:	offsetTable
		offsetTableEntry.w Obj3F_Init		; 0
		offsetTableEntry.w Obj3F_Horizontal	; 2 - pushes horizontally
		offsetTableEntry.w Obj3F_Vertical	; 4 - pushes vertically
; ===========================================================================
; loc_2A7C4:
Obj3F_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj3F_MapUnc_2AA12,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_OOZFanHoriz,3,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo48_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	tst.b	subtype(a0)
	bpl.s	Obj3F_Horizontal
	addq.b	#2,routine(a0)
	move.l	#Obj3F_MapUnc_2AAC4,mappings(a0)
	bra.w	Obj3F_Vertical
; ===========================================================================
; loc_2A802:
Obj3F_Horizontal:
	btst	#1,subtype(a0)
	bne.s	loc_2A82A
	subq.w	#1,objoff_30(a0)
	bpl.s	loc_2A82A
	move.w	#0,objoff_34(a0)
	move.w	#$78,objoff_30(a0)
	bchg	#0,objoff_32(a0)
	beq.s	loc_2A82A
	move.w	#$B4,objoff_30(a0)

loc_2A82A:
	tst.b	objoff_32(a0)
	beq.w	loc_2A84E
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	BranchTo_JmpTo26_MarkObjGone
	cmpi.w	#$400,objoff_34(a0)
	bhs.s	BranchTo_JmpTo26_MarkObjGone
	addi.w	#$2A,objoff_34(a0)
	move.b	objoff_34(a0),anim_frame_duration(a0)
	bra.s	loc_2A86A
; ===========================================================================

loc_2A84E:
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.w	loc_2A894
	lea	(Sidekick).w,a1 ; a1=character
	bsr.w	loc_2A894
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	BranchTo_JmpTo26_MarkObjGone
	move.b	#0,anim_frame_duration(a0)

loc_2A86A:
	addq.b	#1,anim_frame(a0)
	cmpi.b	#6,anim_frame(a0)
	blo.s	loc_2A87C
	move.b	#0,anim_frame(a0)

loc_2A87C:
	moveq	#0,d0
	btst	#0,subtype(a0)
	beq.s	loc_2A888
	moveq	#5,d0

loc_2A888:
	add.b	anim_frame(a0),d0
	move.b	d0,mapping_frame(a0)

BranchTo_JmpTo26_MarkObjGone ; BranchTo
	jmpto	MarkObjGone, JmpTo26_MarkObjGone
; ===========================================================================

loc_2A894:
	cmpi.b	#4,routine(a1)
	bhs.s	return_2A8FC
	tst.b	obj_control(a1)
	bne.s	return_2A8FC
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	btst	#0,status(a0)
	bne.s	loc_2A8B4
	neg.w	d0

loc_2A8B4:
	addi.w	#$50,d0
	cmpi.w	#$F0,d0
	bhs.s	return_2A8FC
	move.w	y_pos(a1),d1
	addi.w	#$60,d1
	sub.w	y_pos(a0),d1
	bcs.s	return_2A8FC
	cmpi.w	#$70,d1
	bhs.s	return_2A8FC
	subi.w	#$50,d0
	bcc.s	loc_2A8DC
	not.w	d0
	add.w	d0,d0

loc_2A8DC:
	addi.w	#$60,d0
	btst	#0,status(a0)
	bne.s	loc_2A8EA
	neg.w	d0

loc_2A8EA:
	neg.b	d0
	asr.w	#4,d0
	btst	#0,subtype(a0)
	beq.s	loc_2A8F8
	neg.w	d0

loc_2A8F8:
	add.w	d0,x_pos(a1)

return_2A8FC:
	rts
; ===========================================================================
; loc_2A8FE:
Obj3F_Vertical:
	btst	#1,subtype(a0)
	bne.s	loc_2A926
	subq.w	#1,objoff_30(a0)
	bpl.s	loc_2A926
	move.w	#0,objoff_34(a0)
	move.w	#$78,objoff_30(a0)
	bchg	#0,objoff_32(a0)
	beq.s	loc_2A926
	move.w	#$B4,objoff_30(a0)

loc_2A926:
	tst.b	objoff_32(a0)
	beq.w	loc_2A94A
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	BranchTo2_JmpTo26_MarkObjGone
	cmpi.w	#$400,objoff_34(a0)
	bhs.s	BranchTo2_JmpTo26_MarkObjGone
	addi.w	#$2A,objoff_34(a0)
	move.b	objoff_34(a0),anim_frame_duration(a0)
	bra.s	loc_2A966
; ===========================================================================

loc_2A94A:
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.w	loc_2A990
	lea	(Sidekick).w,a1 ; a1=character
	bsr.w	loc_2A990
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	BranchTo2_JmpTo26_MarkObjGone
	move.b	#0,anim_frame_duration(a0)

loc_2A966:
	addq.b	#1,anim_frame(a0)
	cmpi.b	#6,anim_frame(a0)
	blo.s	+
	move.b	#0,anim_frame(a0)
+
	moveq	#0,d0
	btst	#0,subtype(a0)
	beq.s	+
	moveq	#5,d0
+
	add.b	anim_frame(a0),d0
	move.b	d0,mapping_frame(a0)

BranchTo2_JmpTo26_MarkObjGone
	jmpto	MarkObjGone, JmpTo26_MarkObjGone
; ===========================================================================

loc_2A990:
	cmpi.b	#4,routine(a1)
	bhs.s	return_2AA10
	tst.b	obj_control(a1)
	bne.s	return_2AA10
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$40,d0
	cmpi.w	#$80,d0
	bhs.s	return_2AA10
	moveq	#0,d1
	move.b	(Oscillating_Data+$14).w,d1
	add.w	y_pos(a1),d1
	addi.w	#$60,d1
	sub.w	y_pos(a0),d1
	bcs.s	return_2AA10
	cmpi.w	#$90,d1
	bhs.s	return_2AA10
	subi.w	#$60,d1
	bcs.s	+
	not.w	d1
	add.w	d1,d1
+
	addi.w	#$60,d1
	neg.w	d1
	asr.w	#4,d1
	add.w	d1,y_pos(a1)
	bset	#1,status(a1)
	move.w	#0,y_vel(a1)
	move.w	#1,inertia(a1)
	tst.b	flip_angle(a1)
	bne.s	return_2AA10
	move.b	#1,flip_angle(a1)
	move.b	#AniIDSonAni_Walk,anim(a1)
	move.b	#$7F,flips_remaining(a1)
	move.b	#8,flip_speed(a1)

return_2AA10:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
; sidefacing fan
Obj3F_MapUnc_2AA12:	include "mappings/sprite/obj3F_a.asm"
; upfacing fan
Obj3F_MapUnc_2AAC4:	include "mappings/sprite/obj3F_b.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo26_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo48_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
