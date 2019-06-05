; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Game Mode: Special Stage
; ----------------------------------------------------------------------------
; loc_4F64:
SpecialStage:
	cmpi.b	#7,(Current_Special_Stage).w
	blo.s	+
	move.b	#0,(Current_Special_Stage).w
+
	move.w	#SndID_SpecStageEntry,d0 ; play that funky special stage entry sound
	bsr.w	PlaySound
	move.b	#MusID_FadeOut,d0 ; fade out the music
	bsr.w	PlayMusic
	bsr.w	Pal_FadeToWhite
	tst.w	(Two_player_mode).w
	beq.s	+
	move.w	#0,(Two_player_mode).w
	st.b	(SS_2p_Flag).w ; set to -1
	bra.s	++
; ===========================================================================
+
	sf.b	(SS_2p_Flag).w ; set to 0
; (!)
+
	move	#$2700,sr		; Mask all interrupts
	lea	(VDP_control_port).l,a6
	move.w	#$8B03,(a6)		; EXT-INT disabled, V scroll by screen, H scroll by line
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8ADF,(Hint_counter_reserve).w	; H-INT every 224th scanline
	move.w	#$8200|(VRAM_SS_Plane_A_Name_Table1/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_SS_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $A000
	move.w	#$8C08,(a6)		; H res 32 cells, no interlace, S/H enabled
	move.w	#$9003,(a6)		; Scroll table size: 128x32
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	move.w	#$8D00|(VRAM_SS_Horiz_Scroll_Table/$400),(a6)		; H scroll table base: $FC00
	move.w	#$8500|(VRAM_SS_Sprite_Attribute_Table/$200),(a6)	; Sprite attribute table base: $F800
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l

; /------------------------------------------------------------------------\
; | We're gonna zero-fill a bunch of VRAM regions. This was done by macro, |
; | so there's gonna be a lot of wasted cycles.                            |
; \------------------------------------------------------------------------/
	
	dmaFillVRAM 0,VRAM_SS_Plane_A_Name_Table2,VRAM_SS_Plane_Table_Size ; clear Plane A pattern name table 1
	dmaFillVRAM 0,VRAM_SS_Plane_A_Name_Table1,VRAM_SS_Plane_Table_Size ; clear Plane A pattern name table 2
	dmaFillVRAM 0,VRAM_SS_Plane_B_Name_Table,VRAM_SS_Plane_Table_Size ; clear Plane B pattern name table
	dmaFillVRAM 0,VRAM_SS_Horiz_Scroll_Table,VRAM_SS_Horiz_Scroll_Table_Size  ; clear Horizontal scroll table

	clr.l	(Vscroll_Factor).w
	clr.l	(unk_F61A).w
	clr.b	(SpecialStage_Started).w

; /------------------------------------------------------------------------\
; | Now we clear out some regions in main RAM where we want to store some  |
; | of our data structures.                                                |
; \------------------------------------------------------------------------/
	; Bug: These '+4's shouldn't be here; clearRAM accidentally clears an additional 4 bytes
	clearRAM SS_Sprite_Table,SS_Sprite_Table_End+4
	clearRAM SS_Horiz_Scroll_Buf_1,SS_Horiz_Scroll_Buf_1_End+4
	clearRAM SS_Misc_Variables,SS_Misc_Variables_End+4
	clearRAM SS_Sprite_Table_Input,SS_Sprite_Table_Input_End
	clearRAM SS_Object_RAM,SS_Object_RAM_End

	move	#$2300,sr
	lea	(VDP_control_port).l,a6
	move.w	#$8F02,(a6)		; VRAM pointer increment: $0002
	bsr.w	ssInitTableBuffers
	bsr.w	ssLdComprsdData
	move.w	#0,(SpecialStage_CurrentSegment).w
	moveq	#PLCID_SpecialStage,d0
	bsr.w	RunPLC_ROM
	clr.b	(Level_started_flag).w
	move.l	#0,(Camera_X_pos).w	; probably means something else in this context
	move.l	#0,(Camera_Y_pos).w
	move.l	#0,(Camera_X_pos_copy).w
	move.l	#0,(Camera_Y_pos_copy).w
	cmpi.w	#1,(Player_mode).w	; is this a Tails alone game?
	bgt.s	+			; if yes, branch
	move.b	#ObjID_SonicSS,(MainCharacter+id).w ; load Obj09 (special stage Sonic)
	tst.w	(Player_mode).w		; is this a Sonic and Tails game?
	bne.s	++			; if not, branch
+	move.b	#ObjID_TailsSS,(Sidekick+id).w ; load Obj10 (special stage Tails)
+	move.b	#ObjID_SSHUD,(SpecialStageHUD+id).w ; load Obj5E (special stage HUD)
	move.b	#ObjID_StartBanner,(SpecialStageStartBanner+id).w ; load Obj5F (special stage banner)
	move.b	#ObjID_SSNumberOfRings,(SpecialStageNumberOfRings+id).w ; load Obj87 (special stage ring count)
	move.w	#$80,(SS_Offset_X).w
	move.w	#$36,(SS_Offset_Y).w
	bsr.w	SSPlaneB_Background
	bsr.w	SSDecompressPlayerArt
	bsr.w	SSInitPalAndData
	move.l	#$C0000,(SS_New_Speed_Factor).w
	clr.w	(Ctrl_1_Logical).w
	clr.w	(Ctrl_2_Logical).w

-	move.b	#VintID_S2SS,(Vint_routine).w
	bsr.w	WaitForVint
	move.b	(SSTrack_drawing_index).w,d0
	bne.s	-

	bsr.w	SSTrack_Draw

-	move.b	#VintID_S2SS,(Vint_routine).w
	bsr.w	WaitForVint
	bsr.w	SSTrack_Draw
	bsr.w	SSLoadCurrentPerspective
	bsr.w	SSObjectsManager
	move.b	(SSTrack_duration_timer).w,d0
	subq.w	#1,d0
	bne.s	-

	jsr	(Obj5A_CreateRingsToGoText).l
	bsr.w	SS_ScrollBG
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	bsr.w	RunPLC_RAM
	move.b	#VintID_CtrlDMA,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	#MusID_SpecStage,d0
	bsr.w	PlayMusic
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromWhite

-	bsr.w	PauseGame
	move.w	(Ctrl_1).w,(Ctrl_1_Logical).w
	move.w	(Ctrl_2).w,(Ctrl_2_Logical).w
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w ; special stage mode?
	bne.w	SpecialStage_Unpause		; if not, branch
	move.b	#VintID_S2SS,(Vint_routine).w
	bsr.w	WaitForVint
	bsr.w	SSTrack_Draw
	bsr.w	SSSetGeometryOffsets
	bsr.w	SSLoadCurrentPerspective
	bsr.w	SSObjectsManager
	bsr.w	SS_ScrollBG
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	bsr.w	RunPLC_RAM
	tst.b	(SpecialStage_Started).w
	beq.s	-

	moveq	#PLCID_SpecStageBombs,d0
	bsr.w	LoadPLC

-	bsr.w	PauseGame
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w ; special stage mode?
	bne.w	SpecialStage_Unpause		; if not, branch
	move.b	#VintID_S2SS,(Vint_routine).w
	bsr.w	WaitForVint
	bsr.w	SSTrack_Draw
	bsr.w	SSSetGeometryOffsets
	bsr.w	SSLoadCurrentPerspective
	bsr.w	SSObjectsManager
	bsr.w	SS_ScrollBG
	bsr.w	PalCycle_SS
	tst.b	(SS_Pause_Only_flag).w
	beq.s	+
	move.w	(Ctrl_1).w,d0
	andi.w	#(button_start_mask<<8)|button_start_mask,d0
	move.w	d0,(Ctrl_1_Logical).w
	move.w	(Ctrl_2).w,d0
	andi.w	#(button_start_mask<<8)|button_start_mask,d0
	move.w	d0,(Ctrl_2_Logical).w
	bra.s	++
; ===========================================================================
+
	move.w	(Ctrl_1).w,(Ctrl_1_Logical).w
	move.w	(Ctrl_2).w,(Ctrl_2_Logical).w
+
	jsr	(RunObjects).l
	tst.b	(SS_Check_Rings_flag).w
	bne.s	+
	jsr	(BuildSprites).l
	bsr.w	RunPLC_RAM
	bra.s	-
; ===========================================================================
+
	andi.b	#7,(Emerald_count).w
	tst.b	(SS_2p_Flag).w
	beq.s	+
	lea	(SS2p_RingBuffer).w,a0
	move.w	(a0)+,d0
	add.w	(a0)+,d0
	add.w	(a0)+,d0
	add.w	(a0)+,d0
	add.w	(a0)+,d0
	add.w	(a0)+,d0
	bra.s	++
; ===========================================================================
+
	move.w	(Ring_count).w,d0
	add.w	(Ring_count_2P).w,d0
+
	cmp.w	(SS_Perfect_rings_left).w,d0
	bne.s	+
	st.b	(Perfect_rings_flag).w
+
	bsr.w	Pal_FadeToWhite
	tst.w	(Two_player_mode_copy).w
	bne.w	loc_540C
	move	#$2700,sr
	lea	(VDP_control_port).l,a6
	move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)		; PNT A base: $C000
	move.w	#$8400|(VRAM_Menu_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $E000
	move.w	#$9001,(a6)		; Scroll table size: 64x32
	move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled
	bsr.w	ClearScreen
	jsrto	(Hud_Base).l, JmpTo_Hud_Base
	clr.w	(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	move	#$2300,sr
	moveq	#PalID_Result,d0
	bsr.w	PalLoad_Now
	moveq	#PLCID_Std1,d0
	bsr.w	LoadPLC2
	move.l	#vdpComm(tiles_to_bytes(ArtTile_VRAM_Start+2),VRAM,WRITE),d0
	lea	SpecialStage_ResultsLetters(pc),a0
	jsrto	(LoadTitleCardSS).l, JmpTo_LoadTitleCardSS
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_SpecialStageResults),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_SpecialStageResults).l,a0
	bsr.w	NemDec
	move.w	(Player_mode).w,d0
	beq.s	++
	subq.w	#1,d0
	beq.s	+
	clr.w	(Ring_count).w
	bra.s	++
; ===========================================================================
+
	clr.w	(Ring_count_2P).w
+
	move.w	(Ring_count).w,(Bonus_Countdown_1).w
	move.w	(Ring_count_2P).w,(Bonus_Countdown_2).w
	clr.w	(Total_Bonus_Countdown).w
	tst.b	(Got_Emerald).w
	beq.s	+
	move.w	#1000,(Total_Bonus_Countdown).w
+
	move.b	#1,(Update_HUD_score).w
	move.b	#1,(Update_Bonus_score).w
	move.w	#MusID_EndLevel,d0
	jsr	(PlaySound).l

	clearRAM SS_Sprite_Table_Input,SS_Sprite_Table_Input_End
	clearRAM SS_Object_RAM,SS_Object_RAM_End

	move.b	#ObjID_SSResults,(SpecialStageResults+id).w ; load Obj6F (special stage results) at $FFFFB800
-
	move.b	#VintID_Level,(Vint_routine).w
	bsr.w	WaitForVint
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	bsr.w	RunPLC_RAM
	tst.w	(Level_Inactive_flag).w
	beq.s	-
	tst.l	(Plc_Buffer).w
	bne.s	-
	move.w	#SndID_SpecStageEntry,d0
	bsr.w	PlaySound
	bsr.w	Pal_FadeToWhite
	tst.w	(Two_player_mode_copy).w
	bne.s	loc_540C
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	rts
; ===========================================================================

loc_540C:
	move.w	#VsRSID_SS,(Results_Screen_2P).w
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	rts
; ===========================================================================

; loc_541A:
SpecialStage_Unpause:
	move.b	#MusID_Unpause,(Music_to_play).w
	move.b	#VintID_Level,(Vint_routine).w
	bra.w	WaitForVint




; ===========================================================================
; ---------------------------------------------------------------------------
; Animated color of the twinkling stars in the special stage background
; ---------------------------------------------------------------------------
; loc_542A: Pal_UNK8:
Pal_SpecialStageStars:	dc.w  $EEE, $CCC, $AAA,	$888, $888, $AAA, $CCC,	$EEE

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_543A
PalCycle_SS:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#3,d0
	bne.s	+
	move.b	(SS_Star_color_1).w,d0
	addi_.b	#1,(SS_Star_color_1).w
	andi.w	#7,d0
	add.w	d0,d0
	move.w	Pal_SpecialStageStars(pc,d0.w),(Normal_palette+$1C).w
	move.b	(SS_Star_color_2).w,d0
	addi_.b	#1,(SS_Star_color_2).w
	andi.w	#7,d0
	add.w	d0,d0
	move.w	Pal_SpecialStageStars(pc,d0.w),(Normal_palette+$1E).w
+
	cmpi.b	#6,(Current_Special_Stage).w
	bne.s	+
	cmpi.b	#3,(Current_Special_Act).w
	beq.w	SSCheckpoint_rainbow
/
	tst.b	(SS_Checkpoint_Rainbow_flag).w
	beq.s	+	; rts
	move.b	(Vint_runcount+3).w,d0
	andi.b	#7,d0
	bne.s	+	; rts
	move.b	(SS_Rainbow_palette).w,d0
	addi_.b	#1,(SS_Rainbow_palette).w
	andi.b	#3,d0
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	move.w	word_54C4(pc,d0.w),(Normal_palette_line4+$16).w
	move.w	word_54C6(pc,d0.w),(Normal_palette_line4+$18).w
	move.w	word_54C8(pc,d0.w),(Normal_palette_line4+$1A).w
+
	rts
; ===========================================================================
; special stage rainbow blinking sprite palettes... (chaos emerald colors?)
;word_54BC:
		dc.w   $0EE, $0C0, $0EE, $0C0
word_54C4:	dc.w   $0EE
word_54C6:	dc.w   $0CC
word_54C8:	dc.w   $088, $0E0, $0C0, $080, $EE0, $CC0, $880, $E0E, $C0C, $808
; ===========================================================================

;loc_54DC
SSCheckpoint_rainbow:
	tst.b	(SS_Pause_Only_flag).w
	beq.s	-
	moveq	#0,d0
	move.b	(Vint_runcount+3).w,d0
	andi.b	#1,d0
	bne.w	-
	move.w	(Ring_count).w,d2
	add.w	(Ring_count_2P).w,d2
	cmp.w	(SS_Ring_Requirement).w,d2
	blt.w	-
	lea	(Normal_palette+2).w,a0
	movea.l	a0,a1
	move.w	(a0)+,d0

	moveq	#$B,d1
-	move.w	(a0)+,(a1)+
	dbf	d1,-

	move.w	d0,(a1)
	rts
; End of function PalCycle_SS


;|||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_5514
SSLoadCurrentPerspective:
	cmpi.b	#4,(SSTrack_drawing_index).w
	bne.s	+	; rts
	movea.l	#SSRAM_MiscKoz_SpecialPerspective,a0
	moveq	#0,d0
	move.b	(SSTrack_mapping_frame).w,d0
	add.w	d0,d0
	adda.w	(a0,d0.w),a0
	move.l	a0,(SS_CurrentPerspective).w
+	rts
; End of function SSLoadCurrentPerspective


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_5534
SSObjectsManager:
	cmpi.b	#4,(SSTrack_drawing_index).w
	bne.w	return_55DC
	moveq	#0,d0
	move.b	(SpecialStage_CurrentSegment).w,d0
	cmp.b	(SpecialStage_LastSegment2).w,d0
	beq.w	return_55DC
	move.b	d0,(SpecialStage_LastSegment2).w
	movea.l	(SS_CurrentLevelLayout).w,a1
	move.b	(a1,d0.w),d3
	andi.w	#$7F,d3
	lea	(Ani_SSTrack_Len).l,a0
	move.b	(a0,d3.w),d3
	add.w	d3,d3
	add.w	d3,d3
	movea.l	(SS_CurrentLevelObjectLocations).w,a0
-
	bsr.w	SSSingleObjLoad
	bne.s	return_55DC
	moveq	#0,d0
	move.b	(a0)+,d0
	bmi.s	++
	move.b	d0,d1
	andi.b	#$40,d1
	bne.s	+
	addq.w	#1,(SS_Perfect_rings_left).w
	move.b	#ObjID_SSRing,id(a1)
	add.w	d0,d0
	add.w	d0,d0
	add.w	d3,d0
	move.w	d0,objoff_30(a1)
	move.b	(a0)+,angle(a1)
	bra.s	-
; ===========================================================================
+
	andi.w	#$3F,d0
	move.b	#ObjID_SSBomb,id(a1)
	add.w	d0,d0
	add.w	d0,d0
	add.w	d3,d0
	move.w	d0,objoff_30(a1)
	move.b	(a0)+,angle(a1)
	bra.s	-
; ===========================================================================
+
	move.l	a0,(SS_CurrentLevelObjectLocations).w
	addq.b	#1,d0
	beq.s	return_55DC
	addq.b	#1,d0
	beq.s	++
	addq.b	#1,d0
	beq.s	+
	st.b	(SS_NoCheckpoint_flag).w
	sf.b	(SS_NoCheckpointMsg_flag).w
	bra.s	++
; ===========================================================================
+
	tst.b	(SS_2p_Flag).w
	bne.s	+
	move.b	#ObjID_SSEmerald,id(a1)
	rts
; ===========================================================================
+
	move.b	#ObjID_SSMessage,id(a1)

return_55DC:
	rts
; End of function SSObjectsManager

; ===========================================================================
SSTrackPNTCommands:
	dc.l vdpComm(VRAM_SS_Plane_A_Name_Table2 + 0 * (PNT_Buffer_End-PNT_Buffer),VRAM,WRITE)
	dc.l vdpComm(VRAM_SS_Plane_A_Name_Table2 + 1 * (PNT_Buffer_End-PNT_Buffer),VRAM,WRITE)
	dc.l vdpComm(VRAM_SS_Plane_A_Name_Table2 + 2 * (PNT_Buffer_End-PNT_Buffer),VRAM,WRITE)
	dc.l vdpComm(VRAM_SS_Plane_A_Name_Table2 + 3 * (PNT_Buffer_End-PNT_Buffer),VRAM,WRITE)
	dc.l vdpComm(VRAM_SS_Plane_A_Name_Table1 + 0 * (PNT_Buffer_End-PNT_Buffer),VRAM,WRITE)
	dc.l vdpComm(VRAM_SS_Plane_A_Name_Table1 + 1 * (PNT_Buffer_End-PNT_Buffer),VRAM,WRITE)
	dc.l vdpComm(VRAM_SS_Plane_A_Name_Table1 + 2 * (PNT_Buffer_End-PNT_Buffer),VRAM,WRITE)
	dc.l vdpComm(VRAM_SS_Plane_A_Name_Table1 + 3 * (PNT_Buffer_End-PNT_Buffer),VRAM,WRITE)
