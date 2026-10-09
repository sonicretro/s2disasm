; -------------------------------------------------------------------------------
; Main game level order

; One value per act. That value is the level/act number of the level to load when
; that act finishes.
; -------------------------------------------------------------------------------
;word_142F8:
LevelOrder: zoneOrderedTable 2,2	; WrdArr_LevelOrder
	; EHZ
	zoneTableEntry.w  emerald_hill_zone_act_2	; Act 1
	zoneTableEntry.w  chemical_plant_zone_act_1	; Act 2
	; Zone 1
	zoneTableEntry.w  0				; Act 1
	zoneTableEntry.w  0				; Act 2
	; WZ
	zoneTableEntry.w  wood_zone_act_2		; Act 1
	zoneTableEntry.w  metropolis_zone_act_1		; Act 2
	; Zone 3
	zoneTableEntry.w  0				; Act 1
	zoneTableEntry.w  0				; Act 2
	; MTZ
	zoneTableEntry.w  metropolis_zone_act_2		; Act 1
	zoneTableEntry.w  metropolis_zone_act_3		; Act 2
	; MTZ
	zoneTableEntry.w  sky_chase_zone_act_1		; Act 3
	zoneTableEntry.w  0				; Act 4
	; WFZ
	zoneTableEntry.w  death_egg_zone_act_1		; Act 1
	zoneTableEntry.w  0				; Act 2
	; HTZ
	zoneTableEntry.w  hill_top_zone_act_2		; Act 1
	zoneTableEntry.w  mystic_cave_zone_act_1	; Act 2
	; HPZ
	zoneTableEntry.w  hidden_palace_zone_act_2 	; Act 1
	zoneTableEntry.w  oil_ocean_zone_act_1		; Act 2
	; Zone 9
	zoneTableEntry.w  0				; Act 1
	zoneTableEntry.w  0				; Act 2
	; OOZ
	zoneTableEntry.w  oil_ocean_zone_act_2		; Act 1
	zoneTableEntry.w  metropolis_zone_act_1		; Act 2
	; MCZ
	zoneTableEntry.w  mystic_cave_zone_act_2	; Act 1
	zoneTableEntry.w  oil_ocean_zone_act_1		; Act 2
	; CNZ
	zoneTableEntry.w  casino_night_zone_act_2	; Act 1
	zoneTableEntry.w  hill_top_zone_act_1		; Act 2
	; CPZ
	zoneTableEntry.w  chemical_plant_zone_act_2	; Act 1
	zoneTableEntry.w  aquatic_ruin_zone_act_1	; Act 2
	; DEZ
	zoneTableEntry.w  -1				; Act 1
	zoneTableEntry.w  0				; Act 2
	; ARZ
	zoneTableEntry.w  aquatic_ruin_zone_act_2	; Act 1
	zoneTableEntry.w  casino_night_zone_act_1	; Act 2
	; SCZ
	zoneTableEntry.w  wing_fortress_zone_act_1 	; Act 1
	zoneTableEntry.w  0				; Act 2
    zoneTableEnd

;word_1433C:
LevelOrder_2P: zoneOrderedTable 2,2	; WrdArr_LevelOrder_2P
	; EHZ
	zoneTableEntry.w  emerald_hill_zone_act_2	; Act 1
	zoneTableEntry.w  casino_night_zone_act_1	; Act 2
	; Zone 1
	zoneTableEntry.w  0				; Act 1
	zoneTableEntry.w  0				; Act 2
	; WZ
	zoneTableEntry.w  wood_zone_act_2		; Act 1
	zoneTableEntry.w  metropolis_zone_act_1		; Act 2
	; Zone 3
	zoneTableEntry.w  0				; Act 1
	zoneTableEntry.w  0				; Act 2
	; MTZ
	zoneTableEntry.w  metropolis_zone_act_2		; Act 1
	zoneTableEntry.w  metropolis_zone_act_3		; Act 2
	; MTZ
	zoneTableEntry.w  sky_chase_zone_act_1		; Act 3
	zoneTableEntry.w  0				; Act 4
	; WFZ
	zoneTableEntry.w  death_egg_zone_act_1		; Act 1
	zoneTableEntry.w  0				; Act 2
	; HTZ
	zoneTableEntry.w  hill_top_zone_act_2		; Act 1
	zoneTableEntry.w  mystic_cave_zone_act_1	; Act 2
	; HPZ
	zoneTableEntry.w  hidden_palace_zone_act_2 	; Act 1
	zoneTableEntry.w  oil_ocean_zone_act_1		; Act 2
	; Zone 9
	zoneTableEntry.w  0				; Act 1
	zoneTableEntry.w  0				; Act 2
	; OOZ
	zoneTableEntry.w  oil_ocean_zone_act_2		; Act 1
	zoneTableEntry.w  metropolis_zone_act_1		; Act 2
	; MCZ
	zoneTableEntry.w  mystic_cave_zone_act_2	; Act 1
	zoneTableEntry.w  -1				; Act 2
	; CNZ
	zoneTableEntry.w  casino_night_zone_act_2	; Act 1
	zoneTableEntry.w  mystic_cave_zone_act_1	; Act 2
	; CPZ
	zoneTableEntry.w  chemical_plant_zone_act_2 	; Act 1
	zoneTableEntry.w  aquatic_ruin_zone_act_1	; Act 2
	; DEZ
	zoneTableEntry.w  -1				; Act 1
	zoneTableEntry.w  0				; Act 2
	; ARZ
	zoneTableEntry.w  aquatic_ruin_zone_act_2	; Act 1
	zoneTableEntry.w  casino_night_zone_act_1	; Act 2
	; SCZ
	zoneTableEntry.w  wing_fortress_zone_act_1 	; Act 1
	zoneTableEntry.w  0				; Act 2
    zoneTableEnd
results_screen_object macro startx, targetx, y, routine, frame
	dc.w	startx, targetx, spriteScreenPositionYCentered(y)
	dc.b	routine, frame
    endm

results_screen_object_size = 8

; byte_14380:
Obj3A_SubObjectMetadata:
	;                               start X,          target X, start Y, routine, map frame
	results_screen_object  spriteScreenPositionX(            0-96), spriteScreenPositionXCentered(  0),     -56,       2,         0
	results_screen_object  spriteScreenPositionX( screen_width+64), spriteScreenPositionXCentered(-32),     -38,       4,         3
	results_screen_object  spriteScreenPositionX(screen_width+128), spriteScreenPositionXCentered( 32),     -38,       6,         4
	results_screen_object  spriteScreenPositionX(screen_width+184), spriteScreenPositionXCentered( 88),     -50,       8,         6
	results_screen_object  spriteScreenPositionX(screen_width+400), spriteScreenPositionXCentered(  0),      48,       4,         9
	results_screen_object  spriteScreenPositionX(screen_width+352), spriteScreenPositionXCentered(  0),       0,       4,        $A
	results_screen_object  spriteScreenPositionX(screen_width+368), spriteScreenPositionXCentered(  0),      16,       4,        $B
	results_screen_object  spriteScreenPositionX(screen_width+384), spriteScreenPositionXCentered(  0),      32,     $16,        $E
Obj3A_SubObjectMetadata_End:
; ===========================================================================
