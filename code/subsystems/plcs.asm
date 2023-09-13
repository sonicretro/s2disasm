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




; ---------------------------------------------------------------------------
; PATTERN LOAD REQUEST LISTS
;
; Pattern load request lists are simple structures used to load
; Nemesis-compressed art for sprites.
;
; The decompressor predictably moves down the list, so request 0 is processed first, etc.
; This only matters if your addresses are bad and you overwrite art loaded in a previous request.
;

; NOTICE: The load queue buffer can only hold $10 (16) load requests. None of the routines
; that load PLRs into the queue do any bounds checking, so it's possible to create a buffer
; overflow and completely screw up the variables stored directly after the queue buffer.
; (in my experience this is a guaranteed crash or hang)
;
; Many levels queue more than 16 items overall,
; but they don't exceed the limit because
; their PLRs are split into multiple parts (like PlrList_Mtz1 and PlrList_Mtz2)
; and they fully process the first part before requesting the rest.
;
; If you can find some extra RAM for it (which is easy in Sonic 2),
; you can increase this limit by increasing the size of Plc_Buffer.
; ---------------------------------------------------------------------------

;---------------------------------------------------------------------------------------
; Table of pattern load request lists. Remember to use word-length data when adding lists
; otherwise you'll break the array.
;---------------------------------------------------------------------------------------
; word_42660 ; OffInd_PlrLists:
ArtLoadCues:		offsetTable
PLCptr_Std1:		offsetTableEntry.w PlrList_Std1			; 0
PLCptr_Std2:		offsetTableEntry.w PlrList_Std2			; 1
PLCptr_StdWtr:		offsetTableEntry.w PlrList_StdWtr		; 2
PLCptr_GameOver:	offsetTableEntry.w PlrList_GameOver		; 3
PLCptr_Ehz1:		offsetTableEntry.w PlrList_Ehz1			; 4
PLCptr_Ehz2:		offsetTableEntry.w PlrList_Ehz2			; 5
PLCptr_MilesLife2P:	offsetTableEntry.w PlrList_MilesLife2P		; 6
PLCptr_MilesLife:	offsetTableEntry.w PlrList_MilesLife		; 7
PLCptr_TailsLife2P:	offsetTableEntry.w PlrList_TailsLife2P		; 8
PLCptr_TailsLife:	offsetTableEntry.w PlrList_TailsLife		; 9
PLCptr_Unused1:		offsetTableEntry.w PlrList_Mtz1			; 10
PLCptr_Unused2:		offsetTableEntry.w PlrList_Mtz1			; 11
PLCptr_Mtz1:		offsetTableEntry.w PlrList_Mtz1			; 12
PLCptr_Mtz2:		offsetTableEntry.w PlrList_Mtz2			; 13
			offsetTableEntry.w PlrList_Wfz1			; 14
			offsetTableEntry.w PlrList_Wfz1			; 15
PLCptr_Wfz1:		offsetTableEntry.w PlrList_Wfz1			; 16
PLCptr_Wfz2:		offsetTableEntry.w PlrList_Wfz2			; 17
PLCptr_Htz1:		offsetTableEntry.w PlrList_Htz1			; 18
PLCptr_Htz2:		offsetTableEntry.w PlrList_Htz2			; 19
PLCptr_Hpz1:		offsetTableEntry.w PlrList_Hpz1			; 20
PLCptr_Hpz2:		offsetTableEntry.w PlrList_Hpz2			; 21
PLCptr_Unused3:		offsetTableEntry.w PlrList_Ooz1			; 22
PLCptr_Unused4:		offsetTableEntry.w PlrList_Ooz1			; 23
PLCptr_Ooz1:		offsetTableEntry.w PlrList_Ooz1			; 24
PLCptr_Ooz2:		offsetTableEntry.w PlrList_Ooz2			; 25
PLCptr_Mcz1:		offsetTableEntry.w PlrList_Mcz1			; 26
PLCptr_Mcz2:		offsetTableEntry.w PlrList_Mcz2			; 27
PLCptr_Cnz1:		offsetTableEntry.w PlrList_Cnz1			; 28
PLCptr_Cnz2:		offsetTableEntry.w PlrList_Cnz2			; 29
PLCptr_Cpz1:		offsetTableEntry.w PlrList_Cpz1			; 30
PLCptr_Cpz2:		offsetTableEntry.w PlrList_Cpz2			; 31
PLCptr_Dez1:		offsetTableEntry.w PlrList_Dez1			; 32
PLCptr_Dez2:		offsetTableEntry.w PlrList_Dez2			; 33
PLCptr_Arz1:		offsetTableEntry.w PlrList_Arz1			; 34
PLCptr_Arz2:		offsetTableEntry.w PlrList_Arz2			; 35
PLCptr_Scz1:		offsetTableEntry.w PlrList_Scz1			; 36
PLCptr_Scz2:		offsetTableEntry.w PlrList_Scz2			; 37
PLCptr_Results:		offsetTableEntry.w PlrList_Results		; 38
PLCptr_Signpost:	offsetTableEntry.w PlrList_Signpost		; 39
PLCptr_CpzBoss:		offsetTableEntry.w PlrList_CpzBoss		; 40
PLCptr_EhzBoss:		offsetTableEntry.w PlrList_EhzBoss		; 41
PLCptr_HtzBoss:		offsetTableEntry.w PlrList_HtzBoss		; 42
PLCptr_ArzBoss:		offsetTableEntry.w PlrList_ArzBoss		; 43
PLCptr_MczBoss:		offsetTableEntry.w PlrList_MczBoss		; 44
PLCptr_CnzBoss:		offsetTableEntry.w PlrList_CnzBoss		; 45
PLCptr_MtzBoss:		offsetTableEntry.w PlrList_MtzBoss		; 46
PLCptr_OozBoss:		offsetTableEntry.w PlrList_OozBoss		; 47
PLCptr_FieryExplosion:	offsetTableEntry.w PlrList_FieryExplosion	; 48
PLCptr_DezBoss:		offsetTableEntry.w PlrList_DezBoss		; 49
PLCptr_EhzAnimals:	offsetTableEntry.w PlrList_EhzAnimals		; 50
PLCptr_MczAnimals:	offsetTableEntry.w PlrList_MczAnimals		; 51
PLCptr_HtzAnimals:
PLCptr_MtzAnimals:
PLCptr_WfzAnimals:	offsetTableEntry.w PlrList_WfzAnimals		; 52
PLCptr_DezAnimals:	offsetTableEntry.w PlrList_DezAnimals		; 53
PLCptr_HpzAnimals:	offsetTableEntry.w PlrList_HpzAnimals		; 54
PLCptr_OozAnimals:	offsetTableEntry.w PlrList_OozAnimals		; 55
PLCptr_SczAnimals:	offsetTableEntry.w PlrList_SczAnimals		; 56
PLCptr_CnzAnimals:	offsetTableEntry.w PlrList_CnzAnimals		; 57
PLCptr_CpzAnimals:	offsetTableEntry.w PlrList_CpzAnimals		; 58
PLCptr_ArzAnimals:	offsetTableEntry.w PlrList_ArzAnimals		; 59
PLCptr_SpecialStage:	offsetTableEntry.w PlrList_SpecialStage		; 60
PLCptr_SpecStageBombs:	offsetTableEntry.w PlrList_SpecStageBombs	; 61
PLCptr_WfzBoss:		offsetTableEntry.w PlrList_WfzBoss		; 62
PLCptr_Tornado:		offsetTableEntry.w PlrList_Tornado		; 63
PLCptr_Capsule:		offsetTableEntry.w PlrList_Capsule		; 64
PLCptr_Explosion:	offsetTableEntry.w PlrList_Explosion		; 65
PLCptr_ResultsTails:	offsetTableEntry.w PlrList_ResultsTails		; 66

; macro for a pattern load request list header
; must be on the same line as a label that has a corresponding _End label later
plrlistheader macro {INTLABEL}
__LABEL__ label *
	dc.w (((__LABEL___End - __LABEL__Plc) / 6) - 1)
__LABEL__Plc:
    endm

; macro for a pattern load request
plreq macro toVRAMaddr,fromROMaddr
	dc.l	fromROMaddr
	dc.w	tiles_to_bytes(toVRAMaddr)
    endm

;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Standard 1 - loaded for every level
;---------------------------------------------------------------------------------------
PlrList_Std1: plrlistheader
	plreq ArtTile_ArtNem_HUD, ArtNem_HUD
	plreq ArtTile_ArtNem_life_counter, ArtNem_Sonic_life_counter
	plreq ArtTile_ArtNem_Ring, ArtNem_Ring
	plreq ArtTile_ArtNem_Numbers, ArtNem_Numbers
PlrList_Std1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Standard 2 - loaded for every level
;---------------------------------------------------------------------------------------
PlrList_Std2: plrlistheader
	plreq ArtTile_ArtNem_Checkpoint, ArtNem_Checkpoint
	plreq ArtTile_ArtNem_Powerups, ArtNem_Powerups
	plreq ArtTile_ArtNem_Shield, ArtNem_Shield
	plreq ArtTile_ArtNem_Invincible_stars, ArtNem_Invincible_stars
PlrList_Std2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Aquatic level standard
;---------------------------------------------------------------------------------------
PlrList_StdWtr:	plrlistheader
	plreq ArtTile_ArtNem_Explosion, ArtNem_Explosion
	plreq ArtTile_ArtNem_SuperSonic_stars, ArtNem_SuperSonic_stars
	plreq ArtTile_ArtNem_Bubbles, ArtNem_Bubbles
PlrList_StdWtr_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Game/Time over
;---------------------------------------------------------------------------------------
PlrList_GameOver: plrlistheader
	plreq ArtTile_ArtNem_Game_Over, ArtNem_Game_Over
PlrList_GameOver_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Emerald Hill Zone primary
;---------------------------------------------------------------------------------------
PlrList_Ehz1: plrlistheader
	plreq ArtTile_ArtNem_Waterfall, ArtNem_Waterfall
	plreq ArtTile_ArtNem_EHZ_Bridge, ArtNem_EHZ_Bridge
	plreq ArtTile_ArtNem_Buzzer_Fireball, ArtNem_HtzFireball1
	plreq ArtTile_ArtNem_Buzzer, ArtNem_Buzzer
	plreq ArtTile_ArtNem_Coconuts, ArtNem_Coconuts
	plreq ArtTile_ArtNem_Masher, ArtNem_Masher
