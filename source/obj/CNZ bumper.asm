; ----------------------------------------------------------------------------
; Object 44 - Round bumper from Casino Night Zone
; ----------------------------------------------------------------------------
; Sprite_1F730:
Obj44:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj44_Index(pc,d0.w),d1
	jmp	Obj44_Index(pc,d1.w)
; ===========================================================================
; off_1F73E: Obj44_States:
Obj44_Index:	offsetTable
		offsetTableEntry.w Obj44_Init	; 0
		offsetTableEntry.w Obj44_Main	; 2
; ===========================================================================
; loc_1F742:
Obj44_Init:
	addq.b	#2,routine(a0) ; => Obj44_Main
	move.l	#Obj44_MapUnc_1F85A,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZRoundBumper,2,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo5_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#1,priority(a0)
	move.b	#$D7,collision_flags(a0)

; loc_1F770:
Obj44_Main:
	move.b	collision_property(a0),d0
	beq.w	loc_1F83E
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#0,collision_property(a0)
	beq.s	+
	bsr.s	Obj44_BumpCharacter
+
	lea	(Sidekick).w,a1 ; a1=character
	bclr	#1,collision_property(a0)
	beq.s	+
	bsr.s	Obj44_BumpCharacter
+
	clr.b	collision_property(a0)
	bra.w	loc_1F83E
; ===========================================================================
; loc_1F79C:
Obj44_BumpCharacter:
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
	move.b	#1,anim(a0)
	move.w	#SndID_Bumper,d0
	jsr	(PlaySound).l
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	cmpi.b	#$8A,2(a2,d0.w)
	bhs.s	return_1F83C
	addq.b	#1,2(a2,d0.w)
+
	moveq	#1,d0
	movea.w	a1,a3
	jsr	(AddPoints2).l
	bsr.w	SingleObjLoad
	bne.s	return_1F83C
	_move.b	#ObjID_Points,id(a1) ; load obj29
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#4,mapping_frame(a1)

return_1F83C:
	rts
; ===========================================================================

loc_1F83E:
	lea	(Ani_obj44).l,a1
	jsrto	(AnimateSprite).l, JmpTo3_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo2_MarkObjGone
; ===========================================================================
; animation script
; off_1F84C:
Ani_obj44:	offsetTable
		offsetTableEntry.w byte_1F850	; 0
		offsetTableEntry.w byte_1F853	; 1
byte_1F850:	dc.b  $F,  0,$FF
		rev02even
byte_1F853:	dc.b   3,  1,  0,  1,$FD,  0
		even
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj44_MapUnc_1F85A:	BINCLUDE "mappings/sprite/obj44.bin"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo2_MarkObjGone 
	jmp	(MarkObjGone).l
JmpTo3_AnimateSprite 
	jmp	(AnimateSprite).l
JmpTo5_Adjust2PArtPointer 
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
