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

; ---------------------------------------------------------------------------
; Subroutine to fade in from black
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_23C6: Pal_FadeTo:
Pal_FadeFromBlack:
	move.w	#$3F,(Palette_fade_range).w
	moveq	#0,d0
	lea	(Normal_palette).w,a0
	move.b	(Palette_fade_start).w,d0
	adda.w	d0,a0
	moveq	#0,d1
	move.b	(Palette_fade_length).w,d0
; loc_23DE: Pal_ToBlack:
.palettewrite:
	move.w	d1,(a0)+
	dbf	d0,.palettewrite	; fill palette with $000 (black)

	move.w	#$15,d4

.nextframe:
	move.b	#VintID_Fade,(Vint_routine).w
	bsr.w	WaitForVint
	bsr.s	.UpdateAllColours
	bsr.w	RunPLC_RAM
	dbf	d4,.nextframe

	rts
; End of function Pal_FadeFromBlack

; ---------------------------------------------------------------------------
; Subroutine to update all colours once
; ---------------------------------------------------------------------------
; sub_23FE: Pal_FadeIn:
.UpdateAllColours:
	; Update above-water palette
	moveq	#0,d0
	lea	(Normal_palette).w,a0
	lea	(Target_palette).w,a1
	move.b	(Palette_fade_start).w,d0
	adda.w	d0,a0
	adda.w	d0,a1

	move.b	(Palette_fade_length).w,d0

.nextcolour:
	bsr.s	.UpdateColour
	dbf	d0,.nextcolour

	tst.b	(Water_flag).w
	beq.s	.skipunderwater
	; Update underwater palette
	moveq	#0,d0
	lea	(Underwater_palette).w,a0
	lea	(Underwater_target_palette).w,a1
	move.b	(Palette_fade_start).w,d0
	adda.w	d0,a0
	adda.w	d0,a1

	move.b	(Palette_fade_length).w,d0

.nextcolour2:
	bsr.s	.UpdateColour
	dbf	d0,.nextcolour2

.skipunderwater:
	rts

; ---------------------------------------------------------------------------
; Subroutine to update a single colour once
; ---------------------------------------------------------------------------
; sub_243E: Pal_AddColor:
.UpdateColour:
	move.w	(a1)+,d2
	move.w	(a0),d3
	cmp.w	d2,d3
	beq.s	.updatenone

;.updateblue:
	move.w	d3,d1
	addi.w	#$200,d1	; increase blue value
	cmp.w	d2,d1		; has blue reached threshold level?
	bhi.s	.updategreen	; if yes, branch
	move.w	d1,(a0)+	; update palette
	rts

; loc_2454: Pal_AddGreen:
.updategreen:
	move.w	d3,d1
	addi.w	#$20,d1		; increase green value
	cmp.w	d2,d1
	bhi.s	.updatered
	move.w	d1,(a0)+	; update palette
	rts

; loc_2462: Pal_AddRed:
.updatered:
	addq.w	#2,(a0)+	; increase red value
	rts

; loc_2466: Pal_AddNone:
.updatenone:
	addq.w	#2,a0
	rts


; ---------------------------------------------------------------------------
; Subroutine to fade out to black
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_246A: Pal_FadeFrom:
Pal_FadeToBlack:
	move.w	#$3F,(Palette_fade_range).w

	move.w	#$15,d4

.nextframe:
	move.b	#VintID_Fade,(Vint_routine).w
	bsr.w	WaitForVint
	bsr.s	.UpdateAllColours
	bsr.w	RunPLC_RAM
	dbf	d4,.nextframe

	rts
; End of function Pal_FadeToBlack

; ---------------------------------------------------------------------------
; Subroutine to update all colours once
; ---------------------------------------------------------------------------
; sub_248A: Pal_FadeOut:
.UpdateAllColours:
	; Update above-water palette
	moveq	#0,d0
	lea	(Normal_palette).w,a0
	move.b	(Palette_fade_start).w,d0
	adda.w	d0,a0

	move.b	(Palette_fade_length).w,d0
.nextcolour:
	bsr.s	.UpdateColour
	dbf	d0,.nextcolour

	; Notice how this one lacks a check for
	; if Water_flag is set, unlike Pal_FadeFromBlack?

	; Update underwater palette
	moveq	#0,d0
	lea	(Underwater_palette).w,a0
	move.b	(Palette_fade_start).w,d0
	adda.w	d0,a0

	move.b	(Palette_fade_length).w,d0
.nextcolour2:
	bsr.s	.UpdateColour
	dbf	d0,.nextcolour2

	rts

