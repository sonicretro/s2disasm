; ----------------------------------------------------------------------------
; Object 0E - Title screen intro animation
; ----------------------------------------------------------------------------
obj0e_counter		= objoff_2A
obj0e_array_index	= objoff_2C
obj0e_intro_complete	= objoff_2F
obj0e_music_playing	= objoff_30
obj0e_current_frame	= objoff_34

obj0e_make_sprite_position macro x,y
	dc.w	spriteScreenPositionXCentered(x),spriteScreenPositionYCentered(y)
    endm

; Sprite_12E18:
Obj0E:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj0E_Index(pc,d0.w),d1
	jmp	Obj0E_Index(pc,d1.w)
; ===========================================================================
; off_12E26: Obj0E_States:
Obj0E_Index: offsetTable
	offsetTableEntry.w Obj0E_Init		;   0
	offsetTableEntry.w Obj0E_Sonic		;   2
	offsetTableEntry.w Obj0E_Tails		;   4
	offsetTableEntry.w Obj0E_LogoTop	;   6
	offsetTableEntry.w Obj0E_FlashingStar	;   8
	offsetTableEntry.w Obj0E_SonicHand	;  $A
	offsetTableEntry.w Obj0E_FallingStar	;  $C
	offsetTableEntry.w Obj0E_MaskingSprite	;  $E
	offsetTableEntry.w Obj0E_TailsHand	; $10
; ===========================================================================
; loc_12E38:
Obj0E_Init:
	addq.b	#2,routine(a0)	; useless, because it's overwritten with the subtype below
	move.l	#Obj0E_MapUnc_136A8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_TitleSprites,0,0),art_tile(a0)
	move.b	#4,priority(a0)
	move.b	subtype(a0),routine(a0)
	bra.s	Obj0E
; ===========================================================================

Obj0E_Sonic:
	addq.w	#1,obj0e_current_frame(a0)
	cmpi.w	#288,obj0e_current_frame(a0)
	bhs.s	+
	bsr.w	TitleScreen_SetFinalState
+
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj0E_Sonic_Index(pc,d0.w),d1
	jmp	Obj0E_Sonic_Index(pc,d1.w)
; ===========================================================================
; off_12E76:
Obj0E_Sonic_Index: offsetTable
	offsetTableEntry.w Obj0E_Sonic_Init			;   0
	offsetTableEntry.w Obj0E_Sonic_FadeInAndPlayMusic	;   2
	offsetTableEntry.w Obj0E_Sonic_LoadPalette		;   4
	offsetTableEntry.w Obj0E_Sonic_Move			;   6
	offsetTableEntry.w Obj0E_Animate			;   8
	offsetTableEntry.w Obj0E_Sonic_AnimationFinished	;  $A
	offsetTableEntry.w Obj0E_Sonic_SpawnTails		;  $C
	offsetTableEntry.w Obj0E_Sonic_FlashBackground		;  $E
	offsetTableEntry.w Obj0E_Sonic_SpawnFallingStar		; $10
	offsetTableEntry.w Obj0E_Sonic_MakeStarSparkle		; $12
; ===========================================================================
; spawn more stars
Obj0E_Sonic_Init:
	addq.b	#2,routine_secondary(a0)	; Obj0E_Sonic_FadeInAndPlayMusic
	move.b	#5,mapping_frame(a0)

	move.w	#spriteScreenPositionXCentered(-16),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-16),y_pixel(a0)

	; Load flashing star object.
	lea	(IntroFlashingStar).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#8,subtype(a1)

	; Load emblem top object.
	lea	(IntroEmblemTop).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#6,subtype(a1)

	; Play twinkling sound.
	moveq	#signextendB(SndID_Sparkle),d0
	jmpto	JmpTo4_PlaySound
; ===========================================================================
; loc_12EC2:
Obj0E_Sonic_FadeInAndPlayMusic:
	; Wait.
	cmpi.w	#56,obj0e_current_frame(a0)
	bhs.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)	; Obj0E_Sonic_LoadPalette

	; Load palette-changer object.
	lea	(TitleScreenPaletteChanger3).w,a1
	move.b	#ObjID_TtlScrPalChanger,id(a1)
	move.b	#0,subtype(a1)

	; Play title screen music.
	st.b	obj0e_music_playing(a0)
	moveq	#signextendB(MusID_Title),d0
	jmpto	JmpTo4_PlayMusic
; ===========================================================================
; loc_12EE8:
Obj0E_Sonic_LoadPalette:
	; Wait.
	cmpi.w	#128,obj0e_current_frame(a0)
	bhs.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)	; Obj0E_Sonic_Move

	; Load Sonic's palette to palette line 1.
	lea	(Pal_133EC).l,a1
	lea	(Normal_palette).w,a2
	moveq	#bytesToWcnt(palette_line_size),d6
-	move.w	(a1)+,(a2)+
	dbf	d6,-
; sub_12F08: Obj0E_Sonic_LoadSky:
Obj0E_LoadMaskingSprite:
	; Load sprite mask object.
	lea	(IntroMaskingSprite).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$E,subtype(a1)
	rts
; End of function Obj0E_Sonic_LoadPalette

; ===========================================================================
; loc_12F18:
Obj0E_Sonic_Move:
	; 'd2' is used to detect when the end of the position array has been
	; reached.
	moveq	#Obj0E_Sonic_Positions_End-Obj0E_Sonic_Positions+4,d2
	lea	(Obj0E_Sonic_Positions).l,a1
; loc_12F20:
Obj0E_Move:
	; Change position every 4 frames.
	move.w	obj0e_counter(a0),d0
	addq.w	#1,d0
	move.w	d0,obj0e_counter(a0)
	andi.w	#3,d0
	bne.s	+

	; Advance index, while checking if we've reached the end of the
	; position array.
	move.w	obj0e_array_index(a0),d1
	addq.w	#4,d1
	cmp.w	d2,d1
	bhs.w	Obj0E_NextRoutineSecondary
	move.w	d1,obj0e_array_index(a0)

	; Obtain position from the array and apply it to the object.
	move.l	-4(a1,d1.w),d0
	move.w	d0,y_pixel(a0)
	swap	d0
	move.w	d0,x_pixel(a0)
+
	bra.w	DisplaySprite
; ===========================================================================
; loc_12F52:
Obj0E_Animate:
	lea	(Ani_obj0E).l,a1
	bsr.w	AnimateSprite
	bra.w	DisplaySprite
; ===========================================================================
; Obj0E_Sonic_LastFrame:
Obj0E_Sonic_AnimationFinished:
	addq.b	#2,routine_secondary(a0)	; Obj0E_Sonic_SpawnTails
	move.b	#$12,mapping_frame(a0)

	; Load Sonic's hand object.
	lea	(IntroSonicHand).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$A,subtype(a1)

	bra.w	DisplaySprite
; ===========================================================================
; loc_12F7C:
Obj0E_Sonic_SpawnTails:
	cmpi.w	#192,obj0e_current_frame(a0)
	blo.s	+
	addq.b	#2,routine_secondary(a0)	; Obj0E_Sonic_FlashBackground

	; Load Tails object.
	lea	(IntroTails).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#4,subtype(a1)
+
	bra.w	DisplaySprite
; ===========================================================================
; loc_12F9A:
Obj0E_Sonic_FlashBackground:
	cmpi.w	#288,obj0e_current_frame(a0)
	blo.s	+
	addq.b	#2,routine_secondary(a0)	; Obj0E_Sonic_SpawnFallingStar
	clr.w	obj0e_array_index(a0)
	st.b	obj0e_intro_complete(a0)

	; Fill palette line 3 with white.
	lea	(Normal_palette_line3).w,a1
	move.w	#$EEE,d0
	moveq	#bytesToWcnt(palette_line_size),d6
-	move.w	d0,(a1)+
	dbf	d6,-

	; Load palette-changer object.
	lea	(TitleScreenPaletteChanger2).w,a1
	move.b	#ObjID_TtlScrPalChanger,id(a1)
	move.b	#2,subtype(a1)

	; Load title screen menu object.
	move.b	#ObjID_TitleMenu,(TitleScreenMenu+id).w
+
	bra.w	DisplaySprite
; ===========================================================================
; loc_12FD6:
Obj0E_Sonic_SpawnFallingStar:
	; Wait a different amount of time on PAL consoles so that it's timed
	; right with the music.
	btst	#6,(Graphics_Flags).w
	beq.s	+
	cmpi.w	#400,obj0e_current_frame(a0)
	beq.s	++
	bra.w	DisplaySprite
; ===========================================================================
+
	cmpi.w	#464,obj0e_current_frame(a0)
	beq.s	+
	bra.w	DisplaySprite
; ===========================================================================
+
	; Create falling star object.
	lea	(IntroFallingStar).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$C,subtype(a1)

	addq.b	#2,routine_secondary(a0)	; Obj0E_Sonic_MakeStarSparkle

	; Delete sprite mask object.
	lea	(IntroMaskingSprite).w,a1
	bsr.w	DeleteObject2

	bra.w	DisplaySprite
