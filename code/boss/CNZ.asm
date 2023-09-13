; ===========================================================================
; ----------------------------------------------------------------------------
; Object 51 - CNZ boss
; ----------------------------------------------------------------------------
; Sprite_318F0:
Obj51:
	moveq	#0,d0
	move.b	boss_subtype(a0),d0
	move.w	Obj51_Index(pc,d0.w),d1
	jmp	Obj51_Index(pc,d1.w)
; ===========================================================================
; off_318FE:
Obj51_Index:	offsetTable
		offsetTableEntry.w Obj51_Init	; 0
		offsetTableEntry.w loc_31A04	; 2
		offsetTableEntry.w loc_31F24	; 4
; ===========================================================================
; loc_31904:
Obj51_Init:
	move.l	#Obj51_MapUnc_320EA,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZBoss_Fudge,0,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
    if ~~fixBugs
	; Multi-sprite objects cannot use the 'priority' SST as it is
	; overwritten by 'sub3_y_pos'.
	move.b	#3,priority(a0)
    endif
	move.w	#$2A46,x_pos(a0)
	move.w	#$654,y_pos(a0)
	move.b	#0,mainspr_mapframe(a0)
	move.b	#$20,mainspr_width(a0)
    if ~~fixBugs
	; This instruction is pointless, as bit 4 of 'render_flags' is never
	; set anyway. Also, it clashes with 'boss_invulnerable_time', as they
	; use the same SST slot. This causes this boss to behave in numerous
	; strange ways when it is first hit: no hit sound plays, the boss is
	; invulnerable for much longer than it should be, and Eggman takes a
	; while to react and show his hurt face.
	move.b	#$80,mainspr_height(a0)
    endif
	addq.b	#2,boss_subtype(a0)
	move.b	#0,boss_routine(a0)
	bset	#6,render_flags(a0)
	move.b	#4,mainspr_childsprites(a0)
	move.b	#$F,collision_flags(a0)
	move.b	#8,boss_hitcount2(a0)
	move.w	x_pos(a0),(Boss_X_pos).w
	move.w	y_pos(a0),(Boss_Y_pos).w
	move.w	x_pos(a0),sub2_x_pos(a0)
	move.w	y_pos(a0),sub2_y_pos(a0)
	move.b	#5,sub2_mapframe(a0)
	move.w	x_pos(a0),sub3_x_pos(a0)
	move.w	y_pos(a0),sub3_y_pos(a0)
	move.b	#1,sub3_mapframe(a0)
	move.w	x_pos(a0),sub4_x_pos(a0)
	move.w	y_pos(a0),sub4_y_pos(a0)
	move.b	#6,sub4_mapframe(a0)
	move.w	x_pos(a0),sub5_x_pos(a0)
	move.w	y_pos(a0),sub5_y_pos(a0)
	move.b	#2,sub5_mapframe(a0)
	move.b	#0,objoff_38(a0)
	move.w	#0,(Boss_Y_vel).w
	move.w	#-$180,(Boss_X_vel).w
	move.b	#0,objoff_2D(a0)
	move.w	#1,(Boss_Countdown).w
	bsr.w	loc_319D6
	rts
; ===========================================================================

loc_319D6:
	lea	(Boss_AnimationArray).w,a2
	move.b	#8,(a2)+
	move.b	#0,(a2)+
	move.b	#1,(a2)+
	move.b	#0,(a2)+
	move.b	#$10,(a2)+
	move.b	#0,(a2)+
	move.b	#3,(a2)+
	move.b	#0,(a2)+
	move.b	#2,(a2)+
	move.b	#0,(a2)+
	rts
; ===========================================================================

loc_31A04:
	tst.b	(Boss_CollisionRoutine).w
	beq.s	loc_31A1C
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	loc_31A1C
	move.b	#SndID_CNZBossZap,d0
	jsrto	PlaySound, JmpTo9_PlaySound

loc_31A1C:
	moveq	#0,d0
	move.b	boss_routine(a0),d0
	move.w	off_31A2A(pc,d0.w),d1
	jmp	off_31A2A(pc,d1.w)
; ===========================================================================
off_31A2A:	offsetTable
		offsetTableEntry.w loc_31A36	;  0
		offsetTableEntry.w loc_31BA8	;  2
		offsetTableEntry.w loc_31C22	;  4
		offsetTableEntry.w loc_31D5C	;  6
		offsetTableEntry.w loc_31DCC	;  8
		offsetTableEntry.w loc_31E2A	; $A
; ===========================================================================

loc_31A36:
	moveq	#0,d0
	move.b	objoff_38(a0),d0
	move.w	off_31A44(pc,d0.w),d0
	jmp	off_31A44(pc,d0.w)
; ===========================================================================
off_31A44:	offsetTable
		offsetTableEntry.w loc_31A48	; 0
		offsetTableEntry.w loc_31A78	; 2
; ===========================================================================

loc_31A48:
	cmpi.w	#$28C0,(Boss_X_pos).w
	bgt.s	BranchTo_loc_31AA4
	move.w	#$28C0,(Boss_X_pos).w
	move.w	#0,(Boss_Y_vel).w
	move.w	#$180,(Boss_X_vel).w
	move.b	#2,objoff_38(a0)
	bset	#0,render_flags(a0)
	move.b	#0,objoff_2D(a0)

BranchTo_loc_31AA4 ; BranchTo
	bra.w	loc_31AA4
; ===========================================================================

loc_31A78:
	cmpi.w	#$29C0,(Boss_X_pos).w
	blt.s	loc_31AA4
	move.w	#$29C0,(Boss_X_pos).w
	move.w	#0,(Boss_Y_vel).w
	move.w	#-$180,(Boss_X_vel).w
	move.b	#0,objoff_38(a0)
	bclr	#0,render_flags(a0)
	move.b	#0,objoff_2D(a0)

loc_31AA4:
	bsr.w	Boss_MoveObject
	tst.b	objoff_3F(a0)
	beq.s	loc_31AB6
	subq.b	#1,objoff_3F(a0)
	bra.w	loc_31B46
; ===========================================================================

loc_31AB6:
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	x_pos(a0),d0
	addi.w	#$10,d0
	cmpi.w	#$20,d0
	bhs.s	loc_31B46
	cmpi.w	#$6B0,(MainCharacter+y_pos).w
	blo.s	loc_31B06
	cmpi.b	#3,objoff_2D(a0)
	bhs.s	loc_31B46
	addq.b	#1,objoff_2D(a0)
	addq.b	#2,boss_routine(a0)
	move.b	#8,(Boss_AnimationArray).w
	move.b	#0,(Boss_AnimationArray+3).w
	move.b	#0,(Boss_AnimationArray+9).w
	move.b	#0,(Boss_CollisionRoutine).w
	bsr.w	loc_31BF2
	move.w	#$50,(Boss_Countdown).w
	bra.w	loc_31C08
; ===========================================================================

loc_31B06:
	cmpi.w	#$67C,(MainCharacter+y_pos).w
	blo.s	loc_31B46
	move.b	#$F,mainspr_mapframe(a0)
	move.b	#2,(Boss_CollisionRoutine).w
	move.b	#$20,(Boss_AnimationArray+3).w
	move.b	#$20,(Boss_AnimationArray+9).w
	move.b	#9,(Boss_AnimationArray).w
	addq.b	#4,boss_routine(a0)
	move.w	#0,(Boss_X_vel).w
	move.w	#$180,(Boss_Y_vel).w
	move.b	#0,objoff_3E(a0)
	bra.w	loc_31C08
; ===========================================================================

loc_31B46:
	bra.w	+
+	addi_.w	#1,(Boss_Countdown).w
	move.w	(Boss_Countdown).w,d0
	andi.w	#$3F,d0
	bne.w	loc_31C08
	btst	#6,(Boss_Countdown+1).w
	beq.s	loc_31B86
	move.b	#$F,mainspr_mapframe(a0)
	move.b	#2,(Boss_CollisionRoutine).w
	move.b	#$20,(Boss_AnimationArray+3).w
	move.b	#$20,(Boss_AnimationArray+9).w
	move.b	#9,(Boss_AnimationArray).w
	bra.w	loc_31C08
; ===========================================================================

loc_31B86:
	move.b	#$C,mainspr_mapframe(a0)
	move.b	#1,(Boss_CollisionRoutine).w
	move.b	#0,(Boss_AnimationArray+3).w
	move.b	#0,(Boss_AnimationArray+9).w
	move.b	#4,(Boss_AnimationArray).w
	bra.w	loc_31C08
; ===========================================================================

loc_31BA8:
	move.b	#0,(Boss_CollisionRoutine).w
	subi_.w	#1,(Boss_Countdown).w
	bne.s	loc_31BC6
	move.b	#$20,(Boss_AnimationArray+3).w
	move.b	#$20,(Boss_AnimationArray+9).w
	bra.w	loc_31C08
; ===========================================================================

loc_31BC6:
	cmpi.w	#-$14,(Boss_Countdown).w
	bgt.w	loc_31C08
	move.b	#0,(Boss_AnimationArray+3).w
	move.b	#0,(Boss_AnimationArray+9).w
	move.b	#0,boss_routine(a0)
	move.w	#-1,(Boss_Countdown).w
	move.b	#$40,objoff_3F(a0)
	bra.w	loc_31C08
; ===========================================================================

loc_31BF2:
	jsrto	AllocateObject, JmpTo16_AllocateObject
	bne.s	return_31C06
	move.b	#ObjID_CNZBoss,id(a1) ; load obj51
	move.b	#4,boss_subtype(a1)
	move.l	a0,objoff_34(a1)

return_31C06:
	rts
; ===========================================================================

loc_31C08:
	bsr.w	loc_31CDC
	bsr.w	loc_31E76
	bsr.w	loc_31C92
	lea	(Ani_obj51).l,a1
	bsr.w	AnimateBoss

    if removeJmpTos&&~~fixBugs
	; This has to be moved so that it doesn't point to 'DisplaySprite3'.
JmpTo39_DisplaySprite ; JmpTo
    endif

    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*3,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo39_DisplaySprite
    endif
; ===========================================================================

loc_31C22:
	bsr.w	Boss_MoveObject
	tst.b	objoff_3E(a0)
	bne.s	loc_31C60
	cmpi.w	#$680,y_pos(a0)
	blo.s	loc_31C08
	move.w	#0,(Boss_X_vel).w
	move.w	#-$180,(Boss_Y_vel).w
	move.b	#-1,objoff_3E(a0)
	move.b	#1,(Boss_CollisionRoutine).w
	move.b	#0,(Boss_AnimationArray+3).w
	move.b	#0,(Boss_AnimationArray+9).w
	move.b	#4,(Boss_AnimationArray).w
	bra.s	loc_31C08
; ===========================================================================

loc_31C60:
	cmpi.w	#$654,y_pos(a0)
	bhs.s	loc_31C08
	move.b	#0,boss_routine(a0)
	move.w	#0,(Boss_Y_vel).w
	move.w	#-$180,(Boss_X_vel).w
	btst	#0,render_flags(a0)
	beq.s	BranchTo_loc_31C08
	move.w	#$180,(Boss_X_vel).w
	move.b	#$C,mainspr_mapframe(a0)

BranchTo_loc_31C08 ; BranchTo
	bra.w	loc_31C08
; ===========================================================================

loc_31C92:
	cmpi.b	#48-1,boss_invulnerable_time(a0)
	bne.s	loc_31CAC
	lea	(Boss_AnimationArray).w,a1
	andi.b	#$F0,6(a1)
	ori.b	#6,6(a1)
	rts
; ===========================================================================

loc_31CAC:
	cmpi.b	#4,(MainCharacter+routine).w
	beq.s	loc_31CBC
	cmpi.b	#4,(Sidekick+routine).w
	bne.s	return_31CDA

loc_31CBC:
	lea	(Boss_AnimationArray).w,a1
	move.b	6(a1),d0
	andi.b	#$F,d0
	cmpi.b	#6,d0
	beq.s	return_31CDA
	andi.b	#$F0,6(a1)
	ori.b	#5,6(a1)

return_31CDA:
	rts
; ===========================================================================

loc_31CDC:
	move.b	boss_sine_count(a0),d0
	jsr	(CalcSine).l
	asr.w	#6,d0
	add.w	(Boss_Y_pos).w,d0
	move.w	d0,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	addq.b	#2,boss_sine_count(a0)
	cmpi.b	#6,boss_routine(a0)
	bhs.s	return_31D40
	tst.b	boss_hitcount2(a0)
	beq.s	loc_31D42
	tst.b	collision_flags(a0)
	bne.s	return_31D40
	tst.b	boss_invulnerable_time(a0)
	bne.s	loc_31D24
	move.b	#48,boss_invulnerable_time(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l

loc_31D24:
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	loc_31D32
	move.w	#$EEE,d0

loc_31D32:
	move.w	d0,(a1)
	subq.b	#1,boss_invulnerable_time(a0)
	bne.s	return_31D40
	move.b	#$F,collision_flags(a0)

return_31D40:
	rts
; ===========================================================================

loc_31D42:
	moveq	#100,d0
	jsrto	AddPoints, JmpTo7_AddPoints
	move.w	#$B3,(Boss_Countdown).w
	move.b	#6,boss_routine(a0)
	moveq	#PLCID_Capsule,d0
	jsrto	LoadPLC, JmpTo10_LoadPLC
	rts
; ===========================================================================

loc_31D5C:
	st.b	boss_defeated(a0)
	subq.w	#1,(Boss_Countdown).w
	bmi.s	loc_31D7E
	move.b	#0,(Boss_CollisionRoutine).w
	move.b	#0,mainspr_mapframe(a0)
	move.b	#$B,collision_property(a0)
	bsr.w	Boss_LoadExplosion
	bra.s	loc_31DB8
; ===========================================================================

loc_31D7E:
	bset	#0,render_flags(a0)
	clr.w	(Boss_X_vel).w
	clr.w	(Boss_Y_vel).w
	addq.b	#2,boss_routine(a0)
	lea	(Boss_AnimationArray).w,a1
	andi.b	#$F0,6(a1)
	ori.b	#3,6(a1)
	_move.b	#8,0(a1)
	move.b	#$DD,(Level_Layout+$C54).w
	move.b	#1,(Screen_redraw_flag).w
	move.w	#-$12,(Boss_Countdown).w

loc_31DB8:
	move.w	(Boss_Y_pos).w,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	bsr.w	loc_31E76
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*3,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo39_DisplaySprite
    endif
; ===========================================================================

loc_31DCC:
	addq.w	#1,(Boss_Countdown).w
	beq.s	loc_31DDC
	bpl.s	loc_31DE2
	addi.w	#$18,(Boss_Y_vel).w
	bra.s	loc_31E0E
; ===========================================================================

loc_31DDC:
	clr.w	(Boss_Y_vel).w
	bra.s	loc_31E0E
; ===========================================================================

loc_31DE2:
	cmpi.w	#$18,(Boss_Countdown).w
	blo.s	loc_31DFA
	beq.s	loc_31E02
	cmpi.w	#$20,(Boss_Countdown).w
	blo.s	loc_31E0E
	addq.b	#2,boss_routine(a0)
	bra.s	loc_31E0E
; ===========================================================================

loc_31DFA:
	subi_.w	#8,(Boss_Y_vel).w
	bra.s	loc_31E0E
; ===========================================================================

loc_31E02:
	clr.w	(Boss_Y_vel).w
	jsrto	PlayLevelMusic, JmpTo6_PlayLevelMusic
	jsrto	LoadPLC_AnimalExplosion, JmpTo6_LoadPLC_AnimalExplosion

loc_31E0E:
	bsr.w	Boss_MoveObject
	bsr.w	loc_31CDC
	move.w	(Boss_Y_pos).w,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	bsr.w	loc_31E76
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*3,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo39_DisplaySprite
    endif
; ===========================================================================

loc_31E2A:
	move.w	#$400,(Boss_X_vel).w
	move.w	#-$40,(Boss_Y_vel).w
	cmpi.w	#$2B20,(Camera_Max_X_pos).w
	beq.s	loc_31E44
	addq.w	#2,(Camera_Max_X_pos).w
	bra.s	loc_31E4A
; ===========================================================================

loc_31E44:
	tst.b	render_flags(a0)
	bpl.s	JmpTo58_DeleteObject

loc_31E4A:
	bsr.w	Boss_MoveObject
	bsr.w	loc_31CDC
	move.w	(Boss_Y_pos).w,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	bsr.w	loc_31E76
	lea	(Ani_obj51).l,a1
	bsr.w	AnimateBoss
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*3,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo39_DisplaySprite
    endif
