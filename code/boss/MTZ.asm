; ===========================================================================
; ----------------------------------------------------------------------------
; Object 54 - MTZ boss
; ----------------------------------------------------------------------------
; Sprite_32288:
Obj54:
	moveq	#0,d0
	move.b	boss_subtype(a0),d0
	move.w	Obj54_Index(pc,d0.w),d1
	jmp	Obj54_Index(pc,d1.w)
; ===========================================================================
; off_32296:
Obj54_Index:	offsetTable
		offsetTableEntry.w Obj54_Init			; 0
		offsetTableEntry.w Obj54_Main		 	; 2
		offsetTableEntry.w Obj54_Laser			; 4
		offsetTableEntry.w Obj54_LaserShooter	; 6
; ===========================================================================
; loc_3229E:
Obj54_Init:
	move.l	#Obj54_MapUnc_32DC6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MTZBoss,0,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
    if ~~fixBugs
	; Multi-sprite objects cannot use the 'priority' SST as it is
	; overwritten by 'sub3_y_pos'.
	move.b	#3,priority(a0)
    endif
	move.w	#$2B50,x_pos(a0)
	move.w	#$380,y_pos(a0)
	move.b	#2,mainspr_mapframe(a0)
	addq.b	#2,boss_subtype(a0)		; => Obj54_Main
	bset	#6,render_flags(a0)
	move.b	#2,mainspr_childsprites(a0)
	move.b	#$F,collision_flags(a0)
	move.b	#8,boss_hitcount2(a0)
	move.b	#7,objoff_3E(a0)
	move.w	x_pos(a0),(Boss_X_pos).w
	move.w	y_pos(a0),(Boss_Y_pos).w
	move.w	#0,(Boss_X_vel).w
	move.w	#$100,(Boss_Y_vel).w
	move.b	#$20,mainspr_width(a0)
	clr.b	objoff_2B(a0)
	clr.b	objoff_2C(a0)
	move.b	#$40,boss_sine_count(a0)
	move.b	#$27,objoff_33(a0)
	move.b	#$27,objoff_39(a0)
	move.w	x_pos(a0),sub2_x_pos(a0)
	move.w	y_pos(a0),sub2_y_pos(a0)
	move.b	#$C,sub2_mapframe(a0)
	move.w	x_pos(a0),sub3_x_pos(a0)
	move.w	y_pos(a0),sub3_y_pos(a0)
	move.b	#0,sub3_mapframe(a0)
	jsrto	AllocateObject, JmpTo17_AllocateObject
	bne.s	+
	move.b	#ObjID_MTZBoss,id(a1) ; load obj54
	move.b	#6,boss_subtype(a1)		; => Obj54_LaserShooter
	move.b	#$13,mapping_frame(a1)
	move.l	#Obj54_MapUnc_32DC6,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_MTZBoss,0,0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#6,priority(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.l	a0,objoff_34(a1)
	move.b	#$20,width_pixels(a1)
	jsrto	AllocateObject, JmpTo17_AllocateObject
	bne.s	+
	move.b	#ObjID_MTZBossOrb,id(a1) ; load obj53
	move.l	a0,objoff_34(a1)
+
	lea	(Boss_AnimationArray).w,a2
	move.b	#$10,(a2)+
	move.b	#0,(a2)+
	move.b	#3,(a2)+
	move.b	#0,(a2)+
	move.b	#1,(a2)+
	move.b	#0,(a2)+
	rts
; ===========================================================================
;loc_323BA
Obj54_Main:
	moveq	#0,d0
	move.b	boss_routine(a0),d0
	move.w	Obj54_MainSubStates(pc,d0.w),d1
	jmp	Obj54_MainSubStates(pc,d1.w)
; ===========================================================================
Obj54_MainSubStates:	offsetTable
		offsetTableEntry.w Obj54_MainSub0	;   0
		offsetTableEntry.w Obj54_MainSub2	;   2
		offsetTableEntry.w Obj54_MainSub4	;   4
		offsetTableEntry.w Obj54_MainSub6	;   6
		offsetTableEntry.w Obj54_MainSub8	;   8
		offsetTableEntry.w Obj54_MainSubA	;  $A
		offsetTableEntry.w Obj54_MainSubC	;  $C
		offsetTableEntry.w Obj54_MainSubE	;  $E
		offsetTableEntry.w Obj54_MainSub10	; $10
		offsetTableEntry.w Obj54_MainSub12	; $12
; ===========================================================================
;loc_323DC
Obj54_MainSub0:
	bsr.w	Boss_MoveObject
	move.w	(Boss_Y_pos).w,y_pos(a0)
	cmpi.w	#$4A0,(Boss_Y_pos).w
	blo.s	+
	addq.b	#2,boss_routine(a0)		; => Obj54_MainSub2
	move.w	#0,(Boss_Y_vel).w
	move.w	#-$100,(Boss_X_vel).w
	bclr	#7,objoff_2B(a0)
	bclr	#0,render_flags(a0)
	move.w	(MainCharacter+x_pos).w,d0
	cmp.w	(Boss_X_pos).w,d0
	blo.s	+
	move.w	#$100,(Boss_X_vel).w
	bset	#7,objoff_2B(a0)
	bset	#0,render_flags(a0)
+
	bsr.w	Obj54_AnimateFace
	lea	(Ani_obj53).l,a1
	bsr.w	AnimateBoss
	bsr.w	Obj54_AlignSprites
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*3,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo40_DisplaySprite
    endif
; ===========================================================================
;loc_3243C
Obj54_Float:
	move.b	boss_sine_count(a0),d0
	jsr	(CalcSine).l
	asr.w	#6,d0
	add.w	(Boss_Y_pos).w,d0
	move.w	d0,y_pos(a0)
	addq.b	#4,boss_sine_count(a0)
	rts
; ===========================================================================
;loc_32456
Obj54_MainSub2:
	bsr.w	Boss_MoveObject
	btst	#7,objoff_2B(a0)
	bne.s	+
	cmpi.w	#$2AD0,(Boss_X_pos).w
	bhs.s	Obj54_MoveAndShow
	bchg	#7,objoff_2B(a0)
	move.w	#$100,(Boss_X_vel).w
	bset	#0,render_flags(a0)
	bset	#6,objoff_2B(a0)
	beq.s	Obj54_MoveAndShow
	addq.b	#2,boss_routine(a0)		; => Obj54_MainSub4
	move.w	#-$100,(Boss_Y_vel).w
	bra.s	Obj54_MoveAndShow
; ===========================================================================
+
	cmpi.w	#$2BD0,(Boss_X_pos).w
	blo.s	Obj54_MoveAndShow
	bchg	#7,objoff_2B(a0)
	move.w	#-$100,(Boss_X_vel).w
	bclr	#0,render_flags(a0)
	bset	#6,objoff_2B(a0)
	beq.s	Obj54_MoveAndShow
	addq.b	#2,boss_routine(a0)		; => Obj54_MainSub4
	move.w	#-$100,(Boss_Y_vel).w
;loc_324BC
Obj54_MoveAndShow:
	move.w	(Boss_X_pos).w,x_pos(a0)
	bsr.w	Obj54_Float
;loc_324C6
Obj54_Display:
	bsr.w	Obj54_AnimateFace
	lea	(Ani_obj53).l,a1
	bsr.w	AnimateBoss
	bsr.w	Obj54_AlignSprites
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*3,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo40_DisplaySprite
    endif
; ===========================================================================
;loc_324DC
Obj54_MainSub4:
	bsr.w	Boss_MoveObject
	cmpi.w	#$470,(Boss_Y_pos).w
	bhs.s	+
	move.w	#0,(Boss_Y_vel).w
+
	btst	#7,objoff_2B(a0)
	bne.s	+
	cmpi.w	#$2B50,(Boss_X_pos).w
	bhs.s	++
	move.w	#0,(Boss_X_vel).w
	bra.s	++
; ===========================================================================
+
	cmpi.w	#$2B50,(Boss_X_pos).w
	blo.s	+
	move.w	#0,(Boss_X_vel).w
+
	move.w	(Boss_X_vel).w,d0
	or.w	(Boss_Y_vel).w,d0
	bne.s	BranchTo_Obj54_MoveAndShow
	addq.b	#2,boss_routine(a0)		; => Obj54_MainSub6

BranchTo_Obj54_MoveAndShow ; BranchTo
	bra.s	Obj54_MoveAndShow
; ===========================================================================
;loc_32524
Obj54_MainSub6:
	cmpi.b	#$68,objoff_33(a0)
	bhs.s	+
	addq.b	#1,objoff_33(a0)
	addq.b	#1,objoff_39(a0)
	bra.s	BranchTo2_Obj54_MoveAndShow
; ===========================================================================
+
	subq.b	#1,objoff_39(a0)
	bne.s	BranchTo2_Obj54_MoveAndShow
	addq.b	#2,boss_routine(a0)		; => Obj54_MainSub8

BranchTo2_Obj54_MoveAndShow
	bra.w	Obj54_MoveAndShow
