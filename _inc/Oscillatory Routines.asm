; ---------------------------------------------------------------------------
; Oscillating number subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4A70:
OscillateNumInit:
	lea	(Oscillating_Numbers).w,a1
	lea	(Osc_Data).l,a2
	moveq	#bytesToWcnt(Osc_Data_End-Osc_Data),d1
; loc_4A7C:
Osc_Loop:
	move.w	(a2)+,(a1)+
	dbf	d1,Osc_Loop
	rts
; End of function OscillateNumInit

; ===========================================================================
; word_4A84:
Osc_Data:
	dc.w %0000000001111101		; oscillation direction bitfield
	dc.w   $80,   0	; baseline values
	dc.w   $80,   0
	dc.w   $80,   0
	dc.w   $80,   0
	dc.w   $80,   0
	dc.w   $80,   0
	dc.w   $80,   0
	dc.w   $80,   0
	dc.w   $80,   0
	dc.w $3848, $EE
	dc.w $2080, $B4
	dc.w $3080,$10E
	dc.w $5080,$1C2
	dc.w $7080,$276
	dc.w   $80,   0
	dc.w $4000, $FE
Osc_Data_End:

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4AC6:
OscillateNumDo:
	tst.w	(Two_player_mode).w
	bne.s	+
	cmpi.b	#6,(MainCharacter+routine).w
	bhs.s	OscillateNumDo_Return
+
	lea	(Oscillating_Numbers).w,a1
	lea	(Osc_Data2).l,a2
	move.w	(a1)+,d3
	moveq	#bytesToLcnt(Osc_Data2_End-Osc_Data2),d1

-	move.w	(a2)+,d2
	move.w	(a2)+,d4
	btst	d1,d3
	bne.s	+
	move.w	2(a1),d0
	add.w	d2,d0
	move.w	d0,2(a1)
	_add.w	d0,0(a1)
	_cmp.b	0(a1),d4
	bhi.s	++
	bset	d1,d3
	bra.s	++
; ===========================================================================
+
	move.w	2(a1),d0
	sub.w	d2,d0
	move.w	d0,2(a1)
	_add.w	d0,0(a1)
	_cmp.b	0(a1),d4
	bls.s	+
	bclr	d1,d3
+
	addq.w	#4,a1
	dbf	d1,-

	move.w	d3,(Oscillation_Control).w
; return_4B22:
OscillateNumDo_Return:
	rts
; End of function OscillateNumDo

; ===========================================================================
; word_4B24:
Osc_Data2:
	dc.w	 2, $10
	dc.w	 2, $18
	dc.w	 2, $20
	dc.w	 2, $30
	dc.w	 4, $20
	dc.w	 8,   8
	dc.w	 8, $40
	dc.w	 4, $40
	dc.w	 2, $38
	dc.w	 2, $38
	dc.w	 2, $20
	dc.w	 3, $30
	dc.w	 5, $50
	dc.w	 7, $70
	dc.w	 2, $40
	dc.w	 2, $40
Osc_Data2_End: