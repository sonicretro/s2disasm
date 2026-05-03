; ----------------------------------------------------------------------------
; Object 58 - Boss explosion
; ----------------------------------------------------------------------------
; Sprite_2D494:
Obj58:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj58_Index(pc,d0.w),d1
	jmp	Obj58_Index(pc,d1.w)
; ===========================================================================
; off_2D4A2:
Obj58_Index:	offsetTable
		offsetTableEntry.w Obj58_Init	; 0
		offsetTableEntry.w Obj58_Main	; 2
; ===========================================================================
; loc_2D4A6:
Obj58_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj58_MapUnc_2D50A,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_FieryExplosion,0,1),art_tile(a0)
	jsrto	JmpTo59_Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#0,priority(a0)
	move.b	#0,collision_flags(a0)
	move.b	#$C,width_pixels(a0)
	move.b	#7,anim_frame_duration(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#SndID_BossExplosion,d0
	jmp	(PlaySound).l
; ===========================================================================
	rts
; ===========================================================================
; loc_2D4EC:
Obj58_Main:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#7,mapping_frame(a0)
	beq.w	JmpTo50_DeleteObject
+
	jmpto	JmpTo33_DisplaySprite

    if removeJmpTos
JmpTo50_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
