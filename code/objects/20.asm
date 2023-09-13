; ===========================================================================
; ----------------------------------------------------------------------------
; Object 20 - Lava bubble from Hill Top Zone (boss weapon)
; ----------------------------------------------------------------------------
; Sprite_22FF8:
Obj20:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj20_Index(pc,d0.w),d1
	jmp	Obj20_Index(pc,d1.w)
; ===========================================================================
; off_23006:
Obj20_Index:	offsetTable
		offsetTableEntry.w Obj20_Init				;  0
		offsetTableEntry.w loc_23076				;  2
		offsetTableEntry.w loc_23084				;  4
		offsetTableEntry.w loc_2311E				;  6
		offsetTableEntry.w loc_23144				;  8
		offsetTableEntry.w loc_231D2				; $A
		offsetTableEntry.w BranchTo_JmpTo21_DeleteObject	; $C
; ===========================================================================
; loc_23014:
Obj20_Init:
	addq.b	#2,routine(a0)
	move.b	#8,y_radius(a0)
	move.b	#8,x_radius(a0)
	move.l	#Obj20_MapUnc_23254,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HtzFireball2,0,1),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo17_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	move.b	#8,width_pixels(a0)
	move.w	y_pos(a0),objoff_30(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#3,d0
	andi.w	#$780,d0
	neg.w	d0
	move.w	d0,x_vel(a0)
	move.w	d0,y_vel(a0)
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	lsl.w	#4,d0
	move.w	d0,objoff_32(a0)
	move.w	d0,objoff_34(a0)

loc_23076:
	lea	(Ani_obj20).l,a1
	jsrto	AnimateSprite, JmpTo4_AnimateSprite
	jmpto	MarkObjGone, JmpTo8_MarkObjGone
; ===========================================================================

loc_23084:
	cmpi.b	#5,anim_frame_duration(a0)
	bne.s	loc_230B4
	jsrto	AllocateObjectAfterCurrent, JmpTo6_AllocateObjectAfterCurrent
	bne.s	loc_230A6
	bsr.s	loc_230C2
	jsrto	AllocateObjectAfterCurrent, JmpTo6_AllocateObjectAfterCurrent
	bne.s	loc_230A6
	bsr.s	loc_230C2
	neg.w	x_vel(a1)
	bset	#0,render_flags(a1)

loc_230A6:
	move.w	#SndID_ArrowFiring,d0
	jsr	(PlaySound).l
	addq.b	#2,routine(a0)

loc_230B4:
	lea	(Ani_obj20).l,a1
	jsrto	AnimateSprite, JmpTo4_AnimateSprite
	jmpto	MarkObjGone, JmpTo8_MarkObjGone
; ===========================================================================

loc_230C2:
	_move.b	#ObjID_LavaBubble,id(a1) ; load obj20
	move.b	#8,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	x_vel(a0),x_vel(a1)
	move.w	y_vel(a0),y_vel(a1)
	move.b	#8,y_radius(a1)
	move.b	#8,x_radius(a1)
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#3,priority(a1)
	move.b	#8,width_pixels(a1)
	move.b	#$8B,collision_flags(a1)
	move.w	y_pos(a1),objoff_30(a1)
	rts
; ===========================================================================

loc_2311E:
	subq.w	#1,objoff_32(a0)
	bpl.s	loc_23136
	move.w	objoff_34(a0),objoff_32(a0)
	move.b	#2,routine(a0)
	move.w	#(0<<8)|(1<<0),anim(a0)

loc_23136:
	lea	(Ani_obj20).l,a1
	jsrto	AnimateSprite, JmpTo4_AnimateSprite
	jmpto	MarkObjGone, JmpTo8_MarkObjGone
; ===========================================================================

loc_23144:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	loc_2315A
	move.b	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	andi.b	#1,mapping_frame(a0)

loc_2315A:
	jsrto	ObjectMove, JmpTo7_ObjectMove
	addi.w	#$18,y_vel(a0)
	move.w	(Camera_Max_Y_pos).w,d0
	addi.w	#224,d0
	cmp.w	y_pos(a0),d0
	bhs.s	loc_23176
	jmpto	DeleteObject, JmpTo21_DeleteObject
; ===========================================================================

loc_23176:
	bclr	#1,render_flags(a0)
	tst.w	y_vel(a0)
	bmi.s	BranchTo_JmpTo8_MarkObjGone
	bset	#1,render_flags(a0)
	bsr.w	ObjCheckFloorDist
	tst.w	d1
	bpl.s	BranchTo_JmpTo8_MarkObjGone
	add.w	d1,y_pos(a0)
	addq.b	#2,routine(a0)
	move.b	#2,anim(a0)
	move.b	#4,mapping_frame(a0)
	move.w	#0,y_vel(a0)
	move.l	#Obj20_MapUnc_23294,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HtzFireball1,0,1),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo17_Adjust2PArtPointer
	move.b	#0,mapping_frame(a0)
	move.w	#9,objoff_32(a0)
	move.b	#3,objoff_36(a0)

BranchTo_JmpTo8_MarkObjGone ; BranchTo
	jmpto	MarkObjGone, JmpTo8_MarkObjGone
; ===========================================================================

loc_231D2:
	subq.w	#1,objoff_32(a0)
	bpl.s	loc_23224
	move.w	#$7F,objoff_32(a0)
	subq.b	#1,objoff_36(a0)
	bmi.s	loc_23224
	jsrto	AllocateObjectAfterCurrent, JmpTo6_AllocateObjectAfterCurrent
	bne.s	loc_23224
	moveq	#0,d0

	move.w	#bytesToLcnt(object_size),d1

loc_231F0:
	move.l	(a0,d0.w),(a1,d0.w)
	addq.w	#4,d0
	dbf	d1,loc_231F0
    if object_size&3
	move.w	(a0,d0.w),(a1,d0.w)
    endif

	move.w	#9,objoff_32(a1)
	move.w	#(2<<8)|(0<<0),anim(a1)
	move.w	#$E,d0
	tst.w	x_vel(a1)
	bpl.s	loc_23214
	neg.w	d0

loc_23214:
	add.w	d0,x_pos(a1)
	move.l	a1,-(sp)
	bsr.w	FireCheckFloorDist
	movea.l	(sp)+,a1 ; a1=object
	add.w	d1,y_pos(a1)

loc_23224:
	lea	(Ani_obj20).l,a1
	jsrto	AnimateSprite, JmpTo4_AnimateSprite
	jmpto	MarkObjGone, JmpTo8_MarkObjGone
; ===========================================================================

BranchTo_JmpTo21_DeleteObject ; BranchTo
	jmpto	DeleteObject, JmpTo21_DeleteObject
; ===========================================================================
; animation script
; off_23236:
Ani_obj20:	offsetTable
		offsetTableEntry.w byte_2323C	; 0
		offsetTableEntry.w byte_23243	; 1
		offsetTableEntry.w byte_23246	; 2
byte_2323C:	dc.b  $B,  2,  3,$FC,  4,$FD,  1
	rev02even
byte_23243:	dc.b $7F,  5,$FF
	rev02even
byte_23246:	dc.b   5,  4,  5,  2,  3,  0,  1,  0,  1,  2,  3,  4,  5,$FC
	even

; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj20_MapUnc_23254:	include "mappings/sprite/obj20_a.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj20_MapUnc_23294:	include "mappings/sprite/obj20_b.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo21_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo8_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo6_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo4_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo17_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
; loc_232FA:
JmpTo7_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif
