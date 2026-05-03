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
	andi.b	#~(1<<render_flags.x_flip|1<<render_flags.y_flip),d0
	move.b	status(a0),d2
	andi.b	#~(1<<status.npc.x_flip|1<<status.npc.y_flip),d2
	move.b	render_flags(a1),d1
	andi.b	#1<<render_flags.x_flip|1<<render_flags.y_flip,d1
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
	bclr	#render_flags.x_flip,render_flags(a0)
	bclr	#status.npc.x_flip,status(a0)
	tst.w	d0
	beq.s	return_36818
	bset	#render_flags.x_flip,render_flags(a0)
	bset	#status.npc.x_flip,status(a0)

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
;  a1 = address of new projectile
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