; ===========================================================================

    if removeJmpTos
JmpTo59_DeleteObject ; JmpTo
    endif

JmpTo58_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
; ===========================================================================

loc_31E76:
	move.w	x_pos(a0),d0
	move.w	y_pos(a0),d1
	move.w	d0,sub3_x_pos(a0)
	move.w	d1,sub3_y_pos(a0)
	move.w	d0,sub4_x_pos(a0)
	move.w	d1,sub4_y_pos(a0)
	tst.b	boss_defeated(a0)
	bne.s	loc_31EAE
	move.w	d0,sub5_x_pos(a0)
	move.w	d1,sub5_y_pos(a0)
	move.w	d0,sub2_x_pos(a0)
	move.w	d1,sub2_y_pos(a0)
	move.w	d1,objoff_3A(a0)
	move.w	d1,objoff_34(a0)
	rts
; ===========================================================================

loc_31EAE:
	cmpi.w	#$78,(Boss_Countdown).w
	bgt.s	return_31F22
	subi_.w	#1,sub5_x_pos(a0)
	move.l	objoff_3A(a0),d0
	move.w	objoff_2E(a0),d1
	addi.w	#$38,objoff_2E(a0)
	ext.l	d1
	asl.l	#8,d1
	add.l	d1,d0
	move.l	d0,objoff_3A(a0)
	move.w	objoff_3A(a0),sub5_y_pos(a0)
	cmpi.w	#$6F0,sub5_y_pos(a0)
	blt.s	loc_31EE8
	move.w	#0,objoff_2E(a0)

loc_31EE8:
	cmpi.w	#60,(Boss_Countdown).w
	bgt.s	return_31F22
	addi_.w	#1,sub2_x_pos(a0)
	move.l	objoff_34(a0),d0
	move.w	objoff_30(a0),d1
	addi.w	#$38,objoff_30(a0)
	ext.l	d1
	asl.l	#8,d1
	add.l	d1,d0
	move.l	d0,objoff_34(a0)
	move.w	objoff_34(a0),sub2_y_pos(a0)
	cmpi.w	#$6F0,sub2_y_pos(a0)
	blt.s	return_31F22
	move.w	#0,objoff_30(a0)

return_31F22:
	rts
; ===========================================================================

loc_31F24:
	movea.l	objoff_34(a0),a1 ; a1=object
	cmpi.b	#6,boss_routine(a1)
	bhs.w	JmpTo59_DeleteObject
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_31F40(pc,d0.w),d1
	jmp	off_31F40(pc,d1.w)
; ===========================================================================
off_31F40:	offsetTable
		offsetTableEntry.w loc_31F48	; 0
		offsetTableEntry.w loc_31F96	; 2
		offsetTableEntry.w loc_31FDC	; 4
		offsetTableEntry.w loc_32080	; 6
; ===========================================================================

