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
	beq.s	Draw_FG

	move.b	#0,(Screen_redraw_flag).w

	moveq	#-block_width,d4	; X (relative to camera)
	moveq	#(1+screen_height/block_height+1)-1,d6 ; Cover the screen, plus an extra row at the top and bottom.
; loc_DACE:
Draw_All:
	; Redraw the whole screen.
	movem.l	d4-d6,-(sp)
	moveq	#-block_width,d5	; X (relative)
	move.w	d4,d1
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	d1,d4
	moveq	#-block_width,d5	; X (relative)
	bsr.w	DrawBlockRow		; draw the current row
	movem.l	(sp)+,d4-d6
	addi.w	#block_height,d4	; move onto the next row
	dbf	d6,Draw_All		; repeat for all rows

	move.b	#0,(Scroll_flags_copy).w

	rts
; ===========================================================================
; loc_DAF6:
Draw_FG:
	tst.b	(a2)		; is any scroll flag set?
	beq.s	return_DB5A	; if not, branch

	bclr	#scroll_flag_fg_up,(a2)	; has the level scrolled up?
	beq.s	+			; if not, branch
	moveq	#-block_height,d4
	moveq	#-block_width,d5
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	moveq	#-block_height,d4
	moveq	#-block_width,d5
	bsr.w	DrawBlockRow	; redraw upper row
+
	bclr	#scroll_flag_fg_down,(a2)	; has the level scrolled down?
	beq.s	+			; if not, branch
	move.w	#screen_height,d4
	moveq	#-block_width,d5
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	#screen_height,d4
	moveq	#-block_width,d5
	bsr.w	DrawBlockRow	; redraw bottom row
+
	bclr	#scroll_flag_fg_left,(a2)	; has the level scrolled to the left?
	beq.s	+			; if not, branch
	moveq	#-block_height,d4
	moveq	#-block_width,d5
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	moveq	#-block_height,d4
	moveq	#-block_width,d5
	bsr.w	DrawBlockColumn	; redraw left-most column
+
	bclr	#scroll_flag_fg_right,(a2)	; has the level scrolled to the right?
	beq.s	return_DB5A		; if not, return
	moveq	#-block_height,d4
	move.w	#screen_width,d5
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	moveq	#-block_height,d4
	move.w	#screen_width,d5
	bsr.w	DrawBlockColumn	; redraw right-most column

return_DB5A:
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_DB5C:
Draw_FG_P2:
	tst.b	(a2)
	beq.s	return_DBC0

	bclr	#scroll_flag_fg_up,(a2)
	beq.s	+
	moveq	#-block_height,d4	; Y offset
	moveq	#-block_width,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer2
	moveq	#-block_height,d4	; Y offset
	moveq	#-block_width,d5	; X offset
	bsr.w	DrawBlockRow
+
	bclr	#scroll_flag_fg_down,(a2)
	beq.s	+
	move.w	#screen_height,d4	; Y offset
	moveq	#-block_width,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer2
	move.w	#screen_height,d4	; Y offset
	moveq	#-block_width,d5	; X offset
	bsr.w	DrawBlockRow
+
	bclr	#scroll_flag_fg_left,(a2)
	beq.s	+
	moveq	#-block_height,d4	; Y offset
	moveq	#-block_width,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer2
	moveq	#-block_height,d4	; Y offset
	moveq	#-block_width,d5	; X offset
	bsr.w	DrawBlockColumn
+
	bclr	#scroll_flag_fg_right,(a2)
	beq.s	return_DBC0
	moveq	#-block_height,d4	; Y offset
	move.w	#screen_width,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer2
	moveq	#-block_height,d4	; Y offset
	move.w	#screen_width,d5	; X offset
	bsr.w	DrawBlockColumn

return_DBC0:
	rts
; End of function Draw_FG_P2


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_DBC2:
Draw_BG1:
	tst.b	(a2)
	beq.w	return_DC90

	bclr	#scroll_flag_bg1_up,(a2)
	beq.s	+
	moveq	#-block_height,d4	; Y offset
	moveq	#-block_width,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	moveq	#-block_height,d4	; Y offset
	moveq	#-block_width,d5	; X offset
	bsr.w	DrawBlockRow
+
	bclr	#scroll_flag_bg1_down,(a2)
	beq.s	+
	move.w	#screen_height,d4	; Y offset
	moveq	#-block_width,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	#screen_height,d4	; Y offset
	moveq	#-block_width,d5	; X offset
	bsr.w	DrawBlockRow
+
	bclr	#scroll_flag_bg1_left,(a2)
	beq.s	+
	moveq	#-block_height,d4	; Y offset
	moveq	#-block_width,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	moveq	#-block_height,d4	; Y offset
	moveq	#-block_width,d5	; X offset
	bsr.w	DrawBlockColumn
+
	bclr	#scroll_flag_bg1_right,(a2)
	beq.s	+
	moveq	#-block_height,d4	; Y offset
	move.w	#screen_width,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	moveq	#-block_height,d4	; Y offset
	move.w	#screen_width,d5	; X offset
	bsr.w	DrawBlockColumn
+
	bclr	#scroll_flag_bg1_up_whole_row,(a2)
	beq.s	+
	moveq	#-block_height,d4		; Y offset
	moveq	#0,d5		; X (absolute)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1.AbsoluteX
	moveq	#-block_height,d4
	moveq	#0,d5
	moveq	#gameplay_plane_width/block_width-1,d6	; The entire width of the plane in blocks minus 1.
	bsr.w	DrawBlockRow.AbsoluteXCustomWidth
+
	bclr	#scroll_flag_bg1_down_whole_row,(a2)
	beq.s	+
	move.w	#screen_height,d4		; Y offset
	moveq	#0,d5		; X (absolute)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1.AbsoluteX
	move.w	#screen_height,d4
	moveq	#0,d5
	moveq	#gameplay_plane_width/block_width-1,d6	; The entire width of the plane in blocks minus 1.
	bsr.w	DrawBlockRow.AbsoluteXCustomWidth
+
	; This should be no different than 'scroll_flag_bg1_up_whole_row'.
	; The only difference between the two is that this has a relative X
	; coordinate, but that doesn't matter since the entire row is copied
	; anyway.
	bclr	#scroll_flag_bg1_up_whole_row_2,(a2)
	beq.s	+
	moveq	#-block_height,d4		; Y offset (relative to camera)
	moveq	#-block_width,d5		; X offset (relative to camera)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	moveq	#-block_height,d4
	moveq	#-block_width,d5
	moveq	#gameplay_plane_width/block_width-1,d6	; The entire width of the plane in blocks minus 1.
	bsr.w	DrawBlockRow_CustomWidth
+
	; This should be no different than 'scroll_flag_bg1_down_whole_row'.
	; The only difference between the two is that this has a relative X
	; coordinate, but that doesn't matter since the entire row is copied
	; anyway.
	bclr	#scroll_flag_bg1_down_whole_row_2,(a2)
	beq.s	return_DC90
	move.w	#screen_height,d4		; Y offset (relative to camera)
	moveq	#-block_width,d5		; X offset (relative to camera)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	#screen_height,d4
	moveq	#-block_width,d5
	moveq	#gameplay_plane_width/block_width-1,d6	; The entire width of the plane in blocks minus 1.
	bsr.w	DrawBlockRow_CustomWidth

return_DC90:
	rts
; End of function Draw_BG1


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_DC92:
Draw_BG2:
	tst.b	(a2)
	beq.w	++	; rts

	; Leftover from Sonic 1: was used by Green Hill Zone and Spring Yard Zone.
	bclr	#scroll_flag_bg2_left,(a2)
	beq.s	+
	move.w	#block_height*7,d4	; Y offset
	moveq	#-block_width,d5	; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	#block_height*7,d4	; Y offset
	moveq	#-block_width,d5	; X offset
	moveq	#3-1,d6	; Only three blocks, which works out to 48 pixels in height.
	bsr.w	DrawBlockColumn.CustomHeight
+
	bclr	#scroll_flag_bg2_right,(a2)
	beq.s	+
	move.w	#block_height*7,d4	; Y offset
	move.w	#screen_width,d5		; X offset
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	#block_height*7,d4	; Y offset
	move.w	#screen_width,d5	; X offset
	moveq	#3-1,d6	; Only three blocks, which works out to 48 pixels in height.
	bsr.w	DrawBlockColumn.CustomHeight
+
	rts
; End of function Draw_BG2

; ===========================================================================
; Scrap Brain Zone 1 block positioning array -- S1 left-over
; Each entry is an index into BGCameraLookup; used to decide the camera to use
; for given block for reloading BG. A entry of 0 means assume X = 0 for section,
; but otherwise loads camera Y for selected camera.
; Note that this list is 32 blocks long, which is enough to span the entire
; two-chunk-tall background.
;byte_DCD6
SBZ_CameraSections:
	; BG1 (draw whole row)
	dc.b 0	; 0
	dc.b 0	; 1
	dc.b 0	; 2
	dc.b 0	; 3
	dc.b 0	; 4
	; BG3
	dc.b 6	; 5
	dc.b 6	; 6
	dc.b 6	; 7
	dc.b 6	; 8
	dc.b 6	; 9
	dc.b 6	; 10
	dc.b 6	; 11
	dc.b 6	; 12
	dc.b 6	; 13
	dc.b 6	; 14
	; BG2
	dc.b 4	; 15
	dc.b 4	; 16
	dc.b 4	; 17
	dc.b 4	; 18
	dc.b 4	; 19
	dc.b 4	; 20
	dc.b 4	; 21
	; BG1
	dc.b 2	; 22
	dc.b 2	; 23
	dc.b 2	; 24
	dc.b 2	; 25
	dc.b 2	; 26
	dc.b 2	; 27
	dc.b 2	; 28
	dc.b 2	; 29
	dc.b 2	; 30
	dc.b 2	; 31
	dc.b 2	; 32

	; Total height: 2 256x256 chunks.
	; This matches the height of the background.

	even

; ===========================================================================
	; Scrap Brain Zone 1 drawing code -- Sonic 1 left-over.

;Draw_BG2_SBZ:
	; Chemical Plant Zone uses a lighty-modified version this code.
	; This is an advanced form of the usual background-drawing code that
	; allows each row of blocks to update and scroll independently...
	; kind of. There are only three possible 'cameras' that each row can
	; align itself with. Still, each row is free to decide which camera
	; it aligns with.
	; This could have really benefitted Oil Ocean Zone's background,
	; which has a section that goes unseen because the regular background
	; drawer is too primitive to display it without making the sun and
	; clouds disappear. Using this would have avoided that.

	; Handle loading the rows as the camera moves up and down.
	moveq	#-block_height,d4	; Y offset (relative to camera)
	bclr	#scroll_flag_advanced_bg_up,(a2)
	bne.s	.doUpOrDown
	bclr	#scroll_flag_advanced_bg_down,(a2)
	beq.s	.checkIfShouldDoLeftOrRight
	move.w	#screen_height,d4	; Y offset (relative to camera)

.doUpOrDown:
	lea_	SBZ_CameraSections+1,a0
	move.w	(Camera_BG_Y_pos).w,d0
	add.w	d4,d0
	andi.w	#$1F0,d0	; After right-shifting, the is a mask of $1F. Since SBZ_CameraSections is $20 items long, this is correct.
	lsr.w	#4,d0
	move.b	(a0,d0.w),d0
	lea	(BGCameraLookup).l,a3
	movea.w	(a3,d0.w),a3	; Camera, either BG, BG2 or BG3 depending on Y
	beq.s	.doWholeRow
	moveq	#-block_width,d5	; X offset (relative to camera)
	movem.l	d4-d5,-(sp)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	movem.l	(sp)+,d4-d5
	bsr.w	DrawBlockRow
	bra.s	.checkIfShouldDoLeftOrRight
; ===========================================================================

.doWholeRow:
	moveq	#0,d5	; X (absolute)
	movem.l	d4-d5,-(sp)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1.AbsoluteX
	movem.l	(sp)+,d4-d5
	moveq	#gameplay_plane_width/block_width-1,d6	; The entire width of the plane in blocks minus 1.
	bsr.w	DrawBlockRow.AbsoluteXCustomWidth

