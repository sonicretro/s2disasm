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