; ===========================================================================
; loc_13014:
Obj0E_Sonic_MakeStarSparkle:
	; Animate the falling star every 8 frames.
	move.b	(Vint_runcount+3).w,d0
	andi.b	#7,d0
	bne.s	++

	; Advance index, while checking if we've reached the end of the
	; colour array.
	move.w	obj0e_array_index(a0),d0
	addq.w	#2,d0
	cmpi.w	#CyclingPal_TitleStar_End-CyclingPal_TitleStar,d0
	blo.s	+
	moveq	#0,d0
+
	move.w	d0,obj0e_array_index(a0)

	; Obtain colour from the array and apply it to the palette line.
	move.w	CyclingPal_TitleStar(pc,d0.w),(Normal_palette_line3+5*2).w
+
	bra.w	DisplaySprite
; ===========================================================================
; word_1303A:
CyclingPal_TitleStar:
	binclude "art/palettes/Title Star Cycle.bin"
CyclingPal_TitleStar_End

;word_13046:
Obj0E_Sonic_Positions:
	;                             X,   Y
	obj0e_make_sprite_position  -24, -32
	obj0e_make_sprite_position  -32, -48
	obj0e_make_sprite_position  -40, -64
	obj0e_make_sprite_position  -42, -74
	obj0e_make_sprite_position  -38, -82
	obj0e_make_sprite_position  -32, -86
	obj0e_make_sprite_position  -28, -87
	obj0e_make_sprite_position  -24, -88
Obj0E_Sonic_Positions_End
; ===========================================================================

Obj0E_Tails:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj0E_Tails_Index(pc,d0.w),d1
	jmp	Obj0E_Tails_Index(pc,d1.w)
; ===========================================================================
; off_13074:
Obj0E_Tails_Index: offsetTable
	offsetTableEntry.w Obj0E_Tails_Init			; 0
	offsetTableEntry.w Obj0E_Tails_Move			; 2
	offsetTableEntry.w Obj0E_Animate			; 4
	offsetTableEntry.w Obj0E_Tails_AnimationFinished	; 6
	offsetTableEntry.w BranchTo10_DisplaySprite		; 8
; ===========================================================================

Obj0E_Tails_Init:
	addq.b	#2,routine_secondary(a0)	; Obj0E_Tails_Move
    if fixBugs
	; Tails' priority is never set, even though it is set in
	; 'TitleScreen_SetFinalState', suggesting that it was meant to be.
	; This causes Tails to be layered behind Sonic instead of in front of
	; him.
	move.b	#3,priority(a0)
    endif
	move.w	#spriteScreenPositionXCentered(-72),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-24),y_pixel(a0)
	move.b	#1,anim(a0)
	rts
; ===========================================================================
; loc_13096:
Obj0E_Tails_Move:
	moveq	#Obj0E_Tails_Positions_End-Obj0E_Tails_Positions+4,d2
	lea	(Obj0E_Tails_Positions).l,a1
	bra.w	Obj0E_Move
; ===========================================================================
; loc_130A2:
Obj0E_Tails_AnimationFinished:
	addq.b	#2,routine_secondary(a0)	; BranchTo10_DisplaySprite

	; Load Tails' hand object.
	lea	(IntroTailsHand).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$10,subtype(a1)

BranchTo10_DisplaySprite ; BranchTo
	bra.w	DisplaySprite
; ===========================================================================
; word_130B8:
Obj0E_Tails_Positions:
	;                             X,   Y
	obj0e_make_sprite_position  -73, -40
	obj0e_make_sprite_position  -77, -56
	obj0e_make_sprite_position  -82, -68
	obj0e_make_sprite_position  -84, -74
	obj0e_make_sprite_position  -86, -78
	obj0e_make_sprite_position  -87, -79
	obj0e_make_sprite_position  -88, -80
Obj0E_Tails_Positions_End
; ===========================================================================

Obj0E_LogoTop:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj0E_LogoTop_Index(pc,d0.w),d1
	jmp	Obj0E_LogoTop_Index(pc,d1.w)
; ===========================================================================
; off_130E2:
Obj0E_LogoTop_Index: offsetTable
	offsetTableEntry.w Obj0E_LogoTop_Init		; 0
	offsetTableEntry.w BranchTo11_DisplaySprite	; 2
; ===========================================================================

Obj0E_LogoTop_Init:
	; Don't show the trademark symbol on Japanese consoles.
	move.b	#$B,mapping_frame(a0)
	tst.b	(Graphics_Flags).w
	bmi.s	+
	move.b	#$A,mapping_frame(a0)
+
	move.b	#2,priority(a0)
	move.w	#spriteScreenPositionXCentered(0),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-8),y_pixel(a0)
; loc_1310A:
Obj0E_NextRoutineSecondary:
	addq.b	#2,routine_secondary(a0)	; BranchTo11_DisplaySprite

BranchTo11_DisplaySprite ; BranchTo
	bra.w	DisplaySprite
; ===========================================================================
; Obj0E_SkyPiece:
Obj0E_MaskingSprite:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj0E_MaskingSprite_Index(pc,d0.w),d1
	jmp	Obj0E_MaskingSprite_Index(pc,d1.w)
; ===========================================================================
; off_13120:
Obj0E_MaskingSprite_Index: offsetTable
	offsetTableEntry.w Obj0E_MaskingSprite_Init	; 0
	offsetTableEntry.w BranchTo12_DisplaySprite	; 2
; ===========================================================================

Obj0E_MaskingSprite_Init:
	addq.b	#2,routine_secondary(a0)	; BranchTo12_DisplaySprite
	move.w	#make_art_tile(ArtTile_ArtNem_Title,0,0),art_tile(a0)
	move.b	#$11,mapping_frame(a0)
	move.b	#2,priority(a0)
	; Masking sprites normally must have an X coordinate of 0. I don't
	; know why it isn't set to that here, but it is corrected to 0 in
	; 'TitleScreen_Loop'.
	move.w	#spriteScreenPositionXCentered(-32),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(0),y_pixel(a0)

BranchTo12_DisplaySprite ; BranchTo
	bra.w	DisplaySprite
; ===========================================================================
; Obj0E_LargeStar:
Obj0E_FlashingStar:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj0E_FlashingStar_Index(pc,d0.w),d1
	jmp	Obj0E_FlashingStar_Index(pc,d1.w)
; ===========================================================================
; off_13158:
Obj0E_FlashingStar_Index: offsetTable
	offsetTableEntry.w Obj0E_FlashingStar_Init	; 0
	offsetTableEntry.w Obj0E_Animate		; 2
	offsetTableEntry.w Obj0E_FlashingStar_Wait	; 4
	offsetTableEntry.w Obj0E_FlashingStar_Move	; 6
; ===========================================================================

Obj0E_FlashingStar_Init:
	addq.b	#2,routine_secondary(a0)	; Obj0E_Animate
	move.b	#$C,mapping_frame(a0)
	ori.w	#high_priority,art_tile(a0)
	move.b	#2,anim(a0)
	move.b	#1,priority(a0)
	move.w	#spriteScreenPositionXCentered(-32),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-72),y_pixel(a0)
	move.w	#4,obj0e_counter(a0)
	rts
; ===========================================================================
; loc_13190:
Obj0E_FlashingStar_Wait:
	subq.w	#1,obj0e_counter(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)	; Obj0E_FlashingStar_Move
	rts
; ===========================================================================
; loc_1319E:
Obj0E_FlashingStar_Move:
	move.b	#2,routine_secondary(a0)	; Obj0E_Animate
	move.b	#0,anim_frame(a0)
	move.b	#0,anim_frame_duration(a0)
	move.w	#6,obj0e_counter(a0)

	; Advance index, while checking if we've reached the end of the
	; position array.
	move.w	obj0e_array_index(a0),d0
	addq.w	#4,d0
	cmpi.w	#Obj0E_FlashingStar_Positions_End-Obj0E_FlashingStar_Positions+4,d0
	bhs.w	DeleteObject
	move.w	d0,obj0e_array_index(a0)

	; Obtain position from the array and apply it to the object.
	move.l	Obj0E_FlashingStar_Positions-4(pc,d0.w),d0
	move.w	d0,y_pixel(a0)
	swap	d0
	move.w	d0,x_pixel(a0)

	; Play twinkling sound.
	moveq	#signextendB(SndID_Sparkle),d0
	jmpto	JmpTo4_PlaySound
; ===========================================================================
; word_131DC:
Obj0E_FlashingStar_Positions:
	;                             X,   Y
	obj0e_make_sprite_position  -70,   2
	obj0e_make_sprite_position   80,   8
	obj0e_make_sprite_position   18,  65
	obj0e_make_sprite_position  126, -78
	obj0e_make_sprite_position  -96, -13
	obj0e_make_sprite_position   96, -16
	obj0e_make_sprite_position  -19,  75
	obj0e_make_sprite_position  -96, -69
	obj0e_make_sprite_position   69,  23
Obj0E_FlashingStar_Positions_End
; ===========================================================================

Obj0E_SonicHand:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj0E_SonicHand_Index(pc,d0.w),d1
	jmp	Obj0E_SonicHand_Index(pc,d1.w)
; ===========================================================================
; off_1320E:
Obj0E_SonicHand_Index: offsetTable
	offsetTableEntry.w Obj0E_SonicHand_Init		; 0
	offsetTableEntry.w Obj0E_SonicHand_Move		; 2
	offsetTableEntry.w BranchTo13_DisplaySprite	; 4
; ===========================================================================

Obj0E_SonicHand_Init:
	addq.b	#2,routine_secondary(a0)	; Obj0E_SonicHand_Move
	move.b	#9,mapping_frame(a0)
    if fixBugs
	; This matches 'TitleScreen_SetFinalState'.
	move.b	#2,priority(a0)
    else
	; This is inconsistent with 'TitleScreen_SetFinalState'.
	move.b	#3,priority(a0)
    endif
	move.w	#spriteScreenPositionXCentered(37),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-49),y_pixel(a0)

BranchTo13_DisplaySprite ; BranchTo
	bra.w	DisplaySprite
; ===========================================================================
; loc_13234:
Obj0E_SonicHand_Move:
	moveq	#Obj0E_SonicHand_Positions_End-Obj0E_SonicHand_Positions+4,d2
	lea	(Obj0E_SonicHand_Positions).l,a1
	bra.w	Obj0E_Move
; ===========================================================================
; word_13240:
Obj0E_SonicHand_Positions:
	;                            X,   Y
	obj0e_make_sprite_position  35, -47
	obj0e_make_sprite_position  32, -46
	obj0e_make_sprite_position  33, -47
Obj0E_SonicHand_Positions_End
; ===========================================================================

Obj0E_TailsHand:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj0E_TailsHand_Index(pc,d0.w),d1
	jmp	Obj0E_TailsHand_Index(pc,d1.w)
; ===========================================================================
; off_1325A:
Obj0E_TailsHand_Index: offsetTable
	offsetTableEntry.w Obj0E_TailsHand_Init		; 0
	offsetTableEntry.w Obj0E_TailsHand_Move		; 2
	offsetTableEntry.w BranchTo14_DisplaySprite	; 4
; ===========================================================================

Obj0E_TailsHand_Init:
	addq.b	#2,routine_secondary(a0)	; Obj0E_TailsHand_Move
	move.b	#$13,mapping_frame(a0)
    if fixBugs
	; This matches 'TitleScreen_SetFinalState'.
	move.b	#2,priority(a0)
    else
	; This is inconsistent with 'TitleScreen_SetFinalState', and causes
	; the hand to be layered behind Tails if his priority is fixed.
	move.b	#3,priority(a0)
    endif
	move.w	#spriteScreenPositionXCentered(-17),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-27),y_pixel(a0)

BranchTo14_DisplaySprite ; BranchTo
	bra.w	DisplaySprite
; ===========================================================================
; loc_13280:
Obj0E_TailsHand_Move:
	moveq	#Obj0E_TailsHand_Positions_End-Obj0E_TailsHand_Positions+4,d2
	lea	(Obj0E_TailsHand_Positions).l,a1
	bra.w	Obj0E_Move
; ===========================================================================
; word_1328C:
Obj0E_TailsHand_Positions:
	;                             X,   Y
	obj0e_make_sprite_position  -20, -32
	obj0e_make_sprite_position  -19, -31
Obj0E_TailsHand_Positions_End
; ===========================================================================
; Obj0E_SmallStar:
Obj0E_FallingStar:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj0E_FallingStar_Index(pc,d0.w),d1
	jmp	Obj0E_FallingStar_Index(pc,d1.w)
; ===========================================================================
; off_132A2:
Obj0E_FallingStar_Index: offsetTable
	offsetTableEntry.w Obj0E_FallingStar_Init	; 0
	offsetTableEntry.w Obj0E_FallingStar_Main	; 2
; ===========================================================================
; Obj0E_SmallStar_Init:
Obj0E_FallingStar_Init:
	addq.b	#2,routine_secondary(a0)	; Obj0E_FallingStar_Main
	move.b	#$C,mapping_frame(a0)
	move.b	#5,priority(a0)
	move.w	#spriteScreenPositionXCentered(80),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-112),y_pixel(a0)
	move.b	#3,anim(a0)
	move.w	#140,obj0e_counter(a0)
	bra.w	DisplaySprite
; ===========================================================================
; loc_132D2: Obj0E_SmallStar_Main:
Obj0E_FallingStar_Main:
	subq.w	#1,obj0e_counter(a0)
	bmi.w	DeleteObject

	; Make the star fall.
	subq.w	#2,x_pixel(a0)
	addq.w	#1,y_pixel(a0)

	lea	(Ani_obj0E).l,a1
	bsr.w	AnimateSprite
	bra.w	DisplaySprite