; ===========================================================================
;loc_32544
Obj54_MainSub8:
	cmpi.b	#$27,objoff_33(a0)
	blo.s	+
	subq.b	#1,objoff_33(a0)
	bra.s	BranchTo3_Obj54_MoveAndShow
; ===========================================================================
+
	addq.b	#1,objoff_39(a0)
	cmpi.b	#$27,objoff_39(a0)
	blo.s	BranchTo3_Obj54_MoveAndShow
	move.w	#$100,(Boss_Y_vel).w
	move.b	#0,boss_routine(a0)		; => Obj54_MainSub0
	bclr	#6,objoff_2B(a0)

BranchTo3_Obj54_MoveAndShow
	bra.w	Obj54_MoveAndShow
; ===========================================================================
;loc_32574
Obj54_MainSubA:
	tst.b	objoff_39(a0)
	beq.s	+
	subq.b	#1,objoff_39(a0)
	bra.s	++
; ===========================================================================
+
	move.b	#-1,objoff_3A(a0)
+
	cmpi.b	#$27,objoff_33(a0)
	blo.s	+
	subq.b	#1,objoff_33(a0)
+
	bsr.w	Boss_MoveObject
	cmpi.w	#$420,(Boss_Y_pos).w
	bhs.s	+
	move.w	#0,(Boss_Y_vel).w
+
	tst.b	objoff_2C(a0)
	bne.s	BranchTo4_Obj54_MoveAndShow
	tst.b	objoff_3A(a0)
	beq.s	+
	move.b	#$80,objoff_3A(a0)
+
	addq.b	#2,boss_routine(a0)		; => Obj54_MainSubC

BranchTo4_Obj54_MoveAndShow
	bra.w	Obj54_MoveAndShow
; ===========================================================================
;loc_325BE
Obj54_MainSubC:
	tst.b	objoff_3E(a0)
	beq.s	++
	tst.b	objoff_3A(a0)
	bne.s	BranchTo5_Obj54_MoveAndShow
	cmpi.b	#$27,objoff_39(a0)
	bhs.s	+
	addq.b	#1,objoff_39(a0)
	bra.s	BranchTo5_Obj54_MoveAndShow
; ===========================================================================
+
	move.w	#$100,(Boss_Y_vel).w
	move.b	#0,boss_routine(a0)		; => Obj54_MainSub0
	bclr	#6,objoff_2B(a0)
	bra.s	BranchTo5_Obj54_MoveAndShow
; ===========================================================================
+
	move.w	#-$180,(Boss_Y_vel).w
	move.w	#-$100,(Boss_X_vel).w
	bclr	#0,render_flags(a0)
	btst	#7,objoff_2B(a0)
	beq.s	+
	move.w	#$100,(Boss_X_vel).w
	bset	#0,render_flags(a0)
+
	move.b	#$E,boss_routine(a0)		; => Obj54_MainSubE
	move.b	#0,objoff_2E(a0)
	bclr	#6,objoff_2B(a0)
	move.b	#0,objoff_2F(a0)

BranchTo5_Obj54_MoveAndShow
	bra.w	Obj54_MoveAndShow
; ===========================================================================
;loc_3262E
Obj54_MainSubE:
	tst.b	objoff_2F(a0)
	beq.s	+
	subq.b	#1,objoff_2F(a0)
	bra.w	Obj54_Display
; ===========================================================================
+
	moveq	#0,d0
	move.b	objoff_2E(a0),d0
	move.w	off_3264A(pc,d0.w),d1
	jmp	off_3264A(pc,d1.w)
; ===========================================================================
off_3264A:	offsetTable
		offsetTableEntry.w loc_32650	; 0
		offsetTableEntry.w loc_326B8	; 2
		offsetTableEntry.w loc_32704	; 4
; ===========================================================================

loc_32650:
	bsr.w	Boss_MoveObject
	cmpi.w	#$420,(Boss_Y_pos).w
	bhs.s	+
	move.w	#0,(Boss_Y_vel).w
+
	btst	#7,objoff_2B(a0)
	bne.s	+
	cmpi.w	#$2AF0,(Boss_X_pos).w
	bhs.s	BranchTo6_Obj54_MoveAndShow
	addq.b	#2,objoff_2E(a0)
	move.w	#$180,(Boss_Y_vel).w
	move.b	#3,objoff_2D(a0)
	move.w	#$1E,(Boss_Countdown).w
	bset	#0,render_flags(a0)
	bra.s	BranchTo6_Obj54_MoveAndShow
; ===========================================================================
+
	cmpi.w	#$2BB0,(Boss_X_pos).w
	blo.s	BranchTo6_Obj54_MoveAndShow
	addq.b	#2,objoff_2E(a0)
	move.w	#$180,(Boss_Y_vel).w
	move.b	#3,objoff_2D(a0)
	move.w	#$1E,(Boss_Countdown).w
	bclr	#0,render_flags(a0)

BranchTo6_Obj54_MoveAndShow
	bra.w	Obj54_MoveAndShow
; ===========================================================================

loc_326B8:
	bsr.w	Boss_MoveObject
	cmpi.w	#$4A0,(Boss_Y_pos).w
	blo.s	+
	move.w	#-$180,(Boss_Y_vel).w
	addq.b	#2,objoff_2E(a0)
	bchg	#7,objoff_2B(a0)
	bra.s	+++
; ===========================================================================
+
	btst	#7,objoff_2B(a0)
	bne.s	+
	cmpi.w	#$2AD0,(Boss_X_pos).w
	bhs.s	++
	move.w	#0,(Boss_X_vel).w
	bra.s	++
; ===========================================================================
+
	cmpi.w	#$2BD0,(Boss_X_pos).w
	blo.s	+
	move.w	#0,(Boss_X_vel).w
+
	bsr.w	Obj54_FireLaser
	bra.w	Obj54_MoveAndShow
; ===========================================================================

loc_32704:
	bsr.w	Boss_MoveObject
	cmpi.w	#$470,(Boss_Y_pos).w
	bhs.s	+
	move.w	#$100,(Boss_X_vel).w
	btst	#7,objoff_2B(a0)
	bne.s	+
	move.w	#-$100,(Boss_X_vel).w
+
	cmpi.w	#$420,(Boss_Y_pos).w
	bhs.s	+
	move.w	#0,(Boss_Y_vel).w
	move.b	#0,objoff_2E(a0)
+
	bsr.w	Obj54_FireLaser
	bra.w	Obj54_MoveAndShow
; ===========================================================================
;loc_32740
Obj54_FireLaser:
	subi_.w	#1,(Boss_Countdown).w
	bne.s	+		; rts
	tst.b	objoff_2D(a0)
	beq.s	+		; rts
	subq.b	#1,objoff_2D(a0)
	jsrto	AllocateObject, JmpTo17_AllocateObject
	bne.s	+		; rts
	move.b	#ObjID_MTZBoss,id(a1) ; load obj54
	move.b	#4,boss_subtype(a1)		; => Obj54_Laser
	move.l	a0,objoff_34(a1)
	move.w	#$1E,(Boss_Countdown).w
	move.b	#$10,objoff_2F(a0)
+
	rts
; ===========================================================================
;loc_32774
Obj54_AlignSprites:
	move.w	x_pos(a0),d0
	move.w	y_pos(a0),d1
	move.w	d0,sub2_x_pos(a0)
	move.w	d1,sub2_y_pos(a0)
	move.w	d0,sub3_x_pos(a0)
	move.w	d1,sub3_y_pos(a0)
	rts
; ===========================================================================
;loc_3278E
Obj54_AnimateFace:
	bsr.w	Obj54_CheckHit
	cmpi.b	#$3F,boss_invulnerable_time(a0)
	bne.s	++
	st.b	objoff_38(a0)
	lea	(Boss_AnimationArray).w,a1
	andi.b	#$F0,2(a1)
	ori.b	#5,2(a1)
	tst.b	objoff_3E(a0)
	beq.s	+
	move.b	#$A,boss_routine(a0)		; => Obj54_MainSubA
	move.w	#-$180,(Boss_Y_vel).w
	subq.b	#1,objoff_3E(a0)
	move.w	#0,(Boss_X_vel).w
+
	move.w	#0,(Boss_X_vel).w
	rts
; ===========================================================================
+
	cmpi.b	#4,(MainCharacter+routine).w
	beq.s	+
	cmpi.b	#4,(Sidekick+routine).w
	bne.s	++		; rts
+
	lea	(Boss_AnimationArray).w,a1
	move.b	2(a1),d0
	andi.b	#$F,d0
	cmpi.b	#4,d0
	beq.s	+		; rts
	andi.b	#$F0,2(a1)
	ori.b	#4,2(a1)
+
	rts
; ===========================================================================
;loc_32802
Obj54_MainSub10:
	subq.w	#1,(Boss_Countdown).w
	cmpi.w	#60,(Boss_Countdown).w
	blo.s	++
	bmi.s	+
	bsr.w	Boss_LoadExplosion
	lea	(Boss_AnimationArray).w,a1
	move.b	#7,2(a1)
	bra.s	++
; ===========================================================================
+
	bset	#0,render_flags(a0)
	clr.w	(Boss_X_vel).w
	clr.w	(Boss_Y_vel).w
	addq.b	#2,boss_routine(a0)		; => Obj54_MainSub12
	move.w	#-$12,(Boss_Countdown).w
	lea	(Boss_AnimationArray).w,a1
	move.b	#3,2(a1)
	jsrto	PlayLevelMusic, JmpTo7_PlayLevelMusic
+
	move.w	(Boss_Y_pos).w,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	lea	(Ani_obj53).l,a1
	bsr.w	AnimateBoss
	bsr.w	Obj54_AlignSprites
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*3,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo40_DisplaySprite
    endif
; ===========================================================================
;loc_32864
Obj54_MainSub12:
	move.w	#$400,(Boss_X_vel).w
	move.w	#-$40,(Boss_Y_vel).w
	cmpi.w	#$2BF0,(Camera_Max_X_pos).w
	bhs.s	+
	addq.w	#2,(Camera_Max_X_pos).w
	bra.s	++
; ===========================================================================
+
	tst.b	render_flags(a0)
	bpl.s	JmpTo60_DeleteObject
+
	tst.b	(Boss_defeated_flag).w
	bne.s	+
	move.b	#1,(Boss_defeated_flag).w
	jsrto	LoadPLC_AnimalExplosion, JmpTo7_LoadPLC_AnimalExplosion
+
	bsr.w	Boss_MoveObject
	bsr.w	loc_328C0
	move.w	(Boss_Y_pos).w,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	lea	(Ani_obj53).l,a1
	bsr.w	AnimateBoss
	bsr.w	Obj54_AlignSprites
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*3,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo40_DisplaySprite
    endif
; ===========================================================================

JmpTo60_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
; ===========================================================================

loc_328C0:
	move.b	boss_sine_count(a0),d0
	jsr	(CalcSine).l
	asr.w	#6,d0
	add.w	(Boss_Y_pos).w,d0
	move.w	d0,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	addq.b	#2,boss_sine_count(a0)
;loc_328DE
Obj54_CheckHit:
	cmpi.b	#$10,boss_routine(a0)
	bhs.s	return_32924
	tst.b	boss_hitcount2(a0)
	beq.s	Obj54_Defeated
	tst.b	collision_flags(a0)
	bne.s	return_32924
	tst.b	boss_invulnerable_time(a0)
	bne.s	+
	move.b	#$40,boss_invulnerable_time(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l
+
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	+
	move.w	#$EEE,d0
+
	move.w	d0,(a1)
	subq.b	#1,boss_invulnerable_time(a0)
	bne.s	return_32924
	move.b	#$F,collision_flags(a0)

return_32924:
	rts
; ===========================================================================
;loc_32926
Obj54_Defeated:
	moveq	#100,d0
	jsrto	AddPoints, JmpTo8_AddPoints
	move.w	#$EF,(Boss_Countdown).w
	move.b	#$10,boss_routine(a0)		; => Obj54_MainSub10
	moveq	#PLCID_Capsule,d0
	jsrto	LoadPLC, JmpTo11_LoadPLC
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 53 - Shield orbs that surround MTZ boss
; ----------------------------------------------------------------------------
; Sprite_32940:
Obj53:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj53_Index(pc,d0.w),d1
	jmp	Obj53_Index(pc,d1.w)
; ===========================================================================
; off_3294E:
Obj53_Index:	offsetTable
		offsetTableEntry.w Obj53_Init	; 0
		offsetTableEntry.w Obj53_Main	; 2
		offsetTableEntry.w Obj53_BreakAway	; 4
		offsetTableEntry.w Obj53_BounceAround	; 6
		offsetTableEntry.w Obj53_Burst	; 8
; ===========================================================================
; loc_32958:
Obj53_Init:
	movea.l	a0,a1
	moveq	#6,d3
	moveq	#0,d2
	bra.s	+
; ===========================================================================
-	jsrto	AllocateObject, JmpTo17_AllocateObject
	bne.s	++
+
	move.b	#$20,width_pixels(a1)
	move.l	objoff_34(a0),objoff_34(a1)
	move.b	#ObjID_MTZBossOrb,id(a1) ; load obj53
	move.l	#Obj54_MapUnc_32DC6,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_MTZBoss,0,0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#3,priority(a1)
	addq.b	#2,routine(a1)		; => Obj53_Main
	move.b	#5,mapping_frame(a1)
	move.b	byte_329CC(pc,d2.w),objoff_28(a1)
	move.b	byte_329CC(pc,d2.w),objoff_3B(a1)
	move.b	byte_329D3(pc,d2.w),objoff_3A(a1)
	move.b	#$40,objoff_29(a1)
	move.b	#$87,collision_flags(a1)
	move.b	#2,collision_property(a1)
	move.b	#0,objoff_3C(a1)
	addq.w	#1,d2
	dbf	d3,-
