; ===========================================================================
; ----------------------------------------------------------------------------
; Object 56 - EHZ boss
; the bottom part of the vehicle with the ability to fly is the parent object
; ----------------------------------------------------------------------------
; Sprite_2EF18:
Obj56:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj56_Index(pc,d0.w),d1
	jmp	Obj56_Index(pc,d1.w)
; ===========================================================================
; off_2EF26:
Obj56_Index:	offsetTable
		offsetTableEntry.w Obj56_Init	; 0 - Init
		offsetTableEntry.w loc_2F262	; 2 - Flying vehicle, bottom = main object
		offsetTableEntry.w loc_2F54E	; 4 - Propeller normal
		offsetTableEntry.w loc_2F5F6	; 6 - Vehicle on ground
		offsetTableEntry.w loc_2F664	; 8 - Wheels
		offsetTableEntry.w loc_2F7F4	; A - Spike
		offsetTableEntry.w loc_2F52A	; C - Propeller after defeat
		offsetTableEntry.w loc_2F8DA	; E - Flying vehicle, top
; ===========================================================================

; #7,status(ax) set via collision response routine (Touch_Enemy_Part2)
; 	when after a hit collision_property(ax) = hitcount has reached zero
; objoff_2A(ax) used as timer (countdown)
; objoff_2C(ax) tertiary rountine counter
; #0,objoff_2D(ax) set when Robotnik is on ground
; #1,objoff_2D(ax) set when Robotnik is active (moving back & forth)
; #2,objoff_2D(ax) set when Robotnik is flying off after being defeated
;	#3,objoff_2D(ax) flag to separate spike from vehicle
; objoff_2E(ax)	y_position of wheels
;	objoff_34(ax) parent object
; objoff_3C(ax)	timer after defeat

; loc_2EF36:
Obj56_Init:
	move.l	#Obj56_MapUnc_2FAF8,mappings(a0)	; main object
	move.w	#make_art_tile(ArtTile_ArtNem_Eggpod_1,1,0),art_tile(a0) ; vehicle with ability to fly, bottom part
	ori.b	#4,render_flags(a0)
	move.b	#$81,subtype(a0)
	move.w	#$29D0,x_pos(a0)
	move.w	#$426,y_pos(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#$14,y_radius(a0)
	move.b	#4,priority(a0)
	move.b	#$F,collision_flags(a0)
	move.b	#8,collision_property(a0)	; hitcount
	addq.b	#2,routine(a0)
	move.w	x_pos(a0),objoff_30(a0)
	move.w	y_pos(a0),objoff_38(a0)
	jsrto	Adjust2PArtPointer, JmpTo61_Adjust2PArtPointer
	jsr	(AllocateObjectAfterCurrent).l	; vehicle with ability to fly, top part
	bne.w	+

	_move.b	#ObjID_EHZBoss,id(a1) ; load obj56
	move.l	a0,objoff_34(a1)	; link top and bottom to each other
	move.l	a1,objoff_34(a0)	; i.e. addresses for cross references
	move.l	#Obj56_MapUnc_2FAF8,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Eggpod_1,0,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#4,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#$E,routine(a1)
	move.b	#1,anim(a1)	; normal animation
	move.b	render_flags(a0),render_flags(a1)
+
	jsr	(AllocateObjectAfterCurrent).l	; Vehicle on ground
	bne.s	+

	_move.b	#ObjID_EHZBoss,id(a1) ; load obj56
	move.l	a0,objoff_34(a1)	; linked to main object
	move.l	#Obj56_MapUnc_2FA58,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_EHZBoss,0,0),art_tile(a1)
	jsrto	Adjust2PArtPointer2, JmpTo9_Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#$30,width_pixels(a1)
	move.b	#$10,y_radius(a1)
	move.b	#3,priority(a1)
	move.w	#$2AF0,x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#6,routine(a1)
+
	bsr.w	loc_2F098
	subi_.w	#8,objoff_38(a0)
	move.w	#$2AF0,x_pos(a0)
	move.w	#$2F8,y_pos(a0)
	jsr	(AllocateObjectAfterCurrent).l	; propeller normal
	bne.s	+	; rts

	_move.b	#ObjID_EHZBoss,id(a1) ; load obj56
	move.l	a0,objoff_34(a1)	; linked to main object
	move.l	#Obj56_MapUnc_2F970,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_EggChoppers,1,0),art_tile(a1)
	jsrto	Adjust2PArtPointer2, JmpTo9_Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#$40,width_pixels(a1)
	move.b	#3,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.w	#$1E,objoff_2A(a1)
	move.b	#4,routine(a1)
+
	rts
; ---------------------------------------------------------------------------

loc_2F098:
	jsr	(AllocateObjectAfterCurrent).l	; first foreground wheel
	bne.s	+

	_move.b	#ObjID_EHZBoss,id(a1) ; load obj56
	move.l	a0,objoff_34(a1)	; linked to main object
	move.l	#Obj56_MapUnc_2FA58,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_EHZBoss,1,0),art_tile(a1)
	jsrto	Adjust2PArtPointer2, JmpTo9_Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#2,priority(a1)
	move.b	#$10,y_radius(a1)
	move.b	#$10,x_radius(a1)
	move.w	#$2AF0,x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	addi.w	#$1C,x_pos(a1)
	addi.w	#$C,y_pos(a1)
	move.b	#8,routine(a1)
	move.b	#4,mapping_frame(a1)
	move.b	#1,anim(a1)
	move.w	#$A,objoff_2A(a1)
	move.b	#0,subtype(a1)
+
	jsr	(AllocateObjectAfterCurrent).l	; second foreground wheel
	bne.s	+

	_move.b	#ObjID_EHZBoss,id(a1) ; load obj56
	move.l	a0,objoff_34(a1)	; linked to main object
	move.l	#Obj56_MapUnc_2FA58,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_EHZBoss,1,0),art_tile(a1)
	jsrto	Adjust2PArtPointer2, JmpTo9_Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#2,priority(a1)
	move.b	#$10,y_radius(a1)
	move.b	#$10,x_radius(a1)
	move.w	#$2AF0,x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	addi.w	#-$C,x_pos(a1)
	addi.w	#$C,y_pos(a1)
	move.b	#8,routine(a1)
	move.b	#4,mapping_frame(a1)
	move.b	#1,anim(a1)
	move.w	#$A,objoff_2A(a1)
	move.b	#1,subtype(a1)
+
	jsr	(AllocateObjectAfterCurrent).l	; background wheel
	bne.s	+

	_move.b	#ObjID_EHZBoss,id(a1) ; load obj56
	move.l	a0,objoff_34(a1)	; linked to main object
	move.l	#Obj56_MapUnc_2FA58,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_EHZBoss,1,0),art_tile(a1)
	jsrto	Adjust2PArtPointer2, JmpTo9_Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#3,priority(a1)
	move.b	#$10,y_radius(a1)
	move.b	#$10,x_radius(a1)
	move.w	#$2AF0,x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	addi.w	#-$2C,x_pos(a1)
	addi.w	#$C,y_pos(a1)
	move.b	#8,routine(a1)
	move.b	#6,mapping_frame(a1)
	move.b	#2,anim(a1)
	move.w	#$A,objoff_2A(a1)
	move.b	#2,subtype(a1)
+
	jsr	(AllocateObjectAfterCurrent).l	; Spike
	bne.s	+

	_move.b	#ObjID_EHZBoss,id(a1) ; load obj56
	move.l	a0,objoff_34(a1)	; linked to main object
	move.l	#Obj56_MapUnc_2FA58,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_EHZBoss,1,0),art_tile(a1)
	jsrto	Adjust2PArtPointer2, JmpTo9_Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#2,priority(a1)
	move.w	#$2AF0,x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	addi.w	#-$36,x_pos(a1)
	addi_.w	#8,y_pos(a1)
	move.b	#$A,routine(a1)
	move.b	#1,mapping_frame(a1)
	move.b	#0,anim(a1)
+
	rts
; ===========================================================================

loc_2F262:	; Obj56_VehicleMain:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_2F270(pc,d0.w),d1
	jmp	off_2F270(pc,d1.w)
; ---------------------------------------------------------------------------
off_2F270:	offsetTable
		offsetTableEntry.w loc_2F27C	; 0 - approaching diagonally
		offsetTableEntry.w loc_2F2A8	; 2 - final approaching stage (vertically/waiting)
		offsetTableEntry.w loc_2F304	; 4 - moving back and forth
		offsetTableEntry.w loc_2F336	; 6 - boss defeated, falling/lying on ground
		offsetTableEntry.w loc_2F374	; 8 - boss idle for $C frames
		offsetTableEntry.w loc_2F38A	; A - flying off, moving camera
; ===========================================================================

loc_2F27C:	; Obj56_VehicleMain_Sub0:
	move.b	#0,collision_flags(a0)
	cmpi.w	#$29D0,x_pos(a0)	; reached the point to unite with bottom vehicle?
	ble.s	loc_2F29A
	subi_.w	#1,x_pos(a0)
	addi_.w	#1,y_pos(a0)	; move diagonally down
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F29A:
	move.w	#$29D0,x_pos(a0)
	addq.b	#2,routine_secondary(a0)	; next routine
	bra.w	JmpTo35_DisplaySprite
; ===========================================================================

loc_2F2A8:	; Obj56_VehicleMain_Sub2:
	moveq	#0,d0
	move.b	objoff_2C(a0),d0	; tertiary routine
	move.w	off_2F2B6(pc,d0.w),d1
	jmp	off_2F2B6(pc,d1.w)
; ---------------------------------------------------------------------------
off_2F2B6:	offsetTable
		offsetTableEntry.w loc_2F2BA	; 0 - moving down to ground vehicle vertically
		offsetTableEntry.w loc_2F2E0	; 2 - not moving, delay until activation
; ---------------------------------------------------------------------------

loc_2F2BA:	; Obj56_VehicleMain_Sub2_0:
	cmpi.w	#$41E,y_pos(a0)
	bge.s	loc_2F2CC
	addi_.w	#1,y_pos(a0)	; move vertically (down)
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F2CC:
	addq.b	#2,objoff_2C(a0)	; tertiary routine
	bset	#0,objoff_2D(a0)	; Robotnik on ground (relevant for propeller)
	move.w	#60,objoff_2A(a0)	; timer for standing still
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F2E0:	; Obj56_VehicleMain_Sub2_2:
	subi_.w	#1,objoff_2A(a0)	; timer
	bpl.w	JmpTo35_DisplaySprite
	move.w	#-$200,x_vel(a0)
	addq.b	#2,routine_secondary(a0)
	move.b	#$F,collision_flags(a0)
	bset	#1,objoff_2D(a0)	; boss now active and moving
	bra.w	JmpTo35_DisplaySprite
; ===========================================================================

loc_2F304:	; Obj56_VehicleMain_Sub4:
	bsr.w	loc_2F4A6	; routine to handle hits
	bsr.w	loc_2F484	; position check, sets direction
	move.w	objoff_2E(a0),d0	; y_position of wheels
	lsr.w	#1,d0
	subi.w	#$14,d0
	move.w	d0,y_pos(a0)	; set y_pos depending on wheels
	move.w	#0,objoff_2E(a0)
	move.l	x_pos(a0),d2
	move.w	x_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d2
	move.l	d2,x_pos(a0)	; set x_pos depening on velocity
	bra.w	JmpTo35_DisplaySprite
; ===========================================================================

loc_2F336:	; Obj56_VehicleMain_Sub6:
	subq.w	#1,objoff_3C(a0)	; timer set after defeat
	bmi.s	loc_2F35C	; if countdown finished
	bsr.w	Boss_LoadExplosion
	jsrto	ObjectMoveAndFall, JmpTo4_ObjectMoveAndFall
	jsrto	ObjCheckFloorDist, JmpTo3_ObjCheckFloorDist
	tst.w	d1
	bpl.w	JmpTo35_DisplaySprite
	add.w	d1,y_pos(a0)
	move.w	#0,y_vel(a0)	; set to ground and stand still
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F35C:
	clr.w	x_vel(a0)
	addq.b	#2,routine_secondary(a0)
	move.w	#-$26,objoff_3C(a0)
	move.w	#$C,objoff_2A(a0)
	bra.w	JmpTo35_DisplaySprite
; ===========================================================================

loc_2F374:	; Obj56_VehicleMain_Sub8:
	subq.w	#1,objoff_2A(a0)	; timer
	bpl.w	JmpTo35_DisplaySprite
	addq.b	#2,routine_secondary(a0)
	move.b	#0,objoff_2C(a0)	; tertiary routine
	bra.w	JmpTo35_DisplaySprite
; ===========================================================================

loc_2F38A:	; Obj56_VehicleMain_SubA:
	moveq	#0,d0
	move.b	objoff_2C(a0),d0	; tertiary routine
	move.w	off_2F39C(pc,d0.w),d1
	jsr	off_2F39C(pc,d1.w)
	bra.w	JmpTo35_DisplaySprite
; ===========================================================================
off_2F39C:	offsetTable
		offsetTableEntry.w loc_2F3A2	; 0 - initialize propellor
		offsetTableEntry.w loc_2F424	; 2 - waiting
		offsetTableEntry.w loc_2F442	; 4 - flying off
; ===========================================================================

loc_2F3A2:	; Obj56_VehicleMain_SubA_0:
	bclr	#0,objoff_2D(a0)	; Robotnik off ground
	jsrto	AllocateObjectAfterCurrent, JmpTo21_AllocateObjectAfterCurrent	; reload propeller after defeat
	bne.w	+	; rts

	_move.b	#ObjID_EHZBoss,id(a1) ; load obj56
	move.l	a0,objoff_34(a1)	; linked to main object
	move.l	#Obj56_MapUnc_2F970,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_EggChoppers,1,0),art_tile(a1)
	jsrto	Adjust2PArtPointer2, JmpTo9_Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#3,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	addi.w	#$C,y_pos(a1)
	move.b	status(a0),status(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	#$C,routine(a1)
	move.b	#2,anim(a1)
	move.w	#$10,objoff_2A(a1)	; timer
	move.w	#$32,objoff_2A(a0)	; timer
	addq.b	#2,objoff_2C(a0)	; tertiary routine - increase
	jsrto	PlayLevelMusic, JmpTo2_PlayLevelMusic ; play level Music
	move.b	#1,(Boss_defeated_flag).w
+
	rts
; ===========================================================================

loc_2F424:	; Obj56_VehicleMain_SubA_2:
	subi_.w	#1,objoff_2A(a0)	; timer
	bpl.s	+	; rts
	bset	#2,objoff_2D(a0)	; Robotnik flying off
	move.w	#$60,objoff_2A(a0)	; timer
	addq.b	#2,objoff_2C(a0)	; tertiary routine
	jsrto	LoadPLC_AnimalExplosion, JmpTo2_LoadPLC_AnimalExplosion ; PLC_Explosion
+
	rts
; ===========================================================================

loc_2F442:	; Obj56_VehicleMain_SubA_4:
	subi_.w	#1,objoff_2A(a0)	; timer
	bpl.s	loc_2F45C
	bset	#0,status(a0)
	bset	#0,render_flags(a0)
	addq.w	#6,x_pos(a0)
	bra.s	loc_2F460
; ===========================================================================

loc_2F45C:
	subq.w	#1,y_pos(a0)

loc_2F460:
	cmpi.w	#$2AB0,(Camera_Max_X_pos).w
	bhs.s	loc_2F46E
	addq.w	#2,(Camera_Max_X_pos).w
	bra.s	return_2F482
; ===========================================================================

loc_2F46E:
	tst.b	render_flags(a0)
	bmi.s	return_2F482
	addq.w	#4,sp
	movea.l	objoff_34(a0),a1 ; parent address (vehicle)
	jsrto	DeleteObject2, JmpTo5_DeleteObject2
	jmpto	DeleteObject, JmpTo52_DeleteObject
; ===========================================================================

return_2F482:
	rts
; ===========================================================================

loc_2F484:	; shared routine, checks positions and sets direction
	move.w	x_pos(a0),d0
	cmpi.w	#$28A0,d0	; beyond left boundary?
	ble.s	loc_2F494
	cmpi.w	#$2B08,d0
	blt.s	return_2F4A4	; beyond right boundary?

loc_2F494:	; beyond boundary
	bchg	#0,status(a0)	; change direction
	bchg	#0,render_flags(a0)	; mirror sprite
	neg.w	x_vel(a0)	; change direction of velocity

return_2F4A4:
	rts
; ===========================================================================

loc_2F4A6:	; routine to handle hits
	cmpi.b	#6,routine_secondary(a0)	; is only called when value is 4?
	bhs.s	return_2F4EC	; thus unnecessary? (return if greater or equal than 6)
	tst.b	status(a0)
	bmi.s	loc_2F4EE	; Sonic has just defeated the boss (i.e. bit 7 set)
	tst.b	collision_flags(a0)	; set to 0 when boss was hit by Touch_Enemy_Part2
	bne.s	return_2F4EC	; not 0, i.e. boss not hit
	tst.b	objoff_3E(a0)
	bne.s	loc_2F4D0	; boss already invincibile
	move.b	#$20,objoff_3E(a0)	; boss invincibility timer
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l	; play boss hit sound

loc_2F4D0:
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0	; black
	tst.w	(a1)
	bne.s	loc_2F4DE	; already not black (i.e. white)?
	move.w	#$EEE,d0	; white

loc_2F4DE:
	move.w	d0,(a1)	; set respective color
	subq.b	#1,objoff_3E(a0)	; decrease boss invincibility timer
	bne.s	return_2F4EC
	move.b	#$F,collision_flags(a0)	; if invincibility ended, allow collision again

return_2F4EC:
	rts
; ===========================================================================

loc_2F4EE:	;	boss defeated
	moveq	#100,d0
	jsrto	AddPoints, JmpTo3_AddPoints	; add 1000 points, reward for defeating boss
	move.b	#6,routine_secondary(a0)
	move.w	#0,x_vel(a0)
	move.w	#-$180,y_vel(a0)
	move.w	#$B3,objoff_3C(a0)	; timer
	bset	#3,objoff_2D(a0)	; flag to separate spike from vehicle
	movea.l	objoff_34(a0),a1 ; address top part
	move.b	#4,anim(a1)	; flying off animation
	move.b	#6,mapping_frame(a1)
	moveq	#PLCID_Capsule,d0
	jmpto	LoadPLC, JmpTo6_LoadPLC	; load egg prison
; ===========================================================================
	rts
; ===========================================================================

loc_2F52A:	; Obj56_PropellerReloaded:	; Propeller after defeat
	subi_.w	#1,y_pos(a0)	; move up
	subi_.w	#1,objoff_2A(a0)	; decrease timer
	bpl.w	JmpTo35_DisplaySprite
	move.b	#4,routine(a0)	; Propeller normal
	lea	(Ani_obj56_a).l,a1
	jsrto	AnimateSprite, JmpTo17_AnimateSprite
	bra.w	JmpTo35_DisplaySprite
; ===========================================================================

loc_2F54E:	; Obj56_Propeller:	; Propeller normal
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_2F55C(pc,d0.w),d1
	jmp	off_2F55C(pc,d1.w)
; ---------------------------------------------------------------------------
off_2F55C:	offsetTable
		offsetTableEntry.w loc_2F560	; 0 - Robotnik in air
		offsetTableEntry.w loc_2F5C6	; 2 - Robotnik on ground
; ---------------------------------------------------------------------------

loc_2F560:	; Obj56_Propeller_Sub0
	movea.l	objoff_34(a0),a1 ; parent address (vehicle)
	cmpi.b	#ObjID_EHZBoss,id(a1)
	bne.w	JmpTo52_DeleteObject	; if boss non-existant
	btst	#0,objoff_2D(a1)	; is Robotnik on ground?
	beq.s	loc_2F58E	; if not, branch
	move.b	#1,anim(a0)
	move.w	#$18,objoff_2A(a0)	; timer until deletion
	addq.b	#2,routine_secondary(a0)
	move.b	#MusID_StopSFX,d0
	jsrto	PlaySound, JmpTo6_PlaySound
	bra.s	loc_2F5A0
; ---------------------------------------------------------------------------

loc_2F58E:	; not on ground
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	loc_2F5A0
	move.b	#SndID_Helicopter,d0
	jsrto	PlaySound, JmpTo6_PlaySound

loc_2F5A0:
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.b	status(a1),status(a0)
	move.b	render_flags(a1),render_flags(a0)
	lea	(Ani_obj56_a).l,a1
	jsrto	AnimateSprite, JmpTo17_AnimateSprite
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F5C6:	; Obj56_Propeller_Sub2
	subi_.w	#1,objoff_2A(a0)	; timer
	bpl.s	loc_2F5E8
	cmpi.w	#-$10,objoff_2A(a0)
	ble.w	JmpTo52_DeleteObject
	move.b	#4,priority(a0)
	addi_.w	#1,y_pos(a0)	; move down
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F5E8:
	lea	(Ani_obj56_a).l,a1
	jsrto	AnimateSprite, JmpTo17_AnimateSprite
	bra.w	JmpTo35_DisplaySprite
; ===========================================================================

loc_2F5F6:	; Obj56_GroundVehicle:
	tst.b	routine_secondary(a0)
	bne.s	loc_2F626
; Obj56_GroundVehicle_Sub0:
	cmpi.w	#$28F0,(Camera_Min_X_pos).w
	blo.w	JmpTo35_DisplaySprite
	cmpi.w	#$29D0,x_pos(a0)
	ble.s	loc_2F618
	subi_.w	#1,x_pos(a0)
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F618:
	move.w	#$29D0,x_pos(a0)
	addq.b	#2,routine_secondary(a0)
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F626:	; Obj56_GroundVehicle_Sub2:
	movea.l	objoff_34(a0),a1 ; parent address (vehicle)
	btst	#1,objoff_2D(a1)
	beq.w	JmpTo35_DisplaySprite	; boss not moving yet (inactive)
	btst	#2,objoff_2D(a1)	; Robotnik flying off flag
	bne.w	JmpTo35_DisplaySprite
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	addi_.w	#8,y_pos(a0)
	move.b	status(a1),status(a0)
	bmi.w	JmpTo35_DisplaySprite
	move.b	render_flags(a1),render_flags(a0)
	bra.w	JmpTo35_DisplaySprite
; ===========================================================================

loc_2F664:	; Obj56_Wheel:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_2F672(pc,d0.w),d1
	jmp	off_2F672(pc,d1.w)
; ---------------------------------------------------------------------------
off_2F672:	offsetTable
		offsetTableEntry.w loc_2F67C	; 0 - wheels moving towards start position
		offsetTableEntry.w loc_2F714	; 2 - standing still (boss inactive)
		offsetTableEntry.w loc_2F746	; 4 - normal mode (boss active)
		offsetTableEntry.w loc_2F7A6	; 6 - inactive while defeat
		offsetTableEntry.w loc_2F7D2	; 8 - wheels bouncing away after defeat
; ---------------------------------------------------------------------------

loc_2F67C:	; Obj56_Wheel_Sub0:
	cmpi.w	#$28F0,(Camera_Min_X_pos).w
	blo.w	JmpTo35_DisplaySprite
	move.w	#$100,y_vel(a0)
	cmpi.b	#1,subtype(a0)	; wheel number (0-2)
	bgt.s	loc_2F6B6	; background wheel
	beq.s	loc_2F6A6	; second foreground wheel
; ---------------------------------------------------------------------------
	cmpi.w	#$29EC,x_pos(a0)	; first foreground wheel
	ble.s	loc_2F6C6
	subi_.w	#1,x_pos(a0)
	bra.s	loc_2F6E8

loc_2F6A6:	; second foreground wheel
	cmpi.w	#$29C4,x_pos(a0)
	ble.s	loc_2F6D2
	subi_.w	#1,x_pos(a0)
	bra.s	loc_2F6E8

loc_2F6B6:	; background wheel
	cmpi.w	#$29A4,x_pos(a0)
	ble.s	loc_2F6DE
	subi_.w	#1,x_pos(a0)
	bra.s	loc_2F6E8
; ---------------------------------------------------------------------------

loc_2F6C6:	; first foreground wheel
	move.w	#$29EC,x_pos(a0)
	addq.b	#2,routine_secondary(a0)
	bra.s	loc_2F6E8

loc_2F6D2:	; second foreground wheel
	move.w	#$29C4,x_pos(a0)
	addq.b	#2,routine_secondary(a0)
	bra.s	loc_2F6E8

loc_2F6DE:	; background wheel
	move.w	#$29A4,x_pos(a0)
	addq.b	#2,routine_secondary(a0)
; ---------------------------------------------------------------------------

loc_2F6E8:	; routine for all wheels
	jsrto	ObjectMoveAndFall, JmpTo4_ObjectMoveAndFall
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	loc_2F6FA
	add.w	d1,y_pos(a0)	; reset on floor

loc_2F6FA:
	tst.b	routine_secondary(a0)
	beq.s	loc_2F706
	move.w	#-$200,x_vel(a0)	; if reached position, set velocity

loc_2F706:
	lea	(Ani_obj56_b).l,a1
	jsrto	AnimateSprite, JmpTo17_AnimateSprite
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F714:	; Obj56_Wheel_Sub2:
	movea.l	objoff_34(a0),a1 ; parent address (vehicle)
	cmpi.b	#ObjID_EHZBoss,id(a1)
	bne.w	JmpTo52_DeleteObject	; if boss non-existant
	btst	#1,objoff_2D(a1)
	beq.w	JmpTo35_DisplaySprite	; boss not moving yet (inactive)
	addq.b	#2,routine_secondary(a0)
	cmpi.b	#2,priority(a0)
	bne.s	BranchTo_JmpTo35_DisplaySprite
	move.w	y_pos(a0),d0
	movea.l	objoff_34(a0),a1 ; parent address (vehicle)
	add.w	d0,objoff_2E(a1)

BranchTo_JmpTo35_DisplaySprite ; BranchTo
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F746:	; Obj56_Wheel_Sub4:
	movea.l	objoff_34(a0),a1 ; parent address (vehicle)
	cmpi.b	#ObjID_EHZBoss,id(a1)
	bne.w	JmpTo52_DeleteObject	; if boss non-existant
	move.b	status(a1),status(a0)
	move.b	render_flags(a1),render_flags(a0)
	tst.b	status(a0)
	bpl.s	loc_2F768	; has Sonic just defeated the boss (i.e. bit 7 set)?
	addq.b	#2,routine_secondary(a0)	; if yes, Sub6

loc_2F768:
	bsr.w	loc_2F484	; position check, sets direction
	jsrto	ObjectMoveAndFall, JmpTo4_ObjectMoveAndFall
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	loc_2F77E
	add.w	d1,y_pos(a0)	; reset on floor

loc_2F77E:
	move.w	#$100,y_vel(a0)
	cmpi.b	#2,priority(a0)
	bne.s	loc_2F798
	move.w	y_pos(a0),d0
	movea.l	objoff_34(a0),a1 ; parent address (vehicle)
	add.w	d0,objoff_2E(a1)

loc_2F798:
	lea	(Ani_obj56_b).l,a1
	jsrto	AnimateSprite, JmpTo17_AnimateSprite
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F7A6:	; Obj56_Wheel_Sub6:
	subi_.w	#1,objoff_2A(a0)	; timer, initially set to $A (first delay until wheels rolling off)
	bpl.w	JmpTo35_DisplaySprite
	addq.b	#2,routine_secondary(a0)	; Sub8
	move.w	#$A,objoff_2A(a0)
	move.w	#-$300,y_vel(a0)	; first bounce higher
	cmpi.b	#2,priority(a0)
	beq.w	JmpTo35_DisplaySprite
	neg.w	x_vel(a0)	; into other direction
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F7D2:	; Obj56_Wheel_Sub8:
	subq.w	#1,objoff_2A(a0)	; timer, initially set to $A (second delay until wheels rolling off)
	bpl.w	JmpTo35_DisplaySprite
	jsrto	ObjectMoveAndFall, JmpTo4_ObjectMoveAndFall
	jsrto	ObjCheckFloorDist, JmpTo3_ObjCheckFloorDist
	tst.w	d1
	bpl.s	BranchTo_JmpTo36_MarkObjGone
	move.w	#-$200,y_vel(a0)	; negative velocity to have bouncing effect
	add.w	d1,y_pos(a0)	; reset on floor

BranchTo_JmpTo36_MarkObjGone ; BranchTo
	jmpto	MarkObjGone, JmpTo36_MarkObjGone
; ===========================================================================

loc_2F7F4:	; Obj56_Spike:
	tst.b	routine_secondary(a0)
	bne.s	loc_2F824
; Obj56_Spike_Sub0:
	cmpi.w	#$28F0,(Camera_Min_X_pos).w
	blo.w	JmpTo35_DisplaySprite
	cmpi.w	#$299A,x_pos(a0)
	ble.s	loc_2F816
	subi_.w	#1,x_pos(a0)
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F816:
	move.w	#$299A,x_pos(a0)
	addq.b	#2,routine_secondary(a0)
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F824:	; Obj56_Spike_Sub2:
	movea.l	objoff_34(a0),a1 ; parent address (vehicle)
	cmpi.b	#ObjID_EHZBoss,id(a1)
	bne.w	JmpTo52_DeleteObject	; if boss non-existant
	btst	#3,objoff_2D(a1)
	bne.s	loc_2F88A	; spike separated from vehicle
	bsr.w	loc_2F8AA
	btst	#1,objoff_2D(a1)
	beq.w	JmpTo35_DisplaySprite	; boss not moving yet (inactive)
	move.b	#$8B,collision_flags(a0)	; spike still linked to vehicle
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.b	status(a1),status(a0)	; transfer positions
	move.b	render_flags(a1),render_flags(a0)
	addi.w	#$10,y_pos(a0)	; vertical offset
	move.w	#-$36,d0
	btst	#0,status(a0)
	beq.s	loc_2F878
	neg.w	d0

loc_2F878:
	add.w	d0,x_pos(a0)	; horizontal offset
	lea	(Ani_obj56_b).l,a1
	jsrto	AnimateSprite, JmpTo17_AnimateSprite
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F88A:	; spike separated from vehicle
	move.w	#-3,d0	; velocity of spike in pixels/frame
	btst	#0,status(a0)	; check direction
	beq.s	loc_2F898
	neg.w	d0

loc_2F898:
	add.w	d0,x_pos(a0)
	lea	(Ani_obj56_b).l,a1
	jsrto	AnimateSprite, JmpTo17_AnimateSprite
	bra.w	JmpTo35_DisplaySprite
; ---------------------------------------------------------------------------

loc_2F8AA:
	cmpi.b	#1,collision_property(a1)	; hit counter, only 1 life left?
	beq.s	loc_2F8B4
	rts
; ---------------------------------------------------------------------------

loc_2F8B4:
	move.w	x_pos(a0),d0
	sub.w	(MainCharacter+x_pos).w,d0
	bpl.s	loc_2F8C8
	btst	#0,status(a1)	; Sonic right from spike
	bne.s	loc_2F8D2	; spike facing right
	rts
; ---------------------------------------------------------------------------

loc_2F8C8:
	btst	#0,status(a1)	; Sonic left from spike
	beq.s	loc_2F8D2	; spike facing left
	rts
; ---------------------------------------------------------------------------

loc_2F8D2:
	bset	#3,objoff_2D(a1)	; flag to separate spike from vehicle
	rts
; ===========================================================================

loc_2F8DA:	; Obj56_VehicleTop:
	movea.l	objoff_34(a0),a1 ; parent address (vehicle)
	move.l	x_pos(a1),x_pos(a0)
	move.l	y_pos(a1),y_pos(a0)
	move.b	status(a1),status(a0)	; update position and status
	move.b	render_flags(a1),render_flags(a0)
	move.b	objoff_3E(a1),d0	; boss invincibility timer
	cmpi.b	#$1F,d0	; boss just got hit?
	bne.s	loc_2F906
	move.b	#2,anim(a0)	; Robotnik animation when hit

loc_2F906:
	cmpi.b	#4,(MainCharacter+routine).w	; Sonic = ball
	beq.s	loc_2F916
	cmpi.b	#4,(Sidekick+routine).w	; Tails = ball
	bne.s	loc_2F924

loc_2F916:
	cmpi.b	#2,anim(a0)	; check Eggman animation (when hit)
	beq.s	loc_2F924
	move.b	#3,anim(a0)	; Eggman animation when hurting Sonic

loc_2F924:
	lea	(Ani_obj56_c).l,a1	; animation script
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================
; animation script
; off_2F936:
Ani_obj56_a:	offsetTable
		offsetTableEntry.w byte_2F93C	; 0
		offsetTableEntry.w byte_2F940	; 1
		offsetTableEntry.w byte_2F956	; 2
byte_2F93C:
	dc.b   1,  5,  6,$FF
byte_2F940:
	dc.b   1,  1,  1,  1,  2,  2,  2,  3,  3,  3,  4,  4,  4,  0,  0,  0
	dc.b   0,  0,  0,  0,  0,$FF; 16
byte_2F956:
	dc.b   1,  0,  0,  0,  0,  0,  0,  0,  0,  4,  4,  4,  3,  3,  3,  2
	dc.b   2,  2,  1,  1,  1,  5,  6,$FE,  2
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj56_MapUnc_2F970:	include "mappings/sprite/obj56_a.asm"
	; propeller
	; 7 frames

; animation script
; off_2FA44:
Ani_obj56_b:	offsetTable
		offsetTableEntry.w byte_2FA4A	; 0
		offsetTableEntry.w byte_2FA4F	; 1
		offsetTableEntry.w byte_2FA53	; 2
byte_2FA4A:
	dc.b   5,  1,  2,  3,$FF	; spike
	rev02even
byte_2FA4F:
	dc.b   1,  4,  5,$FF	; foreground wheel
	rev02even
byte_2FA53:
	dc.b   1,  6,  7,$FF	; background wheel
	even

; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj56_MapUnc_2FA58:	include "mappings/sprite/obj56_b.asm"
	; ground vehicle
	; frame 0 = vehicle itself
	; frame 1-3 = spike
	;	frame 4-5 = foreground wheel
	; frame 6-7 = background wheel

; animation script
; off_2FAC8:
Ani_obj56_c:	offsetTable
		offsetTableEntry.w byte_2FAD2	; 0
		offsetTableEntry.w byte_2FAD5	; 1
		offsetTableEntry.w byte_2FAD9	; 2
		offsetTableEntry.w byte_2FAE2	; 3
		offsetTableEntry.w byte_2FAEB	; 4
byte_2FAD2:	dc.b  $F,  0,$FF	; bottom
	rev02even
byte_2FAD5:	dc.b   7,  1,  2,$FF	; top, normal
	rev02even
byte_2FAD9:	dc.b   7,  5,  5,  5,  5,  5,  5,$FD,  1	;	top, when hit
	rev02even
byte_2FAE2:	dc.b   7,  3,  4,  3,  4,  3,  4,$FD,  1	; top, laughter (when hurting Sonic)
	rev02even
byte_2FAEB:	dc.b  $F,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,$FD,  1	; top, when flying off
	even	; for top part, after end of special animations always return to normal one ($FD->1)

; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj56_MapUnc_2FAF8:	include "mappings/sprite/obj56_c.asm"
	; flying vehicle
	; frame 0 = bottom
	; frame 1-2 = top, normal
	; frame 3-4 = top, laughter
	; frame 5 = top, when hit
	; frame 6 = top, when flying off
; ===========================================================================

    if ~~removeJmpTos
JmpTo35_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo52_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo36_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo5_DeleteObject2 ; JmpTo
	jmp	(DeleteObject2).l
JmpTo6_PlaySound ; JmpTo
	jmp	(PlaySound).l
JmpTo21_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo17_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo9_Adjust2PArtPointer2 ; JmpTo
	jmp	(Adjust2PArtPointer2).l
JmpTo3_ObjCheckFloorDist ; JmpTo
	jmp	(ObjCheckFloorDist).l
JmpTo6_LoadPLC ; JmpTo
	jmp	(LoadPLC).l
JmpTo3_AddPoints ; JmpTo
	jmp	(AddPoints).l
JmpTo61_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo2_PlayLevelMusic ; play level Music
	jmp	(PlayLevelMusic).l
JmpTo2_LoadPLC_AnimalExplosion ; PLC_Explosion
	jmp	(LoadPLC_AnimalExplosion).l
JmpTo4_ObjectMoveAndFall ; JmpTo
	jmp	(ObjectMoveAndFall).l

	align 4
    else
JmpTo52_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo35_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
    endif
