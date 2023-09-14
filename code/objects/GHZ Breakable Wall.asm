; ===========================================================================
; ----------------------------------------------------------------------------
; Object 3C - Breakable wall (leftover from S1) (mostly unused)
; ----------------------------------------------------------------------------
; Sprite_15D44:
Obj3C:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj3C_Index(pc,d0.w),d1
	jsr	Obj3C_Index(pc,d1.w)
	bra.w	MarkObjGone
; ===========================================================================
; off_15D56:
Obj3C_Index:	offsetTable
		offsetTableEntry.w Obj3C_Init		; 0
		offsetTableEntry.w Obj3C_Main		; 2
		offsetTableEntry.w Obj3C_Fragment	; 4
; ===========================================================================
; loc_15D5C:
Obj3C_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj3C_MapUnc_15ECC,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_BreakWall,2,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	move.b	subtype(a0),mapping_frame(a0)
; loc_15D8A:
Obj3C_Main:
	move.w	(MainCharacter+x_vel).w,objoff_30(a0)
	move.w	#$1B,d1
	move.w	#$20,d2
	move.w	#$20,d3
	move.w	x_pos(a0),d4
	bsr.w	SolidObject
	btst	#5,status(a0)
	bne.s	+
-	rts
; ===========================================================================
+
	lea	(MainCharacter).w,a1 ; a1=character
	cmpi.b	#2,anim(a1)
	bne.s	-	; rts
	mvabs.w	objoff_30(a0),d0
	cmpi.w	#$480,d0
	blo.s	-	; rts
	move.w	objoff_30(a0),x_vel(a1)
	addq.w	#4,x_pos(a1)
	lea	(Obj3C_FragmentSpeeds_LeftToRight).l,a4
	move.w	x_pos(a0),d0
	cmp.w	x_pos(a1),d0
	blo.s	+
	subi_.w	#8,x_pos(a1)
	lea	(Obj3C_FragmentSpeeds_RightToLeft).l,a4
+
	move.w	x_vel(a1),inertia(a1)
	bclr	#5,status(a0)
	bclr	#5,status(a1)
	bsr.s	BreakObjectToPieces
; loc_15E02:
Obj3C_Fragment:
	bsr.w	ObjectMove
	addi.w	#$70,y_vel(a0)
	tst.b	render_flags(a0)
	bpl.w	DeleteObject
	bra.w	DisplaySprite

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_15E18:
BreakObjectToPieces:	; splits up one object into its current mapping frame pieces
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	add.w	d0,d0
	movea.l	mappings(a0),a3
	adda.w	(a3,d0.w),a3	; put address of appropriate frame to a3
	move.w	(a3)+,d1	; amount of pieces the frame consists of
	subq.w	#1,d1
	bset	#5,render_flags(a0)
	_move.b	id(a0),d4
	move.b	render_flags(a0),d5
	movea.l	a0,a1
	bra.s	BreakObjectToPieces_InitObject
; ===========================================================================
; loc_15E3E:
BreakObjectToPieces_Loop:
	bsr.w	AllocateObjectAfterCurrent
	bne.s	loc_15E82
	addq.w	#8,a3	; next mapping piece
; loc_15E46:
BreakObjectToPieces_InitObject:
	move.b	#4,routine(a1)
	_move.b	d4,id(a1) ; load object with ID of parent object and routine 4
	move.l	a3,mappings(a1)
	move.b	d5,render_flags(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	priority(a0),priority(a1)
	move.b	width_pixels(a0),width_pixels(a1)
	move.w	(a4)+,x_vel(a1)
	move.w	(a4)+,y_vel(a1)
	dbf	d1,BreakObjectToPieces_Loop

loc_15E82:
	move.w	#SndID_SlowSmash,d0
	jmp	(PlaySound).l
; End of function BreakObjectToPieces

; ===========================================================================
; word_15E8C:
Obj3C_FragmentSpeeds_LeftToRight:
	;    x_vel,y_vel
	dc.w  $400,-$500	; 0
	dc.w  $600,-$100	; 2
	dc.w  $600, $100	; 4
	dc.w  $400, $500	; 6
	dc.w  $600,-$600	; 8
	dc.w  $800,-$200	; 10
	dc.w  $800, $200	; 12
	dc.w  $600, $600	; 14
; word_15EAC:
Obj3C_FragmentSpeeds_RightToLeft:
	dc.w -$600,-$600	; 0
	dc.w -$800,-$200	; 2
	dc.w -$800, $200	; 4
	dc.w -$600, $600	; 6
	dc.w -$400,-$500	; 8
	dc.w -$600,-$100	; 10
	dc.w -$600, $100	; 12
	dc.w -$400, $500	; 14
; -------------------------------------------------------------------------------
; Unused sprite mappings
; -------------------------------------------------------------------------------
Obj3C_MapUnc_15ECC:	include "mappings/sprite/obj3C.asm"
; ===========================================================================
