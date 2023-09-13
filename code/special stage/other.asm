; ===========================================================================
; ----------------------------------------------------------------------------
; Object 61 - Bombs from Special Stage
; ----------------------------------------------------------------------------
; Sprite_34EB0:
Obj61:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj61_Index(pc,d0.w),d1
	jmp	Obj61_Index(pc,d1.w)
; ===========================================================================
; off_34EBE:
Obj61_Index:	offsetTable
		offsetTableEntry.w Obj61_Init	; 0
		offsetTableEntry.w loc_34F06	; 2
		offsetTableEntry.w loc_3533A	; 4
		offsetTableEntry.w loc_34F6A	; 6
; ===========================================================================
; loc_34EC6:
Obj61_Init:
	addq.b	#2,routine(a0)
	move.w	#$7F,x_pos(a0)
	move.w	#$58,y_pos(a0)
	move.l	#Obj61_MapUnc_36508,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialBomb,1,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	move.b	#2,collision_flags(a0)
	move.b	#-1,(SS_unk_DB4D).w
	tst.b	angle(a0)
	bmi.s	loc_34F06
	bsr.w	loc_3529C

loc_34F06:
	bsr.w	loc_3512A
	bsr.w	loc_351A0
	lea	(Ani_obj61).l,a1
	bsr.w	loc_3539E
	tst.b	render_flags(a0)
	bpl.s	return_34F26
	bsr.w	loc_34F28
	bra.w	JmpTo44_DisplaySprite
; ===========================================================================

return_34F26:
	rts
; ===========================================================================

loc_34F28:
	move.w	#8,d6
	bsr.w	loc_350A0
	bcc.s	return_34F68
	move.b	#1,collision_property(a1)
	move.w	#SndID_SlowSmash,d0
	jsr	(PlaySound2).l
	move.b	#6,routine(a0)
	move.b	#0,anim_frame(a0)
	move.b	#0,anim_frame_duration(a0)
	move.l	objoff_34(a0),d0
	beq.s	return_34F68
	move.l	#0,objoff_34(a0)
	movea.l	d0,a1 ; a1=object
	st.b	objoff_2A(a1)

return_34F68:
	rts
; ===========================================================================

loc_34F6A:
	move.b	#$A,anim(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialExplosion,2,0),art_tile(a0)
	bsr.w	loc_34F90
	bsr.w	loc_3512A
	bsr.w	loc_351A0
	lea	(Ani_obj61).l,a1
	jsrto	AnimateSprite, JmpTo24_AnimateSprite
	bra.w	JmpTo44_DisplaySprite
; ===========================================================================

loc_34F90:
	cmpi.w	#4,objoff_30(a0)
	bhs.s	return_34F9E
	move.b	#1,priority(a0)

return_34F9E:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 60 - Rings from Special Stage
; ----------------------------------------------------------------------------
; Sprite_34FA0:
Obj60:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj60_Index(pc,d0.w),d1
	jmp	Obj60_Index(pc,d1.w)
; ===========================================================================
; off_34FAE:
Obj60_Index:	offsetTable
		offsetTableEntry.w Obj60_Init	; 0
		offsetTableEntry.w loc_34FF0	; 1
		offsetTableEntry.w loc_3533A	; 2
		offsetTableEntry.w loc_35010	; 3
; ===========================================================================
; loc_34FB6:
Obj60_Init:
	addq.b	#2,routine(a0)
	move.w	#$7F,x_pos(a0)
	move.w	#$58,y_pos(a0)
	move.l	#Obj5A_Obj5B_Obj60_MapUnc_3632A,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialRings,3,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	move.b	#1,collision_flags(a0)
	tst.b	angle(a0)
	bmi.s	loc_34FF0
	bsr.w	loc_3529C

loc_34FF0:

	bsr.w	loc_3512A
	bsr.w	loc_351A0
	bsr.w	loc_35036
	lea	(Ani_obj5B_obj60).l,a1
	bsr.w	loc_3539E
	tst.b	render_flags(a0)
	bmi.w	JmpTo44_DisplaySprite
	rts
; ===========================================================================

loc_35010:
	move.b	#$A,anim(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialStars,2,0),art_tile(a0)
	bsr.w	loc_34F90
	bsr.w	loc_3512A
	bsr.w	loc_351A0
	lea	(Ani_obj5B_obj60).l,a1
	jsrto	AnimateSprite, JmpTo24_AnimateSprite
	bra.w	JmpTo44_DisplaySprite
; ===========================================================================

loc_35036:
	move.w	#$A,d6
	bsr.w	loc_350A0
	bcc.s	return_3509E
	cmpa.l	#MainCharacter,a1
	bne.s	loc_3504E
	addq.w	#1,(Ring_count).w
	bra.s	loc_35052
; ===========================================================================

loc_3504E:
	addq.w	#1,(Ring_count_2P).w

loc_35052:
	addq.b	#1,ss_rings_units(a1)
	cmpi.b	#$A,ss_rings_units(a1)
	blt.s	loc_3507A
	addq.b	#1,ss_rings_tens(a1)
	move.b	#0,ss_rings_units(a1)
	cmpi.b	#$A,ss_rings_tens(a1)
	blt.s	loc_3507A
	addq.b	#1,ss_rings_hundreds(a1)
	move.b	#0,ss_rings_tens(a1)

loc_3507A:
	move.b	#6,routine(a0)
	move.l	objoff_34(a0),d0
	beq.s	loc_35094
	move.l	#0,objoff_34(a0)
	movea.l	d0,a1 ; a1=object
	st.b	objoff_2A(a1)

loc_35094:
	move.w	#SndID_Ring,d0
	jsr	(PlaySound2).l

return_3509E:
	rts
; ===========================================================================

loc_350A0:
	cmpi.b	#8,anim(a0)
	bne.s	loc_350DC
	tst.b	collision_flags(a0)
	beq.s	loc_350DC
	lea	(MainCharacter).w,a2 ; a2=object (special stage Sonic)
	lea	(Sidekick).w,a3 ; a3=object (special stage Tails)
	move.w	objoff_34(a2),d0
	cmp.w	objoff_34(a3),d0
	blo.s	loc_350CE
	movea.l	a3,a1
	bsr.w	loc_350E2
	bcs.s	return_350E0
	movea.l	a2,a1
	bra.w	loc_350E2
; ===========================================================================

loc_350CE:
	movea.l	a2,a1
	bsr.w	loc_350E2
	bcs.s	return_350E0
	movea.l	a3,a1
	bra.w	loc_350E2
; ===========================================================================

loc_350DC:
	move	#0,ccr

return_350E0:
	rts
; ===========================================================================

loc_350E2:
	tst.b	id(a1)
	beq.s	loc_3511A
	cmpi.b	#2,routine(a1)
	bne.s	loc_3511A
	tst.b	routine_secondary(a1)
	bne.s	loc_3511A
	move.b	angle(a1),d0
	move.b	angle(a0),d1
	move.b	d1,d2
	add.b	d6,d1
	bcs.s	loc_35110
	sub.b	d6,d2
	bcs.s	loc_35112
	cmp.b	d1,d0
	bhs.s	loc_3511A
	cmp.b	d2,d0
	bhs.s	loc_35120
	bra.s	loc_3511A
; ===========================================================================

loc_35110:
	sub.b	d6,d2

loc_35112:
	cmp.b	d1,d0
	blo.s	loc_35120
	cmp.b	d2,d0
	bhs.s	loc_35120

loc_3511A:
	move	#0,ccr
	rts
; ===========================================================================

loc_35120:
	clr.b	collision_flags(a0)
	move	#1,ccr
	rts
; ===========================================================================

loc_3512A:
	btst	#7,status(a0)
	bne.s	loc_3516C
	cmpi.b	#4,(SSTrack_drawing_index).w
	bne.s	loc_35146
	subi.l	#$CCCC,objoff_30(a0)
	ble.s	loc_3516C
	bra.s	loc_35150
; ===========================================================================

loc_35146:
	subi.l	#$CCCD,objoff_30(a0)
	ble.s	loc_3516C

loc_35150:
	cmpi.b	#$A,anim(a0)
	beq.s	return_3516A
	move.w	objoff_30(a0),d0
	cmpi.w	#$1D,d0
	ble.s	loc_35164
	moveq	#$1E,d0

loc_35164:
	move.b	byte_35180(pc,d0.w),anim(a0)

return_3516A:
	rts
; ===========================================================================

loc_3516C:
	move.l	(sp)+,d0
	move.l	objoff_34(a0),d0
	beq.w	JmpTo63_DeleteObject
	movea.l	d0,a1 ; a1=object
	st.b	objoff_2A(a1)

    if removeJmpTos
JmpTo63_DeleteObject ; JmpTo
    endif

	jmpto	DeleteObject, JmpTo63_DeleteObject
; ===========================================================================
byte_35180:
	dc.b   9,  9,  9,  8,  8,  7,  7,  6,  6,  5,  5,  4,  4,  3,  3,  3
	dc.b   2,  2,  2,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0; 16
	even
; ===========================================================================

loc_351A0:
	move.w	d7,-(sp)
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	movea.l	(SS_CurrentPerspective).w,a1
	move.w	objoff_30(a0),d0
	beq.w	loc_35258
	cmp.w	(a1)+,d0
	bgt.w	loc_35258
	subq.w	#1,d0
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	tst.b	(SSTrack_Orientation).w
	bne.w	loc_35260
	move.b	4(a1,d0.w),d6
	move.b	5(a1,d0.w),d7
	beq.s	loc_351E8
	move.b	angle(a0),d1
	cmp.b	d6,d1
	blo.s	loc_351E8
	cmp.b	d7,d1
	blo.s	loc_35258

loc_351E8:
	move.b	(a1,d0.w),d2
	move.b	2(a1,d0.w),d4
	move.b	3(a1,d0.w),d5
	move.b	1(a1,d0.w),d3

loc_351F8:
	bpl.s	loc_35202
	cmpi.b	#$48,d3
	blo.s	loc_35202
	ext.w	d3

loc_35202:
	move.b	angle(a0),d0
	jsrto	CalcSine, JmpTo14_CalcSine
	muls.w	d4,d1
	muls.w	d5,d0
	asr.l	#8,d0
	asr.l	#8,d1
	add.w	d2,d1
	add.w	d3,d0
	move.w	d1,x_pos(a0)
	move.w	d0,y_pos(a0)
	move.l	objoff_34(a0),d0
	beq.s	loc_3524E
	movea.l	d0,a1 ; a1=object
	move.b	angle(a0),d0
	jsrto	CalcSine, JmpTo14_CalcSine
	move.w	d4,d7
	lsr.w	#2,d7
	add.w	d7,d4
	muls.w	d4,d1
	move.w	d5,d7
	asr.w	#2,d7
	add.w	d7,d5
	muls.w	d5,d0
	asr.l	#8,d0
	asr.l	#8,d1
	add.w	d2,d1
	add.w	d3,d0
	move.w	d1,x_pos(a1)
	move.w	d0,y_pos(a1)

loc_3524E:
	ori.b	#$80,render_flags(a0)

loc_35254:
	move.w	(sp)+,d7
	rts
; ===========================================================================

loc_35258:
	andi.b	#$7F,render_flags(a0)
	bra.s	loc_35254
; ===========================================================================

loc_35260:
	move.b	#$80,d1
	move.b	4(a1,d0.w),d6
	move.b	5(a1,d0.w),d7
	beq.s	loc_35282
	sub.w	d1,d6
	sub.w	d1,d7
	neg.w	d6
	neg.w	d7
	move.b	angle(a0),d1
	cmp.b	d7,d1
	blo.s	loc_35282
	cmp.b	d6,d1
	blo.s	loc_35258

loc_35282:
	move.b	(a1,d0.w),d2
	move.b	2(a1,d0.w),d4
	move.b	3(a1,d0.w),d5
	subi.w	#$100,d2
	neg.w	d2
	move.b	1(a1,d0.w),d3
	bra.w	loc_351F8
; ===========================================================================

loc_3529C:
	jsrto	SSAllocateObjectAfterCurrent, JmpTo_SSAllocateObjectAfterCurrent
	bne.w	return_3532C
	move.l	a0,objoff_34(a1)
	move.b	id(a0),id(a1)
	move.b	#4,routine(a1)
	move.l	#Obj63_MapUnc_34492,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialFlatShadow,3,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#5,priority(a1)
	move.b	angle(a0),d0
	cmpi.b	#$10,d0
	bgt.s	loc_352E6
	bset	#0,render_flags(a1)
	move.b	#2,objoff_2B(a1)
	move.l	a1,objoff_34(a0)
	rts
; ===========================================================================

loc_352E6:
	cmpi.b	#$30,d0
	bgt.s	loc_352FE
	bset	#0,render_flags(a1)
	move.b	#1,objoff_2B(a1)
	move.l	a1,objoff_34(a0)
	rts
; ===========================================================================

loc_352FE:
	cmpi.b	#$50,d0
	bgt.s	loc_35310
	move.b	#0,objoff_2B(a1)
	move.l	a1,objoff_34(a0)
	rts
; ===========================================================================

loc_35310:
	cmpi.b	#$70,d0
	bgt.s	loc_35322
	move.b	#1,objoff_2B(a1)
	move.l	a1,objoff_34(a0)
	rts
; ===========================================================================

loc_35322:
	move.b	#2,objoff_2B(a1)
	move.l	a1,objoff_34(a0)

return_3532C:
	rts
; ===========================================================================
	dc.b   0
	dc.b   0	; 1
	dc.b   0	; 2
	dc.b $18	; 3
	dc.b   0	; 4
	dc.b $14	; 5
	dc.b   0	; 6
	dc.b $14	; 7
	dc.b   0	; 8
	dc.b $14	; 9
	dc.b   0	; 10
	dc.b   0	; 11
	even
; ===========================================================================

loc_3533A:
	tst.b	objoff_2A(a0)
	bne.w	BranchTo_JmpTo63_DeleteObject
	movea.l	objoff_34(a0),a1 ; a1=object
	tst.b	render_flags(a1)
	bmi.s	loc_3534E
	rts
; ===========================================================================

loc_3534E:
	moveq	#9,d0
	sub.b	anim(a1),d0
	addi_.b	#1,d0
	cmpi.b	#$A,d0
	bne.s	loc_35362
	move.w	#9,d0

loc_35362:
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	moveq	#0,d1
	move.b	objoff_2B(a0),d1
	beq.s	loc_3538A
	cmpi.b	#1,d1
	beq.s	loc_35380
	add.w	d1,d0
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialSideShadow,3,0),art_tile(a0)
	bra.s	loc_35392
; ===========================================================================

loc_35380:
	add.w	d1,d0
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialDiagShadow,3,0),art_tile(a0)
	bra.s	loc_35392
; ===========================================================================

loc_3538A:
	add.w	d1,d0
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialFlatShadow,3,0),art_tile(a0)

loc_35392:
	move.b	d0,mapping_frame(a0)
	bra.w	JmpTo44_DisplaySprite
; ===========================================================================

BranchTo_JmpTo63_DeleteObject ; BranchTo
	jmpto	DeleteObject, JmpTo63_DeleteObject
; ===========================================================================

loc_3539E:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	return_353E8
	moveq	#0,d0
	move.b	anim(a0),d0
	add.w	d0,d0
	adda.w	(a1,d0.w),a1
	move.b	(a1),anim_frame_duration(a0)
	moveq	#0,d1
	move.b	anim_frame(a0),d1
	move.b	1(a1,d1.w),d0
	bpl.s	loc_353CA
	move.b	#0,anim_frame(a0)
	move.b	1(a1),d0

loc_353CA:
	andi.b	#$7F,d0
	move.b	d0,mapping_frame(a0)
	move.b	status(a0),d1
	andi.b	#3,d1
	andi.b	#$FC,render_flags(a0)
	or.b	d1,render_flags(a0)
	addq.b	#1,anim_frame(a0)

return_353E8:
	rts
; ===========================================================================
byte_353EA:
	dc.b $38
	dc.b $48	; 1
	dc.b $2A	; 2
	dc.b $56	; 3
	dc.b $1C	; 4
	dc.b $64	; 5
	dc.b  $E	; 6
	dc.b $72	; 7
	dc.b   0	; 8
	dc.b $80	; 9
byte_353F4:
	dc.b $40
	dc.b $30	; 1
	dc.b $50	; 2
	dc.b $20	; 3
	dc.b $60	; 4
	dc.b $10	; 5
	dc.b $70	; 6
	dc.b   0	; 7
	dc.b $80	; 8
	dc.b   0	; 9
	even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 5B - Ring spray/spill in Special Stage
; ----------------------------------------------------------------------------
; Sprite_353FE:
Obj5B:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj5B_Index(pc,d0.w),d1
	jmp	Obj5B_Index(pc,d1.w)
; ===========================================================================
; off_3540C:
Obj5B_Index:	offsetTable
		offsetTableEntry.w Obj5B_Init	; 0
		offsetTableEntry.w Obj5B_Main	; 2
; ===========================================================================
; loc_35410:
Obj5B_Init:
	movea.l	ss_parent(a0),a3
	moveq	#0,d1
	move.b	ss_rings_tens(a3),d1
	beq.s	loc_35428
	subi_.b	#1,ss_rings_tens(a3)
	move.w	#$A,d1
	bra.s	loc_35458
; ===========================================================================

loc_35428:
	move.b	ss_rings_hundreds(a3),d1
	beq.s	loc_35440
	subi_.b	#1,ss_rings_hundreds(a3)
	move.b	#9,ss_rings_tens(a3)
	move.w	#$A,d1
	bra.s	loc_35458
; ===========================================================================

loc_35440:
	move.b	ss_rings_units(a3),d1
	beq.s	loc_3545C
	move.b	#0,ss_rings_units(a3)
	btst	#0,d1
	beq.s	loc_35458
	lea_	byte_353F4,a2
	bra.s	loc_3545C
; ===========================================================================

loc_35458:
	lea_	byte_353EA,a2
loc_3545C:
	cmpi.b	#ObjID_SonicSS,id(a3)
	bne.s	loc_35468
	sub.w	d1,(Ring_count).w
	bra.s	loc_3546C
; ===========================================================================

loc_35468:
	sub.w	d1,(Ring_count_2P).w

loc_3546C:
	move.w	d1,d2
	subq.w	#1,d2
	bmi.w	JmpTo63_DeleteObject
	movea.l	a0,a1
	bra.s	loc_3547E
; ===========================================================================

loc_35478:
	jsrto	SSAllocateObject, JmpTo2_SSAllocateObject
	bne.s	loc_354DE

loc_3547E:
	move.b	#ObjID_SSRingSpill,id(a1) ; load obj5B
	move.b	#2,routine(a1)
	move.l	#Obj5A_Obj5B_Obj60_MapUnc_3632A,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialRings,3,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#5,priority(a1)
	move.b	#0,collision_flags(a1)
	move.b	#8,anim(a1)
	move.w	x_pos(a3),x_pos(a1)
	move.w	y_pos(a3),y_pos(a1)
	move.b	angle(a3),d0
	addi.b	#$40,d0
	add.b	(a2)+,d0
	jsr	(CalcSine).l
	muls.w	#$400,d1
	asr.l	#8,d1
	move.w	d1,x_vel(a1)
	muls.w	#$1000,d0
	asr.l	#8,d0
	move.w	d0,y_vel(a1)

loc_354DE:
	dbf	d2,loc_35478
	rts
; ===========================================================================
; loc_354E4:
Obj5B_Main:
	jsrto	ObjectMoveAndFall, JmpTo7_ObjectMoveAndFall
	addi.w	#$80,y_vel(a0)
	bsr.w	loc_3551C
	tst.w	x_pos(a0)
	bmi.w	JmpTo63_DeleteObject
	cmpi.w	#256,x_pos(a0) ; Screen width
	bhs.w	JmpTo63_DeleteObject
	cmpi.w	#224,y_pos(a0) ; Screen height
	bgt.w	JmpTo63_DeleteObject
	lea	(Ani_obj5B_obj60).l,a1
	jsrto	AnimateSprite, JmpTo24_AnimateSprite
	bra.w	JmpTo44_DisplaySprite
; ===========================================================================

loc_3551C:
	tst.w	y_vel(a0)
	bmi.w	+
	move.b	#0,priority(a0)
	move.b	#9,anim(a0)
+
	rts
; ===========================================================================
	rts
; ===========================================================================

SSRainbowPaletteColors:
	move.w	word_35548(pc,d0.w),(Normal_palette_line4+$16).w
	move.w	word_35548+2(pc,d0.w),(Normal_palette_line4+$18).w
	move.w	word_35548+4(pc,d0.w),(Normal_palette_line4+$1A).w
	rts
; ===========================================================================
word_35548:
	dc.w   $EE,  $88,  $44
	dc.w   $EE,  $CC,  $88	; 3
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 5A - Messages/checkpoint from Special Stage
; ----------------------------------------------------------------------------
; Sprite_35554:
Obj5A:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj5A_Index(pc,d0.w),d1
	jmp	Obj5A_Index(pc,d1.w)
; ===========================================================================
; off_35562:
Obj5A_Index:	offsetTable
		offsetTableEntry.w Obj5A_Init               ;   0
		offsetTableEntry.w Obj5A_CheckpointRainbow  ;   2
		offsetTableEntry.w Obj5A_TextFlyoutInit     ;   4
		offsetTableEntry.w Obj5A_Handshake          ;   6
		offsetTableEntry.w Obj5A_TextFlyout         ;   8
		offsetTableEntry.w Obj5A_MostRingsWin       ;  $A
		offsetTableEntry.w Obj5A_RingCheckTrigger   ;  $C
		offsetTableEntry.w Obj5A_RingsNeeded        ;  $E
		offsetTableEntry.w Obj5A_FlashMessage       ; $10
		offsetTableEntry.w Obj5A_MoveAndFlash       ; $12
		offsetTableEntry.w Obj5A_FlashOnly          ; $14
; ===========================================================================
; loc_35578:
Obj5A_Init:
	tst.b	(SS_NoCheckpoint_flag).w
	bne.s	Obj5A_RingsMessageInit
	movea.l	(SSTrack_last_mappings_copy).w,a1
	cmpa.l	#MapSpec_Straight4,a1
	blt.s	++		; rts
	cmpa.l	#MapSpec_Drop1,a1
	bge.s	++		; rts
	moveq	#6,d0
	bsr.s	SSRainbowPaletteColors
	st.b	(SS_Checkpoint_Rainbow_flag).w
	moveq	#6,d0
-
	jsrto	SSAllocateObject, JmpTo2_SSAllocateObject
	bne.s	+
	move.b	#ObjID_SSMessage,id(a1) ; load obj5A
	move.b	#2,routine(a1)	; => Obj5A_CheckpointRainbow
	move.l	#Obj5A_Obj5B_Obj60_MapUnc_3632A,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialRings,3,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#5,priority(a1)
	move.b	d0,objoff_2A(a1)
	move.w	#0,objoff_30(a1)
	move.b	#-1,mapping_frame(a1)
+	dbf	d0,-

	bra.w	JmpTo63_DeleteObject
; ===========================================================================
+
	rts
; ===========================================================================
;loc_355E0
Obj5A_RingsMessageInit:
	sf.b	(SS_NoCheckpoint_flag).w
	tst.b	(SS_2p_Flag).w
	bne.w	JmpTo63_DeleteObject
	sf.b	(SS_HideRingsToGo).w
	sf.b	(SS_TriggerRingsToGo).w
	move.w	#0,(SS_NoRingsTogoLifetime).w
	move.b	#0,objoff_3A(a0)
	bra.w	JmpTo63_DeleteObject
; ===========================================================================
 ; temporarily remap characters to title card letter format
 ; Characters are encoded as Aa, Bb, Cc, etc. through a macro
 charset 'a','z','A'	; Convert to uppercase
 charset 'A',"\xD\x11\7\x11\1\x11"
 charset 'G',0	; can't have an embedded 0 in a string
 charset 'H',"\xB\4\x11\x11\9\xF\5\8\xC\x11\3\6\2\xA\x11\x10\x11\xE\x11"
 charset '!',"\x11"
 charset '.',"\x12"

specialText macro letters
	dc.b letters
	dc.b $FF	; output string terminator
    endm

Obj5A_RingsToGoText:
	specialText "RING"
	specialText "!OGOT"
	specialText "S"
	even

Obj5A_ToGoOffsets:
	dc.w   $C0	; 0
	dc.w   $B8	; 1
	dc.w   $B0	; 2
	dc.w   $A0	; 3
	dc.w   $98	; 4
	dc.w   $88	; 5

 charset ; revert character set

; ===========================================================================
;loc_3561E
Obj5A_CreateRingsToGoText:
	st.b	(SS_TriggerRingsToGo).w
	jsrto	SSAllocateObject, JmpTo2_SSAllocateObject
	bne.w	return_356E4
	move.l	#Obj5F_MapUnc_72D2,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialHUD,2,0),art_tile(a1)
	move.b	#ObjID_SSMessage,id(a1) ; load obj5A
	move.b	#4,render_flags(a1)
    if ~~fixBugs
	; Multi-sprite objects cannot use the 'priority' SST as it is
	; overwritten by 'sub3_y_pos'.
	move.b	#1,priority(a1)
    endif
	bset	#6,render_flags(a1)
	move.b	#0,mainspr_childsprites(a1)
	move.b	#$E,routine(a1)	; => Obj5A_RingsNeeded
	lea	subspr_data(a1),a2
	move.w	#$5A,d1
	move.w	#$38,d2
	moveq	#0,d0
	moveq	#2,d3

