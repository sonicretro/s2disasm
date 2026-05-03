; ----------------------------------------------------------------------------
; Object 84 - Pinball mode enable/disable
; (used in Casino Night Zone to determine when Sonic should stay in a ball)
; ----------------------------------------------------------------------------
; Sprite_2115C:
Obj84:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj84_Index(pc,d0.w),d1
	jsr	Obj84_Index(pc,d1.w)
	jmp	(MarkObjGone3).l
; ===========================================================================
; off_21170: Obj84_States:
Obj84_Index:	offsetTable
		offsetTableEntry.w Obj84_Init	; 0
		offsetTableEntry.w Obj84_MainX	; 2
		offsetTableEntry.w Obj84_MainY	; 4
; ===========================================================================
; loc_21176:
Obj84_Init:
	addq.b	#2,routine(a0) ; => Obj84_MainX
	move.l	#Obj03_MapUnc_1FFB8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,0,0),art_tile(a0)
	jsrto	JmpTo12_Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#5,priority(a0)
	move.b	subtype(a0),d0
	btst	#2,d0
	beq.s	Obj84_Init_CheckX
	addq.b	#2,routine(a0) ; => Obj84_MainY
	andi.w	#7,d0
	move.b	d0,mapping_frame(a0)
	andi.w	#3,d0
	add.w	d0,d0
	move.w	word_211E8(pc,d0.w),objoff_32(a0)
	move.w	y_pos(a0),d1
	lea	(MainCharacter).w,a1 ; a1=character
	cmp.w	y_pos(a1),d1
	bhs.s	+
	move.b	#1,objoff_34(a0)
+
	lea	(Sidekick).w,a1 ; a1=character
	cmp.w	y_pos(a1),d1
	bhs.s	+
	move.b	#1,objoff_35(a0)
+
	bra.w	Obj84_MainY
; ===========================================================================
word_211E8:
	dc.w   $20
	dc.w   $40	; 1
	dc.w   $80	; 2
	dc.w  $100	; 3
; ===========================================================================
; loc_211F0:
Obj84_Init_CheckX:
	andi.w	#3,d0
	move.b	d0,mapping_frame(a0)
	add.w	d0,d0
	move.w	word_211E8(pc,d0.w),objoff_32(a0)
	move.w	x_pos(a0),d1
	lea	(MainCharacter).w,a1 ; a1=character
	cmp.w	x_pos(a1),d1
	bhs.s	+
	move.b	#1,objoff_34(a0)
+
	lea	(Sidekick).w,a1 ; a1=character
	cmp.w	x_pos(a1),d1
	bhs.s	Obj84_MainX
	move.b	#1,objoff_35(a0)

; loc_21224:
Obj84_MainX:

	tst.w	(Debug_placement_mode).w
	bne.s	return_21284
	move.w	x_pos(a0),d1
	lea	objoff_34(a0),a2 ; a2=object
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	+
	lea	(Sidekick).w,a1 ; a1=character
	cmpi.w	#4,(Tails_CPU_routine).w	; TailsCPU_Flying
	beq.s	return_21284

+	tst.b	(a2)+
	bne.s	Obj84_MainX_Alt
	cmp.w	x_pos(a1),d1
	bhi.s	return_21284
	move.b	#1,-1(a2)
	move.w	y_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	y_pos(a1),d4
	cmp.w	d2,d4
	blo.s	return_21284
	cmp.w	d3,d4
	bhs.s	return_21284
	btst	#render_flags.x_flip,render_flags(a0)
	bne.s	+
	move.b	#1,pinball_mode(a1) ; enable must-roll "pinball mode"
	bra.s	loc_212C4
; ---------------------------------------------------------------------------
+	move.b	#0,pinball_mode(a1) ; disable pinball mode

return_21284:
	rts
; ===========================================================================
; loc_21286:
Obj84_MainX_Alt:
	cmp.w	x_pos(a1),d1
	bls.s	return_21284
	move.b	#0,-1(a2)
	move.w	y_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	y_pos(a1),d4
	cmp.w	d2,d4
	blo.s	return_21284
	cmp.w	d3,d4
	bhs.s	return_21284
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	move.b	#1,pinball_mode(a1)
	bra.s	loc_212C4
; ---------------------------------------------------------------------------
+	move.b	#0,pinball_mode(a1)
	rts
; ===========================================================================

loc_212C4:
	btst	#status.player.rolling,status(a1)
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+	bset	#status.player.rolling,status(a1)
	move.b	#$E,y_radius(a1)
	move.b	#7,x_radius(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	addq.w	#5,y_pos(a1)
	move.w	#SndID_Roll,d0
	jsr	(PlaySound).l
	rts

; ===========================================================================
; loc_212F6:
Obj84_MainY:

	tst.w	(Debug_placement_mode).w
	bne.s	return_21350
	move.w	y_pos(a0),d1
	lea	objoff_34(a0),a2 ; a2=object
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	+
	lea	(Sidekick).w,a1 ; a1=character
    if fixBugs
	; AI Tails can behave rather strangely if he happens to be flying into
	; an autoroll object, most visible in Casino Night.
	cmpi.w	#4,(Tails_CPU_routine).w	; TailsCPU_Flying
	beq.s	return_21350
    endif
+
	tst.b	(a2)+
	bne.s	Obj84_MainY_Alt
	cmp.w	y_pos(a1),d1
	bhi.s	return_21350
	move.b	#1,-1(a2)
	move.w	x_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	x_pos(a1),d4
	cmp.w	d2,d4
	blo.s	return_21350
	cmp.w	d3,d4
	bhs.s	return_21350
	btst	#render_flags.x_flip,render_flags(a0)
	bne.s	+
	move.b	#1,pinball_mode(a1)
	bra.w	loc_212C4
; ---------------------------------------------------------------------------
+	move.b	#0,pinball_mode(a1)

return_21350:
	rts
; ===========================================================================
; loc_21352:
Obj84_MainY_Alt:
	cmp.w	y_pos(a1),d1
	bls.s	return_21350
	move.b	#0,-1(a2)
	move.w	x_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	x_pos(a1),d4
	cmp.w	d2,d4
	blo.s	return_21350
	cmp.w	d3,d4
	bhs.s	return_21350
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	move.b	#1,pinball_mode(a1)
	bra.w	loc_212C4
; ---------------------------------------------------------------------------
+	move.b	#0,pinball_mode(a1)
	rts
