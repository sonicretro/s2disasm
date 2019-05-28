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