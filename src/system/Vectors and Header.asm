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
