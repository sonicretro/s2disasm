; --------------------------------------------------------------------------------------
; Filler (free space) (unnecessary; could be replaced with "even")
; --------------------------------------------------------------------------------------
	align $1000

; ---------------------------------------------------------------------------
; Subroutine to load the sound driver
; ---------------------------------------------------------------------------
; sub_EC000:
SoundDriverLoad:
	move	sr,-(sp)
	movem.l	d0-a6,-(sp)
	move	#$2700,sr
	lea	(Z80_Bus_Request).l,a3
	lea	(Z80_Reset).l,a2
	moveq	#0,d2
	move.w	#$100,d1
	move.w	d1,(a3)	; get Z80 bus
	move.w	d1,(a2)	; release Z80 reset (was held high by console on startup)
-	btst	d2,(a3)
	bne.s	-	; wait until the 68000 has the bus
	jsr	DecompressSoundDriver(pc)
	btst	#0,(VDP_control_port+1).l	; check video mode
	sne	(Z80_RAM+zPalModeByte).l	; set if PAL
	move.w	d2,(a2)	; hold Z80 reset
	move.w	d2,(a3)	; release Z80 bus
	moveq	#signextendB($E6),d0
-	dbf	d0,-	; wait for 2,314 cycles
	move.w	d1,(a2)	; release Z80 reset
	movem.l	(sp)+,d0-a6
	move	(sp)+,sr
	rts
