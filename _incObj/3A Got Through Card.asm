; ----------------------------------------------------------------------------
; Object 3A - End of level results screen
; ----------------------------------------------------------------------------
; Sprite_14086:
Obj3A: ; (screen-space obj)
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj3A_Index(pc,d0.w),d1
	jmp	Obj3A_Index(pc,d1.w)
; ===========================================================================
; off_14094:
Obj3A_Index:	offsetTable
		offsetTableEntry.w loc_140AC					;   0
		offsetTableEntry.w loc_14102					;   2
		offsetTableEntry.w BranchTo_Obj34_MoveTowardsTargetPosition	;   4
		offsetTableEntry.w loc_14146					;   6
		offsetTableEntry.w loc_14168					;   8
		offsetTableEntry.w loc_1419C					;  $A
		offsetTableEntry.w loc_141AA					;  $C
		offsetTableEntry.w loc_1419C					;  $E
		offsetTableEntry.w loc_14270					; $10
		offsetTableEntry.w loc_142B0					; $12
		offsetTableEntry.w loc_142CC					; $14
		offsetTableEntry.w loc_1413A					; $16
; ===========================================================================

loc_140AC:
	tst.l	(Plc_Buffer).w
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+
	movea.l	a0,a1
	lea	Obj3A_SubObjectMetadata(pc),a2
	moveq	#bytesToXcnt(Obj3A_SubObjectMetadata_End-Obj3A_SubObjectMetadata, results_screen_object_size),d1

loc_140BC:
	_move.b	id(a1),d0
	beq.s	loc_140CE
	cmpi.b	#ObjID_Results,d0
	beq.s	loc_140CE
	lea	next_object(a1),a1 ; a1=object
	bra.s	loc_140BC
; ===========================================================================

loc_140CE:

	_move.b	#ObjID_Results,id(a1) ; load obj3A
	move.w	(a2)+,x_pixel(a1)
	move.w	(a2)+,titlecard_x_target(a1)
	move.w	(a2)+,y_pixel(a1)
	move.b	(a2)+,routine(a1)
	move.b	(a2)+,mapping_frame(a1)
	move.l	#MapUnc_EOLTitleCards,mappings(a1)
	bsr.w	Adjust2PArtPointer2
	move.b	#0,render_flags(a1)
	lea	next_object(a1),a1 ; a1=object
	dbf	d1,loc_140BC

loc_14102:
	moveq	#0,d0
	cmpi.w	#2,(Player_mode).w
	bne.s	loc_14118
	addq.w	#1,d0
	btst	#7,(Graphics_Flags).w
	beq.s	loc_14118
	addq.w	#1,d0

loc_14118:

	move.b	d0,mapping_frame(a0)
	bsr.w	Obj34_MoveTowardsTargetPosition
	move.w	x_pixel(a0),d0
	cmp.w	titlecard_x_target(a0),d0
	bne.w	return_14138
	move.b	#$A,routine(a0)
	move.w	#$B4,anim_frame_duration(a0)

return_14138:
	rts
; ===========================================================================

loc_1413A:
	tst.w	(Perfect_rings_left).w
	bne.w	DeleteObject

BranchTo_Obj34_MoveTowardsTargetPosition ; BranchTo
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================

loc_14146:
	move.b	(Current_Zone).w,d0
	cmpi.b	#sky_chase_zone,d0
	beq.s	loc_1415E
	cmpi.b	#wing_fortress_zone,d0
	beq.s	loc_1415E
	cmpi.b	#death_egg_zone,d0
	bne.w	Obj34_MoveTowardsTargetPosition

loc_1415E:

	move.b	#5,mapping_frame(a0)
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================

loc_14168:
	move.b	(Current_Zone).w,d0
	cmpi.b	#sky_chase_zone,d0
	beq.w	BranchTo9_DeleteObject
	cmpi.b	#wing_fortress_zone,d0
	beq.w	BranchTo9_DeleteObject
	cmpi.b	#death_egg_zone,d0
	beq.w	BranchTo9_DeleteObject
	cmpi.b	#metropolis_zone_2,d0
	bne.s	loc_1418E
	moveq	#8,d0
	bra.s	loc_14194
; ===========================================================================

loc_1418E:
	move.b	(Current_Act).w,d0
	addq.b	#6,d0

loc_14194:
	move.b	d0,mapping_frame(a0)
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================

loc_1419C:
	subq.w	#1,anim_frame_duration(a0)
	bne.s	BranchTo18_DisplaySprite
	addq.b	#2,routine(a0)

BranchTo18_DisplaySprite ; BranchTo
	bra.w	DisplaySprite
; ===========================================================================

loc_141AA:
	bsr.w	DisplaySprite
	move.b	#1,(Update_Bonus_score).w
	moveq	#0,d0
	tst.w	(Bonus_Countdown_1).w
	beq.s	loc_141C6
	addi.w	#10,d0
	subi.w	#10,(Bonus_Countdown_1).w

loc_141C6:
	tst.w	(Bonus_Countdown_2).w
	beq.s	loc_141D6
	addi.w	#10,d0
	subi.w	#10,(Bonus_Countdown_2).w

loc_141D6:
	tst.w	(Bonus_Countdown_3).w
	beq.s	loc_141E6
	addi.w	#10,d0
	subi.w	#10,(Bonus_Countdown_3).w

loc_141E6:
	add.w	d0,(Total_Bonus_Countdown).w
	tst.w	d0
	bne.s	loc_14256
	move.w	#SndID_TallyEnd,d0
	jsr	(PlaySound).l
	addq.b	#2,routine(a0)
	move.w	#$B4,anim_frame_duration(a0)
	cmpi.w	#1000,(Total_Bonus_Countdown).w
	blo.s	return_14254
	move.w	#$12C,anim_frame_duration(a0)
	lea	next_object(a0),a1 ; a1=object

loc_14214:
	_tst.b	id(a1)
	beq.s	loc_14220
	lea	next_object(a1),a1 ; a1=object
	bra.s	loc_14214
; ===========================================================================

loc_14220:
	_move.b	#ObjID_Results,id(a1) ; load obj3A (uses screen-space)
	move.b	#$12,routine(a1)
	move.w	#spriteScreenPositionXCentered(104),x_pixel(a1)
	move.w	#spriteScreenPositionYCentered(40),y_pixel(a1)
	move.l	#MapUnc_EOLTitleCards,mappings(a1)
	bsr.w	Adjust2PArtPointer2
	move.b	#0,render_flags(a1)
	move.w	#60,anim_frame_duration(a1)
	addq.b	#1,(Continue_count).w

return_14254:

	rts
; ===========================================================================

loc_14256:
	jsr	(AddPoints).l
	move.b	(Vint_runcount+3).w,d0
	andi.b	#3,d0
	bne.s	return_14254
	move.w	#SndID_Blip,d0
	jmp	(PlaySound).l
; ===========================================================================

loc_14270:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	add.b	(Current_Act).w,d0
	add.w	d0,d0
	lea	LevelOrder(pc),a1
	tst.w	(Two_player_mode).w
	beq.s	loc_1428C
	lea	LevelOrder_2P(pc),a1

loc_1428C:
	move.w	(a1,d0.w),d0
	tst.w	d0
	bpl.s	loc_1429C
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ===========================================================================

loc_1429C:
	move.w	d0,(Current_ZoneAndAct).w
	clr.b	(Last_star_pole_hit).w
	clr.b	(Last_star_pole_hit_2P).w
	move.w	#1,(Level_Inactive_flag).w
	rts
; ===========================================================================

loc_142B0:
	tst.w	anim_frame_duration(a0)
	beq.s	loc_142BC
	subq.w	#1,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_142BC:
	addi_.b	#2,routine(a0)
	move.w	#SndID_ContinueJingle,d0
	jsr	(PlaySound).l

loc_142CC:
	subq.w	#1,anim_frame_duration(a0)
	bpl.s	loc_142E2
	move.w	#$13,anim_frame_duration(a0)
	addq.b	#1,anim_frame(a0)
	andi.b	#1,anim_frame(a0)

loc_142E2:
	moveq	#$C,d0
	add.b	anim_frame(a0),d0
	move.b	d0,mapping_frame(a0)
	btst	#4,(Level_frame_counter+1).w
	bne.w	DisplaySprite
	rts
