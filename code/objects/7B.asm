; ===========================================================================
; ----------------------------------------------------------------------------
; Object 7B - Warp pipe exit spring from CPZ
; ----------------------------------------------------------------------------
; Sprite_29590:
Obj7B:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj7B_Index(pc,d0.w),d1
	jsr	Obj7B_Index(pc,d1.w)
	tst.w	(Two_player_mode).w
	beq.s	+
	jmpto	DisplaySprite, JmpTo25_DisplaySprite
; ===========================================================================
+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo40_DeleteObject
	jmpto	DisplaySprite, JmpTo25_DisplaySprite

    if removeJmpTos
JmpTo40_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
; off_295C0:
Obj7B_Index:	offsetTable
		offsetTableEntry.w Obj7B_Init	; 0
		offsetTableEntry.w Obj7B_Main	; 2
; ===========================================================================
; byte_295C4:
Obj7B_Strengths:
	; Speed applied on Sonic
	dc.w -$1000
	dc.w  -$A80
; ===========================================================================
; loc_295C8:
Obj7B_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj7B_MapUnc_29780,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZTubeSpring,0,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#1,priority(a0)
	move.b	subtype(a0),d0
	andi.w	#2,d0
	move.w	Obj7B_Strengths(pc,d0.w),objoff_30(a0)
	jsrto	Adjust2PArtPointer, JmpTo42_Adjust2PArtPointer
; loc_295FE:
Obj7B_Main:
	cmpi.b	#1,mapping_frame(a0)
	beq.s	loc_29648
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#$10,d3
	move.w	x_pos(a0),d4
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	jsrto	SolidObject_Always_SingleCharacter, JmpTo4_SolidObject_Always_SingleCharacter
	btst	#p1_standing_bit,status(a0)
	beq.s	+
	bsr.w	loc_296C2
+
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	moveq	#p2_standing_bit,d6
	jsrto	SolidObject_Always_SingleCharacter, JmpTo4_SolidObject_Always_SingleCharacter
	btst	#p2_standing_bit,status(a0)
	beq.s	loc_29648
	bsr.s	loc_296C2

loc_29648:
	move.w	x_pos(a0),d4
	move.w	d4,d5
	subi.w	#$10,d4
	addi.w	#$10,d5
	move.w	y_pos(a0),d2
	move.w	d2,d3
	addi.w	#$30,d3
	move.w	(MainCharacter+x_pos).w,d0
	cmp.w	d4,d0
	blo.s	loc_29686
	cmp.w	d5,d0
	bhs.s	loc_29686
	move.w	(MainCharacter+y_pos).w,d0
	cmp.w	d2,d0
	blo.s	loc_29686
	cmp.w	d3,d0
	bhs.s	loc_29686
	cmpi.b	#2,prev_anim(a0)
	beq.s	loc_29686
	move.b	#2,anim(a0)

loc_29686:
	move.w	(Sidekick+x_pos).w,d0
	cmp.w	d4,d0
	blo.s	loc_296B6
	cmp.w	d5,d0
	bhs.s	loc_296B6
	move.w	(Sidekick+y_pos).w,d0
	cmp.w	d2,d0
	blo.s	loc_296B6
	cmp.w	d3,d0
	bhs.s	loc_296B6
	cmpi.w	#4,(Tails_CPU_routine).w	; TailsCPU_Flying
	beq.w	loc_296B6
	cmpi.b	#3,prev_anim(a0)
	beq.s	loc_296B6
	move.b	#3,anim(a0)

loc_296B6:
	lea	(Ani_obj7B).l,a1
	jmpto	AnimateSprite, JmpTo8_AnimateSprite
; ===========================================================================
	rts
; ===========================================================================

loc_296C2:
	move.w	#(1<<8)|(0<<0),anim(a0)
	addq.w	#4,y_pos(a1)
	move.w	objoff_30(a0),y_vel(a1)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#AniIDSonAni_Spring,anim(a1)
	move.b	#2,routine(a1)
	move.b	subtype(a0),d0
	bpl.s	+
	move.w	#0,x_vel(a1)
+
	btst	#0,d0
	beq.s	loc_29736
	move.w	#1,inertia(a1)
	move.b	#1,flip_angle(a1)
	move.b	#AniIDSonAni_Walk,anim(a1)
	move.b	#0,flips_remaining(a1)
	move.b	#4,flip_speed(a1)
	btst	#1,d0
	bne.s	+
	move.b	#1,flips_remaining(a1)
+
	btst	#0,status(a1)
	beq.s	loc_29736
	neg.b	flip_angle(a1)
	neg.w	inertia(a1)

loc_29736:
	andi.b	#$C,d0
	cmpi.b	#4,d0
	bne.s	+
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)
+
	cmpi.b	#8,d0
	bne.s	+
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)
+
	move.w	#SndID_Spring,d0
	jmp	(PlaySound).l
; ===========================================================================
; animation script
; off_29768:
Ani_obj7B:	offsetTable
		offsetTableEntry.w byte_29770	; 0
		offsetTableEntry.w byte_29773	; 1
		offsetTableEntry.w byte_29777	; 2
		offsetTableEntry.w byte_29777	; 3
byte_29770:	dc.b  $F,  0,$FF
		rev02even
byte_29773:	dc.b   0,  3,$FD,  0
		rev02even
byte_29777:	dc.b   5,  1,  2,  2,  2,  4,$FD,  0
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj7B_MapUnc_29780:	include "mappings/sprite/obj7B.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo25_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo40_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo8_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo42_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo4_SolidObject_Always_SingleCharacter ; JmpTo
	jmp	(SolidObject_Always_SingleCharacter).l

	align 4
    endif
