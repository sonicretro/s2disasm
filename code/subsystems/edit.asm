; ===========================================================================
; ---------------------------------------------------------------------------
; When debug mode is currently in use
; ---------------------------------------------------------------------------
; loc_41A78:
DebugMode:
	moveq	#0,d0
	move.b	(Debug_placement_mode).w,d0
	move.w	Debug_Index(pc,d0.w),d1
	jmp	Debug_Index(pc,d1.w)
; ===========================================================================
; off_41A86:
Debug_Index:	offsetTable
		offsetTableEntry.w Debug_Init	; 0
		offsetTableEntry.w Debug_Main	; 2
; ===========================================================================
; loc_41A8A: Debug_Main:
Debug_Init:
	addq.b	#2,(Debug_placement_mode).w
	move.w	(Camera_Min_Y_pos).w,(Camera_Min_Y_pos_Debug_Copy).w
	move.w	(Camera_Max_Y_pos_target).w,(Camera_Max_Y_pos_Debug_Copy).w
	cmpi.b	#sky_chase_zone,(Current_Zone).w
	bne.s	+
	move.w	#0,(Camera_Min_X_pos).w
	move.w	#$3FFF,(Camera_Max_X_pos).w
+
	andi.w	#$7FF,(MainCharacter+y_pos).w
	andi.w	#$7FF,(Camera_Y_pos).w
	andi.w	#$7FF,(Camera_BG_Y_pos).w
	clr.b	(Scroll_lock).w
	move.b	#0,mapping_frame(a0)
	move.b	#AniIDSonAni_Walk,anim(a0)
    if fixBugs
	; The 'in air' bit is left as whatever it was when Sonic entered
	; Debug Mode. This affects the camera's vertical deadzone.
	; Since 'Debug_ExitDebugMode' explicitly sets the 'in air' bit, it can
	; be assumed that having it cleared here was intended.
	bclr #1,(MainCharacter+status).w
    endif
	; S1 leftover
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w ; special stage mode? (you can't enter debug mode in S2's special stage)
	bne.s	.islevel	; if not, branch
	moveq	#6,d0		; force zone 6's debug object list (was the ending in S1)
	bra.s	.selectlist
; ===========================================================================
.islevel:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0

.selectlist:
	lea	(DebugObjectLists).l,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d6
	cmp.b	(Debug_object).w,d6
	bhi.s	+
	move.b	#0,(Debug_object).w
+
	bsr.w	LoadDebugObjectSprite
	move.b	#$C,(Debug_Accel_Timer).w
	move.b	#1,(Debug_Speed).w
; loc_41B0C:
Debug_Main:
	; S1 leftover
	moveq	#6,d0		; force zone 6's debug object list (was the ending in S1)
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; special stage mode? (you can't enter debug mode in S2's special stage)
	beq.s	.isntlevel	; if yes, branch

	moveq	#0,d0
	move.b	(Current_Zone).w,d0

.isntlevel:
	lea	(DebugObjectLists).l,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d6
	bsr.w	Debug_Control
	jmp	(DisplaySprite).l

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41B34:
Debug_Control:
;Debug_ControlMovement:
	moveq	#0,d4
	move.w	#1,d1
	move.b	(Ctrl_1_Press).w,d4
	andi.w	#button_up_mask|button_down_mask|button_left_mask|button_right_mask,d4
	bne.s	Debug_Move
	move.b	(Ctrl_1_Held).w,d0
	andi.w	#button_up_mask|button_down_mask|button_left_mask|button_right_mask,d0
	bne.s	Debug_ContinueMoving
	move.b	#$C,(Debug_Accel_Timer).w
	move.b	#$F,(Debug_Speed).w
	bra.w	Debug_ControlObjects
; ===========================================================================
; loc_41B5E:
Debug_ContinueMoving:
	subq.b	#1,(Debug_Accel_Timer).w
	bne.s	Debug_TimerNotOver
	move.b	#1,(Debug_Accel_Timer).w
	addq.b	#1,(Debug_Speed).w
	bne.s	Debug_Move
	move.b	#-1,(Debug_Speed).w
; loc_41B76:
Debug_Move:
	move.b	(Ctrl_1_Held).w,d4
; loc_41B7A:
Debug_TimerNotOver:
	moveq	#0,d1
	move.b	(Debug_Speed).w,d1
	addq.w	#1,d1
	swap	d1
	asr.l	#4,d1
	move.l	y_pos(a0),d2
	move.l	x_pos(a0),d3

	; Move up
	btst	#button_up,d4
	beq.s	.upNotHeld
	sub.l	d1,d2
	moveq	#0,d0
	move.w	(Camera_Min_Y_pos).w,d0
	swap	d0
	cmp.l	d0,d2
	bge.s	.minYPosNotReached
	move.l	d0,d2
