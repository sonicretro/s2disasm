; ===========================================================================
; ----------------------------------------------------------------------------
; Object 34 - level title card (screen with red, yellow, and blue)
; ----------------------------------------------------------------------------
titlecard_x_target     = objoff_30	; the X position the object will reach
titlecard_x_source     = objoff_32	; the X position the object starts from and will end at
titlecard_location     = objoff_34	; point up to which titlecard is drawn
titlecard_vram_dest    = objoff_36	; target of VRAM write
titlecard_vram_dest_2P = objoff_38	; target of VRAM write
titlecard_split_point  = objoff_3A	; point to split drawing for yellow and red portions
titlecard_leaveflag    = objoff_3E	; whether or not titlecard is leaving screen
; Sprite_13C48:
Obj34: ; (note: screen-space obj)
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj34_Index(pc,d0.w),d1
	jmp	Obj34_Index(pc,d1.w)
; ===========================================================================
Obj34_Index:	offsetTable
		offsetTableEntry.w Obj34_Init			;   0 - create all the title card objects
		offsetTableEntry.w Obj34_BackgroundIn		;   2 - the background, coming in
		offsetTableEntry.w Obj34_BottomPartIn		;   4 - the yellow part at the bottom, coming in
		offsetTableEntry.w Obj34_LeftPartIn		;   6 - the red part on the left, coming in
		offsetTableEntry.w Obj34_ZoneName		;   8 - the name of the zone, coming in
		offsetTableEntry.w Obj34_Zone			;  $A - the word "ZONE", coming in
		offsetTableEntry.w Obj34_ActNumber		;  $C - the act number, coming in
		offsetTableEntry.w Obj34_LeftPartOut		;  $E - red part on the left, going out
		offsetTableEntry.w Obj34_BottomPartOut		; $10 - yellow part at the bottom, going out
		offsetTableEntry.w Obj34_BackgroundOutInit	; $12 - the background, going out (first frame)
		offsetTableEntry.w Obj34_BackgroundOut		; $14 - the background, going out
		offsetTableEntry.w Obj34_WaitAndGoAway		; $16 - wait and go away, used by the zone name, "ZONE" and the act number
; ===========================================================================
; loc_13C6E:
Obj34_Init:
	lea	(a0),a1
	lea	Obj34_TitleCardData(pc),a2

	moveq	#(Obj34_TitleCardData_End-Obj34_TitleCardData)/$A-1,d1
-	_move.b	#ObjID_TitleCard,id(a1) ; load obj34
	move.b	(a2)+,routine(a1)
	move.l	#Obj34_MapUnc_147BA,mappings(a1)
	move.b	(a2)+,mapping_frame(a1)
	move.b	(a2)+,width_pixels(a1)
	move.b	(a2)+,anim_frame_duration(a1)
	move.w	(a2),x_pixel(a1)
	move.w	(a2)+,titlecard_x_source(a1)
	move.w	(a2)+,titlecard_x_target(a1)
	move.w	(a2)+,y_pixel(a1)
	move.b	#0,render_flags(a1)
	lea	next_object(a1),a1 ; a1=object
	dbf	d1,-

	move.w	#$26,(TitleCard_Bottom+titlecard_location).w
	clr.w	(Vscroll_Factor_FG).w
	move.w	#-224,(Vscroll_Factor_P2_FG).w

	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len

	rts
; ===========================================================================
; This macro declares data for an object. The data includes:
; - the initial routine counter (byte)
; - the initial mapping frame (byte)
; - the width of the object (byte)
; - the number of frames before it appears on screen (byte)
; - the X position where it starts and where it will go back (word)
; - the X position to reach (word)
; - the Y position (word)
titlecardobjdata macro routine,frame,width,duration,xstart,xstop,y
	dc.b routine,frame,width,duration
	dc.w 128+xstart,128+xstop,128+y
    endm
; word_13CD4:
Obj34_TitleCardData:
	titlecardobjdata  8,   0, $80, $1B, 320+128,   160,    56	; zone name
	titlecardobjdata $A, $11, $40, $1C,    0-88,   200,    80	; "ZONE"
	titlecardobjdata $C, $12, $18, $1C,    0-24,   264,    80	; act number
	titlecardobjdata  2,   0,   0,   0,   0-128, 0-128, 0-128	; blue background
	titlecardobjdata  4, $15, $48,   8, 320+232,   232,   160	; bottom yellow part
	titlecardobjdata  6, $16,   8, $15,       0,   112,   112	; left red part
Obj34_TitleCardData_End:

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_13D10:
Obj34_Wait:
	subq.b	#1,anim_frame_duration(a0)	; subtract 1
	bne.s	+				; if it's not 0, branch
	move.b	#1,anim_frame_duration(a0)	; reset to 1
	rts
; ---------------------------------------------------------------------------
+	addq.w	#4,sp	; don't run the code after the call to this routine
	rts
; End of function Obj34_Wait

; ===========================================================================
; loc_13D22:
Obj34_BackgroundIn:	; the blue background (green when playing as Knuckles), coming in
	moveq	#$10,d0
	moveq	#8,d1
	tst.w	(Two_player_mode).w	; if two-player mode is on (1)
	sne	d6			; then set d6 to $FF, else set d6 to $00
	beq.s	+
	moveq	#$20,d0
	moveq	#7,d1
+
	move.w	titlecard_location(a0),d2
	cmp.w	d0,d2
	beq.s	++	; rts
	lsl.w	d1,d2
	move.w	#VRAM_Plane_A_Name_Table,d0
	add.w	d2,d0
	move.w	d0,titlecard_vram_dest(a0)
	tst.b	d6
	beq.s	+
	addi.w	#VRAM_Plane_A_Name_Table_2P,d2
	move.w	d2,titlecard_vram_dest_2P(a0)
+
	addq.w	#1,titlecard_location(a0)
+
	rts
; ===========================================================================
; loc_13D58:
Obj34_BottomPartIn:	; the yellow part at the bottom, coming in
	jsr	Obj34_Wait(pc)
	move.w	titlecard_location(a0),d0
	bmi.w	Obj34_MoveTowardsTargetPosition
	add.w	d0,d0
	move.w	#$80*$14/2,d1		; $14 half-cells down (for 2P mode)
	tst.w	(Two_player_mode).w
	sne	d6
	bne.s	+
	add.w	d1,d1				; double distance down for 1P mode
+
	move.w	#VRAM_Plane_A_Name_Table,d2
	add.w	d0,d2
	add.w	d1,d2
	move.w	d2,titlecard_vram_dest(a0)
	tst.b	d6
	beq.s	+
	addi.w	#VRAM_Plane_A_Name_Table_2P,d1
	add.w	d0,d1
	move.w	d1,titlecard_vram_dest_2P(a0)
+
	subq.w	#2,titlecard_location(a0)
	move.w	titlecard_location(a0),titlecard_split_point(a0)
	cmpi.w	#6,titlecard_location(a0) ; if titlecard_location(a0) is 6,
	seq	titlecard_location(a0) ; then set it to $FF, else set it to $00
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================
; loc_13DA6:
Obj34_LeftPartIn:	; the red part on the left, coming in
	jsr	Obj34_Wait(pc)
	tst.w	titlecard_location(a0)
	bmi.w	Obj34_MoveTowardsTargetPosition
	move.w	#VRAM_Plane_A_Name_Table,titlecard_vram_dest(a0)
	tst.w	(Two_player_mode).w
	beq.s	+
	move.w	#VRAM_Plane_A_Name_Table_2P,titlecard_vram_dest_2P(a0)
+
	addq.w	#2,titlecard_location(a0)
	move.w	titlecard_location(a0),titlecard_split_point(a0)
	cmpi.w	#$E,titlecard_location(a0)
	seq	titlecard_location(a0)
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================
; loc_13DDC:
Obj34_ZoneName:		; the name of the zone, coming in
	jsr	Obj34_Wait(pc)
	move.b	(Current_Zone).w,mapping_frame(a0)
	bra.s	Obj34_MoveTowardsTargetPosition
; ===========================================================================
; loc_13DE8:
Obj34_Zone:		; the word "ZONE", coming in
	jsr	Obj34_Wait(pc)
	bra.s	Obj34_MoveTowardsTargetPosition
; ===========================================================================
; loc_13DEE:
Obj34_ActNumber:	; the act number, coming in
	jsr	Obj34_Wait(pc)
	move.b	(Current_Zone).w,d0	; get the current zone
	cmpi.b	#sky_chase_zone,d0	; is it Sky Chase?
	beq.s	BranchTo9_DeleteObject	; if yes, branch
	cmpi.b	#wing_fortress_zone,d0	; is it Wing Fortress?
	beq.s	BranchTo9_DeleteObject	; if yes, branch
	cmpi.b	#death_egg_zone,d0	; is it Death Egg Zone?
	beq.s	BranchTo9_DeleteObject	; if yes, branch
	move.b	(Current_Act).w,d1	; get the current act
	addi.b	#$12,d1			; add $12 to it (this is the index of the "1" frame in the mappings)
	cmpi.b	#metropolis_zone_2,d0	; are we in Metropolis Zone Act 3?
	bne.s	+			; if not, branch
	moveq	#$14,d1			; use the "3" frame instead
+
	move.b	d1,mapping_frame(a0)	; set the mapping frame

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_13E1C:
Obj34_MoveTowardsTargetPosition:
	moveq	#$10,d0 ; Movement speed
	move.w	x_pixel(a0),d1
	cmp.w	titlecard_x_target(a0),d1
	beq.s	.display
	bhi.s	+
	neg.w	d0
+
	sub.w	d0,x_pixel(a0)
	; If target lies very far off-screen, then don't bother trying to display it.
	; This is because the sprite coordinates are prone to overflow and underflow.
	cmpi.w	#128+320+64,x_pixel(a0)
	bhi.s	.return
.display:
	bra.w	DisplaySprite
.return:
	rts
; End of function Obj34_MoveTowardsTargetPosition

; ===========================================================================

BranchTo9_DeleteObject
	bra.w	DeleteObject
; ===========================================================================
; loc_13E42:
Obj34_LeftPartOut:	; red part on the left, going out
	move.w	titlecard_location(a0),d0
	bpl.s	+
	move.b	#$10,TitleCard_Bottom-TitleCard_Left+routine(a0)
	clr.w	TitleCard_Bottom-TitleCard_Left+titlecard_location(a0)
	bra.s	BranchTo9_DeleteObject
; ===========================================================================
+
	add.w	d0,d0
	move.w	#VRAM_Plane_A_Name_Table,titlecard_vram_dest(a0)
	add.w	d0,titlecard_vram_dest(a0)
	tst.w	(Two_player_mode).w
	beq.s	+
	move.w	#VRAM_Plane_A_Name_Table_2P,titlecard_vram_dest_2P(a0)
	add.w	d0,titlecard_vram_dest_2P(a0)
+
	subq.w	#4,titlecard_location(a0)
	cmpi.w	#-2,titlecard_location(a0)
	bne.s	+
	clr.w	titlecard_location(a0)
+
	bra.w	loc_13EC4
; ===========================================================================
; loc_13E84:
Obj34_BottomPartOut:	; yellow part at the bottom, going out
	move.w	titlecard_location(a0),d0
	cmpi.w	#$28,d0
	bne.s	+
	move.b	#$12,TitleCard_Background-TitleCard_Bottom+routine(a0)
	bra.s	BranchTo9_DeleteObject
; ---------------------------------------------------------------------------
+
	add.w	d0,d0
	move.w	#$80*$14/2,d1		; $14 half-cells down (for 2P mode)
	tst.w	(Two_player_mode).w
	sne	d6
	bne.s	+
	add.w	d1,d1				; double distance down for 1P mode
+
	move.w	#VRAM_Plane_A_Name_Table,d2
	add.w	d0,d2
	add.w	d1,d2
	move.w	d2,titlecard_vram_dest(a0)
	tst.b	d6
	beq.s	+
	addi.w	#VRAM_Plane_A_Name_Table_2P,d1
	add.w	d0,d1
	move.w	d1,titlecard_vram_dest_2P(a0)
+
	addq.w	#4,titlecard_location(a0)

loc_13EC4:
	moveq	#$20,d0
	move.w	x_pixel(a0),d1
	cmp.w	titlecard_x_source(a0),d1
	beq.s	++	; rts
	bhi.s	+
	neg.w	d0
+
	sub.w	d0,x_pixel(a0)
	cmpi.w	#$200,x_pixel(a0)
	bhi.s	+	; rts
	bra.w	DisplaySprite
; ---------------------------------------------------------------------------
+	rts
; ===========================================================================
; loc_13EE6:
Obj34_BackgroundOutInit:	; the background, going out
	move.l	a0,-(sp)
	move.l	d7,-(sp)
	bsr.w	DeformBgLayer
	move.l	(sp)+,d7
	movea.l	(sp)+,a0 ; load 0bj address
	addi_.b	#2,routine(a0)
	move.w	#$F0,titlecard_location(a0)
; loc_13EFE:
Obj34_BackgroundOut:
	move.w	titlecard_location(a0),d0
	subi.w	#$20,d0
	cmpi.w	#-$30,d0
	beq.w	BranchTo9_DeleteObject
	move.w	d0,titlecard_location(a0)
	move.w	d0,titlecard_vram_dest(a0)
	rts
; ===========================================================================
; loc_13F18:
Obj34_WaitAndGoAway:
	tst.w	anim_frame_duration(a0)
	beq.s	+
	subq.w	#1,anim_frame_duration(a0)
	bra.s	+++	; DisplaySprite
; ---------------------------------------------------------------------------
+
	moveq	#$20,d0
	move.w	x_pixel(a0),d1
	cmp.w	titlecard_x_source(a0),d1
	beq.s	Obj34_LoadStandardWaterAndAnimalArt
	bhi.s	+
	neg.w	d0
+
	sub.w	d0,x_pixel(a0)
	cmpi.w	#$200,x_pixel(a0)
	bhi.s	Obj34_LoadStandardWaterAndAnimalArt
+
	bra.w	DisplaySprite
; ===========================================================================
; loc_13F44:
Obj34_LoadStandardWaterAndAnimalArt:
	cmpa.w	#TitleCard_ZoneName,a0	; is this the zone name object?
	bne.s	+			; if not, just delete the title card
	moveq	#PLCID_StdWtr,d0	; load the standard water graphics
	jsrto	LoadPLC, JmpTo3_LoadPLC
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	move.b	Animal_PLCTable(pc,d0.w),d0 ; load the animal graphics for the current zone
	jsrto	LoadPLC, JmpTo3_LoadPLC
+
	bra.w	DeleteObject		; delete the title card object
; ===========================================================================
;byte_13F62:
Animal_PLCTable: zoneOrderedTable 1,1
	zoneTableEntry.b PLCID_EhzAnimals	; EHZ
	zoneTableEntry.b PLCID_EhzAnimals	; Zone 1
	zoneTableEntry.b PLCID_EhzAnimals	; WZ
	zoneTableEntry.b PLCID_EhzAnimals	; Zone 3
	zoneTableEntry.b PLCID_MtzAnimals	; MTZ1,2
	zoneTableEntry.b PLCID_MtzAnimals	; MTZ3
	zoneTableEntry.b PLCID_WfzAnimals	; WFZ
	zoneTableEntry.b PLCID_HtzAnimals	; HTZ
	zoneTableEntry.b PLCID_HpzAnimals	; HPZ
	zoneTableEntry.b PLCID_HpzAnimals	; Zone 9
	zoneTableEntry.b PLCID_OozAnimals	; OOZ
	zoneTableEntry.b PLCID_MczAnimals	; MCZ
	zoneTableEntry.b PLCID_CnzAnimals	; CNZ
	zoneTableEntry.b PLCID_CpzAnimals	; CPZ
	zoneTableEntry.b PLCID_DezAnimals	; DEZ
	zoneTableEntry.b PLCID_ArzAnimals	; ARZ
	zoneTableEntry.b PLCID_SczAnimals	; SCZ
    zoneTableEnd

	dc.b PLCID_SczAnimals	; level slot $11 (non-existent), not part of main table
	even

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 39 - Game/Time Over text
; ----------------------------------------------------------------------------
; Sprite_13F74:
Obj39: ; (screen-space obj)
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj39_Index(pc,d0.w),d1
	jmp	Obj39_Index(pc,d1.w)
; ===========================================================================
Obj39_Index:	offsetTable
		offsetTableEntry.w Obj39_Init		; 0
		offsetTableEntry.w Obj39_SlideIn	; 2
		offsetTableEntry.w Obj39_Wait		; 4
; ===========================================================================
; loc_13F88:
Obj39_Init:
	tst.l	(Plc_Buffer).w
	beq.s	+
	rts		; wait until the art is loaded
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine(a0)
	move.w	#$50,x_pixel(a0)
	btst	#0,mapping_frame(a0)
	beq.s	+
	move.w	#$1F0,x_pixel(a0)
+
	move.w	#$F0,y_pixel(a0)
	move.l	#Obj39_MapUnc_14C6C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Game_Over,0,1),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#0,render_flags(a0)
	move.b	#0,priority(a0)
; loc_13FCC:
Obj39_SlideIn:
	moveq	#$10,d1
	cmpi.w	#$120,x_pixel(a0)
	beq.s	Obj39_SetTimer
	blo.s	+
	neg.w	d1
+
	add.w	d1,x_pixel(a0)
	bra.w	DisplaySprite
; ===========================================================================
; loc_13FE2:
Obj39_SetTimer:
	move.w	#$2D0,anim_frame_duration(a0)
	addq.b	#2,routine(a0)
	rts
; ===========================================================================
; loc_13FEE:
Obj39_Wait:
	btst	#0,mapping_frame(a0)
	bne.w	Obj39_Display
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0
	bne.s	Obj39_Dismiss
	tst.w	anim_frame_duration(a0)
	beq.s	Obj39_Dismiss
	subq.w	#1,anim_frame_duration(a0)
	bra.w	DisplaySprite
; ===========================================================================
; loc_14014:
Obj39_Dismiss:
	tst.b	(Time_Over_flag).w
	bne.s	Obj39_TimeOver
	tst.b	(Time_Over_flag_2P).w
	bne.s	Obj39_TimeOver
	move.b	#GameModeID_ContinueScreen,(Game_Mode).w ; => ContinueScreen
	tst.b	(Continue_count).w
	bne.s	Obj39_Check2PMode
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	bra.s	Obj39_Check2PMode
; ===========================================================================
; loc_14034:
Obj39_TimeOver:
	clr.l	(Saved_Timer).w
	move.w	#1,(Level_Inactive_flag).w
; loc_1403E:
Obj39_Check2PMode:
	tst.w	(Two_player_mode).w
	beq.s	Obj39_Display

	move.w	#0,(Level_Inactive_flag).w
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	move.w	#VsRSID_Act,(Results_Screen_2P).w
	tst.b	(Time_Over_flag).w
	bne.s	Obj39_Display
	tst.b	(Time_Over_flag_2P).w
	bne.s	Obj39_Display
	move.w	#1,(Game_Over_2P).w
	move.w	#VsRSID_Zone,(Results_Screen_2P).w
	jsrto	sub_8476, JmpTo_sub_8476
	move.w	#-1,(a4)
	tst.b	parent+1(a0)
	beq.s	+
	addq.w	#1,a4
+
	move.b	#-2,(a4)
; BranchTo17_DisplaySprite
Obj39_Display:
	bra.w	DisplaySprite
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 3A - End of level results screen
; ----------------------------------------------------------------------------
; Sprite_14086:
Obj3A: ; (screen-space obj)
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj3A_Index(pc,d0.w),d1
	jmp	Obj3A_Index(pc,d1.w)
; ===========================================================================
; off_14094:
Obj3A_Index:	offsetTable
		offsetTableEntry.w loc_140AC					;   0
		offsetTableEntry.w loc_14102					;   2
		offsetTableEntry.w BranchTo_Obj34_MoveTowardsTargetPosition	;   4
		offsetTableEntry.w loc_14146					;   6
		offsetTableEntry.w loc_14168					;   8
		offsetTableEntry.w loc_1419C					;  $A
		offsetTableEntry.w loc_141AA					;  $C
		offsetTableEntry.w loc_1419C					;  $E
		offsetTableEntry.w loc_14270					; $10
		offsetTableEntry.w loc_142B0					; $12
		offsetTableEntry.w loc_142CC					; $14
		offsetTableEntry.w loc_1413A					; $16
; ===========================================================================

