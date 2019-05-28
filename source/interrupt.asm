; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; vertical and horizontal interrupt handlers
; VERTICAL INTERRUPT HANDLER:
V_Int:
	movem.l	d0-a6,-(sp)
	tst.b	(Vint_routine).w
	beq.w	Vint_Lag

-	move.w	(VDP_control_port).l,d0
	andi.w	#8,d0
	beq.s	-

	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.l	(Vscroll_Factor).w,(VDP_data_port).l ; send screen y-axis pos. to VSRAM
	btst	#6,(Graphics_Flags).w ; is Megadrive PAL?
	beq.s	+		; if not, branch

	move.w	#$700,d0
-	dbf	d0,- ; wait here in a loop doing nothing for a while...
+
	move.b	(Vint_routine).w,d0
	move.b	#VintID_Lag,(Vint_routine).w
	move.w	#1,(Hint_flag).w
	andi.w	#$3E,d0
	move.w	Vint_SwitchTbl(pc,d0.w),d0
	jsr	Vint_SwitchTbl(pc,d0.w)

VintRet:
	addq.l	#1,(Vint_runcount).w
	movem.l	(sp)+,d0-a6
	rte
; ===========================================================================
Vint_SwitchTbl: offsetTable
Vint_Lag_ptr		offsetTableEntry.w Vint_Lag			;   0
Vint_SEGA_ptr:		offsetTableEntry.w Vint_SEGA		;   2
Vint_Title_ptr:		offsetTableEntry.w Vint_Title		;   4
Vint_Unused6_ptr:	offsetTableEntry.w Vint_Unused6		;   6
Vint_Level_ptr:		offsetTableEntry.w Vint_Level		;   8
Vint_S2SS_ptr:		offsetTableEntry.w Vint_S2SS		;  $A
Vint_TitleCard_ptr:	offsetTableEntry.w Vint_TitleCard	;  $C
Vint_UnusedE_ptr:	offsetTableEntry.w Vint_UnusedE		;  $E
Vint_Pause_ptr:		offsetTableEntry.w Vint_Pause		; $10
Vint_Fade_ptr:		offsetTableEntry.w Vint_Fade		; $12
Vint_PCM_ptr:		offsetTableEntry.w Vint_PCM			; $14
Vint_Menu_ptr:		offsetTableEntry.w Vint_Menu		; $16
Vint_Ending_ptr:	offsetTableEntry.w Vint_Ending		; $18
Vint_CtrlDMA_ptr:	offsetTableEntry.w Vint_CtrlDMA		; $1A
; ===========================================================================
;VintSub0
Vint_Lag:
	cmpi.b	#GameModeID_TitleCard|GameModeID_Demo,(Game_Mode).w	; pre-level Demo Mode?
	beq.s	loc_4C4
	cmpi.b	#GameModeID_TitleCard|GameModeID_Level,(Game_Mode).w	; pre-level Zone play mode?
	beq.s	loc_4C4
	cmpi.b	#GameModeID_Demo,(Game_Mode).w	; Demo Mode?
	beq.s	loc_4C4
	cmpi.b	#GameModeID_Level,(Game_Mode).w	; Zone play mode?
	beq.s	loc_4C4

	stopZ80			; stop the Z80
	bsr.w	sndDriverInput	; give input to the sound driver
	startZ80		; start the Z80

	bra.s	VintRet
; ---------------------------------------------------------------------------

loc_4C4:
	tst.b	(Water_flag).w
	beq.w	Vint0_noWater
	move.w	(VDP_control_port).l,d0
	btst	#6,(Graphics_Flags).w
	beq.s	+

	move.w	#$700,d0
-	dbf	d0,- ; do nothing for a while...
+
	move.w	#1,(Hint_flag).w

	stopZ80

	tst.b	(Water_fullscreen_flag).w
	bne.s	loc_526

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM

	bra.s	loc_54A
; ---------------------------------------------------------------------------

loc_526:
	dma68kToVDP Underwater_palette,$0000,palette_line_size*4,CRAM

loc_54A:
	move.w	(Hint_counter_reserve).w,(a5)
	move.w	#$8200|(VRAM_Plane_A_Name_Table/$400),(VDP_control_port).l	; Set scroll A PNT base to $C000
	bsr.w	sndDriverInput

	startZ80

	bra.w	VintRet
