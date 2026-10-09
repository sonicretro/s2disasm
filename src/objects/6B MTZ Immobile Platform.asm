; ---------------------------------------------------------------------------
; Object 6B - Immobile platform from MTZ
; ---------------------------------------------------------------------------
; subtype bits: .ffftttt
; t = platform behavior (see Obj6B_Types)
; f = sprite frame and width (indexes Obj6B_Properties)
; ---------------------------------------------------------------------------
; Some movement types use status.npc.x_flip to determine movement direction
; ---------------------------------------------------------------------------
obj6B_base_flip		= objoff_2E ; byte
obj6B_y_origin		= objoff_30 ; word
obj6B_x_origin		= objoff_34 ; word
obj6B_acceleration	= objoff_38 ; byte

; Sprite_27D6C:
Obj6B:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj6B_Index(pc,d0.w),d1
	jmp	Obj6B_Index(pc,d1.w)
; ===========================================================================
; off_27D7A:
Obj6B_Index:	offsetTable
		offsetTableEntry.w Obj6B_Init	; 0
		offsetTableEntry.w Obj6B_Main	; 2
; ===========================================================================
obj6B_properties macro width,height,mappingFrame
	dc.b width, height, mappingFrame, 0
    endm

; byte_27D7E:
Obj6B_Properties:
	obj6B_properties  32, 12, 1
	obj6B_properties  16, 16, 0
; ===========================================================================
; loc_27D86:
Obj6B_Init:
	addq.b	#2,routine(a0)	; => Obj6B_Main
	move.l	#Obj65_Obj6A_Obj6B_MapUnc_26EC8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,3,0),art_tile(a0)
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	bne.s	.notCPZ
	move.l	#Obj6B_MapUnc_2800E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,0),art_tile(a0)

.notCPZ:
	jsrto	JmpTo34_Adjust2PArtPointer
	move.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#3,priority(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0		; get sprite frame bits (.fff....)
	lsr.w	#4-2,d0			; ... shift into place for f*4...
	andi.w	#%11100,d0		; ... remove other bits to index table
	lea	Obj6B_Properties(pc,d0.w),a2
	move.b	(a2)+,width_pixels(a0)
	move.b	(a2)+,y_radius(a0)
	move.b	(a2)+,mapping_frame(a0)
	move.w	x_pos(a0),obj6B_x_origin(a0)
	move.w	y_pos(a0),obj6B_y_origin(a0)
	move.b	status(a0),obj6B_base_flip(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#%1111,d0
	subq.w	#8,d0			; is it one of the Obj6B_Stair types?
	bcs.s	Obj6B_Main		; if not, branch
	lsl.w	#2,d0
	lea	(Oscillating_Data+$2A).w,a2
	lea	(a2,d0.w),a2
	tst.w	(a2)
	bpl.s	Obj6B_Main
	bchg	#status.npc.x_flip,obj6B_base_flip(a0)
; loc_27E0E:
Obj6B_Main:
	move.w	x_pos(a0),-(sp)
	moveq	#0,d0
	move.b	subtype(a0),d0		; get behavior bits (....mmmm)
	andi.w	#%1111,d0		; ... remove other bits...
	add.w	d0,d0			; ... and scale to m*2 to index table
	move.w	Obj6B_Types(pc,d0.w),d1
	jsr	Obj6B_Types(pc,d1.w)
	move.w	(sp)+,d4
	_btst	#render_flags.on_screen,render_flags(a0)
	_beq.s	.offScreen
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	JmpTo14_SolidObject

.offScreen:
	move.w	obj6B_x_origin(a0),d0
	jmpto	JmpTo4_MarkObjGone2
; ===========================================================================
; off_27E4E:
Obj6B_Types:	offsetTable
	offsetTableEntry.w Obj6B_Type_Immobile		;  0
	offsetTableEntry.w Obj6B_Horizontal		;  1
	offsetTableEntry.w Obj6B_Horizontal.long	;  2
	offsetTableEntry.w Obj6B_Vertical		;  3
	offsetTableEntry.w Obj6B_Vertical.long		;  4
	offsetTableEntry.w Obj6B_Sinking		;  5
	offsetTableEntry.w Obj6B_Sink			;  6
	offsetTableEntry.w Obj6B_Descend		;  7
	offsetTableEntry.w Obj6B_Stair.smallest		;  8
	offsetTableEntry.w Obj6B_Stair.small		;  9
	offsetTableEntry.w Obj6B_Stair.large		; $A
	offsetTableEntry.w Obj6B_Stair.largest		; $B
; ===========================================================================
; 0 - Platform that doesn't move
; ---------------------------------------------------------------------------
; return_27E66:
Obj6B_Type_Immobile:
	rts
; ===========================================================================
; 1 - Horizontally moving platform, small range
; ---------------------------------------------------------------------------
; Movement has a(n imperfect) range of $40
; !status.npc.x_flip - Move between -$3F and 0, starting at 0
;  status.npc.x_flip - Move between -$40 and -1, starting at -$40
; ---------------------------------------------------------------------------
; loc_27E68:
Obj6B_Horizontal:
	move.w	#$40,d1				; assume a range of $40
	moveq	#0,d0
	move.b	(Oscillating_Data+8).w,d0	; range: 0..$3F
	bra.s	.moveX
; ===========================================================================
; 2 - Horizontally moving platform, large range
; ---------------------------------------------------------------------------
; Movement has a(n imperfect) range of $80
; !status.npc.x_flip - Move between -$7F and 0, starting at 0
;  status.npc.x_flip - Move between -$80 and -1, starting at -$80
; ---------------------------------------------------------------------------
; loc_27E74:
.long:
	move.w	#$80,d1				; assume a range of $80
	moveq	#0,d0
	move.b	(Oscillating_Data+$1C).w,d0	; range: 0..$7F

.moveX:
	btst	#status.npc.x_flip,status(a0)
	beq.s	.notReverse
	neg.w	d0				; flip range
	add.w	d1,d0				; ''

.notReverse:
	move.w	obj6B_x_origin(a0),d1
	sub.w	d0,d1
	move.w	d1,x_pos(a0)
	rts
; ===========================================================================
; 3 - Vertically moving platform, small range
; ---------------------------------------------------------------------------
; Movement has a(n imperfect) range of $40
; !status.npc.x_flip - Move between -$3F and 0, starting at 0
;  status.npc.x_flip - Move between -$40 and -1, starting at -$40
; ---------------------------------------------------------------------------
; loc_27E96:
Obj6B_Vertical:
	move.w	#$40,d1				; assume a range of $40
	moveq	#0,d0
	move.b	(Oscillating_Data+8).w,d0	; range: 0..$3F
	bra.s	.moveY
; ===========================================================================
; 4 - Vertically moving platform, large range
; ---------------------------------------------------------------------------
; Movement has a(n imperfect) range of $80
; !status.npc.x_flip - Move between -$7F and 0, starting at 0
;  status.npc.x_flip - Move between -$80 and -1, starting at -$80
; ---------------------------------------------------------------------------
; loc_27EA2:
.long:
	move.w	#$80,d1				; assume a range of $80
	moveq	#0,d0
	move.b	(Oscillating_Data+$1C).w,d0	; range: 0..$7F

; loc_27EAC:
.moveY:
	btst	#status.npc.x_flip,status(a0)
	beq.s	.notReverse
	neg.w	d0				; flip range
	add.w	d1,d0				; ''

; loc_27EB8:
.notReverse:
	move.w	obj6B_y_origin(a0),d1
	sub.w	d0,d1
	move.w	d1,y_pos(a0)
	rts
; ===========================================================================
; 5 - Platform that sinks once stood on
; ---------------------------------------------------------------------------
; loc_27EC4:
Obj6B_Sinking:
	move.b	(Oscillating_Data).w,d0		; range: 0..$1F
	lsr.w	#1,d0				; range: 0..$F
	add.w	obj6B_y_origin(a0),d0		; bob on top of the lava
	move.w	d0,y_pos(a0)			; ''
	move.b	status(a0),d1
	andi.b	#standing_mask,d1
	beq.s	.return
	addq.b	#1,subtype(a0)	; => Obj6B_Sink

; return_27EE0:
.return:
	rts
; ===========================================================================
; 6 - Platform as it is sinking
; ---------------------------------------------------------------------------
; Platform accelerates downward until it goes under the level's lower
; boundary*, then stops.
; * This doesn't work as intended in MTZ due to the screen wrapping. The
; platform can sometimes loop around and eventually come to a stop somewhere
; above its starting position.
; ---------------------------------------------------------------------------
; loc_27EE2:
Obj6B_Sink:
	move.l	y_pos(a0),d3
	move.w	y_vel(a0),d0		; align velocity with position
	ext.l	d0			; ''
	asl.l	#8,d0			; ''
	add.l	d0,d3			; apply velocity
	move.l	d3,y_pos(a0)		; ''
	addi_.w	#8,y_vel(a0)
	; this check was likey adapted from Obj18, but doesn't work right with
	; MTZ's screen wrapping
	move.w	(Camera_Max_Y_pos).w,d0
	addi.w	#screen_height,d0
	cmp.w	y_pos(a0),d0
	bhs.s	.return
	move.b	#0,subtype(a0)	; => Obj6B_Type_Immobile

; return_27F0E:
.return:
	rts
; ===========================================================================
; 7 - Platform that descends once stood on, accelerating towards its halfway
; point, then decelerating to ease into its destination.
; The destination is $E1 units below its starting point.
; ---------------------------------------------------------------------------
; __
;   \
;    \ <-- inflection point
;     \__ <-- stationary point
;
; ---------------------------------------------------------------------------
; loc_27F10:
Obj6B_Descend:
	tst.b	obj6B_acceleration(a0)	; has movement started?
	bne.s	.moveY			; if yes, branch
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	.return
	move.b	#8,obj6B_acceleration(a0)

; loc_27F26:
.moveY:
	jsrto	JmpTo14_ObjectMove
	andi.w	#$7FF,y_pos(a0)		; wrap position
	cmpi.w	#$2A8,y_vel(a0)		; has curve reached inflection point?
	bne.s	.accelerate		; if not, branch
	neg.b	obj6B_acceleration(a0)	; reverse curvature's sign

; loc_27F3C:
.accelerate:
	move.b	obj6B_acceleration(a0),d1
	ext.w	d1
	add.w	d1,y_vel(a0)
	bne.s	.return		; branch, if stationary point isn't reached
	clr.b	subtype(a0)	; => Obj6B_Type_Immobile

; return_27F4C:
.return:
	rts
; ===========================================================================
; 8 - Block used to construct a rotating stairway. Follows a square path
; clockwise around its origin point.
; This subtype uses a radius of $10.
; ---------------------------------------------------------------------------
; loc_27F4E:
Obj6B_Stair:
.smallest:
	move.w	#$10,d1				; assume a radius of $10
	moveq	#0,d0
	move.b	(Oscillating_Data+$28).w,d0	; range 0..$3F
	lsr.w	#1,d0				; scale to 0..$1F
	move.w	(Oscillating_Data+$2A).w,d3
	bra.s	.tstCorner
; ===========================================================================
; 9 - Block used to construct a rotating stairway. Follows a square path
; clockwise around its origin point.
; This subtype uses a radius of $30.
; ---------------------------------------------------------------------------
; loc_27F60:
.small:
	move.w	#$30,d1				; assume a radius of $30
	moveq	#0,d0
	move.b	(Oscillating_Data+$2C).w,d0	; range 0..$5F
	move.w	(Oscillating_Data+$2E).w,d3
	bra.s	.tstCorner
; ===========================================================================
; $A - Block used to construct a rotating stairway. Follows a square path
; clockwise around its origin point.
; This subtype uses a radius of $50. Left over from S1, but unused here.
; ---------------------------------------------------------------------------
; loc_27F70:
.large:
	move.w	#$50,d1				; assume a radius of $50
	moveq	#0,d0
	move.b	(Oscillating_Data+$30).w,d0	; range 0..$9E
	move.w	(Oscillating_Data+$32).w,d3
	bra.s	.tstCorner
; ===========================================================================
; $B - Block used to construct a rotating stairway. Follows a square path
; clockwise around its origin point.
; This subtype uses a radius of $70. Left over from S1, but unused here.
; ---------------------------------------------------------------------------
; loc_27F80:
.largest:
	move.w	#$70,d1				; assume a radius of $70
	moveq	#0,d0
	move.b	(Oscillating_Data+$34).w,d0	; range 0..$DE
	move.w	(Oscillating_Data+$36).w,d3

; loc_27F8E:
.tstCorner:
	tst.w	d3			; has stair block reached a corner?
	bne.s	.moveBlock		; if not, branch
	; When the oscillator reaches a stationary point, that means
	; the stair block has reached a corner and needs to change its
	; movement direction, which is acheived by changing the flip flags.
	addq.b	#1<<status.npc.x_flip,obj6B_base_flip(a0)
	andi.b	#1<<status.npc.x_flip|1<<status.npc.y_flip,obj6B_base_flip(a0)

; loc_27F9C:
.moveBlock:
	move.b	obj6B_base_flip(a0),d2
	andi.b	#1<<status.npc.x_flip|1<<status.npc.y_flip,d2
	bne.s	.topToBottom

; ===========================================================================
; Case ~~y_flip && ~~x_flip
; ---------------------------------------------------------------------------
; Move x_pos from -radius to +radius, oscillator is counting up
; Offset y_pos by -radius
; ---------------------------------------------------------------------------
;.leftToRight:
	sub.w	d1,d0				; offset range by radius...
	add.w	obj6B_x_origin(a0),d0		; ... center around origin...
	move.w	d0,x_pos(a0)			; ... and move horizontally
	neg.w	d1				; use -radius for y position
	add.w	obj6B_y_origin(a0),d1		; ''
	move.w	d1,y_pos(a0)			; ''
	rts
; ===========================================================================
; Case ~~y_flip && x_flip
; ---------------------------------------------------------------------------
; Move y_pos from -radius to +radius, oscillator is counting down
; Offset x_pos by +radius
; ---------------------------------------------------------------------------
; loc_27FBC:
.topToBottom:
	subq.b	#1,d2
	bne.s	.rightToLeft
	subq.w	#1,d1			; account for range being off by 1
	sub.w	d1,d0				; offset range by radius...
	neg.w	d0				; ... reverse motion...
	add.w	obj6B_y_origin(a0),d0		; ... center around origin...
	move.w	d0,y_pos(a0)			; ... and move vertically
	addq.w	#1,d1				; undo change to radius
	add.w	obj6B_x_origin(a0),d1		; use radius for x position
	move.w	d1,x_pos(a0)			; ''
	rts
; ===========================================================================
; Case y_flip && ~~x_flip
; ---------------------------------------------------------------------------
; Move x_pos from +radius to -radius, oscillator is counting up
; Offset y_pos by +radius
; ---------------------------------------------------------------------------
; loc_27FDA:
.rightToLeft:
	subq.b	#1,d2
	bne.s	.bottomToTop
	subq.w	#1,d1			; account for range being off by 1
	sub.w	d1,d0				; offset range by radius...
	neg.w	d0				; ... reverse motion...
	add.w	obj6B_x_origin(a0),d0		; ... center around origin...
	move.w	d0,x_pos(a0)			; ... and move horizontally
	addq.w	#1,d1				; undo change to radius
	add.w	obj6B_y_origin(a0),d1		; use radius for y position
	move.w	d1,y_pos(a0)			; ''
	rts
; ===========================================================================
; Case y_flip && x_flip
; ---------------------------------------------------------------------------
; Move y_pos from +radius to -radius, oscillator is counting down
; Offset x_pos by -radius
; ---------------------------------------------------------------------------
; loc_27FF8:
.bottomToTop:
	sub.w	d1,d0				; offset range by radius...
	add.w	obj6B_y_origin(a0),d0		; ... center around origin...
	move.w	d0,y_pos(a0)			; ... and move vertically
	neg.w	d1				; use -radius for x position
	add.w	obj6B_x_origin(a0),d1		; ''
	move.w	d1,x_pos(a0)			; ''
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
Obj6B_MapUnc_2800E:	include "mappings/sprite/obj6B.asm"
; ===========================================================================


; ===========================================================================
