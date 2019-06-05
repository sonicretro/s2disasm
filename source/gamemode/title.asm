; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Game Mode: Title screen

; ----------------------------------------------------------------------------
; loc_3998:
TitleScreen:
	move.b	#MusID_Stop,d0
	bsr.w	PlayMusic
	bsr.w	ClearPLC
	bsr.w	Pal_FadeToBlack
	move	#$2700,sr
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
	bsr.w	ClearScreen

	clearRAM Sprite_Table_Input,Sprite_Table_Input_End ; fill $AC00-$AFFF with $0
	clearRAM TtlScr_Object_RAM,TtlScr_Object_RAM_End ; fill object RAM ($B000-$D5FF) with $0
	clearRAM Misc_Variables,Misc_Variables_End ; clear CPU player RAM and following variables
	clearRAM Camera_RAM,Camera_RAM_End ; clear camera RAM and following variables

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_CreditText),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_CreditText).l,a0
	bsr.w	NemDec
	lea	(off_B2B0).l,a1
	jsr	(loc_B272).l

	clearRAM Target_palette,Target_palette_End	; fill palette with 0 (black)
	moveq	#PalID_BGND,d0
	bsr.w	PalLoad_ForFade
	bsr.w	Pal_FadeFromBlack
	move	#$2700,sr
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
	move.b	#0,(Last_star_pole_hit).w
	move.b	#0,(Last_star_pole_hit_2P).w
	move.w	#0,(Debug_placement_mode).w
	move.w	#0,(Demo_mode_flag).w
	move.w	#0,(unk_FFDA).w
	move.w	#0,(PalCycle_Timer).w
	move.w	#0,(Two_player_mode).w
	move.b	#0,(Level_started_flag).w
	bsr.w	Pal_FadeToBlack
	move	#$2700,sr
	lea	(Chunk_Table).l,a1
	lea	(MapEng_TitleScreen).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_Title,2,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_TtlScr_Plane_B_Name_Table,VRAM,WRITE),d0
	moveq	#$27,d1
	moveq	#$1B,d2
	jsrto	(PlaneMapToVRAM_H40).l, PlaneMapToVRAM_H40
	lea	(Chunk_Table).l,a1
	lea	(MapEng_TitleBack).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_Title,2,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_TtlScr_Plane_B_Name_Table + planeLocH40($28,0),VRAM,WRITE),d0
	moveq	#$17,d1
	moveq	#$1B,d2
	jsrto	(PlaneMapToVRAM_H40).l, PlaneMapToVRAM_H40
	lea	(Chunk_Table).l,a1
	lea	(MapEng_TitleLogo).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_Title,3,1),d0
	bsr.w	EniDec

	lea	(Chunk_Table+$858).l,a1
	lea	(CopyrightText).l,a2

	moveq	#bytesToWcnt(CopyrightText_End-CopyrightText),d6
-	move.w	(a2)+,(a1)+	; load mappings for copyright 1992 sega message
	dbf	d6,-

	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_TtlScr_Plane_A_Name_Table,VRAM,WRITE),d0
	moveq	#$27,d1
	moveq	#$1B,d2
	jsrto	(PlaneMapToVRAM_H40).l, PlaneMapToVRAM_H40

	clearRAM Normal_palette,Target_palette_End	; fill two palettes with 0 (black)

	moveq	#PalID_Title,d0
	bsr.w	PalLoad_ForFade
	move.b	#0,(Debug_mode_flag).w
	move.w	#0,(Two_player_mode).w
	move.w	#$280,(Demo_Time_left).w
	clr.w	(Ctrl_1).w
	move.b	#ObjID_IntroStars,(IntroSonic+id).w ; load Obj0E (flashing intro star)
	move.b	#2,(IntroSonic+subtype).w				; Sonic
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	moveq	#PLCID_Std1,d0
	bsr.w	LoadPLC2
	move.w	#0,(Correct_cheat_entries).w
	move.w	#0,(Correct_cheat_entries_2).w
	nop
	nop
	nop
	nop
	nop
	nop
	move.w	#4,(Sonic_Pos_Record_Index).w
	move.w	#0,(Sonic_Pos_Record_Buf).w

	lea	(Results_Data_2P).w,a1

	moveq	#bytesToWcnt(Results_Data_2P_End-Results_Data_2P),d0
-	move.w	#-1,(a1)+
	dbf	d0,-

	move.w	#-$280,(Camera_X_pos).w
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromBlack

; loc_3C14:
TitleScreen_Loop:
	move.b	#VintID_Title,(Vint_routine).w
	bsr.w	WaitForVint
	jsr	(RunObjects).l
	jsrto	(SwScrl_Title).l, JmpTo_SwScrl_Title
	jsr	(BuildSprites).l

	; write alternating 0s and 4s, 80 times, at every 4th word,
	; starting at Sprite_Table+6
	lea	(Sprite_Table+4).w,a1
	moveq	#0,d0

	moveq	#79,d6
-	tst.w	(a1)
	bne.s	+
	bchg	#2,d0
	move.w	d0,2(a1)
+	addq.w	#8,a1
	dbf	d6,-

	bsr.w	RunPLC_RAM
	bsr.w	TailsNameCheat
	tst.w	(Demo_Time_left).w
	beq.w	TitleScreen_Demo
	tst.b	(IntroSonic+objoff_2F).w
	beq.w	TitleScreen_Loop
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0
	beq.w	TitleScreen_Loop ; loop until Start is pressed
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
	move.w #emerald_hill_zone_act_1,(Current_ZoneAndAct).w
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
	move.b	#emerald_hill_zone,(Current_Zone_2P).w
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
	bchg	#7,(Graphics_Flags).w ; turn on the cheat that changes MILES to "TAILS"
	move.b	#SndID_Ring,d0 ; play the ring sound for a successfully entered cheat
	bsr.w	PlaySound
+	move.w	#0,(Correct_cheat_entries).w
+	rts
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
ArtNem_Player1VS2:	BINCLUDE	"art/nemesis/1Player2VS.bin"
	even

	charset '0','9',0 ; Add character set for numbers
	charset '*',$A ; Add character for star
	charset '@',$B ; Add character for copyright symbol
	charset ':',$C ; Add character for colon
	charset '.',$D ; Add character for period
	charset 'A','Z',$E ; Add character set for letters

; word_3E82:
CopyrightText:
	dc.w  make_art_tile(ArtTile_ArtNem_FontStuff_TtlScr + '@',0,0)	; (C)
	dc.w  make_art_tile(ArtTile_VRAM_Start,0,0)	;
	dc.w  make_art_tile(ArtTile_ArtNem_FontStuff_TtlScr + '1',0,0)	; 1
	dc.w  make_art_tile(ArtTile_ArtNem_FontStuff_TtlScr + '9',0,0)	; 9
	dc.w  make_art_tile(ArtTile_ArtNem_FontStuff_TtlScr + '9',0,0)	; 9
	dc.w  make_art_tile(ArtTile_ArtNem_FontStuff_TtlScr + '2',0,0)	; 2
	dc.w  make_art_tile(ArtTile_VRAM_Start,0,0)	;
	dc.w  make_art_tile(ArtTile_ArtNem_FontStuff_TtlScr + 'S',0,0)	; S
	dc.w  make_art_tile(ArtTile_ArtNem_FontStuff_TtlScr + 'E',0,0)	; E
	dc.w  make_art_tile(ArtTile_ArtNem_FontStuff_TtlScr + 'G',0,0)	; G
	dc.w  make_art_tile(ArtTile_ArtNem_FontStuff_TtlScr + 'A',0,0)	; A
CopyrightText_End:

    charset ; Revert character set

    if ~~removeJmpTos
; sub_3E98:
JmpTo_SwScrl_Title 
	jmp	(SwScrl_Title).l

	align 4
    endif
