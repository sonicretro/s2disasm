; ===========================================================================
; ----------------------------------------------------------------------------
; Object 04 - Surface of the water - water surface
; ----------------------------------------------------------------------------

Obj04:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj04_Index(pc,d0.w),d1
	jmp	Obj04_Index(pc,d1.w)
; ===========================================================================
; off_208EA:
Obj04_Index:	offsetTable
		offsetTableEntry.w Obj04_Init		; 0
		offsetTableEntry.w Obj04_Action		; 2
		offsetTableEntry.w Obj04_Action2	; 4
; ===========================================================================
; loc_208F0: Obj04_Main:
Obj04_Init:
	addq.b	#2,routine(a0) ; => Obj04_Action
	move.l	#Obj04_MapUnc_20A0E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_WaterSurface,0,1),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo12_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$80,width_pixels(a0)
	move.w	x_pos(a0),objoff_30(a0)
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	Obj04_Action
	addq.b	#2,routine(a0) ; Obj04_Action2
	move.l	#Obj04_MapUnc_20AFE,mappings(a0)
	bra.w	Obj04_Action2
; ===========================================================================
; loc_20930:
Obj04_Action:
	move.w	(Water_Level_1).w,d1
	move.w	d1,y_pos(a0)
	tst.b	objoff_32(a0)
	bne.s	Obj04_Animate
    if fixBugs
	move.b	(Ctrl_1_Press).w,d0 ; is Start button pressed?
	or.b	(Ctrl_2_Press).w,d0 ; (either player)
	andi.b	#button_start_mask,d0
    else
	; This only checks player 1, causing the water to look weird if
	; player 2 pauses the game instead.
	btst	#button_start,(Ctrl_1_Press).w	; is Start button pressed?
    endif
	beq.s	loc_20962		; if not, branch
	addq.b	#3,mapping_frame(a0)	; use different frames
	move.b	#1,objoff_32(a0)	; stop animation
	bra.s	Obj04_Display
; ===========================================================================
; loc_20952:
Obj04_Animate:
	tst.w	(Game_paused).w		; is the game paused?
	bne.s	Obj04_Display		; if yes, branch
	move.b	#0,objoff_32(a0)	; resume animation
	subq.b	#3,mapping_frame(a0)	; use normal frames

loc_20962:

    if ~~fixBugs
Obj04_Display:
    endif
	; This code should be skipped when the game is paused, but is isn't.
	; This causes the wrong sprite to display when the game is paused.
	lea	(Anim_obj04).l,a1
	moveq	#0,d1
	move.b	anim_frame(a0),d1
	move.b	(a1,d1.w),mapping_frame(a0)
	addq.b	#1,anim_frame(a0)
	andi.b	#$3F,anim_frame(a0)

    if fixBugs
Obj04_Display:
    endif
	jmpto	DisplaySprite, JmpTo10_DisplaySprite
; ===========================================================================
; water sprite animation 'script' (custom format for this object)
; byte_20982:
Anim_obj04:
	dc.b 0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1
	dc.b 1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2
	dc.b 2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1
	dc.b 1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0
	even
; ===========================================================================
; loc_209C2:
Obj04_Action2:
	move.w	(Water_Level_1).w,d1
	move.w	d1,y_pos(a0)
	tst.b	objoff_32(a0)
	bne.s	Obj04_Animate2
    if fixBugs
	move.b	(Ctrl_1_Press).w,d0 ; is Start button pressed?
	or.b	(Ctrl_2_Press).w,d0 ; (either player)
	andi.b	#button_start_mask,d0
    else
	; This only checks player 1, causing the water to look weird if
	; player 2 pauses the game instead.
	btst	#button_start,(Ctrl_1_Press).w	; is Start button pressed?
    endif
	beq.s	loc_209F4		; if not, branch
	addq.b	#2,mapping_frame(a0)    ; use different frames
	move.b	#1,objoff_32(a0)		; stop animation
	bra.s	BranchTo_JmpTo10_DisplaySprite
; ===========================================================================
; loc_209E4:
Obj04_Animate2:
	tst.w	(Game_paused).w	; is the game paused?
	bne.s	BranchTo_JmpTo10_DisplaySprite	; if yes, branch
	move.b	#0,objoff_32(a0)	; resume animation
	subq.b	#2,mapping_frame(a0)	; use normal frames

loc_209F4:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	BranchTo_JmpTo10_DisplaySprite
	move.b	#5,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	andi.b	#1,mapping_frame(a0)

BranchTo_JmpTo10_DisplaySprite ; BranchTo
	jmpto	DisplaySprite, JmpTo10_DisplaySprite
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj04_MapUnc_20A0E:	include "mappings/sprite/obj04_a.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj04_MapUnc_20AFE:	include "mappings/sprite/obj04_b.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 49 - Waterfall from EHZ
; ----------------------------------------------------------------------------
; Sprite_20B9E:
Obj49:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj49_Index(pc,d0.w),d1
	jmp	Obj49_Index(pc,d1.w)
; ===========================================================================
; off_20BAC:
Obj49_Index:	offsetTable
		offsetTableEntry.w Obj49_Init	; 0
		offsetTableEntry.w Obj49_ChkDel	; 2
; ===========================================================================
; loc_20BB0: Obj49_Main:
Obj49_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj49_MapUnc_20C50,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Waterfall,1,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo12_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.w	x_pos(a0),objoff_30(a0)
	move.b	#0,priority(a0)
	move.b	#$80,y_radius(a0)
	bset	#4,render_flags(a0)
; loc_20BEA:
Obj49_ChkDel:
	tst.w	(Two_player_mode).w
	bne.s	+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo18_DeleteObject
+
	move.w	x_pos(a0),d1
	move.w	d1,d2
	subi.w	#$40,d1
	addi.w	#$40,d2
	move.b	subtype(a0),d3
	move.b	#0,mapping_frame(a0)
	move.w	(MainCharacter+x_pos).w,d0
	cmp.w	d1,d0
	blo.s	loc_20C36
	cmp.w	d2,d0
	bhs.s	loc_20C36
	move.b	#1,mapping_frame(a0)
	add.b	d3,mapping_frame(a0)
	jmpto	DisplaySprite, JmpTo10_DisplaySprite
; ===========================================================================

loc_20C36:
	move.w	(Sidekick+x_pos).w,d0
	cmp.w	d1,d0
	blo.s	Obj49_Display
	cmp.w	d2,d0
	bhs.s	Obj49_Display
	move.b	#1,mapping_frame(a0)
; loc_20C48:
Obj49_Display:
	add.b	d3,mapping_frame(a0)
	jmpto	DisplaySprite, JmpTo10_DisplaySprite
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj49_MapUnc_20C50:	include "mappings/sprite/obj49.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 31 - Lava collision marker
; ----------------------------------------------------------------------------
; Sprite_20DEC:
Obj31:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj31_Index(pc,d0.w),d1
	jmp	Obj31_Index(pc,d1.w)
; ===========================================================================
; off_20DFA: Obj31_States:
Obj31_Index:	offsetTable
		offsetTableEntry.w Obj31_Init	; 0
		offsetTableEntry.w Obj31_Main	; 2
; ---------------------------------------------------------------------------
; byte_20DFE:
Obj31_CollisionFlagsBySubtype:
	dc.b $96	; 0
	dc.b $94	; 1
	dc.b $95	; 2
	even
; ===========================================================================
; loc_20E02:
Obj31_Init:
	addq.b	#2,routine(a0) ; => Obj31_Main
	moveq	#0,d0
	move.b	subtype(a0),d0
	move.b	Obj31_CollisionFlagsBySubtype(pc,d0.w),collision_flags(a0)
    if fixBugs
	move.l	#Obj31_MapUnc_20E74,mappings(a0)
    else
	; This dumb code is a workaround for the bug below.
	move.l	#Obj31_MapUnc_20E6C,mappings(a0)
	tst.w	(Debug_placement_mode).w
	beq.s	+
	move.l	#Obj31_MapUnc_20E74,mappings(a0)
+
    endif
	move.w	#make_art_tile(ArtTile_ArtNem_Powerups,0,1),art_tile(a0)
    if fixBugs
	move.b	#4,render_flags(a0)
    else
	; The high bit of 'render_flags' should not be set here: this causes
	; this object to become visible when the player dies, because of how
	; 'RunObjectsWhenPlayerIsDead' works.
	move.b	#$84,render_flags(a0)
    endif
	move.b	#$80,width_pixels(a0)
	move.b	#4,priority(a0)
	move.b	subtype(a0),mapping_frame(a0)

; loc_20E46:
Obj31_Main:
	tst.w	(Two_player_mode).w
	bne.s	+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo18_DeleteObject
+
	tst.w	(Debug_placement_mode).w
	beq.s	+	; rts
	jsrto	DisplaySprite, JmpTo10_DisplaySprite
+
	rts
; ===========================================================================
    if ~~fixBugs
; -------------------------------------------------------------------------------
; sprite non-mappings
; -------------------------------------------------------------------------------
Obj31_MapUnc_20E6C:	include "mappings/sprite/obj31_a.asm"
    endif
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj31_MapUnc_20E74:	include "mappings/sprite/obj31_b.asm"
; ===========================================================================




; ----------------------------------------------------------------------------
; Object 74 - Invisible solid block
; ----------------------------------------------------------------------------
; Sprite_20EE0:
Obj74:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj74_Index(pc,d0.w),d1
	jmp	Obj74_Index(pc,d1.w)
; ===========================================================================
; off_20EEE: Obj74_States:
Obj74_Index:	offsetTable
		offsetTableEntry.w Obj74_Init	; 0
		offsetTableEntry.w Obj74_Main	; 2
; ===========================================================================
; loc_20EF2:
Obj74_Init:
	addq.b	#2,routine(a0) ; => Obj74_Main
	move.l	#Obj74_MapUnc_20F66,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Powerups,0,1),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo12_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	subtype(a0),d0
	move.b	d0,d1
	andi.w	#$F0,d0
	addi.w	#$10,d0
	lsr.w	#1,d0
	move.b	d0,width_pixels(a0)
	andi.w	#$F,d1
	addq.w	#1,d1
	lsl.w	#3,d1
	move.b	d1,y_radius(a0)

; loc_20F2E:
Obj74_Main:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	x_pos(a0),d4
	bsr.w	SolidObject_Always
	tst.w	(Two_player_mode).w
	bne.s	+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo18_DeleteObject
    if gameRevision=0
    ; this object was visible with debug mode in REV00
+
	tst.w	(Debug_placement_mode).w
	beq.s	+	; rts
	jmp	(DisplaySprite).l
    endif
+
	rts
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj74_MapUnc_20F66:	include "mappings/sprite/obj74.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 7C - Big pylon in foreground of CPZ
; ----------------------------------------------------------------------------
; Sprite_20FD2:
Obj7C:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj7C_Index(pc,d0.w),d1
	jmp	Obj7C_Index(pc,d1.w)
; ===========================================================================
; off_20FE0: Obj7C_States:
Obj7C_Index:	offsetTable
		offsetTableEntry.w Obj7C_Init	; 0
		offsetTableEntry.w Obj7C_Main	; 2
; ===========================================================================
; loc_20FE4:
Obj7C_Init:
	addq.b	#2,routine(a0) ; => Obj7C_Main
	move.l	#Obj7C_MapUnc_2103C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZMetalThings,2,1),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo12_Adjust2PArtPointer
	move.b	#$10,width_pixels(a0)
	move.b	#7,priority(a0)

; loc_21006:
Obj7C_Main:
	move.w	(Camera_X_pos).w,d1
	andi.w	#$3FF,d1
	cmpi.w	#$2E0,d1
	bhs.s	+	; rts
	asr.w	#1,d1
	move.w	d1,d0
	asr.w	#1,d1
	add.w	d1,d0
	neg.w	d0
	move.w	d0,x_pixel(a0)
	move.w	(Camera_Y_pos).w,d1
	asr.w	#1,d1
	andi.w	#$3F,d1
	neg.w	d1
	addi.w	#$100,d1
	move.w	d1,y_pixel(a0)
	jmpto	DisplaySprite, JmpTo10_DisplaySprite
; ---------------------------------------------------------------------------
+	rts
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj7C_MapUnc_2103C:	include "mappings/sprite/obj7C.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 27 - An explosion, giving off an animal and 100 points
; ----------------------------------------------------------------------------
; Sprite_21088:
Obj27:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj27_Index(pc,d0.w),d1
	jmp	Obj27_Index(pc,d1.w)
; ===========================================================================
; off_21096: Obj27_States:
Obj27_Index:	offsetTable
		offsetTableEntry.w Obj27_InitWithAnimal	; 0
		offsetTableEntry.w Obj27_Init		; 2
		offsetTableEntry.w Obj27_Main		; 4
; ===========================================================================
; loc_2109C: Obj27_Init:
Obj27_InitWithAnimal:
	addq.b	#2,routine(a0) ; => Obj27_Init
	jsrto	AllocateObject, JmpTo2_AllocateObject
	bne.s	Obj27_Init
	_move.b	#ObjID_Animal,id(a1) ; load obj28 (Animal and 100 points)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	objoff_3E(a0),objoff_3E(a1)	; Set by Touch_KillEnemy

; loc_210BE: Obj27_Init2:
Obj27_Init:
	addq.b	#2,routine(a0) ; => Obj27_Main
	move.l	#Obj27_MapUnc_21120,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Explosion,0,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo12_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#1,priority(a0)
	move.b	#0,collision_flags(a0)
	move.b	#$C,width_pixels(a0)
	move.b	#3,anim_frame_duration(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#SndID_Explosion,d0
	jsr	(PlaySound).l

; loc_21102:
Obj27_Main:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#5,mapping_frame(a0)
	beq.w	JmpTo18_DeleteObject
+
	jmpto	DisplaySprite, JmpTo10_DisplaySprite
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj27_MapUnc_21120:	include "mappings/sprite/obj27.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 84 - Pinball mode enable/disable
; (used in Casino Night Zone to determine when Sonic should stay in a ball)
; ----------------------------------------------------------------------------
; Sprite_2115C:
Obj84:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj84_Index(pc,d0.w),d1
	jsr	Obj84_Index(pc,d1.w)
	jmp	(MarkObjGone3).l
; ===========================================================================
; off_21170: Obj84_States:
Obj84_Index:	offsetTable
		offsetTableEntry.w Obj84_Init	; 0
		offsetTableEntry.w Obj84_MainX	; 2
		offsetTableEntry.w Obj84_MainY	; 4
; ===========================================================================
; loc_21176:
Obj84_Init:
	addq.b	#2,routine(a0) ; => Obj84_MainX
	move.l	#Obj03_MapUnc_1FFB8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,0,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo12_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#5,priority(a0)
	move.b	subtype(a0),d0
	btst	#2,d0
	beq.s	Obj84_Init_CheckX
	addq.b	#2,routine(a0) ; => Obj84_MainY
	andi.w	#7,d0
	move.b	d0,mapping_frame(a0)
	andi.w	#3,d0
	add.w	d0,d0
	move.w	word_211E8(pc,d0.w),objoff_32(a0)
	move.w	y_pos(a0),d1
	lea	(MainCharacter).w,a1 ; a1=character
	cmp.w	y_pos(a1),d1
	bhs.s	+
	move.b	#1,objoff_34(a0)
+
	lea	(Sidekick).w,a1 ; a1=character
	cmp.w	y_pos(a1),d1
	bhs.s	+
	move.b	#1,objoff_35(a0)
+
	bra.w	Obj84_MainY
; ===========================================================================
word_211E8:
	dc.w   $20
	dc.w   $40	; 1
	dc.w   $80	; 2
	dc.w  $100	; 3
; ===========================================================================
; loc_211F0:
Obj84_Init_CheckX:
	andi.w	#3,d0
	move.b	d0,mapping_frame(a0)
	add.w	d0,d0
	move.w	word_211E8(pc,d0.w),objoff_32(a0)
	move.w	x_pos(a0),d1
	lea	(MainCharacter).w,a1 ; a1=character
	cmp.w	x_pos(a1),d1
	bhs.s	+
	move.b	#1,objoff_34(a0)
+
	lea	(Sidekick).w,a1 ; a1=character
	cmp.w	x_pos(a1),d1
	bhs.s	Obj84_MainX
	move.b	#1,objoff_35(a0)

; loc_21224:
Obj84_MainX:

	tst.w	(Debug_placement_mode).w
	bne.s	return_21284
	move.w	x_pos(a0),d1
	lea	objoff_34(a0),a2 ; a2=object
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	+
	lea	(Sidekick).w,a1 ; a1=character
	cmpi.w	#4,(Tails_CPU_routine).w	; TailsCPU_Flying
	beq.s	return_21284

+	tst.b	(a2)+
	bne.s	Obj84_MainX_Alt
	cmp.w	x_pos(a1),d1
	bhi.s	return_21284
	move.b	#1,-1(a2)
	move.w	y_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	y_pos(a1),d4
	cmp.w	d2,d4
	blo.s	return_21284
	cmp.w	d3,d4
	bhs.s	return_21284
	btst	#0,render_flags(a0)
	bne.s	+
	move.b	#1,pinball_mode(a1) ; enable must-roll "pinball mode"
	bra.s	loc_212C4
; ---------------------------------------------------------------------------
+	move.b	#0,pinball_mode(a1) ; disable pinball mode

return_21284:
	rts
; ===========================================================================
; loc_21286:
Obj84_MainX_Alt:
	cmp.w	x_pos(a1),d1
	bls.s	return_21284
	move.b	#0,-1(a2)
	move.w	y_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	y_pos(a1),d4
	cmp.w	d2,d4
	blo.s	return_21284
	cmp.w	d3,d4
	bhs.s	return_21284
	btst	#0,render_flags(a0)
	beq.s	+
	move.b	#1,pinball_mode(a1)
	bra.s	loc_212C4
; ---------------------------------------------------------------------------
+	move.b	#0,pinball_mode(a1)
	rts
; ===========================================================================

loc_212C4:
	btst	#2,status(a1)
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+	bset	#2,status(a1)
	move.b	#$E,y_radius(a1)
	move.b	#7,x_radius(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	addq.w	#5,y_pos(a1)
	move.w	#SndID_Roll,d0
	jsr	(PlaySound).l
	rts

; ===========================================================================
; loc_212F6:
Obj84_MainY:

	tst.w	(Debug_placement_mode).w
	bne.s	return_21350
	move.w	y_pos(a0),d1
	lea	objoff_34(a0),a2 ; a2=object
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	+
	lea	(Sidekick).w,a1 ; a1=character
+
	tst.b	(a2)+
	bne.s	Obj84_MainY_Alt
	cmp.w	y_pos(a1),d1
	bhi.s	return_21350
	move.b	#1,-1(a2)
	move.w	x_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	x_pos(a1),d4
	cmp.w	d2,d4
	blo.s	return_21350
	cmp.w	d3,d4
	bhs.s	return_21350
	btst	#0,render_flags(a0)
	bne.s	+
	move.b	#1,pinball_mode(a1)
	bra.w	loc_212C4
