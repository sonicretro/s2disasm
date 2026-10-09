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
	jsrto	JmpTo3_PlayMusic
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
	jsrto	JmpTo2_LoadPLC
	moveq	#PalID_MCZ_B,d0
	jsrto	JmpTo2_PalLoad_Now
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
	jsrto	JmpTo_AllocateObject
	bne.s	+
	move.b	#ObjID_MCZBoss,id(a1) ; load obj57 (MCZ boss)
+
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	#MusID_Boss,d0
	jsrto	JmpTo3_PlayMusic
+
	rts
; ===========================================================================
; loc_F23E:
LevEvents_MCZ2_Routine4:
	tst.b	(Screen_Shaking_Flag).w
	beq.s	+
	move.w	(Level_frame_counter).w,d0
	andi.w	#$1F,d0
	bne.s	+
	move.w	#SndID_Rumbling2,d0
	jsrto	JmpTo3_PlaySound
+
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_Max_X_pos).w,(Tails_Max_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	rts

; ===========================================================================
