; ----------------------------------------------------------------------------
; Primary sprite mappings for springs
; ----------------------------------------------------------------------------
Obj41_MapUnc_1901C:	mappingsTable
	mappingsTableEntry.w	word_19048
	mappingsTableEntry.w	word_1905A
	mappingsTableEntry.w	word_19064
	mappingsTableEntry.w	word_19076
	mappingsTableEntry.w	word_19088
	mappingsTableEntry.w	word_19092
	mappingsTableEntry.w	word_190A4
	mappingsTableEntry.w	word_190B6
	mappingsTableEntry.w	word_190D8
	mappingsTableEntry.w	word_190F2
	mappingsTableEntry.w	word_19114
; -------------------------------------------------------------------------------
; Secondary sprite mappings for springs
; merged with the above mappings; can't split to file in a useful way...
; -------------------------------------------------------------------------------
Obj41_MapUnc_19032:	mappingsTable
	mappingsTableEntry.w	word_19048
	mappingsTableEntry.w	word_1905A
	mappingsTableEntry.w	word_19064
	mappingsTableEntry.w	word_19076
	mappingsTableEntry.w	word_19088
	mappingsTableEntry.w	word_19092
	mappingsTableEntry.w	word_190A4
	mappingsTableEntry.w	word_19136
	mappingsTableEntry.w	word_19158
	mappingsTableEntry.w	word_19172
	mappingsTableEntry.w	word_19194

word_19048:	spriteHeader
	spritePiece	-$10, -$10, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-8, 0, 2, 2, 8, 0, 0, 0, 0
word_19048_End

word_1905A:	spriteHeader
	spritePiece	-$10, -8, 4, 2, 0, 0, 0, 0, 0
word_1905A_End

word_19064:	spriteHeader
	spritePiece	-$10, -$20, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-8, -$10, 2, 4, $C, 0, 0, 0, 0
word_19064_End

word_19076:	spriteHeader
	spritePiece	0, -$10, 1, 4, 0, 0, 0, 0, 0
	spritePiece	-8, -8, 1, 2, 4, 0, 0, 0, 0
word_19076_End

word_19088:	spriteHeader
	spritePiece	-8, -$10, 1, 4, 0, 0, 0, 0, 0
word_19088_End

word_19092:	spriteHeader
	spritePiece	$10, -$10, 1, 4, 0, 0, 0, 0, 0
	spritePiece	-8, -8, 3, 2, 6, 0, 0, 0, 0
word_19092_End

word_190A4:	spriteHeader
	spritePiece	-$10, 0, 4, 2, 0, 0, 1, 0, 0
	spritePiece	-8, -$10, 2, 2, 8, 0, 1, 0, 0
word_190A4_End

word_190B6:	spriteHeader
	spritePiece	-$10, -$10, 4, 2, 0, 0, 0, 0, 0
	spritePiece	0, 0, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-$A, -5, 2, 2, $C, 0, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, $1C, 0, 0, 1, 0
word_190B6_End

word_190D8:	spriteHeader
	spritePiece	-$16, -$A, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-6, 6, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, $1C, 0, 0, 1, 0
word_190D8_End

word_190F2:	spriteHeader
	spritePiece	-5, -$1A, 4, 2, 0, 0, 0, 0, 0
	spritePiece	$B, -$A, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-$A, -$D, 3, 4, $10, 0, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, $1C, 0, 0, 1, 0
word_190F2_End

word_19114:	spriteHeader
	spritePiece	-$10, 0, 4, 2, 0, 0, 1, 0, 0
	spritePiece	0, -$10, 2, 2, 8, 0, 1, 0, 0
	spritePiece	-$A, -$B, 2, 2, $C, 0, 1, 0, 0
	spritePiece	-$10, -$10, 2, 2, $1C, 0, 1, 1, 0
word_19114_End

word_19136:	spriteHeader
	spritePiece	-$10, -$10, 4, 2, 0, 0, 0, 0, 0
	spritePiece	0, 0, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-$A, -5, 2, 2, $C, 0, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, $1C, 0, 0, 0, 0
word_19136_End

word_19158:	spriteHeader
	spritePiece	-$16, -$A, 4, 2, 0, 0, 0, 0, 0
	spritePiece	-6, 6, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, $1C, 0, 0, 0, 0
word_19158_End

word_19172:	spriteHeader
	spritePiece	-5, -$1A, 4, 2, 0, 0, 0, 0, 0
	spritePiece	$B, -$A, 2, 2, 8, 0, 0, 0, 0
	spritePiece	-$A, -$D, 3, 4, $10, 0, 0, 0, 0
	spritePiece	-$10, 0, 2, 2, $1C, 0, 0, 0, 0
word_19172_End

word_19194:	spriteHeader
	spritePiece	-$10, 0, 4, 2, 0, 0, 1, 0, 0
	spritePiece	0, -$10, 2, 2, 8, 0, 1, 0, 0
	spritePiece	-$A, -$B, 2, 2, $C, 0, 1, 0, 0
	spritePiece	-$10, -$10, 2, 2, $1C, 0, 1, 0, 0
word_19194_End

	even
