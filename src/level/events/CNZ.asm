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
	jsrto	JmpTo3_PlayMusic
	clr.b	(Boss_spawn_delay).w
	move.b	#6,(Current_Boss_ID).w
	moveq	#PLCID_CnzBoss,d0
	jsrto	JmpTo2_LoadPLC
	moveq	#PalID_CNZ_B,d0
	jsrto	JmpTo2_PalLoad_Now
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
	jsrto	JmpTo_AllocateObject
	bne.s	+
	move.b	#ObjID_CNZBoss,id(a1) ; load obj51
+
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	#MusID_Boss,d0
	jsrto	JmpTo3_PlayMusic
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