Ani_SSTrack_Len:
	dc.b SSTrackAni_TurnThenRise_End - SSTrackAni_TurnThenRise	; 0
	dc.b SSTrackAni_TurnThenDrop_End - SSTrackAni_TurnThenDrop	; 1
	dc.b SSTrackAni_TurnThenStraight_End - SSTrackAni_TurnThenStraight	; 2
	dc.b SSTrackAni_Straight_End - SSTrackAni_Straight	; 3
	dc.b SSTrackAni_StraightThenTurn_End - SSTrackAni_StraightThenTurn	; 4
	dc.b   0	; 5

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_5604
SSTrack_Draw:
	moveq	#0,d0
	move.b	(SSTrack_drawing_index).w,d0					; Get drawing position
	cmpi.b	#4,d0											; Is it time to draw a new frame?
	bge.w	SSTrackSetOrientation							; Branch if not
	add.w	d0,d0											; Multiply by 4
	add.w	d0,d0
	bne.w	SSTrack_BeginDraw								; Branch if we don't need to start a new segment
	move.l	(SSTrack_last_mappings).w,(SSTrack_last_mappings_copy).w	; Save last mappings
	move.b	(SSTrack_mapping_frame).w,(SSTrack_last_mapping_frame).w	; Save last frame
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	move.b	(SpecialStage_CurrentSegment).w,d1				; Get current segment ID
	move.b	(SSTrack_anim_frame).w,d2						; Get current frame
	movea.l	(SS_CurrentLevelLayout).w,a1					; Pointer to level layout
	move.b	(a1,d1.w),d3									; Get segment geometry type
	andi.b	#$7F,d3											; Strip flip flag
	move.b	d3,(SSTrack_anim).w								; Set this as new animation
	move.w	d3,d1											; Copy to d1
	add.w	d3,d3											; Turn it into an index
	lea	(Ani_SpecialStageTrack).l,a1						; Animation table
	adda.w	(a1,d3.w),a1									; Add offset so a1 points to animation data
	adda.w	d2,a1											; Offset into current animation frame
	moveq	#0,d4
	move.b	(a1),d4											; d4 = animation frame to draw
	move.b	d4,(SSTrack_mapping_frame).w					; Save to RAM
	lsl.w	#2,d4
	lea	(Map_SpecialStageTrack).l,a1						; Mappings table
	movea.l	(a1,d4.w),a0									; a0 = pointer to mappings for current track frame
	movea.l	a0,a1											; Copy to a1
	moveq	#0,d2
	move.b	(a0)+,d2										; Skip the first 2 bytes
	move.b	(a0)+,d2										; Why not 'addq.l	#2,a0'?
	move.b	(a0)+,d2										; Get byte
	lsl.w	#8,d2											; Shift it up to be the high byte of a word
	move.b	(a0)+,d2										; Read another byte; why not 'move.w	(a0)+,d2'?
	addq.w	#4,d2											; Add 4
	adda.w	d2,a1											; Use as offset from start of file
	movea.l	a1,a2											; Save to a2
	moveq	#0,d2
	move.b	(a1)+,d2										; Skip the first 2 bytes
	move.b	(a1)+,d2										; Why not 'addq.l	#2,a1'?
	move.b	(a1)+,d2										; Get byte
	lsl.w	#8,d2											; Shift it up to be the high byte of a word
	move.b	(a1)+,d2										; Read another byte; why not 'move.w	(a1)+,d2'?
	addq.w	#4,d2											; Add 4
	adda.w	d2,a2											; Use as offset from previous offset
	move.b	(a2)+,d2										; Ignore the first 3 bytes
	move.b	(a2)+,d2										; Why not 'addq.l	#3,a2'?
	move.b	(a2)+,d2
	move.b	(a2)+,d2										; Get byte (unused)
	move.l	a0,(SSTrack_mappings_bitflags).w				; Save pointer to bit flags mappings
	move.l	a0,(SSTrack_last_mappings).w					; ... twice
	move.l	a1,(SSTrack_mappings_uncompressed).w			; Save pointer to uncompressed mappings
	move.l	a2,(SSTrack_mappings_RLE).w						; Save pointer to RLE mappings
	lea_	Ani_SSTrack_Len,a4								; Pointer to animation lengths
	move.b	(a4,d1.w),d2									; Get length of current animation
	move.b	(SSTrack_anim_frame).w,(SSTrack_last_anim_frame).w	; Save old frame
	addi_.b	#1,(SSTrack_anim_frame).w						; Increment current frame
	cmp.b	(SSTrack_anim_frame).w,d2						; Compare with animation length
	bne.s	SSTrack_BeginDraw								; If not equal, branch
	move.b	#0,(SSTrack_anim_frame).w						; Reset to start
	move.b	(SpecialStage_CurrentSegment).w,(SpecialStage_LastSegment).w	; Save old segment
	addi_.b	#1,(SpecialStage_CurrentSegment).w				; Increment current segment

;loc_56D2
SSTrack_BeginDraw:
	tst.b	(SS_Alternate_PNT).w							; Are we using the alternate PNT?
	beq.s	+												; Branch if not
	addi.w	#$10,d0											; Change where we will be drawing
+
	lea_	SSTrackPNTCommands,a3							; Table of VRAM commands
	movea.l	(a3,d0.w),a3									; Get command to set destination in VRAM for current frame
	move.l	a3,(VDP_control_port).l							; Send it to VDP
	lea	(VDP_data_port).l,a6
	bsr.w	SSTrackSetOrientation							; Set oriantation flags
	movea.l	(SSTrack_mappings_bitflags).w,a0				; Get pointer to bit flags mappings
	movea.l	(SSTrack_mappings_uncompressed).w,a1			; Get pointer to uncompressed mappings
	movea.l	(SSTrack_mappings_RLE).w,a2						; Get pointer to RLE mappings
	lea	(SSDrawRegBuffer).w,a3								; Pointer to register buffer from last draw
	movem.w	(a3)+,d2-d7										; Restore registers from previous call (or set them to zero)
	lea	(SSPNT_UncLUT).l,a3									; Pattern name list for drawing routines
	lea	(SSPNT_RLELUT).l,a4									; RLE-encoded pattern name list for drawing routines
	movea.w	#-8,a5											; Initialize loop counter: draws 7 lines
	moveq	#0,d0
	tst.b	(SSTrack_Orientation).w							; Is the current segment flipped?
	bne.w	SSTrackDrawLineFlipLoop							; Branch if yes

;loc_5722
SSTrackDrawLineLoop:
	adda_.w	#1,a5											; Increment loop counter
	cmpa.w	#0,a5											; Have all 7 lines been drawn?
	beq.w	SSTrackDraw_return								; If yes, return

;loc_572E
SSTrackDrawLoop_Inner:
	moveq	#0,d1
	subq.w	#1,d7											; Subtract 1 from bit counter
	bpl.s	+												; Branch if we still have bits we can use
	move.b	(a0)+,d6										; Get a new byte from bit flags
	moveq	#7,d7											; We now have 8 fresh new bits
+
	add.b	d6,d6											; Do we have to use RLE compression?
	bcc.s	SSTrackDrawRLE									; Branch if yes
	subq.b	#1,d5											; Subtract 1 from bit counter
	bpl.s	+												; Branch if we still have bits we can use
	move.b	(a1)+,d4										; Get a new byte from uncompressed mappings pointer
	moveq	#7,d5											; We now have 8 fresh new bits
+
	add.b	d4,d4											; Do we need a 10-bit index?
	bcc.s	+												; Branch if not
	moveq	#$A,d0											; d0 = 10 bits
	sub.b	d5,d0											; d0 = 10 - d5
	subq.b	#3,d0											; d0 =  7 - d5; why not shorten it to 'moveq	#7,d0 \n	sub.b	d5,d0'?
	add.w	d0,d0											; Convert into table index
	move.w	SSTrackDrawUnc_Read10LUT(pc,d0.w),d0
	jmp	SSTrackDrawUnc_Read10LUT(pc,d0.w)
; ===========================================================================
;off_5758
SSTrackDrawUnc_Read10LUT:	offsetTable
		offsetTableEntry.w SSTrackDrawUnc_Read10_Got7	; 0
		offsetTableEntry.w SSTrackDrawUnc_Read10_Got6	; 1
		offsetTableEntry.w SSTrackDrawUnc_Read10_Got5	; 2
		offsetTableEntry.w SSTrackDrawUnc_Read10_Got4	; 3
		offsetTableEntry.w SSTrackDrawUnc_Read10_Got3	; 4
		offsetTableEntry.w SSTrackDrawUnc_Read10_Got2	; 5
		offsetTableEntry.w SSTrackDrawUnc_Read10_Got1	; 6
		offsetTableEntry.w SSTrackDrawUnc_Read10_Got0	; 7
; ===========================================================================
+
	moveq	#6,d0											; d0 = 6
	sub.b	d5,d0											; d0 = 6 - d5
	addq.b	#1,d0											; d0 = 7 - d5; why not shorten it to 'moveq	#7,d0 \n	sub.b	d5,d0'?
	add.w	d0,d0											; Convert into table index
	move.w	SSTrackDrawUnc_Read6LUT(pc,d0.w),d0
	jmp	SSTrackDrawUnc_Read6LUT(pc,d0.w)
; ===========================================================================
;off_5778
SSTrackDrawUnc_Read6LUT:	offsetTable
		offsetTableEntry.w SSTrackDrawUnc_Read6_Got7	; 0
		offsetTableEntry.w SSTrackDrawUnc_Read6_Got6	; 1
		offsetTableEntry.w SSTrackDrawUnc_Read6_Got5	; 2
		offsetTableEntry.w SSTrackDrawUnc_Read6_Got4	; 3
		offsetTableEntry.w SSTrackDrawUnc_Read6_Got3	; 4
		offsetTableEntry.w SSTrackDrawUnc_Read6_Got2	; 5
		offsetTableEntry.w SSTrackDrawUnc_Read6_Got1	; 6
		offsetTableEntry.w SSTrackDrawUnc_Read6_Got0	; 7
; ===========================================================================

SSTrackDrawRLE:
	subq.b	#1,d3											; Subtract 1 from bit counter
	bpl.s	++												; Branch if we still have bits we can use
	move.b	(a2)+,d2										; Get a new byte from RLE mappings pointer
	cmpi.b	#-1,d2											; Is d2 equal to -1?
	bne.s	+												; Branch if not
	moveq	#0,d3											; Set bit counter to zero
	bra.w	SSTrackDrawLineLoop
; ===========================================================================
+
	moveq	#7,d3											; We now have 8 fresh new bits
+
	add.b	d2,d2											; Do we need a 7-bit index?
	bcc.s	+												; Branch if not
	moveq	#7,d0											; d0 = 7
	sub.b	d3,d0											; d0 = 10 - d3
	add.b	d0,d0											; Convert into table index
	move.w	SSTrackDrawRLE_Read7LUT(pc,d0.w),d0
	jmp	SSTrackDrawRLE_Read7LUT(pc,d0.w)
; ===========================================================================
;off_57AE
SSTrackDrawRLE_Read7LUT:	offsetTable
		offsetTableEntry.w SSTrackDrawRLE_Read7_Got7	; 0
		offsetTableEntry.w SSTrackDrawRLE_Read7_Got6	; 1
		offsetTableEntry.w SSTrackDrawRLE_Read7_Got5	; 2
		offsetTableEntry.w SSTrackDrawRLE_Read7_Got4	; 3
		offsetTableEntry.w SSTrackDrawRLE_Read7_Got3	; 4
		offsetTableEntry.w SSTrackDrawRLE_Read7_Got2	; 5
		offsetTableEntry.w SSTrackDrawRLE_Read7_Got1	; 6
		offsetTableEntry.w SSTrackDrawRLE_Read7_Got0	; 7
; ===========================================================================
+
	moveq	#6,d0											; d0 = 6
	sub.b	d3,d0											; d0 = 6 - d3
	addq.b	#1,d0											; d0 = 7 - d3; why not shorten it to 'moveq	#7,d0 \n	sub.b	d3,d0'?
	add.b	d0,d0											; Convert into table index
	move.w	SSTrackDrawRLE_Read6LUT(pc,d0.w),d0
	jmp	SSTrackDrawRLE_Read6LUT(pc,d0.w)
; ===========================================================================
;off_57CE
SSTrackDrawRLE_Read6LUT:	offsetTable
		offsetTableEntry.w SSTrackDrawRLE_Read6_Got7	; 0
		offsetTableEntry.w SSTrackDrawRLE_Read6_Got6	; 1
		offsetTableEntry.w SSTrackDrawRLE_Read6_Got5	; 2
		offsetTableEntry.w SSTrackDrawRLE_Read6_Got4	; 3
		offsetTableEntry.w SSTrackDrawRLE_Read6_Got3	; 4
		offsetTableEntry.w SSTrackDrawRLE_Read6_Got2	; 5
		offsetTableEntry.w SSTrackDrawRLE_Read6_Got1	; 6
		offsetTableEntry.w SSTrackDrawRLE_Read6_Got0	; 7
; ===========================================================================
;loc_57DE
SSTrackDrawUnc_Read10_Got0:
	; Reads 10 bits from uncompressed mappings, 0 bits in bit buffer
	moveq	#0,d0
	move.b	(a1)+,d0
	lsl.w	#2,d0
	move.b	(a1)+,d4
	rol.b	#2,d4
	move.b	d4,d1
	andi.b	#3,d1
	or.b	d1,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#6,d5
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5806
SSTrackDrawUnc_Read10_Got1:
	; Reads 10 bits from uncompressed mappings, 1 bit in bit buffer
	move.b	d4,d0
	lsl.w	#2,d0
	andi.w	#$200,d0
	move.b	(a1)+,d1
	lsl.w	#1,d1
	or.w	d1,d0
	move.b	(a1)+,d4
	rol.b	#1,d4
	move.b	d4,d1
	andi.b	#1,d1
	or.b	d1,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#7,d5
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5836
SSTrackDrawUnc_Read10_Got2:
	; Reads 10 bits from uncompressed mappings, 2 bits in bit buffer
	move.b	d4,d0
	lsl.w	#2,d0
	andi.w	#$300,d0
	move.b	(a1)+,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#0,d5											; Bit buffer now empty
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5856
SSTrackDrawUnc_Read10_Got3:
	; Reads 10 bits from uncompressed mappings, 3 bits in bit buffer
	move.b	d4,d0
	lsl.w	#2,d0
	andi.w	#$380,d0
	move.b	(a1)+,d4
	ror.b	#1,d4
	move.b	d4,d1
	andi.b	#$7F,d1
	or.b	d1,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#1,d5											; Bit buffer now has 1 bit
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5880
SSTrackDrawUnc_Read10_Got4:
	; Reads 10 bits from uncompressed mappings, 4 bits in bit buffer
	move.b	d4,d0
	lsl.w	#2,d0
	andi.w	#$3C0,d0
	move.b	(a1)+,d4
	ror.b	#2,d4
	move.b	d4,d1
	andi.b	#$3F,d1
	or.b	d1,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#2,d5											; Bit buffer now has 2 bits
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_58AA
SSTrackDrawUnc_Read10_Got5:
	; Reads 10 bits from uncompressed mappings, 5 bits in bit buffer
	move.b	d4,d0
	lsl.w	#2,d0
	andi.w	#$3E0,d0
	move.b	(a1)+,d4
	ror.b	#3,d4
	move.b	d4,d1
	andi.b	#$1F,d1
	or.b	d1,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#3,d5											; Bit buffer now has 3 bits
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_58D4
SSTrackDrawUnc_Read10_Got6:
	; Reads 10 bits from uncompressed mappings, 6 bits in bit buffer
	move.b	d4,d0
	lsl.w	#2,d0
	andi.w	#$3F0,d0
	move.b	(a1)+,d4
	ror.b	#4,d4
	move.b	d4,d1
	andi.b	#$F,d1
	or.b	d1,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#4,d5											; Bit buffer now has 4 bits
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_58FE
SSTrackDrawUnc_Read10_Got7:
	; Reads 10 bits from uncompressed mappings, 7 bits in bit buffer
	move.b	d4,d0
	lsl.w	#2,d0
	andi.w	#$3F8,d0
	move.b	(a1)+,d4
	rol.b	#3,d4
	move.b	d4,d1
	andi.b	#7,d1
	or.b	d1,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#5,d5											; Bit buffer now has 5 bits
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5928
SSTrackDrawUnc_Read6_Got0:
	; Reads 6 bits from uncompressed mappings, 0 bits in bit buffer
	move.b	(a1)+,d4
	ror.b	#2,d4
	move.b	d4,d0
	andi.w	#$3F,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#2,d5											; Bit buffer now has 2 bits
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5944
SSTrackDrawUnc_Read6_Got1:
	; Reads 6 bits from uncompressed mappings, 1 bit in bit buffer
	move.b	d4,d0
	lsr.b	#2,d0
	andi.w	#$20,d0
	move.b	(a1)+,d4
	ror.b	#3,d4
	move.b	d4,d1
	andi.b	#$1F,d1
	or.b	d1,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#3,d5											; Bit buffer now has 3 bits
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_596A
SSTrackDrawUnc_Read6_Got2:
	; Reads 6 bits from uncompressed mappings, 2 bits in bit buffer
	move.b	d4,d0
	lsr.b	#2,d0
	andi.w	#$30,d0
	move.b	(a1)+,d4
	ror.b	#4,d4
	move.b	d4,d1
	andi.b	#$F,d1
	or.b	d1,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#4,d5											; Bit buffer now has 4 bits
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5990
SSTrackDrawUnc_Read6_Got3:
	; Reads 6 bits from uncompressed mappings, 3 bits in bit buffer
	move.b	d4,d0
	lsr.b	#2,d0
	andi.w	#$38,d0
	move.b	(a1)+,d4
	rol.b	#3,d4
	move.b	d4,d1
	andi.b	#7,d1
	or.b	d1,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#5,d5											; Bit buffer now has 5 bits
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_59B6
SSTrackDrawUnc_Read6_Got4:
	; Reads 6 bits from uncompressed mappings, 4 bits in bit buffer
	move.b	d4,d0
	lsr.b	#2,d0
	andi.w	#$3C,d0
	move.b	(a1)+,d4
	rol.b	#2,d4
	move.b	d4,d1
	andi.b	#3,d1
	or.b	d1,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#6,d5											; Bit buffer now has 6 bits
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_59DC
SSTrackDrawUnc_Read6_Got5:
	; Reads 6 bits from uncompressed mappings, 5 bits in bit buffer
	move.b	d4,d0
	lsr.b	#2,d0
	andi.w	#$3E,d0
	move.b	(a1)+,d4
	rol.b	#1,d4
	move.b	d4,d1
	andi.b	#1,d1
	or.b	d1,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#7,d5											; Bit buffer now has 7 bits
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5A02
SSTrackDrawUnc_Read6_Got6:
	; Reads 6 bits from uncompressed mappings, 6 bits in bit buffer
	lsr.b	#2,d4
	andi.w	#$3F,d4
	add.w	d4,d4
	move.w	(a3,d4.w),d4
	ori.w	#palette_line_3,d4
	move.w	d4,(a6)
	moveq	#0,d5											; Bit buffer now empty
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5A1A
SSTrackDrawUnc_Read6_Got7:
	; Reads 6 bits from uncompressed mappings, 7 bits in bit buffer
	ror.b	#2,d4
	move.b	d4,d0
	andi.w	#$3F,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	ori.w	#palette_line_3,d0
	move.w	d0,(a6)
	moveq	#1,d5											; Bit buffer now has 1 bit
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5A34
SSTrackDrawRLE_Read7_Got0:
	; Reads 7 bits from RLE-compressed mappings, 0 bits in bit buffer
	move.b	(a2)+,d2
	ror.b	#1,d2
	move.b	d2,d0
	andi.w	#$7F,d0
	moveq	#1,d3											; Bit buffer now has 1 bit
	cmpi.b	#$7F,d0
	beq.w	SSTrackDrawLineLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5A66
SSTrackDrawRLE_Read7_Got1:
	; Reads 7 bits from RLE-compressed mappings, 1 bit in bit buffer
	move.b	d2,d1
	lsr.b	#1,d1
	andi.b	#$40,d1
	move.b	(a2)+,d2
	ror.b	#2,d2
	move.b	d2,d0
	andi.w	#$3F,d0
	or.b	d1,d0
	moveq	#2,d3											; Bit buffer now has 2 bits
	cmpi.b	#$7F,d0
	beq.w	SSTrackDrawLineLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5AA2
SSTrackDrawRLE_Read7_Got2:
	; Reads 7 bits from RLE-compressed mappings, 2 bits in bit buffer
	move.b	d2,d1
	lsr.b	#1,d1
	andi.b	#$60,d1
	move.b	(a2)+,d2
	ror.b	#3,d2
	move.b	d2,d0
	andi.w	#$1F,d0
	or.b	d1,d0
	moveq	#3,d3											; Bit buffer now has 3 bits
	cmpi.b	#$7F,d0
	beq.w	SSTrackDrawLineLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5ADE
SSTrackDrawRLE_Read7_Got3:
	; Reads 7 bits from RLE-compressed mappings, 3 bits in bit buffer
	move.b	d2,d1
	lsr.b	#1,d1
	andi.b	#$70,d1
	move.b	(a2)+,d2
	ror.b	#4,d2
	move.b	d2,d0
	andi.w	#$F,d0
	or.b	d1,d0
	moveq	#4,d3											; Bit buffer now has 4 bits
	cmpi.b	#$7F,d0
	beq.w	SSTrackDrawLineLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5B1A
SSTrackDrawRLE_Read7_Got4:
	; Reads 7 bits from RLE-compressed mappings, 4 bits in bit buffer
	move.b	d2,d1
	lsr.b	#1,d1
	andi.b	#$78,d1
	move.b	(a2)+,d2
	rol.b	#3,d2
	move.b	d2,d0
	andi.w	#7,d0
	or.b	d1,d0
	moveq	#5,d3											; Bit buffer now has 5 bits
	cmpi.b	#$7F,d0
	beq.w	SSTrackDrawLineLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5B56
