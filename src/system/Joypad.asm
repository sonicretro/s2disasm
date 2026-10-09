; ---------------------------------------------------------------------------
; Subroutine to initialize joypads
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_10EC:
JoypadInit:
	stopZ80
	moveq	#$40,d0
	move.b	d0,(HW_Port_1_Control).l	; init port 1 (joypad 1)
	move.b	d0,(HW_Port_2_Control).l	; init port 2 (joypad 2)
	move.b	d0,(HW_Expansion_Control).l	; init port 3 (expansion/extra)
	startZ80
	rts
; End of function JoypadInit

; ---------------------------------------------------------------------------
; Subroutine to read joypad input, and send it to the RAM
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_111C:
ReadJoypads:
	lea	(Ctrl_1).w,a0	; address where joypad states are written
	lea	(HW_Port_1_Data).l,a1	; first joypad port
	bsr.s	Joypad_Read		; do the first joypad
	addq.w	#2,a1			; do the second joypad

; sub_112A:
Joypad_Read:
	move.b	#0,(a1)	; Poll controller data port
	nop
	nop
	move.b	(a1),d0	; Get controller port data (start/A)
	lsl.b	#2,d0
	andi.b	#$C0,d0
	move.b	#$40,(a1)	; Poll controller data port again
	nop
	nop
	move.b	(a1),d1	; Get controller port data (B/C/Dpad)
	andi.b	#$3F,d1
	or.b	d1,d0	; Fuse them into one controller bit array
	not.b	d0
	move.b	(a0),d1	; Get button press data
	eor.b	d0,d1	; Toggle off held buttons
	move.b	d0,(a0)+	; Store raw controller input for held button data
	and.b	d0,d1
	move.b	d1,(a0)+	; Store pressed controller input
	rts
; End of function Joypad_Read
