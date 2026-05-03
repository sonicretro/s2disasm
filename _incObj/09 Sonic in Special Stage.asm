; ----------------------------------------------------------------------------
; Object 09 - Sonic in Special Stage
; ----------------------------------------------------------------------------
; Sprite_338EC:
Obj09:
	bsr.w	loc_33908
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj09_Index(pc,d0.w),d1
	jmp	Obj09_Index(pc,d1.w)
; ===========================================================================
; off_338FE:
Obj09_Index:	offsetTable
		offsetTableEntry.w Obj09_Init	; 0
		offsetTableEntry.w Obj09_MdNormal	; 2
		offsetTableEntry.w Obj09_MdJump	; 4
		offsetTableEntry.w Obj09_Index	; 6 - invalid
		offsetTableEntry.w Obj09_MdAir	; 8
; ===========================================================================

loc_33908:
	lea	(SS_Ctrl_Record_Buf_End).w,a1

	moveq	#bytesToWcnt(SS_Ctrl_Record_Buf_End-SS_Ctrl_Record_Buf)-1,d0
-	move.w	-4(a1),-(a1)
	dbf	d0,-

	move.w	(Ctrl_1_Logical).w,-(a1)
	rts
; ===========================================================================
; loc_3391C:
Obj09_Init:
	move.b	#2,routine(a0)
	moveq	#0,d0
	move.l	d0,ss_x_pos(a0)
	move.w	#$80,d1
	move.w	d1,ss_y_pos(a0)
	move.w	d0,ss_y_sub(a0)
	add.w	(SS_Offset_X).w,d0
	move.w	d0,x_pos(a0)
	add.w	(SS_Offset_Y).w,d1
	move.w	d1,y_pos(a0)
	move.b	#$E,y_radius(a0)
	move.b	#7,x_radius(a0)
	move.l	#Obj09_MapUnc_34212,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialSonic,1,0),art_tile(a0)
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#3,priority(a0)
	move.w	#$6E,ss_z_pos(a0)
	clr.b	(SS_Swap_Positions_Flag).w
	move.w	#$400,ss_init_flip_timer(a0)
	move.b	#$40,angle(a0)
	move.b	#1,(Sonic_LastLoadedDPLC).w
	clr.b	ss_slide_timer(a0)
	bclr	#status.player.ss.slowing,status(a0)
	clr.b	collision_property(a0)
	clr.b	ss_dplc_timer(a0)
	movea.l	#SpecialStageShadow_Sonic,a1
	move.b	#ObjID_SSShadow,id(a1) ; load obj63 (shadow) at $FFFFB140
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$18,y_pos(a1)
	move.l	#Obj63_MapUnc_34492,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialFlatShadow,3,0),art_tile(a1)
	move.b	#1<<render_flags.level_fg,render_flags(a1)
	move.b	#4,priority(a1)
	move.l	a0,ss_parent(a1)
	bra.w	LoadSSSonicDynPLC
; ===========================================================================

Obj09_MdNormal:
	tst.b	routine_secondary(a0)
	bne.s	Obj09_Hurt
	lea	(Ctrl_1_Held_Logical).w,a2
	bsr.w	SSPlayer_Move
	bsr.w	SSPlayer_Traction
	bsr.w	SSPlayerSwapPositions
	bsr.w	SSObjectMove
	bsr.w	SSAnglePos
	bsr.w	SSSonic_Jump
	bsr.w	SSPlayer_SetAnimation
	lea	(off_341E4).l,a1
	bsr.w	SSPlayer_Animate
	bsr.w	SSPlayer_Collision
	bra.w	LoadSSSonicDynPLC
; ===========================================================================

Obj09_Hurt:
	bsr.w	SSHurt_Animation
	bsr.w	SSPlayerSwapPositions
	bsr.w	SSObjectMove
	bsr.w	SSAnglePos
	bra.w	LoadSSSonicDynPLC
; ===========================================================================

SSHurt_Animation:
	moveq	#0,d0
	move.b	ss_hurt_timer(a0),d0
	addi_.b	#8,d0
	move.b	d0,ss_hurt_timer(a0)
	bne.s	+
	move.b	#0,routine_secondary(a0)
	move.b	#$1E,ss_dplc_timer(a0)
