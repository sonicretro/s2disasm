; ---------------------------------------------------------------------------
; Subroutine to play music after a countdown (when Sonic leaves the water)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1D81E:
ResumeMusic:
	cmpi.b	#12,air_left(a1)
	bhi.s	ResumeMusic_Done	; branch if countdown hasn't started yet

	cmpa.w	#MainCharacter,a1
	bne.s	ResumeMusic_Done	; branch if it isn't player 1

	move.w	(Level_Music).w,d0	; prepare to play current level's music

	btst	#status_secondary.invincible,status_secondary(a1)
	beq.s	+		; branch if Sonic is not invincible
	move.w	#MusID_Invincible,d0	; prepare to play invincibility music
+
	tst.b	(Super_Sonic_flag).w
	beq.w	+		; branch if it isn't Super Sonic
	move.w	#MusID_SuperSonic,d0	; prepare to play Super Sonic music
+
	tst.b	(Current_Boss_ID).w
	beq.s	+		; branch if not in a boss fight
	move.w	#MusID_Boss,d0	; prepare to play boss music
+
	jsr	(PlayMusic).l
; return_1D858:
ResumeMusic_Done:
	move.b	#30,air_left(a1)	; reset air to full
	rts
