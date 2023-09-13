; --------------------------------------------------------------------------------------
; Offset index of object locations
; --------------------------------------------------------------------------------------
Off_Objects: zoneOrderedOffsetTable 2,2
	; EHZ
	zoneOffsetTableEntry.w  Objects_EHZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_EHZ_2	; Act 2
	; Zone 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 2
	; WZ
	zoneOffsetTableEntry.w  Objects_Null	; Act 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 2
	; Zone 3
	zoneOffsetTableEntry.w  Objects_Null	; Act 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 2
	; MTZ
	zoneOffsetTableEntry.w  Objects_MTZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_MTZ_2	; Act 2
	; MTZ
	zoneOffsetTableEntry.w  Objects_MTZ_3	; Act 3
	zoneOffsetTableEntry.w  Objects_MTZ_3	; Act 4
	; WFZ
	zoneOffsetTableEntry.w  Objects_WFZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_WFZ_2	; Act 2
	; HTZ
	zoneOffsetTableEntry.w  Objects_HTZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_HTZ_2	; Act 2
	; HPZ
	zoneOffsetTableEntry.w  Objects_HPZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_HPZ_2	; Act 2
	; Zone 9
	zoneOffsetTableEntry.w  Objects_Null	; Act 1
	zoneOffsetTableEntry.w  Objects_Null	; Act 2
	; OOZ
	zoneOffsetTableEntry.w  Objects_OOZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_OOZ_2	; Act 2
	; MCZ
	zoneOffsetTableEntry.w  Objects_MCZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_MCZ_2	; Act 2
	; CNZ
	zoneOffsetTableEntry.w  Objects_CNZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_CNZ_2	; Act 2
	; CPZ
	zoneOffsetTableEntry.w  Objects_CPZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_CPZ_2	; Act 2
	; DEZ
	zoneOffsetTableEntry.w  Objects_DEZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_DEZ_2	; Act 2
	; ARZ
	zoneOffsetTableEntry.w  Objects_ARZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_ARZ_2	; Act 2
	; SCZ
	zoneOffsetTableEntry.w  Objects_SCZ_1	; Act 1
	zoneOffsetTableEntry.w  Objects_SCZ_2	; Act 2
    zoneTableEnd

	; These things act as boundaries for the object layout parser, so it doesn't read past the end/beginning of the file
	ObjectLayoutBoundary
Objects_EHZ_1:	BINCLUDE	"level/objects/EHZ_1.bin"
	ObjectLayoutBoundary

    if gameRevision=0
; A collision switcher was improperly placed
Objects_EHZ_2:	BINCLUDE	"level/objects/EHZ_2 (REV00).bin"
    else
Objects_EHZ_2:	BINCLUDE	"level/objects/EHZ_2.bin"
    endif

	ObjectLayoutBoundary
Objects_MTZ_1:	BINCLUDE	"level/objects/MTZ_1.bin"
	ObjectLayoutBoundary
Objects_MTZ_2:	BINCLUDE	"level/objects/MTZ_2.bin"
	ObjectLayoutBoundary
Objects_MTZ_3:	BINCLUDE	"level/objects/MTZ_3.bin"
	ObjectLayoutBoundary

    if gameRevision=0
; The lampposts were bugged: their 'remember state' flags weren't set
Objects_WFZ_1:	BINCLUDE	"level/objects/WFZ_1 (REV00).bin"
    else
Objects_WFZ_1:	BINCLUDE	"level/objects/WFZ_1.bin"
    endif

	ObjectLayoutBoundary
Objects_WFZ_2:	BINCLUDE	"level/objects/WFZ_2.bin"
	ObjectLayoutBoundary
Objects_HTZ_1:	BINCLUDE	"level/objects/HTZ_1.bin"
	ObjectLayoutBoundary
Objects_HTZ_2:	BINCLUDE	"level/objects/HTZ_2.bin"
	ObjectLayoutBoundary
Objects_HPZ_1:	BINCLUDE	"level/objects/HPZ_1.bin"
	ObjectLayoutBoundary
Objects_HPZ_2:	BINCLUDE	"level/objects/HPZ_2.bin"
	ObjectLayoutBoundary
	; Oddly, there's a gap for another layout here
	ObjectLayoutBoundary
Objects_OOZ_1:	BINCLUDE	"level/objects/OOZ_1.bin"
	ObjectLayoutBoundary
Objects_OOZ_2:	BINCLUDE	"level/objects/OOZ_2.bin"
	ObjectLayoutBoundary
Objects_MCZ_1:	BINCLUDE	"level/objects/MCZ_1.bin"
	ObjectLayoutBoundary
Objects_MCZ_2:	BINCLUDE	"level/objects/MCZ_2.bin"
	ObjectLayoutBoundary

    if gameRevision=0
; The signposts are too low, causing them to poke out the bottom of the ground
Objects_CNZ_1:	BINCLUDE	"level/objects/CNZ_1 (REV00).bin"
	ObjectLayoutBoundary
Objects_CNZ_2:	BINCLUDE	"level/objects/CNZ_2 (REV00).bin"
    else
Objects_CNZ_1:	BINCLUDE	"level/objects/CNZ_1.bin"
	ObjectLayoutBoundary
Objects_CNZ_2:	BINCLUDE	"level/objects/CNZ_2.bin"
    endif

	ObjectLayoutBoundary
Objects_CPZ_1:	BINCLUDE	"level/objects/CPZ_1.bin"
	ObjectLayoutBoundary
Objects_CPZ_2:	BINCLUDE	"level/objects/CPZ_2.bin"
	ObjectLayoutBoundary
Objects_DEZ_1:	BINCLUDE	"level/objects/DEZ_1.bin"
	ObjectLayoutBoundary
Objects_DEZ_2:	BINCLUDE	"level/objects/DEZ_2.bin"
	ObjectLayoutBoundary
Objects_ARZ_1:	BINCLUDE	"level/objects/ARZ_1.bin"
	ObjectLayoutBoundary
Objects_ARZ_2:	BINCLUDE	"level/objects/ARZ_2.bin"
	ObjectLayoutBoundary
Objects_SCZ_1:	BINCLUDE	"level/objects/SCZ_1.bin"
	ObjectLayoutBoundary
Objects_SCZ_2:	BINCLUDE	"level/objects/SCZ_2.bin"
	ObjectLayoutBoundary
Objects_Null:
	ObjectLayoutBoundary
	; Another strange space for a layout
	ObjectLayoutBoundary
	; And another
	ObjectLayoutBoundary
	; And another
	ObjectLayoutBoundary
