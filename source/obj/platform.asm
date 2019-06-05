; ----------------------------------------------------------------------------
; Object 18 - Stationary floating platform from ARZ, EHZ and HTZ
; ----------------------------------------------------------------------------
; Sprite_104AC:
Obj18:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj18_Index(pc,d0.w),d1
	jmp	Obj18_Index(pc,d1.w)
; ===========================================================================
; off_104BA:
Obj18_Index:	offsetTable
		offsetTableEntry.w Obj18_Init			; 0
		offsetTableEntry.w loc_1056A			; 2
		offsetTableEntry.w BranchTo3_DeleteObject	; 4
		offsetTableEntry.w loc_105A8			; 6
		offsetTableEntry.w loc_105D4			; 8
; ===========================================================================
;word_104C4:
Obj18_InitData:
	;    width_pixels
	;	 frame
	dc.b $20, 0
	dc.b $20, 1
	dc.b $20, 2
	dc.b $40, 3
	dc.b $30, 4
; ===========================================================================
; loc_104CE:
Obj18_Init:
	addq.b	#2,routine(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#3,d0
	andi.w	#$E,d0
	lea	Obj18_InitData(pc,d0.w),a2
	move.b	(a2)+,width_pixels(a0)
	move.b	(a2)+,mapping_frame(a0)
	move.l	#Obj18_MapUnc_107F6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj18_MapUnc_1084E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)
+
	bsr.w	Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.w	y_pos(a0),objoff_2C(a0)
	move.w	y_pos(a0),objoff_34(a0)
	move.w	x_pos(a0),objoff_32(a0)
	move.w	#$80,angle(a0)
	tst.b	subtype(a0)
	bpl.s	++
	addq.b	#6,routine(a0)
	andi.b	#$F,subtype(a0)
	move.b	#$30,y_radius(a0)
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	+
	move.b	#$28,y_radius(a0)
+
	bset	#4,render_flags(a0)
	bra.w	loc_105D4
; ===========================================================================
+
	andi.b	#$F,subtype(a0)

loc_1056A:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	+
	tst.b	objoff_38(a0)
	beq.s	++
	subq.b	#4,objoff_38(a0)
	bra.s	++
; ===========================================================================
+
	cmpi.b	#$40,objoff_38(a0)
	beq.s	+
	addq.b	#4,objoff_38(a0)
+
	move.w	x_pos(a0),-(sp)
	bsr.w	sub_10638
	bsr.w	sub_1061E
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	moveq	#8,d3
	move.w	(sp)+,d4
	jsrto	(PlatformObject).l, JmpTo_PlatformObject
	bra.s	loc_105B0
; ===========================================================================

loc_105A8:
	bsr.w	sub_10638
	bsr.w	sub_1061E

loc_105B0:
	tst.w	(Two_player_mode).w
	beq.s	+
	bra.w	DisplaySprite
; ===========================================================================
+
	move.w	objoff_32(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	BranchTo3_DeleteObject
	bra.w	DisplaySprite
; ===========================================================================

BranchTo3_DeleteObject 
	bra.w	DeleteObject
; ===========================================================================

loc_105D4:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	+
	tst.b	objoff_38(a0)
	beq.s	++
	subq.b	#4,objoff_38(a0)
	bra.s	++
; ===========================================================================
+
	cmpi.b	#$40,objoff_38(a0)
	beq.s	+
	addq.b	#4,objoff_38(a0)
+
	move.w	x_pos(a0),-(sp)
	bsr.w	sub_10638
	bsr.w	sub_1061E
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	(sp)+,d4
	jsrto	(SolidObject).l, JmpTo_SolidObject
	bra.s	loc_105B0

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_1061E:
	move.b	objoff_38(a0),d0
	jsrto	(CalcSine).l, JmpTo3_CalcSine
	move.w	#$400,d1
	muls.w	d1,d0
	swap	d0
	add.w	objoff_2C(a0),d0
	move.w	d0,y_pos(a0)
	rts
; End of function sub_1061E


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_10638:
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	add.w	d0,d0
	move.w	Obj18_Behaviours(pc,d0.w),d1
	jmp	Obj18_Behaviours(pc,d1.w)
; End of function sub_10638

; ===========================================================================
; off_1064C:
Obj18_Behaviours: offsetTable
	offsetTableEntry.w return_10668	;  0
	offsetTableEntry.w loc_1067A	;  1
	offsetTableEntry.w loc_106C0	;  2
	offsetTableEntry.w loc_106D8	;  3
	offsetTableEntry.w loc_10702	;  4
	offsetTableEntry.w loc_1066A	;  5
	offsetTableEntry.w loc_106B0	;  6
	offsetTableEntry.w loc_10778	;  7
	offsetTableEntry.w loc_107A4	;  8
	offsetTableEntry.w return_10668	;  9
	offsetTableEntry.w loc_107BC	; $A
	offsetTableEntry.w loc_107D6	; $B
	offsetTableEntry.w loc_106A2	; $C
	offsetTableEntry.w loc_10692	; $D
; ===========================================================================

return_10668:
	rts
; ===========================================================================

loc_1066A:
	move.w	objoff_32(a0),d0
	move.b	angle(a0),d1
	neg.b	d1
	addi.b	#$40,d1
	bra.s	loc_10686
; ===========================================================================

loc_1067A:
	move.w	objoff_32(a0),d0
	move.b	angle(a0),d1
	subi.b	#$40,d1

loc_10686:
	ext.w	d1
	add.w	d1,d0
	move.w	d0,x_pos(a0)
	bra.w	loc_107EE
; ===========================================================================

loc_10692:
	move.w	objoff_34(a0),d0
	move.b	(Oscillating_Data+$C).w,d1
	neg.b	d1
	addi.b	#$30,d1
	bra.s	loc_106CC
; ===========================================================================

loc_106A2:
	move.w	objoff_34(a0),d0
	move.b	(Oscillating_Data+$C).w,d1
	subi.b	#$30,d1
	bra.s	loc_106CC
; ===========================================================================

loc_106B0:
	move.w	objoff_34(a0),d0
	move.b	angle(a0),d1
	neg.b	d1
	addi.b	#$40,d1
	bra.s	loc_106CC
; ===========================================================================

loc_106C0:
	move.w	objoff_34(a0),d0
	move.b	angle(a0),d1
	subi.b	#$40,d1

loc_106CC:
	ext.w	d1
	add.w	d1,d0
	move.w	d0,objoff_2C(a0)
	bra.w	loc_107EE
; ===========================================================================

loc_106D8:
	tst.w	objoff_3A(a0)
	bne.s	loc_106F0
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	+	; rts
	move.w	#$1E,objoff_3A(a0)
/
	rts
; ===========================================================================

loc_106F0:
	subq.w	#1,objoff_3A(a0)
	bne.s	-	; rts
	move.w	#$20,objoff_3A(a0)
	addq.b	#1,subtype(a0)
	rts
; ===========================================================================

loc_10702:
	tst.w	objoff_3A(a0)
	beq.s	loc_10730
	subq.w	#1,objoff_3A(a0)
	bne.s	loc_10730
	bclr	#p1_standing_bit,status(a0)
	beq.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	sub_1075E
+
	bclr	#p2_standing_bit,status(a0)
	beq.s	+
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	sub_1075E
+
	move.b	#6,routine(a0)

loc_10730:
	move.l	objoff_2C(a0),d3
	move.w	y_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d3,objoff_2C(a0)
	addi.w	#$38,y_vel(a0)
	move.w	(Camera_Max_Y_pos_now).w,d0
	addi.w	#$120,d0
	cmp.w	objoff_2C(a0),d0
	bhs.s	+	; rts
	move.b	#4,routine(a0)
+
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_1075E:
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#2,routine(a1)
	move.w	y_vel(a0),y_vel(a1)
	rts
; End of function sub_1075E

; ===========================================================================

loc_10778:
	tst.w	objoff_3A(a0)
	bne.s	loc_10798
	lea	(ButtonVine_Trigger).w,a2
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#4,d0
	tst.b	(a2,d0.w)
	beq.s	+	; rts
	move.w	#$3C,objoff_3A(a0)
/
	rts
; ===========================================================================

loc_10798:
	subq.w	#1,objoff_3A(a0)
	bne.s	-	; rts
	addq.b	#1,subtype(a0)
	rts
; ===========================================================================

loc_107A4:
	subq.w	#2,objoff_2C(a0)
	move.w	objoff_34(a0),d0
	subi.w	#$200,d0
	cmp.w	objoff_2C(a0),d0
	bne.s	+	; rts
	clr.b	subtype(a0)
+
	rts
; ===========================================================================

loc_107BC:
	move.w	objoff_34(a0),d0
	move.b	angle(a0),d1
	subi.b	#$40,d1
	ext.w	d1
	asr.w	#1,d1
	add.w	d1,d0
	move.w	d0,objoff_2C(a0)
	bra.w	loc_107EE
; ===========================================================================

loc_107D6:
	move.w	objoff_34(a0),d0
	move.b	angle(a0),d1
	neg.b	d1
	addi.b	#$40,d1
	ext.w	d1
	asr.w	#1,d1
	add.w	d1,d0
	move.w	d0,objoff_2C(a0)

loc_107EE:
	move.b	(Oscillating_Data+$18).w,angle(a0)
	rts
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj18_MapUnc_107F6:	BINCLUDE "mappings/sprite/obj18_a.bin"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj18_MapUnc_1084E:	BINCLUDE "mappings/sprite/obj18_b.bin"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo3_CalcSine 
	jmp	(CalcSine).l
JmpTo_PlatformObject 
	jmp	(PlatformObject).l
JmpTo_SolidObject 
	jmp	(SolidObject).l

	align 4
    endif
