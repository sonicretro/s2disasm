; ----------------------------------------------------------------------------
; Object CB - Background clouds from ending sequence
; ----------------------------------------------------------------------------
; Sprite_A9F2:
ObjCB:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCB_Index(pc,d0.w),d1
	jmp	ObjCB_Index(pc,d1.w)
; ===========================================================================
; off_AA00:
ObjCB_Index:	offsetTable
		offsetTableEntry.w ObjCB_Init	; 0
		offsetTableEntry.w loc_AA76	; 2
		offsetTableEntry.w loc_AA8A	; 4
; ===========================================================================
; loc_AA06:
ObjCB_Init:
	lea	(ObjB3_SubObjData).l,a1
	jsrto	JmpTo_LoadSubObject_Part3
	move.w	art_tile(a0),d0
	andi.w	#$1FFF,d0
	ori.w	#palette_mask,d0
	move.w	d0,art_tile(a0)
	move.b	#$30,width_pixels(a0)
	move.l	(RNG_seed).w,d0
	ror.l	#1,d0
	move.l	d0,(RNG_seed).w
	move.w	d0,d1
	andi.w	#3,d0
	move.b	ObjCB_Frames(pc,d0.w),mapping_frame(a0)
	add.w	d0,d0
	move.w	ObjCB_YSpeeds(pc,d0.w),y_vel(a0)
	tst.b	(CutScene+$34).w
	beq.s	+
	andi.w	#$FF,d1
	move.w	d1,y_pos(a0)
	move.w	#$150,x_pos(a0)
	rts
; ===========================================================================
+
	andi.w	#$1FF,d1
	move.w	d1,x_pos(a0)
	move.w	#$100,y_pos(a0)
	rts
; ===========================================================================
; byte_AA6A:
ObjCB_Frames:
	dc.b   0
	dc.b   1	; 1
	dc.b   2	; 2
	dc.b   0	; 3
	even
; word_AA6E:
ObjCB_YSpeeds:
	dc.w -$300
	dc.w -$200	; 1
	dc.w -$100	; 2
	dc.w -$300	; 3
; ===========================================================================

loc_AA76:
	tst.b	(CutScene+objoff_34).w
	beq.s	loc_AA8A
	addq.b	#2,routine(a0)
	move.w	y_vel(a0),x_vel(a0)
	clr.w	y_vel(a0)

loc_AA8A:
	jsrto	JmpTo2_ObjectMove
	tst.b	(CutScene+objoff_34).w
	beq.s	+
	cmpi.w	#-$20,x_pos(a0)
	blt.w	JmpTo3_DeleteObject
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================
+
	tst.w	y_pos(a0)
	bmi.w	JmpTo3_DeleteObject
	jmpto	JmpTo5_DisplaySprite

    if removeJmpTos
JmpTo3_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