loc_140AC:
	tst.l	(Plc_Buffer).w
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+
	movea.l	a0,a1
	lea	Obj3A_SubObjectMetadata(pc),a2
	moveq	#bytesToXcnt(Obj3A_SubObjectMetadata_End-Obj3A_SubObjectMetadata, results_screen_object_size),d1

loc_140BC:
	_move.b	id(a1),d0
	beq.s	loc_140CE
	cmpi.b	#ObjID_Results,d0
	beq.s	loc_140CE
	lea	next_object(a1),a1 ; a1=object
	bra.s	loc_140BC
; ===========================================================================

loc_140CE:

	_move.b	#ObjID_Results,id(a1) ; load obj3A
	move.w	(a2)+,x_pixel(a1)
	move.w	(a2)+,titlecard_x_target(a1)
	move.w	(a2)+,y_pixel(a1)
	move.b	(a2)+,routine(a1)
	move.b	(a2)+,mapping_frame(a1)
	move.l	#Obj3A_MapUnc_14CBC,mappings(a1)
	bsr.w	Adjust2PArtPointer2
	move.b	#0,render_flags(a1)
	lea	next_object(a1),a1 ; a1=object
	dbf	d1,loc_140BC

loc_14102:
	moveq	#0,d0
	cmpi.w	#2,(Player_mode).w
	bne.s	loc_14118
	addq.w	#1,d0
	btst	#7,(Graphics_Flags).w
	beq.s	loc_14118
	addq.w	#1,d0

loc_14118:

	move.b	d0,mapping_frame(a0)
	bsr.w	Obj34_MoveTowardsTargetPosition
	move.w	x_pixel(a0),d0
	cmp.w	titlecard_x_target(a0),d0
	bne.w	return_14138
	move.b	#$A,routine(a0)
	move.w	#$B4,anim_frame_duration(a0)

return_14138:
	rts
; ===========================================================================

loc_1413A:
	tst.w	(Perfect_rings_left).w
	bne.w	DeleteObject

BranchTo_Obj34_MoveTowardsTargetPosition ; BranchTo
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================

loc_14146:
	move.b	(Current_Zone).w,d0
	cmpi.b	#sky_chase_zone,d0
	beq.s	loc_1415E
	cmpi.b	#wing_fortress_zone,d0
	beq.s	loc_1415E
	cmpi.b	#death_egg_zone,d0
	bne.w	Obj34_MoveTowardsTargetPosition

loc_1415E:

	move.b	#5,mapping_frame(a0)
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================

loc_14168:
	move.b	(Current_Zone).w,d0
	cmpi.b	#sky_chase_zone,d0
	beq.w	BranchTo9_DeleteObject
	cmpi.b	#wing_fortress_zone,d0
	beq.w	BranchTo9_DeleteObject
	cmpi.b	#death_egg_zone,d0
	beq.w	BranchTo9_DeleteObject
	cmpi.b	#metropolis_zone_2,d0
	bne.s	loc_1418E
	moveq	#8,d0
	bra.s	loc_14194
; ===========================================================================

loc_1418E:
	move.b	(Current_Act).w,d0
	addq.b	#6,d0

loc_14194:
	move.b	d0,mapping_frame(a0)
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================

loc_1419C:
	subq.w	#1,anim_frame_duration(a0)
	bne.s	BranchTo18_DisplaySprite
	addq.b	#2,routine(a0)

BranchTo18_DisplaySprite
	bra.w	DisplaySprite
; ===========================================================================

loc_141AA:
	bsr.w	DisplaySprite
	move.b	#1,(Update_Bonus_score).w
	moveq	#0,d0
	tst.w	(Bonus_Countdown_1).w
	beq.s	loc_141C6
	addi.w	#10,d0
	subi.w	#10,(Bonus_Countdown_1).w

loc_141C6:
	tst.w	(Bonus_Countdown_2).w
	beq.s	loc_141D6
	addi.w	#10,d0
	subi.w	#10,(Bonus_Countdown_2).w

loc_141D6:
	tst.w	(Bonus_Countdown_3).w
	beq.s	loc_141E6
	addi.w	#10,d0
	subi.w	#10,(Bonus_Countdown_3).w

loc_141E6:
	add.w	d0,(Total_Bonus_Countdown).w
	tst.w	d0
	bne.s	loc_14256
	move.w	#SndID_TallyEnd,d0
	jsr	(PlaySound).l
	addq.b	#2,routine(a0)
	move.w	#$B4,anim_frame_duration(a0)
	cmpi.w	#1000,(Total_Bonus_Countdown).w
	blo.s	return_14254
	move.w	#$12C,anim_frame_duration(a0)
	lea	next_object(a0),a1 ; a1=object

loc_14214:
	_tst.b	id(a1)
	beq.s	loc_14220
	lea	next_object(a1),a1 ; a1=object
	bra.s	loc_14214
; ===========================================================================

loc_14220:
	_move.b	#ObjID_Results,id(a1) ; load obj3A (uses screen-space)
	move.b	#$12,routine(a1)
	move.w	#$188,x_pixel(a1)
	move.w	#$118,y_pixel(a1)
	move.l	#Obj3A_MapUnc_14CBC,mappings(a1)
	bsr.w	Adjust2PArtPointer2
	move.b	#0,render_flags(a1)
	move.w	#60,anim_frame_duration(a1)
	addq.b	#1,(Continue_count).w

return_14254:

	rts
; ===========================================================================

loc_14256:
	jsr	(AddPoints).l
	move.b	(Vint_runcount+3).w,d0
	andi.b	#3,d0
	bne.s	return_14254
	move.w	#SndID_Blip,d0
	jmp	(PlaySound).l
; ===========================================================================

loc_14270:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	add.b	(Current_Act).w,d0
	add.w	d0,d0
	lea	LevelOrder(pc),a1
	tst.w	(Two_player_mode).w
	beq.s	loc_1428C
	lea	LevelOrder_2P(pc),a1

loc_1428C:
	move.w	(a1,d0.w),d0
	tst.w	d0
	bpl.s	loc_1429C
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ===========================================================================

loc_1429C:
	move.w	d0,(Current_ZoneAndAct).w
	clr.b	(Last_star_pole_hit).w
	clr.b	(Last_star_pole_hit_2P).w
	move.w	#1,(Level_Inactive_flag).w
	rts
; ===========================================================================

loc_142B0:
	tst.w	anim_frame_duration(a0)
	beq.s	loc_142BC
	subq.w	#1,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_142BC:
	addi_.b	#2,routine(a0)
	move.w	#SndID_ContinueJingle,d0
	jsr	(PlaySound).l

loc_142CC:
	subq.w	#1,anim_frame_duration(a0)
	bpl.s	loc_142E2
	move.w	#$13,anim_frame_duration(a0)
	addq.b	#1,anim_frame(a0)
	andi.b	#1,anim_frame(a0)

loc_142E2:
	moveq	#$C,d0
	add.b	anim_frame(a0),d0
	move.b	d0,mapping_frame(a0)
	btst	#4,(Timer_frames+1).w
	bne.w	DisplaySprite
	rts
; ===========================================================================
; -------------------------------------------------------------------------------
; Main game level order

; One value per act. That value is the level/act number of the level to load when
; that act finishes.
; -------------------------------------------------------------------------------
;word_142F8:
LevelOrder: zoneOrderedTable 2,2	; WrdArr_LevelOrder
	; EHZ
	zoneTableEntry.w  emerald_hill_zone_act_2	; Act 1
	zoneTableEntry.w  chemical_plant_zone_act_1	; Act 2
	; Zone 1
	zoneTableEntry.w  0				; Act 1
	zoneTableEntry.w  0				; Act 2
	; WZ
	zoneTableEntry.w  wood_zone_act_2		; Act 1
	zoneTableEntry.w  metropolis_zone_act_1		; Act 2
	; Zone 3
	zoneTableEntry.w  0				; Act 1
	zoneTableEntry.w  0				; Act 2
	; MTZ
	zoneTableEntry.w  metropolis_zone_act_2		; Act 1
	zoneTableEntry.w  metropolis_zone_act_3		; Act 2
	; MTZ
	zoneTableEntry.w  sky_chase_zone_act_1		; Act 3
	zoneTableEntry.w  0				; Act 4
	; WFZ
	zoneTableEntry.w  death_egg_zone_act_1		; Act 1
	zoneTableEntry.w  0				; Act 2
	; HTZ
	zoneTableEntry.w  hill_top_zone_act_2		; Act 1
	zoneTableEntry.w  mystic_cave_zone_act_1	; Act 2
	; HPZ
	zoneTableEntry.w  hidden_palace_zone_act_2 	; Act 1
	zoneTableEntry.w  oil_ocean_zone_act_1		; Act 2
	; Zone 9
	zoneTableEntry.w  0				; Act 1
	zoneTableEntry.w  0				; Act 2
	; OOZ
	zoneTableEntry.w  oil_ocean_zone_act_2		; Act 1
	zoneTableEntry.w  metropolis_zone_act_1		; Act 2
	; MCZ
	zoneTableEntry.w  mystic_cave_zone_act_2	; Act 1
	zoneTableEntry.w  oil_ocean_zone_act_1		; Act 2
	; CNZ
	zoneTableEntry.w  casino_night_zone_act_2	; Act 1
	zoneTableEntry.w  hill_top_zone_act_1		; Act 2
	; CPZ
	zoneTableEntry.w  chemical_plant_zone_act_2	; Act 1
	zoneTableEntry.w  aquatic_ruin_zone_act_1	; Act 2
	; DEZ
	zoneTableEntry.w  -1				; Act 1
	zoneTableEntry.w  0				; Act 2
	; ARZ
	zoneTableEntry.w  aquatic_ruin_zone_act_2	; Act 1
	zoneTableEntry.w  casino_night_zone_act_1	; Act 2
	; SCZ
	zoneTableEntry.w  wing_fortress_zone_act_1 	; Act 1
	zoneTableEntry.w  0				; Act 2
    zoneTableEnd

;word_1433C:
LevelOrder_2P: zoneOrderedTable 2,2	; WrdArr_LevelOrder_2P
	; EHZ
	zoneTableEntry.w  emerald_hill_zone_act_2	; Act 1
	zoneTableEntry.w  casino_night_zone_act_1	; Act 2
	; Zone 1
	zoneTableEntry.w  0				; Act 1
	zoneTableEntry.w  0				; Act 2
	; WZ
	zoneTableEntry.w  wood_zone_act_2		; Act 1
	zoneTableEntry.w  metropolis_zone_act_1		; Act 2
	; Zone 3
	zoneTableEntry.w  0				; Act 1
	zoneTableEntry.w  0				; Act 2
	; MTZ
	zoneTableEntry.w  metropolis_zone_act_2		; Act 1
	zoneTableEntry.w  metropolis_zone_act_3		; Act 2
	; MTZ
	zoneTableEntry.w  sky_chase_zone_act_1		; Act 3
	zoneTableEntry.w  0				; Act 4
	; WFZ
	zoneTableEntry.w  death_egg_zone_act_1		; Act 1
	zoneTableEntry.w  0				; Act 2
	; HTZ
	zoneTableEntry.w  hill_top_zone_act_2		; Act 1
	zoneTableEntry.w  mystic_cave_zone_act_1	; Act 2
	; HPZ
	zoneTableEntry.w  hidden_palace_zone_act_2 	; Act 1
	zoneTableEntry.w  oil_ocean_zone_act_1		; Act 2
	; Zone 9
	zoneTableEntry.w  0				; Act 1
	zoneTableEntry.w  0				; Act 2
	; OOZ
	zoneTableEntry.w  oil_ocean_zone_act_2		; Act 1
	zoneTableEntry.w  metropolis_zone_act_1		; Act 2
	; MCZ
	zoneTableEntry.w  mystic_cave_zone_act_2	; Act 1
	zoneTableEntry.w  -1				; Act 2
	; CNZ
	zoneTableEntry.w  casino_night_zone_act_2	; Act 1
	zoneTableEntry.w  mystic_cave_zone_act_1	; Act 2
	; CPZ
	zoneTableEntry.w  chemical_plant_zone_act_2 	; Act 1
	zoneTableEntry.w  aquatic_ruin_zone_act_1	; Act 2
	; DEZ
	zoneTableEntry.w  -1				; Act 1
	zoneTableEntry.w  0				; Act 2
	; ARZ
	zoneTableEntry.w  aquatic_ruin_zone_act_2	; Act 1
	zoneTableEntry.w  casino_night_zone_act_1	; Act 2
	; SCZ
	zoneTableEntry.w  wing_fortress_zone_act_1 	; Act 1
	zoneTableEntry.w  0				; Act 2
    zoneTableEnd

results_screen_object macro startx, targetx, y, routine, frame
	dc.w	128+startx, 128+targetx, 128+y
	dc.b	routine, frame
    endm

results_screen_object_size = 8

; byte_14380:
Obj3A_SubObjectMetadata:
	;                      start X, target X, start Y, routine, map frame
	results_screen_object     0-96,    320/2,      56,       2,         0
	results_screen_object   320+64, 320/2-32,      74,       4,         3
	results_screen_object  320+128, 320/2+32,      74,       6,         4
	results_screen_object  320+184, 320/2+88,      62,       8,         6
	results_screen_object  320+400,    320/2,     160,       4,         9
	results_screen_object  320+352,    320/2,     112,       4,        $A
	results_screen_object  320+368,    320/2,     128,       4,        $B
	results_screen_object  320+384,    320/2,     144,     $16,        $E
Obj3A_SubObjectMetadata_End:
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 6F - End of special stage results screen
; ----------------------------------------------------------------------------
; Sprite_143C0:
Obj6F: ; (note: screen-space obj)
	moveq	#0,d0
	moveq	#0,d6
	move.b	routine(a0),d0
	move.w	Obj6F_Index(pc,d0.w),d1
	jmp	Obj6F_Index(pc,d1.w)
; ===========================================================================
; off_143D0:
Obj6F_Index:	offsetTable
		offsetTableEntry.w Obj6F_Init	;   0
		offsetTableEntry.w Obj6F_InitEmeraldText	;   2
		offsetTableEntry.w Obj6F_InitResultTitle	;   4
		offsetTableEntry.w Obj6F_Emerald0	;   6
		offsetTableEntry.w Obj6F_Emerald1	;   8
		offsetTableEntry.w Obj6F_Emerald2	;  $A
		offsetTableEntry.w Obj6F_Emerald3	;  $C
		offsetTableEntry.w Obj6F_Emerald4	;  $E
		offsetTableEntry.w Obj6F_Emerald5	; $10
		offsetTableEntry.w Obj6F_Emerald6	; $12
		offsetTableEntry.w BranchTo3_Obj34_MoveTowardsTargetPosition	; $14
		offsetTableEntry.w Obj6F_P1Rings	; $16
		offsetTableEntry.w Obj6F_P2Rings	; $18
		offsetTableEntry.w Obj6F_DeleteIfNotEmerald	; $1A
		offsetTableEntry.w Obj6F_TimedDisplay	; $1C
		offsetTableEntry.w Obj6F_TallyScore	; $1E
		offsetTableEntry.w Obj6F_TimedDisplay	; $20
		offsetTableEntry.w Obj6F_DisplayOnly	; $22
		offsetTableEntry.w Obj6F_TimedDisplay	; $24
		offsetTableEntry.w Obj6F_TimedDisplay	; $26
		offsetTableEntry.w Obj6F_TallyPerfect	; $28
		offsetTableEntry.w Obj6F_PerfectBonus	; $2A
		offsetTableEntry.w Obj6F_TimedDisplay	; $2C
		offsetTableEntry.w Obj6F_DisplayOnly	; $2E
		offsetTableEntry.w Obj6F_InitAndMoveSuperMsg	; $30
		offsetTableEntry.w Obj6F_MoveTowardsSourcePosition	; $32
		offsetTableEntry.w Obj6F_MoveAndDisplay	; $34
; ===========================================================================
;loc_14406
Obj6F_Init:
	tst.l	(Plc_Buffer).w
	beq.s	+
	rts
; ===========================================================================
+
	movea.l	a0,a1
	lea	Obj6F_SubObjectMetaData(pc),a2
	moveq	#bytesToXcnt(Obj6F_SubObjectMetaData_End-Obj6F_SubObjectMetaData, results_screen_object_size),d1

-	_move.b	id(a0),id(a1) ; load obj6F
	move.w	(a2),x_pixel(a1)
	move.w	(a2)+,titlecard_x_source(a1)
	move.w	(a2)+,titlecard_x_target(a1)
	move.w	(a2)+,y_pixel(a1)
	move.b	(a2)+,routine(a1)
	move.b	(a2)+,mapping_frame(a1)
	move.l	#Obj6F_MapUnc_14ED0,mappings(a1)
	move.b	#$78,width_pixels(a1)
	move.b	#0,render_flags(a1)
	lea	next_object(a1),a1 ; go to next object ; a1=object
	dbf	d1,- ; loop

;loc_14450
Obj6F_InitEmeraldText:
	tst.b	(Got_Emerald).w
	beq.s	+
	move.b	#4,mapping_frame(a0)		; "Chaos Emerald"
+
	cmpi.b	#7,(Emerald_count).w
	bne.s	+
	move.b	#$19,mapping_frame(a0)		; "Chaos Emeralds"
+
	move.w	titlecard_x_target(a0),d0
	cmp.w	x_pixel(a0),d0
	bne.s	BranchTo2_Obj34_MoveTowardsTargetPosition
	move.b	#$1C,routine(a0)	; => Obj6F_TimedDisplay
	move.w	#$B4,anim_frame_duration(a0)

BranchTo2_Obj34_MoveTowardsTargetPosition
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================
;loc_14484
Obj6F_InitResultTitle:
	cmpi.b	#7,(Emerald_count).w
	bne.s	+
	moveq	#$16,d0		; "Sonic has all the"
	bra.s	++
; ===========================================================================
+
	tst.b	(Got_Emerald).w
	beq.w	DeleteObject
	moveq	#1,d0		; "Sonic got a"
+
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	addq.w	#1,d0		; "Miles got a" or "Miles has all the"
	btst	#7,(Graphics_Flags).w
	beq.s	+
	addq.w	#1,d0		; "Tails got a" or "Tails has all the"
+
	move.b	d0,mapping_frame(a0)
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================
;loc_144B6
Obj6F_Emerald6:
	addq.w	#1,d6
;loc_144B8
Obj6F_Emerald5:
	addq.w	#1,d6
;loc_144BA
Obj6F_Emerald4:
	addq.w	#1,d6
;loc_144BC
Obj6F_Emerald3:
	addq.w	#1,d6
;loc_144BE
Obj6F_Emerald2:
	addq.w	#1,d6
;loc_144C0
Obj6F_Emerald1:
	addq.w	#1,d6
;loc_144C2
Obj6F_Emerald0:
	lea	(Got_Emeralds_array).w,a1
	tst.b	(a1,d6.w)
	beq.w	DeleteObject
	btst	#0,(Vint_runcount+3).w
	beq.s	+
	bsr.w	DisplaySprite
+
	rts
; ===========================================================================
;loc_144DC
Obj6F_P2Rings:
	tst.w	(Player_mode).w
	bne.w	DeleteObject
	cmpi.b	#$26,(SpecialStageResults+routine).w	; Do we need space for perfect countdown?
	beq.w	DeleteObject							; Branch if yes
	moveq	#$E,d0		; "Miles rings"
	btst	#7,(Graphics_Flags).w
	beq.s	+
	addq.w	#1,d0		; "Tails rings"
+
	lea	(Bonus_Countdown_2).w,a1
	bra.s	loc_1455A
; ===========================================================================
;loc_14500
Obj6F_P1Rings:
	cmpi.b	#$26,(SpecialStageResults+routine).w	; Do we need space for perfect countdown?
	bne.s	+										; Branch if not
	move.w	#5000,(Bonus_Countdown_1).w				; Perfect bonus
	move.b	#$2A,routine(a0)	; => Obj6F_PerfectBonus
	move.w	#$120,y_pixel(a0)
	st.b	(Update_Bonus_score).w	; set to -1 (update)
	move.w	#SndID_Signpost,d0
	jsr	(PlaySound).l
	move.w	#$5A,(SpecialStageResults+anim_frame_duration).w
	bra.w	Obj6F_PerfectBonus
; ===========================================================================
+
	move.w	(Player_mode).w,d0
	beq.s	++
	move.w	#$120,y_pixel(a0)
	subq.w	#1,d0
	beq.s	++
	moveq	#$E,d0		; "Miles rings"
	btst	#7,(Graphics_Flags).w
	beq.s	+
	addq.w	#1,d0		; "Tails rings"
+
	lea	(Bonus_Countdown_2).w,a1
	bra.s	loc_1455A
; ===========================================================================
+
	moveq	#$D,d0		; "Sonic rings"
	lea	(Bonus_Countdown_1).w,a1

loc_1455A:
	tst.w	(a1)
	bne.s	+
	addq.w	#5,d0		; Rings text with zero points
+
	move.b	d0,mapping_frame(a0)

BranchTo3_Obj34_MoveTowardsTargetPosition
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================
;loc_14568
Obj6F_DeleteIfNotEmerald:
	tst.b	(Got_Emerald).w
	beq.w	DeleteObject
	bra.s	BranchTo3_Obj34_MoveTowardsTargetPosition
; ===========================================================================
;loc_14572
Obj6F_TimedDisplay:
	subq.w	#1,anim_frame_duration(a0)
	bne.s	BranchTo19_DisplaySprite
	addq.b	#2,routine(a0)

BranchTo19_DisplaySprite
	bra.w	DisplaySprite
; ===========================================================================
;loc_14580
Obj6F_TallyScore:
	bsr.w	DisplaySprite
	move.b	#1,(Update_Bonus_score).w
	moveq	#0,d0
	tst.w	(Bonus_Countdown_1).w
	beq.s	+
	addi.w	#10,d0
	subq.w	#1,(Bonus_Countdown_1).w
+
	tst.w	(Bonus_Countdown_2).w
	beq.s	+
	addi.w	#10,d0
	subq.w	#1,(Bonus_Countdown_2).w
+
	tst.w	(Total_Bonus_Countdown).w
	beq.s	+
	addi.w	#10,d0
	subi.w	#10,(Total_Bonus_Countdown).w
+
	tst.w	d0
	bne.s	+++
	move.w	#SndID_TallyEnd,d0
	jsr	(PlaySound).l
	addq.b	#2,routine(a0)		; => Obj6F_TimedDisplay
	move.w	#$78,anim_frame_duration(a0)
	tst.w	(Perfect_rings_flag).w
	bne.s	+
	cmpi.w	#2,(Player_mode).w
	beq.s	++		; rts
	tst.b	(Got_Emerald).w
	beq.s	++		; rts
	cmpi.b	#7,(Emerald_count).w
	bne.s	++		; rts
	move.b	#$30,routine(a0)	; => Obj6F_InitAndMoveSuperMsg
	rts
; ===========================================================================
+
	move.b	#$24,routine(a0)	; => Obj6F_TimedDisplay
	move.w	#$5A,anim_frame_duration(a0)
/
	rts
; ===========================================================================
+
	jsr	(AddPoints).l
	move.b	(Vint_runcount+3).w,d0
	andi.b	#3,d0
	bne.s	-		; rts
	move.w	#SndID_Blip,d0
	jmp	(PlaySound).l
; ===========================================================================
;loc_1461C
Obj6F_DisplayOnly:
	move.w	#1,(Level_Inactive_flag).w
	bra.w	DisplaySprite
; ===========================================================================
;loc_14626
Obj6F_TallyPerfect:
	bsr.w	DisplaySprite
	move.b	#1,(Update_Bonus_score).w
	moveq	#0,d0
	tst.w	(Bonus_Countdown_1).w
	beq.s	+
	addi.w	#20,d0
	subi.w	#20,(Bonus_Countdown_1).w
+
	tst.w	d0
	beq.s	+
	jsr	(AddPoints).l
	move.b	(Vint_runcount+3).w,d0
	andi.b	#3,d0
	bne.s	++		; rts
	move.w	#SndID_Blip,d0
	jmp	(PlaySound).l
; ===========================================================================
+
	move.w	#SndID_TallyEnd,d0
	jsr	(PlaySound).l
	addq.b	#4,routine(a0)
	move.w	#$78,anim_frame_duration(a0)
	cmpi.w	#2,(Player_mode).w
	beq.s	+		; rts
	tst.b	(Got_Emerald).w
	beq.s	+		; rts
	cmpi.b	#7,(Emerald_count).w
	bne.s	+		; rts
	move.b	#$30,routine(a0)	; => Obj6F_InitAndMoveSuperMsg
+
	rts
; ===========================================================================
;loc_14692
Obj6F_PerfectBonus:
	moveq	#$11,d0		; "Perfect bonus"
	btst	#3,(Vint_runcount+3).w
	beq.s	+
	moveq	#$15,d0		; null text
+
	move.b	d0,mapping_frame(a0)
	bra.w	DisplaySprite
; ===========================================================================
;loc_146A6
Obj6F_InitAndMoveSuperMsg:
	move.b	#$32,next_object+routine(a0)			; => Obj6F_MoveTowardsSourcePosition
	move.w	x_pixel(a0),d0
	cmp.w	titlecard_x_source(a0),d0
	bne.s	Obj6F_MoveTowardsSourcePosition
	move.b	#$14,next_object+routine(a0)			; => BranchTo3_Obj34_MoveTowardsTargetPosition
	subq.w	#8,next_object+y_pixel(a0)
	move.b	#$1A,next_object+mapping_frame(a0)		; "Now Sonic can"
	move.b	#$34,routine(a0)						; => Obj6F_MoveAndDisplay
	subq.w	#8,y_pixel(a0)
	move.b	#$1B,mapping_frame(a0)					; "Change into"
	lea	(SpecialStageResults2).w,a1
	_move.b	id(a0),id(a1) ; load obj6F; (uses screen-space)
	clr.w	x_pixel(a1)
	move.w	#$120,titlecard_x_target(a1)
	move.w	#$B4,y_pixel(a1)
	move.b	#$14,routine(a1)						; => BranchTo3_Obj34_MoveTowardsTargetPosition
	move.b	#$1C,mapping_frame(a1)					; "Super Sonic"
	move.l	#Obj6F_MapUnc_14ED0,mappings(a1)
	move.b	#$78,width_pixels(a1)
	move.b	#0,render_flags(a1)
	bra.w	DisplaySprite
; ===========================================================================
; Modified copy of `Obj34_MoveTowardsTargetPosition`. It has a higher speed
; and moves the object toward its source instead of its destination.
;loc_14714 Obj6F_MoveToTargetPos
Obj6F_MoveTowardsSourcePosition:
	moveq	#$20,d0 ; Movement speed
	move.w	x_pixel(a0),d1
	cmp.w	titlecard_x_source(a0),d1
	beq.s	.display
	bhi.s	+
	neg.w	d0
+
	sub.w	d0,x_pixel(a0)
	; If target lies very far off-screen, then don't bother trying to display it.
	; This is because the sprite coordinates are prone to overflow and underflow.
	cmpi.w	#128+320+64,x_pixel(a0)
	bhi.s	.return
;BranchTo20_DisplaySprite
.display:
	bra.w	DisplaySprite
.return:
	rts
; ===========================================================================
;loc_14736
Obj6F_MoveAndDisplay:
	move.w	x_pixel(a0),d0
	cmp.w	titlecard_x_target(a0),d0
	bne.w	Obj34_MoveTowardsTargetPosition
	move.w	#$B4,anim_frame_duration(a0)
	move.b	#$20,routine(a0)	; => Obj6F_TimedDisplay
	bra.w	DisplaySprite
; ===========================================================================
;byte_14752
Obj6F_SubObjectMetaData:
	;                       start X, target X, start Y, routine, map frame
	results_screen_object   320+128,    320/2,      42,       2,         0		; "Special Stage"
	results_screen_object     0-128,    320/2,      24,       4,         1		; "Sonic got a"
	results_screen_object   320/2-8,    0-128,      68,       6,         5		; Emerald 0
	results_screen_object  320/2+16,    0-128,      80,       8,         6		; Emerald 1
	results_screen_object  320/2+16,    0-128,     104,      $A,         7		; Emerald 2
	results_screen_object   320/2-8,    0-128,     116,      $C,         8		; Emerald 3
	results_screen_object  320/2-32,    0-128,     104,      $E,         9		; Emerald 4
	results_screen_object  320/2-32,    0-128,      80,     $10,        $A		; Emerald 5
	results_screen_object   320/2-8,    0-128,      92,     $12,        $B		; Emerald 6
	results_screen_object   320+368,    320/2,     136,     $14,        $C		; Score
	results_screen_object   320+384,    320/2,     152,     $16,        $D		; Sonic Rings
	results_screen_object   320+400,    320/2,     168,     $18,        $E		; Miles Rings
	results_screen_object   320+416,    320/2,     184,     $1A,       $10		; Gems Bonus
Obj6F_SubObjectMetaData_End:
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj34_MapUnc_147BA:	mappingsTable
.zone_names:	zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w word_147E8	; EHZ
	zoneOffsetTableEntry.w word_147E8	; Zone 1
	zoneOffsetTableEntry.w word_147E8	; WZ
	zoneOffsetTableEntry.w word_147E8	; Zone 3
	zoneOffsetTableEntry.w word_14842	; MTZ1,2
	zoneOffsetTableEntry.w word_14842	; MTZ3
	zoneOffsetTableEntry.w word_14B24	; WFZ
	zoneOffsetTableEntry.w word_14894	; HTZ
	zoneOffsetTableEntry.w word_148CE	; HPZ
	zoneOffsetTableEntry.w word_147E8	; Zone 9
	zoneOffsetTableEntry.w word_14930	; OOZ
	zoneOffsetTableEntry.w word_14972	; MCZ
	zoneOffsetTableEntry.w word_149C4	; CNZ
	zoneOffsetTableEntry.w word_14A1E	; CPZ
	zoneOffsetTableEntry.w word_14B86	; DEZ
	zoneOffsetTableEntry.w word_14A88	; ARZ
	zoneOffsetTableEntry.w word_14AE2	; SCZ
    zoneTableEnd
	mappingsTableEntry.w	word_14BC8
	mappingsTableEntry.w	word_14BEA
	mappingsTableEntry.w	word_14BF4
	mappingsTableEntry.w	word_14BFE
	mappingsTableEntry.w	word_14C08
	mappingsTableEntry.w	word_14C32

word_147E8:	spriteHeader
	spritePiece	-$3D, 0, 2, 2, $580, 0, 0, 0, 1
	spritePiece	-$30, 0, 3, 2, $5DE, 0, 0, 0, 1
	spritePiece	-$18, 0, 2, 2, $580, 0, 0, 0, 1
	spritePiece	-8, 0, 2, 2, $5E4, 0, 0, 0, 1
	spritePiece	8, 0, 2, 2, $5E8, 0, 0, 0, 1
	spritePiece	$18, 0, 2, 2, $5EC, 0, 0, 0, 1
	spritePiece	$28, 0, 2, 2, $5F0, 0, 0, 0, 1
	spritePiece	$48, 0, 2, 2, $5F4, 0, 0, 0, 1
	spritePiece	$58, 0, 1, 2, $5F8, 0, 0, 0, 1
	spritePiece	$60, 0, 2, 2, $5EC, 0, 0, 0, 1
	spritePiece	$70, 0, 2, 2, $5EC, 0, 0, 0, 1
word_147E8_End

word_14842:	spriteHeader
	spritePiece	-$20, 0, 3, 2, $5DE, 0, 0, 0, 1
	spritePiece	-8, 0, 2, 2, $580, 0, 0, 0, 1
	spritePiece	8, 0, 2, 2, $5E4, 0, 0, 0, 1
	spritePiece	$18, 0, 2, 2, $5E8, 0, 0, 0, 1
	spritePiece	$28, 0, 2, 2, $588, 0, 0, 0, 1
	spritePiece	$38, 0, 2, 2, $5EC, 0, 0, 0, 1
	spritePiece	$48, 0, 2, 2, $588, 0, 0, 0, 1
	spritePiece	$58, 0, 2, 2, $5F0, 0, 0, 0, 1
	spritePiece	$68, 0, 1, 2, $5F4, 0, 0, 0, 1
	spritePiece	$70, 0, 2, 2, $5F6, 0, 0, 0, 1
word_14842_End

word_14894:	spriteHeader
	spritePiece	8, 0, 2, 2, $5DE, 0, 0, 0, 1
	spritePiece	$18, 0, 1, 2, $5E2, 0, 0, 0, 1
	spritePiece	$20, 0, 2, 2, $5E4, 0, 0, 0, 1
	spritePiece	$30, 0, 2, 2, $5E4, 0, 0, 0, 1
	spritePiece	$51, 0, 2, 2, $5E8, 0, 0, 0, 1
	spritePiece	$60, 0, 2, 2, $588, 0, 0, 0, 1
	spritePiece	$70, 0, 2, 2, $5EC, 0, 0, 0, 1
word_14894_End

word_148CE:	spriteHeader
	spritePiece	-$48, 0, 2, 2, $5DE, 0, 0, 0, 1
	spritePiece	-$38, 0, 1, 2, $5E2, 0, 0, 0, 1
	spritePiece	-$30, 0, 2, 2, $5E4, 0, 0, 0, 1
	spritePiece	-$20, 0, 2, 2, $5E4, 0, 0, 0, 1
	spritePiece	-$10, 0, 2, 2, $580, 0, 0, 0, 1
	spritePiece	0, 0, 2, 2, $584, 0, 0, 0, 1
	spritePiece	$20, 0, 2, 2, $5E8, 0, 0, 0, 1
	spritePiece	$30, 0, 2, 2, $5EC, 0, 0, 0, 1
	spritePiece	$40, 0, 2, 2, $5F0, 0, 0, 0, 1
	spritePiece	$50, 0, 2, 2, $5EC, 0, 0, 0, 1
	spritePiece	$60, 0, 2, 2, $5F4, 0, 0, 0, 1
	spritePiece	$70, 0, 2, 2, $580, 0, 0, 0, 1
word_148CE_End

word_14930:	spriteHeader
	spritePiece	-5, 0, 2, 2, $588, 0, 0, 0, 1
	spritePiece	$B, 0, 1, 2, $5DE, 0, 0, 0, 1
	spritePiece	$13, 0, 2, 2, $5E0, 0, 0, 0, 1
	spritePiece	$33, 0, 2, 2, $588, 0, 0, 0, 1
	spritePiece	$43, 0, 2, 2, $5E4, 0, 0, 0, 1
	spritePiece	$53, 0, 2, 2, $580, 0, 0, 0, 1
	spritePiece	$60, 0, 2, 2, $5E8, 0, 0, 0, 1
	spritePiece	$70, 0, 2, 2, $584, 0, 0, 0, 1
word_14930_End

word_14972:	spriteHeader
	spritePiece	-$30, 0, 3, 2, $5DE, 0, 0, 0, 1
	spritePiece	-$18, 0, 2, 2, $5E4, 0, 0, 0, 1
	spritePiece	-8, 0, 2, 2, $5E8, 0, 0, 0, 1
	spritePiece	8, 0, 2, 2, $5EC, 0, 0, 0, 1
	spritePiece	$18, 0, 1, 2, $5F0, 0, 0, 0, 1
	spritePiece	$20, 0, 2, 2, $5F2, 0, 0, 0, 1
	spritePiece	$41, 0, 2, 2, $5F2, 0, 0, 0, 1
	spritePiece	$50, 0, 2, 2, $5F6, 0, 0, 0, 1
	spritePiece	$60, 0, 2, 2, $5FA, 0, 0, 0, 1
	spritePiece	$70, 0, 2, 2, $580, 0, 0, 0, 1
word_14972_End

word_149C4:	spriteHeader
	spritePiece	-$2F, 0, 2, 2, $5DE, 0, 0, 0, 1
	spritePiece	-$20, 0, 2, 2, $5E2, 0, 0, 0, 1
	spritePiece	-$10, 0, 2, 2, $5E6, 0, 0, 0, 1
	spritePiece	0, 0, 1, 2, $5EA, 0, 0, 0, 1
	spritePiece	8, 0, 2, 2, $584, 0, 0, 0, 1
	spritePiece	$18, 0, 2, 2, $588, 0, 0, 0, 1
	spritePiece	$38, 0, 2, 2, $584, 0, 0, 0, 1
	spritePiece	$48, 0, 1, 2, $5EA, 0, 0, 0, 1
	spritePiece	$50, 0, 2, 2, $5EC, 0, 0, 0, 1
	spritePiece	$60, 0, 2, 2, $5F0, 0, 0, 0, 1
	spritePiece	$70, 0, 2, 2, $5F4, 0, 0, 0, 1
word_149C4_End

word_14A1E:	spriteHeader
	spritePiece	-$5C, 0, 2, 2, $5DE, 0, 0, 0, 1
	spritePiece	-$4C, 0, 2, 2, $5E2, 0, 0, 0, 1
	spritePiece	-$3C, 0, 2, 2, $580, 0, 0, 0, 1
	spritePiece	-$2F, 0, 3, 2, $5E6, 0, 0, 0, 1
	spritePiece	-$17, 0, 1, 2, $5EC, 0, 0, 0, 1
	spritePiece	-$F, 0, 2, 2, $5DE, 0, 0, 0, 1
	spritePiece	0, 0, 2, 2, $5EE, 0, 0, 0, 1
	spritePiece	$10, 0, 2, 2, $5F2, 0, 0, 0, 1
	spritePiece	$31, 0, 2, 2, $5F6, 0, 0, 0, 1
	spritePiece	$41, 0, 2, 2, $5F2, 0, 0, 0, 1
	spritePiece	$50, 0, 2, 2, $5EE, 0, 0, 0, 1
	spritePiece	$60, 0, 2, 2, $584, 0, 0, 0, 1
	spritePiece	$70, 0, 2, 2, $5FA, 0, 0, 0, 1
word_14A1E_End

word_14A88:	spriteHeader
	spritePiece	-$2E, 0, 2, 2, $5DE, 0, 0, 0, 1
	spritePiece	-$1E, 0, 2, 2, $5E2, 0, 0, 0, 1
	spritePiece	-$E, 0, 2, 2, $5E6, 0, 0, 0, 1
	spritePiece	0, 0, 2, 2, $5DE, 0, 0, 0, 1
	spritePiece	$10, 0, 2, 2, $5EA, 0, 0, 0, 1
	spritePiece	$20, 0, 1, 2, $5EE, 0, 0, 0, 1
	spritePiece	$28, 0, 2, 2, $5F0, 0, 0, 0, 1
	spritePiece	$48, 0, 2, 2, $5F4, 0, 0, 0, 1
	spritePiece	$58, 0, 2, 2, $5E6, 0, 0, 0, 1
	spritePiece	$68, 0, 1, 2, $5EE, 0, 0, 0, 1
	spritePiece	$70, 0, 2, 2, $584, 0, 0, 0, 1
word_14A88_End

word_14AE2:	spriteHeader
	spritePiece	-$10, 0, 2, 2, $5DE, 0, 0, 0, 1
	spritePiece	0, 0, 2, 2, $5E2, 0, 0, 0, 1
	spritePiece	$10, 0, 2, 2, $5E6, 0, 0, 0, 1
	spritePiece	$30, 0, 2, 2, $5EA, 0, 0, 0, 1
	spritePiece	$40, 0, 2, 2, $5EE, 0, 0, 0, 1
	spritePiece	$50, 0, 2, 2, $5F2, 0, 0, 0, 1
	spritePiece	$60, 0, 2, 2, $5DE, 0, 0, 0, 1
	spritePiece	$70, 0, 2, 2, $580, 0, 0, 0, 1
word_14AE2_End

word_14B24:	spriteHeader
	spritePiece	-$4F, 0, 3, 2, $5DE, 0, 0, 0, 1
	spritePiece	-$38, 0, 1, 2, $5E4, 0, 0, 0, 1
	spritePiece	-$30, 0, 2, 2, $584, 0, 0, 0, 1
	spritePiece	-$20, 0, 2, 2, $5E6, 0, 0, 0, 1
	spritePiece	1, 0, 2, 2, $5EA, 0, 0, 0, 1
	spritePiece	$10, 0, 2, 2, $588, 0, 0, 0, 1
	spritePiece	$20, 0, 2, 2, $5EE, 0, 0, 0, 1
	spritePiece	$30, 0, 2, 2, $5F2, 0, 0, 0, 1
	spritePiece	$40, 0, 2, 2, $5EE, 0, 0, 0, 1
	spritePiece	$50, 0, 2, 2, $580, 0, 0, 0, 1
	spritePiece	$5F, 0, 2, 2, $5F6, 0, 0, 0, 1
	spritePiece	$6F, 0, 2, 2, $5F6, 0, 0, 0, 1
word_14B24_End

