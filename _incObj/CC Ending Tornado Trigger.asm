; ----------------------------------------------------------------------------
; Object CC - Trigger for rescue plane and birds from ending sequence
; ----------------------------------------------------------------------------
; Sprite_A3C8:
ObjCC:
	jsrto	JmpTo_ObjB2_Animate_Pilot
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCC_Index(pc,d0.w),d1
	jmp	ObjCC_Index(pc,d1.w)
; ===========================================================================
; loc_A3DA:
ObjCC_Index:	offsetTable
		offsetTableEntry.w ObjCC_Init	; 0
		offsetTableEntry.w ObjCC_Main	; 2
; ===========================================================================
; loc_A3DE:
ObjCC_Init:
	lea	(ObjB2_SubObjData).l,a1
	jsrto	JmpTo_LoadSubObject_Part3
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	move.b	#4,mapping_frame(a0)
	move.b	#1,anim(a0)
+
	move.w	#-$10,x_pos(a0)
	move.w	#$C0,y_pos(a0)
	move.w	#$100,x_vel(a0)
	move.w	#-$80,y_vel(a0)
	move.b	#$14,objoff_35(a0)
	move.b	#3,priority(a0)
	move.w	#4,(Ending_VInt_Subrout).w
	move.l	a0,-(sp)
	lea	(MapEng_EndingTailsPlane).l,a0
	cmpi.w	#4,(Ending_Routine).w
	bne.s	+
	lea	(MapEng_EndingSonicPlane).l,a0
+
	lea	(Chunk_Table).l,a1
	move.w	#make_art_tile(ArtTile_ArtNem_EndingFinalTornado,0,1),d0
	jsrto	JmpTo_EniDec
	movea.l	(sp)+,a0 ; load 0bj address
	move.w	#$C00,(Normal_palette_line3).w
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================
; loc_A456:
ObjCC_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjCC_State2_States(pc,d0.w),d1
	jsr	ObjCC_State2_States(pc,d1.w)
	jmpto	JmpTo5_DisplaySprite
; ===========================================================================
ObjCC_State2_States: offsetTable
	offsetTableEntry.w loc_A474	;  0
	offsetTableEntry.w loc_A4B6	;  2
	offsetTableEntry.w loc_A5A6	;  4
	offsetTableEntry.w loc_A6C6	;  6
	offsetTableEntry.w loc_A7DE	;  8
	offsetTableEntry.w loc_A83E	; $A
; ===========================================================================

loc_A474:
	cmpi.w	#$A0,x_pos(a0)
	beq.s	+
	jsrto	JmpTo2_ObjectMove
-
	lea	(Ani_objB2_a).l,a1
	jmpto	JmpTo_AnimateSprite
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$480,objoff_3C(a0)
	btst	#6,(Graphics_Flags).w
	beq.s	+
	move.w	#$3D0,objoff_3C(a0)
+
	move.w	#$40,objoff_32(a0)
	st.b	(CutScene+objoff_34).w
	clr.w	x_vel(a0)
	clr.w	y_vel(a0)
	bra.s	-
; ===========================================================================

loc_A4B6:
	bsr.w	sub_ABBA
	bsr.w	sub_A524
	subq.w	#1,objoff_3C(a0)
	bmi.s	+
	bra.s	-
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#2,objoff_3C(a0)
	clr.w	objoff_32(a0)
	clr.b	mapping_frame(a0)
	cmpi.w	#2,(Ending_Routine).w
	beq.s	+
	move.b	#7,mapping_frame(a0)
	cmpi.w	#4,(Ending_Routine).w
	bne.s	+
	move.b	#$18,mapping_frame(a0)
+
	clr.b	anim(a0)
	clr.b	anim_frame(a0)
	clr.b	anim_frame_duration(a0)
	move.l	#ObjCF_MapUnc_ADA2,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	jsr	(Adjust2PArtPointer).l
	subi.w	#$14,x_pos(a0)
	addi.w	#$14,y_pos(a0)
	bra.w	sub_A58C

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_A524:
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	(Ending_Routine).w,d0
	move.w	off_A534(pc,d0.w),d0
	jmp	off_A534(pc,d0.w)
; End of function sub_A524

; ===========================================================================
off_A534:	offsetTable
		offsetTableEntry.w loc_A53A	; 0
		offsetTableEntry.w loc_A55C	; 2
		offsetTableEntry.w loc_A582	; 4
; ===========================================================================

loc_A53A:
	move.w	y_pos(a0),d0
	subi.w	#$1C,d0
-
	move.w	d0,y_pos(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.l	#(1<<24)|(0<<16)|(AniIDSonAni_Wait<<8)|(AniIDSonAni_Wait<<0),mapping_frame(a1)
	move.w	#$100,anim_frame_duration(a1)
	rts
; ===========================================================================

loc_A55C:
	tst.w	objoff_32(a0)
	beq.s	+
	subq.w	#1,objoff_32(a0)
	addi.l	#$8000,x_pos(a1)
	addq.w	#1,y_pos(a1)
	rts
; ===========================================================================
+
	move.w	#$C0,x_pos(a1)
	move.w	#$90,y_pos(a1)
	rts
; ===========================================================================

loc_A582:
	move.w	y_pos(a0),d0
	subi.w	#$18,d0
	bra.s	-

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_A58C:
	tst.b	(Super_Sonic_flag).w
	bne.w	return_A38C

loc_A594:
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	#$200,x_pos(a1)
	move.w	#0,y_pos(a1)
	rts
; End of function sub_A58C

; ===========================================================================

loc_A5A6:
	bsr.s	sub_A58C
	subq.w	#1,objoff_3C(a0)
	bpl.s	+	; rts
	move.w	#2,objoff_3C(a0)
	move.w	objoff_32(a0),d0
	cmpi.w	#$1C,d0
	bhs.s	++
	addq.w	#1,objoff_32(a0)
	move.w	(Ending_Routine).w,d1
	move.w	off_A5FC(pc,d1.w),d1
	lea	off_A5FC(pc,d1.w),a1
	move.b	(a1,d0.w),mapping_frame(a0)
	add.w	d0,d0
	add.w	d0,d0
	move.l	word_A656(pc,d0.w),d1
	move.w	d1,y_pos(a0)
	swap	d1
	move.w	d1,x_pos(a0)
+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$60,objoff_3C(a0)
	clr.b	objoff_31(a0)
	clr.w	objoff_32(a0)
	rts
; ===========================================================================
off_A5FC:	offsetTable
		offsetTableEntry.w byte_A602	; 0
		offsetTableEntry.w byte_A61E	; 2
		offsetTableEntry.w byte_A63A	; 4
byte_A602:
	dc.b   7,  7,  7,  7,  8,  8,  8,  8,  8,  8,  8,  9,  9,  9, $A, $A
	dc.b  $A, $B, $B, $B, $B, $B, $B, $B, $B, $B, $B, $B; 16
byte_A61E:
	dc.b   0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  2,  2,  2,  3,  3
	dc.b   3,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4; 16
byte_A63A:
	dc.b $18,$18,$18,$18,$19,$19,$19,$19,$19,$19,$19,  9,  9,  9, $A, $A
	dc.b  $A, $B, $B, $B, $B, $B, $B, $B, $B, $B, $B, $B; 16
	even
word_A656:
	dc.w   $A0,  $70,  $B0,  $70,  $B6,  $71,  $BC,  $72
	dc.w   $C4,  $74,  $C8,  $75,  $CA,  $76,  $CC,  $77; 8
	dc.w   $CE,  $78,  $D0,  $79,  $D2,  $7A,  $D4,  $7B; 16
	dc.w   $D6,  $7C,  $D9,  $7E,  $DC,  $81,  $DE,  $84; 24
	dc.w   $E1,  $87,  $E4,  $8B,  $E7,  $8F,  $EC,  $94; 32
	dc.w   $F0,  $99,  $F5,  $9D,  $F9,  $A4, $100,  $AC; 40
	dc.w  $108,  $B8, $112,  $C4, $11F,  $D3, $12C,  $FA; 48
; ===========================================================================

loc_A6C6:
	subq.w	#1,objoff_3C(a0)
	bmi.s	loc_A720
	tst.b	(Super_Sonic_flag).w
	beq.s	+	; rts
	subq.b	#1,objoff_31(a0)
	bpl.s	+	; rts
	addq.b	#3,objoff_31(a0)
	move.w	objoff_32(a0),d0
	addq.w	#4,objoff_32(a0)
	cmpi.w	#$78,d0
	bhs.s	+	; rts
	cmpi.w	#$C,d0
	blo.s	++
	bsr.w	loc_A594
	move.l	word_A766(pc,d0.w),d1
	move.w	d1,y_pos(a0)
	swap	d1
	move.w	d1,x_pos(a0)
	lsr.w	#2,d0
	move.b	byte_A748(pc,d0.w),mapping_frame(a0)
+
	rts
; ===========================================================================
+
	move.l	word_A766(pc,d0.w),d0
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	d0,y_pos(a1)
	swap	d0
	move.w	d0,x_pos(a1)
	rts
; ===========================================================================

loc_A720:
	addq.b	#2,routine_secondary(a0)
	clr.w	objoff_3C(a0)
	clr.w	objoff_32(a0)
	lea	(ChildObject_AD6E).l,a2
	jsrto	JmpTo_LoadChildObject
	tst.b	(Super_Sonic_flag).w
	bne.w	return_A38C
	lea	(ChildObject_AD6A).l,a2
	jmpto	JmpTo_LoadChildObject
; ===========================================================================
byte_A748:
	dc.b $12,$12,$12,$12,$12,$12,$12,$13,$13,$13,$13,$13,$13,$14,$14,$14
	dc.b $14,$15,$15,$15,$16,$16,$16,$16,$16,$16,$16,$16,$16,  0; 16
	even
word_A766:
	dc.w   $C0, $90	; 1
	dc.w   $B0, $91	; 3
	dc.w   $A8, $92	; 5
	dc.w   $9B, $96	; 7
	dc.w   $99, $98	; 9
	dc.w   $98, $99	; 11
	dc.w   $99, $9A	; 13
	dc.w   $9B, $9C	; 15
	dc.w   $9F, $9E	; 17
	dc.w   $A4, $A0	; 19
	dc.w   $AC, $A2	; 21
	dc.w   $B7, $A5	; 23
	dc.w   $C4, $A8	; 25
	dc.w   $D3, $AB	; 27
	dc.w   $DE, $AE	; 29
	dc.w   $E8, $B0	; 31
	dc.w   $EF, $B2	; 33
	dc.w   $F4, $B5	; 35
	dc.w   $F9, $B8	; 37
	dc.w   $FC, $BB	; 39
	dc.w   $FE, $BE	; 41
	dc.w   $FF, $C0	; 43
	dc.w  $100, $C2	; 45
	dc.w  $101, $C5	; 47
	dc.w  $102, $C8	; 49
	dc.w  $102, $CC	; 51
	dc.w  $101, $D1	; 53
	dc.w   $FD, $D7	; 55
	dc.w   $F9, $DE	; 57
	dc.w   $F9,$118	; 59
; ===========================================================================

loc_A7DE:
	bsr.w	loc_A594
	subq.w	#1,objoff_3C(a0)
	bpl.s	+	; rts
	move.w	#2,objoff_3C(a0)
	move.w	objoff_32(a0),d0
	cmpi.w	#$1C,d0
	bhs.s	++
	addq.w	#4,objoff_32(a0)
	lea	word_A822(pc,d0.w),a1
	move.w	(a1)+,d0
	add.w	d0,(Horiz_Scroll_Buf).w
	move.w	(a1)+,d0
	add.w	d0,(Vscroll_Factor_FG).w
+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	bset	#status.npc.p1_standing,status(a0)
	clr.b	objoff_31(a0)
	clr.w	objoff_32(a0)
	rts
; ===========================================================================
word_A822:
	dc.w  -$3A
	dc.w   $88	; 1
	dc.w   -$C	; 2
	dc.w   $22	; 3
	dc.w	-8	; 4
	dc.w   $10	; 5
	dc.w	-4	; 6
	dc.w	 8	; 7
	dc.w	-2	; 8
	dc.w	 4	; 9
	dc.w	-1	; 10
	dc.w	 2	; 11
	dc.w	-1	; 12
	dc.w	 2	; 13
; ===========================================================================

loc_A83E:
	tst.b	(Super_Sonic_flag).w
	beq.w	return_A38C
	move.b	#$17,mapping_frame(a0)
	subq.b	#1,objoff_31(a0)
	bpl.s	+	; rts
	addq.b	#3,objoff_31(a0)
	move.w	objoff_32(a0),d0
	cmpi.w	#$20,d0
	bhs.s	+	; rts
	addq.w	#4,objoff_32(a0)
	move.l	word_A874(pc,d0.w),d1
	move.w	d1,y_pos(a0)
	swap	d1
	move.w	d1,x_pos(a0)
+
	rts
; ===========================================================================
word_A874:
	dc.w   $60,$88	; 1
	dc.w   $50,$68	; 3
	dc.w   $44,$46	; 5
	dc.w   $3C,$36	; 7
	dc.w   $36,$2A	; 9
	dc.w   $33,$24	; 11
	dc.w   $31,$20	; 13
	dc.w   $30,$1E	; 15
