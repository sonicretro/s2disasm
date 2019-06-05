; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Various subroutines relating to art (I guess?)
; ---------------------------------------------------------------------------
; Subroutine to transfer a plane map to VRAM
; ---------------------------------------------------------------------------

; control register:
;    CD1 CD0 A13 A12 A11 A10 A09 A08     (D31-D24)
;    A07 A06 A05 A04 A03 A02 A01 A00     (D23-D16)
;     ?   ?   ?   ?   ?   ?   ?   ?      (D15-D8)
;    CD5 CD4 CD3 CD2  ?   ?  A15 A14     (D7-D0)
;
;	A00-A15 - address
;	CD0-CD3 - code
;	CD4 - 1 if VRAM copy DMA mode. 0 otherwise.
;	CD5 - DMA operation
;	
;	Bits CD3-CD0:
;	0000 - VRAM read
;	0001 - VRAM write
;	0011 - CRAM write
;	0100 - VSRAM read
;	0101 - VSRAM write
;	1000 - CRAM read
;
; d0 = control register
; d1 = width
; d2 = heigth
; a1 = source address

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_140E: ShowVDPGraphics: PlaneMapToVRAM:
PlaneMapToVRAM_H40:
	lea	(VDP_data_port).l,a6
	move.l	#vdpCommDelta(planeLocH40(0,1)),d4	; $800000
-	move.l	d0,VDP_control_port-VDP_data_port(a6)	; move d0 to VDP_control_port
	move.w	d1,d3
-	move.w	(a1)+,(a6)	; from source address to destination in VDP
	dbf	d3,-		; next tile
	add.l	d4,d0		; increase destination address by $80 (1 line)
	dbf	d2,--		; next line
	rts
; End of function PlaneMapToVRAM_H40

; ---------------------------------------------------------------------------
; Alternate subroutine to transfer a plane map to VRAM
; (used for Special Stage background)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_142E: ShowVDPGraphics2: PlaneMapToVRAM2:
PlaneMapToVRAM_H80_SpecialStage:
	lea	(VDP_data_port).l,a6
	move.l	#vdpCommDelta(planeLocH80(0,1)),d4	; $1000000
-	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d1,d3
-	move.w	(a1)+,(a6)
	dbf	d3,-
	add.l	d4,d0
	dbf	d2,--
	rts
; End of function PlaneMapToVRAM_H80_SpecialStage

; ---------------------------------------------------------------------------
; Subroutine for queueing VDP commands (seems to only queue transfers to VRAM),
; to be issued the next time ProcessDMAQueue is called.
; Can be called a maximum of 18 times before the buffer needs to be cleared
; by issuing the commands (this subroutine DOES check for overflow)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_144E: DMA_68KtoVRAM: QueueCopyToVRAM: QueueVDPCommand: Add_To_DMA_Queue:
QueueDMATransfer:
	movea.l	(VDP_Command_Buffer_Slot).w,a1
	cmpa.w	#VDP_Command_Buffer_Slot,a1
	beq.s	QueueDMATransfer_Done ; return if there's no more room in the buffer

	; piece together some VDP commands and store them for later...
	move.w	#$9300,d0 ; command to specify DMA transfer length & $00FF
	move.b	d3,d0
	move.w	d0,(a1)+ ; store command

	move.w	#$9400,d0 ; command to specify DMA transfer length & $FF00
	lsr.w	#8,d3
	move.b	d3,d0
	move.w	d0,(a1)+ ; store command

	move.w	#$9500,d0 ; command to specify source address & $0001FE
	lsr.l	#1,d1
	move.b	d1,d0
	move.w	d0,(a1)+ ; store command

	move.w	#$9600,d0 ; command to specify source address & $01FE00
	lsr.l	#8,d1
	move.b	d1,d0
	move.w	d0,(a1)+ ; store command

	move.w	#$9700,d0 ; command to specify source address & $FE0000
	lsr.l	#8,d1
	;andi.b	#$7F,d1		; this instruction safely allows source to be in RAM; S3K added this
	move.b	d1,d0
	move.w	d0,(a1)+ ; store command

	andi.l	#$FFFF,d2 ; command to specify destination address and begin DMA
	lsl.l	#2,d2
	lsr.w	#2,d2
	swap	d2
	ori.l	#vdpComm($0000,VRAM,DMA),d2 ; set bits to specify VRAM transfer
	move.l	d2,(a1)+ ; store command

	move.l	a1,(VDP_Command_Buffer_Slot).w ; set the next free slot address
	cmpa.w	#VDP_Command_Buffer_Slot,a1
	beq.s	QueueDMATransfer_Done ; return if there's no more room in the buffer
	move.w	#0,(a1) ; put a stop token at the end of the used part of the buffer
; return_14AA:
QueueDMATransfer_Done:
	rts
; End of function QueueDMATransfer


; ---------------------------------------------------------------------------
; Subroutine for issuing all VDP commands that were queued
; (by earlier calls to QueueDMATransfer)
; Resets the queue when it's done
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_14AC: CopyToVRAM: IssueVDPCommands: Process_DMA: Process_DMA_Queue:
ProcessDMAQueue:
	lea	(VDP_control_port).l,a5
	lea	(VDP_Command_Buffer).w,a1
; loc_14B6:
ProcessDMAQueue_Loop:
	move.w	(a1)+,d0
	beq.s	ProcessDMAQueue_Done ; branch if we reached a stop token
	; issue a set of VDP commands...
	move.w	d0,(a5)		; transfer length
	move.w	(a1)+,(a5)	; transfer length
	move.w	(a1)+,(a5)	; source address
	move.w	(a1)+,(a5)	; source address
	move.w	(a1)+,(a5)	; source address
	move.w	(a1)+,(a5)	; destination
	move.w	(a1)+,(a5)	; destination
	cmpa.w	#VDP_Command_Buffer_Slot,a1
	bne.s	ProcessDMAQueue_Loop ; loop if we haven't reached the end of the buffer
; loc_14CE:
ProcessDMAQueue_Done:
	move.w	#0,(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	rts
; End of function ProcessDMAQueue



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

; ---------------------------------------------------------------------------
; END OF NEMESIS DECOMPRESSOR
; ---------------------------------------------------------------------------



; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; ---------------------------------------------------------------------------
; Subroutine to load pattern load cues (aka to queue pattern load requests)
; ---------------------------------------------------------------------------

; ARGUMENTS
; d0 = index of PLC list (see ArtLoadCues)

; NOTICE: This subroutine does not check for buffer overruns. The programmer
;	  (or hacker) is responsible for making sure that no more than
;	  16 load requests are copied into the buffer.
;    _________DO NOT PUT MORE THAN 16 LOAD REQUESTS IN A LIST!__________
;         (or if you change the size of Plc_Buffer, the limit becomes (Plc_Buffer_Only_End-Plc_Buffer)/6)

; sub_161E: PLCLoad:
LoadPLC:
	movem.l	a1-a2,-(sp)
	lea	(ArtLoadCues).l,a1
	add.w	d0,d0
	move.w	(a1,d0.w),d0
	lea	(a1,d0.w),a1
	lea	(Plc_Buffer).w,a2

-	tst.l	(a2)
	beq.s	+ ; if it's zero, exit this loop
	addq.w	#6,a2
	bra.s	-
+
	move.w	(a1)+,d0
	bmi.s	+ ; if it's negative, skip the next loop

-	move.l	(a1)+,(a2)+
	move.w	(a1)+,(a2)+
	dbf	d0,-
+
	movem.l	(sp)+,a1-a2 ; a1=object
	rts
; End of function LoadPLC


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Queue pattern load requests, but clear the PLQ first

; ARGUMENTS
; d0 = index of PLC list (see ArtLoadCues)

; NOTICE: This subroutine does not check for buffer overruns. The programmer
;	  (or hacker) is responsible for making sure that no more than
;	  16 load requests are copied into the buffer.
;	  _________DO NOT PUT MORE THAN 16 LOAD REQUESTS IN A LIST!__________
;         (or if you change the size of Plc_Buffer, the limit becomes (Plc_Buffer_Only_End-Plc_Buffer)/6)
; sub_1650:
LoadPLC2:
	movem.l	a1-a2,-(sp)
	lea	(ArtLoadCues).l,a1
	add.w	d0,d0
	move.w	(a1,d0.w),d0
	lea	(a1,d0.w),a1
	bsr.s	ClearPLC
	lea	(Plc_Buffer).w,a2
	move.w	(a1)+,d0
	bmi.s	+ ; if it's negative, skip the next loop

-	move.l	(a1)+,(a2)+
	move.w	(a1)+,(a2)+
	dbf	d0,-
+
	movem.l	(sp)+,a1-a2
	rts
; End of function LoadPLC2


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Clear the pattern load queue ($FFF680 - $FFF700)

ClearPLC:
	lea	(Plc_Buffer).w,a2

	moveq	#bytesToLcnt(Plc_Buffer_End-Plc_Buffer),d0
-	clr.l	(a2)+
	dbf	d0,-

	rts
; End of function ClearPLC

; ---------------------------------------------------------------------------
; Subroutine to use graphics listed in a pattern load cue
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_168A:
RunPLC_RAM:
	tst.l	(Plc_Buffer).w
	beq.s	++	; rts
	tst.w	(Plc_Buffer_Reg18).w
	bne.s	++	; rts
	movea.l	(Plc_Buffer).w,a0
	lea_	NemDec_WriteAndStay,a3
	nop
	lea	(Decomp_Buffer).w,a1
	move.w	(a0)+,d2
	bpl.s	+
	adda.w	#NemDec_WriteAndStay_XOR-NemDec_WriteAndStay,a3
+
	andi.w	#$7FFF,d2
	move.w	d2,(Plc_Buffer_Reg18).w
	bsr.w	NemDecPrepare
	move.b	(a0)+,d5
	asl.w	#8,d5
	move.b	(a0)+,d5
	moveq	#$10,d6
	moveq	#0,d0
	move.l	a0,(Plc_Buffer).w
	move.l	a3,(Plc_Buffer_Reg0).w
	move.l	d0,(Plc_Buffer_Reg4).w
	move.l	d0,(Plc_Buffer_Reg8).w
	move.l	d0,(Plc_Buffer_RegC).w
	move.l	d5,(Plc_Buffer_Reg10).w
	move.l	d6,(Plc_Buffer_Reg14).w
+
	rts
; End of function RunPLC_RAM


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Process one PLC from the queue

; sub_16E0:
ProcessDPLC:
	tst.w	(Plc_Buffer_Reg18).w
	beq.w	+	; rts
	move.w	#6,(Plc_Buffer_Reg1A).w
	moveq	#0,d0
	move.w	(Plc_Buffer+4).w,d0
	addi.w	#$C0,(Plc_Buffer+4).w
	bra.s	ProcessDPLC_Main

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Process one PLC from the queue

; loc_16FC:
ProcessDPLC2:
	tst.w	(Plc_Buffer_Reg18).w
	beq.s	+	; rts
	move.w	#3,(Plc_Buffer_Reg1A).w
	moveq	#0,d0
	move.w	(Plc_Buffer+4).w,d0
	addi.w	#$60,(Plc_Buffer+4).w

; loc_1714:
ProcessDPLC_Main:
	lea	(VDP_control_port).l,a4
	lsl.l	#2,d0		; set up target VRAM address
	lsr.w	#2,d0
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d0
	swap	d0
	move.l	d0,(a4)
	subq.w	#4,a4
	movea.l	(Plc_Buffer).w,a0
	movea.l	(Plc_Buffer_Reg0).w,a3
	move.l	(Plc_Buffer_Reg4).w,d0
	move.l	(Plc_Buffer_Reg8).w,d1
	move.l	(Plc_Buffer_RegC).w,d2
	move.l	(Plc_Buffer_Reg10).w,d5
	move.l	(Plc_Buffer_Reg14).w,d6
	lea	(Decomp_Buffer).w,a1

