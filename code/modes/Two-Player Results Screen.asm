; ===========================================================================
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
	moveq	#$27,d1
	moveq	#$1B,d2
	jsrto	PlaneMapToVRAM_H40, PlaneMapToVRAM_H40
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
	moveq	#$27,d1
	moveq	#$1B,d2
	jsrto	PlaneMapToVRAM_H40, PlaneMapToVRAM_H40
	clr.w	(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	clr.b	(Level_started_flag).w
	clr.w	(Anim_Counters).w
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	Dynamic_Normal, JmpTo_Dynamic_Normal
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
	jsrto	Dynamic_Normal, JmpTo_Dynamic_Normal
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
; ----------------------------------------------------------------------------
; Object 21 - Score/Rings/Time display (in 2P results)
; ----------------------------------------------------------------------------
; Sprite_80BE:
Obj21: ; (screen-space obj)
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj21_Index(pc,d0.w),d1
	jmp	Obj21_Index(pc,d1.w)
; ===========================================================================
; JmpTbl_80CC: Obj21_States:
Obj21_Index:	offsetTable
		offsetTableEntry.w Obj21_Init	; 0
		offsetTableEntry.w Obj21_Main	; 2
; ---------------------------------------------------------------------------
; word_80D0:
Obj21_PositionTable:
	;      x,    y
	dc.w $F0, $148
	dc.w $F0, $130
	dc.w $E0, $148
	dc.w $F0, $148
	dc.w $F0, $148
; ===========================================================================
; loc_80E4:
Obj21_Init:
	addq.b	#2,routine(a0) ; => Obj21_Main
	move.w	(Results_Screen_2P).w,d0
	add.w	d0,d0
	add.w	d0,d0
	move.l	Obj21_PositionTable(pc,d0.w),x_pixel(a0) ; and y_pixel(a0)
	move.l	#Obj21_MapUnc_8146,mappings(a0)
 	move.w	#make_art_tile(ArtTile_ArtNem_1P2PWins,0,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo2_Adjust2PArtPointer
	move.b	#0,render_flags(a0)
	move.b	#0,priority(a0)
	moveq	#2,d1
	move.b	(SS_Total_Won).w,d0	; d0 = SS_Total_Won_1P
	sub.b	(SS_Total_Won+1).w,d0	;    - SS_Total_Won_2P
	beq.s	++
	bcs.s	+
	moveq	#0,d1
	bra.s	++
; ---------------------------------------------------------------------------
+
	moveq	#1,d1
+
	move.b	d1,mapping_frame(a0)

; loc_812C:
Obj21_Main:
	andi.w	#tile_mask,art_tile(a0)
	btst	#3,(Vint_runcount+3).w
	beq.s	JmpTo4_DisplaySprite
	ori.w	#palette_line_1,art_tile(a0)

JmpTo4_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
; ===========================================================================
; --------------------------------------------------------------------------
; sprite mappings
; --------------------------------------------------------------------------
Obj21_MapUnc_8146:	include "mappings/sprite/obj21.asm"
; ===========================================================================

; loc_819A:
Setup2PResults_Act:
	move.w	#$1F2,d2
	moveq	#0,d0
	bsr.w	sub_8672
	move.w	#$216,d2
	moveq	#0,d1
	move.b	(Current_Act_2P).w,d1
	addq.b	#1,d1
	bsr.w	sub_86B0
	move.w	#$33E,d2
	move.l	(Score).w,d1
	bsr.w	sub_86F6
	move.w	#$352,d2
	move.l	(Score_2P).w,d1
	bsr.w	sub_86F6
	move.w	#$3DA,d2
	moveq	#0,d0
	move.w	(Timer_minute_word).w,d1
	bsr.w	sub_86B0
	move.w	#$3E0,d2
	moveq	#0,d1
	move.b	(Timer_second).w,d1
	bsr.w	sub_86B0
	move.w	#$3E6,d2
	moveq	#0,d1
	move.b	(Timer_frame).w,d1
	mulu.w	#$1B0,d1
	lsr.l	#8,d1
	bsr.w	sub_86B0
	move.w	#$3EE,d2
	moveq	#0,d0
	move.w	(Timer_minute_word_2P).w,d1
	bsr.w	sub_86B0
	move.w	#$3F4,d2
	moveq	#0,d1
	move.b	(Timer_second_2P).w,d1
	bsr.w	sub_86B0
	move.w	#$3FA,d2
	moveq	#0,d1
	move.b	(Timer_frame_2P).w,d1
	mulu.w	#$1B0,d1
	lsr.l	#8,d1
	bsr.w	sub_86B0
	move.w	#$486,d2
	moveq	#0,d0
	move.w	(Ring_count).w,d1
	bsr.w	sub_86B0
	move.w	#$49A,d2
	move.w	(Ring_count_2P).w,d1
	bsr.w	sub_86B0
	move.w	#$526,d2
	moveq	#0,d0
	move.w	(Rings_Collected).w,d1
	bsr.w	sub_86B0
	move.w	#$53A,d2
	move.w	(Rings_Collected_2P).w,d1
	bsr.w	sub_86B0
	move.w	#$5C6,d2
	moveq	#0,d0
	move.w	(Monitors_Broken).w,d1
	bsr.w	sub_86B0
	move.w	#$5DA,d2
	move.w	(Monitors_Broken_2P).w,d1
	bsr.w	sub_86B0
	bsr.w	sub_8476
	move.w	#$364,d2
	move.w	#$6000,d0
	move.l	(Score).w,d1
	sub.l	(Score_2P).w,d1
	bsr.w	sub_8652
	move.w	#$404,d2
	move.l	(Timer_2P).w,d1
	sub.l	(Timer).w,d1
	bsr.w	sub_8652
	move.w	#$4A4,d2
	moveq	#0,d1
	move.w	(Ring_count).w,d1
	sub.w	(Ring_count_2P).w,d1
	bsr.w	sub_8652
	move.w	#$544,d2
	moveq	#0,d1
	move.w	(Rings_Collected).w,d1
	sub.w	(Rings_Collected_2P).w,d1
	bsr.w	sub_8652
	move.w	#$5E4,d2
	moveq	#0,d1
	move.w	(Monitors_Broken).w,d1
	sub.w	(Monitors_Broken_2P).w,d1
	bsr.w	sub_8652
	move.w	#$706,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a4),d1
	bsr.w	sub_86B0
	move.w	#$70E,d2
	moveq	#0,d1
	move.b	1(a4),d1
	bsr.w	sub_86B0
	move.w	(a4),(SS_Total_Won).w
	rts
; ===========================================================================
; loc_82FA:
Setup2PResults_Zone:
	move.w	#$242,d2
	moveq	#0,d0
	bsr.w	sub_8672
	bsr.w	sub_84A4
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	move.w	#$398,d6
	bsr.w	sub_854A
	move.w	#$488,d6
	bsr.w	sub_854A
	move.w	#$618,d6
	bsr.w	sub_854A
	rts
; ===========================================================================
; loc_8328:
Setup2PResults_Game:
	lea	(Results_Data_2P).w,a5
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	move.w	#$208,d6
	bsr.w	sub_84C4
	move.w	#$258,d6
	bsr.w	sub_84C4
	move.w	#$2A8,d6
	bsr.w	sub_84C4
	move.w	#$348,d6
	bsr.w	sub_84C4
	move.w	#$398,d6
	bsr.w	sub_84C4
	move.w	#$3E8,d6
	bsr.w	sub_84C4
	move.w	#$488,d6
	bsr.w	sub_84C4
	move.w	#$4D8,d6
	bsr.w	sub_84C4
	move.w	#$528,d6
	bsr.w	sub_84C4
	move.w	#$5C8,d6
	bsr.w	sub_84C4
	move.w	#$618,d6
	bsr.w	sub_84C4
	move.w	#$668,d6
	bsr.w	sub_84C4
	move.w	#$70A,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a4),d1
	bsr.w	sub_86B0
	move.w	#$710,d2
	moveq	#0,d1
	move.b	1(a4),d1
	bsr.w	sub_86B0
	rts
; ===========================================================================
; loc_83B0:
Setup2PResults_SpecialAct:
	move.w	#$266,d2
	moveq	#0,d1
	move.b	(Current_Act_2P).w,d1
	addq.b	#1,d1
	bsr.w	sub_86B0
	move.w	#$4D6,d2
	moveq	#0,d0
	move.w	(SS2p_RingBuffer).w,d1		; P1 SS act 1 rings
	bsr.w	sub_86B0
	move.w	#$4E6,d2
	move.w	(SS2p_RingBuffer+2).w,d1	; P2 SS act 1 rings
	bsr.w	sub_86B0
	move.w	#$576,d2
	moveq	#0,d0
	move.w	(SS2p_RingBuffer+4).w,d1	; P1 SS act 2 rings
	bsr.w	sub_86B0
	move.w	#$586,d2
	move.w	(SS2p_RingBuffer+6).w,d1	; P2 SS act 2 rings
	bsr.w	sub_86B0
	move.w	#$616,d2
	moveq	#0,d0
	move.w	(SS2p_RingBuffer+8).w,d1	; P1 SS act 3 rings
	bsr.w	sub_86B0
	move.w	#$626,d2
	move.w	(SS2p_RingBuffer+$A).w,d1	; P2 SS act 3 rings
	bsr.w	sub_86B0
	bsr.w	sub_8476
	move.w	#$6000,d0
	move.w	#$4F0,d2
	moveq	#0,d1
	move.w	(SS2p_RingBuffer).w,d1		; P1 SS act 1 rings
	sub.w	(SS2p_RingBuffer+2).w,d1	; P2 SS act 1 rings
	bsr.w	sub_8652
	move.w	#$590,d2
	moveq	#0,d1
	move.w	(SS2p_RingBuffer+4).w,d1	; P1 SS act 2 rings
	sub.w	(SS2p_RingBuffer+6).w,d1	; P2 SS act 2 rings
	bsr.w	sub_8652
	move.w	#$630,d2
	moveq	#0,d1
	move.w	(SS2p_RingBuffer+8).w,d1	; P1 SS act 3 rings
	sub.w	(SS2p_RingBuffer+$A).w,d1	; P2 SS act 3 rings
	bsr.w	sub_8652
	move.w	(a4),(SS_Total_Won).w
	rts
; ===========================================================================
; loc_8452:
Setup2PResults_SpecialZone:
	bsr.w	sub_84A4
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	move.w	#$4D4,d6
	bsr.w	sub_85CE
	move.w	#$574,d6
	bsr.w	sub_85CE
	move.w	#$614,d6
	bsr.w	sub_85CE
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_8476:
	lea	(EHZ_Results_2P).w,a4
	move.b	(Current_Zone_2P).w,d0
	beq.s	+
	lea	(MCZ_Results_2P).w,a4
	subq.b	#1,d0
	beq.s	+
	lea	(CNZ_Results_2P).w,a4
	subq.b	#1,d0
	beq.s	+
	lea	(SS_Results_2P).w,a4
+
	moveq	#0,d0
	move.b	(Current_Act_2P).w,d0
	add.w	d0,d0
	lea	(a4,d0.w),a4
	clr.w	(a4)
	rts
; End of function sub_8476


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_84A4:
	lea	(EHZ_Results_2P).w,a5
	move.b	(Current_Zone_2P).w,d0
	beq.s	+	; rts
	lea	(MCZ_Results_2P).w,a5
	subq.b	#1,d0
	beq.s	+	; rts
	lea	(CNZ_Results_2P).w,a5
	subq.b	#1,d0
	beq.s	+	; rts
	lea	(SS_Results_2P).w,a5
+
	rts
; End of function sub_84A4


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_84C4:
	move.w	(a5),d0
	bmi.s	+
	move.w	d6,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a5),d1
	bsr.w	sub_86B0
	addq.w	#8,d6
	move.w	d6,d2
	moveq	#0,d1
	move.b	1(a5),d1
	bsr.w	sub_86B0
	addi.w	#$12,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; ===========================================================================
+
	addq.w	#4,d6
	not.w	d0
	bne.s	+
	lea	(Text2P_NoGame).l,a1
	move.w	d6,d2
	bsr.w	loc_8698
	addi.w	#$16,d6
	move.w	d6,d2
	lea	(Text2P_Blank).l,a1
	bsr.w	loc_8698
	addq.w	#2,a5
	rts
; ===========================================================================
+
	moveq	#0,d0
	lea	(Text2P_GameOver).l,a1
	move.w	d6,d2
	bsr.w	loc_8698
	addi.w	#$16,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; End of function sub_84C4


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_854A:
	move.w	(a5),d0
	bmi.s	loc_8582
	move.w	d6,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a5),d1
	bsr.w	sub_86B0
	addq.w	#8,d6
	move.w	d6,d2
	moveq	#0,d1
	move.b	1(a5),d1
	bsr.w	sub_86B0
	addi.w	#$C,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; ===========================================================================

loc_8582:
	not.w	d0
	bne.s	loc_85A6
	lea	(Text2P_NoGame).l,a1
	move.w	d6,d2
	bsr.w	loc_8698
	addi.w	#$14,d6
	move.w	d6,d2
	lea	(Text2P_Blank).l,a1
	bsr.w	loc_8698
	addq.w	#2,a5
	rts
