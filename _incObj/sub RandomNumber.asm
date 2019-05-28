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