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
	jsrto	JmpTo3_PlayMusic
	clr.b	(Boss_spawn_delay).w
	move.b	#7,(Current_Boss_ID).w
	moveq	#PLCID_MtzBoss,d0
	jsrto	JmpTo2_LoadPLC
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
	jsrto	JmpTo_AllocateObject
	bne.s	+
	move.b	#ObjID_MTZBoss,id(a1) ; load obj54 (MTZ boss)
+
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_MTZ3_Routine5
	move.w	#MusID_Boss,d0
	jsrto	JmpTo3_PlayMusic
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