PlrList_Ehz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Emerald Hill Zone secondary
;---------------------------------------------------------------------------------------
PlrList_Ehz2: plrlistheader
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_DignlSprng
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Ehz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Miles 1up patch
;---------------------------------------------------------------------------------------
PlrList_MilesLife2P: plrlistheader
	plreq ArtTile_ArtNem_2p_life_counter, ArtNem_MilesLife
PlrList_MilesLife2P_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Miles life counter
;---------------------------------------------------------------------------------------
PlrList_MilesLife: plrlistheader
	plreq ArtTile_ArtNem_life_counter, ArtNem_MilesLife
PlrList_MilesLife_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Tails 1up patch
;---------------------------------------------------------------------------------------
PlrList_TailsLife2P: plrlistheader
	plreq ArtTile_ArtNem_2p_life_counter, ArtNem_TailsLife
PlrList_TailsLife2P_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Tails life counter
;---------------------------------------------------------------------------------------
PlrList_TailsLife: plrlistheader
	plreq ArtTile_ArtNem_life_counter, ArtNem_TailsLife
PlrList_TailsLife_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Metropolis Zone primary
;---------------------------------------------------------------------------------------
PlrList_Mtz1: plrlistheader
	plreq ArtTile_ArtNem_MtzWheel, ArtNem_MtzWheel
	plreq ArtTile_ArtNem_MtzWheelIndent, ArtNem_MtzWheelIndent
	plreq ArtTile_ArtNem_LavaCup, ArtNem_LavaCup
	plreq ArtTile_ArtNem_BoltEnd_Rope, ArtNem_BoltEnd_Rope
	plreq ArtTile_ArtNem_MtzSteam, ArtNem_MtzSteam
	plreq ArtTile_ArtNem_MtzSpikeBlock, ArtNem_MtzSpikeBlock
	plreq ArtTile_ArtNem_MtzSpike, ArtNem_MtzSpike
	plreq ArtTile_ArtNem_Shellcracker, ArtNem_Shellcracker
	plreq ArtTile_ArtNem_MtzSupernova, ArtNem_MtzSupernova
PlrList_Mtz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Metropolis Zone secondary
;---------------------------------------------------------------------------------------
PlrList_Mtz2: plrlistheader
	plreq ArtTile_ArtNem_Button, ArtNem_Button
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_MtzMantis, ArtNem_MtzMantis
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
	plreq ArtTile_ArtNem_MtzAsstBlocks, ArtNem_MtzAsstBlocks
	plreq ArtTile_ArtNem_MtzLavaBubble, ArtNem_MtzLavaBubble
	plreq ArtTile_ArtNem_MtzCog, ArtNem_MtzCog
	plreq ArtTile_ArtNem_MtzSpinTubeFlash, ArtNem_MtzSpinTubeFlash
PlrList_Mtz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Wing Fortress Zone primary
;---------------------------------------------------------------------------------------
PlrList_Wfz1: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
	plreq ArtTile_ArtNem_WfzVrtclPrpllr, ArtNem_WfzVrtclPrpllr
	plreq ArtTile_ArtNem_WfzHrzntlPrpllr, ArtNem_WfzHrzntlPrpllr
	plreq ArtTile_ArtNem_Balkrie, ArtNem_Balkrie
	plreq ArtTile_ArtNem_BreakPanels, ArtNem_BreakPanels
	plreq ArtTile_ArtNem_WfzScratch, ArtNem_WfzScratch
	plreq ArtTile_ArtNem_WfzTiltPlatforms, ArtNem_WfzTiltPlatforms
	; These two are already in the list, so this is redundant
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
PlrList_Wfz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Wing Fortress Zone secondary
;---------------------------------------------------------------------------------------
PlrList_Wfz2: plrlistheader
	plreq ArtTile_ArtNem_WfzVrtclPrpllr, ArtNem_WfzVrtclPrpllr
	plreq ArtTile_ArtNem_WfzHrzntlPrpllr, ArtNem_WfzHrzntlPrpllr
	plreq ArtTile_ArtNem_WfzVrtclLazer, ArtNem_WfzVrtclLazer
	plreq ArtTile_ArtNem_WfzWallTurret, ArtNem_WfzWallTurret
	plreq ArtTile_ArtNem_WfzHrzntlLazer, ArtNem_WfzHrzntlLazer
	plreq ArtTile_ArtNem_WfzConveyorBeltWheel, ArtNem_WfzConveyorBeltWheel
	plreq ArtTile_ArtNem_WfzHook, ArtNem_WfzHook
	plreq ArtTile_ArtNem_WfzThrust, ArtNem_WfzThrust
	plreq ArtTile_ArtNem_WfzBeltPlatform, ArtNem_WfzBeltPlatform
	plreq ArtTile_ArtNem_WfzGunPlatform, ArtNem_WfzGunPlatform
	plreq ArtTile_ArtNem_WfzUnusedBadnik, ArtNem_WfzUnusedBadnik
	plreq ArtTile_ArtNem_WfzLaunchCatapult, ArtNem_WfzLaunchCatapult
	plreq ArtTile_ArtNem_WfzSwitch, ArtNem_WfzSwitch
	plreq ArtTile_ArtNem_WfzFloatingPlatform, ArtNem_WfzFloatingPlatform
PlrList_Wfz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Hill Top Zone primary
;---------------------------------------------------------------------------------------
PlrList_Htz1: plrlistheader
	plreq ArtTile_ArtNem_HtzFireball1, ArtNem_HtzFireball1
	plreq ArtTile_ArtNem_HtzRock, ArtNem_HtzRock
	plreq ArtTile_ArtNem_HtzSeeSaw, ArtNem_HtzSeeSaw
	plreq ArtTile_ArtNem_Sol, ArtNem_Sol
	plreq ArtTile_ArtNem_Rexon, ArtNem_Rexon
	plreq ArtTile_ArtNem_Spiker, ArtNem_Spiker
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_DignlSprng
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Htz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Hill Top Zone secondary
;---------------------------------------------------------------------------------------
PlrList_Htz2: plrlistheader
	plreq ArtTile_ArtNem_HtzZipline, ArtNem_HtzZipline
	plreq ArtTile_ArtNem_HtzFireball2, ArtNem_HtzFireball2
	plreq ArtTile_ArtNem_HtzValveBarrier, ArtNem_HtzValveBarrier
PlrList_Htz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; HPZ Primary
;---------------------------------------------------------------------------------------
PlrList_Hpz1: ;plrlistheader
;	plreq ArtTile_ArtNem_WaterSurface, ArtNem_WaterSurface
;PlrList_Hpz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; HPZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Hpz2: ;plrlistheader
;PlrList_Hpz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; OOZ Primary
;---------------------------------------------------------------------------------------
PlrList_Ooz1: plrlistheader
	plreq ArtTile_ArtNem_OOZBurn, ArtNem_OOZBurn
	plreq ArtTile_ArtNem_OOZElevator, ArtNem_OOZElevator
	plreq ArtTile_ArtNem_SpikyThing, ArtNem_SpikyThing
	plreq ArtTile_ArtNem_BurnerLid, ArtNem_BurnerLid
	plreq ArtTile_ArtNem_StripedBlocksVert, ArtNem_StripedBlocksVert
	plreq ArtTile_ArtNem_Oilfall, ArtNem_Oilfall
	plreq ArtTile_ArtNem_Oilfall2, ArtNem_Oilfall2
	plreq ArtTile_ArtNem_BallThing, ArtNem_BallThing
	plreq ArtTile_ArtNem_LaunchBall, ArtNem_LaunchBall
PlrList_Ooz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; OOZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Ooz2: plrlistheader
	plreq ArtTile_ArtNem_OOZPlatform, ArtNem_OOZPlatform
	plreq ArtTile_ArtNem_PushSpring, ArtNem_PushSpring
	plreq ArtTile_ArtNem_OOZSwingPlat, ArtNem_OOZSwingPlat
	plreq ArtTile_ArtNem_StripedBlocksHoriz, ArtNem_StripedBlocksHoriz
	plreq ArtTile_ArtNem_OOZFanHoriz, ArtNem_OOZFanHoriz
	plreq ArtTile_ArtNem_Button, ArtNem_Button
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_DignlSprng
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
	plreq ArtTile_ArtNem_Aquis, ArtNem_Aquis
	plreq ArtTile_ArtNem_Octus, ArtNem_Octus
PlrList_Ooz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; MCZ Primary
;---------------------------------------------------------------------------------------
PlrList_Mcz1: plrlistheader
	plreq ArtTile_ArtNem_Crate, ArtNem_Crate
	plreq ArtTile_ArtNem_MCZCollapsePlat, ArtNem_MCZCollapsePlat
	plreq ArtTile_ArtNem_VineSwitch, ArtNem_VineSwitch
	plreq ArtTile_ArtNem_VinePulley, ArtNem_VinePulley
	plreq ArtTile_ArtNem_Flasher, ArtNem_Flasher
	plreq ArtTile_ArtNem_Crawlton, ArtNem_Crawlton
PlrList_Mcz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; MCZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Mcz2: plrlistheader
	plreq ArtTile_ArtNem_HorizSpike, ArtNem_HorizSpike
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_MCZGateLog, ArtNem_MCZGateLog
	plreq ArtTile_ArtNem_LeverSpring, ArtNem_LeverSpring
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Mcz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CNZ Primary
;---------------------------------------------------------------------------------------
PlrList_Cnz1: plrlistheader
	plreq ArtTile_ArtNem_Crawl, ArtNem_Crawl
	plreq ArtTile_ArtNem_BigMovingBlock, ArtNem_BigMovingBlock
	plreq ArtTile_ArtNem_CNZSnake, ArtNem_CNZSnake
	plreq ArtTile_ArtNem_CNZBonusSpike, ArtNem_CNZBonusSpike
	plreq ArtTile_ArtNem_CNZElevator, ArtNem_CNZElevator
	plreq ArtTile_ArtNem_CNZCage, ArtNem_CNZCage
	plreq ArtTile_ArtNem_CNZHexBumper, ArtNem_CNZHexBumper
	plreq ArtTile_ArtNem_CNZRoundBumper, ArtNem_CNZRoundBumper
	plreq ArtTile_ArtNem_CNZFlipper, ArtNem_CNZFlipper
	plreq ArtTile_ArtNem_CNZMiniBumper, ArtNem_CNZMiniBumper
PlrList_Cnz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CNZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Cnz2: plrlistheader
	plreq ArtTile_ArtNem_CNZDiagPlunger, ArtNem_CNZDiagPlunger
	plreq ArtTile_ArtNem_CNZVertPlunger, ArtNem_CNZVertPlunger
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_DignlSprng
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Cnz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CPZ Primary
;---------------------------------------------------------------------------------------
PlrList_Cpz1: plrlistheader
	plreq ArtTile_ArtNem_CPZMetalThings, ArtNem_CPZMetalThings
	plreq ArtTile_ArtNem_ConstructionStripes_2, ArtNem_ConstructionStripes
	plreq ArtTile_ArtNem_CPZBooster, ArtNem_CPZBooster
	plreq ArtTile_ArtNem_CPZElevator, ArtNem_CPZElevator
	plreq ArtTile_ArtNem_CPZAnimatedBits, ArtNem_CPZAnimatedBits
	plreq ArtTile_ArtNem_CPZTubeSpring, ArtNem_CPZTubeSpring
	plreq ArtTile_ArtNem_WaterSurface, ArtNem_WaterSurface
	plreq ArtTile_ArtNem_CPZStairBlock, ArtNem_CPZStairBlock
	plreq ArtTile_ArtNem_CPZMetalBlock, ArtNem_CPZMetalBlock
PlrList_Cpz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CPZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Cpz2: plrlistheader
	plreq ArtTile_ArtNem_Grabber, ArtNem_Grabber
	plreq ArtTile_ArtNem_Spiny, ArtNem_Spiny
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_CPZDroplet
	plreq ArtTile_ArtNem_LeverSpring, ArtNem_LeverSpring
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Cpz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; DEZ Primary
;---------------------------------------------------------------------------------------
PlrList_Dez1: plrlistheader
	plreq ArtTile_ArtNem_ConstructionStripes_1, ArtNem_ConstructionStripes
PlrList_Dez1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; DEZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Dez2: plrlistheader
	plreq ArtTile_ArtNem_SilverSonic, ArtNem_SilverSonic
	plreq ArtTile_ArtNem_DEZWindow, ArtNem_DEZWindow
	plreq ArtTile_ArtNem_RobotnikRunning, ArtNem_RobotnikRunning
	plreq ArtTile_ArtNem_RobotnikUpper, ArtNem_RobotnikUpper
	plreq ArtTile_ArtNem_RobotnikLower, ArtNem_RobotnikLower
PlrList_Dez2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; ARZ Primary
;---------------------------------------------------------------------------------------
PlrList_Arz1: plrlistheader
	plreq ArtTile_ArtNem_ARZBarrierThing, ArtNem_ARZBarrierThing
	plreq ArtTile_ArtNem_WaterSurface, ArtNem_WaterSurface2
	plreq ArtTile_ArtNem_Leaves, ArtNem_Leaves
	plreq ArtTile_ArtNem_ArrowAndShooter, ArtNem_ArrowAndShooter
PlrList_Arz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; ARZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Arz2: plrlistheader
	plreq ArtTile_ArtNem_ChopChop, ArtNem_ChopChop
	plreq ArtTile_ArtNem_Whisp, ArtNem_Whisp
	plreq ArtTile_ArtNem_Grounder, ArtNem_Grounder
	plreq ArtTile_ArtNem_BigBubbles, ArtNem_BigBubbles
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_LeverSpring, ArtNem_LeverSpring
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Arz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; SCZ Primary
;---------------------------------------------------------------------------------------
PlrList_Scz1: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
PlrList_Scz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; SCZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Scz2: plrlistheader
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
	plreq ArtTile_ArtNem_WfzVrtclPrpllr, ArtNem_WfzVrtclPrpllr
	plreq ArtTile_ArtNem_WfzHrzntlPrpllr, ArtNem_WfzHrzntlPrpllr
	plreq ArtTile_ArtNem_Balkrie, ArtNem_Balkrie
	plreq ArtTile_ArtNem_Turtloid, ArtNem_Turtloid
	plreq ArtTile_ArtNem_Nebula, ArtNem_Nebula
PlrList_Scz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Sonic end of level results screen
;---------------------------------------------------------------------------------------
PlrList_Results: plrlistheader
	plreq ArtTile_ArtNem_TitleCard, ArtNem_TitleCard
	plreq ArtTile_ArtNem_ResultsText, ArtNem_ResultsText
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniSonic
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_Results_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; End of level signpost
;---------------------------------------------------------------------------------------
PlrList_Signpost: plrlistheader
	plreq ArtTile_ArtNem_Signpost, ArtNem_Signpost