; ===========================================================================

loc_85A6:
	moveq	#0,d0
	lea	(Text2P_GameOver).l,a1
	move.w	d6,d2
	bsr.w	loc_8698
	addi.w	#$14,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; End of function sub_854A


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_85CE:
	move.w	(a5),d0
	bmi.s	+
	move.w	d6,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a5),d1
	bsr.w	sub_86B0
	addi.w	#$C,d6
	move.w	d6,d2
	moveq	#0,d1
	move.b	1(a5),d1
	bsr.w	sub_86B0
	addi.w	#$10,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; ===========================================================================
+
	not.w	d0
	bne.s	loc_862C
	lea	(Text2P_NoGame).l,a1
	move.w	d6,d2
	addq.w	#4,d2
	bsr.w	loc_8698
	addi.w	#$14,d6
	move.w	d6,d2
	lea	(Text2P_Blank).l,a1
	bsr.s	loc_8698
	addq.w	#2,a5
	rts
; ===========================================================================

loc_862C:
	moveq	#0,d0
	lea	(Text2P_GameOver).l,a1
	move.w	d6,d2
	bsr.s	loc_8698
	addi.w	#$14,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; End of function sub_85CE


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_8652:
	lea	(Text2P_Tied).l,a1
	beq.s	++
	bcs.s	+
	lea	(Text2P_1P).l,a1
	addq.b	#1,(a4)
	bra.s	++