+
	add.b	angle(a0),d0
	andi.b	#~(1<<render_flags.x_flip|1<<render_flags.y_flip),render_flags(a0)
	subi.b	#$10,d0
	lsr.b	#5,d0
	add.w	d0,d0
	move.b	byte_33A92(pc,d0.w),mapping_frame(a0)
	move.b	byte_33A92+1(pc,d0.w),d0
	or.b	d0,render_flags(a0)
	move.b	ss_hurt_timer(a0),d0
	subi_.b	#8,d0
	bne.s	return_33A90
	move.b	d0,collision_property(a0)
	cmpa.l	#MainCharacter,a0
	bne.s	+
	tst.w	(Ring_count).w
	beq.s	return_33A90
	bra.s	++
; ===========================================================================
+
	tst.w	(Ring_count_2P).w
	beq.s	return_33A90
+
	jsrto	JmpTo_SSAllocateObject
	bne.s	return_33A90
	move.l	a0,ss_parent(a1)
	move.b	#ObjID_SSRingSpill,id(a1) ; load obj5B

return_33A90:
	rts
; ===========================================================================
byte_33A92:
	dc.b   4,   TRUE<<render_flags.x_flip|FALSE<<render_flags.y_flip
	dc.b   0,  FALSE<<render_flags.x_flip|FALSE<<render_flags.y_flip	; 2
	dc.b   4,  FALSE<<render_flags.x_flip|FALSE<<render_flags.y_flip	; 4
	dc.b  $C,  FALSE<<render_flags.x_flip|FALSE<<render_flags.y_flip	; 6
	dc.b   4,  FALSE<<render_flags.x_flip| TRUE<<render_flags.y_flip	; 8
	dc.b   0,  FALSE<<render_flags.x_flip| TRUE<<render_flags.y_flip	; 10
	dc.b   4,   TRUE<<render_flags.x_flip| TRUE<<render_flags.y_flip	; 12
	dc.b  $C,   TRUE<<render_flags.x_flip|FALSE<<render_flags.y_flip	; 14
dword_33AA2:
	dc.l   (SSRAM_ArtNem_SpecialSonicAndTails & $FFFFFF) + tiles_to_bytes($000)		; Sonic in upright position, $58 tiles
	dc.l   (SSRAM_ArtNem_SpecialSonicAndTails & $FFFFFF) + tiles_to_bytes($058)		; Sonic in diagonal position, $CC tiles
	dc.l   (SSRAM_ArtNem_SpecialSonicAndTails & $FFFFFF) + tiles_to_bytes($124)		; Sonic in horizontal position, $4D tiles
	dc.l   (SSRAM_ArtNem_SpecialSonicAndTails & $FFFFFF) + tiles_to_bytes($171)		; Sonic in ball form, $12 tiles
; ===========================================================================

LoadSSSonicDynPLC:
	move.b	ss_dplc_timer(a0),d0
	beq.s	+
	subq.b	#1,d0
	move.b	d0,ss_dplc_timer(a0)
	andi.b	#1,d0
	beq.s	+
	rts
; ===========================================================================
+
	jsrto	JmpTo42_DisplaySprite
	lea	dword_33AA2(pc),a3
	lea	(Sonic_LastLoadedDPLC).w,a4
	move.w	#tiles_to_bytes(ArtTile_ArtNem_SpecialSonic),d4
	moveq	#0,d1

LoadSSPlayerDynPLC:
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	cmp.b	(a4),d0
	beq.s	return_33B3E
	move.b	d0,(a4)
	moveq	#0,d6
	cmpi.b	#4,d0
	blt.s	loc_33AFE
	addq.w	#4,d6
	cmpi.b	#$C,d0
	blt.s	loc_33AFE
	addq.w	#4,d6
	cmpi.b	#$10,d0
	blt.s	loc_33AFE
	addq.b	#4,d6

loc_33AFE:
	move.l	(a3,d6.w),d6
	add.w	d1,d0
	add.w	d0,d0
	lea	(Obj09_MapRUnc_345FA).l,a2
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d5
	subq.w	#1,d5
	bmi.s	return_33B3E

SSPLC_ReadEntry:
	moveq	#0,d1
	move.w	(a2)+,d1
	move.w	d1,d3
	lsr.w	#8,d3
	andi.w	#$F0,d3
	addi.w	#$10,d3
	andi.w	#$FFF,d1
	lsl.w	#1,d1
	add.l	d6,d1
	move.w	d4,d2
	add.w	d3,d4
	add.w	d3,d4
	jsr	(QueueDMATransfer).l
	dbf	d5,SSPLC_ReadEntry

return_33B3E:
	rts
; ===========================================================================

SSSonic_Jump:
	lea	(Ctrl_1_Press_Logical).w,a2

