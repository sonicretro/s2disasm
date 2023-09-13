; ===========================================================================
; ----------------------------------------------------------------------------
; Object 67 - Spin tube from MTZ
; ----------------------------------------------------------------------------
; Sprite_2715C:
Obj67:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj67_Index(pc,d0.w),d1
	jsr	Obj67_Index(pc,d1.w)
	move.b	objoff_2C(a0),d0
	add.b	objoff_36(a0),d0
	beq.w	JmpTo4_MarkObjGone3
	lea	(Ani_obj67).l,a1
	jsrto	AnimateSprite, JmpTo7_AnimateSprite
	jmpto	DisplaySprite, JmpTo19_DisplaySprite
; ===========================================================================
; off_27184:
Obj67_Index:	offsetTable
		offsetTableEntry.w Obj67_Init	; 0
		offsetTableEntry.w Obj67_Main	; 2
; ===========================================================================
; loc_27188:
Obj67_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj67_MapUnc_27548,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MtzSpinTubeFlash,3,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#5,priority(a0)
; loc_271AC:
Obj67_Main:
	lea	(MainCharacter).w,a1 ; a1=character
	lea	objoff_2C(a0),a4
	bsr.s	loc_271BE
	lea	(Sidekick).w,a1 ; a1=character
	lea	objoff_36(a0),a4

loc_271BE:
	moveq	#0,d0
	move.b	(a4),d0
	move.w	off_271CA(pc,d0.w),d0
	jmp	off_271CA(pc,d0.w)
; ===========================================================================
off_271CA:	offsetTable
		offsetTableEntry.w loc_271D0	; 0
		offsetTableEntry.w loc_27260	; 2
		offsetTableEntry.w loc_27294	; 4
; ===========================================================================

loc_271D0:
	tst.w	(Debug_placement_mode).w
	bne.w	return_2725E
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addq.w	#3,d0
	btst	#0,status(a0)
	beq.s	+
	addi.w	#$A,d0
+
	cmpi.w	#$10,d0
	bhs.s	return_2725E
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	addi.w	#$20,d1
	cmpi.w	#$40,d1
	bhs.s	return_2725E
	tst.b	obj_control(a1)
	bne.s	return_2725E
	addq.b	#2,(a4)
	move.b	#$81,obj_control(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	move.w	#$800,inertia(a1)
	move.w	#0,x_vel(a1)
	move.w	#0,y_vel(a1)
	bclr	#5,status(a0)
	bclr	#5,status(a1)
	bset	#1,status(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	clr.b	1(a4)
	move.w	#SndID_Roll,d0
	jsr	(PlaySound).l
	move.w	#(1<<8)|(0<<0),anim(a0)

return_2725E:
	rts
; ===========================================================================

loc_27260:
	move.b	1(a4),d0
	addq.b	#2,1(a4)
	jsr	(CalcSine).l
	asr.w	#5,d0
	move.w	y_pos(a0),d2
	sub.w	d0,d2
	move.w	d2,y_pos(a1)
	cmpi.b	#$80,1(a4)
	bne.s	+
	bsr.w	loc_27310
	addq.b	#2,(a4)
	move.w	#SndID_SpindashRelease,d0
	jsr	(PlaySound).l
+
	rts
; ===========================================================================

loc_27294:
	subq.b	#1,2(a4)
	bpl.s	Obj67_MoveCharacter
	movea.l	6(a4),a2
	move.w	(a2)+,d4
	move.w	d4,x_pos(a1)
	move.w	(a2)+,d5
	move.w	d5,y_pos(a1)
	tst.b	subtype(a0)
	bpl.s	+
	subq.w	#8,a2
+
	move.l	a2,6(a4)
	subq.w	#4,4(a4)
	beq.s	loc_272EE
	move.w	(a2)+,d4
	move.w	(a2)+,d5
	move.w	#$1000,d2
	bra.w	loc_27374
; ===========================================================================
; update the position of Sonic/Tails in the MTZ tube
; loc_272C8:
Obj67_MoveCharacter:
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

loc_272EE:
	andi.w	#$7FF,y_pos(a1)
	clr.b	(a4)
	clr.b	obj_control(a1)
	btst	#4,subtype(a0)
	bne.s	+
	move.w	#0,x_vel(a1)
	move.w	#0,y_vel(a1)
+
	rts
; ===========================================================================

loc_27310:
	move.b	subtype(a0),d0
	bpl.s	loc_27344
	neg.b	d0
	andi.w	#$F,d0
	add.w	d0,d0
	lea	(off_273F2).l,a2
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
	bra.s	loc_27368
; ===========================================================================

loc_27344:
	andi.w	#$F,d0
	add.w	d0,d0
	lea	(off_273F2).l,a2
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,4(a4)
	subq.w	#4,4(a4)
	move.w	(a2)+,d4
	move.w	d4,x_pos(a1)
	move.w	(a2)+,d5
	move.w	d5,y_pos(a1)

loc_27368:
	move.l	a2,6(a4)
	move.w	(a2)+,d4
	move.w	(a2)+,d5
	move.w	#$1000,d2

loc_27374:
	moveq	#0,d0
	move.w	d2,d3
	move.w	d4,d0
	sub.w	x_pos(a1),d0
	bge.s	loc_27384
	neg.w	d0
	neg.w	d2

loc_27384:
	moveq	#0,d1
	move.w	d5,d1
	sub.w	y_pos(a1),d1
	bge.s	loc_27392
	neg.w	d1
	neg.w	d3

loc_27392:
	cmp.w	d0,d1
	blo.s	loc_273C4
	moveq	#0,d1
	move.w	d5,d1
	sub.w	y_pos(a1),d1
	swap	d1
	divs.w	d3,d1
	moveq	#0,d0
	move.w	d4,d0
	sub.w	x_pos(a1),d0
	beq.s	loc_273B0
	swap	d0
	divs.w	d1,d0

loc_273B0:
	move.w	d0,x_vel(a1)
	move.w	d3,y_vel(a1)
	abs.w	d1
	move.w	d1,2(a4)
	rts
; ===========================================================================

loc_273C4:
	moveq	#0,d0
	move.w	d4,d0
	sub.w	x_pos(a1),d0
	swap	d0
	divs.w	d2,d0
	moveq	#0,d1
	move.w	d5,d1
	sub.w	y_pos(a1),d1
	beq.s	loc_273DE
	swap	d1
	divs.w	d0,d1

loc_273DE:
	move.w	d1,y_vel(a1)
	move.w	d2,x_vel(a1)
	abs.w	d0
	move.w	d0,2(a4)
	rts
; ===========================================================================
; MTZ tube position data
; off_273F2:
	include	"misc/obj67.asm"
; animation script
; byte_2752E:
Ani_obj67:	offsetTable
		offsetTableEntry.w byte_27532	; 0
		offsetTableEntry.w byte_27535	; 1
byte_27532:
	dc.b $1F,  0,$FF
	rev02even
byte_27535:
	dc.b   1,  1,  0,  0,  0,  0,  0,  1,  0,  0,  0,  1,  0,  0,  1,  0,$FE,  2
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj67_MapUnc_27548:	include "mappings/sprite/obj67.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo19_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo7_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo4_MarkObjGone3 ; JmpTo
	jmp	(MarkObjGone3).l

	align 4
    else
JmpTo4_MarkObjGone3 ; JmpTo
	jmp	(MarkObjGone3).l
    endif