.minYPosNotReached:
; loc_41BA4:
.upNotHeld:
	; Move down
	btst	#button_down,d4
	beq.s	.downNotHeld
	add.l	d1,d2
	moveq	#0,d0
	move.w	(Camera_Max_Y_pos_target).w,d0
	addi.w	#224-1,d0
	swap	d0
	cmp.l	d0,d2
	blt.s	.maxYPosNotReached
	move.l	d0,d2
.maxYPosNotReached:
; loc_41BBE:
.downNotHeld:
	; Move left
	btst	#button_left,d4
	beq.s	.leftNotHeld
	sub.l	d1,d3
	bcc.s	.minXPosNotReached
	moveq	#0,d3
.minXPosNotReached:
; loc_41BCA:
.leftNotHeld:
	; Move right
	btst	#button_right,d4
	beq.s	.rightNotHeld
	add.l	d1,d3
; loc_41BD2:
.rightNotHeld:
	move.l	d2,y_pos(a0)
	move.l	d3,x_pos(a0)
; loc_41BDA:
Debug_ControlObjects:
;Debug_CycleObjectsBackwards:
	btst	#button_A,(Ctrl_1_Held).w
	beq.s	Debug_SpawnObject
	btst	#button_C,(Ctrl_1_Press).w
	beq.s	Debug_CycleObjects
	; Cycle backwards though object list
	subq.b	#1,(Debug_object).w
	bcc.s	BranchTo_LoadDebugObjectSprite
	add.b	d6,(Debug_object).w
	bra.s	BranchTo_LoadDebugObjectSprite
; ===========================================================================
; loc_41BF6:
Debug_CycleObjects:
	btst	#button_A,(Ctrl_1_Press).w
	beq.s	Debug_SpawnObject
	; Cycle forwards though object list
	addq.b	#1,(Debug_object).w
	cmp.b	(Debug_object).w,d6
	bhi.s	BranchTo_LoadDebugObjectSprite
	move.b	#0,(Debug_object).w

BranchTo_LoadDebugObjectSprite ; BranchTo
	bra.w	LoadDebugObjectSprite
; ===========================================================================
; loc_41C12:
Debug_SpawnObject:
	btst	#button_C,(Ctrl_1_Press).w
	beq.s	Debug_ExitDebugMode
	; Spawn object
	jsr	(AllocateObject).l
	bne.s	Debug_ExitDebugMode
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	_move.b	mappings(a0),id(a1) ; load obj
	move.b	render_flags(a0),render_flags(a1)
    if fixBugs
	; The high bit of 'render_flags' is not cleared here. This causes
	; 'RunObjectDisplayOnly' to display the object even when it isn't
	; fully initialised. This causes the crash that occurs when you
	; attempt to spawn an object in Debug Mode while dead.
	andi.b	#$7F,render_flags(a1)
    endif
	move.b	render_flags(a0),status(a1)
	andi.b	#$7F,status(a1)
	moveq	#0,d0
	move.b	(Debug_object).w,d0
	lsl.w	#3,d0
	move.b	4(a2,d0.w),subtype(a1)
	rts
; ===========================================================================
; loc_41C56:
Debug_ExitDebugMode:
	btst	#button_B,(Ctrl_1_Press).w
	beq.s	return_41CB6
	; Exit debug mode
	moveq	#0,d0
	move.w	d0,(Debug_placement_mode).w
	lea	(MainCharacter).w,a1 ; a1=character
	move.l	#MapUnc_Sonic,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtUnc_Sonic,0,0),art_tile(a1)
	tst.w	(Two_player_mode).w
	beq.s	.notTwoPlayerMode
	move.w	#make_art_tile_2p(ArtTile_ArtUnc_Sonic,0,0),art_tile(a1)
; loc_41C82:
.notTwoPlayerMode:
	bsr.s	Debug_ResetPlayerStats
	move.b	#$13,y_radius(a1)
	move.b	#9,x_radius(a1)
	move.w	(Camera_Min_Y_pos_Debug_Copy).w,(Camera_Min_Y_pos).w
	move.w	(Camera_Max_Y_pos_Debug_Copy).w,(Camera_Max_Y_pos_target).w
	; useless leftover; this is for S1's special stage
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; special stage mode?
	bne.s	return_41CB6		; if not, branch
	move.b	#AniIDSonAni_Roll,(MainCharacter+anim).w
	bset	#2,(MainCharacter+status).w
	bset	#1,(MainCharacter+status).w

return_41CB6:
	rts
; End of function Debug_Control


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41CB8:
Debug_ResetPlayerStats:
	move.b	d0,anim(a1)
	move.w	d0,x_sub(a1) ; subpixel x
	move.w	d0,y_sub(a1) ; subpixel y
	move.b	d0,obj_control(a1)
	move.b	d0,spindash_flag(a1)
	move.w	d0,x_vel(a1)
	move.w	d0,y_vel(a1)
	move.w	d0,inertia(a1)
    if fixBugs
	andi.b	#1<<6,status(a1) ; Preserve the 'is underwater' flag, and clear everything else.
	ori.b	#2,status(a1)    ; Set the 'is rolling' flag.
    else
	; This resets the 'is underwater' flag, causing the bug where if you
	; enter Debug Mode underwater, and exit it above-water, Sonic will
	; still move as if he's underwater.
	move.b	#2,status(a1)
    endif
	move.b	#2,routine(a1)
	move.b	#0,routine_secondary(a1)
	rts
; End of function Debug_ResetPlayerStats


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41CEC:
LoadDebugObjectSprite:
	moveq	#0,d0
	move.b	(Debug_object).w,d0
	lsl.w	#3,d0
	move.l	(a2,d0.w),mappings(a0)
	move.w	6(a2,d0.w),art_tile(a0)
	move.b	5(a2,d0.w),mapping_frame(a0)
	jsrto	Adjust2PArtPointer, JmpTo66_Adjust2PArtPointer
	rts
; End of function LoadDebugObjectSprite

; ===========================================================================
; ---------------------------------------------------------------------------
; OBJECT DEBUG LISTS

; The jump table goes by level ID, so Metropolis Zone's list is repeated to
; account for its third act. Hidden Palace Zone uses Oil Ocean Zone's list.
; ---------------------------------------------------------------------------
; JmpTbl_DbgObjLists:
DebugObjectLists: zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w DbgObjList_EHZ	; EHZ
	zoneOffsetTableEntry.w DbgObjList_Def	; Zone 1
	zoneOffsetTableEntry.w DbgObjList_Def	; WZ
	zoneOffsetTableEntry.w DbgObjList_Def	; Zone 3
	zoneOffsetTableEntry.w DbgObjList_MTZ	; MTZ1,2
	zoneOffsetTableEntry.w DbgObjList_MTZ	; MTZ3
	zoneOffsetTableEntry.w DbgObjList_WFZ	; WFZ
	zoneOffsetTableEntry.w DbgObjList_HTZ	; HTZ
	zoneOffsetTableEntry.w DbgObjList_HPZ	; HPZ
	zoneOffsetTableEntry.w DbgObjList_Def	; Zone 9
	zoneOffsetTableEntry.w DbgObjList_OOZ	; OOZ
	zoneOffsetTableEntry.w DbgObjList_MCZ	; MCZ
	zoneOffsetTableEntry.w DbgObjList_CNZ	; CNZ
	zoneOffsetTableEntry.w DbgObjList_CPZ	; CPZ
	zoneOffsetTableEntry.w DbgObjList_Def	; DEZ
	zoneOffsetTableEntry.w DbgObjList_ARZ	; ARZ
	zoneOffsetTableEntry.w DbgObjList_SCZ	; SCZ
    zoneTableEnd

; macro for a debug object list header
; must be on the same line as a label that has a corresponding _End label later
dbglistheader macro {INTLABEL}
__LABEL__ label *
	dc.w ((__LABEL___End - __LABEL__ - 2) / 8)
    endm

; macro to define debug list object data
dbglistobj macro   obj, mapaddr, subtype, frame, vram
	dc.l obj<<24|mapaddr
	dc.b subtype,frame
	dc.w vram
    endm

DbgObjList_Def: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0) ; obj25 = ring
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0) ; obj26 = monitor
DbgObjList_Def_End

