; ----------------------------------------------------------------------------
; Object 35 - Invincibility Stars
; ----------------------------------------------------------------------------

obj35_table_offset = objoff_34
obj35_frames_addr = objoff_30
obj35_other_layer_id = objoff_36

; Sprite_1D97E:
Obj35:
	moveq	#0,d0
	move.b	objoff_A(a0),d0
	move.w	Obj35_Index(pc,d0.w),d1
	jmp	Obj35_Index(pc,d1.w)
; ===========================================================================
; off_1D98C:
Obj35_Index:	offsetTable
		offsetTableEntry.w Obj35_Main	; 0
		offsetTableEntry.w Obj35_Layer0Update	; 2
		offsetTableEntry.w Obj35_OtherLayersUpdate	; 4
; off_1D992:
Obj35_Layers:
	dc.l Obj35_Layer1Frames1
	dc.b 0 ; offset for Obj35_PositionOffsetTable; here it's overwritten right before Obj35_Layer0Update
	dc.b Obj35_Layer1Frames2-Obj35_Layer1Frames1

	dc.l Obj35_Layer2Frames1
	dc.b 22
	dc.b Obj35_Layer2Frames2-Obj35_Layer2Frames1

	dc.l Obj35_Layer3Frames1
	dc.b 44
	dc.b Obj35_Layer3Frames2-Obj35_Layer3Frames1
; ===========================================================================
; loc_1D9A4:
Obj35_Main:
	moveq	#0,d2
	lea	Obj35_Layers-6(pc),a2
	lea	(a0),a1

	moveq	#3,d1 ; 3 star layers

-	_move.b	id(a0),id(a1) ; load obj35
	move.b	#4,objoff_A(a1)		; => Obj35_OtherLayersUpdate
	move.l	#Obj35_MapUnc_1DCBC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Invincible_stars,0,0),art_tile(a1)
	bsr.w	Adjust2PArtPointer2
	move.b	#1<<render_flags.level_fg,render_flags(a1)
	bset	#render_flags.multi_sprite,render_flags(a1)
	move.b	#$10,mainspr_width(a1)
	move.b	#2,mainspr_childsprites(a1)
	move.w	parent(a0),parent(a1)
	move.b	d2,obj35_other_layer_id(a1)
	addq.w	#1,d2
	move.l	(a2)+,obj35_frames_addr(a1)
	move.w	(a2)+,objoff_34(a1)
	lea	next_object(a1),a1 ; a1=object
	dbf	d1,-

	move.b	#2,objoff_A(a0)		; => Obj35_Layer0Update
	move.b	#4,obj35_table_offset(a0)

; loc_1DA0C:
Obj35_Layer0Update:
    if fixBugs
	; If Sonic is invincible and he turns Super, then the invincibility
	; stars will not go away. S3K fixes this by doing this:
	tst.b	(Super_Sonic_flag).w
	bne.w	DeleteObject
    endif
	movea.w	parent(a0),a1 ; a1=character
	btst	#status_secondary.invincible,status_secondary(a1)
	beq.w	DeleteObject
	move.w	x_pos(a1),d0
	move.w	d0,x_pos(a0)
	move.w	y_pos(a1),d1
	move.w	d1,y_pos(a0)
	lea	subspr_data(a0),a2
	lea	Obj35_Layer0Frames(pc),a3
	moveq	#0,d5

-	move.w	objoff_38(a0),d2
	move.b	(a3,d2.w),d5 ; frame
	bpl.s	loc_1DA44
	clr.w	objoff_38(a0)
	bra.s	-
; ===========================================================================

loc_1DA44:
	addq.w	#1,objoff_38(a0)
	lea	Obj35_PositionOffsetTable(pc),a6
	move.b	obj35_table_offset(a0),d6

	jsr	Obj35_GetSpriteParams(pc)
	move.w	d2,(a2)+	; sub2_x_pos
	move.w	d3,(a2)+	; sub2_y_pos
	move.w	d5,(a2)+	; sub2_mapframe

	addi.w	#16*2,d6	; add 16 positions (add 180 degrees to the angle)

	jsr	Obj35_GetSpriteParams(pc)
	move.w	d2,(a2)+	; sub3_x_pos
	move.w	d3,(a2)+	; sub3_y_pos
	move.w	d5,(a2)+	; sub3_mapframe

	moveq	#9*2,d0	; add 9 positions (18 bytes) to the table offset
	btst	#status.player.x_flip,status(a1)	; if the player is looking to the left, negate the speed
	beq.s	+
	neg.w	d0

+	add.b	d0,obj35_table_offset(a0)
	move.w	#object_display_list_size*1,d0
	bra.w	DisplaySprite3
; ===========================================================================
; loc_1DA80:
Obj35_OtherLayersUpdate:
    if fixBugs
	; If Sonic is invincible and he turns Super, then the invincibility
	; stars will not go away. S3K fixes this by doing this:
	tst.b	(Super_Sonic_flag).w
	bne.w	DeleteObject
    endif
	movea.w	parent(a0),a1 ; a1=character
	btst	#status_secondary.invincible,status_secondary(a1)
	beq.w	DeleteObject
	cmpi.w	#2,(Player_mode).w
	beq.s	+
	lea	(Sonic_Pos_Record_Index).w,a5
	lea	(Sonic_Pos_Record_Buf).w,a6
	tst.b	parent+1(a0)
	beq.s	++

