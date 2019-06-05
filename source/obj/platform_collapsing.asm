; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Objects: Collapsing platforms (1A, 1F)

; ----------------------------------------------------------------------------
; Object 1A - Collapsing platform from HPZ (and GHZ)
; also supports OOZ, but never made use of
;
; Unlike Object 1F, this supports sloped platforms and subtype-dependant
; mappings. Both are used by GHZ, the latter to allow different shading
; on right-facing ledges.
; ----------------------------------------------------------------------------
; Sprite_108BC:
Obj1A:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj1A_Index(pc,d0.w),d1
	jmp	Obj1A_Index(pc,d1.w)
; ===========================================================================
; off_108CA:
Obj1A_Index:	offsetTable
		offsetTableEntry.w Obj1A_Init		; 0
		offsetTableEntry.w Obj1A_Main		; 2
		offsetTableEntry.w Obj1A_Fragment	; 4
; ===========================================================================

collapsing_platform_delay_pointer = objoff_34
collapsing_platform_delay_counter = objoff_38
collapsing_platform_stood_on_flag = objoff_3A
collapsing_platform_slope_pointer = objoff_3C

; loc_108D0:
Obj1A_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj1A_MapUnc_10C6C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#7,collapsing_platform_delay_counter(a0)
	move.b	subtype(a0),mapping_frame(a0)
	move.l	#Obj1A_DelayData,collapsing_platform_delay_pointer(a0)
	cmpi.b	#hidden_palace_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj1A_MapUnc_1101C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HPZPlatform,2,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$30,width_pixels(a0)
	move.l	#Obj1A_HPZ_SlopeData,collapsing_platform_slope_pointer(a0)
	move.l	#Obj1A_HPZ_DelayData,collapsing_platform_delay_pointer(a0)
	bra.s	Obj1A_Main
; ===========================================================================
+
	cmpi.b	#oil_ocean_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj1F_MapUnc_110C6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_OOZPlatform,3,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$40,width_pixels(a0)
	move.l	#Obj1A_OOZ_SlopeData,collapsing_platform_slope_pointer(a0)
	bra.s	Obj1A_Main
; ===========================================================================
+
	move.l	#Obj1A_GHZ_SlopeData,collapsing_platform_slope_pointer(a0)
	move.b	#$34,width_pixels(a0)
	move.b	#$38,y_radius(a0)
	bset	#4,render_flags(a0)
; loc_1097C:
Obj1A_Main:
	tst.b	collapsing_platform_stood_on_flag(a0)
	beq.s	+
	tst.b	collapsing_platform_delay_counter(a0)
	beq.w	Obj1A_CreateFragments	; time up; collapse
	subq.b	#1,collapsing_platform_delay_counter(a0)
+
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	sub_1099E
	move.b	#1,collapsing_platform_stood_on_flag(a0)

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_1099E:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	movea.l	collapsing_platform_slope_pointer(a0),a2 ; a2=object
	move.w	x_pos(a0),d4
	jsrto	(SlopedPlatform).l, JmpTo_SlopedPlatform
	bra.w	MarkObjGone
; End of function sub_1099E

; ===========================================================================
; loc_109B4:
Obj1A_Fragment:
	tst.b	collapsing_platform_delay_counter(a0)
	beq.s	Obj1A_FragmentFall	; time up; collapse
	tst.b	collapsing_platform_stood_on_flag(a0)
	bne.s	+
	subq.b	#1,collapsing_platform_delay_counter(a0)
	bra.w	DisplaySprite
; ===========================================================================
+
	bsr.w	sub_1099E
	subq.b	#1,collapsing_platform_delay_counter(a0)
	bne.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	sub_109DC
	lea	(Sidekick).w,a1 ; a1=character

sub_109DC:
	btst	#3,status(a1)
	beq.s	+
	bclr	#3,status(a1)
	bclr	#5,status(a1)
	move.b	#AniIDSonAni_Run,next_anim(a1)
+
	rts
; End of function sub_109DC

; ===========================================================================
; loc_109F8:
Obj1A_FragmentFall:
	bsr.w	ObjectMoveAndFall
	tst.b	render_flags(a0)
	bpl.w	DeleteObject
	bra.w	DisplaySprite
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 1F - Collapsing platform from ARZ, MCZ and OOZ (and MZ, SLZ and SBZ)
; ----------------------------------------------------------------------------
; Sprite_10A08:
Obj1F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj1F_Index(pc,d0.w),d1
	jmp	Obj1F_Index(pc,d1.w)
