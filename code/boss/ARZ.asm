; ===========================================================================
; ----------------------------------------------------------------------------
; Object 89 - ARZ boss
; ----------------------------------------------------------------------------
; OST Variables:
; Main Vehicle
obj89_hammer_y_vel	= objoff_2E		; falling hammer's y velocity
obj89_target		= objoff_38
obj89_hammer_y_pos	= objoff_3A		; falling hammer's y position
obj89_hammer_flags	= objoff_3E

; Pillars & Arrows
obj89_pillar_parent		= objoff_2A	; address of main vehicle
obj89_pillar_shake_time		= objoff_30
obj89_pillar_shaking		= objoff_38
obj89_eyes_timer		= objoff_30
obj89_arrow_routine		= objoff_2A
obj89_arrow_timer		= objoff_30
obj89_arrow_parent2		= objoff_34
obj89_arrow_parent		= objoff_38	; address of main vehicle

; Sprite_30480:
Obj89:
	moveq	#0,d0
	move.b	boss_subtype(a0),d0
	move.w	Obj89_Index(pc,d0.w),d1
	jmp	Obj89_Index(pc,d1.w)
; ===========================================================================
; off_3048E:
Obj89_Index:	offsetTable
		offsetTableEntry.w Obj89_Init	; 0 - Init
		offsetTableEntry.w Obj89_Main	; 2 - Main Vehicle
		offsetTableEntry.w Obj89_Pillar	; 4 - Pillars & Arrows
    if fixBugs
		; These shouldn't be subtypes of the pillar object, as the
		; 'obj89_pillar_parent' variable does not exist to them: they
		; should be subtypes of the main boss object instead.
		; This mistake causes 'obj89_pillar_parent' to be deferenced
		; even when it is set to 0, or overwritten by
		; 'obj89_arrow_routine', which can cause crashes or other
		; eratic behaviour.
		offsetTableEntry.w Obj89_Arrow			; 6 - arrow
		offsetTableEntry.w Obj89_Pillar_BulgingEyes	; 8 - pillar normal (standing)
    endif
; ===========================================================================
; loc_30494:
Obj89_Init:
	tst.l	(Plc_Buffer).w			; is art finished loading?
	beq.s	+				; if yes, branch
	rts
; ---------------------------------------------------------------------------
+
	tst.w	(Player_mode).w			; is player mode anything other than Sonic & Tails?
	bne.s	Obj89_Init_RaisePillars		; if yes, branch
	move.w	(MainCharacter+x_pos).w,d0
	cmpi.w	#$2A60,d0			; is Sonic too close to the left edge?
	blt.w	Obj89_Init_Standard		; if yes, branch
	cmpi.w	#$2B60,d0			; is Sonic too close to the right edge?
	bgt.w	Obj89_Init_Standard		; if yes, branch
	cmpi.b	#$81,(Sidekick+obj_control).w
	beq.w	Obj89_Init_RaisePillars		; branch, if Tails is flying
	move.w	(Sidekick+x_pos).w,d0
	cmpi.w	#$2A60,d0			; is Tails too close to the left edge?
	blt.w	Obj89_Init_Standard		; if yes, branch
	cmpi.w	#$2B60,d0			; is Tails too close to the right edge?
	bgt.w	Obj89_Init_Standard		; if yes, branch

; loc_304D4:
Obj89_Init_RaisePillars:
	move.b	#1,(Screen_Shaking_Flag).w	; make screen shake
	move.w	#make_art_tile(ArtTile_ArtNem_ARZBoss,0,0),art_tile(a0)
	move.l	#Obj89_MapUnc_30E04,mappings(a0)
	ori.b	#4,render_flags(a0)
	move.b	#$20,mainspr_width(a0)
    if ~~fixBugs
	; Multi-sprite objects cannot use the 'priority' SST as it is
	; overwritten by 'sub3_y_pos'.
	move.b	#2,priority(a0)
    endif
	move.b	#2,boss_subtype(a0)	; => Obj89_Main
	move.w	#$2AE0,x_pos(a0)
	move.w	#$388,y_pos(a0)
	move.w	#$2AE0,(Boss_X_pos).w
	move.w	#$388,(Boss_Y_pos).w
	bset	#6,render_flags(a0)
	move.b	#3,mainspr_childsprites(a0)
	move.b	#$F,collision_flags(a0)
	move.b	#8,boss_hitcount2(a0)
	move.b	#8,mainspr_mapframe(a0)
	move.w	#-$380,obj89_hammer_y_vel(a0)
	clr.b	(Boss_CollisionRoutine).w	; disable special collisions
	move.w	#$2AE0,sub2_x_pos(a0)		;
	move.w	#$488,sub2_y_pos(a0)
	move.b	#0,sub2_mapframe(a0)
	move.w	#$2AE0,sub3_x_pos(a0)		;
	move.w	#$488,sub3_y_pos(a0)
	move.b	#9,sub3_mapframe(a0)
	move.w	#$2AE0,sub4_x_pos(a0)		;
	move.w	#$488,sub4_y_pos(a0)
	move.b	#6,sub4_mapframe(a0)
	move.w	#$100,(Boss_Y_vel).w

	; load first pillar object
	jsrto	AllocateObject, JmpTo14_AllocateObject
	bne.w	Obj89_Init_Standard
	move.b	#ObjID_ARZBoss,id(a1) ; load obj89
	move.l	#Obj89_MapUnc_30D68,mappings(a1)
	ori.b	#4,render_flags(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_ARZBoss,0,0),art_tile(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#4,priority(a1)
	move.w	#$2A50,x_pos(a1)
	move.w	#$510,y_pos(a1)
	addq.b	#4,boss_subtype(a1)	; => Obj89_Pillar
	move.l	a0,obj89_pillar_parent(a1)
	move.b	#0,mapping_frame(a1)
	move.b	#2,priority(a1)
	move.b	#$20,y_radius(a1)
	movea.l	a1,a2				; save first pillar's address
	jsrto	AllocateObjectAfterCurrent, JmpTo22_AllocateObjectAfterCurrent
	bne.s	Obj89_Init_Standard
	moveq	#0,d0

	move.w	#bytesToLcnt(object_size),d1

; loc_305DC:
Obj89_Init_DuplicatePillar:
	move.l	(a2,d0.w),(a1,d0.w)
	addq.w	#4,d0
	dbf	d1,Obj89_Init_DuplicatePillar
    if object_size&3
	move.w	(a2,d0.w),(a1,d0.w)
    endif

	bset	#0,render_flags(a1)
	move.w	#$2B70,x_pos(a1)		; move pillar to other side of boss area

; loc_305F4:
Obj89_Init_Standard:
	bsr.w	Obj89_Init_AnimationArray
	rts
; ===========================================================================
; loc_305FA:
Obj89_Init_AnimationArray:
	lea	(Boss_AnimationArray).w,a2
	move.b	#4,(a2)+	; main vehicle
	move.b	#0,(a2)+
	move.b	#0,(a2)+	; face
	move.b	#0,(a2)+
	move.b	#2,(a2)+	; hammer
	move.b	#0,(a2)+
	move.b	#1,(a2)+	; flames
	move.b	#0,(a2)+
	rts
; ===========================================================================
; loc_30620:
Obj89_Main:
	moveq	#0,d0
	move.b	boss_routine(a0),d0
	move.w	Obj89_Main_Index(pc,d0.w),d1
	jmp	Obj89_Main_Index(pc,d1.w)
; ===========================================================================
; off_3062E:
Obj89_Main_Index:	offsetTable			; main boss object
		offsetTableEntry.w Obj89_Main_Sub0	; 0 - moving down into arena
		offsetTableEntry.w Obj89_Main_Sub2	; 2 - moving left/right
		offsetTableEntry.w Obj89_Main_Sub4	; 4 - having reached pillar
		offsetTableEntry.w Obj89_Main_Sub6	; 6 - hit with hammer
		offsetTableEntry.w Obj89_Main_Sub8	; 8 - boss exploding
		offsetTableEntry.w Obj89_Main_SubA	; A - move boss down and alter a little up again
		offsetTableEntry.w Obj89_Main_SubC	; C - beaten boss moving away
; ===========================================================================
; loc_3063C:
Obj89_Main_Sub0:
	bsr.w	Boss_MoveObject
	bsr.w	Obj89_Main_HandleFace
	bsr.w	Obj89_Main_AlignParts
	cmpi.w	#$430,(Boss_Y_pos).w		; has boss reached its target?
	blt.s	Obj89_Main_Sub0_Standard	; if not, branch
	move.w	#$430,(Boss_Y_pos).w
	addi_.b	#2,boss_routine(a0)	; => Obj89_Main_Sub2
	move.w	#0,(Boss_Y_vel).w		; stop y movement
	move.w	#-$C8,(Boss_X_vel).w		; move leftward
	st.b	obj89_target(a0)

; loc_3066C:
Obj89_Main_Sub0_Standard:
	lea	(Ani_obj89_b).l,a1
	bsr.w	AnimateBoss
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*2,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
    endif
; ===========================================================================
; loc_3067A:
Obj89_Main_Sub2:
	bsr.w	Boss_MoveObject
	bsr.w	Obj89_Main_HandleFace
	bsr.w	Obj89_Main_AlignParts
	tst.b	obj89_target(a0)		; is boss going left?
	bne.s	Obj89_Main_Sub2_GoingLeft	; if yes, branch
	cmpi.w	#$2B10,(Boss_X_pos).w		; is boss right in front of the right pillar?
	blt.s	Obj89_Main_Sub2_Standard	; branch, if still too far away
	bra.s	Obj89_Main_Sub2_AtTarget
; ===========================================================================
; loc_30696:
Obj89_Main_Sub2_GoingLeft:
	cmpi.w	#$2AB0,(Boss_X_pos).w		; is boss right in front of the left pillar?
	bgt.s	Obj89_Main_Sub2_Standard	; branch, if still too far away

; loc_3069E:
Obj89_Main_Sub2_AtTarget:
	addi_.b	#2,boss_routine(a0)	; => Obj89_Main_Sub4
	move.w	#0,(Boss_X_vel).w

; loc_306AA:
Obj89_Main_Sub2_Standard:
	lea	(Ani_obj89_b).l,a1
	bsr.w	AnimateBoss
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*2,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
    endif
; ===========================================================================
; loc_306B8:
Obj89_Main_Sub4:
	bsr.w	Boss_MoveObject
	bsr.w	Obj89_Main_HandleFace
	bsr.w	Obj89_Main_AlignParts
	cmpi.b	#-$40,boss_sine_count(a0)	; has boss reached the right height in its hovering animation?
	bne.s	Obj89_Main_Sub4_Standard	; if not, branch
	lea	(Boss_AnimationArray).w,a1
	andi.b	#$F0,2*2(a1)			; reset hammer animation
	ori.b	#3,2*2(a1)			; reset hammer animation timer
	addq.b	#2,boss_routine(a0)	; => Obj89_Main_Sub6
	btst	#0,render_flags(a0)
	sne	obj89_target(a0)		; target opposite side
	move.w	#$1E,(Boss_Countdown).w
	move.b	#SndID_Hammer,d0
	jsrto	PlaySound, JmpTo8_PlaySound

; loc_306F8:
Obj89_Main_Sub4_Standard:
	lea	(Ani_obj89_b).l,a1
	bsr.w	AnimateBoss
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*2,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
    endif
; ===========================================================================
; loc_30706:
Obj89_Main_Sub6:
	cmpi.w	#$14,(Boss_Countdown).w		; has counter reached a specific value?
	bne.s	+				; if not, branch
	bset	#0,obj89_hammer_flags(a0)	; hammer just hit a pillar
	move.b	#1,(Boss_CollisionRoutine).w	; enable hammer collision
+
	subi_.w	#1,(Boss_Countdown).w		; decrement counter
	bpl.s	Obj89_Main_Sub6_Standard	; branch, if counter > 0
	clr.b	(Boss_CollisionRoutine).w	; disable hammer collision
	move.b	#2,boss_routine(a0)	; => Obj89_Main_Sub2
	bchg	#0,render_flags(a0)		; face opposite direction
	beq.s	Obj89_Main_Sub6_MoveRight	; branch, if new direction is right
	move.w	#-$C8,(Boss_X_vel).w		; move left
	bra.s	Obj89_Main_Sub6_Standard
; ===========================================================================
; loc_3073C:
Obj89_Main_Sub6_MoveRight:
	move.w	#$C8,(Boss_X_vel).w		; move right

; loc_30742:
Obj89_Main_Sub6_Standard:
	bsr.w	Boss_MoveObject
	bsr.w	Obj89_Main_HandleFace
	bsr.w	Obj89_Main_AlignParts
	lea	(Ani_obj89_b).l,a1
	bsr.w	AnimateBoss
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*2,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
    endif
; ===========================================================================
; loc_3075C:
Obj89_Main_HandleFace:
	bsr.w	Obj89_Main_HandleHoveringAndHits
	cmpi.b	#4,(MainCharacter+routine).w	; is Sonic hurt?
	beq.s	Obj89_Main_Laugh		; if yes, branch
	cmpi.b	#4,(Sidekick+routine).w		; is Tails hurt?
	bne.s	Obj89_Main_ChkHurt		; if not, branch

; loc_30770:
Obj89_Main_Laugh:
	lea	(Boss_AnimationArray).w,a1
	move.b	#$31,1*2+1(a1)			; use laughing animation

; loc_3077A:
Obj89_Main_ChkHurt:
	cmpi.b	#64-1,boss_invulnerable_time(a0)	; was boss hurt?
	bne.s	return_3078C				; if not, branch
	lea	(Boss_AnimationArray).w,a1
	move.b	#-$40,1*2+1(a1)			; use hurt animation

return_3078C:
	rts
; ===========================================================================
; loc_3078E:
Obj89_Main_HandleHoveringAndHits:
	move.b	boss_sine_count(a0),d0
	jsr	(CalcSine).l
	asr.w	#6,d0
	add.w	(Boss_Y_pos).w,d0
	move.w	d0,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	addq.b	#2,boss_sine_count(a0)
	cmpi.b	#8,boss_routine(a0)		; has boss been defeated?
	bhs.s	return_307F2			; if yes, branch
	tst.b	boss_hitcount2(a0)		; has boss run out of hits?
	beq.s	Obj89_Main_KillBoss		; if yes, branch
	tst.b	collision_flags(a0)		; are boss's collisions enabled?
	bne.s	return_307F2			; if yes, branch
	tst.b	boss_invulnerable_time(a0)	; is boss invulnerable?
	bne.s	Obj89_Main_Flash		; if yes, branch
	move.b	#64,boss_invulnerable_time(a0)	; make boss invulnerable
	move.w	#SndID_BossHit,d0		; play "boss hit" sound
	jsr	(PlaySound).l

; loc_307D6:
Obj89_Main_Flash:
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0				; 0000 = black
	tst.w	(a1)				; is current color black?
	bne.s	+				; if not, branch
	move.w	#$EEE,d0			; 0EEE = white
+
	move.w	d0,(a1)				; set color
	subq.b	#1,boss_invulnerable_time(a0)
	bne.s	return_307F2			; branch, if invulnerability hasn't run out
	move.b	#$F,collision_flags(a0)		; restore collisions

return_307F2:
	rts
; ===========================================================================
; loc_307F4:
Obj89_Main_KillBoss:
	moveq	#100,d0
	jsrto	AddPoints, JmpTo5_AddPoints
	move.w	#$B3,(Boss_Countdown).w		; set timer
	move.b	#8,boss_routine(a0)	; => Obj89_Main_Sub8
	lea	(Boss_AnimationArray).w,a1
	move.b	#5,1*2(a1)			; use defeated animation
	move.b	#0,1*2+1(a1)			; reset animation
	moveq	#PLCID_Capsule,d0
	jsrto	LoadPLC, JmpTo8_LoadPLC
	move.b	#5,sub2_mapframe(a0)
	rts
; ===========================================================================
; loc_30824:
Obj89_Main_AlignParts:
	move.w	x_pos(a0),d0
	move.w	y_pos(a0),d1
	move.w	d0,sub2_x_pos(a0)
	move.w	d1,sub2_y_pos(a0)
	move.w	d0,sub4_x_pos(a0)
	move.w	d1,sub4_y_pos(a0)
	tst.b	boss_defeated(a0)
	bne.s	Obj89_Main_DropHammer		; branch, if boss was defeated
	move.w	d0,sub3_x_pos(a0)
	move.w	d1,sub3_y_pos(a0)
	move.w	d1,obj89_hammer_y_pos(a0)
	rts
; ===========================================================================
; loc_30850:
Obj89_Main_DropHammer:
	cmpi.w	#$78,(Boss_Countdown).w
	bgt.s	return_3088A			; wait until timer is below $78
	subi_.w	#1,sub3_x_pos(a0)		; make hammer move left
	move.l	obj89_hammer_y_pos(a0),d0
	move.w	obj89_hammer_y_vel(a0),d1
	addi.w	#$38,obj89_hammer_y_vel(a0)	; add gravity
	ext.l	d1
	asl.l	#8,d1
	add.l	d1,d0
	move.l	d0,obj89_hammer_y_pos(a0)	; update position
	move.w	obj89_hammer_y_pos(a0),sub3_y_pos(a0)
	cmpi.w	#$540,sub3_y_pos(a0)		; has the hammer reached the bottom?
	blt.s	return_3088A			; if not, branch
	move.w	#0,obj89_hammer_y_vel(a0)	; else, make hammer invisible

return_3088A:
	rts
; ===========================================================================
; loc_3088C:
Obj89_Main_Sub8:
	st.b	boss_defeated(a0)
	subq.w	#1,(Boss_Countdown).w
	bmi.s	Obj89_Main_SetupEscapeAnim
	bsr.w	Boss_LoadExplosion
	bra.s	Obj89_Main_Sub8_Standard
; ===========================================================================
; loc_3089C:
Obj89_Main_SetupEscapeAnim:
	move.b	#3,mainspr_childsprites(a0)
	lea	(Boss_AnimationArray).w,a2
	move.b	#1,2*2(a2)			; hammer
	move.b	#0,2*2+1(a2)
	move.b	#0,1*2(a2)			; face
	move.b	#0,1*2+1(a2)
	bset	#0,render_flags(a0)
	clr.w	(Boss_X_vel).w			; stop movement
	clr.w	(Boss_Y_vel).w
	addq.b	#2,boss_routine(a0)	; => Obj89_Main_SubA
	move.w	#-$12,(Boss_Countdown).w

; loc_308D6:
Obj89_Main_Sub8_Standard:
	move.w	(Boss_Y_pos).w,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	lea	(Ani_obj89_b).l,a1
	bsr.w	AnimateBoss
	bsr.w	Obj89_Main_AlignParts
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*2,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
    endif
; ===========================================================================
; loc_308F4:
Obj89_Main_SubA:
	addq.w	#1,(Boss_Countdown).w		; note: countdown starts out as -$12
	beq.s	Obj89_Main_SubA_StopFall	; branch, if countdown reached 0
	bpl.s	Obj89_Main_SubA_Phase2		; branch, if falling phase is over
	addi.w	#$18,(Boss_Y_vel).w		; else, make boss fall
	bra.s	Obj89_Main_SubA_Standard
; ===========================================================================
; loc_30904:
Obj89_Main_SubA_StopFall:
	clr.w	(Boss_Y_vel).w			; stop fall
	bra.s	Obj89_Main_SubA_Standard
; ===========================================================================
; loc_3090A:
Obj89_Main_SubA_Phase2:
	cmpi.w	#$18,(Boss_Countdown).w
	blo.s	Obj89_Main_SubA_Ascend
	beq.s	Obj89_Main_SubA_StopAscent
	cmpi.w	#$20,(Boss_Countdown).w
	blo.s	Obj89_Main_SubA_Standard
	addq.b	#2,boss_routine(a0)	; => Obj89_Main_SubC
	bra.s	Obj89_Main_SubA_Standard
; ===========================================================================
; loc_30922:
Obj89_Main_SubA_Ascend:
	subi_.w	#8,(Boss_Y_vel).w		; ascend slowly
	bra.s	Obj89_Main_SubA_Standard
; ===========================================================================
; loc_3092A:
Obj89_Main_SubA_StopAscent:
	clr.w	(Boss_Y_vel).w			; stop ascent
	jsrto	PlayLevelMusic, JmpTo4_PlayLevelMusic
	jsrto	LoadPLC_AnimalExplosion, JmpTo4_LoadPLC_AnimalExplosion

; loc_30936:
Obj89_Main_SubA_Standard:
	bsr.w	Boss_MoveObject
	bsr.w	Obj89_Main_HandleHoveringAndHits
	move.w	(Boss_Y_pos).w,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	lea	(Ani_obj89_b).l,a1
	bsr.w	AnimateBoss
	bsr.w	Obj89_Main_AlignParts
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*2,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
    endif
; ===========================================================================
; loc_3095C:
Obj89_Main_SubC:
	move.w	#$400,(Boss_X_vel).w
	move.w	#-$40,(Boss_Y_vel).w
	cmpi.w	#$2C00,(Camera_Max_X_pos).w	; has camera reached its target position?
	bhs.s	Obj89_Main_SubC_ChkDelete	; if yes, branch
	addq.w	#2,(Camera_Max_X_pos).w		; else, move camera
	bra.s	Obj89_Main_SubC_Standard
; ===========================================================================
; loc_30976:
Obj89_Main_SubC_ChkDelete:
	tst.b	render_flags(a0)		; is boss still visible?
	bpl.s	JmpTo54_DeleteObject		; if not, branch

; loc_3097C:
Obj89_Main_SubC_Standard:
	bsr.w	Boss_MoveObject
	bsr.w	Obj89_Main_HandleHoveringAndHits
	move.w	(Boss_Y_pos).w,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	lea	(Ani_obj89_b).l,a1
	bsr.w	AnimateBoss
	bsr.w	Obj89_Main_AlignParts
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	move.w	#object_display_list_size*2,d0
	jmp	(DisplaySprite3).l
    else
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
    endif
; ===========================================================================

JmpTo54_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
; ===========================================================================
; loc_309A8:
Obj89_Pillar:
	moveq	#0,d0
	movea.l	obj89_pillar_parent(a0),a1 ; a1=object
	cmpi.b	#8,boss_routine(a1)		; has boss been defeated?
	blt.s	Obj89_Pillar_Normal		; if not, branch
	move.b	#4,routine_secondary(a0)

; loc_309BC:
Obj89_Pillar_Normal:
	move.b	routine_secondary(a0),d0
	move.w	Obj89_Pillar_Index(pc,d0.w),d1
	jmp	Obj89_Pillar_Index(pc,d1.w)
; ===========================================================================
; off_309C8:
Obj89_Pillar_Index:	offsetTable				; pillar/arrow object
		offsetTableEntry.w Obj89_Pillar_Sub0		; 0 - raise pillars
		offsetTableEntry.w Obj89_Pillar_Sub2		; 2 - pillars shaking(?)
		offsetTableEntry.w Obj89_Pillar_Sub4		; 4 - move pillars down
    if ~~fixBugs
		; See the bugfix under 'Obj89_Index'.
		offsetTableEntry.w Obj89_Arrow			; 6 - arrow
		offsetTableEntry.w Obj89_Pillar_BulgingEyes	; 8 - pillar normal (standing)
    endif
; ===========================================================================
; loc_309D2:
Obj89_Pillar_Sub0:
	bsr.w	Obj89_Pillar_SolidObject
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+
	move.w	#SndID_Rumbling2,d0		; play rumbling sound every 32 frames
	jsrto	PlaySound, JmpTo8_PlaySound
+
	subi_.w	#1,y_pos(a0)			; raise pillar
	cmpi.w	#$488,y_pos(a0)			; has pillar reached its target height?
	bgt.s	BranchTo_JmpTo37_DisplaySprite	; if not, branch
	addq.b	#2,routine_secondary(a0)	; => Obj89_Pillar_Sub2
	move.b	#0,(Screen_Shaking_Flag).w	; stop screen shaking

BranchTo_JmpTo37_DisplaySprite ; BranchTo
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
; ===========================================================================
; loc_30A04:
Obj89_Pillar_Sub2:
	; note: the boss switches targets before bit 0 of obj89_hammer_flags is set.  In other
	; words, it's always the pillar facing the new target that fires.
	bsr.w	Obj89_Pillar_SolidObject
	movea.l	obj89_pillar_parent(a0),a3 ; a3=object
	btst	#0,obj89_hammer_flags(a3)
	beq.s	Obj89_Pillar_Sub2_Standard	; branch, if hammer hasn't hit a pillar
	tst.b	obj89_target(a3)		; is boss targeting the right?
	beq.s	Obj89_Pillar_Sub2_RightPillar	; if yes, branch
	btst	#0,render_flags(a0)		; is pillar facing left?
	beq.s	Obj89_Pillar_Sub2_Standard	; if not, branch
	bra.s	loc_30A2C
; ===========================================================================
; loc_30A24:
Obj89_Pillar_Sub2_RightPillar:
	btst	#0,render_flags(a0)		; is pillar facing right?
	bne.s	Obj89_Pillar_Sub2_Standard	; if not, branch

loc_30A2C:
	bclr	#0,obj89_hammer_flags(a3)	; clear "hitting-pillar" flag
	bsr.w	Obj89_Pillar_Shoot		; shoot an arrow
	st.b	obj89_pillar_shaking(a0)	; make pillar shake

; loc_30A3A:
Obj89_Pillar_Sub2_Standard:
	bsr.w	Obj89_Pillar_ChkShake
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
; ===========================================================================
; loc_30A42:
Obj89_Pillar_ChkShake:
	tst.b	obj89_pillar_shaking(a0)	; is pillar shaking?
	beq.s	return_30AAE			; if not, branch
	tst.w	obj89_pillar_shake_time(a0)	; has timer been set?
	bgt.s	+				; if yes, branch
	move.w	#$1F,obj89_pillar_shake_time(a0); else, initialize timer
+
	subi_.w	#1,obj89_pillar_shake_time(a0)
	bgt.s	Obj89_Pillar_Shake		; branch, if timer hasn't expired
	sf	obj89_pillar_shaking(a0)	; stop shaking
	move.w	#0,obj89_pillar_shake_time(a0)	; clear timer
	tst.b	obj89_target(a3)		; is boss targeting the left?
	bne.s	+				; if yes, branch
	move.w	#$2A50,x_pos(a0)		; reset x position of left pillar
	bra.s	Obj89_Pillar_Sub2_End
; ===========================================================================
+
	move.w	#$2B70,x_pos(a0)		; reset x position of right pillar

; loc_30A7A:
Obj89_Pillar_Sub2_End:
	move.w	#$488,y_pos(a0)			; reset y position
	bra.s	return_30AAE
; ===========================================================================
; loc_30A82:
Obj89_Pillar_Shake:
	move.w	#$2A50,d1			; load left pillar's default x position
	tst.b	obj89_target(a3)		; is boss targeting the left
	beq.s	+				; if not, branch
	move.w	#$2B70,d1			; load right pillar's default x position
+
	move.b	(Vint_runcount+3).w,d0
	andi.w	#1,d0
	add.w	d0,d0
	add.w	Obj89_Pillar_ShakeOffsets(pc,d0.w),d1
	move.w	d1,x_pos(a0)			; add offset to x position
	move.w	#$488,d1			; load  pillar's default y position
	add.w	Obj89_Pillar_ShakeOffsets(pc,d0.w),d1
	move.w	d1,y_pos(a0)			; add offset to y position

return_30AAE:
	rts
; ===========================================================================
; word_30AB0:
Obj89_Pillar_ShakeOffsets:
	dc.w	 1	; 0
	dc.w	-1	; 1
; ===========================================================================
; loc_30AB4:
Obj89_Pillar_Shoot:
	jsrto	AllocateObject, JmpTo14_AllocateObject
	bne.w	return_30B40
	_move.b	#ObjID_ARZBoss,id(a1) ; load obj89
    if fixBugs
	; See the bugfix under 'Obj89_Index'.
	move.b	#8,boss_subtype(a1)	; => Obj89_Pillar_BulgingEyes
    else
	move.b	#4,boss_subtype(a1)
	move.b	#8,routine_secondary(a1)	; => Obj89_Pillar_BulgingEyes
    endif
	move.l	#Obj89_MapUnc_30D68,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_ARZBoss,0,0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	moveq	#0,d6
	move.b	#2,mapping_frame(a1)
	move.w	#$2A6A,x_pos(a1)		; align with left pillar
	tst.b	obj89_target(a3)		; is boss targeting the right?
	beq.s	+				; if yes, branch
	st.b	d6
	move.w	#$2B56,x_pos(a1)		; align with right pillar
	bset	#0,render_flags(a1)
+
	move.w	#$28,obj89_eyes_timer(a1)
	jsrto	RandomNumber, JmpTo3_RandomNumber
	andi.w	#3,d0
	add.w	d0,d0
	move.w	Obj89_Arrow_Offsets(pc,d0.w),y_pos(a1)
	movea.l	a1,a2
	jsrto	AllocateObject, JmpTo14_AllocateObject
	bne.s	return_30B40
	_move.b	#ObjID_ARZBoss,id(a1) ; load obj89
    if fixBugs
	; See the bugfix under 'Obj89_Index'.
	move.b	#6,boss_subtype(a1)	; => Obj89_Arrow
    else
	move.b	#4,boss_subtype(a1)
	move.b	#6,routine_secondary(a1)	; => Obj89_Arrow
    endif
	move.l	a2,obj89_arrow_parent2(a1)
	move.b	d6,subtype(a1)
	move.l	a3,obj89_arrow_parent(a1)

return_30B40:
	rts
; ===========================================================================
; word_30B42:
Obj89_Arrow_Offsets:
	dc.w  $458
	dc.w  $478	; 1
	dc.w  $498	; 2
	dc.w  $4B8	; 3
; ===========================================================================
; loc_30B4A:
Obj89_Pillar_Sub4:
	move.b	#1,(Screen_Shaking_Flag).w	; make screen shake
	addi_.w	#1,y_pos(a0)			; lower pillar
	cmpi.w	#$510,y_pos(a0)			; has pillar lowered into the ground?
	blt.s	BranchTo2_JmpTo37_DisplaySprite	; if not, branch
	move.b	#0,(Screen_Shaking_Flag).w	; else, stop shaking the screen
	jmpto	DeleteObject, JmpTo55_DeleteObject