; ---------------------------------------------------------------------------

Vint0_noWater:
	move.w	(VDP_control_port).l,d0
	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.l	(Vscroll_Factor).w,(VDP_data_port).l
	btst	#6,(Graphics_Flags).w
	beq.s	+

	move.w	#$700,d0
-	dbf	d0,- ; do nothing for a while...
+
	move.w	#1,(Hint_flag).w
	move.w	(Hint_counter_reserve).w,(VDP_control_port).l
	move.w	#$8200|(VRAM_Plane_A_Name_Table/$400),(VDP_control_port).l	; Set scroll A PNT base to $C000
	move.l	(Vscroll_Factor_P2).w,(Vscroll_Factor_P2_HInt).w

	stopZ80
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	bsr.w	sndDriverInput
	startZ80

	bra.w	VintRet
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; This subroutine copies the H scroll table buffer (in main RAM) to the H scroll
; table (in VRAM).
;VintSub2
Vint_SEGA:
	bsr.w	Do_ControllerPal

	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM
	jsrto	(SegaScr_VInt).l, JmpTo_SegaScr_VInt
	tst.w	(Demo_Time_left).w	; is there time left on the demo?
	beq.w	+	; if not, return
	subq.w	#1,(Demo_Time_left).w	; subtract 1 from time left in demo
+
	rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;VintSub14
Vint_PCM:
	move.b	(Vint_runcount+3).w,d0
	andi.w	#$F,d0
	bne.s	+

	stopZ80
	bsr.w	ReadJoypads
	startZ80
+
	tst.w	(Demo_Time_left).w	; is there time left on the demo?
	beq.w	+	; if not, return
	subq.w	#1,(Demo_Time_left).w	; subtract 1 from time left in demo
+
	rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;VintSub4
Vint_Title:
	bsr.w	Do_ControllerPal
	bsr.w	ProcessDPLC
	tst.w	(Demo_Time_left).w	; is there time left on the demo?
	beq.w	+	; if not, return
	subq.w	#1,(Demo_Time_left).w	; subtract 1 from time left in demo
+
	rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;VintSub6
Vint_Unused6:
	bsr.w	Do_ControllerPal
	rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;VintSub10
Vint_Pause:
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; Special Stage?
	beq.w	Vint_Pause_specialStage
;VintSub8
Vint_Level:
	stopZ80

	bsr.w	ReadJoypads
	tst.b	(Teleport_timer).w
	beq.s	loc_6F8
	lea	(VDP_control_port).l,a5
	tst.w	(Game_paused).w	; is the game paused ?
	bne.w	loc_748	; if yes, branch
	subq.b	#1,(Teleport_timer).w
	bne.s	+
	move.b	#0,(Teleport_flag).w
+
	cmpi.b	#$10,(Teleport_timer).w
	blo.s	loc_6F8
	lea	(VDP_data_port).l,a6
	move.l	#vdpComm($0000,CRAM,WRITE),(VDP_control_port).l
	move.w	#$EEE,d0

	move.w	#$1F,d1
-	move.w	d0,(a6)
	dbf	d1,-

	move.l	#vdpComm($0042,CRAM,WRITE),(VDP_control_port).l

	move.w	#$1F,d1
-	move.w	d0,(a6)
	dbf	d1,-

	bra.s	loc_748
; ---------------------------------------------------------------------------

loc_6F8:
	tst.b	(Water_fullscreen_flag).w
	bne.s	loc_724
	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	bra.s	loc_748
; ---------------------------------------------------------------------------

loc_724:

	dma68kToVDP Underwater_palette,$0000,palette_line_size*4,CRAM

loc_748:
	move.w	(Hint_counter_reserve).w,(a5)
	move.w	#$8200|(VRAM_Plane_A_Name_Table/$400),(VDP_control_port).l	; Set scroll A PNT base to $C000

	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM

	bsr.w	ProcessDMAQueue
	bsr.w	sndDriverInput

	startZ80

	movem.l	(Camera_RAM).w,d0-d7
	movem.l	d0-d7,(Camera_RAM_copy).w
	movem.l	(Camera_X_pos_P2).w,d0-d7
	movem.l	d0-d7,(Camera_P2_copy).w
	movem.l	(Scroll_flags).w,d0-d3
	movem.l	d0-d3,(Scroll_flags_copy).w
	move.l	(Vscroll_Factor_P2).w,(Vscroll_Factor_P2_HInt).w
	cmpi.b	#$5C,(Hint_counter_reserve+1).w
	bhs.s	Do_Updates
	move.b	#1,(Do_Updates_in_H_int).w
	rts

; ---------------------------------------------------------------------------
; Subroutine to run a demo for an amount of time
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_7E6: Demo_Time:
Do_Updates:
	jsrto	(LoadTilesAsYouMove).l, JmpTo_LoadTilesAsYouMove
	jsr	(HudUpdate).l
	bsr.w	ProcessDPLC2
	tst.w	(Demo_Time_left).w	; is there time left on the demo?
	beq.w	+		; if not, branch
	subq.w	#1,(Demo_Time_left).w	; subtract 1 from time left in demo
+
	rts
; End of function Do_Updates

; ---------------------------------------------------------------------------
;Vint10_specialStage
Vint_Pause_specialStage:
	stopZ80

	bsr.w	ReadJoypads
	jsr	(sndDriverInput).l
	tst.b	(SS_Last_Alternate_HorizScroll_Buf).w
	beq.s	loc_84A

	dma68kToVDP SS_Horiz_Scroll_Buf_2,VRAM_SS_Horiz_Scroll_Table,VRAM_SS_Horiz_Scroll_Table_Size,VRAM
	bra.s	loc_86E
; ---------------------------------------------------------------------------
loc_84A:
	dma68kToVDP SS_Horiz_Scroll_Buf_1,VRAM_SS_Horiz_Scroll_Table,VRAM_SS_Horiz_Scroll_Table_Size,VRAM

loc_86E:
	startZ80
	rts
; ========================================================================>>>
;VintSubA
Vint_S2SS:
	stopZ80

	bsr.w	ReadJoypads
	bsr.w	SSSet_VScroll

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	dma68kToVDP SS_Sprite_Table,VRAM_SS_Sprite_Attribute_Table,VRAM_SS_Sprite_Attribute_Table_Size,VRAM

	tst.b	(SS_Alternate_HorizScroll_Buf).w
	beq.s	loc_906

	dma68kToVDP SS_Horiz_Scroll_Buf_2,VRAM_SS_Horiz_Scroll_Table,VRAM_SS_Horiz_Scroll_Table_Size,VRAM
	bra.s	loc_92A
; ---------------------------------------------------------------------------

loc_906:
	dma68kToVDP SS_Horiz_Scroll_Buf_1,VRAM_SS_Horiz_Scroll_Table,VRAM_SS_Horiz_Scroll_Table_Size,VRAM

loc_92A:
	tst.b	(SSTrack_Orientation).w			; Is the current track frame flipped?
	beq.s	++								; Branch if not
	moveq	#0,d0
	move.b	(SSTrack_drawing_index).w,d0	; Get drawing position
	cmpi.b	#4,d0							; Have we finished drawing and streaming track frame?
	bge.s	++								; Branch if yes (nothing to draw)
	add.b	d0,d0							; Convert to index
	tst.b	(SS_Alternate_PNT).w			; [(SSTrack_drawing_index) * 2] = subroutine
	beq.s	+								; Branch if not using the alternate Plane A name table
	addi_.w	#8,d0							; ([(SSTrack_drawing_index) * 2] + 8) = subroutine
+
	move.w	SS_PNTA_Transfer_Table(pc,d0.w),d0
	jsr	SS_PNTA_Transfer_Table(pc,d0.w)
+
	bsr.w	SSRun_Animation_Timers
	addi_.b	#1,(SSTrack_drawing_index).w	; Run track timer
	move.b	(SSTrack_drawing_index).w,d0	; Get new timer value
	cmp.b	d1,d0							; Is it less than the player animation timer?
	blt.s	+++								; Branch if so
	move.b	#0,(SSTrack_drawing_index).w	; Start drawing new frame
	lea	(VDP_control_port).l,a6
	tst.b	(SS_Alternate_PNT).w			; Are we using the alternate address for plane A?
	beq.s	+								; Branch if not
	move.w	#$8200|(VRAM_SS_Plane_A_Name_Table1/$400),(a6)	; Set PNT A base to $C000
	bra.s	++
; ===========================================================================
;off_97A
SS_PNTA_Transfer_Table:	offsetTable
		offsetTableEntry.w loc_A50	; 0
		offsetTableEntry.w loc_A76	; 1
		offsetTableEntry.w loc_A9C	; 2
		offsetTableEntry.w loc_AC2	; 3
		offsetTableEntry.w loc_9B8	; 4
		offsetTableEntry.w loc_9DE	; 5
		offsetTableEntry.w loc_A04	; 6
		offsetTableEntry.w loc_A2A	; 7
; ===========================================================================
+
	move.w	#$8200|(VRAM_SS_Plane_A_Name_Table2/$400),(a6)	; Set PNT A base to $8000
+
	eori.b	#1,(SS_Alternate_PNT).w			; Toggle flag
+
	bsr.w	ProcessDMAQueue
	jsr	(sndDriverInput).l

	startZ80

	bsr.w	ProcessDPLC2
	tst.w	(Demo_Time_left).w
	beq.w	+	; rts
	subq.w	#1,(Demo_Time_left).w
+
	rts
; ---------------------------------------------------------------------------
; (!)
; Each of these functions copies one fourth of pattern name table A into VRAM
; from a buffer in main RAM. $700 bytes are copied each frame, with the target
; are in VRAM depending on the current drawing position.
loc_9B8:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table1 + 0 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_9DE:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table1 + 1 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A04:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table1 + 2 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A2A:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table1 + 3 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A50:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table2 + 0 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A76:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table2 + 1 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A9C:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table2 + 2 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_AC2:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table2 + 3 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_AE8
SSSet_VScroll:
	move.w	(VDP_control_port).l,d0
	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.l	(Vscroll_Factor).w,(VDP_data_port).l
	rts
; End of function SSSet_VScroll


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_B02
SSRun_Animation_Timers:
	move.w	(SS_Cur_Speed_Factor).w,d0		; Get current speed factor
	cmp.w	(SS_New_Speed_Factor).w,d0		; Has the speed factor changed?
	beq.s	+								; Branch if yes
	move.l	(SS_New_Speed_Factor).w,(SS_Cur_Speed_Factor).w	; Save new speed factor
	move.b	#0,(SSTrack_duration_timer).w	; Reset timer
+
	subi_.b	#1,(SSTrack_duration_timer).w	; Run track timer
	bgt.s	+								; Branch if not expired yet
	lea	(SSAnim_Base_Duration).l,a0
	move.w	(SS_Cur_Speed_Factor).w,d0		; The current speed factor is an index
	lsr.w	#1,d0
	move.b	(a0,d0.w),d1
	move.b	d1,(SS_player_anim_frame_timer).w	; New player animation length (later halved)
	move.b	d1,(SSTrack_duration_timer).w		; New track timer
	subq.b	#1,(SS_player_anim_frame_timer).w	; Subtract one
	rts
; ---------------------------------------------------------------------------
+
	move.b	(SS_player_anim_frame_timer).w,d1	; Get current player animatino length
	addq.b	#1,d1		; Increase it
	rts
; End of function SSRun_Animation_Timers

; ===========================================================================
;byte_B46
SSAnim_Base_Duration:
	dc.b 60
	dc.b 30	; 1
	dc.b 15	; 2
	dc.b 10	; 3
	dc.b  8	; 4
	dc.b  6	; 5
	dc.b  5	; 6
	dc.b  0	; 7
; ===========================================================================
;VintSub1A
Vint_CtrlDMA:
	stopZ80
	jsr	(ProcessDMAQueue).l
	startZ80
	rts
; ===========================================================================
;VintSubC
Vint_TitleCard:
	stopZ80

	bsr.w	ReadJoypads
	tst.b	(Water_fullscreen_flag).w
	bne.s	loc_BB2

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	bra.s	loc_BD6
; ---------------------------------------------------------------------------

loc_BB2:
	dma68kToVDP Underwater_palette,$0000,palette_line_size*4,CRAM

loc_BD6:
	move.w	(Hint_counter_reserve).w,(a5)

	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM

	bsr.w	ProcessDMAQueue
	jsr	(DrawLevelTitleCard).l
	jsr	(sndDriverInput).l

	startZ80

	movem.l	(Camera_RAM).w,d0-d7
	movem.l	d0-d7,(Camera_RAM_copy).w
	movem.l	(Scroll_flags).w,d0-d1
	movem.l	d0-d1,(Scroll_flags_copy).w
	move.l	(Vscroll_Factor_P2).w,(Vscroll_Factor_P2_HInt).w
	bsr.w	ProcessDPLC
	rts
; ===========================================================================
;VintSubE
Vint_UnusedE:
	bsr.w	Do_ControllerPal
	addq.b	#1,(VIntSubE_RunCount).w
	move.b	#VintID_UnusedE,(Vint_routine).w
	rts
; ===========================================================================
;VintSub12
Vint_Fade:
	bsr.w	Do_ControllerPal
	move.w	(Hint_counter_reserve).w,(a5)
	bra.w	ProcessDPLC
; ===========================================================================
;VintSub18
Vint_Ending:
	stopZ80

	bsr.w	ReadJoypads

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM

	bsr.w	ProcessDMAQueue
	bsr.w	sndDriverInput
	movem.l	(Camera_RAM).w,d0-d7
	movem.l	d0-d7,(Camera_RAM_copy).w
	movem.l	(Scroll_flags).w,d0-d3
	movem.l	d0-d3,(Scroll_flags_copy).w
	jsrto	(LoadTilesAsYouMove).l, JmpTo_LoadTilesAsYouMove

	startZ80

	move.w	(Ending_VInt_Subrout).w,d0
	beq.s	+	; rts
	clr.w	(Ending_VInt_Subrout).w
	move.w	off_D3C-2(pc,d0.w),d0
	jsr	off_D3C(pc,d0.w)
+
	rts
; ===========================================================================
off_D3C:	offsetTable
		offsetTableEntry.w (+)	; 1
		offsetTableEntry.w (++)	; 2
; ===========================================================================
+
	dmaFillVRAM 0,VRAM_EndSeq_Plane_A_Name_Table,VRAM_EndSeq_Plane_Table_Size	; VRAM Fill $C000 with $2000 zeros
	rts
; ---------------------------------------------------------------------------
+
	dmaFillVRAM 0,VRAM_EndSeq_Plane_B_Name_Table2,VRAM_EndSeq_Plane_Table_Size
	dmaFillVRAM 0,VRAM_EndSeq_Plane_A_Name_Table,VRAM_EndSeq_Plane_Table_Size

	lea	(VDP_control_port).l,a6
	move.w	#$8B00,(a6)		; EXT-INT off, V scroll by screen, H scroll by screen
	move.w	#$8400|(VRAM_EndSeq_Plane_B_Name_Table2/$2000),(a6)	; PNT B base: $4000
	move.w	#$9011,(a6)		; Scroll table size: 64x64
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_EndSeq_Plane_A_Name_Table + planeLocH40($16,$21),VRAM,WRITE),d0	;$50AC0003
	moveq	#$16,d1
	moveq	#$E,d2
	jsrto	(PlaneMapToVRAM_H40).l, PlaneMapToVRAM_H40
	rts
; ===========================================================================
;VintSub16
Vint_Menu:
	stopZ80

	bsr.w	ReadJoypads

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM

	bsr.w	ProcessDMAQueue
	bsr.w	sndDriverInput

	startZ80

	bsr.w	ProcessDPLC
	tst.w	(Demo_Time_left).w
	beq.w	+	; rts
	subq.w	#1,(Demo_Time_left).w
+
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_E98
Do_ControllerPal:
	stopZ80

	bsr.w	ReadJoypads
	tst.b	(Water_fullscreen_flag).w
	bne.s	loc_EDA

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	bra.s	loc_EFE
; ---------------------------------------------------------------------------

loc_EDA:
	dma68kToVDP Underwater_palette,$0000,palette_line_size*4,CRAM

loc_EFE:
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM

	bsr.w	sndDriverInput

	startZ80

	rts
; End of function sub_E98
; ||||||||||||||| E N D   O F   V - I N T |||||||||||||||||||||||||||||||||||

; ===========================================================================
; Start of H-INT code
H_Int:
	tst.w	(Hint_flag).w
	beq.w	+
	tst.w	(Two_player_mode).w
	beq.w	PalToCRAM
	move.w	#0,(Hint_flag).w
	move.l	a5,-(sp)
	move.l	d0,-(sp)

-	move.w	(VDP_control_port).l,d0	; loop start: Make sure V_BLANK is over
	andi.w	#4,d0
	beq.s	-	; loop end

	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l		; Display disable
	move.w	#$8200|(VRAM_Plane_A_Name_Table_2P/$400),(VDP_control_port).l	; PNT A base: $A000
	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.l	(Vscroll_Factor_P2_HInt).w,(VDP_data_port).l

	stopZ80
	dma68kToVDP Sprite_Table_2,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	startZ80

-	move.w	(VDP_control_port).l,d0
	andi.w	#4,d0
	beq.s	-

	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l		; Display enable
	move.l	(sp)+,d0
	movea.l	(sp)+,a5
+
	rte


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; game code

; ---------------------------------------------------------------------------
; loc_1000:
PalToCRAM:
	move	#$2700,sr
	move.w	#0,(Hint_flag).w
	movem.l	a0-a1,-(sp)
	lea	(VDP_data_port).l,a1
	lea	(Underwater_palette).w,a0 	; load palette from RAM
	move.l	#vdpComm($0000,CRAM,WRITE),4(a1)	; set VDP to write to CRAM address $00
    rept 32
	move.l	(a0)+,(a1)	; move palette to CRAM (all 64 colors at once)
    endm
	move.w	#$8ADF,4(a1)	; Write %1101 %1111 to register 10 (interrupt every 224th line)
	movem.l	(sp)+,a0-a1
	tst.b	(Do_Updates_in_H_int).w
	bne.s	loc_1072
	rte
; ===========================================================================

loc_1072:
	clr.b	(Do_Updates_in_H_int).w
	movem.l	d0-a6,-(sp)
	bsr.w	Do_Updates
	movem.l	(sp)+,d0-a6
	rte

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Input our music/sound selection to the sound driver.

sndDriverInput:
	lea	(Music_to_play&$00FFFFFF).l,a0
	lea	(Z80_RAM+zAbsVar).l,a1 ; $A01B80
	cmpi.b	#$80,zAbsVar.QueueToPlay-zAbsVar(a1)	; If this (zReadyFlag) isn't $80, the driver is processing a previous sound request.
	bne.s	loc_10C4	; So we'll wait until at least the next frame before putting anything in there.
	_move.b	0(a0),d0
	beq.s	loc_10A4
	_clr.b	0(a0)
	bra.s	loc_10AE
; ---------------------------------------------------------------------------

loc_10A4:
	move.b	4(a0),d0	; If there was something in Music_to_play_2, check what that was. Else, just go to the loop.
	beq.s	loc_10C4
	clr.b	4(a0)

loc_10AE:		; Check that the sound is not FE or FF
	move.b	d0,d1	; If it is, we need to put it in $A01B83 as $7F or $80 respectively
	subi.b	#MusID_Pause,d1
	bcs.s	loc_10C0
	addi.b	#$7F,d1
	move.b	d1,zAbsVar.StopMusic-zAbsVar(a1)
	bra.s	loc_10C4
; ---------------------------------------------------------------------------

loc_10C0:
	move.b	d0,zAbsVar.QueueToPlay-zAbsVar(a1)

loc_10C4:
	moveq	#4-1,d1
				; FFE4 (Music_to_play_2) goes to 1B8C (zMusicToPlay),
-	move.b	1(a0,d1.w),d0	; FFE3 (unk_FFE3) goes to 1B8B, (unknown)
	beq.s	+		; FFE2 (SFX_to_play_2) goes to 1B8A (zSFXToPlay2),
	tst.b	zAbsVar.SFXToPlay-zAbsVar(a1,d1.w)	; FFE1 (SFX_to_play) goes to 1B89 (zSFXToPlay).
	bne.s	+
	clr.b	1(a0,d1.w)
	move.b	d0,zAbsVar.SFXToPlay-zAbsVar(a1,d1.w)
+
	dbf	d1,-
	rts
; End of function sndDriverInput

    if ~~removeJmpTos
; sub_10E0:
JmpTo_LoadTilesAsYouMove 
	jmp	(LoadTilesAsYouMove).l
JmpTo_SegaScr_VInt 
	jmp	(SegaScr_VInt).l

	align 4
    endif
