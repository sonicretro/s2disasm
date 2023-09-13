; ===========================================================================
; ----------------------------------------------------------------------------
; Object 66 - Yellow spring walls from MTZ
; ----------------------------------------------------------------------------
; Sprite_26F58:
Obj66:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj66_Index(pc,d0.w),d1
	jmp	Obj66_Index(pc,d1.w)
; ===========================================================================
; off_26F66:
Obj66_Index:	offsetTable
		offsetTableEntry.w Obj66_Init	; 0
		offsetTableEntry.w Obj66_Main	; 2
; ===========================================================================
; loc_26F6A:
Obj66_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj66_MapUnc_27120,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Powerups,0,1),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo30_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#8,width_pixels(a0)
	move.b	#4,priority(a0)
	move.b	#$40,y_radius(a0)
	move.b	subtype(a0),d0
	lsr.b	#4,d0
	andi.b	#7,d0
	move.b	d0,mapping_frame(a0)
	beq.s	Obj66_Main
	move.b	#$80,y_radius(a0)
; loc_26FAE:
Obj66_Main:
	move.w	#$13,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	x_pos(a0),d4
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	jsrto	SolidObject_Always_SingleCharacter, JmpTo3_SolidObject_Always_SingleCharacter
	cmpi.b	#1,d4
	bne.s	loc_26FF6
	btst	#1,status(a1)
	beq.s	loc_26FF6
	move.b	status(a0),d1
	move.w	x_pos(a0),d0
	sub.w	x_pos(a1),d0
	bcs.s	+
	eori.b	#1,d1
+
	andi.b	#1,d1
	bne.s	loc_26FF6
	bsr.s	loc_27042

loc_26FF6:
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	moveq	#p2_standing_bit,d6
	jsrto	SolidObject_Always_SingleCharacter, JmpTo3_SolidObject_Always_SingleCharacter
	cmpi.b	#1,d4
	bne.s	loc_2702C
	btst	#1,status(a1)
	beq.s	loc_2702C
	move.b	status(a0),d1
	move.w	x_pos(a0),d0
	sub.w	x_pos(a1),d0
	bcs.s	+
	eori.b	#1,d1
+
	andi.b	#1,d1
	bne.s	loc_2702C
	bsr.s	loc_27042

loc_2702C:
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo33_DeleteObject
    if gameRevision=0
       ; this object was visible with debug mode in REV00
	tst.w	(Debug_placement_mode).w
	beq.s	+	; rts
	jsrto	DisplaySprite, JmpTo47_DisplaySprite
+
    endif
	rts

    if removeJmpTos
JmpTo33_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
loc_27042:
    if gameRevision>0
	; REV00 didn't prevent the player from bouncing if they were hurt or dead
	cmpi.b	#4,routine(a1)
	blo.s	loc_2704C
	rts
    endif
; ===========================================================================

loc_2704C:
	move.w	objoff_30(a0),x_vel(a1)
	move.w	#-$800,x_vel(a1)
	move.w	#-$800,y_vel(a1)
	bset	#0,status(a1)
	btst	#0,status(a0)
	bne.s	+
	bclr	#0,status(a1)
	neg.w	x_vel(a1)
+
	move.w	#$F,move_lock(a1)
	move.w	x_vel(a1),inertia(a1)
	btst	#2,status(a1)
	bne.s	+
	move.b	#AniIDSonAni_Walk,anim(a1)
+
	move.b	subtype(a0),d0
	bpl.s	+
	move.w	#0,y_vel(a1)
+
	btst	#0,d0
	beq.s	loc_270DC
	move.w	#1,inertia(a1)
	move.b	#1,flip_angle(a1)
	move.b	#AniIDSonAni_Walk,anim(a1)
	move.b	#1,flips_remaining(a1)
	move.b	#8,flip_speed(a1)
	btst	#1,d0
	bne.s	+
	move.b	#3,flips_remaining(a1)
+
	btst	#0,status(a1)
	beq.s	loc_270DC
	neg.b	flip_angle(a1)
	neg.w	inertia(a1)

loc_270DC:
	andi.b	#$C,d0
	cmpi.b	#4,d0
	bne.s	+
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)
+
	cmpi.b	#8,d0
	bne.s	+
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)
+
	bclr	#p1_pushing_bit,status(a0)
	bclr	#p2_pushing_bit,status(a0)
    if fixBugs
	; Clear the player's 'roll-jumping' flag, to unlock their controls
	; and prevent them from getting stuck.
	bclr	#4,status(a1)
    endif
	bclr	#5,status(a1)
	move.w	#SndID_Spring,d0
	jmp	(PlaySound).l
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj66_MapUnc_27120:	include "mappings/sprite/obj66.asm"
; ===========================================================================

    if ~~removeJmpTos

     if gameRevision=0
JmpTo47_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
     endif

JmpTo33_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo30_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo3_SolidObject_Always_SingleCharacter ; JmpTo
	jmp	(SolidObject_Always_SingleCharacter).l

	align 4
    endif
