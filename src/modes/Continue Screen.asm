; ----------------------------------------------------------------------------
; Continue Screen
; ----------------------------------------------------------------------------
; loc_7870:
ContinueScreen:
	bsr.w	Pal_FadeToBlack
	move	#$2700,sr
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l
	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	bsr.w	ClearScreen

	clearRAM Object_RAM,Object_RAM_End

    if fixBugs
	; Clear the DMA queue. This fixes the bug where, if you get a
	; Game Over in Hill Top Zone, then Tails' graphics will be corrupted
	; on the Continue screen.
	; This is caused by HTZ's transforming cloud art being loaded over
	; Tails' Continue art: 'Dynamic_HTZ' is responsible for queueing the
	; art to be transferred with 'QueueDMATransfer', which takes effect
	; around the next frame. The problem here is, the art is queued, you
	; die, get a Game Over, advance to the Continue screen, and then
	; finally the art is loaded.
	clr.w	(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w

	; The game leaves this flag set after a Game Over, which causes
	; Sonic to animate incorrectly.
	clr.b	(Super_Sonic_flag).w
    endif

	bsr.w	ContinueScreen_LoadLetters
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_ContinueTails),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_ContinueTails).l,a0
	bsr.w	NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_MiniContinue),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_MiniSonic).l,a0
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	lea	(ArtNem_MiniTails).l,a0
+
	bsr.w	NemDec
	moveq	#$A,d1
	jsr	(ContScrCounter).l
	moveq	#PalID_SS1,d0
	bsr.w	PalLoad_ForFade
	move.w	#0,(Target_palette).w
	move.b	#MusID_Continue,d0
	bsr.w	PlayMusic
	move.w	#(11*60)-1,(Demo_Time_left).w	; 11 seconds minus 1 frame
	clr.b	(Level_started_flag).w
	clr.l	(Camera_X_pos_copy).w
	move.l	#$1000000,(Camera_Y_pos_copy).w
	move.b	#ObjID_ContinueChars,(MainCharacter+id).w ; load ObjDB (Sonic on continue screen)
	move.b	#ObjID_ContinueChars,(Sidekick+id).w ; load ObjDB (Tails on continue screen)
	move.b	#6,(Sidekick+routine).w ; => ObjDB_Tails_Init
	move.b	#ObjID_ContinueText,(ContinueText+id).w ; load ObjDA (continue screen text)
	move.b	#ObjID_ContinueIcons,(ContinueIcons+id).w ; load ObjDA (continue icons)
	move.b	#4,(ContinueIcons+routine).w ; => loc_7AD0
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromBlack
-
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	cmpi.b	#4,(MainCharacter+routine).w
	bhs.s	+
	move	#$2700,sr
	move.w	(Demo_Time_left).w,d1
	divu.w	#60,d1
	andi.l	#$F,d1
	jsr	(ContScrCounter).l
	move	#$2300,sr
+
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	cmpi.w	#$180,(Sidekick+x_pos).w
	bhs.s	+
	cmpi.b	#4,(MainCharacter+routine).w
	bhs.s	-
	tst.w	(Demo_Time_left).w
	bne.w	-
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ---------------------------------------------------------------------------
+
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	move.b	#3,(Life_count).w
	move.b	#3,(Life_count_2P).w
	moveq	#0,d0
	move.w	d0,(Ring_count).w
	move.l	d0,(Timer).w
	move.l	d0,(Score).w
	move.b	d0,(Last_star_pole_hit).w
	move.w	d0,(Ring_count_2P).w
	move.l	d0,(Timer_2P).w
	move.l	d0,(Score_2P).w
	move.b	d0,(Last_star_pole_hit_2P).w
	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w
	subq.b	#1,(Continue_count).w
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_7A04:
ContinueScreen_LoadLetters:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_TitleCard),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_TitleCard).l,a0
	bsr.w	NemDec
	lea	(Level_Layout).w,a4
	lea	(ArtNem_TitleCard2).l,a0
	bsr.w	NemDecToRAM
	lea	(ContinueScreen_AdditionalLetters).l,a0
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ContinueScreen_Additional),VRAM,WRITE),(VDP_control_port).l
	lea	(Level_Layout).w,a1
	lea	(VDP_data_port).l,a6
-
	moveq	#0,d0
	move.b	(a0)+,d0
	bmi.s	+	; rts
	lsl.w	#5,d0
	lea	(a1,d0.w),a2
	moveq	#0,d1
	move.b	(a0)+,d1
	lsl.w	#3,d1
	subq.w	#1,d1

-	move.l	(a2)+,(a6)
	dbf	d1,-

	bra.s	--
; ---------------------------------------------------------------------------
+	rts
; End of function ContinueScreen_LoadLetters

; ===========================================================================

 ; temporarily remap characters to title card letter format
 ; Characters are encoded as Aa, Bb, Cc, etc. through a macro
 charset 'A',0	; can't have an embedded 0 in a string
 charset 'B',"\4\8\xC\4\x10\x14\x18\x1C\x1E\x22\x26\x2A\4\4\x30\x34\x38\x3C\x40\x44\x48\x4C\x52\x56\4"
 charset 'a',"\4\4\4\4\4\4\4\4\2\4\4\4\6\4\4\4\4\4\4\4\4\4\6\4\4"
 charset '.',"\x5A"

; Defines which letters load for the continue screen
; Each letter occurs only once, and  the letters ENOZ (i.e. ZONE) aren't loaded here
; However, this is hidden by the titleLetters macro, and normal titles can be used
; (the macro is defined near SpecialStage_ResultsLetters, which uses it before here)

; word_7A5E:
ContinueScreen_AdditionalLetters:
	titleLetters "CONTINUE"

 charset ; revert character set
; ===========================================================================
