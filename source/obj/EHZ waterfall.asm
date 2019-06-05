; ----------------------------------------------------------------------------
; Object 49 - Waterfall from EHZ
; ----------------------------------------------------------------------------
; Sprite_20B9E:
Obj49:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj49_Index(pc,d0.w),d1
	jmp	Obj49_Index(pc,d1.w)
; ===========================================================================
; off_20BAC:
Obj49_Index:	offsetTable
		offsetTableEntry.w Obj49_Init	; 0
		offsetTableEntry.w Obj49_ChkDel	; 2
; ===========================================================================
; loc_20BB0: Obj49_Main:
Obj49_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj49_MapUnc_20C50,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Waterfall,1,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo12_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.w	x_pos(a0),objoff_30(a0)
	move.b	#0,priority(a0)
	move.b	#$80,y_radius(a0)
	bset	#4,render_flags(a0)
; loc_20BEA:
Obj49_ChkDel:
	tst.w	(Two_player_mode).w
	bne.s	+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo18_DeleteObject
+
	move.w	x_pos(a0),d1
	move.w	d1,d2
	subi.w	#$40,d1
	addi.w	#$40,d2
	move.b	subtype(a0),d3
	move.b	#0,mapping_frame(a0)
	move.w	(MainCharacter+x_pos).w,d0
	cmp.w	d1,d0
	blo.s	loc_20C36
	cmp.w	d2,d0
	bhs.s	loc_20C36
	move.b	#1,mapping_frame(a0)
	add.b	d3,mapping_frame(a0)
	jmpto	(DisplaySprite).l, JmpTo10_DisplaySprite
; ===========================================================================

loc_20C36:
	move.w	(Sidekick+x_pos).w,d0
	cmp.w	d1,d0
	blo.s	Obj49_Display
	cmp.w	d2,d0
	bhs.s	Obj49_Display
	move.b	#1,mapping_frame(a0)
; loc_20C48:
Obj49_Display:
	add.b	d3,mapping_frame(a0)
	jmpto	(DisplaySprite).l, JmpTo10_DisplaySprite
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj49_MapUnc_20C50:	BINCLUDE "mappings/sprite/obj49.bin"
