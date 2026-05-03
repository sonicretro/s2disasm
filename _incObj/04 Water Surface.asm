; ----------------------------------------------------------------------------
; Object 04 - Surface of the water - water surface
; ----------------------------------------------------------------------------

Obj04:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj04_Index(pc,d0.w),d1
	jmp	Obj04_Index(pc,d1.w)
; ===========================================================================
; off_208EA:
Obj04_Index:	offsetTable
		offsetTableEntry.w Obj04_Init		; 0
		offsetTableEntry.w Obj04_Action		; 2
		offsetTableEntry.w Obj04_Action2	; 4
; ===========================================================================
; loc_208F0: Obj04_Main:
Obj04_Init:
	addq.b	#2,routine(a0) ; => Obj04_Action
	move.l	#Obj04_MapUnc_20A0E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_WaterSurface,0,1),art_tile(a0)
	jsrto	JmpTo12_Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#$80,width_pixels(a0)
	move.w	x_pos(a0),objoff_30(a0)
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	Obj04_Action
	addq.b	#2,routine(a0) ; Obj04_Action2
	move.l	#Obj04_MapUnc_20AFE,mappings(a0)
	bra.w	Obj04_Action2
; ===========================================================================
; loc_20930:
Obj04_Action:
	move.w	(Water_Level_1).w,d1
	move.w	d1,y_pos(a0)
	tst.b	objoff_32(a0)
	bne.s	Obj04_Animate
    if fixBugs
	move.b	(Ctrl_1_Press).w,d0 ; is Start button pressed?
	or.b	(Ctrl_2_Press).w,d0 ; (either player)
	andi.b	#button_start_mask,d0
    else
	; This only checks player 1, causing the water to look weird if
	; player 2 pauses the game instead.
	btst	#button_start,(Ctrl_1_Press).w	; is Start button pressed?
    endif
	beq.s	loc_20962		; if not, branch
	addq.b	#3,mapping_frame(a0)	; use different frames
	move.b	#1,objoff_32(a0)	; stop animation
	bra.s	Obj04_Display
; ===========================================================================
; loc_20952:
Obj04_Animate:
	tst.w	(Game_paused).w		; is the game paused?
	bne.s	Obj04_Display		; if yes, branch
	move.b	#0,objoff_32(a0)	; resume animation
	subq.b	#3,mapping_frame(a0)	; use normal frames

loc_20962:

    if ~~fixBugs
Obj04_Display:
    endif
	; This code should be skipped when the game is paused, but is isn't.
	; This causes the wrong sprite to display when the game is paused.
	lea	(Anim_obj04).l,a1
	moveq	#0,d1
	move.b	anim_frame(a0),d1
	move.b	(a1,d1.w),mapping_frame(a0)
	addq.b	#1,anim_frame(a0)
	andi.b	#$3F,anim_frame(a0)

    if fixBugs
Obj04_Display:
    endif
	jmpto	JmpTo10_DisplaySprite
; ===========================================================================
; water sprite animation 'script' (custom format for this object)
; byte_20982:
Anim_obj04:
	dc.b 0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1
	dc.b 1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2
	dc.b 2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1
	dc.b 1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0
	even
; ===========================================================================
; loc_209C2:
Obj04_Action2:
	move.w	(Water_Level_1).w,d1
	move.w	d1,y_pos(a0)
	tst.b	objoff_32(a0)
	bne.s	Obj04_Animate2
    if fixBugs
	move.b	(Ctrl_1_Press).w,d0 ; is Start button pressed?
	or.b	(Ctrl_2_Press).w,d0 ; (either player)
	andi.b	#button_start_mask,d0
    else
	; This only checks player 1, causing the water to look weird if
	; player 2 pauses the game instead.
	btst	#button_start,(Ctrl_1_Press).w	; is Start button pressed?
    endif
	beq.s	loc_209F4		; if not, branch
	addq.b	#2,mapping_frame(a0)    ; use different frames
	move.b	#1,objoff_32(a0)		; stop animation
	bra.s	BranchTo_JmpTo10_DisplaySprite
; ===========================================================================
; loc_209E4:
Obj04_Animate2:
	tst.w	(Game_paused).w	; is the game paused?
	bne.s	BranchTo_JmpTo10_DisplaySprite	; if yes, branch
	move.b	#0,objoff_32(a0)	; resume animation
	subq.b	#2,mapping_frame(a0)	; use normal frames

loc_209F4:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	BranchTo_JmpTo10_DisplaySprite
	move.b	#5,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	andi.b	#1,mapping_frame(a0)

BranchTo_JmpTo10_DisplaySprite ; BranchTo
	jmpto	JmpTo10_DisplaySprite
