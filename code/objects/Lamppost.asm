; ===========================================================================
; ----------------------------------------------------------------------------
; Object 79 - Star pole / starpost / checkpoint
; ----------------------------------------------------------------------------
; Sprite_1F0B4:
Obj79:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj79_Index(pc,d0.w),d1
	jmp	Obj79_Index(pc,d1.w)
; ===========================================================================
; off_1F0C2: Obj79_States:
Obj79_Index:	offsetTable
		offsetTableEntry.w Obj79_Init		; 0
		offsetTableEntry.w Obj79_Main		; 2
		offsetTableEntry.w Obj79_Animate	; 4
		offsetTableEntry.w Obj79_Dongle		; 6
		offsetTableEntry.w Obj79_Star		; 8
; ===========================================================================
; loc_1F0CC:
Obj79_Init:
	addq.b	#2,routine(a0) ; => Obj79_Main
	move.l	#Obj79_MapUnc_1F424,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Checkpoint,0,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo3_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#8,width_pixels(a0)
	move.b	#5,priority(a0)
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
    if fixBugs
	; If you spawn a checkpoint in Debug Mode and activate it, then
	; every checkpoint that is spawned with Debug Mode afterwards will be
	; activated too. The cause of the bug is that the spawned checkpoint
	; does not have a respawn entry, but this object fails to check for
	; that before accessing the respawn table.
	beq.s	Obj79_Main
    endif
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
	btst	#0,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
	bne.s	loc_1F120
	move.b	(Last_star_pole_hit).w,d1
	andi.b	#$7F,d1
	move.b	subtype(a0),d2
	andi.b	#$7F,d2
	cmp.b	d2,d1
	blo.s	Obj79_Main

loc_1F120:
	bset	#0,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
	move.b	#2,anim(a0)

; loc_1F12C:
Obj79_Main:
	tst.w	(Debug_placement_mode).w
	bne.w	Obj79_Animate
	lea	(MainCharacter).w,a3 ; a3=character
	move.b	(Last_star_pole_hit).w,d1
	bsr.s	Obj79_CheckActivation
	tst.w	(Two_player_mode).w
	beq.w	Obj79_Animate
	lea	(Sidekick).w,a3 ; a3=character
	move.b	(Last_star_pole_hit_2P).w,d1
	bsr.s	Obj79_CheckActivation
	bra.w	Obj79_Animate
; ---------------------------------------------------------------------------
; loc_1F154:
Obj79_CheckActivation:
	andi.b	#$7F,d1
	move.b	subtype(a0),d2
	andi.b	#$7F,d2
	cmp.b	d2,d1
	bhs.w	loc_1F222
	move.w	x_pos(a3),d0
	sub.w	x_pos(a0),d0
	addi_.w	#8,d0
	cmpi.w	#$10,d0
	bhs.w	return_1F220
	move.w	y_pos(a3),d0
	sub.w	y_pos(a0),d0
	addi.w	#$40,d0
	cmpi.w	#$68,d0
	bhs.w	return_1F220
	move.w	#SndID_Checkpoint,d0 ; checkpoint ding-dong sound
	jsr	(PlaySound).l
	jsr	(AllocateObject).l
	bne.s	loc_1F206
	_move.b	#ObjID_Starpost,id(a1) ; load obj79
	move.b	#6,routine(a1) ; => Obj79_Dongle
	move.w	x_pos(a0),objoff_30(a1)
	move.w	y_pos(a0),objoff_32(a1)
	subi.w	#$14,objoff_32(a1)
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#8,width_pixels(a1)
	move.b	#4,priority(a1)
	move.b	#2,mapping_frame(a1)
	move.w	#$20,objoff_36(a1)
	move.w	a0,parent(a1)
	tst.w	(Two_player_mode).w
	bne.s	loc_1F206
	cmpi.b	#7,(Emerald_count).w
	beq.s	loc_1F206
	cmpi.w	#50,(Ring_count).w
	blo.s	loc_1F206
	bsr.w	Obj79_MakeSpecialStars

loc_1F206:
	move.b	#1,anim(a0)
	bsr.w	Obj79_SaveData
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
    if fixBugs
	; If you spawn a checkpoint in Debug Mode and activate it, then
	; every checkpoint that is spawned with Debug Mode afterwards will be
	; activated too. The cause of the bug is that the spawned checkpoint
	; does not have a respawn entry, but this object fails to check for
	; that before accessing the respawn table.
	beq.s	return_1F220
    endif
	bset	#0,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)

return_1F220:
	rts
; ===========================================================================

loc_1F222:
	tst.b	anim(a0)
	bne.s	return_1F22E
	move.b	#2,anim(a0)

return_1F22E:
	rts
; ===========================================================================
; loc_1F230:
Obj79_Animate:
	lea	(Ani_obj79).l,a1
	jsrto	AnimateSprite, JmpTo2_AnimateSprite
	jmp	(MarkObjGone).l
; ===========================================================================
; loc_1F240:
Obj79_Dongle:
	subq.w	#1,objoff_36(a0)
	bpl.s	Obj79_MoveDonglyThing
	movea.w	parent(a0),a1 ; a1=object
	cmpi.b	#ObjID_Starpost,id(a1)
	bne.s	+
	move.b	#2,anim(a1)
	move.b	#0,mapping_frame(a1)
+
	jmp	(DeleteObject).l
; ===========================================================================
; loc_1F262:
Obj79_MoveDonglyThing:
	move.b	angle(a0),d0
	subi.b	#$10,angle(a0)
	subi.b	#$40,d0
	jsr	(CalcSine).l
	muls.w	#$C00,d1
	swap	d1
	add.w	objoff_30(a0),d1
	move.w	d1,x_pos(a0)
	muls.w	#$C00,d0
	swap	d0
	add.w	objoff_32(a0),d0
	move.w	d0,y_pos(a0)
	jmp	(MarkObjGone).l
; ===========================================================================
; hit a starpost / save checkpoint
; loc_1F298:
Obj79_SaveData:
	cmpa.w	#MainCharacter,a3	; is it player 1?
	bne.w	Obj79_SaveDataPlayer2	; if not, branch
	move.b	subtype(a0),(Last_star_pole_hit).w
	move.b	(Last_star_pole_hit).w,(Saved_Last_star_pole_hit).w
	move.w	x_pos(a0),(Saved_x_pos).w
	move.w	y_pos(a0),(Saved_y_pos).w
	move.w	(MainCharacter+art_tile).w,(Saved_art_tile).w
	move.w	(MainCharacter+top_solid_bit).w,(Saved_Solid_bits).w
	move.w	(Ring_count).w,(Saved_Ring_count).w
	move.b	(Extra_life_flags).w,(Saved_Extra_life_flags).w
	move.l	(Timer).w,(Saved_Timer).w
	move.b	(Dynamic_Resize_Routine).w,(Saved_Dynamic_Resize_Routine).w
	move.w	(Camera_Max_Y_pos).w,(Saved_Camera_Max_Y_pos).w
	move.w	(Camera_X_pos).w,(Saved_Camera_X_pos).w
	move.w	(Camera_Y_pos).w,(Saved_Camera_Y_pos).w
	move.w	(Camera_BG_X_pos).w,(Saved_Camera_BG_X_pos).w
	move.w	(Camera_BG_Y_pos).w,(Saved_Camera_BG_Y_pos).w
	move.w	(Camera_BG2_X_pos).w,(Saved_Camera_BG2_X_pos).w
	move.w	(Camera_BG2_Y_pos).w,(Saved_Camera_BG2_Y_pos).w
	move.w	(Camera_BG3_X_pos).w,(Saved_Camera_BG3_X_pos).w
	move.w	(Camera_BG3_Y_pos).w,(Saved_Camera_BG3_Y_pos).w
	move.w	(Water_Level_2).w,(Saved_Water_Level).w
	move.b	(Water_routine).w,(Saved_Water_routine).w
	move.b	(Water_fullscreen_flag).w,(Saved_Water_move).w
	rts
; ===========================================================================
; second player hit a checkpoint in 2-player mode
; loc_1F326:
Obj79_SaveDataPlayer2:
	move.b	subtype(a0),(Last_star_pole_hit_2P).w
	move.b	(Last_star_pole_hit_2P).w,(Saved_Last_star_pole_hit_2P).w
	move.w	x_pos(a0),(Saved_x_pos_2P).w
	move.w	y_pos(a0),(Saved_y_pos_2P).w
	move.w	(Sidekick+art_tile).w,(Saved_art_tile_2P).w
	move.w	(Sidekick+top_solid_bit).w,(Saved_Solid_bits_2P).w
	move.w	(Ring_count_2P).w,(Saved_Ring_count_2P).w
	move.b	(Extra_life_flags_2P).w,(Saved_Extra_life_flags_2P).w
	move.l	(Timer_2P).w,(Saved_Timer_2P).w
	rts
; ===========================================================================
; continue from a starpost / load checkpoint
; loc_1F35E:
Obj79_LoadData:
	move.b	(Saved_Last_star_pole_hit).w,(Last_star_pole_hit).w
	move.w	(Saved_x_pos).w,(MainCharacter+x_pos).w
	move.w	(Saved_y_pos).w,(MainCharacter+y_pos).w
	move.w	(Saved_Ring_count).w,(Ring_count).w
	move.b	(Saved_Extra_life_flags).w,(Extra_life_flags).w
	clr.w	(Ring_count).w
	clr.b	(Extra_life_flags).w
	move.l	(Saved_Timer).w,(Timer).w
	move.b	#59,(Timer_frame).w
	subq.b	#1,(Timer_second).w
	move.w	(Saved_art_tile).w,(MainCharacter+art_tile).w
	move.w	(Saved_Solid_bits).w,(MainCharacter+top_solid_bit).w
	move.b	(Saved_Dynamic_Resize_Routine).w,(Dynamic_Resize_Routine).w
	move.b	(Saved_Water_routine).w,(Water_routine).w
	move.w	(Saved_Camera_Max_Y_pos).w,(Camera_Max_Y_pos).w
	move.w	(Saved_Camera_Max_Y_pos).w,(Camera_Max_Y_pos_target).w
	move.w	(Saved_Camera_X_pos).w,(Camera_X_pos).w
	move.w	(Saved_Camera_Y_pos).w,(Camera_Y_pos).w
	move.w	(Saved_Camera_BG_X_pos).w,(Camera_BG_X_pos).w
	move.w	(Saved_Camera_BG_Y_pos).w,(Camera_BG_Y_pos).w
	move.w	(Saved_Camera_BG2_X_pos).w,(Camera_BG2_X_pos).w
	move.w	(Saved_Camera_BG2_Y_pos).w,(Camera_BG2_Y_pos).w
	move.w	(Saved_Camera_BG3_X_pos).w,(Camera_BG3_X_pos).w
	move.w	(Saved_Camera_BG3_Y_pos).w,(Camera_BG3_Y_pos).w
	tst.b	(Water_flag).w	; does the level have water?
	beq.s	+		; if not, branch to skip loading water stuff
	move.w	(Saved_Water_Level).w,(Water_Level_2).w
	move.b	(Saved_Water_routine).w,(Water_routine).w
	move.b	(Saved_Water_move).w,(Water_fullscreen_flag).w
+
	tst.b	(Last_star_pole_hit).w
	bpl.s	return_1F412
	move.w	(Saved_x_pos).w,d0
	subi.w	#$A0,d0
	move.w	d0,(Camera_Min_X_pos).w

return_1F412:
	rts
; ===========================================================================
; animation script
; off_1F414:
Ani_obj79:	offsetTable
		offsetTableEntry.w byte_1F41A	; 0
		offsetTableEntry.w byte_1F41D	; 1
		offsetTableEntry.w byte_1F420	; 2
byte_1F41A:
	dc.b  $F,  0,$FF
	rev02even
byte_1F41D:
	dc.b  $F,  1,$FF
	rev02even
byte_1F420:
	dc.b   3,  0,  4,$FF
	even
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj79_MapUnc_1F424:	include "mappings/sprite/obj79_a.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj79_MapUnc_1F4A0:	include "mappings/sprite/obj79_b.asm"
; ===========================================================================

; loc_1F4C4:
Obj79_MakeSpecialStars:
	moveq	#4-1,d1 ; execute the loop 4 times (1 for each star)
	moveq	#0,d2

-	bsr.w	AllocateObjectAfterCurrent
	bne.s	+	; rts
	_move.b	id(a0),id(a1) ; load obj79
	move.l	#Obj79_MapUnc_1F4A0,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Checkpoint,0,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#8,routine(a1) ; => Obj79_Star
	move.w	x_pos(a0),d0
	move.w	d0,x_pos(a1)
	move.w	d0,objoff_30(a1)
	move.w	y_pos(a0),d0
	subi.w	#$30,d0
	move.w	d0,y_pos(a1)
	move.w	d0,objoff_32(a1)
	move.b	priority(a0),priority(a1)
	move.b	#8,width_pixels(a1)
	move.b	#1,mapping_frame(a1)
	move.w	#-$400,x_vel(a1)
	move.w	#0,y_vel(a1)
	move.w	d2,objoff_34(a1) ; set the angle
	addi.w	#$40,d2 ; increase the angle for next time
	dbf	d1,- ; loop
+
	rts
; ===========================================================================
; loc_1F536:
Obj79_Star:
	move.b	collision_property(a0),d0
	beq.w	loc_1F554
	andi.b	#1,d0
	beq.s	+
	move.b	#1,(f_bigring).w
	move.b	#GameModeID_SpecialStage,(Game_Mode).w ; => SpecialStage
+
	clr.b	collision_property(a0)

loc_1F554:
	addi.w	#$A,objoff_34(a0)
	move.w	objoff_34(a0),d0
	andi.w	#$FF,d0
	jsr	(CalcSine).l
	asr.w	#5,d0
	asr.w	#3,d1
	move.w	d1,d3
	move.w	objoff_34(a0),d2
	andi.w	#$3E0,d2
	lsr.w	#5,d2
	moveq	#2,d5
	moveq	#0,d4
	cmpi.w	#$10,d2
	ble.s	+
	neg.w	d1
+
	andi.w	#$F,d2
	cmpi.w	#8,d2
	ble.s	loc_1F594
	neg.w	d2
	andi.w	#7,d2

loc_1F594:
	lsr.w	#1,d2
	beq.s	+
	add.w	d1,d4
+
	asl.w	#1,d1
	dbf	d5,loc_1F594

	asr.w	#4,d4
	add.w	d4,d0
	addq.w	#1,objoff_36(a0)
	move.w	objoff_36(a0),d1
	cmpi.w	#$80,d1
	beq.s	loc_1F5BE
	bgt.s	loc_1F5C4

loc_1F5B4:
	muls.w	d1,d0
	muls.w	d1,d3
	asr.w	#7,d0
	asr.w	#7,d3
	bra.s	loc_1F5D6
; ===========================================================================

loc_1F5BE:
	move.b	#$D8,collision_flags(a0)

loc_1F5C4:
	cmpi.w	#$180,d1
	ble.s	loc_1F5D6
	neg.w	d1
	addi.w	#$200,d1
	bmi.w	JmpTo10_DeleteObject
	bra.s	loc_1F5B4
; ===========================================================================

loc_1F5D6:
	move.w	objoff_30(a0),d2
	add.w	d3,d2
	move.w	d2,x_pos(a0)
	move.w	objoff_32(a0),d2
	add.w	d0,d2
	move.w	d2,y_pos(a0)
	addq.b	#1,anim_frame(a0)
	move.b	anim_frame(a0),d0
	andi.w	#6,d0
	lsr.w	#1,d0
	cmpi.b	#3,d0
	bne.s	+
	moveq	#1,d0
+
	move.b	d0,mapping_frame(a0)
	jmpto	MarkObjGone, JmpTo_MarkObjGone
; ===========================================================================

JmpTo10_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo2_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo3_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
