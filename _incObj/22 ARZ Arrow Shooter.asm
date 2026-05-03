; ----------------------------------------------------------------------------
; Object 22 - Arrow shooter from ARZ
; ----------------------------------------------------------------------------
; Sprite_25694:
Obj22:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj22_Index(pc,d0.w),d1
	jmp	Obj22_Index(pc,d1.w)
; ===========================================================================
; off_256A2:
Obj22_Index:	offsetTable
		offsetTableEntry.w Obj22_Init		; 0
		offsetTableEntry.w Obj22_Main		; 2
		offsetTableEntry.w Obj22_ShootArrow	; 4
		offsetTableEntry.w Obj22_Arrow_Init	; 6
		offsetTableEntry.w Obj22_Arrow		; 8
; ===========================================================================
; loc_256AC:
Obj22_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj22_MapUnc_25804,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_ArrowAndShooter,0,0),art_tile(a0)
	jsrto	JmpTo24_Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#3,priority(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#1,mapping_frame(a0)
	andi.b	#$F,subtype(a0)
; loc_256E0:
Obj22_Main:
	cmpi.b	#2,anim(a0)
	beq.s	Obj22_Animate
	moveq	#0,d2
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	Obj22_DetectPlayer
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	Obj22_DetectPlayer
	tst.b	d2
	bne.s	+
	tst.b	anim(a0)
	beq.s	+
	moveq	#2,d2
+
	move.b	d2,anim(a0)
; loc_25706:
Obj22_Animate:
	lea	(Ani_obj22).l,a1
	jsrto	JmpTo5_AnimateSprite
	jmpto	JmpTo15_MarkObjGone
; ===========================================================================
; loc_25714:
Obj22_DetectPlayer:
	move.w	x_pos(a0),d0
	sub.w	x_pos(a1),d0	; is the player on the left of the shooter?
	bcc.s	+		; if yes, branch
	neg.w	d0
+
	cmpi.w	#$40,d0		; is the player within $40 pixels of the shooter?
	bhs.s	+		; if not, branch
	moveq	#1,d2		; change the shooter's animation
+
	rts
; ===========================================================================
; loc_2572A:
Obj22_ShootArrow:
	jsrto	JmpTo5_AllocateObject
	bne.s	+
	_move.b	id(a0),id(a1) ; load obj22
	addq.b	#6,routine(a1)
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	status(a0),status(a1)
	move.w	#SndID_PreArrowFiring,d0
	jsr	(PlaySound).l
+
	subq.b	#2,routine(a0)
	lea	(Ani_obj22).l,a1
	jsrto	JmpTo5_AnimateSprite
	jmpto	JmpTo15_MarkObjGone
; ===========================================================================
; loc_2577A:
Obj22_Arrow_Init:
	addq.b	#2,routine(a0)
	move.b	#8,y_radius(a0)
	move.b	#$10,x_radius(a0)
	move.b	#4,priority(a0)
	move.b	#$9B,collision_flags(a0)
	move.b	#8,width_pixels(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#$400,x_vel(a0)
	btst	#status.npc.x_flip,status(a0)
	beq.s	+
	neg.w	x_vel(a0)
+
	move.w	#SndID_ArrowFiring,d0
	jsr	(PlaySound).l
; loc_257BE:
Obj22_Arrow:
	jsrto	JmpTo11_ObjectMove
	btst	#status.npc.x_flip,status(a0)
	bne.s	loc_257DE
	moveq	#-8,d3
	bsr.w	ObjCheckLeftWallDist
	tst.w	d1
	bmi.w	BranchTo_JmpTo27_DeleteObject
	jmpto	JmpTo15_MarkObjGone
; ===========================================================================

BranchTo_JmpTo27_DeleteObject ; BranchTo
	jmpto	JmpTo27_DeleteObject
; ===========================================================================

loc_257DE:
	moveq	#8,d3
	bsr.w	ObjCheckRightWallDist
	tst.w	d1
	bmi.w	BranchTo_JmpTo27_DeleteObject
	jmpto	JmpTo15_MarkObjGone
