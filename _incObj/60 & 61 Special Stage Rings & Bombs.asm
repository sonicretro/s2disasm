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
	move.b	#1<<render_flags.level_fg,render_flags(a0)
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
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.s	return_34F26
	bsr.w	loc_34F28
	jmpto	JmpTo44_DisplaySprite
; ===========================================================================

return_34F26:
	rts
; ===========================================================================

loc_34F28:
	move.w	#8,d6
	bsr.w	Obj61_TestCollision
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
	jsrto	JmpTo24_AnimateSprite
	jmpto	JmpTo44_DisplaySprite
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
	move.b	#1<<render_flags.level_fg,render_flags(a0)
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
	_btst	#render_flags.on_screen,render_flags(a0)
	_bne.w	JmpTo44_DisplaySprite
	rts
; ===========================================================================

loc_35010:
	move.b	#$A,anim(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialStars,2,0),art_tile(a0)
	bsr.w	loc_34F90
	bsr.w	loc_3512A
	bsr.w	loc_351A0
	lea	(Ani_obj5B_obj60).l,a1
	jsrto	JmpTo24_AnimateSprite
	jmpto	JmpTo44_DisplaySprite
; ===========================================================================

loc_35036:
	move.w	#$A,d6
	bsr.w	Obj61_TestCollision
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
; loc_350A0:
Obj61_TestCollision:
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
	btst	#status.npc.no_balancing,status(a0)
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
    if fixBugs
	; Save the last animation value to elsewhere, related to a bugfix below.
	move.b	anim(a0),objoff_23(a0)
    endif
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
	jmpto	JmpTo63_DeleteObject
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
	jsrto	JmpTo14_CalcSine
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
	jsrto	JmpTo14_CalcSine
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
	ori.b	#1<<render_flags.on_screen,render_flags(a0)

loc_35254:
	move.w	(sp)+,d7
	rts
; ===========================================================================

loc_35258:
	andi.b	#~(1<<render_flags.on_screen)&$FF,render_flags(a0)
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
	jsrto	JmpTo_SSAllocateObjectAfterCurrent
	bne.w	return_3532C
	move.l	a0,objoff_34(a1)
	move.b	id(a0),id(a1)
	move.b	#4,routine(a1)
	move.l	#Obj63_MapUnc_34492,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialFlatShadow,3,0),art_tile(a1)
	move.b	#1<<render_flags.level_fg,render_flags(a1)
	move.b	#5,priority(a1)
	move.b	angle(a0),d0
	cmpi.b	#$10,d0
	bgt.s	loc_352E6
	bset	#render_flags.x_flip,render_flags(a1)
	move.b	#2,objoff_2B(a1)
	move.l	a1,objoff_34(a0)
	rts
; ===========================================================================

loc_352E6:
	cmpi.b	#$30,d0
	bgt.s	loc_352FE
	bset	#render_flags.x_flip,render_flags(a1)
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
	_btst	#render_flags.on_screen,render_flags(a1)
	_bne.s	loc_3534E
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
	jmpto	JmpTo44_DisplaySprite
; ===========================================================================

BranchTo_JmpTo63_DeleteObject ; BranchTo
	jmpto	JmpTo63_DeleteObject
; ===========================================================================

loc_3539E:
    if fixBugs
	; anim_frame_duration causes many of the animations to look far choppier
	; than they should, or appear inconsistent. To solve this, we will store
	; the proper animation elsewhere and stop decrementing the frame duration
	; until both match up.
	move.b	objoff_23(a0),d0
	cmp.b	anim(a0),d0
	bne.s	.skip
    endif
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	return_353E8
    if fixBugs
.skip:
	move.b	anim(a0),objoff_23(a0)
    endif
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
	andi.b	#1<<status.npc.x_flip|1<<status.npc.y_flip,d1
	andi.b	#~(1<<render_flags.x_flip|1<<render_flags.y_flip),render_flags(a0)
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
