; ---------------------------------------------------------------------------
; S2 sound driver (Sound driver compression (slightly modified Saxman))
; ---------------------------------------------------------------------------
; loc_EC0E8:
Snd_Driver:
	save
	include "src/sound/Z80 Sound Driver.asm" ; CPU Z80
	restore
	padding off
	!org (Snd_Driver+Size_of_Snd_driver_guess) ; don't worry; I know what I'm doing

; loc_ED04C:
Snd_Driver_End:

; ---------------------------------------------------------------------------
; Filler (free space)
; ---------------------------------------------------------------------------
	; the DAC data has to line up with the end of the bank.

	; actually it only has to fit within one bank, but we'll line it up to the end anyway
	; because the padding gives the sound driver some room to grow
	cnop -Size_of_DAC_samples, $8000

; ---------------------------------------------------------------------------
; DAC samples
; ---------------------------------------------------------------------------

; loc_ED100:
SndDAC_Start:

SndDAC_Kick:	include	"sound/DAC/generated/Kick.inc"
SndDAC_Snare:	include	"sound/DAC/generated/Snare.inc"
SndDAC_Timpani:	include	"sound/DAC/generated/Timpani.inc"
SndDAC_Tom:	include	"sound/DAC/generated/Tom.inc"
SndDAC_Clap:	include	"sound/DAC/generated/Clap.inc"
SndDAC_Scratch:	include	"sound/DAC/generated/Scratch.inc"
SndDAC_Bongo:	include	"sound/DAC/generated/Bongo.inc"

SndDAC_End

	if SndDAC_End - SndDAC_Start > $8000
		fatal "DAC samples must fit within $8000 bytes, but you have $\{SndDAC_End-SndDAC_Start } bytes of DAC samples."
	endif
	if SndDAC_End - SndDAC_Start > Size_of_DAC_samples
		fatal "Size_of_DAC_samples = $\{Size_of_DAC_samples}, but you have $\{SndDAC_End-SndDAC_Start} bytes of DAC samples."
	endif
