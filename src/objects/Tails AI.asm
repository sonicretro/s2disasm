; ---------------------------------------------------------------------------
; Tails' AI code for the Sonic and Tails mode 1-player game
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1BAD4:
TailsCPU_Control: ; a0=Tails
	move.b	(Ctrl_2_Held).w,d0	; did the real player 2 hit something?
	andi.b	#button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,d0
	beq.s	+			; if not, branch
	move.w	#600,(Tails_control_counter).w ; give player 2 control for 10 seconds (minimum)
+
	lea	(MainCharacter).w,a1 ; a1=character ; a1=Sonic
	move.w	(Tails_CPU_routine).w,d0
	move.w	TailsCPU_States(pc,d0.w),d0
	jmp	TailsCPU_States(pc,d0.w)
; ===========================================================================
; off_1BAF4:
TailsCPU_States: offsetTable
	offsetTableEntry.w TailsCPU_Init	; 0
	offsetTableEntry.w TailsCPU_Spawning	; 2
	offsetTableEntry.w TailsCPU_Flying	; 4
	offsetTableEntry.w TailsCPU_Normal	; 6
	offsetTableEntry.w TailsCPU_Panic	; 8

; ===========================================================================
; initial AI State
; ---------------------------------------------------------------------------
; loc_1BAFE:
TailsCPU_Init:
	move.w	#6,(Tails_CPU_routine).w	; => TailsCPU_Normal
	move.b	#0,obj_control(a0)
	move.b	#AniIDSonAni_Walk,anim(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)
	move.w	#0,inertia(a0)
	move.b	#0,status(a0)
	move.w	#0,(Tails_respawn_counter).w
	rts

; ===========================================================================
; AI State where Tails is waiting to respawn
; ---------------------------------------------------------------------------
; loc_1BB30:
TailsCPU_Spawning:
	move.b	(Ctrl_2_Held_Logical).w,d0
	andi.b	#button_B_mask|button_C_mask|button_A_mask|button_start_mask,d0
	bne.s	TailsCPU_Respawn
	move.w	(Level_frame_counter).w,d0
	andi.w	#$3F,d0
	bne.s	return_1BB88
	tst.b	obj_control(a1)
	bne.s	return_1BB88
	move.b	status(a1),d0
	andi.b	#1<<status.player.in_air|1<<status.player.rolljumping|1<<status.player.underwater|1<<status.player.prevent_tails_respawn,d0
	bne.s	return_1BB88
; loc_1BB54:
TailsCPU_Respawn:
	move.w	#4,(Tails_CPU_routine).w	; => TailsCPU_Flying
	move.w	x_pos(a1),d0
	move.w	d0,x_pos(a0)
	move.w	d0,(Tails_CPU_target_x).w
	move.w	y_pos(a1),d0
	move.w	d0,(Tails_CPU_target_y).w
	subi.w	#$C0,d0
	move.w	d0,y_pos(a0)
	ori.w	#high_priority,art_tile(a0)
	move.b	#0,spindash_flag(a0)
	move.w	#0,spindash_counter(a0)

return_1BB88:
	rts

; ===========================================================================
; AI State where Tails pretends to be a helicopter
; ---------------------------------------------------------------------------
; loc_1BB8A:
TailsCPU_Flying:
	_btst	#render_flags.on_screen,render_flags(a0)
	_bne.s	TailsCPU_FlyingOnscreen
	addq.w	#1,(Tails_respawn_counter).w
	cmpi.w	#$12C,(Tails_respawn_counter).w
	blo.s	TailsCPU_Flying_Part2
	move.w	#0,(Tails_respawn_counter).w
	move.w	#2,(Tails_CPU_routine).w	; => TailsCPU_Spawning
	move.b	#$81,obj_control(a0)
	move.b	#1<<status.player.in_air,status(a0)
	move.w	#0,x_pos(a0)
	move.w	#0,y_pos(a0)
	move.b	#AniIDTailsAni_Fly,anim(a0)
	rts
; ---------------------------------------------------------------------------
; loc_1BBC8:
TailsCPU_FlyingOnscreen:
	move.w	#0,(Tails_respawn_counter).w
; loc_1BBCE:
TailsCPU_Flying_Part2:
	lea	(Sonic_Pos_Record_Buf).w,a2
	move.w	#$10,d2
	lsl.b	#2,d2
	addq.b	#4,d2
	move.w	(Sonic_Pos_Record_Index).w,d3
	sub.b	d2,d3
	move.w	(a2,d3.w),(Tails_CPU_target_x).w
	move.w	2(a2,d3.w),(Tails_CPU_target_y).w
	tst.b	(Water_flag).w
	beq.s	+
	move.w	(Water_Level_1).w,d0
	subi.w	#$10,d0
	cmp.w	(Tails_CPU_target_y).w,d0
	bge.s	+
	move.w	d0,(Tails_CPU_target_y).w
+
	move.w	x_pos(a0),d0
	sub.w	(Tails_CPU_target_x).w,d0
	beq.s	loc_1BC54
	mvabs.w	d0,d2
	lsr.w	#4,d2
	cmpi.w	#$C,d2
	blo.s	+
	moveq	#$C,d2
+
	mvabs.b	x_vel(a1),d1
	add.b	d1,d2
	addq.w	#1,d2
	tst.w	d0
	bmi.s	loc_1BC40
	bset	#status.player.x_flip,status(a0)
	cmp.w	d0,d2
	blo.s	+
	move.w	d0,d2
	moveq	#0,d0
+
	neg.w	d2
	bra.s	loc_1BC50
; ---------------------------------------------------------------------------

loc_1BC40:
	bclr	#status.player.x_flip,status(a0)
	neg.w	d0
	cmp.w	d0,d2
	blo.s	loc_1BC50
	move.b	d0,d2
	moveq	#0,d0

loc_1BC50:
	add.w	d2,x_pos(a0)

loc_1BC54:
	moveq	#1,d2
	move.w	y_pos(a0),d1
	sub.w	(Tails_CPU_target_y).w,d1
	beq.s	loc_1BC68
	bmi.s	loc_1BC64
	neg.w	d2

loc_1BC64:
	add.w	d2,y_pos(a0)

loc_1BC68:
	lea	(Sonic_Stat_Record_Buf).w,a2
	move.b	2(a2,d3.w),d2
	andi.b	#$D2,d2
	bne.s	return_1BCDE
	or.w	d0,d1
	bne.s	return_1BCDE
	move.w	#6,(Tails_CPU_routine).w	; => TailsCPU_Normal
	move.b	#0,obj_control(a0)
	move.b	#AniIDSonAni_Walk,anim(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)
	move.w	#0,inertia(a0)
	move.b	#1<<status.player.in_air,status(a0)
	move.w	#0,move_lock(a0)
	andi.w	#drawing_mask,art_tile(a0)
	tst.b	art_tile(a1)
	bpl.s	+
	ori.w	#high_priority,art_tile(a0)
+
	move.b	top_solid_bit(a1),top_solid_bit(a0)
	move.b	lrb_solid_bit(a1),lrb_solid_bit(a0)
	cmpi.b	#AniIDSonAni_Spindash,anim(a1)
	beq.s	return_1BCDE
	move.b	spindash_flag(a0),d0
	beq.s	return_1BCDE
	move.b	d0,spindash_flag(a1)
	bsr.w	loc_212C4

return_1BCDE:
	rts

; ===========================================================================
; AI State where Tails follows the player normally
; ---------------------------------------------------------------------------
; loc_1BCE0:
TailsCPU_Normal:
	cmpi.b	#6,(MainCharacter+routine).w	; is Sonic dead?
	blo.s	TailsCPU_Normal_SonicOK		; if not, branch
	; Sonic's dead; fly down to his corpse
	move.w	#4,(Tails_CPU_routine).w	; => TailsCPU_Flying
	move.b	#0,spindash_flag(a0)
	move.w	#0,spindash_counter(a0)
	move.b	#$81,obj_control(a0)
	move.b	#1<<status.player.in_air,status(a0)
	move.b	#AniIDTailsAni_Fly,anim(a0)
	rts
; ---------------------------------------------------------------------------
; loc_1BD0E:
TailsCPU_Normal_SonicOK:
	bsr.w	TailsCPU_CheckDespawn
	tst.w	(Tails_control_counter).w	; if CPU has control
	bne.w	TailsCPU_Normal_HumanControl		; (if not, branch)
	tst.b	obj_control(a0)			; and Tails isn't fully object controlled (&$80)
	bmi.w	TailsCPU_Normal_HumanControl		; (if not, branch)
	tst.w	move_lock(a0)			; and Tails' movement is locked (usually because he just fell down a slope)
	beq.s	+					; (if not, branch)
	tst.w	inertia(a0)			; and Tails is stopped, then...
	bne.s	+					; (if not, branch)
	move.w	#8,(Tails_CPU_routine).w	; => TailsCPU_Panic
+
	lea	(Sonic_Pos_Record_Buf).w,a1
	move.w	#$10,d1
	lsl.b	#2,d1
	addq.b	#4,d1
	move.w	(Sonic_Pos_Record_Index).w,d0
	sub.b	d1,d0
	move.w	(a1,d0.w),d2	; d2 = earlier x position of Sonic
	move.w	2(a1,d0.w),d3	; d3 = earlier y position of Sonic
	lea	(Sonic_Stat_Record_Buf).w,a1
	move.w	(a1,d0.w),d1	; d1 = earlier input of Sonic
	move.b	2(a1,d0.w),d4	; d4 = earlier status of Sonic
	move.w	d1,d0
	btst	#status.player.pushing,status(a0)	; is Tails pushing against something?
	beq.s	+					; if not, branch
	btst	#status.player.pushing,d4		; was Sonic pushing against something?
	beq.w	TailsCPU_Normal_FilterAction_Part2	; if not, branch elsewhere

; either Tails isn't pushing, or Tails and Sonic are both pushing
+	sub.w	x_pos(a0),d2
	beq.s	TailsCPU_Normal_Stand ; branch if Tails is already lined up horizontally with Sonic
	bpl.s	TailsCPU_Normal_FollowRight
	neg.w	d2

; Tails wants to go left because that's where Sonic is
; loc_1BD76: TailsCPU_Normal_FollowLeft:
	cmpi.w	#$10,d2
	blo.s	+
	andi.w	#~(((button_left_mask|button_right_mask)<<8)|(button_left_mask|button_right_mask)),d1	; AND out Sonic's left/right input...
	ori.w	#(button_left_mask<<8)|button_left_mask,d1	; ...and give Tails his own
+
	tst.w	inertia(a0)
	beq.s	TailsCPU_Normal_FilterAction
	btst	#status.player.x_flip,status(a0)
	beq.s	TailsCPU_Normal_FilterAction
	subq.w	#1,x_pos(a0)
	bra.s	TailsCPU_Normal_FilterAction
; ===========================================================================
; Tails wants to go right because that's where Sonic is
; loc_1BD98:
TailsCPU_Normal_FollowRight:
	cmpi.w	#$10,d2
	blo.s	+
	andi.w	#~(((button_left_mask|button_right_mask)<<8)|(button_left_mask|button_right_mask)),d1	; AND out Sonic's left/right input
	ori.w	#(button_right_mask<<8)|button_right_mask,d1	; ...and give Tails his own
+
	tst.w	inertia(a0)
	beq.s	TailsCPU_Normal_FilterAction
	btst	#status.player.x_flip,status(a0)
	bne.s	TailsCPU_Normal_FilterAction
	addq.w	#1,x_pos(a0)
	bra.s	TailsCPU_Normal_FilterAction
; ===========================================================================
; Tails is happy where he is
; loc_1BDBA:
TailsCPU_Normal_Stand:
	bclr	#status.player.x_flip,status(a0)
	move.b	d4,d0
	andi.b	#1,d0
	beq.s	TailsCPU_Normal_FilterAction
	bset	#status.player.x_flip,status(a0)

; Filter the action we chose depending on a few things
; loc_1BDCE:
TailsCPU_Normal_FilterAction:
	tst.b	(Tails_CPU_jumping).w
	beq.s	+
	ori.w	#((button_B_mask|button_C_mask|button_A_mask)<<8),d1
	btst	#status.player.in_air,status(a0)
	bne.s	TailsCPU_Normal_SendAction
	move.b	#0,(Tails_CPU_jumping).w
+
	move.w	(Level_frame_counter).w,d0
	andi.w	#$FF,d0
	beq.s	+
	cmpi.w	#$40,d2
	bhs.s	TailsCPU_Normal_SendAction
+
	sub.w	y_pos(a0),d3
	beq.s	TailsCPU_Normal_SendAction
	bpl.s	TailsCPU_Normal_SendAction
	neg.w	d3
	cmpi.w	#$20,d3
	blo.s	TailsCPU_Normal_SendAction
; loc_1BE06:
TailsCPU_Normal_FilterAction_Part2:
	move.b	(Level_frame_counter+1).w,d0
	andi.b	#$3F,d0
	bne.s	TailsCPU_Normal_SendAction
	cmpi.b	#AniIDSonAni_Duck,anim(a0)
	beq.s	TailsCPU_Normal_SendAction
	ori.w	#((button_B_mask|button_C_mask|button_A_mask)<<8)|(button_B_mask|button_C_mask|button_A_mask),d1
	move.b	#1,(Tails_CPU_jumping).w

; Send the action we chose by storing it into player 2's input
; loc_1BE22:
TailsCPU_Normal_SendAction:
	move.w	d1,(Ctrl_2_Logical).w
	rts

; ===========================================================================
; Follow orders from controller 2
; and decrease the counter to when the CPU will regain control
; loc_1BE28:
TailsCPU_Normal_HumanControl:
	tst.w	(Tails_control_counter).w
	beq.s	+	; don't decrease if it's already 0
	subq.w	#1,(Tails_control_counter).w
+
	rts

; ===========================================================================
; loc_1BE34:
TailsCPU_Despawn:
	move.w	#0,(Tails_control_counter).w
	move.w	#0,(Tails_respawn_counter).w
	move.w	#2,(Tails_CPU_routine).w	; => TailsCPU_Spawning
	move.b	#$81,obj_control(a0)
	move.b	#1<<status.player.in_air,status(a0)
	move.w	#$4000,x_pos(a0)
	move.w	#0,y_pos(a0)
	move.b	#AniIDTailsAni_Fly,anim(a0)
	rts
; ===========================================================================
; sub_1BE66:
TailsCPU_CheckDespawn:
	_btst	#render_flags.on_screen,render_flags(a0)
	_bne.s	TailsCPU_ResetRespawnTimer
	btst	#status.player.on_object,status(a0)
	beq.s	TailsCPU_TickRespawnTimer

	moveq	#0,d0
	move.b	interact(a0),d0
    if object_size=$40
	lsl.w	#object_size_bits,d0
    else
	mulu.w	#object_size,d0
    endif
	addi.l	#Object_RAM,d0
	movea.l	d0,a3	; a3=object
	move.b	(Tails_interact_ID).w,d0
	cmp.b	id(a3),d0
	bne.s	BranchTo_TailsCPU_Despawn

; loc_1BE8C:
TailsCPU_TickRespawnTimer:
	addq.w	#1,(Tails_respawn_counter).w
	cmpi.w	#$12C,(Tails_respawn_counter).w
	blo.s	TailsCPU_UpdateObjInteract

BranchTo_TailsCPU_Despawn ; BranchTo
	bra.w	TailsCPU_Despawn
; ===========================================================================
; loc_1BE9C:
TailsCPU_ResetRespawnTimer:
	move.w	#0,(Tails_respawn_counter).w
; loc_1BEA2:
TailsCPU_UpdateObjInteract:
	moveq	#0,d0
	move.b	interact(a0),d0
    if object_size=$40
	lsl.w	#object_size_bits,d0
    else
	mulu.w	#object_size,d0
    endif
	addi.l	#Object_RAM,d0
	movea.l	d0,a3	; a3=object
	move.b	id(a3),(Tails_interact_ID).w
	rts

; ===========================================================================
; AI State where Tails stops, drops, and spindashes in Sonic's direction
; ---------------------------------------------------------------------------
; loc_1BEB8:
TailsCPU_Panic:
	bsr.w	TailsCPU_CheckDespawn
	tst.w	(Tails_control_counter).w
	bne.w	return_1BF36
	tst.w	move_lock(a0)
	bne.s	return_1BF36
	tst.b	spindash_flag(a0)
	bne.s	TailsCPU_Panic_ChargingDash

	tst.w	inertia(a0)
	bne.s	return_1BF36
	bclr	#status.player.x_flip,status(a0)
	move.w	x_pos(a0),d0
	sub.w	x_pos(a1),d0
	bcs.s	+
	bset	#status.player.x_flip,status(a0)
+
	move.w	#(button_down_mask<<8)|button_down_mask,(Ctrl_2_Logical).w
	move.b	(Level_frame_counter+1).w,d0
	andi.b	#$7F,d0
	beq.s	TailsCPU_Panic_ReleaseDash

	cmpi.b	#AniIDSonAni_Duck,anim(a0)
	bne.s	return_1BF36
	move.w	#((button_down_mask|button_B_mask|button_C_mask|button_A_mask)<<8)|(button_down_mask|button_B_mask|button_C_mask|button_A_mask),(Ctrl_2_Logical).w
	rts
; ---------------------------------------------------------------------------
; loc_1BF0C:
TailsCPU_Panic_ChargingDash:
	move.w	#(button_down_mask<<8)|button_down_mask,(Ctrl_2_Logical).w
	move.b	(Level_frame_counter+1).w,d0
	andi.b	#$7F,d0
	bne.s	TailsCPU_Panic_RevDash

; loc_1BF1C:
TailsCPU_Panic_ReleaseDash:
	move.w	#0,(Ctrl_2_Logical).w
	move.w	#6,(Tails_CPU_routine).w	; => TailsCPU_Normal
	rts
; ---------------------------------------------------------------------------
; loc_1BF2A:
TailsCPU_Panic_RevDash:
	andi.b	#$1F,d0
	bne.s	return_1BF36
	ori.w	#((button_B_mask|button_C_mask|button_A_mask)<<8)|(button_B_mask|button_C_mask|button_A_mask),(Ctrl_2_Logical).w

return_1BF36:
	rts
; End of function TailsCPU_Control
