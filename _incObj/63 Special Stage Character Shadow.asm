; ----------------------------------------------------------------------------
; Object 63 - Character shadow from Special Stage
; ----------------------------------------------------------------------------
; Sprite_340A4:
Obj63:
	movea.l	ss_parent(a0),a1 ; a1=object
	cmpa.l	#MainCharacter,a1
	bne.s	loc_340BC
	movea.l	#MainCharacter,a1 ; a1=character
	bsr.s	loc_340CC
	jmpto	JmpTo42_DisplaySprite
; ===========================================================================

loc_340BC:
	movea.l	#Sidekick,a1 ; a1=object
	bsr.s	loc_340CC
	bsr.w	loc_341BA
	jmpto	JmpTo42_DisplaySprite
; ===========================================================================

loc_340CC:
	cmpi.b	#2,routine(a1)
	beq.w	loc_34108
	bsr.w	loc_33D02
	move.b	angle(a0),d0
	jsr	(CalcSine).l
	muls.w	ss_z_pos(a1),d1
	muls.w	#$CC,d1
	swap	d1
	add.w	(SS_Offset_X).w,d1
	move.w	d1,x_pos(a0)
	muls.w	ss_z_pos(a1),d0
	asr.l	#8,d0
	add.w	(SS_Offset_Y).w,d0
	move.w	d0,y_pos(a0)
	bra.w	loc_3411A
; ===========================================================================

loc_34108:
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.b	angle(a1),angle(a0)

loc_3411A:
	moveq	#0,d0
	move.b	angle(a0),d0
	subi.b	#$10,d0
	lsr.b	#5,d0
	move.b	d0,d1
	lsl.w	#3,d0
	lea	word_3417A(pc),a2
	adda.w	d0,a2
	move.w	(a2)+,art_tile(a0)
	move.w	(a2)+,d0
	add.w	d0,x_pos(a0)
	move.w	(a2)+,d0
	add.w	d0,y_pos(a0)
	move.b	(a2)+,mapping_frame(a0)
	move.b	render_flags(a0),d0
	andi.b	#~(1<<render_flags.x_flip|1<<render_flags.y_flip),d0
	or.b	(a2)+,d0
	move.b	d0,render_flags(a0)
	tst.b	angle(a0)
	bpl.s	return_34178
	cmpi.b	#3,d1
	beq.s	loc_34164
	cmpi.b	#7,d1
	bne.s	loc_3416A

loc_34164:
	addi_.b	#3,mapping_frame(a0)

loc_3416A:
	move.w	(SS_Offset_Y).w,d1
	sub.w	y_pos(a0),d1
	add.w	d1,d1
	add.w	d1,y_pos(a0)

return_34178:
	rts
; ===========================================================================
obj63_data macro artTile,xOffset,yOffset,frame,xFlip
	dc.w make_art_tile(artTile,3,0), xOffset, yOffset
	dc.b frame,xFlip<<render_flags.x_flip
    endm

word_3417A:
	obj63_data	ArtTile_ArtNem_SpecialDiagShadow,  $14,  $14,    1,  TRUE ; 0
	obj63_data	ArtTile_ArtNem_SpecialFlatShadow,    0,  $18,    0, FALSE ; 4
	obj63_data	ArtTile_ArtNem_SpecialDiagShadow, -$14,  $14,    1, FALSE ; 8
	obj63_data	ArtTile_ArtNem_SpecialSideShadow, -$14,    0,    2, FALSE ; 12
	obj63_data	ArtTile_ArtNem_SpecialDiagShadow, -$14, -$14,    7, FALSE ; 16
	obj63_data	ArtTile_ArtNem_SpecialFlatShadow,    0, -$18,    9, FALSE ; 20
	obj63_data	ArtTile_ArtNem_SpecialDiagShadow,  $14, -$14,    7,  TRUE ; 24
	obj63_data	ArtTile_ArtNem_SpecialSideShadow,  $14,    0,    2,  TRUE ; 28
; ===========================================================================

loc_341BA:
	cmpi.b	#1,anim(a1)
	bne.s	return_341E0
	move.b	status(a1),d1
	andi.w	#1<<status.npc.x_flip|1<<status.npc.y_flip,d1
	cmpi.b	#1<<status.npc.y_flip,d1
	bhs.s	return_341E0
	move.b	byte_341E2(pc,d1.w),d0
	ext.w	d0
	add.w	d0,x_pos(a0)
	subi_.w	#4,y_pos(a0)

return_341E0:
	rts
