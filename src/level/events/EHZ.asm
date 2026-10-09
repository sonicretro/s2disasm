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
	jsrto	JmpTo3_PlayMusic
	clr.b	(Boss_spawn_delay).w
	move.b	#2,(Current_Boss_ID).w
	moveq	#PLCID_EhzBoss,d0
	jsrto	JmpTo2_LoadPLC
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
	jsrto	JmpTo_AllocateObject
	bne.s	+

	move.b	#ObjID_EHZBoss,id(a1) ; load obj56 (EHZ boss)
	move.b	#$81,subtype(a1)
	move.w	#$29D0,x_pos(a1)
	move.w	#$426,y_pos(a1)
+
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_EHZ2_Routine4
	move.w	#MusID_Boss,d0
	jsrto	JmpTo3_PlayMusic
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
