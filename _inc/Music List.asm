;----------------------------------------------------------------------------
; 1P Music Playlist
;----------------------------------------------------------------------------
; byte_3EA0:
MusicList: zoneOrderedTable 1,1
	zoneTableEntry.b MusID_EHZ	; EHZ
	zoneTableEntry.b MusID_EHZ	; Zone 1
	zoneTableEntry.b MusID_MTZ	; WZ
	zoneTableEntry.b MusID_OOZ	; Zone 3
	zoneTableEntry.b MusID_MTZ	; MTZ1,2
	zoneTableEntry.b MusID_MTZ	; MTZ3
	zoneTableEntry.b MusID_WFZ	; WFZ
	zoneTableEntry.b MusID_HTZ	; HTZ
	zoneTableEntry.b MusID_HPZ	; HPZ
	zoneTableEntry.b MusID_SCZ	; Zone 9
	zoneTableEntry.b MusID_OOZ	; OOZ
	zoneTableEntry.b MusID_MCZ	; MCZ
	zoneTableEntry.b MusID_CNZ	; CNZ
	zoneTableEntry.b MusID_CPZ	; CPZ
	zoneTableEntry.b MusID_DEZ	; DEZ
	zoneTableEntry.b MusID_ARZ	; ARZ
	zoneTableEntry.b MusID_SCZ	; SCZ
    zoneTableEnd
	even
;----------------------------------------------------------------------------
; 2P Music Playlist
;----------------------------------------------------------------------------
; byte_3EB2:
MusicList2: zoneOrderedTable 1,1
	zoneTableEntry.b MusID_EHZ_2P	; EHZ
	zoneTableEntry.b MusID_EHZ	; Zone 1
	zoneTableEntry.b MusID_MTZ	; WZ
	zoneTableEntry.b MusID_OOZ	; Zone 3
	zoneTableEntry.b MusID_MTZ	; MTZ1,2
	zoneTableEntry.b MusID_MTZ	; MTZ3
	zoneTableEntry.b MusID_WFZ	; WFZ
	zoneTableEntry.b MusID_HTZ	; HTZ
	zoneTableEntry.b MusID_HPZ	; HPZ
	zoneTableEntry.b MusID_SCZ	; Zone 9
	zoneTableEntry.b MusID_OOZ	; OOZ
	zoneTableEntry.b MusID_MCZ_2P	; MCZ
	zoneTableEntry.b MusID_CNZ_2P	; CNZ
	zoneTableEntry.b MusID_CPZ	; CPZ
	zoneTableEntry.b MusID_DEZ	; DEZ
	zoneTableEntry.b MusID_ARZ	; ARZ
	zoneTableEntry.b MusID_SCZ	; SCZ
    zoneTableEnd
	even
; ===========================================================================