+
	rts
; ===========================================================================
byte_329CC:
	dc.b $24
	dc.b $6C	; 1
	dc.b $B4	; 2
	dc.b $FC	; 3
	dc.b $48	; 4
	dc.b $90	; 5
	dc.b $D8	; 6
	rev02even
byte_329D3:
	dc.b   0
	dc.b   1	; 1
	dc.b   1	; 2
	dc.b   0	; 3
	dc.b   1	; 4
	dc.b   1	; 5
	dc.b   0	; 6
	even
; ===========================================================================
;loc_329DA
Obj53_Main:
	movea.l	objoff_34(a0),a1 ; a1=object
	move.w	y_pos(a1),objoff_2A(a0)
	subi_.w	#4,objoff_2A(a0)
	move.w	x_pos(a1),objoff_38(a0)
	tst.b	objoff_38(a1)
	beq.s	Obj53_ClearBossCollision
	move.b	#0,objoff_38(a1)
	addi_.b	#1,objoff_2C(a1)
	addq.b	#2,routine(a0)		; => Obj53_BreakAway
	move.b	#60,objoff_32(a0)
	move.b	#2,anim(a0)
	move.w	#-$400,y_vel(a0)
	move.w	#-$80,d1
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	x_pos(a0),d0
	bpl.s	+
	neg.w	d1
+
	cmpi.w	#$2AF0,x_pos(a0)
	bhs.s	+
	move.w	#$80,d1
+
	cmpi.w	#$2BB0,x_pos(a0)
	blo.s	+
	move.w	#-$80,d1
+
	bclr	#0,render_flags(a0)
	tst.w	d1
	bmi.s	+
	bset	#0,render_flags(a0)
+
	move.w	d1,x_vel(a0)
	bra.s	+
; ===========================================================================
;loc_32A56
Obj53_ClearBossCollision:
	cmpi.b	#2,collision_property(a0)
	beq.s	+
	move.b	#0,collision_flags(a1)
+
	bsr.w	Obj53_OrbitBoss
	bsr.w	Obj53_SetAnimPriority
	jmpto	DisplaySprite, JmpTo40_DisplaySprite
; ===========================================================================
;loc_32A70
Obj53_OrbitBoss:
	move.b	objoff_29(a0),d0
	jsr	(CalcSine).l
	move.w	d0,d3
	moveq	#0,d1
	move.b	objoff_33(a1),d1
	muls.w	d1,d0
	move.w	d0,d5
	move.w	d0,d4
	move.b	objoff_39(a1),d2
	tst.b	objoff_3A(a1)
	beq.s	+
	move.w	#$10,d2
+
	muls.w	d3,d2
	move.w	objoff_38(a0),d6
	move.b	objoff_28(a0),d0
	jsr	(CalcSine).l
	muls.w	d0,d5
	swap	d5
	add.w	d6,d5
	move.w	d5,x_pos(a0)
	muls.w	d1,d4
	swap	d4
	move.w	d4,objoff_30(a0)
	move.w	objoff_2A(a0),d6
	move.b	objoff_3B(a0),d0
	tst.b	objoff_3A(a1)
	beq.s	+
	move.b	objoff_3C(a0),d0
+
	jsr	(CalcSine).l
	muls.w	d0,d2
	swap	d2
	add.w	d6,d2
	move.w	d2,y_pos(a0)
	addq.b	#4,objoff_28(a0)
	tst.b	objoff_3A(a1)
	bne.s	+
	addq.b	#8,objoff_3B(a0)
	rts
; ===========================================================================
+
	cmpi.b	#-1,objoff_3A(a1)
	beq.s	++
	cmpi.b	#$80,objoff_3A(a1)
	bne.s	+
	subq.b	#2,objoff_3C(a0)
	bpl.s	return_32B18
	clr.b	objoff_3C(a0)
+
	move.b	#0,objoff_3A(a1)
	rts
; ===========================================================================
+
	cmpi.b	#$40,objoff_3C(a0)
	bhs.s	return_32B18
	addq.b	#2,objoff_3C(a0)

return_32B18:
	rts
; ===========================================================================
;loc_32B1A
Obj53_SetAnimPriority:
	move.w	objoff_30(a0),d0
	bmi.s	++
	cmpi.w	#$C,d0
	blt.s	+
	move.b	#3,mapping_frame(a0)
	move.b	#1,priority(a0)
	rts
; ===========================================================================
+
	move.b	#4,mapping_frame(a0)
	move.b	#2,priority(a0)
	rts
; ===========================================================================
+
	cmpi.w	#-$C,d0
	blt.s	+
	move.b	#4,mapping_frame(a0)
	move.b	#6,priority(a0)
	rts
; ===========================================================================
+
	move.b	#5,mapping_frame(a0)
	move.b	#7,priority(a0)
	rts
; ===========================================================================
;loc_32B64
Obj53_BreakAway:
	tst.b	objoff_32(a0)
	bmi.s	+
	subq.b	#1,objoff_32(a0)
	bpl.s	+
	move.b	#$DA,collision_flags(a0)
+
	jsrto	ObjectMoveAndFall, JmpTo6_ObjectMoveAndFall
	subi.w	#$20,y_vel(a0)
	cmpi.w	#$180,y_vel(a0)
	blt.s	+
	move.w	#$180,y_vel(a0)
+
	cmpi.w	#$4AC,y_pos(a0)
	blo.s	Obj53_Animate
	move.w	#$4AC,y_pos(a0)
	move.w	#$4AC,objoff_2E(a0)
	move.b	#1,objoff_2C(a0)
	addq.b	#2,routine(a0)
	bsr.w	Obj53_FaceLeader
;loc_32BB0
Obj53_Animate:
	bsr.w	+
	lea	(Ani_obj53).l,a1
	jsrto	AnimateSprite, JmpTo21_AnimateSprite
	jmpto	DisplaySprite, JmpTo40_DisplaySprite
; ===========================================================================
+
	cmpi.b	#-2,collision_property(a0)
	bgt.s	+		; rts
	move.b	#$14,mapping_frame(a0)
	move.b	#6,anim(a0)
	addq.b	#2,routine(a0)
+
	rts
; ===========================================================================
;loc_32BDC
Obj53_BounceAround:
	tst.b	objoff_32(a0)
	bmi.s	+
	subq.b	#1,objoff_32(a0)
	bpl.s	+
	move.b	#$DA,collision_flags(a0)
+
	bsr.w	Obj53_CheckPlayerHit
	cmpi.b	#$B,mapping_frame(a0)
	bne.s	Obj53_Animate
	move.b	objoff_2C(a0),d0
	jsr	(CalcSine).l
	neg.w	d0
	asr.w	#2,d0
	add.w	objoff_2E(a0),d0
	cmpi.w	#$4AC,d0
	bhs.s	++
	move.w	d0,y_pos(a0)
	addq.b	#1,objoff_2C(a0)
	btst	#0,objoff_2C(a0)
	beq.w	JmpTo40_DisplaySprite
	moveq	#-1,d0
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d0
+
	add.w	d0,x_pos(a0)
	jmpto	DisplaySprite, JmpTo40_DisplaySprite
; ===========================================================================
+
	move.w	#$4AC,y_pos(a0)
	bsr.w	Obj53_FaceLeader
	move.b	#1,objoff_2C(a0)
	jmpto	DisplaySprite, JmpTo40_DisplaySprite
; ===========================================================================
;loc_32C4C
Obj53_FaceLeader:
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	x_pos(a0),d0
	bpl.s	+
	bclr	#0,render_flags(a0)
	rts
; ===========================================================================
+
	bset	#0,render_flags(a0)
	rts
; ===========================================================================
;loc_32C66
Obj53_CheckPlayerHit:
	cmpi.b	#4,(MainCharacter+routine).w
	beq.s	+
	cmpi.b	#4,(Sidekick+routine).w
	bne.s	++
+
	move.b	#$14,mapping_frame(a0)
	move.b	#6,anim(a0)
+
	cmpi.b	#-2,collision_property(a0)
	bgt.s	+
	move.b	#$14,mapping_frame(a0)
	move.b	#6,anim(a0)
+
	rts
; ===========================================================================
;loc_32C98
Obj53_Burst:
	move.b	#SndID_BossExplosion,d0
	jsrto	PlaySound, JmpTo10_PlaySound
	movea.l	objoff_34(a0),a1 ; a1=object
	subi_.b	#1,objoff_2C(a1)

    if removeJmpTos
JmpTo61_DeleteObject ; JmpTo
    endif

	jmpto	DeleteObject, JmpTo61_DeleteObject
; ===========================================================================
;loc_32CAE
Obj54_Laser:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_32CBC(pc,d0.w),d0
	jmp	off_32CBC(pc,d0.w)
; ===========================================================================
off_32CBC:	offsetTable
		offsetTableEntry.w Obj54_Laser_Init	; 0
		offsetTableEntry.w Obj54_Laser_Main	; 2
; ===========================================================================
;loc_32CC0
Obj54_Laser_Init:
	move.l	#Obj54_MapUnc_32DC6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MTZBoss,0,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#5,priority(a0)
	move.b	#$12,mapping_frame(a0)
	addq.b	#2,routine_secondary(a0)	; => Obj54_Laser_Main
	movea.l	objoff_34(a0),a1 ; a1=object
	move.b	#$50,width_pixels(a0)
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	addi_.w	#7,y_pos(a0)
	subi_.w	#4,x_pos(a0)
	move.w	#-$400,d0
	btst	#0,render_flags(a1)
	beq.s	+
	neg.w	d0
	addi_.w	#8,x_pos(a0)
+
	move.w	d0,x_vel(a0)
	move.b	#$99,collision_flags(a0)
	move.b	#SndID_LaserBurst,d0
	jsrto	PlaySound, JmpTo10_PlaySound
;loc_32D2C
Obj54_Laser_Main:
	jsrto	ObjectMove, JmpTo24_ObjectMove
	cmpi.w	#$2AB0,x_pos(a0)
	blo.w	JmpTo61_DeleteObject
	cmpi.w	#$2BF0,x_pos(a0)
	bhs.w	JmpTo61_DeleteObject
	jmpto	DisplaySprite, JmpTo40_DisplaySprite
; ===========================================================================
;loc_32D48
Obj54_LaserShooter:
	movea.l	objoff_34(a0),a1 ; a1=object
	cmpi.b	#ObjID_MTZBoss,id(a1)
	bne.w	JmpTo61_DeleteObject
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	bclr	#0,render_flags(a0)
	btst	#0,render_flags(a1)
	beq.w	JmpTo40_DisplaySprite
	bset	#0,render_flags(a0)

    if removeJmpTos
JmpTo40_DisplaySprite ; JmpTo
    endif

	jmpto	DisplaySprite, JmpTo40_DisplaySprite
; ===========================================================================
; animation script
; off_32D7A:
Ani_obj53:	offsetTable
		offsetTableEntry.w byte_32D8A	; 0
		offsetTableEntry.w byte_32D8D	; 1
		offsetTableEntry.w byte_32D91	; 2
		offsetTableEntry.w byte_32DA6	; 3
		offsetTableEntry.w byte_32DAA	; 4
		offsetTableEntry.w byte_32DB5	; 5
		offsetTableEntry.w byte_32DC0	; 6
		offsetTableEntry.w byte_32DC3	; 7
byte_32D8A:	dc.b  $F,  2,$FF
	rev02even
byte_32D8D:	dc.b   1,  0,  1,$FF
	rev02even
byte_32D91:	dc.b   3,  5,  5,  5,  5,  5,  5,  5,  5,  6,  7,  6,  7,  6,  7,  8
		dc.b   9, $A, $B,$FE,  1; 16
	rev02even
byte_32DA6:	dc.b   7, $C, $D,$FF
	rev02even
byte_32DAA:	dc.b   7, $E, $F, $E, $F, $E, $F, $E, $F,$FD,  3
	rev02even
byte_32DB5:	dc.b   7,$10,$10,$10,$10,$10,$10,$10,$10,$FD,  3
	rev02even
byte_32DC0:	dc.b   1,$14,$FC
	rev02even
byte_32DC3:	dc.b   7,$11,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj54_MapUnc_32DC6:	include "mappings/sprite/obj54.asm"

    if ~~removeJmpTos
	align 4
    endif
; ===========================================================================

    if ~~removeJmpTos
JmpTo40_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo61_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo17_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
JmpTo10_PlaySound ; JmpTo
	jmp	(PlaySound).l
JmpTo21_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo11_LoadPLC ; JmpTo
	jmp	(LoadPLC).l
JmpTo8_AddPoints ; JmpTo
	jmp	(AddPoints).l
JmpTo7_PlayLevelMusic ; JmpTo
	jmp	(PlayLevelMusic).l
JmpTo7_LoadPLC_AnimalExplosion ; JmpTo
	jmp	(LoadPLC_AnimalExplosion).l
JmpTo6_ObjectMoveAndFall ; JmpTo
	jmp	(ObjectMoveAndFall).l
; loc_32F88:
JmpTo24_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif
