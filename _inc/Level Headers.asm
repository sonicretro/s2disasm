; ---------------------------------------------------------------------------
; "MAIN LEVEL LOAD BLOCK" (after Nemesis)
;
; This struct array tells the engine where to find all the art associated with
; a particular zone. Each zone gets three longwords, in which it stores three
; pointers (in the lower 24 bits) and three jump table indeces (in the upper eight
; bits). The assembled data looks something like this:
;
; aaBBBBBB
; ccDDDDDD
; eeFFFFFF
;
; aa = index for primary pattern load request list
; BBBBBB = pointer to level art
; cc = index for secondary pattern load request list
; DDDDDD = pointer to 16x16 block mappings
; ee = index for palette
; FFFFFF = pointer to 128x128 block mappings
;
; Nemesis refers to this as the "main level load block". However, that name implies
; that this is code (obviously, it isn't), or at least that it points to the level's
; collision, object and ring placement arrays (it only points to art...
; although the 128x128 mappings do affect the actual level layout and collision)
; ---------------------------------------------------------------------------

; declare some global variables to be used by the levartptrs macro
cur_zone_id := 0
cur_zone_str := "0"

; macro for declaring a "main level load block" (MLLB)
levartptrs macro plc1,plc2,palette,art,map16x16,map128x128
	!org LevelArtPointers+zone_id_{cur_zone_str}*12
	dc.l (plc1<<24)|art
	dc.l (plc2<<24)|map16x16
	dc.l (palette<<24)|map128x128
cur_zone_id := cur_zone_id+1
cur_zone_str := "\{cur_zone_id}"
    endm

; BEGIN SArt_Ptrs Art_Ptrs_Array[17]
; dword_42594: MainLoadBlocks: saArtPtrs:
LevelArtPointers:
	levartptrs PLCID_Ehz1,        PLCID_Ehz2,      PalID_EHZ,  ArtKos_EHZ, BM16_EHZ, BM128_EHZ ; EHZ    ; EMERALD HILL ZONE
	levartptrs PLCID_MilesLife2P, PLCID_MilesLife, PalID_EHZ2, ArtKos_EHZ, BM16_EHZ, BM128_EHZ ; Zone 1 ; LEVEL 1 (UNUSED)
	levartptrs PLCID_TailsLife2P, PLCID_TailsLife, PalID_WZ,   ArtKos_EHZ, BM16_EHZ, BM128_EHZ ; WZ     ; WOOD ZONE (UNUSED)
	levartptrs PLCID_Unused1,     PLCID_Unused2,   PalID_EHZ3, ArtKos_EHZ, BM16_EHZ, BM128_EHZ ; Zone 3 ; LEVEL 3 (UNUSED)
	levartptrs PLCID_Mtz1,        PLCID_Mtz2,      PalID_MTZ,  ArtKos_MTZ, BM16_MTZ, BM128_MTZ ; MTZ1,2 ; METROPOLIS ZONE ACTS 1 & 2
	levartptrs PLCID_Mtz1,        PLCID_Mtz2,      PalID_MTZ,  ArtKos_MTZ, BM16_MTZ, BM128_MTZ ; MTZ3   ; METROPOLIS ZONE ACT 3
	levartptrs PLCID_Wfz1,        PLCID_Wfz2,      PalID_WFZ,  ArtKos_SCZ, BM16_WFZ, BM128_WFZ ; WFZ    ; WING FORTRESS ZONE
	levartptrs PLCID_Htz1,        PLCID_Htz2,      PalID_HTZ,  ArtKos_EHZ, BM16_EHZ, BM128_EHZ ; HTZ    ; HILL TOP ZONE
	levartptrs PLCID_Hpz1,        PLCID_Hpz2,      PalID_HPZ,  ArtKos_HPZ, BM16_HPZ, BM128_HPZ ; HPZ    ; HIDDEN PALACE ZONE (UNUSED)
	levartptrs PLCID_Unused3,     PLCID_Unused4,   PalID_EHZ4, ArtKos_EHZ, BM16_EHZ, BM128_EHZ ; Zone 9 ; LEVEL 9 (UNUSED)
	levartptrs PLCID_Ooz1,        PLCID_Ooz2,      PalID_OOZ,  ArtKos_OOZ, BM16_OOZ, BM128_OOZ ; OOZ    ; OIL OCEAN ZONE
	levartptrs PLCID_Mcz1,        PLCID_Mcz2,      PalID_MCZ,  ArtKos_MCZ, BM16_MCZ, BM128_MCZ ; MCZ    ; MYSTIC CAVE ZONE
	levartptrs PLCID_Cnz1,        PLCID_Cnz2,      PalID_CNZ,  ArtKos_CNZ, BM16_CNZ, BM128_CNZ ; CNZ    ; CASINO NIGHT ZONE
	levartptrs PLCID_Cpz1,        PLCID_Cpz2,      PalID_CPZ,  ArtKos_CPZ, BM16_CPZ, BM128_CPZ ; CPZ    ; CHEMICAL PLANT ZONE
	levartptrs PLCID_Dez1,        PLCID_Dez2,      PalID_DEZ,  ArtKos_CPZ, BM16_CPZ, BM128_CPZ ; DEZ    ; DEATH EGG ZONE
	levartptrs PLCID_Arz1,        PLCID_Arz2,      PalID_ARZ,  ArtKos_ARZ, BM16_ARZ, BM128_ARZ ; ARZ    ; AQUATIC RUIN ZONE
	levartptrs PLCID_Scz1,        PLCID_Scz2,      PalID_SCZ,  ArtKos_SCZ, BM16_WFZ, BM128_WFZ ; SCZ    ; SKY CHASE ZONE

    if (cur_zone_id<>no_of_zones)&&(MOMPASS=1)
	message "Warning: Table LevelArtPointers has \{cur_zone_id/1.0} entries, but it should have \{no_of_zones/1.0} entries"
    endif
	!org LevelArtPointers+cur_zone_id*12

; ---------------------------------------------------------------------------
; END Art_Ptrs_Array[17]
