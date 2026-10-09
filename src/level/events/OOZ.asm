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
	jsrto	JmpTo3_PlayMusic
	clr.b	(Boss_spawn_delay).w
	move.b	#8,(Current_Boss_ID).w
	moveq	#PLCID_OozBoss,d0
	jsrto	JmpTo2_LoadPLC
	moveq	#PalID_OOZ_B,d0
	jsrto	JmpTo2_PalLoad_Now
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
	jsrto	JmpTo_AllocateObject
	bne.s	+
	move.b	#ObjID_OOZBoss,id(a1) ; load obj55 (OOZ boss)
+
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	#MusID_Boss,d0
	jsrto	JmpTo3_PlayMusic
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
