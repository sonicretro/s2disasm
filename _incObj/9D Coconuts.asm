; ----------------------------------------------------------------------------
; Object 9D - Coconuts (monkey badnik) from EHZ
; ----------------------------------------------------------------------------
; OST Variables:
Obj9D_timer		= objoff_2A	; byte
Obj9D_climb_table_index	= objoff_2C	; word
Obj9D_attack_timer	= objoff_2E	; byte	; time player needs to spend close to object before it attacks
; Sprite_37BFA:
Obj9D:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj9D_Index(pc,d0.w),d1
	jmp	Obj9D_Index(pc,d1.w)
; ===========================================================================
; off_37C08:
Obj9D_Index:	offsetTable
		offsetTableEntry.w Obj9D_Init		; 0
		offsetTableEntry.w Obj9D_Idle		; 2
		offsetTableEntry.w Obj9D_Climbing	; 4
		offsetTableEntry.w Obj9D_Throwing	; 6
; ===========================================================================
; loc_37C10:
Obj9D_Init:
	bsr.w	LoadSubObject
	move.b	#$10,Obj9D_timer(a0)
	rts
; ===========================================================================
; loc_37C1C: Obj9D_Main:
Obj9D_Idle:
	bsr.w	Obj_GetOrientationToPlayer
	bclr	#render_flags.x_flip,render_flags(a0)	; face right
	bclr	#status.npc.x_flip,status(a0)
	tst.w	d0		; is player to object's left?
	beq.s	+		; if not, branch
	bset	#render_flags.x_flip,render_flags(a0)	; face left
	bset	#status.npc.x_flip,status(a0)
+
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	bcc.s	+	; branch, if distance to player is greater than 60 in either direction
	tst.b	Obj9D_attack_timer(a0)	; wait for a bit before attacking
	beq.s	Obj9D_StartThrowing	; branch, when done waiting
	subq.b	#1,Obj9D_attack_timer(a0)
+
	subq.b	#1,Obj9D_timer(a0)	; wait for a bit...
	bmi.s	Obj9D_StartClimbing	; branch, when done waiting
	jmpto	JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------

Obj9D_StartClimbing:
	addq.b	#2,routine(a0)	; => Obj9D_Climbing
	bsr.w	Obj9D_SetClimbingDirection
	jmpto	JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
; loc_37C66:
Obj9D_StartThrowing:
	move.b	#6,routine(a0)	; => Obj9D_Throwing
	move.b	#1,mapping_frame(a0)	; display first throwing frame
	move.b	#8,Obj9D_timer(a0)	; set time to display frame
	move.b	#$20,Obj9D_attack_timer(a0)	; reset timer
	jmpto	JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
; loc_37C82:
Obj9D_SetClimbingDirection:
	move.w	Obj9D_climb_table_index(a0),d0
	cmpi.w	#$C,d0
	blo.s	+	; branch, if index is less than $C
	moveq	#0,d0	; otherwise, reset to 0
+
	lea	Obj9D_ClimbData(pc,d0.w),a1
	addq.w	#2,d0
	move.w	d0,Obj9D_climb_table_index(a0)
	move.b	(a1)+,y_vel(a0)	; climbing speed
	move.b	(a1)+,Obj9D_timer(a0) ; time to spend moving at this speed
	rts
; ===========================================================================
; byte_37CA2:
Obj9D_ClimbData:
	dc.b  -1,$20
	dc.b   1,$18	; 2
	dc.b  -1,$10	; 4
	dc.b   1,$28	; 6
	dc.b  -1,$20	; 8
	dc.b   1,$10	; 10
; ===========================================================================
; loc_37CAE: Obj09_Climbing:
Obj9D_Climbing:
	subq.b	#1,Obj9D_timer(a0)
	beq.s	Obj9D_StopClimbing	; branch, if done moving
	jsrto	JmpTo26_ObjectMove	; else, keep moving
	lea	(Ani_obj09).l,a1
	jsrto	JmpTo25_AnimateSprite
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; loc_37CC6:
Obj9D_StopClimbing:
	subq.b	#2,routine(a0)	; => Obj9D_Idle
	move.b	#$10,Obj9D_timer(a0)	; time to remain idle
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; loc_37CD4: Obj09_Throwing:
Obj9D_Throwing:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj9D_ThrowingStates(pc,d0.w),d1
	jsr	Obj9D_ThrowingStates(pc,d1.w)
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_37CE6:
Obj9D_ThrowingStates:	offsetTable
		offsetTableEntry.w Obj9D_ThrowingHandRaised	; 0
		offsetTableEntry.w Obj9D_ThrowingHandLowered	; 2
; ===========================================================================
; loc_37CEA:
Obj9D_ThrowingHandRaised:
	subq.b	#1,Obj9D_timer(a0)	; wait for a bit...
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+	addq.b	#2,routine_secondary(a0)	; => Obj9D_ThrowingHandLowered
	move.b	#8,Obj9D_timer(a0)
	move.b	#2,mapping_frame(a0)	; display second throwing frame
	bra.w	Obj9D_CreateCoconut
; ===========================================================================
; loc_37D06:
Obj9D_ThrowingHandLowered:
	subq.b	#1,Obj9D_timer(a0)	; wait for a bit...
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+	clr.b	routine_secondary(a0)	; reset routine counter for next time
	move.b	#4,routine(a0) ; => Obj9D_Climbing
	move.b	#8,Obj9D_timer(a0)	; this gets overwrittten by the next subroutine...
	bra.w	Obj9D_SetClimbingDirection
; ===========================================================================
; loc_37D22:
Obj9D_CreateCoconut:
	jsrto	JmpTo19_AllocateObject
	bne.s	return_37D74		; branch, if no free slots
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	#3,mapping_frame(a1)
	move.b	#$20,subtype(a1) ; <== Obj9D_SubObjData2
	move.w	x_pos(a0),x_pos(a1)	; align with parent object
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#-$D,y_pos(a1)		; offset slightly upward
	moveq	#0,d0		; use rightfacing data
	btst	#render_flags.x_flip,render_flags(a0)	; is object facing left?
	bne.s	+		; if yes, branch
	moveq	#4,d0		; use leftfacing data
+
	lea	Obj9D_ThrowData(pc,d0.w),a2
	move.w	(a2)+,d0
	add.w	d0,x_pos(a1)	; offset slightly left or right depending on object's direction
	move.w	(a2)+,x_vel(a1)	; set projectile speed
	move.w	#-$100,y_vel(a1)
	lea_	Obj98_CoconutFall,a2 ; set the routine used to move the projectile
	move.l	a2,objoff_2A(a1)

return_37D74:
	rts
; ===========================================================================
; word_37D76:
Obj9D_ThrowData:
	dc.w   -$B,  $100	; 0
	dc.w	$B, -$100	; 4
; off_37D7E:
Obj9D_SubObjData:
	subObjData Obj9D_Obj98_MapUnc_37D96,make_art_tile(ArtTile_ArtNem_Coconuts,0,0),1<<render_flags.level_fg,5,$C,9
