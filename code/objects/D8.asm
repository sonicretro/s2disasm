; ===========================================================================
; ----------------------------------------------------------------------------
; Object D8 - Block thingy from CNZ that disappears after 3 hits (UFO saucer-shaped)
; ----------------------------------------------------------------------------
; Sprite_2C6AC:
ObjD8:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjD8_Index(pc,d0.w),d1
	jmp	ObjD8_Index(pc,d1.w)
; ===========================================================================
; off_2C6BA:
ObjD8_Index:	offsetTable
		offsetTableEntry.w ObjD8_Init	; 0
		offsetTableEntry.w loc_2C6FC	; 2
		offsetTableEntry.w loc_2C884	; 4
; ===========================================================================
; loc_2C6C0:
ObjD8_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjD8_MapUnc_2C8C4,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZMiniBumper,2,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo56_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#1,priority(a0)
	move.b	#$D7,collision_flags(a0)
	move.b	subtype(a0),d0
	rol.b	#2,d0
	andi.b	#3,d0
	move.b	d0,anim(a0)

loc_2C6FC:
	move.b	collision_property(a0),d0
	bne.w	loc_2C70A
	tst.w	objoff_30(a0)
	beq.s	loc_2C740

loc_2C70A:
	lea	objoff_30(a0),a4
	tst.b	(a4)
	beq.s	loc_2C716
	subq.b	#1,(a4)
	bra.s	loc_2C724
; ===========================================================================

loc_2C716:
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#0,collision_property(a0)
	beq.s	loc_2C724
	bsr.s	loc_2C74E

loc_2C724:
	addq.w	#1,a4
	tst.b	(a4)
	beq.s	loc_2C72E
	subq.b	#1,(a4)
	bra.s	loc_2C73C
; ===========================================================================

loc_2C72E:
	lea	(Sidekick).w,a1 ; a1=character
	bclr	#1,collision_property(a0)
	beq.s	loc_2C73C
	bsr.s	loc_2C74E

loc_2C73C:
	clr.b	collision_property(a0)

loc_2C740:
	lea	(Ani_objD8).l,a1
	jsrto	AnimateSprite, JmpTo12_AnimateSprite
	jmpto	MarkObjGone, JmpTo31_MarkObjGone
; ===========================================================================

loc_2C74E:
	move.b	mapping_frame(a0),d0
	subq.b	#3,d0
	beq.s	loc_2C75C
	bcc.s	loc_2C77A
	addq.b	#3,d0
	bne.s	loc_2C77A

loc_2C75C:
	move.b	#3,anim(a0)
	move.w	#-$700,y_vel(a1)
	move.w	y_pos(a0),d2
	sub.w	y_pos(a1),d2
	bpl.s	BranchTo_loc_2C806
	neg.w	y_vel(a1)

BranchTo_loc_2C806 ; BranchTo
	bra.w	loc_2C806
; ===========================================================================

loc_2C77A:
	subq.b	#1,d0
	bne.s	loc_2C7EC
	move.b	#4,anim(a0)
	move.w	#$20,d3
	btst	#0,status(a0)
	bne.s	loc_2C794
	move.w	#$60,d3

loc_2C794:
	move.w	x_vel(a1),d1
	move.w	y_vel(a1),d2
	jsr	(CalcAngle).l
	sub.w	d3,d0
	mvabs.w	d0,d1
	neg.w	d0
	add.w	d3,d0
	cmpi.b	#$40,d1
	bhs.s	loc_2C7BE
	cmpi.b	#$38,d1
	blo.s	loc_2C7D0
	move.w	d3,d0
	bra.s	loc_2C7D0
; ===========================================================================

loc_2C7BE:
	subi.w	#$80,d1
	neg.w	d1
	cmpi.b	#$38,d1
	blo.s	loc_2C7D0
	move.w	d3,d0
	addi.w	#$80,d0

loc_2C7D0:
	jsr	(CalcSine).l
	muls.w	#-$700,d1
	asr.l	#8,d1
	move.w	d1,x_vel(a1)
	muls.w	#-$700,d0
	asr.l	#8,d0
	move.w	d0,y_vel(a1)
	bra.s	loc_2C806
; ===========================================================================

loc_2C7EC:
	move.b	#5,anim(a0)
	move.w	#-$700,x_vel(a1)
	move.w	x_pos(a0),d2
	sub.w	x_pos(a1),d2
	bpl.s	loc_2C806
	neg.w	x_vel(a1)

loc_2C806:
	bset	#1,status(a1)
	bclr	#4,status(a1)
	bclr	#5,status(a1)
	clr.b	jumping(a1)
	move.w	#SndID_BonusBumper,d0
	jsr	(PlaySound).l
	movea.w	a1,a3
	moveq	#4,d3
	moveq	#1,d0
	subi.w	#palette_line_1,art_tile(a0)
	bcc.s	loc_2C85C
	addi.w	#palette_line_1,art_tile(a0)
	move.b	#4,routine(a0)
	lea	(CNZ_saucer_data).w,a1
	move.b	subtype(a0),d1
	andi.w	#$3F,d1		; This means CNZ_saucer_data is only $40 bytes large
	lea	(a1,d1.w),a1
	addq.b	#1,(a1)
	cmpi.b	#3,(a1)
	blo.s	loc_2C85C
	moveq	#2,d3
	moveq	#50,d0

loc_2C85C:
	jsr	(AddPoints2).l
	jsrto	AllocateObject, JmpTo11_AllocateObject
	bne.s	loc_2C87E
	_move.b	#ObjID_Points,id(a1) ; load obj29
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	d3,mapping_frame(a1)

loc_2C87E:
	move.b	#4,(a4)
	rts
; ===========================================================================

loc_2C884:
	lea	(Ani_objD8).l,a1
	jsrto	AnimateSprite, JmpTo12_AnimateSprite
	cmpi.b	#3,anim(a0)
	blo.w	JmpTo46_DeleteObject
	jmpto	MarkObjGone, JmpTo31_MarkObjGone

    if removeJmpTos
JmpTo46_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
; animation script
; off_2C89C:
Ani_objD8:	offsetTable
		offsetTableEntry.w byte_2C8A8	; 0
		offsetTableEntry.w byte_2C8AB	; 1
		offsetTableEntry.w byte_2C8AE	; 2
		offsetTableEntry.w byte_2C8B1	; 3
		offsetTableEntry.w byte_2C8B7	; 4
		offsetTableEntry.w byte_2C8BD	; 5
byte_2C8A8:	dc.b  $F,  0,$FF
	rev02even
byte_2C8AB:	dc.b  $F,  1,$FF
	rev02even
byte_2C8AE:	dc.b  $F,  2,$FF
	rev02even
byte_2C8B1:	dc.b   3,  3,  0,  3,$FD,  0
	rev02even
byte_2C8B7:	dc.b   3,  4,  1,  4,$FD,  1
	rev02even
byte_2C8BD:	dc.b   3,  5,  2,  5,$FD,  2
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjD8_MapUnc_2C8C4:	include "mappings/sprite/objD8.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo46_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo11_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
JmpTo31_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo12_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo56_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