.checkIfShouldDoLeftOrRight:
	; If there are other scroll flags set, then go do them.
	tst.b	(a2)
	bne.s	.doLeftOrRight
	rts
; ===========================================================================

.doLeftOrRight:
	moveq	#-block_height,d4 ; Y offset

	; Load left column.
	moveq	#-block_width,d5 ; X offset
	move.b	(a2),d0
	andi.b	#(1<<scroll_flag_advanced_bg1_right)|(1<<scroll_flag_advanced_bg2_right)|(1<<scroll_flag_advanced_bg3_right),d0
	beq.s	+
	lsr.b	#1,d0	; Make the left and right flags share the same bits, to simplify a calculation later.
	move.b	d0,(a2)
	; Load right column.
	move.w	#screen_width,d5 ; X offset
+
	; Select the correct starting background section, and then begin
	; drawing the column.
	lea_	SBZ_CameraSections,a0
	move.w	(Camera_BG_Y_pos).w,d0
	andi.w	#$1F0,d0	; After right-shifting, the is a mask of $1F. Since SBZ_CameraSections is $20 items long, this is correct.
	lsr.w	#4,d0
	lea	(a0,d0.w),a0
	bra.w	DrawBlockColumn_Advanced
; end unused routine

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_DD82:
Draw_BG3:
	tst.b	(a2)
	beq.w	++	; rts

	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	beq.w	Draw_BG3_CPZ
    if fixBugs
	cmpi.b	#oil_ocean_zone,(Current_Zone).w
	beq.w	Draw_BG3_OOZ
    endif

	; Leftover from Sonic 1: was used by Green Hill Zone.
	bclr	#scroll_flag_bg3_left,(a2)
	beq.s	+
	move.w	#block_height*4,d4	; Y offset (relative to camera)
	moveq	#-block_width,d5	; X offset (relative to camera)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	#block_height*4,d4	; Y offset (relative to camera)
	moveq	#-block_width,d5	; X offset (relative to camera)
	moveq	#3-1,d6
	bsr.w	DrawBlockColumn.CustomHeight
+
	bclr	#scroll_flag_bg3_right,(a2)
	beq.s	+
	move.w	#block_height*4,d4	; Y offset (relative to camera)
	move.w	#screen_width,d5	; X offset (relative to camera)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	#block_height*4,d4	; Y offset (relative to camera)
	move.w	#screen_width,d5	; X offset (relative to camera)
	moveq	#3-1,d6
	bsr.w	DrawBlockColumn.CustomHeight
+
	rts
; ===========================================================================
; Chemical Plant Zone block positioning array
; Each entry is an index into BGCameraLookup; used to decide the camera to use
; for given block for reloading BG. Unlike the Scrap Brain Zone version, 0
; does not make X = 0: it's just a duplicate of 2.
;byte_DDD0
CPZ_CameraSections:
	; BG1
	dc.b 2	; 0
	dc.b 2	; 1
	dc.b 2	; 2
	dc.b 2	; 3
	dc.b 2	; 4
	dc.b 2	; 5
	dc.b 2	; 6
	dc.b 2	; 7
	dc.b 2	; 8
	dc.b 2	; 9
	dc.b 2	; 10
	dc.b 2	; 11
	dc.b 2	; 12
	dc.b 2	; 13
	dc.b 2	; 14
	dc.b 2	; 15
	dc.b 2	; 16
	dc.b 2	; 17
	dc.b 2	; 18
	dc.b 2	; 19
	; BG2
	dc.b 4	; 20
	dc.b 4	; 21
	dc.b 4	; 22
	dc.b 4	; 23
	dc.b 4	; 24
	dc.b 4	; 25
	dc.b 4	; 26
	dc.b 4	; 27
	dc.b 4	; 28
	dc.b 4	; 29
	dc.b 4	; 30
	dc.b 4	; 31
	dc.b 4	; 32
	dc.b 4	; 33
	dc.b 4	; 34
	dc.b 4	; 35
	dc.b 4	; 36
	dc.b 4	; 37
	dc.b 4	; 38
	dc.b 4	; 39
	dc.b 4	; 40
	dc.b 4	; 41
	dc.b 4	; 42
	dc.b 4	; 43
	dc.b 4	; 44
	dc.b 4	; 45
	dc.b 4	; 46
	dc.b 4	; 47
	dc.b 4	; 48
	dc.b 4	; 49
	dc.b 4	; 50
	dc.b 4	; 51
	dc.b 4	; 52
	dc.b 4	; 53
	dc.b 4	; 54
	dc.b 4	; 55
	dc.b 4	; 56
	dc.b 4	; 57
	dc.b 4	; 58
	dc.b 4	; 59
	dc.b 4	; 60
	dc.b 4	; 61
	dc.b 4	; 62
	dc.b 4	; 63
	dc.b 4	; 64

	; Total height: 8 128x128 chunks.
	; CPZ's background is only 7 chunks tall, but extending to
	; 8 is necessary for wrapping to be achieved using bitmasks.

	even

; ===========================================================================
; loc_DE12:
Draw_BG3_CPZ:
	; This is a lighty-modified duplicate of Scrap Brain Zone's drawing
	; code (which is still in this game - it's labelled 'Draw_BG2_SBZ').
	; This is an advanced form of the usual background-drawing code that
	; allows each row of blocks to update and scroll independently...
	; kind of. There are only three possible 'cameras' that each row can
	; align itself with. Still, each row is free to decide which camera
	; it aligns with.
	; This could have really benefitted Oil Ocean Zone's background,
	; which has a section that goes unseen because the regular background
	; drawer is too primitive to display it without making the sun and
	; clouds disappear. Using this would have avoided that.
	; This code differs from the Scrap Brain Zone version by being
	; hardcoded to a different table ('CPZ_CameraSections' instead of
	; 'SBZ_CameraSections'), and lacking support for redrawing the whole
	; row when it uses "camera 0".

	; Handle loading the rows as the camera moves up and down.
	moveq	#-block_height,d4	; Y offset
	bclr	#scroll_flag_advanced_bg_up,(a2)
	bne.s	.doUpOrDown
	bclr	#scroll_flag_advanced_bg_down,(a2)
	beq.s	.checkIfShouldDoLeftOrRight
	move.w	#screen_height,d4	; Y offset

.doUpOrDown:
	; Select the correct camera, so that the X value of the loaded row is
	; right.
	lea_	CPZ_CameraSections+1,a0
	move.w	(Camera_BG_Y_pos).w,d0
	add.w	d4,d0
	andi.w	#$3F0,d0	; After right-shifting, the is a mask of $3F. Since CPZ_CameraSections is $40 items long, this is correct.
	lsr.w	#4,d0
	move.b	(a0,d0.w),d0
	movea.w	BGCameraLookup(pc,d0.w),a3	; Camera, either BG, BG2 or BG3 depending on Y
	moveq	#-block_width,d5	; X offset
	movem.l	d4-d5,-(sp)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	movem.l	(sp)+,d4-d5
	bsr.w	DrawBlockRow

.checkIfShouldDoLeftOrRight:
	; If there are other scroll flags set, then go do them.
	tst.b	(a2)
	bne.s	.doLeftOrRight
	rts
; ===========================================================================

.doLeftOrRight:
	moveq	#-block_height,d4 ; Y offset

	; Load left column.
	moveq	#-block_width,d5 ; X offset
	move.b	(a2),d0
	andi.b	#(1<<scroll_flag_advanced_bg1_right)|(1<<scroll_flag_advanced_bg2_right)|(1<<scroll_flag_advanced_bg3_right),d0
	beq.s	+
	lsr.b	#1,d0	; Make the left and right flags share the same bits, to simplify a calculation later.
	move.b	d0,(a2)
	; Load right column.
	move.w	#screen_width,d5 ; X offset
+
	; Select the correct starting background section, and then begin
	; drawing the column.
	lea_	CPZ_CameraSections,a0
	move.w	(Camera_BG_Y_pos).w,d0
    if fixBugs
	andi.w	#$3F0,d0	; After right-shifting, the is a mask of $3F. Since CPZ_CameraSections is $40 items long, this is correct.
    else
	; After right-shifting, the is a mask of $7F. Since CPZ_CameraSections
	; is $40 items long, this is incorrect, and will cause accesses to
	; exceed the bounds of CPZ_CameraSections and read invalid data. This
	; is most notably a problem in Marble Zone's version of this code.
	andi.w	#$7F0,d0
    endif
	lsr.w	#4,d0
	lea	(a0,d0.w),a0
	bra.w	DrawBlockColumn_Advanced
; ===========================================================================
;word_DE7E
BGCameraLookup:
	dc.w Camera_BG_copy	; BG Camera
	dc.w Camera_BG_copy	; BG Camera
	dc.w Camera_BG2_copy	; BG2 Camera
	dc.w Camera_BG3_copy	; BG3 Camera
; ===========================================================================
; loc_DE86:
DrawBlockColumn_Advanced:
	tst.w	(Two_player_mode).w
	bne.s	.doubleResolution

	moveq	#(1+screen_height/block_height+1)-1,d6	; Enough blocks to cover the screen, plus one more on the top and bottom.
	move.l	#vdpCommDelta(gameplay_plane_width/tile_width*2),d7	; store VDP command for line increment

-
	; If the block is not part of the row that needs updating, then skip
	; drawing it.
	moveq	#0,d0
	move.b	(a0)+,d0
	btst	d0,(a2)
	beq.s	+

	; Get the correct camera and draw this block.
	movea.w	BGCameraLookup(pc,d0.w),a3	; Camera, either BG, BG2 or BG3 depending on Y
	movem.l	d4-d5/a0,-(sp)
	movem.l	d4-d5,-(sp)
	bsr.w	GetBlock
	movem.l	(sp)+,d4-d5
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	bsr.w	ProcessAndWriteBlock_Vertical
	movem.l	(sp)+,d4-d5/a0
+
	; Move onto the next block down.
	addi.w	#block_height,d4
	dbf	d6,-

	; Clear the scroll flags now that we're done here.
	clr.b	(a2)

	rts
; ===========================================================================

.doubleResolution:
	moveq	#(1+screen_height/block_height+1)-1,d6	; Enough blocks to cover the screen, plus one more on the top and bottom.
	move.l	#vdpCommDelta(gameplay_plane_width/tile_width*2),d7	; store VDP command for line increment

-
	; If the block is not part of the row that needs updating, then skip
	; drawing it.
	moveq	#0,d0
	move.b	(a0)+,d0
	btst	d0,(a2)
	beq.s	+

	; Get the correct camera and draw this block.
	movea.w	BGCameraLookup(pc,d0.w),a3	; Camera, either BG, BG2 or BG3 depending on Y
	movem.l	d4-d5/a0,-(sp)
	movem.l	d4-d5,-(sp)
	bsr.w	GetBlock
	movem.l	(sp)+,d4-d5
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	bsr.w	ProcessAndWriteBlock_DoubleResolution_Vertical
	movem.l	(sp)+,d4-d5/a0
+
	; Move onto the next block down.
	addi.w	#block_height,d4
	dbf	d6,-

	; Clear the scroll flags now that we're done here.
	clr.b	(a2)

	rts
; End of function Draw_BG3


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
    if fixBugs
	; See 'SwScrl_OOZ'.
	; This uses the same drawing method as Chemical Plant Zone to enable
	; the unused part of Oil Ocean Zone's background to be drawn without
	; it causing the clouds and sun to disappear.

; Oil Ocean Zone block positioning array
; Each entry is an index into BGCameraLookup; used to decide the camera to use
; for given block for reloading BG. A entry of 0 means assume X = 0 for section,
; but otherwise loads camera Y for selected camera.

OOZ_CameraSections:
	; BG1 (draw whole row) for the sky.
	dc.b 0	; 0
	dc.b 0	; 1
	dc.b 0	; 2
	dc.b 0	; 3
	dc.b 0	; 4
	dc.b 0	; 5
	dc.b 0	; 6
	dc.b 0	; 7
	dc.b 0	; 8
	dc.b 0	; 9
	dc.b 0	; 10
	dc.b 0	; 11
	dc.b 0	; 12
	dc.b 0	; 13
	dc.b 0	; 14
	dc.b 0	; 15
	dc.b 0	; 16
	; BG1 for the factory.
	dc.b 2	; 17
	dc.b 2	; 18
	dc.b 2	; 19
	dc.b 2	; 20
	dc.b 2	; 21
	dc.b 2	; 22
	dc.b 2	; 23
	dc.b 2	; 24
	dc.b 2	; 25
	dc.b 2	; 26
	dc.b 2	; 27
	dc.b 2	; 28
	dc.b 2	; 29
	dc.b 2	; 30
	dc.b 2	; 31
	dc.b 2	; 32

	; Total height: 4 128x128 chunks.
	; This matches the height of the background.

	even

; ===========================================================================

Draw_BG3_OOZ:
	; This is a lighty-modified duplicate of Scrap Brain Zone's drawing
	; code (which is still in this game - it's labelled 'Draw_BG2_SBZ').
	; This is an advanced form of the usual background-drawing code that
	; allows each row of blocks to update and scroll independently...
	; kind of. There are only three possible 'cameras' that each row can
	; align itself with. Still, each row is free to decide which camera
	; it aligns with.

	; Handle loading the rows as the camera moves up and down.
	moveq	#-block_height,d4	; Y offset
	bclr	#scroll_flag_advanced_bg_up,(a2)
	bne.s	.doUpOrDown
	bclr	#scroll_flag_advanced_bg_down,(a2)
	beq.s	.checkIfShouldDoLeftOrRight
	move.w	#screen_height,d4	; Y offset

.doUpOrDown:
	; Select the correct camera, so that the X value of the loaded row is
	; right.
	lea_	OOZ_CameraSections+1,a0
	move.w	(Camera_BG_Y_pos).w,d0
	add.w	d4,d0
	andi.w	#$1F0,d0	; After right-shifting, the is a mask of $1F. Since OOZ_CameraSections is $20 items long, this is correct.
	lsr.w	#4,d0
	move.b	(a0,d0.w),d0
	lea	BGCameraLookup(pc),a3
	movea.w	(a3,d0.w),a3	; Camera, either BG, BG2 or BG3 depending on Y
	beq.s	.doWholeRow
	moveq	#-block_width,d5	; X offset
	movem.l	d4-d5,-(sp)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	movem.l	(sp)+,d4-d5
	bsr.w	DrawBlockRow
	bra.s	.checkIfShouldDoLeftOrRight
; ===========================================================================

.doWholeRow:
	moveq	#0,d5	; X (absolute)
	movem.l	d4-d5,-(sp)
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1.AbsoluteX
	movem.l	(sp)+,d4-d5
	moveq	#gameplay_plane_width/block_width-1,d6	; The entire width of the plane in blocks minus 1.
	bsr.w	DrawBlockRow.AbsoluteXCustomWidth

.checkIfShouldDoLeftOrRight:
	; If there are other scroll flags set, then go do them.
	tst.b	(a2)
	bne.s	.doLeftOrRight
	rts
; ===========================================================================

.doLeftOrRight:
	moveq	#-block_height,d4 ; Y offset

	; Load left column.
	moveq	#-block_width,d5 ; X offset
	move.b	(a2),d0
	andi.b	#(1<<scroll_flag_advanced_bg1_right)|(1<<scroll_flag_advanced_bg2_right)|(1<<scroll_flag_advanced_bg3_right),d0
	beq.s	+
	lsr.b	#1,d0	; Make the left and right flags share the same bits, to simplify a calculation later.
	move.b	d0,(a2)
	; Load right column.
	move.w	#screen_width,d5 ; X offset
+
	; Select the correct starting background section, and then begin
	; drawing the column.
	lea_	OOZ_CameraSections,a0
	move.w	(Camera_BG_Y_pos).w,d0
	andi.w	#$1F0,d0	; After right-shifting, the is a mask of $1F. Since OOZ_CameraSections is $20 items long, this is correct.
	lsr.w	#4,d0
	lea	(a0,d0.w),a0
	bra.w	DrawBlockColumn_Advanced
    endif

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_DF04: DrawBlockCol1:
DrawBlockColumn:
	moveq	#(1+screen_height/block_height+1)-1,d6 ; Enough blocks to cover the screen, plus one more on the top and bottom.
; DrawBlockCol2:
.CustomHeight:
	add.w	(a3),d5		; add camera X pos
	add.w	4(a3),d4	; add camera Y pos
	move.l	#vdpCommDelta(gameplay_plane_width/tile_width*2),d7	; store VDP command for line increment
	move.l	d0,d1		; copy byte-swapped VDP command for later access
	bsr.w	GetAddressOfBlockInChunk

	tst.w	(Two_player_mode).w
	bne.s	.doubleResolution

-	move.w	(a0),d3		; get ID of the 16x16 block
	andi.w	#$3FF,d3
	lsl.w	#3,d3		; multiply by 8, the size in bytes of a 16x16
	lea	(Block_Table).w,a1
	adda.w	d3,a1		; a1 = address of the current 16x16 in the block table
	move.l	d1,d0
	bsr.w	ProcessAndWriteBlock_Vertical
	adda.w	#chunk_width/block_width*2,a0	; move onto the 16x16 vertically below this one
	addi.w	#gameplay_plane_width/tile_width*2*2,d1	; draw on alternate 8x8 lines
	andi.w	#((gameplay_plane_width/tile_width)*(gameplay_plane_height/tile_height)*2)-1,d1	; wrap around plane (assumed to be in 64x32 mode)
	addi.w	#block_height,d4		; add 16 to Y offset
	move.w	d4,d0
	andi.w	#$70,d0		; have we reached a new 128x128?
	bne.s	+		; if not, branch
	bsr.w	GetAddressOfBlockInChunk	; otherwise, renew the block address
+	dbf	d6,-		; repeat 16 times

	rts
; ===========================================================================

.doubleResolution:
-	move.w	(a0),d3
	andi.w	#$3FF,d3
	lsl.w	#3,d3
	lea	(Block_Table).w,a1
	adda.w	d3,a1
	move.l	d1,d0
	bsr.w	ProcessAndWriteBlock_DoubleResolution_Vertical
	adda.w	#chunk_width/block_width*2,a0
	addi.w	#gameplay_plane_width/tile_width*2,d1
	andi.w	#((gameplay_plane_width/tile_width)*(gameplay_plane_height/tile_height)*2)-1,d1
	addi.w	#block_height,d4
	move.w	d4,d0
	andi.w	#$70,d0
	bne.s	+
	bsr.w	GetAddressOfBlockInChunk
+	dbf	d6,-

	rts
; End of function DrawBlockColumn


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_DF8A: DrawTiles_Vertical: DrawBlockRow:
DrawBlockRow_CustomWidth:
	add.w	(a3),d5
	add.w	4(a3),d4
	bra.s	DrawBlockRow.AbsoluteXAbsoluteYCustomWidth
; End of function DrawBlockRow_CustomWidth


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_DF92: DrawTiles_Vertical1: DrawBlockRow1:
DrawBlockRow:
	moveq	#(1+screen_width/block_width+1)-1,d6 ; Just enough blocks to cover the screen.
	add.w	(a3),d5		; add X pos
; loc_DF96: DrawTiles_Vertical2: DrawBlockRow2:
.AbsoluteXCustomWidth:
	add.w	4(a3),d4	; add Y pos
; loc_DF9A: DrawTiles_Vertical3: DrawBlockRow3:
.AbsoluteXAbsoluteYCustomWidth:
	tst.w	(Two_player_mode).w
	bne.s	.doubleResolution

	move.l	a2,-(sp)
	move.w	d6,-(sp)
	lea	(Block_cache).w,a2
	move.l	d0,d1
	or.w	d2,d1
	swap	d1		; make VRAM write command
	move.l	d1,-(sp)
	move.l	d1,(a5)		; set up a VRAM write at that address
	swap	d1
	bsr.w	GetAddressOfBlockInChunk

-	move.w	(a0),d3		; get ID of the 16x16 block
	andi.w	#$3FF,d3
	lsl.w	#3,d3		; multiply by 8, the size in bytes of a 16x16
	lea	(Block_Table).w,a1
	adda.w	d3,a1		; a1 = address of current 16x16 in the block table
	bsr.w	ProcessAndWriteBlock_Horizontal
	addq.w	#2,a0		; move onto next 16x16
	addq.b	#4,d1		; increment VRAM write address
	bpl.s	+
	andi.b	#$7F,d1		; restrict to a single 8x8 line
	swap	d1
	move.l	d1,(a5)		; set up a VRAM write at a new address
	swap	d1
+
	addi.w	#block_width,d5		; add 16 to X offset
	move.w	d5,d0
	andi.w	#$70,d0		; have we reached a new 128x128?
	bne.s	+		; if not, branch
	bsr.w	GetAddressOfBlockInChunk	; otherwise, renew the block address
+
	dbf	d6,-		; repeat 22 times

	move.l	(sp)+,d1
	addi.l	#vdpCommDelta(gameplay_plane_width/tile_width*2),d1	; move onto next line
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
; loc_E018: DrawBlockRow_2P:
.doubleResolution:
	move.l	d0,d1
	or.w	d2,d1
	swap	d1
	move.l	d1,(a5)
	swap	d1
	tst.b	d1
	bmi.s	+++

	bsr.w	GetAddressOfBlockInChunk

-	move.w	(a0),d3
	andi.w	#$3FF,d3
	lsl.w	#3,d3
	lea	(Block_Table).w,a1
	adda.w	d3,a1
	bsr.w	ProcessAndWriteBlock_DoubleResolution_Horizontal
	addq.w	#2,a0
	addq.b	#4,d1
	bpl.s	+
	andi.b	#$7F,d1
	swap	d1
	move.l	d1,(a5)
	swap	d1
+
	addi.w	#block_width,d5
	move.w	d5,d0
	andi.w	#$70,d0
	bne.s	+
	bsr.w	GetAddressOfBlockInChunk
+	dbf	d6,-

	rts
; ===========================================================================
+
	bsr.w	GetAddressOfBlockInChunk

-	move.w	(a0),d3
	andi.w	#$3FF,d3
	lsl.w	#3,d3
	lea	(Block_Table).w,a1
	adda.w	d3,a1
	bsr.w	ProcessAndWriteBlock_DoubleResolution_Horizontal
	addq.w	#2,a0
	addq.b	#4,d1
	bmi.s	+
	ori.b	#$80,d1
	swap	d1
	move.l	d1,(a5)
	swap	d1
+
	addi.w	#block_width,d5
	move.w	d5,d0
	andi.w	#$70,d0
	bne.s	+
	bsr.w	GetAddressOfBlockInChunk
+	dbf	d6,-

	rts
; End of function DrawBlockRow


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E09E: GetBlockAddr:
GetAddressOfBlockInChunk:
	movem.l	d4-d5,-(sp)
	move.w	d4,d3		; d3 = camera Y pos + offset
	add.w	d3,d3
	andi.w	#$F00,d3	; limit to units of $100 ($100 = size of a row of FG and BG 128x128s in level layout table)
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
; End of function GetAddressOfBlockInChunk


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E0D4: ProcessAndWriteBlock:
ProcessAndWriteBlock_Horizontal:
	; Compared to 'ProcessAndWriteBlock_Vertical', this caches the bottom
	; two tiles far later writing. This avoids the need to constantly
	; alternate VRAM destinations.
	btst	#3,(a0)		; is this 16x16 to be Y-flipped?
	bne.s	.flipY		; if it is, branch
	btst	#2,(a0)		; is this 16x16 to be X-flipped?
	bne.s	.flipX		; if it is, branch
	move.l	(a1)+,(a6)	; write top two 8x8s to VRAM
	move.l	(a1)+,(a2)+	; store bottom two 8x8s for later writing
	rts
; ===========================================================================
; ProcessAndWriteBlock_FlipX:
.flipX:
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
; ProcessAndWriteBlock_FlipY:
.flipY:
	btst	#2,(a0)		; is this 16x16 to be X-flipped as well?
	bne.s	.flipXY		; if it is, branch
	move.l	(a1)+,d0
	move.l	(a1)+,d3
	eori.l	#(flip_y<<16)|flip_y,d3	; toggle Y-flip flag of the 8x8s
	move.l	d3,(a6)		; write bottom two 8x8s to VRAM
	eori.l	#(flip_y<<16)|flip_y,d0
	move.l	d0,(a2)+	; store top two 8x8s for later writing
	rts
; ===========================================================================
; ProcessAndWriteBlock_FlipXY:
.flipXY:
	move.l	(a1)+,d0
	move.l	(a1)+,d3
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d3	; toggle X and Y-flip flags of the 8x8s
	swap	d3
	move.l	d3,(a6)		; write bottom two 8x8s to VRAM
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d0
	swap	d0
	move.l	d0,(a2)+	; store top two 8x8s for later writing
	rts
; End of function ProcessAndWriteBlock_Horizontal


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_E136: ProcessAndWriteBlock_2P:
ProcessAndWriteBlock_DoubleResolution_Horizontal:
	; In two player mode, the VDP's Interlace Mode 2 is enabled, making
	; tiles twice as tall (16x8 instead of 8x8). Because of this, blocks
	; are now composed of only two tiles, arranged side by side.
	btst	#3,(a0)
	bne.s	.flipY
	btst	#2,(a0)
	bne.s	.flipX
	move.l	(a1)+,(a6)
	rts
; ===========================================================================
; loc_E146:
.flipX:
	move.l	(a1)+,d3
	eori.l	#(flip_x<<16)|flip_x,d3
	swap	d3
	move.l	d3,(a6)
	rts
; ===========================================================================
; loc_E154:
.flipY:
	btst	#2,(a0)
	bne.s	.flipXY
	move.l	(a1)+,d3
	eori.l	#(flip_y<<16)|flip_y,d3
	move.l	d3,(a6)
	rts
; ===========================================================================
;loc_E166:
.flipXY:
	move.l	(a1)+,d3
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d3
	swap	d3
	move.l	d3,(a6)
	rts
; End of function ProcessAndWriteBlock_DoubleResolution_Horizontal


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E174: ProcessAndWriteBlock2:
ProcessAndWriteBlock_Vertical:
	or.w	d2,d0
	swap	d0		; make VRAM write command
	btst	#3,(a0)		; is the 16x16 to be Y-flipped?
	bne.s	.flipY		; if it is, branch
	btst	#2,(a0)		; is the 16x16 to be X-flipped?
	bne.s	.flipX		; if it is, branch
	move.l	d0,(a5)		; write to this VRAM address
	move.l	(a1)+,(a6)	; write top two 8x8s
	add.l	d7,d0		; move onto next line
	move.l	d0,(a5)
	move.l	(a1)+,(a6)	; write bottom two 8x8s
	rts
; ===========================================================================
; ProcessAndWriteBlock2_FlipX:
.flipX:
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
; ProcessAndWriteBlock2_FlipY:
.flipY:
	btst	#2,(a0)		; is the 16x16 to be X-flipped as well?
	bne.s	.flipXY		; if it is, branch
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
;ProcessAndWriteBlock2_FlipXY:
.flipXY:
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
; End of function ProcessAndWriteBlock_Vertical


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_E1FA: ProcessAndWriteBlock2_2P:
ProcessAndWriteBlock_DoubleResolution_Vertical:
	or.w	d2,d0
	swap	d0
	btst	#3,(a0)
	bne.s	.flipY
	btst	#2,(a0)
	bne.s	.flipX
	move.l	d0,(a5)
	move.l	(a1)+,(a6)
	rts
; ===========================================================================
; loc_E210:
.flipX:
	move.l	d0,(a5)
	move.l	(a1)+,d3
	eori.l	#(flip_x<<16)|flip_x,d3
	swap	d3
	move.l	d3,(a6)
	rts
; ===========================================================================
; loc_E220:
.flipY:
	btst	#2,(a0)
	bne.s	.flipXY
	move.l	d0,(a5)
	move.l	(a1)+,d3
	eori.l	#(flip_y<<16)|flip_y,d3
	move.l	d3,(a6)
	rts
; ===========================================================================
; loc_E234:
.flipXY:
	move.l	d0,(a5)
	move.l	(a1)+,d3
	eori.l	#((flip_x|flip_y)<<16)|flip_x|flip_y,d3
	swap	d3
	move.l	d3,(a6)
	rts
; End of function ProcessAndWriteBlock_DoubleResolution_Vertical


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E244: GetBlockPtr:
GetBlock:
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
; End of function GetBlock


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E286: Calc_VRAM_Pos: CalcBlockVRAMPos:
CalculateVRAMAddressOfBlockForPlayer1:
	add.w	(a3),d5		; add X pos
; CalcBlockVRAMPos2:
.AbsoluteX:
	tst.w	(Two_player_mode).w
	bne.s	.AbsoluteX_DoubleResolution
	add.w	4(a3),d4	; add Y pos
; CalcBlockVRAMPos_NoCamera:
.AbsoluteXAbsoluteY:
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
; loc_E2A8: CalcBlockVRAMPos_2P:
.AbsoluteX_DoubleResolution:
	add.w	4(a3),d4
; loc_E2AC: CalcBlockVRAMPos_2P_NoCamera:
.AbsoluteXAbsoluteY_DoubleResolution:
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
; End of function CalculateVRAMAddressOfBlockForPlayer1


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;loc_E2C2: CalcBlockVRAMPosB:
CalculateVRAMAddressOfBlockForPlayer2:
	tst.w	(Two_player_mode).w
	bne.s	.doubleResolution

;.regularResolution:
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
; This subroutine was in Sonic 1 unused and works by swapping the bottom portion
; of the background's nametable with that of the window plane. This allowed for a
; third scrolling layer (used in the Tokyo Toy Show '90 demo), at the cost of the
; bottom of the background appearing blank.
; Now, it is instead used to draw the second player's foreground.
.doubleResolution:
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
; End of function CalculateVRAMAddressOfBlockForPlayer2

; ===========================================================================
; Loads the background in its initial state into VRAM (plane B). Especially
; important for levels that never re-load the background dynamically.
; See also: DrawLevelTitleCard (loads plane A)
;loc_E300:
DrawInitialBG:
	lea	(VDP_control_port).l,a5
	lea	(VDP_data_port).l,a6
	lea	(Camera_BG_X_pos).w,a3
	lea	(Level_Layout+$80).w,a4	; background
	move.w	#vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE)>>16,d2
    if fixBugs
	; The purpose of this function is to dynamically load a portion of
	; the background, based on where the BG camera is pointing. This
	; makes plenty of sense for levels that dynamically load their
	; background to Plane B. However, not all levels do this: some are
	; content with just loading their entire (small) background to
	; Plane B and leaving it there, untouched.
	; Unfortunately, that does not mesh well with this function: if the
	; camera is too high or too low, then only part of the background
	; will be properly loaded. This bug most visibly manifests itself in
	; Casino Night Zone Act 1, where the background abruptly cuts off at
	; the bottom.
	; To work around this, an ugly hack was added, to cause the function
	; to load a portion of the background 16 pixels lower than normal.
	; However, this hack applies to both Act 1 AND Act 2, resulting in
	; Act 2's background being cut off at the top.
	; Sonic 3 & Knuckles fixed this problem for good by giving each zone
	; its own background initialisation function (see 'LevelSetup' in the
	; Sonic & Knuckles disassembly). This fix won't go quite that far,
	; but it will give these 'static' backgrounds their own
	; initialisation logic, much like two player Mystic Cave Zone does.
	move.b	(Current_Zone).w,d0
	cmpi.b	#emerald_hill_zone,d0
	beq.w	DrawInitialBG_LoadWholeBackground_512x256
	cmpi.b	#casino_night_zone,d0
	beq.w	DrawInitialBG_LoadWholeBackground_512x256
	cmpi.b	#hill_top_zone,d0
	beq.w	DrawInitialBG_LoadWholeBackground_512x256
    else
	; This is a nasty hack to work around the bug described above.
	moveq	#0,d4
	cmpi.b	#casino_night_zone,(Current_Zone).w
	beq.w	++
    endif
	tst.w	(Two_player_mode).w
	beq.w	+
	cmpi.b	#mystic_cave_zone,(Current_Zone).w
	beq.w	DrawInitialBG_LoadWholeBackground_512x512
+
	moveq	#-block_height,d4
+
	moveq	#gameplay_plane_height/block_height-1,d6 ; Height of plane in blocks minus 1.
-	movem.l	d4-d6,-(sp)
	moveq	#0,d5
	move.w	d4,d1
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	d1,d4
	moveq	#0,d5
	moveq	#gameplay_plane_width/block_width-1,d6 ; Width of plane in blocks minus 1.
	move	#$2700,sr
	bsr.w	DrawBlockRow_CustomWidth
	move	#$2300,sr
	movem.l	(sp)+,d4-d6
	addi.w	#block_height,d4
	dbf	d6,-

	rts
; ===========================================================================
	; Dead code for initialising the second player's portion of Plane B.
	; This was used in earlier builds before title cards were implemented.
	moveq	#-block_height,d4

	moveq	#gameplay_plane_height/block_height-1,d6 ; Height of plane in blocks minus 1.
-	movem.l	d4-d6,-(sp)
	moveq	#0,d5
	move.w	d4,d1
	bsr.w	CalculateVRAMAddressOfBlockForPlayer2
	move.w	d1,d4
	moveq	#0,d5
	moveq	#gameplay_plane_width/block_width-1,d6 ; Width of plane in blocks minus 1.
	move	#$2700,sr
	bsr.w	DrawBlockRow_CustomWidth
	move	#$2300,sr
	movem.l	(sp)+,d4-d6
	addi.w	#block_height,d4
	dbf	d6,-

	rts
; ===========================================================================
; loc_E396:
DrawInitialBG_LoadWholeBackground_512x512:
	; Mystic Cave Zone loads its entire background at once in two player
	; mode, since the plane is big enough to fit it, unlike in one player
	; mode (512x512 instead of 512x256).
	moveq	#0,d4	; Absolute plane Y coordinate.

	moveq	#gameplay_plane_height_2p/block_height-1,d6 ; Height of plane in blocks minus 1.
-	movem.l	d4-d6,-(sp)
	moveq	#0,d5
	move.w	d4,d1
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1.AbsoluteXAbsoluteY_DoubleResolution
	move.w	d1,d4
	moveq	#0,d5
	moveq	#gameplay_plane_width/block_width-1,d6 ; Width of plane in blocks minus 1.
	move	#$2700,sr
	bsr.w	DrawBlockRow.AbsoluteXAbsoluteYCustomWidth
	move	#$2300,sr
	movem.l	(sp)+,d4-d6
	addi.w	#block_height,d4
	dbf	d6,-

	rts
; ===========================================================================
    if fixBugs
DrawInitialBG_LoadWholeBackground_512x256:
	moveq	#0,d4	; Absolute plane Y coordinate.

	moveq	#gameplay_plane_height/block_height-1,d6 ; Height of plane in blocks minus 1.
-	movem.l	d4-d6,-(sp)
	moveq	#0,d5
	move.w	d4,d1
	; This is just a fancy efficient way of doing 'if true then call this, else call that'.
	pea	+(pc)
	tst.w	(Two_player_mode).w
	beq.w	CalculateVRAMAddressOfBlockForPlayer1.AbsoluteXAbsoluteY
	bra.w	CalculateVRAMAddressOfBlockForPlayer1.AbsoluteXAbsoluteY_DoubleResolution
+
	move.w	d1,d4
	moveq	#0,d5
	moveq	#gameplay_plane_width/block_width-1,d6 ; Width of plane in blocks minus 1.
	move	#$2700,sr
	bsr.w	DrawBlockRow.AbsoluteXAbsoluteYCustomWidth
	move	#$2300,sr
	movem.l	(sp)+,d4-d6
	addi.w	#block_height,d4
	dbf	d6,-

	rts
    endif
; ===========================================================================
