;--------------------------------------------------------------------------------------
; Offset index of ring locations
;  The first commented number on each line is an array index; the second is the
;  associated zone.
;--------------------------------------------------------------------------------------
Off_Rings: zoneOrderedOffsetTable 2,2
	; EHZ
	zoneOffsetTableEntry.w  Rings_EHZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_EHZ_2	; Act 2
	; Zone 1
	zoneOffsetTableEntry.w  Rings_Lev1_1	; Act 1
	zoneOffsetTableEntry.w  Rings_Lev1_2	; Act 2
	; WZ
	zoneOffsetTableEntry.w  Rings_WZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_WZ_2	; Act 2
	; Zone 3
	zoneOffsetTableEntry.w  Rings_Lev3_1	; Act 1
	zoneOffsetTableEntry.w  Rings_Lev3_2	; Act 2
	; MTZ
	zoneOffsetTableEntry.w  Rings_MTZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_MTZ_2	; Act 2
	; MTZ
	zoneOffsetTableEntry.w  Rings_MTZ_3	; Act 3
	zoneOffsetTableEntry.w  Rings_MTZ_4	; Act 4
	; WFZ
	zoneOffsetTableEntry.w  Rings_WFZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_WFZ_2	; Act 2
	; HTZ
	zoneOffsetTableEntry.w  Rings_HTZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_HTZ_2	; Act 2
	; HPZ
	zoneOffsetTableEntry.w  Rings_HPZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_HPZ_2	; Act 2
	; Zone 9
	zoneOffsetTableEntry.w  Rings_Lev9_1	; Act 1
	zoneOffsetTableEntry.w  Rings_Lev9_2	; Act 2
	; OOZ
	zoneOffsetTableEntry.w  Rings_OOZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_OOZ_2	; Act 2
	; MCZ
	zoneOffsetTableEntry.w  Rings_MCZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_MCZ_2	; Act 2
	; CNZ
	zoneOffsetTableEntry.w  Rings_CNZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_CNZ_2	; Act 2
	; CPZ
	zoneOffsetTableEntry.w  Rings_CPZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_CPZ_2	; Act 2
	; DEZ
	zoneOffsetTableEntry.w  Rings_DEZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_DEZ_2	; Act 2
	; ARZ
	zoneOffsetTableEntry.w  Rings_ARZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_ARZ_2	; Act 2
	; SCZ
	zoneOffsetTableEntry.w  Rings_SCZ_1	; Act 1
	zoneOffsetTableEntry.w  Rings_SCZ_2	; Act 2
    zoneTableEnd

Rings_EHZ_1:	BINCLUDE	"level/rings/EHZ_1.bin"
Rings_EHZ_2:	BINCLUDE	"level/rings/EHZ_2.bin"
Rings_Lev1_1:	BINCLUDE	"level/rings/01_1.bin"
Rings_Lev1_2:	BINCLUDE	"level/rings/01_2.bin"
Rings_WZ_1:	BINCLUDE	"level/rings/WZ_1.bin"
Rings_WZ_2:	BINCLUDE	"level/rings/WZ_2.bin"
Rings_Lev3_1:	BINCLUDE	"level/rings/03_1.bin"
Rings_Lev3_2:	BINCLUDE	"level/rings/03_2.bin"
Rings_MTZ_1:	BINCLUDE	"level/rings/MTZ_1.bin"
Rings_MTZ_2:	BINCLUDE	"level/rings/MTZ_2.bin"
Rings_MTZ_3:	BINCLUDE	"level/rings/MTZ_3.bin"
Rings_MTZ_4:	BINCLUDE	"level/rings/MTZ_4.bin"
Rings_HTZ_1:	BINCLUDE	"level/rings/HTZ_1.bin"
Rings_HTZ_2:	BINCLUDE	"level/rings/HTZ_2.bin"
Rings_HPZ_1:	BINCLUDE	"level/rings/HPZ_1.bin"
Rings_HPZ_2:	BINCLUDE	"level/rings/HPZ_2.bin"
Rings_Lev9_1:	BINCLUDE	"level/rings/09_1.bin"
Rings_Lev9_2:	BINCLUDE	"level/rings/09_2.bin"
Rings_OOZ_1:	BINCLUDE	"level/rings/OOZ_1.bin"
Rings_OOZ_2:	BINCLUDE	"level/rings/OOZ_2.bin"
Rings_MCZ_1:	BINCLUDE	"level/rings/MCZ_1.bin"
Rings_MCZ_2:	BINCLUDE	"level/rings/MCZ_2.bin"
Rings_CNZ_1:	BINCLUDE	"level/rings/CNZ_1.bin"
Rings_CNZ_2:	BINCLUDE	"level/rings/CNZ_2.bin"
Rings_CPZ_1:	BINCLUDE	"level/rings/CPZ_1.bin"
Rings_CPZ_2:	BINCLUDE	"level/rings/CPZ_2.bin"
Rings_DEZ_1:	BINCLUDE	"level/rings/DEZ_1.bin"
Rings_DEZ_2:	BINCLUDE	"level/rings/DEZ_2.bin"
Rings_WFZ_1:	BINCLUDE	"level/rings/WFZ_1.bin"
Rings_WFZ_2:	BINCLUDE	"level/rings/WFZ_2.bin"
Rings_ARZ_1:	BINCLUDE	"level/rings/ARZ_1.bin"
Rings_ARZ_2:	BINCLUDE	"level/rings/ARZ_2.bin"
Rings_SCZ_1:	BINCLUDE	"level/rings/SCZ_1.bin"
Rings_SCZ_2:	BINCLUDE	"level/rings/SCZ_2.bin"
