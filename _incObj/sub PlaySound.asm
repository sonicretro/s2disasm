; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; If Music_to_play is clear, move d0 into Music_to_play,
; else move d0 into Music_to_play_2.
; sub_135E:
PlayMusic:
	tst.b	(Music_to_play).w
	bne.s	+
	move.b	d0,(Music_to_play).w
	rts
+
	move.b	d0,(Music_to_play_2).w
	rts
; End of function PlayMusic


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1370
PlaySound:
	move.b	d0,(SFX_to_play).w
	rts
; End of function PlaySound


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; play a sound in alternating speakers (as in the ring collection sound)
; sub_1376:
PlaySoundStereo:
	move.b	d0,(SFX_to_play_2).w
	rts
; End of function PlaySoundStereo


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; play a sound if the source is onscreen
; sub_137C:
PlaySoundLocal:
	tst.b	render_flags(a0)
	bpl.s	+	; rts
	move.b	d0,(SFX_to_play).w
+
	rts
; End of function PlaySoundLocal