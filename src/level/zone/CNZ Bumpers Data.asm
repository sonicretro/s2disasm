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


; ===========================================================================
