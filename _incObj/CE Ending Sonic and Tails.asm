; ----------------------------------------------------------------------------
; Object CE - Sonic and Tails jumping off the plane from ending sequence
; ----------------------------------------------------------------------------
; Sprite_A894:
ObjCE:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCE_Index(pc,d0.w),d1
	jmp	ObjCE_Index(pc,d1.w)
; ===========================================================================
; off_A8A2:
ObjCE_Index:	offsetTable
		offsetTableEntry.w ObjCE_Init				; 0
		offsetTableEntry.w loc_A902				; 2
		offsetTableEntry.w loc_A936				; 4
		offsetTableEntry.w BranchTo_JmpTo5_DisplaySprite	; 6
; ===========================================================================
; loc_A8AA:
ObjCE_Init:
	lea	(ObjB3_SubObjData).l,a1
	jsrto	JmpTo_LoadSubObject_Part3
	move.l	#ObjCF_MapUnc_ADA2,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,1),art_tile(a0)
	move.b	#1,priority(a0)
	jsr	(Adjust2PArtPointer).l
	move.b	#$C,mapping_frame(a0)
	cmpi.w	#4,(Ending_Routine).w
	bne.s	+
	move.b	#$F,mapping_frame(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,1,1),art_tile(a0)
+
	move.w	#$E8,d0
	move.w	d0,x_pos(a0)
	move.w	d0,objoff_30(a0)
	move.w	#$118,d0
	move.w	d0,y_pos(a0)
	move.w	d0,objoff_32(a0)
	rts
; ===========================================================================

loc_A902:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.p1_standing,status(a1)
	bne.s	+

loc_A90E:
	move.w	objoff_30(a0),d0
	add.w	(Horiz_Scroll_Buf).w,d0
	move.w	d0,x_pos(a0)
	move.w	objoff_32(a0),d0
	sub.w	(Vscroll_Factor_FG).w,d0
	move.w	d0,y_pos(a0)

BranchTo_JmpTo5_DisplaySprite ; BranchTo
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================
+
	addq.b	#2,routine(a0)
	clr.w	objoff_3C(a0)
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================

loc_A936:
	subq.w	#1,objoff_3C(a0)
	bpl.s	BranchTo2_JmpTo5_DisplaySprite
	move.w	#4,objoff_3C(a0)
	move.w	objoff_34(a0),d0
	cmpi.w	#4,d0
	bhs.s	++
	addq.w	#2,objoff_34(a0)
	lea	byte_A980(pc,d0.w),a1
	cmpi.w	#2,(Ending_Routine).w
	bne.s	+
	lea	byte_A984(pc,d0.w),a1
+
	move.b	(a1)+,d0
	ext.w	d0
	add.w	d0,x_pos(a0)
	move.b	(a1)+,d0
	ext.w	d0
	add.w	d0,y_pos(a0)
	addq.b	#1,mapping_frame(a0)

BranchTo2_JmpTo5_DisplaySprite ; BranchTo
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================
+
	addq.b	#2,routine(a0)
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================
byte_A980:
	dc.b   -8,   0
	dc.b -$44,-$38	; 2
byte_A984:
	dc.b   -8,   0
	dc.b -$50,-$40	; 2
