; ----------------------------------------------------------------------------
; Object BD - Ascending/descending metal platforms from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BC1C:
ObjBD:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBD_Index(pc,d0.w),d1
	jmp	ObjBD_Index(pc,d1.w)
; ===========================================================================
; off_3BC2A:
ObjBD_Index:	offsetTable
		offsetTableEntry.w ObjBD_Init	; 0
		offsetTableEntry.w loc_3BC3C	; 2
		offsetTableEntry.w loc_3BC50	; 4
; ===========================================================================
; loc_3BC30:
ObjBD_Init:
	addq.b	#2,routine(a0)
	move.w	#1,objoff_2A(a0)
	rts
; ===========================================================================

loc_3BC3C:
	subq.w	#1,objoff_2A(a0)
	bne.s	+
	move.w	#$40,objoff_2A(a0)
	bsr.w	loc_3BCF8
+
	jmpto	JmpTo8_MarkObjGone3
; ===========================================================================

loc_3BC50:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3BC62(pc,d0.w),d1
	jsr	off_3BC62(pc,d1.w)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3BC62:	offsetTable
		offsetTableEntry.w loc_3BC6C	; 0
		offsetTableEntry.w loc_3BCAC	; 2
		offsetTableEntry.w loc_3BCB6	; 4
		offsetTableEntry.w loc_3BCCC	; 6
		offsetTableEntry.w loc_3BCD6	; 8
; ===========================================================================

loc_3BC6C:
	bsr.w	LoadSubObject
	move.b	#2,mapping_frame(a0)
	subq.b	#2,routine(a0)
	addq.b	#2,routine_secondary(a0)
	move.w	#$C7,objoff_2A(a0)
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	loc_3BC92
	move.w	#$1C7,objoff_2A(a0)

loc_3BC92:
	moveq	#0,d0
	move.b	subtype(a0),d0
	subi.b	#$7E,d0
	move.b	d0,subtype(a0)
	move.w	word_3BCA8(pc,d0.w),y_vel(a0)
	rts
; ===========================================================================
word_3BCA8:
	dc.w -$100
	dc.w  $100	; 1
; ===========================================================================

loc_3BCAC:
	lea	(Ani_objBD).l,a1
	jmpto	JmpTo25_AnimateSprite
; ===========================================================================

loc_3BCB6:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3BCC0
	bra.w	loc_3BCDE
; ===========================================================================

loc_3BCC0:
	addq.b	#2,routine_secondary(a0)
	move.b	#1,anim(a0)
	rts
; ===========================================================================

loc_3BCCC:
	lea	(Ani_objBD).l,a1
	jmpto	JmpTo25_AnimateSprite
; ===========================================================================

loc_3BCD6:
	bsr.w	loc_3B7BC
    if fixBugs
	; 'DeleteObject' is called here, but then 'loc_3BC50' calls 'MarkObjGone' afterwards.
	; This can result in either the object being queued for display with 'DisplaySprite',
	; or the object being deleted again with yet another call to 'DeleteObject'.
	; To prevent this, just meddle with the stack to prevent returning to 'loc_3BC50', like this:
	addq.w	#4,sp
    endif
	jmpto	JmpTo65_DeleteObject
; ===========================================================================

loc_3BCDE:
	move.w	x_pos(a0),-(sp)
	jsrto	JmpTo26_ObjectMove
	move.w	#$23,d1
	move.w	#4,d2
	move.w	#5,d3
	move.w	(sp)+,d4
	jmpto	JmpTo9_PlatformObject
; ===========================================================================

loc_3BCF8:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	+	; rts
	_move.b	#ObjID_SmallMetalPform,id(a1) ; load objBD
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#4,routine(a1)
	move.b	subtype(a0),subtype(a1)
	move.b	render_flags(a0),render_flags(a1)
+
	rts
; ===========================================================================
; off_3BD24:
ObjBD_SubObjData:
	subObjData ObjBD_MapUnc_3BD3E,make_art_tile(ArtTile_ArtNem_WfzBeltPlatform,3,1),1<<render_flags.level_fg,4,$18,0
