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
	dc.l H_Int			; IRQ level 4 (horizontal retrace interrupt)
	dc.l ErrorTrap		; IRQ level 5
	dc.l V_Int			; IRQ level 6 (vertical retrace interrupt)
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
	dc.b "SONIC THE             HEDGEHOG 2                " ; Domestic name
	dc.b "SONIC THE             HEDGEHOG 2                " ; International name
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
	dc.l (RAM_End-1)&$FFFFFF		; End address of RAM
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
	tst.l	(HW_Port_1_Control-1).l	; test ports A and B control
	bne.s	PortA_Ok	; If so, branch.
	tst.w	(HW_Expansion_Control-1).l	; test port C control
; loc_214:
PortA_Ok:
	bne.s	PortC_OK ; Skip the VDP and Z80 setup code if port A, B or C is ok...?
	lea	SetupValues(pc),a5	; Load setup values array address.
	movem.w	(a5)+,d5-d7
	movem.l	(a5)+,a0-a4
	move.b	HW_Version-Z80_Bus_Request(a1),d0	; Get hardware version
	andi.b	#$F,d0	; Compare
	beq.s	SkipSecurity	; If the console has no TMSS, skip the security stuff.
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
	move.w	d5,(a4)	; move value to VDP register
	add.w	d7,d5	; next register
	dbf	d1,VDPInitLoop

	move.l	(a5)+,(a4)	; set VRAM write mode
	move.w	d0,(a3)	; clear the screen
	move.w	d7,(a1)	; stop the Z80
	move.w	d7,(a2)	; reset the Z80
; loc_250:
WaitForZ80:
	btst	d0,(a1)	; has the Z80 stopped?
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
	move.l	d0,(a3)	; clear 2 palettes
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
	dc.b $80		; Command $9780	- See above + VRAM fill mode
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
	cmp.w	(a1),d1	; compare correct checksum to the one in ROM
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
	move.b	(Game_Mode).w,d0 ; load Game Mode
	andi.w	#$3C,d0	; limit Game Mode value to $3C max (change to a maximum of 7C to add more game modes)
	jsr	GameModesArray(pc,d0.w)	; jump to apt location in ROM
	bra.s	MainGameLoop	; loop indefinitely
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
	moveq	#$3F,d7
; loc_3E2:
Checksum_Red:
	move.w	#$E,(VDP_data_port).l ; fill palette with red
	dbf	d7,Checksum_Red	; repeat $3F more times
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
