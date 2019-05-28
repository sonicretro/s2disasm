; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_213E:
PalCycle_SuperSonic:
	move.b	(Super_Sonic_palette).w,d0
	beq.s	++	; rts	; return, if Sonic isn't super
	bmi.w	PalCycle_SuperSonic_normal	; branch, if fade-in is done
	subq.b	#1,d0
	bne.s	PalCycle_SuperSonic_revert	; branch for values greater than 1

	; fade from Sonic's to Super Sonic's palette
	; run frame timer
	subq.b	#1,(Palette_timer).w
	bpl.s	++	; rts
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
	; note: the fade in for Sonic's underwater palette is missing.
	; branch to the code below (*) to fix this
/	rts
; ===========================================================================
; loc_2188:
PalCycle_SuperSonic_revert:	; runs the fade in transition backwards
	; run frame timer
	subq.b	#1,(Palette_timer).w
	bpl.s	-	; rts
	move.b	#3,(Palette_timer).w

	; decrement palette frame and update Sonic's palette
	lea	(CyclingPal_SSTransformation).l,a0
	move.w	(Palette_frame).w,d0
	subq.w	#8,(Palette_frame).w	; previous frame
	bcc.s	+			; branch, if it isn't the first frame
	move.b	#0,(Palette_frame).w
	move.b	#0,(Super_Sonic_palette).w	; stop palette cycle
+
	lea	(Normal_palette+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
	; underwater palettes (*)
	lea	(CyclingPal_CPZUWTransformation).l,a0
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	beq.s	+
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	-	; rts
	lea	(CyclingPal_ARZUWTransformation).l,a0
+	lea	(Underwater_palette+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
	rts
; ===========================================================================
; loc_21E6:
PalCycle_SuperSonic_normal:
	; run frame timer
	subq.b	#1,(Palette_timer).w
	bpl.s	-	; rts
	move.b	#7,(Palette_timer).w

	; increment palette frame and update Sonic's palette
	lea	(CyclingPal_SSTransformation).l,a0
	move.w	(Palette_frame).w,d0
	addq.w	#8,(Palette_frame).w	; next frame
	cmpi.w	#$78,(Palette_frame).w	; is it the last frame?
	blo.s	+			; if not, branch
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
	bne.w	-	; rts
	lea	(CyclingPal_ARZUWTransformation).l,a0
+	lea	(Underwater_palette+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
	rts
; End of function PalCycle_SuperSonic