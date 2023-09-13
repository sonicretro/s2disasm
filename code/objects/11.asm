; ===========================================================================
; ----------------------------------------------------------------------------
; Object 11 - Bridge in Emerald Hill Zone and Hidden Palace Zone
; ----------------------------------------------------------------------------
; OST Variables:
Obj11_child1		= objoff_30	; pointer to first set of bridge segments
Obj11_child2		= objoff_34	; pointer to second set of bridge segments, if applicable

; Sprite_F66C:
Obj11:
	btst	#6,render_flags(a0)	; is this a child sprite object?
	bne.w	+			; if yes, branch
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj11_Index(pc,d0.w),d1
	jmp	Obj11_Index(pc,d1.w)
; ===========================================================================
+	; child sprite objects only need to be drawn
	move.w	#object_display_list_size*3,d0
	bra.w	DisplaySprite3
; ===========================================================================
; off_F68C:
Obj11_Index:	offsetTable
		offsetTableEntry.w Obj11_Init		; 0
		offsetTableEntry.w Obj11_EHZ		; 2
		offsetTableEntry.w Obj11_Display	; 4
		offsetTableEntry.w Obj11_HPZ		; 6
; ===========================================================================
; loc_F694: Obj11_Main:
Obj11_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj11_MapUnc_FC70,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_EHZ_Bridge,2,0),art_tile(a0)
	move.b	#3,priority(a0)
	cmpi.b	#hidden_palace_zone,(Current_Zone).w	; is this an HPZ bridge?
	bne.s	+			; if not, branch
	addq.b	#4,routine(a0)
	move.l	#Obj11_MapUnc_FC28,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HPZ_Bridge,3,0),art_tile(a0)
+
	bsr.w	Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$80,width_pixels(a0)
	move.w	y_pos(a0),d2
	move.w	d2,objoff_3C(a0)
	move.w	x_pos(a0),d3
	lea	subtype(a0),a2	; copy bridge subtype to a2
	moveq	#0,d1
	move.b	(a2),d1		; d1 = subtype
	move.w	d1,d0
	lsr.w	#1,d0
	lsl.w	#4,d0	; (d0 div 2) * 16
	sub.w	d0,d3	; x position of left half
	swap	d1	; store subtype in high word for later
	move.w	#8,d1
	bsr.s	Obj11_MakeBdgSegment
	move.w	sub6_x_pos(a1),d0
	subq.w	#8,d0
	move.w	d0,x_pos(a1)		; center of first subsprite object
	move.l	a1,Obj11_child1(a0)	; pointer to first subsprite object
	swap	d1	; retrieve subtype
	subq.w	#8,d1
	bls.s	+	; branch, if subtype <= 8 (bridge has no more than 8 logs)
	; else, create a second subsprite object for the rest of the bridge
	move.w	d1,d4
	bsr.s	Obj11_MakeBdgSegment
	move.l	a1,Obj11_child2(a0)	; pointer to second subsprite object
	move.w	d4,d0
	add.w	d0,d0
	add.w	d4,d0	; d0*3
	move.w	sub2_x_pos(a1,d0.w),d0
	subq.w	#8,d0
	move.w	d0,x_pos(a1)		; center of second subsprite object
+
	bra.s	Obj11_EHZ

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; sub_F728:
Obj11_MakeBdgSegment:
	jsrto	AllocateObjectAfterCurrent, JmpTo_AllocateObjectAfterCurrent
	bne.s	+	; rts
	_move.b	id(a0),id(a1) ; load obj11
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	render_flags(a0),render_flags(a1)
	bset	#6,render_flags(a1)
	move.b	#$40,mainspr_width(a1)
	move.b	d1,mainspr_childsprites(a1)
	subq.b	#1,d1
	lea	subspr_data(a1),a2 ; starting address for subsprite data

-	move.w	d3,(a2)+	; sub?_x_pos
	move.w	d2,(a2)+	; sub?_y_pos
	move.w	#0,(a2)+	; sub?_mapframe
	addi.w	#$10,d3		; width of a log, x_pos for next log
	dbf	d1,-	; repeat for d1 logs
+
	rts
; End of function Obj11_MakeBdgSegment

; ===========================================================================
; loc_F77A: Obj11_Action:
Obj11_EHZ:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	+
	tst.b	objoff_3E(a0)
	beq.s	loc_F7BC
	subq.b	#4,objoff_3E(a0)
	bra.s	loc_F7B8
+
	andi.b	#p2_standing,d0
	beq.s	++
	move.b	objoff_3F(a0),d0
	sub.b	objoff_3B(a0),d0
	beq.s	++
	bcc.s	+
	addq.b	#1,objoff_3F(a0)
	bra.s	++
; ---------------------------------------------------------------------------
+
	subq.b	#1,objoff_3F(a0)
+
	cmpi.b	#$40,objoff_3E(a0)
	beq.s	loc_F7B8
	addq.b	#4,objoff_3E(a0)

loc_F7B8:
	bsr.w	Obj11_Depress

loc_F7BC:
	moveq	#0,d1
	move.b	subtype(a0),d1
	lsl.w	#3,d1
	move.w	d1,d2
	addq.w	#8,d1
	add.w	d2,d2
	moveq	#8,d3
	move.w	x_pos(a0),d4
	bsr.w	sub_F872

; loc_F7D4:
Obj11_Unload:
	; this is essentially MarkObjGone, except we need to delete our subsprite objects as well
	tst.w	(Two_player_mode).w	; is it two player mode?
	beq.s	+			; if not, branch
	rts
; ---------------------------------------------------------------------------
+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	+
	rts
; ---------------------------------------------------------------------------
+	; delete first subsprite object
	movea.l	Obj11_child1(a0),a1 ; a1=object
	bsr.w	DeleteObject2
	cmpi.b	#8,subtype(a0)
	bls.s	+	; if bridge has more than 8 logs, delete second subsprite object
	movea.l	Obj11_child2(a0),a1 ; a1=object
	bsr.w	DeleteObject2
+
	bra.w	DeleteObject
; ===========================================================================
; loc_F80C: BranchTo_DisplaySprite:
Obj11_Display:
	bra.w	DisplaySprite
; ===========================================================================
; loc_F810: Obj11_Action_HPZ:
Obj11_HPZ:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	+
	tst.b	objoff_3E(a0)
	beq.s	loc_F852
	subq.b	#4,objoff_3E(a0)
	bra.s	loc_F84E
; ===========================================================================
+
	andi.b	#p2_standing,d0
	beq.s	++
	move.b	objoff_3F(a0),d0
	sub.b	objoff_3B(a0),d0
	beq.s	++
	bcc.s	+
	addq.b	#1,objoff_3F(a0)
	bra.s	++
; ===========================================================================
+
	subq.b	#1,objoff_3F(a0)
+
	cmpi.b	#$40,objoff_3E(a0)
	beq.s	loc_F84E
	addq.b	#4,objoff_3E(a0)

loc_F84E:
	bsr.w	Obj11_Depress

loc_F852:
	moveq	#0,d1
	move.b	subtype(a0),d1
	lsl.w	#3,d1
	move.w	d1,d2
	addq.w	#8,d1
	add.w	d2,d2
	moveq	#8,d3
	move.w	x_pos(a0),d4
	bsr.w	sub_F872
	bsr.w	sub_F912
	bra.w	Obj11_Unload

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_F872:
	lea	(Sidekick).w,a1 ; a1=character
	moveq	#p2_standing_bit,d6
	moveq	#objoff_3B,d5
	movem.l	d1-d4,-(sp)
	bsr.s	+
	movem.l	(sp)+,d1-d4
	lea	(MainCharacter).w,a1 ; a1=character
	subq.b	#1,d6
	moveq	#objoff_3F,d5
+
	btst	d6,status(a0)
	beq.s	loc_F8F0
	btst	#1,status(a1)
	bne.s	+
	moveq	#0,d0
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	bmi.s	+
	cmp.w	d2,d0
	blo.s	++
+
	bclr	#3,status(a1)
	bclr	d6,status(a0)
	moveq	#0,d4
	rts
; ===========================================================================
+
	lsr.w	#4,d0
	move.b	d0,(a0,d5.w)
	movea.l	Obj11_child1(a0),a2
	cmpi.w	#8,d0
	blo.s	+
	movea.l	Obj11_child2(a0),a2 ; a2=object
	subi_.w	#8,d0
+
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	move.w	sub2_y_pos(a2,d0.w),d0
	subq.w	#8,d0
	moveq	#0,d1
	move.b	y_radius(a1),d1
	sub.w	d1,d0
	move.w	d0,y_pos(a1)
	moveq	#0,d4
	rts
; ===========================================================================

loc_F8F0:
	move.w	d1,-(sp)
	jsrto	PlatformObject11_cont, JmpTo_PlatformObject11_cont
	move.w	(sp)+,d1
	btst	d6,status(a0)
	beq.s	+	; rts
	moveq	#0,d0
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	add.w	d1,d0
	lsr.w	#4,d0
	move.b	d0,(a0,d5.w)
