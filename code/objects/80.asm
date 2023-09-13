; ===========================================================================
; ----------------------------------------------------------------------------
; Object 80 - Vine that you hang off and it moves down from MCZ
; ----------------------------------------------------------------------------
; Sprite_2997C:
Obj80:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj80_Index(pc,d0.w),d1
	jmp	Obj80_Index(pc,d1.w)
; ===========================================================================
; off_2998A:
Obj80_Index:	offsetTable
		offsetTableEntry.w Obj80_Init		; 0 - Init
		offsetTableEntry.w Obj80_MCZ_Main	; 2 - MCZ Vine
		offsetTableEntry.w Obj80_WFZ_Main	; 4 - WFZ Hook
; ===========================================================================
; loc_29990:
Obj80_Init:
	addq.b	#2,routine(a0)
	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	move.b	#$80,y_radius(a0)
	bset	#4,render_flags(a0)
	move.w	y_pos(a0),objoff_3C(a0)
	cmpi.b	#wing_fortress_zone,(Current_Zone).w
	bne.s	Obj80_MCZ_Init
	addq.b	#2,routine(a0)
	move.l	#Obj80_MapUnc_29DD0,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_WfzHook_Fudge,1,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo44_Adjust2PArtPointer
	move.w	#$A0,objoff_2E(a0)
	move.b	subtype(a0),d0
	move.b	d0,d1
	andi.b	#$F,d0
	beq.s	+
	move.w	#$60,objoff_2E(a0)
+
	move.b	subtype(a0),d0
	move.w	#2,objoff_3A(a0)
	andi.b	#$70,d1
	beq.s	+
	move.w	objoff_2E(a0),d0
	move.w	d0,objoff_38(a0)
	move.b	#1,objoff_36(a0)
	add.w	d0,y_pos(a0)
	lsr.w	#4,d0
	addq.w	#1,d0
	move.b	d0,mapping_frame(a0)
+
	bra.w	Obj80_WFZ_Main
; ===========================================================================
; loc_29A1C:
Obj80_MCZ_Init:
	move.l	#Obj80_MapUnc_29C64,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_VinePulley,3,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo44_Adjust2PArtPointer
	move.w	#$B0,objoff_2E(a0)
	move.b	subtype(a0),d0
	bpl.s	+
	move.b	#1,objoff_34(a0)
+
	move.w	#2,objoff_3A(a0)
	andi.b	#$70,d0
	beq.s	Obj80_MCZ_Main
	move.w	objoff_2E(a0),d0
	move.w	d0,objoff_38(a0)
	move.b	#1,objoff_36(a0)
	add.w	d0,y_pos(a0)
	lsr.w	#5,d0
	addq.w	#1,d0
	move.b	d0,mapping_frame(a0)
; loc_29A66:
Obj80_MCZ_Main:
	tst.b	objoff_36(a0)
	beq.s	loc_29A74
	tst.w	objoff_30(a0)
	bne.s	loc_29A8A
	bra.s	loc_29A7A
; ===========================================================================

loc_29A74:
	tst.w	objoff_30(a0)
	beq.s	loc_29A8A

loc_29A7A:
	move.w	objoff_38(a0),d2
	cmp.w	objoff_2E(a0),d2
	beq.s	loc_29AAE
	add.w	objoff_3A(a0),d2
	bra.s	loc_29A94
; ===========================================================================

loc_29A8A:
	move.w	objoff_38(a0),d2
	beq.s	loc_29AAE
	sub.w	objoff_3A(a0),d2

loc_29A94:
	move.w	d2,objoff_38(a0)
	move.w	objoff_3C(a0),d0
	add.w	d2,d0
	move.w	d0,y_pos(a0)
	move.w	d2,d0
	beq.s	+
	lsr.w	#5,d0
	addq.w	#1,d0
+
	move.b	d0,mapping_frame(a0)

loc_29AAE:
	lea	objoff_30(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	(Ctrl_1).w,d0
	bsr.s	Obj80_Action
	lea	(Sidekick).w,a1 ; a1=character
	addq.w	#1,a2
	move.w	(Ctrl_2).w,d0
	bsr.s	Obj80_Action
	jmpto	MarkObjGone, JmpTo25_MarkObjGone
; ===========================================================================
; loc_29ACC:
Obj80_Action:
	tst.b	(a2)
	beq.w	loc_29B5E
	tst.b	render_flags(a1)
	bpl.s	loc_29B42
	cmpi.b	#4,routine(a1)
	bhs.s	loc_29B42
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0
	beq.w	loc_29B50
	clr.b	obj_control(a1)
	clr.b	(a2)
	move.b	#18,2(a2)
	andi.w	#(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
	beq.w	+
	move.b	#60,2(a2)
+
	btst	#(button_left+8),d0
	beq.s	+
	move.w	#-$200,x_vel(a1)
+
	btst	#(button_right+8),d0
	beq.s	+
	move.w	#$200,x_vel(a1)
+
	move.w	#-$380,y_vel(a1)
	bset	#1,status(a1)
	tst.b	objoff_34(a0)
	beq.s	+	; rts
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	lea	(ButtonVine_Trigger).w,a3
	lea	(a3,d0.w),a3
	bclr	#0,(a3)
+
	rts
; ===========================================================================

loc_29B42:
	clr.b	obj_control(a1)
	clr.b	(a2)
	move.b	#60,2(a2)
	rts
; ===========================================================================

loc_29B50:
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$94,y_pos(a1)
	rts
; ===========================================================================

loc_29B5E:
	tst.b	2(a2)
	beq.s	+
	subq.b	#1,2(a2)
	bne.w	return_29BF8
+
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$10,d0
	cmpi.w	#$20,d0
	bhs.w	return_29BF8
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	subi.w	#$88,d1
	cmpi.w	#$18,d1
	bhs.w	return_29BF8
	tst.b	obj_control(a1)
	bmi.s	return_29BF8
	cmpi.b	#4,routine(a1)
	bhs.s	return_29BF8
	tst.w	(Debug_placement_mode).w
	bne.s	return_29BF8
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	clr.w	inertia(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$94,y_pos(a1)
	move.b	#AniIDSonAni_Hang2,anim(a1)
	move.b	#1,obj_control(a1)
	move.b	#1,(a2)
	tst.b	objoff_34(a0)
	beq.s	return_29BF8
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	lea	(ButtonVine_Trigger).w,a3
	bset	#0,(a3,d0.w)
	move.w	#SndID_Blip,d0
	jsr	(PlaySound).l

return_29BF8:
	rts
; ===========================================================================
; loc_29BFA:
Obj80_WFZ_Main:
	tst.b	objoff_36(a0)
	beq.s	loc_29C08
	tst.w	objoff_30(a0)
	bne.s	loc_29C1E
	bra.s	loc_29C0E
; ===========================================================================

loc_29C08:
	tst.w	objoff_30(a0)
	beq.s	loc_29C1E

loc_29C0E:
	move.w	objoff_38(a0),d2
	cmp.w	objoff_2E(a0),d2
	beq.s	loc_29C42
	add.w	objoff_3A(a0),d2
	bra.s	loc_29C28
; ===========================================================================

loc_29C1E:
	move.w	objoff_38(a0),d2
	beq.s	loc_29C42
	sub.w	objoff_3A(a0),d2

loc_29C28:
	move.w	d2,objoff_38(a0)
	move.w	objoff_3C(a0),d0
	add.w	d2,d0
	move.w	d0,y_pos(a0)
	move.w	d2,d0
	beq.s	+
	lsr.w	#4,d0
	addq.w	#1,d0
+
	move.b	d0,mapping_frame(a0)

loc_29C42:
	lea	objoff_30(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	(Ctrl_1).w,d0
	bsr.w	Obj80_Action
	lea	(Sidekick).w,a1 ; a1=character
	addq.w	#1,a2
	move.w	(Ctrl_2).w,d0
	bsr.w	Obj80_Action
	jmpto	MarkObjGone, JmpTo25_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj80_MapUnc_29C64:	include "mappings/sprite/obj80_a.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj80_MapUnc_29DD0:	include "mappings/sprite/obj80_b.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo25_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo44_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
