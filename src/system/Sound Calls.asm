; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Despite the name, this can actually be used for playing sounds.
; The original source code called this 'bgmset'.
; sub_135E:
PlayMusic:
	tst.b	(Sound_Queue.Music0).w
	bne.s	+
	move.b	d0,(Sound_Queue.Music0).w
	rts
+
	move.b	d0,(Sound_Queue.Music1).w
	rts
; End of function PlayMusic


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Despite the name, this can actually be used for playing music.
; The original source code called this 'sfxset'.
; sub_1370
PlaySound:
	; Curiously, none of these functions write to 'Sound_Queue.Queue2'...
	move.b	d0,(Sound_Queue.SFX0).w
	rts
; End of function PlaySound


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Despite the name, this can actually be used for playing music.
; Unfortunately, the original name for this is not known.
; sub_1376: PlaySoundStereo:
PlaySound2:
	move.b	d0,(Sound_Queue.SFX1).w
	rts
; End of function PlaySound2


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Play a sound if the source is on-screen.
; sub_137C:
PlaySoundLocal:
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.s	.return
	move.b	d0,(Sound_Queue.SFX0).w

.return:
	rts
; End of function PlaySoundLocal
