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
