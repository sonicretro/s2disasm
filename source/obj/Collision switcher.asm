; ----------------------------------------------------------------------------
; Object 03 - Collision plane/layer switcher
; ----------------------------------------------------------------------------
; Sprite_1FCDC:
Obj03:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj03_Index(pc,d0.w),d1
	jsr	Obj03_Index(pc,d1.w)
	jmp	(MarkObjGone3).l
; ===========================================================================
; off_1FCF0:
Obj03_Index:	offsetTable
		offsetTableEntry.w Obj03_Init	; 0
		offsetTableEntry.w Obj03_MainX	; 2
		offsetTableEntry.w Obj03_MainY	; 4
; ===========================================================================
; loc_1FCF6:
Obj03_Init:
	addq.b	#2,routine(a0) ; => Obj03_MainX
	move.l	#Obj03_MapUnc_1FFB8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,1,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo7_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#5,priority(a0)
	move.b	subtype(a0),d0
	btst	#2,d0
	beq.s	Obj03_Init_CheckX
;Obj03_Init_CheckY:
	addq.b	#2,routine(a0) ; => Obj03_MainY
	andi.w	#7,d0
	move.b	d0,mapping_frame(a0)
	andi.w	#3,d0
	add.w	d0,d0
	move.w	word_1FD68(pc,d0.w),objoff_32(a0)
	move.w	y_pos(a0),d1
	lea	(MainCharacter).w,a1 ; a1=character
	cmp.w	y_pos(a1),d1
	bhs.s	+
	move.b	#1,objoff_34(a0)
+
	lea	(Sidekick).w,a1 ; a1=character
	cmp.w	y_pos(a1),d1
	bhs.s	+
	move.b	#1,objoff_35(a0)
+
	bra.w	Obj03_MainY
; ===========================================================================
word_1FD68:
	dc.w   $20
	dc.w   $40	; 1
	dc.w   $80	; 2
	dc.w  $100	; 3
; ===========================================================================
; loc_1FD70:
Obj03_Init_CheckX:
	andi.w	#3,d0
	move.b	d0,mapping_frame(a0)
	add.w	d0,d0
	move.w	word_1FD68(pc,d0.w),objoff_32(a0)
	move.w	x_pos(a0),d1
	lea	(MainCharacter).w,a1 ; a1=character
	cmp.w	x_pos(a1),d1
	bhs.s	+
	move.b	#1,objoff_34(a0)
+
	lea	(Sidekick).w,a1 ; a1=character
	cmp.w	x_pos(a1),d1
	bhs.s	+
	move.b	#1,objoff_35(a0)
+

; loc_1FDA4:
Obj03_MainX:
	tst.w	(Debug_placement_mode).w
	bne.w	return_1FEAC
	move.w	x_pos(a0),d1
	lea	objoff_34(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	+
	lea	(Sidekick).w,a1 ; a1=character

+	tst.b	(a2)+
	bne.s	Obj03_MainX_Alt
	cmp.w	x_pos(a1),d1
	bhi.w	return_1FEAC
	move.b	#1,-1(a2)
	move.w	y_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	y_pos(a1),d4
	cmp.w	d2,d4
	blt.w	return_1FEAC
	cmp.w	d3,d4
	bge.w	return_1FEAC
	move.b	subtype(a0),d0
	bpl.s	+
	btst	#1,status(a1)
	bne.w	return_1FEAC
+
	btst	#0,render_flags(a0)
	bne.s	+
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)
	btst	#3,d0
	beq.s	+
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)
+
	andi.w	#drawing_mask,art_tile(a1)
	btst	#5,d0
	beq.s	return_1FEAC
	ori.w	#high_priority,art_tile(a1)
	bra.s	return_1FEAC
; ===========================================================================
; loc_1FE38:
Obj03_MainX_Alt:
	cmp.w	x_pos(a1),d1
	bls.w	return_1FEAC
	move.b	#0,-1(a2)
	move.w	y_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	y_pos(a1),d4
	cmp.w	d2,d4
	blt.w	return_1FEAC
	cmp.w	d3,d4
	bge.w	return_1FEAC
	move.b	subtype(a0),d0
	bpl.s	+
	btst	#1,status(a1)
	bne.w	return_1FEAC
+
	btst	#0,render_flags(a0)
	bne.s	+
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)
	btst	#4,d0
	beq.s	+
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)
+
	andi.w	#drawing_mask,art_tile(a1)
	btst	#6,d0
	beq.s	return_1FEAC
	ori.w	#high_priority,art_tile(a1)

return_1FEAC:
	rts
; ===========================================================================

Obj03_MainY:
	tst.w	(Debug_placement_mode).w
	bne.w	return_1FFB6
	move.w	y_pos(a0),d1
	lea	objoff_34(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	+
	lea	(Sidekick).w,a1 ; a1=character

+	tst.b	(a2)+
	bne.s	Obj03_MainY_Alt
	cmp.w	y_pos(a1),d1
	bhi.w	return_1FFB6
	move.b	#1,-1(a2)
	move.w	x_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	x_pos(a1),d4
	cmp.w	d2,d4
	blt.w	return_1FFB6
	cmp.w	d3,d4
	bge.w	return_1FFB6
	move.b	subtype(a0),d0
	bpl.s	+
	btst	#1,status(a1)
	bne.w	return_1FFB6
+
	btst	#0,render_flags(a0)
	bne.s	+
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)
	btst	#3,d0
	beq.s	+
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)
+
	andi.w	#drawing_mask,art_tile(a1)
	btst	#5,d0
	beq.s	return_1FFB6
	ori.w	#high_priority,art_tile(a1)
	bra.s	return_1FFB6
; ===========================================================================
; loc_1FF42:
Obj03_MainY_Alt:
	cmp.w	y_pos(a1),d1
	bls.w	return_1FFB6
	move.b	#0,-1(a2)
	move.w	x_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	x_pos(a1),d4
	cmp.w	d2,d4
	blt.w	return_1FFB6
	cmp.w	d3,d4
	bge.w	return_1FFB6
	move.b	subtype(a0),d0
	bpl.s	+
	btst	#1,status(a1)
	bne.w	return_1FFB6
+
	btst	#0,render_flags(a0)
	bne.s	+
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)
	btst	#4,d0
	beq.s	+
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)
+
	andi.w	#drawing_mask,art_tile(a1)
	btst	#6,d0
	beq.s	return_1FFB6
	ori.w	#high_priority,art_tile(a1)

return_1FFB6:
	rts
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj03_MapUnc_1FFB8:	BINCLUDE "mappings/sprite/obj03.bin"
; ===========================================================================

    if ~~removeJmpTos
JmpTo7_Adjust2PArtPointer 
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