+	lea	(Tails_Pos_Record_Index).w,a5
	lea	(Tails_Pos_Record_Buf).w,a6

+	move.b	obj35_other_layer_id(a0),d1	; calculate the player position table offset
	lsl.b	#2,d1
	move.w	d1,d2
	add.w	d1,d1
	add.w	d2,d1
	move.w	(a5),d0
	sub.b	d1,d0	; d0 (offset) = obj35_other_layer_id * 12 bytes (obj35_other_layer_id * 3 positions)
	lea	(a6,d0.w),a2
	move.w	(a2)+,d0	; save the previous player position in d0, d1
	move.w	(a2)+,d1
	move.w	d0,x_pos(a0)
	move.w	d1,y_pos(a0)
	lea	subspr_data(a0),a2
	movea.l	obj35_frames_addr(a0),a3

-	move.w	objoff_38(a0),d2
	move.b	(a3,d2.w),d5 ; load frame 1
	bpl.s	loc_1DAE4
	clr.w	objoff_38(a0)
	bra.s	-
; ===========================================================================

loc_1DAE4:
	swap	d5
	add.b	objoff_35(a0),d2
	move.b	(a3,d2.w),d5 ; load frame 2
	addq.w	#1,objoff_38(a0)
	lea	Obj35_PositionOffsetTable(pc),a6
	move.b	obj35_table_offset(a0),d6

	jsr	Obj35_GetSpriteParams(pc)
	move.w	d2,(a2)+	; sub2_x_pos
	move.w	d3,(a2)+	; sub2_y_pos
	move.w	d5,(a2)+	; sub2_mapframe, use frame 2

	addi.w	#16*2,d6	; add 16 positions (add 180 degrees to the angle)
	swap	d5
	
	jsr	Obj35_GetSpriteParams(pc)
	move.w	d2,(a2)+	; sub3_x_pos
	move.w	d3,(a2)+	; sub3_y_pos
	move.w	d5,(a2)+	; sub3_mapframe, use frame 1
	
	moveq	#1*2,d0	; add 1 positions (2 bytes) to the table offset
	btst	#status.player.x_flip,status(a1)	; if the player is looking to the left, negate the speed
	beq.s	+
	neg.w	d0

+	add.b	d0,obj35_table_offset(a0)
	move.w	#object_display_list_size*1,d0
	bra.w	DisplaySprite3
; ===========================================================================
; loc_1DB2C:
Obj35_GetSpriteParams:
	andi.w	#$3E,d6	; 31*2, 64 bytes in the array (32 positions)
	move.b	(a6,d6.w),d2	; read the X and Y position into d2 and d3 respectively
	move.b	1(a6,d6.w),d3
	ext.w	d2
	ext.w	d3
	add.w	d0,d2	; add the previous player position to d2 and d3
	add.w	d1,d3
	rts
; ===========================================================================
; byte_1DB42:
Obj35_PositionOffsetTable:
		;		X, Y
		dc.b	15, 0	; 0 degrees
		dc.b	15, 3
		dc.b	14, 6
		dc.b	13, 8
		dc.b	11, 11
		dc.b	8, 13
		dc.b	6, 14
		dc.b	3, 15
		dc.b	0, 16	; 90
		dc.b	-4, 15
		dc.b	-7, 14
		dc.b	-9, 13
		dc.b	-12, 11
		dc.b	-14, 8
		dc.b	-15, 6
		dc.b	-16, 3
		dc.b	-16, 0	; 180
		dc.b	-16, -4
		dc.b	-15, -7
		dc.b	-14, -9
		dc.b	-12, -12
		dc.b	-9, -14
		dc.b	-7, -15
		dc.b	-4, -16
		dc.b	-1, -16	; 270
		dc.b	3, -16
		dc.b	6, -15
		dc.b	8, -14
		dc.b	11, -12
		dc.b	13, -9
		dc.b	14, -7
		dc.b	15, -4

; byte_1DB82:
Obj35_Layer0Frames:		dc.b   8,  5,  7,  6,  6,  7,  5,  8,  6,  7,  7,  6,$FF
	rev02even
; byte_1DB8F:
Obj35_Layer1Frames1:	dc.b   8,  7,  6,  5,  4,  3,  4,  5,  6,  7,$FF
Obj35_Layer1Frames2:	dc.b   3,  4,  5,  6,  7,  8,  7,  6,  5,  4
	rev02even
; byte_1DBA4:
Obj35_Layer2Frames1:	dc.b   8,  7,  6,  5,  4,  3,  2,  3,  4,  5,  6,  7,$FF
Obj35_Layer2Frames2:	dc.b   2,  3,  4,  5,  6,  7,  8,  7,  6,  5,  4,  3
	rev02even
; byte_1DBBD:
Obj35_Layer3Frames1:	dc.b   7,  6,  5,  4,  3,  2,  1,  2,  3,  4,  5,  6,$FF
Obj35_Layer3Frames2:	dc.b   1,  2,  3,  4,  5,  6,  7,  6,  5,  4,  3,  2
	even

	include "src/anim/Shield.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj38_MapUnc_1DBE4:	include "mappings/sprite/obj38.asm"
Obj35_MapUnc_1DCBC:	include "mappings/sprite/obj35.asm"

; ===========================================================================