; ---------------------------------------------------------------------------
; Subroutine to update a single colour once
; ---------------------------------------------------------------------------
; sub_24B8: Pal_DecColor:
.UpdateColour:
	move.w	(a0),d2
	beq.s	.updatenone
;.updatered:
	move.w	d2,d1
	andi.w	#$E,d1
	beq.s	.updategreen
	subq.w	#2,(a0)+	; decrease red value
	rts

; loc_24C8: Pal_DecGreen:
.updategreen:
	move.w	d2,d1
	andi.w	#$E0,d1
	beq.s	.updateblue
	subi.w	#$20,(a0)+	; decrease green value
	rts

; loc_24D6: Pal_DecBlue:
.updateblue:
	move.w	d2,d1
	andi.w	#$E00,d1
	beq.s	.updatenone
	subi.w	#$200,(a0)+	; decrease blue value
	rts

; loc_24E4: Pal_DecNone:
.updatenone:
	addq.w	#2,a0
	rts


; ---------------------------------------------------------------------------
; Subroutine to fade in from white
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_24E8: Pal_MakeWhite:
Pal_FadeFromWhite:
	move.w	#$3F,(Palette_fade_range).w
	moveq	#0,d0
	lea	(Normal_palette).w,a0
	move.b	(Palette_fade_start).w,d0
	adda.w	d0,a0
	move.w	#$EEE,d1

	move.b	(Palette_fade_length).w,d0

.palettewrite:
	move.w	d1,(a0)+
	dbf	d0,.palettewrite

	move.w	#$15,d4

.nextframe:
	move.b	#VintID_Fade,(Vint_routine).w
	bsr.w	WaitForVint
	bsr.s	.UpdateAllColours
	bsr.w	RunPLC_RAM
	dbf	d4,.nextframe

	rts
; End of function Pal_FadeFromWhite

; ---------------------------------------------------------------------------
; Subroutine to update all colours once
; ---------------------------------------------------------------------------
; sub_2522: Pal_WhiteToBlack:
.UpdateAllColours:
	; Update above-water palette
	moveq	#0,d0
	lea	(Normal_palette).w,a0
	lea	(Target_palette).w,a1
	move.b	(Palette_fade_start).w,d0
	adda.w	d0,a0
	adda.w	d0,a1

	move.b	(Palette_fade_length).w,d0

.nextcolour:
	bsr.s	.UpdateColour
	dbf	d0,.nextcolour

	tst.b	(Water_flag).w
	beq.s	.skipunderwater
	; Update underwater palette
	moveq	#0,d0
	lea	(Underwater_palette).w,a0
	lea	(Underwater_target_palette).w,a1
	move.b	(Palette_fade_start).w,d0
	adda.w	d0,a0
	adda.w	d0,a1

	move.b	(Palette_fade_length).w,d0

.nextcolour2:
	bsr.s	.UpdateColour
	dbf	d0,.nextcolour2

.skipunderwater:
	rts

; ---------------------------------------------------------------------------
; Subroutine to update a single colour once
; ---------------------------------------------------------------------------
; sub_2562: Pal_DecColor2:
.UpdateColour:
	move.w	(a1)+,d2
	move.w	(a0),d3
	cmp.w	d2,d3
	beq.s	.updatenone
;.updateblue:
	move.w	d3,d1
	subi.w	#$200,d1	; decrease blue value
	bcs.s	.updategreen
	cmp.w	d2,d1
	blo.s	.updategreen
	move.w	d1,(a0)+
	rts

; loc_257A: Pal_DecGreen2:
.updategreen:
	move.w	d3,d1
	subi.w	#$20,d1	; decrease green value
	bcs.s	.updatered
	cmp.w	d2,d1
	blo.s	.updatered
	move.w	d1,(a0)+
	rts

; loc_258A: Pal_DecRed2:
.updatered:
	subq.w	#2,(a0)+	; decrease red value
	rts

; loc_258E: Pal_DecNone2:
.updatenone:
	addq.w	#2,a0
	rts


; ---------------------------------------------------------------------------
; Subroutine to fade out to white (used when you enter a special stage)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_2592: Pal_MakeFlash:
Pal_FadeToWhite:
	move.w	#$3F,(Palette_fade_range).w

	move.w	#$15,d4

.nextframe:
	move.b	#VintID_Fade,(Vint_routine).w
	bsr.w	WaitForVint
	bsr.s	.UpdateAllColours
	bsr.w	RunPLC_RAM
	dbf	d4,.nextframe

	rts
; End of function Pal_FadeToWhite