; ===========================================================================

BranchTo2_JmpTo37_DisplaySprite
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
; ===========================================================================
; loc_30B6C:
Obj89_Pillar_BulgingEyes:
	subi_.w	#1,obj89_eyes_timer(a0)
	beq.w	JmpTo55_DeleteObject
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
; ===========================================================================
; loc_30B7A:
Obj89_Pillar_SolidObject:
	move.w	#$23,d1
	move.w	#$44,d2
	move.w	#$45,d3
	move.w	x_pos(a0),d4
	move.w	y_pos(a0),-(sp)
	addi_.w	#4,y_pos(a0)			; assume a slightly lower y position
	jsrto	SolidObject, JmpTo26_SolidObject
	move.w	(sp)+,y_pos(a0)			; restore y position
	rts
; ===========================================================================
;loc_30B9E:
Obj89_Arrow:
	moveq	#0,d0
	movea.l	obj89_arrow_parent(a0),a1 ; a1=object
	cmpi.b	#8,boss_routine(a1)		; has boss been defeated?
	blt.s	Obj89_Arrow_Normal		; if not, branch
	move.b	#6,obj89_arrow_routine(a0)	; => Obj89_Arrow_Sub6

; loc_30BB2:
Obj89_Arrow_Normal:
	move.b	obj89_arrow_routine(a0),d0
	move.w	Obj89_Arrow_Index(pc,d0.w),d1
	jmp	Obj89_Arrow_Index(pc,d1.w)
; ===========================================================================
; off_30BBE:
Obj89_Arrow_Index:	offsetTable
		offsetTableEntry.w Obj89_Arrow_Init			; 0 - launch arrow (init)
		offsetTableEntry.w Obj89_Arrow_Sub2			; 2 - arrow in air
		offsetTableEntry.w Obj89_Arrow_Sub4			; 4 - arrow stuck
		offsetTableEntry.w Obj89_Arrow_Sub6			; 6 - falling down
		offsetTableEntry.w BranchTo_JmpTo55_DeleteObject	; 8 - delete arrow
; ===========================================================================
; loc_30BC8:
Obj89_Arrow_Init:
	move.l	#Obj89_MapUnc_30D68,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_ARZBoss,0,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#-$70,mainspr_width(a0)
	move.b	#4,priority(a0)
	addq.b	#2,obj89_arrow_routine(a0)	; => Obj89_Arrow_Sub2
	movea.l	obj89_arrow_parent2(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)		; align with parent object
	move.w	y_pos(a1),y_pos(a0)
	move.w	#4,y_vel(a0)
	move.b	#4,mapping_frame(a0)
	addi.w	#9,y_pos(a0)
	tst.b	subtype(a0)			; was arrow fired from right pillar?
	beq.s	+				; if not, branch
	bset	#0,status(a0)			; make arrow face left
	bset	#0,render_flags(a0)
	move.w	#-3,x_vel(a0)			; move left
	bra.s	Obj89_Arrow_Init_End
; ===========================================================================
+
	move.w	#3,x_vel(a0)			; move right

; loc_30C2E:
Obj89_Arrow_Init_End:
	move.b	#$B0,collision_flags(a0)
	rts
; ===========================================================================
; loc_30C36:
Obj89_Arrow_Sub2:
	btst	#7,status(a0)
	beq.s	+
	move.b	#8,obj89_arrow_routine(a0)	; => BranchTo_JmpTo55_DeleteObject
+
	move.w	x_pos(a0),d0			; load x position...
	add.w	x_vel(a0),d0			; ...and add x velocity
	tst.w	x_vel(a0)			; is arrow moving right?
	bpl.s	Obj89_Arrow_Sub2_GoingRight	; if yes, branch
	cmpi.w	#$2A77,d0
	bgt.s	Obj89_Arrow_Sub2_Move		; branch, if arrow hasn't reached left pillar
	move.w	#$2A77,d0			; else, make arrow stick to left pillar
	bra.s	Obj89_Arrow_Sub2_Stop
; ===========================================================================
; loc_30C5E:
Obj89_Arrow_Sub2_GoingRight:
	cmpi.w	#$2B49,d0
	blt.s	Obj89_Arrow_Sub2_Move		; branch, if arrow hasn't reached right pillar
	move.w	#$2B49,d0			; else, make arrow stick to right pillar

; loc_30C68:
Obj89_Arrow_Sub2_Stop:
	addi_.b	#2,obj89_arrow_routine(a0)	; => Obj89_Arrow_Sub4
	move.w	d0,x_pos(a0)			; update position
	move.b	#SndID_ArrowStick,d0
	jsrto	PlaySound, JmpTo8_PlaySound
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
; ===========================================================================
; loc_30C7E:
Obj89_Arrow_Sub2_Move:
	move.w	d0,x_pos(a0)			; update position
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
; ===========================================================================
; loc_30C86:
Obj89_Arrow_Sub4:
	move.b	#0,collision_flags(a0)		; make arrow harmless
	btst	#7,status(a0)
	beq.s	+
	addi_.b	#2,obj89_arrow_routine(a0)	; => Obj89_Arrow_Sub6
