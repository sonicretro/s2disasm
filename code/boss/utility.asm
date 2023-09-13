; ===========================================================================
; ----------------------------------------------------------------------------
; Object 58 - Boss explosion
; ----------------------------------------------------------------------------
; Sprite_2D494:
Obj58:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj58_Index(pc,d0.w),d1
	jmp	Obj58_Index(pc,d1.w)
; ===========================================================================
; off_2D4A2:
Obj58_Index:	offsetTable
		offsetTableEntry.w Obj58_Init	; 0
		offsetTableEntry.w Obj58_Main	; 2
; ===========================================================================
; loc_2D4A6:
Obj58_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj58_MapUnc_2D50A,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_FieryExplosion,0,1),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo59_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#0,priority(a0)
	move.b	#0,collision_flags(a0)
	move.b	#$C,width_pixels(a0)
	move.b	#7,anim_frame_duration(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#SndID_BossExplosion,d0
	jmp	(PlaySound).l
; ===========================================================================
	rts
; ===========================================================================
; loc_2D4EC:
Obj58_Main:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#7,mapping_frame(a0)
	beq.w	JmpTo50_DeleteObject
+
	jmpto	DisplaySprite, JmpTo33_DisplaySprite

    if removeJmpTos
JmpTo50_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj58_MapUnc_2D50A:	include "mappings/sprite/obj58.asm"
; ===========================================================================

	; Unused - a little dead code here (until the next label)
;Boss_HoverPos:
	move.b	boss_sine_count(a0),d0 ; a0=object
	jsr	(CalcSine).l
	asr.w	#6,d0
	add.w	(Boss_Y_pos).w,d0
	move.w	d0,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	addq.b	#2,boss_sine_count(a0)

;loc_2D57C
Boss_HandleHits:
	cmpi.b	#8,boss_routine(a0)	; is boss exploding or retreating?
	bhs.s	return_2D5C2		; if yes, branch
	tst.b	boss_hitcount2(a0)	; has boss run out of hits?
	beq.s	Boss_Defeat		; if yes, branch
	tst.b	collision_flags(a0)	; are boss' collisions enabled?
	bne.s	return_2D5C2		; if yes, branch
	tst.b	boss_invulnerable_time(a0)	; is boss invulnerable?
	bne.s	+				; if yes, branch
	move.b	#$20,boss_invulnerable_time(a0)	; make boss invulnerable
	move.w	#SndID_BossHit,d0	; play "boss hit" sound
	jsr	(PlaySound).l
+
	; do palette flashing effect
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0		; 0000 = black
	tst.w	(a1)		; is current color black?
	bne.s	+		; if not, branch
	move.w	#$EEE,d0	; 0EEE = white
+
	move.w	d0,(a1)		; set color to white or black
	subq.b	#1,boss_invulnerable_time(a0)	; decrease boss' invulnerable time
	bne.s	return_2D5C2			; branch, if it hasn't run out
	move.b	#$F,collision_flags(a0)		; else, restore collisions

return_2D5C2:
	rts
; ===========================================================================
; loc_2D5C4:
Boss_Defeat:
	moveq	#100,d0
	jsrto	AddPoints, JmpTo_AddPoints
	move.w	#$B3,(Boss_Countdown).w
	move.b	#8,boss_routine(a0)
	moveq	#PLCID_Capsule,d0
	jsrto	LoadPLC, JmpTo4_LoadPLC
	rts
; ===========================================================================

;loc_2D5DE:
Boss_MoveObject:
	move.l	(Boss_X_pos).w,d2
	move.l	(Boss_Y_pos).w,d3
	move.w	(Boss_X_vel).w,d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d2
	move.w	(Boss_Y_vel).w,d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d2,(Boss_X_pos).w
	move.l	d3,(Boss_Y_pos).w
	rts
; ===========================================================================
; a1 = animation script pointer
;AnimationArray: up to 8 2-byte entries:
	; 4-bit: anim_ID (1)
	; 4-bit: anim_ID (2) - the relevant one
	; 4-bit: anim_frame
	; 4-bit: anim_timer until next anim_frame
; if anim_ID (1) & (2) are not equal, new animation data is loaded

;loc_2D604:
AnimateBoss:
	moveq	#0,d6
	movea.l	a1,a4		; address of animation script
	lea	(Boss_AnimationArray).w,a2
	lea	mainspr_mapframe(a0),a3	; mapframe 1 (main object)
	tst.b	(a3)
	bne.s	+
	addq.w	#2,a2
	bra.s	++
; ----------------------------------------------------------------------------
+
	bsr.w	AnimateBoss_Loop

+
	moveq	#0,d6
	move.b	mainspr_childsprites(a0),d6	; number of child sprites
	subq.w	#1,d6		; = amount of iterations to run the code from AnimateBoss_Loop
	bmi.s	return_2D690	; if was 0, don't run
	lea	sub2_mapframe(a0),a3	; mapframe 2
; ----------------------------------------------------------------------------
;loc_2D62A:
AnimateBoss_Loop:	; increases a2 (AnimationArray) by 2 each iteration
	movea.l	a4,a1
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d4
	move.b	(a2)+,d0
	move.b	d0,d1
	lsr.b	#4,d1		; anim_ID (1)
	andi.b	#$F,d0		; anim_ID (2)
	move.b	d0,d2
	cmp.b	d0,d1
	beq.s	+
	st.b	d4		; anim_IDs not equal
+
	move.b	d0,d5
	lsl.b	#4,d5
	or.b	d0,d5		; anim_ID (2) in both nybbles
	move.b	(a2)+,d0
	move.b	d0,d1
	lsr.b	#4,d1		; anim_frame
	tst.b	d4		; are the anim_IDs equal?
	beq.s	+
	moveq	#0,d0
	moveq	#0,d1		; reset d0,d1 if anim_IDs not equal
+
	andi.b	#$F,d0		; timer until next anim_frame
	subi_.b	#1,d0
	bpl.s	loc_2D67C	; timer not yet at 0, and anim_IDs are equal

	add.w	d2,d2		; anim_ID (2)
	adda.w	(a1,d2.w),a1	; address of animation data with this ID
	move.b	(a1),d0		; animation speed
	move.b	1(a1,d1.w),d2	; mapping_frame of first/next anim_frame
	bmi.s	AnimateBoss_CmdParam	; if animation command parameter, branch

loc_2D672:
	andi.b	#$7F,d2
	move.b	d2,(a3)		; store mapping_frame to OST of object
	addi_.b	#1,d1		; anim_frame

loc_2D67C:
	lsl.b	#4,d1
	or.b	d1,d0
	move.b	d0,-1(a2)	; (2nd byte) anim_frame and anim_timer
	move.b	d5,-2(a2)	; (1st byte) anim_ID (both nybbles)
	adda_.w	#6,a3		; mapping_frame of next subobject
	dbf	d6,AnimateBoss_Loop

return_2D690:
	rts
; ----------------------------------------------------------------------------
;loc_2D692:
AnimateBoss_CmdParam:	; parameter $FF - reset animation to first frame
	addq.b	#1,d2
	bne.s	+
	move.b	#0,d1
	move.b	1(a1),d2
	bra.s	loc_2D672
; ----------------------------------------------------------------------------
+		; parameter $FE - increase boss routine
	addq.b	#1,d2
	bne.s	+
	addi_.b	#2,angle(a0)	; boss routine
	rts
; ----------------------------------------------------------------------------
+		; parameter $FD - change anim_ID to byte after parameter
	addq.b	#1,d2
	bne.s	+
	andi.b	#$F0,d5		; keep anim_ID (1)
	or.b	2(a1,d1.w),d5	; set anim_ID (2)
	bra.s	loc_2D67C
; ----------------------------------------------------------------------------
+		; parameter $FC - jump back to anim_frame d1
	addq.b	#1,d2
	bne.s	+	; rts
	moveq	#0,d3
	move.b	2(a1,d1.w),d1	; anim_frame
	move.b	1(a1,d1.w),d2	; mapping_frame
	bra.s	loc_2D672
; ----------------------------------------------------------------------------
+		; parameter $80-$FB
	rts
; ===========================================================================

;loc_2D6CC:
Boss_LoadExplosion:
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

    if ~~removeJmpTos
JmpTo33_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo50_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo4_LoadPLC ; JmpTo
	jmp	(LoadPLC).l
JmpTo_AddPoints ; JmpTo
	jmp	(AddPoints).l
JmpTo59_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