+
	rts
; End of function sub_F872


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_F912:
	moveq	#0,d0
	tst.w	(MainCharacter+x_vel).w
	bne.s	+
	move.b	(Vint_runcount+3).w,d0
	andi.w	#$1C,d0
	lsr.w	#1,d0
+
	moveq	#0,d2
	move.b	byte_F950+1(pc,d0.w),d2
	swap	d2
	move.b	byte_F950(pc,d0.w),d2
	moveq	#0,d0
	tst.w	(Sidekick+x_vel).w
	bne.s	+
	move.b	(Vint_runcount+3).w,d0
	andi.w	#$1C,d0
	lsr.w	#1,d0
+
	moveq	#0,d6
	move.b	byte_F950+1(pc,d0.w),d6
	swap	d6
	move.b	byte_F950(pc,d0.w),d6
	bra.s	+
; ===========================================================================
byte_F950:
	dc.b   1,  2
	dc.b   1,  2	; 2
	dc.b   1,  2	; 4
	dc.b   1,  2	; 6
	dc.b   0,  1	; 8
	dc.b   0,  0	; 10
	dc.b   0,  0	; 12
	dc.b   0,  1	; 14
; ===========================================================================
+
	moveq	#-2,d3
	moveq	#-2,d4
	move.b	status(a0),d0
	andi.b	#p1_standing,d0
	beq.s	+
	move.b	objoff_3F(a0),d3
+
	move.b	status(a0),d0
	andi.b	#p2_standing,d0
	beq.s	+
	move.b	objoff_3B(a0),d4
+
	movea.l	Obj11_child1(a0),a1
	lea	sub9_mapframe+next_subspr(a1),a2
	lea	sub2_mapframe(a1),a1
	moveq	#0,d1
	move.b	subtype(a0),d1
	subq.b	#1,d1
	moveq	#0,d5

-	moveq	#0,d0
	subq.w	#1,d3
	cmp.b	d3,d5
	bne.s	+
	move.w	d2,d0
+
	addq.w	#2,d3
	cmp.b	d3,d5
	bne.s	+
	move.w	d2,d0
+
	subq.w	#1,d3
	subq.w	#1,d4
	cmp.b	d4,d5
	bne.s	+
	move.w	d6,d0
+
	addq.w	#2,d4
	cmp.b	d4,d5
	bne.s	+
	move.w	d6,d0
+
	subq.w	#1,d4
	cmp.b	d3,d5
	bne.s	+
	swap	d2
	move.w	d2,d0
	swap	d2
+
	cmp.b	d4,d5
	bne.s	+
	swap	d6
	move.w	d6,d0
	swap	d6
+
	move.b	d0,(a1)
	addq.w	#1,d5
	addq.w	#6,a1
	cmpa.w	a2,a1
	bne.s	+
	movea.l	Obj11_child2(a0),a1 ; a1=object
	lea	sub2_mapframe(a1),a1
+	dbf	d1,-

	rts
; End of function sub_F912

; ===========================================================================

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; subroutine to make the bridge push down where Sonic or Tails walks over
; loc_F9E8:
Obj11_Depress:
	move.b	objoff_3E(a0),d0
	jsrto	CalcSine, JmpTo_CalcSine
	move.w	d0,d4
	lea	(byte_FB28).l,a4
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#4,d0
	moveq	#0,d3
	move.b	objoff_3F(a0),d3
	move.w	d3,d2
	add.w	d0,d3
	moveq	#0,d5
	lea	(Obj11_DepressionOffsets-$80).l,a5
	move.b	(a5,d3.w),d5
	andi.w	#$F,d3
	lsl.w	#4,d3
	lea	(a4,d3.w),a3
	movea.l	Obj11_child1(a0),a1
	lea	sub9_y_pos+next_subspr(a1),a2
	lea	sub2_y_pos(a1),a1

-	moveq	#0,d0
	move.b	(a3)+,d0
	addq.w	#1,d0
	mulu.w	d5,d0
	mulu.w	d4,d0
	swap	d0
	add.w	objoff_3C(a0),d0
	move.w	d0,(a1)
	addq.w	#6,a1
	cmpa.w	a2,a1
	bne.s	+
	movea.l	Obj11_child2(a0),a1 ; a1=object
	lea	sub2_y_pos(a1),a1
+	dbf	d2,-

	moveq	#0,d0
	move.b	subtype(a0),d0
	moveq	#0,d3
	move.b	objoff_3F(a0),d3
	addq.b	#1,d3
	sub.b	d0,d3
	neg.b	d3
	bmi.s	++	; rts
	move.w	d3,d2
	lsl.w	#4,d3
	lea	(a4,d3.w),a3
	adda.w	d2,a3
	subq.w	#1,d2
	bcs.s	++	; rts

-	moveq	#0,d0
	move.b	-(a3),d0
	addq.w	#1,d0
	mulu.w	d5,d0
	mulu.w	d4,d0
	swap	d0
	add.w	objoff_3C(a0),d0
	move.w	d0,(a1)
	addq.w	#6,a1
	cmpa.w	a2,a1
	bne.s	+
	movea.l	Obj11_child2(a0),a1 ; a1=object
	lea	sub2_y_pos(a1),a1
+	dbf	d2,-
+
	rts
; ===========================================================================
; seems to be bridge piece vertical position offset data
Obj11_DepressionOffsets: ; byte_FA98:
	dc.b   2,  4,  6,  8,  8,  6,  4,  2,  0,  0,  0,  0,  0,  0,  0,  0; 16
	dc.b   2,  4,  6,  8, $A,  8,  6,  4,  2,  0,  0,  0,  0,  0,  0,  0; 32
	dc.b   2,  4,  6,  8, $A, $A,  8,  6,  4,  2,  0,  0,  0,  0,  0,  0; 48
	dc.b   2,  4,  6,  8, $A, $C, $A,  8,  6,  4,  2,  0,  0,  0,  0,  0; 64
	dc.b   2,  4,  6,  8, $A, $C, $C, $A,  8,  6,  4,  2,  0,  0,  0,  0; 80
	dc.b   2,  4,  6,  8, $A, $C, $E, $C, $A,  8,  6,  4,  2,  0,  0,  0; 96
	dc.b   2,  4,  6,  8, $A, $C, $E, $E, $C, $A,  8,  6,  4,  2,  0,  0; 112
	dc.b   2,  4,  6,  8, $A, $C, $E,$10, $E, $C, $A,  8,  6,  4,  2,  0; 128
	dc.b   2,  4,  6,  8, $A, $C, $E,$10,$10, $E, $C, $A,  8,  6,  4,  2; 144

; something else important for bridge depression to work (phase? bridge size adjustment?)
byte_FB28:
	dc.b $FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 16
	dc.b $B5,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 32
	dc.b $7E,$DB,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 48
	dc.b $61,$B5,$EC,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 64
	dc.b $4A,$93,$CD,$F3,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 80
	dc.b $3E,$7E,$B0,$DB,$F6,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0; 96
	dc.b $38,$6D,$9D,$C5,$E4,$F8,$FF,  0,  0,  0,  0,  0,  0,  0,  0,  0; 112
	dc.b $31,$61,$8E,$B5,$D4,$EC,$FB,$FF,  0,  0,  0,  0,  0,  0,  0,  0; 128
	dc.b $2B,$56,$7E,$A2,$C1,$DB,$EE,$FB,$FF,  0,  0,  0,  0,  0,  0,  0; 144
	dc.b $25,$4A,$73,$93,$B0,$CD,$E1,$F3,$FC,$FF,  0,  0,  0,  0,  0,  0; 160
	dc.b $1F,$44,$67,$88,$A7,$BD,$D4,$E7,$F4,$FD,$FF,  0,  0,  0,  0,  0; 176
	dc.b $1F,$3E,$5C,$7E,$98,$B0,$C9,$DB,$EA,$F6,$FD,$FF,  0,  0,  0,  0; 192
	dc.b $19,$38,$56,$73,$8E,$A7,$BD,$D1,$E1,$EE,$F8,$FE,$FF,  0,  0,  0; 208
	dc.b $19,$38,$50,$6D,$83,$9D,$B0,$C5,$D8,$E4,$F1,$F8,$FE,$FF,  0,  0; 224
	dc.b $19,$31,$4A,$67,$7E,$93,$A7,$BD,$CD,$DB,$E7,$F3,$F9,$FE,$FF,  0; 240
	dc.b $19,$31,$4A,$61,$78,$8E,$A2,$B5,$C5,$D4,$E1,$EC,$F4,$FB,$FE,$FF; 256

	even
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj11_MapUnc_FC28:	include "mappings/sprite/obj11_a.asm"

; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj11_MapUnc_FC70:	include "mappings/sprite/obj11_b.asm"

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

    if ~~removeJmpTos
; sub_FC88:
JmpTo_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo_PlatformObject11_cont ; JmpTo
	jmp	(PlatformObject11_cont).l
; sub_FC94:
JmpTo_CalcSine ; JmpTo
	jmp	(CalcSine).l

	align 4
    endif