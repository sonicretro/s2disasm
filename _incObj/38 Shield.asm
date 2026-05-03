; ----------------------------------------------------------------------------
; Object 38 - Shield
; ----------------------------------------------------------------------------
; Sprite_1D8F2:
Obj38:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj38_Index(pc,d0.w),d1
	jmp	Obj38_Index(pc,d1.w)
; ===========================================================================
; off_1D900:
Obj38_Index:	offsetTable
		offsetTableEntry.w Obj38_Main	; 0
		offsetTableEntry.w Obj38_Shield	; 2
; ===========================================================================
; loc_1D904:
Obj38_Main:
	addq.b	#2,routine(a0)
	move.l	#Obj38_MapUnc_1DBE4,mappings(a0)
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#1,priority(a0)
	move.b	#$18,width_pixels(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Shield,0,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
; loc_1D92C:
Obj38_Shield:
	movea.w	parent(a0),a2 ; a2=character
	btst	#status_secondary.invincible,status_secondary(a2)
	bne.s	return_1D976
	btst	#status_secondary.shield,status_secondary(a2)
	beq.s	JmpTo7_DeleteObject
	move.w	x_pos(a2),x_pos(a0)
	move.w	y_pos(a2),y_pos(a0)
	move.b	status(a2),status(a0)
	andi.w	#drawing_mask,art_tile(a0)
	tst.w	art_tile(a2)
	bpl.s	Obj38_Display
	ori.w	#high_priority,art_tile(a0)
; loc_1D964:
Obj38_Display:
	lea	(Ani_obj38).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

return_1D976:
	rts
