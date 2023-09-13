; ===========================================================================
; ----------------------------------------------------------------------------
; Object 48 - Round ball thing from OOZ that fires you off in a different direction (sphere)
; ----------------------------------------------------------------------------
; Sprite_25244:
Obj48:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj48_Index(pc,d0.w),d1
	jsr	Obj48_Index(pc,d1.w)
	move.b	objoff_2C(a0),d0
	add.b	objoff_36(a0),d0
	beq.w	JmpTo14_MarkObjGone
	jmpto	DisplaySprite, JmpTo15_DisplaySprite

    if removeJmpTos
JmpTo14_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
    endif
; ===========================================================================
; off_25262:
Obj48_Index:	offsetTable
		offsetTableEntry.w Obj48_Init	; 0
		offsetTableEntry.w Obj48_Main	; 2
; ===========================================================================
; byte_25266:
Obj48_Properties:
	;      render_flags
	;	   objoff_3F
	dc.b   4,  0	; 0
	dc.b   6,  7	; 2
	dc.b   7,  0	; 4
	dc.b   5,  7	; 6
	dc.b   5,  0	; 8
	dc.b   4,  7	; 10
	dc.b   6,  0	; 12
	dc.b   7,  7	; 14
; ===========================================================================
; loc_25276:
Obj48_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj48_MapUnc_254FE,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_LaunchBall,3,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo23_Adjust2PArtPointer
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	btst	#0,status(a0)
	beq.s	+
	addq.w	#4,d0
+
	add.w	d0,d0
	move.b	Obj48_Properties(pc,d0.w),render_flags(a0)
	move.b	Obj48_Properties+1(pc,d0.w),objoff_3F(a0)
	beq.s	+
	move.b	#1,objoff_3E(a0)
+
	move.b	objoff_3F(a0),mapping_frame(a0)
	move.b	#$28,width_pixels(a0)
	move.b	#1,priority(a0)
; loc_252C6:
Obj48_Main:
	lea	(MainCharacter).w,a1 ; a1=character
	lea	objoff_2C(a0),a4
	moveq	#objoff_2C,d2
	bsr.s	loc_252DC
	lea	(Sidekick).w,a1 ; a1=character
	lea	objoff_36(a0),a4
	moveq	#objoff_36,d2

loc_252DC:
	moveq	#0,d0
	move.b	(a4),d0
	move.w	Obj48_Modes(pc,d0.w),d0
	jmp	Obj48_Modes(pc,d0.w)
; ===========================================================================
; off_252E8:
Obj48_Modes:	offsetTable
		offsetTableEntry.w loc_252F0	; 0
		offsetTableEntry.w loc_253C6	; 2
		offsetTableEntry.w loc_25474	; 4
		offsetTableEntry.w loc_254F2	; 6
; ===========================================================================

loc_252F0:
	tst.w	(Debug_placement_mode).w
	bne.w	return_253C4
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$10,d0
	cmpi.w	#$20,d0
	bhs.w	return_253C4
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	addi.w	#$10,d1
	cmpi.w	#$20,d1
	bhs.w	return_253C4
	cmpa.w	#Sidekick,a1
	bne.s	+
	cmpi.w	#4,(Tails_CPU_routine).w	; TailsCPU_Flying
	beq.w	return_253C4
+
	cmpi.b	#6,routine(a1)
	bhs.w	return_253C4
	tst.w	(Debug_placement_mode).w
	bne.w	return_253C4
	btst	#3,status(a1)
	beq.s	+
	moveq	#0,d0
	move.b	interact(a1),d0
    if object_size=$40
	lsl.w	#object_size_bits,d0
    else
	mulu.w	#object_size,d0
    endif
	addi.l	#Object_RAM,d0
	movea.l	d0,a3	; a3=object
	move.b	#0,(a3,d2.w)
+
    if object_size<>$40
	moveq	#0,d0 ; Clear the high word for the coming division.
    endif
	move.w	a0,d0
	subi.w	#Object_RAM,d0
    if object_size=$40
	lsr.w	#object_size_bits,d0
    else
	divu.w	#object_size,d0
    endif
	andi.w	#$7F,d0
	move.b	d0,interact(a1)
	addq.b	#2,(a4)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#$81,obj_control(a1)
	move.b	#2,anim(a1)
	move.w	#$1000,inertia(a1)
	move.w	#0,x_vel(a1)
	move.w	#0,y_vel(a1)
	bclr	#5,status(a0)
	bclr	#5,status(a1)
	bset	#1,status(a1)
	bset	#3,status(a1)
	move.b	objoff_3F(a0),mapping_frame(a0)
	move.w	#SndID_Roll,d0
	jsr	(PlaySound).l

return_253C4:
	rts
; ===========================================================================

loc_253C6:
	tst.b	objoff_3E(a0)
	bne.s	loc_253EE
	cmpi.b	#7,mapping_frame(a0)
	beq.s	loc_25408
	subq.w	#1,anim_frame_duration(a0)
	bpl.s	return_253EC
	move.w	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#7,mapping_frame(a0)
	beq.s	loc_25408

return_253EC:
	rts
; ===========================================================================

loc_253EE:
	tst.b	mapping_frame(a0)
	beq.s	loc_25408
	subq.w	#1,anim_frame_duration(a0)
	bpl.s	return_253EC
	move.w	#7,anim_frame_duration(a0)
	subq.b	#1,mapping_frame(a0)
	beq.s	loc_25408
	rts
; ===========================================================================

loc_25408:
	addq.b	#2,(a4)
	move.b	subtype(a0),d0
	addq.b	#1,d0
	btst	#0,status(a0)
	beq.s	+
	subq.b	#2,d0
+
	andi.w	#3,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	word_25464(pc,d0.w),x_vel(a1)
	move.w	word_25464+2(pc,d0.w),y_vel(a1)
	move.w	#3,anim_frame_duration(a0)
	tst.b	subtype(a0)
	bpl.s	return_25462
	move.b	#0,obj_control(a1)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#0,jumping(a1)
	move.b	#2,routine(a1)
	move.b	#6,(a4)
	move.w	#7,objoff_3C(a0)

return_25462:
	rts
; ===========================================================================
word_25464:
	dc.w	  0,-$1000
	dc.w  $1000,     0	; 2
	dc.w	  0, $1000	; 4
	dc.w -$1000,     0	; 6
; ===========================================================================

loc_25474:
	tst.b	render_flags(a1)
	bmi.s	loc_25492
	move.b	#0,obj_control(a1)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#0,(a4)
	rts
; ===========================================================================

loc_25492:
	cmpi.b	#2,objoff_2C(a0)
	beq.s	Obj48_MoveCharacter
	cmpi.b	#2,objoff_36(a0)
	beq.s	Obj48_MoveCharacter
	subq.w	#1,anim_frame_duration(a0)
	bpl.s	Obj48_MoveCharacter
	move.w	#1,anim_frame_duration(a0)
	tst.b	objoff_3E(a0)
	beq.s	loc_254C2
	cmpi.b	#7,mapping_frame(a0)
	beq.s	Obj48_MoveCharacter
	addq.b	#1,mapping_frame(a0)
	bra.s	Obj48_MoveCharacter
; ===========================================================================

loc_254C2:
	tst.b	mapping_frame(a0)
	beq.s	Obj48_MoveCharacter
	subq.b	#1,mapping_frame(a0)

; update the position of Sonic/Tails between launchers
; loc_254CC:
Obj48_MoveCharacter:
	move.l	x_pos(a1),d2
	move.l	y_pos(a1),d3
	move.w	x_vel(a1),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d2
	move.w	y_vel(a1),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d2,x_pos(a1)
	move.l	d3,y_pos(a1)
	rts
; ===========================================================================

loc_254F2:
	subq.w	#1,objoff_3C(a0)
	bpl.s	+	; rts
	move.b	#0,(a4)
+
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj48_MapUnc_254FE:	include "mappings/sprite/obj48.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo15_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo14_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo23_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
