; ===========================================================================
; ----------------------------------------------------------------------------
; Object 43 - Sliding spike obstacle thing from OOZ
; ----------------------------------------------------------------------------
; Sprite_23E40:
Obj43:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj43_Index(pc,d0.w),d1
	jmp	Obj43_Index(pc,d1.w)
; ===========================================================================
; off_23E4E:
Obj43_Index:	offsetTable
		offsetTableEntry.w Obj43_Init	; 0
		offsetTableEntry.w loc_23F0A	; 2
		offsetTableEntry.w loc_23F5C	; 4
; ---------------------------------------------------------------------------
byte_23E54:
	dc.b   0
	dc.b $68	; 1
	dc.b   0	; 2
	dc.b   0	; 3
	dc.b   0	; 4
	dc.b   0	; 5
	dc.b   1	; 6
	dc.b $E8	; 7
	dc.b $FF	; 8
	dc.b $E8	; 9
	dc.b   0	; 10
	dc.b $18	; 11
	dc.b   1	; 12
	dc.b $A8	; 13
	dc.b $FF	; 14
	dc.b $A8	; 15
	dc.b $FF	; 16
	dc.b $D8	; 17
	even
; ===========================================================================
; loc_23E66:
Obj43_Init:
	addq.b	#2,routine(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpikyThing,2,1),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo19_Adjust2PArtPointer
	moveq	#0,d1
	move.b	subtype(a0),d1
	lea	byte_23E54(pc,d1.w),a2
	move.b	(a2)+,d1
	movea.l	a0,a1
	bra.s	loc_23EA8
; ===========================================================================

loc_23E84:
	jsrto	AllocateObjectAfterCurrent, JmpTo8_AllocateObjectAfterCurrent
	bne.s	loc_23ED4
	_move.b	id(a0),id(a1) ; load obj43
	move.b	#4,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#1,objoff_36(a1)

loc_23EA8:
	move.l	#Obj43_MapUnc_23FE0,mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#4,priority(a1)
	move.b	#$18,width_pixels(a1)
	move.b	#$A5,collision_flags(a1)
	move.w	x_pos(a1),objoff_30(a1)

loc_23ED4:
	dbf	d1,loc_23E84
	move.l	a0,objoff_3C(a1)
	move.l	a1,objoff_3C(a0)
	moveq	#0,d1
	move.b	(a2)+,d1
	move.w	objoff_30(a0),d0
	sub.w	d1,d0
	move.w	d0,objoff_32(a0)
	move.w	d0,objoff_32(a1)
	add.w	d1,d0
	add.w	d1,d0
	move.w	d0,objoff_34(a0)
	move.w	d0,objoff_34(a1)
	move.w	(a2)+,d0
	add.w	d0,x_pos(a0)
	move.w	(a2)+,d0
	add.w	d0,x_pos(a1)

loc_23F0A:
	bsr.s	loc_23F66
	move.w	objoff_32(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bls.s	JmpTo13_DisplaySprite
	move.w	objoff_34(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	loc_23F36

JmpTo13_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
; ===========================================================================

loc_23F36:
	movea.l	objoff_3C(a0),a1 ; a1=object
	cmpa.l	a0,a1
	beq.s	loc_23F44
	jsr	(DeleteObject2).l

loc_23F44:
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	JmpTo24_DeleteObject
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)

JmpTo24_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
; ===========================================================================

loc_23F5C:
	bsr.s	loc_23F66
	bsr.s	loc_23FB0
	jmp	(DisplaySprite).l
; ===========================================================================

loc_23F66:
	tst.b	objoff_36(a0)
	bne.s	loc_23F8E
	move.w	x_pos(a0),d1
	subq.w	#1,d1
	cmp.w	objoff_32(a0),d1
	bne.s	loc_23F88
	move.b	#1,objoff_36(a0)
	move.w	#SndID_SlidingSpike,d0
	jsr	(PlaySoundLocal).l

loc_23F88:
	move.w	d1,x_pos(a0)
	rts
; ===========================================================================

loc_23F8E:
	move.w	x_pos(a0),d1
	addq.w	#1,d1
	cmp.w	objoff_34(a0),d1
	bne.s	loc_23FAA
	move.b	#0,objoff_36(a0)
	move.w	#SndID_SlidingSpike,d0
	jsr	(PlaySoundLocal).l

loc_23FAA:
	move.w	d1,x_pos(a0)
	rts
; ===========================================================================

loc_23FB0:
	movea.l	objoff_3C(a0),a1 ; a1=object
	move.w	x_pos(a0),d0
	subi.w	#$18,d0
	move.w	x_pos(a1),d2
	addi.w	#$18,d2
	cmp.w	d0,d2
	bne.s	return_23FDE
	eori.b	#1,objoff_36(a0)
	eori.b	#1,objoff_36(a1)
	move.w	#SndID_SlidingSpike,d0
	jsr	(PlaySoundLocal).l

return_23FDE:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj43_MapUnc_23FE0:	include "mappings/sprite/obj43.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo8_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo19_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 07 - Oil Ocean in OOZ
; ----------------------------------------------------------------------------
; OST:
oil_char1submersion	= objoff_38 ; $38(a0)
oil_char2submersion	= objoff_3A ; $3A(a0)
; ----------------------------------------------------------------------------
; Sprite_24020:
Obj07:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj07_Index(pc,d0.w),d1
	jmp	Obj07_Index(pc,d1.w)
; ===========================================================================
; off_2402E: Obj07_States:
Obj07_Index:	offsetTable
		offsetTableEntry.w Obj07_Init	; 0
		offsetTableEntry.w Obj07_Main	; 2
; ===========================================================================
; loc_24032:
Obj07_Init:
	addq.b	#2,routine(a0) ; => Obj07_Main
	move.w	#$758,y_pos(a0)
	move.b	#$20,width_pixels(a0)
	move.w	y_pos(a0),objoff_30(a0)
	move.b	#$30,oil_char1submersion(a0)
	bset	#7,status(a0)

; loc_24054:
Obj07_Main:
	; check player 1
	tst.w	(Debug_placement_mode).w
	bne.w	Obj07_End
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing,d1
	move.b	status(a0),d0
	and.b	d1,d0
	bne.s	Obj07_CheckKillChar1
	cmpi.b	#$30,oil_char1submersion(a0)
	beq.s	Obj07_CheckSupportChar1
	addq.b	#1,oil_char1submersion(a0)
	bra.s	Obj07_CheckSupportChar1
; ---------------------------------------------------------------------------
; loc_24078:
Obj07_CheckKillChar1:
	tst.b	oil_char1submersion(a0)
	beq.s	Obj07_SuffocateCharacter
	subq.b	#1,oil_char1submersion(a0)

; loc_24082:
Obj07_CheckSupportChar1:
	moveq	#$20,d1
	moveq	#0,d3
	move.b	oil_char1submersion(a0),d3
	moveq	#p1_standing_bit,d6
	move.w	x_pos(a1),d4
	move.w	d4,x_pos(a0)
	jsrto	PlatformObject_SingleCharacter, JmpTo_PlatformObject_SingleCharacter ; stop the character from falling past the oil

	; check player 2
	lea	(Sidekick).w,a1 ; a1=character
	moveq	#p2_standing,d1
	move.b	status(a0),d0
	and.b	d1,d0
	bne.s	Obj07_CheckKillChar2
	cmpi.b	#$30,oil_char2submersion(a0)
	beq.s	Obj07_CheckSupportChar2
	addq.b	#1,oil_char2submersion(a0)
	bra.s	Obj07_CheckSupportChar2
; ---------------------------------------------------------------------------
; loc_240B4:
Obj07_CheckKillChar2:
	tst.b	oil_char2submersion(a0)
	beq.s	Obj07_SuffocateCharacter
	subq.b	#1,oil_char2submersion(a0)

; loc_240BE:
Obj07_CheckSupportChar2:
	moveq	#$20,d1
	moveq	#0,d3
	move.b	oil_char2submersion(a0),d3
	moveq	#p2_standing_bit,d6
	move.w	x_pos(a1),d4
	move.w	d4,x_pos(a0)
	jsrto	PlatformObject_SingleCharacter, JmpTo_PlatformObject_SingleCharacter ; stop the character from falling past the oil

	rts
; ---------------------------------------------------------------------------
; loc_240D6:
Obj07_SuffocateCharacter:
	not.b	d1
	and.b	d1,status(a0)
	move.l	a0,-(sp)
	movea.l	a0,a2
	movea.l	a1,a0
	jsrto	KillCharacter, JmpTo3_KillCharacter
	movea.l	(sp)+,a0 ; load 0bj address

Obj07_End:
	rts
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo3_KillCharacter ; JmpTo
	jmp	(KillCharacter).l
JmpTo_PlatformObject_SingleCharacter ; JmpTo
	jmp	(PlatformObject_SingleCharacter).l

	align 4
    endif
