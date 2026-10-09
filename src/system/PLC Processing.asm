; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; ---------------------------------------------------------------------------
; Subroutine to load pattern load cues (aka to queue pattern load requests)
; ---------------------------------------------------------------------------

; ARGUMENTS
; d0 = index of PLC list (see ArtLoadCues)

; NOTICE: This subroutine does not check for buffer overruns. The programmer
;         (or hacker) is responsible for making sure that no more than
;         16 load requests are copied into the buffer.
;         _________DO NOT PUT MORE THAN 16 LOAD REQUESTS IN A LIST!__________
;         (or if you change the size of Plc_Buffer, the limit becomes (Plc_Buffer_Only_End-Plc_Buffer)/6)

; sub_161E: PLCLoad: AddPLC:
LoadPLC:
	movem.l	a1-a2,-(sp)
	lea	(ArtLoadCues).l,a1
	add.w	d0,d0
	move.w	(a1,d0.w),d0
	lea	(a1,d0.w),a1	; jump to relevant PLC
	lea	(Plc_Buffer).w,a2

	; exit this loop when we find space available in RAM
.findFreeSpaceLoop:
	tst.l	(a2)	; is space available in RAM ?
	beq.s	.foundFreeSpace ; if it's zero, exit this loop
	addq.w	#6,a2	; try next space
	bra.s	.findFreeSpaceLoop

	; the PLC is only copied to RAM if it has a positive length
.foundFreeSpace:
	move.w	(a1)+,d0	; get PLC length
	bmi.s	.return ; if it's negative, skip the next loop

.copyPLCLoop:
	move.l	(a1)+,(a2)+
	move.w	(a1)+,(a2)+	; copy PLC to RAM
	dbf	d0,.copyPLCLoop	; repeat for the whole length of the PLC

.return:
	movem.l	(sp)+,a1-a2 ; a1=object
	rts
; End of function LoadPLC


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Queue pattern load requests, but clear the PLQ first

; ARGUMENTS
; d0 = index of PLC list (see ArtLoadCues)

; NOTICE: This subroutine does not check for buffer overruns. The programmer
;         (or hacker) is responsible for making sure that no more than
;         16 load requests are copied into the buffer.
;         _________DO NOT PUT MORE THAN 16 LOAD REQUESTS IN A LIST!__________
;         (or if you change the size of Plc_Buffer, the limit becomes (Plc_Buffer_Only_End-Plc_Buffer)/6)
; sub_1650:
LoadPLC2:
	movem.l	a1-a2,-(sp)
	lea	(ArtLoadCues).l,a1
	add.w	d0,d0
	move.w	(a1,d0.w),d0
	lea	(a1,d0.w),a1	; jump to relevant PLC
	bsr.s	ClearPLC	; erase any data in PLC buffer space
	lea	(Plc_Buffer).w,a2

	; the PLC is only copied to RAM if it has a positive length
	move.w	(a1)+,d0	; get PLC length
	bmi.s	.return ; if it's negative, skip the next loop

.copyPLCLoop:
	move.l	(a1)+,(a2)+
	move.w	(a1)+,(a2)+
	dbf	d0,.copyPLCLoop

.return:
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
	; Immediately returns if the queue is empty or processing of a previous piece is still ongoing
	tst.l	(Plc_Buffer).w
	beq.s	.return
	tst.w	(Plc_PatternsLeft).w
	bne.s	.return

	movea.l	(Plc_Buffer).w,a0
	lea_	NemDec_WriteAndStay,a3
	nop
	lea	(Decomp_Buffer).w,a1
	move.w	(a0)+,d2
	bpl.s	+
	adda.w	#NemDec_WriteAndStay_XOR-NemDec_WriteAndStay,a3
+
	andi.w	#$7FFF,d2
    if ~~fixBugs
	; This is done too early: this variable is used to determine when
	; there are PLCs to process, which means that as soon as this
	; variable is set, PLC processing will occur during V-Int. If an
	; interrupt occurs between here and the end of this function, then
	; the PLC processor will begin despite it not being fully
	; initialised yet, causing a crash. S3K fixes this bug by moving this
	; instruction to the end of the function.
	move.w	d2,(Plc_PatternsLeft).w
    endif

	bsr.w	NemDecPrepare
	move.b	(a0)+,d5
	asl.w	#8,d5
	move.b	(a0)+,d5
	moveq	#$10,d6
	moveq	#0,d0
	move.l	a0,(Plc_Buffer).w
	move.l	a3,(Plc_PtrNemCode).w
	move.l	d0,(Plc_RepeatCount).w
	move.l	d0,(Plc_PaletteIndex).w
	move.l	d0,(Plc_PreviousRow).w
	move.l	d5,(Plc_DataWord).w
	move.l	d6,(Plc_ShiftValue).w
    if fixBugs
	; See above.
	move.w	d2,(Plc_PatternsLeft).w
    endif

.return:
	rts
; End of function RunPLC_RAM


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Process one PLC from the queue

; sub_16E0:
ProcessDPLC:
	; In Sonic 1, ProcessDPLC processed 9 patterns per frame, however Sonic 2
	; instead only processes 6 patterns. It's possible this was made as an
	; attempt to sidestep the PLC race conditions, or the occasional lag that
	; could happen when decompressing the explosion graphics.
	tst.w	(Plc_PatternsLeft).w
	beq.w	+	; rts
	move.w	#6,(Plc_FramePatternsLeft).w	; 6 patterns are decompressed every frame
	moveq	#0,d0
	move.w	(Plc_Buffer+4).w,d0
	addi.w	#6*$20,(Plc_Buffer+4).w	; increment by 6 patterns's worth of data
	bra.s	ProcessDPLC_Main

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Process one PLC from the queue

; loc_16FC:
ProcessDPLC2:
	tst.w	(Plc_PatternsLeft).w
	beq.s	+	; rts
	move.w	#3,(Plc_FramePatternsLeft).w
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
	movea.l	(Plc_PtrNemCode).w,a3
	move.l	(Plc_RepeatCount).w,d0
	move.l	(Plc_PaletteIndex).w,d1
	move.l	(Plc_PreviousRow).w,d2
	move.l	(Plc_DataWord).w,d5
	move.l	(Plc_ShiftValue).w,d6
	lea	(Decomp_Buffer).w,a1

-	movea.w	#8,a5
	bsr.w	NemDecRun.writePixelLoopEntry
	subq.w	#1,(Plc_PatternsLeft).w
	beq.s	ProcessDPLC_Pop
	subq.w	#1,(Plc_FramePatternsLeft).w
	bne.s	-

	move.l	a0,(Plc_Buffer).w
	move.l	a3,(Plc_PtrNemCode).w
	move.l	d0,(Plc_RepeatCount).w
	move.l	d1,(Plc_PaletteIndex).w
	move.l	d2,(Plc_PreviousRow).w
	move.l	d5,(Plc_DataWord).w
	move.l	d6,(Plc_ShiftValue).w
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

    if fixBugs
	; The above code does not properly 'pop' the 16th PLC entry.
	; Because of this, occupying the 16th slot will cause it to
	; be repeatedly decompressed infinitely.
	; Granted, this could be conisdered more of an optimisation
	; than a bug: treating the 16th entry as a dummy that
	; should never be occupied makes this code unnecessary.
	; Still, the overhead of this code is minimal.
    if (Plc_Buffer_Only_End-Plc_Buffer-6)&2
	move.w	6(a0),(a0)
    endif

	clr.l	(Plc_Buffer_Only_End-6).w
    endif

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
-	movea.l	(a1)+,a0	; get source address
	moveq	#0,d0
	move.w	(a1)+,d0	; get destination VRAM address
	lsl.l	#2,d0
	lsr.w	#2,d0
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d0
	swap	d0	; d0 = VDP command to write to destination
	move.l	d0,(VDP_control_port).l
	bsr.w	NemDec
	dbf	d1,-

	rts
; End of function RunPLC_ROM
