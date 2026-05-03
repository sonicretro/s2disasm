; ---------------------------------------------------------------------------
; START OF NEMESIS DECOMPRESSOR

; For format explanation see http://info.sonicretro.org/Nemesis_compression
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Nemesis decompression to VRAM
; sub_14DE: NemDecA:
NemDec:
	movem.l	d0-a1/a3-a5,-(sp)
	lea	(NemDec_WriteAndStay).l,a3 ; write all data to the same location
	lea	(VDP_data_port).l,a4	   ; specifically, to the VDP data port
	bra.s	NemDecMain

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Nemesis decompression to RAM
; input: a0 = art address, a4 = starting address of destination
; sub_14F0: NemDecB:
NemDecToRAM:
	movem.l	d0-a1/a3-a5,-(sp)
	lea	(NemDec_WriteAndAdvance).l,a3 ; advance to the next location after each write


; sub_14FA:
NemDecMain:
	lea	(Decomp_Buffer).w,a1
	move.w	(a0)+,d2	; get number of patterns

	lsl.w	#1,d2
	bcc.s	.noXORMode

	adda.w	#NemDec_WriteAndStay_XOR-NemDec_WriteAndStay,a3	; file uses XOR mode if sign bit isn't set

.noXORMode:
	lsl.w	#2,d2	; get number of 8-pixel rows in the uncompressed data
	movea.w	d2,a5	; (stored in a5 because there are no spare data registers)
	moveq	#8,d3	; a pattern row contains 8 pixels
	moveq	#0,d2
	moveq	#0,d4
	bsr.w	NemDecPrepare
	move.b	(a0)+,d5	; first byte fetch of compressed data
	asl.w	#8,d5	; shift up by a byte
	move.b	(a0)+,d5	; second byte fetch of compressed data
	move.w	#$10,d6	; set initial shift value
	bsr.s	NemDecRun
	movem.l	(sp)+,d0-a1/a3-a5
	rts
; End of function NemDec


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; part of the Nemesis decompressor
; sub_1528:
NemDecRun:
	move.w	d6,d7
	subq.w	#8,d7	; get shift value
	move.w	d5,d1
	lsr.w	d7,d1	; makes it so high bit of the code is in 7th bit

	; if the high 6 bits are set, this signifies inline data
	cmpi.b	#%11111100,d1
	bhs.s	NemDec_InlineData

	andi.w	#$FF,d1
	add.w	d1,d1
	move.b	(a1,d1.w),d0	; get code length in bits
	ext.w	d0
	sub.w	d0,d6	; subtracted from the shift value, such that the next time around the next code is read

	; don't read a new byte if there's no need to
	cmpi.w	#9,d6
	bhs.s	.afterNewByteRead

	addq.w	#8,d6
	asl.w	#8,d5
	move.b	(a0)+,d5	; read next byte

.afterNewByteRead:
	move.b	1(a1,d1.w),d1
	move.w	d1,d0
	andi.w	#$F,d1	; get palette index for pixel
	andi.w	#$F0,d0

; loc_155E:
.getRepeatCount:
	lsr.w	#4,d0

; loc_1560:
.writePixel:
	lsl.l	#4,d4	; shift up by a nibble
	or.b	d1,d4	; write pixel

	; loops until an entire 8-pixel row has been written
	subq.w	#1,d3
	bne.s	.writePixelLoopExitCheck

	; writes the row to its destination with the appropriately determined function
	jmp	(a3) ; dynamic jump! to NemDec_WriteAndStay, NemDec_WriteAndAdvance, NemDec_WriteAndStay_XOR, or NemDec_WriteAndAdvance_XOR
; ===========================================================================
; loc_156A:
.writePixelLoopEntry:
	moveq	#0,d4	; reset row
	moveq	#8,d3	; reset nibble counter
; loc_156E:
.writePixelLoopExitCheck:
	dbf	d0,.writePixel
	bra.s	NemDecRun
; ===========================================================================

; loc_1574:
NemDec_InlineData:
	subq.w	#6,d6	; 6 bits needed to signal inline data
	cmpi.w	#9,d6
	bhs.s	+
	addq.w	#8,d6
	asl.w	#8,d5
	move.b	(a0)+,d5
+
	subq.w	#7,d6	; and 7 bits needed for the inline data itself
	move.w	d5,d1
	lsr.w	d6,d1	; the shift makes it so that the low bit of the code is in position 0
	move.w	d1,d0
	andi.w	#$F,d1	; get pixel palette index
	andi.w	#$70,d0	; high nibble is the repeat count for the pixel
	cmpi.w	#9,d6
	bhs.s	NemDecRun.getRepeatCount
	addq.w	#8,d6
	asl.w	#8,d5
	move.b	(a0)+,d5
	bra.s	NemDecRun.getRepeatCount
; End of function NemDecRun

; ===========================================================================
; loc_15A0:
NemDec_WriteAndStay:
	move.l	d4,(a4)	; write 8-pixel row
	subq.w	#1,a5

	; don't return until all 8-pixel rows have been written
	move.w	a5,d4
	bne.s	NemDecRun.writePixelLoopEntry
	rts
; ---------------------------------------------------------------------------
; loc_15AA:
NemDec_WriteAndStay_XOR:
	eor.l	d4,d2	; XOR the previous row with the current one
	move.l	d2,(a4)
	subq.w	#1,a5
	move.w	a5,d4
	bne.s	NemDecRun.writePixelLoopEntry
	rts
; ===========================================================================
; loc_15B6:
NemDec_WriteAndAdvance:
	move.l	d4,(a4)+
	subq.w	#1,a5
	move.w	a5,d4
	bne.s	NemDecRun.writePixelLoopEntry
	rts

    if *-NemDec_WriteAndAdvance > NemDec_WriteAndStay_XOR-NemDec_WriteAndStay
	fatal "the code in NemDec_WriteAndAdvance must not be larger than the code in NemDec_WriteAndStay"
    endif
    org NemDec_WriteAndAdvance+NemDec_WriteAndStay_XOR-NemDec_WriteAndStay

; ---------------------------------------------------------------------------
; loc_15C0:
NemDec_WriteAndAdvance_XOR:
	eor.l	d4,d2
	move.l	d2,(a4)+
	subq.w	#1,a5
	move.w	a5,d4
	bne.s	NemDecRun.writePixelLoopEntry
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Part of the Nemesis decompressor

; sub_15CC:
NemDecPrepare:
	move.b	(a0)+,d0

	; don't return until the end of the code table description has been reached
.checkCodeTableDescriptionEnd:
	cmpi.b	#$FF,d0
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+	move.w	d0,d7

; loc_15D8:
.nextCode:
	move.b	(a0)+,d0	; read next byte
	cmpi.b	#$80,d0	; sign bit being set means a new palette index
	bhs.s	.checkCodeTableDescriptionEnd	; (note: a bmi could have been used instead of a cmpi+bhs)

	move.b	d0,d1
	andi.w	#$F,d7	; get palette index
	andi.w	#$70,d1	; get palette index repeat count
	or.w	d1,d7	; combine the two
	andi.w	#$F,d0	; get the length of the code in bits
	move.b	d0,d1
	lsl.w	#8,d1
	or.w	d1,d7	; combine with palette index and repeat count to form code table entry
	moveq	#8,d1

	; extra processing is needed if the code isn't 8 bits long
	sub.w	d0,d1
	bne.s	.shorterThan8BitCode

	move.b	(a0)+,d0	; get code
	add.w	d0,d0	; each code gets a word-sized entry in the table
	move.w	d7,(a1,d0.w)	; store the entry for the code
	bra.s	.nextCode	; repeat
; ---------------------------------------------------------------------------

; the Nemesis decompressor uses prefix-free codes (no valid code is a prefix of a longer code)
; e.g. if 10 is a valid 2-bit code, 110 is a valid 3-bit code but 100 isn't
; also, when the actual compressed data is processed the high bit of each code is in bit position 7
; so the code needs to be bit-shifted appropriately over here before being used as a code table index
; additionally, the code needs multiple entries in the table because no masking is done during compressed data processing
; so if 11000 is a valid code then all indices of the form 11000XXX need to have the same entry
.shorterThan8BitCode:
	move.b	(a0)+,d0	; get code
	lsl.w	d1,d0	; shift so that the high bit is in the 7th bit
	add.w	d0,d0	; get index into code table
	moveq	#1,d5
	lsl.w	d1,d5
	subq.w	#1,d5	; d5 = 2^d1 - 1

	; store the required number of entries
.shorterThan8BitCodeLoop:
	move.w	d7,(a1,d0.w)
	addq.w	#2,d0
	dbf	d5,.shorterThan8BitCodeLoop

	bra.s	.nextCode
; End of function NemDecPrepare

; ---------------------------------------------------------------------------
; END OF NEMESIS DECOMPRESSOR
; ---------------------------------------------------------------------------
