; ----------------------------------------------------------------------------
; Object CA - Cut scene at end of game
; ----------------------------------------------------------------------------
; Sprite_A1D6:
ObjCA:
	addq.w	#1,objoff_32(a0)
	; Branch if Tails...
	cmpi.w	#4,(Ending_Routine).w
	beq.s	+
	; ...and branch if not Super Sonic, making the first check redundant.
	; Was Sonic's ending originally *always* going to feature Super Sonic?
	cmpi.w	#2,(Ending_Routine).w
	bne.s	+
	st.b	(Super_Sonic_flag).w
	move.w	#$100,(Ring_count).w
	move.b	#-1,(Super_Sonic_palette).w
+
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCA_Index(pc,d0.w),d1
	jmp	ObjCA_Index(pc,d1.w)
; ===========================================================================
; off_A208:
ObjCA_Index:	offsetTable
		offsetTableEntry.w ObjCA_Init	;  0
		offsetTableEntry.w loc_A240	;  2
		offsetTableEntry.w loc_A24E	;  4
		offsetTableEntry.w loc_A240	;  6
		offsetTableEntry.w loc_A256	;  8
		offsetTableEntry.w loc_A30A	; $A
		offsetTableEntry.w loc_A34C	; $C
		offsetTableEntry.w loc_A38E	; $E
; ===========================================================================
; loc_A218:
ObjCA_Init:
	moveq	#4,d0
	move.w	#$180,d1
	btst	#6,(Graphics_Flags).w
	beq.s	sub_A22A
	move.w	#$100,d1

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_A22A:

	lea	(EndSeqPaletteChanger).w,a1
	move.b	#ObjID_TtlScrPalChanger,id(a1) ; load objC9 (palette change handler) at $FFFFB0C0
	move.b	d0,subtype(a1)
	addq.b	#2,routine(a0)
	move.w	d1,objoff_3C(a0)
	rts
; End of function sub_A22A

; ===========================================================================

loc_A240:
	subq.w	#1,objoff_3C(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine(a0)
	rts
; ===========================================================================

loc_A24E:
	moveq	#6,d0
	move.w	#$80,d1
	bra.s	sub_A22A
; ===========================================================================

loc_A256:
	move.w	objoff_2E(a0),d0
	cmpi.w	#$10,d0
	bhs.s	+
	addq.w	#4,objoff_2E(a0)
	clr.b	routine(a0)
	move.l	a0,-(sp)
	movea.l	off_A29C(pc,d0.w),a0
	lea	(Chunk_Table).l,a1
	move.w	#make_art_tile(ArtTile_ArtNem_EndingPics,0,0),d0
	jsrto	JmpTo_EniDec
	move	#$2700,sr
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_A_Name_Table + planeLoc(64,14,8),VRAM,WRITE),d0
	moveq	#12-1,d1
	moveq	#9-1,d2
	jsrto	JmpTo2_PlaneMapToVRAM_H40
	move	#$2300,sr
	movea.l	(sp)+,a0 ; load 0bj address
	rts
; ===========================================================================
off_A29C:
	dc.l MapEng_Ending1
	dc.l MapEng_Ending2
	dc.l MapEng_Ending3
	dc.l MapEng_Ending4
; ===========================================================================
+
	move.w	#2,(Ending_VInt_Subrout).w
	st.b	(Control_Locked).w
	st.b	(Ending_PalCycle_flag).w
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	(Ending_Routine).w,d0
	move.w	ObjCA_State5_States(pc,d0.w),d0
	jsr	ObjCA_State5_States(pc,d0.w)
	move.w	#$80,d1
	bsr.w	sub_A22A
	move.w	#$40,objoff_3C(a0)
	rts
; ===========================================================================
ObjCA_State5_States:	offsetTable
	offsetTableEntry.w loc_A2E0	; 0
	offsetTableEntry.w loc_A2EE	; 2
	offsetTableEntry.w loc_A2F2	; 4
; ===========================================================================

loc_A2E0:
	moveq	#8,d0
-
	move.b	#ObjID_Sonic,id(a1) ; load Sonic object
	move.b	#$81,obj_control(a1)
	rts
; ===========================================================================

loc_A2EE:
	moveq	#$C,d0
	bra.s	-
; ===========================================================================

loc_A2F2:
	moveq	#$E,d0
	move.b	#ObjID_Tails,id(a1) ; load Tails object
	move.b	#$81,obj_control(a1)
	move.b	#ObjID_TailsTails,(Tails_Tails_Cutscene+id).w ; load Obj05 (Tails' tails) at $FFFFB080
	move.w	a1,(Tails_Tails_Cutscene+parent).w
	rts
; ===========================================================================

loc_A30A:
	subq.w	#1,objoff_3C(a0)
	bpl.s	+
	moveq	#$A,d0
	move.w	#$80,d1
	bsr.w	sub_A22A
	move.w	#$C0,objoff_3C(a0)
+
	lea	(MainCharacter).w,a1 ; a1=character
	move.b	#AniIDSonAni_Float2,anim(a1)
	move.w	#$A0,x_pos(a1)
	move.w	#$50,y_pos(a1)
	cmpi.w	#2,(Ending_Routine).w
	bne.s	+	; rts
	move.b	#AniIDSonAni_Walk,anim(a1)
	move.w	#$1000,inertia(a1)
+
	rts
; ===========================================================================

loc_A34C:
	subq.w	#1,objoff_3C(a0)
	bmi.s	+
	moveq	#0,d4
	moveq	#0,d5
	move.w	#0,(Camera_X_pos_diff).w
	move.w	#$100,(Camera_Y_pos_diff).w
	bra.w	SwScrl_DEZ
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	#$100,objoff_3C(a0)
	cmpi.w	#4,(Ending_Routine).w
	bne.s	return_A38C
	move.w	#$880,objoff_3C(a0)
	btst	#6,(Graphics_Flags).w
	beq.s	return_A38C
	move.w	#$660,objoff_3C(a0)

return_A38C:
	rts
; ===========================================================================

loc_A38E:
	btst	#6,(Graphics_Flags).w
	beq.s	+
	cmpi.w	#$E40,objoff_32(a0)
	beq.s	loc_A3BE
	bra.w	++
; ===========================================================================
+
	cmpi.w	#$1140,objoff_32(a0)
	beq.s	loc_A3BE
+
	subq.w	#1,objoff_3C(a0)
	bne.s	+
	lea	(ChildObject_AD62).l,a2
	jsrto	JmpTo_LoadChildObject
+
	bra.w	loc_AB9C
; ===========================================================================

loc_A3BE:
	addq.b	#2,routine(a0)
	st.b	(Credits_Trigger).w
	rts
