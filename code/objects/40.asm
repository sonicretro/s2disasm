; ===========================================================================
; ----------------------------------------------------------------------------
; Object 40 - Pressure spring from CPZ, ARZ, and MCZ (the red "diving board" springboard)
; ----------------------------------------------------------------------------
; Sprite_26370:
Obj40:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj40_Index(pc,d0.w),d1
	jsr	Obj40_Index(pc,d1.w)
	jmpto	MarkObjGone, JmpTo17_MarkObjGone
; ===========================================================================
; off_26382:
Obj40_Index:	offsetTable
		offsetTableEntry.w Obj40_Init	; 0
		offsetTableEntry.w Obj40_Main	; 2
; ---------------------------------------------------------------------------
; it seems this object's strength was once controlled by subtype
; these would be applied to the player's y_vel
; word_26386:
Obj40_Strengths:
	dc.w -$400	; 0
	dc.w -$A00	; 2
	; inaccessible
	dc.w -$800	; 4
; ===========================================================================
; loc_2638C:
Obj40_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj40_MapUnc_265F4,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_LeverSpring,0,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo26_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#$1C,width_pixels(a0)
	move.b	#4,priority(a0)
	bset	#7,status(a0)
	move.b	subtype(a0),d0
	andi.w	#2,d0		; there is enough data for this to be capped at 4
	move.w	Obj40_Strengths(pc,d0.w),objoff_30(a0)	; this is never read
; loc_263C8:
Obj40_Main:
	lea	(Ani_obj40).l,a1
	jsrto	AnimateSprite, JmpTo6_AnimateSprite
	move.w	#$27,d1
	move.w	#8,d2
	move.w	x_pos(a0),d4
	lea	Obj40_SlopeData_DiagUp(pc),a2
	tst.b	mapping_frame(a0)
	beq.s	+
	lea	Obj40_SlopeData_Straight(pc),a2
+
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	jsrto	SlopedSolid_SingleCharacter, JmpTo_SlopedSolid_SingleCharacter
	btst	#p1_standing_bit,status(a0)
	beq.s	+
	bsr.s	loc_2641E
+
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	moveq	#p2_standing_bit,d6
	jsrto	SlopedSolid_SingleCharacter, JmpTo_SlopedSolid_SingleCharacter
	btst	#p2_standing_bit,status(a0)
	beq.s	+	; rts
	bsr.s	loc_2641E
+
	rts
; ===========================================================================

loc_2641E:
	btst	#0,status(a0)
	bne.s	loc_26436
	move.w	x_pos(a0),d0
	subi.w	#$10,d0
	cmp.w	x_pos(a1),d0
	blo.s	loc_26446
	rts
; ===========================================================================

loc_26436:
	move.w	x_pos(a0),d0
	addi.w	#$10,d0
	cmp.w	x_pos(a1),d0
	bhs.s	loc_26446
	rts
; ===========================================================================

loc_26446:
	cmpi.b	#1,anim(a0)
	beq.s	loc_26456
	move.w	#(1<<8)|(0<<0),anim(a0)
	rts
; ===========================================================================

loc_26456:
	tst.b	mapping_frame(a0)
	beq.s	loc_2645E
	rts
; ===========================================================================

loc_2645E:
	move.w	x_pos(a0),d0
	subi.w	#$1C,d0
	sub.w	x_pos(a1),d0
	neg.w	d0
	btst	#0,status(a0)
	beq.s	loc_2647A
	not.w	d0
    if fixBugs
	addi.w	#2*$1C,d0
    else
	; This should be 2*$1C instead of $27. As is, this makes it
	; impossible to get as high of a launch from flipped pressure springs
	; as you can for unflipped ones.
	addi.w	#$27,d0
    endif

loc_2647A:
	tst.w	d0
	bpl.s	loc_26480
	moveq	#0,d0

loc_26480:
	lea	(byte_26550).l,a3
	move.b	(a3,d0.w),d0
	move.w	#-$400,y_vel(a1)
	sub.b	d0,y_vel(a1)
	bset	#0,status(a1)
	btst	#0,status(a0)
	bne.s	loc_264AA
	bclr	#0,status(a1)
	neg.b	d0

loc_264AA:
	mvabs.w	x_vel(a1),d1
	cmpi.w	#$400,d1
	blo.s	loc_264BC
	sub.b	d0,x_vel(a1)

loc_264BC:
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#AniIDSonAni_Spring,anim(a1)
	move.b	#2,routine(a1)
	move.b	#0,spindash_flag(a1)
	move.b	subtype(a0),d0
	btst	#0,d0
	beq.s	loc_2651E
	move.w	#1,inertia(a1)
	move.b	#1,flip_angle(a1)
	move.b	#AniIDSonAni_Walk,anim(a1)
	move.b	#1,flips_remaining(a1)
	move.b	#8,flip_speed(a1)
	btst	#1,d0
	bne.s	loc_2650E
	move.b	#3,flips_remaining(a1)

loc_2650E:
	btst	#0,status(a1)
	beq.s	loc_2651E
	neg.b	flip_angle(a1)
	neg.w	inertia(a1)

loc_2651E:
	andi.b	#$C,d0
	cmpi.b	#4,d0
	bne.s	loc_26534
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)

loc_26534:
	cmpi.b	#8,d0
	bne.s	loc_26546
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)

loc_26546:
	move.w	#SndID_Spring,d0
	jmp	(PlaySound).l
; ===========================================================================
byte_26550:
	dc.b   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	dc.b   0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1; 16
	dc.b   1,  1,  1,  1,  1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  2,  2; 32
	dc.b   3,  3,  3,  3,  3,  3,  4,  4,  0,  0,  0,  0,  0,  0,  0,  0; 48
	dc.b   0,  0,  0,  0,  0,  0,  0,  0; 64
;byte_26598:
Obj40_SlopeData_DiagUp:
	dc.b   8,  8,  8,  8,  8,  8,  8,  9, $A, $B, $C, $D, $E, $F,$10,$10
	dc.b $11,$12,$13,$14,$14,$15,$15,$16,$17,$18,$18,$18,$18,$18,$18,$18; 16
	dc.b $18,$18,$18,$18,$18,$18,$18,$18; 32
;byte_265C0:
Obj40_SlopeData_Straight:
	dc.b   8,  8,  8,  8,  8,  8,  8,  9, $A, $B, $C, $C, $C, $C, $D, $D
	dc.b  $D, $D, $D, $D, $E, $E, $F, $F,$10,$10,$10,$10, $F, $F, $E, $E; 16
	dc.b  $D, $D, $D, $D, $D, $D, $D, $D; 32
	even

; animation script
; off_265E8:
Ani_obj40:	offsetTable
		offsetTableEntry.w byte_265EC	; 0
		offsetTableEntry.w byte_265EF	; 1
byte_265EC:	dc.b  $F,  0,$FF
	rev02even
byte_265EF:	dc.b   3,  1,  0,$FD,  0
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj40_MapUnc_265F4:	include "mappings/sprite/obj40.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo17_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo6_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo26_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo_SlopedSolid_SingleCharacter ; JmpTo
	jmp	(SlopedSolid_SingleCharacter).l

	align 4
    endif