word_14B86:	spriteHeader
	spritePiece	-$E, 0, 2, 2, $5DE, 0, 0, 0, 1
	spritePiece	2, 0, 2, 2, $580, 0, 0, 0, 1
	spritePiece	$10, 0, 2, 2, $5E2, 0, 0, 0, 1
	spritePiece	$20, 0, 2, 2, $5E6, 0, 0, 0, 1
	spritePiece	$30, 0, 2, 2, $5EA, 0, 0, 0, 1
	spritePiece	$51, 0, 2, 2, $580, 0, 0, 0, 1
	spritePiece	$60, 0, 2, 2, $5EE, 0, 0, 0, 1
	spritePiece	$70, 0, 2, 2, $5EE, 0, 0, 0, 1
word_14B86_End

word_14BC8:	spriteHeader
	spritePiece	1, 0, 2, 2, $58C, 0, 0, 0, 1
	spritePiece	$10, 0, 2, 2, $588, 0, 0, 0, 1
	spritePiece	$20, 0, 2, 2, $584, 0, 0, 0, 1
	spritePiece	$30, 0, 2, 2, $580, 0, 0, 0, 1
word_14BC8_End

word_14BEA:	spriteHeader
	spritePiece	0, 0, 2, 4, $590, 0, 0, 1, 1
word_14BEA_End

word_14BF4:	spriteHeader
	spritePiece	0, 0, 3, 4, $598, 0, 0, 1, 1
word_14BF4_End

word_14BFE:	spriteHeader
	spritePiece	0, 0, 3, 4, $5A4, 0, 0, 1, 1
word_14BFE_End

word_14C08:	spriteHeader
	spritePiece	-$48, 0, 4, 2, $5B0, 0, 0, 0, 1
	spritePiece	-$28, 0, 4, 2, $5B8, 0, 0, 0, 1
	spritePiece	-8, 0, 4, 2, $5C0, 0, 0, 0, 1
	spritePiece	$18, 0, 4, 2, $5C8, 0, 0, 0, 1
	spritePiece	$38, 0, 2, 2, $5D0, 0, 0, 0, 1
word_14C08_End

word_14C32:	spriteHeader
	spritePiece	0, -$70, 1, 4, $5D4, 0, 0, 0, 1
	spritePiece	0, -$50, 1, 4, $5D4, 0, 0, 0, 1
	spritePiece	0, -$30, 1, 4, $5D4, 0, 0, 0, 1
	spritePiece	0, -$10, 1, 4, $5D4, 0, 0, 0, 1
	spritePiece	0, $10, 1, 4, $5D4, 0, 0, 0, 1
	spritePiece	0, $30, 1, 4, $5D4, 0, 0, 0, 1
	spritePiece	0, $50, 1, 4, $5D4, 0, 0, 0, 1
word_14C32_End

	even

; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj39_MapUnc_14C6C:	include "mappings/sprite/obj39.asm"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj3A_MapUnc_14CBC:	mappingsTable
	mappingsTableEntry.w	word_14CDA
	mappingsTableEntry.w	word_14D1C
	mappingsTableEntry.w	word_14D5E
	mappingsTableEntry.w	word_14DA0
	mappingsTableEntry.w	word_14DDA
	mappingsTableEntry.w	word_14BC8
	mappingsTableEntry.w	word_14BEA
	mappingsTableEntry.w	word_14BF4
	mappingsTableEntry.w	word_14BFE
	mappingsTableEntry.w	word_14DF4
	mappingsTableEntry.w	word_14E1E
	mappingsTableEntry.w	word_14E50
	mappingsTableEntry.w	word_14E82
	mappingsTableEntry.w	word_14E8C
	mappingsTableEntry.w	word_14E96

word_14CDA:	spriteHeader
	spritePiece	-$40, 0, 2, 2, $5D0, 0, 0, 0, 1
	spritePiece	-$30, 0, 2, 2, $588, 0, 0, 0, 1
	spritePiece	-$20, 0, 2, 2, $584, 0, 0, 0, 1
	spritePiece	-$10, 0, 1, 2, $5C0, 0, 0, 0, 1
	spritePiece	-8, 0, 2, 2, $5B4, 0, 0, 0, 1
	spritePiece	$10, 0, 2, 2, $5B8, 0, 0, 0, 1
	spritePiece	$20, 0, 2, 2, $588, 0, 0, 0, 1
	spritePiece	$2F, 0, 2, 2, $5D4, 0, 0, 0, 1
word_14CDA_End

word_14D1C:	spriteHeader
	spritePiece	-$44, 0, 3, 2, $5C6, 0, 0, 0, 1
	spritePiece	-$2C, 0, 1, 2, $5C0, 0, 0, 0, 1
	spritePiece	-$24, 0, 2, 2, $5C2, 0, 0, 0, 1
	spritePiece	-$14, 0, 2, 2, $580, 0, 0, 0, 1
	spritePiece	-4, 0, 2, 2, $5D0, 0, 0, 0, 1
	spritePiece	$14, 0, 2, 2, $5B8, 0, 0, 0, 1
	spritePiece	$24, 0, 2, 2, $588, 0, 0, 0, 1
	spritePiece	$33, 0, 2, 2, $5D4, 0, 0, 0, 1
word_14D1C_End

word_14D5E:	spriteHeader
	spritePiece	-$3D, 0, 2, 2, $5D4, 0, 0, 0, 1
	spritePiece	-$30, 0, 2, 2, $5B0, 0, 0, 0, 1
	spritePiece	-$20, 0, 1, 2, $5C0, 0, 0, 0, 1
	spritePiece	-$18, 0, 2, 2, $5C2, 0, 0, 0, 1
	spritePiece	-8, 0, 2, 2, $5D0, 0, 0, 0, 1
	spritePiece	$10, 0, 2, 2, $5B8, 0, 0, 0, 1
	spritePiece	$20, 0, 2, 2, $588, 0, 0, 0, 1
	spritePiece	$2F, 0, 2, 2, $5D4, 0, 0, 0, 1
word_14D5E_End

word_14DA0:	spriteHeader
	spritePiece	-$38, 0, 2, 2, $5D4, 0, 0, 0, 1
	spritePiece	-$28, 0, 2, 2, $5BC, 0, 0, 0, 1
	spritePiece	-$18, 0, 2, 2, $5CC, 0, 0, 0, 1
	spritePiece	-8, 0, 2, 2, $588, 0, 0, 0, 1
	spritePiece	8, 0, 2, 2, $5D8, 0, 0, 0, 1
	spritePiece	$18, 0, 2, 2, $5B8, 0, 0, 0, 1
	spritePiece	$28, 0, 2, 2, $5BC, 0, 0, 0, 1
word_14DA0_End

word_14DDA:	spriteHeader
	spritePiece	0, 0, 2, 2, $5B0, 0, 0, 0, 1
	spritePiece	$10, 0, 2, 2, $5B4, 0, 0, 0, 1
	spritePiece	$1F, 0, 2, 2, $5D4, 0, 0, 0, 1
word_14DDA_End

word_14DF4:	spriteHeader
	spritePiece	-$48, 0, 3, 2, $5E6, 0, 0, 1, 1
	spritePiece	-$30, 0, 2, 2, $5EC, 0, 0, 1, 1
	spritePiece	-$2C, 0, 2, 2, $5F0, 0, 0, 0, 1
	spritePiece	$38, 0, 4, 2, $520, 0, 0, 0, 1
	spritePiece	$58, 0, 1, 2, $6F0, 0, 0, 0, 1
word_14DF4_End

word_14E1E:	spriteHeader
	spritePiece	-$5C, 0, 4, 2, $6DA, 0, 0, 1, 1
	spritePiece	-$34, 0, 4, 2, $5DE, 0, 0, 1, 1
	spritePiece	-$14, 0, 1, 2, $6CA, 0, 0, 1, 1
	spritePiece	-$18, 0, 2, 2, $5F0, 0, 0, 0, 1
	spritePiece	$38, 0, 4, 2, $528, 0, 0, 0, 1
	spritePiece	$58, 0, 1, 2, $6F0, 0, 0, 0, 1
word_14E1E_End

word_14E50:	spriteHeader
	spritePiece	-$5C, 0, 4, 2, $6D2, 0, 0, 1, 1
	spritePiece	-$34, 0, 4, 2, $5DE, 0, 0, 1, 1
	spritePiece	-$14, 0, 1, 2, $6CA, 0, 0, 1, 1
	spritePiece	-$18, 0, 2, 2, $5F0, 0, 0, 0, 1
	spritePiece	$38, 0, 4, 2, $530, 0, 0, 0, 1
	spritePiece	$58, 0, 1, 2, $6F0, 0, 0, 0, 1
word_14E50_End

word_14E82:	spriteHeader
	spritePiece	0, 0, 2, 3, $5F4, 0, 0, 0, 1
word_14E82_End

word_14E8C:	spriteHeader
	spritePiece	0, 0, 2, 3, $5FA, 0, 0, 0, 1
word_14E8C_End

word_14E96:	spriteHeader
	spritePiece	-$68, 0, 4, 2, $540, 0, 0, 1, 1
	spritePiece	-$48, 0, 3, 2, $548, 0, 0, 1, 1
	spritePiece	-$28, 0, 4, 2, $5DE, 0, 0, 1, 1
	spritePiece	-8, 0, 1, 2, $6CA, 0, 0, 1, 1
	spritePiece	-$C, 0, 2, 2, $5F0, 0, 0, 0, 1
	spritePiece	$38, 0, 4, 2, $538, 0, 0, 0, 1
	spritePiece	$58, 0, 1, 2, $6F0, 0, 0, 0, 1
word_14E96_End

	even

; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj6F_MapUnc_14ED0:	include "mappings/sprite/obj6F.asm"
; ===========================================================================

;loc_15584: ; level title card drawing function called from Vint
DrawLevelTitleCard:
	lea	(VDP_data_port).l,a6
	tst.w	(TitleCard_ZoneName+titlecard_leaveflag).w
	bne.w	loc_15670
	moveq	#$3F,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6
	tst.w	(Two_player_mode).w
	beq.s	loc_155A8
	moveq	#$1F,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6

loc_155A8:
	lea	(TitleCard_Background+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)

loc_155AE:
	move.w	(a0)+,d0
	beq.s	loc_155C6
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d5,d4

loc_155C0:
	move.l	d6,(a6)
	dbf	d4,loc_155C0

loc_155C6:
	dbf	d7,loc_155AE
	moveq	#$26,d1
	sub.w	(TitleCard_Bottom+titlecard_split_point).w,d1
	lsr.w	#1,d1
	subq.w	#1,d1
	moveq	#7,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6
	tst.w	(Two_player_mode).w
	beq.s	loc_155EA
	moveq	#3,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6

loc_155EA:
	lea	(TitleCard_Bottom+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)

loc_155F0:
	move.w	(a0)+,d0
	beq.s	loc_15614
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	move.w	d5,d4

loc_155FE:
	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d1,d3

loc_15604:
	move.l	d6,(a6)
	dbf	d3,loc_15604
	addi.l	#vdpCommDelta($0080),d0
	dbf	d4,loc_155FE

loc_15614:
	dbf	d7,loc_155F0
	move.w	(TitleCard_Left+titlecard_split_point).w,d1 ; horizontal draw from left until this position
	subq.w	#1,d1
	moveq	#$D,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$58,0,0,0,1),d6 ; VRAM location of graphic to fill on left side
	tst.w	(Two_player_mode).w
	beq.s	loc_15634
	moveq	#6,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$58,0,0,0,1),d6 ; VRAM location of graphic to fill on left side (2p)

loc_15634:
	lea	(TitleCard_Left+titlecard_vram_dest).w,a0 ; obj34 red title card left side part
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)
	move.w	#$8F80,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0080

loc_15640:
	move.w	(a0)+,d0
	beq.s	loc_15664
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	move.w	d1,d4

loc_1564E:
	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d5,d3

loc_15654:
	move.l	d6,(a6)
	dbf	d3,loc_15654
	addi.l	#vdpCommDelta($0002),d0
	dbf	d4,loc_1564E

loc_15664:
	dbf	d7,loc_15640
	move.w	#$8F02,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0002
	rts
; ===========================================================================

loc_15670:
	moveq	#9,d3
	moveq	#3,d4
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6
	tst.w	(Two_player_mode).w
	beq.s	+
	moveq	#4,d3
	moveq	#1,d4
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6
+
	lea	(TitleCard_Left+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)
	move.w	#$8F80,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0080

loc_156A2:
	move.w	(a0)+,d0
	beq.s	loc_156CE
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	moveq	#3,d2

loc_156B0:
	move.l	d0,VDP_control_port-VDP_data_port(a6)

	move.w	d3,d1
-	move.l	d5,(a6)
	dbf	d1,-

	move.w	d4,d1
-	move.l	d6,(a6)
	dbf	d1,-

	addi.l	#vdpCommDelta($0002),d0
	dbf	d2,loc_156B0

loc_156CE:
	dbf	d7,loc_156A2
	move.w	#$8F02,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0002
	moveq	#7,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6
	tst.w	(Two_player_mode).w
	beq.s	+
	moveq	#3,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6
+
	lea	(TitleCard_Bottom+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)

loc_156F4:
	move.w	(a0)+,d0
	beq.s	loc_15714
	clr.w	-2(a0)
	jsr	sub_15792(pc)

	move.w	d5,d4
-	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.l	d6,(a6)
	move.l	d6,(a6)
	addi.l	#vdpCommDelta($0080),d0
	dbf	d4,-

loc_15714:
	dbf	d7,loc_156F4
	move.w	(TitleCard_Background+titlecard_vram_dest).w,d4
	beq.s	loc_1578C
	lea	VDP_control_port-VDP_data_port(a6),a5
	tst.w	(Two_player_mode).w
	beq.s	loc_15758
	lea	(Camera_X_pos_P2).w,a3
	lea	(Level_Layout).w,a4
	move.w	#vdpComm(VRAM_Plane_A_Name_Table_2P,VRAM,WRITE)>>16,d2

	moveq	#1,d6
-	movem.l	d4-d6,-(sp)
	moveq	#-$10,d5
	move.w	d4,d1
	bsr.w	CalculateVRAMAddressOfBlockForPlayer2
	move.w	d1,d4
	moveq	#-$10,d5
	moveq	#$1F,d6
	bsr.w	DrawBlockRow_CustomWidth
	movem.l	(sp)+,d4-d6
	addi.w	#$10,d4
	dbf	d6,-

loc_15758:
	lea	(Camera_X_pos).w,a3
	lea	(Level_Layout).w,a4
	move.w	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE)>>16,d2
	move.w	(TitleCard_Background+titlecard_vram_dest).w,d4

	moveq	#2-1,d6 ; Do two rows
-	movem.l	d4-d6,-(sp)
	moveq	#-16,d5
	move.w	d4,d1
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	d1,d4
	moveq	#-16,d5
	moveq	#64/2-1,d6
	bsr.w	DrawBlockRow_CustomWidth
	movem.l	(sp)+,d4-d6
	addi.w	#16,d4
	dbf	d6,-

loc_1578C:
	clr.w	(TitleCard_Background+titlecard_vram_dest).w
	rts
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to convert a VRAM address into a 32-bit VRAM write command word
; Input:
;	d0	VRAM address (word)
; Output:
;	d0	32-bit VDP command word for a VRAM write to specified address.
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_15792:
	andi.l	#$FFFF,d0
	lsl.l	#2,d0
	lsr.w	#2,d0
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d0
	swap	d0
	rts
; End of function sub_15792

; ===========================================================================

;loc_157A4
LoadTitleCardSS:
	movem.l	d0/a0,-(sp)
	bsr.s	LoadTitleCard0
	movem.l	(sp)+,d0/a0
	bra.s	loc_157EC

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_157B0:
LoadTitleCard0:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_TitleCard),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_TitleCard).l,a0
	jsrto	NemDec, JmpTo2_NemDec
	lea	(Level_Layout).w,a4
	lea	(ArtNem_TitleCard2).l,a0
	jmpto	NemDecToRAM, JmpTo_NemDecToRAM
; ===========================================================================
; loc_157D2:
LoadTitleCard:
	bsr.s	LoadTitleCard0
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	move.b	Off_TitleCardLetters(pc,d0.w),d0
	lea	TitleCardLetters(pc),a0
	lea	(a0,d0.w),a0
	move.l	#vdpComm(tiles_to_bytes(ArtTile_LevelName),VRAM,WRITE),d0

loc_157EC:
	move	#$2700,sr
	lea	(Level_Layout).w,a1
	lea	(VDP_data_port).l,a6
	move.l	d0,4(a6)

loc_157FE:
	moveq	#0,d0
	move.b	(a0)+,d0
	bmi.s	loc_1581A
	lsl.w	#5,d0
	lea	(a1,d0.w),a2
	moveq	#0,d1
	move.b	(a0)+,d1
	lsl.w	#3,d1
	subq.w	#1,d1

loc_15812:
	move.l	(a2)+,(a6)
	dbf	d1,loc_15812
	bra.s	loc_157FE
; ===========================================================================

loc_1581A:
	move	#$2300,sr
	rts
; ===========================================================================
; byte_15820:
Off_TitleCardLetters: zoneOrderedTable 1,1
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; EHZ
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; Zone 1
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; WZ
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; Zone 3
	zoneTableEntry.b TitleCardLetters_MTZ - TitleCardLetters	; MTZ1,2
	zoneTableEntry.b TitleCardLetters_MTZ - TitleCardLetters	; MTZ3
	zoneTableEntry.b TitleCardLetters_WFZ - TitleCardLetters	; WFZ
	zoneTableEntry.b TitleCardLetters_HTZ - TitleCardLetters	; HTZ
	zoneTableEntry.b TitleCardLetters_HPZ - TitleCardLetters	; HPZ
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; Zone 9
	zoneTableEntry.b TitleCardLetters_OOZ - TitleCardLetters	; OOZ
	zoneTableEntry.b TitleCardLetters_MCZ - TitleCardLetters	; MCZ
	zoneTableEntry.b TitleCardLetters_CNZ - TitleCardLetters	; CNZ
	zoneTableEntry.b TitleCardLetters_CPZ - TitleCardLetters	; CPZ
	zoneTableEntry.b TitleCardLetters_DEZ - TitleCardLetters	; DEZ
	zoneTableEntry.b TitleCardLetters_ARZ - TitleCardLetters	; ARZ
	zoneTableEntry.b TitleCardLetters_SCZ - TitleCardLetters	; SCZ
    zoneTableEnd
	even

 ; temporarily remap characters to title card letter format
 ; Characters are encoded as Aa, Bb, Cc, etc. through a macro
 charset 'A',0	; can't have an embedded 0 in a string
 charset 'B',"\4\8\xC\4\x10\x14\x18\x1C\x1E\x22\x26\x2A\4\4\x30\x34\x38\x3C\x40\x44\x48\x4C\x52\x56\4"
 charset 'a',"\4\4\4\4\4\4\4\4\2\4\4\4\6\4\4\4\4\4\4\4\4\4\6\4\4"
 charset '.',"\x5A"

; Defines which letters load for the continue screen
; Each letter occurs only once, and  the letters ENOZ (i.e. ZONE) aren't loaded here
; However, this is hidden by the titleLetters macro, and normal titles can be used
; (the macro is defined near SpecialStage_ResultsLetters, which uses it before here)

; word_15832:
TitleCardLetters:

TitleCardLetters_EHZ:
	titleLetters	"EMERALD HILL"
TitleCardLetters_MTZ:
	titleLetters	"METROPOLIS"
TitleCardLetters_HTZ:
	titleLetters	"HILL TOP"
TitleCardLetters_HPZ:
	titleLetters	"HIDDEN PALACE"
TitleCardLetters_OOZ:
	titleLetters	"OIL OCEAN"
TitleCardLetters_MCZ:
	titleLetters	"MYSTIC CAVE"
TitleCardLetters_CNZ:
	titleLetters	"CASINO NIGHT"
TitleCardLetters_CPZ:
	titleLetters	"CHEMICAL PLANT"
TitleCardLetters_ARZ:
	titleLetters	"AQUATIC RUIN"
TitleCardLetters_SCZ:
	titleLetters	"SKY CHASE"
TitleCardLetters_WFZ:
	titleLetters	"WING FORTRESS"
TitleCardLetters_DEZ:
	titleLetters	"DEATH EGG"

 charset ; revert character set

; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo2_NemDec ; JmpTo
	jmp	(NemDec).l
JmpTo_NemDecToRAM ; JmpTo
	jmp	(NemDecToRAM).l
JmpTo3_LoadPLC ; JmpTo
	jmp	(LoadPLC).l
JmpTo_sub_8476 ; JmpTo
	jmp	(sub_8476).l

	align 4
    endif
