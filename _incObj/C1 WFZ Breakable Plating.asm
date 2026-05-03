; ---------------------------------------------------------------------------
; Object C1 - Breakable plating from WFZ
; (and what Sonic hangs onto on the back of Robotnik's getaway ship)
; ---------------------------------------------------------------------------
; OST Variables:
plating_time		= objoff_30	; time between grabbing the plating & breaking
plating_grabbed		= objoff_32	; flag set when Sonic/Tails grab the plating
plating_unk		= objoff_3F	; seems to be used to determine how long some plates hold on
					; for after breaking until they fly off
; Sprite_3C0AC:
ObjC1:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC1_Index(pc,d0.w),d1
	jmp	ObjC1_Index(pc,d1.w)
; ===========================================================================
; off_3C0BA:
ObjC1_Index:	offsetTable
		offsetTableEntry.w ObjC1_Init	; 0
		offsetTableEntry.w ObjC1_Main	; 2
		offsetTableEntry.w ObjC1_FallOff	; 4
; ===========================================================================
; loc_3C0C0:
ObjC1_Init:
	move.w	#($44<<1),d0
	bsr.w	LoadSubObject_Part2
	moveq	#0,d0
	; Yes, this is actually configurable, but in practice is redundant
	; since all of them are set to break after 2 seconds.
	move.b	subtype(a0),d0
	mulu.w	#60,d0			; multiply by 60 (1 second)
	move.w	d0,plating_time(a0)	; set breakage time

ObjC1_Main:
	tst.b	plating_grabbed(a0)	; has plating already been grabbed?
	beq.s	ObjC1_Grab		; if not, branch
	tst.w	plating_time(a0)
	beq.s	+
	subq.w	#1,plating_time(a0)	; decrement time until break
	beq.s	ObjC1_Release
+
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	y_pos(a0),d0
	subi.w	#$18,d0
	btst	#button_up,(Ctrl_1_Held).w	; is Up being pressed?
	beq.s	+			; if not, branch
	subq.w	#1,y_pos(a1)		; move Sonic up
	cmp.w	y_pos(a1),d0
	blo.s	+			; but stop if he's about to fall off
	move.w	d0,y_pos(a1)
+
	addi.w	#$30,d0
	btst	#button_down,(Ctrl_1_Held).w	; is Down being pressed?
	beq.s	+			; if not, branch
	addq.w	#1,y_pos(a1)		; move Sonic down
	cmp.w	y_pos(a1),d0
	bhs.s	+			; but stop if he's about to fall off
	move.w	d0,y_pos(a1)
+
	move.b	(Ctrl_1_Press_Logical).w,d0
	andi.w	#button_B_mask|button_C_mask|button_A_mask,d0	; is A/B/C being pressed?
	beq.s	BranchTo16_JmpTo39_MarkObjGone		; if not, branch
; loc_3C12E:
ObjC1_Release:
	clr.b	collision_flags(a0)
	clr.b	(MainCharacter+obj_control).w
	clr.b	(WindTunnel_holding_flag).w
	clr.b	plating_grabbed(a0)
	bra.s	ObjC1_BeginBreakup
; ===========================================================================
; loc_3C140:
ObjC1_Grab:
	tst.b	collision_property(a0)		; has Sonic touched the plating?
	beq.s	BranchTo16_JmpTo39_MarkObjGone	; if not, branch
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a0),d0
	subi.w	#$14,d0
	cmp.w	x_pos(a1),d0
	bhs.s	BranchTo16_JmpTo39_MarkObjGone
	clr.b	collision_property(a0)
	cmpi.b	#4,routine(a1)			; is Sonic hurt, dying, etc?
	bhs.s	BranchTo16_JmpTo39_MarkObjGone	; if yes, branch
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	move.w	x_pos(a0),d0
	subi.w	#$14,d0
	move.w	d0,x_pos(a1)
	bset	#status.player.x_flip,status(a1)
	move.b	#AniIDSonAni_Hang,anim(a1)
	move.b	#1,(MainCharacter+obj_control).w	; lock controls
	move.b	#1,(WindTunnel_holding_flag).w		; disable wind tunnel
	move.b	#1,plating_grabbed(a0)		; begin break timer

BranchTo16_JmpTo39_MarkObjGone ; BranchTo
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; loc_3C19A:
ObjC1_BeginBreakup:
	lea	(ObjC1_Positions).l,a4
	lea	(ObjC1_BreakTimes).l,a2
	bsr.w	loc_3C1F4
; ObjC1_Breakup:
ObjC1_FallOff:
	tst.b	plating_unk(a0)
	beq.s	+
	subq.b	#1,plating_unk(a0)
	bra.s	++
; ===========================================================================
+
	jsrto	JmpTo26_ObjectMove
	addi_.w	#8,y_vel(a0)
	lea	(Ani_objC1).l,a1
	jsrto	JmpTo25_AnimateSprite
+
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.w	JmpTo65_DeleteObject
	jmpto	JmpTo45_DisplaySprite
; ===========================================================================
; animation script
; off_3C1D6:
Ani_objC1:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3,  2,  3,  4,  5,  1,$FF
		even

; Time (in frames) to wait until breaking off the aircraft
; byte_3C1E0:
ObjC1_BreakTimes:
	dc.b   0
	dc.b   4	; 1
	dc.b $18	; 2
	dc.b $20	; 3
	even

; Positions each breaking plate starts at
; byte_3C1E4:
ObjC1_Positions:
	; x-position, y-position
	dc.w  -$10,-$10
	dc.w  -$10, $10
	dc.w  -$30,-$10
	dc.w  -$30, $10
; ===========================================================================

loc_3C1F4:
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	move.b	priority(a0),d4
	subq.b	#1,d4
	moveq	#3,d1
	movea.l	a0,a1
	bra.s	loc_3C20E
; ===========================================================================

loc_3C208:
	jsrto	JmpTo25_AllocateObjectAfterCurrent
	bne.s	loc_3C26C

loc_3C20E:
	move.b	#4,routine(a1)
	_move.b	id(a0),id(a1) ; load obj
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#1<<render_flags.on_screen|1<<render_flags.level_fg,render_flags(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	(a4)+,d0
	add.w	d2,d0
	move.w	d0,x_pos(a1)
	move.w	(a4)+,d0
	add.w	d3,d0
	move.w	d0,y_pos(a1)
	move.b	d4,priority(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#1,mapping_frame(a1)
	move.w	#-$400,x_vel(a1)
	move.w	#0,y_vel(a1)
	move.b	(a2)+,plating_unk(a1)
	dbf	d1,loc_3C208

loc_3C26C:
	move.w	#SndID_SlowSmash,d0
	jmp	(PlaySound).l
; ===========================================================================
; off_3C276:
ObjC1_SubObjData:
	subObjData ObjC1_MapUnc_3C280,make_art_tile(ArtTile_ArtNem_BreakPanels,3,1),1<<render_flags.level_fg,4,$40,$E1
