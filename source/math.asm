; ---------------------------------------------------------------------------
; Subroutine to generate a pseudo-random number in d0
; d0 = (RNG & $FFFF0000) | ((RNG*41 & $FFFF) + ((RNG*41 & $FFFF0000) >> 16))
; RNG = ((RNG*41 + ((RNG*41 & $FFFF) << 16)) & $FFFF0000) | (RNG*41 & $FFFF)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_3390:
RandomNumber:
	move.l	(RNG_seed).w,d1
	bne.s	+
	move.l	#$2A6D365A,d1 ; if the RNG is 0, reset it to this crazy number

	; set the high word of d0 to be the high word of the RNG
	; and multiply the RNG by 41
+	move.l	d1,d0
	asl.l	#2,d1
	add.l	d0,d1
	asl.l	#3,d1
	add.l	d0,d1

	; add the low word of the RNG to the high word of the RNG
	; and set the low word of d0 to be the result
	move.w	d1,d0
	swap	d1
	add.w	d1,d0
	move.w	d0,d1
	swap	d1

	move.l	d1,(RNG_seed).w
	rts
; End of function RandomNumber


; ---------------------------------------------------------------------------
; Subroutine to calculate sine and cosine of an angle
; d0 = input byte = angle (360 degrees == 256)
; d0 = output word = 255 * sine(angle)
; d1 = output word = 255 * cosine(angle)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_33B6:
CalcSine:
	andi.w	#$FF,d0
	add.w	d0,d0
	addi.w	#$80,d0
	move.w	Sine_Data(pc,d0.w),d1 ; cos
	subi.w	#$80,d0
	move.w	Sine_Data(pc,d0.w),d0 ; sin
	rts
; End of function CalcSine

; ===========================================================================
; word_33CE:
Sine_Data:	BINCLUDE	"misc/sinewave.bin"


; ---------------------------------------------------------------------------
; Subroutine to calculate arctangent of y/x
; d1 = input x
; d2 = input y
; d0 = output angle (360 degrees == 256)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_364E:
CalcAngle:
	movem.l	d3-d4,-(sp)
	moveq	#0,d3
	moveq	#0,d4
	move.w	d1,d3
	move.w	d2,d4
	or.w	d3,d4
	beq.s	CalcAngle_Zero ; special case return if x and y are both 0
	move.w	d2,d4

	absw.w	d3	; calculate absolute value of x
	absw.w	d4	; calculate absolute value of y
	cmp.w	d3,d4
	bhs.w	+
	lsl.l	#8,d4
	divu.w	d3,d4
	moveq	#0,d0
	move.b	Angle_Data(pc,d4.w),d0
	bra.s	++
+
	lsl.l	#8,d3
	divu.w	d4,d3
	moveq	#$40,d0
	sub.b	Angle_Data(pc,d3.w),d0
+
	tst.w	d1
	bpl.w	+
	neg.w	d0
	addi.w	#$80,d0
+
	tst.w	d2
	bpl.w	+
	neg.w	d0
	addi.w	#$100,d0
+
	movem.l	(sp)+,d3-d4
	rts
; ===========================================================================
; loc_36AA:
CalcAngle_Zero:
	move.w	#$40,d0
	movem.l	(sp)+,d3-d4
	rts
; End of function CalcAngle

; ===========================================================================
; byte_36B4:
Angle_Data:	BINCLUDE	"misc/angles.bin"

; ===========================================================================

    if gameRevision<2
	nop
    endif
