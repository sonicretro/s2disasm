; ===========================================================================
; ----------------------------------------------------------------------------
; Object 45 - Pressure spring from OOZ
; ----------------------------------------------------------------------------
obj45_strength = objoff_30
obj45_frame = objoff_32
obj45_original_x_pos = objoff_34

; Sprite_240F8:
Obj45:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj45_Index(pc,d0.w),d1
	jsr	Obj45_Index(pc,d1.w)
	jmpto	MarkObjGone, JmpTo11_MarkObjGone
; ===========================================================================
; off_2410A:
Obj45_Index:	offsetTable
		offsetTableEntry.w Obj45_Init		; 0
		offsetTableEntry.w Obj45_Vertical	; 2
		offsetTableEntry.w Obj45_Horizontal	; 4
; ===========================================================================
; loc_24110:
Obj45_Init:
	; Much of this object's code is copied from the spring object, Obj41.
	addq.b	#2,routine(a0)
	move.l	#Obj45_MapUnc_2451A,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_PushSpring,2,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#16,width_pixels(a0)
	move.b	#4,priority(a0)
	move.b	subtype(a0),d0
	lsr.w	#3,d0
    if fixBugs
	; This bugfix is a bit of a hack: ideally, the Oil Ocean Zone Act 2
	; object layout should be corrected to not contain instances of this
	; object with an invalid subtype, but this will have to do.
	andi.w	#2,d0
    else
	; Some instances of this object use a subtype of $30, which results
	; in d0 being 6 here. Due to sheer luck, this ends up branching to
	; 'Obj45_InitHorizontal' instead of crashing the game.
	andi.w	#$E,d0
    endif
	move.w	Obj45_InitRoutines(pc,d0.w),d0
	jmp	Obj45_InitRoutines(pc,d0.w)
; ===========================================================================
; off_24146:
Obj45_InitRoutines: offsetTable
	offsetTableEntry.w Obj45_InitVertical
	offsetTableEntry.w Obj45_InitHorizontal
; ===========================================================================
;loc_2414A:
Obj45_InitHorizontal:
	move.b	#4,routine(a0)
	move.b	#1,anim(a0)
	move.b	#$A,mapping_frame(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_PushSpring,2,0),art_tile(a0)
	move.b	#20,width_pixels(a0)
	move.w	x_pos(a0),obj45_original_x_pos(a0)
;loc_2416E:
Obj45_InitVertical:
	move.b	subtype(a0),d0
	andi.w	#2,d0
	move.w	Obj45_Strengths(pc,d0.w),obj45_strength(a0)
	jsrto	Adjust2PArtPointer, JmpTo20_Adjust2PArtPointer
	rts
; ===========================================================================
;word_24182:
Obj45_Strengths:
	dc.w -$1000	; Strong
	dc.w  -$A00	; Weak
; ===========================================================================
; loc_24186:
Obj45_Vertical:
	; Is a player stood on this object?
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	loc_2419C
	; No; release the spring.
	tst.b	obj45_frame(a0)
	beq.s	loc_241A8
	subq.b	#1,obj45_frame(a0)
	bra.s	loc_241A8
; ===========================================================================

loc_2419C:
	; Yes; compress the spring.
	cmpi.b	#9,obj45_frame(a0)
	beq.s	Obj45_LaunchCharacterVertical
	addq.b	#1,obj45_frame(a0)

loc_241A8:
	; Handle solidity.
	moveq	#0,d3
	move.b	obj45_frame(a0),d3
	move.b	d3,mapping_frame(a0)
	add.w	d3,d3
	move.w	#27,d1
	move.w	#20,d2
	move.w	x_pos(a0),d4
	jsrto	SolidObject45, JmpTo_SolidObject45
	rts
; ===========================================================================
; loc_241C6:
Obj45_LaunchCharacterVertical:
	lea	(MainCharacter).w,a1
	moveq	#p1_standing_bit,d6
	bsr.s	loc_241D4
	lea	(Sidekick).w,a1
	moveq	#p2_standing_bit,d6

