; Sonic the Hedgehog 2 disassembled binary

; Nemesis,   2004: Created original disassembly for SNASM68K
; Aurochs,   2005: Translated to AS and annotated
; Xenowhirl, 2007: More annotation, overall cleanup, Z80 disassembly
; ---------------------------------------------------------------------------
; NOTES:
;
; Set your editor's tab width to 8 characters wide for viewing this file.
;
; It is highly suggested that you read the AS User's Manual before diving too
; far into this disassembly. At least read the section on nameless temporary
; symbols. Your brain may melt if you don't know how those work.
;
; See s2.notes.txt for more comments about this disassembly and other useful info.

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ASSEMBLY OPTIONS:
;
gameRevision = 1
;	| If 0, a REV00 ROM is built
;	| If 1, a REV01 ROM is built, which contains some fixes
;	| If 2, a (probable) REV02 ROM is built, which contains even more fixes
padToPowerOfTwo = 1
;	| If 1, pads the end of the ROM to the next power of two bytes (for real hardware)
;
fixBugs = 0
;	| If 1, enables all bug-fixes
;	| See also the 'FixDriverBugs' flag in 's2.sounddriver.asm'
allOptimizations = 0
;	| If 1, enables all optimizations
;
skipChecksumCheck = 0
;	| If 1, disables the slow bootup checksum calculation
;
zeroOffsetOptimization = 0|allOptimizations
;	| If 1, makes a handful of zero-offset instructions smaller
;
removeJmpTos = 0|(gameRevision=2)|allOptimizations
;	| If 1, many unnecessary JmpTos are removed, improving performance
;
addsubOptimize = 0|(gameRevision=2)|allOptimizations
;	| If 1, some add/sub instructions are optimized to addq/subq
;
relativeLea = 0|(gameRevision<>2)|allOptimizations
;	| If 1, makes some instructions use pc-relative addressing, instead of absolute long
;
useFullWaterTables = 0
;	| If 1, zone offset tables for water levels cover all level slots instead of only slots 8-$F
;	| Set to 1 if you've shifted level IDs around or you want water in levels with a level slot below 8

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; AS-specific macros and assembler settings
	CPU 68000
	include "s2.macrosetup.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Simplifying macros and functions
	include "s2.macros.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equates section - Names for variables.
	include "s2.constants.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Expressing SMPS bytecode in a portable and human-readable form
SonicDriverVer = 2 ; Tell SMPS2ASM that we are targetting Sonic 2's sound driver
	include "sound/_smps2asm_inc.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Expressing sprite mappings and DPLCs in a portable and human-readable form
SonicMappingsVer := 2
SonicDplcVer := 2
	include "mappings/MapMacros.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; start of ROM

