; ===========================================================================
; ----------------------------------------------------------------------------
; Object 42 - Steam Spring from MTZ
; ----------------------------------------------------------------------------
; Sprite_26634:
Obj42:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj42_Index(pc,d0.w),d1
	jmp	Obj42_Index(pc,d1.w)
; ===========================================================================
; off_26642:
Obj42_Index:	offsetTable
		offsetTableEntry.w Obj42_Init	; 0
		offsetTableEntry.w loc_26688	; 2
		offsetTableEntry.w loc_2683A	; 4
; ===========================================================================
; loc_26648:
Obj42_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj42_MapUnc_2686C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,3,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	jsrto	Adjust2PArtPointer, JmpTo27_Adjust2PArtPointer
	move.b	#7,mapping_frame(a0)
	move.w	y_pos(a0),objoff_34(a0)
	move.w	#$10,objoff_36(a0)
	addi.w	#$10,y_pos(a0)

loc_26688:
	move.w	#$1B,d1
	move.w	#$10,d2
	move.w	#$10,d3
	move.w	x_pos(a0),d4
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	jsrto	SolidObject_Always_SingleCharacter, JmpTo2_SolidObject_Always_SingleCharacter
	btst	#p1_standing_bit,status(a0)
	beq.s	+
	bsr.w	loc_2678E
+
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	moveq	#p2_standing_bit,d6
	jsrto	SolidObject_Always_SingleCharacter, JmpTo2_SolidObject_Always_SingleCharacter
	btst	#p2_standing_bit,status(a0)
	beq.s	+
	bsr.w	loc_2678E
+
	move.b	routine_secondary(a0),d0
	bne.s	loc_266E4
	subq.w	#1,objoff_32(a0)
	bpl.s	BranchTo_JmpTo18_MarkObjGone
	move.w	#$3B,objoff_32(a0)
	addq.b	#2,routine_secondary(a0)
	bra.s	BranchTo_JmpTo18_MarkObjGone
; ===========================================================================

loc_266E4:
	subq.b	#2,d0
	bne.s	loc_26716
	subq.w	#8,objoff_36(a0)
	bne.s	loc_26708
	addq.b	#2,routine_secondary(a0)
	bsr.s	loc_2674C
	addi.w	#$28,x_pos(a1)
	bsr.s	loc_2674C
	subi.w	#$28,x_pos(a1)
	bset	#0,render_flags(a1)

loc_26708:
	move.w	objoff_36(a0),d0
	add.w	objoff_34(a0),d0
	move.w	d0,y_pos(a0)
	bra.s	BranchTo_JmpTo18_MarkObjGone
; ===========================================================================

loc_26716:
	subq.b	#2,d0
	bne.s	loc_2672C
	subq.w	#1,objoff_32(a0)
	bpl.s	BranchTo_JmpTo18_MarkObjGone
	move.w	#$3B,objoff_32(a0)
	addq.b	#2,routine_secondary(a0)
	bra.s	BranchTo_JmpTo18_MarkObjGone
; ===========================================================================

loc_2672C:
	addq.w	#8,objoff_36(a0)
	cmpi.w	#$10,objoff_36(a0)
	bne.s	loc_2673C
	clr.b	routine_secondary(a0)

loc_2673C:
	move.w	objoff_36(a0),d0
	add.w	objoff_34(a0),d0
	move.w	d0,y_pos(a0)

BranchTo_JmpTo18_MarkObjGone ; BranchTo
	jmpto	MarkObjGone, JmpTo18_MarkObjGone
; ===========================================================================

loc_2674C:
	jsrto	AllocateObject, JmpTo7_AllocateObject
	bne.s	+
	_move.b	id(a0),id(a1) ; load obj42
	addq.b	#4,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	objoff_34(a0),y_pos(a1)
	move.b	#7,anim_frame_duration(a1)
	move.l	mappings(a0),mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_MtzSteam,1,0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#$18,width_pixels(a1)
	move.b	#4,priority(a1)
+
	rts
; ===========================================================================

loc_2678E:
	cmpi.b	#2,routine_secondary(a0)
	beq.s	loc_26798
	rts
; ===========================================================================

loc_26798:
	move.w	#-$A00,y_vel(a1)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#AniIDSonAni_Spring,anim(a1)
	move.b	#2,routine(a1)
	move.b	#0,spindash_flag(a1)
	move.b	subtype(a0),d0
	bpl.s	+
	move.w	#0,x_vel(a1)
+
	btst	#0,d0
	beq.s	loc_26808
	move.w	#1,inertia(a1)
	move.b	#1,flip_angle(a1)
	move.b	#AniIDSonAni_Walk,anim(a1)
	move.b	#0,flips_remaining(a1)
	move.b	#4,flip_speed(a1)
	btst	#1,d0
	bne.s	+
	move.b	#1,flips_remaining(a1)
+
	btst	#0,status(a1)
	beq.s	loc_26808
	neg.b	flip_angle(a1)
	neg.w	inertia(a1)

loc_26808:
	andi.b	#$C,d0
	cmpi.b	#4,d0
	bne.s	+
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)
+
	cmpi.b	#8,d0
	bne.s	+
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)
+
	move.w	#SndID_Spring,d0
	jmp	(PlaySound).l
; ===========================================================================

loc_2683A:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	++
	move.b	#7,anim_frame_duration(a0)
	move.b	#0,collision_flags(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#3,mapping_frame(a0)
	bne.s	+
	move.b	#$A6,collision_flags(a0)
+
	cmpi.b	#7,mapping_frame(a0)
	beq.w	JmpTo30_DeleteObject
+
	jmpto	DisplaySprite, JmpTo18_DisplaySprite

    if removeJmpTos
JmpTo30_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj42_MapUnc_2686C:	include "mappings/sprite/obj42.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo18_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo30_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo7_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
JmpTo18_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo27_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo2_SolidObject_Always_SingleCharacter ; JmpTo
	jmp	(SolidObject_Always_SingleCharacter).l

	align 4
    endif
