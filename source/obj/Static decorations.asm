; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Objects: Static decorations (1C, 71)

; ----------------------------------------------------------------------------
; Object 1C - Bridge stake in Emerald Hill Zone and Hill Top Zone, falling oil in Oil Ocean Zone
; ----------------------------------------------------------------------------
; Sprite_111D4:
Obj1C:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj1C_Index(pc,d0.w),d1
	jmp	Obj1C_Index(pc,d1.w)
; ===========================================================================
; off_111E2:
Obj1C_Index:	offsetTable
		offsetTableEntry.w Obj1C_Init		; 0
		offsetTableEntry.w BranchTo_MarkObjGone	; 2
; ===========================================================================

objsubdecl macro frame, mapaddr,artaddr,width,priority
	dc.l frame<<24|mapaddr
	dc.w artaddr
	dc.b width, priority
    endm

; dword_111E6:
Obj1C_InitData:
	objsubdecl 0, Obj1C_MapUnc_11552, make_art_tile(ArtTile_ArtNem_BoltEnd_Rope,2,0), 4, 6
	objsubdecl 1, Obj1C_MapUnc_11552, make_art_tile(ArtTile_ArtNem_BoltEnd_Rope,2,0), 4, 6
	objsubdecl 1, Obj11_MapUnc_FC70,  make_art_tile(ArtTile_ArtNem_EHZ_Bridge,2,0), 4, 1
	objsubdecl 2, Obj1C_MapUnc_11552, make_art_tile(ArtTile_ArtNem_BoltEnd_Rope,1,0), $10, 6
	objsubdecl 3, Obj16_MapUnc_21F14, make_art_tile(ArtTile_ArtNem_HtzZipline,2,0), 8, 4
	objsubdecl 4, Obj16_MapUnc_21F14, make_art_tile(ArtTile_ArtNem_HtzZipline,2,0), 8, 4
	objsubdecl 1, Obj16_MapUnc_21F14, make_art_tile(ArtTile_ArtNem_HtzZipline,2,0), $20, 1
	objsubdecl 0, Obj1C_MapUnc_113D6, make_art_tile(ArtTile_ArtKos_LevelArt,2,0), 8, 1
	objsubdecl 1, Obj1C_MapUnc_113D6, make_art_tile(ArtTile_ArtKos_LevelArt,2,0), 8, 1
	objsubdecl 0, Obj1C_MapUnc_113EE, make_art_tile(ArtTile_ArtUnc_Waterfall3,2,0), 4, 4
	objsubdecl 0, Obj1C_MapUnc_11406, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0), 4, 4
	objsubdecl 1, Obj1C_MapUnc_11406, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0), 4, 4
	objsubdecl 2, Obj1C_MapUnc_11406, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0), 4, 4
	objsubdecl 3, Obj1C_MapUnc_11406, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0), 4, 4
	objsubdecl 4, Obj1C_MapUnc_11406, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0), 4, 4
	objsubdecl 5, Obj1C_MapUnc_11406, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0), 4, 4
	objsubdecl 0, Obj1C_MapUnc_114AE, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0), $18, 4
	objsubdecl 1, Obj1C_MapUnc_114AE, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0), $18, 4
	objsubdecl 2, Obj1C_MapUnc_114AE, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0), 8, 4
	objsubdecl 3, Obj1C_MapUnc_114AE, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0), 8, 4
	objsubdecl 4, Obj1C_MapUnc_114AE, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0), 8, 4
; byte_1128E:
Obj1C_Radii:
	dc.b   0
	dc.b   0	; 1
	dc.b   0	; 2
	dc.b   0	; 3
	dc.b   0	; 4
	dc.b   0	; 5
	dc.b   0	; 6
	dc.b   0	; 7
	dc.b   0	; 8
	dc.b   0	; 9
	dc.b   0	; 10
	dc.b   0	; 11
	dc.b   0	; 12
	dc.b $30	; 13
	dc.b $40	; 14
	dc.b $60	; 15
	dc.b   0	; 16
	dc.b   0	; 17
	dc.b $30	; 18
	dc.b $40	; 19
	dc.b $50	; 20
	dc.b   0	; 21
; ===========================================================================
; loc_112A4:
Obj1C_Init:
	addq.b	#2,routine(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	move.w	d0,d1
	lsl.w	#3,d0
	lea	Obj1C_InitData(pc),a1
	lea	(a1,d0.w),a1
	move.b	(a1),mapping_frame(a0)
	move.l	(a1)+,mappings(a0)
	move.w	(a1)+,art_tile(a0)
	bsr.w	Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	(a1)+,width_pixels(a0)
	move.b	(a1)+,priority(a0)
	lea	Obj1C_Radii(pc),a1
	move.b	(a1,d1.w),d1
	beq.s	BranchTo_MarkObjGone	; if the radius is zero, branch
	move.b	d1,y_radius(a0)
	bset	#4,render_flags(a0)

BranchTo_MarkObjGone 
	bra.w	MarkObjGone
; ===========================================================================
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
	ori.b	#4,render_flags(a0)
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
; ===========================================================================
; off_1136A:
Ani_obj71:	offsetTable
		offsetTableEntry.w byte_11372	; 0
		offsetTableEntry.w byte_1137A	; 1
		offsetTableEntry.w byte_11389	; 2
		offsetTableEntry.w byte_11392	; 3
byte_11372:	dc.b   8,  3,  3,  4,  5,  5,  4,$FF
	rev02even
byte_1137A:	dc.b   5,  0,  0,  0,  1,  2,  3,  3,  2,  1,  2,  3,  3,  1,$FF
	rev02even
byte_11389:	dc.b  $B,  0,  1,  2,  3,  4,  5,$FD,  3
	rev02even
byte_11392:	dc.b $7F,  6,$FD,  2
	even

; --------------------------------------------------------------------------------
; sprite mappings
; --------------------------------------------------------------------------------
Obj71_MapUnc_11396:	BINCLUDE "mappings/sprite/obj71_a.bin"
; ----------------------------------------------------------------------------------------
; Unknown sprite mappings
; ----------------------------------------------------------------------------------------
Obj1C_MapUnc_113D6:	BINCLUDE "mappings/sprite/obj1C_a.bin"
; --------------------------------------------------------------------------------
; Unknown sprite mappings
; --------------------------------------------------------------------------------
Obj1C_MapUnc_113EE:	BINCLUDE "mappings/sprite/obj1C_b.bin"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj1C_MapUnc_11406:	BINCLUDE "mappings/sprite/obj1C_c.bin"
; --------------------------------------------------------------------------------
; sprite mappings
; --------------------------------------------------------------------------------
Obj1C_MapUnc_114AE:	BINCLUDE "mappings/sprite/obj1C_d.bin"
; --------------------------------------------------------------------------------
; sprite mappings
; --------------------------------------------------------------------------------
Obj1C_MapUnc_11552:	BINCLUDE "mappings/sprite/obj1C_e.bin"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj71_MapUnc_11576:	BINCLUDE "mappings/sprite/obj71_b.bin"
; ===========================================================================

    if gameRevision<2
	nop
    endif
