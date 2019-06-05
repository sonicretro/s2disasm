; ---------------------------------------------------------------------------
; Subroutine to display correct tiles as you move
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; loc_DA5C:
LoadTilesAsYouMove:
	lea	(VDP_control_port).l,a5
	lea	(VDP_data_port).l,a6
	lea	(Scroll_flags_BG_copy).w,a2
	lea	(Camera_BG_copy).w,a3
	lea	(Level_Layout+$80).w,a4	; first background line
	move.w	#vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE)>>16,d2
	bsr.w	Draw_BG1
	lea	(Scroll_flags_BG2_copy).w,a2	; referred to in CPZ deformation routine, but cleared right after
	lea	(Camera_BG2_copy).w,a3
	bsr.w	Draw_BG2	; Essentially unused, though
	lea	(Scroll_flags_BG3_copy).w,a2
	lea	(Camera_BG3_copy).w,a3
	bsr.w	Draw_BG3	; used in CPZ deformation routine
	tst.w	(Two_player_mode).w
	beq.s	+
	lea	(Scroll_flags_copy_P2).w,a2
	lea	(Camera_P2_copy).w,a3	; second player camera
	lea	(Level_Layout).w,a4
	move.w	#vdpComm(VRAM_Plane_A_Name_Table_2P,VRAM,WRITE)>>16,d2
	bsr.w	Draw_FG_P2

+
	lea	(Scroll_flags_copy).w,a2
	lea	(Camera_RAM_copy).w,a3
	lea	(Level_Layout).w,a4
	move.w	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE)>>16,d2
	tst.b	(Screen_redraw_flag).w

	; comment out this line to disable blast processing
	beq.s	Draw_FG

	move.b	#0,(Screen_redraw_flag).w
	moveq	#-$10,d4
	moveq	#$F,d6
; loc_DACE:
Draw_All:
	movem.l	d4-d6,-(sp)	; This whole routine basically redraws the whole
	moveq	#-$10,d5	; area instead of merely a line of tiles
	move.w	d4,d1
	bsr.w	CalcBlockVRAMPos
	move.w	d1,d4
	moveq	#-$10,d5
	bsr.w	DrawBlockRow1	; draw the current row
	movem.l	(sp)+,d4-d6
	addi.w	#$10,d4		; move onto the next row
	dbf	d6,Draw_All	; repeat for all rows
	move.b	#0,(Scroll_flags_copy).w
	rts
; ===========================================================================
; loc_DAF6:
Draw_FG:
	tst.b	(a2)		; is any scroll flag set?
	beq.s	return_DB5A	; if not, branch
	bclr	#0,(a2)		; has the level scrolled up?
	beq.s	+		; if not, branch
	moveq	#-$10,d4
	moveq	#-$10,d5
	bsr.w	CalcBlockVRAMPos
	moveq	#-$10,d4
	moveq	#-$10,d5
	bsr.w	DrawBlockRow1	; redraw upper row
+
	bclr	#1,(a2)		; has the level scrolled down?
	beq.s	+		; if not, branch
	move.w	#224,d4
	moveq	#-$10,d5
	bsr.w	CalcBlockVRAMPos
	move.w	#224,d4
	moveq	#-$10,d5
	bsr.w	DrawBlockRow1	; redraw bottom row
+
	bclr	#2,(a2)		; has the level scrolled to the left?
	beq.s	+	; if not, branch
	moveq	#-$10,d4
	moveq	#-$10,d5
	bsr.w	CalcBlockVRAMPos
	moveq	#-$10,d4
	moveq	#-$10,d5
	bsr.w	DrawBlockCol1	; redraw left-most column
+
	bclr	#3,(a2)		; has the level scrolled to the right?
	beq.s	return_DB5A	; if not, return
	moveq	#-$10,d4
	move.w	#320,d5
	bsr.w	CalcBlockVRAMPos
	moveq	#-$10,d4
	move.w	#320,d5
	bsr.w	DrawBlockCol1	; redraw right-most column

return_DB5A:
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_DB5C:
Draw_FG_P2:
	tst.b	(a2)
	beq.s	return_DBC0
	bclr	#0,(a2)
	beq.s	+
	moveq	#-$10,d4
	moveq	#-$10,d5
	bsr.w	CalcBlockVRAMPosB
	moveq	#-$10,d4
	moveq	#-$10,d5
	bsr.w	DrawBlockRow1
+
	bclr	#1,(a2)
	beq.s	+
	move.w	#$E0,d4
	moveq	#-$10,d5
	bsr.w	CalcBlockVRAMPosB
	move.w	#$E0,d4
	moveq	#-$10,d5
	bsr.w	DrawBlockRow1
+
	bclr	#2,(a2)
	beq.s	+
	moveq	#-$10,d4
	moveq	#-$10,d5
	bsr.w	CalcBlockVRAMPosB
	moveq	#-$10,d4
	moveq	#-$10,d5
	bsr.w	DrawBlockCol1
