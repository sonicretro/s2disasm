; -------------------------------------------------------------------------------
; sprite mappings - zone title cards
; Note: if you modify these mappings, also adjust the characters
;	loaded into VRAM in TitleCardLetters
; -------------------------------------------------------------------------------
; Obj34_MapUnc_147BA:
MapUnc_TitleCards:	mappingsTable
.zone_names:	zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w TC_EHZ		; Emerald Hill Zone
	zoneOffsetTableEntry.w TC_EHZ		; XXX unused (unknown)
	zoneOffsetTableEntry.w TC_EHZ		; XXX unused (Wood Zone)
	zoneOffsetTableEntry.w TC_EHZ		; XXX unused (unknown)
	zoneOffsetTableEntry.w TC_MTZ		; Metropolis Zone Act 1 and 2
	zoneOffsetTableEntry.w TC_MTZ		; Metropolis Zone Act 3
	zoneOffsetTableEntry.w TC_WFZ		; Wing Fortress Zone
	zoneOffsetTableEntry.w TC_HTZ		; Hill Top Zone
	zoneOffsetTableEntry.w TC_HPZ		; XXX Hidden Palace Zone
	zoneOffsetTableEntry.w TC_EHZ		; XXX unused (Cyber City Zone)
	zoneOffsetTableEntry.w TC_OOZ		; Oil Ocean Zone
	zoneOffsetTableEntry.w TC_MCZ		; Mystic Cave Zone
	zoneOffsetTableEntry.w TC_CNZ		; Casino Night Zone
	zoneOffsetTableEntry.w TC_CPZ		; Chemical Plant Zone
	zoneOffsetTableEntry.w TC_DEZ		; Death Egg Zone
	zoneOffsetTableEntry.w TC_ARZ		; Aquatic Ruin Zone
	zoneOffsetTableEntry.w TC_SCZ		; Sky Chase Zone
    zoneTableEnd
	mappingsTableEntry.w TC_ZONE		; "ZONE" text
	mappingsTableEntry.w TC_No1		; Act number 1
	mappingsTableEntry.w TC_No2		; Act number 2
	mappingsTableEntry.w TC_No3		; Act number 3
	mappingsTableEntry.w TC_STH		; "SONIC THE HEDGEHOG" text
	mappingsTableEntry.w TC_RedStripes	; Red stripes

; word_147E8:
TC_EHZ:		spriteHeader	; EMERALD HILL
	spritePiece	-$3D, 0, 2, 2, $580, 0, 0, 0, 1	; E
	spritePiece	-$30, 0, 3, 2, $5DE, 0, 0, 0, 1	; M
	spritePiece	-$18, 0, 2, 2, $580, 0, 0, 0, 1	; E
	spritePiece	-8, 0, 2, 2, $5E4, 0, 0, 0, 1	; R
	spritePiece	8, 0, 2, 2, $5E8, 0, 0, 0, 1	; A
	spritePiece	$18, 0, 2, 2, $5EC, 0, 0, 0, 1	; L
	spritePiece	$28, 0, 2, 2, $5F0, 0, 0, 0, 1	; D

	spritePiece	$48, 0, 2, 2, $5F4, 0, 0, 0, 1	; H
	spritePiece	$58, 0, 1, 2, $5F8, 0, 0, 0, 1	; I
	spritePiece	$60, 0, 2, 2, $5EC, 0, 0, 0, 1	; L
	spritePiece	$70, 0, 2, 2, $5EC, 0, 0, 0, 1	; L
TC_EHZ_End

; word_14842:
TC_MTZ:		spriteHeader	; METROPOLIS
	spritePiece	-$20, 0, 3, 2, $5DE, 0, 0, 0, 1	; M
	spritePiece	-8, 0, 2, 2, $580, 0, 0, 0, 1	; E
	spritePiece	8, 0, 2, 2, $5E4, 0, 0, 0, 1	; T
	spritePiece	$18, 0, 2, 2, $5E8, 0, 0, 0, 1	; R
	spritePiece	$28, 0, 2, 2, $588, 0, 0, 0, 1	; O
	spritePiece	$38, 0, 2, 2, $5EC, 0, 0, 0, 1	; P
	spritePiece	$48, 0, 2, 2, $588, 0, 0, 0, 1	; O
	spritePiece	$58, 0, 2, 2, $5F0, 0, 0, 0, 1	; L
	spritePiece	$68, 0, 1, 2, $5F4, 0, 0, 0, 1	; I
	spritePiece	$70, 0, 2, 2, $5F6, 0, 0, 0, 1	; S
