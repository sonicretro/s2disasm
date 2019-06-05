; ----------------------------------------------------------------------------
; Object 7D - Points that can be gotten at the end of an act (leftover from S1)  (unused)
; ----------------------------------------------------------------------------
; Sprite_1F624:
Obj7D:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj7D_Index(pc,d0.w),d1
	jmp	Obj7D_Index(pc,d1.w)
; ===========================================================================
; off_1F632: Obj7D_States:
Obj7D_Index:	offsetTable
		offsetTableEntry.w Obj7D_Init	; 0
		offsetTableEntry.w Obj7D_Main	; 2
; ===========================================================================
; loc_1F636:
Obj7D_Init:
	moveq	#$10,d2
	move.w	d2,d3
	add.w	d3,d3
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d2,d0
	cmp.w	d3,d0
	bhs.s	Obj7D_NoAdd
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	add.w	d2,d1
	cmp.w	d3,d1
	bhs.s	Obj7D_NoAdd
	tst.w	(Debug_placement_mode).w
	bne.s	Obj7D_NoAdd
	tst.b	(SpecialStage_flag_2P).w
	bne.s	Obj7D_NoAdd
	addq.b	#2,routine(a0)
	move.l	#Obj7D_MapUnc_1F6FE,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_EndPoints,0,1),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo4_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#0,priority(a0)
	move.b	#$10,width_pixels(a0)
	move.b	subtype(a0),mapping_frame(a0)
	move.w	#$77,objoff_30(a0)
	move.w	#SndID_Bonus,d0
	jsr	(PlaySound).l
	moveq	#0,d0
	move.b	subtype(a0),d0
	add.w	d0,d0
	move.w	word_1F6D2(pc,d0.w),d0
	jsr	(AddPoints).l

Obj7D_NoAdd:
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	JmpTo11_DeleteObject
	rts
; ===========================================================================

JmpTo11_DeleteObject 
	jmp	(DeleteObject).l
; ===========================================================================
word_1F6D2:
	dc.w	 0
	dc.w  1000	; 1
	dc.w   100	; 2
	dc.w	 1	; 3
; ===========================================================================
; loc_1F6DA:
Obj7D_Main:
	subq.w	#1,objoff_30(a0)
	bmi.s	JmpTo12_DeleteObject
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	JmpTo12_DeleteObject
	jmp	(DisplaySprite).l
; ===========================================================================

JmpTo12_DeleteObject 
	jmp	(DeleteObject).l
; ===========================================================================
; -------------------------------------------------------------------------------
; Unused sprite mappings
; -------------------------------------------------------------------------------
Obj7D_MapUnc_1F6FE:	BINCLUDE "mappings/sprite/obj7D.bin"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo4_Adjust2PArtPointer 
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
