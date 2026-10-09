;loc_5D8A
SSTrackDrawLineFlipLoop:
	adda_.w	#1,a5								; Increment loop counter
	cmpa.w	#0,a5								; Have all 8 lines been drawn?
	beq.w	SSTrackDraw_return						; If yes, return
	lea	(PNT_Buffer).w,a6						; Destination buffer
	swap	d0								; High word starts at 0
	addi.w	#$100,d0							; Adding $100 means seek to end of current line/start of next line
	andi.w	#$F00,d0							; Keep to confines
	adda.w	d0,a6								; Seek to end of current line
	swap	d0								; Leaves the low word of d0 free for use

;loc_5DA8
SSTrackDrawFlipLoop_Inner:
	moveq	#0,d1
	subq.w	#1,d7								; Subtract 1 from bit counter
	bpl.s	+								; Branch if we still have bits we can use
	move.b	(a0)+,d6							; Get a new byte from bit flags
	moveq	#7,d7								; We now have 8 fresh new bits
+
	add.b	d6,d6								; Do we have to use RLE compression?
	bcc.s	SSTrackDrawFlipRLE						; Branch if yes
	subq.b	#1,d5								; Subtract 1 from bit counter
	bpl.s	+								; Branch if we still have bits we can use
	move.b	(a1)+,d4							; Get a new byte from uncompressed mappings pointer
	moveq	#7,d5								; We now have 8 fresh new bits
+
	add.b	d4,d4								; Do we need a 10-bit index?
	bcc.s	+								; Branch if not
	move.w	#$A,d0								; d0 = 10 bits
	sub.b	d5,d0								; d0 = 10 - d5
	subq.b	#3,d0								; d0 =  7 - d5; why not shorten it to 'moveq	#7,d0 \n	sub.b	d5,d0'?
	add.w	d0,d0								; Convert into table index
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
	move.w	#6,d0								; d0 = 6
	sub.b	d5,d0								; d0 = 6 - d5
	addq.b	#1,d0								; d0 = 7 - d5; why not shorten it to 'moveq	#7,d0 \n	sub.b	d5,d0'?
	add.w	d0,d0								; Convert into table index
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
	subq.b	#1,d3								; Subtract 1 from bit counter
	bpl.s	++								; Branch if we still have bits we can use
	move.b	(a2)+,d2							; Get a new byte from RLE mappings pointer
	cmpi.b	#-1,d2								; Is d2 equal to -1?
	bne.s	+								; Branch if not
	moveq	#0,d3								; Set bit counter to zero
	bra.w	SSTrackDrawLineFlipLoop
; ===========================================================================
+
	moveq	#7,d3								; We now have 8 fresh new bits
+
	add.b	d2,d2								; Do we need a 7-bit index?
	bcc.s	+								; Branch if not
	move.w	#7,d0								; d0 = 7
	sub.b	d3,d0								; d0 = 10 - d3
	add.b	d0,d0								; Convert into table index
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
	move.w	#6,d0								; d0 = 6
	sub.b	d3,d0								; d0 = 6 - d3
	addq.b	#1,d0								; d0 = 7 - d3; why not shorten it to 'moveq	#7,d0 \n	sub.b	d3,d0'?
	add.b	d0,d0								; Convert into table index
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
	moveq	#6,d5								; Bit buffer now has 6 bits
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
	moveq	#7,d5								; Bit buffer now has 7 bits
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
	moveq	#0,d5								; Bit buffer now empty
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
	moveq	#1,d5								; Bit buffer now has 1 bit
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
	moveq	#2,d5								; Bit buffer now has 2 bits
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
	moveq	#3,d5								; Bit buffer now has 3 bits
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
	moveq	#4,d5								; Bit buffer now has 4 bits
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
	moveq	#5,d5								; Bit buffer now has 5 bits
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
	moveq	#2,d5								; Bit buffer now has 2 bits
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
	moveq	#3,d5								; Bit buffer now has 3 bits
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
	moveq	#4,d5								; Bit buffer now has 4 bits
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
	moveq	#5,d5								; Bit buffer now has 5 bits
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
	moveq	#6,d5								; Bit buffer now has 6 bits
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
	moveq	#7,d5								; Bit buffer now has 7 bits
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
	moveq	#0,d5								; Bit buffer now empty
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
	moveq	#1,d5								; Bit buffer now has 1 bit
	bra.w	SSTrackDrawFlipLoop_Inner
; ===========================================================================
;loc_60B8
SSTrackDrawFlipRLE_Read7_Got0:
	; Reads 7 bits from RLE-compressed mappings, 0 bits in bit buffer
	move.b	(a2)+,d2
	ror.b	#1,d2
	move.b	d2,d0
	andi.w	#$7F,d0
	moveq	#1,d3								; Bit buffer now has 1 bit
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
	moveq	#2,d3								; Bit buffer now has 2 bits
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
	moveq	#3,d3								; Bit buffer now has 3 bits
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
	moveq	#4,d3								; Bit buffer now has 4 bits
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
	moveq	#5,d3								; Bit buffer now has 5 bits
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
	moveq	#6,d3								; Bit buffer now has 6 bits
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
	moveq	#7,d3								; Bit buffer now has 7 bits
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
	moveq	#0,d3								; Bit buffer now empty
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
	moveq	#2,d3								; Bit buffer now has 2 bits
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
	moveq	#3,d3								; Bit buffer now has 3 bits
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
	moveq	#4,d3								; Bit buffer now has 4 bits
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
	moveq	#5,d3								; Bit buffer now has 5 bits
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
	moveq	#6,d3								; Bit buffer now has 6 bits
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
	moveq	#7,d3								; Bit buffer now has 7 bits
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
	moveq	#0,d3								; Bit buffer now empty
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
	moveq	#1,d3								; Bit buffer now has 1 bit
	move.w	(a4,d0.w),d1
	move.w	2(a4,d0.w),d0
	ori.w	#palette_line_3|high_priority,d1

-	move.w	d1,-(a6)
	dbf	d0,-

	bra.w	SSTrackDrawFlipLoop_Inner

; ===========================================================================
