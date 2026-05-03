; ----------------------------------------------------------------------------
; Object 08 - Water splash in Aquatic Ruin Zone, Spindash dust
; ----------------------------------------------------------------------------

obj08_previous_frame = objoff_30
obj08_dust_timer = objoff_32
obj08_belongs_to_tails = objoff_34
obj08_vram_address = objoff_3C

; Sprite_1DD20:
Obj08:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj08_Index(pc,d0.w),d1
	jmp	Obj08_Index(pc,d1.w)
; ===========================================================================
; off_1DD2E:
Obj08_Index:	offsetTable
		offsetTableEntry.w Obj08_Init			; 0
		offsetTableEntry.w Obj08_Main			; 2
		offsetTableEntry.w BranchTo16_DeleteObject	; 4
		offsetTableEntry.w Obj08_CheckSkid		; 6
; ===========================================================================
; loc_1DD36:
Obj08_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj08_MapUnc_1DF5E,mappings(a0)
	ori.b	#1<<render_flags.level_fg,render_flags(a0)
	move.b	#1,priority(a0)
	move.b	#$10,width_pixels(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SonicDust,0,0),art_tile(a0)
	move.w	#MainCharacter,parent(a0)
	move.w	#tiles_to_bytes(ArtTile_ArtNem_SonicDust),obj08_vram_address(a0)
	cmpa.w	#Sonic_Dust,a0
	beq.s	+
	move.b	#1,obj08_belongs_to_tails(a0)
	cmpi.w	#2,(Player_mode).w
	beq.s	+
	move.w	#make_art_tile(ArtTile_ArtNem_TailsDust,0,0),art_tile(a0)
	move.w	#Sidekick,parent(a0)
	move.w	#tiles_to_bytes(ArtTile_ArtNem_TailsDust),obj08_vram_address(a0)
+
	bsr.w	Adjust2PArtPointer

; loc_1DD90:
Obj08_Main:
	movea.w	parent(a0),a2 ; a2=character
	moveq	#0,d0
	move.b	anim(a0),d0	; use current animation as a secondary routine counter
	add.w	d0,d0
	move.w	Obj08_DisplayModes(pc,d0.w),d1
	jmp	Obj08_DisplayModes(pc,d1.w)
; ===========================================================================
; off_1DDA4:
Obj08_DisplayModes: offsetTable
	offsetTableEntry.w Obj08_Display	; 0
	offsetTableEntry.w Obj08_MdSplash	; 2
	offsetTableEntry.w Obj08_MdSpindashDust	; 4
	offsetTableEntry.w Obj08_MdSkidDust	; 6
; ===========================================================================
; loc_1DDAC:
Obj08_MdSplash:
	move.w	(Water_Level_1).w,y_pos(a0)
	tst.b	prev_anim(a0)
	bne.s	Obj08_Display
	move.w	x_pos(a2),x_pos(a0)
	move.b	#0,status(a0)
	andi.w	#drawing_mask,art_tile(a0)
	bra.s	Obj08_Display
; ===========================================================================
; loc_1DDCC:
Obj08_MdSpindashDust:
	cmpi.b	#12,air_left(a2)
	blo.s	Obj08_ResetDisplayMode
	cmpi.b	#4,routine(a2)
	bhs.s	Obj08_ResetDisplayMode
	tst.b	spindash_flag(a2)
	beq.s	Obj08_ResetDisplayMode
	move.w	x_pos(a2),x_pos(a0)
	move.w	y_pos(a2),y_pos(a0)
	move.b	status(a2),status(a0)
	andi.b	#1<<status.npc.x_flip,status(a0)
	tst.b	obj08_belongs_to_tails(a0)
	beq.s	+
	subi_.w	#4,y_pos(a0)	; Tails is shorter than Sonic
+
	tst.b	prev_anim(a0)
	bne.s	Obj08_Display
	andi.w	#drawing_mask,art_tile(a0)
	tst.w	art_tile(a2)
	bpl.s	Obj08_Display
	ori.w	#high_priority,art_tile(a0)
	bra.s	Obj08_Display
; ===========================================================================
; loc_1DE20:
Obj08_MdSkidDust:
	cmpi.b	#12,air_left(a2)
	blo.s	Obj08_ResetDisplayMode

; loc_1DE28:
Obj08_Display:
	lea	(Ani_obj08).l,a1
	jsr	(AnimateSprite).l
	bsr.w	Obj08_LoadDustOrSplashArt
	jmp	(DisplaySprite).l
; ===========================================================================
; loc_1DE3E:
Obj08_ResetDisplayMode:
	move.b	#0,anim(a0)
	rts
; ===========================================================================

BranchTo16_DeleteObject ; BranchTo
	bra.w	DeleteObject
; ===========================================================================
; loc_1DE4A:
Obj08_CheckSkid:
	movea.w	parent(a0),a2 ; a2=character
	cmpi.b	#AniIDSonAni_Stop,anim(a2)	; SonAni_Stop
	beq.s	Obj08_SkidDust
	move.b	#2,routine(a0)
	move.b	#0,obj08_dust_timer(a0)
	rts
; ===========================================================================
; loc_1DE64:
Obj08_SkidDust:
	subq.b	#1,obj08_dust_timer(a0)
	bpl.s	loc_1DEE0
	move.b	#3,obj08_dust_timer(a0)
	bsr.w	AllocateObject
	bne.s	loc_1DEE0
	_move.b	id(a0),id(a1) ; load obj08
	move.w	x_pos(a2),x_pos(a1)
	move.w	y_pos(a2),y_pos(a1)
	addi.w	#$10,y_pos(a1)
	tst.b	obj08_belongs_to_tails(a0)
	beq.s	+
	subi_.w	#4,y_pos(a1)	; Tails is shorter than Sonic
+
	move.b	#0,status(a1)
	move.b	#3,anim(a1)
	addq.b	#2,routine(a1)
	move.l	mappings(a0),mappings(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	#1,priority(a1)
	move.b	#4,width_pixels(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.w	parent(a0),parent(a1)
	andi.w	#drawing_mask,art_tile(a1)
	tst.w	art_tile(a2)
	bpl.s	loc_1DEE0
	ori.w	#high_priority,art_tile(a1)

loc_1DEE0:
	bsr.s	Obj08_LoadDustOrSplashArt
	rts
; ===========================================================================
; loc_1DEE4:
Obj08_LoadDustOrSplashArt:
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	cmp.b	obj08_previous_frame(a0),d0
	beq.s	return_1DF36
	move.b	d0,obj08_previous_frame(a0)
	lea	(Obj08_MapRUnc_1E074).l,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d5
	subq.w	#1,d5
	bmi.s	return_1DF36
	move.w	obj08_vram_address(a0),d4

-	moveq	#0,d1
	move.w	(a2)+,d1
	move.w	d1,d3
	lsr.w	#8,d3
	andi.w	#$F0,d3
	addi.w	#$10,d3
	andi.w	#$FFF,d1
	lsl.l	#5,d1
	addi.l	#ArtUnc_SplashAndDust,d1
	move.w	d4,d2
	add.w	d3,d4
	add.w	d3,d4
	jsr	(QueueDMATransfer).l
	dbf	d5,-

return_1DF36:
	rts
