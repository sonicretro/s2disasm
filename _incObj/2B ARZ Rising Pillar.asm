; ----------------------------------------------------------------------------
; Object 2B - Rising pillar from ARZ
; ----------------------------------------------------------------------------
; Sprite_25A5A:
Obj2B:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj2B_Index(pc,d0.w),d1
	jmp	Obj2B_Index(pc,d1.w)
; ===========================================================================
; off_25A68:
Obj2B_Index:	offsetTable
		offsetTableEntry.w Obj2B_Init	; 0
		offsetTableEntry.w Obj2B_Main	; 2
		offsetTableEntry.w loc_25B8E	; 4
; ===========================================================================
; loc_25A6E:
Obj2B_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj2B_MapUnc_25C6E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,1,0),art_tile(a0)
	jsrto	JmpTo25_Adjust2PArtPointer
    if fixBugs
	ori.b	#1<<render_flags.level_fg|1<<render_flags.explicit_height,render_flags(a0)
	move.b	#$1C,width_pixels(a0)
	move.b	#$20,y_radius(a0)
    else
	; This should use the accurate height check and larger size values, since
	; right now it vanishes whilst partially on-screen.
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#$18,y_radius(a0)
    endif
	move.b	#4,priority(a0)
; loc_25A9C:
Obj2B_Main:
	move.w	x_pos(a0),-(sp)
	bsr.w	loc_25B28
    if fixBugs
	moveq	#$10+$B,d1
    else
	; Read above.
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
    endif
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	(sp)+,d4
	jsrto	JmpTo8_SolidObject
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.w	loc_25ACE
	jmpto	JmpTo16_MarkObjGone
; ===========================================================================

loc_25ACE:
	lea	(word_25BBE).l,a4
	lea	(byte_25BB0).l,a2
	addq.b	#7,mapping_frame(a0)
	bsr.w	loc_25BF6
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	bsr.s	loc_25AF6
	lea	(Sidekick).w,a1 ; a1=character
	addq.b	#1,d6
	bsr.s	loc_25AF6
	bra.w	loc_25B8E
; ===========================================================================

loc_25AF6:
	bclr	d6,status(a0)
	beq.s	return_25B26
	bset	#status.player.rolling,status(a1)
	move.b	#$E,y_radius(a1)
	move.b	#7,x_radius(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	bset	#status.player.in_air,status(a1)
	bclr	#status.player.on_object,status(a1)
	move.b	#2,routine(a1)

return_25B26:
	rts
; ===========================================================================

loc_25B28:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_25B36(pc,d0.w),d1
	jmp	off_25B36(pc,d1.w)
; ===========================================================================
off_25B36:	offsetTable
		offsetTableEntry.w loc_25B3C	; 0
		offsetTableEntry.w loc_25B66	; 2
		offsetTableEntry.w return_25B64	; 4
; ===========================================================================

loc_25B3C:
	tst.w	(Debug_placement_mode).w
	bne.s	return_25B64
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_25B4C
	lea	(Sidekick).w,a1 ; a1=character

loc_25B4C:
	move.w	x_pos(a0),d0
	sub.w	x_pos(a1),d0
	bcc.s	loc_25B58
	neg.w	d0

loc_25B58:
	cmpi.w	#$40,d0
	bhs.s	return_25B64
	move.b	#2,routine_secondary(a0)

return_25B64:

	rts
; ===========================================================================

loc_25B66:
	subq.w	#1,objoff_34(a0)
	bcc.s	return_25B8C
	move.w	#3,objoff_34(a0)
	subq.w	#4,y_pos(a0)
	addq.b	#4,y_radius(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#6,mapping_frame(a0)
	bne.s	return_25B8C
	move.b	#4,routine_secondary(a0)

return_25B8C:
	rts
; ===========================================================================

loc_25B8E:

	tst.b	objoff_3F(a0)
	beq.s	loc_25B9A
	subq.b	#1,objoff_3F(a0)
	bra.s	loc_25BA4
; ===========================================================================

loc_25B9A:
	jsrto	JmpTo12_ObjectMove
	addi.w	#$18,y_vel(a0)

loc_25BA4:
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	JmpTo28_DeleteObject
	jmpto	JmpTo16_DisplaySprite

    if removeJmpTos
JmpTo28_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
byte_25BB0:
	dc.b   0
	dc.b   0	; 1
	dc.b   0	; 2
	dc.b   0	; 3
	dc.b   4	; 4
	dc.b   4	; 5
	dc.b   8	; 6
	dc.b   8	; 7
	dc.b  $C	; 8
	dc.b  $C	; 9
	dc.b $10	; 10
	dc.b $10	; 11
	dc.b $14	; 12
	dc.b $14	; 13
	even
word_25BBE:
	dc.w -$200,-$200,$200,-$200	; 0
	dc.w -$1C0,-$1C0,$1C0,-$1C0	; 4
	dc.w -$180,-$180,$180,-$180	; 8
	dc.w -$140,-$140,$140,-$140	; 12
	dc.w -$100,-$100,$100,-$100	; 16
	dc.w  -$C0, -$C0, $C0, -$C0	; 20
	dc.w  -$80, -$80, $80, -$80	; 24
; ===========================================================================

loc_25BF6:
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	add.w	d0,d0
	movea.l	mappings(a0),a3
	adda.w	(a3,d0.w),a3
	move.w	(a3)+,d1
	subq.w	#1,d1
	bset	#render_flags.static_mappings,render_flags(a0)
	_move.b	id(a0),d4
	move.b	render_flags(a0),d5
	movea.l	a0,a1
	bra.s	loc_25C24
; ===========================================================================

loc_25C1C:
	jsrto	JmpTo10_AllocateObjectAfterCurrent
	bne.s	loc_25C64
	addq.w	#8,a3

loc_25C24:
	move.b	#4,routine(a1)
	_move.b	d4,id(a1) ; load obj2B?
	move.l	a3,mappings(a1)
	move.b	d5,render_flags(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	priority(a0),priority(a1)
	move.b	width_pixels(a0),width_pixels(a1)
	move.w	(a4)+,x_vel(a1)
	move.w	(a4)+,y_vel(a1)
	move.b	(a2)+,objoff_3F(a1)
	dbf	d1,loc_25C1C

loc_25C64:
	move.w	#SndID_SlowSmash,d0
	jmp	(PlaySound).l