StartOfRom:
    if * <> 0
	fatal "StartOfRom was $\{*} but it should be 0"
    endif

	; According to Sonic Jam, this is the 'AC' segment.
	include "code/Header, EntryPoint.asm"
	include "code/Int.asm" ; Likely the actual filename in the original source code, according to the Yuji Naka footage

	; General
	include "code/Utilities.asm"
	include "code/subsystems/Palette.asm"
	include "code/Utilities2.asm"

	; Screen modes
	include "code/modes/Sega Screen.asm"
	include "code/modes/Title Screen.asm"
	include "code/modes/Level.asm"
	include "code/modes/Special Stage.asm"
	include "code/modes/Continue Screen.asm"
	include "code/modes/Two-Player Results Screen.asm"
	include "code/modes/Options Screen & Level Select.asm"
	include "code/modes/Ending & Credits.asm"

	; Level
	include "code/subsystems/Level Data & Drawing.asm"
	include "code/subsystems/Level Events.asm"

	; Objects
	include "code/objects/11.asm"
	include "code/objects/15.asm"
	include "code/objects/17.asm"
	include "code/objects/18.asm"
	include "code/objects/1A & 1F.asm"
	include "code/objects/1C & 71.asm"
	include "code/objects/2A & 2D.asm"
	include "code/objects/28.asm"
	include "code/objects/Rings.asm"
	include "code/objects/Monitor.asm"
	include "code/objects/Title Screen.asm"
	include "code/objects/Title Card, Game Over, Results.asm"
	include "code/objects/Spikes.asm"
	include "code/objects/GHZ Purple Rock.asm"
	include "code/objects/GHZ Breakable Wall.asm"

	; Subsystems
	include "code/subsystems/Objects.asm"
	include "code/subsystems/Rings.asm"
	include "code/subsystems/Bumpers.asm"
	include "code/subsystems/Object Loader.asm"

	include "code/objects/Signpost.asm"

	include "code/subsystems/player solid object collision.asm"

	include "code/objects/Sonic.asm"
	include "code/objects/Tails.asm"
	include "code/objects/Drowning Bubbles, Shield, Splash, Super Sonic Stars.asm"

	include "code/subsystems/collision.asm"
	include "code/subsystems/floor and wall distance checking.asm"

	include "code/objects/Lamppost.asm"
	include "code/objects/Hidden Points.asm"
	include "code/objects/Bumper.asm"
	include "code/objects/Bubbles.asm"
	include "code/objects/Path Swapper.asm"
	include "code/objects/0B.asm"
	include "code/objects/0C.asm"
	include "code/objects/HPZ Emerald.asm"
	include "code/objects/HPZ Waterfall.asm"
	include "code/objects/04, 49, 31, 74, 7C, 27, 84, 8B.asm"
	include "code/objects/06.asm"
	include "code/objects/14.asm"
	include "code/objects/16.asm"
	include "code/objects/19.asm"
	include "code/objects/1B.asm"
	include "code/objects/1D.asm"
	include "code/objects/1E.asm"
	include "code/objects/20.asm"
	include "code/objects/2F, 32.asm"
	include "code/objects/30.asm"
	include "code/objects/33.asm"
	include "code/objects/43, 07.asm"
	include "code/objects/45, 46.asm"
	include "code/objects/47.asm"
	include "code/objects/3D.asm"
	include "code/objects/48.asm"
	include "code/objects/22.asm"
	include "code/objects/23, 2B.asm"
	include "code/objects/2C.asm"
	include "code/objects/40.asm"
	include "code/objects/42.asm"
	include "code/objects/64.asm"
	include "code/objects/65.asm"
	include "code/objects/66.asm"
	include "code/objects/67.asm"
	include "code/objects/68, 6D.asm"
	include "code/objects/69.asm"
	include "code/objects/6A.asm"
	include "code/objects/6B.asm"
	include "code/objects/6C.asm"
	include "code/objects/6E.asm"
	include "code/objects/70.asm"
	include "code/objects/72.asm"
	; MCZ
	include "code/objects/73.asm"
	include "code/objects/75.asm"
	include "code/objects/76.asm"
	include "code/objects/77.asm"
	; CPZ
	include "code/objects/78.asm"
	include "code/objects/7A.asm"
	include "code/objects/7B.asm"
	; MCZ
	include "code/objects/7F.asm"
	include "code/objects/80.asm"
	include "code/objects/81.asm"
	; ARZ
	include "code/objects/82.asm"
	include "code/objects/83.asm"
	; OOZ
	include "code/objects/3F.asm"
	; CNZ
	include "code/objects/85.asm"
	include "code/objects/86.asm"
	include "code/objects/D2.asm"
	include "code/objects/D3.asm"
	include "code/objects/D4.asm"
	include "code/objects/D5.asm"
	include "code/objects/D6.asm"
	include "code/objects/D7.asm"
	include "code/objects/D8.asm"
	; WFZ
	include "code/objects/D9.asm"
	; OOZ
	include "code/objects/4A.asm"
	include "code/objects/50.asm"
	; EHZ
	include "code/objects/4B.asm"
	include "code/objects/5C.asm"
	; Boss
	include "code/boss/utility.asm"
	include "code/boss/CPZ.asm"
	include "code/boss/EHZ.asm"
	include "code/boss/HTZ.asm"
	include "code/boss/ARZ.asm"
	include "code/boss/MCZ.asm"
	include "code/boss/CNZ.asm"
	include "code/boss/MTZ.asm"
	include "code/boss/OOZ.asm"
	; Special Stage
	include "code/special stage/sonic.asm"
	include "code/special stage/tails.asm"
	include "code/special stage/other.asm"
	; Made by a different programmer?
	include "code/objects/almighty object blob.asm"
	; Generic
	include "code/objects/8A.asm"
	include "code/objects/3E.asm"

	; Subsystems again
	include "code/subsystems/player enemy collision.asm"
	include "code/subsystems/animated level artwork.asm"
	include "code/subsystems/hud.asm"
	include "code/subsystems/edit.asm" ; Likely the actual filename in the original source code, according to the Yuji Naka footage
	include "code/subsystems/plcs.asm"

	; According to Sonic Jam, this is the 'TBL' segment.
	include "code/assets/assets.asm"

	align $100

	; According to Sonic Jam, this is the 'DATA' segment.
	include "code/assets/assets2.asm"

;--------------------------------------------------------------------------------------
; Filler (free space) (unnecessary; could be replaced with "even")
;--------------------------------------------------------------------------------------
	align $100

	; According to Sonic Jam, this is the 'RINGACT' segment.
	include "code/assets/rings.asm"

; --------------------------------------------------------------------------------------
; Filler (free space) (unnecessary; could be replaced with "even")
; --------------------------------------------------------------------------------------
	align $200

	; According to Sonic Jam, this is the 'ACTTBL' segment.
	include "code/assets/object layouts.asm"

; --------------------------------------------------------------------------------------
; Filler (free space) (unnecessary; could be replaced with "even")
; --------------------------------------------------------------------------------------
	align $800


	include "code/assets/sound.asm"


	align $20

	; According to Sonic Jam, this is the 'TBL2' segment.
	include "code/assets/assets3.asm"

	include "code/assets/sound2.asm"


; end of 'ROM'
	if padToPowerOfTwo && (*)&(*-1)
		cnop	-1,2<<lastbit(*-1)
		dc.b	0
paddingSoFar	:= paddingSoFar+1
	else
		even
	endif
EndOfRom:
	if MOMPASS=2
		; "About" because it will be off by the same amount that Size_of_Snd_driver_guess is incorrect (if you changed it), and because I may have missed a small amount of internal padding somewhere
		message "ROM size is $\{EndOfRom-StartOfRom} bytes (\{(EndOfRom-StartOfRom)/1024.0} KiB). About $\{paddingSoFar} bytes are padding. "
	endif
	; share these symbols externally (WARNING: don't rename, move or remove these labels!)
	shared movewZ80CompSize
	END
