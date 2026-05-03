; ----------------------------------------------------------------------------
; Object 71 - Bridge stake and pulsing orb from Hidden Palace Zone
; ----------------------------------------------------------------------------
; Sprite_112F0:
Obj71:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj71_Index(pc,d0.w),d1
	jmp	Obj71_Index(pc,d1.w)
; ===========================================================================
; off_112FE:
Obj71_Index:	offsetTable
		offsetTableEntry.w Obj71_Init	; 0
		offsetTableEntry.w Obj71_Main	; 2
; ---------------------------------------------------------------------------
; dword_11302:
Obj71_InitData:
	objsubdecl 3, Obj11_MapUnc_FC28,  make_art_tile(ArtTile_ArtNem_HPZ_Bridge,3,0), 4, 1		; Hidden Palace bridge
	objsubdecl 0, Obj71_MapUnc_11396, make_art_tile(ArtTile_ArtNem_HPZOrb,3,1), $10, 1		; Hidden Palace pulsing orb
	objsubdecl 0, Obj71_MapUnc_11576, make_art_tile(ArtTile_ArtNem_MtzLavaBubble,2,0), $10, 1	; MTZ lava bubble
; ===========================================================================
; loc_1131A:
Obj71_Init:
	addq.b	#2,routine(a0)
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	lsl.w	#3,d0
	lea	Obj71_InitData(pc),a1
	lea	(a1,d0.w),a1
	move.b	(a1),mapping_frame(a0)
	move.l	(a1)+,mappings(a0)
	move.w	(a1)+,art_tile(a0)
	bsr.w	Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	(a1)+,width_pixels(a0)
	move.b	(a1)+,priority(a0)
	move.b	subtype(a0),d0
	andi.w	#$F0,d0
	lsr.b	#4,d0
	move.b	d0,anim(a0)
; loc_1135C:
Obj71_Main:
	lea	(Ani_obj71).l,a1
	bsr.w	AnimateSprite
	bra.w	MarkObjGone
