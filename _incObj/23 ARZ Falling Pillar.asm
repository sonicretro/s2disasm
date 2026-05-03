; ----------------------------------------------------------------------------
; Object 23 - Pillar that drops its lower part from ARZ
; ----------------------------------------------------------------------------
; Sprite_2588C:
Obj23:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj23_Index(pc,d0.w),d1
	jmp	Obj23_Index(pc,d1.w)
; ===========================================================================
; off_2589A:
Obj23_Index:	offsetTable
		offsetTableEntry.w Obj23_Init	; 0
		offsetTableEntry.w Obj23_Main	; 2
; ===========================================================================
; loc_2589E:
Obj23_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj23_MapUnc_259E6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,1,0),art_tile(a0)
	jsrto	JmpTo25_Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#$20,y_radius(a0)
	move.b	#4,priority(a0)
	jsrto	JmpTo10_AllocateObjectAfterCurrent
	bne.s	Obj23_Main
	_move.b	id(a0),id(a1) ; load obj23
	addq.b	#2,routine(a1)
	addq.b	#2,routine_secondary(a1)
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	x_pos(a0),objoff_30(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$30,y_pos(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#$10,y_radius(a1)
	move.b	#4,priority(a1)
	move.b	#1,mapping_frame(a1)
; loc_25922:
Obj23_Main:
	move.w	x_pos(a0),-(sp)
	bsr.w	loc_25948
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	(sp)+,d4
	jsrto	JmpTo8_SolidObject
	jmpto	JmpTo16_MarkObjGone
; ===========================================================================

loc_25948:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj23_Modes(pc,d0.w),d1
	jmp	Obj23_Modes(pc,d1.w)
; ===========================================================================
; off_25956:
Obj23_Modes:	offsetTable
		offsetTableEntry.w return_2598C	; 0
		offsetTableEntry.w loc_2595E	; 2
		offsetTableEntry.w loc_2598E	; 4
		offsetTableEntry.w loc_259B8	; 6
; ===========================================================================

loc_2595E:
	tst.w	(Debug_placement_mode).w
	bne.s	return_2598C
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_2596E
	lea	(Sidekick).w,a1 ; a1=character

loc_2596E:
	move.w	x_pos(a0),d0
	sub.w	x_pos(a1),d0
	bcc.s	+
	neg.w	d0
+
	cmpi.w	#$80,d0
	bhs.s	return_2598C
	move.b	#4,routine_secondary(a0)
	move.w	#8,objoff_34(a0)

return_2598C:
	rts
; ===========================================================================

loc_2598E:
	move.w	objoff_34(a0),d0
	subq.w	#1,d0
	bcc.s	loc_2599C
	addq.b	#2,routine_secondary(a0)
	rts
; ===========================================================================

loc_2599C:
	move.w	d0,objoff_34(a0)
	move.b	byte_259B0(pc,d0.w),d0
	ext.w	d0
	add.w	objoff_30(a0),d0
	move.w	d0,x_pos(a0)
	rts
; ===========================================================================
byte_259B0:
	dc.b  0	; 0
	dc.b  1	; 1
	dc.b -1	; 2
	dc.b  1	; 3
	dc.b  0	; 4
	dc.b -1	; 5
	dc.b  0	; 6
	dc.b  1	; 7
	even
; ===========================================================================

loc_259B8:
	jsrto	JmpTo12_ObjectMove
	addi.w	#$38,y_vel(a0)
	bsr.w	ObjCheckFloorDist
	tst.w	d1
	bpl.w	+
	add.w	d1,y_pos(a0)
	clr.w	y_vel(a0)
	move.w	y_pos(a0),objoff_32(a0)
	move.b	#2,mapping_frame(a0)
	clr.b	routine_secondary(a0)
+
	rts