SSTrackDrawRLE_Read7_Got5:
	; Reads 7 bits from RLE-compressed mappings, 5 bits in bit buffer
	move.b	d2,d1
	lsr.b	#1,d1
	andi.b	#$7C,d1
	move.b	(a2)+,d2
	rol.b	#2,d2
	move.b	d2,d0
	andi.w	#3,d0
	or.b	d1,d0
	moveq	#6,d3											; Bit buffer now has 6 bits
	cmpi.b	#$7F,d0
	beq.w	SSTrackDrawLineLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5B92
SSTrackDrawRLE_Read7_Got6:
	; Reads 7 bits from RLE-compressed mappings, 6 bits in bit buffer
	move.b	d2,d1
	lsr.b	#1,d1
	andi.b	#$7E,d1
	move.b	(a2)+,d2
	rol.b	#1,d2
	move.b	d2,d0
	andi.w	#1,d0
	or.b	d1,d0
	moveq	#7,d3											; Bit buffer now has 7 bits
	cmpi.b	#$7F,d0
	beq.w	SSTrackDrawLineLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5BCE
SSTrackDrawRLE_Read7_Got7:
	; Reads 7 bits from RLE-compressed mappings, 7 bits in bit buffer
	lsr.b	#1,d2
	andi.w	#$7F,d2
	moveq	#0,d3											; Bit buffer now empty
	cmpi.b	#$7F,d2
	beq.w	SSTrackDrawLineLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d2
	add.w	d2,d2
	add.w	d2,d2
	move.w	(a4,d2.w),d1
	move.w	2(a4,d2.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5BFC
SSTrackDrawRLE_Read6_Got0:
	; Reads 6 bits from RLE-compressed mappings, 0 bits in bit buffer
	move.b	(a2)+,d2
	ror.b	#2,d2
	move.b	d2,d0
	andi.w	#$3F,d0
	add.w	d0,d0
	add.w	d0,d0
	moveq	#2,d3											; Bit buffer now has 2 bits
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5C22
SSTrackDrawRLE_Read6_Got1:
	; Reads 6 bits from RLE-compressed mappings, 1 bit in bit buffer
	move.b	d2,d0
	lsr.b	#2,d0
	andi.w	#$20,d0
	move.b	(a2)+,d2
	ror.b	#3,d2
	move.b	d2,d1
	andi.b	#$1F,d1
	or.b	d1,d0
	moveq	#3,d3											; Bit buffer now has 3 bits
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5C52
SSTrackDrawRLE_Read6_Got2:
	; Reads 6 bits from RLE-compressed mappings, 2 bits in bit buffer
	move.b	d2,d0
	lsr.b	#2,d0
	andi.w	#$30,d0
	move.b	(a2)+,d2
	ror.b	#4,d2
	move.b	d2,d1
	andi.b	#$F,d1
	or.b	d1,d0
	add.w	d0,d0
	add.w	d0,d0
	moveq	#4,d3											; Bit buffer now has 4 bits
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5C82
SSTrackDrawRLE_Read6_Got3:
	; Reads 6 bits from RLE-compressed mappings, 3 bits in bit buffer
	move.b	d2,d0
	lsr.b	#2,d0
	andi.w	#$38,d0
	move.b	(a2)+,d2
	rol.b	#3,d2
	move.b	d2,d1
	andi.b	#7,d1
	or.b	d1,d0
	add.w	d0,d0
	add.w	d0,d0
	moveq	#5,d3											; Bit buffer now has 5 bits
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5CB2
SSTrackDrawRLE_Read6_Got4:
	; Reads 6 bits from RLE-compressed mappings, 4 bits in bit buffer
	move.b	d2,d0
	lsr.b	#2,d0
	andi.w	#$3C,d0
	move.b	(a2)+,d2
	rol.b	#2,d2
	move.b	d2,d1
	andi.b	#3,d1
	or.b	d1,d0
	add.w	d0,d0
	add.w	d0,d0
	moveq	#6,d3											; Bit buffer now has 6 bits
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5CE2
SSTrackDrawRLE_Read6_Got5:
	; Reads 6 bits from RLE-compressed mappings, 5 bits in bit buffer
	move.b	d2,d0
	lsr.b	#2,d0
	andi.w	#$3E,d0
	move.b	(a2)+,d2
	rol.b	#1,d2
	move.b	d2,d1
	andi.b	#1,d1
	or.b	d1,d0
	add.w	d0,d0
	add.w	d0,d0
	moveq	#7,d3											; Bit buffer now has 7 bits
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5D12
SSTrackDrawRLE_Read6_Got6:
	; Reads 6 bits from RLE-compressed mappings, 6 bits in bit buffer
	lsr.b	#2,d2
	andi.w	#$3F,d2
	add.w	d2,d2
	add.w	d2,d2
	moveq	#0,d3											; Bit buffer now empty
	move.w	(a4,d2.w),d1
	move.w	2(a4,d2.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5D34
SSTrackDrawRLE_Read6_Got7:
	; Reads 6 bits from RLE-compressed mappings, 7 bits in bit buffer
	ror.b	#2,d2
	move.b	d2,d0
	andi.w	#$3F,d0
	add.w	d0,d0
	add.w	d0,d0
	moveq	#1,d3											; Bit buffer now has 1 bit
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================

;loc_5D58
SSTrackDraw_return:
	cmpi.b	#3,(SSTrack_drawing_index).w					; Have we drawed a full frame?
	beq.s	+												; Branch if yes
	move.l	a0,(SSTrack_mappings_bitflags).w				; Save pointer
	move.l	a1,(SSTrack_mappings_uncompressed).w			; Save pointer
	move.l	a2,(SSTrack_mappings_RLE).w						; Save pointer
	lea	(SSDrawRegBuffer_End).w,a3							; Pointer to end of registry buffer
	movem.w	d2-d7,-(a3)										; Save the bit buffers and bit counters
	rts
; ===========================================================================
+
	lea	(SSDrawRegBuffer).w,a2								; Pointer to registry buffer
	moveq	#0,d0
    rept 6
	move.w	d0,(a2)+										; Clear bit buffers and bit counters
    endm
	rts
; ===========================================================================

;loc_5D8A
SSTrackDrawLineFlipLoop:
	adda_.w	#1,a5											; Increment loop counter
	cmpa.w	#0,a5											; Have all 8 lines been drawn?
	beq.w	SSTrackDraw_return								; If yes, return
	lea	(PNT_Buffer).w,a6									; Destination buffer
	swap	d0												; High word starts at 0
	addi.w	#$100,d0										; Adding $100 means seek to end of current line/start of next line
	andi.w	#$F00,d0										; Keep to confines
	adda.w	d0,a6											; Seek to end of current line
	swap	d0												; Leaves the low word of d0 free for use

;loc_5DA8
SSTrackDrawFlipLoop_Inner:
	moveq	#0,d1
	subq.w	#1,d7											; Subtract 1 from bit counter
	bpl.s	+												; Branch if we still have bits we can use
	move.b	(a0)+,d6										; Get a new byte from bit flags
	moveq	#7,d7											; We now have 8 fresh new bits
+
	add.b	d6,d6											; Do we have to use RLE compression?
	bcc.s	SSTrackDrawFlipRLE								; Branch if yes
	subq.b	#1,d5											; Subtract 1 from bit counter
	bpl.s	+												; Branch if we still have bits we can use
	move.b	(a1)+,d4										; Get a new byte from uncompressed mappings pointer
	moveq	#7,d5											; We now have 8 fresh new bits
+
	add.b	d4,d4											; Do we need a 10-bit index?
	bcc.s	+												; Branch if not
	move.w	#$A,d0											; d0 = 10 bits
	sub.b	d5,d0											; d0 = 10 - d5
	subq.b	#3,d0											; d0 =  7 - d5; why not shorten it to 'moveq	#7,d0 \n	sub.b	d5,d0'?
	add.w	d0,d0											; Convert into table index
	move.w	SSTrackDrawFlipUnc_Read10LUT(pc,d0.w),d0
	jmp	SSTrackDrawFlipUnc_Read10LUT(pc,d0.w)
; ===========================================================================
;off_5DD4
SSTrackDrawFlipUnc_Read10LUT:	offsetTable
		offsetTableEntry.w SSTrackDrawFlipUnc_Read10_Got7	; 0
		offsetTableEntry.w SSTrackDrawFlipUnc_Read10_Got6	; 1
		offsetTableEntry.w SSTrackDrawFlipUnc_Read10_Got5	; 2
		offsetTableEntry.w SSTrackDrawFlipUnc_Read10_Got4	; 3
		offsetTableEntry.w SSTrackDrawFlipUnc_Read10_Got3	; 4
		offsetTableEntry.w SSTrackDrawFlipUnc_Read10_Got2	; 5
		offsetTableEntry.w SSTrackDrawFlipUnc_Read10_Got1	; 6
		offsetTableEntry.w SSTrackDrawFlipUnc_Read10_Got0	; 7
; ===========================================================================
+
	move.w	#6,d0											; d0 = 6
	sub.b	d5,d0											; d0 = 6 - d5
	addq.b	#1,d0											; d0 = 7 - d5; why not shorten it to 'moveq	#7,d0 \n	sub.b	d5,d0'?
	add.w	d0,d0											; Convert into table index
	move.w	SSTrackDrawFlipUnc_Read6LUT(pc,d0.w),d0
	jmp	SSTrackDrawFlipUnc_Read6LUT(pc,d0.w)
; ===========================================================================
;off_5DF6
SSTrackDrawFlipUnc_Read6LUT:	offsetTable
		offsetTableEntry.w SSTrackDrawFlipUnc_Read6_Got7	; 0
		offsetTableEntry.w SSTrackDrawFlipUnc_Read6_Got6	; 1
		offsetTableEntry.w SSTrackDrawFlipUnc_Read6_Got5	; 2
		offsetTableEntry.w SSTrackDrawFlipUnc_Read6_Got4	; 3
		offsetTableEntry.w SSTrackDrawFlipUnc_Read6_Got3	; 4
		offsetTableEntry.w SSTrackDrawFlipUnc_Read6_Got2	; 5
		offsetTableEntry.w SSTrackDrawFlipUnc_Read6_Got1	; 6
		offsetTableEntry.w SSTrackDrawFlipUnc_Read6_Got0	; 7
; ===========================================================================
;loc_5E06
SSTrackDrawFlipRLE:
	subq.b	#1,d3											; Subtract 1 from bit counter
	bpl.s	++												; Branch if we still have bits we can use
	move.b	(a2)+,d2										; Get a new byte from RLE mappings pointer
	cmpi.b	#-1,d2											; Is d2 equal to -1?
	bne.s	+												; Branch if not
	moveq	#0,d3											; Set bit counter to zero
	bra.w	SSTrackDrawLineFlipLoop
; ===========================================================================
+
	moveq	#7,d3											; We now have 8 fresh new bits
+
	add.b	d2,d2											; Do we need a 7-bit index?
	bcc.s	+												; Branch if not
	move.w	#7,d0											; d0 = 7
	sub.b	d3,d0											; d0 = 10 - d3
	add.b	d0,d0											; Convert into table index
	move.w	SSTrackDrawFlipRLE_Read7LUT(pc,d0.w),d0
	jmp	SSTrackDrawFlipRLE_Read7LUT(pc,d0.w)
; ===========================================================================
;off_5E2E
SSTrackDrawFlipRLE_Read7LUT:	offsetTable
		offsetTableEntry.w SSTrackDrawFlipRLE_Read7_Got7	; 0
		offsetTableEntry.w SSTrackDrawFlipRLE_Read7_Got6	; 1
		offsetTableEntry.w SSTrackDrawFlipRLE_Read7_Got5	; 2
		offsetTableEntry.w SSTrackDrawFlipRLE_Read7_Got4	; 3
		offsetTableEntry.w SSTrackDrawFlipRLE_Read7_Got3	; 4
		offsetTableEntry.w SSTrackDrawFlipRLE_Read7_Got2	; 5
		offsetTableEntry.w SSTrackDrawFlipRLE_Read7_Got1	; 6
		offsetTableEntry.w SSTrackDrawFlipRLE_Read7_Got0	; 7
; ===========================================================================
+
	move.w	#6,d0											; d0 = 6
	sub.b	d3,d0											; d0 = 6 - d3
	addq.b	#1,d0											; d0 = 7 - d3; why not shorten it to 'moveq	#7,d0 \n	sub.b	d3,d0'?
	add.b	d0,d0											; Convert into table index
	move.w	SSTrackDrawFlipRLE_Read6LUT(pc,d0.w),d0
	jmp	SSTrackDrawFlipRLE_Read6LUT(pc,d0.w)
; ===========================================================================
;off_5E50
SSTrackDrawFlipRLE_Read6LUT:	offsetTable
		offsetTableEntry.w SSTrackDrawFlipRLE_Read6_Got7	; 0
		offsetTableEntry.w SSTrackDrawFlipRLE_Read6_Got6	; 1
		offsetTableEntry.w SSTrackDrawFlipRLE_Read6_Got5	; 2
		offsetTableEntry.w SSTrackDrawFlipRLE_Read6_Got4	; 3
		offsetTableEntry.w SSTrackDrawFlipRLE_Read6_Got3	; 4
		offsetTableEntry.w SSTrackDrawFlipRLE_Read6_Got2	; 5
		offsetTableEntry.w SSTrackDrawFlipRLE_Read6_Got1	; 6
		offsetTableEntry.w SSTrackDrawFlipRLE_Read6_Got0	; 7
; ===========================================================================
;loc_5E60
SSTrackDrawFlipUnc_Read10_Got0:
	; Reads 10 bits from uncompressed mappings, 0 bits in bit buffer
	move.w	#0,d0
	move.b	(a1)+,d0
	lsl.w	#2,d0
	move.b	(a1)+,d4
	rol.b	#2,d4
	move.b	d4,d1
	andi.b	#3,d1
	or.b	d1,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#6,d5											; Bit buffer now has 6 bits
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_5E8A
SSTrackDrawFlipUnc_Read10_Got1:
	; Reads 10 bits from uncompressed mappings, 1 bit in bit buffer
	move.b	d4,d0
	lsl.w	#2,d0
	andi.w	#$200,d0
	move.b	(a1)+,d1
	lsl.w	#1,d1
	or.w	d1,d0
	move.b	(a1)+,d4
	rol.b	#1,d4
	move.b	d4,d1
	andi.b	#1,d1
	or.b	d1,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#7,d5											; Bit buffer now has 7 bits
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_5EBA
SSTrackDrawFlipUnc_Read10_Got2:
	; Reads 10 bits from uncompressed mappings, 2 bits in bit buffer
	move.b	d4,d0
	lsl.w	#2,d0
	andi.w	#$300,d0
	move.b	(a1)+,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#0,d5											; Bit buffer now empty
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_5EDA
SSTrackDrawFlipUnc_Read10_Got3:
	; Reads 10 bits from uncompressed mappings, 3 bits in bit buffer
	move.b	d4,d0
	lsl.w	#2,d0
	andi.w	#$380,d0
	move.b	(a1)+,d4
	ror.b	#1,d4
	move.b	d4,d1
	andi.b	#$7F,d1
	or.b	d1,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#1,d5											; Bit buffer now has 1 bit
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_5F04
SSTrackDrawFlipUnc_Read10_Got4:
	; Reads 10 bits from uncompressed mappings, 4 bits in bit buffer
	move.b	d4,d0
	lsl.w	#2,d0
	andi.w	#$3C0,d0
	move.b	(a1)+,d4
	ror.b	#2,d4
	move.b	d4,d1
	andi.b	#$3F,d1
	or.b	d1,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#2,d5											; Bit buffer now has 2 bits
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_5F2E
SSTrackDrawFlipUnc_Read10_Got5:
	; Reads 10 bits from uncompressed mappings, 5 bits in bit buffer
	move.b	d4,d0
	lsl.w	#2,d0
	andi.w	#$3E0,d0
	move.b	(a1)+,d4
	ror.b	#3,d4
	move.b	d4,d1
	andi.b	#$1F,d1
	or.b	d1,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#3,d5											; Bit buffer now has 3 bits
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_5F58
SSTrackDrawFlipUnc_Read10_Got6:
	; Reads 10 bits from uncompressed mappings, 6 bits in bit buffer
	move.b	d4,d0
	lsl.w	#2,d0
	andi.w	#$3F0,d0
	move.b	(a1)+,d4
	ror.b	#4,d4
	move.b	d4,d1
	andi.b	#$F,d1
	or.b	d1,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#4,d5											; Bit buffer now has 4 bits
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_5F82
SSTrackDrawFlipUnc_Read10_Got7:
	; Reads 10 bits from uncompressed mappings, 7 bits in bit buffer
	move.b	d4,d0
	lsl.w	#2,d0
	andi.w	#$3F8,d0
	move.b	(a1)+,d4
	rol.b	#3,d4
	move.b	d4,d1
	andi.b	#7,d1
	or.b	d1,d0
	addi.w	#(SSPNT_UncLUT_Part2-SSPNT_UncLUT)/2,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#5,d5											; Bit buffer now has 5 bits
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_5FAC
SSTrackDrawFlipUnc_Read6_Got0:
	; Reads 6 bits from uncompressed mappings, 0 bits in bit buffer
	move.b	(a1)+,d4
	ror.b	#2,d4
	move.b	d4,d0
	andi.w	#$3F,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#2,d5											; Bit buffer now has 2 bits
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_5FC8
SSTrackDrawFlipUnc_Read6_Got1:
	; Reads 6 bits from uncompressed mappings, 1 bit in bit buffer
	move.b	d4,d0
	lsr.b	#2,d0
	andi.w	#$20,d0
	move.b	(a1)+,d4
	ror.b	#3,d4
	move.b	d4,d1
	andi.b	#$1F,d1
	or.b	d1,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#3,d5											; Bit buffer now has 3 bits
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_5FEE
SSTrackDrawFlipUnc_Read6_Got2:
	; Reads 6 bits from uncompressed mappings, 2 bits in bit buffer
	move.b	d4,d0
	lsr.b	#2,d0
	andi.w	#$30,d0
	move.b	(a1)+,d4
	ror.b	#4,d4
	move.b	d4,d1
	andi.b	#$F,d1
	or.b	d1,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#4,d5											; Bit buffer now has 4 bits
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_6014
SSTrackDrawFlipUnc_Read6_Got3:
	; Reads 6 bits from uncompressed mappings, 3 bits in bit buffer
	move.b	d4,d0
	lsr.b	#2,d0
	andi.w	#$38,d0
	move.b	(a1)+,d4
	rol.b	#3,d4
	move.b	d4,d1
	andi.b	#7,d1
	or.b	d1,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#5,d5											; Bit buffer now has 5 bits
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_603A
SSTrackDrawFlipUnc_Read6_Got4:
	; Reads 6 bits from uncompressed mappings, 4 bits in bit buffer
	move.b	d4,d0
	lsr.b	#2,d0
	andi.w	#$3C,d0
	move.b	(a1)+,d4
	rol.b	#2,d4
	move.b	d4,d1
	andi.b	#3,d1
	or.b	d1,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#6,d5											; Bit buffer now has 6 bits
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_6060
SSTrackDrawFlipUnc_Read6_Got5:
	; Reads 6 bits from uncompressed mappings, 5 bits in bit buffer
	move.b	d4,d0
	lsr.b	#2,d0
	andi.w	#$3E,d0
	move.b	(a1)+,d4
	rol.b	#1,d4
	move.b	d4,d1
	andi.b	#1,d1
	or.b	d1,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#7,d5											; Bit buffer now has 7 bits
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_6086
SSTrackDrawFlipUnc_Read6_Got6:
	; Reads 6 bits from uncompressed mappings, 6 bits in bit buffer
	lsr.b	#2,d4
	andi.w	#$3F,d4
	add.w	d4,d4
	move.w	(a3,d4.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#0,d5											; Bit buffer now empty
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_609E
SSTrackDrawFlipUnc_Read6_Got7:
	; Reads 6 bits from uncompressed mappings, 7 bits in bit buffer
	ror.b	#2,d4
	move.b	d4,d0
	andi.w	#$3F,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	eori.w	#flip_x|palette_line_3,d0
	move.w	d0,-(a6)
	moveq	#1,d5											; Bit buffer now has 1 bit
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_60B8
SSTrackDrawFlipRLE_Read7_Got0:
	; Reads 7 bits from RLE-compressed mappings, 0 bits in bit buffer
	move.b	(a2)+,d2
	ror.b	#1,d2
	move.b	d2,d0
	andi.w	#$7F,d0
	moveq	#1,d3											; Bit buffer now has 1 bit
	cmpi.b	#$7F,d0
	beq.w	SSTrackDrawLineFlipLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_60EA
SSTrackDrawFlipRLE_Read7_Got1:
	; Reads 7 bits from RLE-compressed mappings, 1 bit in bit buffer
	move.b	d2,d1
	lsr.b	#1,d1
	andi.b	#$40,d1
	move.b	(a2)+,d2
	ror.b	#2,d2
	move.b	d2,d0
	andi.w	#$3F,d0
	or.b	d1,d0
	moveq	#2,d3											; Bit buffer now has 2 bits
	cmpi.b	#$7F,d0
	beq.w	SSTrackDrawLineFlipLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_6126
SSTrackDrawFlipRLE_Read7_Got2:
	; Reads 7 bits from RLE-compressed mappings, 2 bits in bit buffer
	move.b	d2,d1
	lsr.b	#1,d1
	andi.b	#$60,d1
	move.b	(a2)+,d2
	ror.b	#3,d2
	move.b	d2,d0
	andi.w	#$1F,d0
	or.b	d1,d0
	moveq	#3,d3											; Bit buffer now has 3 bits
	cmpi.b	#$7F,d0
	beq.w	SSTrackDrawLineFlipLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_6162
SSTrackDrawFlipRLE_Read7_Got3:
	; Reads 7 bits from RLE-compressed mappings, 3 bits in bit buffer
	move.b	d2,d1
	lsr.b	#1,d1
	andi.b	#$70,d1
	move.b	(a2)+,d2
	ror.b	#4,d2
	move.b	d2,d0
	andi.w	#$F,d0
	or.b	d1,d0
	moveq	#4,d3											; Bit buffer now has 4 bits
	cmpi.b	#$7F,d0
	beq.w	SSTrackDrawLineFlipLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_619E
SSTrackDrawFlipRLE_Read7_Got4:
	; Reads 7 bits from RLE-compressed mappings, 4 bits in bit buffer
	move.b	d2,d1
	lsr.b	#1,d1
	andi.b	#$78,d1
	move.b	(a2)+,d2
	rol.b	#3,d2
	move.b	d2,d0
	andi.w	#7,d0
	or.b	d1,d0
	moveq	#5,d3											; Bit buffer now has 5 bits
	cmpi.b	#$7F,d0
	beq.w	SSTrackDrawLineFlipLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_61DA
SSTrackDrawFlipRLE_Read7_Got5:
	; Reads 7 bits from RLE-compressed mappings, 5 bits in bit buffer
	move.b	d2,d1
	lsr.b	#1,d1
	andi.b	#$7C,d1
	move.b	(a2)+,d2
	rol.b	#2,d2
	move.b	d2,d0
	andi.w	#3,d0
	or.b	d1,d0
	moveq	#6,d3											; Bit buffer now has 6 bits
	cmpi.b	#$7F,d0
	beq.w	SSTrackDrawLineFlipLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_6216
SSTrackDrawFlipRLE_Read7_Got6:
	; Reads 7 bits from RLE-compressed mappings, 6 bits in bit buffer
	move.b	d2,d1
	lsr.b	#1,d1
	andi.b	#$7E,d1
	move.b	(a2)+,d2
	rol.b	#1,d2
	move.b	d2,d0
	andi.w	#1,d0
	or.b	d1,d0
	moveq	#7,d3											; Bit buffer now has 7 bits
	cmpi.b	#$7F,d0
	beq.w	SSTrackDrawLineFlipLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_6252
SSTrackDrawFlipRLE_Read7_Got7:
	; Reads 7 bits from RLE-compressed mappings, 7 bits in bit buffer
	lsr.b	#1,d2
	andi.w	#$7F,d2
	moveq	#0,d3											; Bit buffer now empty
	cmpi.b	#$7F,d2
	beq.w	SSTrackDrawLineFlipLoop
	addi.w	#(SSPNT_RLELUT_Part2-SSPNT_RLELUT)/4,d2
	add.w	d2,d2
	add.w	d2,d2
	move.w	(a4,d2.w),d1
	move.w	2(a4,d2.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_6280
SSTrackDrawFlipRLE_Read6_Got0:
	; Reads 6 bits from RLE-compressed mappings, 0 bits in bit buffer
	move.b	(a2)+,d2
	ror.b	#2,d2
	move.b	d2,d0
	andi.w	#$3F,d0
	add.w	d0,d0
	add.w	d0,d0
	moveq	#2,d3											; Bit buffer now has 2 bits
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_62A6
SSTrackDrawFlipRLE_Read6_Got1:
	; Reads 6 bits from RLE-compressed mappings, 1 bit in bit buffer
	move.b	d2,d0
	lsr.b	#2,d0
	andi.w	#$20,d0
	move.b	(a2)+,d2
	ror.b	#3,d2
	move.b	d2,d1
	andi.b	#$1F,d1
	or.b	d1,d0
	moveq	#3,d3											; Bit buffer now has 3 bits
	add.w	d0,d0
	add.w	d0,d0
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_62D6
SSTrackDrawFlipRLE_Read6_Got2:
	; Reads 6 bits from RLE-compressed mappings, 2 bits in bit buffer
	move.b	d2,d0
	lsr.b	#2,d0
	andi.w	#$30,d0
	move.b	(a2)+,d2
	ror.b	#4,d2
	move.b	d2,d1
	andi.b	#$F,d1
	or.b	d1,d0
	add.w	d0,d0
	add.w	d0,d0
	moveq	#4,d3											; Bit buffer now has 4 bits
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_6306
SSTrackDrawFlipRLE_Read6_Got3:
	; Reads 6 bits from RLE-compressed mappings, 3 bits in bit buffer
	move.b	d2,d0
	lsr.b	#2,d0
	andi.w	#$38,d0
	move.b	(a2)+,d2
	rol.b	#3,d2
	move.b	d2,d1
	andi.b	#7,d1
	or.b	d1,d0
	add.w	d0,d0
	add.w	d0,d0
	moveq	#5,d3											; Bit buffer now has 5 bits
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_6336
SSTrackDrawFlipRLE_Read6_Got4:
	; Reads 6 bits from RLE-compressed mappings, 4 bits in bit buffer
	move.b	d2,d0
	lsr.b	#2,d0
	andi.w	#$3C,d0
	move.b	(a2)+,d2
	rol.b	#2,d2
	move.b	d2,d1
	andi.b	#3,d1
	or.b	d1,d0
	add.w	d0,d0
	add.w	d0,d0
	moveq	#6,d3											; Bit buffer now has 6 bits
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_6366
SSTrackDrawFlipRLE_Read6_Got5:
	; Reads 6 bits from RLE-compressed mappings, 5 bits in bit buffer
	move.b	d2,d0
	lsr.b	#2,d0
	andi.w	#$3E,d0
	move.b	(a2)+,d2
	rol.b	#1,d2
	move.b	d2,d1
	andi.b	#1,d1
	or.b	d1,d0
	add.w	d0,d0
	add.w	d0,d0
	moveq	#7,d3											; Bit buffer now has 7 bits
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_6396
SSTrackDrawFlipRLE_Read6_Got6:
	; Reads 6 bits from RLE-compressed mappings, 6 bits in bit buffer
	lsr.b	#2,d2
	andi.w	#$3F,d2
	add.w	d2,d2
	add.w	d2,d2
	moveq	#0,d3											; Bit buffer now empty
	move.w	(a4,d2.w),d1
	move.w	2(a4,d2.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_63B8
SSTrackDrawFlipRLE_Read6_Got7:
	; Reads 6 bits from RLE-compressed mappings, 7 bits in bit buffer
	ror.b	#2,d2
	move.b	d2,d0
	andi.w	#$3F,d0
	add.w	d0,d0
	add.w	d0,d0
	moveq	#1,d3											; Bit buffer now has 1 bit
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner

; ===========================================================================
; frames of animation of the special stage track
; this chooses how objects curve along the track as well as which track frame to draw
; off_63DC:
Ani_SpecialStageTrack:	offsetTable
	offsetTableEntry.w SSTrackAni_TurnThenRise	; 0
	offsetTableEntry.w SSTrackAni_TurnThenDrop	; 1
	offsetTableEntry.w SSTrackAni_TurnThenStraight	; 2
	offsetTableEntry.w SSTrackAni_Straight		; 3
	offsetTableEntry.w SSTrackAni_StraightThenTurn	; 4
; byte_63E6:
SSTrackAni_TurnThenRise:
	dc.b $26,$27,$28,$29,$2A,$2B,$26 ; turning
	dc.b   0,  1,  2,  3,  4,  5,  6,  7,  8,  9, $A, $B, $C, $D, $E, $F,$10 ; rise
SSTrackAni_TurnThenRise_End:
; byte_63FE:
SSTrackAni_TurnThenDrop:
	dc.b $26,$27,$28,$29,$2A,$2B,$26 ; turning
	dc.b $15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,$20,$21,$22,$23,$24,$25 ; drop
SSTrackAni_TurnThenDrop_End:
; byte_6416:
SSTrackAni_TurnThenStraight:
	dc.b $26,$27,$28,$29,$2A,$2B,$26 ; turning
	dc.b $2C,$2D,$2E,$2F,$30 ; exit turn
SSTrackAni_TurnThenStraight_End:
; byte_6422:
SSTrackAni_Straight:
	dc.b $11,$12,$13,$14,$11,$12,$13,$14 ; straight
	dc.b $11,$12,$13,$14,$11,$12,$13,$14 ; straight
SSTrackAni_Straight_End:
; byte_6432:
SSTrackAni_StraightThenTurn:
	dc.b $11,$12,$13,$14 ; straight
	dc.b $31,$32,$33,$34,$35,$36,$37 ; enter turn
SSTrackAni_StraightThenTurn_End:

	even

; ===========================================================================
; pointers to the mappings for each frame of the special stage track
; indexed into by the numbers used in the above animations
;
; Format of each mappings file:
;	File is divided in 3 segments, with the same structure:
;	Segment structure:
;		4-byte unsigned length of segment (not counting the 4 bytes used for length);
;		the first 2 bytes of each length is ignored, and only the last 2 bytes are
;		actually used.
;		Rest of the segment is mappings data, as follows:
;	1st segment:
;		Mappings data is a bitstream indicating whether to draw a single tile at
;		a time using the uncompressed mappings (see 2nd segment) or a sequence of
;		tiles using the RLE mappings (see 3rd segment).
;	2nd segment:
;		Mappings data is a bitstream: the first bit in each cycle determines how
;		many bits from the stream are to be used as an index to the uncompressed
;		pattern name list SSPNT_UncLUT: if the first bit is set, 10 bits form an
;		index into SSPNT_UncLUT_Part2, otherwise 6 bits are used as an index into
;		SSPNT_UncLUT.
;		These tiles are drawn in palette line 3.
;	3nd segment:
;		Mappings data is a bitstream: the first bit in each cycle determines how
;		many bits from the stream are to be used as an index to the RLE-compressed
;		pattern name list SSPNT_RLELUT: if the first bit is set, 7 bits form an
;		index into SSPNT_RLELUT_Part2, otherwise 6 bits are used as an index into
;		SSPNT_RLELUT.
;		These tiles are drawn in palette line 3, with the high priority bit set.
; off_643E:
Map_SpecialStageTrack:
	dc.l MapSpec_Rise1		;   0
	dc.l MapSpec_Rise2		;   1
	dc.l MapSpec_Rise3		;   2
	dc.l MapSpec_Rise4		;   3
	dc.l MapSpec_Rise5		;   4
	dc.l MapSpec_Rise6		;   5
	dc.l MapSpec_Rise7		;   6
	dc.l MapSpec_Rise8		;   7
	dc.l MapSpec_Rise9		;   8
	dc.l MapSpec_Rise10		;   9
	dc.l MapSpec_Rise11		;  $A
	dc.l MapSpec_Rise12		;  $B
	dc.l MapSpec_Rise13		;  $C
	dc.l MapSpec_Rise14		;  $D	; This may flip the special stage's horizontal orientation
	dc.l MapSpec_Rise15		;  $E
	dc.l MapSpec_Rise16		;  $F
	dc.l MapSpec_Rise17		; $10
	dc.l MapSpec_Straight1	; $11
	dc.l MapSpec_Straight2	; $12	; This may flip the special stage's horizontal orientation
	dc.l MapSpec_Straight3	; $13
	dc.l MapSpec_Straight4	; $14
	dc.l MapSpec_Drop1		; $15
	dc.l MapSpec_Drop2		; $16
	dc.l MapSpec_Drop3		; $17
	dc.l MapSpec_Drop4		; $18
	dc.l MapSpec_Drop5		; $19
	dc.l MapSpec_Drop6		; $1A	; This may flip the special stage's horizontal orientation
	dc.l MapSpec_Drop7		; $1B
	dc.l MapSpec_Drop8		; $1C
	dc.l MapSpec_Drop9		; $1D
	dc.l MapSpec_Drop10		; $1E
	dc.l MapSpec_Drop11		; $1F
	dc.l MapSpec_Drop12		; $20
	dc.l MapSpec_Drop13		; $21
	dc.l MapSpec_Drop14		; $22
	dc.l MapSpec_Drop15		; $23
	dc.l MapSpec_Drop16		; $24
	dc.l MapSpec_Drop17		; $25
	dc.l MapSpec_Turning1	; $26
	dc.l MapSpec_Turning2	; $27
	dc.l MapSpec_Turning3	; $28
	dc.l MapSpec_Turning4	; $29
	dc.l MapSpec_Turning5	; $2A
	dc.l MapSpec_Turning6	; $2B
	dc.l MapSpec_Unturn1	; $2C
	dc.l MapSpec_Unturn2	; $2D
	dc.l MapSpec_Unturn3	; $2E
	dc.l MapSpec_Unturn4	; $2F
	dc.l MapSpec_Unturn5	; $30
	dc.l MapSpec_Turn1		; $31
	dc.l MapSpec_Turn2		; $32
	dc.l MapSpec_Turn3		; $33
	dc.l MapSpec_Turn4		; $34
	dc.l MapSpec_Turn5		; $35
	dc.l MapSpec_Turn6		; $36
	dc.l MapSpec_Turn7		; $37

; These are pattern names. They get sent to either the pattern name table
; buffer or one region of one of the plane A name tables in the special stage.
; They are indexed by the second segment of the mappings in Map_SpecialStageTrack, above.
;word_651E
SSPNT_UncLUT:
	dc.w make_block_tile($0001,0,0,0,1), make_block_tile($0007,0,0,0,1), make_block_tile($002C,0,0,0,1), make_block_tile($000B,0,0,0,1)	; $00
	dc.w make_block_tile($0024,0,0,0,1), make_block_tile($0024,1,0,0,1), make_block_tile($0039,0,0,0,1), make_block_tile($002B,1,0,0,1)	; $04
	dc.w make_block_tile($005D,0,0,0,1), make_block_tile($005D,1,0,0,1), make_block_tile($002B,0,0,0,1), make_block_tile($004A,0,0,0,1)	; $08
	dc.w make_block_tile($0049,0,0,0,1), make_block_tile($0037,0,0,0,1), make_block_tile($0049,1,0,0,1), make_block_tile($0045,0,0,0,1)	; $0C
	dc.w make_block_tile($0045,1,0,0,1), make_block_tile($003A,1,0,0,1), make_block_tile($0048,0,0,0,1), make_block_tile($0050,1,0,0,1)	; $10
	dc.w make_block_tile($0036,0,0,0,1), make_block_tile($0037,1,0,0,1), make_block_tile($003A,0,0,0,1), make_block_tile($0050,0,0,0,1)	; $14
	dc.w make_block_tile($0042,1,0,0,1), make_block_tile($0042,0,0,0,1), make_block_tile($0015,1,0,0,1), make_block_tile($001D,0,0,0,1)	; $18
	dc.w make_block_tile($004B,0,0,0,1), make_block_tile($0017,1,0,0,1), make_block_tile($0048,1,0,0,1), make_block_tile($0036,1,0,0,1)	; $1C
	dc.w make_block_tile($0038,0,0,0,1), make_block_tile($004B,1,0,0,1), make_block_tile($0015,0,0,0,1), make_block_tile($0021,0,0,0,1)	; $20
	dc.w make_block_tile($0017,0,0,0,1), make_block_tile($0033,0,0,0,1), make_block_tile($001A,0,0,0,1), make_block_tile($002A,0,0,0,1)	; $24
	dc.w make_block_tile($005E,0,0,0,1), make_block_tile($0028,0,0,0,1), make_block_tile($0030,0,0,0,1), make_block_tile($0021,1,0,0,1)	; $28
	dc.w make_block_tile($0038,1,0,0,1), make_block_tile($001A,1,0,0,1), make_block_tile($0025,0,0,0,1), make_block_tile($005E,1,0,0,1)	; $2C
	dc.w make_block_tile($0025,1,0,0,1), make_block_tile($0033,1,0,0,1), make_block_tile($0003,0,0,0,1), make_block_tile($0014,1,0,0,1)	; $30
	dc.w make_block_tile($0014,0,0,0,1), make_block_tile($0004,0,0,0,1), make_block_tile($004E,0,0,0,1), make_block_tile($0003,1,0,0,1)	; $34
	dc.w make_block_tile($000C,0,0,0,1), make_block_tile($002A,1,0,0,1), make_block_tile($0002,0,0,0,1), make_block_tile($0051,0,0,0,1)	; $38
	dc.w make_block_tile($0040,0,0,0,1), make_block_tile($003D,0,0,0,1), make_block_tile($0019,0,0,0,1), make_block_tile($0052,0,0,0,1)	; $3C
;word_659E
SSPNT_UncLUT_Part2:
	dc.w make_block_tile($0009,0,0,0,1), make_block_tile($005A,0,0,0,1), make_block_tile($0030,1,0,0,1), make_block_tile($004E,1,0,0,1)	; $40
	dc.w make_block_tile($0052,1,0,0,1), make_block_tile($0051,1,0,0,1), make_block_tile($0009,1,0,0,1), make_block_tile($0040,1,0,0,1)	; $44
	dc.w make_block_tile($002F,0,0,0,1), make_block_tile($005A,1,0,0,1), make_block_tile($0018,1,0,0,1), make_block_tile($0034,0,0,0,1)	; $48
	dc.w make_block_tile($0019,1,0,0,1), make_block_tile($002F,1,0,0,1), make_block_tile($003D,1,0,0,1), make_block_tile($003E,0,0,0,1)	; $4C
	dc.w make_block_tile($0018,0,0,0,1), make_block_tile($000C,1,0,0,1), make_block_tile($0012,0,0,0,1), make_block_tile($0004,1,0,0,1)	; $50
	dc.w make_block_tile($0026,0,0,0,1), make_block_tile($0034,1,0,0,1), make_block_tile($0005,1,0,0,1), make_block_tile($003B,0,0,0,1)	; $54
	dc.w make_block_tile($003E,1,0,0,1), make_block_tile($003B,1,0,0,1), make_block_tile($0000,0,0,0,1), make_block_tile($0002,1,0,0,1)	; $58
	dc.w make_block_tile($0005,0,0,0,1), make_block_tile($000D,0,0,0,1), make_block_tile($0055,0,0,0,1), make_block_tile($00AF,0,0,0,1)	; $5C
	dc.w make_block_tile($001C,0,0,0,1), make_block_tile($001B,0,0,0,1), make_block_tile($000D,1,0,0,1), make_block_tile($0016,0,0,0,1)	; $60
	dc.w make_block_tile($0012,1,0,0,1), make_block_tile($001F,0,0,0,1), make_block_tile($0032,1,0,0,1), make_block_tile($0013,0,0,0,1)	; $64
	dc.w make_block_tile($0092,0,0,0,1), make_block_tile($0026,1,0,0,1), make_block_tile($0010,0,0,0,1), make_block_tile($004D,0,0,0,1)	; $68
	dc.w make_block_tile($0047,0,0,0,1), make_block_tile($0092,1,0,0,1), make_block_tile($0000,1,0,0,1), make_block_tile($0062,0,0,0,1)	; $6C
	dc.w make_block_tile($0066,0,0,0,1), make_block_tile($0090,0,0,0,1), make_block_tile($0008,0,0,0,1), make_block_tile($007C,1,0,0,1)	; $70
	dc.w make_block_tile($0067,1,0,0,1), make_block_tile($00F7,1,0,0,1), make_block_tile($000E,0,0,0,1), make_block_tile($0060,0,0,0,1)	; $74
	dc.w make_block_tile($0032,0,0,0,1), make_block_tile($0094,0,0,0,1), make_block_tile($001C,1,0,0,1), make_block_tile($0105,1,0,0,1)	; $78
	dc.w make_block_tile($00B0,1,0,0,1), make_block_tile($0059,0,0,0,1), make_block_tile($000F,0,0,0,1), make_block_tile($0067,0,0,0,1)	; $7C
	dc.w make_block_tile($0068,0,0,0,1), make_block_tile($0094,1,0,0,1), make_block_tile($007C,0,0,0,1), make_block_tile($00B0,0,0,0,1)	; $80
	dc.w make_block_tile($00B1,0,0,0,1), make_block_tile($0006,0,0,0,1), make_block_tile($0041,1,0,0,1), make_block_tile($0087,0,0,0,1)	; $84
	dc.w make_block_tile($0093,0,0,0,1), make_block_tile($00CC,0,0,0,1), make_block_tile($001F,1,0,0,1), make_block_tile($0068,1,0,0,1)	; $88
	dc.w make_block_tile($0041,0,0,0,1), make_block_tile($008F,0,0,0,1), make_block_tile($0090,1,0,0,1), make_block_tile($00C2,0,0,0,1)	; $8C
	dc.w make_block_tile($0013,1,0,0,1), make_block_tile($00C2,1,0,0,1), make_block_tile($005C,0,0,0,1), make_block_tile($0064,0,0,0,1)	; $90
	dc.w make_block_tile($00D8,0,0,0,1), make_block_tile($001B,1,0,0,1), make_block_tile($00CC,1,0,0,1), make_block_tile($0011,1,0,0,1)	; $94
	dc.w make_block_tile($0055,1,0,0,1), make_block_tile($00E2,1,0,0,1), make_block_tile($00F3,1,0,0,1), make_block_tile($0044,0,0,0,1)	; $98
	dc.w make_block_tile($00D8,1,0,0,1), make_block_tile($0085,0,0,0,1), make_block_tile($00A1,0,0,0,1), make_block_tile($00C1,0,0,0,1)	; $9C
	dc.w make_block_tile($0119,0,0,0,1), make_block_tile($0089,1,0,0,1), make_block_tile($000A,1,0,0,1), make_block_tile($0022,1,0,0,1)	; $A0
	dc.w make_block_tile($003F,0,0,0,1), make_block_tile($005B,0,0,0,1), make_block_tile($007F,0,0,0,1), make_block_tile($0086,1,0,0,1)	; $A4
	dc.w make_block_tile($0008,1,0,0,1), make_block_tile($0080,0,0,0,1), make_block_tile($0066,1,0,0,1), make_block_tile($00E0,1,0,0,1)	; $A8
	dc.w make_block_tile($00C1,1,0,0,1), make_block_tile($0020,0,0,0,1), make_block_tile($0022,0,0,0,1), make_block_tile($0054,0,0,0,1)	; $AC
	dc.w make_block_tile($00D2,0,0,0,1), make_block_tile($0059,1,0,0,1), make_block_tile($00B1,1,0,0,1), make_block_tile($0060,1,0,0,1)	; $B0
	dc.w make_block_tile($0119,1,0,0,1), make_block_tile($00A4,1,0,0,1), make_block_tile($008F,1,0,0,1), make_block_tile($000A,0,0,0,1)	; $B4
	dc.w make_block_tile($0061,0,0,0,1), make_block_tile($0075,0,0,0,1), make_block_tile($0095,0,0,0,1), make_block_tile($00B6,0,0,0,1)	; $B8
	dc.w make_block_tile($00E0,0,0,0,1), make_block_tile($0010,1,0,0,1), make_block_tile($0098,1,0,0,1), make_block_tile($005B,1,0,0,1)	; $BC
	dc.w make_block_tile($00D2,1,0,0,1), make_block_tile($0016,1,0,0,1), make_block_tile($0053,0,0,0,1), make_block_tile($0091,0,0,0,1)	; $C0
	dc.w make_block_tile($0096,0,0,0,1), make_block_tile($00A4,0,0,0,1), make_block_tile($00DD,0,0,0,1), make_block_tile($00E6,0,0,0,1)	; $C4
	dc.w make_block_tile($007A,1,0,0,1), make_block_tile($004D,1,0,0,1), make_block_tile($00E6,1,0,0,1), make_block_tile($0011,0,0,0,1)	; $C8
	dc.w make_block_tile($0057,0,0,0,1), make_block_tile($007A,0,0,0,1), make_block_tile($0086,0,0,0,1), make_block_tile($009E,0,0,0,1)	; $CC
	dc.w make_block_tile($00DA,0,0,0,1), make_block_tile($0058,0,0,0,1), make_block_tile($00DC,0,0,0,1), make_block_tile($00E3,0,0,0,1)	; $D0
	dc.w make_block_tile($0063,1,0,0,1), make_block_tile($003C,0,0,0,1), make_block_tile($0056,0,0,0,1), make_block_tile($0069,0,0,0,1)	; $D4
	dc.w make_block_tile($007E,0,0,0,1), make_block_tile($00AE,0,0,0,1), make_block_tile($00B5,0,0,0,1), make_block_tile($00B8,0,0,0,1)	; $D8
	dc.w make_block_tile($00CD,0,0,0,1), make_block_tile($00FB,0,0,0,1), make_block_tile($00FF,0,0,0,1), make_block_tile($005C,1,0,0,1)	; $DC
	dc.w make_block_tile($00CD,1,0,0,1), make_block_tile($0074,1,0,0,1), make_block_tile($00EA,1,0,0,1), make_block_tile($00FF,1,0,0,1)	; $E0
	dc.w make_block_tile($00B5,1,0,0,1), make_block_tile($0043,0,0,0,1), make_block_tile($006C,0,0,0,1), make_block_tile($0074,0,0,0,1)	; $E4
	dc.w make_block_tile($0077,0,0,0,1), make_block_tile($0089,0,0,0,1), make_block_tile($0097,0,0,0,1), make_block_tile($009F,0,0,0,1)	; $E8
	dc.w make_block_tile($00A0,0,0,0,1), make_block_tile($0113,0,0,0,1), make_block_tile($011B,0,0,0,1), make_block_tile($0078,1,0,0,1)	; $EC
	dc.w make_block_tile($000F,1,0,0,1), make_block_tile($00E1,1,0,0,1), make_block_tile($00FB,1,0,0,1), make_block_tile($0128,1,0,0,1)	; $F0
	dc.w make_block_tile($0063,0,0,0,1), make_block_tile($0084,0,0,0,1), make_block_tile($008D,0,0,0,1), make_block_tile($00CB,0,0,0,1)	; $F4
	dc.w make_block_tile($00D7,0,0,0,1), make_block_tile($00E9,0,0,0,1), make_block_tile($0128,0,0,0,1), make_block_tile($0138,0,0,0,1)	; $F8
	dc.w make_block_tile($00AE,1,0,0,1), make_block_tile($00EC,1,0,0,1), make_block_tile($0031,0,0,0,1), make_block_tile($004C,0,0,0,1)	; $FC
	dc.w make_block_tile($00E2,0,0,0,1), make_block_tile($00EA,0,0,0,1), make_block_tile($0064,1,0,0,1), make_block_tile($0029,0,0,0,1)	; $100
	dc.w make_block_tile($002D,0,0,0,1), make_block_tile($006D,0,0,0,1), make_block_tile($0078,0,0,0,1), make_block_tile($0088,0,0,0,1)	; $104
	dc.w make_block_tile($00B4,0,0,0,1), make_block_tile($00BE,0,0,0,1), make_block_tile($00CF,0,0,0,1), make_block_tile($00E1,0,0,0,1)	; $108
	dc.w make_block_tile($00E4,0,0,0,1), make_block_tile($0054,1,0,0,1), make_block_tile($00D6,1,0,0,1), make_block_tile($00D7,1,0,0,1)	; $10C
	dc.w make_block_tile($0061,1,0,0,1), make_block_tile($012B,1,0,0,1), make_block_tile($0047,1,0,0,1), make_block_tile($0035,0,0,0,1)	; $110
	dc.w make_block_tile($006A,0,0,0,1), make_block_tile($0072,0,0,0,1), make_block_tile($0073,0,0,0,1), make_block_tile($0098,0,0,0,1)	; $114
	dc.w make_block_tile($00D5,0,0,0,1), make_block_tile($00D6,0,0,0,1), make_block_tile($0116,0,0,0,1), make_block_tile($011E,0,0,0,1)	; $118
	dc.w make_block_tile($0126,0,0,0,1), make_block_tile($0127,0,0,0,1), make_block_tile($012F,0,0,0,1), make_block_tile($015D,0,0,0,1)	; $11C
	dc.w make_block_tile($0069,1,0,0,1), make_block_tile($0088,1,0,0,1), make_block_tile($0075,1,0,0,1), make_block_tile($0097,1,0,0,1)	; $120
	dc.w make_block_tile($00B4,1,0,0,1), make_block_tile($00D1,1,0,0,1), make_block_tile($00D4,1,0,0,1), make_block_tile($00D5,1,0,0,1)	; $124
	dc.w make_block_tile($00CB,1,0,0,1), make_block_tile($00E4,1,0,0,1), make_block_tile($0091,1,0,0,1), make_block_tile($0062,1,0,0,1)	; $128
	dc.w make_block_tile($0006,1,0,0,1), make_block_tile($00B8,1,0,0,1), make_block_tile($0065,0,0,0,1), make_block_tile($006E,0,0,0,1)	; $12C
	dc.w make_block_tile($0071,0,0,0,1), make_block_tile($007D,0,0,0,1), make_block_tile($00D1,0,0,0,1), make_block_tile($00E7,0,0,0,1)	; $130
	dc.w make_block_tile($00F9,0,0,0,1), make_block_tile($0108,0,0,0,1), make_block_tile($012E,0,0,0,1), make_block_tile($014B,0,0,0,1)	; $134
	dc.w make_block_tile($0081,1,0,0,1), make_block_tile($0085,1,0,0,1), make_block_tile($0077,1,0,0,1), make_block_tile($007E,1,0,0,1)	; $138
	dc.w make_block_tile($0095,1,0,0,1), make_block_tile($00DF,1,0,0,1), make_block_tile($0087,1,0,0,1), make_block_tile($006C,1,0,0,1)	; $13C
	dc.w make_block_tile($00F5,1,0,0,1), make_block_tile($0108,1,0,0,1), make_block_tile($0079,1,0,0,1), make_block_tile($006D,1,0,0,1)	; $140
	dc.w make_block_tile($012A,1,0,0,1), make_block_tile($00AA,1,0,0,1), make_block_tile($001E,0,0,0,1), make_block_tile($0027,0,0,0,1)	; $144
	dc.w make_block_tile($0046,0,0,0,1), make_block_tile($005F,0,0,0,1), make_block_tile($0070,0,0,0,1), make_block_tile($0079,0,0,0,1)	; $148
	dc.w make_block_tile($009A,0,0,0,1), make_block_tile($00AA,0,0,0,1), make_block_tile($00C3,0,0,0,1), make_block_tile($00D3,0,0,0,1)	; $14C
	dc.w make_block_tile($00D4,0,0,0,1), make_block_tile($00DE,0,0,0,1), make_block_tile($00DF,0,0,0,1), make_block_tile($00F8,0,0,0,1)	; $150
	dc.w make_block_tile($0100,0,0,0,1), make_block_tile($0101,0,0,0,1), make_block_tile($012B,0,0,0,1), make_block_tile($0133,0,0,0,1)	; $154
	dc.w make_block_tile($0136,0,0,0,1), make_block_tile($0143,0,0,0,1), make_block_tile($0151,0,0,0,1), make_block_tile($002E,1,0,0,1)	; $158
	dc.w make_block_tile($009E,1,0,0,1), make_block_tile($0099,1,0,0,1), make_block_tile($00D3,1,0,0,1), make_block_tile($00DD,1,0,0,1)	; $15C
	dc.w make_block_tile($00DE,1,0,0,1), make_block_tile($00E9,1,0,0,1), make_block_tile($00EF,1,0,0,1), make_block_tile($00F0,1,0,0,1)	; $160
	dc.w make_block_tile($00F8,1,0,0,1), make_block_tile($0127,1,0,0,1), make_block_tile($00BE,1,0,0,1), make_block_tile($0096,1,0,0,1)	; $164
	dc.w make_block_tile($004F,0,0,0,1), make_block_tile($006F,0,0,0,1), make_block_tile($0081,0,0,0,1), make_block_tile($008B,0,0,0,1)	; $168
	dc.w make_block_tile($008E,0,0,0,1), make_block_tile($009C,0,0,0,1), make_block_tile($00A3,0,0,0,1), make_block_tile($00B3,0,0,0,1)	; $16C
	dc.w make_block_tile($00C0,0,0,0,1), make_block_tile($00CE,0,0,0,1), make_block_tile($00F0,0,0,0,1), make_block_tile($00F1,0,0,0,1)	; $170
	dc.w make_block_tile($00F5,0,0,0,1), make_block_tile($00F7,0,0,0,1), make_block_tile($0102,0,0,0,1), make_block_tile($0104,0,0,0,1)	; $174
	dc.w make_block_tile($0105,0,0,0,1), make_block_tile($0109,0,0,0,1), make_block_tile($010C,0,0,0,1), make_block_tile($0114,0,0,0,1)	; $178
	dc.w make_block_tile($0118,0,0,0,1), make_block_tile($0120,0,0,0,1), make_block_tile($0124,0,0,0,1), make_block_tile($0125,0,0,0,1)	; $17C
	dc.w make_block_tile($012A,0,0,0,1), make_block_tile($0130,0,0,0,1), make_block_tile($0132,0,0,0,1), make_block_tile($0137,0,0,0,1)	; $180
	dc.w make_block_tile($0159,0,0,0,1), make_block_tile($0165,0,0,0,1), make_block_tile($003F,1,0,0,1), make_block_tile($006B,1,0,0,1)	; $184
	dc.w make_block_tile($0080,1,0,0,1), make_block_tile($0053,1,0,0,1), make_block_tile($00C6,1,0,0,1), make_block_tile($00CF,1,0,0,1)	; $188
	dc.w make_block_tile($00D9,1,0,0,1), make_block_tile($00DC,1,0,0,1), make_block_tile($0056,1,0,0,1), make_block_tile($00B6,1,0,0,1)	; $18C
	dc.w make_block_tile($00F9,1,0,0,1), make_block_tile($0102,1,0,0,1), make_block_tile($0104,1,0,0,1), make_block_tile($0115,1,0,0,1)	; $190
	dc.w make_block_tile($006A,1,0,0,1), make_block_tile($0113,1,0,0,1), make_block_tile($0072,1,0,0,1), make_block_tile($0035,1,0,0,1)	; $194
	dc.w make_block_tile($0138,1,0,0,1), make_block_tile($015D,1,0,0,1), make_block_tile($0143,1,0,0,1), make_block_tile($0023,0,0,0,1)	; $198
	dc.w make_block_tile($0076,0,0,0,1), make_block_tile($007B,0,0,0,1), make_block_tile($008A,0,0,0,1), make_block_tile($009D,0,0,0,1)	; $19C
	dc.w make_block_tile($00A6,0,0,0,1), make_block_tile($00A8,0,0,0,1), make_block_tile($00AC,0,0,0,1), make_block_tile($00B2,0,0,0,1)	; $1A0
	dc.w make_block_tile($00B7,0,0,0,1), make_block_tile($00BB,0,0,0,1), make_block_tile($00BC,0,0,0,1), make_block_tile($00BD,0,0,0,1)	; $1A4
	dc.w make_block_tile($00C6,0,0,0,1), make_block_tile($00E5,0,0,0,1), make_block_tile($00E8,0,0,0,1), make_block_tile($00EE,0,0,0,1)	; $1A8
	dc.w make_block_tile($00F4,0,0,0,1), make_block_tile($010A,0,0,0,1), make_block_tile($010D,0,0,0,1), make_block_tile($0111,0,0,0,1)	; $1AC
	dc.w make_block_tile($0115,0,0,0,1), make_block_tile($011A,0,0,0,1), make_block_tile($011F,0,0,0,1), make_block_tile($0122,0,0,0,1)	; $1B0
	dc.w make_block_tile($0123,0,0,0,1), make_block_tile($0139,0,0,0,1), make_block_tile($013A,0,0,0,1), make_block_tile($013C,0,0,0,1)	; $1B4
	dc.w make_block_tile($0142,0,0,0,1), make_block_tile($0144,0,0,0,1), make_block_tile($0147,0,0,0,1), make_block_tile($0148,0,0,0,1)	; $1B8
	dc.w make_block_tile($015E,0,0,0,1), make_block_tile($015F,0,0,0,1), make_block_tile($0163,0,0,0,1), make_block_tile($0168,0,0,0,1)	; $1BC
	dc.w make_block_tile($016A,0,0,0,1), make_block_tile($016C,0,0,0,1), make_block_tile($0170,0,0,0,1), make_block_tile($00E5,1,0,0,1)	; $1C0
	dc.w make_block_tile($00CE,1,0,0,1), make_block_tile($00EE,1,0,0,1), make_block_tile($00F1,1,0,0,1), make_block_tile($0084,1,0,0,1)	; $1C4
	dc.w make_block_tile($00FD,1,0,0,1), make_block_tile($0100,1,0,0,1), make_block_tile($00B9,1,0,0,1), make_block_tile($0117,1,0,0,1)	; $1C8
	dc.w make_block_tile($0071,1,0,0,1), make_block_tile($0109,1,0,0,1), make_block_tile($010D,1,0,0,1), make_block_tile($0065,1,0,0,1)	; $1CC
	dc.w make_block_tile($0125,1,0,0,1), make_block_tile($0122,1,0,0,1), make_block_tile($0031,1,0,0,1), make_block_tile($003C,1,0,0,1)	; $1D0
	dc.w make_block_tile($010F,1,0,0,1), make_block_tile($00C5,1,0,0,1), make_block_tile($0133,1,0,0,1), make_block_tile($0137,1,0,0,1)	; $1D4
	dc.w make_block_tile($011F,1,0,0,1), make_block_tile($002E,0,0,0,1), make_block_tile($006B,0,0,0,1), make_block_tile($0082,0,0,0,1)	; $1D8
	dc.w make_block_tile($0083,0,0,0,1), make_block_tile($008C,0,0,0,1), make_block_tile($0099,0,0,0,1), make_block_tile($009B,0,0,0,1)	; $1DC
	dc.w make_block_tile($00A2,0,0,0,1), make_block_tile($00A5,0,0,0,1), make_block_tile($00A7,0,0,0,1), make_block_tile($00A9,0,0,0,1)	; $1E0
	dc.w make_block_tile($00AB,0,0,0,1), make_block_tile($00AD,0,0,0,1), make_block_tile($00B9,0,0,0,1), make_block_tile($00BA,0,0,0,1)	; $1E4
	dc.w make_block_tile($00BF,0,0,0,1), make_block_tile($00C4,0,0,0,1), make_block_tile($00C5,0,0,0,1), make_block_tile($00C7,0,0,0,1)	; $1E8
	dc.w make_block_tile($00C8,0,0,0,1), make_block_tile($00C9,0,0,0,1), make_block_tile($00CA,0,0,0,1), make_block_tile($00D0,0,0,0,1)	; $1EC
	dc.w make_block_tile($00D9,0,0,0,1), make_block_tile($00DB,0,0,0,1), make_block_tile($00EB,0,0,0,1), make_block_tile($00EC,0,0,0,1)	; $1F0
	dc.w make_block_tile($00ED,0,0,0,1), make_block_tile($00EF,0,0,0,1), make_block_tile($00F2,0,0,0,1), make_block_tile($00F3,0,0,0,1)	; $1F4
	dc.w make_block_tile($00F6,0,0,0,1), make_block_tile($00FA,0,0,0,1), make_block_tile($00FC,0,0,0,1), make_block_tile($00FD,0,0,0,1)	; $1F8
	dc.w make_block_tile($00FE,0,0,0,1), make_block_tile($0103,0,0,0,1), make_block_tile($0106,0,0,0,1), make_block_tile($0107,0,0,0,1)	; $2FC
	dc.w make_block_tile($010B,0,0,0,1), make_block_tile($010E,0,0,0,1), make_block_tile($010F,0,0,0,1), make_block_tile($0110,0,0,0,1)	; $200
	dc.w make_block_tile($0112,0,0,0,1), make_block_tile($0117,0,0,0,1), make_block_tile($011C,0,0,0,1), make_block_tile($011D,0,0,0,1)	; $204
	dc.w make_block_tile($0121,0,0,0,1), make_block_tile($0129,0,0,0,1), make_block_tile($012C,0,0,0,1), make_block_tile($012D,0,0,0,1)	; $208
	dc.w make_block_tile($0131,0,0,0,1), make_block_tile($0134,0,0,0,1), make_block_tile($0135,0,0,0,1), make_block_tile($013B,0,0,0,1)	; $20C
	dc.w make_block_tile($013D,0,0,0,1), make_block_tile($013E,0,0,0,1), make_block_tile($013F,0,0,0,1), make_block_tile($0140,0,0,0,1)	; $210
	dc.w make_block_tile($0141,0,0,0,1), make_block_tile($0145,0,0,0,1), make_block_tile($0146,0,0,0,1), make_block_tile($0149,0,0,0,1)	; $214
	dc.w make_block_tile($014A,0,0,0,1), make_block_tile($014C,0,0,0,1), make_block_tile($014D,0,0,0,1), make_block_tile($014E,0,0,0,1)	; $218
	dc.w make_block_tile($014F,0,0,0,1), make_block_tile($0150,0,0,0,1), make_block_tile($0152,0,0,0,1), make_block_tile($0153,0,0,0,1)	; $21C
	dc.w make_block_tile($0154,0,0,0,1), make_block_tile($0155,0,0,0,1), make_block_tile($0156,0,0,0,1), make_block_tile($0157,0,0,0,1)	; $220
	dc.w make_block_tile($0158,0,0,0,1), make_block_tile($015A,0,0,0,1), make_block_tile($015B,0,0,0,1), make_block_tile($015C,0,0,0,1)	; $224
	dc.w make_block_tile($0160,0,0,0,1), make_block_tile($0161,0,0,0,1), make_block_tile($0162,0,0,0,1), make_block_tile($0164,0,0,0,1)	; $228
	dc.w make_block_tile($0166,0,0,0,1), make_block_tile($0167,0,0,0,1), make_block_tile($0169,0,0,0,1), make_block_tile($016B,0,0,0,1)	; $22C
	dc.w make_block_tile($016D,0,0,0,1), make_block_tile($016E,0,0,0,1), make_block_tile($016F,0,0,0,1), make_block_tile($0171,0,0,0,1)	; $230
	dc.w make_block_tile($0172,0,0,0,1), make_block_tile($0173,0,0,0,1), make_block_tile($006E,1,0,0,1), make_block_tile($007D,1,0,0,1)	; $234
	dc.w make_block_tile($00C3,1,0,0,1), make_block_tile($00DB,1,0,0,1), make_block_tile($00E7,1,0,0,1), make_block_tile($00E8,1,0,0,1)	; $238
	dc.w make_block_tile($00EB,1,0,0,1), make_block_tile($00ED,1,0,0,1), make_block_tile($00F2,1,0,0,1), make_block_tile($00F6,1,0,0,1)	; $23C
	dc.w make_block_tile($00FA,1,0,0,1), make_block_tile($00FC,1,0,0,1), make_block_tile($00FE,1,0,0,1), make_block_tile($002D,1,0,0,1)	; $240
	dc.w make_block_tile($0103,1,0,0,1), make_block_tile($0106,1,0,0,1), make_block_tile($0107,1,0,0,1), make_block_tile($010B,1,0,0,1)	; $244
	dc.w make_block_tile($0073,1,0,0,1), make_block_tile($009A,1,0,0,1), make_block_tile($0129,1,0,0,1), make_block_tile($012C,1,0,0,1)	; $248
	dc.w make_block_tile($012D,1,0,0,1), make_block_tile($0111,1,0,0,1), make_block_tile($013C,1,0,0,1), make_block_tile($0120,1,0,0,1)	; $24C
	dc.w make_block_tile($0146,1,0,0,1), make_block_tile($00A9,1,0,0,1), make_block_tile($009C,1,0,0,1), make_block_tile($0116,1,0,0,1)	; $250
	dc.w make_block_tile($014F,1,0,0,1), make_block_tile($014C,1,0,0,1), make_block_tile($006F,1,0,0,1), make_block_tile($0158,1,0,0,1)	; $254
	dc.w make_block_tile($0156,1,0,0,1), make_block_tile($0159,1,0,0,1), make_block_tile($015A,1,0,0,1), make_block_tile($0161,1,0,0,1)	; $258
	dc.w make_block_tile($007B,1,0,0,1), make_block_tile($0166,1,0,0,1), make_block_tile($011C,1,0,0,1), make_block_tile($0118,1,0,0,1)	; $25C
	dc.w make_block_tile($00A0,1,0,0,1), make_block_tile($00A3,1,0,0,1), make_block_tile($0167,1,0,0,1), make_block_tile($00A1,1,0,0,1)	; $260

; These are run-length encoded pattern names. They get sent to either the
; pattern name table buffer or one region of one of the plane A name tables
; in the special stage.
; They are indexed by the third segment of the mappings in Map_SpecialStageTrack, above.
; Format: PNT,count
;word_69E6
SSPNT_RLELUT:
	dc.w	make_block_tile($0007,0,0,0,0),$0001,	make_block_tile($0001,0,0,0,0),$0001	; $00
	dc.w	make_block_tile($004A,0,0,0,0),$0001,	make_block_tile($0039,0,0,0,0),$0003	; $02
	dc.w	make_block_tile($0001,0,0,0,0),$0005,	make_block_tile($0028,0,0,0,0),$0007	; $04
	dc.w	make_block_tile($002C,0,0,0,0),$0001,	make_block_tile($0001,0,0,0,0),$0002	; $06
	dc.w	make_block_tile($0028,0,0,0,0),$0005,	make_block_tile($0039,0,0,0,0),$0001	; $08
	dc.w	make_block_tile($0028,0,0,0,0),$0009,	make_block_tile($0001,0,0,0,0),$0004	; $0A
	dc.w	make_block_tile($0028,0,0,0,0),$0006,	make_block_tile($0028,0,0,0,0),$0003	; $0C
	dc.w	make_block_tile($004A,0,0,0,0),$0002,	make_block_tile($0001,0,0,0,0),$0003	; $0E
	dc.w	make_block_tile($0028,0,0,0,0),$0004,	make_block_tile($0039,0,0,0,0),$0002	; $10
	dc.w	make_block_tile($0039,0,0,0,0),$0004,	make_block_tile($0001,0,0,0,0),$0006	; $12
	dc.w	make_block_tile($0007,0,0,0,0),$0002,	make_block_tile($002C,0,0,0,0),$0002	; $14
	dc.w	make_block_tile($0028,0,0,0,0),$0001,	make_block_tile($001D,0,0,0,0),$0001	; $16
	dc.w	make_block_tile($0028,0,0,0,0),$0008,	make_block_tile($0028,0,0,0,0),$0002	; $18
	dc.w	make_block_tile($0007,0,0,0,0),$0003,	make_block_tile($0001,0,0,0,0),$0007	; $1A
	dc.w	make_block_tile($0028,0,0,0,0),$000B,	make_block_tile($0039,0,0,0,0),$0005	; $1C
	dc.w	make_block_tile($001D,0,0,0,0),$0003,	make_block_tile($001D,0,0,0,0),$0004	; $1E
	dc.w	make_block_tile($001D,0,0,0,0),$0002,	make_block_tile($001D,0,0,0,0),$0005	; $20
	dc.w	make_block_tile($0028,0,0,0,0),$000D,	make_block_tile($000B,0,0,0,0),$0001	; $22
	dc.w	make_block_tile($0028,0,0,0,0),$000A,	make_block_tile($0039,0,0,0,0),$0006	; $24
	dc.w	make_block_tile($0039,0,0,0,0),$0007,	make_block_tile($002C,0,0,0,0),$0003	; $26
	dc.w	make_block_tile($001D,0,0,0,0),$0009,	make_block_tile($004A,0,0,0,0),$0003	; $28
	dc.w	make_block_tile($001D,0,0,0,0),$0007,	make_block_tile($0028,0,0,0,0),$000F	; $2A
	dc.w	make_block_tile($001D,0,0,0,0),$000B,	make_block_tile($001D,0,0,0,0),$0011	; $2C
	dc.w	make_block_tile($001D,0,0,0,0),$000D,	make_block_tile($001D,0,0,0,0),$0008	; $2E
	dc.w	make_block_tile($0028,0,0,0,0),$0011,	make_block_tile($001D,0,0,0,0),$0006	; $30
	dc.w	make_block_tile($000B,0,0,0,0),$0002,	make_block_tile($001D,0,0,0,0),$0015	; $32
	dc.w	make_block_tile($0028,0,0,0,0),$000C,	make_block_tile($001D,0,0,0,0),$000A	; $34
	dc.w	make_block_tile($0028,0,0,0,0),$000E,	make_block_tile($0001,0,0,0,0),$0008	; $36
	dc.w	make_block_tile($001D,0,0,0,0),$000F,	make_block_tile($0028,0,0,0,0),$0010	; $38
	dc.w	make_block_tile($0007,0,0,0,0),$0006,	make_block_tile($001D,0,0,0,0),$0013	; $3A
	dc.w	make_block_tile($004A,0,0,0,0),$0004,	make_block_tile($001D,0,0,0,0),$0017	; $3C
	dc.w	make_block_tile($0007,0,0,0,0),$0004,	make_block_tile($000B,0,0,0,0),$0003	; $3E
;word_6AE6
SSPNT_RLELUT_Part2:
	dc.w	make_block_tile($001D,0,0,0,0),$001B,	make_block_tile($004A,0,0,0,0),$0006	; $40
	dc.w	make_block_tile($001D,0,0,0,0),$001D,	make_block_tile($004A,0,0,0,0),$0005	; $42
	dc.w	make_block_tile($0001,0,0,0,0),$0009,	make_block_tile($0007,0,0,0,0),$0005	; $44
	dc.w	make_block_tile($001D,0,0,0,0),$001E,	make_block_tile($001D,0,0,0,0),$0019	; $46
	dc.w	make_block_tile($0001,0,0,0,0),$0011,	make_block_tile($001D,0,0,0,0),$000C	; $48
	dc.w	make_block_tile($001D,0,0,0,0),$007F,	make_block_tile($002C,0,0,0,0),$0004	; $4A
	dc.w	make_block_tile($001D,0,0,0,0),$000E,	make_block_tile($001D,0,0,0,0),$001C	; $4C
	dc.w	make_block_tile($004A,0,0,0,0),$000A,	make_block_tile($001D,0,0,0,0),$001A	; $4E
	dc.w	make_block_tile($004A,0,0,0,0),$0007,	make_block_tile($001D,0,0,0,0),$0018	; $50
	dc.w	make_block_tile($000B,0,0,0,0),$0004,	make_block_tile($001D,0,0,0,0),$0012	; $52
	dc.w	make_block_tile($001D,0,0,0,0),$0010,	make_block_tile($0001,0,0,0,0),$000F	; $54
	dc.w	make_block_tile($000B,0,0,0,0),$0005,	make_block_tile($0001,0,0,0,0),$000D	; $56
	dc.w	make_block_tile($0001,0,0,0,0),$0013,	make_block_tile($004A,0,0,0,0),$0009	; $58
	dc.w	make_block_tile($004A,0,0,0,0),$000B,	make_block_tile($004A,0,0,0,0),$000C	; $5A
	dc.w	make_block_tile($002C,0,0,0,0),$0005,	make_block_tile($001D,0,0,0,0),$0014	; $5C
	dc.w	make_block_tile($000B,0,0,0,0),$0007,	make_block_tile($001D,0,0,0,0),$0016	; $5E
	dc.w	make_block_tile($0001,0,0,0,0),$000C,	make_block_tile($0001,0,0,0,0),$000E	; $60
	dc.w	make_block_tile($004A,0,0,0,0),$0008,	make_block_tile($001D,0,0,0,0),$005F	; $62
	dc.w	make_block_tile($0001,0,0,0,0),$000A,	make_block_tile($000B,0,0,0,0),$0006	; $64
	dc.w	make_block_tile($000B,0,0,0,0),$0008,	make_block_tile($000B,0,0,0,0),$000A	; $66
	dc.w	make_block_tile($0039,0,0,0,0),$0008,	make_block_tile($000B,0,0,0,0),$0009	; $68
	dc.w	make_block_tile($002C,0,0,0,0),$0006,	make_block_tile($0001,0,0,0,0),$0010	; $6A
	dc.w	make_block_tile($000B,0,0,0,0),$000C,	make_block_tile($0001,0,0,0,0),$000B	; $6C
	dc.w	make_block_tile($0001,0,0,0,0),$0012,	make_block_tile($0007,0,0,0,0),$0007	; $6E
	dc.w	make_block_tile($001D,0,0,0,0),$001F,	make_block_tile($0028,0,0,0,0),$0012	; $70
	dc.w	make_block_tile($000B,0,0,0,0),$000B,	make_block_tile($002C,0,0,0,0),$0007	; $72
	dc.w	make_block_tile($002C,0,0,0,0),$000B,	make_block_tile($001D,0,0,0,0),$0023	; $74
	dc.w	make_block_tile($0001,0,0,0,0),$0015,	make_block_tile($002C,0,0,0,0),$0008	; $76
	dc.w	make_block_tile($001D,0,0,0,0),$002E,	make_block_tile($001D,0,0,0,0),$003F	; $78
	dc.w	make_block_tile($0001,0,0,0,0),$0014,	make_block_tile($000B,0,0,0,0),$000D	; $7A
	dc.w	make_block_tile($002C,0,0,0,0),$0009,	make_block_tile($002C,0,0,0,0),$000A	; $7C
	dc.w	make_block_tile($001D,0,0,0,0),$0025,	make_block_tile($001D,0,0,0,0),$0055	; $7E
	dc.w	make_block_tile($001D,0,0,0,0),$0071,	make_block_tile($001D,0,0,0,0),$007C	; $80
	dc.w	make_block_tile($004A,0,0,0,0),$000D,	make_block_tile($002C,0,0,0,0),$000C	; $82
	dc.w	make_block_tile($002C,0,0,0,0),$000F,	make_block_tile($002C,0,0,0,0),$0010	; $84

;unknown
;byte_6BFE:
	dc.b $FF,$FB,$FF,$FB,$FF,$FA,$FF,$FA; 528
	dc.b $FF,$FA,$FF,$FA	; 544
; ===========================================================================
; (!)
;loc_6C0A
SSTrackSetOrientation:
	move.b	(SS_Alternate_HorizScroll_Buf).w,(SS_Last_Alternate_HorizScroll_Buf).w
	moveq	#0,d1
	movea.l	(SSTrack_mappings_bitflags).w,a0				; Get frame mappings pointer
	cmpa.l	#MapSpec_Straight2,a0							; Is the track rising or one of the first straight frame?
	blt.s	+												; Branch if yes
	cmpa.l	#MapSpec_Straight3,a0							; Is it straight path frame 3 or higher?
	bge.s	+												; Branch if yes
	; We only get here for straight frame 2
	movea.l	(SS_CurrentLevelLayout).w,a5					; Get current level layout
	move.b	(SpecialStage_CurrentSegment).w,d1				; Get current segment
	move.b	(a5,d1.w),d1									; Get segment geometry
	bpl.s	+++												; Branch if not flipped
-
	st.b	(SSTrack_Orientation).w							; Mark as being flipped
	move.b	(SSTrack_drawing_index).w,d0					; Get drawing position
	cmp.b	(SS_player_anim_frame_timer).w,d0				; Is it lower than the player's frame?
	blt.w	return_6C9A										; Return if yes
	st.b	(SS_Alternate_HorizScroll_Buf).w				; Use the alternate horizontal scroll buffer
	rts
; ===========================================================================
+
	cmpa.l	#MapSpec_Rise14,a0								; Is the track one of the first 13 rising frames?
	blt.s	+												; Branch if yes
	cmpa.l	#MapSpec_Rise15,a0								; Is it rising frame 15 or higher?
	bge.s	+												; Branch if yes
	; We only get here for straight frame 14
	movea.l	(SS_CurrentLevelLayout).w,a5					; Get current level layout
	move.b	(SpecialStage_CurrentSegment).w,d1				; Get current segment
	move.b	(a5,d1.w),d1									; Get segment geometry
	bpl.s	++												; Branch if not flipped
	bra.s	-
; ===========================================================================
+
	cmpa.l	#MapSpec_Drop6,a0								; Is the track before drop frame 6?
	blt.s	return_6C9A										; Return is yes
	cmpa.l	#MapSpec_Drop7,a0								; Is it drop frame 7 or higher?
	bge.s	return_6C9A										; Return if yes
	; We only get here for straight frame 6
	movea.l	(SS_CurrentLevelLayout).w,a5					; Get current level layout
	move.b	(SpecialStage_CurrentSegment).w,d1				; Get current segment
	move.b	(a5,d1.w),d1									; Get segment geometry
	bmi.s	-												; Branch if flipped
+
	sf.b	(SSTrack_Orientation).w							; Mark as being unflipped
	move.b	(SSTrack_drawing_index).w,d0					; Get drawing position
	cmp.b	(SS_player_anim_frame_timer).w,d0				; Is it lower than the player's frame?
	blt.s	return_6C9A										; Return if yes
	sf.b	(SS_Alternate_HorizScroll_Buf).w				; Don't use the alternate horizontal scroll buffer

return_6C9A:
	rts
; End of function SSTrack_Draw


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Initialize the PNT and H scroll table buffers.

ssInitTableBuffers:
	lea	(SS_Horiz_Scroll_Buf_1).w,a1
	lea	(SS_Horiz_Scroll_Buf_2).w,a2
	moveq	#0,d0											; Scroll of 0 for PNTA and PNTB on lines 0 and 1 (normal) or lines 6 and 7 (flipped)
	moveq	#0,d1											; Scroll of 0 for PNTB on lines 2 and 3 (normal) or lines 4 and 5 (flipped)
	moveq	#0,d2											; Scroll of 0 for PNTB on lines 4 and 5 (normal) or lines 2 and 3 (flipped)
	moveq	#0,d3											; Scroll of 0 for PNTB on lines 6 and 7 (normal) or lines 0 and 1 (flipped)
	move.w	#-$100,d1										; Scroll of 3 screens for PNTA on lines 2 and 3 (normal) or lines 4 and 5 (flipped)
	move.w	#-$200,d2										; Scroll of 2 screens for PNTA on lines 4 and 5 (normal) or lines 2 and 3 (flipped)
	move.w	#-$300,d3										; Scroll of 1 screen for PNTA on lines 6 and 7 (normal) or lines 0 and 1 (flipped)
	swap	d1
	swap	d2
	swap	d3
	moveq	#$1F,d4

-	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d1,(a1)+
	move.l	d1,(a1)+
	move.l	d2,(a1)+
	move.l	d2,(a1)+
	move.l	d3,(a1)+
	move.l	d3,(a1)+
	move.l	d3,(a2)+
	move.l	d3,(a2)+
	move.l	d2,(a2)+
	move.l	d2,(a2)+
	move.l	d1,(a2)+
	move.l	d1,(a2)+
	move.l	d0,(a2)+
	move.l	d0,(a2)+
	dbf	d4,-

	rts
; End of function ssInitTableBuffers


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Load compressed special stage data into RAM, or VRAM for the art.

ssLdComprsdData:
	lea	(ArtKos_Special).l,a0
	lea	(Chunk_Table).l,a1
	bsr.w	KosDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_VRAM_Start),VRAM,WRITE),(VDP_control_port).l
	lea	(VDP_data_port).l,a1
	movea.l	#Chunk_Table,a0
	move.w	(a0)+,d0
	subq.w	#1,d0

-   rept 7
	move.l	(a0),(a1)
    endm
	move.l	(a0)+,(a1)
	dbf	d0,-

	lea	(MiscKoz_SpecialPerspective).l,a0
	lea	(SSRAM_MiscKoz_SpecialPerspective).l,a1
	bsr.w	KosDec
	lea	(MiscKoz_SpecialLevelLayout).l,a0
	lea	(SSRAM_MiscNem_SpecialLevelLayout).w,a4
	bsr.w	NemDecToRAM
	lea	(MiscKoz_SpecialObjectLocations).l,a0
	lea	(SSRAM_MiscKoz_SpecialObjectLocations).w,a1
	bsr.w	KosDec
	rts
; End of function ssLdComprsdData


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_6D52
SSPlaneB_Background:
	move	#$2700,sr
	movea.l	#Chunk_Table,a1
	lea	(MapEng_SpecialBackBottom).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialBack,0,0),d0
	bsr.w	EniDec
	movea.l	#Chunk_Table+$400,a1
	lea	(MapEng_SpecialBack).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialBack,0,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_SS_Plane_B_Name_Table + $0000,VRAM,WRITE),d0
	moveq	#$1F,d1
	moveq	#$1F,d2
	jsrto	(PlaneMapToVRAM_H80_SpecialStage).l, PlaneMapToVRAM_H80_SpecialStage
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_SS_Plane_B_Name_Table + $0040,VRAM,WRITE),d0
	moveq	#$1F,d1
	moveq	#$1F,d2
	jsrto	(PlaneMapToVRAM_H80_SpecialStage).l, PlaneMapToVRAM_H80_SpecialStage
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_SS_Plane_B_Name_Table + $0080,VRAM,WRITE),d0
	moveq	#$1F,d1
	moveq	#$1F,d2
	jsrto	(PlaneMapToVRAM_H80_SpecialStage).l, PlaneMapToVRAM_H80_SpecialStage
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_SS_Plane_B_Name_Table + $00C0,VRAM,WRITE),d0
	moveq	#$1F,d1
	moveq	#$1F,d2
	jsrto	(PlaneMapToVRAM_H80_SpecialStage).l, PlaneMapToVRAM_H80_SpecialStage
	move	#$2300,sr
	rts
; End of function SSPlaneB_Background


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_6DD4
SSDecompressPlayerArt:
	lea	(ArtNem_SpecialSonicAndTails).l,a0
	lea	(SSRAM_ArtNem_SpecialSonicAndTails & $FFFFFF).l,a4
	bra.w	NemDecToRAM
; End of function SSDecompressPlayerArt


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_6DE4
SS_ScrollBG:
	bsr.w	SSPlaneB_SetHorizOffset
	bsr.w	SSTrack_SetVscroll
	rts
; End of function SS_ScrollBG

; ===========================================================================
; special stage background vertical and horizontal scroll offsets
off_6DEE:	offsetTable
		offsetTableEntry.w byte_6E04	;  0
		offsetTableEntry.w byte_6E09	;  1
		offsetTableEntry.w byte_6E0E	;  2
		offsetTableEntry.w byte_6E13	;  3
		offsetTableEntry.w byte_6E18	;  4
		offsetTableEntry.w byte_6E1D	;  5
		offsetTableEntry.w byte_6E22	;  6
		offsetTableEntry.w byte_6E27	;  7
		offsetTableEntry.w byte_6E2C	;  8
		offsetTableEntry.w byte_6E31	;  9
		offsetTableEntry.w byte_6E36	; $A
byte_6E04:	dc.b   2,  2,  2,  2,  2
byte_6E09:	dc.b   4,  4,  5,  4,  5
byte_6E0E:	dc.b  $B, $B, $B, $B, $C
byte_6E13:	dc.b   0,  0,  1,  0,  0
byte_6E18:	dc.b   1,  1,  1,  1,  1
byte_6E1D:	dc.b   9,  9,  8,  9,  9
byte_6E22:	dc.b   9,  9,  9,  9, $A
byte_6E27:	dc.b   7,  7,  6,  7,  7
byte_6E2C:	dc.b   0,  1,  1,  1,  0
byte_6E31:	dc.b   4,  3,  3,  3,  4
byte_6E36:	dc.b   0,  0,$FF,  0,  0
	even

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_6E3C
SSPlaneB_SetHorizOffset:
	moveq	#0,d7
	moveq	#0,d6
	moveq	#0,d0
	move.b	(SSTrack_last_anim_frame).w,d2					; Get last track animation frame
	move.b	(SSTrack_anim).w,d0								; Get current track animation
	add.w	d0,d0											; Convert it to an index
	move.w	off_6E54(pc,d0.w),d0
	jmp	off_6E54(pc,d0.w)
