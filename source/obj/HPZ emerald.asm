; ----------------------------------------------------------------------------
; Object 12 - Emerald from Hidden Palace Zone (unused)
; ----------------------------------------------------------------------------
; Sprite_2031C:
Obj12:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj12_Index(pc,d0.w),d1
	jmp	Obj12_Index(pc,d1.w)
; ===========================================================================
; off_2032A
Obj12_Index:	offsetTable
		offsetTableEntry.w Obj12_Init	; 0
		offsetTableEntry.w Obj12_Main	; 2
; ===========================================================================
; loc_2032E:
Obj12_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj12_MapUnc_20382,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HPZ_Emerald,3,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo10_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#4,priority(a0)
; loc_20356:
Obj12_Main:
	move.w	#$20,d1
	move.w	#$10,d2
	move.w	#$10,d3
	move.w	x_pos(a0),d4
	bsr.w	SolidObject
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo16_DeleteObject
	jmpto	(DisplaySprite).l, JmpTo8_DisplaySprite
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings (unused)
; -------------------------------------------------------------------------------
Obj12_MapUnc_20382:	BINCLUDE "mappings/sprite/obj12.bin"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo8_DisplaySprite 
	jmp	(DisplaySprite).l
JmpTo16_DeleteObject 
	jmp	(DeleteObject).l
JmpTo10_Adjust2PArtPointer 
	jmp	(Adjust2PArtPointer).l

	align 4
    else
JmpTo16_DeleteObject 
	jmp	(DeleteObject).l
    endif
