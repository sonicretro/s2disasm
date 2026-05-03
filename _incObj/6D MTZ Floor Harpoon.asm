; ----------------------------------------------------------------------------
; Object 6D - Floor spike from MTZ
; ----------------------------------------------------------------------------
floorspike_initial_x_pos =	objoff_30
floorspike_initial_y_pos =	objoff_32
floorspike_offset =		objoff_34 ; on the y axis
floorspike_position =		objoff_36 ; 0 = retracted or expanding, 1 = expanded or retracting
floorspike_waiting =		objoff_38 ; 0 = moving, 1 = waiting
floorspike_delay =		objoff_3A ; short delay before the spike retracts
; Sprite_27794:
Obj6D:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj6D_Index(pc,d0.w),d1
	jmp	Obj6D_Index(pc,d1.w)
; ===========================================================================
; off_277A2:
Obj6D_Index:	offsetTable
		offsetTableEntry.w Obj6D_Init	; 0
		offsetTableEntry.w Obj6D_Main	; 2
; ===========================================================================
; loc_277A6:
Obj6D_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj68_Obj6D_MapUnc_27750,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MtzSpike,1,0),art_tile(a0)
	jsrto	JmpTo31_Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#4,width_pixels(a0)
	move.b	#4,priority(a0)
	move.w	x_pos(a0),floorspike_initial_x_pos(a0)
	move.w	y_pos(a0),floorspike_initial_y_pos(a0)
	move.b	#$84,collision_flags(a0)
; loc_277E0:
Obj6D_Main:
	bsr.w	Obj6D_Action
	moveq	#0,d0
	move.b	floorspike_offset(a0),d0
	neg.w	d0
	add.w	floorspike_initial_y_pos(a0),d0
	move.w	d0,y_pos(a0)
	move.w	floorspike_initial_x_pos(a0),d0
	jmpto	JmpTo2_MarkObjGone2
; ===========================================================================
; loc_277FC:
Obj6D_Action:
	tst.w	floorspike_delay(a0)
	beq.s	+
	subq.w	#1,floorspike_delay(a0)
	rts
; ---------------------------------------------------------------------------
+
	tst.w	floorspike_waiting(a0)
	beq.s	+
	move.b	(Level_frame_counter+1).w,d0
	sub.b	subtype(a0),d0
	andi.b	#$7F,d0
	bne.s	Obj6D_Action_End
	clr.w	floorspike_waiting(a0)
+
	tst.w	floorspike_position(a0)
	beq.s	Obj6D_Expanding
; Obj6D_Retracting:
	subi.w	#$400,floorspike_offset(a0)
	bcc.s	Obj6D_Action_End
	move.w	#0,floorspike_offset(a0)
	move.w	#0,floorspike_position(a0)
	move.w	#1,floorspike_waiting(a0)
	rts
; ===========================================================================
; loc_27842:
Obj6D_Expanding:
	addi.w	#$400,floorspike_offset(a0)
	cmpi.w	#$2000,floorspike_offset(a0)
	blo.s	Obj6D_Action_End
	move.w	#$2000,floorspike_offset(a0)
	move.w	#1,floorspike_position(a0)
	move.w	#3,floorspike_delay(a0)
; return_27862:
Obj6D_Action_End:
	rts
