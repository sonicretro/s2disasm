; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Objects: Rings (25, 37, DC)

; ----------------------------------------------------------------------------
; Object 25 - A ring (usually only placed through placement mode)
; ----------------------------------------------------------------------------
; Obj_Ring:
Obj25:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj25_Index(pc,d0.w),d1
	jmp	Obj25_Index(pc,d1.w)
; ===========================================================================
; Obj_25_subtbl:
Obj25_Index:	offsetTable
		offsetTableEntry.w Obj25_Init		; 0
		offsetTableEntry.w Obj25_Animate	; 2
		offsetTableEntry.w Obj25_Collect	; 4
		offsetTableEntry.w Obj25_Sparkle	; 6
		offsetTableEntry.w Obj25_Delete		; 8
; ===========================================================================
; Obj_25_sub_0:
Obj25_Init:
	addq.b	#2,routine(a0)
	move.w	x_pos(a0),objoff_32(a0)
	move.l	#Obj25_MapUnc_12382,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,1,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#2,priority(a0)
	move.b	#$47,collision_flags(a0)
	move.b	#8,width_pixels(a0)
; Obj_25_sub_2:
Obj25_Animate:
	move.b	(Rings_anim_frame).w,mapping_frame(a0)
	move.w	objoff_32(a0),d0
	bra.w	MarkObjGone2
; ===========================================================================
; Obj_25_sub_4:
Obj25_Collect:
	addq.b	#2,routine(a0)
	move.b	#0,collision_flags(a0)
	move.b	#1,priority(a0)
	bsr.s	CollectRing
; Obj_25_sub_6:
Obj25_Sparkle:
	lea	(Ani_Ring).l,a1
	bsr.w	AnimateSprite
	bra.w	DisplaySprite
; ===========================================================================
; BranchTo4_DeleteObject 
Obj25_Delete:
	bra.w	DeleteObject

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_11FC2:
CollectRing:
	tst.b	parent+1(a0)		; did Tails collect the ring?
	bne.s	CollectRing_Tails	; if yes, branch

CollectRing_Sonic:
	cmpi.w	#999,(Rings_Collected).w ; did Sonic collect 999 or more rings?
	bhs.s	CollectRing_1P		; if yes, branch
	addq.w	#1,(Rings_Collected).w	; add 1 to the number of collected rings

CollectRing_1P:

    if gameRevision=0
	cmpi.w	#999,(Ring_count).w	; does the player 1 have 999 or more rings?
	bhs.s	+			; if yes, skip the increment
	addq.w	#1,(Ring_count).w	; add 1 to the ring count
+
	ori.b	#1,(Update_HUD_rings).w	; set flag to update the ring counter in the HUD
	move.w	#SndID_Ring,d0		; prepare to play the ring sound
    else
	move.w	#SndID_Ring,d0		; prepare to play the ring sound
	cmpi.w	#999,(Ring_count).w	; does the player 1 have 999 or more rings?
	bhs.s	JmpTo_PlaySoundStereo	; if yes, play the ring sound
	addq.w	#1,(Ring_count).w	; add 1 to the ring count
	ori.b	#1,(Update_HUD_rings).w	; set flag to update the ring counter in the HUD
    endif

	cmpi.w	#100,(Ring_count).w	; does the player 1 have less than 100 rings?
	blo.s	JmpTo_PlaySoundStereo	; if yes, play the ring sound
	bset	#1,(Extra_life_flags).w	; test and set the flag for the first extra life
	beq.s	+			; if it was clear before, branch
	cmpi.w	#200,(Ring_count).w	; does the player 1 have less than 200 rings?
	blo.s	JmpTo_PlaySoundStereo	; if yes, play the ring sound
	bset	#2,(Extra_life_flags).w	; test and set the flag for the second extra life
	bne.s	JmpTo_PlaySoundStereo	; if it was set before, play the ring sound
+
	addq.b	#1,(Life_count).w	; add 1 to the life count
	addq.b	#1,(Update_HUD_lives).w	; add 1 to the displayed life count
	move.w	#MusID_ExtraLife,d0	; prepare to play the extra life jingle

JmpTo_PlaySoundStereo 
	jmp	(PlaySoundStereo).l
; ===========================================================================
	rts
; ===========================================================================

CollectRing_Tails:
	cmpi.w	#999,(Rings_Collected_2P).w	; did Tails collect 999 or more rings?
	bhs.s	+				; if yes, branch
	addq.w	#1,(Rings_Collected_2P).w	; add 1 to the number of collected rings
+                                          
	cmpi.w	#999,(Ring_count_2P).w		; does Tails have 999 or more rings?
	bhs.s	+				; if yes, branch
	addq.w	#1,(Ring_count_2P).w		; add 1 to the ring count
+
	tst.w	(Two_player_mode).w		; are we in a 2P game?
	beq.s	CollectRing_1P			; if not, branch

; CollectRing_2P:
	ori.b	#1,(Update_HUD_rings_2P).w	; set flag to update the ring counter in the second player's HUD
	move.w	#SndID_Ring,d0			; prepare to play the ring sound
	cmpi.w	#100,(Ring_count_2P).w		; does the player 2 have less than 100 rings?
	blo.s	JmpTo2_PlaySoundStereo		; if yes, play the ring sound
	bset	#1,(Extra_life_flags_2P).w	; test and set the flag for the first extra life
	beq.s	+				; if it was clear before, branch
	cmpi.w	#200,(Ring_count_2P).w		; does the player 2 have less than 200 rings?
	blo.s	JmpTo2_PlaySoundStereo		; if yes, play the ring sound
	bset	#2,(Extra_life_flags_2P).w	; test and set the flag for the second extra life
	bne.s	JmpTo2_PlaySoundStereo		; if it was set before, play the ring sound
+
	addq.b	#1,(Life_count_2P).w		; add 1 to the life count
	addq.b	#1,(Update_HUD_lives_2P).w	; add 1 to the displayed life count
	move.w	#MusID_ExtraLife,d0		; prepare to play the extra life jingle

JmpTo2_PlaySoundStereo 
	jmp	(PlaySoundStereo).l
; End of function CollectRing

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 37 - Scattering rings (generated when Sonic is hurt and has rings)
; ----------------------------------------------------------------------------
; Sprite_12078:
Obj37:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj37_Index(pc,d0.w),d1
	jmp	Obj37_Index(pc,d1.w)
; ===========================================================================
; Obj_37_subtbl:
Obj37_Index:	offsetTable
		offsetTableEntry.w Obj37_Init		; 0
		offsetTableEntry.w Obj37_Main		; 2
		offsetTableEntry.w Obj37_Collect	; 4
		offsetTableEntry.w Obj37_Sparkle	; 6
		offsetTableEntry.w Obj37_Delete		; 8
; ===========================================================================
; Obj_37_sub_0:
Obj37_Init:
	movea.l	a0,a1
	moveq	#0,d5
	move.w	(Ring_count).w,d5
	tst.b	parent+1(a0)
	beq.s	+
	move.w	(Ring_count_2P).w,d5
+
	moveq	#$20,d0
	cmp.w	d0,d5
	blo.s	+
	move.w	d0,d5
+
	subq.w	#1,d5
	move.w	#$288,d4
	bra.s	+
; ===========================================================================

-	bsr.w	SingleObjLoad
	bne.w	+++
+
	_move.b	#ObjID_LostRings,id(a1) ; load obj37
	addq.b	#2,routine(a1)
	move.b	#8,y_radius(a1)
	move.b	#8,x_radius(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.l	#Obj25_MapUnc_12382,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,1,0),art_tile(a1)
	bsr.w	Adjust2PArtPointer2
	move.b	#$84,render_flags(a1)
	move.b	#3,priority(a1)
	move.b	#$47,collision_flags(a1)
	move.b	#8,width_pixels(a1)
	move.b	#-1,(Ring_spill_anim_counter).w
	tst.w	d4
	bmi.s	+
	move.w	d4,d0
	jsrto	(CalcSine).l, JmpTo4_CalcSine
	move.w	d4,d2
	lsr.w	#8,d2
	asl.w	d2,d0
	asl.w	d2,d1
	move.w	d0,d2
	move.w	d1,d3
	addi.b	#$10,d4
	bcc.s	+
	subi.w	#$80,d4
	bcc.s	+
	move.w	#$288,d4
+
	move.w	d2,x_vel(a1)
	move.w	d3,y_vel(a1)
	neg.w	d2
	neg.w	d4
	dbf	d5,-
+
	move.w	#SndID_RingSpill,d0
	jsr	(PlaySoundStereo).l
	tst.b	parent+1(a0)
	bne.s	+
	move.w	#0,(Ring_count).w
	move.b	#$80,(Update_HUD_rings).w
	move.b	#0,(Extra_life_flags).w
	bra.s	Obj37_Main
; ===========================================================================
+
	move.w	#0,(Ring_count_2P).w
	move.b	#$80,(Update_HUD_rings_2P).w
	move.b	#0,(Extra_life_flags_2P).w
; Obj_37_sub_2:
Obj37_Main:
	move.b	(Ring_spill_anim_frame).w,mapping_frame(a0)
	bsr.w	ObjectMove
	addi.w	#$18,y_vel(a0)
	bmi.s	loc_121B8
	move.b	(Vint_runcount+3).w,d0
	add.b	d7,d0
	andi.b	#7,d0
	bne.s	loc_121B8
	tst.b	render_flags(a0)
	bpl.s	loc_121D0
	jsr	(RingCheckFloorDist).l
	tst.w	d1
	bpl.s	loc_121B8
	add.w	d1,y_pos(a0)
	move.w	y_vel(a0),d0
	asr.w	#2,d0
	sub.w	d0,y_vel(a0)
	neg.w	y_vel(a0)

loc_121B8:

	tst.b	(Ring_spill_anim_counter).w
	beq.s	Obj37_Delete
	move.w	(Camera_Max_Y_pos_now).w,d0
	addi.w	#$E0,d0
	cmp.w	y_pos(a0),d0
	blo.s	Obj37_Delete
	bra.w	DisplaySprite
; ===========================================================================

loc_121D0:
	tst.w	(Two_player_mode).w
	bne.w	Obj37_Delete
	bra.s	loc_121B8
; ===========================================================================
; Obj_37_sub_4:
Obj37_Collect:
	addq.b	#2,routine(a0)
	move.b	#0,collision_flags(a0)
	move.b	#1,priority(a0)
	bsr.w	CollectRing
; Obj_37_sub_6:
Obj37_Sparkle:
	lea	(Ani_Ring).l,a1
	bsr.w	AnimateSprite
	bra.w	DisplaySprite
; ===========================================================================
; BranchTo5_DeleteObject 
Obj37_Delete:
	bra.w	DeleteObject

; Unused - dead code/data S1 big ring:
; ===========================================================================
; BigRing:
	; a0=object
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	BigRing_States(pc,d0.w),d1
	jmp	BigRing_States(pc,d1.w)
; ===========================================================================
BigRing_States:	offsetTable
		offsetTableEntry.w BigRing_Init		; 0
		offsetTableEntry.w BigRing_Main		; 2
		offsetTableEntry.w BigRing_Enter	; 4
		offsetTableEntry.w BigRing_Delete	; 6
; ===========================================================================
; loc_12216:
BigRing_Init:
	move.l	#Obj37_MapUnc_123E6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_BigRing,1,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#$40,width_pixels(a0)
	tst.b	render_flags(a0)
	bpl.s	BigRing_Main
	cmpi.b	#6,(Got_Emerald).w
	beq.w	BigRing_Delete
	cmpi.w	#50,(Ring_count).w
	bhs.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.b	#2,priority(a0)
	move.b	#$52,collision_flags(a0)
	move.w	#$C40,(BigRingGraphics).w
; loc_12264:
BigRing_Main:
	move.b	(Rings_anim_frame).w,mapping_frame(a0)
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	DeleteObject
	bra.w	DisplaySprite
; ===========================================================================
; loc_12282:
BigRing_Enter:
	subq.b	#2,routine(a0)
	move.b	#0,collision_flags(a0)
	bsr.w	SingleObjLoad
	bne.w	+
	; Note: the object ID is not set
	; If you want to restore the big ring object, you'll also have to
	; restore the ring flash object (right after this) and assign its ID to
	; the created object here (a1).
	;move.b	#ObjID_BigRingFlash,id(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.l	a0,objoff_3C(a1)
	move.w	(MainCharacter+x_pos).w,d0
	cmp.w	x_pos(a0),d0
	blo.s	+
	bset	#0,render_flags(a1)
+
	move.w	#SndID_EnterGiantRing,d0
	jsr	(PlaySoundStereo).l
	bra.s	BigRing_Main
; ===========================================================================
; BranchTo6_DeleteObject 
BigRing_Delete:
	bra.w	DeleteObject

; Unused - dead code/data S1 ring flash:
; ===========================================================================
; BigRingFlash:
	; a0=object
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	BigRingFlash_States(pc,d0.w),d1
	jmp	BigRingFlash_States(pc,d1.w)
; ===========================================================================
BigRingFlash_States: offsetTable
	offsetTableEntry.w BigRingFlash_Init	; 0
	offsetTableEntry.w BigRingFlash_Main	; 2
	offsetTableEntry.w BigRingFlash_Delete	; 4
