; ===========================================================================
; loc_3998:
TitleScreen:
	; Stop music.
	move.b	#MusID_Stop,d0
	bsr.w	PlayMusic

	; Clear the PLC queue, preventing any PLCs from before loading after this point.
	bsr.w	ClearPLC

	; Fade out.
	bsr.w	Pal_FadeToBlack

	; Disable interrupts, so that we can have exclusive access to the VDP.
	move	#$2700,sr

	; Configure the VDP for this screen mode.
	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8200|(VRAM_TtlScr_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_TtlScr_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $E000
	move.w	#$9001,(a6)		; Scroll table size: 64x32
	move.w	#$9200,(a6)		; Disable window
	move.w	#$8B03,(a6)		; EXT-INT disabled, V scroll by screen, H scroll by line
	move.w	#$8720,(a6)		; Background palette/color: 2/0

	clr.b	(Water_fullscreen_flag).w

	move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled

	; Reset plane maps, sprite table, and scroll tables.
	bsr.w	ClearScreen

	; Reset a bunch of engine state.
	clearRAM Object_Display_Lists,Object_Display_Lists_End ; fill $AC00-$AFFF with $0
	clearRAM Object_RAM,Object_RAM_End ; fill object RAM ($B000-$D5FF) with $0
	clearRAM Misc_Variables,Misc_Variables_End ; clear CPU player RAM and following variables
	clearRAM Camera_RAM,Camera_RAM_End ; clear camera RAM and following variables

	; Load the credit font for the following text.
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_CreditText),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_CreditText).l,a0
	bsr.w	NemDec

	; Load the 'Sonic and Miles 'Tails' Prower in' text.
	lea	(off_B2B0).l,a1
	jsr	(loc_B272).l

	; Fade-in, showing the text that was just loaded.
	clearRAM Target_palette,Target_palette_End	; fill palette with 0 (black)
	moveq	#PalID_BGND,d0
	bsr.w	PalLoad_ForFade
	bsr.w	Pal_FadeFromBlack

	; 'Pal_FadeFromBlack' enabled the interrupts, so disable them again
	; so that we have exclusive access to the VDP for the following calls
	; to the Nemesis decompressor.
	move	#$2700,sr

	; Load assets while the above text is being displayed.
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Title),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Title).l,a0
	bsr.w	NemDec

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_TitleSprites),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_TitleSprites).l,a0
	bsr.w	NemDec

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_MenuJunk),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_MenuJunk).l,a0
	bsr.w	NemDec

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Player1VS2),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Player1VS2).l,a0
	bsr.w	NemDec

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_FontStuff_TtlScr),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_FontStuff).l,a0
	bsr.w	NemDec

	; Clear some variables.
	move.b	#0,(Last_star_pole_hit).w
	move.b	#0,(Last_star_pole_hit_2P).w
	move.w	#0,(Debug_placement_mode).w
	move.w	#0,(Demo_mode_flag).w
	move.w	#0,(unk_FFDA).w
	move.w	#0,(PalCycle_Timer).w
	move.w	#0,(Two_player_mode).w
	move.b	#0,(Level_started_flag).w

	; And finally fade out.
	bsr.w	Pal_FadeToBlack

	; 'Pal_FadeToBlack' enabled the interrupts, so disable them again
	; so that we have exclusive access to the VDP for the following calls
	; to the plane map loader.
	move	#$2700,sr

	; Decompress the first part of the title screen background plane map...
	lea	(Chunk_Table).l,a1
	lea	(MapEng_TitleScreen).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_Title,2,0),d0
	bsr.w	EniDec

	; ...and send it to VRAM.
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_TtlScr_Plane_B_Name_Table,VRAM,WRITE),d0
	moveq	#40-1,d1 ; Width
	moveq	#28-1,d2 ; Height
	jsrto	PlaneMapToVRAM_H40, PlaneMapToVRAM_H40

	; Decompress the second part of the title screen background plane map...
	lea	(Chunk_Table).l,a1
	lea	(MapEng_TitleBack).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_Title,2,0),d0
	bsr.w	EniDec

	; ...and send it to VRAM.
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_TtlScr_Plane_B_Name_Table+planeLocH40(40,0),VRAM,WRITE),d0
	moveq	#24-1,d1 ; Width
	moveq	#28-1,d2 ; Height
	jsrto	PlaneMapToVRAM_H40, PlaneMapToVRAM_H40

	; Decompress the title screen emblem plane map...
	lea	(Chunk_Table).l,a1
	lea	(MapEng_TitleLogo).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_Title,3,1),d0
	bsr.w	EniDec

	; ...add the copyright text to it...
	lea	(Chunk_Table+planeLocH40(44,16)).l,a1
	lea	(CopyrightText).l,a2
	moveq	#bytesToWcnt(CopyrightText_End-CopyrightText),d6
-	move.w	(a2)+,(a1)+
	dbf	d6,-

	; ...and send it to VRAM.
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_TtlScr_Plane_A_Name_Table,VRAM,WRITE),d0
	moveq	#40-1,d1 ; Width
	moveq	#28-1,d2 ; Height
	jsrto	PlaneMapToVRAM_H40, PlaneMapToVRAM_H40

	; Clear the palette.
	clearRAM Normal_palette,Target_palette_End

	; Load the title screen palette, so we can fade into it later.
	moveq	#PalID_Title,d0
	bsr.w	PalLoad_ForFade

	; Reset some variables.
	move.b	#0,(Debug_mode_flag).w
	move.w	#0,(Two_player_mode).w

	; Set the time that the title screen lasts (little over ten seconds).
	move.w	#60*10+40,(Demo_Time_left).w

	; Clear the player's inputs, to prevent a leftover input from
	; skipping the intro.
	clr.w	(Ctrl_1).w

	; Load the object responsible for the intro animation.
	move.b	#ObjID_TitleIntro,(IntroSonic+id).w
	move.b	#2,(IntroSonic+subtype).w

	; Run it for a frame, so that it initialises.
	jsr	(RunObjects).l
	jsr	(BuildSprites).l

	; Load some standard sprites.
	moveq	#PLCID_Std1,d0
	bsr.w	LoadPLC2

	; Reset the cheat input state.
	move.w	#0,(Correct_cheat_entries).w
	move.w	#0,(Correct_cheat_entries_2).w

	; I do not know why these are here.
	nop
	nop
	nop
	nop
	nop
	nop

	; Reset Sonic's position record buffer.
	move.w	#4,(Sonic_Pos_Record_Index).w
	move.w	#0,(Sonic_Pos_Record_Buf).w

	; Reset the two player mode results data.
	lea	(Results_Data_2P).w,a1
	moveq	#bytesToWcnt(Results_Data_2P_End-Results_Data_2P),d0
-	move.w	#-1,(a1)+
	dbf	d0,-

	; Initialise the camera's X position.
	move.w	#-$280,(Camera_X_pos).w

	; Enable the VDP's display.
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l

	; Fade into the palette that was loaded earlier.
	bsr.w	Pal_FadeFromBlack

; loc_3C14:
TitleScreen_Loop:
	move.b	#VintID_Title,(Vint_routine).w
	bsr.w	WaitForVint

	jsr	(RunObjects).l
	jsrto	SwScrl_Title, JmpTo_SwScrl_Title
	jsr	(BuildSprites).l

	; Find the masking sprite, and move it to the proper location. The
	; sprite is normally at X 128+128, but in order to perform masking,
	; it must be at X 0.
	; The masking sprite is used to stop Sonic and Tails from overlapping
	; the emblem.
	; You might be wondering why it alternates between 0 and 4 for the X
	; position. That's because masking sprites only work if another
	; sprite rendered before them (or if the previous scanline reached
	; its pixel limit). Because of this, a sprite is placed at X 4 before
	; a second one is placed at X 0.
	lea	(Sprite_Table+4).w,a1
	moveq	#0,d0

	moveq	#(Sprite_Table_End-Sprite_Table)/8-1,d6
-	tst.w	(a1)	; The masking sprite has its art-tile set to $0000.
	bne.s	+
	bchg	#2,d0	; Alternate between X positions of 0 and 4.
	move.w	d0,2(a1)
+	addq.w	#8,a1
	dbf	d6,-

	bsr.w	RunPLC_RAM
	bsr.w	TailsNameCheat

	; If the timer has run out, go play a demo.
	tst.w	(Demo_Time_left).w
	beq.w	TitleScreen_Demo

	; If the intro is still playing, then don't let the start button
	; begin the game.
	tst.b	(IntroSonic+obj0e_intro_complete).w
	beq.w	TitleScreen_Loop

	; If the start button has not been pressed, then loop back and keep
	; running the title screen.
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0
	beq.w	TitleScreen_Loop ; loop until Start is pressed

	; At this point, the start button has been pressed and it's time to
	; enter one player mode, two player mode, or the options menu.

	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)

	move.b	#3,(Life_count).w
	move.b	#3,(Life_count_2P).w

	moveq	#0,d0
	move.w	d0,(Ring_count).w
	move.l	d0,(Timer).w
	move.l	d0,(Score).w
	move.w	d0,(Ring_count_2P).w
	move.l	d0,(Timer_2P).w
	move.l	d0,(Score_2P).w
	move.b	d0,(Continue_count).w

	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w

	move.b	#MusID_FadeOut,d0 ; prepare to stop music (fade out)
	bsr.w	PlaySound

	moveq	#0,d0
	move.b	(Title_screen_option).w,d0
	bne.s	TitleScreen_CheckIfChose2P	; branch if not a 1-player game

	moveq	#0,d0
	move.w	d0,(Two_player_mode_copy).w
	move.w	d0,(Two_player_mode).w
    if emerald_hill_zone_act_1=0
	move.w	d0,(Current_ZoneAndAct).w ; emerald_hill_zone_act_1
    else
	move.w	#emerald_hill_zone_act_1,(Current_ZoneAndAct).w
    endif
	tst.b	(Level_select_flag).w	; has level select cheat been entered?
	beq.s	+			; if not, branch
	btst	#button_A,(Ctrl_1_Held).w ; is A held down?
	beq.s	+	 		; if not, branch
	move.b	#GameModeID_LevelSelect,(Game_Mode).w ; => LevelSelectMenu
	rts
; ---------------------------------------------------------------------------
+
	move.w	d0,(Current_Special_StageAndAct).w
	move.w	d0,(Got_Emerald).w
	move.l	d0,(Got_Emeralds_array).w
	move.l	d0,(Got_Emeralds_array+4).w
	rts
; ===========================================================================
; loc_3CF6:
TitleScreen_CheckIfChose2P:
	subq.b	#1,d0
	bne.s	TitleScreen_ChoseOptions

	moveq	#1,d1
	move.w	d1,(Two_player_mode_copy).w
	move.w	d1,(Two_player_mode).w

	moveq	#0,d0
	move.w	d0,(Got_Emerald).w
	move.l	d0,(Got_Emeralds_array).w
	move.l	d0,(Got_Emeralds_array+4).w

	move.b	#GameModeID_2PLevelSelect,(Game_Mode).w ; => LevelSelectMenu2P
	move.b	#0,(Current_Zone_2P).w
	rts
; ---------------------------------------------------------------------------
; loc_3D20:
TitleScreen_ChoseOptions:
	move.b	#GameModeID_OptionsMenu,(Game_Mode).w ; => OptionsMenu
	move.b	#0,(Options_menu_box).w
	rts
; ===========================================================================
; loc_3D2E:
TitleScreen_Demo:
	move.b	#MusID_FadeOut,d0
	bsr.w	PlaySound

	move.w	(Demo_number).w,d0
	andi.w	#7,d0
	add.w	d0,d0
	move.w	DemoLevels(pc,d0.w),d0
	move.w	d0,(Current_ZoneAndAct).w

	addq.w	#1,(Demo_number).w
	cmpi.w	#(DemoLevels_End-DemoLevels)/2,(Demo_number).w
	blo.s	+
	move.w	#0,(Demo_number).w
+
	move.w	#1,(Demo_mode_flag).w
	move.b	#GameModeID_Demo,(Game_Mode).w ; => Level (Demo mode)
	cmpi.w	#emerald_hill_zone_act_1,(Current_ZoneAndAct).w
	bne.s	+
	move.w	#1,(Two_player_mode).w
+
	move.b	#3,(Life_count).w
	move.b	#3,(Life_count_2P).w

	moveq	#0,d0
	move.w	d0,(Ring_count).w
	move.l	d0,(Timer).w
	move.l	d0,(Score).w
	move.w	d0,(Ring_count_2P).w
	move.l	d0,(Timer_2P).w
	move.l	d0,(Score_2P).w

	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w

	rts
; ===========================================================================
; word_3DAC:
DemoLevels:
	dc.w	emerald_hill_zone_act_1		; EHZ (2P)
	dc.w	chemical_plant_zone_act_1	; CPZ
	dc.w	aquatic_ruin_zone_act_1		; ARZ
	dc.w	casino_night_zone_act_1		; CNZ
DemoLevels_End:

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_3DB4:
TailsNameCheat:
	lea	(TailsNameCheat_Buttons).l,a0
	move.w	(Correct_cheat_entries).w,d0
	adda.w	d0,a0
	move.b	(Ctrl_1_Press).w,d0
	andi.b	#button_up_mask|button_down_mask|button_left_mask|button_right_mask,d0
	beq.s	++	; rts
	cmp.b	(a0),d0
	bne.s	+
	addq.w	#1,(Correct_cheat_entries).w
	tst.b	1(a0)		; read the next entry
	bne.s	++		; if it's not zero, return

	; Switch the detected console's region between Japanese and
	; international. This affects the presence of trademark symbols, and
	; causes Tails' name to swap between 'Tails' and 'Miles'.
	bchg	#7,(Graphics_Flags).w

	move.b	#SndID_Ring,d0 ; play the ring sound for a successfully entered cheat
	bsr.w	PlaySound
+
	move.w	#0,(Correct_cheat_entries).w
+
	rts
; End of function TailsNameCheat

; ===========================================================================
; byte_3DEE:
TailsNameCheat_Buttons:
	dc.b	button_up_mask
	dc.b	button_down_mask
	dc.b	button_down_mask
	dc.b	button_down_mask
	dc.b	button_up_mask
	dc.b	0	; end
	even
; ---------------------------------------------------------------------------------
; Nemesis compressed art
; 10 blocks
; Player 1 2 VS Text
; ---------------------------------------------------------------------------------
; ArtNem_3DF4:
ArtNem_Player1VS2:	BINCLUDE	"art/nemesis/1Player2VS.nem"
	even

	charset '0','9',0 ; Add character set for numbers
	charset '*',$A ; Add character for star
	charset '@',$B ; Add character for copyright symbol
	charset ':',$C ; Add character for colon
	charset '.',$D ; Add character for period
	charset 'A','Z',$E ; Add character set for letters

; word_3E82:
CopyrightText:
  irpc chr,"@ 1992 SEGA"
    if "chr"<>" "
	dc.w  make_art_tile(ArtTile_ArtNem_FontStuff_TtlScr + 'chr'|0,0,0)
    else
	dc.w  make_art_tile(ArtTile_VRAM_Start,0,0)
    endif
  endm
CopyrightText_End:

    charset ; Revert character set

    if ~~removeJmpTos
; sub_3E98:
JmpTo_SwScrl_Title ; JmpTo
	jmp	(SwScrl_Title).l

	align 4
    endif
