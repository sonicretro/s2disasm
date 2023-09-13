; ===========================================================================
; ----------------------------------------------------------------------------
; Object 7F - Vine switch that you hang off in MCZ
; ----------------------------------------------------------------------------
; Sprite_297E4:
Obj7F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj7F_Index(pc,d0.w),d1
	jmp	Obj7F_Index(pc,d1.w)
; ===========================================================================
; off_297F2:
Obj7F_Index:	offsetTable
		offsetTableEntry.w Obj7F_Init	; 0
		offsetTableEntry.w Obj7F_Main	; 2
; ===========================================================================
; loc_297F6:
Obj7F_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj7F_MapUnc_29938,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_VineSwitch,3,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo43_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#8,width_pixels(a0)
	move.b	#4,priority(a0)
; loc_2981E:
Obj7F_Main:
	lea	objoff_30(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	(Ctrl_1).w,d0
	bsr.s	Obj7F_Action
	lea	(Sidekick).w,a1 ; a1=character
	addq.w	#1,a2
	move.w	(Ctrl_2).w,d0
	bsr.s	Obj7F_Action
	jmpto	MarkObjGone, JmpTo24_MarkObjGone
; ===========================================================================
; loc_2983C:
Obj7F_Action:
	tst.b	(a2)
	beq.s	loc_29890
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0
	beq.w	return_29936
	clr.b	obj_control(a1)
	clr.b	(a2)
	move.b	#18,2(a2)
	andi.w	#(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
	beq.s	+
	move.b	#60,2(a2)
+
	move.w	#-$300,y_vel(a1)
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	lea	(ButtonVine_Trigger).w,a3
	lea	(a3,d0.w),a3
	bclr	#0,(a3)
	move.b	#0,mapping_frame(a0)
	tst.w	objoff_30(a0)
	beq.s	+
	move.b	#1,mapping_frame(a0)
+
	bra.w	return_29936
; ===========================================================================

loc_29890:
	tst.b	2(a2)
	beq.s	+
	subq.b	#1,2(a2)
	bne.w	return_29936
+
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$C,d0
	cmpi.w	#$18,d0
	bhs.w	return_29936
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	subi.w	#$28,d1
	cmpi.w	#$10,d1
	bhs.w	return_29936
	tst.b	obj_control(a1)
	bmi.s	return_29936
	cmpi.b	#4,routine(a1)
	bhs.s	return_29936
	tst.w	(Debug_placement_mode).w
	bne.s	return_29936
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	clr.w	inertia(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$30,y_pos(a1)
	move.b	#AniIDSonAni_Hang2,anim(a1)
	move.b	#1,obj_control(a1)
	move.b	#1,(a2)
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	lea	(ButtonVine_Trigger).w,a3
	bset	#0,(a3,d0.w)
	move.w	#SndID_Blip,d0
	jsr	(PlaySound).l
	move.b	#0,mapping_frame(a0)
	tst.w	objoff_30(a0)
	beq.s	return_29936
	move.b	#1,mapping_frame(a0)

return_29936:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj7F_MapUnc_29938:	include "mappings/sprite/obj7F.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo24_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo43_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
