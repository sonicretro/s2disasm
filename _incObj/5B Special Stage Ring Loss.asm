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
	jsrto	JmpTo2_SSAllocateObject
	bne.s	loc_354DE

loc_3547E:
	move.b	#ObjID_SSRingSpill,id(a1) ; load obj5B
	move.b	#2,routine(a1)
	move.l	#Obj5A_Obj5B_Obj60_MapUnc_3632A,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialRings,3,0),art_tile(a1)
	move.b	#1<<render_flags.level_fg,render_flags(a1)
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
	jsrto	JmpTo7_ObjectMoveAndFall
	addi.w	#$80,y_vel(a0)
	bsr.w	loc_3551C
	tst.w	x_pos(a0)
	bmi.w	JmpTo63_DeleteObject
	cmpi.w	#screen_width_ss,x_pos(a0)
	bhs.w	JmpTo63_DeleteObject
	cmpi.w	#screen_height_ss,y_pos(a0)
	bgt.w	JmpTo63_DeleteObject
	lea	(Ani_obj5B_obj60).l,a1
	jsrto	JmpTo24_AnimateSprite
	jmpto	JmpTo44_DisplaySprite
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
