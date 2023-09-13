; ===========================================================================
; ----------------------------------------------------------------------------
; Object 06 - Rotating cylinder in MTZ, twisting spiral pathway in EHZ
; ----------------------------------------------------------------------------
; Sprite_214C4:
Obj06:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj06_Index(pc,d0.w),d1
	jsr	Obj06_Index(pc,d1.w)
	tst.w	(Two_player_mode).w
	beq.s	Obj06_ChkDel
	rts
; ---------------------------------------------------------------------------
; seems to be an optimization to delete the object the instant it goes offscreen
; only in 1-player mode, because it would screw up the other player
; loc_214DA:
Obj06_ChkDel:
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	JmpTo19_DeleteObject
	rts
; ---------------------------------------------------------------------------
JmpTo19_DeleteObject ; JmpTo
	jmp	(DeleteObject).l

; ===========================================================================
; off_214F4:
Obj06_Index:	offsetTable
		offsetTableEntry.w Obj06_Init		; 0
		offsetTableEntry.w Obj06_Spiral		; 2
		offsetTableEntry.w Obj06_Cylinder	; 4
; ===========================================================================
; loc_214FA:
Obj06_Init:
	addq.b	#2,routine(a0) ; => Obj06_Spiral
	move.b	#$D0,width_pixels(a0)
	tst.b	subtype(a0)
	bpl.s	Obj06_Spiral
	addq.b	#2,routine(a0) ; => Obj06_Cylinder
	bra.w	Obj06_Cylinder

; ===========================================================================
; spiral pathway from EHZ
; loc_21512:
Obj06_Spiral:
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	bsr.s	+
	lea	(Sidekick).w,a1 ; a1=character
	addq.b	#1,d6
+
	btst	d6,status(a0)
	bne.w	loc_215C0
	btst	#1,status(a1)
	bne.w	return_215BE
	btst	#3,status(a1)
	bne.s	loc_21580
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	tst.w	x_vel(a1)
	bmi.s	loc_21556
	cmpi.w	#-$C0,d0
	bgt.s	return_215BE
	cmpi.w	#-$D0,d0
	blt.s	return_215BE
	bra.s	loc_21562
; ---------------------------------------------------------------------------

loc_21556:
	cmpi.w	#$C0,d0
	blt.s	return_215BE
	cmpi.w	#$D0,d0
	bgt.s	return_215BE

loc_21562:
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	subi.w	#$10,d1
	cmpi.w	#$30,d1
	bhs.s	return_215BE
	tst.b	obj_control(a1)
	bne.s	return_215BE
	bsr.w	RideObject_SetRide
	rts
; ---------------------------------------------------------------------------

loc_21580:
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	tst.w	x_vel(a1)
	bmi.s	loc_2159C
	cmpi.w	#-$B0,d0
	bgt.s	return_215BE
	cmpi.w	#-$C0,d0
	blt.s	return_215BE
	bra.s	loc_215A8
; ---------------------------------------------------------------------------

loc_2159C:
	cmpi.w	#$B0,d0
	blt.s	return_215BE
	cmpi.w	#$C0,d0
	bgt.s	return_215BE

loc_215A8:
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	subi.w	#$10,d1
	cmpi.w	#$30,d1
	bhs.s	return_215BE
	bsr.w	RideObject_SetRide

return_215BE:
	rts
; ---------------------------------------------------------------------------

loc_215C0:
	mvabs.w	inertia(a1),d0
	cmpi.w	#$600,d0
	blo.s	Obj06_Spiral_CharacterFallsOff
	btst	#1,status(a1)
	bne.s	Obj06_Spiral_CharacterFallsOff
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$D0,d0
	bmi.s	Obj06_Spiral_CharacterFallsOff
	cmpi.w	#$1A0,d0
	blo.s	Obj06_Spiral_MoveCharacter

; loc_215EA:
Obj06_Spiral_CharacterFallsOff:
	bclr	#3,status(a1)
	bclr	d6,status(a0)
	move.b	#0,flips_remaining(a1)
	move.b	#4,flip_speed(a1)
	rts

; ---------------------------------------------------------------------------
; loc_21602:
Obj06_Spiral_MoveCharacter:
	btst	#3,status(a1)
	beq.s	return_215BE
	move.b	Obj06_CosineTable(pc,d0.w),d1
	ext.w	d1
	move.w	y_pos(a0),d2
	add.w	d1,d2
	moveq	#0,d1
	move.b	y_radius(a1),d1
	subi.w	#$13,d1
	sub.w	d1,d2
	move.w	d2,y_pos(a1)
	lsr.w	#3,d0
	andi.w	#$3F,d0
	move.b	Obj06_FlipAngleTable(pc,d0.w),flip_angle(a1)
	rts

; ===========================================================================
; Fun fact - Sega had a patent which included the original source code
; for these tables: https://patents.google.com/patent/US5411272
; byte_21634:
; sloopdirtbl:
Obj06_FlipAngleTable:
	dc.b	$00,$00
	dc.b	$01,$01,$16,$16,$16,$16,$2C,$2C
	dc.b	$2C,$2C,$42,$42,$42,$42,$58,$58
	dc.b	$58,$58,$6E,$6E,$6E,$6E,$84,$84
	dc.b	$84,$84,$9A,$9A,$9A,$9A,$B0,$B0
	dc.b	$B0,$B0,$C6,$C6,$C6,$C6,$DC,$DC
	dc.b	$DC,$DC,$F2,$F2,$F2,$F2,$01,$01
	dc.b	$00,$00
; byte_21668:
; slooptbl:
Obj06_CosineTable:
	dc.b	 32, 32, 32, 32, 32, 32, 32, 32
	dc.b	 32, 32, 32, 32, 32, 32, 32, 32

	dc.b	 32, 32, 32, 32, 32, 32, 32, 32
	dc.b	 32, 32, 32, 32, 32, 32, 31, 31
	dc.b	 31, 31, 31, 31, 31, 31, 31, 31
	dc.b	 31, 31, 31, 31, 31, 30, 30, 30

	dc.b	 30, 30, 30, 30, 30, 30, 29, 29
	dc.b	 29, 29, 29, 28, 28, 28, 28, 27
	dc.b	 27, 27, 27, 26, 26, 26, 25, 25
	dc.b	 25, 24, 24, 24, 23, 23, 22, 22

	dc.b	 21, 21, 20, 20, 19, 18, 18, 17
	dc.b	 16, 16, 15, 14, 14, 13, 12, 12
	dc.b	 11, 10, 10,  9,  8,  8,  7,  6
	dc.b	  6,  5,  4,  4,  3,  2,  2,  1

	dc.b	  0, -1, -2, -2, -3, -4, -4, -5
	dc.b	 -6, -7, -7, -8, -9, -9,-10,-10
	dc.b	-11,-11,-12,-12,-13,-14,-14,-15
	dc.b	-15,-16,-16,-17,-17,-18,-18,-19

	dc.b	-19,-19,-20,-21,-21,-22,-22,-23
	dc.b	-23,-24,-24,-25,-25,-26,-26,-27
	dc.b	-27,-28,-28,-28,-29,-29,-30,-30
	dc.b	-30,-31,-31,-31,-32,-32,-32,-33

	dc.b	-33,-33,-33,-34,-34,-34,-35,-35
	dc.b	-35,-35,-35,-35,-35,-35,-36,-36
	dc.b	-36,-36,-36,-36,-36,-36,-36,-37
	dc.b	-37,-37,-37,-37,-37,-37,-37,-37

	dc.b	-37,-37,-37,-37,-37,-37,-37,-37
	dc.b	-37,-37,-37,-37,-37,-37,-37,-37
	dc.b	-37,-37,-37,-37,-36,-36,-36,-36
	dc.b	-36,-36,-36,-35,-35,-35,-35,-35

	dc.b	-35,-35,-35,-34,-34,-34,-33,-33
	dc.b	-33,-33,-32,-32,-32,-31,-31,-31
	dc.b	-30,-30,-30,-29,-29,-28,-28,-28
	dc.b	-27,-27,-26,-26,-25,-25,-24,-24

	dc.b	-23,-23,-22,-22,-21,-21,-20,-19
	dc.b	-19,-18,-18,-17,-16,-16,-15,-14
	dc.b	-14,-13,-12,-11,-11,-10, -9, -8
	dc.b	 -7, -7, -6, -5, -4, -3, -2, -1

	dc.b	  0,  1,  2,  3,  4,  5,  6,  7
	dc.b	  8,  8,  9, 10, 10, 11, 12, 13
	dc.b	 13, 14, 14, 15, 15, 16, 16, 17
	dc.b	 17, 18, 18, 19, 19, 20, 20, 21

	dc.b	 21, 22, 22, 23, 23, 24, 24, 24
	dc.b	 25, 25, 25, 25, 26, 26, 26, 26
	dc.b	 27, 27, 27, 27, 28, 28, 28, 28
	dc.b	 28, 28, 29, 29, 29, 29, 29, 29

	dc.b	 29, 30, 30, 30, 30, 30, 30, 30
	dc.b	 31, 31, 31, 31, 31, 31, 31, 31
	dc.b	 31, 31, 32, 32, 32, 32, 32, 32
	dc.b	 32, 32, 32, 32, 32, 32, 32, 32

	dc.b	 32, 32, 32, 32, 32, 32, 32, 32
	dc.b	 32, 32, 32, 32, 32, 32, 32, 32

	even

; ===========================================================================
; rotating meshed cage from MTZ
; loc_21808:
Obj06_Cylinder:
	lea	(MainCharacter).w,a1 ; a1=character
	lea	(MTZCylinder_Angle_Sonic).w,a2
	moveq	#p1_standing_bit,d6
	bsr.s	+
	lea	(Sidekick).w,a1 ; a1=character
	lea	(MTZCylinder_Angle_Tails).w,a2
	addq.b	#1,d6
+
	btst	d6,status(a0)
	bne.w	loc_2188C
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	cmpi.w	#-$C0,d0
	blt.s	return_2188A
	cmpi.w	#$C0,d0
	bge.s	return_2188A
	move.w	y_pos(a0),d0
	addi.w	#60,d0
	move.w	y_pos(a1),d2
	move.b	y_radius(a1),d1
	ext.w	d1
	add.w	d2,d1
	addq.w	#4,d1
	sub.w	d1,d0
	bhi.s	return_2188A
	cmpi.w	#-$10,d0
	blo.s	return_2188A
	cmpi.b	#6,routine(a1)
	bhs.s	return_2188A
	add.w	d0,d2
	addq.w	#3,d2
	move.w	d2,y_pos(a1)
	move.b	#1,flip_turned(a1) ; face the other way
	bsr.w	RideObject_SetRide
	move.w	#(AniIDSonAni_Walk<<8)|(AniIDSonAni_Run<<0),anim(a1)
	move.b	#0,(a2)
	tst.w	inertia(a1)
	bne.s	return_2188A
	move.w	#1,inertia(a1)

return_2188A:
	rts
; ===========================================================================

loc_2188C:
	btst	#1,status(a1)
	bne.s	loc_218C6
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$C0,d0
	bmi.s	loc_218A8
	cmpi.w	#$180,d0
	blo.s	loc_218E0

loc_218A8:
	bclr	#3,status(a1)
	bclr	d6,status(a0)
	move.b	#0,flips_remaining(a1)
	move.b	#4,flip_speed(a1)
	bset	#1,status(a1)
	rts
; ---------------------------------------------------------------------------
loc_218C6:
	move.b	(a2),d0
	addi.b	#$20,d0
	cmpi.b	#$40,d0
	bhs.s	+
	asr	y_vel(a1)
	bra.s	loc_218A8
; ---------------------------------------------------------------------------
+	move.w	#0,y_vel(a1)
	bra.s	loc_218A8
; ===========================================================================

loc_218E0:
	btst	#3,status(a1)
	beq.s	return_2188A
	move.b	(a2),d0
	jsrto	CalcSine, JmpTo6_CalcSine
	muls.w	#$2800,d1
	swap	d1
	move.w	y_pos(a0),d2
	add.w	d1,d2
	moveq	#0,d1
	move.b	y_radius(a1),d1
	subi.w	#$13,d1
	sub.w	d1,d2
	move.w	d2,y_pos(a1)
	move.b	(a2),d0
	move.b	d0,flip_angle(a1)
	addq.b	#4,(a2)
	tst.w	inertia(a1)
	bne.s	return_2191E
	move.w	#1,inertia(a1)

return_2191E:
	rts
; ===========================================================================

    if ~~removeJmpTos
JmpTo6_CalcSine ; JmpTo
	jmp	(CalcSine).l

	align 4
    endif
