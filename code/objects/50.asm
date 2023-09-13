; ===========================================================================
; ----------------------------------------------------------------------------
; Object 50 - Aquis (seahorse badnik) from OOZ
; ----------------------------------------------------------------------------
; OST Variables:
Obj50_unkown1		= objoff_2A	; word
Obj50_shooting_flag	= objoff_2D	; byte	; if set, shooting is disabled
Obj50_shots_remaining	= objoff_2E	; word	; number of shots before retreating
Obj50_unkown2		= objoff_30	; word
Obj50_unkown3		= objoff_32	; word
Obj50_unkown4		= objoff_34	; word
Obj50_child		= objoff_36	; long	; pointer to wing object (main)
Obj50_parent		= objoff_36	; long	; pointer to main object (wing)
Obj50_unkown5		= objoff_3A	; word
Obj50_timer		= objoff_3C	; byte	; time spent following the player before shooting and time to wait before actually shooting

; Sprite_2CCC8:
Obj50:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj50_Index(pc,d0.w),d1
	jmp	Obj50_Index(pc,d1.w)
; ===========================================================================
; off_2CCD6:
Obj50_Index:	offsetTable
		offsetTableEntry.w Obj50_Init	; 0
		offsetTableEntry.w Obj50_Main	; 2
		offsetTableEntry.w Obj50_Wing	; 4
		offsetTableEntry.w Obj50_Bullet	; 6
; ===========================================================================
; loc_2CCDE:
Obj50_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj50_MapUnc_2CF94,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Aquis,1,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#$A,collision_flags(a0)
	move.b	#4,priority(a0)
	move.b	#$10,width_pixels(a0)
	move.w	#-$100,x_vel(a0)
	move.b	subtype(a0),d0
	move.b	d0,d1
	andi.w	#$F0,d1
	lsl.w	#4,d1
	move.w	d1,Obj50_shots_remaining(a0)	; looks like the number of shots could be set via subtype at one point
	move.w	d1,Obj50_unkown2(a0)	; unused
	andi.w	#$F,d0
	lsl.w	#4,d0
	subq.w	#1,d0
	move.w	d0,Obj50_unkown3(a0)	; unused
	move.w	d0,Obj50_unkown4(a0)	; unused
	move.w	y_pos(a0),Obj50_unkown1(a0)	; unused
	move.w	(Water_Level_1).w,Obj50_unkown5(a0)
	move.b	#3,Obj50_shots_remaining(a0)	; hardcoded to three shots

	; creat wing child object
	jsrto	AllocateObject, JmpTo12_AllocateObject
	bne.s	Obj50_Main

	_move.b	#ObjID_Aquis,id(a1) ; load obj50
	move.b	#4,routine(a1)	; => Obj50_Wing
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$A,x_pos(a1)
	addi.w	#-6,y_pos(a1)
	move.l	#Obj50_MapUnc_2CF94,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Aquis,1,0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#3,priority(a1)
	move.b	status(a0),status(a1)
	move.b	#3,anim(a1)
	move.l	a1,Obj50_child(a0)
	move.l	a0,Obj50_parent(a1)
	bset	#6,status(a0)	; set compund sprite flag. This is useless, as the object doesn't define any child spites, nor does it set its child sprite count
; loc_2CDA2:
Obj50_Main:
	lea	(Ani_obj50).l,a1
	jsrto	AnimateSprite, JmpTo14_AnimateSprite
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj50_Main_Index(pc,d0.w),d1
	jsr	Obj50_Main_Index(pc,d1.w)
	bsr.w	Obj50_ControlWing
	jmpto	MarkObjGone, JmpTo33_MarkObjGone
; ===========================================================================
; off_2CDC2:
Obj50_Main_Index: offsetTable
	offsetTableEntry.w Obj50_CheckIfOnScreen	; 0
	offsetTableEntry.w Obj50_Chase			; 2
	offsetTableEntry.w Obj50_Shooting		; 4
	offsetTableEntry.w BranchTo_JmpTo20_ObjectMove	; 6
; ===========================================================================
; loc_2CDCA:
Obj50_Wing:
	movea.l	Obj50_parent(a0),a1 ; a1=object
	; This check is made redundant by the one after it.
	tst.b	id(a1)		; is parent object's slot empty?
	beq.w	JmpTo48_DeleteObject	; if yes, branch
	cmpi.b	#ObjID_Aquis,id(a1)	; is parent object ObjID_Aquis?
	bne.w	JmpTo48_DeleteObject	; if not, branch
	btst	#7,status(a1)		; is parent object marked as destroyed?
	bne.w	JmpTo48_DeleteObject	; if yes, branch
	lea	(Ani_obj50).l,a1
	jsrto	AnimateSprite, JmpTo14_AnimateSprite
	jmpto	DisplaySprite, JmpTo32_DisplaySprite
; ===========================================================================
; loc_2CDF4:
Obj50_Bullet:
	jsrto	ObjectMove, JmpTo20_ObjectMove
	lea	(Ani_obj50).l,a1
	jsrto	AnimateSprite, JmpTo14_AnimateSprite
	jmpto	MarkObjGone, JmpTo33_MarkObjGone
; ===========================================================================
; wait and do nothing until on screen
; loc_2CE06:
Obj50_CheckIfOnScreen:
	tst.b	render_flags(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)	; => Obj50_Chase
	rts
; ===========================================================================
; loc_2CE14:
Obj50_Chase:
	bsr.w	Obj50_FollowPlayer
	rts
; ===========================================================================
; loc_2CE1A:
Obj50_Shooting:
	bsr.w	Obj50_WaitForNextShot
	bsr.w	Obj50_ChkIfShoot
	rts
; ===========================================================================
; loc_2CE24:
Obj50_ChkIfShoot:
	tst.b	Obj50_shooting_flag(a0)	; is object allowed to shoot?
	bne.w	return_2CEAC		; if not, branch
	st.b	Obj50_shooting_flag(a0)	; else, disallow shooting after this
	jsrto	Obj_GetOrientationToPlayer, JmpTo_Obj_GetOrientationToPlayer
	tst.w	d1		; is player above object?
	beq.s	return_2CEAC	; if yes, don't shoot
	cmpi.w	#$FFF0,d1	; ? d1 should only be 0 or 2 here...
	bhs.s	return_2CEAC

	; shoot bullet
	jsrto	AllocateObject, JmpTo12_AllocateObject
	bne.s	return_2CEAC
	_move.b	#ObjID_Aquis,id(a1) ; load obj50
	move.b	#6,routine(a1)	; => Obj50_Bullet
	move.w	x_pos(a0),x_pos(a1)	; align with parent object
	move.w	y_pos(a0),y_pos(a1)
	move.l	#Obj50_MapUnc_2CF94,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Aquis,1,0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#3,priority(a1)
	move.b	#$98,collision_flags(a1)
	move.b	#2,anim(a1)
	move.w	#$A,d0		; set y offset
	move.w	#$10,d1		; set x offset
	move.w	#-$300,d2	; set x velocity
	btst	#0,status(a0)	; is object facing right?
	beq.s	+		; if yes, branch
	neg.w	d1	; else, align bullet with other side of object...
	neg.w	d2	; ...and move in the opposite direction
+
	sub.w	d0,y_pos(a1)
	sub.w	d1,x_pos(a1)
	move.w	d2,x_vel(a1)
	move.w	#$200,y_vel(a1)

return_2CEAC:
	rts
; ===========================================================================
; follow player for a while; target is whichever character is the closest
; loc_2CEAE:
Obj50_FollowPlayer:
	subq.b	#1,Obj50_timer(a0)
	bmi.s	Obj50_DoneFollowing	; branch, if counter has expired
	jsrto	Obj_GetOrientationToPlayer, JmpTo_Obj_GetOrientationToPlayer
	bclr	#0,status(a0)	; face right
	tst.w	d0
	beq.s	+		; branch, if player is right from object
	bset	#0,status(a0)	; otherwise, face left
+
	; make object move towards player; d0 and d1 were set by the GetOrientationToPlayer routine
	move.w	Obj50_Speeds(pc,d0.w),d2
	add.w	d2,x_vel(a0)
	move.w	Obj50_Speeds(pc,d1.w),d2
	add.w	d2,y_vel(a0)
	move.w	#$100,d0	; $100 is object's max x...
	move.w	d0,d1		; ...and y velocity
	jsrto	Obj_CapSpeed, JmpTo_Obj_CapSpeed
	jmpto	ObjectMove, JmpTo20_ObjectMove
; ===========================================================================
; word_2CEE6:
Obj50_Speeds:
	dc.w   -$10	; 0 - left/up
	dc.w	$10	; 2 - right/down
; ===========================================================================
; loc_2CEEA:
Obj50_DoneFollowing:
	addq.b	#2,routine_secondary(a0)	; => Obj50_Shooting
	move.b	#$20,Obj50_timer(a0)
	jmpto	Obj_MoveStop, JmpTo_Obj_MoveStop
; ===========================================================================
; loc_2CEF8:
Obj50_WaitForNextShot:
	subq.b	#1,Obj50_timer(a0)	; wait for a while
	bmi.s	+		; branch, if counter has expired
	rts
; ===========================================================================
+	; check if object is out of shots and flee if it is
	subq.b	#1,Obj50_shots_remaining(a0)
	bmi.s	Obj50_GoAway	; branch, if object is out of atttacks
	; otherwise, shoot and return to chasing the player
	subq.b	#2,routine_secondary(a0)	; => Obj50_Chase
	move.w	#-$100,y_vel(a0)
	move.b	#$80,Obj50_timer(a0)	; reset timer
	clr.b	Obj50_shooting_flag(a0)	; reenbale shooting
	rts
; ===========================================================================
; loc_2CF1C:
Obj50_GoAway:
	move.b	#6,routine_secondary(a0)	; => BranchTo_JmpTo20_ObjectMove
	move.w	#-$200,x_vel(a0)	; fly off to the left
	clr.w	y_vel(a0)
	rts
; ===========================================================================

BranchTo_JmpTo20_ObjectMove ; BranchTo
	jmpto	ObjectMove, JmpTo20_ObjectMove
; ===========================================================================
; loc_2CF32:
Obj50_ControlWing:
	moveq	#$A,d0	; x offset
	moveq	#-6,d1	; y offset
	movea.l	Obj50_child(a0),a1 ; a1=object
	move.w	x_pos(a0),x_pos(a1)	; align child with parent object
	move.w	y_pos(a0),y_pos(a1)
	move.b	status(a0),status(a1)
	move.b	respawn_index(a0),respawn_index(a1)
	move.b	render_flags(a0),render_flags(a1)
	btst	#0,status(a1)	; is object facing right?
	beq.s	+		; if yes, branch
	neg.w	d0	; else, align wing with other side of object
+
	add.w	d0,x_pos(a1)
	add.w	d1,y_pos(a1)
	rts
; ===========================================================================
; animation script
; off_2CF6C:
Ani_obj50:	offsetTable
		offsetTableEntry.w Ani_obj50_Normal	; 0
		offsetTableEntry.w byte_2CF7B		; 1
		offsetTableEntry.w Ani_obj50_Bullet	; 2
		offsetTableEntry.w Ani_obj50_Wing	; 3
		offsetTableEntry.w byte_2CF8D		; 4
		offsetTableEntry.w byte_2CF90		; 5
Ani_obj50_Normal:	dc.b  $E,  0,$FF			; byte_2CF78
	rev02even
byte_2CF7B:		dc.b   5,  3,  4,  3,  4,  3,  4,$FF
	rev02even
Ani_obj50_Bullet:	dc.b   3,  5,  6,  7,  6,$FF		; byte_2CF83
	rev02even
Ani_obj50_Wing:		dc.b   3,  1,  2,$FF			; byte_2CF89
	rev02even
byte_2CF8D:		dc.b   1,  5,$FF
	rev02even
byte_2CF90:		dc.b  $E,  8,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj50_MapUnc_2CF94:	include "mappings/sprite/obj50.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo32_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo48_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo12_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
JmpTo33_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo14_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo_Obj_GetOrientationToPlayer ; JmpTo
	jmp	(Obj_GetOrientationToPlayer).l
JmpTo_Obj_CapSpeed ; JmpTo
	jmp	(Obj_CapSpeed).l
JmpTo_Obj_MoveStop ; JmpTo
	jmp	(Obj_MoveStop).l
; loc_2D060:
JmpTo20_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    else
JmpTo48_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
