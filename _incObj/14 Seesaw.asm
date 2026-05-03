; ----------------------------------------------------------------------------
; Object 14 - See saw from Hill Top Zone
; ----------------------------------------------------------------------------
; Sprite_21928:
Obj14:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj14_Index(pc,d0.w),d1
	jsr	Obj14_Index(pc,d1.w)
	move.w	objoff_30(a0),d0
	jmpto	JmpTo_MarkObjGone2
; ===========================================================================
; off_2193E:
Obj14_Index:	offsetTable
		offsetTableEntry.w Obj14_Init		;  0
		offsetTableEntry.w Obj14_Main		;  2
		offsetTableEntry.w return_21A74		;  4
		offsetTableEntry.w Obj14_Ball_Init	;  6
		offsetTableEntry.w Obj14_Ball_Main	;  8
		offsetTableEntry.w Obj14_Ball_Fly	; $A
; ===========================================================================
; loc_2194A:
Obj14_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj14_MapUnc_21CF0,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HtzSeeSaw,0,0),art_tile(a0)
	jsrto	JmpTo13_Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#$30,width_pixels(a0)
	move.w	x_pos(a0),objoff_30(a0)
	tst.b	subtype(a0)
	bne.s	loc_219A4
	jsrto	JmpTo3_AllocateObjectAfterCurrent
	bne.s	loc_219A4
	_move.b	#ObjID_Seesaw,id(a1) ; load obj14
	addq.b	#6,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	status(a0),status(a1)
	move.l	a0,objoff_3C(a1)

loc_219A4:
	btst	#status.npc.x_flip,status(a0)
	beq.s	loc_219B2
	move.b	#2,mapping_frame(a0)

loc_219B2:
	move.b	mapping_frame(a0),objoff_3A(a0)

Obj14_Main:
	move.b	objoff_3A(a0),d1
	btst	#p1_standing_bit,status(a0)
	beq.s	loc_21A12
	moveq	#2,d1
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a0),d0
	sub.w	x_pos(a1),d0
	bcc.s	+
	neg.w	d0
	moveq	#0,d1
+
	cmpi.w	#8,d0
	bhs.s	+
	moveq	#1,d1
+
	btst	#p2_standing_bit,status(a0)
	beq.s	Obj14_UpdateMappingAndCollision
	moveq	#2,d2
	lea	(Sidekick).w,a1 ; a1=character
	move.w	x_pos(a0),d0
	sub.w	x_pos(a1),d0
	bcc.s	+
	neg.w	d0
	moveq	#0,d2
+
	cmpi.w	#8,d0
	bhs.s	+
	moveq	#1,d2
+
	add.w	d2,d1
	cmpi.w	#3,d1
	bne.s	+
	addq.w	#1,d1
+
	lsr.w	#1,d1
	bra.s	Obj14_UpdateMappingAndCollision
; ===========================================================================

loc_21A12:
	btst	#p2_standing_bit,status(a0)
	beq.s	loc_21A38
	moveq	#2,d1
	lea	(Sidekick).w,a1 ; a1=character
	move.w	x_pos(a0),d0
	sub.w	x_pos(a1),d0
	bcc.s	+
	neg.w	d0
	moveq	#0,d1
+
	cmpi.w	#8,d0
	bhs.s	Obj14_UpdateMappingAndCollision
	moveq	#1,d1
	bra.s	Obj14_UpdateMappingAndCollision
; ===========================================================================

loc_21A38:
	move.w	(MainCharacter+y_vel).w,d0
	move.w	(Sidekick+y_vel).w,d2
	cmp.w	d0,d2
	blt.s	+
	move.w	d2,d0
+
	move.w	d0,objoff_38(a0)

; loc_21A4A:
Obj14_UpdateMappingAndCollision:
	bsr.w	Obj14_SetMapping
	lea	(byte_21C8E).l,a2
	btst	#0,mapping_frame(a0)
	beq.s	+
	lea	(byte_21CBF).l,a2
+
	move.w	x_pos(a0),-(sp)
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	moveq	#8,d3
	move.w	(sp)+,d4
	bra.w	SlopedPlatform
