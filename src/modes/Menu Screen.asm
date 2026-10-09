; loc_8BD4:
MenuScreen:
	bsr.w	Pal_FadeToBlack
	move	#$2700,sr
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	ClearScreen
	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)		; PNT A base: $C000
	move.w	#$8400|(VRAM_Menu_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $E000
	move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)		; PNT A base: $C000
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled
	move.w	#$9001,(a6)		; Scroll table size: 64x32

	clearRAM Object_Display_Lists,Object_Display_Lists_End
	clearRAM Object_RAM,Object_RAM_End

	; load background + graphics of font/LevSelPics
	clr.w	(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_FontStuff),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_FontStuff).l,a0
	bsr.w	NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_MenuBox),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_MenuBox).l,a0
	bsr.w	NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_LevelSelectPics),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_LevelSelectPics).l,a0
	bsr.w	NemDec
	lea	(Chunk_Table).l,a1
	lea	(MapEng_MenuBack).l,a0
	move.w	#make_art_tile(ArtTile_VRAM_Start,3,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
	moveq	#40-1,d1
	moveq	#28-1,d2
	jsrto	JmpTo_PlaneMapToVRAM_H40	; fullscreen background

	cmpi.b	#GameModeID_OptionsMenu,(Game_Mode).w	; options menu?
	beq.w	MenuScreen_Options	; if yes, branch

	cmpi.b	#GameModeID_LevelSelect,(Game_Mode).w	; level select menu?
	beq.w	MenuScreen_LevelSelect	; if yes, branch

;MenuScreen_LevSel2P:
	lea	(Chunk_Table).l,a1
	lea	(MapEng_LevSel2P).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox,0,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table+$198).l,a1
	lea	(MapEng_LevSel2P).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox,1,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table+$330).l,a1
	lea	(MapEng_LevSelIcon).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_LevelSelectPics,0,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table+$498).l,a2

	moveq	#bytesToWcnt(tiles_to_bytes(1)),d1
-	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox+11,1,0),(a2)+
	dbf	d1,-

	bsr.w	Update2PLevSelSelection
	addq.b	#1,(Current_Zone_2P).w
	andi.b	#3,(Current_Zone_2P).w
	bsr.w	ClearOld2PLevSelSelection
	addq.b	#1,(Current_Zone_2P).w
	andi.b	#3,(Current_Zone_2P).w
	bsr.w	ClearOld2PLevSelSelection
	addq.b	#1,(Current_Zone_2P).w
	andi.b	#3,(Current_Zone_2P).w
	bsr.w	ClearOld2PLevSelSelection
	addq.b	#1,(Current_Zone_2P).w
	andi.b	#3,(Current_Zone_2P).w
	clr.w	(Player_mode).w
	clr.b	(Current_Act_2P).w
	clr.w	(Results_Screen_2P).w	; VsRSID_Act
	clr.b	(Level_started_flag).w
	clr.w	(Anim_Counters).w
	clr.w	(Game_Over_2P).w
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo2_Dynamic_Normal
	moveq	#PalID_Menu,d0
	bsr.w	PalLoad_ForFade
	lea	(Normal_palette_line3).w,a1
	lea	(Target_palette_line3).w,a2

	moveq	#bytesToLcnt(tiles_to_bytes(1)),d1
-	move.l	(a1),(a2)+
	clr.l	(a1)+
	dbf	d1,-

	move.b	#MusID_Options,d0
	jsrto	JmpTo_PlayMusic
	move.w	#(30*60)-1,(Demo_Time_left).w	; 30 seconds
	clr.w	(Two_player_mode).w
	clr.l	(Camera_X_pos).w
	clr.l	(Camera_Y_pos).w
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromBlack

;loc_8DA8:
LevelSelect2P_Main:
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move	#$2700,sr
	bsr.w	ClearOld2PLevSelSelection
	bsr.w	LevelSelect2P_Controls
	bsr.w	Update2PLevSelSelection
	move	#$2300,sr
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo2_Dynamic_Normal
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0
	bne.s	LevelSelect2P_PressStart
	bra.w	LevelSelect2P_Main
; ===========================================================================
;loc_8DE2:
LevelSelect2P_PressStart:
	bsr.w	Chk2PZoneCompletion
	bmi.s	loc_8DF4
	move.w	#SndID_Error,d0
	jsrto	JmpTo_PlaySound
	bra.w	LevelSelect2P_Main
; ===========================================================================

loc_8DF4:
	moveq	#0,d0
	move.b	(Current_Zone_2P).w,d0
	add.w	d0,d0
	move.w	LevelSelect2P_LevelOrder(pc,d0.w),d0
	bmi.s	loc_8E3A
	move.w	d0,(Current_ZoneAndAct).w
	move.w	#1,(Two_player_mode).w
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	move.b	#0,(Last_star_pole_hit).w
	move.b	#0,(Last_star_pole_hit_2P).w
	moveq	#0,d0
	move.l	d0,(Score).w
	move.l	d0,(Score_2P).w
	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w
	rts
; ===========================================================================

loc_8E3A:
	move.b	#4,(Current_Special_Stage).w
	move.b	#GameModeID_SpecialStage,(Game_Mode).w ; => SpecialStage
	moveq	#1,d0
	move.w	d0,(Two_player_mode).w
	move.w	d0,(Two_player_mode_copy).w
	rts
