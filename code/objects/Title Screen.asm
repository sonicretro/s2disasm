; ----------------------------------------------------------------------------
; Object 0E - Title screen intro animation
; ----------------------------------------------------------------------------
obj0e_counter		= objoff_2A
obj0e_array_index	= objoff_2C
obj0e_intro_complete	= objoff_2F
obj0e_music_playing	= objoff_30
obj0e_current_frame	= objoff_34

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

	move.w	#128+144,x_pixel(a0)
	move.w	#128+96,y_pixel(a0)

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
	jmpto	PlaySound, JmpTo4_PlaySound
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
	jmpto	PlayMusic, JmpTo4_PlayMusic
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
	;           X,      Y
	dc.w  128+136, 128+80
	dc.w  128+128, 128+64
	dc.w  128+120, 128+48
	dc.w  128+118, 128+38
	dc.w  128+122, 128+30
	dc.w  128+128, 128+26
	dc.w  128+132, 128+25
	dc.w  128+136, 128+24
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
	move.w	#128+88,x_pixel(a0)
	move.w	#128+88,y_pixel(a0)
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

BranchTo10_DisplaySprite
	bra.w	DisplaySprite
; ===========================================================================
; word_130B8:
Obj0E_Tails_Positions:
	;           X,      Y
	dc.w   128+87, 128+72
	dc.w   128+83, 128+56
	dc.w   128+78, 128+44
	dc.w   128+76, 128+38
	dc.w   128+74, 128+34
	dc.w   128+73, 128+33
	dc.w   128+72, 128+32
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
	move.w	#128+320/2,x_pixel(a0)
	move.w	#128+104,y_pixel(a0)
; loc_1310A:
Obj0E_NextRoutineSecondary:
	addq.b	#2,routine_secondary(a0)	; BranchTo11_DisplaySprite

BranchTo11_DisplaySprite
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
	move.w	#128+128,x_pixel(a0)
	move.w	#128+224/2,y_pixel(a0)

BranchTo12_DisplaySprite
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
	move.w	#128+128,x_pixel(a0)
	move.w	#128+40,y_pixel(a0)
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
	jmpto	PlaySound, JmpTo4_PlaySound
; ===========================================================================
; word_131DC:
Obj0E_FlashingStar_Positions:
	dc.w  128+90,  128+114
	dc.w  128+240, 128+120
	dc.w  128+178, 128+177
	dc.w  128+286, 128+34
	dc.w  128+64,  128+99
	dc.w  128+256, 128+96
	dc.w  128+141, 128+187
	dc.w  128+64,  128+43
	dc.w  128+229, 128+135
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
	move.w	#128+197,x_pixel(a0)
	move.w	#128+63,y_pixel(a0)

BranchTo13_DisplaySprite
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
	dc.w  128+195, 128+65
	dc.w  128+192, 128+66
	dc.w  128+193, 128+65
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
	; the hand to be layered behind Tails is his priority is fixed.
	move.b	#3,priority(a0)
    endif
	move.w	#128+143,x_pixel(a0)
	move.w	#128+85,y_pixel(a0)

BranchTo14_DisplaySprite
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
	dc.w  128+140, 128+80
	dc.w  128+141, 128+81
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
	move.w	#128+240,x_pixel(a0)
	move.w	#128+0,y_pixel(a0)
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
; ===========================================================================
; ----------------------------------------------------------------------------
; Object C9 - "Palette changing handler" from title screen
; ----------------------------------------------------------------------------
ttlscrpalchanger_fadein_time_left = objoff_30
ttlscrpalchanger_fadein_time = objoff_31
ttlscrpalchanger_fadein_amount = objoff_32
ttlscrpalchanger_start_offset = objoff_34
ttlscrpalchanger_length = objoff_36
ttlscrpalchanger_codeptr = objoff_3A

; Sprite_132F0:
ObjC9:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC9_Index(pc,d0.w),d1
	jmp	ObjC9_Index(pc,d1.w)
; ===========================================================================
ObjC9_Index:	offsetTable
		offsetTableEntry.w ObjC9_Init	; 0
		offsetTableEntry.w ObjC9_Main	; 2
; ===========================================================================

ObjC9_Init:
	addq.b	#2,routine(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lea	(PaletteChangerDataIndex).l,a1
	adda.w	(a1,d0.w),a1
	move.l	(a1)+,ttlscrpalchanger_codeptr(a0)
	movea.l	(a1)+,a2
	move.b	(a1)+,d0
	move.w	d0,ttlscrpalchanger_start_offset(a0)
	lea	(Target_palette).w,a3
	adda.w	d0,a3
	move.b	(a1)+,d0
	move.w	d0,ttlscrpalchanger_length(a0)

-	move.w	(a2)+,(a3)+
	dbf	d0,-

	move.b	(a1)+,d0
	move.b	d0,ttlscrpalchanger_fadein_time_left(a0)
	move.b	d0,ttlscrpalchanger_fadein_time(a0)
	move.b	(a1)+,ttlscrpalchanger_fadein_amount(a0)
	rts
; ===========================================================================

ObjC9_Main:
	subq.b	#1,ttlscrpalchanger_fadein_time_left(a0)
	bpl.s	+
	move.b	ttlscrpalchanger_fadein_time(a0),ttlscrpalchanger_fadein_time_left(a0)
	subq.b	#1,ttlscrpalchanger_fadein_amount(a0)
	bmi.w	DeleteObject
	movea.l	ttlscrpalchanger_codeptr(a0),a2
	movea.l	a0,a3
	move.w	ttlscrpalchanger_length(a0),d0
	move.w	ttlscrpalchanger_start_offset(a0),d1
	lea	(Normal_palette).w,a0
	adda.w	d1,a0
	lea	(Target_palette).w,a1
	adda.w	d1,a1

-	jsr	(a2)	; dynamic call! to Pal_FadeFromBlack.UpdateColour, loc_1344C, or loc_1348A, assuming the PaletteChangerData pointers haven't been changed
	dbf	d0,-

	movea.l	a3,a0
+
	rts
; ===========================================================================
; off_1337C:
PaletteChangerDataIndex: offsetTable
	offsetTableEntry.w off_1338C	;  0
	offsetTableEntry.w off_13398	;  2
	offsetTableEntry.w off_133A4	;  4
	offsetTableEntry.w off_133B0	;  6
	offsetTableEntry.w off_133BC	;  8
	offsetTableEntry.w off_133C8	; $A
	offsetTableEntry.w off_133D4	; $C
	offsetTableEntry.w off_133E0	; $E

C9PalInfo macro codeptr,dataptr,loadtoOffset,length,fadeinTime,fadeinAmount
	dc.l codeptr, dataptr
	dc.b loadtoOffset, length, fadeinTime, fadeinAmount
    endm

off_1338C:	C9PalInfo Pal_FadeFromBlack.UpdateColour, Pal_1342C, $60, $F,2,$15
off_13398:	C9PalInfo                      loc_1344C, Pal_1340C, $40, $F,4,7
off_133A4:	C9PalInfo                      loc_1344C,  Pal_AD1E,   0, $F,8,7
off_133B0:	C9PalInfo                      loc_1348A,  Pal_AD1E,   0, $F,8,7
off_133BC:	C9PalInfo                      loc_1344C,  Pal_AC7E,   0,$1F,4,7
off_133C8:	C9PalInfo                      loc_1344C,  Pal_ACDE, $40,$1F,4,7
off_133D4:	C9PalInfo                      loc_1344C,  Pal_AD3E,   0, $F,4,7
off_133E0:	C9PalInfo                      loc_1344C,  Pal_AC9E,   0,$1F,4,7

Pal_133EC:	BINCLUDE "art/palettes/Title Sonic.bin"
Pal_1340C:	BINCLUDE "art/palettes/Title Background.bin"
Pal_1342C:	BINCLUDE "art/palettes/Title Emblem.bin"

; ===========================================================================

loc_1344C:

	move.b	(a1)+,d2
	andi.b	#$E,d2
	move.b	(a0),d3
	cmp.b	d2,d3
	bls.s	loc_1345C
	subq.b	#2,d3
	move.b	d3,(a0)

loc_1345C:
	addq.w	#1,a0
	move.b	(a1)+,d2
	move.b	d2,d3
	andi.b	#$E0,d2
	andi.b	#$E,d3
	move.b	(a0),d4
	move.b	d4,d5
	andi.b	#$E0,d4
	andi.b	#$E,d5
	cmp.b	d2,d4
	bls.s	loc_1347E
	subi.b	#$20,d4

loc_1347E:
	cmp.b	d3,d5
	bls.s	loc_13484
	subq.b	#2,d5

loc_13484:
	or.b	d4,d5
	move.b	d5,(a0)+
	rts
; ===========================================================================

loc_1348A:
	moveq	#$E,d2
	move.b	(a0),d3
	and.b	d2,d3
	cmp.b	d2,d3
	bhs.s	loc_13498
	addq.b	#2,d3
	move.b	d3,(a0)

loc_13498:
	addq.w	#1,a0
	move.b	(a0),d3
	move.b	d3,d4
	andi.b	#$E0,d3
	andi.b	#$E,d4
	cmpi.b	#-$20,d3
	bhs.s	loc_134B0
	addi.b	#$20,d3

loc_134B0:
	cmp.b	d2,d4
	bhs.s	loc_134B6
	addq.b	#2,d4

loc_134B6:
	or.b	d3,d4
	move.b	d4,(a0)+
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


TitleScreen_SetFinalState:
	tst.b	obj0e_intro_complete(a0)
	bne.w	+	; rts

	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,(Ctrl_1_Press).w
	andi.b	#button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,(Ctrl_2_Press).w
	andi.b	#button_start_mask,d0
	beq.w	+	; rts

	; Initialise Sonic object.
	st.b	obj0e_intro_complete(a0)
	move.b	#$10,routine_secondary(a0)
	move.b	#$12,mapping_frame(a0)
	move.w	#128+136,x_pixel(a0)
	move.w	#128+24,y_pixel(a0)

	; Initialise Sonic's hand object.
	lea	(IntroSonicHand).w,a1
	bsr.w	TitleScreen_InitSprite
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$A,routine(a1)
	move.b	#2,priority(a1)
	move.b	#9,mapping_frame(a1)
	move.b	#4,routine_secondary(a1)
	move.w	#128+193,x_pixel(a1)
	move.w	#128+65,y_pixel(a1)

	; Initialise Tails object.
	lea	(IntroTails).w,a1
	bsr.w	TitleScreen_InitSprite
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#4,routine(a1)
	move.b	#4,mapping_frame(a1)
	move.b	#6,routine_secondary(a1)
	move.b	#3,priority(a1)
	move.w	#128+72,x_pixel(a1)
	move.w	#128+32,y_pixel(a1)

	; Initialise Tails' hand object.
	lea	(IntroTailsHand).w,a1
	bsr.w	TitleScreen_InitSprite
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$10,routine(a1)
	move.b	#2,priority(a1)
	move.b	#$13,mapping_frame(a1)
	move.b	#4,routine_secondary(a1)
	move.w	#128+141,x_pixel(a1)
	move.w	#128+81,y_pixel(a1)

	; Initialise top-of-emblem object.
	lea	(IntroEmblemTop).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#6,subtype(a1)

	; Initialise sprite mask object.
	bsr.w	Obj0E_LoadMaskingSprite

	; Initialise title screen menu object.
	move.b	#ObjID_TitleMenu,(TitleScreenMenu+id).w

	; Delete palette-changer object.
	lea	(TitleScreenPaletteChanger).w,a1
	bsr.w	DeleteObject2

	; Load palette line 4.
	lea_	Pal_1342C,a1
	lea	(Normal_palette_line4).w,a2
	moveq	#bytesToLcnt(palette_line_size),d6
-	move.l	(a1)+,(a2)+
	dbf	d6,-

	; Load palette line 3.
	lea_	Pal_1340C,a1
	lea	(Normal_palette_line3).w,a2
	moveq	#bytesToLcnt(palette_line_size),d6
-	move.l	(a1)+,(a2)+
	dbf	d6,-

	; Load palette line 1.
	lea_	Pal_133EC,a1
	lea	(Normal_palette).w,a2
	moveq	#bytesToLcnt(palette_line_size),d6
-	move.l	(a1)+,(a2)+
	dbf	d6,-

	; Play title screen music if it isn't already playing.
	tst.b	obj0e_music_playing(a0)
	bne.s	+
	moveq	#signextendB(MusID_Title),d0
	jsrto	PlayMusic, JmpTo4_PlayMusic
