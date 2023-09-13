; ===========================================================================
; ----------------------------------------------------------------------------
; Object 2F - Smashable ground in Hill Top Zone
; ----------------------------------------------------------------------------
; Sprite_23300:
Obj2F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj2F_Index(pc,d0.w),d1
	jmp	Obj2F_Index(pc,d1.w)
; ===========================================================================
; off_2330E:
Obj2F_Index:	offsetTable
		offsetTableEntry.w Obj2F_Init		; 0
		offsetTableEntry.w Obj2F_Main		; 2
		offsetTableEntry.w Obj2F_Fragment	; 4
; ===========================================================================
; byte_23314:
Obj2F_Properties:
	;    y_radius
	;	  mapping_frame
	dc.b $24, 0	; 0
	dc.b $20, 2	; 2
	dc.b $18, 4	; 4
	dc.b $10, 6	; 6
	dc.b   8, 8	; 8
; ===========================================================================
; loc_2331E:
Obj2F_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj2F_MapUnc_236FA,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,1),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo18_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#$1E,d0
	lea	Obj2F_Properties(pc,d0.w),a2
	move.b	(a2)+,y_radius(a0)
	move.b	(a2)+,mapping_frame(a0)
	move.b	#$20,y_radius(a0)
	bset	#4,render_flags(a0)
; loc_23368:
Obj2F_Main:
	move.w	(Chain_Bonus_counter).w,objoff_38(a0)
	move.b	(MainCharacter+anim).w,objoff_32(a0)
	move.b	(Sidekick+anim).w,objoff_33(a0)
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	x_pos(a0),d4
	jsrto	SolidObject, JmpTo3_SolidObject
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	+

BranchTo_JmpTo9_MarkObjGone ; BranchTo
	jmpto	MarkObjGone, JmpTo9_MarkObjGone
; ===========================================================================
+
	cmpi.b	#standing_mask,d0
	bne.s	loc_23408
	cmpi.b	#AniIDSonAni_Roll,objoff_32(a0)
	bne.s	loc_233C0
	tst.b	subtype(a0)
	bmi.s	loc_233F0
	cmpi.b	#$E,(MainCharacter+top_solid_bit).w
	beq.s	loc_233F0

loc_233C0:
	move.b	#$C,(MainCharacter+top_solid_bit).w
	move.b	#$D,(MainCharacter+lrb_solid_bit).w
	cmpi.b	#AniIDSonAni_Roll,objoff_33(a0)
	bne.s	loc_233E2
	tst.b	subtype(a0)
	bmi.s	loc_233F0
	cmpi.b	#$E,(Sidekick+top_solid_bit).w
	beq.s	loc_233F0

loc_233E2:
	move.b	#$C,(Sidekick+top_solid_bit).w
	move.b	#$D,(Sidekick+lrb_solid_bit).w
	bra.s	BranchTo_JmpTo9_MarkObjGone
; ===========================================================================

loc_233F0:
	lea	(MainCharacter).w,a1 ; a1=character
	move.b	objoff_32(a0),d0
	bsr.s	loc_2343E
	lea	(Sidekick).w,a1 ; a1=character
	move.b	objoff_33(a0),d0
	bsr.s	loc_2343E
	bra.w	loc_234A4
; ===========================================================================

loc_23408:
	move.b	d0,d1
	andi.b	#p1_standing,d1
	beq.s	loc_23470
	cmpi.b	#AniIDSonAni_Roll,objoff_32(a0)
	bne.s	loc_23426
	tst.b	subtype(a0)
	bmi.s	loc_23436
	cmpi.b	#$E,(MainCharacter+top_solid_bit).w
	beq.s	loc_23436

loc_23426:
	move.b	#$C,(MainCharacter+top_solid_bit).w
	move.b	#$D,(MainCharacter+lrb_solid_bit).w
	bra.w	BranchTo_JmpTo9_MarkObjGone
; ===========================================================================

loc_23436:
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_23444
	bra.s	loc_234A4
; ===========================================================================

loc_2343E:
	cmpi.b	#AniIDSonAni_Roll,d0
	bne.s	loc_2345C

loc_23444:
	bset	#2,status(a1)
	move.b	#$E,y_radius(a1)
	move.b	#7,x_radius(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)

loc_2345C:
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#2,routine(a1)
	rts
; ===========================================================================

loc_23470:
	andi.b	#p2_standing,d0
	beq.w	BranchTo_JmpTo9_MarkObjGone
	cmpi.b	#AniIDSonAni_Roll,objoff_33(a0)
	bne.s	loc_2348E
	tst.b	subtype(a0)
	bmi.s	loc_2349E
	cmpi.b	#$E,(Sidekick+top_solid_bit).w
	beq.s	loc_2349E

loc_2348E:
	move.b	#$C,(Sidekick+top_solid_bit).w
	move.b	#$D,(Sidekick+lrb_solid_bit).w
	bra.w	BranchTo_JmpTo9_MarkObjGone
; ===========================================================================

loc_2349E:
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	loc_23444

loc_234A4:
	move.w	objoff_38(a0),(Chain_Bonus_counter).w
	andi.b	#~standing_mask,status(a0)
	lea	(byte_234F2).l,a4
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	addq.b	#1,mapping_frame(a0)
	move.l	d0,d1
	add.w	d0,d0
	add.w	d0,d0
	lea	(a4,d0.w),a4
	neg.w	d1
	addi.w	#9,d1
	move.w	#$18,d2
	jsrto	BreakObjectToPieces, JmpTo_BreakObjectToPieces
	bsr.w	SmashableObject_LoadPoints
; loc_234DC:
Obj2F_Fragment:
	jsrto	ObjectMove, JmpTo8_ObjectMove
	addi.w	#$18,y_vel(a0)
	tst.b	render_flags(a0)
	bpl.w	JmpTo22_DeleteObject
	jmpto	DisplaySprite, JmpTo12_DisplaySprite
; ===========================================================================
byte_234F2:
	dc.b $FF
	dc.b   0	; 1
	dc.b $F8	; 2
	dc.b   0	; 3
	dc.b   1	; 4
	dc.b   0	; 5
	dc.b $F8	; 6
	dc.b   0	; 7
	dc.b $FF	; 8
	dc.b $20	; 9
	dc.b $F9	; 10
	dc.b   0	; 11
	dc.b   0	; 12
	dc.b $E0	; 13
	dc.b $F9	; 14
	dc.b   0	; 15
	dc.b $FF	; 16
	dc.b $40	; 17
	dc.b $FA	; 18
	dc.b   0	; 19
	dc.b   0	; 20
	dc.b $C0	; 21
	dc.b $FA	; 22
	dc.b   0	; 23
	dc.b $FF	; 24
	dc.b $60	; 25
	dc.b $FB	; 26
	dc.b   0	; 27
	dc.b   0	; 28
	dc.b $A0	; 29
	dc.b $FB	; 30
	dc.b   0	; 31
	dc.b $FF	; 32
	dc.b $80	; 33
	dc.b $FC	; 34
	dc.b   0	; 35
	dc.b   0	; 36
	dc.b $80	; 37
	dc.b $FC	; 38
	dc.b   0	; 39
	even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 32 - Breakable block/rock from CPZ and HTZ
; ----------------------------------------------------------------------------
breakableblock_mainchar_anim =	objoff_32
breakableblock_sidekick_anim =	objoff_33
; Sprite_2351A:
Obj32:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj32_Index(pc,d0.w),d1
	jmp	Obj32_Index(pc,d1.w)
; ===========================================================================
; off_23528:
Obj32_Index:	offsetTable
		offsetTableEntry.w Obj32_Init		; 0
		offsetTableEntry.w Obj32_Main		; 2
		offsetTableEntry.w Obj32_Fragment	; 4
; ===========================================================================
; loc_2352E:
Obj32_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj32_MapUnc_23852,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HtzRock,2,0),art_tile(a0)
	move.b	#$18,width_pixels(a0)
	move.l	#Obj32_VelArray1,objoff_3C(a0)
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj32_MapUnc_23886,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZMetalBlock,3,0),art_tile(a0)
	move.b	#$10,width_pixels(a0)
	move.l	#Obj32_VelArray2,objoff_3C(a0)
+
	jsrto	Adjust2PArtPointer, JmpTo18_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
; loc_23582:
Obj32_Main:
	move.w	(Chain_Bonus_counter).w,objoff_38(a0)
	move.b	(MainCharacter+anim).w,breakableblock_mainchar_anim(a0)
	move.b	(Sidekick+anim).w,breakableblock_sidekick_anim(a0)
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#$10,d2
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	jsrto	SolidObject, JmpTo3_SolidObject
	move.b	status(a0),d0
	andi.b	#standing_mask,d0	; is at least one player standing on the object?
	bne.s	Obj32_SupportingSomeone

BranchTo2_JmpTo9_MarkObjGone
	jmpto	MarkObjGone, JmpTo9_MarkObjGone
; ===========================================================================
; loc_235BC:
Obj32_SupportingSomeone:
	cmpi.b	#standing_mask,d0	; are BOTH players standing on the object?
	bne.s	Obj32_SupportingOnePlayerOnly	; if not, branch
	cmpi.b	#AniIDSonAni_Roll,breakableblock_mainchar_anim(a0)
	beq.s	+
	cmpi.b	#AniIDSonAni_Roll,breakableblock_sidekick_anim(a0)
	bne.s	BranchTo2_JmpTo9_MarkObjGone
+
	lea	(MainCharacter).w,a1 ; a1=character
	move.b	breakableblock_mainchar_anim(a0),d0
	bsr.s	Obj32_SetCharacterOffBlock
	lea	(Sidekick).w,a1 ; a1=character
	move.b	breakableblock_sidekick_anim(a0),d0
	bsr.s	Obj32_SetCharacterOffBlock
	bra.w	Obj32_Destroy
; ===========================================================================
; loc_235EA:
Obj32_SupportingOnePlayerOnly:
	move.b	d0,d1
	andi.b	#p1_standing,d1			 ; is the main character standing on the object?
	beq.s	Obj32_SupportingSidekick ; if not, branch
	cmpi.b	#AniIDSonAni_Roll,breakableblock_mainchar_anim(a0)
	bne.s	BranchTo2_JmpTo9_MarkObjGone
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	Obj32_BouncePlayer
	bra.s	Obj32_Destroy
; ===========================================================================
; loc_23602:
Obj32_SetCharacterOffBlock:
	cmpi.b	#AniIDSonAni_Roll,d0
	bne.s	+
; loc_23608:
Obj32_BouncePlayer:
	bset	#2,status(a1)
	move.b	#$E,y_radius(a1)
	move.b	#7,x_radius(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	move.w	#-$300,y_vel(a1)
+
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#2,routine(a1)
	rts
; ===========================================================================
; loc_2363A:
Obj32_SupportingSidekick:
	andi.b	#p2_standing,d0	; is the sidekick standing on the object? (at this point, it should...)
	beq.w	BranchTo2_JmpTo9_MarkObjGone ; if, by miracle, he's not, branch
	cmpi.b	#2,breakableblock_sidekick_anim(a0)
	bne.w	BranchTo2_JmpTo9_MarkObjGone
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	Obj32_BouncePlayer
; loc_23652:
Obj32_Destroy:
	move.w	objoff_38(a0),(Chain_Bonus_counter).w
	andi.b	#~standing_mask,status(a0)
	movea.l	objoff_3C(a0),a4
	jsrto	BreakObjectToPieces, JmpTo_BreakObjectToPieces
	bsr.w	SmashableObject_LoadPoints
; loc_2366A:
Obj32_Fragment:
	jsrto	ObjectMove, JmpTo8_ObjectMove
	addi.w	#$18,y_vel(a0)
	tst.b	render_flags(a0)
	bpl.w	JmpTo22_DeleteObject
	jmpto	DisplaySprite, JmpTo12_DisplaySprite
; ===========================================================================
; velocity array for smashed bits, two words for each fragment
; byte_23680:
Obj32_VelArray1:
	;    x_vel y_vel
	dc.w -$200,-$200
	dc.w     0,-$280
	dc.w  $200,-$200
	dc.w -$1C0,-$1C0
	dc.w     0,-$200
	dc.w  $1C0,-$1C0
;byte_23698:
Obj32_VelArray2:
	;    x_vel y_vel
	dc.w -$100,-$200
	dc.w  $100,-$200
	dc.w  -$C0,-$1C0
	dc.w   $C0,-$1C0

; ===========================================================================
; loc_236A8:
SmashableObject_LoadPoints:
	jsrto	AllocateObject, JmpTo3_AllocateObject
	bne.s	+++	; rts
	_move.b	#ObjID_Points,id(a1) ; load obj29
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	(Chain_Bonus_counter).w,d2
	addq.w	#2,(Chain_Bonus_counter).w
	cmpi.w	#6,d2
	blo.s	+
	moveq	#6,d2
+
	moveq	#0,d0
	move.w	SmashableObject_ScoreBonus(pc,d2.w),d0
	cmpi.w	#$20,(Chain_Bonus_counter).w
	blo.s	+
	move.w	#1000,d0
	moveq	#$A,d2
+
	jsr	(AddPoints).l
	lsr.w	#1,d2
	move.b	d2,mapping_frame(a1)
+
	rts
; ===========================================================================
; word_236F2:
SmashableObject_ScoreBonus:
	dc.w	10
	dc.w	20	; 1
	dc.w	50	; 2
	dc.w   100	; 3
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj2F_MapUnc_236FA:	include "mappings/sprite/obj2F.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj32_MapUnc_23852:	include "mappings/sprite/obj32_a.asm"
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj32_MapUnc_23886:	include "mappings/sprite/obj32_b.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo12_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo22_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo3_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
JmpTo9_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo18_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo_BreakObjectToPieces ; JmpTo
	jmp	(BreakObjectToPieces).l
JmpTo3_SolidObject ; JmpTo
	jmp	(SolidObject).l
; loc_238D6:
JmpTo8_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    else
JmpTo22_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
