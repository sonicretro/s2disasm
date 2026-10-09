; ---------------------------------------------------------------------------
; Object 25 - A ring (usually only placed through placement mode)
; ---------------------------------------------------------------------------
; OST Variables:
ring_base_x_pos		= objoff_32	; x-position of primary ring (leftover from Sonic 1)

; Sprite_11F44: Obj_Ring:
Obj25:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj25_Index(pc,d0.w),d1
	jmp	Obj25_Index(pc,d1.w)
; ===========================================================================
; off_11F52: Obj_25_subtbl:
Obj25_Index:	offsetTable
		offsetTableEntry.w Obj25_Init		; 0
		offsetTableEntry.w Obj25_Animate	; 2
		offsetTableEntry.w Obj25_Collect	; 4
		offsetTableEntry.w Obj25_Sparkle	; 6
		offsetTableEntry.w Obj25_Delete		; 8
; ===========================================================================
; loc_11F5C: Obj_25_sub_0:
Obj25_Init:
	addq.b	#2,routine(a0)
	move.w	x_pos(a0),ring_base_x_pos(a0)
	move.l	#Obj25_MapUnc_12382,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,1,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#2,priority(a0)
	move.b	#$47,collision_flags(a0)
	move.b	#8,width_pixels(a0)
; loc_11F90: Obj_25_sub_2:
Obj25_Animate:
	move.b	(Rings_anim_frame).w,mapping_frame(a0)
	move.w	ring_base_x_pos(a0),d0
	bra.w	MarkObjGone2
; ===========================================================================
; loc_11F9E: Obj_25_sub_4:
Obj25_Collect:
	addq.b	#2,routine(a0)
	move.b	#0,collision_flags(a0)
	move.b	#1,priority(a0)
	bsr.s	CollectRing
; loc_11FB0: Obj_25_sub_6:
Obj25_Sparkle:
	lea	(Ani_Ring).l,a1
	bsr.w	AnimateSprite
	bra.w	DisplaySprite
; ===========================================================================
; loc_11FBE: BranchTo4_DeleteObject
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
	bhs.s	JmpTo_PlaySound2	; if yes, play the ring sound
	addq.w	#1,(Ring_count).w	; add 1 to the ring count
	ori.b	#1,(Update_HUD_rings).w	; set flag to update the ring counter in the HUD
    endif

	cmpi.w	#100,(Ring_count).w	; does the player 1 have less than 100 rings?
	blo.s	JmpTo_PlaySound2	; if yes, play the ring sound
	bset	#1,(Extra_life_flags).w	; test and set the flag for the first extra life
	beq.s	+			; if it was clear before, branch
	cmpi.w	#200,(Ring_count).w	; does the player 1 have less than 200 rings?
	blo.s	JmpTo_PlaySound2	; if yes, play the ring sound
	bset	#2,(Extra_life_flags).w	; test and set the flag for the second extra life
	bne.s	JmpTo_PlaySound2	; if it was set before, play the ring sound
+
	addq.b	#1,(Life_count).w	; add 1 to the life count
	addq.b	#1,(Update_HUD_lives).w	; add 1 to the displayed life count
	move.w	#MusID_ExtraLife,d0	; prepare to play the extra life jingle

JmpTo_PlaySound2 ; JmpTo
	jmp	(PlaySound2).l
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
	blo.s	JmpTo2_PlaySound2		; if yes, play the ring sound
	bset	#1,(Extra_life_flags_2P).w	; test and set the flag for the first extra life
	beq.s	+				; if it was clear before, branch
	cmpi.w	#200,(Ring_count_2P).w		; does the player 2 have less than 200 rings?
	blo.s	JmpTo2_PlaySound2		; if yes, play the ring sound
	bset	#2,(Extra_life_flags_2P).w	; test and set the flag for the second extra life
	bne.s	JmpTo2_PlaySound2		; if it was set before, play the ring sound
+
	addq.b	#1,(Life_count_2P).w		; add 1 to the life count
	addq.b	#1,(Update_HUD_lives_2P).w	; add 1 to the displayed life count
	move.w	#MusID_ExtraLife,d0		; prepare to play the extra life jingle

JmpTo2_PlaySound2 ; JmpTo
	jmp	(PlaySound2).l
; End of function CollectRing

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 37 - Scattering rings (generated when Sonic is hurt and has rings)
; ---------------------------------------------------------------------------
; OST Variables:
  if fixBugs
lostrings_timer		= objoff_1F	; time until ring is deleted
  endif

; Sprite_12078:
Obj37:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj37_Index(pc,d0.w),d1
	jmp	Obj37_Index(pc,d1.w)
; ===========================================================================
; off_12086: Obj_37_subtbl:
Obj37_Index:	offsetTable
		offsetTableEntry.w Obj37_Init		; 0
		offsetTableEntry.w Obj37_Main		; 2
		offsetTableEntry.w Obj37_Collect	; 4
		offsetTableEntry.w Obj37_Sparkle	; 6
		offsetTableEntry.w Obj37_Delete		; 8
; ===========================================================================
; loc_12090: Obj_37_sub_0:
Obj37_Init:
	movea.l	a0,a1
	moveq	#0,d5
	move.w	(Ring_count).w,d5	; use Sonic's rings counter
	tst.b	parent+1(a0)		; did Tails lose his rings?
	beq.s	+			; if not, branch
	move.w	(Ring_count_2P).w,d5	; use Tails' ring counter instead
+
	moveq	#32,d0
	cmp.w	d0,d5		; has player over 33 rings?
	blo.s	+		; if not, branch
	move.w	d0,d5		; if yes, limit to 32 rings
+
	subq.w	#1,d5
	move.w	#$288,d4	; set initial angle
	bra.s	+
; ===========================================================================

-	bsr.w	AllocateObject
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
	move.b	#1<<render_flags.on_screen|1<<render_flags.level_fg,render_flags(a1)
	move.b	#3,priority(a1)
	move.b	#$47,collision_flags(a1)
	move.b	#8,width_pixels(a1)
  if ~~fixBugs
	; The ring deletion timer shouldn't be stored as a global variable, since
	; it makes it possible to reset it for all lost rings by getting hit twice
	; in quick succession (this is more noticeable in two player mode). Instead,
	; we'll handle it as an SST.
	move.b	#-1,(Ring_spill_anim_counter).w		; reset deletion/animation timer
  endif
	tst.w	d4
	bmi.s	+
	move.w	d4,d0
	jsrto	JmpTo4_CalcSine
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
  if fixBugs
	moveq	#-1,d0
	move.b	d0,lostrings_timer(a0)		; reset deletion/animation timer
	move.b	d0,(Ring_spill_anim_counter).w	; we still need this for the animation
  endif
	move.w	#SndID_RingSpill,d0
	jsr	(PlaySound2).l
	tst.b	parent+1(a0)	; did Tails grab the ring?
	bne.s	+		; if yes, branch
	; reset Sonic's ring counter
	move.w	#0,(Ring_count).w
	move.b	#$80,(Update_HUD_rings).w
	move.b	#0,(Extra_life_flags).w
	bra.s	Obj37_Main
; ===========================================================================
+
	; reset Tails' ring counter
	move.w	#0,(Ring_count_2P).w
	move.b	#$80,(Update_HUD_rings_2P).w
	move.b	#0,(Extra_life_flags_2P).w
; loc_12178: Obj_37_sub_2:
Obj37_Main:
	move.b	(Ring_spill_anim_frame).w,mapping_frame(a0)
	bsr.w	ObjectMove
	addi.w	#$18,y_vel(a0)		; apply gravity
	bmi.s	Obj37_CheckBoundary

	; only checks floor collision every 8 frames
	move.b	(Vint_runcount+3).w,d0
	add.b	d7,d0
	andi.b	#7,d0
	bne.s	Obj37_CheckBoundary

	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.s	loc_121D0
	jsr	(RingCheckFloorDist).l
	tst.w	d1			; has the ring hit the floor?
	bpl.s	Obj37_CheckBoundary	; if not, branch
	add.w	d1,y_pos(a0)		; align to floor
	; reduce y-speed by 25% and bounce
	move.w	y_vel(a0),d0
	asr.w	#2,d0
	sub.w	d0,y_vel(a0)
	neg.w	y_vel(a0)
; loc_121B8:
Obj37_CheckBoundary:
  if fixBugs
	subq.b	#1,lostrings_timer(a0)		; has the timer finished?
	beq.s	Obj37_Delete			; if yes, branch
  else
	tst.b	(Ring_spill_anim_counter).w	; has the animation finished?
	beq.s	Obj37_Delete			; if yes, branch
  endif
	; The code below is programmed to automatically delete rings if they hit
	; the bottom of the screen, however it does not take into account vertical
	; wrapping, leading to a situation where the player will unfairly lose all
	; their rings immediately if they happen to take damage near the boundary.
	move.w	(Camera_Max_Y_pos).w,d0
	addi.w	#screen_height,d0
	cmp.w	y_pos(a0),d0			; has object moved below the level boundary?
	blo.s	Obj37_Delete			; if yes, branch
	bra.w	DisplaySprite
; ===========================================================================

loc_121D0:
	tst.w	(Two_player_mode).w
	bne.w	Obj37_Delete
	bra.s	Obj37_CheckBoundary
; ===========================================================================
; loc_121DA: Obj_37_sub_4:
Obj37_Collect:
	addq.b	#2,routine(a0)
	move.b	#0,collision_flags(a0)
	move.b	#1,priority(a0)
	bsr.w	CollectRing
; loc_121EE: Obj_37_sub_6:
Obj37_Sparkle:
	lea	(Ani_Ring).l,a1
	bsr.w	AnimateSprite
	bra.w	DisplaySprite
; ===========================================================================
; loc_121FC: BranchTo5_DeleteObject
Obj37_Delete:
	bra.w	DeleteObject

; ===========================================================================
; ---------------------------------------------------------------------------
; Object XX - Giant Ring (leftover from S1, unreferenced)
; ---------------------------------------------------------------------------
; Sprite_12504: Obj_BigRing:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	BigRing_States(pc,d0.w),d1
	jmp	BigRing_States(pc,d1.w)
; ===========================================================================
; off_12512:
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
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$40,width_pixels(a0)
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.s	BigRing_Main
	; Got_Emerald is a boolean set after exiting a Special Stage, it should actually
	; be using Emerald_count.
	; This seems to be the result of Sega repurposing the original variable, since
	; it correctly checked Emerald_count up to Beta 4 (coincidentally, it was this
	; build that moved it from $FE57 to $FFB1). Super Sonic also incorrectly checked
	; this variable in Beta 5, and the All Emeralds cheat still writes to it.
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
	move.w	#$C40,(BigRingGraphics).w	; $C40 was the size of the Giant Ring graphics
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
	bsr.w	AllocateObject
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
	bset	#render_flags.x_flip,render_flags(a1)
+
	move.w	#SndID_EnterGiantRing,d0
	jsr	(PlaySound2).l
	bra.s	BigRing_Main
; ===========================================================================
; BranchTo6_DeleteObject
BigRing_Delete:
	bra.w	DeleteObject

; ===========================================================================
; ---------------------------------------------------------------------------
; Object XX - Giant Ring flash (leftover from S1, unreferenced)
; ---------------------------------------------------------------------------
; OST Variables:
flash_parent 		= objoff_3C

; Sprite_125C8: Obj_BigRingFlash:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	BigRingFlash_States(pc,d0.w),d1
	jmp	BigRingFlash_States(pc,d1.w)
; ===========================================================================
; off_125D6:
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
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
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
	movea.l	flash_parent(a0),a1 ; a1=object	; get the parent big ring object
	move.b	#6,routine(a1)			; set its routine to "delete"
	move.b	#AniIDSonAni_Blank,(MainCharacter+anim).w	; change the character's animation
	move.b	#1,(f_bigring).w
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#status_secondary.invincible,status_secondary(a1)
	bclr	#status_secondary.shield,status_secondary(a1)
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
	include "src/anim/Rings.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj25_MapUnc_12382:	include "mappings/sprite/obj37_a.asm"
; -------------------------------------------------------------------------------
; Unused sprite mappings
; -------------------------------------------------------------------------------
Obj37_MapUnc_123E6:	include "mappings/sprite/obj37_b.asm"
Obj37_MapUnc_124E6:	include "mappings/sprite/obj37_c.asm"

; ===========================================================================
