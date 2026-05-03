; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_19DC:
PalCycle_Load:
	bsr.w	PalCycle_SuperSonic
	moveq	#0,d2
	moveq	#0,d0
	move.b	(Current_Zone).w,d0	; use level number as index into palette cycles
	add.w	d0,d0			; (multiply by element size = 2 bytes)
	move.w	PalCycle(pc,d0.w),d0	; load animated palettes offset index into d0
	jmp	PalCycle(pc,d0.w)	; jump to PalCycle + offset index
; ---------------------------------------------------------------------------
	rts
; End of function PalCycle_Load

; ===========================================================================
; off_19F4:
PalCycle: zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w PalCycle_EHZ	; EHZ
	zoneOffsetTableEntry.w PalCycle_Null	; Zone 1
	zoneOffsetTableEntry.w PalCycle_WZ	; WZ
	zoneOffsetTableEntry.w PalCycle_Null	; Zone 3
	zoneOffsetTableEntry.w PalCycle_MTZ	; MTZ1,2
	zoneOffsetTableEntry.w PalCycle_MTZ	; MTZ3
	zoneOffsetTableEntry.w PalCycle_WFZ	; WFZ
	zoneOffsetTableEntry.w PalCycle_HTZ	; HTZ
	zoneOffsetTableEntry.w PalCycle_HPZ	; HPZ
	zoneOffsetTableEntry.w PalCycle_Null	; Zone 9
	zoneOffsetTableEntry.w PalCycle_OOZ	; OOZ
	zoneOffsetTableEntry.w PalCycle_MCZ	; MCZ
	zoneOffsetTableEntry.w PalCycle_CNZ	; CNZ
	zoneOffsetTableEntry.w PalCycle_CPZ	; CPZ
	zoneOffsetTableEntry.w PalCycle_CPZ	; DEZ
	zoneOffsetTableEntry.w PalCycle_ARZ	; ARZ
	zoneOffsetTableEntry.w PalCycle_WFZ	; SCZ
    zoneTableEnd

; ===========================================================================
; return_1A16:
PalCycle_Null:
	rts
; ===========================================================================

PalCycle_EHZ:
	lea	(CyclingPal_EHZ_ARZ_Water).l,a0
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	.return
	move.w	#7,(PalCycle_Timer).w
	move.w	(PalCycle_Frame).w,d0
	addq.w	#1,(PalCycle_Frame).w
	andi.w	#3,d0
	lsl.w	#3,d0
	move.l	(a0,d0.w),(Normal_palette_line2+6).w
	move.l	4(a0,d0.w),(Normal_palette_line2+$1C).w

.return:
	rts
; ===========================================================================

; PalCycle_Level2:
PalCycle_WZ:
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	.return
	move.w	#2,(PalCycle_Timer).w
	lea	(CyclingPal_WoodConveyor).l,a0
	move.w	(PalCycle_Frame).w,d0
	subq.w	#2,(PalCycle_Frame).w
	bcc.s	+
	move.w	#6,(PalCycle_Frame).w
+	lea	(Normal_palette_line4+6).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)

.return:
	rts
; ===========================================================================

PalCycle_MTZ:
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	++
	move.w	#$11,(PalCycle_Timer).w
	lea	(CyclingPal_MTZ1).l,a0
	move.w	(PalCycle_Frame).w,d0
	addq.w	#2,(PalCycle_Frame).w
	cmpi.w	#$C,(PalCycle_Frame).w
	blo.s	+
	move.w	#0,(PalCycle_Frame).w
+	lea	(Normal_palette_line3+$A).w,a1
	move.w	(a0,d0.w),(a1)
+
	subq.w	#1,(PalCycle_Timer2).w
	bpl.s	++
	move.w	#2,(PalCycle_Timer2).w
	lea	(CyclingPal_MTZ2).l,a0
	move.w	(PalCycle_Frame2).w,d0
	addq.w	#2,(PalCycle_Frame2).w
	cmpi.w	#6,(PalCycle_Frame2).w
	blo.s	+
	move.w	#0,(PalCycle_Frame2).w
+	lea	(Normal_palette_line3+2).w,a1
	move.l	(a0,d0.w),(a1)+
	move.w	4(a0,d0.w),(a1)
+
	subq.w	#1,(PalCycle_Timer3).w
	bpl.s	.return
	move.w	#9,(PalCycle_Timer3).w
	lea	(CyclingPal_MTZ3).l,a0
	move.w	(PalCycle_Frame3).w,d0
	addq.w	#2,(PalCycle_Frame3).w
	cmpi.w	#$14,(PalCycle_Frame3).w
	blo.s	+
	move.w	#0,(PalCycle_Frame3).w