; ===========================================================================
+
	lea	(Text2P_2P).l,a1
	addq.b	#1,1(a4)
+
	bra.s	loc_8698
; End of function sub_8652


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_8672:
	lea	(Text2P_EmeraldHill).l,a1
	move.b	(Current_Zone_2P).w,d1
	beq.s	loc_8698
	lea	(Text2P_MysticCave).l,a1
	subq.b	#1,d1
	beq.s	loc_8698
	lea	(Text2P_CasinoNight).l,a1
	subq.b	#1,d1
	beq.s	loc_8698
	lea	(Text2P_SpecialStage).l,a1

loc_8698:
	lea	(Chunk_Table).l,a2
	lea	(a2,d2.w),a2
	moveq	#0,d1

	move.b	(a1)+,d1
-	move.b	(a1)+,d0
	move.w	d0,(a2)+
	dbf	d1,-

	rts
; End of function sub_8672


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_86B0:
	lea	(Chunk_Table).l,a2
	lea	(a2,d2.w),a2
	lea	(word_86F0).l,a3
	moveq	#0,d2

	moveq	#2,d5
-	moveq	#0,d3
	move.w	(a3)+,d4

-	sub.w	d4,d1
	bcs.s	+
	addq.w	#1,d3
	bra.s	-
; ---------------------------------------------------------------------------
+
	add.w	d4,d1
	tst.w	d5
	beq.s	++
	tst.w	d3
	beq.s	+
	moveq	#1,d2
+
	tst.w	d2
	beq.s	++
+
	addi.b	#$10,d3
	move.b	d3,d0
	move.w	d0,(a2)
+
	addq.w	#2,a2
	dbf	d5,--

	rts
; End of function sub_86B0

; ===========================================================================
word_86F0:
	dc.w   100
	dc.w	10	; 1
	dc.w	 1	; 2

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_86F6:
	lea	(Chunk_Table).l,a2
	lea	(a2,d2.w),a2
	lea	(dword_8732).l,a3
	moveq	#0,d2

	moveq	#5,d5
-	moveq	#0,d3
	move.l	(a3)+,d4

-	sub.l	d4,d1
	bcs.s	+
	addq.w	#1,d3
	bra.s	-
; ===========================================================================
+
	add.l	d4,d1
	tst.w	d3
	beq.s	+
	moveq	#1,d2