-	movea.w	#8,a5
	bsr.w	NemDec_WriteIter
	subq.w	#1,(Plc_Buffer_Reg18).w
	beq.s	ProcessDPLC_Pop
	subq.w	#1,(Plc_Buffer_Reg1A).w
	bne.s	-

	move.l	a0,(Plc_Buffer).w
	move.l	a3,(Plc_Buffer_Reg0).w
	move.l	d0,(Plc_Buffer_Reg4).w
	move.l	d1,(Plc_Buffer_Reg8).w
	move.l	d2,(Plc_Buffer_RegC).w
	move.l	d5,(Plc_Buffer_Reg10).w
	move.l	d6,(Plc_Buffer_Reg14).w
+
	rts

; ===========================================================================
; pop one request off the buffer so that the next one can be filled

; loc_177A:
ProcessDPLC_Pop:
	lea	(Plc_Buffer).w,a0
	moveq	#bytesToLcnt(Plc_Buffer_Only_End-Plc_Buffer-6),d0
-	move.l	6(a0),(a0)+
	dbf	d0,-
	rts

; End of function ProcessDPLC


; ---------------------------------------------------------------------------
; Subroutine to execute a pattern load cue directly from the ROM
; rather than loading them into the queue first
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

RunPLC_ROM:
	lea	(ArtLoadCues).l,a1
	add.w	d0,d0
	move.w	(a1,d0.w),d0
	lea	(a1,d0.w),a1

	move.w	(a1)+,d1
-	movea.l	(a1)+,a0
	moveq	#0,d0
	move.w	(a1)+,d0
	lsl.l	#2,d0
	lsr.w	#2,d0
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d0
	swap	d0
	move.l	d0,(VDP_control_port).l
	bsr.w	NemDec
	dbf	d1,-

	rts
; End of function RunPLC_ROM

; ---------------------------------------------------------------------------
; Enigma Decompression Algorithm

; ARGUMENTS:
; d0 = starting art tile (added to each 8x8 before writing to destination)
; a0 = source address
; a1 = destination address

; For format explanation see http://info.sonicretro.org/Enigma_compression
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; EniDec_17BC:
EniDec:
	movem.l	d0-d7/a1-a5,-(sp)
	movea.w	d0,a3		; store starting art tile
	move.b	(a0)+,d0
	ext.w	d0
	movea.w	d0,a5		; store first byte, extended to word
	move.b	(a0)+,d4	; store second byte
	lsl.b	#3,d4		; multiply by 8
	movea.w	(a0)+,a2	; store third and fourth byte
	adda.w	a3,a2		; add starting art tile
	movea.w	(a0)+,a4	; store fifth and sixth byte
	adda.w	a3,a4		; add starting art tile
	move.b	(a0)+,d5	; store seventh byte
	asl.w	#8,d5		; shift up by a byte
	move.b	(a0)+,d5	; store eighth byte in lower register byte
	moveq	#16,d6		; 16 bits = 2 bytes

EniDec_Loop:
	moveq	#7,d0		; process 7 bits at a time
	move.w	d6,d7
	sub.w	d0,d7
	move.w	d5,d1
	lsr.w	d7,d1
	andi.w	#$7F,d1		; keep only lower 7 bits
	move.w	d1,d2
	cmpi.w	#$40,d1		; is bit 6 set?
	bhs.s	+		; if it is, branch
	moveq	#6,d0		; if not, process 6 bits instead of 7
	lsr.w	#1,d2		; bitfield now becomes TTSSSS instead of TTTSSSS
+
	bsr.w	EniDec_ChkGetNextByte
	andi.w	#$F,d2	; keep only lower nybble
	lsr.w	#4,d1	; store upper nybble (max value = 7)
	add.w	d1,d1
	jmp	EniDec_JmpTable(pc,d1.w)
; End of function EniDec

; ===========================================================================

EniDec_Sub0:
	move.w	a2,(a1)+	; write to destination
	addq.w	#1,a2		; increment
	dbf	d2,EniDec_Sub0	; repeat
	bra.s	EniDec_Loop
; ===========================================================================

EniDec_Sub4:
	move.w	a4,(a1)+	; write to destination
	dbf	d2,EniDec_Sub4	; repeat
	bra.s	EniDec_Loop
; ===========================================================================

EniDec_Sub8:
	bsr.w	EniDec_GetInlineCopyVal

-	move.w	d1,(a1)+
	dbf	d2,-

	bra.s	EniDec_Loop
; ===========================================================================

EniDec_SubA:
	bsr.w	EniDec_GetInlineCopyVal

-	move.w	d1,(a1)+
	addq.w	#1,d1
	dbf	d2,-

	bra.s	EniDec_Loop
; ===========================================================================

EniDec_SubC:
	bsr.w	EniDec_GetInlineCopyVal

-	move.w	d1,(a1)+
	subq.w	#1,d1
	dbf	d2,-

	bra.s	EniDec_Loop
; ===========================================================================

EniDec_SubE:
	cmpi.w	#$F,d2
	beq.s	EniDec_End

-	bsr.w	EniDec_GetInlineCopyVal
	move.w	d1,(a1)+
	dbf	d2,-

	bra.s	EniDec_Loop
; ===========================================================================
; Enigma_JmpTable:
EniDec_JmpTable:
	bra.s	EniDec_Sub0
	bra.s	EniDec_Sub0
	bra.s	EniDec_Sub4
	bra.s	EniDec_Sub4
	bra.s	EniDec_Sub8
	bra.s	EniDec_SubA
	bra.s	EniDec_SubC
	bra.s	EniDec_SubE
; ===========================================================================

EniDec_End:
	subq.w	#1,a0
	cmpi.w	#16,d6		; were we going to start on a completely new byte?
	bne.s	+		; if not, branch
	subq.w	#1,a0
+
	move.w	a0,d0
	lsr.w	#1,d0		; are we on an odd byte?
	bcc.s	+		; if not, branch
	addq.w	#1,a0		; ensure we're on an even byte
+
	movem.l	(sp)+,d0-d7/a1-a5
	rts

;  S U B R O U T I N E 


EniDec_GetInlineCopyVal:
	move.w	a3,d3		; store starting art tile
	move.b	d4,d1
	add.b	d1,d1
	bcc.s	+		; if d4 was < $80
	subq.w	#1,d6		; get next bit number
	btst	d6,d5		; is the bit set?
	beq.s	+		; if not, branch
	ori.w	#high_priority,d3	; set high priority bit
+
	add.b	d1,d1
	bcc.s	+		; if d4 was < $40
	subq.w	#1,d6		; get next bit number
	btst	d6,d5
	beq.s	+
	addi.w	#palette_line_2,d3	; set second palette line bit
+
	add.b	d1,d1
	bcc.s	+		; if d4 was < $20
	subq.w	#1,d6		; get next bit number
	btst	d6,d5
	beq.s	+
	addi.w	#palette_line_1,d3	; set first palette line bit
+
	add.b	d1,d1
	bcc.s	+		; if d4 was < $10
	subq.w	#1,d6		; get next bit number
	btst	d6,d5
	beq.s	+
	ori.w	#flip_y,d3	; set Y-flip bit
+
	add.b	d1,d1
	bcc.s	+		; if d4 was < 8
	subq.w	#1,d6
	btst	d6,d5
	beq.s	+
	ori.w	#flip_x,d3	; set X-flip bit
+
	move.w	d5,d1
	move.w	d6,d7		; get remaining bits
	sub.w	a5,d7		; subtract minimum bit number
	bcc.s	+		; if we're beyond that, branch
	move.w	d7,d6
	addi.w	#16,d6		; 16 bits = 2 bytes
	neg.w	d7		; calculate bit deficit
	lsl.w	d7,d1		; make space for this many bits
	move.b	(a0),d5		; get next byte
	rol.b	d7,d5		; make the upper X bits the lower X bits
	add.w	d7,d7
	and.w	EniDec_AndVals-2(pc,d7.w),d5	; only keep X lower bits
	add.w	d5,d1		; compensate for the bit deficit
-
	move.w	a5,d0
	add.w	d0,d0
	and.w	EniDec_AndVals-2(pc,d0.w),d1	; only keep as many bits as required
	add.w	d3,d1		; add starting art tile
	move.b	(a0)+,d5	; get current byte, move onto next byte
	lsl.w	#8,d5		; shift up by a byte
	move.b	(a0)+,d5	; store next byte in lower register byte
	rts
