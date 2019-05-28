; ---------------------------------------------------------------------------
; Subroutine to pause the game
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1388:
PauseGame:
	nop
	tst.b	(Life_count).w	; do you have any lives left?
	beq.w	Unpause		; if not, branch
	tst.w	(Game_paused).w	; is game already paused?
	bne.s	+		; if yes, branch
	move.b	(Ctrl_1_Press).w,d0 ; is Start button pressed?
	or.b	(Ctrl_2_Press).w,d0 ; (either player)
	andi.b	#button_start_mask,d0
	beq.s	Pause_DoNothing	; if not, branch
+
	move.w	#1,(Game_paused).w	; freeze time
	move.b	#MusID_Pause,(Music_to_play).w	; pause music
; loc_13B2:
Pause_Loop:
	move.b	#VintID_Pause,(Vint_routine).w
	bsr.w	WaitForVint
	tst.b	(Slow_motion_flag).w	; is slow-motion cheat on?
	beq.s	Pause_ChkStart		; if not, branch
	btst	#button_A,(Ctrl_1_Press).w	; is button A pressed?
	beq.s	Pause_ChkBC		; if not, branch
	move.b	#GameModeID_TitleScreen,(Game_Mode).w ; set game mode to 4 (title screen)
	nop
	bra.s	Pause_Resume
; ===========================================================================
; loc_13D4:
Pause_ChkBC:
	btst	#button_B,(Ctrl_1_Held).w ; is button B pressed?
	bne.s	Pause_SlowMo		; if yes, branch
	btst	#button_C,(Ctrl_1_Press).w ; is button C pressed?
	bne.s	Pause_SlowMo		; if yes, branch
; loc_13E4:
Pause_ChkStart:
	move.b	(Ctrl_1_Press).w,d0	; is Start button pressed?
	or.b	(Ctrl_2_Press).w,d0	; (either player)
	andi.b	#button_start_mask,d0
	beq.s	Pause_Loop	; if not, branch
; loc_13F2:
Pause_Resume:
	move.b	#MusID_Unpause,(Music_to_play).w	; unpause the music
; loc_13F8:
Unpause:
	move.w	#0,(Game_paused).w	; unpause the game
; return_13FE:
Pause_DoNothing:
	rts
; ===========================================================================
; loc_1400:
Pause_SlowMo:
	move.w	#1,(Game_paused).w
	move.b	#MusID_Unpause,(Music_to_play).w
	rts
; End of function PauseGame