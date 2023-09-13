; ===========================================================================
; ----------------------------------------------------------------------------
; Object 28 - Animal and the 100 points from a badnik
; ----------------------------------------------------------------------------
animal_ground_routine_base = objoff_30
animal_ground_x_vel = objoff_32
animal_ground_y_vel = objoff_34
; Sprite_1188C:
Obj28:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj28_Index(pc,d0.w),d1
	jmp	Obj28_Index(pc,d1.w)
; ===========================================================================
; off_1189A:
Obj28_Index:	offsetTable
		offsetTableEntry.w Obj28_Init	;   0
		offsetTableEntry.w Obj28_Main	;   2
		offsetTableEntry.w Obj28_Walk	;   4
		offsetTableEntry.w Obj28_Fly	;   6
		offsetTableEntry.w Obj28_Walk	;   8
		offsetTableEntry.w Obj28_Walk	;  $A
		offsetTableEntry.w Obj28_Walk	;  $C
		offsetTableEntry.w Obj28_Fly	;  $E
		offsetTableEntry.w Obj28_Walk	; $10
		offsetTableEntry.w Obj28_Fly	; $12
		offsetTableEntry.w Obj28_Walk	; $14
		offsetTableEntry.w Obj28_Walk	; $16
		offsetTableEntry.w Obj28_Walk	; $18
		offsetTableEntry.w Obj28_Walk	; $1A
		offsetTableEntry.w Obj28_Prison	; $1C
		; These are the S1 ending actions:
		offsetTableEntry.w Obj28_FlickyWait	; $1E
		offsetTableEntry.w Obj28_FlickyWait	; $20
		offsetTableEntry.w Obj28_FlickyJump	; $22
		offsetTableEntry.w Obj28_RabbitWait	; $24
		offsetTableEntry.w Obj28_LandJump	; $26
		offsetTableEntry.w Obj28_SingleBounce	; $28
		offsetTableEntry.w Obj28_LandJump	; $2A
		offsetTableEntry.w Obj28_SingleBounce	; $2C
		offsetTableEntry.w Obj28_LandJump	; $2E
		offsetTableEntry.w Obj28_FlyBounce	; $30
		offsetTableEntry.w Obj28_DoubleBounce	; $32

; byte_118CE:
Obj28_ZoneAnimals:	zoneOrderedTable 1,2

zoneAnimals macro first,second
	zoneTableEntry.b (Obj28_Properties_first - Obj28_Properties) / 8
	zoneTableEntry.b (Obj28_Properties_second - Obj28_Properties) / 8
    endm
	; This table declares what animals will appear in the zone.
	; When an enemy is destroyed, a random animal is chosen from the 2 selected animals.
	; Note: you must also load the corresponding art in the PLCs.
	zoneAnimals.b Squirrel,	Flicky	; EHZ
	zoneAnimals.b Squirrel,	Flicky	; Zone 1
	zoneAnimals.b Squirrel,	Flicky	; WZ
	zoneAnimals.b Squirrel,	Flicky	; Zone 3
	zoneAnimals.b Monkey,	Eagle	; MTZ1,2
	zoneAnimals.b Monkey,	Eagle	; MTZ3
	zoneAnimals.b Monkey,	Eagle	; WFZ
	zoneAnimals.b Monkey,	Eagle	; HTZ
	zoneAnimals.b Mouse,	Seal	; HPZ
	zoneAnimals.b Mouse,	Seal	; Zone 9
	zoneAnimals.b Penguin,	Seal	; OOZ
	zoneAnimals.b Mouse,	Chicken	; MCZ
	zoneAnimals.b Bear,	Flicky	; CNZ
	zoneAnimals.b Rabbit,	Eagle	; CPZ
	zoneAnimals.b Pig,	Chicken	; DEZ
	zoneAnimals.b Penguin,	Flicky	; ARZ
	zoneAnimals.b Turtle,	Chicken	; SCZ
    zoneTableEnd

; word_118F0:
Obj28_Properties:

obj28decl macro	xvel,yvel,mappings,{INTLABEL}
Obj28_Properties___LABEL__: label *
	dc.w xvel
	dc.w yvel
	dc.l mappings
    endm
		; This table declares the speed and mappings of each animal.
Rabbit:		obj28decl -$200,-$400,Obj28_MapUnc_11EAC
Chicken:	obj28decl -$200,-$300,Obj28_MapUnc_11E1C
Penguin:	obj28decl -$180,-$300,Obj28_MapUnc_11EAC
Seal:		obj28decl -$140,-$180,Obj28_MapUnc_11E88
Pig:		obj28decl -$1C0,-$300,Obj28_MapUnc_11E64
Flicky:		obj28decl -$300,-$400,Obj28_MapUnc_11E1C
Squirrel:	obj28decl -$280,-$380,Obj28_MapUnc_11E40
Eagle:		obj28decl -$280,-$300,Obj28_MapUnc_11E1C
Mouse:		obj28decl -$200,-$380,Obj28_MapUnc_11E40
Monkey:		obj28decl -$2C0,-$300,Obj28_MapUnc_11E40
Turtle:		obj28decl -$140,-$200,Obj28_MapUnc_11E40
Bear:		obj28decl -$200,-$300,Obj28_MapUnc_11E40

	; The following tables tell the properties of animals based on their subtype.

; word_11950:
Obj28_Speeds:
	dc.w -$440, -$400
	dc.w -$440, -$400	; 2
	dc.w -$440, -$400	; 4
	dc.w -$300, -$400	; 6
	dc.w -$300, -$400	; 8
	dc.w -$180, -$300	; 10
	dc.w -$180, -$300	; 12
	dc.w -$140, -$180	; 14
	dc.w -$1C0, -$300	; 16
	dc.w -$200, -$300	; 18
	dc.w -$280, -$380	; 20
; off_1197C:
Obj28_Mappings:
	dc.l Obj28_MapUnc_11E1C
	dc.l Obj28_MapUnc_11E1C	; 1
	dc.l Obj28_MapUnc_11E1C	; 2
	dc.l Obj28_MapUnc_11EAC	; 3
	dc.l Obj28_MapUnc_11EAC	; 4
	dc.l Obj28_MapUnc_11EAC	; 5
	dc.l Obj28_MapUnc_11EAC	; 6
	dc.l Obj28_MapUnc_11E88	; 7
	dc.l Obj28_MapUnc_11E64	; 8
	dc.l Obj28_MapUnc_11E1C	; 9
	dc.l Obj28_MapUnc_11E40	; 10
; word_119A8:
Obj28_ArtLocations:
	dc.w  ArtTile_ArtNem_S1EndFlicky	;  0	Flicky
	dc.w  ArtTile_ArtNem_S1EndFlicky	;  1	Flicky
	dc.w  ArtTile_ArtNem_S1EndFlicky	;  2	Flicky
	dc.w  ArtTile_ArtNem_S1EndRabbit	;  3	Rabbit
	dc.w  ArtTile_ArtNem_S1EndRabbit	;  4	Rabbit
	dc.w  ArtTile_ArtNem_S1EndPenguin	;  5	Penguin
	dc.w  ArtTile_ArtNem_S1EndPenguin	;  6	Penguin
	dc.w  ArtTile_ArtNem_S1EndSeal		;  7	Seal
	dc.w  ArtTile_ArtNem_S1EndPig		;  8	Pig
	dc.w  ArtTile_ArtNem_S1EndChicken	;  9	Chicken
	dc.w  ArtTile_ArtNem_S1EndSquirrel	; 10	Squirrel

; ===========================================================================
; loc_119BE:
Obj28_Init:
	tst.b	subtype(a0)
	beq.w	Obj28_InitRandom
	moveq	#0,d0
	move.b	subtype(a0),d0
	add.w	d0,d0
	move.b	d0,routine(a0)
	subi.w	#$14,d0
	move.w	Obj28_ArtLocations(pc,d0.w),art_tile(a0)
	add.w	d0,d0
	move.l	Obj28_Mappings(pc,d0.w),mappings(a0)
	lea	Obj28_Speeds(pc),a1
	move.w	(a1,d0.w),animal_ground_x_vel(a0)
	move.w	(a1,d0.w),x_vel(a0)
	move.w	2(a1,d0.w),animal_ground_y_vel(a0)
	move.w	2(a1,d0.w),y_vel(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$C,y_radius(a0)
	move.b	#4,render_flags(a0)
	bset	#0,render_flags(a0)
	move.b	#6,priority(a0)
	move.b	#8,width_pixels(a0)
	move.b	#7,anim_frame_duration(a0)
	bra.w	DisplaySprite
; ===========================================================================
; loc_11A2C:
Obj28_InitRandom:
	addq.b	#2,routine(a0)
	jsrto	RandomNumber, JmpTo_RandomNumber
	move.w	#make_art_tile(ArtTile_ArtNem_Animal_1,0,0),art_tile(a0)
	andi.w	#1,d0
	beq.s	+
	move.w	#make_art_tile(ArtTile_ArtNem_Animal_2,0,0),art_tile(a0)
+
	moveq	#0,d1
	move.b	(Current_Zone).w,d1
	add.w	d1,d1
	add.w	d0,d1
	lea	Obj28_ZoneAnimals(pc),a1
	move.b	(a1,d1.w),d0
	move.b	d0,animal_ground_routine_base(a0)
	lsl.w	#3,d0
	lea	Obj28_Properties(pc),a1
	adda.w	d0,a1
	move.w	(a1)+,animal_ground_x_vel(a0)
	move.w	(a1)+,animal_ground_y_vel(a0)
	move.l	(a1)+,mappings(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$C,y_radius(a0)
	move.b	#4,render_flags(a0)
	bset	#0,render_flags(a0)
	move.b	#6,priority(a0)
	move.b	#8,width_pixels(a0)
	move.b	#7,anim_frame_duration(a0)
	move.b	#2,mapping_frame(a0)
	move.w	#-$400,y_vel(a0)
	tst.b	objoff_38(a0)
	bne.s	++
	bsr.w	AllocateObject
	bne.s	+
	_move.b	#ObjID_Points,id(a1) ; load obj29
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	objoff_3E(a0),d0
	lsr.w	#1,d0
	move.b	d0,mapping_frame(a1)
+	bra.w	DisplaySprite
; ===========================================================================
+
	move.b	#$1C,routine(a0)
	clr.w	x_vel(a0)
	bra.w	DisplaySprite
; ===========================================================================
;loc_11ADE
Obj28_Main:
	tst.b	render_flags(a0)
	bpl.w	DeleteObject
	bsr.w	ObjectMoveAndFall
	tst.w	y_vel(a0)
	bmi.s	+
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	+
	add.w	d1,y_pos(a0)
	move.w	animal_ground_x_vel(a0),x_vel(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
	move.b	#1,mapping_frame(a0)
	move.b	animal_ground_routine_base(a0),d0
	add.b	d0,d0
	addq.b	#4,d0
	move.b	d0,routine(a0)
	tst.b	objoff_38(a0)
	beq.s	+
	btst	#4,(Vint_runcount+3).w
	beq.s	+
	neg.w	x_vel(a0)
	bchg	#0,render_flags(a0)
+	bra.w	DisplaySprite
; ===========================================================================
;loc_11B38
Obj28_Walk:

	bsr.w	ObjectMoveAndFall
	move.b	#1,mapping_frame(a0)
	tst.w	y_vel(a0)
	bmi.s	+
	move.b	#0,mapping_frame(a0)
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	+
	add.w	d1,y_pos(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
+
	tst.b	subtype(a0)
	bne.s	Obj28_ChkDel
	tst.b	render_flags(a0)
	bpl.w	DeleteObject
	bra.w	DisplaySprite
; ===========================================================================
;loc_11B74
Obj28_Fly:
	bsr.w	ObjectMove
	addi.w	#$18,y_vel(a0)
	tst.w	y_vel(a0)
	bmi.s	+
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	+
	add.w	d1,y_pos(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
	tst.b	subtype(a0)
	beq.s	+
	cmpi.b	#$A,subtype(a0)
	beq.s	+
	neg.w	x_vel(a0)
	bchg	#0,render_flags(a0)
+
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#1,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	andi.b	#1,mapping_frame(a0)
+
	tst.b	subtype(a0)
	bne.s	Obj28_ChkDel
	tst.b	render_flags(a0)
	bpl.w	DeleteObject
	bra.w	DisplaySprite
; ===========================================================================
;loc_11BD8
Obj28_ChkDel:
	move.w	x_pos(a0),d0
	sub.w	(MainCharacter+x_pos).w,d0
	bcs.s	+
	subi.w	#$180,d0
	bpl.s	+
	tst.b	render_flags(a0)
	bpl.w	DeleteObject
+
	bra.w	DisplaySprite
; ===========================================================================
;loc_11BF4
Obj28_Prison:
	tst.b	render_flags(a0)
	bpl.w	DeleteObject
	subq.w	#1,objoff_36(a0)
	bne.w	+
	move.b	#2,routine(a0)
	move.b	#1,priority(a0)
+
	bra.w	DisplaySprite
; ===========================================================================
;loc_11C14
Obj28_FlickyWait:
	bsr.w	ChkAnimalInRange
	bcc.s	+
	move.w	animal_ground_x_vel(a0),x_vel(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
	move.b	#$E,routine(a0)
	bra.w	Obj28_Fly
; ===========================================================================
+
	bra.w	Obj28_ChkDel
; ===========================================================================
;loc_11C34
Obj28_FlickyJump:
	bsr.w	ChkAnimalInRange
	bpl.s	+
	clr.w	x_vel(a0)
	clr.w	animal_ground_x_vel(a0)
	bsr.w	ObjectMove
	addi.w	#$18,y_vel(a0)
	bsr.w	AnimalJump
	bsr.w	AnimalFaceSonic
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#1,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	andi.b	#1,mapping_frame(a0)
+
	bra.w	Obj28_ChkDel
; ===========================================================================
;loc_11C6E
Obj28_RabbitWait:
	bsr.w	ChkAnimalInRange
	bpl.s	++
	move.w	animal_ground_x_vel(a0),x_vel(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
	move.b	#4,routine(a0)
	bra.w	Obj28_Walk
; ===========================================================================
;loc_11C8A
Obj28_DoubleBounce:
	bsr.w	ObjectMoveAndFall
	move.b	#1,mapping_frame(a0)
	tst.w	y_vel(a0)
	bmi.s	++
	move.b	#0,mapping_frame(a0)
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	++
	not.b	objoff_29(a0)
	bne.s	+
	neg.w	x_vel(a0)
	bchg	#0,render_flags(a0)
+
	add.w	d1,y_pos(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
+
	bra.w	Obj28_ChkDel
; ===========================================================================
;loc_11CC8
Obj28_LandJump:
	bsr.w	ChkAnimalInRange
	bpl.s	+
	clr.w	x_vel(a0)
	clr.w	animal_ground_x_vel(a0)
	bsr.w	ObjectMoveAndFall
	bsr.w	AnimalJump
	bsr.w	AnimalFaceSonic
+
	bra.w	Obj28_ChkDel
; ===========================================================================
;loc_11CE6
Obj28_SingleBounce:
	bsr.w	ChkAnimalInRange
	bpl.s	+
	bsr.w	ObjectMoveAndFall
	move.b	#1,mapping_frame(a0)
	tst.w	y_vel(a0)
	bmi.s	+
	move.b	#0,mapping_frame(a0)
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	+
	neg.w	x_vel(a0)
	bchg	#0,render_flags(a0)
	add.w	d1,y_pos(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
+
	bra.w	Obj28_ChkDel
; ===========================================================================
;loc_11D24
Obj28_FlyBounce:
	bsr.w	ChkAnimalInRange
	bpl.s	+++
	bsr.w	ObjectMove
	addi.w	#$18,y_vel(a0)
	tst.w	y_vel(a0)
	bmi.s	++
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	++
	not.b	objoff_29(a0)
	bne.s	+
	neg.w	x_vel(a0)
	bchg	#0,render_flags(a0)
+
	add.w	d1,y_pos(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
+
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#1,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	andi.b	#1,mapping_frame(a0)
+
	bra.w	Obj28_ChkDel

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_11D78
AnimalJump:
	move.b	#1,mapping_frame(a0)
	tst.w	y_vel(a0)
	bmi.s	+	; rts
	move.b	#0,mapping_frame(a0)
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	+	; rts
	add.w	d1,y_pos(a0)
	move.w	animal_ground_y_vel(a0),y_vel(a0)
+
	rts
; End of function AnimalJump


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_11DA0
AnimalFaceSonic:
	bset	#0,render_flags(a0)
	move.w	x_pos(a0),d0
	sub.w	(MainCharacter+x_pos).w,d0
	bcc.s	+	; rts
	bclr	#0,render_flags(a0)
+
	rts
; End of function AnimalFaceSonic


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_11DB8
ChkAnimalInRange:
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	x_pos(a0),d0
	subi.w	#$B8,d0
	rts
; End of function ChkAnimalInRange

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 29 - "100 points" text
; ----------------------------------------------------------------------------
; Sprite_11DC6:
Obj29:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj29_Index(pc,d0.w),d1
	jmp	Obj29_Index(pc,d1.w)
; ===========================================================================
; off_11DD4:
Obj29_Index:	offsetTable
		offsetTableEntry.w Obj29_Init	; 0
		offsetTableEntry.w Obj29_Main	; 2
; ===========================================================================

Obj29_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj29_MapUnc_11ED0,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Numbers,0,1),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#1,priority(a0)
	move.b	#8,width_pixels(a0)
	move.w	#-$300,y_vel(a0)	; set initial speed (upwards)

Obj29_Main:
	tst.w	y_vel(a0)		; test speed
	bpl.w	DeleteObject		; if it's positive (>= 0), delete the object
	bsr.w	ObjectMove		; move the points
	addi.w	#$18,y_vel(a0)		; slow down
	bra.w	DisplaySprite
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj28_MapUnc_11E1C:	include "mappings/sprite/obj28_a.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj28_MapUnc_11E40:	include "mappings/sprite/obj28_b.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj28_MapUnc_11E64:	include "mappings/sprite/obj28_c.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj28_MapUnc_11E88:	include "mappings/sprite/obj28_d.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj28_MapUnc_11EAC:	include "mappings/sprite/obj28_e.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj29_MapUnc_11ED0:	include "mappings/sprite/obj29.asm"

    if ~~removeJmpTos
JmpTo_RandomNumber ; JmpTo
	jmp	(RandomNumber).l

	align 4
    endif
