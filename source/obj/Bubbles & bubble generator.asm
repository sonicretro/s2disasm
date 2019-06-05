; ----------------------------------------------------------------------------
; Object 24 - Bubbles in Aquatic Ruin Zone
; ----------------------------------------------------------------------------
; Sprite_1F8A8:
Obj24:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj24_Index(pc,d0.w),d1
	jmp	Obj24_Index(pc,d1.w)
; ===========================================================================
; off_1F8B6:
Obj24_Index:	offsetTable
		offsetTableEntry.w Obj24_Init				;  0
		offsetTableEntry.w loc_1F924				;  2
		offsetTableEntry.w loc_1F93E				;  4
		offsetTableEntry.w loc_1F99E				;  6
		offsetTableEntry.w BranchTo_JmpTo15_DeleteObject	;  8
		offsetTableEntry.w loc_1F9C0				; $A
; ===========================================================================
; loc_1F8C2:
Obj24_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj24_MapUnc_1FBF6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_BigBubbles,0,1),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo6_Adjust2PArtPointer
	move.b	#$84,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#1,priority(a0)
	move.b	subtype(a0),d0
	bpl.s	loc_1F90A
	addq.b	#8,routine(a0)
	andi.w	#$7F,d0
	move.b	d0,objoff_32(a0)
	move.b	d0,objoff_33(a0)
	move.b	#6,anim(a0)
	bra.w	loc_1F9C0
; ===========================================================================

loc_1F90A:
	move.b	d0,anim(a0)
	move.w	x_pos(a0),objoff_30(a0)
	move.w	#-$88,y_vel(a0)
	jsr	(RandomNumber).l
	move.b	d0,angle(a0)

loc_1F924:
	lea	(Ani_obj24).l,a1
	jsr	(AnimateSprite).l
	cmpi.b	#6,mapping_frame(a0)
	bne.s	loc_1F93E
	move.b	#1,objoff_2E(a0)

loc_1F93E:

	move.w	(Water_Level_1).w,d0
	cmp.w	y_pos(a0),d0
	blo.s	loc_1F956
	move.b	#6,routine(a0)
	addq.b	#3,anim(a0)
	bra.w	loc_1F99E
; ===========================================================================

loc_1F956:
	move.b	angle(a0),d0
	addq.b	#1,angle(a0)
	andi.w	#$7F,d0
	lea	(Obj0A_WobbleData).l,a1
	move.b	(a1,d0.w),d0
	ext.w	d0
	add.w	objoff_30(a0),d0
	move.w	d0,x_pos(a0)
	tst.b	objoff_2E(a0)
	beq.s	loc_1F988
	bsr.w	loc_1FB02
	cmpi.b	#6,routine(a0)
	beq.s	loc_1F99E

loc_1F988:
	jsrto	(ObjectMove).l, JmpTo3_ObjectMove
	tst.b	render_flags(a0)
	bpl.s	JmpTo13_DeleteObject
	jmp	(DisplaySprite).l
; ===========================================================================

JmpTo13_DeleteObject 
	jmp	(DeleteObject).l
; ===========================================================================

loc_1F99E:

	lea	(Ani_obj24).l,a1
	jsr	(AnimateSprite).l
	tst.b	render_flags(a0)
	bpl.s	JmpTo14_DeleteObject
	jmp	(DisplaySprite).l
; ===========================================================================

JmpTo14_DeleteObject 
	jmp	(DeleteObject).l
; ===========================================================================

    if removeJmpTos
JmpTo15_DeleteObject 
    endif

BranchTo_JmpTo15_DeleteObject 
	jmpto	(DeleteObject).l, JmpTo15_DeleteObject
; ===========================================================================

loc_1F9C0:

	tst.w	objoff_36(a0)
	bne.s	loc_1FA22
	move.w	(Water_Level_1).w,d0
	cmp.w	y_pos(a0),d0
	bhs.w	loc_1FACE
	tst.b	render_flags(a0)
	bpl.w	loc_1FACE
	subq.w	#1,objoff_38(a0)
	bpl.w	loc_1FAC2
	move.w	#1,objoff_36(a0)

loc_1F9E8:
	jsr	(RandomNumber).l
	move.w	d0,d1
	andi.w	#7,d0
	cmpi.w	#6,d0
	bhs.s	loc_1F9E8
	move.b	d0,objoff_34(a0)
	andi.w	#$C,d1
	lea	(byte_1FAF0).l,a1
	adda.w	d1,a1
	move.l	a1,objoff_3C(a0)
	subq.b	#1,objoff_32(a0)
	bpl.s	BranchTo_loc_1FA2A
	move.b	objoff_33(a0),objoff_32(a0)
	bset	#7,objoff_36(a0)

BranchTo_loc_1FA2A 
	bra.s	loc_1FA2A
