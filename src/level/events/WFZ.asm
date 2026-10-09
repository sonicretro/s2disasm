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
	jsrto	JmpTo2_LoadPLC
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
	jsrto	JmpTo2_LoadPLC
+
	rts
; ===========================================================================
; return_E984:
LevEvents_WFZ_RoutineNull:
	rts

; ===========================================================================