loc_241D4:
	; If this isn't the character that's stood on this object, then return.
	bclr	d6,status(a0)
	beq.w	return_24278
	; Launch the character into the air.
	move.w	obj45_strength(a0),y_vel(a1)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#AniIDSonAni_Spring,anim(a1)
	move.b	#2,routine(a1)
	; Clear the character's X velocity if the high bit of the subtype is set.
	move.b	subtype(a0),d0
	bpl.s	loc_24206
	move.w	#0,x_vel(a1)

loc_24206:
	btst	#0,d0
	beq.s	loc_24246
	; Make the character flip.
	move.w	#1,inertia(a1)
	move.b	#1,flip_angle(a1)
	move.b	#AniIDSonAni_Walk,anim(a1)
	move.b	#0,flips_remaining(a1)
	move.b	#4,flip_speed(a1)
	; If this is a strong spring, then make the character flip twice.
	btst	#1,d0
	bne.s	loc_24236
	move.b	#1,flips_remaining(a1)

loc_24236:
	; Correct some details to account for the character's direction.
	btst	#0,status(a1)
	beq.s	loc_24246
	neg.b	flip_angle(a1)
	neg.w	inertia(a1)

loc_24246:
	; Handle plane-switching.
	andi.b	#$C,d0
	cmpi.b	#4,d0
	bne.s	loc_2425C
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)

loc_2425C:
	cmpi.b	#8,d0
	bne.s	loc_2426E
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)

loc_2426E:
	move.w	#SndID_Spring,d0
	jmp	(PlaySound).l
; ===========================================================================

return_24278:
	rts
; ===========================================================================
; loc_2427A:
Obj45_Horizontal:
	move.b	#0,objoff_36(a0)
	move.w	#31,d1
	move.w	#12,d2
	move.w	#13,d3
	move.w	x_pos(a0),d4
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	jsrto	SolidObject_Always_SingleCharacter, JmpTo_SolidObject_Always_SingleCharacter
	cmpi.w	#1,d4
	bne.s	loc_242C0
	move.b	status(a0),d1
	move.w	x_pos(a0),d2
	sub.w	x_pos(a1),d2
	bcs.s	loc_242B6
	eori.b	#1,d1

loc_242B6:
	andi.b	#1,d1
	bne.s	loc_242C0
	bsr.w	loc_2433C

loc_242C0:
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	moveq	#p2_standing_bit,d6
	jsrto	SolidObject_Always_SingleCharacter, JmpTo_SolidObject_Always_SingleCharacter
	cmpi.w	#1,d4
	bne.s	loc_242EE
	move.b	status(a0),d1
	move.w	x_pos(a0),d2
	sub.w	x_pos(a1),d2
	bcs.s	loc_242E6
	eori.b	#1,d1

loc_242E6:
	andi.b	#1,d1
	bne.s	loc_242EE
	bsr.s	loc_2433C

loc_242EE:
	tst.b	objoff_36(a0)
	bne.s	return_2433A
	move.w	obj45_original_x_pos(a0),d0
	cmp.w	x_pos(a0),d0
	beq.s	return_2433A
	bhs.s	loc_2431C
	subq.b	#4,mapping_frame(a0)
	subq.w	#4,x_pos(a0)
	cmp.w	x_pos(a0),d0
	blo.s	loc_24336
	move.b	#$A,mapping_frame(a0)
	move.w	obj45_original_x_pos(a0),x_pos(a0)
	bra.s	loc_24336
; ===========================================================================

loc_2431C:
	subq.b	#4,mapping_frame(a0)
	addq.w	#4,x_pos(a0)
	cmp.w	x_pos(a0),d0
	bhs.s	loc_24336
	move.b	#$A,mapping_frame(a0)
	move.w	obj45_original_x_pos(a0),x_pos(a0)

loc_24336:
	bsr.w	Obj45_LaunchCharacterHorizontal

return_2433A:
	rts
; ===========================================================================

loc_2433C:
	btst	#0,status(a0)
	beq.s	loc_24378
	btst	#0,status(a1)
	bne.w	return_243CE
	tst.w	d0
	bne.w	loc_2435E
	tst.w	inertia(a1)
	beq.s	return_243CE
	bpl.s	loc_243C8
	bra.s	return_243CE
; ===========================================================================

loc_2435E:
	move.w	obj45_original_x_pos(a0),d0
	addi.w	#$12,d0
	cmp.w	x_pos(a0),d0
	beq.s	loc_243C8
	addq.w	#1,x_pos(a0)
	moveq	#1,d0
	move.w	#$40,d1
	bra.s	loc_243A6
; ===========================================================================

loc_24378:
	btst	#0,status(a1)
	beq.s	return_243CE
	tst.w	d0
	bne.w	loc_2438E
	tst.w	inertia(a1)
	bmi.s	loc_243C8
	bra.s	return_243CE
; ===========================================================================

loc_2438E:
	move.w	obj45_original_x_pos(a0),d0
	subi.w	#$12,d0
	cmp.w	x_pos(a0),d0
	beq.s	loc_243C8
	subq.w	#1,x_pos(a0)
	moveq	#-1,d0
	move.w	#-$40,d1

loc_243A6:
	add.w	d0,x_pos(a1)
	move.w	d1,inertia(a1)
	move.w	#0,x_vel(a1)
	move.w	obj45_original_x_pos(a0),d0
	sub.w	x_pos(a0),d0
	bcc.s	loc_243C0
	neg.w	d0

loc_243C0:
	addi.w	#$A,d0
	move.b	d0,mapping_frame(a0)

loc_243C8:
	move.b	#1,objoff_36(a0)

return_243CE:
	rts
; ===========================================================================
; loc_243D0:
Obj45_LaunchCharacterHorizontal:
	move.b	status(a0),d0
	andi.b	#pushing_mask,d0
	beq.w	return_244D0
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_pushing_bit,d6
	bsr.s	loc_243EA
	lea	(Sidekick).w,a1 ; a1=character
	moveq	#p2_pushing_bit,d6

loc_243EA:
	bclr	d6,status(a0)
	beq.w	return_244D0
	move.w	obj45_original_x_pos(a0),d0
	sub.w	x_pos(a0),d0
	bcc.s	loc_243FE
	neg.w	d0

loc_243FE:
	addi.w	#$A,d0
	lsl.w	#7,d0
	neg.w	d0
	move.w	d0,x_vel(a1)
	subq.w	#4,x_pos(a1)
	bset	#0,status(a1)
	btst	#0,status(a0)
	bne.s	loc_2442C
	bclr	#0,status(a1)
	addi_.w	#8,x_pos(a1)
	neg.w	x_vel(a1)

loc_2442C:
	move.w	#$F,move_lock(a1)
	move.w	x_vel(a1),inertia(a1)
	btst	#2,status(a1)
	bne.s	loc_24446
	move.b	#AniIDSonAni_Walk,anim(a1)

loc_24446:
	; Clear the character's Y velocity if the high bit of the subtype is set.
	move.b	subtype(a0),d0
	bpl.s	loc_24452
	move.w	#0,y_vel(a1)

loc_24452:
	btst	#0,d0
	beq.s	loc_24492
	; Make the character flip.
	move.w	#1,inertia(a1)
	move.b	#1,flip_angle(a1)
	move.b	#AniIDSonAni_Walk,anim(a1)
	move.b	#1,flips_remaining(a1)
	move.b	#8,flip_speed(a1)
	btst	#1,d0
	bne.s	loc_24482
	; If this is a strong spring, then make the character flip four times.
	move.b	#3,flips_remaining(a1)

loc_24482:
	; Correct some details to account for the character's direction.
	btst	#0,status(a1)
	beq.s	loc_24492
	neg.b	flip_angle(a1)
	neg.w	inertia(a1)

loc_24492:
	; Handle plane-switching.
	andi.b	#$C,d0
	cmpi.b	#4,d0
	bne.s	loc_244A8
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)

loc_244A8:
	cmpi.b	#8,d0
	bne.s	loc_244BA
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)

loc_244BA:
	bclr	#5,status(a1)
	move.b	#AniIDSonAni_Run,prev_anim(a1)	; Force character's animation to restart
	move.w	#SndID_Spring,d0
	jmp	(PlaySound).l
; ===========================================================================

return_244D0:
	rts
; ===========================================================================
; off_244D2:
; Unused animation script
Ani_obj45:	offsetTable
		offsetTableEntry.w byte_244D6	; 0
		offsetTableEntry.w byte_244F8	; 1
byte_244D6:
	dc.b   0,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  9,  9,  9,  9,  9
	dc.b   9,  9,  8,  7,  6,  5,  4,  3,  2,  1,  0,  0,  0,  0,  0,  0; 16
	dc.b   0,$FF	; 32
byte_244F8:
	dc.b   0, $A, $B, $C, $D, $E, $F,$10,$11,$12,$13,$13,$13,$13,$13,$13
	dc.b $13,$13,$12,$11,$10, $F, $E, $D, $C, $B, $A, $A, $A, $A, $A, $A; 16
	dc.b  $A,$FF	; 32
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj45_MapUnc_2451A:	include "mappings/sprite/obj45.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 46 - Ball from OOZ (unused, beta leftover)
; ----------------------------------------------------------------------------
; Sprite_24A16:
Obj46:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj46_Index(pc,d0.w),d1
	jmp	Obj46_Index(pc,d1.w)
; ===========================================================================
; off_24A24:
Obj46_Index:	offsetTable
		offsetTableEntry.w Obj46_Init		; 0 - Init
		offsetTableEntry.w Obj46_Inactive	; 2 - Ball inactive
		offsetTableEntry.w Obj46_Moving		; 4 - Ball moving
		offsetTableEntry.w Obj46_PressureSpring	; 6 - Pressure Spring
; ===========================================================================
; loc_24A2C:
Obj46_Init:
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
	bset	#0,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
	bne.w	JmpTo25_DeleteObject
+
	; loads the ball itself
	addq.b	#2,routine(a0)
	move.b	#$F,y_radius(a0)
	move.b	#$F,x_radius(a0)
	move.l	#Obj46_MapUnc_24C52,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_BallThing,3,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo20_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	move.w	x_pos(a0),objoff_34(a0)
	move.w	y_pos(a0),objoff_36(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#0,objoff_14(a0)
	move.b	#1,objoff_1F(a0)

; Obj46_InitPressureSpring:	; loads the spring under the ball
	jsrto	AllocateObject, JmpTo4_AllocateObject
	bne.s	+
	_move.b	#ObjID_OOZBall,id(a1) ; load obj46
	addq.b	#6,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$12,y_pos(a1)
	move.l	#Obj45_MapUnc_2451A,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_PushSpring,2,0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#4,priority(a1)
	move.b	#9,mapping_frame(a1)
	move.l	a0,objoff_3C(a1)
+
	move.l	a1,objoff_3C(a0)
; loc_24AEA:
Obj46_Inactive:
	btst	#button_A,(Ctrl_2_Press).w
	bne.s	+
	lea	(ButtonVine_Trigger).w,a2
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#4,d0
	tst.b	(a2,d0.w)
	beq.s	++
+
	addq.b	#2,routine(a0)
	bset	#1,status(a0)
	move.w	#-$300,y_vel(a0)
	move.w	#$100,objoff_14(a0)
	movea.l	objoff_3C(a0),a1 ; a1=object
	move.b	#1,objoff_30(a1)
	btst	#0,status(a0)
	beq.s	+
	neg.w	objoff_14(a0)
+
	bsr.w	loc_24BF0
	jmpto	MarkObjGone, JmpTo11_MarkObjGone
; ===========================================================================
; loc_24B38:
Obj46_Moving:
	move.w	x_pos(a0),-(sp)
	jsrto	ObjectMove, JmpTo9_ObjectMove
	btst	#1,status(a0)
	beq.s	loc_24B8C
	addi.w	#$18,y_vel(a0)
	bmi.s	+
	move.w	(Camera_Max_Y_pos).w,d0
	addi.w	#224,d0
	cmp.w	y_pos(a0),d0
	blo.s	loc_24BC4
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.w	+
	add.w	d1,y_pos(a0)
	clr.w	y_vel(a0)
	bclr	#1,status(a0)
	move.w	#$100,x_vel(a0)
	btst	#0,status(a0)
	beq.s	+
	neg.w	x_vel(a0)
+
	bra.s	loc_24BA4
; ===========================================================================

loc_24B8C:
	jsr	(ObjCheckFloorDist).l
	cmpi.w	#8,d1
	blt.s	loc_24BA0
	bset	#1,status(a0)
	bra.s	loc_24BA4
; ===========================================================================

loc_24BA0:
	add.w	d1,y_pos(a0)

loc_24BA4:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#$10,d2
	move.w	#$11,d3
	move.w	(sp)+,d4
	jsrto	SolidObject, JmpTo5_SolidObject
	bsr.w	loc_24BF0
	jmpto	MarkObjGone, JmpTo11_MarkObjGone
; ===========================================================================

loc_24BC4:
	move.w	(sp)+,d4
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	BranchTo_JmpTo25_DeleteObject
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)

    if removeJmpTos
JmpTo25_DeleteObject ; JmpTo
    endif

BranchTo_JmpTo25_DeleteObject ; BranchTo
	jmpto	DeleteObject, JmpTo25_DeleteObject
; ===========================================================================
; loc_24BDC:
Obj46_PressureSpring:
	tst.b	objoff_30(a0)
	beq.s	+
	subq.b	#1,mapping_frame(a0)
	bne.s	+
	clr.b	objoff_30(a0)
+
	jmpto	MarkObjGone, JmpTo11_MarkObjGone
; ===========================================================================

loc_24BF0:
	tst.b	mapping_frame(a0)
	beq.s	+
	move.b	#0,mapping_frame(a0)
	rts
; ===========================================================================
+
	move.b	objoff_14(a0),d0
	beq.s	loc_24C2A
	bmi.s	loc_24C32
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	loc_24C2A
	neg.b	d0
	addq.b	#8,d0
	bcs.s	+
	moveq	#0,d0
+
	move.b	d0,anim_frame_duration(a0)
	move.b	objoff_1F(a0),d0
	addq.b	#1,d0
	cmpi.b	#4,d0
	bne.s	+
	moveq	#1,d0
+
	move.b	d0,objoff_1F(a0)

loc_24C2A:
	move.b	objoff_1F(a0),mapping_frame(a0)
	rts
; ===========================================================================

loc_24C32:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	loc_24C2A
	addq.b	#8,d0
	bcs.s	+
	moveq	#0,d0
+
	move.b	d0,anim_frame_duration(a0)
	move.b	objoff_1F(a0),d0
	subq.b	#1,d0
	bne.s	+
	moveq	#3,d0
+
	move.b	d0,objoff_1F(a0)
	bra.s	loc_24C2A
; ===========================================================================
; ----------------------------------------------------------------------------
; Unused sprite mappings
; ----------------------------------------------------------------------------
Obj46_MapUnc_24C52:	include "mappings/sprite/obj46.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo25_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo4_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
; some of these are still used, for some reason:
JmpTo11_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo20_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo5_SolidObject ; JmpTo
	jmp	(SolidObject).l
JmpTo_SolidObject_Always_SingleCharacter ; JmpTo
	jmp	(SolidObject_Always_SingleCharacter).l
JmpTo_SolidObject45 ; JmpTo
	jmp	(SolidObject45).l
; loc_24CEE:
JmpTo9_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif
