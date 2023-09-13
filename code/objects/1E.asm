; ===========================================================================
; ----------------------------------------------------------------------------
; Object 1E - Spin tube from CPZ
; ----------------------------------------------------------------------------
; Sprite_2259C:
Obj1E:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj1E_Index(pc,d0.w),d1
	jsr	Obj1E_Index(pc,d1.w)
	move.b	objoff_2C(a0),d0
	add.b	objoff_36(a0),d0
	beq.w	JmpTo_MarkObjGone3
	rts

    if removeJmpTos
JmpTo_MarkObjGone3 ; JmpTo
	jmp	(MarkObjGone3).l
    endif
; ===========================================================================
; JmpTbl_225B8: Obj1E_States:
Obj1E_Index:	offsetTable
		offsetTableEntry.w Obj1E_Init	; 0
		offsetTableEntry.w Obj1E_Main	; 2
; ===========================================================================
word_225BC:
	dc.w   $A0	; 0
	dc.w  $100	; 2
	dc.w  $120	; 4
; ===========================================================================
; loc_225C2: LoadSubtype_1E:
Obj1E_Init:
	addq.b	#2,routine(a0)
	move.b	subtype(a0),d0
	add.w	d0,d0
	andi.w	#6,d0
	move.w	word_225BC(pc,d0.w),objoff_2A(a0)
; loc_225D6:
Obj1E_Main:
	lea	(MainCharacter).w,a1 ; a1=character
	lea	objoff_2C(a0),a4
	bsr.s	+
	lea	(Sidekick).w,a1 ; a1=character
	lea	objoff_36(a0),a4
+
	moveq	#0,d0
	move.b	(a4),d0
	move.w	Obj1E_Modes(pc,d0.w),d0
	jmp	Obj1E_Modes(pc,d0.w)
; ===========================================================================
; off_225F4:
Obj1E_Modes:	offsetTable
		offsetTableEntry.w loc_225FC	; 0
		offsetTableEntry.w loc_2271A	; 2
		offsetTableEntry.w loc_227FE	; 4
		offsetTableEntry.w loc_2286A	; 6
; ===========================================================================

loc_225FC:
	tst.w	(Debug_placement_mode).w
	bne.w	return_22718
	move.w	objoff_2A(a0),d2
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	cmp.w	d2,d0
	bhs.w	return_22718
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	cmpi.w	#$80,d1
	bhs.w	return_22718
	cmpi.b	#$20,anim(a1)
	beq.w	return_22718

	moveq	#0,d3
	cmpi.w	#$A0,d2
	beq.s	+
	moveq	#8,d3
	cmpi.w	#$120,d2
	beq.s	+
	moveq	#4,d3
	neg.w	d0
	addi.w	#$100,d0
+
	cmpi.w	#$80,d0
	blo.s	loc_2267E
	moveq	#0,d2
	move.b	subtype(a0),d0
	lsr.w	#2,d0
	andi.w	#$F,d0
	move.b	byte_2266E(pc,d0.w),d2
	cmpi.b	#2,d2
	bne.s	loc_22688
	move.b	(Timer_second).w,d2
	andi.b	#1,d2
	bra.s	loc_22688
; ===========================================================================
byte_2266E:
	dc.b   2
	dc.b   2	; 1
	dc.b   2	; 2
	dc.b   2	; 3
	dc.b   2	; 4
	dc.b   2	; 5
	dc.b   2	; 6
	dc.b   2	; 7
	dc.b   2	; 8
	dc.b   2	; 9
	dc.b   0	; 10
	dc.b   2	; 11
	dc.b   0	; 12
	dc.b   1	; 13
	dc.b   2	; 14
	dc.b   1	; 15
	even
; ===========================================================================

loc_2267E:
	moveq	#2,d2
	cmpi.w	#$40,d1
	bhs.s	loc_22688
	moveq	#3,d2

loc_22688:
	move.b	d2,1(a4)
	add.w	d3,d2
	add.w	d2,d2
	andi.w	#$1E,d2
	lea	off_22980(pc),a2
	adda.w	(a2,d2.w),a2
	move.w	(a2)+,4(a4)
	subq.w	#4,4(a4)
	move.w	(a2)+,d4
	add.w	x_pos(a0),d4
	move.w	d4,x_pos(a1)
	move.w	(a2)+,d5
	add.w	y_pos(a0),d5
	move.w	d5,y_pos(a1)
	move.l	a2,6(a4)
	move.w	(a2)+,d4
	add.w	x_pos(a0),d4
	move.w	(a2)+,d5
	add.w	y_pos(a0),d5
	addq.b	#2,(a4)
	move.b	#$81,obj_control(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	move.w	#$800,inertia(a1)
	move.w	#0,x_vel(a1)
	move.w	#0,y_vel(a1)
	bclr	#5,status(a0)
	bclr	#5,status(a1)
	bset	#1,status(a1)
	move.b	#0,jumping(a1)
	bclr	#high_priority_bit,art_tile(a1)
	move.w	#$800,d2
	bsr.w	loc_22902
	move.w	#SndID_Roll,d0
	jsr	(PlaySound).l

return_22718:
	rts
; ===========================================================================

loc_2271A:
	subq.b	#1,2(a4)
	bpl.s	Obj1E_MoveCharacter
	movea.l	6(a4),a2
	move.w	(a2)+,d4
	add.w	x_pos(a0),d4
	move.w	d4,x_pos(a1)
	move.w	(a2)+,d5
	add.w	y_pos(a0),d5
	move.w	d5,y_pos(a1)
	tst.b	1(a4)
	bpl.s	+
	subq.w	#8,a2
+
	move.l	a2,6(a4)
	subq.w	#4,4(a4)
	beq.s	loc_22784
	move.w	(a2)+,d4
	add.w	x_pos(a0),d4
	move.w	(a2)+,d5
	add.w	y_pos(a0),d5
	move.w	#$800,d2
	bra.w	loc_22902
; ===========================================================================
; update the position of Sonic/Tails in the CPZ tube
; loc_2275E:
Obj1E_MoveCharacter:
	move.l	x_pos(a1),d2
	move.l	y_pos(a1),d3
	move.w	x_vel(a1),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d2
	move.w	y_vel(a1),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d2,x_pos(a1)
	move.l	d3,y_pos(a1)
	rts
; ===========================================================================

loc_22784:
	cmpi.b	#4,1(a4)
	bhs.s	loc_227A6
	move.b	subtype(a0),d0
	andi.w	#$FC,d0
	add.b	1(a4),d0
	move.b	#4,1(a4)
	move.b	byte_227BE(pc,d0.w),d0
	bne.w	loc_22892

loc_227A6:
	andi.w	#$7FF,y_pos(a1)
	move.b	#6,(a4)
	clr.b	obj_control(a1)
	move.w	#SndID_SpindashRelease,d0
	jmp	(PlaySound).l
; ===========================================================================
byte_227BE:
	dc.b   2,  1,  0,  0
	dc.b  -1,  3,  0,  0
	dc.b   4, -2,  0,  0
	dc.b  -3, -4,  0,  0
	dc.b  -5, -5,  0,  0
	dc.b   7,  6,  0,  0
	dc.b  -7, -6,  0,  0
	dc.b   8,  9,  0,  0
	dc.b  -8, -9,  0,  0
	dc.b  11, 10,  0,  0
	dc.b  12,  0,  0,  0
	dc.b -11,-10,  0,  0
	dc.b -12,  0,  0,  0
	dc.b   0, 13,  0,  0
	dc.b -13, 14,  0,  0
	dc.b   0,-14,  0,  0
; ===========================================================================

loc_227FE:
	subq.b	#1,2(a4)
	bpl.s	Obj1E_MoveCharacter_2
	movea.l	6(a4),a2
	move.w	(a2)+,d4
	move.w	d4,x_pos(a1)
	move.w	(a2)+,d5
	move.w	d5,y_pos(a1)
	tst.b	1(a4)
	bpl.s	loc_2281C
	subq.w	#8,a2

loc_2281C:
	move.l	a2,6(a4)
	subq.w	#4,4(a4)
	beq.s	loc_22858
	move.w	(a2)+,d4
	move.w	(a2)+,d5
	move.w	#$800,d2
	bra.w	loc_22902
; ===========================================================================
; update the position of Sonic/Tails in the CPZ tube
; loc_22832:
Obj1E_MoveCharacter_2:
	move.l	x_pos(a1),d2
	move.l	y_pos(a1),d3
	move.w	x_vel(a1),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d2
	move.w	y_vel(a1),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d2,x_pos(a1)
	move.l	d3,y_pos(a1)
	rts
; ===========================================================================

loc_22858:
	andi.w	#$7FF,y_pos(a1)
	clr.b	(a4)
	move.w	#SndID_SpindashRelease,d0
	jmp	(PlaySound).l
; ===========================================================================

loc_2286A:
	move.w	objoff_2A(a0),d2
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	cmp.w	d2,d0
	bhs.w	loc_2288E
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	cmpi.w	#$80,d1
	bhs.w	loc_2288E
	rts
; ===========================================================================

loc_2288E:
	clr.b	(a4)
	rts
; ===========================================================================

loc_22892:
	bpl.s	loc_228C4
	neg.b	d0
	move.b	#-4,1(a4)
	add.w	d0,d0
	lea	(off_22E88).l,a2
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d0
	subq.w	#4,d0
	move.w	d0,4(a4)
	lea	(a2,d0.w),a2
	move.w	(a2)+,d4
	move.w	d4,x_pos(a1)
	move.w	(a2)+,d5
	move.w	d5,y_pos(a1)
	subq.w	#8,a2
	bra.s	loc_228E4
; ===========================================================================

loc_228C4:
	add.w	d0,d0
	lea	(off_22E88).l,a2
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,4(a4)
	subq.w	#4,4(a4)
	move.w	(a2)+,d4
	move.w	d4,x_pos(a1)
	move.w	(a2)+,d5
	move.w	d5,y_pos(a1)

loc_228E4:
	move.l	a2,6(a4)
	move.w	(a2)+,d4
	move.w	(a2)+,d5
	move.w	#$800,d2
	bsr.w	loc_22902
	move.w	#SndID_Roll,d0
	jsr	(PlaySound).l
	addq.b	#2,(a4)
	rts
; ===========================================================================

loc_22902:
	moveq	#0,d0
	move.w	d2,d3
	move.w	d4,d0
	sub.w	x_pos(a1),d0
	bge.s	+
	neg.w	d0
	neg.w	d2
+
	moveq	#0,d1
	move.w	d5,d1
	sub.w	y_pos(a1),d1
	bge.s	+
	neg.w	d1
	neg.w	d3
+
	cmp.w	d0,d1
	blo.s	loc_22952
	moveq	#0,d1
	move.w	d5,d1
	sub.w	y_pos(a1),d1
	swap	d1
	divs.w	d3,d1
	moveq	#0,d0
	move.w	d4,d0
	sub.w	x_pos(a1),d0
	beq.s	+
	swap	d0
	divs.w	d1,d0
+
	move.w	d0,x_vel(a1)
	move.w	d3,y_vel(a1)
	abs.w	d1
	move.w	d1,2(a4)
	rts
; ===========================================================================

loc_22952:
	moveq	#0,d0
	move.w	d4,d0
	sub.w	x_pos(a1),d0
	swap	d0
	divs.w	d2,d0
	moveq	#0,d1
	move.w	d5,d1
	sub.w	y_pos(a1),d1
	beq.s	+
	swap	d1
	divs.w	d0,d1
+
	move.w	d1,y_vel(a1)
	move.w	d2,x_vel(a1)
	abs.w	d0
	move.w	d0,2(a4)
	rts
; ===========================================================================
obj1E67Size macro {INTLABEL}
__LABEL__ label *
	dc.w __LABEL___End-__LABEL__-2
	endm
; -------------------------------------------------------------------------------
; spin tube data - entry/exit
; -------------------------------------------------------------------------------
; off_22980:
	include	"misc/obj1E_a.asm"
; -------------------------------------------------------------------------------
; spin tube data - main tube
; -------------------------------------------------------------------------------
; off_22E88:
	include	"misc/obj1E_b.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo_MarkObjGone3 ; JmpTo
	jmp	(MarkObjGone3).l

	align 4
    endif
