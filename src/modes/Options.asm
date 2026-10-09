; loc_8FCC:
MenuScreen_Options:
	lea	(Chunk_Table).l,a1
	lea	(MapEng_Options).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox,0,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table+$160).l,a1
	lea	(MapEng_Options).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox,1,0),d0
	bsr.w	EniDec
	clr.b	(Options_menu_box).w
	bsr.w	OptionScreen_DrawSelected
	addq.b	#1,(Options_menu_box).w
	bsr.w	OptionScreen_DrawUnselected
	addq.b	#1,(Options_menu_box).w
	bsr.w	OptionScreen_DrawUnselected
	clr.b	(Options_menu_box).w
	clr.b	(Level_started_flag).w
	clr.w	(Anim_Counters).w
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo2_Dynamic_Normal
	moveq	#PalID_Menu,d0
	bsr.w	PalLoad_ForFade
	move.b	#MusID_Options,d0
	jsrto	JmpTo_PlayMusic
	clr.w	(Two_player_mode).w
	clr.l	(Camera_X_pos).w
	clr.l	(Camera_Y_pos).w
	clr.w	(Correct_cheat_entries).w
	clr.w	(Correct_cheat_entries_2).w
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromBlack
; loc_9060:
OptionScreen_Main:
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move	#$2700,sr
	bsr.w	OptionScreen_DrawUnselected
	bsr.w	OptionScreen_Controls
	bsr.w	OptionScreen_DrawSelected
	move	#$2300,sr
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo2_Dynamic_Normal
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0
	bne.s	OptionScreen_Select
	bra.w	OptionScreen_Main
; ===========================================================================
; loc_909A:
OptionScreen_Select:
	move.b	(Options_menu_box).w,d0
	bne.s	OptionScreen_Select_Not1P
	; Start a single player game
	moveq	#0,d0
	move.w	d0,(Two_player_mode).w
	move.w	d0,(Two_player_mode_copy).w
    if emerald_hill_zone_act_1=0
	move.w	d0,(Current_ZoneAndAct).w ; emerald_hill_zone_act_1
    else
	move.w	#emerald_hill_zone_act_1,(Current_ZoneAndAct).w
    endif
    if fixBugs
	; The game forgets to reset these variables here, making it possible
	; for the player to repeatedly soft-reset and play Emerald Hill Zone
	; over and over again, collecting all of the emeralds within the
	; first act. This code is borrowed from similar logic in the title
	; screen, which doesn't make this mistake.
	move.w	d0,(Current_Special_StageAndAct).w
	move.w	d0,(Got_Emerald).w
	move.l	d0,(Got_Emeralds_array).w
	move.l	d0,(Got_Emeralds_array+4).w
    endif
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	rts
; ===========================================================================
; loc_90B6:
OptionScreen_Select_Not1P:
	subq.b	#1,d0
	bne.s	OptionScreen_Select_Other
	; Start a 2P VS game
	moveq	#1,d0
	move.w	d0,(Two_player_mode).w
	move.w	d0,(Two_player_mode_copy).w
    if fixBugs
	; The game forgets to reset these variables here, making it possible
	; for the player to play two player mode with all emeralds collected,
	; allowing them to use Super Sonic. This code is borrowed from
	; similar logic in the title screen, which doesn't make this mistake.
	moveq	#0,d0
	move.w	d0,(Got_Emerald).w
	move.l	d0,(Got_Emeralds_array).w
	move.l	d0,(Got_Emeralds_array+4).w
    endif
	move.b	#GameModeID_2PLevelSelect,(Game_Mode).w ; => LevelSelectMenu2P
	move.b	#0,(Current_Zone_2P).w
	move.w	#0,(Player_mode).w
	rts
; ===========================================================================
; loc_90D8:
OptionScreen_Select_Other:
	; When pressing START on the sound test option, return to the SEGA screen
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_90E0:
OptionScreen_Controls:
	moveq	#0,d2
	move.b	(Options_menu_box).w,d2
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
	move.b	d2,(Options_menu_box).w
	lsl.w	#2,d2
	move.b	OptionScreen_Choices(pc,d2.w),d3 ; number of choices for the option
	movea.l	OptionScreen_Choices(pc,d2.w),a1 ; location where the choice is stored (in RAM)
	move.w	(a1),d2
	btst	#button_left,d0
	beq.s	+
	subq.b	#1,d2
	bcc.s	+
	move.b	d3,d2

+
	btst	#button_right,d0
	beq.s	+
	addq.b	#1,d2
	cmp.b	d3,d2
	bls.s	+
	moveq	#0,d2

+
    if fixBugs
	; Based on code from the Level Select.
	cmpi.b	#2,(Options_menu_box).w
	bne.s	+
	btst	#button_A,d0
	beq.s	+
	addi.b	#$10,d2
	andi.b	#$7F,d2
    else
	; This code appears to have been carelessly created from a copy of the
	; above block of code. It makes no sense to advance by $10 on options
	; that have only 2 or 3 values. Likewise, the logic for setting the
	; value to 0 when exceeding the maximum bound only makes sense for
	; incrementing by 1, not $10.
	btst	#button_A,d0
	beq.s	+
	addi.b	#$10,d2
	cmp.b	d3,d2
	bls.s	+
	moveq	#0,d2
    endif

+
	move.w	d2,(a1)
	cmpi.b	#2,(Options_menu_box).w
	bne.s	+	; rts
	andi.w	#button_B_mask|button_C_mask,d0
	beq.s	+	; rts
	move.w	(Sound_test_sound).w,d0
	addi.w	#$80,d0
	jsrto	JmpTo_PlayMusic
	lea	(level_select_cheat).l,a0
	lea	(continues_cheat).l,a2
	lea	(Level_select_flag).w,a1	; Also Slow_motion_flag
	moveq	#0,d2	; flag to tell the routine to enable the continues cheat
	bsr.w	CheckCheats

+
	rts
; End of function OptionScreen_Controls

; ===========================================================================
; word_917A:
OptionScreen_Choices:
	dc.l (3-1)<<24|(Player_option&$FFFFFF)
	dc.l (2-1)<<24|(Two_player_items&$FFFFFF)
	dc.l ($80-1)<<24|(Sound_test_sound&$FFFFFF)

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_9186
OptionScreen_DrawSelected:
	bsr.w	OptionScreen_SelectTextPtr
	moveq	#0,d1
	move.b	(Options_menu_box).w,d1
	lsl.w	#3,d1
	lea	(OptScrBoxData).l,a3
	lea	(a3,d1.w),a3
	move.w	#palette_line_3,d0
	lea	(Chunk_Table+$30).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$B6).l,a2
	moveq	#0,d1
	cmpi.b	#2,(Options_menu_box).w
	beq.s	+
	move.b	(Options_menu_box).w,d1
	lsl.w	#2,d1
	lea	OptionScreen_Choices(pc),a1
	movea.l	(a1,d1.w),a1
	move.w	(a1),d1
	lsl.w	#2,d1
+
	movea.l	(a4,d1.w),a1
	bsr.w	MenuScreenTextToRAM
	cmpi.b	#2,(Options_menu_box).w
	bne.s	+
	lea	(Chunk_Table+$C2).l,a2
	bsr.w	OptionScreen_HexDumpSoundTest
+
	lea	(Chunk_Table).l,a1
	move.l	(a3)+,d0
	moveq	#22-1,d1
	moveq	#8-1,d2
	jmpto	JmpTo_PlaneMapToVRAM_H40
; ===========================================================================

;loc_91F8
OptionScreen_DrawUnselected:
	bsr.w	OptionScreen_SelectTextPtr
	moveq	#0,d1
	move.b	(Options_menu_box).w,d1
	lsl.w	#3,d1
	lea	(OptScrBoxData).l,a3
	lea	(a3,d1.w),a3
	moveq	#palette_line_0,d0
	lea	(Chunk_Table+$190).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$216).l,a2
	moveq	#0,d1
	cmpi.b	#2,(Options_menu_box).w
	beq.s	+
	move.b	(Options_menu_box).w,d1
	lsl.w	#2,d1
	lea	OptionScreen_Choices(pc),a1
	movea.l	(a1,d1.w),a1
	move.w	(a1),d1
	lsl.w	#2,d1

+
	movea.l	(a4,d1.w),a1
	bsr.w	MenuScreenTextToRAM
	cmpi.b	#2,(Options_menu_box).w
	bne.s	+
	lea	(Chunk_Table+$222).l,a2
	bsr.w	OptionScreen_HexDumpSoundTest

+
	lea	(Chunk_Table+$160).l,a1
	move.l	(a3)+,d0
	moveq	#22-1,d1
	moveq	#8-1,d2
	jmpto	JmpTo_PlaneMapToVRAM_H40
; ===========================================================================

;loc_9268
OptionScreen_SelectTextPtr:
	lea	(off_92D2).l,a4
	tst.b	(Graphics_Flags).w
	bpl.s	+
	lea	(off_92DE).l,a4

+
	tst.b	(Options_menu_box).w
	beq.s	+
	lea	(off_92EA).l,a4

+
	cmpi.b	#2,(Options_menu_box).w
	bne.s	+	; rts
	lea	(off_92F2).l,a4

+
	rts
; ===========================================================================

;loc_9296
OptionScreen_HexDumpSoundTest:
	move.w	(Sound_test_sound).w,d1
	move.b	d1,d2
	lsr.b	#4,d1
	bsr.s	+
	move.b	d2,d1

+
	andi.w	#$F,d1
	cmpi.b	#$A,d1
	blo.s	+
	addi.b	#4,d1

+
	addi.b	#$10,d1
	move.b	d1,d0
	move.w	d0,(a2)+
	rts
; ===========================================================================
; off_92BA:
OptScrBoxData:

; macro to declare the data for an options screen box
boxData macro txtlabel,vramAddr
	dc.l txtlabel, vdpComm(vramAddr,VRAM,WRITE)
    endm

	boxData	TextOptScr_PlayerSelect,VRAM_Plane_A_Name_Table+planeLoc(64,9,3)
	boxData	TextOptScr_VsModeItems,VRAM_Plane_A_Name_Table+planeLoc(64,9,11)
	boxData	TextOptScr_SoundTest,VRAM_Plane_A_Name_Table+planeLoc(64,9,19)

off_92D2:
	dc.l TextOptScr_SonicAndMiles
	dc.l TextOptScr_SonicAlone
	dc.l TextOptScr_MilesAlone
off_92DE:
	dc.l TextOptScr_SonicAndTails
	dc.l TextOptScr_SonicAlone
	dc.l TextOptScr_TailsAlone
off_92EA:
	dc.l TextOptScr_AllKindsItems
	dc.l TextOptScr_TeleportOnly
off_92F2:
	dc.l TextOptScr_0
; ===========================================================================