TC_MTZ_End

; word_14894:
TC_HTZ:		spriteHeader	; HILL TOP
	spritePiece	8, 0, 2, 2, $5DE, 0, 0, 0, 1	; H
	spritePiece	$18, 0, 1, 2, $5E2, 0, 0, 0, 1	; I
	spritePiece	$20, 0, 2, 2, $5E4, 0, 0, 0, 1	; L
	spritePiece	$30, 0, 2, 2, $5E4, 0, 0, 0, 1	; L

	spritePiece	$51, 0, 2, 2, $5E8, 0, 0, 0, 1	; T
	spritePiece	$60, 0, 2, 2, $588, 0, 0, 0, 1	; O
	spritePiece	$70, 0, 2, 2, $5EC, 0, 0, 0, 1	; P
TC_HTZ_End

; word_148CE:
TC_HPZ:		spriteHeader	; HIDDEN PALACE
	spritePiece	-$48, 0, 2, 2, $5DE, 0, 0, 0, 1	; H
	spritePiece	-$38, 0, 1, 2, $5E2, 0, 0, 0, 1	; I
	spritePiece	-$30, 0, 2, 2, $5E4, 0, 0, 0, 1	; D
	spritePiece	-$20, 0, 2, 2, $5E4, 0, 0, 0, 1	; D
	spritePiece	-$10, 0, 2, 2, $580, 0, 0, 0, 1	; E
	spritePiece	0, 0, 2, 2, $584, 0, 0, 0, 1	; N

	spritePiece	$20, 0, 2, 2, $5E8, 0, 0, 0, 1	; P
	spritePiece	$30, 0, 2, 2, $5EC, 0, 0, 0, 1	; A
	spritePiece	$40, 0, 2, 2, $5F0, 0, 0, 0, 1	; L
	spritePiece	$50, 0, 2, 2, $5EC, 0, 0, 0, 1	; A
	spritePiece	$60, 0, 2, 2, $5F4, 0, 0, 0, 1	; C
	spritePiece	$70, 0, 2, 2, $580, 0, 0, 0, 1	; E
TC_HPZ_End

; word_14930:
TC_OOZ:		spriteHeader	; OIL OCEAN
	spritePiece	-5, 0, 2, 2, $588, 0, 0, 0, 1	; O
	spritePiece	$B, 0, 1, 2, $5DE, 0, 0, 0, 1	; I
	spritePiece	$13, 0, 2, 2, $5E0, 0, 0, 0, 1	; L

	spritePiece	$33, 0, 2, 2, $588, 0, 0, 0, 1	; O
	spritePiece	$43, 0, 2, 2, $5E4, 0, 0, 0, 1	; C
	spritePiece	$53, 0, 2, 2, $580, 0, 0, 0, 1	; E
	spritePiece	$60, 0, 2, 2, $5E8, 0, 0, 0, 1	; A
	spritePiece	$70, 0, 2, 2, $584, 0, 0, 0, 1	; N
TC_OOZ_End

; word_14972:
TC_MCZ:		spriteHeader	; MYSTIC CAVE
	spritePiece	-$30, 0, 3, 2, $5DE, 0, 0, 0, 1	; M
	spritePiece	-$18, 0, 2, 2, $5E4, 0, 0, 0, 1	; Y
	spritePiece	-8, 0, 2, 2, $5E8, 0, 0, 0, 1	; S
	spritePiece	8, 0, 2, 2, $5EC, 0, 0, 0, 1	; T
	spritePiece	$18, 0, 1, 2, $5F0, 0, 0, 0, 1	; I
	spritePiece	$20, 0, 2, 2, $5F2, 0, 0, 0, 1	; C

	spritePiece	$41, 0, 2, 2, $5F2, 0, 0, 0, 1	; C
	spritePiece	$50, 0, 2, 2, $5F6, 0, 0, 0, 1	; A
	spritePiece	$60, 0, 2, 2, $5FA, 0, 0, 0, 1	; V
	spritePiece	$70, 0, 2, 2, $580, 0, 0, 0, 1	; E
TC_MCZ_End

; word_149C4:
TC_CNZ:		spriteHeader	; CASINO NIGHT
	spritePiece	-$2F, 0, 2, 2, $5DE, 0, 0, 0, 1	; C
	spritePiece	-$20, 0, 2, 2, $5E2, 0, 0, 0, 1	; A
	spritePiece	-$10, 0, 2, 2, $5E6, 0, 0, 0, 1	; S
	spritePiece	0, 0, 1, 2, $5EA, 0, 0, 0, 1	; I
	spritePiece	8, 0, 2, 2, $584, 0, 0, 0, 1	; N
	spritePiece	$18, 0, 2, 2, $588, 0, 0, 0, 1	; O

	spritePiece	$38, 0, 2, 2, $584, 0, 0, 0, 1	; N
	spritePiece	$48, 0, 1, 2, $5EA, 0, 0, 0, 1	; I
	spritePiece	$50, 0, 2, 2, $5EC, 0, 0, 0, 1	; G
	spritePiece	$60, 0, 2, 2, $5F0, 0, 0, 0, 1	; H
	spritePiece	$70, 0, 2, 2, $5F4, 0, 0, 0, 1	; T
TC_CNZ_End

; word_14A1E:
TC_CPZ:		spriteHeader	; CHEMICAL PLANT
	spritePiece	-$5C, 0, 2, 2, $5DE, 0, 0, 0, 1	; C
	spritePiece	-$4C, 0, 2, 2, $5E2, 0, 0, 0, 1	; H
	spritePiece	-$3C, 0, 2, 2, $580, 0, 0, 0, 1	; E
	spritePiece	-$2F, 0, 3, 2, $5E6, 0, 0, 0, 1	; M
	spritePiece	-$17, 0, 1, 2, $5EC, 0, 0, 0, 1	; I
	spritePiece	-$F, 0, 2, 2, $5DE, 0, 0, 0, 1	; C
	spritePiece	0, 0, 2, 2, $5EE, 0, 0, 0, 1	; A
	spritePiece	$10, 0, 2, 2, $5F2, 0, 0, 0, 1	; L

	spritePiece	$31, 0, 2, 2, $5F6, 0, 0, 0, 1	; P
	spritePiece	$41, 0, 2, 2, $5F2, 0, 0, 0, 1	; L
	spritePiece	$50, 0, 2, 2, $5EE, 0, 0, 0, 1	; A
	spritePiece	$60, 0, 2, 2, $584, 0, 0, 0, 1	; N
	spritePiece	$70, 0, 2, 2, $5FA, 0, 0, 0, 1	; T
TC_CPZ_End

; word_14A88:
TC_ARZ:		spriteHeader	; AQUATIC RUIN
	spritePiece	-$2E, 0, 2, 2, $5DE, 0, 0, 0, 1	; A
	spritePiece	-$1E, 0, 2, 2, $5E2, 0, 0, 0, 1	; Q
	spritePiece	-$E, 0, 2, 2, $5E6, 0, 0, 0, 1	; U
	spritePiece	0, 0, 2, 2, $5DE, 0, 0, 0, 1	; A
	spritePiece	$10, 0, 2, 2, $5EA, 0, 0, 0, 1	; T
	spritePiece	$20, 0, 1, 2, $5EE, 0, 0, 0, 1	; I
	spritePiece	$28, 0, 2, 2, $5F0, 0, 0, 0, 1	; C

	spritePiece	$48, 0, 2, 2, $5F4, 0, 0, 0, 1	; R
	spritePiece	$58, 0, 2, 2, $5E6, 0, 0, 0, 1	; U
	spritePiece	$68, 0, 1, 2, $5EE, 0, 0, 0, 1	; I
	spritePiece	$70, 0, 2, 2, $584, 0, 0, 0, 1	; N
TC_ARZ_End

; word_14AE2:
TC_SCZ:		spriteHeader	; SKY CHASE
	spritePiece	-$10, 0, 2, 2, $5DE, 0, 0, 0, 1	; S
	spritePiece	0, 0, 2, 2, $5E2, 0, 0, 0, 1	; K
	spritePiece	$10, 0, 2, 2, $5E6, 0, 0, 0, 1	; Y

	spritePiece	$30, 0, 2, 2, $5EA, 0, 0, 0, 1	; C
	spritePiece	$40, 0, 2, 2, $5EE, 0, 0, 0, 1	; H
	spritePiece	$50, 0, 2, 2, $5F2, 0, 0, 0, 1	; A
	spritePiece	$60, 0, 2, 2, $5DE, 0, 0, 0, 1	; S
	spritePiece	$70, 0, 2, 2, $580, 0, 0, 0, 1	; E
TC_SCZ_End

; word_14B24:
TC_WFZ:		spriteHeader	; WING FORTRESS
	spritePiece	-$4F, 0, 3, 2, $5DE, 0, 0, 0, 1	; W
	spritePiece	-$38, 0, 1, 2, $5E4, 0, 0, 0, 1	; I
	spritePiece	-$30, 0, 2, 2, $584, 0, 0, 0, 1	; N
	spritePiece	-$20, 0, 2, 2, $5E6, 0, 0, 0, 1	; G

	spritePiece	1, 0, 2, 2, $5EA, 0, 0, 0, 1	; F
	spritePiece	$10, 0, 2, 2, $588, 0, 0, 0, 1	; O
	spritePiece	$20, 0, 2, 2, $5EE, 0, 0, 0, 1	; R
	spritePiece	$30, 0, 2, 2, $5F2, 0, 0, 0, 1	; T
	spritePiece	$40, 0, 2, 2, $5EE, 0, 0, 0, 1	; R
	spritePiece	$50, 0, 2, 2, $580, 0, 0, 0, 1	; E
	spritePiece	$5F, 0, 2, 2, $5F6, 0, 0, 0, 1	; S
	spritePiece	$6F, 0, 2, 2, $5F6, 0, 0, 0, 1	; S
TC_WFZ_End

; word_14B86:
TC_DEZ:		spriteHeader	; DEATH EGG
	spritePiece	-$E, 0, 2, 2, $5DE, 0, 0, 0, 1	; D
	spritePiece	2, 0, 2, 2, $580, 0, 0, 0, 1	; E
	spritePiece	$10, 0, 2, 2, $5E2, 0, 0, 0, 1	; A
	spritePiece	$20, 0, 2, 2, $5E6, 0, 0, 0, 1	; T
	spritePiece	$30, 0, 2, 2, $5EA, 0, 0, 0, 1	; H

	spritePiece	$51, 0, 2, 2, $580, 0, 0, 0, 1	; E
	spritePiece	$60, 0, 2, 2, $5EE, 0, 0, 0, 1	; G
	spritePiece	$70, 0, 2, 2, $5EE, 0, 0, 0, 1	; G
TC_DEZ_End


; Miscellaneous title card mappings

; word_14BC8:
TC_ZONE:	spriteHeader	; ZONE
	spritePiece	1, 0, 2, 2, $58C, 0, 0, 0, 1	; Z
	spritePiece	$10, 0, 2, 2, $588, 0, 0, 0, 1	; O
	spritePiece	$20, 0, 2, 2, $584, 0, 0, 0, 1	; N
	spritePiece	$30, 0, 2, 2, $580, 0, 0, 0, 1	; E
TC_ZONE_End

; word_14BEA:
TC_No1:		spriteHeader	; Act number 1
	spritePiece	0, 0, 2, 4, $590, 0, 0, 1, 1	; 1
TC_No1_End

; word_14BF4:
TC_No2:		spriteHeader	; Act number 2
	spritePiece	0, 0, 3, 4, $598, 0, 0, 1, 1	; 2
TC_No2_End

; word_14BFE:
TC_No3:		spriteHeader	; Act number 3
	spritePiece	0, 0, 3, 4, $5A4, 0, 0, 1, 1	; 3
TC_No3_End

; word_14C08:
TC_STH:		spriteHeader	; "SONIC THE HEDGEHOG" text
	spritePiece	-$48, 0, 4, 2, $5B0, 0, 0, 0, 1
	spritePiece	-$28, 0, 4, 2, $5B8, 0, 0, 0, 1
	spritePiece	-8, 0, 4, 2, $5C0, 0, 0, 0, 1
	spritePiece	$18, 0, 4, 2, $5C8, 0, 0, 0, 1
	spritePiece	$38, 0, 2, 2, $5D0, 0, 0, 0, 1
TC_STH_End

; word_14C32:
TC_RedStripes:	spriteHeader	; Red stripes
	spritePiece	0, -$70, 1, 4, $5D4, 0, 0, 0, 1
	spritePiece	0, -$50, 1, 4, $5D4, 0, 0, 0, 1
	spritePiece	0, -$30, 1, 4, $5D4, 0, 0, 0, 1
	spritePiece	0, -$10, 1, 4, $5D4, 0, 0, 0, 1
	spritePiece	0, $10, 1, 4, $5D4, 0, 0, 0, 1
	spritePiece	0, $30, 1, 4, $5D4, 0, 0, 0, 1
	spritePiece	0, $50, 1, 4, $5D4, 0, 0, 0, 1
TC_RedStripes_End

	even
