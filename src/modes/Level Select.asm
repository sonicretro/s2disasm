; loc_92F6:
MenuScreen_LevelSelect:
	; Load foreground (sans zone icon)
	lea	(Chunk_Table).l,a1
	lea	(MapEng_LevSel).l,a0	; 2 bytes per 8x8 tile, compressed
	move.w	#make_art_tile(ArtTile_VRAM_Start,0,0),d0
	bsr.w	EniDec

	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
	moveq	#40-1,d1
	moveq	#28-1,d2	; 40x28 = whole screen
	jsrto	JmpTo_PlaneMapToVRAM_H40	; display patterns

	; Draw sound test number
	moveq	#palette_line_0,d3
	bsr.w	LevelSelect_DrawSoundNumber

	; Load zone icon
	lea	(Chunk_Table+planeLoc(40,0,28)).l,a1
	lea	(MapEng_LevSelIcon).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_LevelSelectPics,0,0),d0
	bsr.w	EniDec

	bsr.w	LevelSelect_DrawIcon

	clr.w	(Player_mode).w
	clr.w	(Results_Screen_2P).w	; VsRSID_Act
	clr.b	(Level_started_flag).w
	clr.w	(Anim_Counters).w

	; Animate background (loaded back in MenuScreen)
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo2_Dynamic_Normal	; background

	moveq	#PalID_Menu,d0
	bsr.w	PalLoad_ForFade

	lea	(Normal_palette_line3).w,a1
	lea	(Target_palette_line3).w,a2

	moveq	#bytesToLcnt(palette_line_size),d1
-	move.l	(a1),(a2)+
	clr.l	(a1)+
	dbf	d1,-

	move.b	#MusID_Options,d0
	jsrto	JmpTo_PlayMusic

	move.w	#(30*60)-1,(Demo_Time_left).w	; 30 seconds
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

;loc_93AC:
LevelSelect_Main:	; routine running during level select
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint

	move	#$2700,sr

	moveq	#palette_line_0,d3
	bsr.w	LevelSelect_MarkFields	; unmark fields
	bsr.w	LevSelControls		; possible change selected fields
	move.w	#palette_line_3,d3
	bsr.w	LevelSelect_MarkFields	; mark fields

	bsr.w	LevelSelect_DrawIcon

	move	#$2300,sr

	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo2_Dynamic_Normal

	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0	; start pressed?
	bne.s	LevelSelect_PressStart	; yes
	bra.w	LevelSelect_Main	; no
; ===========================================================================

;loc_93F0:
LevelSelect_PressStart:
	move.w	(Level_select_zone).w,d0
	add.w	d0,d0
	move.w	LevelSelect_Order(pc,d0.w),d0
	bmi.w	LevelSelect_Return	; sound test
	cmpi.w	#$4000,d0
	bne.s	LevelSelect_StartZone

;LevelSelect_SpecialStage:
	move.b	#GameModeID_SpecialStage,(Game_Mode).w ; => SpecialStage
    if emerald_hill_zone_act_1=0
	clr.w	(Current_ZoneAndAct).w ; emerald_hill_zone_act_1
    else
	move.w	#emerald_hill_zone_act_1,(Current_ZoneAndAct).w
    endif
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
	move.w	(Player_option).w,(Player_mode).w
	rts
; ===========================================================================

;loc_944C:
LevelSelect_Return:
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ===========================================================================
; -----------------------------------------------------------------------------
; Level Select Level Order

; One entry per item in the level select menu. Just set the value for the item
; you want to link to the level/act number of the level you want to load when
; the player selects that item.
; -----------------------------------------------------------------------------
;Misc_9454:
LevelSelect_Order:
	dc.w	emerald_hill_zone_act_1
	dc.w	emerald_hill_zone_act_2	; 1
	dc.w	chemical_plant_zone_act_1	; 2
	dc.w	chemical_plant_zone_act_2	; 3
	dc.w	aquatic_ruin_zone_act_1	; 4
	dc.w	aquatic_ruin_zone_act_2	; 5
	dc.w	casino_night_zone_act_1	; 6
	dc.w	casino_night_zone_act_2	; 7
	dc.w	hill_top_zone_act_1	; 8
	dc.w	hill_top_zone_act_2	; 9
	dc.w	mystic_cave_zone_act_1	; 10
	dc.w	mystic_cave_zone_act_2	; 11
	dc.w	oil_ocean_zone_act_1	; 12
	dc.w	oil_ocean_zone_act_2	; 13
	dc.w	metropolis_zone_act_1	; 14
	dc.w	metropolis_zone_act_2	; 15
	dc.w	metropolis_zone_act_3	; 16
	dc.w	sky_chase_zone_act_1	; 17
	dc.w	wing_fortress_zone_act_1	; 18
	dc.w	death_egg_zone_act_1	; 19
	dc.w	$4000	; 20 - special stage
	dc.w	$FFFF	; 21 - sound test
; ===========================================================================

;loc_9480:
LevelSelect_StartZone:
	andi.w	#$3FFF,d0
	move.w	d0,(Current_ZoneAndAct).w
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
	move.b	#MusID_FadeOut,d0
	jsrto	JmpTo_PlaySound
	moveq	#0,d0
	move.w	d0,(Two_player_mode_copy).w
	move.w	d0,(Two_player_mode).w
	rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Change what you're selecting in the level select
; ---------------------------------------------------------------------------
; loc_94DC:
LevSelControls:
	move.b	(Ctrl_1_Press).w,d1
	andi.b	#button_up_mask|button_down_mask,d1
	bne.s	+	; up/down pressed
	subq.w	#1,(LevSel_HoldTimer).w
	bpl.s	LevSelControls_CheckLR

+
	move.w	#$B,(LevSel_HoldTimer).w
	move.b	(Ctrl_1_Held).w,d1
	andi.b	#button_up_mask|button_down_mask,d1
	beq.s	LevSelControls_CheckLR	; up/down not pressed, check for left & right
	move.w	(Level_select_zone).w,d0
	btst	#button_up,d1
	beq.s	+
	subq.w	#1,d0	; decrease by 1
	bcc.s	+	; >= 0?
	moveq	#$15,d0	; set to $15

+
	btst	#button_down,d1
	beq.s	+
	addq.w	#1,d0	; yes, add 1
	cmpi.w	#$16,d0
	blo.s	+	; smaller than $16?
	moveq	#0,d0	; if not, set to 0

+
	move.w	d0,(Level_select_zone).w
	rts
; ===========================================================================
; loc_9522:
LevSelControls_CheckLR:
	cmpi.w	#$15,(Level_select_zone).w	; are we in the sound test?
	bne.s	LevSelControls_SwitchSide	; no
	move.w	(Sound_test_sound).w,d0
	move.b	(Ctrl_1_Press).w,d1
	btst	#button_left,d1
	beq.s	+
	subq.b	#1,d0
	bcc.s	+
	moveq	#$7F,d0

+
	btst	#button_right,d1
	beq.s	+
	addq.b	#1,d0
	cmpi.w	#$80,d0
	blo.s	+
	moveq	#0,d0

+
	btst	#button_A,d1
	beq.s	+
	addi.b	#$10,d0
	andi.b	#$7F,d0

+
	move.w	d0,(Sound_test_sound).w
	andi.w	#button_B_mask|button_C_mask,d1
	beq.s	+	; rts
	move.w	(Sound_test_sound).w,d0
	addi.w	#$80,d0
	jsrto	JmpTo_PlayMusic
	lea	(debug_cheat).l,a0
	lea	(super_sonic_cheat).l,a2
	lea	(Debug_options_flag).w,a1	; Also S1_hidden_credits_flag
	moveq	#1,d2	; flag to tell the routine to enable the Super Sonic cheat
	bsr.w	CheckCheats

+
	rts
; ===========================================================================
; loc_958A:
LevSelControls_SwitchSide:	; not in soundtest, not up/down pressed
	move.b	(Ctrl_1_Press).w,d1
	andi.b	#button_left_mask|button_right_mask,d1
	beq.s	+				; no direction key pressed
	move.w	(Level_select_zone).w,d0	; left or right pressed
	move.b	LevelSelect_SwitchTable(pc,d0.w),d0 ; set selected zone according to table
	move.w	d0,(Level_select_zone).w
+
	rts
; ===========================================================================
;byte_95A2:
LevelSelect_SwitchTable:
	dc.b $E
	dc.b $F		; 1
	dc.b $11	; 2
	dc.b $11	; 3
	dc.b $12	; 4
	dc.b $12	; 5
	dc.b $13	; 6
	dc.b $13	; 7
	dc.b $14	; 8
	dc.b $14	; 9
	dc.b $15	; 10
	dc.b $15	; 11
	dc.b $C		; 12
	dc.b $D		; 13
	dc.b 0		; 14
	dc.b 1		; 15
	dc.b 1		; 16
	dc.b 2		; 17
	dc.b 4		; 18
	dc.b 6		; 19
	dc.b 8		; 20
	dc.b $A		; 21
	even
; ===========================================================================

;loc_95B8:
LevelSelect_MarkFields:
	lea	(Chunk_Table).l,a4
	lea	(LevSel_MarkTable).l,a5
	lea	(VDP_data_port).l,a6
	moveq	#0,d0
	move.w	(Level_select_zone).w,d0
	lsl.w	#2,d0
	lea	(a5,d0.w),a3
	moveq	#0,d0
	move.b	(a3),d0
	mulu.w	#$50,d0
	moveq	#0,d1
	move.b	1(a3),d1
	add.w	d1,d0
	lea	(a4,d0.w),a1
	moveq	#0,d1
	move.b	(a3),d1
	lsl.w	#7,d1
	add.b	1(a3),d1
	addi.w	#VRAM_Plane_A_Name_Table,d1
	lsl.l	#2,d1
	lsr.w	#2,d1
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d1
	swap	d1
	move.l	d1,4(a6)

	moveq	#$D,d2
