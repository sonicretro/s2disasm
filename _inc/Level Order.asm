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
