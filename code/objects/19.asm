; ===========================================================================
; ----------------------------------------------------------------------------
; Object 19 - Platform from CPZ, OOZ and WFZ
; ----------------------------------------------------------------------------
; Sprite_22018:
Obj19:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj19_Index(pc,d0.w),d1
	jmp	Obj19_Index(pc,d1.w)
; ===========================================================================
; off_22026: Obj19_States:
Obj19_Index:	offsetTable
		offsetTableEntry.w Obj19_Init	; 0
		offsetTableEntry.w Obj19_Main	; 2
; ---------------------------------------------------------------------------
; word_2202A:
Obj19_SubtypeProperties:
	;    width_pixels
	;	  mapping_frame
	dc.b $20, 0
	dc.b $18, 1
	dc.b $40, 2
	dc.b $20, 3
; ===========================================================================
; loc_22032:
Obj19_Init:
	addq.b	#2,routine(a0) ; => Obj19_Main
	move.l	#Obj19_MapUnc_2222A,mappings(a0)

	move.w	#make_art_tile(ArtTile_ArtNem_CPZElevator,3,0),art_tile(a0) ; set default art

	cmpi.b	#oil_ocean_zone,(Current_Zone).w ; are we in OOZ?
	bne.s	+			; if not, branch
	move.w	#make_art_tile(ArtTile_ArtNem_OOZElevator,3,0),art_tile(a0) ; set OOZ art
+
	cmpi.b	#wing_fortress_zone,(Current_Zone).w ; are we in WFZ?
	bne.s	+			; if not, branch
	move.w	#make_art_tile(ArtTile_ArtNem_WfzFloatingPlatform,1,1),art_tile(a0) ; set WTZ art
+
	jsrto	Adjust2PArtPointer, JmpTo15_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#3,d0
	andi.w	#$1E,d0
	lea	Obj19_SubtypeProperties(pc,d0.w),a2
	move.b	(a2)+,width_pixels(a0)
	move.b	(a2)+,mapping_frame(a0)
	move.b	#4,priority(a0)
	move.w	x_pos(a0),objoff_30(a0)
	move.w	y_pos(a0),objoff_32(a0)
	andi.b	#$F,subtype(a0)
	cmpi.b	#3,subtype(a0)
	bne.s	loc_220AA
	btst	#0,status(a0)
	bne.s	loc_220B2

loc_220AA:
	cmpi.b	#7,subtype(a0)
	bne.s	Obj19_Main

loc_220B2:
	subi.w	#$C0,y_pos(a0)

; loc_220B8:
Obj19_Main:
	move.w	x_pos(a0),-(sp)
	bsr.w	Obj19_Move
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	move.w	#$11,d3
	move.w	(sp)+,d4
	jsrto	PlatformObject, JmpTo4_PlatformObject
	move.w	objoff_30(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo20_DeleteObject
	jmpto	DisplaySprite, JmpTo11_DisplaySprite
; ---------------------------------------------------------------------------
; loc_220E8:
Obj19_Move:
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	add.w	d0,d0
	move.w	Obj19_MoveTypes(pc,d0.w),d1
	jmp	Obj19_MoveTypes(pc,d1.w)
; ===========================================================================
; platform movement routine table
; off_220FC:
Obj19_MoveTypes:offsetTable
		offsetTableEntry.w Obj19_MoveRoutine1		;  0
		offsetTableEntry.w Obj19_MoveRoutine2		;  1
		offsetTableEntry.w Obj19_MoveRoutine3		;  2
		offsetTableEntry.w Obj19_MoveRoutine4		;  3
		offsetTableEntry.w Obj19_MoveRoutine5		;  4
		offsetTableEntry.w Obj19_MoveRoutineNull	;  5
		offsetTableEntry.w Obj19_MoveRoutine6		;  6
		offsetTableEntry.w Obj19_MoveRoutine6		;  7
		offsetTableEntry.w Obj19_MoveRoutine7		;  8
		offsetTableEntry.w Obj19_MoveRoutine7		;  9
		offsetTableEntry.w Obj19_MoveRoutine7		; $A
		offsetTableEntry.w Obj19_MoveRoutine7		; $B
		offsetTableEntry.w Obj19_MoveRoutine8		; $C
		offsetTableEntry.w Obj19_MoveRoutine8		; $D
		offsetTableEntry.w Obj19_MoveRoutine8		; $E
		offsetTableEntry.w Obj19_MoveRoutine8		; $F

; ===========================================================================
; loc_2211C:
Obj19_MoveRoutine1:
	move.b	(Oscillating_Data+8).w,d0
	move.w	#$40,d1
	bra.s	Obj19_MoveRoutine2_Part2

; ===========================================================================
; loc_22126:
Obj19_MoveRoutine2:
	move.b	(Oscillating_Data+$C).w,d0
	move.w	#$60,d1
; loc_2212E:
Obj19_MoveRoutine2_Part2:
	btst	#0,status(a0)
	beq.s	+
	neg.w	d0
	add.w	d1,d0
+
	move.w	objoff_30(a0),d1
	sub.w	d0,d1
	move.w	d1,x_pos(a0)
	rts

; ===========================================================================
; loc_22146:
Obj19_MoveRoutine3:
	move.b	(Oscillating_Data+$1C).w,d0
	move.w	#$80,d1
	btst	#0,status(a0)
	beq.s	+
	neg.w	d0
	add.w	d1,d0
+
	move.w	objoff_32(a0),d1
	sub.w	d0,d1
	move.w	d1,y_pos(a0)
	rts

; ===========================================================================
; loc_22166:
Obj19_MoveRoutine4:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	+	; rts
	addq.b	#1,subtype(a0)
+	rts

; ===========================================================================
; loc_22176:
Obj19_MoveRoutine5:
	jsrto	ObjectMove, JmpTo5_ObjectMove
	moveq	#8,d1
	move.w	objoff_32(a0),d0
	subi.w	#$60,d0
	cmp.w	y_pos(a0),d0
	bhs.s	+
	neg.w	d1
+
	add.w	d1,y_vel(a0)
	bne.s	Obj19_MoveRoutineNull
	addq.b	#1,subtype(a0)

; return_22196:
Obj19_MoveRoutineNull:
	rts

; ===========================================================================
; loc_22198:
Obj19_MoveRoutine6:
	jsrto	ObjectMove, JmpTo5_ObjectMove
	moveq	#8,d1
	move.w	objoff_32(a0),d0
	subi.w	#$60,d0
	cmp.w	y_pos(a0),d0
	bhs.s	+
	neg.w	d1
+
	add.w	d1,y_vel(a0)
	rts

; ===========================================================================
; loc_221B4:
Obj19_MoveRoutine7:
	move.b	(Oscillating_Data+$38).w,d1
	subi.b	#$40,d1
	ext.w	d1
	move.b	(Oscillating_Data+$3C).w,d2
	subi.b	#$40,d2
	ext.w	d2
	btst	#2,d0
	beq.s	+
	neg.w	d1
	neg.w	d2
+
	btst	#1,d0
	beq.s	+
	neg.w	d1
	exg	d1,d2
+
	add.w	objoff_30(a0),d1
	move.w	d1,x_pos(a0)
	add.w	objoff_32(a0),d2
	move.w	d2,y_pos(a0)
	rts

; ===========================================================================
; loc_221EE:
Obj19_MoveRoutine8:
	move.b	(Oscillating_Data+$38).w,d1
	subi.b	#$40,d1
	ext.w	d1
	move.b	(Oscillating_Data+$3C).w,d2
	subi.b	#$40,d2
	ext.w	d2
	btst	#2,d0
	beq.s	+
	neg.w	d1
	neg.w	d2
+
	btst	#1,d0
	beq.s	+
	neg.w	d1
	exg	d1,d2
+
	neg.w	d1
	add.w	objoff_30(a0),d1
	move.w	d1,x_pos(a0)
	add.w	objoff_32(a0),d2
	move.w	d2,y_pos(a0)
	rts
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj19_MapUnc_2222A:	include "mappings/sprite/obj19.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo11_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo20_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo15_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo4_PlatformObject ; JmpTo
	jmp	(PlatformObject).l
; loc_222A4:
JmpTo5_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    else
JmpTo20_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