; ===========================================================================
off_6E54:	offsetTable
		offsetTableEntry.w +	; 0			; Turn, then rise
		offsetTableEntry.w +	; 1			; Turn, then drop
		offsetTableEntry.w +	; 2			; Turn, then straight
		offsetTableEntry.w ++	; 3 ; rts	; Straight
		offsetTableEntry.w ++	; 4 ; rts	; Straight, then turn
; ===========================================================================
+
	moveq	#0,d1
	cmpi.b	#1,d2											; Was the last frame the first in this segment?
	blt.s	++												; Branch if yes
	moveq	#2,d1
	cmpi.b	#2,d2											; Was the last frame frame 1?
	blt.s	++												; Branch if yes
	moveq	#4,d1
	cmpi.b	#$A,d2											; Was the last frame less than $A?
	blt.s	++												; Branch if yes
	moveq	#2,d1
	cmpi.b	#$B,d2											; Was the last frame $A?
	blt.s	++												; Branch if yes
	moveq	#0,d1
	cmpi.b	#$C,d2											; Was the last frame $B?
	blt.s	++												; Branch if yes
+
	rts
; ===========================================================================
+
	moveq	#0,d0
	moveq	#0,d2
	move.b	(SSTrack_drawing_index).w,d0					; Get drawing position
	lea_	off_6DEE,a0										; a0 = pointer to background scroll data
	adda.w	(a0,d1.w),a0									; a0 = pointer to background scroll data for current animation frame
	move.b	(a0,d0.w),d2									; Get background offset for current frame duration
	tst.b	(SS_Last_Alternate_HorizScroll_Buf).w			; Was the alternate horizontal scroll buffer used last time?
	bne.s	+												; Branch if yes
	tst.b	(SS_Alternate_HorizScroll_Buf).w				; Is the alternate horizontal scroll buffer being used now?
	beq.s	+++												; Branch if not
	bra.s	++
