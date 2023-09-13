; ===========================================================================
; ----------------------------------------------------------------------------
; Object 76 - Spike block that slides out of the wall from MCZ
; ----------------------------------------------------------------------------
sliding_spikes_remaining_movement = objoff_36
; Sprite_28DF8:
Obj76:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj76_Index(pc,d0.w),d1
	jmp	Obj76_Index(pc,d1.w)
; ===========================================================================
; off_28E06:
Obj76_Index:	offsetTable
		offsetTableEntry.w Obj76_Init	; 0
		offsetTableEntry.w Obj76_Main	; 2
; ===========================================================================
; byte_28E0A:
Obj76_InitData:
	dc.b $40	; width_pixels
	dc.b $10	; y_radius
	dc.b   0	; mapping_frame
	even
; ===========================================================================
; loc_28E0E:
Obj76_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj76_MapUnc_28F3A,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo39_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0	; this is always 0 in the original layouts...
	lsr.w	#2,d0
	andi.w	#$1C,d0
	lea	Obj76_InitData(pc,d0.w),a2
	move.b	(a2)+,width_pixels(a0)
	move.b	(a2)+,y_radius(a0)
	move.b	(a2)+,mapping_frame(a0)
	move.w	x_pos(a0),objoff_34(a0)
	move.w	y_pos(a0),objoff_30(a0)
	andi.w	#$F,subtype(a0)
; loc_28E5E:
Obj76_Main:
	move.w	x_pos(a0),-(sp)
	moveq	#0,d0
	move.b	subtype(a0),d0
	move.w	Obj76_Modes(pc,d0.w),d1
	jsr	Obj76_Modes(pc,d1.w)
	move.w	(sp)+,d4
	tst.b	render_flags(a0)
	bpl.s	loc_28EC2
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	SolidObject, JmpTo19_SolidObject
	swap	d6
	andi.w	#touch_side_mask,d6
	beq.s	loc_28EC2
	move.b	d6,d0
	andi.b	#p1_touch_side,d0
	beq.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	jsrto	Touch_ChkHurt2, JmpTo_Touch_ChkHurt2
	bclr	#p1_pushing_bit,status(a0)
+
	andi.b	#p2_touch_side,d6
	beq.s	loc_28EC2
	lea	(Sidekick).w,a1 ; a1=character
	jsrto	Touch_ChkHurt2, JmpTo_Touch_ChkHurt2
	bclr	#p2_pushing_bit,status(a0)

loc_28EC2:
	move.w	objoff_34(a0),d0
	jmpto	MarkObjGone2, JmpTo5_MarkObjGone2
; ===========================================================================
; off_28ECA:
Obj76_Modes:	offsetTable
		offsetTableEntry.w Obj76_CheckPlayers	; 0
		offsetTableEntry.w Obj76_SlideOut	; 2
; ===========================================================================
; loc_28ECE:
Obj76_CheckPlayers:
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	Obj76_CheckPlayer
	lea	(Sidekick).w,a1 ; a1=character
; loc_28ED8:
Obj76_CheckPlayer:
	btst	#1,status(a1)
	bne.s	++	; rts
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$C0,d0
	btst	#0,status(a0)
	beq.s	+
	subi.w	#$100,d0
+
	cmpi.w	#$80,d0
	bhs.s	+	; rts
	move.w	y_pos(a1),d0
	sub.w	y_pos(a0),d0
	addi.w	#$10,d0
	cmpi.w	#$20,d0
	bhs.s	+	; rts
	move.b	#2,subtype(a0)
	move.w	#$80,sliding_spikes_remaining_movement(a0)
+	rts
; ===========================================================================
; loc_28F1E:
Obj76_SlideOut:
	tst.w	sliding_spikes_remaining_movement(a0)
	beq.s	++	; rts
	subq.w	#1,sliding_spikes_remaining_movement(a0)
	moveq	#-1,d0
	btst	#0,status(a0)
	beq.s	+
	neg.w	d0
+	add.w	d0,x_pos(a0)
+	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj76_MapUnc_28F3A:	include "mappings/sprite/obj76.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo_Touch_ChkHurt2 ; JmpTo
	jmp	(Touch_ChkHurt2).l
JmpTo39_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo19_SolidObject ; JmpTo
	jmp	(SolidObject).l
JmpTo5_MarkObjGone2 ; JmpTo
	jmp	(MarkObjGone2).l

	align 4
    endif
