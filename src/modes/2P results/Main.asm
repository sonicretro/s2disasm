; loc_7D50:
TwoPlayerResults:
	bsr.w	Pal_FadeToBlack
	move	#$2700,sr
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	ClearScreen
	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_Menu_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $E000
	move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled
	move.w	#$9001,(a6)		; Scroll table size: 64x32

	clearRAM Object_Display_Lists,Object_Display_Lists_End
	clearRAM Object_RAM,Object_RAM_End

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_FontStuff),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_FontStuff).l,a0
	bsr.w	NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_1P2PWins),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_1P2PWins).l,a0
	bsr.w	NemDec
	lea	(Chunk_Table).l,a1
	lea	(MapEng_MenuBack).l,a0
	move.w	#make_art_tile(ArtTile_VRAM_Start,3,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
	moveq	#40-1,d1
	moveq	#28-1,d2
    if removeJmpTos
	jsr	(PlaneMapToVRAM_H40).l
    else
	bsr.w	PlaneMapToVRAM_H40
    endif
	move.w	(Results_Screen_2P).w,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,d0
	lea	TwoPlayerResultsPointers(pc),a2
	movea.l	(a2,d0.w),a0
	movea.l	4(a2,d0.w),a2
	lea	(Chunk_Table).l,a1
	move.w	#make_art_tile(ArtTile_VRAM_Start,0,0),d0
	bsr.w	EniDec
	jsr	(a2)	; dynamic call! to Setup2PResults_Act, Setup2PResults_Zone, Setup2PResults_Game, Setup2PResults_SpecialAct, or Setup2PResults_SpecialZone, assuming the pointers in TwoPlayerResultsPointers have not been changed
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(tiles_to_bytes(ArtTile_TwoPlayerResults),VRAM,WRITE),d0
	moveq	#40-1,d1
	moveq	#28-1,d2
    if removeJmpTos
	jsr	(PlaneMapToVRAM_H40).l
    else
	bsr.w	PlaneMapToVRAM_H40
    endif
	clr.w	(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	clr.b	(Level_started_flag).w
	clr.w	(Anim_Counters).w
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo_Dynamic_Normal
	moveq	#PLCID_Std1,d0
	bsr.w	LoadPLC2
	moveq	#PalID_Menu,d0
	bsr.w	PalLoad_ForFade
	moveq	#0,d0
	move.b	#MusID_2PResult,d0
	cmp.w	(Level_Music).w,d0
	beq.s	+
	move.w	d0,(Level_Music).w
	bsr.w	PlayMusic
+
	move.w	#(30*60)-1,(Demo_Time_left).w	; 30 seconds
	clr.w	(Two_player_mode).w
	clr.l	(Camera_X_pos).w
	clr.l	(Camera_Y_pos).w
	clr.l	(Vscroll_Factor).w
	clr.l	(Vscroll_Factor_P2).w
	clr.l	(Vscroll_Factor_P2_HInt).w
	move.b	#ObjID_2PResults,(VSResults_HUD+id).w
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromBlack

-	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo_Dynamic_Normal
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	bsr.w	RunPLC_RAM
	tst.l	(Plc_Buffer).w
	bne.s	-
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0
	beq.s	-			; stay on that screen until either player presses start

	move.w	(Results_Screen_2P).w,d0 ; were we at the act results screen? (VsRSID_Act)
	bne.w	TwoPlayerResultsDone_Zone ; if not, branch
	tst.b	(Current_Act).w		; did we just finish act 1?
	bne.s	+			; if not, branch
	addq.b	#1,(Current_Act).w	; go to the next act
	move.b	#1,(Current_Act_2P).w
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	move.b	#0,(Last_star_pole_hit).w
	move.b	#0,(Last_star_pole_hit_2P).w
	moveq	#1,d0
	move.w	d0,(Two_player_mode).w
	move.w	d0,(Two_player_mode_copy).w
	moveq	#0,d0
	move.l	d0,(Score).w
	move.l	d0,(Score_2P).w
	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w
	rts
; ===========================================================================
+	; Displays results for the zone
	move.b	#2,(Current_Act_2P).w
	bsr.w	sub_84A4
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	bsr.s	sub_7F9A
	bsr.s	sub_7F9A
	move.b	(a4),d1
	sub.b	1(a4),d1
	beq.s	+		; if there's a tie, branch
	move.w	#VsRSID_Zone,(Results_Screen_2P).w
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	rts
; ===========================================================================
+	; There's a tie, play a special stage
	move.b	(Current_Zone_2P).w,d0
	addq.b	#1,d0
	move.b	d0,(Current_Special_Stage).w
	move.w	#VsRSID_SS,(Results_Screen_2P).w
	move.b	#1,(f_bigring).w
	move.b	#GameModeID_SpecialStage,(Game_Mode).w ; => SpecialStage
	moveq	#1,d0
	move.w	d0,(Two_player_mode).w
	move.w	d0,(Two_player_mode_copy).w
	move.b	#0,(Last_star_pole_hit).w
	move.b	#0,(Last_star_pole_hit_2P).w
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_7F9A:
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	beq.s	++
	bcs.s	+
	addq.b	#1,(a4)
	bra.s	++
; ===========================================================================
+
	addq.b	#1,1(a4)
+
	addq.w	#2,a5
	rts
; End of function sub_7F9A

; ===========================================================================

; loc_7FB2:
TwoPlayerResultsDone_Zone:
	subq.w	#1,d0			; were we at the zone results screen? (VsRSID_Zone)
	bne.s	TwoPlayerResultsDone_Game ; if not, branch

; loc_7FB6:
TwoPlayerResultsDone_ZoneOrSpecialStages:
	lea	(Results_Data_2P).w,a4
	moveq	#0,d0
	moveq	#0,d1
    rept 3
	move.w	(a4)+,d0
	add.l	d0,d1
	move.w	(a4)+,d0
	add.l	d0,d1
	addq.w	#2,a4
    endm
	move.w	(a4)+,d0
	add.l	d0,d1
	move.w	(a4)+,d0
	add.l	d0,d1
	swap	d1
	tst.w	d1	; have all levels been completed?
	bne.s	+	; if not, branch
	move.w	#VsRSID_Game,(Results_Screen_2P).w
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	rts
; ===========================================================================
+
	tst.w	(Game_Over_2P).w
	beq.s	+		; if there's a Game Over, clear the results
	lea	(Results_Data_2P).w,a1

	moveq	#bytesToWcnt(Results_Data_2P_End-Results_Data_2P),d0
-	move.w	#-1,(a1)+
	dbf	d0,-

	move.b	#3,(Life_count).w
	move.b	#3,(Life_count_2P).w
+
	move.b	#GameModeID_2PLevelSelect,(Game_Mode).w ; => LevelSelectMenu2P
	rts
; ===========================================================================
; loc_8020:
TwoPlayerResultsDone_Game:
	subq.w	#1,d0	; were we at the game results screen? (VsRSID_Game)
	bne.s	TwoPlayerResultsDone_SpecialStage ; if not, branch
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ===========================================================================
; loc_802C:
TwoPlayerResultsDone_SpecialStage:
	subq.w	#1,d0			; were we at the special stage results screen? (VsRSID_SS)
	bne.w	TwoPlayerResultsDone_SpecialStages ; if not, branch
	cmpi.b	#3,(Current_Zone_2P).w	; do we come from the special stage "zone"?
	beq.s	+			; if yes, branch
	move.w	#VsRSID_Zone,(Results_Screen_2P).w ; show zone results after tiebreaker special stage
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	rts
; ===========================================================================
+
	tst.b	(Current_Act_2P).w
	beq.s	+
	cmpi.b	#2,(Current_Act_2P).w
	beq.s	loc_80AC
	bsr.w	sub_84A4
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	bsr.s	sub_8094
	bsr.s	sub_8094
	move.b	(a4),d1
	sub.b	1(a4),d1
	bne.s	loc_80AC
+
	addq.b	#1,(Current_Act_2P).w
	addq.b	#1,(Current_Special_Stage).w
	move.w	#VsRSID_SS,(Results_Screen_2P).w
	move.b	#1,(f_bigring).w
	move.b	#GameModeID_SpecialStage,(Game_Mode).w ; => SpecialStage
	move.w	#1,(Two_player_mode).w
	move.w	#0,(Level_Music).w
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_8094:
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	beq.s	++
	bcs.s	+
	addq.b	#1,(a4)
	bra.s	++
; ===========================================================================
+
	addq.b	#1,1(a4)
+
	addq.w	#2,a5
	rts
; End of function sub_8094

; ===========================================================================

loc_80AC:
	move.w	#VsRSID_SSZone,(Results_Screen_2P).w
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	rts
; ===========================================================================
; loc_80BA: BranchTo_loc_7FB6:
TwoPlayerResultsDone_SpecialStages:
	; we were at the special stages results screen (VsRSID_SSZone)
	bra.w	TwoPlayerResultsDone_ZoneOrSpecialStages

; ===========================================================================
