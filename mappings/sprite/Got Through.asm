; -------------------------------------------------------------------------------
; sprite mappings - end-of-level results screen title cards
; Note: only the following letters are included in the font art
;	A, C, G, H, I, L, M, R, S, T, U
; -------------------------------------------------------------------------------
; Obj3A_MapUnc_14CBC:
MapUnc_EOLTitleCards:	mappingsTable
	mappingsTableEntry.w	EOL_Sonic	; "SONIC GOT" text
	mappingsTableEntry.w	EOL_Miles	; "MILES GOT" text (Japanese region)
	mappingsTableEntry.w	EOL_Tails	; "TAILS GOT" text (international region)
	mappingsTableEntry.w	EOL_Through	; "THROUGH" text
	mappingsTableEntry.w	EOL_Act		; "ACT" text

	mappingsTableEntry.w	TC_ZONE		; "ZONE" text
	mappingsTableEntry.w	TC_No1		; "1" text
	mappingsTableEntry.w	TC_No2		; "2" text
	mappingsTableEntry.w	TC_No3		; "3" text

	mappingsTableEntry.w	EOL_Total	; Total text
	mappingsTableEntry.w	EOL_TimeBonus	; Time Bonus text
	mappingsTableEntry.w	EOL_RingBonus	; Ring Bonus text
	mappingsTableEntry.w	EOL_SonFrame1	; Mini Sonic, frame 1
	mappingsTableEntry.w	EOL_SonFrame2	; Mini Sonic, frame 2
	mappingsTableEntry.w	EOL_Perfect	; Perfect text

; word_14CDA:
EOL_Sonic:	spriteHeader	; SONIC GOT
	spritePiece	-$40, 0, 2, 2, $5D0, 0, 0, 0, 1	; S
	spritePiece	-$30, 0, 2, 2, $588, 0, 0, 0, 1	; O
	spritePiece	-$20, 0, 2, 2, $584, 0, 0, 0, 1	; N
	spritePiece	-$10, 0, 1, 2, $5C0, 0, 0, 0, 1	; I
	spritePiece	-8, 0, 2, 2, $5B4, 0, 0, 0, 1	; C

	spritePiece	$10, 0, 2, 2, $5B8, 0, 0, 0, 1	; G
	spritePiece	$20, 0, 2, 2, $588, 0, 0, 0, 1	; O
	spritePiece	$2F, 0, 2, 2, $5D4, 0, 0, 0, 1	; T
EOL_Sonic_End

; word_14D1C:
EOL_Miles:	spriteHeader	; MILES GOT
	spritePiece	-$44, 0, 3, 2, $5C6, 0, 0, 0, 1	; M
	spritePiece	-$2C, 0, 1, 2, $5C0, 0, 0, 0, 1	; I
	spritePiece	-$24, 0, 2, 2, $5C2, 0, 0, 0, 1	; L
	spritePiece	-$14, 0, 2, 2, $580, 0, 0, 0, 1	; E
	spritePiece	-4, 0, 2, 2, $5D0, 0, 0, 0, 1	; S

	spritePiece	$14, 0, 2, 2, $5B8, 0, 0, 0, 1	; G
	spritePiece	$24, 0, 2, 2, $588, 0, 0, 0, 1	; O
	spritePiece	$33, 0, 2, 2, $5D4, 0, 0, 0, 1	; T
EOL_Miles_End

; word_14D5E:
EOL_Tails:	spriteHeader	; TAILS GOT
	spritePiece	-$3D, 0, 2, 2, $5D4, 0, 0, 0, 1	; T
	spritePiece	-$30, 0, 2, 2, $5B0, 0, 0, 0, 1	; A
	spritePiece	-$20, 0, 1, 2, $5C0, 0, 0, 0, 1	; I
	spritePiece	-$18, 0, 2, 2, $5C2, 0, 0, 0, 1	; L
	spritePiece	-8, 0, 2, 2, $5D0, 0, 0, 0, 1	; S

	spritePiece	$10, 0, 2, 2, $5B8, 0, 0, 0, 1	; G
	spritePiece	$20, 0, 2, 2, $588, 0, 0, 0, 1	; O
	spritePiece	$2F, 0, 2, 2, $5D4, 0, 0, 0, 1	; T
EOL_Tails_End

; word_14DA0:
EOL_Through:	spriteHeader	; THROUGH
	spritePiece	-$38, 0, 2, 2, $5D4, 0, 0, 0, 1	; T
	spritePiece	-$28, 0, 2, 2, $5BC, 0, 0, 0, 1	; H
	spritePiece	-$18, 0, 2, 2, $5CC, 0, 0, 0, 1	; R
	spritePiece	-8, 0, 2, 2, $588, 0, 0, 0, 1	; O
	spritePiece	8, 0, 2, 2, $5D8, 0, 0, 0, 1	; U
	spritePiece	$18, 0, 2, 2, $5B8, 0, 0, 0, 1	; G
	spritePiece	$28, 0, 2, 2, $5BC, 0, 0, 0, 1	; H
EOL_Through_End

; word_14DDA:
EOL_Act:	spriteHeader	; ACT
	spritePiece	0, 0, 2, 2, $5B0, 0, 0, 0, 1	; A
	spritePiece	$10, 0, 2, 2, $5B4, 0, 0, 0, 1	; C
	spritePiece	$1F, 0, 2, 2, $5D4, 0, 0, 0, 1	; T
EOL_Act_End


; Miscellaneous end-of-level results screen title cards mappings

; word_14DF4:
EOL_Total:	spriteHeader	; Total text
	spritePiece	-$48, 0, 3, 2, $5E6, 0, 0, 1, 1
	spritePiece	-$30, 0, 2, 2, $5EC, 0, 0, 1, 1
	spritePiece	-$2C, 0, 2, 2, $5F0, 0, 0, 0, 1
	spritePiece	$38, 0, 4, 2, $520, 0, 0, 0, 1
	spritePiece	$58, 0, 1, 2, $6F0, 0, 0, 0, 1
EOL_Total_End

; word_14E1E:
EOL_TimeBonus:	spriteHeader	; Time Bonus text
	spritePiece	-$5C, 0, 4, 2, $6DA, 0, 0, 1, 1
	spritePiece	-$34, 0, 4, 2, $5DE, 0, 0, 1, 1
	spritePiece	-$14, 0, 1, 2, $6CA, 0, 0, 1, 1
	spritePiece	-$18, 0, 2, 2, $5F0, 0, 0, 0, 1
	spritePiece	$38, 0, 4, 2, $528, 0, 0, 0, 1
	spritePiece	$58, 0, 1, 2, $6F0, 0, 0, 0, 1
EOL_TimeBonus_End

; word_14E50:
EOL_RingBonus:	spriteHeader	; Ring Bonus text
	spritePiece	-$5C, 0, 4, 2, $6D2, 0, 0, 1, 1
	spritePiece	-$34, 0, 4, 2, $5DE, 0, 0, 1, 1
	spritePiece	-$14, 0, 1, 2, $6CA, 0, 0, 1, 1
	spritePiece	-$18, 0, 2, 2, $5F0, 0, 0, 0, 1
	spritePiece	$38, 0, 4, 2, $530, 0, 0, 0, 1
	spritePiece	$58, 0, 1, 2, $6F0, 0, 0, 0, 1
EOL_RingBonus_End

; word_14E82:
EOL_SonFrame1:	spriteHeader	; Mini Sonic, frame 1
	spritePiece	0, 0, 2, 3, $5F4, 0, 0, 0, 1
EOL_SonFrame1_End

; word_14E8C:
EOL_SonFrame2:	spriteHeader	; Mini Sonic, frame 2
	spritePiece	0, 0, 2, 3, $5FA, 0, 0, 0, 1
EOL_SonFrame2_End

; word_14E96:
EOL_Perfect:	spriteHeader	; Perfect text
	spritePiece	-$68, 0, 4, 2, $540, 0, 0, 1, 1
	spritePiece	-$48, 0, 3, 2, $548, 0, 0, 1, 1
	spritePiece	-$28, 0, 4, 2, $5DE, 0, 0, 1, 1
	spritePiece	-8, 0, 1, 2, $6CA, 0, 0, 1, 1
	spritePiece	-$C, 0, 2, 2, $5F0, 0, 0, 0, 1
	spritePiece	$38, 0, 4, 2, $538, 0, 0, 0, 1
	spritePiece	$58, 0, 1, 2, $6F0, 0, 0, 0, 1
EOL_Perfect_End

	even
