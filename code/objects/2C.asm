; ===========================================================================
; ----------------------------------------------------------------------------
; Object 2C - Sprite that makes leaves fly off when you hit it from ARZ
; ----------------------------------------------------------------------------
; Sprite_26104:
Obj2C:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj2C_Index(pc,d0.w),d1
	jmp	Obj2C_Index(pc,d1.w)
; ===========================================================================
; off_26112:
Obj2C_Index:	offsetTable
		offsetTableEntry.w Obj2C_Init	; 0
		offsetTableEntry.w Obj2C_Main	; 2
		offsetTableEntry.w Obj2C_Leaf	; 4
; ===========================================================================
; byte_26118:
Obj2C_CollisionFlags:
	dc.b $D6
	dc.b $D4	; 1
	dc.b $D5	; 2
	even
; ===========================================================================
; loc_2611C:
Obj2C_Init:
	addq.b	#2,routine(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	move.b	Obj2C_CollisionFlags(pc,d0.w),collision_flags(a0)
	move.l	#Obj31_MapUnc_20E74,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Powerups,0,1),art_tile(a0)
    if fixBugs
	move.b	#4,render_flags(a0)
    else
	; The high bit of 'render_flags' should not be set here: this causes
	; this object to become visible when the player dies, because of how
	; 'RunObjectsWhenPlayerIsDead' works.
	move.b	#$84,render_flags(a0)
    endif
	move.b	#$80,width_pixels(a0)
	move.b	#4,priority(a0)
	move.b	subtype(a0),mapping_frame(a0)
; loc_26152:
Obj2C_Main:
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo29_DeleteObject
    if fixBugs
	; This object never actually displays itself, even in Debug Mode.
	tst.w	(Debug_placement_mode).w
	beq.s	+
	jsr	(DisplaySprite).l
+
    endif
	move.b	collision_property(a0),d0
	beq.s	loc_261C2
	move.w	objoff_2E(a0),d0
	beq.s	+
	add.b	(Timer_frames+1).w,d0
	andi.w	#$F,d0
	bne.s	loc_26198
+
	lea	(MainCharacter).w,a2 ; a2=character
	bclr	#0,collision_property(a0)
	beq.s	Obj2C_RemoveCollision
	bsr.s	Obj2C_CreateLeaves
	tst.w	objoff_2E(a0)
	bne.s	Obj2C_RemoveCollision
	move.w	(Timer_frames).w,objoff_2E(a0)
	bra.s	Obj2C_RemoveCollision
; ===========================================================================

loc_26198:
	addi_.w	#8,d0
	andi.w	#$F,d0
	bne.s	Obj2C_RemoveCollision
	lea	(Sidekick).w,a2 ; a2=character
	bclr	#1,collision_property(a0)
	beq.s	Obj2C_RemoveCollision
	bsr.s	Obj2C_CreateLeaves
	tst.w	objoff_2E(a0)
	bne.s	Obj2C_RemoveCollision
	move.w	(Timer_frames).w,objoff_2E(a0)
; loc_261BC:
Obj2C_RemoveCollision:
	clr.b	collision_property(a0)
	rts
; ===========================================================================

loc_261C2:
	clr.w	objoff_2E(a0)
	rts
; ===========================================================================
; loc_261C8:
Obj2C_CreateLeaves:
	mvabs.w	x_vel(a2),d0
	cmpi.w	#$200,d0
	bhs.s	loc_261E4
	mvabs.w	y_vel(a2),d0
	cmpi.w	#$200,d0
	blo.s	loc_261C2

loc_261E4:
	lea	(Obj2C_Speeds).l,a3
	moveq	#4-1,d6

loc_261EC:
	jsrto	AllocateObject, JmpTo6_AllocateObject
	bne.w	loc_26278
	_move.b	#ObjID_LeavesGenerator,id(a1) ; load obj2C
	move.b	#4,routine(a1)
	move.w	x_pos(a2),x_pos(a1)
	move.w	y_pos(a2),y_pos(a1)
	jsrto	RandomNumber, JmpTo2_RandomNumber
	andi.w	#$F,d0
	subq.w	#8,d0
	add.w	d0,x_pos(a1)
	swap	d0
	andi.w	#$F,d0
	subq.w	#8,d0
	add.w	d0,y_pos(a1)
	move.w	(a3)+,x_vel(a1)
	move.w	(a3)+,y_vel(a1)
	btst	#0,status(a2)
	beq.s	+
	neg.w	x_vel(a1)
+
	move.w	x_pos(a1),objoff_30(a1)
	move.w	y_pos(a1),objoff_34(a1)
	andi.b	#1,d0
	move.b	d0,mapping_frame(a1)
	move.l	#Obj2C_MapUnc_2631E,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Leaves,3,1),art_tile(a1)
	move.b	#$84,render_flags(a1)
	move.b	#8,width_pixels(a1)
	move.b	#1,priority(a1)
	move.b	#4,objoff_38(a1)
	; This line makes no sense: d1 is never set to anything, the object
	; being written to is the parent, not the child, and angle isn't used
	; by the parent at all.
	move.b	d1,angle(a0)		; ???

loc_26278:
	dbf	d6,loc_261EC
	move.w	#SndID_Leaves,d0
	jmp	(PlaySound).l
; ===========================================================================
; byte_26286: word_26286:
Obj2C_Speeds:
	dc.w -$80,-$80	; 0
	dc.w  $C0,-$40	; 1
	dc.w -$C0, $40	; 2
	dc.w  $80, $80	; 3
; ===========================================================================
; loc_26296:
Obj2C_Leaf:
	move.b	objoff_38(a0),d0
	add.b	d0,angle(a0)
	add.b	(Vint_runcount+3).w,d0
	andi.w	#$1F,d0
	bne.s	+
	add.b	d7,d0
	andi.b	#1,d0
	beq.s	+
	neg.b	objoff_38(a0)
+
	move.l	objoff_30(a0),d2
	move.l	objoff_34(a0),d3
	move.w	x_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d2
	move.w	y_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d2,objoff_30(a0)
	move.l	d3,objoff_34(a0)
	swap	d2
	andi.w	#3,d3
	addq.w	#4,d3
	add.w	d3,y_vel(a0)
	move.b	angle(a0),d0
	jsrto	CalcSine, JmpTo7_CalcSine
	asr.w	#6,d0
	add.w	objoff_30(a0),d0
	move.w	d0,x_pos(a0)
	asr.w	#6,d1
	add.w	objoff_34(a0),d1
	move.w	d1,y_pos(a0)
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#$B,anim_frame_duration(a0)
	bchg	#1,mapping_frame(a0)
+
	tst.b	render_flags(a0)
	bpl.w	JmpTo29_DeleteObject
	jmpto	DisplaySprite, JmpTo17_DisplaySprite

    if removeJmpTos
JmpTo29_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj2C_MapUnc_2631E:	include "mappings/sprite/obj2C.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo17_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo29_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo6_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
JmpTo2_RandomNumber ; JmpTo
	jmp	(RandomNumber).l
JmpTo7_CalcSine ; JmpTo
	jmp	(CalcSine).l

	align 4
    endif