; ===========================================================================
; word_8E52:
LevelSelect2P_LevelOrder:
	dc.w	emerald_hill_zone_act_1
	dc.w	mystic_cave_zone_act_1
	dc.w	casino_night_zone_act_1
	dc.w	$FFFF

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_8E5A:
LevelSelect2P_Controls:
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	move.b	d0,d1
	andi.b	#button_up_mask|button_down_mask,d0
	beq.s	+
	bchg	#1,(Current_Zone_2P).w

+
	andi.b	#button_left_mask|button_right_mask,d1
	beq.s	+	; rts
	bchg	#0,(Current_Zone_2P).w
+
	rts
; End of function LevelSelect2P_Controls

; ---------------------------------------------------------------------------
; Subroutine to update the 2P level select selection graphically
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_8E7E:
Update2PLevSelSelection:
	moveq	#0,d0
	move.b	(Current_Zone_2P).w,d0
	lsl.w	#4,d0	; 16 bytes per entry
	lea	(LevSel2PIconData).l,a3
	lea	(a3,d0.w),a3
	move.w	#palette_line_3,d0	; highlight text
	lea	(Chunk_Table+$48).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$94).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$D8).l,a2
	movea.l	4(a3),a1
	bsr.w	Chk2PZoneCompletion	; has the zone been completed?
	bmi.s	+	; if not, branch
	lea	(Chunk_Table+$468).l,a1	; display large X instead of icon
+
	moveq	#2,d1
-	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	lea	$1A(a2),a2
	dbf	d1,-

	lea	(Chunk_Table).l,a1
	move.l	(a3)+,d0
	moveq	#17-1,d1
	moveq	#12-1,d2
	jsrto	JmpTo_PlaneMapToVRAM_H40
	lea	(Pal_LevelIcons).l,a1
	moveq	#0,d0
	move.b	(a3),d0
	lsl.w	#5,d0
	lea	(a1,d0.w),a1
	lea	(Normal_palette_line3).w,a2

	moveq	#bytesToLcnt(palette_line_size),d1
-	move.l	(a1)+,(a2)+
	dbf	d1,-

	rts
; End of function Update2PLevSelSelection

; ---------------------------------------------------------------------------
; Subroutine to check if a 2P zone has been completed
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_8EFE:
Chk2PZoneCompletion:
	moveq	#0,d0
	move.b	(Current_Zone_2P).w,d0
	; multiply d0 by 6
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	add.w	d0,d0
	lea	(Results_Data_2P).w,a5
	lea	(a5,d0.w),a5
	move.w	(a5),d0
	add.w	2(a5),d0
	rts
; End of function Chk2PZoneCompletion

; ---------------------------------------------------------------------------
; Subroutine to clear the old 2P level select selection
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_8F1C:
ClearOld2PLevSelSelection:
	moveq	#0,d0
	move.b	(Current_Zone_2P).w,d0
	lsl.w	#4,d0
	lea	(LevSel2PIconData).l,a3
	lea	(a3,d0.w),a3
	moveq	#palette_line_0,d0
	lea	(Chunk_Table+$1E0).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$22C).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$270).l,a2
	lea	(Chunk_Table+$498).l,a1
	bsr.w	Chk2PZoneCompletion
	bmi.s	+
	lea	(Chunk_Table+$468).l,a1
+
	moveq	#2,d1
-	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	lea	$1A(a2),a2
	dbf	d1,-

	lea	(Chunk_Table+$198).l,a1
	move.l	(a3)+,d0
	moveq	#17-1,d1
	moveq	#12-1,d2
	jmpto	JmpTo_PlaneMapToVRAM_H40
; End of function ClearOld2PLevSelSelection

; ===========================================================================
; off_8F7E:
LevSel2PIconData:

; macro to declare icon data for a 2P level select icon
iconData macro txtlabel,txtlabel2,vramAddr,iconPal,iconAddr
	dc.l txtlabel, txtlabel2	; text locations
	dc.l vdpComm(vramAddr,VRAM,WRITE)	; VRAM location to place data
	dc.l iconPal<<24|((iconAddr)&$FFFFFF)	; icon palette and plane data location
    endm

	iconData	Text2P_EmeraldHill,Text2P_Zone, VRAM_Plane_A_Name_Table+planeLoc(64,2,2),   0,Chunk_Table+$330
	iconData	Text2P_MysticCave, Text2P_Zone, VRAM_Plane_A_Name_Table+planeLoc(64,22,2),  5,Chunk_Table+$3A8
	iconData	Text2P_CasinoNight,Text2P_Zone, VRAM_Plane_A_Name_Table+planeLoc(64,2,15),  6,Chunk_Table+$3C0
	iconData	Text2P_Special,    Text2P_Stage,VRAM_Plane_A_Name_Table+planeLoc(64,22,15),12,Chunk_Table+$450

; ---------------------------------------------------------------------------
; Common menu screen subroutine for transferring text to RAM

; ARGUMENTS:
; d0 = starting art tile
; a1 = data source
; a2 = destination
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_8FBE:
MenuScreenTextToRAM:
	moveq	#0,d1
	move.b	(a1)+,d1
-	move.b	(a1)+,d0
	move.w	d0,(a2)+
	dbf	d1,-
	rts
; End of function MenuScreenTextToRAM

; ===========================================================================
