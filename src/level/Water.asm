; ---------------------------------------------------------------------------
; Subroutine to move the water or oil surface sprites to where the screen is at
; (the closest match I could find to this subroutine in Sonic 1 is Obj1B_Action)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_44E4:
UpdateWaterSurface:
	tst.b	(Water_flag).w
	beq.s	++	; rts
	move.w	(Camera_X_pos).w,d1
    if fixBugs
	; This function can cause the water surface's to be cut off at the
	; left when the game is paused. This is because this function pushes
	; the water surface sprite to the right every frame. To fix this,
	; just avoid pushing the sprite to the right when the game is about
	; to be paused.
	move.b	(Ctrl_1_Press).w,d0 ; is Start button pressed?
	or.b	(Ctrl_2_Press).w,d0 ; (either player)
	andi.b	#button_start_mask,d0
	bne.s	+
    endif
	btst	#0,(Level_frame_counter+1).w
	beq.s	+
	addi.w	#$20,d1
+		; match obj x-position to screen position
	move.w	d1,d0
	addi.w	#$60,d0
	move.w	d0,(WaterSurface1+x_pos).w
	addi.w	#$120,d1
	move.w	d1,(WaterSurface2+x_pos).w
+
	rts
; End of function UpdateWaterSurface


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; ---------------------------------------------------------------------------
; Subroutine to do special water effects
; ---------------------------------------------------------------------------
; sub_450E: ; LZWaterEffects:
WaterEffects:
	tst.b	(Water_flag).w	; does level have water?
	beq.s	NonWaterEffects	; if not, branch
	tst.b	(Deform_lock).w
	bne.s	MoveWater
	cmpi.b	#6,(MainCharacter+routine).w	; is player dead?
	bhs.s	MoveWater			; if yes, branch
	bsr.w	DynamicWater
; loc_4526: ; LZMoveWater:
MoveWater:
	clr.b	(Water_fullscreen_flag).w
	moveq	#0,d0
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w	; is level ARZ?
	beq.s	+		; if yes, branch
	move.b	(Oscillating_Data).w,d0
	lsr.w	#1,d0
+
	add.w	(Water_Level_2).w,d0
	move.w	d0,(Water_Level_1).w
		; calculate distance between water surface and top of screen
	move.w	(Water_Level_1).w,d0
	sub.w	(Camera_Y_pos).w,d0
	bhs.s	+
	tst.w	d0
	bpl.s	+
	move.b	#screen_height-1,(Hint_counter_reserve+1).w	; H-INT every 224th scanline
	move.b	#1,(Water_fullscreen_flag).w
+
	cmpi.w	#screen_height-1,d0
	blo.s	+
	move.w	#screen_height-1,d0
+
	move.b	d0,(Hint_counter_reserve+1).w	; H-INT every d0 scanlines
; loc_456A:
NonWaterEffects:
	cmpi.b	#oil_ocean_zone,(Current_Zone).w	; is the level OOZ?
	bne.s	+			; if not, branch
	bsr.w	OilSlides		; call oil slide routine
+
	cmpi.b	#wing_fortress_zone,(Current_Zone).w	; is the level WFZ?
	bne.s	+			; if not, branch
	bsr.w	WindTunnel		; call wind and block break routine
+
	rts
; End of function WaterEffects

; ===========================================================================
    if useFullWaterTables
WaterHeight: zoneOrderedTable 2,2
	zoneTableEntry.w  $600, $600	; EHZ
	zoneTableEntry.w  $600, $600	; Zone 1
	zoneTableEntry.w  $600, $600	; WZ
	zoneTableEntry.w  $600, $600	; Zone 3
	zoneTableEntry.w  $600, $600	; MTZ1,2
	zoneTableEntry.w  $600, $600	; MTZ3
	zoneTableEntry.w  $600, $600	; WFZ
	zoneTableEntry.w  $600, $600	; HTZ
	zoneTableEntry.w  $600, $600	; HPZ
	zoneTableEntry.w  $600, $600	; Zone 9
	zoneTableEntry.w  $600, $600	; OOZ
	zoneTableEntry.w  $600, $600	; MCZ
	zoneTableEntry.w  $600, $600	; CNZ
	zoneTableEntry.w  $600, $710	; CPZ
	zoneTableEntry.w  $600, $600	; DEZ
	zoneTableEntry.w  $410, $510	; ARZ
	zoneTableEntry.w  $600, $600	; SCZ
    zoneTableEnd
    else
; word_4584:
WaterHeight:
	dc.w  $600, $600	; HPZ
	dc.w  $600, $600
	dc.w  $600, $600	; OOZ
	dc.w  $600, $600	; MCZ
	dc.w  $600, $600	; CNZ
	dc.w  $600, $710	; CPZ
	dc.w  $600, $600	; DEZ
	dc.w  $410, $510	; ARZ
    endif

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_45A4: ; LZDynamicWater:
DynamicWater:
	moveq	#0,d0
	move.w	(Current_ZoneAndAct).w,d0
    if ~~useFullWaterTables
	subi.w	#hidden_palace_zone_act_1,d0
    endif
	ror.b	#1,d0
	lsr.w	#6,d0
	andi.w	#$FFFE,d0
	move.w	Dynamic_water_routine_table(pc,d0.w),d0
	jsr	Dynamic_water_routine_table(pc,d0.w)
	moveq	#0,d1
	move.b	(Water_on).w,d1
	move.w	(Water_Level_3).w,d0
	sub.w	(Water_Level_2).w,d0
	beq.s	++	; rts
	bcc.s	+
	neg.w	d1
+
	add.w	d1,(Water_Level_2).w
+
	rts
; End of function DynamicWater

; ===========================================================================
    if useFullWaterTables
Dynamic_water_routine_table: zoneOrderedOffsetTable 2,2
	; EHZ
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
	; Zone 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
	; WZ
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
	; Zone 3
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
	; MTZ
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
	; MTZ
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 3
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 4
	; WFZ
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
	; HTZ
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
	; HPZ
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
	; Zone 9
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
	; OOZ
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
	; MCZ
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
	; CNZ
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
	; CPZ
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterCPZ2 ; Act 2
	; DEZ
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
	; ARZ
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
	; SCZ
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Act 2
    zoneTableEnd
    else
; off_45D8:
Dynamic_water_routine_table: offsetTable
	; HPZ
	offsetTableEntry.w DynamicWaterNull ; Act 1
	offsetTableEntry.w DynamicWaterNull ; Act 2
	; Zone 9
	offsetTableEntry.w DynamicWaterNull ; Act 1
	offsetTableEntry.w DynamicWaterNull ; Act 2
	; OOZ
	offsetTableEntry.w DynamicWaterNull ; Act 1
	offsetTableEntry.w DynamicWaterNull ; Act 2
	; MCZ
	offsetTableEntry.w DynamicWaterNull ; Act 1
	offsetTableEntry.w DynamicWaterNull ; Act 2
	; CNZ
	offsetTableEntry.w DynamicWaterNull ; Act 1
	offsetTableEntry.w DynamicWaterNull ; Act 2
	; CPZ
	offsetTableEntry.w DynamicWaterNull ; Act 1
	offsetTableEntry.w DynamicWaterCPZ2 ; Act 2
	; DEZ
	offsetTableEntry.w DynamicWaterNull ; Act 1
	offsetTableEntry.w DynamicWaterNull ; Act 2
	; ARZ
	offsetTableEntry.w DynamicWaterNull ; Act 1
	offsetTableEntry.w DynamicWaterNull ; Act 2
    endif
; ===========================================================================
; return_45F8:
DynamicWaterNull:
	rts
; ===========================================================================
; loc_45FA:
DynamicWaterCPZ2:
	cmpi.w	#$1DE0,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	#$510,(Water_Level_3).w
+	rts
