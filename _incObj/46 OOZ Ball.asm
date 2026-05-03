; ----------------------------------------------------------------------------
; Object 46 - Ball from OOZ (unused, beta leftover)
; ----------------------------------------------------------------------------
; Sprite_24A16:
Obj46:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj46_Index(pc,d0.w),d1
	jmp	Obj46_Index(pc,d1.w)
; ===========================================================================
; off_24A24:
Obj46_Index:	offsetTable
		offsetTableEntry.w Obj46_Init		; 0 - Init
		offsetTableEntry.w Obj46_Inactive	; 2 - Ball inactive
		offsetTableEntry.w Obj46_Moving		; 4 - Ball moving
		offsetTableEntry.w Obj46_PressureSpring	; 6 - Pressure Spring
; ===========================================================================
; loc_24A2C:
Obj46_Init:
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
	bset	#0,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
	bne.w	JmpTo25_DeleteObject
+
	; loads the ball itself
	addq.b	#2,routine(a0)
	move.b	#$F,y_radius(a0)
	move.b	#$F,x_radius(a0)
	move.l	#Obj46_MapUnc_24C52,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_BallThing,3,0),art_tile(a0)
	jsrto	JmpTo20_Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#3,priority(a0)
	move.w	x_pos(a0),objoff_34(a0)
	move.w	y_pos(a0),objoff_36(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#0,objoff_14(a0)
	move.b	#1,objoff_1F(a0)

; Obj46_InitPressureSpring:	; loads the spring under the ball
	jsrto	JmpTo4_AllocateObject
	bne.s	+
	_move.b	#ObjID_OOZBall,id(a1) ; load obj46
	addq.b	#6,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$12,y_pos(a1)
	move.l	#Obj45_MapUnc_2451A,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_PushSpring,2,0),art_tile(a1)
	ori.b	#1<<render_flags.level_fg,render_flags(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#4,priority(a1)
	move.b	#9,mapping_frame(a1)
	move.l	a0,objoff_3C(a1)
+
	move.l	a1,objoff_3C(a0)
; loc_24AEA:
Obj46_Inactive:
	btst	#button_A,(Ctrl_2_Press).w
	bne.s	+
	lea	(ButtonVine_Trigger).w,a2
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#4,d0
	tst.b	(a2,d0.w)
	beq.s	++
+
	addq.b	#2,routine(a0)
	bset	#status.npc.y_flip,status(a0)
	move.w	#-$300,y_vel(a0)
	move.w	#$100,objoff_14(a0)
	movea.l	objoff_3C(a0),a1 ; a1=object
	move.b	#1,objoff_30(a1)
	btst	#status.npc.x_flip,status(a0)
	beq.s	+
	neg.w	objoff_14(a0)
+
	bsr.w	loc_24BF0
	jmpto	JmpTo11_MarkObjGone
; ===========================================================================
; loc_24B38:
Obj46_Moving:
	move.w	x_pos(a0),-(sp)
	jsrto	JmpTo9_ObjectMove
	btst	#status.npc.y_flip,status(a0)
	beq.s	loc_24B8C
	addi.w	#$18,y_vel(a0)
	bmi.s	+
	move.w	(Camera_Max_Y_pos).w,d0
	addi.w	#screen_height,d0
	cmp.w	y_pos(a0),d0
	blo.s	loc_24BC4
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.w	+
	add.w	d1,y_pos(a0)
	clr.w	y_vel(a0)
	bclr	#status.npc.y_flip,status(a0)
	move.w	#$100,x_vel(a0)
	btst	#status.npc.x_flip,status(a0)
	beq.s	+
	neg.w	x_vel(a0)
+
	bra.s	loc_24BA4
; ===========================================================================

loc_24B8C:
	jsr	(ObjCheckFloorDist).l
	cmpi.w	#8,d1
	blt.s	loc_24BA0
	bset	#status.npc.y_flip,status(a0)
	bra.s	loc_24BA4
; ===========================================================================

loc_24BA0:
	add.w	d1,y_pos(a0)

loc_24BA4:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#$10,d2
	move.w	#$11,d3
	move.w	(sp)+,d4
	jsrto	JmpTo5_SolidObject
	bsr.w	loc_24BF0
	jmpto	JmpTo11_MarkObjGone
; ===========================================================================

loc_24BC4:
	move.w	(sp)+,d4
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	BranchTo_JmpTo25_DeleteObject
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)

    if removeJmpTos
JmpTo25_DeleteObject ; JmpTo
    endif

BranchTo_JmpTo25_DeleteObject ; BranchTo
	jmpto	JmpTo25_DeleteObject
; ===========================================================================
; loc_24BDC:
Obj46_PressureSpring:
	tst.b	objoff_30(a0)
	beq.s	+
	subq.b	#1,mapping_frame(a0)
	bne.s	+
	clr.b	objoff_30(a0)
+
	jmpto	JmpTo11_MarkObjGone
; ===========================================================================

loc_24BF0:
	tst.b	mapping_frame(a0)
	beq.s	+
	move.b	#0,mapping_frame(a0)
	rts
; ===========================================================================
+
	move.b	objoff_14(a0),d0
	beq.s	loc_24C2A
	bmi.s	loc_24C32
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	loc_24C2A
	neg.b	d0
	addq.b	#8,d0
	bcs.s	+
	moveq	#0,d0
+
	move.b	d0,anim_frame_duration(a0)
	move.b	objoff_1F(a0),d0
	addq.b	#1,d0
	cmpi.b	#4,d0
	bne.s	+
	moveq	#1,d0
+
	move.b	d0,objoff_1F(a0)

loc_24C2A:
	move.b	objoff_1F(a0),mapping_frame(a0)
	rts
; ===========================================================================

loc_24C32:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	loc_24C2A
	addq.b	#8,d0
	bcs.s	+
	moveq	#0,d0
+
	move.b	d0,anim_frame_duration(a0)
	move.b	objoff_1F(a0),d0
	subq.b	#1,d0
	bne.s	+
	moveq	#3,d0
+
	move.b	d0,objoff_1F(a0)
	bra.s	loc_24C2A
