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