+
	tst.w	d2
	beq.s	+
	addi.b	#$10,d3
	move.b	d3,d0
	move.w	d0,(a2)
+
	addq.w	#2,a2
	dbf	d5,--

	rts
; End of function sub_86F6

; ===========================================================================
dword_8732:
	dc.l 100000
	dc.l  10000
	dc.l   1000
	dc.l    100
	dc.l     10
	dc.l      1

	; set the character set for menu text
	charset '@',"\27\30\31\32\33\34\35\36\37\38\39\40\41\42\43\44\45\46\47\48\49\50\51\52\53\54\55"
	charset '0',"\16\17\18\19\20\21\22\23\24\25"
	charset '*',$1A
	charset ':',$1C
	charset '.',$1D
	charset ' ',0

	; Menu text
Text2P_EmeraldHill:	menutxt	"EMERALD HILL"	; byte_874A:
	rev02even
Text2P_MysticCave:	menutxt	" MYSTIC CAVE"	; byte_8757:
	rev02even
Text2P_CasinoNight:	menutxt	"CASINO NIGHT"	; byte_8764:
	rev02even
Text2P_SpecialStage:	menutxt	"SPECIAL STAGE"	; byte_8771:
	rev02even
Text2P_Special:		menutxt	"   SPECIAL  "	; byte_877F:
	rev02even
Text2P_Zone:		menutxt	"ZONE "		; byte_878C:
	rev02even
Text2P_Stage:		menutxt	"STAGE"		; byte_8792:
	rev02even
Text2P_GameOver:	menutxt	"GAME OVER"	; byte_8798:
	rev02even
Text2P_TimeOver:	menutxt	"TIME OVER"
	rev02even
Text2P_NoGame:		menutxt	"NO GAME"	; byte_87AC:
	rev02even
Text2P_Tied:		menutxt	"TIED"		; byte_87B4:
	rev02even
Text2P_1P:		menutxt	" 1P"		; byte_87B9:
	rev02even
Text2P_2P:		menutxt	" 2P"		; byte_87BD:
	rev02even
Text2P_Blank:		menutxt	"    "		; byte_87C1:
	rev02even

	charset ; reset character set

; ------------------------------------------------------------------------
; MENU ANIMATION SCRIPT
; ------------------------------------------------------------------------
;word_87C6:
Anim_SonicMilesBG:	zoneanimstart
	; Sonic/Miles animated background
	zoneanimdecl  -1, ArtUnc_MenuBack,    1,  6, $A
	dc.b   0,$C7
	dc.b  $A,  5
	dc.b $14,  5
	dc.b $1E,$C7
	dc.b $14,  5
	dc.b  $A,  5
	even

	zoneanimend

; off_87DC:
TwoPlayerResultsPointers:
VsResultsScreen_Act:	dc.l Map_2PActResults, Setup2PResults_Act
VsResultsScreen_Zone:	dc.l Map_2PZoneResults, Setup2PResults_Zone
VsResultsScreen_Game:	dc.l Map_2PGameResults, Setup2PResults_Game
VsResultsScreen_SS:	dc.l Map_2PSpecialStageActResults, Setup2PResults_SpecialAct
VsResultsScreen_SSZone:	dc.l Map_2PSpecialStageZoneResults, Setup2PResults_SpecialZone

; 2P single act results screen (enigma compressed)
; byte_8804:
Map_2PActResults:	BINCLUDE "mappings/misc/2P Act Results.eni"

; 2P zone results screen (enigma compressed)
; byte_88CE:
Map_2PZoneResults:	BINCLUDE "mappings/misc/2P Zone Results.eni"

; 2P game results screen (after all 4 zones) (enigma compressed)
; byte_8960:
Map_2PGameResults:	BINCLUDE "mappings/misc/2P Game Results.eni"

; 2P special stage act results screen (enigma compressed)
; byte_8AA4:
Map_2PSpecialStageActResults:	BINCLUDE "mappings/misc/2P Special Stage Act Results.eni"

; 2P special stage zone results screen (enigma compressed)
; byte_8B30:
Map_2PSpecialStageZoneResults:	BINCLUDE "mappings/misc/2P Special Stage Zone Results.eni"

	even

    if ~~removeJmpTos
JmpTo2_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo_Dynamic_Normal ; JmpTo
	jmp	(Dynamic_Normal).l

	align 4
    endif
