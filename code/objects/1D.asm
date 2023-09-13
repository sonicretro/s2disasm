; ===========================================================================
; ----------------------------------------------------------------------------
; Object 1D - Blue balls in CPZ
; ----------------------------------------------------------------------------
; Sprite_22408:
Obj1D:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj1D_Index(pc,d0.w),d1
	jmp	Obj1D_Index(pc,d1.w)
; ===========================================================================
; off_22416: Obj1D_States:
Obj1D_Index:	offsetTable
		offsetTableEntry.w Obj1D_Init		; 0
		offsetTableEntry.w Obj1D_Wait		; 2
		offsetTableEntry.w Obj1D_MoveArc	; 4
		offsetTableEntry.w Obj1D_Wait		; 6
		offsetTableEntry.w Obj1D_MoveStraight	; 8
; ---------------------------------------------------------------------------
; unused table of speed values
; word_22420:
	dc.w -$480
	dc.w -$500
	dc.w -$600
	dc.w -$700
; ===========================================================================
; loc_22428:
Obj1D_Init:
	addq.b	#2,routine(a0) ; => Obj1D_Wait
	move.w	#-$480,y_vel(a0)
	moveq	#0,d1
	move.b	subtype(a0),d1
	move.b	d1,d0
	andi.b	#$F,d1	; number of blue balls
	moveq	#2,d5	; routine number
	andi.b	#$F0,d0
	beq.s	+
	moveq	#6,d5	; routine number
+
	move.b	status(a0),d4
	moveq	#0,d2
	movea.l	a0,a1
	bra.s	Obj1D_InitBall
; ---------------------------------------------------------------------------
Obj1D_LoadBall:
	jsrto	AllocateObjectAfterCurrent, JmpTo5_AllocateObjectAfterCurrent
	bne.s	++
; loc_22458:
Obj1D_InitBall:
	_move.b	id(a0),id(a1) ; load obj1D
	move.b	d5,routine(a1) ; => Obj1D_Wait (either one)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.l	#Obj1D_MapUnc_22576,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZDroplet,3,0),art_tile(a1)
	jsrto	Adjust2PArtPointer2, JmpTo3_Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#3,priority(a1)
	move.b	#%10001011,collision_flags(a1)
	move.w	x_pos(a1),objoff_38(a1)
	move.w	y_pos(a1),objoff_30(a1)
	move.w	y_vel(a0),y_vel(a1)
	move.w	y_vel(a1),objoff_34(a1)
	move.b	#8,width_pixels(a1)
	move.w	#$60,objoff_3A(a1)
	move.w	#$B,objoff_36(a1)
	andi.b	#1,d4
	beq.s	+
	neg.w	objoff_36(a1)
	neg.w	objoff_3A(a1)
+
	move.w	d2,objoff_32(a1)
	addq.w	#3,d2
+
	dbf	d1,Obj1D_LoadBall
	rts
; ===========================================================================
; loc_224D6:
Obj1D_Wait:
	subq.w	#1,objoff_32(a0)
	bpl.s	BranchTo_JmpTo7_MarkObjGone
	addq.b	#2,routine(a0) ; => Obj1D_MoveArc or Obj1D_MoveStraight
	move.w	#$3B,objoff_32(a0)
	move.w	#SndID_Gloop,d0
	jsr	(PlaySoundLocal).l

BranchTo_JmpTo7_MarkObjGone ; BranchTo
	jmpto	MarkObjGone, JmpTo7_MarkObjGone
; ===========================================================================
; loc_224F4:
Obj1D_MoveArc:
	jsrto	ObjectMove, JmpTo6_ObjectMove
	move.w	objoff_36(a0),d0
	add.w	d0,x_vel(a0)
	addi.w	#$18,y_vel(a0)
	bne.s	+
	neg.w	objoff_36(a0)
+
	move.w	objoff_30(a0),d0
	cmp.w	y_pos(a0),d0
	bhi.s	BranchTo2_JmpTo7_MarkObjGone
	move.w	objoff_34(a0),y_vel(a0)
	clr.w	x_vel(a0)
	subq.b	#2,routine(a0) ; => Obj1D_Wait

BranchTo2_JmpTo7_MarkObjGone
	jmpto	MarkObjGone, JmpTo7_MarkObjGone
; ===========================================================================
; loc_22528:
Obj1D_MoveStraight:
	jsrto	ObjectMove, JmpTo6_ObjectMove
	addi.w	#$18,y_vel(a0)
	bne.s	+
	move.w	objoff_3A(a0),d0
	add.w	objoff_38(a0),d0
	move.w	d0,x_pos(a0)
+
	cmpi.w	#$180,y_vel(a0)
	bne.s	+
	move.w	#SndID_Gloop,d0
	jsr	(PlaySoundLocal).l
+
	move.w	objoff_30(a0),d0
	cmp.w	y_pos(a0),d0
	bhi.s	BranchTo3_JmpTo7_MarkObjGone
	move.w	objoff_34(a0),y_vel(a0)
	move.w	objoff_38(a0),x_pos(a0)
	move.w	#SndID_Gloop,d0
	jsr	(PlaySoundLocal).l

BranchTo3_JmpTo7_MarkObjGone
	jmpto	MarkObjGone, JmpTo7_MarkObjGone
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj1D_MapUnc_22576:	include "mappings/sprite/obj1D.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo7_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo5_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo3_Adjust2PArtPointer2 ; JmpTo
	jmp	(Adjust2PArtPointer2).l
; loc_22596:
JmpTo6_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif
