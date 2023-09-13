; ---------------------------------------------------------------------------
; Pseudo-object to do collision with (and initialize?) the special bumpers in CNZ.
; These are the bumpers that are part of the level layout but have object-like collision.
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_173BC:
SpecialCNZBumpers:
	moveq	#0,d0
	move.b	(CNZ_Bumper_routine).w,d0
	move.w	SpecialCNZBumpers_Index(pc,d0.w),d0
	jmp	SpecialCNZBumpers_Index(pc,d0.w)
; ===========================================================================
; off_173CA:
SpecialCNZBumpers_Index: offsetTable
	offsetTableEntry.w SpecialCNZBumpers_Init	; 0
	offsetTableEntry.w SpecialCNZBumpers_Main	; 2
; ===========================================================================
; loc_173CE:
SpecialCNZBumpers_Init:
	addq.b	#2,(CNZ_Bumper_routine).w
	lea	(SpecialCNZBumpers_Act1).l,a1
	tst.b	(Current_Act).w
	beq.s	+
	lea	(SpecialCNZBumpers_Act2).l,a1
+
	move.w	(Camera_X_pos).w,d4
	subq.w	#8,d4
	bhi.s	+
	moveq	#1,d4
	bra.s	+
; ===========================================================================
-
	lea	next_bumper(a1),a1
+
	cmp.w	bumper_x(a1),d4
	bhi.s	-
	move.l	a1,(CNZ_Visible_bumpers_start).w
	move.l	a1,(CNZ_Visible_bumpers_start_P2).w
	addi.w	#$150,d4
	bra.s	+
; ===========================================================================
-
	lea	next_bumper(a1),a1
+
	cmp.w	bumper_x(a1),d4
	bhi.s	-
	move.l	a1,(CNZ_Visible_bumpers_end).w
	move.l	a1,(CNZ_Visible_bumpers_end_P2).w
	move.b	#1,(CNZ_Bumper_UnkFlag).w
	rts
; ===========================================================================
; loc_17422:
SpecialCNZBumpers_Main:
	movea.l	(CNZ_Visible_bumpers_start).w,a1
	move.w	(Camera_X_pos).w,d4
	subq.w	#8,d4
	bhi.s	+
	moveq	#1,d4
	bra.s	+
; ===========================================================================
-
	lea	next_bumper(a1),a1
+
	cmp.w	bumper_x(a1),d4
	bhi.s	-
	bra.s	+
; ===========================================================================
-
	subq.w	#next_bumper,a1
+
	cmp.w	prev_bumper_x(a1),d4
	bls.s	-
	move.l	a1,(CNZ_Visible_bumpers_start).w
	movea.l	(CNZ_Visible_bumpers_end).w,a2
	addi.w	#$150,d4
	bra.s	+
; ===========================================================================
-
	lea	next_bumper(a2),a2
+
	cmp.w	bumper_x(a2),d4
	bhi.s	-
	bra.s	+
; ===========================================================================
-
	subq.w	#next_bumper,a2
+
	cmp.w	prev_bumper_x(a2),d4
	bls.s	-
	move.l	a2,(CNZ_Visible_bumpers_end).w
	tst.w	(Two_player_mode).w
	bne.s	+
	move.l	a1,(CNZ_Visible_bumpers_start_P2).w
	move.l	a2,(CNZ_Visible_bumpers_end_P2).w
	rts
; ===========================================================================
+
	movea.l	(CNZ_Visible_bumpers_start_P2).w,a1
	move.w	(Camera_X_pos_P2).w,d4
	subq.w	#8,d4
	bhi.s	+
	moveq	#1,d4
	bra.s	+
; ===========================================================================
-
	lea	next_bumper(a1),a1
+
	cmp.w	bumper_x(a1),d4
	bhi.s	-
	bra.s	+
; ===========================================================================
-
	subq.w	#next_bumper,a1
+
	cmp.w	prev_bumper_x(a1),d4
	bls.s	-
	move.l	a1,(CNZ_Visible_bumpers_start_P2).w
	movea.l	(CNZ_Visible_bumpers_end_P2).w,a2
	addi.w	#$150,d4
	bra.s	+
; ===========================================================================
-
	lea	next_bumper(a2),a2
+
	cmp.w	bumper_x(a2),d4
	bhi.s	-
	bra.s	+
; ===========================================================================
-
	subq.w	#next_bumper,a2
+
	cmp.w	prev_bumper_x(a2),d4
	bls.s	-
	move.l	a2,(CNZ_Visible_bumpers_end_P2).w
	rts
; ===========================================================================

Check_CNZ_bumpers:
	movea.l	(CNZ_Visible_bumpers_start).w,a1
	movea.l	(CNZ_Visible_bumpers_end).w,a2
	cmpa.w	#MainCharacter,a0
	beq.s	+
	movea.l	(CNZ_Visible_bumpers_start_P2).w,a1
	movea.l	(CNZ_Visible_bumpers_end_P2).w,a2
+
	cmpa.l	a1,a2
	beq.w	return_17578
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	subi.w	#9,d2
	moveq	#0,d5
	move.b	y_radius(a0),d5
	subq.b	#3,d5
	sub.w	d5,d3
    if fixBugs
	cmpi.b	#AniIDSonAni_Duck,anim(a0)	; is Sonic ducking?
    else
	; This logic only works for Sonic, not Tails. Also, it only applies
	; to the last frame of his ducking animation. This is a leftover from
	; Sonic 1, where Sonic's ducking animation only had one frame.
	cmpi.b	#$4D,mapping_frame(a0)	; is Sonic ducking?
    endif
	bne.s	+				; if not, branch
	addi.w	#$C,d3
	moveq	#$A,d5
+
	move.w	#$12,d4
	add.w	d5,d5

CNZ_Bumper_loop:
	move.w	bumper_id(a1),d0
	andi.w	#$E,d0
	lea	byte_17558(pc,d0.w),a3
	moveq	#0,d1
	move.b	(a3)+,d1
	move.w	bumper_x(a1),d0
	sub.w	d1,d0
	sub.w	d2,d0
	bcc.s	loc_17530
	add.w	d1,d1
	add.w	d1,d0
	bcs.s	loc_17536
	bra.w	CNZ_Bumper_next
; ===========================================================================

loc_17530:
	cmp.w	d4,d0
	bhi.w	CNZ_Bumper_next

loc_17536:
	moveq	#0,d1
	move.b	(a3)+,d1
	move.w	bumper_y(a1),d0
	sub.w	d1,d0
	sub.w	d3,d0
	bcc.s	loc_17550
	add.w	d1,d1
	add.w	d1,d0
	bcs.w	loc_17564
	bra.w	CNZ_Bumper_next
; ===========================================================================

loc_17550:
	cmp.w	d5,d0
	bhi.w	CNZ_Bumper_next
	bra.s	loc_17564
; ===========================================================================
byte_17558:
	dc.b $20
	dc.b $20	; 1
	dc.b $20	; 2
	dc.b $20	; 3
	dc.b $40	; 4
	dc.b   8	; 5
	dc.b $40	; 6
	dc.b   8	; 7
	dc.b   8	; 8
	dc.b $40	; 9
	dc.b   8	; 10
	dc.b $40	; 11
	even
; ===========================================================================

loc_17564:
	move.w	(a1),d0
	move.w	off_1757A(pc,d0.w),d0
	jmp	off_1757A(pc,d0.w)
; ===========================================================================

CNZ_Bumper_next:
	lea	next_bumper(a1),a1
	cmpa.l	a1,a2
	bne.w	CNZ_Bumper_loop

return_17578:
	rts
; ===========================================================================
off_1757A:	offsetTable
		offsetTableEntry.w loc_17586	;  0
		offsetTableEntry.w loc_17638	;  2
		offsetTableEntry.w loc_1769E	;  4
		offsetTableEntry.w loc_176F6	;  6
		offsetTableEntry.w loc_1774C	;  8
		offsetTableEntry.w loc_177A4	; $A
; ===========================================================================

loc_17586:
	move.w	bumper_y(a1),d0
	sub.w	y_pos(a0),d0
	neg.w	d0
	cmpi.w	#$20,d0
	blt.s	loc_175A0
	move.w	#$A00,y_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_175A0:
	move.w	bumper_x(a1),d0
	sub.w	x_pos(a0),d0
	neg.w	d0
	cmpi.w	#$20,d0
	blt.s	loc_175BA
	move.w	#$A00,x_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_175BA:
	move.w	bumper_x(a1),d0
	sub.w	x_pos(a0),d0
	cmpi.w	#$20,d0
	blt.s	loc_175CC
	move.w	#$20,d0

loc_175CC:
	add.w	bumper_y(a1),d0
	subq.w	#8,d0
	move.w	y_pos(a0),d1
	addi.w	#$E,d1
	sub.w	d1,d0
	bcc.s	return_175E8
	move.w	#$20,d3
	bsr.s	loc_175EA
	bra.w	loc_177FA
; ===========================================================================

return_175E8:
	rts
; ===========================================================================

loc_175EA:
	move.w	x_vel(a0),d1
	move.w	y_vel(a0),d2
	jsr	(CalcAngle).l
	move.b	d0,(unk_FFDC).w
	sub.w	d3,d0
	mvabs.w	d0,d1
	neg.w	d0
	add.w	d3,d0
	move.b	d0,(unk_FFDD).w
	move.b	d1,(unk_FFDF).w
	cmpi.b	#$38,d1
	blo.s	loc_17618
	move.w	d3,d0

loc_17618:
	move.b	d0,(unk_FFDE).w
	jsr	(CalcSine).l
	muls.w	#-$A00,d1
	asr.l	#8,d1
	move.w	d1,x_vel(a0)
	muls.w	#-$A00,d0
	asr.l	#8,d0
	move.w	d0,y_vel(a0)
	rts
; ===========================================================================

loc_17638:
	move.w	bumper_y(a1),d0
	sub.w	y_pos(a0),d0
	neg.w	d0
	cmpi.w	#$20,d0
	blt.s	loc_17652
	move.w	#$A00,y_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_17652:
	move.w	bumper_x(a1),d0
	sub.w	x_pos(a0),d0
	cmpi.w	#$20,d0
	blt.s	loc_1766A
	move.w	#-$A00,x_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_1766A:
	move.w	bumper_x(a1),d0
	sub.w	x_pos(a0),d0
	neg.w	d0
	cmpi.w	#$20,d0
	blt.s	loc_1767E
	move.w	#$20,d0

loc_1767E:
	add.w	bumper_y(a1),d0
	subq.w	#8,d0
	move.w	y_pos(a0),d1
	addi.w	#$E,d1
	sub.w	d1,d0
	bcc.s	return_1769C
	move.w	#$60,d3
	bsr.w	loc_175EA
	bra.w	loc_177FA
; ===========================================================================

return_1769C:
	rts
; ===========================================================================

loc_1769E:
	move.w	bumper_y(a1),d0
	sub.w	y_pos(a0),d0
	neg.w	d0
	cmpi.w	#8,d0
	blt.s	loc_176B8
	move.w	#$A00,y_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_176B8:
	move.w	bumper_x(a1),d0
	sub.w	x_pos(a0),d0
	cmpi.w	#$40,d0
	blt.s	loc_176D0
	move.w	#-$A00,x_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_176D0:
	neg.w	d0
	cmpi.w	#$40,d0
	blt.s	loc_176E2
	move.w	#$A00,x_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_176E2:
	move.w	#$38,d3
	tst.w	d0
	bmi.s	loc_176EE
	move.w	#$48,d3

loc_176EE:
	bsr.w	loc_175EA
	bra.w	loc_177FA
; ===========================================================================

loc_176F6:
	move.w	bumper_y(a1),d0
	sub.w	y_pos(a0),d0
	cmpi.w	#8,d0
	blt.s	loc_1770E
	move.w	#-$A00,y_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_1770E:
	move.w	bumper_x(a1),d0
	sub.w	x_pos(a0),d0
	cmpi.w	#$40,d0
	blt.s	loc_17726
	move.w	#-$A00,x_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_17726:
	neg.w	d0
	cmpi.w	#$40,d0
	blt.s	loc_17738
	move.w	#$A00,x_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_17738:
	move.w	#$C8,d3
	tst.w	d0
	bmi.s	loc_17744
	move.w	#$B8,d3

loc_17744:
	bsr.w	loc_175EA
	bra.w	loc_177FA
; ===========================================================================

loc_1774C:
	move.w	bumper_x(a1),d0
	sub.w	x_pos(a0),d0
	neg.w	d0
	cmpi.w	#8,d0
	blt.s	loc_17766
	move.w	#$A00,x_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_17766:
	move.w	bumper_y(a1),d0
	sub.w	y_pos(a0),d0
	cmpi.w	#$40,d0
	blt.s	loc_1777E
	move.w	#-$A00,y_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_1777E:
	neg.w	d0
	cmpi.w	#$40,d0
	blt.s	loc_17790
	move.w	#$A00,x_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_17790:
	move.w	#8,d3
	tst.w	d0
	bmi.s	loc_1779C
	move.w	#$F8,d3

loc_1779C:
	bsr.w	loc_175EA
	bra.w	loc_177FA
; ===========================================================================

loc_177A4:
	move.w	bumper_x(a1),d0
	sub.w	x_pos(a0),d0
	cmpi.w	#8,d0
	blt.s	loc_177BC
	move.w	#$A00,x_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_177BC:
	move.w	bumper_y(a1),d0
	sub.w	y_pos(a0),d0
	cmpi.w	#$40,d0
	blt.s	loc_177D4
	move.w	#-$A00,y_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_177D4:
	neg.w	d0
	cmpi.w	#$40,d0
	blt.s	loc_177E6
	move.w	#$A00,x_vel(a0)
	bra.w	loc_177FA
; ===========================================================================

loc_177E6:
	move.w	#$78,d3
	tst.w	d0
	bmi.s	loc_177F2
	move.w	#$88,d3

loc_177F2:
	bsr.w	loc_175EA
	bra.w	loc_177FA
loc_177FA:
	bset	#1,status(a0)
	bclr	#4,status(a0)
	bclr	#5,status(a0)
	clr.b	jumping(a0)
	move.w	#SndID_LargeBumper,d0
	; This line unintentionally acts as a boundary marker for the below
	; bumper data. Changes to this instruction, or the location of
	; `PlaySound`, may cause Casino Night Zone Act 1 to crash. Fix the
	; below bug to prevent this.
	jmp	(PlaySound).l
; ===========================================================================
SpecialCNZBumpers_Act1:
    if fixBugs
	; Sonic Team forgot to start this file with a boundary marker,
	; meaning the game could potentially read past the start of the file
	; and load random bumpers. In a stroke of luck, the above `jmp`
	; instruction happens to resemble a boundary marker well enough to
	; prevent any misbehaviour. However, this is not the case in
	; 'Knuckles in Sonic 2' due to the code being located at a
	; wildly-different address, which necessitated that this bug be fixed
	; properly, like this.
	dc.w	$0000, $0000, $0000
    endif
	BINCLUDE	"level/objects/CNZ 1 bumpers.bin"	; byte_1781A

SpecialCNZBumpers_Act2:
	BINCLUDE	"level/objects/CNZ 2 bumpers.bin"	; byte_1795E
; ===========================================================================

    if gameRevision<2
	nop
    endif
