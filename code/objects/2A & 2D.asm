; ----------------------------------------------------------------------------
; Object 2A - Stomper from MCZ
; ----------------------------------------------------------------------------
; Sprite_115C4:
Obj2A:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj2A_Index(pc,d0.w),d1
	jmp	Obj2A_Index(pc,d1.w)
; ===========================================================================
; off_115D2:
Obj2A_Index:	offsetTable
		offsetTableEntry.w Obj2A_Init	; 0
		offsetTableEntry.w Obj2A_Main	; 2
; ===========================================================================
; loc_115D6:
Obj2A_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj2A_MapUnc_11666,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	move.w	y_pos(a0),objoff_32(a0)
	move.b	#$50,y_radius(a0)
	bset	#4,render_flags(a0)
; loc_11610:
Obj2A_Main:
	tst.b	routine_secondary(a0)
	bne.s	+
	addq.w	#1,objoff_30(a0)
	cmpi.w	#$60,objoff_30(a0)
	bne.s	++
	move.b	#2,routine_secondary(a0)
	bra.s	++
; ===========================================================================
+
	subq.w	#8,objoff_30(a0)
	bhi.s	+
	move.w	#0,objoff_30(a0)
	move.b	#0,routine_secondary(a0)
+
	move.w	objoff_32(a0),d0
	sub.w	objoff_30(a0),d0
	move.w	d0,y_pos(a0)
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#$40,d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	x_pos(a0),d4
	jsrto	SolidObject, JmpTo2_SolidObject
	bra.w	MarkObjGone
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj2A_MapUnc_11666:	include "mappings/sprite/obj2A.asm"

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 2D - One way barrier from CPZ and DEZ
; ----------------------------------------------------------------------------
; Sprite_1169A:
Obj2D:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj2D_Index(pc,d0.w),d1
	jmp	Obj2D_Index(pc,d1.w)
; ===========================================================================
; off_116A8:
Obj2D_Index:	offsetTable
		offsetTableEntry.w Obj2D_Init	; 0
		offsetTableEntry.w Obj2D_Main	; 2
; ===========================================================================
; loc_116AC:
Obj2D_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj2D_MapUnc_11822,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HtzValveBarrier,1,0),art_tile(a0)
	move.b	#8,width_pixels(a0)
	cmpi.b	#metropolis_zone,(Current_Zone).w
	beq.s	+
	cmpi.b	#metropolis_zone_2,(Current_Zone).w
	bne.s	++
+
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,3,0),art_tile(a0)
	move.b	#$C,width_pixels(a0)
+
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	bne.s	+
	move.w	#make_art_tile(ArtTile_ArtNem_ConstructionStripes_2,1,0),art_tile(a0)
	move.b	#8,width_pixels(a0)
+
	cmpi.b	#death_egg_zone,(Current_Zone).w
	bne.s	+
	move.w	#make_art_tile(ArtTile_ArtNem_ConstructionStripes_1,1,0),art_tile(a0)
	move.b	#8,width_pixels(a0)
+
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	+
	move.w	#make_art_tile(ArtTile_ArtNem_ARZBarrierThing,1,0),art_tile(a0)
	move.b	#8,width_pixels(a0)
+
	bsr.w	Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.w	y_pos(a0),objoff_32(a0)
	move.b	subtype(a0),mapping_frame(a0)
	move.w	x_pos(a0),d2
	move.w	d2,d3
	subi.w	#$200,d2
	addi.w	#$18,d3
	btst	#0,status(a0)
	beq.s	+
	subi.w	#-$1E8,d2
	addi.w	#$1E8,d3
+
	move.w	d2,objoff_38(a0)
	move.w	d3,objoff_3A(a0)
; loc_1175E:
Obj2D_Main:
	btst	#0,status(a0)
	bne.s	+
	move.w	objoff_38(a0),d2
	move.w	x_pos(a0),d3
	tst.b	routine_secondary(a0)                ; check if barrier is moving up
	beq.s	++
	move.w	objoff_3A(a0),d3
	bra.s	++
; ===========================================================================
+
	move.w	x_pos(a0),d2
	move.w	objoff_3A(a0),d3
	tst.b	routine_secondary(a0)                ; check if barrier is moving up
	beq.s	+
	move.w	objoff_38(a0),d2
+
	move.w	objoff_32(a0),d4
	move.w	d4,d5
	subi.w	#$20,d4
	addi.w	#$20,d5
	move.b	#0,routine_secondary(a0)             ; set barrier to move down, check if characters are in area
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	Obj2D_CheckCharacter
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	Obj2D_CheckCharacter
	tst.b	routine_secondary(a0)                ; check if barrier is moving up
	beq.s	+
	cmpi.w	#$40,objoff_30(a0)                   ; check if barrier is high enough
	beq.s	+++
	addq.w	#8,objoff_30(a0)                     ; move barrier up
	bra.s	++
; ===========================================================================
+
	tst.w	objoff_30(a0)                        ; check if barrier is not in original position
	beq.s	++
	subq.w	#8,objoff_30(a0)                     ; move barrier down
+
	move.w	objoff_32(a0),d0                     ; set the barrier y position
	sub.w	objoff_30(a0),d0
	move.w	d0,y_pos(a0)
+
	moveq	#0,d1                                ; perform solid object collision
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#$20,d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	x_pos(a0),d4
	jsrto	SolidObject, JmpTo2_SolidObject
	bra.w	MarkObjGone                          ; delete object if off screen

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_117F4
Obj2D_CheckCharacter:
    ; rect ltrb (d2, d4, d3, d5)

	move.w	x_pos(a1),d0
	cmp.w	d2,d0
	blt.w	return_11820
	cmp.w	d3,d0
	bhs.w	return_11820
	move.w	y_pos(a1),d0
	cmp.w	d4,d0
	blo.w	return_11820
	cmp.w	d5,d0
	bhs.w	return_11820
	tst.b	obj_control(a1)
	bmi.s	return_11820
	move.b	#2,routine_secondary(a0)             ; set barrier to move up

return_11820:
	rts
; End of function Obj2D_CheckCharacter

; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj2D_MapUnc_11822:	include "mappings/sprite/obj2D.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo2_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif