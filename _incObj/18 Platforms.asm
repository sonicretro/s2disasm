; ----------------------------------------------------------------------------
; Object 18 - Stationary floating platform from ARZ, EHZ and HTZ
; ----------------------------------------------------------------------------
; subtype bits: sffftttt
; t = platform behavior (see Obj18_Behaviours)
; f = sprite frame and width (indexes Obj18_InitData)
; s = solidity type ; 0 = top solid, 1 = full solid
; ----------------------------------------------------------------------------
; s and f bits are filtered out after initialization so t bits can be used
; as a secondary routine counter
; ----------------------------------------------------------------------------
obj18_y_actual			= objoff_2C ; word ; unmodified y-position
obj18_x_origin			= objoff_32 ; word ; center point of movement
obj18_y_origin			= objoff_34 ; word ; ''
obj18_y_offset			= objoff_38 ; byte ; adjustment for sag
obj18_delay			= objoff_3A ; word ; fall or rise timer

; Sprite_104AC:
Obj18:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj18_Index(pc,d0.w),d1
	jmp	Obj18_Index(pc,d1.w)
; ===========================================================================
; off_104BA:
Obj18_Index:	offsetTable
		offsetTableEntry.w Obj18_Init			; 0
		offsetTableEntry.w Obj18_TopSolid		; 2
		offsetTableEntry.w Obj18_Delete			; 4
		offsetTableEntry.w Obj18_NonSolid		; 6
		offsetTableEntry.w Obj18_FullSolid		; 8
; ===========================================================================
;word_104C4:
Obj18_InitData:
	;    width_pixels
	;	 frame
	dc.b $20, 0
	dc.b $20, 1
	dc.b $20, 2
	dc.b $40, 3
	dc.b $30, 4
; ===========================================================================
; loc_104CE:
Obj18_Init:
	addq.b	#2,routine(a0)	; => Obj18_TopSolid
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#4-1,d0			; shift subtype bits -> 000sffft
	andi.w	#%1110,d0		; remove s and high t bits
	lea	Obj18_InitData(pc,d0.w),a2	; use f bits * 2 as index
	move.b	(a2)+,width_pixels(a0)
	move.b	(a2)+,mapping_frame(a0)
	move.l	#Obj18_MapUnc_107F6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	.notMapARZ
	move.l	#Obj18_MapUnc_1084E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)

.notMapARZ:
	bsr.w	Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#4,priority(a0)
	move.w	y_pos(a0),obj18_y_actual(a0)
	move.w	y_pos(a0),obj18_y_origin(a0)
	move.w	x_pos(a0),obj18_x_origin(a0)
	move.w	#$80,angle(a0)		; overwritten by most movement types
	tst.b	subtype(a0)
	bpl.s	.topSolid
	addq.b	#6,routine(a0)	; => Obj18_FullSolid
	andi.b	#%1111,subtype(a0)	; filter t bits for use as index
	move.b	#$30,y_radius(a0)
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	.notHeightARZ
	move.b	#$28,y_radius(a0)

.notHeightARZ:
	bset	#render_flags.explicit_height,render_flags(a0)
	bra.w	Obj18_FullSolid
; ---------------------------------------------------------------------------

.topSolid:
	andi.b	#%1111,subtype(a0)	; filter t bits for use as index
	; fall through to Obj18_TopSolid
; ===========================================================================
; loc_1056A:
Obj18_TopSolid:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	.sag
	tst.b	obj18_y_offset(a0)	; has platform stopped sagging?
	beq.s	.doMovement		; if yes, branch
	subq.b	#4,obj18_y_offset(a0)	; else, rise
	bra.s	.doMovement
; ---------------------------------------------------------------------------

.sag:
	cmpi.b	#$40,obj18_y_offset(a0)	; is platform sagging enough?
	beq.s	.doMovement		; if yes, branch
	addq.b	#4,obj18_y_offset(a0)	; else, sag more

.doMovement:
	move.w	x_pos(a0),-(sp)
	bsr.w	Obj18_Move
	bsr.w	Obj18_Nudge
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	moveq	#8,d3
	move.w	(sp)+,d4
	jsrto	JmpTo_PlatformObject
	bra.s	Obj18_Despawn
; ===========================================================================
; loc_105A8:
Obj18_NonSolid:
	bsr.w	Obj18_Move
	bsr.w	Obj18_Nudge
	; fall through to Obj18_Despawn
; ===========================================================================

; loc_105B0:
Obj18_Despawn:
	tst.w	(Two_player_mode).w
	beq.s	.not2P
	bra.w	DisplaySprite
; ---------------------------------------------------------------------------

.not2P:
	; local version of MarkObjGone
	move.w	obj18_x_origin(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$80+roundToNextMultiple(screen_width,$80)+$80,d0
	bhi.s	Obj18_Delete
	bra.w	DisplaySprite
; ===========================================================================
; BranchTo3_DeleteObject:
Obj18_Delete:
	bra.w	DeleteObject
; ===========================================================================
; loc_105D4:
Obj18_FullSolid:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	.sag
	tst.b	obj18_y_offset(a0)	; has platform stopped sagging?
	beq.s	.doMovement		; if yes, branch
	subq.b	#4,obj18_y_offset(a0)	; else, rise
	bra.s	.doMovement
; ---------------------------------------------------------------------------

.sag:
	cmpi.b	#$40,obj18_y_offset(a0)	; is platform sagging enough?
	beq.s	.doMovement		; if yes, branch
	addq.b	#4,obj18_y_offset(a0)	; else, sag more

.doMovement:
	move.w	x_pos(a0),-(sp)
	bsr.w	Obj18_Move
	bsr.w	Obj18_Nudge
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	(sp)+,d4
	jsrto	JmpTo_SolidObject
	bra.s	Obj18_Despawn

; ---------------------------------------------------------------------------
; Subroutine to adjust the platform's y-positon to simulate it sagging under
; the player's weight
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1061E:
Obj18_Nudge:
	move.b	obj18_y_offset(a0),d0
	jsrto	JmpTo3_CalcSine
	move.w	#$400,d1
	muls.w	d1,d0
	swap	d0
	add.w	obj18_y_actual(a0),d0
	move.w	d0,y_pos(a0)
	rts
; End of function Obj18_Nudge


; ---------------------------------------------------------------------------
; Subroutine to handle the platform's different movement modes
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_10638:
Obj18_Move:
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#%1111,d0		; filter for t bits
	add.w	d0,d0
	move.w	Obj18_Behaviours(pc,d0.w),d1
	jmp	Obj18_Behaviours(pc,d1.w)
; End of function Obj18_Move

; ===========================================================================
; off_1064C:
Obj18_Behaviours: offsetTable
	offsetTableEntry.w Obj18_Stationary		;  0
	offsetTableEntry.w Obj18_Horizontal.normal	;  1
	offsetTableEntry.w Obj18_Vertical.normal	;  2
	offsetTableEntry.w Obj18_Falling		;  3
	offsetTableEntry.w Obj18_Fall			;  4
	offsetTableEntry.w Obj18_Horizontal.reversed	;  5
	offsetTableEntry.w Obj18_Vertical.reversed	;  6
	offsetTableEntry.w Obj18_ButtonTrigger		;  7
	offsetTableEntry.w Obj18_Rise			;  8
	offsetTableEntry.w Obj18_Stationary		;  9
	offsetTableEntry.w Obj18_ShortVertical.reversed	; $A
	offsetTableEntry.w Obj18_ShortVertical.normal	; $B
	offsetTableEntry.w Obj18_Vertical.altNormal	; $C
	offsetTableEntry.w Obj18_Vertical.altReversed	; $D
; ===========================================================================
; 0, 9 - Platform that doesn't move
; ---------------------------------------------------------------------------
; return_10668:
Obj18_Stationary:
	rts
; ===========================================================================
; 1, 5 - Horizontally moving platform
; ---------------------------------------------------------------------------
; Movement has a radius of $40
; 1 - Start at lower end of range: -$40
; 5 - Start at upper end of range: $40
; ---------------------------------------------------------------------------
; loc_1066A:
Obj18_Horizontal:
.reversed:
	move.w	obj18_x_origin(a0),d0
	move.b	angle(a0),d1
	neg.b	d1
	addi.b	#$40,d1
	bra.s	.moveX
; ---------------------------------------------------------------------------
; loc_1067A:
.normal:
	move.w	obj18_x_origin(a0),d0
	move.b	angle(a0),d1
	subi.b	#$40,d1

; loc_10686:
.moveX:
	ext.w	d1
	add.w	d1,d0
	move.w	d0,x_pos(a0)
	bra.w	Obj18_UpdateAngle
; ===========================================================================
; 2, 6, $C, $D - Vertically moving platform
; ---------------------------------------------------------------------------
; Regular movement (2, 6) has a radius of $40
; 2 - Start at lower end of range: -$40
; 6 - Start at upper end of range: $40
; ---------------------------------------------------------------------------
; Alternative movement ($C, $D) has a(n imperfect) radius of $30
; $C - Start at lower end of range: -$2F
; $D - Start at upper end of range: $2F
; ---------------------------------------------------------------------------
; loc_10692:
Obj18_Vertical:
.altReversed:
	move.w	obj18_y_origin(a0),d0
	move.b	(Oscillating_Data+$C).w,d1
	neg.b	d1
	addi.b	#$30,d1			; range: -$2F..$30
	bra.s	.moveY
; ---------------------------------------------------------------------------
; loc_106A2:
.altNormal:
	move.w	obj18_y_origin(a0),d0
	move.b	(Oscillating_Data+$C).w,d1
	subi.b	#$30,d1			; range: -$30..$2F
	bra.s	.moveY
; ---------------------------------------------------------------------------
; loc_106B0:
.reversed:
	move.w	obj18_y_origin(a0),d0
	move.b	angle(a0),d1
	neg.b	d1
	addi.b	#$40,d1
	bra.s	.moveY
; ---------------------------------------------------------------------------
; loc_106C0:
.normal:
	move.w	obj18_y_origin(a0),d0
	move.b	angle(a0),d1
	subi.b	#$40,d1

; loc_106CC:
.moveY:
	ext.w	d1
	add.w	d1,d0
	move.w	d0,obj18_y_actual(a0)
	bra.w	Obj18_UpdateAngle
; ===========================================================================
; 3 - Platform will drop half a second after it is stood on
; ---------------------------------------------------------------------------
; loc_106D8:
Obj18_Falling:
	tst.w	obj18_delay(a0)		; has timer been set?
	bne.s	.countdown		; if yes, branch
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	.return
	move.w	#30,obj18_delay(a0)	; set drop timer

.return:
	rts
; ---------------------------------------------------------------------------
; loc_106F0:
.countdown:
	subq.w	#1,obj18_delay(a0)
	bne.s	.return
	move.w	#$20,obj18_delay(a0)	; start timer
	addq.b	#1,subtype(a0)	; => Obj18_Fall
	rts
; ===========================================================================
; 4 - Platform as it is falling
; ---------------------------------------------------------------------------
; Will drop players after half a second, which translates into $5F pixels
; below the platform's initial position
; ---------------------------------------------------------------------------
; loc_10702:
Obj18_Fall:
	tst.w	obj18_delay(a0)
	beq.s	.moveY
	subq.w	#1,obj18_delay(a0)
	bne.s	.moveY
	bclr	#p1_standing_bit,status(a0)
	beq.s	.noP1
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	Obj18_DropPlayer

.noP1:
	bclr	#p2_standing_bit,status(a0)
	beq.s	.noP2
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	Obj18_DropPlayer

.noP2:
	move.b	#6,routine(a0)	; => Obj18_NonSolid

; loc_10730:
.moveY:
	move.l	obj18_y_actual(a0),d3
	move.w	y_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d3,obj18_y_actual(a0)
	addi.w	#$38,y_vel(a0)
	move.w	(Camera_Max_Y_pos).w,d0
	addi.w	#screen_height+$40,d0
	cmp.w	obj18_y_actual(a0),d0
	bhs.s	.return
	move.b	#4,routine(a0)	; => Obj18_Delete

.return:
	rts

; ---------------------------------------------------------------------------
; Subroutine to detach the player from the falling platform and transfer its
; downward velocity
; Input:
;	a1	Address to player object
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1075E:
Obj18_DropPlayer:
	bset	#status.player.in_air,status(a1)
	bclr	#status.player.on_object,status(a1)
	move.b	#2,routine(a1)
	move.w	y_vel(a0),y_vel(a1)
	rts
; End of function Obj18_DropPlayer

; ===========================================================================
; 7 - Platform will rise one second after a button is pressed
; ---------------------------------------------------------------------------
; Leftover from S1. The subtype bits used to determine the button ID are
; cleared during init, but would also conflict with the frame/width and
; solidity selection. As a result, this platform type can respond to only
; button ID 0
; ---------------------------------------------------------------------------
; loc_10778:
Obj18_ButtonTrigger:
	tst.w	obj18_delay(a0)		; has timer been set?
	bne.s	.countdown		; if yes, branch
	lea	(ButtonVine_Trigger).w,a2
	moveq	#0,d0
	move.b	subtype(a0),d0		; high nybble determines the button ID
	lsr.w	#4,d0			; d0 = button ID
	tst.b	(a2,d0.w)
	beq.s	.return
	move.w	#60,obj18_delay(a0)	; start timer

.return:
	rts
; ---------------------------------------------------------------------------
; loc_10798:
.countdown:
	subq.w	#1,obj18_delay(a0)
	bne.s	.return
	addq.b	#1,subtype(a0)	; => Obj18_Rise
	rts
; ===========================================================================
; 8 - Platform as it is rising
; ---------------------------------------------------------------------------
; Will stop $200 pixels above its initial position
; ---------------------------------------------------------------------------
; loc_107A4:
Obj18_Rise:
	subq.w	#2,obj18_y_actual(a0)
	move.w	obj18_y_origin(a0),d0
	subi.w	#$200,d0		; target is $200 above start position
	cmp.w	obj18_y_actual(a0),d0	; is target reached?
	bne.s	.return			; if not, branch
	clr.b	subtype(a0)	; => Obj18_Stationary

.return:
	rts
; ===========================================================================
; $A, $B - Vertically moving platform with smaller movement range
; ---------------------------------------------------------------------------
; Movement has a radius of $20
; $A - Start at lower end of range: -$20
; $B - Start at upper end of range: $20
; ---------------------------------------------------------------------------
; loc_107BC:
Obj18_ShortVertical:
.reversed:
	move.w	obj18_y_origin(a0),d0
	move.b	angle(a0),d1
	subi.b	#$40,d1
	ext.w	d1
	asr.w	#1,d1
	add.w	d1,d0
	move.w	d0,obj18_y_actual(a0)
	bra.w	Obj18_UpdateAngle
; ---------------------------------------------------------------------------
; loc_107D6:
.normal:
	move.w	obj18_y_origin(a0),d0
	move.b	angle(a0),d1
	neg.b	d1
	addi.b	#$40,d1
	ext.w	d1
	asr.w	#1,d1
	add.w	d1,d0
	move.w	d0,obj18_y_actual(a0)
	; fall through to Obj18_UpdateAngle
; ===========================================================================
; loc_107EE:
Obj18_UpdateAngle:
	move.b	(Oscillating_Data+$18).w,angle(a0)	; range: 0..$80
	rts