; ----------------------------------------------------------------------------
; Object 29 - "100 points" text
; ----------------------------------------------------------------------------
; Sprite_11DC6:
Obj29:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj29_Index(pc,d0.w),d1
	jmp	Obj29_Index(pc,d1.w)
; ===========================================================================
; off_11DD4:
Obj29_Index:	offsetTable
		offsetTableEntry.w Obj29_Init	; 0
		offsetTableEntry.w Obj29_Main	; 2
; ===========================================================================

Obj29_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj29_MapUnc_11ED0,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Numbers,0,1),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#1,priority(a0)
	move.b	#8,width_pixels(a0)
	move.w	#-$300,y_vel(a0)	; set initial speed (upwards)

Obj29_Main:
	tst.w	y_vel(a0)		; test speed
	bpl.w	DeleteObject		; if it's positive (>= 0), delete the object
	bsr.w	ObjectMove		; move the points
	addi.w	#$18,y_vel(a0)		; slow down
	bra.w	DisplaySprite
