; ----------------------------------------------------------------------------
; Object D5 - Elevator from CNZ
; ----------------------------------------------------------------------------
; Sprite_2BA08:
ObjD5:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjD5_Index(pc,d0.w),d1
	jmp	ObjD5_Index(pc,d1.w)
; ===========================================================================
; off_2BA16:
ObjD5_Index:	offsetTable
		offsetTableEntry.w ObjD5_Init	; 0
		offsetTableEntry.w ObjD5_Main	; 2
; ===========================================================================
; loc_2BA1A:
ObjD5_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjD5_MapUnc_2BB40,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZElevator,2,0),art_tile(a0)
	jsrto	JmpTo53_Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	move.w	y_pos(a0),objoff_32(a0)
	move.w	#$8000,y_sub(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#2,d0
	sub.w	d0,y_pos(a0)
	btst	#status.npc.x_flip,status(a0)
	beq.s	ObjD5_Main
	add.w	d0,d0
	add.w	d0,y_pos(a0)
; loc_2BA68:
ObjD5_Main:
	jsrto	JmpTo18_ObjectMove
	move.w	objoff_34(a0),d0
	move.w	off_2BA94(pc,d0.w),d1
	jsr	off_2BA94(pc,d1.w)
	cmpi.w	#6,objoff_34(a0)
	bhs.s	+
	move.w	#$10,d1
	move.w	#9,d3
	move.w	x_pos(a0),d4
	jsrto	JmpTo_PlatformObjectD5
+
	jmpto	JmpTo28_MarkObjGone
; ===========================================================================
off_2BA94:	offsetTable
		offsetTableEntry.w loc_2BA9C	; 0
		offsetTableEntry.w loc_2BAB6	; 2
		offsetTableEntry.w loc_2BAEE	; 4
		offsetTableEntry.w loc_2BB08	; 6
; ===========================================================================

loc_2BA9C:
	move.b	status(a0),d0
	andi.w	#standing_mask,d0
	beq.s	+	; rts
	move.w	#SndID_CNZElevator,d0
	jsr	(PlaySound).l
	addq.w	#2,objoff_34(a0)
+
	rts
; ===========================================================================

loc_2BAB6:
	moveq	#8,d1
	move.w	objoff_32(a0),d0
	cmp.w	y_pos(a0),d0
	bhs.s	+
	neg.w	d1
+
	add.w	d1,y_vel(a0)
	bne.s	+	; rts
	addq.w	#2,objoff_34(a0)
	move.w	d0,y_pos(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#2,d0
	sub.w	d0,y_pos(a0)
	btst	#status.npc.x_flip,status(a0)
	bne.s	+	; rts
	add.w	d0,d0
	add.w	d0,y_pos(a0)
+
	rts
; ===========================================================================

loc_2BAEE:
	move.b	status(a0),d0
	andi.w	#standing_mask,d0
	bne.s	+	; rts
	move.w	#SndID_CNZElevator,d0
	jsr	(PlaySound).l
	addq.w	#2,objoff_34(a0)
+
	rts
; ===========================================================================

loc_2BB08:
	moveq	#8,d1
	move.w	objoff_32(a0),d0
	cmp.w	y_pos(a0),d0
	bhs.s	+
	neg.w	d1
+
	add.w	d1,y_vel(a0)
	bne.s	+	; rts
	clr.w	objoff_34(a0)
	move.w	d0,y_pos(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#2,d0
	sub.w	d0,y_pos(a0)
	btst	#status.npc.x_flip,status(a0)
	beq.s	+	; rts
	add.w	d0,d0
	add.w	d0,y_pos(a0)
+
	rts
