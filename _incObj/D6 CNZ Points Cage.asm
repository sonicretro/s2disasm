; ----------------------------------------------------------------------------
; Object D6 - Cage that gives out points from CNZ
; ----------------------------------------------------------------------------
; Sprite_2BB6C:
ObjD6:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjD6_Index(pc,d0.w),d1
	jmp	ObjD6_Index(pc,d1.w)
; ===========================================================================
; off_2BB7A:
ObjD6_Index:	offsetTable
		offsetTableEntry.w ObjD6_Init	; 0
		offsetTableEntry.w ObjD6_Main	; 2
; ===========================================================================
; loc_2BB7E:
ObjD6_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjD6_MapUnc_2BEBC,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZCage,0,0),art_tile(a0)
	jsrto	JmpTo54_Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$18,width_pixels(a0)
	move.b	#1,priority(a0)
; loc_2BBA6:
ObjD6_Main:
	move.w	#$23,d1
	move.w	#$10,d2
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	lea	objoff_30(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	bsr.w	loc_2BBE8
	movem.l	(sp)+,d1-d4
	lea	objoff_34(a0),a2 ; a2=object
	lea	(Sidekick).w,a1 ; a1=character
	moveq	#p2_standing_bit,d6
	bsr.w	loc_2BBE8
	lea	(Ani_objD6).l,a1
	jsrto	JmpTo10_AnimateSprite
	jmpto	JmpTo29_MarkObjGone
; ===========================================================================

loc_2BBE8:
	move.w	(a2),d0
	move.w	off_2BBF2(pc,d0.w),d0
	jmp	off_2BBF2(pc,d0.w)
; ===========================================================================
off_2BBF2:	offsetTable
		offsetTableEntry.w loc_2BBF8	; 0
		offsetTableEntry.w loc_2BDF8	; 2
		offsetTableEntry.w loc_2BE9C	; 4
; ===========================================================================

loc_2BBF8:
	tst.b	obj_control(a1)
	bne.w	return_2BC84
	tst.b	subtype(a0)
	beq.s	loc_2BC0C
	tst.w	(SlotMachineInUse).w
	bne.s	return_2BC84

loc_2BC0C:
	jsrto	JmpTo7_SolidObject_Always_SingleCharacter
	tst.w	d4
	bpl.s	return_2BC84
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	#0,x_vel(a1)
	move.w	#0,y_vel(a1)
	move.w	#0,inertia(a1)
	move.b	#$81,obj_control(a1)
	bset	#status.player.rolling,status(a1)
	move.b	#$E,y_radius(a1)
	move.b	#7,x_radius(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	move.b	#1,anim(a0)
	addq.w	#2,(a2)+
	move.w	#$78,(a2)
	move.w	a1,parent(a0)
	tst.b	subtype(a0)
	beq.s	return_2BC84
	cmpi.b	#$18,(SlotMachine_Routine).w	; Is it the null routine?
	bne.s	return_2BC84					; Branch if not
	move.b	#8,(SlotMachine_Routine).w		; => SlotMachine_Routine3
	clr.w	objoff_2E(a0)
	move.w	#-1,(SlotMachineInUse).w
	move.w	#-1,objoff_2A(a0)

return_2BC84:
	rts
; ===========================================================================

loc_2BC86:
	move.w	(SlotMachine_Reward).w,d0
	bpl.w	loc_2BD4E
	tst.w	objoff_2A(a0)
	bpl.s	+
	move.w	#$64,objoff_2A(a0)
+
	tst.w	objoff_2A(a0)
	beq.w	+
	btst	#0,(Level_frame_counter+1).w
	beq.w	loc_2BD48
	cmpi.w	#$10,objoff_2C(a0)
	bhs.w	loc_2BD48
	jsrto	JmpTo10_AllocateObject
	bne.w	loc_2BD48
	_move.b	#ObjID_BombPrize,id(a1) ; load objD3
	move.l	#ObjD3_MapUnc_2B8D4,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZBonusSpike,0,0),art_tile(a1)
	jsrto	JmpTo6_Adjust2PArtPointer2
	move.b	#1<<render_flags.level_fg,render_flags(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#4,priority(a1)
	move.w	#$1E,casino_prize_display_delay(a1)
	move.w	objoff_2E(a0),objoff_2E(a1)
	addi.w	#$90,objoff_2E(a0)
	move.w	x_pos(a0),casino_prize_machine_x_pos(a1)
	move.w	y_pos(a0),casino_prize_machine_y_pos(a1)
	move.w	objoff_2E(a1),d0
	jsrto	JmpTo12_CalcSine
	asr.w	#1,d1
	add.w	casino_prize_machine_x_pos(a1),d1
	move.w	d1,casino_prize_x_pos(a1)
	move.w	d1,x_pos(a1)
	asr.w	#1,d0
	add.w	casino_prize_machine_y_pos(a1),d0
	move.w	d0,casino_prize_y_pos(a1)
	move.w	d0,y_pos(a1)
	lea	objoff_2C(a0),a2
	move.l	a2,objoff_2A(a1)
	move.w	parent(a0),parent(a1)
	addq.w	#1,objoff_2C(a0)
	subq.w	#1,objoff_2A(a0)
+
	tst.w	objoff_2C(a0)
	beq.w	loc_2BE2E

loc_2BD48:
	addq.w	#1,(Bonus_Countdown_3).w
	rts
; ===========================================================================

loc_2BD4E:
	beq.w	+
	btst	#0,(Level_frame_counter+1).w
	beq.w	return_2BDF6
	cmpi.w	#$10,objoff_2C(a0)
	bhs.w	return_2BDF6
	jsrto	JmpTo10_AllocateObject
	bne.w	return_2BDF6
	_move.b	#ObjID_RingPrize,id(a1) ; load objDC
	move.l	#Obj25_MapUnc_12382,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,1,0),art_tile(a1)
	jsrto	JmpTo6_Adjust2PArtPointer2
	move.b	#1<<render_flags.level_fg,render_flags(a1)
	move.b	#3,priority(a1)
	move.b	#8,width_pixels(a1)
	move.w	#$1A,casino_prize_display_delay(a1)
	move.w	objoff_2E(a0),objoff_2E(a1)
	addi.w	#$89,objoff_2E(a0)
	move.w	x_pos(a0),casino_prize_machine_x_pos(a1)
	move.w	y_pos(a0),casino_prize_machine_y_pos(a1)
	move.w	objoff_2E(a1),d0
	jsrto	JmpTo12_CalcSine
	asr.w	#1,d1
	add.w	casino_prize_machine_x_pos(a1),d1
	move.w	d1,casino_prize_x_pos(a1)
	move.w	d1,x_pos(a1)
	asr.w	#1,d0
	add.w	casino_prize_machine_y_pos(a1),d0
	move.w	d0,casino_prize_y_pos(a1)
	move.w	d0,y_pos(a1)
	lea	objoff_2C(a0),a2
	move.l	a2,objoff_2A(a1)
	move.w	parent(a0),parent(a1)
	addq.w	#1,objoff_2C(a0)
	subq.w	#1,(SlotMachine_Reward).w
+
	tst.w	objoff_2C(a0)
	beq.s	loc_2BE2E

return_2BDF6:
	rts
; ===========================================================================

loc_2BDF8:
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.s	loc_2BE2E
	tst.b	subtype(a0)
	beq.s	loc_2BE28
	move.w	a1,objoff_3E(a0)
	cmpi.b	#$18,(SlotMachine_Routine).w	; Is it the null routine?
	beq.w	loc_2BC86						; Branch if yes
	move.b	(Vint_runcount+3).w,d0
	andi.w	#$F,d0
	bne.s	+	; rts
	move.w	#SndID_CasinoBonus,d0
	jsr	(PlaySound).l
+
	rts
; ===========================================================================

loc_2BE28:
	subq.w	#1,2(a2)
	bpl.s	loc_2BE5E

loc_2BE2E:
	move.w	#0,objoff_2C(a0)
	move.b	#0,anim(a0)
	move.b	#0,objoff_2A(a1)
	bclr	d6,status(a0)
	bclr	#status.player.on_object,status(a1)
	bset	#status.player.in_air,status(a1)
	move.w	#$400,y_vel(a1)
	addq.w	#2,(a2)+
	move.w	#$1E,(a2)
	rts
; ===========================================================================

loc_2BE5E:
	move.w	2(a2),d0
	andi.w	#$F,d0
	bne.s	+	; rts
	move.w	#SndID_CasinoBonus,d0
	jsr	(PlaySound).l
	moveq	#10,d0
	movea.w	a1,a3
	jsr	(AddPoints2).l
	jsrto	JmpTo10_AllocateObject
	bne.s	+	; rts
	_move.b	#ObjID_Points,id(a1) ; load obj29
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#0,mapping_frame(a1)
+
	rts
; ===========================================================================

loc_2BE9C:
	subq.w	#1,2(a2)
	bpl.s	+	; rts
	clr.w	(a2)
	tst.b	subtype(a0)
	beq.s	+	; rts
	clr.w	(SlotMachineInUse).w
+
	rts