; ===========================================================================

return_21A74:
	rts
; ===========================================================================

; loc_21A76:
Obj14_SetMapping:
	move.b	mapping_frame(a0),d0
	cmp.b	d1,d0
	beq.s	return_21AA0
	bhs.s	+
	addq.b	#2,d0
+
	subq.b	#1,d0
	move.b	d0,mapping_frame(a0)
	move.b	d1,objoff_3A(a0)
	bclr	#render_flags.x_flip,render_flags(a0)
	btst	#1,mapping_frame(a0)
	beq.s	return_21AA0
	bset	#render_flags.x_flip,render_flags(a0)

return_21AA0:
	rts
; ===========================================================================
; loc_21AA2:
Obj14_Ball_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj14_MapUnc_21D7C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Sol,0,0),art_tile(a0)
	jsrto	JmpTo13_Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#$8B,collision_flags(a0)
	move.b	#$C,width_pixels(a0)
	move.w	x_pos(a0),objoff_30(a0) ; save seesaw x position
	addi.w	#$28,x_pos(a0)
	addi.w	#$10,y_pos(a0)
	move.w	y_pos(a0),objoff_34(a0) ; save bottom of seesaw y position
	btst	#status.npc.x_flip,status(a0)
	beq.s	Obj14_Ball_Main
	subi.w	#$50,x_pos(a0)
	move.b	#2,objoff_3A(a0)
; loc_21AFC:
Obj14_Ball_Main:
	bsr.w	Obj14_Animate
	movea.l	objoff_3C(a0),a1 ; a1=parent object (seesaw)
	moveq	#0,d0
	move.b	objoff_3A(a0),d0 ; d0 = ball angle - seesaw angle
	sub.b	objoff_3A(a1),d0
	beq.s	Obj14_SetBallToRestOnSeeSaw
	bcc.s	+
	neg.b	d0
+
	move.w	#-$818,d1
	move.w	#-$114,d2
	cmpi.b	#1,d0
	beq.s	+
	move.w	#-$AF0,d1
	move.w	#-$CC,d2
	cmpi.w	#$A00,objoff_38(a1) ; check if character y_vel that jumped on
	blt.s	+                   ; seesaw > 2560
	move.w	#-$E00,d1
	move.w	#-$A0,d2
+
	move.w	d1,y_vel(a0)
	move.w	d2,x_vel(a0)
	move.w	x_pos(a0),d0
	sub.w	objoff_30(a0),d0
	bcc.s	+
	neg.w	x_vel(a0)
+
	addq.b	#2,routine(a0)
	bra.s	Obj14_Ball_Fly
; ===========================================================================

; loc_21B56:
Obj14_SetBallToRestOnSeeSaw:
	lea	(Obj14_YOffsets).l,a2
	moveq	#0,d0
	move.b	mapping_frame(a1),d0
	move.w	#$28,d2
	move.w	x_pos(a0),d1
	sub.w	objoff_30(a0),d1
	bcc.s	+
	neg.w	d2
	addq.w	#2,d0
+
	add.w	d0,d0
	move.w	objoff_34(a0),d1 ; d1 = bottom of seesaw y position
	add.w	(a2,d0.w),d1     ;    + offset for current angle
	move.w	d1,y_pos(a0)     ; set y position so ball rests on seesaw
	add.w	objoff_30(a0),d2
	move.w	d2,x_pos(a0)
	clr.w	y_sub(a0)
	clr.w	x_sub(a0)
	rts
; ===========================================================================

Obj14_Ball_Fly:

	bsr.w	Obj14_Animate
	tst.w	y_vel(a0)
	bpl.s	loc_21BB6
	jsrto	JmpTo_ObjectMoveAndFall
	move.w	objoff_34(a0),d0 ; d0 = bottom of seesaw y position
	subi.w	#$2F,d0
	cmp.w	y_pos(a0),d0
	bgt.s	return_21BB4
	jsrto	JmpTo_ObjectMoveAndFall

return_21BB4:
	rts
; ===========================================================================

loc_21BB6:
	jsrto	JmpTo_ObjectMoveAndFall
	movea.l	objoff_3C(a0),a1 ; a1=parent object (seesaw)
	lea	(Obj14_YOffsets).l,a2
	moveq	#0,d0
	move.b	mapping_frame(a1),d0
	move.w	x_pos(a0),d1
	sub.w	objoff_30(a0),d1
	bcc.s	+
	addq.w	#2,d0
+
	add.w	d0,d0
	move.w	objoff_34(a0),d1 ; d1 = bottom of seesaw y position
	add.w	(a2,d0.w),d1     ;    + offset for current angle
	cmp.w	y_pos(a0),d1     ; return if y position < d1
	bgt.s	return_21C2A
	movea.l	objoff_3C(a0),a1 ; a1=parent object (seesaw)
	moveq	#2,d1            ; d1 = x_vel >= 0 ? 0 : 2
	tst.w	x_vel(a0)
	bmi.s	+
	moveq	#0,d1
+
	move.b	d1,objoff_3A(a1) ; set seesaw angle to d1
	move.b	d1,objoff_3A(a0) ; set ball angle to d1
	cmp.b	mapping_frame(a1),d1
	beq.s	loc_21C1E

	; launch main character if stood on seesaw
	lea	(MainCharacter).w,a2 ; a2=character
	bclr	#p1_standing_bit,status(a1)
	beq.s	+
	bsr.s	Obj14_LaunchCharacter
+
    ; launch sidekick if stood on seesaw
	lea	(Sidekick).w,a2 ; a2=character
	bclr	#p2_standing_bit,status(a1)
	beq.s	loc_21C1E
	bsr.s	Obj14_LaunchCharacter

loc_21C1E:
	clr.w	x_vel(a0)      ; clear ball velocity
	clr.w	y_vel(a0)
	subq.b	#2,routine(a0) ; set ball to main state

return_21C2A:
	rts
; ===========================================================================

; loc_21C2C:
Obj14_LaunchCharacter:
	move.w	y_vel(a0),y_vel(a2) ; set character y velocity to inverse of sol
	neg.w	y_vel(a2)           ; y velocity
	bset	#status.player.in_air,status(a2)	; set character airborne flag
	bclr	#status.player.on_object,status(a2)	; clear character on object flag
	clr.b	jumping(a2)         ; clear character jumping flag
	move.b	#AniIDSonAni_Spring,anim(a2) ; set character to spring animation
	move.b	#2,routine(a2)      ; set character to airborne state
    if fixBugs
	; If the player charges a Spin Dash on a seesaw, and gets launched by
	; it, they will retain their Spin Dash state in the air. This fixes
	; that.
	clr.b	spindash_flag(a2)
    endif
	move.w	#SndID_Spring,d0    ; play spring sound
	jmp	(PlaySound).l
; ===========================================================================
; heights of the contact point of the ball on the seesaw
; word_21C5C:
Obj14_YOffsets:
	dc.w -8, -28, -47, -28, -8 ; low, balanced, high, balanced, low
; ===========================================================================

; loc_21C66:
Obj14_Animate:
	move.b	(Level_frame_counter+1).w,d0
	andi.b	#3,d0
	bne.s	Obj14_SetSolToFaceMainCharacter
	bchg	#palette_bit_0,art_tile(a0)

Obj14_SetSolToFaceMainCharacter:
	andi.b	#~(1<<render_flags.x_flip),render_flags(a0)
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	x_pos(a0),d0
	bcs.s	return_21C8C
	ori.b	#1<<render_flags.x_flip,render_flags(a0)

return_21C8C:
	rts
; ===========================================================================
byte_21C8E:
	dc.b  20, 20, 22, 24, 26, 28, 26, 24, 22, 20, 19, 18, 17, 16, 15, 14
	dc.b  13, 12, 11, 10,  9,  8,  7,  6,  5,  4,  3,  2,  1,  0, -1, -2
	dc.b  -3, -4, -5, -6, -7, -8, -9,-10,-11,-12,-13,-14,-14,-14,-14,-14
	dc.b -14
	rev02even
byte_21CBF:
	dc.b   5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5
	dc.b   5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5
	dc.b   5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5
	even
