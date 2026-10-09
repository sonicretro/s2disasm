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

; ----------------------------------------------------------------------------
; This macro defines Pal_ABC and Pal_ABC_End, so palptr can compute the size of
; the palette automatically
; path2 is used for the Sonic and Tails palette, which has 2 palette lines
palette macro {INTLABEL},path,path2
__LABEL__ label *
	BINCLUDE "art/palettes/path"
    if "path2"<>""
	BINCLUDE "art/palettes/path2"
    endif
__LABEL___End label *
	endm

Pal_SEGA:  palette Sega screen.bin ; SEGA screen palette (Sonic and initial background)
Pal_Title: palette Title screen.bin ; Title screen Palette
Pal_MenuB: palette S2B Level Select.bin ; Leftover S2B level select palette
Pal_BGND:  palette SonicAndTails.bin,SonicAndTails2.bin ; "Sonic and Miles" background palette (also usually the primary palette line)
Pal_EHZ:   palette EHZ.bin ; Emerald Hill Zone palette
Pal_WZ:    palette Wood Zone.bin ; Wood Zone palette
Pal_MTZ:   palette MTZ.bin ; Metropolis Zone palette
Pal_WFZ:   palette WFZ.bin ; Wing Fortress Zone palette
Pal_HTZ:   palette HTZ.bin ; Hill Top Zone palette
Pal_HPZ:   palette HPZ.bin ; Hidden Palace Zone palette
Pal_HPZ_U: palette HPZ underwater.bin ; Hidden Palace Zone underwater palette
Pal_OOZ:   palette OOZ.bin ; Oil Ocean Zone palette
Pal_MCZ:   palette MCZ.bin ; Mystic Cave Zone palette
Pal_CNZ:   palette CNZ.bin ; Casino Night Zone palette
Pal_CPZ:   palette CPZ.bin ; Chemical Plant Zone palette
Pal_CPZ_U: palette CPZ underwater.bin ; Chemical Plant Zone underwater palette
Pal_DEZ:   palette DEZ.bin ; Death Egg Zone palette
Pal_ARZ:   palette ARZ.bin ; Aquatic Ruin Zone palette
Pal_ARZ_U: palette ARZ underwater.bin ; Aquatic Ruin Zone underwater palette
Pal_SCZ:   palette SCZ.bin ; Sky Chase Zone palette
Pal_MCZ_B: palette MCZ Boss.bin ; Mystic Cave Zone boss palette
Pal_CNZ_B: palette CNZ Boss.bin ; Casino Night Zone boss palette
Pal_OOZ_B: palette OOZ Boss.bin ; Oil Ocean Zone boss palette
Pal_Menu:  palette Menu.bin ; Menu palette
Pal_SS:    palette Special Stage Main.bin ; Special Stage palette
Pal_SS1:   palette Special Stage 1.bin ; Special Stage 1 palette
Pal_SS2:   palette Special Stage 2.bin ; Special Stage 2 palette
Pal_SS3:   palette Special Stage 3.bin ; Special Stage 3 palette
Pal_SS4:   palette Special Stage 4.bin ; Special Stage 4 palette
Pal_SS5:   palette Special Stage 5.bin ; Special Stage 5 palette
Pal_SS6:   palette Special Stage 6.bin ; Special Stage 6 palette
Pal_SS7:   palette Special Stage 7.bin ; Special Stage 7 palette
Pal_SS1_2p:palette Special Stage 1 2p.bin ; Special Stage 1 2p palette
Pal_SS2_2p:palette Special Stage 2 2p.bin ; Special Stage 2 2p palette
Pal_SS3_2p:palette Special Stage 3 2p.bin ; Special Stage 3 2p palette
Pal_Result:palette Special Stage Results Screen.bin ; Special Stage Results Screen palette
; ===========================================================================

	jmpTos ; Empty
