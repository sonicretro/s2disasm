; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; ---------------------------------------------------------------------------
; KOSINSKI DECOMPRESSION PROCEDURE
; (sometimes called KOZINSKI decompression)

; This is the only procedure in the game that stores variables on the stack.

; ARGUMENTS:
; a0 = source address
; a1 = destination address

; For format explanation, see http://info.sonicretro.org/Kosinski_compression
; ---------------------------------------------------------------------------
; KozDec_193A:
KosDec:
	subq.l	#2,sp
	move.b	(a0)+,1(sp)
	move.b	(a0)+,(sp)
	move.w	(sp),d5	; copy first description field
	moveq	#$F,d4	; 16 bits in a byte

Kos_Loop:
	lsr.w	#1,d5	; bit which is shifted out goes into C flag
	move	sr,d6
	dbf	d4,.chkbit
	move.b	(a0)+,1(sp)
	move.b	(a0)+,(sp)
	move.w	(sp),d5	; get next description field if needed
	moveq	#$F,d4	; reset bit counter

.chkbit:
	move	d6,ccr
	bcc.s	Kos_RLE

	; bit was set - copy byte as-is
	move.b	(a0)+,(a1)+
	bra.s	Kos_Loop
; ---------------------------------------------------------------------------
Kos_RLE:
	moveq	#0,d3
	lsr.w	#1,d5	; get next bit
	move	sr,d6
	dbf	d4,.chkbit
	move.b	(a0)+,1(sp)
	move.b	(a0)+,(sp)
	move.w	(sp),d5
	moveq	#$F,d4

.chkbit:
	move	d6,ccr	; was bit set ?
	bcs.s	Kos_SeparateRLE	; if it was, branch
	lsr.w	#1,d5	; bit which is shifted out goes into X flag
	dbf	d4,.loop1
	move.b	(a0)+,1(sp)
	move.b	(a0)+,(sp)
	move.w	(sp),d5
	moveq	#$F,d4

.loop1:
	roxl.w	#1,d3	; get high repeat count bit by shifting X flag in
	lsr.w	#1,d5
	dbf	d4,.loop2
	move.b	(a0)+,1(sp)
	move.b	(a0)+,(sp)
	move.w	(sp),d5
	moveq	#$F,d4

.loop2:
	roxl.w	#1,d3	; get low repeat count bit
	addq.w	#1,d3	; increment repeat count
	moveq	#-1,d2
	move.b	(a0)+,d2	; calculate offset
	bra.s	Kos_RLELoop
; ---------------------------------------------------------------------------
Kos_SeparateRLE:
	move.b	(a0)+,d0	; get first byte
	move.b	(a0)+,d1	; get second byte
	moveq	#-1,d2
	move.b	d1,d2
	lsl.w	#5,d2
	move.b	d0,d2	; calculate offset
	andi.w	#7,d1	; does a third byte need to be read ?
	beq.s	Kos_SeparateRLE2	; if so, branch
	move.b	d1,d3	; copy repeat count
	addq.w	#1,d3	; and increment it

Kos_RLELoop:
	move.b	(a1,d2.w),d0
	move.b	d0,(a1)+	; copy appropriate byte as many times as needed
	dbf	d3,Kos_RLELoop
	bra.s	Kos_Loop
; ---------------------------------------------------------------------------
Kos_SeparateRLE2:
	move.b	(a0)+,d1
	beq.s	Kos_Done	; 0 indicates end of compressed data
	cmpi.b	#1,d1
	beq.w	Kos_Loop	; 1 indicates a new description needs to be read
	move.b	d1,d3	; otherwise, copy repeat count
	bra.s	Kos_RLELoop
; ---------------------------------------------------------------------------
Kos_Done:
	addq.l	#2,sp	; restore stack pointer
	rts
; End of function KosDec

; ===========================================================================

	jmpTos ; Empty
