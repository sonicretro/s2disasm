; ===========================================================================
; ----------------------------------------------------------------------------
; Object 87 - Number of rings in Special Stage
; ----------------------------------------------------------------------------
; Sprite_7356:
Obj87:
	moveq	#0,d0
	move.b	objoff_A(a0),d0
	move.w	Obj87_Index(pc,d0.w),d1
	jmp	Obj87_Index(pc,d1.w)
; ===========================================================================
; off_7364:
Obj87_Index:	offsetTable
		offsetTableEntry.w Obj87_Init	; 0
		offsetTableEntry.w loc_7480	; 2
		offsetTableEntry.w loc_753E	; 4
		offsetTableEntry.w loc_75DE	; 6
; ===========================================================================

; loc_736C:
Obj87_Init:
	move.b	#2,objoff_A(a0)		; => loc_7480
	move.l	#Obj5F_MapUnc_72D2,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialHUD,2,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	bset	#6,render_flags(a0)
	move.b	#2,mainspr_childsprites(a0)
	move.w	#$20,d0
	moveq	#0,d1
	lea	sub2_x_pos(a0),a1
	move.w	#$48,(a1)			; sub2_x_pos
	move.w	d0,sub2_y_pos-sub2_x_pos(a1)	; sub2_y_pos
	move.w	d1,mainspr_height-sub2_x_pos(a1) ; mainspr_height and sub2_mapframe
	move.w	#$E0,sub3_x_pos-sub2_x_pos(a1)	; sub3_x_pos
	move.w	d0,sub3_y_pos-sub2_x_pos(a1)	; sub3_y_pos
	move.w	d1,mapping_frame-sub2_x_pos(a1)	; mapping_frame	and sub3_mapframe
	move.w	d0,sub4_y_pos-sub2_x_pos(a1)	; sub4_y_pos
	move.w	d0,sub5_y_pos-sub2_x_pos(a1)	; sub5_y_pos
	move.w	d0,sub6_y_pos-sub2_x_pos(a1)	; sub6_y_pos
	move.w	d0,sub7_y_pos-sub2_x_pos(a1)	; sub7_y_pos
	tst.b	(SS_2p_Flag).w
	bne.s	+++
	cmpi.w	#0,(Player_mode).w
	beq.s	+
	subi_.b	#1,mainspr_childsprites(a0)
	move.w	#$94,(a1)			; sub2_x_pos
	rts
; ===========================================================================
+
	bsr.w	SSSingleObjLoad
	bne.s	+	; rts
	move.b	#ObjID_SSNumberOfRings,id(a1) ; load obj87
	move.b	#4,objoff_A(a1)		; => loc_753E
	move.l	#Obj5F_MapUnc_72D2,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialHUD,2,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	bset	#6,render_flags(a1)
	move.b	#1,mainspr_childsprites(a1)
	lea	sub2_x_pos(a1),a2
	move.w	#$80,(a2)			; sub2_x_pos
	move.w	d0,sub2_y_pos-sub2_x_pos(a2)	; sub2_y_pos
	move.w	d1,mainspr_height-sub2_x_pos(a2) ; mainspr_height and sub2_mapframe
	move.w	d0,sub3_y_pos-sub2_x_pos(a2)	; sub3_y_pos
	move.w	d0,sub4_y_pos-sub2_x_pos(a2)	; sub4_y_pos
/	rts
; ===========================================================================
+
	bsr.w	SSSingleObjLoad
	bne.s	-	; rts
	move.b	#ObjID_SSNumberOfRings,id(a1) ; load obj87
	move.b	#6,objoff_A(a1)		; => loc_75DE
	move.l	#Obj5F_MapUnc_72D2,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialHUD,2,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	bset	#6,render_flags(a1)
	move.b	#0,mainspr_childsprites(a1)
	lea	sub2_x_pos(a1),a2
	move.w	#$2C,d0
	move.w	#$A,d1
	move.w	d0,sub2_y_pos-sub2_x_pos(a2)	; sub2_y_pos
	move.w	d1,mainspr_height-sub2_x_pos(a2) ; mainspr_height and sub2_mapframe
	move.w	d0,sub3_y_pos-sub2_x_pos(a2)	; sub3_y_pos
	move.w	d1,mapping_frame-sub2_x_pos(a2)	; mapping_frame	and sub3_mapframe
	move.w	d0,sub4_y_pos-sub2_x_pos(a2)	; sub4_y_pos
	move.w	d1,sub4_mapframe-1-sub2_x_pos(a2) ; something and sub4_mapframe
	rts
; ===========================================================================

loc_7480:
	moveq	#0,d0
	moveq	#0,d3
	moveq	#0,d5
	lea	sub2_x_pos(a0),a1
	movea.l	a1,a2
	addq.w	#5,a2	; a2 = sub2_mapframe(a0)
	cmpi.w	#2,(Player_mode).w
	beq.s	loc_74EA
	move.b	(MainCharacter+ss_rings_hundreds).w,d0
	beq.s	+
	addq.w	#1,d3
	move.b	d0,(a2)
	lea	next_subspr(a2),a2
+	move.b	(MainCharacter+ss_rings_tens).w,d0
	tst.b	d3
	bne.s	+
	tst.b	d0
	beq.s	++
+	addq.w	#1,d3
	move.b	d0,(a2)
	lea	next_subspr(a2),a2
+	addq.w	#1,d3
	move.b	(MainCharacter+ss_rings_units).w,(a2)
	lea	next_subspr(a2),a2
	move.w	d3,d4
	subq.w	#1,d4
	move.w	#$48,d1
	tst.w	(Player_mode).w
	beq.s	+
	addi.w	#$54,d1
/	move.w	d1,(a1,d5.w)
	addi_.w	#8,d1
	addq.w	#next_subspr,d5
	dbf	d4,-
	cmpi.w	#1,(Player_mode).w
	beq.s	loc_7536

loc_74EA:
	moveq	#0,d0
	moveq	#0,d4
	move.b	(Sidekick+ss_rings_hundreds).w,d0
	beq.s	+
	addq.w	#1,d4
	move.b	d0,(a2)
	lea	next_subspr(a2),a2
+	move.b	(Sidekick+ss_rings_tens).w,d0
	tst.b	d4
	bne.s	+
	tst.b	d0
	beq.s	++
+
	addq.w	#1,d4
	move.b	d0,(a2)
	lea	next_subspr(a2),a2
+	move.b	(Sidekick+ss_rings_units).w,(a2)
	addq.w	#1,d4
	add.w	d4,d3
	subq.w	#1,d4
	move.w	#$E0,d1
	tst.w	(Player_mode).w
	beq.s	+
	subi.w	#$44,d1
/	move.w	d1,(a1,d5.w)
	addi_.w	#8,d1
	addq.w	#6,d5
	dbf	d4,-

loc_7536:
	move.b	d3,mainspr_childsprites(a0)
	jmpto	(DisplaySprite).l, JmpTo_DisplaySprite
; ===========================================================================

loc_753E:
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#1,d3
	move.b	(MainCharacter+ss_rings_units).w,d0
	add.b	(Sidekick+ss_rings_units).w,d0
	move.b	(MainCharacter+ss_rings_tens).w,d1
	add.b	(Sidekick+ss_rings_tens).w,d1
	move.b	(MainCharacter+ss_rings_hundreds).w,d2
	add.b	(Sidekick+ss_rings_hundreds).w,d2
	cmpi.b	#10,d0
	blo.s	+
	addq.w	#1,d1
	subi.b	#10,d0
+
	tst.b	d1
	beq.s	++
	cmpi.b	#10,d1
	blo.s	+
	addi_.b	#1,d2
	subi.b	#10,d1
+
	addq.w	#1,d3
	tst.b	d2
	beq.s	++
	addq.w	#1,d3
	bra.s	++
; ===========================================================================
+
	tst.b	d2
	beq.s	+
	addq.w	#2,d3
+
	lea	sub2_x_pos(a0),a1
	move.b	d3,mainspr_childsprites(a0)
	cmpi.b	#2,d3
	blt.s	+
	beq.s	++
	move.w	#$78,(a1)			; sub2_x_pos
	move.b	d2,sub2_mapframe-sub2_x_pos(a1)	; sub2_mapframe
	move.w	#$80,sub3_x_pos-sub2_x_pos(a1)	; sub3_x_pos
	move.b	d1,sub3_mapframe-sub2_x_pos(a1)	; sub3_mapframe
	move.w	#$88,sub4_x_pos-sub2_x_pos(a1)	; sub4_x_pos
	move.b	d0,sub4_mapframe-sub2_x_pos(a1)	; sub4_mapframe
	jmpto	(DisplaySprite).l, JmpTo_DisplaySprite
; ===========================================================================
+
	move.w	#$80,(a1)			; sub2_x_pos
	move.b	d0,sub2_mapframe-sub2_x_pos(a1)	; sub2_mapframe
	jmpto	(DisplaySprite).l, JmpTo_DisplaySprite
; ===========================================================================
+
	move.w	#$7C,(a1)			; sub2_x_pos
	move.b	d1,sub2_mapframe-sub2_x_pos(a1)	; sub2_mapframe
	move.w	#$84,sub3_x_pos-sub2_x_pos(a1)	; sub3_x_pos
	move.b	d0,sub3_mapframe-sub2_x_pos(a1)	; sub3_mapframe
	jmpto	(DisplaySprite).l, JmpTo_DisplaySprite
; ===========================================================================

loc_75DE:
	move.b	(SS_2P_BCD_Score).w,d0
	bne.s	+
	rts
; ===========================================================================
+
	lea	sub2_x_pos(a0),a1
	moveq	#0,d2
	move.b	d0,d1
	andi.b	#$F0,d0
	beq.s	+
	addq.w	#1,d2
	move.w	#$20,(a1)	; sub2_x_pos
	lea	next_subspr(a1),a1
	subi.b	#$10,d0
	beq.s	+
	addq.w	#1,d2
	move.w	#$30,(a1)	; sub3_x_pos
	lea	next_subspr(a1),a1
	subi.b	#$10,d0
	beq.s	+
	addq.w	#1,d2
	move.w	#$40,(a1)	; sub4_x_pos
	bra.s	++
; ===========================================================================
+
	andi.b	#$F,d1
	beq.s	+
	addq.w	#1,d2
	move.w	#$B8,(a1)	; sub?_x_pos
	lea	next_subspr(a1),a1
	subi_.b	#1,d1
	beq.s	+
	addq.w	#1,d2
	move.w	#$C8,(a1)	; sub?_x_pos
	lea	next_subspr(a1),a1
	subi_.b	#1,d1
	beq.s	+
	addq.w	#1,d2
	move.w	#$D8,(a1)	; sub?_x_pos
+
	move.b	d2,mainspr_childsprites(a0)
	jmpto	(DisplaySprite).l, JmpTo_DisplaySprite