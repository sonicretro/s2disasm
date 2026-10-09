;---------------------------------------------------------------------------------------
; Offset index of level layouts
; Two entries per zone, pointing to the level layouts for acts 1 and 2 of each zone
; respectively.
;---------------------------------------------------------------------------------------
Off_Level: zoneOrderedOffsetTable 2,2
	; EHZ
	zoneOffsetTableEntry.w Level_EHZ1	; Act 1
	zoneOffsetTableEntry.w Level_EHZ2	; Act 2
	; Zone 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 2
	; WZ
	zoneOffsetTableEntry.w Level_Invalid	; Act 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 2
	; Zone 3
	zoneOffsetTableEntry.w Level_Invalid	; Act 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 2
	; MTZ
	zoneOffsetTableEntry.w Level_MTZ1	; Act 1
	zoneOffsetTableEntry.w Level_MTZ2	; Act 2
	; MTZ
	zoneOffsetTableEntry.w Level_MTZ3	; Act 3
	zoneOffsetTableEntry.w Level_MTZ3	; Act 4
	; WFZ
	zoneOffsetTableEntry.w Level_WFZ	; Act 1
	zoneOffsetTableEntry.w Level_WFZ	; Act 2
	; HTZ
	zoneOffsetTableEntry.w Level_HTZ1	; Act 1
	zoneOffsetTableEntry.w Level_HTZ2	; Act 2
	; HPZ
	zoneOffsetTableEntry.w Level_HPZ1	; Act 1
	zoneOffsetTableEntry.w Level_HPZ1	; Act 2
	; Zone 9
	zoneOffsetTableEntry.w Level_Invalid	; Act 1
	zoneOffsetTableEntry.w Level_Invalid	; Act 2
	; OOZ
	zoneOffsetTableEntry.w Level_OOZ1	; Act 1
	zoneOffsetTableEntry.w Level_OOZ2	; Act 2
	; MCZ
	zoneOffsetTableEntry.w Level_MCZ1	; Act 1
	zoneOffsetTableEntry.w Level_MCZ2	; Act 2
	; CNZ
	zoneOffsetTableEntry.w Level_CNZ1	; Act 1
	zoneOffsetTableEntry.w Level_CNZ2	; Act 2
	; CPZ
	zoneOffsetTableEntry.w Level_CPZ1	; Act 1
	zoneOffsetTableEntry.w Level_CPZ2	; Act 2
	; DEZ
	zoneOffsetTableEntry.w Level_DEZ	; Act 1
	zoneOffsetTableEntry.w Level_DEZ	; Act 2
	; ARZ
	zoneOffsetTableEntry.w Level_ARZ1	; Act 1
	zoneOffsetTableEntry.w Level_ARZ2	; Act 2
	; SCZ
	zoneOffsetTableEntry.w Level_SCZ	; Act 1
	zoneOffsetTableEntry.w Level_SCZ	; Act 2
    zoneTableEnd

; These are all compressed in the Kosinski format.
Level_Invalid:
Level_EHZ1:	BINCLUDE	"level/layout/EHZ_1.kos"
	even
Level_EHZ2:	BINCLUDE	"level/layout/EHZ_2.kos"
	even
Level_MTZ1:	BINCLUDE	"level/layout/MTZ_1.kos"
	even
Level_MTZ2:	BINCLUDE	"level/layout/MTZ_2.kos"
	even
Level_MTZ3:	BINCLUDE	"level/layout/MTZ_3.kos"
	even
Level_WFZ:	BINCLUDE	"level/layout/WFZ.kos"
	even
Level_HTZ1:	BINCLUDE	"level/layout/HTZ_1.kos"
	even
Level_HTZ2:	BINCLUDE	"level/layout/HTZ_2.kos"
	even
Level_HPZ1:	;BINCLUDE	"level/layout/HPZ_1.kos"
	;even
Level_OOZ1:	BINCLUDE	"level/layout/OOZ_1.kos"
	even
Level_OOZ2:	BINCLUDE	"level/layout/OOZ_2.kos"
	even
Level_MCZ1:	BINCLUDE	"level/layout/MCZ_1.kos"
	even
Level_MCZ2:	BINCLUDE	"level/layout/MCZ_2.kos"
	even
Level_CNZ1:	BINCLUDE	"level/layout/CNZ_1.kos"
	even
Level_CNZ2:	BINCLUDE	"level/layout/CNZ_2.kos"
	even
Level_CPZ1:	BINCLUDE	"level/layout/CPZ_1.kos"
	even
Level_CPZ2:	BINCLUDE	"level/layout/CPZ_2.kos"
	even
Level_DEZ:	BINCLUDE	"level/layout/DEZ.kos"
	even
Level_ARZ1:	BINCLUDE	"level/layout/ARZ_1.kos"
	even
Level_ARZ2:	BINCLUDE	"level/layout/ARZ_2.kos"
	even
Level_SCZ:	BINCLUDE	"level/layout/SCZ.kos"
	even
