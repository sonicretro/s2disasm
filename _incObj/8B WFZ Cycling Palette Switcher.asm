; ----------------------------------------------------------------------------
; Object 8B - Cycling palette switcher from Wing Fortress Zone
; ----------------------------------------------------------------------------
; Sprite_21392:
Obj8B:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj8B_Index(pc,d0.w),d1
	jsr	Obj8B_Index(pc,d1.w)
	jmp	(MarkObjGone3).l
; ===========================================================================
; off_213A6:
Obj8B_Index:	offsetTable
		offsetTableEntry.w Obj8B_Init	; 0
		offsetTableEntry.w Obj8B_Main	; 2
; ===========================================================================
word_213AA:
	dc.w   $20
	dc.w   $40	; 1
	dc.w   $80	; 2
	dc.w  $100	; 3
; ===========================================================================
; loc_213B2:
Obj8B_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj03_MapUnc_1FFB8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,0,0),art_tile(a0)
	jsrto	JmpTo12_Adjust2PArtPointer
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#5,priority(a0)
	move.b	subtype(a0),d0
	andi.w	#3,d0
	move.b	d0,mapping_frame(a0)
	add.w	d0,d0
	move.w	word_213AA(pc,d0.w),objoff_32(a0)
	move.w	x_pos(a0),d1
	lea	(MainCharacter).w,a1 ; a1=character
	cmp.w	x_pos(a1),d1
	bhs.s	loc_21402
	move.b	#1,objoff_34(a0)

loc_21402:
	lea	(Sidekick).w,a1 ; a1=character
	cmp.w	x_pos(a1),d1
	bhs.s	Obj8B_Main
	move.b	#1,objoff_35(a0)
; loc_21412:
Obj8B_Main:
	tst.w	(Debug_placement_mode).w
	bne.s	return_2146A
	move.w	x_pos(a0),d1
	lea	objoff_34(a0),a2 ; a2=object
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_2142A
	lea	(Sidekick).w,a1 ; a1=character

loc_2142A:
	tst.b	(a2)+
	bne.s	loc_2146C
	cmp.w	x_pos(a1),d1
	bhi.s	return_2146A
	move.b	#1,-1(a2)
	move.w	y_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	y_pos(a1),d4
	cmp.w	d2,d4
	blo.s	return_2146A
	cmp.w	d3,d4
	bhs.s	return_2146A
	btst	#render_flags.x_flip,render_flags(a0)
	bne.s	+
	move.b	#1,(WFZ_SCZ_Fire_Toggle).w
	rts
; ---------------------------------------------------------------------------
+	move.b	#0,(WFZ_SCZ_Fire_Toggle).w

return_2146A:
	rts
; ===========================================================================

loc_2146C:
	cmp.w	x_pos(a1),d1
	bls.s	return_2146A
	move.b	#0,-1(a2)
	move.w	y_pos(a0),d2
	move.w	d2,d3
	move.w	objoff_32(a0),d4
	sub.w	d4,d2
	add.w	d4,d3
	move.w	y_pos(a1),d4
	cmp.w	d2,d4
	blo.s	return_2146A
	cmp.w	d3,d4
	bhs.s	return_2146A
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	move.b	#1,(WFZ_SCZ_Fire_Toggle).w
	rts
; ---------------------------------------------------------------------------
+	move.b	#0,(WFZ_SCZ_Fire_Toggle).w
	rts
