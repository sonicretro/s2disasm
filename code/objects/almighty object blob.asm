; ---------------------------------------------------------------------------
; LoadSubObject
; loads information from a sub-object into this object a0
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_365F4:
LoadSubObject:
	moveq	#0,d0
	move.b	subtype(a0),d0
; loc_365FA:
LoadSubObject_Part2:
	move.w	SubObjData_Index(pc,d0.w),d0
	lea	SubObjData_Index(pc,d0.w),a1
; loc_36602:
LoadSubObject_Part3:
	move.l	(a1)+,mappings(a0)
	move.w	(a1)+,art_tile(a0)
	jsr	(Adjust2PArtPointer).l
	move.b	(a1)+,d0
	or.b	d0,render_flags(a0)
	move.b	(a1)+,priority(a0)
	move.b	(a1)+,width_pixels(a0)
	move.b	(a1),collision_flags(a0)
	addq.b	#2,routine(a0)
	rts

; ===========================================================================
; table that maps from the subtype ID to which address to load the data from
; the format of the data there is
;	dc.l Pointer_To_Sprite_Mappings
;	dc.w VRAM_Location
;	dc.b render_flags, priority, width_pixels, collision_flags
;
; for whatever reason, only Obj8C and later have entries in this table

; off_36628:
SubObjData_Index: offsetTable
	offsetTableEntry.w Obj8C_SubObjData	; $0
	offsetTableEntry.w Obj8D_SubObjData	; $2
	offsetTableEntry.w Obj90_SubObjData	; $4
	offsetTableEntry.w Obj90_SubObjData2	; $6
	offsetTableEntry.w Obj91_SubObjData	; $8
	offsetTableEntry.w Obj92_SubObjData	; $A
	offsetTableEntry.w Invalid_SubObjData	; $C
	offsetTableEntry.w Obj94_SubObjData	; $E
	offsetTableEntry.w Obj94_SubObjData2	; $10
	offsetTableEntry.w Obj99_SubObjData2	; $12
	offsetTableEntry.w Obj99_SubObjData	; $14
	offsetTableEntry.w Obj9A_SubObjData	; $16
	offsetTableEntry.w Obj9B_SubObjData	; $18
	offsetTableEntry.w Obj9C_SubObjData	; $1A
	offsetTableEntry.w Obj9A_SubObjData2	; $1C
	offsetTableEntry.w Obj9D_SubObjData	; $1E
	offsetTableEntry.w Obj9D_SubObjData2	; $20
	offsetTableEntry.w Obj9E_SubObjData	; $22
	offsetTableEntry.w Obj9F_SubObjData	; $24
	offsetTableEntry.w ObjA0_SubObjData	; $26
	offsetTableEntry.w ObjA1_SubObjData	; $28
	offsetTableEntry.w ObjA2_SubObjData	; $2A
	offsetTableEntry.w ObjA3_SubObjData	; $2C
	offsetTableEntry.w ObjA4_SubObjData	; $2E
	offsetTableEntry.w ObjA4_SubObjData2	; $30
	offsetTableEntry.w ObjA5_SubObjData	; $32
	offsetTableEntry.w ObjA6_SubObjData	; $34
	offsetTableEntry.w ObjA7_SubObjData	; $36
	offsetTableEntry.w ObjA7_SubObjData2	; $38
	offsetTableEntry.w ObjA8_SubObjData	; $3A
	offsetTableEntry.w ObjA8_SubObjData2	; $3C
	offsetTableEntry.w ObjA7_SubObjData3	; $3E
	offsetTableEntry.w ObjAC_SubObjData	; $40
	offsetTableEntry.w ObjAD_SubObjData	; $42
	offsetTableEntry.w ObjAD_SubObjData2	; $44
	offsetTableEntry.w ObjAD_SubObjData3	; $46
	offsetTableEntry.w ObjAF_SubObjData2	; $48
	offsetTableEntry.w ObjAF_SubObjData	; $4A
	offsetTableEntry.w ObjB0_SubObjData	; $4C
	offsetTableEntry.w ObjB1_SubObjData	; $4E
	offsetTableEntry.w ObjB2_SubObjData	; $50
	offsetTableEntry.w ObjB2_SubObjData	; $52
	offsetTableEntry.w ObjB2_SubObjData	; $54
	offsetTableEntry.w ObjBC_SubObjData2	; $56
	offsetTableEntry.w ObjBC_SubObjData2	; $58
	offsetTableEntry.w ObjB3_SubObjData	; $5A
	offsetTableEntry.w ObjB2_SubObjData2	; $5C
	offsetTableEntry.w ObjB3_SubObjData	; $5E
	offsetTableEntry.w ObjB3_SubObjData	; $60
	offsetTableEntry.w ObjB3_SubObjData	; $62
	offsetTableEntry.w ObjB4_SubObjData	; $64
	offsetTableEntry.w ObjB5_SubObjData	; $66
	offsetTableEntry.w ObjB5_SubObjData	; $68
	offsetTableEntry.w ObjB6_SubObjData	; $6A
	offsetTableEntry.w ObjB6_SubObjData	; $6C
	offsetTableEntry.w ObjB6_SubObjData	; $6E
	offsetTableEntry.w ObjB6_SubObjData	; $70
	offsetTableEntry.w ObjB7_SubObjData	; $72
	offsetTableEntry.w ObjB8_SubObjData	; $74
	offsetTableEntry.w ObjB9_SubObjData	; $76
	offsetTableEntry.w ObjBA_SubObjData	; $78
	offsetTableEntry.w ObjBB_SubObjData	; $7A
	offsetTableEntry.w ObjBC_SubObjData2	; $7C
	offsetTableEntry.w ObjBD_SubObjData	; $7E
	offsetTableEntry.w ObjBD_SubObjData	; $80
	offsetTableEntry.w ObjBE_SubObjData	; $82
	offsetTableEntry.w ObjBE_SubObjData2	; $84
	offsetTableEntry.w ObjC0_SubObjData	; $86
	offsetTableEntry.w ObjC1_SubObjData	; $88
	offsetTableEntry.w ObjC2_SubObjData	; $8A
	offsetTableEntry.w Invalid_SubObjData2	; $8C
	offsetTableEntry.w ObjB8_SubObjData2	; $8E
	offsetTableEntry.w ObjC3_SubObjData	; $90
	offsetTableEntry.w ObjC5_SubObjData	; $92
	offsetTableEntry.w ObjC5_SubObjData2	; $94
	offsetTableEntry.w ObjC5_SubObjData3	; $96
	offsetTableEntry.w ObjC5_SubObjData3	; $98
	offsetTableEntry.w ObjC5_SubObjData3	; $9A
	offsetTableEntry.w ObjC5_SubObjData3	; $9C
	offsetTableEntry.w ObjC5_SubObjData3	; $9E
	offsetTableEntry.w ObjC6_SubObjData2	; $A0
	offsetTableEntry.w ObjC5_SubObjData4	; $A2
	offsetTableEntry.w ObjAF_SubObjData3	; $A4
	offsetTableEntry.w ObjC6_SubObjData3	; $A6
	offsetTableEntry.w ObjC6_SubObjData4	; $A8
	offsetTableEntry.w ObjC6_SubObjData	; $AA
	offsetTableEntry.w ObjC8_SubObjData	; $AC
; ===========================================================================
; ---------------------------------------------------------------------------
; Get Orientation To Player
; Returns the horizontal and vertical distances of the closest player object.
;
; input variables:
;  a0 = object
;
; returns:
;  a1 = address of closest player character
;  d0 = 0 if player is left from object, 2 if right
;  d1 = 0 if player is above object, 2 if below
;  d2 = closest character's horizontal distance to object
;  d3 = closest character's vertical distance to object
;
; writes:
;  d0, d1, d2, d3, d4, d5
;  a1
;  a2 = sidekick
; ---------------------------------------------------------------------------
;loc_366D6:
Obj_GetOrientationToPlayer:
	moveq	#0,d0
	moveq	#0,d1
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a0),d2
	sub.w	x_pos(a1),d2
	mvabs.w	d2,d4	; absolute horizontal distance to main character
	lea	(Sidekick).w,a2 ; a2=character
	move.w	x_pos(a0),d3
	sub.w	x_pos(a2),d3
	mvabs.w	d3,d5	; absolute horizontal distance to sidekick
	cmp.w	d5,d4	; get shorter distance
	bls.s	+	; branch, if main character is closer
	; if sidekick is closer
	movea.l	a2,a1
	move.w	d3,d2
+
	tst.w	d2	; is player to enemy's left?
	bpl.s	+	; if not, branch
	addq.w	#2,d0
+
	move.w	y_pos(a0),d3
	sub.w	y_pos(a1),d3	; vertical distance to closest character
	bhs.s	+	; branch, if enemy is under
	addq.w	#2,d1
+
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Cap Object Speed
; Prevents an object from going over a specified speed value.
;
; input variables:
;  d0 = max x velocity
;  d1 = max y velocity
;
;  a0 = object
;
; writes:
;  d0, d1, d2, d3
; ---------------------------------------------------------------------------
; loc_3671A:
Obj_CapSpeed:
	move.w	x_vel(a0),d2
	bpl.s	+	; branch, if object is moving right
	; going left
	neg.w	d0	; set opposite direction
	cmp.w	d0,d2	; is object's current x velocity lower than max?
	bhs.s	++	; if yes, branch
	move.w	d0,d2	; else, cap speed
	bra.w	++
; ===========================================================================
+	; going right
	cmp.w	d0,d2	; is object's current x velocity lower than max?
	bls.s	+	; if yes, branch
	move.w	d0,d2	; else, cap speed
+
	move.w	y_vel(a0),d3
	bpl.s	+	; branch, if object is moving down
	; going up
	neg.w	d1	; set opposite direction
	cmp.w	d1,d3	; is object's current y velocity lower than max?
	bhs.s	++	; if yes, branch
	move.w	d1,d3	; else, cap speed
	bra.w	++
; ===========================================================================
+	; going down
	cmp.w	d1,d3	; is object's current y velocity lower than max?
	bls.s	+	; if yes, branch
	move.w	d1,d3	; else, cap speed
+	; update speed
	move.w	d2,x_vel(a0)
	move.w	d3,y_vel(a0)
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Movement Stop
; Stops an object's movement.
;
; input variables:
;  a0 = object
;
; writes:
;  d0 = 0
; ---------------------------------------------------------------------------
;loc_36754:
Obj_MoveStop:
	moveq	#0,d0
	move.w	d0,x_vel(a0)
	move.w	d0,y_vel(a0)
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Align Child XY
; Moves a referenced object to the position of the current object with
; variable x and y offset.
;
; input variables:
;  d0 = x offset
;  d1 = y offset
;
;  a0 = parent object
;  a1 = child object
;
; writes:
;  d2 = new x position
;  d3 = new y position
; ---------------------------------------------------------------------------
;loc_36760:
Obj_AlignChildXY:
	move.w	x_pos(a0),d2
	add.w	d0,d2
	move.w	d2,x_pos(a1)
	move.w	y_pos(a0),d3
	add.w	d1,d3
	move.w	d3,y_pos(a1)
	rts
; ===========================================================================

loc_36776:
	move.w	(Tornado_Velocity_X).w,d0
	add.w	d0,x_pos(a0)
	move.w	(Tornado_Velocity_Y).w,d0
	add.w	d0,y_pos(a0)
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Delete If Behind Screen
; deletes an object if it scrolls off the left side of the screen
;
; input variables:
;  a0 = object
;
; writes:
;  d0
; ---------------------------------------------------------------------------
;loc_36788:
Obj_DeleteBehindScreen:
	tst.w	(Two_player_mode).w
	beq.s	+
	jmp	(DisplaySprite).l
+
	; when not in two player mode
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	bmi.w	JmpTo64_DeleteObject
	jmp	(DisplaySprite).l
; ===========================================================================

; loc_367AA:
InheritParentXYFlip:
	move.b	render_flags(a0),d0
	andi.b	#$FC,d0
	move.b	status(a0),d2
	andi.b	#$FC,d2
	move.b	render_flags(a1),d1
	andi.b	#3,d1
	or.b	d1,d0
	or.b	d1,d2
	move.b	d0,render_flags(a0)
	move.b	d2,status(a0)
	rts
; ===========================================================================

;loc_367D0:
LoadChildObject:
	jsr	(AllocateObjectAfterCurrent).l
	bne.s	+	; rts
	move.w	(a2)+,d0
	move.w	a1,(a0,d0.w) ; store pointer to child in parent's SST
	_move.b	(a2)+,id(a1) ; load obj
	move.b	(a2)+,subtype(a1)
	move.w	a0,objoff_2C(a1) ; store pointer to parent in child's SST
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
+
	rts
; ===========================================================================
	; unused/dead code ; a0=object
	bsr.w	Obj_GetOrientationToPlayer
	bclr	#0,render_flags(a0)
	bclr	#0,status(a0)
	tst.w	d0
	beq.s	return_36818
	bset	#0,render_flags(a0)
	bset	#0,status(a0)

return_36818:
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Create Projectiles
; Creates a specified number of generic moving projectiles.
;
; input variables:
;  d2 = subtype, used for object initialization (refer to LoadSubObject)
;  d6 = number of projectiles to create -1
;
;  a2 = projectile stat list
;   format:
;   dc.b x_offset, y_offset, x_vel, y_vel, mapping_frame, render_flags
;
; writes:
;  d0
;  d1 = index in list
;  d6 = num objects
;
;  a1 = addres of new projectile
;  a3 = movement type (ObjectMove)
; ---------------------------------------------------------------------------
;loc_3681A:
Obj_CreateProjectiles:
	moveq	#0,d1
	; loop creates d6+1 projectiles
-
	jsr	(AllocateObjectAfterCurrent).l
	bne.s	return_3686E
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	d2,subtype(a1)	; used for object initialization
	move.w	x_pos(a0),x_pos(a1)	; align objects
	move.w	y_pos(a0),y_pos(a1)
	lea	(ObjectMove).l,a3	; set movement type
	move.l	a3,objoff_2A(a1)
	lea	(a2,d1.w),a3	; get address in list
	move.b	(a3)+,d0	; get x offset
	ext.w	d0
	add.w	d0,x_pos(a1)
	move.b	(a3)+,d0	; get y offset
	ext.w	d0
	add.w	d0,y_pos(a1)
	move.b	(a3)+,x_vel(a1)	; set movement values
	move.b	(a3)+,y_vel(a1)
	move.b	(a3)+,mapping_frame(a1)	; set map frame
	move.b	(a3)+,render_flags(a1)	; set render flags
	addq.w	#6,d1
	dbf	d6,-

return_3686E:
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to animate a sprite using an animation script
; Works like AnimateSprite, except for:
; * this function does not change render flags to match orientation given by
;   the status byte;
; * the function returns 0 on d0 if it changed the mapping frame, or 1 if an
;   end-of-animation flag was found ($FC to $FF);
; * it is only used by Mecha Sonic;
; * some of the end-of-animation flags work differently.
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_36870:
AnimateSprite_Checked:
	moveq	#0,d0
	move.b	anim(a0),d0		; move animation number to d0
	cmp.b	prev_anim(a0),d0	; is animation set to change?
	beq.s	AnimChk_Run		; if not, branch
	move.b	d0,prev_anim(a0)	; set previous animation to current animation
	move.b	#0,anim_frame(a0)	; reset animation
	move.b	#0,anim_frame_duration(a0)	; reset frame duration

AnimChk_Run:
	subq.b	#1,anim_frame_duration(a0)	; subtract 1 from frame duration
	bpl.s	AnimChk_Wait	; if time remains, branch
	add.w	d0,d0
	adda.w	(a1,d0.w),a1	; calculate address of appropriate animation script
	move.b	(a1),anim_frame_duration(a0)	; load frame duration
	moveq	#0,d1
	move.b	anim_frame(a0),d1	; load current frame number
	move.b	1(a1,d1.w),d0		; read sprite number from script
	bmi.s	AnimChk_End_FF		; if animation is complete, branch
;loc_368A8
AnimChk_Next:
	move.b	d0,mapping_frame(a0)	; load sprite number
	addq.b	#1,anim_frame(a0)	; next frame number
;loc_368B0
AnimChk_Wait:
	moveq	#0,d0	; Return 0
	rts
; ---------------------------------------------------------------------------
;loc_368B4
AnimChk_End_FF:
	addq.b	#1,d0		; is the end flag = $FF?
	bne.s	AnimChk_End_FE	; if not, branch
	move.b	#0,anim_frame(a0)	; restart the animation
	move.b	1(a1),d0	; read sprite number
	bsr.s	AnimChk_Next
	moveq	#1,d0	; Return 1
	rts
; ---------------------------------------------------------------------------
;loc_368C8
AnimChk_End_FE:
	addq.b	#1,d0		; is the end flag = $FE?
	bne.s	AnimChk_End_FD	; if not, branch
	addq.b	#2,routine(a0)	; jump to next routine
	move.b	#0,anim_frame_duration(a0)
	addq.b	#1,anim_frame(a0)
	moveq	#1,d0	; Return 1
	rts
; ---------------------------------------------------------------------------
;loc_368DE
AnimChk_End_FD:
	addq.b	#1,d0		; is the end flag = $FD?
	bne.s	AnimChk_End_FC	; if not, branch
	addq.b	#2,routine_secondary(a0)	; jump to next routine
	moveq	#1,d0	; Return 1
	rts
; ---------------------------------------------------------------------------
;loc_368EA
AnimChk_End_FC:
	addq.b	#1,d0		; is the end flag = $FC?
	bne.s	AnimChk_End	; if not, branch
	move.b	#1,anim_frame_duration(a0)	; Force frame duration to 1
	moveq	#1,d0	; Return 1

AnimChk_End:
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Delete If Off-Screen
; deletes an object if it is too far away from the screen
;
; input variables:
;  a0 = object
;
; writes:
;  d0
; ---------------------------------------------------------------------------
;loc_368F8:
Obj_DeleteOffScreen:
	tst.w	(Two_player_mode).w
	beq.s	+
	jmp	(DisplaySprite).l
+
	; when not in two player mode
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo64_DeleteObject
	jmp	(DisplaySprite).l
; ===========================================================================

    if removeJmpTos
JmpTo65_DeleteObject ; JmpTo
    endif

JmpTo64_DeleteObject ; JmpTo
	jmp	(DeleteObject).l




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 8C - Whisp (blowfly badnik) from ARZ
; ----------------------------------------------------------------------------

obj8C_timer = objoff_2A
obj8C_attacks_remaining = objoff_2B

; Sprite_36924:
Obj8C:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj8C_Index(pc,d0.w),d1
	jmp	Obj8C_Index(pc,d1.w)
; ===========================================================================
; off_36932: Obj8C_States:
Obj8C_Index:	offsetTable
		offsetTableEntry.w Obj8C_Init                  ; 0
		offsetTableEntry.w Obj8C_WaitUntilOnscreen     ; 1
		offsetTableEntry.w Obj8C_ChasePlayer           ; 2
		offsetTableEntry.w Obj8C_WaitUntilTimerExpires ; 3
		offsetTableEntry.w Obj8C_FlyAway               ; 4
; ===========================================================================
; loc_3693C:
Obj8C_Init:
	bsr.w	LoadSubObject
	move.b	#$10,obj8C_timer(a0)
	move.b	#4,obj8C_attacks_remaining(a0)
	rts
; ===========================================================================
; loc_3694E:
Obj8C_WaitUntilOnscreen:
	tst.b	render_flags(a0)
	bmi.s	loc_36970
	bra.w	Obj8C_Animate
; ===========================================================================
; loc_36958:
Obj8C_WaitUntilTimerExpires:
	subq.b	#1,obj8C_timer(a0)
	bmi.s	loc_36970
; loc_3695E:
Obj8C_Animate:
	lea	(Ani_obj8C).l,a1
	jsr	(AnimateSprite).l
	jmp	(MarkObjGone).l
; ===========================================================================

loc_36970:
	subq.b	#1,obj8C_attacks_remaining(a0)
	bpl.s	loc_36996
	move.b	#8,routine(a0)
	bclr	#0,status(a0)
	clr.w	y_vel(a0)
	move.w	#-$200,x_vel(a0)
	move.w	#-$200,y_vel(a0)
	bra.w	Obj8C_FlyAway
; ===========================================================================

loc_36996:
	move.b	#4,routine(a0)
	move.w	#-$100,y_vel(a0)
	move.b	#96,obj8C_timer(a0)
; loc_369A8:
Obj8C_ChasePlayer:
	subq.b	#1,obj8C_timer(a0)
	bmi.s	loc_369F8
	bsr.w	Obj_GetOrientationToPlayer
	bclr	#0,status(a0)
	tst.w	d0
	beq.s	loc_369C2
	bset	#0,status(a0)

loc_369C2:
	move.w	Obj8C_MovementDeltas(pc,d0.w),d2
	add.w	d2,x_vel(a0)
	move.w	Obj8C_MovementDeltas(pc,d1.w),d2
	add.w	d2,y_vel(a0)
	move.w	#$200,d0
	move.w	d0,d1
	bsr.w	Obj_CapSpeed
	jsr	(ObjectMove).l
	lea	(Ani_obj8C).l,a1
	jsr	(AnimateSprite).l
	jmp	(MarkObjGone).l
; ===========================================================================
; word_369F4:
Obj8C_MovementDeltas:
	dc.w -$10
	dc.w  $10
; ===========================================================================

loc_369F8:
	move.b	#6,routine(a0)
	jsr	(RandomNumber).l
	move.l	(RNG_seed).w,d0
	andi.b	#$1F,d0
	move.b	d0,obj8C_timer(a0)
	bsr.w	Obj_MoveStop
	lea	(Ani_obj8C).l,a1
	jsr	(AnimateSprite).l
	jmp	(MarkObjGone).l
; ===========================================================================
; loc_36A26:
Obj8C_FlyAway:
	jsr	(ObjectMove).l
	lea	(Ani_obj8C).l,a1
	jsr	(AnimateSprite).l
	jmp	(MarkObjGone).l
; ===========================================================================
; off_36A3E:
Obj8C_SubObjData:
	subObjData Obj8C_MapUnc_36A4E,make_art_tile(ArtTile_ArtNem_Whisp,1,1),4,4,$C,$B
; animation script
; off_36A48:
Ani_obj8C:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,$FF
		even
; ------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------
Obj8C_MapUnc_36A4E:	include "mappings/sprite/obj8C.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 8D - Grounder in wall, from ARZ
; ----------------------------------------------------------------------------
; Sprite_36A76:
Obj8D:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj8D_Index(pc,d0.w),d1
	jmp	Obj8D_Index(pc,d1.w)
; ===========================================================================
; off_36A84:
Obj8D_Index:	offsetTable
		offsetTableEntry.w Obj8D_Init		;  0
		offsetTableEntry.w loc_36ADC		;  2
		offsetTableEntry.w Obj8D_Animate	;  4
		offsetTableEntry.w loc_36B0E		;  6
		offsetTableEntry.w loc_36B34		;  8
		offsetTableEntry.w loc_36B6A		; $A
; ===========================================================================
; loc_36A90:
Obj8D_Init:
	bsr.w	LoadSubObject
	bclr	#1,render_flags(a0)
	beq.s	+
	bclr	#1,status(a0)
	andi.w	#drawing_mask,art_tile(a0)
+
	move.b	#$14,y_radius(a0)
	move.b	#$10,x_radius(a0)
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	+
	add.w	d1,y_pos(a0)
	move.w	#0,y_vel(a0)
+
	_move.b	id(a0),d0
	subi.b	#ObjID_GrounderInWall,d0
	beq.w	loc_36C64
	move.b	#6,routine(a0)
	rts
; ===========================================================================

loc_36ADC:
	bsr.w	Obj_GetOrientationToPlayer
	abs.w	d2
	cmpi.w	#$60,d2
	bls.s	+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	st.b	objoff_2B(a0)
	bsr.w	loc_36C2C
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; loc_36B00:
Obj8D_Animate:
	lea	(Ani_obj8D_b).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_36B0E:
	addq.b	#2,routine(a0)
	bsr.w	Obj_GetOrientationToPlayer
	move.w	Obj8D_Directions(pc,d0.w),x_vel(a0)
	bclr	#0,status(a0)
	tst.w	d0
	beq.s	+
	bset	#0,status(a0)
+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; word_36B30:
Obj8D_Directions:
	dc.w -$100
	dc.w  $100	; 1
; ===========================================================================

loc_36B34:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jsr	(ObjCheckFloorDist).l
	cmpi.w	#-1,d1
	blt.s	loc_36B5C
	cmpi.w	#$C,d1
	bge.s	loc_36B5C
	add.w	d1,y_pos(a0)
	lea	(Ani_obj8D_a).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_36B5C:
	addq.b	#2,routine(a0)
	move.b	#$3B,objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_36B6A:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_36B74
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_36B74:
	move.b	#8,routine(a0)
	neg.w	x_vel(a0)
	bchg	#0,status(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 8F - Wall behind which Grounder hides, from ARZ
; ----------------------------------------------------------------------------
; Sprite_36B88:
Obj8F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj8F_Index(pc,d0.w),d1
	jmp	Obj8F_Index(pc,d1.w)
; ===========================================================================
; off_36B96:
Obj8F_Index:	offsetTable
		offsetTableEntry.w Obj8F_Init	; 0
		offsetTableEntry.w loc_36BA6	; 2
		offsetTableEntry.w Obj8F_Move	; 4
; ===========================================================================
; loc_36B9C:
Obj8F_Init:
	bsr.w	LoadSubObject
	clr.w	art_tile(a0)
	rts
; ===========================================================================

loc_36BA6:
	movea.w	objoff_2C(a0),a1 ; a1=object
	tst.b	objoff_2B(a1)
	bne.s	+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	objoff_2E(a0),d0
	move.b	Obj8F_Directions(pc,d0.w),x_vel(a0)
	move.b	Obj8F_Directions+1(pc,d0.w),y_vel(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; byte_36BCC:
Obj8F_Directions:
	dc.b  1,-2	; 0
	dc.b  1,-1	; 2
	dc.b -1,-2	; 4
	dc.b -1,-1	; 6
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 90 - Rocks thrown by Grounder behind wall, from ARZ
; ----------------------------------------------------------------------------
; Sprite_36BD4:
Obj90:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj90_Index(pc,d0.w),d1
	jmp	Obj90_Index(pc,d1.w)
; ===========================================================================
; off_36BE2:
Obj90_Index:	offsetTable
		offsetTableEntry.w Obj90_Init	; 0
		offsetTableEntry.w Obj90_Move	; 2
; ===========================================================================
; loc_36BE6:
Obj90_Init:
	bsr.w	LoadSubObject
	move.w	#make_art_tile(ArtTile_ArtNem_Grounder,2,0),art_tile(a0)
	move.w	objoff_2E(a0),d0
	move.b	Obj90_Directions(pc,d0.w),x_vel(a0)
	move.b	Obj90_Directions+1(pc,d0.w),y_vel(a0)
	lsr.w	#1,d0
	move.b	Obj90_Frames(pc,d0.w),mapping_frame(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; byte_36C0C:
Obj90_Frames:
	dc.b   0
	dc.b   2	; 1
	dc.b   0	; 2
	dc.b   1	; 3
	dc.b   0	; 4
	dc.b   0	; 5
; ===========================================================================
; byte_36C12:
Obj90_Directions:
	dc.b  -1, -4
	dc.b   4, -3	; 2
	dc.b   2,  0	; 4
	dc.b  -3, -1	; 6
	dc.b  -3, -3	; 8
	even
; ===========================================================================
; loc_36C1C:
Obj8F_Move:
Obj90_Move:
	tst.b	render_flags(a0)
	bpl.w	JmpTo65_DeleteObject
	jsrto	ObjectMoveAndFall, JmpTo8_ObjectMoveAndFall
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_36C2C:
	moveq	#0,d1

	moveq	#4,d6
-	jsrto	AllocateObject, JmpTo19_AllocateObject
	bne.s	+	; rts
	bsr.w	loc_36C40
	dbf	d6,-
+
	rts
; ===========================================================================

loc_36C40:
	_move.b	#ObjID_GrounderRocks,id(a1) ; load obj90
	move.b	#6,subtype(a1) ; <== Obj90_SubObjData2
	move.w	a0,objoff_2C(a1)
	move.w	d1,objoff_2E(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addq.w	#2,d1
	rts
; ===========================================================================

loc_36C64:
	moveq	#0,d1

	moveq	#3,d6
-	jsrto	AllocateObject, JmpTo19_AllocateObject
	bne.s	+	; rts
	bsr.w	loc_36C78
	dbf	d6,-
+
	rts
; ===========================================================================

loc_36C78:
	_move.b	#ObjID_GrounderWall,id(a1) ; load obj8F
	move.b	#4,subtype(a1) ; <== Obj90_SubObjData
	move.w	a0,objoff_2C(a1)
	move.w	d1,objoff_2E(a1)
	move.l	x_pos(a0),d0
	swap	d0
	moveq	#0,d2
	move.b	byte_36CBC(pc,d1.w),d2
	ext.w	d2
	add.w	d2,d0
	swap	d0
	move.l	d0,x_pos(a1)
	move.l	y_pos(a0),d0
	swap	d0
	moveq	#0,d2
	move.b	byte_36CBC+1(pc,d1.w),d2
	ext.w	d2
	add.w	d2,d0
	swap	d0
	move.l	d0,y_pos(a1)
	addq.w	#2,d1
	rts
; ===========================================================================
byte_36CBC:
	dc.b    0,-$14
	dc.b  $10,  -4	; 2
	dc.b    0,  $C	; 4
	dc.b -$10,  -4	; 6
; off_36CC4:
Obj8D_SubObjData:
	subObjData Obj8D_MapUnc_36CF0,make_art_tile(ArtTile_ArtNem_Grounder,1,1),4,5,$10,2
; off_36CCE:
Obj90_SubObjData:
	subObjData Obj90_MapUnc_36D00,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),$84,4,$10,0
; off_36CD8:
Obj90_SubObjData2:
	subObjData Obj90_MapUnc_36CFA,make_art_tile(ArtTile_ArtNem_Grounder,1,1),$84,4,8,0

; animation script
Ani_obj8D_a:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3,  2,  3,  4,$FF
		even
; animation script
; off_36CEA:
Ani_obj8D_b:	offsetTable
		offsetTableEntry.w +
+		dc.b   7,  0,  1,$FC
		even
; -----------------------------------------------------------------------------
; sprite mappings (obj8D)
; -----------------------------------------------------------------------------
Obj8D_MapUnc_36CF0:	mappingsTable
	mappingsTableEntry.w	word_36D02
	mappingsTableEntry.w	word_36D24
	mappingsTableEntry.w	word_36D46
	mappingsTableEntry.w	word_36D58
	mappingsTableEntry.w	word_36D6A
; -----------------------------------------------------------------------------
; sprite mappings (obj90)
; -----------------------------------------------------------------------------
Obj90_MapUnc_36CFA:	mappingsTable
	mappingsTableEntry.w	word_36D7C
	mappingsTableEntry.w	word_36D86
	mappingsTableEntry.w	word_36D90
; -----------------------------------------------------------------------------
; sprite mappings (obj90)
; -----------------------------------------------------------------------------
Obj90_MapUnc_36D00:	mappingsTable
	mappingsTableEntry.w	word_36D9A

word_36D02:	spriteHeader
	spritePiece	-8, -$C, 1, 1, 0, 0, 0, 0, 0
	spritePiece	-$10, -4, 2, 3, 1, 0, 0, 0, 0
	spritePiece	0, -$C, 1, 1, 0, 1, 0, 0, 0
	spritePiece	0, -4, 2, 3, 1, 1, 0, 0, 0
word_36D02_End

word_36D24:	spriteHeader
	spritePiece	-8, -$14, 1, 1, 7, 0, 0, 0, 0
	spritePiece	-$10, -$C, 2, 4, 8, 0, 0, 0, 0
	spritePiece	0, -$14, 1, 1, 7, 1, 0, 0, 0
	spritePiece	0, -$C, 2, 4, 8, 1, 0, 0, 0
word_36D24_End

word_36D46:	spriteHeader
	spritePiece	-$10, -$14, 4, 4, $10, 0, 0, 0, 0
	spritePiece	-$10, $C, 4, 1, $20, 0, 0, 0, 0
word_36D46_End

word_36D58:	spriteHeader
	spritePiece	-$10, -$14, 4, 4, $10, 0, 0, 0, 0
	spritePiece	-$10, $C, 4, 1, $24, 0, 0, 0, 0
word_36D58_End

word_36D6A:	spriteHeader
	spritePiece	-$10, -$14, 4, 4, $10, 0, 0, 0, 0
	spritePiece	-$10, $C, 4, 1, $28, 0, 0, 0, 0
word_36D6A_End

word_36D7C:	spriteHeader
	spritePiece	-8, -8, 2, 2, $2C, 0, 0, 0, 0
word_36D7C_End

word_36D86:	spriteHeader
	spritePiece	-4, -4, 1, 1, $30, 0, 0, 0, 0
word_36D86_End

word_36D90:	spriteHeader
	spritePiece	-4, -4, 1, 1, $31, 0, 0, 0, 0
word_36D90_End

word_36D9A:	spriteHeader
	spritePiece	-$10, -8, 2, 2, $93, 0, 0, 2, 0
	spritePiece	0, -8, 2, 2, $97, 0, 0, 2, 0
word_36D9A_End

	even

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 91 - Chop Chop (piranha/shark badnik) from ARZ
; ----------------------------------------------------------------------------
; OST Variables:
Obj91_move_timer	= objoff_2A	; time to wait before turning around
Obj91_bubble_timer	= objoff_2C	; time to wait before producing a bubble
; Sprite_36DAC:
Obj91:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj91_Index(pc,d0.w),d1
	jmp	Obj91_Index(pc,d1.w)
; ===========================================================================
; off_36DBA:
Obj91_Index:	offsetTable
		offsetTableEntry.w Obj91_Init		; 0 - Initialize object variables
		offsetTableEntry.w Obj91_Main		; 2 - Moving back and forth until Sonic or Tails approach
		offsetTableEntry.w Obj91_Waiting	; 4 - Stopped, opening and closing mouth
		offsetTableEntry.w Obj91_Charge		; 6 - Charging at Sonic or Tails
; ===========================================================================
; loc_36DC2:
Obj91_Init:
	bsr.w	LoadSubObject
	move.w	#$200,Obj91_move_timer(a0)
	move.w	#$50,Obj91_bubble_timer(a0)
	moveq	#$40,d0		; enemy speed
	btst	#0,status(a0)	; is enemy facing left?
	bne.s	+		; if not, branch
	neg.w	d0		; else reverse movement direction
+
	move.w	d0,x_vel(a0)	; set speed
	rts
; ===========================================================================
; loc_36DE4:
Obj91_Main:
	subq.b	#1,Obj91_bubble_timer(a0)
	bne.s	+			; branch, if timer isn't done counting down
	bsr.w	Obj91_MakeBubble
+
	subq.w	#1,Obj91_move_timer(a0)
	bpl.s	+			; branch, if timer isn't done counting down
	move.w	#$200,Obj91_move_timer(a0)	; else, reset timer...
	bchg	#0,status(a0)		; ...change direction...
	bchg	#0,render_flags(a0)
	neg.w	x_vel(a0)		; ...and reverse movement
+
	jsrto	ObjectMove, JmpTo26_ObjectMove
	bsr.w	Obj_GetOrientationToPlayer
	move.w	d2,d4
	move.w	d3,d5
	bsr.w	Obj91_TestCharacterPos	; are Sonic or Tails close enough to attack?
	bne.s	Obj91_PrepareCharge	; if yes, prepare to charge at them
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; loc_36E20
Obj91_PrepareCharge:
	addq.b	#2,routine(a0)	; => Obj91_Waiting
	move.b	#$10,Obj91_move_timer(a0)	; time to wait before charging at the player
	clr.w	x_vel(a0)		; stop movement
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; loc_36E32:
Obj91_Waiting:
	subq.b	#1,Obj91_move_timer(a0)
	bmi.s	Obj91_MoveTowardsPlayer		; branch, if wait time is over
	bra.w	Obj91_Animate
; ===========================================================================
; loc_36E3C:
Obj91_MoveTowardsPlayer:
	addq.b	#2,routine(a0)	; => Obj91_Charge
	bsr.w	Obj_GetOrientationToPlayer
	lsr.w	#1,d0		; set speed based on closest character
	move.b	Obj91_HorizontalSpeeds(pc,d0.w),x_vel(a0)	; horizontal
	addi.w	#$10,d3
	cmpi.w	#$20,d3		; is closest character withing $10 pixels above or $F pixels below?
	blo.s	+		; if not, branch
	lsr.w	#1,d1		; set speed based on closest character
	move.b	Obj91_VerticalSpeeds(pc,d1.w),1+y_vel(a0)	; vertical
+
	bra.w	Obj91_Animate
; ===========================================================================
; byte_36E62:
Obj91_HorizontalSpeeds:
	dc.b  -2	; 0 - player is left from object -> move left
	dc.b   2	; 1 - player is right from object -> move right
; byte_36E64:
Obj91_VerticalSpeeds:
	dc.b $80	; 0 - player is above object -> ...move down?
	dc.b $80	; 1 - player is below object -> move down
; ===========================================================================
; loc_36E66:
Obj91_Charge:
	jsrto	ObjectMove, JmpTo26_ObjectMove
; loc_36E6A:
Obj91_Animate:
	lea	(Ani_obj91).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; loc_36E78:
Obj91_MakeBubble:
	move.w	#$50,Obj91_bubble_timer(a0)	; reset timer
	jsrto	AllocateObject, JmpTo19_AllocateObject
	bne.s	return_36EB0
	_move.b	#ObjID_SmallBubbles,id(a1) ; load obj
	move.b	#6,subtype(a1) ; <== Obj90_SubObjData2
	move.w	x_pos(a0),x_pos(a1)	; align objects horizontally
	moveq	#$14,d0			; load x-offset
	btst	#0,render_flags(a0)	; is object facing left?
	beq.s	+			; if not, branch
	neg.w	d0			; else mirror offset
+
	add.w	d0,x_pos(a1)		; add horizontal offset
	move.w	y_pos(a0),y_pos(a1)	; align objects vertically
	addq.w	#6,y_pos(a1)		; move object 6 pixels down

return_36EB0:
	rts
; ===========================================================================
; loc_36EB2:
Obj91_TestCharacterPos:
	addi.w	#$20,d3
	cmpi.w	#$40,d3			; is character too low?
	bhs.s	Obj91_DoNotCharge	; if yes, branch
	tst.w	d2			; is character to the left?
	bmi.s	Obj91_TestPosLeft	; if yes, branch
	tst.w	x_vel(a0)		; is object moving left, towards character?
	bpl.s	Obj91_DoNotCharge	; if not, branch
	bra.w	Obj91_TestHorizontalDist
; ===========================================================================
; loc_36ECA:
Obj91_TestPosLeft:
	tst.w	x_vel(a0)		; is object moving right, towards character?
	bmi.s	Obj91_DoNotCharge	; if not, branch
	neg.w	d2			; get absolute value

; loc_36ED2:
Obj91_TestHorizontalDist:
	cmpi.w	#$20,d2			; is distance less than $20?
	blo.s	Obj91_DoNotCharge	; if yes, don't attack
	cmpi.w	#$A0,d2			; is distance less than $A0?
	blo.s	Obj91_PlayerInRange	; if yes, attack

; loc_36EDE:
Obj91_DoNotCharge:
	moveq	#0,d2			; -> don't charge at player
	rts
; ===========================================================================
; loc_36EE2:
Obj91_PlayerInRange:
	moveq	#1,d2			; -> charge at player
	rts
; ===========================================================================
; off_36EE6:
Obj91_SubObjData:
	subObjData Obj91_MapUnc_36EF6,make_art_tile(ArtTile_ArtNem_ChopChop,1,0),4,4,$10,2

; animation script
; off_36EF0:
Ani_obj91:	offsetTable
		offsetTableEntry.w +
+		dc.b   4,  0,  1,$FF	; 0
		even
; --------------------------------------------------------------------------
; sprite mappings
; --------------------------------------------------------------------------
Obj91_MapUnc_36EF6:	include "mappings/sprite/obj91.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 92 - Spiker (drill badnik) from HTZ
; ----------------------------------------------------------------------------
; Sprite_36F0E:
Obj92:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj92_Index(pc,d0.w),d1
	jmp	Obj92_Index(pc,d1.w)
; ===========================================================================
; off_36F1C:
Obj92_Index:	offsetTable
		offsetTableEntry.w Obj92_Init	; 0
		offsetTableEntry.w loc_36F3C	; 2
		offsetTableEntry.w loc_36F68	; 4
		offsetTableEntry.w loc_36F90	; 6
; ===========================================================================
; loc_36F24:
Obj92_Init:
	bsr.w	LoadSubObject
	move.b	#$40,objoff_2A(a0)
	move.w	#$80,x_vel(a0)
	bchg	#0,status(a0)
	rts
; ===========================================================================

loc_36F3C:
	bsr.w	loc_3703E
	bne.s	loc_36F48
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_36F5A

loc_36F48:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(Ani_obj92).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_36F5A:
	addq.b	#2,routine(a0)
	move.b	#$10,objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_36F68:
	bsr.w	loc_3703E
	bne.s	+
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_36F78
+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_36F78:
	subq.b	#2,routine(a0)
	move.b	#$40,objoff_2A(a0)
	neg.w	x_vel(a0)
	bchg	#0,status(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_36F90:
	move.b	objoff_2E(a0),d0
	cmpi.b	#8,d0
	beq.s	loc_36FA4
	subq.b	#1,d0
	move.b	d0,objoff_2E(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_36FA4:
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	loc_36FDC
	st.b	objoff_2B(a0)
	_move.b	#ObjID_SpikerDrill,id(a1) ; load obj93
	move.b	subtype(a0),subtype(a1)
	move.w	a0,objoff_2C(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#4,mapping_frame(a1)
	move.b	#2,mapping_frame(a0)
	move.b	#1,anim(a0)

loc_36FDC:
	move.b	objoff_2F(a0),routine(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 93 - Drill thrown by Spiker from HTZ
; ----------------------------------------------------------------------------
; Sprite_36FE6:
Obj93:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj93_Index(pc,d0.w),d1
	jmp	Obj93_Index(pc,d1.w)
; ===========================================================================
; off_36FF4:
Obj93_Index:	offsetTable
		offsetTableEntry.w Obj93_Init	; 0
		offsetTableEntry.w loc_37028	; 2
; ===========================================================================
; loc_36FF8:
Obj93_Init:
	bsr.w	LoadSubObject
	ori.b	#$80,render_flags(a0)
	ori.b	#$80,collision_flags(a0)
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.b	render_flags(a1),d0
	andi.b	#3,d0
	or.b	d0,render_flags(a0)
	moveq	#2,d1
	btst	#1,d0
	bne.s	+
	neg.w	d1
+
	move.b	d1,y_vel(a0)
	rts
; ===========================================================================

loc_37028:
	tst.b	render_flags(a0)
	bpl.w	JmpTo65_DeleteObject
	bchg	#0,render_flags(a0)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3703E:
	tst.b	objoff_2B(a0)
	bne.s	loc_37062
	tst.b	render_flags(a0)
	bpl.s	loc_37062
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$20,d2
	cmpi.w	#$40,d2
	bhs.s	loc_37062
	addi.w	#$80,d3
	cmpi.w	#$100,d3
	blo.s	loc_37066

loc_37062:
	moveq	#0,d0
	rts
; ===========================================================================

loc_37066:
	move.b	routine(a0),objoff_2F(a0)
	move.b	#6,routine(a0)
	move.b	#$10,objoff_2E(a0)
	moveq	#1,d0
	rts
; ===========================================================================
; off_3707C:
Obj92_SubObjData:
	subObjData Obj92_Obj93_MapUnc_37092,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),4,4,$10,$12
; animation script
; off_37086:
Ani_obj92:	offsetTable
		offsetTableEntry.w byte_3708A	; 0
		offsetTableEntry.w byte_3708E	; 2
byte_3708A:	dc.b   9,  0,  1,$FF
byte_3708E:	dc.b   9,  2,  3,$FF
		even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
Obj92_Obj93_MapUnc_37092:	include "mappings/sprite/obj93.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 95 - Sol (fireball-throwing orbit badnik) from HTZ
; ----------------------------------------------------------------------------
; Sprite_370FE:
Obj95:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj95_Index(pc,d0.w),d1
	jmp	Obj95_Index(pc,d1.w)
; ===========================================================================
; off_3710C:
Obj95_Index:	offsetTable
		offsetTableEntry.w Obj95_Init	; 0
		offsetTableEntry.w Obj95_WaitForPlayer	; 2
		offsetTableEntry.w loc_37224	; 4
		offsetTableEntry.w Obj95_FireballUpdate	; 6
		offsetTableEntry.w loc_372B8	; 8
; ===========================================================================
; loc_37116:
Obj95_Init:
	move.l	#Obj95_MapUnc_372E6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo64_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#$B,collision_flags(a0)
	move.b	#$C,width_pixels(a0)
	move.w	#-$40,x_vel(a0)
	moveq	#0,d2
	lea	objoff_37(a0),a2
	movea.l	a2,a3
	addq.w	#1,a2
	moveq	#3,d1

; loc_37152:
Obj95_NextFireball:
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	loc_371AE
	addq.b	#1,(a3)
    if object_size<>$40
	moveq	#0,d5 ; Clear the high word for the coming division.
    endif
	move.w	a1,d5
	subi.w	#MainCharacter,d5
    if object_size=$40
	lsr.w	#object_size_bits,d5
    else
	divu.w	#object_size,d5
    endif
	andi.w	#$7F,d5
	move.b	d5,(a2)+
	_move.b	id(a0),id(a1) ; load obj95
	move.b	#6,routine(a1)
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#4,priority(a1)
	move.b	#8,width_pixels(a1)
	move.b	#3,mapping_frame(a1)
	move.b	#$98,collision_flags(a1)
	move.b	d2,angle(a1)
	addi.b	#$40,d2
	move.l	a0,objoff_3C(a1)
	dbf	d1,Obj95_NextFireball

loc_371AE:
	moveq	#1,d0
	btst	#0,status(a0)
	beq.s	loc_371BA
	neg.w	d0

loc_371BA:
	move.b	d0,objoff_36(a0)
	move.b	subtype(a0),routine(a0)
	addq.b	#2,routine(a0)
	move.w	#-$40,x_vel(a0)
	btst	#0,status(a0)
	beq.s	return_371DA
	neg.w	x_vel(a0)

return_371DA:
	rts
; ===========================================================================

; loc_371DC:
Obj95_WaitForPlayer:
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	x_pos(a0),d0
	bcc.s	loc_371E8
	neg.w	d0

loc_371E8:
	cmpi.w	#$A0,d0
	bhs.s	loc_3720C
	move.w	(MainCharacter+y_pos).w,d0
	sub.w	y_pos(a0),d0
	bcc.s	loc_371FA
	neg.w	d0

loc_371FA:
	cmpi.w	#$50,d0
	bhs.s	loc_3720C
	tst.w	(Debug_placement_mode).w
	bne.s	loc_3720C
	move.b	#1,anim(a0)

loc_3720C:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(Ani_obj95_a).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	andi.b	#3,mapping_frame(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_37224:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(Ani_obj95_b).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	andi.b	#3,mapping_frame(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

; loc_3723C:
Obj95_FireballUpdate:
	lea	(Ani_obj95_b).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	movea.l	objoff_3C(a0),a1 ; a1=object
	_cmpi.b	#ObjID_Sol,id(a1) ; check if parent object is still alive
	bne.w	JmpTo65_DeleteObject
	cmpi.b	#2,mapping_frame(a1)
	bne.s	Obj95_FireballOrbit
	cmpi.b	#$40,angle(a0)
	bne.s	Obj95_FireballOrbit
	addq.b	#2,routine(a0)
	move.b	#0,anim(a0)
	subq.b	#1,objoff_37(a1)
	bne.s	loc_37278
	addq.b	#2,routine(a1)

loc_37278:
	move.w	#-$200,x_vel(a0)
	btst	#0,status(a1)
	beq.s	+
	neg.w	x_vel(a0)
+
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

; loc_3728E:
Obj95_FireballOrbit:
	move.b	angle(a0),d0
	jsr	(CalcSine).l
	asr.w	#4,d1
	add.w	x_pos(a1),d1
	move.w	d1,x_pos(a0)
	asr.w	#4,d0
	add.w	y_pos(a1),d0
	move.w	d0,y_pos(a0)
	move.b	objoff_36(a1),d0
	add.b	d0,angle(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_372B8:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	tst.b	render_flags(a0)
	bpl.w	JmpTo65_DeleteObject
	lea	(Ani_obj95_b).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; animation script
; off_372D2:
Ani_obj95_a:	offsetTable
		offsetTableEntry.w byte_372D6	; 0
		offsetTableEntry.w byte_372DA	; 1
byte_372D6:	dc.b  $F,  0,$FF,  0
byte_372DA:	dc.b  $F,  1,  2,$FE,  1
		even
; animation script
; off_372E0:
Ani_obj95_b:	offsetTable
		offsetTableEntry.w +
+		dc.b   5,  3,  4,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj95_MapUnc_372E6:	include "mappings/sprite/obj95.asm"

Invalid_SubObjData:

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 94,96 - Rexon (lava snake badnik), from HTZ
; ----------------------------------------------------------------------------
; Sprite_37322:
Obj94:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj94_Index(pc,d0.w),d1
	jmp	Obj94_Index(pc,d1.w)
; ===========================================================================
; off_37330:
Obj94_Index:	offsetTable
		offsetTableEntry.w Obj94_Init	; 0
		offsetTableEntry.w Obj94_WaitForPlayer	; 2
		offsetTableEntry.w Obj94_ReadyToCreateHead	; 4
		offsetTableEntry.w Obj94_PostCreateHead	; 6
; ===========================================================================
; loc_37338:
Obj94_Init:
	bsr.w	LoadSubObject
	move.b	#2,mapping_frame(a0)
	move.w	#-$20,x_vel(a0)
	move.b	#$80,objoff_2A(a0)
	rts
; ===========================================================================

; loc_37350:
Obj94_WaitForPlayer:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$60,d2
	cmpi.w	#$100,d2
	bhs.s	loc_37362
	bsr.w	Obj94_CreateHead

loc_37362:
	move.w	x_pos(a0),-(sp)
	bsr.w	Obj94_CheckTurnAround
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#$11,d3
	move.w	(sp)+,d4
	jsrto	SolidObject, JmpTo27_SolidObject
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

; loc_37380:
Obj94_CheckTurnAround:
	subq.b	#1,objoff_2A(a0)
	bpl.s	loc_37396
	move.b	#$80,objoff_2A(a0)
	neg.w	x_vel(a0)
	bchg	#0,render_flags(a0)

loc_37396:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	rts
; ===========================================================================

; loc_3739C:
Obj94_ReadyToCreateHead:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$60,d2
	cmpi.w	#$100,d2
	bhs.s	loc_373AE
	bsr.w	Obj94_CreateHead

loc_373AE:
	bsr.w	Obj94_SolidCollision
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

; loc_373B6:
Obj94_SolidCollision:
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	x_pos(a0),d4
	jmpto	SolidObject, JmpTo27_SolidObject
; ===========================================================================

; loc_373CA:
Obj94_PostCreateHead:
	bsr.s	Obj94_SolidCollision
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 97 - Rexon's head, from HTZ
; ----------------------------------------------------------------------------
; Sprite_373D0:
Obj97:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj97_Index(pc,d0.w),d1
	jmp	Obj97_Index(pc,d1.w)
; ===========================================================================
; off_373DE:
Obj97_Index:	offsetTable
		offsetTableEntry.w Obj97_Init	; 0
		offsetTableEntry.w Obj97_InitialWait	; 2
		offsetTableEntry.w Obj97_RaiseHead	; 4
		offsetTableEntry.w Obj97_Normal	; 6
		offsetTableEntry.w Obj97_DeathDrop	; 8
; ===========================================================================
; loc_373E8:
Obj97_Init:
	bsr.w	LoadSubObject
	move.b	#8,width_pixels(a0)
	moveq	#$28,d0
	btst	#0,render_flags(a0)
	bne.s	+
	moveq	#-$18,d0
+
	add.w	d0,x_pos(a0)
	addi.w	#$10,y_pos(a0)
	move.b	#1,objoff_38(a0)
	movea.w	objoff_2C(a0),a1 ; a1=object
	lea	objoff_2E(a1),a1
	move.b	#$B,collision_flags(a0)
	moveq	#0,d0
	move.w	objoff_2E(a0),d0
	cmpi.w	#8,d0
	beq.s	+
	move.b	#1,mapping_frame(a0)
	move.b	#$8B,collision_flags(a0)
	move.w	(a1,d0.w),objoff_30(a0)
+
	move.w	6(a1),objoff_32(a0)
	lsr.w	#1,d0
	move.b	byte_3744E(pc,d0.w),objoff_2A(a0)
	move.b	d0,objoff_39(a0)
	rts
; ===========================================================================
byte_3744E:
	dc.b $1E
	dc.b $18	; 1
	dc.b $12	; 2
	dc.b  $C	; 3
	dc.b   6	; 4
	dc.b   0	; 5
	even
; ===========================================================================

; loc_37454:
Obj97_InitialWait:
    if gameRevision<2
	bsr.w	Obj97_CheckHeadIsAlive
	subq.b	#1,objoff_2A(a0)
	bmi.s	Obj97_StartRaise
    else
	; fixes an occational crash when defeated
	subq.b	#1,objoff_2A(a0)
	bmi.s	Obj97_StartRaise
	bsr.w	Obj97_CheckHeadIsAlive
    endif
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

; loc_37462:
Obj97_StartRaise:
	addq.b	#2,routine(a0)
	move.w	#-$120,x_vel(a0)
	move.w	#-$200,y_vel(a0)
	move.w	objoff_2E(a0),d0
	subi_.w	#8,d0
	neg.w	d0
	lsr.w	#1,d0
	move.b	byte_3744E(pc,d0.w),objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

; loc_37488:
Obj97_RaiseHead:
    if gameRevision<2
	bsr.w	Obj97_CheckHeadIsAlive
	moveq	#$10,d0
	add.w	d0,x_vel(a0)
	subq.b	#1,objoff_2A(a0)
	bmi.s	Obj97_StartNormalState
    else
	; fixes an occational crash when defeated
	moveq	#$10,d0
	add.w	d0,x_vel(a0)
	subq.b	#1,objoff_2A(a0)
	bmi.s	Obj97_StartNormalState
	bsr.w	Obj97_CheckHeadIsAlive
    endif
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

; loc_374A0:
Obj97_StartNormalState:
	addq.b	#2,routine(a0)
	bsr.w	Obj_MoveStop
	move.b	#$20,objoff_2A(a0)
	move.w	objoff_2E(a0),d0
	lsr.w	#1,d0
	move.b	byte_374BE(pc,d0.w),objoff_2B(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
byte_374BE:
	dc.b $24
	dc.b $20	; 1
	dc.b $1C	; 2
	dc.b $1A	; 3
	even
; ===========================================================================

; loc_374C2:
Obj97_Normal:
	bsr.w	Obj97_CheckHeadIsAlive
	cmpi.w	#8,objoff_2E(a0)
	bne.s	loc_374D8
	subq.b	#1,objoff_2A(a0)
	bpl.s	loc_374D8
	bsr.w	Obj97_FireProjectile

loc_374D8:
	move.b	objoff_39(a0),d0
	addq.b	#1,d0
	move.b	d0,objoff_39(a0)
	andi.b	#3,d0
	bne.s	+
	bsr.w	loc_3758A
	bsr.w	Obj97_Oscillate
+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

; loc_374F4:
Obj97_DeathDrop:
	move.w	(Camera_Max_Y_pos).w,d0
	addi.w	#224,d0
	cmp.w	y_pos(a0),d0
	blo.w	JmpTo65_DeleteObject
	jsrto	ObjectMoveAndFall, JmpTo8_ObjectMoveAndFall
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

; loc_3750C:
Obj97_CheckHeadIsAlive:
	movea.w	objoff_32(a0),a1 ; a1=object
	cmpi.b	#ObjID_RexonHead,id(a1)
	beq.s	+	; rts
	move.b	#8,routine(a0)
	move.w	objoff_2E(a0),d0
	move.w	word_37528(pc,d0.w),x_vel(a0)
+
	rts
; ===========================================================================
word_37528:
	dc.w   $80
	dc.w -$100	; 1
	dc.w  $100	; 2
	dc.w  -$80	; 3
	dc.w   $80	; 4
; ===========================================================================

; loc_37532:
Obj97_FireProjectile:
	move.b	#$7F,objoff_2A(a0)
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	++	; rts
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#3,mapping_frame(a1)
	move.b	#$10,subtype(a1) ; <== Obj94_SubObjData2
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	lea	(ObjectMove).l,a2
	move.l	a2,objoff_2A(a1)
	moveq	#1,d0
	moveq	#$10,d1
	btst	#0,render_flags(a0)
	bne.s	+
	neg.w	d0
	neg.w	d1
+
	move.b	d0,x_vel(a1)
	add.w	d1,x_pos(a1)
	addq.w	#4,y_pos(a1)
	move.b	#$80,1+y_vel(a1)
+
	rts
; ===========================================================================

loc_3758A:
	move.b	objoff_2B(a0),d0
	move.b	objoff_38(a0),d1
	add.b	d1,d0
	move.b	d0,objoff_2B(a0)
	subi.b	#$18,d0
	beq.s	+
	bcs.s	+
	cmpi.b	#$10,d0
	blo.s	++	; rts
+
	neg.b	objoff_38(a0)
+
	rts
; ===========================================================================

; loc_375AC:
Obj94_CreateHead:
	move.b	#6,routine(a0)
	bclr	#0,render_flags(a0)
	tst.w	d0
	beq.s	+
	bset	#0,render_flags(a0)
+
	bsr.w	Obj_MoveStop
	lea	objoff_2C(a0),a2
	moveq	#0,d1
	moveq	#4,d6

loc_375CE:
	jsrto	AllocateObject, JmpTo19_AllocateObject
	bne.s	+	; rts
	_move.b	#ObjID_RexonHead,id(a1) ; load obj97
	move.b	render_flags(a0),render_flags(a1)
	move.b	subtype(a0),subtype(a1)
	move.w	a0,objoff_2C(a1)
	move.w	a1,(a2)+
	move.w	d1,objoff_2E(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addq.w	#2,d1
	dbf	d6,loc_375CE
+
	rts
; ===========================================================================

; loc_37604:
Obj97_Oscillate:
	move.w	objoff_30(a0),d0
	beq.s	+	; rts
	movea.w	d0,a1 ; a1=object
	lea	byte_376A8(pc),a2
	moveq	#0,d0
	move.b	objoff_2B(a0),d0
	andi.b	#$7F,d0
	move.w	d0,d1
	andi.w	#$1F,d0
	add.w	d0,d0
	move.b	(a2,d0.w),d2
	ext.w	d2
	move.b	1(a2,d0.w),d3
	ext.w	d3
	lsr.w	#4,d1
	andi.w	#6,d1
	move.w	off_37652(pc,d1.w),d1
	jsr	off_37652(pc,d1.w)
	move.w	x_pos(a0),d4
	add.w	d2,d4
	move.w	d4,x_pos(a1)
	move.b	1+y_pos(a0),d5
	add.b	d3,d5
	move.b	d5,1+y_pos(a1)
+
	rts
; ===========================================================================
off_37652:	offsetTable
		offsetTableEntry.w return_3765A	;   0
		offsetTableEntry.w loc_3765C	; $20
		offsetTableEntry.w loc_37662	; $40
		offsetTableEntry.w loc_37668	; $60
; ===========================================================================

return_3765A:
	rts
; ===========================================================================

loc_3765C:
	exg	d2,d3
	neg.w	d3
	rts
; ===========================================================================

loc_37662:
	neg.w	d2
	neg.w	d3
	rts
; ===========================================================================

loc_37668:
	exg	d2,d3
	neg.w	d2
	rts
; ===========================================================================
; off_3766E:
Obj94_SubObjData:
	subObjData Obj94_Obj98_MapUnc_37678,make_art_tile(ArtTile_ArtNem_Rexon,3,0),4,4,$10,0
; ------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------
Obj94_Obj98_MapUnc_37678:	include "mappings/sprite/obj97.asm"

; seems to be a lookup table for oscillating horizontal position offset
byte_376A8:
	dc.b $F,  0
	dc.b $F,$FF	; 1
	dc.b $F,$FF	; 2
	dc.b $F,$FE	; 3
	dc.b $F,$FD	; 4
	dc.b $F,$FC	; 5
	dc.b $E,$FC	; 6
	dc.b $E,$FB	; 7
	dc.b $E,$FA	; 8
	dc.b $E,$FA	; 9
	dc.b $D,$F9	; 10
	dc.b $D,$F8	; 11
	dc.b $C,$F8	; 12
	dc.b $C,$F7	; 13
	dc.b $C,$F6	; 14
	dc.b $B,$F6	; 15
	dc.b $B,$F5	; 16
	dc.b $A,$F5	; 17
	dc.b $A,$F4	; 18
	dc.b  9,$F4	; 19
	dc.b  8,$F4	; 20
	dc.b  8,$F3	; 21
	dc.b  7,$F3	; 22
	dc.b  6,$F2	; 23
	dc.b  6,$F2	; 24
	dc.b  5,$F2	; 25
	dc.b  4,$F2	; 26
	dc.b  4,$F1	; 27
	dc.b  3,$F1	; 28
	dc.b  2,$F1	; 29
	dc.b  1,$F1	; 30
	dc.b  1,$F1	; 31




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 98 - Projectile with optional gravity (EHZ coconut, CPZ spiny, etc.)
; ----------------------------------------------------------------------------
; Sprite_376E8:
Obj98:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj98_Index(pc,d0.w),d1
	jmp	Obj98_Index(pc,d1.w)
; ===========================================================================
; off_376F6: Obj98_States:
Obj98_Index:	offsetTable
		offsetTableEntry.w Obj98_Init	; 0
		offsetTableEntry.w Obj98_Main	; 2
; ===========================================================================
; loc_376FA:
Obj98_Init: ;;
	bra.w	LoadSubObject
; ===========================================================================
; loc_376FE:
Obj98_Main:
	tst.b	render_flags(a0)
	bpl.w	JmpTo65_DeleteObject
	movea.l	objoff_2A(a0),a1
	jsr	(a1)	; dynamic call! to Obj98_NebulaBombFall, Obj98_TurtloidShotMove, Obj98_CoconutFall, Obj98_CluckerShotMove, Obj98_SpinyShotFall, or Obj98_WallTurretShotMove, assuming the code hasn't been changed
	jmpto	MarkObjGone, JmpTo39_MarkObjGone

; ===========================================================================
; for obj99
; loc_37710:
Obj98_NebulaBombFall:
	bchg	#palette_bit_0,art_tile(a0) ; bypass the animation system and make it blink
	jmpto	ObjectMoveAndFall, JmpTo8_ObjectMoveAndFall

; ===========================================================================
; for obj9A
; loc_3771A:
Obj98_TurtloidShotMove:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(Ani_TurtloidShot).l,a1
	jmpto	AnimateSprite, JmpTo25_AnimateSprite

; ===========================================================================
; for obj9D
; loc_37728:
Obj98_CoconutFall:
	addi.w	#$20,y_vel(a0) ; apply gravity (less than normal)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	rts

; ===========================================================================
; for objAE
; loc_37734:
Obj98_CluckerShotMove:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(Ani_CluckerShot).l,a1
	jmpto	AnimateSprite, JmpTo25_AnimateSprite

; ===========================================================================
; for objA6
; loc_37742:
Obj98_SpinyShotFall:
	addi.w	#$20,y_vel(a0) ; apply gravity (less than normal)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(Ani_SpinyShot).l,a1
	jmpto	AnimateSprite, JmpTo25_AnimateSprite

; ===========================================================================
; for objB8
; loc_37756:
Obj98_WallTurretShotMove:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(Ani_WallTurretShot).l,a1
	jmpto	AnimateSprite, JmpTo25_AnimateSprite

; ===========================================================================
; off_37764:
Obj94_SubObjData2:
	subObjData Obj94_Obj98_MapUnc_37678,make_art_tile(ArtTile_ArtNem_Rexon,1,0),$84,4,4,$98
; off_3776E:
Obj99_SubObjData:
	subObjData Obj99_Obj98_MapUnc_3789A,make_art_tile(ArtTile_ArtNem_Nebula,1,1),$84,4,8,$8B
; off_37778:
Obj9A_SubObjData2:
	subObjData Obj9A_Obj98_MapUnc_37B62,make_art_tile(ArtTile_ArtNem_Turtloid,0,0),$84,4,4,$98
; off_37782:
Obj9D_SubObjData2:
	subObjData Obj9D_Obj98_MapUnc_37D96,make_art_tile(ArtTile_ArtNem_Coconuts,0,0),$84,4,8,$8B
; off_3778C:
ObjA4_SubObjData2:
	subObjData ObjA4_Obj98_MapUnc_38A96,make_art_tile(ArtTile_ArtNem_MtzSupernova,0,1),$84,5,4,$98
; off_37796:
ObjA6_SubObjData:
	subObjData ObjA5_ObjA6_Obj98_MapUnc_38CCA,make_art_tile(ArtTile_ArtNem_Spiny,1,0),$84,5,4,$98
; off_377A0:
ObjA7_SubObjData3:
	subObjData ObjA7_ObjA8_ObjA9_Obj98_MapUnc_3921A,make_art_tile(ArtTile_ArtNem_Grabber,1,1),$84,4,4,$98
; off_377AA:
ObjAD_SubObjData3:
	subObjData ObjAD_Obj98_MapUnc_395B4,make_art_tile(ArtTile_ArtNem_WfzScratch,0,0),$84,5,4,$98
; off_377B4:
ObjAF_SubObjData:
	subObjData ObjAF_Obj98_MapUnc_39E68,make_art_tile(ArtTile_ArtNem_CNZBonusSpike,1,0),$84,5,4,$98
; off_377BE:
ObjB8_SubObjData2:
	subObjData ObjB8_Obj98_MapUnc_3BA46,make_art_tile(ArtTile_ArtNem_WfzWallTurret,0,0),$84,3,4,$98




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 99 - Nebula (bomber badnik) from SCZ
; ----------------------------------------------------------------------------
; Sprite_377C8:
Obj99:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj99_Index(pc,d0.w),d1
	jmp	Obj99_Index(pc,d1.w)
; ===========================================================================
; off_377D6:
Obj99_Index:	offsetTable
		offsetTableEntry.w Obj99_Init
		offsetTableEntry.w loc_377E8
		offsetTableEntry.w loc_3781C
; ===========================================================================
; loc_377DC:
Obj99_Init:
	bsr.w	LoadSubObject
	move.w	#-$C0,x_vel(a0)
	rts
; ===========================================================================

loc_377E8:
	bsr.w	Obj_GetOrientationToPlayer
	tst.w	d0
	bne.s	loc_377FA
	cmpi.w	#$80,d2
	bhs.s	loc_377FA
	bsr.w	loc_37810

loc_377FA:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	bsr.w	loc_36776
	lea	(Ani_obj99).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================

loc_37810:
	addq.b	#2,routine(a0)
	move.w	#-$A0,y_vel(a0)
	rts
; ===========================================================================

loc_3781C:
	tst.b	objoff_2A(a0)
	bne.s	loc_37834
	bsr.w	Obj_GetOrientationToPlayer
	addi_.w	#8,d2
	cmpi.w	#$10,d2
	bhs.s	loc_37834
	bsr.w	loc_37850

loc_37834:
	addi_.w	#1,y_vel(a0)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	bsr.w	loc_36776
	lea	(Ani_obj99).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================

loc_37850:
	st.b	objoff_2A(a0)
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	return_37886
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#4,mapping_frame(a1)
	move.b	#$14,subtype(a1) ; <== Obj99_SubObjData
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$18,y_pos(a1)
	lea_	Obj98_NebulaBombFall,a2
	move.l	a2,objoff_2A(a1)

return_37886:
	rts
; ===========================================================================
; off_37888:
Obj99_SubObjData2:
	subObjData Obj99_Obj98_MapUnc_3789A,make_art_tile(ArtTile_ArtNem_Nebula,1,1),4,4,$10,6
; animation script
; off_37892:
Ani_obj99:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3,  0,  1,  2,  3,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj99_Obj98_MapUnc_3789A:	include "mappings/sprite/obj99.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 9A - Turtloid (turtle badnik) from Sky Chase Zone
; ----------------------------------------------------------------------------
; Sprite_37936:
Obj9A:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj9A_Index(pc,d0.w),d1
	jmp	Obj9A_Index(pc,d1.w)
; ===========================================================================
; off_37944:
Obj9A_Index:	offsetTable
		offsetTableEntry.w Obj9A_Init	; 0
		offsetTableEntry.w Obj9A_Main	; 2
; ===========================================================================
; loc_37948:
Obj9A_Init:
	bsr.w	LoadSubObject
	move.w	#-$80,x_vel(a0)
	bsr.w	loc_37A4A
	lea	(Ani_obj9A).l,a1
	move.l	a1,objoff_2E(a0)
	bra.w	loc_37ABE
; ===========================================================================
; loc_37964:
Obj9A_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3797A(pc,d0.w),d1
	jsr	off_3797A(pc,d1.w)
	bsr.w	loc_37982
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================
off_3797A:	offsetTable
		offsetTableEntry.w loc_379A0	; 0
		offsetTableEntry.w loc_379CA	; 2
		offsetTableEntry.w loc_379EA	; 4
		offsetTableEntry.w return_37A04	; 6
; ===========================================================================

loc_37982:
	move.w	x_pos(a0),-(sp)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	bsr.w	loc_36776
	move.w	#$18,d1
	move.w	#8,d2
	move.w	#$E,d3
	move.w	(sp)+,d4
	jmpto	PlatformObject, JmpTo9_PlatformObject
; ===========================================================================

loc_379A0:
	bsr.w	Obj_GetOrientationToPlayer
	tst.w	d0
	bmi.w	return_37A48
	cmpi.w	#$80,d2
	bhs.w	return_37A48
	addq.b	#2,routine_secondary(a0)
	move.w	#0,x_vel(a0)
	move.b	#4,objoff_2A(a0)
	move.b	#1,mapping_frame(a0)
	rts
; ===========================================================================

loc_379CA:
	subq.b	#1,objoff_2A(a0)
	bpl.w	return_37A48
	addq.b	#2,routine_secondary(a0)
	move.b	#8,objoff_2A(a0)
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.b	#3,mapping_frame(a1)
	bra.w	loc_37AF2
; ===========================================================================

loc_379EA:
	subq.b	#1,objoff_2A(a0)
	bpl.s	return_37A02
	addq.b	#2,routine_secondary(a0)
	move.w	#-$80,x_vel(a0)
	clr.b	mapping_frame(a0)
	movea.w	objoff_2C(a0),a1 ; a1=object

return_37A02:
	rts
; ===========================================================================

return_37A04:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 9B - Turtloid rider from Sky Chase Zone
; ----------------------------------------------------------------------------
; Sprite_37A06:
Obj9B:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj9B_Index(pc,d0.w),d1
	jmp	Obj9B_Index(pc,d1.w)
; ===========================================================================
; off_37A14:
Obj9B_Index:	offsetTable
		offsetTableEntry.w Obj9B_Init	; 0
		offsetTableEntry.w Obj9B_Main	; 2
; ===========================================================================
; BranchTo_LoadSubObject
Obj9B_Init:
	bra.w	LoadSubObject
; ===========================================================================
; loc_37A1C:
Obj9B_Main:
	movea.w	objoff_2C(a0),a1 ; a1=object
	lea	word_37A2C(pc),a2
	bsr.w	loc_37A30
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================
word_37A2C:
	dc.w	 4	; 0
	dc.w  -$18	; 1
; ===========================================================================

loc_37A30:
	move.l	x_pos(a1),x_pos(a0)
	move.l	y_pos(a1),y_pos(a0)
	move.w	(a2)+,d0
	add.w	d0,x_pos(a0)
	move.w	(a2)+,d0
	add.w	d0,y_pos(a0)

return_37A48:
	rts
; ===========================================================================

loc_37A4A:
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	return_37A80
	_move.b	#ObjID_TurtloidRider,id(a1) ; load obj9B
	move.b	#2,mapping_frame(a1)
	move.b	#$18,subtype(a1) ; <== Obj9B_SubObjData
	move.w	a0,objoff_2C(a1)
	move.w	a1,objoff_2C(a0)
	move.w	x_pos(a0),x_pos(a1)
	addq.w	#4,x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	subi.w	#$18,y_pos(a1)

return_37A80:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 9C - Balkiry's jet from Sky Chase Zone
; ----------------------------------------------------------------------------
; Sprite_37A82:
Obj9C:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj9C_Index(pc,d0.w),d1
	jmp	Obj9C_Index(pc,d1.w)
; ===========================================================================
; off_37A90:
Obj9C_Index:	offsetTable
		offsetTableEntry.w Obj9C_Init
		offsetTableEntry.w Obj9C_Main
; ===========================================================================
; BranchTo2_LoadSubObject
Obj9C_Init:
	bra.w	LoadSubObject
; ===========================================================================
; loc_37A98:
Obj9C_Main:
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.b	objoff_32(a0),d0
	cmp.b	id(a1),d0
	bne.w	JmpTo65_DeleteObject
	move.l	x_pos(a1),x_pos(a0)
	move.l	y_pos(a1),y_pos(a0)
	movea.l	objoff_2E(a0),a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================

loc_37ABE:
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	+	; rts
	_move.b	#ObjID_BalkiryJet,id(a1) ; load obj9C
	move.b	#6,mapping_frame(a1)
	move.b	#$1A,subtype(a1) ; <== Obj9C_SubObjData
	move.w	a0,objoff_2C(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.l	objoff_2E(a0),objoff_2E(a1)
	move.b	id(a0),objoff_32(a1)
+
	rts

; ===========================================================================
; this code is for Obj9A

loc_37AF2:
	jsrto	AllocateObject, JmpTo19_AllocateObject
	bne.s	+	; rts
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#6,mapping_frame(a1)
	move.b	#$1C,subtype(a1) ; <== Obj9A_SubObjData2
	move.w	x_pos(a0),x_pos(a1)
	subi.w	#$14,x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$A,y_pos(a1)
	move.w	#-$100,x_vel(a1)
	lea_	Obj98_TurtloidShotMove,a2
	move.l	a2,objoff_2A(a1)
+
	rts
; ===========================================================================
; off_37B32:
Obj9A_SubObjData:
	subObjData Obj9A_Obj98_MapUnc_37B62,make_art_tile(ArtTile_ArtNem_Turtloid,0,0),4,5,$18,0
; off_37B3C:
Obj9B_SubObjData:
	subObjData Obj9A_Obj98_MapUnc_37B62,make_art_tile(ArtTile_ArtNem_Turtloid,0,0),4,4,$C,$1A
; off_37B46:
Obj9C_SubObjData:
	subObjData Obj9A_Obj98_MapUnc_37B62,make_art_tile(ArtTile_ArtNem_Turtloid,0,0),4,5,8,0

; animation script
; off_37B50: TurtloidShotAniData:
Ani_TurtloidShot: offsetTable
		offsetTableEntry.w +
+		dc.b   1,  4,  5,$FF
		even

; animation script
; off_37B56:
Ani_obj9A:	offsetTable
		offsetTableEntry.w +
+		dc.b   1,  6,  7,$FF
		even

; animation script
; off_37B5C:
Ani_obj9C:	offsetTable
		offsetTableEntry.w +
+		dc.b   1,  8,  9,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj9A_Obj98_MapUnc_37B62:	include "mappings/sprite/obj9C.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 9D - Coconuts (monkey badnik) from EHZ
; ----------------------------------------------------------------------------
; OST Variables:
Obj9D_timer		= objoff_2A	; byte
Obj9D_climb_table_index	= objoff_2C	; word
Obj9D_attack_timer	= objoff_2E	; byte	; time player needs to spend close to object before it attacks
; Sprite_37BFA:
Obj9D:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj9D_Index(pc,d0.w),d1
	jmp	Obj9D_Index(pc,d1.w)
; ===========================================================================
; off_37C08:
Obj9D_Index:	offsetTable
		offsetTableEntry.w Obj9D_Init		; 0
		offsetTableEntry.w Obj9D_Idle		; 2
		offsetTableEntry.w Obj9D_Climbing	; 4
		offsetTableEntry.w Obj9D_Throwing	; 6
; ===========================================================================
; loc_37C10:
Obj9D_Init:
	bsr.w	LoadSubObject
	move.b	#$10,Obj9D_timer(a0)
	rts
; ===========================================================================
; loc_37C1C: Obj9D_Main:
Obj9D_Idle:
	bsr.w	Obj_GetOrientationToPlayer
	bclr	#0,render_flags(a0)	; face right
	bclr	#0,status(a0)
	tst.w	d0		; is player to object's left?
	beq.s	+		; if not, branch
	bset	#0,render_flags(a0)	; face left
	bset	#0,status(a0)
+
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	bcc.s	+	; branch, if distance to player is greater than 60 in either direction
	tst.b	Obj9D_attack_timer(a0)	; wait for a bit before attacking
	beq.s	Obj9D_StartThrowing	; branch, when done waiting
	subq.b	#1,Obj9D_attack_timer(a0)
+
	subq.b	#1,Obj9D_timer(a0)	; wait for a bit...
	bmi.s	Obj9D_StartClimbing	; branch, when done waiting
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------

Obj9D_StartClimbing:
	addq.b	#2,routine(a0)	; => Obj9D_Climbing
	bsr.w	Obj9D_SetClimbingDirection
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
; loc_37C66:
Obj9D_StartThrowing:
	move.b	#6,routine(a0)	; => Obj9D_Throwing
	move.b	#1,mapping_frame(a0)	; display first throwing frame
	move.b	#8,Obj9D_timer(a0)	; set time to display frame
	move.b	#$20,Obj9D_attack_timer(a0)	; reset timer
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
; loc_37C82:
Obj9D_SetClimbingDirection:
	move.w	Obj9D_climb_table_index(a0),d0
	cmpi.w	#$C,d0
	blo.s	+	; branch, if index is less than $C
	moveq	#0,d0	; otherwise, reset to 0
+
	lea	Obj9D_ClimbData(pc,d0.w),a1
	addq.w	#2,d0
	move.w	d0,Obj9D_climb_table_index(a0)
	move.b	(a1)+,y_vel(a0)	; climbing speed
	move.b	(a1)+,Obj9D_timer(a0) ; time to spend moving at this speed
	rts
; ===========================================================================
; byte_37CA2:
Obj9D_ClimbData:
	dc.b  -1,$20
	dc.b   1,$18	; 2
	dc.b  -1,$10	; 4
	dc.b   1,$28	; 6
	dc.b  -1,$20	; 8
	dc.b   1,$10	; 10
; ===========================================================================
; loc_37CAE: Obj09_Climbing:
Obj9D_Climbing:
	subq.b	#1,Obj9D_timer(a0)
	beq.s	Obj9D_StopClimbing	; branch, if done moving
	jsrto	ObjectMove, JmpTo26_ObjectMove	; else, keep moving
	lea	(Ani_obj09).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; loc_37CC6:
Obj9D_StopClimbing:
	subq.b	#2,routine(a0)	; => Obj9D_Idle
	move.b	#$10,Obj9D_timer(a0)	; time to remain idle
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; loc_37CD4: Obj09_Throwing:
Obj9D_Throwing:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj9D_ThrowingStates(pc,d0.w),d1
	jsr	Obj9D_ThrowingStates(pc,d1.w)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; off_37CE6:
Obj9D_ThrowingStates:	offsetTable
		offsetTableEntry.w Obj9D_ThrowingHandRaised	; 0
		offsetTableEntry.w Obj9D_ThrowingHandLowered	; 2
; ===========================================================================
; loc_37CEA:
Obj9D_ThrowingHandRaised:
	subq.b	#1,Obj9D_timer(a0)	; wait for a bit...
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+	addq.b	#2,routine_secondary(a0)	; => Obj9D_ThrowingHandLowered
	move.b	#8,Obj9D_timer(a0)
	move.b	#2,mapping_frame(a0)	; display second throwing frame
	bra.w	Obj9D_CreateCoconut
; ===========================================================================
; loc_37D06:
Obj9D_ThrowingHandLowered:
	subq.b	#1,Obj9D_timer(a0)	; wait for a bit...
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+	clr.b	routine_secondary(a0)	; reset routine counter for next time
	move.b	#4,routine(a0) ; => Obj9D_Climbing
	move.b	#8,Obj9D_timer(a0)	; this gets overwrittten by the next subroutine...
	bra.w	Obj9D_SetClimbingDirection
; ===========================================================================
; loc_37D22:
Obj9D_CreateCoconut:
	jsrto	AllocateObject, JmpTo19_AllocateObject
	bne.s	return_37D74		; branch, if no free slots
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#3,mapping_frame(a1)
	move.b	#$20,subtype(a1) ; <== Obj9D_SubObjData2
	move.w	x_pos(a0),x_pos(a1)	; align with parent object
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#-$D,y_pos(a1)		; offset slightly upward
	moveq	#0,d0		; use rightfacing data
	btst	#0,render_flags(a0)	; is object facing left?
	bne.s	+		; if yes, branch
	moveq	#4,d0		; use leftfacing data
+
	lea	Obj9D_ThrowData(pc,d0.w),a2
	move.w	(a2)+,d0
	add.w	d0,x_pos(a1)	; offset slightly left or right depending on object's direction
	move.w	(a2)+,x_vel(a1)	; set projectile speed
	move.w	#-$100,y_vel(a1)
	lea_	Obj98_CoconutFall,a2 ; set the routine used to move the projectile
	move.l	a2,objoff_2A(a1)

return_37D74:
	rts
; ===========================================================================
; word_37D76:
Obj9D_ThrowData:
	dc.w   -$B,  $100	; 0
	dc.w	$B, -$100	; 4
; off_37D7E:
Obj9D_SubObjData:
	subObjData Obj9D_Obj98_MapUnc_37D96,make_art_tile(ArtTile_ArtNem_Coconuts,0,0),4,5,$C,9

; animation script
; off_37D88:
Ani_obj09:	offsetTable
		offsetTableEntry.w byte_37D8C	; 0
		offsetTableEntry.w byte_37D90	; 1
byte_37D8C:	dc.b   5,  0,  1,$FF
byte_37D90:	dc.b   9,  1,  2,  1,$FF
		even
; ------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------
Obj9D_Obj98_MapUnc_37D96:	include "mappings/sprite/obj9D.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 9E - Crawlton (snake badnik) from MCZ
; ----------------------------------------------------------------------------
; Sprite_37E16:
Obj9E:
	moveq	#0,d0
	move.b	objoff_3B(a0),d0
	move.w	Obj9E_Index(pc,d0.w),d1
	jmp	Obj9E_Index(pc,d1.w)
; ===========================================================================
; off_37E24:
Obj9E_Index:	offsetTable
		offsetTableEntry.w Obj9E_Init	;  0
		offsetTableEntry.w loc_37E42	;  2
		offsetTableEntry.w loc_37E98	;  4
		offsetTableEntry.w loc_37EB6	;  6
		offsetTableEntry.w loc_37ED4	;  8
		offsetTableEntry.w loc_37EFC	; $A
; ===========================================================================
; loc_37E30:
Obj9E_Init:
	bsr.w	LoadSubObject
	move.b	#$80,y_radius(a0)
	addq.b	#2,objoff_3B(a0)
	bra.w	loc_37F74
; ===========================================================================

loc_37E42:
	bsr.w	Obj_GetOrientationToPlayer
	move.w	d2,d4
	move.w	d3,d5
	addi.w	#$80,d2
	cmpi.w	#$100,d2
	bhs.s	+
	addi.w	#$80,d3
	cmpi.w	#$100,d3
	blo.s	loc_37E62
+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_37E62:
	addq.b	#2,objoff_3B(a0)
	move.b	#$10,objoff_3A(a0)
	bclr	#0,render_flags(a0)
	tst.w	d0
	beq.s	+
	bset	#0,render_flags(a0)
+
	neg.w	d4
	lsl.w	#3,d4
	andi.w	#$FF00,d4
	move.w	d4,x_vel(a0)
	neg.w	d5
	lsl.w	#3,d5
	andi.w	#$FF00,d5
	move.w	d5,y_vel(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_37E98:
	subq.b	#1,objoff_3A(a0)
	bmi.s	+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
+
	addq.b	#2,objoff_3B(a0)
	move.b	#8,objoff_39(a0)
	move.b	#$1C,objoff_3A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_37EB6:
	subq.b	#1,objoff_3A(a0)
	beq.s	+
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
+
	move.b	objoff_39(a0),objoff_3B(a0)
	move.b	#$20,objoff_3A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_37ED4:
	subq.b	#1,objoff_3A(a0)
	beq.s	+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
+
	move.b	#6,objoff_3B(a0)
	move.b	#2,objoff_39(a0)
	move.b	#$1C,objoff_3A(a0)
	neg.w	x_vel(a0)
	neg.w	y_vel(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_37EFC:
	movea.w	parent(a0),a1 ; a1=object
	cmpi.b	#ObjID_Crawlton,id(a1)
	bne.w	JmpTo65_DeleteObject
	bclr	#0,render_flags(a0)
	btst	#0,render_flags(a1)
	beq.s	+
	bset	#0,render_flags(a0)
+
	move.b	#$80,objoff_14(a0)
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	cmpi.b	#6,objoff_3B(a1)
	bne.s	loc_37F6C
	move.w	x_vel(a1),d2
	asr.w	#8,d2
	move.w	y_vel(a1),d3
	asr.w	#8,d3
	lea	subspr_data(a0),a2
	move.b	objoff_3A(a1),d0
	moveq	#$18,d1

	moveq	#6,d6
-	move.w	(a2),d4		; sub?_x_pos
	move.w	2(a2),d5	; sub?_y_pos
	cmp.b	d1,d0
	bhs.s	+
	add.w	d2,d4
	add.w	d3,d5
+
	move.w	d4,(a2)+	; sub?_x_pos
	move.w	d5,(a2)+	; sub?_y_pos
	subi_.b	#4,d1
	bcs.s	loc_37F6C
	addq.w	#next_subspr-4,a2
	dbf	d6,-

loc_37F6C:
	move.w	#object_display_list_size*5,d0
	jmpto	DisplaySprite3, JmpTo5_DisplaySprite3
; ===========================================================================

loc_37F74:
	jsrto	AllocateObject, JmpTo19_AllocateObject
	bne.s	+	; rts
	_move.b	#ObjID_Crawlton,id(a1) ; load obj9E
	move.b	render_flags(a0),render_flags(a1)
	bset	#6,render_flags(a1)
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#$A,objoff_3B(a1)
	move.b	#0,mainspr_mapframe(a1)
	move.b	#$80,mainspr_width(a1)
	move.b	#7,mainspr_childsprites(a1)
	move.w	a0,parent(a1)
	move.w	x_pos(a0),d2
	move.w	d2,x_pos(a1)
	move.w	y_pos(a0),d3
	move.w	d3,y_pos(a1)
	move.b	#$80,objoff_14(a1)
	bset	#4,render_flags(a1)
	lea	subspr_data(a1),a2

	moveq	#6,d6
-	move.w	d2,(a2)+	; sub?_x_pos
	move.w	d3,(a2)+	; sub?_y_pos
	move.w	#2,(a2)+	; sub?_mapframe
	addi.w	#$10,d1
	dbf	d6,-
+
	rts
; ===========================================================================
; off_37FE8:
Obj9E_SubObjData:
	subObjData Obj9E_MapUnc_37FF2,make_art_tile(ArtTile_ArtNem_Crawlton,1,0),4,4,$80,$B
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj9E_MapUnc_37FF2:	include "mappings/sprite/obj9E.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 9F - Shellcraker (crab badnik) from MTZ
; ----------------------------------------------------------------------------
; Sprite_3800C:
Obj9F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj9F_Index(pc,d0.w),d1
	jmp	Obj9F_Index(pc,d1.w)
; ===========================================================================
; off_3801A:
Obj9F_Index:	offsetTable
		offsetTableEntry.w Obj9F_Init	; 0
		offsetTableEntry.w loc_3804E	; 2
		offsetTableEntry.w loc_380C4	; 4
		offsetTableEntry.w loc_380FC	; 6
; ===========================================================================
; loc_38022:
Obj9F_Init:
	bsr.w	LoadSubObject
	btst	#0,render_flags(a0)
	beq.s	+
	bset	#0,status(a0)
+
	move.w	#-$40,x_vel(a0)
	move.b	#$C,y_radius(a0)
	move.b	#$18,x_radius(a0)
	move.w	#$140,objoff_2A(a0)
	rts
; ===========================================================================

loc_3804E:
	bsr.w	Obj_GetOrientationToPlayer
	tst.w	d0
	beq.s	loc_3805E
	btst	#0,render_flags(a0)
	beq.s	loc_38068

loc_3805E:
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	blo.s	loc_380AE

loc_38068:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jsr	(ObjCheckFloorDist).l
	cmpi.w	#-8,d1
	blt.s	loc_38096
	cmpi.w	#$C,d1
	bge.s	loc_38096
	add.w	d1,y_pos(a0)
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3809A
	lea	(Ani_obj9F).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38096:
	neg.w	x_vel(a0)

loc_3809A:
	addq.b	#2,routine(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#$3B,objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_380AE:
	move.b	#6,routine(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#8,objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_380C4:
	tst.b	render_flags(a0)
	bpl.s	loc_380E4
	bsr.w	Obj_GetOrientationToPlayer
	tst.w	d0
	beq.s	loc_380DA
	btst	#0,render_flags(a0)
	beq.s	loc_380E4

loc_380DA:
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	blo.s	loc_380AE

loc_380E4:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_380EE
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_380EE:
	subq.b	#2,routine(a0)
	move.w	#$140,objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_380FC:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3810E(pc,d0.w),d1
	jsr	off_3810E(pc,d1.w)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
off_3810E:	offsetTable
		offsetTableEntry.w loc_38114	; 0
		offsetTableEntry.w loc_3812A	; 2
		offsetTableEntry.w loc_3813E	; 4
; ===========================================================================

loc_38114:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3811C
	rts
; ===========================================================================

loc_3811C:
	addq.b	#2,routine_secondary(a0)
	move.b	#3,mapping_frame(a0)
	bra.w	loc_38292
; ===========================================================================

loc_3812A:
	tst.b	objoff_2C(a0)
	bne.s	loc_38132
	rts
; ===========================================================================

loc_38132:
	addq.b	#2,routine_secondary(a0)
	move.w	#$20,objoff_2A(a0)
	rts
; ===========================================================================

loc_3813E:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_38146
	rts
; ===========================================================================

loc_38146:
	clr.b	routine_secondary(a0)
	clr.b	objoff_2C(a0)
	move.b	#2,routine(a0)
	move.w	#$140,objoff_2A(a0)
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Object A0 - Shellcracker's claw from MTZ
; ----------------------------------------------------------------------------
; Sprite_3815C:
ObjA0:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA0_Index(pc,d0.w),d1
	jmp	ObjA0_Index(pc,d1.w)
; ===========================================================================
; off_3816A:
ObjA0_Index:	offsetTable
		offsetTableEntry.w ObjA0_Init	; 0
		offsetTableEntry.w loc_381AC	; 2
		offsetTableEntry.w loc_38280	; 4
; ===========================================================================
; loc_38170:
ObjA0_Init:
	bsr.w	LoadSubObject
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.b	render_flags(a1),d0
	andi.b	#1,d0
	or.b	d0,render_flags(a0)
	move.w	objoff_2E(a0),d0
	beq.s	loc_38198
	move.b	#4,mapping_frame(a0)
	addq.w	#6,x_pos(a0)
	addq.w	#6,y_pos(a0)

loc_38198:
	lsr.w	#1,d0
	move.b	byte_381A4(pc,d0.w),objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
byte_381A4:
	dc.b   0	; 0
	dc.b   3	; 1
	dc.b   5	; 2
	dc.b   7	; 3
	dc.b   9	; 4
	dc.b  $B	; 5
	dc.b  $D	; 6
	dc.b  $F	; 7
	even
; ===========================================================================

loc_381AC:
	movea.w	objoff_2C(a0),a1 ; a1=object
	cmpi.b	#ObjID_Shellcracker,id(a1)
	bne.s	loc_381D0
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_381C8(pc,d0.w),d1
	jsr	off_381C8(pc,d1.w)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
off_381C8:	offsetTable
		offsetTableEntry.w loc_381E0	; 0
		offsetTableEntry.w loc_3822A	; 2
		offsetTableEntry.w loc_38244	; 4
		offsetTableEntry.w loc_38258	; 6
; ===========================================================================

loc_381D0:
	move.b	#4,routine(a0)
	move.w	#$40,objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_381E0:
	subq.b	#1,objoff_2A(a0)
	beq.s	loc_381EA
	bmi.s	loc_381EA
	rts
; ===========================================================================

loc_381EA:
	addq.b	#2,routine_secondary(a0)
	move.w	objoff_2E(a0),d0
	cmpi.w	#$E,d0
	bhs.s	loc_3821A
	move.w	#-$400,d2
	btst	#0,render_flags(a0)
	beq.s	loc_38206
	neg.w	d2

loc_38206:
	move.w	d2,x_vel(a0)
	lsr.w	#1,d0
	move.b	byte_38222(pc,d0.w),d1
	move.b	d1,objoff_2A(a0)
	move.b	d1,objoff_2B(a0)
	rts
; ===========================================================================

loc_3821A:
	move.w	#$B,objoff_2A(a0)
	rts
; ===========================================================================
byte_38222:
	dc.b  $D	; 0
	dc.b  $C	; 1
	dc.b  $A	; 2
	dc.b   8	; 3
	dc.b   6	; 4
	dc.b   4	; 5
	dc.b   2	; 6
	dc.b   0	; 7
	even
; ===========================================================================

loc_3822A:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	subq.b	#1,objoff_2A(a0)
	beq.s	loc_38238
	bmi.s	loc_38238
	rts
; ===========================================================================

loc_38238:
	addq.b	#2,routine_secondary(a0)
	move.b	#8,objoff_2A(a0)
	rts
; ===========================================================================

loc_38244:
	subq.b	#1,objoff_2A(a0)
	beq.s	loc_3824E
	bmi.s	loc_3824E
	rts
; ===========================================================================

loc_3824E:
	addq.b	#2,routine_secondary(a0)
	neg.w	x_vel(a0)
	rts
; ===========================================================================

loc_38258:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	subq.b	#1,objoff_2B(a0)
	beq.s	loc_38266
	bmi.s	loc_38266
	rts
; ===========================================================================

loc_38266:
	tst.w	objoff_2E(a0)
	bne.s	loc_3827A
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.b	#0,mapping_frame(a1)
	st.b	objoff_2C(a1)

loc_3827A:
	addq.w	#4,sp
	bra.w	JmpTo65_DeleteObject
; ===========================================================================

loc_38280:
	jsrto	ObjectMoveAndFall, JmpTo8_ObjectMoveAndFall
	subi_.w	#1,objoff_2A(a0)
	bmi.w	JmpTo65_DeleteObject
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38292:
	moveq	#0,d1
	moveq	#7,d6

loc_38296:
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	return_382EE
	_move.b	#ObjID_ShellcrackerClaw,id(a1) ; load objA0
	move.b	#$26,subtype(a1) ; <== ObjA0_SubObjData
	move.b	#5,mapping_frame(a1)
	move.b	#4,priority(a1)
	move.w	a0,objoff_2C(a1)
	move.w	d1,objoff_2E(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	#-$14,d2
	btst	#0,render_flags(a0)
	beq.s	loc_382D8
	neg.w	d2
	tst.w	d1
	beq.s	loc_382D8
	subi.w	#$C,d2

loc_382D8:
	add.w	d2,x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	subi_.w	#8,y_pos(a1)
	addq.w	#2,d1
	dbf	d6,loc_38296

return_382EE:
	rts
; ===========================================================================
; off_382F0:
Obj9F_SubObjData:
	subObjData Obj9F_MapUnc_38314,make_art_tile(ArtTile_ArtNem_Shellcracker,0,0),4,5,$18,$A
; off_382FA:
ObjA0_SubObjData:
	subObjData Obj9F_MapUnc_38314,make_art_tile(ArtTile_ArtNem_Shellcracker,0,0),4,4,$C,$9A
; animation script
; off_38304:
Ani_obj9F:	offsetTable
		offsetTableEntry.w byte_38308	; 0
		offsetTableEntry.w byte_3830E	; 1
byte_38308:	dc.b  $E,  0,  1,  2,$FF,  0
byte_3830E:	dc.b  $E,  0,  2,  1,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj9F_MapUnc_38314:	include "mappings/sprite/objA0.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object A1 - Slicer (praying mantis dude) from MTZ
; ----------------------------------------------------------------------------
; Sprite_383B4:
ObjA1:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA1_Index(pc,d0.w),d1
	jmp	ObjA1_Index(pc,d1.w)
; ===========================================================================
; off_383C2:
ObjA1_Index:	offsetTable
		offsetTableEntry.w ObjA1_Init	; 0
		offsetTableEntry.w ObjA1_Main	; 2
		offsetTableEntry.w loc_38466	; 4
		offsetTableEntry.w loc_38482	; 6
		offsetTableEntry.w BranchTo5_JmpTo39_MarkObjGone	; 8
; ===========================================================================
; loc_383CC:
ObjA1_Init:
	bsr.w	LoadSubObject
	move.w	#-$40,d0
	btst	#0,render_flags(a0)
	beq.s	loc_383DE
	neg.w	d0

loc_383DE:
	move.w	d0,x_vel(a0)
	move.b	#$10,y_radius(a0)
	move.b	#$10,x_radius(a0)
	rts
; ===========================================================================

ObjA1_Main:
	tst.b	render_flags(a0)
	bpl.s	loc_3841C
	bsr.w	Obj_GetOrientationToPlayer
	btst	#0,render_flags(a0)
	beq.s	loc_38404
	subq.w	#2,d0

loc_38404:
	tst.w	d0
	bne.s	loc_3841C
	addi.w	#$80,d2
	cmpi.w	#$100,d2
	bhs.s	loc_3841C
	addi.w	#$40,d3
	cmpi.w	#$80,d3
	blo.s	loc_38452

loc_3841C:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jsr	(ObjCheckFloorDist).l
	cmpi.w	#-8,d1
	blt.s	loc_38444
	cmpi.w	#$C,d1
	bge.s	loc_38444
	add.w	d1,y_pos(a0)
	lea	(Ani_objA1).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38444:
	addq.b	#2,routine(a0)
	move.b	#$3B,objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38452:
	addq.b	#4,routine(a0)
	move.b	#3,mapping_frame(a0)
	move.b	#8,objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38466:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_38470
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38470:
	subq.b	#2,routine(a0)
	neg.w	x_vel(a0)
	bchg	#0,status(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38482:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_3848C
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3848C:
	addq.b	#2,routine(a0)
	move.b	#4,mapping_frame(a0)
	bsr.w	ObjA1_LoadPincers
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

BranchTo5_JmpTo39_MarkObjGone
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object A2 - Slicer's pincers from MTZ
; ----------------------------------------------------------------------------
; Sprite_384A2:
ObjA2:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA2_Index(pc,d0.w),d1
	jmp	ObjA2_Index(pc,d1.w)
; ===========================================================================
; off_384B0:
ObjA2_Index:	offsetTable
		offsetTableEntry.w ObjA2_Init	; 0
		offsetTableEntry.w ObjA2_Main	; 2
		offsetTableEntry.w ObjA2_Main2	; 4
; ===========================================================================
; loc_384B6:
ObjA2_Init:
	bsr.w	LoadSubObject
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

ObjA2_Main:
	tst.b	render_flags(a0)
	bpl.w	JmpTo65_DeleteObject
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3851A
	movea.w	objoff_2C(a0),a1 ; a1=object
	cmpi.b	#ObjID_Slicer,id(a1)
	bne.s	loc_3851A
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_384F6(pc,d0.w),d1
	jsr	off_384F6(pc,d1.w)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(Ani_objA2).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
off_384F6:	offsetTable
		offsetTableEntry.w +
; ===========================================================================
+
	bsr.w	Obj_GetOrientationToPlayer
	move.w	ObjA2_acceleration(pc,d0.w),d2
	add.w	d2,x_vel(a0)
	move.w	ObjA2_acceleration(pc,d1.w),d2
	add.w	d2,y_vel(a0)
	move.w	#$200,d0
	move.w	d0,d1
	bra.w	Obj_CapSpeed
; ===========================================================================
ObjA2_acceleration:	dc.w -$10, $10
; ===========================================================================

loc_3851A:
	addq.b	#2,routine(a0)
	move.w	#$60,objoff_2A(a0)

ObjA2_Main2:
	subq.w	#1,objoff_2A(a0)
	bmi.w	JmpTo65_DeleteObject
	jsrto	ObjectMoveAndFall, JmpTo8_ObjectMoveAndFall
	lea	(Ani_objA2).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

ObjA1_LoadPincers:
	lea	objoff_3C(a0),a2 ; a2=object
	moveq	#0,d1
	moveq	#1,d6

loc_38546:
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	return_385BA
	_move.b	#ObjID_SlicerPincers,id(a1) ; load objA2
	move.b	#$2A,subtype(a1) ; <== ObjA2_SubObjData
	move.b	render_flags(a0),render_flags(a1)
	move.b	#5,mapping_frame(a1)
	move.b	#4,priority(a1)
	move.w	#$78,objoff_2A(a1)
	move.w	a0,objoff_2C(a1)
	move.w	a1,(a2)+
	move.w	#-$200,d0
	btst	#0,render_flags(a1)
	beq.s	loc_3858A
	neg.w	d0
	bset	#0,status(a1)

loc_3858A:
	move.w	d0,x_vel(a1)
	lea	ObjA1_Pincer_Offsets(pc,d1.w),a3
	move.b	(a3)+,d0
	ext.w	d0
	btst	#0,render_flags(a1)
	beq.s	loc_385A0
	neg.w	d0

loc_385A0:
	add.w	x_pos(a0),d0
	move.w	d0,x_pos(a1)
	move.b	(a3)+,d0
	ext.w	d0
	add.w	y_pos(a0),d0
	move.w	d0,y_pos(a1)
	addq.w	#2,d1
	dbf	d6,loc_38546

return_385BA:
	rts
; ===========================================================================
ObjA1_Pincer_Offsets:
	dc.b    6,    0	; 0
	dc.b -$10,    0	; 3
; off_385C0
ObjA1_SubObjData:
	subObjData ObjA1_MapUnc_385E2,make_art_tile(ArtTile_ArtNem_MtzMantis,1,0),4,5,$10,6
; off_385CA:
ObjA2_SubObjData:
	subObjData ObjA1_MapUnc_385E2,make_art_tile(ArtTile_ArtNem_MtzMantis,1,0),4,4,$10,$9A
; animation script
; off_385D4:
Ani_objA1:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b $13,  0,  2,$FF
		even
; animation script
; off_385DA:
Ani_objA2:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3,  5,  6,  7,  8,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjA1_MapUnc_385E2:	include "mappings/sprite/objA2.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object A3 - Flasher (firefly/glowbug badnik) from MCZ
; ----------------------------------------------------------------------------
; Sprite_3873E:
ObjA3:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA3_Index(pc,d0.w),d1
	jmp	ObjA3_Index(pc,d1.w)
; ===========================================================================
; off_3874C:
ObjA3_Index:	offsetTable
		offsetTableEntry.w loc_3875A	;  0
		offsetTableEntry.w loc_38766	;  2
		offsetTableEntry.w loc_38794	;  4
		offsetTableEntry.w loc_38832	;  6
		offsetTableEntry.w loc_3885C	;  8
		offsetTableEntry.w loc_38880	; $A
		offsetTableEntry.w loc_3888E	; $C
; ===========================================================================

loc_3875A:
	bsr.w	LoadSubObject
	move.w	#$40,objoff_2A(a0)
	rts
; ===========================================================================

loc_38766:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_38770
	jmpto	MarkObjGone_P1, JmpTo2_MarkObjGone_P1
; ===========================================================================

loc_38770:
	addq.b	#2,routine(a0)
	move.w	#-$100,x_vel(a0)
	move.w	#$40,y_vel(a0)
	move.w	#2,objoff_2E(a0)
	clr.w	objoff_2A(a0)
	move.w	#$80,objoff_30(a0)
	jmpto	MarkObjGone_P1, JmpTo2_MarkObjGone_P1
; ===========================================================================

loc_38794:
	subq.w	#1,objoff_30(a0)
	bmi.s	loc_387FC
	move.w	objoff_2A(a0),d0
	bmi.w	JmpTo65_DeleteObject
	bclr	#0,render_flags(a0)
	bclr	#0,status(a0)
	tst.w	x_vel(a0)
	bmi.s	loc_387C0
	bset	#0,render_flags(a0)
	bset	#0,status(a0)

loc_387C0:
	addq.w	#1,d0
	move.w	d0,objoff_2A(a0)
	move.w	objoff_2C(a0),d1
	move.w	word_38810(pc,d1.w),d2
	cmp.w	d2,d0
	blo.s	loc_387EC
	addq.w	#2,d1
	move.w	d1,objoff_2C(a0)
	lea	byte_38820(pc,d1.w),a1
	tst.b	(a1)+
	beq.s	loc_387E4
	neg.w	objoff_2E(a0)

loc_387E4:
	tst.b	(a1)+
	beq.s	loc_387EC
	neg.w	y_vel(a0)

loc_387EC:
	move.w	objoff_2E(a0),d0
	add.w	d0,x_vel(a0)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jmpto	MarkObjGone_P1, JmpTo2_MarkObjGone_P1
; ===========================================================================

loc_387FC:
	addq.b	#2,routine(a0)
	move.w	#$80,objoff_30(a0)
	ori.b	#$80,collision_flags(a0)
	jmpto	MarkObjGone_P1, JmpTo2_MarkObjGone_P1
; ===========================================================================
word_38810:
	dc.w  $100
	dc.w  $1A0	; 1
	dc.w  $208	; 2
	dc.w  $285	; 3
	dc.w  $300	; 4
	dc.w  $340	; 5
	dc.w  $390	; 6
	dc.w  $440	; 7
byte_38820:
	dc.b $F0
	dc.b   0	; 1
	dc.b   1	; 2
	dc.b   1	; 3
	dc.b   0	; 4
	dc.b   1	; 5
	dc.b   1	; 6
	dc.b   1	; 7
	dc.b   0	; 8
	dc.b   1	; 9
	dc.b   0	; 10
	dc.b   1	; 11
	dc.b   1	; 12
	dc.b   0	; 13
	dc.b   0	; 14
	dc.b   1	; 15
	dc.b   0	; 16
	dc.b   1	; 17
	even
; ===========================================================================

loc_38832:
	move.b	routine(a0),d2
	lea	(Ani_objA3_a).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	cmp.b	routine(a0),d2
	bne.s	loc_3884A
	jmpto	MarkObjGone_P1, JmpTo2_MarkObjGone_P1
; ===========================================================================

loc_3884A:
	clr.l	mapping_frame(a0) ; Clear mapping_frame, anim_frame, anim, and prev_anim.
	clr.w	anim_frame_duration(a0)
	move.b	#3,mapping_frame(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3885C:
	subq.w	#1,objoff_30(a0)
	bmi.s	loc_38870
	lea	(Ani_objA3_b).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone_P1, JmpTo2_MarkObjGone_P1
; ===========================================================================

loc_38870:
	addq.b	#2,routine(a0)
	clr.l	mapping_frame(a0) ; Clear mapping_frame, anim_frame, anim, and prev_anim.
	clr.w	anim_frame_duration(a0)
	jmpto	MarkObjGone_P1, JmpTo2_MarkObjGone_P1
; ===========================================================================

loc_38880:
	lea	(Ani_objA3_c).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone_P1, JmpTo2_MarkObjGone_P1
; ===========================================================================

loc_3888E:
	move.b	#4,routine(a0)
	move.w	#$80,objoff_30(a0)
	andi.b	#$7F,collision_flags(a0)
	clr.l	mapping_frame(a0) ; Clear mapping_frame, anim_frame, anim, and prev_anim.
	clr.w	anim_frame_duration(a0)
	jmpto	MarkObjGone_P1, JmpTo2_MarkObjGone_P1
; ===========================================================================
; off_388AC:
ObjA3_SubObjData:
	subObjData ObjA3_MapUnc_388F0,make_art_tile(ArtTile_ArtNem_Flasher,0,1),4,4,$10,6

; animation script
; off_388B6:
Ani_objA3_a:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   0,  0,  1,  0,  0,  0,  0,  0,  1,  0,  0,  0,  1,  0,  0,  1
		dc.b   0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  2,  3,  4, $FC
		even
; animation script
; off_388DA:
Ani_objA3_b:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   0,  2,  0,  3,  0,  4,  0,  3,  0,$FF
		even
; animation script
; off_388E6:
Ani_objA3_c:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3,  4,  3,  2,  1,  0,$FC
		even
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
ObjA3_MapUnc_388F0:	include "mappings/sprite/objA3.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object A4 - Asteron (exploding starfish badnik) from MTZ
; ----------------------------------------------------------------------------
; Sprite_3899C:
ObjA4:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA4_Index(pc,d0.w),d1
	jmp	ObjA4_Index(pc,d1.w)
; ===========================================================================
; off_389AA:
ObjA4_Index:	offsetTable
		offsetTableEntry.w ObjA4_Init	; 0
		offsetTableEntry.w loc_389B6	; 2
		offsetTableEntry.w loc_389DA	; 4
		offsetTableEntry.w loc_38A2C	; 6
; ===========================================================================
; BranchTo3_LoadSubObject
ObjA4_Init:
	bra.w	LoadSubObject
; ===========================================================================

loc_389B6:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	bhs.s	BranchTo6_JmpTo39_MarkObjGone
	addi.w	#$40,d3
	cmpi.w	#$80,d3
	blo.s	loc_389D2

BranchTo6_JmpTo39_MarkObjGone
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_389D2:
	addq.b	#2,routine(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_389DA:
	bsr.w	Obj_GetOrientationToPlayer
	abs.w	d2
	cmpi.w	#$10,d2
	blo.s	loc_389FA
	cmpi.w	#$60,d2
	bhs.s	loc_389FA
	move.w	word_38A1A(pc,d0.w),x_vel(a0)
	bsr.w	loc_38A1E

loc_389FA:
	abs.w	d3
	cmpi.w	#$10,d3
	blo.s	BranchTo7_JmpTo39_MarkObjGone
	cmpi.w	#$60,d3
	bhs.s	BranchTo7_JmpTo39_MarkObjGone
	move.w	word_38A1A(pc,d1.w),y_vel(a0)
	bsr.w	loc_38A1E

BranchTo7_JmpTo39_MarkObjGone
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
word_38A1A:
	dc.w  -$40	; 0
	dc.w   $40	; 1
; ===========================================================================

loc_38A1E:
	move.b	#6,routine(a0)
	move.b	#$40,objoff_2A(a0)
	rts
; ===========================================================================

loc_38A2C:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_38A44
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(Ani_objA4).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38A44:
	_move.b	#ObjID_Explosion,id(a0) ; load 0bj27
	move.b	#2,routine(a0)
	bsr.w	loc_38A58
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38A58:
	move.b	#$30,d2
	moveq	#4,d6
	lea	(word_38A68).l,a2
	bra.w	Obj_CreateProjectiles
; ===========================================================================
word_38A68:
	dc.w $F8
	dc.w $FC
	dc.w $200
	dc.w $8FC
	dc.w $3FF
	dc.w $301
	dc.w $808
	dc.w $303
	dc.w $401
	dc.w $F808
	dc.w $FD03
	dc.w $400
	dc.w $F8FC
	dc.w $FDFF
	dc.w $300
; off_38A86:
ObjA4_SubObjData:
	subObjData ObjA4_Obj98_MapUnc_38A96,make_art_tile(ArtTile_ArtNem_MtzSupernova,0,1),4,4,$10,$B
; animation script
; off_38A90:
Ani_objA4:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjA4_Obj98_MapUnc_38A96:	include "mappings/sprite/objA4.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object A5 - Spiny (crawling badnik) from CPZ
; ----------------------------------------------------------------------------
; Sprite_38AEA:
ObjA5:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA5_Index(pc,d0.w),d1
	jmp	ObjA5_Index(pc,d1.w)
; ===========================================================================
; off_38AF8:
ObjA5_Index:	offsetTable
		offsetTableEntry.w ObjA5_Init	; 0
		offsetTableEntry.w loc_38B10	; 2
		offsetTableEntry.w loc_38B62	; 4
; ===========================================================================
; loc_38AFE:
ObjA5_Init:
	bsr.w	LoadSubObject
	move.w	#-$40,x_vel(a0)
	move.w	#$80,objoff_2A(a0)
	rts
; ===========================================================================

loc_38B10:
	tst.b	objoff_2B(a0)
	beq.s	loc_38B1E
	subq.b	#1,objoff_2B(a0)
	bra.w	loc_38B2C
; ===========================================================================

loc_38B1E:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	blo.s	loc_38B4E

loc_38B2C:
	subq.b	#1,objoff_2A(a0)
	bne.s	loc_38B3C
	move.w	#$80,objoff_2A(a0)
	neg.w	x_vel(a0)

loc_38B3C:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(Ani_objA5).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38B4E:
	addq.b	#2,routine(a0)
	move.b	#$28,objoff_2B(a0)
	move.b	#2,mapping_frame(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38B62:
	subq.b	#1,objoff_2B(a0)
	bmi.s	loc_38B78
	cmpi.b	#$14,objoff_2B(a0)
	bne.s	+
	bsr.w	loc_38C22
+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38B78:
	subq.b	#2,routine(a0)
	move.b	#$40,objoff_2B(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object A6 - Spiny (on wall) from CPZ
; ----------------------------------------------------------------------------
; Sprite_38B86:
ObjA6:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA6_Index(pc,d0.w),d1
	jmp	ObjA6_Index(pc,d1.w)
; ===========================================================================
; off_38B94:
ObjA6_Index:	offsetTable
		offsetTableEntry.w ObjA6_Init	; 0
		offsetTableEntry.w loc_38BAC	; 2
		offsetTableEntry.w loc_38BFE	; 4
; ===========================================================================
; loc_38B9A:
ObjA6_Init:
	bsr.w	LoadSubObject
	move.w	#-$40,y_vel(a0)
	move.w	#$80,objoff_2A(a0)
	rts
; ===========================================================================

loc_38BAC:
	tst.b	objoff_2B(a0)
	beq.s	loc_38BBA
	subq.b	#1,objoff_2B(a0)
	bra.w	loc_38BC8
; ===========================================================================

loc_38BBA:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	blo.s	loc_38BEA

loc_38BC8:
	subq.b	#1,objoff_2A(a0)
	bne.s	+
	move.w	#$80,objoff_2A(a0)
	neg.w	y_vel(a0)
+
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(Ani_objA6).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38BEA:
	addq.b	#2,routine(a0)
	move.b	#$28,objoff_2B(a0)
	move.b	#5,mapping_frame(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38BFE:
	subq.b	#1,objoff_2B(a0)
	bmi.s	loc_38C14
	cmpi.b	#$14,objoff_2B(a0)
	bne.s	+
	bsr.w	loc_38C6E
+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38C14:
	subq.b	#2,routine(a0)
	move.b	#$40,objoff_2B(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_38C22:
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	++	; rts
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#6,mapping_frame(a1)
	move.b	#$34,subtype(a1) ; <== ObjA6_SubObjData
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	#-$300,y_vel(a1)
	move.w	#$100,d1
	lea	(MainCharacter).w,a2 ; a2=character
	move.w	x_pos(a0),d0
	cmp.w	x_pos(a2),d0
	blo.s	+
	neg.w	d1
+
	move.w	d1,x_vel(a1)
	lea_	Obj98_SpinyShotFall,a2
	move.l	a2,objoff_2A(a1)
+
	rts
; ===========================================================================

loc_38C6E:
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	++	; rts
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#6,mapping_frame(a1)
	move.b	#$34,subtype(a1) ; <== ObjA6_SubObjData
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	#$300,d1
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d1
+
	move.w	d1,x_vel(a1)
	lea_	Obj98_SpinyShotFall,a2
	move.l	a2,objoff_2A(a1)
+
	rts
; ===========================================================================
; off_38CAE:
ObjA5_SubObjData:
	subObjData ObjA5_ObjA6_Obj98_MapUnc_38CCA,make_art_tile(ArtTile_ArtNem_Spiny,1,0),4,4,8,$B
; animation scripts
; off_38CB8
Ani_objA5:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   9,  0,  1,$FF
		even
; off_38CBE
Ani_objA6:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   9,  3,  4,$FF
		even
; off_38CC4
Ani_SpinyShot:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3,  6,  7,$FF
		even
; ------------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------------
ObjA5_ObjA6_Obj98_MapUnc_38CCA:	include "mappings/sprite/objA6.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object A7 - Grabber (spider badnik) from CPZ
; ----------------------------------------------------------------------------
; Sprite_38DBA:
ObjA7:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA7_Index(pc,d0.w),d1
	jmp	ObjA7_Index(pc,d1.w)
; ===========================================================================
; off_38DC8:
ObjA7_Index:	offsetTable
		offsetTableEntry.w ObjA7_Init	; 0
		offsetTableEntry.w ObjA7_Main	; 2
; ===========================================================================
; loc_38DCC:
ObjA7_Init:
	bsr.w	LoadSubObject
	move.w	#-$40,d0
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d0
+
	move.w	d0,x_vel(a0)
	move.w	#$FF,objoff_2A(a0)
	move.b	#2,objoff_2D(a0)
	lea	(ChildObject_391E0).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObject_391E4).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObject_391E8).l,a2
	bra.w	LoadChildObject
; ===========================================================================
; loc_38E0C:
ObjA7_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_38E46(pc,d0.w),d1
	jsr	off_38E46(pc,d1.w)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	moveq	#0,d0
	moveq	#$10,d1
	movea.w	objoff_3C(a0),a1 ; a1=object
	bsr.w	Obj_AlignChildXY
	movea.w	parent(a0),a1 ; a1=object
	move.w	x_pos(a0),x_pos(a1)
	movea.w	objoff_3A(a0),a1 ; a1=object
	move.w	x_pos(a0),x_pos(a1)
	lea	objoff_3A(a0),a2 ; a2=object
	bra.w	loc_39182
; ===========================================================================
off_38E46:	offsetTable
		offsetTableEntry.w loc_38E52	;  0
		offsetTableEntry.w loc_38E9A	;  2
		offsetTableEntry.w loc_38EB4	;  4
		offsetTableEntry.w loc_38F3E	;  6
		offsetTableEntry.w loc_38F58	;  8
		offsetTableEntry.w BranchTo_ObjA7_CheckExplode	; $A
; ===========================================================================

loc_38E52:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$40,d2
	cmpi.w	#$80,d2
	bhs.s	loc_38E66
	cmpi.w	#-$80,d3
	bhi.s	loc_38E84

loc_38E66:
	subq.w	#1,objoff_2A(a0)
	bpl.s	return_38E82
	move.w	#$FF,objoff_2A(a0)
	neg.w	x_vel(a0)
	bchg	#0,render_flags(a0)
	bchg	#0,status(a0)

return_38E82:
	rts
; ===========================================================================

loc_38E84:
	addq.b	#2,routine_secondary(a0)
	move.w	x_vel(a0),objoff_2E(a0)
	clr.w	x_vel(a0)
	move.b	#$10,objoff_2C(a0)
	rts
; ===========================================================================

loc_38E9A:
	subq.b	#1,objoff_2C(a0)
	bmi.s	loc_38EA2
	rts
; ===========================================================================

loc_38EA2:
	addq.b	#2,routine_secondary(a0)
	move.w	#$200,y_vel(a0)
	move.b	#$40,objoff_2C(a0)
	rts
; ===========================================================================

loc_38EB4:
	tst.b	objoff_30(a0)
	bne.s	ObjA7_GrabCharacter
	subq.b	#1,objoff_2C(a0)
	beq.s	loc_38ED6
	cmpi.b	#$20,objoff_2C(a0)
	bne.s	loc_38ECC
	neg.w	y_vel(a0)

loc_38ECC:
	lea	(Ani_objA7).l,a1
	jmpto	AnimateSprite, JmpTo25_AnimateSprite
; ===========================================================================

loc_38ED6:
	move.b	#0,routine_secondary(a0)
	clr.w	y_vel(a0)
	move.w	objoff_2E(a0),x_vel(a0)
	move.b	#0,mapping_frame(a0)
	rts
; ===========================================================================

;loc_38EEE:
ObjA7_GrabCharacter:
	addq.b	#2,routine_secondary(a0)
	movea.w	objoff_32(a0),a1
	move.b	#$81,obj_control(a1)
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	move.b	#AniIDSonAni_Float,anim(a1)
    if fixBugs
	; If the player gets grabbed while charging a Spin Dash, they won't
	; exist their Spin Dash state: the dust graphic will still appear,
	; just floating in the air, and when the player touches the ground,
	; they'll dash off. To fix this, just clear the player's Spin Dash
	; flag, like this:
	clr.b spindash_flag(a1)
    endif
	move.b	#1,mapping_frame(a0)
	tst.w	y_vel(a0)
	bmi.s	loc_38F2A
	neg.w	y_vel(a0)
	move.b	objoff_2C(a0),d0
	subi.b	#$40,d0
	neg.w	d0
	addq.b	#1,d0
	move.b	d0,objoff_2C(a0)

loc_38F2A:
	move.b	#1,objoff_2A(a0)
	move.b	#$10,objoff_2B(a0)
	move.b	#$20,objoff_37(a0)
	rts
; ===========================================================================

loc_38F3E:
	bsr.w	ObjA7_CheckExplode
	bsr.w	loc_390BC
	subq.b	#1,objoff_2C(a0)
	beq.s	loc_38F4E
	rts
; ===========================================================================

loc_38F4E:
	addq.b	#2,routine_secondary(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_38F58:
	bsr.w	ObjA7_CheckExplode
	bra.w	loc_390BC
; ===========================================================================
	rts
; ===========================================================================

BranchTo_ObjA7_CheckExplode ; BranchTo
	bra.w	ObjA7_CheckExplode
; ===========================================================================
; ----------------------------------------------------------------------------
; Object A8 - Grabber's legs from CPZ
; ----------------------------------------------------------------------------
; Sprite_38F66:
ObjA8:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA8_Index(pc,d0.w),d1
	jmp	ObjA8_Index(pc,d1.w)
; ===========================================================================
; off_38F74:
ObjA8_Index:	offsetTable
		offsetTableEntry.w ObjA8_Init	; 0
		offsetTableEntry.w loc_38F88	; 2
		offsetTableEntry.w loc_38FE8	; 4
		offsetTableEntry.w loc_39022	; 6
; ===========================================================================
; loc_38F7C:
ObjA8_Init:
	bsr.w	LoadSubObject
	move.b	#3,mapping_frame(a0)
	rts
; ===========================================================================

loc_38F88:
	movea.w	objoff_2C(a0),a1 ; a1=object
	cmpi.b	#ObjID_Grabber,id(a1)
	bne.w	JmpTo65_DeleteObject
	bsr.w	InheritParentXYFlip
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.b	mapping_frame(a1),d0
	addq.b	#3,d0
	move.b	d0,mapping_frame(a0)
	move.b	collision_property(a0),d0
	beq.s	BranchTo2_JmpTo45_DisplaySprite
	clr.b	collision_property(a0)
	cmpi.b	#4,routine_secondary(a1)
	bne.s	BranchTo2_JmpTo45_DisplaySprite
	andi.b	#3,d0
	beq.s	BranchTo2_JmpTo45_DisplaySprite
	clr.b	collision_flags(a0)
	addq.b	#2,routine(a0)
	add.w	d0,d0
	st.b	objoff_30(a1)
	move.w	word_38FE0-6(pc,d0.w),objoff_32(a1)
	move.w	word_38FE0(pc,d0.w),objoff_34(a1)

BranchTo2_JmpTo45_DisplaySprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
		dc.w MainCharacter	; -2
		dc.w Sidekick	; -1
word_38FE0:	dc.w MainCharacter	; 0
		dc.w Ctrl_1_Held	; 1
		dc.w Ctrl_2_Held	; 2
		dc.w Ctrl_1_Held	; 3
; ===========================================================================

loc_38FE8:
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.w	objoff_32(a1),d0
	beq.s	loc_3901A
	movea.w	d0,a2 ; a2=object
	cmpi.b	#ObjID_Grabber,id(a1)
	bne.s	loc_3900A
	move.w	x_pos(a0),x_pos(a2)
	move.w	y_pos(a0),y_pos(a2)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3900A:
	move.b	#0,obj_control(a2)
	bset	#1,status(a2)
	bra.w	JmpTo65_DeleteObject
; ===========================================================================

loc_3901A:
	addq.b	#2,routine(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_39022:
	movea.w	objoff_2C(a0),a1 ; a1=object
	cmpi.b	#ObjID_Grabber,id(a1) ; compare to objA7
	bne.w	JmpTo65_DeleteObject
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; ----------------------------------------------------------------------------
; Object A9 - The little hanger box thing a Grabber's string comes out of
; ----------------------------------------------------------------------------
; Sprite_39032:
ObjA9:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA9_Index(pc,d0.w),d1
	jmp	ObjA9_Index(pc,d1.w)
; ===========================================================================
; off_39040:
ObjA9_Index:	offsetTable
		offsetTableEntry.w ObjA9_Init	; 0
		offsetTableEntry.w ObjA9_Main	; 2
; ===========================================================================
; loc_39044:
ObjA9_Init:
	bsr.w	LoadSubObject
	move.b	#2,mapping_frame(a0)
	subi.w	#$C,y_pos(a0)
	rts
; ===========================================================================
; loc_39056:
ObjA9_Main:
	movea.w	objoff_2C(a0),a1 ; a1=object
	cmpi.b	#ObjID_Grabber,id(a1) ; compare to objA7 (grabber badnik)
	bne.w	JmpTo65_DeleteObject
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; ----------------------------------------------------------------------------
; Object AA - The thin white string a Grabber hangs from
; ----------------------------------------------------------------------------
; Sprite_39066:
ObjAA:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAA_Index(pc,d0.w),d1
	jmp	ObjAA_Index(pc,d1.w)
; ===========================================================================
; off_39074:
ObjAA_Index:	offsetTable
		offsetTableEntry.w ObjAA_Init	; 0
		offsetTableEntry.w ObjAA_Main	; 2
; ===========================================================================
; loc_39078:
ObjAA_Init:
	bsr.w	LoadSubObject
	subq.w	#8,y_pos(a0)
	rts
; ===========================================================================
; loc_39082:
ObjAA_Main:
	movea.w	objoff_2C(a0),a1 ; a1=object
	cmpi.b	#ObjID_Grabber,id(a1) ; compare to objA7 (grabber badnik)
	bne.w	JmpTo65_DeleteObject
	move.w	y_pos(a1),d0
	sub.w	y_pos(a0),d0
	bmi.s	+
	lsr.w	#4,d0
	move.b	d0,mapping_frame(a0)
+
	jmpto	DisplaySprite, JmpTo45_DisplaySprite

; ===========================================================================
; ----------------------------------------------------------------------------
; Object AB - Removed object (unknown, unused)
; ----------------------------------------------------------------------------
; Sprite_390A2:
ObjAB:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAB_Index(pc,d0.w),d1
	jmp	ObjAB_Index(pc,d1.w)
; ===========================================================================
; off_390B0:
ObjAB_Index:	offsetTable
		offsetTableEntry.w ObjAB_Init
		offsetTableEntry.w ObjAB_Main
; ===========================================================================
; BranchTo4_LoadSubObject
ObjAB_Init:
	bra.w	LoadSubObject
; ===========================================================================
; BranchTo10_JmpTo39_MarkObjGone
ObjAB_Main:
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; END OF OBJECT AB


; ---------------------------------------------------------------------------
; Some subroutine for the Grabber badnik
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

loc_390BC:
	movea.w	objoff_34(a0),a1 ; a1=object
	move.w	(a1),d0
	tst.b	objoff_31(a0)
	beq.s	loc_390E6
	subq.b	#1,objoff_37(a0)
	beq.s	loc_390FA
	move.b	objoff_36(a0),d1
	andi.b	#$C,d0
	beq.s	return_390E4
	cmp.b	d1,d0
	beq.s	return_390E4
	move.b	d0,objoff_36(a0)
	addq.b	#1,objoff_38(a0)

return_390E4:
	rts
; ---------------------------------------------------------------------------
loc_390E6:
	andi.b	#$C,d0
	beq.s	return_390E4
	nop
	st.b	objoff_31(a0)
	move.b	d0,objoff_36(a0)
	nop
	rts
; ---------------------------------------------------------------------------
loc_390FA:
	cmpi.b	#4,objoff_38(a0)
	blo.s	+
	move.b	#$A,routine_secondary(a0)
	clr.w	y_vel(a0)
	clr.b	collision_flags(a0)
	movea.w	objoff_32(a0),a2 ; a2=object
	move.b	#0,obj_control(a2)
	bset	#1,status(a2)
	move.b	#AniIDSonAni_Walk,anim(a2)
	clr.w	objoff_32(a0)
+
	move.b	#$20,objoff_37(a0)
	clr.b	objoff_31(a0)
	clr.b	objoff_38(a0)
	rts
; End of subroutine loc_390BC

; ---------------------------------------------------------------------------
; Grabber death check subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_3913A:
ObjA7_CheckExplode:
	subq.b	#1,objoff_2A(a0)
	bne.s	+
	move.b	objoff_2B(a0),objoff_2A(a0)
	subq.b	#1,objoff_2B(a0)
	beq.s	ObjA7_Poof
	bchg	#palette_bit_0,art_tile(a0)
+
	rts
; ---------------------------------------------------------------------------
; loc_39154:
ObjA7_Poof:
	_move.b	#ObjID_Explosion,id(a0) ; load 0bj27 (transform into explosion)
	move.b	#2,routine(a0)
	bset	#palette_bit_0,art_tile(a0)
	move.w	objoff_32(a0),d0
	beq.s	+
	movea.w	d0,a2 ; a2=object
	move.b	#0,objoff_2A(a2)
	bset	#1,status(a2)
	move.b	#$B,collision_flags(a0)
+
	rts
; End of subroutine ObjA7_CheckExplode
; ===========================================================================

; ---------------------------------------------------------------------------
; Yet another subroutine for the Grabber badnik
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

loc_39182:
	tst.w	(Two_player_mode).w
	beq.s	+
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
+	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	+
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
+	lea	(Object_Respawn_Table).w,a3
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a3,d0.w)
+
	tst.b	objoff_30(a0)
	beq.s	+
	movea.w	objoff_32(a0),a3
	move.b	#0,obj_control(a3)
	bset	#1,status(a3)
+
	moveq	#0,d6
	move.b	objoff_2D(a0),d6

-	movea.w	(a2)+,a1
	jsrto	DeleteObject2, JmpTo6_DeleteObject2
	dbf	d6,-

	bra.w	JmpTo65_DeleteObject
; End of subroutine loc_39182

; ===========================================================================
ChildObject_391E0:	childObjectData objoff_3E, ObjID_GrabberBox, $3A
ChildObject_391E4:	childObjectData objoff_3C, ObjID_GrabberLegs, $38
ChildObject_391E8:	childObjectData objoff_3A, ObjID_GrabberString, $3C
; off_391EC:
ObjA7_SubObjData:
	subObjData ObjA7_ObjA8_ObjA9_Obj98_MapUnc_3921A,make_art_tile(ArtTile_ArtNem_Grabber,1,1),4,4,$10,$B
; off_391F6:
ObjA7_SubObjData2:
	subObjData ObjA7_ObjA8_ObjA9_Obj98_MapUnc_3921A,make_art_tile(ArtTile_ArtNem_Grabber,1,1),4,1,$10,$D7
; off_39200:
ObjA8_SubObjData:
	subObjData ObjA7_ObjA8_ObjA9_Obj98_MapUnc_3921A,make_art_tile(ArtTile_ArtNem_Grabber,1,1),4,4,4,0
; off_3920A:
ObjA8_SubObjData2:
	subObjData ObjAA_MapUnc_39228,make_art_tile(ArtTile_ArtNem_Grabber,1,1),4,5,4,0
; animation script
; off_39214:
Ani_objA7:	offsetTable
		offsetTableEntry.w byte_39216	; 0
byte_39216:
	dc.b   7,  0,  1,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings - objA7,objA8,objA9
; ----------------------------------------------------------------------------
ObjA7_ObjA8_ObjA9_Obj98_MapUnc_3921A:	mappingsTable
	mappingsTableEntry.w	word_3923A
	mappingsTableEntry.w	word_39254
	mappingsTableEntry.w	word_3926E
	mappingsTableEntry.w	word_39278
	mappingsTableEntry.w	word_39282
	mappingsTableEntry.w	word_3928C
	mappingsTableEntry.w	word_39296
; -------------------------------------------------------------------------------
; sprite mappings - objAA (string of various lengths)
; -------------------------------------------------------------------------------
ObjAA_MapUnc_39228:	mappingsTable
	mappingsTableEntry.w	word_392A0	; 0
	mappingsTableEntry.w	word_392AA	; 1
	mappingsTableEntry.w	word_392B4	; 2
	mappingsTableEntry.w	word_392C6	; 3
	mappingsTableEntry.w	word_392D8	; 4
	; Unused - The spider badnik never goes down enough for these to appear
	mappingsTableEntry.w	word_3930C	; 5	; This is in the wrong place - this should be frame 6
	mappingsTableEntry.w	word_392F2	; 6	; This is in the wrong place - this should be frame 5
	mappingsTableEntry.w	word_3932E	; 7
	mappingsTableEntry.w	word_3932E	; 8	; This should point to word_39350

word_3923A:	spriteHeader
	spritePiece	-$1B, -8, 1, 2, 0, 0, 0, 0, 0
	spritePiece	-$13, -8, 4, 2, 2, 0, 0, 0, 0
	spritePiece	-$F, 8, 3, 2, $1D, 0, 0, 0, 0
word_3923A_End

word_39254:	spriteHeader
	spritePiece	-$1B, -8, 1, 2, 0, 0, 0, 0, 0
	spritePiece	-$13, -8, 4, 2, 2, 0, 0, 0, 0
	spritePiece	-$F, 8, 4, 2, $23, 0, 0, 0, 0
word_39254_End

word_3926E:	spriteHeader
	spritePiece	-4, -4, 1, 1, $A, 0, 0, 0, 0
word_3926E_End

word_39278:	spriteHeader
	spritePiece	-7, -8, 3, 2, $F, 0, 0, 0, 0
word_39278_End

word_39282:	spriteHeader
	spritePiece	-7, -8, 4, 2, $15, 0, 0, 0, 0
word_39282_End

word_3928C:	spriteHeader
	spritePiece	-4, -4, 1, 1, $2B, 0, 0, 0, 0
word_3928C_End

word_39296:	spriteHeader
	spritePiece	-4, -4, 1, 1, $2C, 0, 0, 0, 0
word_39296_End

word_392A0:	spriteHeader
	spritePiece	-4, 0, 1, 2, $B, 0, 0, 0, 0
word_392A0_End

word_392AA:	spriteHeader
	spritePiece	-4, 0, 1, 4, $B, 0, 0, 0, 0
word_392AA_End

word_392B4:	spriteHeader
	spritePiece	-4, 0, 1, 2, $B, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 4, $B, 0, 0, 0, 0
word_392B4_End

word_392C6:	spriteHeader
	spritePiece	-4, 0, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $20, 1, 4, $B, 0, 0, 0, 0
word_392C6_End

word_392D8:	spriteHeader
	spritePiece	-4, 0, 1, 2, $B, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $30, 1, 4, $B, 0, 0, 0, 0
word_392D8_End

word_392F2:	spriteHeader
	spritePiece	-4, 0, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $20, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $40, 1, 4, $B, 0, 0, 0, 0
word_392F2_End

word_3930C:	spriteHeader
	spritePiece	-4, 0, 1, 2, $B, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $30, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $50, 1, 4, $B, 0, 0, 0, 0
word_3930C_End

word_3932E:	spriteHeader
	spritePiece	-4, 0, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $20, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $40, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $60, 1, 4, $B, 0, 0, 0, 0
word_3932E_End

; Unused frame
word_39350:	spriteHeader
	spritePiece	-4, 0, 1, 2, $B, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $30, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $50, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $70, 1, 4, $B, 0, 0, 0, 0
word_39350_End

	even


; ===========================================================================
; ----------------------------------------------------------------------------
; Object AC - Balkiry (jet badnik) from SCZ
; ----------------------------------------------------------------------------
; Sprite_3937A:
ObjAC:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAC_Index(pc,d0.w),d1
	jmp	ObjAC_Index(pc,d1.w)
; ===========================================================================
; off_39388:
ObjAC_Index:	offsetTable
		offsetTableEntry.w ObjAC_Init	; 0
		offsetTableEntry.w ObjAC_Main	; 2
; ===========================================================================
; loc_3938C:
ObjAC_Init:
	bsr.w	LoadSubObject
	move.b	#1,mapping_frame(a0)
	move.w	#-$300,x_vel(a0)
	bclr	#1,render_flags(a0)
	beq.s	+
	move.w	#-$500,x_vel(a0)
+
	lea_	Ani_obj9C,a1
	move.l	a1,objoff_2E(a0)
	bra.w	loc_37ABE
; ===========================================================================
; loc_393B6:
ObjAC_Main:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	bsr.w	loc_36776
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================
; off_393C2:
ObjAC_SubObjData:
	subObjData ObjAC_MapUnc_393CC,make_art_tile(ArtTile_ArtNem_Balkrie,0,0),4,4,$20,8
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjAC_MapUnc_393CC:	include "mappings/sprite/objAC.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object AD - Clucker's base from WFZ
; ----------------------------------------------------------------------------
; Sprite_3941C:
ObjAD:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAD_Index(pc,d0.w),d1
	jmp	ObjAD_Index(pc,d1.w)
; ===========================================================================
; off_3942A:
ObjAD_Index:	offsetTable
		offsetTableEntry.w ObjAD_Init	; 0
		offsetTableEntry.w ObjAD_Main	; 2
; ===========================================================================
; loc_3942E:
ObjAD_Init:
	bsr.w	LoadSubObject
	move.b	#$C,mapping_frame(a0)
	rts
; ===========================================================================
; loc_3943A:
ObjAD_Main:
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	x_pos(a0),d4
	jsrto	SolidObject, JmpTo27_SolidObject
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object AE - Clucker (chicken badnik) from WFZ
; ----------------------------------------------------------------------------
; Sprite_39452:
ObjAE:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAE_Index(pc,d0.w),d1
	jmp	ObjAE_Index(pc,d1.w)
; ===========================================================================
; off_39460:
ObjAE_Index:	offsetTable
		offsetTableEntry.w ObjAE_Init	;  0
		offsetTableEntry.w loc_39488	;  2
		offsetTableEntry.w loc_394A2	;  4
		offsetTableEntry.w loc_394D2	;  6
		offsetTableEntry.w loc_394E0	;  8
		offsetTableEntry.w loc_39508	; $A
		offsetTableEntry.w loc_39516	; $C
; ===========================================================================
; loc_3946E:
ObjAE_Init:
	bsr.w	LoadSubObject
	move.b	#$15,mapping_frame(a0)
	btst	#0,render_flags(a0)
	beq.s	+
	bset	#0,status(a0)
+
	rts
; ===========================================================================

loc_39488:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$80,d2
	cmpi.w	#$100,d2
	blo.s	+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_394A2:
	move.b	routine(a0),d2
	lea	(Ani_objAE_a).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	cmp.b	routine(a0),d2
	bne.s	+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
+
	lea	mapping_frame(a0),a1
	clr.l	(a1) ; Clear mapping_frame, anim_frame, anim, and prev_anim.
	clr.w	anim_frame_duration-mapping_frame(a1)
	move.b	#8,(a1)
	move.b	#6,collision_flags(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_394D2:
	lea	(Ani_objAE_b).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_394E0:
	tst.b	objoff_2A(a0)
	beq.s	+
	subq.b	#1,objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	lea	mapping_frame(a0),a1
	clr.l	(a1) ; Clear mapping_frame, anim_frame, anim, and prev_anim.
	clr.w	anim_frame_duration-mapping_frame(a1)
	move.b	#$B,(a1)
	bsr.w	loc_39526
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_39508:
	lea	(Ani_objAE_c).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_39516:
	move.b	#8,routine(a0)
	move.b	#$40,objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_39526:
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	++	; rts
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#$D,mapping_frame(a1)
	move.b	#$46,subtype(a1) ; <==  ObjAD_SubObjData3
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$B,y_pos(a1)
	move.w	#-$200,d0
	move.w	#-8,d1
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d0
	neg.w	d1
+
	move.w	d0,x_vel(a1)
	add.w	d1,x_pos(a1)
	lea_	Obj98_CluckerShotMove,a2
	move.l	a2,objoff_2A(a1)
+
	rts
; ===========================================================================
ObjAD_SubObjData:
	subObjData ObjAD_Obj98_MapUnc_395B4,make_art_tile(ArtTile_ArtNem_WfzScratch,0,0),4,4,$18,0
ObjAD_SubObjData2:
	subObjData ObjAD_Obj98_MapUnc_395B4,make_art_tile(ArtTile_ArtNem_WfzScratch,0,0),4,5,$10,0

; animation script
; off_3958A
Ani_objAE_a:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,  3,  4,  5,  6,  7,$FC
		even

; animation script
; off_39596
Ani_objAE_b:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  8,  9, $A, $B, $B, $B, $B,$FC
		even

; animation script
; off_395A2
Ani_objAE_c:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3, $A, $B,$FC
		even

; animation script
; off_395A8
Ani_CluckerShot:offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3, $D, $E, $F,$10,$11,$12,$13,$14,$FF
		even

; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjAD_Obj98_MapUnc_395B4:	include "mappings/sprite/objAE.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object AF - Mecha Sonic / Silver Sonic from DEZ
; (also handles Eggman's remote-control window)
; ----------------------------------------------------------------------------
; Sprite_3972C:
ObjAF:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAF_Index(pc,d0.w),d1
	jmp	ObjAF_Index(pc,d1.w)
; ===========================================================================
; off_3973A:
ObjAF_Index:	offsetTable
		offsetTableEntry.w ObjAF_Init	;   0
		offsetTableEntry.w loc_397AC	;   2
		offsetTableEntry.w loc_397E6	;   4
		offsetTableEntry.w loc_397FE	;   6
		offsetTableEntry.w loc_3984A	;   8
		offsetTableEntry.w loc_398C0	;  $A
		offsetTableEntry.w loc_39B92	;  $C
		offsetTableEntry.w loc_39BBA	;  $E
		offsetTableEntry.w loc_39BCC	; $10
		offsetTableEntry.w loc_39BE2	; $12
		offsetTableEntry.w loc_39BEA	; $14
		offsetTableEntry.w loc_39C02	; $16
		offsetTableEntry.w loc_39C0A	; $18
		offsetTableEntry.w loc_39C12	; $1A
		offsetTableEntry.w loc_39C2A	; $1C
		offsetTableEntry.w loc_39C42	; $1E
		offsetTableEntry.w loc_39C50	; $20
		offsetTableEntry.w loc_39CA0	; $22
; ===========================================================================
; loc_3975E:
ObjAF_Init:
	bsr.w	LoadSubObject
	move.b	#$1B,y_radius(a0)
	move.b	#$10,x_radius(a0)
	move.b	#0,collision_flags(a0)
	move.b	#8,collision_property(a0)
	lea	(ChildObject_39DC2).l,a2
	bsr.w	LoadChildObject
	move.b	#$E,routine(a1)
	lea	(ChildObject_39DC6).l,a2
	bsr.w	LoadChildObject
	move.b	#$14,routine(a1)
	lea	(ChildObject_39DCA).l,a2
	bsr.w	LoadChildObject
	move.b	#$1A,routine(a1)
	rts
; ===========================================================================

loc_397AC:
	move.w	(Camera_X_pos).w,d0
	cmpi.w	#$224,d0
	bhs.s	loc_397BA
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_397BA:
	addq.b	#2,routine(a0)
	move.w	#60,objoff_2A(a0)
	move.w	#$100,y_vel(a0)
	move.w	#$224,d0
	move.w	d0,(Camera_Min_X_pos).w
	move.w	d0,(Camera_Max_X_pos).w
	move.b	#9,(Current_Boss_ID).w
	moveq	#signextendB(MusID_FadeOut),d0
	jsrto	PlaySound, JmpTo12_PlaySound
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_397E6:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_397F0
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_397F0:
	addq.b	#2,routine(a0)
	moveq	#signextendB(MusID_Boss),d0
	jsrto	PlayMusic, JmpTo5_PlayMusic
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_397FE:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	loc_3980E
	moveq	#signextendB(SndID_Fire),d0
	jsrto	PlaySound, JmpTo12_PlaySound

loc_3980E:
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bmi.s	loc_39830
	jsrto	ObjectMove, JmpTo26_ObjectMove
	moveq	#0,d0
	moveq	#0,d1
	movea.w	parent(a0),a1 ; a1=object
	bsr.w	Obj_AlignChildXY
	bsr.w	loc_39D4A
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_39830:
	add.w	d1,y_pos(a0)
	move.w	#0,y_vel(a0)
	move.b	#$1A,collision_flags(a0)
	bset	#1,status(a0)
	bra.w	loc_399D6
; ===========================================================================

loc_3984A:
	bsr.w	loc_39CAE
	bsr.w	loc_39D1C
	subq.b	#1,objoff_2A(a0)
	beq.s	loc_39886
	cmpi.b	#$32,objoff_2A(a0)
	bne.s	loc_3986A
	moveq	#signextendB(SndID_MechaSonicBuzz),d0
	jsrto	PlaySound, JmpTo12_PlaySound
	jsrto	DisplaySprite, JmpTo45_DisplaySprite

loc_3986A:
	jsr	(ObjCheckFloorDist).l
	add.w	d1,y_pos(a0)
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	bsr.w	loc_39D4A
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_39886:
	addq.b	#2,routine(a0)
	moveq	#0,d0
	move.b	objoff_2F(a0),d0
	andi.b	#$F,d0
	move.b	byte_398B0(pc,d0.w),routine_secondary(a0)
	addq.b	#1,objoff_2F(a0)
	clr.b	objoff_2E(a0)
	movea.w	objoff_3C(a0),a1 ; a1=object
	move.b	#$16,routine(a1)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
byte_398B0:
	dc.b   6
	dc.b   0	; 1
	dc.b $10	; 2
	dc.b   6	; 3
	dc.b   6	; 4
	dc.b $1E	; 5
	dc.b   0	; 6
	dc.b $10	; 7
	dc.b   6	; 8
	dc.b   6	; 9
	dc.b $10	; 10
	dc.b   6	; 11
	dc.b   0	; 12
	dc.b   6	; 13
	dc.b $10	; 14
	dc.b $1E	; 15
	even
; ===========================================================================

loc_398C0:
	bsr.w	loc_39CAE
	bsr.w	loc_39D1C
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_398F2(pc,d0.w),d1
	jsr	off_398F2(pc,d1.w)
	moveq	#0,d0
	moveq	#0,d1
	movea.w	parent(a0),a1 ; a1=object
	bsr.w	Obj_AlignChildXY
	bsr.w	loc_39D4A
	bsr.w	Obj_AlignChildXY
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
off_398F2:	offsetTable
		offsetTableEntry.w loc_3991E	;   0
		offsetTableEntry.w loc_39946	;   2
		offsetTableEntry.w loc_39976	;   4
		offsetTableEntry.w loc_39A0A	;   6
		offsetTableEntry.w loc_39A1C	;   8
		offsetTableEntry.w loc_39A44	;  $A
		offsetTableEntry.w loc_39A68	;  $C
		offsetTableEntry.w loc_39A96	;  $E
		offsetTableEntry.w loc_39A0A	; $10
		offsetTableEntry.w loc_39A1C	; $12
		offsetTableEntry.w loc_39AAA	; $14
		offsetTableEntry.w loc_39ACE	; $16
		offsetTableEntry.w loc_39AF4	; $18
		offsetTableEntry.w loc_39B28	; $1A
		offsetTableEntry.w loc_39A96	; $1C
		offsetTableEntry.w loc_39A0A	; $1E
		offsetTableEntry.w loc_39A1C	; $20
		offsetTableEntry.w loc_39AAA	; $22
		offsetTableEntry.w loc_39ACE	; $24
		offsetTableEntry.w loc_39B44	; $26
		offsetTableEntry.w loc_39B28	; $28
		offsetTableEntry.w loc_39A96	; $2A
; ===========================================================================

loc_3991E:
	addq.b	#2,routine_secondary(a0)
	move.b	#3,mapping_frame(a0)
	move.b	#2,objoff_2C(a0)

loc_3992E:
	move.b	#$20,objoff_2A(a0)
	movea.w	parent(a0),a1 ; a1=object
	move.b	#$10,routine(a1)
	move.b	#1,anim(a1)
	rts
; ===========================================================================

loc_39946:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_3994E
	rts
; ===========================================================================

loc_3994E:
	addq.b	#2,routine_secondary(a0)
	move.b	#$40,objoff_2A(a0)
	move.b	#1,anim(a0)
	move.w	#$800,d0
	bsr.w	loc_39D60
	movea.w	parent(a0),a1 ; a1=object
	move.b	#2,anim(a1)
	moveq	#signextendB(SndID_SpindashRelease),d0
	jmpto	PlaySound, JmpTo12_PlaySound
; ===========================================================================

loc_39976:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_399C2
	cmpi.b	#$20,objoff_2A(a0)
	bne.s	loc_39994
	move.b	#2,anim(a0)
	movea.w	parent(a0),a1 ; a1=object
	move.b	#$12,routine(a1)

loc_39994:
	bsr.w	loc_39D72
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	cmpi.b	#2,anim(a0)
	bne.s	return_399C0
	cmpi.b	#2,anim_frame(a0)
	bne.s	return_399C0
	cmpi.b	#3,anim_frame_duration(a0)
	bne.s	return_399C0
	bchg	#0,render_flags(a0)

return_399C0:
	rts
; ===========================================================================

loc_399C2:
	subq.b	#1,objoff_2C(a0)
	beq.s	loc_399D6
	move.b	#2,routine_secondary(a0)
	clr.w	x_vel(a0)
	bra.w	loc_3992E
; ===========================================================================

loc_399D6:
	move.b	#8,routine(a0)
	move.b	#0,anim(a0)
	move.b	#$64,objoff_2A(a0)
	clr.w	x_vel(a0)
	movea.w	parent(a0),a1 ; a1=object
	move.b	#$12,routine(a1)
	movea.w	objoff_3C(a0),a1 ; a1=object
	move.b	#$18,routine(a1)
	moveq	#signextendB(SndID_MechaSonicBuzz),d0
	jsrto	PlaySound, JmpTo12_PlaySound
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_39A0A:
	addq.b	#2,routine_secondary(a0)
	move.b	#3,mapping_frame(a0)
	move.b	#3,anim(a0)
	rts
; ===========================================================================

loc_39A1C:
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	bne.s	loc_39A2A
	rts
; ===========================================================================

loc_39A2A:
	addq.b	#2,routine_secondary(a0)
	move.b	#$20,objoff_2A(a0)
	move.b	#4,anim(a0)
	moveq	#signextendB(SndID_LaserBeam),d0
	jsrto	PlaySound, JmpTo12_PlaySound
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_39A44:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_39A56
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	rts
; ===========================================================================

loc_39A56:
	addq.b	#2,routine_secondary(a0)
	move.b	#$40,objoff_2A(a0)
	move.w	#$800,d0
	bra.w	loc_39D60
; ===========================================================================

loc_39A68:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_39A7C
	bsr.w	loc_39D72
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39A7C:
	addq.b	#2,routine_secondary(a0)
	move.b	#5,anim(a0)
	bchg	#0,render_flags(a0)
	clr.w	x_vel(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_39A96:
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	bne.w	BranchTo_loc_399D6
	rts
; ===========================================================================

BranchTo_loc_399D6 ; BranchTo
	bra.w	loc_399D6
; ===========================================================================

loc_39AAA:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_39ABC
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	rts
; ===========================================================================

loc_39ABC:
	addq.b	#2,routine_secondary(a0)
	move.b	#$40,objoff_2A(a0)
	move.w	#$400,d0
	bra.w	loc_39D60
; ===========================================================================

loc_39ACE:
	subq.b	#1,objoff_2A(a0)
	cmpi.b	#60,objoff_2A(a0)
	bne.s	loc_39ADE
	bsr.w	loc_39AE8

loc_39ADE:
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39AE8:
	addq.b	#2,routine_secondary(a0)
	move.w	#-$600,y_vel(a0)
	rts
; ===========================================================================

loc_39AF4:
	subq.b	#1,objoff_2A(a0)
	bmi.w	loc_39A7C
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	loc_39B0A
	bsr.w	loc_39B1A

loc_39B0A:
	addi.w	#$38,y_vel(a0)
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39B1A:
	addq.b	#2,routine_secondary(a0)
	add.w	d1,y_pos(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_39B28:
	subq.b	#1,objoff_2A(a0)
	bmi.w	loc_39A7C
	jsr	(ObjCheckFloorDist).l
	add.w	d1,y_pos(a0)
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39B44:
	subq.b	#1,objoff_2A(a0)
	bmi.w	loc_39A7C
	tst.b	objoff_2E(a0)
	bne.s	loc_39B66
	tst.w	y_vel(a0)
	bmi.s	loc_39B66
	st.b	objoff_2E(a0)
	bsr.w	loc_39D82
	moveq	#signextendB(SndID_SpikeSwitch),d0
	jsrto	PlaySound, JmpTo12_PlaySound

loc_39B66:
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	loc_39B74
	bsr.w	loc_39B84

loc_39B74:
	addi.w	#$38,y_vel(a0)
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39B84:
	addq.b	#2,routine_secondary(a0)
	add.w	d1,y_pos(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_39B92:
	clr.b	collision_flags(a0)
	subq.w	#1,objoff_32(a0)
	bmi.s	loc_39BA4
	jsrto	Boss_LoadExplosion, JmpTo_Boss_LoadExplosion
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_39BA4:
	move.w	#$1000,(Camera_Max_X_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w
    if fixBugs
	move.w	(Level_Music).w,d0
    else
	; 'Level_Music' is a word long, not a byte.
	; All this does is try to play Sound 0, which doesn't do anything.
	; This causes the Death Egg Music music to not resume after the
	; Silver Sonic fight.
	move.b	(Level_Music).w,d0
    endif
	jsrto	PlayMusic, JmpTo5_PlayMusic
	bra.w	JmpTo65_DeleteObject
; ===========================================================================

loc_39BBA:
	bsr.w	LoadSubObject
	move.b	#8,width_pixels(a0)
	move.b	#0,collision_flags(a0)
	rts
; ===========================================================================

loc_39BCC:
	movea.w	objoff_2C(a0),a1 ; a1=object
	bsr.w	InheritParentXYFlip
	lea	(off_39E30).l,a1
	bsr.w	AnimateSprite_Checked
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_39BE2:
	andi.b	#$7F,render_flags(a0)
	rts
; ===========================================================================

loc_39BEA:
	bsr.w	LoadSubObject
	move.b	#8,width_pixels(a0)
	move.b	#$B,mapping_frame(a0)
	move.b	#3,priority(a0)
	rts
; ===========================================================================

loc_39C02:
	move.b	#0,collision_flags(a0)
	rts
; ===========================================================================

loc_39C0A:
	move.b	#$98,collision_flags(a0)
	rts
; ===========================================================================

loc_39C12:
	bsr.w	LoadSubObject
	move.b	#4,mapping_frame(a0)
	move.w	#$2C0,x_pos(a0)
	move.w	#$139,y_pos(a0)
	rts
; ===========================================================================

loc_39C2A:
	movea.w	objoff_2C(a0),a1 ; a1=object
	bclr	#1,status(a1)
	bne.s	loc_39C3A
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_39C3A:
	addq.b	#2,routine(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_39C42:
	lea	(Ani_objAF_c).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_39C50:
	movea.w	objoff_2C(a0),a1 ; a1=object
	lea	(MainCharacter).w,a2 ; a2=character
	btst	#2,status(a1)
	bne.s	loc_39C92
	move.b	#2,anim(a0)
	cmpi.b	#4,routine(a2)
	bne.s	loc_39C78
	move.b	#3,anim(a0)
	bra.w	loc_39C84
; ===========================================================================

loc_39C78:
	tst.b	collision_flags(a1)
	bne.s	loc_39C84
	move.b	#4,anim(a0)

loc_39C84:
	lea	(Ani_objAF_c).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_39C92:
	addq.b	#2,routine(a0)
	move.b	#1,anim(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_39CA0:
	lea	(Ani_objAF_c).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_39CAE:
	tst.b	collision_property(a0)
	beq.s	loc_39CF0
	tst.b	collision_flags(a0)
	bne.s	return_39CEE
	tst.b	objoff_30(a0)
	bne.s	loc_39CD0
	move.b	#$20,objoff_30(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l

loc_39CD0:
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	loc_39CDE
	move.w	#$EEE,d0

loc_39CDE:
	move.w	d0,(a1)
	subq.b	#1,objoff_30(a0)
	bne.s	return_39CEE
	clr.w	(Normal_palette_line2+2).w
	bsr.w	loc_39D24

return_39CEE:
	rts
; ===========================================================================

loc_39CF0:
	moveq	#100,d0
	bsr.w	AddPoints
	move.w	#$FF,objoff_32(a0)
	move.b	#$C,routine(a0)
	clr.b	collision_flags(a0)
	bset	#2,status(a0)
	movea.w	objoff_3C(a0),a1 ; a1=object
	jsrto	DeleteObject2, JmpTo6_DeleteObject2
	movea.w	parent(a0),a1 ; a1=object
	jmpto	DeleteObject2, JmpTo6_DeleteObject2
; ===========================================================================

loc_39D1C:
	tst.b	collision_flags(a0)
	beq.w	return_37A48

loc_39D24:
	move.b	mapping_frame(a0),d0
	cmpi.b	#6,d0
	beq.s	loc_39D42
	cmpi.b	#7,d0
	beq.s	loc_39D42
	cmpi.b	#8,d0
	beq.s	loc_39D42
	move.b	#$1A,collision_flags(a0)
	rts
; ===========================================================================

loc_39D42:
	move.b	#$9A,collision_flags(a0)
	rts
; ===========================================================================

loc_39D4A:
	moveq	#$C,d0
	moveq	#-$C,d1
	btst	#0,render_flags(a0)
	beq.s	loc_39D58
	neg.w	d0

loc_39D58:
	movea.w	objoff_3C(a0),a1 ; a1=object
	bra.w	Obj_AlignChildXY
; ===========================================================================

loc_39D60:
	tst.b	objoff_2D(a0)
	bne.s	loc_39D68
	neg.w	d0

loc_39D68:
	not.b	objoff_2D(a0)
	move.w	d0,x_vel(a0)
	rts
; ===========================================================================

loc_39D72:
	moveq	#$20,d0
	tst.w	x_vel(a0)
	bmi.s	loc_39D7C
	neg.w	d0

loc_39D7C:
	add.w	d0,x_vel(a0)
	rts
; ===========================================================================

loc_39D82:
	move.b	#$4A,d2
	moveq	#7,d6
	lea	(byte_39D92).l,a2
	bra.w	Obj_CreateProjectiles
; ===========================================================================
byte_39D92:
	dc.b   0,$E8,  0,$FD, $F,  0,$F0,$F0,$FE,$FE,$10,  0,$E8,  0,$FD,  0
	dc.b $11,  0,$F0,$10,$FE,  2,$12,  0,  0,$18,  0,  3,$13,  0,$10,$10; 16
	dc.b   2,  2,$14,  0,$18,  0,  3,  0,$15,  0,$10,$F0,  2,$FE,$16,  0; 32
	even
ChildObject_39DC2:	childObjectData objoff_3E, ObjID_MechaSonic, $48
ChildObject_39DC6:	childObjectData objoff_3C, ObjID_MechaSonic, $48
ChildObject_39DCA:	childObjectData objoff_3A, ObjID_MechaSonic, $A4
; off_39DCE:
ObjAF_SubObjData2:
	subObjData ObjAF_Obj98_MapUnc_39E68,make_art_tile(ArtTile_ArtNem_SilverSonic,1,0),4,4,$10,$1A
; off_39DD8:
ObjAF_SubObjData3:
	subObjData ObjAF_MapUnc_3A08C,make_art_tile(ArtTile_ArtNem_DEZWindow,0,0),4,6,$10,0

; animation script
off_39DE2:	offsetTable
		offsetTableEntry.w byte_39DEE	; 0
		offsetTableEntry.w byte_39DF4	; 1
		offsetTableEntry.w byte_39DF8	; 2
		offsetTableEntry.w byte_39DFE	; 3
		offsetTableEntry.w byte_39E14	; 4
		offsetTableEntry.w byte_39E1A	; 5
byte_39DEE:
	dc.b   2,  0,  1,  2,$FF,  0
byte_39DF4:
	dc.b $45,  3,$FD,  0
byte_39DF8:
	dc.b   3,  4,  5,  4,  3,$FC
byte_39DFE:
	dc.b   3,  3,  3,  6,  6,  6,  7,  7,  7,  8,  8,  8,  6,  6,  7,  7
	dc.b   8,  8,  6,  7,  8,$FC; 16
byte_39E14:
	dc.b   2,  6,  7,  8,$FF,  0
byte_39E1A:
	dc.b   3,  8,  7,  6,  8,  8,  7,  7,  6,  6,  8,  8,  8,  7,  7,  7
	dc.b   6,  6,  6,  3,  3,$FC; 16
	even

; animation script
off_39E30:	offsetTable
		offsetTableEntry.w byte_39E36	; 0
		offsetTableEntry.w byte_39E3A	; 1
		offsetTableEntry.w byte_39E3E	; 2
byte_39E36:
	dc.b   1, $B, $C,$FF
byte_39E3A:
	dc.b   1, $D, $E,$FF
byte_39E3E:
	dc.b   1,  9, $A,$FF
	even

; animation script
; off_39E42:
Ani_objAF_c:	offsetTable
		offsetTableEntry.w byte_39E4C	; 0
		offsetTableEntry.w byte_39E54	; 1
		offsetTableEntry.w byte_39E5C	; 2
		offsetTableEntry.w byte_39E60	; 3
		offsetTableEntry.w byte_39E64	; 4
byte_39E4C:	dc.b   3,  4,  3,  2,  1,  0,$FC,  0
byte_39E54:	dc.b   3,  0,  1,  2,  3,  4,$FA,  0
byte_39E5C:	dc.b   3,  5,  5,$FF
byte_39E60:	dc.b   3,  5,  6,$FF
byte_39E64:	dc.b   3,  7,  7,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjAF_Obj98_MapUnc_39E68:	include "mappings/sprite/objAF_a.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjAF_MapUnc_3A08C:	include "mappings/sprite/objAF_b.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object B0 - Sonic on the Sega screen
; ----------------------------------------------------------------------------
; Sprite_3A1DC:
ObjB0:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB0_Index(pc,d0.w),d1
	jmp	ObjB0_Index(pc,d1.w)
; ===========================================================================
; off_3A1EA:
ObjB0_Index:	offsetTable
		offsetTableEntry.w ObjB0_Init		;  0
		offsetTableEntry.w ObjB0_RunLeft	;  2
		offsetTableEntry.w ObjB0_MidWipe	;  4
		offsetTableEntry.w ObjB0_RunRight	;  6
		offsetTableEntry.w ObjB0_EndWipe	;  8
		offsetTableEntry.w return_3A3F6		; $A
; ===========================================================================

ObjB0_Init:
	bsr.w	LoadSubObject
	move.w	#$1E8,x_pixel(a0)
	move.w	#$F0,y_pixel(a0)
	move.w	#$B,objoff_2A(a0)
	move.w	#2,(SegaScr_VInt_Subrout).w
	bset	#0,render_flags(a0)
	bset	#0,status(a0)

	; Initialize streak horizontal offsets for Sonic going left.
	; 9 full lines (8 pixels) + 6 pixels, 2-byte interleaved entries for PNT A and PNT B
	lea	(Horiz_Scroll_Buf + 2 * 2 * (9 * 8 + 6)).w,a1
	lea	Streak_Horizontal_offsets(pc),a2
	moveq	#0,d0
	moveq	#35-1,d6	; Number of streaks-1
-	move.b	(a2)+,d0
	add.w	d0,(a1)
	addq.w	#2 * 2 * 2,a1	; Advance to next streak 2 pixels down
	dbf	d6,-

	lea	off_3A294(pc),a1 ; pointers to mapping DPLC data
	lea	(ArtUnc_Sonic).l,a3
	lea	(Chunk_Table).l,a5
	moveq	#4-1,d5 ; there are 4 mapping frames to loop over

	; this copies the tiles that we want to scale up from ROM to RAM
;loc_3A246:
;CopySpriteTilesToRAMForSegaScreen:
-	movea.l	(a1)+,a2
	move.w	(a2)+,d6 ; get the number of pieces in this mapping frame
	subq.w	#1,d6
-	move.w	(a2)+,d0
	move.w	d0,d1
	; Depending on the exact location (and size) of the art being used,
	; you may encounter an overflow in the original code which garbles
	; the enlarged Sonic. The following code fixes this:
    if fixBugs
	andi.l	#$FFF,d0
	lsl.l	#5,d0
	lea	(a3,d0.l),a4 ; source ROM address of tiles to copy
    else
	andi.w	#$FFF,d0
	lsl.w	#5,d0
	lea	(a3,d0.w),a4 ; source ROM address of tiles to copy
    endif
	andi.w	#$F000,d1 ; abcd000000000000
	rol.w	#4,d1	  ; (this calculation can be done smaller and faster
	addq.w	#1,d1	  ; by doing rol.w #7,d1 addq.w #7,d1
	lsl.w	#3,d1	  ; instead of these 4 lines)
	subq.w	#1,d1	  ; 000000000abcd111 ; number of dwords to copy minus 1
-	move.l	(a4)+,(a5)+
	dbf	d1,- ; copy all of the pixels in this piece into the temp buffer
	dbf	d6,-- ; loop per piece in the frame
	dbf	d5,--- ; loop per mapping frame

	; this scales up the tiles by 2
;ScaleUpSpriteTiles:
	move.w	d7,-(sp)
	moveq	#0,d0
	moveq	#0,d1
	lea	SonicRunningSpriteScaleData(pc),a6
	moveq	#4*2-1,d7 ; there are 4 sprite mapping frames with 2 pieces each
-	movea.l	(a6)+,a1 ; source in RAM of tile graphics to enlarge
	movea.l	(a6)+,a2 ; destination in RAM of enlarged graphics
	move.b	(a6)+,d0 ; width of the sprite piece to enlarge (minus 1)
	move.b	(a6)+,d1 ; height of the sprite piece to enlarge (minus 1)
	bsr.w	Scale_2x
	dbf	d7,- ; loop over each piece
	move.w	(sp)+,d7

	rts
; ===========================================================================
off_3A294:
	dc.l MapRUnc_Sonic.frame45
	dc.l MapRUnc_Sonic.frame46
	dc.l MapRUnc_Sonic.frame47
	dc.l MapRUnc_Sonic.frame48

map_piece macro width,height
	dc.l copysrc,copydst
	dc.b width-1,height-1
copysrc := copysrc + tiles_to_bytes(width * height)
copydst := copydst + tiles_to_bytes(width * height) * 2 * 2
    endm
;word_3A2A4:
SonicRunningSpriteScaleData:
copysrc := Chunk_Table
copydst := Chunk_Table + $B00
SegaScreenScaledSpriteDataStart = copydst
	rept 4 ; repeat 4 times since there are 4 frames to scale up
	; piece 1 of each frame (the smaller top piece):
	map_piece 3,2
	; piece 2 of each frame (the larger bottom piece):
	map_piece 4,4
	endm
SegaScreenScaledSpriteDataEnd = copydst
	if copysrc > SegaScreenScaledSpriteDataStart
	fatal "Scale copy source overran allocated size. Try changing the initial value of copydst to Chunk_Table+$\{copysrc-Chunk_Table}"
	endif
; ===========================================================================

ObjB0_RunLeft:
	subi.w	#$20,x_pos(a0)
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3A312
	bsr.w	ObjB0_Move_Streaks_Left
	lea	(Ani_objB0).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3A312:
	addq.b	#2,routine(a0)
	move.w	#$C,objoff_2A(a0)
	move.b	#1,objoff_2C(a0)
	move.b	#-1,objoff_2D(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjB0_MidWipe:
	tst.w	objoff_2A(a0)
	beq.s	loc_3A33A
	subq.w	#1,objoff_2A(a0)
	bsr.w	ObjB0_Move_Streaks_Left

loc_3A33A:
	lea	word_3A49E(pc),a1
	bsr.w	loc_3A44E
	bne.s	loc_3A346
	rts
; ===========================================================================

loc_3A346:
	addq.b	#2,routine(a0)
	bchg	#0,render_flags(a0)
	move.w	#$B,objoff_2A(a0)
	move.w	#4,(SegaScr_VInt_Subrout).w
	subi.w	#$28,x_pos(a0)
	bchg	#0,render_flags(a0)
	bchg	#0,status(a0)

    if fixBugs
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len
    else
	; This clears a lot more than the horizontal scroll buffer, which is $400 bytes.
	; This is because the loop counter is erroneously set to $400, instead of ($400/4)-1.
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+(HorizontalScrollBuffer.len*4+4)
    endif

	; Initialize streak horizontal offsets for Sonic going right.
	; 9 full lines (8 pixels) + 7 pixels, 2-byte interleaved entries for PNT A and PNT B
	lea	(Horiz_Scroll_Buf + 2 * 2 * (9 * 8 + 7)).w,a1
	lea	Streak_Horizontal_offsets(pc),a2
	moveq	#0,d0
	moveq	#35-1,d6	; Number of streaks-1

loc_3A38A:
	move.b	(a2)+,d0
	sub.w	d0,(a1)
	addq.w	#2 * 2 * 2,a1	; Advance to next streak 2 pixels down
	dbf	d6,loc_3A38A
	rts
; ===========================================================================

ObjB0_RunRight:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3A3B4
	addi.w	#$20,x_pos(a0)
	bsr.w	ObjB0_Move_Streaks_Right
	lea	(Ani_objB0).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3A3B4:
	addq.b	#2,routine(a0)
	move.w	#$C,objoff_2A(a0)
	move.b	#1,objoff_2C(a0)
	move.b	#-1,objoff_2D(a0)
	rts
; ===========================================================================

ObjB0_EndWipe:
	tst.w	objoff_2A(a0)
	beq.s	loc_3A3DA
	subq.w	#1,objoff_2A(a0)
	bsr.w	ObjB0_Move_Streaks_Right

loc_3A3DA:
	lea	word_3A514(pc),a1
	bsr.w	loc_3A44E
	bne.s	loc_3A3E6
	rts
; ===========================================================================

loc_3A3E6:
	addq.b	#2,routine(a0)
	st.b	(SegaScr_PalDone_Flag).w
	move.b	#SndID_SegaSound,d0
	jsrto	PlaySound, JmpTo12_PlaySound

return_3A3F6:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B1 - Object that hides TM symbol on JP region
; ----------------------------------------------------------------------------
; Sprite_3A3F8:
ObjB1:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB1_Index(pc,d0.w),d1
	jmp	ObjB1_Index(pc,d1.w)
; ===========================================================================
; off_3A406:
ObjB1_Index:	offsetTable
		offsetTableEntry.w ObjB1_Init	; 0
		offsetTableEntry.w ObjB1_Main	; 2
; ===========================================================================
; loc_3A40A:
ObjB1_Init:
	bsr.w	LoadSubObject
	move.b	#4,mapping_frame(a0)
	move.w	#$174,x_pixel(a0)
	move.w	#$D8,y_pixel(a0)
	rts
; ===========================================================================
; BranchTo4_JmpTo45_DisplaySprite
ObjB1_Main:
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjB0_Move_Streaks_Left:
	; 9 full lines (8 pixels) + 6 pixels, 2-byte interleaved entries for PNT A and PNT B
	lea	(Horiz_Scroll_Buf + 2 * 2 * (9 * 8 + 6)).w,a1

	move.w	#35-1,d6	; Number of streaks-1
-	subi.w	#$20,(a1)
	addq.w	#2 * 2 * 2,a1	; Advance to next streak 2 pixels down
	dbf	d6,-
	rts
; ===========================================================================

ObjB0_Move_Streaks_Right:
	; 9 full lines (8 pixels) + 7 pixels, 2-byte interleaved entries for PNT A and PNT B
	lea	(Horiz_Scroll_Buf + 2 * 2 * (9 * 8 + 7)).w,a1

	move.w	#35-1,d6	; Number of streaks-1
-	addi.w	#$20,(a1)
	addq.w	#2 * 2 * 2,a1	; Advance to next streak 2 pixels down
	dbf	d6,-
	rts
; ===========================================================================

loc_3A44E:
	subq.b	#1,objoff_2C(a0)
	bne.s	loc_3A496
	moveq	#0,d0
	move.b	objoff_2D(a0),d0
	addq.b	#1,d0
	cmp.b	1(a1),d0
	blo.s	loc_3A468
	tst.b	3(a1)
	bne.s	loc_3A49A

loc_3A468:
	move.b	d0,objoff_2D(a0)
	_move.b	0(a1),objoff_2C(a0)
	lea	6(a1),a2		; This loads a palette: Sega Screen 2.bin or Sega Screen 3.bin
	moveq	#0,d1
	move.b	2(a1),d1
	move.w	d1,d2
	tst.w	d0
	beq.s	loc_3A48C

loc_3A482:
	subq.b	#1,d0
	beq.s	loc_3A48A
	add.w	d2,d1
	bra.s	loc_3A482
; ===========================================================================

loc_3A48A:
	adda.w	d1,a2

loc_3A48C:
	movea.w	4(a1),a3

loc_3A490:
	move.w	(a2)+,(a3)+
	subq.w	#2,d2
	bne.s	loc_3A490

loc_3A496:
	moveq	#0,d0
	rts
; ===========================================================================

loc_3A49A:
	moveq	#1,d0
	rts
; ===========================================================================

; probably some sort of description of how to use the following palette
word_3A49E:
	dc.b   4	; 0	; How many frames before each iteration
	dc.b   7	; 1	; How many iterations
	dc.b $10	; 2	; Number of colors * 2 to skip each iteration
	dc.b $FF	; 3	; Some sort of flag
	dc.w Normal_palette+$10	; 4	; First target palette entry

; Palette for the SEGA screen (background and pre-wipe foreground) (7 frames)
;pal_3A4A4:
	BINCLUDE	"art/palettes/Sega Screen 2.bin"


; probably some sort of description of how to use the following palette
word_3A514:
	dc.b   4	; 0	; How many frames before each iteration
	dc.b   7	; 1	; How many iterations
	dc.b $10	; 2	; Number of colors * 2 to skip each iteration
	dc.b $FF	; 3	; Some sort of flag
	dc.w Normal_palette	; 4	; First target palette entry

; Palette for the SEGA screen (wiping and post-wipe foreground) (7 frames)
;pal_3A51A:
	BINCLUDE	"art/palettes/Sega Screen 3.bin"

; off_3A58A:
ObjB0_SubObjData:
	subObjData ObjB1_MapUnc_3A5A6,make_art_tile(ArtTile_ArtUnc_Giant_Sonic,2,1),0,1,$10,0

; off_3A594:
ObjB1_SubObjData:
	subObjData ObjB1_MapUnc_3A5A6,make_art_tile(ArtTile_ArtNem_Sega_Logo+2,0,0),0,2,8,0

; animation script
; off_3A59E:
Ani_objB0:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   0,  0,  1,  2,  3,$FF
		even

; ------------------------------------------------------------------------------
; sprite mappings
; Gigantic Sonic (2x size) mappings for the SEGA screen
; also has the "trademark hider" mappings
; ------------------------------------------------------------------------------
ObjB1_MapUnc_3A5A6:	include "mappings/sprite/objB1.asm"
; ===========================================================================
;loc_3A68A
SegaScr_VInt:
	move.w	(SegaScr_VInt_Subrout).w,d0
	beq.w	return_37A48
	clr.w	(SegaScr_VInt_Subrout).w
	move.w	off_3A69E-2(pc,d0.w),d0
	jmp	off_3A69E(pc,d0.w)
; ===========================================================================
off_3A69E:	offsetTable
		offsetTableEntry.w loc_3A6A2	; 0
		offsetTableEntry.w loc_3A6D4	; 2
; ===========================================================================

loc_3A6A2:
	dma68kToVDP SegaScreenScaledSpriteDataStart,tiles_to_bytes(ArtTile_ArtUnc_Giant_Sonic),\
	            SegaScreenScaledSpriteDataEnd-SegaScreenScaledSpriteDataStart,VRAM

	lea	ObjB1_Streak_fade_to_right(pc),a1
	; 9 full lines ($100 bytes each) plus $28 8-pixel cells
	move.l	#vdpComm(VRAM_SegaScr_Plane_A_Name_Table + planeLocH80($28,9),VRAM,WRITE),d0	; $49500003
	bra.w	loc_3A710
; ===========================================================================

loc_3A6D4:
	dmaFillVRAM 0,VRAM_SegaScr_Plane_A_Name_Table,VRAM_SegaScr_Plane_Table_Size ; clear Plane A pattern name table

	lea	ObjB1_Streak_fade_to_left(pc),a1
	; $49A00003; 9 full lines ($100 bytes each) plus $50 8-pixel cells
	move.l	#vdpComm(VRAM_SegaScr_Plane_A_Name_Table + planeLocH80($50,9),VRAM,WRITE),d0
	bra.w	loc_3A710
loc_3A710:
	lea	(VDP_data_port).l,a6
	; This is the line delta; for each line, the code below
	; writes $30 entries, leaving $50 untouched.
	move.l	#vdpCommDelta(planeLocH80(0,1)),d6	; $1000000
	moveq	#7,d1	; Inner loop: repeat 8 times
	moveq	#9,d2	; Outer loop: repeat $A times
-
	move.l	d0,4(a6)	; Send command to VDP: set address to write to
	move.w	d1,d3		; Reset inner loop counter
	movea.l	a1,a2		; Reset data pointer
-
	move.w	(a2)+,d4	; Read one pattern name table entry
	bclr	#$A,d4		; Test bit $A and clear (flag for end of line)
	beq.s	+			; Branch if bit was clear
	bsr.w	loc_3A742	; Fill rest of line with this set of pixels
+
	move.w	d4,(a6)		; Write PNT entry
	dbf	d3,-
	add.l	d6,d0		; Point to the next VRAM area to be written to
	dbf	d2,--
	rts
; ===========================================================================

loc_3A742:
	moveq	#$28,d5		; Fill next $29 entries...
-
	move.w	d4,(a6)		; ...using the PNT entry that had bit $A set
	dbf	d5,-
	rts
; ===========================================================================
; Pattern A name table entries, with special flag detailed below
; These are used for the streaks, and point to VRAM in the $1000-$10FF range
ObjB1_Streak_fade_to_right:
	dc.w make_block_tile(ArtTile_ArtNem_Trails+0,0,0,1,1)	; 0
	dc.w make_block_tile(ArtTile_ArtNem_Trails+1,0,0,1,1)	; 2
	dc.w make_block_tile(ArtTile_ArtNem_Trails+2,0,0,1,1)	; 4
	dc.w make_block_tile(ArtTile_ArtNem_Trails+3,0,0,1,1)	; 6
	dc.w make_block_tile(ArtTile_ArtNem_Trails+4,0,0,1,1)	; 8
	dc.w make_block_tile(ArtTile_ArtNem_Trails+5,0,0,1,1)	; 10
	dc.w make_block_tile(ArtTile_ArtNem_Trails+6,0,0,1,1)	; 12
	dc.w make_block_tile(ArtTile_ArtNem_Trails+7,0,0,1,1) | (1 << $A)	; 14	; Bit $A is used as a flag to use this tile $29 times
ObjB1_Streak_fade_to_left:
	dc.w make_block_tile(ArtTile_ArtNem_Trails+7,0,0,1,1) | (1 << $A)	;  0	; Bit $A is used as a flag to use this tile $29 times
	dc.w make_block_tile(ArtTile_ArtNem_Trails+6,0,0,1,1)	; 2
	dc.w make_block_tile(ArtTile_ArtNem_Trails+5,0,0,1,1)	; 4
	dc.w make_block_tile(ArtTile_ArtNem_Trails+4,0,0,1,1)	; 6
	dc.w make_block_tile(ArtTile_ArtNem_Trails+3,0,0,1,1)	; 8
	dc.w make_block_tile(ArtTile_ArtNem_Trails+2,0,0,1,1)	; 10
	dc.w make_block_tile(ArtTile_ArtNem_Trails+1,0,0,1,1)	; 12
	dc.w make_block_tile(ArtTile_ArtNem_Trails+0,0,0,1,1)	; 14
Streak_Horizontal_offsets:
	dc.b $12
	dc.b   4	; 1
	dc.b   4	; 2
	dc.b   2	; 3
	dc.b   2	; 4
	dc.b   2	; 5
	dc.b   2	; 6
	dc.b   0	; 7
	dc.b   0	; 8
	dc.b   0	; 9
	dc.b   0	; 10
	dc.b   0	; 11
	dc.b   0	; 12
	dc.b   0	; 13
	dc.b   0	; 14
	dc.b   4	; 15
	dc.b   4	; 16
	dc.b   6	; 17
	dc.b  $A	; 18
	dc.b   8	; 19
	dc.b   6	; 20
	dc.b   4	; 21
	dc.b   4	; 22
	dc.b   4	; 23
	dc.b   4	; 24
	dc.b   6	; 25
	dc.b   6	; 26
	dc.b   8	; 27
	dc.b   8	; 28
	dc.b  $A	; 29
	dc.b  $A	; 30
	dc.b  $C	; 31
	dc.b  $E	; 32
	dc.b $10	; 33
	dc.b $16	; 34
	dc.b   0	; 35
	even




; ===========================================================================
; ----------------------------------------------------------------------------
; Object B2 - The Tornado (Tails' plane)
; ----------------------------------------------------------------------------
; Sprite_3A790:
ObjB2:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB2_Index(pc,d0.w),d1
	jmp	ObjB2_Index(pc,d1.w)
; ===========================================================================
; off_3A79E:
ObjB2_Index:	offsetTable
		offsetTableEntry.w ObjB2_Init	;  0
		offsetTableEntry.w ObjB2_Main_SCZ	;  2
		offsetTableEntry.w ObjB2_Main_WFZ_Start	;  4
		offsetTableEntry.w ObjB2_Main_WFZ_End	;  6
		offsetTableEntry.w ObjB2_Invisible_grabber	;  8
		offsetTableEntry.w loc_3AD0C	; $A
		offsetTableEntry.w loc_3AD2A	; $C
		offsetTableEntry.w loc_3AD42	; $E
; ===========================================================================
; loc_3A7AE:
ObjB2_Init:
	bsr.w	LoadSubObject
	moveq	#0,d0
	move.b	subtype(a0),d0
	subi.b	#$4E,d0
	move.b	d0,routine(a0)
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	cmpi.b	#8,d0
	bhs.s	+
	move.b	#4,mapping_frame(a0)
	move.b	#1,anim(a0)
+ ; BranchTo5_JmpTo45_DisplaySprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3A7DE:
ObjB2_Main_SCZ:
	bsr.w	ObjB2_Animate_Pilot
	tst.w	(Debug_placement_mode).w
	bne.w	ObjB2_animate
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	art_tile(a1),d0
	andi.w	#high_priority,d0
	move.w	art_tile(a0),d1
	andi.w	#drawing_mask,d1
	or.w	d0,d1
	move.w	d1,art_tile(a0)
	move.w	x_pos(a0),-(sp)
	bsr.w	ObjB2_Move_with_player
	move.b	status(a0),objoff_2E(a0)
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jsrto	SolidObject, JmpTo27_SolidObject
	bsr.w	ObjB2_Move_obbey_player
	move.b	objoff_2E(a0),d0
	move.b	status(a0),d1
	andi.b	#p1_standing,d0	; 'on object' bit
	andi.b	#p1_standing,d1	; 'on object' bit
	eor.b	d0,d1
	move.b	d1,objoff_2E(a0)
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),d1
	move.w	(Camera_X_pos).w,d0
	move.w	d0,(Camera_Min_X_pos).w
	move.w	d0,d2
	addi.w	#$11,d2
	cmp.w	d2,d1
	bhi.s	+
	addq.w	#1,d1
	move.w	d1,x_pos(a1)
+ ; loc_3A85E:
	cmpi.w	#$1400,d0
	blo.s	loc_3A878
	cmpi.w	#$1568,d1
	bhs.s	ObjB2_SCZ_Finished
	st.b	(Control_Locked).w
	move.w	#(button_right_mask<<8)|button_right_mask,(Ctrl_1_Logical).w
	bra.w	loc_3A87C
; ===========================================================================

loc_3A878:
	subi.w	#$40,d0

loc_3A87C:
	move.w	d0,(Camera_Max_X_pos).w
; loc_3A880:
ObjB2_animate:
	lea	(Ani_objB2_a).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3A88E:
ObjB2_SCZ_Finished:
	bsr.w	ObjB2_Deactivate_level
	move.w	#wing_fortress_zone_act_1,(Current_ZoneAndAct).w
	bra.s	ObjB2_animate
; ===========================================================================
; loc_3A89A:
ObjB2_Main_WFZ_Start:
	bsr.w	ObjB2_Animate_Pilot
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3A8BA(pc,d0.w),d1
	jsr	off_3A8BA(pc,d1.w)
	lea	(Ani_objB2_a).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	Obj_DeleteOffScreen, Obj_DeleteOffScreen
; ===========================================================================
off_3A8BA:	offsetTable
		offsetTableEntry.w ObjB2_Main_WFZ_Start_init	; 0
		offsetTableEntry.w ObjB2_Main_WFZ_Start_main	; 2
		offsetTableEntry.w ObjB2_Main_WFZ_Start_shot_down	; 4
		offsetTableEntry.w ObjB2_Main_WFZ_Start_fall_down	; 6
; ===========================================================================
; loc_3A8C2:
ObjB2_Main_WFZ_Start_init:
	addq.b	#2,routine_secondary(a0)
	move.w	#$C0,objoff_32(a0)
	move.w	#$100,x_vel(a0)
	rts
; ===========================================================================
; loc_3A8D4:
ObjB2_Main_WFZ_Start_main:
	subq.w	#1,objoff_32(a0)
	bmi.s	+
	move.w	x_pos(a0),-(sp)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	bsr.w	loc_36776
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jsrto	SolidObject, JmpTo27_SolidObject
	bra.w	ObjB2_Horizontal_limit
; ===========================================================================
+ ; loc_3A8FC:
	addq.b	#2,routine_secondary(a0)
	move.w	#$60,objoff_2A(a0)
	move.w	#1,objoff_32(a0)
	move.w	#$100,x_vel(a0)
	move.w	#$100,y_vel(a0)
	rts
; ===========================================================================
; loc_3A91A:
ObjB2_Main_WFZ_Start_shot_down:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+
	moveq	#signextendB(SndID_Scatter),d0
	jsrto	PlaySound, JmpTo12_PlaySound
+ ; loc_3A92A:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
- ; loc_3A930:
	bsr.w	ObjB2_Align_plane
	subq.w	#1,objoff_32(a0)
	bne.w	return_37A48
	move.w	#$E,objoff_32(a0)
	bra.w	ObjB2_Main_WFZ_Start_load_smoke
; ===========================================================================
+ ; loc_3A946:
	addq.b	#2,routine_secondary(a0)
	bra.w	loc_3B7BC
; ===========================================================================
; loc_3A94E:
ObjB2_Main_WFZ_Start_fall_down:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	bra.s	-
; ===========================================================================
; loc_3A954:
ObjB2_Main_WFZ_End:
	bsr.w	ObjB2_Animate_Pilot
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjB2_Main_WFZ_states(pc,d0.w),d1
	jsr	ObjB2_Main_WFZ_states(pc,d1.w)
	lea	(Ani_objB2_a).l,a1
	jmpto	AnimateSprite, JmpTo25_AnimateSprite
; ===========================================================================
; off_3A970:
ObjB2_Main_WFZ_states:	offsetTable
		offsetTableEntry.w ObjB2_Wait_Leader_position	;   0
		offsetTableEntry.w ObjB2_Move_Leader_edge	;   2
		offsetTableEntry.w ObjB2_Wait_for_plane	;   4
		offsetTableEntry.w ObjB2_Prepare_to_jump	;   6
		offsetTableEntry.w ObjB2_Jump_to_plane	;   8
		offsetTableEntry.w ObjB2_Landed_on_plane	;  $A
		offsetTableEntry.w ObjB2_Approaching_ship	;  $C
		offsetTableEntry.w ObjB2_Jump_to_ship	;  $E
		offsetTableEntry.w ObjB2_Dock_on_DEZ	; $10
; ===========================================================================
; loc_3A982:
ObjB2_Wait_Leader_position:
	lea	(MainCharacter).w,a1 ; a1=character
	cmpi.w	#$5EC,y_pos(a1)
	blo.s	+	; rts
	clr.w	(Ctrl_1_Logical).w
	addq.w	#1,objoff_2E(a0)
	cmpi.w	#$40,objoff_2E(a0)
	bhs.s	++
+ ; return_3A99E:
	rts
; ===========================================================================
+ ; loc_3A9A0:
	addq.b	#2,routine_secondary(a0)
	move.w	#$2E58,x_pos(a0)
	move.w	#$66C,y_pos(a0)
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.w	ObjB2_Waiting_animation
	lea	(ChildObject_3AFBC).l,a2
	bsr.w	LoadChildObject
	move.w	#$3118,x_pos(a1)
	move.w	#$3F0,y_pos(a1)
	lea	(ChildObject_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$3070,x_pos(a1)
	move.w	#$3B0,y_pos(a1)
	lea	(ChildObject_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$3070,x_pos(a1)
	move.w	#$430,y_pos(a1)
	lea	(ChildObject_3AFC0).l,a2
	bsr.w	LoadChildObject
	clr.w	x_pos(a1)
	clr.w	y_pos(a1)
	rts
; ===========================================================================
; loc_3AA0E: ObjB2_Move_Leader_egde:
ObjB2_Move_Leader_edge:
	lea	(MainCharacter).w,a1 ; a1=character
	cmpi.w	#$2E30,x_pos(a1)
	bhs.s	+
	move.w	#(button_right_mask<<8)|button_right_mask,(Ctrl_1_Logical).w
	rts
; ===========================================================================
+ ; loc_3AA22:
	addq.b	#2,routine_secondary(a0)
	clr.w	(Ctrl_1_Logical).w
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	clr.w	inertia(a1)
	move.w	#$600,(Sonic_top_speed).w
	move.w	#$C,(Sonic_acceleration).w
	move.w	#$80,(Sonic_deceleration).w
	bra.w	ObjB2_Waiting_animation
; ===========================================================================
; loc_3AA4C:
ObjB2_Wait_for_plane:
	cmpi.w	#$380,(Camera_BG_X_offset).w
	bhs.s	+
	clr.w	(Ctrl_1_Logical).w
	bra.w	ObjB2_Waiting_animation
; ===========================================================================
+ ; loc_3AA5C:
	addq.b	#2,routine_secondary(a0)
	move.w	#$100,x_vel(a0)
	move.w	#-$100,y_vel(a0)
	clr.w	objoff_2A(a0)
	bra.w	ObjB2_Waiting_animation
; ===========================================================================
; loc_3AA74:
ObjB2_Prepare_to_jump:
	bsr.w	ObjB2_Waiting_animation
	addq.w	#1,objoff_2A(a0)
	cmpi.w	#$30,objoff_2A(a0)
	bne.s	+
	addq.b	#2,routine_secondary(a0)
	move.w	#(button_A_mask<<8)|button_A_mask,(Ctrl_1_Logical).w
	move.w	#$38,objoff_2E(a0)
	tst.b	(Super_Sonic_flag).w
	beq.s	+
	move.w	#$28,objoff_2E(a0)
+ ; loc_3AAA0:
	bsr.w	ObjB2_Align_plane
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3AAA8:
ObjB2_Jump_to_plane:
	clr.w	(Ctrl_1_Logical).w
	addq.w	#1,objoff_2A(a0)
	subq.w	#1,objoff_2E(a0)
	bmi.s	+
	move.w	#((button_right_mask|button_A_mask)<<8)|button_right_mask|button_A_mask,(Ctrl_1_Logical).w
+ ; loc_3AABC:
	bsr.w	ObjB2_Align_plane
	btst	#p1_standing_bit,status(a0)
	beq.s	+
	addq.b	#2,routine_secondary(a0)
	move.w	#$20,objoff_2E(a0)
	lea	(Level_Layout+$0D2).w,a1
	move.l	#$501F0025,(a1)+
	lea	(Level_Layout+$1D2).w,a1
	move.l	#$25001F50,(a1)+
	lea	(Level_Layout+$BD6).w,a1
	move.l	#$501F0025,(a1)+
	lea	(Level_Layout+$CD6).w,a1
	move.l	#$25001F50,(a1)+
+ ; BranchTo6_JmpTo45_DisplaySprite:
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3AAFE:
ObjB2_Landed_on_plane:
	addq.w	#1,objoff_2A(a0)
	cmpi.w	#$100,objoff_2A(a0)
	blo.s	loc_3AB18
	addq.b	#2,routine_secondary(a0)
	movea.w	objoff_3A(a0),a1 ; a1=object??
	move.b	#2,routine_secondary(a1)

loc_3AB18:
	clr.w	(Ctrl_1_Logical).w
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a0),x_pos(a1)
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	clr.w	inertia(a1)
	bclr	#1,status(a1)
	bclr	#2,status(a1)
	move.l	#(1<<24)|(0<<16)|(AniIDSonAni_Wait<<8)|(AniIDSonAni_Wait<<0),mapping_frame(a1)
	move.w	#$100,anim_frame_duration(a1)
	move.b	#$13,y_radius(a1)
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	move.b	#$F,y_radius(a1)
+ ; loc_3AB60:
	bsr.w	ObjB2_Align_plane
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3AB68:
ObjB2_Approaching_ship:
	clr.w	(Ctrl_1_Logical).w
	bsr.w	ObjB2_Waiting_animation
	cmpi.w	#$437,objoff_2A(a0)
	blo.s	loc_3AB8A
	addq.b	#2,routine_secondary(a0)
; loc_3AB7C:
ObjB2_Jump_to_ship:
	cmpi.w	#$447,objoff_2A(a0)
	bhs.s	loc_3AB8A
	move.w	#(button_A_mask<<8)|button_A_mask,(Ctrl_1_Logical).w

loc_3AB8A:
	cmpi.w	#$460,objoff_2A(a0)
	blo.s	ObjB2_Dock_on_DEZ
	move.b	#6,(Dynamic_Resize_Routine).w ; => LevEvents_WFZ_Routine4
	addq.b	#2,routine_secondary(a0)
	lea	(ChildObject_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$3090,x_pos(a1)
	move.w	#$3D0,y_pos(a1)
	lea	(ChildObject_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$30C0,x_pos(a1)
	move.w	#$3F0,y_pos(a1)
	lea	(ChildObject_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$3090,x_pos(a1)
	move.w	#$410,y_pos(a1)
; loc_3ABDE:
ObjB2_Dock_on_DEZ:
	cmpi.w	#$9C0,objoff_2A(a0)
	bhs.s	ObjB2_Start_DEZ
	move.w	objoff_2A(a0),d0
	addq.w	#1,d0
	move.w	d0,objoff_2A(a0)
	move.w	objoff_34(a0),d1
	move.w	word_3AC16(pc,d1.w),d2
	cmp.w	d2,d0
	blo.s	loc_3AC0E
	addq.w	#2,d1
	move.w	d1,objoff_34(a0)
	lea	byte_3AC2A(pc,d1.w),a1
	move.b	(a1)+,x_vel(a0)
	move.b	(a1)+,y_vel(a0)

loc_3AC0E:
	bsr.w	ObjB2_Align_plane
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
word_3AC16:
	dc.w  $1E0
	dc.w  $260	; 1
	dc.w  $2A0	; 2
	dc.w  $2C0	; 3
	dc.w  $300	; 4
	dc.w  $3A0	; 5
	dc.w  $3F0	; 6
	dc.w  $460	; 7
	dc.w  $4A0	; 8
	dc.w  $580	; 9
byte_3AC2A:
	dc.b $FF
	dc.b $FF	; 1
	dc.b   1	; 2
	dc.b   0	; 3
	dc.b   0	; 4
	dc.b   1	; 5
	dc.b   1	; 6
	dc.b $FF	; 7
	dc.b   1	; 8
	dc.b   1	; 9
	dc.b   1	; 10
	dc.b $FF	; 11
	dc.b $FF	; 12
	dc.b   1	; 13
	dc.b $FF	; 14
	dc.b $FF	; 15
	dc.b $FF	; 16
	dc.b   1	; 17
	dc.b $FE	; 18
	dc.b   0	; 19
	dc.b   0	; 20
	dc.b   0	; 21
	even
; ===========================================================================
; loc_3AC40:
ObjB2_Start_DEZ:
	move.w	#death_egg_zone_act_1,(Current_ZoneAndAct).w
; loc_3AC46:
ObjB2_Deactivate_level:
	move.w	#1,(Level_Inactive_flag).w
	clr.b	(Last_star_pole_hit).w
	clr.b	(Last_star_pole_hit_2P).w
	rts
; ===========================================================================
; loc_3AC56:
ObjB2_Waiting_animation:
	lea	(MainCharacter).w,a1 ; a1=character
	move.l	#(1<<24)|(0<<16)|(AniIDSonAni_Wait<<8)|(AniIDSonAni_Wait<<0),mapping_frame(a1)
	move.w	#$100,anim_frame_duration(a1)
	rts
; ===========================================================================
; loc_3AC6A:
ObjB2_Invisible_grabber:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3AC78(pc,d0.w),d1
	jmp	off_3AC78(pc,d1.w)
; ===========================================================================
off_3AC78:	offsetTable
		offsetTableEntry.w loc_3AC7E	; 0
		offsetTableEntry.w loc_3AC84	; 2
		offsetTableEntry.w loc_3ACF2	; 4
; ===========================================================================

loc_3AC7E:
	move.b	#$C7,collision_flags(a0)

loc_3AC84:
	tst.b	collision_property(a0)
	beq.s	return_3ACF0
	addq.b	#2,routine_secondary(a0)
	clr.b	collision_flags(a0)
	move.w	#(224/2)+8,(Camera_Y_pos_bias).w
	movea.w	objoff_2C(a0),a1 ; a1=object
	bset	#6,status(a1)
	lea	(MainCharacter).w,a1 ; a1=character
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	move.w	x_pos(a0),d0
	subi.w	#$10,d0
	move.w	d0,x_pos(a1)
	cmpi.w	#2,(Player_mode).w
	bne.s	loc_3ACC8
	subi.w	#$10,y_pos(a1)

loc_3ACC8:
	bset	#0,status(a1)
	bclr	#1,status(a1)
	bclr	#2,status(a1)
	move.b	#AniIDSonAni_Hang,anim(a1)
	move.b	#1,(MainCharacter+obj_control).w
	move.b	#1,(WindTunnel_holding_flag).w
	clr.w	(Ctrl_1_Logical).w

return_3ACF0:
	rts
; ===========================================================================

loc_3ACF2:
	lea	(MainCharacter).w,a1 ; a1=character
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	move.w	x_pos(a0),d0
	subi.w	#$10,d0
	move.w	d0,x_pos(a1)
	rts
; ===========================================================================

loc_3AD0C:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3AD1A(pc,d0.w),d1
	jmp	off_3AD1A(pc,d1.w)
; ===========================================================================
off_3AD1A:	offsetTable
		offsetTableEntry.w +	; 0
; ===========================================================================
+ ; loc_3AD1C:
	bchg	#2,status(a0)
	bne.w	return_37A48
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3AD2A:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3AD38(pc,d0.w),d1
	jmp	off_3AD38(pc,d1.w)
; ===========================================================================
off_3AD38:	offsetTable
		offsetTableEntry.w +	; 0
; ===========================================================================
+ ; loc_3AD3A:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3AD42:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3AD50(pc,d0.w),d1
	jmp	off_3AD50(pc,d1.w)
; ===========================================================================
off_3AD50:	offsetTable
		offsetTableEntry.w loc_3AD54	; 0
		offsetTableEntry.w loc_3AD5C	; 2
; ===========================================================================

loc_3AD54:
	bsr.w	loc_3AD6E
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3AD5C:
	bsr.w	loc_3AD6E
	lea	(Ani_objB2_b).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3AD6E:
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.w	x_pos(a1),d0
	subi.w	#$C,d0
	move.w	d0,x_pos(a0)
	move.w	y_pos(a1),d0
	addi.w	#$28,d0
	move.w	d0,y_pos(a0)
	rts
; ===========================================================================
; loc_3AD8C:
ObjB2_Align_plane:
	move.w	x_pos(a0),-(sp)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	bsr.w	loc_36776
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jmpto	SolidObject, JmpTo27_SolidObject
; ===========================================================================
; loc_3ADAA:
ObjB2_Move_with_player:
	lea	(MainCharacter).w,a1 ; a1=character
	btst	#3,status(a1)
	beq.s	ObjB2_Move_below_player
	bsr.w	ObjB2_Move_vert
	bsr.w	ObjB2_Vertical_limit
	jsrto	ObjectMove, JmpTo26_ObjectMove
	bra.w	loc_36776
; ===========================================================================
; loc_3ADC6:
ObjB2_Move_below_player:
	tst.b	objoff_2E(a0)
	beq.s	loc_3ADD4
	bsr.w	Obj_GetOrientationToPlayer
	move.w	d2,objoff_38(a0)

loc_3ADD4:
	move.w	#1,d0
	move.w	objoff_38(a0),d3
	beq.s	loc_3ADE8
	bmi.s	loc_3ADE2
	neg.w	d0

loc_3ADE2:
	add.w	d0,d3
	move.w	d3,objoff_38(a0)

loc_3ADE8:
	move.w	x_pos(a1),d1
	add.w	d3,d1
	move.w	d1,x_pos(a0)
	bra.w	loc_36776
; ===========================================================================
; loc_3ADF6:
ObjB2_Move_vert:
	tst.b	objoff_2F(a0)
	bne.s	loc_3AE16
	tst.b	objoff_2E(a0)
	beq.s	return_3AE38
	st.b	objoff_2F(a0)
	clr.b	objoff_30(a0)
	move.w	#$200,y_vel(a0)
	move.b	#$14,objoff_31(a0)

loc_3AE16:
	subq.b	#1,objoff_31(a0)
	bpl.s	loc_3AE26
	clr.b	objoff_2F(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_3AE26:
	move.w	y_vel(a0),d0
	cmpi.w	#-$100,d0
	ble.s	loc_3AE34
	addi.w	#-$20,d0

loc_3AE34:
	move.w	d0,y_vel(a0)

return_3AE38:
	rts
; ===========================================================================
; loc_3AE3A:
ObjB2_Move_obbey_player:
	lea	(MainCharacter).w,a1 ; a1=character
	btst	#3,status(a1)
	beq.s	ObjB2_Move_vert2
	tst.b	objoff_2F(a0)
	bne.s	loc_3AE72
	clr.w	y_vel(a0)
	move.w	(Ctrl_1).w,d2
	move.w	#$80,d3
	andi.w	#(button_up_mask|button_down_mask)<<8,d2
	beq.s	loc_3AE72
	andi.w	#button_down_mask<<8,d2
	bne.s	loc_3AE66
	neg.w	d3

loc_3AE66:
	move.w	d3,y_vel(a0)
	bsr.w	ObjB2_Vertical_limit
	jsrto	ObjectMove, JmpTo26_ObjectMove

loc_3AE72:
	bsr.w	Obj_GetOrientationToPlayer
	moveq	#$10,d3
	add.w	d3,d2
	cmpi.w	#$20,d2
	blo.s	return_3AE9E
	mvabs.w	inertia(a1),d2
	cmpi.w	#$900,d2
	bhs.s	return_3AE9E
	tst.w	d0
	beq.s	loc_3AE94
	neg.w	d3

loc_3AE94:
	move.w	x_pos(a1),d1
	add.w	d3,d1
	move.w	d1,x_pos(a0)

return_3AE9E:
	rts
; ===========================================================================
; loc_3AEA0:
ObjB2_Move_vert2:
	tst.b	objoff_30(a0)
	bne.s	loc_3AEC0
	tst.b	objoff_2E(a0)
	beq.s	return_3AE9E
	st.b	objoff_30(a0)
	clr.b	objoff_2F(a0)
	move.w	#$200,y_vel(a0)
	move.b	#$2B,objoff_31(a0)

loc_3AEC0:
	subq.b	#1,objoff_31(a0)
	bpl.s	loc_3AED0
	clr.b	objoff_30(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_3AED0:
	move.w	y_vel(a0),d0
	cmpi.w	#-$100,d0
	ble.s	loc_3AEDE
	addi.w	#-$20,d0

loc_3AEDE:
	move.w	d0,y_vel(a0)
	bsr.w	ObjB2_Vertical_limit
	jsrto	ObjectMove, JmpTo26_ObjectMove
	rts
; ===========================================================================
; loc_3AEEC:
ObjB2_Horizontal_limit:
	bsr.w	Obj_GetOrientationToPlayer
	moveq	#$10,d3
	add.w	d3,d2
	cmpi.w	#$20,d2
	blo.s	return_3AF0A
	tst.w	d0
	beq.s	loc_3AF00
	neg.w	d3

loc_3AF00:
	move.w	x_pos(a0),d1
	sub.w	d3,d1
	move.w	d1,x_pos(a1)

return_3AF0A:
	rts
; ===========================================================================
; loc_3AF0C:
ObjB2_Vertical_limit:
	move.w	(Camera_Y_pos).w,d0
	move.w	y_pos(a0),d1
	move.w	y_vel(a0),d2
	beq.s	return_3AF32
	bpl.s	loc_3AF26
	addi.w	#$34,d0
	cmp.w	d0,d1
	blo.s	loc_3AF2E
	rts
; ===========================================================================

loc_3AF26:
	addi.w	#$A8,d0
	cmp.w	d0,d1
	blo.s	return_3AF32

loc_3AF2E:
	clr.w	y_vel(a0)

return_3AF32:
	rts
; ===========================================================================
; loc_3AF34:
ObjB2_Main_WFZ_Start_load_smoke:
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	+
	_move.b	#ObjID_TornadoSmoke2,id(a1) ; load objC3
	move.b	#$90,subtype(a1) ; <== ObjC3_SubObjData
	move.w	a0,objoff_2C(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
+ ; return_3AF56:
	rts
; ===========================================================================
; loc_3AF58:
ObjB2_Animate_Pilot:
	subq.b	#1,objoff_37(a0)
	bmi.s	+
	rts
; ===========================================================================
+ ; loc_3AF60:
	move.b	#8,objoff_37(a0)
	moveq	#0,d0
	move.b	objoff_36(a0),d0
	moveq	#Tails_pilot_frames_end-Tails_pilot_frames,d1
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	moveq	#Sonic_pilot_frames_end-Sonic_pilot_frames,d1
+ ; loc_3AF78:
	addq.b	#1,d0
	cmp.w	d1,d0
	blo.s	+
	moveq	#0,d0
+ ; loc_3AF80:
	move.b	d0,objoff_36(a0)
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	move.b	Sonic_pilot_frames(pc,d0.w),d0
	jmpto	LoadSonicDynPLC_Part2, JmpTo_LoadSonicDynPLC_Part2
; ===========================================================================
+ ; loc_3AF94:
	move.b	Tails_pilot_frames(pc,d0.w),d0
	jmpto	LoadTailsDynPLC_Part2, JmpTo_LoadTailsDynPLC_Part2
; ===========================================================================
; byte_3AF9C:
Sonic_pilot_frames:
	dc.b $2D
	dc.b $2E	; 1
	dc.b $2F	; 2
	dc.b $30	; 3
Sonic_pilot_frames_end:

; byte_3AFA0:
Tails_pilot_frames:
	dc.b $10
	dc.b $10	; 1
	dc.b $10	; 2
	dc.b $10	; 3
	dc.b   1	; 4
	dc.b   2	; 5
	dc.b   3	; 6
	dc.b   2	; 7
	dc.b   1	; 8
	dc.b   1	; 9
	dc.b $10	; 10
	dc.b $10	; 11
	dc.b $10	; 12
	dc.b $10	; 13
	dc.b   1	; 14
	dc.b   2	; 15
	dc.b   3	; 16
	dc.b   2	; 17
	dc.b   1	; 18
	dc.b   1	; 19
	dc.b   4	; 20
	dc.b   4	; 21
	dc.b   1	; 22
	dc.b   1	; 23
Tails_pilot_frames_end:
	even

ChildObject_3AFB8:	childObjectData objoff_3E, ObjID_Tornado, $58
ChildObject_3AFBC:	childObjectData objoff_3C, ObjID_Tornado, $56
ChildObject_3AFC0:	childObjectData objoff_3A, ObjID_Tornado, $5C
			childObjectData objoff_3E, ObjID_Tornado, $5A	; seems unused
; off_3AFC8:
ObjB2_SubObjData:
	subObjData ObjB2_MapUnc_3AFF2,make_art_tile(ArtTile_ArtNem_Tornado,0,1),4,4,$60,0
; off_3AFD2:
ObjB2_SubObjData2:
	subObjData ObjB2_MapUnc_3B292,make_art_tile(ArtTile_ArtNem_TornadoThruster,0,0),4,3,$40,0
; animation script
; off_3AFDC:
Ani_objB2_a:	offsetTable
		offsetTableEntry.w byte_3AFE0	; 0
		offsetTableEntry.w byte_3AFE6	; 1
byte_3AFE0:	dc.b   0,  0,  1,  2,  3,$FF
byte_3AFE6:	dc.b   0,  4,  5,  6,  7,$FF
		even
; animation script
; off_3AFEC:
Ani_objB2_b:	offsetTable
		offsetTableEntry.w +	; 0
; byte_3AFEE:
+		dc.b   0,  1,  2,$FF
		even
; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjB2_MapUnc_3AFF2:	include "mappings/sprite/objB2_a.asm"
; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjB2_MapUnc_3B292:	include "mappings/sprite/objB2_b.asm"


; ===========================================================================
; ----------------------------------------------------------------------------
; Object B3 - Clouds (placeable object) from SCZ
; ----------------------------------------------------------------------------
; Sprite_3B2DE:
ObjB3:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB3_Index(pc,d0.w),d1
	jmp	ObjB3_Index(pc,d1.w)
; ===========================================================================
; off_3B2EC:
ObjB3_Index:	offsetTable
		offsetTableEntry.w ObjB3_Init	; 0
		offsetTableEntry.w ObjB3_Main	; 2
; ===========================================================================
; loc_3B2F0:
ObjB3_Init:
	bsr.w	LoadSubObject
	moveq	#0,d0
	move.b	subtype(a0),d0
	subi.b	#$5E,d0
	move.w	word_3B30C(pc,d0.w),x_vel(a0)
	lsr.w	#1,d0
	move.b	d0,mapping_frame(a0)
	rts
; ===========================================================================
word_3B30C:
	dc.w  -$80
	dc.w  -$40	; 1
	dc.w  -$20	; 2
; ===========================================================================
; loc_3B312:
ObjB3_Main:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	move.w	(Tornado_Velocity_X).w,d0
	add.w	d0,x_pos(a0)
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================
; off_3B322:
ObjB3_SubObjData:
	subObjData ObjB3_MapUnc_3B32C,make_art_tile(ArtTile_ArtNem_Clouds,2,0),4,6,$30,0

; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjB3_MapUnc_3B32C:	include "mappings/sprite/objB3.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object B4 - Vertical propeller from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B36A:
ObjB4:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB4_Index(pc,d0.w),d1
	jmp	ObjB4_Index(pc,d1.w)
; ===========================================================================
; off_3B378:
ObjB4_Index:	offsetTable
		offsetTableEntry.w ObjB4_Init	; 0
		offsetTableEntry.w ObjB4_Main	; 2
; ===========================================================================
; loc_3B37C:
ObjB4_Init:
	bsr.w	LoadSubObject
	bclr	#1,render_flags(a0)
	beq.s	+
	clr.b	collision_flags(a0)
+
	rts
; ===========================================================================
; loc_3B38E:
ObjB4_Main:
	lea	(Ani_objB4).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+
	moveq	#signextendB(SndID_Helicopter),d0
	jsrto	PlaySoundLocal, JmpTo_PlaySoundLocal
+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; off_3B3AC:
ObjB4_SubObjData:
	subObjData ObjB4_MapUnc_3B3BE,make_art_tile(ArtTile_ArtNem_WfzVrtclPrpllr,1,1),4,4,4,$A8
; animation script
; off_3B3B6:
Ani_objB4:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,$FF,  0
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB4_MapUnc_3B3BE:	include "mappings/sprite/objB4.asm"
; ===========================================================================
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
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
off_3B442:	offsetTable
		offsetTableEntry.w +	; 0
; ===========================================================================
+	bra.w	ObjB5_CheckPlayers
; ===========================================================================
; loc_3B448:
ObjB5_Animate:
	lea	(Ani_objB5).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
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
	bset	#1,status(a1)
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
	subObjData ObjB5_MapUnc_3B548,make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1),4,4,$40,0

; animation script
; off_3B4E8:
Ani_objB5:	offsetTable
		offsetTableEntry.w byte_3B4FC	; 0
		offsetTableEntry.w byte_3B506	; 1
		offsetTableEntry.w byte_3B50E	; 2
		offsetTableEntry.w byte_3B516	; 3
		offsetTableEntry.w byte_3B51C	; 4
		offsetTableEntry.w byte_3B524	; 5
		offsetTableEntry.w byte_3B52A	; 6
		offsetTableEntry.w byte_3B532	; 7
		offsetTableEntry.w byte_3B53A	; 8
		offsetTableEntry.w byte_3B544	; 9
byte_3B4FC:	dc.b   7,  0,  1,  2,  3,  4,  5,$FD,  1,  0
byte_3B506:	dc.b   4,  0,  1,  2,  3,  4,$FD,  2
byte_3B50E:	dc.b   3,  5,  0,  1,  2,$FD,  3,  0
byte_3B516:	dc.b   2,  3,  4,  5,$FD,  4
byte_3B51C:	dc.b   1,  0,  1,  2,  3,  4,  5,$FF
byte_3B524:	dc.b   2,  5,  4,  3,$FD,  6
byte_3B52A:	dc.b   3,  2,  1,  0,  5,$FD,  7,  0
byte_3B532:	dc.b   4,  4,  3,  2,  1,  0,$FD,  8
byte_3B53A:	dc.b   7,  5,  4,  3,  2,  1,  0,$FD,  9,  0
byte_3B544:	dc.b $7E,  0,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB5_MapUnc_3B548:	include "mappings/sprite/objB5.asm"
; ===========================================================================
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
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
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
	jmpto	AnimateSprite, JmpTo25_AnimateSprite
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
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
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
	jmpto	PlaySound, JmpTo12_PlaySound
; ===========================================================================

loc_3B6A6:
	subq.b	#1,objoff_2A(a0)
	bmi.s	+
	lea	(Ani_objB6).l,a1
	jmpto	AnimateSprite, JmpTo25_AnimateSprite
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
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
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
	bclr	#0,status(a0)
	tst.w	d0
	bne.s	+
	bset	#0,status(a0)
+
	bra.w	loc_3B7BC
; ===========================================================================

loc_3B72C:
	lea	(Ani_objB6).l,a1
	jmpto	AnimateSprite, JmpTo25_AnimateSprite
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
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
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
	jmpto	SolidObject, JmpTo27_SolidObject
; ===========================================================================

loc_3B7A6:
	move.w	x_pos(a0),-(sp)
	move.w	#$F,d1
	move.w	#$18,d2
	move.w	#$18,d3
	move.w	(sp)+,d4
	jmpto	SolidObject, JmpTo27_SolidObject
; ===========================================================================

loc_3B7BC:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	return_3B7F6
	bclr	#p1_standing_bit,status(a0)
	beq.s	loc_3B7DE
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#3,status(a1)
	bset	#1,status(a1)

loc_3B7DE:
	bclr	#p2_standing_bit,status(a0)
	beq.s	return_3B7F6
	lea	(Sidekick).w,a1 ; a1=character
	bclr	#4,status(a1)
	bset	#1,status(a1)

return_3B7F6:
	rts
; ===========================================================================

loc_3B7F8:
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
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
	subObjData ObjB6_MapUnc_3B856,make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1),4,4,$10,0

; animation script
; off_3B822:
Ani_objB6:	offsetTable
		offsetTableEntry.w byte_3B830	; 0
		offsetTableEntry.w byte_3B836	; 1
		offsetTableEntry.w byte_3B83A	; 2
		offsetTableEntry.w byte_3B840	; 3
		offsetTableEntry.w byte_3B846	; 4
		offsetTableEntry.w byte_3B84C	; 5
		offsetTableEntry.w byte_3B850	; 6
byte_3B830:	dc.b   3,  1,  2,$FD,  1,  0
byte_3B836:	dc.b $3F,  2,$FD,  2
byte_3B83A:	dc.b   3,  2,  1,  0,$FA,  0
byte_3B840:	dc.b   1,  0,  1,  2,  3,$FF
byte_3B846:	dc.b   3,  1,  0,$FD,  5,  0
byte_3B84C:	dc.b $3F,  0,$FD,  6
byte_3B850:	dc.b   3,  0,  1,  2,$FA,  0
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB6_MapUnc_3B856:	include "mappings/sprite/objB6.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B7 - Unused huge vertical laser from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B8A6:
ObjB7:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB7_Index(pc,d0.w),d1
	jmp	ObjB7_Index(pc,d1.w)
; ===========================================================================
; off_3B8B4:
ObjB7_Index:	offsetTable
		offsetTableEntry.w ObjB7_Init	; 0
		offsetTableEntry.w ObjB7_Main	; 2
; ===========================================================================
; loc_3B8B8:
ObjB7_Init:
	bsr.w	LoadSubObject
	move.b	#$20,objoff_2A(a0)
	rts
; ===========================================================================
; loc_3B8C4:
ObjB7_Main:
	subq.b	#1,objoff_2A(a0)
	beq.w	JmpTo65_DeleteObject
	bchg	#0,objoff_2B(a0)
	beq.w	return_37A48
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; off_3B8DA:
ObjB7_SubObjData:
	subObjData ObjB7_MapUnc_3B8E4,make_art_tile(ArtTile_ArtNem_WfzVrtclLazer,2,1),4,4,$18,$A9
ObjB7_MapUnc_3B8E4:	include "mappings/sprite/objB7.asm"

; ===========================================================================
; ----------------------------------------------------------------------------
; Object B8 - Wall turret from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B968:
ObjB8:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB8_Index(pc,d0.w),d1
	jmp	ObjB8_Index(pc,d1.w)
; ===========================================================================
; off_3B976:
ObjB8_Index:	offsetTable
		offsetTableEntry.w ObjB8_Init	; 0
		offsetTableEntry.w loc_3B980	; 2
		offsetTableEntry.w loc_3B9AA	; 4
; ===========================================================================
; BranchTo5_LoadSubObject
ObjB8_Init:
	bra.w	LoadSubObject
; ===========================================================================

loc_3B980:
	tst.b	render_flags(a0)
	bpl.s	+
	bsr.w	Obj_GetOrientationToPlayer
	tst.w	d1
	beq.s	+
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	blo.s	++
+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	#2,objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3B9AA:
	bsr.w	Obj_GetOrientationToPlayer
	moveq	#0,d6
	addi.w	#$20,d2
	cmpi.w	#$40,d2
	blo.s	loc_3B9C0
	move.w	d0,d6
	lsr.w	#1,d6
	addq.w	#1,d6

loc_3B9C0:
	move.b	d6,mapping_frame(a0)
	subq.w	#1,objoff_2A(a0)
	bne.s	+
	move.w	#$60,objoff_2A(a0)
	bsr.w	loc_3B9D8
+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3B9D8:
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	+	; rts
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#3,mapping_frame(a1)
	move.b	#$8E,subtype(a1) ; <== ObjB8_SubObjData2
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	lea_	Obj98_WallTurretShotMove,a2
	move.l	a2,objoff_2A(a1)
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	lsl.w	#2,d0
	lea	byte_3BA2A(pc,d0.w),a2
	move.b	(a2)+,d0
	ext.w	d0
	add.w	d0,x_pos(a1)
	move.b	(a2)+,d0
	ext.w	d0
	add.w	d0,y_pos(a1)
	move.b	(a2)+,x_vel(a1)
	move.b	(a2)+,y_vel(a1)
+
	rts
; ===========================================================================
byte_3BA2A:
	dc.b   0
	dc.b $18	; 1
	dc.b   0	; 2
	dc.b   1	; 3
	dc.b $EF	; 4
	dc.b $10	; 5
	dc.b $FF	; 6
	dc.b   1	; 7
	dc.b $11	; 8
	dc.b $10	; 9
	dc.b   1	; 10
	dc.b   1	; 11
	even
; off_3BA36:
ObjB8_SubObjData:
	subObjData ObjB8_Obj98_MapUnc_3BA46,make_art_tile(ArtTile_ArtNem_WfzWallTurret,0,0),4,4,$10,0
; animation script
; off_3BA40:
Ani_WallTurretShot: offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   2,  3,  4,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB8_Obj98_MapUnc_3BA46:	include "mappings/sprite/objB8.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B9 - Laser from WFZ that shoots down the Tornado
; ----------------------------------------------------------------------------
; Sprite_3BABA:
ObjB9:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB9_Index(pc,d0.w),d1
	jmp	ObjB9_Index(pc,d1.w)
; ===========================================================================
; off_3BAC8:
ObjB9_Index:	offsetTable
		offsetTableEntry.w ObjB9_Init
		offsetTableEntry.w loc_3BAD2
		offsetTableEntry.w loc_3BAF0
; ===========================================================================
; BranchTo6_LoadSubObject
ObjB9_Init:
	bra.w	LoadSubObject
; ===========================================================================

loc_3BAD2:
	tst.b	render_flags(a0)
	bmi.s	+
	bra.w	loc_3BAF8
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	#-$1000,x_vel(a0)
	moveq	#signextendB(SndID_LargeLaser),d0
	jsrto	PlaySound, JmpTo12_PlaySound
	bra.w	loc_3BAF8
; ===========================================================================

loc_3BAF0:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	bra.w	loc_3BAF8
loc_3BAF8:
	move.w	x_pos(a0),d0
	move.w	(Camera_X_pos).w,d1
	subi.w	#$40,d1
	cmp.w	d1,d0
	blt.w	JmpTo65_DeleteObject
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; off_3BB0E:
ObjB9_SubObjData:
	subObjData ObjB9_MapUnc_3BB18,make_art_tile(ArtTile_ArtNem_WfzHrzntlLazer,2,1),4,1,$60,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB9_MapUnc_3BB18:	include "mappings/sprite/objB9.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BA - Wheel from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BB4C:
ObjBA:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBA_Index(pc,d0.w),d1
	jmp	ObjBA_Index(pc,d1.w)
; ===========================================================================
; off_3BB5A:
ObjBA_Index:	offsetTable
		offsetTableEntry.w ObjBA_Init	; 0
		offsetTableEntry.w ObjBA_Main	; 2
; ===========================================================================
; BranchTo7_LoadSubObject
ObjBA_Init:
	bra.w	LoadSubObject
; ===========================================================================
; BranchTo14_JmpTo39_MarkObjGone
ObjBA_Main:
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; off_3BB66:
ObjBA_SubObjData:
	subObjData ObjBA_MapUnc_3BB70,make_art_tile(ArtTile_ArtNem_WfzConveyorBeltWheel,2,1),4,4,$10,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBA_MapUnc_3BB70:	include "mappings/sprite/objBA.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BB - Removed object (unknown, unused)
; ----------------------------------------------------------------------------
; Sprite_3BB7C:
ObjBB:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBB_Index(pc,d0.w),d1
	jmp	ObjBB_Index(pc,d1.w)
; ===========================================================================
; off_3BB8A:
ObjBB_Index:	offsetTable
		offsetTableEntry.w ObjBB_Init	; 0
		offsetTableEntry.w ObjBB_Main	; 2
; ===========================================================================
; BranchTo8_LoadSubObject
ObjBB_Init:
	bra.w	LoadSubObject
; ===========================================================================
; BranchTo15_JmpTo39_MarkObjGone
ObjBB_Main:
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; off_3BB96:
ObjBB_SubObjData:
	subObjData ObjBB_MapUnc_3BBA0,make_art_tile(ArtTile_ArtNem_Unknown,1,0),4,4,$C,9
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBB_MapUnc_3BBA0:	include "mappings/sprite/objBB.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BC - Fire coming out of Robotnik's ship in WFZ
; ----------------------------------------------------------------------------
; Sprite_3BBBC:
ObjBC:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBC_Index(pc,d0.w),d1
	jmp	ObjBC_Index(pc,d1.w)
; ===========================================================================
; off_3BBCA:
ObjBC_Index:	offsetTable
		offsetTableEntry.w ObjBC_Init
		offsetTableEntry.w ObjBC_Main
; ===========================================================================
; loc_3BBCE:
ObjBC_Init:
	bsr.w	LoadSubObject
	move.w	x_pos(a0),objoff_2C(a0)
	rts
; ===========================================================================
; loc_3BBDA:
ObjBC_Main:
	move.w	objoff_2C(a0),d0
	move.w	(Camera_BG_X_offset).w,d1
	cmpi.w	#$380,d1
	bhs.w	JmpTo65_DeleteObject
	add.w	d1,d0
	move.w	d0,x_pos(a0)
	bchg	#0,objoff_2A(a0)
	beq.w	return_37A48
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; off_3BBFE:
ObjBC_SubObjData2:
	subObjData ObjBC_MapUnc_3BC08,make_art_tile(ArtTile_ArtNem_WfzThrust,2,0),4,4,$10,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBC_MapUnc_3BC08:	include "mappings/sprite/objBC.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BD - Ascending/descending metal platforms from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BC1C:
ObjBD:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBD_Index(pc,d0.w),d1
	jmp	ObjBD_Index(pc,d1.w)
; ===========================================================================
; off_3BC2A:
ObjBD_Index:	offsetTable
		offsetTableEntry.w ObjBD_Init	; 0
		offsetTableEntry.w loc_3BC3C	; 2
		offsetTableEntry.w loc_3BC50	; 4
; ===========================================================================
; loc_3BC30:
ObjBD_Init:
	addq.b	#2,routine(a0)
	move.w	#1,objoff_2A(a0)
	rts
; ===========================================================================

loc_3BC3C:
	subq.w	#1,objoff_2A(a0)
	bne.s	+
	move.w	#$40,objoff_2A(a0)
	bsr.w	loc_3BCF8
+
	jmpto	MarkObjGone3, JmpTo8_MarkObjGone3
; ===========================================================================

loc_3BC50:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3BC62(pc,d0.w),d1
	jsr	off_3BC62(pc,d1.w)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
off_3BC62:	offsetTable
		offsetTableEntry.w loc_3BC6C	; 0
		offsetTableEntry.w loc_3BCAC	; 2
		offsetTableEntry.w loc_3BCB6	; 4
		offsetTableEntry.w loc_3BCCC	; 6
		offsetTableEntry.w loc_3BCD6	; 8
; ===========================================================================

loc_3BC6C:
	bsr.w	LoadSubObject
	move.b	#2,mapping_frame(a0)
	subq.b	#2,routine(a0)
	addq.b	#2,routine_secondary(a0)
	move.w	#$C7,objoff_2A(a0)
	btst	#0,render_flags(a0)
	beq.s	loc_3BC92
	move.w	#$1C7,objoff_2A(a0)

loc_3BC92:
	moveq	#0,d0
	move.b	subtype(a0),d0
	subi.b	#$7E,d0
	move.b	d0,subtype(a0)
	move.w	word_3BCA8(pc,d0.w),y_vel(a0)
	rts
; ===========================================================================
word_3BCA8:
	dc.w -$100
	dc.w  $100	; 1
; ===========================================================================

loc_3BCAC:
	lea	(Ani_objBD).l,a1
	jmpto	AnimateSprite, JmpTo25_AnimateSprite
; ===========================================================================

loc_3BCB6:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3BCC0
	bra.w	loc_3BCDE
; ===========================================================================

loc_3BCC0:
	addq.b	#2,routine_secondary(a0)
	move.b	#1,anim(a0)
	rts
; ===========================================================================

loc_3BCCC:
	lea	(Ani_objBD).l,a1
	jmpto	AnimateSprite, JmpTo25_AnimateSprite
; ===========================================================================

loc_3BCD6:
	bsr.w	loc_3B7BC
    if fixBugs
	; 'DeleteObject' is called here, but then 'loc_3BC50' calls 'MarkObjGone' afterwards.
	; This can result in either the object being queued for display with 'DisplaySprite',
	; or the object being deleted again with yet another call to 'DeleteObject'.
	; To prevent this, just meddle with the stack to prevent returning to 'loc_3BC50', like this:
	addq.w	#4,sp
    endif
	bra.w	JmpTo65_DeleteObject
; ===========================================================================

loc_3BCDE:
	move.w	x_pos(a0),-(sp)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	move.w	#$23,d1
	move.w	#4,d2
	move.w	#5,d3
	move.w	(sp)+,d4
	jmpto	PlatformObject, JmpTo9_PlatformObject
; ===========================================================================

loc_3BCF8:
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	+	; rts
	_move.b	#ObjID_SmallMetalPform,id(a1) ; load objBD
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#4,routine(a1)
	move.b	subtype(a0),subtype(a1)
	move.b	render_flags(a0),render_flags(a1)
+
	rts
; ===========================================================================
; off_3BD24:
ObjBD_SubObjData:
	subObjData ObjBD_MapUnc_3BD3E,make_art_tile(ArtTile_ArtNem_WfzBeltPlatform,3,1),4,4,$18,0
; animation script
; off_3BD2E:
Ani_objBD:	offsetTable
		offsetTableEntry.w byte_3BD32	; 0
		offsetTableEntry.w byte_3BD38	; 1
byte_3BD32:	dc.b   3,  2,  1,  0,$FA,  0
byte_3BD38:	dc.b   1,  0,  1,  2,$FA
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBD_MapUnc_3BD3E:	include "mappings/sprite/objBD.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BE - Lateral cannon (temporary platform that pops in/out) from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BD7A:
ObjBE:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBE_Index(pc,d0.w),d1
	jmp	ObjBE_Index(pc,d1.w)
; ===========================================================================
; off_3BD88:
ObjBE_Index:	offsetTable
		offsetTableEntry.w ObjBE_Init	;  0
		offsetTableEntry.w loc_3BDA2	;  2
		offsetTableEntry.w loc_3BDC6	;  4
		offsetTableEntry.w loc_3BDD4	;  6
		offsetTableEntry.w loc_3BDC6	;  8
		offsetTableEntry.w loc_3BDF4	; $A
; ===========================================================================
; loc_3BD94:
ObjBE_Init:
	moveq	#0,d0
	move.b	#($41<<1),d0
	bsr.w	LoadSubObject_Part2
	bra.w	loc_3B77E
; ===========================================================================

loc_3BDA2:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$F0,d0
	cmp.b	subtype(a0),d0
	beq.s	+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine(a0)
	clr.b	anim(a0)
	move.w	#$A0,objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3BDC6:
	lea	(Ani_objBE).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3BDD4:
	subq.w	#1,objoff_2A(a0)
	beq.s	+
	bsr.w	loc_3BE04
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine(a0)
	move.b	#1,anim(a0)
	bsr.w	loc_3B7BC
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3BDF4:
	move.b	#2,routine(a0)
	move.w	#$40,objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3BE04:
	move.b	mapping_frame(a0),d0
	cmpi.b	#3,d0
	beq.s	+
	cmpi.b	#4,d0
	bne.w	loc_3B7BC
+
	move.w	x_pos(a0),-(sp)
	move.w	#$23,d1
	move.w	#$18,d2
	move.w	#$19,d3
	move.w	(sp)+,d4
	jmpto	PlatformObject, JmpTo9_PlatformObject
; ===========================================================================
; off_3BE2C:
ObjBE_SubObjData:
	subObjData ObjBE_MapUnc_3BE46,make_art_tile(ArtTile_ArtNem_WfzGunPlatform,3,1),4,4,$18,0
; animation script
; off_3BE36:
Ani_objBE:	offsetTable
		offsetTableEntry.w byte_3BE3A	; 0
		offsetTableEntry.w byte_3BE40	; 1
byte_3BE3A:	dc.b   5,  0,  1,  2,  3,$FC
byte_3BE40:	dc.b   5,  3,  2,  1,  0,$FC
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBE_MapUnc_3BE46:	include "mappings/sprite/objBE.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BF - Rotaty-stick badnik from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BEAA:
ObjBF:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBF_Index(pc,d0.w),d1
	jmp	ObjBF_Index(pc,d1.w)
; ===========================================================================
; off_3BEB8:
ObjBF_Index:	offsetTable
		offsetTableEntry.w ObjBF_Init		; 0
		offsetTableEntry.w ObjBF_Animate	; 2
; ===========================================================================
; BranchTo9_LoadSubObject
ObjBF_Init:
	bra.w	LoadSubObject
; ===========================================================================
; loc_3BEC0:
ObjBF_Animate:
	lea	(Ani_objBF).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; off_3BECE:
ObjBE_SubObjData2:
	subObjData ObjBF_MapUnc_3BEE0,make_art_tile(ArtTile_ArtNem_WfzUnusedBadnik,3,1),4,4,4,4
; animation script
; off_3BED8:
Ani_objBF:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBF_MapUnc_3BEE0:	include "mappings/sprite/objBF.asm"
; ===========================================================================
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
	btst	#0,status(a0)
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
	jsrto	PlatformObject, JmpTo9_PlatformObject
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
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
	btst	#0,status(a0)
	bne.s	+
	neg.w	x_vel(a0)
	neg.w	objoff_30(a0)
+
	jsrto	ObjectMove, JmpTo26_ObjectMove
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
	bclr	#0,status(a1)
	btst	#0,status(a0)
	bne.s	+
	bset	#0,status(a1)
+
	rts
; ===========================================================================

loc_3BFD8:
	move.w	objoff_30(a0),d0
	add.w	d0,x_vel(a0)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	move.w	objoff_32(a0),d0
	sub.w	x_pos(a0),d0
	btst	#0,status(a0)
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
	bset	#1,status(a1)
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
	subObjData ObjC0_MapUnc_3C098,make_art_tile(ArtTile_ArtNem_WfzLaunchCatapult,1,0),4,4,$10,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC0_MapUnc_3C098:	include "mappings/sprite/objC0.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object C1 - Breakable plating from WFZ
; (and what Sonic hangs onto on the back of Robotnik's getaway ship)
; ----------------------------------------------------------------------------
; Sprite_3C0AC:
ObjC1:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC1_Index(pc,d0.w),d1
	jmp	ObjC1_Index(pc,d1.w)
; ===========================================================================
; off_3C0BA:
ObjC1_Index:	offsetTable
		offsetTableEntry.w ObjC1_Init	; 0
		offsetTableEntry.w ObjC1_Main	; 2
		offsetTableEntry.w ObjC1_Breakup	; 4
; ===========================================================================
; loc_3C0C0:
ObjC1_Init:
	move.w	#($44<<1),d0
	bsr.w	LoadSubObject_Part2
	moveq	#0,d0
	move.b	subtype(a0),d0
	mulu.w	#60,d0
	move.w	d0,objoff_30(a0)

ObjC1_Main:
	tst.b	objoff_32(a0)
	beq.s	loc_3C140
	tst.w	objoff_30(a0)
	beq.s	+
	subq.w	#1,objoff_30(a0)
	beq.s	loc_3C12E
+
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	y_pos(a0),d0
	subi.w	#$18,d0
	btst	#button_up,(Ctrl_1_Held).w
	beq.s	+
	subq.w	#1,y_pos(a1)
	cmp.w	y_pos(a1),d0
	blo.s	+
	move.w	d0,y_pos(a1)
+
	addi.w	#$30,d0
	btst	#button_down,(Ctrl_1_Held).w
	beq.s	+
	addq.w	#1,y_pos(a1)
	cmp.w	y_pos(a1),d0
	bhs.s	+
	move.w	d0,y_pos(a1)
+
	move.b	(Ctrl_1_Press_Logical).w,d0
	andi.w	#button_B_mask|button_C_mask|button_A_mask,d0
	beq.s	BranchTo16_JmpTo39_MarkObjGone

loc_3C12E:
	clr.b	collision_flags(a0)
	clr.b	(MainCharacter+obj_control).w
	clr.b	(WindTunnel_holding_flag).w
	clr.b	objoff_32(a0)
	bra.s	loc_3C19A
; ===========================================================================

loc_3C140:
	tst.b	collision_property(a0)
	beq.s	BranchTo16_JmpTo39_MarkObjGone
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a0),d0
	subi.w	#$14,d0
	cmp.w	x_pos(a1),d0
	bhs.s	BranchTo16_JmpTo39_MarkObjGone
	clr.b	collision_property(a0)
	cmpi.b	#4,routine(a1)
	bhs.s	BranchTo16_JmpTo39_MarkObjGone
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	move.w	x_pos(a0),d0
	subi.w	#$14,d0
	move.w	d0,x_pos(a1)
	bset	#0,status(a1)
	move.b	#AniIDSonAni_Hang,anim(a1)
	move.b	#1,(MainCharacter+obj_control).w
	move.b	#1,(WindTunnel_holding_flag).w
	move.b	#1,objoff_32(a0)

BranchTo16_JmpTo39_MarkObjGone
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3C19A:
	lea	(byte_3C1E4).l,a4
	lea	(byte_3C1E0).l,a2
	bsr.w	loc_3C1F4

ObjC1_Breakup:
	tst.b	objoff_3F(a0)
	beq.s	+
	subq.b	#1,objoff_3F(a0)
	bra.s	++
; ===========================================================================
+
	jsrto	ObjectMove, JmpTo26_ObjectMove
	addi_.w	#8,y_vel(a0)
	lea	(Ani_objC1).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
+
	tst.b	render_flags(a0)
	bpl.w	JmpTo65_DeleteObject
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; animation script
; off_3C1D6:
Ani_objC1:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3,  2,  3,  4,  5,  1,$FF
		even

; unknown
byte_3C1E0:
	dc.b   0
	dc.b   4	; 1
	dc.b $18	; 2
	dc.b $20	; 3
	even
byte_3C1E4:
	dc.w  -$10
	dc.w  -$10	; 2
	dc.w  -$10	; 4
	dc.w   $10	; 6
	dc.w  -$30	; 8
	dc.w  -$10	; 10
	dc.w  -$30	; 12
	dc.w   $10	; 14
; ===========================================================================

loc_3C1F4:
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	move.b	priority(a0),d4
	subq.b	#1,d4
	moveq	#3,d1
	movea.l	a0,a1
	bra.s	loc_3C20E
; ===========================================================================

loc_3C208:
	jsrto	AllocateObjectAfterCurrent, JmpTo25_AllocateObjectAfterCurrent
	bne.s	loc_3C26C

loc_3C20E:
	move.b	#4,routine(a1)
	_move.b	id(a0),id(a1) ; load obj
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#$84,render_flags(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	(a4)+,d0
	add.w	d2,d0
	move.w	d0,x_pos(a1)
	move.w	(a4)+,d0
	add.w	d3,d0
	move.w	d0,y_pos(a1)
	move.b	d4,priority(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#1,mapping_frame(a1)
	move.w	#-$400,x_vel(a1)
	move.w	#0,y_vel(a1)
	move.b	(a2)+,objoff_3F(a1)
	dbf	d1,loc_3C208

loc_3C26C:
	move.w	#SndID_SlowSmash,d0
	jmp	(PlaySound).l
; ===========================================================================
; off_3C276:
ObjC1_SubObjData:
	subObjData ObjC1_MapUnc_3C280,make_art_tile(ArtTile_ArtNem_BreakPanels,3,1),4,4,$40,$E1
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC1_MapUnc_3C280:	include "mappings/sprite/objC1.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object C2 - Rivet thing you bust to get into ship at the end of WFZ
; ----------------------------------------------------------------------------
; Sprite_3C328:
ObjC2:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC2_Index(pc,d0.w),d1
	jmp	ObjC2_Index(pc,d1.w)
; ===========================================================================
; off_3C336:
ObjC2_Index:	offsetTable
		offsetTableEntry.w ObjC2_Init	; 0
		offsetTableEntry.w ObjC2_Main	; 2
; ===========================================================================
; BranchTo10_LoadSubObject
ObjC2_Init:
	bra.w	LoadSubObject
; ===========================================================================
; loc_3C33E:
ObjC2_Main:
	move.b	(MainCharacter+anim).w,objoff_30(a0)
	move.w	x_pos(a0),-(sp)
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jsrto	SolidObject, JmpTo27_SolidObject
	btst	#p1_standing_bit,status(a0)
	bne.s	ObjC2_Bust
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; loc_3C366:
ObjC2_Bust:
	cmpi.b	#2,objoff_30(a0)
	bne.s	+
	move.w	#$2880,(Camera_Min_X_pos).w
	bclr	#p1_standing_bit,status(a0)
	_move.b	#ObjID_Explosion,id(a0) ; load 0bj27 (transform into explosion)
	move.b	#2,routine(a0)
	bset	#1,(MainCharacter+status).w
	bclr	#3,(MainCharacter+status).w
	lea	(Level_Layout+$850).w,a1	; alter the level layout
	move.l	#$8A707172,(a1)+
	move.w	#$7374,(a1)+
	lea	(Level_Layout+$950).w,a1
	move.l	#$6E787978,(a1)+
	move.w	#$787A,(a1)+
	move.b	#1,(Screen_redraw_flag).w
+
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; off_3C3B8:
ObjC2_SubObjData:
	subObjData ObjC2_MapUnc_3C3C2,make_art_tile(ArtTile_ArtNem_WfzSwitch,1,1),4,4,$10,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC2_MapUnc_3C3C2:	include "mappings/sprite/objC2.asm"

Invalid_SubObjData2:

; ===========================================================================
; ----------------------------------------------------------------------------
; Object C3,C4 - Plane's smoke from WFZ
; ----------------------------------------------------------------------------
; Sprite_3C3D6:
ObjC3:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC3_Index(pc,d0.w),d1
	jmp	ObjC3_Index(pc,d1.w)
; ===========================================================================
; off_3C3E4:
ObjC3_Index:	offsetTable
		offsetTableEntry.w ObjC3_Init
		offsetTableEntry.w ObjC3_Main
; ===========================================================================
; loc_3C3E8:
ObjC3_Init:
	bsr.w	LoadSubObject
	move.b	#7,anim_frame_duration(a0)
	jsrto	RandomNumber, JmpTo6_RandomNumber
	move.w	(RNG_seed).w,d0
	andi.w	#$1C,d0
	sub.w	d0,x_pos(a0)
	addi.w	#$10,y_pos(a0)
	move.w	#-$100,y_vel(a0)
	move.w	#-$100,x_vel(a0)
	rts
; ===========================================================================
; loc_3C416:
ObjC3_Main:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#5,mapping_frame(a0)
	beq.w	JmpTo65_DeleteObject
+
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; off_3C438:
ObjC3_SubObjData:
	subObjData Obj27_MapUnc_21120,make_art_tile(ArtTile_ArtNem_Explosion,0,0),4,5,$C,0
; ===========================================================================
; ----------------------------------------------------------------------------
; Object C5 - WFZ boss
; ----------------------------------------------------------------------------
; Sprite_3C442:
ObjC5:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC5_Index(pc,d0.w),d1
	jmp	ObjC5_Index(pc,d1.w)
; ===========================================================================
ObjC5_Index:	offsetTable
		offsetTableEntry.w ObjC5_Init			;   0 - Main loading sequence
		offsetTableEntry.w ObjC5_LaserCase		;   2 - Laser case (inside is laser)
		offsetTableEntry.w ObjC5_LaserWall		;   4 - Laser wall
		offsetTableEntry.w ObjC5_PlatformReleaser	;   6 - Platform releaser
		offsetTableEntry.w ObjC5_Platform		;   8 - Platform
		offsetTableEntry.w ObjC5_PlatformHurt		;  $A - Invisible object that gets the platform's spikes to hurt Sonic
		offsetTableEntry.w ObjC5_LaserShooter		;  $C - Laser shooter
		offsetTableEntry.w ObjC5_Laser			;  $E - Laser
		offsetTableEntry.w ObjC5_Robotnik		; $10 - Robotnik
		offsetTableEntry.w ObjC5_RobotnikPlatform	; $12 - Platform Robotnik's on
; ===========================================================================

ObjC5_Init:
	bsr.w	LoadSubObject
	move.b	subtype(a0),d0
	subi.b	#$90,d0
	move.b	d0,routine(a0)
	rts
; ===========================================================================

ObjC5_LaserCase:	; also the "mother" object
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_CaseIndex(pc,d0.w),d1
	jsr	ObjC5_CaseIndex(pc,d1.w)
	bra.w	ObjC5_HandleHits
; ===========================================================================
ObjC5_CaseIndex:offsetTable
		offsetTableEntry.w ObjC5_CaseBoundary		;   0 - Sets up boundaries for movement and basic things
		offsetTableEntry.w ObjC5_CaseWaitStart		;   2 - Waits for Sonic to start
		offsetTableEntry.w ObjC5_CaseWaitDown		;   4 - Waits to make the laser go down
		offsetTableEntry.w ObjC5_CaseDown		;   6 - Moves the case down
		offsetTableEntry.w ObjC5_CaseXSpeed		;   8 - Sets an X speed for the case
		offsetTableEntry.w ObjC5_CaseBoundaryChk	;  $A - Checks to make sure the case doesn't go through the boundaries
		offsetTableEntry.w ObjC5_CaseAnimate		;  $C - Animates the case (opening and closing)
		offsetTableEntry.w ObjC5_CaseLSLoad		;  $E - Laser shooter loading
		offsetTableEntry.w ObjC5_CaseLSDown		; $10 - Moves the laser shooter down
		offsetTableEntry.w ObjC5_CaseWaitLoadLaser	; $12 - Waits to load the laser
		offsetTableEntry.w ObjC5_CaseWaitMove		; $14 - Waits to move (checks if laser is completely loaded (as big as it gets))
		offsetTableEntry.w ObjC5_CaseBoundaryLaserChk	; $16 - Checks boundaries when moving with the laser
		offsetTableEntry.w ObjC5_CaseLSUp		; $18 - wait for laser shooter to go back up
		offsetTableEntry.w ObjC5_CaseAnimate		; $1A - Animates the case (opening and closing)
		offsetTableEntry.w ObjC5_CaseStartOver		; $1C - Sets secondary routine to 8
		offsetTableEntry.w ObjC5_CaseDefeated		; $1E - When defeated goes here (explosions and stuff)
; ===========================================================================

ObjC5_CaseBoundary:
	addq.b	#2,routine_secondary(a0)
	move.b	#0,collision_flags(a0)
	move.b	#8,collision_property(a0)	; Hit points
	move.w	#$442,d0
	move.w	d0,(Camera_Max_Y_pos).w
	move.w	d0,(Camera_Max_Y_pos_target).w
	move.w	x_pos(a0),d0
	subi.w	#$60,d0			; Max Left position
	move.w	d0,objoff_34(a0)
	addi.w	#$C0,d0			; Max Right Position
	move.w	d0,objoff_36(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseWaitStart:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$20,d2
	cmpi.w	#$40,d2			; How far away Sonic is to start the boss
	blo.s	ObjC5_CaseStart
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseStart:
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,y_vel(a0)		; Speed at which the laser carrier goes down
	lea	(ChildObject_ObjC5LaserWall).l,a2
	bsr.w	LoadChildObject
	subi.w	#$88,x_pos(a1)		; where to load the left laser wall (x)
	addi.w	#$60,y_pos(a1)		; left laser wall (y)
	lea	(ChildObject_ObjC5LaserWall).l,a2
	bsr.w	LoadChildObject
	addi.w	#$88,x_pos(a1)		; right laser wall (x)
	addi.w	#$60,y_pos(a1)		; right laser wall (y)
	lea	(ChildObject_ObjC5LaserShooter).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObject_ObjC5PlatformReleaser).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObject_ObjC5Robotnik).l,a2
	bsr.w	LoadChildObject
	move.w	#$5A,objoff_2A(a0)	; How long for the boss music to start playing and the boss to start
	moveq	#signextendB(MusID_FadeOut),d0
	jsrto	PlaySound, JmpTo12_PlaySound
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseWaitDown:
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjC5_CaseSpeedDown
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseSpeedDown:
	addq.b	#2,routine_secondary(a0)
	move.w	#$60,objoff_2A(a0)	; How long the laser carrier goes down
	moveq	#signextendB(MusID_Boss),d0
	jsrto	PlayMusic, JmpTo5_PlayMusic
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseDown:
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjC5_CaseStopDown
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseStopDown:
	addq.b	#2,routine_secondary(a0)
	clr.w	y_vel(a0)		; stop the laser carrier from going down
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseXSpeed:
	addq.b	#2,routine_secondary(a0)
	bsr.w	Obj_GetOrientationToPlayer
	move.w	#$100,d1		; Speed of carrier (when going back and forth before sending out laser)
	tst.w	d0
	bne.s	ObjC5_CasePMLoader
	neg.w	d1

ObjC5_CasePMLoader:
	move.w	d1,x_vel(a0)
	bset	#2,status(a0)		; makes the platform maker load
	move.w	#$70,objoff_2A(a0)	; how long to go back and forth before letting out laser
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseBoundaryChk:			; waits and makes sure the carrier does not go beyond the limit
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjC5_CaseOpeningAnim
	move.w	x_pos(a0),d0
	tst.w	x_vel(a0)
	bmi.s	ObjC5_CaseBoundaryChk2
	cmp.w	objoff_36(a0),d0
	bhs.s	ObjC5_CaseNegSpeed
	bra.w	ObjC5_CaseMoveDisplay
; ===========================================================================

ObjC5_CaseBoundaryChk2:
	cmp.w	objoff_34(a0),d0
	bhs.s	ObjC5_CaseMoveDisplay

ObjC5_CaseNegSpeed:
	neg.w	x_vel(a0)

ObjC5_CaseMoveDisplay:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseOpeningAnim:
	addq.b	#2,routine_secondary(a0)
	clr.b	anim(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseAnimate:
	lea	(Ani_objC5).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseLSLoad:		; loads up the laser shooter (LS)
	addq.b	#2,routine_secondary(a0)
	move.w	#$E,objoff_2A(a0)	; Time the laser shooter moves down
	movea.w	objoff_3C(a0),a1 ; a1=object (laser shooter)
	move.b	#4,routine_secondary(a1)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseLSDown:
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjC5_CaseAddCollision
	movea.w	objoff_3C(a0),a1 ; a1=object (laser shooter)
	addq.w	#1,y_pos(a1)	; laser shooter down speed
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseAddCollision:
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)	; Length before shooting laser
	bset	#4,status(a0)		; makes the hit sound and flashes happen only once when you hit it
	bset	#6,status(a0)		; makes sure collision gets restored
	move.b	#6,collision_flags(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseWaitLoadLaser:
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjC5_CaseLoadLaser
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseLoadLaser:
	addq.b	#2,routine_secondary(a0)
	lea	(ChildObject_ObjC5Laser).l,a2
	bsr.w	LoadChildObject		; loads laser
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseWaitMove:
	movea.w	parent(a0),a1 ; a1=object
	btst	#2,status(a1)		; waits to check if laser fired
	bne.s	ObjC5_CaseLaserSpeed
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseLaserSpeed:
	addq.b	#2,routine_secondary(a0)
	move.w	#$80,objoff_2A(a0)	; how long to move the laser
	bsr.w	Obj_GetOrientationToPlayer	; tests if Sonic is to the right or left
	move.w	#$80,d1		; Speed when moving with laser
	tst.w	d0
	bne.s	ObjC5_CaseLaserSpeedSet
	neg.w	d1

ObjC5_CaseLaserSpeedSet:
	move.w	d1,x_vel(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseBoundaryLaserChk:		; make sure you stay in range when firing laser
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjC5_CaseStopLaserDelete
	move.w	x_pos(a0),d0
	tst.w	x_vel(a0)
	bmi.s	ObjC5_CaseBoundaryLaserChk2
	cmp.w	objoff_36(a0),d0
	bhs.s	ObjC5_CaseLaserStopMove
	bra.w	ObjC5_CaseLaserMoveDisplay
; ===========================================================================

ObjC5_CaseBoundaryLaserChk2:
	cmp.w	objoff_34(a0),d0
	bhs.s	ObjC5_CaseLaserMoveDisplay

ObjC5_CaseLaserStopMove:
	clr.w	x_vel(a0)	; stop moving

ObjC5_CaseLaserMoveDisplay:
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseStopLaserDelete:		; stops collision and deletes laser
	addq.b	#2,routine_secondary(a0)
	move.w	#$E,objoff_2A(a0)	; time for laser shooter to move back up
	bclr	#3,status(a0)
	bclr	#4,status(a0)
	bclr	#6,status(a0)
	clr.b	collision_flags(a0)	; no more collision
	movea.w	parent(a0),a1 		; a1=object (laser)
	jsrto	DeleteObject2, JmpTo6_DeleteObject2	; delete the laser
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseLSUp:
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjC5_CaseClosingAnim
	movea.w	objoff_3C(a0),a1 ; a1=object (laser shooter)
	subq.w	#1,y_pos(a1)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseClosingAnim: ;sets which animation to do
	addq.b	#2,routine_secondary(a0)
	move.b	#1,anim(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseStartOver:
	move.b	#8,routine_secondary(a0)
	bsr.w	ObjC5_CaseXSpeed
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseDefeated:
	clr.b	collision_flags(a0)
	st.b	collision_property(a0)
	bclr	#6,status(a0)
	subq.w	#1,objoff_30(a0)	; timer
	bmi.s	ObjC5_End
	jsrto	Boss_LoadExplosion, JmpTo_Boss_LoadExplosion
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_End:	; play music and change camera speed
	moveq	#signextendB(MusID_WFZ),d0
	jsrto	PlayMusic, JmpTo5_PlayMusic
	move.w	#$720,d0
	move.w	d0,(Camera_Max_Y_pos).w
	move.w	d0,(Camera_Max_Y_pos_target).w
	bsr.w	JmpTo65_DeleteObject
	addq.w	#4,sp
	rts
; ===========================================================================

ObjC5_LaserWall:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_LaserWallIndex(pc,d0.w),d1
	jsr	ObjC5_LaserWallIndex(pc,d1.w)
	tst.b	(a0)
	beq.w	return_37A48
	move.w	x_pos(a0),-(sp)
	move.w	#$13,d1
	move.w	#$40,d2
	move.w	#$80,d3
	move.w	(sp)+,d4
	jmpto	SolidObject, JmpTo27_SolidObject
; ===========================================================================
ObjC5_LaserWallIndex: offsetTable
	offsetTableEntry.w ObjC5_LaserWallMappings	; 0 - selects the mappings
	offsetTableEntry.w ObjC5_LaserWallWaitDelete	; 2 - Waits till set to delete (when the boss is defeated)
	offsetTableEntry.w ObjC5_LaserWallDelete	; 4 - After a little time it deletes
; ===========================================================================

ObjC5_LaserWallMappings:
	addq.b	#2,routine_secondary(a0)
	move.b	#$C,mapping_frame(a0)	; loads the laser wall from the WFZ boss art
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_LaserWallWaitDelete:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#5,status(a1)
	bne.s	ObjC5_LaserWallTimerSet
	bchg	#0,objoff_2F(a0)	; makes it "flash" if set it won't flash
	bne.w	return_37A48
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_LaserWallTimerSet:	; sets a small timer
	addq.b	#2,routine_secondary(a0)
	move.b	#4,objoff_30(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_LaserWallDelete:
	subq.b	#1,anim_frame_duration(a0)
	bpl.w	return_37A48
	move.b	anim_frame_duration(a0),d0
	move.b	anim_frame(a0),d1
	addq.b	#2,d0
	bpl.s	ObjC5_LaserWallDisplay
	move.b	d1,anim_frame_duration(a0)
	subq.b	#1,objoff_30(a0)
	bpl.s	ObjC5_LaserWallDisplay
	move.b	#$10,objoff_30(a0)
	addq.b	#1,d1
	cmpi.b	#5,d1
	bhs.w	JmpTo65_DeleteObject
	move.b	d1,anim_frame(a0)
	move.b	d1,anim_frame_duration(a0)

ObjC5_LaserWallDisplay:
	bclr	#0,objoff_2F(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaser:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_PlatformReleaserIndex(pc,d0.w),d1
	jmp	ObjC5_PlatformReleaserIndex(pc,d1.w)
; ===========================================================================
ObjC5_PlatformReleaserIndex: offsetTable
	offsetTableEntry.w ObjC5_PlatformReleaserInit		; 0 - Load mappings and position
	offsetTableEntry.w ObjC5_PlatformReleaserWaitDown	; 2 - Waits for laser case to move down
	offsetTableEntry.w ObjC5_PlatformReleaserDown		; 4 - Goes down until time limit is up
	offsetTableEntry.w ObjC5_PlatformReleaserLoadWait	; 6 - Waits to load the platforms (the interval of time between each is from this) and makes sure only 3 are loaded
	offsetTableEntry.w ObjC5_PlatformReleaserDelete		; 8 - Explodes then deletes
; ===========================================================================

ObjC5_PlatformReleaserInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#5,mapping_frame(a0)
	addq.w	#8,y_pos(a0)		; Move down a little
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserWaitDown:
	movea.w	objoff_2C(a0),a1 ; a1=object laser case
	btst	#2,status(a1)		; checks if laser case is done moving down (so it starts loading the platforms)
	bne.s	ObjC5_PlatformReleaserSetDown
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserSetDown:
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)	; time to go down
	move.w	#$40,y_vel(a0)		; speed to go down
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserDown:
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjC5_PlatformReleaserStop
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserStop:
	addq.b	#2,routine_secondary(a0)
	clr.w	y_vel(a0)
	move.w	#$10,objoff_2A(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserLoadWait:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#5,status(a1)
	bne.s	ObjC5_PlatformReleaserDestroyP
	subq.w	#1,objoff_2A(a0)
	bne.s	BranchTo8_JmpTo45_DisplaySprite
	move.w	#$80,objoff_2A(a0)	; Time between loading platforms
	moveq	#0,d0
	move.b	objoff_2E(a0),d0
	addq.b	#1,d0
	cmpi.b	#3,d0			; How many platforms to load
	blo.s	ObjC5_PlatformReleaserLoadP
	moveq	#0,d0

ObjC5_PlatformReleaserLoadP:	; P=Platforms
	move.b	d0,objoff_2E(a0)
	tst.b	objoff_30(a0,d0.w)
	bne.s	BranchTo8_JmpTo45_DisplaySprite
	st.b	objoff_30(a0,d0.w)
	lea	(ChildObject_ObjC5Platform).l,a2
	bsr.w	LoadChildObject
	move.b	objoff_2E(a0),objoff_2E(a1)

BranchTo8_JmpTo45_DisplaySprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserDestroyP: 	; P=Platforms
	addq.b	#2,routine_secondary(a0)
	bset	#5,status(a0)		; destroy platforms
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserDelete:
	movea.w	objoff_2C(a0),a1 ; a1=object
	cmpi.b	#ObjID_WFZBoss,id(a1)
	bne.w	JmpTo65_DeleteObject
	jsrto	Boss_LoadExplosion, JmpTo_Boss_LoadExplosion
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_Platform:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_PlatformIndex(pc,d0.w),d1
	jsr	ObjC5_PlatformIndex(pc,d1.w)
	lea	(Ani_objC5).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	tst.b	(a0)
	beq.w	return_37A48
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
ObjC5_PlatformIndex: offsetTable
	offsetTableEntry.w ObjC5_PlatformInit			; 0 - Selects mappings, anim ation, y speed and loads the object that hurts Sonic (by spiky area)
	offsetTableEntry.w ObjC5_PlatformDownWait		; 2 - Wait till the platform goes down some
	offsetTableEntry.w ObjC5_PlatformTestChangeDirection	; 4 - checks if time limit is over and if so to change direction
; ===========================================================================

ObjC5_PlatformInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#3,anim(a0)
	move.b	#7,mapping_frame(a0)
	move.w	#$100,y_vel(a0)			; Y speed
	move.w	#$60,objoff_2A(a0)
	lea	(ChildObject_ObjC5PlatformHurt).l,a2	; loads the invisible object that hurts Sonic
	bra.w	LoadChildObject
; ===========================================================================

ObjC5_PlatformDownWait:		; waits for it to go down some
	bsr.w	ObjC5_PlatformCheckExplode
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjC5_PlatformLeft
	bra.w	ObjC5_PlatformMakeSolid
; ===========================================================================

ObjC5_PlatformLeft:			; goes left and makes a time limit (for going left)
	addq.b	#2,routine_secondary(a0)
	move.w	#$60,objoff_2A(a0)
	move.w	#-$100,x_vel(a0)		; X speed
	move.w	y_pos(a0),objoff_34(a0)
	bra.w	ObjC5_PlatformMakeSolid
; ===========================================================================

ObjC5_PlatformTestChangeDirection:
	bsr.w	ObjC5_PlatformCheckExplode
	subq.w	#1,objoff_2A(a0)
	bne.s	ObjC5_PlatformTestLeftRight
	move.w	#$C0,objoff_2A(a0)
	neg.w	x_vel(a0)

ObjC5_PlatformTestLeftRight:	; tests to see if a value should be added to go left or right
	moveq	#4,d0
	move.w	y_pos(a0),d1
	cmp.w	objoff_34(a0),d1
	blo.s	ObjC5_PlatformChangeY
	neg.w	d0

ObjC5_PlatformChangeY:	; give it that curving feel
	add.w	d0,y_vel(a0)
	bra.w	ObjC5_PlatformMakeSolid

ObjC5_PlatformMakeSolid:	; makes into a platform and moves
	move.w	x_pos(a0),-(sp)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	move.w	#$10,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	(sp)+,d4
	jmpto	PlatformObject, JmpTo9_PlatformObject
; ===========================================================================

ObjC5_PlatformCheckExplode:	; checks to see if platforms should explode
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#5,status(a1)
	bne.w	ObjC5_PlatformExplode
	rts
; ===========================================================================

ObjC5_PlatformExplode:
	bsr.w	loc_3B7BC
	move.b	#ObjID_BossExplosion,id(a0) ; load 0bj58 (explosion)
	clr.b	routine(a0)
	movea.w	objoff_3C(a0),a1 ; a1=object (invisible hurting thing)
	jsrto	DeleteObject2, JmpTo6_DeleteObject2
	addq.w	#4,sp
	rts
; ===========================================================================

ObjC5_PlatformHurt:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_PlatformHurtIndex(pc,d0.w),d1
	jmp	ObjC5_PlatformHurtIndex(pc,d1.w)
; ===========================================================================
ObjC5_PlatformHurtIndex: offsetTable
	offsetTableEntry.w ObjC5_PlatformHurtCollision		; 0 - Gives collision that hurts Sonic
	offsetTableEntry.w ObjC5_PlatformHurtFollowPlatform	; 2 - Follows around the platform and waits to be deleted
; ===========================================================================

ObjC5_PlatformHurtCollision:
	addq.b	#2,routine_secondary(a0)
	move.b	#$98,collision_flags(a0)
	rts
; ===========================================================================

ObjC5_PlatformHurtFollowPlatform:
	movea.w	objoff_2C(a0),a1 ; a1=object (platform)
	btst	#5,status(a1)
	bne.w	JmpTo65_DeleteObject
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),d0
	addi.w	#$C,d0
	move.w	d0,y_pos(a0)
	rts
; ===========================================================================

ObjC5_LaserShooter:
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	btst	#5,status(a1)
	bne.w	JmpTo65_DeleteObject
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_LaserShooterIndex(pc,d0.w),d1
	jmp	ObjC5_LaserShooterIndex(pc,d1.w)
; ===========================================================================
ObjC5_LaserShooterIndex: offsetTable
	offsetTableEntry.w ObjC5_LaserShooterInit	; 0 - Loads up mappings
	offsetTableEntry.w ObjC5_LaserShooterFollow	; 2 - Goes back and forth with the laser case
	offsetTableEntry.w ObjC5_LaserShooterDown	; 4 - Laser case sets it to this routine which then makes it go down
; ===========================================================================

ObjC5_LaserShooterInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#4,mapping_frame(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_LaserShooterFollow:
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_LaserShooterDown:
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	move.w	x_pos(a1),x_pos(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_Laser:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#5,status(a1)
	bne.w	JmpTo65_DeleteObject
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_LaserIndex(pc,d0.w),d1
	jsr	ObjC5_LaserIndex(pc,d1.w)
	bchg	#0,objoff_2F(a0)
	bne.w	return_37A48
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
ObjC5_LaserIndex: offsetTable
	offsetTableEntry.w ObjC5_LaserInit	; 0 - Loads mappings and collision and such
	offsetTableEntry.w ObjC5_LaserFlash	; 2 - Makes the laser flash (gives the charging up effect)
	offsetTableEntry.w ObjC5_LaseWaitShoot	; 4 - Waits a little to launch the laser when it's done flickering (charging)
	offsetTableEntry.w ObjC5_LaserShoot	; 6 - Shoots down the laser untill it's fully shot out
	offsetTableEntry.w ObjC5_LaserMove	; 8 - Moves with laser case and shooter
; ===========================================================================

ObjC5_LaserInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#$D,mapping_frame(a0)
	move.b	#4,priority(a0)
	move.b	#0,collision_flags(a0)
	addi.w	#$10,y_pos(a0)
	move.b	#$C,anim_frame(a0)
	subq.w	#3,y_pos(a0)
	rts
; ===========================================================================

ObjC5_LaserFlash:
	bset	#0,objoff_2F(a0)
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	ObjC5_LaserNoLaser
	move.b	anim_frame_duration(a0),d0
	addq.b	#2,d0
	bpl.s	ObjC5_LaserFlicker
	move.b	anim_frame(a0),d0
	subq.b	#1,d0
	beq.s	ObjC5_LaseNext
	move.b	d0,anim_frame(a0)
	move.b	d0,anim_frame_duration(a0)

ObjC5_LaserFlicker:	; this is what makes the laser flicker before being fully loaded (covering laser shooter)
	bclr	#0,objoff_2F(a0)

ObjC5_LaserNoLaser: ; without this the laser would just stay on the shooter not going down
	rts
; ===========================================================================

ObjC5_LaseNext:		; just sets up a time to wait for the laser to shoot when it's loaded and done flickering
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)
	rts
; ===========================================================================

ObjC5_LaseWaitShoot:
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjC5_LaseStartShooting
	rts
; ===========================================================================

ObjC5_LaseStartShooting:
	addq.b	#2,routine_secondary(a0)
	addi.w	#$10,y_pos(a0)
	rts
; ===========================================================================

ObjC5_LaserShoot:
	moveq	#0,d0
	move.b	objoff_2E(a0),d0
	addq.b	#1,d0
	cmpi.b	#5,d0
	bhs.s	ObjC5_LaseShotOut
	addi.w	#$10,y_pos(a0)
	move.b	d0,objoff_2E(a0)
	move.b	ObjC5_LaserMappingsData(pc,d0.w),mapping_frame(a0)
	move.b	ObjC5_LaserCollisionData(pc,d0.w),collision_flags(a0)
	rts
; ===========================================================================

ObjC5_LaseShotOut:	; laser is fully shot out and lets the laser case know so it moves
	addq.b	#2,routine_secondary(a0)
	move.w	#$80,objoff_2A(a0)
	bset	#2,status(a0)
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	bset	#3,status(a1)
	rts
; ===========================================================================
ObjC5_LaserMappingsData:
	dc.b  $E
	dc.b  $F	; 1
	dc.b $10	; 2
	dc.b $11	; 3
	dc.b $12	; 4
	dc.b   0	; 5
ObjC5_LaserCollisionData:
	dc.b $86
	dc.b $AB	; 1
	dc.b $AC	; 2
	dc.b $AD	; 3
	dc.b $AE	; 4
	dc.b   0	; 5
	even
; ===========================================================================

ObjC5_LaserMove:
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	rts
; ===========================================================================

ObjC5_Robotnik:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_RobotnikIndex(pc,d0.w),d1
	jmp	ObjC5_RobotnikIndex(pc,d1.w)
; ===========================================================================
ObjC5_RobotnikIndex: offsetTable
	offsetTableEntry.w ObjC5_RobotnikInit		; 0 - Loads art, animation and position
	offsetTableEntry.w ObjC5_RobotnikAnimate	; 2 - Animates Robotnik and waits till the case is defeated
	offsetTableEntry.w ObjC5_RobotnikDown		; 4 - Goes down until timer is up
; ===========================================================================

ObjC5_RobotnikInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#0,mapping_frame(a0)
	move.b	#1,anim(a0)
	move.w	#$2C60,x_pos(a0)
	move.w	#$4E6,y_pos(a0)
	lea	(ChildObject_ObjC5RobotnikPlatform).l,a2
	bsr.w	LoadChildObject
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_RobotnikAnimate:
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	btst	#5,status(a1)
	bne.s	ObjC5_RobotnikTimer
	lea	(Ani_objC5_objC6).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_RobotnikTimer:		; Increase routine and set timer
	addq.b	#2,routine_secondary(a0)
	move.w	#$C0,objoff_2A(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_RobotnikDown:
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjC5_RobotnikDelete
	addq.w	#1,y_pos(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_RobotnikDelete:		; Deletes Robotnik and the platform he's on
	movea.w	parent(a0),a1 ; a1=object (Robotnik Platform)
	jsrto	DeleteObject2, JmpTo6_DeleteObject2
	bra.w	JmpTo65_DeleteObject
; ===========================================================================

ObjC5_RobotnikPlatform:	; Just displays the platform and move accordingly to the Robotnik object
	movea.w	objoff_2C(a0),a1 ; a1=object (Robotnik)
	move.w	y_pos(a1),d0
	addi.w	#$26,d0
	move.w	d0,y_pos(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
	; some unused/dead code, At one point it appears a section of the platform was solid
	move.w	x_pos(a0),-(sp)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	move.w	#$F,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	(sp)+,d4
	jmpto	PlatformObject, JmpTo9_PlatformObject
; ===========================================================================

ObjC5_HandleHits:
	tst.b	collision_property(a0)
	beq.s	ObjC5_NoHitPointsLeft
	tst.b	collision_flags(a0)
	bne.s	return_3CC3A
	tst.b	objoff_30(a0)
	bne.s	ObjC5_FlashSetUp
	btst	#6,status(a0)
	beq.s	return_3CC3A
	move.b	#$20,objoff_30(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l

ObjC5_FlashSetUp:
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	ObjC5_FlashCollisionRestore
	move.w	#$EEE,d0

ObjC5_FlashCollisionRestore:
	move.w	d0,(a1)
	subq.b	#1,objoff_30(a0)
	bne.s	return_3CC3A
	btst	#4,status(a0)	; makes sure the boss doesn't need collision
	beq.s	return_3CC3A
	move.b	#6,collision_flags(a0)	; restore collision

return_3CC3A:
	rts
; ===========================================================================

ObjC5_NoHitPointsLeft:	; when the boss is defeated this tells it what to do
	moveq	#100,d0
	bsr.w	AddPoints
	clr.b	collision_flags(a0)
	move.w	#$EF,objoff_30(a0)
	move.b	#$1E,routine_secondary(a0)
	bset	#5,status(a0)
	bclr	#6,status(a0)
	rts
; ===========================================================================
ChildObject_ObjC5LaserWall:		childObjectData objoff_2A, ObjID_WFZBoss, $94
ChildObject_ObjC5Platform:		childObjectData objoff_3E, ObjID_WFZBoss, $98
ChildObject_ObjC5PlatformHurt:		childObjectData objoff_3C, ObjID_WFZBoss, $9A
ChildObject_ObjC5LaserShooter:		childObjectData objoff_3C, ObjID_WFZBoss, $9C
ChildObject_ObjC5PlatformReleaser:	childObjectData objoff_3A, ObjID_WFZBoss, $96
ChildObject_ObjC5Laser:			childObjectData objoff_3E, ObjID_WFZBoss, $9E
ChildObject_ObjC5Robotnik:		childObjectData objoff_38, ObjID_WFZBoss, $A0
ChildObject_ObjC5RobotnikPlatform:	childObjectData objoff_3E, ObjID_WFZBoss, $A2

; off_3CC80:
ObjC5_SubObjData:		; Laser Case
	subObjData ObjC5_MapUnc_3CCD8,make_art_tile(ArtTile_ArtNem_WFZBoss,0,0),4,4,$20,0
; off_3CC8A:
ObjC5_SubObjData2:		; Laser Walls
	subObjData ObjC5_MapUnc_3CCD8,make_art_tile(ArtTile_ArtNem_WFZBoss,0,0),4,1,8,0
; off_3CC94:
ObjC5_SubObjData3:		; Platforms, platform releaser, laser and laser shooter
	subObjData ObjC5_MapUnc_3CCD8,make_art_tile(ArtTile_ArtNem_WFZBoss,0,0),4,5,$10,0
; off_3CC9E:
ObjC6_SubObjData2:		; Robotnik
	subObjData ObjC6_MapUnc_3D0EE,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),4,5,$20,0
; off_3CCA8:
ObjC5_SubObjData4:		; Robotnik platform
	subObjData ObjC5_MapUnc_3CEBC,make_art_tile(ArtTile_ArtNem_WfzFloatingPlatform,1,1),4,5,$20,0

; animation script
; off_3CCB2:
Ani_objC5:	offsetTable
		offsetTableEntry.w byte_3CCBA	; 0
		offsetTableEntry.w byte_3CCC4	; 1
		offsetTableEntry.w byte_3CCCC	; 2
		offsetTableEntry.w byte_3CCD0	; 3
byte_3CCBA:	dc.b   5,  0,  1,  2,  3,  3,  3,  3,$FA,  0
byte_3CCC4:	dc.b   3,  3,  2,  1,  0,  0,$FA,  0
byte_3CCCC:	dc.b   3,  5,  6,$FF
byte_3CCD0:	dc.b   3,  7,  8,  9, $A, $B,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC5_MapUnc_3CCD8:	include "mappings/sprite/objC5_a.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC5_MapUnc_3CEBC:	include "mappings/sprite/objC5_b.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object C6 - Eggman
; ----------------------------------------------------------------------------
; Sprite_3CED0:
ObjC6:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC6_Index(pc,d0.w),d1
	jmp	ObjC6_Index(pc,d1.w)
; ===========================================================================
; off_3CEDE: ObjC6_States:
ObjC6_Index:	offsetTable
		offsetTableEntry.w ObjC6_Init	; 0
		offsetTableEntry.w ObjC6_State2	; 2
		offsetTableEntry.w ObjC6_State3	; 4
		offsetTableEntry.w ObjC6_State4	; 6
; ===========================================================================
; loc_3CEE6:
ObjC6_Init:
	bsr.w	LoadSubObject
	move.b	subtype(a0),d0
	subi.b	#$A4,d0
	move.b	d0,routine(a0) ; => ObjC6_State2, ObjC6_State3, or ObjC6_State4??
	rts
; ===========================================================================
; loc_3CEF8:
ObjC6_State2:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC6_State2_States(pc,d0.w),d1
	jmp	ObjC6_State2_States(pc,d1.w)
; ===========================================================================
; off_3CF06:
ObjC6_State2_States: offsetTable
	offsetTableEntry.w ObjC6_State2_State1	; 0
	offsetTableEntry.w ObjC6_State2_State2	; 2
	offsetTableEntry.w ObjC6_State2_State3	; 4
	offsetTableEntry.w ObjC6_State2_State4	; 6
	offsetTableEntry.w ObjC6_State2_State5	; 8
; ===========================================================================
; loc_3CF10:
ObjC6_State2_State1: ; a1=object (set in loc_3D94C)
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State2_State2
	lea	(ChildObject_3D0D0).l,a2
	bsr.w	LoadChildObject
	move.w	#$3F8,x_pos(a1)
	move.w	#$160,y_pos(a1)
	move.w	a0,(DEZ_Eggman).w
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CF32:
ObjC6_State2_State2:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$5C,d2
	cmpi.w	#$B8,d2
	blo.s	loc_3CF44
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
loc_3CF44:
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State2_State3
	move.w	#$18,objoff_2A(a0)
	move.b	#1,mapping_frame(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CF58:
ObjC6_State2_State3:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3CF62
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
loc_3CF62:
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State2_State4
	bset	#2,status(a0)
	move.w	#$200,x_vel(a0)
	move.w	#$10,objoff_2A(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CF7C:
ObjC6_State2_State4:
	cmpi.w	#$810,x_pos(a0)
	bhs.s	loc_3CFC0
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$50,d2
	cmpi.w	#$A0,d2
	bhs.s	+
	move.w	x_pos(a1),d0
	addi.w	#$50,d0
	move.w	d0,x_pos(a0)
+
	subq.w	#1,objoff_2A(a0)
	bpl.s	+
	move.w	#$20,objoff_2A(a0)
	bsr.w	loc_3D00C
+
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(Ani_objC5_objC6).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3CFC0:
	move.b	#2,mapping_frame(a0)
	clr.w	x_vel(a0)
	tst.b	render_flags(a0)
	bpl.s	+
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State2_State5
	move.w	#$80,x_vel(a0)
	move.w	#-$200,y_vel(a0)
	move.b	#2,mapping_frame(a0)
	move.w	#$50,objoff_2A(a0)
	bset	#3,status(a0)
+
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CFF6:
ObjC6_State2_State5:
	subq.w	#1,objoff_2A(a0)
	bmi.w	JmpTo65_DeleteObject
	addi.w	#$10,y_vel(a0)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3D00C:
	lea	(ChildObject_3D0D4).l,a2
	bsr.w	LoadChildObject
	move.b	#$AA,subtype(a1) ; <== ObjC6_SubObjData
	move.b	#5,mapping_frame(a1)
	move.w	#-$100,x_vel(a1)
	subi.w	#$18,y_pos(a1)
	move.w	#8,objoff_2A(a1)
	rts
; ===========================================================================
; loc_3D036:
ObjC6_State3:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC6_State3_States(pc,d0.w),d1
	jmp	ObjC6_State3_States(pc,d1.w)
; ===========================================================================
; off_3D044:
ObjC6_State3_States: offsetTable
	offsetTableEntry.w ObjC6_State3_State1	; 0
	offsetTableEntry.w ObjC6_State3_State2	; 2
	offsetTableEntry.w ObjC6_State3_State3	; 4
; ===========================================================================
; loc_3D04A:
ObjC6_State3_State1:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#2,status(a1)
	bne.s	loc_3D05E
	bsr.w	loc_3D086
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
loc_3D05E:
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State3_State2
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3D066:
ObjC6_State3_State2:
	bsr.w	loc_3D086
	lea	(Ani_objC6).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3D078:
ObjC6_State3_State3:
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#5,status(a1)
	bra.w	JmpTo65_DeleteObject
; ===========================================================================

loc_3D086:
	move.w	x_pos(a0),-(sp)
	move.w	#$13,d1
	move.w	#$20,d2
	move.w	#$20,d3
	move.w	(sp)+,d4
	jmpto	SolidObject, JmpTo27_SolidObject
; ===========================================================================
; loc_3D09C:
ObjC6_State4:
	subq.w	#1,objoff_2A(a0)
	bmi.w	JmpTo65_DeleteObject
	addi.w	#$10,y_vel(a0)
	jsrto	ObjectMove, JmpTo26_ObjectMove
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
; off_3D0B2:
ObjC6_SubObjData3:
	subObjData ObjC6_MapUnc_3D0EE,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),4,5,$18,0
; off_3D0BC:
ObjC6_SubObjData4:
	subObjData ObjC6_MapUnc_3D1DE,make_art_tile(ArtTile_ArtNem_ConstructionStripes_1,1,0),4,1,8,0
; off_3D0C6:
ObjC6_SubObjData:
	subObjData ObjC6_MapUnc_3D0EE,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),4,5,4,0
ChildObject_3D0D0:	childObjectData objoff_3E, ObjID_Eggman, $A8
ChildObject_3D0D4:	childObjectData objoff_3C, ObjID_Eggman, $AA
; animation script
; off_3D0D8:
Ani_objC5_objC6:offsetTable
		offsetTableEntry.w byte_3D0DC	; 0
		offsetTableEntry.w byte_3D0E2	; 1
byte_3D0DC:	dc.b   5,  2,  3,  4,$FF,  0
byte_3D0E2:	dc.b   5,  6,  7,$FF
		even
; animation script
; off_3D0E6:
Ani_objC6:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,  3,$FA
		even
; ----------------------------------------------------------------------------
; sprite mappings ; Robotnik running
; ----------------------------------------------------------------------------
ObjC6_MapUnc_3D0EE:	include "mappings/sprite/objC6_a.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC6_MapUnc_3D1DE:	include "mappings/sprite/objC6_b.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object C8 - Crawl (shield badnik) from CNZ
; ----------------------------------------------------------------------------
; Sprite_3D23E:
ObjC8:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC8_Index(pc,d0.w),d1
	jmp	ObjC8_Index(pc,d1.w)
; ===========================================================================
; off_3D24C:
ObjC8_Index:	offsetTable
		offsetTableEntry.w ObjC8_Init	; 0
		offsetTableEntry.w loc_3D27C	; 2
		offsetTableEntry.w loc_3D2A6	; 4
		offsetTableEntry.w loc_3D2D4	; 6
; ===========================================================================
; loc_3D254:
ObjC8_Init:
	bsr.w	LoadSubObject
	move.w	#$200,objoff_2A(a0)
	moveq	#$20,d0
	btst	#0,render_flags(a0)
	bne.s	+
	neg.w	d0
+
	move.w	d0,x_vel(a0)
	move.b	#$F,y_radius(a0)
	move.b	#$10,x_radius(a0)
	rts
; ===========================================================================

loc_3D27C:
	subq.w	#1,objoff_2A(a0)
	beq.s	+
	jsrto	ObjectMove, JmpTo26_ObjectMove
	bsr.w	loc_3D416
	lea	(Ani_objC8).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	#$3B,objoff_2A(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3D2A6:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	bsr.w	loc_3D416
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================
+
	move.b	#2,routine(a0)
	move.w	#$200,objoff_2A(a0)
	neg.w	x_vel(a0)
	bchg	#0,render_flags(a0)
	bchg	#0,status(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3D2D4:
	move.b	#$D7,collision_flags(a0)
	bsr.w	Obj_GetOrientationToPlayer
	move.w	d2,d4
	addi.w	#$40,d2
	cmpi.w	#$80,d2
	bhs.w	loc_3D39A
	addi.w	#$40,d3
	cmpi.w	#$80,d3
	bhs.w	loc_3D39A
	bclr	#3,status(a0)
	bne.w	loc_3D386
	move.b	collision_property(a0),d0
	beq.s	BranchTo18_JmpTo39_MarkObjGone
	bclr	#0,collision_property(a0)
	beq.s	+++
	cmpi.b	#AniIDSonAni_Roll,anim(a1)
	bne.s	loc_3D36C
	btst	#1,status(a1)
	bne.s	++
	bsr.w	Obj_GetOrientationToPlayer
	btst	#0,render_flags(a0)
	beq.s	+
	subq.w	#2,d0
+
	tst.w	d0
	bne.s	loc_3D390
+
	bsr.s	loc_3D3A4
+
	lea	(Sidekick).w,a1 ; a1=character
	bclr	#1,collision_property(a0)
	beq.s	+++
	cmpi.b	#AniIDSonAni_Roll,anim(a1)
	bne.s	loc_3D36C
	btst	#1,status(a1)
	bne.s	++
	bsr.w	Obj_GetOrientationToPlayer
	btst	#0,render_flags(a0)
	beq.s	+
	subq.w	#2,d0
+
	tst.w	d0
	bne.s	loc_3D390
+
	bsr.s	loc_3D3A4
+
	clr.b	collision_property(a0)

BranchTo18_JmpTo39_MarkObjGone
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3D36C:
	move.b	#$97,collision_flags(a0)
	btst	#status_sec_isInvincible,status_secondary(a1)
	beq.s	+
	move.b	#$17,collision_flags(a0)
+
	bset	#3,status(a0)

loc_3D386:
	move.b	#1,mapping_frame(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3D390:
	move.b	#$17,collision_flags(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3D39A:
	move.b	objoff_2C(a0),routine(a0)
	jmpto	MarkObjGone, JmpTo39_MarkObjGone
; ===========================================================================

loc_3D3A4:
	move.b	#2,mapping_frame(a0)
	btst	#1,status(a1)
	beq.s	+
	move.b	#3,mapping_frame(a0)
+
	move.w	x_pos(a0),d1
	move.w	y_pos(a0),d2
	sub.w	x_pos(a1),d1
	sub.w	y_pos(a1),d2
	jsr	(CalcAngle).l
	move.b	(Timer_frames).w,d1
	andi.w	#3,d1
	add.w	d1,d0
	jsr	(CalcSine).l
	muls.w	#-$700,d1
	asr.l	#8,d1
	move.w	d1,x_vel(a1)
	muls.w	#-$700,d0
	asr.l	#8,d0
	move.w	d0,y_vel(a1)
	bset	#1,status(a1)
	bclr	#4,status(a1)
	bclr	#5,status(a1)
	clr.b	jumping(a1)
	move.w	#SndID_Bumper,d0
	jsr	(PlaySound).l
	rts
; ===========================================================================
	; unused
	rts
; ===========================================================================

loc_3D416:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$40,d2
	cmpi.w	#$80,d2
	bhs.s	+	; rts
	addi.w	#$40,d3
	cmpi.w	#$80,d3
	bhs.s	+	; rts
	move.b	routine(a0),objoff_2C(a0)
	move.b	#6,routine(a0)
	clr.b	mapping_frame(a0)
+
	rts
; ===========================================================================
; off_3D440:
ObjC8_SubObjData:
	subObjData ObjC8_MapUnc_3D450,make_art_tile(ArtTile_ArtNem_Crawl,0,1),4,3,$10,$D7
; animation script
; off_3D44A:
Ani_objC8:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b $13,  0,  1,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings ; Crawl CNZ
; ----------------------------------------------------------------------------
ObjC8_MapUnc_3D450:	include "mappings/sprite/objC8.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object C7 - Eggrobo (final boss) from Death Egg
; ----------------------------------------------------------------------------
; Sprite_3D4C8:
ObjC7:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC7_Index(pc,d0.w),d1
	jmp	ObjC7_Index(pc,d1.w)
; ===========================================================================
; off_3D4D6:
ObjC7_Index:	offsetTable
		offsetTableEntry.w ObjC7_Init	;   0
		offsetTableEntry.w ObjC7_Body	;   2
		offsetTableEntry.w ObjC7_Shoulder	;   4
		offsetTableEntry.w ObjC7_FrontLowerLeg	;   6
		offsetTableEntry.w ObjC7_FrontForearm	;   8
		offsetTableEntry.w ObjC7_Arm	;  $A
		offsetTableEntry.w ObjC7_FrontThigh	;  $C
		offsetTableEntry.w ObjC7_Head	;  $E
		offsetTableEntry.w ObjC7_Jet	; $10
		offsetTableEntry.w ObjC7_BackLowerLeg	; $12
		offsetTableEntry.w ObjC7_BackForearm	; $14
		offsetTableEntry.w ObjC7_BackThigh	; $16
		offsetTableEntry.w ObjC7_TargettingSensor	; $18
		offsetTableEntry.w ObjC7_TargettingLock	; $1A
		offsetTableEntry.w ObjC7_EggmanBomb	; $1C
		offsetTableEntry.w ObjC7_FallingPieces	; $1E
		offsetTableEntry.w ObjC7_SetupEnding	; $20
; ===========================================================================
; loc_3D4F8:
ObjC7_Init:
	lea	ObjC7_SubObjData(pc),a1
	bsr.w	LoadSubObject_Part3
	move.b	subtype(a0),routine(a0)
	rts
; ===========================================================================
;loc_3D508
ObjC7_Body:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3D51A(pc,d0.w),d1
	jsr	off_3D51A(pc,d1.w)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
off_3D51A:	offsetTable
		offsetTableEntry.w loc_3D52A	;  0
		offsetTableEntry.w loc_3D5A8	;  2
		offsetTableEntry.w loc_3D5C2	;  4
		offsetTableEntry.w loc_3D5EA	;  6
		offsetTableEntry.w loc_3D62E	;  8
		offsetTableEntry.w loc_3D640	; $A
		offsetTableEntry.w loc_3D684	; $C
		offsetTableEntry.w loc_3D8D2	; $E
; ===========================================================================

loc_3D52A:
	addq.b	#2,routine_secondary(a0)
	move.b	#3,mapping_frame(a0)
	move.b	#5,priority(a0)
	lea	(ChildObjC7_Shoulder).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_FrontForearm).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_FrontLowerLeg).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_Arm).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_FrontThigh).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_Head).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_Jet).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_BackLowerLeg).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_BackForearm).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_BackThigh).l,a2
	bsr.w	LoadChildObject
	lea	(ObjC7_ChildDeltas).l,a1
	bra.w	ObjC7_PositionChildren
; ===========================================================================

loc_3D5A8:
	btst	#2,status(a0)
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.b	#60,anim_frame_duration(a0)
	moveq	#signextendB(MusID_FadeOut),d0
	jmpto	PlaySound, JmpTo12_PlaySound
; ===========================================================================

loc_3D5C2:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.b	#$79,anim_frame_duration(a0)
	move.w	#-$100,y_vel(a0)
	movea.w	objoff_38(a0),a1 ; a1=object
	move.b	#4,routine_secondary(a1)
	moveq	#signextendB(MusID_EndBoss),d0
	jmpto	PlayMusic, JmpTo5_PlayMusic
; ===========================================================================

loc_3D5EA:
	subq.b	#1,anim_frame_duration(a0)
	beq.s	+
	moveq	#signextendB(SndID_Rumbling),d0
	jsrto	PlaySound, JmpTo12_PlaySound
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(ObjC7_ChildDeltas).l,a1
	bra.w	ObjC7_PositionChildren
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	clr.w	y_vel(a0)
	move.b	#$1F,anim_frame_duration(a0)
	move.b	#$16,collision_flags(a0)
	move.b	#$C,collision_property(a0)
	bsr.w	ObjC7_InitCollision
	movea.w	objoff_38(a0),a1 ; a1=object
	move.b	#6,routine_secondary(a1)
	rts
; ===========================================================================

loc_3D62E:
	bsr.w	ObjC7_CheckHit
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	rts
; ===========================================================================

loc_3D640:
	bsr.w	ObjC7_CheckHit
	addq.b	#2,routine_secondary(a0)
	move.b	#$20,anim_frame_duration(a0)
	move.b	angle(a0),d0
	addq.b	#1,d0
	move.b	d0,angle(a0)
	andi.w	#3,d0
	move.b	byte_3D680(pc,d0.w),d0
	move.b	d0,anim(a0)
	clr.b	prev_anim(a0)
	cmpi.b	#2,d0
	bne.s	+	; rts
	movea.w	objoff_38(a0),a1 ; a1=object
	move.b	#4,routine_secondary(a1)
	move.b	#2,anim(a1)
+
	rts
; ===========================================================================
byte_3D680:
	dc.b   2
	dc.b   0	; 1
	dc.b   2	; 2
	dc.b   4	; 3
	even
; ===========================================================================

loc_3D684:
	bsr.w	ObjC7_CheckHit
	moveq	#0,d0
	move.b	anim(a0),d0
	move.w	off_3D696(pc,d0.w),d1
	jmp	off_3D696(pc,d1.w)
; ===========================================================================
off_3D696:	offsetTable
		offsetTableEntry.w loc_3D6AA	; 0
		offsetTableEntry.w loc_3D702	; 2
		offsetTableEntry.w loc_3D83C	; 4
; ===========================================================================
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,anim(a0)
	rts
; ===========================================================================

loc_3D6AA:
	moveq	#0,d0
	move.b	prev_anim(a0),d0
	move.w	off_3D6B8(pc,d0.w),d1
	jmp	off_3D6B8(pc,d1.w)
; ===========================================================================
off_3D6B8:	offsetTable
		offsetTableEntry.w loc_3D6C0	; 0
		offsetTableEntry.w loc_3D6CE	; 2
		offsetTableEntry.w loc_3D6C0	; 4
		offsetTableEntry.w loc_3D6E8	; 6
; ===========================================================================

loc_3D6C0:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	rts
; ===========================================================================

loc_3D6CE:
	lea	(off_3E40C).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	move.b	#$40,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D6E8:
	lea	(off_3E42C).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	subq.b	#2,routine_secondary(a0)
	move.b	#$40,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D702:
	moveq	#0,d0
	move.b	prev_anim(a0),d0
	move.w	off_3D710(pc,d0.w),d1
	jmp	off_3D710(pc,d1.w)
; ===========================================================================
off_3D710:	offsetTable
		offsetTableEntry.w loc_3D6C0	;  0
		offsetTableEntry.w loc_3D720	;  2
		offsetTableEntry.w loc_3D744	;  4
		offsetTableEntry.w loc_3D6C0	;  6
		offsetTableEntry.w loc_3D784	;  8
		offsetTableEntry.w loc_3D7B8	; $A
		offsetTableEntry.w loc_3D7F0	; $C
		offsetTableEntry.w loc_3D82E	; $C
; ===========================================================================

loc_3D720:
	lea	(off_3E3D0).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	move.b	#$80,anim_frame_duration(a0)
	clr.w	x_vel(a0)
	move.w	#-$200,y_vel(a0)
	rts
; ===========================================================================

loc_3D744:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	++
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+
	moveq	#signextendB(SndID_Fire),d0
	jsrto	PlaySoundLocal, JmpTo_PlaySoundLocal
+
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(ObjC7_ChildDeltas).l,a1
	bra.w	ObjC7_PositionChildren
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	clr.w	y_vel(a0)
	lea	(ChildObjC7_TargettingSensor).l,a2
	bsr.w	LoadChildObject
	clr.w	x_vel(a0)
	clr.w	objoff_28(a0)
	rts
; ===========================================================================

loc_3D784:
	move.w	objoff_28(a0),d0
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	move.w	d0,x_pos(a0)
	bclr	#0,render_flags(a0)
	cmpi.w	#$780,d0
	bhs.s	+
	bset	#0,render_flags(a0)
+
	bsr.w	loc_3E168
	move.w	#$800,y_vel(a0)
	move.b	#$20,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D7B8:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(ObjC7_ChildDeltas).l,a1
	bra.w	ObjC7_PositionChildren
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	clr.w	y_vel(a0)
	move.b	#1,(Screen_Shaking_Flag).w
	move.w	#$40,(DEZ_Shake_Timer).w
	movea.w	objoff_38(a0),a1 ; a1=object
	move.b	#6,routine_secondary(a1)
	moveq	#signextendB(SndID_Smash),d0
	jmpto	PlaySound, JmpTo12_PlaySound
; ===========================================================================

loc_3D7F0:
	lea	(off_3E30A).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	lea	(ObjC7_ChildDeltas).l,a1
	bsr.w	ObjC7_PositionChildren
	bsr.w	Obj_GetOrientationToPlayer
	btst	#0,render_flags(a0)
	beq.s	+
	subq.w	#2,d0
+
	tst.w	d0
	bne.s	+
	subq.b	#2,routine_secondary(a0)
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	move.b	#$60,anim_frame_duration(a0)
	bra.w	CreateEggmanBombs
; ===========================================================================

loc_3D82E:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	subq.b	#2,routine_secondary(a0)
	rts
; ===========================================================================

loc_3D83C:
	moveq	#0,d0
	move.b	prev_anim(a0),d0
	move.w	off_3D84A(pc,d0.w),d1
	jmp	off_3D84A(pc,d1.w)
; ===========================================================================
off_3D84A:	offsetTable
		offsetTableEntry.w loc_3D6C0	;  0
		offsetTableEntry.w loc_3D856	;  2
		offsetTableEntry.w loc_3D6C0	;  4
		offsetTableEntry.w loc_3D89E	;  6
		offsetTableEntry.w loc_3D6C0	;  8
		offsetTableEntry.w loc_3D8B8	; $A
; ===========================================================================

loc_3D856:
	bset	#6,status(a0)
	lea	(off_3E2F6).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	bsr.w	Obj_GetOrientationToPlayer
	btst	#0,render_flags(a0)
	beq.s	+
	subq.w	#2,d0
+
	tst.w	d0
	bne.s	+
	addq.b	#2,prev_anim(a0)
	move.b	#$40,anim_frame_duration(a0)
	bset	#4,status(a0)
	rts
; ---------------------------------------------------------------------------
+
	move.b	#8,prev_anim(a0)
	move.b	#$20,anim_frame_duration(a0)
	bra.w	CreateEggmanBombs
; ===========================================================================

loc_3D89E:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	bset	#5,status(a0)
	move.b	#$40,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D8B8:
	lea	(off_3E300).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	subq.b	#2,routine_secondary(a0)
	bclr	#6,status(a0)
	rts
; ===========================================================================

loc_3D8D2:
	moveq	#0,d0
	move.b	anim(a0),d0
	move.w	off_3D8E0(pc,d0.w),d1
	jmp	off_3D8E0(pc,d1.w)
; ===========================================================================
off_3D8E0:	offsetTable
		offsetTableEntry.w loc_3D8E6	; 0
		offsetTableEntry.w loc_3D922	; 2
		offsetTableEntry.w loc_3D93C	; 4
; ===========================================================================

loc_3D8E6:
	jsrto	Boss_LoadExplosion, JmpTo_Boss_LoadExplosion
	jsrto	ObjectMoveAndFall, JmpTo8_ObjectMoveAndFall
	move.w	y_pos(a0),d0
	cmpi.w	#$15C,d0
	bhs.s	+
	rts
; ---------------------------------------------------------------------------
+
	move.w	#$15C,y_pos(a0)
	move.w	y_vel(a0),d0
	bmi.s	+
	lsr.w	#2,d0
	cmpi.w	#$100,d0
	blo.s	+
	neg.w	d0
	move.w	d0,y_vel(a0)
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,anim(a0)
	move.b	#$40,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D922:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	jmpto	Boss_LoadExplosion, JmpTo_Boss_LoadExplosion
; ---------------------------------------------------------------------------
+
	addq.b	#2,anim(a0)
	st.b	(Control_Locked).w
	move.w	#$1000,(Camera_Max_X_pos).w
	rts
; ===========================================================================

loc_3D93C:
	move.w	#(button_right_mask<<8)|button_right_mask,(Ctrl_1_Logical).w
	cmpi.w	#$840,(Camera_X_pos).w
	bhs.s	+
	rts
; ---------------------------------------------------------------------------
+
	move.b	#$20,routine(a0)
	clr.b	routine_secondary(a0)
	move.w	#$20,objoff_2A(a0)
	move.b	#1,(Screen_Shaking_Flag).w
	move.w	#$1000,(DEZ_Shake_Timer).w
	movea.w	objoff_36(a0),a1 ; a1=object
	jmpto	DeleteObject2, JmpTo6_DeleteObject2
; ===========================================================================
;loc_3D970
ObjC7_SetupEnding:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+
	moveq	#signextendB(SndID_Rumbling2),d0
	jsrto	PlaySound, JmpTo12_PlaySound
	subq.w	#1,objoff_2A(a0)
+
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),d0
	sub.w	objoff_2A(a0),d0
	move.w	d0,x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	bsr.w	loc_3DFBA
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3D9AC(pc,d0.w),d1
	jmp	off_3D9AC(pc,d1.w)
; ===========================================================================
off_3D9AC:	offsetTable
		offsetTableEntry.w loc_3D9B0	; 0
		offsetTableEntry.w loc_3D9D6	; 2
; ===========================================================================

loc_3D9B0:
	lea	(MainCharacter).w,a1 ; a1=character
	cmpi.w	#$EC0,x_pos(a1)
	bhs.s	loc_3D9BE
	rts
; ===========================================================================

loc_3D9BE:
	addq.b	#2,routine_secondary(a0)
	move.w	#$3F,(Palette_fade_range).w
	move.b	#$16,anim_frame_duration(a0)
	move.w	#$7FFF,(PalCycle_Timer).w
	rts
; ===========================================================================

loc_3D9D6:
	subq.b	#1,anim_frame_duration(a0)
	beq.w	+
	movea.l	a0,a1
	lea	(Normal_palette).w,a0

	moveq	#$3F,d0
-	jsrto	Pal_FadeToWhite.UpdateColour, JmpTo_Pal_FadeToWhite_UpdateColour
	dbf	d0,-
	movea.l	a1,a0
	rts
; ---------------------------------------------------------------------------
+
	move.l	#$EEE0EEE,d0
	lea	(Normal_palette).w,a1

	moveq	#$1F,d6
-	move.l	d0,(a1)+
	dbf	d6,-

	moveq	#signextendB(MusID_FadeOut),d0
	jsrto	PlaySound, JmpTo12_PlaySound
	move.b	#GameModeID_EndingSequence,(Game_Mode).w ; => EndingSequence
	bra.w	JmpTo65_DeleteObject
; ===========================================================================

ObjC7_Shoulder:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DA34(pc,d0.w),d1
	jsr	off_3DA34(pc,d1.w)
	lea	byte_3DA38(pc),a1
	bsr.w	loc_3E282
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
off_3DA34:	offsetTable
		offsetTableEntry.w loc_3DA3C	; 0
		offsetTableEntry.w return_3DA48	; 2
; ===========================================================================
byte_3DA38:
	dc.w   $C
	dc.w -$14
; ===========================================================================

loc_3DA3C:
	addq.b	#2,routine_secondary(a0)
	move.b	#4,mapping_frame(a0)
	rts
; ===========================================================================

return_3DA48:
	rts
; ===========================================================================
;loc_3DA4A
ObjC7_FrontLowerLeg:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DA62(pc,d0.w),d1
	jsr	off_3DA62(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
off_3DA62:	offsetTable
		offsetTableEntry.w loc_3DA66	; 0
		offsetTableEntry.w return_3DA72	; 2
; ===========================================================================

loc_3DA66:
	addq.b	#2,routine_secondary(a0)
	move.b	#$B,mapping_frame(a0)
	rts
; ===========================================================================

return_3DA72:
	rts
; ===========================================================================
;loc_3DA74
ObjC7_FrontForearm:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DA96(pc,d0.w),d1
	jsr	off_3DA96(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	btst	#6,status(a0)
	bne.w	return_37A48
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
off_3DA96:	offsetTable
		offsetTableEntry.w loc_3DAA0	; 0
		offsetTableEntry.w loc_3DAAC	; 2
		offsetTableEntry.w loc_3DACC	; 4
		offsetTableEntry.w loc_3DB32	; 6
		offsetTableEntry.w loc_3DB5A	; 8
; ===========================================================================

loc_3DAA0:
	addq.b	#2,routine_secondary(a0)
	move.b	#6,mapping_frame(a0)
	rts
; ===========================================================================

loc_3DAAC:
	movea.w	objoff_2C(a0),a1 ; a1=object
	bclr	#4,status(a1)
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$10,objoff_2A(a0)
	move.w	y_pos(a0),objoff_2E(a0)
	rts
; ===========================================================================

loc_3DACC:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	addi.w	#$20,y_vel(a0)
	jmpto	ObjectMove, JmpTo26_ObjectMove
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$20,objoff_2A(a0)
	bsr.w	Obj_GetOrientationToPlayer
	abs.w	d2
	cmpi.w	#$100,d2
	blo.s	+
	move.w	#$FF,d2
+
	andi.w	#$C0,d2
	lsr.w	#5,d2
	move.w	word_3DB2A(pc,d2.w),d2
	tst.w	d1
	bne.s	+
	neg.w	d2
+
	move.w	d2,y_vel(a0)
	move.w	#$800,d2
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#0,render_flags(a0)
	bne.s	+
	neg.w	d2
+
	move.w	d2,x_vel(a0)
	moveq	#signextendB(SndID_SpindashRelease),d0
	jmpto	PlaySound, JmpTo12_PlaySound
; ===========================================================================
word_3DB2A:
	dc.w  $200
	dc.w  $100	; 1
	dc.w   $80	; 2
	dc.w	 0	; 3
; ===========================================================================

loc_3DB32:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	jmpto	ObjectMove, JmpTo26_ObjectMove
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	neg.w	x_vel(a0)
	move.w	#$20,objoff_2A(a0)
	move.w	objoff_2E(a0),d0
	sub.w	y_pos(a0),d0
	asl.w	#3,d0
	move.w	d0,y_vel(a0)
	rts
; ===========================================================================

loc_3DB5A:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	jmpto	ObjectMove, JmpTo26_ObjectMove
; ---------------------------------------------------------------------------
+
	move.b	#2,routine_secondary(a0)
	clr.w	x_vel(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================
;loc_3DB74
ObjC7_Arm:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DB8C(pc,d0.w),d1
	jsr	off_3DB8C(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
off_3DB8C:	offsetTable
		offsetTableEntry.w loc_3DB90	; 0
		offsetTableEntry.w return_3DB9C	; 2
; ===========================================================================

loc_3DB90:
	addq.b	#2,routine_secondary(a0)
	move.b	#5,mapping_frame(a0)
	rts
; ===========================================================================

return_3DB9C:
	rts
; ===========================================================================
;loc_3DB9E
ObjC7_FrontThigh:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DBB6(pc,d0.w),d1
	jsr	off_3DBB6(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
off_3DBB6:	offsetTable
		offsetTableEntry.w loc_3DBBA	; 0
		offsetTableEntry.w return_3DBC6	; 2
; ===========================================================================

loc_3DBBA:
	addq.b	#2,routine_secondary(a0)
	move.b	#$A,mapping_frame(a0)
	rts
; ===========================================================================

return_3DBC6:
	rts
; ===========================================================================
;loc_3DBC8
ObjC7_Head:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DBE8(pc,d0.w),d1
	jsr	off_3DBE8(pc,d1.w)
	lea	byte_3DBF2(pc),a1
	bsr.w	loc_3E282
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
off_3DBE8:	offsetTable
		offsetTableEntry.w loc_3DBF6	; 0
		offsetTableEntry.w loc_3DC02	; 2
		offsetTableEntry.w loc_3DC1C	; 4
		offsetTableEntry.w loc_3DC2A	; 6
		offsetTableEntry.w loc_3DC46	; 8
; ===========================================================================
byte_3DBF2:
	dc.w    0
	dc.w -$34
; ===========================================================================

loc_3DBF6:
	addq.b	#2,routine_secondary(a0)
	move.b	#$15,mapping_frame(a0)
	rts
; ===========================================================================

loc_3DC02:
	movea.w	(DEZ_Eggman).w,a1
	btst	#3,status(a1)
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)
	rts
; ===========================================================================

loc_3DC1C:
	lea	(Ani_objC7_a).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3DC2A:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	movea.w	objoff_2C(a0),a1 ; a1=object
	bset	#2,status(a1)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3DC46:
	move.b	#-1,collision_property(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
;loc_3DC50
ObjC7_Jet:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DC66(pc,d0.w),d1
	jsr	off_3DC66(pc,d1.w)
	lea	byte_3DC70(pc),a1
	bra.w	loc_3E282
; ===========================================================================
off_3DC66:	offsetTable
		offsetTableEntry.w loc_3DC74
		offsetTableEntry.w loc_3DC80
		offsetTableEntry.w loc_3DC86
		offsetTableEntry.w loc_3DC94
		offsetTableEntry.w loc_3DC80
; ===========================================================================
byte_3DC70:
	dc.w  $38
	dc.w  $18
; ===========================================================================

loc_3DC74:
	addq.b	#2,routine_secondary(a0)
	move.b	#$C,mapping_frame(a0)
	rts
; ===========================================================================

loc_3DC80:
	move.b	#3,anim(a0)

loc_3DC86:
	lea	(Ani_objC7_b).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3DC94:
	move.b	#1,anim(a0)
	bra.s	loc_3DC86
; ===========================================================================
;loc_3DC9C
ObjC7_BackLowerLeg:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DCB4(pc,d0.w),d1
	jsr	off_3DCB4(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
off_3DCB4:	offsetTable
		offsetTableEntry.w loc_3DCB8	; 0
		offsetTableEntry.w return_3DCCA	; 2
; ===========================================================================

loc_3DCB8:
	addq.b	#2,routine_secondary(a0)
	move.b	#$B,mapping_frame(a0)
	move.b	#5,priority(a0)
	rts
; ===========================================================================

return_3DCCA:
	rts
; ===========================================================================
;loc_3DCCC
ObjC7_BackForearm:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DCE4(pc,d0.w),d1
	jsr	off_3DCE4(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
off_3DCE4:	offsetTable
		offsetTableEntry.w loc_3DCEE	; 0
		offsetTableEntry.w loc_3DD00	; 2
		offsetTableEntry.w loc_3DACC	; 4
		offsetTableEntry.w loc_3DB32	; 6
		offsetTableEntry.w loc_3DB5A	; 8
; ===========================================================================

loc_3DCEE:
	addq.b	#2,routine_secondary(a0)
	move.b	#6,mapping_frame(a0)
	move.b	#5,priority(a0)
	rts
; ===========================================================================

loc_3DD00:
	movea.w	objoff_2C(a0),a1 ; a1=object
	bclr	#5,status(a1)
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$10,objoff_2A(a0)
	move.w	y_pos(a0),objoff_2E(a0)
	rts
; ===========================================================================
;loc_3DD20
ObjC7_BackThigh:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DD38(pc,d0.w),d1
	jsr	off_3DD38(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
off_3DD38:	offsetTable
		offsetTableEntry.w loc_3DD3C	; 0
		offsetTableEntry.w return_3DD4E	; 2
; ===========================================================================

loc_3DD3C:
	addq.b	#2,routine_secondary(a0)
	move.b	#$A,mapping_frame(a0)
	move.b	#5,priority(a0)
	rts
; ===========================================================================

return_3DD4E:
	rts
; ===========================================================================
;loc_3DD50
ObjC7_TargettingSensor:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DD5E(pc,d0.w),d1
	jmp	off_3DD5E(pc,d1.w)
; ===========================================================================
off_3DD5E:	offsetTable
		offsetTableEntry.w loc_3DD64	; 0
		offsetTableEntry.w loc_3DDA6	; 2
		offsetTableEntry.w loc_3DE3C	; 4
; ===========================================================================

loc_3DD64:
	addq.b	#2,routine_secondary(a0)
	move.b	#$10,mapping_frame(a0)
	ori.w	#high_priority,art_tile(a0)
	move.b	#1,priority(a0)
	move.w	#$A0,objoff_2A(a0)
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.w	x_vel(a1),objoff_30(a0)
	move.w	y_vel(a1),objoff_32(a0)
	move.w	#$18,angle(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3DDA6:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3DE0A
	lea	next_object(a0),a1 ; a1=object
	movea.l	a1,a2
	move.w	-(a1),y_vel(a0)
	move.w	-(a1),x_vel(a0)

	moveq	#2,d6
-	move.l	-(a1),-(a2)
	dbf	d6,-

	lea	(MainCharacter).w,a2 ; a2=character
	move.w	x_vel(a2),d0
	bne.s	+
	move.w	x_pos(a2),x_pos(a0)
+
	move.w	d0,(a1)+
	move.w	y_vel(a2),d0
	bne.s	+
	move.w	y_pos(a2),y_pos(a0)
+
	move.w	d0,(a1)+
	jsrto	ObjectMove, JmpTo26_ObjectMove
	lea	(Ani_objC7_c).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	subq.b	#1,angle(a0)
	bpl.s	+
	subq.b	#1,objoff_27(a0)
	move.b	objoff_27(a0),angle(a0)
	moveq	#signextendB(SndID_Beep),d0
	jsrto	PlaySound, JmpTo12_PlaySound
+
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3DE0A:
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)
	move.b	#4,angle(a0)
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	lea	(ChildObjC7_TargettingLock).l,a2
	bsr.w	LoadChildObject
	clr.w	x_vel(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3DE3C:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3DE62
	lea	(Ani_objC7_c).l,a1
	jsrto	AnimateSprite, JmpTo25_AnimateSprite
	subq.b	#1,angle(a0)
	bpl.s	+
	move.b	#4,angle(a0)
	moveq	#signextendB(SndID_Beep),d0
	jsrto	PlaySound, JmpTo12_PlaySound
+
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3DE62:
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.w	x_pos(a0),objoff_28(a1)
	bra.w	JmpTo65_DeleteObject
; ===========================================================================
;loc_3DE70
ObjC7_TargettingLock:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DE7E(pc,d0.w),d1
	jmp	off_3DE7E(pc,d1.w)
; ===========================================================================
off_3DE7E:	offsetTable
		offsetTableEntry.w loc_3DE82	; 0
		offsetTableEntry.w loc_3DEA2	; 2
; ===========================================================================

loc_3DE82:
	addq.b	#2,routine_secondary(a0)
	move.b	#$14,mapping_frame(a0)
	move.b	#1,priority(a0)
	ori.w	#high_priority,art_tile(a0)
	move.w	#4,objoff_2A(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3DEA2:
	movea.w	objoff_2C(a0),a1 ; a1=object
	tst.b	(a1)
	beq.w	JmpTo65_DeleteObject
	subq.w	#1,objoff_2A(a0)
	bne.s	+
	move.w	#4,objoff_2A(a0)
	bchg	#palette_bit_0,art_tile(a0)
+
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
;loc_3DEC2
ObjC7_EggmanBomb:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DED0(pc,d0.w),d1
	jmp	off_3DED0(pc,d1.w)
; ===========================================================================
off_3DED0:	offsetTable
		offsetTableEntry.w loc_3DED8
		offsetTableEntry.w loc_3DF04
		offsetTableEntry.w loc_3DF36
		offsetTableEntry.w loc_3DF80
; ===========================================================================

loc_3DED8:
	addq.b	#2,routine_secondary(a0)
	move.b	#$E,mapping_frame(a0)
	move.b	#$89,collision_flags(a0)
	move.b	#5,priority(a0)
	move.b	#$C,width_pixels(a0)
	lea	byte_3DF00(pc),a1
	bsr.w	loc_3E282
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
byte_3DF00:
	dc.w  $38
	dc.w -$14
; ===========================================================================

loc_3DF04:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#7,status(a1)
	bne.s	loc_3DF4C
	jsrto	ObjectMoveAndFall, JmpTo8_ObjectMoveAndFall
	move.w	y_pos(a0),d0
	cmpi.w	#$170,d0
	bhs.s	+
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$170,y_pos(a0)
	move.w	#$40,objoff_2A(a0)
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3DF36:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#7,status(a1)
	bne.s	loc_3DF4C
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3DF4C
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3DF4C:
	move.b	#6,routine_secondary(a0)
	move.l	#Obj58_MapUnc_2D50A,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_FieryExplosion,0,0),art_tile(a0)
	move.b	#1,priority(a0)
	move.b	#7,anim_frame_duration(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#SndID_BossExplosion,d0
	jsr	(PlaySound).l
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3DF80:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#5,mapping_frame(a0)
	blo.s	+
	clr.b	collision_flags(a0)
	cmpi.b	#7,mapping_frame(a0)
	beq.w	JmpTo65_DeleteObject
+
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================
;loc_3DFAA
ObjC7_FallingPieces:
	subq.w	#1,objoff_2A(a0)
	bmi.w	JmpTo65_DeleteObject
	jsrto	ObjectMoveAndFall, JmpTo8_ObjectMoveAndFall
	jmpto	DisplaySprite, JmpTo45_DisplaySprite
; ===========================================================================

loc_3DFBA:
	jsr	(AllocateObject).l
	bne.s	+	; rts
	_move.b	#ObjID_BossExplosion,id(a1) ; load obj
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	jsr	(RandomNumber).l
	move.w	d0,d1
	moveq	#0,d1
	move.b	d0,d1
	lsr.b	#2,d1
	subi.w	#$30,d1
	add.w	d1,x_pos(a1)
	lsr.w	#8,d0
	lsr.b	#2,d0
	subi.w	#$30,d0
	add.w	d0,y_pos(a1)
+
	rts
; ===========================================================================
;loc_3DFF8
ObjC7_CheckHit:
	tst.b	collision_property(a0)
	beq.s	ObjC7_Beaten
	tst.b	objoff_2A(a0)
	bne.s	ObjC7_Flashing
	tst.b	collision_flags(a0)
	beq.s	+
	movea.w	objoff_36(a0),a1 ; a1=object
	tst.b	collision_flags(a1)
	bne.s	+++		; rts
	clr.b	collision_flags(a0)
	subq.b	#1,collision_property(a0)
	beq.s	ObjC7_Beaten
+
	move.b	#60,objoff_2A(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l
;loc_3E02E
ObjC7_Flashing:
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	+
	move.w	#$EEE,d0
+
	move.w	d0,(a1)
	subq.b	#1,objoff_2A(a0)
	bne.s	+
	clr.w	(Normal_palette_line2+2).w
	move.b	#$16,collision_flags(a0)
	movea.w	objoff_36(a0),a1 ; a1=object
	move.b	#$2A,collision_flags(a1)
+
	rts
; ===========================================================================
;loc_3E05A
ObjC7_Beaten:
	moveq	#100,d0
	bsr.w	AddPoints
	clr.b	anim_frame_duration(a0)
	move.b	#$E,routine_secondary(a0)
	bset	#7,status(a0)
	clr.b	anim(a0)
	clr.b	collision_flags(a0)
	clr.w	x_vel(a0)
	clr.w	y_vel(a0)
	bsr.w	ObjC7_RemoveCollision
	bsr.w	ObjC7_Break
	movea.w	objoff_38(a0),a1 ; a1=object
	jsrto	DeleteObject2, JmpTo6_DeleteObject2
	addq.w	#4,sp
	rts
; ===========================================================================
;loc_3E094
ObjC7_Break:
	lea	(ObjC7_BreakOffsets).l,a1
	lea	ObjC7_BreakSpeeds(pc),a2
	moveq	#0,d0
	moveq	#ObjC7_BreakOffsets_End-ObjC7_BreakOffsets-1,d6

-	move.b	(a1)+,d0
	movea.w	(a0,d0.w),a3 ; a3=object
	move.b	#$1E,routine(a3)
	clr.b	routine_secondary(a3)
	move.w	#$80,objoff_2A(a3)
	move.w	(a2)+,x_vel(a3)
	move.w	(a2)+,y_vel(a3)
	dbf	d6,-
	rts
; ===========================================================================
;word_3E0C6
ObjC7_BreakSpeeds:
	dc.w  $200,-$400
	dc.w -$100,-$100	; 2
	dc.w  $300,-$300	; 4
	dc.w -$100,-$400	; 6
	dc.w  $180,-$200	; 8
	dc.w -$200,-$300	; 10
	dc.w	 0,-$400	; 12
	dc.w  $100,-$300	; 14
ObjC7_BreakSpeeds_End
;byte_3E0E6
ObjC7_BreakOffsets:
	dc.b objoff_2C
	dc.b objoff_2E	; 1
	dc.b objoff_30	; 2
	dc.b objoff_32	; 3
	dc.b objoff_34	; 4
	dc.b objoff_3A	; 5
	dc.b objoff_3C	; 6
	dc.b objoff_3E	; 7
ObjC7_BreakOffsets_End
	even
; ===========================================================================
;loc_3E0EE
ObjC7_InitCollision:
	lea	ObjC7_ChildOffsets(pc),a1
	lea	ObjC7_ChildCollision(pc),a2
	moveq	#0,d0

	moveq	#ObjC7_ChildCollision_End-ObjC7_ChildCollision-1,d6
-	move.b	(a1)+,d0
	movea.w	(a0,d0.w),a3 ; a3=object
	move.b	(a2)+,collision_flags(a3)
	dbf	d6,-

	rts
; ===========================================================================
;byte_3E10A
ObjC7_ChildCollision:
	dc.b   0
	dc.b $8F	; 1
	dc.b $9C	; 2
	dc.b   0	; 3
	dc.b $86	; 4
	dc.b $2A	; 5
	dc.b $8B	; 6
	dc.b $8F	; 7
	dc.b $9C	; 8
	dc.b $8B	; 9
ObjC7_ChildCollision_End
;byte_3E114
ObjC7_ChildOffsets:
	dc.b objoff_2C
	dc.b objoff_2E	; 1
	dc.b objoff_30	; 2
	dc.b objoff_32	; 3
	dc.b objoff_34	; 4
	dc.b objoff_36	; 5
	dc.b objoff_38	; 6
	dc.b objoff_3A	; 7
	dc.b objoff_3C	; 8
	dc.b objoff_3E	; 9
ObjC7_ChildOffsets_End
	even
; ===========================================================================
;loc_3E11E
ObjC7_RemoveCollision:
	lea	ObjC7_ChildOffsets(pc),a1
	moveq	#0,d0
	moveq	#ObjC7_ChildOffsets_End-ObjC7_ChildOffsets-1,d6

-	move.b	(a1)+,d0
	movea.w	(a0,d0.w),a3 ; a3=object
	clr.b	collision_flags(a3)
	dbf	d6,-
	rts
; ===========================================================================
;loc_3E136
CreateEggmanBombs:
	lea	EggmanBomb_InitSpeeds(pc),a3
	moveq	#1,d6

-	lea	(ChildObjC7_EggmanBomb).l,a2
	bsr.w	LoadChildObject
	move.w	(a3)+,d0
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d0
+
	move.w	d0,x_vel(a1)
	move.w	(a3)+,y_vel(a1)
	dbf	d6,-
	rts
; ===========================================================================
;word_3E160
EggmanBomb_InitSpeeds:
	dc.w   $60,-$800
	dc.w   $C0,-$A00
; ===========================================================================

loc_3E168:
	move.b	render_flags(a0),d0
	andi.b	#1,d0
	moveq	#0,d1
	lea	byte_3E19E(pc),a1

-	move.b	(a1)+,d1
	beq.w	return_37A48
	movea.w	(a0,d1.w),a2 ; a2=object
	move.b	render_flags(a2),d2
	andi.b	#$FE,d2
	or.b	d0,d2
	move.b	d2,render_flags(a2)
	move.b	status(a2),d2
	andi.b	#$FE,d2
	or.b	d0,d2
	move.b	d2,status(a2)
	bra.s	-
; ===========================================================================
byte_3E19E:
	dc.b objoff_2C, objoff_2E, objoff_30, objoff_32	; 3
	dc.b objoff_34, objoff_36, objoff_38, objoff_3A	; 7
	dc.b objoff_3C, objoff_3E, 0
	even
; ===========================================================================

loc_3E1AA:
	movea.l	(a1)+,a2
	moveq	#0,d0
	move.b	anim_frame(a0),d0
	move.b	(a1,d0.w),d0
	move.b	d0,d1
	moveq	#0,d4
	andi.w	#$C0,d1
	beq.s	+
	bsr.w	loc_3E23E
+
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.b	(a2)+,d0
	move.b	(a2)+,d3
	move.b	objoff_1F(a0),d2
	addq.b	#1,d2
	cmp.b	d3,d2
	blo.s	+
	addq.b	#1,anim_frame(a0)
	moveq	#0,d2
+
	move.b	d2,objoff_1F(a0)
	moveq	#0,d5

-	move.b	(a2)+,d5
	movea.w	(a0,d5.w),a3 ; a3=object
	tst.w	d5
	bne.s	+
	movea.l	a0,a3
+
	move.l	x_pos(a3),d2
	move.b	(a2)+,d1
	ext.w	d1
	asl.w	#4,d1
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d1
+
	tst.w	d4
	beq.s	+
	neg.w	d1
+
	ext.l	d1
	asl.l	#8,d1
	add.l	d1,d2
	move.l	d2,x_pos(a3)
	move.l	y_pos(a3),d3
	move.b	(a2)+,d1
	ext.w	d1
	asl.w	#4,d1
	tst.w	d4
	beq.s	+
	neg.w	d1
+
	ext.l	d1
	asl.l	#8,d1
	add.l	d1,d3
	move.l	d3,y_pos(a3)
	dbf	d0,-

	moveq	#0,d1
	rts
; ===========================================================================

loc_3E236:
	clr.b	anim_frame(a0)
	moveq	#1,d1

return_3E23C:
	rts
; ===========================================================================

loc_3E23E:
	andi.b	#$3F,d0
	rol.b	#3,d1
	move.w	off_3E24C-2(pc,d1.w),d1
	jmp	off_3E24C(pc,d1.w)
; ===========================================================================
off_3E24C:	offsetTable
		offsetTableEntry.w loc_3E252
		offsetTableEntry.w loc_3E27A
		offsetTableEntry.w loc_3E27E
; ===========================================================================

loc_3E252:
	tst.b	objoff_1F(a0)
	bne.s	return_3E23C
	move.b	anim_frame(a0),d1
	addq.b	#1,d1
	move.b	(a1,d1.w),d0
	jsrto	PlaySound, JmpTo12_PlaySound ; sound id most likely came from off_3E40C or off_3E42C
	addq.b	#1,d1
	move.b	d1,anim_frame(a0)
	move.b	(a1,d1.w),d0
	move.b	d0,d1
	andi.b	#$C0,d1
	bne.s	loc_3E23E
	rts
; ===========================================================================

loc_3E27A:
	moveq	#1,d4
	rts
; ===========================================================================

loc_3E27E:
	addq.w	#4,sp
	bra.s	loc_3E236
; ===========================================================================

loc_3E282:
	movea.w	objoff_2C(a0),a2 ; a2=object
	move.w	x_pos(a2),d0
	move.w	(a1)+,d1
	btst	#0,render_flags(a2)
	beq.s	+
	neg.w	d1
+
	add.w	d1,d0
	move.w	d0,x_pos(a0)
	move.w	y_pos(a2),d0
	add.w	(a1)+,d0
	move.w	d0,y_pos(a0)
	rts
; ===========================================================================
;loc_3E2A8
ObjC7_PositionChildren:
	moveq	#0,d0
	moveq	#0,d6

	move.b	(a1)+,d6
-	move.b	(a1)+,d0
	movea.w	(a0,d0.w),a2 ; a2=object
	move.w	x_pos(a0),d1
	move.b	(a1)+,d2
	ext.w	d2
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d2
+
	add.w	d2,d1
	move.w	d1,x_pos(a2)
	move.w	y_pos(a0),d1
	move.b	(a1)+,d2
	ext.w	d2
	add.w	d2,d1
	move.w	d1,y_pos(a2)
	dbf	d6,-
	rts
; ===========================================================================
;byte_3E2E0
ObjC7_ChildDeltas:
	dc.b   6
	dc.b objoff_2E, $FC, $3C	; 1
	dc.b objoff_30, $F4,   8	; 2
	dc.b objoff_32,  $C, $F8	; 3
	dc.b objoff_34,   4, $24	; 4
	dc.b objoff_3A, $FC, $3C	; 5
	dc.b objoff_3C, $F4,   8	; 6
	dc.b objoff_3E,   4, $24	; 7
	even
off_3E2F6:
	dc.l ObjC7_GroupAni_3E318
	dc.b 0, 1, 2, 3, $FF, 0
	even
off_3E300:
	dc.l ObjC7_GroupAni_3E318
	dc.b 5, 6, 7, 8, $FF, 0
	even
off_3E30A:
	dc.l ObjC7_GroupAni_3E318
	dc.b 0, 1, 2, 3, 4, 5, 6, 7, 8, $C0
	even
; -----------------------------------------------------------------------------
; Custom animation
; -----------------------------------------------------------------------------
; must be on the same line as a label that has a corresponding _End label later
c7anilistheader macro maxframe,{INTLABEL}
__LABEL__ label *
	dc.b ((__LABEL___End - __LABEL__ - 2) / 3) - 1,maxframe
    endm

; macro for a animation data
c7ani macro pieceOffset,deltax,deltay
	dc.b	pieceOffset,deltax,deltay
    endm

ObjC7_GroupAni_3E318:		offsetTable ;include "mappings/sprite/objC7_a.asm"
		offsetTableEntry.w byte_3E32A
		offsetTableEntry.w byte_3E33E
		offsetTableEntry.w byte_3E352
		offsetTableEntry.w byte_3E366
		offsetTableEntry.w byte_3E37A
		offsetTableEntry.w byte_3E380
		offsetTableEntry.w byte_3E394
		offsetTableEntry.w byte_3E3A8
		offsetTableEntry.w byte_3E3BC

byte_3E32A:	c7anilistheader 8
	c7ani       $00, $E0, $0C
	c7ani objoff_30, $E0, $0C
	c7ani objoff_32, $E0, $0C
	c7ani objoff_3C, $E0, $0C
	c7ani objoff_34, $F8, $04
	c7ani objoff_3E, $F8, $04
byte_3E32A_End

byte_3E33E:	c7anilistheader 8
	c7ani       $00, $EC, $14
	c7ani objoff_30, $EC, $14
	c7ani objoff_32, $EC, $14
	c7ani objoff_3C, $EC, $14
	c7ani objoff_34, $FA, $06
	c7ani objoff_3E, $FA, $06
byte_3E33E_End

byte_3E352:	c7anilistheader 8
	c7ani       $00, $F8, $14
	c7ani objoff_30, $F8, $14
	c7ani objoff_32, $F8, $14
	c7ani objoff_3C, $F8, $14
	c7ani objoff_34, $FE, $04
	c7ani objoff_3E, $FE, $04
byte_3E352_End

byte_3E366:	c7anilistheader 8
	c7ani       $00, $FC, $0C
	c7ani objoff_30, $FC, $0C
	c7ani objoff_32, $FC, $0C
	c7ani objoff_3C, $FC, $0c
	c7ani objoff_34, $00, $02
	c7ani objoff_3E, $00, $02
byte_3E366_End

byte_3E37A:	c7anilistheader 8
	c7ani       $00, $00, $00
byte_3E37A_End
	even
byte_3E380:	c7anilistheader 8
	c7ani       $00, $04, $E8
	c7ani objoff_30, $04, $E8
	c7ani objoff_32, $04, $E8
	c7ani objoff_3C, $04, $E8
	c7ani objoff_34, $02, $FA
	c7ani objoff_3E, $02, $FA
byte_3E380_End

byte_3E394:	c7anilistheader 8
	c7ani       $00, $0C, $E8
	c7ani objoff_30, $0C, $E8
	c7ani objoff_32, $0C, $E8
	c7ani objoff_3C, $0C, $E8
	c7ani objoff_34, $04, $FC
	c7ani objoff_3E, $04, $FC
byte_3E394_End

byte_3E3A8:	c7anilistheader 8
	c7ani       $00, $18, $F4
	c7ani objoff_30, $18, $F4
	c7ani objoff_32, $18, $F4
	c7ani objoff_3C, $18, $F4
	c7ani objoff_34, $04, $FC
	c7ani objoff_3E, $04, $FC
byte_3E3A8_End

byte_3E3BC:	c7anilistheader 8
	c7ani       $00, $18, $FC
	c7ani objoff_30, $18, $FC
	c7ani objoff_32, $18, $FC
	c7ani objoff_3C, $18, $FC
	c7ani objoff_34, $06, $FE
	c7ani objoff_3E, $06, $FE
byte_3E3BC_End

off_3E3D0:
	dc.l ObjC7_GroupAni_3E3D8
	dc.b 0, 1, 2, $C0
	even
; -----------------------------------------------------------------------------
; Custom animation
; -----------------------------------------------------------------------------
ObjC7_GroupAni_3E3D8:		offsetTable ;include "mappings/sprite/objC7_b.asm"
		offsetTableEntry.w byte_3E3DE
		offsetTableEntry.w byte_3E3F2
		offsetTableEntry.w byte_3E3F8

byte_3E3DE:	c7anilistheader $10
	c7ani       $00, $00, $04
	c7ani objoff_30, $00, $04
	c7ani objoff_32, $00, $04
	c7ani objoff_3C, $00, $04
	c7ani objoff_34, $00, $04
	c7ani objoff_3E, $00, $04
byte_3E3DE_End

byte_3E3F2:	c7anilistheader $10
	c7ani       $00, $00, $00
byte_3E3F2_End
	even
byte_3E3F8:	c7anilistheader 8
	c7ani       $00, $00, $F8
	c7ani objoff_30, $00, $F8
	c7ani objoff_32, $00, $F8
	c7ani objoff_3C, $00, $F8
	c7ani objoff_34, $00, $F8
	c7ani objoff_3E, $00, $F8
byte_3E3F8_End

off_3E40C:
	dc.l ObjC7_GroupAni_3E438
	dc.b   0,  1,  2,  3, $40, SndID_Hammer
	dc.b   4,  5,  6,  7,   8, $40, SndID_Hammer
	dc.b   9, $A,  1,  2,   3, $40, SndID_Hammer
	dc.b   4,  5,  6,  7,   8, $40, SndID_Hammer, $C0
	even
off_3E42C:
	dc.l ObjC7_GroupAni_3E438
	dc.b $88, $87, $86, $85, $B, $40, SndID_Hammer, $C0
	even
; -----------------------------------------------------------------------------
; Custom animation
; -----------------------------------------------------------------------------
ObjC7_GroupAni_3E438:		offsetTable ;include "mappings/sprite/objC7_c.asm"
		offsetTableEntry.w byte_3E450
		offsetTableEntry.w byte_3E468
		offsetTableEntry.w byte_3E480
		offsetTableEntry.w byte_3E494
		offsetTableEntry.w byte_3E4AC
		offsetTableEntry.w byte_3E4C4
		offsetTableEntry.w byte_3E4D6
		offsetTableEntry.w byte_3E4EE
		offsetTableEntry.w byte_3E502
		offsetTableEntry.w byte_3E51A
		offsetTableEntry.w byte_3E532
		offsetTableEntry.w byte_3E544

byte_3E450:	c7anilistheader $20
	c7ani objoff_34, $F8, $F8
	c7ani objoff_2E, $F8, $F8
	c7ani       $00, $00, $FC
	c7ani objoff_30, $04, $FB
	c7ani objoff_32, $03, $FB
	c7ani objoff_3C, $FC, $FB
	c7ani objoff_3E, $00, $FE
byte_3E450_End
	even
byte_3E468:	c7anilistheader $10
	c7ani objoff_34, $F0, $FC
	c7ani objoff_2E, $F0, $FC
	c7ani       $00, $F0, $FC
	c7ani objoff_30, $F4, $FB
	c7ani objoff_32, $F3, $FB
	c7ani objoff_3C, $EC, $FB
	c7ani objoff_3E, $F8, $00
byte_3E468_End
	even
byte_3E480:	c7anilistheader $10
	c7ani objoff_34, $F8, $04
	c7ani objoff_2E, $F8, $04
	c7ani       $00, $F8, $04
	c7ani objoff_30, $FC, $03
	c7ani objoff_32, $FB, $03
	c7ani objoff_3C, $F4, $03
byte_3E480_End

byte_3E494:	c7anilistheader $10
	c7ani objoff_34, $FC, $10
	c7ani objoff_2E, $F8, $10
	c7ani       $00, $00, $08
	c7ani objoff_30, $F8, $0A
	c7ani objoff_32, $FA, $0A
	c7ani objoff_3C, $08, $0A
	c7ani objoff_3E, $00, $08
byte_3E494_End
	even
byte_3E4AC:	c7anilistheader $20
	c7ani objoff_34, $FE, $FE
	c7ani       $00, $F4, $FC
	c7ani objoff_30, $F0, $FD
	c7ani objoff_32, $F1, $FD
	c7ani objoff_3C, $F8, $FD
	c7ani objoff_3E, $EC, $FA
	c7ani objoff_3A, $E8, $FC
byte_3E4AC_End
	even
byte_3E4C4:	c7anilistheader $20
	c7ani objoff_3E, $F8, $FC
	c7ani objoff_3A, $F8, $FC
	c7ani objoff_30, $FC, $FF
	c7ani objoff_32, $FD, $FF
	c7ani objoff_3C, $04, $FF
byte_3E4C4_End
	even
byte_3E4D6:	c7anilistheader $10
	c7ani objoff_3E, $F0, $FC
	c7ani objoff_3A, $F0, $FC
	c7ani       $00, $F0, $FC
	c7ani objoff_30, $EC, $FB
	c7ani objoff_32, $ED, $FB
	c7ani objoff_3C, $F4, $FB
	c7ani objoff_34, $F8, $00
byte_3E4D6_End
	even
byte_3E4EE:	c7anilistheader $10
	c7ani objoff_3E, $F8, $04
	c7ani objoff_3A, $F8, $04
	c7ani       $00, $F8, $04
	c7ani objoff_30, $F4, $03
	c7ani objoff_32, $F5, $03
	c7ani objoff_3C, $FC, $03
byte_3E4EE_End

byte_3E502:	c7anilistheader $10
	c7ani objoff_3E, $FC, $10
	c7ani objoff_3A, $F8, $10
	c7ani       $00, $00, $08
	c7ani objoff_30, $08, $0A
	c7ani objoff_32, $06, $0A
	c7ani objoff_3C, $F8, $0A
	c7ani objoff_34, $00, $08
byte_3E502_End
	even
byte_3E51A:	c7anilistheader $20
	c7ani objoff_3E, $FE, $FE
	c7ani       $00, $F4, $FC
	c7ani objoff_30, $F8, $FD
	c7ani objoff_32, $F7, $FD
	c7ani objoff_3C, $F1, $FD
	c7ani objoff_34, $EC, $FA
	c7ani objoff_2E, $E8, $FC
byte_3E51A_End
	even
byte_3E532:	c7anilistheader $20
	c7ani objoff_34, $F8, $FC
	c7ani objoff_2E, $F8, $FC
	c7ani objoff_30, $04, $FF
	c7ani objoff_32, $03, $FF
	c7ani objoff_3C, $FC, $FF
byte_3E532_End
	even
byte_3E544:	c7anilistheader $10
	c7ani objoff_3E, $00, $08
	c7ani objoff_3A, $00, $08
	c7ani       $00, $00, $08
	c7ani objoff_30, $00, $08
	c7ani objoff_32, $00, $08
	c7ani objoff_3C, $00, $08
	c7ani objoff_34, $00, $08
byte_3E544_End
	even

;word_3E55C
ChildObjC7_Shoulder:
	dc.w objoff_2C
	dc.b ObjID_Eggrobo
	dc.b   4
;word_3E560
ChildObjC7_FrontLowerLeg:
	dc.w objoff_2E
	dc.b ObjID_Eggrobo
	dc.b   6
;word_3E564
ChildObjC7_FrontForearm:
	dc.w objoff_30
	dc.b ObjID_Eggrobo
	dc.b   8
;word_3E568
ChildObjC7_Arm:
	dc.w objoff_32
	dc.b ObjID_Eggrobo
	dc.b  $A
;word_3E56C
ChildObjC7_FrontThigh:
	dc.w objoff_34
	dc.b ObjID_Eggrobo
	dc.b  $C
;word_3E570
ChildObjC7_Head:
	dc.w objoff_36
	dc.b ObjID_Eggrobo
	dc.b  $E
;word_3E574
ChildObjC7_Jet:
	dc.w objoff_38
	dc.b ObjID_Eggrobo
	dc.b $10
;word_3E578
ChildObjC7_BackLowerLeg:
	dc.w objoff_3A
	dc.b ObjID_Eggrobo
	dc.b $12
;word_3E57C
ChildObjC7_BackForearm:
	dc.w objoff_3C
	dc.b ObjID_Eggrobo
	dc.b $14
;word_3E580
ChildObjC7_BackThigh:
	dc.w objoff_3E
	dc.b ObjID_Eggrobo
	dc.b $16
;word_3E584
ChildObjC7_TargettingSensor:
	dc.w objoff_10
	dc.b ObjID_Eggrobo
	dc.b $18
;word_3E588
ChildObjC7_TargettingLock:
	dc.w objoff_10
	dc.b ObjID_Eggrobo
	dc.b $1A
;word_3E58C
ChildObjC7_EggmanBomb:
	dc.w objoff_10
	dc.b ObjID_Eggrobo
	dc.b $1C
;off_3E590
ObjC7_SubObjData:
	subObjData ObjC7_MapUnc_3E5F8,make_art_tile(ArtTile_ArtNem_DEZBoss,0,0),4,4,$38,$00

; animation script
; off_3E59A:
Ani_objC7_a:	offsetTable
		offsetTableEntry.w +
+		dc.b   7,$15,$15,$15,$15,$15,$15,$15,$15,  0,  1,  2,$FA
		even

; animation script
; off_3E5AA:
Ani_objC7_b:	offsetTable
		offsetTableEntry.w byte_3E5B2
		offsetTableEntry.w byte_3E5B6
		offsetTableEntry.w byte_3E5D0
		offsetTableEntry.w byte_3E5EA
byte_3E5B2:	dc.b   1, $C, $D,$FF
byte_3E5B6:	dc.b   1, $C, $D, $C, $C, $D, $D, $C, $C, $C, $D, $D, $D, $C, $C, $C
		dc.b  $C, $C, $D, $D, $D, $D, $D, $D,$FA,  0; 16
byte_3E5D0:	dc.b   1, $D, $D, $D, $D, $D, $D, $C, $C, $C, $C, $C, $D, $D, $D, $C
		dc.b  $C, $C, $D, $D, $C, $C, $D, $C,$FD,  0; 16
byte_3E5EA:	dc.b   0, $D,$15,$FF
		even

; animation script
; off_3E5EE:
Ani_objC7_c:	offsetTable
		offsetTableEntry.w byte_3E5F0
byte_3E5F0:	dc.b   3,$13,$12,$11,$10,$16,$FF
		even
; ------------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------------
ObjC7_MapUnc_3E5F8:	include "mappings/sprite/objC7.asm"
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to upscale graphics by a factor of 2x, based on given mappings
; data for correct positioning of tiles.
;
; This code is awfully structured and planned: whenever a 3-column sprite piece
; is scaled, it scales the next tiles that were copied to RAM as if the piece
; had 4 columns; this will then be promptly overwritten by the next piece. If
; this happens near the end of the buffer, you will get a buffer overrun.
; Moreover, when the number of rows in the sprite piece is also 3 or 4, the code
; will make an incorrect computation for the output of the next subpiece, which
; causes the output to overwrite art from the previous subpiece. Thus, this code
; fails if there is a 3x3 or a 3x4 sprite piece in the source mappings. Sadly,
; this issue is basically unfixable without rewriting the code entirely.
;
; Input:
; 	a1	Location of tiles to be enlarged
; 	a2	Destination buffer for enlarged tiles
; 	d0	Width-1 of sprite piece
; 	d1	Height-1 of sprite piece
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;loc_3E89E
Scale_2x:
	move.w	d1,d2					; Copy piece height-1
	andi.w	#1,d2					; Want only low bit -- this is 1 for Wx2 or Wx4 pieces, 0 otherwise
	addq.w	#1,d2					; Make it into 2 for Wx2 or Wx4 pieces, 1 otherwise
	lsl.w	#6,d2					; This is now $80 (4 tiles) for Wx2 or Wx4 pieces, $40 (2 tiles) otherwise
	swap	d2						; Save it to high word
	move.w	d1,d3					; Copy piece height-1 again
	lsr.w	#1,d3					; This time, want high bit (1 for Wx3 or Wx4, 0 for Wx2 or Wx1)
	addq.w	#1,d3					; Make it into 2 for Wx3 or Wx4 pieces, 1 otherwise
	lsl.w	#6,d3					; This is now $80 (4 tiles) for Wx3 or Wx4 pieces, $40 (2 tiles) otherwise
	swap	d3						; Save it to high word
	bsr.w	.upscale_part1				; Scale the first line???; sets a3 = ???, a5 = ???
	btst	#1,d0					; Is this a 1xH or a 2xH piece?
	beq.w	return_37A48				; Return if yes
	btst	#1,d1					; Is this a Wx3 or a Wx4 piece?
	bne.s	.set_dest				; Branch if yes
	movea.l	a3,a5					; Advance to next column instead

.set_dest:
	movea.l	a5,a2					; Set new output location

.upscale_part1:
	movea.l	a2,a4					; Copy destination to a4
	swap	d2					; Get height offset
	lea	(a2,d2.w),a3				; Output location for next tile
	swap	d2					; Save height offset again
	move.w	d1,d5					; Copy height-1
	andi.w	#1,d5					; How many tiles we want to do-1 -- this is 1 for Wx2 or Wx4 pieces, 0 otherwise
	bsr.w	Scale2x_SingleTile
	btst	#1,d1					; Are we upscaling a Wx3 or Wx4 piece?
	beq.s	.done_cols				; Branch if not
	swap	d2					; Get height offset
	move.w	d2,d4					; Copy it to d4
	swap	d2					; Save height offset again
	add.w	d4,d4					; This is now $100 (8 tiles) for Wx4 pieces, $80 (4 tiles) for Wx3 pieces
	move.w	d0,d3					; Copy piece width-1
	andi.w	#1,d3					; Want only low bit -- this is 1 for 2xH or 4xH pieces, 0 otherwise
	lsl.w	d3,d4					; This is now: $200 (16 tiles) for 2x4 or 4x4 pieces; $100 (8 tiles) for 2x3, 4x3, 1x4 or 3x4 pieces; $80 (4 tiles) for 1x3 or 3x3 pieces
	adda.w	d4,a4					; Advance to this location
	move.w	d1,d5					; Copy height-1
	lsr.w	#1,d5					; How many tiles we want to do-1 -- this is 1 for Wx4 pieces, 0 for Wx3 pieces
	swap	d3					; Get height offset
	lea	(a4,d3.w),a5				; Output location for next tile
	swap	d3					; Save height offset again
	bsr.w	Scale2x_SingleTile2

.done_cols:
	btst	#0,d0					; Is this a 1xH or 3xH piece?
	bne.s	.keep_upscaling				; Branch if not
	btst	#1,d0					; Was this a single column piece?
	beq.s	.done					; Return if so

.keep_upscaling:
	swap	d2					; Get height offset
	lea	(a2,d2.w),a2				; Output location for next tile
	lea	(a2,d2.w),a3				; Output location for next tile
	swap	d2					; Save height offset again
	move.w	d1,d5					; Copy height-1
	andi.w	#1,d5					; How many tiles we want to do -- this is 1 for Wx2 or Wx4 pieces, 0 otherwise
	bsr.w	Scale2x_SingleTile
	btst	#1,d1					; Are we upscaling a Wx3 or Wx4 piece?
	beq.s	.done					; Branch if not
	move.w	d1,d5					; Copy height-1
	lsr.w	#1,d5					; How many tiles we want to do-1 -- this is 1 for Wx4 or Wx3 pieces, 0 otherwise
	swap	d3					; Get height offset
	lea	(a4,d3.w),a4				; Output location for next tile
	lea	(a4,d3.w),a5				; Output location for next tile
	swap	d3					; Save height offset again
	bsr.w	Scale2x_SingleTile2

.done:
	rts
; ===========================================================================
; Upscales the given tile to the pair of tiles on the output pointers.
;
; Input:
; 	a1	Pixel source
; 	d5	Number of tiles-1 to upscale
; 	a2	Location of output tiles for left pixels
; 	a3	Location of output tiles for right pixels
; Output:
; 	a1	Pixel source after processed tiles
; 	a2	Location of output tiles for left pixels after scaled tiles
; 	a3	Location of output tiles for right pixels after scaled tiles
;loc_3E944
Scale2x_SingleTile:
	moveq	#7,d6					; 8 rows per tile

.loop:
	bsr.w	Scale_2x_LeftPixels			; Upscale pixels 0-3 of current row
	addq.w	#4,a2					; Advance write destination by one row (8 pixels)
	bsr.w	Scale_2x_RightPixels			; Upscale pixels 4-7 of current row
	addq.w	#4,a3					; Advance write destination by one row (8 pixels)
	dbf	d6,.loop

	dbf	d5,Scale2x_SingleTile

	rts
; ===========================================================================
; Upscales the given tile to the pair of tiles on the output pointers.
;
; Input:
; 	a1	Pixel source
; 	d5	Number of tiles-1 to upscale
; 	a4	Location of output tiles for left pixels
; 	a5	Location of output tiles for right pixels
; Output:
; 	a1	Pixel source after processed tiles
; 	a4	Location of output tiles for left pixels after scaled tiles
; 	a5	Location of output tiles for right pixels after scaled tiles
;loc_3E95C
Scale2x_SingleTile2:
	moveq	#7,d6					; 8 rows per tile

.loop:
	bsr.w	Scale_2x_LeftPixels2			; Upscale pixels 0-3 of current row
	addq.w	#4,a4					; Advance write destination by one row (8 pixels)
	bsr.w	Scale_2x_RightPixels2			; Upscale pixels 4-7 of current row
	addq.w	#4,a5					; Advance write destination by one row (8 pixels)
	dbf	d6,.loop

	dbf	d5,Scale2x_SingleTile2

	rts
; ===========================================================================
; Upscales the leftmost 4 pixels on the current row into the corresponding two
; rows of the output tile
;loc_3E974
Scale_2x_LeftPixels:
	bsr.w	.upscale_pixel_pair

.upscale_pixel_pair:
	move.b	(a1)+,d2				; Read two pixels
	move.b	d2,d3					; Save them
	andi.b	#$F0,d2					; Get left pixel
	move.b	d2,d4					; Copy it...
	lsr.b	#4,d4					; ...shift it down into place...
	or.b	d2,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a2)+				; Save to top tile, both on one row...
	move.b	d4,3(a2)				; ...and on the row below
	andi.b	#$F,d3					; Get saved right pixel
	move.b	d3,d4					; Copy it...
	lsl.b	#4,d4					; ...shift it up into place...
	or.b	d3,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a2)+				; Save to top tile, both on one row...
	move.b	d4,3(a2)				; ...and on the row below
	rts
; ===========================================================================
; Upscales the rightmost 4 pixels on the current row into the corresponding two
; rows of the output tile
;loc_3E99E
Scale_2x_RightPixels:
	bsr.w	.upscale_pixel_pair

.upscale_pixel_pair:
	move.b	(a1)+,d2				; Read two pixels
	move.b	d2,d3					; Save them
	andi.b	#$F0,d2					; Get left pixel
	move.b	d2,d4					; Copy it...
	lsr.b	#4,d4					; ...shift it down into place...
	or.b	d2,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a3)+				; Save to bottom tile, both on one row...
	move.b	d4,3(a3)				; ...and on the row below
	andi.b	#$F,d3					; Get saved right pixel
	move.b	d3,d4					; Copy it...
	lsl.b	#4,d4					; ...shift it up into place...
	or.b	d3,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a3)+				; Save to bottom tile, both on one row...
	move.b	d4,3(a3)				; ...and on the row below
	rts
; ===========================================================================
; Upscales the leftmost 4 pixels on the current row into the corresponding two
; rows of the output tile
;loc_3E9C8
Scale_2x_LeftPixels2:
	bsr.w	.upscale_pixel_pair

.upscale_pixel_pair:
	move.b	(a1)+,d2				; Read two pixels
	move.b	d2,d3					; Save them
	andi.b	#$F0,d2					; Get left pixel
	move.b	d2,d4					; Copy it...
	lsr.b	#4,d4					; ...shift it down into place...
	or.b	d2,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a4)+				; Save to top tile, both on one row...
	move.b	d4,3(a4)				; ...and on the row below
	andi.b	#$F,d3					; Get saved right pixel
	move.b	d3,d4					; Copy it...
	lsl.b	#4,d4					; ...shift it up into place...
	or.b	d3,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a4)+				; Save to top tile, both on one row...
	move.b	d4,3(a4)				; ...and on the row below
	rts
; ===========================================================================
; Upscales the rightmost 4 pixels on the current row into the corresponding two
; rows of the output tile
;loc_3E9F2
Scale_2x_RightPixels2:
	bsr.w	.upscale_pixel_pair

.upscale_pixel_pair:
	move.b	(a1)+,d2				; Read two pixels
	move.b	d2,d3					; Save them
	andi.b	#$F0,d2					; Get left pixel
	move.b	d2,d4					; Copy it...
	lsr.b	#4,d4					; ...shift it down into place...
	or.b	d2,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a5)+				; Save to bottom tile, both on one row...
	move.b	d4,3(a5)				; ...and on the row below
	andi.b	#$F,d3					; Get saved right pixel
	move.b	d3,d4					; Copy it...
	lsl.b	#4,d4					; ...shift it up into place...
	or.b	d3,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a5)+				; Save to bottom tile, both on one row...
	move.b	d4,3(a5)				; ...and on the row below
	rts
; ===========================================================================

	; this data seems to be unused
	dc.b $12,$34,$56,$78
	dc.b $12,$34,$56,$78	; 4
	dc.b $12,$34,$56,$78	; 8
	dc.b $12,$34,$56,$78	; 12
	dc.b $12,$34,$56,$78	; 16
	dc.b $12,$34,$56,$78	; 20
	dc.b $12,$34,$56,$78	; 24
	dc.b $12,$34,$56,$78	; 28

; ===========================================================================

    if ~~removeJmpTos
JmpTo5_DisplaySprite3 ; JmpTo
	jmp	(DisplaySprite3).l
JmpTo45_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo65_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo19_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
JmpTo39_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo6_DeleteObject2 ; JmpTo
	jmp	(DeleteObject2).l
JmpTo12_PlaySound ; JmpTo
	jmp	(PlaySound).l
JmpTo25_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo25_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo_PlaySoundLocal ; JmpTo
	jmp	(PlaySoundLocal).l
JmpTo6_RandomNumber ; JmpTo
	jmp	(RandomNumber).l
JmpTo2_MarkObjGone_P1 ; JmpTo
	jmp	(MarkObjGone_P1).l
JmpTo_Pal_FadeToWhite_UpdateColour ; JmpTo
	jmp	(Pal_FadeToWhite.UpdateColour).l
JmpTo_LoadTailsDynPLC_Part2 ; JmpTo
	jmp	(LoadTailsDynPLC_Part2).l
JmpTo_LoadSonicDynPLC_Part2 ; JmpTo
	jmp	(LoadSonicDynPLC_Part2).l
JmpTo8_MarkObjGone3 ; JmpTo
	jmp	(MarkObjGone3).l
JmpTo64_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo5_PlayMusic ; JmpTo
	jmp	(PlayMusic).l
JmpTo_Boss_LoadExplosion ; JmpTo
	jmp	(Boss_LoadExplosion).l
JmpTo9_PlatformObject ; JmpTo
	jmp	(PlatformObject).l
JmpTo27_SolidObject ; JmpTo
	jmp	(SolidObject).l
JmpTo8_ObjectMoveAndFall ; JmpTo
	jmp	(ObjectMoveAndFall).l
; loc_3EAC0:
JmpTo26_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif
