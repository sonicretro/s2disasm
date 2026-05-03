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
	bset	#status.npc.no_balancing,status(a0)

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
	jsrto	JmpTo_PlatformObject_SingleCharacter ; stop the character from falling past the oil

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
	jsrto	JmpTo_PlatformObject_SingleCharacter ; stop the character from falling past the oil

	rts
; ---------------------------------------------------------------------------
; loc_240D6:
Obj07_SuffocateCharacter:
	not.b	d1
	and.b	d1,status(a0)
	move.l	a0,-(sp)
	movea.l	a0,a2
	movea.l	a1,a0
	jsrto	JmpTo3_KillCharacter
	movea.l	(sp)+,a0 ; load 0bj address

Obj07_End:
	rts
