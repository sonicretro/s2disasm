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
	jsrto	JmpTo_AllocateObject
	bne.s	+	; rts
	move.b	#ObjID_MechaSonic,id(a1) ; load objAF (Silver Sonic)
	move.b	#$48,subtype(a1)
	move.w	#$348,x_pos(a1)
	move.w	#$A0,y_pos(a1)
	moveq	#PLCID_FieryExplosion,d0
	jmpto	JmpTo2_LoadPLC
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
	jmpto	JmpTo2_LoadPLC
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