; ===========================================================================
; loc_122D8:
BigRingFlash_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj37_MapUnc_124E6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_BigRing_Flash,1,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#0,priority(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#-1,mapping_frame(a0)
; loc_12306:
BigRingFlash_Main:
	bsr.s	BigRingFlash_Animate
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	DeleteObject
	bra.w	DisplaySprite

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_12320:
BigRingFlash_Animate:
	subq.b	#1,anim_frame_duration(a0)	; subtract 1 from frame duration
	bpl.s	+	; rts
	move.b	#1,anim_frame_duration(a0)	; reset frame duration (2 frames)
	addq.b	#1,mapping_frame(a0)		; use next animation frame
	cmpi.b	#8,mapping_frame(a0)		; have we reached the end of the animation frames?
	bhs.s	++				; if yes, branch
	cmpi.b	#3,mapping_frame(a0)		; have we reached the 4th animation frame?
	bne.s	+	; rts			; if not, return
	movea.l	objoff_3C(a0),a1 ; a1=object	; get the parent big ring object
	move.b	#6,routine(a1)			; set its routine to "delete"
	move.b	#AniIDSonAni_Blank,(MainCharacter+anim).w	; change the character's animation
	move.b	#1,(SpecialStage_flag_2P).w
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#status_sec_isInvincible,status_secondary(a1)
	bclr	#status_sec_hasShield,status_secondary(a1)
+	rts
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	#0,(MainCharacter).w		; delete the player object
	addq.l	#4,sp
	rts
; End of function BigRingFlash_Animate

; ===========================================================================
; BranchTo7_DeleteObject 
BigRingFlash_Delete:
	bra.w	DeleteObject

; end of dead code/data

; ===========================================================================

; animation script
; byte_1237A:
Ani_Ring:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   5,  4,  5,  6,  7,$FC
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj25_MapUnc_12382:	BINCLUDE "mappings/sprite/obj37_a.bin"

; -------------------------------------------------------------------------------
; Unused sprite mappings
; -------------------------------------------------------------------------------
Obj37_MapUnc_123E6:	BINCLUDE "mappings/sprite/obj37_b.bin"
; -------------------------------------------------------------------------------
; Unused sprite mappings
; -------------------------------------------------------------------------------
Obj37_MapUnc_124E6:	BINCLUDE "mappings/sprite/obj37_c.bin"

; ===========================================================================
; ----------------------------------------------------------------------------
; Object DC - Ring prize from Casino Night Zone
; ----------------------------------------------------------------------------
casino_prize_x_pos =		objoff_30	; X position of the ring with greater precision
casino_prize_y_pos =		objoff_34	; Y position of the ring with greater precision
casino_prize_machine_x_pos =	objoff_38	; X position of the slot machine that generated the ring
casino_prize_machine_y_pos =	objoff_3A	; Y position of the slot machine that generated the ring
casino_prize_display_delay =	objoff_3C	; number of frames before which the ring is displayed
; Sprite_125E6:
ObjDC:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjDC_Index(pc,d0.w),d1
	jmp	ObjDC_Index(pc,d1.w)
; ===========================================================================
; off_125F4:
ObjDC_Index:	offsetTable
		offsetTableEntry.w ObjDC_Main		; 0
		offsetTableEntry.w ObjDC_Animate	; 2
		offsetTableEntry.w ObjDC_Delete		; 4
; ===========================================================================
; loc_125FA:
ObjDC_Main:
	moveq	#0,d1
	move.w	casino_prize_machine_x_pos(a0),d1
	swap	d1
	move.l	casino_prize_x_pos(a0),d0
	sub.l	d1,d0
	asr.l	#4,d0
	sub.l	d0,casino_prize_x_pos(a0)
	move.w	casino_prize_x_pos(a0),x_pos(a0)
	moveq	#0,d1
	move.w	casino_prize_machine_y_pos(a0),d1
	swap	d1
	move.l	casino_prize_y_pos(a0),d0
	sub.l	d1,d0
	asr.l	#4,d0
	sub.l	d0,casino_prize_y_pos(a0)
	move.w	casino_prize_y_pos(a0),y_pos(a0)
	lea	Ani_objDC(pc),a1
	bsr.w	AnimateSprite
	subq.w	#1,casino_prize_display_delay(a0)
	bne.w	DisplaySprite
	movea.l	objoff_2A(a0),a1
	subq.w	#1,(a1)
	bsr.w	CollectRing
	addi_.b	#2,routine(a0)
; loc_1264E:
ObjDC_Animate:
	lea	Ani_Ring(pc),a1
	bsr.w	AnimateSprite
	bra.w	DisplaySprite
; ===========================================================================
; BranchTo8_DeleteObject 
ObjDC_Delete:
	bra.w	DeleteObject
; ===========================================================================
; animation script
; byte_1265E
Ani_objDC:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,  3,$FF
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo4_CalcSine 
	jmp	(CalcSine).l

	align 4
    endif
