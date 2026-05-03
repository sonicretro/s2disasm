; ----------------------------------------------------------------------------
; Object A3 - Flasher (firefly/glowbug badnik) from MCZ
; ----------------------------------------------------------------------------
; Sprite_3873E:
ObjA3:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA3_Index(pc,d0.w),d1
	jmp	ObjA3_Index(pc,d1.w)
; ===========================================================================
; off_3874C:
ObjA3_Index:	offsetTable
		offsetTableEntry.w loc_3875A	;  0
		offsetTableEntry.w loc_38766	;  2
		offsetTableEntry.w loc_38794	;  4
		offsetTableEntry.w loc_38832	;  6
		offsetTableEntry.w loc_3885C	;  8
		offsetTableEntry.w loc_38880	; $A
		offsetTableEntry.w loc_3888E	; $C
; ===========================================================================

loc_3875A:
	bsr.w	LoadSubObject
	move.w	#$40,objoff_2A(a0)
	rts
; ===========================================================================

loc_38766:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_38770
	jmpto	JmpTo2_MarkObjGone_P1
; ===========================================================================

loc_38770:
	addq.b	#2,routine(a0)
	move.w	#-$100,x_vel(a0)
	move.w	#$40,y_vel(a0)
	move.w	#2,objoff_2E(a0)
	clr.w	objoff_2A(a0)
	move.w	#$80,objoff_30(a0)
	jmpto	JmpTo2_MarkObjGone_P1
; ===========================================================================

loc_38794:
	subq.w	#1,objoff_30(a0)
	bmi.s	loc_387FC
	move.w	objoff_2A(a0),d0
	bmi.w	JmpTo65_DeleteObject
	bclr	#render_flags.x_flip,render_flags(a0)
	bclr	#status.npc.x_flip,status(a0)
	tst.w	x_vel(a0)
	bmi.s	loc_387C0
	bset	#render_flags.x_flip,render_flags(a0)
	bset	#status.npc.x_flip,status(a0)

loc_387C0:
	addq.w	#1,d0
	move.w	d0,objoff_2A(a0)
	move.w	objoff_2C(a0),d1
	move.w	word_38810(pc,d1.w),d2
	cmp.w	d2,d0
	blo.s	loc_387EC
	addq.w	#2,d1
	move.w	d1,objoff_2C(a0)
	lea	byte_38820(pc,d1.w),a1
	tst.b	(a1)+
	beq.s	loc_387E4
	neg.w	objoff_2E(a0)

loc_387E4:
	tst.b	(a1)+
	beq.s	loc_387EC
	neg.w	y_vel(a0)

loc_387EC:
	move.w	objoff_2E(a0),d0
	add.w	d0,x_vel(a0)
	jsrto	JmpTo26_ObjectMove
	jmpto	JmpTo2_MarkObjGone_P1
; ===========================================================================

loc_387FC:
	addq.b	#2,routine(a0)
	move.w	#$80,objoff_30(a0)
	ori.b	#$80,collision_flags(a0)
	jmpto	JmpTo2_MarkObjGone_P1
; ===========================================================================
word_38810:
	dc.w  $100
	dc.w  $1A0	; 1
	dc.w  $208	; 2
	dc.w  $285	; 3
	dc.w  $300	; 4
	dc.w  $340	; 5
	dc.w  $390	; 6
	dc.w  $440	; 7
byte_38820:
	dc.b $F0
	dc.b   0	; 1
	dc.b   1	; 2
	dc.b   1	; 3
	dc.b   0	; 4
	dc.b   1	; 5
	dc.b   1	; 6
	dc.b   1	; 7
	dc.b   0	; 8
	dc.b   1	; 9
	dc.b   0	; 10
	dc.b   1	; 11
	dc.b   1	; 12
	dc.b   0	; 13
	dc.b   0	; 14
	dc.b   1	; 15
	dc.b   0	; 16
	dc.b   1	; 17
	even
; ===========================================================================

loc_38832:
	move.b	routine(a0),d2
	lea	(Ani_objA3_a).l,a1
	jsrto	JmpTo25_AnimateSprite
	cmp.b	routine(a0),d2
	bne.s	loc_3884A
	jmpto	JmpTo2_MarkObjGone_P1
; ===========================================================================

loc_3884A:
	clr.l	mapping_frame(a0) ; Clear mapping_frame, anim_frame, anim, and prev_anim.
	clr.w	anim_frame_duration(a0)
	move.b	#3,mapping_frame(a0)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================

loc_3885C:
	subq.w	#1,objoff_30(a0)
	bmi.s	loc_38870
	lea	(Ani_objA3_b).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo2_MarkObjGone_P1
; ===========================================================================

loc_38870:
	addq.b	#2,routine(a0)
	clr.l	mapping_frame(a0) ; Clear mapping_frame, anim_frame, anim, and prev_anim.
	clr.w	anim_frame_duration(a0)
	jmpto	JmpTo2_MarkObjGone_P1
; ===========================================================================

loc_38880:
	lea	(Ani_objA3_c).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo2_MarkObjGone_P1
; ===========================================================================

loc_3888E:
	move.b	#4,routine(a0)
	move.w	#$80,objoff_30(a0)
	andi.b	#$7F,collision_flags(a0)
	clr.l	mapping_frame(a0) ; Clear mapping_frame, anim_frame, anim, and prev_anim.
	clr.w	anim_frame_duration(a0)
	jmpto	JmpTo2_MarkObjGone_P1
; ===========================================================================
; off_388AC:
ObjA3_SubObjData:
	subObjData ObjA3_MapUnc_388F0,make_art_tile(ArtTile_ArtNem_Flasher,0,1),1<<render_flags.level_fg,4,$10,6