+
	bclr	#3,(a2)
	beq.s	return_DBC0
	moveq	#-$10,d4
	move.w	#320,d5
	bsr.w	CalcBlockVRAMPosB
	moveq	#-$10,d4
	move.w	#320,d5
	bsr.w	DrawBlockCol1

return_DBC0:
	rts
; End of function Draw_FG_P2


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_DBC2:
Draw_BG1:
	tst.b	(a2)
	beq.w	return_DC90
	bclr	#0,(a2)
	beq.s	+
	moveq	#-$10,d4
	moveq	#-$10,d5
	bsr.w	CalcBlockVRAMPos
	moveq	#-$10,d4
	moveq	#-$10,d5
	bsr.w	DrawBlockRow1
+
	bclr	#1,(a2)
	beq.s	+
	move.w	#$E0,d4
	moveq	#-$10,d5
	bsr.w	CalcBlockVRAMPos
	move.w	#$E0,d4
	moveq	#-$10,d5
	bsr.w	DrawBlockRow1
+
	bclr	#2,(a2)
	beq.s	+
	moveq	#-$10,d4
	moveq	#-$10,d5
	bsr.w	CalcBlockVRAMPos
	moveq	#-$10,d4
	moveq	#-$10,d5
	bsr.w	DrawBlockCol1
+
	bclr	#3,(a2)
	beq.s	+
	moveq	#-$10,d4
	move.w	#320,d5
	bsr.w	CalcBlockVRAMPos
	moveq	#-$10,d4
	move.w	#320,d5
	bsr.w	DrawBlockCol1
+
	bclr	#4,(a2)
	beq.s	+
	moveq	#-$10,d4
	moveq	#0,d5
	bsr.w	CalcBlockVRAMPos2
	moveq	#-$10,d4
	moveq	#0,d5
	moveq	#$1F,d6
	bsr.w	DrawBlockRow2
+
	bclr	#5,(a2)
	beq.s	+
	move.w	#$E0,d4
	moveq	#0,d5
	bsr.w	CalcBlockVRAMPos2
	move.w	#$E0,d4
	moveq	#0,d5
	moveq	#$1F,d6
	bsr.w	DrawBlockRow2
+
	bclr	#6,(a2)
	beq.s	+
	moveq	#-$10,d4
	moveq	#-$10,d5
	bsr.w	CalcBlockVRAMPos
	moveq	#-$10,d4
	moveq	#-$10,d5
	moveq	#$1F,d6
	bsr.w	DrawBlockRow
+
	bclr	#7,(a2)
	beq.s	return_DC90
	move.w	#$E0,d4
	moveq	#-$10,d5
	bsr.w	CalcBlockVRAMPos
	move.w	#$E0,d4
	moveq	#-$10,d5
	moveq	#$1F,d6
	bsr.w	DrawBlockRow

return_DC90:
	rts
; End of function Draw_BG1


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_DC92:
Draw_BG2:
	tst.b	(a2)
	beq.w	++	; rts
	bclr	#0,(a2)
	beq.s	+
	move.w	#$70,d4
	moveq	#-$10,d5
	bsr.w	CalcBlockVRAMPos
	move.w	#$70,d4
	moveq	#-$10,d5
	moveq	#2,d6
	bsr.w	DrawBlockCol2
+
	bclr	#1,(a2)
	beq.s	+	; rts
	move.w	#$70,d4
	move.w	#320,d5
	bsr.w	CalcBlockVRAMPos
	move.w	#$70,d4
	move.w	#320,d5
	moveq	#2,d6
	bsr.w	DrawBlockCol2
+
	rts
; End of function Draw_BG2

; ===========================================================================
; Scrap Brain Zone 1 block positioning array -- S1 left-over
; Each entry is an index into BGCameraLookup; used to decide the camera to use
; for given block for reloading BG. A entry of 0 means assume X = 0 for section,
; but otherwise loads camera Y for selected camera.
;byte_DCD6
SBZ_CameraSections:
	dc.b   0
	dc.b   0	; 1
	dc.b   0	; 2
	dc.b   0	; 3
	dc.b   0	; 4
	dc.b   6	; 5
	dc.b   6	; 6
	dc.b   6	; 7
	dc.b   6	; 8
	dc.b   6	; 9
	dc.b   6	; 10
	dc.b   6	; 11
	dc.b   6	; 12
	dc.b   6	; 13
	dc.b   6	; 14
	dc.b   4	; 15
	dc.b   4	; 16
	dc.b   4	; 17
	dc.b   4	; 18
	dc.b   4	; 19
	dc.b   4	; 20
	dc.b   4	; 21
	dc.b   2	; 22
	dc.b   2	; 23
	dc.b   2	; 24
	dc.b   2	; 25
	dc.b   2	; 26
	dc.b   2	; 27
	dc.b   2	; 28
	dc.b   2	; 29
	dc.b   2	; 30
	dc.b   2	; 31
	dc.b   2	; 32
	even
