; ---------------------------------------------------------------------------
; NEMESIS DECOMPRESSOR

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
; input: a4 = starting address of destination
; sub_14F0: NemDecB:
NemDecToRAM:
	movem.l	d0-a1/a3-a5,-(sp)
	lea	(NemDec_WriteAndAdvance).l,a3 ; advance to the next location after each write


; sub_14FA:
NemDecMain:
	lea	(Decomp_Buffer).w,a1
	move.w	(a0)+,d2
	lsl.w	#1,d2
	bcc.s	+
	adda.w	#NemDec_WriteAndStay_XOR-NemDec_WriteAndStay,a3
+	lsl.w	#2,d2
	movea.w	d2,a5
	moveq	#8,d3
	moveq	#0,d2
	moveq	#0,d4
	bsr.w	NemDecPrepare
	move.b	(a0)+,d5
	asl.w	#8,d5
	move.b	(a0)+,d5
	move.w	#$10,d6
	bsr.s	NemDecRun
	movem.l	(sp)+,d0-a1/a3-a5
	rts
; End of function NemDec


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; part of the Nemesis decompressor
; sub_1528:
NemDecRun:
	move.w	d6,d7
	subq.w	#8,d7
	move.w	d5,d1
	lsr.w	d7,d1
	cmpi.b	#-4,d1
	bhs.s	loc_1574
	andi.w	#$FF,d1
	add.w	d1,d1
	move.b	(a1,d1.w),d0
	ext.w	d0
	sub.w	d0,d6
	cmpi.w	#9,d6
	bhs.s	+
	addq.w	#8,d6
	asl.w	#8,d5
	move.b	(a0)+,d5
+	move.b	1(a1,d1.w),d1
	move.w	d1,d0
	andi.w	#$F,d1
	andi.w	#$F0,d0

loc_155E:
	lsr.w	#4,d0

loc_1560:
	lsl.l	#4,d4
	or.b	d1,d4
	subq.w	#1,d3
	bne.s	NemDec_WriteIter_Part2
	jmp	(a3) ; dynamic jump! to NemDec_WriteAndStay, NemDec_WriteAndAdvance, NemDec_WriteAndStay_XOR, or NemDec_WriteAndAdvance_XOR
; ===========================================================================
; loc_156A:
NemDec_WriteIter:
	moveq	#0,d4
	moveq	#8,d3
; loc_156E:
NemDec_WriteIter_Part2:
	dbf	d0,loc_1560
	bra.s	NemDecRun
; ===========================================================================

loc_1574:
	subq.w	#6,d6
	cmpi.w	#9,d6
	bhs.s	+
	addq.w	#8,d6
	asl.w	#8,d5
	move.b	(a0)+,d5
+
	subq.w	#7,d6
	move.w	d5,d1
	lsr.w	d6,d1
	move.w	d1,d0
	andi.w	#$F,d1
	andi.w	#$70,d0
	cmpi.w	#9,d6
	bhs.s	loc_155E
	addq.w	#8,d6
	asl.w	#8,d5
	move.b	(a0)+,d5
	bra.s	loc_155E
; End of function NemDecRun

; ===========================================================================
; loc_15A0:
NemDec_WriteAndStay:
	move.l	d4,(a4)
	subq.w	#1,a5
	move.w	a5,d4
	bne.s	NemDec_WriteIter
	rts
; ---------------------------------------------------------------------------
; loc_15AA:
NemDec_WriteAndStay_XOR:
	eor.l	d4,d2
	move.l	d2,(a4)
	subq.w	#1,a5
	move.w	a5,d4
	bne.s	NemDec_WriteIter
	rts
; ===========================================================================
; loc_15B6:
NemDec_WriteAndAdvance:
	move.l	d4,(a4)+
	subq.w	#1,a5
	move.w	a5,d4
	bne.s	NemDec_WriteIter
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
	bne.s	NemDec_WriteIter
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Part of the Nemesis decompressor

; sub_15CC:
NemDecPrepare:
	move.b	(a0)+,d0

-	cmpi.b	#$FF,d0
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+	move.w	d0,d7

loc_15D8:
	move.b	(a0)+,d0
	cmpi.b	#$80,d0
	bhs.s	-

	move.b	d0,d1
	andi.w	#$F,d7
	andi.w	#$70,d1
	or.w	d1,d7
	andi.w	#$F,d0
	move.b	d0,d1
	lsl.w	#8,d1
	or.w	d1,d7
	moveq	#8,d1
	sub.w	d0,d1
	bne.s	loc_1606
	move.b	(a0)+,d0
	add.w	d0,d0
	move.w	d7,(a1,d0.w)
	bra.s	loc_15D8
; ---------------------------------------------------------------------------
loc_1606:
	move.b	(a0)+,d0
	lsl.w	d1,d0
	add.w	d0,d0
	moveq	#1,d5
	lsl.w	d1,d5
	subq.w	#1,d5

-	move.w	d7,(a1,d0.w)
	addq.w	#2,d0
	dbf	d5,-

	bra.s	loc_15D8
; End of function NemDecPrepare