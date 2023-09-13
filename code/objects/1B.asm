; ===========================================================================
; ----------------------------------------------------------------------------
; Object 1B - Speed booster from CPZ
; ----------------------------------------------------------------------------
speedbooster_boostspeed =	objoff_30
; Sprite_222AC:
Obj1B:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj1B_Index(pc,d0.w),d1
	jmp	Obj1B_Index(pc,d1.w)
; ===========================================================================
; off_222BA:
Obj1B_Index:	offsetTable
		offsetTableEntry.w Obj1B_Init	; 0
		offsetTableEntry.w Obj1B_Main	; 2
; ---------------------------------------------------------------------------
; word_222BE:
Obj1B_BoosterSpeeds:
	dc.w $1000
	dc.w  $A00
; ===========================================================================
; loc_222C2:
Obj1B_Init:
	addq.b	#2,routine(a0) ; => Obj1B_Main
	move.l	#Obj1B_MapUnc_223E2,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBooster,3,1),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo16_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#1,priority(a0)
	move.b	subtype(a0),d0
	andi.w	#2,d0
	move.w	Obj1B_BoosterSpeeds(pc,d0.w),speedbooster_boostspeed(a0)

; loc_222F8:
Obj1B_Main:
	move.b	(Timer_frames+1).w,d0
	andi.b	#2,d0
	move.b	d0,mapping_frame(a0)
	move.w	x_pos(a0),d0
	move.w	d0,d1
	subi.w	#$10,d0
	addi.w	#$10,d1
	move.w	y_pos(a0),d2
	move.w	d2,d3
	subi.w	#$10,d2
	addi.w	#$10,d3

	lea	(MainCharacter).w,a1 ; a1=character
	btst	#1,status(a1)
	bne.s	+
	move.w	x_pos(a1),d4
	cmp.w	d0,d4
	blo.w	+
	cmp.w	d1,d4
	bhs.w	+
	move.w	y_pos(a1),d4
	cmp.w	d2,d4
	blo.w	+
	cmp.w	d3,d4
	bhs.w	+
	move.w	d0,-(sp)
	bsr.w	Obj1B_GiveBoost
	move.w	(sp)+,d0
+
	lea	(Sidekick).w,a1 ; a1=character
	btst	#1,status(a1)
	bne.s	+
	move.w	x_pos(a1),d4
	cmp.w	d0,d4
	blo.w	+
	cmp.w	d1,d4
	bhs.w	+
	move.w	y_pos(a1),d4
	cmp.w	d2,d4
	blo.w	+
	cmp.w	d3,d4
	bhs.w	+
	bsr.w	Obj1B_GiveBoost
+
	jmpto	MarkObjGone, JmpTo6_MarkObjGone

; ===========================================================================
; sub_22388:
Obj1B_GiveBoost:
	move.w	x_vel(a1),d0
	btst	#0,status(a0)
	beq.s	+
	neg.w	d0 ; d0 = absolute value of character's x velocity
+
	cmpi.w	#$1000,d0		; is the character already going super fast?
	bge.s	Obj1B_GiveBoost_Done	; if yes, branch to not change the speed
	move.w	speedbooster_boostspeed(a0),x_vel(a1) ; make the character go super fast
	bclr	#0,status(a1)	; turn him right
	btst	#0,status(a0)	; was that the correct direction?
	beq.s	+		; if yes, branch
	bset	#0,status(a1)	; turn him left
	neg.w	x_vel(a1)	; make the boosting direction left
+
	move.w	#$F,move_lock(a1)	; don't let him turn around for a few frames
	move.w	x_vel(a1),inertia(a1)	; update his inertia value
	bclr	#5,status(a0)
	bclr	#6,status(a0)
	bclr	#5,status(a1)
; loc_223D8:
Obj1B_GiveBoost_Done:
	move.w	#SndID_Spring,d0 ; spring boing sound
	jmp	(PlaySound).l
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj1B_MapUnc_223E2:	include "mappings/sprite/obj1B.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo6_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo16_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
