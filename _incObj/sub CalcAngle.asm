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