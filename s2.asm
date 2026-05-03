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

	include "_inc/DMA Queue.asm"
	include "_inc/Nemesis Decompressor.asm"
	include "_inc/PLC Processing.asm"
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

	include "_incObj/sub RandomNumber.asm"
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
	include "_incObj/AD & AE Clucker.asm" ; AD is the base it comes out of, AE is Clucker itself
	include "_anim/Clucker.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjAD_Obj98_MapUnc_395B4:	include "mappings/sprite/objAE.asm"
; ===========================================================================
	include "_incObj/AF Mecha Sonic.asm"
	include "_anim/Mecha Sonic.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjAF_Obj98_MapUnc_39E68:	include "mappings/sprite/objAF_a.asm"
ObjAF_MapUnc_3A08C:	include "mappings/sprite/objAF_b.asm"
; ===========================================================================
	include "_incObj/B0 & B1 Sonic on Sega Screen.asm" ; B1 is the trademark hider for JP regions
	include "_anim/Sonic on Sega Screen.asm"
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
	include "_incObj/B2 Tornado.asm"
	include "_anim/Tornado.asm"
; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjB2_MapUnc_3AFF2:	include "mappings/sprite/objB2_a.asm"
ObjB2_MapUnc_3B292:	include "mappings/sprite/objB2_b.asm"
; ===========================================================================
	include "_incObj/B3 Clouds.asm"
; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjB3_MapUnc_3B32C:	include "mappings/sprite/objB3.asm"
; ===========================================================================
	include "_incObj/B4 WFZ Vertical Propeller.asm"
	include "_anim/WFZ Vertical Propeller.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB4_MapUnc_3B3BE:	include "mappings/sprite/objB4.asm"
; ===========================================================================
	include "_incObj/B5 WFZ Horizontal Propeller.asm"
	include "_anim/WFZ Horizontal Propeller.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB5_MapUnc_3B548:	include "mappings/sprite/objB5.asm"
; ===========================================================================
	include "_incObj/B6 WFZ Tilting Platform.asm"
	include "_anim/WFZ Tilting Platform.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB6_MapUnc_3B856:	include "mappings/sprite/objB6.asm"
; ===========================================================================
	include "_incObj/B7 WFZ Huge Laser.asm"
ObjB7_MapUnc_3B8E4:	include "mappings/sprite/objB7.asm"
; ===========================================================================
	include "_incObj/B8 WFZ Wall Turret.asm"
	include "_anim/WFZ Wall Turret.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB8_Obj98_MapUnc_3BA46:	include "mappings/sprite/objB8.asm"
; ===========================================================================
	include "_incObj/B9 WFZ Cutscene Laser.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB9_MapUnc_3BB18:	include "mappings/sprite/objB9.asm"
; ===========================================================================
	include "_incObj/BA WFZ Wheel.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBA_MapUnc_3BB70:	include "mappings/sprite/objBA.asm"
; ===========================================================================
	include "_incObj/BB Deleted Object.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBB_MapUnc_3BBA0:	include "mappings/sprite/objBB.asm"
; ===========================================================================
	include "_incObj/BC WFZ Escape Jet.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBC_MapUnc_3BC08:	include "mappings/sprite/objBC.asm"
; ===========================================================================
	include "_incObj/BD WFZ Platforms.asm"
	include "_anim/WFZ Platforms.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBD_MapUnc_3BD3E:	include "mappings/sprite/objBD.asm"
; ===========================================================================
	include "_incObj/BE WFZ Lateral Cannon Platform.asm"
	include "_anim/WFZ Lateral Cannon Platform.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBE_MapUnc_3BE46:	include "mappings/sprite/objBE.asm"
; ===========================================================================
	include "_incObj/BF WFZ Destructible Pole.asm"
	include "_incObj/WFZ Destructible Pole.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBF_MapUnc_3BEE0:	include "mappings/sprite/objBF.asm"
; ===========================================================================
	include "_incObj/C0 WFZ Launcher.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC0_MapUnc_3C098:	include "mappings/sprite/objC0.asm"
; ===========================================================================
	include "_incObj/C1 WFZ Breakable Plating.asm" ; animation script is embedded in the code
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
ObjC1_MapUnc_3C280:	include "mappings/sprite/objC1.asm"
; ===========================================================================
	include "_incObj/C2 WFZ Rivet Switch.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC2_MapUnc_3C3C2:	include "mappings/sprite/objC2.asm"

Invalid_SubObjData2:

; ===========================================================================
	include "_incObj/C3 & C4 WFZ Cutscene Smoke.asm"
; ===========================================================================
	include "_incObj/C5 WFZ Boss.asm"
	include "_anim/WFZ Boss.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC5_MapUnc_3CCD8:	include "mappings/sprite/objC5_a.asm"
ObjC5_MapUnc_3CEBC:	include "mappings/sprite/objC5_b.asm"
; ===========================================================================
	include "_incObj/C6 Eggman.asm"
	include "_anim/Eggman.asm"
; ----------------------------------------------------------------------------
; sprite mappings ; Robotnik running
; ----------------------------------------------------------------------------
ObjC6_MapUnc_3D0EE:	include "mappings/sprite/objC6_a.asm"
ObjC6_MapUnc_3D1DE:	include "mappings/sprite/objC6_b.asm"
; ===========================================================================
	include "_incObj/C8 Crawl.asm"
	include "_anim/Crawl.asm"
; ----------------------------------------------------------------------------
; sprite mappings ; Crawl CNZ
; ----------------------------------------------------------------------------
ObjC8_MapUnc_3D450:	include "mappings/sprite/objC8.asm"
; ===========================================================================
	include "_incObj/C7 Death Egg Robot.asm" ; Contains macros for a custom animation format, might need more splitting?
	include "_anim/Death Egg Robot 1.asm"
	include "_anim/Death Egg Robot 2.asm"
	include "_anim/Death Egg Robot 3.asm"
; ------------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------------
ObjC7_MapUnc_3E5F8:	include "mappings/sprite/objC7.asm"
; ===========================================================================
	include "_incObj/sub Scale2x.asm"
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
	include "_incObj/8A Credits.asm"
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings (unused?)
; ----------------------------------------------------------------------------
Obj8A_MapUnc_3EB4E:	include "mappings/sprite/obj8A.asm"
; ===========================================================================

	jmpTos JmpTo65_Adjust2PArtPointer

; ===========================================================================
	include "_incObj/3E Prison Capsule.asm"
; ===========================================================================
	include "_anim/Prison Capsule.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; [fixBugs] These mappings contain a bug: the second and third sprites have
; their 'total sprite pieces' value set too low by one, causing the last
; sprite piece to not be displayed.
; ----------------------------------------------------------------------------
Obj3E_MapUnc_3F436:	include "mappings/sprite/obj3E.asm"
; ===========================================================================

	jmpTos JmpTo66_DeleteObject,JmpTo20_AllocateObject

	include "_incObj/sub TouchResponse.asm" ; includes HurtCharacter, KillCharacter, and Boss damage stuff. Maybe split better??
; ===========================================================================

	jmpTos JmpTo_Sonic_ResetOnFloor_Part2,JmpTo_Check_CNZ_bumpers,JmpTo_Touch_Rings

; ===========================================================================
	include "_inc/Animate Level Graphics.asm"
; ===========================================================================

	jmpTos JmpTo2_NemDecToRAM

	include "_inc/HUD Update.asm"
; ===========================================================================
; ArtUnc_4134C:
Art_Hud:	BINCLUDE	"art/uncompressed/Big and small numbers used on counters - 1.bin"
; ArtUnc_4164C:
Art_LivesNums:	BINCLUDE	"art/uncompressed/Big and small numbers used on counters - 2.bin"
; ArtUnc_4178C:
Art_Text:	BINCLUDE	"art/uncompressed/Big and small numbers used on counters - 3.bin"

	jmpTos JmpTo_DrawSprite_2P_Loop,JmpTo_DrawSprite_Loop

; ===========================================================================
	include "_inc/Debug Mode.asm"
; ===========================================================================
	include "_inc/Debug Lists.asm"
	jmpTos JmpTo66_Adjust2PArtPointer
	include "_inc/Level Headers.asm"
	include "_inc/Pattern Load Cues.asm"
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

	include "_inc/Saxman Decompressor.asm"

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
