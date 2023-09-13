; ===========================================================================
; ----------------------------------------------------------------------------
; Object 83 - 3 adjoined platforms from ARZ that rotate in a circle
; ----------------------------------------------------------------------------
; OST Variables:
Obj83_last_x_pos	= objoff_2C	; word
Obj83_speed		= objoff_2E	; word
Obj83_initial_x_pos	= objoff_30	; word
Obj83_initial_y_pos	= objoff_32	; word
; Child object RAM pointers
Obj83_childobjptr_chains	= objoff_34	; longword	; chain multisprite object
Obj83_childobjptr_platform2	= objoff_38	; longword	; 2nd platform object (parent object is 1st platform)
Obj83_childobjptr_platform3	= objoff_3C	; longword	; 3rd platform object

; Sprite_2A4FC:
Obj83:
	btst	#6,render_flags(a0)
	bne.w	.isMultispriteObject
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj83_Index(pc,d0.w),d1
	jmp	Obj83_Index(pc,d1.w)
; ===========================================================================
.isMultispriteObject:
	move.w	#object_display_list_size*5,d0
	jmpto	DisplaySprite3, JmpTo3_DisplaySprite3
; ===========================================================================
; off_2A51C:
Obj83_Index:	offsetTable
		offsetTableEntry.w Obj83_Init			; 0
		offsetTableEntry.w Obj83_Main			; 2
		offsetTableEntry.w Obj83_PlatformSubObject	; 4
; ===========================================================================
; loc_2A522:
Obj83_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj15_Obj83_MapUnc_1021E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo47_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#$20,width_pixels(a0)
	move.w	x_pos(a0),Obj83_initial_x_pos(a0)
	move.w	y_pos(a0),Obj83_initial_y_pos(a0)

	; Setup subtype variables (rotation speed and other unused variable)
	move.b	subtype(a0),d1
	move.b	d1,d0
	andi.w	#$F,d1	; The lower 4 bits of subtype are unused, making these instructions useless
	andi.b	#$F0,d0
	ext.w	d0
	asl.w	#3,d0
	move.w	d0,Obj83_speed(a0)

	; Set angle according to X-flip and Y-flip
	move.b	status(a0),d0
	ror.b	#2,d0
	andi.b	#$C0,d0
	move.b	d0,angle(a0)

	; Create child object (chain multisprite)
	jsrto	AllocateObjectAfterCurrent, JmpTo19_AllocateObjectAfterCurrent
	bne.s	.noRAMforChildObjects

	_move.b	id(a0),id(a1) ; load obj83
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#4,render_flags(a1)
	bset	#6,render_flags(a1)
	move.b	#$40,mainspr_width(a1)
	moveq	#8,d1
	move.b	d1,mainspr_childsprites(a1)
	subq.w	#1,d1
	lea	subspr_data(a1),a2

.nextChildSprite:
	addq.w	#next_subspr-2,a2
	move.w	#1,(a2)+	; sub?_mapframe
	dbf	d1,.nextChildSprite

	move.b	#1,mainspr_mapframe(a1)
	move.b	#$40,mainspr_height(a1)
	bset	#4,render_flags(a1)
	move.l	a1,Obj83_childobjptr_chains(a0)

	; Create remaining child objects: platform 2 and 3
	bsr.s	Obj83_LoadSubObject
	move.l	a1,Obj83_childobjptr_platform2(a0)
	bsr.s	Obj83_LoadSubObject
	move.l	a1,Obj83_childobjptr_platform3(a0)

.noRAMforChildObjects:
	bra.s	Obj83_Main
; ===========================================================================
; loc_2A5DE:
Obj83_LoadSubObject:
	jsrto	AllocateObjectAfterCurrent, JmpTo19_AllocateObjectAfterCurrent
	bne.s	.noRAMforChildObject	; rts
	addq.b	#4,routine(a1)
	_move.b	id(a0),id(a1) ; load obj
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#4,priority(a1)
	move.b	#$20,width_pixels(a1)
	move.w	x_pos(a0),Obj83_initial_x_pos(a1)
	move.w	y_pos(a0),Obj83_initial_y_pos(a1)
	move.w	x_pos(a0),Obj83_last_x_pos(a1)

.noRAMforChildObject:
	rts
; ===========================================================================
; loc_2A620:
Obj83_Main:
	move.w	x_pos(a0),-(sp)
	moveq	#0,d0
	moveq	#0,d1
	move.w	Obj83_speed(a0),d0
	add.w	d0,angle(a0)
	move.w	Obj83_initial_y_pos(a0),d2
	move.w	Obj83_initial_x_pos(a0),d3
	moveq	#0,d6
	movea.l	Obj83_childobjptr_chains(a0),a1 ; a1=object
	lea	subspr_data(a1),a2

	; Update first row of chains
	move.b	angle(a0),d0
	jsrto	CalcSine, JmpTo10_CalcSine
	swap	d0
	swap	d1
	asr.l	#4,d0
	asr.l	#4,d1
	move.l	d0,d4
	move.l	d1,d5
	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	move.w	d5,x_pos(a1)	; update chainlink mainsprite x_pos
	move.w	d4,y_pos(a1)	; update chainlink mainsprite y_pos
	move.l	d0,d4
	move.l	d1,d5
	add.l	d0,d4
	add.l	d1,d5
	moveq	#1,d6	; Update 2 chainlink childsprites (the third chainlink is the mainsprite, which has already been updated)
	bsr.w	Obj83_UpdateChainSpritePosition
	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	move.w	d5,x_pos(a0)
	move.w	d4,y_pos(a0)

	; Update second row of chains
	move.b	angle(a0),d0
	addi.b	#256/3,d0	; 360 degrees = 256
	jsrto	CalcSine, JmpTo10_CalcSine
	swap	d0
	swap	d1
	asr.l	#4,d0
	asr.l	#4,d1
	move.l	d0,d4
	move.l	d1,d5
	moveq	#2,d6	; Update 3 chainlink childsprites
	bsr.w	Obj83_UpdateChainSpritePosition
	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	movea.l	Obj83_childobjptr_platform2(a0),a1 ; a1=object
	move.w	d5,x_pos(a1)
	move.w	d4,y_pos(a1)

	; Update third row of chains
	move.b	angle(a0),d0
	subi.b	#256/3,d0	; 360 degrees = 256
	jsrto	CalcSine, JmpTo10_CalcSine
	swap	d0
	swap	d1
	asr.l	#4,d0
	asr.l	#4,d1
	move.l	d0,d4
	move.l	d1,d5
	moveq	#2,d6	; Update 3 chainlink childsprites
	bsr.w	Obj83_UpdateChainSpritePosition
	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	movea.l	Obj83_childobjptr_platform3(a0),a1 ; a1=object
	move.w	d5,x_pos(a1)
	move.w	d4,y_pos(a1)

	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jsrto	PlatformObject, JmpTo7_PlatformObject
	tst.w	(Two_player_mode).w
	beq.s	.notTwoPlayerMode
	jmpto	DisplaySprite, JmpTo27_DisplaySprite
; ===========================================================================
.notTwoPlayerMode:
	move.w	Obj83_initial_x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	.objectOffscreen
	jmpto	DisplaySprite, JmpTo27_DisplaySprite
; ===========================================================================
.objectOffscreen:
	movea.l	Obj83_childobjptr_chains(a0),a1 ; a1=object
	jsrto	DeleteObject2, JmpTo4_DeleteObject2
	jmpto	DeleteObject, JmpTo42_DeleteObject
; ===========================================================================
; loc_2A72E:
Obj83_UpdateChainSpritePosition:
.nextChainSprite:
	movem.l	d4-d5,-(sp)
	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	move.w	d5,(a2)+	; sub?_x_pos
	move.w	d4,(a2)+	; sub?_y_pos
	movem.l	(sp)+,d4-d5
	add.l	d0,d4
	add.l	d1,d5
	addq.w	#next_subspr-4,a2
	dbf	d6,.nextChainSprite
	rts
; ===========================================================================
; loc_2A74E: Obj83_SubObject:
Obj83_PlatformSubObject:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	Obj83_last_x_pos(a0),d4
	jsrto	PlatformObject, JmpTo7_PlatformObject
	move.w	x_pos(a0),Obj83_last_x_pos(a0)
	move.w	Obj83_initial_x_pos(a0),d0
	jmpto	MarkObjGone2, JmpTo8_MarkObjGone2
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo3_DisplaySprite3 ; JmpTo
	jmp	(DisplaySprite3).l
JmpTo27_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo42_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo4_DeleteObject2 ; JmpTo
	jmp	(DeleteObject2).l
JmpTo19_AllocateObjectAfterCurrent ; JmpTo
	jmp	(AllocateObjectAfterCurrent).l
JmpTo47_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo10_CalcSine ; JmpTo
	jmp	(CalcSine).l
JmpTo7_PlatformObject ; JmpTo
	jmp	(PlatformObject).l
JmpTo8_MarkObjGone2 ; JmpTo
	jmp	(MarkObjGone2).l

	align 4
    endif