; ===========================================================================
+
	beq.s	+		; if the exact number of bits are leftover, branch
	lsr.w	d7,d1		; remove unneeded bits
	move.w	a5,d0
	add.w	d0,d0
	and.w	EniDec_AndVals-2(pc,d0.w),d1	; only keep as many bits as required
	add.w	d3,d1		; add starting art tile
	move.w	a5,d0		; store number of bits used up by inline copy
	bra.s	EniDec_ChkGetNextByte	; move onto next byte
; ===========================================================================
+
	moveq	#16,d6	; 16 bits = 2 bytes
	bra.s	-
; End of function EniDec_GetInlineCopyVal

; ===========================================================================
; word_190A:
EniDec_AndVals:
	dc.w	 1,    3,    7,   $F
	dc.w   $1F,  $3F,  $7F,  $FF
	dc.w  $1FF, $3FF, $7FF, $FFF
	dc.w $1FFF,$3FFF,$7FFF,$FFFF
; ===========================================================================

EniDec_ChkGetNextByte:
	sub.w	d0,d6
	cmpi.w	#9,d6
	bhs.s	+	; rts
	addq.w	#8,d6	; 8 bits = 1 byte
	asl.w	#8,d5	; shift up by a byte
	move.b	(a0)+,d5	; store next byte in lower register byte
+
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; ---------------------------------------------------------------------------
; KOSINSKI DECOMPRESSION PROCEDURE
; (sometimes called KOZINSKI decompression)

; This is the only procedure in the game that stores variables on the stack.

; ARGUMENTS:
; a0 = source address
; a1 = destination address

; For format explanation see http://info.sonicretro.org/Kosinski_compression
; ---------------------------------------------------------------------------
; KozDec_193A:
KosDec:
	subq.l	#2,sp
	move.b	(a0)+,1(sp)
	move.b	(a0)+,(sp)
	move.w	(sp),d5
	moveq	#$F,d4

-
	lsr.w	#1,d5
	move	sr,d6
	dbf	d4,+
	move.b	(a0)+,1(sp)
	move.b	(a0)+,(sp)
	move.w	(sp),d5
	moveq	#$F,d4
+
	move	d6,ccr
	bcc.s	+
	move.b	(a0)+,(a1)+
	bra.s	-
; ---------------------------------------------------------------------------
+
	moveq	#0,d3
	lsr.w	#1,d5
	move	sr,d6
	dbf	d4,+
	move.b	(a0)+,1(sp)
	move.b	(a0)+,(sp)
	move.w	(sp),d5
	moveq	#$F,d4
+
	move	d6,ccr
	bcs.s	+++
	lsr.w	#1,d5
	dbf	d4,+
	move.b	(a0)+,1(sp)
	move.b	(a0)+,(sp)
	move.w	(sp),d5
	moveq	#$F,d4
+
	roxl.w	#1,d3
	lsr.w	#1,d5
	dbf	d4,+
	move.b	(a0)+,1(sp)
	move.b	(a0)+,(sp)
	move.w	(sp),d5
	moveq	#$F,d4
+
	roxl.w	#1,d3
	addq.w	#1,d3
	moveq	#-1,d2
	move.b	(a0)+,d2
	bra.s	++
; ---------------------------------------------------------------------------
+
	move.b	(a0)+,d0
	move.b	(a0)+,d1
	moveq	#-1,d2
	move.b	d1,d2
	lsl.w	#5,d2
	move.b	d0,d2
	andi.w	#7,d1
	beq.s	++
	move.b	d1,d3
	addq.w	#1,d3
/
	move.b	(a1,d2.w),d0
	move.b	d0,(a1)+
	dbf	d3,-
	bra.s	--
; ---------------------------------------------------------------------------
+
	move.b	(a0)+,d1
	beq.s	+
	cmpi.b	#1,d1
	beq.w	--
	move.b	d1,d3
	bra.s	-
; ---------------------------------------------------------------------------
+
	addq.l	#2,sp
	rts
; End of function KosDec

; ===========================================================================

    if gameRevision<2
	nop
    endif