+	lea	(Normal_palette_line3+$1E).w,a1
	move.w	(a0,d0.w),(a1)

.return:
	rts
; ===========================================================================

PalCycle_HTZ:
	lea	(CyclingPal_Lava).l,a0
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	.return
	move.w	#0,(PalCycle_Timer).w
	move.w	(PalCycle_Frame).w,d0
	addq.w	#1,(PalCycle_Frame).w
	andi.w	#$F,d0
	move.b	PalCycle_HTZ_LavaDelayData(pc,d0.w),(PalCycle_Timer+1).w
	lsl.w	#3,d0
	move.l	(a0,d0.w),(Normal_palette_line2+6).w
	move.l	4(a0,d0.w),(Normal_palette_line2+$1C).w

.return:
	rts
; ===========================================================================
; byte_1B40:
PalCycle_HTZ_LavaDelayData: ; number of frames between changes of the lava palette
	dc.b	$B, $B, $B, $A
	dc.b	 8, $A, $B, $B
	dc.b	$B, $B, $D, $F
	dc.b	$D, $B, $B, $B
	even
; ===========================================================================

PalCycle_HPZ:
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	.return
	move.w	#4,(PalCycle_Timer).w
	lea	(CyclingPal_HPZWater).l,a0
	move.w	(PalCycle_Frame).w,d0
	subq.w	#2,(PalCycle_Frame).w
	bcc.s	+
	move.w	#6,(PalCycle_Frame).w
+	lea	(Normal_palette_line4+$12).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
	lea	(CyclingPal_HPZUnderwater).l,a0
	lea	(Underwater_palette_line4+$12).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)

.return:
	rts
; ===========================================================================

PalCycle_OOZ:
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	.return
	move.w	#7,(PalCycle_Timer).w
	lea	(CyclingPal_Oil).l,a0
	move.w	(PalCycle_Frame).w,d0
	addq.w	#2,(PalCycle_Frame).w
	andi.w	#6,(PalCycle_Frame).w
	lea	(Normal_palette_line3+$14).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)

.return:
	rts
; ===========================================================================

PalCycle_MCZ:
	tst.b	(Current_Boss_ID).w
	bne.s	.return
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	.return
	move.w	#1,(PalCycle_Timer).w
	lea	(CyclingPal_Lantern).l,a0
	move.w	(PalCycle_Frame).w,d0
	addq.w	#2,(PalCycle_Frame).w
	andi.w	#6,(PalCycle_Frame).w
	move.w	(a0,d0.w),(Normal_palette_line2+$16).w

.return:
	rts
; ===========================================================================

PalCycle_CNZ:
	subq.w	#1,(PalCycle_Timer).w
	bpl.w	CNZ_SkipToBossPalCycle
	move.w	#7,(PalCycle_Timer).w
	lea	(CyclingPal_CNZ1).l,a0
	move.w	(PalCycle_Frame).w,d0
	addq.w	#2,(PalCycle_Frame).w
	cmpi.w	#6,(PalCycle_Frame).w
	blo.s	+
	move.w	#0,(PalCycle_Frame).w
+
	lea	(a0,d0.w),a0
	lea	(Normal_palette).w,a1
	_move.w	0(a0),$4A(a1)
	move.w	6(a0),$4C(a1)
	move.w	$C(a0),$4E(a1)
	move.w	$12(a0),$56(a1)
	move.w	$18(a0),$58(a1)
	move.w	$1E(a0),$5A(a1)
	lea	(CyclingPal_CNZ3).l,a0
	lea	(a0,d0.w),a0
	_move.w	0(a0),$64(a1)
	move.w	6(a0),$66(a1)
	move.w	$C(a0),$68(a1)
	lea	(CyclingPal_CNZ4).l,a0
	move.w	(PalCycle_Frame_CNZ).w,d0
	addq.w	#2,(PalCycle_Frame_CNZ).w
	cmpi.w	#$24,(PalCycle_Frame_CNZ).w
	blo.s	+
	move.w	#0,(PalCycle_Frame_CNZ).w
+
	lea	(Normal_palette_line4+$12).w,a1
	move.w	4(a0,d0.w),(a1)+
	move.w	2(a0,d0.w),(a1)+
	move.w	(a0,d0.w),(a1)+

CNZ_SkipToBossPalCycle:
	tst.b	(Current_Boss_ID).w
	beq.w	+++	; rts
	subq.w	#1,(PalCycle_Timer2).w
	bpl.w	+++	; rts
	move.w	#3,(PalCycle_Timer2).w
	move.w	(PalCycle_Frame2).w,d0
	addq.w	#2,(PalCycle_Frame2).w
	cmpi.w	#6,(PalCycle_Frame2).w
	blo.s	+
	move.w	#0,(PalCycle_Frame2).w
+	lea	(CyclingPal_CNZ1_B).l,a0
	lea	(a0,d0.w),a0
	lea	(Normal_palette).w,a1
	_move.w	0(a0),$24(a1)
	move.w	6(a0),$26(a1)
	move.w	$C(a0),$28(a1)
	lea	(CyclingPal_CNZ2_B).l,a0
	move.w	(PalCycle_Frame3).w,d0
	addq.w	#2,(PalCycle_Frame3).w
	cmpi.w	#$14,(PalCycle_Frame3).w
	blo.s	+
	move.w	#0,(PalCycle_Frame3).w
+	move.w	(a0,d0.w),$3C(a1)
	lea	(CyclingPal_CNZ3_B).l,a0
	move.w	(PalCycle_Frame2_CNZ).w,d0
	addq.w	#2,(PalCycle_Frame2_CNZ).w
	andi.w	#$E,(PalCycle_Frame2_CNZ).w
	move.w	(a0,d0.w),$3E(a1)
+	rts
; ===========================================================================

PalCycle_CPZ:
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	.return
	move.w	#7,(PalCycle_Timer).w
	lea	(CyclingPal_CPZ1).l,a0
	move.w	(PalCycle_Frame).w,d0
	addq.w	#6,(PalCycle_Frame).w
	cmpi.w	#$36,(PalCycle_Frame).w
	blo.s	+
	move.w	#0,(PalCycle_Frame).w
+	lea	(Normal_palette_line4+$18).w,a1
	move.l	(a0,d0.w),(a1)+
	move.w	4(a0,d0.w),(a1)
	lea	(CyclingPal_CPZ2).l,a0
	move.w	(PalCycle_Frame2).w,d0
	addq.w	#2,(PalCycle_Frame2).w
	cmpi.w	#$2A,(PalCycle_Frame2).w
	blo.s	+
	move.w	#0,(PalCycle_Frame2).w
+	move.w	(a0,d0.w),(Normal_palette_line4+$1E).w
	lea	(CyclingPal_CPZ3).l,a0
	move.w	(PalCycle_Frame3).w,d0
	addq.w	#2,(PalCycle_Frame3).w
	andi.w	#$1E,(PalCycle_Frame3).w
	move.w	(a0,d0.w),(Normal_palette_line3+$1E).w

.return:
	rts
; ===========================================================================

PalCycle_ARZ:
	lea	(CyclingPal_EHZ_ARZ_Water).l,a0
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	.return
	move.w	#5,(PalCycle_Timer).w
	move.w	(PalCycle_Frame).w,d0
	addq.w	#1,(PalCycle_Frame).w
	andi.w	#3,d0
	lsl.w	#3,d0
	lea	(Normal_palette_line3+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)

.return:
	rts
; ===========================================================================

PalCycle_WFZ:
	subq.w	#1,(PalCycle_Timer).w
	bpl.s	+++
	move.w	#1,(PalCycle_Timer).w
	lea	(CyclingPal_WFZFire).l,a0
	tst.b	(WFZ_SCZ_Fire_Toggle).w
	beq.s	+
	move.w	#5,(PalCycle_Timer).w
	lea	(CyclingPal_WFZBelt).l,a0
+	move.w	(PalCycle_Frame).w,d0
	addq.w	#8,(PalCycle_Frame).w
	cmpi.w	#$20,(PalCycle_Frame).w
	blo.s	+
	move.w	#0,(PalCycle_Frame).w
+	lea	(Normal_palette_line3+$E).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
+	subq.w	#1,(PalCycle_Timer2).w
	bpl.s	++	; subq.w
	move.w	#3,(PalCycle_Timer2).w
	lea	(CyclingPal_WFZ1).l,a0
	move.w	(PalCycle_Frame2).w,d0
	addq.w	#2,(PalCycle_Frame2).w
	cmpi.w	#$44,(PalCycle_Frame2).w
	blo.s	+	; move.w
	move.w	#0,(PalCycle_Frame2).w
+	move.w	(a0,d0.w),(Normal_palette_line3+$1C).w
+
	subq.w	#1,(PalCycle_Timer3).w
	bpl.s	.return
	move.w	#5,(PalCycle_Timer3).w
	lea	(CyclingPal_WFZ2).l,a0
	move.w	(PalCycle_Frame3).w,d0
	addq.w	#2,(PalCycle_Frame3).w
	cmpi.w	#$18,(PalCycle_Frame3).w
	blo.s	+
	move.w	#0,(PalCycle_Frame3).w
+	move.w	(a0,d0.w),(Normal_palette_line3+$1E).w

.return:
	rts
; ===========================================================================

; ----------------------------------------------------------------------------
; word_1E5A:
	BINCLUDE "art/palettes/Title Water.bin"; S1 Title Screen Water palette (unused)
; word_1E7A:
CyclingPal_EHZ_ARZ_Water:
	BINCLUDE "art/palettes/EHZ ARZ Water.bin"; Emerald Hill/Aquatic Ruin Rotating Water palette
; word_1E9A:
CyclingPal_Lava:
	BINCLUDE "art/palettes/Hill Top Lava.bin"; Hill Top Lava palette
; word_1F1A:
CyclingPal_WoodConveyor:
	BINCLUDE "art/palettes/Wood Conveyor.bin"; Wood Conveyor Belts palette
; byte_1F2A:
CyclingPal_MTZ1:
	BINCLUDE "art/palettes/MTZ Cycle 1.bin"; Metropolis Cycle #1 palette
; word_1F36:
CyclingPal_MTZ2:
	BINCLUDE "art/palettes/MTZ Cycle 2.bin"; Metropolis Cycle #2 palette
; word_1F42:
CyclingPal_MTZ3:
	BINCLUDE "art/palettes/MTZ Cycle 3.bin"; Metropolis Cycle #3 palette
; word_1F56:
CyclingPal_HPZWater:
	BINCLUDE "art/palettes/HPZ Water Cycle.bin"; Hidden Palace Water Cycle
; word_1F66:
CyclingPal_HPZUnderwater:
	BINCLUDE "art/palettes/HPZ Underwater Cycle.bin"; Hidden Palace Underwater Cycle
; word_1F76:
CyclingPal_Oil:
	BINCLUDE "art/palettes/OOZ Oil.bin"; Oil Ocean Oil palette
; word_1F86:
CyclingPal_Lantern:
	BINCLUDE "art/palettes/MCZ Lantern.bin"; Mystic Cave Lanterns
; word_1F8E:
CyclingPal_CNZ1:
	BINCLUDE "art/palettes/CNZ Cycle 1.bin"; Casino Night Cycles 1 & 2
; word_1FB2:
CyclingPal_CNZ3:
	BINCLUDE "art/palettes/CNZ Cycle 3.bin"; Casino Night Cycle 3
; word_1FC4:
CyclingPal_CNZ4:
	BINCLUDE "art/palettes/CNZ Cycle 4.bin"; Casino Night Cycle 4
; word_1FEC:
CyclingPal_CNZ1_B:
	BINCLUDE "art/palettes/CNZ Boss Cycle 1.bin"; Casino Night Boss Cycle 1
; word_1FFE:
CyclingPal_CNZ2_B:
	BINCLUDE "art/palettes/CNZ Boss Cycle 2.bin"; Casino Night Boss Cycle 2
; word_2012:
CyclingPal_CNZ3_B:
	BINCLUDE "art/palettes/CNZ Boss Cycle 3.bin"; Casino Night Boss Cycle 3
; word_2022:
CyclingPal_CPZ1:
	BINCLUDE "art/palettes/CPZ Cycle 1.bin"; Chemical Plant Cycle 1
; word_2058:
CyclingPal_CPZ2:
	BINCLUDE "art/palettes/CPZ Cycle 2.bin"; Chemical Plant Cycle 2
; word_2082:
CyclingPal_CPZ3:
	BINCLUDE "art/palettes/CPZ Cycle 3.bin"; Chemical Plant Cycle 3
; word_20A2:
CyclingPal_WFZFire:
	BINCLUDE "art/palettes/WFZ Fire Cycle.bin"; Wing Fortress Fire Cycle palette
; word_20C2:
CyclingPal_WFZBelt:
	BINCLUDE "art/palettes/WFZ Conveyor Cycle.bin"; Wing Fortress Conveyor Belt Cycle palette
; word_20E2: CyclingPal_CPZ4:
CyclingPal_WFZ1:
	BINCLUDE "art/palettes/WFZ Cycle 1.bin"; Wing Fortress Flashing Light Cycle 1
; word_2126:
CyclingPal_WFZ2:
	BINCLUDE "art/palettes/WFZ Cycle 2.bin"; Wing Fortress Flashing Light Cycle 2
; ----------------------------------------------------------------------------


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_213E:
PalCycle_SuperSonic:
	move.b	(Super_Sonic_palette).w,d0
	beq.s	.return	; return, if Sonic isn't super
	bmi.w	.normal	; branch, if fade-in is done
	subq.b	#1,d0
	bne.s	.revert	; branch for values greater than 1

	; fade from Sonic's to Super Sonic's palette
	; run frame timer
	subq.b	#1,(Palette_timer).w
	bpl.s	.return
	move.b	#3,(Palette_timer).w

	; increment palette frame and update Sonic's palette
	lea	(CyclingPal_SSTransformation).l,a0
	move.w	(Palette_frame).w,d0
	addq.w	#8,(Palette_frame).w	; 1 palette entry = 1 word, Sonic uses 4 shades of blue
	cmpi.w	#$30,(Palette_frame).w	; has palette cycle reached the 6th frame?
	blo.s	+			; if not, branch
	move.b	#-1,(Super_Sonic_palette).w	; mark fade-in as done
	move.b	#0,(MainCharacter+obj_control).w	; restore Sonic's movement
+
	lea	(Normal_palette+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
    if fixBugs
	; underwater palettes
	lea	(CyclingPal_CPZUWTransformation).l,a0
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	beq.s	+
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	.return
	lea	(CyclingPal_ARZUWTransformation).l,a0
+	lea	(Underwater_palette+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
    else
	; Note: The fade in for Sonic's underwater palette is missing.
	; Because of this, Super Sonic's transformation will be uncorrect
	; when underwater.
    endif
.return:
	rts
; ===========================================================================
; loc_2188: PalCycle_SuperSonic_revert:
.revert:	; runs the fade in transition backwards
	; run frame timer
	subq.b	#1,(Palette_timer).w
	bpl.s	.return
	move.b	#3,(Palette_timer).w

	; decrement palette frame and update Sonic's palette
	lea	(CyclingPal_SSTransformation).l,a0
	move.w	(Palette_frame).w,d0
	subq.w	#8,(Palette_frame).w	; previous frame
	bcc.s	+			; branch, if it isn't the first frame
    if fixBugs
	move.w	#0,(Palette_frame).w
    else
	; This does not clear the full variable, causing this palette cycle
	; to behave incorrectly the next time it is activated.
	move.b	#0,(Palette_frame).w
    endif
	move.b	#0,(Super_Sonic_palette).w	; stop palette cycle
+
	lea	(Normal_palette+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
	; underwater palettes
	lea	(CyclingPal_CPZUWTransformation).l,a0
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	beq.s	+
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	.return
	lea	(CyclingPal_ARZUWTransformation).l,a0
+	lea	(Underwater_palette+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
	rts
; ===========================================================================
; loc_21E6: PalCycle_SuperSonic_normal:
.normal:
	; run frame timer
	subq.b	#1,(Palette_timer).w
	bpl.s	.return
	move.b	#7,(Palette_timer).w

	; increment palette frame and update Sonic's palette
	lea	(CyclingPal_SSTransformation).l,a0
	move.w	(Palette_frame).w,d0
	addq.w	#8,(Palette_frame).w	; next frame
	cmpi.w	#$78,(Palette_frame).w	; is it the last frame?
    if fixBugs
	bls.s	+			; if not, branch
    else
	; This condition causes the last frame to be skipped.
	blo.s	+			; if not, branch
    endif
	move.w	#$30,(Palette_frame).w	; reset frame counter (Super Sonic's normal palette cycle starts at $30. Everything before that is for the palette fade)
+
	lea	(Normal_palette+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
	; underwater palettes
	lea	(CyclingPal_CPZUWTransformation).l,a0
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	beq.s	+
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.w	.return
	lea	(CyclingPal_ARZUWTransformation).l,a0
+	lea	(Underwater_palette+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
	rts
; End of function PalCycle_SuperSonic

; ===========================================================================
;----------------------------------------------------------------------------
;Palette for transformation to Super Sonic
;----------------------------------------------------------------------------
; Pal_2246:
CyclingPal_SSTransformation:
	BINCLUDE	"art/palettes/Super Sonic transformation.bin"
;----------------------------------------------------------------------------
;Palette for transformation to Super Sonic while underwater in CPZ
;----------------------------------------------------------------------------
; Pal_22C6:
CyclingPal_CPZUWTransformation:
	BINCLUDE	"art/palettes/CPZWater SS transformation.bin"
;----------------------------------------------------------------------------
;Palette for transformation to Super Sonic while underwater in ARZ
;----------------------------------------------------------------------------
; Pal_2346:
CyclingPal_ARZUWTransformation:
	BINCLUDE	"art/palettes/ARZWater SS transformation.bin"
