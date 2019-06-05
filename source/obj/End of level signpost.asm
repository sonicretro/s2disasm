; ----------------------------------------------------------------------------
; Object 0D - End of level sign post
; ----------------------------------------------------------------------------
; OST:
obj0D_spinframe		= objoff_30 ; $30(a0)
obj0D_sparkleframe	= objoff_34 ; $34(a0)
obj0D_finalanim		= objoff_36 ; $36(a0) ; 4 if Tails only, 3 otherwise (determines what character to show)
; ----------------------------------------------------------------------------

Obj0D:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj0D_Index(pc,d0.w),d1
	jsr	Obj0D_Index(pc,d1.w)
	lea	(Ani_obj0D).l,a1
	bsr.w	AnimateSprite
	bsr.w	PLCLoad_Signpost
	bra.w	MarkObjGone
; ===========================================================================
; off_191D8: Obj_0D_subtbl: Obj0D_States:
Obj0D_Index:	offsetTable
		offsetTableEntry.w Obj0D_Init	; 0
		offsetTableEntry.w Obj0D_Main	; 2
; ===========================================================================
; loc_191DC: Obj_0D_sub_0:
Obj0D_Init:
	tst.w	(Two_player_mode).w
	beq.s	loc_19208
	move.l	#Obj0D_MapUnc_19656,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_2p_Signpost,0,0),art_tile(a0)
	move.b	#-1,(Signpost_prev_frame).w
	moveq	#0,d1
	move.w	#$1020,d1
	move.w	#-$80,d4
	moveq	#0,d5
	bsr.w	loc_19564
	bra.s	loc_1922C
; ---------------------------------------------------------------------------

loc_19208:
	cmpi.w	#metropolis_zone_act_2,(Current_ZoneAndAct).w
	beq.s	loc_1921E
	tst.b	(Current_Act).w
	beq.s	loc_1921E
	move.w	#0,x_pos(a0)
	rts
; ---------------------------------------------------------------------------
loc_1921E:
	move.l	#Obj0D_MapUnc_195BE,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Signpost,0,0),art_tile(a0)

loc_1922C:
	addq.b	#2,routine(a0) ; => Obj0D_Main
	bsr.w	Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$18,width_pixels(a0)
	move.b	#4,priority(a0)
	move.w	#$3C3C,(Loser_Time_Left).w

; loc_1924C: Obj_0D_sub_2:
Obj0D_Main:
	tst.b	(Update_HUD_timer).w
	beq.w	loc_192D6
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	bcs.s	loc_192D6
	cmpi.w	#$20,d0
	bhs.s	loc_192D6
	move.w	#SndID_Signpost,d0
	jsr	(PlayMusic).l	; play spinning sound
	clr.b	(Update_HUD_timer).w
	move.w	#1,anim(a0)
	move.w	#0,obj0D_spinframe(a0)
	move.w	(Camera_Max_X_pos).w,(Camera_Min_X_pos).w	; lock screen
	move.b	#2,routine_secondary(a0) ; => Obj0D_Main_State2
	cmpi.b	#$C,(Loser_Time_Left).w
	bhi.s	loc_192A0
	move.w	(Level_Music).w,d0
	jsr	(PlayMusic).l	; play zone music

loc_192A0:
	tst.b	obj0D_finalanim(a0)
	bne.w	loc_19350
	move.b	#3,obj0D_finalanim(a0)
	cmpi.w	#2,(Player_mode).w
	bne.s	loc_192BC
	move.b	#4,obj0D_finalanim(a0)

loc_192BC:
	tst.w	(Two_player_mode).w
	beq.w	loc_19350
	move.w	#$3C3C,(Loser_Time_Left).w
	move.w	#SndID_Signpost2P,d0	; play different spinning sound
	jsr	(PlaySound).l
	bra.s	loc_19350
; ---------------------------------------------------------------------------

loc_192D6:
	tst.w	(Two_player_mode).w
	beq.s	loc_19350
	tst.b	(Update_HUD_timer_2P).w
	beq.s	loc_19350
	lea	(Sidekick).w,a1 ; a1=character
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	bcs.s	loc_19350
	cmpi.w	#$20,d0
	bhs.s	loc_19350
	move.w	#SndID_Signpost,d0
	jsr	(PlayMusic).l
	clr.b	(Update_HUD_timer_2P).w
	move.w	#1,anim(a0)
	move.w	#0,obj0D_spinframe(a0)
	move.w	(Tails_Max_X_pos).w,(Tails_Min_X_pos).w
	move.b	#2,routine_secondary(a0) ; => Obj0D_Main_State2
	cmpi.b	#$C,(Loser_Time_Left).w
	bhi.s	loc_1932E
	move.w	(Level_Music).w,d0
	jsr	(PlayMusic).l

loc_1932E:
	tst.b	obj0D_finalanim(a0)
	bne.s	loc_19350
	move.b	#4,obj0D_finalanim(a0)
	tst.w	(Two_player_mode).w
	beq.s	loc_19350
	move.w	#$3C3C,(Loser_Time_Left).w
	move.w	#SndID_Signpost2P,d0
	jsr	(PlaySound).l

loc_19350:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj0D_Main_States(pc,d0.w),d1
	jmp	Obj0D_Main_States(pc,d1.w)
; ===========================================================================
Obj0D_Main_States: offsetTable
	offsetTableEntry.w Obj0D_Main_StateNull	; 0
	offsetTableEntry.w Obj0D_Main_State2	; 2
	offsetTableEntry.w Obj0D_Main_State3	; 4
	offsetTableEntry.w Obj0D_Main_State4	; 6
; ===========================================================================
; return_19366:
Obj0D_Main_StateNull:
	rts
; ===========================================================================
; loc_19368:
Obj0D_Main_State2:
	subq.w	#1,obj0D_spinframe(a0)
	bpl.s	loc_19398
	move.w	#$3C,obj0D_spinframe(a0)
	addq.b	#1,anim(a0)
	cmpi.b	#3,anim(a0)
	bne.s	loc_19398
	move.b	#4,routine_secondary(a0) ; => Obj0D_Main_State3
	move.b	obj0D_finalanim(a0),anim(a0)
	tst.w	(Two_player_mode).w
	beq.s	loc_19398
	move.b	#6,routine_secondary(a0) ; => Obj0D_Main_State4

loc_19398:
	subq.w	#1,objoff_32(a0)
	bpl.s	return_19406
	move.w	#$B,objoff_32(a0)
	moveq	#0,d0
	move.b	obj0D_sparkleframe(a0),d0
	addq.b	#2,obj0D_sparkleframe(a0)
	andi.b	#$E,obj0D_sparkleframe(a0)
	lea	Obj0D_RingSparklePositions(pc,d0.w),a2
	bsr.w	SingleObjLoad
	bne.s	return_19406
	_move.b	#ObjID_Ring,id(a1) ; load obj25 (a ring) for the sparkly effects over the signpost
	move.b	#6,routine(a1) ; => Obj_25_sub_6
	move.b	(a2)+,d0
	ext.w	d0
	add.w	x_pos(a0),d0
	move.w	d0,x_pos(a1)
	move.b	(a2)+,d0
	ext.w	d0
	add.w	y_pos(a0),d0
	move.w	d0,y_pos(a1)
	move.l	#Obj25_MapUnc_12382,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,1,0),art_tile(a1)
	bsr.w	Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#2,priority(a1)
	move.b	#8,width_pixels(a1)

return_19406:
	rts
; ===========================================================================
; byte_19408:
Obj0D_RingSparklePositions:
	dc.b -24,-16	; 1
	dc.b   8,  8	; 3
	dc.b -16,  0	; 5
	dc.b  24, -8	; 7
	dc.b   0, -8	; 9
	dc.b  16,  0	; 11
	dc.b -24,  8	; 13
	dc.b  24, 16	; 15
; ===========================================================================
; loc_19418:
Obj0D_Main_State3:
	tst.w	(Debug_placement_mode).w
	bne.w	return_194D0
	btst	#1,(MainCharacter+status).w
	bne.s	loc_19434
	move.b	#1,(Control_Locked).w
	move.w	#(button_right_mask<<8)|0,(Ctrl_1_Logical).w
loc_19434:
	; This check here is for S1's Big Ring, which would set Sonic's Object ID to 0
	tst.b	(MainCharacter+id).w
	beq.s	loc_1944C
	move.w	(MainCharacter+x_pos).w,d0
	move.w	(Camera_Max_X_pos).w,d1
	addi.w	#$128,d1
	cmp.w	d1,d0
	blo.w	return_194D0

loc_1944C:
	move.b	#0,routine_secondary(a0) ; => Obj0D_Main_StateNull
;loc_19452:
Load_EndOfAct:
	lea	(MainCharacter).w,a1 ; a1=character
	clr.b	status_secondary(a1)
	clr.b	(Update_HUD_timer).w
	bsr.w	SingleObjLoad
	bne.s	+
	move.b	#ObjID_Results,id(a1) ; load obj3A (end of level results screen)
+
	moveq	#PLCID_Results,d0
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	moveq	#PLCID_ResultsTails,d0
+
	jsr	(LoadPLC2).l
	move.b	#1,(Update_Bonus_score).w
	moveq	#0,d0
	move.b	(Timer_minute).w,d0
	mulu.w	#$3C,d0
	moveq	#0,d1
	move.b	(Timer_second).w,d1
	add.w	d1,d0
	divu.w	#$F,d0
	moveq	#$14,d1
	cmp.w	d1,d0
	blo.s	+
	move.w	d1,d0
+
	add.w	d0,d0
	move.w	TimeBonuses(pc,d0.w),(Bonus_Countdown_1).w
	move.w	(Ring_count).w,d0
	mulu.w	#$A,d0
	move.w	d0,(Bonus_Countdown_2).w
	clr.w	(Total_Bonus_Countdown).w
	clr.w	(Bonus_Countdown_3).w
	tst.w	(Perfect_rings_left).w
	bne.s	+
	move.w	#5000,(Bonus_Countdown_3).w
+
	move.w	#MusID_EndLevel,d0
	jsr	(PlayMusic).l

return_194D0:
	rts
; ===========================================================================
; word_194D2:
TimeBonuses:
	dc.w 5000, 5000, 1000, 500, 400, 400, 300, 300
	dc.w  200,  200,  200, 200, 100, 100, 100, 100
	dc.w   50,   50,   50,  50,   0
; ===========================================================================
; loc_194FC:
Obj0D_Main_State4:
	subq.w	#1,obj0D_spinframe(a0)
	bpl.s	return_19532
	tst.b	(Time_Over_flag).w
	bne.s	return_19532
	tst.b	(Time_Over_flag_2P).w
	bne.s	return_19532
	tst.b	(Update_HUD_timer).w
	bne.s	return_19532
	tst.b	(Update_HUD_timer_2P).w
	bne.s	return_19532
	move.b	#0,(Last_star_pole_hit).w
	move.b	#0,(Last_star_pole_hit_2P).w
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	move.w	#VsRSID_Act,(Results_Screen_2P).w

return_19532:
	rts
; ===========================================================================

PLCLoad_Signpost:
	tst.w	(Two_player_mode).w
	beq.s	return_1958C
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	cmp.b	(Signpost_prev_frame).w,d0
	beq.s	return_1958C
	move.b	d0,(Signpost_prev_frame).w
	lea	(Obj0D_MapRUnc_196EE).l,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d5
	subq.w	#1,d5
	bmi.s	return_1958C
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_Signpost),d4

loc_19560:
	moveq	#0,d1
	move.w	(a2)+,d1

loc_19564:
	move.w	d1,d3
	lsr.w	#8,d3
	andi.w	#$F0,d3
	addi.w	#$10,d3
	andi.w	#$FFF,d1
	lsl.l	#5,d1
	addi.l	#ArtUnc_Signpost,d1
	move.w	d4,d2
	add.w	d3,d4
	add.w	d3,d4
	jsr	(QueueDMATransfer).l
	dbf	d5,loc_19560

return_1958C:
	rts
; ===========================================================================
; animation script
; off_1958E:
Ani_obj0D:	offsetTable
		offsetTableEntry.w byte_19598	; 0
		offsetTableEntry.w byte_1959B	; 1
		offsetTableEntry.w byte_195A9	; 2
		offsetTableEntry.w byte_195B7	; 3
		offsetTableEntry.w byte_195BA	; 4
byte_19598:	dc.b	$0F, $02, $FF
	rev02even
byte_1959B:	dc.b	$01, $02, $03, $04, $05, $01, $03, $04, $05, $00, $03, $04, $05, $FF
	rev02even
byte_195A9:	dc.b	$01, $02, $03, $04, $05, $01, $03, $04, $05, $00, $03, $04, $05, $FF
	rev02even
byte_195B7:	dc.b	$0F, $00, $FF
	rev02even
byte_195BA:	dc.b	$0F, $01, $FF
	even
; -------------------------------------------------------------------------------
; sprite mappings - Primary sprite table for object 0D (signpost)
; -------------------------------------------------------------------------------
; SprTbl_0D_Primary:
Obj0D_MapUnc_195BE:	BINCLUDE "mappings/sprite/obj0D_a.bin"
; -------------------------------------------------------------------------------
; sprite mappings - Secondary sprite table for object 0D (signpost)
; -------------------------------------------------------------------------------
; SprTbl_0D_Scndary:
Obj0D_MapUnc_19656:	BINCLUDE "mappings/sprite/obj0D_b.bin"
; -------------------------------------------------------------------------------
; dynamic pattern loading cues
; -------------------------------------------------------------------------------
Obj0D_MapRUnc_196EE:	BINCLUDE "mappings/spriteDPLC/obj0D.bin"
; ===========================================================================

    if gameRevision<2
	nop
    endif