+
	bsr.w	Obj89_Arrow_Platform
	lea	(Ani_obj89_a).l,a1
	jsrto	AnimateSprite, JmpTo19_AnimateSprite
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
; ===========================================================================
; loc_30CAC:
Obj89_Arrow_Sub6:
	bsr.w	Obj89_Arrow_ChkDropPlayers
	move.w	y_pos(a0),d0			; load y position...
	add.w	y_vel(a0),d0			; ...and add y velocity
	cmpi.w	#$4F0,d0			; has arrow dropped to the ground?
	bgt.w	JmpTo55_DeleteObject		; if yes, branch
	move.w	d0,y_pos(a0)			; update y position
	jmpto	DisplaySprite, JmpTo37_DisplaySprite
; ===========================================================================

    if removeJmpTos
JmpTo55_DeleteObject ; JmpTo
    endif

BranchTo_JmpTo55_DeleteObject ; BranchTo
	jmpto	DeleteObject, JmpTo55_DeleteObject
; ===========================================================================
; loc_30CCC:
Obj89_Arrow_Platform:
	tst.w	obj89_arrow_timer(a0)		; is timer set?
	bne.s	Obj89_Arrow_Platform_Decay	; if yes, branch
	move.w	#$1B,d1
	move.w	#1,d2
	move.w	#2,d3
	move.w	x_pos(a0),d4
	jsrto	PlatformObject, JmpTo8_PlatformObject
	btst	#3,status(a0)			; is Sonic standing on the arrow?
	beq.s	return_30D02			; if not, branch
	move.w	#$1F,obj89_arrow_timer(a0)	; else, set timer

; loc_30CF4:
Obj89_Arrow_Platform_Decay:
	subi_.w	#1,obj89_arrow_timer(a0)	; decrement timer
	bne.s	return_30D02			; branch, if timer hasn't expired
	move.b	#6,obj89_arrow_routine(a0)	; => Obj89_Arrow_Sub6

return_30D02:
	rts
; ===========================================================================
; loc_30D04:
Obj89_Arrow_ChkDropPlayers:
	bclr	#p1_standing_bit,status(a0)
	beq.s	+				; branch, if Sonic wasn't standing on the arrow
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	Obj89_Arrow_DropPlayer
+
	bclr	#p2_standing_bit,status(a0)
	beq.s	return_30D2A			; branch, if Tails wasn't standing on the arrow
	lea	(Sidekick).w,a1 ; a1=character

; loc_30D1E:
Obj89_Arrow_DropPlayer:
	bset	#1,status(a1)
	bclr	#3,status(a1)

return_30D2A:
	rts
; ===========================================================================
; animation script
; off_30D2C:
Ani_obj89_a:	offsetTable
		offsetTableEntry.w byte_30D30	; 0
		offsetTableEntry.w byte_30D47	; 1
byte_30D30:	dc.b   1,  4,  6,  5,  4,  6,  4,  5,  4,  6,  4,  4,  6,  5,  4,  6
		dc.b   4,  5,  4,  6,  4,$FD,  1; 16
	rev02even

byte_30D47:	dc.b  $F,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4
		dc.b   4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,$F9; 16
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj89_MapUnc_30D68:	include "mappings/sprite/obj89_a.asm"

; animation script
; off_30DC8:
Ani_obj89_b:	offsetTable
		offsetTableEntry.w byte_30DD4	;  0
		offsetTableEntry.w byte_30DEA	;  2
		offsetTableEntry.w byte_30DEE	;  4
		offsetTableEntry.w byte_30DF1	;  6
		offsetTableEntry.w byte_30DFD	;  8
		offsetTableEntry.w byte_30E00	; $A
byte_30DD4:	dc.b   7,  0,  1,$FF,  2,  3,  2,  3,  2,  3,  2,  3,$FF,  4,  4,  4
		dc.b   4,  4,  4,  4,  4,$FF; 16
	rev02even
byte_30DEA:	dc.b   1,  6,  7,$FF
	rev02even
byte_30DEE:	dc.b  $F,  9,$FF
	rev02even
byte_30DF1:	dc.b   2, $A, $A, $B, $B, $B, $B, $B, $A, $A,$FD,  2
	rev02even
byte_30DFD:	dc.b  $F,  8,$FF
	rev02even
byte_30E00:	dc.b   7,  5,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj89_MapUnc_30E04:	include "mappings/sprite/obj89_b.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo37_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo55_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo14_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
JmpTo8_PlaySound ; JmpTo
	jmp	(PlaySound).l
JmpTo22_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo19_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo3_RandomNumber ; JmpTo
	jmp	(RandomNumber).l
JmpTo8_LoadPLC ; JmpTo
	jmp	(LoadPLC).l
JmpTo5_AddPoints ; JmpTo
	jmp	(AddPoints).l
JmpTo4_PlayLevelMusic ; JmpTo
	jmp	(PlayLevelMusic).l
JmpTo4_LoadPLC_AnimalExplosion ; JmpTo
	jmp	(LoadPLC_AnimalExplosion).l
JmpTo8_PlatformObject ; JmpTo
	jmp	(PlatformObject).l
JmpTo26_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif
