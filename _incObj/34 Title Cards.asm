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
	move.l	#MapUnc_TitleCards,mappings(a1)
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
	move.w	#-screen_height,(Vscroll_Factor_P2_FG).w

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
	dc.w xstart,xstop,y
    endm
; word_13CD4:
Obj34_TitleCardData:
	titlecardobjdata  8,   0, $80, $1B, spriteScreenPositionX(screen_width+128), spriteScreenPositionXCentered(  0), spriteScreenPositionYCentered(-56)	; zone name
	titlecardobjdata $A, $11, $40, $1C, spriteScreenPositionX(             -88), spriteScreenPositionXCentered( 40), spriteScreenPositionYCentered(-32)	; "ZONE"
	titlecardobjdata $C, $12, $18, $1C, spriteScreenPositionX(             -24), spriteScreenPositionXCentered(104), spriteScreenPositionYCentered(-32)	; act number
	titlecardobjdata  2,   0,   0,   0,                                       0,                                  0,                                  0	; blue background
	titlecardobjdata  4, $15, $48,   8, spriteScreenPositionX(screen_width+232), spriteScreenPositionXCentered( 72), spriteScreenPositionYCentered( 48)	; bottom yellow part
	titlecardobjdata  6, $16,   8, $15, spriteScreenPositionX(               0), spriteScreenPositionXCentered(-48), spriteScreenPositionYCentered(  0)	; left red part
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
	cmpi.w	#$200,x_pixel(a0)
	bhi.s	.return
.display:
	bra.w	DisplaySprite
.return:
	rts
; End of function Obj34_MoveTowardsTargetPosition

; ===========================================================================

BranchTo9_DeleteObject ; BranchTo
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
	; If target lies very far off-screen, then don't bother trying to display it.
	; This is because the sprite coordinates are prone to overflow and underflow.
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
	; If target lies very far off-screen, then don't bother trying to display it.
	; This is because the sprite coordinates are prone to overflow and underflow.
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
	jsrto	JmpTo3_LoadPLC
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	move.b	Animal_PLCTable(pc,d0.w),d0 ; load the animal graphics for the current zone
	jsrto	JmpTo3_LoadPLC
+
	bra.w	DeleteObject		; delete the title card object
