; ----------------------------------------------------------------------------
; Object A5 - Spiny (crawling badnik) from CPZ
; ----------------------------------------------------------------------------
; Sprite_38AEA:
ObjA5:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA5_Index(pc,d0.w),d1
	jmp	ObjA5_Index(pc,d1.w)
; ===========================================================================
; off_38AF8:
ObjA5_Index:	offsetTable
		offsetTableEntry.w ObjA5_Init	; 0
		offsetTableEntry.w loc_38B10	; 2
		offsetTableEntry.w loc_38B62	; 4
; ===========================================================================
; loc_38AFE:
ObjA5_Init:
	bsr.w	LoadSubObject
	move.w	#-$40,x_vel(a0)
	move.w	#$80,objoff_2A(a0)
	rts
; ===========================================================================

loc_38B10:
	tst.b	objoff_2B(a0)
	beq.s	loc_38B1E
	subq.b	#1,objoff_2B(a0)
	bra.w	loc_38B2C
; ===========================================================================

loc_38B1E:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	blo.s	loc_38B4E

loc_38B2C:
	subq.b	#1,objoff_2A(a0)
	bne.s	loc_38B3C
	move.w	#$80,objoff_2A(a0)
	neg.w	x_vel(a0)

loc_38B3C:
	jsrto	JmpTo26_ObjectMove
	lea	(Ani_objA5).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38B4E:
	addq.b	#2,routine(a0)
	move.b	#$28,objoff_2B(a0)
	move.b	#2,mapping_frame(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38B62:
	subq.b	#1,objoff_2B(a0)
	bmi.s	loc_38B78
	cmpi.b	#$14,objoff_2B(a0)
	bne.s	+
	bsr.w	loc_38C22
+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38B78:
	subq.b	#2,routine(a0)
	move.b	#$40,objoff_2B(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object A6 - Spiny (on wall) from CPZ
; ----------------------------------------------------------------------------
; Sprite_38B86:
ObjA6:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA6_Index(pc,d0.w),d1
	jmp	ObjA6_Index(pc,d1.w)
; ===========================================================================
; off_38B94:
ObjA6_Index:	offsetTable
		offsetTableEntry.w ObjA6_Init	; 0
		offsetTableEntry.w loc_38BAC	; 2
		offsetTableEntry.w loc_38BFE	; 4
; ===========================================================================
; loc_38B9A:
ObjA6_Init:
	bsr.w	LoadSubObject
	move.w	#-$40,y_vel(a0)
	move.w	#$80,objoff_2A(a0)
	rts
; ===========================================================================

loc_38BAC:
	tst.b	objoff_2B(a0)
	beq.s	loc_38BBA
	subq.b	#1,objoff_2B(a0)
	bra.w	loc_38BC8
; ===========================================================================

loc_38BBA:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	blo.s	loc_38BEA

loc_38BC8:
	subq.b	#1,objoff_2A(a0)
	bne.s	+
	move.w	#$80,objoff_2A(a0)
	neg.w	y_vel(a0)
+
	jsrto	JmpTo26_ObjectMove
	lea	(Ani_objA6).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38BEA:
	addq.b	#2,routine(a0)
	move.b	#$28,objoff_2B(a0)
	move.b	#5,mapping_frame(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38BFE:
	subq.b	#1,objoff_2B(a0)
	bmi.s	loc_38C14
	cmpi.b	#$14,objoff_2B(a0)
	bne.s	+
	bsr.w	loc_38C6E
+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38C14:
	subq.b	#2,routine(a0)
	move.b	#$40,objoff_2B(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_38C22:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	++	; rts
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#6,mapping_frame(a1)
	move.b	#$34,subtype(a1) ; <== ObjA6_SubObjData
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	#-$300,y_vel(a1)
	move.w	#$100,d1
	lea	(MainCharacter).w,a2 ; a2=character
	move.w	x_pos(a0),d0
	cmp.w	x_pos(a2),d0
	blo.s	+
	neg.w	d1
+
	move.w	d1,x_vel(a1)
	lea_	Obj98_SpinyShotFall,a2
	move.l	a2,objoff_2A(a1)
+
	rts
; ===========================================================================

loc_38C6E:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	++	; rts
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#6,mapping_frame(a1)
	move.b	#$34,subtype(a1) ; <== ObjA6_SubObjData
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	#$300,d1
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	neg.w	d1
+
	move.w	d1,x_vel(a1)
	lea_	Obj98_SpinyShotFall,a2
	move.l	a2,objoff_2A(a1)
+
	rts
; ===========================================================================
; off_38CAE:
ObjA5_SubObjData:
	subObjData ObjA5_ObjA6_Obj98_MapUnc_38CCA,make_art_tile(ArtTile_ArtNem_Spiny,1,0),1<<render_flags.level_fg,4,8,$B
