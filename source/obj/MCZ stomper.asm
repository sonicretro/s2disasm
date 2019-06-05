; ----------------------------------------------------------------------------
; Object 2A - Stomper from MCZ
; ----------------------------------------------------------------------------
; Sprite_115C4:
Obj2A:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj2A_Index(pc,d0.w),d1
	jmp	Obj2A_Index(pc,d1.w)
; ===========================================================================
; off_115D2:
Obj2A_Index:	offsetTable
		offsetTableEntry.w Obj2A_Init	; 0
		offsetTableEntry.w Obj2A_Main	; 2
; ===========================================================================
; loc_115D6:
Obj2A_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj2A_MapUnc_11666,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	move.w	y_pos(a0),objoff_32(a0)
	move.b	#$50,y_radius(a0)
	bset	#4,render_flags(a0)
; loc_11610:
Obj2A_Main:
	tst.b	routine_secondary(a0)
	bne.s	+
	addq.w	#1,objoff_30(a0)
	cmpi.w	#$60,objoff_30(a0)
	bne.s	++
	move.b	#2,routine_secondary(a0)
	bra.s	++
; ===========================================================================
+
	subq.w	#8,objoff_30(a0)
	bhi.s	+
	move.w	#0,objoff_30(a0)
	move.b	#0,routine_secondary(a0)
+
	move.w	objoff_32(a0),d0
	sub.w	objoff_30(a0),d0
	move.w	d0,y_pos(a0)
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#$40,d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	x_pos(a0),d4
	jsrto	(SolidObject).l, JmpTo2_SolidObject
	bra.w	MarkObjGone
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj2A_MapUnc_11666:	BINCLUDE "mappings/sprite/obj2A.bin"