PlrList_Signpost_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CPZ Boss
;---------------------------------------------------------------------------------------
PlrList_CpzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_3, ArtNem_Eggpod
	plreq ArtTile_ArtNem_CPZBoss, ArtNem_CPZBoss
	plreq ArtTile_ArtNem_EggpodJets_1, ArtNem_EggpodJets
	plreq ArtTile_ArtNem_BossSmoke_1, ArtNem_BossSmoke
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_CpzBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; EHZ Boss
;---------------------------------------------------------------------------------------
PlrList_EhzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_1, ArtNem_Eggpod
	plreq ArtTile_ArtNem_EHZBoss, ArtNem_EHZBoss
	plreq ArtTile_ArtNem_EggChoppers, ArtNem_EggChoppers
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_EhzBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; HTZ Boss
;---------------------------------------------------------------------------------------
PlrList_HtzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_2, ArtNem_Eggpod
	plreq ArtTile_ArtNem_HTZBoss, ArtNem_HTZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
	plreq ArtTile_ArtNem_BossSmoke_2, ArtNem_BossSmoke
PlrList_HtzBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; ARZ Boss
;---------------------------------------------------------------------------------------
PlrList_ArzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_ARZBoss, ArtNem_ARZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_ArzBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; MCZ Boss
;---------------------------------------------------------------------------------------
PlrList_MczBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_MCZBoss, ArtNem_MCZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_MczBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CNZ Boss
;---------------------------------------------------------------------------------------
PlrList_CnzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_CNZBoss, ArtNem_CNZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_CnzBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; MTZ Boss
;---------------------------------------------------------------------------------------
PlrList_MtzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_MTZBoss, ArtNem_MTZBoss
	plreq ArtTile_ArtNem_EggpodJets_2, ArtNem_EggpodJets
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_MtzBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; OOZ Boss
;---------------------------------------------------------------------------------------
PlrList_OozBoss: plrlistheader
	plreq ArtTile_ArtNem_OOZBoss, ArtNem_OOZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_OozBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Fiery Explosion
;---------------------------------------------------------------------------------------
PlrList_FieryExplosion: plrlistheader
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_FieryExplosion_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Death Egg
;---------------------------------------------------------------------------------------
PlrList_DezBoss: plrlistheader
	plreq ArtTile_ArtNem_DEZBoss, ArtNem_DEZBoss
PlrList_DezBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; EHZ Animals
;---------------------------------------------------------------------------------------
PlrList_EhzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Squirrel
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Flicky
PlrList_EhzAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; MCZ Animals
;---------------------------------------------------------------------------------------
PlrList_MczAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Mouse
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_MczAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; HTZ/MTZ/WFZ animals
;---------------------------------------------------------------------------------------
PlrList_HtzAnimals:
PlrList_MtzAnimals:
PlrList_WfzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Monkey
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Eagle
PlrList_HtzAnimals_End
PlrList_MtzAnimals_End
PlrList_WfzAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; DEZ Animals
;---------------------------------------------------------------------------------------
PlrList_DezAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Pig
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_DezAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; HPZ animals
;---------------------------------------------------------------------------------------
PlrList_HpzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Mouse
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Seal
PlrList_HpzAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; OOZ Animals
;---------------------------------------------------------------------------------------
PlrList_OozAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Penguin
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Seal
PlrList_OozAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; SCZ Animals
;---------------------------------------------------------------------------------------
PlrList_SczAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Turtle
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_SczAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CNZ Animals
;---------------------------------------------------------------------------------------
PlrList_CnzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Bear
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Flicky
PlrList_CnzAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; CPZ Animals
;---------------------------------------------------------------------------------------
PlrList_CpzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Rabbit
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Eagle
PlrList_CpzAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; ARZ Animals
;---------------------------------------------------------------------------------------
PlrList_ArzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Penguin
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Flicky
PlrList_ArzAnimals_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Special Stage
;---------------------------------------------------------------------------------------
PlrList_SpecialStage: plrlistheader
	plreq ArtTile_ArtNem_SpecialEmerald, ArtNem_SpecialEmerald
	plreq ArtTile_ArtNem_SpecialMessages, ArtNem_SpecialMessages
	plreq ArtTile_ArtNem_SpecialHUD, ArtNem_SpecialHUD
	plreq ArtTile_ArtNem_SpecialFlatShadow, ArtNem_SpecialFlatShadow
	plreq ArtTile_ArtNem_SpecialDiagShadow, ArtNem_SpecialDiagShadow
	plreq ArtTile_ArtNem_SpecialSideShadow, ArtNem_SpecialSideShadow
	plreq ArtTile_ArtNem_SpecialExplosion, ArtNem_SpecialExplosion
	plreq ArtTile_ArtNem_SpecialRings, ArtNem_SpecialRings
	plreq ArtTile_ArtNem_SpecialStart, ArtNem_SpecialStart
	plreq ArtTile_ArtNem_SpecialPlayerVSPlayer, ArtNem_SpecialPlayerVSPlayer
	plreq ArtTile_ArtNem_SpecialBack, ArtNem_SpecialBack
	plreq ArtTile_ArtNem_SpecialStars, ArtNem_SpecialStars
	plreq ArtTile_ArtNem_SpecialTailsText, ArtNem_SpecialTailsText
PlrList_SpecialStage_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Special Stage Bombs
;---------------------------------------------------------------------------------------
PlrList_SpecStageBombs: plrlistheader
	plreq ArtTile_ArtNem_SpecialBomb, ArtNem_SpecialBomb