; ===========================================================================
; Scrap Brain Zone 1 drawing code -- S1 left-over
; Compare with CPZ drawing code
; begin unused routine
	moveq	#-$10,d4
	bclr	#0,(a2)
	bne.s	+
	bclr	#1,(a2)
	beq.s	+++
	move.w	#$E0,d4
+
	lea_	SBZ_CameraSections+1,a0
	move.w	(Camera_BG_Y_pos).w,d0
	add.w	d4,d0
	andi.w	#$1F0,d0
	lsr.w	#4,d0
	move.b	(a0,d0.w),d0
	lea	(BGCameraLookup).l,a3
	movea.w	(a3,d0.w),a3	; Camera, either BG, BG2 or BG3 depending on Y
	beq.s	+
	moveq	#-$10,d5
	movem.l	d4-d5,-(sp)
	bsr.w	CalcBlockVRAMPos
	movem.l	(sp)+,d4-d5
	bsr.w	DrawBlockRow1
	bra.s	++
; ===========================================================================
+
	moveq	#0,d5
	movem.l	d4-d5,-(sp)
	bsr.w	CalcBlockVRAMPos2
	movem.l	(sp)+,d4-d5
	moveq	#$1F,d6
	bsr.w	DrawBlockRow2
+
	tst.b	(a2)
	bne.s	+
	rts
; ===========================================================================
+
	moveq	#-$10,d4
	moveq	#-$10,d5
	move.b	(a2),d0
	andi.b	#-$58,d0
	beq.s	+
	lsr.b	#1,d0
	move.b	d0,(a2)
	move.w	#320,d5
+
	lea_	SBZ_CameraSections,a0
	move.w	(Camera_BG_Y_pos).w,d0
	andi.w	#$1F0,d0
	lsr.w	#4,d0
	lea	(a0,d0.w),a0
	bra.w	loc_DE86
; end unused routine

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_DD82:
Draw_BG3:
	tst.b	(a2)
	beq.w	++	; rts
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	beq.w	Draw_BG3_CPZ
	; S1 left-over: GHZ used this
	bclr	#0,(a2)
	beq.s	+
	move.w	#$40,d4
	moveq	#-$10,d5
	bsr.w	CalcBlockVRAMPos
	move.w	#$40,d4
	moveq	#-$10,d5
	moveq	#2,d6
	bsr.w	DrawBlockCol2
+
	bclr	#1,(a2)
	beq.s	+	; rts
	move.w	#$40,d4
	move.w	#320,d5
	bsr.w	CalcBlockVRAMPos
	move.w	#$40,d4
	move.w	#320,d5
	moveq	#2,d6
	bsr.w	DrawBlockCol2
+
	rts
; ===========================================================================
; Chemical Plant Zone 1 block positioning array
; Each entry is an index into BGCameraLookup; used to decide the camera to use
; for given block for reloading BG. A entry of 0 means assume X = 0 for section,
; but otherwise loads camera Y for selected camera.
;byte_DDD0
CPZ_CameraSections:
	dc.b   2
	dc.b   2	; 1
	dc.b   2	; 2
	dc.b   2	; 3
	dc.b   2	; 4
	dc.b   2	; 5
	dc.b   2	; 6
	dc.b   2	; 7
	dc.b   2	; 8
	dc.b   2	; 9
	dc.b   2	; 10
	dc.b   2	; 11
	dc.b   2	; 12
	dc.b   2	; 13
	dc.b   2	; 14
	dc.b   2	; 15
	dc.b   2	; 16
	dc.b   2	; 17
	dc.b   2	; 18
	dc.b   2	; 19
	dc.b   4	; 20
	dc.b   4	; 21
	dc.b   4	; 22
	dc.b   4	; 23
	dc.b   4	; 24
	dc.b   4	; 25
	dc.b   4	; 26
	dc.b   4	; 27
	dc.b   4	; 28
	dc.b   4	; 29
	dc.b   4	; 30
	dc.b   4	; 31
	dc.b   4	; 32
	dc.b   4	; 33
	dc.b   4	; 34
	dc.b   4	; 35
	dc.b   4	; 36
	dc.b   4	; 37
	dc.b   4	; 38
	dc.b   4	; 39
	dc.b   4	; 40
	dc.b   4	; 41
	dc.b   4	; 42
	dc.b   4	; 43
	dc.b   4	; 44
	dc.b   4	; 45
	dc.b   4	; 46
	dc.b   4	; 47
	dc.b   4	; 48
	dc.b   4	; 49
	dc.b   4	; 50
	dc.b   4	; 51
	dc.b   4	; 52
	dc.b   4	; 53
	dc.b   4	; 54
	dc.b   4	; 55
	dc.b   4	; 56
	dc.b   4	; 57
	dc.b   4	; 58
	dc.b   4	; 59
	dc.b   4	; 60
	dc.b   4	; 61
	dc.b   4	; 62
	dc.b   4	; 63
	dc.b   4	; 64
	even
