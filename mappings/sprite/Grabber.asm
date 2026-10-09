; ----------------------------------------------------------------------------
; sprite mappings - objA7,objA8,objA9
; ----------------------------------------------------------------------------
ObjA7_ObjA8_ObjA9_Obj98_MapUnc_3921A:	mappingsTable
	mappingsTableEntry.w	word_3923A
	mappingsTableEntry.w	word_39254
	mappingsTableEntry.w	word_3926E
	mappingsTableEntry.w	word_39278
	mappingsTableEntry.w	word_39282
	mappingsTableEntry.w	word_3928C
	mappingsTableEntry.w	word_39296
; -------------------------------------------------------------------------------
; sprite mappings - objAA (string of various lengths)
; -------------------------------------------------------------------------------
ObjAA_MapUnc_39228:	mappingsTable
	mappingsTableEntry.w	word_392A0	; 0
	mappingsTableEntry.w	word_392AA	; 1
	mappingsTableEntry.w	word_392B4	; 2
	mappingsTableEntry.w	word_392C6	; 3
	mappingsTableEntry.w	word_392D8	; 4
	; Unused - The spider badnik never goes down enough for these to appear
	mappingsTableEntry.w	word_3930C	; 5	; This is in the wrong place - this should be frame 6
	mappingsTableEntry.w	word_392F2	; 6	; This is in the wrong place - this should be frame 5
	mappingsTableEntry.w	word_3932E	; 7
	mappingsTableEntry.w	word_3932E	; 8	; This should point to word_39350

word_3923A:	spriteHeader
	spritePiece	-$1B, -8, 1, 2, 0, 0, 0, 0, 0
	spritePiece	-$13, -8, 4, 2, 2, 0, 0, 0, 0
	spritePiece	-$F, 8, 3, 2, $1D, 0, 0, 0, 0
word_3923A_End

word_39254:	spriteHeader
	spritePiece	-$1B, -8, 1, 2, 0, 0, 0, 0, 0
	spritePiece	-$13, -8, 4, 2, 2, 0, 0, 0, 0
	spritePiece	-$F, 8, 4, 2, $23, 0, 0, 0, 0
word_39254_End

word_3926E:	spriteHeader
	spritePiece	-4, -4, 1, 1, $A, 0, 0, 0, 0
word_3926E_End

word_39278:	spriteHeader
	spritePiece	-7, -8, 3, 2, $F, 0, 0, 0, 0
word_39278_End

word_39282:	spriteHeader
	spritePiece	-7, -8, 4, 2, $15, 0, 0, 0, 0
word_39282_End

word_3928C:	spriteHeader
	spritePiece	-4, -4, 1, 1, $2B, 0, 0, 0, 0
word_3928C_End

word_39296:	spriteHeader
	spritePiece	-4, -4, 1, 1, $2C, 0, 0, 0, 0
word_39296_End

word_392A0:	spriteHeader
	spritePiece	-4, 0, 1, 2, $B, 0, 0, 0, 0
word_392A0_End

word_392AA:	spriteHeader
	spritePiece	-4, 0, 1, 4, $B, 0, 0, 0, 0
word_392AA_End

word_392B4:	spriteHeader
	spritePiece	-4, 0, 1, 2, $B, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 4, $B, 0, 0, 0, 0
word_392B4_End

word_392C6:	spriteHeader
	spritePiece	-4, 0, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $20, 1, 4, $B, 0, 0, 0, 0
word_392C6_End

word_392D8:	spriteHeader
	spritePiece	-4, 0, 1, 2, $B, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $30, 1, 4, $B, 0, 0, 0, 0
word_392D8_End

word_392F2:	spriteHeader
	spritePiece	-4, 0, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $20, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $40, 1, 4, $B, 0, 0, 0, 0
word_392F2_End

word_3930C:	spriteHeader
	spritePiece	-4, 0, 1, 2, $B, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $30, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $50, 1, 4, $B, 0, 0, 0, 0
word_3930C_End

word_3932E:	spriteHeader
	spritePiece	-4, 0, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $20, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $40, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $60, 1, 4, $B, 0, 0, 0, 0
word_3932E_End

; Unused frame
word_39350:	spriteHeader
	spritePiece	-4, 0, 1, 2, $B, 0, 0, 0, 0
	spritePiece	-4, $10, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $30, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $50, 1, 4, $B, 0, 0, 0, 0
	spritePiece	-4, $70, 1, 4, $B, 0, 0, 0, 0
word_39350_End

	even
