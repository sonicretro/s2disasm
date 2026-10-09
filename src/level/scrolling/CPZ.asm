; loc_D27C:
SwScrl_CPZ:
	; Update scroll flags, to dynamically load more of the background as
	; the player moves around.
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#5,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#6,d5
	bsr.w	SetHorizVertiScrollFlagsBG

	; Ditto.
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#7,d4
	moveq	#scroll_flag_advanced_bg2_left,d6
	bsr.w	SetHorizScrollFlagsBG2

	; Update 'Camera_BG2_Y_pos'.
	move.w	(Camera_BG_Y_pos).w,d0
	move.w	d0,(Camera_BG2_Y_pos).w

	; Update the background's vertical scrolling.
	move.w	d0,(Vscroll_Factor_BG).w

	; Merge BG1's and BG2's scroll flags into BG3...
	move.b	(Scroll_flags_BG).w,d0
	or.b	(Scroll_flags_BG2).w,d0
	move.b	d0,(Scroll_flags_BG3).w

	; ...then clear BG1's and BG2's scroll flags.
	; This zone basically uses its own dynamic background loader.
	clr.b	(Scroll_flags_BG).w
	clr.b	(Scroll_flags_BG2).w

	; Every 8 frames, subtract 1 from 'TempArray_LayerDef'.
	; This animates the 'special line block'.
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	lea	(CPZ_CameraSections+1).l,a0
	move.w	(Camera_BG_Y_pos).w,d0
	move.w	d0,d2
	andi.w	#$3F0,d0
	lsr.w	#4,d0
	lea	(a0,d0.w),a0	; 'a0' goes completely unused after this...
	move.w	d0,d4
	; 'd4' now holds the index of the current line block.

	lea	(Horiz_Scroll_Buf).w,a1

    if fixBugs
	move.w	#screen_height/block_height-1,d1
    else
	; The '+1' is so that, if one block is partially-offscreen at the
	; top, then another will fill the gap at the bottom of the screen.
	; This causes 'Horiz_Scroll_Buf' to overflow due to a lack of
	; bounds-checking. This was likely a deliberate optimisation. Still,
	; it's possible to avoid this without any performance penalty with a
	; little extra code. See below.
	move.w	#screen_height/block_height+1-1,d1
    endif

	; Set up the foreground part of the horizontal scroll value.
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0

	; Get the offset into the starting block.
	andi.w	#$F,d2

    if fixBugs
	; See above.

	; Back this up, because we'll need it later.
	move.w	d2,d5
	; If this is 0, then we won't need to do an extra block, so skip
	; ahead.
	beq.s	.doLineBlocks
	; Process the first set of line blocks.
	bsr.s	.doLineBlocks

	; Do one last line block.
	moveq	#1-1,d1

	; Invert 'd2' to get the number of lines in the first block that we
	; skipped, so that we can do them now.
	move.w	#$10,d2
	sub.w	d5,d2

	; Process the final line block.
.doLineBlocks:
    endif

	; Behaviour depends on which line block we're processing.
	move.w	(Camera_BG_X_pos).w,d0
	cmpi.b	#18,d4
	beq.s	.doPartialSpecialLineBlock
	blo.s	+
	move.w	(Camera_BG2_X_pos).w,d0
+
	neg.w	d0

	add.w	d2,d2
	jmp	.doPartialLineBlock(pc,d2.w)
; ===========================================================================

.doFullLineBlock:
	; Behaviour depends on which line block we're processing.
	move.w	(Camera_BG_X_pos).w,d0
	cmpi.b	#18,d4
	beq.s	.doFullSpecialLineBlock
	blo.s	+
	move.w	(Camera_BG2_X_pos).w,d0
+
	neg.w	d0

	; This works like a Duff's Device.
.doPartialLineBlock:
    rept 16
	move.l	d0,(a1)+
    endm
	addq.b	#1,d4	; Next line block.
	dbf	d1,.doFullLineBlock
	rts
; ===========================================================================
; loc_D34A:
.doPartialSpecialLineBlock:
	; Invert the offset into the starting block to obtain the number of
	; lines to output minus 1.
	move.w	#$F,d0
	sub.w	d2,d0
	move.w	d0,d2
	bra.s	+
; ===========================================================================
.doFullSpecialLineBlock:
	; A block is 16 lines.
	move.w	#16-1,d2
+
	; The special block row has a ripple effect applied to it.
	move.w	(Camera_BG_X_pos).w,d3
	neg.w	d3
	move.w	(TempArray_LayerDef).w,d0
	andi.w	#$1F,d0
	lea_	SwScrl_RippleData,a2
	lea	(a2,d0.w),a2

.doLine:
	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d2,.doLine

	addq.b	#1,d4	; Next block.
	dbf	d1,.doFullLineBlock
	rts
; ===========================================================================
