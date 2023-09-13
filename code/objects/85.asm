; ===========================================================================
; ----------------------------------------------------------------------------
; Object 85 - Spring from CNZ that you hold jump on to pull back further
; ----------------------------------------------------------------------------
; Sprite_2AB84:
Obj85:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj85_Index(pc,d0.w),d1
	jsr	Obj85_Index(pc,d1.w)
	move.w	#object_display_list_size*4,d0
	tst.w	(Two_player_mode).w
	beq.s	+
	jmpto	DisplaySprite3, JmpTo4_DisplaySprite3
; ===========================================================================
+
	move.w	x_pos(a0),d1
	andi.w	#$FF80,d1
	sub.w	(Camera_X_pos_coarse).w,d1
	cmpi.w	#$280,d1
	bhi.w	+
	jmpto	DisplaySprite3, JmpTo4_DisplaySprite3
; ===========================================================================
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	BranchTo_JmpTo43_DeleteObject
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)

BranchTo_JmpTo43_DeleteObject ; BranchTo
	jmpto	DeleteObject, JmpTo43_DeleteObject
; ===========================================================================
; off_2ABCE:
Obj85_Index:	offsetTable
		offsetTableEntry.w Obj85_Init		; 0
		offsetTableEntry.w Obj85_Up		; 2
		offsetTableEntry.w Obj85_Diagonal	; 4
; ===========================================================================
; loc_2ABD4:
Obj85_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj85_MapUnc_2B07E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZVertPlunger,0,0),art_tile(a0)
	tst.b	subtype(a0)
	beq.s	+
	move.l	#Obj85_MapUnc_2B0EC,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZDiagPlunger,0,0),art_tile(a0)
+
	jsrto	Adjust2PArtPointer, JmpTo49_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	bset	#6,render_flags(a0)
	move.b	#1,mainspr_mapframe(a0)
	tst.b	subtype(a0)
	beq.s	Obj85_Init_Up
	addq.b	#2,routine(a0)
	move.b	#$20,mainspr_width(a0)
	move.b	#$18,width_pixels(a0)
	move.w	x_pos(a0),objoff_2E(a0)
	move.w	y_pos(a0),objoff_34(a0)
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	addi.w	#0,d3
	move.b	#1,mainspr_childsprites(a0)
	lea	subspr_data(a0),a2
	move.w	d2,(a2)+	; sub2_x_pos
	move.w	d3,(a2)+	; sub2_y_pos
	move.w	#2,(a2)+	; sub2_mapframe
	bra.w	Obj85_Diagonal
; ===========================================================================
; loc_2AC54:
Obj85_Init_Up:
	move.b	#$18,mainspr_width(a0)
	move.b	#$18,width_pixels(a0)
	move.w	y_pos(a0),objoff_34(a0)
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	addi.w	#$20,d3
	move.b	#1,mainspr_childsprites(a0)
	lea	subspr_data(a0),a2
	move.w	d2,(a2)+	; sub2_x_pos
	move.w	d3,(a2)+	; sub2_y_pos
	move.w	#2,(a2)+	; sub2_mapframe
; loc_2AC84:
Obj85_Up:
	move.b	#0,objoff_3A(a0)
	move.w	objoff_34(a0),d0
	add.w	objoff_38(a0),d0
	move.w	d0,y_pos(a0)
	move.b	#2,sub2_mapframe(a0)
	cmpi.w	#$10,objoff_38(a0)
	blo.s	+
	move.b	#3,sub2_mapframe(a0)
+
	move.w	#$23,d1
	move.w	#$20,d2
	move.w	#$1D,d3
	move.w	x_pos(a0),d4
	lea	objoff_36(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	(Ctrl_1_Logical).w,d5
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	bsr.s	loc_2AD26
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	addq.w	#1,a2
	move.w	(Ctrl_2).w,d5
	moveq	#p2_standing_bit,d6
	bsr.s	loc_2AD26
	tst.w	objoff_36(a0)
	beq.s	loc_2AD14
	tst.w	objoff_38(a0)
	beq.s	return_2AD24
	moveq	#0,d0
	cmpi.b	#1,objoff_36(a0)
	bne.s	+
	or.w	(Ctrl_1_Logical).w,d0
+
	cmpi.b	#1,objoff_37(a0)
	bne.s	+
	or.w	(Ctrl_2).w,d0
+
	andi.w	#(button_B_mask|button_C_mask|button_A_mask)<<8,d0
	bne.s	return_2AD24
	move.w	#$202,objoff_36(a0)
	rts
; ===========================================================================

loc_2AD14:
	move.b	#1,mainspr_mapframe(a0)
	subq.w	#4,objoff_38(a0)
	bcc.s	return_2AD24
	clr.w	objoff_38(a0)

return_2AD24:
	rts
; ===========================================================================

loc_2AD26:
	move.b	(a2),d0
	bne.s	loc_2AD7A

loc_2AD2A:
	tst.w	(Debug_placement_mode).w
	bne.s	return_2AD78
	tst.w	y_vel(a1)
	bmi.s	return_2AD78
	jsrto	SolidObject_Always_SingleCharacter, JmpTo5_SolidObject_Always_SingleCharacter
	btst	d6,status(a0)
	beq.s	return_2AD78
	move.b	#$81,obj_control(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	#0,x_vel(a1)
	move.w	#0,y_vel(a1)
	move.w	#0,inertia(a1)
	bset	#2,status(a1)
	move.b	#$E,y_radius(a1)
	move.b	#7,x_radius(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	addq.b	#1,(a2)

return_2AD78:
	rts
; ===========================================================================

loc_2AD7A:
    if gameRevision>0
	cmpi.b	#4,routine(a1)
	bhs.s	return_2AD78
    endif
	subq.b	#1,d0
	bne.w	loc_2AE0C
	tst.b	render_flags(a1)
	bmi.s	loc_2ADB0
	bclr	d6,status(a0)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#2,routine(a1)
	move.b	#0,obj_control(a1)
	move.b	#0,(a2)
	rts
; ===========================================================================

loc_2ADB0:
	andi.w	#(button_B_mask|button_C_mask|button_A_mask)<<8,d5
	beq.s	loc_2ADFE
	tst.b	objoff_3A(a0)
	bne.s	loc_2ADFE
	move.b	#1,objoff_3A(a0)
	subq.b	#1,objoff_32(a0)
	bpl.s	loc_2ADDA
	move.b	#3,objoff_32(a0)
	cmpi.w	#$20,objoff_38(a0)
	beq.s	loc_2ADDA
	addq.w	#1,objoff_38(a0)

loc_2ADDA:
	subq.b	#1,objoff_33(a0)
	bpl.s	loc_2ADF8
	move.w	objoff_38(a0),d0
	subi.w	#$20,d0
	neg.w	d0
	lsr.w	#1,d0
	move.b	d0,objoff_33(a0)
	bchg	#2,mainspr_mapframe(a0)
	bra.s	loc_2ADFE
; ===========================================================================

loc_2ADF8:
	move.b	#1,mainspr_mapframe(a0)

loc_2ADFE:
	move.w	y_pos(a0),d0
	subi.w	#$2E,d0
	move.w	d0,y_pos(a1)
	rts
; ===========================================================================

loc_2AE0C:
	move.b	#0,(a2)
	bclr	d6,status(a0)
	beq.w	loc_2AD2A
	move.w	objoff_38(a0),d0
	addi.w	#$10,d0
	lsl.w	#7,d0
	neg.w	d0
	move.w	d0,y_vel(a1)
	move.w	#0,x_vel(a1)
	move.w	#$800,inertia(a1)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#2,routine(a1)
	move.b	#0,obj_control(a1)
	move.w	#SndID_CNZLaunch,d0
	jmp	(PlaySound).l
; ===========================================================================
; loc_2AE56:
Obj85_Diagonal:
	move.b	#0,objoff_3A(a0)
	move.w	objoff_38(a0),d1
	lsr.w	#1,d1
	move.w	objoff_2E(a0),d0
	sub.w	d1,d0
	move.w	d0,x_pos(a0)
	move.w	objoff_34(a0),d0
	add.w	d1,d0
	move.w	d0,y_pos(a0)
	move.b	#2,sub2_mapframe(a0)
	cmpi.w	#$10,objoff_38(a0)
	blo.s	+
	move.b	#3,sub2_mapframe(a0)
+
	move.w	#$23,d1
	move.w	#8,d2
	move.w	#5,d3
	move.w	x_pos(a0),d4
	lea	objoff_36(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	(Ctrl_1_Logical).w,d5
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	bsr.s	loc_2AF06
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	addq.w	#1,a2
	move.w	(Ctrl_2).w,d5
	moveq	#p2_standing_bit,d6
	bsr.s	loc_2AF06
	tst.w	objoff_36(a0)
	beq.s	loc_2AEF4
	tst.w	objoff_38(a0)
	beq.s	return_2AF04
	moveq	#0,d0
	cmpi.b	#1,objoff_36(a0)
	bne.s	+
	or.w	(Ctrl_1_Logical).w,d0
+
	cmpi.b	#1,objoff_37(a0)
	bne.s	+
	or.w	(Ctrl_2).w,d0
+
	andi.w	#(button_B_mask|button_C_mask|button_A_mask)<<8,d0
	bne.s	return_2AF04
	move.w	#$202,objoff_36(a0)
	rts
; ===========================================================================

loc_2AEF4:
	move.b	#1,mainspr_mapframe(a0)
	subq.w	#4,objoff_38(a0)
	bcc.s	return_2AF04
	clr.w	objoff_38(a0)

return_2AF04:
	rts
; ===========================================================================

loc_2AF06:
	move.b	(a2),d0
	bne.s	loc_2AF7A
	tst.w	(Debug_placement_mode).w
	bne.s	return_2AF78
	tst.w	y_vel(a1)
	bmi.s	return_2AF78
	jsrto	SolidObject_Always_SingleCharacter, JmpTo5_SolidObject_Always_SingleCharacter
	btst	d6,status(a0)
	bne.s	loc_2AF2E
	move.b	d6,d0
	addq.b	#pushing_bit_delta,d0
	btst	d0,status(a0)
	beq.s	return_2AF78
	bset	d6,status(a0)

loc_2AF2E:
	move.b	#$81,obj_control(a1)
	move.w	x_pos(a0),x_pos(a1)
	addi.w	#$13,x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	subi.w	#$13,y_pos(a1)
	move.w	#0,x_vel(a1)
	move.w	#0,y_vel(a1)
	move.w	#0,inertia(a1)
	bset	#2,status(a1)
	move.b	#$E,y_radius(a1)
	move.b	#7,x_radius(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	addq.b	#1,(a2)

return_2AF78:
	rts
; ===========================================================================

loc_2AF7A:
    if gameRevision>0
	cmpi.b	#4,routine(a1)
	bhs.s	return_2AF78
    endif
	subq.b	#1,d0
	bne.w	loc_2B018
	tst.b	render_flags(a1)
	bmi.s	loc_2AFB0
	bclr	d6,status(a0)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#2,routine(a1)
	move.b	#0,obj_control(a1)
	move.b	#0,(a2)
	rts
; ===========================================================================

loc_2AFB0:
	andi.w	#(button_B_mask|button_C_mask|button_A_mask)<<8,d5
	beq.s	loc_2AFFE
	tst.b	objoff_3A(a0)
	bne.s	loc_2AFFE
	move.b	#1,objoff_3A(a0)
	subq.b	#1,objoff_32(a0)
	bpl.s	loc_2AFDA
	move.b	#3,objoff_32(a0)
	cmpi.w	#$1C,objoff_38(a0)
	beq.s	loc_2AFDA
	addq.w	#1,objoff_38(a0)

loc_2AFDA:
	subq.b	#1,objoff_33(a0)
	bpl.s	loc_2AFF8
	move.w	objoff_38(a0),d0
	subi.w	#$1C,d0
	neg.w	d0
	lsr.w	#1,d0
	move.b	d0,objoff_33(a0)
	bchg	#2,mainspr_mapframe(a0)
	bra.s	loc_2AFFE
; ===========================================================================

loc_2AFF8:
	move.b	#1,mainspr_mapframe(a0)

loc_2AFFE:
	move.w	x_pos(a0),d0
	addi.w	#$13,d0
	move.w	d0,x_pos(a1)
	move.w	y_pos(a0),d0
	subi.w	#$13,d0
	move.w	d0,y_pos(a1)
	rts
; ===========================================================================

loc_2B018:
	move.b	#0,(a2)
	bclr	d6,status(a0)
	beq.w	return_2AF78
	move.w	objoff_38(a0),d0
	addi_.w	#4,d0
	lsl.w	#7,d0
	move.w	d0,x_vel(a1)
	neg.w	d0
	move.w	d0,y_vel(a1)
	move.w	#$800,inertia(a1)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	tst.b	subtype(a0)
	bpl.s	loc_2B068
	neg.w	d0
	move.w	d0,inertia(a1)
	bclr	#0,status(a1)
	bclr	#1,status(a1)
	move.b	#-$20,angle(a1)

loc_2B068:
	move.b	#2,routine(a1)
	move.b	#0,obj_control(a1)
	move.w	#SndID_CNZLaunch,d0
	jmp	(PlaySound).l
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj85_MapUnc_2B07E:	include "mappings/sprite/obj85_a.asm"
Obj85_MapUnc_2B0EC:	include "mappings/sprite/obj85_b.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo4_DisplaySprite3 ; JmpTo
	jmp	(DisplaySprite3).l
JmpTo43_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo49_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo5_SolidObject_Always_SingleCharacter ; JmpTo
	jmp	(SolidObject_Always_SingleCharacter).l

	align 4
    endif
