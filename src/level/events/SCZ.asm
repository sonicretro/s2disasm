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