; ---------------------------------------------------------------------------
+	move.b	#0,pinball_mode(a1)

return_21350:
	rts
; ===========================================================================
; loc_21352:
Obj84_MainY_Alt:
	cmp.w	y_pos(a1),d1
	bls.s	return_21350
	move.b	#0,-1(a2)
	move.w	x_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	x_pos(a1),d4
	cmp.w	d2,d4
	blo.s	return_21350
	cmp.w	d3,d4
	bhs.s	return_21350
	btst	#0,render_flags(a0)
	beq.s	+
	move.b	#1,pinball_mode(a1)
	bra.w	loc_212C4
; ---------------------------------------------------------------------------
+	move.b	#0,pinball_mode(a1)
	rts




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 8B - Cycling palette switcher from Wing Fortress Zone
; ----------------------------------------------------------------------------
; Sprite_21392:
Obj8B:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj8B_Index(pc,d0.w),d1
	jsr	Obj8B_Index(pc,d1.w)
	jmp	(MarkObjGone3).l
; ===========================================================================
; off_213A6:
Obj8B_Index:	offsetTable
		offsetTableEntry.w Obj8B_Init	; 0
		offsetTableEntry.w Obj8B_Main	; 2
; ===========================================================================
word_213AA:
	dc.w   $20
	dc.w   $40	; 1
	dc.w   $80	; 2
	dc.w  $100	; 3
; ===========================================================================
; loc_213B2:
Obj8B_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj03_MapUnc_1FFB8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,0,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo12_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#5,priority(a0)
	move.b	subtype(a0),d0
	andi.w	#3,d0
	move.b	d0,mapping_frame(a0)
	add.w	d0,d0
	move.w	word_213AA(pc,d0.w),objoff_32(a0)
	move.w	x_pos(a0),d1
	lea	(MainCharacter).w,a1 ; a1=character
	cmp.w	x_pos(a1),d1
	bhs.s	loc_21402
	move.b	#1,objoff_34(a0)

loc_21402:
	lea	(Sidekick).w,a1 ; a1=character
	cmp.w	x_pos(a1),d1
	bhs.s	Obj8B_Main
	move.b	#1,objoff_35(a0)
; loc_21412:
Obj8B_Main:
	tst.w	(Debug_placement_mode).w
	bne.s	return_2146A
	move.w	x_pos(a0),d1
	lea	objoff_34(a0),a2 ; a2=object
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_2142A
	lea	(Sidekick).w,a1 ; a1=character

loc_2142A:
	tst.b	(a2)+
	bne.s	loc_2146C
	cmp.w	x_pos(a1),d1
	bhi.s	return_2146A
	move.b	#1,-1(a2)
	move.w	y_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	y_pos(a1),d4
	cmp.w	d2,d4
	blo.s	return_2146A
	cmp.w	d3,d4
	bhs.s	return_2146A
	btst	#0,render_flags(a0)
	bne.s	+
	move.b	#1,(WFZ_SCZ_Fire_Toggle).w
	rts
; ---------------------------------------------------------------------------
+	move.b	#0,(WFZ_SCZ_Fire_Toggle).w

return_2146A:
	rts
; ===========================================================================

loc_2146C:
	cmp.w	x_pos(a1),d1
	bls.s	return_2146A
	move.b	#0,-1(a2)
	move.w	y_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	y_pos(a1),d4
	cmp.w	d2,d4
	blo.s	return_2146A
	cmp.w	d3,d4
	bhs.s	return_2146A
	btst	#0,render_flags(a0)
	beq.s	+
	move.b	#1,(WFZ_SCZ_Fire_Toggle).w
	rts
; ---------------------------------------------------------------------------
+	move.b	#0,(WFZ_SCZ_Fire_Toggle).w
	rts
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
; loc_214AC:
JmpTo10_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo18_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo2_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
JmpTo12_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    else
JmpTo18_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
