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
;	| If 2, a (theoretical) REV02 ROM is built, which contains even more fixes
padToPowerOfTwo = 1
;	| If 1, pads the end of the ROM to the next power of two bytes (for real hardware)
;
fixBugs = 0
;	| If 1, enables all bug-fixes
;	| See also the 'FixDriverBugs' flag in 's2.sounddriver.asm'
;	| See also the 'FixMusicAndSFXDataBugs' flag in 'build.lua'
allOptimizations = 0
;	| If 1, enables all optimizations
;
skipChecksumCheck = 0
;	| If 1, disables the slow bootup checksum calculation
;
zeroOffsetOptimization = 0|allOptimizations
;	| If 1, makes a handful of zero-offset instructions smaller
;
removeJmpTos = 0|(gameRevision>=2)|allOptimizations
;	| If 1, many unnecessary JmpTos are removed, improving performance
;
addsubOptimize = 0|(gameRevision=2)|allOptimizations
;	| If 1, some add/sub instructions are optimized to addq/subq
;
relativeLea = 0|(gameRevision<2)|allOptimizations
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
FixMusicAndSFXDataBugs = fixBugs
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
Vectors:
	dc.l System_Stack	; Initial stack pointer value
	dc.l EntryPoint		; Start of program
	dc.l ErrorTrap		; Bus error
	dc.l ErrorTrap		; Address error (4)
	dc.l ErrorTrap		; Illegal instruction
	dc.l ErrorTrap		; Division by zero
	dc.l ErrorTrap		; CHK exception
	dc.l ErrorTrap		; TRAPV exception (8)
	dc.l ErrorTrap		; Privilege violation
	dc.l ErrorTrap		; TRACE exception
	dc.l ErrorTrap		; Line-A emulator
	dc.l ErrorTrap		; Line-F emulator (12)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved) (16)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved) (20)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved) (24)
	dc.l ErrorTrap		; Spurious exception
	dc.l ErrorTrap		; IRQ level 1
	dc.l ErrorTrap		; IRQ level 2
	dc.l ErrorTrap		; IRQ level 3 (28)
	dc.l H_Int		; IRQ level 4 (horizontal retrace interrupt)
	dc.l ErrorTrap		; IRQ level 5
	dc.l V_Int		; IRQ level 6 (vertical retrace interrupt)
	dc.l ErrorTrap		; IRQ level 7 (32)
	dc.l ErrorTrap		; TRAP #00 exception
	dc.l ErrorTrap		; TRAP #01 exception
	dc.l ErrorTrap		; TRAP #02 exception
	dc.l ErrorTrap		; TRAP #03 exception (36)
	dc.l ErrorTrap		; TRAP #04 exception
	dc.l ErrorTrap		; TRAP #05 exception
	dc.l ErrorTrap		; TRAP #06 exception
	dc.l ErrorTrap		; TRAP #07 exception (40)
	dc.l ErrorTrap		; TRAP #08 exception
	dc.l ErrorTrap		; TRAP #09 exception
	dc.l ErrorTrap		; TRAP #10 exception
	dc.l ErrorTrap		; TRAP #11 exception (44)
	dc.l ErrorTrap		; TRAP #12 exception
	dc.l ErrorTrap		; TRAP #13 exception
	dc.l ErrorTrap		; TRAP #14 exception
	dc.l ErrorTrap		; TRAP #15 exception (48)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved) (52)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved) (56)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved) (60)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved) (64)
; byte_100:
Header:
	dc.b "SEGA GENESIS    " ; Console name
	dc.b "(C)SEGA 1992.SEP" ; Copyright holder and release date (generally year)
	dc.b "SONIC THE       " ; Domestic name
	dc.b "      HEDGEHOG 2"
	dc.b "                "
	dc.b "SONIC THE       " ; International name
	dc.b "      HEDGEHOG 2"
	dc.b "                "
    if gameRevision=0
	dc.b "GM 00001051-00"   ; Version (REV00)
    elseif gameRevision=1
	dc.b "GM 00001051-01"   ; Version (REV01)
    elseif gameRevision=2
	dc.b "GM 00001051-02"   ; Version (REV02)
    endif
; word_18E
Checksum:
	dc.w $D951		; Checksum (patched later if incorrect)
	dc.b "J               " ; I/O Support
	dc.l StartOfRom		; Start address of ROM
; dword_1A4
ROMEndLoc:
	dc.l EndOfRom-1		; End address of ROM
	dc.l RAM_Start&$FFFFFF		; Start address of RAM
	dc.l (RAM_End-1)&$FFFFFF	; End address of RAM
	dc.b "    "		; Backup RAM ID
	dc.l $20202020		; Backup RAM start address
	dc.l $20202020		; Backup RAM end address
	dc.b "            "	; Modem support
	dc.b "                                        "	; Notes (unused, anything can be put in this space, but it has to be 52 bytes.)
	dc.b "JUE             " ; Country code (region)
EndOfHeader:

; ===========================================================================
; Crash/Freeze the 68000. Note that the Z80 continues to run, so the music keeps playing.
; loc_200:
ErrorTrap:
	nop	; delay
	nop	; delay
	bra.s	ErrorTrap	; Loop indefinitely.

; ===========================================================================
; loc_206:
EntryPoint:
	; Everything from here to just past CheckSumCheck is the standard
	; "MEGA DRIVE hard initial program", distributed by Sega as a file
	; called 'ICD_BLK4.PRG'.
	; http://techdocs.exodusemulator.com/Console/SegaMegaDrive/Software.html#original-development-tools
	tst.l	(HW_Port_1_Control-1).l		; test ports A and B control
	bne.s	PortA_Ok			; If so, branch.
	tst.w	(HW_Expansion_Control-1).l	; test port C control
; loc_214:
PortA_Ok:
	bne.s	PortC_OK ; Skip the VDP and Z80 setup code if this is a soft-reset.
	lea	SetupValues(pc),a5	; Load setup values array address.
	movem.w	(a5)+,d5-d7
	movem.l	(a5)+,a0-a4
	move.b	HW_Version-Z80_Bus_Request(a1),d0	; Get hardware version
	andi.b	#$F,d0					; Compare
	beq.s	SkipSecurity				; If the console has no TMSS, skip the security stuff.
	move.l	#'SEGA',Security_Addr-Z80_Bus_Request(a1) ; Satisfy the TMSS
; loc_234:
SkipSecurity:
	move.w	(a4),d0	; check if VDP works
	moveq	#0,d0	; clear d0
	movea.l	d0,a6	; clear a6
	move.l	a6,usp	; set usp to $0

	moveq	#VDPInitValues_End-VDPInitValues-1,d1 ; run the following loop $18 times
; loc_23E:
VDPInitLoop:
	move.b	(a5)+,d5	; add $8000 to value
	move.w	d5,(a4)		; move value to VDP register
	add.w	d7,d5		; next register
	dbf	d1,VDPInitLoop

	move.l	(a5)+,(a4)	; set VRAM write mode
	move.w	d0,(a3)		; clear the screen
	move.w	d7,(a1)		; stop the Z80
	move.w	d7,(a2)		; reset the Z80
; loc_250:
WaitForZ80:
	btst	d0,(a1)		; has the Z80 stopped?
	bne.s	WaitForZ80	; if not, branch

	moveq	#Z80StartupCodeEnd-Z80StartupCodeBegin-1,d2
; loc_256:
Z80InitLoop:
	move.b	(a5)+,(a0)+
	dbf	d2,Z80InitLoop

	move.w	d0,(a2)
	move.w	d0,(a1)	; start the Z80
	move.w	d7,(a2)	; reset the Z80

; loc_262:
ClrRAMLoop:
	move.l	d0,-(a6)	; clear 4 bytes of RAM
	dbf	d6,ClrRAMLoop	; repeat until the entire RAM is clear
	move.l	(a5)+,(a4)	; set VDP display mode and increment mode
	move.l	(a5)+,(a4)	; set VDP to CRAM write

	moveq	#bytesToLcnt($80),d3	; set repeat times
; loc_26E:
ClrCRAMLoop:
	move.l	d0,(a3)		; clear 2 palettes
	dbf	d3,ClrCRAMLoop	; repeat until the entire CRAM is clear
	move.l	(a5)+,(a4)	; set VDP to VSRAM write

	moveq	#bytesToLcnt($50),d4	; set repeat times
; loc_278: ClrVDPStuff:
ClrVSRAMLoop:
	move.l	d0,(a3)	; clear 4 bytes of VSRAM.
	dbf	d4,ClrVSRAMLoop	; repeat until the entire VSRAM is clear
	moveq	#PSGInitValues_End-PSGInitValues-1,d5	; set repeat times.
; loc_280:
PSGInitLoop:
	move.b	(a5)+,PSG_input-VDP_data_port(a3) ; reset the PSG
	dbf	d5,PSGInitLoop	; repeat for other channels
	move.w	d0,(a2)
	movem.l	(a6),d0-a6	; clear all registers
	move	#$2700,sr	; set the sr
 ; loc_292:
PortC_OK: ;;
	bra.s	GameProgram	; Branch to game program.
; ===========================================================================
; byte_294:
SetupValues:
	dc.w	$8000,bytesToLcnt($10000),$100

	dc.l	Z80_RAM
	dc.l	Z80_Bus_Request
	dc.l	Z80_Reset
	dc.l	VDP_data_port, VDP_control_port

VDPInitValues:	; values for VDP registers
	dc.b 4			; Command $8004 - HInt off, Enable HV counter read
	dc.b $14		; Command $8114 - Display off, VInt off, DMA on, PAL off
	dc.b $30		; Command $8230 - Scroll A Address $C000
	dc.b $3C		; Command $833C - Window Address $F000
	dc.b 7			; Command $8407 - Scroll B Address $E000
	dc.b $6C		; Command $856C - Sprite Table Address $D800
	dc.b 0			; Command $8600 - Null
	dc.b 0			; Command $8700 - Background color Pal 0 Color 0
	dc.b 0			; Command $8800 - Null
	dc.b 0			; Command $8900 - Null
	dc.b $FF		; Command $8AFF - Hint timing $FF scanlines
	dc.b 0			; Command $8B00 - Ext Int off, VScroll full, HScroll full
	dc.b $81		; Command $8C81 - 40 cell mode, shadow/highlight off, no interlace
	dc.b $37		; Command $8D37 - HScroll Table Address $DC00
	dc.b 0			; Command $8E00 - Null
	dc.b 1			; Command $8F01 - VDP auto increment 1 byte
	dc.b 1			; Command $9001 - 64x32 cell scroll size
	dc.b 0			; Command $9100 - Window H left side, Base Point 0
	dc.b 0			; Command $9200 - Window V upside, Base Point 0
	dc.b $FF		; Command $93FF - DMA Length Counter $FFFF
	dc.b $FF		; Command $94FF - See above
	dc.b 0			; Command $9500 - DMA Source Address $0
	dc.b 0			; Command $9600 - See above
	dc.b $80		; Command $9780 - See above + VRAM fill mode
VDPInitValues_End:

	dc.l	vdpComm($0000,VRAM,DMA) ; value for VRAM write mode

	; Z80 instructions (not the sound driver; that gets loaded later)
Z80StartupCodeBegin: ; loc_2CA:
    save
    CPU Z80 ; start assembling Z80 code
    phase 0 ; pretend we're at address 0
	xor	a	; clear a to 0
	ld	bc,((Z80_RAM_End-Z80_RAM)-zStartupCodeEndLoc)-1 ; prepare to loop this many times
	ld	de,zStartupCodeEndLoc+1	; initial destination address
	ld	hl,zStartupCodeEndLoc	; initial source address
	ld	sp,hl	; set the address the stack starts at
	ld	(hl),a	; set first byte of the stack to 0
	ldir		; loop to fill the stack (entire remaining available Z80 RAM) with 0
	pop	ix	; clear ix
	pop	iy	; clear iy
	ld	i,a	; clear i
	ld	r,a	; clear r
	pop	de	; clear de
	pop	hl	; clear hl
	pop	af	; clear af
	ex	af,af'	; swap af with af'
	exx		; swap bc/de/hl with their shadow registers too
	pop	bc	; clear bc
	pop	de	; clear de
	pop	hl	; clear hl
	pop	af	; clear af
	ld	sp,hl	; clear sp
	di		; clear iff1 (for interrupt handler)
	im	1	; interrupt handling mode = 1
	ld	(hl),0E9h ; replace the first instruction with a jump to itself
	jp	(hl)	  ; jump to the first instruction (to stay there forever)
zStartupCodeEndLoc:
    dephase ; stop pretending
	restore
    padding off ; unfortunately our flags got reset so we have to set them again...
Z80StartupCodeEnd:

	dc.w	$8104	; value for VDP display mode
	dc.w	$8F02	; value for VDP increment
	dc.l	vdpComm($0000,CRAM,WRITE)	; value for CRAM write mode
	dc.l	vdpComm($0000,VSRAM,WRITE)	; value for VSRAM write mode

PSGInitValues:
	dc.b	$9F,$BF,$DF,$FF	; values for PSG channel volumes
PSGInitValues_End:
; ===========================================================================

	even
; loc_300:
GameProgram:
	tst.w	(VDP_control_port).l
; loc_306:
CheckSumCheck:
    if gameRevision>0
	move.w	(VDP_control_port).l,d1
	btst	#1,d1
	bne.s	CheckSumCheck	; wait until DMA is completed
    endif
	; "MEGA DRIVE hard initial program" ends here.
	btst	#6,(HW_Expansion_Control).l
	beq.s	ChecksumTest
	cmpi.l	#'init',(Checksum_fourcc).w ; has checksum routine already run?
	beq.w	GameInit

; loc_328:
ChecksumTest:
    if skipChecksumCheck=0	; checksum code
	movea.l	#EndOfHeader,a0	; start checking bytes after the header ($200)
	movea.l	#ROMEndLoc,a1	; stop at end of ROM
	move.l	(a1),d0
	moveq	#0,d1
; loc_338:
ChecksumLoop:
	add.w	(a0)+,d1
	cmp.l	a0,d0
	bhs.s	ChecksumLoop
	movea.l	#Checksum,a1	; read the checksum
	cmp.w	(a1),d1		; compare correct checksum to the one in ROM
	bne.w	ChecksumError	; if they don't match, branch
    endif
;checksum_good:
	; Clear some RAM only on a coldboot.
	lea	(CrossResetRAM).w,a6
	moveq	#0,d7

	move.w	#bytesToLcnt(CrossResetRAM_End-CrossResetRAM),d6
-	move.l	d7,(a6)+
	dbf	d6,-

	move.b	(HW_Version).l,d0
	andi.b	#$C0,d0
	move.b	d0,(Graphics_Flags).w
	move.l	#'init',(Checksum_fourcc).w ; set flag so checksum won't be run again
; loc_370:
GameInit:
	; Clear some RAM on every boot and reset.
	lea	(RAM_Start&$FFFFFF).l,a6
	moveq	#0,d7
	move.w	#bytesToLcnt(CrossResetRAM-RAM_Start),d6
; loc_37C:
GameClrRAM:
	move.l	d7,(a6)+
	dbf	d6,GameClrRAM	; clear RAM ($0000-$FDFF)

	bsr.w	VDPSetupGame
	bsr.w	JmpTo_SoundDriverLoad
	bsr.w	JoypadInit
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; set Game Mode to Sega Screen
; loc_394:
MainGameLoop:
	move.b	(Game_Mode).w,d0	; load Game Mode
	andi.w	#$3C,d0			; limit Game Mode value to $3C max (change to a maximum of $7C to add more game modes)
	jsr	GameModesArray(pc,d0.w)	; jump to apt location in ROM
	bra.s	MainGameLoop		; loop indefinitely
; ===========================================================================
; loc_3A2:
GameModesArray: ;;
GameMode_SegaScreen:	bra.w	SegaScreen		; SEGA screen mode
GameMode_TitleScreen:	bra.w	TitleScreen		; Title screen mode
GameMode_Demo:		bra.w	Level			; Demo mode
GameMode_Level:		bra.w	Level			; Zone play mode
GameMode_SpecialStage:	bra.w	SpecialStage		; Special stage play mode
GameMode_ContinueScreen:bra.w	ContinueScreen		; Continue mode
GameMode_2PResults:	bra.w	TwoPlayerResults	; 2P results mode
GameMode_2PLevelSelect:	bra.w	LevelSelectMenu2P	; 2P level select mode
GameMode_EndingSequence:bra.w	JmpTo_EndingSequence	; End sequence mode
GameMode_OptionsMenu:	bra.w	OptionsMenu		; Options mode
GameMode_LevelSelect:	bra.w	LevelSelectMenu		; Level select mode
; ===========================================================================
    if skipChecksumCheck=0	; checksum error code
; loc_3CE:
ChecksumError:
	move.l	d1,-(sp)
	bsr.w	VDPSetupGame
	move.l	(sp)+,d1
	move.l	#vdpComm($0000,CRAM,WRITE),(VDP_control_port).l ; set VDP to CRAM write
	moveq	#16*4-1,d7 ; all colours of all palette lines
; loc_3E2:
Checksum_Red:
	move.w	#$00E,(VDP_data_port).l	; fill palette with red
	dbf	d7,Checksum_Red		; repeat $3F more times
; loc_3EE:
ChecksumFailed_Loop:
	bra.s	ChecksumFailed_Loop
    endif
; ===========================================================================
; loc_3F0:
LevelSelectMenu2P: ;;
	jmp	(MenuScreen).l
; ===========================================================================
; loc_3F6:
JmpTo_EndingSequence ; JmpTo
	jmp	(EndingSequence).l
; ===========================================================================
; loc_3FC:
OptionsMenu: ;;
	jmp	(MenuScreen).l
; ===========================================================================
; loc_402:
LevelSelectMenu: ;;
	jmp	(MenuScreen).l
; ===========================================================================

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; vertical and horizontal interrupt handlers
; VERTICAL INTERRUPT HANDLER:
V_Int:
	movem.l	d0-a6,-(sp)
	tst.b	(Vint_routine).w
	beq.w	Vint_Lag

	; waits until vertical blanking is taking place
-	move.w	(VDP_control_port).l,d0
	andi.w	#8,d0
	beq.s	-

	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.l	(Vscroll_Factor).w,(VDP_data_port).l ; send screen y-axis pos. to VSRAM
	btst	#6,(Graphics_Flags).w	; is Megadrive PAL?
	beq.s	+			; if not, branch

	move.w	#$700,d0
-	dbf	d0,- ; wait here in a loop doing nothing for a while...
+

	move.b	(Vint_routine).w,d0
	move.b	#VintID_Lag,(Vint_routine).w
	move.w	#1,(Hint_flag).w	; allows horizontal interrupt code to run
	andi.w	#$3E,d0
	move.w	Vint_SwitchTbl(pc,d0.w),d0
	jsr	Vint_SwitchTbl(pc,d0.w)

VintRet:
	addq.l	#1,(Vint_runcount).w
	movem.l	(sp)+,d0-a6
	rte
; ===========================================================================
Vint_SwitchTbl: offsetTable
Vint_Lag_ptr		offsetTableEntry.w Vint_Lag		;   0
Vint_SEGA_ptr:		offsetTableEntry.w Vint_SEGA		;   2
Vint_Title_ptr:		offsetTableEntry.w Vint_Title		;   4
Vint_Unused6_ptr:	offsetTableEntry.w Vint_Unused6		;   6
Vint_Level_ptr:		offsetTableEntry.w Vint_Level		;   8
Vint_S2SS_ptr:		offsetTableEntry.w Vint_S2SS		;  $A
Vint_TitleCard_ptr:	offsetTableEntry.w Vint_TitleCard	;  $C
Vint_UnusedE_ptr:	offsetTableEntry.w Vint_UnusedE		;  $E
Vint_Pause_ptr:		offsetTableEntry.w Vint_Pause		; $10
Vint_Fade_ptr:		offsetTableEntry.w Vint_Fade		; $12
Vint_PCM_ptr:		offsetTableEntry.w Vint_PCM		; $14
Vint_Menu_ptr:		offsetTableEntry.w Vint_Menu		; $16
Vint_Ending_ptr:	offsetTableEntry.w Vint_Ending		; $18
Vint_CtrlDMA_ptr:	offsetTableEntry.w Vint_CtrlDMA		; $1A
; ===========================================================================
;VintSub0
Vint_Lag:
	cmpi.b	#GameModeID_TitleCard|GameModeID_Demo,(Game_Mode).w	; pre-level Demo Mode?
	beq.s	.isInLevelMode
	cmpi.b	#GameModeID_TitleCard|GameModeID_Level,(Game_Mode).w	; pre-level Zone play mode?
	beq.s	.isInLevelMode
	cmpi.b	#GameModeID_Demo,(Game_Mode).w	; Demo Mode?
	beq.s	.isInLevelMode
	cmpi.b	#GameModeID_Level,(Game_Mode).w	; Zone play mode?
	beq.s	.isInLevelMode

	stopZ80			; stop the Z80
	bsr.w	sndDriverInput	; give input to the sound driver
	startZ80		; start the Z80

	bra.s	VintRet
; ---------------------------------------------------------------------------

; loc_4C4:
.isInLevelMode:
	tst.b	(Water_flag).w
	beq.w	Vint0_noWater
	move.w	(VDP_control_port).l,d0

	btst	#6,(Graphics_Flags).w ; is Megadrive PAL?
	beq.s	+		; if not, branch

	move.w	#$700,d0
-	dbf	d0,- ; wait here in a loop doing nothing for a while...
+

	move.w	#1,(Hint_flag).w

	stopZ80

	tst.b	(Water_fullscreen_flag).w
	bne.s	.useUnderwaterPalette

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM

	bra.s	.afterSetPalette
; ---------------------------------------------------------------------------

; loc_526:
.useUnderwaterPalette:
	dma68kToVDP Underwater_palette,$0000,palette_line_size*4,CRAM

; loc_54A:
.afterSetPalette:
	move.w	(Hint_counter_reserve).w,(a5)
	move.w	#$8200|(VRAM_Plane_A_Name_Table/$400),(VDP_control_port).l	; Set scroll A PNT base to $C000
	bsr.w	sndDriverInput

	startZ80

	bra.w	VintRet
; ---------------------------------------------------------------------------

Vint0_noWater:
	move.w	(VDP_control_port).l,d0
    if ~~fixBugs
	; As with the sprite table upload, this only needs to be done in two-player mode.

	; Update V-Scroll.
	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.l	(Vscroll_Factor).w,(VDP_data_port).l
    endif

	btst	#6,(Graphics_Flags).w	; is Megadrive PAL?
	beq.s	+			; if not, branch

	move.w	#$700,d0
-	dbf	d0,- ; wait here in a loop doing nothing for a while...
+

	move.w	#1,(Hint_flag).w
	move.w	(Hint_counter_reserve).w,(VDP_control_port).l
	move.w	#$8200|(VRAM_Plane_A_Name_Table/$400),(VDP_control_port).l	; Set scroll A PNT base to $C000
    if ~~fixBugs
	; Does not need to be done on lag frames.
	move.l	(Vscroll_Factor_P2).w,(Vscroll_Factor_P2_HInt).w
    endif

	stopZ80
    if fixBugs
	; In two-player mode, we have to update the sprite table
	; even during a lag frame so that the top half of the screen
	; shows the correct sprites.
	tst.w	(Two_player_mode).w
	beq.s	++

	; Update V-Scroll.
	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.l	(Vscroll_Factor).w,(VDP_data_port).l

	; Like in Sonic 3, the sprite tables are page-flipped in two-player mode.
	; This fixes a race-condition where incomplete sprite tables can be uploaded
	; to the VDP on lag frames, causing corrupted sprites to appear.

	; Upload the front buffer.
	tst.b	(Current_sprite_table_page).w
	beq.s	+
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	bra.s	++
+
	dma68kToVDP Sprite_Table_Alternate,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
+
    else
	; In the original game, the sprite table is needlessly updated on lag frames.
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
    endif
	bsr.w	sndDriverInput
	startZ80

	bra.w	VintRet
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; This subroutine copies the H scroll table buffer (in main RAM) to the H scroll
; table (in VRAM).
;VintSub2
Vint_SEGA:
	bsr.w	Do_ControllerPal

	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM
	jsrto	JmpTo_SegaScr_VInt
	tst.w	(Demo_Time_left).w	; is there time left on the demo?
	beq.w	+			; if not, return
	subq.w	#1,(Demo_Time_left).w	; subtract 1 from time left in demo
+
	rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;VintSub14
Vint_PCM:
	move.b	(Vint_runcount+3).w,d0

	; makes it so the joypads are only read once every 16 frames
	andi.w	#$F,d0
	bne.s	+

	stopZ80
	bsr.w	ReadJoypads
	startZ80

+
	tst.w	(Demo_Time_left).w	; is there time left on the demo?
	beq.w	+			; if not, return
	subq.w	#1,(Demo_Time_left).w	; subtract 1 from time left in demo
+
	rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;VintSub4
Vint_Title:
	bsr.w	Do_ControllerPal
	bsr.w	ProcessDPLC
	tst.w	(Demo_Time_left).w	; is there time left on the demo?
	beq.w	+			; if not, return
	subq.w	#1,(Demo_Time_left).w	; subtract 1 from time left in demo
+
	rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;VintSub6
Vint_Unused6:
	bsr.w	Do_ControllerPal
	rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;VintSub10
Vint_Pause:
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; Special Stage?
	beq.w	Vint_Pause_specialStage
;VintSub8
Vint_Level:
	stopZ80

	bsr.w	ReadJoypads
	tst.b	(Teleport_timer).w
	beq.s	.setNormalOrUnderwaterPalette
	lea	(VDP_control_port).l,a5
	tst.w	(Game_paused).w	; is the game paused?
	bne.w	.afterPaletteSetup	; if yes, branch
	subq.b	#1,(Teleport_timer).w
	bne.s	+
	move.b	#0,(Teleport_flag).w
+
	cmpi.b	#16,(Teleport_timer).w
	blo.s	.setNormalOrUnderwaterPalette
	lea	(VDP_data_port).l,a6
	move.l	#vdpComm($0000,CRAM,WRITE),(VDP_control_port).l
	move.w	#$EEE,d0 ; White.

	; Do two palette lines.
	move.w	#16*2-1,d1
-	move.w	d0,(a6)
	dbf	d1,-

	; Skip a colour.
	move.l	#vdpComm($0042,CRAM,WRITE),(VDP_control_port).l

	; Do the remaining two palette lines.
    if fixBugs
	move.w	#31-1,d1
    else
	; This does one more colour than necessary: it isn't accounting for
	; the colour that was skipped earlier!
	move.w	#32-1,d1
    endif
-	move.w	d0,(a6)
	dbf	d1,-

	bra.s	.afterPaletteSetup
; ---------------------------------------------------------------------------

; loc_6F8:
.setNormalOrUnderwaterPalette:
	tst.b	(Water_fullscreen_flag).w
	bne.s	.useUnderwaterPalette
	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	bra.s	.afterPaletteSetup
; ---------------------------------------------------------------------------

; loc_724:
.useUnderwaterPalette:
	dma68kToVDP Underwater_palette,$0000,palette_line_size*4,CRAM

; loc_748:
.afterPaletteSetup:
	move.w	(Hint_counter_reserve).w,(a5)
	move.w	#$8200|(VRAM_Plane_A_Name_Table/$400),(VDP_control_port).l	; Set scroll A PNT base to $C000

	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM

    if fixBugs
	tst.w	(Two_player_mode).w
	beq.s	++
	; Like in Sonic 3, the sprite tables are page-flipped in two-player mode.
	; This fixes a race-condition where incomplete sprite tables can be uploaded
	; to the VDP on lag frames, causing corrupted sprites to appear.

	; Perform page-flipping.
	tst.b	(Sprite_table_page_flip_pending).w
	beq.s	+
	sf.b	(Sprite_table_page_flip_pending).w
	not.b	(Current_sprite_table_page).w
+
	; Upload the front buffer.
	tst.b	(Current_sprite_table_page).w
	bne.s	+
	dma68kToVDP Sprite_Table_Alternate,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	bra.s	++
+
    endif
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
+

	bsr.w	ProcessDMAQueue
	bsr.w	sndDriverInput

	startZ80

	movem.l	(Camera_RAM).w,d0-d7
	movem.l	d0-d7,(Camera_RAM_copy).w
	movem.l	(Camera_X_pos_P2).w,d0-d7
	movem.l	d0-d7,(Camera_P2_copy).w
	movem.l	(Scroll_flags).w,d0-d3
	movem.l	d0-d3,(Scroll_flags_copy).w
	move.l	(Vscroll_Factor_P2).w,(Vscroll_Factor_P2_HInt).w
	cmpi.b	#$5C,(Hint_counter_reserve+1).w
	bhs.s	Do_Updates
	move.b	#1,(Do_Updates_in_H_int).w
	rts

; ---------------------------------------------------------------------------
; Subroutine to run a demo for an amount of time
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_7E6: Demo_Time:
Do_Updates:
	jsrto	JmpTo_LoadTilesAsYouMove
	jsr	(HudUpdate).l
	bsr.w	ProcessDPLC2
	tst.w	(Demo_Time_left).w	; is there time left on the demo?
	beq.w	+			; if not, branch
	subq.w	#1,(Demo_Time_left).w	; subtract 1 from time left in demo
+
	rts
; End of function Do_Updates

; ---------------------------------------------------------------------------
;Vint10_specialStage
Vint_Pause_specialStage:
	stopZ80

	bsr.w	ReadJoypads
	jsr	(sndDriverInput).l
	tst.b	(SS_Last_Alternate_HorizScroll_Buf).w
	beq.s	loc_84A

	dma68kToVDP SS_Horiz_Scroll_Buf_2,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM
	bra.s	loc_86E
; ---------------------------------------------------------------------------
loc_84A:
	dma68kToVDP SS_Horiz_Scroll_Buf_1,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM

loc_86E:
	startZ80
	rts
; ========================================================================>>>
;VintSubA
Vint_S2SS:
	stopZ80

	bsr.w	ReadJoypads
	bsr.w	SSSet_VScroll

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM

	tst.b	(SS_Alternate_HorizScroll_Buf).w
	beq.s	loc_906

	dma68kToVDP SS_Horiz_Scroll_Buf_2,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM
	bra.s	loc_92A
; ---------------------------------------------------------------------------

loc_906:
	dma68kToVDP SS_Horiz_Scroll_Buf_1,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM

loc_92A:
	tst.b	(SSTrack_Orientation).w		; Is the current track frame flipped?
	beq.s	++				; Branch if not
	moveq	#0,d0
	move.b	(SSTrack_drawing_index).w,d0	; Get drawing position
	cmpi.b	#4,d0				; Have we finished drawing and streaming track frame?
	bge.s	++				; Branch if yes (nothing to draw)
	add.b	d0,d0				; Convert to index
	tst.b	(SS_Alternate_PNT).w		; [(SSTrack_drawing_index) * 2] = subroutine
	beq.s	+				; Branch if not using the alternate Plane A name table
	addi_.w	#8,d0				; ([(SSTrack_drawing_index) * 2] + 8) = subroutine
+
	move.w	SS_PNTA_Transfer_Table(pc,d0.w),d0
	jsr	SS_PNTA_Transfer_Table(pc,d0.w)
+
	bsr.w	SSRun_Animation_Timers
	addi_.b	#1,(SSTrack_drawing_index).w	; Run track timer
	move.b	(SSTrack_drawing_index).w,d0	; Get new timer value
	cmp.b	d1,d0				; Is it less than the player animation timer?
	blt.s	+++				; Branch if so
	move.b	#0,(SSTrack_drawing_index).w	; Start drawing new frame
	lea	(VDP_control_port).l,a6
	tst.b	(SS_Alternate_PNT).w		; Are we using the alternate address for plane A?
	beq.s	+				; Branch if not
	move.w	#$8200|(VRAM_SS_Plane_A_Name_Table1/$400),(a6)	; Set PNT A base to $C000
	bra.s	++
; ===========================================================================
;off_97A
SS_PNTA_Transfer_Table:	offsetTable
		offsetTableEntry.w loc_A50	; 0
		offsetTableEntry.w loc_A76	; 1
		offsetTableEntry.w loc_A9C	; 2
		offsetTableEntry.w loc_AC2	; 3
		offsetTableEntry.w loc_9B8	; 4
		offsetTableEntry.w loc_9DE	; 5
		offsetTableEntry.w loc_A04	; 6
		offsetTableEntry.w loc_A2A	; 7
; ===========================================================================
+
	move.w	#$8200|(VRAM_SS_Plane_A_Name_Table2/$400),(a6)	; Set PNT A base to $8000
+
	eori.b	#1,(SS_Alternate_PNT).w	; Toggle flag
+
	bsr.w	ProcessDMAQueue
	jsr	(sndDriverInput).l

	startZ80

	bsr.w	ProcessDPLC2
	tst.w	(Demo_Time_left).w
	beq.w	+	; rts
	subq.w	#1,(Demo_Time_left).w
+
	rts
; ---------------------------------------------------------------------------
; (!)
; Each of these functions copies one fourth of pattern name table A into VRAM
; from a buffer in main RAM. $700 bytes are copied each frame, with the target
; are in VRAM depending on the current drawing position.
loc_9B8:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table1 + 0 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_9DE:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table1 + 1 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A04:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table1 + 2 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A2A:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table1 + 3 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A50:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table2 + 0 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A76:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table2 + 1 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A9C:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table2 + 2 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_AC2:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table2 + 3 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_AE8
SSSet_VScroll:
	move.w	(VDP_control_port).l,d0
	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.l	(Vscroll_Factor).w,(VDP_data_port).l
	rts
; End of function SSSet_VScroll


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_B02
SSRun_Animation_Timers:
	move.w	(SS_Cur_Speed_Factor).w,d0		; Get current speed factor
	cmp.w	(SS_New_Speed_Factor).w,d0		; Has the speed factor changed?
	beq.s	+					; Branch if yes
	move.l	(SS_New_Speed_Factor).w,(SS_Cur_Speed_Factor).w	; Save new speed factor
	move.b	#0,(SSTrack_duration_timer).w		; Reset timer
+
	subi_.b	#1,(SSTrack_duration_timer).w		; Run track timer
	bgt.s	+					; Branch if not expired yet
	lea	(SSAnim_Base_Duration).l,a0
	move.w	(SS_Cur_Speed_Factor).w,d0		; The current speed factor is an index
	lsr.w	#1,d0
	move.b	(a0,d0.w),d1
	move.b	d1,(SS_player_anim_frame_timer).w	; New player animation length (later halved)
	move.b	d1,(SSTrack_duration_timer).w		; New track timer
	subq.b	#1,(SS_player_anim_frame_timer).w	; Subtract one
	rts
; ---------------------------------------------------------------------------
+
	move.b	(SS_player_anim_frame_timer).w,d1	; Get current player animation length
	addq.b	#1,d1					; Increase it
	rts
; End of function SSRun_Animation_Timers

; ===========================================================================
;byte_B46
SSAnim_Base_Duration:
	dc.b 60
	dc.b 30	; 1
	dc.b 15	; 2
	dc.b 10	; 3
	dc.b  8	; 4
	dc.b  6	; 5
	dc.b  5	; 6
	dc.b  0	; 7
	even
; ===========================================================================
;VintSub1A
Vint_CtrlDMA:
	stopZ80
	jsr	(ProcessDMAQueue).l
	startZ80
	rts
; ===========================================================================
;VintSubC
Vint_TitleCard:
	stopZ80

	bsr.w	ReadJoypads
	tst.b	(Water_fullscreen_flag).w
	bne.s	loc_BB2

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	bra.s	loc_BD6
; ---------------------------------------------------------------------------

loc_BB2:
	dma68kToVDP Underwater_palette,$0000,palette_line_size*4,CRAM

loc_BD6:
	move.w	(Hint_counter_reserve).w,(a5)

	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM

    if fixBugs
	tst.w	(Two_player_mode).w
	beq.s	++
	; Like in Sonic 3, the sprite tables are page-flipped in two-player mode.
	; This fixes a race-condition where incomplete sprite tables can be uploaded
	; to the VDP on lag frames, causing corrupted sprites to appear.

	; Perform page-flipping.
	tst.b	(Sprite_table_page_flip_pending).w
	beq.s	+
	sf.b	(Sprite_table_page_flip_pending).w
	not.b	(Current_sprite_table_page).w
+
	; Upload the front buffer.
	tst.b	(Current_sprite_table_page).w
	bne.s	+
	dma68kToVDP Sprite_Table_Alternate,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	bra.s	++
+
    endif
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
+
	bsr.w	ProcessDMAQueue
	jsr	(DrawLevelTitleCard).l
	jsr	(sndDriverInput).l

	startZ80

	movem.l	(Camera_RAM).w,d0-d7
	movem.l	d0-d7,(Camera_RAM_copy).w
	movem.l	(Scroll_flags).w,d0-d1
	movem.l	d0-d1,(Scroll_flags_copy).w
	move.l	(Vscroll_Factor_P2).w,(Vscroll_Factor_P2_HInt).w
	bsr.w	ProcessDPLC
	rts
; ===========================================================================
;VintSubE
Vint_UnusedE:
	bsr.w	Do_ControllerPal
	addq.b	#1,(VIntSubE_RunCount).w
	move.b	#VintID_UnusedE,(Vint_routine).w
	rts
; ===========================================================================
;VintSub12
Vint_Fade:
	bsr.w	Do_ControllerPal
	move.w	(Hint_counter_reserve).w,(a5)
	bra.w	ProcessDPLC
; ===========================================================================
;VintSub18
Vint_Ending:
	stopZ80

	bsr.w	ReadJoypads

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM

	bsr.w	ProcessDMAQueue
	bsr.w	sndDriverInput
	movem.l	(Camera_RAM).w,d0-d7
	movem.l	d0-d7,(Camera_RAM_copy).w
	movem.l	(Scroll_flags).w,d0-d3
	movem.l	d0-d3,(Scroll_flags_copy).w
	jsrto	JmpTo_LoadTilesAsYouMove

	startZ80

	move.w	(Ending_VInt_Subrout).w,d0
	beq.s	+	; rts
	clr.w	(Ending_VInt_Subrout).w
	move.w	off_D3C-2(pc,d0.w),d0
	jsr	off_D3C(pc,d0.w)
+
	rts
; ===========================================================================
off_D3C:	offsetTable
		offsetTableEntry.w (+)	; 1
		offsetTableEntry.w (++)	; 2
; ===========================================================================
+
	dmaFillVRAM 0,VRAM_EndSeq_Plane_A_Name_Table,VRAM_EndSeq_Plane_Table_Size	; VRAM Fill $C000 with $2000 zeros
	rts
; ---------------------------------------------------------------------------
+
	dmaFillVRAM 0,VRAM_EndSeq_Plane_B_Name_Table2,VRAM_EndSeq_Plane_Table_Size
	dmaFillVRAM 0,VRAM_EndSeq_Plane_A_Name_Table,VRAM_EndSeq_Plane_Table_Size

	lea	(VDP_control_port).l,a6
	move.w	#$8B00,(a6)		; EXT-INT off, V scroll by screen, H scroll by screen
	move.w	#$8400|(VRAM_EndSeq_Plane_B_Name_Table2/$2000),(a6)	; PNT B base: $4000
	move.w	#$9011,(a6)		; Scroll table size: 64x64
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_EndSeq_Plane_A_Name_Table + planeLoc(64,22,33),VRAM,WRITE),d0	;$50AC0003
	moveq	#23-1,d1
	moveq	#15-1,d2
    if removeJmpTos
	jsr	(PlaneMapToVRAM_H40).l
    else
	bsr.w	PlaneMapToVRAM_H40
    endif
	rts
; ===========================================================================
;VintSub16
Vint_Menu:
	stopZ80

	bsr.w	ReadJoypads

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM

	bsr.w	ProcessDMAQueue
	bsr.w	sndDriverInput

	startZ80

	bsr.w	ProcessDPLC
	tst.w	(Demo_Time_left).w
	beq.w	+	; rts
	subq.w	#1,(Demo_Time_left).w
+
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_E98
Do_ControllerPal:
	stopZ80

	bsr.w	ReadJoypads
	tst.b	(Water_fullscreen_flag).w
	bne.s	loc_EDA

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	bra.s	loc_EFE
; ---------------------------------------------------------------------------

loc_EDA:
	dma68kToVDP Underwater_palette,$0000,palette_line_size*4,CRAM

loc_EFE:
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM

	bsr.w	sndDriverInput

	startZ80

	rts
; End of function sub_E98
; ||||||||||||||| E N D   O F   V - I N T |||||||||||||||||||||||||||||||||||

; ===========================================================================
; Start of H-INT code
H_Int:
	tst.w	(Hint_flag).w
	beq.w	H_Int_Done
	tst.w	(Two_player_mode).w
	beq.w	PalToCRAM
	move.w	#0,(Hint_flag).w
	move.l	a5,-(sp)
	move.l	d0,-(sp)

-	move.w	(VDP_control_port).l,d0	; loop start: Wait until we're in the H-blank region
	andi.w	#4,d0
	beq.s	-	; loop end


	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l		; Display disable

	move.w	#$8200|(VRAM_Plane_A_Name_Table_2P/$400),(VDP_control_port).l	; PNT A base: $A000

	; Update V-Scroll.
	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.l	(Vscroll_Factor_P2_HInt).w,(VDP_data_port).l

	stopZ80
    if fixBugs
	; Like in Sonic 3, the sprite tables are page-flipped in two-player mode.
	; This fixes a race-condition where incomplete sprite tables can be uploaded
	; to the VDP on lag frames.

	; Upload the front buffer.
	tst.b	(Current_sprite_table_page).w
	beq.s	+
	dma68kToVDP Sprite_Table_P2,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	bra.s	++
+
	dma68kToVDP Sprite_Table_P2_Alternate,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
+
    else
	dma68kToVDP Sprite_Table_P2,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
    endif
	startZ80

-	move.w	(VDP_control_port).l,d0 ; loop start: Wait until we're in the H-blank region
	andi.w	#4,d0
	beq.s	-	; loop end

	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l		; Display enable
	move.l	(sp)+,d0
	movea.l	(sp)+,a5

H_Int_Done:
	rte


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; game code

; ---------------------------------------------------------------------------
; loc_1000:
PalToCRAM:
	move	#$2700,sr
	move.w	#0,(Hint_flag).w
	movem.l	a0-a1,-(sp)
	lea	(VDP_data_port).l,a1
	lea	(Underwater_palette).w,a0 ; load palette from RAM
	move.l	#vdpComm($0000,CRAM,WRITE),VDP_control_port-VDP_data_port(a1)	; set VDP to write to CRAM address $00
    rept 32
	move.l	(a0)+,(a1)	; move palette to CRAM (all 64 colors at once)
    endm
	move.w	#$8A00|223,VDP_control_port-VDP_data_port(a1)	; Write %1101 %1111 to register 10 (interrupt every 224th line)
	movem.l	(sp)+,a0-a1
	tst.b	(Do_Updates_in_H_int).w
	bne.s	loc_1072
	rte
; ===========================================================================

loc_1072:
	clr.b	(Do_Updates_in_H_int).w
	movem.l	d0-a6,-(sp)
	bsr.w	Do_Updates
	movem.l	(sp)+,d0-a6
	rte

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Input our music/sound selection to the sound driver.

sndDriverInput:
	lea	(Sound_Queue&$00FFFFFF).l,a0
	lea	(Z80_RAM+zAbsVar).l,a1 ; $A01B80

	cmpi.b	#$80,zVar.QueueToPlay(a1)	; If this (zReadyFlag) isn't $80, the driver is processing a previous sound request.
	bne.s	.doSFX	; So we'll wait until at least the next frame before putting anything in there.

	; If there's something in the first music queue slot, then play it.
	_move.b	SoundQueue.Music0(a0),d0
	beq.s	.checkMusic2
	_clr.b	SoundQueue.Music0(a0)
	bra.s	.playMusic
; ---------------------------------------------------------------------------
; loc_10A4:
.checkMusic2:
	; If there's something in the second music queue slot, then play it.
	move.b	SoundQueue.Music1(a0),d0
	beq.s	.doSFX
	clr.b	SoundQueue.Music1(a0)
; loc_10AE:
.playMusic:
	; If this is 'MusID_Pause' or 'MusID_Unpause', then this isn't a real
	; sound ID, and it shouldn't be passed to the driver. Instead, it
	; should be used here to manually set the driver's pause flag.
	move.b	d0,d1
	subi.b	#MusID_Pause,d1
	bcs.s	.isNotPauseCommand
	addi.b	#$7F,d1
	move.b	d1,zVar.StopMusic(a1)
	bra.s	.doSFX
; ---------------------------------------------------------------------------
; loc_10C0:
.isNotPauseCommand:
	; Send the music's sound ID to the driver.
	move.b	d0,zVar.QueueToPlay(a1)
; loc_10C4:
.doSFX:
	; Process the SFX queue.
    if fixBugs
	moveq	#3-1,d1
    else
	; This is too high: there is only room for three bytes in the
	; driver's queue. This causes the first byte of 'VoiceTblPtr' to be
	; overwritten.
	moveq	#4-1,d1
    endif

.loop:
	; If there's no sound queued, skip this slot.
	move.b	SoundQueue.SFX0(a0,d1.w),d0
	beq.s	.skip
	; If this slot in the driver's queue is occupied, skip this slot.
	tst.b	zVar.Queue0(a1,d1.w)
	bne.s	.skip
	; Remove the sound from this queue, and put it in the driver's queue.
	clr.b	SoundQueue.SFX0(a0,d1.w)
	move.b	d0,zVar.Queue0(a1,d1.w)

.skip:
	dbf	d1,.loop

	rts
; End of function sndDriverInput

	jmpTos JmpTo_LoadTilesAsYouMove,JmpTo_SegaScr_VInt




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


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1158:
VDPSetupGame:
	lea	(VDP_control_port).l,a0
	lea	(VDP_data_port).l,a1
	lea	(VDPSetupArray).l,a2
	moveq	#bytesToWcnt(VDPSetupArray_End-VDPSetupArray),d7
; loc_116C:
VDP_Loop:
	move.w	(a2)+,(a0)
	dbf	d7,VDP_Loop	; set the VDP registers

	move.w	(VDPSetupArray+2).l,d0	; get command for register #1
	move.w	d0,(VDP_Reg1_val).w	; and store it in RAM (for easy display blanking/enabling)
	move.w	#$8A00+223,(Hint_counter_reserve).w	; H-INT every 224th scanline
	moveq	#0,d0

	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.w	d0,(a1)
	move.w	d0,(a1)

	move.l	#vdpComm($0000,CRAM,WRITE),(VDP_control_port).l

	move.w	#bytesToWcnt(palette_line_size*4),d7
; loc_11A0:
VDP_ClrCRAM:
	move.w	d0,(a1)
	dbf	d7,VDP_ClrCRAM	; clear the CRAM

	clr.l	(Vscroll_Factor).w
	clr.l	(unk_F61A).w
	move.l	d1,-(sp)

	dmaFillVRAM 0,$0000,$10000	; fill entire VRAM with 0

	move.l	(sp)+,d1
	rts
; End of function VDPSetupGame

; ===========================================================================
; word_11E2:
VDPSetupArray:
	dc.w $8004		; H-INT disabled
	dc.w $8134		; Genesis mode, DMA enabled, VBLANK-INT enabled
	dc.w $8200|(VRAM_Plane_A_Name_Table/$400)	; PNT A base: $C000
	dc.w $8328		; PNT W base: $A000
	dc.w $8400|(VRAM_Plane_B_Name_Table/$2000)	; PNT B base: $E000
	dc.w $8500|(VRAM_Sprite_Attribute_Table/$200)	; Sprite attribute table base: $F800
	dc.w $8600
	dc.w $8700		; Background palette/color: 0/0
	dc.w $8800
	dc.w $8900
	dc.w $8A00		; H-INT every scanline
	dc.w $8B00		; EXT-INT off, V scroll by screen, H scroll by screen
	dc.w $8C81		; H res 40 cells, no interlace, S/H disabled
	dc.w $8D00|(VRAM_Horiz_Scroll_Table/$400)	; H scroll table base: $FC00
	dc.w $8E00
	dc.w $8F02		; VRAM pointer increment: $0002
	dc.w $9001		; Scroll table size: 64x32
	dc.w $9100		; Disable window
	dc.w $9200		; Disable window
VDPSetupArray_End:

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1208:
ClearScreen:
	stopZ80

	dmaFillVRAM 0,$0000,tiles_to_bytes(2)				; Fill first $40 bytes of VRAM with 0
	dmaFillVRAM 0,VRAM_Plane_A_Name_Table,VRAM_Plane_Table_Size	; Clear Plane A pattern name table
	dmaFillVRAM 0,VRAM_Plane_B_Name_Table,VRAM_Plane_Table_Size	; Clear Plane B pattern name table

	tst.w	(Two_player_mode).w
	beq.s	+

	dmaFillVRAM 0,VRAM_Plane_A_Name_Table_2P,VRAM_Plane_Table_Size
+
	clr.l	(Vscroll_Factor).w
	clr.l	(unk_F61A).w

    if fixBugs
	clearRAM Sprite_Table,Sprite_Table_End
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len
    else
	; These '+4's shouldn't be here; clearRAM accidentally clears an additional 4 bytes
	clearRAM Sprite_Table,Sprite_Table_End+4
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len+4
    endif

	startZ80
	rts
; End of function ClearScreen


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; JumpTo load the sound driver
; sub_130A:
JmpTo_SoundDriverLoad ; JmpTo
	nop
	jmp	(SoundDriverLoad).l
; End of function JmpTo_SoundDriverLoad

; ===========================================================================
; unused mostly-leftover subroutine to load the sound driver
; SoundDriverLoadS1:
	move.w	#$100,(Z80_Bus_Request).l ; stop the Z80
	move.w	#$100,(Z80_Reset).l ; reset the Z80
	lea	(Z80_RAM).l,a1
	move.b	#$F3,(a1)+	; di
	move.b	#$F3,(a1)+	; di
	move.b	#$C3,(a1)+	; jp
	move.b	#0,(a1)+	; jp address low byte
	move.b	#0,(a1)+	; jp address high byte
	move.w	#0,(Z80_Reset).l
	nop
	nop
	nop
	nop
	move.w	#$100,(Z80_Reset).l ; reset the Z80
	move.w	#0,(Z80_Bus_Request).l ; start the Z80
	rts

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

; ---------------------------------------------------------------------------
; Subroutine to pause the game
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1388:
PauseGame:
	nop
	tst.b	(Life_count).w	; do you have any lives left?
	beq.w	Unpause		; if not, branch
    if fixBugs
	; The game still lets you pause if player 2 got a Game Over, or if
	; either player got a Time Over. The following code fixes this.
	tst.b	(Life_count_2P).w
	beq.w	Unpause
	tst.b	(Time_Over_flag).w
	bne.w	Unpause
	tst.b   (Time_Over_flag_2P).w
	bne.w   Unpause
    endif
	tst.w	(Game_paused).w	; is game already paused?
	bne.s	+		; if yes, branch
	move.b	(Ctrl_1_Press).w,d0 ; is Start button pressed?
	or.b	(Ctrl_2_Press).w,d0 ; (either player)
	andi.b	#button_start_mask,d0
	beq.s	Pause_DoNothing	; if not, branch
+
	move.w	#1,(Game_paused).w	; freeze time
	move.b	#MusID_Pause,(Sound_Queue.Music0).w	; pause music
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
	move.b	#MusID_Unpause,(Sound_Queue.Music0).w	; unpause the music
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
	move.b	#MusID_Unpause,(Sound_Queue.Music0).w
	rts
; End of function PauseGame

; ---------------------------------------------------------------------------
; Subroutine to transfer a plane map to VRAM
; ---------------------------------------------------------------------------

; control register:
;    CD1 CD0 A13 A12 A11 A10 A09 A08     (D31-D24)
;    A07 A06 A05 A04 A03 A02 A01 A00     (D23-D16)
;     ?   ?   ?   ?   ?   ?   ?   ?      (D15-D8)
;    CD5 CD4 CD3 CD2  ?   ?  A15 A14     (D7-D0)
;
;	A00-A15 - address
;	CD0-CD3 - code
;	CD4 - 1 if VRAM copy DMA mode. 0 otherwise.
;	CD5 - DMA operation
;
;	Bits CD3-CD0:
;	0000 - VRAM read
;	0001 - VRAM write
;	0011 - CRAM write
;	0100 - VSRAM read
;	0101 - VSRAM write
;	1000 - CRAM read
;
; d0 = control register
; d1 = width
; d2 = heigth
; a1 = source address

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_140E: ShowVDPGraphics: PlaneMapToVRAM:
PlaneMapToVRAM_H40:
	lea	(VDP_data_port).l,a6
	move.l	#vdpCommDelta(planeLoc(64,0,1)),d4	; $800000

-	move.l	d0,VDP_control_port-VDP_data_port(a6)	; move d0 to VDP_control_port
	move.w	d1,d3

-	move.w	(a1)+,(a6)	; from source address to destination in VDP
	dbf	d3,-		; next tile

	add.l	d4,d0		; increase destination address by $80 (1 line)
	dbf	d2,--		; next line

	rts
; End of function PlaneMapToVRAM_H40

; ---------------------------------------------------------------------------
; Alternate subroutine to transfer a plane map to VRAM
; (used for Special Stage background)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_142E: ShowVDPGraphics2: PlaneMapToVRAM2:
PlaneMapToVRAM_H80_SpecialStage:
	lea	(VDP_data_port).l,a6
	move.l	#vdpCommDelta(planeLoc(128,0,1)),d4	; $1000000
-	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d1,d3
-	move.w	(a1)+,(a6)
	dbf	d3,-
	add.l	d4,d0
	dbf	d2,--
	rts
; End of function PlaneMapToVRAM_H80_SpecialStage


; ---------------------------------------------------------------------------
; Subroutine for queueing VDP commands (seems to only queue transfers to VRAM),
; to be issued the next time ProcessDMAQueue is called.
; Can be called a maximum of 18 times before the buffer needs to be cleared
; by issuing the commands (this subroutine DOES check for overflow)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_144E: DMA_68KtoVRAM: QueueCopyToVRAM: QueueVDPCommand: Add_To_DMA_Queue:
QueueDMATransfer:
	movea.l	(VDP_Command_Buffer_Slot).w,a1
	cmpa.w	#VDP_Command_Buffer_Slot,a1
	beq.s	.return ; return if there's no more room in the buffer

	; piece together some VDP commands and store them for later...
	move.w	#$9300,d0 ; command to specify DMA transfer length & $00FF
	move.b	d3,d0
	move.w	d0,(a1)+ ; store command

	move.w	#$9400,d0 ; command to specify DMA transfer length & $FF00
	lsr.w	#8,d3
	move.b	d3,d0
	move.w	d0,(a1)+ ; store command

	move.w	#$9500,d0 ; command to specify source address & $0001FE
	lsr.l	#1,d1
	move.b	d1,d0
	move.w	d0,(a1)+ ; store command

	move.w	#$9600,d0 ; command to specify source address & $01FE00
	lsr.l	#8,d1
	move.b	d1,d0
	move.w	d0,(a1)+ ; store command

	move.w	#$9700,d0 ; command to specify source address & $FE0000
	lsr.l	#8,d1
	;andi.b	#$7F,d1		; this instruction safely allows source to be in RAM; S3K added this
	move.b	d1,d0
	move.w	d0,(a1)+ ; store command

	andi.l	#$FFFF,d2 ; command to specify destination address and begin DMA
	lsl.l	#2,d2
	lsr.w	#2,d2
	swap	d2
	ori.l	#vdpComm($0000,VRAM,DMA),d2 ; set bits to specify VRAM transfer
	move.l	d2,(a1)+ ; store command

	move.l	a1,(VDP_Command_Buffer_Slot).w ; set the next free slot address
	cmpa.w	#VDP_Command_Buffer_Slot,a1
	beq.s	.return ; return if there's no more room in the buffer
	move.w	#0,(a1) ; put a stop token at the end of the used part of the buffer
; return_14AA: QueueDMATransfer_Done:
.return:
	rts
; End of function QueueDMATransfer


; ---------------------------------------------------------------------------
; Subroutine for issuing all VDP commands that were queued
; (by earlier calls to QueueDMATransfer)
; Resets the queue when it's done
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_14AC: CopyToVRAM: IssueVDPCommands: Process_DMA: Process_DMA_Queue:
ProcessDMAQueue:
	lea	(VDP_control_port).l,a5
	lea	(VDP_Command_Buffer).w,a1
; loc_14B6: ProcessDMAQueue_Loop:
.loop
	move.w	(a1)+,d0
	beq.s	.done ; branch if we reached a stop token
	; issue a set of VDP commands...
	move.w	d0,(a5)		; transfer length
	move.w	(a1)+,(a5)	; transfer length
	move.w	(a1)+,(a5)	; source address
	move.w	(a1)+,(a5)	; source address
	move.w	(a1)+,(a5)	; source address
	move.w	(a1)+,(a5)	; destination
	move.w	(a1)+,(a5)	; destination
	cmpa.w	#VDP_Command_Buffer_Slot,a1
	bne.s	.loop ; loop if we haven't reached the end of the buffer
; loc_14CE: ProcessDMAQueue_Done:
.done:
	move.w	#0,(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	rts
; End of function ProcessDMAQueue

	include "_inc/Nemesis Decompressor.asm"

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; ---------------------------------------------------------------------------
; Subroutine to load pattern load cues (aka to queue pattern load requests)
; ---------------------------------------------------------------------------

; ARGUMENTS
; d0 = index of PLC list (see ArtLoadCues)

; NOTICE: This subroutine does not check for buffer overruns. The programmer
;         (or hacker) is responsible for making sure that no more than
;         16 load requests are copied into the buffer.
;         _________DO NOT PUT MORE THAN 16 LOAD REQUESTS IN A LIST!__________
;         (or if you change the size of Plc_Buffer, the limit becomes (Plc_Buffer_Only_End-Plc_Buffer)/6)

; sub_161E: PLCLoad: AddPLC:
LoadPLC:
	movem.l	a1-a2,-(sp)
	lea	(ArtLoadCues).l,a1
	add.w	d0,d0
	move.w	(a1,d0.w),d0
	lea	(a1,d0.w),a1	; jump to relevant PLC
	lea	(Plc_Buffer).w,a2

	; exit this loop when we find space available in RAM
.findFreeSpaceLoop:
	tst.l	(a2)	; is space available in RAM ?
	beq.s	.foundFreeSpace ; if it's zero, exit this loop
	addq.w	#6,a2	; try next space
	bra.s	.findFreeSpaceLoop

	; the PLC is only copied to RAM if it has a positive length
.foundFreeSpace:
	move.w	(a1)+,d0	; get PLC length
	bmi.s	.return ; if it's negative, skip the next loop

.copyPLCLoop:
	move.l	(a1)+,(a2)+
	move.w	(a1)+,(a2)+	; copy PLC to RAM
	dbf	d0,.copyPLCLoop	; repeat for the whole length of the PLC

.return:
	movem.l	(sp)+,a1-a2 ; a1=object
	rts
; End of function LoadPLC


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Queue pattern load requests, but clear the PLQ first

; ARGUMENTS
; d0 = index of PLC list (see ArtLoadCues)

; NOTICE: This subroutine does not check for buffer overruns. The programmer
;         (or hacker) is responsible for making sure that no more than
;         16 load requests are copied into the buffer.
;         _________DO NOT PUT MORE THAN 16 LOAD REQUESTS IN A LIST!__________
;         (or if you change the size of Plc_Buffer, the limit becomes (Plc_Buffer_Only_End-Plc_Buffer)/6)
; sub_1650:
LoadPLC2:
	movem.l	a1-a2,-(sp)
	lea	(ArtLoadCues).l,a1
	add.w	d0,d0
	move.w	(a1,d0.w),d0
	lea	(a1,d0.w),a1	; jump to relevant PLC
	bsr.s	ClearPLC	; erase any data in PLC buffer space
	lea	(Plc_Buffer).w,a2

	; the PLC is only copied to RAM if it has a positive length
	move.w	(a1)+,d0	; get PLC length
	bmi.s	.return ; if it's negative, skip the next loop

.copyPLCLoop:
	move.l	(a1)+,(a2)+
	move.w	(a1)+,(a2)+
	dbf	d0,.copyPLCLoop

.return:
	movem.l	(sp)+,a1-a2
	rts
; End of function LoadPLC2


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Clear the pattern load queue ($FFF680 - $FFF700)

ClearPLC:
	lea	(Plc_Buffer).w,a2

	moveq	#bytesToLcnt(Plc_Buffer_End-Plc_Buffer),d0
-	clr.l	(a2)+
	dbf	d0,-

	rts
; End of function ClearPLC

; ---------------------------------------------------------------------------
; Subroutine to use graphics listed in a pattern load cue
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_168A:
RunPLC_RAM:
	; Immediately returns if the queue is empty or processing of a previous piece is still ongoing
	tst.l	(Plc_Buffer).w
	beq.s	.return
	tst.w	(Plc_PatternsLeft).w
	bne.s	.return

	movea.l	(Plc_Buffer).w,a0
	lea_	NemDec_WriteAndStay,a3
	nop
	lea	(Decomp_Buffer).w,a1
	move.w	(a0)+,d2
	bpl.s	+
	adda.w	#NemDec_WriteAndStay_XOR-NemDec_WriteAndStay,a3
+
	andi.w	#$7FFF,d2
    if ~~fixBugs
	; This is done too early: this variable is used to determine when
	; there are PLCs to process, which means that as soon as this
	; variable is set, PLC processing will occur during V-Int. If an
	; interrupt occurs between here and the end of this function, then
	; the PLC processor will begin despite it not being fully
	; initialised yet, causing a crash. S3K fixes this bug by moving this
	; instruction to the end of the function.
	move.w	d2,(Plc_PatternsLeft).w
    endif

	bsr.w	NemDecPrepare
	move.b	(a0)+,d5
	asl.w	#8,d5
	move.b	(a0)+,d5
	moveq	#$10,d6
	moveq	#0,d0
	move.l	a0,(Plc_Buffer).w
	move.l	a3,(Plc_PtrNemCode).w
	move.l	d0,(Plc_RepeatCount).w
	move.l	d0,(Plc_PaletteIndex).w
	move.l	d0,(Plc_PreviousRow).w
	move.l	d5,(Plc_DataWord).w
	move.l	d6,(Plc_ShiftValue).w
    if fixBugs
	; See above.
	move.w	d2,(Plc_PatternsLeft).w
    endif

.return:
	rts
; End of function RunPLC_RAM


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Process one PLC from the queue

; sub_16E0:
ProcessDPLC:
	; In Sonic 1, ProcessDPLC processed 9 patterns per frame, however Sonic 2
	; instead only processes 6 patterns. It's possible this was made as an
	; attempt to sidestep the PLC race conditions, or the occasional lag that
	; could happen when decompressing the explosion graphics.
	tst.w	(Plc_PatternsLeft).w
	beq.w	+	; rts
	move.w	#6,(Plc_FramePatternsLeft).w	; 6 patterns are decompressed every frame
	moveq	#0,d0
	move.w	(Plc_Buffer+4).w,d0
	addi.w	#6*$20,(Plc_Buffer+4).w	; increment by 6 patterns's worth of data
	bra.s	ProcessDPLC_Main

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Process one PLC from the queue

; loc_16FC:
ProcessDPLC2:
	tst.w	(Plc_PatternsLeft).w
	beq.s	+	; rts
	move.w	#3,(Plc_FramePatternsLeft).w
	moveq	#0,d0
	move.w	(Plc_Buffer+4).w,d0
	addi.w	#$60,(Plc_Buffer+4).w

; loc_1714:
ProcessDPLC_Main:
	lea	(VDP_control_port).l,a4
	lsl.l	#2,d0		; set up target VRAM address
	lsr.w	#2,d0
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d0
	swap	d0
	move.l	d0,(a4)
	subq.w	#4,a4
	movea.l	(Plc_Buffer).w,a0
	movea.l	(Plc_PtrNemCode).w,a3
	move.l	(Plc_RepeatCount).w,d0
	move.l	(Plc_PaletteIndex).w,d1
	move.l	(Plc_PreviousRow).w,d2
	move.l	(Plc_DataWord).w,d5
	move.l	(Plc_ShiftValue).w,d6
	lea	(Decomp_Buffer).w,a1

-	movea.w	#8,a5
	bsr.w	NemDecRun.writePixelLoopEntry
	subq.w	#1,(Plc_PatternsLeft).w
	beq.s	ProcessDPLC_Pop
	subq.w	#1,(Plc_FramePatternsLeft).w
	bne.s	-

	move.l	a0,(Plc_Buffer).w
	move.l	a3,(Plc_PtrNemCode).w
	move.l	d0,(Plc_RepeatCount).w
	move.l	d1,(Plc_PaletteIndex).w
	move.l	d2,(Plc_PreviousRow).w
	move.l	d5,(Plc_DataWord).w
	move.l	d6,(Plc_ShiftValue).w
+
	rts

; ===========================================================================
; pop one request off the buffer so that the next one can be filled

; loc_177A:
ProcessDPLC_Pop:
	lea	(Plc_Buffer).w,a0
	moveq	#bytesToLcnt(Plc_Buffer_Only_End-Plc_Buffer-6),d0
-	move.l	6(a0),(a0)+
	dbf	d0,-

    if fixBugs
	; The above code does not properly 'pop' the 16th PLC entry.
	; Because of this, occupying the 16th slot will cause it to
	; be repeatedly decompressed infinitely.
	; Granted, this could be conisdered more of an optimisation
	; than a bug: treating the 16th entry as a dummy that
	; should never be occupied makes this code unnecessary.
	; Still, the overhead of this code is minimal.
    if (Plc_Buffer_Only_End-Plc_Buffer-6)&2
	move.w	6(a0),(a0)
    endif

	clr.l	(Plc_Buffer_Only_End-6).w
    endif

	rts

; End of function ProcessDPLC


; ---------------------------------------------------------------------------
; Subroutine to execute a pattern load cue directly from the ROM
; rather than loading them into the queue first
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

RunPLC_ROM:
	lea	(ArtLoadCues).l,a1
	add.w	d0,d0
	move.w	(a1,d0.w),d0
	lea	(a1,d0.w),a1

	move.w	(a1)+,d1
-	movea.l	(a1)+,a0	; get source address
	moveq	#0,d0
	move.w	(a1)+,d0	; get destination VRAM address
	lsl.l	#2,d0
	lsr.w	#2,d0
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d0
	swap	d0	; d0 = VDP command to write to destination
	move.l	d0,(VDP_control_port).l
	bsr.w	NemDec
	dbf	d1,-

	rts
; End of function RunPLC_ROM

	include "_inc/Enigma Decompressor.asm"
	include "_inc/Kosinski Decompressor.asm"

	include "_inc/Palette Cycle.asm"
	include "_inc/Palette Fade and Load.asm"
	include "_inc/Palette Pointers.asm"

; ---------------------------------------------------------------------------
; Subroutine to perform vertical synchronization
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_3384: DelayProgram:
WaitForVint:
	move	#$2300,sr

-	tst.b	(Vint_routine).w
	bne.s	-
	rts
; End of function WaitForVint


; ---------------------------------------------------------------------------
; Subroutine to generate a pseudo-random number in d0
; d0 = (RNG & $FFFF0000) | ((RNG*41 & $FFFF) + ((RNG*41 & $FFFF0000) >> 16))
; RNG = ((RNG*41 + ((RNG*41 & $FFFF) << 16)) & $FFFF0000) | (RNG*41 & $FFFF)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_3390:
RandomNumber:
	move.l	(RNG_seed).w,d1
	bne.s	.afterSanity0ResetCheck
	move.l	#$2A6D365A,d1 ; if the RNG is 0, reset it to this crazy number

	; set the high word of d0 to be the high word of the RNG
	; and multiply the RNG by 41
.afterSanity0ResetCheck:
	move.l	d1,d0
	asl.l	#2,d1
	add.l	d0,d1
	asl.l	#3,d1
	add.l	d0,d1

	; add the low word of the RNG to the high word of the RNG
	; and set the low word of d0 to be the result
	move.w	d1,d0
	swap	d1
	add.w	d1,d0
	move.w	d0,d1
	swap	d1

	move.l	d1,(RNG_seed).w
	rts
; End of function RandomNumber

	include "_incObj/sub CalcSine.asm"
	include "_incObj/sub CalcAngle.asm"

; loc_37B8:
SegaScreen:
	move.b	#MusID_Stop,d0
	bsr.w	PlayMusic ; stop music
	bsr.w	ClearPLC
	bsr.w	Pal_FadeToBlack

	clearRAM Misc_Variables,Misc_Variables_End

	clearRAM Object_RAM,Object_RAM_End ; fill object RAM with 0

	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8200|(VRAM_SegaScr_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_SegaScr_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $A000
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	move.w	#$8B03,(a6)		; EXT-INT disabled, V scroll by screen, H scroll by line
	move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled
	move.w	#$9003,(a6)		; Scroll table size: 128x32 ($2000 bytes)
	clr.b	(Water_fullscreen_flag).w
	clr.w	(Two_player_mode).w
	move	#$2700,sr
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	ClearScreen

	dmaFillVRAM 0,VRAM_SegaScr_Plane_A_Name_Table,VRAM_SegaScr_Plane_Table_Size ; clear Plane A pattern name table

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Sega_Logo),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_SEGA).l,a0
	bsr.w	NemDec

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Trails),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_IntroTrails).l,a0
	bsr.w	NemDec

	; This gets overwritten by the upscaled Sonic sprite. This may have
	; been used to test the Sega screen before the sprite upscaling logic
	; was added.
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtUnc_Giant_Sonic),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_SilverSonic).l,a0
	bsr.w	NemDec

	lea	(Chunk_Table).l,a1
	lea	(MapEng_SEGA).l,a0
	move.w	#make_art_tile(ArtTile_VRAM_Start,0,0),d0
	bsr.w	EniDec

	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_SegaScr_Plane_B_Name_Table,VRAM,WRITE),d0
	moveq	#40-1,d1	; 40 cells wide
	moveq	#28-1,d2	; 28 cells tall
	bsr.w	PlaneMapToVRAM_H80_Sega

	tst.b	(Graphics_Flags).w ; are we on a Japanese Mega Drive?
	bmi.s	SegaScreen_Contin ; if not, branch

	; load an extra sprite to hide the TM (trademark) symbol on the SEGA screen
	lea	(SegaHideTM).w,a1
	move.b	#ObjID_SegaHideTM,id(a1)	; load objB1 at $FFFFB080
	move.b	#$4E,subtype(a1) ; <== ObjB1_SubObjData
; loc_38CE:
SegaScreen_Contin:
	moveq	#PalID_SEGA,d0
	bsr.w	PalLoad_Now
	move.w	#-$A,(PalCycle_Frame).w
	move.w	#0,(PalCycle_Timer).w
	move.w	#0,(SegaScr_VInt_Subrout).w
	move.w	#0,(SegaScr_PalDone_Flag).w
	lea	(SegaScreenObject).w,a1
	move.b	#ObjID_SonicOnSegaScr,id(a1) ; load objB0 (sega screen?) at $FFFFB040
	move.b	#$4C,subtype(a1) ; <== ObjB0_SubObjData
	move.w	#4*60,(Demo_Time_left).w	; 4 seconds
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
; loc_390E:
Sega_WaitPalette:
	move.b	#VintID_SEGA,(Vint_routine).w
	bsr.w	WaitForVint
	jsrto	JmpTo_RunObjects
	jsr	(BuildSprites).l
	tst.b	(SegaScr_PalDone_Flag).w
	beq.s	Sega_WaitPalette
    if ~~fixBugs
	; This is a leftover from Sonic 1: ObjB0 plays the Sega sound now.
	; Normally, you'll only hear one Sega sound, but the game actually
	; tries to play it twice. The only reason it doesn't is because the
	; sound queue only has room for one sound per frame. Some custom
	; sound drivers don't have this limitation, however, and the sound
	; will indeed play twice in those.
	move.b	#SndID_SegaSound,d0
	bsr.w	PlaySound	; play "SEGA" sound
    endif
	move.b	#VintID_SEGA,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	#3*60,(Demo_Time_left).w	; 3 seconds
; loc_3940:
Sega_WaitEnd:
	move.b	#VintID_PCM,(Vint_routine).w
	bsr.w	WaitForVint
	tst.w	(Demo_Time_left).w
	beq.s	Sega_GotoTitle
	move.b	(Ctrl_1_Press).w,d0	; is Start button pressed?
	or.b	(Ctrl_2_Press).w,d0	; (either player)
	andi.b	#button_start_mask,d0
	beq.s	Sega_WaitEnd		; if not, branch
; loc_395E:
Sega_GotoTitle:
	clr.w	(SegaScr_PalDone_Flag).w
	clr.w	(SegaScr_VInt_Subrout).w
	move.b	#GameModeID_TitleScreen,(Game_Mode).w	; => TitleScreen
	rts

; ---------------------------------------------------------------------------
; Subroutine that does the exact same thing as PlaneMapToVRAM_H80_SpecialStage
; (this one is used at the Sega screen)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_396E: ShowVDPGraphics3: PlaneMapToVRAM3:
PlaneMapToVRAM_H80_Sega:
	lea	(VDP_data_port).l,a6
	move.l	#vdpCommDelta(planeLoc(128,0,1)),d4	; $1000000
-	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d1,d3
-	move.w	(a1)+,(a6)
	dbf	d3,-
	add.l	d4,d0
	dbf	d2,--
	rts
; End of function PlaneMapToVRAM_H80_Sega

; ===========================================================================

	jmpTos JmpTo_RunObjects




; ===========================================================================
; loc_3998:
TitleScreen:
	; Stop music.
	move.b	#MusID_Stop,d0
	bsr.w	PlayMusic

	; Clear the PLC queue, preventing any PLCs from before loading after this point.
	bsr.w	ClearPLC

	; Fade out.
	bsr.w	Pal_FadeToBlack

	; Disable interrupts, so that we can have exclusive access to the VDP.
	move	#$2700,sr

	; Configure the VDP for this screen mode.
	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8200|(VRAM_TtlScr_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_TtlScr_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $E000
	move.w	#$9001,(a6)		; Scroll table size: 64x32
	move.w	#$9200,(a6)		; Disable window
	move.w	#$8B03,(a6)		; EXT-INT disabled, V scroll by screen, H scroll by line
	move.w	#$8720,(a6)		; Background palette/color: 2/0

	clr.b	(Water_fullscreen_flag).w

	move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled

	; Reset plane maps, sprite table, and scroll tables.
	bsr.w	ClearScreen

	; Reset a bunch of engine state.
	clearRAM Object_Display_Lists,Object_Display_Lists_End ; fill $AC00-$AFFF with $0
	clearRAM Object_RAM,Object_RAM_End ; fill object RAM ($B000-$D5FF) with $0
	clearRAM Misc_Variables,Misc_Variables_End ; clear CPU player RAM and following variables
	clearRAM Camera_RAM,Camera_RAM_End ; clear camera RAM and following variables

	; Load the credit font for the following text.
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_CreditText),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_CreditText).l,a0
	bsr.w	NemDec

	; Load the 'Sonic and Miles 'Tails' Prower in' text.
	lea	(off_B2B0).l,a1
	jsr	(loc_B272).l

	; Fade-in, showing the text that was just loaded.
	clearRAM Target_palette,Target_palette_End	; fill palette with 0 (black)
	moveq	#PalID_BGND,d0
	bsr.w	PalLoad_ForFade
	bsr.w	Pal_FadeFromBlack

	; 'Pal_FadeFromBlack' enabled the interrupts, so disable them again
	; so that we have exclusive access to the VDP for the following calls
	; to the Nemesis decompressor.
	move	#$2700,sr

	; Load assets while the above text is being displayed.
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Title),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Title).l,a0
	bsr.w	NemDec

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_TitleSprites),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_TitleSprites).l,a0
	bsr.w	NemDec

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_MenuJunk),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_MenuJunk).l,a0
	bsr.w	NemDec

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Player1VS2),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Player1VS2).l,a0
	bsr.w	NemDec

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_FontStuff_TtlScr),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_FontStuff).l,a0
	bsr.w	NemDec

	; Clear some variables.
	move.b	#0,(Last_star_pole_hit).w
	move.b	#0,(Last_star_pole_hit_2P).w
	move.w	#0,(Debug_placement_mode).w
	move.w	#0,(Demo_mode_flag).w
	move.w	#0,(unk_FFDA).w
	move.w	#0,(PalCycle_Timer).w
	move.w	#0,(Two_player_mode).w
	move.b	#0,(Level_started_flag).w

	; And finally fade out.
	bsr.w	Pal_FadeToBlack

	; 'Pal_FadeToBlack' enabled the interrupts, so disable them again
	; so that we have exclusive access to the VDP for the following calls
	; to the plane map loader.
	move	#$2700,sr

	; Decompress the first part of the title screen background plane map...
	lea	(Chunk_Table).l,a1
	lea	(MapEng_TitleScreen).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_Title,2,0),d0
	bsr.w	EniDec

	; ...and send it to VRAM.
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_TtlScr_Plane_B_Name_Table,VRAM,WRITE),d0
	moveq	#40-1,d1 ; Width
	moveq	#28-1,d2 ; Height
    if removeJmpTos
	jsr	(PlaneMapToVRAM_H40).l
    else
	bsr.w	PlaneMapToVRAM_H40
    endif

	; Decompress the second part of the title screen background plane map...
	lea	(Chunk_Table).l,a1
	lea	(MapEng_TitleBack).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_Title,2,0),d0
	bsr.w	EniDec

	; ...and send it to VRAM.
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_TtlScr_Plane_B_Name_Table+planeLoc(64,40,0),VRAM,WRITE),d0
	moveq	#24-1,d1 ; Width
	moveq	#28-1,d2 ; Height
    if removeJmpTos
	jsr	(PlaneMapToVRAM_H40).l
    else
	bsr.w	PlaneMapToVRAM_H40
    endif

	; Decompress the title screen emblem plane map...
	lea	(Chunk_Table).l,a1
	lea	(MapEng_TitleLogo).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_Title,3,1),d0
	bsr.w	EniDec

	; ...add the copyright text to it...
	lea	(Chunk_Table+planeLoc(40,28,26)).l,a1
	lea	(CopyrightText).l,a2
	moveq	#bytesToWcnt(CopyrightText_End-CopyrightText),d6
-	move.w	(a2)+,(a1)+
	dbf	d6,-

	; ...and send it to VRAM.
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_TtlScr_Plane_A_Name_Table,VRAM,WRITE),d0
	moveq	#40-1,d1 ; Width
	moveq	#28-1,d2 ; Height
    if removeJmpTos
	jsr	(PlaneMapToVRAM_H40).l
    else
	bsr.w	PlaneMapToVRAM_H40
    endif

	; Clear the palette.
	clearRAM Normal_palette,Target_palette_End

	; Load the title screen palette, so we can fade into it later.
	moveq	#PalID_Title,d0
	bsr.w	PalLoad_ForFade

	; Reset some variables.
	move.b	#0,(Debug_mode_flag).w
	move.w	#0,(Two_player_mode).w

	; Set the time that the title screen lasts (little over ten seconds).
	move.w	#60*10+40,(Demo_Time_left).w

	; Clear the player's inputs, to prevent a leftover input from
	; skipping the intro.
	clr.w	(Ctrl_1).w

	; Load the object responsible for the intro animation.
	move.b	#ObjID_TitleIntro,(IntroSonic+id).w
	move.b	#2,(IntroSonic+subtype).w

	; Run it for a frame, so that it initialises.
	jsr	(RunObjects).l
	jsr	(BuildSprites).l

	; Load some standard sprites.
	moveq	#PLCID_Std1,d0
	bsr.w	LoadPLC2

	; Reset the cheat input state.
	move.w	#0,(Correct_cheat_entries).w
	move.w	#0,(Correct_cheat_entries_2).w

    if 0
	; Sonic 2 Beta 4 reveals that these were the original instructions.
	; The original source code may have been able to produce debug builds with this enabled.
	move.w	#$101,(Level_select_flag).w
	move.w	#$101,(Debug_mode_flag).w
    else
	nop
	nop
	nop
	nop
	nop
	nop
    endif

	; Reset Sonic's position record buffer.
	move.w	#4,(Sonic_Pos_Record_Index).w
	move.w	#0,(Sonic_Pos_Record_Buf).w

	; Reset the two player mode results data.
	lea	(Results_Data_2P).w,a1
	moveq	#bytesToWcnt(Results_Data_2P_End-Results_Data_2P),d0
-	move.w	#-1,(a1)+
	dbf	d0,-

	; Initialise the camera's X position.
	move.w	#-$280,(Camera_X_pos).w

	; Enable the VDP's display.
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l

	; Fade into the palette that was loaded earlier.
	bsr.w	Pal_FadeFromBlack

; loc_3C14:
TitleScreen_Loop:
	move.b	#VintID_Title,(Vint_routine).w
	bsr.w	WaitForVint

	jsr	(RunObjects).l
	jsrto	JmpTo_SwScrl_Title
	jsr	(BuildSprites).l

	; Find the masking sprite, and move it to the proper location. The
	; sprite is normally at X 128+128, but in order to perform masking,
	; it must be at X 0.
	; The masking sprite is used to stop Sonic and Tails from overlapping
	; the emblem.
	; You might be wondering why it alternates between 0 and 4 for the X
	; position. That's because masking sprites only work if another
	; sprite rendered before them (or if the previous scanline reached
	; its pixel limit). Because of this, a sprite is placed at X 4 before
	; a second one is placed at X 0.
	lea	(Sprite_Table+4).w,a1
	moveq	#0,d0

	moveq	#(Sprite_Table_End-Sprite_Table)/8-1,d6
-	tst.w	(a1)	; The masking sprite has its art-tile set to $0000.
	bne.s	+
	bchg	#2,d0	; Alternate between X positions of 0 and 4.
	move.w	d0,2(a1)
+	addq.w	#8,a1
	dbf	d6,-

	bsr.w	RunPLC_RAM
	bsr.w	TailsNameCheat

	; If the timer has run out, go play a demo.
	tst.w	(Demo_Time_left).w
	beq.w	TitleScreen_Demo

	; If the intro is still playing, then don't let the start button
	; begin the game.
	tst.b	(IntroSonic+obj0e_intro_complete).w
	beq.w	TitleScreen_Loop

	; If the start button has not been pressed, then loop back and keep
	; running the title screen.
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0
	beq.w	TitleScreen_Loop ; loop until Start is pressed

	; At this point, the start button has been pressed and it's time to
	; enter one player mode, two player mode, or the options menu.

	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)

	move.b	#3,(Life_count).w
	move.b	#3,(Life_count_2P).w

	moveq	#0,d0
	move.w	d0,(Ring_count).w
	move.l	d0,(Timer).w
	move.l	d0,(Score).w
	move.w	d0,(Ring_count_2P).w
	move.l	d0,(Timer_2P).w
	move.l	d0,(Score_2P).w
	move.b	d0,(Continue_count).w

	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w

	move.b	#MusID_FadeOut,d0 ; prepare to stop music (fade out)
	bsr.w	PlaySound

	moveq	#0,d0
	move.b	(Title_screen_option).w,d0
	bne.s	TitleScreen_CheckIfChose2P	; branch if not a 1-player game

	moveq	#0,d0
	move.w	d0,(Two_player_mode_copy).w
	move.w	d0,(Two_player_mode).w
    if emerald_hill_zone_act_1=0
	move.w	d0,(Current_ZoneAndAct).w ; emerald_hill_zone_act_1
    else
	move.w	#emerald_hill_zone_act_1,(Current_ZoneAndAct).w
    endif
	tst.b	(Level_select_flag).w	; has level select cheat been entered?
	beq.s	+			; if not, branch
	btst	#button_A,(Ctrl_1_Held).w ; is A held down?
	beq.s	+	 		; if not, branch
	move.b	#GameModeID_LevelSelect,(Game_Mode).w ; => LevelSelectMenu
	rts
; ---------------------------------------------------------------------------
+
	move.w	d0,(Current_Special_StageAndAct).w
	move.w	d0,(Got_Emerald).w
	move.l	d0,(Got_Emeralds_array).w
	move.l	d0,(Got_Emeralds_array+4).w
	rts
; ===========================================================================
; loc_3CF6:
TitleScreen_CheckIfChose2P:
	subq.b	#1,d0
	bne.s	TitleScreen_ChoseOptions

	moveq	#1,d1
	move.w	d1,(Two_player_mode_copy).w
	move.w	d1,(Two_player_mode).w

	moveq	#0,d0
	move.w	d0,(Got_Emerald).w
	move.l	d0,(Got_Emeralds_array).w
	move.l	d0,(Got_Emeralds_array+4).w

	move.b	#GameModeID_2PLevelSelect,(Game_Mode).w ; => LevelSelectMenu2P
	move.b	#0,(Current_Zone_2P).w
	rts
; ---------------------------------------------------------------------------
; loc_3D20:
TitleScreen_ChoseOptions:
	move.b	#GameModeID_OptionsMenu,(Game_Mode).w ; => OptionsMenu
	move.b	#0,(Options_menu_box).w
	rts
; ===========================================================================
; loc_3D2E:
TitleScreen_Demo:
	move.b	#MusID_FadeOut,d0
	bsr.w	PlaySound

	move.w	(Demo_number).w,d0
	andi.w	#7,d0
	add.w	d0,d0
	move.w	DemoLevels(pc,d0.w),d0
	move.w	d0,(Current_ZoneAndAct).w

	addq.w	#1,(Demo_number).w
	cmpi.w	#(DemoLevels_End-DemoLevels)/2,(Demo_number).w
	blo.s	+
	move.w	#0,(Demo_number).w
+
	move.w	#1,(Demo_mode_flag).w
	move.b	#GameModeID_Demo,(Game_Mode).w ; => Level (Demo mode)
	cmpi.w	#emerald_hill_zone_act_1,(Current_ZoneAndAct).w
	bne.s	+
	move.w	#1,(Two_player_mode).w
+
	move.b	#3,(Life_count).w
	move.b	#3,(Life_count_2P).w

	moveq	#0,d0
	move.w	d0,(Ring_count).w
	move.l	d0,(Timer).w
	move.l	d0,(Score).w
	move.w	d0,(Ring_count_2P).w
	move.l	d0,(Timer_2P).w
	move.l	d0,(Score_2P).w

	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w

	rts
; ===========================================================================
; word_3DAC:
DemoLevels:
	dc.w	emerald_hill_zone_act_1		; EHZ (2P)
	dc.w	chemical_plant_zone_act_1	; CPZ
	dc.w	aquatic_ruin_zone_act_1		; ARZ
	dc.w	casino_night_zone_act_1		; CNZ
DemoLevels_End:

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_3DB4:
TailsNameCheat:
	lea	(TailsNameCheat_Buttons).l,a0
	move.w	(Correct_cheat_entries).w,d0
	adda.w	d0,a0
	move.b	(Ctrl_1_Press).w,d0
	andi.b	#button_up_mask|button_down_mask|button_left_mask|button_right_mask,d0
	beq.s	++	; rts
	cmp.b	(a0),d0
	bne.s	+
	addq.w	#1,(Correct_cheat_entries).w
	tst.b	1(a0)		; read the next entry
	bne.s	++		; if it's not zero, return

	; Switch the detected console's region between Japanese and
	; international. This affects the presence of trademark symbols, and
	; causes Tails' name to swap between 'Tails' and 'Miles'.
	bchg	#7,(Graphics_Flags).w

	move.b	#SndID_Ring,d0 ; play the ring sound for a successfully entered cheat
	bsr.w	PlaySound
+
	move.w	#0,(Correct_cheat_entries).w
+
	rts
; End of function TailsNameCheat

; ===========================================================================
; byte_3DEE:
TailsNameCheat_Buttons:
	dc.b	button_up_mask
	dc.b	button_down_mask
	dc.b	button_down_mask
	dc.b	button_down_mask
	dc.b	button_up_mask
	dc.b	0	; end
	even
; ---------------------------------------------------------------------------------
; Nemesis compressed art
; 10 blocks
; Player 1 2 VS Text
; ---------------------------------------------------------------------------------
; ArtNem_3DF4:
ArtNem_Player1VS2:	BINCLUDE	"art/nemesis/1Player2VS.nem"
	even

	charset '0','9',0 ; Add character set for numbers
	charset '*',$A ; Add character for star
	charset '@',$B ; Add character for copyright symbol
	charset ':',$C ; Add character for colon
	charset '.',$D ; Add character for period
	charset 'A','Z',$E ; Add character set for letters

; word_3E82:
CopyrightText:
  irpc chr,"@ 1992 SEGA"
    if "chr"<>" "
	dc.w  make_art_tile(ArtTile_ArtNem_FontStuff_TtlScr + 'chr'|0,0,0)
    else
	dc.w  make_art_tile(ArtTile_VRAM_Start,0,0)
    endif
  endm
CopyrightText_End:

    charset ; Revert character set

	jmpTos JmpTo_SwScrl_Title

	include "_inc/Music List.asm"

; ---------------------------------------------------------------------------
; Level
; DEMO AND ZONE LOOP (MLS values $08, $0C; bit 7 set indicates that load routine is running)
; ---------------------------------------------------------------------------
; loc_3EC4:
Level:
	bset	#GameModeFlag_TitleCard,(Game_Mode).w ; add $80 to screen mode (for pre level sequence)
	tst.w	(Demo_mode_flag).w	; test the old flag for the credits demos (now unused)
	bmi.s	+
	move.b	#MusID_FadeOut,d0
	bsr.w	PlaySound	; fade out music
+
	bsr.w	ClearPLC
	bsr.w	Pal_FadeToBlack
	tst.w	(Demo_mode_flag).w
	bmi.s	Level_ClrRam
	move	#$2700,sr
	bsr.w	ClearScreen
	jsr	(LoadTitleCard).l ; load title card patterns
	move	#$2300,sr
	moveq	#0,d0
	move.w	d0,(Level_frame_counter).w
	move.b	(Current_Zone).w,d0

	; multiply d0 by 12, the size of a level art load block
	add.w	d0,d0
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0

	lea	(LevelArtPointers).l,a2
	lea	(a2,d0.w),a2
	moveq	#0,d0
	move.b	(a2),d0	; PLC1 ID
	beq.s	+
	bsr.w	LoadPLC
+
	moveq	#PLCID_Std2,d0
	bsr.w	LoadPLC
	bsr.w	Level_SetPlayerMode
	moveq	#PLCID_MilesLife2P,d0
	tst.w	(Two_player_mode).w
	bne.s	+
	cmpi.w	#2,(Player_mode).w
	bne.s	Level_ClrRam
	addq.w	#PLCID_MilesLife-PLCID_MilesLife2P,d0
+
	tst.b	(Graphics_Flags).w
	bpl.s	+
	addq.w	#PLCID_TailsLife2P-PLCID_MilesLife2P,d0
+
	bsr.w	LoadPLC
; loc_3F48:
Level_ClrRam:
	clearRAM Object_Display_Lists,Object_Display_Lists_End
	clearRAM Object_RAM,LevelOnly_Object_RAM_End ; clear object RAM and level-only object RAM
	clearRAM MiscLevelVariables,MiscLevelVariables_End
	clearRAM Misc_Variables,Misc_Variables_End
	clearRAM Oscillating_Data,Oscillating_variables_End
    if fixBugs
	clearRAM CNZ_saucer_data,CNZ_saucer_data_End
    else
	; The '+C0' shouldn't be here; CNZ_saucer_data is only $40 bytes large
	clearRAM CNZ_saucer_data,CNZ_saucer_data_End+$C0
    endif

	cmpi.w	#chemical_plant_zone_act_2,(Current_ZoneAndAct).w ; CPZ 2
	beq.s	Level_InitWater
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w ; ARZ
	beq.s	Level_InitWater
	cmpi.b	#hidden_palace_zone,(Current_Zone).w ; HPZ
	bne.s	+

Level_InitWater:
	move.b	#1,(Water_flag).w
	move.w	#0,(Two_player_mode).w
+
	lea	(VDP_control_port).l,a6
	move.w	#$8B03,(a6)		; EXT-INT disabled, V scroll by screen, H scroll by line
	move.w	#$8200|(VRAM_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $E000
	move.w	#$8500|(VRAM_Sprite_Attribute_Table/$200),(a6)	; Sprite attribute table base: $F800
	move.w	#$9001,(a6)		; Scroll table size: 64x32
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8720,(a6)		; Background palette/color: 2/0
	move.w	#$8C81,(a6)		; H res 40 cells, no interlace
	tst.b	(Debug_options_flag).w
	beq.s	++
	btst	#button_C,(Ctrl_1_Held).w
	beq.s	+
	move.w	#$8C89,(a6)	; H res 40 cells, no interlace, S/H enabled
+
	btst	#button_A,(Ctrl_1_Held).w
	beq.s	+
	move.b	#1,(Debug_mode_flag).w
+
	move.w	#$8ADF,(Hint_counter_reserve).w	; H-INT every 223rd scanline
	tst.w	(Two_player_mode).w
	beq.s	+
	move.w	#$8A6B,(Hint_counter_reserve).w	; H-INT every 108th scanline
	move.w	#$8014,(a6)			; H-INT enabled
	move.w	#$8C87,(a6)			; H res 40 cells, double res interlace
+
	move.w	(Hint_counter_reserve).w,(a6)
	clr.w	(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	tst.b	(Water_flag).w	; does level have water?
	beq.s	Level_LoadPal	; if not, branch
	move.w	#$8014,(a6)	; H-INT enabled
	moveq	#0,d0
	move.w	(Current_ZoneAndAct).w,d0
    if ~~useFullWaterTables
	subi.w	#hidden_palace_zone_act_1,d0
    endif
	ror.b	#1,d0
	lsr.w	#6,d0
	andi.w	#$FFFE,d0
	lea	(WaterHeight).l,a1	; load water height array
	move.w	(a1,d0.w),d0
	move.w	d0,(Water_Level_1).w ; set water heights
	move.w	d0,(Water_Level_2).w
	move.w	d0,(Water_Level_3).w
	clr.b	(Water_routine).w	; clear water routine counter
	clr.b	(Water_fullscreen_flag).w	; clear water movement
	move.b	#1,(Water_on).w	; enable water
; loc_407C:
Level_LoadPal:
	moveq	#PalID_BGND,d0
	bsr.w	PalLoad_Now	; load Sonic's palette line
	tst.b	(Water_flag).w	; does level have water?
	beq.s	Level_GetBgm	; if not, branch
	moveq	#PalID_HPZ_U,d0	; palette number $15
	cmpi.b	#hidden_palace_zone,(Current_Zone).w
	beq.s	Level_WaterPal ; branch if level is HPZ
	moveq	#PalID_CPZ_U,d0	; palette number $16
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	beq.s	Level_WaterPal ; branch if level is CPZ
	moveq	#PalID_ARZ_U,d0	; palette number $17
; loc_409E:
Level_WaterPal:
	bsr.w	PalLoad_Water_Now	; load underwater palette (with d0)
	tst.b	(Last_star_pole_hit).w ; is it the start of the level?
	beq.s	Level_GetBgm	; if yes, branch
	move.b	(Saved_Water_move).w,(Water_fullscreen_flag).w
; loc_40AE:
Level_GetBgm:
	tst.w	(Demo_mode_flag).w
	bmi.s	+
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	lea_	MusicList,a1
	tst.w	(Two_player_mode).w
	beq.s	Level_PlayBgm
	lea_	MusicList2,a1
; loc_40C8:
Level_PlayBgm:
	move.b	(a1,d0.w),d0		; load from music playlist
	move.w	d0,(Level_Music).w	; store level music
	bsr.w	PlayMusic		; play level music
	move.b	#ObjID_TitleCard,(TitleCard+id).w ; load Obj34 (level title card) at $FFFFB080
; loc_40DA:
Level_TtlCard:
	move.b	#VintID_TitleCard,(Vint_routine).w
	bsr.w	WaitForVint
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	bsr.w	RunPLC_RAM
	move.w	(TitleCard_ZoneName+x_pos).w,d0
	cmp.w	(TitleCard_ZoneName+titlecard_x_target).w,d0 ; has title card sequence finished?
	bne.s	Level_TtlCard		; if not, branch
	tst.l	(Plc_Buffer).w		; are there any items in the pattern load cue?
	bne.s	Level_TtlCard		; if yes, branch
	move.b	#VintID_TitleCard,(Vint_routine).w
	bsr.w	WaitForVint
	jsr	(Hud_Base).l
+
	moveq	#PalID_BGND,d0
	bsr.w	PalLoad_ForFade	; load Sonic's palette line
	bsr.w	LevelSizeLoad
	jsrto	JmpTo_DeformBgLayer
	clr.w	(Vscroll_Factor_FG).w
	move.w	#-screen_height,(Vscroll_Factor_P2_FG).w

	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len

	bsr.w	LoadZoneTiles
	jsrto	JmpTo_loadZoneBlockMaps
	jsr	(LoadAnimatedBlocks).l
	jsrto	JmpTo_DrawInitialBG
	jsr	(ConvertCollisionArray).l
	bsr.w	LoadCollisionIndexes
	bsr.w	WaterEffects
	bsr.w	InitPlayers
	move.w	#0,(Ctrl_1_Logical).w
	move.w	#0,(Ctrl_2_Logical).w
	move.w	#0,(Ctrl_1).w
	move.w	#0,(Ctrl_2).w
	move.b	#1,(Control_Locked).w
	move.b	#1,(Control_Locked_P2).w
	move.b	#0,(Level_started_flag).w
; Level_ChkWater:
	tst.b	(Water_flag).w	; does level have water?
	beq.s	+	; if not, branch
	move.b	#ObjID_WaterSurface,(WaterSurface1+id).w ; load Obj04 (water surface) at $FFFFB380
	move.w	#$60,(WaterSurface1+x_pos).w ; set horizontal offset
	move.b	#ObjID_WaterSurface,(WaterSurface2+id).w ; load Obj04 (water surface) at $FFFFB3C0
	move.w	#$120,(WaterSurface2+x_pos).w ; set different horizontal offset
+
	cmpi.b	#chemical_plant_zone,(Current_Zone).w	; check if zone == CPZ
	bne.s	+			; branch if not
	move.b	#ObjID_CPZPylon,(CPZPylon+id).w ; load Obj7C (CPZ pylon) at $FFFFB340
+
	cmpi.b	#oil_ocean_zone,(Current_Zone).w	; check if zone == OOZ
	bne.s	Level_ClrHUD		; branch if not
	move.b	#ObjID_Oil,(Oil+id).w ; load Obj07 (OOZ oil) at $FFFFB380
; Level_LoadObj: misnomer now
Level_ClrHUD:
	moveq	#0,d0
	tst.b	(Last_star_pole_hit).w	; are you starting from a lamppost?
	bne.s	Level_FromCheckpoint	; if yes, branch
	move.w	d0,(Ring_count).w	; clear rings
	move.l	d0,(Timer).w		; clear time
	move.b	d0,(Extra_life_flags).w	; clear extra lives counter
	move.w	d0,(Ring_count_2P).w	; ditto for player 2
	move.l	d0,(Timer_2P).w
	move.b	d0,(Extra_life_flags_2P).w
; loc_41E4:
Level_FromCheckpoint:
	move.b	d0,(Time_Over_flag).w
	move.b	d0,(Time_Over_flag_2P).w
	move.b	d0,(SlotMachine_Routine).w
	move.w	d0,(SlotMachineInUse).w
	move.w	d0,(Debug_placement_mode).w
	move.w	d0,(Level_Inactive_flag).w
	move.b	d0,(Teleport_timer).w
	move.b	d0,(Teleport_flag).w
	move.w	d0,(Rings_Collected).w
	move.w	d0,(Rings_Collected_2P).w
	move.w	d0,(Monitors_Broken).w
	move.w	d0,(Monitors_Broken_2P).w
	move.w	d0,(Loser_Time_Left).w
    if fixBugs
	; S3K adds this. The game leaves this flag set after a Game Over or a reset,
	; which can have bizarre effects when playing as Tails.
	move.b	d0,(Super_Sonic_flag).w
    endif
	bsr.w	OscillateNumInit
	move.b	#1,(Update_HUD_score).w
	move.b	#1,(Update_HUD_rings).w
	move.b	#1,(Update_HUD_timer).w
	move.b	#1,(Update_HUD_timer_2P).w
	jsr	(ObjectsManager).l
	jsr	(RingsManager).l
	jsr	(SpecialCNZBumpers).l
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	jsrto	JmpTo_AniArt_Load
	bsr.w	SetLevelEndType
	move.w	#0,(Demo_button_index).w
	move.w	#0,(Demo_button_index_2P).w
	lea	(DemoScriptPointers).l,a1
	moveq	#0,d0
	move.b	(Current_Zone).w,d0	; load zone value
	lsl.w	#2,d0
	movea.l	(a1,d0.w),a1
	tst.w	(Demo_mode_flag).w
	bpl.s	+
	lea	(EndingDemoScriptPointers).l,a1
	move.w	(Ending_demo_number).w,d0
	subq.w	#1,d0
	lsl.w	#2,d0
	movea.l	(a1,d0.w),a1
+
	move.b	1(a1),(Demo_press_counter).w
    if emerald_hill_zone<>0
	cmpi.b	#emerald_hill_zone,(Current_Zone).w
    else
	tst.b	(Current_Zone).w	; emerald_hill_zone
    endif
	bne.s	+
	lea	(Demo_EHZ_Tails).l,a1
	move.b	1(a1),(Demo_press_counter_2P).w
+
	move.w	#$668,(Demo_Time_left).w
	tst.w	(Demo_mode_flag).w
	bpl.s	+
	move.w	#$21C,(Demo_Time_left).w
	cmpi.w	#4,(Ending_demo_number).w
	bne.s	+
	move.w	#$1FE,(Demo_Time_left).w
+
	tst.b	(Water_flag).w
	beq.s	++
	moveq	#PalID_HPZ_U,d0
	cmpi.b	#hidden_palace_zone,(Current_Zone).w
	beq.s	+
	moveq	#PalID_CPZ_U,d0
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	beq.s	+
	moveq	#PalID_ARZ_U,d0
+
	bsr.w	PalLoad_Water_ForFade
+
	move.w	#-1,(TitleCard_ZoneName+titlecard_leaveflag).w
	move.b	#$E,(TitleCard_Left+routine).w	; make the left part move offscreen
	move.w	#$A,(TitleCard_Left+titlecard_location).w

-	move.b	#VintID_TitleCard,(Vint_routine).w
	bsr.w	WaitForVint
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	bsr.w	RunPLC_RAM
	tst.b	(TitleCard_Background+id).w
	bne.s	-	; loop while the title card background is still loaded

	lea	(TitleCard).w,a1
	move.b	#$16,TitleCard_ZoneName-TitleCard+routine(a1)
	move.w	#$2D,TitleCard_ZoneName-TitleCard+anim_frame_duration(a1)
	move.b	#$16,TitleCard_Zone-TitleCard+routine(a1)
	move.w	#$2D,TitleCard_Zone-TitleCard+anim_frame_duration(a1)
	tst.b	TitleCard_ActNumber-TitleCard+id(a1)
	beq.s	+	; branch if the act number has been unloaded
	move.b	#$16,TitleCard_ActNumber-TitleCard+routine(a1)
	move.w	#$2D,TitleCard_ActNumber-TitleCard+anim_frame_duration(a1)
+	move.b	#0,(Control_Locked).w
	move.b	#0,(Control_Locked_P2).w
	move.b	#1,(Level_started_flag).w

; Level_StartGame: loc_435A:
	bclr	#GameModeFlag_TitleCard,(Game_Mode).w ; clear $80 from the game mode

; ---------------------------------------------------------------------------
; Main level loop (when all title card and loading sequences are finished)
; ---------------------------------------------------------------------------
; loc_4360:
Level_MainLoop:
	bsr.w	PauseGame
	move.b	#VintID_Level,(Vint_routine).w
	bsr.w	WaitForVint
	addq.w	#1,(Level_frame_counter).w ; add 1 to level timer
	bsr.w	MoveSonicInDemo
	bsr.w	WaterEffects
	jsr	(RunObjects).l
	tst.w	(Level_Inactive_flag).w
	bne.w	Level
	jsrto	JmpTo_DeformBgLayer
	bsr.w	UpdateWaterSurface
	jsr	(RingsManager).l
	cmpi.b	#casino_night_zone,(Current_Zone).w	; is it CNZ?
	bne.s	+			; if not, branch past jsr
	jsr	(SpecialCNZBumpers).l
+
	jsrto	JmpTo_AniArt_Load
	bsr.w	PalCycle_Load
	bsr.w	RunPLC_RAM
	bsr.w	OscillateNumDo
	bsr.w	ChangeRingFrame
	bsr.w	CheckLoadSignpostArt
	jsr	(BuildSprites).l
	jsr	(ObjectsManager).l
	cmpi.b	#GameModeID_Demo,(Game_Mode).w	; check if in demo mode
	beq.s	+
	cmpi.b	#GameModeID_Level,(Game_Mode).w	; check if in normal play mode
	beq.w	Level_MainLoop
	rts
; ---------------------------------------------------------------------------
+
	tst.w	(Level_Inactive_flag).w
	bne.s	+
	tst.w	(Demo_Time_left).w
	beq.s	+
	cmpi.b	#GameModeID_Demo,(Game_Mode).w
	beq.w	Level_MainLoop
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ---------------------------------------------------------------------------
+
	cmpi.b	#GameModeID_Demo,(Game_Mode).w
	bne.s	+
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
+
	move.w	#1*60,(Demo_Time_left).w	; 1 second
	move.w	#$3F,(Palette_fade_range).w
	clr.w	(PalChangeSpeed).w
-
	move.b	#VintID_Level,(Vint_routine).w
	bsr.w	WaitForVint
	bsr.w	MoveSonicInDemo
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	jsr	(ObjectsManager).l
	subq.w	#1,(PalChangeSpeed).w
	bpl.s	+
	move.w	#2,(PalChangeSpeed).w
	bsr.w	Pal_FadeToBlack.UpdateAllColours
+
	tst.w	(Demo_Time_left).w
	bne.s	-
	rts

; ---------------------------------------------------------------------------
; Subroutine to set the player mode, which is forced to Sonic and Tails in
; the demo mode and in 2P mode
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4450:
Level_SetPlayerMode:
	cmpi.b	#GameModeID_TitleCard|GameModeID_Demo,(Game_Mode).w ; pre-level demo mode?
	beq.s	+			; if yes, branch
	tst.w	(Two_player_mode).w	; 2P mode?
	bne.s	+			; if yes, branch
	move.w	(Player_option).w,(Player_mode).w ; use the option chosen in the Options screen
	rts
+
	move.w	#0,(Player_mode).w	; force Sonic and Tails
	rts
; End of function Level_SetPlayerMode


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_446E:
InitPlayers:
	move.w	(Player_mode).w,d0
	bne.s	InitPlayers_Alone ; branch if this isn't a Sonic and Tails game

	move.b	#ObjID_Sonic,(MainCharacter+id).w ; load Obj01 Sonic object at $FFFFB000
	move.b	#ObjID_SpindashDust,(Sonic_Dust+id).w ; load Obj08 Sonic's spindash dust/splash object at $FFFFD100

	cmpi.b	#wing_fortress_zone,(Current_Zone).w
	beq.s	+ ; skip loading Tails if this is WFZ
	cmpi.b	#death_egg_zone,(Current_Zone).w
	beq.s	+ ; skip loading Tails if this is DEZ
	cmpi.b	#sky_chase_zone,(Current_Zone).w
	beq.s	+ ; skip loading Tails if this is SCZ

	move.b	#ObjID_Tails,(Sidekick+id).w ; load Obj02 Tails object at $FFFFB040
	move.w	(MainCharacter+x_pos).w,(Sidekick+x_pos).w
	move.w	(MainCharacter+y_pos).w,(Sidekick+y_pos).w
	subi.w	#$20,(Sidekick+x_pos).w
	addi_.w	#4,(Sidekick+y_pos).w
	move.b	#ObjID_SpindashDust,(Tails_Dust+id).w ; load Obj08 Tails' spindash dust/splash object at $FFFFD140
+
	rts
; ===========================================================================
; loc_44BE:
InitPlayers_Alone: ; either Sonic or Tails but not both
	subq.w	#1,d0
	bne.s	InitPlayers_TailsAlone ; branch if this is a Tails alone game

	move.b	#ObjID_Sonic,(MainCharacter+id).w ; load Obj01 Sonic object at $FFFFB000
	move.b	#ObjID_SpindashDust,(Sonic_Dust+id).w ; load Obj08 Sonic's spindash dust/splash object at $FFFFD100
	rts
; ===========================================================================
; loc_44D0:
InitPlayers_TailsAlone:
	move.b	#ObjID_Tails,(MainCharacter+id).w ; load Obj02 Tails object at $FFFFB000
	move.b	#ObjID_SpindashDust,(Tails_Dust+id).w ; load Obj08 Tails' spindash dust/splash object at $FFFFD100
	addi_.w	#4,(MainCharacter+y_pos).w
	rts
; End of function InitPlayers

	include "_inc/Water.asm"
	include "_inc/Wind Tunnels.asm"
	include "_inc/Slides.asm"
	include "_inc/MoveSonicInDemo.asm"
	include "_inc/Load Collision Index.asm"
	include "_incObj/sub OscillatingNumber.asm"

; ---------------------------------------------------------------------------
; Subroutine to change global object animation variables (like rings)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4B64:
ChangeRingFrame:
	subq.b	#1,(Logspike_anim_counter).w
	bpl.s	+
	move.b	#$B,(Logspike_anim_counter).w
	subq.b	#1,(Logspike_anim_frame).w ; animate unused log spikes
	andi.b	#7,(Logspike_anim_frame).w
+
	subq.b	#1,(Rings_anim_counter).w
	bpl.s	+
	move.b	#7,(Rings_anim_counter).w
	addq.b	#1,(Rings_anim_frame).w ; animate rings in the level (obj25)
	andi.b	#3,(Rings_anim_frame).w
+
	subq.b	#1,(Unknown_anim_counter).w
	bpl.s	+
	move.b	#7,(Unknown_anim_counter).w
	addq.b	#1,(Unknown_anim_frame).w ; animate nothing (deleted special stage object is my best guess)
	cmpi.b	#6,(Unknown_anim_frame).w
	blo.s	+
	move.b	#0,(Unknown_anim_frame).w
+
	tst.b	(Ring_spill_anim_counter).w
	beq.s	+	; rts
	moveq	#0,d0
	move.b	(Ring_spill_anim_counter).w,d0
	add.w	(Ring_spill_anim_accum).w,d0
	move.w	d0,(Ring_spill_anim_accum).w
	rol.w	#7,d0
	andi.w	#3,d0
	move.b	d0,(Ring_spill_anim_frame).w ; animate scattered rings (obj37)
	subq.b	#1,(Ring_spill_anim_counter).w
+
	rts
; End of function ChangeRingFrame




; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

nosignpost macro actid
	cmpi.w	#actid,(Current_ZoneAndAct).w
	beq.ATTRIBUTE	+	; rts
    endm

; sub_4BD2:
SetLevelEndType:
	move.w	#0,(Level_Has_Signpost).w	; set level type to non-signpost
	tst.w	(Two_player_mode).w	; is it two-player competitive mode?
	bne.s	LevelEnd_SetSignpost	; if yes, branch
	nosignpost.w emerald_hill_zone_act_2
	nosignpost.w metropolis_zone_act_3
	nosignpost.w wing_fortress_zone_act_1
	nosignpost.w hill_top_zone_act_2
	nosignpost.w oil_ocean_zone_act_2
	nosignpost.s mystic_cave_zone_act_2
	nosignpost.s casino_night_zone_act_2
	nosignpost.s chemical_plant_zone_act_2
	nosignpost.s death_egg_zone_act_1
	nosignpost.s aquatic_ruin_zone_act_2
	nosignpost.s sky_chase_zone_act_1

; loc_4C40:
LevelEnd_SetSignpost:
	move.w	#1,(Level_Has_Signpost).w	; set level type to signpost
+	rts
; End of function SetLevelEndType


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4C48:
CheckLoadSignpostArt:
	tst.w	(Level_Has_Signpost).w
	beq.s	+	; rts
	tst.w	(Debug_placement_mode).w
	bne.s	+	; rts
	move.w	(Camera_X_pos).w,d0
	move.w	(Camera_Max_X_pos).w,d1
	subi.w	#$100,d1
	cmp.w	d1,d0
	blt.s	SignpostUpdateTailsBounds
	tst.b	(Update_HUD_timer).w
	beq.s	SignpostUpdateTailsBounds
	cmp.w	(Camera_Min_X_pos).w,d1
	beq.s	SignpostUpdateTailsBounds
	move.w	d1,(Camera_Min_X_pos).w ; prevent camera from scrolling back to the left
	tst.w	(Two_player_mode).w
	bne.s	+	; rts
	moveq	#PLCID_Signpost,d0 ; <== PLC_1F
	bra.w	LoadPLC2		; load signpost art
; ---------------------------------------------------------------------------
; loc_4C80:
SignpostUpdateTailsBounds:
	tst.w	(Two_player_mode).w
	beq.s	+	; rts
	move.w	(Camera_X_pos_P2).w,d0
	move.w	(Tails_Max_X_pos).w,d1
	subi.w	#$100,d1
	cmp.w	d1,d0
	blt.s	+	; rts
	tst.b	(Update_HUD_timer_2P).w
	beq.s	+	; rts
	cmp.w	(Tails_Min_X_pos).w,d1
	beq.s	+	; rts
	move.w	d1,(Tails_Min_X_pos).w ; prevent Tails from going past new left boundary
+	rts
; End of function CheckLoadSignpostArt




; ===========================================================================
; Demo scripts
	include "demodata/EHZ.asm"
	include "demodata/CPZ.asm"
	include "demodata/ARZ.asm"

	include "_inc/Load Zone Tiles.asm"

	include "_inc/Special Stage.asm"
; ===========================================================================
	include "_incObj/5E Special Stage HUD.asm"
; -----------------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------------
Obj5E_MapUnc_7070:	include "mappings/sprite/obj5E.asm"
; ===========================================================================
	include "_incObj/5F Special Stage Start Banner.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj5F_MapUnc_7240:	include "mappings/sprite/obj5F_a.asm"
; -----------------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------------
Obj5F_MapUnc_72D2:	include "mappings/sprite/obj5F_b.asm"
; ===========================================================================
	include "_incObj/87 Special Stage Rings Counter.asm"

	include "_inc/Special Stage Part 2.asm"

; ----------------------------------------------------------------------------
; Continue Screen
; ----------------------------------------------------------------------------
; loc_7870:
ContinueScreen:
	bsr.w	Pal_FadeToBlack
	move	#$2700,sr
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l
	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	bsr.w	ClearScreen

	clearRAM Object_RAM,Object_RAM_End

    if fixBugs
	; Clear the DMA queue. This fixes the bug where, if you get a
	; Game Over in Hill Top Zone, then Tails' graphics will be corrupted
	; on the Continue screen.
	; This is caused by HTZ's transforming cloud art being loaded over
	; Tails' Continue art: 'Dynamic_HTZ' is responsible for queueing the
	; art to be transferred with 'QueueDMATransfer', which takes effect
	; around the next frame. The problem here is, the art is queued, you
	; die, get a Game Over, advance to the Continue screen, and then
	; finally the art is loaded.
	clr.w	(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w

	; The game leaves this flag set after a Game Over, which causes
	; Sonic to animate incorrectly.
	clr.b	(Super_Sonic_flag).w
    endif

	bsr.w	ContinueScreen_LoadLetters
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_ContinueTails),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_ContinueTails).l,a0
	bsr.w	NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_MiniContinue),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_MiniSonic).l,a0
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	lea	(ArtNem_MiniTails).l,a0
+
	bsr.w	NemDec
	moveq	#$A,d1
	jsr	(ContScrCounter).l
	moveq	#PalID_SS1,d0
	bsr.w	PalLoad_ForFade
	move.w	#0,(Target_palette).w
	move.b	#MusID_Continue,d0
	bsr.w	PlayMusic
	move.w	#(11*60)-1,(Demo_Time_left).w	; 11 seconds minus 1 frame
	clr.b	(Level_started_flag).w
	clr.l	(Camera_X_pos_copy).w
	move.l	#$1000000,(Camera_Y_pos_copy).w
	move.b	#ObjID_ContinueChars,(MainCharacter+id).w ; load ObjDB (Sonic on continue screen)
	move.b	#ObjID_ContinueChars,(Sidekick+id).w ; load ObjDB (Tails on continue screen)
	move.b	#6,(Sidekick+routine).w ; => ObjDB_Tails_Init
	move.b	#ObjID_ContinueText,(ContinueText+id).w ; load ObjDA (continue screen text)
	move.b	#ObjID_ContinueIcons,(ContinueIcons+id).w ; load ObjDA (continue icons)
	move.b	#4,(ContinueIcons+routine).w ; => loc_7AD0
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromBlack
-
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	cmpi.b	#4,(MainCharacter+routine).w
	bhs.s	+
	move	#$2700,sr
	move.w	(Demo_Time_left).w,d1
	divu.w	#60,d1
	andi.l	#$F,d1
	jsr	(ContScrCounter).l
	move	#$2300,sr
+
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	cmpi.w	#$180,(Sidekick+x_pos).w
	bhs.s	+
	cmpi.b	#4,(MainCharacter+routine).w
	bhs.s	-
	tst.w	(Demo_Time_left).w
	bne.w	-
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ---------------------------------------------------------------------------
+
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	move.b	#3,(Life_count).w
	move.b	#3,(Life_count_2P).w
	moveq	#0,d0
	move.w	d0,(Ring_count).w
	move.l	d0,(Timer).w
	move.l	d0,(Score).w
	move.b	d0,(Last_star_pole_hit).w
	move.w	d0,(Ring_count_2P).w
	move.l	d0,(Timer_2P).w
	move.l	d0,(Score_2P).w
	move.b	d0,(Last_star_pole_hit_2P).w
	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w
	subq.b	#1,(Continue_count).w
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_7A04:
ContinueScreen_LoadLetters:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_TitleCard),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_TitleCard).l,a0
	bsr.w	NemDec
	lea	(Level_Layout).w,a4
	lea	(ArtNem_TitleCard2).l,a0
	bsr.w	NemDecToRAM
	lea	(ContinueScreen_AdditionalLetters).l,a0
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ContinueScreen_Additional),VRAM,WRITE),(VDP_control_port).l
	lea	(Level_Layout).w,a1
	lea	(VDP_data_port).l,a6
-
	moveq	#0,d0
	move.b	(a0)+,d0
	bmi.s	+	; rts
	lsl.w	#5,d0
	lea	(a1,d0.w),a2
	moveq	#0,d1
	move.b	(a0)+,d1
	lsl.w	#3,d1
	subq.w	#1,d1

-	move.l	(a2)+,(a6)
	dbf	d1,-

	bra.s	--
; ---------------------------------------------------------------------------
+	rts
; End of function ContinueScreen_LoadLetters

; ===========================================================================

 ; temporarily remap characters to title card letter format
 ; Characters are encoded as Aa, Bb, Cc, etc. through a macro
 charset 'A',0	; can't have an embedded 0 in a string
 charset 'B',"\4\8\xC\4\x10\x14\x18\x1C\x1E\x22\x26\x2A\4\4\x30\x34\x38\x3C\x40\x44\x48\x4C\x52\x56\4"
 charset 'a',"\4\4\4\4\4\4\4\4\2\4\4\4\6\4\4\4\4\4\4\4\4\4\6\4\4"
 charset '.',"\x5A"

; Defines which letters load for the continue screen
; Each letter occurs only once, and  the letters ENOZ (i.e. ZONE) aren't loaded here
; However, this is hidden by the titleLetters macro, and normal titles can be used
; (the macro is defined near SpecialStage_ResultsLetters, which uses it before here)

; word_7A5E:
ContinueScreen_AdditionalLetters:
	titleLetters "CONTINUE"

 charset ; revert character set
; ===========================================================================
	include "_incObj/DA Continue Text.asm"
; ===========================================================================
	include "_incObj/DB Continue Player.asm"
; ===========================================================================
	include "_anim/Tails Nag.asm"
; -------------------------------------------------------------------------------
; Sprite mappings for text, countdown, stars, and Tails on the continue screen
; Art starts at $A000 in VRAM
; -------------------------------------------------------------------------------
ObjDA_MapUnc_7CB6:	include	"mappings/sprite/objDA.asm"

	jmpTos JmpTo_Adjust2PArtPointer2,JmpTo_Adjust2PArtPointer

; ===========================================================================
; loc_7D50:
TwoPlayerResults:
	bsr.w	Pal_FadeToBlack
	move	#$2700,sr
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	ClearScreen
	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_Menu_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $E000
	move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled
	move.w	#$9001,(a6)		; Scroll table size: 64x32

	clearRAM Object_Display_Lists,Object_Display_Lists_End
	clearRAM Object_RAM,Object_RAM_End

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_FontStuff),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_FontStuff).l,a0
	bsr.w	NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_1P2PWins),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_1P2PWins).l,a0
	bsr.w	NemDec
	lea	(Chunk_Table).l,a1
	lea	(MapEng_MenuBack).l,a0
	move.w	#make_art_tile(ArtTile_VRAM_Start,3,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
	moveq	#40-1,d1
	moveq	#28-1,d2
    if removeJmpTos
	jsr	(PlaneMapToVRAM_H40).l
    else
	bsr.w	PlaneMapToVRAM_H40
    endif
	move.w	(Results_Screen_2P).w,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,d0
	lea	TwoPlayerResultsPointers(pc),a2
	movea.l	(a2,d0.w),a0
	movea.l	4(a2,d0.w),a2
	lea	(Chunk_Table).l,a1
	move.w	#make_art_tile(ArtTile_VRAM_Start,0,0),d0
	bsr.w	EniDec
	jsr	(a2)	; dynamic call! to Setup2PResults_Act, Setup2PResults_Zone, Setup2PResults_Game, Setup2PResults_SpecialAct, or Setup2PResults_SpecialZone, assuming the pointers in TwoPlayerResultsPointers have not been changed
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(tiles_to_bytes(ArtTile_TwoPlayerResults),VRAM,WRITE),d0
	moveq	#40-1,d1
	moveq	#28-1,d2
    if removeJmpTos
	jsr	(PlaneMapToVRAM_H40).l
    else
	bsr.w	PlaneMapToVRAM_H40
    endif
	clr.w	(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	clr.b	(Level_started_flag).w
	clr.w	(Anim_Counters).w
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo_Dynamic_Normal
	moveq	#PLCID_Std1,d0
	bsr.w	LoadPLC2
	moveq	#PalID_Menu,d0
	bsr.w	PalLoad_ForFade
	moveq	#0,d0
	move.b	#MusID_2PResult,d0
	cmp.w	(Level_Music).w,d0
	beq.s	+
	move.w	d0,(Level_Music).w
	bsr.w	PlayMusic
+
	move.w	#(30*60)-1,(Demo_Time_left).w	; 30 seconds
	clr.w	(Two_player_mode).w
	clr.l	(Camera_X_pos).w
	clr.l	(Camera_Y_pos).w
	clr.l	(Vscroll_Factor).w
	clr.l	(Vscroll_Factor_P2).w
	clr.l	(Vscroll_Factor_P2_HInt).w
	move.b	#ObjID_2PResults,(VSResults_HUD+id).w
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromBlack

-	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo_Dynamic_Normal
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	bsr.w	RunPLC_RAM
	tst.l	(Plc_Buffer).w
	bne.s	-
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0
	beq.s	-			; stay on that screen until either player presses start

	move.w	(Results_Screen_2P).w,d0 ; were we at the act results screen? (VsRSID_Act)
	bne.w	TwoPlayerResultsDone_Zone ; if not, branch
	tst.b	(Current_Act).w		; did we just finish act 1?
	bne.s	+			; if not, branch
	addq.b	#1,(Current_Act).w	; go to the next act
	move.b	#1,(Current_Act_2P).w
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	move.b	#0,(Last_star_pole_hit).w
	move.b	#0,(Last_star_pole_hit_2P).w
	moveq	#1,d0
	move.w	d0,(Two_player_mode).w
	move.w	d0,(Two_player_mode_copy).w
	moveq	#0,d0
	move.l	d0,(Score).w
	move.l	d0,(Score_2P).w
	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w
	rts
; ===========================================================================
+	; Displays results for the zone
	move.b	#2,(Current_Act_2P).w
	bsr.w	sub_84A4
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	bsr.s	sub_7F9A
	bsr.s	sub_7F9A
	move.b	(a4),d1
	sub.b	1(a4),d1
	beq.s	+		; if there's a tie, branch
	move.w	#VsRSID_Zone,(Results_Screen_2P).w
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	rts
; ===========================================================================
+	; There's a tie, play a special stage
	move.b	(Current_Zone_2P).w,d0
	addq.b	#1,d0
	move.b	d0,(Current_Special_Stage).w
	move.w	#VsRSID_SS,(Results_Screen_2P).w
	move.b	#1,(f_bigring).w
	move.b	#GameModeID_SpecialStage,(Game_Mode).w ; => SpecialStage
	moveq	#1,d0
	move.w	d0,(Two_player_mode).w
	move.w	d0,(Two_player_mode_copy).w
	move.b	#0,(Last_star_pole_hit).w
	move.b	#0,(Last_star_pole_hit_2P).w
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_7F9A:
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	beq.s	++
	bcs.s	+
	addq.b	#1,(a4)
	bra.s	++
; ===========================================================================
+
	addq.b	#1,1(a4)
+
	addq.w	#2,a5
	rts
; End of function sub_7F9A

; ===========================================================================

; loc_7FB2:
TwoPlayerResultsDone_Zone:
	subq.w	#1,d0			; were we at the zone results screen? (VsRSID_Zone)
	bne.s	TwoPlayerResultsDone_Game ; if not, branch

; loc_7FB6:
TwoPlayerResultsDone_ZoneOrSpecialStages:
	lea	(Results_Data_2P).w,a4
	moveq	#0,d0
	moveq	#0,d1
    rept 3
	move.w	(a4)+,d0
	add.l	d0,d1
	move.w	(a4)+,d0
	add.l	d0,d1
	addq.w	#2,a4
    endm
	move.w	(a4)+,d0
	add.l	d0,d1
	move.w	(a4)+,d0
	add.l	d0,d1
	swap	d1
	tst.w	d1	; have all levels been completed?
	bne.s	+	; if not, branch
	move.w	#VsRSID_Game,(Results_Screen_2P).w
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	rts
; ===========================================================================
+
	tst.w	(Game_Over_2P).w
	beq.s	+		; if there's a Game Over, clear the results
	lea	(Results_Data_2P).w,a1

	moveq	#bytesToWcnt(Results_Data_2P_End-Results_Data_2P),d0
-	move.w	#-1,(a1)+
	dbf	d0,-

	move.b	#3,(Life_count).w
	move.b	#3,(Life_count_2P).w
+
	move.b	#GameModeID_2PLevelSelect,(Game_Mode).w ; => LevelSelectMenu2P
	rts
; ===========================================================================
; loc_8020:
TwoPlayerResultsDone_Game:
	subq.w	#1,d0	; were we at the game results screen? (VsRSID_Game)
	bne.s	TwoPlayerResultsDone_SpecialStage ; if not, branch
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ===========================================================================
; loc_802C:
TwoPlayerResultsDone_SpecialStage:
	subq.w	#1,d0			; were we at the special stage results screen? (VsRSID_SS)
	bne.w	TwoPlayerResultsDone_SpecialStages ; if not, branch
	cmpi.b	#3,(Current_Zone_2P).w	; do we come from the special stage "zone"?
	beq.s	+			; if yes, branch
	move.w	#VsRSID_Zone,(Results_Screen_2P).w ; show zone results after tiebreaker special stage
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	rts
; ===========================================================================
+
	tst.b	(Current_Act_2P).w
	beq.s	+
	cmpi.b	#2,(Current_Act_2P).w
	beq.s	loc_80AC
	bsr.w	sub_84A4
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	bsr.s	sub_8094
	bsr.s	sub_8094
	move.b	(a4),d1
	sub.b	1(a4),d1
	bne.s	loc_80AC
+
	addq.b	#1,(Current_Act_2P).w
	addq.b	#1,(Current_Special_Stage).w
	move.w	#VsRSID_SS,(Results_Screen_2P).w
	move.b	#1,(f_bigring).w
	move.b	#GameModeID_SpecialStage,(Game_Mode).w ; => SpecialStage
	move.w	#1,(Two_player_mode).w
	move.w	#0,(Level_Music).w
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_8094:
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	beq.s	++
	bcs.s	+
	addq.b	#1,(a4)
	bra.s	++
; ===========================================================================
+
	addq.b	#1,1(a4)
+
	addq.w	#2,a5
	rts
; End of function sub_8094

; ===========================================================================

loc_80AC:
	move.w	#VsRSID_SSZone,(Results_Screen_2P).w
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	rts
; ===========================================================================
; loc_80BA: BranchTo_loc_7FB6:
TwoPlayerResultsDone_SpecialStages:
	; we were at the special stages results screen (VsRSID_SSZone)
	bra.w	TwoPlayerResultsDone_ZoneOrSpecialStages

; ===========================================================================
	include "_incObj/21 2P Results Display.asm"
; ===========================================================================
; --------------------------------------------------------------------------
; sprite mappings
; --------------------------------------------------------------------------
Obj21_MapUnc_8146:	include "mappings/sprite/obj21.asm"
; ===========================================================================

	include "_inc/2P Results.asm"

; ------------------------------------------------------------------------
; MENU ANIMATION SCRIPT
; ------------------------------------------------------------------------
;word_87C6:
Anim_SonicMilesBG:	zoneanimstart
	; Sonic/Miles animated background
	zoneanimdecl  -1, ArtUnc_MenuBack,    1,  6, $A
	dc.b   0,$C7
	dc.b  $A,  5
	dc.b $14,  5
	dc.b $1E,$C7
	dc.b $14,  5
	dc.b  $A,  5
	even

	zoneanimend

; off_87DC:
TwoPlayerResultsPointers:
VsResultsScreen_Act:	dc.l Map_2PActResults, Setup2PResults_Act
VsResultsScreen_Zone:	dc.l Map_2PZoneResults, Setup2PResults_Zone
VsResultsScreen_Game:	dc.l Map_2PGameResults, Setup2PResults_Game
VsResultsScreen_SS:	dc.l Map_2PSpecialStageActResults, Setup2PResults_SpecialAct
VsResultsScreen_SSZone:	dc.l Map_2PSpecialStageZoneResults, Setup2PResults_SpecialZone

; 2P single act results screen (enigma compressed)
; byte_8804:
Map_2PActResults:	BINCLUDE "mappings/misc/2P Act Results.eni"

; 2P zone results screen (enigma compressed)
; byte_88CE:
Map_2PZoneResults:	BINCLUDE "mappings/misc/2P Zone Results.eni"

; 2P game results screen (after all 4 zones) (enigma compressed)
; byte_8960:
Map_2PGameResults:	BINCLUDE "mappings/misc/2P Game Results.eni"

; 2P special stage act results screen (enigma compressed)
; byte_8AA4:
Map_2PSpecialStageActResults:	BINCLUDE "mappings/misc/2P Special Stage Act Results.eni"

; 2P special stage zone results screen (enigma compressed)
; byte_8B30:
Map_2PSpecialStageZoneResults:	BINCLUDE "mappings/misc/2P Special Stage Zone Results.eni"

	even

	jmpTos JmpTo2_Adjust2PArtPointer,JmpTo_Dynamic_Normal




; ===========================================================================
; loc_8BD4:
MenuScreen:
	bsr.w	Pal_FadeToBlack
	move	#$2700,sr
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	ClearScreen
	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)		; PNT A base: $C000
	move.w	#$8400|(VRAM_Menu_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $E000
	move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)		; PNT A base: $C000
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled
	move.w	#$9001,(a6)		; Scroll table size: 64x32

	clearRAM Object_Display_Lists,Object_Display_Lists_End
	clearRAM Object_RAM,Object_RAM_End

	; load background + graphics of font/LevSelPics
	clr.w	(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_FontStuff),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_FontStuff).l,a0
	bsr.w	NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_MenuBox),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_MenuBox).l,a0
	bsr.w	NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_LevelSelectPics),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_LevelSelectPics).l,a0
	bsr.w	NemDec
	lea	(Chunk_Table).l,a1
	lea	(MapEng_MenuBack).l,a0
	move.w	#make_art_tile(ArtTile_VRAM_Start,3,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
	moveq	#40-1,d1
	moveq	#28-1,d2
	jsrto	JmpTo_PlaneMapToVRAM_H40	; fullscreen background

	cmpi.b	#GameModeID_OptionsMenu,(Game_Mode).w	; options menu?
	beq.w	MenuScreen_Options	; if yes, branch

	cmpi.b	#GameModeID_LevelSelect,(Game_Mode).w	; level select menu?
	beq.w	MenuScreen_LevelSelect	; if yes, branch

;MenuScreen_LevSel2P:
	lea	(Chunk_Table).l,a1
	lea	(MapEng_LevSel2P).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox,0,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table+$198).l,a1
	lea	(MapEng_LevSel2P).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox,1,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table+$330).l,a1
	lea	(MapEng_LevSelIcon).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_LevelSelectPics,0,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table+$498).l,a2

	moveq	#bytesToWcnt(tiles_to_bytes(1)),d1
-	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox+11,1,0),(a2)+
	dbf	d1,-

	bsr.w	Update2PLevSelSelection
	addq.b	#1,(Current_Zone_2P).w
	andi.b	#3,(Current_Zone_2P).w
	bsr.w	ClearOld2PLevSelSelection
	addq.b	#1,(Current_Zone_2P).w
	andi.b	#3,(Current_Zone_2P).w
	bsr.w	ClearOld2PLevSelSelection
	addq.b	#1,(Current_Zone_2P).w
	andi.b	#3,(Current_Zone_2P).w
	bsr.w	ClearOld2PLevSelSelection
	addq.b	#1,(Current_Zone_2P).w
	andi.b	#3,(Current_Zone_2P).w
	clr.w	(Player_mode).w
	clr.b	(Current_Act_2P).w
	clr.w	(Results_Screen_2P).w	; VsRSID_Act
	clr.b	(Level_started_flag).w
	clr.w	(Anim_Counters).w
	clr.w	(Game_Over_2P).w
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo2_Dynamic_Normal
	moveq	#PalID_Menu,d0
	bsr.w	PalLoad_ForFade
	lea	(Normal_palette_line3).w,a1
	lea	(Target_palette_line3).w,a2

	moveq	#bytesToLcnt(tiles_to_bytes(1)),d1
-	move.l	(a1),(a2)+
	clr.l	(a1)+
	dbf	d1,-

	move.b	#MusID_Options,d0
	jsrto	JmpTo_PlayMusic
	move.w	#(30*60)-1,(Demo_Time_left).w	; 30 seconds
	clr.w	(Two_player_mode).w
	clr.l	(Camera_X_pos).w
	clr.l	(Camera_Y_pos).w
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromBlack

;loc_8DA8:
LevelSelect2P_Main:
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move	#$2700,sr
	bsr.w	ClearOld2PLevSelSelection
	bsr.w	LevelSelect2P_Controls
	bsr.w	Update2PLevSelSelection
	move	#$2300,sr
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo2_Dynamic_Normal
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0
	bne.s	LevelSelect2P_PressStart
	bra.w	LevelSelect2P_Main
; ===========================================================================
;loc_8DE2:
LevelSelect2P_PressStart:
	bsr.w	Chk2PZoneCompletion
	bmi.s	loc_8DF4
	move.w	#SndID_Error,d0
	jsrto	JmpTo_PlaySound
	bra.w	LevelSelect2P_Main
; ===========================================================================

loc_8DF4:
	moveq	#0,d0
	move.b	(Current_Zone_2P).w,d0
	add.w	d0,d0
	move.w	LevelSelect2P_LevelOrder(pc,d0.w),d0
	bmi.s	loc_8E3A
	move.w	d0,(Current_ZoneAndAct).w
	move.w	#1,(Two_player_mode).w
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	move.b	#0,(Last_star_pole_hit).w
	move.b	#0,(Last_star_pole_hit_2P).w
	moveq	#0,d0
	move.l	d0,(Score).w
	move.l	d0,(Score_2P).w
	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w
	rts
; ===========================================================================

loc_8E3A:
	move.b	#4,(Current_Special_Stage).w
	move.b	#GameModeID_SpecialStage,(Game_Mode).w ; => SpecialStage
	moveq	#1,d0
	move.w	d0,(Two_player_mode).w
	move.w	d0,(Two_player_mode_copy).w
	rts
; ===========================================================================
; word_8E52:
LevelSelect2P_LevelOrder:
	dc.w	emerald_hill_zone_act_1
	dc.w	mystic_cave_zone_act_1
	dc.w	casino_night_zone_act_1
	dc.w	$FFFF

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_8E5A:
LevelSelect2P_Controls:
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	move.b	d0,d1
	andi.b	#button_up_mask|button_down_mask,d0
	beq.s	+
	bchg	#1,(Current_Zone_2P).w

+
	andi.b	#button_left_mask|button_right_mask,d1
	beq.s	+	; rts
	bchg	#0,(Current_Zone_2P).w
+
	rts
; End of function LevelSelect2P_Controls

; ---------------------------------------------------------------------------
; Subroutine to update the 2P level select selection graphically
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_8E7E:
Update2PLevSelSelection:
	moveq	#0,d0
	move.b	(Current_Zone_2P).w,d0
	lsl.w	#4,d0	; 16 bytes per entry
	lea	(LevSel2PIconData).l,a3
	lea	(a3,d0.w),a3
	move.w	#palette_line_3,d0	; highlight text
	lea	(Chunk_Table+$48).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$94).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$D8).l,a2
	movea.l	4(a3),a1
	bsr.w	Chk2PZoneCompletion	; has the zone been completed?
	bmi.s	+	; if not, branch
	lea	(Chunk_Table+$468).l,a1	; display large X instead of icon
+
	moveq	#2,d1
-	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	lea	$1A(a2),a2
	dbf	d1,-

	lea	(Chunk_Table).l,a1
	move.l	(a3)+,d0
	moveq	#17-1,d1
	moveq	#12-1,d2
	jsrto	JmpTo_PlaneMapToVRAM_H40
	lea	(Pal_LevelIcons).l,a1
	moveq	#0,d0
	move.b	(a3),d0
	lsl.w	#5,d0
	lea	(a1,d0.w),a1
	lea	(Normal_palette_line3).w,a2

	moveq	#bytesToLcnt(palette_line_size),d1
-	move.l	(a1)+,(a2)+
	dbf	d1,-

	rts
; End of function Update2PLevSelSelection

; ---------------------------------------------------------------------------
; Subroutine to check if a 2P zone has been completed
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_8EFE:
Chk2PZoneCompletion:
	moveq	#0,d0
	move.b	(Current_Zone_2P).w,d0
	; multiply d0 by 6
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	add.w	d0,d0
	lea	(Results_Data_2P).w,a5
	lea	(a5,d0.w),a5
	move.w	(a5),d0
	add.w	2(a5),d0
	rts
; End of function Chk2PZoneCompletion

; ---------------------------------------------------------------------------
; Subroutine to clear the old 2P level select selection
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_8F1C:
ClearOld2PLevSelSelection:
	moveq	#0,d0
	move.b	(Current_Zone_2P).w,d0
	lsl.w	#4,d0
	lea	(LevSel2PIconData).l,a3
	lea	(a3,d0.w),a3
	moveq	#palette_line_0,d0
	lea	(Chunk_Table+$1E0).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$22C).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$270).l,a2
	lea	(Chunk_Table+$498).l,a1
	bsr.w	Chk2PZoneCompletion
	bmi.s	+
	lea	(Chunk_Table+$468).l,a1
+
	moveq	#2,d1
-	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	lea	$1A(a2),a2
	dbf	d1,-

	lea	(Chunk_Table+$198).l,a1
	move.l	(a3)+,d0
	moveq	#17-1,d1
	moveq	#12-1,d2
	jmpto	JmpTo_PlaneMapToVRAM_H40
; End of function ClearOld2PLevSelSelection

; ===========================================================================
; off_8F7E:
LevSel2PIconData:

; macro to declare icon data for a 2P level select icon
iconData macro txtlabel,txtlabel2,vramAddr,iconPal,iconAddr
	dc.l txtlabel, txtlabel2	; text locations
	dc.l vdpComm(vramAddr,VRAM,WRITE)	; VRAM location to place data
	dc.l iconPal<<24|((iconAddr)&$FFFFFF)	; icon palette and plane data location
    endm

	iconData	Text2P_EmeraldHill,Text2P_Zone, VRAM_Plane_A_Name_Table+planeLoc(64,2,2),   0,Chunk_Table+$330
	iconData	Text2P_MysticCave, Text2P_Zone, VRAM_Plane_A_Name_Table+planeLoc(64,22,2),  5,Chunk_Table+$3A8
	iconData	Text2P_CasinoNight,Text2P_Zone, VRAM_Plane_A_Name_Table+planeLoc(64,2,15),  6,Chunk_Table+$3C0
	iconData	Text2P_Special,    Text2P_Stage,VRAM_Plane_A_Name_Table+planeLoc(64,22,15),12,Chunk_Table+$450

; ---------------------------------------------------------------------------
; Common menu screen subroutine for transferring text to RAM

; ARGUMENTS:
; d0 = starting art tile
; a1 = data source
; a2 = destination
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_8FBE:
MenuScreenTextToRAM:
	moveq	#0,d1
	move.b	(a1)+,d1
-	move.b	(a1)+,d0
	move.w	d0,(a2)+
	dbf	d1,-
	rts
; End of function MenuScreenTextToRAM

; ===========================================================================
; loc_8FCC:
MenuScreen_Options:
	lea	(Chunk_Table).l,a1
	lea	(MapEng_Options).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox,0,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table+$160).l,a1
	lea	(MapEng_Options).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox,1,0),d0
	bsr.w	EniDec
	clr.b	(Options_menu_box).w
	bsr.w	OptionScreen_DrawSelected
	addq.b	#1,(Options_menu_box).w
	bsr.w	OptionScreen_DrawUnselected
	addq.b	#1,(Options_menu_box).w
	bsr.w	OptionScreen_DrawUnselected
	clr.b	(Options_menu_box).w
	clr.b	(Level_started_flag).w
	clr.w	(Anim_Counters).w
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo2_Dynamic_Normal
	moveq	#PalID_Menu,d0
	bsr.w	PalLoad_ForFade
	move.b	#MusID_Options,d0
	jsrto	JmpTo_PlayMusic
	clr.w	(Two_player_mode).w
	clr.l	(Camera_X_pos).w
	clr.l	(Camera_Y_pos).w
	clr.w	(Correct_cheat_entries).w
	clr.w	(Correct_cheat_entries_2).w
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromBlack
; loc_9060:
OptionScreen_Main:
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move	#$2700,sr
	bsr.w	OptionScreen_DrawUnselected
	bsr.w	OptionScreen_Controls
	bsr.w	OptionScreen_DrawSelected
	move	#$2300,sr
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo2_Dynamic_Normal
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0
	bne.s	OptionScreen_Select
	bra.w	OptionScreen_Main
; ===========================================================================
; loc_909A:
OptionScreen_Select:
	move.b	(Options_menu_box).w,d0
	bne.s	OptionScreen_Select_Not1P
	; Start a single player game
	moveq	#0,d0
	move.w	d0,(Two_player_mode).w
	move.w	d0,(Two_player_mode_copy).w
    if emerald_hill_zone_act_1=0
	move.w	d0,(Current_ZoneAndAct).w ; emerald_hill_zone_act_1
    else
	move.w	#emerald_hill_zone_act_1,(Current_ZoneAndAct).w
    endif
    if fixBugs
	; The game forgets to reset these variables here, making it possible
	; for the player to repeatedly soft-reset and play Emerald Hill Zone
	; over and over again, collecting all of the emeralds within the
	; first act. This code is borrowed from similar logic in the title
	; screen, which doesn't make this mistake.
	move.w	d0,(Current_Special_StageAndAct).w
	move.w	d0,(Got_Emerald).w
	move.l	d0,(Got_Emeralds_array).w
	move.l	d0,(Got_Emeralds_array+4).w
    endif
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	rts
; ===========================================================================
; loc_90B6:
OptionScreen_Select_Not1P:
	subq.b	#1,d0
	bne.s	OptionScreen_Select_Other
	; Start a 2P VS game
	moveq	#1,d0
	move.w	d0,(Two_player_mode).w
	move.w	d0,(Two_player_mode_copy).w
    if fixBugs
	; The game forgets to reset these variables here, making it possible
	; for the player to play two player mode with all emeralds collected,
	; allowing them to use Super Sonic. This code is borrowed from
	; similar logic in the title screen, which doesn't make this mistake.
	moveq	#0,d0
	move.w	d0,(Got_Emerald).w
	move.l	d0,(Got_Emeralds_array).w
	move.l	d0,(Got_Emeralds_array+4).w
    endif
	move.b	#GameModeID_2PLevelSelect,(Game_Mode).w ; => LevelSelectMenu2P
	move.b	#0,(Current_Zone_2P).w
	move.w	#0,(Player_mode).w
	rts
; ===========================================================================
; loc_90D8:
OptionScreen_Select_Other:
	; When pressing START on the sound test option, return to the SEGA screen
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_90E0:
OptionScreen_Controls:
	moveq	#0,d2
	move.b	(Options_menu_box).w,d2
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	btst	#button_up,d0
	beq.s	+
	subq.b	#1,d2
	bcc.s	+
	move.b	#2,d2

+
	btst	#button_down,d0
	beq.s	+
	addq.b	#1,d2
	cmpi.b	#3,d2
	blo.s	+
	moveq	#0,d2

+
	move.b	d2,(Options_menu_box).w
	lsl.w	#2,d2
	move.b	OptionScreen_Choices(pc,d2.w),d3 ; number of choices for the option
	movea.l	OptionScreen_Choices(pc,d2.w),a1 ; location where the choice is stored (in RAM)
	move.w	(a1),d2
	btst	#button_left,d0
	beq.s	+
	subq.b	#1,d2
	bcc.s	+
	move.b	d3,d2

+
	btst	#button_right,d0
	beq.s	+
	addq.b	#1,d2
	cmp.b	d3,d2
	bls.s	+
	moveq	#0,d2

+
    if fixBugs
	; Based on code from the Level Select.
	cmpi.b	#2,(Options_menu_box).w
	bne.s	+
	btst	#button_A,d0
	beq.s	+
	addi.b	#$10,d2
	andi.b	#$7F,d2
    else
	; This code appears to have been carelessly created from a copy of the
	; above block of code. It makes no sense to advance by $10 on options
	; that have only 2 or 3 values. Likewise, the logic for setting the
	; value to 0 when exceeding the maximum bound only makes sense for
	; incrementing by 1, not $10.
	btst	#button_A,d0
	beq.s	+
	addi.b	#$10,d2
	cmp.b	d3,d2
	bls.s	+
	moveq	#0,d2
    endif

+
	move.w	d2,(a1)
	cmpi.b	#2,(Options_menu_box).w
	bne.s	+	; rts
	andi.w	#button_B_mask|button_C_mask,d0
	beq.s	+	; rts
	move.w	(Sound_test_sound).w,d0
	addi.w	#$80,d0
	jsrto	JmpTo_PlayMusic
	lea	(level_select_cheat).l,a0
	lea	(continues_cheat).l,a2
	lea	(Level_select_flag).w,a1	; Also Slow_motion_flag
	moveq	#0,d2	; flag to tell the routine to enable the continues cheat
	bsr.w	CheckCheats

+
	rts
; End of function OptionScreen_Controls

; ===========================================================================
; word_917A:
OptionScreen_Choices:
	dc.l (3-1)<<24|(Player_option&$FFFFFF)
	dc.l (2-1)<<24|(Two_player_items&$FFFFFF)
	dc.l ($80-1)<<24|(Sound_test_sound&$FFFFFF)

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_9186
OptionScreen_DrawSelected:
	bsr.w	OptionScreen_SelectTextPtr
	moveq	#0,d1
	move.b	(Options_menu_box).w,d1
	lsl.w	#3,d1
	lea	(OptScrBoxData).l,a3
	lea	(a3,d1.w),a3
	move.w	#palette_line_3,d0
	lea	(Chunk_Table+$30).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$B6).l,a2
	moveq	#0,d1
	cmpi.b	#2,(Options_menu_box).w
	beq.s	+
	move.b	(Options_menu_box).w,d1
	lsl.w	#2,d1
	lea	OptionScreen_Choices(pc),a1
	movea.l	(a1,d1.w),a1
	move.w	(a1),d1
	lsl.w	#2,d1
+
	movea.l	(a4,d1.w),a1
	bsr.w	MenuScreenTextToRAM
	cmpi.b	#2,(Options_menu_box).w
	bne.s	+
	lea	(Chunk_Table+$C2).l,a2
	bsr.w	OptionScreen_HexDumpSoundTest
+
	lea	(Chunk_Table).l,a1
	move.l	(a3)+,d0
	moveq	#22-1,d1
	moveq	#8-1,d2
	jmpto	JmpTo_PlaneMapToVRAM_H40
; ===========================================================================

;loc_91F8
OptionScreen_DrawUnselected:
	bsr.w	OptionScreen_SelectTextPtr
	moveq	#0,d1
	move.b	(Options_menu_box).w,d1
	lsl.w	#3,d1
	lea	(OptScrBoxData).l,a3
	lea	(a3,d1.w),a3
	moveq	#palette_line_0,d0
	lea	(Chunk_Table+$190).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$216).l,a2
	moveq	#0,d1
	cmpi.b	#2,(Options_menu_box).w
	beq.s	+
	move.b	(Options_menu_box).w,d1
	lsl.w	#2,d1
	lea	OptionScreen_Choices(pc),a1
	movea.l	(a1,d1.w),a1
	move.w	(a1),d1
	lsl.w	#2,d1

+
	movea.l	(a4,d1.w),a1
	bsr.w	MenuScreenTextToRAM
	cmpi.b	#2,(Options_menu_box).w
	bne.s	+
	lea	(Chunk_Table+$222).l,a2
	bsr.w	OptionScreen_HexDumpSoundTest

+
	lea	(Chunk_Table+$160).l,a1
	move.l	(a3)+,d0
	moveq	#22-1,d1
	moveq	#8-1,d2
	jmpto	JmpTo_PlaneMapToVRAM_H40
; ===========================================================================

;loc_9268
OptionScreen_SelectTextPtr:
	lea	(off_92D2).l,a4
	tst.b	(Graphics_Flags).w
	bpl.s	+
	lea	(off_92DE).l,a4

+
	tst.b	(Options_menu_box).w
	beq.s	+
	lea	(off_92EA).l,a4

+
	cmpi.b	#2,(Options_menu_box).w
	bne.s	+	; rts
	lea	(off_92F2).l,a4

+
	rts
; ===========================================================================

;loc_9296
OptionScreen_HexDumpSoundTest:
	move.w	(Sound_test_sound).w,d1
	move.b	d1,d2
	lsr.b	#4,d1
	bsr.s	+
	move.b	d2,d1

+
	andi.w	#$F,d1
	cmpi.b	#$A,d1
	blo.s	+
	addi.b	#4,d1

+
	addi.b	#$10,d1
	move.b	d1,d0
	move.w	d0,(a2)+
	rts
; ===========================================================================
; off_92BA:
OptScrBoxData:

; macro to declare the data for an options screen box
boxData macro txtlabel,vramAddr
	dc.l txtlabel, vdpComm(vramAddr,VRAM,WRITE)
    endm

	boxData	TextOptScr_PlayerSelect,VRAM_Plane_A_Name_Table+planeLoc(64,9,3)
	boxData	TextOptScr_VsModeItems,VRAM_Plane_A_Name_Table+planeLoc(64,9,11)
	boxData	TextOptScr_SoundTest,VRAM_Plane_A_Name_Table+planeLoc(64,9,19)

off_92D2:
	dc.l TextOptScr_SonicAndMiles
	dc.l TextOptScr_SonicAlone
	dc.l TextOptScr_MilesAlone
off_92DE:
	dc.l TextOptScr_SonicAndTails
	dc.l TextOptScr_SonicAlone
	dc.l TextOptScr_TailsAlone
off_92EA:
	dc.l TextOptScr_AllKindsItems
	dc.l TextOptScr_TeleportOnly
off_92F2:
	dc.l TextOptScr_0
; ===========================================================================
; loc_92F6:
MenuScreen_LevelSelect:
	; Load foreground (sans zone icon)
	lea	(Chunk_Table).l,a1
	lea	(MapEng_LevSel).l,a0	; 2 bytes per 8x8 tile, compressed
	move.w	#make_art_tile(ArtTile_VRAM_Start,0,0),d0
	bsr.w	EniDec

	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
	moveq	#40-1,d1
	moveq	#28-1,d2	; 40x28 = whole screen
	jsrto	JmpTo_PlaneMapToVRAM_H40	; display patterns

	; Draw sound test number
	moveq	#palette_line_0,d3
	bsr.w	LevelSelect_DrawSoundNumber

	; Load zone icon
	lea	(Chunk_Table+planeLoc(40,0,28)).l,a1
	lea	(MapEng_LevSelIcon).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_LevelSelectPics,0,0),d0
	bsr.w	EniDec

	bsr.w	LevelSelect_DrawIcon

	clr.w	(Player_mode).w
	clr.w	(Results_Screen_2P).w	; VsRSID_Act
	clr.b	(Level_started_flag).w
	clr.w	(Anim_Counters).w

	; Animate background (loaded back in MenuScreen)
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo2_Dynamic_Normal	; background

	moveq	#PalID_Menu,d0
	bsr.w	PalLoad_ForFade

	lea	(Normal_palette_line3).w,a1
	lea	(Target_palette_line3).w,a2

	moveq	#bytesToLcnt(palette_line_size),d1
-	move.l	(a1),(a2)+
	clr.l	(a1)+
	dbf	d1,-

	move.b	#MusID_Options,d0
	jsrto	JmpTo_PlayMusic

	move.w	#(30*60)-1,(Demo_Time_left).w	; 30 seconds
	clr.w	(Two_player_mode).w
	clr.l	(Camera_X_pos).w
	clr.l	(Camera_Y_pos).w
	clr.w	(Correct_cheat_entries).w
	clr.w	(Correct_cheat_entries_2).w

	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint

	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l

	bsr.w	Pal_FadeFromBlack

;loc_93AC:
LevelSelect_Main:	; routine running during level select
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint

	move	#$2700,sr

	moveq	#palette_line_0,d3
	bsr.w	LevelSelect_MarkFields	; unmark fields
	bsr.w	LevSelControls		; possible change selected fields
	move.w	#palette_line_3,d3
	bsr.w	LevelSelect_MarkFields	; mark fields

	bsr.w	LevelSelect_DrawIcon

	move	#$2300,sr

	lea	(Anim_SonicMilesBG).l,a2
	jsrto	JmpTo2_Dynamic_Normal

	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0	; start pressed?
	bne.s	LevelSelect_PressStart	; yes
	bra.w	LevelSelect_Main	; no
; ===========================================================================

;loc_93F0:
LevelSelect_PressStart:
	move.w	(Level_select_zone).w,d0
	add.w	d0,d0
	move.w	LevelSelect_Order(pc,d0.w),d0
	bmi.w	LevelSelect_Return	; sound test
	cmpi.w	#$4000,d0
	bne.s	LevelSelect_StartZone

;LevelSelect_SpecialStage:
	move.b	#GameModeID_SpecialStage,(Game_Mode).w ; => SpecialStage
    if emerald_hill_zone_act_1=0
	clr.w	(Current_ZoneAndAct).w ; emerald_hill_zone_act_1
    else
	move.w	#emerald_hill_zone_act_1,(Current_ZoneAndAct).w
    endif
	move.b	#3,(Life_count).w
	move.b	#3,(Life_count_2P).w
	moveq	#0,d0
	move.w	d0,(Ring_count).w
	move.l	d0,(Timer).w
	move.l	d0,(Score).w
	move.w	d0,(Ring_count_2P).w
	move.l	d0,(Timer_2P).w
	move.l	d0,(Score_2P).w
	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w
	move.w	(Player_option).w,(Player_mode).w
	rts
; ===========================================================================

;loc_944C:
LevelSelect_Return:
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ===========================================================================
; -----------------------------------------------------------------------------
; Level Select Level Order

; One entry per item in the level select menu. Just set the value for the item
; you want to link to the level/act number of the level you want to load when
; the player selects that item.
; -----------------------------------------------------------------------------
;Misc_9454:
LevelSelect_Order:
	dc.w	emerald_hill_zone_act_1
	dc.w	emerald_hill_zone_act_2	; 1
	dc.w	chemical_plant_zone_act_1	; 2
	dc.w	chemical_plant_zone_act_2	; 3
	dc.w	aquatic_ruin_zone_act_1	; 4
	dc.w	aquatic_ruin_zone_act_2	; 5
	dc.w	casino_night_zone_act_1	; 6
	dc.w	casino_night_zone_act_2	; 7
	dc.w	hill_top_zone_act_1	; 8
	dc.w	hill_top_zone_act_2	; 9
	dc.w	mystic_cave_zone_act_1	; 10
	dc.w	mystic_cave_zone_act_2	; 11
	dc.w	oil_ocean_zone_act_1	; 12
	dc.w	oil_ocean_zone_act_2	; 13
	dc.w	metropolis_zone_act_1	; 14
	dc.w	metropolis_zone_act_2	; 15
	dc.w	metropolis_zone_act_3	; 16
	dc.w	sky_chase_zone_act_1	; 17
	dc.w	wing_fortress_zone_act_1	; 18
	dc.w	death_egg_zone_act_1	; 19
	dc.w	$4000	; 20 - special stage
	dc.w	$FFFF	; 21 - sound test
; ===========================================================================

;loc_9480:
LevelSelect_StartZone:
	andi.w	#$3FFF,d0
	move.w	d0,(Current_ZoneAndAct).w
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	move.b	#3,(Life_count).w
	move.b	#3,(Life_count_2P).w
	moveq	#0,d0
	move.w	d0,(Ring_count).w
	move.l	d0,(Timer).w
	move.l	d0,(Score).w
	move.w	d0,(Ring_count_2P).w
	move.l	d0,(Timer_2P).w
	move.l	d0,(Score_2P).w
	move.b	d0,(Continue_count).w
	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w
	move.b	#MusID_FadeOut,d0
	jsrto	JmpTo_PlaySound
	moveq	#0,d0
	move.w	d0,(Two_player_mode_copy).w
	move.w	d0,(Two_player_mode).w
	rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Change what you're selecting in the level select
; ---------------------------------------------------------------------------
; loc_94DC:
LevSelControls:
	move.b	(Ctrl_1_Press).w,d1
	andi.b	#button_up_mask|button_down_mask,d1
	bne.s	+	; up/down pressed
	subq.w	#1,(LevSel_HoldTimer).w
	bpl.s	LevSelControls_CheckLR

+
	move.w	#$B,(LevSel_HoldTimer).w
	move.b	(Ctrl_1_Held).w,d1
	andi.b	#button_up_mask|button_down_mask,d1
	beq.s	LevSelControls_CheckLR	; up/down not pressed, check for left & right
	move.w	(Level_select_zone).w,d0
	btst	#button_up,d1
	beq.s	+
	subq.w	#1,d0	; decrease by 1
	bcc.s	+	; >= 0?
	moveq	#$15,d0	; set to $15

+
	btst	#button_down,d1
	beq.s	+
	addq.w	#1,d0	; yes, add 1
	cmpi.w	#$16,d0
	blo.s	+	; smaller than $16?
	moveq	#0,d0	; if not, set to 0

+
	move.w	d0,(Level_select_zone).w
	rts
; ===========================================================================
; loc_9522:
LevSelControls_CheckLR:
	cmpi.w	#$15,(Level_select_zone).w	; are we in the sound test?
	bne.s	LevSelControls_SwitchSide	; no
	move.w	(Sound_test_sound).w,d0
	move.b	(Ctrl_1_Press).w,d1
	btst	#button_left,d1
	beq.s	+
	subq.b	#1,d0
	bcc.s	+
	moveq	#$7F,d0

+
	btst	#button_right,d1
	beq.s	+
	addq.b	#1,d0
	cmpi.w	#$80,d0
	blo.s	+
	moveq	#0,d0

+
	btst	#button_A,d1
	beq.s	+
	addi.b	#$10,d0
	andi.b	#$7F,d0

+
	move.w	d0,(Sound_test_sound).w
	andi.w	#button_B_mask|button_C_mask,d1
	beq.s	+	; rts
	move.w	(Sound_test_sound).w,d0
	addi.w	#$80,d0
	jsrto	JmpTo_PlayMusic
	lea	(debug_cheat).l,a0
	lea	(super_sonic_cheat).l,a2
	lea	(Debug_options_flag).w,a1	; Also S1_hidden_credits_flag
	moveq	#1,d2	; flag to tell the routine to enable the Super Sonic cheat
	bsr.w	CheckCheats

+
	rts
; ===========================================================================
; loc_958A:
LevSelControls_SwitchSide:	; not in soundtest, not up/down pressed
	move.b	(Ctrl_1_Press).w,d1
	andi.b	#button_left_mask|button_right_mask,d1
	beq.s	+				; no direction key pressed
	move.w	(Level_select_zone).w,d0	; left or right pressed
	move.b	LevelSelect_SwitchTable(pc,d0.w),d0 ; set selected zone according to table
	move.w	d0,(Level_select_zone).w
+
	rts
; ===========================================================================
;byte_95A2:
LevelSelect_SwitchTable:
	dc.b $E
	dc.b $F		; 1
	dc.b $11	; 2
	dc.b $11	; 3
	dc.b $12	; 4
	dc.b $12	; 5
	dc.b $13	; 6
	dc.b $13	; 7
	dc.b $14	; 8
	dc.b $14	; 9
	dc.b $15	; 10
	dc.b $15	; 11
	dc.b $C		; 12
	dc.b $D		; 13
	dc.b 0		; 14
	dc.b 1		; 15
	dc.b 1		; 16
	dc.b 2		; 17
	dc.b 4		; 18
	dc.b 6		; 19
	dc.b 8		; 20
	dc.b $A		; 21
	even
; ===========================================================================

;loc_95B8:
LevelSelect_MarkFields:
	lea	(Chunk_Table).l,a4
	lea	(LevSel_MarkTable).l,a5
	lea	(VDP_data_port).l,a6
	moveq	#0,d0
	move.w	(Level_select_zone).w,d0
	lsl.w	#2,d0
	lea	(a5,d0.w),a3
	moveq	#0,d0
	move.b	(a3),d0
	mulu.w	#$50,d0
	moveq	#0,d1
	move.b	1(a3),d1
	add.w	d1,d0
	lea	(a4,d0.w),a1
	moveq	#0,d1
	move.b	(a3),d1
	lsl.w	#7,d1
	add.b	1(a3),d1
	addi.w	#VRAM_Plane_A_Name_Table,d1
	lsl.l	#2,d1
	lsr.w	#2,d1
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d1
	swap	d1
	move.l	d1,4(a6)

	moveq	#$D,d2
-	move.w	(a1)+,d0
	add.w	d3,d0
	move.w	d0,(a6)
	dbf	d2,-

	addq.w	#2,a3
	moveq	#0,d0
	move.b	(a3),d0
	beq.s	+
	mulu.w	#$50,d0
	moveq	#0,d1
	move.b	1(a3),d1
	add.w	d1,d0
	lea	(a4,d0.w),a1
	moveq	#0,d1
	move.b	(a3),d1
	lsl.w	#7,d1
	add.b	1(a3),d1
	addi.w	#VRAM_Plane_A_Name_Table,d1
	lsl.l	#2,d1
	lsr.w	#2,d1
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d1
	swap	d1
	move.l	d1,4(a6)
	move.w	(a1)+,d0
	add.w	d3,d0
	move.w	d0,(a6)

+
	cmpi.w	#$15,(Level_select_zone).w
	bne.s	+	; rts
	bsr.w	LevelSelect_DrawSoundNumber
+
	rts
; ===========================================================================
;loc_965A:
LevelSelect_DrawSoundNumber:
	move.l	#vdpComm(VRAM_Plane_A_Name_Table+planeLoc(64,34,18),VRAM,WRITE),(VDP_control_port).l
	move.w	(Sound_test_sound).w,d0
	move.b	d0,d2
	lsr.b	#4,d0
	bsr.s	+
	move.b	d2,d0

+
	andi.w	#$F,d0
	cmpi.b	#$A,d0
	blo.s	+
	addi.b	#4,d0

+
	addi.b	#$10,d0
	add.w	d3,d0
	move.w	d0,(a6)
	rts
; ===========================================================================

;loc_9688:
LevelSelect_DrawIcon:
	move.w	(Level_select_zone).w,d0
	lea	(LevSel_IconTable).l,a3
	lea	(a3,d0.w),a3
	lea	(Chunk_Table+planeLoc(40,0,28)).l,a1
	moveq	#0,d0
	move.b	(a3),d0
	lsl.w	#3,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	lea	(a1,d0.w),a1
	move.l	#vdpComm(VRAM_Plane_A_Name_Table+planeLoc(64,27,22),VRAM,WRITE),d0
	moveq	#4-1,d1
	moveq	#3-1,d2
	jsrto	JmpTo_PlaneMapToVRAM_H40
	lea	(Pal_LevelIcons).l,a1
	moveq	#0,d0
	move.b	(a3),d0
	lsl.w	#5,d0
	lea	(a1,d0.w),a1
	lea	(Normal_palette_line3).w,a2

    if fixBugs
	; When the icon changes, the colours are briefly incorrect. This is
	; because there's a delay between the icon being updated and the
	; colours being updated, due to the colours being uploaded to the VDP
	; during V-Int. To avoid this we can upload the colours ourselves right
	; here.
	; Prepare the VDP for data transfer.
	move.l  #vdpComm(2*16*2,CRAM,WRITE),VDP_control_port-VDP_data_port(a6)
    endif

	moveq	#bytesToLcnt(palette_line_size),d1
-
    if fixBugs
	; Upload colours to the VDP.
	move.l	(a1),(a6)
    endif
	move.l	(a1)+,(a2)+
	dbf	d1,-

	rts
; ===========================================================================
;byte_96D8
LevSel_IconTable:
	dc.b   0,0	;0	EHZ
	dc.b   7,7	;2	CPZ
	dc.b   8,8	;4	ARZ
	dc.b   6,6	;6	CNZ
	dc.b   2,2	;8	HTZ
	dc.b   5,5	;$A	MCZ
	dc.b   4,4	;$C	OOZ
	dc.b   1,1,1	;$E	MTZ
	dc.b   9	;$11	SCZ
	dc.b  $A	;$12	WFZ
	dc.b  $B	;$13	DEZ
	dc.b  $C	;$14	Special Stage
	dc.b  $E	;$15	Sound Test
	even
;byte_96EE:
LevSel_MarkTable:	; 4 bytes per level select entry
; line primary, 2*column ($E fields), line secondary, 2*column secondary (1 field)
	dc.b   3,  6,  3,$24	;0
	dc.b   3,  6,  4,$24
	dc.b   6,  6,  6,$24
	dc.b   6,  6,  7,$24
	dc.b   9,  6,  9,$24	;4
	dc.b   9,  6, $A,$24
	dc.b  $C,  6, $C,$24
	dc.b  $C,  6, $D,$24
	dc.b  $F,  6, $F,$24	;8
	dc.b  $F,  6,$10,$24
	dc.b $12,  6,$12,$24
	dc.b $12,  6,$13,$24
	dc.b $15,  6,$15,$24	;$C
	dc.b $15,  6,$16,$24
; --- second column ---
	dc.b   3,$2C,  3,$48
	dc.b   3,$2C,  4,$48
	dc.b   3,$2C,  5,$48	;$10
	dc.b   6,$2C,  0,  0
	dc.b   9,$2C,  0,  0
	dc.b  $C,$2C,  0,  0
	dc.b  $F,$2C,  0,  0	;$14
	dc.b $12,$2C,$12,$48
; ===========================================================================
; loc_9746:
CheckCheats:	; This is called from 2 places: the options screen and the level select screen
	move.w	(Correct_cheat_entries).w,d0	; Get the number of correct sound IDs entered so far
	adda.w	d0,a0				; Skip to the next entry
	move.w	(Sound_test_sound).w,d0		; Get the current sound test sound
	cmp.b	(a0),d0				; Compare it to the cheat
	bne.s	+				; If they're different, branch
	addq.w	#1,(Correct_cheat_entries).w	; Add 1 to the number of correct entries
	tst.b	1(a0)				; Is the next entry 0?
	bne.s	++				; If not, branch
	move.w	#$101,(a1)			; Enable the cheat
	move.b	#SndID_Ring,d0			; Play the ring sound
	jsrto	JmpTo_PlaySound
+
	move.w	#0,(Correct_cheat_entries).w	; Clear the number of correct entries
+
	move.w	(Correct_cheat_entries_2).w,d0	; Do the same procedure with the other cheat
	adda.w	d0,a2
	move.w	(Sound_test_sound).w,d0
	cmp.b	(a2),d0
	bne.s	++
	addq.w	#1,(Correct_cheat_entries_2).w
	tst.b	1(a2)
	bne.s	+++	; rts
	tst.w	d2				; Test this to determine which cheat to enable
	bne.s	+				; If not 0, branch
	move.b	#$F,(Continue_count).w		; Give 15 continues
    if fixBugs
	; Fun fact: this was fixed in the version of Sonic 2 included in
	; Sonic Mega Collection.
	move.b	#SndID_ContinueJingle,d0	; Play the continue jingle
    else
	; The next line causes the bug where the OOZ music plays until reset.
	; Remove "&$7F" to fix the bug.
	move.b	#SndID_ContinueJingle&$7F,d0	; Play the continue jingle
    endif
	jsrto	JmpTo_PlayMusic
	bra.s	++
; ===========================================================================
+
	move.w	#7,(Got_Emerald).w		; Give 7 emeralds to the player
	move.b	#MusID_Emerald,d0		; Play the emerald jingle
	jsrto	JmpTo_PlayMusic
+
	move.w	#0,(Correct_cheat_entries_2).w	; Clear the number of correct entries
+
	rts
; ===========================================================================
level_select_cheat:
	; 17th September 1965, the birthdate of one of Sonic 2's developers,
	; Yuji Naka.
	dc.b $19, $65,   9, $17,   0
	rev02even
; byte_97B7
continues_cheat:
	; November 24th, which was Sonic 2's release date in the EU and US.
	dc.b   1,   1,   2,   4,   0
	rev02even
debug_cheat:
	; 24th November 1992 (also known as "Sonic 2sday"), which was
	; Sonic 2's release date in the EU and US.
	dc.b   1,   9,   9,   2,   1,   1,   2,   4,   0
	rev02even
; byte_97C5
super_sonic_cheat:
	; Book of Genesis, 41:26, which makes frequent reference to the
	; number 7. 7 happens to be the number of Chaos Emeralds.
	; The Mega Drive is known as the Genesis in the US.
	dc.b   4,   1,   2,   6,   0
	rev02even

	; set the character set for menu text
	charset '@',"\27\30\31\32\33\34\35\36\37\38\39\40\41\42\43\44\45\46\47\48\49\50\51\52\53\54\55"
	charset '0',"\16\17\18\19\20\21\22\23\24\25"
	charset '*',$1A
	charset ':',$1C
	charset '.',$1D
	charset ' ',0

	; options screen menu text

TextOptScr_PlayerSelect:	menutxt	"* PLAYER SELECT *"	; byte_97CA:
TextOptScr_SonicAndMiles:	menutxt	"SONIC AND MILES"	; byte_97DC:
TextOptScr_SonicAndTails:	menutxt	"SONIC AND TAILS"	; byte_97EC:
TextOptScr_SonicAlone:		menutxt	"SONIC ALONE    "	; byte_97FC:
TextOptScr_MilesAlone:		menutxt	"MILES ALONE    "	; byte_980C:
TextOptScr_TailsAlone:		menutxt	"TAILS ALONE    "	; byte_981C:
TextOptScr_VsModeItems:		menutxt	"* VS MODE ITEMS *"	; byte_982C:
TextOptScr_AllKindsItems:	menutxt	"ALL KINDS ITEMS"	; byte_983E:
TextOptScr_TeleportOnly:	menutxt	"TELEPORT ONLY  "	; byte_984E:
TextOptScr_SoundTest:		menutxt	"*  SOUND TEST   *"	; byte_985E:
TextOptScr_0:			menutxt	"      00       "	; byte_9870:

	charset ; reset character set

; level select picture palettes
; byte_9880:
Pal_LevelIcons:	BINCLUDE "art/palettes/Level Select Icons.bin"

; 2-player level select screen mappings (Enigma compressed)
; byte_9A60:
	even
MapEng_LevSel2P:	BINCLUDE "mappings/misc/Level Select 2P.eni"

; options screen mappings (Enigma compressed)
; byte_9AB2:
	even
MapEng_Options:	BINCLUDE "mappings/misc/Options Screen.eni"

; level select screen mappings (Enigma compressed)
; byte_9ADE:
	even
MapEng_LevSel:	BINCLUDE "mappings/misc/Level Select.eni"

; 1P and 2P level select icon mappings (Enigma compressed)
; byte_9C32:
	even
MapEng_LevSelIcon:	BINCLUDE "mappings/misc/Level Select Icons.eni"
	even

	jmpTos JmpTo_PlaySound,JmpTo_PlayMusic,JmpTo_PlaneMapToVRAM_H40,JmpTo2_Dynamic_Normal




; ===========================================================================
; loc_9C7C:
EndingSequence:
	clearRAM Object_RAM,Object_RAM_End
	clearRAM Misc_Variables,Misc_Variables_End
	clearRAM Camera_RAM,Camera_RAM_End

	move	#$2700,sr
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l

	stopZ80
	dmaFillVRAM 0,VRAM_Plane_A_Name_Table,VRAM_Plane_Table_Size ; clear Plane A pattern name table
	clr.l	(Vscroll_Factor).w
	clr.l	(unk_F61A).w
	startZ80

	lea	(VDP_control_port).l,a6
	move.w	#$8B03,(a6)		; EXT-INT disabled, V scroll by screen, H scroll by line
	move.w	#$8200|(VRAM_EndSeq_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_EndSeq_Plane_B_Name_Table1/$2000),(a6)	; PNT B base: $E000
	move.w	#$8500|(VRAM_Sprite_Attribute_Table/$200),(a6)		; Sprite attribute table base: $F800
	move.w	#$9001,(a6)		; Scroll table size: 64x32
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8720,(a6)		; Background palette/color: 2/0
	move.w	#$8ADF,(Hint_counter_reserve).w	; H-INT every 224th scanline
	move.w	(Hint_counter_reserve).w,(a6)
	clr.b	(Super_Sonic_flag).w
	cmpi.b	#7,(Emerald_count).w
	bne.s	+
	cmpi.w	#2,(Player_mode).w
	beq.s	+
	st.b	(Super_Sonic_flag).w
	move.b	#-1,(Super_Sonic_palette).w
	move.b	#$F,(Palette_timer).w
	move.w	#$30,(Palette_frame).w
+
	moveq	#0,d0
	cmpi.w	#2,(Player_mode).w
	beq.s	+
	tst.b	(Super_Sonic_flag).w
	bne.s	++
	bra.w	+++

; ===========================================================================
+
	addq.w	#2,d0
+
	addq.w	#2,d0
+
	move.w	d0,(Ending_Routine).w
	bsr.w	EndingSequence_LoadCharacterArt
	bsr.w	EndingSequence_LoadFlickyArt
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_EndingFinalTornado),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingFinalTornado).l,a0
	jsrto	JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_EndingPics),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingPics).l,a0
	jsrto	JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_EndingMiniTornado),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingMiniTornado).l,a0
	jsrto	JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Tornado),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Tornado).l,a0
	jsrto	JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Clouds),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Clouds).l,a0
	jsrto	JmpTo_NemDec
	move.w	#death_egg_zone_act_1,(Current_ZoneAndAct).w
	move	#$2300,sr
	moveq	#signextendB(MusID_Ending),d0
	jsrto	JmpTo2_PlayMusic
	move.l	#$EEE0EEE,d1
	lea	(Normal_palette).w,a1

	moveq	#bytesToLcnt(palette_line_size*4),d0
-	move.l	d1,(a1)+
	dbf	d0,-

	lea	(Pal_AC7E).l,a1
	lea	(Target_palette).w,a2

	moveq	#bytesToLcnt(palette_line_size*4),d0
-	move.l	(a1)+,(a2)+
	dbf	d0,-

	clr.b	(Screen_Shaking_Flag).w
	moveq	#0,d0
	move.w	d0,(Debug_placement_mode).w
	move.w	d0,(Level_Inactive_flag).w
	move.w	d0,(Level_frame_counter).w
	move.w	d0,(Camera_X_pos).w
	move.w	d0,(Camera_Y_pos).w
	move.w	d0,(Camera_X_pos_copy).w
	move.w	d0,(Camera_Y_pos_copy).w
	move.w	d0,(Camera_BG_X_pos).w
	move.w	#$C8,(Camera_BG_Y_pos).w
	move.l	d0,(Vscroll_Factor).w
	move.b	d0,(Horiz_block_crossed_flag_BG).w
	move.b	d0,(Verti_block_crossed_flag_BG).w
	move.w	d0,(Ending_VInt_Subrout).w
	move.w	d0,(Credits_Trigger).w

    if fixBugs
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len
    else
	; The '+4' shouldn't be here; clearRAM accidentally clears an additional 4 bytes
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len+4
    endif

	move.w	#$7FFF,(PalCycle_Timer).w
	lea	(CutScene).w,a1
	move.b	#ObjID_CutScene,id(a1) ; load objCA (end of game cutscene) at $FFFFB100
	move.b	#6,routine(a1)
	move.w	#$60,objoff_3C(a1)
	move.w	#1,objoff_30(a1)
	cmpi.w	#4,(Ending_Routine).w
	bne.s	+
	move.w	#$10,objoff_2E(a1)
	move.w	#$100,objoff_3C(a1)
+
	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
-
	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	addq.w	#1,(Level_frame_counter).w
	jsr	(RandomNumber).l
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	tst.b	(Ending_PalCycle_flag).w
	beq.s	+
	jsrto	JmpTo_PalCycle_Load
+
	bsr.w	EndgameCredits
	tst.w	(Level_Inactive_flag).w
	beq.w	-
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_9EF4
EndgameCredits:
	tst.b	(Credits_Trigger).w
	beq.w	.return
	bsr.w	Pal_FadeToBlack
	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8200|(VRAM_EndSeq_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_EndSeq_Plane_B_Name_Table1/$2000),(a6)	; PNT B base: $E000
	move.w	#$9001,(a6)		; Scroll table size: 64x32
	move.w	#$9200,(a6)		; Disable window
	move.w	#$8B03,(a6)		; EXT-INT disabled, V scroll by screen, H scroll by line
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	clr.b	(Water_fullscreen_flag).w
	move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled
	jsrto	JmpTo_ClearScreen

	clearRAM Object_Display_Lists,Object_Display_Lists_End
	clearRAM Object_RAM,Object_RAM_End
	clearRAM Misc_Variables,Misc_Variables_End
	clearRAM Camera_RAM,Camera_RAM_End

	clr.b	(Screen_Shaking_Flag).w
	moveq	#0,d0
	move.w	d0,(Level_Inactive_flag).w
	move.w	d0,(Level_frame_counter).w
	move.w	d0,(Camera_X_pos).w
	move.w	d0,(Camera_Y_pos).w
	move.w	d0,(Camera_X_pos_copy).w
	move.w	d0,(Camera_Y_pos_copy).w
	move.w	d0,(Camera_BG_X_pos).w
	move.w	d0,(Camera_BG_Y_pos).w
	move.l	d0,(Vscroll_Factor).w
	move.b	d0,(Horiz_block_crossed_flag_BG).w
	move.b	d0,(Verti_block_crossed_flag_BG).w
	move.w	d0,(Ending_VInt_Subrout).w
	move.w	d0,(Credits_Trigger).w

    if fixBugs
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len
    else
	; The '+4' shouldn't be here; clearRAM accidentally clears an additional 4 bytes
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len+4
    endif

	moveq	#signextendB(MusID_Credits),d0
	jsrto	JmpTo2_PlaySound
	clr.w	(Target_palette).w
	move.w	#$EEE,(Target_palette+$C).w
	move.w	#$EE,(Target_palette_line2+$C).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_CreditText_CredScr),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_CreditText).l,a0
	jsrto	JmpTo_NemDec
	clr.w	(CreditsScreenIndex).w
-
	jsrto	JmpTo_ClearScreen
	bsr.w	ShowCreditsScreen
	bsr.w	Pal_FadeFromBlack

	; Here's how to calculate new duration values for the below instructions.
	; Each slide of the credits is displayed for $18E frames at 60 FPS, or $144 frames at 50 FPS.
	; We also need to take into account how many frames the fade-in/fade-out take: which is $16 each.
	; Also, there are 21 slides to display.
	; That said, by doing '($18E+$16+$16)*21', we get the total number of frames it takes until
	; the credits reach the Sonic 2 splash (which is technically not an actual slide in the credits).
	; Dividing this by 60 will give us how many seconds it takes. The result being 154.7.
	; Doing the same for 50 FPS, by dividing the result of '($144+$16+$16)*21' by 50, will give us 154.56.
	; Now that we have the time it should take for the credits to end, we can adjust the calculation to account
	; for any slides we may have added. For example, if you added a slide, bringing the total to 22,
	; performing '((154.7*60)/22)-($16+$16)' will give you the new value to put in the 'move.w' instruction below.
	move.w	#$18E,d0
	btst	#6,(Graphics_Flags).w
	beq.s	+
	move.w	#$144,d0

/	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	dbf	d0,-

	bsr.w	Pal_FadeToBlack
	lea	(off_B2CA).l,a1
	addq.w	#1,(CreditsScreenIndex).w
	move.w	(CreditsScreenIndex).w,d0
	lsl.w	#2,d0
	move.l	(a1,d0.w),d0
	bpl.s	--
	bsr.w	Pal_FadeToBlack
	jsrto	JmpTo_ClearScreen
	move.l	#vdpComm($0000,VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingTitle).l,a0
	jsrto	JmpTo_NemDec
	lea	(MapEng_EndGameLogo).l,a0
	lea	(Chunk_Table).l,a1
	move.w	#0,d0
	jsrto	JmpTo_EniDec
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_A_Name_Table+planeLoc(64,12,11),VRAM,WRITE),d0
	moveq	#16-1,d1
	moveq	#6-1,d2
	jsrto	JmpTo2_PlaneMapToVRAM_H40
	clr.w	(CreditsScreenIndex).w
	bsr.w	EndgameLogoFlash

	move.w	#$3B,d0
-	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	dbf	d0,-

	move.w	#$257,d6
-	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	addq.w	#1,(CreditsScreenIndex).w
	bsr.w	EndgameLogoFlash
	cmpi.w	#$5E,(CreditsScreenIndex).w
	blo.s	-
	move.b	(Ctrl_1_Press).w,d1
	andi.b	#button_B_mask|button_C_mask|button_A_mask|button_start_mask,d1
	bne.s	+
	dbf	d6,-
+
	st.b	(Level_Inactive_flag).w
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen

.return:
	rts
; End of function EndgameCredits


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_A0C0
EndgameLogoFlash:
	lea	(Normal_palette+2).w,a2
	move.w	(CreditsScreenIndex).w,d0
	cmpi.w	#$24,d0
	bhs.s	EndgameCredits.return
	btst	#0,d0
	bne.s	EndgameCredits.return
	lsr.w	#1,d0
	move.b	byte_A0EC(pc,d0.w),d0
	mulu.w	#$18,d0
	lea	pal_A0FE(pc,d0.w),a1

	moveq	#5,d0
-	move.l	(a1)+,(a2)+
	dbf	d0,-

	rts
; End of function EndgameLogoFlash

; ===========================================================================
byte_A0EC:
	dc.b   0
	dc.b   1	; 1
	dc.b   2	; 2
	dc.b   3	; 3
	dc.b   4	; 4
	dc.b   3	; 5
	dc.b   2	; 6
	dc.b   1	; 7
	dc.b   0	; 8
	dc.b   5	; 9
	dc.b   6	; 10
	dc.b   7	; 11
	dc.b   8	; 12
	dc.b   7	; 13
	dc.b   6	; 14
	dc.b   5	; 15
	dc.b   0	; 16
	dc.b   0	; 17
	even

; palette cycle for the end-of-game logo
pal_A0FE:	BINCLUDE	"art/palettes/Ending Cycle.bin"

; ===========================================================================
	include "_incObj/CA Ending Cutscene.asm"
; ===========================================================================
	include "_incObj/CC Ending Tornado Trigger.asm"
; ===========================================================================
	include "_incObj/CE Ending Sonic and Tails.asm"
; ===========================================================================
	include "_incObj/CF Ending Tornado Propeller.asm"
; ===========================================================================
	include "_incObj/CB Ending Clouds.asm"
; ===========================================================================
	include "_incObj/CD Ending Birds.asm"

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_ABBA:
	subq.w	#1,objoff_30(a0)
	bpl.s	+	; rts
	tst.b	objoff_35(a0)
	beq.s	+	; rts
	subq.b	#1,objoff_35(a0)
	move.l	(RNG_seed).w,d0
	andi.w	#$F,d0
	move.w	d0,objoff_30(a0)
	lea	(ChildObject_AD66).l,a2
	jsrto	JmpTo_LoadChildObject
+	rts
; End of function sub_ABBA


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_ABE2:
EndingSequence_LoadCharacterArt:
	move.w	(Ending_Routine).w,d0
	move.w	EndingSequence_LoadCharacterArt_Characters(pc,d0.w),d0
	jmp	EndingSequence_LoadCharacterArt_Characters(pc,d0.w)
; End of function EndingSequence_LoadCharacterArt

; ===========================================================================
EndingSequence_LoadCharacterArt_Characters: offsetTable
	offsetTableEntry.w EndingSequence_LoadCharacterArt_Sonic	; 0
	offsetTableEntry.w EndingSequence_LoadCharacterArt_SuperSonic	; 2
	offsetTableEntry.w EndingSequence_LoadCharacterArt_Tails	; 4
; ===========================================================================
; loc_ABF4:
EndingSequence_LoadCharacterArt_Sonic:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_EndingCharacter),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingSonic).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
; loc_AC08:
EndingSequence_LoadCharacterArt_SuperSonic:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_EndingCharacter),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingSuperSonic).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
; loc_AC1C:
EndingSequence_LoadCharacterArt_Tails:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_EndingCharacter),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingTails).l,a0
	jmpto	JmpTo_NemDec

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_AC30:
EndingSequence_LoadFlickyArt:
	move.w	(Ending_Routine).w,d0
	move.w	EndingSequence_LoadFlickyArt_Flickies(pc,d0.w),d0
	jmp	EndingSequence_LoadFlickyArt_Flickies(pc,d0.w)
; End of function EndingSequence_LoadFlickyArt

; ===========================================================================
EndingSequence_LoadFlickyArt_Flickies: offsetTable
	offsetTableEntry.w EndingSequence_LoadFlickyArt_Flicky	; 0
	offsetTableEntry.w EndingSequence_LoadFlickyArt_Eagle	; 2
	offsetTableEntry.w EndingSequence_LoadFlickyArt_Chicken	; 4
; ===========================================================================
; loc_AC42:
EndingSequence_LoadFlickyArt_Flicky:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Animal_2),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Flicky).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
; loc_AC56:
EndingSequence_LoadFlickyArt_Eagle:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Animal_2),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Eagle).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
; loc_AC6A:
EndingSequence_LoadFlickyArt_Chicken:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Animal_2),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Chicken).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
Pal_AC7E:	BINCLUDE	"art/palettes/Ending Sonic.bin"
Pal_AC9E:	BINCLUDE	"art/palettes/Ending Tails.bin"
Pal_ACDE:	BINCLUDE	"art/palettes/Ending Background.bin"
Pal_AD1E:	BINCLUDE	"art/palettes/Ending Photos.bin"
Pal_AD3E:	BINCLUDE	"art/palettes/Ending Super Sonic.bin"

ChildObject_AD5E:	childObjectData objoff_3E, ObjID_EndingSeqClouds, $00
ChildObject_AD62:	childObjectData objoff_3E, ObjID_EndingSeqTrigger, $00
ChildObject_AD66:	childObjectData objoff_3E, ObjID_EndingSeqBird, $00
ChildObject_AD6A:	childObjectData objoff_3E, ObjID_EndingSeqSonic, $00
ChildObject_AD6E:	childObjectData objoff_3E, ObjID_TornadoHelixes, $00

; off_AD72:
ObjCD_SubObjData:
    if fixBugs
	subObjData Obj28_MapUnc_11E1C,make_art_tile(ArtTile_ArtNem_Animal_2,0,0),1<<render_flags.level_fg,1,8,0
    else
	; This should use priority 1, not 2. As-is, it causes the birds to
	; overlap the Tornado but appear behind Sonic.
	subObjData Obj28_MapUnc_11E1C,make_art_tile(ArtTile_ArtNem_Animal_2,0,0),1<<render_flags.level_fg,2,8,0
    endif

	include "_anim/Ending Birds.asm"
	include "_anim/Ending Propeller.asm"

; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjCF_MapUnc_ADA2:	include "mappings/sprite/objCF.asm"
; --------------------------------------------------------------------------------------
; Enigma compressed art mappings
; "Sonic the Hedgehog 2" mappings		; MapEng_B23A:
	even
MapEng_EndGameLogo:	BINCLUDE	"mappings/misc/Sonic 2 end of game logo.eni"
	even

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_B262
ShowCreditsScreen:
	lea	off_B2CA(pc),a1
	move.w	(CreditsScreenIndex).w,d0
	lsl.w	#2,d0
	move.l	(a1,d0.w),d0
	movea.l	d0,a1

loc_B272:
	move	#$2700,sr
	lea	(VDP_data_port).l,a6
-
	move.l	(a1)+,d0
	bmi.s	++
	movea.l	d0,a2
	move.w	(a1)+,d0
	bsr.s	sub_B29E
	move.l	d0,4(a6)
	move.b	(a2)+,d0
	lsl.w	#8,d0
-
	move.b	(a2)+,d0
	bmi.s	+
	move.w	d0,(a6)
	bra.s	-
; ===========================================================================
+	bra.s	--
; ===========================================================================
+
	move	#$2300,sr
	rts
; End of function ShowCreditsScreen


; ---------------------------------------------------------------------------
; Subroutine to convert a VRAM address into a 32-bit VRAM write command word
; Input:
;	d0	VRAM address (word)
; Output:
;	d0	32-bit VDP command word for a VRAM write to specified address.
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_B29E:
	andi.l	#$FFFF,d0
	lsl.l	#2,d0
	lsr.w	#2,d0
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d0
	swap	d0
	rts
; End of function sub_B29E

	include "_inc/Credits Text.asm"

; -------------------------------------------------------------------------------
; Nemesis compressed art
; 64 blocks
; Standard font used in credits
; -------------------------------------------------------------------------------
; ArtNem_BD26:
ArtNem_CreditText:	BINCLUDE	"art/nemesis/Credit Text.nem"
	even
; ===========================================================================

	jmpTos JmpTo5_DisplaySprite,JmpTo3_DeleteObject,JmpTo2_PlaySound,JmpTo_ObjB2_Animate_Pilot,JmpTo_AnimateSprite,JmpTo_NemDec,JmpTo_EniDec,JmpTo_ClearScreen,JmpTo2_PlayMusic,JmpTo_LoadChildObject,JmpTo2_PlaneMapToVRAM_H40,JmpTo2_ObjectMove,JmpTo_PalCycle_Load,JmpTo_LoadSubObject_Part3

	include "_inc/LevelSizeLoad.asm"

; ===========================================================================
; --------------------------------------------------------------------------------------
; CHARACTER START LOCATION ARRAY

; 2 entries per act, corresponding to the X and Y locations that you want the player to
; appear at when the level starts.
; --------------------------------------------------------------------------------------
StartLocations: zoneOrderedTable 2,4	; WrdArr_StartLoc
	; EHZ
	zoneTableBinEntry	2, "startpos/EHZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/EHZ_2.bin"	; Act 2
	; Zone 1
	zoneTableBinEntry	2, "startpos/01_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/01_2.bin"	; Act 2
	; WZ
	zoneTableBinEntry	2, "startpos/WZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/WZ_2.bin"	; Act 2
	; Zone 3
	zoneTableBinEntry	2, "startpos/03_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/03_2.bin"	; Act 2
	; MTZ
	zoneTableBinEntry	2, "startpos/MTZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/MTZ_2.bin"	; Act 2
	; MTZ
	zoneTableBinEntry	2, "startpos/MTZ_3.bin"	; Act 3
	zoneTableBinEntry	2, "startpos/MTZ_4.bin"	; Act 4
	; WFZ
	zoneTableBinEntry	2, "startpos/WFZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/WFZ_2.bin"	; Act 2
	; HTZ
	zoneTableBinEntry	2, "startpos/HTZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/HTZ_2.bin"	; Act 2
	; HPZ
	zoneTableBinEntry	2, "startpos/HPZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/HPZ_2.bin"	; Act 2
	; Zone 9
	zoneTableBinEntry	2, "startpos/09_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/09_2.bin"	; Act 2
	; OOZ
	zoneTableBinEntry	2, "startpos/OOZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/OOZ_2.bin"	; Act 2
	; MCZ
	zoneTableBinEntry	2, "startpos/MCZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/MCZ_2.bin"	; Act 2
	; CNZ
	zoneTableBinEntry	2, "startpos/CNZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/CNZ_2.bin"	; Act 2
	; CPZ
	zoneTableBinEntry	2, "startpos/CPZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/CPZ_2.bin"	; Act 2
	; DEZ
	zoneTableBinEntry	2, "startpos/DEZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/DEZ_2.bin"	; Act 2
	; ARZ
	zoneTableBinEntry	2, "startpos/ARZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/ARZ_2.bin"	; Act 2
	; SCZ
	zoneTableBinEntry	2, "startpos/SCZ_1.bin"	; Act 1
	zoneTableBinEntry	2, "startpos/SCZ_2.bin"	; Act 2
    zoneTableEnd

	include "_inc/Camera Init.asm"

	include "_inc/Software Scrolling Manager.asm" ; This needs to be broken up further
	include "_inc/Camera Scrolling.asm"

	include "_inc/Level Drawing.asm"

	include "_inc/LoadLevelLayout.asm" ; includes loadZoneBlockMaps

	include "_inc/DynamicLevelEvents.asm" ; Another big one
; ===========================================================================

; loc_F626:
PlayLevelMusic:
	move.w	(Level_Music).w,d0
	jmpto	JmpTo3_PlayMusic
; ===========================================================================

; loc_F62E:
LoadPLC_AnimalExplosion:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	lea	(Animal_PLCTable).l,a2
	move.b	(a2,d0.w),d0
	jsrto	JmpTo2_LoadPLC
	moveq	#PLCID_Explosion,d0
	jsrto	JmpTo2_LoadPLC
	rts
; ===========================================================================

	jmpTos JmpTo_AllocateObject,JmpTo3_PlaySound,JmpTo2_PalLoad_Now,JmpTo2_LoadPLC,JmpTo3_PlayMusic

; ===========================================================================
	include "_incObj/11 Bridge.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj11_MapUnc_FC28:	include "mappings/sprite/obj11_a.asm"

; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj11_MapUnc_FC70:	include "mappings/sprite/obj11_b.asm"

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

	jmpTos JmpTo_AllocateObjectAfterCurrent,JmpTo_PlatformObject11_cont,JmpTo_CalcSine

; ===========================================================================
	include "_incObj/15 ARZ Swinging Platform.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj15_MapUnc_101E8:			include "mappings/sprite/obj15_a.asm"
Obj15_Obj83_MapUnc_1021E:	include "mappings/sprite/obj83.asm"
	include "mappings/sprite/obj7A_b.asm"
	include "mappings/sprite/obj15_b.asm"

; ===========================================================================

	jmpTos JmpTo_PlatformObject2,JmpTo2_AllocateObjectAfterCurrent,JmpTo2_CalcSine,JmpTo_ObjCheckRightWallDist

; ===========================================================================
	include "_incObj/17 Spiked Pole Helix.asm"
; ===========================================================================
; -----------------------------------------------------------------------------
; sprite mappings - helix of spikes on a pole (GHZ) (unused)
; -----------------------------------------------------------------------------
Obj17_MapUnc_10452:	include "mappings/sprite/obj17.asm"
; ===========================================================================

	jmpTos ; Empty

	include "_incObj/18 Platforms.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj18_MapUnc_107F6:	include "mappings/sprite/obj18_a.asm"
Obj18_MapUnc_1084E:	include "mappings/sprite/obj18_b.asm"
; ===========================================================================

	jmpTos JmpTo3_CalcSine,JmpTo_PlatformObject,JmpTo_SolidObject

; ===========================================================================
	include "_incObj/1A & 1F Collapsing Floors.asm"
; -------------------------------------------------------------------------------
; unused sprite mappings (GHZ)
; -------------------------------------------------------------------------------
Obj1A_MapUnc_10C6C:	include "mappings/sprite/obj1A_a.asm"
; ----------------------------------------------------------------------------
; unused sprite mappings (MZ, SLZ, SBZ)
; ----------------------------------------------------------------------------
Obj1F_MapUnc_10F0C:	include "mappings/sprite/obj1F_a.asm"

; Slope data for platforms.
;byte_10FDC:
Obj1A_OOZ_SlopeData:
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
;byte_10FEC:
Obj1A_HPZ_SlopeData
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	even
; ----------------------------------------------------------------------------
; sprite mappings (HPZ)
; ----------------------------------------------------------------------------
Obj1A_MapUnc_1101C:	include "mappings/sprite/obj1A_b.asm"
; ----------------------------------------------------------------------------
; sprite mappings (OOZ)
; ----------------------------------------------------------------------------
Obj1F_MapUnc_110C6:	include "mappings/sprite/obj1F_b.asm"
; -------------------------------------------------------------------------------
; sprite mappings (MCZ)
; -------------------------------------------------------------------------------
Obj1F_MapUnc_11106:	include "mappings/sprite/obj1F_c.asm"
; -------------------------------------------------------------------------------
; sprite mappings (ARZ)
; -------------------------------------------------------------------------------
Obj1F_MapUnc_1115E:	include "mappings/sprite/obj1F_d.asm"
; ===========================================================================

	jmpTos JmpTo_SlopedPlatform,JmpTo2_PlatformObject

; ===========================================================================
	include "_incObj/1C Bridge Stake and Falling Oil.asm"
	include "_incObj/71 Bridge Stake and Pulsing Orb.asm"
; ===========================================================================
	include "_anim/HPZ Stake and Orb.asm"

; --------------------------------------------------------------------------------
; sprite mappings
; --------------------------------------------------------------------------------
Obj71_MapUnc_11396:	include "mappings/sprite/obj71_a.asm"
; ----------------------------------------------------------------------------------------
; Unknown sprite mappings
; ----------------------------------------------------------------------------------------
Obj1C_MapUnc_113D6:	include "mappings/sprite/obj1C_a.asm"
Obj1C_MapUnc_113EE:	include "mappings/sprite/obj1C_b.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj1C_MapUnc_11406:	include "mappings/sprite/obj1C_c.asm"
Obj1C_MapUnc_114AE:	include "mappings/sprite/obj1C_d.asm"
Obj1C_MapUnc_11552:	include "mappings/sprite/obj1C_e.asm"
Obj71_MapUnc_11576:	include "mappings/sprite/obj71_b.asm"
; ===========================================================================

	jmpTos ; Empty

	include "_incObj/2A MCZ Stomper.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj2A_MapUnc_11666:	include "mappings/sprite/obj2A.asm"
; ===========================================================================

	include "_incObj/2D CPZ One Way Barrier.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj2D_MapUnc_11822:	include "mappings/sprite/obj2D.asm"
; ===========================================================================

	jmpTos JmpTo2_SolidObject

; ===========================================================================

	include "_incObj/28 Animals.asm"
; ===========================================================================
	include "_incObj/29 Points.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj28_MapUnc_11E1C:	include "mappings/sprite/obj28_a.asm"
Obj28_MapUnc_11E40:	include "mappings/sprite/obj28_b.asm"
Obj28_MapUnc_11E64:	include "mappings/sprite/obj28_c.asm"
Obj28_MapUnc_11E88:	include "mappings/sprite/obj28_d.asm"
Obj28_MapUnc_11EAC:	include "mappings/sprite/obj28_e.asm"
Obj29_MapUnc_11ED0:	include "mappings/sprite/obj29.asm"

	jmpTos JmpTo_RandomNumber

; ===========================================================================
	include "_incObj/25 & 37 Rings.asm" ; also includes the dead code for Sonic 1's Big Rings
; ===========================================================================
	include "_anim/Rings.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj25_MapUnc_12382:	include "mappings/sprite/obj37_a.asm"
; -------------------------------------------------------------------------------
; Unused sprite mappings
; -------------------------------------------------------------------------------
Obj37_MapUnc_123E6:	include "mappings/sprite/obj37_b.asm"
Obj37_MapUnc_124E6:	include "mappings/sprite/obj37_c.asm"

; ===========================================================================
	include "_incObj/DC CNZ Ring Prize.asm"
; ===========================================================================

	jmpTos JmpTo4_CalcSine

; ===========================================================================
	include "_incObj/26 Monitor.asm"
; ===========================================================================
	include "_incObj/2E Monitor Contents.asm"
; ===========================================================================
	include "_anim/Monitors.asm"
; ---------------------------------------------------------------------------------
; Sprite Mappings - Sprite table for monitor and monitor contents (26, ??)
; ---------------------------------------------------------------------------------
; MapUnc_12D36: MapUnc_obj26:
Obj26_MapUnc_12D36:	include "mappings/sprite/obj26.asm"
; ===========================================================================

	jmpTos ; Empty

	include "_incObj/0E Title Screen Animations.asm"
; ===========================================================================
	include "_incObj/C9 Title Screen Palette Changing Handler.asm"

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


TitleScreen_SetFinalState:
	tst.b	obj0e_intro_complete(a0)
	bne.w	+	; rts

	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,(Ctrl_1_Press).w
	andi.b	#button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,(Ctrl_2_Press).w
	andi.b	#button_start_mask,d0
	beq.w	+	; rts

	; Initialise Sonic object.
	st.b	obj0e_intro_complete(a0)
	move.b	#$10,routine_secondary(a0)
	move.b	#$12,mapping_frame(a0)
	move.w	#spriteScreenPositionXCentered(-24),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-88),y_pixel(a0)

	; Initialise Sonic's hand object.
	lea	(IntroSonicHand).w,a1
	bsr.w	TitleScreen_InitSprite
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$A,routine(a1)
	move.b	#2,priority(a1)
	move.b	#9,mapping_frame(a1)
	move.b	#4,routine_secondary(a1)
	move.w	#spriteScreenPositionXCentered(33),x_pixel(a1)
	move.w	#spriteScreenPositionYCentered(-47),y_pixel(a1)

	; Initialise Tails object.
	lea	(IntroTails).w,a1
	bsr.w	TitleScreen_InitSprite
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#4,routine(a1)
	move.b	#4,mapping_frame(a1)
	move.b	#6,routine_secondary(a1)
	move.b	#3,priority(a1)
	move.w	#spriteScreenPositionXCentered(-88),x_pixel(a1)
	move.w	#spriteScreenPositionYCentered(-80),y_pixel(a1)

	; Initialise Tails' hand object.
	lea	(IntroTailsHand).w,a1
	bsr.w	TitleScreen_InitSprite
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#$10,routine(a1)
	move.b	#2,priority(a1)
	move.b	#$13,mapping_frame(a1)
	move.b	#4,routine_secondary(a1)
	move.w	#spriteScreenPositionXCentered(-19),x_pixel(a1)
	move.w	#spriteScreenPositionYCentered(-31),y_pixel(a1)

	; Initialise top-of-emblem object.
	lea	(IntroEmblemTop).w,a1
	move.b	#ObjID_TitleIntro,id(a1)
	move.b	#6,subtype(a1)

	; Initialise sprite mask object.
	bsr.w	Obj0E_LoadMaskingSprite

	; Initialise title screen menu object.
	move.b	#ObjID_TitleMenu,(TitleScreenMenu+id).w

	; Delete palette-changer object.
	lea	(TitleScreenPaletteChanger).w,a1
	bsr.w	DeleteObject2

	; Load palette line 4.
	lea_	Pal_1342C,a1
	lea	(Normal_palette_line4).w,a2
	moveq	#bytesToLcnt(palette_line_size),d6
-	move.l	(a1)+,(a2)+
	dbf	d6,-

	; Load palette line 3.
	lea_	Pal_1340C,a1
	lea	(Normal_palette_line3).w,a2
	moveq	#bytesToLcnt(palette_line_size),d6
-	move.l	(a1)+,(a2)+
	dbf	d6,-

	; Load palette line 1.
	lea_	Pal_133EC,a1
	lea	(Normal_palette).w,a2
	moveq	#bytesToLcnt(palette_line_size),d6
-	move.l	(a1)+,(a2)+
	dbf	d6,-

	; Play title screen music if it isn't already playing.
	tst.b	obj0e_music_playing(a0)
	bne.s	+
	moveq	#signextendB(MusID_Title),d0
	jsrto	JmpTo4_PlayMusic
+
	rts
; End of function TitleScreen_SetFinalState


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_135EA:
TitleScreen_InitSprite:
	move.l	#Obj0E_MapUnc_136A8,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_TitleSprites,0,0),art_tile(a1)
	move.b	#4,priority(a1)
	rts
; End of function TitleScreen_InitSprite

; ===========================================================================
	include "_incObj/0F Title Screen Menu.asm"
; ===========================================================================
	include "_anim/Title Screen.asm"
; -----------------------------------------------------------------------------
; Sprite Mappings - Flashing stars from intro (Obj0E)
; -----------------------------------------------------------------------------
Obj0E_MapUnc_136A8:	include "mappings/sprite/obj0E.asm"
; -----------------------------------------------------------------------------
; Sprite Mappings - Menu
; -----------------------------------------------------------------------------
Obj0F_MapUnc_13B70:	include "mappings/sprite/obj0F.asm"

	jmpTos0 JmpTo4_PlaySound,JmpTo4_PlayMusic

; ===========================================================================
	include "_incObj/34 Title Cards.asm"
; ===========================================================================
;byte_13F62:
Animal_PLCTable: zoneOrderedTable 1,1
	zoneTableEntry.b PLCID_EhzAnimals	; EHZ
	zoneTableEntry.b PLCID_EhzAnimals	; Zone 1
	zoneTableEntry.b PLCID_EhzAnimals	; WZ
	zoneTableEntry.b PLCID_EhzAnimals	; Zone 3
	zoneTableEntry.b PLCID_MtzAnimals	; MTZ1,2
	zoneTableEntry.b PLCID_MtzAnimals	; MTZ3
	zoneTableEntry.b PLCID_WfzAnimals	; WFZ
	zoneTableEntry.b PLCID_HtzAnimals	; HTZ
	zoneTableEntry.b PLCID_HpzAnimals	; HPZ
	zoneTableEntry.b PLCID_HpzAnimals	; Zone 9
	zoneTableEntry.b PLCID_OozAnimals	; OOZ
	zoneTableEntry.b PLCID_MczAnimals	; MCZ
	zoneTableEntry.b PLCID_CnzAnimals	; CNZ
	zoneTableEntry.b PLCID_CpzAnimals	; CPZ
	zoneTableEntry.b PLCID_DezAnimals	; DEZ
	zoneTableEntry.b PLCID_ArzAnimals	; ARZ
	zoneTableEntry.b PLCID_SczAnimals	; SCZ
    zoneTableEnd

	dc.b PLCID_SczAnimals	; level slot $11 (non-existent), not part of main table
	even

; ===========================================================================
	include "_incObj/39 Game Over.asm"
; ===========================================================================
	include "_incObj/3A Got Through Card.asm"
; ===========================================================================
	include "_inc/Level Order.asm"

results_screen_object macro startx, targetx, y, routine, frame
	dc.w	startx, targetx, spriteScreenPositionYCentered(y)
	dc.b	routine, frame
    endm

results_screen_object_size = 8

; byte_14380:
Obj3A_SubObjectMetadata:
	;                               start X,          target X, start Y, routine, map frame
	results_screen_object  spriteScreenPositionX(            0-96), spriteScreenPositionXCentered(  0),     -56,       2,         0
	results_screen_object  spriteScreenPositionX( screen_width+64), spriteScreenPositionXCentered(-32),     -38,       4,         3
	results_screen_object  spriteScreenPositionX(screen_width+128), spriteScreenPositionXCentered( 32),     -38,       6,         4
	results_screen_object  spriteScreenPositionX(screen_width+184), spriteScreenPositionXCentered( 88),     -50,       8,         6
	results_screen_object  spriteScreenPositionX(screen_width+400), spriteScreenPositionXCentered(  0),      48,       4,         9
	results_screen_object  spriteScreenPositionX(screen_width+352), spriteScreenPositionXCentered(  0),       0,       4,        $A
	results_screen_object  spriteScreenPositionX(screen_width+368), spriteScreenPositionXCentered(  0),      16,       4,        $B
	results_screen_object  spriteScreenPositionX(screen_width+384), spriteScreenPositionXCentered(  0),      32,     $16,        $E
Obj3A_SubObjectMetadata_End:
; ===========================================================================
	include "_incObj/6F Special Stage Results.asm"

	include "mappings/sprite/Title Cards.asm"

; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj39_MapUnc_14C6C:	include "mappings/sprite/obj39.asm"

	include "mappings/sprite/Got Through.asm"

; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj6F_MapUnc_14ED0:	include "mappings/sprite/obj6F.asm"
; ===========================================================================

;loc_15584: ; level title card drawing function called from Vint
DrawLevelTitleCard:
	lea	(VDP_data_port).l,a6
	tst.w	(TitleCard_ZoneName+titlecard_leaveflag).w
	bne.w	loc_15670
	moveq	#$3F,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6
	tst.w	(Two_player_mode).w
	beq.s	loc_155A8
	moveq	#$1F,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6

loc_155A8:
	lea	(TitleCard_Background+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)

loc_155AE:
	move.w	(a0)+,d0
	beq.s	loc_155C6
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d5,d4

loc_155C0:
	move.l	d6,(a6)
	dbf	d4,loc_155C0

loc_155C6:
	dbf	d7,loc_155AE
	moveq	#$26,d1
	sub.w	(TitleCard_Bottom+titlecard_split_point).w,d1
	lsr.w	#1,d1
	subq.w	#1,d1
	moveq	#7,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6
	tst.w	(Two_player_mode).w
	beq.s	loc_155EA
	moveq	#3,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6

loc_155EA:
	lea	(TitleCard_Bottom+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)

loc_155F0:
	move.w	(a0)+,d0
	beq.s	loc_15614
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	move.w	d5,d4

loc_155FE:
	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d1,d3

loc_15604:
	move.l	d6,(a6)
	dbf	d3,loc_15604
	addi.l	#vdpCommDelta(gameplay_plane_width/tile_width*2),d0
	dbf	d4,loc_155FE

loc_15614:
	dbf	d7,loc_155F0
	move.w	(TitleCard_Left+titlecard_split_point).w,d1 ; horizontal draw from left until this position
	subq.w	#1,d1
	moveq	#$D,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$58,0,0,0,1),d6 ; VRAM location of graphic to fill on left side
	tst.w	(Two_player_mode).w
	beq.s	loc_15634
	moveq	#6,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$58,0,0,0,1),d6 ; VRAM location of graphic to fill on left side (2p)

loc_15634:
	lea	(TitleCard_Left+titlecard_vram_dest).w,a0 ; obj34 red title card left side part
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)
	move.w	#$8F80,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0080

loc_15640:
	move.w	(a0)+,d0
	beq.s	loc_15664
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	move.w	d1,d4

loc_1564E:
	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d5,d3

loc_15654:
	move.l	d6,(a6)
	dbf	d3,loc_15654
	addi.l	#vdpCommDelta($0002),d0
	dbf	d4,loc_1564E

loc_15664:
	dbf	d7,loc_15640
	move.w	#$8F02,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0002
	rts
; ===========================================================================

loc_15670:
	moveq	#9,d3
	moveq	#3,d4
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6
	tst.w	(Two_player_mode).w
	beq.s	+
	moveq	#4,d3
	moveq	#1,d4
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6
+
	lea	(TitleCard_Left+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)
	move.w	#$8F80,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0080

loc_156A2:
	move.w	(a0)+,d0
	beq.s	loc_156CE
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	moveq	#3,d2

loc_156B0:
	move.l	d0,VDP_control_port-VDP_data_port(a6)

	move.w	d3,d1
-	move.l	d5,(a6)
	dbf	d1,-

	move.w	d4,d1
-	move.l	d6,(a6)
	dbf	d1,-

	addi.l	#vdpCommDelta($0002),d0
	dbf	d2,loc_156B0

loc_156CE:
	dbf	d7,loc_156A2
	move.w	#$8F02,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0002
	moveq	#7,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6
	tst.w	(Two_player_mode).w
	beq.s	+
	moveq	#3,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6
+
	lea	(TitleCard_Bottom+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)

loc_156F4:
	move.w	(a0)+,d0
	beq.s	loc_15714
	clr.w	-2(a0)
	jsr	sub_15792(pc)

	move.w	d5,d4
-	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.l	d6,(a6)
	move.l	d6,(a6)
	addi.l	#vdpCommDelta(gameplay_plane_width/tile_width*2),d0
	dbf	d4,-

loc_15714:
	dbf	d7,loc_156F4
	move.w	(TitleCard_Background+titlecard_vram_dest).w,d4
	beq.s	loc_1578C
	; Initialize plane A for both players; we have to do this here as otherwise
	; it will appear corrupted when the title card leaves.
	lea	VDP_control_port-VDP_data_port(a6),a5
	tst.w	(Two_player_mode).w
	beq.s	loc_15758
	lea	(Camera_X_pos_P2).w,a3
	lea	(Level_Layout).w,a4
	move.w	#vdpComm(VRAM_Plane_A_Name_Table_2P,VRAM,WRITE)>>16,d2

	moveq	#1,d6
-	movem.l	d4-d6,-(sp)
	moveq	#-$10,d5
	move.w	d4,d1
	bsr.w	CalculateVRAMAddressOfBlockForPlayer2
	move.w	d1,d4
	moveq	#-$10,d5
	moveq	#$1F,d6
	bsr.w	DrawBlockRow_CustomWidth
	movem.l	(sp)+,d4-d6
	addi.w	#$10,d4
	dbf	d6,-

loc_15758:
	lea	(Camera_X_pos).w,a3
	lea	(Level_Layout).w,a4
	move.w	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE)>>16,d2
	move.w	(TitleCard_Background+titlecard_vram_dest).w,d4

	moveq	#2-1,d6 ; Do two rows
-	movem.l	d4-d6,-(sp)
	moveq	#-16,d5
	move.w	d4,d1
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	d1,d4
	moveq	#-16,d5
	moveq	#64/2-1,d6
	bsr.w	DrawBlockRow_CustomWidth
	movem.l	(sp)+,d4-d6
	addi.w	#16,d4
	dbf	d6,-

loc_1578C:
	clr.w	(TitleCard_Background+titlecard_vram_dest).w
	rts
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to convert a VRAM address into a 32-bit VRAM write command word
; Input:
;	d0	VRAM address (word)
; Output:
;	d0	32-bit VDP command word for a VRAM write to specified address.
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_15792:
	andi.l	#$FFFF,d0
	lsl.l	#2,d0
	lsr.w	#2,d0
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d0
	swap	d0
	rts
; End of function sub_15792

; ===========================================================================

;loc_157A4
LoadTitleCardSS:
	movem.l	d0/a0,-(sp)
	bsr.s	LoadTitleCard0
	movem.l	(sp)+,d0/a0
	bra.s	loc_157EC

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_157B0:
LoadTitleCard0:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_TitleCard),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_TitleCard).l,a0
	jsrto	JmpTo2_NemDec
	lea	(Level_Layout).w,a4
	lea	(ArtNem_TitleCard2).l,a0
	jmpto	JmpTo_NemDecToRAM
; ===========================================================================
; loc_157D2:
LoadTitleCard:
	bsr.s	LoadTitleCard0
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	move.b	Off_TitleCardLetters(pc,d0.w),d0
	lea	TitleCardLetters(pc),a0
	lea	(a0,d0.w),a0
	move.l	#vdpComm(tiles_to_bytes(ArtTile_LevelName),VRAM,WRITE),d0

loc_157EC:
	move	#$2700,sr
	lea	(Level_Layout).w,a1
	lea	(VDP_data_port).l,a6
	move.l	d0,4(a6)

loc_157FE:
	moveq	#0,d0
	move.b	(a0)+,d0
	bmi.s	loc_1581A
	lsl.w	#5,d0
	lea	(a1,d0.w),a2
	moveq	#0,d1
	move.b	(a0)+,d1
	lsl.w	#3,d1
	subq.w	#1,d1

loc_15812:
	move.l	(a2)+,(a6)
	dbf	d1,loc_15812
	bra.s	loc_157FE
; ===========================================================================

loc_1581A:
	move	#$2300,sr
	rts
; ===========================================================================
; byte_15820:
Off_TitleCardLetters: zoneOrderedTable 1,1
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; EHZ
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; Zone 1
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; WZ
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; Zone 3
	zoneTableEntry.b TitleCardLetters_MTZ - TitleCardLetters	; MTZ1,2
	zoneTableEntry.b TitleCardLetters_MTZ - TitleCardLetters	; MTZ3
	zoneTableEntry.b TitleCardLetters_WFZ - TitleCardLetters	; WFZ
	zoneTableEntry.b TitleCardLetters_HTZ - TitleCardLetters	; HTZ
	zoneTableEntry.b TitleCardLetters_HPZ - TitleCardLetters	; HPZ
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; Zone 9
	zoneTableEntry.b TitleCardLetters_OOZ - TitleCardLetters	; OOZ
	zoneTableEntry.b TitleCardLetters_MCZ - TitleCardLetters	; MCZ
	zoneTableEntry.b TitleCardLetters_CNZ - TitleCardLetters	; CNZ
	zoneTableEntry.b TitleCardLetters_CPZ - TitleCardLetters	; CPZ
	zoneTableEntry.b TitleCardLetters_DEZ - TitleCardLetters	; DEZ
	zoneTableEntry.b TitleCardLetters_ARZ - TitleCardLetters	; ARZ
	zoneTableEntry.b TitleCardLetters_SCZ - TitleCardLetters	; SCZ
    zoneTableEnd
	even

 ; temporarily remap characters to title card letter format
 ; Characters are encoded as Aa, Bb, Cc, etc. through a macro
 charset 'A',0	; can't have an embedded 0 in a string
 charset 'B',"\4\8\xC\4\x10\x14\x18\x1C\x1E\x22\x26\x2A\4\4\x30\x34\x38\x3C\x40\x44\x48\x4C\x52\x56\4"
 charset 'a',"\4\4\4\4\4\4\4\4\2\4\4\4\6\4\4\4\4\4\4\4\4\4\6\4\4"
 charset '.',"\x5A"

; Defines which letters load for the continue screen
; Each letter occurs only once, and the letters ENOZ (i.e. ZONE) aren't loaded here
; However, this is hidden by the titleLetters macro, and normal titles can be used
; (the macro is defined near SpecialStage_ResultsLetters, which uses it before here)
; The actual mappings for zone title cards are found at MapUnc_TitleCards

; word_15832:
TitleCardLetters:

TitleCardLetters_EHZ:
	titleLetters	"EMERALD HILL"
TitleCardLetters_MTZ:
	titleLetters	"METROPOLIS"
TitleCardLetters_HTZ:
	titleLetters	"HILL TOP"
TitleCardLetters_HPZ:
	titleLetters	"HIDDEN PALACE"
TitleCardLetters_OOZ:
	titleLetters	"OIL OCEAN"
TitleCardLetters_MCZ:
	titleLetters	"MYSTIC CAVE"
TitleCardLetters_CNZ:
	titleLetters	"CASINO NIGHT"
TitleCardLetters_CPZ:
	titleLetters	"CHEMICAL PLANT"
TitleCardLetters_ARZ:
	titleLetters	"AQUATIC RUIN"
TitleCardLetters_SCZ:
	titleLetters	"SKY CHASE"
TitleCardLetters_WFZ:
	titleLetters	"WING FORTRESS"
TitleCardLetters_DEZ:
	titleLetters	"DEATH EGG"

 charset ; revert character set

; ===========================================================================

	jmpTos JmpTo2_NemDec,JmpTo_NemDecToRAM,JmpTo3_LoadPLC,JmpTo_sub_8476

; ===========================================================================
	include "_incObj/36 Spikes.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj36_MapUnc_15B68:	include "mappings/sprite/obj36.asm"

	jmpTos ; Empty

; ===========================================================================
	include "_incObj/3B Purple Rock.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; Unused sprite mappings
; -------------------------------------------------------------------------------
Obj3B_MapUnc_15D2E:	include "mappings/sprite/obj3B.asm"

	jmpTos0 ; Empty

; ===========================================================================
	include "_incObj/3C Smashable Wall.asm"
; -------------------------------------------------------------------------------
; Unused sprite mappings
; -------------------------------------------------------------------------------
Obj3C_MapUnc_15ECC:	include "mappings/sprite/obj3C.asm"
; ===========================================================================
	bra.w	ObjNull

	include "_incObj/sub RunObjects.asm"
; ===========================================================================
	include "_inc/Object Pointers.asm" ; also includes the null object

	include "_incObj/sub ObjectMove.asm" ; also ObjectMoveAndFall
	include "_incObj/sub DeleteObject.asm" ; also MarkObjGone
	include "_incObj/sub DisplaySprite.asm"
	include "_incObj/sub AnimateSprite.asm"

	include "_inc/BuildSprites.asm" ; also DrawSprites and the 2P versions
; ===========================================================================

	jmpTos JmpTo_BuildHUD,JmpTo_BuildHUD_P1,JmpTo_BuildHUD_P2

; ===========================================================================
	include "_inc/Rings Manager.asm"
; ===========================================================================
	include "mappings/sprite/Rings.asm"

	include "_inc/CNZ Bumpers.asm"
; ===========================================================================
SpecialCNZBumpers_Act1:
    if fixBugs
	; Sonic Team forgot to start this file with a boundary marker,
	; meaning the game could potentially read past the start of the file
	; and load random bumpers. In a stroke of luck, the above `jmp`
	; instruction happens to resemble a boundary marker well enough to
	; prevent any misbehaviour. However, this is not the case in
	; 'Knuckles in Sonic 2' due to the code being located at a
	; wildly-different address, which necessitated that this bug be fixed
	; properly, like this.
	dc.w	$0000, $0000, $0000
    endif
	BINCLUDE	"level/objects/CNZ 1 bumpers.bin"	; byte_1781A

SpecialCNZBumpers_Act2:
	BINCLUDE	"level/objects/CNZ 2 bumpers.bin"	; byte_1795E
; ===========================================================================

	jmpTos ; Empty

; ===========================================================================
	include "_inc/Objects Manager.asm"

;---------------------------------------------------------------------------------------
; CNZ object layouts for 2-player mode (various objects were deleted)
;---------------------------------------------------------------------------------------

; Macro for marking the boundaries of an object layout file
ObjectLayoutBoundary macro
	dc.w	$FFFF, $0000, $0000
    endm

    if fixBugs
	; Sonic Team forgot to put a boundary marker here, meaning the game
	; could potentially read past the start of the file and load random
	; objects.
	ObjectLayoutBoundary
    endif

; byte_1802A;
    if gameRevision=0
Objects_CNZ1_2P:	BINCLUDE	"level/objects/CNZ_1_2P (REV00).bin"
    else
    ; a Crawl badnik was moved slightly further away from a ledge
    ; 2 flippers were moved closer to a wall
Objects_CNZ1_2P:	BINCLUDE	"level/objects/CNZ_1_2P.bin"
    endif

	ObjectLayoutBoundary

; byte_18492:
    if gameRevision=0
Objects_CNZ2_2P:	BINCLUDE	"level/objects/CNZ_2_2P (REV00).bin"
    else
    ; 4 Crawl badniks were slightly moved, placing them closer/farther away from ledges
    ; 2 flippers were moved away from a wall to keep players from getting stuck behind them
Objects_CNZ2_2P:	BINCLUDE	"level/objects/CNZ_2_2P.bin"
    endif

	ObjectLayoutBoundary

	jmpTos ; Empty

; ===========================================================================
	include "_incObj/41 Springs.asm"
	include "_anim/Springs.asm"
	include "mappings/sprite/Springs.asm"
; ===========================================================================

	jmpTos ; Empty

	include "_incObj/0D Signpost.asm"
; ===========================================================================
	include "_anim/Signpost.asm"
; -------------------------------------------------------------------------------
; sprite mappings - Primary sprite table for object 0D (signpost)
; -------------------------------------------------------------------------------
; SprTbl_0D_Primary:
Obj0D_MapUnc_195BE:	include "mappings/sprite/obj0D_a.asm"
; -------------------------------------------------------------------------------
; sprite mappings - Secondary sprite table for object 0D (signpost)
; -------------------------------------------------------------------------------
; SprTbl_0D_Scndary:
Obj0D_MapUnc_19656:	include "mappings/sprite/obj0D_b.asm"
; -------------------------------------------------------------------------------
; dynamic pattern loading cues
; -------------------------------------------------------------------------------
Obj0D_MapRUnc_196EE:	include "mappings/spriteDPLC/obj0D.asm"
; ===========================================================================

	jmpTos ; Empty

	include "_incObj/sub SolidObject.asm" ; also SlopedSolid
; ===========================================================================
	include "_incObj/sub MvSonicOnPtfm.asm" ; also MvSonicOnSlope
; ===========================================================================
	include "_incObj/sub PlatformObject.asm" ; also SlopedPlatform
; ===========================================================================
	include "_incObj/01 Sonic.asm" ; Needs to be broken up further!
; ===========================================================================
	include "_anim/Sonic.asm"
	include "_incObj/sub LoadSonicDynPLC.asm"
; ===========================================================================

	jmpTos0 JmpTo_KillCharacter

; ===========================================================================
	include "_incObj/02 Tails.asm" ; Needs to be broken up further!
; ===========================================================================
	include "_anim/Tails.asm"
	include "_incObj/sub LoadTailsDynPLC.asm" ; also LoadTailsTailsDynPLC
; ===========================================================================
	include "_incObj/05 Tails' Tails.asm"
	include "_anim/Tails' Tails.asm"
; ===========================================================================

	jmpTos JmpTo2_KillCharacter

; ===========================================================================
	include "_incObj/0A Bubbles & Drowning Countdown.asm"
; ===========================================================================
	include "_incObj/sub ResumeMusic.asm"
; ===========================================================================
	include "_anim/Bubbles.asm"
; ===========================================================================
	include "_incObj/38 Shield.asm"
; ===========================================================================

JmpTo7_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
; ===========================================================================
	include "_incObj/35 Invincibility Stars.asm"
; ===========================================================================
byte_1DB42:
Ani_obj35:	include "_anim/Invincibility Stars.asm"
	include "_anim/Shield.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj38_MapUnc_1DBE4:	include "mappings/sprite/obj38.asm"
Obj35_MapUnc_1DCBC:	include "mappings/sprite/obj35.asm"

; ===========================================================================
	include "_incObj/08 Splash & Dust.asm"
; ===========================================================================
	include "_anim/Splash & Dust.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj08_MapUnc_1DF5E:	include "mappings/sprite/obj08.asm"
; -------------------------------------------------------------------------------
; dynamic pattern loading cues
; -------------------------------------------------------------------------------
Obj08_MapRUnc_1E074:	include "mappings/spriteDPLC/obj08.asm"
; ===========================================================================
	include "_incObj/7E Super Sonic's Stars.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj7E_MapUnc_1E1BE:	include "mappings/sprite/obj7E.asm"
; ===========================================================================

	jmpTos ; Empty

	include "_incObj/Sonic AnglePos.asm"
; ===========================================================================
	include "_incObj/sub FindTile.asm" ; also FindFloor and FindWall
	include "_incObj/sub ConvertCollisionArray.asm"

	jmpTos ; Empty

	include "_incObj/sub CalcRoom.asm" ; InFront and OverHead
	include "_incObj/sub CheckFloor.asm" ; also Walls and Ceilings
; ===========================================================================
	include "_incObj/79 Starpost.asm"
; ===========================================================================
	include "_anim/Starpost.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj79_MapUnc_1F424:	include "mappings/sprite/obj79_a.asm"
Obj79_MapUnc_1F4A0:	include "mappings/sprite/obj79_b.asm"
; ===========================================================================
	include "_incObj/79 Starpost (Part 2).asm" ; Stars for Special Stage entrance
; ===========================================================================

	jmpTos JmpTo_MarkObjGone,JmpTo2_AnimateSprite,JmpTo3_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/7D Hidden Bonuses.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; Unused sprite mappings
; -------------------------------------------------------------------------------
Obj7D_MapUnc_1F6FE:	include "mappings/sprite/obj7D.asm"
; ===========================================================================

	jmpTos JmpTo4_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/44 Bumper.asm"
; ===========================================================================
	include "_anim/Bumper.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj44_MapUnc_1F85A:	include "mappings/sprite/obj44.asm"
; ===========================================================================

	jmpTos JmpTo2_MarkObjGone,JmpTo3_AnimateSprite,JmpTo5_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/24 ARZ Bubbles.asm"
; ===========================================================================
	include "_anim/ARZ Bubbles.asm"
	include "mappings/sprite/ARZ Bubbles.asm"
; ===========================================================================

	jmpTos JmpTo7_DisplaySprite,JmpTo15_DeleteObject,JmpTo6_Adjust2PArtPointer,JmpTo3_ObjectMove

; ===========================================================================
	include "_incObj/03 Collision Switcher.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj03_MapUnc_1FFB8:	include "mappings/sprite/obj03.asm"
; ===========================================================================

	jmpTos JmpTo7_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/0B CPZ Pipe.asm"
; ===========================================================================
	include "_anim/CPZ Pipe.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj0B_MapUnc_201A0:	include "mappings/sprite/obj0B.asm"
; ===========================================================================

	jmpTos JmpTo3_MarkObjGone,JmpTo8_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/0C Small Floating Platform.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Unused sprite mappings
; ----------------------------------------------------------------------------
Obj0C_MapUnc_202FA:	include "mappings/sprite/obj0C.asm"
; ===========================================================================

	jmpTos JmpTo4_MarkObjGone,JmpTo9_Adjust2PArtPointer,JmpTo5_CalcSine

; ===========================================================================
	include "_incObj/12 HPZ Emerald.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings (unused)
; -------------------------------------------------------------------------------
Obj12_MapUnc_20382:	include "mappings/sprite/obj12.asm"
; ===========================================================================

	jmpTos JmpTo8_DisplaySprite,JmpTo16_DeleteObject,JmpTo10_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/13 HPZ Waterfall.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings (unused)
; -------------------------------------------------------------------------------
Obj13_MapUnc_20528:	include "mappings/sprite/obj13.asm"
; ===========================================================================

	jmpTos JmpTo9_DisplaySprite,JmpTo17_DeleteObject,JmpTo2_Adjust2PArtPointer2,JmpTo11_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/04 Water Surface.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj04_MapUnc_20A0E:	include "mappings/sprite/obj04_a.asm"
Obj04_MapUnc_20AFE:	include "mappings/sprite/obj04_b.asm"
; ===========================================================================
	include "_incObj/49 EHZ Waterfall.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj49_MapUnc_20C50:	include "mappings/sprite/obj49.asm"
; ===========================================================================
	include "_incObj/31 Lava Collision Maker.asm"
; ===========================================================================
    if ~~fixBugs
; -------------------------------------------------------------------------------
; sprite non-mappings
; -------------------------------------------------------------------------------
Obj31_MapUnc_20E6C:	include "mappings/sprite/obj31_a.asm"
    endif
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj31_MapUnc_20E74:	include "mappings/sprite/obj31_b.asm"
; ===========================================================================
	include "_incObj/74 Invisible Solid Block.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj74_MapUnc_20F66:	include "mappings/sprite/obj74.asm"
; ===========================================================================
	include "_incObj/7C Pylon.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj7C_MapUnc_2103C:	include "mappings/sprite/obj7C.asm"
; ===========================================================================
	include "_incObj/27 Explosion.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj27_MapUnc_21120:	include "mappings/sprite/obj27.asm"
; ===========================================================================
	include "_incObj/84 Pinball Mode Trigger.asm"
	include "_incObj/8B WFZ Cycling Palette Switcher.asm"
; ===========================================================================

	jmpTos JmpTo10_DisplaySprite,JmpTo18_DeleteObject,JmpTo2_AllocateObject,JmpTo12_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/06 Corkscrew.asm" ; EHZ spiral path and MTZ rotating cylinder
; ===========================================================================

	jmpTos JmpTo6_CalcSine

; ===========================================================================
	include "_incObj/14 Seesaw.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj14_MapUnc_21CF0:	include "mappings/sprite/obj14_a.asm"
Obj14_MapUnc_21D7C:	include "mappings/sprite/obj14_b.asm"
; ===========================================================================

	jmpTos JmpTo3_AllocateObjectAfterCurrent,JmpTo13_Adjust2PArtPointer,JmpTo_ObjectMoveAndFall,JmpTo_MarkObjGone2

; ===========================================================================
	include "_incObj/16 HTZ Diagonal Lift.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj16_MapUnc_21F14:	include "mappings/sprite/obj16.asm"
; ===========================================================================

	jmpTos JmpTo5_MarkObjGone,JmpTo4_AllocateObjectAfterCurrent,JmpTo14_Adjust2PArtPointer,JmpTo3_PlatformObject,JmpTo4_ObjectMove

; ===========================================================================
	include "_incObj/19 Moving Platforms.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj19_MapUnc_2222A:	include "mappings/sprite/obj19.asm"
; ===========================================================================

	jmpTos JmpTo11_DisplaySprite,JmpTo20_DeleteObject,JmpTo15_Adjust2PArtPointer,JmpTo4_PlatformObject,JmpTo5_ObjectMove

; ===========================================================================
	include "_incObj/1B CPZ Speed Booster.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj1B_MapUnc_223E2:	include "mappings/sprite/obj1B.asm"
; ===========================================================================

	jmpTos JmpTo6_MarkObjGone,JmpTo16_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/1D CPZ Blue Balls.asm"
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj1D_MapUnc_22576:	include "mappings/sprite/obj1D.asm"
; ===========================================================================

	jmpTos JmpTo7_MarkObjGone,JmpTo5_AllocateObjectAfterCurrent,JmpTo3_Adjust2PArtPointer2,JmpTo6_ObjectMove

; ===========================================================================
	include "_incObj/1E CPZ Spin Tube.asm"
; ===========================================================================
obj1E67Size macro {INTLABEL}
__LABEL__ label *
	dc.w __LABEL___End-__LABEL__-2
	endm
; -------------------------------------------------------------------------------
; spin tube data - entry/exit
; -------------------------------------------------------------------------------
; off_22980:
	include	"misc/obj1E_a.asm"
; -------------------------------------------------------------------------------
; spin tube data - main tube
; -------------------------------------------------------------------------------
; off_22E88:
	include	"misc/obj1E_b.asm"
; ===========================================================================

	jmpTos JmpTo_MarkObjGone3

; ===========================================================================
	include "_incObj/20 HTZ Boss Lava Bubble.asm"
; ===========================================================================
	include "_anim/HTZ Boss Lava Bubble.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj20_MapUnc_23254:	include "mappings/sprite/obj20_a.asm"
Obj20_MapUnc_23294:	include "mappings/sprite/obj20_b.asm"
; ===========================================================================

	jmpTos JmpTo21_DeleteObject,JmpTo8_MarkObjGone,JmpTo6_AllocateObjectAfterCurrent,JmpTo4_AnimateSprite,JmpTo17_Adjust2PArtPointer,JmpTo7_ObjectMove

; ===========================================================================
	include "_incObj/2F & 32 Smashable Ground & Blocks.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj2F_MapUnc_236FA:	include "mappings/sprite/obj2F.asm"
Obj32_MapUnc_23852:	include "mappings/sprite/obj32_a.asm"
Obj32_MapUnc_23886:	include "mappings/sprite/obj32_b.asm"
; ===========================================================================

	jmpTos JmpTo12_DisplaySprite,JmpTo22_DeleteObject,JmpTo3_AllocateObject,JmpTo9_MarkObjGone,JmpTo18_Adjust2PArtPointer,JmpTo_BreakObjectToPieces,JmpTo3_SolidObject,JmpTo8_ObjectMove

; ===========================================================================
	include "_incObj/30 HTZ Quake Lava.asm"
; ===========================================================================

	jmpTos JmpTo23_DeleteObject,JmpTo_Touch_ChkHurt,JmpTo2_MarkObjGone3,JmpTo_DropOnFloor,JmpTo_SolidObject_Always,JmpTo_SlopedSolid

; ===========================================================================
	include "_incObj/33 OOZ Green Platform.asm"
; ===========================================================================
	include "_anim/OOZ Green Platform.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj33_MapUnc_23DDC:	include "mappings/sprite/obj33_a.asm"
Obj33_MapUnc_23DF0:	include "mappings/sprite/obj33_b.asm"
; ===========================================================================

	jmpTos JmpTo10_MarkObjGone,JmpTo7_AllocateObjectAfterCurrent,JmpTo4_SolidObject

; ===========================================================================
	include "_incObj/43 OOZ Sliding Spikes.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj43_MapUnc_23FE0:	include "mappings/sprite/obj43.asm"
; ===========================================================================

	jmpTos JmpTo8_AllocateObjectAfterCurrent,JmpTo19_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/07 Oil Ocean.asm"
; ===========================================================================

	jmpTos JmpTo3_KillCharacter,JmpTo_PlatformObject_SingleCharacter

; ===========================================================================
	include "_incObj/45 OOZ Pressure Spring.asm"
; ===========================================================================
	include "_anim/OOZ Pressure Spring.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj45_MapUnc_2451A:	include "mappings/sprite/obj45.asm"
; ===========================================================================
	include "_incObj/46 OOZ Ball.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Unused sprite mappings
; ----------------------------------------------------------------------------
Obj46_MapUnc_24C52:	include "mappings/sprite/obj46.asm"
; ===========================================================================

	; some of these are still used, for some reason:
	jmpTos JmpTo25_DeleteObject,JmpTo4_AllocateObject,JmpTo11_MarkObjGone,JmpTo20_Adjust2PArtPointer,JmpTo5_SolidObject,JmpTo_SolidObject_Always_SingleCharacter,JmpTo_SolidObject45,JmpTo9_ObjectMove

; ===========================================================================
	include "_incObj/47 Button.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj47_MapUnc_24D96:	include "mappings/sprite/obj47.asm"
; ===========================================================================

	jmpTos JmpTo12_MarkObjGone,JmpTo21_Adjust2PArtPointer,JmpTo6_SolidObject

; ===========================================================================
	include "_incObj/3D OOZ Smashable Launcher Cap.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj3D_MapUnc_250BA:	include "mappings/sprite/obj3D.asm"
; ===========================================================================

	jmpTos JmpTo14_DisplaySprite,JmpTo26_DeleteObject,JmpTo13_MarkObjGone,JmpTo9_AllocateObjectAfterCurrent,JmpTo3_MarkObjGone3,JmpTo22_Adjust2PArtPointer,JmpTo2_BreakObjectToPieces,JmpTo7_SolidObject,JmpTo10_ObjectMove

; ===========================================================================
	include "_incObj/48 OOZ Cannon.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj48_MapUnc_254FE:	include "mappings/sprite/obj48.asm"
; ===========================================================================

	jmpTos JmpTo15_DisplaySprite,JmpTo14_MarkObjGone,JmpTo23_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/22 ARZ Arrow Shooter.asm"
; ===========================================================================
	include "_anim/ARZ Arrow Shooter.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj22_MapUnc_25804:	include "mappings/sprite/obj22.asm"
; ===========================================================================

	jmpTos JmpTo27_DeleteObject,JmpTo5_AllocateObject,JmpTo15_MarkObjGone,JmpTo5_AnimateSprite,JmpTo24_Adjust2PArtPointer,JmpTo11_ObjectMove

; ===========================================================================
	include "_incObj/23 ARZ Falling Pillar.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj23_MapUnc_259E6:	include "mappings/sprite/obj23.asm"
; ===========================================================================
	include "_incObj/2B ARZ Rising Pillar.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj2B_MapUnc_25C6E:	include "mappings/sprite/obj2B.asm"
; ===========================================================================

	jmpTos JmpTo16_DisplaySprite,JmpTo28_DeleteObject,JmpTo16_MarkObjGone,JmpTo10_AllocateObjectAfterCurrent,JmpTo25_Adjust2PArtPointer,JmpTo8_SolidObject,JmpTo12_ObjectMove

; ===========================================================================
	include "_incObj/2C ARZ Leaf Spawner.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj2C_MapUnc_2631E:	include "mappings/sprite/obj2C.asm"
; ===========================================================================

	jmpTos JmpTo17_DisplaySprite,JmpTo29_DeleteObject,JmpTo6_AllocateObject,JmpTo2_RandomNumber,JmpTo7_CalcSine

; ===========================================================================
	include "_incObj/40 Springboard.asm"
	include "_anim/Springboard.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj40_MapUnc_265F4:	include "mappings/sprite/obj40.asm"
; ===========================================================================

	jmpTos JmpTo17_MarkObjGone,JmpTo6_AnimateSprite,JmpTo26_Adjust2PArtPointer,JmpTo_SlopedSolid_SingleCharacter

; ===========================================================================
	include "_incObj/42 MTZ Steam Spring.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj42_MapUnc_2686C:	include "mappings/sprite/obj42.asm"
; ===========================================================================

	jmpTos JmpTo18_DisplaySprite,JmpTo30_DeleteObject,JmpTo7_AllocateObject,JmpTo18_MarkObjGone,JmpTo27_Adjust2PArtPointer,JmpTo2_SolidObject_Always_SingleCharacter

; ===========================================================================
	include "_incObj/64 MTZ Twin Crusher.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj64_MapUnc_26A5C:	include "mappings/sprite/obj64.asm"
; ===========================================================================

	jmpTos JmpTo28_Adjust2PArtPointer,JmpTo9_SolidObject

; ===========================================================================
	include "_incObj/65 MTZ Long Moving Platform.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj65_Obj6A_Obj6B_MapUnc_26EC8:	include "mappings/sprite/obj65_a.asm"
Obj65_MapUnc_26F04:	include "mappings/sprite/obj65_b.asm"
; ===========================================================================

	jmpTos JmpTo19_MarkObjGone,JmpTo11_AllocateObjectAfterCurrent,JmpTo29_Adjust2PArtPointer,JmpTo10_SolidObject

; ===========================================================================
	include "_incObj/66 MTZ Spring Walls.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj66_MapUnc_27120:	include "mappings/sprite/obj66.asm"
; ===========================================================================

    if gameRevision=0
	jmpTos JmpTo47_DisplaySprite,JmpTo33_DeleteObject,JmpTo30_Adjust2PArtPointer,JmpTo3_SolidObject_Always_SingleCharacter
    else
	jmpTos JmpTo33_DeleteObject,JmpTo30_Adjust2PArtPointer,JmpTo3_SolidObject_Always_SingleCharacter
    endif

; ===========================================================================
	include "_incObj/67 MTZ Spin Tube.asm"
; ===========================================================================
; MTZ tube position data
; off_273F2:
	include	"misc/obj67.asm"
	include "_anim/MTZ Spin Tube.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj67_MapUnc_27548:	include "mappings/sprite/obj67.asm"
; ===========================================================================

	jmpTos JmpTo19_DisplaySprite,JmpTo7_AnimateSprite,JmpTo4_MarkObjGone3

; ===========================================================================
	include "_incObj/68 MTZ Harpoon Block.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj68_Obj6D_MapUnc_27750:	include "mappings/sprite/obj68.asm"
; ===========================================================================
	include "_incObj/6D MTZ Floor Harpoon.asm"
; ===========================================================================

	jmpTos JmpTo20_MarkObjGone,JmpTo12_AllocateObjectAfterCurrent,JmpTo31_Adjust2PArtPointer,JmpTo11_SolidObject,JmpTo2_MarkObjGone2

; ===========================================================================
	include "_incObj/69 Nut.asm" ; BLAME THE DISCORD FOR THIS ONE
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj69_MapUnc_27A26:	include "mappings/sprite/obj69.asm"
; ===========================================================================

	jmpTos JmpTo21_MarkObjGone,JmpTo_ObjCheckFloorDist,JmpTo32_Adjust2PArtPointer,JmpTo12_SolidObject,JmpTo13_ObjectMove

; ===========================================================================
	include "_incObj/6A MTZ Shifting Platform.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj6A_MapUnc_27D30:	include "mappings/sprite/obj6A.asm"
; ===========================================================================

	jmpTos JmpTo13_AllocateObjectAfterCurrent,JmpTo33_Adjust2PArtPointer,JmpTo13_SolidObject,JmpTo3_MarkObjGone2

; ===========================================================================
	include "_incObj/6B MTZ Immobile Platform.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj6B_MapUnc_2800E:	include "mappings/sprite/obj6B.asm"
; ===========================================================================

	jmpTos JmpTo34_Adjust2PArtPointer,JmpTo14_SolidObject,JmpTo4_MarkObjGone2,JmpTo14_ObjectMove

; ===========================================================================
	include "_incObj/6C MTZ Pulley Platform.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj6C_MapUnc_28372:	include "mappings/sprite/obj6C.asm"
; ===========================================================================

	jmpTos JmpTo20_DisplaySprite,JmpTo34_DeleteObject,JmpTo8_AllocateObject,JmpTo35_Adjust2PArtPointer,JmpTo5_PlatformObject,JmpTo15_ObjectMove

; ===========================================================================
	include "_incObj/6E MTZ Circular Platform.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj6E_MapUnc_2852C:	include "mappings/sprite/obj6E.asm"
; ===========================================================================

	jmpTos JmpTo36_Adjust2PArtPointer,JmpTo15_SolidObject

; ===========================================================================
	include "_incObj/70 MTZ Giant Cog.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj70_MapUnc_28786:	include "mappings/sprite/obj70.asm"
; ===========================================================================

	jmpTos JmpTo14_AllocateObjectAfterCurrent,JmpTo4_Adjust2PArtPointer2,JmpTo16_SolidObject

; ===========================================================================
	include "_incObj/72 CNZ Conveyor.asm"
; ===========================================================================

	jmpTos JmpTo5_MarkObjGone3

; ===========================================================================
	include "_incObj/73 MCZ Rotating Platform (Unused).asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj73_MapUnc_28B9C:	include "mappings/sprite/obj73.asm"
; ===========================================================================

	jmpTos JmpTo21_DisplaySprite,JmpTo9_AllocateObject,JmpTo_DeleteObject2,JmpTo37_Adjust2PArtPointer,JmpTo17_SolidObject

; ===========================================================================
	include "_incObj/75 MCZ Brick.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj75_MapUnc_28D8A:	include "mappings/sprite/obj75.asm"
; ===========================================================================

	jmpTos JmpTo_DisplaySprite3,JmpTo22_DisplaySprite,JmpTo38_DeleteObject,JmpTo22_MarkObjGone,JmpTo2_DeleteObject2,JmpTo15_AllocateObjectAfterCurrent,JmpTo38_Adjust2PArtPointer,JmpTo8_CalcSine,JmpTo18_SolidObject

; ===========================================================================
	include "_incObj/76 MCZ Sliding Spikes.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj76_MapUnc_28F3A:	include "mappings/sprite/obj76.asm"
; ===========================================================================

	jmpTos JmpTo_Touch_ChkHurt2,JmpTo39_Adjust2PArtPointer,JmpTo19_SolidObject,JmpTo5_MarkObjGone2

; ===========================================================================
	include "_incObj/77 MCZ Bridge.asm"
; ===========================================================================
	include "_anim/MCZ Bridge.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj77_MapUnc_29064:	include "mappings/sprite/obj77.asm"
; ===========================================================================

	jmpTos JmpTo23_MarkObjGone,JmpTo40_Adjust2PArtPointer,JmpTo20_SolidObject

; ===========================================================================
	include "_incObj/78 Staircase.asm"
; ===========================================================================

	jmpTos JmpTo16_AllocateObjectAfterCurrent,JmpTo5_Adjust2PArtPointer2,JmpTo21_SolidObject,JmpTo6_MarkObjGone2

; ===========================================================================
	include "_incObj/7A CPZ Sliding Platform.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj7A_MapUnc_29564:	include "mappings/sprite/obj7A.asm"
; ===========================================================================

	jmpTos JmpTo24_DisplaySprite,JmpTo17_AllocateObjectAfterCurrent,JmpTo41_Adjust2PArtPointer,JmpTo6_PlatformObject

; ===========================================================================
	include "_incObj/7B CPZ Spring Lid.asm"
; ===========================================================================
	include "_anim/CPZ Spring Lid.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj7B_MapUnc_29780:	include "mappings/sprite/obj7B.asm"
; ===========================================================================

	jmpTos JmpTo25_DisplaySprite,JmpTo40_DeleteObject,JmpTo8_AnimateSprite,JmpTo42_Adjust2PArtPointer,JmpTo4_SolidObject_Always_SingleCharacter

; ===========================================================================
	include "_incObj/7F MCZ Vine Switch.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj7F_MapUnc_29938:	include "mappings/sprite/obj7F.asm"
; ===========================================================================

	jmpTos JmpTo24_MarkObjGone,JmpTo43_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/80 MCZ Moving Vine.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj80_MapUnc_29C64:	include "mappings/sprite/obj80_a.asm"
Obj80_MapUnc_29DD0:	include "mappings/sprite/obj80_b.asm"
; ===========================================================================

	jmpTos JmpTo25_MarkObjGone,JmpTo44_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/81 MCZ Drawbridge.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj81_MapUnc_2A24E:	include "mappings/sprite/obj81.asm"
; ===========================================================================

	jmpTos JmpTo2_DisplaySprite3,JmpTo26_DisplaySprite,JmpTo41_DeleteObject,JmpTo3_DeleteObject2,JmpTo18_AllocateObjectAfterCurrent,JmpTo45_Adjust2PArtPointer,JmpTo9_CalcSine,JmpTo22_SolidObject

; ===========================================================================
	include "_incObj/82 ARZ Swinging Platform.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj82_MapUnc_2A476:	include "mappings/sprite/obj82.asm"
; ===========================================================================

	jmpTos JmpTo2_ObjCheckFloorDist,JmpTo46_Adjust2PArtPointer,JmpTo_ObjCheckCeilingDist,JmpTo23_SolidObject,JmpTo7_MarkObjGone2,JmpTo16_ObjectMove

; ===========================================================================
	include "_incObj/83 ARZ Rotating Platform Triple.asm"
; ===========================================================================

	jmpTos JmpTo3_DisplaySprite3,JmpTo27_DisplaySprite,JmpTo42_DeleteObject,JmpTo4_DeleteObject2,JmpTo19_AllocateObjectAfterCurrent,JmpTo47_Adjust2PArtPointer,JmpTo10_CalcSine,JmpTo7_PlatformObject,JmpTo8_MarkObjGone2

; ===========================================================================
	include "_incObj/3F OOZ Fan.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
; sidefacing fan
Obj3F_MapUnc_2AA12:	include "mappings/sprite/obj3F_a.asm"
; upfacing fan
Obj3F_MapUnc_2AAC4:	include "mappings/sprite/obj3F_b.asm"
; ===========================================================================

	jmpTos JmpTo26_MarkObjGone,JmpTo48_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/85 CNZ Pinball Plunger Spring.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj85_MapUnc_2B07E:	include "mappings/sprite/obj85_a.asm"
Obj85_MapUnc_2B0EC:	include "mappings/sprite/obj85_b.asm"
; ===========================================================================

	jmpTos JmpTo4_DisplaySprite3,JmpTo43_DeleteObject,JmpTo49_Adjust2PArtPointer,JmpTo5_SolidObject_Always_SingleCharacter

; ===========================================================================
	include "_incObj/86 CNZ Pinball Flipper.asm"
	include "_anim/CNZ Pinball Flipper.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj86_MapUnc_2B45A:	include "mappings/sprite/obj86.asm"
; ===========================================================================

	jmpTos JmpTo27_MarkObjGone,JmpTo9_AnimateSprite,JmpTo50_Adjust2PArtPointer,JmpTo11_CalcSine,JmpTo6_SolidObject_Always_SingleCharacter,JmpTo2_SlopedSolid

; ===========================================================================
	include "_incObj/D2 CNZ Snake Block.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjD2_MapUnc_2B694:	include "mappings/sprite/objD2.asm"
; ===========================================================================

	jmpTos JmpTo6_MarkObjGone3,JmpTo51_Adjust2PArtPointer,JmpTo24_SolidObject,JmpTo9_MarkObjGone2

; ===========================================================================
	include "_incObj/D3 CNZ Bomb Prize.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjD3_MapUnc_2B8D4:	include "mappings/sprite/objD6_a.asm"
; ===========================================================================

	jmpTos JmpTo28_DisplaySprite,JmpTo44_DeleteObject

; ===========================================================================
	include "_incObj/D4 CNZ Big Block.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjD4_MapUnc_2B9CA:	include "mappings/sprite/objD4.asm"
; ===========================================================================

	jmpTos JmpTo52_Adjust2PArtPointer,JmpTo25_SolidObject,JmpTo10_MarkObjGone2,JmpTo17_ObjectMove

; ===========================================================================
	include "_incObj/D5 CNZ Elevator.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjD5_MapUnc_2BB40:	include "mappings/sprite/objD5.asm"
; ===========================================================================

	jmpTos JmpTo28_MarkObjGone,JmpTo53_Adjust2PArtPointer,JmpTo_PlatformObjectD5,JmpTo18_ObjectMove

; ===========================================================================
	include "_incObj/D6 CNZ Points Cage.asm"
	include "_anim/CNZ Points Cage.asm"
; ------------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------------
ObjD6_MapUnc_2BEBC:	include "mappings/sprite/objD6_b.asm"
; ===========================================================================
	include "_incObj/sub SlotMachine.asm"
; ===========================================================================

	jmpTos JmpTo10_AllocateObject,JmpTo29_MarkObjGone,JmpTo10_AnimateSprite,JmpTo6_Adjust2PArtPointer2,JmpTo54_Adjust2PArtPointer,JmpTo12_CalcSine,JmpTo7_SolidObject_Always_SingleCharacter

; ===========================================================================
	include "_incObj/D7 CNZ Bumper.asm"
; ===========================================================================
	include "_anim/CNZ Bumper.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjD7_MapUnc_2C626:	include "mappings/sprite/objD7.asm"
; ===========================================================================

	jmpTos JmpTo30_DisplaySprite,JmpTo30_MarkObjGone,JmpTo11_AnimateSprite,JmpTo55_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/D8 CNZ Point Block.asm"
; ===========================================================================
	include "_anim/CNZ Point Block.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjD8_MapUnc_2C8C4:	include "mappings/sprite/objD8.asm"
; ===========================================================================

	jmpTos JmpTo46_DeleteObject,JmpTo11_AllocateObject,JmpTo31_MarkObjGone,JmpTo12_AnimateSprite,JmpTo56_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/D9 Invisible Hang Flag.asm"
; ===========================================================================

	jmpTos JmpTo7_MarkObjGone3

; ===========================================================================
	include "_incObj/4A Octus.asm"
; ===========================================================================
	include "_anim/Octus.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj4A_MapUnc_2CBFE:	include "mappings/sprite/obj4A.asm"
; ===========================================================================

	jmpTos0 JmpTo31_DisplaySprite,JmpTo47_DeleteObject,JmpTo32_MarkObjGone,JmpTo13_AnimateSprite,JmpTo2_ObjectMoveAndFall,JmpTo19_ObjectMove

; ===========================================================================
	include "_incObj/50 Aquis.asm"
; ===========================================================================
	include "_anim/Aquis.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj50_MapUnc_2CF94:	include "mappings/sprite/obj50.asm"
; ===========================================================================

	jmpTos JmpTo32_DisplaySprite,JmpTo48_DeleteObject,JmpTo12_AllocateObject,JmpTo33_MarkObjGone,JmpTo14_AnimateSprite,JmpTo_Obj_GetOrientationToPlayer,JmpTo_Obj_CapSpeed,JmpTo_Obj_MoveStop,JmpTo20_ObjectMove

; ===========================================================================
	include "_incObj/4B Buzzer.asm"
; ===========================================================================
	include "_anim/Buzzer.asm"
; ----------------------------------------------------------------------------
; sprite mappings -- Buzz Bomber Sprite Table
; ----------------------------------------------------------------------------
; MapUnc_2D2EA: SprTbl_Buzzer:
Obj4B_MapUnc_2D2EA:	include "mappings/sprite/obj4B.asm"
; ===========================================================================

	jmpTos0 JmpTo49_DeleteObject,JmpTo20_AllocateObjectAfterCurrent,JmpTo15_AnimateSprite,JmpTo7_Adjust2PArtPointer2,JmpTo_MarkObjGone_P1,JmpTo57_Adjust2PArtPointer,JmpTo21_ObjectMove

; ===========================================================================
	include "_incObj/5C Masher.asm"
; ===========================================================================
	include "_anim/Masher.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj5C_MapUnc_2D442:	include "mappings/sprite/obj5C.asm"
; ===========================================================================

	jmpTos0 JmpTo34_MarkObjGone,JmpTo16_AnimateSprite,JmpTo58_Adjust2PArtPointer,JmpTo22_ObjectMove

; ===========================================================================
	include "_incObj/58 Boss Explosions.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj58_MapUnc_2D50A:	include "mappings/sprite/obj58.asm"
; ===========================================================================
	include "_incObj/sub BossCommon.asm" ; bunch of common stuff for bosses, like damage and animation
; ===========================================================================

	jmpTos JmpTo33_DisplaySprite,JmpTo50_DeleteObject,JmpTo4_LoadPLC,JmpTo_AddPoints,JmpTo59_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/5D CPZ Boss.asm"

BranchTo2_JmpTo34_DisplaySprite ; BranchTo
	jmpto	JmpTo34_DisplaySprite

    if removeJmpTos
JmpTo34_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo51_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
	include "_anim/CPZ Boss 1.asm"
; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_CPZBoss
; ----------------------------------------------------------------------------
Obj5D_MapUnc_2EADC:	include "mappings/sprite/obj5D_a.asm"

	include "_anim/CPZ Boss 2.asm"

; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_Eggpod
; ----------------------------------------------------------------------------
Obj5D_MapUnc_2ED8C:	include "mappings/sprite/obj5D_b.asm"
; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_EggpodJets
; ----------------------------------------------------------------------------
Obj5D_MapUnc_2EE88:	include "mappings/sprite/obj5D_c.asm"
; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_BossSmoke
; ----------------------------------------------------------------------------
Obj5D_MapUnc_2EEA0:	include "mappings/sprite/obj5D_d.asm"
; ===========================================================================

	jmpTos JmpTo34_DisplaySprite,JmpTo51_DeleteObject,JmpTo35_MarkObjGone,JmpTo5_PlaySound,JmpTo8_Adjust2PArtPointer2,JmpTo5_LoadPLC,JmpTo2_AddPoints,JmpTo60_Adjust2PArtPointer,JmpTo_PlayLevelMusic,JmpTo_LoadPLC_AnimalExplosion,JmpTo3_ObjectMoveAndFall,JmpTo23_ObjectMove

; ===========================================================================
	include "_incObj/56 EHZ Boss.asm"
; ===========================================================================
	include "_anim/EHZ Boss 1.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj56_MapUnc_2F970:	include "mappings/sprite/obj56_a.asm"
	; propeller
	; 7 frames
	include "_anim/EHZ Boss 2.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj56_MapUnc_2FA58:	include "mappings/sprite/obj56_b.asm"
	; ground vehicle
	; frame 0 = vehicle itself
	; frame 1-3 = spike
	; frame 4-5 = foreground wheel
	; frame 6-7 = background wheel
	include "_anim/EHZ Boss 3.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj56_MapUnc_2FAF8:	include "mappings/sprite/obj56_c.asm"
	; flying vehicle
	; frame 0 = bottom
	; frame 1-2 = top, normal
	; frame 3-4 = top, laughter
	; frame 5 = top, when hit
	; frame 6 = top, when flying off
; ===========================================================================

	jmpTos JmpTo35_DisplaySprite,JmpTo52_DeleteObject,JmpTo36_MarkObjGone,JmpTo5_DeleteObject2,JmpTo6_PlaySound,JmpTo21_AllocateObjectAfterCurrent,JmpTo17_AnimateSprite,JmpTo9_Adjust2PArtPointer2,JmpTo3_ObjCheckFloorDist,JmpTo6_LoadPLC,JmpTo3_AddPoints,JmpTo61_Adjust2PArtPointer,JmpTo2_PlayLevelMusic,JmpTo2_LoadPLC_AnimalExplosion,JmpTo4_ObjectMoveAndFall

; ===========================================================================
	include "_incObj/52 HTZ Boss.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_BossSmoke
; ----------------------------------------------------------------------------
Obj52_MapUnc_30258:	include "mappings/sprite/obj52_a.asm"
	include "_anim/HTZ Boss.asm"
; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_Eggpod + ?
; ----------------------------------------------------------------------------
Obj52_MapUnc_302BC:	include "mappings/sprite/obj52_b.asm"
; ===========================================================================

	jmpTos0 JmpTo36_DisplaySprite,JmpTo53_DeleteObject,JmpTo13_AllocateObject,JmpTo37_MarkObjGone,JmpTo7_PlaySound,JmpTo18_AnimateSprite,JmpTo4_ObjCheckFloorDist,JmpTo7_LoadPLC,JmpTo_Obj20,JmpTo4_AddPoints,JmpTo62_Adjust2PArtPointer,JmpTo3_PlayLevelMusic,JmpTo3_LoadPLC_AnimalExplosion

; ===========================================================================
	include "_incObj/89 ARZ Boss.asm"
; ===========================================================================
	include "_anim/ARZ Boss 1.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj89_MapUnc_30D68:	include "mappings/sprite/obj89_a.asm"
	include "_anim/ARZ Boss 2.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj89_MapUnc_30E04:	include "mappings/sprite/obj89_b.asm"
; ===========================================================================

	jmpTos JmpTo37_DisplaySprite,JmpTo55_DeleteObject,JmpTo14_AllocateObject,JmpTo8_PlaySound,JmpTo22_AllocateObjectAfterCurrent,JmpTo19_AnimateSprite,JmpTo3_RandomNumber,JmpTo8_LoadPLC,JmpTo5_AddPoints,JmpTo4_PlayLevelMusic,JmpTo4_LoadPLC_AnimalExplosion,JmpTo8_PlatformObject,JmpTo26_SolidObject

; ===========================================================================
	include "_incObj/57 MCZ Boss.asm"
; ===========================================================================
	include "_anim/MCZ Boss.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj57_MapUnc_316EC:	include "mappings/sprite/obj57.asm"
; ===========================================================================

	jmpTos JmpTo38_DisplaySprite,JmpTo57_DeleteObject,JmpTo15_AllocateObject,JmpTo4_RandomNumber,JmpTo9_LoadPLC,JmpTo6_AddPoints,JmpTo5_PlayLevelMusic,JmpTo5_LoadPLC_AnimalExplosion,JmpTo5_ObjectMoveAndFall

; ===========================================================================
	include "_incObj/51 CNZ Boss.asm"
; ===========================================================================
	include "_anim/CNZ Boss.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj51_MapUnc_320EA:	include "mappings/sprite/obj51.asm"
; ===========================================================================

	jmpTos JmpTo39_DisplaySprite,JmpTo59_DeleteObject,JmpTo16_AllocateObject,JmpTo9_PlaySound,JmpTo23_AllocateObjectAfterCurrent,JmpTo20_AnimateSprite,JmpTo10_LoadPLC,JmpTo7_AddPoints,JmpTo6_PlayLevelMusic,JmpTo6_LoadPLC_AnimalExplosion

; ===========================================================================
	include "_incObj/53 & 54 MTZ Boss.asm" ; 54 is the boss, 53 are the shield orbs
; ===========================================================================
	include "_anim/MTZ Boss.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj54_MapUnc_32DC6:	include "mappings/sprite/obj54.asm"
; ===========================================================================

	jmpTos0 JmpTo40_DisplaySprite,JmpTo61_DeleteObject,JmpTo17_AllocateObject,JmpTo10_PlaySound,JmpTo21_AnimateSprite,JmpTo11_LoadPLC,JmpTo8_AddPoints,JmpTo7_PlayLevelMusic,JmpTo7_LoadPLC_AnimalExplosion,JmpTo6_ObjectMoveAndFall,JmpTo24_ObjectMove

; ===========================================================================
	include "_incObj/55 OOZ Boss.asm"
; ===========================================================================
	include "_anim/OOZ Boss.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj55_MapUnc_33756:	include "mappings/sprite/obj55.asm"
; ===========================================================================

	jmpTos JmpTo41_DisplaySprite,JmpTo62_DeleteObject,JmpTo18_AllocateObject,JmpTo38_MarkObjGone,JmpTo11_PlaySound,JmpTo24_AllocateObjectAfterCurrent,JmpTo22_AnimateSprite,JmpTo5_RandomNumber,JmpTo63_Adjust2PArtPointer,JmpTo13_CalcSine,JmpTo8_PlayLevelMusic,JmpTo8_LoadPLC_AnimalExplosion,JmpTo25_ObjectMove

; ===========================================================================
	include "_incObj/09 Sonic in Special Stage.asm"
; ===========================================================================
	include "_incObj/63 Special Stage Character Shadow.asm"
; ===========================================================================
	include "_anim/Sonic in Special Stage.asm"
; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_SpecialSonicAndTails
; ----------------------------------------------------------------------------
Obj09_MapUnc_34212:	include "mappings/sprite/obj09.asm"
; ----------------------------------------------------------------------------
; sprite mappings for special stage shadows
; ----------------------------------------------------------------------------
Obj63_MapUnc_34492:	include "mappings/sprite/obj63.asm"
	include "mappings/spriteDPLC/Special Stage Player.asm"
; ===========================================================================

	jmpTos JmpTo42_DisplaySprite,JmpTo_SSAllocateObject

; ===========================================================================
	include "_incObj/10 & 88 Tails in Special Stage.asm" ; 88 is Tails' tails
; ===========================================================================
	include "_anim/Tails in Special Stage.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj10_MapUnc_34B3E:	include "mappings/sprite/obj10.asm"

	include "_anim/Tails in Special Stage's Tails.asm"
; ----------------------------------------------------------------------------
; sprite mappings for Tails' tails in special stage
; ----------------------------------------------------------------------------
Obj88_MapUnc_34DA8:	include "mappings/sprite/obj88.asm"
; ===========================================================================

	jmpTos JmpTo43_DisplaySprite,JmpTo23_AnimateSprite

; ===========================================================================
	include "_incObj/60 & 61 Special Stage Rings & Bombs.asm"
; ===========================================================================
	include "_incObj/5B Special Stage Ring Loss.asm"

SSRainbowPaletteColors:
	move.w	word_35548(pc,d0.w),(Normal_palette_line4+$16).w
	move.w	word_35548+2(pc,d0.w),(Normal_palette_line4+$18).w
	move.w	word_35548+4(pc,d0.w),(Normal_palette_line4+$1A).w
	rts
; ===========================================================================
word_35548:
	dc.w   $EE,  $88,  $44
	dc.w   $EE,  $CC,  $88	; 3
; ===========================================================================
	include "_incObj/5A Special Stage Messages.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj5A_MapUnc_35E1E:	include "mappings/sprite/obj5A.asm"
; ===========================================================================

loc_35F76:
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	move.w	word_35F92(pc,d0.w),(Normal_palette_line4+$16).w
	move.w	word_35F92+2(pc,d0.w),(Normal_palette_line4+$18).w
	move.w	word_35F92+4(pc,d0.w),(Normal_palette_line4+$1A).w
	rts
; ===========================================================================
; Special Stage Chaos Emerald palette
word_35F92:	BINCLUDE	"art/palettes/SS Emerald.bin"
; ===========================================================================
	include "_incObj/59 Special Stage Chaos Emerald.asm"
; ===========================================================================
	include "_anim/Special Stage Chaos Emerald.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj59_MapUnc_3625A:	include "mappings/sprite/obj59.asm"

	include "_anim/Special Stage Ring Loss.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj5A_Obj5B_Obj60_MapUnc_3632A:	include "mappings/sprite/obj5A_5B_60.asm"

	include "_anim/Special Stage Bombs.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj61_MapUnc_36508:	include "mappings/sprite/obj61.asm"
; ===========================================================================

	jmpTos0 JmpTo44_DisplaySprite,JmpTo63_DeleteObject,JmpTo24_AnimateSprite,JmpTo_SSStartNewAct,JmpTo_CalcAngle,JmpTo14_CalcSine,JmpTo7_ObjectMoveAndFall,JmpTo_SSAllocateObjectAfterCurrent,JmpTo2_SSAllocateObject

; ===========================================================================
	include "_incObj/sub LoadSubObject.asm"
	include "_incObj/sub ObjCommon.asm" ; Lots of common subroutines for objects in here
; ===========================================================================
	include "_incObj/8C Whisp.asm"
	include "_anim/Whisp.asm"
; ------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------
Obj8C_MapUnc_36A4E:	include "mappings/sprite/obj8C.asm"
; ===========================================================================
	include "_incObj/8D, 8F & 90 Grounder in Wall.asm" ; 8F is the wall, 90 is the debris
	include "_anim/Grounder in Wall.asm"
	include "mappings/sprite/obj8D_90.asm"
; ===========================================================================
	include "_incObj/91 Chop Chop.asm"
	include "_anim/Chop Chop.asm"
; --------------------------------------------------------------------------
; sprite mappings
; --------------------------------------------------------------------------
Obj91_MapUnc_36EF6:	include "mappings/sprite/obj91.asm"
; ===========================================================================
	include "_incObj/92 & 93 Spiker.asm" ; 93 is the drill it launches
	include "_anim/Spiker.asm"
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
Obj92_Obj93_MapUnc_37092:	include "mappings/sprite/obj93.asm"
; ===========================================================================
	include "_incObj/95 Sol.asm"
; ===========================================================================
	include "_anim/Sol.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj95_MapUnc_372E6:	include "mappings/sprite/obj95.asm"

Invalid_SubObjData:

; ===========================================================================
	include "_incObj/94, 96 & 97 Rexon.asm" ; 97 is the head
; ------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------
Obj94_Obj98_MapUnc_37678:	include "mappings/sprite/obj97.asm"

; seems to be a lookup table for oscillating horizontal position offset
byte_376A8:
	dc.b $F,  0
	dc.b $F,$FF	; 1
	dc.b $F,$FF	; 2
	dc.b $F,$FE	; 3
	dc.b $F,$FD	; 4
	dc.b $F,$FC	; 5
	dc.b $E,$FC	; 6
	dc.b $E,$FB	; 7
	dc.b $E,$FA	; 8
	dc.b $E,$FA	; 9
	dc.b $D,$F9	; 10
	dc.b $D,$F8	; 11
	dc.b $C,$F8	; 12
	dc.b $C,$F7	; 13
	dc.b $C,$F6	; 14
	dc.b $B,$F6	; 15
	dc.b $B,$F5	; 16
	dc.b $A,$F5	; 17
	dc.b $A,$F4	; 18
	dc.b  9,$F4	; 19
	dc.b  8,$F4	; 20
	dc.b  8,$F3	; 21
	dc.b  7,$F3	; 22
	dc.b  6,$F2	; 23
	dc.b  6,$F2	; 24
	dc.b  5,$F2	; 25
	dc.b  4,$F2	; 26
	dc.b  4,$F1	; 27
	dc.b  3,$F1	; 28
	dc.b  2,$F1	; 29
	dc.b  1,$F1	; 30
	dc.b  1,$F1	; 31

; ===========================================================================
	include "_incObj/98 Projectile With Gravity.asm"
; ===========================================================================
; off_37764:
Obj94_SubObjData2:
	subObjData Obj94_Obj98_MapUnc_37678,make_art_tile(ArtTile_ArtNem_Rexon,1,0),1<<render_flags.on_screen|1<<render_flags.level_fg,4,4,$98
; off_3776E:
Obj99_SubObjData:
	subObjData Obj99_Obj98_MapUnc_3789A,make_art_tile(ArtTile_ArtNem_Nebula,1,1),1<<render_flags.on_screen|1<<render_flags.level_fg,4,8,$8B
; off_37778:
Obj9A_SubObjData2:
	subObjData Obj9A_Obj98_MapUnc_37B62,make_art_tile(ArtTile_ArtNem_Turtloid,0,0),1<<render_flags.on_screen|1<<render_flags.level_fg,4,4,$98
; off_37782:
Obj9D_SubObjData2:
	subObjData Obj9D_Obj98_MapUnc_37D96,make_art_tile(ArtTile_ArtNem_Coconuts,0,0),1<<render_flags.on_screen|1<<render_flags.level_fg,4,8,$8B
; off_3778C:
ObjA4_SubObjData2:
	subObjData ObjA4_Obj98_MapUnc_38A96,make_art_tile(ArtTile_ArtNem_MtzSupernova,0,1),1<<render_flags.on_screen|1<<render_flags.level_fg,5,4,$98
; off_37796:
ObjA6_SubObjData:
	subObjData ObjA5_ObjA6_Obj98_MapUnc_38CCA,make_art_tile(ArtTile_ArtNem_Spiny,1,0),1<<render_flags.on_screen|1<<render_flags.level_fg,5,4,$98
; off_377A0:
ObjA7_SubObjData3:
	subObjData ObjA7_ObjA8_ObjA9_Obj98_MapUnc_3921A,make_art_tile(ArtTile_ArtNem_Grabber,1,1),1<<render_flags.on_screen|1<<render_flags.level_fg,4,4,$98
; off_377AA:
ObjAD_SubObjData3:
	subObjData ObjAD_Obj98_MapUnc_395B4,make_art_tile(ArtTile_ArtNem_WfzScratch,0,0),1<<render_flags.on_screen|1<<render_flags.level_fg,5,4,$98
; off_377B4:
ObjAF_SubObjData:
	subObjData ObjAF_Obj98_MapUnc_39E68,make_art_tile(ArtTile_ArtNem_CNZBonusSpike,1,0),1<<render_flags.on_screen|1<<render_flags.level_fg,5,4,$98
; off_377BE:
ObjB8_SubObjData2:
	subObjData ObjB8_Obj98_MapUnc_3BA46,make_art_tile(ArtTile_ArtNem_WfzWallTurret,0,0),1<<render_flags.on_screen|1<<render_flags.level_fg,3,4,$98

; ===========================================================================
	include "_incObj/99 Nebula.asm"
	include "_anim/Nebula.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj99_Obj98_MapUnc_3789A:	include "mappings/sprite/obj99.asm"
; ===========================================================================
	include "_incObj/9A & 9B Turtloid.asm" ; 9B is the one riding on top
; ===========================================================================
	include "_incObj/9C Balkiry's Jet.asm"
	include "_anim/Turtloid Shot.asm"
	include "_anim/Turtloid.asm"
	include "_anim/Balkiry's Jet.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj9A_Obj98_MapUnc_37B62:	include "mappings/sprite/obj9C.asm"

; ===========================================================================
	include "_incObj/9D Coconuts.asm"
	include "_anim/Coconuts.asm"
; ------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------
Obj9D_Obj98_MapUnc_37D96:	include "mappings/sprite/obj9D.asm"

; ===========================================================================
	include "_incObj/9E Crawltron.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj9E_MapUnc_37FF2:	include "mappings/sprite/obj9E.asm"

; ===========================================================================
	include "_incObj/9F & A0 Shellcracker.asm" ; A0 is the claw
	include "_anim/Shellcracker.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj9F_MapUnc_38314:	include "mappings/sprite/objA0.asm"
; ===========================================================================
	include "_incObj/A1 & A2 Slicer.asm" ; A2 is the pincers
	include "_anim/Slicer.asm"
	include "_anim/Slicer's Pincers.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjA1_MapUnc_385E2:	include "mappings/sprite/objA2.asm"

; ===========================================================================
	include "_incObj/A3 Flasher.asm"
	include "_anim/Flasher.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
ObjA3_MapUnc_388F0:	include "mappings/sprite/objA3.asm"

; ===========================================================================
	include "_incObj/A4 Asteron.asm"
	include "_anim/Asteron.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjA4_Obj98_MapUnc_38A96:	include "mappings/sprite/objA4.asm"

; ===========================================================================
	include "_incObj/A5 & A6 Spiny.asm" ; A6 is the Spiny on a wall
	include "_anim/Spiny.asm"
; ------------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------------
ObjA5_ObjA6_Obj98_MapUnc_38CCA:	include "mappings/sprite/objA6.asm"
; ===========================================================================
	include "_incObj/A7, A8, A9, AA & AB Grabber.asm" ; A8 is the legs, A9 is the spool, AA is the string, AB is unused
	include "_anim/Grabber.asm"
	include "mappings/sprite/Grabber.asm"
; ===========================================================================
	include "_incObj/AC Balkiry.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjAC_MapUnc_393CC:	include "mappings/sprite/objAC.asm"

; ===========================================================================
; ----------------------------------------------------------------------------
; Object AD - Clucker's base from WFZ
; ----------------------------------------------------------------------------
; Sprite_3941C:
ObjAD:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAD_Index(pc,d0.w),d1
	jmp	ObjAD_Index(pc,d1.w)
; ===========================================================================
; off_3942A:
ObjAD_Index:	offsetTable
		offsetTableEntry.w ObjAD_Init	; 0
		offsetTableEntry.w ObjAD_Main	; 2
; ===========================================================================
; loc_3942E:
ObjAD_Init:
	bsr.w	LoadSubObject
	move.b	#$C,mapping_frame(a0)
	rts
; ===========================================================================
; loc_3943A:
ObjAD_Main:
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	x_pos(a0),d4
	jsrto	JmpTo27_SolidObject
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object AE - Clucker (chicken badnik) from WFZ
; ----------------------------------------------------------------------------
; Sprite_39452:
ObjAE:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAE_Index(pc,d0.w),d1
	jmp	ObjAE_Index(pc,d1.w)
; ===========================================================================
; off_39460:
ObjAE_Index:	offsetTable
		offsetTableEntry.w ObjAE_Init	;  0
		offsetTableEntry.w loc_39488	;  2
		offsetTableEntry.w loc_394A2	;  4
		offsetTableEntry.w loc_394D2	;  6
		offsetTableEntry.w loc_394E0	;  8
		offsetTableEntry.w loc_39508	; $A
		offsetTableEntry.w loc_39516	; $C
; ===========================================================================
; loc_3946E:
ObjAE_Init:
	bsr.w	LoadSubObject
	move.b	#$15,mapping_frame(a0)
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	bset	#status.npc.x_flip,status(a0)
+
	rts
; ===========================================================================

loc_39488:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$80,d2
	cmpi.w	#$100,d2
	blo.s	+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_394A2:
	move.b	routine(a0),d2
	lea	(Ani_objAE_a).l,a1
	jsrto	JmpTo25_AnimateSprite
	cmp.b	routine(a0),d2
	bne.s	+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
+
	lea	mapping_frame(a0),a1
	clr.l	(a1) ; Clear mapping_frame, anim_frame, anim, and prev_anim.
	clr.w	anim_frame_duration-mapping_frame(a1)
	move.b	#8,(a1)
	move.b	#6,collision_flags(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_394D2:
	lea	(Ani_objAE_b).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_394E0:
	tst.b	objoff_2A(a0)
	beq.s	+
	subq.b	#1,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	lea	mapping_frame(a0),a1
	clr.l	(a1) ; Clear mapping_frame, anim_frame, anim, and prev_anim.
	clr.w	anim_frame_duration-mapping_frame(a1)
	move.b	#$B,(a1)
	bsr.w	loc_39526
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_39508:
	lea	(Ani_objAE_c).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_39516:
	move.b	#8,routine(a0)
	move.b	#$40,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_39526:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	++	; rts
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#$D,mapping_frame(a1)
	move.b	#$46,subtype(a1) ; <==  ObjAD_SubObjData3
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$B,y_pos(a1)
	move.w	#-$200,d0
	move.w	#-8,d1
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	neg.w	d0
	neg.w	d1
+
	move.w	d0,x_vel(a1)
	add.w	d1,x_pos(a1)
	lea_	Obj98_CluckerShotMove,a2
	move.l	a2,objoff_2A(a1)
+
	rts
; ===========================================================================
ObjAD_SubObjData:
	subObjData ObjAD_Obj98_MapUnc_395B4,make_art_tile(ArtTile_ArtNem_WfzScratch,0,0),1<<render_flags.level_fg,4,$18,0
ObjAD_SubObjData2:
	subObjData ObjAD_Obj98_MapUnc_395B4,make_art_tile(ArtTile_ArtNem_WfzScratch,0,0),1<<render_flags.level_fg,5,$10,0

; animation script
; off_3958A
Ani_objAE_a:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,  3,  4,  5,  6,  7,$FC
		even

; animation script
; off_39596
Ani_objAE_b:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  8,  9, $A, $B, $B, $B, $B,$FC
		even

; animation script
; off_395A2
Ani_objAE_c:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3, $A, $B,$FC
		even

; animation script
; off_395A8
Ani_CluckerShot:offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3, $D, $E, $F,$10,$11,$12,$13,$14,$FF
		even

; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjAD_Obj98_MapUnc_395B4:	include "mappings/sprite/objAE.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object AF - Mecha Sonic / Silver Sonic from DEZ
; (also handles Eggman's remote-control window)
; ----------------------------------------------------------------------------
; Sprite_3972C:
ObjAF:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAF_Index(pc,d0.w),d1
	jmp	ObjAF_Index(pc,d1.w)
; ===========================================================================
; off_3973A:
ObjAF_Index:	offsetTable
		offsetTableEntry.w ObjAF_Init	;   0
		offsetTableEntry.w loc_397AC	;   2
		offsetTableEntry.w loc_397E6	;   4
		offsetTableEntry.w loc_397FE	;   6
		offsetTableEntry.w loc_3984A	;   8
		offsetTableEntry.w loc_398C0	;  $A
		offsetTableEntry.w loc_39B92	;  $C
		offsetTableEntry.w loc_39BBA	;  $E
		offsetTableEntry.w loc_39BCC	; $10
		offsetTableEntry.w loc_39BE2	; $12
		offsetTableEntry.w loc_39BEA	; $14
		offsetTableEntry.w loc_39C02	; $16
		offsetTableEntry.w loc_39C0A	; $18
		offsetTableEntry.w loc_39C12	; $1A
		offsetTableEntry.w loc_39C2A	; $1C
		offsetTableEntry.w loc_39C42	; $1E
		offsetTableEntry.w loc_39C50	; $20
		offsetTableEntry.w loc_39CA0	; $22
; ===========================================================================
; loc_3975E:
ObjAF_Init:
	bsr.w	LoadSubObject
	move.b	#$1B,y_radius(a0)
	move.b	#$10,x_radius(a0)
	move.b	#0,collision_flags(a0)
	move.b	#8,collision_property(a0)
	lea	(ChildObject_39DC2).l,a2
	bsr.w	LoadChildObject
	move.b	#$E,routine(a1)
	lea	(ChildObject_39DC6).l,a2
	bsr.w	LoadChildObject
	move.b	#$14,routine(a1)
	lea	(ChildObject_39DCA).l,a2
	bsr.w	LoadChildObject
	move.b	#$1A,routine(a1)
	rts
; ===========================================================================

loc_397AC:
	move.w	(Camera_X_pos).w,d0
	cmpi.w	#$224,d0
	bhs.s	loc_397BA
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_397BA:
	addq.b	#2,routine(a0)
	move.w	#60,objoff_2A(a0)
	move.w	#$100,y_vel(a0)
	move.w	#$224,d0
	move.w	d0,(Camera_Min_X_pos).w
	move.w	d0,(Camera_Max_X_pos).w
	move.b	#9,(Current_Boss_ID).w
	moveq	#signextendB(MusID_FadeOut),d0
	jsrto	JmpTo12_PlaySound
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_397E6:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_397F0
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_397F0:
	addq.b	#2,routine(a0)
	moveq	#signextendB(MusID_Boss),d0
	jsrto	JmpTo5_PlayMusic
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_397FE:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	loc_3980E
	moveq	#signextendB(SndID_Fire),d0
	jsrto	JmpTo12_PlaySound

loc_3980E:
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bmi.s	loc_39830
	jsrto	JmpTo26_ObjectMove
	moveq	#0,d0
	moveq	#0,d1
	movea.w	parent(a0),a1 ; a1=object
	bsr.w	Obj_AlignChildXY
	bsr.w	loc_39D4A
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_39830:
	add.w	d1,y_pos(a0)
	move.w	#0,y_vel(a0)
	move.b	#$1A,collision_flags(a0)
	bset	#status.npc.y_flip,status(a0)
	bra.w	loc_399D6
; ===========================================================================

loc_3984A:
	bsr.w	loc_39CAE
	bsr.w	loc_39D1C
	subq.b	#1,objoff_2A(a0)
	beq.s	loc_39886
	cmpi.b	#$32,objoff_2A(a0)
	bne.s	loc_3986A
	moveq	#signextendB(SndID_MechaSonicBuzz),d0
	jsrto	JmpTo12_PlaySound
	jsrto	JmpTo45_DisplaySprite

loc_3986A:
	jsr	(ObjCheckFloorDist).l
	add.w	d1,y_pos(a0)
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	bsr.w	loc_39D4A
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_39886:
	addq.b	#2,routine(a0)
	moveq	#0,d0
	move.b	objoff_2F(a0),d0
	andi.b	#$F,d0
	move.b	byte_398B0(pc,d0.w),routine_secondary(a0)
	addq.b	#1,objoff_2F(a0)
	clr.b	objoff_2E(a0)
	movea.w	objoff_3C(a0),a1 ; a1=object
	move.b	#$16,routine(a1)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
byte_398B0:
	dc.b   6
	dc.b   0	; 1
	dc.b $10	; 2
	dc.b   6	; 3
	dc.b   6	; 4
	dc.b $1E	; 5
	dc.b   0	; 6
	dc.b $10	; 7
	dc.b   6	; 8
	dc.b   6	; 9
	dc.b $10	; 10
	dc.b   6	; 11
	dc.b   0	; 12
	dc.b   6	; 13
	dc.b $10	; 14
	dc.b $1E	; 15
	even
; ===========================================================================

loc_398C0:
	bsr.w	loc_39CAE
	bsr.w	loc_39D1C
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_398F2(pc,d0.w),d1
	jsr	off_398F2(pc,d1.w)
	moveq	#0,d0
	moveq	#0,d1
	movea.w	parent(a0),a1 ; a1=object
	bsr.w	Obj_AlignChildXY
	bsr.w	loc_39D4A
	bsr.w	Obj_AlignChildXY
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_398F2:	offsetTable
		offsetTableEntry.w loc_3991E	;   0
		offsetTableEntry.w loc_39946	;   2
		offsetTableEntry.w loc_39976	;   4
		offsetTableEntry.w loc_39A0A	;   6
		offsetTableEntry.w loc_39A1C	;   8
		offsetTableEntry.w loc_39A44	;  $A
		offsetTableEntry.w loc_39A68	;  $C
		offsetTableEntry.w loc_39A96	;  $E
		offsetTableEntry.w loc_39A0A	; $10
		offsetTableEntry.w loc_39A1C	; $12
		offsetTableEntry.w loc_39AAA	; $14
		offsetTableEntry.w loc_39ACE	; $16
		offsetTableEntry.w loc_39AF4	; $18
		offsetTableEntry.w loc_39B28	; $1A
		offsetTableEntry.w loc_39A96	; $1C
		offsetTableEntry.w loc_39A0A	; $1E
		offsetTableEntry.w loc_39A1C	; $20
		offsetTableEntry.w loc_39AAA	; $22
		offsetTableEntry.w loc_39ACE	; $24
		offsetTableEntry.w loc_39B44	; $26
		offsetTableEntry.w loc_39B28	; $28
		offsetTableEntry.w loc_39A96	; $2A
; ===========================================================================

loc_3991E:
	addq.b	#2,routine_secondary(a0)
	move.b	#3,mapping_frame(a0)
	move.b	#2,objoff_2C(a0)

loc_3992E:
	move.b	#$20,objoff_2A(a0)
	movea.w	parent(a0),a1 ; a1=object
	move.b	#$10,routine(a1)
	move.b	#1,anim(a1)
	rts
; ===========================================================================

loc_39946:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_3994E
	rts
; ===========================================================================

loc_3994E:
	addq.b	#2,routine_secondary(a0)
	move.b	#$40,objoff_2A(a0)
	move.b	#1,anim(a0)
	move.w	#$800,d0
	bsr.w	loc_39D60
	movea.w	parent(a0),a1 ; a1=object
	move.b	#2,anim(a1)
	moveq	#signextendB(SndID_SpindashRelease),d0
	jmpto	JmpTo12_PlaySound
; ===========================================================================

loc_39976:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_399C2
	cmpi.b	#$20,objoff_2A(a0)
	bne.s	loc_39994
	move.b	#2,anim(a0)
	movea.w	parent(a0),a1 ; a1=object
	move.b	#$12,routine(a1)

loc_39994:
	bsr.w	loc_39D72
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	cmpi.b	#2,anim(a0)
	bne.s	return_399C0
	cmpi.b	#2,anim_frame(a0)
	bne.s	return_399C0
	cmpi.b	#3,anim_frame_duration(a0)
	bne.s	return_399C0
	bchg	#render_flags.x_flip,render_flags(a0)

return_399C0:
	rts
; ===========================================================================

loc_399C2:
	subq.b	#1,objoff_2C(a0)
	beq.s	loc_399D6
	move.b	#2,routine_secondary(a0)
	clr.w	x_vel(a0)
	bra.w	loc_3992E
; ===========================================================================

loc_399D6:
	move.b	#8,routine(a0)
	move.b	#0,anim(a0)
	move.b	#$64,objoff_2A(a0)
	clr.w	x_vel(a0)
	movea.w	parent(a0),a1 ; a1=object
	move.b	#$12,routine(a1)
	movea.w	objoff_3C(a0),a1 ; a1=object
	move.b	#$18,routine(a1)
	moveq	#signextendB(SndID_MechaSonicBuzz),d0
	jsrto	JmpTo12_PlaySound
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_39A0A:
	addq.b	#2,routine_secondary(a0)
	move.b	#3,mapping_frame(a0)
	move.b	#3,anim(a0)
	rts
; ===========================================================================

loc_39A1C:
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	bne.s	loc_39A2A
	rts
; ===========================================================================

loc_39A2A:
	addq.b	#2,routine_secondary(a0)
	move.b	#$20,objoff_2A(a0)
	move.b	#4,anim(a0)
	moveq	#signextendB(SndID_LaserBeam),d0
	jsrto	JmpTo12_PlaySound
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_39A44:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_39A56
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	rts
; ===========================================================================

loc_39A56:
	addq.b	#2,routine_secondary(a0)
	move.b	#$40,objoff_2A(a0)
	move.w	#$800,d0
	bra.w	loc_39D60
; ===========================================================================

loc_39A68:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_39A7C
	bsr.w	loc_39D72
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39A7C:
	addq.b	#2,routine_secondary(a0)
	move.b	#5,anim(a0)
	bchg	#render_flags.x_flip,render_flags(a0)
	clr.w	x_vel(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_39A96:
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	bne.w	BranchTo_loc_399D6
	rts
; ===========================================================================

BranchTo_loc_399D6 ; BranchTo
	bra.w	loc_399D6
; ===========================================================================

loc_39AAA:
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_39ABC
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	rts
; ===========================================================================

loc_39ABC:
	addq.b	#2,routine_secondary(a0)
	move.b	#$40,objoff_2A(a0)
	move.w	#$400,d0
	bra.w	loc_39D60
; ===========================================================================

loc_39ACE:
	subq.b	#1,objoff_2A(a0)
	cmpi.b	#60,objoff_2A(a0)
	bne.s	loc_39ADE
	bsr.w	loc_39AE8

loc_39ADE:
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39AE8:
	addq.b	#2,routine_secondary(a0)
	move.w	#-$600,y_vel(a0)
	rts
; ===========================================================================

loc_39AF4:
	subq.b	#1,objoff_2A(a0)
	bmi.w	loc_39A7C
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	loc_39B0A
	bsr.w	loc_39B1A

loc_39B0A:
	addi.w	#$38,y_vel(a0)
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39B1A:
	addq.b	#2,routine_secondary(a0)
	add.w	d1,y_pos(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_39B28:
	subq.b	#1,objoff_2A(a0)
	bmi.w	loc_39A7C
	jsr	(ObjCheckFloorDist).l
	add.w	d1,y_pos(a0)
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39B44:
	subq.b	#1,objoff_2A(a0)
	bmi.w	loc_39A7C
	tst.b	objoff_2E(a0)
	bne.s	loc_39B66
	tst.w	y_vel(a0)
	bmi.s	loc_39B66
	st.b	objoff_2E(a0)
	bsr.w	loc_39D82
	moveq	#signextendB(SndID_SpikeSwitch),d0
	jsrto	JmpTo12_PlaySound

loc_39B66:
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	loc_39B74
	bsr.w	loc_39B84

loc_39B74:
	addi.w	#$38,y_vel(a0)
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39B84:
	addq.b	#2,routine_secondary(a0)
	add.w	d1,y_pos(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_39B92:
	clr.b	collision_flags(a0)
	subq.w	#1,objoff_32(a0)
	bmi.s	loc_39BA4
	jsrto	JmpTo_Boss_LoadExplosion
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_39BA4:
	move.w	#$1000,(Camera_Max_X_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w
    if fixBugs
	move.w	(Level_Music).w,d0
    else
	; 'Level_Music' is a word long, not a byte.
	; All this does is try to play Sound 0, which doesn't do anything.
	; This causes the Death Egg Music music to not resume after the
	; Silver Sonic fight.
	move.b	(Level_Music).w,d0
    endif
	jsrto	JmpTo5_PlayMusic
	jmpto	JmpTo65_DeleteObject
; ===========================================================================

loc_39BBA:
	bsr.w	LoadSubObject
	move.b	#8,width_pixels(a0)
	move.b	#0,collision_flags(a0)
	rts
; ===========================================================================

loc_39BCC:
	movea.w	objoff_2C(a0),a1 ; a1=object
	bsr.w	InheritParentXYFlip
	lea	(off_39E30).l,a1
	bsr.w	AnimateSprite_Checked
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_39BE2:
	andi.b	#~(1<<render_flags.on_screen)&$FF,render_flags(a0)
	rts
; ===========================================================================

loc_39BEA:
	bsr.w	LoadSubObject
	move.b	#8,width_pixels(a0)
	move.b	#$B,mapping_frame(a0)
	move.b	#3,priority(a0)
	rts
; ===========================================================================

loc_39C02:
	move.b	#0,collision_flags(a0)
	rts
; ===========================================================================

loc_39C0A:
	move.b	#$98,collision_flags(a0)
	rts
; ===========================================================================

loc_39C12:
	bsr.w	LoadSubObject
	move.b	#4,mapping_frame(a0)
	move.w	#$2C0,x_pos(a0)
	move.w	#$139,y_pos(a0)
	rts
; ===========================================================================

loc_39C2A:
	movea.w	objoff_2C(a0),a1 ; a1=object
	bclr	#status.npc.y_flip,status(a1)
	bne.s	loc_39C3A
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_39C3A:
	addq.b	#2,routine(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_39C42:
	lea	(Ani_objAF_c).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_39C50:
	movea.w	objoff_2C(a0),a1 ; a1=object
	lea	(MainCharacter).w,a2 ; a2=character
	btst	#status.npc.misc,status(a1)
	bne.s	loc_39C92
	move.b	#2,anim(a0)
	cmpi.b	#4,routine(a2)
	bne.s	loc_39C78
	move.b	#3,anim(a0)
	bra.w	loc_39C84
; ===========================================================================

loc_39C78:
	tst.b	collision_flags(a1)
	bne.s	loc_39C84
	move.b	#4,anim(a0)

loc_39C84:
	lea	(Ani_objAF_c).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_39C92:
	addq.b	#2,routine(a0)
	move.b	#1,anim(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_39CA0:
	lea	(Ani_objAF_c).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_39CAE:
	tst.b	collision_property(a0)
	beq.s	loc_39CF0
	tst.b	collision_flags(a0)
	bne.s	return_39CEE
	tst.b	objoff_30(a0)
	bne.s	loc_39CD0
	move.b	#$20,objoff_30(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l

loc_39CD0:
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	loc_39CDE
	move.w	#$EEE,d0

loc_39CDE:
	move.w	d0,(a1)
	subq.b	#1,objoff_30(a0)
	bne.s	return_39CEE
	clr.w	(Normal_palette_line2+2).w
	bsr.w	loc_39D24

return_39CEE:
	rts
; ===========================================================================

loc_39CF0:
	moveq	#100,d0
	bsr.w	AddPoints
	move.w	#$FF,objoff_32(a0)
	move.b	#$C,routine(a0)
	clr.b	collision_flags(a0)
	bset	#status.npc.misc,status(a0)
	movea.w	objoff_3C(a0),a1 ; a1=object
	jsrto	JmpTo6_DeleteObject2
	movea.w	parent(a0),a1 ; a1=object
	jmpto	JmpTo6_DeleteObject2
; ===========================================================================

loc_39D1C:
	tst.b	collision_flags(a0)
	beq.w	return_37A48

loc_39D24:
	move.b	mapping_frame(a0),d0
	cmpi.b	#6,d0
	beq.s	loc_39D42
	cmpi.b	#7,d0
	beq.s	loc_39D42
	cmpi.b	#8,d0
	beq.s	loc_39D42
	move.b	#$1A,collision_flags(a0)
	rts
; ===========================================================================

loc_39D42:
	move.b	#$9A,collision_flags(a0)
	rts
; ===========================================================================

loc_39D4A:
	moveq	#$C,d0
	moveq	#-$C,d1
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	loc_39D58
	neg.w	d0

loc_39D58:
	movea.w	objoff_3C(a0),a1 ; a1=object
	bra.w	Obj_AlignChildXY
; ===========================================================================

loc_39D60:
	tst.b	objoff_2D(a0)
	bne.s	loc_39D68
	neg.w	d0

loc_39D68:
	not.b	objoff_2D(a0)
	move.w	d0,x_vel(a0)
	rts
; ===========================================================================

loc_39D72:
	moveq	#$20,d0
	tst.w	x_vel(a0)
	bmi.s	loc_39D7C
	neg.w	d0

loc_39D7C:
	add.w	d0,x_vel(a0)
	rts
; ===========================================================================

loc_39D82:
	move.b	#$4A,d2
	moveq	#byte_39D92.counter,d6
	lea	(byte_39D92).l,a2
	bra.w	Obj_CreateProjectiles
; ===========================================================================
byte_39D92:
	dc.b    0,-$18
	dc.b    0,  -3
	dc.b   $F
	dc.b  FALSE<<render_flags.x_flip

	dc.b -$10,-$10
	dc.b   -2,  -2
	dc.b  $10
	dc.b  FALSE<<render_flags.x_flip

	dc.b -$18,   0
	dc.b   -3,   0
	dc.b  $11
	dc.b  FALSE<<render_flags.x_flip

	dc.b -$10, $10
	dc.b   -2,   2
	dc.b  $12
	dc.b  FALSE<<render_flags.x_flip

	dc.b    0, $18
	dc.b    0,   3
	dc.b  $13
	dc.b  FALSE<<render_flags.x_flip

	dc.b  $10, $10
	dc.b    2,   2
	dc.b  $14
	dc.b  FALSE<<render_flags.x_flip

	dc.b  $18,   0
	dc.b    3,   0
	dc.b  $15
	dc.b  FALSE<<render_flags.x_flip

	dc.b  $10, $F0
	dc.b    2,  -2
	dc.b  $16
	dc.b  FALSE<<render_flags.x_flip
byte_39D92.end:
byte_39D92.counter = ((byte_39D92.end - byte_39D92) / 6) - 1

ChildObject_39DC2:	childObjectData objoff_3E, ObjID_MechaSonic, $48
ChildObject_39DC6:	childObjectData objoff_3C, ObjID_MechaSonic, $48
ChildObject_39DCA:	childObjectData objoff_3A, ObjID_MechaSonic, $A4
; off_39DCE:
ObjAF_SubObjData2:
	subObjData ObjAF_Obj98_MapUnc_39E68,make_art_tile(ArtTile_ArtNem_SilverSonic,1,0),1<<render_flags.level_fg,4,$10,$1A
; off_39DD8:
ObjAF_SubObjData3:
	subObjData ObjAF_MapUnc_3A08C,make_art_tile(ArtTile_ArtNem_DEZWindow,0,0),1<<render_flags.level_fg,6,$10,0

; animation script
off_39DE2:	offsetTable
		offsetTableEntry.w byte_39DEE	; 0
		offsetTableEntry.w byte_39DF4	; 1
		offsetTableEntry.w byte_39DF8	; 2
		offsetTableEntry.w byte_39DFE	; 3
		offsetTableEntry.w byte_39E14	; 4
		offsetTableEntry.w byte_39E1A	; 5
byte_39DEE:
	dc.b   2,  0,  1,  2,$FF,  0
byte_39DF4:
	dc.b $45,  3,$FD,  0
byte_39DF8:
	dc.b   3,  4,  5,  4,  3,$FC
byte_39DFE:
	dc.b   3,  3,  3,  6,  6,  6,  7,  7,  7,  8,  8,  8,  6,  6,  7,  7
	dc.b   8,  8,  6,  7,  8,$FC; 16
byte_39E14:
	dc.b   2,  6,  7,  8,$FF,  0
byte_39E1A:
	dc.b   3,  8,  7,  6,  8,  8,  7,  7,  6,  6,  8,  8,  8,  7,  7,  7
	dc.b   6,  6,  6,  3,  3,$FC; 16
	even

; animation script
off_39E30:	offsetTable
		offsetTableEntry.w byte_39E36	; 0
		offsetTableEntry.w byte_39E3A	; 1
		offsetTableEntry.w byte_39E3E	; 2
byte_39E36:
	dc.b   1, $B, $C,$FF
byte_39E3A:
	dc.b   1, $D, $E,$FF
byte_39E3E:
	dc.b   1,  9, $A,$FF
	even

; animation script
; off_39E42:
Ani_objAF_c:	offsetTable
		offsetTableEntry.w byte_39E4C	; 0
		offsetTableEntry.w byte_39E54	; 1
		offsetTableEntry.w byte_39E5C	; 2
		offsetTableEntry.w byte_39E60	; 3
		offsetTableEntry.w byte_39E64	; 4
byte_39E4C:	dc.b   3,  4,  3,  2,  1,  0,$FC,  0
byte_39E54:	dc.b   3,  0,  1,  2,  3,  4,$FA,  0
byte_39E5C:	dc.b   3,  5,  5,$FF
byte_39E60:	dc.b   3,  5,  6,$FF
byte_39E64:	dc.b   3,  7,  7,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjAF_Obj98_MapUnc_39E68:	include "mappings/sprite/objAF_a.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjAF_MapUnc_3A08C:	include "mappings/sprite/objAF_b.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object B0 - Sonic on the Sega screen
; ----------------------------------------------------------------------------
; Sprite_3A1DC:
ObjB0:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB0_Index(pc,d0.w),d1
	jmp	ObjB0_Index(pc,d1.w)
; ===========================================================================
; off_3A1EA:
ObjB0_Index:	offsetTable
		offsetTableEntry.w ObjB0_Init		;  0
		offsetTableEntry.w ObjB0_RunLeft	;  2
		offsetTableEntry.w ObjB0_MidWipe	;  4
		offsetTableEntry.w ObjB0_RunRight	;  6
		offsetTableEntry.w ObjB0_EndWipe	;  8
		offsetTableEntry.w return_3A3F6		; $A
; ===========================================================================

ObjB0_Init:
	bsr.w	LoadSubObject
	move.w	#spriteScreenPositionX(screen_width+40),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(0),y_pixel(a0)
	move.w	#$B,objoff_2A(a0)
	move.w	#2,(SegaScr_VInt_Subrout).w
	bset	#render_flags.x_flip,render_flags(a0)
	bset	#status.npc.x_flip,status(a0)

	; Initialize streak horizontal offsets for Sonic going left.
	; 9 full lines (8 pixels) + 6 pixels, 2-byte interleaved entries for PNT A and PNT B
	lea	(Horiz_Scroll_Buf + 2 * 2 * (9 * 8 + 6)).w,a1
	lea	Streak_Horizontal_offsets(pc),a2
	moveq	#0,d0
	moveq	#35-1,d6	; Number of streaks-1
-	move.b	(a2)+,d0
	add.w	d0,(a1)
	addq.w	#2 * 2 * 2,a1	; Advance to next streak 2 pixels down
	dbf	d6,-

	lea	off_3A294(pc),a1 ; pointers to mapping DPLC data
	lea	(ArtUnc_Sonic).l,a3
	lea	(Chunk_Table).l,a5
	moveq	#4-1,d5 ; there are 4 mapping frames to loop over

	; this copies the tiles that we want to scale up from ROM to RAM
;loc_3A246:
;CopySpriteTilesToRAMForSegaScreen:
-	movea.l	(a1)+,a2
	move.w	(a2)+,d6 ; get the number of pieces in this mapping frame
	subq.w	#1,d6
-	move.w	(a2)+,d0
	move.w	d0,d1
	; Depending on the exact location (and size) of the art being used,
	; you may encounter an overflow in the original code which garbles
	; the enlarged Sonic. The following code fixes this:
    if fixBugs
	andi.l	#$FFF,d0
	lsl.l	#5,d0
	lea	(a3,d0.l),a4 ; source ROM address of tiles to copy
    else
	andi.w	#$FFF,d0
	lsl.w	#5,d0
	lea	(a3,d0.w),a4 ; source ROM address of tiles to copy
    endif
	andi.w	#$F000,d1 ; abcd000000000000
	rol.w	#4,d1	  ; (this calculation can be done smaller and faster
	addq.w	#1,d1	  ; by doing rol.w #7,d1 addq.w #7,d1
	lsl.w	#3,d1	  ; instead of these 4 lines)
	subq.w	#1,d1	  ; 000000000abcd111 ; number of dwords to copy minus 1
-	move.l	(a4)+,(a5)+
	dbf	d1,- ; copy all of the pixels in this piece into the temp buffer
	dbf	d6,-- ; loop per piece in the frame
	dbf	d5,--- ; loop per mapping frame

	; this scales up the tiles by 2
;ScaleUpSpriteTiles:
	move.w	d7,-(sp)
	moveq	#0,d0
	moveq	#0,d1
	lea	SonicRunningSpriteScaleData(pc),a6
	moveq	#4*2-1,d7 ; there are 4 sprite mapping frames with 2 pieces each
-	movea.l	(a6)+,a1 ; source in RAM of tile graphics to enlarge
	movea.l	(a6)+,a2 ; destination in RAM of enlarged graphics
	move.b	(a6)+,d0 ; width of the sprite piece to enlarge (minus 1)
	move.b	(a6)+,d1 ; height of the sprite piece to enlarge (minus 1)
	bsr.w	Scale_2x
	dbf	d7,- ; loop over each piece
	move.w	(sp)+,d7

	rts
; ===========================================================================
off_3A294:
	dc.l MapRUnc_Sonic.frame45
	dc.l MapRUnc_Sonic.frame46
	dc.l MapRUnc_Sonic.frame47
	dc.l MapRUnc_Sonic.frame48

map_piece macro width,height
	dc.l copysrc,copydst
	dc.b width-1,height-1
copysrc := copysrc + tiles_to_bytes(width * height)
copydst := copydst + tiles_to_bytes(width * height) * 2 * 2
    endm
;word_3A2A4:
SonicRunningSpriteScaleData:
copysrc := Chunk_Table
copydst := Chunk_Table + $B00
SegaScreenScaledSpriteDataStart = copydst
	rept 4 ; repeat 4 times since there are 4 frames to scale up
	; piece 1 of each frame (the smaller top piece):
	map_piece 3,2
	; piece 2 of each frame (the larger bottom piece):
	map_piece 4,4
	endm
SegaScreenScaledSpriteDataEnd = copydst
	if copysrc > SegaScreenScaledSpriteDataStart
	fatal "Scale copy source overran allocated size. Try changing the initial value of copydst to Chunk_Table+$\{copysrc-Chunk_Table}"
	endif
; ===========================================================================

ObjB0_RunLeft:
	subi.w	#$20,x_pos(a0)
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3A312
	bsr.w	ObjB0_Move_Streaks_Left
	lea	(Ani_objB0).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3A312:
	addq.b	#2,routine(a0)
	move.w	#$C,objoff_2A(a0)
	move.b	#1,objoff_2C(a0)
	move.b	#-1,objoff_2D(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjB0_MidWipe:
	tst.w	objoff_2A(a0)
	beq.s	loc_3A33A
	subq.w	#1,objoff_2A(a0)
	bsr.w	ObjB0_Move_Streaks_Left

loc_3A33A:
	lea	word_3A49E(pc),a1
	bsr.w	loc_3A44E
	bne.s	loc_3A346
	rts
; ===========================================================================

loc_3A346:
	addq.b	#2,routine(a0)
	bchg	#render_flags.x_flip,render_flags(a0)
	move.w	#$B,objoff_2A(a0)
	move.w	#4,(SegaScr_VInt_Subrout).w
	subi.w	#$28,x_pos(a0)
	bchg	#render_flags.x_flip,render_flags(a0)
	bchg	#status.npc.x_flip,status(a0)

    if fixBugs
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len
    else
	; This clears a lot more than the horizontal scroll buffer, which is $400 bytes.
	; This is because the loop counter is erroneously set to $400, instead of ($400/4)-1.
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+(HorizontalScrollBuffer.len*4+4)
    endif

	; Initialize streak horizontal offsets for Sonic going right.
	; 9 full lines (8 pixels) + 7 pixels, 2-byte interleaved entries for PNT A and PNT B
	lea	(Horiz_Scroll_Buf + 2 * 2 * (9 * 8 + 7)).w,a1
	lea	Streak_Horizontal_offsets(pc),a2
	moveq	#0,d0
	moveq	#35-1,d6	; Number of streaks-1

loc_3A38A:
	move.b	(a2)+,d0
	sub.w	d0,(a1)
	addq.w	#2 * 2 * 2,a1	; Advance to next streak 2 pixels down
	dbf	d6,loc_3A38A
	rts
; ===========================================================================

ObjB0_RunRight:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3A3B4
	addi.w	#$20,x_pos(a0)
	bsr.w	ObjB0_Move_Streaks_Right
	lea	(Ani_objB0).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3A3B4:
	addq.b	#2,routine(a0)
	move.w	#$C,objoff_2A(a0)
	move.b	#1,objoff_2C(a0)
	move.b	#-1,objoff_2D(a0)
	rts
; ===========================================================================

ObjB0_EndWipe:
	tst.w	objoff_2A(a0)
	beq.s	loc_3A3DA
	subq.w	#1,objoff_2A(a0)
	bsr.w	ObjB0_Move_Streaks_Right

loc_3A3DA:
	lea	word_3A514(pc),a1
	bsr.w	loc_3A44E
	bne.s	loc_3A3E6
	rts
; ===========================================================================

loc_3A3E6:
	addq.b	#2,routine(a0)
	st.b	(SegaScr_PalDone_Flag).w
	move.b	#SndID_SegaSound,d0
	jsrto	JmpTo12_PlaySound

return_3A3F6:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B1 - Object that hides TM symbol on JP region
; ----------------------------------------------------------------------------
; Sprite_3A3F8:
ObjB1:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB1_Index(pc,d0.w),d1
	jmp	ObjB1_Index(pc,d1.w)
; ===========================================================================
; off_3A406:
ObjB1_Index:	offsetTable
		offsetTableEntry.w ObjB1_Init	; 0
		offsetTableEntry.w ObjB1_Main	; 2
; ===========================================================================
; loc_3A40A:
ObjB1_Init:
	bsr.w	LoadSubObject
	move.b	#4,mapping_frame(a0)
	move.w	#spriteScreenPositionXCentered(84),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(-24),y_pixel(a0)
	rts
; ===========================================================================
; BranchTo4_JmpTo45_DisplaySprite
ObjB1_Main:
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjB0_Move_Streaks_Left:
	; 9 full lines (8 pixels) + 6 pixels, 2-byte interleaved entries for PNT A and PNT B
	lea	(Horiz_Scroll_Buf + 2 * 2 * (9 * 8 + 6)).w,a1

	move.w	#35-1,d6	; Number of streaks-1
-	subi.w	#$20,(a1)
	addq.w	#2 * 2 * 2,a1	; Advance to next streak 2 pixels down
	dbf	d6,-
	rts
; ===========================================================================

ObjB0_Move_Streaks_Right:
	; 9 full lines (8 pixels) + 7 pixels, 2-byte interleaved entries for PNT A and PNT B
	lea	(Horiz_Scroll_Buf + 2 * 2 * (9 * 8 + 7)).w,a1

	move.w	#35-1,d6	; Number of streaks-1
-	addi.w	#$20,(a1)
	addq.w	#2 * 2 * 2,a1	; Advance to next streak 2 pixels down
	dbf	d6,-
	rts
; ===========================================================================

loc_3A44E:
	subq.b	#1,objoff_2C(a0)
	bne.s	loc_3A496
	moveq	#0,d0
	move.b	objoff_2D(a0),d0
	addq.b	#1,d0
	cmp.b	1(a1),d0
	blo.s	loc_3A468
	tst.b	3(a1)
	bne.s	loc_3A49A

loc_3A468:
	move.b	d0,objoff_2D(a0)
	_move.b	0(a1),objoff_2C(a0)
	lea	6(a1),a2		; This loads a palette: Sega Screen 2.bin or Sega Screen 3.bin
	moveq	#0,d1
	move.b	2(a1),d1
	move.w	d1,d2
	tst.w	d0
	beq.s	loc_3A48C

loc_3A482:
	subq.b	#1,d0
	beq.s	loc_3A48A
	add.w	d2,d1
	bra.s	loc_3A482
; ===========================================================================

loc_3A48A:
	adda.w	d1,a2

loc_3A48C:
	movea.w	4(a1),a3

loc_3A490:
	move.w	(a2)+,(a3)+
	subq.w	#2,d2
	bne.s	loc_3A490

loc_3A496:
	moveq	#0,d0
	rts
; ===========================================================================

loc_3A49A:
	moveq	#1,d0
	rts
; ===========================================================================

; probably some sort of description of how to use the following palette
word_3A49E:
	dc.b   4		; 0	; How many frames before each iteration
	dc.b   7		; 1	; How many iterations
	dc.b $10		; 2	; Number of colors * 2 to skip each iteration
	dc.b $FF		; 3	; Some sort of flag
	dc.w Normal_palette+$10	; 4	; First target palette entry

; Palette for the SEGA screen (background and pre-wipe foreground) (7 frames)
;pal_3A4A4:
	BINCLUDE	"art/palettes/Sega Screen 2.bin"


; probably some sort of description of how to use the following palette
word_3A514:
	dc.b   4		; 0	; How many frames before each iteration
	dc.b   7		; 1	; How many iterations
	dc.b $10		; 2	; Number of colors * 2 to skip each iteration
	dc.b $FF		; 3	; Some sort of flag
	dc.w Normal_palette	; 4	; First target palette entry

; Palette for the SEGA screen (wiping and post-wipe foreground) (7 frames)
;pal_3A51A:
	BINCLUDE	"art/palettes/Sega Screen 3.bin"

; off_3A58A:
ObjB0_SubObjData:
	subObjData ObjB1_MapUnc_3A5A6,make_art_tile(ArtTile_ArtUnc_Giant_Sonic,2,1),0,1,$10,0

; off_3A594:
ObjB1_SubObjData:
	subObjData ObjB1_MapUnc_3A5A6,make_art_tile(ArtTile_ArtNem_Sega_Logo+2,0,0),0,2,8,0

; animation script
; off_3A59E:
Ani_objB0:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   0,  0,  1,  2,  3,$FF
		even

; ------------------------------------------------------------------------------
; sprite mappings
; Gigantic Sonic (2x size) mappings for the SEGA screen
; also has the "trademark hider" mappings
; ------------------------------------------------------------------------------
ObjB1_MapUnc_3A5A6:	include "mappings/sprite/objB1.asm"
; ===========================================================================
;loc_3A68A
SegaScr_VInt:
	move.w	(SegaScr_VInt_Subrout).w,d0
	beq.w	return_37A48
	clr.w	(SegaScr_VInt_Subrout).w
	move.w	off_3A69E-2(pc,d0.w),d0
	jmp	off_3A69E(pc,d0.w)
; ===========================================================================
off_3A69E:	offsetTable
		offsetTableEntry.w loc_3A6A2	; 0
		offsetTableEntry.w loc_3A6D4	; 2
; ===========================================================================

loc_3A6A2:
	dma68kToVDP SegaScreenScaledSpriteDataStart,tiles_to_bytes(ArtTile_ArtUnc_Giant_Sonic),\
	            SegaScreenScaledSpriteDataEnd-SegaScreenScaledSpriteDataStart,VRAM

	lea	ObjB1_Streak_fade_to_right(pc),a1
	; 9 full lines ($100 bytes each) plus $28 8-pixel cells
	move.l	#vdpComm(VRAM_SegaScr_Plane_A_Name_Table + planeLoc(128,40,9),VRAM,WRITE),d0	; $49500003
	bra.w	loc_3A710
; ===========================================================================

loc_3A6D4:
	dmaFillVRAM 0,VRAM_SegaScr_Plane_A_Name_Table,VRAM_SegaScr_Plane_Table_Size ; clear Plane A pattern name table

	lea	ObjB1_Streak_fade_to_left(pc),a1
	; $49A00003; 9 full lines ($100 bytes each) plus $50 8-pixel cells
	move.l	#vdpComm(VRAM_SegaScr_Plane_A_Name_Table + planeLoc(128,80,9),VRAM,WRITE),d0
	bra.w	loc_3A710
loc_3A710:
	lea	(VDP_data_port).l,a6
	; This is the line delta; for each line, the code below
	; writes $30 entries, leaving $50 untouched.
	move.l	#vdpCommDelta(planeLoc(128,0,1)),d6	; $1000000
	moveq	#7,d1	; Inner loop: repeat 8 times
	moveq	#9,d2	; Outer loop: repeat $A times
-
	move.l	d0,4(a6)	; Send command to VDP: set address to write to
	move.w	d1,d3		; Reset inner loop counter
	movea.l	a1,a2		; Reset data pointer
-
	move.w	(a2)+,d4	; Read one pattern name table entry
	bclr	#$A,d4		; Test bit $A and clear (flag for end of line)
	beq.s	+			; Branch if bit was clear
	bsr.w	loc_3A742	; Fill rest of line with this set of pixels
+
	move.w	d4,(a6)		; Write PNT entry
	dbf	d3,-
	add.l	d6,d0		; Point to the next VRAM area to be written to
	dbf	d2,--
	rts
; ===========================================================================

loc_3A742:
	moveq	#$28,d5		; Fill next $29 entries...
-
	move.w	d4,(a6)		; ...using the PNT entry that had bit $A set
	dbf	d5,-
	rts
; ===========================================================================
; Pattern A name table entries, with special flag detailed below
; These are used for the streaks, and point to VRAM in the $1000-$10FF range
ObjB1_Streak_fade_to_right:
	dc.w make_block_tile(ArtTile_ArtNem_Trails+0,0,0,1,1)	; 0
	dc.w make_block_tile(ArtTile_ArtNem_Trails+1,0,0,1,1)	; 2
	dc.w make_block_tile(ArtTile_ArtNem_Trails+2,0,0,1,1)	; 4
	dc.w make_block_tile(ArtTile_ArtNem_Trails+3,0,0,1,1)	; 6
	dc.w make_block_tile(ArtTile_ArtNem_Trails+4,0,0,1,1)	; 8
	dc.w make_block_tile(ArtTile_ArtNem_Trails+5,0,0,1,1)	; 10
	dc.w make_block_tile(ArtTile_ArtNem_Trails+6,0,0,1,1)	; 12
	dc.w make_block_tile(ArtTile_ArtNem_Trails+7,0,0,1,1) | (1 << $A)	; 14	; Bit $A is used as a flag to use this tile $29 times
ObjB1_Streak_fade_to_left:
	dc.w make_block_tile(ArtTile_ArtNem_Trails+7,0,0,1,1) | (1 << $A)	;  0	; Bit $A is used as a flag to use this tile $29 times
	dc.w make_block_tile(ArtTile_ArtNem_Trails+6,0,0,1,1)	; 2
	dc.w make_block_tile(ArtTile_ArtNem_Trails+5,0,0,1,1)	; 4
	dc.w make_block_tile(ArtTile_ArtNem_Trails+4,0,0,1,1)	; 6
	dc.w make_block_tile(ArtTile_ArtNem_Trails+3,0,0,1,1)	; 8
	dc.w make_block_tile(ArtTile_ArtNem_Trails+2,0,0,1,1)	; 10
	dc.w make_block_tile(ArtTile_ArtNem_Trails+1,0,0,1,1)	; 12
	dc.w make_block_tile(ArtTile_ArtNem_Trails+0,0,0,1,1)	; 14
Streak_Horizontal_offsets:
	dc.b $12
	dc.b   4	; 1
	dc.b   4	; 2
	dc.b   2	; 3
	dc.b   2	; 4
	dc.b   2	; 5
	dc.b   2	; 6
	dc.b   0	; 7
	dc.b   0	; 8
	dc.b   0	; 9
	dc.b   0	; 10
	dc.b   0	; 11
	dc.b   0	; 12
	dc.b   0	; 13
	dc.b   0	; 14
	dc.b   4	; 15
	dc.b   4	; 16
	dc.b   6	; 17
	dc.b  $A	; 18
	dc.b   8	; 19
	dc.b   6	; 20
	dc.b   4	; 21
	dc.b   4	; 22
	dc.b   4	; 23
	dc.b   4	; 24
	dc.b   6	; 25
	dc.b   6	; 26
	dc.b   8	; 27
	dc.b   8	; 28
	dc.b  $A	; 29
	dc.b  $A	; 30
	dc.b  $C	; 31
	dc.b  $E	; 32
	dc.b $10	; 33
	dc.b $16	; 34
	dc.b   0	; 35
	even




; ===========================================================================
; ----------------------------------------------------------------------------
; Object B2 - The Tornado (Tails' plane)
; ----------------------------------------------------------------------------
; Sprite_3A790:
ObjB2:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB2_Index(pc,d0.w),d1
	jmp	ObjB2_Index(pc,d1.w)
; ===========================================================================
; off_3A79E:
ObjB2_Index:	offsetTable
		offsetTableEntry.w ObjB2_Init	;  0
		offsetTableEntry.w ObjB2_Main_SCZ	;  2
		offsetTableEntry.w ObjB2_Main_WFZ_Start	;  4
		offsetTableEntry.w ObjB2_Main_WFZ_End	;  6
		offsetTableEntry.w ObjB2_Invisible_grabber	;  8
		offsetTableEntry.w loc_3AD0C	; $A
		offsetTableEntry.w loc_3AD2A	; $C
		offsetTableEntry.w loc_3AD42	; $E
; ===========================================================================
; loc_3A7AE:
ObjB2_Init:
	bsr.w	LoadSubObject
	moveq	#0,d0
	move.b	subtype(a0),d0
	subi.b	#$4E,d0
	move.b	d0,routine(a0)
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	cmpi.b	#8,d0
	bhs.s	+
	move.b	#4,mapping_frame(a0)
	move.b	#1,anim(a0)
+ ; BranchTo5_JmpTo45_DisplaySprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3A7DE:
ObjB2_Main_SCZ:
	bsr.w	ObjB2_Animate_Pilot
	tst.w	(Debug_placement_mode).w
	bne.w	ObjB2_animate
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	art_tile(a1),d0
	andi.w	#high_priority,d0
	move.w	art_tile(a0),d1
	andi.w	#drawing_mask,d1
	or.w	d0,d1
	move.w	d1,art_tile(a0)
	move.w	x_pos(a0),-(sp)
	bsr.w	ObjB2_Move_with_player
	move.b	status(a0),objoff_2E(a0)
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jsrto	JmpTo27_SolidObject
	bsr.w	ObjB2_Move_obbey_player
	move.b	objoff_2E(a0),d0
	move.b	status(a0),d1
	andi.b	#p1_standing,d0	; 'on object' bit
	andi.b	#p1_standing,d1	; 'on object' bit
	eor.b	d0,d1
	move.b	d1,objoff_2E(a0)
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),d1
	move.w	(Camera_X_pos).w,d0
	move.w	d0,(Camera_Min_X_pos).w
	move.w	d0,d2
	addi.w	#$11,d2
	cmp.w	d2,d1
	bhi.s	+
	addq.w	#1,d1
	move.w	d1,x_pos(a1)
+ ; loc_3A85E:
	cmpi.w	#$1400,d0
	blo.s	loc_3A878
	cmpi.w	#$1568,d1
	bhs.s	ObjB2_SCZ_Finished
	st.b	(Control_Locked).w
	move.w	#(button_right_mask<<8)|button_right_mask,(Ctrl_1_Logical).w
	bra.w	loc_3A87C
; ===========================================================================

loc_3A878:
	subi.w	#$40,d0

loc_3A87C:
	move.w	d0,(Camera_Max_X_pos).w
; loc_3A880:
ObjB2_animate:
	lea	(Ani_objB2_a).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3A88E:
ObjB2_SCZ_Finished:
	bsr.w	ObjB2_Deactivate_level
	move.w	#wing_fortress_zone_act_1,(Current_ZoneAndAct).w
	bra.s	ObjB2_animate
; ===========================================================================
; loc_3A89A:
ObjB2_Main_WFZ_Start:
	bsr.w	ObjB2_Animate_Pilot
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3A8BA(pc,d0.w),d1
	jsr	off_3A8BA(pc,d1.w)
	lea	(Ani_objB2_a).l,a1
	jsrto	JmpTo25_AnimateSprite
	bra.w	Obj_DeleteOffScreen
; ===========================================================================
off_3A8BA:	offsetTable
		offsetTableEntry.w ObjB2_Main_WFZ_Start_init	; 0
		offsetTableEntry.w ObjB2_Main_WFZ_Start_main	; 2
		offsetTableEntry.w ObjB2_Main_WFZ_Start_shot_down	; 4
		offsetTableEntry.w ObjB2_Main_WFZ_Start_fall_down	; 6
; ===========================================================================
; loc_3A8C2:
ObjB2_Main_WFZ_Start_init:
	addq.b	#2,routine_secondary(a0)
	move.w	#$C0,objoff_32(a0)
	move.w	#$100,x_vel(a0)
	rts
; ===========================================================================
; loc_3A8D4:
ObjB2_Main_WFZ_Start_main:
	subq.w	#1,objoff_32(a0)
	bmi.s	+
	move.w	x_pos(a0),-(sp)
	jsrto	JmpTo26_ObjectMove
	bsr.w	loc_36776
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jsrto	JmpTo27_SolidObject
	bra.w	ObjB2_Horizontal_limit
; ===========================================================================
+ ; loc_3A8FC:
	addq.b	#2,routine_secondary(a0)
	move.w	#$60,objoff_2A(a0)
	move.w	#1,objoff_32(a0)
	move.w	#$100,x_vel(a0)
	move.w	#$100,y_vel(a0)
	rts
; ===========================================================================
; loc_3A91A:
ObjB2_Main_WFZ_Start_shot_down:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+
	moveq	#signextendB(SndID_Scatter),d0
	jsrto	JmpTo12_PlaySound
+ ; loc_3A92A:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
- ; loc_3A930:
	bsr.w	ObjB2_Align_plane
	subq.w	#1,objoff_32(a0)
	bne.w	return_37A48
	move.w	#$E,objoff_32(a0)
	bra.w	ObjB2_Main_WFZ_Start_load_smoke
; ===========================================================================
+ ; loc_3A946:
	addq.b	#2,routine_secondary(a0)
	bra.w	loc_3B7BC
; ===========================================================================
; loc_3A94E:
ObjB2_Main_WFZ_Start_fall_down:
	jsrto	JmpTo26_ObjectMove
	bra.s	-
; ===========================================================================
; loc_3A954:
ObjB2_Main_WFZ_End:
	bsr.w	ObjB2_Animate_Pilot
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjB2_Main_WFZ_states(pc,d0.w),d1
	jsr	ObjB2_Main_WFZ_states(pc,d1.w)
	lea	(Ani_objB2_a).l,a1
	jmpto	JmpTo25_AnimateSprite
; ===========================================================================
; off_3A970:
ObjB2_Main_WFZ_states:	offsetTable
		offsetTableEntry.w ObjB2_Wait_Leader_position	;   0
		offsetTableEntry.w ObjB2_Move_Leader_edge	;   2
		offsetTableEntry.w ObjB2_Wait_for_plane	;   4
		offsetTableEntry.w ObjB2_Prepare_to_jump	;   6
		offsetTableEntry.w ObjB2_Jump_to_plane	;   8
		offsetTableEntry.w ObjB2_Landed_on_plane	;  $A
		offsetTableEntry.w ObjB2_Approaching_ship	;  $C
		offsetTableEntry.w ObjB2_Jump_to_ship	;  $E
		offsetTableEntry.w ObjB2_Dock_on_DEZ	; $10
; ===========================================================================
; loc_3A982:
ObjB2_Wait_Leader_position:
	lea	(MainCharacter).w,a1 ; a1=character
	cmpi.w	#$5EC,y_pos(a1)
	blo.s	+	; rts
	clr.w	(Ctrl_1_Logical).w
	addq.w	#1,objoff_2E(a0)
	cmpi.w	#$40,objoff_2E(a0)
	bhs.s	++
+ ; return_3A99E:
	rts
; ===========================================================================
+ ; loc_3A9A0:
	addq.b	#2,routine_secondary(a0)
	move.w	#$2E58,x_pos(a0)
	move.w	#$66C,y_pos(a0)
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.w	ObjB2_Waiting_animation
	lea	(ChildObject_3AFBC).l,a2
	bsr.w	LoadChildObject
	move.w	#$3118,x_pos(a1)
	move.w	#$3F0,y_pos(a1)
	lea	(ChildObject_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$3070,x_pos(a1)
	move.w	#$3B0,y_pos(a1)
	lea	(ChildObject_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$3070,x_pos(a1)
	move.w	#$430,y_pos(a1)
	lea	(ChildObject_3AFC0).l,a2
	bsr.w	LoadChildObject
	clr.w	x_pos(a1)
	clr.w	y_pos(a1)
	rts
; ===========================================================================
; loc_3AA0E: ObjB2_Move_Leader_egde:
ObjB2_Move_Leader_edge:
	lea	(MainCharacter).w,a1 ; a1=character
	cmpi.w	#$2E30,x_pos(a1)
	bhs.s	+
	move.w	#(button_right_mask<<8)|button_right_mask,(Ctrl_1_Logical).w
	rts
; ===========================================================================
+ ; loc_3AA22:
	addq.b	#2,routine_secondary(a0)
	clr.w	(Ctrl_1_Logical).w
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	clr.w	inertia(a1)
	move.w	#$600,(Sonic_top_speed).w
	move.w	#$C,(Sonic_acceleration).w
	move.w	#$80,(Sonic_deceleration).w
	bra.w	ObjB2_Waiting_animation
; ===========================================================================
; loc_3AA4C:
ObjB2_Wait_for_plane:
	cmpi.w	#$380,(Camera_BG_X_offset).w
	bhs.s	+
	clr.w	(Ctrl_1_Logical).w
	bra.w	ObjB2_Waiting_animation
; ===========================================================================
+ ; loc_3AA5C:
	addq.b	#2,routine_secondary(a0)
	move.w	#$100,x_vel(a0)
	move.w	#-$100,y_vel(a0)
	clr.w	objoff_2A(a0)
	bra.w	ObjB2_Waiting_animation
; ===========================================================================
; loc_3AA74:
ObjB2_Prepare_to_jump:
	bsr.w	ObjB2_Waiting_animation
	addq.w	#1,objoff_2A(a0)
	cmpi.w	#$30,objoff_2A(a0)
	bne.s	+
	addq.b	#2,routine_secondary(a0)
	move.w	#(button_A_mask<<8)|button_A_mask,(Ctrl_1_Logical).w
	move.w	#$38,objoff_2E(a0)
	tst.b	(Super_Sonic_flag).w
	beq.s	+
	move.w	#$28,objoff_2E(a0)
+ ; loc_3AAA0:
	bsr.w	ObjB2_Align_plane
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3AAA8:
ObjB2_Jump_to_plane:
	clr.w	(Ctrl_1_Logical).w
	addq.w	#1,objoff_2A(a0)
	subq.w	#1,objoff_2E(a0)
	bmi.s	+
	move.w	#((button_right_mask|button_A_mask)<<8)|button_right_mask|button_A_mask,(Ctrl_1_Logical).w
+ ; loc_3AABC:
	bsr.w	ObjB2_Align_plane
	btst	#p1_standing_bit,status(a0)
	beq.s	+
	addq.b	#2,routine_secondary(a0)
	move.w	#$20,objoff_2E(a0)
	lea	(Level_Layout+$0D2).w,a1
	move.l	#$501F0025,(a1)+
	lea	(Level_Layout+$1D2).w,a1
	move.l	#$25001F50,(a1)+
	lea	(Level_Layout+$BD6).w,a1
	move.l	#$501F0025,(a1)+
	lea	(Level_Layout+$CD6).w,a1
	move.l	#$25001F50,(a1)+
+ ; BranchTo6_JmpTo45_DisplaySprite:
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3AAFE:
ObjB2_Landed_on_plane:
	addq.w	#1,objoff_2A(a0)
	cmpi.w	#$100,objoff_2A(a0)
	blo.s	loc_3AB18
	addq.b	#2,routine_secondary(a0)
	movea.w	objoff_3A(a0),a1 ; a1=object??
	move.b	#2,routine_secondary(a1)

loc_3AB18:
	clr.w	(Ctrl_1_Logical).w
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a0),x_pos(a1)
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	clr.w	inertia(a1)
	bclr	#status.player.in_air,status(a1)
	bclr	#status.player.rolling,status(a1)
	move.l	#(1<<24)|(0<<16)|(AniIDSonAni_Wait<<8)|(AniIDSonAni_Wait<<0),mapping_frame(a1)
	move.w	#$100,anim_frame_duration(a1)
	move.b	#$13,y_radius(a1)
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	move.b	#$F,y_radius(a1)
+ ; loc_3AB60:
	bsr.w	ObjB2_Align_plane
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3AB68:
ObjB2_Approaching_ship:
	clr.w	(Ctrl_1_Logical).w
	bsr.w	ObjB2_Waiting_animation
	cmpi.w	#$437,objoff_2A(a0)
	blo.s	loc_3AB8A
	addq.b	#2,routine_secondary(a0)
; loc_3AB7C:
ObjB2_Jump_to_ship:
	cmpi.w	#$447,objoff_2A(a0)
	bhs.s	loc_3AB8A
	move.w	#(button_A_mask<<8)|button_A_mask,(Ctrl_1_Logical).w

loc_3AB8A:
	cmpi.w	#$460,objoff_2A(a0)
	blo.s	ObjB2_Dock_on_DEZ
	move.b	#6,(Dynamic_Resize_Routine).w ; => LevEvents_WFZ_Routine4
	addq.b	#2,routine_secondary(a0)
	lea	(ChildObject_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$3090,x_pos(a1)
	move.w	#$3D0,y_pos(a1)
	lea	(ChildObject_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$30C0,x_pos(a1)
	move.w	#$3F0,y_pos(a1)
	lea	(ChildObject_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$3090,x_pos(a1)
	move.w	#$410,y_pos(a1)
; loc_3ABDE:
ObjB2_Dock_on_DEZ:
	cmpi.w	#$9C0,objoff_2A(a0)
	bhs.s	ObjB2_Start_DEZ
	move.w	objoff_2A(a0),d0
	addq.w	#1,d0
	move.w	d0,objoff_2A(a0)
	move.w	objoff_34(a0),d1
	move.w	word_3AC16(pc,d1.w),d2
	cmp.w	d2,d0
	blo.s	loc_3AC0E
	addq.w	#2,d1
	move.w	d1,objoff_34(a0)
	lea	byte_3AC2A(pc,d1.w),a1
	move.b	(a1)+,x_vel(a0)
	move.b	(a1)+,y_vel(a0)

loc_3AC0E:
	bsr.w	ObjB2_Align_plane
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
word_3AC16:
	dc.w  $1E0
	dc.w  $260	; 1
	dc.w  $2A0	; 2
	dc.w  $2C0	; 3
	dc.w  $300	; 4
	dc.w  $3A0	; 5
	dc.w  $3F0	; 6
	dc.w  $460	; 7
	dc.w  $4A0	; 8
	dc.w  $580	; 9
byte_3AC2A:
	dc.b $FF
	dc.b $FF	; 1
	dc.b   1	; 2
	dc.b   0	; 3
	dc.b   0	; 4
	dc.b   1	; 5
	dc.b   1	; 6
	dc.b $FF	; 7
	dc.b   1	; 8
	dc.b   1	; 9
	dc.b   1	; 10
	dc.b $FF	; 11
	dc.b $FF	; 12
	dc.b   1	; 13
	dc.b $FF	; 14
	dc.b $FF	; 15
	dc.b $FF	; 16
	dc.b   1	; 17
	dc.b $FE	; 18
	dc.b   0	; 19
	dc.b   0	; 20
	dc.b   0	; 21
	even
; ===========================================================================
; loc_3AC40:
ObjB2_Start_DEZ:
	move.w	#death_egg_zone_act_1,(Current_ZoneAndAct).w
; loc_3AC46:
ObjB2_Deactivate_level:
	move.w	#1,(Level_Inactive_flag).w
	clr.b	(Last_star_pole_hit).w
	clr.b	(Last_star_pole_hit_2P).w
	rts
; ===========================================================================
; loc_3AC56:
ObjB2_Waiting_animation:
	lea	(MainCharacter).w,a1 ; a1=character
	move.l	#(1<<24)|(0<<16)|(AniIDSonAni_Wait<<8)|(AniIDSonAni_Wait<<0),mapping_frame(a1)
	move.w	#$100,anim_frame_duration(a1)
	rts
; ===========================================================================
; loc_3AC6A:
ObjB2_Invisible_grabber:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3AC78(pc,d0.w),d1
	jmp	off_3AC78(pc,d1.w)
; ===========================================================================
off_3AC78:	offsetTable
		offsetTableEntry.w loc_3AC7E	; 0
		offsetTableEntry.w loc_3AC84	; 2
		offsetTableEntry.w loc_3ACF2	; 4
; ===========================================================================

loc_3AC7E:
	move.b	#$C7,collision_flags(a0)

loc_3AC84:
	tst.b	collision_property(a0)
	beq.s	return_3ACF0
	addq.b	#2,routine_secondary(a0)
	clr.b	collision_flags(a0)
	move.w	#(screen_height/2)+8,(Camera_Y_pos_bias).w
	movea.w	objoff_2C(a0),a1 ; a1=object
	bset	#status.npc.p2_pushing,status(a1)
	lea	(MainCharacter).w,a1 ; a1=character
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	move.w	x_pos(a0),d0
	subi.w	#$10,d0
	move.w	d0,x_pos(a1)
	cmpi.w	#2,(Player_mode).w
	bne.s	loc_3ACC8
	subi.w	#$10,y_pos(a1)

loc_3ACC8:
	bset	#status.player.x_flip,status(a1)
	bclr	#status.player.in_air,status(a1)
	bclr	#status.player.rolling,status(a1)
	move.b	#AniIDSonAni_Hang,anim(a1)
	move.b	#1,(MainCharacter+obj_control).w
	move.b	#1,(WindTunnel_holding_flag).w
	clr.w	(Ctrl_1_Logical).w

return_3ACF0:
	rts
; ===========================================================================

loc_3ACF2:
	lea	(MainCharacter).w,a1 ; a1=character
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	move.w	x_pos(a0),d0
	subi.w	#$10,d0
	move.w	d0,x_pos(a1)
	rts
; ===========================================================================

loc_3AD0C:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3AD1A(pc,d0.w),d1
	jmp	off_3AD1A(pc,d1.w)
; ===========================================================================
off_3AD1A:	offsetTable
		offsetTableEntry.w +	; 0
; ===========================================================================
+ ; loc_3AD1C:
	bchg	#status.npc.misc,status(a0)
	bne.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3AD2A:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3AD38(pc,d0.w),d1
	jmp	off_3AD38(pc,d1.w)
; ===========================================================================
off_3AD38:	offsetTable
		offsetTableEntry.w +	; 0
; ===========================================================================
+ ; loc_3AD3A:
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3AD42:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3AD50(pc,d0.w),d1
	jmp	off_3AD50(pc,d1.w)
; ===========================================================================
off_3AD50:	offsetTable
		offsetTableEntry.w loc_3AD54	; 0
		offsetTableEntry.w loc_3AD5C	; 2
; ===========================================================================

loc_3AD54:
	bsr.w	loc_3AD6E
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3AD5C:
	bsr.w	loc_3AD6E
	lea	(Ani_objB2_b).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3AD6E:
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.w	x_pos(a1),d0
	subi.w	#$C,d0
	move.w	d0,x_pos(a0)
	move.w	y_pos(a1),d0
	addi.w	#$28,d0
	move.w	d0,y_pos(a0)
	rts
; ===========================================================================
; loc_3AD8C:
ObjB2_Align_plane:
	move.w	x_pos(a0),-(sp)
	jsrto	JmpTo26_ObjectMove
	bsr.w	loc_36776
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jmpto	JmpTo27_SolidObject
; ===========================================================================
; loc_3ADAA:
ObjB2_Move_with_player:
	lea	(MainCharacter).w,a1 ; a1=character
	btst	#status.player.on_object,status(a1)
	beq.s	ObjB2_Move_below_player
	bsr.w	ObjB2_Move_vert
	bsr.w	ObjB2_Vertical_limit
	jsrto	JmpTo26_ObjectMove
	bra.w	loc_36776
; ===========================================================================
; loc_3ADC6:
ObjB2_Move_below_player:
	tst.b	objoff_2E(a0)
	beq.s	loc_3ADD4
	bsr.w	Obj_GetOrientationToPlayer
	move.w	d2,objoff_38(a0)

loc_3ADD4:
	move.w	#1,d0
	move.w	objoff_38(a0),d3
	beq.s	loc_3ADE8
	bmi.s	loc_3ADE2
	neg.w	d0

loc_3ADE2:
	add.w	d0,d3
	move.w	d3,objoff_38(a0)

loc_3ADE8:
	move.w	x_pos(a1),d1
	add.w	d3,d1
	move.w	d1,x_pos(a0)
	bra.w	loc_36776
; ===========================================================================
; loc_3ADF6:
ObjB2_Move_vert:
	tst.b	objoff_2F(a0)
	bne.s	loc_3AE16
	tst.b	objoff_2E(a0)
	beq.s	return_3AE38
	st.b	objoff_2F(a0)
	clr.b	objoff_30(a0)
	move.w	#$200,y_vel(a0)
	move.b	#$14,objoff_31(a0)

loc_3AE16:
	subq.b	#1,objoff_31(a0)
	bpl.s	loc_3AE26
	clr.b	objoff_2F(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_3AE26:
	move.w	y_vel(a0),d0
	cmpi.w	#-$100,d0
	ble.s	loc_3AE34
	addi.w	#-$20,d0

loc_3AE34:
	move.w	d0,y_vel(a0)

return_3AE38:
	rts
; ===========================================================================
; loc_3AE3A:
ObjB2_Move_obbey_player:
	lea	(MainCharacter).w,a1 ; a1=character
	btst	#status.player.on_object,status(a1)
	beq.s	ObjB2_Move_vert2
	tst.b	objoff_2F(a0)
	bne.s	loc_3AE72
	clr.w	y_vel(a0)
	move.w	(Ctrl_1).w,d2
	move.w	#$80,d3
	andi.w	#(button_up_mask|button_down_mask)<<8,d2
	beq.s	loc_3AE72
	andi.w	#button_down_mask<<8,d2
	bne.s	loc_3AE66
	neg.w	d3

loc_3AE66:
	move.w	d3,y_vel(a0)
	bsr.w	ObjB2_Vertical_limit
	jsrto	JmpTo26_ObjectMove

loc_3AE72:
	bsr.w	Obj_GetOrientationToPlayer
	moveq	#$10,d3
	add.w	d3,d2
	cmpi.w	#$20,d2
	blo.s	return_3AE9E
	mvabs.w	inertia(a1),d2
	cmpi.w	#$900,d2
	bhs.s	return_3AE9E
	tst.w	d0
	beq.s	loc_3AE94
	neg.w	d3

loc_3AE94:
	move.w	x_pos(a1),d1
	add.w	d3,d1
	move.w	d1,x_pos(a0)

return_3AE9E:
	rts
; ===========================================================================
; loc_3AEA0:
ObjB2_Move_vert2:
	tst.b	objoff_30(a0)
	bne.s	loc_3AEC0
	tst.b	objoff_2E(a0)
	beq.s	return_3AE9E
	st.b	objoff_30(a0)
	clr.b	objoff_2F(a0)
	move.w	#$200,y_vel(a0)
	move.b	#$2B,objoff_31(a0)

loc_3AEC0:
	subq.b	#1,objoff_31(a0)
	bpl.s	loc_3AED0
	clr.b	objoff_30(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_3AED0:
	move.w	y_vel(a0),d0
	cmpi.w	#-$100,d0
	ble.s	loc_3AEDE
	addi.w	#-$20,d0

loc_3AEDE:
	move.w	d0,y_vel(a0)
	bsr.w	ObjB2_Vertical_limit
	jsrto	JmpTo26_ObjectMove
	rts
; ===========================================================================
; loc_3AEEC:
ObjB2_Horizontal_limit:
	bsr.w	Obj_GetOrientationToPlayer
	moveq	#$10,d3
	add.w	d3,d2
	cmpi.w	#$20,d2
	blo.s	return_3AF0A
	tst.w	d0
	beq.s	loc_3AF00
	neg.w	d3

loc_3AF00:
	move.w	x_pos(a0),d1
	sub.w	d3,d1
	move.w	d1,x_pos(a1)

return_3AF0A:
	rts
; ===========================================================================
; loc_3AF0C:
ObjB2_Vertical_limit:
	move.w	(Camera_Y_pos).w,d0
	move.w	y_pos(a0),d1
	move.w	y_vel(a0),d2
	beq.s	return_3AF32
	bpl.s	loc_3AF26
	addi.w	#$34,d0
	cmp.w	d0,d1
	blo.s	loc_3AF2E
	rts
; ===========================================================================

loc_3AF26:
	addi.w	#$A8,d0
	cmp.w	d0,d1
	blo.s	return_3AF32

loc_3AF2E:
	clr.w	y_vel(a0)

return_3AF32:
	rts
; ===========================================================================
; loc_3AF34:
ObjB2_Main_WFZ_Start_load_smoke:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	+
	_move.b	#ObjID_TornadoSmoke2,id(a1) ; load objC3
	move.b	#$90,subtype(a1) ; <== ObjC3_SubObjData
	move.w	a0,objoff_2C(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
+ ; return_3AF56:
	rts
; ===========================================================================
; loc_3AF58:
ObjB2_Animate_Pilot:
	subq.b	#1,objoff_37(a0)
	bmi.s	+
	rts
; ===========================================================================
+ ; loc_3AF60:
	move.b	#8,objoff_37(a0)
	moveq	#0,d0
	move.b	objoff_36(a0),d0
	moveq	#Tails_pilot_frames_end-Tails_pilot_frames,d1
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	moveq	#Sonic_pilot_frames_end-Sonic_pilot_frames,d1
+ ; loc_3AF78:
	addq.b	#1,d0
	cmp.w	d1,d0
	blo.s	+
	moveq	#0,d0
+ ; loc_3AF80:
	move.b	d0,objoff_36(a0)
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	move.b	Sonic_pilot_frames(pc,d0.w),d0
	jmpto	JmpTo_LoadSonicDynPLC_Part2
; ===========================================================================
+ ; loc_3AF94:
	move.b	Tails_pilot_frames(pc,d0.w),d0
	jmpto	JmpTo_LoadTailsDynPLC_Part2
; ===========================================================================
; byte_3AF9C:
Sonic_pilot_frames:
	dc.b $2D
	dc.b $2E	; 1
	dc.b $2F	; 2
	dc.b $30	; 3
Sonic_pilot_frames_end:

; byte_3AFA0:
Tails_pilot_frames:
	dc.b $10
	dc.b $10	; 1
	dc.b $10	; 2
	dc.b $10	; 3
	dc.b   1	; 4
	dc.b   2	; 5
	dc.b   3	; 6
	dc.b   2	; 7
	dc.b   1	; 8
	dc.b   1	; 9
	dc.b $10	; 10
	dc.b $10	; 11
	dc.b $10	; 12
	dc.b $10	; 13
	dc.b   1	; 14
	dc.b   2	; 15
	dc.b   3	; 16
	dc.b   2	; 17
	dc.b   1	; 18
	dc.b   1	; 19
	dc.b   4	; 20
	dc.b   4	; 21
	dc.b   1	; 22
	dc.b   1	; 23
Tails_pilot_frames_end:
	even

ChildObject_3AFB8:	childObjectData objoff_3E, ObjID_Tornado, $58
ChildObject_3AFBC:	childObjectData objoff_3C, ObjID_Tornado, $56
ChildObject_3AFC0:	childObjectData objoff_3A, ObjID_Tornado, $5C
			childObjectData objoff_3E, ObjID_Tornado, $5A	; seems unused
; off_3AFC8:
ObjB2_SubObjData:
	subObjData ObjB2_MapUnc_3AFF2,make_art_tile(ArtTile_ArtNem_Tornado,0,1),1<<render_flags.level_fg,4,$60,0
; off_3AFD2:
ObjB2_SubObjData2:
	subObjData ObjB2_MapUnc_3B292,make_art_tile(ArtTile_ArtNem_TornadoThruster,0,0),1<<render_flags.level_fg,3,$40,0
; animation script
; off_3AFDC:
Ani_objB2_a:	offsetTable
		offsetTableEntry.w byte_3AFE0	; 0
		offsetTableEntry.w byte_3AFE6	; 1
byte_3AFE0:	dc.b   0,  0,  1,  2,  3,$FF
byte_3AFE6:	dc.b   0,  4,  5,  6,  7,$FF
		even
; animation script
; off_3AFEC:
Ani_objB2_b:	offsetTable
		offsetTableEntry.w +	; 0
; byte_3AFEE:
+		dc.b   0,  1,  2,$FF
		even
; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjB2_MapUnc_3AFF2:	include "mappings/sprite/objB2_a.asm"
; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjB2_MapUnc_3B292:	include "mappings/sprite/objB2_b.asm"


; ===========================================================================
; ----------------------------------------------------------------------------
; Object B3 - Clouds (placeable object) from SCZ
; ----------------------------------------------------------------------------
; Sprite_3B2DE:
ObjB3:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB3_Index(pc,d0.w),d1
	jmp	ObjB3_Index(pc,d1.w)
; ===========================================================================
; off_3B2EC:
ObjB3_Index:	offsetTable
		offsetTableEntry.w ObjB3_Init	; 0
		offsetTableEntry.w ObjB3_Main	; 2
; ===========================================================================
; loc_3B2F0:
ObjB3_Init:
	bsr.w	LoadSubObject
	moveq	#0,d0
	move.b	subtype(a0),d0
	subi.b	#$5E,d0
	move.w	word_3B30C(pc,d0.w),x_vel(a0)
	lsr.w	#1,d0
	move.b	d0,mapping_frame(a0)
	rts
; ===========================================================================
word_3B30C:
	dc.w  -$80
	dc.w  -$40	; 1
	dc.w  -$20	; 2
; ===========================================================================
; loc_3B312:
ObjB3_Main:
	jsrto	JmpTo26_ObjectMove
	move.w	(Tornado_Velocity_X).w,d0
	add.w	d0,x_pos(a0)
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================
; off_3B322:
ObjB3_SubObjData:
	subObjData ObjB3_MapUnc_3B32C,make_art_tile(ArtTile_ArtNem_Clouds,2,0),1<<render_flags.level_fg,6,$30,0

; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjB3_MapUnc_3B32C:	include "mappings/sprite/objB3.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object B4 - Vertical propeller from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B36A:
ObjB4:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB4_Index(pc,d0.w),d1
	jmp	ObjB4_Index(pc,d1.w)
; ===========================================================================
; off_3B378:
ObjB4_Index:	offsetTable
		offsetTableEntry.w ObjB4_Init	; 0
		offsetTableEntry.w ObjB4_Main	; 2
; ===========================================================================
; loc_3B37C:
ObjB4_Init:
	bsr.w	LoadSubObject
	bclr	#render_flags.y_flip,render_flags(a0)
	beq.s	+
	clr.b	collision_flags(a0)
+
	rts
; ===========================================================================
; loc_3B38E:
ObjB4_Main:
	lea	(Ani_objB4).l,a1
	jsrto	JmpTo25_AnimateSprite
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+
	moveq	#signextendB(SndID_Helicopter),d0
	jsrto	JmpTo_PlaySoundLocal
+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3B3AC:
ObjB4_SubObjData:
	subObjData ObjB4_MapUnc_3B3BE,make_art_tile(ArtTile_ArtNem_WfzVrtclPrpllr,1,1),1<<render_flags.level_fg,4,4,$A8
; animation script
; off_3B3B6:
Ani_objB4:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,$FF,  0
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB4_MapUnc_3B3BE:	include "mappings/sprite/objB4.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B5 - Horizontal propeller from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B3FA:
ObjB5:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB5_Index(pc,d0.w),d1
	jmp	ObjB5_Index(pc,d1.w)
; ===========================================================================
; off_3B408:
ObjB5_Index:	offsetTable
		offsetTableEntry.w ObjB5_Init		; 0
		offsetTableEntry.w ObjB5_Main		; 2 - used in WFZ
		offsetTableEntry.w ObjB5_Animate	; 4 - used in SCZ, no effect on players
; ===========================================================================
; loc_3B40E:
ObjB5_Init:
	bsr.w	LoadSubObject
	move.b	#4,anim(a0)
	move.b	subtype(a0),d0
	subi.b	#$64,d0
	move.b	d0,routine(a0)
	rts
; ===========================================================================
; loc_3B426:
ObjB5_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B442(pc,d0.w),d1
	jsr	off_3B442(pc,d1.w)
	lea	(Ani_objB5).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3B442:	offsetTable
		offsetTableEntry.w +	; 0
; ===========================================================================
+	bra.w	ObjB5_CheckPlayers
; ===========================================================================
; loc_3B448:
ObjB5_Animate:
	lea	(Ani_objB5).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; loc_3B456:
ObjB5_CheckPlayers:
	cmpi.b	#4,anim(a0)
	bne.s	++	; rts
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.w	ObjB5_CheckPlayer
	lea	(Sidekick).w,a1 ; a1=character
; loc_3B46A:
ObjB5_CheckPlayer:
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$40,d0
	cmpi.w	#$80,d0
	bhs.s	++	; rts
	moveq	#0,d1
	move.b	(Oscillating_Data+$14).w,d1
	add.w	y_pos(a1),d1
	addi.w	#$60,d1
	sub.w	y_pos(a0),d1
	bcs.s	++	; rts
	cmpi.w	#$90,d1
	bhs.s	++	; rts
	subi.w	#$60,d1
	bcs.s	+
	not.w	d1
	add.w	d1,d1
+
	addi.w	#$60,d1
	neg.w	d1
	asr.w	#4,d1
	add.w	d1,y_pos(a1)
	bset	#status.player.in_air,status(a1)
	move.w	#0,y_vel(a1)
	move.w	#1,inertia(a1)
	tst.b	flip_angle(a1)
	bne.s	+	; rts
	move.b	#1,flip_angle(a1)
	move.b	#AniIDSonAni_Float2,anim(a1)
	move.b	#$7F,flips_remaining(a1)
	move.b	#8,flip_speed(a1)
+
	rts
; ===========================================================================
; off_3B4DE:
ObjB5_SubObjData:
	subObjData ObjB5_MapUnc_3B548,make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1),1<<render_flags.level_fg,4,$40,0

; animation script
; off_3B4E8:
Ani_objB5:	offsetTable
		offsetTableEntry.w byte_3B4FC	; 0
		offsetTableEntry.w byte_3B506	; 1
		offsetTableEntry.w byte_3B50E	; 2
		offsetTableEntry.w byte_3B516	; 3
		offsetTableEntry.w byte_3B51C	; 4
		offsetTableEntry.w byte_3B524	; 5
		offsetTableEntry.w byte_3B52A	; 6
		offsetTableEntry.w byte_3B532	; 7
		offsetTableEntry.w byte_3B53A	; 8
		offsetTableEntry.w byte_3B544	; 9
byte_3B4FC:	dc.b   7,  0,  1,  2,  3,  4,  5,$FD,  1,  0
byte_3B506:	dc.b   4,  0,  1,  2,  3,  4,$FD,  2
byte_3B50E:	dc.b   3,  5,  0,  1,  2,$FD,  3,  0
byte_3B516:	dc.b   2,  3,  4,  5,$FD,  4
byte_3B51C:	dc.b   1,  0,  1,  2,  3,  4,  5,$FF
byte_3B524:	dc.b   2,  5,  4,  3,$FD,  6
byte_3B52A:	dc.b   3,  2,  1,  0,  5,$FD,  7,  0
byte_3B532:	dc.b   4,  4,  3,  2,  1,  0,$FD,  8
byte_3B53A:	dc.b   7,  5,  4,  3,  2,  1,  0,$FD,  9,  0
byte_3B544:	dc.b $7E,  0,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB5_MapUnc_3B548:	include "mappings/sprite/objB5.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B6 - Tilting platform from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B5D0:
ObjB6:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB6_Index(pc,d0.w),d1
	jmp	ObjB6_Index(pc,d1.w)
; ===========================================================================
; off_3B5DE:
ObjB6_Index:	offsetTable
		offsetTableEntry.w ObjB6_Init	; 0
		offsetTableEntry.w loc_3B602	; 2
		offsetTableEntry.w loc_3B65C	; 4
		offsetTableEntry.w loc_3B6C8	; 6
		offsetTableEntry.w loc_3B73C	; 8
; ===========================================================================
; loc_3B5E8:
ObjB6_Init:
	moveq	#0,d0
	move.b	#($35<<1),d0
	bsr.w	LoadSubObject_Part2
	move.b	subtype(a0),d0
	andi.b	#6,d0
	addq.b	#2,d0
	move.b	d0,routine(a0)
	rts
; ===========================================================================

loc_3B602:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B614(pc,d0.w),d1
	jsr	off_3B614(pc,d1.w)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3B614:	offsetTable
		offsetTableEntry.w loc_3B61C	; 0
		offsetTableEntry.w loc_3B624	; 2
		offsetTableEntry.w loc_3B644	; 4
		offsetTableEntry.w loc_3B64E	; 6
; ===========================================================================

loc_3B61C:
	addq.b	#2,routine_secondary(a0)
	bra.w	loc_3B77E
; ===========================================================================

loc_3B624:
	bsr.w	loc_3B790
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$F0,d0
	cmp.b	subtype(a0),d0
	beq.s	loc_3B638
	rts
; ===========================================================================

loc_3B638:
	addq.b	#2,routine_secondary(a0)
	clr.b	anim(a0)
	bra.w	loc_3B7BC
; ===========================================================================

loc_3B644:
	lea	(Ani_objB6).l,a1
	jmpto	JmpTo25_AnimateSprite
; ===========================================================================

loc_3B64E:
	move.b	#2,routine_secondary(a0)
	move.w	#$C0,objoff_2A(a0)
	rts
; ===========================================================================

loc_3B65C:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B66E(pc,d0.w),d1
	jsr	off_3B66E(pc,d1.w)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3B66E:	offsetTable
		offsetTableEntry.w loc_3B61C
		offsetTableEntry.w loc_3B674
		offsetTableEntry.w loc_3B6A6
; ===========================================================================

loc_3B674:
	bsr.w	loc_3B790
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.b	#$20,objoff_2A(a0)
	move.b	#3,anim(a0)
	clr.b	anim_frame(a0)
	clr.b	anim_frame_duration(a0)
	bsr.w	loc_3B7BC
	bsr.w	loc_3B7F8
	moveq	#signextendB(SndID_Fire),d0
	jmpto	JmpTo12_PlaySound
; ===========================================================================

loc_3B6A6:
	subq.b	#1,objoff_2A(a0)
	bmi.s	+
	lea	(Ani_objB6).l,a1
	jmpto	JmpTo25_AnimateSprite
; ===========================================================================
+
	move.b	#2,routine_secondary(a0)
	clr.b	mapping_frame(a0)
	move.w	#$C0,objoff_2A(a0)
	rts
; ===========================================================================

loc_3B6C8:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B6DA(pc,d0.w),d1
	jsr	off_3B6DA(pc,d1.w)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3B6DA:	offsetTable
		offsetTableEntry.w loc_3B6E2	; 0
		offsetTableEntry.w loc_3B6FE	; 2
		offsetTableEntry.w loc_3B72C	; 4
		offsetTableEntry.w loc_3B736	; 6
; ===========================================================================

loc_3B6E2:
	bsr.w	loc_3B790
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$10,objoff_2A(a0)
	rts
; ===========================================================================

loc_3B6FE:
	bsr.w	loc_3B790
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.b	#0,anim(a0)
	bsr.w	Obj_GetOrientationToPlayer
	bclr	#status.npc.x_flip,status(a0)
	tst.w	d0
	bne.s	+
	bset	#status.npc.x_flip,status(a0)
+
	bra.w	loc_3B7BC
; ===========================================================================

loc_3B72C:
	lea	(Ani_objB6).l,a1
	jmpto	JmpTo25_AnimateSprite
; ===========================================================================

loc_3B736:
	clr.b	routine_secondary(a0)
	rts
; ===========================================================================

loc_3B73C:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B74E(pc,d0.w),d1
	jsr	off_3B74E(pc,d1.w)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3B74E:	offsetTable
		offsetTableEntry.w loc_3B756	; 0
		offsetTableEntry.w loc_3B764	; 2
		offsetTableEntry.w loc_3B644	; 4
		offsetTableEntry.w loc_3B64E	; 6
; ===========================================================================

loc_3B756:
	addq.b	#2,routine_secondary(a0)
	move.b	#2,mapping_frame(a0)
	bra.w	loc_3B77E
; ===========================================================================

loc_3B764:
	bsr.w	loc_3B7A6
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3B770
	rts
; ===========================================================================

loc_3B770:
	addq.b	#2,routine_secondary(a0)
	move.b	#4,anim(a0)
	bra.w	loc_3B7BC
; ===========================================================================

loc_3B77E:
	move.b	subtype(a0),d0
	andi.w	#$F0,d0
	move.b	d0,subtype(a0)
	move.w	d0,objoff_2A(a0)
	rts
; ===========================================================================

loc_3B790:
	move.w	x_pos(a0),-(sp)
	move.w	#$23,d1
	move.w	#4,d2
	move.w	#4,d3
	move.w	(sp)+,d4
	jmpto	JmpTo27_SolidObject
; ===========================================================================

loc_3B7A6:
	move.w	x_pos(a0),-(sp)
	move.w	#$F,d1
	move.w	#$18,d2
	move.w	#$18,d3
	move.w	(sp)+,d4
	jmpto	JmpTo27_SolidObject
; ===========================================================================

loc_3B7BC:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	return_3B7F6
	bclr	#p1_standing_bit,status(a0)
	beq.s	loc_3B7DE
	lea	(MainCharacter).w,a1 ; a1=character
    if fixBugs
	bclr	#status.player.on_object,status(a1)
    else
	; This is the wrong constant; it is for NPCs, not the player!
	bclr	#status.npc.p1_standing,status(a1)
    endif
	bset	#status.player.in_air,status(a1)

loc_3B7DE:
	bclr	#p2_standing_bit,status(a0)
	beq.s	return_3B7F6
	lea	(Sidekick).w,a1 ; a1=character
    if fixBugs
	bclr	#status.player.on_object,status(a1)
    else
	; This is the wrong constant; it is for NPCs, not the player!
	bclr	#status.npc.p2_standing,status(a1)
    endif
	bset	#status.player.in_air,status(a1)

return_3B7F6:
	rts
; ===========================================================================

loc_3B7F8:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	+
	_move.b	#ObjID_VerticalLaser,id(a1) ; load objB7 (huge unused vertical laser!)
	move.b	#$72,subtype(a1) ; <== ObjB7_SubObjData
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
+
	rts
; ===========================================================================
; off_3B818:
ObjB6_SubObjData:
	subObjData ObjB6_MapUnc_3B856,make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1),1<<render_flags.level_fg,4,$10,0

; animation script
; off_3B822:
Ani_objB6:	offsetTable
		offsetTableEntry.w byte_3B830	; 0
		offsetTableEntry.w byte_3B836	; 1
		offsetTableEntry.w byte_3B83A	; 2
		offsetTableEntry.w byte_3B840	; 3
		offsetTableEntry.w byte_3B846	; 4
		offsetTableEntry.w byte_3B84C	; 5
		offsetTableEntry.w byte_3B850	; 6
byte_3B830:	dc.b   3,  1,  2,$FD,  1,  0
byte_3B836:	dc.b $3F,  2,$FD,  2
byte_3B83A:	dc.b   3,  2,  1,  0,$FA,  0
byte_3B840:	dc.b   1,  0,  1,  2,  3,$FF
byte_3B846:	dc.b   3,  1,  0,$FD,  5,  0
byte_3B84C:	dc.b $3F,  0,$FD,  6
byte_3B850:	dc.b   3,  0,  1,  2,$FA,  0
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB6_MapUnc_3B856:	include "mappings/sprite/objB6.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B7 - Unused huge vertical laser from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B8A6:
ObjB7:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB7_Index(pc,d0.w),d1
	jmp	ObjB7_Index(pc,d1.w)
; ===========================================================================
; off_3B8B4:
ObjB7_Index:	offsetTable
		offsetTableEntry.w ObjB7_Init	; 0
		offsetTableEntry.w ObjB7_Main	; 2
; ===========================================================================
; loc_3B8B8:
ObjB7_Init:
	bsr.w	LoadSubObject
	move.b	#$20,objoff_2A(a0)
	rts
; ===========================================================================
; loc_3B8C4:
ObjB7_Main:
	subq.b	#1,objoff_2A(a0)
	beq.w	JmpTo65_DeleteObject
	bchg	#0,objoff_2B(a0)
	beq.w	return_37A48
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3B8DA:
ObjB7_SubObjData:
	subObjData ObjB7_MapUnc_3B8E4,make_art_tile(ArtTile_ArtNem_WfzVrtclLazer,2,1),1<<render_flags.level_fg,4,$18,$A9
ObjB7_MapUnc_3B8E4:	include "mappings/sprite/objB7.asm"

; ===========================================================================
; ----------------------------------------------------------------------------
; Object B8 - Wall turret from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B968:
ObjB8:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB8_Index(pc,d0.w),d1
	jmp	ObjB8_Index(pc,d1.w)
; ===========================================================================
; off_3B976:
ObjB8_Index:	offsetTable
		offsetTableEntry.w ObjB8_Init	; 0
		offsetTableEntry.w loc_3B980	; 2
		offsetTableEntry.w loc_3B9AA	; 4
; ===========================================================================
; BranchTo5_LoadSubObject
ObjB8_Init:
	bra.w	LoadSubObject
; ===========================================================================

loc_3B980:
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.s	+
	bsr.w	Obj_GetOrientationToPlayer
	tst.w	d1
	beq.s	+
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	blo.s	++
+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	#2,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3B9AA:
	bsr.w	Obj_GetOrientationToPlayer
	moveq	#0,d6
	addi.w	#$20,d2
	cmpi.w	#$40,d2
	blo.s	loc_3B9C0
	move.w	d0,d6
	lsr.w	#1,d6
	addq.w	#1,d6

loc_3B9C0:
	move.b	d6,mapping_frame(a0)
	subq.w	#1,objoff_2A(a0)
	bne.s	+
	move.w	#$60,objoff_2A(a0)
	bsr.w	loc_3B9D8
+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3B9D8:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	+	; rts
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#3,mapping_frame(a1)
	move.b	#$8E,subtype(a1) ; <== ObjB8_SubObjData2
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	lea_	Obj98_WallTurretShotMove,a2
	move.l	a2,objoff_2A(a1)
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	lsl.w	#2,d0
	lea	byte_3BA2A(pc,d0.w),a2
	move.b	(a2)+,d0
	ext.w	d0
	add.w	d0,x_pos(a1)
	move.b	(a2)+,d0
	ext.w	d0
	add.w	d0,y_pos(a1)
	move.b	(a2)+,x_vel(a1)
	move.b	(a2)+,y_vel(a1)
+
	rts
; ===========================================================================
byte_3BA2A:
	dc.b   0
	dc.b $18	; 1
	dc.b   0	; 2
	dc.b   1	; 3
	dc.b $EF	; 4
	dc.b $10	; 5
	dc.b $FF	; 6
	dc.b   1	; 7
	dc.b $11	; 8
	dc.b $10	; 9
	dc.b   1	; 10
	dc.b   1	; 11
	even
; off_3BA36:
ObjB8_SubObjData:
	subObjData ObjB8_Obj98_MapUnc_3BA46,make_art_tile(ArtTile_ArtNem_WfzWallTurret,0,0),1<<render_flags.level_fg,4,$10,0
; animation script
; off_3BA40:
Ani_WallTurretShot: offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   2,  3,  4,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB8_Obj98_MapUnc_3BA46:	include "mappings/sprite/objB8.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B9 - Laser from WFZ that shoots down the Tornado
; ----------------------------------------------------------------------------
; Sprite_3BABA:
ObjB9:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB9_Index(pc,d0.w),d1
	jmp	ObjB9_Index(pc,d1.w)
; ===========================================================================
; off_3BAC8:
ObjB9_Index:	offsetTable
		offsetTableEntry.w ObjB9_Init
		offsetTableEntry.w loc_3BAD2
		offsetTableEntry.w loc_3BAF0
; ===========================================================================
; BranchTo6_LoadSubObject
ObjB9_Init:
	bra.w	LoadSubObject
; ===========================================================================

loc_3BAD2:
	_btst	#render_flags.on_screen,render_flags(a0)
	_bne.s	+
	bra.w	loc_3BAF8
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	#-$1000,x_vel(a0)
	moveq	#signextendB(SndID_LargeLaser),d0
	jsrto	JmpTo12_PlaySound
	bra.w	loc_3BAF8
; ===========================================================================

loc_3BAF0:
	jsrto	JmpTo26_ObjectMove
	bra.w	loc_3BAF8
loc_3BAF8:
	move.w	x_pos(a0),d0
	move.w	(Camera_X_pos).w,d1
	subi.w	#$40,d1
	cmp.w	d1,d0
	blt.w	JmpTo65_DeleteObject
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; off_3BB0E:
ObjB9_SubObjData:
	subObjData ObjB9_MapUnc_3BB18,make_art_tile(ArtTile_ArtNem_WfzHrzntlLazer,2,1),1<<render_flags.level_fg,1,$60,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB9_MapUnc_3BB18:	include "mappings/sprite/objB9.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BA - Wheel from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BB4C:
ObjBA:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBA_Index(pc,d0.w),d1
	jmp	ObjBA_Index(pc,d1.w)
; ===========================================================================
; off_3BB5A:
ObjBA_Index:	offsetTable
		offsetTableEntry.w ObjBA_Init	; 0
		offsetTableEntry.w ObjBA_Main	; 2
; ===========================================================================
; BranchTo7_LoadSubObject
ObjBA_Init:
	bra.w	LoadSubObject
; ===========================================================================
; BranchTo14_JmpTo39_MarkObjGone
ObjBA_Main:
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3BB66:
ObjBA_SubObjData:
	subObjData ObjBA_MapUnc_3BB70,make_art_tile(ArtTile_ArtNem_WfzConveyorBeltWheel,2,1),1<<render_flags.level_fg,4,$10,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBA_MapUnc_3BB70:	include "mappings/sprite/objBA.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BB - Removed object (unknown, unused)
; ----------------------------------------------------------------------------
; Sprite_3BB7C:
ObjBB:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBB_Index(pc,d0.w),d1
	jmp	ObjBB_Index(pc,d1.w)
; ===========================================================================
; off_3BB8A:
ObjBB_Index:	offsetTable
		offsetTableEntry.w ObjBB_Init	; 0
		offsetTableEntry.w ObjBB_Main	; 2
; ===========================================================================
; BranchTo8_LoadSubObject
ObjBB_Init:
	bra.w	LoadSubObject
; ===========================================================================
; BranchTo15_JmpTo39_MarkObjGone
ObjBB_Main:
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3BB96:
ObjBB_SubObjData:
	subObjData ObjBB_MapUnc_3BBA0,make_art_tile(ArtTile_ArtNem_Unknown,1,0),1<<render_flags.level_fg,4,$C,9
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBB_MapUnc_3BBA0:	include "mappings/sprite/objBB.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BC - Fire coming out of Robotnik's ship in WFZ
; ----------------------------------------------------------------------------
; Sprite_3BBBC:
ObjBC:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBC_Index(pc,d0.w),d1
	jmp	ObjBC_Index(pc,d1.w)
; ===========================================================================
; off_3BBCA:
ObjBC_Index:	offsetTable
		offsetTableEntry.w ObjBC_Init
		offsetTableEntry.w ObjBC_Main
; ===========================================================================
; loc_3BBCE:
ObjBC_Init:
	bsr.w	LoadSubObject
	move.w	x_pos(a0),objoff_2C(a0)
	rts
; ===========================================================================
; loc_3BBDA:
ObjBC_Main:
	move.w	objoff_2C(a0),d0
	move.w	(Camera_BG_X_offset).w,d1
	cmpi.w	#$380,d1
	bhs.w	JmpTo65_DeleteObject
	add.w	d1,d0
	move.w	d0,x_pos(a0)
	bchg	#0,objoff_2A(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; off_3BBFE:
ObjBC_SubObjData2:
	subObjData ObjBC_MapUnc_3BC08,make_art_tile(ArtTile_ArtNem_WfzThrust,2,0),1<<render_flags.level_fg,4,$10,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBC_MapUnc_3BC08:	include "mappings/sprite/objBC.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BD - Ascending/descending metal platforms from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BC1C:
ObjBD:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBD_Index(pc,d0.w),d1
	jmp	ObjBD_Index(pc,d1.w)
; ===========================================================================
; off_3BC2A:
ObjBD_Index:	offsetTable
		offsetTableEntry.w ObjBD_Init	; 0
		offsetTableEntry.w loc_3BC3C	; 2
		offsetTableEntry.w loc_3BC50	; 4
; ===========================================================================
; loc_3BC30:
ObjBD_Init:
	addq.b	#2,routine(a0)
	move.w	#1,objoff_2A(a0)
	rts
; ===========================================================================

loc_3BC3C:
	subq.w	#1,objoff_2A(a0)
	bne.s	+
	move.w	#$40,objoff_2A(a0)
	bsr.w	loc_3BCF8
+
	jmpto	JmpTo8_MarkObjGone3
; ===========================================================================

loc_3BC50:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3BC62(pc,d0.w),d1
	jsr	off_3BC62(pc,d1.w)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3BC62:	offsetTable
		offsetTableEntry.w loc_3BC6C	; 0
		offsetTableEntry.w loc_3BCAC	; 2
		offsetTableEntry.w loc_3BCB6	; 4
		offsetTableEntry.w loc_3BCCC	; 6
		offsetTableEntry.w loc_3BCD6	; 8
; ===========================================================================

loc_3BC6C:
	bsr.w	LoadSubObject
	move.b	#2,mapping_frame(a0)
	subq.b	#2,routine(a0)
	addq.b	#2,routine_secondary(a0)
	move.w	#$C7,objoff_2A(a0)
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	loc_3BC92
	move.w	#$1C7,objoff_2A(a0)

loc_3BC92:
	moveq	#0,d0
	move.b	subtype(a0),d0
	subi.b	#$7E,d0
	move.b	d0,subtype(a0)
	move.w	word_3BCA8(pc,d0.w),y_vel(a0)
	rts
; ===========================================================================
word_3BCA8:
	dc.w -$100
	dc.w  $100	; 1
; ===========================================================================

loc_3BCAC:
	lea	(Ani_objBD).l,a1
	jmpto	JmpTo25_AnimateSprite
; ===========================================================================

loc_3BCB6:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3BCC0
	bra.w	loc_3BCDE
; ===========================================================================

loc_3BCC0:
	addq.b	#2,routine_secondary(a0)
	move.b	#1,anim(a0)
	rts
; ===========================================================================

loc_3BCCC:
	lea	(Ani_objBD).l,a1
	jmpto	JmpTo25_AnimateSprite
; ===========================================================================

loc_3BCD6:
	bsr.w	loc_3B7BC
    if fixBugs
	; 'DeleteObject' is called here, but then 'loc_3BC50' calls 'MarkObjGone' afterwards.
	; This can result in either the object being queued for display with 'DisplaySprite',
	; or the object being deleted again with yet another call to 'DeleteObject'.
	; To prevent this, just meddle with the stack to prevent returning to 'loc_3BC50', like this:
	addq.w	#4,sp
    endif
	jmpto	JmpTo65_DeleteObject
; ===========================================================================

loc_3BCDE:
	move.w	x_pos(a0),-(sp)
	jsrto	JmpTo26_ObjectMove
	move.w	#$23,d1
	move.w	#4,d2
	move.w	#5,d3
	move.w	(sp)+,d4
	jmpto	JmpTo9_PlatformObject
; ===========================================================================

loc_3BCF8:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	+	; rts
	_move.b	#ObjID_SmallMetalPform,id(a1) ; load objBD
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#4,routine(a1)
	move.b	subtype(a0),subtype(a1)
	move.b	render_flags(a0),render_flags(a1)
+
	rts
; ===========================================================================
; off_3BD24:
ObjBD_SubObjData:
	subObjData ObjBD_MapUnc_3BD3E,make_art_tile(ArtTile_ArtNem_WfzBeltPlatform,3,1),1<<render_flags.level_fg,4,$18,0
; animation script
; off_3BD2E:
Ani_objBD:	offsetTable
		offsetTableEntry.w byte_3BD32	; 0
		offsetTableEntry.w byte_3BD38	; 1
byte_3BD32:	dc.b   3,  2,  1,  0,$FA,  0
byte_3BD38:	dc.b   1,  0,  1,  2,$FA
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBD_MapUnc_3BD3E:	include "mappings/sprite/objBD.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BE - Lateral cannon (temporary platform that pops in/out) from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BD7A:
ObjBE:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBE_Index(pc,d0.w),d1
	jmp	ObjBE_Index(pc,d1.w)
; ===========================================================================
; off_3BD88:
ObjBE_Index:	offsetTable
		offsetTableEntry.w ObjBE_Init	;  0
		offsetTableEntry.w loc_3BDA2	;  2
		offsetTableEntry.w loc_3BDC6	;  4
		offsetTableEntry.w loc_3BDD4	;  6
		offsetTableEntry.w loc_3BDC6	;  8
		offsetTableEntry.w loc_3BDF4	; $A
; ===========================================================================
; loc_3BD94:
ObjBE_Init:
	moveq	#0,d0
	move.b	#($41<<1),d0
	bsr.w	LoadSubObject_Part2
	bra.w	loc_3B77E
; ===========================================================================

loc_3BDA2:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$F0,d0
	cmp.b	subtype(a0),d0
	beq.s	+
	jmpto	JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine(a0)
	clr.b	anim(a0)
	move.w	#$A0,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3BDC6:
	lea	(Ani_objBE).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3BDD4:
	subq.w	#1,objoff_2A(a0)
	beq.s	+
	bsr.w	loc_3BE04
	jmpto	JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine(a0)
	move.b	#1,anim(a0)
	bsr.w	loc_3B7BC
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3BDF4:
	move.b	#2,routine(a0)
	move.w	#$40,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3BE04:
	move.b	mapping_frame(a0),d0
	cmpi.b	#3,d0
	beq.s	+
	cmpi.b	#4,d0
	bne.w	loc_3B7BC
+
	move.w	x_pos(a0),-(sp)
	move.w	#$23,d1
	move.w	#$18,d2
	move.w	#$19,d3
	move.w	(sp)+,d4
	jmpto	JmpTo9_PlatformObject
; ===========================================================================
; off_3BE2C:
ObjBE_SubObjData:
	subObjData ObjBE_MapUnc_3BE46,make_art_tile(ArtTile_ArtNem_WfzGunPlatform,3,1),1<<render_flags.level_fg,4,$18,0
; animation script
; off_3BE36:
Ani_objBE:	offsetTable
		offsetTableEntry.w byte_3BE3A	; 0
		offsetTableEntry.w byte_3BE40	; 1
byte_3BE3A:	dc.b   5,  0,  1,  2,  3,$FC
byte_3BE40:	dc.b   5,  3,  2,  1,  0,$FC
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBE_MapUnc_3BE46:	include "mappings/sprite/objBE.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BF - Rotaty-stick badnik from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BEAA:
ObjBF:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBF_Index(pc,d0.w),d1
	jmp	ObjBF_Index(pc,d1.w)
; ===========================================================================
; off_3BEB8:
ObjBF_Index:	offsetTable
		offsetTableEntry.w ObjBF_Init		; 0
		offsetTableEntry.w ObjBF_Animate	; 2
; ===========================================================================
; BranchTo9_LoadSubObject
ObjBF_Init:
	bra.w	LoadSubObject
; ===========================================================================
; loc_3BEC0:
ObjBF_Animate:
	lea	(Ani_objBF).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3BECE:
ObjBE_SubObjData2:
	subObjData ObjBF_MapUnc_3BEE0,make_art_tile(ArtTile_ArtNem_WfzUnusedBadnik,3,1),1<<render_flags.level_fg,4,4,4
; animation script
; off_3BED8:
Ani_objBF:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBF_MapUnc_3BEE0:	include "mappings/sprite/objBF.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; Object C0 - Speed launcher from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BF04:
ObjC0:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC0_Index(pc,d0.w),d1
	jmp	ObjC0_Index(pc,d1.w)
; ===========================================================================
; off_3BF12:
ObjC0_Index:	offsetTable
		offsetTableEntry.w ObjC0_Init	; 0
		offsetTableEntry.w ObjC0_Main	; 2
; ===========================================================================
; loc_3BF16:
ObjC0_Init:
	move.w	#($43<<1),d0
	bsr.w	LoadSubObject_Part2
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#4,d0
	btst	#status.npc.x_flip,status(a0)
	bne.s	+
	neg.w	d0
+
	move.w	x_pos(a0),d1
	move.w	d1,objoff_34(a0)
	add.w	d1,d0
	move.w	d0,objoff_32(a0)
; loc_3BF3E:
ObjC0_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3BF60(pc,d0.w),d1
	jsr	off_3BF60(pc,d1.w)
	move.w	#$10,d1
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	jsrto	JmpTo9_PlatformObject
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
off_3BF60:	offsetTable
		offsetTableEntry.w loc_3BF66
		offsetTableEntry.w loc_3BFD8
		offsetTableEntry.w loc_3C062
; ===========================================================================

loc_3BF66:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	+++	; rts
	addq.b	#2,routine_secondary(a0)
	move.w	#$C00,x_vel(a0)
	move.w	#$80,objoff_30(a0)
	btst	#status.npc.x_flip,status(a0)
	bne.s	+
	neg.w	x_vel(a0)
	neg.w	objoff_30(a0)
+
	jsrto	JmpTo26_ObjectMove
	move.b	status(a0),d0
	move.b	d0,d1
	andi.b	#p1_standing,d1
	beq.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_3BFB4
+
	andi.b	#p2_standing,d0
	beq.s	+	; rts
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	loc_3BFB4
+
	rts
; ===========================================================================

loc_3BFB4:
	clr.w	inertia(a1)
	clr.w	x_vel(a1)
	move.w	x_pos(a0),x_pos(a1)
	bclr	#status.player.x_flip,status(a1)
	btst	#status.npc.x_flip,status(a0)
	bne.s	+
	bset	#status.player.x_flip,status(a1)
+
	rts
; ===========================================================================

loc_3BFD8:
	move.w	objoff_30(a0),d0
	add.w	d0,x_vel(a0)
	jsrto	JmpTo26_ObjectMove
	move.w	objoff_32(a0),d0
	sub.w	x_pos(a0),d0
	btst	#status.npc.x_flip,status(a0)
	beq.s	+
	neg.w	d0
+
	tst.w	d0
	bpl.s	loc_3C034
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	return_3C01E
	move.b	d0,d1
	andi.b	#p1_standing,d1
	beq.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_3BFB4
+
	andi.b	#p2_standing,d0
	beq.s	return_3C01E
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	loc_3BFB4

return_3C01E:
	rts
; ===========================================================================

loc_3C020:
	move.w	x_vel(a0),x_vel(a1)
	move.w	#-$400,y_vel(a1)
	bset	#status.player.in_air,status(a1)
	rts
; ===========================================================================

loc_3C034:
	addq.b	#2,routine_secondary(a0)
	move.w	objoff_32(a0),x_pos(a0)
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	loc_3C062
	move.b	d0,d1
	andi.b	#p1_standing,d1
	beq.s	loc_3C056
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_3C020

loc_3C056:
	andi.b	#p2_standing,d0
	beq.s	loc_3C062
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	loc_3C020

loc_3C062:
	move.w	x_pos(a0),d0
	moveq	#4,d1
	tst.w	objoff_30(a0)	; if objoff_30(a0) is positive,
	spl	d2		; then set d2 to $FF, else set d2 to $00
	bmi.s	+
	neg.w	d1
+
	add.w	d1,d0
	cmp.w	objoff_34(a0),d0
	bhs.s	+
	not.b	d2
+
	tst.b	d2
	bne.s	+
	clr.b	routine_secondary(a0)
	move.w	objoff_34(a0),d0
+
	move.w	d0,x_pos(a0)
	rts
; ===========================================================================
; off_3C08E:
ObjC0_SubObjData:
	subObjData ObjC0_MapUnc_3C098,make_art_tile(ArtTile_ArtNem_WfzLaunchCatapult,1,0),1<<render_flags.level_fg,4,$10,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC0_MapUnc_3C098:	include "mappings/sprite/objC0.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Object C1 - Breakable plating from WFZ
; (and what Sonic hangs onto on the back of Robotnik's getaway ship)
; ---------------------------------------------------------------------------
; OST Variables:
plating_time		= objoff_30	; time between grabbing the plating & breaking
plating_grabbed		= objoff_32	; flag set when Sonic/Tails grab the plating
plating_unk		= objoff_3F	; seems to be used to determine how long some plates hold on
					; for after breaking until they fly off
; Sprite_3C0AC:
ObjC1:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC1_Index(pc,d0.w),d1
	jmp	ObjC1_Index(pc,d1.w)
; ===========================================================================
; off_3C0BA:
ObjC1_Index:	offsetTable
		offsetTableEntry.w ObjC1_Init	; 0
		offsetTableEntry.w ObjC1_Main	; 2
		offsetTableEntry.w ObjC1_FallOff	; 4
; ===========================================================================
; loc_3C0C0:
ObjC1_Init:
	move.w	#($44<<1),d0
	bsr.w	LoadSubObject_Part2
	moveq	#0,d0
	; Yes, this is actually configurable, but in practice is redundant
	; since all of them are set to break after 2 seconds.
	move.b	subtype(a0),d0
	mulu.w	#60,d0			; multiply by 60 (1 second)
	move.w	d0,plating_time(a0)	; set breakage time

ObjC1_Main:
	tst.b	plating_grabbed(a0)	; has plating already been grabbed?
	beq.s	ObjC1_Grab		; if not, branch
	tst.w	plating_time(a0)
	beq.s	+
	subq.w	#1,plating_time(a0)	; decrement time until break
	beq.s	ObjC1_Release
+
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	y_pos(a0),d0
	subi.w	#$18,d0
	btst	#button_up,(Ctrl_1_Held).w	; is Up being pressed?
	beq.s	+			; if not, branch
	subq.w	#1,y_pos(a1)		; move Sonic up
	cmp.w	y_pos(a1),d0
	blo.s	+			; but stop if he's about to fall off
	move.w	d0,y_pos(a1)
+
	addi.w	#$30,d0
	btst	#button_down,(Ctrl_1_Held).w	; is Down being pressed?
	beq.s	+			; if not, branch
	addq.w	#1,y_pos(a1)		; move Sonic down
	cmp.w	y_pos(a1),d0
	bhs.s	+			; but stop if he's about to fall off
	move.w	d0,y_pos(a1)
+
	move.b	(Ctrl_1_Press_Logical).w,d0
	andi.w	#button_B_mask|button_C_mask|button_A_mask,d0	; is A/B/C being pressed?
	beq.s	BranchTo16_JmpTo39_MarkObjGone		; if not, branch
; loc_3C12E:
ObjC1_Release:
	clr.b	collision_flags(a0)
	clr.b	(MainCharacter+obj_control).w
	clr.b	(WindTunnel_holding_flag).w
	clr.b	plating_grabbed(a0)
	bra.s	ObjC1_BeginBreakup
; ===========================================================================
; loc_3C140:
ObjC1_Grab:
	tst.b	collision_property(a0)		; has Sonic touched the plating?
	beq.s	BranchTo16_JmpTo39_MarkObjGone	; if not, branch
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a0),d0
	subi.w	#$14,d0
	cmp.w	x_pos(a1),d0
	bhs.s	BranchTo16_JmpTo39_MarkObjGone
	clr.b	collision_property(a0)
	cmpi.b	#4,routine(a1)			; is Sonic hurt, dying, etc?
	bhs.s	BranchTo16_JmpTo39_MarkObjGone	; if yes, branch
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	move.w	x_pos(a0),d0
	subi.w	#$14,d0
	move.w	d0,x_pos(a1)
	bset	#status.player.x_flip,status(a1)
	move.b	#AniIDSonAni_Hang,anim(a1)
	move.b	#1,(MainCharacter+obj_control).w	; lock controls
	move.b	#1,(WindTunnel_holding_flag).w		; disable wind tunnel
	move.b	#1,plating_grabbed(a0)		; begin break timer

BranchTo16_JmpTo39_MarkObjGone ; BranchTo
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; loc_3C19A:
ObjC1_BeginBreakup:
	lea	(ObjC1_Positions).l,a4
	lea	(ObjC1_BreakTimes).l,a2
	bsr.w	loc_3C1F4
; ObjC1_Breakup:
ObjC1_FallOff:
	tst.b	plating_unk(a0)
	beq.s	+
	subq.b	#1,plating_unk(a0)
	bra.s	++
; ===========================================================================
+
	jsrto	JmpTo26_ObjectMove
	addi_.w	#8,y_vel(a0)
	lea	(Ani_objC1).l,a1
	jsrto	JmpTo25_AnimateSprite
+
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	JmpTo65_DeleteObject
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; animation script
; off_3C1D6:
Ani_objC1:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3,  2,  3,  4,  5,  1,$FF
		even

; Time (in frames) to wait until breaking off the aircraft
; byte_3C1E0:
ObjC1_BreakTimes:
	dc.b   0
	dc.b   4	; 1
	dc.b $18	; 2
	dc.b $20	; 3
	even

; Positions each breaking plate starts at
; byte_3C1E4:
ObjC1_Positions:
	; x-position, y-position
	dc.w  -$10,-$10
	dc.w  -$10, $10
	dc.w  -$30,-$10
	dc.w  -$30, $10
; ===========================================================================

loc_3C1F4:
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	move.b	priority(a0),d4
	subq.b	#1,d4
	moveq	#3,d1
	movea.l	a0,a1
	bra.s	loc_3C20E
; ===========================================================================

loc_3C208:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	loc_3C26C

loc_3C20E:
	move.b	#4,routine(a1)
	_move.b	id(a0),id(a1) ; load obj
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#1<<render_flags.on_screen|1<<render_flags.level_fg,render_flags(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	(a4)+,d0
	add.w	d2,d0
	move.w	d0,x_pos(a1)
	move.w	(a4)+,d0
	add.w	d3,d0
	move.w	d0,y_pos(a1)
	move.b	d4,priority(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#1,mapping_frame(a1)
	move.w	#-$400,x_vel(a1)
	move.w	#0,y_vel(a1)
	move.b	(a2)+,plating_unk(a1)
	dbf	d1,loc_3C208

loc_3C26C:
	move.w	#SndID_SlowSmash,d0
	jmp	(PlaySound).l
; ===========================================================================
; off_3C276:
ObjC1_SubObjData:
	subObjData ObjC1_MapUnc_3C280,make_art_tile(ArtTile_ArtNem_BreakPanels,3,1),1<<render_flags.level_fg,4,$40,$E1
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
ObjC1_MapUnc_3C280:	include "mappings/sprite/objC1.asm"

; ===========================================================================
; ----------------------------------------------------------------------------
; Object C2 - Rivet thing you bust to get into ship at the end of WFZ
; ----------------------------------------------------------------------------
; Sprite_3C328:
ObjC2:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC2_Index(pc,d0.w),d1
	jmp	ObjC2_Index(pc,d1.w)
; ===========================================================================
; off_3C336:
ObjC2_Index:	offsetTable
		offsetTableEntry.w ObjC2_Init	; 0
		offsetTableEntry.w ObjC2_Main	; 2
; ===========================================================================
; BranchTo10_LoadSubObject
ObjC2_Init:
	bra.w	LoadSubObject
; ===========================================================================
; loc_3C33E:
ObjC2_Main:
	move.b	(MainCharacter+anim).w,objoff_30(a0)
	move.w	x_pos(a0),-(sp)
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jsrto	JmpTo27_SolidObject
	btst	#p1_standing_bit,status(a0)
	bne.s	ObjC2_Bust
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; loc_3C366:
ObjC2_Bust:
	cmpi.b	#2,objoff_30(a0)
	bne.s	+
	move.w	#$2880,(Camera_Min_X_pos).w
	bclr	#p1_standing_bit,status(a0)
	_move.b	#ObjID_Explosion,id(a0) ; load 0bj27 (transform into explosion)
	move.b	#2,routine(a0)
	bset	#status.player.in_air,(MainCharacter+status).w
	bclr	#status.player.on_object,(MainCharacter+status).w
	lea	(Level_Layout+$850).w,a1	; alter the level layout
	move.l	#$8A707172,(a1)+
	move.w	#$7374,(a1)+
	lea	(Level_Layout+$950).w,a1
	move.l	#$6E787978,(a1)+
	move.w	#$787A,(a1)+
	move.b	#1,(Screen_redraw_flag).w
+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3C3B8:
ObjC2_SubObjData:
	subObjData ObjC2_MapUnc_3C3C2,make_art_tile(ArtTile_ArtNem_WfzSwitch,1,1),1<<render_flags.level_fg,4,$10,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC2_MapUnc_3C3C2:	include "mappings/sprite/objC2.asm"

Invalid_SubObjData2:

; ===========================================================================
; ----------------------------------------------------------------------------
; Object C3,C4 - Plane's smoke from WFZ
; ----------------------------------------------------------------------------
; Sprite_3C3D6:
ObjC3:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC3_Index(pc,d0.w),d1
	jmp	ObjC3_Index(pc,d1.w)
; ===========================================================================
; off_3C3E4:
ObjC3_Index:	offsetTable
		offsetTableEntry.w ObjC3_Init
		offsetTableEntry.w ObjC3_Main
; ===========================================================================
; loc_3C3E8:
ObjC3_Init:
	bsr.w	LoadSubObject
	move.b	#7,anim_frame_duration(a0)
	jsrto	JmpTo6_RandomNumber
	move.w	(RNG_seed).w,d0
	andi.w	#$1C,d0
	sub.w	d0,x_pos(a0)
	addi.w	#$10,y_pos(a0)
	move.w	#-$100,y_vel(a0)
	move.w	#-$100,x_vel(a0)
	rts
; ===========================================================================
; loc_3C416:
ObjC3_Main:
	jsrto	JmpTo26_ObjectMove
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#5,mapping_frame(a0)
	beq.w	JmpTo65_DeleteObject
+
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; off_3C438:
ObjC3_SubObjData:
	subObjData Obj27_MapUnc_21120,make_art_tile(ArtTile_ArtNem_Explosion,0,0),1<<render_flags.level_fg,5,$C,0
; ===========================================================================
; ----------------------------------------------------------------------------
; Object C5 - WFZ boss
; ----------------------------------------------------------------------------
; Sprite_3C442:
ObjC5:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC5_Index(pc,d0.w),d1
	jmp	ObjC5_Index(pc,d1.w)
; ===========================================================================
ObjC5_Index:	offsetTable
		offsetTableEntry.w ObjC5_Init			;   0 - Main loading sequence
		offsetTableEntry.w ObjC5_LaserCase		;   2 - Laser case (inside is laser)
		offsetTableEntry.w ObjC5_LaserWall		;   4 - Laser wall
		offsetTableEntry.w ObjC5_PlatformReleaser	;   6 - Platform releaser
		offsetTableEntry.w ObjC5_Platform		;   8 - Platform
		offsetTableEntry.w ObjC5_PlatformHurt		;  $A - Invisible object that gets the platform's spikes to hurt Sonic
		offsetTableEntry.w ObjC5_LaserShooter		;  $C - Laser shooter
		offsetTableEntry.w ObjC5_Laser			;  $E - Laser
		offsetTableEntry.w ObjC5_Robotnik		; $10 - Robotnik
		offsetTableEntry.w ObjC5_RobotnikPlatform	; $12 - Platform Robotnik's on
; ===========================================================================

ObjC5_Init:
	bsr.w	LoadSubObject
	move.b	subtype(a0),d0
	subi.b	#$90,d0
	move.b	d0,routine(a0)
	rts
; ===========================================================================

ObjC5_LaserCase:	; also the "mother" object
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_CaseIndex(pc,d0.w),d1
	jsr	ObjC5_CaseIndex(pc,d1.w)
	bra.w	ObjC5_HandleHits
; ===========================================================================
ObjC5_CaseIndex:offsetTable
		offsetTableEntry.w ObjC5_CaseBoundary		;   0 - Sets up boundaries for movement and basic things
		offsetTableEntry.w ObjC5_CaseWaitStart		;   2 - Waits for Sonic to start
		offsetTableEntry.w ObjC5_CaseWaitDown		;   4 - Waits to make the laser go down
		offsetTableEntry.w ObjC5_CaseDown		;   6 - Moves the case down
		offsetTableEntry.w ObjC5_CaseXSpeed		;   8 - Sets an X speed for the case
		offsetTableEntry.w ObjC5_CaseBoundaryChk	;  $A - Checks to make sure the case doesn't go through the boundaries
		offsetTableEntry.w ObjC5_CaseAnimate		;  $C - Animates the case (opening and closing)
		offsetTableEntry.w ObjC5_CaseLSLoad		;  $E - Laser shooter loading
		offsetTableEntry.w ObjC5_CaseLSDown		; $10 - Moves the laser shooter down
		offsetTableEntry.w ObjC5_CaseWaitLoadLaser	; $12 - Waits to load the laser
		offsetTableEntry.w ObjC5_CaseWaitMove		; $14 - Waits to move (checks if laser is completely loaded (as big as it gets))
		offsetTableEntry.w ObjC5_CaseBoundaryLaserChk	; $16 - Checks boundaries when moving with the laser
		offsetTableEntry.w ObjC5_CaseLSUp		; $18 - wait for laser shooter to go back up
		offsetTableEntry.w ObjC5_CaseAnimate		; $1A - Animates the case (opening and closing)
		offsetTableEntry.w ObjC5_CaseStartOver		; $1C - Sets secondary routine to 8
		offsetTableEntry.w ObjC5_CaseDefeated		; $1E - When defeated goes here (explosions and stuff)
; ===========================================================================

ObjC5_CaseBoundary:
	addq.b	#2,routine_secondary(a0)
	move.b	#0,collision_flags(a0)
	move.b	#8,collision_property(a0)	; Hit points
	move.w	#$442,d0
	move.w	d0,(Camera_Max_Y_pos).w
	move.w	d0,(Camera_Max_Y_pos_target).w
	move.w	x_pos(a0),d0
	subi.w	#$60,d0			; Max Left position
	move.w	d0,objoff_34(a0)
	addi.w	#$C0,d0			; Max Right Position
	move.w	d0,objoff_36(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseWaitStart:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$20,d2
	cmpi.w	#$40,d2			; How far away Sonic is to start the boss
	blo.s	ObjC5_CaseStart
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseStart:
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,y_vel(a0)		; Speed at which the laser carrier goes down
	lea	(ChildObject_ObjC5LaserWall).l,a2
	bsr.w	LoadChildObject
	subi.w	#$88,x_pos(a1)		; where to load the left laser wall (x)
	addi.w	#$60,y_pos(a1)		; left laser wall (y)
	lea	(ChildObject_ObjC5LaserWall).l,a2
	bsr.w	LoadChildObject
	addi.w	#$88,x_pos(a1)		; right laser wall (x)
	addi.w	#$60,y_pos(a1)		; right laser wall (y)
	lea	(ChildObject_ObjC5LaserShooter).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObject_ObjC5PlatformReleaser).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObject_ObjC5Robotnik).l,a2
	bsr.w	LoadChildObject
	move.w	#$5A,objoff_2A(a0)	; How long for the boss music to start playing and the boss to start
	moveq	#signextendB(MusID_FadeOut),d0
	jsrto	JmpTo12_PlaySound
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseWaitDown:
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjC5_CaseSpeedDown
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseSpeedDown:
	addq.b	#2,routine_secondary(a0)
	move.w	#$60,objoff_2A(a0)	; How long the laser carrier goes down
	moveq	#signextendB(MusID_Boss),d0
	jsrto	JmpTo5_PlayMusic
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseDown:
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjC5_CaseStopDown
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseStopDown:
	addq.b	#2,routine_secondary(a0)
	clr.w	y_vel(a0)		; stop the laser carrier from going down
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseXSpeed:
	addq.b	#2,routine_secondary(a0)
	bsr.w	Obj_GetOrientationToPlayer
	move.w	#$100,d1		; Speed of carrier (when going back and forth before sending out laser)
	tst.w	d0
	bne.s	ObjC5_CasePMLoader
	neg.w	d1

ObjC5_CasePMLoader:
	move.w	d1,x_vel(a0)
	bset	#status.npc.misc,status(a0)		; makes the platform maker load
	move.w	#$70,objoff_2A(a0)	; how long to go back and forth before letting out laser
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseBoundaryChk:			; waits and makes sure the carrier does not go beyond the limit
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjC5_CaseOpeningAnim
	move.w	x_pos(a0),d0
	tst.w	x_vel(a0)
	bmi.s	ObjC5_CaseBoundaryChk2
	cmp.w	objoff_36(a0),d0
	bhs.s	ObjC5_CaseNegSpeed
	bra.w	ObjC5_CaseMoveDisplay
; ===========================================================================

ObjC5_CaseBoundaryChk2:
	cmp.w	objoff_34(a0),d0
	bhs.s	ObjC5_CaseMoveDisplay

ObjC5_CaseNegSpeed:
	neg.w	x_vel(a0)

ObjC5_CaseMoveDisplay:
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseOpeningAnim:
	addq.b	#2,routine_secondary(a0)
	clr.b	anim(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseAnimate:
	lea	(Ani_objC5).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseLSLoad:		; loads up the laser shooter (LS)
	addq.b	#2,routine_secondary(a0)
	move.w	#$E,objoff_2A(a0)	; Time the laser shooter moves down
	movea.w	objoff_3C(a0),a1 ; a1=object (laser shooter)
	move.b	#4,routine_secondary(a1)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseLSDown:
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjC5_CaseAddCollision
	movea.w	objoff_3C(a0),a1 ; a1=object (laser shooter)
	addq.w	#1,y_pos(a1)	; laser shooter down speed
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseAddCollision:
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)	; Length before shooting laser
	bset	#status.npc.p2_standing,status(a0)		; makes the hit sound and flashes happen only once when you hit it
	bset	#status.npc.p2_pushing,status(a0)		; makes sure collision gets restored
	move.b	#6,collision_flags(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseWaitLoadLaser:
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjC5_CaseLoadLaser
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseLoadLaser:
	addq.b	#2,routine_secondary(a0)
	lea	(ChildObject_ObjC5Laser).l,a2
	bsr.w	LoadChildObject		; loads laser
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseWaitMove:
	movea.w	parent(a0),a1 ; a1=object
	btst	#status.npc.misc,status(a1)		; waits to check if laser fired
	bne.s	ObjC5_CaseLaserSpeed
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseLaserSpeed:
	addq.b	#2,routine_secondary(a0)
	move.w	#$80,objoff_2A(a0)	; how long to move the laser
	bsr.w	Obj_GetOrientationToPlayer	; tests if Sonic is to the right or left
	move.w	#$80,d1		; Speed when moving with laser
	tst.w	d0
	bne.s	ObjC5_CaseLaserSpeedSet
	neg.w	d1

ObjC5_CaseLaserSpeedSet:
	move.w	d1,x_vel(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseBoundaryLaserChk:		; make sure you stay in range when firing laser
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjC5_CaseStopLaserDelete
	move.w	x_pos(a0),d0
	tst.w	x_vel(a0)
	bmi.s	ObjC5_CaseBoundaryLaserChk2
	cmp.w	objoff_36(a0),d0
	bhs.s	ObjC5_CaseLaserStopMove
	bra.w	ObjC5_CaseLaserMoveDisplay
; ===========================================================================

ObjC5_CaseBoundaryLaserChk2:
	cmp.w	objoff_34(a0),d0
	bhs.s	ObjC5_CaseLaserMoveDisplay

ObjC5_CaseLaserStopMove:
	clr.w	x_vel(a0)	; stop moving

ObjC5_CaseLaserMoveDisplay:
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseStopLaserDelete:		; stops collision and deletes laser
	addq.b	#2,routine_secondary(a0)
	move.w	#$E,objoff_2A(a0)	; time for laser shooter to move back up
	bclr	#status.npc.p1_standing,status(a0)
	bclr	#status.npc.p2_standing,status(a0)
	bclr	#status.npc.p2_pushing,status(a0)
	clr.b	collision_flags(a0)	; no more collision
	movea.w	parent(a0),a1 		; a1=object (laser)
	jsrto	JmpTo6_DeleteObject2	; delete the laser
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseLSUp:
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjC5_CaseClosingAnim
	movea.w	objoff_3C(a0),a1 ; a1=object (laser shooter)
	subq.w	#1,y_pos(a1)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseClosingAnim: ;sets which animation to do
	addq.b	#2,routine_secondary(a0)
	move.b	#1,anim(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseStartOver:
	move.b	#8,routine_secondary(a0)
	bsr.w	ObjC5_CaseXSpeed
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseDefeated:
	clr.b	collision_flags(a0)
	st.b	collision_property(a0)
	bclr	#status.npc.p2_pushing,status(a0)
	subq.w	#1,objoff_30(a0)	; timer
	bmi.s	ObjC5_End
	jsrto	JmpTo_Boss_LoadExplosion
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_End:	; play music and change camera speed
	moveq	#signextendB(MusID_WFZ),d0
	jsrto	JmpTo5_PlayMusic
	move.w	#$720,d0
	move.w	d0,(Camera_Max_Y_pos).w
	move.w	d0,(Camera_Max_Y_pos_target).w
	jsrto	JmpTo65_DeleteObject
	addq.w	#4,sp
	rts
; ===========================================================================

ObjC5_LaserWall:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_LaserWallIndex(pc,d0.w),d1
	jsr	ObjC5_LaserWallIndex(pc,d1.w)
	tst.b	(a0)
	beq.w	return_37A48
	move.w	x_pos(a0),-(sp)
	move.w	#$13,d1
	move.w	#$40,d2
	move.w	#$80,d3
	move.w	(sp)+,d4
	jmpto	JmpTo27_SolidObject
; ===========================================================================
ObjC5_LaserWallIndex: offsetTable
	offsetTableEntry.w ObjC5_LaserWallMappings	; 0 - selects the mappings
	offsetTableEntry.w ObjC5_LaserWallWaitDelete	; 2 - Waits till set to delete (when the boss is defeated)
	offsetTableEntry.w ObjC5_LaserWallDelete	; 4 - After a little time it deletes
; ===========================================================================

ObjC5_LaserWallMappings:
	addq.b	#2,routine_secondary(a0)
	move.b	#$C,mapping_frame(a0)	; loads the laser wall from the WFZ boss art
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_LaserWallWaitDelete:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.p1_pushing,status(a1)
	bne.s	ObjC5_LaserWallTimerSet
	bchg	#0,objoff_2F(a0)	; makes it "flash" if set it won't flash
	bne.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_LaserWallTimerSet:	; sets a small timer
	addq.b	#2,routine_secondary(a0)
	move.b	#4,objoff_30(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_LaserWallDelete:
	subq.b	#1,anim_frame_duration(a0)
	bpl.w	return_37A48
	move.b	anim_frame_duration(a0),d0
	move.b	anim_frame(a0),d1
	addq.b	#2,d0
	bpl.s	ObjC5_LaserWallDisplay
	move.b	d1,anim_frame_duration(a0)
	subq.b	#1,objoff_30(a0)
	bpl.s	ObjC5_LaserWallDisplay
	move.b	#$10,objoff_30(a0)
	addq.b	#1,d1
	cmpi.b	#5,d1
	bhs.w	JmpTo65_DeleteObject
	move.b	d1,anim_frame(a0)
	move.b	d1,anim_frame_duration(a0)

ObjC5_LaserWallDisplay:
	bclr	#0,objoff_2F(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaser:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_PlatformReleaserIndex(pc,d0.w),d1
	jmp	ObjC5_PlatformReleaserIndex(pc,d1.w)
; ===========================================================================
ObjC5_PlatformReleaserIndex: offsetTable
	offsetTableEntry.w ObjC5_PlatformReleaserInit		; 0 - Load mappings and position
	offsetTableEntry.w ObjC5_PlatformReleaserWaitDown	; 2 - Waits for laser case to move down
	offsetTableEntry.w ObjC5_PlatformReleaserDown		; 4 - Goes down until time limit is up
	offsetTableEntry.w ObjC5_PlatformReleaserLoadWait	; 6 - Waits to load the platforms (the interval of time between each is from this) and makes sure only 3 are loaded
	offsetTableEntry.w ObjC5_PlatformReleaserDelete		; 8 - Explodes then deletes
; ===========================================================================

ObjC5_PlatformReleaserInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#5,mapping_frame(a0)
	addq.w	#8,y_pos(a0)		; Move down a little
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserWaitDown:
	movea.w	objoff_2C(a0),a1 ; a1=object laser case
	btst	#status.npc.misc,status(a1)		; checks if laser case is done moving down (so it starts loading the platforms)
	bne.s	ObjC5_PlatformReleaserSetDown
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserSetDown:
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)	; time to go down
	move.w	#$40,y_vel(a0)		; speed to go down
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserDown:
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjC5_PlatformReleaserStop
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserStop:
	addq.b	#2,routine_secondary(a0)
	clr.w	y_vel(a0)
	move.w	#$10,objoff_2A(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserLoadWait:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.p1_pushing,status(a1)
	bne.s	ObjC5_PlatformReleaserDestroyP
	subq.w	#1,objoff_2A(a0)
	bne.s	BranchTo8_JmpTo45_DisplaySprite
	move.w	#$80,objoff_2A(a0)	; Time between loading platforms
	moveq	#0,d0
	move.b	objoff_2E(a0),d0
	addq.b	#1,d0
	cmpi.b	#3,d0			; How many platforms to load
	blo.s	ObjC5_PlatformReleaserLoadP
	moveq	#0,d0

ObjC5_PlatformReleaserLoadP:	; P=Platforms
	move.b	d0,objoff_2E(a0)
	tst.b	objoff_30(a0,d0.w)
	bne.s	BranchTo8_JmpTo45_DisplaySprite
	st.b	objoff_30(a0,d0.w)
	lea	(ChildObject_ObjC5Platform).l,a2
	bsr.w	LoadChildObject
	move.b	objoff_2E(a0),objoff_2E(a1)

BranchTo8_JmpTo45_DisplaySprite ; BranchTo
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserDestroyP: 	; P=Platforms
	addq.b	#2,routine_secondary(a0)
	bset	#status.npc.p1_pushing,status(a0)		; destroy platforms
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserDelete:
	movea.w	objoff_2C(a0),a1 ; a1=object
	cmpi.b	#ObjID_WFZBoss,id(a1)
	bne.w	JmpTo65_DeleteObject
	jsrto	JmpTo_Boss_LoadExplosion
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_Platform:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_PlatformIndex(pc,d0.w),d1
	jsr	ObjC5_PlatformIndex(pc,d1.w)
	lea	(Ani_objC5).l,a1
	jsrto	JmpTo25_AnimateSprite
	tst.b	(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
ObjC5_PlatformIndex: offsetTable
	offsetTableEntry.w ObjC5_PlatformInit			; 0 - Selects mappings, anim ation, y speed and loads the object that hurts Sonic (by spiky area)
	offsetTableEntry.w ObjC5_PlatformDownWait		; 2 - Wait till the platform goes down some
	offsetTableEntry.w ObjC5_PlatformTestChangeDirection	; 4 - checks if time limit is over and if so to change direction
; ===========================================================================

ObjC5_PlatformInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#3,anim(a0)
	move.b	#7,mapping_frame(a0)
	move.w	#$100,y_vel(a0)			; Y speed
	move.w	#$60,objoff_2A(a0)
	lea	(ChildObject_ObjC5PlatformHurt).l,a2	; loads the invisible object that hurts Sonic
	bra.w	LoadChildObject
; ===========================================================================

ObjC5_PlatformDownWait:		; waits for it to go down some
	bsr.w	ObjC5_PlatformCheckExplode
	subq.w	#1,objoff_2A(a0)
	beq.s	ObjC5_PlatformLeft
	bra.w	ObjC5_PlatformMakeSolid
; ===========================================================================

ObjC5_PlatformLeft:			; goes left and makes a time limit (for going left)
	addq.b	#2,routine_secondary(a0)
	move.w	#$60,objoff_2A(a0)
	move.w	#-$100,x_vel(a0)		; X speed
	move.w	y_pos(a0),objoff_34(a0)
	bra.w	ObjC5_PlatformMakeSolid
; ===========================================================================

ObjC5_PlatformTestChangeDirection:
	bsr.w	ObjC5_PlatformCheckExplode
	subq.w	#1,objoff_2A(a0)
	bne.s	ObjC5_PlatformTestLeftRight
	move.w	#$C0,objoff_2A(a0)
	neg.w	x_vel(a0)

ObjC5_PlatformTestLeftRight:	; tests to see if a value should be added to go left or right
	moveq	#4,d0
	move.w	y_pos(a0),d1
	cmp.w	objoff_34(a0),d1
	blo.s	ObjC5_PlatformChangeY
	neg.w	d0

ObjC5_PlatformChangeY:	; give it that curving feel
	add.w	d0,y_vel(a0)
	bra.w	ObjC5_PlatformMakeSolid

ObjC5_PlatformMakeSolid:	; makes into a platform and moves
	move.w	x_pos(a0),-(sp)
	jsrto	JmpTo26_ObjectMove
	move.w	#$10,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	(sp)+,d4
	jmpto	JmpTo9_PlatformObject
; ===========================================================================

ObjC5_PlatformCheckExplode:	; checks to see if platforms should explode
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.p1_pushing,status(a1)
	bne.w	ObjC5_PlatformExplode
	rts
; ===========================================================================

ObjC5_PlatformExplode:
	bsr.w	loc_3B7BC
	move.b	#ObjID_BossExplosion,id(a0) ; load 0bj58 (explosion)
	clr.b	routine(a0)
	movea.w	objoff_3C(a0),a1 ; a1=object (invisible hurting thing)
	jsrto	JmpTo6_DeleteObject2
	addq.w	#4,sp
	rts
; ===========================================================================

ObjC5_PlatformHurt:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_PlatformHurtIndex(pc,d0.w),d1
	jmp	ObjC5_PlatformHurtIndex(pc,d1.w)
; ===========================================================================
ObjC5_PlatformHurtIndex: offsetTable
	offsetTableEntry.w ObjC5_PlatformHurtCollision		; 0 - Gives collision that hurts Sonic
	offsetTableEntry.w ObjC5_PlatformHurtFollowPlatform	; 2 - Follows around the platform and waits to be deleted
; ===========================================================================

ObjC5_PlatformHurtCollision:
	addq.b	#2,routine_secondary(a0)
	move.b	#$98,collision_flags(a0)
	rts
; ===========================================================================

ObjC5_PlatformHurtFollowPlatform:
	movea.w	objoff_2C(a0),a1 ; a1=object (platform)
	btst	#status.npc.p1_pushing,status(a1)
	bne.w	JmpTo65_DeleteObject
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),d0
	addi.w	#$C,d0
	move.w	d0,y_pos(a0)
	rts
; ===========================================================================

ObjC5_LaserShooter:
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	btst	#status.npc.p1_pushing,status(a1)
	bne.w	JmpTo65_DeleteObject
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_LaserShooterIndex(pc,d0.w),d1
	jmp	ObjC5_LaserShooterIndex(pc,d1.w)
; ===========================================================================
ObjC5_LaserShooterIndex: offsetTable
	offsetTableEntry.w ObjC5_LaserShooterInit	; 0 - Loads up mappings
	offsetTableEntry.w ObjC5_LaserShooterFollow	; 2 - Goes back and forth with the laser case
	offsetTableEntry.w ObjC5_LaserShooterDown	; 4 - Laser case sets it to this routine which then makes it go down
; ===========================================================================

ObjC5_LaserShooterInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#4,mapping_frame(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_LaserShooterFollow:
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_LaserShooterDown:
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	move.w	x_pos(a1),x_pos(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_Laser:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.p1_pushing,status(a1)
	bne.w	JmpTo65_DeleteObject
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_LaserIndex(pc,d0.w),d1
	jsr	ObjC5_LaserIndex(pc,d1.w)
	bchg	#0,objoff_2F(a0)
	bne.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
ObjC5_LaserIndex: offsetTable
	offsetTableEntry.w ObjC5_LaserInit	; 0 - Loads mappings and collision and such
	offsetTableEntry.w ObjC5_LaserFlash	; 2 - Makes the laser flash (gives the charging up effect)
	offsetTableEntry.w ObjC5_LaseWaitShoot	; 4 - Waits a little to launch the laser when it's done flickering (charging)
	offsetTableEntry.w ObjC5_LaserShoot	; 6 - Shoots down the laser untill it's fully shot out
	offsetTableEntry.w ObjC5_LaserMove	; 8 - Moves with laser case and shooter
; ===========================================================================

ObjC5_LaserInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#$D,mapping_frame(a0)
	move.b	#4,priority(a0)
	move.b	#0,collision_flags(a0)
	addi.w	#$10,y_pos(a0)
	move.b	#$C,anim_frame(a0)
	subq.w	#3,y_pos(a0)
	rts
; ===========================================================================

ObjC5_LaserFlash:
	bset	#0,objoff_2F(a0)
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	ObjC5_LaserNoLaser
	move.b	anim_frame_duration(a0),d0
	addq.b	#2,d0
	bpl.s	ObjC5_LaserFlicker
	move.b	anim_frame(a0),d0
	subq.b	#1,d0
	beq.s	ObjC5_LaseNext
	move.b	d0,anim_frame(a0)
	move.b	d0,anim_frame_duration(a0)

ObjC5_LaserFlicker:	; this is what makes the laser flicker before being fully loaded (covering laser shooter)
	bclr	#0,objoff_2F(a0)

ObjC5_LaserNoLaser: ; without this the laser would just stay on the shooter not going down
	rts
; ===========================================================================

ObjC5_LaseNext:		; just sets up a time to wait for the laser to shoot when it's loaded and done flickering
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)
	rts
; ===========================================================================

ObjC5_LaseWaitShoot:
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjC5_LaseStartShooting
	rts
; ===========================================================================

ObjC5_LaseStartShooting:
	addq.b	#2,routine_secondary(a0)
	addi.w	#$10,y_pos(a0)
	rts
; ===========================================================================

ObjC5_LaserShoot:
	moveq	#0,d0
	move.b	objoff_2E(a0),d0
	addq.b	#1,d0
	cmpi.b	#5,d0
	bhs.s	ObjC5_LaseShotOut
	addi.w	#$10,y_pos(a0)
	move.b	d0,objoff_2E(a0)
	move.b	ObjC5_LaserMappingsData(pc,d0.w),mapping_frame(a0)
	move.b	ObjC5_LaserCollisionData(pc,d0.w),collision_flags(a0)
	rts
; ===========================================================================

ObjC5_LaseShotOut:	; laser is fully shot out and lets the laser case know so it moves
	addq.b	#2,routine_secondary(a0)
	move.w	#$80,objoff_2A(a0)
	bset	#status.npc.misc,status(a0)
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	bset	#status.npc.p1_standing,status(a1)
	rts
; ===========================================================================
ObjC5_LaserMappingsData:
	dc.b  $E
	dc.b  $F	; 1
	dc.b $10	; 2
	dc.b $11	; 3
	dc.b $12	; 4
	dc.b   0	; 5
ObjC5_LaserCollisionData:
	dc.b $86
	dc.b $AB	; 1
	dc.b $AC	; 2
	dc.b $AD	; 3
	dc.b $AE	; 4
	dc.b   0	; 5
	even
; ===========================================================================

ObjC5_LaserMove:
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	rts
; ===========================================================================

ObjC5_Robotnik:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC5_RobotnikIndex(pc,d0.w),d1
	jmp	ObjC5_RobotnikIndex(pc,d1.w)
; ===========================================================================
ObjC5_RobotnikIndex: offsetTable
	offsetTableEntry.w ObjC5_RobotnikInit		; 0 - Loads art, animation and position
	offsetTableEntry.w ObjC5_RobotnikAnimate	; 2 - Animates Robotnik and waits till the case is defeated
	offsetTableEntry.w ObjC5_RobotnikDown		; 4 - Goes down until timer is up
; ===========================================================================

ObjC5_RobotnikInit:
	addq.b	#2,routine_secondary(a0)
	move.b	#0,mapping_frame(a0)
	move.b	#1,anim(a0)
	move.w	#$2C60,x_pos(a0)
	move.w	#$4E6,y_pos(a0)
	lea	(ChildObject_ObjC5RobotnikPlatform).l,a2
	bsr.w	LoadChildObject
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_RobotnikAnimate:
	movea.w	objoff_2C(a0),a1 ; a1=object (laser case)
	btst	#status.npc.p1_pushing,status(a1)
	bne.s	ObjC5_RobotnikTimer
	lea	(Ani_objC5_objC6).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_RobotnikTimer:		; Increase routine and set timer
	addq.b	#2,routine_secondary(a0)
	move.w	#$C0,objoff_2A(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_RobotnikDown:
	subq.w	#1,objoff_2A(a0)
	bmi.s	ObjC5_RobotnikDelete
	addq.w	#1,y_pos(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_RobotnikDelete:		; Deletes Robotnik and the platform he's on
	movea.w	parent(a0),a1 ; a1=object (Robotnik Platform)
	jsrto	JmpTo6_DeleteObject2
	jmpto	JmpTo65_DeleteObject
; ===========================================================================

ObjC5_RobotnikPlatform:	; Just displays the platform and move accordingly to the Robotnik object
	movea.w	objoff_2C(a0),a1 ; a1=object (Robotnik)
	move.w	y_pos(a1),d0
	addi.w	#$26,d0
	move.w	d0,y_pos(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
	; some unused/dead code, At one point it appears a section of the platform was solid
	move.w	x_pos(a0),-(sp)
	jsrto	JmpTo26_ObjectMove
	move.w	#$F,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	(sp)+,d4
	jmpto	JmpTo9_PlatformObject
; ===========================================================================

ObjC5_HandleHits:
	tst.b	collision_property(a0)
	beq.s	ObjC5_NoHitPointsLeft
	tst.b	collision_flags(a0)
	bne.s	return_3CC3A
	tst.b	objoff_30(a0)
	bne.s	ObjC5_FlashSetUp
	btst	#status.npc.p2_pushing,status(a0)
	beq.s	return_3CC3A
	move.b	#$20,objoff_30(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l

ObjC5_FlashSetUp:
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	ObjC5_FlashCollisionRestore
	move.w	#$EEE,d0

ObjC5_FlashCollisionRestore:
	move.w	d0,(a1)
	subq.b	#1,objoff_30(a0)
	bne.s	return_3CC3A
	btst	#status.npc.p2_standing,status(a0)	; makes sure the boss doesn't need collision
	beq.s	return_3CC3A
	move.b	#6,collision_flags(a0)	; restore collision

return_3CC3A:
	rts
; ===========================================================================

ObjC5_NoHitPointsLeft:	; when the boss is defeated this tells it what to do
	moveq	#100,d0
	bsr.w	AddPoints
	clr.b	collision_flags(a0)
	move.w	#$EF,objoff_30(a0)
	move.b	#$1E,routine_secondary(a0)
	bset	#status.npc.p1_pushing,status(a0)
	bclr	#status.npc.p2_pushing,status(a0)
	rts
; ===========================================================================
ChildObject_ObjC5LaserWall:		childObjectData objoff_2A, ObjID_WFZBoss, $94
ChildObject_ObjC5Platform:		childObjectData objoff_3E, ObjID_WFZBoss, $98
ChildObject_ObjC5PlatformHurt:		childObjectData objoff_3C, ObjID_WFZBoss, $9A
ChildObject_ObjC5LaserShooter:		childObjectData objoff_3C, ObjID_WFZBoss, $9C
ChildObject_ObjC5PlatformReleaser:	childObjectData objoff_3A, ObjID_WFZBoss, $96
ChildObject_ObjC5Laser:			childObjectData objoff_3E, ObjID_WFZBoss, $9E
ChildObject_ObjC5Robotnik:		childObjectData objoff_38, ObjID_WFZBoss, $A0
ChildObject_ObjC5RobotnikPlatform:	childObjectData objoff_3E, ObjID_WFZBoss, $A2

; off_3CC80:
ObjC5_SubObjData:		; Laser Case
	subObjData ObjC5_MapUnc_3CCD8,make_art_tile(ArtTile_ArtNem_WFZBoss,0,0),1<<render_flags.level_fg,4,$20,0
; off_3CC8A:
ObjC5_SubObjData2:		; Laser Walls
	subObjData ObjC5_MapUnc_3CCD8,make_art_tile(ArtTile_ArtNem_WFZBoss,0,0),1<<render_flags.level_fg,1,8,0
; off_3CC94:
ObjC5_SubObjData3:		; Platforms, platform releaser, laser and laser shooter
	subObjData ObjC5_MapUnc_3CCD8,make_art_tile(ArtTile_ArtNem_WFZBoss,0,0),1<<render_flags.level_fg,5,$10,0
; off_3CC9E:
ObjC6_SubObjData2:		; Robotnik
	subObjData ObjC6_MapUnc_3D0EE,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),1<<render_flags.level_fg,5,$20,0
; off_3CCA8:
ObjC5_SubObjData4:		; Robotnik platform
	subObjData ObjC5_MapUnc_3CEBC,make_art_tile(ArtTile_ArtNem_WfzFloatingPlatform,1,1),1<<render_flags.level_fg,5,$20,0

; animation script
; off_3CCB2:
Ani_objC5:	offsetTable
		offsetTableEntry.w byte_3CCBA	; 0
		offsetTableEntry.w byte_3CCC4	; 1
		offsetTableEntry.w byte_3CCCC	; 2
		offsetTableEntry.w byte_3CCD0	; 3
byte_3CCBA:	dc.b   5,  0,  1,  2,  3,  3,  3,  3,$FA,  0
byte_3CCC4:	dc.b   3,  3,  2,  1,  0,  0,$FA,  0
byte_3CCCC:	dc.b   3,  5,  6,$FF
byte_3CCD0:	dc.b   3,  7,  8,  9, $A, $B,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC5_MapUnc_3CCD8:	include "mappings/sprite/objC5_a.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC5_MapUnc_3CEBC:	include "mappings/sprite/objC5_b.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object C6 - Eggman
; ----------------------------------------------------------------------------
; Sprite_3CED0:
ObjC6:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC6_Index(pc,d0.w),d1
	jmp	ObjC6_Index(pc,d1.w)
; ===========================================================================
; off_3CEDE: ObjC6_States:
ObjC6_Index:	offsetTable
		offsetTableEntry.w ObjC6_Init	; 0
		offsetTableEntry.w ObjC6_State2	; 2
		offsetTableEntry.w ObjC6_State3	; 4
		offsetTableEntry.w ObjC6_State4	; 6
; ===========================================================================
; loc_3CEE6:
ObjC6_Init:
	bsr.w	LoadSubObject
	move.b	subtype(a0),d0
	subi.b	#$A4,d0
	move.b	d0,routine(a0) ; => ObjC6_State2, ObjC6_State3, or ObjC6_State4??
	rts
; ===========================================================================
; loc_3CEF8:
ObjC6_State2:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC6_State2_States(pc,d0.w),d1
	jmp	ObjC6_State2_States(pc,d1.w)
; ===========================================================================
; off_3CF06:
ObjC6_State2_States: offsetTable
	offsetTableEntry.w ObjC6_State2_State1	; 0
	offsetTableEntry.w ObjC6_State2_State2	; 2
	offsetTableEntry.w ObjC6_State2_State3	; 4
	offsetTableEntry.w ObjC6_State2_State4	; 6
	offsetTableEntry.w ObjC6_State2_State5	; 8
; ===========================================================================
; loc_3CF10:
ObjC6_State2_State1: ; a1=object (set in loc_3D94C)
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State2_State2
	lea	(ChildObject_3D0D0).l,a2
	bsr.w	LoadChildObject
	move.w	#$3F8,x_pos(a1)
	move.w	#$160,y_pos(a1)
	move.w	a0,(DEZ_Eggman).w
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CF32:
ObjC6_State2_State2:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$5C,d2
	cmpi.w	#$B8,d2
	blo.s	loc_3CF44
	jmpto	JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
loc_3CF44:
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State2_State3
	move.w	#$18,objoff_2A(a0)
	move.b	#1,mapping_frame(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CF58:
ObjC6_State2_State3:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3CF62
	jmpto	JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
loc_3CF62:
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State2_State4
	bset	#status.npc.misc,status(a0)
	move.w	#$200,x_vel(a0)
	move.w	#$10,objoff_2A(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CF7C:
ObjC6_State2_State4:
	cmpi.w	#$810,x_pos(a0)
	bhs.s	loc_3CFC0
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$50,d2
	cmpi.w	#$A0,d2
	bhs.s	+
	move.w	x_pos(a1),d0
	addi.w	#$50,d0
	move.w	d0,x_pos(a0)
+
	subq.w	#1,objoff_2A(a0)
	bpl.s	+
	move.w	#$20,objoff_2A(a0)
	bsr.w	loc_3D00C
+
	jsrto	JmpTo26_ObjectMove
	lea	(Ani_objC5_objC6).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3CFC0:
	move.b	#2,mapping_frame(a0)
	clr.w	x_vel(a0)
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.s	+
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State2_State5
	move.w	#$80,x_vel(a0)
	move.w	#-$200,y_vel(a0)
	move.b	#2,mapping_frame(a0)
	move.w	#$50,objoff_2A(a0)
	bset	#status.npc.p1_standing,status(a0)
+
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CFF6:
ObjC6_State2_State5:
	subq.w	#1,objoff_2A(a0)
	bmi.w	JmpTo65_DeleteObject
	addi.w	#$10,y_vel(a0)
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3D00C:
	lea	(ChildObject_3D0D4).l,a2
	bsr.w	LoadChildObject
	move.b	#$AA,subtype(a1) ; <== ObjC6_SubObjData
	move.b	#5,mapping_frame(a1)
	move.w	#-$100,x_vel(a1)
	subi.w	#$18,y_pos(a1)
	move.w	#8,objoff_2A(a1)
	rts
; ===========================================================================
; loc_3D036:
ObjC6_State3:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC6_State3_States(pc,d0.w),d1
	jmp	ObjC6_State3_States(pc,d1.w)
; ===========================================================================
; off_3D044:
ObjC6_State3_States: offsetTable
	offsetTableEntry.w ObjC6_State3_State1	; 0
	offsetTableEntry.w ObjC6_State3_State2	; 2
	offsetTableEntry.w ObjC6_State3_State3	; 4
; ===========================================================================
; loc_3D04A:
ObjC6_State3_State1:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.misc,status(a1)
	bne.s	loc_3D05E
	bsr.w	loc_3D086
	jmpto	JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
loc_3D05E:
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State3_State2
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3D066:
ObjC6_State3_State2:
	bsr.w	loc_3D086
	lea	(Ani_objC6).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; loc_3D078:
ObjC6_State3_State3:
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#status.npc.p1_pushing,status(a1)
	jmpto	JmpTo65_DeleteObject
; ===========================================================================

loc_3D086:
	move.w	x_pos(a0),-(sp)
	move.w	#$13,d1
	move.w	#$20,d2
	move.w	#$20,d3
	move.w	(sp)+,d4
	jmpto	JmpTo27_SolidObject
; ===========================================================================
; loc_3D09C:
ObjC6_State4:
	subq.w	#1,objoff_2A(a0)
	bmi.w	JmpTo65_DeleteObject
	addi.w	#$10,y_vel(a0)
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3D0B2:
ObjC6_SubObjData3:
	subObjData ObjC6_MapUnc_3D0EE,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),1<<render_flags.level_fg,5,$18,0
; off_3D0BC:
ObjC6_SubObjData4:
	subObjData ObjC6_MapUnc_3D1DE,make_art_tile(ArtTile_ArtNem_ConstructionStripes_1,1,0),1<<render_flags.level_fg,1,8,0
; off_3D0C6:
ObjC6_SubObjData:
	subObjData ObjC6_MapUnc_3D0EE,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),1<<render_flags.level_fg,5,4,0
ChildObject_3D0D0:	childObjectData objoff_3E, ObjID_Eggman, $A8
ChildObject_3D0D4:	childObjectData objoff_3C, ObjID_Eggman, $AA
; animation script
; off_3D0D8:
Ani_objC5_objC6:offsetTable
		offsetTableEntry.w byte_3D0DC	; 0
		offsetTableEntry.w byte_3D0E2	; 1
byte_3D0DC:	dc.b   5,  2,  3,  4,$FF,  0
byte_3D0E2:	dc.b   5,  6,  7,$FF
		even
; animation script
; off_3D0E6:
Ani_objC6:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,  3,$FA
		even
; ----------------------------------------------------------------------------
; sprite mappings ; Robotnik running
; ----------------------------------------------------------------------------
ObjC6_MapUnc_3D0EE:	include "mappings/sprite/objC6_a.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC6_MapUnc_3D1DE:	include "mappings/sprite/objC6_b.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object C8 - Crawl (shield badnik) from CNZ
; ----------------------------------------------------------------------------
; Sprite_3D23E:
ObjC8:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC8_Index(pc,d0.w),d1
	jmp	ObjC8_Index(pc,d1.w)
; ===========================================================================
; off_3D24C:
ObjC8_Index:	offsetTable
		offsetTableEntry.w ObjC8_Init	; 0
		offsetTableEntry.w loc_3D27C	; 2
		offsetTableEntry.w loc_3D2A6	; 4
		offsetTableEntry.w loc_3D2D4	; 6
; ===========================================================================
; loc_3D254:
ObjC8_Init:
	bsr.w	LoadSubObject
	move.w	#$200,objoff_2A(a0)
	moveq	#$20,d0
	btst	#render_flags.x_flip,render_flags(a0)
	bne.s	+
	neg.w	d0
+
	move.w	d0,x_vel(a0)
	move.b	#$F,y_radius(a0)
	move.b	#$10,x_radius(a0)
	rts
; ===========================================================================

loc_3D27C:
	subq.w	#1,objoff_2A(a0)
	beq.s	+
	jsrto	JmpTo26_ObjectMove
	bsr.w	loc_3D416
	lea	(Ani_objC8).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	#$3B,objoff_2A(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3D2A6:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	bsr.w	loc_3D416
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
+
	move.b	#2,routine(a0)
	move.w	#$200,objoff_2A(a0)
	neg.w	x_vel(a0)
	bchg	#render_flags.x_flip,render_flags(a0)
	bchg	#status.npc.x_flip,status(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3D2D4:
	move.b	#$D7,collision_flags(a0)
	bsr.w	Obj_GetOrientationToPlayer
	move.w	d2,d4
	addi.w	#$40,d2
	cmpi.w	#$80,d2
	bhs.w	loc_3D39A
	addi.w	#$40,d3
	cmpi.w	#$80,d3
	bhs.w	loc_3D39A
	bclr	#status.npc.p1_standing,status(a0)
	bne.w	loc_3D386
	move.b	collision_property(a0),d0
	beq.s	BranchTo18_JmpTo39_MarkObjGone
	bclr	#0,collision_property(a0)
	beq.s	+++
	cmpi.b	#AniIDSonAni_Roll,anim(a1)
	bne.s	loc_3D36C
	btst	#status.player.in_air,status(a1)
	bne.s	++
	bsr.w	Obj_GetOrientationToPlayer
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	subq.w	#2,d0
+
	tst.w	d0
	bne.s	loc_3D390
+
	bsr.s	loc_3D3A4
+
	lea	(Sidekick).w,a1 ; a1=character
	bclr	#1,collision_property(a0)
	beq.s	+++
	cmpi.b	#AniIDSonAni_Roll,anim(a1)
	bne.s	loc_3D36C
	btst	#status.player.in_air,status(a1)
	bne.s	++
	bsr.w	Obj_GetOrientationToPlayer
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	subq.w	#2,d0
+
	tst.w	d0
	bne.s	loc_3D390
+
	bsr.s	loc_3D3A4
+
	clr.b	collision_property(a0)

BranchTo18_JmpTo39_MarkObjGone ; BranchTo
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3D36C:
	move.b	#$97,collision_flags(a0)
	btst	#status_secondary.invincible,status_secondary(a1)
	beq.s	+
	move.b	#$17,collision_flags(a0)
+
	bset	#status.npc.p1_standing,status(a0)

loc_3D386:
	move.b	#1,mapping_frame(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3D390:
	move.b	#$17,collision_flags(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3D39A:
	move.b	objoff_2C(a0),routine(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3D3A4:
	move.b	#2,mapping_frame(a0)
	btst	#status.player.in_air,status(a1)
	beq.s	+
	move.b	#3,mapping_frame(a0)
+
	move.w	x_pos(a0),d1
	move.w	y_pos(a0),d2
	sub.w	x_pos(a1),d1
	sub.w	y_pos(a1),d2
	jsr	(CalcAngle).l
	move.b	(Level_frame_counter).w,d1
	andi.w	#3,d1
	add.w	d1,d0
	jsr	(CalcSine).l
	muls.w	#-$700,d1
	asr.l	#8,d1
	move.w	d1,x_vel(a1)
	muls.w	#-$700,d0
	asr.l	#8,d0
	move.w	d0,y_vel(a1)
	bset	#status.player.in_air,status(a1)
	bclr	#status.player.rolljumping,status(a1)
	bclr	#status.player.pushing,status(a1)
	clr.b	jumping(a1)
	move.w	#SndID_Bumper,d0
	jsr	(PlaySound).l
	rts
; ===========================================================================
	; unused
	rts
; ===========================================================================

loc_3D416:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$40,d2
	cmpi.w	#$80,d2
	bhs.s	+	; rts
	addi.w	#$40,d3
	cmpi.w	#$80,d3
	bhs.s	+	; rts
	move.b	routine(a0),objoff_2C(a0)
	move.b	#6,routine(a0)
	clr.b	mapping_frame(a0)
+
	rts
; ===========================================================================
; off_3D440:
ObjC8_SubObjData:
	subObjData ObjC8_MapUnc_3D450,make_art_tile(ArtTile_ArtNem_Crawl,0,1),1<<render_flags.level_fg,3,$10,$D7
; animation script
; off_3D44A:
Ani_objC8:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b $13,  0,  1,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings ; Crawl CNZ
; ----------------------------------------------------------------------------
ObjC8_MapUnc_3D450:	include "mappings/sprite/objC8.asm"




; ===========================================================================
; ----------------------------------------------------------------------------
; Object C7 - Eggrobo (final boss) from Death Egg
; ----------------------------------------------------------------------------
; Sprite_3D4C8:
ObjC7:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC7_Index(pc,d0.w),d1
	jmp	ObjC7_Index(pc,d1.w)
; ===========================================================================
; off_3D4D6:
ObjC7_Index:	offsetTable
		offsetTableEntry.w ObjC7_Init	;   0
		offsetTableEntry.w ObjC7_Body	;   2
		offsetTableEntry.w ObjC7_Shoulder	;   4
		offsetTableEntry.w ObjC7_FrontLowerLeg	;   6
		offsetTableEntry.w ObjC7_FrontForearm	;   8
		offsetTableEntry.w ObjC7_Arm	;  $A
		offsetTableEntry.w ObjC7_FrontThigh	;  $C
		offsetTableEntry.w ObjC7_Head	;  $E
		offsetTableEntry.w ObjC7_Jet	; $10
		offsetTableEntry.w ObjC7_BackLowerLeg	; $12
		offsetTableEntry.w ObjC7_BackForearm	; $14
		offsetTableEntry.w ObjC7_BackThigh	; $16
		offsetTableEntry.w ObjC7_TargettingSensor	; $18
		offsetTableEntry.w ObjC7_TargettingLock	; $1A
		offsetTableEntry.w ObjC7_EggmanBomb	; $1C
		offsetTableEntry.w ObjC7_FallingPieces	; $1E
		offsetTableEntry.w ObjC7_SetupEnding	; $20
; ===========================================================================
; loc_3D4F8:
ObjC7_Init:
	lea	ObjC7_SubObjData(pc),a1
	bsr.w	LoadSubObject_Part3
	move.b	subtype(a0),routine(a0)
	rts
; ===========================================================================
;loc_3D508
ObjC7_Body:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3D51A(pc,d0.w),d1
	jsr	off_3D51A(pc,d1.w)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3D51A:	offsetTable
		offsetTableEntry.w loc_3D52A	;  0
		offsetTableEntry.w loc_3D5A8	;  2
		offsetTableEntry.w loc_3D5C2	;  4
		offsetTableEntry.w loc_3D5EA	;  6
		offsetTableEntry.w loc_3D62E	;  8
		offsetTableEntry.w loc_3D640	; $A
		offsetTableEntry.w loc_3D684	; $C
		offsetTableEntry.w loc_3D8D2	; $E
; ===========================================================================

loc_3D52A:
	addq.b	#2,routine_secondary(a0)
	move.b	#3,mapping_frame(a0)
	move.b	#5,priority(a0)
	lea	(ChildObjC7_Shoulder).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_FrontForearm).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_FrontLowerLeg).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_Arm).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_FrontThigh).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_Head).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_Jet).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_BackLowerLeg).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_BackForearm).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_BackThigh).l,a2
	bsr.w	LoadChildObject
	lea	(ObjC7_ChildDeltas).l,a1
	bra.w	ObjC7_PositionChildren
; ===========================================================================

loc_3D5A8:
	btst	#status.npc.misc,status(a0)
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.b	#60,anim_frame_duration(a0)
	moveq	#signextendB(MusID_FadeOut),d0
	jmpto	JmpTo12_PlaySound
; ===========================================================================

loc_3D5C2:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.b	#$79,anim_frame_duration(a0)
	move.w	#-$100,y_vel(a0)
	movea.w	objoff_38(a0),a1 ; a1=object
	move.b	#4,routine_secondary(a1)
	moveq	#signextendB(MusID_EndBoss),d0
	jmpto	JmpTo5_PlayMusic
; ===========================================================================

loc_3D5EA:
	subq.b	#1,anim_frame_duration(a0)
	beq.s	+
	moveq	#signextendB(SndID_Rumbling),d0
	jsrto	JmpTo12_PlaySound
	jsrto	JmpTo26_ObjectMove
	lea	(ObjC7_ChildDeltas).l,a1
	bra.w	ObjC7_PositionChildren
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	clr.w	y_vel(a0)
	move.b	#$1F,anim_frame_duration(a0)
	move.b	#$16,collision_flags(a0)
	move.b	#$C,collision_property(a0)
	bsr.w	ObjC7_InitCollision
	movea.w	objoff_38(a0),a1 ; a1=object
	move.b	#6,routine_secondary(a1)
	rts
; ===========================================================================

loc_3D62E:
	bsr.w	ObjC7_CheckHit
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	rts
; ===========================================================================

loc_3D640:
	bsr.w	ObjC7_CheckHit
	addq.b	#2,routine_secondary(a0)
	move.b	#$20,anim_frame_duration(a0)
	move.b	angle(a0),d0
	addq.b	#1,d0
	move.b	d0,angle(a0)
	andi.w	#3,d0
	move.b	byte_3D680(pc,d0.w),d0
	move.b	d0,anim(a0)
	clr.b	prev_anim(a0)
	cmpi.b	#2,d0
	bne.s	+	; rts
	movea.w	objoff_38(a0),a1 ; a1=object
	move.b	#4,routine_secondary(a1)
	move.b	#2,anim(a1)
+
	rts
; ===========================================================================
byte_3D680:
	dc.b   2
	dc.b   0	; 1
	dc.b   2	; 2
	dc.b   4	; 3
	even
; ===========================================================================

loc_3D684:
	bsr.w	ObjC7_CheckHit
	moveq	#0,d0
	move.b	anim(a0),d0
	move.w	off_3D696(pc,d0.w),d1
	jmp	off_3D696(pc,d1.w)
; ===========================================================================
off_3D696:	offsetTable
		offsetTableEntry.w loc_3D6AA	; 0
		offsetTableEntry.w loc_3D702	; 2
		offsetTableEntry.w loc_3D83C	; 4
; ===========================================================================
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,anim(a0)
	rts
; ===========================================================================

loc_3D6AA:
	moveq	#0,d0
	move.b	prev_anim(a0),d0
	move.w	off_3D6B8(pc,d0.w),d1
	jmp	off_3D6B8(pc,d1.w)
; ===========================================================================
off_3D6B8:	offsetTable
		offsetTableEntry.w loc_3D6C0	; 0
		offsetTableEntry.w loc_3D6CE	; 2
		offsetTableEntry.w loc_3D6C0	; 4
		offsetTableEntry.w loc_3D6E8	; 6
; ===========================================================================

loc_3D6C0:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	rts
; ===========================================================================

loc_3D6CE:
	lea	(off_3E40C).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	move.b	#$40,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D6E8:
	lea	(off_3E42C).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	subq.b	#2,routine_secondary(a0)
	move.b	#$40,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D702:
	moveq	#0,d0
	move.b	prev_anim(a0),d0
	move.w	off_3D710(pc,d0.w),d1
	jmp	off_3D710(pc,d1.w)
; ===========================================================================
off_3D710:	offsetTable
		offsetTableEntry.w loc_3D6C0	;  0
		offsetTableEntry.w loc_3D720	;  2
		offsetTableEntry.w loc_3D744	;  4
		offsetTableEntry.w loc_3D6C0	;  6
		offsetTableEntry.w loc_3D784	;  8
		offsetTableEntry.w loc_3D7B8	; $A
		offsetTableEntry.w loc_3D7F0	; $C
		offsetTableEntry.w loc_3D82E	; $C
; ===========================================================================

loc_3D720:
	lea	(off_3E3D0).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	move.b	#$80,anim_frame_duration(a0)
	clr.w	x_vel(a0)
	move.w	#-$200,y_vel(a0)
	rts
; ===========================================================================

loc_3D744:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	++
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+
	moveq	#signextendB(SndID_Fire),d0
	jsrto	JmpTo_PlaySoundLocal
+
	jsrto	JmpTo26_ObjectMove
	lea	(ObjC7_ChildDeltas).l,a1
	bra.w	ObjC7_PositionChildren
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	clr.w	y_vel(a0)
	lea	(ChildObjC7_TargettingSensor).l,a2
	bsr.w	LoadChildObject
	clr.w	x_vel(a0)
	clr.w	objoff_28(a0)
	rts
; ===========================================================================

loc_3D784:
	move.w	objoff_28(a0),d0
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	move.w	d0,x_pos(a0)
	bclr	#render_flags.x_flip,render_flags(a0)
	cmpi.w	#$780,d0
	bhs.s	+
	bset	#render_flags.x_flip,render_flags(a0)
+
	bsr.w	loc_3E168
	move.w	#$800,y_vel(a0)
	move.b	#$20,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D7B8:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	jsrto	JmpTo26_ObjectMove
	lea	(ObjC7_ChildDeltas).l,a1
	bra.w	ObjC7_PositionChildren
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	clr.w	y_vel(a0)
	move.b	#1,(Screen_Shaking_Flag).w
	move.w	#$40,(DEZ_Shake_Timer).w
	movea.w	objoff_38(a0),a1 ; a1=object
	move.b	#6,routine_secondary(a1)
	moveq	#signextendB(SndID_Smash),d0
	jmpto	JmpTo12_PlaySound
; ===========================================================================

loc_3D7F0:
	lea	(off_3E30A).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	lea	(ObjC7_ChildDeltas).l,a1
	bsr.w	ObjC7_PositionChildren
	bsr.w	Obj_GetOrientationToPlayer
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	subq.w	#2,d0
+
	tst.w	d0
	bne.s	+
	subq.b	#2,routine_secondary(a0)
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	move.b	#$60,anim_frame_duration(a0)
	bra.w	CreateEggmanBombs
; ===========================================================================

loc_3D82E:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	subq.b	#2,routine_secondary(a0)
	rts
; ===========================================================================

loc_3D83C:
	moveq	#0,d0
	move.b	prev_anim(a0),d0
	move.w	off_3D84A(pc,d0.w),d1
	jmp	off_3D84A(pc,d1.w)
; ===========================================================================
off_3D84A:	offsetTable
		offsetTableEntry.w loc_3D6C0	;  0
		offsetTableEntry.w loc_3D856	;  2
		offsetTableEntry.w loc_3D6C0	;  4
		offsetTableEntry.w loc_3D89E	;  6
		offsetTableEntry.w loc_3D6C0	;  8
		offsetTableEntry.w loc_3D8B8	; $A
; ===========================================================================

loc_3D856:
	bset	#status.npc.p2_pushing,status(a0)
	lea	(off_3E2F6).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	bsr.w	Obj_GetOrientationToPlayer
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	subq.w	#2,d0
+
	tst.w	d0
	bne.s	+
	addq.b	#2,prev_anim(a0)
	move.b	#$40,anim_frame_duration(a0)
	bset	#status.npc.p2_standing,status(a0)
	rts
; ---------------------------------------------------------------------------
+
	move.b	#8,prev_anim(a0)
	move.b	#$20,anim_frame_duration(a0)
	bra.w	CreateEggmanBombs
; ===========================================================================

loc_3D89E:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	bset	#status.npc.p1_pushing,status(a0)
	move.b	#$40,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D8B8:
	lea	(off_3E300).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	subq.b	#2,routine_secondary(a0)
	bclr	#status.npc.p2_pushing,status(a0)
	rts
; ===========================================================================

loc_3D8D2:
	moveq	#0,d0
	move.b	anim(a0),d0
	move.w	off_3D8E0(pc,d0.w),d1
	jmp	off_3D8E0(pc,d1.w)
; ===========================================================================
off_3D8E0:	offsetTable
		offsetTableEntry.w loc_3D8E6	; 0
		offsetTableEntry.w loc_3D922	; 2
		offsetTableEntry.w loc_3D93C	; 4
; ===========================================================================

loc_3D8E6:
	jsrto	JmpTo_Boss_LoadExplosion
	jsrto	JmpTo8_ObjectMoveAndFall
	move.w	y_pos(a0),d0
	cmpi.w	#$15C,d0
	bhs.s	+
	rts
; ---------------------------------------------------------------------------
+
	move.w	#$15C,y_pos(a0)
	move.w	y_vel(a0),d0
	bmi.s	+
	lsr.w	#2,d0
	cmpi.w	#$100,d0
	blo.s	+
	neg.w	d0
	move.w	d0,y_vel(a0)
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,anim(a0)
	move.b	#$40,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D922:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	jmpto	JmpTo_Boss_LoadExplosion
; ---------------------------------------------------------------------------
+
	addq.b	#2,anim(a0)
	st.b	(Control_Locked).w
	move.w	#$1000,(Camera_Max_X_pos).w
	rts
; ===========================================================================

loc_3D93C:
	move.w	#(button_right_mask<<8)|button_right_mask,(Ctrl_1_Logical).w
	cmpi.w	#$840,(Camera_X_pos).w
	bhs.s	+
	rts
; ---------------------------------------------------------------------------
+
	move.b	#$20,routine(a0)
	clr.b	routine_secondary(a0)
	move.w	#$20,objoff_2A(a0)
	move.b	#1,(Screen_Shaking_Flag).w
	move.w	#$1000,(DEZ_Shake_Timer).w
	movea.w	objoff_36(a0),a1 ; a1=object
	jmpto	JmpTo6_DeleteObject2
; ===========================================================================
;loc_3D970
ObjC7_SetupEnding:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+
	; PlaySound ends up being clogged up by the explosion sounds, both in
	; the queue and sound channels, meaning this is effectively useless.
	moveq	#signextendB(SndID_Rumbling2),d0
	jsrto	JmpTo12_PlaySound
	subq.w	#1,objoff_2A(a0)
+
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),d0
	sub.w	objoff_2A(a0),d0
	move.w	d0,x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	bsr.w	loc_3DFBA
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3D9AC(pc,d0.w),d1
	jmp	off_3D9AC(pc,d1.w)
; ===========================================================================
off_3D9AC:	offsetTable
		offsetTableEntry.w loc_3D9B0	; 0
		offsetTableEntry.w loc_3D9D6	; 2
; ===========================================================================

loc_3D9B0:
	lea	(MainCharacter).w,a1 ; a1=character
	cmpi.w	#$EC0,x_pos(a1)
	bhs.s	loc_3D9BE
	rts
; ===========================================================================

loc_3D9BE:
	addq.b	#2,routine_secondary(a0)
	move.w	#$3F,(Palette_fade_range).w
	move.b	#$16,anim_frame_duration(a0)
	move.w	#$7FFF,(PalCycle_Timer).w
	rts
; ===========================================================================

loc_3D9D6:
	subq.b	#1,anim_frame_duration(a0)
	beq.w	+
	movea.l	a0,a1
	lea	(Normal_palette).w,a0

	moveq	#$3F,d0
-	jsrto	JmpTo_Pal_FadeToWhite.UpdateColour
	dbf	d0,-
	movea.l	a1,a0
	rts
; ---------------------------------------------------------------------------
+
	move.l	#$EEE0EEE,d0
	lea	(Normal_palette).w,a1

	moveq	#$1F,d6
-	move.l	d0,(a1)+
	dbf	d6,-

	moveq	#signextendB(MusID_FadeOut),d0
    if fixBugs
	jsr	(PlayMusic).l
    else
	; PlaySound ends up being clogged up by the explosion sounds, 
	; preventing the music from fading out as it should.
	jsrto	JmpTo12_PlaySound
    endif
	move.b	#GameModeID_EndingSequence,(Game_Mode).w ; => EndingSequence
	jmpto	JmpTo65_DeleteObject
; ===========================================================================

ObjC7_Shoulder:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DA34(pc,d0.w),d1
	jsr	off_3DA34(pc,d1.w)
	lea	byte_3DA38(pc),a1
	bsr.w	loc_3E282
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DA34:	offsetTable
		offsetTableEntry.w loc_3DA3C	; 0
		offsetTableEntry.w return_3DA48	; 2
; ===========================================================================
byte_3DA38:
	dc.w   $C
	dc.w -$14
; ===========================================================================

loc_3DA3C:
	addq.b	#2,routine_secondary(a0)
	move.b	#4,mapping_frame(a0)
	rts
; ===========================================================================

return_3DA48:
	rts
; ===========================================================================
;loc_3DA4A
ObjC7_FrontLowerLeg:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DA62(pc,d0.w),d1
	jsr	off_3DA62(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DA62:	offsetTable
		offsetTableEntry.w loc_3DA66	; 0
		offsetTableEntry.w return_3DA72	; 2
; ===========================================================================

loc_3DA66:
	addq.b	#2,routine_secondary(a0)
	move.b	#$B,mapping_frame(a0)
	rts
; ===========================================================================

return_3DA72:
	rts
; ===========================================================================
;loc_3DA74
ObjC7_FrontForearm:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DA96(pc,d0.w),d1
	jsr	off_3DA96(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	btst	#status.npc.p2_pushing,status(a0)
	bne.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DA96:	offsetTable
		offsetTableEntry.w loc_3DAA0	; 0
		offsetTableEntry.w loc_3DAAC	; 2
		offsetTableEntry.w loc_3DACC	; 4
		offsetTableEntry.w loc_3DB32	; 6
		offsetTableEntry.w loc_3DB5A	; 8
; ===========================================================================

loc_3DAA0:
	addq.b	#2,routine_secondary(a0)
	move.b	#6,mapping_frame(a0)
	rts
; ===========================================================================

loc_3DAAC:
	movea.w	objoff_2C(a0),a1 ; a1=object
	bclr	#status.npc.p2_standing,status(a1)
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$10,objoff_2A(a0)
	move.w	y_pos(a0),objoff_2E(a0)
	rts
; ===========================================================================

loc_3DACC:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	addi.w	#$20,y_vel(a0)
	jmpto	JmpTo26_ObjectMove
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$20,objoff_2A(a0)
	bsr.w	Obj_GetOrientationToPlayer
	abs.w	d2
	cmpi.w	#$100,d2
	blo.s	+
	move.w	#$FF,d2
+
	andi.w	#$C0,d2
	lsr.w	#5,d2
	move.w	word_3DB2A(pc,d2.w),d2
	tst.w	d1
	bne.s	+
	neg.w	d2
+
	move.w	d2,y_vel(a0)
	move.w	#$800,d2
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#render_flags.x_flip,render_flags(a0)
	bne.s	+
	neg.w	d2
+
	move.w	d2,x_vel(a0)
	moveq	#signextendB(SndID_SpindashRelease),d0
	jmpto	JmpTo12_PlaySound
; ===========================================================================
word_3DB2A:
	dc.w  $200
	dc.w  $100	; 1
	dc.w   $80	; 2
	dc.w	 0	; 3
; ===========================================================================

loc_3DB32:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	jmpto	JmpTo26_ObjectMove
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	neg.w	x_vel(a0)
	move.w	#$20,objoff_2A(a0)
	move.w	objoff_2E(a0),d0
	sub.w	y_pos(a0),d0
	asl.w	#3,d0
	move.w	d0,y_vel(a0)
	rts
; ===========================================================================

loc_3DB5A:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	jmpto	JmpTo26_ObjectMove
; ---------------------------------------------------------------------------
+
	move.b	#2,routine_secondary(a0)
	clr.w	x_vel(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================
;loc_3DB74
ObjC7_Arm:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DB8C(pc,d0.w),d1
	jsr	off_3DB8C(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DB8C:	offsetTable
		offsetTableEntry.w loc_3DB90	; 0
		offsetTableEntry.w return_3DB9C	; 2
; ===========================================================================

loc_3DB90:
	addq.b	#2,routine_secondary(a0)
	move.b	#5,mapping_frame(a0)
	rts
; ===========================================================================

return_3DB9C:
	rts
; ===========================================================================
;loc_3DB9E
ObjC7_FrontThigh:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DBB6(pc,d0.w),d1
	jsr	off_3DBB6(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DBB6:	offsetTable
		offsetTableEntry.w loc_3DBBA	; 0
		offsetTableEntry.w return_3DBC6	; 2
; ===========================================================================

loc_3DBBA:
	addq.b	#2,routine_secondary(a0)
	move.b	#$A,mapping_frame(a0)
	rts
; ===========================================================================

return_3DBC6:
	rts
; ===========================================================================
;loc_3DBC8
ObjC7_Head:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DBE8(pc,d0.w),d1
	jsr	off_3DBE8(pc,d1.w)
	lea	byte_3DBF2(pc),a1
	bsr.w	loc_3E282
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DBE8:	offsetTable
		offsetTableEntry.w loc_3DBF6	; 0
		offsetTableEntry.w loc_3DC02	; 2
		offsetTableEntry.w loc_3DC1C	; 4
		offsetTableEntry.w loc_3DC2A	; 6
		offsetTableEntry.w loc_3DC46	; 8
; ===========================================================================
byte_3DBF2:
	dc.w    0
	dc.w -$34
; ===========================================================================

loc_3DBF6:
	addq.b	#2,routine_secondary(a0)
	move.b	#$15,mapping_frame(a0)
	rts
; ===========================================================================

loc_3DC02:
	movea.w	(DEZ_Eggman).w,a1
	btst	#status.npc.p1_standing,status(a1)
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)
	rts
; ===========================================================================

loc_3DC1C:
	lea	(Ani_objC7_a).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DC2A:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	jmpto	JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	movea.w	objoff_2C(a0),a1 ; a1=object
	bset	#status.npc.misc,status(a1)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DC46:
	move.b	#-1,collision_property(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
;loc_3DC50
ObjC7_Jet:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DC66(pc,d0.w),d1
	jsr	off_3DC66(pc,d1.w)
	lea	byte_3DC70(pc),a1
	bra.w	loc_3E282
; ===========================================================================
off_3DC66:	offsetTable
		offsetTableEntry.w loc_3DC74
		offsetTableEntry.w loc_3DC80
		offsetTableEntry.w loc_3DC86
		offsetTableEntry.w loc_3DC94
		offsetTableEntry.w loc_3DC80
; ===========================================================================
byte_3DC70:
	dc.w  $38
	dc.w  $18
; ===========================================================================

loc_3DC74:
	addq.b	#2,routine_secondary(a0)
	move.b	#$C,mapping_frame(a0)
	rts
; ===========================================================================

loc_3DC80:
	move.b	#3,anim(a0)

loc_3DC86:
	lea	(Ani_objC7_b).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DC94:
	move.b	#1,anim(a0)
	bra.s	loc_3DC86
; ===========================================================================
;loc_3DC9C
ObjC7_BackLowerLeg:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DCB4(pc,d0.w),d1
	jsr	off_3DCB4(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DCB4:	offsetTable
		offsetTableEntry.w loc_3DCB8	; 0
		offsetTableEntry.w return_3DCCA	; 2
; ===========================================================================

loc_3DCB8:
	addq.b	#2,routine_secondary(a0)
	move.b	#$B,mapping_frame(a0)
	move.b	#5,priority(a0)
	rts
; ===========================================================================

return_3DCCA:
	rts
; ===========================================================================
;loc_3DCCC
ObjC7_BackForearm:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DCE4(pc,d0.w),d1
	jsr	off_3DCE4(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DCE4:	offsetTable
		offsetTableEntry.w loc_3DCEE	; 0
		offsetTableEntry.w loc_3DD00	; 2
		offsetTableEntry.w loc_3DACC	; 4
		offsetTableEntry.w loc_3DB32	; 6
		offsetTableEntry.w loc_3DB5A	; 8
; ===========================================================================

loc_3DCEE:
	addq.b	#2,routine_secondary(a0)
	move.b	#6,mapping_frame(a0)
	move.b	#5,priority(a0)
	rts
; ===========================================================================

loc_3DD00:
	movea.w	objoff_2C(a0),a1 ; a1=object
	bclr	#status.npc.p1_pushing,status(a1)
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$10,objoff_2A(a0)
	move.w	y_pos(a0),objoff_2E(a0)
	rts
; ===========================================================================
;loc_3DD20
ObjC7_BackThigh:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DD38(pc,d0.w),d1
	jsr	off_3DD38(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DD38:	offsetTable
		offsetTableEntry.w loc_3DD3C	; 0
		offsetTableEntry.w return_3DD4E	; 2
; ===========================================================================

loc_3DD3C:
	addq.b	#2,routine_secondary(a0)
	move.b	#$A,mapping_frame(a0)
	move.b	#5,priority(a0)
	rts
; ===========================================================================

return_3DD4E:
	rts
; ===========================================================================
;loc_3DD50
ObjC7_TargettingSensor:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DD5E(pc,d0.w),d1
	jmp	off_3DD5E(pc,d1.w)
; ===========================================================================
off_3DD5E:	offsetTable
		offsetTableEntry.w loc_3DD64	; 0
		offsetTableEntry.w loc_3DDA6	; 2
		offsetTableEntry.w loc_3DE3C	; 4
; ===========================================================================

loc_3DD64:
	addq.b	#2,routine_secondary(a0)
	move.b	#$10,mapping_frame(a0)
	ori.w	#high_priority,art_tile(a0)
	move.b	#1,priority(a0)
	move.w	#$A0,objoff_2A(a0)
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.w	x_vel(a1),objoff_30(a0)
	move.w	y_vel(a1),objoff_32(a0)
	move.w	#$18,angle(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DDA6:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3DE0A
	lea	next_object(a0),a1 ; a1=object
	movea.l	a1,a2
	move.w	-(a1),y_vel(a0)
	move.w	-(a1),x_vel(a0)

	moveq	#2,d6
-	move.l	-(a1),-(a2)
	dbf	d6,-

	lea	(MainCharacter).w,a2 ; a2=character
	move.w	x_vel(a2),d0
	bne.s	+
	move.w	x_pos(a2),x_pos(a0)
+
	move.w	d0,(a1)+
	move.w	y_vel(a2),d0
	bne.s	+
	move.w	y_pos(a2),y_pos(a0)
+
	move.w	d0,(a1)+
	jsrto	JmpTo26_ObjectMove
	lea	(Ani_objC7_c).l,a1
	jsrto	JmpTo25_AnimateSprite
	subq.b	#1,angle(a0)
	bpl.s	+
	subq.b	#1,objoff_27(a0)
	move.b	objoff_27(a0),angle(a0)
	moveq	#signextendB(SndID_Beep),d0
	jsrto	JmpTo12_PlaySound
+
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DE0A:
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)
	move.b	#4,angle(a0)
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	lea	(ChildObjC7_TargettingLock).l,a2
	bsr.w	LoadChildObject
	clr.w	x_vel(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DE3C:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3DE62
	lea	(Ani_objC7_c).l,a1
	jsrto	JmpTo25_AnimateSprite
	subq.b	#1,angle(a0)
	bpl.s	+
	move.b	#4,angle(a0)
	moveq	#signextendB(SndID_Beep),d0
	jsrto	JmpTo12_PlaySound
+
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DE62:
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.w	x_pos(a0),objoff_28(a1)
	jmpto	JmpTo65_DeleteObject
; ===========================================================================
;loc_3DE70
ObjC7_TargettingLock:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DE7E(pc,d0.w),d1
	jmp	off_3DE7E(pc,d1.w)
; ===========================================================================
off_3DE7E:	offsetTable
		offsetTableEntry.w loc_3DE82	; 0
		offsetTableEntry.w loc_3DEA2	; 2
; ===========================================================================

loc_3DE82:
	addq.b	#2,routine_secondary(a0)
	move.b	#$14,mapping_frame(a0)
	move.b	#1,priority(a0)
	ori.w	#high_priority,art_tile(a0)
	move.w	#4,objoff_2A(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DEA2:
	movea.w	objoff_2C(a0),a1 ; a1=object
	tst.b	(a1)
	beq.w	JmpTo65_DeleteObject
	subq.w	#1,objoff_2A(a0)
	bne.s	+
	move.w	#4,objoff_2A(a0)
	bchg	#palette_bit_0,art_tile(a0)
+
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
;loc_3DEC2
ObjC7_EggmanBomb:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DED0(pc,d0.w),d1
	jmp	off_3DED0(pc,d1.w)
; ===========================================================================
off_3DED0:	offsetTable
		offsetTableEntry.w loc_3DED8
		offsetTableEntry.w loc_3DF04
		offsetTableEntry.w loc_3DF36
		offsetTableEntry.w loc_3DF80
; ===========================================================================

loc_3DED8:
	addq.b	#2,routine_secondary(a0)
	move.b	#$E,mapping_frame(a0)
	move.b	#$89,collision_flags(a0)
	move.b	#5,priority(a0)
	move.b	#$C,width_pixels(a0)
	lea	byte_3DF00(pc),a1
	bsr.w	loc_3E282
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
byte_3DF00:
	dc.w  $38
	dc.w -$14
; ===========================================================================

loc_3DF04:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.no_balancing,status(a1)
	bne.s	loc_3DF4C
	jsrto	JmpTo8_ObjectMoveAndFall
	move.w	y_pos(a0),d0
	cmpi.w	#$170,d0
	bhs.s	+
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$170,y_pos(a0)
	move.w	#$40,objoff_2A(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DF36:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.no_balancing,status(a1)
	bne.s	loc_3DF4C
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3DF4C
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DF4C:
	move.b	#6,routine_secondary(a0)
	move.l	#Obj58_MapUnc_2D50A,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_FieryExplosion,0,0),art_tile(a0)
	move.b	#1,priority(a0)
	move.b	#7,anim_frame_duration(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#SndID_BossExplosion,d0
	jsr	(PlaySound).l
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DF80:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#5,mapping_frame(a0)
	blo.s	+
	clr.b	collision_flags(a0)
	cmpi.b	#7,mapping_frame(a0)
	beq.w	JmpTo65_DeleteObject
+
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
;loc_3DFAA
ObjC7_FallingPieces:
	subq.w	#1,objoff_2A(a0)
	bmi.w	JmpTo65_DeleteObject
	jsrto	JmpTo8_ObjectMoveAndFall
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DFBA:
	jsr	(AllocateObject).l
	bne.s	+	; rts
	_move.b	#ObjID_BossExplosion,id(a1) ; load obj
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	jsr	(RandomNumber).l
	move.w	d0,d1
	moveq	#0,d1
	move.b	d0,d1
	lsr.b	#2,d1
	subi.w	#$30,d1
	add.w	d1,x_pos(a1)
	lsr.w	#8,d0
	lsr.b	#2,d0
	subi.w	#$30,d0
	add.w	d0,y_pos(a1)
+
	rts
; ===========================================================================
;loc_3DFF8
ObjC7_CheckHit:
	tst.b	collision_property(a0)
	beq.s	ObjC7_Beaten
	tst.b	objoff_2A(a0)
	bne.s	ObjC7_Flashing
	tst.b	collision_flags(a0)
	beq.s	+
	movea.w	objoff_36(a0),a1 ; a1=object
	tst.b	collision_flags(a1)
	bne.s	+++		; rts
	clr.b	collision_flags(a0)
	subq.b	#1,collision_property(a0)
	beq.s	ObjC7_Beaten
+
	move.b	#60,objoff_2A(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l
;loc_3E02E
ObjC7_Flashing:
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	+
	move.w	#$EEE,d0
+
	move.w	d0,(a1)
	subq.b	#1,objoff_2A(a0)
	bne.s	+
	clr.w	(Normal_palette_line2+2).w
	move.b	#$16,collision_flags(a0)
	movea.w	objoff_36(a0),a1 ; a1=object
	move.b	#$2A,collision_flags(a1)
+
	rts
; ===========================================================================
;loc_3E05A
ObjC7_Beaten:
	moveq	#100,d0
	bsr.w	AddPoints
	clr.b	anim_frame_duration(a0)
	move.b	#$E,routine_secondary(a0)
	bset	#status.npc.no_balancing,status(a0)
	clr.b	anim(a0)
	clr.b	collision_flags(a0)
	clr.w	x_vel(a0)
	clr.w	y_vel(a0)
	bsr.w	ObjC7_RemoveCollision
	bsr.w	ObjC7_Break
	movea.w	objoff_38(a0),a1 ; a1=object
	jsrto	JmpTo6_DeleteObject2
	addq.w	#4,sp
	rts
; ===========================================================================
;loc_3E094
ObjC7_Break:
	lea	(ObjC7_BreakOffsets).l,a1
	lea	ObjC7_BreakSpeeds(pc),a2
	moveq	#0,d0
	moveq	#ObjC7_BreakOffsets_End-ObjC7_BreakOffsets-1,d6

-	move.b	(a1)+,d0
	movea.w	(a0,d0.w),a3 ; a3=object
	move.b	#$1E,routine(a3)
	clr.b	routine_secondary(a3)
	move.w	#$80,objoff_2A(a3)
	move.w	(a2)+,x_vel(a3)
	move.w	(a2)+,y_vel(a3)
	dbf	d6,-
	rts
; ===========================================================================
;word_3E0C6
ObjC7_BreakSpeeds:
	dc.w  $200,-$400
	dc.w -$100,-$100	; 2
	dc.w  $300,-$300	; 4
	dc.w -$100,-$400	; 6
	dc.w  $180,-$200	; 8
	dc.w -$200,-$300	; 10
	dc.w	 0,-$400	; 12
	dc.w  $100,-$300	; 14
ObjC7_BreakSpeeds_End
;byte_3E0E6
ObjC7_BreakOffsets:
	dc.b objoff_2C
	dc.b objoff_2E	; 1
	dc.b objoff_30	; 2
	dc.b objoff_32	; 3
	dc.b objoff_34	; 4
	dc.b objoff_3A	; 5
	dc.b objoff_3C	; 6
	dc.b objoff_3E	; 7
ObjC7_BreakOffsets_End
	even
; ===========================================================================
;loc_3E0EE
ObjC7_InitCollision:
	lea	ObjC7_ChildOffsets(pc),a1
	lea	ObjC7_ChildCollision(pc),a2
	moveq	#0,d0

	moveq	#ObjC7_ChildCollision_End-ObjC7_ChildCollision-1,d6
-	move.b	(a1)+,d0
	movea.w	(a0,d0.w),a3 ; a3=object
	move.b	(a2)+,collision_flags(a3)
	dbf	d6,-

	rts
; ===========================================================================
;byte_3E10A
ObjC7_ChildCollision:
	dc.b   0
	dc.b $8F	; 1
	dc.b $9C	; 2
	dc.b   0	; 3
	dc.b $86	; 4
	dc.b $2A	; 5
	dc.b $8B	; 6
	dc.b $8F	; 7
	dc.b $9C	; 8
	dc.b $8B	; 9
ObjC7_ChildCollision_End
;byte_3E114
ObjC7_ChildOffsets:
	dc.b objoff_2C
	dc.b objoff_2E	; 1
	dc.b objoff_30	; 2
	dc.b objoff_32	; 3
	dc.b objoff_34	; 4
	dc.b objoff_36	; 5
	dc.b objoff_38	; 6
	dc.b objoff_3A	; 7
	dc.b objoff_3C	; 8
	dc.b objoff_3E	; 9
ObjC7_ChildOffsets_End
	even
; ===========================================================================
;loc_3E11E
ObjC7_RemoveCollision:
	lea	ObjC7_ChildOffsets(pc),a1
	moveq	#0,d0
	moveq	#ObjC7_ChildOffsets_End-ObjC7_ChildOffsets-1,d6

-	move.b	(a1)+,d0
	movea.w	(a0,d0.w),a3 ; a3=object
	clr.b	collision_flags(a3)
	dbf	d6,-
	rts
; ===========================================================================
;loc_3E136
CreateEggmanBombs:
	lea	EggmanBomb_InitSpeeds(pc),a3
	moveq	#1,d6

-	lea	(ChildObjC7_EggmanBomb).l,a2
	bsr.w	LoadChildObject
	move.w	(a3)+,d0
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	neg.w	d0
+
	move.w	d0,x_vel(a1)
	move.w	(a3)+,y_vel(a1)
	dbf	d6,-
	rts
; ===========================================================================
;word_3E160
EggmanBomb_InitSpeeds:
	dc.w   $60,-$800
	dc.w   $C0,-$A00
; ===========================================================================

loc_3E168:
	move.b	render_flags(a0),d0
	andi.b	#1,d0
	moveq	#0,d1
	lea	byte_3E19E(pc),a1

-	move.b	(a1)+,d1
	beq.w	return_37A48
	movea.w	(a0,d1.w),a2 ; a2=object
	move.b	render_flags(a2),d2
	andi.b	#$FE,d2
	or.b	d0,d2
	move.b	d2,render_flags(a2)
	move.b	status(a2),d2
	andi.b	#~(1<<status.npc.x_flip),d2
	or.b	d0,d2
	move.b	d2,status(a2)
	bra.s	-
; ===========================================================================
byte_3E19E:
	dc.b objoff_2C, objoff_2E, objoff_30, objoff_32	; 3
	dc.b objoff_34, objoff_36, objoff_38, objoff_3A	; 7
	dc.b objoff_3C, objoff_3E, 0
	even
; ===========================================================================

loc_3E1AA:
	movea.l	(a1)+,a2
	moveq	#0,d0
	move.b	anim_frame(a0),d0
	move.b	(a1,d0.w),d0
	move.b	d0,d1
	moveq	#0,d4
	andi.w	#$C0,d1
	beq.s	+
	bsr.w	loc_3E23E
+
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.b	(a2)+,d0
	move.b	(a2)+,d3
	move.b	objoff_1F(a0),d2
	addq.b	#1,d2
	cmp.b	d3,d2
	blo.s	+
	addq.b	#1,anim_frame(a0)
	moveq	#0,d2
+
	move.b	d2,objoff_1F(a0)
	moveq	#0,d5

-	move.b	(a2)+,d5
	movea.w	(a0,d5.w),a3 ; a3=object
	tst.w	d5
	bne.s	+
	movea.l	a0,a3
+
	move.l	x_pos(a3),d2
	move.b	(a2)+,d1
	ext.w	d1
	asl.w	#4,d1
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	neg.w	d1
+
	tst.w	d4
	beq.s	+
	neg.w	d1
+
	ext.l	d1
	asl.l	#8,d1
	add.l	d1,d2
	move.l	d2,x_pos(a3)
	move.l	y_pos(a3),d3
	move.b	(a2)+,d1
	ext.w	d1
	asl.w	#4,d1
	tst.w	d4
	beq.s	+
	neg.w	d1
+
	ext.l	d1
	asl.l	#8,d1
	add.l	d1,d3
	move.l	d3,y_pos(a3)
	dbf	d0,-

	moveq	#0,d1
	rts
; ===========================================================================

loc_3E236:
	clr.b	anim_frame(a0)
	moveq	#1,d1

return_3E23C:
	rts
; ===========================================================================

loc_3E23E:
	andi.b	#$3F,d0
	rol.b	#3,d1
	move.w	off_3E24C-2(pc,d1.w),d1
	jmp	off_3E24C(pc,d1.w)
; ===========================================================================
off_3E24C:	offsetTable
		offsetTableEntry.w loc_3E252
		offsetTableEntry.w loc_3E27A
		offsetTableEntry.w loc_3E27E
; ===========================================================================

loc_3E252:
	tst.b	objoff_1F(a0)
	bne.s	return_3E23C
	move.b	anim_frame(a0),d1
	addq.b	#1,d1
	move.b	(a1,d1.w),d0
	jsrto	JmpTo12_PlaySound ; sound id most likely came from off_3E40C or off_3E42C
	addq.b	#1,d1
	move.b	d1,anim_frame(a0)
	move.b	(a1,d1.w),d0
	move.b	d0,d1
	andi.b	#$C0,d1
	bne.s	loc_3E23E
	rts
; ===========================================================================

loc_3E27A:
	moveq	#1,d4
	rts
; ===========================================================================

loc_3E27E:
	addq.w	#4,sp
	bra.s	loc_3E236
; ===========================================================================

loc_3E282:
	movea.w	objoff_2C(a0),a2 ; a2=object
	move.w	x_pos(a2),d0
	move.w	(a1)+,d1
	btst	#render_flags.x_flip,render_flags(a2)
	beq.s	+
	neg.w	d1
+
	add.w	d1,d0
	move.w	d0,x_pos(a0)
	move.w	y_pos(a2),d0
	add.w	(a1)+,d0
	move.w	d0,y_pos(a0)
	rts
; ===========================================================================
;loc_3E2A8
ObjC7_PositionChildren:
	moveq	#0,d0
	moveq	#0,d6

	move.b	(a1)+,d6
-	move.b	(a1)+,d0
	movea.w	(a0,d0.w),a2 ; a2=object
	move.w	x_pos(a0),d1
	move.b	(a1)+,d2
	ext.w	d2
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	neg.w	d2
+
	add.w	d2,d1
	move.w	d1,x_pos(a2)
	move.w	y_pos(a0),d1
	move.b	(a1)+,d2
	ext.w	d2
	add.w	d2,d1
	move.w	d1,y_pos(a2)
	dbf	d6,-
	rts
; ===========================================================================
;byte_3E2E0
ObjC7_ChildDeltas:
	dc.b   6
	dc.b objoff_2E, $FC, $3C	; 1
	dc.b objoff_30, $F4,   8	; 2
	dc.b objoff_32,  $C, $F8	; 3
	dc.b objoff_34,   4, $24	; 4
	dc.b objoff_3A, $FC, $3C	; 5
	dc.b objoff_3C, $F4,   8	; 6
	dc.b objoff_3E,   4, $24	; 7
	even
off_3E2F6:
	dc.l ObjC7_GroupAni_3E318
	dc.b 0, 1, 2, 3, $FF, 0
	even
off_3E300:
	dc.l ObjC7_GroupAni_3E318
	dc.b 5, 6, 7, 8, $FF, 0
	even
off_3E30A:
	dc.l ObjC7_GroupAni_3E318
	dc.b 0, 1, 2, 3, 4, 5, 6, 7, 8, $C0
	even
; -----------------------------------------------------------------------------
; Custom animation
; -----------------------------------------------------------------------------
; must be on the same line as a label that has a corresponding _End label later
c7anilistheader macro maxframe,{INTLABEL}
__LABEL__ label *
	dc.b ((__LABEL___End - __LABEL__ - 2) / 3) - 1,maxframe
    endm

; macro for a animation data
c7ani macro pieceOffset,deltax,deltay
	dc.b	pieceOffset,deltax,deltay
    endm

ObjC7_GroupAni_3E318:		offsetTable ;include "mappings/sprite/objC7_a.asm"
		offsetTableEntry.w byte_3E32A
		offsetTableEntry.w byte_3E33E
		offsetTableEntry.w byte_3E352
		offsetTableEntry.w byte_3E366
		offsetTableEntry.w byte_3E37A
		offsetTableEntry.w byte_3E380
		offsetTableEntry.w byte_3E394
		offsetTableEntry.w byte_3E3A8
		offsetTableEntry.w byte_3E3BC

byte_3E32A:	c7anilistheader 8
	c7ani       $00, $E0, $0C
	c7ani objoff_30, $E0, $0C
	c7ani objoff_32, $E0, $0C
	c7ani objoff_3C, $E0, $0C
	c7ani objoff_34, $F8, $04
	c7ani objoff_3E, $F8, $04
byte_3E32A_End

byte_3E33E:	c7anilistheader 8
	c7ani       $00, $EC, $14
	c7ani objoff_30, $EC, $14
	c7ani objoff_32, $EC, $14
	c7ani objoff_3C, $EC, $14
	c7ani objoff_34, $FA, $06
	c7ani objoff_3E, $FA, $06
byte_3E33E_End

byte_3E352:	c7anilistheader 8
	c7ani       $00, $F8, $14
	c7ani objoff_30, $F8, $14
	c7ani objoff_32, $F8, $14
	c7ani objoff_3C, $F8, $14
	c7ani objoff_34, $FE, $04
	c7ani objoff_3E, $FE, $04
byte_3E352_End

byte_3E366:	c7anilistheader 8
	c7ani       $00, $FC, $0C
	c7ani objoff_30, $FC, $0C
	c7ani objoff_32, $FC, $0C
	c7ani objoff_3C, $FC, $0c
	c7ani objoff_34, $00, $02
	c7ani objoff_3E, $00, $02
byte_3E366_End

byte_3E37A:	c7anilistheader 8
	c7ani       $00, $00, $00
byte_3E37A_End
	even
byte_3E380:	c7anilistheader 8
	c7ani       $00, $04, $E8
	c7ani objoff_30, $04, $E8
	c7ani objoff_32, $04, $E8
	c7ani objoff_3C, $04, $E8
	c7ani objoff_34, $02, $FA
	c7ani objoff_3E, $02, $FA
byte_3E380_End

byte_3E394:	c7anilistheader 8
	c7ani       $00, $0C, $E8
	c7ani objoff_30, $0C, $E8
	c7ani objoff_32, $0C, $E8
	c7ani objoff_3C, $0C, $E8
	c7ani objoff_34, $04, $FC
	c7ani objoff_3E, $04, $FC
byte_3E394_End

byte_3E3A8:	c7anilistheader 8
	c7ani       $00, $18, $F4
	c7ani objoff_30, $18, $F4
	c7ani objoff_32, $18, $F4
	c7ani objoff_3C, $18, $F4
	c7ani objoff_34, $04, $FC
	c7ani objoff_3E, $04, $FC
byte_3E3A8_End

byte_3E3BC:	c7anilistheader 8
	c7ani       $00, $18, $FC
	c7ani objoff_30, $18, $FC
	c7ani objoff_32, $18, $FC
	c7ani objoff_3C, $18, $FC
	c7ani objoff_34, $06, $FE
	c7ani objoff_3E, $06, $FE
byte_3E3BC_End

off_3E3D0:
	dc.l ObjC7_GroupAni_3E3D8
	dc.b 0, 1, 2, $C0
	even
; -----------------------------------------------------------------------------
; Custom animation
; -----------------------------------------------------------------------------
ObjC7_GroupAni_3E3D8:		offsetTable ;include "mappings/sprite/objC7_b.asm"
		offsetTableEntry.w byte_3E3DE
		offsetTableEntry.w byte_3E3F2
		offsetTableEntry.w byte_3E3F8

byte_3E3DE:	c7anilistheader $10
	c7ani       $00, $00, $04
	c7ani objoff_30, $00, $04
	c7ani objoff_32, $00, $04
	c7ani objoff_3C, $00, $04
	c7ani objoff_34, $00, $04
	c7ani objoff_3E, $00, $04
byte_3E3DE_End

byte_3E3F2:	c7anilistheader $10
	c7ani       $00, $00, $00
byte_3E3F2_End
	even
byte_3E3F8:	c7anilistheader 8
	c7ani       $00, $00, $F8
	c7ani objoff_30, $00, $F8
	c7ani objoff_32, $00, $F8
	c7ani objoff_3C, $00, $F8
	c7ani objoff_34, $00, $F8
	c7ani objoff_3E, $00, $F8
byte_3E3F8_End

off_3E40C:
	dc.l ObjC7_GroupAni_3E438
	dc.b   0,  1,  2,  3, $40, SndID_Hammer
	dc.b   4,  5,  6,  7,   8, $40, SndID_Hammer
	dc.b   9, $A,  1,  2,   3, $40, SndID_Hammer
	dc.b   4,  5,  6,  7,   8, $40, SndID_Hammer, $C0
	even
off_3E42C:
	dc.l ObjC7_GroupAni_3E438
	dc.b $88, $87, $86, $85, $B, $40, SndID_Hammer, $C0
	even
; -----------------------------------------------------------------------------
; Custom animation
; -----------------------------------------------------------------------------
ObjC7_GroupAni_3E438:		offsetTable ;include "mappings/sprite/objC7_c.asm"
		offsetTableEntry.w byte_3E450
		offsetTableEntry.w byte_3E468
		offsetTableEntry.w byte_3E480
		offsetTableEntry.w byte_3E494
		offsetTableEntry.w byte_3E4AC
		offsetTableEntry.w byte_3E4C4
		offsetTableEntry.w byte_3E4D6
		offsetTableEntry.w byte_3E4EE
		offsetTableEntry.w byte_3E502
		offsetTableEntry.w byte_3E51A
		offsetTableEntry.w byte_3E532
		offsetTableEntry.w byte_3E544

byte_3E450:	c7anilistheader $20
	c7ani objoff_34, $F8, $F8
	c7ani objoff_2E, $F8, $F8
	c7ani       $00, $00, $FC
	c7ani objoff_30, $04, $FB
	c7ani objoff_32, $03, $FB
	c7ani objoff_3C, $FC, $FB
	c7ani objoff_3E, $00, $FE
byte_3E450_End
	even
byte_3E468:	c7anilistheader $10
	c7ani objoff_34, $F0, $FC
	c7ani objoff_2E, $F0, $FC
	c7ani       $00, $F0, $FC
	c7ani objoff_30, $F4, $FB
	c7ani objoff_32, $F3, $FB
	c7ani objoff_3C, $EC, $FB
	c7ani objoff_3E, $F8, $00
byte_3E468_End
	even
byte_3E480:	c7anilistheader $10
	c7ani objoff_34, $F8, $04
	c7ani objoff_2E, $F8, $04
	c7ani       $00, $F8, $04
	c7ani objoff_30, $FC, $03
	c7ani objoff_32, $FB, $03
	c7ani objoff_3C, $F4, $03
byte_3E480_End

byte_3E494:	c7anilistheader $10
	c7ani objoff_34, $FC, $10
	c7ani objoff_2E, $F8, $10
	c7ani       $00, $00, $08
	c7ani objoff_30, $F8, $0A
	c7ani objoff_32, $FA, $0A
	c7ani objoff_3C, $08, $0A
	c7ani objoff_3E, $00, $08
byte_3E494_End
	even
byte_3E4AC:	c7anilistheader $20
	c7ani objoff_34, $FE, $FE
	c7ani       $00, $F4, $FC
	c7ani objoff_30, $F0, $FD
	c7ani objoff_32, $F1, $FD
	c7ani objoff_3C, $F8, $FD
	c7ani objoff_3E, $EC, $FA
	c7ani objoff_3A, $E8, $FC
byte_3E4AC_End
	even
byte_3E4C4:	c7anilistheader $20
	c7ani objoff_3E, $F8, $FC
	c7ani objoff_3A, $F8, $FC
	c7ani objoff_30, $FC, $FF
	c7ani objoff_32, $FD, $FF
	c7ani objoff_3C, $04, $FF
byte_3E4C4_End
	even
byte_3E4D6:	c7anilistheader $10
	c7ani objoff_3E, $F0, $FC
	c7ani objoff_3A, $F0, $FC
	c7ani       $00, $F0, $FC
	c7ani objoff_30, $EC, $FB
	c7ani objoff_32, $ED, $FB
	c7ani objoff_3C, $F4, $FB
	c7ani objoff_34, $F8, $00
byte_3E4D6_End
	even
byte_3E4EE:	c7anilistheader $10
	c7ani objoff_3E, $F8, $04
	c7ani objoff_3A, $F8, $04
	c7ani       $00, $F8, $04
	c7ani objoff_30, $F4, $03
	c7ani objoff_32, $F5, $03
	c7ani objoff_3C, $FC, $03
byte_3E4EE_End

byte_3E502:	c7anilistheader $10
	c7ani objoff_3E, $FC, $10
	c7ani objoff_3A, $F8, $10
	c7ani       $00, $00, $08
	c7ani objoff_30, $08, $0A
	c7ani objoff_32, $06, $0A
	c7ani objoff_3C, $F8, $0A
	c7ani objoff_34, $00, $08
byte_3E502_End
	even
byte_3E51A:	c7anilistheader $20
	c7ani objoff_3E, $FE, $FE
	c7ani       $00, $F4, $FC
	c7ani objoff_30, $F8, $FD
	c7ani objoff_32, $F7, $FD
	c7ani objoff_3C, $F1, $FD
	c7ani objoff_34, $EC, $FA
	c7ani objoff_2E, $E8, $FC
byte_3E51A_End
	even
byte_3E532:	c7anilistheader $20
	c7ani objoff_34, $F8, $FC
	c7ani objoff_2E, $F8, $FC
	c7ani objoff_30, $04, $FF
	c7ani objoff_32, $03, $FF
	c7ani objoff_3C, $FC, $FF
byte_3E532_End
	even
byte_3E544:	c7anilistheader $10
	c7ani objoff_3E, $00, $08
	c7ani objoff_3A, $00, $08
	c7ani       $00, $00, $08
	c7ani objoff_30, $00, $08
	c7ani objoff_32, $00, $08
	c7ani objoff_3C, $00, $08
	c7ani objoff_34, $00, $08
byte_3E544_End
	even

;word_3E55C
ChildObjC7_Shoulder:
	dc.w objoff_2C
	dc.b ObjID_Eggrobo
	dc.b   4
;word_3E560
ChildObjC7_FrontLowerLeg:
	dc.w objoff_2E
	dc.b ObjID_Eggrobo
	dc.b   6
;word_3E564
ChildObjC7_FrontForearm:
	dc.w objoff_30
	dc.b ObjID_Eggrobo
	dc.b   8
;word_3E568
ChildObjC7_Arm:
	dc.w objoff_32
	dc.b ObjID_Eggrobo
	dc.b  $A
;word_3E56C
ChildObjC7_FrontThigh:
	dc.w objoff_34
	dc.b ObjID_Eggrobo
	dc.b  $C
;word_3E570
ChildObjC7_Head:
	dc.w objoff_36
	dc.b ObjID_Eggrobo
	dc.b  $E
;word_3E574
ChildObjC7_Jet:
	dc.w objoff_38
	dc.b ObjID_Eggrobo
	dc.b $10
;word_3E578
ChildObjC7_BackLowerLeg:
	dc.w objoff_3A
	dc.b ObjID_Eggrobo
	dc.b $12
;word_3E57C
ChildObjC7_BackForearm:
	dc.w objoff_3C
	dc.b ObjID_Eggrobo
	dc.b $14
;word_3E580
ChildObjC7_BackThigh:
	dc.w objoff_3E
	dc.b ObjID_Eggrobo
	dc.b $16
;word_3E584
ChildObjC7_TargettingSensor:
	dc.w objoff_10
	dc.b ObjID_Eggrobo
	dc.b $18
;word_3E588
ChildObjC7_TargettingLock:
	dc.w objoff_10
	dc.b ObjID_Eggrobo
	dc.b $1A
;word_3E58C
ChildObjC7_EggmanBomb:
	dc.w objoff_10
	dc.b ObjID_Eggrobo
	dc.b $1C
;off_3E590
ObjC7_SubObjData:
	subObjData ObjC7_MapUnc_3E5F8,make_art_tile(ArtTile_ArtNem_DEZBoss,0,0),1<<render_flags.level_fg,4,$38,$00

; animation script
; off_3E59A:
Ani_objC7_a:	offsetTable
		offsetTableEntry.w +
+		dc.b   7,$15,$15,$15,$15,$15,$15,$15,$15,  0,  1,  2,$FA
		even

; animation script
; off_3E5AA:
Ani_objC7_b:	offsetTable
		offsetTableEntry.w byte_3E5B2
		offsetTableEntry.w byte_3E5B6
		offsetTableEntry.w byte_3E5D0
		offsetTableEntry.w byte_3E5EA
byte_3E5B2:	dc.b   1, $C, $D,$FF
byte_3E5B6:	dc.b   1, $C, $D, $C, $C, $D, $D, $C, $C, $C, $D, $D, $D, $C, $C, $C
		dc.b  $C, $C, $D, $D, $D, $D, $D, $D,$FA,  0; 16
byte_3E5D0:	dc.b   1, $D, $D, $D, $D, $D, $D, $C, $C, $C, $C, $C, $D, $D, $D, $C
		dc.b  $C, $C, $D, $D, $C, $C, $D, $C,$FD,  0; 16
byte_3E5EA:	dc.b   0, $D,$15,$FF
		even

; animation script
; off_3E5EE:
Ani_objC7_c:	offsetTable
		offsetTableEntry.w byte_3E5F0
byte_3E5F0:	dc.b   3,$13,$12,$11,$10,$16,$FF
		even
; ------------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------------
ObjC7_MapUnc_3E5F8:	include "mappings/sprite/objC7.asm"
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to upscale graphics by a factor of 2x, based on given mappings
; data for correct positioning of tiles.
;
; This code is awfully structured and planned: whenever a 3-column sprite piece
; is scaled, it scales the next tiles that were copied to RAM as if the piece
; had 4 columns; this will then be promptly overwritten by the next piece. If
; this happens near the end of the buffer, you will get a buffer overrun.
; Moreover, when the number of rows in the sprite piece is also 3 or 4, the code
; will make an incorrect computation for the output of the next subpiece, which
; causes the output to overwrite art from the previous subpiece. Thus, this code
; fails if there is a 3x3 or a 3x4 sprite piece in the source mappings. Sadly,
; this issue is basically unfixable without rewriting the code entirely.
;
; Input:
; 	a1	Location of tiles to be enlarged
; 	a2	Destination buffer for enlarged tiles
; 	d0	Width-1 of sprite piece
; 	d1	Height-1 of sprite piece
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;loc_3E89E
Scale_2x:
	move.w	d1,d2					; Copy piece height-1
	andi.w	#1,d2					; Want only low bit -- this is 1 for Wx2 or Wx4 pieces, 0 otherwise
	addq.w	#1,d2					; Make it into 2 for Wx2 or Wx4 pieces, 1 otherwise
	lsl.w	#6,d2					; This is now $80 (4 tiles) for Wx2 or Wx4 pieces, $40 (2 tiles) otherwise
	swap	d2						; Save it to high word
	move.w	d1,d3					; Copy piece height-1 again
	lsr.w	#1,d3					; This time, want high bit (1 for Wx3 or Wx4, 0 for Wx2 or Wx1)
	addq.w	#1,d3					; Make it into 2 for Wx3 or Wx4 pieces, 1 otherwise
	lsl.w	#6,d3					; This is now $80 (4 tiles) for Wx3 or Wx4 pieces, $40 (2 tiles) otherwise
	swap	d3						; Save it to high word
	bsr.w	.upscale_part1				; Scale the first line???; sets a3 = ???, a5 = ???
	btst	#1,d0					; Is this a 1xH or a 2xH piece?
	beq.w	return_37A48				; Return if yes
	btst	#1,d1					; Is this a Wx3 or a Wx4 piece?
	bne.s	.set_dest				; Branch if yes
	movea.l	a3,a5					; Advance to next column instead

.set_dest:
	movea.l	a5,a2					; Set new output location

.upscale_part1:
	movea.l	a2,a4					; Copy destination to a4
	swap	d2					; Get height offset
	lea	(a2,d2.w),a3				; Output location for next tile
	swap	d2					; Save height offset again
	move.w	d1,d5					; Copy height-1
	andi.w	#1,d5					; How many tiles we want to do-1 -- this is 1 for Wx2 or Wx4 pieces, 0 otherwise
	bsr.w	Scale2x_SingleTile
	btst	#1,d1					; Are we upscaling a Wx3 or Wx4 piece?
	beq.s	.done_cols				; Branch if not
	swap	d2					; Get height offset
	move.w	d2,d4					; Copy it to d4
	swap	d2					; Save height offset again
	add.w	d4,d4					; This is now $100 (8 tiles) for Wx4 pieces, $80 (4 tiles) for Wx3 pieces
	move.w	d0,d3					; Copy piece width-1
	andi.w	#1,d3					; Want only low bit -- this is 1 for 2xH or 4xH pieces, 0 otherwise
	lsl.w	d3,d4					; This is now: $200 (16 tiles) for 2x4 or 4x4 pieces; $100 (8 tiles) for 2x3, 4x3, 1x4 or 3x4 pieces; $80 (4 tiles) for 1x3 or 3x3 pieces
	adda.w	d4,a4					; Advance to this location
	move.w	d1,d5					; Copy height-1
	lsr.w	#1,d5					; How many tiles we want to do-1 -- this is 1 for Wx4 pieces, 0 for Wx3 pieces
	swap	d3					; Get height offset
	lea	(a4,d3.w),a5				; Output location for next tile
	swap	d3					; Save height offset again
	bsr.w	Scale2x_SingleTile2

.done_cols:
	btst	#0,d0					; Is this a 1xH or 3xH piece?
	bne.s	.keep_upscaling				; Branch if not
	btst	#1,d0					; Was this a single column piece?
	beq.s	.done					; Return if so

.keep_upscaling:
	swap	d2					; Get height offset
	lea	(a2,d2.w),a2				; Output location for next tile
	lea	(a2,d2.w),a3				; Output location for next tile
	swap	d2					; Save height offset again
	move.w	d1,d5					; Copy height-1
	andi.w	#1,d5					; How many tiles we want to do -- this is 1 for Wx2 or Wx4 pieces, 0 otherwise
	bsr.w	Scale2x_SingleTile
	btst	#1,d1					; Are we upscaling a Wx3 or Wx4 piece?
	beq.s	.done					; Branch if not
	move.w	d1,d5					; Copy height-1
	lsr.w	#1,d5					; How many tiles we want to do-1 -- this is 1 for Wx4 or Wx3 pieces, 0 otherwise
	swap	d3					; Get height offset
	lea	(a4,d3.w),a4				; Output location for next tile
	lea	(a4,d3.w),a5				; Output location for next tile
	swap	d3					; Save height offset again
	bsr.w	Scale2x_SingleTile2

.done:
	rts
; ===========================================================================
; Upscales the given tile to the pair of tiles on the output pointers.
;
; Input:
; 	a1	Pixel source
; 	d5	Number of tiles-1 to upscale
; 	a2	Location of output tiles for left pixels
; 	a3	Location of output tiles for right pixels
; Output:
; 	a1	Pixel source after processed tiles
; 	a2	Location of output tiles for left pixels after scaled tiles
; 	a3	Location of output tiles for right pixels after scaled tiles
;loc_3E944
Scale2x_SingleTile:
	moveq	#7,d6					; 8 rows per tile

.loop:
	bsr.w	Scale_2x_LeftPixels			; Upscale pixels 0-3 of current row
	addq.w	#4,a2					; Advance write destination by one row (8 pixels)
	bsr.w	Scale_2x_RightPixels			; Upscale pixels 4-7 of current row
	addq.w	#4,a3					; Advance write destination by one row (8 pixels)
	dbf	d6,.loop

	dbf	d5,Scale2x_SingleTile

	rts
; ===========================================================================
; Upscales the given tile to the pair of tiles on the output pointers.
;
; Input:
; 	a1	Pixel source
; 	d5	Number of tiles-1 to upscale
; 	a4	Location of output tiles for left pixels
; 	a5	Location of output tiles for right pixels
; Output:
; 	a1	Pixel source after processed tiles
; 	a4	Location of output tiles for left pixels after scaled tiles
; 	a5	Location of output tiles for right pixels after scaled tiles
;loc_3E95C
Scale2x_SingleTile2:
	moveq	#7,d6					; 8 rows per tile

.loop:
	bsr.w	Scale_2x_LeftPixels2			; Upscale pixels 0-3 of current row
	addq.w	#4,a4					; Advance write destination by one row (8 pixels)
	bsr.w	Scale_2x_RightPixels2			; Upscale pixels 4-7 of current row
	addq.w	#4,a5					; Advance write destination by one row (8 pixels)
	dbf	d6,.loop

	dbf	d5,Scale2x_SingleTile2

	rts
; ===========================================================================
; Upscales the leftmost 4 pixels on the current row into the corresponding two
; rows of the output tile
;loc_3E974
Scale_2x_LeftPixels:
	bsr.w	.upscale_pixel_pair

.upscale_pixel_pair:
	move.b	(a1)+,d2				; Read two pixels
	move.b	d2,d3					; Save them
	andi.b	#$F0,d2					; Get left pixel
	move.b	d2,d4					; Copy it...
	lsr.b	#4,d4					; ...shift it down into place...
	or.b	d2,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a2)+				; Save to top tile, both on one row...
	move.b	d4,3(a2)				; ...and on the row below
	andi.b	#$F,d3					; Get saved right pixel
	move.b	d3,d4					; Copy it...
	lsl.b	#4,d4					; ...shift it up into place...
	or.b	d3,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a2)+				; Save to top tile, both on one row...
	move.b	d4,3(a2)				; ...and on the row below
	rts
; ===========================================================================
; Upscales the rightmost 4 pixels on the current row into the corresponding two
; rows of the output tile
;loc_3E99E
Scale_2x_RightPixels:
	bsr.w	.upscale_pixel_pair

.upscale_pixel_pair:
	move.b	(a1)+,d2				; Read two pixels
	move.b	d2,d3					; Save them
	andi.b	#$F0,d2					; Get left pixel
	move.b	d2,d4					; Copy it...
	lsr.b	#4,d4					; ...shift it down into place...
	or.b	d2,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a3)+				; Save to bottom tile, both on one row...
	move.b	d4,3(a3)				; ...and on the row below
	andi.b	#$F,d3					; Get saved right pixel
	move.b	d3,d4					; Copy it...
	lsl.b	#4,d4					; ...shift it up into place...
	or.b	d3,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a3)+				; Save to bottom tile, both on one row...
	move.b	d4,3(a3)				; ...and on the row below
	rts
; ===========================================================================
; Upscales the leftmost 4 pixels on the current row into the corresponding two
; rows of the output tile
;loc_3E9C8
Scale_2x_LeftPixels2:
	bsr.w	.upscale_pixel_pair

.upscale_pixel_pair:
	move.b	(a1)+,d2				; Read two pixels
	move.b	d2,d3					; Save them
	andi.b	#$F0,d2					; Get left pixel
	move.b	d2,d4					; Copy it...
	lsr.b	#4,d4					; ...shift it down into place...
	or.b	d2,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a4)+				; Save to top tile, both on one row...
	move.b	d4,3(a4)				; ...and on the row below
	andi.b	#$F,d3					; Get saved right pixel
	move.b	d3,d4					; Copy it...
	lsl.b	#4,d4					; ...shift it up into place...
	or.b	d3,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a4)+				; Save to top tile, both on one row...
	move.b	d4,3(a4)				; ...and on the row below
	rts
; ===========================================================================
; Upscales the rightmost 4 pixels on the current row into the corresponding two
; rows of the output tile
;loc_3E9F2
Scale_2x_RightPixels2:
	bsr.w	.upscale_pixel_pair

.upscale_pixel_pair:
	move.b	(a1)+,d2				; Read two pixels
	move.b	d2,d3					; Save them
	andi.b	#$F0,d2					; Get left pixel
	move.b	d2,d4					; Copy it...
	lsr.b	#4,d4					; ...shift it down into place...
	or.b	d2,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a5)+				; Save to bottom tile, both on one row...
	move.b	d4,3(a5)				; ...and on the row below
	andi.b	#$F,d3					; Get saved right pixel
	move.b	d3,d4					; Copy it...
	lsl.b	#4,d4					; ...shift it up into place...
	or.b	d3,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a5)+				; Save to bottom tile, both on one row...
	move.b	d4,3(a5)				; ...and on the row below
	rts
; ===========================================================================

	; this data seems to be unused
	dc.b $12,$34,$56,$78
	dc.b $12,$34,$56,$78	; 4
	dc.b $12,$34,$56,$78	; 8
	dc.b $12,$34,$56,$78	; 12
	dc.b $12,$34,$56,$78	; 16
	dc.b $12,$34,$56,$78	; 20
	dc.b $12,$34,$56,$78	; 24
	dc.b $12,$34,$56,$78	; 28

; ===========================================================================

	jmpTos0 JmpTo5_DisplaySprite3,JmpTo45_DisplaySprite,JmpTo65_DeleteObject,JmpTo19_AllocateObject,JmpTo39_MarkObjGone,JmpTo6_DeleteObject2,JmpTo12_PlaySound,JmpTo25_AllocateObjectAfterCurrent,JmpTo25_AnimateSprite,JmpTo_PlaySoundLocal,JmpTo6_RandomNumber,JmpTo2_MarkObjGone_P1,JmpTo_Pal_FadeToWhite.UpdateColour,JmpTo_LoadTailsDynPLC_Part2,JmpTo_LoadSonicDynPLC_Part2,JmpTo8_MarkObjGone3,JmpTo64_Adjust2PArtPointer,JmpTo5_PlayMusic,JmpTo_Boss_LoadExplosion,JmpTo9_PlatformObject,JmpTo27_SolidObject,JmpTo8_ObjectMoveAndFall,JmpTo26_ObjectMove




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 8A - Sonic Team Presents/Credits (leftover from S1) (seemingly unused)
; ----------------------------------------------------------------------------
; Sprite_3EAC8:
Obj8A: ; (screen-space obj)
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj8A_Index(pc,d0.w),d1
	jmp	Obj8A_Index(pc,d1.w)
; ===========================================================================
; off_3EAD6:
Obj8A_Index:	offsetTable
		offsetTableEntry.w Obj8A_Init
		offsetTableEntry.w Obj8A_Display
; ===========================================================================
; loc_3EADA:
Obj8A_Init:
	addq.b	#2,routine(a0)
	move.w	#spriteScreenPositionXCentered(0),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(0),y_pixel(a0)
	move.l	#Obj8A_MapUnc_3EB4E,mappings(a0)
	move.w	#make_art_tile($05A0,0,0),art_tile(a0)
	jsrto	JmpTo65_Adjust2PArtPointer
	move.w	(Ending_demo_number).w,d0
	move.b	d0,mapping_frame(a0)
	move.b	#0,render_flags(a0)
	move.b	#0,priority(a0)
	cmpi.b	#GameModeID_TitleScreen,(Game_Mode).w	; title screen??
	bne.s	Obj8A_Display	; if not, branch
	move.w	#make_art_tile($0300,0,0),art_tile(a0)
	jsrto	JmpTo65_Adjust2PArtPointer
	move.b	#$A,mapping_frame(a0)
	tst.b	(S1_hidden_credits_flag).w
	beq.s	Obj8A_Display
	cmpi.b	#button_down_mask|button_B_mask|button_C_mask|button_A_mask,(Ctrl_1_Held).w
	bne.s	Obj8A_Display
	move.w	#$EEE,(Target_palette_line3).w
	move.w	#$880,(Target_palette_line3+2).w
	jmp	(DeleteObject).l
; ===========================================================================
; JmpTo46_DisplaySprite
Obj8A_Display:
	jmp	(DisplaySprite).l
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings (unused?)
; ----------------------------------------------------------------------------
Obj8A_MapUnc_3EB4E:	include "mappings/sprite/obj8A.asm"
; ===========================================================================

	jmpTos JmpTo65_Adjust2PArtPointer




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 3E - Egg prison
; ----------------------------------------------------------------------------
; Sprite_3F1E4:
Obj3E:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj3E_Index(pc,d0.w),d1
	jmp	Obj3E_Index(pc,d1.w)
; ===========================================================================
; off_3F1F2:
Obj3E_Index:	offsetTable
		offsetTableEntry.w loc_3F212	;  0
		offsetTableEntry.w loc_3F278	;  2
		offsetTableEntry.w loc_3F354	;  4
		offsetTableEntry.w loc_3F38E	;  6
		offsetTableEntry.w loc_3F3A8	;  8
		offsetTableEntry.w loc_3F406	; $A
; ----------------------------------------------------------------------------
; byte_3F1FE:
Obj3E_ObjLoadData:
	dc.b   0,  2,$20,  4,  0
	dc.b $28,  4,$10,  5,  4	; 5
	dc.b $18,  6,  8,  3,  5	; 10
	dc.b   0,  8,$20,  4,  0	; 15
	even
; ===========================================================================

loc_3F212:
	movea.l	a0,a1
	lea	objoff_38(a0),a3
	lea	Obj3E_ObjLoadData(pc),a2
	moveq	#3,d1
	bra.s	loc_3F228
; ===========================================================================

loc_3F220:
	jsrto	JmpTo20_AllocateObject
	bne.s	loc_3F272
	move.w	a1,(a3)+

loc_3F228:
	_move.b	id(a0),id(a1) ; load obj
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	y_pos(a0),objoff_30(a1)
	move.l	#Obj3E_MapUnc_3F436,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Capsule,1,0),art_tile(a1)
	move.b	#1<<render_flags.on_screen|1<<render_flags.level_fg,render_flags(a1)
	moveq	#0,d0
	move.b	(a2)+,d0
	sub.w	d0,y_pos(a1)
	move.w	y_pos(a1),objoff_30(a1)
	move.b	(a2)+,routine(a1)
	move.b	(a2)+,width_pixels(a1)
	move.b	(a2)+,priority(a1)
	move.b	(a2)+,mapping_frame(a1)

loc_3F272:
	dbf	d1,loc_3F220
	rts
; ===========================================================================

loc_3F278:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3F2AE(pc,d0.w),d1
	jsr	off_3F2AE(pc,d1.w)
	move.w	#$2B,d1
	move.w	#$18,d2
	move.w	#$18,d3
	move.w	x_pos(a0),d4
	jsr	(SolidObject).l
	lea	(Ani_obj3E).l,a1
	jsr	(AnimateSprite).l
	jmp	(MarkObjGone).l
; ===========================================================================
off_3F2AE:	offsetTable
		offsetTableEntry.w loc_3F2B4	; 0
		offsetTableEntry.w loc_3F2FC	; 2
		offsetTableEntry.w return_3F352	; 4
; ===========================================================================

loc_3F2B4:
	movea.w	objoff_38(a0),a1 ; a1=object
	tst.w	objoff_32(a1)
	beq.s	++	; rts
	movea.w	objoff_3A(a0),a2 ; a2=object
	jsr	(AllocateObject).l
	bne.s	+
	_move.b	#ObjID_Explosion,id(a1) ; load obj
	addq.b	#2,routine(a1)
	move.w	x_pos(a2),x_pos(a1)
	move.w	y_pos(a2),y_pos(a1)
+
	move.w	#-$400,y_vel(a2)
	move.w	#$800,x_vel(a2)
	addq.b	#2,routine_secondary(a2)
	move.w	#$1D,objoff_34(a0)
	addq.b	#2,routine_secondary(a0)
+
	rts
; ===========================================================================

loc_3F2FC:
	subq.w	#1,objoff_34(a0)
	bpl.s	return_3F352
	move.b	#1,anim(a0)
	moveq	#7,d6
	move.w	#$9A,d5
	moveq	#-$1C,d4

-	jsr	(AllocateObject).l
	bne.s	+
	_move.b	#ObjID_Animal,id(a1) ; load obj
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	add.w	d4,x_pos(a1)
	move.b	#1,objoff_38(a1)
	addq.w	#7,d4
	move.w	d5,objoff_36(a1)
	subq.w	#8,d5
	dbf	d6,-
+
	movea.w	objoff_3C(a0),a2 ; a2=object
	move.w	#$B4,anim_frame_duration(a2)
	addq.b	#2,routine_secondary(a2)
	addq.b	#2,routine_secondary(a0)

return_3F352:
	rts
; ===========================================================================

loc_3F354:
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	x_pos(a0),d4
	jsr	(SolidObject).l
	move.w	objoff_30(a0),y_pos(a0)
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	+
	addq.w	#8,y_pos(a0)
	clr.b	(Update_HUD_timer).w
	move.w	#1,objoff_32(a0)
+
	jmp	(MarkObjGone).l
; ===========================================================================

loc_3F38E:
	tst.b	routine_secondary(a0)
	beq.s	+
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	JmpTo66_DeleteObject
	jsr	(ObjectMoveAndFall).l
+
	jmp	(MarkObjGone).l

    if removeJmpTos
JmpTo66_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================

loc_3F3A8:
	tst.b	routine_secondary(a0)
	beq.s	return_3F404
	move.b	(Vint_runcount+3).w,d0
	andi.b	#7,d0
	bne.s	loc_3F3F4
	jsr	(AllocateObject).l
	bne.s	loc_3F3F4
	_move.b	#ObjID_Animal,id(a1) ; load obj
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	jsr	(RandomNumber).l
	andi.w	#$1F,d0
	subq.w	#6,d0
	tst.w	d1
	bpl.s	+
	neg.w	d0
+
	add.w	d0,x_pos(a1)
	move.b	#1,objoff_38(a1)
	move.w	#$C,objoff_36(a1)

loc_3F3F4:
	subq.w	#1,anim_frame_duration(a0)
	bne.s	return_3F404
	addq.b	#2,routine(a0)
	move.w	#$B4,anim_frame_duration(a0)

return_3F404:
	rts
; ===========================================================================

loc_3F406:
	moveq	#(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d0
	moveq	#ObjID_Animal,d1
	lea	(Dynamic_Object_RAM).w,a1

-	cmp.b	id(a1),d1
	beq.s	+	; rts
	lea	next_object(a1),a1 ; a1=object
	dbf	d0,-

	jsr	(Load_EndOfAct).l
	jmp	(DeleteObject).l
; ===========================================================================
+	rts
; ===========================================================================
; animation script
; off_3F428:
Ani_obj3E:	offsetTable
		offsetTableEntry.w byte_3F42C	; 0
		offsetTableEntry.w byte_3F42F	; 1
byte_3F42C:	dc.b  $F,  0,$FF
		rev02even
byte_3F42F:	dc.b   3,  0,  1,  2,  3,$FE,  1
		even
; ----------------------------------------------------------------------------
; sprite mappings
; [fixBugs] These mappings contain a bug: the second and third sprites have
; their 'total sprite pieces' value set too low by one, causing the last
; sprite piece to not be displayed.
; ----------------------------------------------------------------------------
Obj3E_MapUnc_3F436:	include "mappings/sprite/obj3E.asm"
; ===========================================================================

	jmpTos JmpTo66_DeleteObject,JmpTo20_AllocateObject




; ---------------------------------------------------------------------------
; Object touch response subroutine - $20(a0) in the object RAM
; collides Sonic with most objects (enemies, rings, monitors...) in the level
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_3F554:
TouchResponse:
	nop
	jsrto	JmpTo_Touch_Rings
	; Bumpers in CNZ
	cmpi.b	#casino_night_zone,(Current_Zone).w
	bne.s	+
	jsrto	JmpTo_Check_CNZ_bumpers
+
	tst.b	(Current_Boss_ID).w
	bne.w	Touch_Boss
	move.w	x_pos(a0),d2 ; load Sonic's position into d2,d3
	move.w	y_pos(a0),d3
	subi_.w	#8,d2
	moveq	#0,d5
	move.b	y_radius(a0),d5
	subq.b	#3,d5
	sub.w	d5,d3
    if fixBugs
	cmpi.b	#AniIDSonAni_Duck,anim(a0)	; is Sonic ducking?
    else
	; This logic only works for Sonic, not Tails. Also, it only applies
	; to the last frame of his ducking animation. This is a leftover from
	; Sonic 1, where Sonic's ducking animation only had one frame.
	cmpi.b	#$4D,mapping_frame(a0)	; is Sonic ducking?
    endif
	bne.s	Touch_NoDuck			; if not, branch
	addi.w	#$C,d3
	moveq	#$A,d5
; loc_3F592:
Touch_NoDuck:
	move.w	#$10,d4
	add.w	d5,d5
	lea	(Dynamic_Object_RAM).w,a1
	move.w	#(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d6
; loc_3F5A0:
Touch_Loop:
	; Note that this uses a branch instead of a 'bsr'.
	; This is because only one object can be collided with in a single frame.
	; If 'Touch_CheckCollision' determines that the character isn't colliding with the
	; object, then it manually branches back to 'Touch_NextObj' to try the next one.
	move.b	collision_flags(a1),d0
	bne.w	Touch_CheckCollision
; loc_3F5A8:
Touch_NextObj:
	lea	next_object(a1),a1 ; load obj address ; goto next object
	dbf	d6,Touch_Loop ; repeat 6F more times

	moveq	#0,d0
	rts
; ===========================================================================
; loc_3F5B4: Touch_Height: Touch_Width:
Touch_CheckCollision:
	andi.w	#$3F,d0
	add.w	d0,d0
	lea	Touch_Sizes(pc,d0.w),a2

	; From here to the branch to 'Touch_ChkValue', this code is the same as 'Touch_Boss_CheckWidth',
	; only it returns to 'Touch_NextObj' instead of 'Touch_Boss_NextObj'.
	; This could have been avoided with some clever stack usage.
;Touch_CheckWidth:
	moveq	#0,d1
	move.b	(a2)+,d1
	move.w	x_pos(a1),d0
	sub.w	d1,d0
	sub.w	d2,d0
	bcc.s	loc_3F5D6
	add.w	d1,d1
	add.w	d1,d0
	bcs.s	Touch_CheckHeight
	bra.w	Touch_NextObj
; ===========================================================================

loc_3F5D6:
	cmp.w	d4,d0
	bhi.w	Touch_NextObj
; loc_3F5DC: Touch_Width: Touch_Height:
Touch_CheckHeight:
	moveq	#0,d1
	move.b	(a2)+,d1
	move.w	y_pos(a1),d0
	sub.w	d1,d0
	sub.w	d3,d0
	bcc.s	loc_3F5F6
	add.w	d1,d1
	add.w	d1,d0
	bcs.w	Touch_ChkValue
	bra.w	Touch_NextObj
; ===========================================================================

loc_3F5F6:
	cmp.w	d5,d0
	bhi.w	Touch_NextObj
	; Here ends the duplicate code.
	bra.w	Touch_ChkValue
; ===========================================================================
; collision sizes (width,height)
; byte_3F600:
Touch_Sizes:
	dc.b   4,  4	;   0
	dc.b $14,$14	;   1
	dc.b  $C,$14	;   2
	dc.b $14, $C	;   3
	dc.b   4,$10	;   4
	dc.b  $C,$12	;   5
	dc.b $10,$10	;   6 - monitors
	dc.b   6,  6	;   7 - rings
	dc.b $18, $C	;   8
	dc.b  $C,$10	;   9
	dc.b $10,  8	;  $A
	dc.b   8,  8	;  $B
	dc.b $14,$10	;  $C
	dc.b $14,  8	;  $D
	dc.b  $E, $E	;  $E
	dc.b $18,$18	;  $F
	dc.b $28,$10	; $10
	dc.b $10,$18	; $11
	dc.b   8,$10	; $12
	dc.b $20,$70	; $13
	dc.b $40,$20	; $14
	dc.b $80,$20	; $15
	dc.b $20,$20	; $16
	dc.b   8,  8	; $17
	dc.b   4,  4	; $18
	dc.b $20,  8	; $19
	dc.b  $C, $C	; $1A
	dc.b   8,  4	; $1B
	dc.b $18,  4	; $1C
	dc.b $28,  4	; $1D
	dc.b   4,  8	; $1E
	dc.b   4,$18	; $1F
	dc.b   4,$28	; $20
	dc.b   4,$10	; $21
	dc.b $18,$18	; $22
	dc.b  $C,$18	; $23
	dc.b $48,  8	; $24
	dc.b $18,$28	; $25
	dc.b $10,  4	; $26
	dc.b $20,  2	; $27
	dc.b   4,$40	; $28
	dc.b $18,$80	; $29
	dc.b $20,$10	; $2A
	dc.b $10,$20	; $2B
	dc.b $10,$30	; $2C
	dc.b $10,$40	; $2D
	dc.b $10,$50	; $2E
	dc.b $10,  2	; $2F
	dc.b $10,  1	; $30
	dc.b   2,  8	; $31
	dc.b $20,$1C	; $32
; ===========================================================================
; loc_3F666:
Touch_Boss:
	lea	Touch_Sizes(pc),a3
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	subi_.w	#8,d2
	moveq	#0,d5
	move.b	y_radius(a0),d5
	subq.b	#3,d5
	sub.w	d5,d3
    if fixBugs
	cmpi.b	#AniIDSonAni_Duck,anim(a0)	; is Sonic ducking?
	bne.s	+				; if not, branch
    else
	; This logic only works for Sonic, not Tails. Also, it only applies
	; to the last frame of his ducking animation. This is a leftover from
	; Sonic 1, where Sonic's ducking animation only had one frame.
	cmpi.b	#$4D,mapping_frame(a0)	; is Sonic ducking?
	bne.s	+			; if not, branch
    endif
	addi.w	#$C,d3
	moveq	#$A,d5
+
	move.w	#$10,d4
	add.w	d5,d5
	lea	(Dynamic_Object_RAM).w,a1
	move.w	#(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d6
; loc_3F69C:
Touch_Boss_Loop:
	; Note that this uses a branch instead of a 'bsr'.
	; This is because only one object can be collided with in a single frame.
	; If 'Touch_Boss_CheckCollision' determines that the character isn't colliding with the
	; object, then it manually branches back to 'Touch_Boss_NextObj' to try the next one.
	move.b	collision_flags(a1),d0
	bne.s	Touch_Boss_CheckCollision
; loc_3F6A2:
Touch_Boss_NextObj:
	lea	next_object(a1),a1 ; a1=object
	dbf	d6,Touch_Boss_Loop

	moveq	#0,d0
	rts
; ===========================================================================
;loc_3F6AE:
Touch_Boss_CheckCollision:
	bsr.w	BossSpecificCollision
	andi.w	#$3F,d0
	beq.s	Touch_Boss_NextObj
	add.w	d0,d0
	lea	(a3,d0.w),a2

	; From here to 'Touch_ChkValue', this code is the same as 'Touch_CheckWidth',
	; only it returns to 'Touch_Boss_NextObj' instead of 'Touch_NextObj'.
	; This could have been avoided with some clever stack usage.
;Touch_Boss_CheckWidth:
	moveq	#0,d1
	move.b	(a2)+,d1
	move.w	x_pos(a1),d0
	sub.w	d1,d0
	sub.w	d2,d0
	bcc.s	loc_3F6D4
	add.w	d1,d1
	add.w	d1,d0
	bcs.s	Touch_Boss_CheckHeight
	bra.s	Touch_Boss_NextObj
; ===========================================================================

loc_3F6D4:
	cmp.w	d4,d0
	bhi.s	Touch_Boss_NextObj
;loc_3F6D8:
Touch_Boss_CheckHeight:
	moveq	#0,d1
	move.b	(a2)+,d1
	move.w	y_pos(a1),d0
	sub.w	d1,d0
	sub.w	d3,d0
	bcc.s	loc_3F6EE
	add.w	d1,d1
	add.w	d1,d0
	bcs.s	Touch_ChkValue
	bra.s	Touch_Boss_NextObj
; ===========================================================================

loc_3F6EE:
	cmp.w	d5,d0
	bhi.s	Touch_Boss_NextObj
	; Here ends the duplicate code.
; loc_3F6F2:
Touch_ChkValue:
	move.b	collision_flags(a1),d1	; load touch response number
	andi.b	#$C0,d1			; is touch response $40 or higher?
	beq.w	Touch_Enemy		; if not, branch
	cmpi.b	#$C0,d1			; is touch response $C0 or higher?
	beq.w	Touch_Special		; if yes, branch
	tst.b	d1			; is touch response $80-$BF?
	bmi.w	Touch_ChkHurt		; if yes, branch
	; touch response is $40-$7F
	move.b	collision_flags(a1),d0
	andi.b	#$3F,d0
	cmpi.b	#6,d0			; is touch response $46?
	beq.s	Touch_Monitor		; if yes, branch
	move.w	(MainCharacter+invulnerable_time).w,d0
	tst.w	(Two_player_mode).w
	beq.s	+
	move.w	invulnerable_time(a0),d0
+
	cmpi.w	#90,d0
	bhs.w	+
	move.b	#4,routine(a1)	; set the object's routine counter
	move.w	a0,parent(a1)
+
	rts
; ===========================================================================
; loc_3F73C:
Touch_Monitor:
	tst.w	y_vel(a0)	; is Sonic moving upwards?
	bpl.s	.breakMonitor	; if not, branch

	; If the center of Sonic is not under the bottom of the monitor, then
	; return. This is a way of checking if Sonic is jumping into the
	; bottom of the monitor, or just the side of it.
	move.w	y_pos(a0),d0
	subi.w	#$10,d0
	cmp.w	y_pos(a1),d0
	; Return. This means that if Sonic jumps upwards into the side of a
	; monitor, then he'll just phase through it.
	blo.s	return_3F78A

	; If we've gotten this far, then Sonic has just jumped into the
	; bottom of this monitor: knock it down.
	neg.w	y_vel(a0)	; reverse Sonic's y-motion
	move.w	#-$180,y_vel(a1)
	tst.b	routine_secondary(a1)
	bne.s	return_3F78A
	move.b	#4,routine_secondary(a1) ; set the monitor's routine counter
	rts
; ===========================================================================
; loc_3F768:
.breakMonitor:
	cmpa.w	#MainCharacter,a0
	beq.s	+
	tst.w	(Two_player_mode).w
	beq.s	return_3F78A
+
	cmpi.b	#AniIDSonAni_Roll,anim(a0)
	bne.s	return_3F78A
	neg.w	y_vel(a0)	; reverse Sonic's y-motion
	move.b	#4,routine(a1)
	move.w	a0,parent(a1)

return_3F78A:
	rts
; ===========================================================================
; loc_3F78C:
Touch_Enemy:
	btst	#status_secondary.invincible,status_secondary(a0)	; is Sonic invincible?
	bne.s	+			; if yes, branch
	cmpi.b	#AniIDSonAni_Spindash,anim(a0)
	beq.s	+
	cmpi.b	#AniIDSonAni_Roll,anim(a0)		; is Sonic rolling?
	bne.w	Touch_ChkHurt		; if not, branch
+
	btst	#render_flags.multi_sprite,render_flags(a1)
	beq.s	Touch_Enemy_Part2
	tst.b	boss_hitcount2(a1)
	beq.s	return_3F7C6
	neg.w	x_vel(a0)
	neg.w	y_vel(a0)
	move.b	#0,collision_flags(a1)
	subq.b	#1,boss_hitcount2(a1)

return_3F7C6:
	rts
; ---------------------------------------------------------------------------
; loc_3F7C8:
Touch_Enemy_Part2:
	tst.b	collision_property(a1)
	beq.s	Touch_KillEnemy
	neg.w	x_vel(a0)
	neg.w	y_vel(a0)
	move.b	#0,collision_flags(a1)
	subq.b	#1,collision_property(a1)
	bne.s	return_3F7E8
	bset	#status.npc.no_balancing,status(a1)

return_3F7E8:
	rts
; ===========================================================================
; loc_3F7EA:
Touch_KillEnemy:
	bset	#status.npc.no_balancing,status(a1)
	moveq	#0,d0
	move.w	(Chain_Bonus_counter).w,d0
	addq.w	#2,(Chain_Bonus_counter).w	; add 2 to chain bonus counter
	cmpi.w	#6,d0
	blo.s	loc_3F802
	moveq	#6,d0

loc_3F802:
	move.w	d0,objoff_3E(a1)
	move.w	Enemy_Points(pc,d0.w),d0
	cmpi.w	#$20,(Chain_Bonus_counter).w	; have 16 enemies been destroyed?
	blo.s	loc_3F81C			; if not, branch
	move.w	#1000,d0			; fix bonus to 10000 points
	move.w	#$A,objoff_3E(a1)

loc_3F81C:
	movea.w	a0,a3
	bsr.w	AddPoints2
	_move.b	#ObjID_Explosion,id(a1) ; load obj
	move.b	#0,routine(a1)

	; Decide how to bounce Sonic back.
	tst.w	y_vel(a0)
	bmi.s	loc_3F844
	move.w	y_pos(a0),d0
	cmp.w	y_pos(a1),d0
	bhs.s	loc_3F84C
	; If Sonic is jumping downwards onto an enemy, and lands directly on
	; top of it, then completely negate his Y velocity, giving him a big
	; bounce.
	neg.w	y_vel(a0)
	rts
; ===========================================================================

loc_3F844:
	; If Sonic is jumping upwards into an enemy, then bounce him back
	; down very slightly.
	addi.w	#$100,y_vel(a0)
	rts
; ===========================================================================

loc_3F84C:
	; If Sonic is jumping downwards onto an enemy, but is somehow not
	; above the enemy (such as when jumping into the *side* of an enemy),
	; then only give him a tiny bounce upwards.
	subi.w	#$100,y_vel(a0)
	rts
; ===========================================================================
; byte_3F854:
Enemy_Points:	dc.w 10, 20, 50, 100
; ===========================================================================

loc_3F85C:
	bset	#status.npc.no_balancing,status(a1)

; ---------------------------------------------------------------------------
; Subroutine for checking if Sonic/Tails should be hurt and hurting them if so
; note: Sonic or Tails must be at a0
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_3F862:
Touch_ChkHurt:
	btst	#status_secondary.invincible,status_secondary(a0)	; is Sonic invincible?
	beq.s	Touch_Hurt		; if not, branch
; loc_3F86A:
Touch_NoHurt:
	moveq	#-1,d0
	rts
; ---------------------------------------------------------------------------
; loc_3F86E:
Touch_Hurt:
	nop
	tst.w	invulnerable_time(a0)
	bne.s	Touch_NoHurt
	movea.l	a1,a2

; End of function TouchResponse
; continue straight to HurtCharacter

; ---------------------------------------------------------------------------
; Hurting Sonic/Tails subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_3F878: HurtSonic:
HurtCharacter:
	move.w	(Ring_count).w,d0
	cmpa.w	#MainCharacter,a0
	beq.s	loc_3F88C
	tst.w	(Two_player_mode).w
	beq.s	Hurt_Sidekick
	move.w	(Ring_count_2P).w,d0

loc_3F88C:
	btst	#status_secondary.shield,status_secondary(a0)
	bne.s	Hurt_Shield
	tst.w	d0
	beq.w	KillCharacter
	jsr	(AllocateObject).l
	bne.s	Hurt_Shield
	_move.b	#ObjID_LostRings,id(a1) ; load obj
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	a0,parent(a1)

; loc_3F8B8:
Hurt_Shield:
	bclr	#status_secondary.shield,status_secondary(a0) ; remove shield

; loc_3F8BE:
Hurt_Sidekick:
	move.b	#4,routine(a0)
	jsrto	JmpTo_Sonic_ResetOnFloor_Part2
	bset	#status.player.in_air,status(a0)
	move.w	#-$400,y_vel(a0) ; make Sonic bounce away from the object
	move.w	#-$200,x_vel(a0)
	btst	#status.player.underwater,status(a0)	; underwater?
	beq.s	Hurt_Reverse	; if not, branch
	move.w	#-$200,y_vel(a0) ; bounce slower
	move.w	#-$100,x_vel(a0)

; loc_3F8EE:
Hurt_Reverse:
	move.w	x_pos(a0),d0
	cmp.w	x_pos(a2),d0
	blo.s	Hurt_ChkSpikes	; if Sonic is left of the object, branch
	neg.w	x_vel(a0)	; if Sonic is right of the object, reverse

; loc_3F8FC:
Hurt_ChkSpikes:
	move.w	#0,inertia(a0)
	move.b	#AniIDSonAni_Hurt2,anim(a0)
	move.w	#$78,invulnerable_time(a0)
	move.w	#SndID_Hurt,d0	; load normal damage sound
	cmpi.b	#ObjID_Spikes,id(a2)	; was damage caused by spikes?
	bne.s	Hurt_Sound	; if not, branch
	move.w	#SndID_HurtBySpikes,d0	; load spikes damage sound

; loc_3F91C:
Hurt_Sound:
	jsr	(PlaySound).l
	moveq	#-1,d0
	rts
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to kill Sonic or Tails
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_3F926: KillSonic:
KillCharacter:
	tst.w	(Debug_placement_mode).w
	bne.s	++
	clr.b	status_secondary(a0)
	move.b	#6,routine(a0)
	jsrto	JmpTo_Sonic_ResetOnFloor_Part2
	bset	#status.player.in_air,status(a0)
	move.w	#-$700,y_vel(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,inertia(a0)
	move.b	#AniIDSonAni_Death,anim(a0)
	bset	#high_priority_bit,art_tile(a0)
	move.w	#SndID_Hurt,d0
	cmpi.b	#ObjID_Spikes,id(a2)
	bne.s	+
	move.w	#SndID_HurtBySpikes,d0
+
	jsr	(PlaySound).l
+
	moveq	#-1,d0
	rts
; ===========================================================================
;loc_3F976:
Touch_Special:
	move.b	collision_flags(a1),d1
	andi.b	#$3F,d1
	cmpi.b	#6,d1
	beq.s	loc_3FA00
	cmpi.b	#7,d1
	beq.w	loc_3FA18
	cmpi.b	#$B,d1
	beq.s	BranchTo_loc_3F85C
	cmpi.b	#$A,d1
	beq.s	loc_3FA00
	cmpi.b	#$C,d1
	beq.s	loc_3F9CE
	cmpi.b	#$14,d1
	beq.s	loc_3FA00
	cmpi.b	#$15,d1
	beq.s	loc_3FA00
	cmpi.b	#$16,d1
	beq.s	loc_3FA00
	cmpi.b	#$17,d1
	beq.s	loc_3FA00
	cmpi.b	#$18,d1
	beq.s	loc_3FA00
	cmpi.b	#$1A,d1
	beq.s	loc_3FA22
	cmpi.b	#$21,d1
	beq.s	loc_3FA12
	rts
; ===========================================================================

BranchTo_loc_3F85C ; BranchTo
	bra.w	loc_3F85C
; ===========================================================================

loc_3F9CE:
	sub.w	d0,d5
	cmpi.w	#8,d5
	bhs.s	BranchTo_Touch_Enemy
	move.w	x_pos(a1),d0
	subq.w	#4,d0
	btst	#status.npc.x_flip,status(a1)
	beq.s	loc_3F9E8
	subi.w	#$10,d0

loc_3F9E8:
	sub.w	d2,d0
	bcc.s	loc_3F9F4
	addi.w	#$18,d0
	bcs.s	BranchTo_Touch_ChkHurt
	bra.s	BranchTo_Touch_Enemy
; ===========================================================================

loc_3F9F4:
	cmp.w	d4,d0
	bhi.s	BranchTo_Touch_Enemy

BranchTo_Touch_ChkHurt ; BranchTo
	bra.w	Touch_ChkHurt
; ===========================================================================

BranchTo_Touch_Enemy ; BranchTo
	bra.w	Touch_Enemy
; ===========================================================================

loc_3FA00:
	move.w	a0,d1
	subi.w	#MainCharacter,d1
	beq.s	+
	addq.b	#1,collision_property(a1)
+
	addq.b	#1,collision_property(a1)
	rts
; ===========================================================================

loc_3FA12:
	addq.b	#1,collision_property(a1)
	rts
; ===========================================================================

loc_3FA18:
	move.b	#2,collision_property(a1)
	bra.w	Touch_Enemy
; ===========================================================================

loc_3FA22:
	move.b	#-1,collision_property(a1)
	bra.w	Touch_Enemy
; ===========================================================================
; loc_3FA2C:
BossSpecificCollision:
	cmpi.b	#$F,d0
	bne.s	+	; rts
	moveq	#0,d0
	move.b	(Current_Boss_ID).w,d0
	beq.s	+	; rts
	subq.w	#1,d0
	add.w	d0,d0
	move.w	BossCollision_Index(pc,d0.w),d0
	jmp	BossCollision_Index(pc,d0.w)
; ===========================================================================
+	rts
; ===========================================================================
; off_3FA48:
BossCollision_Index:offsetTable	; jump depending on boss ID
	offsetTableEntry.w BossCollision_EHZ_CPZ
	offsetTableEntry.w BossCollision_EHZ_CPZ
	offsetTableEntry.w BossCollision_HTZ
	offsetTableEntry.w BossCollision_ARZ
	offsetTableEntry.w BossCollision_MCZ
	offsetTableEntry.w BossCollision_CNZ
	offsetTableEntry.w BossCollision_MTZ
	offsetTableEntry.w BossCollision_OOZ
	offsetTableEntry.w return_3FA5E
; ===========================================================================
;loc_3FA5A:
BossCollision_EHZ_CPZ:
	move.b	collision_flags(a1),d0

return_3FA5E:
	rts
; ===========================================================================
;loc_3FA60:
BossCollision_HTZ:
	tst.b	(Boss_CollisionRoutine).w
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	move.w	d7,-(sp)
	moveq	#0,d1
	move.b	objoff_15(a1),d1
	subq.b	#2,d1
	cmpi.b	#7,d1
	bgt.s	loc_3FAA8
	move.w	d1,d7
	add.w	d7,d7
	move.w	x_pos(a1),d0
	btst	#render_flags.x_flip,render_flags(a1)
	beq.s	loc_3FA8E
	add.w	word_3FAB0(pc,d7.w),d0
	bra.s	loc_3FA92
; ===========================================================================

loc_3FA8E:
	sub.w	word_3FAB0(pc,d7.w),d0

loc_3FA92:
	move.b	byte_3FAC0(pc,d1.w),d1
	ori.l	#$40000,d1
	move.w	y_pos(a1),d7
	subi.w	#$1C,d7
	bsr.w	Boss_DoCollision

loc_3FAA8:
	move.w	(sp)+,d7
	move.b	collision_flags(a1),d0
	rts
; ===========================================================================
word_3FAB0:
	dc.w   $1C
	dc.w   $20	; 1
	dc.w   $28	; 2
	dc.w   $34	; 3
	dc.w   $3C	; 4
	dc.w   $44	; 5
	dc.w   $60	; 6
	dc.w   $70	; 7
byte_3FAC0:
	dc.b   4
	dc.b   4	; 1
	dc.b   8	; 2
	dc.b  $C	; 3
	dc.b $14	; 4
	dc.b $1C	; 5
	dc.b $24	; 6
	dc.b   8	; 7
	even
; ===========================================================================
;loc_3FAC8:
BossCollision_ARZ:
	move.w	d7,-(sp)
	move.w	x_pos(a1),d0
	move.w	y_pos(a1),d7
	tst.b	(Boss_CollisionRoutine).w
	beq.s	++
	addi_.w	#4,d7
	subi.w	#$50,d0
	btst	#render_flags.x_flip,render_flags(a1)
	beq.s	+
	addi.w	#$A0,d0
+
	move.l	#$140010,d1
	bsr.w	Boss_DoCollision
+
	move.w	(sp)+,d7
	move.b	collision_flags(a1),d0
	rts
; ===========================================================================
;loc_3FAFE:
BossCollision_MCZ:
	sf	boss_hurt_sonic(a1)
	cmpi.b	#1,(Boss_CollisionRoutine).w
	blt.s	BossCollision_MCZ2
; Boss_CollisionRoutine = 1, i.e. diggers pointing to the side
    if fixBugs
	; The below call to 'Boss_DoCollision' clobbers 'a1', so back it up
	; here. This fixes Eggman not laughing when he hurts Sonic.
	movem.w	d7/a1,-(sp)
    else
	move.w	d7,-(sp)
    endif
	move.w	x_pos(a1),d0
	move.w	y_pos(a1),d7
	addi_.w	#4,d7
	subi.w	#$30,d0
	btst	#render_flags.x_flip,render_flags(a1)	; left or right?
	beq.s	+
	addi.w	#$60,d0			; x+$30, otherwise x-$30
+
	move.l	#$40004,d1		; heigth 4, width 4
	bsr.w	Boss_DoCollision
    if fixBugs
	; See the above bugfix.
	movem.w	(sp)+,d7/a1
    else
	move.w	(sp)+,d7
    endif
	move.b	collision_flags(a1),d0
	cmpi.w	#$78,invulnerable_time(a0)
	bne.s	+	; rts
	st.b	boss_hurt_sonic(a1)	; Sonic has just been hurt flag
+
	rts
; ===========================================================================
; Boss_CollisionRoutine = 0, i.e. diggers pointing towards top
;loc_3FB46:
BossCollision_MCZ2:
	move.w	d7,-(sp)
	movea.w	#$14,a5
	movea.w	#0,a4

-	move.w	x_pos(a1),d0
	move.w	y_pos(a1),d7
	subi.w	#$20,d7
	add.w	a5,d0			; first check x+$14, second x-$14
	move.l	#$100004,d1		; heigth $10, width 4
	bsr.w	Boss_DoCollision
	movea.w	#-$14,a5
	adda_.w	#1,a4
	cmpa.w	#1,a4
	beq.s	-			; jump back once for second check
	move.w	(sp)+,d7
	move.b	collision_flags(a1),d0
	cmpi.w	#$78,invulnerable_time(a0)
	bne.s	+	; rts
	st.b	boss_hurt_sonic(a1)	; Sonic has just been hurt flag
+
	rts
; ===========================================================================
;loc_3FB8A:
BossCollision_CNZ:
	tst.b	(Boss_CollisionRoutine).w
	beq.s	++
	move.w	d7,-(sp)
	move.w	x_pos(a1),d0
	move.w	y_pos(a1),d7
	addi.w	#$28,d7
	move.l	#$80010,d1
	cmpi.b	#1,(Boss_CollisionRoutine).w
	beq.s	+
	move.w	#$20,d1
	subi_.w	#8,d7
	addi_.w	#4,d0
+
	bsr.w	Boss_DoCollision
	move.w	(sp)+,d7
+
	move.b	collision_flags(a1),d0
	rts
; ===========================================================================
;loc_3FBC4:
BossCollision_MTZ:
	move.b	collision_flags(a1),d0
	rts
; ===========================================================================
;loc_3FBCA:
BossCollision_OOZ:
	cmpi.b	#1,(Boss_CollisionRoutine).w
	blt.s	loc_3FC46
	beq.s	loc_3FC1C
	move.w	d7,-(sp)
	move.w	x_pos(a1),d0
	move.w	y_pos(a1),d7
	moveq	#0,d1
	move.b	mainspr_mapframe(a1),d1
	subq.b	#2,d1
	add.w	d1,d1
	btst	#render_flags.x_flip,render_flags(a1)
	beq.s	loc_3FBF6
	add.w	word_3FC10(pc,d1.w),d0
	bra.s	loc_3FBFA
; ===========================================================================

loc_3FBF6:
	sub.w	word_3FC10(pc,d1.w),d0

loc_3FBFA:
	sub.w	word_3FC10+2(pc,d1.w),d7
	move.l	#$60008,d1
	bsr.w	Boss_DoCollision
	move.w	(sp)+,d7
	move.w	#0,d0
	rts
; ===========================================================================
word_3FC10:
	dc.w   $14,    0
	dc.w   $10,  $10
	dc.w   $10, -$10
; ===========================================================================

loc_3FC1C:
	move.w	d7,-(sp)
	move.w	x_pos(a1),d0
	move.w	y_pos(a1),d7
	moveq	#$10,d1
	btst	#render_flags.x_flip,render_flags(a1)
	beq.s	+
	neg.w	d1
+
	sub.w	d1,d0
	move.l	#$8000C,d1
	bsr.w	loc_3FC7A
	move.w	(sp)+,d7
	move.b	#0,d0
	rts
; ===========================================================================

loc_3FC46:
	move.b	collision_flags(a1),d0
	rts
; ===========================================================================
;loc_3FC4C:
	; d7 = y_boss, d3 = y_Sonic, d1 (high word) = height
	; d0 = x_boss, d2 = x_Sonic, d1 (low word)  = width
Boss_DoCollision:
	sub.w	d1,d0
	sub.w	d2,d0
	bcc.s	loc_3FC5A
	add.w	d1,d1
	add.w	d1,d0
	bcs.s	loc_3FC5E

return_3FC58:
	rts
; ===========================================================================

loc_3FC5A:
	cmp.w	d4,d0
	bhi.s	return_3FC58

loc_3FC5E:
	swap	d1
	sub.w	d1,d7
	sub.w	d3,d7
	bcc.s	loc_3FC70
	add.w	d1,d1
	add.w	d1,d7
	bcs.w	Touch_ChkHurt
	bra.s	return_3FC58
; ===========================================================================

loc_3FC70:
	cmp.w	d5,d7
	bhi.w	return_3FC58
	bra.w	Touch_ChkHurt
; ===========================================================================

loc_3FC7A:
	sub.w	d1,d0
	sub.w	d2,d0
	bcc.s	loc_3FC88
	add.w	d1,d1
	add.w	d1,d0
	bcs.s	loc_3FC8C

return_3FC86:
	rts
; ===========================================================================

loc_3FC88:
	cmp.w	d4,d0
	bhi.s	return_3FC86

loc_3FC8C:
	swap	d1
	sub.w	d1,d7
	sub.w	d3,d7
	bcc.s	loc_3FC9E
	add.w	d1,d1
	add.w	d1,d7
	bcs.w	loc_3FCA4
	bra.s	return_3FC86
; ===========================================================================

loc_3FC9E:
	cmp.w	d5,d7
	bhi.w	return_3FC86

loc_3FCA4:
	neg.w	x_vel(a0)
	neg.w	y_vel(a0)
	rts
; ===========================================================================

	jmpTos JmpTo_Sonic_ResetOnFloor_Part2,JmpTo_Check_CNZ_bumpers,JmpTo_Touch_Rings




; ===========================================================================
;loc_3FCC4:
AniArt_Load:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	PLC_DYNANM+2(pc,d0.w),d1
	lea	PLC_DYNANM(pc,d1.w),a2
	move.w	PLC_DYNANM(pc,d0.w),d0
	jmp	PLC_DYNANM(pc,d0.w)
; ===========================================================================
	rts
; ===========================================================================




; ---------------------------------------------------------------------------
; ZONE ANIMATION PROCEDURES AND SCRIPTS
;
; Each zone gets two entries in this jump table. The first entry points to the
; zone's animation procedure (usually Dynamic_Normal, but some zones have special
; procedures for complicated animations). The second points to the zone's animation
; script.
;
; Note that Animated_Null is not a valid animation script, so don't pair it up
; with anything except Dynamic_Null, or bad things will happen (for example, a bus error exception).
; ---------------------------------------------------------------------------
PLC_DYNANM: zoneOrderedOffsetTable 2,2
	zoneOffsetTableEntry.w Dynamic_Normal	; EHZ
	zoneOffsetTableEntry.w Animated_EHZ

	zoneOffsetTableEntry.w Dynamic_Null	; Zone 1
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_Null	; WZ
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_Null	; Zone 3
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_Normal	; MTZ1,2
	zoneOffsetTableEntry.w Animated_MTZ

	zoneOffsetTableEntry.w Dynamic_Normal	; MTZ3
	zoneOffsetTableEntry.w Animated_MTZ

	zoneOffsetTableEntry.w Dynamic_Null	; WFZ
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_HTZ	; HTZ
	zoneOffsetTableEntry.w Animated_HTZ

	zoneOffsetTableEntry.w Dynamic_Normal	; HPZ
	zoneOffsetTableEntry.w Animated_HPZ

	zoneOffsetTableEntry.w Dynamic_Null	; Zone 9
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_Normal	; OOZ
	zoneOffsetTableEntry.w Animated_OOZ

	zoneOffsetTableEntry.w Dynamic_Null	; MCZ
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_CNZ	; CNZ
	zoneOffsetTableEntry.w Animated_CNZ

	zoneOffsetTableEntry.w Dynamic_Normal	; CPZ
	zoneOffsetTableEntry.w Animated_CPZ

	zoneOffsetTableEntry.w Dynamic_Normal	; DEZ
	zoneOffsetTableEntry.w Animated_DEZ

	zoneOffsetTableEntry.w Dynamic_ARZ	; ARZ
	zoneOffsetTableEntry.w Animated_ARZ

	zoneOffsetTableEntry.w Dynamic_Null	; SCZ
	zoneOffsetTableEntry.w Animated_Null
    zoneTableEnd
; ===========================================================================

Dynamic_Null:
	rts
; ===========================================================================

Dynamic_HTZ:
	; More unused two-player code...
	tst.w	(Two_player_mode).w
	bne.w	Dynamic_Normal

;.doMountainArt:
	; Upload dynamic mountain art.
	lea	(Anim_Counters).w,a3
	moveq	#0,d0
	move.w	(Camera_X_pos).w,d1
	neg.w	d1
	asr.w	#3,d1
	move.w	(Camera_X_pos).w,d0
	lsr.w	#4,d0
	add.w	d1,d0
	subi.w	#$10,d0
	divu.w	#$30,d0
	swap	d0
	cmp.b	1(a3),d0
	beq.s	.skipMountainArt
	move.b	d0,1(a3)
	move.w	d0,d2
	andi.w	#7,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	andi.w	#$38,d2
	lsr.w	#2,d2
	add.w	d2,d0
	lea	.offsets(pc,d0.w),a4
	moveq	#5,d5
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_HTZMountains),d4
; loc_3FD7C:
.mountainLoop:
	moveq	#-1,d1
	move.w	(a4)+,d1
	andi.l	#$FFFFFF,d1
	move.w	d4,d2
	moveq	#tiles_to_words(4),d3	; DMA transfer length (in words)
	jsr	(QueueDMATransfer).l
	addi.w	#$80,d4
	dbf	d5,.mountainLoop
; BranchTo_loc_3FE5C ; BranchTo
.skipMountainArt:
	bra.w	.doCloudArt
; ===========================================================================
; HTZ mountain art main RAM addresses?
;word_3FD9C:
.offsets:
	dc.w   $80, $180, $280, $580, $600, $700	; 6
	dc.w   $80, $180, $280, $580, $600, $700	; 12
	dc.w  $980, $A80, $B80, $C80, $D00, $D80	; 18
	dc.w  $980, $A80, $B80, $C80, $D00, $D80	; 24
	dc.w  $E80,$1180,$1200,$1280,$1300,$1380	; 30
	dc.w  $E80,$1180,$1200,$1280,$1300,$1380	; 36
	dc.w $1400,$1480,$1500,$1580,$1600,$1900	; 42
	dc.w $1400,$1480,$1500,$1580,$1600,$1900	; 48
	dc.w $1D00,$1D80,$1E00,$1F80,$2400,$2580	; 54
	dc.w $1D00,$1D80,$1E00,$1F80,$2400,$2580	; 60
	dc.w $2600,$2680,$2780,$2B00,$2F00,$3280	; 66
	dc.w $2600,$2680,$2780,$2B00,$2F00,$3280	; 72
	dc.w $3600,$3680,$3780,$3C80,$3D00,$3F00	; 78
	dc.w $3600,$3680,$3780,$3C80,$3D00,$3F00	; 84
	dc.w $3F80,$4080,$4480,$4580,$4880,$4900	; 90
	dc.w $3F80,$4080,$4480,$4580,$4880,$4900	; 96
; ===========================================================================
; loc_3FE5C:
.doCloudArt:
	; Upload dynamic cloud art.
	lea	(TempArray_LayerDef).w,a1
	move.w	(Camera_X_pos).w,d2
	neg.w	d2
	asr.w	#3,d2
	move.l	a2,-(sp)
	lea	(ArtUnc_HTZClouds).l,a0
	lea	(Chunk_Table+$7C00).l,a2
	moveq	#16-1,d1
; loc_3FE78:
.cloudLoop:
	move.w	(a1)+,d0
	neg.w	d0
	add.w	d2,d0
	andi.w	#$1F,d0
	lsr.w	#1,d0
	bcc.s	+
	addi.w	#$200,d0
+
	lea	(a0,d0.w),a4
	lsr.w	#1,d0
	bcs.s	.odd

;.even:
	; The same as below, but does not safely handle odd addresses.
    rept 3
	move.l	(a4)+,(a2)+
	adda.w	#$40-4,a2
    endm
	move.l	(a4)+,(a2)+
	suba.w	#$40*3,a2
	adda.w	#$20,a0
	dbf	d1,.cloudLoop
	bra.s	.done
; ===========================================================================
; loc_3FEB4:
.odd:
	; The same as below, but safely handles odd addresses.
    rept 3
      rept 4
	move.b	(a4)+,(a2)+
      endm
	adda.w	#$40-4,a2
    endm
    rept 4
	move.b	(a4)+,(a2)+
    endm
	suba.w	#$40*3,a2
	adda.w	#$20,a0
	dbf	d1,.cloudLoop
; loc_3FEEC:
.done:
	move.l	#(Chunk_Table+$7C00) & $FFFFFF,d1
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_HTZClouds),d2
	move.w	#tiles_to_words(8),d3	; DMA transfer length (in words)
	jsr	(QueueDMATransfer).l
	movea.l	(sp)+,a2
	addq.w	#2,a3
	bra.w	Dynamic_Normal.customCounters
; ===========================================================================

Dynamic_CNZ:
	tst.b	(Current_Boss_ID).w
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+
	lea	(Animated_CNZ).l,a2
	tst.w	(Two_player_mode).w
	beq.s	Dynamic_Normal
	lea	(Animated_CNZ_2P).l,a2
	bra.s	Dynamic_Normal
; ===========================================================================

Dynamic_ARZ:
	tst.b	(Current_Boss_ID).w
	beq.s	Dynamic_Normal
	rts
; ===========================================================================

Dynamic_Normal:
	lea	(Anim_Counters).w,a3
; loc_3FF30:
.customCounters:
	move.w	(a2)+,d6	; Get number of scripts in list
	; S&K checks for empty lists, here
;	bpl.s	.listnotempty	; If there are any, continue
;	rts
;.listnotempty:

; loc_3FF32:
.loop:
	subq.b	#1,(a3)		; Tick down frame duration
	bcc.s	.nextscript	; If frame isn't over, move on to next script

;.nextframe:
	moveq	#0,d0
	move.b	1(a3),d0	; Get current frame
	cmp.b	6(a2),d0	; Have we processed the last frame in the script?
	blo.s	.notlastframe
	moveq	#0,d0		; If so, reset to first frame
	move.b	d0,1(a3)	; ''
; loc_3FF48:
.notlastframe:
	addq.b	#1,1(a3)	; Consider this frame processed; set counter to next frame
	move.b	(a2),(a3)	; Set frame duration to global duration value
	bpl.s	.globalduration
	; If script uses per-frame durations, use those instead
	add.w	d0,d0
	move.b	9(a2,d0.w),(a3)	; Set frame duration to current frame's duration value
; loc_3FF56:
.globalduration:
; Prepare for DMA transfer
	; Get relative address of frame's art
	move.b	8(a2,d0.w),d0	; Get tile ID
	lsl.w	#5,d0		; Turn it into an offset
	; Get VRAM destination address
	move.w	4(a2),d2
	; Get ROM source address
	move.l	(a2),d1		; Get start address of animated tile art
	andi.l	#$FFFFFF,d1
	add.l	d0,d1		; Offset into art, to get the address of new frame
	; Get size of art to be transferred
	moveq	#0,d3
	move.b	7(a2),d3
	lsl.w	#4,d3		; Turn it into actual size (in words)
	; Use d1, d2 and d3 to queue art for transfer
	jsr	(QueueDMATransfer).l
; loc_3FF78:
.nextscript:
	move.b	6(a2),d0	; Get total size of frame data
	tst.b	(a2)		; Is per-frame duration data present?
	bpl.s	.globalduration2; If not, keep the current size; it's correct
	add.b	d0,d0		; Double size to account for the additional frame duration data
; loc_3FF82:
.globalduration2:
	addq.b	#1,d0
	andi.w	#$FE,d0		; Round to next even address, if it isn't already
	lea	8(a2,d0.w),a2	; Advance to next script in list
	addq.w	#2,a3		; Advance to next script's slot in a3 (usually Anim_Counters)
	dbf	d6,.loop
	rts
; ===========================================================================
; ZONE ANIMATION SCRIPTS
;
; The Dynamic_Normal subroutine uses these scripts to reload certain tiles,
; thus animating them. All the relevant art must be uncompressed, because
; otherwise the subroutine would spend so much time waiting for the art to be
; decompressed that the VBLANK window would close before all the animating was done.

;    zoneanimdecl -1, ArtUnc_Flowers1, ArtTile_ArtUnc_Flowers1, 6, 2
;	-1			Global frame duration. If -1, then each frame will use its own duration, instead
;	ArtUnc_Flowers1		Source address
;	ArtTile_ArtUnc_Flowers1	Destination VRAM address
;	6			Number of frames
;	2			Number of tiles to load into VRAM for each frame

;    dc.b   0,$7F		; Start of the script proper
;	0			Tile ID of first tile in ArtUnc_Flowers1 to transfer
;	$7F			Frame duration. Only here if global duration is -1

; loc_3FF94:
Animated_EHZ:	zoneanimstart
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers1, ArtTile_ArtUnc_Flowers1, 6, 2
	dc.b   0,$7F		; Start of the script proper
	dc.b   2,$13
	dc.b   0,  7
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2,  7
	even
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers2, ArtTile_ArtUnc_Flowers2, 8, 2
	dc.b   2,$7F
	dc.b   0, $B
	dc.b   2, $B
	dc.b   0, $B
	dc.b   2,  5
	dc.b   0,  5
	dc.b   2,  5
	dc.b   0,  5
	even
	; Flowers
	zoneanimdecl 7, ArtUnc_Flowers3, ArtTile_ArtUnc_Flowers3, 2, 2
	dc.b   0
	dc.b   2
	even
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers4, ArtTile_ArtUnc_Flowers4, 8, 2
	dc.b   0,$7F
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2, $B
	dc.b   0, $B
	dc.b   2, $B
	even
	; Pulsing thing against checkered background
	zoneanimdecl -1, ArtUnc_EHZPulseBall, ArtTile_ArtUnc_EHZPulseBall, 6, 2
	dc.b   0,$17
	dc.b   2,  9
	dc.b   4, $B
	dc.b   6,$17
	dc.b   4, $B
	dc.b   2,  9
	even

	zoneanimend

Animated_MTZ:	zoneanimstart
	; Spinning metal cylinder
	zoneanimdecl 0, ArtUnc_MTZCylinder, ArtTile_ArtUnc_MTZCylinder, 8,$10
	dc.b   0
	dc.b $10
	dc.b $20
	dc.b $30
	dc.b $40
	dc.b $50
	dc.b $60
	dc.b $70
	even
	; lava
	zoneanimdecl $D, ArtUnc_Lava, ArtTile_ArtUnc_Lava, 6,$C
	dc.b   0
	dc.b  $C
	dc.b $18
	dc.b $24
	dc.b $18
	dc.b  $C
	even
	; MTZ background animated section
	zoneanimdecl -1, ArtUnc_MTZAnimBack, ArtTile_ArtUnc_MTZAnimBack_1, 4, 6
	dc.b   0,$13
	dc.b   6,  7
	dc.b  $C,$13
	dc.b   6,  7
	even
	; MTZ background animated section
	zoneanimdecl -1, ArtUnc_MTZAnimBack, ArtTile_ArtUnc_MTZAnimBack_2, 4, 6
	dc.b  $C,$13
	dc.b   6,  7
	dc.b   0,$13
	dc.b   6,  7
	even

	zoneanimend

Animated_HTZ:	zoneanimstart
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers1, ArtTile_ArtUnc_Flowers1, 6, 2
	dc.b   0,$7F
	dc.b   2,$13
	dc.b   0,  7
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2,  7
	even
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers2, ArtTile_ArtUnc_Flowers2, 8, 2
	dc.b   2,$7F
	dc.b   0, $B
	dc.b   2, $B
	dc.b   0, $B
	dc.b   2,  5
	dc.b   0,  5
	dc.b   2,  5
	dc.b   0,  5
	even
	; Flowers
	zoneanimdecl 7, ArtUnc_Flowers3, ArtTile_ArtUnc_Flowers3, 2, 2
	dc.b   0
	dc.b   2
	even
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers4, ArtTile_ArtUnc_Flowers4, 8, 2
	dc.b   0,$7F
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2, $B
	dc.b   0, $B
	dc.b   2, $B
	even
	; Pulsing thing against checkered background
	zoneanimdecl -1, ArtUnc_EHZPulseBall, ArtTile_ArtUnc_EHZPulseBall, 6, 2
	dc.b   0,$17
	dc.b   2,  9
	dc.b   4, $B
	dc.b   6,$17
	dc.b   4, $B
	dc.b   2,  9
	even

	zoneanimend

; word_4009C: Animated_OOZ:
Animated_HPZ:	zoneanimstart
	; Supposed to be the pulsing orb from HPZ, but uses OOZ's pulsing ball art
	zoneanimdecl 8, ArtUnc_HPZPulseOrb, ArtTile_ArtUnc_HPZPulseOrb_1, 6, 8
	dc.b   0
	dc.b   0
	dc.b   8
	dc.b $10
	dc.b $10
	dc.b   8
	even
	; Supposed to be the pulsing orb from HPZ, but uses OOZ's pulsing ball art
	zoneanimdecl 8, ArtUnc_HPZPulseOrb, ArtTile_ArtUnc_HPZPulseOrb_2, 6, 8
	dc.b   8
	dc.b $10
	dc.b $10
	dc.b   8
	dc.b   0
	dc.b   0
	even
	; Supposed to be the pulsing orb from HPZ, but uses OOZ's pulsing ball art
	zoneanimdecl 8, ArtUnc_HPZPulseOrb, ArtTile_ArtUnc_HPZPulseOrb_3, 6, 8
	dc.b $10
	dc.b   8
	dc.b   0
	dc.b   0
	dc.b   8
	dc.b $10
	even

	zoneanimend

; word_400C8:  Animated_OOZ2:
Animated_OOZ:	zoneanimstart
	; Pulsing ball from OOZ
	zoneanimdecl -1, ArtUnc_OOZPulseBall, ArtTile_ArtUnc_OOZPulseBall, 4, 4
	dc.b   0, $B
	dc.b   4,  5
	dc.b   8,  9
	dc.b   4,  3
	even
	; Square rotating around ball in OOZ
	zoneanimdecl 6, ArtUnc_OOZSquareBall1, ArtTile_ArtUnc_OOZSquareBall1, 4, 4
	dc.b   0
	dc.b   4
	dc.b   8
	dc.b  $C
	even
	; Square rotating around ball
	zoneanimdecl 6, ArtUnc_OOZSquareBall2, ArtTile_ArtUnc_OOZSquareBall2, 4, 4
	dc.b   0
	dc.b   4
	dc.b   8
	dc.b  $C
	even
	; Oil
	zoneanimdecl $11, ArtUnc_Oil1, ArtTile_ArtUnc_Oil1, 6,$10
	dc.b   0
	dc.b $10
	dc.b $20
	dc.b $30
	dc.b $20
	dc.b $10
	even
	; Oil
	zoneanimdecl $11, ArtUnc_Oil2, ArtTile_ArtUnc_Oil2, 6,$10
	dc.b   0
	dc.b $10
	dc.b $20
	dc.b $30
	dc.b $20
	dc.b $10
	even

	zoneanimend

Animated_CNZ:	zoneanimstart
	; Flipping foreground section in CNZ
	zoneanimdecl -1, ArtUnc_CNZFlipTiles, ArtTile_ArtUnc_CNZFlipTiles_2, $10,$10
	dc.b   0,$C7
	dc.b $10,  5
	dc.b $20,  5
	dc.b $30,  5
	dc.b $40,$C7
	dc.b $50,  5
	dc.b $20,  5
	dc.b $60,  5
	dc.b   0,  5
	dc.b $10,  5
	dc.b $20,  5
	dc.b $30,  5
	dc.b $40,  5
	dc.b $50,  5
	dc.b $20,  5
	dc.b $60,  5
	even
	; Flipping foreground section in CNZ
	zoneanimdecl -1, ArtUnc_CNZFlipTiles, ArtTile_ArtUnc_CNZFlipTiles_1, $10,$10
	dc.b $70,  5
	dc.b $80,  5
	dc.b $20,  5
	dc.b $90,  5
	dc.b $A0,  5
	dc.b $B0,  5
	dc.b $20,  5
	dc.b $C0,  5
	dc.b $70,$C7
	dc.b $80,  5
	dc.b $20,  5
	dc.b $90,  5
	dc.b $A0,$C7
	dc.b $B0,  5
	dc.b $20,  5
	dc.b $C0,  5
	even

	zoneanimend

; word_40160:
Animated_CNZ_2P:	zoneanimstart
	; Flipping foreground section in CNZ
	zoneanimdecl -1, ArtUnc_CNZFlipTiles, ArtTile_ArtUnc_CNZFlipTiles_2_2p, $10,$10
	dc.b   0,$C7
	dc.b $10,  5
	dc.b $20,  5
	dc.b $30,  5
	dc.b $40,$C7
	dc.b $50,  5
	dc.b $20,  5
	dc.b $60,  5
	dc.b   0,  5
	dc.b $10,  5
	dc.b $20,  5
	dc.b $30,  5
	dc.b $40,  5
	dc.b $50,  5
	dc.b $20,  5
	dc.b $60,  5
	even
	; Flipping foreground section in CNZ
	zoneanimdecl -1, ArtUnc_CNZFlipTiles, ArtTile_ArtUnc_CNZFlipTiles_1_2p, $10,$10
	dc.b $70,  5
	dc.b $80,  5
	dc.b $20,  5
	dc.b $90,  5
	dc.b $A0,  5
	dc.b $B0,  5
	dc.b $20,  5
	dc.b $C0,  5
	dc.b $70,$C7
	dc.b $80,  5
	dc.b $20,  5
	dc.b $90,  5
	dc.b $A0,$C7
	dc.b $B0,  5
	dc.b $20,  5
	dc.b $C0,  5
	even

	zoneanimend

Animated_CPZ:	zoneanimstart
	; Animated background section in CPZ and DEZ
	zoneanimdecl 4, ArtUnc_CPZAnimBack, ArtTile_ArtUnc_CPZAnimBack, 8, 2
	dc.b   0
	dc.b   2
	dc.b   4
	dc.b   6
	dc.b   8
	dc.b  $A
	dc.b  $C
	dc.b  $E
	even

	zoneanimend

Animated_DEZ:	zoneanimstart
	; Animated background section in CPZ and DEZ
	zoneanimdecl 4, ArtUnc_CPZAnimBack, ArtTile_ArtUnc_DEZAnimBack, 8, 2
	dc.b   0
	dc.b   2
	dc.b   4
	dc.b   6
	dc.b   8
	dc.b  $A
	dc.b  $C
	dc.b  $E
	even

	zoneanimend

Animated_ARZ:	zoneanimstart
	; Waterfall patterns
	zoneanimdecl 5, ArtUnc_Waterfall1, ArtTile_ArtUnc_Waterfall1_2, 2, 4
	dc.b   0
	dc.b   4
	even
	; Waterfall patterns
	zoneanimdecl 5, ArtUnc_Waterfall1, ArtTile_ArtUnc_Waterfall1_1, 2, 4
	dc.b   4
	dc.b   0
	even
	; Waterfall patterns
	zoneanimdecl 5, ArtUnc_Waterfall2, ArtTile_ArtUnc_Waterfall2, 2, 4
	dc.b   0
	dc.b   4
	even
	; Waterfall patterns
	zoneanimdecl 5, ArtUnc_Waterfall3, ArtTile_ArtUnc_Waterfall3, 2, 4
	dc.b   0
	dc.b   4
	even

	zoneanimend

Animated_Null:
	; invalid
; ===========================================================================

; ---------------------------------------------------------------------------
; Unused mystery function
; In CPZ, within a certain range of camera X coordinates spanning
; exactly 2 screens (a boss fight or cutscene?),
; once every 8 frames, make the entire screen refresh and do... SOMETHING...
; (in 2 separate 512-byte blocks of memory, move around a bunch of bytes)
; Maybe some abandoned scrolling effect?
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_40200:
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	beq.s	+
-	rts
; ===========================================================================
; this shifts all blocks of the chunks $EA-$ED and $FA-$FD one block to the
; left and the last block in each row (chunk $ED/$FD) to the beginning
; i.e. rotates the blocks to the left by one
+
	move.w	(Camera_X_pos).w,d0
	cmpi.w	#$1940,d0
	blo.s	-	; rts
	cmpi.w	#$1F80,d0
	bhs.s	-	; rts
	subq.b	#1,(CPZ_UnkScroll_Timer).w
	bpl.s	-	; rts	; do it every 8th frame
	move.b	#7,(CPZ_UnkScroll_Timer).w
	move.b	#1,(Screen_redraw_flag).w
	lea	(Chunk_Table+$EA*$80).l,a1 ; chunks $EA-$ED, $FFFF7500 - $FFFF7700
	bsr.s	+
	lea	(Chunk_Table+$FA*$80).l,a1 ; chunks $FA-$FD, $FFFF7D00 - $FFFF7F00
+
	move.w	#8-1,d1

-	move.w	(a1),d0
    rept 3			; do this for 3 chunks
      rept 7
	move.w	2(a1),(a1)+	; shift 1st line of chunk by 1 block to the left (+3*14 bytes)
      endm
	move.w	$72(a1),(a1)+	; first block of next chunk to the left into previous chunk (+3*2 bytes)
	adda.w	#$70,a1		; go to next chunk (+336 bytes)
    endm
      rept 7			; now do it for the 4th chunk
	move.w	2(a1),(a1)+	; shift 1st line of chunk by 1 block to the left (+14 bytes)
      endm
	move.w	d0,(a1)+ 	; move 1st block of 1st chunk to last block of last chunk (+2 bytes, subsubtotal = 400 bytes)
	suba.w	#$180,a1 	; go to the next row in the first chunk (-384 bytes, subtotal = -16 bytes)
	dbf	d1,- 		; now do this again for rows 2-8 in these chunks
				; 400 + 7 * (-16) = 512 byte range was affected
	rts
; ===========================================================================
; loc_402D4:
LoadAnimatedBlocks:
	cmpi.b	#hill_top_zone,(Current_Zone).w
	bne.s	+
	bsr.w	PatchHTZTiles
	move.b	#-1,(Anim_Counters+1).w
	move.w	#-1,(TempArray_LayerDef+$20).w
+
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	bne.s	+
	move.b	#-1,(Anim_Counters+1).w
+
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	move.w	AnimPatMaps(pc,d0.w),d0
	lea	AnimPatMaps(pc,d0.w),a0
	tst.w	(Two_player_mode).w
	beq.s	+
	cmpi.b	#casino_night_zone,(Current_Zone).w
	bne.s	+
	lea	(APM_CNZ2P).l,a0
+
	tst.w	(a0)
	beq.s	+	; rts
	lea	(Block_Table).w,a1
	adda.w	(a0)+,a1
	move.w	(a0)+,d1
	tst.w	(Two_player_mode).w
	bne.s	LoadLevelBlocks_2P

; loc_40330:
LoadLevelBlocks:
	move.w	(a0)+,(a1)+	; copy blocks to RAM
	dbf	d1,LoadLevelBlocks	; loop using d1
+
	rts
; ===========================================================================
; loc_40338:
LoadLevelBlocks_2P:
	move.w	(a0)+,d0
    if fixBugs
	move.w	d0,d2
	andi.w	#nontile_mask,d0	; d0 holds the preserved non-tile data
	andi.w	#tile_mask,d2		; d2 holds the tile index
	lsr.w	#1,d2			; half tile index
	or.w	d2,d0			; put them back together
    else
	; 'd1', the loop counter, is overwritten with VRAM data.
	move.w	d0,d1
	andi.w	#nontile_mask,d0	; d0 holds the preserved non-tile data
	andi.w	#tile_mask,d1		; d1 holds the tile index (overwrites loop counter!)
	lsr.w	#1,d1			; half tile index
	or.w	d1,d0			; put them back together
    endif
	move.w	d0,(a1)+
	dbf	d1,LoadLevelBlocks_2P	; loop using d1, which we just overwrote
	rts
; ===========================================================================

; --------------------------------------------------------------------------------------
; Animated Pattern Mappings (16x16)
; --------------------------------------------------------------------------------------
; off_40350:
AnimPatMaps: zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w APM_EHZ		; EHZ
	zoneOffsetTableEntry.w APM_Null		; Zone 1
	zoneOffsetTableEntry.w APM_Null		; WZ
	zoneOffsetTableEntry.w APM_Null		; Zone 3
	zoneOffsetTableEntry.w APM_MTZ		; MTZ1,2
	zoneOffsetTableEntry.w APM_MTZ		; MTZ3
	zoneOffsetTableEntry.w APM_Null		; WFZ
	zoneOffsetTableEntry.w APM_EHZ		; HTZ
	zoneOffsetTableEntry.w APM_HPZ		; HPZ
	zoneOffsetTableEntry.w APM_Null		; Zone 9
	zoneOffsetTableEntry.w APM_OOZ		; OOZ
	zoneOffsetTableEntry.w APM_Null		; MCZ
	zoneOffsetTableEntry.w APM_CNZ		; CNZ
	zoneOffsetTableEntry.w APM_CPZ		; CPZ
	zoneOffsetTableEntry.w APM_DEZ		; DEZ
	zoneOffsetTableEntry.w APM_ARZ		; ARZ
	zoneOffsetTableEntry.w APM_Null		; SCZ
    zoneTableEnd

begin_animpat macro {INTLABEL}
__LABEL__ label *
__LABEL___Len := __LABEL___End - __LABEL___Blocks
	dc.w $1800 - __LABEL___Len
	dc.w bytesToWcnt(__LABEL___Len)
__LABEL___Blocks:
    endm

; byte_40372:
APM_EHZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$0 ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$4 ,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$1 ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$5 ,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$8 ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$C ,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$9 ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$D ,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$10,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$14,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$11,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$15,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$2 ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$6 ,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$3 ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$7 ,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$A ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$E ,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$B ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$F ,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$12,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$16,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$13,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$17,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$18,0,0,3,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$1A,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$19,0,0,3,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$1B,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$1C,0,0,3,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$1E,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$1D,0,0,3,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$1F,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$0,1,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$1,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$1,1,0,2,0)

	dc.w make_block_tile(ArtTile_ArtKos_Checkers+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtKos_Checkers+$1,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$1,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$0,1,0,2,0),make_block_tile(ArtTile_ArtKos_Checkers+$0,1,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$1,1,0,2,0),make_block_tile(ArtTile_ArtKos_Checkers+$1,1,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_Flowers1+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_Flowers1+$0,1,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Flowers1+$1,0,0,3,0),make_block_tile(ArtTile_ArtUnc_Flowers1+$1,1,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_Flowers2+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_Flowers2+$0,1,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Flowers2+$1,0,0,3,1),make_block_tile(ArtTile_ArtUnc_Flowers2+$1,1,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_Flowers3+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_Flowers3+$0,1,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Flowers3+$1,0,0,3,0),make_block_tile(ArtTile_ArtUnc_Flowers3+$1,1,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_Flowers4+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_Flowers4+$0,1,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Flowers4+$1,0,0,3,1),make_block_tile(ArtTile_ArtUnc_Flowers4+$1,1,0,3,1)
APM_EHZ_End:



; byte_403EE:
APM_MTZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$0,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$0,1,0,1,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$1,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$1,1,0,1,0)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$2,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$2,1,0,1,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$3,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$3,1,0,1,0)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$E,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$E,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$F,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$F,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$C,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$C,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$D,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$D,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$A,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$A,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$B,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$B,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$8,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$8,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$9,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$9,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$6,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$6,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$7,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$7,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$4,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$4,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$5,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$5,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$2,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$2,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$3,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$3,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$1,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$1,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$4,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$4,1,0,1,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$5,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$5,1,0,1,0)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$0,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$0,1,0,1,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$1,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$1,1,0,1,0)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$2,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$2,1,0,1,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$3,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$3,1,0,1,0)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$4,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$4,1,0,1,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$5,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$5,1,0,1,0)

	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,1),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Lava+$0    ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Lava+$1    ,0,0,2,1)

	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,1),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Lava+$2    ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Lava+$3    ,0,0,2,1)

	dc.w make_block_tile(ArtTile_ArtUnc_Lava+$4    ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Lava+$5    ,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Lava+$8    ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Lava+$9    ,0,0,2,1)

	dc.w make_block_tile(ArtTile_ArtUnc_Lava+$6    ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Lava+$7    ,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Lava+$A    ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Lava+$B    ,0,0,2,1)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$E,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$E,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$F,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$F,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$C,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$C,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$D,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$D,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$A,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$A,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$B,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$B,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$8,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$8,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$9,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$9,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$6,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$6,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$7,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$7,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$4,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$4,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$5,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$5,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$2,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$2,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$3,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$3,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$0,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$1,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$1,0,0,3,1)
APM_MTZ_End:



; byte_404C2:
APM_HPZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$1,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$2,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$3,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$4,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$5,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$6,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$7,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$1,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$2,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$3,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$4,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$5,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$6,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$7,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$1,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$2,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$3,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$4,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$5,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$6,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$7,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$2,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$3,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$4,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$5,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$6,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$7,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$2,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$3,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$4,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$5,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$6,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$7,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$2,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$3,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$4,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$5,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$6,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$7,0,0,2,0)

    if gameRevision<2
	; In REV02, for some reason these blank tiles' palette line was changed to lines 3 and 4.
	; This is consistent with MTZ's blank tiles.
	; Notably, the new palette lines' first entry always happens to match the current VDP background colour.
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$2,0,0,3,0)
    else
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$2,0,0,3,0)
    endif

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$1,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$4,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$3,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$6,0,0,3,0)

    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$5,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$7,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$2,0,0,3,0)
    else
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$5,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$7,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$2,0,0,3,0)
    endif

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$1,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$4,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$3,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$6,0,0,3,0)

    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$5,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$7,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$2,0,0,3,0)
    else
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$5,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$7,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$2,0,0,3,0)
    endif

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$1,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$4,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$3,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$6,0,0,3,0)

    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$5,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$7,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$2,0,0,2,0)
    else
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$5,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$7,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$2,0,0,2,0)
    endif

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$1,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$4,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$3,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$6,0,0,2,0)

    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$5,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$7,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$2,0,0,2,0)
    else
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$5,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$7,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$2,0,0,2,0)
    endif

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$1,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$4,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$3,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$6,0,0,2,0)

    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$5,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$7,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$2,0,0,2,0)
    else
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$5,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$7,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$2,0,0,2,0)
    endif

	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$1,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$4,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$3,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$6,0,0,2,0)

    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$5,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$7,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
    else
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$5,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$7,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
    endif
APM_HPZ_End:



; byte_405B6:
APM_OOZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_OOZPulseBall+$0,0,0,0,1),make_block_tile(ArtTile_ArtUnc_OOZPulseBall+$2,0,0,0,1)
	dc.w make_block_tile(ArtTile_ArtUnc_OOZPulseBall+$1,0,0,0,1),make_block_tile(ArtTile_ArtUnc_OOZPulseBall+$3,0,0,0,1)

	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall1+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_OOZSquareBall1+$1,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall1+$2,0,0,3,1),make_block_tile(ArtTile_ArtUnc_OOZSquareBall1+$3,0,0,3,1)

    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$2,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$1,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$3,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
    else
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$2,0,0,3,0)

	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$1,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$3,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
    endif

	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$0,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$1,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$8,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$9,0,0,2,1)

	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$2,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$3,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$A,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$B,0,0,2,1)

	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$4,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$5,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$C,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$D,0,0,2,1)

	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$6,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$7,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$E,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$F,0,0,2,1)

	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$0,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$1,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$8,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$9,0,0,2,1)

	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$2,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$3,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$A,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$B,0,0,2,1)

	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$4,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$5,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$C,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$D,0,0,2,1)

	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$6,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$7,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$E,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$F,0,0,2,1)
APM_OOZ_End:



; byte_4061A:
APM_CNZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$4,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$1,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$5,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$8,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$C,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$9,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$D,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$2,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$6,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$3,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$7,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$A,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$E,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$B,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$F,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$4,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$1,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$5,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$8,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$C,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$9,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$D,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$2,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$6,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$3,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$7,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$A,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$E,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$B,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$F,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$4,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$1,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$5,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$8,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$C,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$9,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$D,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$2,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$6,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$3,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$7,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$A,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$E,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$B,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$F,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$4,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$1,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$5,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$8,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$C,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$9,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$D,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$2,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$6,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$3,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$7,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$A,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$E,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$B,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$F,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$4,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$1,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$5,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$8,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$C,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$9,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$D,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$2,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$6,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$3,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$7,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$A,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$E,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$B,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$F,0,0,3,1)
APM_CNZ_End:



; byte_406BE:
APM_CNZ2P:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$4,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$1,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$5,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$8,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$C,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$9,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$D,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$2,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$6,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$3,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$7,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$A,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$E,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$B,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$F,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$4,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$1,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$5,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$8,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$C,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$9,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$D,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$2,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$6,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$3,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$7,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$A,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$E,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$B,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$F,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$4,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$1,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$5,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$8,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$C,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$9,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$D,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$2,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$6,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$3,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$7,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$A,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$E,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$B,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$F,0,0,0,0)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$4,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$1,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$5,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$8,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$C,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$9,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$D,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$2,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$6,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$3,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$7,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$A,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$E,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$B,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$F,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$4,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$1,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$5,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$8,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$C,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$9,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$D,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$2,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$6,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$3,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$7,0,0,3,1)

	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$A,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$E,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$B,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$F,0,0,3,1)
APM_CNZ2P_End:



; byte_40762:
APM_CPZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_CPZAnimBack+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_CPZAnimBack+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CPZAnimBack+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_CPZAnimBack+$1,0,0,2,0)
APM_CPZ_End:



; byte_4076E:
APM_DEZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_DEZAnimBack+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_DEZAnimBack+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_DEZAnimBack+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_DEZAnimBack+$1,0,0,2,0)
APM_DEZ_End:



; byte_4077A:
APM_ARZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall3+$0  ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall3+$1  ,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall3+$2  ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall3+$3  ,0,0,2,1)

	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall2+$0  ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall2+$1  ,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall2+$2  ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall2+$3  ,0,0,2,1)

	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$0,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$1,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$2,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$3,0,0,2,1)

    if fixBugs
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$0,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$1,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$2,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$3,0,0,2,1)
    else
	; These are invalid animation entries for waterfalls:
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$C,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$D,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$E,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$F,0,0,2,1)
    endif

	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall3+$0  ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall3+$1  ,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall3+$2  ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall3+$3  ,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall2+$0  ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall2+$1  ,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall2+$2  ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall2+$3  ,0,0,2,0)

	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$2,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$3,0,0,2,0)

    if fixBugs
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$2,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$3,0,0,2,0)
    else
	; These are invalid animation entries for waterfalls:
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$C,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$D,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$E,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$F,0,0,2,0)
    endif
APM_ARZ_End:



; byte_407BE:
APM_Null:	dc.w   0
; ===========================================================================
; loc_407C0:
PatchHTZTiles:
	; When decompressed, 'ArtNem_HTZCliffs' will be $1800 bytes large.
	lea	(ArtNem_HTZCliffs).l,a0
	lea	(Dynamic_Object_RAM_End-$1800).w,a4
	jsrto	JmpTo2_NemDecToRAM
	lea	(Dynamic_Object_RAM_End-$1800).w,a1
	lea_	Dynamic_HTZ.offsets,a4
	moveq	#0,d2
	moveq	#8-1,d4

loc_407DA:
	moveq	#6-1,d3

loc_407DC:
	moveq	#-1,d0
	move.w	(a4)+,d0
	movea.l	d0,a2
	moveq	#32-1,d1

loc_407E4:
	; Copy four pixels.
	move.l	(a1),(a2)+
	; Clear the bytes in 'Object_RAM'.
	move.l	d2,(a1)+

	dbf	d1,loc_407E4
	dbf	d3,loc_407DC
	adda.w	#6*2,a4
	dbf	d4,loc_407DA
	rts
; ===========================================================================

	jmpTos JmpTo2_NemDecToRAM




; ---------------------------------------------------------------------------
; Subroutine to draw the HUD
; ---------------------------------------------------------------------------

hud_letter_num_tiles = 2
hud_letter_vdp_delta = vdpCommDelta(tiles_to_bytes(hud_letter_num_tiles))

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_40804:
BuildHUD:
	tst.w	(Ring_count).w
	beq.s	++	; blink ring count if it's 0
	moveq	#0,d1
	btst	#3,(Level_frame_counter+1).w
	bne.s	+	; only blink on certain frames
	cmpi.b	#9,(Timer_minute).w	; should the minutes counter blink?
	bne.s	+	; if not, branch
	addq.w	#2,d1	; set mapping frame time counter blink
+
	bra.s	++
+
	moveq	#0,d1
	btst	#3,(Level_frame_counter+1).w
	bne.s	+	; only blink on certain frames
	addq.w	#1,d1	; set mapping frame for ring count blink
	cmpi.b	#9,(Timer_minute).w
	bne.s	+
	addq.w	#2,d1	; set mapping frame for double blink
+
	move.w	#spriteScreenPositionX(16),d3	; set X pos
	move.w	#spriteScreenPositionYCentered(24),d2	; set Y pos
	lea	(HUD_MapUnc_40A9A).l,a1
	movea.w	#make_art_tile(ArtTile_ArtNem_HUD,0,1),a3	; set art tile and flags
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	jsrto	JmpTo_DrawSprite_Loop	; draw frame
+
	rts
; End of function BuildHUD

; ===========================================================================

BuildHUD_P1:
	tst.w	(Ring_count).w
	beq.s	BuildHUD_P1_NoRings
	moveq	#0,d1
	btst	#3,(Level_frame_counter+1).w
	bne.s	+
	cmpi.b	#9,(Timer_minute).w
	bne.s	+
	addq.w	#2,d1	; make TIME flash
+
	bra.s	BuildHUD_P1_Continued
; ===========================================================================
; loc_40876:
BuildHUD_P1_NoRings:
	moveq	#0,d1
	btst	#3,(Level_frame_counter+1).w
	bne.s	BuildHUD_P1_Continued
	addq.w	#1,d1	; make RINGS flash
	cmpi.b	#9,(Timer_minute).w
	bne.s	BuildHUD_P1_Continued
	addq.w	#2,d1	; make TIME flash
; loc_4088C:
BuildHUD_P1_Continued:
	move.w	#spriteScreenPositionX(16),d3
	move.w	#spriteScreenPositionY2P(screen_height/2+24),d2
	lea	(HUD_MapUnc_40BEA).l,a1
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Text_2P,0,1),a3
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	jsrto	JmpTo_DrawSprite_2P_Loop
	move.w	#spriteScreenPositionX(56),d3
	move.w	#spriteScreenPositionY2P(screen_height/2-104),d2
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Numbers_2P,0,1),a3
	moveq	#0,d7
	move.b	(Timer_minute).w,d7
	bsr.w	sub_4092E
	bsr.w	sub_4096A
	moveq	#0,d7
	move.b	(Timer_second).w,d7
	bsr.w	loc_40938
	move.w	#spriteScreenPositionX(64),d3
	move.w	#spriteScreenPositionY2P(screen_height/2-88),d2
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Numbers_2P,0,1),a3
	moveq	#0,d7
	move.w	(Ring_count).w,d7
	bsr.w	sub_40984
	tst.b	(Update_HUD_timer_2P).w
	bne.s	+
	tst.b	(Update_HUD_timer).w
	beq.s	+
	move.w	#spriteScreenPositionX(144),d3
	move.w	#spriteScreenPositionY2P(screen_height/2+72),d2
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Numbers_2P,0,1),a3
	moveq	#0,d7
	move.b	(Loser_Time_Left).w,d7
	bsr.w	loc_40938
+
	moveq	#4,d1
	move.w	#spriteScreenPositionX(16),d3
	move.w	#spriteScreenPositionY2P(screen_height/2+24),d2
	lea	(HUD_MapUnc_40BEA).l,a1
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Text_2P,0,1),a3
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	jsrto	JmpTo_DrawSprite_2P_Loop
	moveq	#0,d4
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_4092E:

	lea	(Hud_1).l,a4
	moveq	#Hud_1.loop_counter,d6
	bra.s	loc_40940
; ===========================================================================

loc_40938:

	lea	(Hud_10).l,a4
	moveq	#Hud_10.loop_counter,d6

loc_40940:

	moveq	#0,d1
	move.l	(a4)+,d4

loc_40944:
	sub.l	d4,d7
	bcs.s	loc_4094C
	addq.w	#1,d1
	bra.s	loc_40944
; ===========================================================================

loc_4094C:
	add.l	d4,d7
	lea	(HUD_MapUnc_40C82).l,a1
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	jsrto	JmpTo_DrawSprite_2P_Loop
	addq.w	#8,d3
	dbf	d6,loc_40940
	rts
; End of function sub_4092E


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_4096A:

	moveq	#$A,d1
	lea	(HUD_MapUnc_40C82).l,a1
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	jsrto	JmpTo_DrawSprite_2P_Loop
	addq.w	#8,d3
	rts
; End of function sub_4096A


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_40984:

	lea	(Hud_100).l,a4
	moveq	#Hud_100.loop_counter,d6

loc_4098C:
	moveq	#0,d1
	move.l	(a4)+,d4

loc_40990:
	sub.l	d4,d7
	bcs.s	loc_40998
	addq.w	#1,d1
	bra.s	loc_40990
; ===========================================================================

loc_40998:
	add.l	d4,d7
	tst.w	d6
	beq.s	loc_409AA
	tst.w	d1
	beq.s	loc_409A6
	bset	#$1F,d6

loc_409A6:
	tst.l	d6
	bpl.s	loc_409BE

loc_409AA:
	lea	(HUD_MapUnc_40C82).l,a1
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	jsrto	JmpTo_DrawSprite_2P_Loop

loc_409BE:
	addq.w	#8,d3
	dbf	d6,loc_4098C
	rts
; End of function sub_40984

; ===========================================================================

BuildHUD_P2:
	tst.w	(Ring_count_2P).w
	beq.s	BuildHUD_P2_NoRings
	moveq	#0,d1
	btst	#3,(Level_frame_counter+1).w
	bne.s	+
	cmpi.b	#9,(Timer_minute_2P).w
	bne.s	+
	addq.w	#2,d1
+
	bra.s	BuildHUD_P2_Continued
; ===========================================================================
; loc_409E2:
BuildHUD_P2_NoRings:
	moveq	#0,d1
	btst	#3,(Level_frame_counter+1).w
	bne.s	BuildHUD_P2_Continued
	addq.w	#1,d1
	cmpi.b	#9,(Timer_minute_2P).w
	bne.s	BuildHUD_P2_Continued
	addq.w	#2,d1
; loc_409F8:
BuildHUD_P2_Continued:
	move.w	#spriteScreenPositionX(16),d3
	move.w	#spriteScreenPositionY2P(screen_height/2+24)+screen_height,d2
	lea	(HUD_MapUnc_40BEA).l,a1
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Text_2P,0,1),a3
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	jsrto	JmpTo_DrawSprite_2P_Loop
	move.w	#spriteScreenPositionX(56),d3
	move.w	#spriteScreenPositionY2P(screen_height/2-104)+screen_height,d2
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Numbers_2P,0,1),a3
	moveq	#0,d7
	move.b	(Timer_minute_2P).w,d7
	bsr.w	sub_4092E
	bsr.w	sub_4096A
	moveq	#0,d7
	move.b	(Timer_second_2P).w,d7
	bsr.w	loc_40938
	move.w	#spriteScreenPositionX(64),d3
	move.w	#spriteScreenPositionY2P(screen_height/2-88)+screen_height,d2
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Numbers_2P,0,1),a3
	moveq	#0,d7
	move.w	(Ring_count_2P).w,d7
	bsr.w	sub_40984
	tst.b	(Update_HUD_timer).w
	bne.s	+
	tst.b	(Update_HUD_timer_2P).w
	beq.s	+
	move.w	#spriteScreenPositionX(144),d3
	move.w	#spriteScreenPositionY2P(screen_height/2+72)+screen_height,d2
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Numbers_2P,0,1),a3
	moveq	#0,d7
	move.b	(Loser_Time_Left).w,d7
	bsr.w	loc_40938
+
	moveq	#5,d1
	move.w	#spriteScreenPositionX(16),d3
	move.w	#spriteScreenPositionY2P(screen_height/2+24)+screen_height,d2
	lea	(HUD_MapUnc_40BEA).l,a1
	movea.w	#make_art_tile_2p(ArtTile_ArtNem_Powerups,0,1),a3
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	jsrto	JmpTo_DrawSprite_2P_Loop
	moveq	#0,d4
	rts
; ===========================================================================

; sprite mappings for the HUD
; uses the art in VRAM from $D940 - $FC00
HUD_MapUnc_40A9A:	include "mappings/sprite/hud_a.asm"


HUD_MapUnc_40BEA:	include "mappings/sprite/hud_b.asm"


HUD_MapUnc_40C82:	include "mappings/sprite/hud_c.asm"

; ---------------------------------------------------------------------------
; Add points subroutine
; subroutine to add to Player 1's score
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_40D06:
AddPoints:
	move.b	#1,(Update_HUD_score).w
	lea	(Score).w,a3
	add.l	d0,(a3)	; add d0*10 to the score
	move.l	#999999,d1
	cmp.l	(a3),d1	; is #999999 higher than the score?
	bhi.s	+	; if yes, branch
	move.l	d1,(a3)	; set score to #999999
+
	move.l	(a3),d0
	cmp.l	(Next_Extra_life_score).w,d0
	blo.s	+	; rts
	addi.l	#5000,(Next_Extra_life_score).w
	addq.b	#1,(Life_count).w
	addq.b	#1,(Update_HUD_lives).w
	move.w	#MusID_ExtraLife,d0
	jmp	(PlayMusic).l
; ===========================================================================
+	rts
; End of function AddPoints


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; ---------------------------------------------------------------------------
; Add points subroutine
; subroutine to add to Player 2's score
; (goes to AddPoints to add to Player 1's score instead if this is not Player 2)
; ---------------------------------------------------------------------------

; sub_40D42:
AddPoints2:
	tst.w	(Two_player_mode).w
	beq.s	AddPoints
	cmpa.w	#MainCharacter,a3
	beq.s	AddPoints
	move.b	#1,(Update_HUD_score_2P).w
	lea	(Score_2P).w,a3
	add.l	d0,(a3)	; add d0*10 to the score
	move.l	#999999,d1
	cmp.l	(a3),d1	; is #999999 higher than the score?
	bhi.s	+	; if yes, branch
	move.l	d1,(a3)	; set score to #999999
+
	move.l	(a3),d0
	cmp.l	(Next_Extra_life_score_2P).w,d0
	blo.s	+	; rts
	addi.l	#5000,(Next_Extra_life_score_2P).w
	addq.b	#1,(Life_count_2P).w
	addq.b	#1,(Update_HUD_lives_2P).w
	move.w	#MusID_ExtraLife,d0
	jmp	(PlayMusic).l
; ===========================================================================
+	rts
; End of function AddPoints2

; ---------------------------------------------------------------------------
; Subroutine to update the HUD
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_40D8A:
HudUpdate:
	nop
	lea	(VDP_data_port).l,a6
	tst.w	(Two_player_mode).w
	bne.w	loc_40F50
	tst.w	(Debug_mode_flag).w	; is debug mode on?
	bne.w	loc_40E9A	; if yes, branch
	tst.b	(Update_HUD_score).w	; does the score need updating?
	beq.s	Hud_ChkRings	; if not, branch
	clr.b	(Update_HUD_score).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Score),VRAM,WRITE),d0	; set VRAM address
	move.l	(Score).w,d1	; load score
	bsr.w	Hud_Score
; loc_40DBA:
Hud_ChkRings:
	tst.b	(Update_HUD_rings).w	; does the ring counter need updating?
	beq.s	Hud_ChkTime	; if not, branch
	bpl.s	loc_40DC6
	bsr.w	Hud_InitRings

loc_40DC6:
	clr.b	(Update_HUD_rings).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Rings),VRAM,WRITE),d0
	moveq	#0,d1
	move.w	(Ring_count).w,d1
	bsr.w	Hud_Rings
; loc_40DDA:
Hud_ChkTime:
	tst.b	(Update_HUD_timer).w	; does the time need updating?
	beq.s	Hud_ChkLives	; if not, branch
	tst.w	(Game_paused).w	; is the game paused?
	bne.s	Hud_ChkLives	; if yes, branch
	lea	(Timer).w,a1
	cmpi.l	#(9<<(8*2))|(59<<(8*1))|(59<<(8*0)),(a1)+	; is the time 9.59?
	beq.w	loc_40E84	; if yes, branch
	addq.b	#1,-(a1)
	cmpi.b	#60,(a1)
	blo.s	Hud_ChkLives
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#60,(a1)
	blo.s	+
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#9,(a1)
	blo.s	+
	move.b	#9,(a1)
+
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Minutes),VRAM,WRITE),d0
	moveq	#0,d1
	move.b	(Timer_minute).w,d1
	bsr.w	Hud_Mins
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Seconds),VRAM,WRITE),d0
	moveq	#0,d1
	move.b	(Timer_second).w,d1
	bsr.w	Hud_Secs
; loc_40E38:
Hud_ChkLives:
	tst.b	(Update_HUD_lives).w	; does the lives counter need updating?
	beq.s	Hud_ChkBonus	; if not, branch
	clr.b	(Update_HUD_lives).w
	bsr.w	Hud_Lives
; loc_40E46:
Hud_ChkBonus:
	tst.b	(Update_Bonus_score).w	; do time/ring bonus counters need updating?
	beq.s	Hud_End	; if not, branch
	clr.b	(Update_Bonus_score).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Bonus_Score),VRAM,WRITE),(VDP_control_port).l
	moveq	#0,d1
	move.w	(Total_Bonus_Countdown).w,d1
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_1).w,d1	 ; load time bonus
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_2).w,d1	 ; load ring bonus
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_3).w,d1	 ; load perfect bonus
	bsr.w	Hud_TimeRingBonus
; return_40E82:
Hud_End:
	rts
; ===========================================================================

loc_40E84:
	clr.b	(Update_HUD_timer).w
	lea	(MainCharacter).w,a0 ; a0=character
	movea.l	a0,a2
	bsr.w	KillCharacter
	move.b	#1,(Time_Over_flag).w
	rts
; ===========================================================================

loc_40E9A:
	bsr.w	HudDb_XY
	tst.b	(Update_HUD_rings).w
	beq.s	loc_40EBE
	bpl.s	loc_40EAA
	bsr.w	Hud_InitRings

loc_40EAA:
	clr.b	(Update_HUD_rings).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Rings),VRAM,WRITE),d0

	moveq	#0,d1
	move.w	(Ring_count).w,d1
	bsr.w	Hud_Rings

loc_40EBE:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Seconds),VRAM,WRITE),d0
	moveq	#0,d1
	move.b	(Sprite_count).w,d1
	bsr.w	Hud_Secs
	tst.b	(Update_HUD_lives).w
	beq.s	loc_40EDC
	clr.b	(Update_HUD_lives).w
	bsr.w	Hud_Lives

loc_40EDC:
	tst.b	(Update_Bonus_score).w
	beq.s	loc_40F18
	clr.b	(Update_Bonus_score).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Bonus_Score),VRAM,WRITE),(VDP_control_port).l
	moveq	#0,d1
	move.w	(Total_Bonus_Countdown).w,d1
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_1).w,d1
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_2).w,d1
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_3).w,d1
	bsr.w	Hud_TimeRingBonus

loc_40F18:
	tst.w	(Game_paused).w
	bne.s	return_40F4E
	lea	(Timer).w,a1
	cmpi.l	#(9<<(8*2))|(59<<(8*1))|(59<<(8*0)),(a1)+
	nop			; You can't get a Time Over in Debug Mode, so this branch is dummied-out
	addq.b	#1,-(a1)
	cmpi.b	#60,(a1)
	blo.s	return_40F4E
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#60,(a1)
	blo.s	return_40F4E
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#9,(a1)
	blo.s	return_40F4E
	move.b	#9,(a1)

return_40F4E:
	rts
; ===========================================================================

loc_40F50:
	tst.w	(Game_paused).w
	bne.w	return_4101A
	tst.b	(Update_HUD_timer).w
	beq.s	loc_40F90
	lea	(Timer).w,a1
	cmpi.l	#(9<<(8*2))|(59<<(8*1))|(59<<(8*0)),(a1)+
	beq.w	TimeOver
	addq.b	#1,-(a1)
	cmpi.b	#60,(a1)
	blo.s	loc_40F90
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#60,(a1)
	blo.s	loc_40F90
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#9,(a1)
	blo.s	loc_40F90
	move.b	#9,(a1)

loc_40F90:
	tst.b	(Update_HUD_timer_2P).w
	beq.s	loc_40FC8
	lea	(Timer_2P).w,a1
	cmpi.l	#(9<<(8*2))|(59<<(8*1))|(59<<(8*0)),(a1)+
	beq.w	TimeOver2
	addq.b	#1,-(a1)
	cmpi.b	#60,(a1)
	blo.s	loc_40FC8
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#60,(a1)
	blo.s	loc_40FC8
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#9,(a1)
	blo.s	loc_40FC8
	move.b	#9,(a1)

loc_40FC8:
	tst.b	(Update_HUD_lives).w
	beq.s	loc_40FD6
	clr.b	(Update_HUD_lives).w
	bsr.w	Hud_Lives

loc_40FD6:
	tst.b	(Update_HUD_lives_2P).w
	beq.s	loc_40FE4
	clr.b	(Update_HUD_lives_2P).w
	bsr.w	Hud_Lives2

loc_40FE4:
	move.b	(Update_HUD_timer).w,d0
	or.b	(Update_HUD_timer_2P).w,d0
	beq.s	return_4101A
	lea	(Loser_Time_Left).w,a1
	tst.w	(a1)+
	beq.s	return_4101A
	subq.b	#1,-(a1)
	bhi.s	return_4101A
	move.b	#60,(a1)
	cmpi.b	#12,-1(a1)
	bne.s	loc_41010
	move.w	#MusID_Countdown,d0
	jsr	(PlayMusic).l

loc_41010:
	subq.b	#1,-(a1)
	bcc.s	return_4101A
	move.w	#0,(a1)
	bsr.s	TimeOver0

return_4101A:

	rts
; End of function HudUpdate


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4101C:
TimeOver0:
	tst.b	(Update_HUD_timer).w
	bne.s	TimeOver
	tst.b	(Update_HUD_timer_2P).w
	bne.s	TimeOver2
	rts
; ===========================================================================
; loc_4102A:
TimeOver:
	clr.b	(Update_HUD_timer).w
	lea	(MainCharacter).w,a0 ; a0=character
	movea.l	a0,a2
	bsr.w	KillCharacter
	move.b	#1,(Time_Over_flag).w
	tst.b	(Update_HUD_timer_2P).w
	beq.s	+	; rts
; loc_41044:
TimeOver2:
	clr.b	(Update_HUD_timer_2P).w
	lea	(Sidekick).w,a0 ; a0=character
	movea.l	a0,a2
	bsr.w	KillCharacter
	move.b	#1,(Time_Over_flag_2P).w
+
	rts
; End of function TimeOver0


; ---------------------------------------------------------------------------
; Subroutine to initialize ring counter on the HUD
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4105A:
; Hud_LoadZero:
Hud_InitRings:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Rings),VRAM,WRITE),(VDP_control_port).l
	lea	Hud_TilesRings(pc),a2
	move.w	#(Hud_TilesBase_End-Hud_TilesRings)-1,d2
	bra.s	loc_41090

; ---------------------------------------------------------------------------
; Subroutine to load uncompressed HUD patterns ("E", "0", colon)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_4106E:
Hud_Base:
	lea	(VDP_data_port).l,a6
	bsr.w	Hud_Lives
	tst.w	(Two_player_mode).w
	bne.s	loc_410BC
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Score_E),VRAM,WRITE),(VDP_control_port).l
	lea	Hud_TilesBase(pc),a2
	move.w	#(Hud_TilesBase_End-Hud_TilesBase)-1,d2

loc_41090:
	lea	Art_Hud(pc),a1

loc_41094:
	move.w	#bytesToLcnt(tiles_to_bytes(hud_letter_num_tiles)),d1
	move.b	(a2)+,d0
	bmi.s	loc_410B0
	ext.w	d0
	lsl.w	#5,d0
	lea	(a1,d0.w),a3

loc_410A4:
	move.l	(a3)+,(a6)
	dbf	d1,loc_410A4

loc_410AA:
	dbf	d2,loc_41094
	rts
; ===========================================================================

loc_410B0:
	move.l	#0,(a6)
	dbf	d1,loc_410B0
	bra.s	loc_410AA
; End of function Hud_Base

; ===========================================================================

loc_410BC:
	bsr.w	Hud_Lives2
	move.l	#Art_Hud,d1 ; source addreses
	move.w	#tiles_to_bytes(ArtTile_Art_HUD_Numbers_2P),d2 ; destination VRAM address
	move.w	#tiles_to_words(22),d3 ; DMA transfer length (in words)
	jmp	(QueueDMATransfer).l
; ===========================================================================

	charset	' ',$FF
	charset	'0',0
	charset	'1',2
	charset	'2',4
	charset	'3',6
	charset	'4',8
	charset	'5',$A
	charset	'6',$C
	charset	'7',$E
	charset	'8',$10
	charset	'9',$12
	charset	':',$14
	charset	'E',$16

; byte_410D4:
Hud_TilesBase:
	dc.b "E      0"
	dc.b "0:00"
; byte_410E0:
; Hud_TilesZero:
Hud_TilesRings:
	dc.b "  0"
Hud_TilesBase_End

	charset
	even

; ---------------------------------------------------------------------------
; Subroutine to load debug mode numbers patterns
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_410E4:
HudDb_XY:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Score_E),VRAM,WRITE),(VDP_control_port).l
	move.w	(Camera_X_pos).w,d1
	swap	d1
	move.w	(MainCharacter+x_pos).w,d1
	bsr.s	HudDb_XY2
	move.w	(Camera_Y_pos).w,d1
	swap	d1
	move.w	(MainCharacter+y_pos).w,d1
; loc_41104:
HudDb_XY2:
	moveq	#8-1,d6
	lea	(Art_Text).l,a1
; loc_4110C:
HudDb_XYLoop:
	rol.w	#4,d1
	move.w	d1,d2
	andi.w	#$F,d2
	cmpi.w	#$A,d2
	blo.s	loc_4111E
	addi_.w	#7,d2

loc_4111E:
	lsl.w	#5,d2
	lea	(a1,d2.w),a3
    rept tiles_to_longwords(1)
	move.l	(a3)+,(a6)
    endm
	swap	d1
	dbf	d6,HudDb_XYLoop
	rts
; End of function HudDb_XY

; ---------------------------------------------------------------------------
; Subroutine to load rings numbers patterns
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4113C:
Hud_Rings:
	lea	(Hud_100).l,a2
	moveq	#Hud_100.loop_counter,d6
	bra.s	Hud_LoadArt
; End of function Hud_Rings

; ---------------------------------------------------------------------------
; Subroutine to load score numbers patterns
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41146:
Hud_Score:
	lea	(Hud_100000).l,a2
	moveq	#Hud_100000.loop_counter,d6
; loc_4114E:
Hud_LoadArt:
	moveq	#0,d4
	lea	Art_Hud(pc),a1
; loc_41154:
Hud_ScoreLoop:
	moveq	#0,d2
	move.l	(a2)+,d3

loc_41158:
	sub.l	d3,d1
	bcs.s	loc_41160
	addq.w	#1,d2
	bra.s	loc_41158
; ===========================================================================

loc_41160:
	add.l	d3,d1
	tst.w	d2
	beq.s	loc_4116A
	move.w	#1,d4

loc_4116A:
	tst.w	d4
	beq.s	loc_41198
	lsl.w	#6,d2
	move.l	d0,4(a6)
	lea	(a1,d2.w),a3
    rept tiles_to_longwords(hud_letter_num_tiles)
	move.l	(a3)+,(a6)
    endm

loc_41198:
	addi.l	#hud_letter_vdp_delta,d0
	dbf	d6,Hud_ScoreLoop
	rts
; End of function Hud_Score

; ---------------------------------------------------------------------------
; Subroutine to load countdown numbers on the continue screen
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_411A4:
ContScrCounter:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ContinueCountdown),VRAM,WRITE),(VDP_control_port).l
	lea	(VDP_data_port).l,a6
	lea	(Hud_10).l,a2
	moveq	#Hud_10.loop_counter,d6
	moveq	#0,d4
	lea	Art_Hud(pc),a1
; loc_411C2:
ContScr_Loop:
	moveq	#0,d2
	move.l	(a2)+,d3

loc_411C6:
	sub.l	d3,d1
	bcs.s	loc_411CE
	addq.w	#1,d2
	bra.s	loc_411C6
; ===========================================================================

loc_411CE:
	add.l	d3,d1
	lsl.w	#6,d2
	lea	(a1,d2.w),a3
    rept tiles_to_longwords(hud_letter_num_tiles)
	move.l	(a3)+,(a6)
    endm
	dbf	d6,ContScr_Loop	; repeat 1 more time
	rts
; End of function ContScrCounter

; ===========================================================================
; ---------------------------------------------------------------------------
; for HUD counter
; ---------------------------------------------------------------------------
hud_counter macro {INTLABEL},number
__LABEL__ label *
.loop_counter = int(log(number)) ; Total digits minus one.
	dc.l number
    endm
					; byte_411FC:
Hud_100000:	hud_counter 100000	; byte_41200:
Hud_10000:	hud_counter 10000	; byte_41204:
Hud_1000:	hud_counter 1000	; byte_41208:
Hud_100:	hud_counter 100		; byte_4120C:
Hud_10:		hud_counter 10		; byte_41210:
Hud_1:		hud_counter 1

; ---------------------------------------------------------------------------
; Subroutine to load time numbers patterns
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41214:
Hud_Mins:
	lea_	Hud_1,a2
	moveq	#Hud_1.loop_counter,d6
	bra.s	loc_41222
; ===========================================================================
; loc_4121C:
Hud_Secs:
	lea_	Hud_10,a2
	moveq	#Hud_10.loop_counter,d6

loc_41222:
	moveq	#0,d4
	lea	Art_Hud(pc),a1
; loc_41228:
Hud_TimeLoop:
	moveq	#0,d2
	move.l	(a2)+,d3

loc_4122C:
	sub.l	d3,d1
	bcs.s	loc_41234
	addq.w	#1,d2
	bra.s	loc_4122C
; ===========================================================================

loc_41234:
	add.l	d3,d1
	tst.w	d2
	beq.s	loc_4123E
	move.w	#1,d4

loc_4123E:
	lsl.w	#6,d2
	move.l	d0,4(a6)
	lea	(a1,d2.w),a3
    rept tiles_to_longwords(hud_letter_num_tiles)
	move.l	(a3)+,(a6)
    endm
	addi.l	#hud_letter_vdp_delta,d0
	dbf	d6,Hud_TimeLoop
	rts
; End of function Hud_Mins

; ---------------------------------------------------------------------------
; Subroutine to load time/ring bonus numbers patterns
; ---------------------------------------------------------------------------

; ===========================================================================
; loc_41274:
Hud_TimeRingBonus:
	lea_	Hud_1000,a2
	moveq	#Hud_1000.loop_counter,d6
	moveq	#0,d4
	lea	Art_Hud(pc),a1
; loc_41280:
Hud_BonusLoop:
	moveq	#0,d2
	move.l	(a2)+,d3

loc_41284:
	sub.l	d3,d1
	bcs.s	loc_4128C
	addq.w	#1,d2
	bra.s	loc_41284
; ===========================================================================

loc_4128C:
	add.l	d3,d1
	tst.w	d2
	beq.s	loc_41296
	move.w	#1,d4

loc_41296:
	tst.w	d4
	beq.s	Hud_ClrBonus
	lsl.w	#6,d2
	lea	(a1,d2.w),a3
    rept tiles_to_longwords(hud_letter_num_tiles)
	move.l	(a3)+,(a6)
    endm

loc_412C0:
	dbf	d6,Hud_BonusLoop ; repeat 3 more times
	rts
; ===========================================================================
; loc_412C6:
Hud_ClrBonus:
	moveq	#bytesToLcnt(tiles_to_bytes(hud_letter_num_tiles)),d5
; loc_412C8:
Hud_ClrBonusLoop:
	move.l	#0,(a6)
	dbf	d5,Hud_ClrBonusLoop
	bra.s	loc_412C0

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; ---------------------------------------------------------------------------
; Subroutine to load uncompressed lives counter patterns (Sonic)
; ---------------------------------------------------------------------------

; sub_412D4:
Hud_Lives2:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_2p_life_counter_lives),VRAM,WRITE),d0
	moveq	#0,d1
	move.b	(Life_count_2P).w,d1
	bra.s	loc_412EE
; End of function Hud_Lives2

; ---------------------------------------------------------------------------
; Subroutine to load uncompressed lives counter patterns (Tails)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_412E2:
Hud_Lives:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_life_counter_lives),VRAM,WRITE),d0
	moveq	#0,d1
	move.b	(Life_count).w,d1

loc_412EE:
	lea_	Hud_10,a2
	moveq	#Hud_10.loop_counter,d6
	moveq	#0,d4
	lea	Art_LivesNums(pc),a1
; loc_412FA:
Hud_LivesLoop:
	move.l	d0,4(a6)
	moveq	#0,d2
	move.l	(a2)+,d3
-	sub.l	d3,d1
	bcs.s	loc_4130A
	addq.w	#1,d2
	bra.s	-
; ===========================================================================

loc_4130A:
	add.l	d3,d1
	tst.w	d2
	beq.s	loc_41314
	move.w	#1,d4

loc_41314:
	tst.w	d4
	beq.s	Hud_ClrLives

loc_41318:
	lsl.w	#5,d2
	lea	(a1,d2.w),a3
    rept 8
	move.l	(a3)+,(a6)
    endm

loc_4132E:
	addi.l	#hud_letter_vdp_delta,d0
	dbf	d6,Hud_LivesLoop ; repeat 1 more time
	rts
; ===========================================================================
; loc_4133A:
Hud_ClrLives:
	tst.w	d6
	beq.s	loc_41318
	moveq	#7,d5
; loc_41340:
Hud_ClrLivesLoop:
	move.l	#0,(a6)
	dbf	d5,Hud_ClrLivesLoop
	bra.s	loc_4132E
; End of function Hud_Lives

; ===========================================================================
; ArtUnc_4134C:
Art_Hud:	BINCLUDE	"art/uncompressed/Big and small numbers used on counters - 1.bin"
; ArtUnc_4164C:
Art_LivesNums:	BINCLUDE	"art/uncompressed/Big and small numbers used on counters - 2.bin"
; ArtUnc_4178C:
Art_Text:	BINCLUDE	"art/uncompressed/Big and small numbers used on counters - 3.bin"

	jmpTos JmpTo_DrawSprite_2P_Loop,JmpTo_DrawSprite_Loop




; ===========================================================================
; ---------------------------------------------------------------------------
; When debug mode is currently in use
; ---------------------------------------------------------------------------
; loc_41A78:
DebugMode:
	moveq	#0,d0
	move.b	(Debug_placement_mode).w,d0
	move.w	Debug_Index(pc,d0.w),d1
	jmp	Debug_Index(pc,d1.w)
; ===========================================================================
; off_41A86:
Debug_Index:	offsetTable
		offsetTableEntry.w Debug_Init	; 0
		offsetTableEntry.w Debug_Main	; 2
; ===========================================================================
; loc_41A8A: Debug_Main:
Debug_Init:
	addq.b	#2,(Debug_placement_mode).w
	move.w	(Camera_Min_Y_pos).w,(Camera_Min_Y_pos_Debug_Copy).w
	move.w	(Camera_Max_Y_pos_target).w,(Camera_Max_Y_pos_Debug_Copy).w
	cmpi.b	#sky_chase_zone,(Current_Zone).w
	bne.s	+
	move.w	#0,(Camera_Min_X_pos).w
	move.w	#$3FFF,(Camera_Max_X_pos).w
+
	andi.w	#$7FF,(MainCharacter+y_pos).w
	andi.w	#$7FF,(Camera_Y_pos).w
	andi.w	#$7FF,(Camera_BG_Y_pos).w
	clr.b	(Scroll_lock).w
	move.b	#0,mapping_frame(a0)
	move.b	#AniIDSonAni_Walk,anim(a0)
    if fixBugs
	; The 'in air' bit is left as whatever it was when Sonic entered
	; Debug Mode. This affects the camera's vertical deadzone.
	; Since 'Debug_ExitDebugMode' explicitly sets the 'in air' bit, it can
	; be assumed that having it cleared here was intended.
	bclr	#status.player.in_air,(MainCharacter+status).w
    endif
	; S1 leftover
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w ; special stage mode? (you can't enter debug mode in S2's special stage)
	bne.s	.islevel	; if not, branch
	moveq	#6,d0		; force zone 6's debug object list (was the ending in S1)
	bra.s	.selectlist
; ===========================================================================
.islevel:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0

.selectlist:
	lea	(DebugObjectLists).l,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d6
	cmp.b	(Debug_object).w,d6
	bhi.s	+
	move.b	#0,(Debug_object).w
+
	bsr.w	LoadDebugObjectSprite
	move.b	#$C,(Debug_Accel_Timer).w
	move.b	#1,(Debug_Speed).w
; loc_41B0C:
Debug_Main:
	; S1 leftover
	moveq	#6,d0		; force zone 6's debug object list (was the ending in S1)
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; special stage mode? (you can't enter debug mode in S2's special stage)
	beq.s	.isntlevel	; if yes, branch

	moveq	#0,d0
	move.b	(Current_Zone).w,d0

.isntlevel:
	lea	(DebugObjectLists).l,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d6
	bsr.w	Debug_Control
	jmp	(DisplaySprite).l

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41B34:
Debug_Control:
;Debug_ControlMovement:
	moveq	#0,d4
	move.w	#1,d1
	move.b	(Ctrl_1_Press).w,d4
	andi.w	#button_up_mask|button_down_mask|button_left_mask|button_right_mask,d4
	bne.s	Debug_Move
	move.b	(Ctrl_1_Held).w,d0
	andi.w	#button_up_mask|button_down_mask|button_left_mask|button_right_mask,d0
	bne.s	Debug_ContinueMoving
	move.b	#$C,(Debug_Accel_Timer).w
	move.b	#$F,(Debug_Speed).w
	bra.w	Debug_ControlObjects
; ===========================================================================
; loc_41B5E:
Debug_ContinueMoving:
	subq.b	#1,(Debug_Accel_Timer).w
	bne.s	Debug_TimerNotOver
	move.b	#1,(Debug_Accel_Timer).w
	addq.b	#1,(Debug_Speed).w
	bne.s	Debug_Move
	move.b	#-1,(Debug_Speed).w
; loc_41B76:
Debug_Move:
	move.b	(Ctrl_1_Held).w,d4
; loc_41B7A:
Debug_TimerNotOver:
	moveq	#0,d1
	move.b	(Debug_Speed).w,d1
	addq.w	#1,d1
	swap	d1
	asr.l	#4,d1
	move.l	y_pos(a0),d2
	move.l	x_pos(a0),d3

	; Move up
	btst	#button_up,d4
	beq.s	.upNotHeld
	sub.l	d1,d2
	moveq	#0,d0
	move.w	(Camera_Min_Y_pos).w,d0
	swap	d0
	cmp.l	d0,d2
	bge.s	.minYPosNotReached
	move.l	d0,d2
.minYPosNotReached:
; loc_41BA4:
.upNotHeld:
	; Move down
	btst	#button_down,d4
	beq.s	.downNotHeld
	add.l	d1,d2
	moveq	#0,d0
	move.w	(Camera_Max_Y_pos_target).w,d0
	addi.w	#screen_height-1,d0
	swap	d0
	cmp.l	d0,d2
	blt.s	.maxYPosNotReached
	move.l	d0,d2
.maxYPosNotReached:
; loc_41BBE:
.downNotHeld:
	; Move left
	btst	#button_left,d4
	beq.s	.leftNotHeld
	sub.l	d1,d3
	bcc.s	.minXPosNotReached
	moveq	#0,d3
.minXPosNotReached:
; loc_41BCA:
.leftNotHeld:
	; Move right
	btst	#button_right,d4
	beq.s	.rightNotHeld
	add.l	d1,d3
; loc_41BD2:
.rightNotHeld:
	move.l	d2,y_pos(a0)
	move.l	d3,x_pos(a0)
; loc_41BDA:
Debug_ControlObjects:
;Debug_CycleObjectsBackwards:
	btst	#button_A,(Ctrl_1_Held).w
	beq.s	Debug_SpawnObject
	btst	#button_C,(Ctrl_1_Press).w
	beq.s	Debug_CycleObjects
	; Cycle backwards though object list
	subq.b	#1,(Debug_object).w
	bcc.s	BranchTo_LoadDebugObjectSprite
	add.b	d6,(Debug_object).w
	bra.s	BranchTo_LoadDebugObjectSprite
; ===========================================================================
; loc_41BF6:
Debug_CycleObjects:
	btst	#button_A,(Ctrl_1_Press).w
	beq.s	Debug_SpawnObject
	; Cycle forwards though object list
	addq.b	#1,(Debug_object).w
	cmp.b	(Debug_object).w,d6
	bhi.s	BranchTo_LoadDebugObjectSprite
	move.b	#0,(Debug_object).w

BranchTo_LoadDebugObjectSprite ; BranchTo
	bra.w	LoadDebugObjectSprite
; ===========================================================================
; loc_41C12:
Debug_SpawnObject:
	btst	#button_C,(Ctrl_1_Press).w
	beq.s	Debug_ExitDebugMode
	; Spawn object
	jsr	(AllocateObject).l
	bne.s	Debug_ExitDebugMode
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	_move.b	mappings(a0),id(a1) ; load obj
	move.b	render_flags(a0),render_flags(a1)
    if fixBugs
	; The high bit of 'render_flags' is not cleared here. This causes
	; 'RunObjectDisplayOnly' to display the object even when it isn't
	; fully initialised. This causes the crash that occurs when you
	; attempt to spawn an object in Debug Mode while dead.
	andi.b	#~(1<<render_flags.on_screen)&$FF,render_flags(a1)
    endif
	move.b	render_flags(a0),status(a1)
	andi.b	#~(1<<status.npc.no_balancing)&$FF,status(a1)
	moveq	#0,d0
	move.b	(Debug_object).w,d0
	lsl.w	#3,d0
	move.b	4(a2,d0.w),subtype(a1)
	rts
; ===========================================================================
; loc_41C56:
Debug_ExitDebugMode:
	btst	#button_B,(Ctrl_1_Press).w
	beq.s	return_41CB6
	; Exit debug mode
	moveq	#0,d0
	move.w	d0,(Debug_placement_mode).w
	lea	(MainCharacter).w,a1 ; a1=character
	move.l	#MapUnc_Sonic,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtUnc_Sonic,0,0),art_tile(a1)
	tst.w	(Two_player_mode).w
	beq.s	.notTwoPlayerMode
	move.w	#make_art_tile_2p(ArtTile_ArtUnc_Sonic,0,0),art_tile(a1)
; loc_41C82:
.notTwoPlayerMode:
	bsr.s	Debug_ResetPlayerStats
	move.b	#$13,y_radius(a1)
	move.b	#9,x_radius(a1)
	move.w	(Camera_Min_Y_pos_Debug_Copy).w,(Camera_Min_Y_pos).w
	move.w	(Camera_Max_Y_pos_Debug_Copy).w,(Camera_Max_Y_pos_target).w
	; useless leftover; this is for S1's special stage
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; special stage mode?
	bne.s	return_41CB6		; if not, branch
	move.b	#AniIDSonAni_Roll,(MainCharacter+anim).w
	bset	#status.player.rolling,(MainCharacter+status).w
	bset	#status.player.in_air,(MainCharacter+status).w

return_41CB6:
	rts
; End of function Debug_Control


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41CB8:
Debug_ResetPlayerStats:
	move.b	d0,anim(a1)
	move.w	d0,x_sub(a1) ; subpixel x
	move.w	d0,y_sub(a1) ; subpixel y
	move.b	d0,obj_control(a1)
	move.b	d0,spindash_flag(a1)
	move.w	d0,x_vel(a1)
	move.w	d0,y_vel(a1)
	move.w	d0,inertia(a1)
    if fixBugs
	andi.b	#1<<status.player.underwater,status(a1) ; Preserve the 'is underwater' flag, and clear everything else.
	ori.b	#1<<status.player.in_air,status(a1)    ; Set the 'in air' flag.
    else
	; This resets the 'is underwater' flag, causing the bug where if you
	; enter Debug Mode underwater, and exit it above-water, Sonic will
	; still move as if he's underwater.
	move.b	#1<<status.player.in_air,status(a1)
    endif
	move.b	#2,routine(a1)
	move.b	#0,routine_secondary(a1)
	rts
; End of function Debug_ResetPlayerStats


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41CEC:
LoadDebugObjectSprite:
	moveq	#0,d0
	move.b	(Debug_object).w,d0
	lsl.w	#3,d0
	move.l	(a2,d0.w),mappings(a0)
	move.w	6(a2,d0.w),art_tile(a0)
	move.b	5(a2,d0.w),mapping_frame(a0)
	jsrto	JmpTo66_Adjust2PArtPointer
	rts
; End of function LoadDebugObjectSprite

; ===========================================================================
; ---------------------------------------------------------------------------
; OBJECT DEBUG LISTS

; The jump table goes by level ID, so Metropolis Zone's list is repeated to
; account for its third act. Hidden Palace Zone uses Oil Ocean Zone's list.
; ---------------------------------------------------------------------------
; JmpTbl_DbgObjLists:
DebugObjectLists: zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w DbgObjList_EHZ	; EHZ
	zoneOffsetTableEntry.w DbgObjList_Def	; Zone 1
	zoneOffsetTableEntry.w DbgObjList_Def	; WZ
	zoneOffsetTableEntry.w DbgObjList_Def	; Zone 3
	zoneOffsetTableEntry.w DbgObjList_MTZ	; MTZ1,2
	zoneOffsetTableEntry.w DbgObjList_MTZ	; MTZ3
	zoneOffsetTableEntry.w DbgObjList_WFZ	; WFZ
	zoneOffsetTableEntry.w DbgObjList_HTZ	; HTZ
	zoneOffsetTableEntry.w DbgObjList_HPZ	; HPZ
	zoneOffsetTableEntry.w DbgObjList_Def	; Zone 9
	zoneOffsetTableEntry.w DbgObjList_OOZ	; OOZ
	zoneOffsetTableEntry.w DbgObjList_MCZ	; MCZ
	zoneOffsetTableEntry.w DbgObjList_CNZ	; CNZ
	zoneOffsetTableEntry.w DbgObjList_CPZ	; CPZ
	zoneOffsetTableEntry.w DbgObjList_Def	; DEZ
	zoneOffsetTableEntry.w DbgObjList_ARZ	; ARZ
	zoneOffsetTableEntry.w DbgObjList_SCZ	; SCZ
    zoneTableEnd

; macro for a debug object list header
; must be on the same line as a label that has a corresponding _End label later
dbglistheader macro {INTLABEL}
__LABEL__ label *
	dc.w ((__LABEL___End - __LABEL__ - 2) / 8)
    endm

; macro to define debug list object data
dbglistobj macro   obj, mapaddr, subtype, frame, vram
	dc.l obj<<24|mapaddr
	dc.b subtype,frame
	dc.w vram
    endm

DbgObjList_Def: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0) ; obj25 = ring
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0) ; obj26 = monitor
DbgObjList_Def_End

DbgObjList_EHZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_EHZWaterfall,	Obj49_MapUnc_20C50,   0,   0, make_art_tile(ArtTile_ArtNem_Waterfall,1,0)
	dbglistobj ObjID_EHZWaterfall,	Obj49_MapUnc_20C50,   2,   3, make_art_tile(ArtTile_ArtNem_Waterfall,1,0)
	dbglistobj ObjID_EHZWaterfall,	Obj49_MapUnc_20C50,   4,   5, make_art_tile(ArtTile_ArtNem_Waterfall,1,0)
	dbglistobj ObjID_EHZPlatform,	Obj18_MapUnc_107F6,   1,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_EHZPlatform,	Obj18_MapUnc_107F6, $9A,   1, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $A0,   6, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $30,   7, make_art_tile(ArtTile_ArtNem_DignlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $40,  $A, make_art_tile(ArtTile_ArtNem_DignlSprng,0,0)
	dbglistobj ObjID_Buzzer,	Obj4B_MapUnc_2D2EA,   0,   0, make_art_tile(ArtTile_ArtNem_Buzzer,0,0)
	dbglistobj ObjID_Masher,	Obj5C_MapUnc_2D442,   0,   0, make_art_tile(ArtTile_ArtNem_Masher,0,0)
	dbglistobj ObjID_Coconuts,	Obj9D_Obj98_MapUnc_37D96, $1E,   0, make_art_tile(ArtTile_ArtNem_Coconuts,0,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_EHZ_End

DbgObjList_MTZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_SteamSpring,	Obj42_MapUnc_2686C,   1,   7, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_MTZTwinStompers, Obj64_MapUnc_26A5C,   1,   0, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_MTZTwinStompers, Obj64_MapUnc_26A5C, $11,   1, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_MTZLongPlatform, Obj65_Obj6A_Obj6B_MapUnc_26EC8, $80,   0, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_MTZLongPlatform, Obj65_Obj6A_Obj6B_MapUnc_26EC8, $13,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_Button,	Obj47_MapUnc_24D96,   0,   2, make_art_tile(ArtTile_ArtNem_Button,0,0)
	dbglistobj ObjID_Barrier,	Obj2D_MapUnc_11822,   1,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_MTZSpringWall,	Obj66_MapUnc_27120,   1,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_MTZSpringWall,	Obj66_MapUnc_27120, $11,   1, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_SpikyBlock,	Obj68_Obj6D_MapUnc_27750,   0,   4, make_art_tile(ArtTile_ArtNem_MtzSpikeBlock,3,0)
	dbglistobj ObjID_Nut,		Obj69_MapUnc_27A26,   4,   0, make_art_tile(ArtTile_ArtNem_MtzAsstBlocks,1,0)
	dbglistobj ObjID_MTZMovingPforms, Obj65_Obj6A_Obj6B_MapUnc_26EC8,   0,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_MTZPlatform,	Obj65_Obj6A_Obj6B_MapUnc_26EC8,   7,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_FloorSpike,	Obj68_Obj6D_MapUnc_27750,   0,   0, make_art_tile(ArtTile_ArtNem_MtzSpike,1,0)
	dbglistobj ObjID_LargeRotPform,	Obj6E_MapUnc_2852C,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_LargeRotPform,	Obj6E_MapUnc_2852C, $10,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_LargeRotPform,	Obj6E_MapUnc_2852C, $20,   2, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_Cog,		Obj70_MapUnc_28786, $10,   0, make_art_tile(ArtTile_ArtNem_MtzWheel,3,1)
	dbglistobj ObjID_MTZLavaBubble,	Obj71_MapUnc_11576, $22,   5, make_art_tile(ArtTile_ArtNem_MtzLavaBubble,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_11552,   0,   0, make_art_tile(ArtTile_ArtNem_BoltEnd_Rope,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_11552,   1,   1, make_art_tile(ArtTile_ArtNem_BoltEnd_Rope,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_11552,   3,   2, make_art_tile(ArtTile_ArtNem_BoltEnd_Rope,1,0)
	dbglistobj ObjID_MTZLongPlatform, Obj65_Obj6A_Obj6B_MapUnc_26EC8, $B0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_Shellcracker,	Obj9F_MapUnc_38314, $24,   0, make_art_tile(ArtTile_ArtNem_Shellcracker,0,0)
	dbglistobj ObjID_Asteron,	ObjA4_Obj98_MapUnc_38A96, $2E,   0, make_art_tile(ArtTile_ArtNem_MtzSupernova,0,1)
	dbglistobj ObjID_Slicer,	ObjA1_MapUnc_385E2, $28,   0, make_art_tile(ArtTile_ArtNem_MtzMantis,1,0)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   0,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   1,   1, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   2,   2, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_MTZ_End

DbgObjList_WFZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_WFZPalSwitcher, Obj03_MapUnc_1FFB8,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $5E,   0, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $60,   1, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $62,   2, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_VPropeller,	ObjB4_MapUnc_3B3BE, $64,   0, make_art_tile(ArtTile_ArtNem_WfzVrtclPrpllr,1,1)
	dbglistobj ObjID_HPropeller,	ObjB5_MapUnc_3B548, $66,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1)
	dbglistobj ObjID_HPropeller,	ObjB5_MapUnc_3B548, $68,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1)
	dbglistobj ObjID_CluckerBase,	ObjAD_Obj98_MapUnc_395B4, $42,  $C, make_art_tile(ArtTile_ArtNem_WfzScratch,0,0)
	dbglistobj ObjID_Clucker,	ObjAD_Obj98_MapUnc_395B4, $44,  $B, make_art_tile(ArtTile_ArtNem_WfzScratch,0,0)
	dbglistobj ObjID_TiltingPlatform, ObjB6_MapUnc_3B856, $6A,   0, make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1)
	dbglistobj ObjID_TiltingPlatform, ObjB6_MapUnc_3B856, $6C,   0, make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1)
	dbglistobj ObjID_TiltingPlatform, ObjB6_MapUnc_3B856, $6E,   0, make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1)
	dbglistobj ObjID_TiltingPlatform, ObjB6_MapUnc_3B856, $70,   0, make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1)
	dbglistobj ObjID_VerticalLaser,	ObjB7_MapUnc_3B8E4, $72,   0, make_art_tile(ArtTile_ArtNem_WfzVrtclLazer,2,1)
	dbglistobj ObjID_WallTurret,	ObjB8_Obj98_MapUnc_3BA46, $74,   0, make_art_tile(ArtTile_ArtNem_WfzWallTurret,0,0)
	dbglistobj ObjID_Laser,		ObjB9_MapUnc_3BB18, $76,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlLazer,2,1)
	dbglistobj ObjID_WFZWheel,	ObjBA_MapUnc_3BB70, $78,   0, make_art_tile(ArtTile_ArtNem_WfzConveyorBeltWheel,2,1)
	dbglistobj ObjID_WFZShipFire,	ObjBC_MapUnc_3BC08, $7C,   0, make_art_tile(ArtTile_ArtNem_WfzThrust,2,0)
	dbglistobj ObjID_SmallMetalPform, ObjBD_MapUnc_3BD3E, $7E,   0, make_art_tile(ArtTile_ArtNem_WfzBeltPlatform,3,1)
	dbglistobj ObjID_SmallMetalPform, ObjBD_MapUnc_3BD3E, $80,   0, make_art_tile(ArtTile_ArtNem_WfzBeltPlatform,3,1)
	dbglistobj ObjID_LateralCannon,	ObjBE_MapUnc_3BE46, $82,   0, make_art_tile(ArtTile_ArtNem_WfzGunPlatform,3,1)
	dbglistobj ObjID_WFZStick,	ObjBF_MapUnc_3BEE0, $84,   0, make_art_tile(ArtTile_ArtNem_WfzUnusedBadnik,3,1)
	dbglistobj ObjID_SpeedLauncher,	ObjC0_MapUnc_3C098,   8,   0, make_art_tile(ArtTile_ArtNem_WfzLaunchCatapult,1,0)
	dbglistobj ObjID_BreakablePlating, ObjC1_MapUnc_3C280, $88,   0, make_art_tile(ArtTile_ArtNem_BreakPanels,3,1)
	dbglistobj ObjID_Rivet,		ObjC2_MapUnc_3C3C2, $8A,   0, make_art_tile(ArtTile_ArtNem_WfzSwitch,1,1)
	dbglistobj ObjID_WFZPlatform,	Obj19_MapUnc_2222A, $38,   3, make_art_tile(ArtTile_ArtNem_WfzFloatingPlatform,1,1)
	dbglistobj ObjID_Grab,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_MovingVine,	Obj80_MapUnc_29DD0,   0,   0, make_art_tile(ArtTile_ArtNem_WfzHook_Fudge,1,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_WFZ_End

DbgObjList_HTZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_ForcedSpin,	Obj03_MapUnc_1FFB8,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_ForcedSpin,	Obj03_MapUnc_1FFB8,   4,   4, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_EHZPlatform,	Obj18_MapUnc_107F6,   1,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_EHZPlatform,	Obj18_MapUnc_107F6, $9A,   1, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Seesaw,	Obj14_MapUnc_21CF0,   0,   0, make_art_tile(ArtTile_ArtNem_HtzSeeSaw,0,0)
	dbglistobj ObjID_Barrier,	Obj2D_MapUnc_11822,   0,   0, make_art_tile(ArtTile_ArtNem_HtzValveBarrier,1,0)
	dbglistobj ObjID_SmashableGround, Obj2F_MapUnc_236FA,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,1)
	dbglistobj ObjID_LavaBubble,	Obj20_MapUnc_23254, $44,   2, make_art_tile(ArtTile_ArtNem_HtzFireball2,0,1)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $A0,   6, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $30,   7, make_art_tile(ArtTile_ArtNem_DignlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $40,  $A, make_art_tile(ArtTile_ArtNem_DignlSprng,0,0)
	dbglistobj ObjID_HTZLift,	Obj16_MapUnc_21F14,   0,   0, make_art_tile(ArtTile_ArtNem_HtzZipline,2,0)
	dbglistobj ObjID_BridgeStake,	Obj16_MapUnc_21F14,   4,   3, make_art_tile(ArtTile_ArtNem_HtzZipline,2,0)
	dbglistobj ObjID_BridgeStake,	Obj16_MapUnc_21F14,   5,   4, make_art_tile(ArtTile_ArtNem_HtzZipline,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_113D6,   7,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_113D6,   8,   1, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_BreakableRock,	Obj32_MapUnc_23852,   0,   0, make_art_tile(ArtTile_ArtNem_HtzRock,2,0)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   0,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   1,   1, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   2,   2, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_Rexon2,	Obj94_Obj98_MapUnc_37678,  $E,   2, make_art_tile(ArtTile_ArtNem_Rexon,3,0)
	dbglistobj ObjID_Spiker,	Obj92_Obj93_MapUnc_37092,  $A,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_Sol,		Obj95_MapUnc_372E6,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_HTZ_End

DbgObjList_HPZ:; dbglistheader
;	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
;	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
;DbgObjList_HPZ_End

DbgObjList_OOZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_OOZPoppingPform, Obj33_MapUnc_23DDC,   1,   0, make_art_tile(ArtTile_ArtNem_BurnerLid,3,0)
	dbglistobj ObjID_SlidingSpike,	Obj43_MapUnc_23FE0,   0,   0, make_art_tile(ArtTile_ArtNem_SpikyThing,2,1)
	dbglistobj ObjID_OOZMovingPform, Obj19_MapUnc_2222A, $23,   2, make_art_tile(ArtTile_ArtNem_OOZElevator,3,0)
	dbglistobj ObjID_OOZSpring,	Obj45_MapUnc_2451A,   2,   0, make_art_tile(ArtTile_ArtNem_PushSpring,2,0)
	dbglistobj ObjID_OOZSpring,	Obj45_MapUnc_2451A, $12,  $A, make_art_tile(ArtTile_ArtNem_PushSpring,2,0)
	dbglistobj ObjID_OOZBall,	Obj46_MapUnc_24C52,   0,   1, make_art_tile(ArtTile_ArtNem_BallThing,3,0)
	dbglistobj ObjID_Button,	Obj47_MapUnc_24D96,   0,   2, make_art_tile(ArtTile_ArtNem_Button,0,0)
	dbglistobj ObjID_SwingingPlatform, Obj15_MapUnc_101E8, $88,   1, make_art_tile(ArtTile_ArtNem_OOZSwingPlat,2,0)
	dbglistobj ObjID_OOZLauncher,	Obj3D_MapUnc_250BA,   0,   0, make_art_tile(ArtTile_ArtNem_StripedBlocksVert,3,0)
	dbglistobj ObjID_LauncherBall,	Obj48_MapUnc_254FE, $80,   0, make_art_tile(ArtTile_ArtNem_LaunchBall,3,0)
	dbglistobj ObjID_LauncherBall,	Obj48_MapUnc_254FE, $81,   1, make_art_tile(ArtTile_ArtNem_LaunchBall,3,0)
	dbglistobj ObjID_LauncherBall,	Obj48_MapUnc_254FE, $82,   2, make_art_tile(ArtTile_ArtNem_LaunchBall,3,0)
	dbglistobj ObjID_LauncherBall,	Obj48_MapUnc_254FE, $83,   3, make_art_tile(ArtTile_ArtNem_LaunchBall,3,0)
	dbglistobj ObjID_CollapsPform,	Obj1F_MapUnc_110C6,   0,   0, make_art_tile(ArtTile_ArtNem_OOZPlatform,3,0)
	dbglistobj ObjID_Fan,		Obj3F_MapUnc_2AA12,   0,   0, make_art_tile(ArtTile_ArtNem_OOZFanHoriz,3,0)
	dbglistobj ObjID_Fan,		Obj3F_MapUnc_2AAC4, $80,   0, make_art_tile(ArtTile_ArtNem_OOZFanHoriz,3,0)
	dbglistobj ObjID_Aquis,		Obj50_MapUnc_2CF94,   0,   0, make_art_tile(ArtTile_ArtNem_Aquis,1,0)
	dbglistobj ObjID_Octus,		Obj4A_MapUnc_2CBFE,   0,   0, make_art_tile(ArtTile_ArtNem_Octus,1,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $A,   0, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $B,   1, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $C,   2, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $D,   3, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $E,   4, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $F,   5, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $10,   0, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $11,   1, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $12,   2, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $13,   3, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $14,   4, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_OOZ_End

DbgObjList_MCZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_SwingingPlatform, Obj15_Obj7A_MapUnc_10256, $48,   2, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_CollapsPform,	Obj1F_MapUnc_11106,   0,   0, make_art_tile(ArtTile_ArtNem_MCZCollapsePlat,3,0)
	dbglistobj ObjID_RotatingRings,	Obj73_MapUnc_28B9C, $F5,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_MCZRotPforms,	Obj6A_MapUnc_27D30, $18,   0, make_art_tile(ArtTile_ArtNem_Crate,3,0)
	dbglistobj ObjID_Stomper,	Obj2A_MapUnc_11666,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68, $40,   4, make_art_tile(ArtTile_ArtNem_HorizSpike,1,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Springboard,	Obj40_MapUnc_265F4,   1,   0, make_art_tile(ArtTile_ArtNem_LeverSpring,0,0)
	dbglistobj ObjID_InvisibleBlock, Obj74_MapUnc_20F66, $11,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_MCZBrick,	Obj75_MapUnc_28D8A, $18,   2, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_SlidingSpikes,	Obj76_MapUnc_28F3A,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_MCZBridge,	Obj77_MapUnc_29064,   1,   0, make_art_tile(ArtTile_ArtNem_MCZGateLog,3,0)
	dbglistobj ObjID_VineSwitch,	Obj7F_MapUnc_29938,   0,   0, make_art_tile(ArtTile_ArtNem_VineSwitch,3,0)
	dbglistobj ObjID_MovingVine,	Obj80_MapUnc_29C64,   0,   0, make_art_tile(ArtTile_ArtNem_VinePulley,3,0)
	dbglistobj ObjID_MCZDrawbridge,	Obj81_MapUnc_2A24E,   0,   1, make_art_tile(ArtTile_ArtNem_MCZGateLog,3,0)
	dbglistobj ObjID_SidewaysPform,	Obj15_Obj7A_MapUnc_10256, $12,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_Flasher,	ObjA3_MapUnc_388F0, $2C,   0, make_art_tile(ArtTile_ArtNem_Flasher,0,1)
	dbglistobj ObjID_Crawlton,	Obj9E_MapUnc_37FF2, $22,   0, make_art_tile(ArtTile_ArtNem_Crawlton,1,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_MCZ_End

DbgObjList_CNZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_PinballMode,	Obj03_MapUnc_1FFB8,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_PinballMode,	Obj03_MapUnc_1FFB8,   4,   4, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,  $D,   5, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_RoundBumper,	Obj44_MapUnc_1F85A,   0,   0, make_art_tile(ArtTile_ArtNem_CNZRoundBumper,2,0)
	dbglistobj ObjID_LauncherSpring, Obj85_MapUnc_2B07E,   0,   0, make_art_tile(ArtTile_ArtNem_CNZVertPlunger,0,0)
	dbglistobj ObjID_LauncherSpring, Obj85_MapUnc_2B0EC, $81,   0, make_art_tile(ArtTile_ArtNem_CNZDiagPlunger,0,0)
	dbglistobj ObjID_Flipper,	Obj86_MapUnc_2B45A,   0,   0, make_art_tile(ArtTile_ArtNem_CNZFlipper,2,0)
	dbglistobj ObjID_Flipper,	Obj86_MapUnc_2B45A,   1,   4, make_art_tile(ArtTile_ArtNem_CNZFlipper,2,0)
	dbglistobj ObjID_CNZRectBlocks,	ObjD2_MapUnc_2B694,   1,   0, make_art_tile(ArtTile_ArtNem_CNZSnake,2,0)
	dbglistobj ObjID_BombPrize,	ObjD3_MapUnc_2B8D4,   0,   0, make_art_tile(ArtTile_ArtNem_CNZBonusSpike,0,0)
	dbglistobj ObjID_CNZBigBlock,	ObjD4_MapUnc_2B9CA,   0,   0, make_art_tile(ArtTile_ArtNem_BigMovingBlock,2,0)
	dbglistobj ObjID_CNZBigBlock,	ObjD4_MapUnc_2B9CA,   2,   0, make_art_tile(ArtTile_ArtNem_BigMovingBlock,2,0)
	dbglistobj ObjID_Elevator,	ObjD5_MapUnc_2BB40, $18,   0, make_art_tile(ArtTile_ArtNem_CNZElevator,2,0)
	dbglistobj ObjID_PointPokey,	ObjD6_MapUnc_2BEBC,   1,   0, make_art_tile(ArtTile_ArtNem_CNZCage,0,0)
	dbglistobj ObjID_Bumper,	ObjD7_MapUnc_2C626,   0,   0, make_art_tile(ArtTile_ArtNem_CNZHexBumper,2,0)
	dbglistobj ObjID_BonusBlock,	ObjD8_MapUnc_2C8C4,   0,   0, make_art_tile(ArtTile_ArtNem_CNZMiniBumper,2,0)
	dbglistobj ObjID_BonusBlock,	ObjD8_MapUnc_2C8C4, $40,   1, make_art_tile(ArtTile_ArtNem_CNZMiniBumper,2,0)
	dbglistobj ObjID_BonusBlock,	ObjD8_MapUnc_2C8C4, $80,   2, make_art_tile(ArtTile_ArtNem_CNZMiniBumper,2,0)
	dbglistobj ObjID_Crawl,		ObjC8_MapUnc_3D450, $AC,   0, make_art_tile(ArtTile_ArtNem_Crawl,0,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_CNZ_End

DbgObjList_CPZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_TippingFloor,	Obj0B_MapUnc_201A0, $70,   0, make_art_tile(ArtTile_ArtNem_CPZAnimatedBits,3,1)
	dbglistobj ObjID_SpeedBooster,	Obj1B_MapUnc_223E2,   0,   0, make_art_tile(ArtTile_ArtNem_CPZBooster,3,1)
	dbglistobj ObjID_BlueBalls,	Obj1D_MapUnc_22576,   5,   0, make_art_tile(ArtTile_ArtNem_CPZDroplet,3,1)
	dbglistobj ObjID_CPZPlatform,	Obj19_MapUnc_2222A,   6,   0, make_art_tile(ArtTile_ArtNem_CPZElevator,3,0)
	dbglistobj ObjID_Barrier,	Obj2D_MapUnc_11822,   2,   2, make_art_tile(ArtTile_ArtNem_ConstructionStripes_2,1,0)
	dbglistobj ObjID_BreakableBlock, Obj32_MapUnc_23886,   0,   0, make_art_tile(ArtTile_ArtNem_CPZMetalBlock,3,0)
	dbglistobj ObjID_CPZSquarePform, Obj6B_MapUnc_2800E, $10,   0, make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,0)
	dbglistobj ObjID_CPZStaircase,	Obj6B_MapUnc_2800E,   0,   0, make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,0)
	dbglistobj ObjID_SidewaysPform,	Obj7A_MapUnc_29564,   0,   0, make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,1)
	dbglistobj ObjID_PipeExitSpring, Obj7B_MapUnc_29780,   2,   0, make_art_tile(ArtTile_ArtNem_CPZTubeSpring,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,  $D,   5, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $A0,   6, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Springboard,	Obj40_MapUnc_265F4,   1,   0, make_art_tile(ArtTile_ArtNem_LeverSpring,0,0)
	dbglistobj ObjID_Spiny,		ObjA5_ObjA6_Obj98_MapUnc_38CCA, $32,   0, make_art_tile(ArtTile_ArtNem_Spiny,1,0)
	dbglistobj ObjID_SpinyOnWall,	ObjA5_ObjA6_Obj98_MapUnc_38CCA, $32,   3, make_art_tile(ArtTile_ArtNem_Spiny,1,0)
	dbglistobj ObjID_Grabber,	ObjA7_ObjA8_ObjA9_Obj98_MapUnc_3921A, $36,   0, make_art_tile(ArtTile_ArtNem_Grabber,1,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_CPZ_End

DbgObjList_ARZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_SwingingPlatform, Obj15_Obj83_MapUnc_1021E, $88,   2, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_ARZPlatform,	Obj18_MapUnc_1084E,   1,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_ARZPlatform,	Obj18_MapUnc_1084E, $9A,   1, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_ArrowShooter,	Obj22_MapUnc_25804,   0,   1, make_art_tile(ArtTile_ArtNem_ArrowAndShooter,0,0)
	dbglistobj ObjID_FallingPillar,	Obj23_MapUnc_259E6,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_RisingPillar,	Obj2B_MapUnc_25C6E,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_LeavesGenerator, Obj31_MapUnc_20E74,   0,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LeavesGenerator, Obj31_MapUnc_20E74,   1,   1, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LeavesGenerator, Obj31_MapUnc_20E74,   2,   2, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_Springboard,	Obj40_MapUnc_265F4,   1,   0, make_art_tile(ArtTile_ArtNem_LeverSpring,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $A0,   6, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Barrier,	Obj2D_MapUnc_11822,   3,   3, make_art_tile(ArtTile_ArtNem_ARZBarrierThing,1,0)
	dbglistobj ObjID_CollapsPform,	Obj1F_MapUnc_1115E,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_SwingingPform,	Obj82_MapUnc_2A476,   3,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_SwingingPform,	Obj82_MapUnc_2A476, $11,   1, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_ARZRotPforms,	Obj15_Obj83_MapUnc_1021E, $10,   1, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_ARZBubbles,	Obj24_MapUnc_1FBF6, $81,  $E, make_art_tile(ArtTile_ArtNem_BigBubbles,0,1)
	dbglistobj ObjID_ChopChop,	Obj91_MapUnc_36EF6,   8,   0, make_art_tile(ArtTile_ArtNem_ChopChop,1,0)
	dbglistobj ObjID_Whisp,		Obj8C_MapUnc_36A4E,   0,   0, make_art_tile(ArtTile_ArtNem_Whisp,1,1)
	dbglistobj ObjID_GrounderInWall, Obj8D_MapUnc_36CF0,   2,   0, make_art_tile(ArtTile_ArtNem_Grounder,1,1)
	dbglistobj ObjID_GrounderInWall2, Obj8D_MapUnc_36CF0,   2,   0, make_art_tile(ArtTile_ArtNem_Grounder,1,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_ARZ_End

DbgObjList_SCZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_WFZPalSwitcher, Obj03_MapUnc_1FFB8,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $5E,   0, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $60,   1, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $62,   2, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_VPropeller,	ObjB4_MapUnc_3B3BE, $64,   0, make_art_tile(ArtTile_ArtNem_WfzVrtclPrpllr,1,1)
	dbglistobj ObjID_HPropeller,	ObjB5_MapUnc_3B548, $66,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1)
	dbglistobj ObjID_HPropeller,	ObjB5_MapUnc_3B548, $68,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1)
	dbglistobj ObjID_Turtloid,	Obj9A_Obj98_MapUnc_37B62, $16,   0, make_art_tile(ArtTile_ArtNem_Turtloid,0,0)
	dbglistobj ObjID_Balkiry,	ObjAC_MapUnc_393CC, $40,   0, make_art_tile(ArtTile_ArtNem_Balkrie,0,0)
	dbglistobj ObjID_Nebula,	Obj99_Obj98_MapUnc_3789A, $12,   0, make_art_tile(ArtTile_ArtNem_Nebula,1,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_SCZ_End

	jmpTos JmpTo66_Adjust2PArtPointer




; ---------------------------------------------------------------------------
; "MAIN LEVEL LOAD BLOCK" (after Nemesis)
;
; This struct array tells the engine where to find all the art associated with
; a particular zone. Each zone gets three longwords, in which it stores three
; pointers (in the lower 24 bits) and three jump table indeces (in the upper eight
; bits). The assembled data looks something like this:
;
; aaBBBBBB
; ccDDDDDD
; eeFFFFFF
;
; aa = index for primary pattern load request list
; BBBBBB = pointer to level art
; cc = index for secondary pattern load request list
; DDDDDD = pointer to 16x16 block mappings
; ee = index for palette
; FFFFFF = pointer to 128x128 block mappings
;
; Nemesis refers to this as the "main level load block". However, that name implies
; that this is code (obviously, it isn't), or at least that it points to the level's
; collision, object and ring placement arrays (it only points to art...
; although the 128x128 mappings do affect the actual level layout and collision)
; ---------------------------------------------------------------------------

; declare some global variables to be used by the levartptrs macro
cur_zone_id := 0
cur_zone_str := "0"

; macro for declaring a "main level load block" (MLLB)
levartptrs macro plc1,plc2,palette,art,map16x16,map128x128
	!org LevelArtPointers+zone_id_{cur_zone_str}*12
	dc.l (plc1<<24)|art
	dc.l (plc2<<24)|map16x16
	dc.l (palette<<24)|map128x128
cur_zone_id := cur_zone_id+1
cur_zone_str := "\{cur_zone_id}"
    endm

; BEGIN SArt_Ptrs Art_Ptrs_Array[17]
; dword_42594: MainLoadBlocks: saArtPtrs:
LevelArtPointers:
	levartptrs PLCID_Ehz1,        PLCID_Ehz2,      PalID_EHZ,  ArtKos_EHZ, BM16_EHZ, BM128_EHZ ; EHZ    ; EMERALD HILL ZONE
	levartptrs PLCID_MilesLife2P, PLCID_MilesLife, PalID_EHZ2, ArtKos_EHZ, BM16_EHZ, BM128_EHZ ; Zone 1 ; LEVEL 1 (UNUSED)
	levartptrs PLCID_TailsLife2P, PLCID_TailsLife, PalID_WZ,   ArtKos_EHZ, BM16_EHZ, BM128_EHZ ; WZ     ; WOOD ZONE (UNUSED)
	levartptrs PLCID_Unused1,     PLCID_Unused2,   PalID_EHZ3, ArtKos_EHZ, BM16_EHZ, BM128_EHZ ; Zone 3 ; LEVEL 3 (UNUSED)
	levartptrs PLCID_Mtz1,        PLCID_Mtz2,      PalID_MTZ,  ArtKos_MTZ, BM16_MTZ, BM128_MTZ ; MTZ1,2 ; METROPOLIS ZONE ACTS 1 & 2
	levartptrs PLCID_Mtz1,        PLCID_Mtz2,      PalID_MTZ,  ArtKos_MTZ, BM16_MTZ, BM128_MTZ ; MTZ3   ; METROPOLIS ZONE ACT 3
	levartptrs PLCID_Wfz1,        PLCID_Wfz2,      PalID_WFZ,  ArtKos_SCZ, BM16_WFZ, BM128_WFZ ; WFZ    ; WING FORTRESS ZONE
	levartptrs PLCID_Htz1,        PLCID_Htz2,      PalID_HTZ,  ArtKos_EHZ, BM16_EHZ, BM128_EHZ ; HTZ    ; HILL TOP ZONE
	levartptrs PLCID_Hpz1,        PLCID_Hpz2,      PalID_HPZ,  ArtKos_HPZ, BM16_HPZ, BM128_HPZ ; HPZ    ; HIDDEN PALACE ZONE (UNUSED)
	levartptrs PLCID_Unused3,     PLCID_Unused4,   PalID_EHZ4, ArtKos_EHZ, BM16_EHZ, BM128_EHZ ; Zone 9 ; LEVEL 9 (UNUSED)
	levartptrs PLCID_Ooz1,        PLCID_Ooz2,      PalID_OOZ,  ArtKos_OOZ, BM16_OOZ, BM128_OOZ ; OOZ    ; OIL OCEAN ZONE
	levartptrs PLCID_Mcz1,        PLCID_Mcz2,      PalID_MCZ,  ArtKos_MCZ, BM16_MCZ, BM128_MCZ ; MCZ    ; MYSTIC CAVE ZONE
	levartptrs PLCID_Cnz1,        PLCID_Cnz2,      PalID_CNZ,  ArtKos_CNZ, BM16_CNZ, BM128_CNZ ; CNZ    ; CASINO NIGHT ZONE
	levartptrs PLCID_Cpz1,        PLCID_Cpz2,      PalID_CPZ,  ArtKos_CPZ, BM16_CPZ, BM128_CPZ ; CPZ    ; CHEMICAL PLANT ZONE
	levartptrs PLCID_Dez1,        PLCID_Dez2,      PalID_DEZ,  ArtKos_CPZ, BM16_CPZ, BM128_CPZ ; DEZ    ; DEATH EGG ZONE
	levartptrs PLCID_Arz1,        PLCID_Arz2,      PalID_ARZ,  ArtKos_ARZ, BM16_ARZ, BM128_ARZ ; ARZ    ; AQUATIC RUIN ZONE
	levartptrs PLCID_Scz1,        PLCID_Scz2,      PalID_SCZ,  ArtKos_SCZ, BM16_WFZ, BM128_WFZ ; SCZ    ; SKY CHASE ZONE

    if (cur_zone_id<>no_of_zones)&&(MOMPASS=1)
	message "Warning: Table LevelArtPointers has \{cur_zone_id/1.0} entries, but it should have \{no_of_zones/1.0} entries"
    endif
	!org LevelArtPointers+cur_zone_id*12

; ---------------------------------------------------------------------------
; END Art_Ptrs_Array[17]




; ---------------------------------------------------------------------------
; PATTERN LOAD REQUEST LISTS
;
; Pattern load request lists are simple structures used to load
; Nemesis-compressed art for sprites.
;
; The decompressor predictably moves down the list, so request 0 is processed first, etc.
; This only matters if your addresses are bad and you overwrite art loaded in a previous request.
;

; NOTICE: The load queue buffer can only hold $10 (16) load requests. None of the routines
; that load PLRs into the queue do any bounds checking, so it's possible to create a buffer
; overflow and completely screw up the variables stored directly after the queue buffer.
; (in my experience this is a guaranteed crash or hang)
;
; Many levels queue more than 16 items overall,
; but they don't exceed the limit because
; their PLRs are split into multiple parts (like PlrList_Mtz1 and PlrList_Mtz2)
; and they fully process the first part before requesting the rest.
;
; If you can find some extra RAM for it (which is easy in Sonic 2),
; you can increase this limit by increasing the size of Plc_Buffer.
; ---------------------------------------------------------------------------

;---------------------------------------------------------------------------------------
; Table of pattern load request lists. Remember to use word-length data when adding lists
; otherwise you'll break the array.
;---------------------------------------------------------------------------------------
; word_42660 ; OffInd_PlrLists:
ArtLoadCues:		offsetTable
PLCptr_Std1:		offsetTableEntry.w PlrList_Std1			; 0
PLCptr_Std2:		offsetTableEntry.w PlrList_Std2			; 1
PLCptr_StdWtr:		offsetTableEntry.w PlrList_StdWtr		; 2
PLCptr_GameOver:	offsetTableEntry.w PlrList_GameOver		; 3
PLCptr_Ehz1:		offsetTableEntry.w PlrList_Ehz1			; 4
PLCptr_Ehz2:		offsetTableEntry.w PlrList_Ehz2			; 5
PLCptr_MilesLife2P:	offsetTableEntry.w PlrList_MilesLife2P		; 6
PLCptr_MilesLife:	offsetTableEntry.w PlrList_MilesLife		; 7
PLCptr_TailsLife2P:	offsetTableEntry.w PlrList_TailsLife2P		; 8
PLCptr_TailsLife:	offsetTableEntry.w PlrList_TailsLife		; 9
PLCptr_Unused1:		offsetTableEntry.w PlrList_Mtz1			; 10
PLCptr_Unused2:		offsetTableEntry.w PlrList_Mtz1			; 11
PLCptr_Mtz1:		offsetTableEntry.w PlrList_Mtz1			; 12
PLCptr_Mtz2:		offsetTableEntry.w PlrList_Mtz2			; 13
			offsetTableEntry.w PlrList_Wfz1			; 14
			offsetTableEntry.w PlrList_Wfz1			; 15
PLCptr_Wfz1:		offsetTableEntry.w PlrList_Wfz1			; 16
PLCptr_Wfz2:		offsetTableEntry.w PlrList_Wfz2			; 17
PLCptr_Htz1:		offsetTableEntry.w PlrList_Htz1			; 18
PLCptr_Htz2:		offsetTableEntry.w PlrList_Htz2			; 19
PLCptr_Hpz1:		offsetTableEntry.w PlrList_Hpz1			; 20
PLCptr_Hpz2:		offsetTableEntry.w PlrList_Hpz2			; 21
PLCptr_Unused3:		offsetTableEntry.w PlrList_Ooz1			; 22
PLCptr_Unused4:		offsetTableEntry.w PlrList_Ooz1			; 23
PLCptr_Ooz1:		offsetTableEntry.w PlrList_Ooz1			; 24
PLCptr_Ooz2:		offsetTableEntry.w PlrList_Ooz2			; 25
PLCptr_Mcz1:		offsetTableEntry.w PlrList_Mcz1			; 26
PLCptr_Mcz2:		offsetTableEntry.w PlrList_Mcz2			; 27
PLCptr_Cnz1:		offsetTableEntry.w PlrList_Cnz1			; 28
PLCptr_Cnz2:		offsetTableEntry.w PlrList_Cnz2			; 29
PLCptr_Cpz1:		offsetTableEntry.w PlrList_Cpz1			; 30
PLCptr_Cpz2:		offsetTableEntry.w PlrList_Cpz2			; 31
PLCptr_Dez1:		offsetTableEntry.w PlrList_Dez1			; 32
PLCptr_Dez2:		offsetTableEntry.w PlrList_Dez2			; 33
PLCptr_Arz1:		offsetTableEntry.w PlrList_Arz1			; 34
PLCptr_Arz2:		offsetTableEntry.w PlrList_Arz2			; 35
PLCptr_Scz1:		offsetTableEntry.w PlrList_Scz1			; 36
PLCptr_Scz2:		offsetTableEntry.w PlrList_Scz2			; 37
PLCptr_Results:		offsetTableEntry.w PlrList_Results		; 38
PLCptr_Signpost:	offsetTableEntry.w PlrList_Signpost		; 39
PLCptr_CpzBoss:		offsetTableEntry.w PlrList_CpzBoss		; 40
PLCptr_EhzBoss:		offsetTableEntry.w PlrList_EhzBoss		; 41
PLCptr_HtzBoss:		offsetTableEntry.w PlrList_HtzBoss		; 42
PLCptr_ArzBoss:		offsetTableEntry.w PlrList_ArzBoss		; 43
PLCptr_MczBoss:		offsetTableEntry.w PlrList_MczBoss		; 44
PLCptr_CnzBoss:		offsetTableEntry.w PlrList_CnzBoss		; 45
PLCptr_MtzBoss:		offsetTableEntry.w PlrList_MtzBoss		; 46
PLCptr_OozBoss:		offsetTableEntry.w PlrList_OozBoss		; 47
PLCptr_FieryExplosion:	offsetTableEntry.w PlrList_FieryExplosion	; 48
PLCptr_DezBoss:		offsetTableEntry.w PlrList_DezBoss		; 49
PLCptr_EhzAnimals:	offsetTableEntry.w PlrList_EhzAnimals		; 50
PLCptr_MczAnimals:	offsetTableEntry.w PlrList_MczAnimals		; 51
PLCptr_HtzAnimals:
PLCptr_MtzAnimals:
PLCptr_WfzAnimals:	offsetTableEntry.w PlrList_WfzAnimals		; 52
PLCptr_DezAnimals:	offsetTableEntry.w PlrList_DezAnimals		; 53
PLCptr_HpzAnimals:	offsetTableEntry.w PlrList_HpzAnimals		; 54
PLCptr_OozAnimals:	offsetTableEntry.w PlrList_OozAnimals		; 55
PLCptr_SczAnimals:	offsetTableEntry.w PlrList_SczAnimals		; 56
PLCptr_CnzAnimals:	offsetTableEntry.w PlrList_CnzAnimals		; 57
PLCptr_CpzAnimals:	offsetTableEntry.w PlrList_CpzAnimals		; 58
PLCptr_ArzAnimals:	offsetTableEntry.w PlrList_ArzAnimals		; 59
PLCptr_SpecialStage:	offsetTableEntry.w PlrList_SpecialStage		; 60
PLCptr_SpecStageBombs:	offsetTableEntry.w PlrList_SpecStageBombs	; 61
PLCptr_WfzBoss:		offsetTableEntry.w PlrList_WfzBoss		; 62
PLCptr_Tornado:		offsetTableEntry.w PlrList_Tornado		; 63
PLCptr_Capsule:		offsetTableEntry.w PlrList_Capsule		; 64
PLCptr_Explosion:	offsetTableEntry.w PlrList_Explosion		; 65
PLCptr_ResultsTails:	offsetTableEntry.w PlrList_ResultsTails		; 66

; macro for a pattern load request list header
; must be on the same line as a label that has a corresponding _End label later
plrlistheader macro {INTLABEL}
__LABEL__ label *
	dc.w (((__LABEL___End - __LABEL__Plc) / 6) - 1)
__LABEL__Plc:
    endm

; macro for a pattern load request
plreq macro toVRAMaddr,fromROMaddr
	dc.l	fromROMaddr
	dc.w	tiles_to_bytes(toVRAMaddr)
    endm

;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Standard 1 - loaded for every level
;---------------------------------------------------------------------------------------
PlrList_Std1: plrlistheader
	plreq ArtTile_ArtNem_HUD, ArtNem_HUD
	plreq ArtTile_ArtNem_life_counter, ArtNem_Sonic_life_counter
	plreq ArtTile_ArtNem_Ring, ArtNem_Ring
	plreq ArtTile_ArtNem_Numbers, ArtNem_Numbers
PlrList_Std1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Standard 2 - loaded for every level
;---------------------------------------------------------------------------------------
PlrList_Std2: plrlistheader
	plreq ArtTile_ArtNem_Checkpoint, ArtNem_Checkpoint
	plreq ArtTile_ArtNem_Powerups, ArtNem_Powerups
	plreq ArtTile_ArtNem_Shield, ArtNem_Shield
	plreq ArtTile_ArtNem_Invincible_stars, ArtNem_Invincible_stars
PlrList_Std2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Aquatic level standard
;---------------------------------------------------------------------------------------
PlrList_StdWtr:	plrlistheader
	plreq ArtTile_ArtNem_Explosion, ArtNem_Explosion
	plreq ArtTile_ArtNem_SuperSonic_stars, ArtNem_SuperSonic_stars
	plreq ArtTile_ArtNem_Bubbles, ArtNem_Bubbles
PlrList_StdWtr_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Game/Time over
;---------------------------------------------------------------------------------------
PlrList_GameOver: plrlistheader
	plreq ArtTile_ArtNem_Game_Over, ArtNem_Game_Over
PlrList_GameOver_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Emerald Hill Zone primary
;---------------------------------------------------------------------------------------
PlrList_Ehz1: plrlistheader
	plreq ArtTile_ArtNem_Waterfall, ArtNem_Waterfall
	plreq ArtTile_ArtNem_EHZ_Bridge, ArtNem_EHZ_Bridge
	plreq ArtTile_ArtNem_Buzzer_Fireball, ArtNem_HtzFireball1
	plreq ArtTile_ArtNem_Buzzer, ArtNem_Buzzer
	plreq ArtTile_ArtNem_Coconuts, ArtNem_Coconuts
	plreq ArtTile_ArtNem_Masher, ArtNem_Masher
PlrList_Ehz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Emerald Hill Zone secondary
;---------------------------------------------------------------------------------------
PlrList_Ehz2: plrlistheader
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_DignlSprng
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Ehz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Miles 1up patch
;---------------------------------------------------------------------------------------
PlrList_MilesLife2P: plrlistheader
	plreq ArtTile_ArtNem_2p_life_counter, ArtNem_MilesLife
PlrList_MilesLife2P_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Miles life counter
;---------------------------------------------------------------------------------------
PlrList_MilesLife: plrlistheader
	plreq ArtTile_ArtNem_life_counter, ArtNem_MilesLife
PlrList_MilesLife_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Tails 1up patch
;---------------------------------------------------------------------------------------
PlrList_TailsLife2P: plrlistheader
	plreq ArtTile_ArtNem_2p_life_counter, ArtNem_TailsLife
PlrList_TailsLife2P_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Tails life counter
;---------------------------------------------------------------------------------------
PlrList_TailsLife: plrlistheader
	plreq ArtTile_ArtNem_life_counter, ArtNem_TailsLife
PlrList_TailsLife_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Metropolis Zone primary
;---------------------------------------------------------------------------------------
PlrList_Mtz1: plrlistheader
	plreq ArtTile_ArtNem_MtzWheel, ArtNem_MtzWheel
	plreq ArtTile_ArtNem_MtzWheelIndent, ArtNem_MtzWheelIndent
	plreq ArtTile_ArtNem_LavaCup, ArtNem_LavaCup
	plreq ArtTile_ArtNem_BoltEnd_Rope, ArtNem_BoltEnd_Rope
	plreq ArtTile_ArtNem_MtzSteam, ArtNem_MtzSteam
	plreq ArtTile_ArtNem_MtzSpikeBlock, ArtNem_MtzSpikeBlock
	plreq ArtTile_ArtNem_MtzSpike, ArtNem_MtzSpike
	plreq ArtTile_ArtNem_Shellcracker, ArtNem_Shellcracker
	plreq ArtTile_ArtNem_MtzSupernova, ArtNem_MtzSupernova
PlrList_Mtz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Metropolis Zone secondary
;---------------------------------------------------------------------------------------
PlrList_Mtz2: plrlistheader
	plreq ArtTile_ArtNem_Button, ArtNem_Button
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_MtzMantis, ArtNem_MtzMantis
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
	plreq ArtTile_ArtNem_MtzAsstBlocks, ArtNem_MtzAsstBlocks
	plreq ArtTile_ArtNem_MtzLavaBubble, ArtNem_MtzLavaBubble
	plreq ArtTile_ArtNem_MtzCog, ArtNem_MtzCog
	plreq ArtTile_ArtNem_MtzSpinTubeFlash, ArtNem_MtzSpinTubeFlash
PlrList_Mtz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Wing Fortress Zone primary
;---------------------------------------------------------------------------------------
PlrList_Wfz1: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
	plreq ArtTile_ArtNem_WfzVrtclPrpllr, ArtNem_WfzVrtclPrpllr
	plreq ArtTile_ArtNem_WfzHrzntlPrpllr, ArtNem_WfzHrzntlPrpllr
	plreq ArtTile_ArtNem_Balkrie, ArtNem_Balkrie
	plreq ArtTile_ArtNem_BreakPanels, ArtNem_BreakPanels
	plreq ArtTile_ArtNem_WfzScratch, ArtNem_WfzScratch
	plreq ArtTile_ArtNem_WfzTiltPlatforms, ArtNem_WfzTiltPlatforms
	; These two are already in the list, so this is redundant
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
PlrList_Wfz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Wing Fortress Zone secondary
;---------------------------------------------------------------------------------------
PlrList_Wfz2: plrlistheader
	plreq ArtTile_ArtNem_WfzVrtclPrpllr, ArtNem_WfzVrtclPrpllr
	plreq ArtTile_ArtNem_WfzHrzntlPrpllr, ArtNem_WfzHrzntlPrpllr
	plreq ArtTile_ArtNem_WfzVrtclLazer, ArtNem_WfzVrtclLazer
	plreq ArtTile_ArtNem_WfzWallTurret, ArtNem_WfzWallTurret
	plreq ArtTile_ArtNem_WfzHrzntlLazer, ArtNem_WfzHrzntlLazer
	plreq ArtTile_ArtNem_WfzConveyorBeltWheel, ArtNem_WfzConveyorBeltWheel
	plreq ArtTile_ArtNem_WfzHook, ArtNem_WfzHook
	plreq ArtTile_ArtNem_WfzThrust, ArtNem_WfzThrust
	plreq ArtTile_ArtNem_WfzBeltPlatform, ArtNem_WfzBeltPlatform
	plreq ArtTile_ArtNem_WfzGunPlatform, ArtNem_WfzGunPlatform
	plreq ArtTile_ArtNem_WfzUnusedBadnik, ArtNem_WfzUnusedBadnik
	plreq ArtTile_ArtNem_WfzLaunchCatapult, ArtNem_WfzLaunchCatapult
	plreq ArtTile_ArtNem_WfzSwitch, ArtNem_WfzSwitch
	plreq ArtTile_ArtNem_WfzFloatingPlatform, ArtNem_WfzFloatingPlatform
PlrList_Wfz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Hill Top Zone primary
;---------------------------------------------------------------------------------------
PlrList_Htz1: plrlistheader
	plreq ArtTile_ArtNem_HtzFireball1, ArtNem_HtzFireball1
	plreq ArtTile_ArtNem_HtzRock, ArtNem_HtzRock
	plreq ArtTile_ArtNem_HtzSeeSaw, ArtNem_HtzSeeSaw
	plreq ArtTile_ArtNem_Sol, ArtNem_Sol
	plreq ArtTile_ArtNem_Rexon, ArtNem_Rexon
	plreq ArtTile_ArtNem_Spiker, ArtNem_Spiker
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_DignlSprng
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Htz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Hill Top Zone secondary
;---------------------------------------------------------------------------------------
PlrList_Htz2: plrlistheader
	plreq ArtTile_ArtNem_HtzZipline, ArtNem_HtzZipline
	plreq ArtTile_ArtNem_HtzFireball2, ArtNem_HtzFireball2
	plreq ArtTile_ArtNem_HtzValveBarrier, ArtNem_HtzValveBarrier
PlrList_Htz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; HPZ Primary
;---------------------------------------------------------------------------------------
PlrList_Hpz1: ;plrlistheader
;	plreq ArtTile_ArtNem_WaterSurface, ArtNem_WaterSurface
;PlrList_Hpz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; HPZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Hpz2: ;plrlistheader
;PlrList_Hpz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; OOZ Primary
;---------------------------------------------------------------------------------------
PlrList_Ooz1: plrlistheader
	plreq ArtTile_ArtNem_OOZBurn, ArtNem_OOZBurn
	plreq ArtTile_ArtNem_OOZElevator, ArtNem_OOZElevator
	plreq ArtTile_ArtNem_SpikyThing, ArtNem_SpikyThing
	plreq ArtTile_ArtNem_BurnerLid, ArtNem_BurnerLid
	plreq ArtTile_ArtNem_StripedBlocksVert, ArtNem_StripedBlocksVert
	plreq ArtTile_ArtNem_Oilfall, ArtNem_Oilfall
	plreq ArtTile_ArtNem_Oilfall2, ArtNem_Oilfall2
	plreq ArtTile_ArtNem_BallThing, ArtNem_BallThing
	plreq ArtTile_ArtNem_LaunchBall, ArtNem_LaunchBall
PlrList_Ooz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; OOZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Ooz2: plrlistheader
	plreq ArtTile_ArtNem_OOZPlatform, ArtNem_OOZPlatform
	plreq ArtTile_ArtNem_PushSpring, ArtNem_PushSpring
	plreq ArtTile_ArtNem_OOZSwingPlat, ArtNem_OOZSwingPlat
	plreq ArtTile_ArtNem_StripedBlocksHoriz, ArtNem_StripedBlocksHoriz
	plreq ArtTile_ArtNem_OOZFanHoriz, ArtNem_OOZFanHoriz
	plreq ArtTile_ArtNem_Button, ArtNem_Button
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_DignlSprng
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
	plreq ArtTile_ArtNem_Aquis, ArtNem_Aquis
	plreq ArtTile_ArtNem_Octus, ArtNem_Octus
PlrList_Ooz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; MCZ Primary
;---------------------------------------------------------------------------------------
PlrList_Mcz1: plrlistheader
	plreq ArtTile_ArtNem_Crate, ArtNem_Crate
	plreq ArtTile_ArtNem_MCZCollapsePlat, ArtNem_MCZCollapsePlat
	plreq ArtTile_ArtNem_VineSwitch, ArtNem_VineSwitch
	plreq ArtTile_ArtNem_VinePulley, ArtNem_VinePulley
	plreq ArtTile_ArtNem_Flasher, ArtNem_Flasher
	plreq ArtTile_ArtNem_Crawlton, ArtNem_Crawlton
PlrList_Mcz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; MCZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Mcz2: plrlistheader
	plreq ArtTile_ArtNem_HorizSpike, ArtNem_HorizSpike
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_MCZGateLog, ArtNem_MCZGateLog
	plreq ArtTile_ArtNem_LeverSpring, ArtNem_LeverSpring
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Mcz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CNZ Primary
;---------------------------------------------------------------------------------------
PlrList_Cnz1: plrlistheader
	plreq ArtTile_ArtNem_Crawl, ArtNem_Crawl
	plreq ArtTile_ArtNem_BigMovingBlock, ArtNem_BigMovingBlock
	plreq ArtTile_ArtNem_CNZSnake, ArtNem_CNZSnake
	plreq ArtTile_ArtNem_CNZBonusSpike, ArtNem_CNZBonusSpike
	plreq ArtTile_ArtNem_CNZElevator, ArtNem_CNZElevator
	plreq ArtTile_ArtNem_CNZCage, ArtNem_CNZCage
	plreq ArtTile_ArtNem_CNZHexBumper, ArtNem_CNZHexBumper
	plreq ArtTile_ArtNem_CNZRoundBumper, ArtNem_CNZRoundBumper
	plreq ArtTile_ArtNem_CNZFlipper, ArtNem_CNZFlipper
	plreq ArtTile_ArtNem_CNZMiniBumper, ArtNem_CNZMiniBumper
PlrList_Cnz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CNZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Cnz2: plrlistheader
	plreq ArtTile_ArtNem_CNZDiagPlunger, ArtNem_CNZDiagPlunger
	plreq ArtTile_ArtNem_CNZVertPlunger, ArtNem_CNZVertPlunger
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_DignlSprng
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Cnz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CPZ Primary
;---------------------------------------------------------------------------------------
PlrList_Cpz1: plrlistheader
	plreq ArtTile_ArtNem_CPZMetalThings, ArtNem_CPZMetalThings
	plreq ArtTile_ArtNem_ConstructionStripes_2, ArtNem_ConstructionStripes
	plreq ArtTile_ArtNem_CPZBooster, ArtNem_CPZBooster
	plreq ArtTile_ArtNem_CPZElevator, ArtNem_CPZElevator
	plreq ArtTile_ArtNem_CPZAnimatedBits, ArtNem_CPZAnimatedBits
	plreq ArtTile_ArtNem_CPZTubeSpring, ArtNem_CPZTubeSpring
	plreq ArtTile_ArtNem_WaterSurface, ArtNem_WaterSurface
	plreq ArtTile_ArtNem_CPZStairBlock, ArtNem_CPZStairBlock
	plreq ArtTile_ArtNem_CPZMetalBlock, ArtNem_CPZMetalBlock
PlrList_Cpz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CPZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Cpz2: plrlistheader
	plreq ArtTile_ArtNem_Grabber, ArtNem_Grabber
	plreq ArtTile_ArtNem_Spiny, ArtNem_Spiny
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_CPZDroplet
	plreq ArtTile_ArtNem_LeverSpring, ArtNem_LeverSpring
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Cpz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; DEZ Primary
;---------------------------------------------------------------------------------------
PlrList_Dez1: plrlistheader
	plreq ArtTile_ArtNem_ConstructionStripes_1, ArtNem_ConstructionStripes
PlrList_Dez1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; DEZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Dez2: plrlistheader
	plreq ArtTile_ArtNem_SilverSonic, ArtNem_SilverSonic
	plreq ArtTile_ArtNem_DEZWindow, ArtNem_DEZWindow
	plreq ArtTile_ArtNem_RobotnikRunning, ArtNem_RobotnikRunning
	plreq ArtTile_ArtNem_RobotnikUpper, ArtNem_RobotnikUpper
	plreq ArtTile_ArtNem_RobotnikLower, ArtNem_RobotnikLower
PlrList_Dez2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; ARZ Primary
;---------------------------------------------------------------------------------------
PlrList_Arz1: plrlistheader
	plreq ArtTile_ArtNem_ARZBarrierThing, ArtNem_ARZBarrierThing
	plreq ArtTile_ArtNem_WaterSurface, ArtNem_WaterSurface2
	plreq ArtTile_ArtNem_Leaves, ArtNem_Leaves
	plreq ArtTile_ArtNem_ArrowAndShooter, ArtNem_ArrowAndShooter
PlrList_Arz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; ARZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Arz2: plrlistheader
	plreq ArtTile_ArtNem_ChopChop, ArtNem_ChopChop
	plreq ArtTile_ArtNem_Whisp, ArtNem_Whisp
	plreq ArtTile_ArtNem_Grounder, ArtNem_Grounder
	plreq ArtTile_ArtNem_BigBubbles, ArtNem_BigBubbles
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_LeverSpring, ArtNem_LeverSpring
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Arz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; SCZ Primary
;---------------------------------------------------------------------------------------
PlrList_Scz1: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
PlrList_Scz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; SCZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Scz2: plrlistheader
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
	plreq ArtTile_ArtNem_WfzVrtclPrpllr, ArtNem_WfzVrtclPrpllr
	plreq ArtTile_ArtNem_WfzHrzntlPrpllr, ArtNem_WfzHrzntlPrpllr
	plreq ArtTile_ArtNem_Balkrie, ArtNem_Balkrie
	plreq ArtTile_ArtNem_Turtloid, ArtNem_Turtloid
	plreq ArtTile_ArtNem_Nebula, ArtNem_Nebula
PlrList_Scz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Sonic end of level results screen
;---------------------------------------------------------------------------------------
PlrList_Results: plrlistheader
	plreq ArtTile_ArtNem_TitleCard, ArtNem_TitleCard
	plreq ArtTile_ArtNem_ResultsText, ArtNem_ResultsText
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniSonic
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_Results_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; End of level signpost
;---------------------------------------------------------------------------------------
PlrList_Signpost: plrlistheader
	plreq ArtTile_ArtNem_Signpost, ArtNem_Signpost
PlrList_Signpost_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CPZ Boss
;---------------------------------------------------------------------------------------
PlrList_CpzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_3, ArtNem_Eggpod
	plreq ArtTile_ArtNem_CPZBoss, ArtNem_CPZBoss
	plreq ArtTile_ArtNem_EggpodJets_1, ArtNem_EggpodJets
	plreq ArtTile_ArtNem_BossSmoke_1, ArtNem_BossSmoke
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_CpzBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; EHZ Boss
;---------------------------------------------------------------------------------------
PlrList_EhzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_1, ArtNem_Eggpod
	plreq ArtTile_ArtNem_EHZBoss, ArtNem_EHZBoss
	plreq ArtTile_ArtNem_EggChoppers, ArtNem_EggChoppers
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_EhzBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; HTZ Boss
;---------------------------------------------------------------------------------------
PlrList_HtzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_2, ArtNem_Eggpod
	plreq ArtTile_ArtNem_HTZBoss, ArtNem_HTZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
	plreq ArtTile_ArtNem_BossSmoke_2, ArtNem_BossSmoke
PlrList_HtzBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; ARZ Boss
;---------------------------------------------------------------------------------------
PlrList_ArzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_ARZBoss, ArtNem_ARZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_ArzBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; MCZ Boss
;---------------------------------------------------------------------------------------
PlrList_MczBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_MCZBoss, ArtNem_MCZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_MczBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CNZ Boss
;---------------------------------------------------------------------------------------
PlrList_CnzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_CNZBoss, ArtNem_CNZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_CnzBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; MTZ Boss
;---------------------------------------------------------------------------------------
PlrList_MtzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_MTZBoss, ArtNem_MTZBoss
	plreq ArtTile_ArtNem_EggpodJets_2, ArtNem_EggpodJets
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_MtzBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; OOZ Boss
;---------------------------------------------------------------------------------------
PlrList_OozBoss: plrlistheader
	plreq ArtTile_ArtNem_OOZBoss, ArtNem_OOZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_OozBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Fiery Explosion
;---------------------------------------------------------------------------------------
PlrList_FieryExplosion: plrlistheader
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_FieryExplosion_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Death Egg
;---------------------------------------------------------------------------------------
PlrList_DezBoss: plrlistheader
	plreq ArtTile_ArtNem_DEZBoss, ArtNem_DEZBoss
PlrList_DezBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; EHZ Animals
;---------------------------------------------------------------------------------------
PlrList_EhzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Squirrel
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Flicky
PlrList_EhzAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; MCZ Animals
;---------------------------------------------------------------------------------------
PlrList_MczAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Mouse
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_MczAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; HTZ/MTZ/WFZ animals
;---------------------------------------------------------------------------------------
PlrList_HtzAnimals:
PlrList_MtzAnimals:
PlrList_WfzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Monkey
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Eagle
PlrList_HtzAnimals_End
PlrList_MtzAnimals_End
PlrList_WfzAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; DEZ Animals
;---------------------------------------------------------------------------------------
PlrList_DezAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Pig
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_DezAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; HPZ animals
;---------------------------------------------------------------------------------------
PlrList_HpzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Mouse
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Seal
PlrList_HpzAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; OOZ Animals
;---------------------------------------------------------------------------------------
PlrList_OozAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Penguin
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Seal
PlrList_OozAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; SCZ Animals
;---------------------------------------------------------------------------------------
PlrList_SczAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Turtle
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_SczAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CNZ Animals
;---------------------------------------------------------------------------------------
PlrList_CnzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Bear
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Flicky
PlrList_CnzAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CPZ Animals
;---------------------------------------------------------------------------------------
PlrList_CpzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Rabbit
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Eagle
PlrList_CpzAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; ARZ Animals
;---------------------------------------------------------------------------------------
PlrList_ArzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Penguin
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Flicky
PlrList_ArzAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Special Stage
;---------------------------------------------------------------------------------------
PlrList_SpecialStage: plrlistheader
	plreq ArtTile_ArtNem_SpecialEmerald, ArtNem_SpecialEmerald
	plreq ArtTile_ArtNem_SpecialMessages, ArtNem_SpecialMessages
	plreq ArtTile_ArtNem_SpecialHUD, ArtNem_SpecialHUD
	plreq ArtTile_ArtNem_SpecialFlatShadow, ArtNem_SpecialFlatShadow
	plreq ArtTile_ArtNem_SpecialDiagShadow, ArtNem_SpecialDiagShadow
	plreq ArtTile_ArtNem_SpecialSideShadow, ArtNem_SpecialSideShadow
	plreq ArtTile_ArtNem_SpecialExplosion, ArtNem_SpecialExplosion
	plreq ArtTile_ArtNem_SpecialRings, ArtNem_SpecialRings
	plreq ArtTile_ArtNem_SpecialStart, ArtNem_SpecialStart
	plreq ArtTile_ArtNem_SpecialPlayerVSPlayer, ArtNem_SpecialPlayerVSPlayer
	plreq ArtTile_ArtNem_SpecialBack, ArtNem_SpecialBack
	plreq ArtTile_ArtNem_SpecialStars, ArtNem_SpecialStars
	plreq ArtTile_ArtNem_SpecialTailsText, ArtNem_SpecialTailsText
PlrList_SpecialStage_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Special Stage Bombs
;---------------------------------------------------------------------------------------
PlrList_SpecStageBombs: plrlistheader
	plreq ArtTile_ArtNem_SpecialBomb, ArtNem_SpecialBomb
PlrList_SpecStageBombs_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; WFZ Boss
;---------------------------------------------------------------------------------------
PlrList_WfzBoss: plrlistheader
	plreq ArtTile_ArtNem_WFZBoss, ArtNem_WFZBoss
	plreq ArtTile_ArtNem_RobotnikRunning, ArtNem_RobotnikRunning
	plreq ArtTile_ArtNem_RobotnikUpper, ArtNem_RobotnikUpper
	plreq ArtTile_ArtNem_RobotnikLower, ArtNem_RobotnikLower
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_WfzBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Tornado
;---------------------------------------------------------------------------------------
PlrList_Tornado: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
	plreq ArtTile_ArtNem_TornadoThruster, ArtNem_TornadoThruster
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
PlrList_Tornado_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Capsule/Egg Prison
;---------------------------------------------------------------------------------------
PlrList_Capsule: plrlistheader
	plreq ArtTile_ArtNem_Capsule, ArtNem_Capsule
PlrList_Capsule_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Normal explosion
;---------------------------------------------------------------------------------------
PlrList_Explosion: plrlistheader
	plreq ArtTile_ArtNem_Explosion, ArtNem_Explosion
PlrList_Explosion_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Tails end of level results screen
;---------------------------------------------------------------------------------------
PlrList_ResultsTails: plrlistheader
	plreq ArtTile_ArtNem_TitleCard, ArtNem_TitleCard
	plreq ArtTile_ArtNem_ResultsText, ArtNem_ResultsText
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniTails
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_ResultsTails_End




;---------------------------------------------------------------------------------------
; Weird revision-specific duplicates of portions of the PLR lists (unused)
;---------------------------------------------------------------------------------------
    if gameRevision=0
	; half of PlrList_ResultsTails
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniTails
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_ResultsTails_Dup_End
	dc.l	0
    elseif gameRevision=2
	; half of the EHZ boss PLR list
	dc.w tiles_to_bytes(ArtTile_ArtNem_FieryExplosion)
PlrList_EhzBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; HTZ Boss
;---------------------------------------------------------------------------------------
PlrList_HtzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_2, ArtNem_Eggpod
	plreq ArtTile_ArtNem_HTZBoss, ArtNem_HTZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
	plreq ArtTile_ArtNem_BossSmoke_2, ArtNem_BossSmoke
PlrList_HtzBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; ARZ Boss
;---------------------------------------------------------------------------------------
PlrList_ArzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_ARZBoss, ArtNem_ARZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_ArzBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; MCZ Boss
;---------------------------------------------------------------------------------------
PlrList_MczBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_MCZBoss, ArtNem_MCZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_MczBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; CNZ Boss
;---------------------------------------------------------------------------------------
PlrList_CnzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_CNZBoss, ArtNem_CNZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_CnzBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; MTZ Boss
;---------------------------------------------------------------------------------------
PlrList_MtzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_MTZBoss, ArtNem_MTZBoss
	plreq ArtTile_ArtNem_EggpodJets_2, ArtNem_EggpodJets
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_MtzBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; OOZ Boss
;---------------------------------------------------------------------------------------
PlrList_OozBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_OOZBoss, ArtNem_OOZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_OozBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Fiery Explosion
;---------------------------------------------------------------------------------------
PlrList_FieryExplosion_Dup: plrlistheader
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_FieryExplosion_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Death Egg
;---------------------------------------------------------------------------------------
PlrList_DezBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_DEZBoss, ArtNem_DEZBoss
PlrList_DezBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; EHZ Animals
;---------------------------------------------------------------------------------------
PlrList_EhzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Squirrel
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Flicky
PlrList_EhzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; MCZ Animals
;---------------------------------------------------------------------------------------
PlrList_MczAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Mouse
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_MczAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; HTZ/MTZ/WFZ animals
;---------------------------------------------------------------------------------------
PlrList_HtzAnimals_Dup:
PlrList_MtzAnimals_Dup:
PlrList_WfzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Monkey
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Eagle
PlrList_HtzAnimals_Dup_End
PlrList_MtzAnimals_Dup_End
PlrList_WfzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; DEZ Animals
;---------------------------------------------------------------------------------------
PlrList_DezAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Pig
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_DezAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; HPZ animals
;---------------------------------------------------------------------------------------
PlrList_HpzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Mouse
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Seal
PlrList_HpzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; OOZ Animals
;---------------------------------------------------------------------------------------
PlrList_OozAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Penguin
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Seal
PlrList_OozAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; SCZ Animals
;---------------------------------------------------------------------------------------
PlrList_SczAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Turtle
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_SczAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; CNZ Animals
;---------------------------------------------------------------------------------------
PlrList_CnzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Bear
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Flicky
PlrList_CnzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; CPZ Animals
;---------------------------------------------------------------------------------------
PlrList_CpzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Rabbit
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Eagle
PlrList_CpzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; ARZ Animals
;---------------------------------------------------------------------------------------
PlrList_ArzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Penguin
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Flicky
PlrList_ArzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Special Stage
;---------------------------------------------------------------------------------------
PlrList_SpecialStage_Dup: plrlistheader
	plreq ArtTile_ArtNem_SpecialEmerald, ArtNem_SpecialEmerald
	plreq ArtTile_ArtNem_SpecialMessages, ArtNem_SpecialMessages
	plreq ArtTile_ArtNem_SpecialHUD, ArtNem_SpecialHUD
	plreq ArtTile_ArtNem_SpecialFlatShadow, ArtNem_SpecialFlatShadow
	plreq ArtTile_ArtNem_SpecialDiagShadow, ArtNem_SpecialDiagShadow
	plreq ArtTile_ArtNem_SpecialSideShadow, ArtNem_SpecialSideShadow
	plreq ArtTile_ArtNem_SpecialExplosion, ArtNem_SpecialExplosion
	plreq ArtTile_ArtNem_SpecialRings, ArtNem_SpecialRings
	plreq ArtTile_ArtNem_SpecialStart, ArtNem_SpecialStart
	plreq ArtTile_ArtNem_SpecialPlayerVSPlayer, ArtNem_SpecialPlayerVSPlayer
	plreq ArtTile_ArtNem_SpecialBack, ArtNem_SpecialBack
	plreq ArtTile_ArtNem_SpecialStars, ArtNem_SpecialStars
	plreq ArtTile_ArtNem_SpecialTailsText, ArtNem_SpecialTailsText
PlrList_SpecialStage_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Special Stage Bombs
;---------------------------------------------------------------------------------------
PlrList_SpecStageBombs_Dup: plrlistheader
	plreq ArtTile_ArtNem_SpecialBomb, ArtNem_SpecialBomb
PlrList_SpecStageBombs_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; WFZ Boss
;---------------------------------------------------------------------------------------
PlrList_WfzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_WFZBoss, ArtNem_WFZBoss
	plreq ArtTile_ArtNem_RobotnikRunning, ArtNem_RobotnikRunning
	plreq ArtTile_ArtNem_RobotnikUpper, ArtNem_RobotnikUpper
	plreq ArtTile_ArtNem_RobotnikLower, ArtNem_RobotnikLower
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_WfzBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Tornado
;---------------------------------------------------------------------------------------
PlrList_Tornado_Dup: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
	plreq ArtTile_ArtNem_TornadoThruster, ArtNem_TornadoThruster
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
PlrList_Tornado_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Capsule/Egg Prison
;---------------------------------------------------------------------------------------
PlrList_Capsule_Dup: plrlistheader
	plreq ArtTile_ArtNem_Capsule, ArtNem_Capsule
PlrList_Capsule_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Normal explosion
;---------------------------------------------------------------------------------------
PlrList_Explosion_Dup: plrlistheader
	plreq ArtTile_ArtNem_Explosion, ArtNem_Explosion
PlrList_Explosion_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Tails end of level results screen
;---------------------------------------------------------------------------------------
PlrList_ResultsTails_Dup: plrlistheader
	plreq ArtTile_ArtNem_TitleCard, ArtNem_TitleCard
	plreq ArtTile_ArtNem_ResultsText, ArtNem_ResultsText
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniTails
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_ResultsTails_Dup_End
    endif
; In an accurate ROM, this junk data ends at $42D50.
; Though, REV00 has some 00 bytes, for some reason...



;---------------------------------------------------------------------------------------
; Collision Data
;---------------------------------------------------------------------------------------
ColCurveMap:		BINCLUDE	"collision/Curve and resistance mapping.bin"
	even
ColArrayVertical:	BINCLUDE	"collision/Collision array - Vertical.bin"
ColArrayHorizontal:	BINCLUDE	"collision/Collision array - Horizontal.bin"
	even

; These are all compressed in the Kosinski format.
ColP_EHZHTZ:	BINCLUDE	"collision/EHZ and HTZ primary 16x16 collision index.kos"
	even
ColS_EHZHTZ:	BINCLUDE	"collision/EHZ and HTZ secondary 16x16 collision index.kos"
	even
ColP_WZ:	;BINCLUDE	"collision/WZ primary 16x16 collision index.kos"
	;even
ColP_MTZ:	BINCLUDE	"collision/MTZ primary 16x16 collision index.kos"
	even
ColP_HPZ:	;BINCLUDE	"collision/HPZ primary 16x16 collision index.kos"
	;even
ColS_HPZ:	;BINCLUDE	"collision/HPZ secondary 16x16 collision index.kos"
	;even
ColP_OOZ:	BINCLUDE	"collision/OOZ primary 16x16 collision index.kos"
	even
ColP_MCZ:	BINCLUDE	"collision/MCZ primary 16x16 collision index.kos"
	even
ColP_CNZ:	BINCLUDE	"collision/CNZ primary 16x16 collision index.kos"
	even
ColS_CNZ:	BINCLUDE	"collision/CNZ secondary 16x16 collision index.kos"
	even
ColP_CPZDEZ:	BINCLUDE	"collision/CPZ and DEZ primary 16x16 collision index.kos"
	even
ColS_CPZDEZ:	BINCLUDE	"collision/CPZ and DEZ secondary 16x16 collision index.kos"
	even
ColP_ARZ:	BINCLUDE	"collision/ARZ primary 16x16 collision index.kos"
	even
ColS_ARZ:	BINCLUDE	"collision/ARZ secondary 16x16 collision index.kos"
	even
ColP_WFZSCZ:	BINCLUDE	"collision/WFZ and SCZ primary 16x16 collision index.kos"
	even
ColS_WFZSCZ:	BINCLUDE	"collision/WFZ and SCZ secondary 16x16 collision index.kos"
	even
ColP_Invalid:




;---------------------------------------------------------------------------------------
; Offset index of level layouts
; Two entries per zone, pointing to the level layouts for acts 1 and 2 of each zone
; respectively.
;---------------------------------------------------------------------------------------
Off_Level: zoneOrderedOffsetTable 2,2
	; EHZ
	zoneOffsetTableEntry.w Level_EHZ1	; Act 1
	zoneOffsetTableEntry.w Level_EHZ2	; Act 2
	; Zone 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 2
	; WZ
	zoneOffsetTableEntry.w Level_Invalid	; Act 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 2
	; Zone 3
	zoneOffsetTableEntry.w Level_Invalid	; Act 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 2
	; MTZ
	zoneOffsetTableEntry.w Level_MTZ1	; Act 1
	zoneOffsetTableEntry.w Level_MTZ2	; Act 2
	; MTZ
	zoneOffsetTableEntry.w Level_MTZ3	; Act 3
	zoneOffsetTableEntry.w Level_MTZ3	; Act 4
	; WFZ
	zoneOffsetTableEntry.w Level_WFZ	; Act 1
	zoneOffsetTableEntry.w Level_WFZ	; Act 2
	; HTZ
	zoneOffsetTableEntry.w Level_HTZ1	; Act 1
	zoneOffsetTableEntry.w Level_HTZ2	; Act 2
	; HPZ
	zoneOffsetTableEntry.w Level_HPZ1	; Act 1
	zoneOffsetTableEntry.w Level_HPZ1	; Act 2
	; Zone 9
	zoneOffsetTableEntry.w Level_Invalid	; Act 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 2
	; OOZ
	zoneOffsetTableEntry.w Level_OOZ1	; Act 1
	zoneOffsetTableEntry.w Level_OOZ2	; Act 2
	; MCZ
	zoneOffsetTableEntry.w Level_MCZ1	; Act 1
	zoneOffsetTableEntry.w Level_MCZ2	; Act 2
	; CNZ
	zoneOffsetTableEntry.w Level_CNZ1	; Act 1
	zoneOffsetTableEntry.w Level_CNZ2	; Act 2
	; CPZ
	zoneOffsetTableEntry.w Level_CPZ1	; Act 1
	zoneOffsetTableEntry.w Level_CPZ2	; Act 2
	; DEZ
	zoneOffsetTableEntry.w Level_DEZ	; Act 1
	zoneOffsetTableEntry.w Level_DEZ	; Act 2
	; ARZ
	zoneOffsetTableEntry.w Level_ARZ1	; Act 1
	zoneOffsetTableEntry.w Level_ARZ2	; Act 2
	; SCZ
	zoneOffsetTableEntry.w Level_SCZ	; Act 1
	zoneOffsetTableEntry.w Level_SCZ	; Act 2
    zoneTableEnd

; These are all compressed in the Kosinski format.
Level_Invalid:
Level_EHZ1:	BINCLUDE	"level/layout/EHZ_1.kos"
	even
Level_EHZ2:	BINCLUDE	"level/layout/EHZ_2.kos"
	even
Level_MTZ1:	BINCLUDE	"level/layout/MTZ_1.kos"
	even
Level_MTZ2:	BINCLUDE	"level/layout/MTZ_2.kos"
	even
Level_MTZ3:	BINCLUDE	"level/layout/MTZ_3.kos"
	even
Level_WFZ:	BINCLUDE	"level/layout/WFZ.kos"
	even
Level_HTZ1:	BINCLUDE	"level/layout/HTZ_1.kos"
	even
Level_HTZ2:	BINCLUDE	"level/layout/HTZ_2.kos"
	even
Level_HPZ1:	;BINCLUDE	"level/layout/HPZ_1.kos"
	;even
Level_OOZ1:	BINCLUDE	"level/layout/OOZ_1.kos"
	even
Level_OOZ2:	BINCLUDE	"level/layout/OOZ_2.kos"
	even
Level_MCZ1:	BINCLUDE	"level/layout/MCZ_1.kos"
	even
Level_MCZ2:	BINCLUDE	"level/layout/MCZ_2.kos"
	even
Level_CNZ1:	BINCLUDE	"level/layout/CNZ_1.kos"
	even
Level_CNZ2:	BINCLUDE	"level/layout/CNZ_2.kos"
	even
Level_CPZ1:	BINCLUDE	"level/layout/CPZ_1.kos"
	even
Level_CPZ2:	BINCLUDE	"level/layout/CPZ_2.kos"
	even
Level_DEZ:	BINCLUDE	"level/layout/DEZ.kos"
	even
Level_ARZ1:	BINCLUDE	"level/layout/ARZ_1.kos"
	even
Level_ARZ2:	BINCLUDE	"level/layout/ARZ_2.kos"
	even
Level_SCZ:	BINCLUDE	"level/layout/SCZ.kos"
	even




;---------------------------------------------------------------------------------------
; Animated Level Art
;---------------------------------------------------------------------------------------
; EHZ and HTZ
ArtUnc_Flowers1:	BINCLUDE	"art/uncompressed/EHZ and HTZ flowers - 1.bin"
ArtUnc_Flowers2:	BINCLUDE	"art/uncompressed/EHZ and HTZ flowers - 2.bin"
ArtUnc_Flowers3:	BINCLUDE	"art/uncompressed/EHZ and HTZ flowers - 3.bin"
ArtUnc_Flowers4:	BINCLUDE	"art/uncompressed/EHZ and HTZ flowers - 4.bin"
ArtUnc_EHZPulseBall:	BINCLUDE	"art/uncompressed/Pulsing ball against checkered background (EHZ).bin"
ArtNem_HTZCliffs:	BINCLUDE	"art/nemesis/Dynamically reloaded cliffs in HTZ background.nem"
	even
ArtUnc_HTZClouds:	BINCLUDE	"art/uncompressed/Background clouds (HTZ).bin"

; MTZ
ArtUnc_MTZCylinder:	BINCLUDE	"art/uncompressed/Spinning metal cylinder (MTZ).bin"
ArtUnc_Lava:		BINCLUDE	"art/uncompressed/Lava.bin"
ArtUnc_MTZAnimBack:	BINCLUDE	"art/uncompressed/Animated section of MTZ background.bin"

; HPZ
ArtUnc_HPZPulseOrb:	;BINCLUDE	"art/uncompressed/Pulsing orb (HPZ).bin"

; OOZ
ArtUnc_OOZPulseBall:	BINCLUDE	"art/uncompressed/Pulsing ball (OOZ).bin"
ArtUnc_OOZSquareBall1:	BINCLUDE	"art/uncompressed/Square rotating around ball in OOZ - 1.bin"
ArtUnc_OOZSquareBall2:	BINCLUDE	"art/uncompressed/Square rotating around ball in OOZ - 2.bin"
ArtUnc_Oil1:		BINCLUDE	"art/uncompressed/Oil - 1.bin"
ArtUnc_Oil2:		BINCLUDE	"art/uncompressed/Oil - 2.bin"

; CNZ
ArtUnc_CNZFlipTiles:	BINCLUDE	"art/uncompressed/Flipping foreground section (CNZ).bin"
ArtUnc_CNZSlotPics:	BINCLUDE	"art/uncompressed/Slot pictures.bin"
ArtUnc_CPZAnimBack:	BINCLUDE	"art/uncompressed/Animated background section (CPZ and DEZ).bin"

; ARZ
ArtUnc_Waterfall1:	BINCLUDE	"art/uncompressed/ARZ waterfall patterns - 1.bin"
ArtUnc_Waterfall2:	BINCLUDE	"art/uncompressed/ARZ waterfall patterns - 2.bin"
ArtUnc_Waterfall3:	BINCLUDE	"art/uncompressed/ARZ waterfall patterns - 3.bin"

;---------------------------------------------------------------------------------------
; Player Assets
;---------------------------------------------------------------------------------------
	align tiles_to_bytes(1)
ArtUnc_Sonic:			BINCLUDE	"art/uncompressed/Sonic's art.bin"
	align tiles_to_bytes(1)
ArtUnc_Tails:			BINCLUDE	"art/uncompressed/Tails's art.bin"

MapUnc_Sonic:			include		"mappings/sprite/Sonic.asm"

MapRUnc_Sonic:			include		"mappings/spriteDPLC/Sonic.asm"

ArtNem_Shield:			BINCLUDE	"art/nemesis/Shield.nem"
	even
ArtNem_Invincible_stars:	BINCLUDE	"art/nemesis/Invincibility stars.nem"
	even
ArtUnc_SplashAndDust:		BINCLUDE	"art/uncompressed/Splash and skid dust.bin"

ArtNem_SuperSonic_stars:	BINCLUDE	"art/nemesis/Super Sonic stars.nem"
	even
MapUnc_Tails:			include		"mappings/sprite/Tails.asm"

MapRUnc_Tails:			include		"mappings/spriteDPLC/Tails.asm"

;---------------------------------------------------------------------------------------
; Sega Screen Assets
;---------------------------------------------------------------------------------------
ArtNem_SEGA:			BINCLUDE	"art/nemesis/SEGA.nem"
	even
ArtNem_IntroTrails:		BINCLUDE	"art/nemesis/Shaded blocks from intro.nem"
	even
MapEng_SEGA:			BINCLUDE	"mappings/misc/SEGA mappings.eni"
	even

;---------------------------------------------------------------------------------------
; Title Screen Assets
;---------------------------------------------------------------------------------------
MapEng_TitleScreen:		BINCLUDE	"mappings/misc/Mappings for title screen background.eni"
	even
MapEng_TitleBack:		BINCLUDE	"mappings/misc/Mappings for title screen background 2.eni" ; title screen background (smaller part, water/horizon)
	even
MapEng_TitleLogo:		BINCLUDE	"mappings/misc/Sonic the Hedgehog 2 title screen logo mappings.eni"
	even
ArtNem_Title:			BINCLUDE	"art/nemesis/Main patterns from title screen.nem"
	even
ArtNem_TitleSprites:		BINCLUDE	"art/nemesis/Sonic and Tails from title screen.nem"
	even
ArtNem_MenuJunk:		BINCLUDE	"art/nemesis/A few menu blocks.nem"
	even

;---------------------------------------------------------------------------------------
; General Level Assets
;---------------------------------------------------------------------------------------
ArtNem_Button:			BINCLUDE	"art/nemesis/Button.nem"
	even
ArtNem_VrtclSprng:		BINCLUDE	"art/nemesis/Vertical spring.nem"
	even
ArtNem_HrzntlSprng:		BINCLUDE	"art/nemesis/Horizontal spring.nem"
	even
ArtNem_DignlSprng:		BINCLUDE	"art/nemesis/Diagonal spring.nem"
	even
ArtNem_HUD:			BINCLUDE	"art/nemesis/HUD.nem" ; Score, Rings, Time
	even
ArtNem_Sonic_life_counter:	BINCLUDE	"art/nemesis/Sonic lives counter.nem"
	even
ArtNem_Ring:			BINCLUDE	"art/nemesis/Ring.nem"
	even
ArtNem_Powerups:		BINCLUDE	"art/nemesis/Monitor and contents.nem"
	even
ArtNem_Spikes:			BINCLUDE	"art/nemesis/Spikes.nem"
	even
ArtNem_Numbers:			BINCLUDE	"art/nemesis/Numbers.nem"
	even
ArtNem_Checkpoint:		BINCLUDE	"art/nemesis/Star pole.nem"
	even
ArtNem_Signpost:		BINCLUDE	"art/nemesis/Signpost.nem" ; For one-player mode.
	even
ArtUnc_Signpost:		BINCLUDE	"art/uncompressed/Signpost.bin" ; For two-player mode.
	even
ArtNem_LeverSpring:		BINCLUDE	"art/nemesis/Lever spring.nem"
	even
ArtNem_HorizSpike:		BINCLUDE	"art/nemesis/Long horizontal spike.nem"
	even
ArtNem_BigBubbles:		BINCLUDE	"art/nemesis/Bubble generator.nem" ; Bubble from underwater
	even
ArtNem_Bubbles:			BINCLUDE	"art/nemesis/Bubbles.nem" ; Bubbles from character
	even
ArtUnc_Countdown:		BINCLUDE	"art/uncompressed/Numbers for drowning countdown.bin"
	even
ArtNem_Game_Over:		BINCLUDE	"art/nemesis/Game and Time Over text.nem"
	even
ArtNem_Explosion:		BINCLUDE	"art/nemesis/Explosion.nem"
	even
ArtNem_MilesLife:		BINCLUDE	"art/nemesis/Miles life counter.nem"
	even
ArtNem_Capsule:			BINCLUDE	"art/nemesis/Egg Prison.nem"
	even
ArtNem_ContinueTails:		BINCLUDE	"art/nemesis/Tails on continue screen.nem"
	even
ArtNem_MiniSonic:		BINCLUDE	"art/nemesis/Sonic continue.nem"
	even
ArtNem_TailsLife:		BINCLUDE	"art/nemesis/Tails life counter.nem"
	even
ArtNem_MiniTails:		BINCLUDE	"art/nemesis/Tails continue.nem"
	even

;---------------------------------------------------------------------------------------
; Menu Assets
;---------------------------------------------------------------------------------------
ArtNem_FontStuff:		BINCLUDE	"art/nemesis/Standard font.nem"
	even
ArtNem_1P2PWins:		BINCLUDE	"art/nemesis/1P and 2P wins text from 2P mode.nem"
	even
MapEng_MenuBack:		BINCLUDE	"mappings/misc/Sonic and Miles animated background.eni"
	even
ArtUnc_MenuBack:		BINCLUDE	"art/uncompressed/Sonic and Miles animated background.bin"
	even
ArtNem_TitleCard:		BINCLUDE	"art/nemesis/Title card.nem"
	even
ArtNem_TitleCard2:		BINCLUDE	"art/nemesis/Font using large broken letters.nem"
	even
ArtNem_MenuBox:			BINCLUDE	"art/nemesis/A menu box with a shadow.nem"
	even
ArtNem_LevelSelectPics:		BINCLUDE	"art/nemesis/Pictures in level preview box from level select.nem"
	even
ArtNem_ResultsText:		BINCLUDE	"art/nemesis/End of level results text.nem" ; Text for Sonic or Tails Got Through Act and Bonus/Perfect
	even
ArtNem_SpecialStageResults:	BINCLUDE	"art/nemesis/Special stage results screen art and some emeralds.nem"
	even
ArtNem_Perfect:			BINCLUDE	"art/nemesis/Perfect text.nem"
	even

;---------------------------------------------------------------------------------------
; Small Animal Assets
;---------------------------------------------------------------------------------------
ArtNem_Flicky:			BINCLUDE	"art/nemesis/Flicky.nem"
	even
ArtNem_Squirrel:		BINCLUDE	"art/nemesis/Squirrel.nem" ; Ricky
	even
ArtNem_Mouse:			BINCLUDE	"art/nemesis/Mouse.nem"    ; Micky
	even
ArtNem_Chicken:			BINCLUDE	"art/nemesis/Chicken.nem"  ; Cucky
	even
ArtNem_Monkey:			BINCLUDE	"art/nemesis/Monkey.nem"   ; Wocky
	even
ArtNem_Eagle:			BINCLUDE	"art/nemesis/Eagle.nem"    ; Locky
	even
ArtNem_Pig:			BINCLUDE	"art/nemesis/Pig.nem"      ; Picky
	even
ArtNem_Seal:			BINCLUDE	"art/nemesis/Seal.nem"     ; Rocky
	even
ArtNem_Penguin:			BINCLUDE	"art/nemesis/Penguin.nem"  ; Pecky
	even
ArtNem_Turtle:			BINCLUDE	"art/nemesis/Turtle.nem"   ; Tocky
	even
ArtNem_Bear:			BINCLUDE	"art/nemesis/Bear.nem"     ; Becky
	even
ArtNem_Rabbit:			BINCLUDE	"art/nemesis/Rabbit.nem"   ; Pocky
	even

;---------------------------------------------------------------------------------------
; WFZ Assets
;---------------------------------------------------------------------------------------
ArtNem_WfzSwitch:		BINCLUDE	"art/nemesis/WFZ boss chamber switch.nem" ; Rivet thing that you bust to get inside the ship
	even
ArtNem_BreakPanels:		BINCLUDE	"art/nemesis/Breakaway panels from WFZ.nem"
	even

;---------------------------------------------------------------------------------------
; OOZ Assets
;---------------------------------------------------------------------------------------
ArtNem_SpikyThing:		BINCLUDE	"art/nemesis/Spiked ball from OOZ.nem"
	even
ArtNem_BurnerLid:		BINCLUDE	"art/nemesis/Burner Platform from OOZ.nem"
	even
ArtNem_StripedBlocksVert:	BINCLUDE	"art/nemesis/Striped blocks from CPZ.nem"
	even
ArtNem_Oilfall:			BINCLUDE	"art/nemesis/Cascading oil hitting oil from OOZ.nem"
	even
ArtNem_Oilfall2:		BINCLUDE	"art/nemesis/Cascading oil from OOZ.nem"
	even
ArtNem_BallThing:		BINCLUDE	"art/nemesis/Ball on spring from OOZ (beta holdovers).nem"
	even
ArtNem_LaunchBall:		BINCLUDE	"art/nemesis/Transporter ball from OOZ.nem"
	even
ArtNem_OOZPlatform:		BINCLUDE	"art/nemesis/OOZ collapsing platform.nem"
	even
ArtNem_PushSpring:		BINCLUDE	"art/nemesis/Push spring from OOZ.nem"
	even
ArtNem_OOZSwingPlat:		BINCLUDE	"art/nemesis/Swinging platform from OOZ.nem"
	even
ArtNem_StripedBlocksHoriz:	BINCLUDE	"art/nemesis/4 stripy blocks from OOZ.nem"
	even
ArtNem_OOZElevator:		BINCLUDE	"art/nemesis/Rising platform from OOZ.nem"
	even
ArtNem_OOZFanHoriz:		BINCLUDE	"art/nemesis/Fan from OOZ.nem"
	even
ArtNem_OOZBurn:			BINCLUDE	"art/nemesis/Green flame from OOZ burners.nem"
	even

;---------------------------------------------------------------------------------------
; CNZ Assets
;---------------------------------------------------------------------------------------
ArtNem_CNZSnake:		BINCLUDE	"art/nemesis/Caterpiller platforms from CNZ.nem" ; Patterns for appearing and disappearing string of platforms
	even
ArtNem_CNZBonusSpike:		BINCLUDE	"art/nemesis/Spikey ball from CNZ slots.nem"
	even
ArtNem_BigMovingBlock:		BINCLUDE	"art/nemesis/Moving block from CNZ and CPZ.nem"
	even
ArtNem_CNZElevator:		BINCLUDE	"art/nemesis/CNZ elevator.nem"
	even
ArtNem_CNZCage:			BINCLUDE	"art/nemesis/CNZ slot machine bars.nem"
	even
ArtNem_CNZHexBumper:		BINCLUDE	"art/nemesis/Hexagonal bumper from CNZ.nem"
	even
ArtNem_CNZRoundBumper:		BINCLUDE	"art/nemesis/Round bumper from CNZ.nem"
	even
ArtNem_CNZDiagPlunger:		BINCLUDE	"art/nemesis/Diagonal impulse spring from CNZ.nem"
	even
ArtNem_CNZVertPlunger:		BINCLUDE	"art/nemesis/Vertical impulse spring.nem"
	even
ArtNem_CNZMiniBumper:		BINCLUDE	"art/nemesis/Drop target from CNZ.nem" ; Weird blocks that you hit 3 times to get rid of
	even
ArtNem_CNZFlipper:		BINCLUDE	"art/nemesis/Flippers.nem"
	even

;---------------------------------------------------------------------------------------
; CPZ Assets
;---------------------------------------------------------------------------------------
ArtNem_CPZElevator:		BINCLUDE	"art/nemesis/Large moving platform from CPZ.nem"
	even
ArtNem_WaterSurface:		BINCLUDE	"art/nemesis/Top of water in HPZ and CNZ.nem"
	even
ArtNem_CPZBooster:		BINCLUDE	"art/nemesis/Speed booster from CPZ.nem"
	even
ArtNem_CPZDroplet:		BINCLUDE	"art/nemesis/CPZ worm enemy.nem"
	even
ArtNem_CPZMetalThings:		BINCLUDE	"art/nemesis/CPZ metal things.nem" ; Girder, cylinders
	even
ArtNem_CPZMetalBlock:		BINCLUDE	"art/nemesis/CPZ large moving platform blocks.nem"
	even
ArtNem_ConstructionStripes:	BINCLUDE	"art/nemesis/Stripy blocks from CPZ.nem"
	even
ArtNem_CPZAnimatedBits:		BINCLUDE	"art/nemesis/Small yellow moving platform from CPZ.nem"
	even
ArtNem_CPZStairBlock:		BINCLUDE	"art/nemesis/Moving block from CPZ.nem"
	even
ArtNem_CPZTubeSpring:		BINCLUDE	"art/nemesis/CPZ spintube exit cover.nem"
	even

;---------------------------------------------------------------------------------------
; ARZ Assets
;---------------------------------------------------------------------------------------
ArtNem_WaterSurface2:		BINCLUDE	"art/nemesis/Top of water in ARZ.nem"
	even
ArtNem_Leaves:			BINCLUDE	"art/nemesis/Leaves in ARZ.nem"
	even
ArtNem_ArrowAndShooter:		BINCLUDE	"art/nemesis/Arrow shooter and arrow from ARZ.nem"
	even
ArtNem_ARZBarrierThing:		BINCLUDE	"art/nemesis/One way barrier from ARZ.nem" ; Unused
	even

;---------------------------------------------------------------------------------------
; EHZ/OOZ Badnik Assets
;---------------------------------------------------------------------------------------
; These Badniks being grouped together here is unusual, but can be explained by two things:
; 1. This is where all Badnik tiles were kept in the earliest prototypes.
; 2. These are the only Badniks left from those prototypes.
ArtNem_Buzzer:			BINCLUDE	"art/nemesis/Buzzer enemy.nem"
	even
ArtNem_Octus:			BINCLUDE	"art/nemesis/Octopus badnik from OOZ.nem"
	even
ArtNem_Aquis:			BINCLUDE	"art/nemesis/Seahorse from OOZ.nem"
	even
ArtNem_Masher:			BINCLUDE	"art/nemesis/EHZ Pirahna badnik.nem"
	even

;---------------------------------------------------------------------------------------
; Boss Assets
;---------------------------------------------------------------------------------------
ArtNem_Eggpod:			BINCLUDE	"art/nemesis/Eggpod.nem" ; Robotnik's main ship
	even
ArtNem_CPZBoss:			BINCLUDE	"art/nemesis/CPZ boss.nem"
	even
ArtNem_FieryExplosion:		BINCLUDE	"art/nemesis/Large explosion.nem"
	even
ArtNem_EggpodJets:		BINCLUDE	"art/nemesis/Horizontal jet.nem"
	even
ArtNem_BossSmoke:		BINCLUDE	"art/nemesis/Smoke trail from CPZ and HTZ bosses.nem"
	even
ArtNem_EHZBoss:			BINCLUDE	"art/nemesis/EHZ boss.nem"
	even
ArtNem_EggChoppers:		BINCLUDE	"art/nemesis/Chopper blades for EHZ boss.nem"
	even
ArtNem_HTZBoss:			BINCLUDE	"art/nemesis/HTZ boss.nem"
	even
ArtNem_ARZBoss:			BINCLUDE	"art/nemesis/ARZ boss.nem"
	even
ArtNem_MCZBoss:			BINCLUDE	"art/nemesis/MCZ boss.nem"
	even
ArtNem_CNZBoss:			BINCLUDE	"art/nemesis/CNZ boss.nem"
	even
ArtNem_OOZBoss:			BINCLUDE	"art/nemesis/OOZ boss.nem"
	even
ArtNem_MTZBoss:			BINCLUDE	"art/nemesis/MTZ boss.nem"
	even
ArtUnc_FallingRocks:		BINCLUDE	"art/uncompressed/Falling rocks and stalactites from MCZ.bin"
	even

;---------------------------------------------------------------------------------------
; ARZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Whisp:			BINCLUDE	"art/nemesis/Blowfly from ARZ.nem"
	even
ArtNem_Grounder:		BINCLUDE	"art/nemesis/Grounder from ARZ.nem"
	even
ArtNem_ChopChop:		BINCLUDE	"art/nemesis/Shark from ARZ.nem"
	even

;---------------------------------------------------------------------------------------
; HTZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Rexon:			BINCLUDE	"art/nemesis/Rexxon (lava snake) from HTZ.nem"
	even
ArtNem_Spiker:			BINCLUDE	"art/nemesis/Driller badnik from HTZ.nem"
	even

;---------------------------------------------------------------------------------------
; SCZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Nebula:			BINCLUDE	"art/nemesis/Bomber badnik from SCZ.nem"
	even
ArtNem_Turtloid:		BINCLUDE	"art/nemesis/Turtle badnik from SCZ.nem"
	even

;---------------------------------------------------------------------------------------
; EHZ Badnik Assets (again)
;---------------------------------------------------------------------------------------
ArtNem_Coconuts:		BINCLUDE	"art/nemesis/Coconuts badnik from EHZ.nem"
	even

;---------------------------------------------------------------------------------------
; MCZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Crawlton:		BINCLUDE	"art/nemesis/Snake badnik from MCZ.nem"
	even
ArtNem_Flasher:			BINCLUDE	"art/nemesis/Firefly from MCZ.nem"
	even

;---------------------------------------------------------------------------------------
; MTZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_MtzMantis:		BINCLUDE	"art/nemesis/Praying mantis badnik from MTZ.nem"
	even
ArtNem_Shellcracker:		BINCLUDE	"art/nemesis/Shellcracker badnik from MTZ.nem"
	even
ArtNem_MtzSupernova:		BINCLUDE	"art/nemesis/Exploding star badnik from MTZ.nem"
	even

;---------------------------------------------------------------------------------------
; CPZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Spiny:			BINCLUDE	"art/nemesis/Weird crawling badnik from CPZ.nem"
	even
ArtNem_Grabber:			BINCLUDE	"art/nemesis/Spider badnik from CPZ.nem"
	even

;---------------------------------------------------------------------------------------
; WFZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_WfzScratch:		BINCLUDE	"art/nemesis/Scratch from WFZ.nem" ; Chicken badnik
	even
ArtNem_Balkrie:			BINCLUDE	"art/nemesis/Balkrie (jet badnik) from SCZ.nem" ; This SCZ badnik is here for some reason.
	even

;---------------------------------------------------------------------------------------
; WFZ/DEZ Assets
; It seems that these were haphazardly thrown together instead of neatly-split like the
; other zones' assets.
;---------------------------------------------------------------------------------------
ArtNem_SilverSonic:		BINCLUDE	"art/nemesis/Silver Sonic.nem"
	even
ArtNem_Tornado:			BINCLUDE	"art/nemesis/The Tornado.nem" ; Sonic's plane.
	even
ArtNem_WfzWallTurret:		BINCLUDE	"art/nemesis/Wall turret from WFZ.nem"
	even
ArtNem_WfzHook:			BINCLUDE	"art/nemesis/Hook on chain from WFZ.nem"
	even
ArtNem_WfzGunPlatform:		BINCLUDE	"art/nemesis/Retracting platform from WFZ.nem"
	even
ArtNem_WfzConveyorBeltWheel:	BINCLUDE	"art/nemesis/Wheel for belt in WFZ.nem"
	even
ArtNem_WfzFloatingPlatform:	BINCLUDE	"art/nemesis/Moving platform from WFZ.nem"
	even
ArtNem_WfzVrtclLazer:		BINCLUDE	"art/nemesis/Unused vertical laser in WFZ.nem"
	even
ArtNem_Clouds:			BINCLUDE	"art/nemesis/Clouds.nem"
	even
ArtNem_WfzHrzntlLazer:		BINCLUDE	"art/nemesis/Red horizontal laser from WFZ.nem"
	even
ArtNem_WfzLaunchCatapult:	BINCLUDE	"art/nemesis/Catapult that shoots Sonic to the side from WFZ.nem"
	even
ArtNem_WfzBeltPlatform:		BINCLUDE	"art/nemesis/Platform on belt in WFZ.nem"
	even
ArtNem_WfzUnusedBadnik:		BINCLUDE	"art/nemesis/Unused badnik from WFZ.nem" ; This is not grouped with the zone's badniks, suggesting that it's not a badnik at all.
	even
ArtNem_WfzVrtclPrpllr:		BINCLUDE	"art/nemesis/Vertical spinning blades in WFZ.nem"
	even
ArtNem_WfzHrzntlPrpllr:		BINCLUDE	"art/nemesis/Horizontal spinning blades in WFZ.nem"
	even
ArtNem_WfzTiltPlatforms:	BINCLUDE	"art/nemesis/Tilting plaforms in WFZ.nem"
	even
ArtNem_WfzThrust:		BINCLUDE	"art/nemesis/Thrust from Robotnik's getaway ship in WFZ.nem"
	even
ArtNem_WFZBoss:			BINCLUDE	"art/nemesis/WFZ boss.nem"
	even
ArtNem_RobotnikUpper:		BINCLUDE	"art/nemesis/Robotnik's head.nem"
	even
ArtNem_RobotnikRunning:		BINCLUDE	"art/nemesis/Robotnik.nem"
	even
ArtNem_RobotnikLower:		BINCLUDE	"art/nemesis/Robotnik's lower half.nem"
	even
ArtNem_DEZWindow:		BINCLUDE	"art/nemesis/Window in back that Robotnik looks through in DEZ.nem"
	even
ArtNem_DEZBoss:			BINCLUDE	"art/nemesis/Eggrobo.nem"
	even
; This last-minute badnik addition was mistakenly included with the WFZ/DEZ assets instead of in its own 'CNZ Badnik Assets' section.
ArtNem_Crawl:			BINCLUDE	"art/nemesis/Bouncer badnik from CNZ.nem"
	even
ArtNem_TornadoThruster:		BINCLUDE	"art/nemesis/Rocket thruster for Tornado.nem"
	even

;---------------------------------------------------------------------------------------
; Ending Assets
;---------------------------------------------------------------------------------------
MapEng_Ending1:			BINCLUDE	"mappings/misc/End of game sequence frame 1.eni"
	even
MapEng_Ending2:			BINCLUDE	"mappings/misc/End of game sequence frame 2.eni"
	even
MapEng_Ending3:			BINCLUDE	"mappings/misc/End of game sequence frame 3.eni"
	even
MapEng_Ending4:			BINCLUDE	"mappings/misc/End of game sequence frame 4.eni"
	even
MapEng_EndingTailsPlane:	BINCLUDE	"mappings/misc/Closeup of Tails flying plane in ending sequence.eni"
	even
MapEng_EndingSonicPlane:	BINCLUDE	"mappings/misc/Closeup of Sonic flying plane in ending sequence.eni"
	even

; Strange unused mappings (duplicates of MapEng_EndGameLogo)
    rept 9
				BINCLUDE	"mappings/misc/Sonic 2 end of game logo.eni"
	even
    endm

ArtNem_EndingPics:		BINCLUDE	"art/nemesis/Movie sequence at end of game.nem"
	even
ArtNem_EndingFinalTornado:	BINCLUDE	"art/nemesis/Final image of Tornado with it and Sonic facing screen.nem"
	even
ArtNem_EndingMiniTornado:	BINCLUDE	"art/nemesis/Small pictures of Tornado in final ending sequence.nem"
	even
ArtNem_EndingSonic:		BINCLUDE	"art/nemesis/Small pictures of Sonic and final image of Sonic.nem"
	even
ArtNem_EndingSuperSonic:	BINCLUDE	"art/nemesis/Small pictures of Sonic and final image of Sonic in Super Sonic mode.nem"
	even
ArtNem_EndingTails:		BINCLUDE	"art/nemesis/Final image of Tails.nem"
	even
ArtNem_EndingTitle:		BINCLUDE	"art/nemesis/Sonic the Hedgehog 2 image at end of credits.nem"
	even


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; LEVEL ART AND BLOCK MAPPINGS (16x16 and 128x128)
;
; #define BLOCK_TBL_LEN  // table length unknown
; #define BIGBLOCK_TBL_LEN // table length unknown
; typedef uint16_t uword
;
; struct blockMapElement {
;  uword unk : 5;    // u
;  uword patternIndex : 11; };  // i
; // uuuu uiii iiii iiii
;
; blockMapElement (*blockMapTable)[BLOCK_TBL_LEN][4] = 0xFFFF9000
;
; struct bigBlockMapElement {
;  uword : 4
;  uword blockMapIndex : 12; };  //I
; // 0000 IIII IIII IIII
;
; bigBlockMapElement (*bigBlockMapTable)[BIGBLOCK_TBL_LEN][64] = 0xFFFF0000
;
; /*
; This data determines how the level blocks will be constructed graphically. There are
; two kinds of block mappings: 16x16 and 128x128.
;
; 16x16 blocks are made up of four cells arranged in a square (thus, 16x16 pixels).
; Two bytes are used to define each cell, so the block is 8 bytes long. It can be
; represented by the bitmap blockMapElement, of which the members are:
;
; unk
;  These bits have to do with pattern orientation. I do not know their exact
;  meaning.
; patternIndex
;  The pattern's address divided by $20. Otherwise said: an index into the
;  pattern array.
;
; Each mapping can be expressed as an array of four blockMapElements, while the
; whole table is expressed as a two-dimensional array of blockMapElements (blockMapTable).
; The maps are read in left-to-right, top-to-bottom order.
;
; 128x128 maps are basically lists of indices into blockMapTable. The levels are built
; out of these "big blocks", rather than the "small" 16x16 blocks. bigBlockMapTable is,
; predictably, the table of big block mappings.
; Each big block is 8 16x16 blocks, or 16 cells, square. This produces a total of 16
; blocks or 64 cells.
; As noted earlier, each element of the table provides 'i' for blockMapTable[i][j].
; */

; All of these are compressed in the Kosinski format.

BM16_EHZ:	BINCLUDE	"mappings/16x16/EHZ.kos"
ArtKos_EHZ:	BINCLUDE	"art/kosinski/EHZ_HTZ.kos"
BM16_HTZ:	BINCLUDE	"mappings/16x16/HTZ.kos"
ArtKos_HTZ:	BINCLUDE	"art/kosinski/HTZ_Supp.kos" ; HTZ pattern suppliment to EHZ level patterns
BM128_EHZ:	BINCLUDE	"mappings/128x128/EHZ_HTZ.kos"

BM16_MTZ:	BINCLUDE	"mappings/16x16/MTZ.kos"
ArtKos_MTZ:	BINCLUDE	"art/kosinski/MTZ.kos"
BM128_MTZ:	BINCLUDE	"mappings/128x128/MTZ.kos"

BM16_HPZ:	;BINCLUDE	"mappings/16x16/HPZ.kos"
ArtKos_HPZ:	;BINCLUDE	"art/kosinski/HPZ.kos"
BM128_HPZ:	;BINCLUDE	"mappings/128x128/HPZ.kos"

BM16_OOZ:	BINCLUDE	"mappings/16x16/OOZ.kos"
ArtKos_OOZ:	BINCLUDE	"art/kosinski/OOZ.kos"
BM128_OOZ:	BINCLUDE	"mappings/128x128/OOZ.kos"

BM16_MCZ:	BINCLUDE	"mappings/16x16/MCZ.kos"
ArtKos_MCZ:	BINCLUDE	"art/kosinski/MCZ.kos"
BM128_MCZ:	BINCLUDE	"mappings/128x128/MCZ.kos"

BM16_CNZ:	BINCLUDE	"mappings/16x16/CNZ.kos"
ArtKos_CNZ:	BINCLUDE	"art/kosinski/CNZ.kos"
BM128_CNZ:	BINCLUDE	"mappings/128x128/CNZ.kos"

BM16_CPZ:	BINCLUDE	"mappings/16x16/CPZ_DEZ.kos"
ArtKos_CPZ:	BINCLUDE	"art/kosinski/CPZ_DEZ.kos"
BM128_CPZ:	BINCLUDE	"mappings/128x128/CPZ_DEZ.kos"

; This file contains $320 blocks, overflowing the 'Block_table' buffer. This causes
; 'TempArray_LayerDef' to be overwritten with (empty) block data.
; If only 'fixBugs' could fix this...
BM16_ARZ:	BINCLUDE	"mappings/16x16/ARZ.kos"
ArtKos_ARZ:	BINCLUDE	"art/kosinski/ARZ.kos"
BM128_ARZ:	BINCLUDE	"mappings/128x128/ARZ.kos"

BM16_WFZ:	BINCLUDE	"mappings/16x16/WFZ_SCZ.kos"
ArtKos_SCZ:	BINCLUDE	"art/kosinski/WFZ_SCZ.kos"
ArtKos_WFZ:	BINCLUDE	"art/kosinski/WFZ_Supp.kos" ; WFZ pattern suppliment to SCZ tiles
BM128_WFZ:	BINCLUDE	"mappings/128x128/WFZ_SCZ.kos"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;-----------------------------------------------------------------------------------
; Special Stage Assets
;-----------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------
; Exit curve + slope up
;-----------------------------------------------------------------------------------
MapSpec_Rise1:		BINCLUDE	"mappings/special stage/Slope up - Frame 1.bin"
MapSpec_Rise2:		BINCLUDE	"mappings/special stage/Slope up - Frame 2.bin"
MapSpec_Rise3:		BINCLUDE	"mappings/special stage/Slope up - Frame 3.bin"
MapSpec_Rise4:		BINCLUDE	"mappings/special stage/Slope up - Frame 4.bin"
MapSpec_Rise5:		BINCLUDE	"mappings/special stage/Slope up - Frame 5.bin"
MapSpec_Rise6:		BINCLUDE	"mappings/special stage/Slope up - Frame 6.bin"
MapSpec_Rise7:		BINCLUDE	"mappings/special stage/Slope up - Frame 7.bin"
MapSpec_Rise8:		BINCLUDE	"mappings/special stage/Slope up - Frame 8.bin"
MapSpec_Rise9:		BINCLUDE	"mappings/special stage/Slope up - Frame 9.bin"
MapSpec_Rise10:		BINCLUDE	"mappings/special stage/Slope up - Frame 10.bin"
MapSpec_Rise11:		BINCLUDE	"mappings/special stage/Slope up - Frame 11.bin"
MapSpec_Rise12:		BINCLUDE	"mappings/special stage/Slope up - Frame 12.bin"
MapSpec_Rise13:		BINCLUDE	"mappings/special stage/Slope up - Frame 13.bin"
MapSpec_Rise14:		BINCLUDE	"mappings/special stage/Slope up - Frame 14.bin"
MapSpec_Rise15:		BINCLUDE	"mappings/special stage/Slope up - Frame 15.bin"
MapSpec_Rise16:		BINCLUDE	"mappings/special stage/Slope up - Frame 16.bin"
MapSpec_Rise17:		BINCLUDE	"mappings/special stage/Slope up - Frame 17.bin"

;-----------------------------------------------------------------------------------
; Straight path
;-----------------------------------------------------------------------------------
MapSpec_Straight1:	BINCLUDE	"mappings/special stage/Straight path - Frame 1.bin"
MapSpec_Straight2:	BINCLUDE	"mappings/special stage/Straight path - Frame 2.bin"
MapSpec_Straight3:	BINCLUDE	"mappings/special stage/Straight path - Frame 3.bin"
MapSpec_Straight4:	BINCLUDE	"mappings/special stage/Straight path - Frame 4.bin"

;-----------------------------------------------------------------------------------
; Exit curve + slope down
;-----------------------------------------------------------------------------------
MapSpec_Drop1:		BINCLUDE	"mappings/special stage/Slope down - Frame 1.bin"
MapSpec_Drop2:		BINCLUDE	"mappings/special stage/Slope down - Frame 2.bin"
MapSpec_Drop3:		BINCLUDE	"mappings/special stage/Slope down - Frame 3.bin"
MapSpec_Drop4:		BINCLUDE	"mappings/special stage/Slope down - Frame 4.bin"
MapSpec_Drop5:		BINCLUDE	"mappings/special stage/Slope down - Frame 5.bin"
MapSpec_Drop6:		BINCLUDE	"mappings/special stage/Slope down - Frame 6.bin"
MapSpec_Drop7:		BINCLUDE	"mappings/special stage/Slope down - Frame 7.bin"
MapSpec_Drop8:		BINCLUDE	"mappings/special stage/Slope down - Frame 8.bin"
MapSpec_Drop9:		BINCLUDE	"mappings/special stage/Slope down - Frame 9.bin"
MapSpec_Drop10:		BINCLUDE	"mappings/special stage/Slope down - Frame 10.bin"
MapSpec_Drop11:		BINCLUDE	"mappings/special stage/Slope down - Frame 11.bin"
MapSpec_Drop12:		BINCLUDE	"mappings/special stage/Slope down - Frame 12.bin"
MapSpec_Drop13:		BINCLUDE	"mappings/special stage/Slope down - Frame 13.bin"
MapSpec_Drop14:		BINCLUDE	"mappings/special stage/Slope down - Frame 14.bin"
MapSpec_Drop15:		BINCLUDE	"mappings/special stage/Slope down - Frame 15.bin"
MapSpec_Drop16:		BINCLUDE	"mappings/special stage/Slope down - Frame 16.bin"
MapSpec_Drop17:		BINCLUDE	"mappings/special stage/Slope down - Frame 17.bin"

;-----------------------------------------------------------------------------------
; Curved path
;-----------------------------------------------------------------------------------
MapSpec_Turning1:	BINCLUDE	"mappings/special stage/Curve right - Frame 1.bin"
MapSpec_Turning2:	BINCLUDE	"mappings/special stage/Curve right - Frame 2.bin"
MapSpec_Turning3:	BINCLUDE	"mappings/special stage/Curve right - Frame 3.bin"
MapSpec_Turning4:	BINCLUDE	"mappings/special stage/Curve right - Frame 4.bin"
MapSpec_Turning5:	BINCLUDE	"mappings/special stage/Curve right - Frame 5.bin"
MapSpec_Turning6:	BINCLUDE	"mappings/special stage/Curve right - Frame 6.bin"

;-----------------------------------------------------------------------------------
; Exit curve
;-----------------------------------------------------------------------------------
MapSpec_Unturn1:	BINCLUDE	"mappings/special stage/Curve right - Frame 7.bin"
MapSpec_Unturn2:	BINCLUDE	"mappings/special stage/Curve right - Frame 8.bin"
MapSpec_Unturn3:	BINCLUDE	"mappings/special stage/Curve right - Frame 9.bin"
MapSpec_Unturn4:	BINCLUDE	"mappings/special stage/Curve right - Frame 10.bin"
MapSpec_Unturn5:	BINCLUDE	"mappings/special stage/Curve right - Frame 11.bin"

;-----------------------------------------------------------------------------------
; Enter curve
;-----------------------------------------------------------------------------------
MapSpec_Turn1:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 1.bin"
MapSpec_Turn2:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 2.bin"
MapSpec_Turn3:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 3.bin"
MapSpec_Turn4:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 4.bin"
MapSpec_Turn5:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 5.bin"
MapSpec_Turn6:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 6.bin"
MapSpec_Turn7:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 7.bin"

;--------------------------------------------------------------------------------------
; Special stage level patterns
; Note: Only one line of each tile is stored in this archive. The other 7 lines are
;  the same as this one line, so to get the full tiles, each line needs to be
;  duplicated 7 times over.					; ArtKoz_DCA38:
;--------------------------------------------------------------------------------------
ArtKos_Special:			BINCLUDE	"art/kosinski/SpecStag.kos"
	even

ArtNem_SpecialBack:		BINCLUDE	"art/nemesis/Background art for special stage.nem"
	even
MapEng_SpecialBack:		BINCLUDE	"mappings/misc/Main background mappings for special stage.eni"
	even
MapEng_SpecialBackBottom:	BINCLUDE	"mappings/misc/Lower background mappings for special stage.eni"
	even
ArtNem_SpecialHUD:		BINCLUDE	"art/nemesis/Sonic and Miles number text from special stage.nem"
	even
ArtNem_SpecialStart:		BINCLUDE	"art/nemesis/Start text from special stage.nem" ; Also includes checkered flag
	even
ArtNem_SpecialStars:		BINCLUDE	"art/nemesis/Stars in special stage.nem"
	even
ArtNem_SpecialPlayerVSPlayer:	BINCLUDE	"art/nemesis/Special stage Player VS Player text.nem"
	even
ArtNem_SpecialRings:		BINCLUDE	"art/nemesis/Special stage ring art.nem"
	even
ArtNem_SpecialFlatShadow:	BINCLUDE	"art/nemesis/Horizontal shadow from special stage.nem"
	even
ArtNem_SpecialDiagShadow:	BINCLUDE	"art/nemesis/Diagonal shadow from special stage.nem"
	even
ArtNem_SpecialSideShadow:	BINCLUDE	"art/nemesis/Vertical shadow from special stage.nem"
	even
ArtNem_SpecialExplosion:	BINCLUDE	"art/nemesis/Explosion from special stage.nem"
	even
ArtNem_SpecialBomb:		BINCLUDE	"art/nemesis/Bomb from special stage.nem"
	even
ArtNem_SpecialEmerald:		BINCLUDE	"art/nemesis/Emerald from special stage.nem"
	even
ArtNem_SpecialMessages:		BINCLUDE	"art/nemesis/Special stage messages and icons.nem"
	even
ArtNem_SpecialSonicAndTails:	BINCLUDE	"art/nemesis/Sonic and Tails animation frames in special stage.nem" ; [fixBugs] In this file, Tails' arms are tan instead of orange.
	even
ArtNem_SpecialTailsText:	BINCLUDE	"art/nemesis/Tails text patterns from special stage.nem"
	even
MiscKoz_SpecialPerspective:	BINCLUDE	"misc/Special stage object perspective data.kos"
	even
MiscNem_SpecialLevelLayout:	BINCLUDE	"misc/Special stage level layouts.nem"
	even
MiscKoz_SpecialObjectLocations:	BINCLUDE	"misc/Special stage object location lists.kos"
	even

;--------------------------------------------------------------------------------------
; Filler (free space) (unnecessary; could be replaced with "even")
;--------------------------------------------------------------------------------------
	align $100




;--------------------------------------------------------------------------------------
; Offset index of ring locations
;  The first commented number on each line is an array index; the second is the
;  associated zone.
;--------------------------------------------------------------------------------------
Off_Rings: zoneOrderedOffsetTable 2,2
	; EHZ
	zoneOffsetTableEntry.w  Rings_EHZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_EHZ_2	; Act 2
	; Zone 1
	zoneOffsetTableEntry.w  Rings_Lev1_1	; Act 1
	zoneOffsetTableEntry.w  Rings_Lev1_2	; Act 2
	; WZ
	zoneOffsetTableEntry.w  Rings_WZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_WZ_2	; Act 2
	; Zone 3
	zoneOffsetTableEntry.w  Rings_Lev3_1	; Act 1
	zoneOffsetTableEntry.w  Rings_Lev3_2	; Act 2
	; MTZ
	zoneOffsetTableEntry.w  Rings_MTZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_MTZ_2	; Act 2
	; MTZ
	zoneOffsetTableEntry.w  Rings_MTZ_3	; Act 3
	zoneOffsetTableEntry.w  Rings_MTZ_4	; Act 4
	; WFZ
	zoneOffsetTableEntry.w  Rings_WFZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_WFZ_2	; Act 2
	; HTZ
	zoneOffsetTableEntry.w  Rings_HTZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_HTZ_2	; Act 2
	; HPZ
	zoneOffsetTableEntry.w  Rings_HPZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_HPZ_2	; Act 2
	; Zone 9
	zoneOffsetTableEntry.w  Rings_Lev9_1	; Act 1
	zoneOffsetTableEntry.w  Rings_Lev9_2	; Act 2
	; OOZ
	zoneOffsetTableEntry.w  Rings_OOZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_OOZ_2	; Act 2
	; MCZ
	zoneOffsetTableEntry.w  Rings_MCZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_MCZ_2	; Act 2
	; CNZ
	zoneOffsetTableEntry.w  Rings_CNZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_CNZ_2	; Act 2
	; CPZ
	zoneOffsetTableEntry.w  Rings_CPZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_CPZ_2	; Act 2
	; DEZ
	zoneOffsetTableEntry.w  Rings_DEZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_DEZ_2	; Act 2
	; ARZ
	zoneOffsetTableEntry.w  Rings_ARZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_ARZ_2	; Act 2
	; SCZ
	zoneOffsetTableEntry.w  Rings_SCZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_SCZ_2	; Act 2
    zoneTableEnd

Rings_EHZ_1:	BINCLUDE	"level/rings/EHZ_1.bin"
Rings_EHZ_2:	BINCLUDE	"level/rings/EHZ_2.bin"
Rings_Lev1_1:	BINCLUDE	"level/rings/01_1.bin"
Rings_Lev1_2:	BINCLUDE	"level/rings/01_2.bin"
Rings_WZ_1:	BINCLUDE	"level/rings/WZ_1.bin"
Rings_WZ_2:	BINCLUDE	"level/rings/WZ_2.bin"
Rings_Lev3_1:	BINCLUDE	"level/rings/03_1.bin"
Rings_Lev3_2:	BINCLUDE	"level/rings/03_2.bin"
Rings_MTZ_1:	BINCLUDE	"level/rings/MTZ_1.bin"
Rings_MTZ_2:	BINCLUDE	"level/rings/MTZ_2.bin"
Rings_MTZ_3:	BINCLUDE	"level/rings/MTZ_3.bin"
Rings_MTZ_4:	BINCLUDE	"level/rings/MTZ_4.bin"
Rings_HTZ_1:	BINCLUDE	"level/rings/HTZ_1.bin"
Rings_HTZ_2:	BINCLUDE	"level/rings/HTZ_2.bin"
Rings_HPZ_1:	BINCLUDE	"level/rings/HPZ_1.bin"
Rings_HPZ_2:	BINCLUDE	"level/rings/HPZ_2.bin"
Rings_Lev9_1:	BINCLUDE	"level/rings/09_1.bin"
Rings_Lev9_2:	BINCLUDE	"level/rings/09_2.bin"
Rings_OOZ_1:	BINCLUDE	"level/rings/OOZ_1.bin"
Rings_OOZ_2:	BINCLUDE	"level/rings/OOZ_2.bin"
Rings_MCZ_1:	BINCLUDE	"level/rings/MCZ_1.bin"
Rings_MCZ_2:	BINCLUDE	"level/rings/MCZ_2.bin"
Rings_CNZ_1:	BINCLUDE	"level/rings/CNZ_1.bin"
Rings_CNZ_2:	BINCLUDE	"level/rings/CNZ_2.bin"
Rings_CPZ_1:	BINCLUDE	"level/rings/CPZ_1.bin"
Rings_CPZ_2:	BINCLUDE	"level/rings/CPZ_2.bin"
Rings_DEZ_1:	BINCLUDE	"level/rings/DEZ_1.bin"
Rings_DEZ_2:	BINCLUDE	"level/rings/DEZ_2.bin"
Rings_WFZ_1:	BINCLUDE	"level/rings/WFZ_1.bin"
Rings_WFZ_2:	BINCLUDE	"level/rings/WFZ_2.bin"
Rings_ARZ_1:	BINCLUDE	"level/rings/ARZ_1.bin"
Rings_ARZ_2:	BINCLUDE	"level/rings/ARZ_2.bin"
Rings_SCZ_1:	BINCLUDE	"level/rings/SCZ_1.bin"
Rings_SCZ_2:	BINCLUDE	"level/rings/SCZ_2.bin"

; --------------------------------------------------------------------------------------
; Filler (free space) (unnecessary; could be replaced with "even")
; --------------------------------------------------------------------------------------
	align $200

; --------------------------------------------------------------------------------------
; Offset index of object locations
; --------------------------------------------------------------------------------------
Off_Objects: zoneOrderedOffsetTable 2,2
	; EHZ
	zoneOffsetTableEntry.w  Objects_EHZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_EHZ_2	; Act 2
	; Zone 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 2
	; WZ
	zoneOffsetTableEntry.w  Objects_Null	; Act 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 2
	; Zone 3
	zoneOffsetTableEntry.w  Objects_Null	; Act 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 2
	; MTZ
	zoneOffsetTableEntry.w  Objects_MTZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_MTZ_2	; Act 2
	; MTZ
	zoneOffsetTableEntry.w  Objects_MTZ_3	; Act 3
	zoneOffsetTableEntry.w  Objects_MTZ_3	; Act 4
	; WFZ
	zoneOffsetTableEntry.w  Objects_WFZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_WFZ_2	; Act 2
	; HTZ
	zoneOffsetTableEntry.w  Objects_HTZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_HTZ_2	; Act 2
	; HPZ
	zoneOffsetTableEntry.w  Objects_HPZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_HPZ_2	; Act 2
	; Zone 9
	zoneOffsetTableEntry.w  Objects_Null	; Act 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 2
	; OOZ
	zoneOffsetTableEntry.w  Objects_OOZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_OOZ_2	; Act 2
	; MCZ
	zoneOffsetTableEntry.w  Objects_MCZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_MCZ_2	; Act 2
	; CNZ
	zoneOffsetTableEntry.w  Objects_CNZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_CNZ_2	; Act 2
	; CPZ
	zoneOffsetTableEntry.w  Objects_CPZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_CPZ_2	; Act 2
	; DEZ
	zoneOffsetTableEntry.w  Objects_DEZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_DEZ_2	; Act 2
	; ARZ
	zoneOffsetTableEntry.w  Objects_ARZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_ARZ_2	; Act 2
	; SCZ
	zoneOffsetTableEntry.w  Objects_SCZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_SCZ_2	; Act 2
    zoneTableEnd

	; These things act as boundaries for the object layout parser, so it doesn't read past the end/beginning of the file
	ObjectLayoutBoundary
Objects_EHZ_1:	BINCLUDE	"level/objects/EHZ_1.bin"
	ObjectLayoutBoundary

    if gameRevision=0
; A collision switcher was improperly placed
Objects_EHZ_2:	BINCLUDE	"level/objects/EHZ_2 (REV00).bin"
    else
Objects_EHZ_2:	BINCLUDE	"level/objects/EHZ_2.bin"
    endif

	ObjectLayoutBoundary
Objects_MTZ_1:	BINCLUDE	"level/objects/MTZ_1.bin"
	ObjectLayoutBoundary
Objects_MTZ_2:	BINCLUDE	"level/objects/MTZ_2.bin"
	ObjectLayoutBoundary
Objects_MTZ_3:	BINCLUDE	"level/objects/MTZ_3.bin"
	ObjectLayoutBoundary

    if gameRevision=0
; The lampposts were bugged: their 'remember state' flags weren't set
Objects_WFZ_1:	BINCLUDE	"level/objects/WFZ_1 (REV00).bin"
    else
Objects_WFZ_1:	BINCLUDE	"level/objects/WFZ_1.bin"
    endif

	ObjectLayoutBoundary
Objects_WFZ_2:	BINCLUDE	"level/objects/WFZ_2.bin"
	ObjectLayoutBoundary
Objects_HTZ_1:	BINCLUDE	"level/objects/HTZ_1.bin"
	ObjectLayoutBoundary
Objects_HTZ_2:	BINCLUDE	"level/objects/HTZ_2.bin"
	ObjectLayoutBoundary
Objects_HPZ_1:	BINCLUDE	"level/objects/HPZ_1.bin"
	ObjectLayoutBoundary
Objects_HPZ_2:	BINCLUDE	"level/objects/HPZ_2.bin"
	ObjectLayoutBoundary
	; Oddly, there's a gap for another layout here
	ObjectLayoutBoundary
Objects_OOZ_1:	BINCLUDE	"level/objects/OOZ_1.bin"
	ObjectLayoutBoundary
Objects_OOZ_2:	BINCLUDE	"level/objects/OOZ_2.bin"
	ObjectLayoutBoundary
Objects_MCZ_1:	BINCLUDE	"level/objects/MCZ_1.bin"
	ObjectLayoutBoundary
Objects_MCZ_2:	BINCLUDE	"level/objects/MCZ_2.bin"
	ObjectLayoutBoundary

    if gameRevision=0
; The signposts are too low, causing them to poke out the bottom of the ground
Objects_CNZ_1:	BINCLUDE	"level/objects/CNZ_1 (REV00).bin"
	ObjectLayoutBoundary
Objects_CNZ_2:	BINCLUDE	"level/objects/CNZ_2 (REV00).bin"
    else
Objects_CNZ_1:	BINCLUDE	"level/objects/CNZ_1.bin"
	ObjectLayoutBoundary
Objects_CNZ_2:	BINCLUDE	"level/objects/CNZ_2.bin"
    endif

	ObjectLayoutBoundary
Objects_CPZ_1:	BINCLUDE	"level/objects/CPZ_1.bin"
	ObjectLayoutBoundary
Objects_CPZ_2:	BINCLUDE	"level/objects/CPZ_2.bin"
	ObjectLayoutBoundary
Objects_DEZ_1:	BINCLUDE	"level/objects/DEZ_1.bin"
	ObjectLayoutBoundary
Objects_DEZ_2:	BINCLUDE	"level/objects/DEZ_2.bin"
	ObjectLayoutBoundary
Objects_ARZ_1:	BINCLUDE	"level/objects/ARZ_1.bin"
	ObjectLayoutBoundary
Objects_ARZ_2:	BINCLUDE	"level/objects/ARZ_2.bin"
	ObjectLayoutBoundary
Objects_SCZ_1:	BINCLUDE	"level/objects/SCZ_1.bin"
	ObjectLayoutBoundary
Objects_SCZ_2:	BINCLUDE	"level/objects/SCZ_2.bin"
	ObjectLayoutBoundary
Objects_Null:
	ObjectLayoutBoundary
	; Another strange space for a layout
	ObjectLayoutBoundary
	; And another
	ObjectLayoutBoundary
	; And another
	ObjectLayoutBoundary

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

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Handles the decompression of the sound driver (Saxman compression, an LZSS variant)
; https://segaretro.org/Saxman_compression

; a4 == start of decompressed data (used for dictionary match offsets)
; a5 == current address of end of decompressed data
; a6 == current address in compressed sound driver
; d3 == length of match minus 1
; d4 == offset into decompressed data of dictionary match
; d5 == number of bytes decompressed so far
; d6 == descriptor field
; d7 == bytes left to decompress

; Interestingly, this appears to be a direct translation of the Z80 version in the sound driver
; (or maybe the Z80 version is a direct translation of this...)

; loc_EC04A:
DecompressSoundDriver:
	lea	Snd_Driver(pc),a6
; WARNING: the build script needs editing if you rename this label
movewZ80CompSize:	move.w	#Snd_Driver_End-Snd_Driver,d7 ; patched (by build.lua) after compression since the exact size can't be known beforehand
	moveq	#0,d6	; The decompressor knows it's run out of descriptor bits when it starts reading 0's in bit 8
	lea	(Z80_RAM).l,a5
	moveq	#0,d5
	lea	(Z80_RAM).l,a4
; loc_EC062:
SaxDec_Loop:
	lsr.w	#1,d6	; Next descriptor bit
	btst	#8,d6	; Check if we've run out of bits
	bne.s	+	; (lsr 'shifts in' 0's)
	jsr	SaxDec_GetByte(pc)
	move.b	d0,d6
	ori.w	#$FF00,d6	; These set bits will disappear from the high byte as the register is shifted
+
	btst	#0,d6
	beq.s	SaxDec_ReadCompressed

; SaxDec_ReadUncompressed:
	jsr	SaxDec_GetByte(pc)
	move.b	d0,(a5)+
	addq.w	#1,d5
	bra.w	SaxDec_Loop
; ---------------------------------------------------------------------------
; loc_EC086:
SaxDec_ReadCompressed:
	jsr	SaxDec_GetByte(pc)
	moveq	#0,d4
	move.b	d0,d4
	jsr	SaxDec_GetByte(pc)
	move.b	d0,d3
	andi.w	#$F,d3
	addq.w	#2,d3	; d3 is the length of the match minus 1
	andi.w	#$F0,d0
	lsl.w	#4,d0
	add.w	d0,d4
	addi.w	#$12,d4
	andi.w	#$FFF,d4	; d4 is the offset into the current $1000-byte window
	; This part is a little tricky. You see, d4 currently contains the low three nibbles of an offset into the decompressed data,
	; where the dictionary match lies. The way the high nibble is decided is first by taking it from d5 - the offset of the end
	; of the decompressed data so far. Then, we see if the resulting offset in d4 is somehow higher than d5.
	; If it is, then it's invalid... *unless* you subtract $1000 from it, in which case it refers to data in the previous $1000 block of bytes.
	; This is all just a really gimmicky way of having an offset with a range of $1000 bytes from the end of the decompressed data.
	; If, however, we cannot subtract $1000 because that would put the pointer before the start of the decompressed data, then
	; this is actually a 'zero-fill' match, which encodes a series of zeroes.
	move.w	d5,d0
	andi.w	#$F000,d0
	add.w	d0,d4
	cmp.w	d4,d5
	bhs.s	SaxDec_IsDictionaryReference
	subi.w	#$1000,d4
	bcc.s	SaxDec_IsDictionaryReference

; SaxDec_IsSequenceOfZeroes:
	add.w	d3,d5
	addq.w	#1,d5

-	move.b	#0,(a5)+
	dbf	d3,-

	bra.w	SaxDec_Loop
; ---------------------------------------------------------------------------
; loc_EC0CC:
SaxDec_IsDictionaryReference:
	add.w	d3,d5
	addq.w	#1,d5

-	move.b	(a4,d4.w),(a5)+
	addq.w	#1,d4
	dbf	d3,-

	bra.w	SaxDec_Loop
; End of function DecompressSoundDriver


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_EC0DE:
SaxDec_GetByte:
	move.b	(a6)+,d0
	subq.w	#1,d7	; Decrement remaining number of bytes
	bne.s	+
	addq.w	#4,sp	; Exit the decompressor by meddling with the stack
+
	rts
; End of function SaxDec_GetByte

; ===========================================================================
; ---------------------------------------------------------------------------
; S2 sound driver (Sound driver compression (slightly modified Saxman))
; ---------------------------------------------------------------------------
; loc_EC0E8:
Snd_Driver:
	save
	include "s2.sounddriver.asm" ; CPU Z80
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

; ------------------------------------------------------------------------------
; Music pointers
; ------------------------------------------------------------------------------
; loc_F8000:
MusicPoint2:	startBank
		music_ptr	Mus_CNZ_2P
		music_ptr	Mus_EHZ
		music_ptr	Mus_MTZ
		music_ptr	Mus_CNZ
		music_ptr	Mus_MCZ
		music_ptr	Mus_MCZ_2P
		music_ptr	Mus_ARZ
		music_ptr	Mus_DEZ
		music_ptr	Mus_SpecStage
		music_ptr	Mus_Options
		music_ptr	Mus_Ending
		music_ptr	Mus_EndBoss
		music_ptr	Mus_CPZ
		music_ptr	Mus_Boss
		music_ptr	Mus_SCZ
		music_ptr	Mus_OOZ
		music_ptr	Mus_WFZ
		music_ptr	Mus_EHZ_2P
		music_ptr	Mus_2PResult
		music_ptr	Mus_SuperSonic
		music_ptr	Mus_HTZ
		music_ptr	Mus_ExtraLife
		music_ptr	Mus_Title
		music_ptr	Mus_EndLevel
		music_ptr	Mus_GameOver
		music_ptr	Mus_Invincible
		music_ptr	Mus_Emerald
		music_ptr	Mus_HPZ
		music_ptr	Mus_Drowning
		music_ptr	Mus_Credits

; loc_F803C:
Mus_HPZ:	include	"sound/music/generated/90 - HPZ.inc"
Mus_Drowning:	include	"sound/music/generated/9F - Drowning.inc"
Mus_Invincible:	include	"sound/music/generated/97 - Invincible.inc"
Mus_CNZ_2P:	include	"sound/music/generated/88 - CNZ 2P.inc"
Mus_EHZ:	include	"sound/music/generated/82 - EHZ.inc"
Mus_MTZ:	include	"sound/music/generated/85 - MTZ.inc"
Mus_CNZ:	include	"sound/music/generated/89 - CNZ.inc"
Mus_MCZ:	include	"sound/music/generated/8B - MCZ.inc"
Mus_MCZ_2P:	include	"sound/music/generated/83 - MCZ 2P.inc"
Mus_ARZ:	include	"sound/music/generated/87 - ARZ.inc"
Mus_DEZ:	include	"sound/music/generated/8A - DEZ.inc"
Mus_SpecStage:	include	"sound/music/generated/92 - Special Stage.inc"
Mus_Options:	include	"sound/music/generated/91 - Options.inc"
Mus_Ending:	include	"sound/music/generated/95 - Ending.inc"
Mus_EndBoss:	include	"sound/music/generated/94 - Final Boss.inc"
Mus_CPZ:	include	"sound/music/generated/8E - CPZ.inc"
Mus_Boss:	include	"sound/music/generated/93 - Boss.inc"
Mus_SCZ:	include	"sound/music/generated/8D - SCZ.inc"
Mus_OOZ:	include	"sound/music/generated/84 - OOZ.inc"
Mus_WFZ:	include	"sound/music/generated/8F - WFZ.inc"
Mus_EHZ_2P:	include	"sound/music/generated/8C - EHZ 2P.inc"
Mus_2PResult:	include	"sound/music/generated/81 - 2 Player Menu.inc"
Mus_SuperSonic:	include	"sound/music/generated/96 - Super Sonic.inc"
Mus_HTZ:	include	"sound/music/generated/86 - HTZ.inc"
Mus_Title:	include	"sound/music/generated/99 - Title Screen.inc"
Mus_EndLevel:	include	"sound/music/generated/9A - End of Act.inc"
Mus_ExtraLife:	include	"sound/music/generated/98 - Extra Life.inc"
Mus_GameOver:	include	"sound/music/generated/9B - Game Over.inc"
Mus_Emerald:	include	"sound/music/generated/9D - Got Emerald.inc"
Mus_Credits:	include	"sound/music/generated/9E - Credits.inc"

; ------------------------------------------------------------------------------------------
; Sound effect pointers
; ------------------------------------------------------------------------------------------
; WARNING the sound driver treats certain sounds specially
; going by the ID of the sound.
; SndID_Ring, SndID_RingLeft, SndID_Gloop, SndID_SpindashRev
; are referenced by the sound driver directly.
; If needed you can change this in s2.sounddriver.asm


; NOTE: the exact order of this list determines the priority of each sound, since it determines the sound's SndID.
;       a sound can get dropped if a higher-priority sound is already playing.
;       see zSFXPriority for the priority allocation itself.
; loc_FEE91: SoundPoint:
SoundIndex:
SndPtr_Jump:		rom_ptr_z80	Sound20	; jumping sound
SndPtr_Checkpoint:	rom_ptr_z80	Sound21	; checkpoint ding-dong sound
SndPtr_SpikeSwitch:	rom_ptr_z80	Sound22	; spike switch sound
SndPtr_Hurt:		rom_ptr_z80	Sound23	; hurt sound
SndPtr_Skidding:	rom_ptr_z80	Sound24	; skidding sound
SndPtr_MissileDissolve:	rom_ptr_z80	Sound25	; missile dissolve sound from Sonic 1 (unused)
SndPtr_HurtBySpikes:	rom_ptr_z80	Sound26	; spiky impalement sound
SndPtr_Sparkle:		rom_ptr_z80	Sound27	; sparkling sound
SndPtr_Beep:		rom_ptr_z80	Sound28	; short beep
SndPtr_Bwoop:		rom_ptr_z80	Sound29	; bwoop (unused)
SndPtr_Splash:		rom_ptr_z80	Sound2A	; splash sound
SndPtr_Swish:		rom_ptr_z80	Sound2B	; swish
SndPtr_BossHit:		rom_ptr_z80	Sound2C	; boss hit
SndPtr_InhalingBubble:	rom_ptr_z80	Sound2D	; inhaling a bubble
SndPtr_ArrowFiring:
SndPtr_LavaBall:	rom_ptr_z80	Sound2E	; arrow firing
SndPtr_Shield:		rom_ptr_z80	Sound2F	; shield sound
SndPtr_LaserBeam:	rom_ptr_z80	Sound30	; laser beam
SndPtr_Zap:		rom_ptr_z80	Sound31	; zap (unused)
SndPtr_Drown:		rom_ptr_z80	Sound32	; drownage
SndPtr_FireBurn:	rom_ptr_z80	Sound33	; fire + burn
SndPtr_Bumper:		rom_ptr_z80	Sound34	; bumper bing
SndPtr_Ring:
SndPtr_RingRight:	rom_ptr_z80	Sound35	; ring sound
SndPtr_SpikesMove:	rom_ptr_z80	Sound36
SndPtr_Rumbling:	rom_ptr_z80	Sound37	; rumbling
			rom_ptr_z80	Sound38	; (unused)
SndPtr_Smash:		rom_ptr_z80	Sound39	; smash/breaking
			rom_ptr_z80	Sound3A	; nondescript ding (unused)
SndPtr_DoorSlam:	rom_ptr_z80	Sound3B	; door slamming shut
SndPtr_SpindashRelease:	rom_ptr_z80	Sound3C	; spindash unleashed
SndPtr_Hammer:		rom_ptr_z80	Sound3D	; slide-thunk
SndPtr_Roll:		rom_ptr_z80	Sound3E	; rolling sound
SndPtr_ContinueJingle:	rom_ptr_z80	Sound3F	; got continue
SndPtr_CasinoBonus:	rom_ptr_z80	Sound40	; short bonus ding
SndPtr_Explosion:	rom_ptr_z80	Sound41	; badnik bust
SndPtr_WaterWarning:	rom_ptr_z80	Sound42	; warning ding-ding
SndPtr_EnterGiantRing:	rom_ptr_z80	Sound43	; special stage ring flash (mostly unused)
SndPtr_BossExplosion:	rom_ptr_z80	Sound44	; thunk
SndPtr_TallyEnd:	rom_ptr_z80	Sound45	; cha-ching
SndPtr_RingSpill:	rom_ptr_z80	Sound46	; losing rings
			rom_ptr_z80	Sound47	; chain pull chink-chink (unused)
SndPtr_Flamethrower:	rom_ptr_z80	Sound48	; flamethrower
SndPtr_Bonus:		rom_ptr_z80	Sound49	; bonus pwoieeew (mostly unused)
SndPtr_SpecStageEntry:	rom_ptr_z80	Sound4A	; special stage entry
SndPtr_SlowSmash:	rom_ptr_z80	Sound4B	; slower smash/crumble
SndPtr_Spring:		rom_ptr_z80	Sound4C	; spring boing
SndPtr_Blip:		rom_ptr_z80	Sound4D	; selection blip
SndPtr_RingLeft:	rom_ptr_z80	Sound4E	; another ring sound (only plays in the left speaker?)
SndPtr_Signpost:	rom_ptr_z80	Sound4F	; signpost spin sound
SndPtr_CNZBossZap:	rom_ptr_z80	Sound50	; mosquito zapper
			rom_ptr_z80	Sound51	; (unused)
			rom_ptr_z80	Sound52	; (unused)
SndPtr_Signpost2P:	rom_ptr_z80	Sound53
SndPtr_OOZLidPop:	rom_ptr_z80	Sound54	; OOZ lid pop sound
SndPtr_SlidingSpike:	rom_ptr_z80	Sound55
SndPtr_CNZElevator:	rom_ptr_z80	Sound56
SndPtr_PlatformKnock:	rom_ptr_z80	Sound57
SndPtr_BonusBumper:	rom_ptr_z80	Sound58	; CNZ bonusy bumper sound
SndPtr_LargeBumper:	rom_ptr_z80	Sound59	; CNZ baaang bumper sound
SndPtr_Gloop:		rom_ptr_z80	Sound5A	; CNZ gloop / water droplet sound
SndPtr_PreArrowFiring:	rom_ptr_z80	Sound5B
SndPtr_Fire:		rom_ptr_z80	Sound5C
SndPtr_ArrowStick:	rom_ptr_z80	Sound5D	; chain clink
SndPtr_Helicopter:
SndPtr_WingFortress:	rom_ptr_z80	Sound5E	; helicopter
SndPtr_SuperTransform:	rom_ptr_z80	Sound5F
SndPtr_SpindashRev:	rom_ptr_z80	Sound60	; spindash charge
SndPtr_Rumbling2:	rom_ptr_z80	Sound61	; rumbling
SndPtr_CNZLaunch:	rom_ptr_z80	Sound62
SndPtr_Flipper:		rom_ptr_z80	Sound63	; CNZ blooing bumper
SndPtr_HTZLiftClick:	rom_ptr_z80	Sound64	; HTZ track click sound
SndPtr_Leaves:		rom_ptr_z80	Sound65	; kicking up leaves sound
SndPtr_MegaMackDrop:	rom_ptr_z80	Sound66	; leaf splash?
SndPtr_DrawbridgeMove:	rom_ptr_z80	Sound67
SndPtr_QuickDoorSlam:	rom_ptr_z80	Sound68	; door slamming quickly (unused)
SndPtr_DrawbridgeDown:	rom_ptr_z80	Sound69
SndPtr_LaserBurst:	rom_ptr_z80	Sound6A	; robotic laser burst
SndPtr_Scatter:
SndPtr_LaserFloor:	rom_ptr_z80	Sound6B	; scatter
SndPtr_Teleport:	rom_ptr_z80	Sound6C
SndPtr_Error:		rom_ptr_z80	Sound6D	; error sound
SndPtr_MechaSonicBuzz:	rom_ptr_z80	Sound6E	; Silver Sonic buzz saw
SndPtr_LargeLaser:	rom_ptr_z80	Sound6F
SndPtr_OilSlide:	rom_ptr_z80	Sound70
SndPtr__End:

Sound20:	include "sound/sfx/A0 - Jump.asm"
Sound21:	include "sound/sfx/A1 - Checkpoint.asm"
Sound22:	include "sound/sfx/A2 - Spike Switch.asm"
Sound23:	include "sound/sfx/A3 - Hurt.asm"
Sound24:	include "sound/sfx/A4 - Skidding.asm"
Sound25:	include "sound/sfx/A5 - Block Push.asm"
Sound26:	include "sound/sfx/A6 - Hurt by Spikes.asm"
Sound27:	include "sound/sfx/A7 - Sparkle.asm"
Sound28:	include "sound/sfx/A8 - Beep.asm"
Sound29:	include "sound/sfx/A9 - Special Stage Item (Unused).asm"
Sound2A:	include "sound/sfx/AA - Splash.asm"
Sound2B:	include "sound/sfx/AB - Swish.asm"
Sound2C:	include "sound/sfx/AC - Boss Hit.asm"
Sound2D:	include "sound/sfx/AD - Inhaling Bubble.asm"
Sound2E:	include "sound/sfx/AE - Lava Ball.asm"
Sound2F:	include "sound/sfx/AF - Shield.asm"
Sound30:	include "sound/sfx/B0 - Laser Beam.asm"
Sound31:	include "sound/sfx/B1 - Electricity (Unused).asm"
Sound32:	include "sound/sfx/B2 - Drown.asm"
Sound33:	include "sound/sfx/B3 - Fire Burn.asm"
Sound34:	include "sound/sfx/B4 - Bumper.asm"
Sound35:	include "sound/sfx/B5 - Ring.asm"
Sound36:	include "sound/sfx/B6 - Spikes Move.asm"
Sound37:	include "sound/sfx/B7 - Rumbling.asm"
Sound38:	include "sound/sfx/B8 - Unknown (Unused).asm"
Sound39:	include "sound/sfx/B9 - Smash.asm"
Sound3A:	include "sound/sfx/BA - Special Stage Glass (Unused).asm"
Sound3B:	include "sound/sfx/BB - Door Slam.asm"
Sound3C:	include "sound/sfx/BC - Spin Dash Release.asm"
Sound3D:	include "sound/sfx/BD - Hammer.asm"
Sound3E:	include "sound/sfx/BE - Roll.asm"
Sound3F:	include "sound/sfx/BF - Continue Jingle.asm"
Sound40:	include "sound/sfx/C0 - Casino Bonus.asm"
Sound41:	include "sound/sfx/C1 - Explosion.asm"
Sound42:	include "sound/sfx/C2 - Water Warning.asm"
Sound43:	include "sound/sfx/C3 - Enter Giant Ring (Unused).asm"
Sound44:	include "sound/sfx/C4 - Boss Explosion.asm"
Sound45:	include "sound/sfx/C5 - Tally End.asm"
Sound46:	include "sound/sfx/C6 - Ring Spill.asm"
Sound47:	include "sound/sfx/C7 - Chain Rise (Unused).asm"
Sound48:	include "sound/sfx/C8 - Flamethrower.asm"
Sound49:	include "sound/sfx/C9 - Hidden Bonus (Unused).asm"
Sound4A:	include "sound/sfx/CA - Special Stage Entry.asm"
Sound4B:	include "sound/sfx/CB - Slow Smash.asm"
Sound4C:	include "sound/sfx/CC - Spring.asm"
Sound4D:	include "sound/sfx/CD - Switch.asm"
Sound4E:	include "sound/sfx/CE - Ring Left Speaker.asm"
Sound4F:	include "sound/sfx/CF - Signpost.asm"
Sound50:	include "sound/sfx/D0 - CNZ Boss Zap.asm"
Sound51:	include "sound/sfx/D1 - Unknown (Unused).asm"
Sound52:	include "sound/sfx/D2 - Unknown (Unused).asm"
Sound53:	include "sound/sfx/D3 - Signpost 2P.asm"
Sound54:	include "sound/sfx/D4 - OOZ Lid Pop.asm"
Sound55:	include "sound/sfx/D5 - Sliding Spike.asm"
Sound56:	include "sound/sfx/D6 - CNZ Elevator.asm"
Sound57:	include "sound/sfx/D7 - Platform Knock.asm"
Sound58:	include "sound/sfx/D8 - Bonus Bumper.asm"
Sound59:	include "sound/sfx/D9 - Large Bumper.asm"
Sound5A:	include "sound/sfx/DA - Gloop.asm"
Sound5B:	include "sound/sfx/DB - Pre-Arrow Firing.asm"
Sound5C:	include "sound/sfx/DC - Fire.asm"
Sound5D:	include "sound/sfx/DD - Arrow Stick.asm"
Sound5E:	include "sound/sfx/DE - Helicopter.asm"
Sound5F:	include "sound/sfx/DF - Super Transform.asm"
Sound60:	include "sound/sfx/E0 - Spin Dash Rev.asm"
Sound61:	include "sound/sfx/E1 - Rumbling 2.asm"
Sound62:	include "sound/sfx/E2 - CNZ Launch.asm"
Sound63:	include "sound/sfx/E3 - Flipper.asm"
Sound64:	include "sound/sfx/E4 - HTZ Lift Click.asm"
Sound65:	include "sound/sfx/E5 - Leaves.asm"
Sound66:	include "sound/sfx/E6 - Mega Mack Drop.asm"
Sound67:	include "sound/sfx/E7 - Drawbridge Move.asm"
Sound68:	include "sound/sfx/E8 - Quick Door Slam.asm"
Sound69:	include "sound/sfx/E9 - Drawbridge Down.asm"
Sound6A:	include "sound/sfx/EA - Laser Burst.asm"
Sound6B:	include "sound/sfx/EB - Scatter.asm"
Sound6C:	include "sound/sfx/EC - Teleport.asm"
Sound6D:	include "sound/sfx/ED - Error.asm"
Sound6E:	include "sound/sfx/EE - Mecha Sonic Buzz.asm"
Sound6F:	include "sound/sfx/EF - Large Laser.asm"
Sound70:	include "sound/sfx/F0 - Oil Slide.asm"

	finishBank

; end of 'ROM'
	if padToPowerOfTwo && (*-StartOfRom)&(*-StartOfRom-1)
		cnop	-1,2<<lastbit(*-StartOfRom-1)
		dc.b	$00
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