; ===========================================================================
+
	tst.b	(SS_Alternate_HorizScroll_Buf).w				; Is the alternate horizontal scroll buffer still being used?
	bne.s	++												; Branch if yes
	lea	(SS_Horiz_Scroll_Buf_1 + 2).w,a1					; Load horizontal scroll buffer for PNT B
	bra.s	+++
; ===========================================================================
+
	lea	(SS_Horiz_Scroll_Buf_2 + 2).w,a1					; Load alternate horizontal scroll buffer for PNT B
	neg.w	d2												; Change the sign of the background offset
	bra.s	++
; ===========================================================================
+
	lea	(SS_Horiz_Scroll_Buf_1 + 2).w,a1					; Load horizontal scroll buffer for PNT B
	tst.b	(SS_Alternate_HorizScroll_Buf).w				; Is the alternate horizontal scroll buffer being used now?
	beq.s	+												; Branch if not
	lea	(SS_Horiz_Scroll_Buf_2 + 2).w,a1					; Load alternate horizontal scroll buffer for PNT B
	neg.w	d2												; Change the sign of the background offset
+
	move.w	#$FF,d0											; 256 lines
-	sub.w	d2,(a1)+										; Change current line's offset
	adda_.l	#2,a1											; Skip PNTA entry
	dbf	d0,-

	rts
