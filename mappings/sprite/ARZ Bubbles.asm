; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj24_MapUnc_1FBF6:	mappingsTable
	mappingsTableEntry.w	word_1FC3A
	mappingsTableEntry.w	word_1FC44
	mappingsTableEntry.w	word_1FC44
	mappingsTableEntry.w	word_1FC4E
	mappingsTableEntry.w	word_1FC58
	mappingsTableEntry.w	word_1FC62
	mappingsTableEntry.w	word_1FC6C
	mappingsTableEntry.w	word_1FC76
	mappingsTableEntry.w	word_1FC98
	mappingsTableEntry.w	word_1FC98
	mappingsTableEntry.w	word_1FC98
	mappingsTableEntry.w	word_1FC98
	mappingsTableEntry.w	word_1FC98
	mappingsTableEntry.w	word_1FC98
	mappingsTableEntry.w	word_1FCA2
	mappingsTableEntry.w	word_1FCAC
	mappingsTableEntry.w	word_1FCB6
; -------------------------------------------------------------------------------
; sprite mappings
; merged with the above mappings, can't split to file in a useful way...
; -------------------------------------------------------------------------------
Obj24_MapUnc_1FC18:	mappingsTable
	mappingsTableEntry.w	word_1FC3A
	mappingsTableEntry.w	word_1FC44
	mappingsTableEntry.w	word_1FC44
	mappingsTableEntry.w	word_1FC4E
	mappingsTableEntry.w	word_1FC58
	mappingsTableEntry.w	word_1FC62
	mappingsTableEntry.w	word_1FC6C
	mappingsTableEntry.w	word_1FC76
	mappingsTableEntry.w	word_1FCB8
	mappingsTableEntry.w	word_1FCB8
	mappingsTableEntry.w	word_1FCB8
	mappingsTableEntry.w	word_1FCB8
	mappingsTableEntry.w	word_1FCB8
	mappingsTableEntry.w	word_1FCB8
	mappingsTableEntry.w	word_1FCA2
	mappingsTableEntry.w	word_1FCAC
	mappingsTableEntry.w	word_1FCB6

word_1FC3A:	spriteHeader
	spritePiece	-4, -4, 1, 1, $8D, 0, 0, 0, 0
word_1FC3A_End

word_1FC44:	spriteHeader
	spritePiece	-4, -4, 1, 1, $8E, 0, 0, 0, 0
word_1FC44_End

word_1FC4E:	spriteHeader
	spritePiece	-8, -8, 2, 2, $8F, 0, 0, 0, 0
word_1FC4E_End

word_1FC58:	spriteHeader
	spritePiece	-8, -8, 2, 2, $93, 0, 0, 0, 0
word_1FC58_End

word_1FC62:	spriteHeader
	spritePiece	-$C, -$C, 3, 3, $1C, 0, 0, 0, 0
word_1FC62_End

word_1FC6C:	spriteHeader
	spritePiece	-$10, -$10, 4, 4, 8, 0, 0, 0, 0
word_1FC6C_End

word_1FC76:	spriteHeader
	spritePiece	-$10, -$10, 2, 2, $18, 0, 0, 0, 0
	spritePiece	0, -$10, 2, 2, $18, 1, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, $18, 0, 1, 0, 0
	spritePiece	0, 0, 2, 2, $18, 1, 1, 0, 0
word_1FC76_End

word_1FC98:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $741, 1, 1, 0, 0
word_1FC98_End

word_1FCA2:	spriteHeader
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0
word_1FCA2_End

word_1FCAC:	spriteHeader
	spritePiece	-8, -8, 2, 2, 4, 0, 0, 0, 0
word_1FCAC_End

word_1FCB6:	spriteHeader
word_1FCB6_End

word_1FCB8:	spriteHeader
	spritePiece	-8, -$C, 2, 3, $731, 1, 1, 0, 0
word_1FCB8_End

	even
