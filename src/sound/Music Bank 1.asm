; ---------------------------------------------------------------------------
; Music pointers
; ---------------------------------------------------------------------------

music_ptr macro DATA
DATA.pointer label *
	rom_ptr_z80	DATA
    endm

; loc_F0000:
MusicPoint1:	startBank
		music_ptr	Mus_Continue

Mus_Continue:	include	"sound/music/generated/9C - Continue.inc"

	finishBank

	align $20

; --------------------------------------------------------------------------------------
; EHZ/HTZ Assets
; --------------------------------------------------------------------------------------
ArtNem_HtzFireball1:		BINCLUDE	"art/nemesis/Fireball 1.nem"
	even
ArtNem_Waterfall:		BINCLUDE	"art/nemesis/Waterfall tiles.nem"
	even
ArtNem_HtzFireball2:		BINCLUDE	"art/nemesis/Fireball 2.nem"
	even
ArtNem_EHZ_Bridge:		BINCLUDE	"art/nemesis/EHZ bridge.nem"
	even
ArtNem_HtzZipline:		BINCLUDE	"art/nemesis/HTZ zip-line platform.nem"
	even
ArtNem_HtzValveBarrier:		BINCLUDE	"art/nemesis/One way barrier from HTZ.nem"
	even
ArtNem_HtzSeeSaw:		BINCLUDE	"art/nemesis/See-saw in HTZ.nem"
	even
				BINCLUDE	"art/nemesis/Fireball 3.nem" ; Unused
	even
ArtNem_HtzRock:			BINCLUDE	"art/nemesis/Rock from HTZ.nem"
	even
ArtNem_Sol:			BINCLUDE	"art/nemesis/Sol badnik from HTZ.nem" ; Not grouped with the other badniks for some reason...
	even

; --------------------------------------------------------------------------------------
; MTZ Assets
; --------------------------------------------------------------------------------------
ArtNem_MtzWheel:		BINCLUDE	"art/nemesis/Large spinning wheel from MTZ.nem"
	even
ArtNem_MtzWheelIndent:		BINCLUDE	"art/nemesis/Large spinning wheel from MTZ - indent.nem"
	even
ArtNem_MtzSpikeBlock:		BINCLUDE	"art/nemesis/MTZ spike block.nem"
	even
ArtNem_MtzSteam:		BINCLUDE	"art/nemesis/Steam from MTZ.nem"
	even
ArtNem_MtzSpike:		BINCLUDE	"art/nemesis/Spike from MTZ.nem"
	even
ArtNem_MtzAsstBlocks:		BINCLUDE	"art/nemesis/Similarly shaded blocks from MTZ.nem"
	even
ArtNem_MtzLavaBubble:		BINCLUDE	"art/nemesis/Lava bubble from MTZ.nem"
	even
ArtNem_LavaCup:			BINCLUDE	"art/nemesis/Lava cup from MTZ.nem"
	even
ArtNem_BoltEnd_Rope:		BINCLUDE	"art/nemesis/Bolt end and rope from MTZ.nem"
	even
ArtNem_MtzCog:			BINCLUDE	"art/nemesis/Small cog from MTZ.nem"
	even
ArtNem_MtzSpinTubeFlash:	BINCLUDE	"art/nemesis/Spin tube flash from MTZ.nem"
	even

; --------------------------------------------------------------------------------------
; MCZ Assets
; --------------------------------------------------------------------------------------
ArtNem_Crate:			BINCLUDE	"art/nemesis/Large wooden box from MCZ.nem"
	even
ArtNem_MCZCollapsePlat:		BINCLUDE	"art/nemesis/Collapsing platform from MCZ.nem"
	even
ArtNem_VineSwitch:		BINCLUDE	"art/nemesis/Pull switch from MCZ.nem"
	even
ArtNem_VinePulley:		BINCLUDE	"art/nemesis/Vine that lowers from MCZ.nem"
	even
ArtNem_MCZGateLog:		BINCLUDE	"art/nemesis/Drawbridge logs from MCZ.nem"
	even

; ----------------------------------------------------------------------------------
; Filler (free space)
; ----------------------------------------------------------------------------------
	; the PCM data has to line up with the end of the bank.
	cnop -Size_of_SEGA_sound, $8000

; -------------------------------------------------------------------------------
; Sega Intro Sound
; 8-bit unsigned raw audio at 16Khz
; -------------------------------------------------------------------------------
; loc_F1E8C:
Snd_Sega:	include	"sound/PCM/generated/SEGA.inc"

	if Snd_Sega.size > $8000
		fatal "Sega sound must fit within $8000 bytes, but you have a $\{Snd_Sega.size} byte Sega sound."
	endif
	if Snd_Sega.size > Size_of_SEGA_sound
		fatal "Size_of_SEGA_sound = $\{Size_of_SEGA_sound}, but you have a $\{Snd_Sega.size} byte Sega sound."
	endif