; End of function SSPlaneB_SetHorizOffset

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_6EE0
SSTrack_SetVscroll:
	move.w	(Vscroll_Factor_BG).w,(SSTrack_LastVScroll).w	; Save last vertical scroll value
	moveq	#0,d7											; Set flag to decrease vertical scroll
	moveq	#0,d0
	moveq	#0,d2
	move.b	(SSTrack_last_anim_frame).w,d2					; Get last track animation frame
	move.b	(SSTrack_anim).w,d0								; Get current track animation
	add.w	d0,d0											; Convert it to index
	move.w	off_6EFE(pc,d0.w),d0
	jmp	off_6EFE(pc,d0.w)
; ===========================================================================
off_6EFE:	offsetTable
		offsetTableEntry.w loc_6F0A	; 0			; Turn, then rise
		offsetTableEntry.w loc_6F2A	; 1			; Turn, then drop
		offsetTableEntry.w +		; 2 ; rts	; Turn, then straight
		offsetTableEntry.w loc_6F4C	; 3			; Straight
		offsetTableEntry.w +		; 4 ; rts	; Straight, then turn
; ===========================================================================
+
	rts
; ===========================================================================

loc_6F0A:
	move.b	+(pc,d2.w),d1									; Get current frame's vertical scroll offset
	bpl.s	SSTrack_ApplyVscroll							; Branch if positive
	rts
; ===========================================================================
; Special stage vertical scroll index for 'turn, then rise' animation
+
	dc.b  -1
	dc.b  -1	; 1
	dc.b  -1	; 2
	dc.b  -1	; 3
	dc.b  -1	; 4
	dc.b  -1	; 5
	dc.b  -1	; 6
	dc.b  -1	; 7
	dc.b  -1	; 8
	dc.b  -1	; 9
	dc.b   8	; 10
	dc.b   8	; 11
	dc.b   2	; 12
	dc.b   4	; 13
	dc.b   4	; 14
	dc.b   4	; 15
	dc.b   4	; 16
	dc.b   4	; 17
	dc.b   4	; 18
	dc.b  $A	; 19
	dc.b  $C	; 20
	dc.b  $E	; 21
	dc.b $12	; 22
	dc.b $10	; 23
; ===========================================================================

loc_6F2A:
	st	d7													; Set flag to increase vertical scroll
	move.b	+(pc,d2.w),d1									; Get current frame's vertical scroll offset
	bpl.s	SSTrack_ApplyVscroll							; Branch if positive
	rts
; ===========================================================================
; Special stage vertical scroll index for 'turn, then drop' animation
+
	dc.b  -1
	dc.b  -1	; 1
	dc.b  -1	; 2
	dc.b  -1	; 3
	dc.b  -1	; 4
	dc.b  -1	; 5
	dc.b  -1	; 6
	dc.b  -1	; 7
	dc.b  -1	; 8
	dc.b  -1	; 9
	dc.b  -1	; 10
	dc.b $10	; 11
	dc.b $12	; 12
	dc.b  $E	; 13
	dc.b  $C	; 14
	dc.b  $A	; 15
	dc.b   4	; 16
	dc.b   4	; 17
	dc.b   4	; 18
	dc.b   4	; 19
	dc.b   4	; 20
	dc.b   4	; 21
	dc.b   2	; 22
	dc.b   0	; 23
; ===========================================================================

loc_6F4C:
	tst.b	(SS_Pause_Only_flag).w							; Is the game paused?
	bne.s	+	; rts										; Return if yes
	move.b	++(pc,d2.w),d1									; Get current frame's vertical scroll offset
	bpl.s	SSTrack_ApplyVscroll							; Branch if positive									
+
	rts
; ===========================================================================
; Special stage vertical scroll index for 'straight' animation -- bobbing up and down
+
   rept 4
	dc.b   6
	dc.b   6
	dc.b $14
	dc.b $14
    endm
; ===========================================================================
;loc_6F6A
SSTrack_ApplyVscroll:
	moveq	#0,d0
	moveq	#0,d2
	move.b	(SSTrack_drawing_index).w,d0					; Get drawing position
	lea_	off_6DEE,a0										; a0 = pointer to background scroll data
	adda.w	(a0,d1.w),a0									; a0 = pointer to background scroll data for current animation frame
	move.b	(a0,d0.w),d2									; Get background offset for current frame duration
	tst.b	d7												; Are we supposed to increase the vertical scroll?
	bpl.s	+												; Branch if not
	add.w	d2,(Vscroll_Factor_BG).w						; Increase vertical scroll
	rts
; ===========================================================================
+
	sub.w	d2,(Vscroll_Factor_BG).w						; Decrease vertical scroll
	rts
; End of function SSTrack_SetVscroll

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_6F8E:
SSSingleObjLoad:
	lea	(SS_Dynamic_Object_RAM).w,a1
	move.w	#(SS_Dynamic_Object_RAM_End-SS_Dynamic_Object_RAM)/object_size-1,d5

-	tst.b	id(a1)
	beq.s	+	; rts
	lea	next_object(a1),a1 ; a1=object
	dbf	d5,-
+
	rts
; End of function sub_6F8E

; ===========================================================================

;loc_6FA4:
SSSingleObjLoad2:
	movea.l	a0,a1
	move.w	#SS_Dynamic_Object_RAM_End,d5
	sub.w	a0,d5
    if object_size=$40
	lsr.w	#6,d5
    else
	divu.w	#object_size,d5
    endif
	subq.w	#1,d5
	bcs.s	+	; rts

-	tst.b	id(a1)
	beq.s	+	; rts
	lea	next_object(a1),a1
	dbf	d5,-

+	rts


; ===========================================================================
; ----------------------------------------------------------------------------
; Object 5E - HUD from Special Stage
; ----------------------------------------------------------------------------
; Sprite_6FC0:
Obj5E:
	move.b	routine(a0),d0
	bne.w	JmpTo_DisplaySprite
	move.l	#Obj5E_MapUnc_7070,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialHUD,0,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#0,priority(a0)
	move.b	#1,routine(a0)
	bset	#6,render_flags(a0)
	moveq	#0,d1
	tst.b	(SS_2p_Flag).w
	beq.s	+
	addq.w	#6,d1
	tst.b	(Graphics_Flags).w
	bpl.s	++
	addq.w	#1,d1
	bra.s	++
; ---------------------------------------------------------------------------
+	move.w	(Player_mode).w,d1
	andi.w	#3,d1
	tst.b	(Graphics_Flags).w
	bpl.s	+
	addq.w	#3,d1 ; set special stage tails name to "TAILS" instead of MILES
+
	add.w	d1,d1
	moveq	#0,d2
	moveq	#0,d3
	lea	(SSHUDLayout).l,a1
	lea	sub2_x_pos(a0),a2
	adda.w	(a1,d1.w),a1
	move.b	(a1)+,d3
	move.b	d3,mainspr_childsprites(a0)
	subq.w	#1,d3
	moveq	#0,d0
	move.b	(a1)+,d0

-	move.w	d0,(a2,d2.w)
	move.b	(a1)+,sub2_mapframe-sub2_x_pos(a2,d2.w)	; sub2_mapframe
	addq.w	#next_subspr,d2
	dbf	d3,-

	rts
; ===========================================================================
; off_7042:
SSHUDLayout:	offsetTable
		offsetTableEntry.w SSHUD_SonicMilesTotal	; 0
		offsetTableEntry.w SSHUD_Sonic			; 1
		offsetTableEntry.w SSHUD_Miles			; 2
		offsetTableEntry.w SSHUD_SonicTailsTotal	; 3
		offsetTableEntry.w SSHUD_Sonic_2		; 4
		offsetTableEntry.w SSHUD_Tails			; 5
		offsetTableEntry.w SSHUD_SonicMiles		; 6
		offsetTableEntry.w SSHUD_SonicTails		; 7

; byte_7052:
SSHUD_SonicMilesTotal:
	dc.b   3		; Sprite count
	dc.b   $80		; X-pos
	dc.b   0,  1,  3	; Sprite 1 frame, Sprite 2 frame, etc
; byte_7057:
SSHUD_Sonic:
	dc.b   1
	dc.b   $D4
	dc.b   0
; byte_705A:
SSHUD_Miles:
	dc.b   1
	dc.b   $38
	dc.b   1

; byte_705D:
SSHUD_SonicTailsTotal:
	dc.b   3
	dc.b   $80
	dc.b   0,  2,  3
; byte_7062:
SSHUD_Sonic_2:
	dc.b   1
	dc.b   $D4
	dc.b   0
; byte_7065:
SSHUD_Tails:
	dc.b   1
	dc.b   $38
	dc.b   2

; 2 player
; byte_7068:
SSHUD_SonicMiles:
	dc.b   2
	dc.b   $80
	dc.b   0,  1
; byte_706C:
SSHUD_SonicTails:
	dc.b   2
	dc.b   $80
	dc.b   0,  2
; -----------------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------------
Obj5E_MapUnc_7070:	BINCLUDE "mappings/sprite/obj5E.bin"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 5F - Start banner/"Ending controller" from Special Stage
; ----------------------------------------------------------------------------
; Sprite_70F0:
Obj5F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj5F_Index(pc,d0.w),d1
	jmp	Obj5F_Index(pc,d1.w)
; ===========================================================================
; off_70FE:
Obj5F_Index:	offsetTable
		offsetTableEntry.w Obj5F_Init	;  0
		offsetTableEntry.w Obj5F_Main	;  2
		offsetTableEntry.w loc_71B4	;  4
		offsetTableEntry.w loc_710A	;  6
		offsetTableEntry.w return_723E	;  8
		offsetTableEntry.w loc_7218	; $A
; ===========================================================================

loc_710A:
	moveq	#0,d0
	move.b	angle(a0),d0
	bsr.w	CalcSine
	muls.w	objoff_14(a0),d0
	muls.w	objoff_14(a0),d1
	asr.w	#8,d0
	asr.w	#8,d1
	add.w	d1,x_pos(a0)
	add.w	d0,y_pos(a0)
	cmpi.w	#0,x_pos(a0)
	blt.w	JmpTo_DeleteObject
	cmpi.w	#$100,x_pos(a0)
	bgt.w	JmpTo_DeleteObject
	cmpi.w	#0,y_pos(a0)
	blt.w	JmpTo_DeleteObject

    if removeJmpTos
JmpTo_DisplaySprite 
    endif

	jmpto	(DisplaySprite).l, JmpTo_DisplaySprite
; ===========================================================================

; loc_714A:
Obj5F_Init:
	tst.b	(SS_2p_Flag).w
	beq.s	+
	move.w	#8,d0
	jsrto	(Obj5A_PrintPhrase).l, JmpTo_Obj5A_PrintPhrase
+	move.w	#$80,x_pos(a0)
	move.w	#-$40,y_pos(a0)
	move.w	#$100,y_vel(a0)
	move.l	#Obj5F_MapUnc_7240,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialStart,0,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#1,priority(a0)
	move.b	#2,routine(a0)

; loc_718A:
Obj5F_Main:
	jsrto	(ObjectMove).l, JmpTo_ObjectMove
	cmpi.w	#$48,y_pos(a0)
	blt.w	JmpTo_DisplaySprite
	move.w	#0,y_vel(a0)
	move.w	#$48,y_pos(a0)
	move.b	#4,routine(a0)
	move.b	#$F,objoff_2A(a0)
	jmpto	(DisplaySprite).l, JmpTo_DisplaySprite
; ===========================================================================

loc_71B4:
	subi_.b	#1,objoff_2A(a0)
    if ~~removeJmpTos
	bne.w	JmpTo_DisplaySprite
    else
	bne.s	JmpTo_DisplaySprite
    endif
	moveq	#6,d6

; WARNING: the build script needs editing if you rename this label
word_728C_user: lea	(Obj5F_MapUnc_7240+$4C).l,a2 ; word_728C

	moveq	#2,d3
	move.w	#8,objoff_14(a0)
	move.b	#6,routine(a0)

-	bsr.w	SSSingleObjLoad
	bne.s	+
	moveq	#0,d0

	move.w	#bytesToLcnt(object_size),d1

-	move.l	(a0,d0.w),(a1,d0.w)
	addq.w	#4,d0
	dbf	d1,-
    if object_size&3
	move.w	(a0,d0.w),(a1,d0.w)
    endif

	move.b	d3,mapping_frame(a1)
	addq.w	#1,d3
	move.w	#-$28,d2
	move.w	8(a2),d1
	bsr.w	CalcAngle
	move.b	d0,angle(a1)
	lea	$A(a2),a2
+	dbf	d6,--

	move.b	#$A,routine(a0)
	move.w	#$1E,objoff_2A(a0)
	rts
; ===========================================================================

loc_7218:
	subi_.w	#1,objoff_2A(a0)
	bpl.s	+++	; rts
	tst.b	(SS_2p_Flag).w
	beq.s	+
	move.w	#$A,d0
	jsrto	(Obj5A_PrintPhrase).l, JmpTo_Obj5A_PrintPhrase
	bra.s	++
; ===========================================================================
+	jsrto	(Obj5A_CreateRingReqMessage).l, JmpTo_Obj5A_CreateRingReqMessage

+	st.b	(SpecialStage_Started).w
	jmpto	(DeleteObject).l, JmpTo_DeleteObject
; ===========================================================================

+	rts
; ===========================================================================

    if removeJmpTos
JmpTo_DeleteObject 
	jmp	(DeleteObject).l
    endif

; ===========================================================================

return_723E:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
; WARNING: the build script needs editing if you rename this label
;	   or if you change the meaning of frame 2 in these mappings
Obj5F_MapUnc_7240:	BINCLUDE "mappings/sprite/obj5F_a.bin"
; -----------------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------------
Obj5F_MapUnc_72D2:	BINCLUDE "mappings/sprite/obj5F_b.bin"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 87 - Number of rings in Special Stage
; ----------------------------------------------------------------------------
; Sprite_7356:
Obj87:
	moveq	#0,d0
	move.b	objoff_A(a0),d0
	move.w	Obj87_Index(pc,d0.w),d1
	jmp	Obj87_Index(pc,d1.w)
; ===========================================================================
; off_7364:
Obj87_Index:	offsetTable
		offsetTableEntry.w Obj87_Init	; 0
		offsetTableEntry.w loc_7480	; 2
		offsetTableEntry.w loc_753E	; 4
		offsetTableEntry.w loc_75DE	; 6
; ===========================================================================

; loc_736C:
Obj87_Init:
	move.b	#2,objoff_A(a0)		; => loc_7480
	move.l	#Obj5F_MapUnc_72D2,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialHUD,2,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	bset	#6,render_flags(a0)
	move.b	#2,mainspr_childsprites(a0)
	move.w	#$20,d0
	moveq	#0,d1
	lea	sub2_x_pos(a0),a1
	move.w	#$48,(a1)			; sub2_x_pos
	move.w	d0,sub2_y_pos-sub2_x_pos(a1)	; sub2_y_pos
	move.w	d1,mainspr_height-sub2_x_pos(a1) ; mainspr_height and sub2_mapframe
	move.w	#$E0,sub3_x_pos-sub2_x_pos(a1)	; sub3_x_pos
	move.w	d0,sub3_y_pos-sub2_x_pos(a1)	; sub3_y_pos
	move.w	d1,mapping_frame-sub2_x_pos(a1)	; mapping_frame	and sub3_mapframe
	move.w	d0,sub4_y_pos-sub2_x_pos(a1)	; sub4_y_pos
	move.w	d0,sub5_y_pos-sub2_x_pos(a1)	; sub5_y_pos
	move.w	d0,sub6_y_pos-sub2_x_pos(a1)	; sub6_y_pos
	move.w	d0,sub7_y_pos-sub2_x_pos(a1)	; sub7_y_pos
	tst.b	(SS_2p_Flag).w
	bne.s	+++
	cmpi.w	#0,(Player_mode).w
	beq.s	+
	subi_.b	#1,mainspr_childsprites(a0)
	move.w	#$94,(a1)			; sub2_x_pos
	rts
; ===========================================================================
+
	bsr.w	SSSingleObjLoad
	bne.s	+	; rts
	move.b	#ObjID_SSNumberOfRings,id(a1) ; load obj87
	move.b	#4,objoff_A(a1)		; => loc_753E
	move.l	#Obj5F_MapUnc_72D2,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialHUD,2,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	bset	#6,render_flags(a1)
	move.b	#1,mainspr_childsprites(a1)
	lea	sub2_x_pos(a1),a2
	move.w	#$80,(a2)			; sub2_x_pos
	move.w	d0,sub2_y_pos-sub2_x_pos(a2)	; sub2_y_pos
	move.w	d1,mainspr_height-sub2_x_pos(a2) ; mainspr_height and sub2_mapframe
	move.w	d0,sub3_y_pos-sub2_x_pos(a2)	; sub3_y_pos
	move.w	d0,sub4_y_pos-sub2_x_pos(a2)	; sub4_y_pos
/	rts
; ===========================================================================
+
	bsr.w	SSSingleObjLoad
	bne.s	-	; rts
	move.b	#ObjID_SSNumberOfRings,id(a1) ; load obj87
	move.b	#6,objoff_A(a1)		; => loc_75DE
	move.l	#Obj5F_MapUnc_72D2,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialHUD,2,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	bset	#6,render_flags(a1)
	move.b	#0,mainspr_childsprites(a1)
	lea	sub2_x_pos(a1),a2
	move.w	#$2C,d0
	move.w	#$A,d1
	move.w	d0,sub2_y_pos-sub2_x_pos(a2)	; sub2_y_pos
	move.w	d1,mainspr_height-sub2_x_pos(a2) ; mainspr_height and sub2_mapframe
	move.w	d0,sub3_y_pos-sub2_x_pos(a2)	; sub3_y_pos
	move.w	d1,mapping_frame-sub2_x_pos(a2)	; mapping_frame	and sub3_mapframe
	move.w	d0,sub4_y_pos-sub2_x_pos(a2)	; sub4_y_pos
	move.w	d1,sub4_mapframe-1-sub2_x_pos(a2) ; something and sub4_mapframe
	rts
; ===========================================================================

loc_7480:
	moveq	#0,d0
	moveq	#0,d3
	moveq	#0,d5
	lea	sub2_x_pos(a0),a1
	movea.l	a1,a2
	addq.w	#5,a2	; a2 = sub2_mapframe(a0)
	cmpi.w	#2,(Player_mode).w
	beq.s	loc_74EA
	move.b	(MainCharacter+ss_rings_hundreds).w,d0
	beq.s	+
	addq.w	#1,d3
	move.b	d0,(a2)
	lea	next_subspr(a2),a2
+	move.b	(MainCharacter+ss_rings_tens).w,d0
	tst.b	d3
	bne.s	+
	tst.b	d0
	beq.s	++
+	addq.w	#1,d3
	move.b	d0,(a2)
	lea	next_subspr(a2),a2
+	addq.w	#1,d3
	move.b	(MainCharacter+ss_rings_units).w,(a2)
	lea	next_subspr(a2),a2
	move.w	d3,d4
	subq.w	#1,d4
	move.w	#$48,d1
	tst.w	(Player_mode).w
	beq.s	+
	addi.w	#$54,d1
/	move.w	d1,(a1,d5.w)
	addi_.w	#8,d1
	addq.w	#next_subspr,d5
	dbf	d4,-
	cmpi.w	#1,(Player_mode).w
	beq.s	loc_7536

loc_74EA:
	moveq	#0,d0
	moveq	#0,d4
	move.b	(Sidekick+ss_rings_hundreds).w,d0
	beq.s	+
	addq.w	#1,d4
	move.b	d0,(a2)
	lea	next_subspr(a2),a2
+	move.b	(Sidekick+ss_rings_tens).w,d0
	tst.b	d4
	bne.s	+
	tst.b	d0
	beq.s	++
+
	addq.w	#1,d4
	move.b	d0,(a2)
	lea	next_subspr(a2),a2
+	move.b	(Sidekick+ss_rings_units).w,(a2)
	addq.w	#1,d4
	add.w	d4,d3
	subq.w	#1,d4
	move.w	#$E0,d1
	tst.w	(Player_mode).w
	beq.s	+
	subi.w	#$44,d1
/	move.w	d1,(a1,d5.w)
	addi_.w	#8,d1
	addq.w	#6,d5
	dbf	d4,-

loc_7536:
	move.b	d3,mainspr_childsprites(a0)
	jmpto	(DisplaySprite).l, JmpTo_DisplaySprite
; ===========================================================================

loc_753E:
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#1,d3
	move.b	(MainCharacter+ss_rings_units).w,d0
	add.b	(Sidekick+ss_rings_units).w,d0
	move.b	(MainCharacter+ss_rings_tens).w,d1
	add.b	(Sidekick+ss_rings_tens).w,d1
	move.b	(MainCharacter+ss_rings_hundreds).w,d2
	add.b	(Sidekick+ss_rings_hundreds).w,d2
	cmpi.b	#10,d0
	blo.s	+
	addq.w	#1,d1
	subi.b	#10,d0
+
	tst.b	d1
	beq.s	++
	cmpi.b	#10,d1
	blo.s	+
	addi_.b	#1,d2
	subi.b	#10,d1
+
	addq.w	#1,d3
	tst.b	d2
	beq.s	++
	addq.w	#1,d3
	bra.s	++
; ===========================================================================
+
	tst.b	d2
	beq.s	+
	addq.w	#2,d3
+
	lea	sub2_x_pos(a0),a1
	move.b	d3,mainspr_childsprites(a0)
	cmpi.b	#2,d3
	blt.s	+
	beq.s	++
	move.w	#$78,(a1)			; sub2_x_pos
	move.b	d2,sub2_mapframe-sub2_x_pos(a1)	; sub2_mapframe
	move.w	#$80,sub3_x_pos-sub2_x_pos(a1)	; sub3_x_pos
	move.b	d1,sub3_mapframe-sub2_x_pos(a1)	; sub3_mapframe
	move.w	#$88,sub4_x_pos-sub2_x_pos(a1)	; sub4_x_pos
	move.b	d0,sub4_mapframe-sub2_x_pos(a1)	; sub4_mapframe
	jmpto	(DisplaySprite).l, JmpTo_DisplaySprite
; ===========================================================================
+
	move.w	#$80,(a1)			; sub2_x_pos
	move.b	d0,sub2_mapframe-sub2_x_pos(a1)	; sub2_mapframe
	jmpto	(DisplaySprite).l, JmpTo_DisplaySprite
; ===========================================================================
+
	move.w	#$7C,(a1)			; sub2_x_pos
	move.b	d1,sub2_mapframe-sub2_x_pos(a1)	; sub2_mapframe
	move.w	#$84,sub3_x_pos-sub2_x_pos(a1)	; sub3_x_pos
	move.b	d0,sub3_mapframe-sub2_x_pos(a1)	; sub3_mapframe
	jmpto	(DisplaySprite).l, JmpTo_DisplaySprite
; ===========================================================================

loc_75DE:
	move.b	(SS_2P_BCD_Score).w,d0
	bne.s	+
	rts
; ===========================================================================
+
	lea	sub2_x_pos(a0),a1
	moveq	#0,d2
	move.b	d0,d1
	andi.b	#$F0,d0
	beq.s	+
	addq.w	#1,d2
	move.w	#$20,(a1)	; sub2_x_pos
	lea	next_subspr(a1),a1
	subi.b	#$10,d0
	beq.s	+
	addq.w	#1,d2
	move.w	#$30,(a1)	; sub3_x_pos
	lea	next_subspr(a1),a1
	subi.b	#$10,d0
	beq.s	+
	addq.w	#1,d2
	move.w	#$40,(a1)	; sub4_x_pos
	bra.s	++
; ===========================================================================
+
	andi.b	#$F,d1
	beq.s	+
	addq.w	#1,d2
	move.w	#$B8,(a1)	; sub?_x_pos
	lea	next_subspr(a1),a1
	subi_.b	#1,d1
	beq.s	+
	addq.w	#1,d2
	move.w	#$C8,(a1)	; sub?_x_pos
	lea	next_subspr(a1),a1
	subi_.b	#1,d1
	beq.s	+
	addq.w	#1,d2
	move.w	#$D8,(a1)	; sub?_x_pos
+
	move.b	d2,mainspr_childsprites(a0)
	jmpto	(DisplaySprite).l, JmpTo_DisplaySprite

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_7650
SSSetGeometryOffsets:
	move.b	(SSTrack_drawing_index).w,d0					; Get drawing position
	cmp.b	(SS_player_anim_frame_timer).w,d0				; Compare to player frame duration
	beq.s	+												; If both are equal, branch
	rts
; ===========================================================================
+
	moveq	#0,d0
	move.b	(SSTrack_mapping_frame).w,d0					; Get current track mapping frame
	add.w	d0,d0											; Convert to index
	lea	SSCurveOffsets(pc,d0.w),a2							; Load current curve offsets into a2
	move.b	(a2)+,d0										; Get x offset
	tst.b	(SSTrack_Orientation).w							; Is track flipped?
	beq.s	+												; Branch if not
	neg.b	d0												; Change sign of offset
+
	ext.w	d0												; Extend to word
	addi.w	#$80,d0											; Add 128 (why?)
	move.w	d0,(SS_Offset_X).w								; Set X geometry offset
	move.b	(a2),d0											; Get y offset
	ext.w	d0												; Extend to word
	addi.w	#$36,d0											; Add $36 (why?)
	move.w	d0,(SS_Offset_Y).w								; Set Y geometry offset
	rts
; End of function SSSetGeometryOffsets

; ===========================================================================
; Position offsets to sort-of rotate the plane sonic/tails are in
; when the special stage track is curving, so they follow it better.
; Each word seems to be (x_offset, y_offset)
; See also Ani_SpecialStageTrack.
SSCurveOffsets: ; word_768A:
	dc.b $13,   0,   $13,   0,   $13,   0,   $13,   0	; $00
	dc.b   9, -$A,     0,-$1C,     0,-$1C,     0,-$20	; $04
	dc.b   0,-$24,     0,-$2A,     0,-$10,     0,   6	; $08
	dc.b   0,  $E,     0, $10,     0, $12,     0, $12	; $0C
	dc.b   9, $12                                    	; $10; upward curve
	dc.b   0,   0,     0,   0,     0,   0,     0,   0	; $11; straight
	dc.b $13,   0,   $13,   0,   $13,   0,   $13,   0	; $15
	dc.b  $B,  $C,     0,  $C,     0, $12,     0,  $A	; $19
	dc.b   0,   8,     0,   2,     0, $10,     0,-$20	; $1D
	dc.b   0,-$1F,     0,-$1E,     0,-$1B,     0,-$18	; $21
	dc.b   0, -$E                                    	; $25; downward curve
	dc.b $13,   0,   $13,   0,   $13,   0,   $13,   0	; $26
	dc.b $13,   0,   $13,   0                        	; $2B; turning
	dc.b $13,   0,   $13,   0,   $13,   0,   $13,   0	; $2C
	dc.b  $B,   0                                    	; $30; exit turn
	dc.b   0,   0,     0,   0,     0,   0,     0,   0	; $31
	dc.b   0,   0,     0,   0,     3,   0            	; $35; straight
; ===========================================================================
; Subroutine to advance to the next act and get an encoded version
; of the ring requirements.
; Output:
; 	d0, d1: Binary coded decimal version of ring requirements (maximum of 299 rings)
; 	d2: Number of digits in the ring requirements - 1 (minimum 2 digits)
;loc_76FA
SSStartNewAct:
	moveq	#0,d1
	moveq	#1,d2
	move.w	(Current_Special_StageAndAct).w,d0
	move.b	d0,d1
	lsr.w	#8,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d1,d0
	tst.w	(Player_mode).w
	bne.s	+
	move.b	SpecialStage_RingReq_Team(pc,d0.w),d1
	bra.s	++
; ===========================================================================
+
	move.b	SpecialStage_RingReq_Alone(pc,d0.w),d1
+
	move.w	d1,(SS_Ring_Requirement).w
	moveq	#0,d0
	cmpi.w	#100,d1
	blt.s	+
	addq.w	#1,d2
  ; The following code does a more complete binary coded decimal conversion:
    if 1==0
-	addi.w	#$100,d0
	subi.w	#100,d1
	cmpi.w	#100,d1
	bge.s	-
    else
	; This code (the original) is limited to 299 rings:
	subi.w	#100,d1
	move.w	#$100,d0
	cmpi.w	#100,d1
	blt.s	+
	subi.w	#100,d1
	addi.w	#$100,d0
    endif
+
	divu.w	#10,d1
	lsl.w	#4,d1
	or.b	d1,d0
	swap	d1
	or.b	d1,d0
	move.w	d0,d1
	addi_.w	#1,(Current_Special_StageAndAct).w
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Ring requirement values for Sonic and Tails games
;
; This array stores the number of rings you need to get to complete each round
; of each special stage, while playing with both sonic and tails. 4 bytes per
; stage, corresponding to the four possible parts of the level. Last part is unused.
; ----------------------------------------------------------------------------
; Misc_7756:
SpecialStage_RingReq_Team:
	dc.b  40, 80,140,120	; 4
	dc.b  50,100,140,150	; 8
	dc.b  60,110,160,170	; 12
	dc.b  40,100,150,160	; 16
	dc.b  55,110,200,200	; 20
	dc.b  80,140,220,220	; 24
	dc.b 100,190,210,210	; 28
; ----------------------------------------------------------------------------
; Ring requirement values for Sonic or Tails alone games
;
; This array stores the number of rings you need to get to complete each round
; of each special stage, while playing with either sonic or tails. 4 bytes per
; stage, corresponding to the four possible parts of the level. Last part is unused.
; ----------------------------------------------------------------------------
; Misc_7772:
SpecialStage_RingReq_Alone:
	dc.b  30, 70,130,110	; 4
	dc.b  50,100,140,140	; 8
	dc.b  50,110,160,160	; 12
	dc.b  40,110,150,150	; 16
	dc.b  50, 90,160,160	; 20
	dc.b  80,140,210,210	; 24
	dc.b 100,150,190,190	; 28

; special stage palette table
; word_778E:
SpecialStage_Palettes:
	dc.w   PalID_SS1
	dc.w   PalID_SS2
	dc.w   PalID_SS3
	dc.w   PalID_SS4
	dc.w   PalID_SS5
	dc.w   PalID_SS6
	dc.w   PalID_SS7
	dc.w   PalID_SS1_2p
	dc.w   PalID_SS2_2p
	dc.w   PalID_SS3_2p
              
; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_77A2
SSInitPalAndData:
	clr.b	(Current_Special_Act).w
	move.b	#-1,(SpecialStage_LastSegment2).w
	move.w	#0,(Ring_count).w
	move.w	#0,(Ring_count_2P).w
	move.b	#0,(Perfect_rings_flag).w
	move.b	#0,(Got_Emerald).w
	move.b	#4,(SS_Star_color_2).w
	lea	(SS2p_RingBuffer).w,a2
	moveq	#0,d0
	move.w	d0,(a2)+
	move.w	d0,(a2)+
	move.w	d0,(a2)+
	move.w	d0,(a2)+
	move.w	d0,(a2)+
	move.w	d0,(a2)+
	moveq	#PalID_SS,d0
	bsr.w	PalLoad_ForFade
	lea_	SpecialStage_Palettes,a1
	moveq	#0,d0
	move.b	(Current_Special_Stage).w,d0
	add.w	d0,d0
	move.w	d0,d1
	tst.b	(SS_2p_Flag).w
	beq.s	+
	cmpi.b	#4,d0
	blo.s	+
	addi_.w	#6,d0
+
	move.w	(a1,d0.w),d0
	bsr.w	PalLoad_ForFade
	lea	(SSRAM_MiscKoz_SpecialObjectLocations).w,a0
	adda.w	(a0,d1.w),a0
	move.l	a0,(SS_CurrentLevelObjectLocations).w
	lea	(SSRAM_MiscNem_SpecialLevelLayout).w,a0
	adda.w	(a0,d1.w),a0
	move.l	a0,(SS_CurrentLevelLayout).w
	rts
; End of function SSInitPalAndData

; ===========================================================================

 ; temporarily remap characters to title card letter format
 ; Characters are encoded as Aa, Bb, Cc, etc. through a macro
 charset 'A',0	; can't have an embedded 0 in a string
 charset 'B',"\4\8\xC\4\x10\x14\x18\x1C\x1E\x22\x26\x2A\4\4\x30\x34\x38\x3C\x40\x44\x48\x4C\x52\x56\4"
 charset 'a',"\4\4\4\4\4\4\4\4\2\4\4\4\6\4\4\4\4\4\4\4\4\4\6\4\4"
 charset '.',"\x5A"

; letter lookup string
llookup	:= "ABCDEFGHIJKLMNOPQRSTUVWXYZ ."

; macro for defining title card letters in conjunction with the remapped character set
titleLetters macro letters
     ;  ". ZYXWVUTSRQPONMLKJIHGFEDCBA"
used := %0110000000000110000000010000	; set to initial state
c := 0
    rept strlen(letters)
t := substr(letters,c,1)
	if ~~(used&1<<strstr(llookup,t))	; has the letter been used already?
used := used|1<<strstr(llookup,t)	; if not, mark it as used
	dc.b t			; output letter code
	if t=="."
	dc.b 2			; output character size
	else
	dc.b lowstring(t)	; output letter size
	endif
	endif
c := c+1
    endm
	dc.w $FFFF	; output string terminator
    endm

;word_7822:
SpecialStage_ResultsLetters:
	titleLetters	"ACDGHILMPRSTUW."

 charset ; revert character set

; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo_DisplaySprite 
	jmp	(DisplaySprite).l
JmpTo_LoadTitleCardSS 
	jmp	(LoadTitleCardSS).l
JmpTo_DeleteObject 
	jmp	(DeleteObject).l
JmpTo_Obj5A_CreateRingReqMessage 
	jmp	(Obj5A_CreateRingReqMessage).l
JmpTo_Obj5A_PrintPhrase 
	jmp	(Obj5A_PrintPhrase).l
; sub_7862:
JmpTo_ObjectMove 
	jmp	(ObjectMove).l
JmpTo_Hud_Base 
	jmp	(Hud_Base).l

	align 4
    endif