-	move.w	(a1)+,d0
	add.w	d3,d0
	move.w	d0,(a6)
	dbf	d2,-

	addq.w	#2,a3
	moveq	#0,d0
	move.b	(a3),d0
	beq.s	+
	mulu.w	#$50,d0
	moveq	#0,d1
	move.b	1(a3),d1
	add.w	d1,d0
	lea	(a4,d0.w),a1
	moveq	#0,d1
	move.b	(a3),d1
	lsl.w	#7,d1
	add.b	1(a3),d1
	addi.w	#VRAM_Plane_A_Name_Table,d1
	lsl.l	#2,d1
	lsr.w	#2,d1
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d1
	swap	d1
	move.l	d1,4(a6)
	move.w	(a1)+,d0
	add.w	d3,d0
	move.w	d0,(a6)

+
	cmpi.w	#$15,(Level_select_zone).w
	bne.s	+	; rts
	bsr.w	LevelSelect_DrawSoundNumber
+
	rts
; ===========================================================================
;loc_965A:
LevelSelect_DrawSoundNumber:
	move.l	#vdpComm(VRAM_Plane_A_Name_Table+planeLoc(64,34,18),VRAM,WRITE),(VDP_control_port).l
	move.w	(Sound_test_sound).w,d0
	move.b	d0,d2
	lsr.b	#4,d0
	bsr.s	+
	move.b	d2,d0

+
	andi.w	#$F,d0
	cmpi.b	#$A,d0
	blo.s	+
	addi.b	#4,d0

+
	addi.b	#$10,d0
	add.w	d3,d0
	move.w	d0,(a6)
	rts
; ===========================================================================

;loc_9688:
LevelSelect_DrawIcon:
	move.w	(Level_select_zone).w,d0
	lea	(LevSel_IconTable).l,a3
	lea	(a3,d0.w),a3
	lea	(Chunk_Table+planeLoc(40,0,28)).l,a1
	moveq	#0,d0
	move.b	(a3),d0
	lsl.w	#3,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	lea	(a1,d0.w),a1
	move.l	#vdpComm(VRAM_Plane_A_Name_Table+planeLoc(64,27,22),VRAM,WRITE),d0
	moveq	#4-1,d1
	moveq	#3-1,d2
	jsrto	JmpTo_PlaneMapToVRAM_H40
	lea	(Pal_LevelIcons).l,a1
	moveq	#0,d0
	move.b	(a3),d0
	lsl.w	#5,d0
	lea	(a1,d0.w),a1
	lea	(Normal_palette_line3).w,a2

    if fixBugs
	; When the icon changes, the colours are briefly incorrect. This is
	; because there's a delay between the icon being updated and the
	; colours being updated, due to the colours being uploaded to the VDP
	; during V-Int. To avoid this we can upload the colours ourselves right
	; here.
	; Prepare the VDP for data transfer.
	move.l  #vdpComm(2*16*2,CRAM,WRITE),VDP_control_port-VDP_data_port(a6)
    endif

	moveq	#bytesToLcnt(palette_line_size),d1
-
    if fixBugs
	; Upload colours to the VDP.
	move.l	(a1),(a6)
    endif
	move.l	(a1)+,(a2)+
	dbf	d1,-

	rts
; ===========================================================================
;byte_96D8
LevSel_IconTable:
	dc.b   0,0	;0	EHZ
	dc.b   7,7	;2	CPZ
	dc.b   8,8	;4	ARZ
	dc.b   6,6	;6	CNZ
	dc.b   2,2	;8	HTZ
	dc.b   5,5	;$A	MCZ
	dc.b   4,4	;$C	OOZ
	dc.b   1,1,1	;$E	MTZ
	dc.b   9	;$11	SCZ
	dc.b  $A	;$12	WFZ
	dc.b  $B	;$13	DEZ
	dc.b  $C	;$14	Special Stage
	dc.b  $E	;$15	Sound Test
	even
;byte_96EE:
LevSel_MarkTable:	; 4 bytes per level select entry
; line primary, 2*column ($E fields), line secondary, 2*column secondary (1 field)
	dc.b   3,  6,  3,$24	;0
	dc.b   3,  6,  4,$24
	dc.b   6,  6,  6,$24
	dc.b   6,  6,  7,$24
	dc.b   9,  6,  9,$24	;4
	dc.b   9,  6, $A,$24
	dc.b  $C,  6, $C,$24
	dc.b  $C,  6, $D,$24
	dc.b  $F,  6, $F,$24	;8
	dc.b  $F,  6,$10,$24
	dc.b $12,  6,$12,$24
	dc.b $12,  6,$13,$24
	dc.b $15,  6,$15,$24	;$C
	dc.b $15,  6,$16,$24
; --- second column ---
	dc.b   3,$2C,  3,$48
	dc.b   3,$2C,  4,$48
	dc.b   3,$2C,  5,$48	;$10
	dc.b   6,$2C,  0,  0
	dc.b   9,$2C,  0,  0
	dc.b  $C,$2C,  0,  0
	dc.b  $F,$2C,  0,  0	;$14
	dc.b $12,$2C,$12,$48
; ===========================================================================
