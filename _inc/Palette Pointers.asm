; ===========================================================================
;----------------------------------------------------------------------------
; Palette pointers
; (PALETTE DESCRIPTOR ARRAY)
; This struct array defines the palette to use for each level.
;----------------------------------------------------------------------------

palptr	macro	ptr,lineno
	dc.l ptr	; Pointer to palette
	dc.w (Normal_palette+lineno*palette_line_size)&$FFFF	; Location in ram to load palette into
	dc.w bytesToLcnt(ptr_End-ptr)	; Size of palette in (bytes / 4)
	endm

PalPointers:
PalPtr_SEGA:	palptr Pal_SEGA,  0
PalPtr_Title:	palptr Pal_Title, 1
PalPtr_MenuB:	palptr Pal_MenuB, 0
PalPtr_BGND:	palptr Pal_BGND,  0
PalPtr_EHZ:	palptr Pal_EHZ,   1
PalPtr_EHZ2:	palptr Pal_EHZ,   1
PalPtr_WZ:	palptr Pal_WZ,    1
PalPtr_EHZ3:	palptr Pal_EHZ,   1
PalPtr_MTZ:	palptr Pal_MTZ,   1
PalPtr_MTZ2:	palptr Pal_MTZ,   1
PalPtr_WFZ:	palptr Pal_WFZ,   1
PalPtr_HTZ:	palptr Pal_HTZ,   1
PalPtr_HPZ:	palptr Pal_HPZ,   1
PalPtr_EHZ4:	palptr Pal_EHZ,   1
PalPtr_OOZ:	palptr Pal_OOZ,   1
PalPtr_MCZ:	palptr Pal_MCZ,   1
PalPtr_CNZ:	palptr Pal_CNZ,   1
PalPtr_CPZ:	palptr Pal_CPZ,   1
PalPtr_DEZ:	palptr Pal_DEZ,   1
PalPtr_ARZ:	palptr Pal_ARZ,   1
PalPtr_SCZ:	palptr Pal_SCZ,   1
PalPtr_HPZ_U:	palptr Pal_HPZ_U, 0
PalPtr_CPZ_U:	palptr Pal_CPZ_U, 0
PalPtr_ARZ_U:	palptr Pal_ARZ_U, 0
PalPtr_SS:	palptr Pal_SS,    0
PalPtr_MCZ_B:	palptr Pal_MCZ_B, 1
PalPtr_CNZ_B:	palptr Pal_CNZ_B, 1
PalPtr_SS1:	palptr Pal_SS1,   3
PalPtr_SS2:	palptr Pal_SS2,   3
PalPtr_SS3:	palptr Pal_SS3,   3
PalPtr_SS4:	palptr Pal_SS4,   3
PalPtr_SS5:	palptr Pal_SS5,   3
PalPtr_SS6:	palptr Pal_SS6,   3
PalPtr_SS7:	palptr Pal_SS7,   3
PalPtr_SS1_2p:	palptr Pal_SS1_2p,3
PalPtr_SS2_2p:	palptr Pal_SS2_2p,3
PalPtr_SS3_2p:	palptr Pal_SS3_2p,3
PalPtr_OOZ_B:	palptr Pal_OOZ_B, 1
PalPtr_Menu:	palptr Pal_Menu,  0
PalPtr_Result:	palptr Pal_Result,0