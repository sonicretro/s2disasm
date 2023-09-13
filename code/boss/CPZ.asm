; ===========================================================================
; ----------------------------------------------------------------------------
; Object 5D - CPZ boss
; ----------------------------------------------------------------------------
; OST Variables:
Obj5D_timer2		= objoff_2A
Obj5D_pipe_segments	= objoff_2C
Obj5D_status		= objoff_2D
Obj5D_status2		= objoff_2E
Obj5D_x_vel		= objoff_2E	; and $2F
Obj5D_x_pos_next	= objoff_30
Obj5D_timer		= objoff_30
Obj5D_y_offset		= objoff_31
Obj5D_timer3		= objoff_32
Obj5D_parent		= objoff_34
Obj5D_y_pos_next	= objoff_38
Obj5D_defeat_timer	= objoff_3C
Obj5D_flag		= objoff_3C
Obj5D_timer4		= objoff_3C
Obj5D_invulnerable_time	= objoff_3E
Obj5D_hover_counter	= objoff_3F

; Sprite_2D734:
Obj5D:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj5D_Index(pc,d0.w),d1
	jmp	Obj5D_Index(pc,d1.w)
; ===========================================================================
; off_2D742:
Obj5D_Index:	offsetTable
		offsetTableEntry.w Obj5D_Init		;   0
		offsetTableEntry.w Obj5D_Main		;   2
		offsetTableEntry.w Obj5D_Pipe		;   4
		offsetTableEntry.w Obj5D_Pipe_Pump	;   6
		offsetTableEntry.w Obj5D_Pipe_Retract	;   8
		offsetTableEntry.w Obj5D_Dripper	;  $A
		offsetTableEntry.w Obj5D_Gunk		;  $C
		offsetTableEntry.w Obj5D_PipeSegment	;  $E
		offsetTableEntry.w Obj5D_Container	; $10
		offsetTableEntry.w Obj5D_Pump		; $12
		offsetTableEntry.w Obj5D_FallingParts	; $14
		offsetTableEntry.w Obj5D_Robotnik	; $16
		offsetTableEntry.w Obj5D_Flame		; $18
		offsetTableEntry.w Obj5D_Smoke_Puff	; $1A
; ===========================================================================
; loc_2D75E:
Obj5D_Init:
	; main vehicle
	move.l	#Obj5D_MapUnc_2ED8C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Eggpod_3,1,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.w	#$2B80,x_pos(a0)
	move.w	#$4B0,y_pos(a0)
	move.b	#3,priority(a0)
	move.b	#$F,collision_flags(a0)
	move.b	#8,collision_property(a0)
	addq.b	#2,routine(a0)	; => Obj5D_Main
	move.w	x_pos(a0),Obj5D_x_pos_next(a0)
	move.w	y_pos(a0),Obj5D_y_pos_next(a0)
	bclr	#3,Obj5D_status(a0)
	jsrto	Adjust2PArtPointer, JmpTo60_Adjust2PArtPointer

	; Robotnik sitting in his eggmobile
	jsr	(AllocateObjectAfterCurrent).l
	bne.w	loc_2D8AC
	_move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	a1,Obj5D_parent(a0)
	move.l	#Obj5D_MapUnc_2ED8C,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Eggpod_3,0,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#3,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#$16,routine(a1)	; => Obj5D_Robotnik
	move.b	#1,anim(a1)
	move.b	render_flags(a0),render_flags(a1)
	jsrto	Adjust2PArtPointer2, JmpTo8_Adjust2PArtPointer2
	tst.b	subtype(a0)
	bmi.w	loc_2D8AC

	; eggmobile's exhaust flame
	jsr	(AllocateObjectAfterCurrent).l
	bne.w	loc_2D8AC
	_move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EE88,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_EggpodJets_1,0,0),art_tile(a1)
	jsrto	Adjust2PArtPointer2, JmpTo8_Adjust2PArtPointer2
	move.b	#1,anim_frame_duration(a0)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#3,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#$18,routine(a1)	; => Obj5D_Flame
	move.b	render_flags(a0),render_flags(a1)

	; large pump mechanism on top of eggmobile
	jsr	(AllocateObjectAfterCurrent).l
	bne.s	loc_2D8AC
	_move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#2,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#$12,routine(a1)	; => Obj5D_Pump

loc_2D8AC:
	; glass container that dumps mega mack on player
	jsr	(AllocateObjectAfterCurrent).l
	bne.s	loc_2D908
	_move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#4,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	subi.w	#$38,y_pos(a1)
	subi.w	#$10,x_pos(a1)
	move.w	#-$10,Obj5D_x_vel(a1)
	addi.b	#$10,routine(a1)	; => Obj5D_Container
	move.b	#6,anim(a1)

loc_2D908:
	; pipe used to suck mega mack from tube below
	jsr	(AllocateObjectAfterCurrent).l
	bne.s	return_2D94C
	_move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#4,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#4,routine(a1)		; => Obj5D_Pipe

return_2D94C:
	rts
; ===========================================================================

Obj5D_Main:
	bsr.w	Obj5D_LookAtChar
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj5D_Main_Index(pc,d0.w),d1
	jsr	Obj5D_Main_Index(pc,d1.w)
	lea	(Ani_obj5D_b).l,a1
	jsr	(AnimateSprite).l
	move.b	status(a0),d0
	andi.b	#3,d0
	andi.b	#$FC,render_flags(a0)
	or.b	d0,render_flags(a0)
	jmp	(DisplaySprite).l
; ===========================================================================
Obj5D_Main_Index:	offsetTable
		offsetTableEntry.w Obj5D_Main_Descend		;  0
		offsetTableEntry.w Obj5D_Main_MoveTowardTarget	;  2
		offsetTableEntry.w Obj5D_Main_Wait		;  4
		offsetTableEntry.w Obj5D_Main_FollowPlayer	;  6
		offsetTableEntry.w Obj5D_Main_Explode		;  8
		offsetTableEntry.w Obj5D_Main_StopExploding	; $A
		offsetTableEntry.w Obj5D_Main_Retreat		; $C
; ===========================================================================
; Makes the boss look in Sonic's direction under certain circumstances.

Obj5D_LookAtChar:
	cmpi.b	#8,routine_secondary(a0)
	bge.s	+
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	x_pos(a0),d0
	bgt.s	++
	bclr	#0,status(a0)
+
	rts
; ---------------------------------------------------------------------------
+
	bset	#0,status(a0)
	rts
; ===========================================================================
;Obj5D_Main_8:
Obj5D_Main_Explode:
	subq.w	#1,Obj5D_defeat_timer(a0)
	bpl.w	Obj5D_Main_CreateExplosion
	bset	#0,status(a0)
	bclr	#7,status(a0)
	clr.w	x_vel(a0)
	addq.b	#2,routine_secondary(a0)	; => Obj5D_Main_StopExploding
	move.w	#-$26,Obj5D_defeat_timer(a0)
	rts
; ===========================================================================
;Obj5D_Main_A:
Obj5D_Main_StopExploding:
	addq.w	#1,Obj5D_defeat_timer(a0)
	beq.s	+
	bpl.s	++
	; Fall slightly
	addi.w	#$18,y_vel(a0)
	bra.s	Obj5D_Main_A_End
; ---------------------------------------------------------------------------
+
	; Stop falling
	clr.w	y_vel(a0)
	bra.s	Obj5D_Main_A_End
; ---------------------------------------------------------------------------
+
	cmpi.w	#$30,Obj5D_defeat_timer(a0)
	blo.s	+
	beq.s	++
	cmpi.w	#$38,Obj5D_defeat_timer(a0)
	blo.s	Obj5D_Main_A_End
	addq.b	#2,routine_secondary(a0)	; => Obj5D_Main_Retreat
	bra.s	Obj5D_Main_A_End
; ---------------------------------------------------------------------------
+
	; Rise slightly
	subi_.w	#8,y_vel(a0)
	bra.s	Obj5D_Main_A_End
; ---------------------------------------------------------------------------
+
	; Stop rising
	clr.w	y_vel(a0)
	jsrto	PlayLevelMusic, JmpTo_PlayLevelMusic
	jsrto	LoadPLC_AnimalExplosion, JmpTo_LoadPLC_AnimalExplosion

Obj5D_Main_A_End:
	bsr.w	Obj5D_Main_Move
	bra.w	Obj5D_Main_Pos_and_Collision
; ===========================================================================
;Obj5D_Main_C:
Obj5D_Main_Retreat:
	bset	#6,Obj5D_status2(a0)
	move.w	#$400,x_vel(a0)
	move.w	#-$40,y_vel(a0)
	cmpi.w	#$2C30,(Camera_Max_X_pos).w
	bhs.s	+
	addq.w	#2,(Camera_Max_X_pos).w
	bra.s	Obj5D_Main_C_End
; ===========================================================================
+
	tst.b	render_flags(a0)
	bpl.s	Obj5D_Main_Delete

Obj5D_Main_C_End:
	bsr.w	Obj5D_Main_Move
	bra.w	Obj5D_Main_Pos_and_Collision
; ===========================================================================

Obj5D_Main_Delete:
	addq.l	#4,sp
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	jsr	(DeleteObject2).l

    if removeJmpTos
JmpTo51_DeleteObject ; JmpTo
    endif

	jmp	(DeleteObject).l
; ===========================================================================
;Obj5D_Main_0:
Obj5D_Main_Descend:
	; Strangely, there is code here for Eggman to descend into the arena
	; just like he does in Green Hill Zone in Sonic 1. Because Eggman
	; spawns off-screen, the player never gets to see him do this.
	; The reason for this is that this entire function is copied from
	; Green Hill Zone's boss (see `BGHZ_ShipStart` in the Sonic 1
	; disassembly).
	move.w	#$100,y_vel(a0)
	bsr.w	Obj5D_Main_Move
	cmpi.w	#$4C0,Obj5D_y_pos_next(a0)
	bne.s	Obj5D_Main_Pos_and_Collision
	move.w	#0,y_vel(a0)
	addq.b	#2,routine_secondary(a0)	; => Obj5D_Main_MoveTowardTarget

Obj5D_Main_Pos_and_Collision:
	; do hovering motion using sine wave
	move.b	Obj5D_hover_counter(a0),d0
	jsr	(CalcSine).l
	asr.w	#6,d0
	add.w	Obj5D_y_pos_next(a0),d0		; get y position for next frame, add sine value
	move.w	d0,y_pos(a0)			; set y and x positions
	move.w	Obj5D_x_pos_next(a0),x_pos(a0)
	addq.b	#2,Obj5D_hover_counter(a0)

	cmpi.b	#8,routine_secondary(a0)	; exploding or retreating?
	bhs.s	return_2DAE8			; if yes, branch
	tst.b	status(a0)
	bmi.s	Obj5D_Defeated		; branch, if boss is defeated
	tst.b	collision_flags(a0)
	bne.s	return_2DAE8		; branch, if collisions are not turned off

	; if collisions are turned off, it means the boss was hit
	tst.b	Obj5D_invulnerable_time(a0)
	bne.s	+			; branch, if still invulnerable
	move.b	#32,Obj5D_invulnerable_time(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l
+
	; Make the boss sprite flash by alternating the black
	; colour in palette line 3 between black and white.
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0		; color black
	tst.w	(a1)	; test palette entry
	bne.s	+	; branch, if it's not black
	move.w	#$EEE,d0	; color white
+
	move.w	d0,(a1)		; set color for flashing effect

	subq.b	#1,Obj5D_invulnerable_time(a0)
	bne.s	return_2DAE8
	move.b	#$F,collision_flags(a0)	; restore collisions
	bclr	#1,Obj5D_status(a0)

return_2DAE8:
	rts
; ===========================================================================
; called when status bit 7 is set (check Touch_Enemy_Part2)

Obj5D_Defeated:
	moveq	#100,d0
	jsrto	AddPoints, JmpTo2_AddPoints
	move.b	#8,routine_secondary(a0)	; => Obj5D_Main_Explode
	move.w	#60*3-1,Obj5D_defeat_timer(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.b	#4,anim(a1)
	moveq	#PLCID_Capsule,d0
	jmpto	LoadPLC, JmpTo5_LoadPLC
; ===========================================================================
	rts
; ===========================================================================

Obj5D_Main_Move:
	move.l	Obj5D_x_pos_next(a0),d2
	move.l	Obj5D_y_pos_next(a0),d3
	move.w	x_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d2
	move.w	y_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d2,Obj5D_x_pos_next(a0)
	move.l	d3,Obj5D_y_pos_next(a0)
	rts
; ===========================================================================
; Creates an explosion every 8 frames at a random position relative to boss.
;Obj5D_Main_Explode:
Obj5D_Main_CreateExplosion:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#7,d0
	bne.s	+	; rts
	jsr	(AllocateObject).l
	bne.s	+	; rts
	_move.b	#ObjID_BossExplosion,id(a1) ; load obj58
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	jsr	(RandomNumber).l
	move.w	d0,d1
	moveq	#0,d1
	move.b	d0,d1
	lsr.b	#2,d1
	subi.w	#$20,d1
	add.w	d1,x_pos(a1)
	lsr.w	#8,d0
	lsr.b	#2,d0
	subi.w	#$20,d0
	add.w	d0,y_pos(a1)
+
	rts
; ===========================================================================
; Creates an explosion.

Obj5D_Main_Explode2:
	jsr	(AllocateObject).l
	bne.s	+	; rts
	_move.b	#ObjID_BossExplosion,id(a1) ; load obj58
	; This code suggests that the intended effect is for each piece of
	; the boss to explode before falling off. However, this does not work
	; as the `x_pos` and `y_pos` values do not match the actual physical
	; locations of the pieces. In fact, most pieces' X and Y positions are
	; in the middle of the Eggmobile, completely ruining the effect.
	; I would use `fixBugs` to fix this, but this is a pretty deep-rooted
	; issue to would be complicated to fix.
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
+
	rts
; ===========================================================================
;Obj5D_Main_2:
Obj5D_Main_MoveTowardTarget:
	btst	#3,Obj5D_status(a0)	; is boss on the left side of the arena?
	bne.s	+			; if yes, branch
	move.w	#$2B30,d0	; right side of arena
	bra.s	++
; ---------------------------------------------------------------------------
+
	move.w	#$2A50,d0	; left side of arena
+
	move.w	d0,d1
	sub.w	Obj5D_x_pos_next(a0),d0
	bpl.s	+
	neg.w	d0	; get absolute value
+
	cmpi.w	#3,d0
	ble.s	Obj5D_Main_2_Stop	; branch, if boss is within 3 pixels to his target
	cmp.w	Obj5D_x_pos_next(a0),d1
	bgt.s	Obj5D_Main_2_MoveRight

;Obj5D_Main_2_MoveLeft:
	move.w	#-$300,x_vel(a0)
	bra.s	Obj5D_Main_2_End
; ---------------------------------------------------------------------------

Obj5D_Main_2_MoveRight:
	move.w	#$300,x_vel(a0)

Obj5D_Main_2_End:
	bsr.w	Obj5D_Main_Move
	bra.w	Obj5D_Main_Pos_and_Collision
; ===========================================================================

Obj5D_Main_2_Stop:
	; Once again, there's some strange code that changes Eggman's
	; behaviour if he's above or below his target. Because Eggman is
	; always at the expected Y position, this behaviour is never seen
	; in-game.
	cmpi.w	#$4C0,Obj5D_y_pos_next(a0)
	bne.w	Obj5D_Main_Pos_and_Collision

	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)	; Halt Eggman's vertical movement... not that he had any to begin with.
	addq.b	#2,routine_secondary(a0)	; => Obj5D_Main_Wait
	bchg	#3,Obj5D_status(a0)	; indicate boss is now at the other side
	bset	#0,Obj5D_status2(a0)	; action 0
	bra.w	Obj5D_Main_Pos_and_Collision
; ===========================================================================
; when status2 bit 0 set, wait for something
;Obj5D_Main_4:
Obj5D_Main_Wait:
	btst	#0,Obj5D_status2(a0)	; action 0?
	beq.s	+			; if not, branch
	bra.w	Obj5D_Main_Pos_and_Collision
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)	; => Obj5D_Main_FollowPlayer
	bra.w	Obj5D_Main_Pos_and_Collision
; ===========================================================================
;Obj5D_Main_6:
Obj5D_Main_FollowPlayer:
	move.w	(MainCharacter+x_pos).w,d0
	addi.w	#76,d0				; Keep a distance of 76 pixels when following the player.
	cmp.w	Obj5D_x_pos_next(a0),d0
	bgt.s	Obj5D_Main_6_MoveRight
	beq.w	Obj5D_Main_Pos_and_Collision

;Obj5D_Main_6_MoveLeft:
	subi.l	#$10000,Obj5D_x_pos_next(a0)	; move left one pixel
	; stop at left boundary
	cmpi.w	#$2A28,Obj5D_x_pos_next(a0)
	bgt.w	Obj5D_Main_Pos_and_Collision
	move.w	#$2A28,Obj5D_x_pos_next(a0)
	bra.w	Obj5D_Main_Pos_and_Collision
; ---------------------------------------------------------------------------

Obj5D_Main_6_MoveRight:
	addi.l	#$10000,Obj5D_x_pos_next(a0)	; move right one pixel
	; stop at right boundary
	cmpi.w	#$2B70,Obj5D_x_pos_next(a0)
	blt.w	Obj5D_Main_Pos_and_Collision
	move.w	#$2B70,Obj5D_x_pos_next(a0)
	bra.w	Obj5D_Main_Pos_and_Collision
; ===========================================================================

Obj5D_FallingParts:
	cmpi.b	#-7,Obj5D_timer(a0)
	beq.s	+
	subi_.b	#1,Obj5D_timer(a0)
	bgt.w	JmpTo34_DisplaySprite
	bsr.w	Obj5D_Main_Explode2
	move.b	#-7,Obj5D_timer(a0)
	move.w	#$1E,Obj5D_timer2(a0)
+
	subq.w	#1,Obj5D_timer2(a0)
	bpl.w	JmpTo34_DisplaySprite
	move.w	x_vel(a0),d0
	add.w	d0,x_pos(a0)
	move.l	y_pos(a0),d3
	move.w	y_vel(a0),d0
	addi.w	#$38,y_vel(a0)
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d3,y_pos(a0)
	cmpi.l	#$5800000,d3
	bhs.w	JmpTo51_DeleteObject
	jmpto	MarkObjGone, JmpTo35_MarkObjGone
; ===========================================================================

Obj5D_Pump:
	btst	#7,status(a0)
	bne.s	.bossDefeated

	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.l	x_pos(a1),x_pos(a0)
	move.l	y_pos(a1),y_pos(a0)
	move.b	render_flags(a1),render_flags(a0)
	move.b	status(a1),status(a0)
	movea.l	#Ani_Obj5D_Dripper,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------

.bossDefeated:
	; Split this object into three pieces which each separately fall
	; apart from the boss.
	moveq	#$22,d3	; Start with sprite $22
	move.b	#$78,Obj5D_timer(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.b	d3,mapping_frame(a0)
	move.b	#$14,routine(a0)	; => Obj5D_FallingParts
	jsr	(RandomNumber).l
	asr.w	#8,d0
	asr.w	#6,d0
	move.w	d0,x_vel(a0)
	move.w	#-$380,y_vel(a0)

	moveq	#2-1,d2 ; Create two more objects
	addq.w	#1,d3

-
	jsr	(AllocateObject).l
	bne.w	JmpTo51_DeleteObject
	_move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.b	d3,mapping_frame(a1)
	move.b	#$14,routine(a1)	; => Obj5D_FallingParts
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#2,priority(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	status(a0),status(a1)
	move.b	render_flags(a0),render_flags(a1)
	jsr	(RandomNumber).l
	asr.w	#8,d0
	asr.w	#6,d0
	move.w	d0,x_vel(a1)
	move.w	#-$380,y_vel(a1)
	swap	d0
	addi.b	#$1E,d0
	andi.w	#$7F,d0
	move.b	d0,Obj5D_timer(a1)
	addq.w	#1,d3	; Next sprite
	dbf	d2,-
    if fixBugs
	jmp	(DisplaySprite).l
    else
	; This function fails to display the current object, causing the top
	; piece of the Chemical Plant Zone boss to disappear for one frame when
	; the boss is defeated.
	rts
    endif
; ===========================================================================
; Object to control the pipe's actions before pumping starts.

Obj5D_Pipe:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj5D_Pipe_Index(pc,d0.w),d1
	jmp	Obj5D_Pipe_Index(pc,d1.w)
; ===========================================================================
Obj5D_Pipe_Index:	offsetTable
		offsetTableEntry.w Obj5D_Pipe_Wait	; 0
		offsetTableEntry.w Obj5D_Pipe_Extend	; 2
; ===========================================================================
; wait for main vehicle's action 0
;Obj5D_Pipe_0:
Obj5D_Pipe_Wait:
	; Bit 0 of `Obj5D_status2` is set when the boss has reached its
	; destination and is ready to begin filling its tank.
	movea.l	Obj5D_parent(a0),a1	; parent = main vehicle ; a1=object
	btst	#0,Obj5D_status2(a1)	; parent's action 0?
	bne.s	+			; if yes, branch
	; else, do nothing
	rts
; ---------------------------------------------------------------------------
+
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	addi.w	#$18,y_pos(a0)
    if fixBugs
	move.w	#$C-1,Obj5D_pipe_segments(a0)
    else
	; See the below bugfix.
	move.w	#$C,Obj5D_pipe_segments(a0)
    endif
	addq.b	#2,routine_secondary(a0)	; => Obj5D_Pipe_Extend
	movea.l	a0,a1
	bra.s	Obj5D_Pipe_Extend_Part2		; skip initial loading setup
; ===========================================================================
; load pipe segments, first object controls rest of pipe
; objects not loaded in a loop => one segment loaded per frame
; pipe extends gradually
;Obj5D_Pipe_2_Load:
Obj5D_Pipe_Extend:
	; This code allocates one more object than necessary, leaving a
	; partially initialised object in memory.
    if fixBugs
	subq.w  #1,Obj5D_pipe_segments(a0)	; is pipe fully extended?
	blt.s   Obj5D_Pipe_Extend_End		; if yes, branch
    endif
	jsr	(AllocateObjectAfterCurrent).l
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+
	move.l	a0,Obj5D_parent(a1)
;Obj5D_Pipe_2_Load_Part2:
Obj5D_Pipe_Extend_Part2:
    if ~~fixBugs
	subq.w  #1,Obj5D_pipe_segments(a0)	; is pipe fully extended?
	blt.s   Obj5D_Pipe_Extend_End		; if yes, branch
    endif

	_move.b #ObjID_CPZBoss,id(a1)	; load obj5D
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#5,priority(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)

	; calculate y position for current pipe segment
	move.w	Obj5D_pipe_segments(a0),d0
	subi.w	#$C-1,d0	; $B = maximum number of pipe segments -1, result is always negative or zero
	neg.w	d0	; positive value needed
	lsl.w	#3,d0	; multiply with 8
	move.w	d0,Obj5D_y_pos_next(a1)
	add.w	d0,y_pos(a1)
	move.b	#1,anim(a1)
	cmpi.b	#2,routine_secondary(a1)
	beq.w	Obj5D_PipeSegment	; only true for the first object
	move.b	#$E,routine(a1)	; => Obj5D_PipeSegment
	bra.w	Obj5D_PipeSegment
; ===========================================================================
; once all pipe segments have been loaded, switch to pumping routine
;Obj5D_Pipe_2_Load_End:
Obj5D_Pipe_Extend_End:
	move.b	#0,routine_secondary(a0)	; => Obj5D_Pipe_Pump_0
	move.b	#6,routine(a0)			; => Obj5D_Pipe_Pump
	bra.w	Obj5D_PipeSegment
; ===========================================================================
; Object to control the pipe's actions while pumping.

Obj5D_Pipe_Pump:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj5D_Pipe_Pump_Index(pc,d0.w),d1
	jmp	Obj5D_Pipe_Pump_Index(pc,d1.w)
; ===========================================================================
Obj5D_Pipe_Pump_Index:	offsetTable
		offsetTableEntry.w Obj5D_Pipe_Pump_0	; 0
		offsetTableEntry.w Obj5D_Pipe_Pump_2	; 2
		offsetTableEntry.w Obj5D_Pipe_Pump_4	; 4
; ===========================================================================
; prepares for pumping animation

Obj5D_Pipe_Pump_0:
	jsr	(AllocateObjectAfterCurrent).l
	bne.w	Obj5D_PipeSegment
	move.b	#$E,routine(a0)	; => Obj5D_PipeSegment	; temporarily turn control object into a pipe segment
	move.b	#6,routine(a1)			; => Obj5D_Pipe_Pump
	move.b	#2,routine_secondary(a1)	; => Obj5D_Pipe_Pump_2
	_move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#4,priority(a1)
	move.b	#2,Obj5D_timer3(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)

	; starting position for pumping animation
	move.w	#$B*8,d0
	move.b	d0,Obj5D_y_offset(a1)
	add.w	d0,y_pos(a1)
	move.b	#2,anim(a1)
	move.l	a0,Obj5D_parent(a1)	; address of control object
	move.b	#$12,Obj5D_timer(a1)

	jsr	(AllocateObjectAfterCurrent).l
	bne.s	BranchTo_Obj5D_PipeSegment
	_move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
	move.b	#$A,routine(a1)	; => Obj5D_Dripper
	move.l	Obj5D_parent(a0),Obj5D_parent(a1)

BranchTo_Obj5D_PipeSegment ; BranchTo
	bra.w	Obj5D_PipeSegment
; ===========================================================================
; do pumping animation

Obj5D_Pipe_Pump_2:
	movea.l	Obj5D_parent(a0),a1	; parent = pipe segment (control object) ; a1=object
	movea.l	Obj5D_parent(a1),a2	; parent = main vehicle ; a2=object
	btst	#7,status(a2)		; has boss been defeated?
	bne.w	JmpTo51_DeleteObject	; if yes, branch
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)

	subi_.b	#1,Obj5D_timer(a0)	; animation timer
	bne.s	Obj5D_Pipe_Pump_2_End
	; when timer reaches zero
	move.b	#$12,Obj5D_timer(a0)	; reset animation timer
	subi_.b	#8,Obj5D_y_offset(a0)	; move one segment up
	bgt.s	Obj5D_Pipe_Pump_2_End
	bmi.s	+	; pumping sequence is over when y offset becomes negative

	; one final delay when last segment is reached
	move.b	#3,anim(a0)
	move.b	#$C,Obj5D_timer(a0)
	bra.s	Obj5D_Pipe_Pump_2_End
; ---------------------------------------------------------------------------
+	; when pumping sequence is over
	move.b	#6,Obj5D_timer(a0)
	move.b	#4,routine_secondary(a0)	; => Obj5D_Pipe_Pump_4
	rts
; ---------------------------------------------------------------------------

Obj5D_Pipe_Pump_2_End:
	; set y position based on y offset
	moveq	#0,d0
	move.b	Obj5D_y_offset(a0),d0
	add.w	d0,y_pos(a0)
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

Obj5D_Pipe_Pump_4:
	subi_.b	#1,Obj5D_timer(a0)	; wait a few frames
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+
	subq.b	#1,Obj5D_timer3(a0)
	beq.s	+
	move.b	#2,anim(a0)
	move.b	#$12,Obj5D_timer(a0)
	move.b	#2,routine_secondary(a0)	; => Obj5D_Pipe_Pump_2
	move.b	#$B*8,Obj5D_y_offset(a0)
+
	; set control object's routine
	movea.l	Obj5D_parent(a0),a1	; parent = pipe segment (control object) ; a1=object
	move.b	#8,routine(a1)		; => Obj5D_Pipe_Retract
	move.b	#$B*8,Obj5D_y_offset(a1)
	bra.w	JmpTo51_DeleteObject
; ===========================================================================
; Object to control the pipe's actions after pumping is finished.

Obj5D_Pipe_Retract:
	tst.b	Obj5D_flag(a0)	; is flag set?
	bne.s	loc_2DFEE	; if yes, branch

	moveq	#0,d0
	move.b	Obj5D_y_offset(a0),d0
	add.w	y_pos(a0),d0	; get y pos of current pipe segment
	; This checks the entirety of the 'normal' object pool, even
	; though it only really has to search the dynamic object pool.
	lea	(Object_RAM).w,a1 ; a1=object
	moveq	#(Object_RAM_End-Object_RAM)/object_size-1,d1

Obj5D_Pipe_Retract_Loop:
	cmp.w	y_pos(a1),d0			; compare object's y position with current y offset
	beq.s	Obj5D_Pipe_Retract_ChkID	; if they match, branch
	lea	next_object(a1),a1 ; a1=object
	dbf	d1,Obj5D_Pipe_Retract_Loop	; continue as long as there are object slots left
	bra.s	Obj5D_PipeSegment
; ===========================================================================

loc_2DFD8:
	st.b	Obj5D_flag(a0)
	bra.s	Obj5D_PipeSegment
; ===========================================================================

Obj5D_Pipe_Retract_ChkID:
    if fixBugs
	cmpi.b	#ObjID_CPZBoss,id(a1)
    else
	; 'd7' should not be used here. This causes the 'RunObjects' routine
	; to either run too few objects or too many objects, causing all
	; sorts of errors.
	moveq	#0,d7
	move.b	#ObjID_CPZBoss,d7
	cmp.b	id(a1),d7	; is object a subtype of the CPZ Boss?
    endif
	beq.s	loc_2DFF0	; if yes, branch
    if fixBugs
	; There is no code to advance to the next object here.
	; This causes the loop to get stuck repeatedly checking the same
	; object until 'd1' reaches 0. If the boss's hovering motion is
	; disabled, then it's actually possible to get the boss's
	; pipe stuck because of this bug by positioning Sonic or Tails at the
	; same Y-coordinate as a pipe segment. Even if the boss's hovering
	; motion isn't disabled, this bug can still cause the pipe's updating
	; to be delayed by a frame.
	lea	next_object(a1),a1
    endif
	dbf	d1,Obj5D_Pipe_Retract_Loop
	bra.s	Obj5D_PipeSegment
; ===========================================================================

loc_2DFEE:
	movea.l	a0,a1

loc_2DFF0:
	bset	#7,status(a1)	; mark segment for deletion
	subi_.b	#8,Obj5D_y_offset(a0)	; position of next segment up
	beq.s	loc_2DFD8

Obj5D_PipeSegment:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	movea.l	Obj5D_parent(a1),a2 ; a2=object
	btst	#7,status(a2)		; has boss been defeated?
	bne.s	Obj5D_PipeSegment_End	; if yes, branch

	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	cmpi.b	#4,routine_secondary(a0)
	bne.s	+
	addi.w	#$18,y_pos(a0)
+
	btst	#7,status(a0)			; is object marked for deletion?
	bne.s	BranchTo_JmpTo51_DeleteObject	; if yes, branch
	move.w	Obj5D_y_pos_next(a0),d0
	add.w	d0,y_pos(a0)
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

BranchTo_JmpTo51_DeleteObject ; BranchTo
	bra.w	JmpTo51_DeleteObject
; ===========================================================================

Obj5D_PipeSegment_End:
	move.b	#$14,routine(a0)	; => Obj5D_FallingParts
	jsr	(RandomNumber).l
	asr.w	#8,d0
	asr.w	#6,d0
	move.w	d0,x_vel(a0)
	move.w	#-$380,y_vel(a0)
	swap	d0
	addi.b	#$1E,d0
	andi.w	#$7F,d0
	move.b	d0,Obj5D_timer(a0)
    if fixBugs
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
    else
	; If the Chemical Plant Zone boss is defeated while its pipe is
	; extending, then an incorrect sprite will appear at the boss's rear
	; as it explodes.
	; Pipe segments are supposed to use sprite frame 1, but the
	; AnimateSprite function must be called for that to happen. When the
	; boss is defeated, the segment will switch from calling
	; Obj5D_PipeSegment to Obj5D_PipeSegment_End, which does not call
	; AnimateSprite.
	; This means that if the boss were to be defeated right as a pipe
	; segment spawns, then it will never call AnimateSprite, causing it to
	; display sprite frame 0 instead of 1.
	; To fix this bug, Obj5D_PipeSegment_End should be made to call
	; AnimateSprite.
	jmpto	DisplaySprite, JmpTo34_DisplaySprite
    endif
; ===========================================================================

Obj5D_Dripper:
	btst	#7,status(a0)
	bne.w	JmpTo51_DeleteObject
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj5D_Dripper_States(pc,d0.w),d1
	jmp	Obj5D_Dripper_States(pc,d1.w)
; ===========================================================================
Obj5D_Dripper_States:	offsetTable
		offsetTableEntry.w Obj5D_Dripper_0	; 0
		offsetTableEntry.w Obj5D_Dripper_2	; 2
		offsetTableEntry.w Obj5D_Dripper_4	; 4
; ===========================================================================

Obj5D_Dripper_0:
	addq.b	#2,routine_secondary(a0)	; => Obj5D_Dripper_2
	_move.b	#ObjID_CPZBoss,id(a0) ; load 0bj5D
	move.l	#Obj5D_MapUnc_2EADC,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,3,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#4,priority(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.b	#$F,Obj5D_timer(a0)
	move.b	#4,anim(a0)

Obj5D_Dripper_2:
	subq.b	#1,Obj5D_timer(a0)
	bne.s	+
	move.b	#5,anim(a0)
	move.b	#4,Obj5D_timer(a0)
	addq.b	#2,routine_secondary(a0)
	subi.w	#$24,y_pos(a0)
	subi_.w	#2,x_pos(a0)
	rts
; ---------------------------------------------------------------------------
+
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.b	status(a1),status(a0)
	move.b	render_flags(a1),render_flags(a0)
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

Obj5D_Dripper_4:
	subq.b	#1,Obj5D_timer(a0)
	bne.s	+
	move.b	#0,routine_secondary(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	bset	#1,Obj5D_status2(a1)
	addq.b	#1,Obj5D_timer4(a0)
	cmpi.b	#$C,Obj5D_timer4(a0)
	bge.w	JmpTo51_DeleteObject
	rts
; ---------------------------------------------------------------------------
+
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	subi.w	#$24,y_pos(a0)
	subi_.w	#2,x_pos(a0)
	btst	#0,render_flags(a0)
	beq.s	+
	addi_.w	#4,x_pos(a0)
+
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

Obj5D_Container:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj5D_Container_States(pc,d0.w),d1
	jmp	Obj5D_Container_States(pc,d1.w)
; ===========================================================================
Obj5D_Container_States:	offsetTable
		offsetTableEntry.w Obj5D_Container_Init	; 0
		offsetTableEntry.w Obj5D_Container_Main	; 2
		offsetTableEntry.w Obj5D_Container_Floor	; 4
		offsetTableEntry.w Obj5D_Container_Extend	; 6
		offsetTableEntry.w Obj5D_Container_Floor2	; 8
		offsetTableEntry.w Obj5D_Container_FallOff	; A
; ===========================================================================

Obj5D_Container_Init:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	btst	#7,Obj5D_status2(a1)
	bne.s	+
	bset	#7,Obj5D_status2(a1)
	jsr	(AllocateObjectAfterCurrent).l
	bne.s	+
	_move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#4,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#$10,routine(a1)
	move.b	#4,routine_secondary(a1)	; => Obj5D_Container_Floor
	move.b	#9,anim(a1)
+
	jsr	(AllocateObjectAfterCurrent).l
	bne.s	+
	_move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,3,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#4,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	addi.b	#$10,routine(a1)
	move.b	#6,routine_secondary(a1)	; => Obj5D_Container_Extend
+
	addq.b	#2,routine_secondary(a0)	; => Obj5D_Container_Main

Obj5D_Container_Main:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	subi.w	#$38,y_pos(a0)
	btst	#7,status(a0)
	bne.s	loc_2E2E0
	btst	#2,Obj5D_status2(a1)
	beq.s	+
	bsr.w	loc_2E4CE
	bsr.w	loc_2E3F2
	bra.s	loc_2E2AC
; ---------------------------------------------------------------------------
+
	btst	#5,Obj5D_status2(a1)
	beq.s	loc_2E2AC
	subq.w	#1,Obj5D_timer2(a0)
	bne.s	loc_2E2AC
	bclr	#5,Obj5D_status2(a1)
	bset	#3,Obj5D_status2(a1)
	bset	#4,Obj5D_status2(a1)

loc_2E2AC:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.b	status(a1),status(a0)
	move.b	render_flags(a1),render_flags(a0)
	move.w	Obj5D_x_vel(a0),d0
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d0
+
	add.w	d0,x_pos(a0)
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

loc_2E2E0:
	move.b	#$A,routine_secondary(a0)
	bra.s	loc_2E2AC
; ===========================================================================

Obj5D_Container_FallOff:
	move.l	d7,-(sp)
	move.b	#$1E,Obj5D_timer(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	subi.w	#$38,y_pos(a0)
	move.w	Obj5D_x_vel(a0),d0
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d0
+
	add.w	d0,x_pos(a0)
	move.b	#$20,mapping_frame(a0)
	move.b	#$14,routine(a0)	; => Obj5D_FallingParts
	jsr	(RandomNumber).l
	asr.w	#8,d0
	asr.w	#6,d0
	move.w	d0,x_vel(a0)
	move.w	#-$380,y_vel(a0)
	moveq	#0,d7
	move.w	Obj5D_x_vel(a0),d0
	addi.w	#$18,d0
	bge.s	loc_2E356
	addi.w	#$18,d0
	bge.s	loc_2E354
	addi.w	#$18,d0
	bge.s	loc_2E352
	addq.w	#1,d7

loc_2E352:
	addq.w	#1,d7

loc_2E354:
	addq.w	#1,d7

loc_2E356:
	subq.w	#1,d7
	bmi.w	loc_2E3E6

loc_2E35C:
	jsr	(AllocateObject).l
	bne.w	JmpTo51_DeleteObject
	_move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.b	#$21,mapping_frame(a1)
	move.b	#$14,routine(a1)	; => Obj5D_FallingParts
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#2,priority(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi_.w	#8,y_pos(a1)
	move.w	d7,d2
	add.w	d2,d2
	move.w	word_2E3EC(pc,d2.w),d3
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d3
+
	add.w	d3,x_pos(a1)
	jsr	(RandomNumber).l
	asr.w	#8,d0
	asr.w	#6,d0
	move.w	d0,x_vel(a1)
	move.w	#-$380,y_vel(a1)
	swap	d0
	addi.b	#$1E,d0
	andi.w	#$7F,d0
	move.b	d0,Obj5D_timer(a1)
	dbf	d7,loc_2E35C

loc_2E3E6:
	move.l	(sp)+,d7

    if removeJmpTos
JmpTo34_DisplaySprite ; JmpTo
    endif

	jmpto	DisplaySprite, JmpTo34_DisplaySprite
; ===========================================================================
word_2E3EC:
	dc.w   $18
	dc.w   $30	; 1
	dc.w   $48	; 2
; ===========================================================================

loc_2E3F2:
	btst	#3,Obj5D_status2(a1)
	bne.w	return_2E4CC
	btst	#4,Obj5D_status2(a1)
	bne.w	return_2E4CC
	cmpi.w	#-$14,Obj5D_x_vel(a0)
	blt.s	+
	btst	#1,Obj5D_status(a1)
	beq.w	return_2E4CC
	bclr	#1,Obj5D_status(a1)
	bset	#2,Obj5D_status(a1)
	bra.s	loc_2E464
; ---------------------------------------------------------------------------
+
	cmpi.w	#-$40,Obj5D_x_vel(a0)
	bge.w	return_2E4CC
	move.w	(MainCharacter+x_pos).w,d1
	subi_.w	#8,d1
	btst	#0,render_flags(a0)
	beq.s	+
	add.w	Obj5D_x_vel(a0),d1
	sub.w	x_pos(a0),d1
	bgt.w	return_2E4CC
	cmpi.w	#-$18,d1
	bge.s	loc_2E464
	rts
; ---------------------------------------------------------------------------
+
	sub.w	Obj5D_x_vel(a0),d1
	sub.w	x_pos(a0),d1
	blt.s	return_2E4CC
	cmpi.w	#$18,d1
	bgt.s	return_2E4CC

loc_2E464:
	bset	#5,Obj5D_status2(a1)
	bclr	#2,Obj5D_status2(a1)
	move.w	#$12,Obj5D_timer2(a0)
	jsr	(AllocateObjectAfterCurrent).l
	bne.s	return_2E4CC
	_move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.b	#$10,routine(a1)		; => Obj5D_Container
	move.b	#8,routine_secondary(a1)	; => Obj5D_Container_Floor2
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#5,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#$B,anim(a1)
	move.w	#$24,Obj5D_timer2(a1)

return_2E4CC:
	rts
; ===========================================================================

loc_2E4CE:
	moveq	#1,d0
	btst	#4,Obj5D_status2(a1)
	bne.s	+
	moveq	#-1,d0
+
	cmpi.w	#-$10,Obj5D_x_vel(a0)
	bne.s	loc_2E552
	bclr	#4,Obj5D_status2(a1)
	beq.s	loc_2E552
	bclr	#2,Obj5D_status2(a1)
	clr.b	routine_secondary(a0)
	movea.l	a1,a2
	jsr	(AllocateObjectAfterCurrent).l
	bne.s	return_2E550
	_move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
	move.l	Obj5D_parent(a0),Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#4,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#4,routine(a1)		; => Obj5D_Pipe
	move.b	#0,routine_secondary(a0)
	bra.s	return_2E550
; ===========================================================================
	; Some mysterious dead code...
	move.b	#$A,routine(a1)		; => Obj5D_Dripper
	move.l	Obj5D_parent(a0),Obj5D_parent(a1)

return_2E550:
	rts
; ===========================================================================

loc_2E552:
	move.w	Obj5D_x_vel(a0),d1
	cmpi.w	#-$28,d1
	bge.s	loc_2E59C
	cmpi.w	#-$40,d1
	bge.s	loc_2E594
	move.b	#8,anim(a0)
	cmpi.w	#-$58,d1
	blt.s	loc_2E57E
	bgt.s	loc_2E578
	btst	#4,Obj5D_status2(a1)
	beq.s	return_2E57C

loc_2E578:
	add.w	d0,Obj5D_x_vel(a0)

return_2E57C:
	rts
; ===========================================================================

loc_2E57E:
	move.w	#-$58,Obj5D_x_vel(a0)
	btst	#0,render_flags(a0)
	beq.s	loc_2E578
	move.w	#$58,Obj5D_x_vel(a0)
	bra.s	loc_2E578
; ===========================================================================

loc_2E594:
	move.b	#7,anim(a0)
	bra.s	loc_2E578
; ===========================================================================

loc_2E59C:
	move.b	#6,anim(a0)
	bra.s	loc_2E578
; ===========================================================================

Obj5D_Container_Extend:
	btst	#7,status(a0)
	bne.w	JmpTo51_DeleteObject
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.l	Obj5D_parent(a1),d0
	beq.w	JmpTo51_DeleteObject
	movea.l	d0,a1 ; a1=object
	bclr	#3,Obj5D_status2(a1)
	beq.s	+
	move.b	#$C,routine(a0)
	move.b	#0,routine_secondary(a0)
	move.b	#$87,collision_flags(a0)
	bra.s	Obj5D_Container_Floor_End
; ----------------------------------------------------------------------------
+
	bclr	#1,Obj5D_status2(a1)
	bne.s	+
	tst.b	anim(a0)
	bne.s	Obj5D_Container_Floor_End
	rts
; ---------------------------------------------------------------------------
+
	tst.b	anim(a0)
	bne.s	+
	move.b	#$B,anim(a0)
+
	addi_.b	#1,anim(a0)
	cmpi.b	#$17,anim(a0)
	blt.s	Obj5D_Container_Floor_End
	bclr	#0,Obj5D_status2(a1)
	bset	#2,Obj5D_status2(a1)
	bra.s	Obj5D_Container_Floor_End
; ===========================================================================

Obj5D_Container_Floor:
	btst	#7,status(a0)
	bne.w	JmpTo51_DeleteObject
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	movea.l	Obj5D_parent(a1),a1
	btst	#5,Obj5D_status2(a1)
	beq.s	Obj5D_Container_Floor_End
	cmpi.b	#9,anim(a0)
	bne.s	Obj5D_Container_Floor_End
	move.b	#$A,anim(a0)

Obj5D_Container_Floor_End:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.b	render_flags(a1),render_flags(a0)
	move.b	status(a1),status(a0)
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

Obj5D_Container_Floor2:
	btst	#7,status(a0)
	bne.w	JmpTo51_DeleteObject
	subq.w	#1,Obj5D_timer2(a0)
	beq.w	JmpTo51_DeleteObject
	bra.s	Obj5D_Container_Floor_End
; ===========================================================================

Obj5D_Gunk:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj5D_Gunk_States(pc,d0.w),d1
	jmp	Obj5D_Gunk_States(pc,d1.w)
; ===========================================================================
Obj5D_Gunk_States:	offsetTable
		offsetTableEntry.w Obj5D_Gunk_Init	; 0
		offsetTableEntry.w Obj5D_Gunk_Main	; 2
		offsetTableEntry.w Obj5D_Gunk_Droplets	; 4
		offsetTableEntry.w Obj5D_Gunk_6	; 6
		offsetTableEntry.w Obj5D_Gunk_8	; 8
; ===========================================================================

Obj5D_Gunk_Init:
	addq.b	#2,routine_secondary(a0)	; => Obj5D_Gunk_Main
	move.b	#$20,y_radius(a0)
	move.b	#$19,anim(a0)
	move.w	#0,y_vel(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	movea.l	Obj5D_parent(a1),a1
	btst	#2,Obj5D_status(a1)
	beq.s	Obj5D_Gunk_Main
	bclr	#2,Obj5D_status(a1)
	move.b	#6,routine_secondary(a0)	; => Obj5D_Gunk_6
	move.w	#9,Obj5D_timer2(a0)

Obj5D_Gunk_Main:
	jsrto	ObjectMoveAndFall, JmpTo3_ObjectMoveAndFall
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bmi.s	+	; branch, if hit the floor
	cmpi.w	#$518,y_pos(a0)
	bge.s	Obj5D_Gunk_OffScreen	; branch, if fallen off screen
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================
+
	add.w	d1,y_pos(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	movea.l	Obj5D_parent(a1),a1
	bset	#2,Obj5D_status2(a1)
	bset	#4,Obj5D_status2(a1)
	move.b	#2,routine_secondary(a1)
	addq.b	#2,routine_secondary(a0)	; => Obj5D_Gunk_Droplets
	move.b	#0,subtype(a0)
	move.w	#SndID_MegaMackDrop,d0
	jsrto	PlaySound, JmpTo5_PlaySound
	jmp	(DisplaySprite).l
; ===========================================================================

Obj5D_Gunk_OffScreen:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	movea.l	Obj5D_parent(a1),a1
	bset	#2,Obj5D_status2(a1)
	bset	#4,Obj5D_status2(a1)
	move.b	#2,routine_secondary(a1)
	bra.w	JmpTo51_DeleteObject
; ===========================================================================

Obj5D_Gunk_6:
	subi_.w	#1,Obj5D_timer2(a0)
	bpl.s	+
	move.b	#2,priority(a0)
	move.b	#$25,mapping_frame(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	movea.l	Obj5D_parent(a1),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	addq.b	#2,routine_secondary(a0)	; => Obj5D_Gunk_8
	move.b	#8,anim_frame_duration(a0)
	bra.s	Obj5D_Gunk_8
; ===========================================================================
+
	jsrto	ObjectMove, JmpTo23_ObjectMove
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

Obj5D_Gunk_8:
	subi_.b	#1,anim_frame_duration(a0)
	bpl.s	+
	addi_.b	#1,mapping_frame(a0)
	move.b	#8,anim_frame_duration(a0)
	cmpi.b	#$27,mapping_frame(a0)
	bgt.w	Obj5D_Gunk_OffScreen
	blt.s	+
	addi.b	#$C,anim_frame_duration(a0)
+
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	movea.l	Obj5D_parent(a1),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	jmp	(DisplaySprite).l
; ===========================================================================

Obj5D_Gunk_Droplets:
	moveq	#0,d0
	move.b	subtype(a0),d0
	bne.w	Obj5D_Gunk_Droplets_Move
	addi.w	#$18,y_pos(a0)
	addi.w	#$C,x_pos(a0)
	btst	#0,render_flags(a0)
	beq.s	+
	subi.w	#$18,x_pos(a0)
+
	move.b	#4,y_radius(a0)
	move.b	#4,x_radius(a0)
	addq.b	#1,subtype(a0)
	move.b	#9,mapping_frame(a0)
	move.w	y_vel(a0),d0
	lsr.w	#1,d0
	neg.w	d0
	move.w	d0,y_vel(a0)
	jsr	(RandomNumber).l
	asr.w	#6,d0
	bmi.s	+
	addi.w	#$200,d0
+
	addi.w	#-$100,d0
	move.w	d0,x_vel(a0)
	move.b	#0,collision_flags(a0)
	moveq	#3,d3

Obj5D_Gunk_Droplets_Loop:
	jsr	(AllocateObjectAfterCurrent).l
	bne.w	BranchTo_JmpTo34_DisplaySprite
	_move.b	#ObjID_CPZBoss,id(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,3,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#2,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#4,y_radius(a1)
	move.b	#4,x_radius(a1)
	move.b	#9,mapping_frame(a1)
	move.b	#$C,routine(a1)
	move.b	#4,routine_secondary(a1)
	move.b	#1,subtype(a1)
	move.w	y_vel(a0),y_vel(a1)
	move.b	collision_flags(a0),collision_flags(a1)
	jsr	(RandomNumber).l
	asr.w	#6,d0
	bmi.s	+
	addi.w	#$80,d0
+
	addi.w	#-$80,d0
	move.w	d0,x_vel(a1)
	swap	d0
	andi.w	#$3FF,d0
	sub.w	d0,y_vel(a1)
	dbf	d3,Obj5D_Gunk_Droplets_Loop

BranchTo_JmpTo34_DisplaySprite ; BranchTo
	jmpto	DisplaySprite, JmpTo34_DisplaySprite
; ===========================================================================

Obj5D_Gunk_Droplets_Move:
	jsrto	ObjectMoveAndFall, JmpTo3_ObjectMoveAndFall
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bmi.s	+
	jmpto	MarkObjGone, JmpTo35_MarkObjGone
; ---------------------------------------------------------------------------
+
	bra.w	JmpTo51_DeleteObject
; ===========================================================================

	; a bit of unused/dead code here
	add.w	d1,y_pos(a0) ; a0=object
	move.w	y_vel(a0),d0
	lsr.w	#1,d0
	neg.w	d0
	move.w	d0,y_vel(a0)
	jmpto	DisplaySprite, JmpTo34_DisplaySprite

; ===========================================================================

Obj5D_Robotnik:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.l	x_pos(a1),x_pos(a0)
	move.l	y_pos(a1),y_pos(a0)
	move.b	status(a1),status(a0)
	move.b	render_flags(a1),render_flags(a0)
	move.b	Obj5D_invulnerable_time(a1),d0
	cmpi.b	#$1F,d0
	bne.s	+
	move.b	#2,anim(a0)
+
	cmpi.b	#4,(MainCharacter+routine).w
	beq.s	+
	cmpi.b	#4,(Sidekick+routine).w
	bne.s	Obj5D_Robotnik_End
+
	move.b	#3,anim(a0)

Obj5D_Robotnik_End:
	lea	(Ani_obj5D_b).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================
;byte_2E94A:
Obj5D_Flame_Frames:
	dc.b   0
	dc.b  -1	; 1
	dc.b   1	; 2
	even
; ===========================================================================

Obj5D_Flame:
	btst	#7,status(a0)
	bne.s	loc_2E9A8
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.l	x_pos(a1),x_pos(a0)
	move.l	y_pos(a1),y_pos(a0)
	move.b	status(a1),status(a0)
	move.b	render_flags(a1),render_flags(a0)
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	loc_2E996
	move.b	#1,anim_frame_duration(a0)
	move.b	Obj5D_timer2(a0),d0
	addq.b	#1,d0
	cmpi.b	#2,d0
	ble.s	+
	moveq	#0,d0
+
	move.b	Obj5D_Flame_Frames(pc,d0.w),mapping_frame(a0)
	move.b	d0,Obj5D_timer2(a0)

loc_2E996:
	cmpi.b	#-1,mapping_frame(a0)
	bne.w	JmpTo34_DisplaySprite
	move.b	#0,mapping_frame(a0)
	rts
; ===========================================================================

loc_2E9A8:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	btst	#6,Obj5D_status2(a1)
	bne.s	+
	rts
; ===========================================================================
+
    if fixBugs
	addq.b	#2,routine(a0)
    else
	; Eggman is supposed to start leaving a trail of smoke here, but
	; this code is incorrect which prevents it from appearing.
	; This should be 'routine' instead of 'routine_secondary'...
	addq.b	#2,routine_secondary(a0)
    endif
	move.l	#Obj5D_MapUnc_2EEA0,mappings(a0)
    if fixBugs
	move.w	#make_art_tile(ArtTile_ArtNem_BossSmoke_1,1,0),art_tile(a0)
    else
	; ...and this should be 'make_art_tile(ArtTile_ArtNem_BossSmoke_1,1,0)' instead.
	move.w	#make_art_tile(ArtTile_ArtNem_EggpodJets_1,0,0),art_tile(a0)
    endif
	jsrto	Adjust2PArtPointer, JmpTo60_Adjust2PArtPointer
	move.b	#0,mapping_frame(a0)
	move.b	#5,anim_frame_duration(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	addi_.w	#4,y_pos(a0)
	subi.w	#$28,x_pos(a0)
	rts
; ===========================================================================
; Obj5D_1A:
Obj5D_Smoke_Puff:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	BranchTo2_JmpTo34_DisplaySprite
	move.b	#5,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#4,mapping_frame(a0)
	bne.w	BranchTo2_JmpTo34_DisplaySprite
	move.b	#0,mapping_frame(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.b	id(a1),d0
	beq.w	JmpTo51_DeleteObject	; branch, if parent object is gone
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	addi_.w	#4,y_pos(a0)
	subi.w	#$28,x_pos(a0)

BranchTo2_JmpTo34_DisplaySprite
	jmpto	DisplaySprite, JmpTo34_DisplaySprite
; ===========================================================================
; animation script
; off_2EA3C:
Ani_Obj5D_Dripper:	offsetTable
		offsetTableEntry.w byte_2EA72	;   0
		offsetTableEntry.w byte_2EA75	;   1
		offsetTableEntry.w byte_2EA78	;   2
		offsetTableEntry.w byte_2EA7D	;   3
		offsetTableEntry.w byte_2EA81	;   4
		offsetTableEntry.w byte_2EA88	;   5
		offsetTableEntry.w byte_2EA8B	;   6
		offsetTableEntry.w byte_2EA8E	;   7
		offsetTableEntry.w byte_2EA91	;   8
		offsetTableEntry.w byte_2EA94	;   9
		offsetTableEntry.w byte_2EA97	;  $A
		offsetTableEntry.w byte_2EAA3	;  $B
		offsetTableEntry.w byte_2EAAE	;  $C
		offsetTableEntry.w byte_2EAB1	;  $D
		offsetTableEntry.w byte_2EAB4	;  $E
		offsetTableEntry.w byte_2EAB7	;  $F
		offsetTableEntry.w byte_2EABA	; $10
		offsetTableEntry.w byte_2EABD	; $11
		offsetTableEntry.w byte_2EAC0	; $12
		offsetTableEntry.w byte_2EAC3	; $13
		offsetTableEntry.w byte_2EAC6	; $14
		offsetTableEntry.w byte_2EAC9	; $15
		offsetTableEntry.w byte_2EACC	; $16
		offsetTableEntry.w byte_2EACF	; $17
		offsetTableEntry.w byte_2EAD2	; $18
		offsetTableEntry.w byte_2EAD5	; $19
		offsetTableEntry.w byte_2EAD9	; $1A
byte_2EA72:	dc.b  $F,  0,$FF
	rev02even
byte_2EA75:	dc.b  $F,  1,$FF
	rev02even
byte_2EA78:	dc.b   5,  2,  3,  2,$FF
	rev02even
byte_2EA7D:	dc.b   5,  2,  3,$FF
	rev02even
byte_2EA81:	dc.b   2,  4,  5,  6,  7,  8,$FF
	rev02even
byte_2EA88:	dc.b   3,  9,$FF
	rev02even
byte_2EA8B:	dc.b  $F, $A,$FF
	rev02even
byte_2EA8E:	dc.b  $F,$1C,$FF
	rev02even
byte_2EA91:	dc.b  $F,$1E,$FF
	rev02even
byte_2EA94:	dc.b  $F, $B,$FF
	rev02even
byte_2EA97:	dc.b   3, $C, $C, $D, $D, $D, $D, $D, $C, $C,$FD,  9
	rev02even
byte_2EAA3:	dc.b   3, $E, $E, $F, $F, $F, $F, $F, $E, $E,$FF
	rev02even
byte_2EAAE:	dc.b  $F,$10,$FF
	rev02even
byte_2EAB1:	dc.b  $F,$11,$FF
	rev02even
byte_2EAB4:	dc.b  $F,$12,$FF
	rev02even
byte_2EAB7:	dc.b  $F,$13,$FF
	rev02even
byte_2EABA:	dc.b  $F,$14,$FF
	rev02even
byte_2EABD:	dc.b  $F,$15,$FF
	rev02even
byte_2EAC0:	dc.b  $F,$16,$FF
	rev02even
byte_2EAC3:	dc.b  $F,$17,$FF
	rev02even
byte_2EAC6:	dc.b  $F,$18,$FF
	rev02even
byte_2EAC9:	dc.b  $F,$19,$FF
	rev02even
byte_2EACC:	dc.b  $F,$1A,$FF
	rev02even
byte_2EACF:	dc.b  $F,$1B,$FF
	rev02even
byte_2EAD2:	dc.b  $F,$1C,$FF
	rev02even
byte_2EAD5:	dc.b   1,$1D,$1F,$FF
	rev02even
byte_2EAD9:	dc.b  $F,$1E,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_CPZBoss
; ----------------------------------------------------------------------------
Obj5D_MapUnc_2EADC:	include "mappings/sprite/obj5D_a.asm"

; animation script
; off_2ED5C:
Ani_obj5D_b:	offsetTable
		offsetTableEntry.w byte_2ED66	; 0
		offsetTableEntry.w byte_2ED69	; 1
		offsetTableEntry.w byte_2ED6D	; 2
		offsetTableEntry.w byte_2ED76	; 3
		offsetTableEntry.w byte_2ED7F	; 4
byte_2ED66:	dc.b  $F,  0,$FF
	rev02even
byte_2ED69:	dc.b   7,  1,  2,$FF
	rev02even
byte_2ED6D:	dc.b   7,  5,  5,  5,  5,  5,  5,$FD,  1
	rev02even
byte_2ED76:	dc.b   7,  3,  4,  3,  4,  3,  4,$FD,  1
	rev02even
byte_2ED7F:	dc.b  $F,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,$FD,  1
	even

; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_Eggpod
; ----------------------------------------------------------------------------
Obj5D_MapUnc_2ED8C:	include "mappings/sprite/obj5D_b.asm"
; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_EggpodJets
; ----------------------------------------------------------------------------
Obj5D_MapUnc_2EE88:	include "mappings/sprite/obj5D_c.asm"
; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_BossSmoke
; ----------------------------------------------------------------------------
Obj5D_MapUnc_2EEA0:	include "mappings/sprite/obj5D_d.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo34_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo51_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo35_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo5_PlaySound ; JmpTo
	jmp	(PlaySound).l
JmpTo8_Adjust2PArtPointer2 ; JmpTo
	jmp	(Adjust2PArtPointer2).l
JmpTo5_LoadPLC ; JmpTo
	jmp	(LoadPLC).l
JmpTo2_AddPoints ; JmpTo
	jmp	(AddPoints).l
JmpTo60_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo_PlayLevelMusic ; JmpTo
	jmp	(PlayLevelMusic).l
JmpTo_LoadPLC_AnimalExplosion ; JmpTo
	jmp	(LoadPLC_AnimalExplosion).l
JmpTo3_ObjectMoveAndFall ; JmpTo
	jmp	(ObjectMoveAndFall).l
; loc_2EF12:
JmpTo23_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif
