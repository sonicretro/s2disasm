; ----------------------------------------------------------------------------
; Object 74 - Invisible solid block
; ----------------------------------------------------------------------------
; Sprite_20EE0:
Obj74:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj74_Index(pc,d0.w),d1
	jmp	Obj74_Index(pc,d1.w)
; ===========================================================================
; off_20EEE: Obj74_States:
Obj74_Index:	offsetTable
		offsetTableEntry.w Obj74_Init	; 0
		offsetTableEntry.w Obj74_Main	; 2
; ===========================================================================
; loc_20EF2:
Obj74_Init:
	addq.b	#2,routine(a0) ; => Obj74_Main
	move.l	#Obj74_MapUnc_20F66,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Powerups,0,1),art_tile(a0)
	jsrto	JmpTo12_Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	subtype(a0),d0
	move.b	d0,d1
	andi.w	#$F0,d0
	addi.w	#$10,d0
	lsr.w	#1,d0
	move.b	d0,width_pixels(a0)
	andi.w	#$F,d1
	addq.w	#1,d1
	lsl.w	#3,d1
	move.b	d1,y_radius(a0)

; loc_20F2E:
Obj74_Main:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	x_pos(a0),d4
	bsr.w	SolidObject_Always
	tst.w	(Two_player_mode).w
	bne.s	+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo18_DeleteObject
    if gameRevision=0
    ; this object was visible with debug mode in REV00
+
	tst.w	(Debug_placement_mode).w
	beq.s	+	; rts
	jmp	(DisplaySprite).l
    endif
+
	rts