; ===========================================================================

loc_1FA22:
	subq.w	#1,objoff_38(a0)
	bpl.w	loc_1FAC2

loc_1FA2A:
	jsr	(RandomNumber).l
	andi.w	#$1F,d0
	move.w	d0,objoff_38(a0)
	bsr.w	SingleObjLoad
	bne.s	loc_1FAA6
	_move.b	id(a0),id(a1) ; load obj24
	move.w	x_pos(a0),x_pos(a1)
	jsr	(RandomNumber).l
	andi.w	#$F,d0
	subq.w	#8,d0
	add.w	d0,x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	moveq	#0,d0
	move.b	objoff_34(a0),d0
	movea.l	objoff_3C(a0),a2 ; a2=object
	move.b	(a2,d0.w),subtype(a1)
	btst	#7,objoff_36(a0)
	beq.s	loc_1FAA6
	jsr	(RandomNumber).l
	andi.w	#3,d0
	bne.s	loc_1FA92
	bset	#6,objoff_36(a0)
	bne.s	loc_1FAA6
	move.b	#2,subtype(a1)

loc_1FA92:
	tst.b	objoff_34(a0)
	bne.s	loc_1FAA6
	bset	#6,objoff_36(a0)
	bne.s	loc_1FAA6
	move.b	#2,subtype(a1)

loc_1FAA6:
	subq.b	#1,objoff_34(a0)
	bpl.s	loc_1FAC2
	jsr	(RandomNumber).l
	andi.w	#$7F,d0
	addi.w	#$80,d0
	add.w	d0,objoff_38(a0)
	clr.w	objoff_36(a0)

loc_1FAC2:
	lea	(Ani_obj24).l,a1
	jsr	(AnimateSprite).l

loc_1FACE:
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo15_DeleteObject
	move.w	(Water_Level_1).w,d0
	cmp.w	y_pos(a0),d0
	blo.w	JmpTo7_DisplaySprite
	rts

    if removeJmpTos
JmpTo7_DisplaySprite 
	jmp	(DisplaySprite).l
    endif
; ===========================================================================
byte_1FAF0:
	dc.b   0
	dc.b   1	; 1
	dc.b   0	; 2
	dc.b   0	; 3
	dc.b   0	; 4
	dc.b   0	; 5
	dc.b   1	; 6
	dc.b   0	; 7
	dc.b   0	; 8
	dc.b   0	; 9
	dc.b   0	; 10
	dc.b   1	; 11
	dc.b   0	; 12
	dc.b   1	; 13
	dc.b   0	; 14
	dc.b   0	; 15
	dc.b   1	; 16
	dc.b   0	; 17
; ===========================================================================

loc_1FB02:
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_1FB0C
	lea	(Sidekick).w,a1 ; a1=character

loc_1FB0C:
	tst.b	obj_control(a1)
	bmi.w	return_1FBCA
	move.w	x_pos(a1),d0
	move.w	x_pos(a0),d1
	subi.w	#$10,d1
	cmp.w	d0,d1
	bhs.w	return_1FBCA
	addi.w	#$20,d1
	cmp.w	d0,d1
	blo.w	return_1FBCA
	move.w	y_pos(a1),d0
	move.w	y_pos(a0),d1
	cmp.w	d0,d1
	bhs.w	return_1FBCA
	addi.w	#$10,d1
	cmp.w	d0,d1
	blo.w	return_1FBCA
	bsr.w	ResumeMusic
	move.w	#SndID_InhalingBubble,d0
	jsr	(PlaySound).l
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	clr.w	inertia(a1)
	move.b	#AniIDSonAni_Bubble,anim(a1)
	move.w	#$23,move_lock(a1)
	move.b	#0,jumping(a1)
	bclr	#5,status(a1)
	bclr	#4,status(a1)
	btst	#2,status(a1)
	beq.w	loc_1FBB8
	cmpi.b	#1,(a1)
	bne.s	loc_1FBA8
	bclr	#2,status(a1)
	move.b	#$13,y_radius(a1)
	move.b	#9,x_radius(a1)
	subq.w	#5,y_pos(a1)
	bra.s	loc_1FBB8
; ===========================================================================

loc_1FBA8:
	move.b	#$F,y_radius(a1)
	move.b	#9,x_radius(a1)
	subq.w	#1,y_pos(a1)

loc_1FBB8:
	cmpi.b	#6,routine(a0)
	beq.s	return_1FBCA
	move.b	#6,routine(a0)
	addq.b	#3,anim(a0)

return_1FBCA:
	rts
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite animations
; -------------------------------------------------------------------------------
; animation script
; off_1FBCC:
Ani_obj24:	offsetTable
		offsetTableEntry.w byte_1FBDA	; 0
		offsetTableEntry.w byte_1FBDF	; 1
		offsetTableEntry.w byte_1FBE5	; 2
		offsetTableEntry.w byte_1FBEC	; 3
		offsetTableEntry.w byte_1FBEC	; 4
		offsetTableEntry.w byte_1FBEE	; 5
		offsetTableEntry.w byte_1FBF2	; 6
byte_1FBDA:	dc.b  $E,  0,  1,  2,$FC
		rev02even
byte_1FBDF:	dc.b  $E,  1,  2,  3,  4,$FC
		rev02even
byte_1FBE5:	dc.b  $E,  2,  3,  4,  5,  6,$FC
		rev02even
byte_1FBEC:	dc.b   4,$FC
		rev02even
byte_1FBEE:	dc.b   4,  6,  7,$FC
		rev02even
byte_1FBF2:	dc.b  $F, $E, $F,$FF
		even
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj24_MapUnc_1FBF6: offsetTable
	offsetTableEntry.w word_1FC3A	;   0
	offsetTableEntry.w word_1FC44	;   1
	offsetTableEntry.w word_1FC44	;   2
	offsetTableEntry.w word_1FC4E	;   3
	offsetTableEntry.w word_1FC58	;   4
	offsetTableEntry.w word_1FC62	;   5
	offsetTableEntry.w word_1FC6C	;   6
	offsetTableEntry.w word_1FC76	;   7
	offsetTableEntry.w word_1FC98	;   8
	offsetTableEntry.w word_1FC98	;   9
	offsetTableEntry.w word_1FC98	;  $A
	offsetTableEntry.w word_1FC98	;  $B
	offsetTableEntry.w word_1FC98	;  $C
	offsetTableEntry.w word_1FC98	;  $D
	offsetTableEntry.w word_1FCA2	;  $E
	offsetTableEntry.w word_1FCAC	;  $F
	offsetTableEntry.w word_1FCB6	; $10
; -------------------------------------------------------------------------------
; sprite mappings
; merged with the above mappings, can't split to file in a useful way...
; -------------------------------------------------------------------------------
Obj24_MapUnc_1FC18: offsetTable
	offsetTableEntry.w word_1FC3A	;   0
	offsetTableEntry.w word_1FC44	;   1
	offsetTableEntry.w word_1FC44	;   2
	offsetTableEntry.w word_1FC4E	;   3
	offsetTableEntry.w word_1FC58	;   4
	offsetTableEntry.w word_1FC62	;   5
	offsetTableEntry.w word_1FC6C	;   6
	offsetTableEntry.w word_1FC76	;   7
	offsetTableEntry.w word_1FCB8	;   8
	offsetTableEntry.w word_1FCB8	;   9
	offsetTableEntry.w word_1FCB8	;  $A
	offsetTableEntry.w word_1FCB8	;  $B
	offsetTableEntry.w word_1FCB8	;  $C
	offsetTableEntry.w word_1FCB8	;  $D
	offsetTableEntry.w word_1FCA2	;  $E
	offsetTableEntry.w word_1FCAC	;  $F
	offsetTableEntry.w word_1FCB6	; $10
word_1FC3A:                          
	dc.w	1
	dc.w	$FC00, $008D, $0046, $FFFC
word_1FC44:
	dc.w	1
	dc.w	$FC00, $008E, $0047, $FFFC
word_1FC4E:
	dc.w	1
	dc.w	$F805, $008F, $0047, $FFF8
word_1FC58:
	dc.w	1
	dc.w	$F805, $0093, $0049, $FFF8
word_1FC62:
	dc.w	1
	dc.w	$F40A, $001C, $000E, $FFF4
word_1FC6C:
	dc.w	1
	dc.w	$F00F, $0008, $0004, $FFF0
word_1FC76:
	dc.w	4
	dc.w	$F005, $0018, $000C, $FFF0
	dc.w	$F005, $0818, $080C, $0000
	dc.w	$0005, $1018, $100C, $FFF0
	dc.w	$0005, $1818, $180C, $0000
word_1FC98:
	dc.w	1
	dc.w	$F406, $1F41, $1BA0, $FFF8
word_1FCA2:
	dc.w	1
	dc.w	$F805, $0000, $0000, $FFF8
word_1FCAC:
	dc.w	1
	dc.w	$F805, $0004, $0002, $FFF8
word_1FCB6:
	dc.w	0
word_1FCB8:
	dc.w	1
	dc.w	$F406, $1F31, $1B98, $FFF8
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo7_DisplaySprite 
	jmp	(DisplaySprite).l
JmpTo15_DeleteObject 
	jmp	(DeleteObject).l
JmpTo6_Adjust2PArtPointer 
	jmp	(Adjust2PArtPointer).l
; loc_1FCD6:
JmpTo3_ObjectMove 
	jmp	(ObjectMove).l

	align 4
    endif