; ===========================================================================
; off_10A16:
Obj1F_Index:	offsetTable
		offsetTableEntry.w Obj1F_Init		; 0
		offsetTableEntry.w Obj1F_Main		; 2
		offsetTableEntry.w Obj1F_Fragment	; 4
; ===========================================================================
; loc_10A1C:
Obj1F_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj1F_MapUnc_10F0C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MZ_Platform,2,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#7,collapsing_platform_delay_counter(a0)
	move.b	#$44,width_pixels(a0)
	lea	(Obj1F_DelayData_EvenSubtype).l,a4
	btst	#0,subtype(a0)
	beq.s	+
	lea	(Obj1F_DelayData_OddSubtype).l,a4
+
	move.l	a4,collapsing_platform_delay_pointer(a0)
	cmpi.b	#oil_ocean_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj1F_MapUnc_110C6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_OOZPlatform,3,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$40,width_pixels(a0)
	move.l	#Obj1F_OOZ_DelayData,collapsing_platform_delay_pointer(a0)
+
	cmpi.b	#mystic_cave_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj1F_MapUnc_11106,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MCZCollapsePlat,3,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$20,width_pixels(a0)
	move.l	#Obj1F_MCZ_DelayData,collapsing_platform_delay_pointer(a0)
+
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	Obj1F_Main
	move.l	#Obj1F_MapUnc_1115E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$20,width_pixels(a0)
	move.l	#Obj1F_ARZ_DelayData,collapsing_platform_delay_pointer(a0)
; loc_10AD6:
Obj1F_Main:
	tst.b	collapsing_platform_stood_on_flag(a0)
	beq.s	+
	tst.b	collapsing_platform_delay_counter(a0)
	beq.w	Obj1F_CreateFragments	; time up; collapse
	subq.b	#1,collapsing_platform_delay_counter(a0)
+
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	sub_10AF8
	move.b	#1,collapsing_platform_stood_on_flag(a0)

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_10AF8:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	move.w	#$10,d3
	move.w	x_pos(a0),d4
	jsrto	(PlatformObject).l, JmpTo2_PlatformObject
	bra.w	MarkObjGone
; End of function sub_10AF8

; ===========================================================================
; loc_10B0E:
Obj1F_Fragment:
	tst.b	collapsing_platform_delay_counter(a0)
	beq.s	Obj1F_FragmentFall	; time up; collapse
	tst.b	collapsing_platform_stood_on_flag(a0)
	bne.s	+
	subq.b	#1,collapsing_platform_delay_counter(a0)
	bra.w	DisplaySprite
; ===========================================================================
+
	bsr.w	sub_10AF8
	subq.b	#1,collapsing_platform_delay_counter(a0)
	bne.s	+	; rts
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	sub_10B36
	lea	(Sidekick).w,a1 ; a1=character

sub_10B36:
	btst	#3,status(a1)
	beq.s	+	; rts
	bclr	#3,status(a1)
	bclr	#5,status(a1)
	move.b	#AniIDSonAni_Run,next_anim(a1)
+
	rts
; End of function sub_10B36

; ===========================================================================
; loc_10B52:
Obj1F_FragmentFall:
	bsr.w	ObjectMoveAndFall
	tst.b	render_flags(a0)
	bpl.w	DeleteObject
	bra.w	DisplaySprite
; ===========================================================================
; loc_10B62:
Obj1F_CreateFragments:
	addq.b	#1,mapping_frame(a0)
	bra.s	+
; ===========================================================================
; loc_10B68:
Obj1A_CreateFragments:
	addq.b	#2,mapping_frame(a0)
+
	movea.l	collapsing_platform_delay_pointer(a0),a4
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	add.w	d0,d0
	movea.l	mappings(a0),a3
	adda.w	(a3,d0.w),a3
	move.w	(a3)+,d1
	subq.w	#1,d1
	bset	#5,render_flags(a0)
	_move.b	id(a0),d4
	move.b	render_flags(a0),d5
	movea.l	a0,a1
	bra.s	+
; ===========================================================================
-	bsr.w	SingleObjLoad
	bne.s	+++
	addq.w	#8,a3
+
	move.b	#4,routine(a1)
	_move.b	d4,id(a1) ; load obj1F
	move.l	a3,mappings(a1)
	move.b	d5,render_flags(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	priority(a0),priority(a1)
	move.b	width_pixels(a0),width_pixels(a1)
	move.b	y_radius(a0),y_radius(a1)
	move.b	(a4)+,collapsing_platform_delay_counter(a1)
	cmpa.l	a0,a1
	bhs.s	+
	bsr.w	DisplaySprite2
+	dbf	d1,-
+
	bsr.w	DisplaySprite
	move.w	#SndID_Smash,d0
	jmp	(PlaySound).l
; ===========================================================================
; Delay data for obj1A in all but HPZ:
;byte_10BF2:
Obj1A_DelayData:
	dc.b $1C,$18,$14,$10,$1A,$16,$12, $E, $A,  6,$18,$14,$10, $C,  8,  4
	dc.b $16,$12, $E, $A,  6,  2,$14,$10, $C; 16
	rev02even
; Delay data for obj1A in HPZ:
;byte_10C0B:
Obj1A_HPZ_DelayData:
	dc.b $18,$1C,$20,$1E,$1A,$16,  6, $E,$14,$12, $A,  2
	rev02even
; Delay data for obj1F even subtypes in all levels without more specific data:
;byte_10C17:
Obj1F_DelayData_EvenSubtype:
	dc.b $1E,$16, $E,  6,$1A,$12, $A,  2
	rev02even
; Delay data for obj1F odd subtypes in all levels without more specific data:
;byte_10C1F:
Obj1F_DelayData_OddSubtype:
	dc.b $16,$1E,$1A,$12,  6, $E, $A,  2
	rev02even
; Delay data for obj1F in OOZ:
;byte_10C27:
Obj1F_OOZ_DelayData:
	dc.b $1A,$12, $A,  2,$16, $E,  6
	rev02even
; Delay data for obj1F in MCZ:
;byte_10C2E:
Obj1F_MCZ_DelayData:
	dc.b $1A,$16,$12, $E, $A,  2
	rev02even
; Delay data for obj1F in ARZ:
;byte_10C34:
Obj1F_ARZ_DelayData:
	dc.b $16,$1A,$18,$12,  6, $E, $A,  2
	rev02even
; S1 remnant: Height data for GHZ collapsing platform (unused):
;byte_10C3C:
Obj1A_GHZ_SlopeData:
	dc.b $20,$20,$20,$20,$20,$20,$20,$20,$21,$21,$22,$22,$23,$23,$24,$24
	dc.b $25,$25,$26,$26,$27,$27,$28,$28,$29,$29,$2A,$2A,$2B,$2B,$2C,$2C; 16
	dc.b $2D,$2D,$2E,$2E,$2F,$2F,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30; 32
	even
; -------------------------------------------------------------------------------
; unused sprite mappings (GHZ)
; -------------------------------------------------------------------------------
Obj1A_MapUnc_10C6C:	BINCLUDE "mappings/sprite/obj1A_a.bin"
; ----------------------------------------------------------------------------
; unused sprite mappings (MZ, SLZ, SBZ)
; ----------------------------------------------------------------------------
Obj1F_MapUnc_10F0C:	BINCLUDE "mappings/sprite/obj1F_a.bin"

; Slope data for platforms.
;byte_10FDC:
Obj1A_OOZ_SlopeData:
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
;byte_10FEC:
Obj1A_HPZ_SlopeData
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
; ----------------------------------------------------------------------------
; sprite mappings (HPZ)
; ----------------------------------------------------------------------------
Obj1A_MapUnc_1101C:	BINCLUDE "mappings/sprite/obj1A_b.bin"
; ----------------------------------------------------------------------------
; sprite mappings (OOZ)
; ----------------------------------------------------------------------------
Obj1F_MapUnc_110C6:	BINCLUDE "mappings/sprite/obj1F_b.bin"
; -------------------------------------------------------------------------------
; sprite mappings (MCZ)
; -------------------------------------------------------------------------------
Obj1F_MapUnc_11106:	BINCLUDE "mappings/sprite/obj1F_c.bin"
; -------------------------------------------------------------------------------
; sprite mappings (ARZ)
; -------------------------------------------------------------------------------
Obj1F_MapUnc_1115E:	BINCLUDE "mappings/sprite/obj1F_d.bin"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo_SlopedPlatform 
	jmp	(SlopedPlatform).l
JmpTo2_PlatformObject 
	jmp	(PlatformObject).l

	align 4
    endif