-	move.w	d1,(a2)+	; sub?_x_pos
	move.w	d2,(a2)+	; sub?_y_pos
	move.w	d0,(a2)+	; sub?_mapframe
	subq.w	#8,d1
	dbf	d3,-
	lea	Obj5A_RingsToGoText(pc),a3
	move.w	#$68,d1
	move.w	#$38,d2

-	move.b	(a3)+,d0
	bmi.s	+
	jsrto	SSAllocateObject, JmpTo2_SSAllocateObject
	bne.s	return_356E4
	bsr.s	Init_Obj5A
	move.b	#$10,routine(a1)
	move.w	d1,x_pos(a1)
	move.w	d2,y_pos(a1)
	move.b	d0,mapping_frame(a1)
	addq.w	#8,d1
	bra.s	-
; ===========================================================================
+
	lea	Obj5A_ToGoOffsets(pc),a2

-	move.b	(a3)+,d0
	bmi.s	+
	jsrto	SSAllocateObject, JmpTo2_SSAllocateObject
	bne.s	return_356E4
	bsr.s	Init_Obj5A
	move.b	#$12,routine(a1)	; => Obj5A_MoveAndFlash
	move.w	(a2)+,objoff_2A(a1)
	move.w	d2,y_pos(a1)
	move.b	d0,mapping_frame(a1)
	bra.s	-
; ===========================================================================
+
	move.b	(a3)+,d0
	jsrto	SSAllocateObject, JmpTo2_SSAllocateObject
	bne.s	return_356E4
	bsr.s	Init_Obj5A
	move.b	#$14,routine(a1)	; => Obj5A_FlashOnly
	move.w	(a2)+,x_pos(a1)
	move.w	d2,y_pos(a1)
	move.b	d0,mapping_frame(a1)

return_356E4:
	rts
; ===========================================================================
;loc_356E6
Init_Obj5A:
	move.b	#ObjID_SSMessage,id(a1) ; load obj5A
	move.l	#Obj5A_MapUnc_35E1E,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialMessages,2,0),art_tile(a1)
	move.b	#4,render_flags(a1)
    if ~~fixBugs
	; Multi-sprite objects cannot use the 'priority' SST as it is
	; overwritten by 'sub3_y_pos'. This object doesn't use the
	; multi-sprite system, but it does share display code with one, so
	; this might as well be removed since it won't be used.
	move.b	#1,priority(a1)
    endif
	rts
; ===========================================================================
;loc_35706
Obj5A_RingsNeeded:
	move.b	(SS_TriggerRingsToGo).w,(SS_HideRingsToGo).w
	bne.s	+
	bsr.s	++
	bra.w	Obj5A_FlashMessage
; ===========================================================================
+
	rts
; ===========================================================================
+
	move.w	(Ring_count).w,d0
	cmpi.w	#1,(Player_mode).w
	blt.s	+
	beq.s	++
	move.w	(Ring_count_2P).w,d0
	bra.s	++
; ===========================================================================
+
	add.w	(Ring_count_2P).w,d0
+
	sub.w	(SS_Ring_Requirement).w,d0
	neg.w	d0
	bgt.s	+
	moveq	#0,d0
	moveq	#1,d2
	addi_.w	#1,(SS_NoRingsTogoLifetime).w
	cmpi.w	#$C,(SS_NoRingsTogoLifetime).w
	blo.s	loc_3577A
	st.b	(SS_HideRingsToGo).w
	bra.s	loc_3577A
; ===========================================================================
+
	; This code converts the remaining rings into binary coded decimal format.
	moveq	#0,d1
	move.w	d0,d1
	moveq	#0,d0
	cmpi.w	#100,d1
	blt.s	+
    if fixBugs
	; The following code does a more complete binary coded decimal conversion:
-	addi.w	#$100,d0
	subi.w	#100,d1
	cmpi.w	#100,d1
	bge.s	-
    else
	; This code (the original) breaks when 101+ rings are needed:
-	addi.w	#$100,d0
	subi.w	#100,d1
	bgt.s	-
    endif
+
	divu.w	#10,d1
	lsl.w	#4,d1
	or.b	d1,d0
	swap	d1
	or.b	d1,d0
	move.w	#0,(SS_NoRingsTogoLifetime).w
	sf.b	(SS_HideRingsToGo).w

loc_3577A:
	moveq	#1,d2
	lea	subspr_data(a0),a1
	move.w	d0,(SS_RingsToGoBCD).w
	move.w	d0,d1
	andi.w	#$F,d1
	move.b	d1,sub2_mapframe-sub2_x_pos(a1)
	lsr.w	#4,d0
	beq.s	+
	addq.w	#1,d2
	move.w	d0,d1
	andi.w	#$F,d1
	move.b	d1,sub3_mapframe-sub2_x_pos(a1)
	lsr.w	#4,d0
	beq.s	+
	addq.w	#1,d2
	andi.w	#$F,d0
	move.b	d0,sub4_mapframe-sub2_x_pos(a1)
+
	move.b	d2,mainspr_childsprites(a0)
	rts
; ===========================================================================
;loc_357B2
Obj5A_FlashMessage:
	tst.b	(SS_NoCheckpointMsg_flag).w
	bne.w	+		; rts
	tst.b	(SS_HideRingsToGo).w
	bne.s	+		; rts
	move.b	(Vint_runcount+3).w,d0
	andi.b	#7,d0
	cmpi.b	#6,d0
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	bhs.s	+
	move.w	#object_display_list_size*1,d0
	jmp	(DisplaySprite3).l
    else
	blo.w	JmpTo44_DisplaySprite
    endif
+
	rts
; ===========================================================================
;loc_357D2
Obj5A_MoveAndFlash:
	moveq	#0,d0
	cmpi.w	#2,(SS_RingsToGoBCD).w
	bhs.s	+
	moveq	#-8,d0
+
	add.w	objoff_2A(a0),d0
	move.w	d0,x_pos(a0)
	bra.s	Obj5A_FlashMessage
; ===========================================================================
;loc_357E8
Obj5A_FlashOnly:
	moveq	#0,d0
	cmpi.w	#2,(SS_RingsToGoBCD).w
	bhs.s	Obj5A_FlashMessage
	rts
; ===========================================================================
Obj5A_Rainbow_Frames:
	dc.b   0
	dc.b   1	; 1
	dc.b   1	; 2
	dc.b   1	; 3
	dc.b   2	; 4
	dc.b   4	; 5
	dc.b   6	; 6
	dc.b   8	; 7
	dc.b   9	; 8
	dc.b $FF	; 9
	even
; ===========================================================================
;loc_357FE
Obj5A_CheckpointRainbow:
	cmpi.b	#4,(SSTrack_drawing_index).w
	bne.s	+
	move.w	objoff_2C(a0),d0
	move.b	Obj5A_Rainbow_Frames(pc,d0.w),mapping_frame(a0)
	bmi.w	++
	addi_.w	#1,objoff_2C(a0)
	moveq	#0,d0
	move.b	objoff_2A(a0),d0
	add.w	d0,d0
	add.w	objoff_30(a0),d0
	move.b	Obj5A_Rainbow_Positions(pc,d0.w),1+x_pos(a0)
	move.b	Obj5A_Rainbow_Positions+1(pc,d0.w),1+y_pos(a0)
	addi.w	#$E,objoff_30(a0)
	bra.w	JmpTo44_DisplaySprite
; ===========================================================================
+
	tst.b	mapping_frame(a0)
	bpl.w	JmpTo44_DisplaySprite
	rts
; ===========================================================================
Obj5A_Rainbow_Positions:
	;      x,  y
	dc.b $F6,$F6
	dc.b $70,$5E	; 2
	dc.b $76,$58	; 4
	dc.b $7E,$56	; 6
	dc.b $88,$58	; 8
	dc.b $8E,$5E	; 10
	dc.b $F6,$F6	; 12
	dc.b $F6,$F6	; 14
	dc.b $6D,$5A	; 16
	dc.b $74,$54	; 18
	dc.b $7E,$50	; 20
	dc.b $8A,$54	; 22
	dc.b $92,$5A	; 24
	dc.b $F6,$F6	; 26
	dc.b $F6,$F6	; 28
	dc.b $6A,$58	; 30
	dc.b $72,$50	; 32
	dc.b $7E,$4C	; 34
	dc.b $8C,$50	; 36
	dc.b $94,$58	; 38
	dc.b $F6,$F6	; 40
	dc.b $F6,$F6	; 42
	dc.b $68,$56	; 44
	dc.b $70,$4C	; 46
	dc.b $7E,$48	; 48
	dc.b $8E,$4C	; 50
	dc.b $96,$56	; 52
	dc.b $F6,$F6	; 54
	dc.b $62,$5E	; 56
	dc.b $66,$50	; 58
	dc.b $70,$46	; 60
	dc.b $7E,$42	; 62
	dc.b $8E,$46	; 64
	dc.b $98,$50	; 66
	dc.b $9C,$5E	; 68
	dc.b $5C,$5A	; 70
	dc.b $62,$4A	; 72
	dc.b $70,$3E	; 74
	dc.b $7E,$38	; 76
	dc.b $8E,$3E	; 78
	dc.b $9C,$4A	; 80
	dc.b $A2,$5A	; 82
	dc.b $54,$54	; 84
	dc.b $5A,$3E	; 86
	dc.b $6A,$30	; 88
	dc.b $7E,$2A	; 90
	dc.b $94,$30	; 92
	dc.b $A4,$3E	; 94
	dc.b $AA,$54	; 96
	dc.b $42,$4A	; 98
	dc.b $4C,$28	; 100
	dc.b $62,$12	; 102
	dc.b $7E, $A	; 104
	dc.b $9C,$12	; 106
	dc.b $B2,$28	; 108
	dc.b $BC,$4A	; 110
	dc.b $16,$26	; 112
	dc.b $28,$FC	; 114
	dc.b $EC,$EC	; 116
	dc.b $EC,$EC	; 118
	dc.b $EC,$EC	; 120
	dc.b $D6,$FC	; 122
	dc.b $E8,$26	; 124
; ===========================================================================
+
	cmpi.w	#$E8,x_pos(a0)
	bne.w	JmpTo63_DeleteObject
	moveq	#0,d0
	bsr.w	SSRainbowPaletteColors
	sf.b	(SS_Checkpoint_Rainbow_flag).w
	st.b	(SS_NoCheckpointMsg_flag).w
	tst.b	(SS_2p_Flag).w			; Is it VS mode?
	beq.w	loc_35978					; Branch if not
	move.w	#SndID_Checkpoint,d0
	jsr	(PlaySound).l
	addi.b	#$10,(SS_2P_BCD_Score).w
	moveq	#0,d6
	addi_.b	#1,(Current_Special_Act).w
	move.w	#$C,d0
	move.w	(Ring_count).w,d2
	cmp.w	(Ring_count_2P).w,d2
	bgt.s	++
	beq.s	+++
	subi.b	#$10,(SS_2P_BCD_Score).w
	addi_.b	#1,(SS_2P_BCD_Score).w
	move.w	#$E,d0
	tst.b	(Graphics_Flags).w
	bpl.s	+
	move.w	#$14,d0
+
	move.w	#palette_line_1,d6
+
	move.w	#$80,d3
	bsr.w	Obj5A_CreateCheckpointWingedHand
	add.w	d6,art_tile(a1)
	add.w	d6,2(a2)
	bsr.w	Obj5A_PrintPhrase
	bra.w	JmpTo63_DeleteObject
; ===========================================================================
+
	subi.b	#$10,(SS_2P_BCD_Score).w
	move.w	#$10,d0
	bsr.w	Obj5A_PrintPhrase
	cmpi.b	#3,(Current_Special_Act).w
	beq.s	+
	move.w	#$46,objoff_2A(a0)
	move.b	#$A,routine(a0)
	rts
; ===========================================================================
+
	bsr.w	Obj5A_VSReset
	move.w	#$46,objoff_2A(a0)
	move.b	#$C,routine(a0)
	rts
; ===========================================================================

loc_35978:
	move.w	#6,d1
	move.w	#SndID_Error,d0
	move.w	(Ring_count).w,d2
	add.w	(Ring_count_2P).w,d2
	cmp.w	(SS_Ring_Requirement).w,d2
	blt.s	+
	move.w	#4,d1
	move.w	#SndID_Checkpoint,d0
+
	jsr	(PlaySound).l
	move.w	d1,d0
	bsr.w	Obj5A_PrintCheckpointMessage
	bra.w	JmpTo63_DeleteObject
; ===========================================================================
;loc_359A6
Obj5A_MostRingsWin:
	subi_.w	#1,objoff_2A(a0)
	beq.s	+
	rts
; ===========================================================================
+
	move.w	#$A,d0			; MOST RINGS WINS
	bsr.w	Obj5A_PrintPhrase
	bra.w	JmpTo63_DeleteObject
; ===========================================================================
;loc_359BC
Obj5A_RingCheckTrigger:
	subi_.w	#1,objoff_2A(a0)
	beq.s	+
	rts
; ===========================================================================
+
	st.b	(SS_Check_Rings_flag).w
	bra.w	SSClearObjs
; ===========================================================================
;loc_359CE
Obj5A_Handshake:
	cmpi.b	#$15,mapping_frame(a0)		; Is this the hand?
	bne.s	++							; if not, branch
	move.w	objoff_30(a0),d0			; Target y position for handshake
	tst.b	objoff_2E(a0)
	bne.s	+
	subi_.w	#1,y_pos(a0)
	subi_.w	#4,d0
	cmp.w	y_pos(a0),d0
	blt.s	++
	addi_.w	#1,d0
	move.w	d0,y_pos(a0)
	st.b	objoff_2E(a0)
	bra.s	++
; ===========================================================================
+
	addi_.w	#1,y_pos(a0)
	addi_.w	#4,d0
	cmp.w	y_pos(a0),d0
	bgt.s	+
	subi_.w	#1,d0
	move.w	d0,y_pos(a0)
	sf.b	objoff_2E(a0)
+
	subi_.w	#1,objoff_2A(a0)
	bne.w	JmpTo44_DisplaySprite
	tst.b	objoff_2F(a0)
	beq.s	+
-
	move.w	#MusID_FadeOut,d0
	jsr	(PlayMusic).l
	move.w	#$30,objoff_2A(a0)
	move.b	#$C,routine(a0)	; => Obj5A_RingCheckTrigger
	rts
; ===========================================================================
+
	cmpi.b	#$15,mapping_frame(a0)		; Is this the hand?
	bne.w	JmpTo63_DeleteObject		; Branch if not
	tst.w	objoff_30(a0)
	beq.w	JmpTo63_DeleteObject
	tst.b	(SS_2p_Flag).w			; Is this VS mode?
	beq.s	+							; Branch if not
	bsr.w	Obj5A_VSReset
	cmpi.b	#3,(Current_Special_Act).w
	beq.s	-
	move.w	#$A,d0
	bsr.w	Obj5A_PrintPhrase
	bra.w	JmpTo63_DeleteObject
; ===========================================================================
+
	bsr.w	Obj5A_CreateRingReqMessage
	bra.w	JmpTo63_DeleteObject
; ===========================================================================
;loc_35A7A
Obj5A_VSReset:
	lea	(SS2p_RingBuffer).w,a3
	moveq	#0,d0
	move.b	(Current_Special_Act).w,d0
	subq.w	#1,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(Ring_count).w,(a3,d0.w)
	move.w	(Ring_count_2P).w,2(a3,d0.w)
	move.w	#0,(Ring_count).w
	move.w	#0,(Ring_count_2P).w
	moveq	#0,d0
	move.w	d0,(MainCharacter+ss_rings_base).w
	move.b	d0,(MainCharacter+ss_rings_units).w
	move.w	d0,(Sidekick+ss_rings_base).w
	move.b	d0,(Sidekick+ss_rings_units).w
	rts
; ===========================================================================
;loc_35AB6
Obj5A_CreateCheckpointWingedHand:
	move.w	#$48,d4
	tst.b	(SS_2p_Flag).w		; Is this VS mode?
	beq.s	+						; Branch if not
	move.w	#$1C,d4
+
	jsrto	SSAllocateObject, JmpTo2_SSAllocateObject
	bne.w	+		; rts
	move.b	#ObjID_SSMessage,id(a1) ; load obj5A
	move.b	#6,routine(a1)	; => Obj5A_Handshake
	move.l	#Obj5A_MapUnc_35E1E,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialMessages,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#1,priority(a1)
	move.w	d3,x_pos(a1)
	move.w	d4,y_pos(a1)
	move.w	#$46,objoff_2A(a1)
	move.b	#$14,mapping_frame(a1)		; Checkpoint wings
	movea.l	a1,a2
	jsrto	SSAllocateObject, JmpTo2_SSAllocateObject
	bne.s	+		; rts
	move.b	#ObjID_SSMessage,id(a1) ; load obj5A
	move.b	#6,routine(a1)	; => Obj5A_Handshake
	move.l	#Obj5A_MapUnc_35E1E,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialMessages,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#0,priority(a1)
	move.w	d3,x_pos(a1)
	move.w	d4,y_pos(a1)
	move.w	d4,objoff_30(a1)			; Target y position for handshake
	move.w	#$46,objoff_2A(a1)
	move.b	#$15,mapping_frame(a1)		; Checkpoint hand
	cmpi.w	#6,d0						; Does player have enough rings?
	bne.s	+							; If yes, return
	st.b	objoff_2F(a1)				; Flag for failed checkpoint
	bset	#1,render_flags(a1)			; Point thumb down
+
	rts
; ===========================================================================
;loc_35B5A
Obj5A_TextFlyoutInit:
	subi_.w	#1,objoff_2A(a0)
	bne.w	JmpTo44_DisplaySprite
	cmpi.b	#$13,mapping_frame(a0)		; Is this the hand or wings?
	bgt.w	JmpTo63_DeleteObject		; If yes, branch
	move.b	#8,routine(a0)			; Obj5A_TextFlyout
	move.w	#8,objoff_14(a0)
	move.w	x_pos(a0),d1
	subi.w	#$80,d1
	move.w	y_pos(a0),d2
	subi.w	#$70,d2
	jsrto	CalcAngle, JmpTo_CalcAngle
	move.b	d0,angle(a0)
	bra.w	JmpTo44_DisplaySprite
; ===========================================================================
; this makes special stage messages like "most rings wins!" fly off the screen
;loc_35B96
Obj5A_TextFlyout:
	moveq	#0,d0
	move.b	angle(a0),d0
	jsrto	CalcSine, JmpTo14_CalcSine
	muls.w	objoff_14(a0),d0
	muls.w	objoff_14(a0),d1
	asr.w	#8,d0
	asr.w	#8,d1
	add.w	d1,x_pos(a0)
	add.w	d0,y_pos(a0)
	cmpi.w	#0,x_pos(a0)
	blt.w	JmpTo63_DeleteObject
	cmpi.w	#$100,x_pos(a0)
	bgt.w	JmpTo63_DeleteObject
	cmpi.w	#0,y_pos(a0)
	blt.w	JmpTo63_DeleteObject
	bra.w	JmpTo44_DisplaySprite
; ===========================================================================
;loc_35BD6
Obj5A_PrintNumber:
	jsrto	SSAllocateObjectAfterCurrent, JmpTo_SSAllocateObjectAfterCurrent
	bne.s	+		; rts
	move.b	d0,mapping_frame(a1)
	move.l	#Obj5F_MapUnc_72D2,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialHUD,2,0),art_tile(a1)
	move.b	#ObjID_SSMessage,id(a1) ; load obj5A
	move.b	#4,routine(a1)			; Obj5A_TextFlyoutInit
	move.b	#4,render_flags(a1)
	move.b	#1,priority(a1)
	move.w	d1,x_pos(a1)
	move.w	d2,y_pos(a1)
	move.w	#$46,objoff_2A(a1)
+
	rts
; ===========================================================================
; Subroutine to draw checkpoint or message text
; d0 = text ID
; d1 = x position of first letter
; d2 = y position
;loc_35C14
Obj5A_PrintWord:
	lea	SSMessage_TextFrames(pc),a3
	adda.w	(a3,d0.w),a3

-	move.b	(a3)+,d0
	bmi.s	+		; rts
	jsrto	SSAllocateObjectAfterCurrent, JmpTo_SSAllocateObjectAfterCurrent
	bne.s	+		; rts
	move.b	d0,mapping_frame(a1)
	move.l	#Obj5A_MapUnc_35E1E,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialMessages,2,0),art_tile(a1)
	move.b	#ObjID_SSMessage,id(a1) ; load obj5A
	move.b	#4,routine(a1)			; Obj5A_TextFlyoutInit
	move.b	#4,render_flags(a1)
	move.b	#1,priority(a1)
	move.w	d1,x_pos(a1)
	move.w	d2,y_pos(a1)
	move.w	#$46,objoff_2A(a1)
	addq.w	#8,d1
	bra.s	-
; ===========================================================================
+
	rts
; ===========================================================================
 ; temporarily remap characters to title card letter format
 ; Characters are encoded as Aa, Bb, Cc, etc. through a macro
 charset 'a','z','A'	; Convert to uppercase
 charset 'A',"\xD\x11\7\x11\1\x11"
 charset 'G',0	; can't have an embedded 0 in a string
 charset 'H',"\xB\4\x11\x11\9\xF\5\8\xC\x11\3\6\2\xA\x11\x10\x11\xE\x11"
 charset '!',"\x11"
 charset '.',"\x12"

; Text words
;off_35C62
SSMessage_TextFrames:	offsetTable
		offsetTableEntry.w byte_35C86	;  0
		offsetTableEntry.w byte_35C8A	;  2
		offsetTableEntry.w byte_35C90	;  4
		offsetTableEntry.w byte_35C96	;  6
		offsetTableEntry.w byte_35C9A	;  8
		offsetTableEntry.w byte_35CA1	; $A
		offsetTableEntry.w byte_35CA8	; $C
		offsetTableEntry.w byte_35CAD	; $E
		offsetTableEntry.w byte_35CB3	;$10
		offsetTableEntry.w byte_35CB9	;$12
		offsetTableEntry.w byte_35CBF	;$14
		offsetTableEntry.w byte_35CC4	;$16
		offsetTableEntry.w byte_35CC8	;$18
		offsetTableEntry.w byte_35CCE	;$1A
		offsetTableEntry.w byte_35CD3	;$1C
		offsetTableEntry.w byte_35CD5	;$1E
		offsetTableEntry.w byte_35CD9	;$20
		offsetTableEntry.w byte_35CDB	;$22
byte_35C86:	specialText "GET"
	rev02even
byte_35C8A:	specialText "RINGS"
	rev02even
byte_35C90:	specialText "COOL!"
	rev02even
byte_35C96:	specialText "NOT"
	rev02even
byte_35C9A:	specialText "ENOUGH"
	rev02even
byte_35CA1:	specialText "PLAYER"
	rev02even
byte_35CA8:	specialText "MOST"
	rev02even
byte_35CAD:	specialText "WINS!"
	rev02even
byte_35CB3:	specialText "SONIC"
	rev02even
byte_35CB9:	specialText "MILES"
	rev02even
byte_35CBF:	specialText "TIE!"
	rev02even
byte_35CC4:	specialText "WIN"
	rev02even
byte_35CC8:	specialText "TWICE"
	rev02even
byte_35CCE:	specialText "ALL!"
	rev02even
byte_35CD3:	specialText "!"
	rev02even
byte_35CD5:	specialText "..."
	rev02even
byte_35CD9:	dc.b $13,$FF						; VS
	rev02even
byte_35CDB:	specialText "TAILS"
	even

 charset ; revert character set

; ===========================================================================
;loc_35CE2
Obj5A_CreateRingReqMessage:
	moveq	#0,d0				; GET
	move.w	#$54,d1				; x
	move.w	#$6C,d2				; y
	bsr.w	Obj5A_PrintWord
	jsrto	SSStartNewAct, JmpTo_SSStartNewAct
	move.w	d1,d4				; Binary coded decimal ring requirements
	move.w	d2,d5				; Digit count - 1 (minumum 2 digits)
	movea.w	d2,a3				; Copy of above, but in a3.
	move.w	#$80,d1				; x position of least digit
	cmpi.w	#2,d2				; Do we need hundreds digit?
	beq.s	+					; if yes, branch
	subi_.w	#8,d1				; Otherwise, move digits to the left

+	move.w	#$6C,d2				; y position of digits

-	move.w	d4,d6				; Copy BCD reuirements
	lsr.w	#4,d4				; Next BCD digit
	andi.w	#$F,d6				; Extract least digit
	move.b	d6,d0
	swap	d5
	bsr.w	Obj5A_PrintNumber
	subi_.w	#8,d1				; Set position for next digit
	swap	d5
	dbf	d5,-

	moveq	#2,d0				; RINGS!
	lea	(SSMessage_TextPhrases).l,a2
	adda.w	(a2,d0.w),a2
	move.w	#$6C,d2				; y
	move.w	#$84,d1				; x
	cmpa.w	#2,a3				; Do we need space for hundreds digit?
	bne.s	+					; Branch if not
	addi_.w	#8,d1				; Move digits to right

/	moveq	#0,d0
	move.b	(a2)+,d0
	bmi.s	+
	bsr.w	Obj5A_PrintWord
	bra.s	-
; ===========================================================================
+
	rts
; ===========================================================================
;loc_35D52
Obj5A_PrintCheckpointMessage:
	move.w	#$80,d3				; x
	bsr.w	Obj5A_CreateCheckpointWingedHand
	cmpi.w	#1,(Player_mode).w
	ble.s	loc_35D6E
	addi.w	#palette_line_1,art_tile(a1)
	addi.w	#palette_line_1,art_tile(a2)

loc_35D6E:
	move.w	#$74,d1				; x
	move.w	#$68,d2				; y
	lea	(SSMessage_TextPhrases).l,a2
	adda.w	(a2,d0.w),a2		; Fetch phrase
	cmpi.b	#4,d0				; Is it 'COOL!'?
	beq.s	+					; Branch if yes
	move.w	#$5E,d1				; Move text otherwise

/	moveq	#0,d0
	move.b	(a2)+,d0
	bmi.s	++			; rts
	cmpi.b	#2,d0
	bne.s	+
	move.w	#$5E,d1				; x
	move.w	#$7E,d2				; y
+
	bsr.w	Obj5A_PrintWord
	addi_.w	#8,d1
	bra.s	-
; ===========================================================================
+
	rts
; ===========================================================================
;loc_35DAA
Obj5A_PrintPhrase:
	move.w	d0,d3
	subq.w	#8,d3
	lsr.w	#1,d3
	moveq	#0,d1
	move.b	byte_35DD6(pc,d3.w),d1
	move.w	#$48,d2
	lea	(SSMessage_TextPhrases).l,a2
	adda.w	(a2,d0.w),a2

-	moveq	#0,d0
	move.b	(a2)+,d0
	bmi.s	+			; rts
	bsr.w	Obj5A_PrintWord
	addi_.w	#8,d1
	bra.s	-
; ===========================================================================
+
	rts
; ===========================================================================
byte_35DD6:
	dc.b $48
	dc.b $44	; 1
	dc.b $58	; 2
	dc.b $58	; 3
	dc.b $74	; 4
	dc.b $3C	; 5
	dc.b $58	; 6
	dc.b   0	; 7
	even

; Text phrases
;off_35DDE
SSMessage_TextPhrases:	offsetTable
		offsetTableEntry.w byte_35DF6	;  0
		offsetTableEntry.w byte_35DF7	;  2
		offsetTableEntry.w byte_35DFA	;  4
		offsetTableEntry.w byte_35DFC	;  6
		offsetTableEntry.w byte_35E01	;  8
		offsetTableEntry.w byte_35E05	; $A
		offsetTableEntry.w byte_35E09	; $C
		offsetTableEntry.w byte_35E0C	; $E
		offsetTableEntry.w byte_35E0F	;$10
		offsetTableEntry.w byte_35E11	;$12
		offsetTableEntry.w byte_35E16	;$14
		offsetTableEntry.w byte_35E19	;$16
byte_35DF6:	dc.b $FF					; (empty)
byte_35DF7:	dc.b   2,$1C,$FF			; RINGS!
byte_35DFA:	dc.b   4,$FF				; COOL!
byte_35DFC:	dc.b   6,  8,  2,$1E,$FF	; NOT ENOUGH RINGS...
byte_35E01:	dc.b  $A,$20, $A,$FF		; PLAYER VS PLAYER
byte_35E05:	dc.b  $C,  2, $E,$FF		; MOST RINGS WINS
byte_35E09:	dc.b $10, $E,$FF			; SONIC WINS
byte_35E0C:	dc.b $12, $E,$FF			; MILES WINS
byte_35E0F:	dc.b $14,$FF				; TIE!
byte_35E11:	dc.b $16,$18,$16,$1A,$FF	; WIN TWICE WIN ALL!
byte_35E16:	dc.b $22, $E,$FF			; TAILS WINS
byte_35E19:	dc.b   2,$24,$26,$1C,$FF	; RINGS ?? ?? !
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj5A_MapUnc_35E1E:	include "mappings/sprite/obj5A.asm"
; ===========================================================================

loc_35F76:
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	move.w	word_35F92(pc,d0.w),(Normal_palette_line4+$16).w
	move.w	word_35F92+2(pc,d0.w),(Normal_palette_line4+$18).w
	move.w	word_35F92+4(pc,d0.w),(Normal_palette_line4+$1A).w
	rts
; ===========================================================================
; Special Stage Chaos Emerald palette
word_35F92:	BINCLUDE	"art/palettes/SS Emerald.bin"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 59 - Emerald from Special Stage
; ----------------------------------------------------------------------------
; Sprite_35FBC:
Obj59:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj59_Index(pc,d0.w),d1
	jmp	Obj59_Index(pc,d1.w)
; ===========================================================================
; off_35FCA:
Obj59_Index:	offsetTable
		offsetTableEntry.w Obj59_Init	; 0
		offsetTableEntry.w loc_36022	; 2
		offsetTableEntry.w loc_3533A	; 4
		offsetTableEntry.w loc_36160	; 6
		offsetTableEntry.w loc_36172	; 8
; ===========================================================================
; loc_35FD4:
Obj59_Init:
	st.b	(SS_NoCheckpointMsg_flag).w
	st.b	(SS_Pause_Only_flag).w
	subi_.w	#1,objoff_2A(a0)
	cmpi.w	#-$3C,objoff_2A(a0)
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+
	moveq	#0,d0
	move.b	(Current_Special_Stage).w,d0
	bsr.s	loc_35F76
	addq.b	#2,routine(a0)
	move.l	#Obj59_MapUnc_3625A,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialEmerald,3,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.w	#$36,objoff_30(a0)
	move.b	#$40,angle(a0)
	bsr.w	loc_3529C

loc_36022:
	bsr.w	loc_360F0
	bsr.w	loc_3512A
	bsr.w	loc_3603C
	lea	(off_36228).l,a1
	bsr.w	loc_3539E
	bra.w	JmpTo44_DisplaySprite
; ===========================================================================

loc_3603C:
	move.w	d7,-(sp)
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	movea.l	(SS_CurrentPerspective).w,a1
	adda_.l	#2,a1
	move.w	objoff_30(a0),d0
	subq.w	#1,d0
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	move.b	(a1,d0.w),d2
	move.b	1(a1,d0.w),d3
	move.b	2(a1,d0.w),d4
	move.b	3(a1,d0.w),d5
	move.w	d5,d6
	swap	d5
	move.w	d6,d5
	move.w	d4,d6
	swap	d4
	move.w	d6,d4
	bpl.s	loc_36088
	cmpi.b	#$48,d3
	blo.s	loc_36088
	ext.w	d3

loc_36088:
	move.w	d4,d6
	add.w	d4,d4
	add.w	d6,d4
	lsr.w	#2,d4
	move.w	d5,d6
	add.w	d5,d5
	add.w	d6,d5
	lsr.w	#2,d5
	move.b	angle(a0),d0
	jsrto	CalcSine, JmpTo14_CalcSine
	muls.w	d4,d1
	muls.w	d5,d0
	asr.l	#8,d0
	asr.l	#8,d1
	add.w	d2,d1
	add.w	d3,d0
	move.w	d1,x_pos(a0)
	move.w	d0,y_pos(a0)
	move.b	d1,objoff_3A(a0)
	move.b	d0,objoff_3B(a0)
	swap	d4
	swap	d5
	movea.l	objoff_34(a0),a1 ; a1=object
	move.b	angle(a0),d0
	jsrto	CalcSine, JmpTo14_CalcSine
	move.w	d4,d6
	lsr.w	#2,d6
	add.w	d6,d4
	muls.w	d4,d1
	move.w	d5,d6
	asr.w	#2,d6
	add.w	d6,d5
	muls.w	d5,d0
	asr.l	#8,d0
	asr.l	#8,d1
	add.w	d2,d1
	add.w	d3,d0
	move.w	d1,x_pos(a1)
	move.w	d0,y_pos(a1)
	move.w	(sp)+,d7
	rts
; ===========================================================================

loc_360F0:
	cmpi.b	#3,anim(a0)
	blo.s	return_36140
	tst.b	objoff_3E(a0)
	bne.s	loc_3610C
	move.w	#MusID_FadeOut,d0
	jsr	(PlayMusic).l
	st.b	objoff_3E(a0)

loc_3610C:
	cmpi.b	#6,anim(a0)
	blo.s	return_36140
	move.w	(Ring_count).w,d2
	add.w	(Ring_count_2P).w,d2
	cmp.w	(SS_Ring_Requirement).w,d2
	blt.s	loc_36142
	cmpi.b	#9,anim(a0)
	blo.s	return_36140
	move.w	#$63,objoff_2A(a0)
	move.b	#8,routine(a0)
	move.w	#MusID_Emerald,d0
	jsr	(PlayMusic).l

return_36140:
	rts
; ===========================================================================

loc_36142:
	move.l	#0,(SS_New_Speed_Factor).w
	move.b	#6,routine(a0)
	move.w	#$4F,objoff_2A(a0)
	move.w	#6,d0
	bsr.w	loc_35D6E
	rts
; ===========================================================================

loc_36160:
	subi_.w	#1,objoff_2A(a0)
	bpl.w	JmpTo44_DisplaySprite
	st.b	(SS_Check_Rings_flag).w
	bra.w	SSClearObjs
; ===========================================================================

loc_36172:
	subi_.w	#1,objoff_2A(a0)
	bpl.s	loc_361A4
	moveq	#0,d0
	move.b	(Current_Special_Stage).w,d0
	lea	(Got_Emeralds_array).w,a0
	st.b	(a0,d0.w)
	st.b	(Got_Emerald).w
	addi_.b	#1,(Current_Special_Stage).w
	addi_.b	#1,(Emerald_count).w
	st.b	(SS_Check_Rings_flag).w
	bsr.w	SSClearObjs
	move.l	(sp)+,d0
	rts
; ===========================================================================

loc_361A4:
	addi_.b	#1,objoff_3C(a0)
	moveq	#0,d0
	moveq	#0,d2
	move.b	objoff_3B(a0),d2
	move.b	objoff_3C(a0),d0
	lsr.w	#2,d0
	andi.w	#3,d0
	add.b	byte_361C8(pc,d0.w),d2
	move.w	d2,y_pos(a0)
	bra.w	JmpTo44_DisplaySprite
; ===========================================================================
byte_361C8:
	dc.b $FF
	dc.b   0	; 1
	dc.b   1	; 2
	dc.b   0	; 3
	even
; ===========================================================================
;loc_361CC
SSClearObjs:
	movea.l	#(Object_RAM&$FFFFFF),a1

	move.w	#(Object_RAM_End-Object_RAM)/$10-1,d0
	moveq	#0,d1

loc_361D8:
    rept $10/4
	move.l	d1,(a1)+
    endm
	dbf	d0,loc_361D8
.c := ((Object_RAM_End-Object_RAM)#$10)/4
    if .c
    rept .c
	move.l	d1,(a1)+
    endm
    endif
.c := ((Object_RAM_End-Object_RAM)#$10)&2
    if .c
    rept .c
	move.w	d1,(a1)+
    endm
    endif

    if fixBugs
	clearRAM Sprite_Table,Sprite_Table_End
    else
	; The '+4' shouldn't be here; clearRAM accidentally clears an additional 4 bytes.
	clearRAM Sprite_Table,Sprite_Table_End+4
    endif

	rts
; ===========================================================================
	; unused/dead code ; a0=object
	cmpi.b	#$B,(SSTrack_drawing_index).w
	blo.s	loc_36208
	subi.l	#$4445,objoff_30(a0)
	bra.s	loc_36210
; ---------------------------------------------------------------------------
loc_36208:
	subi.l	#$4444,objoff_30(a0)
loc_36210:
	move.w	objoff_30(a0),d0
	cmpi.w	#$1D,d0
	ble.s	+
	moveq	#$1E,d0
+
	lea_	byte_35180,a1
	move.b	(a1,d0.w),anim(a0)
	rts
	; end of unused code

; ===========================================================================
; animation script for object 59
off_36228:	offsetTable
		offsetTableEntry.w byte_3623C	; 0
		offsetTableEntry.w byte_3623F	; 1
		offsetTableEntry.w byte_36242	; 2
		offsetTableEntry.w byte_36245	; 3
		offsetTableEntry.w byte_36248	; 4
		offsetTableEntry.w byte_3624B	; 5
		offsetTableEntry.w byte_3624E	; 6
		offsetTableEntry.w byte_36251	; 7
		offsetTableEntry.w byte_36254	; 8
		offsetTableEntry.w byte_36257	; 9
byte_3623C:
	dc.b  $B,  0,$FF
	rev02even
byte_3623F:
	dc.b  $B,  1,$FF
	rev02even
byte_36242:
	dc.b  $B,  2,$FF
	rev02even
byte_36245:
	dc.b  $B,  3,$FF
	rev02even
byte_36248:
	dc.b  $B,  4,$FF
	rev02even
byte_3624B:
	dc.b  $B,  5,$FF
	rev02even
byte_3624E:
	dc.b  $B,  6,$FF
	rev02even
byte_36251:
	dc.b  $B,  7,$FF
	rev02even
byte_36254:
	dc.b  $B,  8,$FF
	rev02even
byte_36257:
	dc.b  $B,  9,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj59_MapUnc_3625A:	include "mappings/sprite/obj59.asm"

; animation script:
; off_362D2:
Ani_obj5B_obj60:offsetTable
		offsetTableEntry.w byte_362E8	;  0
		offsetTableEntry.w byte_362EE	;  1
		offsetTableEntry.w byte_362F4	;  2
		offsetTableEntry.w byte_362FA	;  3
		offsetTableEntry.w byte_36300	;  4
		offsetTableEntry.w byte_36306	;  5
		offsetTableEntry.w byte_3630C	;  6
		offsetTableEntry.w byte_36312	;  7
		offsetTableEntry.w byte_36318	;  8
		offsetTableEntry.w byte_3631E	;  9
		offsetTableEntry.w byte_36324	; $A
byte_362E8: dc.b   5,  0, $A,$14, $A,$FF
	rev02even
byte_362EE: dc.b   5,  1, $B,$15, $B,$FF
	rev02even
byte_362F4: dc.b   5,  2, $C,$16, $C,$FF
	rev02even
byte_362FA: dc.b   5,  3, $D,$17, $D,$FF
	rev02even
byte_36300: dc.b   5,  4, $E,$18, $E,$FF
	rev02even
byte_36306: dc.b   5,  5, $F,$19, $F,$FF
	rev02even
byte_3630C: dc.b   5,  6,$10,$1A,$10,$FF
	rev02even
byte_36312: dc.b   5,  7,$11,$1B,$11,$FF
	rev02even
byte_36318: dc.b   5,  8,$12,$1C,$12,$FF
	rev02even
byte_3631E: dc.b   5,  9,$13,$1D,$13,$FF
	rev02even
byte_36324: dc.b   1,$1E,$1F,$20,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj5A_Obj5B_Obj60_MapUnc_3632A:	include "mappings/sprite/obj5A_5B_60.asm"

; animation script:
; off_364CE:
Ani_obj61:	offsetTable
		offsetTableEntry.w byte_364E4	;  0
		offsetTableEntry.w byte_364E7	;  1
		offsetTableEntry.w byte_364EA	;  2
		offsetTableEntry.w byte_364ED	;  3
		offsetTableEntry.w byte_364F0	;  4
		offsetTableEntry.w byte_364F3	;  5
		offsetTableEntry.w byte_364F6	;  6
		offsetTableEntry.w byte_364F9	;  7
		offsetTableEntry.w byte_364FC	;  8
		offsetTableEntry.w byte_364FF	;  9
		offsetTableEntry.w byte_36502	; $A
byte_364E4: dc.b  $B,  0,$FF
	rev02even
byte_364E7: dc.b  $B,  1,$FF
	rev02even
byte_364EA: dc.b  $B,  2,$FF
	rev02even
byte_364ED: dc.b  $B,  3,$FF
	rev02even
byte_364F0: dc.b  $B,  4,$FF
	rev02even
byte_364F3: dc.b  $B,  5,$FF
	rev02even
byte_364F6: dc.b  $B,  6,$FF
	rev02even
byte_364F9: dc.b  $B,  7,$FF
	rev02even
byte_364FC: dc.b  $B,  8,$FF
	rev02even
byte_364FF: dc.b  $B,  9,$FF
	rev02even
byte_36502: dc.b   2, $A, $B, $C,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj61_MapUnc_36508:	include "mappings/sprite/obj61.asm"
; ===========================================================================

JmpTo44_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
; ===========================================================================

    if ~~removeJmpTos
JmpTo63_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo24_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo_SSStartNewAct ; JmpTo
	jmp	(SSStartNewAct).l
JmpTo_CalcAngle ; JmpTo
	jmp	(CalcAngle).l
JmpTo14_CalcSine ; JmpTo
	jmp	(CalcSine).l
JmpTo7_ObjectMoveAndFall ; JmpTo
	jmp	(ObjectMoveAndFall).l
JmpTo_SSAllocateObjectAfterCurrent ; JmpTo
	jmp	(SSAllocateObjectAfterCurrent).l
JmpTo2_SSAllocateObject ; JmpTo
	jmp	(SSAllocateObject).l

	align 4
    endif