PlrList_SpecStageBombs_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; WFZ Boss
;---------------------------------------------------------------------------------------
PlrList_WfzBoss: plrlistheader
	plreq ArtTile_ArtNem_WFZBoss, ArtNem_WFZBoss
	plreq ArtTile_ArtNem_RobotnikRunning, ArtNem_RobotnikRunning
	plreq ArtTile_ArtNem_RobotnikUpper, ArtNem_RobotnikUpper
	plreq ArtTile_ArtNem_RobotnikLower, ArtNem_RobotnikLower
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_WfzBoss_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Tornado
;---------------------------------------------------------------------------------------
PlrList_Tornado: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
	plreq ArtTile_ArtNem_TornadoThruster, ArtNem_TornadoThruster
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
PlrList_Tornado_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Capsule/Egg Prison
;---------------------------------------------------------------------------------------
PlrList_Capsule: plrlistheader
	plreq ArtTile_ArtNem_Capsule, ArtNem_Capsule
PlrList_Capsule_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Normal explosion
;---------------------------------------------------------------------------------------
PlrList_Explosion: plrlistheader
	plreq ArtTile_ArtNem_Explosion, ArtNem_Explosion
PlrList_Explosion_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Tails end of level results screen
;---------------------------------------------------------------------------------------
PlrList_ResultsTails: plrlistheader
	plreq ArtTile_ArtNem_TitleCard, ArtNem_TitleCard
	plreq ArtTile_ArtNem_ResultsText, ArtNem_ResultsText
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniTails
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_ResultsTails_End




;---------------------------------------------------------------------------------------
; Weird revision-specific duplicates of portions of the PLR lists (unused)
;---------------------------------------------------------------------------------------
    if gameRevision=0
	; half of PlrList_ResultsTails
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniTails
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_ResultsTails_Dup_End
	dc.l	0
    elseif gameRevision=2
	; half of the second ARZ PLR list
	plreq ArtTile_ArtNem_Grounder, ArtNem_Grounder
	plreq ArtTile_ArtNem_BigBubbles, ArtNem_BigBubbles
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_LeverSpring, ArtNem_LeverSpring
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Arz2_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; SCZ Primary
;---------------------------------------------------------------------------------------
PlrList_Scz1_Dup: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
PlrList_Scz1_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; SCZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Scz2_Dup: plrlistheader
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
	plreq ArtTile_ArtNem_WfzVrtclPrpllr, ArtNem_WfzVrtclPrpllr
	plreq ArtTile_ArtNem_WfzHrzntlPrpllr, ArtNem_WfzHrzntlPrpllr
	plreq ArtTile_ArtNem_Balkrie, ArtNem_Balkrie
	plreq ArtTile_ArtNem_Turtloid, ArtNem_Turtloid
	plreq ArtTile_ArtNem_Nebula, ArtNem_Nebula
PlrList_Scz2_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Sonic end of level results screen
;---------------------------------------------------------------------------------------
PlrList_Results_Dup: plrlistheader
	plreq ArtTile_ArtNem_TitleCard, ArtNem_TitleCard
	plreq ArtTile_ArtNem_ResultsText, ArtNem_ResultsText
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniSonic
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_Results_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; End of level signpost
;---------------------------------------------------------------------------------------
PlrList_Signpost_Dup: plrlistheader
	plreq ArtTile_ArtNem_Signpost, ArtNem_Signpost
PlrList_Signpost_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; CPZ Boss
;---------------------------------------------------------------------------------------
PlrList_CpzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_3, ArtNem_Eggpod
	plreq ArtTile_ArtNem_CPZBoss, ArtNem_CPZBoss
	plreq ArtTile_ArtNem_EggpodJets_1, ArtNem_EggpodJets
	plreq ArtTile_ArtNem_BossSmoke_1, ArtNem_BossSmoke
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_CpzBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; EHZ Boss
;---------------------------------------------------------------------------------------
PlrList_EhzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_1, ArtNem_Eggpod
	plreq ArtTile_ArtNem_EHZBoss, ArtNem_EHZBoss
	plreq ArtTile_ArtNem_EggChoppers, ArtNem_EggChoppers
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_EhzBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; HTZ Boss
;---------------------------------------------------------------------------------------
PlrList_HtzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_2, ArtNem_Eggpod
	plreq ArtTile_ArtNem_HTZBoss, ArtNem_HTZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
	plreq ArtTile_ArtNem_BossSmoke_2, ArtNem_BossSmoke
