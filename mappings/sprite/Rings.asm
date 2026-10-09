; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------

; Custom mappings format. Compare to Obj25_MapUnc_12382.

; Differences include...
;  No 'sprite pieces per frame' value (hardcoded to 1)

; This was customised even further in Sonic 3 & Knuckles.

; off_1736A:
MapUnc_Rings: mappingsTable
	mappingsTableEntry.w .frame1
	mappingsTableEntry.w .frame2
	mappingsTableEntry.w .frame3
	mappingsTableEntry.w .frame4
	mappingsTableEntry.w .frame5
	mappingsTableEntry.w .frame6
	mappingsTableEntry.w .frame7
	mappingsTableEntry.w .frame8

.frame1:
	spritePiece	-8, -8, 2, 2, 0, 0, 0, 0, 0

.frame2:
	spritePiece	-8, -8, 2, 2, 4, 0, 0, 0, 0

.frame3:
	spritePiece	-4, -8, 1, 2, 8, 0, 0, 0, 0

.frame4:
	spritePiece	-8, -8, 2, 2, 4, 1, 0, 0, 0

.frame5:
	spritePiece	-8, -8, 2, 2, $A, 0, 0, 0, 0

.frame6:
	spritePiece	-8, -8, 2, 2, $A, 1, 1, 0, 0

.frame7:
	spritePiece	-8, -8, 2, 2, $A, 1, 0, 0, 0

.frame8:
	spritePiece	-8, -8, 2, 2, $A, 0, 1, 0, 0

	jmpTos0 ; Empty
