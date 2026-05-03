; ----------------------------------------------------------------------------
; Object CF - "Plane's helixes" from ending sequence
; ----------------------------------------------------------------------------
; Sprite_A988:
ObjCF:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCF_Index(pc,d0.w),d1
	jmp	ObjCF_Index(pc,d1.w)
; ===========================================================================
; off_A996:
ObjCF_Index:	offsetTable
		offsetTableEntry.w ObjCF_Init		; 0
		offsetTableEntry.w ObjCF_Animate	; 2
; ===========================================================================
; loc_A99A:
ObjCF_Init:
	lea	(ObjB3_SubObjData).l,a1
	jsrto	JmpTo_LoadSubObject_Part3
	move.l	#ObjCF_MapUnc_ADA2,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,1),art_tile(a0)
	move.b	#3,priority(a0)
	jsr	(Adjust2PArtPointer).l
	move.b	#5,mapping_frame(a0)
	move.b	#2,anim(a0)
	move.w	#$10F,d0
	move.w	d0,x_pos(a0)
	move.w	d0,objoff_30(a0)
	move.w	#$15E,d0
	move.w	d0,y_pos(a0)
	move.w	d0,objoff_32(a0)
	rts
; ===========================================================================
; loc_A9E4:
ObjCF_Animate:
	lea	(Ani_objCF).l,a1
	jsrto	JmpTo_AnimateSprite
	bra.w	loc_A90E
