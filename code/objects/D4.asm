; ===========================================================================
; ----------------------------------------------------------------------------
; Object D4 - Big block from CNZ that moves back and forth
; ----------------------------------------------------------------------------
; Sprite_2B8EC:
ObjD4:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjD4_Index(pc,d0.w),d1
	jmp	ObjD4_Index(pc,d1.w)
; ===========================================================================
; off_2B8FA:
ObjD4_Index:	offsetTable
		offsetTableEntry.w ObjD4_Init	; 0
		offsetTableEntry.w ObjD4_Main	; 2
; ===========================================================================
; loc_2B8FE:
ObjD4_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjD4_MapUnc_2B9CA,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_BigMovingBlock,2,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo52_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#4,priority(a0)
	move.w	x_pos(a0),objoff_30(a0)
	move.w	y_pos(a0),objoff_32(a0)
	move.w	#$8000,x_sub(a0)
	move.w	#$8000,y_sub(a0)
	tst.b	subtype(a0)
	bne.s	loc_2B95A
	subi.w	#$60,x_pos(a0)
	btst	#0,status(a0)
	beq.s	ObjD4_Main
	addi.w	#$C0,x_pos(a0)
	bra.s	ObjD4_Main
; ===========================================================================

loc_2B95A:
	subi.w	#$60,y_pos(a0)
	btst	#1,status(a0)
	beq.s	ObjD4_Main
	addi.w	#$C0,y_pos(a0)
; loc_2B96E:
ObjD4_Main:
	move.w	x_pos(a0),-(sp)
	moveq	#0,d0
	move.b	subtype(a0),d0
	move.w	ObjD4_Types(pc,d0.w),d1
	jsr	ObjD4_Types(pc,d1.w)
	jsrto	ObjectMove, JmpTo17_ObjectMove
	move.w	#$2B,d1
	move.w	#$20,d2
	move.w	#$21,d3
	move.w	(sp)+,d4
	jsrto	SolidObject, JmpTo25_SolidObject
	move.w	objoff_30(a0),d0
	jmpto	MarkObjGone2, JmpTo10_MarkObjGone2
; ===========================================================================
; off_2B99E:
ObjD4_Types:	offsetTable
		offsetTableEntry.w ObjD4_Horizontal	; 0
		offsetTableEntry.w ObjD4_Vertical	; 2
; ===========================================================================
; loc_2B9A2:
ObjD4_Horizontal:
	moveq	#4,d1
	move.w	objoff_30(a0),d0
	cmp.w	x_pos(a0),d0
	bhi.s	+
	neg.w	d1
+
	add.w	d1,x_vel(a0)
	rts
; ===========================================================================
; loc_2B9B6:
ObjD4_Vertical:
	moveq	#4,d1
	move.w	objoff_32(a0),d0
	cmp.w	y_pos(a0),d0
	bhi.s	+
	neg.w	d1
+
	add.w	d1,y_vel(a0)
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjD4_MapUnc_2B9CA:	include "mappings/sprite/objD4.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo52_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo25_SolidObject ; JmpTo
	jmp	(SolidObject).l
JmpTo10_MarkObjGone2 ; JmpTo
	jmp	(MarkObjGone2).l
; loc_2BA02:
JmpTo17_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif
