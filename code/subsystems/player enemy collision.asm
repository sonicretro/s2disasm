; ---------------------------------------------------------------------------
; Object touch response subroutine - $20(a0) in the object RAM
; collides Sonic with most objects (enemies, rings, monitors...) in the level
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_3F554:
TouchResponse:
	nop
	jsrto	Touch_Rings, JmpTo_Touch_Rings
	; Bumpers in CNZ
	cmpi.b	#casino_night_zone,(Current_Zone).w
	bne.s	+
	jsrto	Check_CNZ_bumpers, JmpTo_Check_CNZ_bumpers
+
	tst.b	(Current_Boss_ID).w
	bne.w	Touch_Boss
	move.w	x_pos(a0),d2 ; load Sonic's position into d2,d3
	move.w	y_pos(a0),d3
	subi_.w	#8,d2
	moveq	#0,d5
	move.b	y_radius(a0),d5
	subq.b	#3,d5
	sub.w	d5,d3
    if fixBugs
	cmpi.b	#AniIDSonAni_Duck,anim(a0)	; is Sonic ducking?
    else
	; This logic only works for Sonic, not Tails. Also, it only applies
	; to the last frame of his ducking animation. This is a leftover from
	; Sonic 1, where Sonic's ducking animation only had one frame.
	cmpi.b	#$4D,mapping_frame(a0)	; is Sonic ducking?
    endif
	bne.s	Touch_NoDuck			; if not, branch
	addi.w	#$C,d3
	moveq	#$A,d5
; loc_3F592:
Touch_NoDuck:
	move.w	#$10,d4
	add.w	d5,d5
	lea	(Dynamic_Object_RAM).w,a1
	move.w	#(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d6
; loc_3F5A0:
Touch_Loop:
	; Note that this uses a branch instead of a 'bsr'.
	; This is because only one object can be collided with in a single frame.
	; If 'Touch_CheckCollision' determines that the character isn't colliding with the
	; object, then it manually branches back to 'Touch_NextObj' to try the next one.
	move.b	collision_flags(a1),d0
	bne.w	Touch_CheckCollision
; loc_3F5A8:
Touch_NextObj:
	lea	next_object(a1),a1 ; load obj address ; goto next object
	dbf	d6,Touch_Loop ; repeat 6F more times

	moveq	#0,d0
	rts
; ===========================================================================
; loc_3F5B4: Touch_Height: Touch_Width:
Touch_CheckCollision:
	andi.w	#$3F,d0
	add.w	d0,d0
	lea	Touch_Sizes(pc,d0.w),a2

	; From here to the branch to 'Touch_ChkValue', this code is the same as 'Touch_Boss_CheckWidth',
	; only it returns to 'Touch_NextObj' instead of 'Touch_Boss_NextObj'.
	; This could have been avoided with some clever stack usage.
;Touch_CheckWidth:
	moveq	#0,d1
	move.b	(a2)+,d1
	move.w	x_pos(a1),d0
	sub.w	d1,d0
	sub.w	d2,d0
	bcc.s	loc_3F5D6
	add.w	d1,d1
	add.w	d1,d0
	bcs.s	Touch_CheckHeight
	bra.w	Touch_NextObj
; ===========================================================================

loc_3F5D6:
	cmp.w	d4,d0
	bhi.w	Touch_NextObj
; loc_3F5DC: Touch_Width: Touch_Height:
Touch_CheckHeight:
	moveq	#0,d1
	move.b	(a2)+,d1
	move.w	y_pos(a1),d0
	sub.w	d1,d0
	sub.w	d3,d0
	bcc.s	loc_3F5F6
	add.w	d1,d1
	add.w	d1,d0
	bcs.w	Touch_ChkValue
	bra.w	Touch_NextObj
; ===========================================================================

loc_3F5F6:
	cmp.w	d5,d0
	bhi.w	Touch_NextObj
	; Here ends the duplicate code.
	bra.w	Touch_ChkValue
; ===========================================================================
; collision sizes (width,height)
; byte_3F600:
Touch_Sizes:
	dc.b   4,  4	;   0
	dc.b $14,$14	;   1
	dc.b  $C,$14	;   2
	dc.b $14, $C	;   3
	dc.b   4,$10	;   4
	dc.b  $C,$12	;   5
	dc.b $10,$10	;   6 - monitors
	dc.b   6,  6	;   7 - rings
	dc.b $18, $C	;   8
	dc.b  $C,$10	;   9
	dc.b $10,  8	;  $A
	dc.b   8,  8	;  $B
	dc.b $14,$10	;  $C
	dc.b $14,  8	;  $D
	dc.b  $E, $E	;  $E
	dc.b $18,$18	;  $F
	dc.b $28,$10	; $10
	dc.b $10,$18	; $11
	dc.b   8,$10	; $12
	dc.b $20,$70	; $13
	dc.b $40,$20	; $14
	dc.b $80,$20	; $15
	dc.b $20,$20	; $16
	dc.b   8,  8	; $17
	dc.b   4,  4	; $18
	dc.b $20,  8	; $19
	dc.b  $C, $C	; $1A
	dc.b   8,  4	; $1B
	dc.b $18,  4	; $1C
	dc.b $28,  4	; $1D
	dc.b   4,  8	; $1E
	dc.b   4,$18	; $1F
	dc.b   4,$28	; $20
	dc.b   4,$10	; $21
	dc.b $18,$18	; $22
	dc.b  $C,$18	; $23
	dc.b $48,  8	; $24
	dc.b $18,$28	; $25
	dc.b $10,  4	; $26
	dc.b $20,  2	; $27
	dc.b   4,$40	; $28
	dc.b $18,$80	; $29
	dc.b $20,$10	; $2A
	dc.b $10,$20	; $2B
	dc.b $10,$30	; $2C
	dc.b $10,$40	; $2D
	dc.b $10,$50	; $2E
	dc.b $10,  2	; $2F
	dc.b $10,  1	; $30
	dc.b   2,  8	; $31
	dc.b $20,$1C	; $32
; ===========================================================================
; loc_3F666:
Touch_Boss:
	lea	Touch_Sizes(pc),a3
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	subi_.w	#8,d2
	moveq	#0,d5
	move.b	y_radius(a0),d5
	subq.b	#3,d5
	sub.w	d5,d3
    if fixBugs
	cmpi.b	#AniIDSonAni_Duck,anim(a0)	; is Sonic ducking?
	bne.s	+				; if not, branch
    else
	; This logic only works for Sonic, not Tails. Also, it only applies
	; to the last frame of his ducking animation. This is a leftover from
	; Sonic 1, where Sonic's ducking animation only had one frame.
	cmpi.b	#$4D,mapping_frame(a0)	; is Sonic ducking?
	bne.s	+			; if not, branch
    endif
	addi.w	#$C,d3
	moveq	#$A,d5
+
	move.w	#$10,d4
	add.w	d5,d5
	lea	(Dynamic_Object_RAM).w,a1
	move.w	#(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d6
; loc_3F69C:
Touch_Boss_Loop:
	; Note that this uses a branch instead of a 'bsr'.
	; This is because only one object can be collided with in a single frame.
	; If 'Touch_Boss_CheckCollision' determines that the character isn't colliding with the
	; object, then it manually branches back to 'Touch_Boss_NextObj' to try the next one.
	move.b	collision_flags(a1),d0
	bne.s	Touch_Boss_CheckCollision
; loc_3F6A2:
Touch_Boss_NextObj:
	lea	next_object(a1),a1 ; a1=object
	dbf	d6,Touch_Boss_Loop

	moveq	#0,d0
	rts
; ===========================================================================
;loc_3F6AE:
Touch_Boss_CheckCollision:
	bsr.w	BossSpecificCollision
	andi.w	#$3F,d0
	beq.s	Touch_Boss_NextObj
	add.w	d0,d0
	lea	(a3,d0.w),a2

	; From here to 'Touch_ChkValue', this code is the same as 'Touch_CheckWidth',
	; only it returns to 'Touch_Boss_NextObj' instead of 'Touch_NextObj'.
	; This could have been avoided with some clever stack usage.
;Touch_Boss_CheckWidth:
	moveq	#0,d1
	move.b	(a2)+,d1
	move.w	x_pos(a1),d0
	sub.w	d1,d0
	sub.w	d2,d0
	bcc.s	loc_3F6D4
	add.w	d1,d1
	add.w	d1,d0
	bcs.s	Touch_Boss_CheckHeight
	bra.s	Touch_Boss_NextObj
; ===========================================================================

loc_3F6D4:
	cmp.w	d4,d0
	bhi.s	Touch_Boss_NextObj
;loc_3F6D8:
Touch_Boss_CheckHeight:
	moveq	#0,d1
	move.b	(a2)+,d1
	move.w	y_pos(a1),d0
	sub.w	d1,d0
	sub.w	d3,d0
	bcc.s	loc_3F6EE
	add.w	d1,d1
	add.w	d1,d0
	bcs.s	Touch_ChkValue
	bra.s	Touch_Boss_NextObj
; ===========================================================================

loc_3F6EE:
	cmp.w	d5,d0
	bhi.s	Touch_Boss_NextObj
	; Here ends the duplicate code.
; loc_3F6F2:
Touch_ChkValue:
	move.b	collision_flags(a1),d1	; load touch response number
	andi.b	#$C0,d1			; is touch response $40 or higher?
	beq.w	Touch_Enemy		; if not, branch
	cmpi.b	#$C0,d1			; is touch response $C0 or higher?
	beq.w	Touch_Special		; if yes, branch
	tst.b	d1			; is touch response $80-$BF?
	bmi.w	Touch_ChkHurt		; if yes, branch
	; touch response is $40-$7F
	move.b	collision_flags(a1),d0
	andi.b	#$3F,d0
	cmpi.b	#6,d0			; is touch response $46?
	beq.s	Touch_Monitor		; if yes, branch
	move.w	(MainCharacter+invulnerable_time).w,d0
	tst.w	(Two_player_mode).w
	beq.s	+
	move.w	invulnerable_time(a0),d0
+
	cmpi.w	#90,d0
	bhs.w	+
	move.b	#4,routine(a1)	; set the object's routine counter
	move.w	a0,parent(a1)
+
	rts
; ===========================================================================
; loc_3F73C:
Touch_Monitor:
	tst.w	y_vel(a0)	; is Sonic moving upwards?
	bpl.s	.breakMonitor	; if not, branch

	; If the center of Sonic is not under the bottom of the monitor, then
	; return. This is a way of checking if Sonic is jumping into the
	; bottom of the monitor, or just the side of it.
	move.w	y_pos(a0),d0
	subi.w	#$10,d0
	cmp.w	y_pos(a1),d0
	; Return. This means that if Sonic jumps upwards into the side of a
	; monitor, then he'll just phase through it.
	blo.s	return_3F78A

	; If we've gotten this far, then Sonic has just jumped into the
	; bottom of this monitor: knock it down.
	neg.w	y_vel(a0)	; reverse Sonic's y-motion
	move.w	#-$180,y_vel(a1)
	tst.b	routine_secondary(a1)
	bne.s	return_3F78A
	move.b	#4,routine_secondary(a1) ; set the monitor's routine counter
	rts
; ===========================================================================
; loc_3F768:
.breakMonitor:
	cmpa.w	#MainCharacter,a0
	beq.s	+
	tst.w	(Two_player_mode).w
	beq.s	return_3F78A
+
	cmpi.b	#AniIDSonAni_Roll,anim(a0)
	bne.s	return_3F78A
	neg.w	y_vel(a0)	; reverse Sonic's y-motion
	move.b	#4,routine(a1)
	move.w	a0,parent(a1)

return_3F78A:
	rts
; ===========================================================================
; loc_3F78C:
Touch_Enemy:
	btst	#status_sec_isInvincible,status_secondary(a0)	; is Sonic invincible?
	bne.s	+			; if yes, branch
	cmpi.b	#AniIDSonAni_Spindash,anim(a0)
	beq.s	+
	cmpi.b	#AniIDSonAni_Roll,anim(a0)		; is Sonic rolling?
	bne.w	Touch_ChkHurt		; if not, branch
+
	btst	#6,render_flags(a1)
	beq.s	Touch_Enemy_Part2
	tst.b	boss_hitcount2(a1)
	beq.s	return_3F7C6
	neg.w	x_vel(a0)
	neg.w	y_vel(a0)
	move.b	#0,collision_flags(a1)
	subq.b	#1,boss_hitcount2(a1)

return_3F7C6:
	rts
; ---------------------------------------------------------------------------
; loc_3F7C8:
Touch_Enemy_Part2:
	tst.b	collision_property(a1)
	beq.s	Touch_KillEnemy
	neg.w	x_vel(a0)
	neg.w	y_vel(a0)
	move.b	#0,collision_flags(a1)
	subq.b	#1,collision_property(a1)
	bne.s	return_3F7E8
	bset	#7,status(a1)

return_3F7E8:
	rts
; ===========================================================================
; loc_3F7EA:
Touch_KillEnemy:
	bset	#7,status(a1)
	moveq	#0,d0
	move.w	(Chain_Bonus_counter).w,d0
	addq.w	#2,(Chain_Bonus_counter).w	; add 2 to chain bonus counter
	cmpi.w	#6,d0
	blo.s	loc_3F802
	moveq	#6,d0

loc_3F802:
	move.w	d0,objoff_3E(a1)
	move.w	Enemy_Points(pc,d0.w),d0
	cmpi.w	#$20,(Chain_Bonus_counter).w	; have 16 enemies been destroyed?
	blo.s	loc_3F81C			; if not, branch
	move.w	#1000,d0			; fix bonus to 10000 points
	move.w	#$A,objoff_3E(a1)

loc_3F81C:
	movea.w	a0,a3
	bsr.w	AddPoints2
	_move.b	#ObjID_Explosion,id(a1) ; load obj
	move.b	#0,routine(a1)

	; Decide how to bounce Sonic back.
	tst.w	y_vel(a0)
	bmi.s	loc_3F844
	move.w	y_pos(a0),d0
	cmp.w	y_pos(a1),d0
	bhs.s	loc_3F84C
	; If Sonic is jumping downwards onto an enemy, and lands directly on
	; top of it, then completely negate his Y velocity, giving him a big
	; bounce.
	neg.w	y_vel(a0)
	rts
; ===========================================================================

loc_3F844:
	; If Sonic is jumping upwards into an enemy, then bounce him back
	; down very slightly.
	addi.w	#$100,y_vel(a0)
	rts
; ===========================================================================

loc_3F84C:
	; If Sonic is jumping downwards onto an enemy, but is somehow not
	; above the enemy (such as when jumping into the *side* of an enemy),
	; then only give him a tiny bounce upwards.
	subi.w	#$100,y_vel(a0)
	rts
; ===========================================================================
; byte_3F854:
Enemy_Points:	dc.w 10, 20, 50, 100
; ===========================================================================

loc_3F85C:
	bset	#7,status(a1)

; ---------------------------------------------------------------------------
; Subroutine for checking if Sonic/Tails should be hurt and hurting them if so
; note: Sonic or Tails must be at a0
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_3F862:
Touch_ChkHurt:
	btst	#status_sec_isInvincible,status_secondary(a0)	; is Sonic invincible?
	beq.s	Touch_Hurt		; if not, branch
; loc_3F86A:
Touch_NoHurt:
	moveq	#-1,d0
	rts
; ---------------------------------------------------------------------------
; loc_3F86E:
Touch_Hurt:
	nop
	tst.w	invulnerable_time(a0)
	bne.s	Touch_NoHurt
	movea.l	a1,a2

; End of function TouchResponse
; continue straight to HurtCharacter

; ---------------------------------------------------------------------------
; Hurting Sonic/Tails subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_3F878: HurtSonic:
HurtCharacter:
	move.w	(Ring_count).w,d0
	cmpa.w	#MainCharacter,a0
	beq.s	loc_3F88C
	tst.w	(Two_player_mode).w
	beq.s	Hurt_Sidekick
	move.w	(Ring_count_2P).w,d0

loc_3F88C:
	btst	#status_sec_hasShield,status_secondary(a0)
	bne.s	Hurt_Shield
	tst.w	d0
	beq.w	KillCharacter
	jsr	(AllocateObject).l
	bne.s	Hurt_Shield
	_move.b	#ObjID_LostRings,id(a1) ; load obj
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	a0,parent(a1)

; loc_3F8B8:
Hurt_Shield:
	bclr	#status_sec_hasShield,status_secondary(a0) ; remove shield

; loc_3F8BE:
Hurt_Sidekick:
	move.b	#4,routine(a0)
	jsrto	Sonic_ResetOnFloor_Part2, JmpTo_Sonic_ResetOnFloor_Part2
	bset	#1,status(a0)
	move.w	#-$400,y_vel(a0) ; make Sonic bounce away from the object
	move.w	#-$200,x_vel(a0)
	btst	#6,status(a0)	; underwater?
	beq.s	Hurt_Reverse	; if not, branch
	move.w	#-$200,y_vel(a0) ; bounce slower
	move.w	#-$100,x_vel(a0)

; loc_3F8EE:
Hurt_Reverse:
	move.w	x_pos(a0),d0
	cmp.w	x_pos(a2),d0
	blo.s	Hurt_ChkSpikes	; if Sonic is left of the object, branch
	neg.w	x_vel(a0)	; if Sonic is right of the object, reverse

; loc_3F8FC:
Hurt_ChkSpikes:
	move.w	#0,inertia(a0)
	move.b	#AniIDSonAni_Hurt2,anim(a0)
	move.w	#$78,invulnerable_time(a0)
	move.w	#SndID_Hurt,d0	; load normal damage sound
	cmpi.b	#ObjID_Spikes,id(a2)	; was damage caused by spikes?
	bne.s	Hurt_Sound	; if not, branch
	move.w	#SndID_HurtBySpikes,d0	; load spikes damage sound

; loc_3F91C:
Hurt_Sound:
	jsr	(PlaySound).l
	moveq	#-1,d0
	rts
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to kill Sonic or Tails
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_3F926: KillSonic:
KillCharacter:
	tst.w	(Debug_placement_mode).w
	bne.s	++
	clr.b	status_secondary(a0)
	move.b	#6,routine(a0)
	jsrto	Sonic_ResetOnFloor_Part2, JmpTo_Sonic_ResetOnFloor_Part2
	bset	#1,status(a0)
	move.w	#-$700,y_vel(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,inertia(a0)
	move.b	#AniIDSonAni_Death,anim(a0)
	bset	#high_priority_bit,art_tile(a0)
	move.w	#SndID_Hurt,d0
	cmpi.b	#ObjID_Spikes,id(a2)
	bne.s	+
	move.w	#SndID_HurtBySpikes,d0
+
	jsr	(PlaySound).l
+
	moveq	#-1,d0
	rts
; ===========================================================================
;loc_3F976:
Touch_Special:
	move.b	collision_flags(a1),d1
	andi.b	#$3F,d1
	cmpi.b	#6,d1
	beq.s	loc_3FA00
	cmpi.b	#7,d1
	beq.w	loc_3FA18
	cmpi.b	#$B,d1
	beq.s	BranchTo_loc_3F85C
	cmpi.b	#$A,d1
	beq.s	loc_3FA00
	cmpi.b	#$C,d1
	beq.s	loc_3F9CE
	cmpi.b	#$14,d1
	beq.s	loc_3FA00
	cmpi.b	#$15,d1
	beq.s	loc_3FA00
	cmpi.b	#$16,d1
	beq.s	loc_3FA00
	cmpi.b	#$17,d1
	beq.s	loc_3FA00
	cmpi.b	#$18,d1
	beq.s	loc_3FA00
	cmpi.b	#$1A,d1
	beq.s	loc_3FA22
	cmpi.b	#$21,d1
	beq.s	loc_3FA12
	rts
; ===========================================================================

BranchTo_loc_3F85C ; BranchTo
	bra.w	loc_3F85C
; ===========================================================================

loc_3F9CE:
	sub.w	d0,d5
	cmpi.w	#8,d5
	bhs.s	BranchTo_Touch_Enemy
	move.w	x_pos(a1),d0
	subq.w	#4,d0
	btst	#0,status(a1)
	beq.s	loc_3F9E8
	subi.w	#$10,d0

loc_3F9E8:
	sub.w	d2,d0
	bcc.s	loc_3F9F4
	addi.w	#$18,d0
	bcs.s	BranchTo_Touch_ChkHurt
	bra.s	BranchTo_Touch_Enemy
; ===========================================================================

loc_3F9F4:
	cmp.w	d4,d0
	bhi.s	BranchTo_Touch_Enemy

BranchTo_Touch_ChkHurt ; BranchTo
	bra.w	Touch_ChkHurt
; ===========================================================================

BranchTo_Touch_Enemy ; BranchTo
	bra.w	Touch_Enemy
; ===========================================================================

loc_3FA00:
	move.w	a0,d1
	subi.w	#MainCharacter,d1
	beq.s	+
	addq.b	#1,collision_property(a1)
+
	addq.b	#1,collision_property(a1)
	rts
; ===========================================================================

loc_3FA12:
	addq.b	#1,collision_property(a1)
	rts
; ===========================================================================

loc_3FA18:
	move.b	#2,collision_property(a1)
	bra.w	Touch_Enemy
; ===========================================================================

loc_3FA22:
	move.b	#-1,collision_property(a1)
	bra.w	Touch_Enemy
; ===========================================================================
; loc_3FA2C:
BossSpecificCollision:
	cmpi.b	#$F,d0
	bne.s	+	; rts
	moveq	#0,d0
	move.b	(Current_Boss_ID).w,d0
	beq.s	+	; rts
	subq.w	#1,d0
	add.w	d0,d0
	move.w	BossCollision_Index(pc,d0.w),d0
	jmp	BossCollision_Index(pc,d0.w)
; ===========================================================================
+	rts
; ===========================================================================
; off_3FA48:
BossCollision_Index:offsetTable	; jump depending on boss ID
	offsetTableEntry.w BossCollision_EHZ_CPZ
	offsetTableEntry.w BossCollision_EHZ_CPZ
	offsetTableEntry.w BossCollision_HTZ
	offsetTableEntry.w BossCollision_ARZ
	offsetTableEntry.w BossCollision_MCZ
	offsetTableEntry.w BossCollision_CNZ
	offsetTableEntry.w BossCollision_MTZ
	offsetTableEntry.w BossCollision_OOZ
	offsetTableEntry.w return_3FA5E
; ===========================================================================
;loc_3FA5A:
BossCollision_EHZ_CPZ:
	move.b	collision_flags(a1),d0

return_3FA5E:
	rts
; ===========================================================================
;loc_3FA60:
BossCollision_HTZ:
	tst.b	(Boss_CollisionRoutine).w
	bne.s	+
	rts
; ---------------------------------------------------------------------------
+
	move.w	d7,-(sp)
	moveq	#0,d1
	move.b	objoff_15(a1),d1
	subq.b	#2,d1
	cmpi.b	#7,d1
	bgt.s	loc_3FAA8
	move.w	d1,d7
	add.w	d7,d7
	move.w	x_pos(a1),d0
	btst	#0,render_flags(a1)
	beq.s	loc_3FA8E
	add.w	word_3FAB0(pc,d7.w),d0
	bra.s	loc_3FA92
; ===========================================================================

loc_3FA8E:
	sub.w	word_3FAB0(pc,d7.w),d0

loc_3FA92:
	move.b	byte_3FAC0(pc,d1.w),d1
	ori.l	#$40000,d1
	move.w	y_pos(a1),d7
	subi.w	#$1C,d7
	bsr.w	Boss_DoCollision

loc_3FAA8:
	move.w	(sp)+,d7
	move.b	collision_flags(a1),d0
	rts
; ===========================================================================
word_3FAB0:
	dc.w   $1C
	dc.w   $20	; 1
	dc.w   $28	; 2
	dc.w   $34	; 3
	dc.w   $3C	; 4
	dc.w   $44	; 5
	dc.w   $60	; 6
	dc.w   $70	; 7
byte_3FAC0:
	dc.b   4
	dc.b   4	; 1
	dc.b   8	; 2
	dc.b  $C	; 3
	dc.b $14	; 4
	dc.b $1C	; 5
	dc.b $24	; 6
	dc.b   8	; 7
	even
; ===========================================================================
;loc_3FAC8:
BossCollision_ARZ:
	move.w	d7,-(sp)
	move.w	x_pos(a1),d0
	move.w	y_pos(a1),d7
	tst.b	(Boss_CollisionRoutine).w
	beq.s	++
	addi_.w	#4,d7
	subi.w	#$50,d0
	btst	#0,render_flags(a1)
	beq.s	+
	addi.w	#$A0,d0
+
	move.l	#$140010,d1
	bsr.w	Boss_DoCollision
+
	move.w	(sp)+,d7
	move.b	collision_flags(a1),d0
	rts
; ===========================================================================
;loc_3FAFE:
BossCollision_MCZ:
	sf	boss_hurt_sonic(a1)
	cmpi.b	#1,(Boss_CollisionRoutine).w
	blt.s	BossCollision_MCZ2
; Boss_CollisionRoutine = 1, i.e. diggers pointing to the side
    if fixBugs
	; The below call to 'Boss_DoCollision' clobbers 'a1', so back it up
	; here. This fixes Eggman not laughing when he hurts Sonic.
	movem.w	d7/a1,-(sp)
    else
	move.w	d7,-(sp)
    endif
	move.w	x_pos(a1),d0
	move.w	y_pos(a1),d7
	addi_.w	#4,d7
	subi.w	#$30,d0
	btst	#0,render_flags(a1)	; left or right?
	beq.s	+
	addi.w	#$60,d0			; x+$30, otherwise x-$30
+
	move.l	#$40004,d1		; heigth 4, width 4
	bsr.w	Boss_DoCollision
    if fixBugs
	; See the above bugfix.
	movem.w	(sp)+,d7/a1
    else
	move.w	(sp)+,d7
    endif
	move.b	collision_flags(a1),d0
	cmpi.w	#$78,invulnerable_time(a0)
	bne.s	+	; rts
	st.b	boss_hurt_sonic(a1)	; Sonic has just been hurt flag
+
	rts
; ===========================================================================
; Boss_CollisionRoutine = 0, i.e. diggers pointing towards top
;loc_3FB46:
BossCollision_MCZ2:
	move.w	d7,-(sp)
	movea.w	#$14,a5
	movea.w	#0,a4

-	move.w	x_pos(a1),d0
	move.w	y_pos(a1),d7
	subi.w	#$20,d7
	add.w	a5,d0			; first check x+$14, second x-$14
	move.l	#$100004,d1		; heigth $10, width 4
	bsr.w	Boss_DoCollision
	movea.w	#-$14,a5
	adda_.w	#1,a4
	cmpa.w	#1,a4
	beq.s	-			; jump back once for second check
	move.w	(sp)+,d7
	move.b	collision_flags(a1),d0
	cmpi.w	#$78,invulnerable_time(a0)
	bne.s	+	; rts
	st.b	boss_hurt_sonic(a1)	; Sonic has just been hurt flag
+
	rts
; ===========================================================================
;loc_3FB8A:
BossCollision_CNZ:
	tst.b	(Boss_CollisionRoutine).w
	beq.s	++
	move.w	d7,-(sp)
	move.w	x_pos(a1),d0
	move.w	y_pos(a1),d7
	addi.w	#$28,d7
	move.l	#$80010,d1
	cmpi.b	#1,(Boss_CollisionRoutine).w
	beq.s	+
	move.w	#$20,d1
	subi_.w	#8,d7
	addi_.w	#4,d0
+
	bsr.w	Boss_DoCollision
	move.w	(sp)+,d7
+
	move.b	collision_flags(a1),d0
	rts
; ===========================================================================
;loc_3FBC4:
BossCollision_MTZ:
	move.b	collision_flags(a1),d0
	rts
; ===========================================================================
;loc_3FBCA:
BossCollision_OOZ:
	cmpi.b	#1,(Boss_CollisionRoutine).w
	blt.s	loc_3FC46
	beq.s	loc_3FC1C
	move.w	d7,-(sp)
	move.w	x_pos(a1),d0
	move.w	y_pos(a1),d7
	moveq	#0,d1
	move.b	mainspr_mapframe(a1),d1
	subq.b	#2,d1
	add.w	d1,d1
	btst	#0,render_flags(a1)
	beq.s	loc_3FBF6
	add.w	word_3FC10(pc,d1.w),d0
	bra.s	loc_3FBFA
; ===========================================================================

loc_3FBF6:
	sub.w	word_3FC10(pc,d1.w),d0

loc_3FBFA:
	sub.w	word_3FC10+2(pc,d1.w),d7
	move.l	#$60008,d1
	bsr.w	Boss_DoCollision
	move.w	(sp)+,d7
	move.w	#0,d0
	rts
; ===========================================================================
word_3FC10:
	dc.w   $14,    0
	dc.w   $10,  $10
	dc.w   $10, -$10
; ===========================================================================

loc_3FC1C:
	move.w	d7,-(sp)
	move.w	x_pos(a1),d0
	move.w	y_pos(a1),d7
	moveq	#$10,d1
	btst	#0,render_flags(a1)
	beq.s	+
	neg.w	d1
+
	sub.w	d1,d0
	move.l	#$8000C,d1
	bsr.w	loc_3FC7A
	move.w	(sp)+,d7
	move.b	#0,d0
	rts
; ===========================================================================

loc_3FC46:
	move.b	collision_flags(a1),d0
	rts
; ===========================================================================
;loc_3FC4C:
	; d7 = y_boss, d3 = y_Sonic, d1 (high word) = height
	; d0 = x_boss, d2 = x_Sonic, d1 (low word)  = width
Boss_DoCollision:
	sub.w	d1,d0
	sub.w	d2,d0
	bcc.s	loc_3FC5A
	add.w	d1,d1
	add.w	d1,d0
	bcs.s	loc_3FC5E

return_3FC58:
	rts
; ===========================================================================

loc_3FC5A:
	cmp.w	d4,d0
	bhi.s	return_3FC58

loc_3FC5E:
	swap	d1
	sub.w	d1,d7
	sub.w	d3,d7
	bcc.s	loc_3FC70
	add.w	d1,d1
	add.w	d1,d7
	bcs.w	Touch_ChkHurt
	bra.s	return_3FC58
; ===========================================================================

loc_3FC70:
	cmp.w	d5,d7
	bhi.w	return_3FC58
	bra.w	Touch_ChkHurt
; ===========================================================================

loc_3FC7A:
	sub.w	d1,d0
	sub.w	d2,d0
	bcc.s	loc_3FC88
	add.w	d1,d1
	add.w	d1,d0
	bcs.s	loc_3FC8C

return_3FC86:
	rts
; ===========================================================================

loc_3FC88:
	cmp.w	d4,d0
	bhi.s	return_3FC86

loc_3FC8C:
	swap	d1
	sub.w	d1,d7
	sub.w	d3,d7
	bcc.s	loc_3FC9E
	add.w	d1,d1
	add.w	d1,d7
	bcs.w	loc_3FCA4
	bra.s	return_3FC86
; ===========================================================================

loc_3FC9E:
	cmp.w	d5,d7
	bhi.w	return_3FC86

loc_3FCA4:
	neg.w	x_vel(a0)
	neg.w	y_vel(a0)
	rts
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo_Sonic_ResetOnFloor_Part2 ; JmpTo
	jmp	(Sonic_ResetOnFloor_Part2).l
JmpTo_Check_CNZ_bumpers
	jmp	(Check_CNZ_bumpers).l
JmpTo_Touch_Rings ; JmpTo
	jmp	(Touch_Rings).l

	align 4
    endif
