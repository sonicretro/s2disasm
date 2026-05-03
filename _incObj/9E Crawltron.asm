; ----------------------------------------------------------------------------
; Object 9E - Crawlton (snake badnik) from MCZ
; ----------------------------------------------------------------------------
; Sprite_37E16:
Obj9E:
	moveq	#0,d0
	move.b	objoff_3B(a0),d0
	move.w	Obj9E_Index(pc,d0.w),d1
	jmp	Obj9E_Index(pc,d1.w)
; ===========================================================================
; off_37E24:
Obj9E_Index:	offsetTable
		offsetTableEntry.w Obj9E_Init	;  0
		offsetTableEntry.w loc_37E42	;  2
		offsetTableEntry.w loc_37E98	;  4
		offsetTableEntry.w loc_37EB6	;  6
		offsetTableEntry.w loc_37ED4	;  8
		offsetTableEntry.w loc_37EFC	; $A
; ===========================================================================
; loc_37E30:
Obj9E_Init:
	bsr.w	LoadSubObject
	move.b	#$80,y_radius(a0)
	addq.b	#2,objoff_3B(a0)
	bra.w	loc_37F74
; ===========================================================================

loc_37E42:
	bsr.w	Obj_GetOrientationToPlayer
	move.w	d2,d4
	move.w	d3,d5
	addi.w	#$80,d2
	cmpi.w	#$100,d2
	bhs.s	+
	addi.w	#$80,d3
	cmpi.w	#$100,d3
	blo.s	loc_37E62
+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_37E62:
	addq.b	#2,objoff_3B(a0)
	move.b	#$10,objoff_3A(a0)
	bclr	#render_flags.x_flip,render_flags(a0)
	tst.w	d0
	beq.s	+
	bset	#render_flags.x_flip,render_flags(a0)
+
	neg.w	d4
	lsl.w	#3,d4
	andi.w	#$FF00,d4
	move.w	d4,x_vel(a0)
	neg.w	d5
	lsl.w	#3,d5
	andi.w	#$FF00,d5
	move.w	d5,y_vel(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_37E98:
	subq.b	#1,objoff_3A(a0)
	bmi.s	+
	jmpto	JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
+
	addq.b	#2,objoff_3B(a0)
	move.b	#8,objoff_39(a0)
	move.b	#$1C,objoff_3A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_37EB6:
	subq.b	#1,objoff_3A(a0)
	beq.s	+
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
+
	move.b	objoff_39(a0),objoff_3B(a0)
	move.b	#$20,objoff_3A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_37ED4:
	subq.b	#1,objoff_3A(a0)
	beq.s	+
	jmpto	JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
+
	move.b	#6,objoff_3B(a0)
	move.b	#2,objoff_39(a0)
	move.b	#$1C,objoff_3A(a0)
	neg.w	x_vel(a0)
	neg.w	y_vel(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_37EFC:
	movea.w	parent(a0),a1 ; a1=object
	cmpi.b	#ObjID_Crawlton,id(a1)
	bne.w	JmpTo65_DeleteObject
	bclr	#render_flags.x_flip,render_flags(a0)
	btst	#render_flags.x_flip,render_flags(a1)
	beq.s	+
	bset	#render_flags.x_flip,render_flags(a0)
+
	move.b	#$80,objoff_14(a0)
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	cmpi.b	#6,objoff_3B(a1)
	bne.s	loc_37F6C
	move.w	x_vel(a1),d2
	asr.w	#8,d2
	move.w	y_vel(a1),d3
	asr.w	#8,d3
	lea	subspr_data(a0),a2
	move.b	objoff_3A(a1),d0
	moveq	#$18,d1

	moveq	#6,d6
-	move.w	(a2),d4		; sub?_x_pos
	move.w	2(a2),d5	; sub?_y_pos
	cmp.b	d1,d0
	bhs.s	+
	add.w	d2,d4
	add.w	d3,d5
+
	move.w	d4,(a2)+	; sub?_x_pos
	move.w	d5,(a2)+	; sub?_y_pos
	subi_.b	#4,d1
	bcs.s	loc_37F6C
	addq.w	#next_subspr-4,a2
	dbf	d6,-

loc_37F6C:
	move.w	#object_display_list_size*5,d0
	jmpto	JmpTo5_DisplaySprite3
; ===========================================================================

loc_37F74:
	jsrto	JmpTo19_AllocateObject
	bne.s	+	; rts
	_move.b	#ObjID_Crawlton,id(a1) ; load obj9E
	move.b	render_flags(a0),render_flags(a1)
	bset	#render_flags.multi_sprite,render_flags(a1)
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#$A,objoff_3B(a1)
	move.b	#0,mainspr_mapframe(a1)
	move.b	#$80,mainspr_width(a1)
	move.b	#7,mainspr_childsprites(a1)
	move.w	a0,parent(a1)
	move.w	x_pos(a0),d2
	move.w	d2,x_pos(a1)
	move.w	y_pos(a0),d3
	move.w	d3,y_pos(a1)
	move.b	#$80,objoff_14(a1)
	bset	#render_flags.explicit_height,render_flags(a1)
	lea	subspr_data(a1),a2

	moveq	#6,d6
-	move.w	d2,(a2)+	; sub?_x_pos
	move.w	d3,(a2)+	; sub?_y_pos
	move.w	#2,(a2)+	; sub?_mapframe
	addi.w	#$10,d1
	dbf	d6,-
+
	rts
; ===========================================================================
; off_37FE8:
Obj9E_SubObjData:
	subObjData Obj9E_MapUnc_37FF2,make_art_tile(ArtTile_ArtNem_Crawlton,1,0),1<<render_flags.level_fg,4,$80,$B
