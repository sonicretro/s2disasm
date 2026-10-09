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
	move.w	#spriteScreenPositionXCentered(-24),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-88),y_pixel(a0)

	; Initialise Sonic's hand object.
	lea	(IntroSonicHand).w,a1
	bsr.w	TitleScreen_InitSprite
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$A,routine(a1)
	move.b	#2,priority(a1)
	move.b	#9,mapping_frame(a1)
	move.b	#4,routine_secondary(a1)
	move.w	#spriteScreenPositionXCentered(33),x_pixel(a1)
	move.w	#spriteScreenPositionYCentered(-47),y_pixel(a1)

	; Initialise Tails object.
	lea	(IntroTails).w,a1
	bsr.w	TitleScreen_InitSprite
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#4,routine(a1)
	move.b	#4,mapping_frame(a1)
	move.b	#6,routine_secondary(a1)
	move.b	#3,priority(a1)
	move.w	#spriteScreenPositionXCentered(-88),x_pixel(a1)
	move.w	#spriteScreenPositionYCentered(-80),y_pixel(a1)

	; Initialise Tails' hand object.
	lea	(IntroTailsHand).w,a1
	bsr.w	TitleScreen_InitSprite
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$10,routine(a1)
	move.b	#2,priority(a1)
	move.b	#$13,mapping_frame(a1)
	move.b	#4,routine_secondary(a1)
	move.w	#spriteScreenPositionXCentered(-19),x_pixel(a1)
	move.w	#spriteScreenPositionYCentered(-31),y_pixel(a1)

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
	jsrto	JmpTo4_PlayMusic
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
