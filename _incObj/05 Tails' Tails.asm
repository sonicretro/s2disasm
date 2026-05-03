; ----------------------------------------------------------------------------
; Object 05 - Tails' tails
; ----------------------------------------------------------------------------
; Sprite_1D200:
Obj05:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj05_Index(pc,d0.w),d1
	jmp	Obj05_Index(pc,d1.w)
; ===========================================================================
; off_1D20E: Obj05_States:
Obj05_Index:	offsetTable
		offsetTableEntry.w Obj05_Init	; 0
		offsetTableEntry.w Obj05_Main	; 2
; ===========================================================================

Obj05_parent_prev_anim = objoff_30

; loc_1D212
Obj05_Init:
	addq.b	#2,routine(a0) ; => Obj05_Main
	move.l	#MapUnc_Tails,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtUnc_Tails_Tails,0,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#2,priority(a0)
	move.b	#$18,width_pixels(a0)
	move.b	#1<<render_flags.level_fg,render_flags(a0)

; loc_1D23A:
Obj05_Main:
	movea.w	parent(a0),a2 ; a2=character
	move.b	angle(a2),angle(a0)
	move.b	status(a2),status(a0)
	move.w	x_pos(a2),x_pos(a0)
	move.w	y_pos(a2),y_pos(a0)
	andi.w	#drawing_mask,art_tile(a0)
	tst.w	art_tile(a2)
	bpl.s	+
	ori.w	#high_priority,art_tile(a0)
+
	moveq	#0,d0
	move.b	anim(a2),d0
    if fixBugs
	; Tails doesn't actually have to be pushing against something for his
	; tails to animate as if he is. This is because bit 5 of 'status' is
	; set whenever Tails is stood next to something: he doesn't
	; necessarily have to be pushing against it. To fix this, we have to
	; check if Tails is displaying any of his pushing sprites. This is
	; exactly how this bug is fixed in Sonic 3 & Knuckles.
	cmpi.b	#$63,mapping_frame(a2)
	blo.s	+
	cmpi.b	#$66,mapping_frame(a2)
	bhi.s	+
    else
	btst	#status.player.pushing,status(a2)
	beq.s	+
    endif
	moveq	#4,d0
+
	; This is here so Obj05Ani_Flick works
	; It changes anim(a0) itself, so we don't want the below code changing it as well
	cmp.b	Obj05_parent_prev_anim(a0),d0	; Did Tails' animation change?
	beq.s	.display
	move.b	d0,Obj05_parent_prev_anim(a0)
	move.b	Obj05AniSelection(pc,d0.w),anim(a0)	; If so, update Tails' tails' animation
; loc_1D288:
.display:
	lea	(Obj05AniData).l,a1
	bsr.w	Tails_Animate_Part2
	bsr.w	LoadTailsTailsDynPLC
	jsr	(DisplaySprite).l
	rts
; ===========================================================================
; animation master script table for the tails
; chooses which animation script to run depending on what Tails is doing
; byte_1D29E:
Obj05AniSelection:
	dc.b	0,0	; TailsAni_Walk,Run	->
	dc.b	3	; TailsAni_Roll		-> Directional
	dc.b	3	; TailsAni_Roll2	-> Directional
	dc.b	9	; TailsAni_Push		-> Pushing
	dc.b	1	; TailsAni_Wait		-> Swish
	dc.b	0	; TailsAni_Balance	-> Blank
	dc.b	2	; TailsAni_LookUp	-> Flick
	dc.b	1	; TailsAni_Duck		-> Swish
	dc.b	7	; TailsAni_Spindash	-> Spindash
	dc.b	0,0,0	; TailsAni_Dummy1,2,3	->
	dc.b	8	; TailsAni_Stop		-> Skidding
	dc.b	0,0	; TailsAni_Float,2	->
	dc.b	0	; TailsAni_Spring	->
	dc.b	0	; TailsAni_Hang		->
	dc.b	0,0	; TailsAni_Blink,2	->
	dc.b	$A	; TailsAni_Hang2	-> Hanging
	dc.b	0	; TailsAni_Bubble	->
	dc.b	0,0,0,0	; TailsAni_Death,2,3,4	->
	dc.b	0,0	; TailsAni_Hurt,Slide	->
	dc.b	0	; TailsAni_Blank	->
	dc.b	0,0	; TailsAni_Dummy4,5	->
	dc.b	0	; TailsAni_HaulAss	->
	dc.b	0	; TailsAni_Fly		->
	even