SSPlayer_Jump:
	move.b	(a2),d0
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0
	beq.w	return_33BAC
	move.w	#$780,d2
	moveq	#0,d0
	move.b	angle(a0),d0
	addi.b	#$80,d0
	jsr	(CalcSine).l
	muls.w	d2,d1
	asr.l	#8,d1
	add.w	d1,x_vel(a0)
	muls.w	d2,d0
	asr.l	#7,d0
	add.w	d0,y_vel(a0)
	bset	#status.player.ss.jumping,status(a0)
	move.b	#4,routine(a0)
	move.b	#3,anim(a0)
	moveq	#0,d0
	move.b	d0,anim_frame_duration(a0)
	move.b	d0,anim_frame(a0)
	move.b	d0,collision_property(a0)
	tst.b	(SS_2p_Flag).w
	bne.s	loc_33B9E
	tst.w	(Player_mode).w
	bne.s	loc_33BA2

loc_33B9E:
	not.b	(SS_Swap_Positions_Flag).w

loc_33BA2:
	move.w	#SndID_Jump,d0
	jsr	(PlaySound).l

return_33BAC:
	rts
; ===========================================================================

Obj09_MdJump:
	lea	(Ctrl_1_Held_Logical).w,a2
	bsr.w	SSPlayer_ChgJumpDir
	bsr.w	SSObjectMoveAndFall
	bsr.w	SSPlayer_JumpAngle
	bsr.w	SSPlayer_DoLevelCollision
	bsr.w	SSPlayerSwapPositions
	bsr.w	SSAnglePos
	lea	(off_341E4).l,a1
	bsr.w	SSPlayer_Animate
	bra.w	LoadSSSonicDynPLC
; ===========================================================================

Obj09_MdAir:
	lea	(Ctrl_1_Held_Logical).w,a2
	bsr.w	SSPlayer_ChgJumpDir
	bsr.w	SSObjectMoveAndFall
	bsr.w	SSPlayer_JumpAngle
	bsr.w	SSPlayer_DoLevelCollision
	bsr.w	SSPlayerSwapPositions
	bsr.w	SSAnglePos
	bsr.w	SSPlayer_SetAnimation
	lea	(off_341E4).l,a1
	bsr.w	SSPlayer_Animate
	bra.w	LoadSSSonicDynPLC
; ===========================================================================

SSObjectMoveAndFall:
	move.l	ss_x_pos(a0),d2
	move.l	ss_y_pos(a0),d3
	move.w	x_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d2
	move.w	y_vel(a0),d0
	addi.w	#$A8,y_vel(a0)	; Apply gravity
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d2,ss_x_pos(a0)
	move.l	d3,ss_y_pos(a0)
	rts
; ===========================================================================

SSPlayer_ChgJumpDir:
	move.b	(a2),d0
	btst	#button_left,d0
	bne.s	+
	btst	#button_right,d0
	bne.w	++
	rts
; ===========================================================================
+
	subi.w	#$40,x_vel(a0)
	rts
; ===========================================================================
+
	addi.w	#$40,x_vel(a0)
	rts
; ===========================================================================

SSPlayer_JumpAngle:
	moveq	#0,d2
	moveq	#0,d3
	move.w	ss_y_pos(a0),d2
	bmi.s	SSPlayer_JumpAngle_above_screen
	move.w	ss_x_pos(a0),d3
	bmi.s	+++
	cmp.w	d2,d3
	blo.s	++
	bne.s	+
	tst.w	d3
	bne.s	+
	move.b	#$40,angle(a0)
	rts
; ===========================================================================
+
	lsl.l	#5,d2
	divu.w	d3,d2
	move.b	d2,angle(a0)
	rts
; ===========================================================================
+
	lsl.l	#5,d3
	divu.w	d2,d3
	subi.w	#$40,d3
	neg.w	d3
	move.b	d3,angle(a0)
	rts
; ===========================================================================
+
	neg.w	d3
	cmp.w	d2,d3
	bhs.s	+
	lsl.l	#5,d3
	divu.w	d2,d3
	addi.w	#$40,d3
	move.b	d3,angle(a0)
	rts
; ===========================================================================
+
	lsl.l	#5,d2
	divu.w	d3,d2
	subi.w	#$80,d2
	neg.w	d2
	move.b	d2,angle(a0)
	rts
; ===========================================================================

SSPlayer_JumpAngle_above_screen:
	neg.w	d2
	move.w	ss_x_pos(a0),d3
	bpl.s	++
	neg.w	d3
	cmp.w	d2,d3
	blo.s	+
	lsl.l	#5,d2
	divu.w	d3,d2
	addi.w	#$80,d2
	move.b	d2,angle(a0)
	rts
; ===========================================================================
+
	lsl.l	#5,d3
	divu.w	d2,d3
	subi.w	#$C0,d3
	neg.w	d3
	move.b	d3,angle(a0)
	rts
; ===========================================================================
+
	cmp.w	d2,d3
	bhs.s	+
	lsl.l	#5,d3
	divu.w	d2,d3
	addi.w	#$C0,d3
	move.b	d3,angle(a0)
	rts
; ===========================================================================
+
	lsl.l	#5,d2
	divu.w	d3,d2
	subi.w	#$100,d2
	neg.w	d2
	move.b	d2,angle(a0)
	rts
; ===========================================================================

loc_33D02:
	moveq	#0,d6
	moveq	#0,d0
	move.w	ss_x_pos(a1),d0
	bpl.s	loc_33D10
	st.b	d6
	neg.w	d0

loc_33D10:
	lsl.l	#7,d0
	divu.w	ss_z_pos(a1),d0
	move.b	byte_33D32(pc,d0.w),d0
	tst.b	d6
	bne.s	loc_33D24
	subi.b	#$80,d0
	neg.b	d0

loc_33D24:
	tst.w	ss_y_pos(a1)
	bpl.s	loc_33D2C
	neg.b	d0

loc_33D2C:
	move.b	d0,angle(a0)
	rts
; ===========================================================================
byte_33D32:
	dc.b $40,$40,$40,$40,$41,$41,$41,$42,$42,$42,$43,$43,$43,$44,$44,$44
	dc.b $45,$45,$45,$46,$46,$46,$47,$47,$47,$48,$48,$48,$48,$49,$49,$49; 16
	dc.b $4A,$4A,$4A,$4B,$4B,$4B,$4C,$4C,$4C,$4D,$4D,$4D,$4E,$4E,$4E,$4F; 32
	dc.b $4F,$50,$50,$50,$51,$51,$51,$52,$52,$52,$53,$53,$53,$54,$54,$54; 48
	dc.b $55,$55,$56,$56,$56,$57,$57,$57,$58,$58,$59,$59,$59,$5A,$5A,$5B; 64
	dc.b $5B,$5B,$5C,$5C,$5D,$5D,$5E,$5E,$5E,$5F,$5F,$60,$60,$61,$61,$62; 80
	dc.b $62,$63,$63,$64,$64,$65,$65,$66,$66,$67,$67,$68,$68,$69,$6A,$6A; 96
	dc.b $6B,$6C,$6C,$6D,$6E,$6E,$6F,$70,$71,$72,$73,$74,$75,$77,$78,$7A; 112
	dc.b $80,  0	; 128
	even
; ===========================================================================

SSPlayer_DoLevelCollision:
	move.w	ss_y_pos(a0),d0
	ble.s	+
	muls.w	d0,d0
	move.w	ss_x_pos(a0),d1
	muls.w	d1,d1
	add.w	d1,d0
	move.w	ss_z_pos(a0),d1
	mulu.w	d1,d1
	cmp.l	d1,d0
	blo.s	+
	move.b	#2,routine(a0)
	bclr	#status.player.ss.jumping,status(a0)
	moveq	#0,d0
	move.w	d0,x_vel(a0)
	move.w	d0,y_vel(a0)
	move.w	d0,inertia(a0)		; This makes player stop on ground
	move.b	d0,ss_slide_timer(a0)
	bset	#status.player.ss.slowing,status(a0)
	bsr.w	SSObjectMove
	bsr.w	SSAnglePos
+
	rts
; ===========================================================================

SSPlayer_Collision:
	tst.b	collision_property(a0)
	beq.s	return_33E42
	clr.b	collision_property(a0)
	tst.b	ss_dplc_timer(a0)
	bne.s	return_33E42
	clr.b	inertia(a0)		; clears only high byte, leaving a bit of speed
	cmpa.l	#MainCharacter,a0
	bne.s	+
	st.b	(SS_Swap_Positions_Flag).w
	tst.w	(Ring_count).w
	beq.s	loc_33E38
	bra.s	++
; ===========================================================================
+
	clr.b	(SS_Swap_Positions_Flag).w
	tst.w	(Ring_count_2P).w
	beq.s	loc_33E38
+
	move.w	#SndID_RingSpill,d0
	jsr	(PlaySound).l

loc_33E38:
	move.b	#2,routine_secondary(a0)		; hurt state
	clr.b	ss_hurt_timer(a0)

return_33E42:
	rts
; ===========================================================================

SSPlayerSwapPositions:
	tst.w	(Player_mode).w
	bne.s	return_33E8E
	move.w	ss_z_pos(a0),d0
	cmpa.l	#MainCharacter,a0
	bne.s	loc_33E5E
	tst.b	(SS_Swap_Positions_Flag).w
	beq.s	loc_33E6E
	bra.s	loc_33E64
; ===========================================================================

loc_33E5E:
	tst.b	(SS_Swap_Positions_Flag).w
	bne.s	loc_33E6E

loc_33E64:
	cmpi.w	#$80,d0
	beq.s	return_33E8E
	addq.w	#1,d0
	bra.s	loc_33E76
; ===========================================================================

loc_33E6E:
	cmpi.w	#$6E,d0
	beq.s	return_33E8E
	subq.w	#1,d0

loc_33E76:
	move.w	d0,ss_z_pos(a0)
	cmpi.w	#$77,d0
	bhs.s	loc_33E88
	move.b	#3,priority(a0)
	rts
; ===========================================================================

loc_33E88:
	move.b	#2,priority(a0)

return_33E8E:
	rts
; ===========================================================================
ss_make_direction_bitfield function xFlip,yFlip,xFlip<<status.player.ss.x_flip|yFlip<<status.player.ss.y_flip

byte_33E90:
	dc.b	ss_make_direction_bitfield( TRUE, FALSE), ss_make_direction_bitfield( TRUE, FALSE)	; 0
	dc.b	ss_make_direction_bitfield(FALSE, FALSE), ss_make_direction_bitfield(FALSE, FALSE)	; 2
	dc.b	ss_make_direction_bitfield( TRUE, FALSE), ss_make_direction_bitfield(FALSE, FALSE)	; 4
	dc.b	ss_make_direction_bitfield(FALSE,  TRUE), ss_make_direction_bitfield(FALSE, FALSE)	; 6
	dc.b	ss_make_direction_bitfield( TRUE, FALSE), ss_make_direction_bitfield(FALSE,  TRUE)	; 8
	dc.b	ss_make_direction_bitfield(FALSE, FALSE), ss_make_direction_bitfield(FALSE,  TRUE)	; 10
	dc.b	ss_make_direction_bitfield( TRUE, FALSE), ss_make_direction_bitfield( TRUE,  TRUE)	; 12
	dc.b	ss_make_direction_bitfield(FALSE,  TRUE), ss_make_direction_bitfield( TRUE, FALSE)	; 14
; ===========================================================================

SSPlayer_SetAnimation:
	btst	#status.player.ss.jumping,status(a0)
	beq.s	+
	move.b	#3,anim(a0)
	andi.b	#~(1<<status.player.ss.x_flip|1<<status.player.ss.y_flip),status(a0)
	rts
; ===========================================================================
+
	moveq	#0,d0
	move.b	angle(a0),d0
	subi.b	#$10,d0
	lsr.b	#5,d0
	move.b	d0,d1
	add.w	d0,d0
	move.b	byte_33E90(pc,d0.w),d2
	cmp.b	anim(a0),d2
	bne.s	+
	cmp.b	ss_last_angle_index(a0),d1
	beq.s	return_33EFE
+
	move.b	d1,ss_last_angle_index(a0)
	move.b	d2,anim(a0)
	move.b	byte_33E90+1(pc,d0.w),d0
	andi.b	#~(1<<status.player.ss.x_flip|1<<status.player.ss.y_flip),status(a0)
	or.b	d0,status(a0)
	cmpi.b	#1,d1
	beq.s	loc_33EF8
	cmpi.b	#5,d1
	bne.s	return_33EFE

loc_33EF8:
	move.w	#$400,ss_init_flip_timer(a0)

return_33EFE:
	rts
; ===========================================================================

SSPlayer_Animate:
	moveq	#0,d0
	move.b	anim(a0),d0
	cmp.b	prev_anim(a0),d0
	beq.s	SSAnim_Do
	move.b	#0,anim_frame(a0)
	move.b	d0,prev_anim(a0)
	move.b	#0,anim_frame_duration(a0)

SSAnim_Do:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	SSAnim_Delay
	add.w	d0,d0
	adda.w	(a1,d0.w),a1
	move.b	(SS_player_anim_frame_timer).w,d0
	lsr.b	#1,d0
	move.b	d0,anim_frame_duration(a0)
	cmpi.b	#0,anim(a0)
	bne.s	+
	subi_.b	#1,ss_flip_timer(a0)
	bgt.s	+
	bchg	#status.player.ss.x_flip,status(a0)
	bchg	#render_flags.x_flip,render_flags(a0)
	move.b	ss_init_flip_timer(a0),ss_flip_timer(a0)
+
	moveq	#0,d1
	move.b	anim_frame(a0),d1
	move.b	1(a1,d1.w),d0
	bpl.s	+
	move.b	#0,anim_frame(a0)
	move.b	1(a1),d0
+
	andi.b	#$7F,d0
	move.b	d0,mapping_frame(a0)
	move.b	status(a0),d1
	andi.b	#1<<status.player.ss.x_flip|1<<status.player.ss.y_flip,d1
	andi.b	#~(1<<render_flags.x_flip|1<<render_flags.y_flip),render_flags(a0)
	or.b	d1,render_flags(a0)
	addq.b	#1,anim_frame(a0)

SSAnim_Delay:
	rts
; ===========================================================================

SSPlayer_Move:
	move.w	inertia(a0),d2
	move.b	(a2),d0
	btst	#button_left,d0
	bne.s	SSPlayer_MoveLeft
	btst	#button_right,d0
	bne.w	SSPlayer_MoveRight
	bset	#status.player.ss.slowing,status(a0)
	bne.s	+
	move.b	#$1E,ss_slide_timer(a0)
+
	move.b	angle(a0),d0
	bmi.s	+
	subi.b	#$38,d0
	cmpi.b	#$10,d0
	bhs.s	+
	move.w	d2,d1
	asr.w	#3,d1
	sub.w	d1,d2
	bra.s	++
; ===========================================================================
+
	move.w	d2,d1
	asr.w	#3,d1
	sub.w	d1,d2
+
	move.w	d2,inertia(a0)
	move.b	ss_slide_timer(a0),d0
	beq.s	+
	subq.b	#1,d0
	move.b	d0,ss_slide_timer(a0)
+
	rts
; ===========================================================================

SSPlayer_MoveLeft:
	addi.w	#$60,d2
	cmpi.w	#$600,d2
	ble.s	+
	move.w	#$600,d2
	bra.s	+
; ===========================================================================

SSPlayer_MoveRight:
	subi.w	#$60,d2
	cmpi.w	#-$600,d2
	bge.s	+
	move.w	#-$600,d2
+
	move.w	d2,inertia(a0)
	bclr	#status.player.ss.slowing,status(a0)
	clr.b	ss_slide_timer(a0)
	rts
; ===========================================================================

SSPlayer_Traction:
	tst.b	ss_slide_timer(a0)
	bne.s	+
	move.b	angle(a0),d0
	jsr	(CalcSine).l
	muls.w	#$50,d1
	asr.l	#8,d1
	add.w	d1,inertia(a0)
+
	move.b	angle(a0),d0
	bpl.s	return_34048
	addi_.b	#4,d0
	cmpi.b	#-$78,d0
	blo.s	return_34048
	mvabs.w	inertia(a0),d0
	cmpi.w	#$100,d0
	bhs.s	return_34048
	move.b	#8,routine(a0)

return_34048:
	rts
; ===========================================================================

SSObjectMove:
	moveq	#0,d0
	moveq	#0,d1
	move.w	inertia(a0),d2
	bpl.s	+
	neg.w	d2
	lsr.w	#8,d2
	sub.b	d2,angle(a0)
	bra.s	++
; ===========================================================================
+
	lsr.w	#8,d2
	add.b	d2,angle(a0)
+
	move.b	angle(a0),d0
	jsr	(CalcSine).l
	muls.w	ss_z_pos(a0),d1
	asr.l	#8,d1
	move.w	d1,ss_x_pos(a0)
	muls.w	ss_z_pos(a0),d0
	asr.l	#8,d0
	move.w	d0,ss_y_pos(a0)
	rts
; ===========================================================================

SSAnglePos:
	move.w	ss_x_pos(a0),d0
	muls.w	#$CC,d0
	asr.l	#8,d0
	add.w	(SS_Offset_X).w,d0
	move.w	d0,x_pos(a0)
	move.w	ss_y_pos(a0),d0
	add.w	(SS_Offset_Y).w,d0
	move.w	d0,y_pos(a0)
	rts
