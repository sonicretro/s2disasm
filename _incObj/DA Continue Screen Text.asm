; ===========================================================================
; ----------------------------------------------------------------------------
; Object DA - Continue text
; ----------------------------------------------------------------------------
; loc_7A68:
ObjDA: ; (screen-space obj)
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjDA_Index(pc,d0.w),d1
	jmp	ObjDA_Index(pc,d1.w)
; ===========================================================================
; Obj_DA_subtbl:
ObjDA_Index:	offsetTable
		offsetTableEntry.w ObjDA_Init		; 0
		offsetTableEntry.w JmpTo2_DisplaySprite	; 2
		offsetTableEntry.w loc_7AD0		; 4
		offsetTableEntry.w loc_7B46		; 6
; ===========================================================================
; loc_7A7E:
ObjDA_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjDA_MapUnc_7CB6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_ContinueText,0,1),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo_Adjust2PArtPointer
	move.b	#0,render_flags(a0)
	move.b	#$3C,width_pixels(a0)
	move.w	#$120,x_pixel(a0)
	move.w	#$C0,y_pixel(a0)

JmpTo2_DisplaySprite 
	jmp	(DisplaySprite).l
; ===========================================================================
; word_7AB2:
ObjDA_XPositions:
	dc.w  $116, $12A, $102,	$13E,  $EE, $152,  $DA,	$166
	dc.w   $C6, $17A,  $B2,	$18E,  $9E, $1A2,  $8A;	8
; ===========================================================================

loc_7AD0:
	movea.l	a0,a1
	lea_	ObjDA_XPositions,a2
	moveq	#0,d1
	move.b	(Continue_count).w,d1
	subq.b	#2,d1
	bcc.s	+
	jmp	(DeleteObject).l
; ===========================================================================
+
	moveq	#1,d3
	cmpi.b	#$E,d1
	blo.s	+
	moveq	#0,d3
	moveq	#$E,d1
+
	move.b	d1,d2
	andi.b	#1,d2

-	_move.b	#ObjID_ContinueIcons,id(a1) ; load objDA
	move.w	(a2)+,x_pixel(a1)
	tst.b	d2
	beq.s	+
	subi.w	#$A,x_pixel(a1)
+
	move.w	#$D0,y_pixel(a1)
	move.b	#4,mapping_frame(a1)
	move.b	#6,routine(a1)
	move.l	#ObjDA_MapUnc_7CB6,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_ContinueText_2,0,1),art_tile(a1)
	jsrto	(Adjust2PArtPointer2).l, JmpTo_Adjust2PArtPointer2
	move.b	#0,render_flags(a1)
	lea	next_object(a1),a1 ; load obj addr
	dbf	d1,-

	lea	-next_object(a1),a1 ; load obj addr
	move.b	d3,subtype(a1)

loc_7B46:
	tst.b	subtype(a0)
	beq.s	+
	cmpi.b	#4,(MainCharacter+routine).w
	blo.s	+
	move.b	(Vint_runcount+3).w,d0
	andi.b	#1,d0
	bne.s	+
	tst.w	(MainCharacter+x_vel).w
	bne.s	JmpTo2_DeleteObject
	rts
; ===========================================================================
+
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$F,d0
	bne.s	JmpTo3_DisplaySprite
	bchg	#0,mapping_frame(a0)