; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_5604
SSTrack_Draw:
	moveq	#0,d0
	move.b	(SSTrack_drawing_index).w,d0					; Get drawing position
	cmpi.b	#4,d0								; Is it time to draw a new frame?
	bge.w	SSTrackSetOrientation						; Branch if not
	add.w	d0,d0								; Multiply by 4
	add.w	d0,d0
	bne.w	SSTrack_BeginDraw						; Branch if we don't need to start a new segment
	move.l	(SSTrack_last_mappings).w,(SSTrack_last_mappings_copy).w	; Save last mappings
	move.b	(SSTrack_mapping_frame).w,(SSTrack_last_mapping_frame).w	; Save last frame
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	move.b	(SpecialStage_CurrentSegment).w,d1				; Get current segment ID
	move.b	(SSTrack_anim_frame).w,d2					; Get current frame
	movea.l	(SS_CurrentLevelLayout).w,a1					; Pointer to level layout
	move.b	(a1,d1.w),d3							; Get segment geometry type
	andi.b	#$7F,d3								; Strip flip flag
	move.b	d3,(SSTrack_anim).w						; Set this as new animation
	move.w	d3,d1								; Copy to d1
	add.w	d3,d3								; Turn it into an index
	lea	(Ani_SpecialStageTrack).l,a1					; Animation table
	adda.w	(a1,d3.w),a1							; Add offset so a1 points to animation data
	adda.w	d2,a1								; Offset into current animation frame
	moveq	#0,d4
	move.b	(a1),d4								; d4 = animation frame to draw
	move.b	d4,(SSTrack_mapping_frame).w					; Save to RAM
	lsl.w	#2,d4
	lea	(Map_SpecialStageTrack).l,a1					; Mappings table
	movea.l	(a1,d4.w),a0							; a0 = pointer to mappings for current track frame
	movea.l	a0,a1								; Copy to a1
	moveq	#0,d2
	move.b	(a0)+,d2							; Skip the first 2 bytes
	move.b	(a0)+,d2							; Why not 'addq.l	#2,a0'?
	move.b	(a0)+,d2							; Get byte
	lsl.w	#8,d2								; Shift it up to be the high byte of a word
	move.b	(a0)+,d2							; Read another byte; why not 'move.w	(a0)+,d2'?
	addq.w	#4,d2								; Add 4
	adda.w	d2,a1								; Use as offset from start of file
	movea.l	a1,a2								; Save to a2
	moveq	#0,d2
	move.b	(a1)+,d2							; Skip the first 2 bytes
	move.b	(a1)+,d2							; Why not 'addq.l	#2,a1'?
	move.b	(a1)+,d2							; Get byte
	lsl.w	#8,d2								; Shift it up to be the high byte of a word
	move.b	(a1)+,d2							; Read another byte; why not 'move.w	(a1)+,d2'?
	addq.w	#4,d2								; Add 4
	adda.w	d2,a2								; Use as offset from previous offset
	move.b	(a2)+,d2							; Ignore the first 3 bytes
	move.b	(a2)+,d2							; Why not 'addq.l	#3,a2'?
	move.b	(a2)+,d2
	move.b	(a2)+,d2							; Get byte (unused)
	move.l	a0,(SSTrack_mappings_bitflags).w				; Save pointer to bit flags mappings
	move.l	a0,(SSTrack_last_mappings).w					; ...twice
	move.l	a1,(SSTrack_mappings_uncompressed).w				; Save pointer to uncompressed mappings
	move.l	a2,(SSTrack_mappings_RLE).w					; Save pointer to RLE mappings
	lea_	Ani_SSTrack_Len,a4						; Pointer to animation lengths
	move.b	(a4,d1.w),d2							; Get length of current animation
	move.b	(SSTrack_anim_frame).w,(SSTrack_last_anim_frame).w		; Save old frame
	addi_.b	#1,(SSTrack_anim_frame).w					; Increment current frame
	cmp.b	(SSTrack_anim_frame).w,d2					; Compare with animation length
	bne.s	SSTrack_BeginDraw						; If not equal, branch
	move.b	#0,(SSTrack_anim_frame).w					; Reset to start
	move.b	(SpecialStage_CurrentSegment).w,(SpecialStage_LastSegment).w	; Save old segment
	addi_.b	#1,(SpecialStage_CurrentSegment).w				; Increment current segment

;loc_56D2
SSTrack_BeginDraw:
	tst.b	(SS_Alternate_PNT).w						; Are we using the alternate PNT?
	beq.s	+								; Branch if not
	addi.w	#$10,d0								; Change where we will be drawing
+
	lea_	SSTrackPNTCommands,a3						; Table of VRAM commands
	movea.l	(a3,d0.w),a3							; Get command to set destination in VRAM for current frame
	move.l	a3,(VDP_control_port).l						; Send it to VDP
	lea	(VDP_data_port).l,a6
	bsr.w	SSTrackSetOrientation						; Set oriantation flags
	movea.l	(SSTrack_mappings_bitflags).w,a0				; Get pointer to bit flags mappings
	movea.l	(SSTrack_mappings_uncompressed).w,a1				; Get pointer to uncompressed mappings
	movea.l	(SSTrack_mappings_RLE).w,a2					; Get pointer to RLE mappings
	lea	(SSDrawRegBuffer).w,a3						; Pointer to register buffer from last draw
	movem.w	(a3)+,d2-d7							; Restore registers from previous call (or set them to zero)
	lea	(SSPNT_UncLUT).l,a3						; Pattern name list for drawing routines
	lea	(SSPNT_RLELUT).l,a4						; RLE-encoded pattern name list for drawing routines
	movea.w	#-8,a5								; Initialize loop counter: draws 7 lines
	moveq	#0,d0
	tst.b	(SSTrack_Orientation).w						; Is the current segment flipped?
	bne.w	SSTrackDrawLineFlipLoop						; Branch if yes

;loc_5722
SSTrackDrawLineLoop:
	adda_.w	#1,a5								; Increment loop counter
	cmpa.w	#0,a5								; Have all 7 lines been drawn?
	beq.w	SSTrackDraw_return						; If yes, return

;loc_572E
SSTrackDrawLoop_Inner:
	moveq	#0,d1
	subq.w	#1,d7								; Subtract 1 from bit counter
	bpl.s	+								; Branch if we still have bits we can use
	move.b	(a0)+,d6							; Get a new byte from bit flags
	moveq	#7,d7								; We now have 8 fresh new bits
+
	add.b	d6,d6								; Do we have to use RLE compression?
	bcc.s	SSTrackDrawRLE							; Branch if yes
	subq.b	#1,d5								; Subtract 1 from bit counter
	bpl.s	+								; Branch if we still have bits we can use
	move.b	(a1)+,d4							; Get a new byte from uncompressed mappings pointer
	moveq	#7,d5								; We now have 8 fresh new bits
+
	add.b	d4,d4								; Do we need a 10-bit index?
	bcc.s	+								; Branch if not
	moveq	#$A,d0								; d0 = 10 bits
	sub.b	d5,d0								; d0 = 10 - d5
	subq.b	#3,d0								; d0 =  7 - d5; why not shorten it to 'moveq	#7,d0 \n	sub.b	d5,d0'?
	add.w	d0,d0								; Convert into table index
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
	moveq	#6,d0								; d0 = 6
	sub.b	d5,d0								; d0 = 6 - d5
	addq.b	#1,d0								; d0 = 7 - d5; why not shorten it to 'moveq	#7,d0 \n	sub.b	d5,d0'?
	add.w	d0,d0								; Convert into table index
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
	subq.b	#1,d3								; Subtract 1 from bit counter
	bpl.s	++								; Branch if we still have bits we can use
	move.b	(a2)+,d2							; Get a new byte from RLE mappings pointer
	cmpi.b	#-1,d2								; Is d2 equal to -1?
	bne.s	+								; Branch if not
	moveq	#0,d3								; Set bit counter to zero
	bra.w	SSTrackDrawLineLoop
; ===========================================================================
+
	moveq	#7,d3								; We now have 8 fresh new bits
+
	add.b	d2,d2								; Do we need a 7-bit index?
	bcc.s	+								; Branch if not
	moveq	#7,d0								; d0 = 7
	sub.b	d3,d0								; d0 = 10 - d3
	add.b	d0,d0								; Convert into table index
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
	moveq	#6,d0								; d0 = 6
	sub.b	d3,d0								; d0 = 6 - d3
	addq.b	#1,d0								; d0 = 7 - d3; why not shorten it to 'moveq	#7,d0 \n	sub.b	d3,d0'?
	add.b	d0,d0								; Convert into table index
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
	moveq	#0,d5								; Bit buffer now empty
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
	moveq	#1,d5								; Bit buffer now has 1 bit
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
	moveq	#2,d5								; Bit buffer now has 2 bits
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
	moveq	#3,d5								; Bit buffer now has 3 bits
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
	moveq	#4,d5								; Bit buffer now has 4 bits
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
	moveq	#5,d5								; Bit buffer now has 5 bits
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
	moveq	#2,d5								; Bit buffer now has 2 bits
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
	moveq	#3,d5								; Bit buffer now has 3 bits
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
	moveq	#4,d5								; Bit buffer now has 4 bits
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
	moveq	#5,d5								; Bit buffer now has 5 bits
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
	moveq	#6,d5								; Bit buffer now has 6 bits
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
	moveq	#7,d5								; Bit buffer now has 7 bits
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
	moveq	#0,d5								; Bit buffer now empty
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
	moveq	#1,d5								; Bit buffer now has 1 bit
	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================
;loc_5A34
SSTrackDrawRLE_Read7_Got0:
	; Reads 7 bits from RLE-compressed mappings, 0 bits in bit buffer
	move.b	(a2)+,d2
	ror.b	#1,d2
	move.b	d2,d0
	andi.w	#$7F,d0
	moveq	#1,d3								; Bit buffer now has 1 bit
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
	moveq	#2,d3								; Bit buffer now has 2 bits
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
	moveq	#3,d3								; Bit buffer now has 3 bits
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
	moveq	#4,d3								; Bit buffer now has 4 bits
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
	moveq	#5,d3								; Bit buffer now has 5 bits
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
	moveq	#6,d3								; Bit buffer now has 6 bits
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
	moveq	#7,d3								; Bit buffer now has 7 bits
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
	moveq	#0,d3								; Bit buffer now empty
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
	moveq	#2,d3								; Bit buffer now has 2 bits
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
	moveq	#3,d3								; Bit buffer now has 3 bits
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
	moveq	#4,d3								; Bit buffer now has 4 bits
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
	moveq	#5,d3								; Bit buffer now has 5 bits
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
	moveq	#6,d3								; Bit buffer now has 6 bits
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
	moveq	#7,d3								; Bit buffer now has 7 bits
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
	moveq	#0,d3								; Bit buffer now empty
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
	moveq	#1,d3								; Bit buffer now has 1 bit
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,(a6)
	dbf	d0,-

	bra.w	SSTrackDrawLoop_Inner
; ===========================================================================

;loc_5D58
SSTrackDraw_return:
	cmpi.b	#3,(SSTrack_drawing_index).w					; Have we drawn a full frame?
	beq.s	+								; Branch if yes
	move.l	a0,(SSTrack_mappings_bitflags).w				; Save pointer
	move.l	a1,(SSTrack_mappings_uncompressed).w				; Save pointer
	move.l	a2,(SSTrack_mappings_RLE).w					; Save pointer
	lea	(SSDrawRegBuffer_End).w,a3					; Pointer to end of registry buffer
	movem.w	d2-d7,-(a3)							; Save the bit buffers and bit counters
	rts
; ===========================================================================
+
	lea	(SSDrawRegBuffer).w,a2						; Pointer to registry buffer
	moveq	#0,d0
    rept 6
	move.w	d0,(a2)+							; Clear bit buffers and bit counters
    endm
	rts
; ===========================================================================
