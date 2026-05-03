; ----------------------------------------------------------------------------
; Object 77 - Bridge from MCZ
; ----------------------------------------------------------------------------
; Sprite_28F88:
Obj77:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj77_Index(pc,d0.w),d1
	jmp	Obj77_Index(pc,d1.w)
; ===========================================================================
; off_28F96:
Obj77_Index:	offsetTable
		offsetTableEntry.w Obj77_Init	; 0
		offsetTableEntry.w Obj77_Main	; 2
; ===========================================================================
; loc_28F9A:
Obj77_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj77_MapUnc_29064,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MCZGateLog,3,0),art_tile(a0)
	jsrto	JmpTo40_Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$80,width_pixels(a0)
; loc_28FBC:
Obj77_Main:
	tst.b	objoff_34(a0)
	bne.s	+
	lea	(ButtonVine_Trigger).w,a2
	moveq	#0,d0
	move.b	subtype(a0),d0
	btst	#0,(a2,d0.w)
	beq.s	+
	move.b	#1,objoff_34(a0)
	bchg	#0,anim(a0)
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.s	+
	move.w	#SndID_DoorSlam,d0
	jsr	(PlaySound).l
+
	lea	(Ani_obj77).l,a1
	jsr	(AnimateSprite).l
	tst.b	mapping_frame(a0)
	bne.s	Obj77_DropCharacters
	move.w	#$4B,d1
	move.w	#8,d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	x_pos(a0),d4
	jsrto	JmpTo20_SolidObject
	jmpto	JmpTo23_MarkObjGone
; ===========================================================================

; Check if the characters are standing on it. If a character is standing on the
; bridge, the "standing on object" flag is cleared so that it falls.

; loc_2901A:
Obj77_DropCharacters:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	+++
	move.b	d0,d1
	andi.b	#p1_standing,d0
	beq.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#status.player.on_object,status(a1)
+
	andi.b	#p2_standing,d1
	beq.s	+
	lea	(Sidekick).w,a1 ; a1=character
	bclr	#status.player.on_object,status(a1)
+
	andi.b	#~standing_mask,status(a0)
+
	jmpto	JmpTo23_MarkObjGone
