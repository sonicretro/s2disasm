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
	btst	#0,(Timer_frames+1).w
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
	move.b	#$DF,(Hint_counter_reserve+1).w	; H-INT every 224th scanline
	move.b	#1,(Water_fullscreen_flag).w
+
	cmpi.w	#$DF,d0
	blo.s	+
	move.w	#$DF,d0
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
	zoneTableEntry.w  $600, $600	; MTZ
	zoneTableEntry.w  $600, $600	; MTZ
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
	dc.w  $600, $600	; Zone 9
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
	zoneOffsetTableEntry.w DynamicWaterNull ; EHZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; EHZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 1
	zoneOffsetTableEntry.w DynamicWaterNull ; WZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; WZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 3
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 3
	zoneOffsetTableEntry.w DynamicWaterNull ; MTZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; MTZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; MTZ 3
	zoneOffsetTableEntry.w DynamicWaterNull ; MTZ 4
	zoneOffsetTableEntry.w DynamicWaterNull ; WFZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; WFZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; HTZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; HTZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; HPZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; HPZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 9
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 9
	zoneOffsetTableEntry.w DynamicWaterNull ; OOZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; OOZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; MCZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; MCZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; CNZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; CNZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; CPZ 1
	zoneOffsetTableEntry.w DynamicWaterCPZ2 ; CPZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; DEZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; DEZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; ARZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; ARZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; SCZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; SCZ 2
    zoneTableEnd
    else
; off_45D8:
Dynamic_water_routine_table: offsetTable
	offsetTableEntry.w DynamicWaterNull ; HPZ 1
	offsetTableEntry.w DynamicWaterNull ; HPZ 2
	offsetTableEntry.w DynamicWaterNull ; Zone 9
	offsetTableEntry.w DynamicWaterNull ; Zone 9
	offsetTableEntry.w DynamicWaterNull ; OOZ 1
	offsetTableEntry.w DynamicWaterNull ; OOZ 2
	offsetTableEntry.w DynamicWaterNull ; MCZ 1
	offsetTableEntry.w DynamicWaterNull ; MCZ 2
	offsetTableEntry.w DynamicWaterNull ; CNZ 1
	offsetTableEntry.w DynamicWaterNull ; CNZ 2
	offsetTableEntry.w DynamicWaterNull ; CPZ 1
	offsetTableEntry.w DynamicWaterCPZ2 ; CPZ 2
	offsetTableEntry.w DynamicWaterNull ; DEZ 1
	offsetTableEntry.w DynamicWaterNull ; DEZ 2
	offsetTableEntry.w DynamicWaterNull ; ARZ 1
	offsetTableEntry.w DynamicWaterNull ; ARZ 2
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

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Equates:
windtunnel_min_x_pos	= 0
windtunnel_max_x_pos	= 4
windtunnel_min_y_pos	= 2
windtunnel_max_y_pos	= 6

; sub_460A:
WindTunnel:
	tst.w	(Debug_placement_mode).w
	bne.w	WindTunnel_End	; don't interact with wind tunnels while in debug mode
	lea	(WindTunnelsCoordinates).l,a2
	moveq	#(WindTunnelsCoordinates_End-WindTunnelsCoordinates)/8-1,d1
	lea	(MainCharacter).w,a1 ; a1=character
-	; check for current wind tunnel if the main character is inside it
	move.w	x_pos(a1),d0
	cmp.w	windtunnel_min_x_pos(a2),d0
	blo.w	WindTunnel_Leave	; branch, if main character is too far left
	cmp.w	windtunnel_max_x_pos(a2),d0
	bhs.w	WindTunnel_Leave	; branch, if main character is too far right
	move.w	y_pos(a1),d2
	cmp.w	windtunnel_min_y_pos(a2),d2
	blo.w	WindTunnel_Leave	; branch, if main character is too far up
	cmp.w	windtunnel_max_y_pos(a2),d2
	bhs.s	WindTunnel_Leave	; branch, if main character is too far down
	tst.b	(WindTunnel_holding_flag).w
	bne.w	WindTunnel_End
	cmpi.b	#4,routine(a1)		; is the main character hurt, dying, etc. ?
	bhs.s	WindTunnel_LeaveHurt	; if yes, branch
	move.b	#1,(WindTunnel_flag).w	; affects character animation and bubble movement
	subi_.w	#4,x_pos(a1)	; move main character to the left
	move.w	#-$400,x_vel(a1)
	move.w	#0,y_vel(a1)
	move.b	#AniIDSonAni_Float2,anim(a1)
	bset	#1,status(a1)	; set "in-air" bit
	btst	#button_up,(Ctrl_1_Held).w	; is Up being pressed?
	beq.s	+				; if not, branch
	subq.w	#1,y_pos(a1)	; move up
+
	btst	#button_down,(Ctrl_1_Held).w	; is Down being pressed?
	beq.s	+				; if not, branch
	addq.w	#1,y_pos(a1)	; move down
+
	rts
; ===========================================================================
; loc_4690:
WindTunnel_Leave:
	addq.w	#8,a2
	dbf	d1,-	; check next tunnel
	; when all wind tunnels have been checked
	tst.b	(WindTunnel_flag).w
	beq.s	WindTunnel_End
	move.b	#AniIDSonAni_Walk,anim(a1)
; loc_46A2:
WindTunnel_LeaveHurt:	; the main character is hurt or dying, leave the tunnel and don't check the other
	clr.b	(WindTunnel_flag).w
; return_46A6:
WindTunnel_End:
	rts
; End of function WindTunnel

; ===========================================================================
; word_46A8:
WindTunnelsCoordinates:
	dc.w $1510,$400,$1AF0,$580
	dc.w $20F0,$618,$2500,$680
WindTunnelsCoordinates_End:

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_46B8:
OilSlides:
	lea	(MainCharacter).w,a1 ; a1=character
	move.b	(Ctrl_1_Held_Logical).w,d2
	bsr.s	+
	lea	(Sidekick).w,a1 ; a1=character
	move.b	(Ctrl_2_Held_Logical).w,d2
+
	btst	#1,status(a1)
	bne.s	+
	move.w	y_pos(a1),d0
	add.w	d0,d0
	andi.w	#$F00,d0
	move.w	x_pos(a1),d1
	lsr.w	#7,d1
	andi.w	#$7F,d1
	add.w	d1,d0
	lea	(Level_Layout).w,a2
	move.b	(a2,d0.w),d0
	lea	OilSlides_Chunks_End(pc),a2

	moveq	#OilSlides_Chunks_End-OilSlides_Chunks-1,d1
-	cmp.b	-(a2),d0
	dbeq	d1,-

	beq.s	loc_4712
+
    if status_sec_isSliding = 7
	tst.b	status_secondary(a1)
	bpl.s	+	; rts
    else
	btst	#status_sec_isSliding,status_secondary(a1)
	beq.s	+	; rts
    endif
	move.w	#5,move_lock(a1)
	andi.b	#(~status_sec_isSliding_mask)&$FF,status_secondary(a1)
+	rts
; ===========================================================================

loc_4712:
	lea	(OilSlides_Speeds).l,a2
	move.b	(a2,d1.w),d0
	beq.s	loc_476E
	move.b	inertia(a1),d1
	tst.b	d0
	bpl.s	+
	cmp.b	d0,d1
	ble.s	++
	subi.w	#$40,inertia(a1)
	bra.s	++
; ===========================================================================
+
	cmp.b	d0,d1
	bge.s	+
	addi.w	#$40,inertia(a1)
+
	bclr	#0,status(a1)
	tst.b	d1
	bpl.s	+
	bset	#0,status(a1)
+
	move.b	#AniIDSonAni_Slide,anim(a1)
	ori.b	#status_sec_isSliding_mask,status_secondary(a1)
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+	; rts
	move.w	#SndID_OilSlide,d0
	jsr	(PlaySound).l
+
	rts
; ===========================================================================

loc_476E:
	move.w	#4,d1
	move.w	inertia(a1),d0
	btst	#button_left,d2
	beq.s	+
	move.b	#AniIDSonAni_Walk,anim(a1)
	bset	#0,status(a1)
	sub.w	d1,d0
	tst.w	d0
	bpl.s	+
	sub.w	d1,d0
+
	btst	#button_right,d2
	beq.s	+
	move.b	#AniIDSonAni_Walk,anim(a1)
	bclr	#0,status(a1)
	add.w	d1,d0
	tst.w	d0
	bmi.s	+
	add.w	d1,d0
+
	move.w	#4,d1
	tst.w	d0
	beq.s	+++
	bmi.s	++
	sub.w	d1,d0
	bhi.s	+
	move.w	#0,d0
	move.b	#AniIDSonAni_Wait,anim(a1)
+	bra.s	++
; ===========================================================================
+
	add.w	d1,d0
	bhi.s	+
	move.w	#0,d0
	move.b	#AniIDSonAni_Wait,anim(a1)
+
	move.w	d0,inertia(a1)
	ori.b	#status_sec_isSliding_mask,status_secondary(a1)
	rts
; End of function OilSlides

; ===========================================================================
OilSlides_Speeds:
	dc.b  -8, -8, -8,  8,  8,  0,  0,  0, -8, -8,  0,  8,  8,  8,  0,  8
	dc.b   8,  8,  0, -8,  0,  0, -8,  8, -8, -8, -8,  8,  8,  8, -8, -8 ; 16

; These are the IDs of the chunks where Sonic and Tails will slide
OilSlides_Chunks:
	dc.b $2F,$30,$31,$33,$35,$38,$3A,$3C,$63,$64,$83,$90,$91,$93,$A1,$A3
	dc.b $BD,$C7,$C8,$CE,$D7,$D8,$E6,$EB,$EC,$ED,$F1,$F2,$F3,$F4,$FA,$FD ; 16
OilSlides_Chunks_End:
	even