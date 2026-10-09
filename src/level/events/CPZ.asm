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
	jsrto	JmpTo3_PlayMusic
	clr.b	(Boss_spawn_delay).w
	move.b	#1,(Current_Boss_ID).w
	moveq	#PLCID_CpzBoss,d0
	jmpto	JmpTo2_LoadPLC
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
	jsrto	JmpTo_AllocateObject
	bne.s	+
	move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
+
	addq.b	#2,(Dynamic_Resize_Routine).w
	move.w	#MusID_Boss,d0
	jsrto	JmpTo3_PlayMusic
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
