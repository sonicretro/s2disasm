; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Game Mode: Level (and Demo)
; ----------------------------------------------------------------------------
; 1P Music Playlist
;----------------------------------------------------------------------------
; byte_3EA0:
MusicList: zoneOrderedTable 1,1
	zoneTableEntry.b MusID_EHZ	; 0 ; EHZ
	zoneTableEntry.b MusID_EHZ	; 1
	zoneTableEntry.b MusID_MTZ	; 2
	zoneTableEntry.b MusID_OOZ	; 3
	zoneTableEntry.b MusID_MTZ	; 4 ; MTZ1,2
	zoneTableEntry.b MusID_MTZ	; 5 ; MTZ3
	zoneTableEntry.b MusID_WFZ	; 6 ; WFZ
	zoneTableEntry.b MusID_HTZ	; 7 ; HTZ
	zoneTableEntry.b MusID_HPZ	; 8
	zoneTableEntry.b MusID_SCZ	; 9
	zoneTableEntry.b MusID_OOZ	; 10 ; OOZ
	zoneTableEntry.b MusID_MCZ	; 11 ; MCZ
	zoneTableEntry.b MusID_CNZ	; 12 ; CNZ
	zoneTableEntry.b MusID_CPZ	; 13 ; CPZ
	zoneTableEntry.b MusID_DEZ	; 14 ; DEZ
	zoneTableEntry.b MusID_ARZ	; 15 ; ARZ
	zoneTableEntry.b MusID_SCZ	; 16 ; SCZ
    zoneTableEnd
	even
;----------------------------------------------------------------------------
; 2P Music Playlist
;----------------------------------------------------------------------------
; byte_3EB2:
MusicList2: zoneOrderedTable 1,1
	zoneTableEntry.b MusID_EHZ_2P	; 0  ; EHZ 2P
	zoneTableEntry.b MusID_EHZ	; 1
	zoneTableEntry.b MusID_MTZ	; 2
	zoneTableEntry.b MusID_OOZ	; 3
	zoneTableEntry.b MusID_MTZ	; 4
	zoneTableEntry.b MusID_MTZ	; 5
	zoneTableEntry.b MusID_WFZ	; 6
	zoneTableEntry.b MusID_HTZ	; 7
	zoneTableEntry.b MusID_HPZ	; 8
	zoneTableEntry.b MusID_SCZ	; 9
	zoneTableEntry.b MusID_OOZ	; 10
	zoneTableEntry.b MusID_MCZ_2P	; 11 ; MCZ 2P
	zoneTableEntry.b MusID_CNZ_2P	; 12 ; CNZ 2P
	zoneTableEntry.b MusID_CPZ	; 13
	zoneTableEntry.b MusID_DEZ	; 14
	zoneTableEntry.b MusID_ARZ	; 15
	zoneTableEntry.b MusID_SCZ	; 16
    zoneTableEnd
	even
; ===========================================================================
; ---------------------------------------------------------------------------
; Level
; DEMO AND ZONE LOOP (MLS values $08, $0C; bit 7 set indicates that load routine is running)
; ---------------------------------------------------------------------------
; loc_3EC4:
Level:
	bset	#GameModeFlag_TitleCard,(Game_Mode).w ; add $80 to screen mode (for pre level sequence)
	tst.w	(Demo_mode_flag).w	; test the old flag for the credits demos (now unused)
	bmi.s	+
	move.b	#MusID_FadeOut,d0
	bsr.w	PlaySound	; fade out music
+
	bsr.w	ClearPLC
	bsr.w	Pal_FadeToBlack
	tst.w	(Demo_mode_flag).w
	bmi.s	Level_ClrRam
	move	#$2700,sr
	bsr.w	ClearScreen
	jsr	(LoadTitleCard).l ; load title card patterns
	move	#$2300,sr
	moveq	#0,d0
	move.w	d0,(Timer_frames).w
	move.b	(Current_Zone).w,d0

	; multiply d0 by 12, the size of a level art load block
	add.w	d0,d0
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0

	lea	(LevelArtPointers).l,a2
	lea	(a2,d0.w),a2
	moveq	#0,d0
	move.b	(a2),d0	; PLC1 ID
	beq.s	+
	bsr.w	LoadPLC
+
	moveq	#PLCID_Std2,d0
	bsr.w	LoadPLC
	bsr.w	Level_SetPlayerMode
	moveq	#PLCID_Miles1up,d0
	tst.w	(Two_player_mode).w
	bne.s	+
	cmpi.w	#2,(Player_mode).w
	bne.s	Level_ClrRam
	addq.w	#PLCID_MilesLife-PLCID_Miles1up,d0
+
	tst.b	(Graphics_Flags).w
	bpl.s	+
	addq.w	#PLCID_Tails1up-PLCID_Miles1up,d0
+
	bsr.w	LoadPLC
; loc_3F48:
Level_ClrRam:
	clearRAM Sprite_Table_Input,Sprite_Table_Input_End
	clearRAM Object_RAM,Object_RAM_End ; clear object RAM
	clearRAM MiscLevelVariables,MiscLevelVariables_End
	clearRAM Misc_Variables,Misc_Variables_End
	clearRAM Oscillating_Data,Oscillating_variables_End
	; Bug: The '+C0' shouldn't be here; CNZ_saucer_data is only $40 bytes large
	clearRAM CNZ_saucer_data,CNZ_saucer_data_End+$C0

	cmpi.w	#chemical_plant_zone_act_2,(Current_ZoneAndAct).w ; CPZ 2
	beq.s	Level_InitWater
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w ; ARZ
	beq.s	Level_InitWater
	cmpi.b	#hidden_palace_zone,(Current_Zone).w ; HPZ
	bne.s	+

Level_InitWater:
	move.b	#1,(Water_flag).w
	move.w	#0,(Two_player_mode).w
+
	lea	(VDP_control_port).l,a6
	move.w	#$8B03,(a6)		; EXT-INT disabled, V scroll by screen, H scroll by line
	move.w	#$8200|(VRAM_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $E000
	move.w	#$8500|(VRAM_Sprite_Attribute_Table/$200),(a6)	; Sprite attribute table base: $F800
	move.w	#$9001,(a6)		; Scroll table size: 64x32
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8720,(a6)		; Background palette/color: 2/0
	move.w	#$8C81,(a6)		; H res 40 cells, no interlace
	tst.b	(Debug_options_flag).w
	beq.s	++
	btst	#button_C,(Ctrl_1_Held).w
	beq.s	+
	move.w	#$8C89,(a6)	; H res 40 cells, no interlace, S/H enabled
+
	btst	#button_A,(Ctrl_1_Held).w
	beq.s	+
	move.b	#1,(Debug_mode_flag).w
+
	move.w	#$8ADF,(Hint_counter_reserve).w	; H-INT every 223rd scanline
	tst.w	(Two_player_mode).w
	beq.s	+
	move.w	#$8A6B,(Hint_counter_reserve).w	; H-INT every 108th scanline
	move.w	#$8014,(a6)			; H-INT enabled
	move.w	#$8C87,(a6)			; H res 40 cells, double res interlace
+
	move.w	(Hint_counter_reserve).w,(a6)
	clr.w	(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	tst.b	(Water_flag).w	; does level have water?
	beq.s	Level_LoadPal	; if not, branch
	move.w	#$8014,(a6)	; H-INT enabled
	moveq	#0,d0
	move.w	(Current_ZoneAndAct).w,d0
    if ~~useFullWaterTables
	subi.w	#hidden_palace_zone_act_1,d0
    endif
	ror.b	#1,d0
	lsr.w	#6,d0
	andi.w	#$FFFE,d0
	lea	(WaterHeight).l,a1	; load water height array
	move.w	(a1,d0.w),d0
	move.w	d0,(Water_Level_1).w ; set water heights
	move.w	d0,(Water_Level_2).w
	move.w	d0,(Water_Level_3).w
	clr.b	(Water_routine).w	; clear water routine counter
	clr.b	(Water_fullscreen_flag).w	; clear water movement
	move.b	#1,(Water_on).w	; enable water
; loc_407C:
Level_LoadPal:
	moveq	#PalID_BGND,d0
	bsr.w	PalLoad_Now	; load Sonic's palette line
	tst.b	(Water_flag).w	; does level have water?
	beq.s	Level_GetBgm	; if not, branch
	moveq	#PalID_HPZ_U,d0	; palette number $15
	cmpi.b	#hidden_palace_zone,(Current_Zone).w
	beq.s	Level_WaterPal ; branch if level is HPZ
	moveq	#PalID_CPZ_U,d0	; palette number $16
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	beq.s	Level_WaterPal ; branch if level is CPZ
	moveq	#PalID_ARZ_U,d0	; palette number $17
; loc_409E:
Level_WaterPal:
	bsr.w	PalLoad_Water_Now	; load underwater palette (with d0)
	tst.b	(Last_star_pole_hit).w ; is it the start of the level?
	beq.s	Level_GetBgm	; if yes, branch
	move.b	(Saved_Water_move).w,(Water_fullscreen_flag).w
; loc_40AE:
Level_GetBgm:
	tst.w	(Demo_mode_flag).w
	bmi.s	+
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	lea_	MusicList,a1
	tst.w	(Two_player_mode).w
	beq.s	Level_PlayBgm
	lea_	MusicList2,a1
; loc_40C8:
Level_PlayBgm:
	move.b	(a1,d0.w),d0		; load from music playlist
	move.w	d0,(Level_Music).w	; store level music
	bsr.w	PlayMusic		; play level music
	move.b	#ObjID_TitleCard,(TitleCard+id).w ; load Obj34 (level title card) at $FFFFB080
; loc_40DA:
Level_TtlCard:
	move.b	#VintID_TitleCard,(Vint_routine).w
	bsr.w	WaitForVint
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	bsr.w	RunPLC_RAM
	move.w	(TitleCard_ZoneName+x_pos).w,d0
	cmp.w	(TitleCard_ZoneName+titlecard_x_target).w,d0 ; has title card sequence finished?
	bne.s	Level_TtlCard		; if not, branch
	tst.l	(Plc_Buffer).w		; are there any items in the pattern load cue?
	bne.s	Level_TtlCard		; if yes, branch
	move.b	#VintID_TitleCard,(Vint_routine).w
	bsr.w	WaitForVint
	jsr	(Hud_Base).l
+
	moveq	#PalID_BGND,d0
	bsr.w	PalLoad_ForFade	; load Sonic's palette line
	bsr.w	LevelSizeLoad
	jsrto	(DeformBgLayer).l, JmpTo_DeformBgLayer
	clr.w	(Vscroll_Factor_FG).w
	move.w	#-$E0,(Vscroll_Factor_P2_FG).w

	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf_End

	bsr.w	LoadZoneTiles
	jsrto	(loadZoneBlockMaps).l, JmpTo_loadZoneBlockMaps
	jsr	(loc_402D4).l
	jsrto	(DrawInitialBG).l, JmpTo_DrawInitialBG
	jsr	(ConvertCollisionArray).l
	bsr.w	LoadCollisionIndexes
	bsr.w	WaterEffects
	bsr.w	InitPlayers
	move.w	#0,(Ctrl_1_Logical).w
	move.w	#0,(Ctrl_2_Logical).w
	move.w	#0,(Ctrl_1).w
	move.w	#0,(Ctrl_2).w
	move.b	#1,(Control_Locked).w
	move.b	#1,(Control_Locked_P2).w
	move.b	#0,(Level_started_flag).w
; Level_ChkWater:
	tst.b	(Water_flag).w	; does level have water?
	beq.s	+	; if not, branch
	move.b	#ObjID_WaterSurface,(WaterSurface1+id).w ; load Obj04 (water surface) at $FFFFB380
	move.w	#$60,(WaterSurface1+x_pos).w ; set horizontal offset
	move.b	#ObjID_WaterSurface,(WaterSurface2+id).w ; load Obj04 (water surface) at $FFFFB3C0
	move.w	#$120,(WaterSurface2+x_pos).w ; set different horizontal offset
+
	cmpi.b	#chemical_plant_zone,(Current_Zone).w	; check if zone == CPZ
	bne.s	+			; branch if not
	move.b	#ObjID_CPZPylon,(CPZPylon+id).w ; load Obj7C (CPZ pylon) at $FFFFB340
+
	cmpi.b	#oil_ocean_zone,(Current_Zone).w	; check if zone == OOZ
	bne.s	Level_ClrHUD		; branch if not
	move.b	#ObjID_Oil,(Oil+id).w ; load Obj07 (OOZ oil) at $FFFFB380
; Level_LoadObj: misnomer now
Level_ClrHUD:
	moveq	#0,d0
	tst.b	(Last_star_pole_hit).w	; are you starting from a lamppost?
	bne.s	Level_FromCheckpoint	; if yes, branch
	move.w	d0,(Ring_count).w	; clear rings
	move.l	d0,(Timer).w		; clear time
	move.b	d0,(Extra_life_flags).w	; clear extra lives counter
	move.w	d0,(Ring_count_2P).w	; ditto for player 2
	move.l	d0,(Timer_2P).w
	move.b	d0,(Extra_life_flags_2P).w
; loc_41E4:
Level_FromCheckpoint:
	move.b	d0,(Time_Over_flag).w
	move.b	d0,(Time_Over_flag_2P).w
	move.b	d0,(SlotMachine_Routine).w
	move.w	d0,(SlotMachineInUse).w
	move.w	d0,(Debug_placement_mode).w
	move.w	d0,(Level_Inactive_flag).w
	move.b	d0,(Teleport_timer).w
	move.b	d0,(Teleport_flag).w
	move.w	d0,(Rings_Collected).w
	move.w	d0,(Rings_Collected_2P).w
	move.w	d0,(Monitors_Broken).w
	move.w	d0,(Monitors_Broken_2P).w
	move.w	d0,(Loser_Time_Left).w
	bsr.w	OscillateNumInit
	move.b	#1,(Update_HUD_score).w
	move.b	#1,(Update_HUD_rings).w
	move.b	#1,(Update_HUD_timer).w
	move.b	#1,(Update_HUD_timer_2P).w
	jsr	(ObjectsManager).l
	jsr	(RingsManager).l
	jsr	(SpecialCNZBumpers).l
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	jsrto	(AniArt_Load).l, JmpTo_AniArt_Load
	bsr.w	SetLevelEndType
	move.w	#0,(Demo_button_index).w
	move.w	#0,(Demo_button_index_2P).w
	lea	(DemoScriptPointers).l,a1
	moveq	#0,d0
	move.b	(Current_Zone).w,d0	; load zone value
	lsl.w	#2,d0
	movea.l	(a1,d0.w),a1
	tst.w	(Demo_mode_flag).w
	bpl.s	+
	lea	(EndingDemoScriptPointers).l,a1
	move.w	(Ending_demo_number).w,d0
	subq.w	#1,d0
	lsl.w	#2,d0
	movea.l	(a1,d0.w),a1
+
	move.b	1(a1),(Demo_press_counter).w
	tst.b	(Current_Zone).w	; emerald_hill_zone
	bne.s	+
	lea	(Demo_EHZ_Tails).l,a1
	move.b	1(a1),(Demo_press_counter_2P).w
+
	move.w	#$668,(Demo_Time_left).w
	tst.w	(Demo_mode_flag).w
	bpl.s	+
	move.w	#$21C,(Demo_Time_left).w
	cmpi.w	#4,(Ending_demo_number).w
	bne.s	+
	move.w	#$1FE,(Demo_Time_left).w
+
	tst.b	(Water_flag).w
	beq.s	++
	moveq	#PalID_HPZ_U,d0
	cmpi.b	#hidden_palace_zone,(Current_Zone).w
	beq.s	+
	moveq	#PalID_CPZ_U,d0
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	beq.s	+
	moveq	#PalID_ARZ_U,d0
+
	bsr.w	PalLoad_Water_ForFade
+
	move.w	#-1,(TitleCard_ZoneName+titlecard_leaveflag).w
	move.b	#$E,(TitleCard_Left+routine).w	; make the left part move offscreen
	move.w	#$A,(TitleCard_Left+titlecard_location).w

-	move.b	#VintID_TitleCard,(Vint_routine).w
	bsr.w	WaitForVint
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	bsr.w	RunPLC_RAM
	tst.b	(TitleCard_Background+id).w
	bne.s	-	; loop while the title card background is still loaded

	lea	(TitleCard).w,a1
	move.b	#$16,TitleCard_ZoneName-TitleCard+routine(a1)
	move.w	#$2D,TitleCard_ZoneName-TitleCard+anim_frame_duration(a1)
	move.b	#$16,TitleCard_Zone-TitleCard+routine(a1)
	move.w	#$2D,TitleCard_Zone-TitleCard+anim_frame_duration(a1)
	tst.b	TitleCard_ActNumber-TitleCard+id(a1)
	beq.s	+	; branch if the act number has been unloaded
	move.b	#$16,TitleCard_ActNumber-TitleCard+routine(a1)
	move.w	#$2D,TitleCard_ActNumber-TitleCard+anim_frame_duration(a1)
+	move.b	#0,(Control_Locked).w
	move.b	#0,(Control_Locked_P2).w
	move.b	#1,(Level_started_flag).w

; Level_StartGame: loc_435A:
	bclr	#GameModeFlag_TitleCard,(Game_Mode).w ; clear $80 from the game mode

; ---------------------------------------------------------------------------
; Main level loop (when all title card and loading sequences are finished)
; ---------------------------------------------------------------------------
; loc_4360:
Level_MainLoop:
	bsr.w	PauseGame
	move.b	#VintID_Level,(Vint_routine).w
	bsr.w	WaitForVint
	addq.w	#1,(Timer_frames).w ; add 1 to level timer
	bsr.w	MoveSonicInDemo
	bsr.w	WaterEffects
	jsr	(RunObjects).l
	tst.w	(Level_Inactive_flag).w
	bne.w	Level
	jsrto	(DeformBgLayer).l, JmpTo_DeformBgLayer
	bsr.w	UpdateWaterSurface
	jsr	(RingsManager).l
	cmpi.b	#casino_night_zone,(Current_Zone).w	; is it CNZ?
	bne.s	+			; if not, branch past jsr
	jsr	(SpecialCNZBumpers).l
+
	jsrto	(AniArt_Load).l, JmpTo_AniArt_Load
	bsr.w	PalCycle_Load
	bsr.w	RunPLC_RAM
	bsr.w	OscillateNumDo
	bsr.w	ChangeRingFrame
	bsr.w	CheckLoadSignpostArt
	jsr	(BuildSprites).l
	jsr	(ObjectsManager).l
	cmpi.b	#GameModeID_Demo,(Game_Mode).w	; check if in demo mode
	beq.s	+
	cmpi.b	#GameModeID_Level,(Game_Mode).w	; check if in normal play mode
	beq.w	Level_MainLoop
	rts
; ---------------------------------------------------------------------------
+
	tst.w	(Level_Inactive_flag).w
	bne.s	+
	tst.w	(Demo_Time_left).w
	beq.s	+
	cmpi.b	#GameModeID_Demo,(Game_Mode).w
	beq.w	Level_MainLoop
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ---------------------------------------------------------------------------
+
	cmpi.b	#GameModeID_Demo,(Game_Mode).w
	bne.s	+
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
+
	move.w	#1*60,(Demo_Time_left).w	; 1 second
	move.w	#$3F,(Palette_fade_range).w
	clr.w	(PalChangeSpeed).w
-
	move.b	#VintID_Level,(Vint_routine).w
	bsr.w	WaitForVint
	bsr.w	MoveSonicInDemo
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	jsr	(ObjectsManager).l
	subq.w	#1,(PalChangeSpeed).w
	bpl.s	+
	move.w	#2,(PalChangeSpeed).w
	bsr.w	Pal_FadeToBlack.UpdateAllColours
+
	tst.w	(Demo_Time_left).w
	bne.s	-
	rts

; ---------------------------------------------------------------------------
; Subroutine to set the player mode, which is forced to Sonic and Tails in
; the demo mode and in 2P mode
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4450:
Level_SetPlayerMode:
	cmpi.b	#GameModeID_TitleCard|GameModeID_Demo,(Game_Mode).w ; pre-level demo mode?
	beq.s	+			; if yes, branch
	tst.w	(Two_player_mode).w	; 2P mode?
	bne.s	+			; if yes, branch
	move.w	(Player_option).w,(Player_mode).w ; use the option chosen in the Options screen
	rts
; ---------------------------------------------------------------------------
+	move.w	#0,(Player_mode).w	; force Sonic and Tails
	rts
; End of function Level_SetPlayerMode


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_446E:
InitPlayers:
	move.w	(Player_mode).w,d0
	bne.s	InitPlayers_Alone ; branch if this isn't a Sonic and Tails game

	move.b	#ObjID_Sonic,(MainCharacter+id).w ; load Obj01 Sonic object at $FFFFB000
	move.b	#ObjID_SpindashDust,(Sonic_Dust+id).w ; load Obj08 Sonic's spindash dust/splash object at $FFFFD100

	cmpi.b	#wing_fortress_zone,(Current_Zone).w
	beq.s	+ ; skip loading Tails if this is WFZ
	cmpi.b	#death_egg_zone,(Current_Zone).w
	beq.s	+ ; skip loading Tails if this is DEZ
	cmpi.b	#sky_chase_zone,(Current_Zone).w
	beq.s	+ ; skip loading Tails if this is SCZ

	move.b	#ObjID_Tails,(Sidekick+id).w ; load Obj02 Tails object at $FFFFB040
	move.w	(MainCharacter+x_pos).w,(Sidekick+x_pos).w
	move.w	(MainCharacter+y_pos).w,(Sidekick+y_pos).w
	subi.w	#$20,(Sidekick+x_pos).w
	addi_.w	#4,(Sidekick+y_pos).w
	move.b	#ObjID_SpindashDust,(Tails_Dust+id).w ; load Obj08 Tails' spindash dust/splash object at $FFFFD140
+
	rts
; ===========================================================================
; loc_44BE:
InitPlayers_Alone: ; either Sonic or Tails but not both
	subq.w	#1,d0
	bne.s	InitPlayers_TailsAlone ; branch if this is a Tails alone game

	move.b	#ObjID_Sonic,(MainCharacter+id).w ; load Obj01 Sonic object at $FFFFB000
	move.b	#ObjID_SpindashDust,(Sonic_Dust+id).w ; load Obj08 Sonic's spindash dust/splash object at $FFFFD100
	rts
; ===========================================================================
; loc_44D0:
InitPlayers_TailsAlone:
	move.b	#ObjID_Tails,(MainCharacter+id).w ; load Obj02 Tails object at $FFFFB000
	move.b	#ObjID_SpindashDust,(Tails_Dust+id).w ; load Obj08 Tails' spindash dust/splash object at $FFFFD100
	addi_.w	#4,(MainCharacter+y_pos).w
	rts
; End of function InitPlayers





; ---------------------------------------------------------------------------
; Subroutine to move the water or oil surface sprites to where the screen is at
; (the closest match I could find to this subroutine in Sonic 1 is Obj1B_Action)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_44E4:
UpdateWaterSurface:
	tst.b	(Water_flag).w
	beq.s	++	; rts
	move.w	(Camera_X_pos).w,d1
	btst	#0,(Timer_frames+1).w
	beq.s	+
	addi.w	#$20,d1
+		; match obj x-position to screen position
	move.w	d1,d0
	addi.w	#$60,d0
	move.w	d0,(WaterSurface1+x_pos).w
	addi.w	#$120,d1
	move.w	d1,(WaterSurface2+x_pos).w
+
	rts
; End of function UpdateWaterSurface


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; ---------------------------------------------------------------------------
; Subroutine to do special water effects
; ---------------------------------------------------------------------------
; sub_450E: ; LZWaterEffects:
WaterEffects:
	tst.b	(Water_flag).w	; does level have water?
	beq.s	NonWaterEffects	; if not, branch
	tst.b	(Deform_lock).w
	bne.s	MoveWater
	cmpi.b	#6,(MainCharacter+routine).w	; is player dead?
	bhs.s	MoveWater			; if yes, branch
	bsr.w	DynamicWater
; loc_4526: ; LZMoveWater:
MoveWater:
	clr.b	(Water_fullscreen_flag).w
	moveq	#0,d0
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w	; is level ARZ?
	beq.s	+		; if yes, branch
	move.b	(Oscillating_Data).w,d0
	lsr.w	#1,d0
+
	add.w	(Water_Level_2).w,d0
	move.w	d0,(Water_Level_1).w
		; calculate distance between water surface and top of screen
	move.w	(Water_Level_1).w,d0
	sub.w	(Camera_Y_pos).w,d0
	bhs.s	+
	tst.w	d0
	bpl.s	+
	move.b	#$DF,(Hint_counter_reserve+1).w	; H-INT every 224th scanline
	move.b	#1,(Water_fullscreen_flag).w
+
	cmpi.w	#$DF,d0
	blo.s	+
	move.w	#$DF,d0
+
	move.b	d0,(Hint_counter_reserve+1).w	; H-INT every d0 scanlines
; loc_456A:
NonWaterEffects:
	cmpi.b	#oil_ocean_zone,(Current_Zone).w	; is the level OOZ?
	bne.s	+			; if not, branch
	bsr.w	OilSlides		; call oil slide routine
+
	cmpi.b	#wing_fortress_zone,(Current_Zone).w	; is the level WFZ?
	bne.s	+			; if not, branch
	bsr.w	WindTunnel		; call wind and block break routine
+
	rts
; End of function WaterEffects

; ===========================================================================
    if useFullWaterTables
WaterHeight: zoneOrderedTable 2,2
	zoneTableEntry.w  $600, $600	; EHZ
	zoneTableEntry.w  $600, $600	; Zone 1
	zoneTableEntry.w  $600, $600	; WZ
	zoneTableEntry.w  $600, $600	; Zone 3
	zoneTableEntry.w  $600, $600	; MTZ
	zoneTableEntry.w  $600, $600	; MTZ
	zoneTableEntry.w  $600, $600	; WFZ
	zoneTableEntry.w  $600, $600	; HTZ
	zoneTableEntry.w  $600, $600	; HPZ
	zoneTableEntry.w  $600, $600	; Zone 9
	zoneTableEntry.w  $600, $600	; OOZ
	zoneTableEntry.w  $600, $600	; MCZ
	zoneTableEntry.w  $600, $600	; CNZ
	zoneTableEntry.w  $600, $710	; CPZ
	zoneTableEntry.w  $600, $600	; DEZ
	zoneTableEntry.w  $410, $510	; ARZ
	zoneTableEntry.w  $600, $600	; SCZ
    zoneTableEnd
    else
; word_4584:
WaterHeight:
	dc.w  $600, $600	; HPZ
	dc.w  $600, $600	; Zone 9
	dc.w  $600, $600	; OOZ
	dc.w  $600, $600	; MCZ
	dc.w  $600, $600	; CNZ
	dc.w  $600, $710	; CPZ
	dc.w  $600, $600	; DEZ
	dc.w  $410, $510	; ARZ
    endif

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_45A4: ; LZDynamicWater:
DynamicWater:
	moveq	#0,d0
	move.w	(Current_ZoneAndAct).w,d0
    if ~~useFullWaterTables
	subi.w	#hidden_palace_zone_act_1,d0
    endif
	ror.b	#1,d0
	lsr.w	#6,d0
	andi.w	#$FFFE,d0
	move.w	Dynamic_water_routine_table(pc,d0.w),d0
	jsr	Dynamic_water_routine_table(pc,d0.w)
	moveq	#0,d1
	move.b	(Water_on).w,d1
	move.w	(Water_Level_3).w,d0
	sub.w	(Water_Level_2).w,d0
	beq.s	++	; rts
	bcc.s	+
	neg.w	d1
+
	add.w	d1,(Water_Level_2).w
+
	rts
; End of function DynamicWater

; ===========================================================================
    if useFullWaterTables
Dynamic_water_routine_table: zoneOrderedOffsetTable 2,2
	zoneOffsetTableEntry.w DynamicWaterNull ; EHZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; EHZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 1
	zoneOffsetTableEntry.w DynamicWaterNull ; WZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; WZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 3
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 3
	zoneOffsetTableEntry.w DynamicWaterNull ; MTZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; MTZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; MTZ 3
	zoneOffsetTableEntry.w DynamicWaterNull ; MTZ 4
	zoneOffsetTableEntry.w DynamicWaterNull ; WFZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; WFZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; HTZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; HTZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; HPZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; HPZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 9
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 9
	zoneOffsetTableEntry.w DynamicWaterNull ; OOZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; OOZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; MCZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; MCZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; CNZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; CNZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; CPZ 1
	zoneOffsetTableEntry.w DynamicWaterCPZ2 ; CPZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; DEZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; DEZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; ARZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; ARZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; SCZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; SCZ 2
    zoneTableEnd
    else
; off_45D8:
Dynamic_water_routine_table: offsetTable
	offsetTableEntry.w DynamicWaterNull ; HPZ 1
	offsetTableEntry.w DynamicWaterNull ; HPZ 2
	offsetTableEntry.w DynamicWaterNull ; Zone 9
	offsetTableEntry.w DynamicWaterNull ; Zone 9
	offsetTableEntry.w DynamicWaterNull ; OOZ 1
	offsetTableEntry.w DynamicWaterNull ; OOZ 2
	offsetTableEntry.w DynamicWaterNull ; MCZ 1
	offsetTableEntry.w DynamicWaterNull ; MCZ 2
	offsetTableEntry.w DynamicWaterNull ; CNZ 1
	offsetTableEntry.w DynamicWaterNull ; CNZ 2
	offsetTableEntry.w DynamicWaterNull ; CPZ 1
	offsetTableEntry.w DynamicWaterCPZ2 ; CPZ 2
	offsetTableEntry.w DynamicWaterNull ; DEZ 1
	offsetTableEntry.w DynamicWaterNull ; DEZ 2
	offsetTableEntry.w DynamicWaterNull ; ARZ 1
	offsetTableEntry.w DynamicWaterNull ; ARZ 2
    endif
; ===========================================================================
; return_45F8:
DynamicWaterNull:
	rts
; ===========================================================================
; loc_45FA:
DynamicWaterCPZ2:
	cmpi.w	#$1DE0,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	#$510,(Water_Level_3).w
+	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Equates:
windtunnel_min_x_pos	= 0
windtunnel_max_x_pos	= 4
windtunnel_min_y_pos	= 2
windtunnel_max_y_pos	= 6

; sub_460A:
WindTunnel:
	tst.w	(Debug_placement_mode).w
	bne.w	WindTunnel_End	; don't interact with wind tunnels while in debug mode
	lea	(WindTunnelsCoordinates).l,a2
	moveq	#(WindTunnelsCoordinates_End-WindTunnelsCoordinates)/8-1,d1
	lea	(MainCharacter).w,a1 ; a1=character
-	; check for current wind tunnel if the main character is inside it
	move.w	x_pos(a1),d0
	cmp.w	windtunnel_min_x_pos(a2),d0
	blo.w	WindTunnel_Leave	; branch, if main character is too far left
	cmp.w	windtunnel_max_x_pos(a2),d0
	bhs.w	WindTunnel_Leave	; branch, if main character is too far right
	move.w	y_pos(a1),d2
	cmp.w	windtunnel_min_y_pos(a2),d2
	blo.w	WindTunnel_Leave	; branch, if main character is too far up
	cmp.w	windtunnel_max_y_pos(a2),d2
	bhs.s	WindTunnel_Leave	; branch, if main character is too far down
	tst.b	(WindTunnel_holding_flag).w
	bne.w	WindTunnel_End
	cmpi.b	#4,routine(a1)		; is the main character hurt, dying, etc. ?
	bhs.s	WindTunnel_LeaveHurt	; if yes, branch
	move.b	#1,(WindTunnel_flag).w	; affects character animation and bubble movement
	subi_.w	#4,x_pos(a1)	; move main character to the left
	move.w	#-$400,x_vel(a1)
	move.w	#0,y_vel(a1)
	move.b	#AniIDSonAni_Float2,anim(a1)
	bset	#1,status(a1)	; set "in-air" bit
	btst	#button_up,(Ctrl_1_Held).w	; is Up being pressed?
	beq.s	+				; if not, branch
	subq.w	#1,y_pos(a1)	; move up
+
	btst	#button_down,(Ctrl_1_Held).w	; is Down being pressed?
	beq.s	+				; if not, branch
	addq.w	#1,y_pos(a1)	; move down
+
	rts
; ===========================================================================
; loc_4690:
WindTunnel_Leave:
	addq.w	#8,a2
	dbf	d1,-	; check next tunnel
	; when all wind tunnels have been checked
	tst.b	(WindTunnel_flag).w
	beq.s	WindTunnel_End
	move.b	#AniIDSonAni_Walk,anim(a1)
; loc_46A2:
WindTunnel_LeaveHurt:	; the main character is hurt or dying, leave the tunnel and don't check the other
	clr.b	(WindTunnel_flag).w
; return_46A6:
WindTunnel_End:
	rts
; End of function WindTunnel

; ===========================================================================
; word_46A8:
WindTunnelsCoordinates:
	dc.w $1510,$400,$1AF0,$580
	dc.w $20F0,$618,$2500,$680
WindTunnelsCoordinates_End:

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_46B8:
OilSlides:
	lea	(MainCharacter).w,a1 ; a1=character
	move.b	(Ctrl_1_Held_Logical).w,d2
	bsr.s	+
	lea	(Sidekick).w,a1 ; a1=character
	move.b	(Ctrl_2_Held_Logical).w,d2
+
	btst	#1,status(a1)
	bne.s	+
	move.w	y_pos(a1),d0
	add.w	d0,d0
	andi.w	#$F00,d0
	move.w	x_pos(a1),d1
	lsr.w	#7,d1
	andi.w	#$7F,d1
	add.w	d1,d0
	lea	(Level_Layout).w,a2
	move.b	(a2,d0.w),d0
	lea	OilSlides_Chunks_End(pc),a2

	moveq	#OilSlides_Chunks_End-OilSlides_Chunks-1,d1
-	cmp.b	-(a2),d0
	dbeq	d1,-

	beq.s	loc_4712
+
    if status_sec_isSliding = 7
	tst.b	status_secondary(a1)
	bpl.s	+	; rts
    else
	btst	#status_sec_isSliding,status_secondary(a1)
	beq.s	+	; rts
    endif
	move.w	#5,move_lock(a1)
	andi.b	#(~status_sec_isSliding_mask)&$FF,status_secondary(a1)
+	rts
; ===========================================================================

loc_4712:
	lea	(OilSlides_Speeds).l,a2
	move.b	(a2,d1.w),d0
	beq.s	loc_476E
	move.b	inertia(a1),d1
	tst.b	d0
	bpl.s	+
	cmp.b	d0,d1
	ble.s	++
	subi.w	#$40,inertia(a1)
	bra.s	++
; ===========================================================================
+
	cmp.b	d0,d1
	bge.s	+
	addi.w	#$40,inertia(a1)
+
	bclr	#0,status(a1)
	tst.b	d1
	bpl.s	+
	bset	#0,status(a1)
+
	move.b	#AniIDSonAni_Slide,anim(a1)
	ori.b	#status_sec_isSliding_mask,status_secondary(a1)
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+	; rts
	move.w	#SndID_OilSlide,d0
	jsr	(PlaySound).l
+
	rts
; ===========================================================================

loc_476E:
	move.w	#4,d1
	move.w	inertia(a1),d0
	btst	#button_left,d2
	beq.s	+
	move.b	#AniIDSonAni_Walk,anim(a1)
	bset	#0,status(a1)
	sub.w	d1,d0
	tst.w	d0
	bpl.s	+
	sub.w	d1,d0
+
	btst	#button_right,d2
	beq.s	+
	move.b	#AniIDSonAni_Walk,anim(a1)
	bclr	#0,status(a1)
	add.w	d1,d0
	tst.w	d0
	bmi.s	+
	add.w	d1,d0
+
	move.w	#4,d1
	tst.w	d0
	beq.s	+++
	bmi.s	++
	sub.w	d1,d0
	bhi.s	+
	move.w	#0,d0
	move.b	#AniIDSonAni_Wait,anim(a1)
+	bra.s	++
; ===========================================================================
+
	add.w	d1,d0
	bhi.s	+
	move.w	#0,d0
	move.b	#AniIDSonAni_Wait,anim(a1)
+
	move.w	d0,inertia(a1)
	ori.b	#status_sec_isSliding_mask,status_secondary(a1)
	rts
; End of function OilSlides

; ===========================================================================
OilSlides_Speeds:
	dc.b  -8, -8, -8,  8,  8,  0,  0,  0, -8, -8,  0,  8,  8,  8,  0,  8
	dc.b   8,  8,  0, -8,  0,  0, -8,  8, -8, -8, -8,  8,  8,  8, -8, -8 ; 16

; These are the IDs of the chunks where Sonic and Tails will slide
OilSlides_Chunks:
	dc.b $2F,$30,$31,$33,$35,$38,$3A,$3C,$63,$64,$83,$90,$91,$93,$A1,$A3
	dc.b $BD,$C7,$C8,$CE,$D7,$D8,$E6,$EB,$EC,$ED,$F1,$F2,$F3,$F4,$FA,$FD ; 16
OilSlides_Chunks_End:
	even




; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_481E:
MoveSonicInDemo:
	tst.w	(Demo_mode_flag).w	; is demo mode on?
	bne.w	MoveDemo_On	; if yes, branch
	rts
; ---------------------------------------------------------------------------
; demo recording routine
; (unused/dead code, but obviously used during development)
; ---------------------------------------------------------------------------
; MoveDemo_Record: loc_4828:
	; calculate output location of recorded player 1 demo?
	lea	(DemoScriptPointers).l,a1
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	lsl.w	#2,d0
	movea.l	(a1,d0.w),a1
	move.w	(Demo_button_index).w,d0
	adda.w	d0,a1

	move.b	(Ctrl_1_Held).w,d0	; load input of player 1
	cmp.b	(a1),d0			; is same button held?
	bne.s	+			; if not, branch
	addq.b	#1,1(a1)		; increment press length counter
	cmpi.b	#$FF,1(a1)		; is button held too long?
	beq.s	+			; if yes, branch
	bra.s	MoveDemo_Record_P2	; go to player 2
; ===========================================================================
+
	move.b	d0,2(a1)		; store last button press
	move.b	#0,3(a1)		; reset hold length counter
	addq.w	#2,(Demo_button_index).w ; advance to next button press
	andi.w	#$3FF,(Demo_button_index).w ; wrap at max button press changes 1024
; loc_486A:
MoveDemo_Record_P2:
	cmpi.b	#emerald_hill_zone,(Current_Zone).w
	bne.s	++	; rts
	lea	($FEC000).l,a1		; output location of recorded player 2 demo? (unknown)
	move.w	(Demo_button_index_2P).w,d0
	adda.w	d0,a1
	move.b	(Ctrl_2_Held).w,d0	; load input of player 2
	cmp.b	(a1),d0			; is same button held?
	bne.s	+			; if not, branch
	addq.b	#1,1(a1)		; increment press length counter
	cmpi.b	#$FF,1(a1)		; is button held too long?
	beq.s	+			; if yes, branch
	bra.s	++			; if not, return
; ===========================================================================
+
	move.b	d0,2(a1)		; store last button press
	move.b	#0,3(a1)		; reset hold length counter
	addq.w	#2,(Demo_button_index_2P).w ; advance to next button press
	andi.w	#$3FF,(Demo_button_index_2P).w ; wrap at max button press changes 1024
+	rts
	; end of inactive recording code
; ===========================================================================
	; continue with MoveSonicInDemo:

; loc_48AA:
MoveDemo_On:
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0
	beq.s	+
	tst.w	(Demo_mode_flag).w
	bmi.s	+
	move.b	#GameModeID_TitleScreen,(Game_Mode).w ; => TitleScreen
+
	lea	(DemoScriptPointers).l,a1 ; load pointer to input data
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w ; special stage mode?
	bne.s	MoveDemo_On_P1		; if yes, branch
	moveq	#6,d0
; loc_48DA:
MoveDemo_On_P1:
	lsl.w	#2,d0
	movea.l	(a1,d0.w),a1

	move.w	(Demo_button_index).w,d0
	adda.w	d0,a1	; a1 now points to the current button press data
	move.b	(a1),d0	; load button press
	lea	(Ctrl_1_Held).w,a0
	move.b	d0,d1
	moveq	#0,d2 ; this was modified from (a0) to #0 in Rev01 of Sonic 1 to nullify the following line
	eor.b	d2,d0	; does nothing now (used to let you hold a button to prevent Sonic from jumping in demos)
	move.b	d1,(a0)+ ; save button press data from demo to Ctrl_1_Held
	and.b	d1,d0	; does nothing now
	move.b	d0,(a0)+ ; save the same thing to Ctrl_1_Press
	subq.b	#1,(Demo_press_counter).w  ; decrement counter until next press
	bcc.s	MoveDemo_On_P2	   ; if it isn't 0 yet, branch
	move.b	3(a1),(Demo_press_counter).w ; reset counter to length of next press
	addq.w	#2,(Demo_button_index).w ; advance to next button press
; loc_4908:
MoveDemo_On_P2:
    if emerald_hill_zone_act_1<$100 ; will it fit within a byte?
	cmpi.b	#emerald_hill_zone_act_1,(Current_Zone).w
    else
	cmpi.w #emerald_hill_zone_act_1,(Current_ZoneAndAct).w ; avoid a range overflow error
    endif
	bne.s	MoveDemo_On_SkipP2 ; if it's not the EHZ demo, branch to skip player 2
	lea	(Demo_EHZ_Tails).l,a1

	; same as the corresponding remainder of MoveDemo_On_P1, but for player 2
	move.w	(Demo_button_index_2P).w,d0
	adda.w	d0,a1
	move.b	(a1),d0
	lea	(Ctrl_2_Held).w,a0
	move.b	d0,d1
	moveq	#0,d2
	eor.b	d2,d0
	move.b	d1,(a0)+
	and.b	d1,d0
	move.b	d0,(a0)+
	subq.b	#1,(Demo_press_counter_2P).w
	bcc.s	+	; rts
	move.b	3(a1),(Demo_press_counter_2P).w
	addq.w	#2,(Demo_button_index_2P).w
+
	rts
; ===========================================================================
; loc_4940:
MoveDemo_On_SkipP2:
	move.w	#0,(Ctrl_2).w
	rts
; End of function MoveSonicInDemo

; ===========================================================================
; ---------------------------------------------------------------------------
; DEMO SCRIPT POINTERS

; Contains an array of pointers to the script controlling the players actions
; to use for each level.
; ---------------------------------------------------------------------------
; off_4948:
DemoScriptPointers: zoneOrderedTable 4,1
	zoneTableEntry.l Demo_EHZ	; $00
	zoneTableEntry.l Demo_EHZ	; $01
	zoneTableEntry.l Demo_EHZ	; $02
	zoneTableEntry.l Demo_EHZ	; $03
	zoneTableEntry.l Demo_EHZ	; $04
	zoneTableEntry.l Demo_EHZ	; $05
	zoneTableEntry.l Demo_EHZ	; $06
	zoneTableEntry.l Demo_EHZ	; $07
	zoneTableEntry.l Demo_EHZ	; $08
	zoneTableEntry.l Demo_EHZ	; $09
	zoneTableEntry.l Demo_EHZ	; $0A
	zoneTableEntry.l Demo_EHZ	; $0B
	zoneTableEntry.l Demo_CNZ	; $0C
	zoneTableEntry.l Demo_CPZ	; $0D
	zoneTableEntry.l Demo_EHZ	; $0E
	zoneTableEntry.l Demo_ARZ	; $0F
	zoneTableEntry.l Demo_EHZ	; $10
    zoneTableEnd
; ---------------------------------------------------------------------------
; dword_498C:
EndingDemoScriptPointers:
	; these values are invalid addresses, but they were used for the ending
	; demos, which aren't present in Sonic 2
	dc.l   $8B0837
	dc.l   $42085C	; 1
	dc.l   $6A085F	; 2
	dc.l   $2F082C	; 3
	dc.l   $210803	; 4
	dc.l $28300808	; 5
	dc.l   $2E0815	; 6
	dc.l	$F0846	; 7
	dc.l   $1A08FF	; 8
	dc.l  $8CA0000	; 9
	dc.l	     0	; 10
	dc.l	     0	; 11




; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_49BC:
LoadCollisionIndexes:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	lsl.w	#2,d0
	move.l	#Primary_Collision,(Collision_addr).w
	move.w	d0,-(sp)
	movea.l	Off_ColP(pc,d0.w),a0
	lea	(Primary_Collision).w,a1
	bsr.w	KosDec
	move.w	(sp)+,d0
	movea.l	Off_ColS(pc,d0.w),a0
	lea	(Secondary_Collision).w,a1
	bra.w	KosDec
; End of function LoadCollisionIndexes

; ===========================================================================
; ---------------------------------------------------------------------------
; Pointers to primary collision indexes

; Contains an array of pointers to the primary collision index data for each
; level. 1 pointer for each level, pointing the primary collision index.
; ---------------------------------------------------------------------------
Off_ColP: zoneOrderedTable 4,1
	zoneTableEntry.l ColP_EHZHTZ
	zoneTableEntry.l ColP_Invalid	; 1
	zoneTableEntry.l ColP_MTZ	; 2
	zoneTableEntry.l ColP_Invalid	; 3
	zoneTableEntry.l ColP_MTZ	; 4
	zoneTableEntry.l ColP_MTZ	; 5
	zoneTableEntry.l ColP_WFZSCZ	; 6
	zoneTableEntry.l ColP_EHZHTZ	; 7
	zoneTableEntry.l ColP_HPZ	; 8
	zoneTableEntry.l ColP_Invalid	; 9
	zoneTableEntry.l ColP_OOZ	; 10
	zoneTableEntry.l ColP_MCZ	; 11
	zoneTableEntry.l ColP_CNZ	; 12
	zoneTableEntry.l ColP_CPZDEZ	; 13
	zoneTableEntry.l ColP_CPZDEZ	; 14
	zoneTableEntry.l ColP_ARZ	; 15
	zoneTableEntry.l ColP_WFZSCZ	; 16
    zoneTableEnd

; ---------------------------------------------------------------------------
; Pointers to secondary collision indexes

; Contains an array of pointers to the secondary collision index data for
; each level. 1 pointer for each level, pointing the secondary collision
; index.
; ---------------------------------------------------------------------------
Off_ColS: zoneOrderedTable 4,1
	zoneTableEntry.l ColS_EHZHTZ
	zoneTableEntry.l ColP_Invalid	; 1
	zoneTableEntry.l ColP_MTZ	; 2
	zoneTableEntry.l ColP_Invalid	; 3
	zoneTableEntry.l ColP_MTZ	; 4
	zoneTableEntry.l ColP_MTZ	; 5
	zoneTableEntry.l ColS_WFZSCZ	; 6
	zoneTableEntry.l ColS_EHZHTZ	; 7
	zoneTableEntry.l ColS_HPZ	; 8
	zoneTableEntry.l ColP_Invalid	; 9
	zoneTableEntry.l ColP_OOZ	; 10
	zoneTableEntry.l ColP_MCZ	; 11
	zoneTableEntry.l ColS_CNZ	; 12
	zoneTableEntry.l ColS_CPZDEZ	; 13
	zoneTableEntry.l ColS_CPZDEZ	; 14
	zoneTableEntry.l ColS_ARZ	; 15
	zoneTableEntry.l ColS_WFZSCZ	; 16
    zoneTableEnd


; ---------------------------------------------------------------------------
; Oscillating number subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4A70:
OscillateNumInit:
	lea	(Oscillating_Numbers).w,a1
	lea	(Osc_Data).l,a2
	moveq	#bytesToWcnt(Osc_Data_End-Osc_Data),d1
; loc_4A7C:
Osc_Loop:
	move.w	(a2)+,(a1)+
	dbf	d1,Osc_Loop
	rts
; End of function OscillateNumInit

; ===========================================================================
; word_4A84:
Osc_Data:
	dc.w %0000000001111101		; oscillation direction bitfield
	dc.w   $80,   0	; baseline values
	dc.w   $80,   0
	dc.w   $80,   0
	dc.w   $80,   0
	dc.w   $80,   0
	dc.w   $80,   0
	dc.w   $80,   0
	dc.w   $80,   0
	dc.w   $80,   0
	dc.w $3848, $EE
	dc.w $2080, $B4
	dc.w $3080,$10E
	dc.w $5080,$1C2
	dc.w $7080,$276
	dc.w   $80,   0
	dc.w $4000, $FE
Osc_Data_End:

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4AC6:
OscillateNumDo:
	tst.w	(Two_player_mode).w
	bne.s	+
	cmpi.b	#6,(MainCharacter+routine).w
	bhs.s	OscillateNumDo_Return
+
	lea	(Oscillating_Numbers).w,a1
	lea	(Osc_Data2).l,a2
	move.w	(a1)+,d3
	moveq	#bytesToLcnt(Osc_Data2_End-Osc_Data2),d1

-	move.w	(a2)+,d2
	move.w	(a2)+,d4
	btst	d1,d3
	bne.s	+
	move.w	2(a1),d0
	add.w	d2,d0
	move.w	d0,2(a1)
	_add.w	d0,0(a1)
	_cmp.b	0(a1),d4
	bhi.s	++
	bset	d1,d3
	bra.s	++
; ===========================================================================
+
	move.w	2(a1),d0
	sub.w	d2,d0
	move.w	d0,2(a1)
	_add.w	d0,0(a1)
	_cmp.b	0(a1),d4
	bls.s	+
	bclr	d1,d3
+
	addq.w	#4,a1
	dbf	d1,-

	move.w	d3,(Oscillation_Control).w
; return_4B22:
OscillateNumDo_Return:
	rts
; End of function OscillateNumDo

; ===========================================================================
; word_4B24:
Osc_Data2:
	dc.w	 2, $10
	dc.w	 2, $18
	dc.w	 2, $20
	dc.w	 2, $30
	dc.w	 4, $20
	dc.w	 8,   8
	dc.w	 8, $40
	dc.w	 4, $40
	dc.w	 2, $38
	dc.w	 2, $38
	dc.w	 2, $20
	dc.w	 3, $30
	dc.w	 5, $50
	dc.w	 7, $70
	dc.w	 2, $40
	dc.w	 2, $40
Osc_Data2_End:



; ---------------------------------------------------------------------------
; Subroutine to change global object animation variables (like rings)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4B64:
ChangeRingFrame:
	subq.b	#1,(Logspike_anim_counter).w
	bpl.s	+
	move.b	#$B,(Logspike_anim_counter).w
	subq.b	#1,(Logspike_anim_frame).w ; animate unused log spikes
	andi.b	#7,(Logspike_anim_frame).w
+
	subq.b	#1,(Rings_anim_counter).w
	bpl.s	+
	move.b	#7,(Rings_anim_counter).w
	addq.b	#1,(Rings_anim_frame).w ; animate rings in the level (obj25)
	andi.b	#3,(Rings_anim_frame).w
+
	subq.b	#1,(Unknown_anim_counter).w
	bpl.s	+
	move.b	#7,(Unknown_anim_counter).w
	addq.b	#1,(Unknown_anim_frame).w ; animate nothing (deleted special stage object is my best guess)
	cmpi.b	#6,(Unknown_anim_frame).w
	blo.s	+
	move.b	#0,(Unknown_anim_frame).w
+
	tst.b	(Ring_spill_anim_counter).w
	beq.s	+	; rts
	moveq	#0,d0
	move.b	(Ring_spill_anim_counter).w,d0
	add.w	(Ring_spill_anim_accum).w,d0
	move.w	d0,(Ring_spill_anim_accum).w
	rol.w	#7,d0
	andi.w	#3,d0
	move.b	d0,(Ring_spill_anim_frame).w ; animate scattered rings (obj37)
	subq.b	#1,(Ring_spill_anim_counter).w
+
	rts
; End of function ChangeRingFrame




; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

nosignpost macro actid
	cmpi.w	#actid,(Current_ZoneAndAct).w
	beq.ATTRIBUTE	+	; rts
    endm

; sub_4BD2:
SetLevelEndType:
	move.w	#0,(Level_Has_Signpost).w	; set level type to non-signpost
	tst.w	(Two_player_mode).w	; is it two-player competitive mode?
	bne.s	LevelEnd_SetSignpost	; if yes, branch
	nosignpost.w emerald_hill_zone_act_2
	nosignpost.w metropolis_zone_act_3
	nosignpost.w wing_fortress_zone_act_1
	nosignpost.w hill_top_zone_act_2
	nosignpost.w oil_ocean_zone_act_2
	nosignpost.s mystic_cave_zone_act_2
	nosignpost.s casino_night_zone_act_2
	nosignpost.s chemical_plant_zone_act_2
	nosignpost.s death_egg_zone_act_1
	nosignpost.s aquatic_ruin_zone_act_2
	nosignpost.s sky_chase_zone_act_1

; loc_4C40:
LevelEnd_SetSignpost:
	move.w	#1,(Level_Has_Signpost).w	; set level type to signpost
+	rts
; End of function SetLevelEndType


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4C48:
CheckLoadSignpostArt:
	tst.w	(Level_Has_Signpost).w
	beq.s	+	; rts
	tst.w	(Debug_placement_mode).w
	bne.s	+	; rts
	move.w	(Camera_X_pos).w,d0
	move.w	(Camera_Max_X_pos).w,d1
	subi.w	#$100,d1
	cmp.w	d1,d0
	blt.s	SignpostUpdateTailsBounds
	tst.b	(Update_HUD_timer).w
	beq.s	SignpostUpdateTailsBounds
	cmp.w	(Camera_Min_X_pos).w,d1
	beq.s	SignpostUpdateTailsBounds
	move.w	d1,(Camera_Min_X_pos).w ; prevent camera from scrolling back to the left
	tst.w	(Two_player_mode).w
	bne.s	+	; rts
	moveq	#PLCID_Signpost,d0 ; <== PLC_1F
	bra.w	LoadPLC2		; load signpost art
; ---------------------------------------------------------------------------
; loc_4C80:
SignpostUpdateTailsBounds:
	tst.w	(Two_player_mode).w
	beq.s	+	; rts
	move.w	(Camera_X_pos_P2).w,d0
	move.w	(Tails_Max_X_pos).w,d1
	subi.w	#$100,d1
	cmp.w	d1,d0
	blt.s	+	; rts
	tst.b	(Update_HUD_timer_2P).w
	beq.s	+	; rts
	cmp.w	(Tails_Min_X_pos).w,d1
	beq.s	+	; rts
	move.w	d1,(Tails_Min_X_pos).w ; prevent Tails from going past new left boundary
+	rts
; End of function CheckLoadSignpostArt




; ===========================================================================
; macro to simplify editing the demo scripts
demoinput macro buttons,duration
btns_mask := 0
idx := 0
  rept strlen("buttons")
btn := substr("buttons",idx,1)
    switch btn
    case "U"
btns_mask := btns_mask|button_up_mask
    case "D"
btns_mask := btns_mask|button_down_mask
    case "L"
btns_mask := btns_mask|button_left_mask
    case "R"
btns_mask := btns_mask|button_right_mask
    case "A"
btns_mask := btns_mask|button_A_mask
    case "B"
btns_mask := btns_mask|button_B_mask
    case "C"
btns_mask := btns_mask|button_C_mask
    case "S"
btns_mask := btns_mask|button_start_mask
    endcase
idx := idx+1
  endm
	dc.b	btns_mask,duration-1
 endm
; ---------------------------------------------------------------------------
; EHZ Demo Script (Sonic)
; ---------------------------------------------------------------------------
; byte_4CA8: Demo_Def:
Demo_EHZ:
	demoinput ,	$4C
	demoinput R,	$43
	demoinput RC,	9
	demoinput R,	$3F
	demoinput RC,	6
	demoinput R,	$B0
	demoinput RC,	$A
	demoinput R,	$46
	demoinput ,	$1E
	demoinput L,	$F
	demoinput ,	5
	demoinput L,	5
	demoinput ,	9
	demoinput L,	$3F
	demoinput ,	5
	demoinput R,	$67
	demoinput ,	$62
	demoinput R,	$12
	demoinput ,	$22
	demoinput D,	8
	demoinput DC,	7
	demoinput D,	$E
	demoinput ,	$3C
	demoinput R,	$A
	demoinput ,	$1E
	demoinput D,	7
	demoinput DC,	7
	demoinput D,	2
	demoinput ,	$F
	demoinput R,	$100
	demoinput R,	$2F
	demoinput ,	$23
	demoinput C,	8
	demoinput RC,	$10
	demoinput R,	3
	demoinput ,	$30
	demoinput RC,	$24
	demoinput R,	$BE
	demoinput ,	$C
	demoinput L,	$14
	demoinput ,	$17
	demoinput D,	3
	demoinput DC,	7
	demoinput D,	3
	demoinput ,	$64
	demoinput S,	1
	demoinput A,	1
	demoinput ,	1
; ---------------------------------------------------------------------------
; EHZ Demo Script (Tails)
; ---------------------------------------------------------------------------
; byte_4D08:
Demo_EHZ_Tails:
	demoinput ,	$3C
	demoinput R,	$10
	demoinput UR,	$44
	demoinput URC,	$7
	demoinput UR,	$7
	demoinput R,	$CA
	demoinput ,	$12
	demoinput R,	$2
	demoinput RC,	$9
	demoinput R,	$53
	demoinput ,	$12
	demoinput R,	$B
	demoinput RC,	$F
	demoinput R,	$24
	demoinput ,	$B
	demoinput C,	$5
	demoinput ,	$E
	demoinput R,	$56
	demoinput ,	$1F
	demoinput R,	$5B
	demoinput ,	$11
	demoinput R,	$100
	demoinput R,	$C1
	demoinput ,	$21
	demoinput L,	$E
	demoinput ,	$E
	demoinput C,	$5
	demoinput RC,	$10
	demoinput C,	$6
	demoinput ,	$D
	demoinput L,	$6
	demoinput ,	$5F
	demoinput R,	$74
	demoinput ,	$19
	demoinput L,	$45
	demoinput ,	$9
	demoinput D,	$31
	demoinput ,	$9
	demoinput R,	$E
	demoinput ,	$24
	demoinput R,	$28
	demoinput ,	$5
	demoinput R,	$1
	demoinput ,	$1
	demoinput ,	$1
	demoinput ,	$1
	demoinput ,	$1
	demoinput ,	$1
; ---------------------------------------------------------------------------
; CNZ Demo Script
; ---------------------------------------------------------------------------
Demo_CNZ:
	demoinput ,	$49
	demoinput R,	$11
	demoinput UR,	1
	demoinput R,	2
	demoinput UR,	7
	demoinput R,	$61
	demoinput RC,	6
	demoinput C,	2
	demoinput ,	9
	demoinput L,	3
	demoinput DL,	4
	demoinput L,	2
	demoinput ,	$1A
	demoinput R,	$12
	demoinput RC,	$1A
	demoinput C,	5
	demoinput RC,	$24
	demoinput R,	$1B
	demoinput ,	8
	demoinput L,	$11
	demoinput ,	$F
	demoinput R,	$78
	demoinput RC,	$17
	demoinput C,	1
	demoinput ,	$10
	demoinput L,	$12
	demoinput ,	8
	demoinput R,	$53
	demoinput ,	$70
	demoinput R,	$75
	demoinput ,	$38
	demoinput R,	$17
	demoinput ,	5
	demoinput L,	$27
	demoinput ,	$D
	demoinput L,	$13
	demoinput ,	$6A
	demoinput C,	$11
	demoinput RC,	3
	demoinput DRC,	6
	demoinput DR,	$15
	demoinput R,	6
	demoinput ,	6
	demoinput L,	$D
	demoinput ,	$49
	demoinput L,	$A
	demoinput ,	$1F
	demoinput R,	7
	demoinput ,	$30
	demoinput L,	2
	demoinput ,	$100
	demoinput ,	$50
	demoinput R,	1
	demoinput RC,	$C
	demoinput R,	$2B
	demoinput ,	$5F
; ---------------------------------------------------------------------------
; CPZ Demo Script
; ---------------------------------------------------------------------------
Demo_CPZ:
	demoinput ,	$47
	demoinput R,	$1C
	demoinput RC,	8
	demoinput R,	$A
	demoinput ,	$1C
	demoinput R,	$E
	demoinput RC,	$29
	demoinput R,	$100
	demoinput R,	$E8
	demoinput DR,	5
	demoinput D,	2
	demoinput L,	$34
	demoinput DL,	$68
	demoinput L,	1
	demoinput ,	$16
	demoinput C,	1
	demoinput LC,	8
	demoinput L,	$F
	demoinput ,	$18
	demoinput R,	2
	demoinput DR,	2
	demoinput R,	$D
	demoinput ,	$20
	demoinput RC,	7
	demoinput R,	$B
	demoinput ,	$1C
	demoinput L,	$E
	demoinput ,	$1D
	demoinput L,	7
	demoinput ,	$100
	demoinput ,	$E0
	demoinput R,	$F
	demoinput ,	$1D
	demoinput L,	3
	demoinput ,	$26
	demoinput R,	7
	demoinput ,	7
	demoinput C,	5
	demoinput ,	$29
	demoinput L,	$12
	demoinput ,	$18
	demoinput R,	$1A
	demoinput ,	$11
	demoinput L,	$2E
	demoinput ,	$14
	demoinput S,	1
	demoinput A,	1
	demoinput ,	1
; ---------------------------------------------------------------------------
; ARZ Demo Script
; ---------------------------------------------------------------------------
Demo_ARZ:
	demoinput ,	$43
	demoinput R,	$4B
	demoinput RC,	9
	demoinput R,	$50
	demoinput RC,	$C
	demoinput R,	6
	demoinput ,	$1B
	demoinput R,	$61
	demoinput RC,	$15
	demoinput R,	$55
	demoinput ,	$41
	demoinput R,	5
	demoinput UR,	1
	demoinput R,	$5C
	demoinput ,	$47
	demoinput R,	$3C
	demoinput RC,	9
	demoinput R,	$28
	demoinput ,	$B
	demoinput R,	$93
	demoinput RC,	$33
	demoinput R,	$23
	demoinput ,	$23
	demoinput R,	$4D
	demoinput ,	$1F
	demoinput L,	2
	demoinput UL,	3
	demoinput L,	1
	demoinput ,	$B
	demoinput L,	$D
	demoinput ,	$11
	demoinput R,	6
	demoinput ,	$62
	demoinput R,	4
	demoinput RC,	6
	demoinput R,	$17
	demoinput ,	$1C
	demoinput R,	$57
	demoinput RC,	$B
	demoinput R,	$17
	demoinput ,	$16
	demoinput R,	$D
	demoinput ,	$2C
	demoinput C,	2
	demoinput RC,	$1B
	demoinput R,	$83
	demoinput ,	$C
	demoinput S,	1

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||



;sub_4E98:
LoadZoneTiles:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	lea	(LevelArtPointers).l,a2
	lea	(a2,d0.w),a2
	move.l	(a2)+,d0
	andi.l	#$FFFFFF,d0	; 8x8 tile pointer
	movea.l	d0,a0
	lea	(Chunk_Table).l,a1
	bsr.w	KosDec
	move.w	a1,d3
	cmpi.b	#hill_top_zone,(Current_Zone).w
	bne.s	+
	lea	(ArtKos_HTZ).l,a0
	lea	(Chunk_Table+tiles_to_bytes(ArtTile_ArtKos_NumTiles_HTZ_Main)).l,a1
	bsr.w	KosDec	; patch for HTZ
	move.w	#tiles_to_bytes(ArtTile_ArtKos_NumTiles_HTZ),d3
+
	cmpi.b	#wing_fortress_zone,(Current_Zone).w
	bne.s	+
	lea	(ArtKos_WFZ).l,a0
	lea	(Chunk_Table+tiles_to_bytes(ArtTile_ArtKos_NumTiles_WFZ_Main)).l,a1
	bsr.w	KosDec	; patch for WFZ
	move.w	#tiles_to_bytes(ArtTile_ArtKos_NumTiles_WFZ),d3
+
	cmpi.b	#death_egg_zone,(Current_Zone).w
	bne.s	+
	move.w	#tiles_to_bytes(ArtTile_ArtKos_NumTiles_DEZ),d3
+
	move.w	d3,d7
	andi.w	#$FFF,d3
	lsr.w	#1,d3
	rol.w	#4,d7
	andi.w	#$F,d7

-	move.w	d7,d2
	lsl.w	#7,d2
	lsl.w	#5,d2
	move.l	#$FFFFFF,d1
	move.w	d2,d1
	jsr	(QueueDMATransfer).l
	move.w	d7,-(sp)
	move.b	#VintID_TitleCard,(Vint_routine).w
	bsr.w	WaitForVint
	bsr.w	RunPLC_RAM
	move.w	(sp)+,d7
	move.w	#$800,d3
	dbf	d7,-

	rts
; End of function LoadZoneTiles

; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo_loadZoneBlockMaps 
	jmp	(loadZoneBlockMaps).l
JmpTo_DeformBgLayer 
	jmp	(DeformBgLayer).l
JmpTo_AniArt_Load 
	jmp	(AniArt_Load).l
JmpTo_DrawInitialBG 
	jmp	(DrawInitialBG).l

	align 4
    endif