DbgObjList_EHZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_EHZWaterfall,	Obj49_MapUnc_20C50,   0,   0, make_art_tile(ArtTile_ArtNem_Waterfall,1,0)
	dbglistobj ObjID_EHZWaterfall,	Obj49_MapUnc_20C50,   2,   3, make_art_tile(ArtTile_ArtNem_Waterfall,1,0)
	dbglistobj ObjID_EHZWaterfall,	Obj49_MapUnc_20C50,   4,   5, make_art_tile(ArtTile_ArtNem_Waterfall,1,0)
	dbglistobj ObjID_EHZPlatform,	Obj18_MapUnc_107F6,   1,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_EHZPlatform,	Obj18_MapUnc_107F6, $9A,   1, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $A0,   6, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $30,   7, make_art_tile(ArtTile_ArtNem_DignlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $40,  $A, make_art_tile(ArtTile_ArtNem_DignlSprng,0,0)
	dbglistobj ObjID_Buzzer,	Obj4B_MapUnc_2D2EA,   0,   0, make_art_tile(ArtTile_ArtNem_Buzzer,0,0)
	dbglistobj ObjID_Masher,	Obj5C_MapUnc_2D442,   0,   0, make_art_tile(ArtTile_ArtNem_Masher,0,0)
	dbglistobj ObjID_Coconuts,	Obj9D_Obj98_MapUnc_37D96, $1E,   0, make_art_tile(ArtTile_ArtNem_Coconuts,0,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_EHZ_End

DbgObjList_MTZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_SteamSpring,	Obj42_MapUnc_2686C,   1,   7, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_MTZTwinStompers, Obj64_MapUnc_26A5C,   1,   0, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_MTZTwinStompers, Obj64_MapUnc_26A5C, $11,   1, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_MTZLongPlatform, Obj65_Obj6A_Obj6B_MapUnc_26EC8, $80,   0, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_MTZLongPlatform, Obj65_Obj6A_Obj6B_MapUnc_26EC8, $13,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_Button,	Obj47_MapUnc_24D96,   0,   2, make_art_tile(ArtTile_ArtNem_Button,0,0)
	dbglistobj ObjID_Barrier,	Obj2D_MapUnc_11822,   1,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_MTZSpringWall,	Obj66_MapUnc_27120,   1,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_MTZSpringWall,	Obj66_MapUnc_27120, $11,   1, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_SpikyBlock,	Obj68_Obj6D_MapUnc_27750,   0,   4, make_art_tile(ArtTile_ArtNem_MtzSpikeBlock,3,0)
	dbglistobj ObjID_Nut,		Obj69_MapUnc_27A26,   4,   0, make_art_tile(ArtTile_ArtNem_MtzAsstBlocks,1,0)
	dbglistobj ObjID_MTZMovingPforms, Obj65_Obj6A_Obj6B_MapUnc_26EC8,   0,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_MTZPlatform,	Obj65_Obj6A_Obj6B_MapUnc_26EC8,   7,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_FloorSpike,	Obj68_Obj6D_MapUnc_27750,   0,   0, make_art_tile(ArtTile_ArtNem_MtzSpike,1,0)
	dbglistobj ObjID_LargeRotPform,	Obj6E_MapUnc_2852C,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_LargeRotPform,	Obj6E_MapUnc_2852C, $10,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_LargeRotPform,	Obj6E_MapUnc_2852C, $20,   2, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_Cog,		Obj70_MapUnc_28786, $10,   0, make_art_tile(ArtTile_ArtNem_MtzWheel,3,1)
	dbglistobj ObjID_MTZLavaBubble,	Obj71_MapUnc_11576, $22,   5, make_art_tile(ArtTile_ArtNem_MtzLavaBubble,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_11552,   0,   0, make_art_tile(ArtTile_ArtNem_BoltEnd_Rope,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_11552,   1,   1, make_art_tile(ArtTile_ArtNem_BoltEnd_Rope,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_11552,   3,   2, make_art_tile(ArtTile_ArtNem_BoltEnd_Rope,1,0)
	dbglistobj ObjID_MTZLongPlatform, Obj65_Obj6A_Obj6B_MapUnc_26EC8, $B0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_Shellcracker,	Obj9F_MapUnc_38314, $24,   0, make_art_tile(ArtTile_ArtNem_Shellcracker,0,0)
	dbglistobj ObjID_Asteron,	ObjA4_Obj98_MapUnc_38A96, $2E,   0, make_art_tile(ArtTile_ArtNem_MtzSupernova,0,1)
	dbglistobj ObjID_Slicer,	ObjA1_MapUnc_385E2, $28,   0, make_art_tile(ArtTile_ArtNem_MtzMantis,1,0)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   0,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   1,   1, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   2,   2, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_MTZ_End

DbgObjList_WFZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_WFZPalSwitcher, Obj03_MapUnc_1FFB8,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $5E,   0, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $60,   1, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $62,   2, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_VPropeller,	ObjB4_MapUnc_3B3BE, $64,   0, make_art_tile(ArtTile_ArtNem_WfzVrtclPrpllr,1,1)
	dbglistobj ObjID_HPropeller,	ObjB5_MapUnc_3B548, $66,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1)
	dbglistobj ObjID_HPropeller,	ObjB5_MapUnc_3B548, $68,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1)
	dbglistobj ObjID_CluckerBase,	ObjAD_Obj98_MapUnc_395B4, $42,  $C, make_art_tile(ArtTile_ArtNem_WfzScratch,0,0)
	dbglistobj ObjID_Clucker,	ObjAD_Obj98_MapUnc_395B4, $44,  $B, make_art_tile(ArtTile_ArtNem_WfzScratch,0,0)
	dbglistobj ObjID_TiltingPlatform, ObjB6_MapUnc_3B856, $6A,   0, make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1)
	dbglistobj ObjID_TiltingPlatform, ObjB6_MapUnc_3B856, $6C,   0, make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1)
	dbglistobj ObjID_TiltingPlatform, ObjB6_MapUnc_3B856, $6E,   0, make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1)
	dbglistobj ObjID_TiltingPlatform, ObjB6_MapUnc_3B856, $70,   0, make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1)
	dbglistobj ObjID_VerticalLaser,	ObjB7_MapUnc_3B8E4, $72,   0, make_art_tile(ArtTile_ArtNem_WfzVrtclLazer,2,1)
	dbglistobj ObjID_WallTurret,	ObjB8_Obj98_MapUnc_3BA46, $74,   0, make_art_tile(ArtTile_ArtNem_WfzWallTurret,0,0)
	dbglistobj ObjID_Laser,		ObjB9_MapUnc_3BB18, $76,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlLazer,2,1)
	dbglistobj ObjID_WFZWheel,	ObjBA_MapUnc_3BB70, $78,   0, make_art_tile(ArtTile_ArtNem_WfzConveyorBeltWheel,2,1)
	dbglistobj ObjID_WFZShipFire,	ObjBC_MapUnc_3BC08, $7C,   0, make_art_tile(ArtTile_ArtNem_WfzThrust,2,0)
	dbglistobj ObjID_SmallMetalPform, ObjBD_MapUnc_3BD3E, $7E,   0, make_art_tile(ArtTile_ArtNem_WfzBeltPlatform,3,1)
	dbglistobj ObjID_SmallMetalPform, ObjBD_MapUnc_3BD3E, $80,   0, make_art_tile(ArtTile_ArtNem_WfzBeltPlatform,3,1)
	dbglistobj ObjID_LateralCannon,	ObjBE_MapUnc_3BE46, $82,   0, make_art_tile(ArtTile_ArtNem_WfzGunPlatform,3,1)
	dbglistobj ObjID_WFZStick,	ObjBF_MapUnc_3BEE0, $84,   0, make_art_tile(ArtTile_ArtNem_WfzUnusedBadnik,3,1)
	dbglistobj ObjID_SpeedLauncher,	ObjC0_MapUnc_3C098,   8,   0, make_art_tile(ArtTile_ArtNem_WfzLaunchCatapult,1,0)
	dbglistobj ObjID_BreakablePlating, ObjC1_MapUnc_3C280, $88,   0, make_art_tile(ArtTile_ArtNem_BreakPanels,3,1)
	dbglistobj ObjID_Rivet,		ObjC2_MapUnc_3C3C2, $8A,   0, make_art_tile(ArtTile_ArtNem_WfzSwitch,1,1)
	dbglistobj ObjID_WFZPlatform,	Obj19_MapUnc_2222A, $38,   3, make_art_tile(ArtTile_ArtNem_WfzFloatingPlatform,1,1)
	dbglistobj ObjID_Grab,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_MovingVine,	Obj80_MapUnc_29DD0,   0,   0, make_art_tile(ArtTile_ArtNem_WfzHook_Fudge,1,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_WFZ_End

DbgObjList_HTZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_ForcedSpin,	Obj03_MapUnc_1FFB8,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_ForcedSpin,	Obj03_MapUnc_1FFB8,   4,   4, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_EHZPlatform,	Obj18_MapUnc_107F6,   1,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_EHZPlatform,	Obj18_MapUnc_107F6, $9A,   1, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Seesaw,	Obj14_MapUnc_21CF0,   0,   0, make_art_tile(ArtTile_ArtNem_HtzSeeSaw,0,0)
	dbglistobj ObjID_Barrier,	Obj2D_MapUnc_11822,   0,   0, make_art_tile(ArtTile_ArtNem_HtzValveBarrier,1,0)
	dbglistobj ObjID_SmashableGround, Obj2F_MapUnc_236FA,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,1)
	dbglistobj ObjID_LavaBubble,	Obj20_MapUnc_23254, $44,   2, make_art_tile(ArtTile_ArtNem_HtzFireball2,0,1)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $A0,   6, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $30,   7, make_art_tile(ArtTile_ArtNem_DignlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $40,  $A, make_art_tile(ArtTile_ArtNem_DignlSprng,0,0)
	dbglistobj ObjID_HTZLift,	Obj16_MapUnc_21F14,   0,   0, make_art_tile(ArtTile_ArtNem_HtzZipline,2,0)
	dbglistobj ObjID_BridgeStake,	Obj16_MapUnc_21F14,   4,   3, make_art_tile(ArtTile_ArtNem_HtzZipline,2,0)
	dbglistobj ObjID_BridgeStake,	Obj16_MapUnc_21F14,   5,   4, make_art_tile(ArtTile_ArtNem_HtzZipline,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_113D6,   7,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_113D6,   8,   1, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_BreakableRock,	Obj32_MapUnc_23852,   0,   0, make_art_tile(ArtTile_ArtNem_HtzRock,2,0)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   0,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   1,   1, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   2,   2, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_Rexon2,	Obj94_Obj98_MapUnc_37678,  $E,   2, make_art_tile(ArtTile_ArtNem_Rexon,3,0)
	dbglistobj ObjID_Spiker,	Obj92_Obj93_MapUnc_37092,  $A,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_Sol,		Obj95_MapUnc_372E6,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_HTZ_End

DbgObjList_HPZ:; dbglistheader
;	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
;	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
;DbgObjList_HPZ_End

DbgObjList_OOZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_OOZPoppingPform, Obj33_MapUnc_23DDC,   1,   0, make_art_tile(ArtTile_ArtNem_BurnerLid,3,0)
	dbglistobj ObjID_SlidingSpike,	Obj43_MapUnc_23FE0,   0,   0, make_art_tile(ArtTile_ArtNem_SpikyThing,2,1)
	dbglistobj ObjID_OOZMovingPform, Obj19_MapUnc_2222A, $23,   2, make_art_tile(ArtTile_ArtNem_OOZElevator,3,0)
	dbglistobj ObjID_OOZSpring,	Obj45_MapUnc_2451A,   2,   0, make_art_tile(ArtTile_ArtNem_PushSpring,2,0)
	dbglistobj ObjID_OOZSpring,	Obj45_MapUnc_2451A, $12,  $A, make_art_tile(ArtTile_ArtNem_PushSpring,2,0)
	dbglistobj ObjID_OOZBall,	Obj46_MapUnc_24C52,   0,   1, make_art_tile(ArtTile_ArtNem_BallThing,3,0)
	dbglistobj ObjID_Button,	Obj47_MapUnc_24D96,   0,   2, make_art_tile(ArtTile_ArtNem_Button,0,0)
	dbglistobj ObjID_SwingingPlatform, Obj15_MapUnc_101E8, $88,   1, make_art_tile(ArtTile_ArtNem_OOZSwingPlat,2,0)
	dbglistobj ObjID_OOZLauncher,	Obj3D_MapUnc_250BA,   0,   0, make_art_tile(ArtTile_ArtNem_StripedBlocksVert,3,0)
	dbglistobj ObjID_LauncherBall,	Obj48_MapUnc_254FE, $80,   0, make_art_tile(ArtTile_ArtNem_LaunchBall,3,0)
	dbglistobj ObjID_LauncherBall,	Obj48_MapUnc_254FE, $81,   1, make_art_tile(ArtTile_ArtNem_LaunchBall,3,0)
	dbglistobj ObjID_LauncherBall,	Obj48_MapUnc_254FE, $82,   2, make_art_tile(ArtTile_ArtNem_LaunchBall,3,0)
	dbglistobj ObjID_LauncherBall,	Obj48_MapUnc_254FE, $83,   3, make_art_tile(ArtTile_ArtNem_LaunchBall,3,0)
	dbglistobj ObjID_CollapsPform,	Obj1F_MapUnc_110C6,   0,   0, make_art_tile(ArtTile_ArtNem_OOZPlatform,3,0)
	dbglistobj ObjID_Fan,		Obj3F_MapUnc_2AA12,   0,   0, make_art_tile(ArtTile_ArtNem_OOZFanHoriz,3,0)
	dbglistobj ObjID_Fan,		Obj3F_MapUnc_2AAC4, $80,   0, make_art_tile(ArtTile_ArtNem_OOZFanHoriz,3,0)
	dbglistobj ObjID_Aquis,		Obj50_MapUnc_2CF94,   0,   0, make_art_tile(ArtTile_ArtNem_Aquis,1,0)
	dbglistobj ObjID_Octus,		Obj4A_MapUnc_2CBFE,   0,   0, make_art_tile(ArtTile_ArtNem_Octus,1,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $A,   0, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $B,   1, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $C,   2, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $D,   3, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $E,   4, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $F,   5, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $10,   0, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $11,   1, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $12,   2, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $13,   3, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $14,   4, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_OOZ_End

DbgObjList_MCZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_SwingingPlatform, Obj15_Obj7A_MapUnc_10256, $48,   2, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_CollapsPform,	Obj1F_MapUnc_11106,   0,   0, make_art_tile(ArtTile_ArtNem_MCZCollapsePlat,3,0)
	dbglistobj ObjID_RotatingRings,	Obj73_MapUnc_28B9C, $F5,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_MCZRotPforms,	Obj6A_MapUnc_27D30, $18,   0, make_art_tile(ArtTile_ArtNem_Crate,3,0)
	dbglistobj ObjID_Stomper,	Obj2A_MapUnc_11666,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68, $40,   4, make_art_tile(ArtTile_ArtNem_HorizSpike,1,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Springboard,	Obj40_MapUnc_265F4,   1,   0, make_art_tile(ArtTile_ArtNem_LeverSpring,0,0)
	dbglistobj ObjID_InvisibleBlock, Obj74_MapUnc_20F66, $11,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_MCZBrick,	Obj75_MapUnc_28D8A, $18,   2, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_SlidingSpikes,	Obj76_MapUnc_28F3A,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_MCZBridge,	Obj77_MapUnc_29064,   1,   0, make_art_tile(ArtTile_ArtNem_MCZGateLog,3,0)
	dbglistobj ObjID_VineSwitch,	Obj7F_MapUnc_29938,   0,   0, make_art_tile(ArtTile_ArtNem_VineSwitch,3,0)
	dbglistobj ObjID_MovingVine,	Obj80_MapUnc_29C64,   0,   0, make_art_tile(ArtTile_ArtNem_VinePulley,3,0)
	dbglistobj ObjID_MCZDrawbridge,	Obj81_MapUnc_2A24E,   0,   1, make_art_tile(ArtTile_ArtNem_MCZGateLog,3,0)
	dbglistobj ObjID_SidewaysPform,	Obj15_Obj7A_MapUnc_10256, $12,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_Flasher,	ObjA3_MapUnc_388F0, $2C,   0, make_art_tile(ArtTile_ArtNem_Flasher,0,1)
	dbglistobj ObjID_Crawlton,	Obj9E_MapUnc_37FF2, $22,   0, make_art_tile(ArtTile_ArtNem_Crawlton,1,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_MCZ_End

DbgObjList_CNZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_PinballMode,	Obj03_MapUnc_1FFB8,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_PinballMode,	Obj03_MapUnc_1FFB8,   4,   4, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,  $D,   5, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_RoundBumper,	Obj44_MapUnc_1F85A,   0,   0, make_art_tile(ArtTile_ArtNem_CNZRoundBumper,2,0)
	dbglistobj ObjID_LauncherSpring, Obj85_MapUnc_2B07E,   0,   0, make_art_tile(ArtTile_ArtNem_CNZVertPlunger,0,0)
	dbglistobj ObjID_LauncherSpring, Obj85_MapUnc_2B0EC, $81,   0, make_art_tile(ArtTile_ArtNem_CNZDiagPlunger,0,0)
	dbglistobj ObjID_Flipper,	Obj86_MapUnc_2B45A,   0,   0, make_art_tile(ArtTile_ArtNem_CNZFlipper,2,0)
	dbglistobj ObjID_Flipper,	Obj86_MapUnc_2B45A,   1,   4, make_art_tile(ArtTile_ArtNem_CNZFlipper,2,0)
	dbglistobj ObjID_CNZRectBlocks,	ObjD2_MapUnc_2B694,   1,   0, make_art_tile(ArtTile_ArtNem_CNZSnake,2,0)
	dbglistobj ObjID_BombPrize,	ObjD3_MapUnc_2B8D4,   0,   0, make_art_tile(ArtTile_ArtNem_CNZBonusSpike,0,0)
	dbglistobj ObjID_CNZBigBlock,	ObjD4_MapUnc_2B9CA,   0,   0, make_art_tile(ArtTile_ArtNem_BigMovingBlock,2,0)
	dbglistobj ObjID_CNZBigBlock,	ObjD4_MapUnc_2B9CA,   2,   0, make_art_tile(ArtTile_ArtNem_BigMovingBlock,2,0)
	dbglistobj ObjID_Elevator,	ObjD5_MapUnc_2BB40, $18,   0, make_art_tile(ArtTile_ArtNem_CNZElevator,2,0)
	dbglistobj ObjID_PointPokey,	ObjD6_MapUnc_2BEBC,   1,   0, make_art_tile(ArtTile_ArtNem_CNZCage,0,0)
	dbglistobj ObjID_Bumper,	ObjD7_MapUnc_2C626,   0,   0, make_art_tile(ArtTile_ArtNem_CNZHexBumper,2,0)
	dbglistobj ObjID_BonusBlock,	ObjD8_MapUnc_2C8C4,   0,   0, make_art_tile(ArtTile_ArtNem_CNZMiniBumper,2,0)
	dbglistobj ObjID_BonusBlock,	ObjD8_MapUnc_2C8C4, $40,   1, make_art_tile(ArtTile_ArtNem_CNZMiniBumper,2,0)
	dbglistobj ObjID_BonusBlock,	ObjD8_MapUnc_2C8C4, $80,   2, make_art_tile(ArtTile_ArtNem_CNZMiniBumper,2,0)
	dbglistobj ObjID_Crawl,		ObjC8_MapUnc_3D450, $AC,   0, make_art_tile(ArtTile_ArtNem_Crawl,0,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_CNZ_End

DbgObjList_CPZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_TippingFloor,	Obj0B_MapUnc_201A0, $70,   0, make_art_tile(ArtTile_ArtNem_CPZAnimatedBits,3,1)
	dbglistobj ObjID_SpeedBooster,	Obj1B_MapUnc_223E2,   0,   0, make_art_tile(ArtTile_ArtNem_CPZBooster,3,1)
	dbglistobj ObjID_BlueBalls,	Obj1D_MapUnc_22576,   5,   0, make_art_tile(ArtTile_ArtNem_CPZDroplet,3,1)
	dbglistobj ObjID_CPZPlatform,	Obj19_MapUnc_2222A,   6,   0, make_art_tile(ArtTile_ArtNem_CPZElevator,3,0)
	dbglistobj ObjID_Barrier,	Obj2D_MapUnc_11822,   2,   2, make_art_tile(ArtTile_ArtNem_ConstructionStripes_2,1,0)
	dbglistobj ObjID_BreakableBlock, Obj32_MapUnc_23886,   0,   0, make_art_tile(ArtTile_ArtNem_CPZMetalBlock,3,0)
	dbglistobj ObjID_CPZSquarePform, Obj6B_MapUnc_2800E, $10,   0, make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,0)
	dbglistobj ObjID_CPZStaircase,	Obj6B_MapUnc_2800E,   0,   0, make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,0)
	dbglistobj ObjID_SidewaysPform,	Obj7A_MapUnc_29564,   0,   0, make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,1)
	dbglistobj ObjID_PipeExitSpring, Obj7B_MapUnc_29780,   2,   0, make_art_tile(ArtTile_ArtNem_CPZTubeSpring,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,  $D,   5, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $A0,   6, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Springboard,	Obj40_MapUnc_265F4,   1,   0, make_art_tile(ArtTile_ArtNem_LeverSpring,0,0)
	dbglistobj ObjID_Spiny,		ObjA5_ObjA6_Obj98_MapUnc_38CCA, $32,   0, make_art_tile(ArtTile_ArtNem_Spiny,1,0)
	dbglistobj ObjID_SpinyOnWall,	ObjA5_ObjA6_Obj98_MapUnc_38CCA, $32,   3, make_art_tile(ArtTile_ArtNem_Spiny,1,0)
	dbglistobj ObjID_Grabber,	ObjA7_ObjA8_ObjA9_Obj98_MapUnc_3921A, $36,   0, make_art_tile(ArtTile_ArtNem_Grabber,1,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_CPZ_End

DbgObjList_ARZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_SwingingPlatform, Obj15_Obj83_MapUnc_1021E, $88,   2, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_ARZPlatform,	Obj18_MapUnc_1084E,   1,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_ARZPlatform,	Obj18_MapUnc_1084E, $9A,   1, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_ArrowShooter,	Obj22_MapUnc_25804,   0,   1, make_art_tile(ArtTile_ArtNem_ArrowAndShooter,0,0)
	dbglistobj ObjID_FallingPillar,	Obj23_MapUnc_259E6,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_RisingPillar,	Obj2B_MapUnc_25C6E,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_LeavesGenerator, Obj31_MapUnc_20E74,   0,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LeavesGenerator, Obj31_MapUnc_20E74,   1,   1, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LeavesGenerator, Obj31_MapUnc_20E74,   2,   2, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_Springboard,	Obj40_MapUnc_265F4,   1,   0, make_art_tile(ArtTile_ArtNem_LeverSpring,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $A0,   6, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Barrier,	Obj2D_MapUnc_11822,   3,   3, make_art_tile(ArtTile_ArtNem_ARZBarrierThing,1,0)
	dbglistobj ObjID_CollapsPform,	Obj1F_MapUnc_1115E,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_SwingingPform,	Obj82_MapUnc_2A476,   3,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_SwingingPform,	Obj82_MapUnc_2A476, $11,   1, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_ARZRotPforms,	Obj15_Obj83_MapUnc_1021E, $10,   1, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_ARZBubbles,	Obj24_MapUnc_1FBF6, $81,  $E, make_art_tile(ArtTile_ArtNem_BigBubbles,0,1)
	dbglistobj ObjID_ChopChop,	Obj91_MapUnc_36EF6,   8,   0, make_art_tile(ArtTile_ArtNem_ChopChop,1,0)
	dbglistobj ObjID_Whisp,		Obj8C_MapUnc_36A4E,   0,   0, make_art_tile(ArtTile_ArtNem_Whisp,1,1)
	dbglistobj ObjID_GrounderInWall, Obj8D_MapUnc_36CF0,   2,   0, make_art_tile(ArtTile_ArtNem_Grounder,1,1)
	dbglistobj ObjID_GrounderInWall2, Obj8D_MapUnc_36CF0,   2,   0, make_art_tile(ArtTile_ArtNem_Grounder,1,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_ARZ_End

DbgObjList_SCZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_WFZPalSwitcher, Obj03_MapUnc_1FFB8,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $5E,   0, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $60,   1, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $62,   2, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_VPropeller,	ObjB4_MapUnc_3B3BE, $64,   0, make_art_tile(ArtTile_ArtNem_WfzVrtclPrpllr,1,1)
	dbglistobj ObjID_HPropeller,	ObjB5_MapUnc_3B548, $66,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1)
	dbglistobj ObjID_HPropeller,	ObjB5_MapUnc_3B548, $68,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1)
	dbglistobj ObjID_Turtloid,	Obj9A_Obj98_MapUnc_37B62, $16,   0, make_art_tile(ArtTile_ArtNem_Turtloid,0,0)
	dbglistobj ObjID_Balkiry,	ObjAC_MapUnc_393CC, $40,   0, make_art_tile(ArtTile_ArtNem_Balkrie,0,0)
	dbglistobj ObjID_Nebula,	Obj99_Obj98_MapUnc_3789A, $12,   0, make_art_tile(ArtTile_ArtNem_Nebula,1,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_SCZ_End

    if ~~removeJmpTos
JmpTo66_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