; ===========================================================================
; loc_DE12:
Draw_BG3_CPZ:
	moveq	#-$10,d4	; bit0 = top row
	bclr	#0,(a2)
	bne.s	+
	bclr	#1,(a2)
	beq.s	++
	move.w	#$E0,d4		; bit1 = bottom row
+
	lea_	CPZ_CameraSections+1,a0
	move.w	(Camera_BG_Y_pos).w,d0
	add.w	d4,d0
	andi.w	#$3F0,d0
	lsr.w	#4,d0
	move.b	(a0,d0.w),d0
	movea.w	BGCameraLookup(pc,d0.w),a3	; Camera, either BG, BG2 or BG3 depending on Y
	moveq	#-$10,d5
	movem.l	d4-d5,-(sp)
	bsr.w	CalcBlockVRAMPos
	movem.l	(sp)+,d4-d5
	bsr.w	DrawBlockRow1
+
	tst.b	(a2)
	bne.s	+
	rts
; ===========================================================================
+
	moveq	#-$10,d4
	moveq	#-$10,d5
	move.b	(a2),d0
	andi.b	#-$58,d0
	beq.s	+
	lsr.b	#1,d0
	move.b	d0,(a2)
	move.w	#320,d5
+
	lea_	CPZ_CameraSections,a0
	move.w	(Camera_BG_Y_pos).w,d0
	andi.w	#$7F0,d0
	lsr.w	#4,d0
	lea	(a0,d0.w),a0
	bra.w	loc_DE86
; ===========================================================================
;word_DE7E
BGCameraLookup:
	dc.w Camera_BG_copy	; BG Camera
	dc.w Camera_BG_copy	; BG Camera
	dc.w Camera_BG2_copy	; BG2 Camera
	dc.w Camera_BG3_copy	; BG3 Camera
; ===========================================================================

loc_DE86:
	tst.w	(Two_player_mode).w
	bne.s	++
	moveq	#$F,d6
	move.l	#vdpCommDelta($0080),d7

-	moveq	#0,d0
	move.b	(a0)+,d0
	btst	d0,(a2)
	beq.s	+
	movea.w	BGCameraLookup(pc,d0.w),a3	; Camera, either BG, BG2 or BG3 depending on Y
	movem.l	d4-d5/a0,-(sp)
	movem.l	d4-d5,-(sp)
	bsr.w	GetBlockPtr
	movem.l	(sp)+,d4-d5
	bsr.w	CalcBlockVRAMPos
	bsr.w	ProcessAndWriteBlock2
	movem.l	(sp)+,d4-d5/a0
+
	addi.w	#$10,d4
	dbf	d6,-

	clr.b	(a2)
	rts
; ===========================================================================
+
	moveq	#$F,d6
	move.l	#vdpCommDelta($0080),d7

-	moveq	#0,d0
	move.b	(a0)+,d0
	btst	d0,(a2)
	beq.s	+
	movea.w	BGCameraLookup(pc,d0.w),a3	; Camera, either BG, BG2 or BG3 depending on Y
	movem.l	d4-d5/a0,-(sp)
	movem.l	d4-d5,-(sp)
	bsr.w	GetBlockPtr
	movem.l	(sp)+,d4-d5
	bsr.w	CalcBlockVRAMPos
	bsr.w	ProcessAndWriteBlock2_2P
	movem.l	(sp)+,d4-d5/a0
+
	addi.w	#$10,d4
	dbf	d6,-

	clr.b	(a2)
	rts
; End of function Draw_BG3


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_DF04:
DrawBlockCol1:
	moveq	#$F,d6

DrawBlockCol2:
	add.w	(a3),d5		; add camera X pos
	add.w	4(a3),d4	; add camera Y pos
	move.l	#vdpCommDelta($0080),d7	; store VDP command for line increment
	move.l	d0,d1		; copy byte-swapped VDP command for later access
	bsr.w	GetBlockAddr
	tst.w	(Two_player_mode).w
	bne.s	++

-	move.w	(a0),d3		; get ID of the 16x16 block
	andi.w	#$3FF,d3
	lsl.w	#3,d3		; multiply by 8, the size in bytes of a 16x16
	lea	(Block_Table).w,a1
	adda.w	d3,a1		; a1 = address of the current 16x16 in the block table
	move.l	d1,d0
	bsr.w	ProcessAndWriteBlock2
	adda.w	#$10,a0		; move onto the 16x16 vertically below this one
	addi.w	#64*2*2,d1	; draw on alternate 8x8 lines
	andi.w	#(64*32*2)-1,d1	; wrap around plane (assumed to be in 64x32 mode)
	addi.w	#$10,d4		; add 16 to Y offset
	move.w	d4,d0
	andi.w	#$70,d0		; have we reached a new 128x128?
	bne.s	+	; if not, branch
	bsr.w	GetBlockAddr	; otherwise, renew the block address
+	dbf	d6,-		; repeat 16 times

	rts
; ===========================================================================

/	move.w	(a0),d3
	andi.w	#$3FF,d3
	lsl.w	#3,d3
	lea	(Block_Table).w,a1
	adda.w	d3,a1
	move.l	d1,d0
	bsr.w	ProcessAndWriteBlock2_2P
	adda.w	#$10,a0
	addi.w	#$80,d1
	andi.w	#$FFF,d1
	addi.w	#$10,d4
	move.w	d4,d0
	andi.w	#$70,d0
	bne.s	+
	bsr.w	GetBlockAddr
+	dbf	d6,-

	rts
; End of function DrawBlockCol1


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_DF8A: DrawTiles_Vertical:
DrawBlockRow:
	add.w	(a3),d5
	add.w	4(a3),d4
	bra.s	DrawBlockRow3
; End of function DrawBlockRow


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_DF92: DrawTiles_Vertical1:
DrawBlockRow1:
	moveq	#$15,d6
	add.w	(a3),d5		; add X pos
; loc_DF96: DrawTiles_Vertical2:
DrawBlockRow2:
	add.w	4(a3),d4	; add Y pos
; loc_DF9A: DrawTiles_Vertical3:
DrawBlockRow3:
	tst.w	(Two_player_mode).w
	bne.s	DrawBlockRow_2P
	move.l	a2,-(sp)
	move.w	d6,-(sp)
	lea	(Block_cache).w,a2
	move.l	d0,d1
	or.w	d2,d1
	swap	d1		; make VRAM write command
	move.l	d1,-(sp)
	move.l	d1,(a5)		; set up a VRAM write at that address
	swap	d1
	bsr.w	GetBlockAddr

-	move.w	(a0),d3		; get ID of the 16x16 block
	andi.w	#$3FF,d3
	lsl.w	#3,d3		; multiply by 8, the size in bytes of a 16x16
	lea	(Block_Table).w,a1
	adda.w	d3,a1		; a1 = address of current 16x16 in the block table
	bsr.w	ProcessAndWriteBlock
	addq.w	#2,a0		; move onto next 16x16
	addq.b	#4,d1		; increment VRAM write address
	bpl.s	+
	andi.b	#$7F,d1		; restrict to a single 8x8 line
	swap	d1
	move.l	d1,(a5)		; set up a VRAM write at a new address
	swap	d1
+
	addi.w	#$10,d5		; add 16 to X offset
	move.w	d5,d0
	andi.w	#$70,d0		; have we reached a new 128x128?
	bne.s	+		; if not, branch
	bsr.w	GetBlockAddr	; otherwise, renew the block address
+
	dbf	d6,-		; repeat 22 times

	move.l	(sp)+,d1
	addi.l	#vdpCommDelta($0080),d1	; move onto next line
	lea	(Block_cache).w,a2
	move.l	d1,(a5)		; write to this VRAM address
	swap	d1
	move.w	(sp)+,d6

-	move.l	(a2)+,(a6)	; write stored 8x8s
	addq.b	#4,d1		; increment VRAM write address
	bmi.s	+
	ori.b	#$80,d1		; force to bottom 8x8 line
	swap	d1
	move.l	d1,(a5)		; set up a VRAM write at a new address
	swap	d1
+
	dbf	d6,-		; repeat 22 times

	movea.l	(sp)+,a2
	rts
; ===========================================================================
; loc_E018:
DrawBlockRow_2P:
	move.l	d0,d1
	or.w	d2,d1
	swap	d1
	move.l	d1,(a5)
	swap	d1
	tst.b	d1
	bmi.s	+++
	bsr.w	GetBlockAddr

-	move.w	(a0),d3
	andi.w	#$3FF,d3
	lsl.w	#3,d3
	lea	(Block_Table).w,a1
	adda.w	d3,a1
	bsr.w	ProcessAndWriteBlock_2P
	addq.w	#2,a0
	addq.b	#4,d1
	bpl.s	+
	andi.b	#$7F,d1
	swap	d1
	move.l	d1,(a5)
	swap	d1
+
	addi.w	#$10,d5
	move.w	d5,d0
	andi.w	#$70,d0
	bne.s	+
	bsr.w	GetBlockAddr
+	dbf	d6,-

	rts
; ===========================================================================
+
	bsr.w	GetBlockAddr

-	move.w	(a0),d3
	andi.w	#$3FF,d3
	lsl.w	#3,d3
	lea	(Block_Table).w,a1
	adda.w	d3,a1
	bsr.w	ProcessAndWriteBlock_2P
	addq.w	#2,a0
	addq.b	#4,d1
	bmi.s	+
	ori.b	#$80,d1
	swap	d1
	move.l	d1,(a5)
	swap	d1
+
	addi.w	#$10,d5
	move.w	d5,d0
	andi.w	#$70,d0
	bne.s	+
	bsr.w	GetBlockAddr
+	dbf	d6,-

	rts
; End of function DrawBlockRow1


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E09E:
GetBlockAddr:
	movem.l	d4-d5,-(sp)
	move.w	d4,d3		; d3 = camera Y pos + offset
	add.w	d3,d3
	andi.w	#$F00,d3	; limit to units of $100 ($100 = $80 * 2, $80 = height of a 128x128)
	lsr.w	#3,d5		; divide by 8
	move.w	d5,d0
	lsr.w	#4,d0		; divide by 16 (overall division of 128)
	andi.w	#$7F,d0
	add.w	d3,d0		; get offset of current 128x128 in the level layout table
	moveq	#-1,d3
	clr.w	d3		; d3 = $FFFF0000
	move.b	(a4,d0.w),d3	; get tile ID of the current 128x128 tile
	lsl.w	#7,d3		; multiply by 128, the size in bytes of a 128x128 in RAM
	andi.w	#$70,d4		; round down to nearest 16-pixel boundary
	andi.w	#$E,d5		; force this to be a multiple of 16
	add.w	d4,d3		; add vertical offset of current 16x16
	add.w	d5,d3		; add horizontal offset of current 16x16
	movea.l	d3,a0		; store address, in the metablock table, of the current 16x16
	movem.l	(sp)+,d4-d5
	rts
; End of function GetBlockAddr


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E0D4:
ProcessAndWriteBlock:
	btst	#3,(a0)		; is this 16x16 to be Y-flipped?
	bne.s	ProcessAndWriteBlock_FlipY	; if it is, branch
	btst	#2,(a0)		; is this 16x16 to be X-flipped?
	bne.s	ProcessAndWriteBlock_FlipX	; if it is, branch
	move.l	(a1)+,(a6)	; write top two 8x8s to VRAM
	move.l	(a1)+,(a2)+	; store bottom two 8x8s for later writing
	rts
; ===========================================================================

ProcessAndWriteBlock_FlipX:
	move.l	(a1)+,d3
	eori.l	#(flip_x<<16)|flip_x,d3	; toggle X-flip flag of the 8x8s
	swap	d3		; swap the position of the 8x8s
	move.l	d3,(a6)		; write top two 8x8s to VRAM
	move.l	(a1)+,d3
	eori.l	#(flip_x<<16)|flip_x,d3
	swap	d3
	move.l	d3,(a2)+	; store bottom two 8x8s for later writing
	rts
; ===========================================================================

ProcessAndWriteBlock_FlipY:
	btst	#2,(a0)		; is this 16x16 to be X-flipped as well?
	bne.s	ProcessAndWriteBlock_FlipXY	; if it is, branch
	move.l	(a1)+,d0
	move.l	(a1)+,d3
	eori.l	#(flip_y<<16)|flip_y,d3	; toggle Y-flip flag of the 8x8s
	move.l	d3,(a6)		; write bottom two 8x8s to VRAM
	eori.l	#(flip_y<<16)|flip_y,d0
	move.l	d0,(a2)+	; store top two 8x8s for later writing
	rts
; ===========================================================================

ProcessAndWriteBlock_FlipXY:
	move.l	(a1)+,d0
	move.l	(a1)+,d3
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d3	; toggle X and Y-flip flags of the 8x8s
	swap	d3
	move.l	d3,(a6)		; write bottom two 8x8s to VRAM
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d0
	swap	d0
	move.l	d0,(a2)+	; store top two 8x8s for later writing
	rts
; End of function ProcessAndWriteBlock


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_E136:
ProcessAndWriteBlock_2P:
	btst	#3,(a0)
	bne.s	loc_E154
	btst	#2,(a0)
	bne.s	loc_E146
	move.l	(a1)+,(a6)
	rts
; ===========================================================================

loc_E146:
	move.l	(a1)+,d3
	eori.l	#(flip_x<<16)|flip_x,d3
	swap	d3
	move.l	d3,(a6)
	rts
; ===========================================================================

loc_E154:
	btst	#2,(a0)
	bne.s	loc_E166
	move.l	(a1)+,d3
	eori.l	#(flip_y<<16)|flip_y,d3
	move.l	d3,(a6)
	rts
; ===========================================================================

loc_E166:
	move.l	(a1)+,d3
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d3
	swap	d3
	move.l	d3,(a6)
	rts
; End of function ProcessAndWriteBlock_2P


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E174:
ProcessAndWriteBlock2:
	or.w	d2,d0
	swap	d0		; make VRAM write command
	btst	#3,(a0)		; is the 16x16 to be Y-flipped?
	bne.s	ProcessAndWriteBlock2_FlipY	; if it is, branch
	btst	#2,(a0)		; is the 16x16 to be X-flipped?
	bne.s	ProcessAndWriteBlock2_FlipX	; if it is, branch
	move.l	d0,(a5)		; write to this VRAM address
	move.l	(a1)+,(a6)	; write top two 8x8s
	add.l	d7,d0		; move onto next line
	move.l	d0,(a5)
	move.l	(a1)+,(a6)	; write bottom two 8x8s
	rts
; ===========================================================================

ProcessAndWriteBlock2_FlipX:
	move.l	d0,(a5)
	move.l	(a1)+,d3
	eori.l	#(flip_x<<16)|flip_x,d3	; toggle X-flip flag of the 8x8s
	swap	d3		; swap the position of the 8x8s
	move.l	d3,(a6)		; write top two 8x8s
	add.l	d7,d0		; move onto next line
	move.l	d0,(a5)
	move.l	(a1)+,d3
	eori.l	#(flip_x<<16)|flip_x,d3
	swap	d3
	move.l	d3,(a6)		; write bottom two 8x8s
	rts
; ===========================================================================

ProcessAndWriteBlock2_FlipY:
	btst	#2,(a0)		; is the 16x16 to be X-flipped as well?
	bne.s	ProcessAndWriteBlock2_FlipXY	; if it is, branch
	move.l	d5,-(sp)
	move.l	d0,(a5)
	move.l	(a1)+,d5
	move.l	(a1)+,d3
	eori.l	#(flip_y<<16)|flip_y,d3	; toggle Y-flip flag of 8x8s
	move.l	d3,(a6)		; write bottom two 8x8s
	add.l	d7,d0		; move onto next line
	move.l	d0,(a5)
	eori.l	#(flip_y<<16)|flip_y,d5
	move.l	d5,(a6)		; write top two 8x8s
	move.l	(sp)+,d5
	rts
; ===========================================================================

ProcessAndWriteBlock2_FlipXY:
	move.l	d5,-(sp)
	move.l	d0,(a5)
	move.l	(a1)+,d5
	move.l	(a1)+,d3
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d3	; toggle X and Y-flip flags of 8x8s
	swap	d3		; swap the position of the 8x8s
	move.l	d3,(a6)		; write bottom two 8x8s
	add.l	d7,d0
	move.l	d0,(a5)
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d5
	swap	d5
	move.l	d5,(a6)		; write top two 8x8s
	move.l	(sp)+,d5
	rts
; End of function ProcessAndWriteBlock2


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_E1FA:
ProcessAndWriteBlock2_2P:
	or.w	d2,d0
	swap	d0
	btst	#3,(a0)
	bne.s	loc_E220
	btst	#2,(a0)
	bne.s	loc_E210
	move.l	d0,(a5)
	move.l	(a1)+,(a6)
	rts
; ===========================================================================

loc_E210:
	move.l	d0,(a5)
	move.l	(a1)+,d3
	eori.l	#(flip_x<<16)|flip_x,d3
	swap	d3
	move.l	d3,(a6)
	rts
; ===========================================================================

loc_E220:
	btst	#2,(a0)
	bne.s	loc_E234
	move.l	d0,(a5)
	move.l	(a1)+,d3
	eori.l	#(flip_y<<16)|flip_y,d3
	move.l	d3,(a6)
	rts
; ===========================================================================

loc_E234:
	move.l	d0,(a5)
	move.l	(a1)+,d3
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d3
	swap	d3
	move.l	d3,(a6)
	rts
; End of function ProcessAndWriteBlock2_2P


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_E244
GetBlockPtr:
	add.w	(a3),d5
	add.w	4(a3),d4
	lea	(Block_Table).w,a1
	move.w	d4,d3		; d3 = camera Y pos + offset
	add.w	d3,d3
	andi.w	#$F00,d3	; limit to units of $100 ($100 = $80 * 2, $80 = height of a 128x128)
	lsr.w	#3,d5		; divide by 8
	move.w	d5,d0
	lsr.w	#4,d0		; divide by 16 (overall division of 128)
	andi.w	#$7F,d0
	add.w	d3,d0		; get offset of current 128x128 in the level layout table
	moveq	#-1,d3
	clr.w	d3		; d3 = $FFFF0000
	move.b	(a4,d0.w),d3	; get tile ID of the current 128x128 tile
	lsl.w	#7,d3		; multiply by 128, the size in bytes of a 128x128 in RAM
	andi.w	#$70,d4		; round down to nearest 16-pixel boundary
	andi.w	#$E,d5		; force this to be a multiple of 16
	add.w	d4,d3		; add vertical offset of current 16x16
	add.w	d5,d3		; add horizontal offset of current 16x16
	movea.l	d3,a0		; store address, in the metablock table, of the current 16x16
	move.w	(a0),d3
	andi.w	#$3FF,d3
	lsl.w	#3,d3
	adda.w	d3,a1
	rts
; End of function GetBlockPtr


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E286: Calc_VRAM_Pos:
CalcBlockVRAMPos:
	add.w	(a3),d5		; add X pos

CalcBlockVRAMPos2:
	tst.w	(Two_player_mode).w
	bne.s	CalcBlockVRAMPos_2P
	add.w	4(a3),d4	; add Y pos
	andi.w	#$F0,d4		; round down to the nearest 16-pixel boundary
	andi.w	#$1F0,d5	; round down to the nearest 16-pixel boundary
	lsl.w	#4,d4		; make it into units of $100 - the height in plane A of a 16x16
	lsr.w	#2,d5		; make it into units of 4 - the width in plane A of a 16x16
	add.w	d5,d4		; combine the two to get final address
	; access a VDP address in plane name table A ($C000) or B ($E000) if d2 has bit 13 unset or set
	moveq	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE)&$FFFF,d0
	swap	d0
	move.w	d4,d0		; make word-swapped VDP command
	rts
; ===========================================================================
; loc_E2A8:
CalcBlockVRAMPos_2P:
	add.w	4(a3),d4

loc_E2AC:
	andi.w	#$1F0,d4
	andi.w	#$1F0,d5
	lsl.w	#3,d4
	lsr.w	#2,d5
	add.w	d5,d4
	; access a VDP address in plane name table A ($C000) or B ($E000) if d2 has bit 13 unset or set
	moveq	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE)&$FFFF,d0
	swap	d0
	move.w	d4,d0
	rts
; End of function CalcBlockVRAMPos


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;loc_E2C2:
CalcBlockVRAMPosB:
	tst.w	(Two_player_mode).w
	bne.s	+
	add.w	4(a3),d4
	add.w	(a3),d5
	andi.w	#$F0,d4
	andi.w	#$1F0,d5
	lsl.w	#4,d4
	lsr.w	#2,d5
	add.w	d5,d4
	; access a VDP address in 2p plane name table A ($A000) or B ($8000) if d2 has bit 13 unset or set
	moveq	#vdpComm(VRAM_Plane_A_Name_Table_2P,VRAM,WRITE)&$FFFF,d0
	swap	d0
	move.w	d4,d0
	rts
; ===========================================================================
; interestingly, this subroutine was in the Sonic 1 ROM, unused
+
	add.w	4(a3),d4
	add.w	(a3),d5
	andi.w	#$1F0,d4
	andi.w	#$1F0,d5
	lsl.w	#3,d4
	lsr.w	#2,d5
	add.w	d5,d4
	; access a VDP address in 2p plane name table A ($A000) or B ($8000) if d2 has bit 13 unset or set
	moveq	#vdpComm(VRAM_Plane_A_Name_Table_2P,VRAM,WRITE)&$FFFF,d0
	swap	d0
	move.w	d4,d0
	rts
; End of function CalcBlockVRAMPosB

; ===========================================================================
; Loads the background in its initial state into VRAM (plane B).
; Especially important for levels that never re-load the background dynamically
;loc_E300:
DrawInitialBG:
	lea	(VDP_control_port).l,a5
	lea	(VDP_data_port).l,a6
	lea	(Camera_BG_X_pos).w,a3
	lea	(Level_Layout+$80).w,a4	; background
	move.w	#vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE)>>16,d2
	moveq	#0,d4
	cmpi.b	#casino_night_zone,(Current_Zone).w
	beq.w	++
	tst.w	(Two_player_mode).w
	beq.w	+
	cmpi.b	#mystic_cave_zone,(Current_Zone).w
	beq.w	loc_E396
+
	moveq	#-$10,d4
+
	moveq	#$F,d6
-	movem.l	d4-d6,-(sp)
	moveq	#0,d5
	move.w	d4,d1
	bsr.w	CalcBlockVRAMPos
	move.w	d1,d4
	moveq	#0,d5
	moveq	#$1F,d6
	move	#$2700,sr
	bsr.w	DrawBlockRow
	move	#$2300,sr
	movem.l	(sp)+,d4-d6
	addi.w	#$10,d4
	dbf	d6,-

	rts
; ===========================================================================
; dead code
	moveq	#-$10,d4

	moveq	#$F,d6
-	movem.l	d4-d6,-(sp)
	moveq	#0,d5
	move.w	d4,d1
	bsr.w	CalcBlockVRAMPosB
	move.w	d1,d4
	moveq	#0,d5
	moveq	#$1F,d6
	move	#$2700,sr
	bsr.w	DrawBlockRow
	move	#$2300,sr
	movem.l	(sp)+,d4-d6
	addi.w	#$10,d4
	dbf	d6,-

	rts
; ===========================================================================

loc_E396:
	moveq	#0,d4

	moveq	#$1F,d6
-	movem.l	d4-d6,-(sp)
	moveq	#0,d5
	move.w	d4,d1
	bsr.w	loc_E2AC
	move.w	d1,d4
	moveq	#0,d5
	moveq	#$1F,d6
	move	#$2700,sr
	bsr.w	DrawBlockRow3
	move	#$2300,sr
	movem.l	(sp)+,d4-d6
	addi.w	#$10,d4
	dbf	d6,-

	rts