; ---------------------------------------------------------------------------
; Subroutine to update all colours once
; ---------------------------------------------------------------------------
; sub_25B2: Pal_ToWhite:
.UpdateAllColours:
	; Update above-water palette
	moveq	#0,d0
	lea	(Normal_palette).w,a0
	move.b	(Palette_fade_start).w,d0
	adda.w	d0,a0

	move.b	(Palette_fade_length).w,d0

.nextcolour:
	bsr.s	.UpdateColour
	dbf	d0,.nextcolour

	; Notice how this one lacks a check for
	; if Water_flag is set, unlike Pal_FadeFromWhite?

	; Update underwater palette
	moveq	#0,d0
	lea	(Underwater_palette).w,a0
	move.b	(Palette_fade_start).w,d0
	adda.w	d0,a0

	move.b	(Palette_fade_length).w,d0

.nextcolour2:
	bsr.s	.UpdateColour
	dbf	d0,.nextcolour2

	rts

; ---------------------------------------------------------------------------
; Subroutine to update a single colour once
; ---------------------------------------------------------------------------
; sub_25E0: Pal_AddColor2:
.UpdateColour:
	move.w	(a0),d2
	cmpi.w	#$EEE,d2
	beq.s	.updatenone
;.updatered:
	move.w	d2,d1
	andi.w	#$E,d1
	cmpi.w	#$E,d1
	beq.s	.updategreen
	addq.w	#2,(a0)+	; increase red value
	rts

; loc_25F8: Pal_AddGreen2:
.updategreen:
	move.w	d2,d1
	andi.w	#$E0,d1
	cmpi.w	#$E0,d1
	beq.s	.updateblue
	addi.w	#$20,(a0)+	; increase green value
	rts

; loc_260A: Pal_AddBlue2:
.updateblue:
	move.w	d2,d1
	andi.w	#$E00,d1
	cmpi.w	#$E00,d1
	beq.s	.updatenone
	addi.w	#$200,(a0)+	; increase blue value
	rts

; loc_261C: Pal_AddNone2:
.updatenone:
	addq.w	#2,a0
	rts
; End of function Pal_AddColor2


; Unused - dead code/data for old SEGA screen:

; ===========================================================================
; PalCycle_Sega:
	tst.b	(PalCycle_Timer+1).w
	bne.s	loc_2680
	lea	(Normal_palette_line2).w,a1
	lea	(Pal_Sega1).l,a0
	moveq	#5,d1
	move.w	(PalCycle_Frame).w,d0

loc_2636:
	bpl.s	loc_2640
	addq.w	#2,a0
	subq.w	#1,d1
	addq.w	#2,d0
	bra.s	loc_2636
; ===========================================================================

loc_2640:
	move.w	d0,d2
	andi.w	#$1E,d2
	bne.s	loc_264A
	addq.w	#2,d0

loc_264A:
	cmpi.w	#$60,d0
	bhs.s	loc_2654
	move.w	(a0)+,(a1,d0.w)

loc_2654:
	addq.w	#2,d0
	dbf	d1,loc_2640
	move.w	(PalCycle_Frame).w,d0
	addq.w	#2,d0
	move.w	d0,d2
	andi.w	#$1E,d2
	bne.s	loc_266A
	addq.w	#2,d0

loc_266A:
	cmpi.w	#$64,d0
	blt.s	loc_2678
	move.w	#$401,(PalCycle_Timer).w
	moveq	#-$C,d0

loc_2678:
	move.w	d0,(PalCycle_Frame).w
	moveq	#1,d0
	rts
; ===========================================================================

loc_2680:
	subq.b	#1,(PalCycle_Timer).w
	bpl.s	loc_26D2
	move.b	#4,(PalCycle_Timer).w
	move.w	(PalCycle_Frame).w,d0
	addi.w	#$C,d0
	cmpi.w	#$30,d0
	blo.s	loc_269E
	moveq	#0,d0
	rts
; ===========================================================================

loc_269E:
	move.w	d0,(PalCycle_Frame).w
	lea	(Pal_Sega2).l,a0
	lea	(a0,d0.w),a0
	lea	(Normal_palette+4).w,a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.w	(a0)+,(a1)
	lea	(Normal_palette_line2).w,a1
	moveq	#0,d0
	moveq	#$2C,d1

loc_26BE:
	move.w	d0,d2
	andi.w	#$1E,d2
	bne.s	loc_26C8
	addq.w	#2,d0

loc_26C8:
	move.w	(a0),(a1,d0.w)
	addq.w	#2,d0
	dbf	d1,loc_26BE

loc_26D2:
	moveq	#1,d0
	rts

; ===========================================================================
;----------------------------------------------------------------------------
; Unused palette for the Sega logo
;----------------------------------------------------------------------------
; Pal_26D6:
Pal_Sega1:	BINCLUDE	"art/palettes/Unused Sega logo.bin"
;----------------------------------------------------------------------------
; Unused palette for the Sega logo (fading?)
;----------------------------------------------------------------------------
; Pal_26E2:
Pal_Sega2:	BINCLUDE	"art/palettes/Unused Sega logo 2.bin"

; end of dead code/data

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_2712: PalLoad1:
PalLoad_ForFade:
	lea	(PalPointers).l,a1
	lsl.w	#3,d0
	adda.w	d0,a1
	movea.l	(a1)+,a2
	movea.w	(a1)+,a3
	adda.w	#Target_palette-Normal_palette,a3

	move.w	(a1)+,d7
-	move.l	(a2)+,(a3)+
	dbf	d7,-

	rts
; End of function PalLoad_ForFade


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_272E: PalLoad2:
PalLoad_Now:
	lea	(PalPointers).l,a1
	lsl.w	#3,d0
	adda.w	d0,a1
	movea.l	(a1)+,a2
	movea.w	(a1)+,a3

	move.w	(a1)+,d7
-	move.l	(a2)+,(a3)+
	dbf	d7,-

	rts
; End of function PalLoad_Now


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_2746: PalLoad3_Water:
PalLoad_Water_Now:
	lea	(PalPointers).l,a1
	lsl.w	#3,d0
	adda.w	d0,a1
	movea.l	(a1)+,a2
	movea.w	(a1)+,a3
	suba.l	#Normal_palette-Underwater_palette,a3

	move.w	(a1)+,d7
-	move.l	(a2)+,(a3)+
	dbf	d7,-

	rts
; End of function PalLoad_Water_Now


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_2764: PalLoad4_Water:
PalLoad_Water_ForFade:
	lea	(PalPointers).l,a1
	lsl.w	#3,d0
	adda.w	d0,a1
	movea.l	(a1)+,a2
	movea.w	(a1)+,a3
	suba.l	#Normal_palette-Underwater_target_palette,a3

	move.w	(a1)+,d7
-	move.l	(a2)+,(a3)+
	dbf	d7,-

	rts
; End of function PalLoad_Water_ForFade

; ===========================================================================
;----------------------------------------------------------------------------
; Palette pointers
; (PALETTE DESCRIPTOR ARRAY)
; This struct array defines the palette to use for each level.
;----------------------------------------------------------------------------

palptr	macro	ptr,lineno
	dc.l ptr	; Pointer to palette
	dc.w (Normal_palette+lineno*palette_line_size)&$FFFF	; Location in ram to load palette into
	dc.w bytesToLcnt(ptr_End-ptr)	; Size of palette in (bytes / 4)
	endm

PalPointers:
PalPtr_SEGA:	palptr Pal_SEGA,  0
PalPtr_Title:	palptr Pal_Title, 1
PalPtr_MenuB:	palptr Pal_MenuB, 0
PalPtr_BGND:	palptr Pal_BGND,  0
PalPtr_EHZ:	palptr Pal_EHZ,   1
PalPtr_EHZ2:	palptr Pal_EHZ,   1
PalPtr_WZ:	palptr Pal_WZ,    1
PalPtr_EHZ3:	palptr Pal_EHZ,   1
PalPtr_MTZ:	palptr Pal_MTZ,   1
PalPtr_MTZ2:	palptr Pal_MTZ,   1
PalPtr_WFZ:	palptr Pal_WFZ,   1
PalPtr_HTZ:	palptr Pal_HTZ,   1
PalPtr_HPZ:	palptr Pal_HPZ,   1
PalPtr_EHZ4:	palptr Pal_EHZ,   1
PalPtr_OOZ:	palptr Pal_OOZ,   1
PalPtr_MCZ:	palptr Pal_MCZ,   1
PalPtr_CNZ:	palptr Pal_CNZ,   1
PalPtr_CPZ:	palptr Pal_CPZ,   1
PalPtr_DEZ:	palptr Pal_DEZ,   1
PalPtr_ARZ:	palptr Pal_ARZ,   1
PalPtr_SCZ:	palptr Pal_SCZ,   1
PalPtr_HPZ_U:	palptr Pal_HPZ_U, 0
PalPtr_CPZ_U:	palptr Pal_CPZ_U, 0
PalPtr_ARZ_U:	palptr Pal_ARZ_U, 0
PalPtr_SS:	palptr Pal_SS,    0
PalPtr_MCZ_B:	palptr Pal_MCZ_B, 1
PalPtr_CNZ_B:	palptr Pal_CNZ_B, 1
PalPtr_SS1:	palptr Pal_SS1,   3
PalPtr_SS2:	palptr Pal_SS2,   3
PalPtr_SS3:	palptr Pal_SS3,   3
PalPtr_SS4:	palptr Pal_SS4,   3
PalPtr_SS5:	palptr Pal_SS5,   3
PalPtr_SS6:	palptr Pal_SS6,   3
PalPtr_SS7:	palptr Pal_SS7,   3
PalPtr_SS1_2p:	palptr Pal_SS1_2p,3
PalPtr_SS2_2p:	palptr Pal_SS2_2p,3
PalPtr_SS3_2p:	palptr Pal_SS3_2p,3
PalPtr_OOZ_B:	palptr Pal_OOZ_B, 1
PalPtr_Menu:	palptr Pal_Menu,  0
PalPtr_Result:	palptr Pal_Result,0

; ----------------------------------------------------------------------------
; This macro defines Pal_ABC and Pal_ABC_End, so palptr can compute the size of
; the palette automatically
; path2 is used for the Sonic and Tails palette, which has 2 palette lines
palette macro {INTLABEL},path,path2
__LABEL__ label *
	BINCLUDE "art/palettes/path"
    if "path2"<>""
	BINCLUDE "art/palettes/path2"
    endif
__LABEL___End label *
	endm

Pal_SEGA:  palette Sega screen.bin ; SEGA screen palette (Sonic and initial background)
Pal_Title: palette Title screen.bin ; Title screen Palette
Pal_MenuB: palette S2B Level Select.bin ; Leftover S2B level select palette
Pal_BGND:  palette SonicAndTails.bin,SonicAndTails2.bin ; "Sonic and Miles" background palette (also usually the primary palette line)
Pal_EHZ:   palette EHZ.bin ; Emerald Hill Zone palette
Pal_WZ:    palette Wood Zone.bin ; Wood Zone palette
Pal_MTZ:   palette MTZ.bin ; Metropolis Zone palette
Pal_WFZ:   palette WFZ.bin ; Wing Fortress Zone palette
Pal_HTZ:   palette HTZ.bin ; Hill Top Zone palette
Pal_HPZ:   palette HPZ.bin ; Hidden Palace Zone palette
Pal_HPZ_U: palette HPZ underwater.bin ; Hidden Palace Zone underwater palette
Pal_OOZ:   palette OOZ.bin ; Oil Ocean Zone palette
Pal_MCZ:   palette MCZ.bin ; Mystic Cave Zone palette
Pal_CNZ:   palette CNZ.bin ; Casino Night Zone palette
Pal_CPZ:   palette CPZ.bin ; Chemical Plant Zone palette
Pal_CPZ_U: palette CPZ underwater.bin ; Chemical Plant Zone underwater palette
Pal_DEZ:   palette DEZ.bin ; Death Egg Zone palette
Pal_ARZ:   palette ARZ.bin ; Aquatic Ruin Zone palette
Pal_ARZ_U: palette ARZ underwater.bin ; Aquatic Ruin Zone underwater palette
Pal_SCZ:   palette SCZ.bin ; Sky Chase Zone palette
Pal_MCZ_B: palette MCZ Boss.bin ; Mystic Cave Zone boss palette
Pal_CNZ_B: palette CNZ Boss.bin ; Casino Night Zone boss palette
Pal_OOZ_B: palette OOZ Boss.bin ; Oil Ocean Zone boss palette
Pal_Menu:  palette Menu.bin ; Menu palette
Pal_SS:    palette Special Stage Main.bin ; Special Stage palette
Pal_SS1:   palette Special Stage 1.bin ; Special Stage 1 palette
Pal_SS2:   palette Special Stage 2.bin ; Special Stage 2 palette
Pal_SS3:   palette Special Stage 3.bin ; Special Stage 3 palette
Pal_SS4:   palette Special Stage 4.bin ; Special Stage 4 palette
Pal_SS5:   palette Special Stage 5.bin ; Special Stage 5 palette
Pal_SS6:   palette Special Stage 6.bin ; Special Stage 6 palette
Pal_SS7:   palette Special Stage 7.bin ; Special Stage 7 palette
Pal_SS1_2p:palette Special Stage 1 2p.bin ; Special Stage 1 2p palette
Pal_SS2_2p:palette Special Stage 2 2p.bin ; Special Stage 2 2p palette
Pal_SS3_2p:palette Special Stage 3 2p.bin ; Special Stage 3 2p palette
Pal_Result:palette Special Stage Results Screen.bin ; Special Stage Results Screen palette
; ===========================================================================

    if gameRevision<2
	nop
    endif
