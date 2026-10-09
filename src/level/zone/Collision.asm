;---------------------------------------------------------------------------------------
; Collision Data
;---------------------------------------------------------------------------------------
ColCurveMap:		BINCLUDE	"collision/Curve and resistance mapping.bin"
	even
ColArrayVertical:	BINCLUDE	"collision/Collision array - Vertical.bin"
ColArrayHorizontal:	BINCLUDE	"collision/Collision array - Horizontal.bin"
	even

; These are all compressed in the Kosinski format.
ColP_EHZHTZ:	BINCLUDE	"collision/EHZ and HTZ primary 16x16 collision index.kos"
	even
ColS_EHZHTZ:	BINCLUDE	"collision/EHZ and HTZ secondary 16x16 collision index.kos"
	even
ColP_WZ:	;BINCLUDE	"collision/WZ primary 16x16 collision index.kos"
	;even
ColP_MTZ:	BINCLUDE	"collision/MTZ primary 16x16 collision index.kos"
	even
ColP_HPZ:	;BINCLUDE	"collision/HPZ primary 16x16 collision index.kos"
	;even
ColS_HPZ:	;BINCLUDE	"collision/HPZ secondary 16x16 collision index.kos"
	;even
ColP_OOZ:	BINCLUDE	"collision/OOZ primary 16x16 collision index.kos"
	even
ColP_MCZ:	BINCLUDE	"collision/MCZ primary 16x16 collision index.kos"
	even
ColP_CNZ:	BINCLUDE	"collision/CNZ primary 16x16 collision index.kos"
	even
ColS_CNZ:	BINCLUDE	"collision/CNZ secondary 16x16 collision index.kos"
	even
ColP_CPZDEZ:	BINCLUDE	"collision/CPZ and DEZ primary 16x16 collision index.kos"
	even
ColS_CPZDEZ:	BINCLUDE	"collision/CPZ and DEZ secondary 16x16 collision index.kos"
	even
ColP_ARZ:	BINCLUDE	"collision/ARZ primary 16x16 collision index.kos"
	even
ColS_ARZ:	BINCLUDE	"collision/ARZ secondary 16x16 collision index.kos"
	even
ColP_WFZSCZ:	BINCLUDE	"collision/WFZ and SCZ primary 16x16 collision index.kos"
	even
ColS_WFZSCZ:	BINCLUDE	"collision/WFZ and SCZ secondary 16x16 collision index.kos"
	even
ColP_Invalid:
