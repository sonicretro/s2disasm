; ------------------------------------------------------------------------
; MENU ANIMATION SCRIPT
; ------------------------------------------------------------------------
;word_87C6:
Anim_SonicMilesBG:	zoneanimstart
	; Sonic/Miles animated background
	zoneanimdecl  -1, ArtUnc_MenuBack,    1,  6, $A
	dc.b   0,$C7
	dc.b  $A,  5
	dc.b $14,  5
	dc.b $1E,$C7
	dc.b $14,  5
	dc.b  $A,  5
	even

	zoneanimend

; off_87DC:
TwoPlayerResultsPointers:
VsResultsScreen_Act:	dc.l Map_2PActResults, Setup2PResults_Act
VsResultsScreen_Zone:	dc.l Map_2PZoneResults, Setup2PResults_Zone
VsResultsScreen_Game:	dc.l Map_2PGameResults, Setup2PResults_Game
VsResultsScreen_SS:	dc.l Map_2PSpecialStageActResults, Setup2PResults_SpecialAct
VsResultsScreen_SSZone:	dc.l Map_2PSpecialStageZoneResults, Setup2PResults_SpecialZone

; 2P single act results screen (enigma compressed)
; byte_8804:
Map_2PActResults:	BINCLUDE "mappings/misc/2P Act Results.eni"

; 2P zone results screen (enigma compressed)
; byte_88CE:
Map_2PZoneResults:	BINCLUDE "mappings/misc/2P Zone Results.eni"

; 2P game results screen (after all 4 zones) (enigma compressed)
; byte_8960:
Map_2PGameResults:	BINCLUDE "mappings/misc/2P Game Results.eni"

; 2P special stage act results screen (enigma compressed)
; byte_8AA4:
Map_2PSpecialStageActResults:	BINCLUDE "mappings/misc/2P Special Stage Act Results.eni"

; 2P special stage zone results screen (enigma compressed)
; byte_8B30:
Map_2PSpecialStageZoneResults:	BINCLUDE "mappings/misc/2P Special Stage Zone Results.eni"

	even

	jmpTos JmpTo2_Adjust2PArtPointer,JmpTo_Dynamic_Normal




; ===========================================================================
