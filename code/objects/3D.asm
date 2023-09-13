; ===========================================================================
; ----------------------------------------------------------------------------
; Object 3D - Block thingy in OOZ that launches you into the round ball things
; ----------------------------------------------------------------------------
; Sprite_24DD0:
Obj3D:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj3D_Index(pc,d0.w),d1
	jmp	Obj3D_Index(pc,d1.w)
; ===========================================================================
; off_24DDE:
Obj3D_Index:	offsetTable
		offsetTableEntry.w Obj3D_Init			; 0
		offsetTableEntry.w Obj3D_Main			; 2
		offsetTableEntry.w Obj3D_Fragment		; 4
		offsetTableEntry.w Obj3D_InvisibleLauncher	; 6
; ===========================================================================
; loc_24DE6:
Obj3D_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj3D_MapUnc_250BA,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_StripedBlocksVert,3,0),art_tile(a0)
	tst.b	subtype(a0)
	beq.s	+
	move.w	#make_art_tile(ArtTile_ArtNem_StripedBlocksHoriz,3,0),art_tile(a0)
	move.b	#2,mapping_frame(a0)
+
	jsrto	Adjust2PArtPointer, JmpTo22_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	bset	#7,status(a0)
	move.b	#4,priority(a0)
; loc_24E26:
Obj3D_Main:
	move.b	(MainCharacter+anim).w,objoff_32(a0)
	move.b	(Sidekick+anim).w,objoff_33(a0)
	move.w	(MainCharacter+y_vel).w,objoff_34(a0)
	move.w	(Sidekick+y_vel).w,objoff_36(a0)
	move.w	#$1B,d1
	move.w	#$10,d2
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	jsrto	SolidObject, JmpTo7_SolidObject
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	loc_24E60

BranchTo_JmpTo13_MarkObjGone ; BranchTo
	jmpto	MarkObjGone, JmpTo13_MarkObjGone
; ===========================================================================

loc_24E60:
	cmpi.b	#standing_mask,d0
	bne.s	loc_24E96
	cmpi.b	#AniIDSonAni_Roll,objoff_32(a0)
	beq.s	loc_24E76
	cmpi.b	#AniIDSonAni_Roll,objoff_33(a0)
	bne.s	BranchTo_JmpTo13_MarkObjGone

loc_24E76:
	lea	(MainCharacter).w,a1 ; a1=character
	move.b	objoff_32(a0),d0
	move.w	objoff_34(a0),d1
	bsr.s	loc_24EB2
	lea	(Sidekick).w,a1 ; a1=character
	move.b	objoff_33(a0),d0
	move.w	objoff_36(a0),d1
	bsr.s	loc_24EB2
	bra.w	loc_24F04
; ===========================================================================

loc_24E96:
	move.b	d0,d1
	andi.b	#p1_standing,d1
	beq.s	loc_24EE8
	cmpi.b	#AniIDSonAni_Roll,objoff_32(a0)
	bne.s	BranchTo_JmpTo13_MarkObjGone
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	objoff_34(a0),d1
	bsr.s	loc_24EB8
	bra.s	loc_24F04
; ===========================================================================

loc_24EB2:
	cmpi.b	#AniIDSonAni_Roll,d0
	bne.s	loc_24ED4

loc_24EB8:
	bset	#2,status(a1)
	move.b	#$E,y_radius(a1)
	move.b	#7,x_radius(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	move.w	d1,y_vel(a1)

loc_24ED4:
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#2,routine(a1)
	rts
; ===========================================================================

loc_24EE8:
	andi.b	#p2_standing,d0
	beq.w	BranchTo_JmpTo13_MarkObjGone
	cmpi.b	#AniIDSonAni_Roll,objoff_33(a0)
	bne.w	BranchTo_JmpTo13_MarkObjGone
	lea	(Sidekick).w,a1 ; a1=character
	move.w	objoff_36(a0),d1
	bsr.s	loc_24EB8

loc_24F04:
	andi.b	#~standing_mask,status(a0)
	jsrto	AllocateObjectAfterCurrent, JmpTo9_AllocateObjectAfterCurrent
	bne.s	loc_24F28
	moveq	#0,d0
	move.w	#bytesToLcnt(objoff_2C),d1 ; Copy everything up until 'objoff_2C', which is where the sub-object's own scratch RAM begins.

loc_24F16:
	move.l	(a0,d0.w),(a1,d0.w)
	addq.w	#4,d0
	dbf	d1,loc_24F16
    if objoff_2C&3
	move.w	(a0,d0.w),(a1,d0.w)
    endif

	move.b	#6,routine(a1)

loc_24F28:
	lea	(word_2507A).l,a4
	addq.b	#1,mapping_frame(a0)
	moveq	#$F,d1
	move.w	#$18,d2
	jsrto	BreakObjectToPieces, JmpTo2_BreakObjectToPieces
; loc_24F3C:
Obj3D_Fragment:
	jsrto	ObjectMove, JmpTo10_ObjectMove
	addi.w	#$18,y_vel(a0)
	tst.b	render_flags(a0)
	bpl.w	JmpTo26_DeleteObject
	jmpto	DisplaySprite, JmpTo14_DisplaySprite
; ===========================================================================
; loc_24F52:
Obj3D_InvisibleLauncher:
	lea	(MainCharacter).w,a1 ; a1=character
	lea	objoff_2C(a0),a4
	bsr.s	loc_24F74
	lea	(Sidekick).w,a1 ; a1=character
	lea	objoff_36(a0),a4
	bsr.s	loc_24F74
	move.b	objoff_2C(a0),d0
	add.b	objoff_36(a0),d0
	beq.w	JmpTo3_MarkObjGone3
	rts
; ===========================================================================

loc_24F74:
	moveq	#0,d0
	move.b	(a4),d0
	move.w	off_24F80(pc,d0.w),d0
	jmp	off_24F80(pc,d0.w)
; ===========================================================================
off_24F80:	offsetTable
		offsetTableEntry.w loc_24F84	; 0
		offsetTableEntry.w loc_25036	; 2
; ===========================================================================

loc_24F84:
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$10,d0
	cmpi.w	#$20,d0
	bhs.w	return_25034
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	tst.b	subtype(a0)
	beq.s	loc_24FAA
	addi.w	#$10,d1

loc_24FAA:
	cmpi.w	#$10,d1
	bhs.w	return_25034
	cmpa.w	#Sidekick,a1
	bne.s	loc_24FC2
	cmpi.w	#4,(Tails_CPU_routine).w ; TailsCPU_Flying
	beq.w	return_25034

loc_24FC2:
	addq.b	#2,(a4)
	move.b	#$81,obj_control(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	move.w	#$800,inertia(a1)
	tst.b	subtype(a0)
	beq.s	loc_24FF0
	move.w	x_pos(a0),x_pos(a1)
	move.w	#0,x_vel(a1)
	move.w	#-$800,y_vel(a1)
	bra.s	loc_25002
; ===========================================================================

loc_24FF0:
	move.w	y_pos(a0),y_pos(a1)
	move.w	#$800,x_vel(a1)
	move.w	#0,y_vel(a1)

loc_25002:
	bclr	#5,status(a0)
	bclr	#5,status(a1)
	bset	#1,status(a1)
	bset	#3,status(a1)
    if object_size<>$40
	moveq	#0,d0 ; Clear the high word for the coming division.
    endif
	move.w	a0,d0
	subi.w	#Object_RAM,d0
    if object_size=$40
	lsr.w	#object_size_bits,d0
    else
	divu.w	#object_size,d0
    endif
	andi.w	#$7F,d0
	move.b	d0,interact(a1)
	move.w	#SndID_Roll,d0
	jsr	(PlaySound).l

return_25034:
	rts
; ===========================================================================

loc_25036:
	tst.b	render_flags(a1)
	bmi.s	Obj3D_MoveCharacter
	move.b	#0,obj_control(a1)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#0,(a4)
	rts
; ===========================================================================
; update the position of Sonic/Tails from the block thing to the launcher
; loc_25054:
Obj3D_MoveCharacter:
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
word_2507A:
	dc.w -$400,-$400 ; 0
	dc.w -$200,-$400 ; 2
	dc.w  $200,-$400 ; 4
	dc.w  $400,-$400 ; 6
	dc.w -$3C0,-$200 ; 8
	dc.w -$1C0,-$200 ; 10
	dc.w  $1C0,-$200 ; 12
	dc.w  $3C0,-$200 ; 14
	dc.w -$380, $200 ; 16
	dc.w -$180, $200 ; 18
	dc.w  $180, $200 ; 20
	dc.w  $380, $200 ; 22
	dc.w -$340, $400 ; 24
	dc.w -$140, $400 ; 26
	dc.w  $140, $400 ; 28
	dc.w  $340, $400 ; 30
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj3D_MapUnc_250BA:	include "mappings/sprite/obj3D.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo14_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo26_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo13_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo9_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo3_MarkObjGone3 ; JmpTo
	jmp	(MarkObjGone3).l
JmpTo22_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo2_BreakObjectToPieces ; JmpTo
	jmp	(BreakObjectToPieces).l
JmpTo7_SolidObject ; JmpTo
	jmp	(SolidObject).l
; loc_2523C:
JmpTo10_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    else
JmpTo3_MarkObjGone3 ; JmpTo
	jmp	(MarkObjGone3).l
JmpTo26_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
; Unused
;JmpTo13_MarkObjGone
	jmp	(MarkObjGone).l
    endif