loc_31F48:
	move.l	#Obj51_MapUnc_320EA,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZBoss_Fudge,0,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#7,priority(a0)
	addq.b	#2,routine_secondary(a0)
	movea.l	objoff_34(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	addi.w	#$30,y_pos(a0)
	move.b	#8,y_radius(a0)
	move.b	#8,x_radius(a0)
	move.b	#$12,boss_sine_count(a0)
	move.b	#$98,collision_flags(a0)
	rts
; ===========================================================================

loc_31F96:
	movea.l	objoff_34(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.w	objoff_28(a0),d0
	add.w	d0,y_pos(a0)
	addi_.w	#1,d0
	cmpi.w	#$2E,d0
	blt.s	+
	move.w	#$2E,d0
+
	move.w	d0,objoff_28(a0)
	tst.w	(Boss_Countdown).w
	bne.w	JmpTo39_DisplaySprite
	addq.b	#2,routine_secondary(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)

    if removeJmpTos&&fixBugs
	; This has to be moved so that it doesn't point to 'DisplaySprite3'.
JmpTo39_DisplaySprite ; JmpTo
    endif

	jmpto	DisplaySprite, JmpTo39_DisplaySprite
; ===========================================================================

loc_31FDC:
	bsr.w	loc_31FF8
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.w	JmpTo39_DisplaySprite
	add.w	d1,y_pos(a0)
	bsr.w	loc_32030
	jmpto	DisplaySprite, JmpTo39_DisplaySprite
; ===========================================================================

loc_31FF8:
	moveq	#0,d2
	move.w	x_pos(a0),d2
	swap	d2
	moveq	#0,d3
	move.w	y_pos(a0),d3
	swap	d3
	move.w	x_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d2
	move.w	y_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	addi.w	#$38,y_vel(a0)
	swap	d2
	move.w	d2,x_pos(a0)
	swap	d3
	move.w	d3,y_pos(a0)
	rts
; ===========================================================================

loc_32030:
	move.b	#SndID_BossExplosion,d0
	jsrto	PlaySound, JmpTo9_PlaySound
	move.w	#make_art_tile(ArtTile_ArtNem_CNZBoss_Fudge,0,0),art_tile(a0)
	move.b	#7,anim(a0)
	move.w	#-$300,y_vel(a0)
	move.w	#-$100,x_vel(a0)
	move.b	#4,boss_subtype(a0)
	move.b	#6,routine_secondary(a0)
	move.b	#$98,collision_flags(a0)
	jsrto	AllocateObjectAfterCurrent, JmpTo23_AllocateObjectAfterCurrent
	bne.s	return_3207E
	moveq	#0,d0

	move.w	#bytesToLcnt(object_size),d1

loc_3206E:
	move.l	(a0,d0.w),(a1,d0.w)
	addq.w	#4,d0
	dbf	d1,loc_3206E
    if object_size&3
	move.w	(a0,d0.w),(a1,d0.w)
    endif

	neg.w	x_vel(a1)

return_3207E:
	rts
; ===========================================================================

loc_32080:
	bsr.w	loc_31FF8
	lea	(Ani_obj51).l,a1
	jsrto	AnimateSprite, JmpTo20_AnimateSprite
	cmpi.w	#$705,y_pos(a0)
	blo.w	JmpTo39_DisplaySprite
	jmpto	JmpTo59_DeleteObject, JmpTo59_DeleteObject
; ===========================================================================
; animation script
; off_3209C:
Ani_obj51:	offsetTable
		offsetTableEntry.w byte_320B0	; 0
		offsetTableEntry.w byte_320B3	; 1
		offsetTableEntry.w byte_320B9	; 2
		offsetTableEntry.w byte_320BF	; 3
		offsetTableEntry.w byte_320C3	; 4
		offsetTableEntry.w byte_320C8	; 5
		offsetTableEntry.w byte_320D3	; 6
		offsetTableEntry.w byte_320DD	; 7
		offsetTableEntry.w byte_320E1	; 8
		offsetTableEntry.w byte_320E4	; 9
byte_320B0:	dc.b  $F,  1,$FF
	rev02even
byte_320B3:	dc.b  $F,  4,$FF,  5,$FC,  2
	rev02even
byte_320B9:	dc.b  $F,  2,$FF,  3,$FC,  2
	rev02even
byte_320BF:	dc.b   7,  6,  7,$FF
	rev02even
byte_320C3:	dc.b   1, $C, $D, $E,$FF
	rev02even
byte_320C8:	dc.b   7,  8,  9,  8,  9,  8,  9,  8,  9,$FD,  3
	rev02even
byte_320D3:	dc.b   7, $A, $A, $A, $A, $A, $A, $A,$FD,  3
	rev02even
byte_320DD:	dc.b   3,$13,$14,$FF
	rev02even
byte_320E1:	dc.b   1,  0,$FF
	rev02even
byte_320E4:	dc.b   1, $F,$10,$11,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj51_MapUnc_320EA:	include "mappings/sprite/obj51.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo39_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo59_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo16_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
JmpTo9_PlaySound ; JmpTo
	jmp	(PlaySound).l
JmpTo23_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo20_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo10_LoadPLC ; JmpTo
	jmp	(LoadPLC).l
JmpTo7_AddPoints ; JmpTo
	jmp	(AddPoints).l
JmpTo6_PlayLevelMusic ; JmpTo
	jmp	(PlayLevelMusic).l
JmpTo6_LoadPLC_AnimalExplosion ; JmpTo
	jmp	(LoadPLC_AnimalExplosion).l

	align 4
    endif
