; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; screen resizing, earthquakage, etc

; sub_E5D0:
RunDynamicLevelEvents:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	move.w	DynamicLevelEventIndex(pc,d0.w),d0
	jsr	DynamicLevelEventIndex(pc,d0.w)
	moveq	#2,d1
	move.w	(Camera_Max_Y_pos_target).w,d0
	sub.w	(Camera_Max_Y_pos).w,d0
	beq.s	++	; rts
	bcc.s	+++
	neg.w	d1
	move.w	(Camera_Y_pos).w,d0
	cmp.w	(Camera_Max_Y_pos_target).w,d0
	bls.s	+
	move.w	d0,(Camera_Max_Y_pos).w
	andi.w	#$FFFE,(Camera_Max_Y_pos).w
+
	add.w	d1,(Camera_Max_Y_pos).w
	move.b	#1,(Camera_Max_Y_Pos_Changing).w
+
	rts
; ===========================================================================
+
	move.w	(Camera_Y_pos).w,d0
	addi_.w	#8,d0
	cmp.w	(Camera_Max_Y_pos).w,d0
	blo.s	+
	btst	#1,(MainCharacter+status).w
	beq.s	+
	add.w	d1,d1
	add.w	d1,d1
+
	add.w	d1,(Camera_Max_Y_pos).w
	move.b	#1,(Camera_Max_Y_Pos_Changing).w
	rts
; End of function RunDynamicLevelEvents

; ===========================================================================
; off_E636:
DynamicLevelEventIndex: zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w LevEvents_EHZ	; EHZ
	zoneOffsetTableEntry.w LevEvents_001	; Zone 1
	zoneOffsetTableEntry.w LevEvents_WZ	; WZ
	zoneOffsetTableEntry.w LevEvents_003	; Zone 3
	zoneOffsetTableEntry.w LevEvents_MTZ	; MTZ1,2
	zoneOffsetTableEntry.w LevEvents_MTZ3	; MTZ3
	zoneOffsetTableEntry.w LevEvents_WFZ	; WFZ
	zoneOffsetTableEntry.w LevEvents_HTZ	; HTZ
	zoneOffsetTableEntry.w LevEvents_HPZ	; HPZ
	zoneOffsetTableEntry.w LevEvents_009	; Zone 9
	zoneOffsetTableEntry.w LevEvents_OOZ	; OOZ
	zoneOffsetTableEntry.w LevEvents_MCZ	; MCZ
	zoneOffsetTableEntry.w LevEvents_CNZ	; CNZ
	zoneOffsetTableEntry.w LevEvents_CPZ	; CPZ
	zoneOffsetTableEntry.w LevEvents_DEZ	; DEZ
	zoneOffsetTableEntry.w LevEvents_ARZ	; ARZ
	zoneOffsetTableEntry.w LevEvents_SCZ	; SCZ
    zoneTableEnd
; ===========================================================================
; loc_E658:
LevEvents_EHZ:
	tst.b	(Current_Act).w
	bne.s	LevEvents_EHZ2
	rts
; ---------------------------------------------------------------------------
LevEvents_EHZ2:
	moveq	#0,d0
	move.b	(Dynamic_Resize_Routine).w,d0
	move.w	LevEvents_EHZ2_Index(pc,d0.w),d0
	jmp	LevEvents_EHZ2_Index(pc,d0.w)
; ===========================================================================
; off_E66E:
LevEvents_EHZ2_Index:	offsetTable
	offsetTableEntry.w LevEvents_EHZ2_Routine1	; 0
	offsetTableEntry.w LevEvents_EHZ2_Routine2	; 2
	offsetTableEntry.w LevEvents_EHZ2_Routine3	; 4
	offsetTableEntry.w LevEvents_EHZ2_Routine4	; 6
; ===========================================================================
; loc_E676:
LevEvents_EHZ2_Routine1:
	tst.w	(Two_player_mode).w
	bne.s	++
	cmpi.w	#$2780,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	move.w	#$390,(Camera_Max_Y_pos_target).w
	move.w	#$390,(Tails_Max_Y_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_EHZ2_Routine2
+
	rts
; ---------------------------------------------------------------------------
+
	move.w	#$2920,(Camera_Max_X_pos).w
	move.w	#$2920,(Tails_Max_X_pos).w
	rts
; ===========================================================================
; loc_E6B0:
LevEvents_EHZ2_Routine2:
	cmpi.w	#$28F0,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	#$28F0,(Camera_Min_X_pos).w
	move.w	#$2940,(Camera_Max_X_pos).w
	move.w	#$28F0,(Tails_Min_X_pos).w
	move.w	#$2940,(Tails_Max_X_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_EHZ2_Routine3
	move.w	#MusID_FadeOut,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
	clr.b	(Boss_spawn_delay).w
	move.b	#2,(Current_Boss_ID).w
	moveq	#PLCID_EhzBoss,d0
	jsrto	LoadPLC, JmpTo2_LoadPLC
+
	rts
; ===========================================================================
; loc_E6EE:
LevEvents_EHZ2_Routine3:
	cmpi.w	#$388,(Camera_Y_pos).w
	blo.s	+
	move.w	#$388,(Camera_Min_Y_pos).w
	move.w	#$388,(Tails_Min_Y_pos).w
+
	addq.b	#1,(Boss_spawn_delay).w
	cmpi.b	#$5A,(Boss_spawn_delay).w
	blo.s	++
	jsrto	AllocateObject, JmpTo_AllocateObject
	bne.s	+

	move.b	#ObjID_EHZBoss,id(a1) ; load obj56 (EHZ boss)
	move.b	#$81,subtype(a1)
	move.w	#$29D0,x_pos(a1)
	move.w	#$426,y_pos(a1)
+
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_EHZ2_Routine4
	move.w	#MusID_Boss,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
+
	rts
; ===========================================================================
; loc_E738:
LevEvents_EHZ2_Routine4:
	tst.b	(Boss_defeated_flag).w
	beq.s	+
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_Max_X_pos).w,(Tails_Max_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
+
	rts

; ===========================================================================
; return_E752:
LevEvents_001:
	rts
; ===========================================================================
; return_E754: LevEvents_002:
LevEvents_WZ:
	rts
; ===========================================================================
; return_E756:
LevEvents_003:
	rts
; ===========================================================================
; return_E758:
LevEvents_MTZ:
	rts

; ===========================================================================
; loc_E75A:
LevEvents_MTZ3:
	moveq	#0,d0
	move.b	(Dynamic_Resize_Routine).w,d0
	move.w	LevEvents_MTZ3_Index(pc,d0.w),d0
	jmp	LevEvents_MTZ3_Index(pc,d0.w)
; ===========================================================================
; off_E768:
LevEvents_MTZ3_Index: offsetTable
	offsetTableEntry.w LevEvents_MTZ3_Routine1	; 0
	offsetTableEntry.w LevEvents_MTZ3_Routine2	; 2
	offsetTableEntry.w LevEvents_MTZ3_Routine3	; 4
	offsetTableEntry.w LevEvents_MTZ3_Routine4	; 6
	offsetTableEntry.w LevEvents_MTZ3_Routine5	; 8
; ===========================================================================
; loc_E772:
LevEvents_MTZ3_Routine1:
	cmpi.w	#$2530,(Camera_X_pos).w
	blo.s	+
	move.w	#$500,(Camera_Max_Y_pos).w
	move.w	#$450,(Camera_Max_Y_pos_target).w
	move.w	#$450,(Tails_Max_Y_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_MTZ3_Routine2
+
	rts
; ===========================================================================
; loc_E792:
LevEvents_MTZ3_Routine2:
	cmpi.w	#$2980,(Camera_X_pos).w
	blo.s	+
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	move.w	#$400,(Camera_Max_Y_pos_target).w
	move.w	#$400,(Tails_Max_Y_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_MTZ3_Routine3
+
	rts
; ===========================================================================
; loc_E7B8:
LevEvents_MTZ3_Routine3:
	cmpi.w	#$2A80,(Camera_X_pos).w
	blo.s	+
	move.w	#$2AB0,(Camera_Min_X_pos).w
	move.w	#$2AB0,(Camera_Max_X_pos).w
	move.w	#$2AB0,(Tails_Min_X_pos).w
	move.w	#$2AB0,(Tails_Max_X_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_MTZ3_Routine4
	move.w	#MusID_FadeOut,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
	clr.b	(Boss_spawn_delay).w
	move.b	#7,(Current_Boss_ID).w
	moveq	#PLCID_MtzBoss,d0
	jsrto	LoadPLC, JmpTo2_LoadPLC
+
	rts
; ===========================================================================
; loc_E7F6:
LevEvents_MTZ3_Routine4:
	cmpi.w	#$400,(Camera_Y_pos).w
	blo.s	+
	move.w	#$400,(Camera_Min_Y_pos).w
	move.w	#$400,(Tails_Min_Y_pos).w
+
	addq.b	#1,(Boss_spawn_delay).w
	cmpi.b	#$5A,(Boss_spawn_delay).w
	blo.s	++
	jsrto	AllocateObject, JmpTo_AllocateObject
	bne.s	+
	move.b	#ObjID_MTZBoss,id(a1) ; load obj54 (MTZ boss)
+
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_MTZ3_Routine5
	move.w	#MusID_Boss,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
+
	rts
; ===========================================================================
; loc_E82E:
LevEvents_MTZ3_Routine5:
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_Max_X_pos).w,(Tails_Max_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	rts

; ===========================================================================
; loc_E842:
LevEvents_WFZ:
	moveq	#0,d0
	move.b	(Dynamic_Resize_Routine).w,d0
	move.w	LevEvents_WFZ_Index(pc,d0.w),d0
	jsr	LevEvents_WFZ_Index(pc,d0.w)
	move.w	(WFZ_LevEvent_Subrout).w,d0
	move.w	LevEvents_WFZ_Index2(pc,d0.w),d0
	jmp	LevEvents_WFZ_Index2(pc,d0.w)
; ===========================================================================
; off_E85C:
LevEvents_WFZ_Index2: offsetTable
	offsetTableEntry.w LevEvents_WFZ_Routine5	; 0
	offsetTableEntry.w LevEvents_WFZ_Routine6	; 2
	offsetTableEntry.w LevEvents_WFZ_RoutineNull	; 4
; ===========================================================================
; off_E862:
LevEvents_WFZ_Index: offsetTable
	offsetTableEntry.w LevEvents_WFZ_Routine1	; 0
	offsetTableEntry.w LevEvents_WFZ_Routine2	; 2
	offsetTableEntry.w LevEvents_WFZ_Routine3	; 4
	offsetTableEntry.w LevEvents_WFZ_Routine4	; 6
; ===========================================================================
; loc_E86A:
LevEvents_WFZ_Routine1:
	move.l	(Camera_X_pos).w,(Camera_BG_X_pos).w
	move.l	(Camera_Y_pos).w,(Camera_BG_Y_pos).w
	moveq	#0,d0
	move.w	d0,(Camera_BG_X_pos_diff).w
	move.w	d0,(Camera_BG_Y_pos_diff).w
	move.w	d0,(Camera_BG_X_offset).w
	move.w	d0,(Camera_BG_Y_offset).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_WFZ_Routine2
	rts
; ===========================================================================
; loc_E88E:
LevEvents_WFZ_Routine2:
	cmpi.w	#$2BC0,(Camera_X_pos).w
	blo.s	+
	cmpi.w	#$580,(Camera_Y_pos).w
	blo.s	+
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_WFZ_Routine3
	move.w	#0,(WFZ_BG_Y_Speed).w
+
	move.w	(Camera_X_pos_diff).w,(Camera_BG_X_pos_diff).w
	move.w	(Camera_Y_pos_diff).w,(Camera_BG_Y_pos_diff).w
	move.w	(Camera_X_pos).w,d0
	move.w	(Camera_Y_pos).w,d1
	bra.w	ScrollBG
; ===========================================================================
; loc_E8C0:
LevEvents_WFZ_Routine3:
	cmpi.w	#$800,(Camera_BG_X_offset).w
	beq.s	+
	addq.w	#2,(Camera_BG_X_offset).w
+
	cmpi.w	#$600,(Camera_BG_X_offset).w
	blt.s	LevEvents_WFZ_Routine3_Part2
	move.w	(WFZ_BG_Y_Speed).w,d0
	moveq	#4,d1
	cmpi.w	#$840,d0
	bhs.s	+
	add.w	d1,d0
	move.w	d0,(WFZ_BG_Y_Speed).w
+
	lsr.w	#8,d0
	add.w	d0,(Camera_BG_Y_offset).w
; loc_E8EC:
LevEvents_WFZ_Routine3_Part2:
	move.w	(Camera_X_pos_diff).w,(Camera_BG_X_pos_diff).w
	move.w	(Camera_Y_pos_diff).w,(Camera_BG_Y_pos_diff).w
	move.w	(Camera_X_pos).w,d0
	move.w	(Camera_Y_pos).w,d1
	bra.w	ScrollBG
; ===========================================================================
; loc_E904:
LevEvents_WFZ_Routine4:
	cmpi.w	#-$2C0,(Camera_BG_X_offset).w
	beq.s	++
	subi_.w	#2,(Camera_BG_X_offset).w
	cmpi.w	#$1B81,(Camera_BG_Y_offset).w
	beq.s	++
	move.w	(WFZ_BG_Y_Speed).w,d0
	beq.s	+
	moveq	#4,d1
	neg.w	d1
	add.w	d1,d0
	move.w	d0,(WFZ_BG_Y_Speed).w
	lsr.w	#8,d0
+
	addq.w	#1,d0
	add.w	d0,(Camera_BG_Y_offset).w
+
	move.w	(Camera_X_pos_diff).w,(Camera_BG_X_pos_diff).w
	move.w	(Camera_Y_pos_diff).w,(Camera_BG_Y_pos_diff).w
	move.w	(Camera_X_pos).w,d0
	move.w	(Camera_Y_pos).w,d1
	bra.w	ScrollBG
; ===========================================================================
; loc_E94A:
LevEvents_WFZ_Routine5:
	cmpi.w	#$2880,(Camera_X_pos).w
	blo.s	+	; rts
	cmpi.w	#$400,(Camera_Y_pos).w
	blo.s	+	; rts
	addq.w	#2,(WFZ_LevEvent_Subrout).w ; => LevEvents_WFZ_Routine6
	moveq	#PLCID_WfzBoss,d0
	jsrto	LoadPLC, JmpTo2_LoadPLC
	move.w	#$2880,(Camera_Min_X_pos).w
+
	rts
; ===========================================================================
; loc_E96C:
LevEvents_WFZ_Routine6:
	cmpi.w	#$500,(Camera_Y_pos).w
	blo.s	+	; rts
	addq.w	#2,(WFZ_LevEvent_Subrout).w ; => LevEvents_WFZ_RoutineNull
	st.b	(Control_Locked).w
	moveq	#PLCID_Tornado,d0
	jsrto	LoadPLC, JmpTo2_LoadPLC
+
	rts
; ===========================================================================
; return_E984:
LevEvents_WFZ_RoutineNull:
	rts

; ===========================================================================
; loc_E986:
LevEvents_HTZ:
	tst.b	(Current_Act).w
	bne.w	LevEvents_HTZ2
	moveq	#0,d0
	move.b	(Dynamic_Resize_Routine).w,d0
	move.w	LevEvents_HTZ_Index(pc,d0.w),d0
	jmp	LevEvents_HTZ_Index(pc,d0.w)
; ===========================================================================
; off_E99C:
LevEvents_HTZ_Index: offsetTable
	offsetTableEntry.w LevEvents_HTZ_Routine1	; 0 left of earthquake
	offsetTableEntry.w LevEvents_HTZ_Routine2	; 2 earthquake
	offsetTableEntry.w LevEvents_HTZ_Routine3	; 4 right of earthquake
; ===========================================================================
; loc_E9A2:
LevEvents_HTZ_Routine1:
	cmpi.w	#$400,(Camera_Y_pos).w
	blo.s	LevEvents_HTZ_Routine1_Part2
	cmpi.w	#$1800,(Camera_X_pos).w
	blo.s	LevEvents_HTZ_Routine1_Part2
	move.b	#1,(Screen_Shaking_Flag_HTZ).w
	move.l	(Camera_X_pos).w,(Camera_BG_X_pos).w
	move.l	(Camera_Y_pos).w,(Camera_BG_Y_pos).w
	moveq	#0,d0
	move.w	d0,(Camera_BG_X_pos_diff).w
	move.w	d0,(Camera_BG_Y_pos_diff).w
	move.w	d0,(Camera_BG_X_offset).w
	move.w	#320,(Camera_BG_Y_offset).w
	subi.w	#$100,(Camera_BG_Y_pos).w
	move.w	#0,(HTZ_Terrain_Delay).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ_Routine2
-
	rts
; ===========================================================================

LevEvents_HTZ_Routine1_Part2:
	tst.b	(Screen_Shaking_Flag_HTZ).w
	beq.s	-	; rts
	move.w	#$200,d0
	moveq	#0,d1
	move.w	d1,(Camera_BG_X_pos_diff).w
	move.w	d1,(Camera_BG_Y_pos_diff).w
	bsr.w	ScrollBG
	or.w	d0,d1
	bne.s	-	; rts
	move.b	#0,(Screen_Shaking_Flag_HTZ).w
	rts
; ===========================================================================
; loc_EA0E:
LevEvents_HTZ_Routine2:
	cmpi.w	#$1978,(Camera_X_pos).w
	blo.w	LevEvents_HTZ_Routine2_Continue
	cmpi.w	#$1E00,(Camera_X_pos).w
	blo.s	.keep_shaking
	move.b	#0,(Screen_Shaking_Flag).w
	bra.s	LevEvents_HTZ_Routine2_Continue
; ---------------------------------------------------------------------------
.keep_shaking:
	tst.b	(HTZ_Terrain_Direction).w
	bne.s	.sinking
	cmpi.w	#320,(Camera_BG_Y_offset).w
	beq.s	.flip_delay
	move.w	(Timer_frames).w,d0
	move.w	d0,d1
	andi.w	#3,d0
	bne.s	LevEvents_HTZ_Routine2_Continue
	addq.w	#1,(Camera_BG_Y_offset).w
	andi.w	#$3F,d1
	bne.s	LevEvents_HTZ_Routine2_Continue
	move.w	#SndID_Rumbling2,d0 ; rumbling sound
	jsr	(PlaySound).l
	bra.s	LevEvents_HTZ_Routine2_Continue
; ---------------------------------------------------------------------------
.sinking:
	cmpi.w	#224,(Camera_BG_Y_offset).w
	beq.s	.flip_delay
	move.w	(Timer_frames).w,d0
	move.w	d0,d1
	andi.w	#3,d0
	bne.s	LevEvents_HTZ_Routine2_Continue
	subq.w	#1,(Camera_BG_Y_offset).w
	andi.w	#$3F,d1
	bne.s	LevEvents_HTZ_Routine2_Continue
	move.w	#SndID_Rumbling2,d0
	jsr	(PlaySound).l
	bra.s	LevEvents_HTZ_Routine2_Continue
; ---------------------------------------------------------------------------
.flip_delay:
	move.b	#0,(Screen_Shaking_Flag).w
	subq.w	#1,(HTZ_Terrain_Delay).w
	bpl.s	LevEvents_HTZ_Routine2_Continue
	move.w	#$78,(HTZ_Terrain_Delay).w
	eori.b	#1,(HTZ_Terrain_Direction).w
	move.b	#1,(Screen_Shaking_Flag).w

; loc_EAA0:
LevEvents_HTZ_Routine2_Continue:
	cmpi.w	#$1800,(Camera_X_pos).w
	blo.s	.exit_left
	cmpi.w	#$1F00,(Camera_X_pos).w
	bhs.s	.exit_right
	move.w	(Camera_X_pos_diff).w,(Camera_BG_X_pos_diff).w
	move.w	(Camera_Y_pos_diff).w,(Camera_BG_Y_pos_diff).w
	move.w	(Camera_X_pos).w,d0
	move.w	(Camera_Y_pos).w,d1
	bra.w	ScrollBG
; ---------------------------------------------------------------------------
.exit_left:
	move.l	#$4000000,(Camera_BG_X_pos).w
	moveq	#0,d0
	move.l	d0,(Camera_BG_Y_pos).w
	move.l	d0,(Camera_BG_X_offset).w
	move.b	d0,(HTZ_Terrain_Direction).w
	subq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ_Routine1
	move.w	#MusID_StopSFX,d0
	jsr	(PlaySound).l
	rts
; ---------------------------------------------------------------------------
.exit_right:
	move.l	#$4000000,(Camera_BG_X_pos).w
	moveq	#0,d0
	move.l	d0,(Camera_BG_Y_pos).w
	move.l	d0,(Camera_BG_X_offset).w
	move.b	d0,(HTZ_Terrain_Direction).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ_Routine3
	move.w	#MusID_StopSFX,d0
	jsr	(PlaySound).l
	rts

; ===========================================================================
; loc_EB14:
LevEvents_HTZ_Routine3:
	cmpi.w	#$1F00,(Camera_X_pos).w
	bhs.s	LevEvents_HTZ_Routine3_Part2
	move.b	#1,(Screen_Shaking_Flag_HTZ).w
	move.l	(Camera_X_pos).w,(Camera_BG_X_pos).w
	move.l	(Camera_Y_pos).w,(Camera_BG_Y_pos).w
	moveq	#0,d0
	move.w	d0,(Camera_BG_X_pos_diff).w
	move.w	d0,(Camera_BG_Y_pos_diff).w
	move.w	d0,(Camera_BG_X_offset).w
	move.w	#320,(Camera_BG_Y_offset).w
	subi.w	#$100,(Camera_BG_Y_pos).w
	move.w	#0,(HTZ_Terrain_Delay).w
	subq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ_Routine2
-
	rts
; ---------------------------------------------------------------------------
; loc_EB54:
LevEvents_HTZ_Routine3_Part2:
	tst.b	(Screen_Shaking_Flag_HTZ).w
	beq.s	-	; rts
	move.w	#$200,d0
	moveq	#0,d1
	move.w	d1,(Camera_BG_X_pos_diff).w
	move.w	d1,(Camera_BG_Y_pos_diff).w
	bsr.w	ScrollBG
	or.w	d0,d1
	bne.s	-	; rts
	move.b	#0,(Screen_Shaking_Flag_HTZ).w
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Computes how much the background layer has been scrolled in X and Y and
; stores result to Camera_BG_X_pos_diff and Camera_BG_Y_pos_diff.
; Caps maximum scroll speed to 16 pixels per frame in either direction.
; This is used to decide how much of the BG needs to be reloaded.
;
; Used for rising lava/terrain in HTZ, and for WFZ->DEZ transition in WFZ.
;
; Input:
;	d0	Target X position of background
;	d1	Target Y position of background
;sub_EB78
ScrollBG:
	sub.w	(Camera_BG_X_pos).w,d0
	sub.w	(Camera_BG_X_offset).w,d0
	bpl.s	.going_right
	cmpi.w	#-16,d0
	bgt.s	.skip_x_cap
	move.w	#-16,d0

.skip_x_cap:
	bra.s	.move_x
; ===========================================================================
.going_right:
	cmpi.w	#16,d0
	blo.s	.move_x
	move.w	#16,d0

.move_x:
	move.b	d0,(Camera_BG_X_pos_diff).w
	sub.w	(Camera_BG_Y_pos).w,d1
	sub.w	(Camera_BG_Y_offset).w,d1
	bpl.s	.going_down
	cmpi.w	#-16,d1
	bgt.s	.skip_y_cap
	move.w	#-16,d1

.skip_y_cap:
	bra.s	.move_y
; ===========================================================================
.going_down:
	cmpi.w	#16,d1
	blo.s	.move_y
	move.w	#16,d1

.move_y:
	move.b	d1,(Camera_BG_Y_pos_diff).w
	rts
; End of function ScrollBG

; ===========================================================================
	; unused/dead code
	; This code is probably meant for testing the background scrolling code
	; used by HTZ and WFZ. It would allows the BG position to be shifted up
	; and down by the second controller.
	btst	#button_up,(Ctrl_2_Held).w
	beq.s	+
	tst.w	(Camera_BG_Y_offset).w
	beq.s	+
	subq.w	#1,(Camera_BG_Y_offset).w
+
	btst	#button_down,(Ctrl_2_Held).w
	beq.s	+
	cmpi.w	#$700,(Camera_BG_Y_offset).w
	beq.s	+
	addq.w	#1,(Camera_BG_Y_offset).w
+
	rts
; ===========================================================================

; sub_EBEA:
LevEvents_HTZ2:
	bsr.w	LevEvents_HTZ2_Prepare
	moveq	#0,d0
	move.b	(Dynamic_Resize_Routine).w,d0
	move.w	LevEvents_HTZ2_Index(pc,d0.w),d0
	jmp	LevEvents_HTZ2_Index(pc,d0.w)
; ===========================================================================
; off_EBFC:
LevEvents_HTZ2_Index: offsetTable
	offsetTableEntry.w LevEvents_HTZ2_Routine1	;   0 earthquake left
	offsetTableEntry.w LevEvents_HTZ2_Routine2	;   2 earthquake (top)
	offsetTableEntry.w LevEvents_HTZ2_Routine3	;   4 earthquake right (top)
	offsetTableEntry.w LevEvents_HTZ2_Routine4	;   6 earthquake (bottom)
	offsetTableEntry.w LevEvents_HTZ2_Routine5	;   8 earthquake right (bottom)
	offsetTableEntry.w LevEvents_HTZ2_Routine6	;  $A boss area cutoff
	offsetTableEntry.w LevEvents_HTZ2_Routine7	;  $C boss area camera shift
	offsetTableEntry.w LevEvents_HTZ2_Routine8	;  $E boss begin
	offsetTableEntry.w LevEvents_HTZ2_Routine9	; $10 boss end / extend camera
; ===========================================================================
; loc_EC0E:
LevEvents_HTZ2_Routine1:
	cmpi.w	#$14C0,(Camera_X_pos).w
	blo.s	LevEvents_HTZ2_Routine1_Part2
	move.b	#1,(Screen_Shaking_Flag_HTZ).w
	move.l	(Camera_X_pos).w,(Camera_BG_X_pos).w
	move.l	(Camera_Y_pos).w,(Camera_BG_Y_pos).w
	moveq	#0,d0
	move.w	d0,(Camera_BG_X_pos_diff).w
	move.w	d0,(Camera_BG_Y_pos_diff).w
	move.w	d0,(Camera_BG_X_offset).w
	move.w	#$2C0,(Camera_BG_Y_offset).w
	subi.w	#$100,(Camera_BG_Y_pos).w
	move.w	#0,(HTZ_Terrain_Delay).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine2
	cmpi.w	#$380,(Camera_Y_pos).w
	blo.s	+	; rts
	move.w	#-$680,(Camera_BG_X_offset).w
	addi.w	#$480,(Camera_BG_X_pos).w
	move.w	#$300,(Camera_BG_Y_offset).w
	addq.b	#6,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine5
/
	rts
; ---------------------------------------------------------------------------

LevEvents_HTZ2_Routine1_Part2:
	tst.b	(Screen_Shaking_Flag_HTZ).w
	beq.s	-	; rts
	move.w	#$200,d0
	moveq	#0,d1
	move.w	d1,(Camera_BG_X_pos_diff).w
	move.w	d1,(Camera_BG_Y_pos_diff).w
	bsr.w	ScrollBG
	or.w	d0,d1
	bne.s	-	; rts
	move.b	#0,(Screen_Shaking_Flag_HTZ).w
	rts

; ===========================================================================
; loc_EC90:
LevEvents_HTZ2_Routine2:
	cmpi.w	#$1678,(Camera_X_pos).w
	blo.w	LevEvents_HTZ2_Routine2_Continue
	cmpi.w	#$1A00,(Camera_X_pos).w
	blo.s	.keep_shaking
	move.b	#0,(Screen_Shaking_Flag).w
	bra.s	LevEvents_HTZ2_Routine2_Continue
; ---------------------------------------------------------------------------
.keep_shaking:
	tst.b	(HTZ_Terrain_Direction).w
	bne.s	.sinking
	cmpi.w	#$2C0,(Camera_BG_Y_offset).w
	beq.s	.flip_delay
	move.w	(Timer_frames).w,d0
	move.w	d0,d1
	andi.w	#3,d0
	bne.s	LevEvents_HTZ2_Routine2_Continue
	addq.w	#1,(Camera_BG_Y_offset).w
	andi.w	#$3F,d1
	bne.s	LevEvents_HTZ2_Routine2_Continue
	move.w	#SndID_Rumbling2,d0
	jsr	(PlaySound).l
	bra.s	LevEvents_HTZ2_Routine2_Continue
; ---------------------------------------------------------------------------
.sinking:
	cmpi.w	#0,(Camera_BG_Y_offset).w
	beq.s	.flip_delay
	move.w	(Timer_frames).w,d0
	move.w	d0,d1
	andi.w	#3,d0
	bne.s	LevEvents_HTZ2_Routine2_Continue
	subq.w	#1,(Camera_BG_Y_offset).w
	andi.w	#$3F,d1
	bne.s	LevEvents_HTZ2_Routine2_Continue
	move.w	#SndID_Rumbling2,d0
	jsr	(PlaySound).l
	bra.s	LevEvents_HTZ2_Routine2_Continue
; ---------------------------------------------------------------------------
.flip_delay:
	move.b	#0,(Screen_Shaking_Flag).w
	subq.w	#1,(HTZ_Terrain_Delay).w
	bpl.s	LevEvents_HTZ2_Routine2_Continue
	move.w	#$78,(HTZ_Terrain_Delay).w
	eori.b	#1,(HTZ_Terrain_Direction).w
	move.b	#1,(Screen_Shaking_Flag).w

; loc_ED22:
LevEvents_HTZ2_Routine2_Continue:
	cmpi.w	#$14C0,(Camera_X_pos).w
	blo.s	.exit_left
	cmpi.w	#$1B00,(Camera_X_pos).w
	bhs.s	.exit_right
	move.w	(Camera_X_pos_diff).w,(Camera_BG_X_pos_diff).w
	move.w	(Camera_Y_pos_diff).w,(Camera_BG_Y_pos_diff).w
	move.w	(Camera_X_pos).w,d0
	move.w	(Camera_Y_pos).w,d1
	bra.w	ScrollBG
; ---------------------------------------------------------------------------
.exit_left:
	move.l	#$4000000,(Camera_BG_X_pos).w
	moveq	#0,d0
	move.l	d0,(Camera_BG_Y_pos).w
	move.l	d0,(Camera_BG_X_offset).w
	move.b	d0,(HTZ_Terrain_Direction).w
	subq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine1
	move.w	#MusID_StopSFX,d0
	jsr	(PlaySound).l
	rts
; ---------------------------------------------------------------------------
.exit_right:
	move.l	#$4000000,(Camera_BG_X_pos).w
	moveq	#0,d0
	move.l	d0,(Camera_BG_Y_pos).w
	move.l	d0,(Camera_BG_X_offset).w
	move.b	d0,(HTZ_Terrain_Direction).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine3
	move.w	#MusID_StopSFX,d0
	jsr	(PlaySound).l
	rts
; ===========================================================================
; loc_ED96:
LevEvents_HTZ2_Routine3:
	cmpi.w	#$1B00,(Camera_X_pos).w
	bhs.s	LevEvents_HTZ2_Routine3_Part2
	move.b	#1,(Screen_Shaking_Flag_HTZ).w
	move.l	(Camera_X_pos).w,(Camera_BG_X_pos).w
	move.l	(Camera_Y_pos).w,(Camera_BG_Y_pos).w
	moveq	#0,d0
	move.w	d0,(Camera_BG_X_pos_diff).w
	move.w	d0,(Camera_BG_Y_pos_diff).w
	move.w	d0,(Camera_BG_X_offset).w
	move.w	#$2C0,(Camera_BG_Y_offset).w
	subi.w	#$100,(Camera_BG_Y_pos).w
	move.w	#0,(HTZ_Terrain_Delay).w
	subq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine2
-
	rts
; ===========================================================================

LevEvents_HTZ2_Routine3_Part2:
	tst.b	(Screen_Shaking_Flag_HTZ).w
	beq.s	-	; rts
	move.w	#$200,d0
	moveq	#0,d1
	move.w	d1,(Camera_BG_X_pos_diff).w
	move.w	d1,(Camera_BG_Y_pos_diff).w
	bsr.w	ScrollBG
	or.w	d0,d1
	bne.s	-	; rts
	move.b	#0,(Screen_Shaking_Flag_HTZ).w
	rts
; ===========================================================================
; loc_EDFA:
LevEvents_HTZ2_Routine4:
	cmpi.w	#$15F0,(Camera_X_pos).w
	blo.w	LevEvents_HTZ2_Routine4_Continue
	cmpi.w	#$1AC0,(Camera_X_pos).w
	bhs.s	LevEvents_HTZ2_Routine4_Continue
	tst.b	(HTZ_Terrain_Direction).w
	bne.s	.sinking
	cmpi.w	#$300,(Camera_BG_Y_offset).w
	beq.s	.flip_delay
	move.w	(Timer_frames).w,d0
	move.w	d0,d1
	andi.w	#3,d0
	bne.s	LevEvents_HTZ2_Routine4_Continue
	addq.w	#1,(Camera_BG_Y_offset).w
	andi.w	#$3F,d1
	bne.s	LevEvents_HTZ2_Routine4_Continue
	move.w	#SndID_Rumbling2,d0
	jsr	(PlaySound).l
	bra.s	LevEvents_HTZ2_Routine4_Continue
; ===========================================================================
.sinking:
	cmpi.w	#0,(Camera_BG_Y_offset).w
	beq.s	.flip_delay
	move.w	(Timer_frames).w,d0
	move.w	d0,d1
	andi.w	#3,d0
	bne.s	LevEvents_HTZ2_Routine4_Continue
	subq.w	#1,(Camera_BG_Y_offset).w
	andi.w	#$3F,d1
	bne.s	LevEvents_HTZ2_Routine4_Continue
	move.w	#SndID_Rumbling2,d0
	jsr	(PlaySound).l
	bra.s	LevEvents_HTZ2_Routine4_Continue
; ===========================================================================
.flip_delay:
	move.b	#0,(Screen_Shaking_Flag).w
	subq.w	#1,(HTZ_Terrain_Delay).w
	bpl.s	LevEvents_HTZ2_Routine4_Continue
	move.w	#$78,(HTZ_Terrain_Delay).w
	eori.b	#1,(HTZ_Terrain_Direction).w
	move.b	#1,(Screen_Shaking_Flag).w

LevEvents_HTZ2_Routine4_Continue:
	cmpi.w	#$14C0,(Camera_X_pos).w
	blo.s	.exit_left
	cmpi.w	#$1B00,(Camera_X_pos).w
	bhs.s	.exit_right
	move.w	(Camera_X_pos_diff).w,(Camera_BG_X_pos_diff).w
	move.w	(Camera_Y_pos_diff).w,(Camera_BG_Y_pos_diff).w
	move.w	(Camera_X_pos).w,d0
	move.w	(Camera_Y_pos).w,d1
	bra.w	ScrollBG
; ===========================================================================
.exit_left:
	move.l	#$4000000,(Camera_BG_X_pos).w
	moveq	#0,d0
	move.l	d0,(Camera_BG_Y_pos).w
	move.l	d0,(Camera_BG_X_offset).w
	move.b	d0,(HTZ_Terrain_Direction).w
	subq.b	#6,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine1
	move.w	#MusID_StopSFX,d0
	jsr	(PlaySound).l
	rts
; ===========================================================================
.exit_right:
	move.l	#$4000000,(Camera_BG_X_pos).w
	moveq	#0,d0
	move.l	d0,(Camera_BG_Y_pos).w
	move.l	d0,(Camera_BG_X_offset).w
	move.b	d0,(HTZ_Terrain_Direction).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine5
	move.w	#MusID_StopSFX,d0
	jsr	(PlaySound).l
	rts
; ===========================================================================
; loc_EEF8:
LevEvents_HTZ2_Routine5:
	cmpi.w	#$1B00,(Camera_X_pos).w
	bhs.s	LevEvents_HTZ2_Routine5_Part2
	move.b	#1,(Screen_Shaking_Flag_HTZ).w
	move.l	(Camera_X_pos).w,(Camera_BG_X_pos).w
	move.l	(Camera_Y_pos).w,(Camera_BG_Y_pos).w
	moveq	#0,d0
	move.w	d0,(Camera_BG_X_pos_diff).w
	move.w	d0,(Camera_BG_Y_pos_diff).w
	move.w	#-$680,(Camera_BG_X_offset).w
	addi.w	#$480,(Camera_BG_X_pos).w
	move.w	#$300,(Camera_BG_Y_offset).w
	subi.w	#$100,(Camera_BG_Y_pos).w
	move.w	#0,(HTZ_Terrain_Delay).w
	subq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine4
-
	rts
; ===========================================================================

LevEvents_HTZ2_Routine5_Part2:
	tst.b	(Screen_Shaking_Flag_HTZ).w
	beq.s	-	; rts
	move.w	#$200,d0
	moveq	#0,d1
	move.w	d1,(Camera_BG_X_pos_diff).w
	move.w	d1,(Camera_BG_Y_pos_diff).w
	bsr.w	ScrollBG
	or.w	d0,d1
	bne.s	-	; rts
	move.b	#0,(Screen_Shaking_Flag_HTZ).w
	rts
; ===========================================================================
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_EF66:
LevEvents_HTZ2_Prepare:
	cmpi.w	#$2B00,(Camera_X_pos).w
	blo.s	+	; rts
	cmpi.b	#$A,(Dynamic_Resize_Routine).w
	bge.s	+	; rts
	move.b	#$A,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine6
	move.b	#0,(Screen_Shaking_Flag_HTZ).w
+
	rts
; End of function LevEvents_HTZ2_Prepare

; ===========================================================================
; loc_EF84:
LevEvents_HTZ2_Routine6:
	cmpi.w	#$2C50,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	move.w	#$480,(Camera_Max_Y_pos_target).w
	move.w	#$480,(Tails_Max_Y_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine7
+
	rts
; ===========================================================================
; loc_EFAA:
LevEvents_HTZ2_Routine7:
	cmpi.w	#$2EDF,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	#$2EE0,(Camera_Min_X_pos).w
	move.w	#$2F5E,(Camera_Max_X_pos).w
	move.w	#$2EE0,(Tails_Min_X_pos).w
	move.w	#$2F5E,(Tails_Max_X_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine8
	move.w	#MusID_FadeOut,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
	clr.b	(Boss_spawn_delay).w
	move.b	#3,(Current_Boss_ID).w
	moveq	#PLCID_HtzBoss,d0
	jmpto	LoadPLC, JmpTo2_LoadPLC
; ===========================================================================
+
	rts
; ===========================================================================
; loc_EFE8:
LevEvents_HTZ2_Routine8:
	cmpi.w	#$478,(Camera_Y_pos).w
	blo.s	+
	move.w	#$478,(Camera_Min_Y_pos).w
	move.w	#$478,(Tails_Min_Y_pos).w
+
	addq.b	#1,(Boss_spawn_delay).w
	cmpi.b	#$5A,(Boss_spawn_delay).w
	blo.s	++	; rts
	jsrto	AllocateObject, JmpTo_AllocateObject
	bne.s	+
	move.b	#ObjID_HTZBoss,id(a1) ; load obj52 (HTZ boss)
+
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine9
	move.w	#MusID_Boss,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
+
	rts
; ===========================================================================
; loc_F020:
LevEvents_HTZ2_Routine9:
	tst.b	(Boss_defeated_flag).w
	beq.s	++	; rts
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_Max_X_pos).w,(Tails_Max_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	cmpi.w	#$30E0,(Camera_X_pos).w
	blo.s	++	; rts
	cmpi.w	#$428,(Camera_Min_Y_pos).w
	blo.s	+
	subq.w	#2,(Camera_Min_Y_pos).w
+
	cmpi.w	#$430,(Camera_Max_Y_pos_target).w
	blo.s	+
	subq.w	#2,(Camera_Max_Y_pos_target).w
+
	rts

; ===========================================================================
; return_F05A:
LevEvents_HPZ:
	rts

; ===========================================================================
; return_F05C:
LevEvents_009:
	rts

; ===========================================================================
; loc_F05E:
LevEvents_OOZ:
	tst.b	(Current_Act).w
	bne.s	LevEvents_OOZ2
	rts
; ---------------------------------------------------------------------------
; loc_F066:
LevEvents_OOZ2:
	moveq	#0,d0
	move.b	(Dynamic_Resize_Routine).w,d0
	move.w	LevEvents_OOZ2_Index(pc,d0.w),d0
	jmp	LevEvents_OOZ2_Index(pc,d0.w)
; ===========================================================================
; off_F074:
LevEvents_OOZ2_Index: offsetTable
	offsetTableEntry.w LevEvents_OOZ2_Routine1	; 0
	offsetTableEntry.w LevEvents_OOZ2_Routine2	; 2
	offsetTableEntry.w LevEvents_OOZ2_Routine3	; 4
	offsetTableEntry.w LevEvents_OOZ2_Routine4	; 6
; ===========================================================================
; loc_F07C:
LevEvents_OOZ2_Routine1:
	cmpi.w	#$2668,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	move.w	#$2D8,(Oil+y_pos).w
	move.w	#$1E0,(Camera_Max_Y_pos_target).w
	move.w	#$1E0,(Tails_Max_Y_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w
+
	rts
; ===========================================================================
; loc_F0A8:
LevEvents_OOZ2_Routine2:
	cmpi.w	#$2880,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	#$2880,(Camera_Min_X_pos).w
	move.w	#$28C0,(Camera_Max_X_pos).w
	move.w	#$2880,(Tails_Min_X_pos).w
	move.w	#$28C0,(Tails_Max_X_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	#MusID_FadeOut,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
	clr.b	(Boss_spawn_delay).w
	move.b	#8,(Current_Boss_ID).w
	moveq	#PLCID_OozBoss,d0
	jsrto	LoadPLC, JmpTo2_LoadPLC
	moveq	#PalID_OOZ_B,d0
	jsrto	PalLoad_Now, JmpTo2_PalLoad_Now
+
	rts
; ===========================================================================
; loc_F0EC:
LevEvents_OOZ2_Routine3:
	cmpi.w	#$1D8,(Camera_Y_pos).w
	blo.s	+
	move.w	#$1D8,(Camera_Min_Y_pos).w
	move.w	#$1D8,(Tails_Min_Y_pos).w
+
	addq.b	#1,(Boss_spawn_delay).w
	cmpi.b	#$5A,(Boss_spawn_delay).w
	blo.s	++	; rts
	jsrto	AllocateObject, JmpTo_AllocateObject
	bne.s	+
	move.b	#ObjID_OOZBoss,id(a1) ; load obj55 (OOZ boss)
+
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	#MusID_Boss,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
+
	rts
; ===========================================================================
; loc_F124:
LevEvents_OOZ2_Routine4:
	tst.b	(Boss_defeated_flag).w
	beq.s	+	; rts
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_Max_X_pos).w,(Tails_Max_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
+
	rts
; ===========================================================================
; loc_F13E:
LevEvents_MCZ:
	tst.b	(Current_Act).w
	bne.s	LevEvents_MCZ2
	rts
; ---------------------------------------------------------------------------
; loc_F146:
LevEvents_MCZ2:
	moveq	#0,d0
	move.b	(Dynamic_Resize_Routine).w,d0
	move.w	LevEvents_MCZ2_Index(pc,d0.w),d0
	jmp	LevEvents_MCZ2_Index(pc,d0.w)
; ===========================================================================
; off_F154:
LevEvents_MCZ2_Index: offsetTable
	offsetTableEntry.w LevEvents_MCZ2_Routine1	; 0
	offsetTableEntry.w LevEvents_MCZ2_Routine2	; 2
	offsetTableEntry.w LevEvents_MCZ2_Routine3	; 4
	offsetTableEntry.w LevEvents_MCZ2_Routine4	; 6
; ===========================================================================
; loc_F15C:
LevEvents_MCZ2_Routine1:
	tst.w	(Two_player_mode).w
	bne.s	++
	cmpi.w	#$2080,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	move.w	#$5D0,(Camera_Max_Y_pos_target).w
	move.w	#$5D0,(Tails_Max_Y_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w
+
	rts
; ---------------------------------------------------------------------------
+
	move.w	#$2100,(Camera_Max_X_pos).w
	move.w	#$2100,(Tails_Max_X_pos).w
	rts
; ===========================================================================
; loc_F196:
LevEvents_MCZ2_Routine2:
	cmpi.w	#$20F0,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	#$20F0,(Camera_Max_X_pos).w
	move.w	#$20F0,(Camera_Min_X_pos).w
	move.w	#$20F0,(Tails_Max_X_pos).w
	move.w	#$20F0,(Tails_Min_X_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	#MusID_FadeOut,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
	clr.b	(Boss_spawn_delay).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtUnc_FallingRocks),VRAM,WRITE),(VDP_control_port).l
	lea	(VDP_data_port).l,a6
	lea	(ArtUnc_FallingRocks).l,a2

	moveq	#7,d0
-   rept 8
	move.l	(a2)+,(a6)
    endm
	dbf	d0,-

	move.b	#5,(Current_Boss_ID).w
	moveq	#PLCID_MczBoss,d0
	jsrto	LoadPLC, JmpTo2_LoadPLC
	moveq	#PalID_MCZ_B,d0
	jsrto	PalLoad_Now, JmpTo2_PalLoad_Now
+
	rts
; ===========================================================================
; loc_F206:
LevEvents_MCZ2_Routine3:
	cmpi.w	#$5C8,(Camera_Y_pos).w
	blo.s	+
	move.w	#$5C8,(Camera_Min_Y_pos).w
	move.w	#$5C8,(Tails_Min_Y_pos).w
+
	addq.b	#1,(Boss_spawn_delay).w
	cmpi.b	#$5A,(Boss_spawn_delay).w
	blo.s	++	; rts
	jsrto	AllocateObject, JmpTo_AllocateObject
	bne.s	+
	move.b	#ObjID_MCZBoss,id(a1) ; load obj57 (MCZ boss)
+
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	#MusID_Boss,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
+
	rts
; ===========================================================================
; loc_F23E:
LevEvents_MCZ2_Routine4:
	tst.b	(Screen_Shaking_Flag).w
	beq.s	+
	move.w	(Timer_frames).w,d0
	andi.w	#$1F,d0
	bne.s	+
	move.w	#SndID_Rumbling2,d0
	jsrto	PlaySound, JmpTo3_PlaySound
+
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_Max_X_pos).w,(Tails_Max_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	rts

; ===========================================================================
; loc_F26A:
LevEvents_CNZ:
	jsr	(SlotMachine).l
	tst.b	(Current_Act).w
	bne.s	LevEvents_CNZ2
	rts			; no events for act 1
; ===========================================================================
; loc_F278:
LevEvents_CNZ2:
	moveq	#0,d0
	move.b	(Dynamic_Resize_Routine).w,d0
	move.w	LevEvents_CNZ2_Index(pc,d0.w),d0
	jmp	LevEvents_CNZ2_Index(pc,d0.w)
; ===========================================================================
; off_F286:
LevEvents_CNZ2_Index: offsetTable
	offsetTableEntry.w LevEvents_CNZ2_Routine1	; 0
	offsetTableEntry.w LevEvents_CNZ2_Routine2	; 2
	offsetTableEntry.w LevEvents_CNZ2_Routine3	; 4
	offsetTableEntry.w LevEvents_CNZ2_Routine4	; 6
; ===========================================================================
; loc_F28E:
LevEvents_CNZ2_Routine1:
	tst.w	(Two_player_mode).w
	bne.s	++
	cmpi.w	#$27C0,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	move.w	#$62E,(Camera_Max_Y_pos_target).w
	move.w	#$62E,(Tails_Max_Y_pos).w
	move.b	#$F9,(Level_Layout+$C54).w
	addq.b	#2,(Dynamic_Resize_Routine).w
+
	rts
; ===========================================================================
+
	move.w	#$26A0,(Camera_Max_X_pos).w
	move.w	#$26A0,(Tails_Max_X_pos).w
	rts
; ===========================================================================
; loc_F2CE:
LevEvents_CNZ2_Routine2:
	cmpi.w	#$2890,(Camera_X_pos).w
	blo.s	+	; rts
	move.b	#$F9,(Level_Layout+$C50).w
	move.w	#$2860,(Camera_Min_X_pos).w
	move.w	#$28E0,(Camera_Max_X_pos).w
	move.w	#$2860,(Tails_Min_X_pos).w
	move.w	#$28E0,(Tails_Max_X_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	#MusID_FadeOut,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
	clr.b	(Boss_spawn_delay).w
	move.b	#6,(Current_Boss_ID).w
	moveq	#PLCID_CnzBoss,d0
	jsrto	LoadPLC, JmpTo2_LoadPLC
	moveq	#PalID_CNZ_B,d0
	jsrto	PalLoad_Now, JmpTo2_PalLoad_Now
+
	rts
; ===========================================================================
; loc_F318:
LevEvents_CNZ2_Routine3:
	cmpi.w	#$4E0,(Camera_Y_pos).w
	blo.s	+
	move.w	#$4E0,(Camera_Min_Y_pos).w
	move.w	#$4E0,(Tails_Min_Y_pos).w
+
	addq.b	#1,(Boss_spawn_delay).w
	cmpi.b	#$5A,(Boss_spawn_delay).w
	blo.s	++	; rts
	jsrto	AllocateObject, JmpTo_AllocateObject
	bne.s	+
	move.b	#ObjID_CNZBoss,id(a1) ; load obj51
+
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	#MusID_Boss,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
+
	rts
; ===========================================================================
; loc_F350:
LevEvents_CNZ2_Routine4:
	cmpi.w	#$2A00,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	#$5D0,(Camera_Max_Y_pos_target).w
	move.w	#$5D0,(Tails_Max_Y_pos).w
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_Max_X_pos).w,(Tails_Max_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
+
	rts
; ===========================================================================
; loc_F378:
LevEvents_CPZ:
	tst.b	(Current_Act).w
	bne.s	LevEvents_CPZ2
	rts
; ===========================================================================
; loc_F380:
LevEvents_CPZ2:
	moveq	#0,d0
	move.b	(Dynamic_Resize_Routine).w,d0
	move.w	LevEvents_CPZ2_Index(pc,d0.w),d0
	jmp	LevEvents_CPZ2_Index(pc,d0.w)
; ===========================================================================
; off_F38E:
LevEvents_CPZ2_Index: offsetTable
	offsetTableEntry.w LevEvents_CPZ2_Routine1	; 0
	offsetTableEntry.w LevEvents_CPZ2_Routine2	; 2
	offsetTableEntry.w LevEvents_CPZ2_Routine3	; 4
	offsetTableEntry.w LevEvents_CPZ2_Routine4	; 6
; ===========================================================================
; loc_F396:
LevEvents_CPZ2_Routine1:
	cmpi.w	#$2680,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	move.w	#$450,(Camera_Max_Y_pos_target).w
	move.w	#$450,(Tails_Max_Y_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w
+
	rts
; ===========================================================================
; loc_F3BC:
LevEvents_CPZ2_Routine2:
	cmpi.w	#$2A20,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	#$2A20,(Camera_Min_X_pos).w
	move.w	#$2A20,(Camera_Max_X_pos).w
	move.w	#$2A20,(Tails_Min_X_pos).w
	move.w	#$2A20,(Tails_Max_X_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	#MusID_FadeOut,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
	clr.b	(Boss_spawn_delay).w
	move.b	#1,(Current_Boss_ID).w
	moveq	#PLCID_CpzBoss,d0
	jmpto	LoadPLC, JmpTo2_LoadPLC
; ===========================================================================
+
	rts
; ===========================================================================
; loc_F3FA:
LevEvents_CPZ2_Routine3:
	cmpi.w	#$448,(Camera_Y_pos).w
	blo.s	+
	move.w	#$448,(Camera_Min_Y_pos).w
	move.w	#$448,(Tails_Min_Y_pos).w
+
	addq.b	#1,(Boss_spawn_delay).w
	cmpi.b	#$5A,(Boss_spawn_delay).w
	blo.s	++
	jsrto	AllocateObject, JmpTo_AllocateObject
	bne.s	+
	move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
+
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	#MusID_Boss,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
+
	rts
; ===========================================================================
; loc_F432:
LevEvents_CPZ2_Routine4:
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_Max_X_pos).w,(Tails_Max_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	rts
; ===========================================================================
; loc_F446:
LevEvents_DEZ:
	moveq	#0,d0
	move.b	(Dynamic_Resize_Routine).w,d0
	move.w	LevEvents_DEZ_Index(pc,d0.w),d0
	jmp	LevEvents_DEZ_Index(pc,d0.w)
; ===========================================================================
; off_F454:
LevEvents_DEZ_Index: offsetTable
	offsetTableEntry.w LevEvents_DEZ_Routine1	; 0
	offsetTableEntry.w LevEvents_DEZ_Routine2	; 2
	offsetTableEntry.w LevEvents_DEZ_Routine3	; 4
	offsetTableEntry.w LevEvents_DEZ_Routine4	; 6
	offsetTableEntry.w LevEvents_DEZ_Routine5	; 8
; ===========================================================================
; loc_F45E:
LevEvents_DEZ_Routine1:
	move.w	#320,d0
	cmp.w	(Camera_X_pos).w,d0
	bhi.s	+	; rts
	addq.b	#2,(Dynamic_Resize_Routine).w
	jsrto	AllocateObject, JmpTo_AllocateObject
	bne.s	+	; rts
	move.b	#ObjID_MechaSonic,id(a1) ; load objAF (Silver Sonic)
	move.b	#$48,subtype(a1)
	move.w	#$348,x_pos(a1)
	move.w	#$A0,y_pos(a1)
	moveq	#PLCID_FieryExplosion,d0
	jmpto	LoadPLC, JmpTo2_LoadPLC
; ===========================================================================
+
	rts
; ===========================================================================
; return_F490:
LevEvents_DEZ_Routine2:
	rts
; ===========================================================================
; loc_F492:
LevEvents_DEZ_Routine3:
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	cmpi.w	#$300,(Camera_X_pos).w
	blo.s	+	; rts
	addq.b	#2,(Dynamic_Resize_Routine).w
	moveq	#PLCID_DezBoss,d0
	jmpto	LoadPLC, JmpTo2_LoadPLC
; ===========================================================================
+
	rts
; ===========================================================================
; loc_F4AC:
LevEvents_DEZ_Routine4:
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	#$680,d0
	cmp.w	(Camera_X_pos).w,d0
	bhi.s	+	; rts
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	d0,(Camera_Min_X_pos).w
	addi.w	#$C0,d0
	move.w	d0,(Camera_Max_X_pos).w
+
	rts
; ===========================================================================
; return_F4CE:
LevEvents_DEZ_Routine5:
	rts
; ===========================================================================
; loc_F4D0:
LevEvents_ARZ:
	tst.b	(Current_Act).w
	bne.s	LevEvents_ARZ2
	rts
; ===========================================================================
; loc_F4D8:
LevEvents_ARZ2:
	moveq	#0,d0
	move.b	(Dynamic_Resize_Routine).w,d0
	move.w	LevEvents_ARZ2_Index(pc,d0.w),d0
	jmp	LevEvents_ARZ2_Index(pc,d0.w)
; ===========================================================================
; off_F4E6:
LevEvents_ARZ2_Index: offsetTable
	offsetTableEntry.w LevEvents_ARZ2_Routine1	; 0
	offsetTableEntry.w LevEvents_ARZ2_Routine2	; 2
	offsetTableEntry.w LevEvents_ARZ2_Routine3	; 4
	offsetTableEntry.w LevEvents_ARZ2_Routine4	; 6
; ===========================================================================
; loc_F4EE:
LevEvents_ARZ2_Routine1:
	cmpi.w	#$2810,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	move.w	#$400,(Camera_Max_Y_pos_target).w
	move.w	#$400,(Tails_Max_Y_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.b	#4,(Current_Boss_ID).w
	moveq	#PLCID_ArzBoss,d0
	jsrto	LoadPLC, JmpTo2_LoadPLC
+
	rts
; ===========================================================================
; loc_F520:
LevEvents_ARZ2_Routine2:
	cmpi.w	#$2A40,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	#$2A40,(Camera_Max_X_pos).w
	move.w	#$2A40,(Camera_Min_X_pos).w
	move.w	#$2A40,(Tails_Max_X_pos).w
	move.w	#$2A40,(Tails_Min_X_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	#MusID_FadeOut,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
	clr.b	(Boss_spawn_delay).w
	jsrto	AllocateObject, JmpTo_AllocateObject
	bne.s	+	; rts
	move.b	#ObjID_ARZBoss,id(a1) ; load obj89
+
	rts
; ===========================================================================
; loc_F55C:
LevEvents_ARZ2_Routine3:
	cmpi.w	#$3F8,(Camera_Y_pos).w
	blo.s	+
	move.w	#$3F8,(Camera_Min_Y_pos).w
	move.w	#$3F8,(Tails_Min_Y_pos).w
+
	addq.b	#1,(Boss_spawn_delay).w
	cmpi.b	#$5A,(Boss_spawn_delay).w
	blo.s	+	; rts
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	#MusID_Boss,d0
	jsrto	PlayMusic, JmpTo3_PlayMusic
+
	rts
; ===========================================================================
; loc_F58A:
LevEvents_ARZ2_Routine4:
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_Max_X_pos).w,(Tails_Max_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	rts
; ===========================================================================
; loc_F59E:
LevEvents_SCZ:
	tst.b	(Current_Act).w
	bne.w	LevEvents_SCZ2
	moveq	#0,d0
	move.b	(Dynamic_Resize_Routine).w,d0
	move.w	LevEvents_SCZ_Index(pc,d0.w),d0
	jmp	LevEvents_SCZ_Index(pc,d0.w)
; ===========================================================================
; off_F5B4:
LevEvents_SCZ_Index: offsetTable
	offsetTableEntry.w LevEvents_SCZ_Routine1	; 0
	offsetTableEntry.w LevEvents_SCZ_Routine2	; 2
	offsetTableEntry.w LevEvents_SCZ_Routine3	; 4
	offsetTableEntry.w LevEvents_SCZ_Routine4	; 6
	offsetTableEntry.w LevEvents_SCZ_RoutineNull	; 8
; ===========================================================================
; loc_F5BE:
LevEvents_SCZ_Routine1:
	move.w	#1,(Tornado_Velocity_X).w
	move.w	#0,(Tornado_Velocity_Y).w
	addq.b	#2,(Dynamic_Resize_Routine).w
	rts
; ===========================================================================
; loc_F5D0:
LevEvents_SCZ_Routine2:
	cmpi.w	#$1180,(Camera_X_pos).w
	blo.s	+
	move.w	#-1,(Tornado_Velocity_X).w
	move.w	#1,(Tornado_Velocity_Y).w
	move.w	#$500,(Camera_Max_Y_pos_target).w
	addq.b	#2,(Dynamic_Resize_Routine).w
+
	rts
; ===========================================================================
; loc_F5F0:
LevEvents_SCZ_Routine3:
	cmpi.w	#$500,(Camera_Y_pos).w
	blo.s	+
	move.w	#1,(Tornado_Velocity_X).w
	move.w	#0,(Tornado_Velocity_Y).w
	addq.b	#2,(Dynamic_Resize_Routine).w
+
	rts
; ===========================================================================
; loc_F60A:
LevEvents_SCZ_Routine4:
	cmpi.w	#$1400,(Camera_X_pos).w
	blo.s	LevEvents_SCZ_RoutineNull
	move.w	#0,(Tornado_Velocity_X).w
	move.w	#0,(Tornado_Velocity_Y).w
	addq.b	#2,(Dynamic_Resize_Routine).w

; return_F622:
LevEvents_SCZ_RoutineNull:
	rts
; ===========================================================================
; return_F624:
LevEvents_SCZ2:
	rts
; ===========================================================================

; loc_F626:
PlayLevelMusic:
	move.w	(Level_Music).w,d0
	jmpto	PlayMusic, JmpTo3_PlayMusic
; ===========================================================================

; loc_F62E:
LoadPLC_AnimalExplosion:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	lea	(Animal_PLCTable).l,a2
	move.b	(a2,d0.w),d0
	jsrto	LoadPLC, JmpTo2_LoadPLC
	moveq	#PLCID_Explosion,d0
	jsrto	LoadPLC, JmpTo2_LoadPLC
	rts
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
JmpTo3_PlaySound ; JmpTo
	jmp	(PlaySound).l
; JmpTo2_PalLoad2
JmpTo2_PalLoad_Now ; JmpTo
	jmp	(PalLoad_Now).l
JmpTo2_LoadPLC ; JmpTo
	jmp	(LoadPLC).l
JmpTo3_PlayMusic ; JmpTo
	jmp	(PlayMusic).l

	align 4
    endif