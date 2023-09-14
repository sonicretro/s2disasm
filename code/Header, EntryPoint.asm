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
	include "ICD_BLK4.PRG"
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
