; ----------------------------------------------------------------------------
; Object CD - Birds from ending sequence
; ----------------------------------------------------------------------------
endingbird_delay	= objoff_3C	; delay before doing the next action
; Sprite_AAAE:
ObjCD:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCD_Index(pc,d0.w),d1
	jmp	ObjCD_Index(pc,d1.w)
; ===========================================================================
; off_AABC:
ObjCD_Index:	offsetTable
		offsetTableEntry.w ObjCD_Init	; 0
		offsetTableEntry.w ObjCD_Main	; 2
; ===========================================================================
; loc_AAC0:
ObjCD_Init:
	lea	(ObjCD_SubObjData).l,a1
	jsrto	JmpTo_LoadSubObject_Part3
	move.l	(RNG_seed).w,d0
	ror.l	#3,d0
	move.l	d0,(RNG_seed).w
	move.l	d0,d1
	andi.w	#$7F,d0
	move.w	#-$A0,d2
	add.w	d0,d2
	move.w	d2,x_pos(a0)
	ror.l	#3,d1
	andi.w	#$FF,d1
	moveq	#8,d2
	add.w	d1,d2
	move.w	d2,y_pos(a0)
	move.w	#$100,x_vel(a0)
	moveq	#$20,d0
	cmpi.w	#$20,d1
	blo.s	+
	neg.w	d0
+
	move.w	d0,y_vel(a0)
	move.w	#$C0,endingbird_delay(a0)
	rts
; ===========================================================================
; loc_AB0E:
ObjCD_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjCD_Main_States(pc,d0.w),d1
	jsr	ObjCD_Main_States(pc,d1.w)
	jsrto	JmpTo2_ObjectMove
	lea	(Ani_objCD).l,a1
	jsrto	JmpTo_AnimateSprite
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================
ObjCD_Main_States:	offsetTable
	offsetTableEntry.w loc_AB34	; 0
	offsetTableEntry.w loc_AB5C	; 2
	offsetTableEntry.w loc_AB8E	; 4
; ===========================================================================

loc_AB34:
	subq.w	#1,endingbird_delay(a0)
	bpl.s	+	; rts
	addq.b	#2,routine_secondary(a0)
	move.w	y_vel(a0),objoff_2E(a0)
	clr.w	x_vel(a0)
	move.w	y_pos(a0),objoff_32(a0)
	move.w	#$80,y_vel(a0)
	move.w	#$180,endingbird_delay(a0)
+
	rts
; ===========================================================================

loc_AB5C:
	subq.w	#1,endingbird_delay(a0)
	bmi.s	++
	move.w	y_pos(a0),d0
	moveq	#-4,d1
	cmp.w	objoff_32(a0),d0
	bhs.s	+
	neg.w	d1
+
	add.w	d1,y_vel(a0)
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#-$100,x_vel(a0)
	move.w	objoff_2E(a0),y_vel(a0)
	move.w	#$C0,endingbird_delay(a0)
	rts
; ===========================================================================

loc_AB8E:
	subq.w	#1,endingbird_delay(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.w	#4,sp
	jmpto	JmpTo3_DeleteObject
; ===========================================================================

loc_AB9C:
	subq.w	#1,objoff_30(a0)
	bpl.s	+	; rts
	move.l	(RNG_seed).w,d0
	andi.w	#$1F,d0
	move.w	d0,objoff_30(a0)
	lea	(ChildObject_AD5E).l,a2
	jsrto	JmpTo_LoadChildObject
+
	rts