PlrList_HtzBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; ARZ Boss
;---------------------------------------------------------------------------------------
PlrList_ArzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_ARZBoss, ArtNem_ARZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_ArzBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; MCZ Boss
;---------------------------------------------------------------------------------------
PlrList_MczBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_MCZBoss, ArtNem_MCZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_MczBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; CNZ Boss
;---------------------------------------------------------------------------------------
PlrList_CnzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_CNZBoss, ArtNem_CNZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_CnzBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; MTZ Boss
;---------------------------------------------------------------------------------------
PlrList_MtzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_MTZBoss, ArtNem_MTZBoss
	plreq ArtTile_ArtNem_EggpodJets_2, ArtNem_EggpodJets
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_MtzBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; OOZ Boss
;---------------------------------------------------------------------------------------
PlrList_OozBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_OOZBoss, ArtNem_OOZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_OozBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Fiery Explosion
;---------------------------------------------------------------------------------------
PlrList_FieryExplosion_Dup: plrlistheader
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_FieryExplosion_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Death Egg
;---------------------------------------------------------------------------------------
PlrList_DezBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_DEZBoss, ArtNem_DEZBoss
PlrList_DezBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; EHZ Animals
;---------------------------------------------------------------------------------------
PlrList_EhzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Squirrel
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Flicky
PlrList_EhzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; MCZ Animals
;---------------------------------------------------------------------------------------
PlrList_MczAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Mouse
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_MczAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; HTZ/MTZ/WFZ animals
;---------------------------------------------------------------------------------------
PlrList_HtzAnimals_Dup:
PlrList_MtzAnimals_Dup:
PlrList_WfzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Monkey
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Eagle
PlrList_HtzAnimals_Dup_End
PlrList_MtzAnimals_Dup_End
PlrList_WfzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; DEZ Animals
;---------------------------------------------------------------------------------------
PlrList_DezAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Pig
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_DezAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; HPZ animals
;---------------------------------------------------------------------------------------
PlrList_HpzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Mouse
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Seal
PlrList_HpzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; OOZ Animals
;---------------------------------------------------------------------------------------
PlrList_OozAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Penguin
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Seal
PlrList_OozAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; SCZ Animals
;---------------------------------------------------------------------------------------
PlrList_SczAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Turtle
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_SczAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; CNZ Animals
;---------------------------------------------------------------------------------------
PlrList_CnzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Bear
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Flicky
PlrList_CnzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; CPZ Animals
;---------------------------------------------------------------------------------------
PlrList_CpzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Rabbit
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Eagle
PlrList_CpzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; ARZ Animals
;---------------------------------------------------------------------------------------
PlrList_ArzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Penguin
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Flicky
PlrList_ArzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Special Stage
;---------------------------------------------------------------------------------------
PlrList_SpecialStage_Dup: plrlistheader
	plreq ArtTile_ArtNem_SpecialEmerald, ArtNem_SpecialEmerald
	plreq ArtTile_ArtNem_SpecialMessages, ArtNem_SpecialMessages
	plreq ArtTile_ArtNem_SpecialHUD, ArtNem_SpecialHUD
	plreq ArtTile_ArtNem_SpecialFlatShadow, ArtNem_SpecialFlatShadow
	plreq ArtTile_ArtNem_SpecialDiagShadow, ArtNem_SpecialDiagShadow
	plreq ArtTile_ArtNem_SpecialSideShadow, ArtNem_SpecialSideShadow
	plreq ArtTile_ArtNem_SpecialExplosion, ArtNem_SpecialExplosion
	plreq ArtTile_ArtNem_SpecialRings, ArtNem_SpecialRings
	plreq ArtTile_ArtNem_SpecialStart, ArtNem_SpecialStart
	plreq ArtTile_ArtNem_SpecialPlayerVSPlayer, ArtNem_SpecialPlayerVSPlayer
	plreq ArtTile_ArtNem_SpecialBack, ArtNem_SpecialBack
	plreq ArtTile_ArtNem_SpecialStars, ArtNem_SpecialStars
	plreq ArtTile_ArtNem_SpecialTailsText, ArtNem_SpecialTailsText
PlrList_SpecialStage_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Special Stage Bombs
;---------------------------------------------------------------------------------------
PlrList_SpecStageBombs_Dup: plrlistheader
	plreq ArtTile_ArtNem_SpecialBomb, ArtNem_SpecialBomb
PlrList_SpecStageBombs_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; WFZ Boss
;---------------------------------------------------------------------------------------
PlrList_WfzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_WFZBoss, ArtNem_WFZBoss
	plreq ArtTile_ArtNem_RobotnikRunning, ArtNem_RobotnikRunning
	plreq ArtTile_ArtNem_RobotnikUpper, ArtNem_RobotnikUpper
	plreq ArtTile_ArtNem_RobotnikLower, ArtNem_RobotnikLower
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_WfzBoss_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Tornado
;---------------------------------------------------------------------------------------
PlrList_Tornado_Dup: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
	plreq ArtTile_ArtNem_TornadoThruster, ArtNem_TornadoThruster
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
PlrList_Tornado_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Capsule/Egg Prison
;---------------------------------------------------------------------------------------
PlrList_Capsule_Dup: plrlistheader
	plreq ArtTile_ArtNem_Capsule, ArtNem_Capsule
PlrList_Capsule_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Normal explosion
;---------------------------------------------------------------------------------------
PlrList_Explosion_Dup: plrlistheader
	plreq ArtTile_ArtNem_Explosion, ArtNem_Explosion
PlrList_Explosion_Dup_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST (duplicate)
; Tails end of level results screen
;---------------------------------------------------------------------------------------
PlrList_ResultsTails_Dup: plrlistheader
	plreq ArtTile_ArtNem_TitleCard, ArtNem_TitleCard
	plreq ArtTile_ArtNem_ResultsText, ArtNem_ResultsText
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniTails
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_ResultsTails_Dup_End
    endif
