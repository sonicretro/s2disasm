; -----------------------------------------------------------------------------
; sprite mappings (obj8D)
; -----------------------------------------------------------------------------
Obj8D_MapUnc_36CF0:	mappingsTable
	mappingsTableEntry.w	word_36D02
	mappingsTableEntry.w	word_36D24
	mappingsTableEntry.w	word_36D46
	mappingsTableEntry.w	word_36D58
	mappingsTableEntry.w	word_36D6A
; -----------------------------------------------------------------------------
; sprite mappings (obj90)
; -----------------------------------------------------------------------------
Obj90_MapUnc_36CFA:	mappingsTable
	mappingsTableEntry.w	word_36D7C
	mappingsTableEntry.w	word_36D86
	mappingsTableEntry.w	word_36D90
; -----------------------------------------------------------------------------
; sprite mappings (obj90)
; -----------------------------------------------------------------------------
Obj90_MapUnc_36D00:	mappingsTable
	mappingsTableEntry.w	word_36D9A

word_36D02:	spriteHeader
	spritePiece	-8, -$C, 1, 1, 0, 0, 0, 0, 0
	spritePiece	-$10, -4, 2, 3, 1, 0, 0, 0, 0
	spritePiece	0, -$C, 1, 1, 0, 1, 0, 0, 0
	spritePiece	0, -4, 2, 3, 1, 1, 0, 0, 0
word_36D02_End

word_36D24:	spriteHeader
	spritePiece	-8, -$14, 1, 1, 7, 0, 0, 0, 0
	spritePiece	-$10, -$C, 2, 4, 8, 0, 0, 0, 0
	spritePiece	0, -$14, 1, 1, 7, 1, 0, 0, 0
	spritePiece	0, -$C, 2, 4, 8, 1, 0, 0, 0
word_36D24_End

word_36D46:	spriteHeader
	spritePiece	-$10, -$14, 4, 4, $10, 0, 0, 0, 0
	spritePiece	-$10, $C, 4, 1, $20, 0, 0, 0, 0
word_36D46_End

word_36D58:	spriteHeader
	spritePiece	-$10, -$14, 4, 4, $10, 0, 0, 0, 0
	spritePiece	-$10, $C, 4, 1, $24, 0, 0, 0, 0
word_36D58_End

word_36D6A:	spriteHeader
	spritePiece	-$10, -$14, 4, 4, $10, 0, 0, 0, 0
	spritePiece	-$10, $C, 4, 1, $28, 0, 0, 0, 0
word_36D6A_End

word_36D7C:	spriteHeader
	spritePiece	-8, -8, 2, 2, $2C, 0, 0, 0, 0
word_36D7C_End

word_36D86:	spriteHeader
	spritePiece	-4, -4, 1, 1, $30, 0, 0, 0, 0
word_36D86_End

word_36D90:	spriteHeader
	spritePiece	-4, -4, 1, 1, $31, 0, 0, 0, 0
word_36D90_End

word_36D9A:	spriteHeader
	spritePiece	-$10, -8, 2, 2, $93, 0, 0, 2, 0
	spritePiece	0, -8, 2, 2, $97, 0, 0, 2, 0
word_36D9A_End

	even
