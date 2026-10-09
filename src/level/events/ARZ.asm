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
	jsrto	JmpTo2_LoadPLC
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
	jsrto	JmpTo3_PlayMusic
	clr.b	(Boss_spawn_delay).w
	jsrto	JmpTo_AllocateObject
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
	jsrto	JmpTo3_PlayMusic
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
