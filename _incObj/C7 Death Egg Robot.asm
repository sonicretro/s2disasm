; ----------------------------------------------------------------------------
; Object C7 - Eggrobo (final boss) from Death Egg
; ----------------------------------------------------------------------------
; Sprite_3D4C8:
ObjC7:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC7_Index(pc,d0.w),d1
	jmp	ObjC7_Index(pc,d1.w)
; ===========================================================================
; off_3D4D6:
ObjC7_Index:	offsetTable
		offsetTableEntry.w ObjC7_Init	;   0
		offsetTableEntry.w ObjC7_Body	;   2
		offsetTableEntry.w ObjC7_Shoulder	;   4
		offsetTableEntry.w ObjC7_FrontLowerLeg	;   6
		offsetTableEntry.w ObjC7_FrontForearm	;   8
		offsetTableEntry.w ObjC7_Arm	;  $A
		offsetTableEntry.w ObjC7_FrontThigh	;  $C
		offsetTableEntry.w ObjC7_Head	;  $E
		offsetTableEntry.w ObjC7_Jet	; $10
		offsetTableEntry.w ObjC7_BackLowerLeg	; $12
		offsetTableEntry.w ObjC7_BackForearm	; $14
		offsetTableEntry.w ObjC7_BackThigh	; $16
		offsetTableEntry.w ObjC7_TargettingSensor	; $18
		offsetTableEntry.w ObjC7_TargettingLock	; $1A
		offsetTableEntry.w ObjC7_EggmanBomb	; $1C
		offsetTableEntry.w ObjC7_FallingPieces	; $1E
		offsetTableEntry.w ObjC7_SetupEnding	; $20
; ===========================================================================
; loc_3D4F8:
ObjC7_Init:
	lea	ObjC7_SubObjData(pc),a1
	bsr.w	LoadSubObject_Part3
	move.b	subtype(a0),routine(a0)
	rts
; ===========================================================================
;loc_3D508
ObjC7_Body:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3D51A(pc,d0.w),d1
	jsr	off_3D51A(pc,d1.w)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3D51A:	offsetTable
		offsetTableEntry.w loc_3D52A	;  0
		offsetTableEntry.w loc_3D5A8	;  2
		offsetTableEntry.w loc_3D5C2	;  4
		offsetTableEntry.w loc_3D5EA	;  6
		offsetTableEntry.w loc_3D62E	;  8
		offsetTableEntry.w loc_3D640	; $A
		offsetTableEntry.w loc_3D684	; $C
		offsetTableEntry.w loc_3D8D2	; $E
; ===========================================================================

loc_3D52A:
	addq.b	#2,routine_secondary(a0)
	move.b	#3,mapping_frame(a0)
	move.b	#5,priority(a0)
	lea	(ChildObjC7_Shoulder).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_FrontForearm).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_FrontLowerLeg).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_Arm).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_FrontThigh).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_Head).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_Jet).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_BackLowerLeg).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_BackForearm).l,a2
	bsr.w	LoadChildObject
	lea	(ChildObjC7_BackThigh).l,a2
	bsr.w	LoadChildObject
	lea	(ObjC7_ChildDeltas).l,a1
	bra.w	ObjC7_PositionChildren
; ===========================================================================

loc_3D5A8:
	btst	#status.npc.misc,status(a0)
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.b	#60,anim_frame_duration(a0)
	moveq	#signextendB(MusID_FadeOut),d0
	jmpto	JmpTo12_PlaySound
; ===========================================================================

loc_3D5C2:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.b	#$79,anim_frame_duration(a0)
	move.w	#-$100,y_vel(a0)
	movea.w	objoff_38(a0),a1 ; a1=object
	move.b	#4,routine_secondary(a1)
	moveq	#signextendB(MusID_EndBoss),d0
	jmpto	JmpTo5_PlayMusic
; ===========================================================================

loc_3D5EA:
	subq.b	#1,anim_frame_duration(a0)
	beq.s	+
	moveq	#signextendB(SndID_Rumbling),d0
	jsrto	JmpTo12_PlaySound
	jsrto	JmpTo26_ObjectMove
	lea	(ObjC7_ChildDeltas).l,a1
	bra.w	ObjC7_PositionChildren
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	clr.w	y_vel(a0)
	move.b	#$1F,anim_frame_duration(a0)
	move.b	#$16,collision_flags(a0)
	move.b	#$C,collision_property(a0)
	bsr.w	ObjC7_InitCollision
	movea.w	objoff_38(a0),a1 ; a1=object
	move.b	#6,routine_secondary(a1)
	rts
; ===========================================================================

loc_3D62E:
	bsr.w	ObjC7_CheckHit
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	rts
; ===========================================================================

loc_3D640:
	bsr.w	ObjC7_CheckHit
	addq.b	#2,routine_secondary(a0)
	move.b	#$20,anim_frame_duration(a0)
	move.b	angle(a0),d0
	addq.b	#1,d0
	move.b	d0,angle(a0)
	andi.w	#3,d0
	move.b	byte_3D680(pc,d0.w),d0
	move.b	d0,anim(a0)
	clr.b	prev_anim(a0)
	cmpi.b	#2,d0
	bne.s	+	; rts
	movea.w	objoff_38(a0),a1 ; a1=object
	move.b	#4,routine_secondary(a1)
	move.b	#2,anim(a1)
+
	rts
; ===========================================================================
byte_3D680:
	dc.b   2
	dc.b   0	; 1
	dc.b   2	; 2
	dc.b   4	; 3
	even
; ===========================================================================

loc_3D684:
	bsr.w	ObjC7_CheckHit
	moveq	#0,d0
	move.b	anim(a0),d0
	move.w	off_3D696(pc,d0.w),d1
	jmp	off_3D696(pc,d1.w)
; ===========================================================================
off_3D696:	offsetTable
		offsetTableEntry.w loc_3D6AA	; 0
		offsetTableEntry.w loc_3D702	; 2
		offsetTableEntry.w loc_3D83C	; 4
; ===========================================================================
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,anim(a0)
	rts
; ===========================================================================

loc_3D6AA:
	moveq	#0,d0
	move.b	prev_anim(a0),d0
	move.w	off_3D6B8(pc,d0.w),d1
	jmp	off_3D6B8(pc,d1.w)
; ===========================================================================
off_3D6B8:	offsetTable
		offsetTableEntry.w loc_3D6C0	; 0
		offsetTableEntry.w loc_3D6CE	; 2
		offsetTableEntry.w loc_3D6C0	; 4
		offsetTableEntry.w loc_3D6E8	; 6
; ===========================================================================

loc_3D6C0:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	rts
; ===========================================================================

loc_3D6CE:
	lea	(off_3E40C).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	move.b	#$40,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D6E8:
	lea	(off_3E42C).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	subq.b	#2,routine_secondary(a0)
	move.b	#$40,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D702:
	moveq	#0,d0
	move.b	prev_anim(a0),d0
	move.w	off_3D710(pc,d0.w),d1
	jmp	off_3D710(pc,d1.w)
; ===========================================================================
off_3D710:	offsetTable
		offsetTableEntry.w loc_3D6C0	;  0
		offsetTableEntry.w loc_3D720	;  2
		offsetTableEntry.w loc_3D744	;  4
		offsetTableEntry.w loc_3D6C0	;  6
		offsetTableEntry.w loc_3D784	;  8
		offsetTableEntry.w loc_3D7B8	; $A
		offsetTableEntry.w loc_3D7F0	; $C
		offsetTableEntry.w loc_3D82E	; $C
; ===========================================================================

loc_3D720:
	lea	(off_3E3D0).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	move.b	#$80,anim_frame_duration(a0)
	clr.w	x_vel(a0)
	move.w	#-$200,y_vel(a0)
	rts
; ===========================================================================

loc_3D744:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	++
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+
	moveq	#signextendB(SndID_Fire),d0
	jsrto	JmpTo_PlaySoundLocal
+
	jsrto	JmpTo26_ObjectMove
	lea	(ObjC7_ChildDeltas).l,a1
	bra.w	ObjC7_PositionChildren
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	clr.w	y_vel(a0)
	lea	(ChildObjC7_TargettingSensor).l,a2
	bsr.w	LoadChildObject
	clr.w	x_vel(a0)
	clr.w	objoff_28(a0)
	rts
; ===========================================================================

loc_3D784:
	move.w	objoff_28(a0),d0
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	move.w	d0,x_pos(a0)
	bclr	#render_flags.x_flip,render_flags(a0)
	cmpi.w	#$780,d0
	bhs.s	+
	bset	#render_flags.x_flip,render_flags(a0)
+
	bsr.w	loc_3E168
	move.w	#$800,y_vel(a0)
	move.b	#$20,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D7B8:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	jsrto	JmpTo26_ObjectMove
	lea	(ObjC7_ChildDeltas).l,a1
	bra.w	ObjC7_PositionChildren
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	clr.w	y_vel(a0)
	move.b	#1,(Screen_Shaking_Flag).w
	move.w	#$40,(DEZ_Shake_Timer).w
	movea.w	objoff_38(a0),a1 ; a1=object
	move.b	#6,routine_secondary(a1)
	moveq	#signextendB(SndID_Smash),d0
	jmpto	JmpTo12_PlaySound
; ===========================================================================

loc_3D7F0:
	lea	(off_3E30A).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	lea	(ObjC7_ChildDeltas).l,a1
	bsr.w	ObjC7_PositionChildren
	bsr.w	Obj_GetOrientationToPlayer
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	subq.w	#2,d0
+
	tst.w	d0
	bne.s	+
	subq.b	#2,routine_secondary(a0)
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	move.b	#$60,anim_frame_duration(a0)
	bra.w	CreateEggmanBombs
; ===========================================================================

loc_3D82E:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	subq.b	#2,routine_secondary(a0)
	rts
; ===========================================================================

loc_3D83C:
	moveq	#0,d0
	move.b	prev_anim(a0),d0
	move.w	off_3D84A(pc,d0.w),d1
	jmp	off_3D84A(pc,d1.w)
; ===========================================================================
off_3D84A:	offsetTable
		offsetTableEntry.w loc_3D6C0	;  0
		offsetTableEntry.w loc_3D856	;  2
		offsetTableEntry.w loc_3D6C0	;  4
		offsetTableEntry.w loc_3D89E	;  6
		offsetTableEntry.w loc_3D6C0	;  8
		offsetTableEntry.w loc_3D8B8	; $A
; ===========================================================================

loc_3D856:
	bset	#status.npc.p2_pushing,status(a0)
	lea	(off_3E2F6).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	bsr.w	Obj_GetOrientationToPlayer
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	subq.w	#2,d0
+
	tst.w	d0
	bne.s	+
	addq.b	#2,prev_anim(a0)
	move.b	#$40,anim_frame_duration(a0)
	bset	#status.npc.p2_standing,status(a0)
	rts
; ---------------------------------------------------------------------------
+
	move.b	#8,prev_anim(a0)
	move.b	#$20,anim_frame_duration(a0)
	bra.w	CreateEggmanBombs
; ===========================================================================

loc_3D89E:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,prev_anim(a0)
	bset	#status.npc.p1_pushing,status(a0)
	move.b	#$40,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D8B8:
	lea	(off_3E300).l,a1
	bsr.w	loc_3E1AA
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	subq.b	#2,routine_secondary(a0)
	bclr	#status.npc.p2_pushing,status(a0)
	rts
; ===========================================================================

loc_3D8D2:
	moveq	#0,d0
	move.b	anim(a0),d0
	move.w	off_3D8E0(pc,d0.w),d1
	jmp	off_3D8E0(pc,d1.w)
; ===========================================================================
off_3D8E0:	offsetTable
		offsetTableEntry.w loc_3D8E6	; 0
		offsetTableEntry.w loc_3D922	; 2
		offsetTableEntry.w loc_3D93C	; 4
; ===========================================================================

loc_3D8E6:
	jsrto	JmpTo_Boss_LoadExplosion
	jsrto	JmpTo8_ObjectMoveAndFall
	move.w	y_pos(a0),d0
	cmpi.w	#$15C,d0
	bhs.s	+
	rts
; ---------------------------------------------------------------------------
+
	move.w	#$15C,y_pos(a0)
	move.w	y_vel(a0),d0
	bmi.s	+
	lsr.w	#2,d0
	cmpi.w	#$100,d0
	blo.s	+
	neg.w	d0
	move.w	d0,y_vel(a0)
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,anim(a0)
	move.b	#$40,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_3D922:
	subq.b	#1,anim_frame_duration(a0)
	bmi.s	+
	jmpto	JmpTo_Boss_LoadExplosion
; ---------------------------------------------------------------------------
+
	addq.b	#2,anim(a0)
	st.b	(Control_Locked).w
	move.w	#$1000,(Camera_Max_X_pos).w
	rts
; ===========================================================================

loc_3D93C:
	move.w	#(button_right_mask<<8)|button_right_mask,(Ctrl_1_Logical).w
	cmpi.w	#$840,(Camera_X_pos).w
	bhs.s	+
	rts
; ---------------------------------------------------------------------------
+
	move.b	#$20,routine(a0)
	clr.b	routine_secondary(a0)
	move.w	#$20,objoff_2A(a0)
	move.b	#1,(Screen_Shaking_Flag).w
	move.w	#$1000,(DEZ_Shake_Timer).w
	movea.w	objoff_36(a0),a1 ; a1=object
	jmpto	JmpTo6_DeleteObject2
; ===========================================================================
;loc_3D970
ObjC7_SetupEnding:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+
	; PlaySound ends up being clogged up by the explosion sounds, both in
	; the queue and sound channels, meaning this is effectively useless.
	moveq	#signextendB(SndID_Rumbling2),d0
	jsrto	JmpTo12_PlaySound
	subq.w	#1,objoff_2A(a0)
+
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),d0
	sub.w	objoff_2A(a0),d0
	move.w	d0,x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	bsr.w	loc_3DFBA
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3D9AC(pc,d0.w),d1
	jmp	off_3D9AC(pc,d1.w)
; ===========================================================================
off_3D9AC:	offsetTable
		offsetTableEntry.w loc_3D9B0	; 0
		offsetTableEntry.w loc_3D9D6	; 2
; ===========================================================================

loc_3D9B0:
	lea	(MainCharacter).w,a1 ; a1=character
	cmpi.w	#$EC0,x_pos(a1)
	bhs.s	loc_3D9BE
	rts
; ===========================================================================

loc_3D9BE:
	addq.b	#2,routine_secondary(a0)
	move.w	#$3F,(Palette_fade_range).w
	move.b	#$16,anim_frame_duration(a0)
	move.w	#$7FFF,(PalCycle_Timer).w
	rts
; ===========================================================================

loc_3D9D6:
	subq.b	#1,anim_frame_duration(a0)
	beq.w	+
	movea.l	a0,a1
	lea	(Normal_palette).w,a0

	moveq	#$3F,d0
-	jsrto	JmpTo_Pal_FadeToWhite.UpdateColour
	dbf	d0,-
	movea.l	a1,a0
	rts
; ---------------------------------------------------------------------------
+
	move.l	#$EEE0EEE,d0
	lea	(Normal_palette).w,a1

	moveq	#$1F,d6
-	move.l	d0,(a1)+
	dbf	d6,-

	moveq	#signextendB(MusID_FadeOut),d0
    if fixBugs
	jsr	(PlayMusic).l
    else
	; PlaySound ends up being clogged up by the explosion sounds,
	; preventing the music from fading out as it should.
	jsrto	JmpTo12_PlaySound
    endif
	move.b	#GameModeID_EndingSequence,(Game_Mode).w ; => EndingSequence
	jmpto	JmpTo65_DeleteObject
; ===========================================================================

ObjC7_Shoulder:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DA34(pc,d0.w),d1
	jsr	off_3DA34(pc,d1.w)
	lea	byte_3DA38(pc),a1
	bsr.w	loc_3E282
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DA34:	offsetTable
		offsetTableEntry.w loc_3DA3C	; 0
		offsetTableEntry.w return_3DA48	; 2
; ===========================================================================
byte_3DA38:
	dc.w   $C
	dc.w -$14
; ===========================================================================

loc_3DA3C:
	addq.b	#2,routine_secondary(a0)
	move.b	#4,mapping_frame(a0)
	rts
; ===========================================================================

return_3DA48:
	rts
; ===========================================================================
;loc_3DA4A
ObjC7_FrontLowerLeg:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DA62(pc,d0.w),d1
	jsr	off_3DA62(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DA62:	offsetTable
		offsetTableEntry.w loc_3DA66	; 0
		offsetTableEntry.w return_3DA72	; 2
; ===========================================================================

loc_3DA66:
	addq.b	#2,routine_secondary(a0)
	move.b	#$B,mapping_frame(a0)
	rts
; ===========================================================================

return_3DA72:
	rts
; ===========================================================================
;loc_3DA74
ObjC7_FrontForearm:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DA96(pc,d0.w),d1
	jsr	off_3DA96(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	btst	#status.npc.p2_pushing,status(a0)
	bne.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DA96:	offsetTable
		offsetTableEntry.w loc_3DAA0	; 0
		offsetTableEntry.w loc_3DAAC	; 2
		offsetTableEntry.w loc_3DACC	; 4
		offsetTableEntry.w loc_3DB32	; 6
		offsetTableEntry.w loc_3DB5A	; 8
; ===========================================================================

loc_3DAA0:
	addq.b	#2,routine_secondary(a0)
	move.b	#6,mapping_frame(a0)
	rts
; ===========================================================================

loc_3DAAC:
	movea.w	objoff_2C(a0),a1 ; a1=object
	bclr	#status.npc.p2_standing,status(a1)
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$10,objoff_2A(a0)
	move.w	y_pos(a0),objoff_2E(a0)
	rts
; ===========================================================================

loc_3DACC:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	addi.w	#$20,y_vel(a0)
	jmpto	JmpTo26_ObjectMove
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$20,objoff_2A(a0)
	bsr.w	Obj_GetOrientationToPlayer
	abs.w	d2
	cmpi.w	#$100,d2
	blo.s	+
	move.w	#$FF,d2
+
	andi.w	#$C0,d2
	lsr.w	#5,d2
	move.w	word_3DB2A(pc,d2.w),d2
	tst.w	d1
	bne.s	+
	neg.w	d2
+
	move.w	d2,y_vel(a0)
	move.w	#$800,d2
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#render_flags.x_flip,render_flags(a0)
	bne.s	+
	neg.w	d2
+
	move.w	d2,x_vel(a0)
	moveq	#signextendB(SndID_SpindashRelease),d0
	jmpto	JmpTo12_PlaySound
; ===========================================================================
word_3DB2A:
	dc.w  $200
	dc.w  $100	; 1
	dc.w   $80	; 2
	dc.w	 0	; 3
; ===========================================================================

loc_3DB32:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	jmpto	JmpTo26_ObjectMove
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	neg.w	x_vel(a0)
	move.w	#$20,objoff_2A(a0)
	move.w	objoff_2E(a0),d0
	sub.w	y_pos(a0),d0
	asl.w	#3,d0
	move.w	d0,y_vel(a0)
	rts
; ===========================================================================

loc_3DB5A:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	jmpto	JmpTo26_ObjectMove
; ---------------------------------------------------------------------------
+
	move.b	#2,routine_secondary(a0)
	clr.w	x_vel(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================
;loc_3DB74
ObjC7_Arm:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DB8C(pc,d0.w),d1
	jsr	off_3DB8C(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DB8C:	offsetTable
		offsetTableEntry.w loc_3DB90	; 0
		offsetTableEntry.w return_3DB9C	; 2
; ===========================================================================

loc_3DB90:
	addq.b	#2,routine_secondary(a0)
	move.b	#5,mapping_frame(a0)
	rts
; ===========================================================================

return_3DB9C:
	rts
; ===========================================================================
;loc_3DB9E
ObjC7_FrontThigh:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DBB6(pc,d0.w),d1
	jsr	off_3DBB6(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DBB6:	offsetTable
		offsetTableEntry.w loc_3DBBA	; 0
		offsetTableEntry.w return_3DBC6	; 2
; ===========================================================================

loc_3DBBA:
	addq.b	#2,routine_secondary(a0)
	move.b	#$A,mapping_frame(a0)
	rts
; ===========================================================================

return_3DBC6:
	rts
; ===========================================================================
;loc_3DBC8
ObjC7_Head:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DBE8(pc,d0.w),d1
	jsr	off_3DBE8(pc,d1.w)
	lea	byte_3DBF2(pc),a1
	bsr.w	loc_3E282
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DBE8:	offsetTable
		offsetTableEntry.w loc_3DBF6	; 0
		offsetTableEntry.w loc_3DC02	; 2
		offsetTableEntry.w loc_3DC1C	; 4
		offsetTableEntry.w loc_3DC2A	; 6
		offsetTableEntry.w loc_3DC46	; 8
; ===========================================================================
byte_3DBF2:
	dc.w    0
	dc.w -$34
; ===========================================================================

loc_3DBF6:
	addq.b	#2,routine_secondary(a0)
	move.b	#$15,mapping_frame(a0)
	rts
; ===========================================================================

loc_3DC02:
	movea.w	(DEZ_Eggman).w,a1
	btst	#status.npc.p1_standing,status(a1)
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)
	rts
; ===========================================================================

loc_3DC1C:
	lea	(Ani_objC7_a).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DC2A:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	jmpto	JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	movea.w	objoff_2C(a0),a1 ; a1=object
	bset	#status.npc.misc,status(a1)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DC46:
	move.b	#-1,collision_property(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
;loc_3DC50
ObjC7_Jet:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DC66(pc,d0.w),d1
	jsr	off_3DC66(pc,d1.w)
	lea	byte_3DC70(pc),a1
	bra.w	loc_3E282
; ===========================================================================
off_3DC66:	offsetTable
		offsetTableEntry.w loc_3DC74
		offsetTableEntry.w loc_3DC80
		offsetTableEntry.w loc_3DC86
		offsetTableEntry.w loc_3DC94
		offsetTableEntry.w loc_3DC80
; ===========================================================================
byte_3DC70:
	dc.w  $38
	dc.w  $18
; ===========================================================================

loc_3DC74:
	addq.b	#2,routine_secondary(a0)
	move.b	#$C,mapping_frame(a0)
	rts
; ===========================================================================

loc_3DC80:
	move.b	#3,anim(a0)

loc_3DC86:
	lea	(Ani_objC7_b).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DC94:
	move.b	#1,anim(a0)
	bra.s	loc_3DC86
; ===========================================================================
;loc_3DC9C
ObjC7_BackLowerLeg:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DCB4(pc,d0.w),d1
	jsr	off_3DCB4(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DCB4:	offsetTable
		offsetTableEntry.w loc_3DCB8	; 0
		offsetTableEntry.w return_3DCCA	; 2
; ===========================================================================

loc_3DCB8:
	addq.b	#2,routine_secondary(a0)
	move.b	#$B,mapping_frame(a0)
	move.b	#5,priority(a0)
	rts
; ===========================================================================

return_3DCCA:
	rts
; ===========================================================================
;loc_3DCCC
ObjC7_BackForearm:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DCE4(pc,d0.w),d1
	jsr	off_3DCE4(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DCE4:	offsetTable
		offsetTableEntry.w loc_3DCEE	; 0
		offsetTableEntry.w loc_3DD00	; 2
		offsetTableEntry.w loc_3DACC	; 4
		offsetTableEntry.w loc_3DB32	; 6
		offsetTableEntry.w loc_3DB5A	; 8
; ===========================================================================

loc_3DCEE:
	addq.b	#2,routine_secondary(a0)
	move.b	#6,mapping_frame(a0)
	move.b	#5,priority(a0)
	rts
; ===========================================================================

loc_3DD00:
	movea.w	objoff_2C(a0),a1 ; a1=object
	bclr	#status.npc.p1_pushing,status(a1)
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$10,objoff_2A(a0)
	move.w	y_pos(a0),objoff_2E(a0)
	rts
; ===========================================================================
;loc_3DD20
ObjC7_BackThigh:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DD38(pc,d0.w),d1
	jsr	off_3DD38(pc,d1.w)
	tst.b	id(a0)
	beq.w	return_37A48
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
off_3DD38:	offsetTable
		offsetTableEntry.w loc_3DD3C	; 0
		offsetTableEntry.w return_3DD4E	; 2
; ===========================================================================

loc_3DD3C:
	addq.b	#2,routine_secondary(a0)
	move.b	#$A,mapping_frame(a0)
	move.b	#5,priority(a0)
	rts
; ===========================================================================

return_3DD4E:
	rts
; ===========================================================================
;loc_3DD50
ObjC7_TargettingSensor:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DD5E(pc,d0.w),d1
	jmp	off_3DD5E(pc,d1.w)
; ===========================================================================
off_3DD5E:	offsetTable
		offsetTableEntry.w loc_3DD64	; 0
		offsetTableEntry.w loc_3DDA6	; 2
		offsetTableEntry.w loc_3DE3C	; 4
; ===========================================================================

loc_3DD64:
	addq.b	#2,routine_secondary(a0)
	move.b	#$10,mapping_frame(a0)
	ori.w	#high_priority,art_tile(a0)
	move.b	#1,priority(a0)
	move.w	#$A0,objoff_2A(a0)
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.w	x_vel(a1),objoff_30(a0)
	move.w	y_vel(a1),objoff_32(a0)
	move.w	#$18,angle(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DDA6:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3DE0A
	lea	next_object(a0),a1 ; a1=object
	movea.l	a1,a2
	move.w	-(a1),y_vel(a0)
	move.w	-(a1),x_vel(a0)

	moveq	#2,d6
-	move.l	-(a1),-(a2)
	dbf	d6,-

	lea	(MainCharacter).w,a2 ; a2=character
	move.w	x_vel(a2),d0
	bne.s	+
	move.w	x_pos(a2),x_pos(a0)
+
	move.w	d0,(a1)+
	move.w	y_vel(a2),d0
	bne.s	+
	move.w	y_pos(a2),y_pos(a0)
+
	move.w	d0,(a1)+
	jsrto	JmpTo26_ObjectMove
	lea	(Ani_objC7_c).l,a1
	jsrto	JmpTo25_AnimateSprite
	subq.b	#1,angle(a0)
	bpl.s	+
	subq.b	#1,objoff_27(a0)
	move.b	objoff_27(a0),angle(a0)
	moveq	#signextendB(SndID_Beep),d0
	jsrto	JmpTo12_PlaySound
+
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DE0A:
	addq.b	#2,routine_secondary(a0)
	move.w	#$40,objoff_2A(a0)
	move.b	#4,angle(a0)
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	lea	(ChildObjC7_TargettingLock).l,a2
	bsr.w	LoadChildObject
	clr.w	x_vel(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DE3C:
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3DE62
	lea	(Ani_objC7_c).l,a1
	jsrto	JmpTo25_AnimateSprite
	subq.b	#1,angle(a0)
	bpl.s	+
	move.b	#4,angle(a0)
	moveq	#signextendB(SndID_Beep),d0
	jsrto	JmpTo12_PlaySound
+
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DE62:
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.w	x_pos(a0),objoff_28(a1)
	jmpto	JmpTo65_DeleteObject
; ===========================================================================
;loc_3DE70
ObjC7_TargettingLock:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DE7E(pc,d0.w),d1
	jmp	off_3DE7E(pc,d1.w)
; ===========================================================================
off_3DE7E:	offsetTable
		offsetTableEntry.w loc_3DE82	; 0
		offsetTableEntry.w loc_3DEA2	; 2
; ===========================================================================

loc_3DE82:
	addq.b	#2,routine_secondary(a0)
	move.b	#$14,mapping_frame(a0)
	move.b	#1,priority(a0)
	ori.w	#high_priority,art_tile(a0)
	move.w	#4,objoff_2A(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DEA2:
	movea.w	objoff_2C(a0),a1 ; a1=object
	tst.b	(a1)
	beq.w	JmpTo65_DeleteObject
	subq.w	#1,objoff_2A(a0)
	bne.s	+
	move.w	#4,objoff_2A(a0)
	bchg	#palette_bit_0,art_tile(a0)
+
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
;loc_3DEC2
ObjC7_EggmanBomb:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3DED0(pc,d0.w),d1
	jmp	off_3DED0(pc,d1.w)
; ===========================================================================
off_3DED0:	offsetTable
		offsetTableEntry.w loc_3DED8
		offsetTableEntry.w loc_3DF04
		offsetTableEntry.w loc_3DF36
		offsetTableEntry.w loc_3DF80
; ===========================================================================

loc_3DED8:
	addq.b	#2,routine_secondary(a0)
	move.b	#$E,mapping_frame(a0)
	move.b	#$89,collision_flags(a0)
	move.b	#5,priority(a0)
	move.b	#$C,width_pixels(a0)
	lea	byte_3DF00(pc),a1
	bsr.w	loc_3E282
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
byte_3DF00:
	dc.w  $38
	dc.w -$14
; ===========================================================================

loc_3DF04:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.no_balancing,status(a1)
	bne.s	loc_3DF4C
	jsrto	JmpTo8_ObjectMoveAndFall
	move.w	y_pos(a0),d0
	cmpi.w	#$170,d0
	bhs.s	+
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$170,y_pos(a0)
	move.w	#$40,objoff_2A(a0)
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DF36:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#status.npc.no_balancing,status(a1)
	bne.s	loc_3DF4C
	subq.w	#1,objoff_2A(a0)
	bmi.s	loc_3DF4C
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DF4C:
	move.b	#6,routine_secondary(a0)
	move.l	#Obj58_MapUnc_2D50A,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_FieryExplosion,0,0),art_tile(a0)
	move.b	#1,priority(a0)
	move.b	#7,anim_frame_duration(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#SndID_BossExplosion,d0
	jsr	(PlaySound).l
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DF80:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#5,mapping_frame(a0)
	blo.s	+
	clr.b	collision_flags(a0)
	cmpi.b	#7,mapping_frame(a0)
	beq.w	JmpTo65_DeleteObject
+
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
;loc_3DFAA
ObjC7_FallingPieces:
	subq.w	#1,objoff_2A(a0)
	bmi.w	JmpTo65_DeleteObject
	jsrto	JmpTo8_ObjectMoveAndFall
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================

loc_3DFBA:
	jsr	(AllocateObject).l
	bne.s	+	; rts
	_move.b	#ObjID_BossExplosion,id(a1) ; load obj
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	jsr	(RandomNumber).l
	move.w	d0,d1
	moveq	#0,d1
	move.b	d0,d1
	lsr.b	#2,d1
	subi.w	#$30,d1
	add.w	d1,x_pos(a1)
	lsr.w	#8,d0
	lsr.b	#2,d0
	subi.w	#$30,d0
	add.w	d0,y_pos(a1)
+
	rts
; ===========================================================================
;loc_3DFF8
ObjC7_CheckHit:
	tst.b	collision_property(a0)
	beq.s	ObjC7_Beaten
	tst.b	objoff_2A(a0)
	bne.s	ObjC7_Flashing
	tst.b	collision_flags(a0)
	beq.s	+
	movea.w	objoff_36(a0),a1 ; a1=object
	tst.b	collision_flags(a1)
	bne.s	+++		; rts
	clr.b	collision_flags(a0)
	subq.b	#1,collision_property(a0)
	beq.s	ObjC7_Beaten
+
	move.b	#60,objoff_2A(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l
;loc_3E02E
ObjC7_Flashing:
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	+
	move.w	#$EEE,d0
+
	move.w	d0,(a1)
	subq.b	#1,objoff_2A(a0)
	bne.s	+
	clr.w	(Normal_palette_line2+2).w
	move.b	#$16,collision_flags(a0)
	movea.w	objoff_36(a0),a1 ; a1=object
	move.b	#$2A,collision_flags(a1)
+
	rts
; ===========================================================================
;loc_3E05A
ObjC7_Beaten:
	moveq	#100,d0
	bsr.w	AddPoints
	clr.b	anim_frame_duration(a0)
	move.b	#$E,routine_secondary(a0)
	bset	#status.npc.no_balancing,status(a0)
	clr.b	anim(a0)
	clr.b	collision_flags(a0)
	clr.w	x_vel(a0)
	clr.w	y_vel(a0)
	bsr.w	ObjC7_RemoveCollision
	bsr.w	ObjC7_Break
	movea.w	objoff_38(a0),a1 ; a1=object
	jsrto	JmpTo6_DeleteObject2
	addq.w	#4,sp
	rts
; ===========================================================================
;loc_3E094
ObjC7_Break:
	lea	(ObjC7_BreakOffsets).l,a1
	lea	ObjC7_BreakSpeeds(pc),a2
	moveq	#0,d0
	moveq	#ObjC7_BreakOffsets_End-ObjC7_BreakOffsets-1,d6

-	move.b	(a1)+,d0
	movea.w	(a0,d0.w),a3 ; a3=object
	move.b	#$1E,routine(a3)
	clr.b	routine_secondary(a3)
	move.w	#$80,objoff_2A(a3)
	move.w	(a2)+,x_vel(a3)
	move.w	(a2)+,y_vel(a3)
	dbf	d6,-
	rts
; ===========================================================================
;word_3E0C6
ObjC7_BreakSpeeds:
	dc.w  $200,-$400
	dc.w -$100,-$100	; 2
	dc.w  $300,-$300	; 4
	dc.w -$100,-$400	; 6
	dc.w  $180,-$200	; 8
	dc.w -$200,-$300	; 10
	dc.w	 0,-$400	; 12
	dc.w  $100,-$300	; 14
ObjC7_BreakSpeeds_End
;byte_3E0E6
ObjC7_BreakOffsets:
	dc.b objoff_2C
	dc.b objoff_2E	; 1
	dc.b objoff_30	; 2
	dc.b objoff_32	; 3
	dc.b objoff_34	; 4
	dc.b objoff_3A	; 5
	dc.b objoff_3C	; 6
	dc.b objoff_3E	; 7
ObjC7_BreakOffsets_End
	even
; ===========================================================================
;loc_3E0EE
ObjC7_InitCollision:
	lea	ObjC7_ChildOffsets(pc),a1
	lea	ObjC7_ChildCollision(pc),a2
	moveq	#0,d0

	moveq	#ObjC7_ChildCollision_End-ObjC7_ChildCollision-1,d6
-	move.b	(a1)+,d0
	movea.w	(a0,d0.w),a3 ; a3=object
	move.b	(a2)+,collision_flags(a3)
	dbf	d6,-

	rts
; ===========================================================================
;byte_3E10A
ObjC7_ChildCollision:
	dc.b   0
	dc.b $8F	; 1
	dc.b $9C	; 2
	dc.b   0	; 3
	dc.b $86	; 4
	dc.b $2A	; 5
	dc.b $8B	; 6
	dc.b $8F	; 7
	dc.b $9C	; 8
	dc.b $8B	; 9
ObjC7_ChildCollision_End
;byte_3E114
ObjC7_ChildOffsets:
	dc.b objoff_2C
	dc.b objoff_2E	; 1
	dc.b objoff_30	; 2
	dc.b objoff_32	; 3
	dc.b objoff_34	; 4
	dc.b objoff_36	; 5
	dc.b objoff_38	; 6
	dc.b objoff_3A	; 7
	dc.b objoff_3C	; 8
	dc.b objoff_3E	; 9
ObjC7_ChildOffsets_End
	even
; ===========================================================================
;loc_3E11E
ObjC7_RemoveCollision:
	lea	ObjC7_ChildOffsets(pc),a1
	moveq	#0,d0
	moveq	#ObjC7_ChildOffsets_End-ObjC7_ChildOffsets-1,d6

-	move.b	(a1)+,d0
	movea.w	(a0,d0.w),a3 ; a3=object
	clr.b	collision_flags(a3)
	dbf	d6,-
	rts
; ===========================================================================
;loc_3E136
CreateEggmanBombs:
	lea	EggmanBomb_InitSpeeds(pc),a3
	moveq	#1,d6

-	lea	(ChildObjC7_EggmanBomb).l,a2
	bsr.w	LoadChildObject
	move.w	(a3)+,d0
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	neg.w	d0
+
	move.w	d0,x_vel(a1)
	move.w	(a3)+,y_vel(a1)
	dbf	d6,-
	rts
; ===========================================================================
;word_3E160
EggmanBomb_InitSpeeds:
	dc.w   $60,-$800
	dc.w   $C0,-$A00
; ===========================================================================

loc_3E168:
	move.b	render_flags(a0),d0
	andi.b	#1,d0
	moveq	#0,d1
	lea	byte_3E19E(pc),a1

-	move.b	(a1)+,d1
	beq.w	return_37A48
	movea.w	(a0,d1.w),a2 ; a2=object
	move.b	render_flags(a2),d2
	andi.b	#$FE,d2
	or.b	d0,d2
	move.b	d2,render_flags(a2)
	move.b	status(a2),d2
	andi.b	#~(1<<status.npc.x_flip),d2
	or.b	d0,d2
	move.b	d2,status(a2)
	bra.s	-
; ===========================================================================
byte_3E19E:
	dc.b objoff_2C, objoff_2E, objoff_30, objoff_32	; 3
	dc.b objoff_34, objoff_36, objoff_38, objoff_3A	; 7
	dc.b objoff_3C, objoff_3E, 0
	even
; ===========================================================================

loc_3E1AA:
	movea.l	(a1)+,a2
	moveq	#0,d0
	move.b	anim_frame(a0),d0
	move.b	(a1,d0.w),d0
	move.b	d0,d1
	moveq	#0,d4
	andi.w	#$C0,d1
	beq.s	+
	bsr.w	loc_3E23E
+
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.b	(a2)+,d0
	move.b	(a2)+,d3
	move.b	objoff_1F(a0),d2
	addq.b	#1,d2
	cmp.b	d3,d2
	blo.s	+
	addq.b	#1,anim_frame(a0)
	moveq	#0,d2
+
	move.b	d2,objoff_1F(a0)
	moveq	#0,d5

-	move.b	(a2)+,d5
	movea.w	(a0,d5.w),a3 ; a3=object
	tst.w	d5
	bne.s	+
	movea.l	a0,a3
+
	move.l	x_pos(a3),d2
	move.b	(a2)+,d1
	ext.w	d1
	asl.w	#4,d1
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	neg.w	d1
+
	tst.w	d4
	beq.s	+
	neg.w	d1
+
	ext.l	d1
	asl.l	#8,d1
	add.l	d1,d2
	move.l	d2,x_pos(a3)
	move.l	y_pos(a3),d3
	move.b	(a2)+,d1
	ext.w	d1
	asl.w	#4,d1
	tst.w	d4
	beq.s	+
	neg.w	d1
+
	ext.l	d1
	asl.l	#8,d1
	add.l	d1,d3
	move.l	d3,y_pos(a3)
	dbf	d0,-

	moveq	#0,d1
	rts
; ===========================================================================

loc_3E236:
	clr.b	anim_frame(a0)
	moveq	#1,d1

return_3E23C:
	rts
; ===========================================================================

loc_3E23E:
	andi.b	#$3F,d0
	rol.b	#3,d1
	move.w	off_3E24C-2(pc,d1.w),d1
	jmp	off_3E24C(pc,d1.w)
; ===========================================================================
off_3E24C:	offsetTable
		offsetTableEntry.w loc_3E252
		offsetTableEntry.w loc_3E27A
		offsetTableEntry.w loc_3E27E
; ===========================================================================

loc_3E252:
	tst.b	objoff_1F(a0)
	bne.s	return_3E23C
	move.b	anim_frame(a0),d1
	addq.b	#1,d1
	move.b	(a1,d1.w),d0
	jsrto	JmpTo12_PlaySound ; sound id most likely came from off_3E40C or off_3E42C
	addq.b	#1,d1
	move.b	d1,anim_frame(a0)
	move.b	(a1,d1.w),d0
	move.b	d0,d1
	andi.b	#$C0,d1
	bne.s	loc_3E23E
	rts
; ===========================================================================

loc_3E27A:
	moveq	#1,d4
	rts
; ===========================================================================

loc_3E27E:
	addq.w	#4,sp
	bra.s	loc_3E236
; ===========================================================================

loc_3E282:
	movea.w	objoff_2C(a0),a2 ; a2=object
	move.w	x_pos(a2),d0
	move.w	(a1)+,d1
	btst	#render_flags.x_flip,render_flags(a2)
	beq.s	+
	neg.w	d1
+
	add.w	d1,d0
	move.w	d0,x_pos(a0)
	move.w	y_pos(a2),d0
	add.w	(a1)+,d0
	move.w	d0,y_pos(a0)
	rts
; ===========================================================================
;loc_3E2A8
ObjC7_PositionChildren:
	moveq	#0,d0
	moveq	#0,d6

	move.b	(a1)+,d6
-	move.b	(a1)+,d0
	movea.w	(a0,d0.w),a2 ; a2=object
	move.w	x_pos(a0),d1
	move.b	(a1)+,d2
	ext.w	d2
	btst	#render_flags.x_flip,render_flags(a0)
	beq.s	+
	neg.w	d2
+
	add.w	d2,d1
	move.w	d1,x_pos(a2)
	move.w	y_pos(a0),d1
	move.b	(a1)+,d2
	ext.w	d2
	add.w	d2,d1
	move.w	d1,y_pos(a2)
	dbf	d6,-
	rts
; ===========================================================================
;byte_3E2E0
ObjC7_ChildDeltas:
	dc.b   6
	dc.b objoff_2E, $FC, $3C	; 1
	dc.b objoff_30, $F4,   8	; 2
	dc.b objoff_32,  $C, $F8	; 3
	dc.b objoff_34,   4, $24	; 4
	dc.b objoff_3A, $FC, $3C	; 5
	dc.b objoff_3C, $F4,   8	; 6
	dc.b objoff_3E,   4, $24	; 7
	even
off_3E2F6:
	dc.l ObjC7_GroupAni_3E318
	dc.b 0, 1, 2, 3, $FF, 0
	even
off_3E300:
	dc.l ObjC7_GroupAni_3E318
	dc.b 5, 6, 7, 8, $FF, 0
	even
off_3E30A:
	dc.l ObjC7_GroupAni_3E318
	dc.b 0, 1, 2, 3, 4, 5, 6, 7, 8, $C0
	even


; -----------------------------------------------------------------------------
; Custom animation
; -----------------------------------------------------------------------------
; must be on the same line as a label that has a corresponding _End label later
c7anilistheader macro maxframe,{INTLABEL}
__LABEL__ label *
	dc.b ((__LABEL___End - __LABEL__ - 2) / 3) - 1,maxframe
    endm

; macro for a animation data
c7ani macro pieceOffset,deltax,deltay
	dc.b	pieceOffset,deltax,deltay
    endm

ObjC7_GroupAni_3E318:		offsetTable ;include "mappings/sprite/objC7_a.asm"
		offsetTableEntry.w byte_3E32A
		offsetTableEntry.w byte_3E33E
		offsetTableEntry.w byte_3E352
		offsetTableEntry.w byte_3E366
		offsetTableEntry.w byte_3E37A
		offsetTableEntry.w byte_3E380
		offsetTableEntry.w byte_3E394
		offsetTableEntry.w byte_3E3A8
		offsetTableEntry.w byte_3E3BC

byte_3E32A:	c7anilistheader 8
	c7ani       $00, $E0, $0C
	c7ani objoff_30, $E0, $0C
	c7ani objoff_32, $E0, $0C
	c7ani objoff_3C, $E0, $0C
	c7ani objoff_34, $F8, $04
	c7ani objoff_3E, $F8, $04
byte_3E32A_End

byte_3E33E:	c7anilistheader 8
	c7ani       $00, $EC, $14
	c7ani objoff_30, $EC, $14
	c7ani objoff_32, $EC, $14
	c7ani objoff_3C, $EC, $14
	c7ani objoff_34, $FA, $06
	c7ani objoff_3E, $FA, $06
byte_3E33E_End

byte_3E352:	c7anilistheader 8
	c7ani       $00, $F8, $14
	c7ani objoff_30, $F8, $14
	c7ani objoff_32, $F8, $14
	c7ani objoff_3C, $F8, $14
	c7ani objoff_34, $FE, $04
	c7ani objoff_3E, $FE, $04
byte_3E352_End

byte_3E366:	c7anilistheader 8
	c7ani       $00, $FC, $0C
	c7ani objoff_30, $FC, $0C
	c7ani objoff_32, $FC, $0C
	c7ani objoff_3C, $FC, $0c
	c7ani objoff_34, $00, $02
	c7ani objoff_3E, $00, $02
byte_3E366_End

byte_3E37A:	c7anilistheader 8
	c7ani       $00, $00, $00
byte_3E37A_End
	even
byte_3E380:	c7anilistheader 8
	c7ani       $00, $04, $E8
	c7ani objoff_30, $04, $E8
	c7ani objoff_32, $04, $E8
	c7ani objoff_3C, $04, $E8
	c7ani objoff_34, $02, $FA
	c7ani objoff_3E, $02, $FA
byte_3E380_End

byte_3E394:	c7anilistheader 8
	c7ani       $00, $0C, $E8
	c7ani objoff_30, $0C, $E8
	c7ani objoff_32, $0C, $E8
	c7ani objoff_3C, $0C, $E8
	c7ani objoff_34, $04, $FC
	c7ani objoff_3E, $04, $FC
byte_3E394_End

byte_3E3A8:	c7anilistheader 8
	c7ani       $00, $18, $F4
	c7ani objoff_30, $18, $F4
	c7ani objoff_32, $18, $F4
	c7ani objoff_3C, $18, $F4
	c7ani objoff_34, $04, $FC
	c7ani objoff_3E, $04, $FC
byte_3E3A8_End

byte_3E3BC:	c7anilistheader 8
	c7ani       $00, $18, $FC
	c7ani objoff_30, $18, $FC
	c7ani objoff_32, $18, $FC
	c7ani objoff_3C, $18, $FC
	c7ani objoff_34, $06, $FE
	c7ani objoff_3E, $06, $FE
byte_3E3BC_End

off_3E3D0:
	dc.l ObjC7_GroupAni_3E3D8
	dc.b 0, 1, 2, $C0
	even
; -----------------------------------------------------------------------------
; Custom animation
; -----------------------------------------------------------------------------
ObjC7_GroupAni_3E3D8:		offsetTable ;include "mappings/sprite/objC7_b.asm"
		offsetTableEntry.w byte_3E3DE
		offsetTableEntry.w byte_3E3F2
		offsetTableEntry.w byte_3E3F8

byte_3E3DE:	c7anilistheader $10
	c7ani       $00, $00, $04
	c7ani objoff_30, $00, $04
	c7ani objoff_32, $00, $04
	c7ani objoff_3C, $00, $04
	c7ani objoff_34, $00, $04
	c7ani objoff_3E, $00, $04
byte_3E3DE_End

byte_3E3F2:	c7anilistheader $10
	c7ani       $00, $00, $00
byte_3E3F2_End
	even
byte_3E3F8:	c7anilistheader 8
	c7ani       $00, $00, $F8
	c7ani objoff_30, $00, $F8
	c7ani objoff_32, $00, $F8
	c7ani objoff_3C, $00, $F8
	c7ani objoff_34, $00, $F8
	c7ani objoff_3E, $00, $F8
byte_3E3F8_End

off_3E40C:
	dc.l ObjC7_GroupAni_3E438
	dc.b   0,  1,  2,  3, $40, SndID_Hammer
	dc.b   4,  5,  6,  7,   8, $40, SndID_Hammer
	dc.b   9, $A,  1,  2,   3, $40, SndID_Hammer
	dc.b   4,  5,  6,  7,   8, $40, SndID_Hammer, $C0
	even
off_3E42C:
	dc.l ObjC7_GroupAni_3E438
	dc.b $88, $87, $86, $85, $B, $40, SndID_Hammer, $C0
	even
; -----------------------------------------------------------------------------
; Custom animation
; -----------------------------------------------------------------------------
ObjC7_GroupAni_3E438:		offsetTable ;include "mappings/sprite/objC7_c.asm"
		offsetTableEntry.w byte_3E450
		offsetTableEntry.w byte_3E468
		offsetTableEntry.w byte_3E480
		offsetTableEntry.w byte_3E494
		offsetTableEntry.w byte_3E4AC
		offsetTableEntry.w byte_3E4C4
		offsetTableEntry.w byte_3E4D6
		offsetTableEntry.w byte_3E4EE
		offsetTableEntry.w byte_3E502
		offsetTableEntry.w byte_3E51A
		offsetTableEntry.w byte_3E532
		offsetTableEntry.w byte_3E544

byte_3E450:	c7anilistheader $20
	c7ani objoff_34, $F8, $F8
	c7ani objoff_2E, $F8, $F8
	c7ani       $00, $00, $FC
	c7ani objoff_30, $04, $FB
	c7ani objoff_32, $03, $FB
	c7ani objoff_3C, $FC, $FB
	c7ani objoff_3E, $00, $FE
byte_3E450_End
	even
byte_3E468:	c7anilistheader $10
	c7ani objoff_34, $F0, $FC
	c7ani objoff_2E, $F0, $FC
	c7ani       $00, $F0, $FC
	c7ani objoff_30, $F4, $FB
	c7ani objoff_32, $F3, $FB
	c7ani objoff_3C, $EC, $FB
	c7ani objoff_3E, $F8, $00
byte_3E468_End
	even
byte_3E480:	c7anilistheader $10
	c7ani objoff_34, $F8, $04
	c7ani objoff_2E, $F8, $04
	c7ani       $00, $F8, $04
	c7ani objoff_30, $FC, $03
	c7ani objoff_32, $FB, $03
	c7ani objoff_3C, $F4, $03
byte_3E480_End

byte_3E494:	c7anilistheader $10
	c7ani objoff_34, $FC, $10
	c7ani objoff_2E, $F8, $10
	c7ani       $00, $00, $08
	c7ani objoff_30, $F8, $0A
	c7ani objoff_32, $FA, $0A
	c7ani objoff_3C, $08, $0A
	c7ani objoff_3E, $00, $08
byte_3E494_End
	even
byte_3E4AC:	c7anilistheader $20
	c7ani objoff_34, $FE, $FE
	c7ani       $00, $F4, $FC
	c7ani objoff_30, $F0, $FD
	c7ani objoff_32, $F1, $FD
	c7ani objoff_3C, $F8, $FD
	c7ani objoff_3E, $EC, $FA
	c7ani objoff_3A, $E8, $FC
byte_3E4AC_End
	even
byte_3E4C4:	c7anilistheader $20
	c7ani objoff_3E, $F8, $FC
	c7ani objoff_3A, $F8, $FC
	c7ani objoff_30, $FC, $FF
	c7ani objoff_32, $FD, $FF
	c7ani objoff_3C, $04, $FF
byte_3E4C4_End
	even
byte_3E4D6:	c7anilistheader $10
	c7ani objoff_3E, $F0, $FC
	c7ani objoff_3A, $F0, $FC
	c7ani       $00, $F0, $FC
	c7ani objoff_30, $EC, $FB
	c7ani objoff_32, $ED, $FB
	c7ani objoff_3C, $F4, $FB
	c7ani objoff_34, $F8, $00
byte_3E4D6_End
	even
byte_3E4EE:	c7anilistheader $10
	c7ani objoff_3E, $F8, $04
	c7ani objoff_3A, $F8, $04
	c7ani       $00, $F8, $04
	c7ani objoff_30, $F4, $03
	c7ani objoff_32, $F5, $03
	c7ani objoff_3C, $FC, $03
byte_3E4EE_End

byte_3E502:	c7anilistheader $10
	c7ani objoff_3E, $FC, $10
	c7ani objoff_3A, $F8, $10
	c7ani       $00, $00, $08
	c7ani objoff_30, $08, $0A
	c7ani objoff_32, $06, $0A
	c7ani objoff_3C, $F8, $0A
	c7ani objoff_34, $00, $08
byte_3E502_End
	even
byte_3E51A:	c7anilistheader $20
	c7ani objoff_3E, $FE, $FE
	c7ani       $00, $F4, $FC
	c7ani objoff_30, $F8, $FD
	c7ani objoff_32, $F7, $FD
	c7ani objoff_3C, $F1, $FD
	c7ani objoff_34, $EC, $FA
	c7ani objoff_2E, $E8, $FC
byte_3E51A_End
	even
byte_3E532:	c7anilistheader $20
	c7ani objoff_34, $F8, $FC
	c7ani objoff_2E, $F8, $FC
	c7ani objoff_30, $04, $FF
	c7ani objoff_32, $03, $FF
	c7ani objoff_3C, $FC, $FF
byte_3E532_End
	even
byte_3E544:	c7anilistheader $10
	c7ani objoff_3E, $00, $08
	c7ani objoff_3A, $00, $08
	c7ani       $00, $00, $08
	c7ani objoff_30, $00, $08
	c7ani objoff_32, $00, $08
	c7ani objoff_3C, $00, $08
	c7ani objoff_34, $00, $08
byte_3E544_End
	even

;word_3E55C
ChildObjC7_Shoulder:
	dc.w objoff_2C
	dc.b ObjID_Eggrobo
	dc.b   4
;word_3E560
ChildObjC7_FrontLowerLeg:
	dc.w objoff_2E
	dc.b ObjID_Eggrobo
	dc.b   6
;word_3E564
ChildObjC7_FrontForearm:
	dc.w objoff_30
	dc.b ObjID_Eggrobo
	dc.b   8
;word_3E568
ChildObjC7_Arm:
	dc.w objoff_32
	dc.b ObjID_Eggrobo
	dc.b  $A
;word_3E56C
ChildObjC7_FrontThigh:
	dc.w objoff_34
	dc.b ObjID_Eggrobo
	dc.b  $C
;word_3E570
ChildObjC7_Head:
	dc.w objoff_36
	dc.b ObjID_Eggrobo
	dc.b  $E
;word_3E574
ChildObjC7_Jet:
	dc.w objoff_38
	dc.b ObjID_Eggrobo
	dc.b $10
;word_3E578
ChildObjC7_BackLowerLeg:
	dc.w objoff_3A
	dc.b ObjID_Eggrobo
	dc.b $12
;word_3E57C
ChildObjC7_BackForearm:
	dc.w objoff_3C
	dc.b ObjID_Eggrobo
	dc.b $14
;word_3E580
ChildObjC7_BackThigh:
	dc.w objoff_3E
	dc.b ObjID_Eggrobo
	dc.b $16
;word_3E584
ChildObjC7_TargettingSensor:
	dc.w objoff_10
	dc.b ObjID_Eggrobo
	dc.b $18
;word_3E588
ChildObjC7_TargettingLock:
	dc.w objoff_10
	dc.b ObjID_Eggrobo
	dc.b $1A
;word_3E58C
ChildObjC7_EggmanBomb:
	dc.w objoff_10
	dc.b ObjID_Eggrobo
	dc.b $1C
;off_3E590
ObjC7_SubObjData:
	subObjData ObjC7_MapUnc_3E5F8,make_art_tile(ArtTile_ArtNem_DEZBoss,0,0),1<<render_flags.level_fg,4,$38,$00
