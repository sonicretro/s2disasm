; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Game Mode: Sega screen
; ----------------------------------------------------------------------------
; loc_37B8:
SegaScreen:
	move.b	#MusID_Stop,d0
	bsr.w	PlayMusic ; stop music
	bsr.w	ClearPLC
	bsr.w	Pal_FadeToBlack

	clearRAM Misc_Variables,Misc_Variables_End

	clearRAM SegaScr_Object_RAM,SegaScr_Object_RAM_End ; fill object RAM with 0

	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8200|(VRAM_SegaScr_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_SegaScr_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $A000
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	move.w	#$8B03,(a6)		; EXT-INT disabled, V scroll by screen, H scroll by line
	move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled
	move.w	#$9003,(a6)		; Scroll table size: 128x32 ($2000 bytes)
	clr.b	(Water_fullscreen_flag).w
	clr.w	(Two_player_mode).w
	move	#$2700,sr
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	ClearScreen

	dmaFillVRAM 0,VRAM_SegaScr_Plane_A_Name_Table,VRAM_SegaScr_Plane_Table_Size ; clear Plane A pattern name table

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Sega_Logo),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_SEGA).l,a0
	bsr.w	NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Trails),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_IntroTrails).l,a0
	bsr.w	NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtUnc_Giant_Sonic),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_SilverSonic).l,a0 ; ?? seems unused here
	bsr.w	NemDec
	lea	(Chunk_Table).l,a1
	lea	(MapEng_SEGA).l,a0
	move.w	#make_art_tile(ArtTile_VRAM_Start,0,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_SegaScr_Plane_B_Name_Table,VRAM,WRITE),d0
	moveq	#$27,d1		; 40 cells wide
	moveq	#$1B,d2		; 28 cells tall
	bsr.w	PlaneMapToVRAM_H80_Sega
	tst.b	(Graphics_Flags).w ; are we on a Japanese Mega Drive?
	bmi.s	SegaScreen_Contin ; if not, branch
	; load an extra sprite to hide the TM (trademark) symbol on the SEGA screen
	lea	(SegaHideTM).w,a1
	move.b	#ObjID_SegaHideTM,id(a1)	; load objB1 at $FFFFB080
	move.b	#$4E,subtype(a1) ; <== ObjB1_SubObjData
; loc_38CE:
SegaScreen_Contin:
	moveq	#PalID_SEGA,d0
	bsr.w	PalLoad_Now
	move.w	#-$A,(PalCycle_Frame).w
	move.w	#0,(PalCycle_Timer).w
	move.w	#0,(SegaScr_VInt_Subrout).w
	move.w	#0,(SegaScr_PalDone_Flag).w
	lea	(SegaScreenObject).w,a1
	move.b	#ObjID_SonicOnSegaScr,id(a1) ; load objB0 (sega screen?) at $FFFFB040
	move.b	#$4C,subtype(a1) ; <== ObjB0_SubObjData
	move.w	#4*60,(Demo_Time_left).w	; 4 seconds
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
; loc_390E:
Sega_WaitPalette:
	move.b	#VintID_SEGA,(Vint_routine).w
	bsr.w	WaitForVint
	jsrto	(RunObjects).l, JmpTo_RunObjects
	jsr	(BuildSprites).l
	tst.b	(SegaScr_PalDone_Flag).w
	beq.s	Sega_WaitPalette
	move.b	#SndID_SegaSound,d0
	bsr.w	PlaySound	; play "SEGA" sound
	move.b	#VintID_SEGA,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	#3*60,(Demo_Time_left).w	; 3 seconds
; loc_3940:
Sega_WaitEnd:
	move.b	#VintID_PCM,(Vint_routine).w
	bsr.w	WaitForVint
	tst.w	(Demo_Time_left).w
	beq.s	Sega_GotoTitle
	move.b	(Ctrl_1_Press).w,d0	; is Start button pressed?
	or.b	(Ctrl_2_Press).w,d0	; (either player)
	andi.b	#button_start_mask,d0
	beq.s	Sega_WaitEnd		; if not, branch
; loc_395E:
Sega_GotoTitle:
	clr.w	(SegaScr_PalDone_Flag).w
	clr.w	(SegaScr_VInt_Subrout).w
	move.b	#GameModeID_TitleScreen,(Game_Mode).w	; => TitleScreen
	rts

; ---------------------------------------------------------------------------
; Subroutine that does the exact same thing as PlaneMapToVRAM_H80_SpecialStage
; (this one is used at the Sega screen)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_396E: ShowVDPGraphics3: PlaneMapToVRAM3:
PlaneMapToVRAM_H80_Sega:
	lea	(VDP_data_port).l,a6
	move.l	#vdpCommDelta(planeLocH80(0,1)),d4	; $1000000
-	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d1,d3
-	move.w	(a1)+,(a6)
	dbf	d3,-
	add.l	d4,d0
	dbf	d2,--
	rts
; End of function PlaneMapToVRAM_H80_Sega

; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
; sub_3990:
JmpTo_RunObjects 
	jmp	(RunObjects).l

	align 4
    endif