+
	rts
; End of function TitleScreen_SetFinalState


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_135EA:
TitleScreen_InitSprite:
	move.l	#Obj0E_MapUnc_136A8,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_TitleSprites,0,0),art_tile(a1)
	move.b	#4,priority(a1)
	rts
; End of function TitleScreen_InitSprite

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 0F - Title screen menu
; ----------------------------------------------------------------------------
; Sprite_13600:
Obj0F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj0F_Index(pc,d0.w),d1
	jsr	Obj0F_Index(pc,d1.w)
	bra.w	DisplaySprite
; ===========================================================================
; off_13612: Obj0F_States:
Obj0F_Index:	offsetTable
		offsetTableEntry.w Obj0F_Init	; 0
		offsetTableEntry.w Obj0F_Main	; 2
; ===========================================================================
; loc_13616:
Obj0F_Init:
	addq.b	#2,routine(a0) ; => Obj0F_Main
	move.w	#128+320/2+8,x_pixel(a0)
	move.w	#128+224/2+92,y_pixel(a0)
	move.l	#Obj0F_MapUnc_13B70,mappings(a0)
	move.w	#make_art_tile(ArtTile_VRAM_Start,0,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	andi.b	#1,(Title_screen_option).w
	move.b	(Title_screen_option).w,mapping_frame(a0)

; loc_13644:
Obj0F_Main:
	moveq	#0,d2
	move.b	(Title_screen_option).w,d2
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	btst	#button_up,d0
	beq.s	+
	subq.b	#1,d2
	bcc.s	+
	move.b	#2,d2
+
	btst	#button_down,d0
	beq.s	+
	addq.b	#1,d2
	cmpi.b	#3,d2
	blo.s	+
	moveq	#0,d2
+
	move.b	d2,mapping_frame(a0)
	move.b	d2,(Title_screen_option).w
	andi.b	#button_up_mask|button_down_mask,d0
	beq.s	+	; rts
	moveq	#signextendB(SndID_Blip),d0 ; selection blip sound
	jsrto	PlaySound, JmpTo4_PlaySound
+
	rts
; ===========================================================================
; animation script
; off_13686:
Ani_obj0E:	offsetTable
		offsetTableEntry.w Ani_obj0E_Sonic		; 0
		offsetTableEntry.w Ani_obj0E_Tails		; 1
		offsetTableEntry.w Ani_obj0E_FlashingStar	; 2
		offsetTableEntry.w Ani_obj0E_FallingStar	; 3
; byte_1368E:
Ani_obj0E_Sonic:
	dc.b   1
	dc.b   5
	dc.b   6
	dc.b   7
    if ~~fixBugs
	; This appears to be a leftover prototype frame: it's a duplicate of
	; frame $12, except Sonic is missing his right arm. The old frame
	; being here in this animation script causes Sonic to appear with
	; both of his arms missing for a single frame.
	dc.b   8
    endif
	dc.b $FA
	even
; byte_13694:
Ani_obj0E_Tails:
	dc.b   1
	dc.b   0
	dc.b   1
	dc.b   2
	dc.b   3
	dc.b   4
	dc.b $FA
	even
; byte_1369C:
Ani_obj0E_FlashingStar:
	dc.b   1
	dc.b  $C
	dc.b  $D
	dc.b  $E
	dc.b  $D
	dc.b  $C
	dc.b $FA
	even
; byte_136A4:
Ani_obj0E_FallingStar:
	dc.b   3
	dc.b  $C
	dc.b  $F
	dc.b $FF
	even
; -----------------------------------------------------------------------------
; Sprite Mappings - Flashing stars from intro (Obj0E)
; -----------------------------------------------------------------------------
Obj0E_MapUnc_136A8:	include "mappings/sprite/obj0E.asm"
; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
Obj0F_MapUnc_13B70:	include "mappings/sprite/obj0F.asm"

    if ~~removeJmpTos
JmpTo4_PlaySound ; JmpTo
	jmp	(PlaySound).l
JmpTo4_PlayMusic ; JmpTo
	jmp	(PlayMusic).l

	align 4
    endif
