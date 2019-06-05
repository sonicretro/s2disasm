; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Game Mode: Ending sequence
; ----------------------------------------------------------------------------
; loc_9C7C:
EndingSequence:
	clearRAM EndSeq_Object_RAM,EndSeq_Object_RAM_End
	clearRAM Misc_Variables,Misc_Variables_End
	clearRAM Camera_RAM,Camera_RAM_End

	move	#$2700,sr
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l

	stopZ80
	dmaFillVRAM 0,VRAM_Plane_A_Name_Table,VRAM_Plane_Table_Size ; clear Plane A pattern name table
	clr.l	(Vscroll_Factor).w
	clr.l	(unk_F61A).w
	startZ80

	lea	(VDP_control_port).l,a6
	move.w	#$8B03,(a6)		; EXT-INT disabled, V scroll by screen, H scroll by line
	move.w	#$8200|(VRAM_EndSeq_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_EndSeq_Plane_B_Name_Table1/$2000),(a6)	; PNT B base: $E000
	move.w	#$8500|(VRAM_Sprite_Attribute_Table/$200),(a6)		; Sprite attribute table base: $F800
	move.w	#$9001,(a6)		; Scroll table size: 64x32
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8720,(a6)		; Background palette/color: 2/0
	move.w	#$8ADF,(Hint_counter_reserve).w	; H-INT every 224th scanline
	move.w	(Hint_counter_reserve).w,(a6)
	clr.b	(Super_Sonic_flag).w
	cmpi.b	#7,(Emerald_count).w
	bne.s	+
	cmpi.w	#2,(Player_mode).w
	beq.s	+
	st	(Super_Sonic_flag).w
	move.b	#-1,(Super_Sonic_palette).w
	move.b	#$F,(Palette_timer).w
	move.w	#$30,(Palette_frame).w
+
	moveq	#0,d0
	cmpi.w	#2,(Player_mode).w
	beq.s	+
	tst.b	(Super_Sonic_flag).w
	bne.s	++
	bra.w	+++

; ===========================================================================
+
	addq.w	#2,d0
+
	addq.w	#2,d0
+
	move.w	d0,(Ending_Routine).w
	bsr.w	EndingSequence_LoadCharacterArt
	bsr.w	EndingSequence_LoadFlickyArt
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_EndingFinalTornado),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingFinalTornado).l,a0
	jsrto	(NemDec).l, JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_EndingPics),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingPics).l,a0
	jsrto	(NemDec).l, JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_EndingMiniTornado),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingMiniTornado).l,a0
	jsrto	(NemDec).l, JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Tornado),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Tornado).l,a0
	jsrto	(NemDec).l, JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Clouds),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Clouds).l,a0
	jsrto	(NemDec).l, JmpTo_NemDec
	move.w	#death_egg_zone_act_1,(Current_ZoneAndAct).w
	move	#$2300,sr
	moveq	#MusID_Ending,d0
	jsrto	(PlayMusic).l, JmpTo2_PlayMusic
	move.l	#$EEE0EEE,d1
	lea	(Normal_palette).w,a1

	moveq	#bytesToLcnt(palette_line_size*4),d0
-	move.l	d1,(a1)+
	dbf	d0,-

	lea	(Pal_AC7E).l,a1
	lea	(Target_palette).w,a2

	moveq	#bytesToLcnt(palette_line_size*4),d0
-	move.l	(a1)+,(a2)+
	dbf	d0,-

	clr.b	(Screen_Shaking_Flag).w
	moveq	#0,d0
	move.w	d0,(Debug_placement_mode).w
	move.w	d0,(Level_Inactive_flag).w
	move.w	d0,(Timer_frames).w
	move.w	d0,(Camera_X_pos).w
	move.w	d0,(Camera_Y_pos).w
	move.w	d0,(Camera_X_pos_copy).w
	move.w	d0,(Camera_Y_pos_copy).w
	move.w	d0,(Camera_BG_X_pos).w
	move.w	#$C8,(Camera_BG_Y_pos).w
	move.l	d0,(Vscroll_Factor).w
	move.b	d0,(Horiz_block_crossed_flag_BG).w
	move.b	d0,(Verti_block_crossed_flag_BG).w
	move.w	d0,(Ending_VInt_Subrout).w
	move.w	d0,(Credits_Trigger).w

	; Bug: The '+4' shouldn't be here; clearRAM accidentally clears an additional 4 bytes
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf_End+4

	move.w	#$7FFF,(PalCycle_Timer).w
	lea	(CutScene).w,a1
	move.b	#ObjID_CutScene,id(a1) ; load objCA (end of game cutscene) at $FFFFB100
	move.b	#6,routine(a1)
	move.w	#$60,objoff_3C(a1)
	move.w	#1,objoff_30(a1)
	cmpi.w	#4,(Ending_Routine).w
	bne.s	+
	move.w	#$10,objoff_2E(a1)
	move.w	#$100,objoff_3C(a1)
+
	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
-
	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	addq.w	#1,(Timer_frames).w
	jsr	(RandomNumber).l
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	tst.b	(Ending_PalCycle_flag).w
	beq.s	+
	jsrto	(PalCycle_Load).l, JmpTo_PalCycle_Load
+
	bsr.w	EndgameCredits
	tst.w	(Level_Inactive_flag).w
	beq.w	-
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_9EF4
EndgameCredits:
	tst.b	(Credits_Trigger).w
	beq.w	+++	; rts
	bsr.w	Pal_FadeToBlack
	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8200|(VRAM_EndSeq_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_EndSeq_Plane_B_Name_Table1/$2000),(a6)	; PNT B base: $E000
	move.w	#$9001,(a6)		; Scroll table size: 64x32
	move.w	#$9200,(a6)		; Disable window
	move.w	#$8B03,(a6)		; EXT-INT disabled, V scroll by screen, H scroll by line
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	clr.b	(Water_fullscreen_flag).w
	move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled
	jsrto	(ClearScreen).l, JmpTo_ClearScreen

	clearRAM Sprite_Table_Input,Sprite_Table_Input_End
	clearRAM EndSeq_Object_RAM,EndSeq_Object_RAM_End
	clearRAM Misc_Variables,Misc_Variables_End
	clearRAM Camera_RAM,Camera_RAM_End

	clr.b	(Screen_Shaking_Flag).w
	moveq	#0,d0
	move.w	d0,(Level_Inactive_flag).w
	move.w	d0,(Timer_frames).w
	move.w	d0,(Camera_X_pos).w
	move.w	d0,(Camera_Y_pos).w
	move.w	d0,(Camera_X_pos_copy).w
	move.w	d0,(Camera_Y_pos_copy).w
	move.w	d0,(Camera_BG_X_pos).w
	move.w	d0,(Camera_BG_Y_pos).w
	move.l	d0,(Vscroll_Factor).w
	move.b	d0,(Horiz_block_crossed_flag_BG).w
	move.b	d0,(Verti_block_crossed_flag_BG).w
	move.w	d0,(Ending_VInt_Subrout).w
	move.w	d0,(Credits_Trigger).w

	; Bug: The '+4' shouldn't be here; clearRAM accidentally clears an additional 4 bytes
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf_End+4

	moveq	#MusID_Credits,d0
	jsrto	(PlaySound).l, JmpTo2_PlaySound
	clr.w	(Target_palette).w
	move.w	#$EEE,(Target_palette+$C).w
	move.w	#$EE,(Target_palette_line2+$C).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_CreditText_CredScr),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_CreditText).l,a0
	jsrto	(NemDec).l, JmpTo_NemDec
	clr.w	(CreditsScreenIndex).w
-
	jsrto	(ClearScreen).l, JmpTo_ClearScreen
	bsr.w	ShowCreditsScreen
	bsr.w	Pal_FadeFromBlack

	; Here's how to calculate new duration values for the below instructions.
	; Each slide of the credits is displayed for $18E frames at 60 FPS, or $144 frames at 50 FPS.
	; We also need to take into account how many frames the fade-in/fade-out take: which is $16 each.
	; Also, there are 21 slides to display.
	; That said, by doing '($18E+$16+$16)*21', we get the total number of frames it takes until
	; the credits reach the Sonic 2 splash (which is technically not an actual slide in the credits).
	; Dividing this by 60 will give us how many seconds it takes. The result being 154.7.
	; Doing the same for 50 FPS, by dividing the result of '($144+$16+$16)*21' by 50, will give us 154.56.
	; Now that we have the time it should take for the credits to end, we can adjust the calculation to account
	; for any slides we may have added. For example, if you added a slide, bringing the total to 22,
	; performing '((154.7*60)/22)-($16+$16)' will give you the new value to put in the 'move.w' instruction below.
	move.w	#$18E,d0
	btst	#6,(Graphics_Flags).w
	beq.s	+
	move.w	#$144,d0

/	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	dbf	d0,-

	bsr.w	Pal_FadeToBlack
	lea	(off_B2CA).l,a1
	addq.w	#1,(CreditsScreenIndex).w
	move.w	(CreditsScreenIndex).w,d0
	lsl.w	#2,d0
	move.l	(a1,d0.w),d0
	bpl.s	--
	bsr.w	Pal_FadeToBlack
	jsrto	(ClearScreen).l, JmpTo_ClearScreen
	move.l	#vdpComm($0000,VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingTitle).l,a0
	jsrto	(NemDec).l, JmpTo_NemDec
	lea	(MapEng_EndGameLogo).l,a0
	lea	(Chunk_Table).l,a1
	move.w	#0,d0
	jsrto	(EniDec).l, JmpTo_EniDec
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_A_Name_Table+planeLocH40(12,11),VRAM,WRITE),d0
	moveq	#$F,d1
	moveq	#5,d2
	jsrto	(PlaneMapToVRAM_H40).l, JmpTo2_PlaneMapToVRAM_H40
	clr.w	(CreditsScreenIndex).w
	bsr.w	EndgameLogoFlash

	move.w	#$3B,d0
-	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	dbf	d0,-

	move.w	#$257,d6
-	move.b	#VintID_Ending,(Vint_routine).w
	bsr.w	WaitForVint
	addq.w	#1,(CreditsScreenIndex).w
	bsr.w	EndgameLogoFlash
	cmpi.w	#$5E,(CreditsScreenIndex).w
	blo.s	-
	move.b	(Ctrl_1_Press).w,d1
	andi.b	#button_B_mask|button_C_mask|button_A_mask|button_start_mask,d1
	bne.s	+
	dbf	d6,-
+
	st	(Level_Inactive_flag).w
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
/
	rts
; End of function sub_9EF4


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_A0C0
EndgameLogoFlash:
	lea	(Normal_palette+2).w,a2
	move.w	(CreditsScreenIndex).w,d0
	cmpi.w	#$24,d0
	bhs.s	-
	btst	#0,d0
	bne.s	-
	lsr.w	#1,d0
	move.b	byte_A0EC(pc,d0.w),d0
	mulu.w	#$18,d0
	lea	pal_A0FE(pc,d0.w),a1

	moveq	#5,d0
-	move.l	(a1)+,(a2)+
	dbf	d0,-

	rts
; End of function EndgameLogoFlash

; ===========================================================================
byte_A0EC:
	dc.b   0
	dc.b   1	; 1
	dc.b   2	; 2
	dc.b   3	; 3
	dc.b   4	; 4
	dc.b   3	; 5
	dc.b   2	; 6
	dc.b   1	; 7
	dc.b   0	; 8
	dc.b   5	; 9
	dc.b   6	; 10
	dc.b   7	; 11
	dc.b   8	; 12
	dc.b   7	; 13
	dc.b   6	; 14
	dc.b   5	; 15
	dc.b   0	; 16
	dc.b   0	; 17

; palette cycle for the end-of-game logo
pal_A0FE:	BINCLUDE	"art/palettes/Ending Cycle.bin"

; ===========================================================================
; ----------------------------------------------------------------------------
; Object CA - Cut scene at end of game
; ----------------------------------------------------------------------------
; Sprite_A1D6:
ObjCA:
	addq.w	#1,objoff_32(a0)
	cmpi.w	#4,(Ending_Routine).w
	beq.s	+
	cmpi.w	#2,(Ending_Routine).w
	bne.s	+
	st	(Super_Sonic_flag).w
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
	jsrto	(EniDec).l, JmpTo_EniDec
	move	#$2700,sr
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_A_Name_Table + planeLocH40(14,8),VRAM,WRITE),d0
	moveq	#$B,d1
	moveq	#8,d2
	jsrto	(PlaneMapToVRAM_H40).l, JmpTo2_PlaneMapToVRAM_H40
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
	st	(Control_Locked).w
	st	(Ending_PalCycle_flag).w
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
	lea	(word_AD62).l,a2
	jsrto	(LoadChildObject).l, JmpTo_LoadChildObject
+
	bra.w	loc_AB9C
; ===========================================================================

loc_A3BE:
	addq.b	#2,routine(a0)
	st	(Credits_Trigger).w
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Object CC - Trigger for rescue plane and birds from ending sequence
; ----------------------------------------------------------------------------
; Sprite_A3C8:
ObjCC:
	jsrto	(ObjB2_Animate_Pilot).l, JmpTo_ObjB2_Animate_Pilot
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCC_Index(pc,d0.w),d1
	jmp	ObjCC_Index(pc,d1.w)
; ===========================================================================
; loc_A3DA:
ObjCC_Index:	offsetTable
		offsetTableEntry.w ObjCC_Init	; 0
		offsetTableEntry.w ObjCC_Main	; 2
; ===========================================================================
; loc_A3DE:
ObjCC_Init:
	lea	(ObjB2_SubObjData).l,a1
	jsrto	(LoadSubObject_Part3).l, JmpTo_LoadSubObject_Part3
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	move.b	#4,mapping_frame(a0)
	move.b	#1,anim(a0)
+
	move.w	#-$10,x_pos(a0)
	move.w	#$C0,y_pos(a0)
	move.w	#$100,x_vel(a0)
	move.w	#-$80,y_vel(a0)
	move.b	#$14,objoff_35(a0)
	move.b	#3,priority(a0)
	move.w	#4,(Ending_VInt_Subrout).w
	move.l	a0,-(sp)
	lea	(MapEng_EndingTailsPlane).l,a0
	cmpi.w	#4,(Ending_Routine).w
	bne.s	+
	lea	(MapEng_EndingSonicPlane).l,a0
+
	lea	(Chunk_Table).l,a1
	move.w	#make_art_tile(ArtTile_ArtNem_EndingFinalTornado,0,1),d0
	jsrto	(EniDec).l, JmpTo_EniDec
	movea.l	(sp)+,a0 ; load 0bj address
	move.w	#$C00,(Normal_palette_line3).w
	jmpto	(DisplaySprite).l, JmpTo5_DisplaySprite
; ===========================================================================
; loc_A456:
ObjCC_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjCC_State2_States(pc,d0.w),d1
	jsr	ObjCC_State2_States(pc,d1.w)
	jmpto	(DisplaySprite).l, JmpTo5_DisplaySprite
; ===========================================================================
ObjCC_State2_States: offsetTable
	offsetTableEntry.w loc_A474	;  0
	offsetTableEntry.w loc_A4B6	;  2
	offsetTableEntry.w loc_A5A6	;  4
	offsetTableEntry.w loc_A6C6	;  6
	offsetTableEntry.w loc_A7DE	;  8
	offsetTableEntry.w loc_A83E	; $A
; ===========================================================================

loc_A474:
	cmpi.w	#$A0,x_pos(a0)
	beq.s	+
	jsrto	(ObjectMove).l, JmpTo2_ObjectMove
-
	lea	(Ani_objB2_a).l,a1
	jmpto	(AnimateSprite).l, JmpTo_AnimateSprite
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$480,objoff_3C(a0)
	btst	#6,(Graphics_Flags).w
	beq.s	+
	move.w	#$3D0,objoff_3C(a0)
+
	move.w	#$40,objoff_32(a0)
	st	(CutScene+objoff_34).w
	clr.w	x_vel(a0)
	clr.w	y_vel(a0)
	bra.s	-
; ===========================================================================

loc_A4B6:
	bsr.w	sub_ABBA
	bsr.w	sub_A524
	subq.w	#1,objoff_3C(a0)
	bmi.s	+
	bra.s	-
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#2,objoff_3C(a0)
	clr.w	objoff_32(a0)
	clr.b	mapping_frame(a0)
	cmpi.w	#2,(Ending_Routine).w
	beq.s	+
	move.b	#7,mapping_frame(a0)
	cmpi.w	#4,(Ending_Routine).w
	bne.s	+
	move.b	#$18,mapping_frame(a0)
+
	clr.b	anim(a0)
	clr.b	anim_frame(a0)
	clr.b	anim_frame_duration(a0)
	move.l	#ObjCF_MapUnc_ADA2,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	jsr	(Adjust2PArtPointer).l
	subi.w	#$14,x_pos(a0)
	addi.w	#$14,y_pos(a0)
	bra.w	sub_A58C

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_A524:
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	(Ending_Routine).w,d0
	move.w	off_A534(pc,d0.w),d0
	jmp	off_A534(pc,d0.w)
; End of function sub_A524

; ===========================================================================
off_A534:	offsetTable
		offsetTableEntry.w loc_A53A	; 0
		offsetTableEntry.w loc_A55C	; 2
		offsetTableEntry.w loc_A582	; 4
; ===========================================================================

loc_A53A:
	move.w	y_pos(a0),d0
	subi.w	#$1C,d0
-
	move.w	d0,y_pos(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.l	#$1000505,mapping_frame(a1)
	move.w	#$100,anim_frame_duration(a1)
	rts
; ===========================================================================

loc_A55C:
	tst.w	objoff_32(a0)
	beq.s	+
	subq.w	#1,objoff_32(a0)
	addi.l	#$8000,x_pos(a1)
	addq.w	#1,y_pos(a1)
	rts
; ===========================================================================
+
	move.w	#$C0,x_pos(a1)
	move.w	#$90,y_pos(a1)
	rts
; ===========================================================================

loc_A582:
	move.w	y_pos(a0),d0
	subi.w	#$18,d0
	bra.s	-

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_A58C:
	tst.b	(Super_Sonic_flag).w
	bne.w	return_A38C

loc_A594:
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	#$200,x_pos(a1)
	move.w	#0,y_pos(a1)
	rts
; End of function sub_A58C

; ===========================================================================

loc_A5A6:
	bsr.s	sub_A58C
	subq.w	#1,objoff_3C(a0)
	bpl.s	+	; rts
	move.w	#2,objoff_3C(a0)
	move.w	objoff_32(a0),d0
	cmpi.w	#$1C,d0
	bhs.s	++
	addq.w	#1,objoff_32(a0)
	move.w	(Ending_Routine).w,d1
	move.w	off_A5FC(pc,d1.w),d1
	lea	off_A5FC(pc,d1.w),a1
	move.b	(a1,d0.w),mapping_frame(a0)
	add.w	d0,d0
	add.w	d0,d0
	move.l	word_A656(pc,d0.w),d1
	move.w	d1,y_pos(a0)
	swap	d1
	move.w	d1,x_pos(a0)
+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$60,objoff_3C(a0)
	clr.b	objoff_31(a0)
	clr.w	objoff_32(a0)
	rts
; ===========================================================================
off_A5FC:	offsetTable
		offsetTableEntry.w byte_A602	; 0
		offsetTableEntry.w byte_A61E	; 2
		offsetTableEntry.w byte_A63A	; 4
byte_A602:
	dc.b   7,  7,  7,  7,  8,  8,  8,  8,  8,  8,  8,  9,  9,  9, $A, $A
	dc.b  $A, $B, $B, $B, $B, $B, $B, $B, $B, $B, $B, $B; 16
byte_A61E:
	dc.b   0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  2,  2,  2,  3,  3
	dc.b   3,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4; 16
byte_A63A:
	dc.b $18,$18,$18,$18,$19,$19,$19,$19,$19,$19,$19,  9,  9,  9, $A, $A
	dc.b  $A, $B, $B, $B, $B, $B, $B, $B, $B, $B, $B, $B; 16
word_A656:
	dc.w   $A0,  $70,  $B0,  $70,  $B6,  $71,  $BC,  $72
	dc.w   $C4,  $74,  $C8,  $75,  $CA,  $76,  $CC,  $77; 8
	dc.w   $CE,  $78,  $D0,  $79,  $D2,  $7A,  $D4,  $7B; 16
	dc.w   $D6,  $7C,  $D9,  $7E,  $DC,  $81,  $DE,  $84; 24
	dc.w   $E1,  $87,  $E4,  $8B,  $E7,  $8F,  $EC,  $94; 32
	dc.w   $F0,  $99,  $F5,  $9D,  $F9,  $A4, $100,  $AC; 40
	dc.w  $108,  $B8, $112,  $C4, $11F,  $D3, $12C,  $FA; 48
; ===========================================================================

loc_A6C6:
	subq.w	#1,objoff_3C(a0)
	bmi.s	loc_A720
	tst.b	(Super_Sonic_flag).w
	beq.s	+	; rts
	subq.b	#1,objoff_31(a0)
	bpl.s	+	; rts
	addq.b	#3,objoff_31(a0)
	move.w	objoff_32(a0),d0
	addq.w	#4,objoff_32(a0)
	cmpi.w	#$78,d0
	bhs.s	+	; rts
	cmpi.w	#$C,d0
	blo.s	++
	bsr.w	loc_A594
	move.l	word_A766(pc,d0.w),d1
	move.w	d1,y_pos(a0)
	swap	d1
	move.w	d1,x_pos(a0)
	lsr.w	#2,d0
	move.b	byte_A748(pc,d0.w),mapping_frame(a0)
+
	rts
; ===========================================================================
+
	move.l	word_A766(pc,d0.w),d0
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	d0,y_pos(a1)
	swap	d0
	move.w	d0,x_pos(a1)
	rts
; ===========================================================================

loc_A720:
	addq.b	#2,routine_secondary(a0)
	clr.w	objoff_3C(a0)
	clr.w	objoff_32(a0)
	lea	(word_AD6E).l,a2
	jsrto	(LoadChildObject).l, JmpTo_LoadChildObject
	tst.b	(Super_Sonic_flag).w
	bne.w	return_A38C
	lea	(word_AD6A).l,a2
	jmpto	(LoadChildObject).l, JmpTo_LoadChildObject
; ===========================================================================
byte_A748:
	dc.b $12,$12,$12,$12,$12,$12,$12,$13,$13,$13,$13,$13,$13,$14,$14,$14
	dc.b $14,$15,$15,$15,$16,$16,$16,$16,$16,$16,$16,$16,$16,  0; 16
word_A766:
	dc.w   $C0, $90	; 1
	dc.w   $B0, $91	; 3
	dc.w   $A8, $92	; 5
	dc.w   $9B, $96	; 7
	dc.w   $99, $98	; 9
	dc.w   $98, $99	; 11
	dc.w   $99, $9A	; 13
	dc.w   $9B, $9C	; 15
	dc.w   $9F, $9E	; 17
	dc.w   $A4, $A0	; 19
	dc.w   $AC, $A2	; 21
	dc.w   $B7, $A5	; 23
	dc.w   $C4, $A8	; 25
	dc.w   $D3, $AB	; 27
	dc.w   $DE, $AE	; 29
	dc.w   $E8, $B0	; 31
	dc.w   $EF, $B2	; 33
	dc.w   $F4, $B5	; 35
	dc.w   $F9, $B8	; 37
	dc.w   $FC, $BB	; 39
	dc.w   $FE, $BE	; 41
	dc.w   $FF, $C0	; 43
	dc.w  $100, $C2	; 45
	dc.w  $101, $C5	; 47
	dc.w  $102, $C8	; 49
	dc.w  $102, $CC	; 51
	dc.w  $101, $D1	; 53
	dc.w   $FD, $D7	; 55
	dc.w   $F9, $DE	; 57
	dc.w   $F9,$118	; 59
; ===========================================================================

loc_A7DE:
	bsr.w	loc_A594
	subq.w	#1,objoff_3C(a0)
	bpl.s	+	; rts
	move.w	#2,objoff_3C(a0)
	move.w	objoff_32(a0),d0
	cmpi.w	#$1C,d0
	bhs.s	++
	addq.w	#4,objoff_32(a0)
	lea	word_A822(pc,d0.w),a1
	move.w	(a1)+,d0
	add.w	d0,(Horiz_Scroll_Buf).w
	move.w	(a1)+,d0
	add.w	d0,(Vscroll_Factor_FG).w
+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	bset	#3,status(a0)
	clr.b	objoff_31(a0)
	clr.w	objoff_32(a0)
	rts
; ===========================================================================
word_A822:
	dc.w  -$3A
	dc.w   $88	; 1
	dc.w   -$C	; 2
	dc.w   $22	; 3
	dc.w	-8	; 4
	dc.w   $10	; 5
	dc.w	-4	; 6
	dc.w	 8	; 7
	dc.w	-2	; 8
	dc.w	 4	; 9
	dc.w	-1	; 10
	dc.w	 2	; 11
	dc.w	-1	; 12
	dc.w	 2	; 13
; ===========================================================================

loc_A83E:
	tst.b	(Super_Sonic_flag).w
	beq.w	return_A38C
	move.b	#$17,mapping_frame(a0)
	subq.b	#1,objoff_31(a0)
	bpl.s	+	; rts
	addq.b	#3,objoff_31(a0)
	move.w	objoff_32(a0),d0
	cmpi.w	#$20,d0
	bhs.s	+	; rts
	addq.w	#4,objoff_32(a0)
	move.l	word_A874(pc,d0.w),d1
	move.w	d1,y_pos(a0)
	swap	d1
	move.w	d1,x_pos(a0)
+
	rts
; ===========================================================================
word_A874:
	dc.w   $60,$88	; 1
	dc.w   $50,$68	; 3
	dc.w   $44,$46	; 5
	dc.w   $3C,$36	; 7
	dc.w   $36,$2A	; 9
	dc.w   $33,$24	; 11
	dc.w   $31,$20	; 13
	dc.w   $30,$1E	; 15

; ===========================================================================
; ----------------------------------------------------------------------------
; Object CE - Sonic and Tails jumping off the plane from ending sequence
; ----------------------------------------------------------------------------
; Sprite_A894:
ObjCE:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCE_Index(pc,d0.w),d1
	jmp	ObjCE_Index(pc,d1.w)
; ===========================================================================
; off_A8A2:
ObjCE_Index:	offsetTable
		offsetTableEntry.w ObjCE_Init				; 0
		offsetTableEntry.w loc_A902				; 2
		offsetTableEntry.w loc_A936				; 4
		offsetTableEntry.w BranchTo_JmpTo5_DisplaySprite	; 6
; ===========================================================================
; loc_A8AA:
ObjCE_Init:
	lea	(ObjB3_SubObjData).l,a1
	jsrto	(LoadSubObject_Part3).l, JmpTo_LoadSubObject_Part3
	move.l	#ObjCF_MapUnc_ADA2,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,1),art_tile(a0)
	move.b	#1,priority(a0)
	jsr	(Adjust2PArtPointer).l
	move.b	#$C,mapping_frame(a0)
	cmpi.w	#4,(Ending_Routine).w
	bne.s	+
	move.b	#$F,mapping_frame(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,1,1),art_tile(a0)
+
	move.w	#$E8,d0
	move.w	d0,x_pos(a0)
	move.w	d0,objoff_30(a0)
	move.w	#$118,d0
	move.w	d0,y_pos(a0)
	move.w	d0,objoff_32(a0)
	rts
; ===========================================================================

loc_A902:
	movea.w	objoff_2C(a0),a1 ; a1=object
	btst	#3,status(a1)
	bne.s	+

loc_A90E:
	move.w	objoff_30(a0),d0
	add.w	(Horiz_Scroll_Buf).w,d0
	move.w	d0,x_pos(a0)
	move.w	objoff_32(a0),d0
	sub.w	(Vscroll_Factor_FG).w,d0
	move.w	d0,y_pos(a0)

BranchTo_JmpTo5_DisplaySprite 
	jmpto	(DisplaySprite).l, JmpTo5_DisplaySprite
; ===========================================================================
+
	addq.b	#2,routine(a0)
	clr.w	objoff_3C(a0)
	jmpto	(DisplaySprite).l, JmpTo5_DisplaySprite
; ===========================================================================

loc_A936:
	subq.w	#1,objoff_3C(a0)
	bpl.s	BranchTo2_JmpTo5_DisplaySprite
	move.w	#4,objoff_3C(a0)
	move.w	objoff_34(a0),d0
	cmpi.w	#4,d0
	bhs.s	++
	addq.w	#2,objoff_34(a0)
	lea	byte_A980(pc,d0.w),a1
	cmpi.w	#2,(Ending_Routine).w
	bne.s	+
	lea	byte_A984(pc,d0.w),a1
+
	move.b	(a1)+,d0
	ext.w	d0
	add.w	d0,x_pos(a0)
	move.b	(a1)+,d0
	ext.w	d0
	add.w	d0,y_pos(a0)
	addq.b	#1,mapping_frame(a0)

BranchTo2_JmpTo5_DisplaySprite 
	jmpto	(DisplaySprite).l, JmpTo5_DisplaySprite
; ===========================================================================
+
	addq.b	#2,routine(a0)
	jmpto	(DisplaySprite).l, JmpTo5_DisplaySprite
; ===========================================================================
byte_A980:
	dc.b   -8,   0
	dc.b -$44,-$38	; 2
byte_A984:
	dc.b   -8,   0
	dc.b -$50,-$40	; 2
; ===========================================================================
; ----------------------------------------------------------------------------
; Object CF - "Plane's helixes" from ending sequence
; ----------------------------------------------------------------------------
; Sprite_A988:
ObjCF:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCF_Index(pc,d0.w),d1
	jmp	ObjCF_Index(pc,d1.w)
; ===========================================================================
; off_A996:
ObjCF_Index:	offsetTable
		offsetTableEntry.w ObjCF_Init		; 0
		offsetTableEntry.w ObjCF_Animate	; 2
; ===========================================================================
; loc_A99A:
ObjCF_Init:
	lea	(ObjB3_SubObjData).l,a1
	jsrto	(LoadSubObject_Part3).l, JmpTo_LoadSubObject_Part3
	move.l	#ObjCF_MapUnc_ADA2,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,1),art_tile(a0)
	move.b	#3,priority(a0)
	jsr	(Adjust2PArtPointer).l
	move.b	#5,mapping_frame(a0)
	move.b	#2,anim(a0)
	move.w	#$10F,d0
	move.w	d0,x_pos(a0)
	move.w	d0,objoff_30(a0)
	move.w	#$15E,d0
	move.w	d0,y_pos(a0)
	move.w	d0,objoff_32(a0)
	rts
; ===========================================================================
; loc_A9E4:
ObjCF_Animate:
	lea	(Ani_objCF).l,a1
	jsrto	(AnimateSprite).l, JmpTo_AnimateSprite
	bra.w	loc_A90E
; ===========================================================================
; ----------------------------------------------------------------------------
; Object CB - Background clouds from ending sequence
; ----------------------------------------------------------------------------
; Sprite_A9F2:
ObjCB:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCB_Index(pc,d0.w),d1
	jmp	ObjCB_Index(pc,d1.w)
; ===========================================================================
; off_AA00:
ObjCB_Index:	offsetTable
		offsetTableEntry.w ObjCB_Init	; 0
		offsetTableEntry.w loc_AA76	; 2
		offsetTableEntry.w loc_AA8A	; 4
; ===========================================================================
; loc_AA06:
ObjCB_Init:
	lea	(ObjB3_SubObjData).l,a1
	jsrto	(LoadSubObject_Part3).l, JmpTo_LoadSubObject_Part3
	move.w	art_tile(a0),d0
	andi.w	#$1FFF,d0
	ori.w	#palette_mask,d0
	move.w	d0,art_tile(a0)
	move.b	#$30,width_pixels(a0)
	move.l	(RNG_seed).w,d0
	ror.l	#1,d0
	move.l	d0,(RNG_seed).w
	move.w	d0,d1
	andi.w	#3,d0
	move.b	ObjCB_Frames(pc,d0.w),mapping_frame(a0)
	add.w	d0,d0
	move.w	ObjCB_YSpeeds(pc,d0.w),y_vel(a0)
	tst.b	(CutScene+$34).w
	beq.s	+
	andi.w	#$FF,d1
	move.w	d1,y_pos(a0)
	move.w	#$150,x_pos(a0)
	rts
; ===========================================================================
+
	andi.w	#$1FF,d1
	move.w	d1,x_pos(a0)
	move.w	#$100,y_pos(a0)
	rts
; ===========================================================================
; byte_AA6A:
ObjCB_Frames:
	dc.b   0
	dc.b   1	; 1
	dc.b   2	; 2
	dc.b   0	; 3
; word_AA6E:
ObjCB_YSpeeds:
	dc.w -$300
	dc.w -$200	; 1
	dc.w -$100	; 2
	dc.w -$300	; 3
; ===========================================================================

loc_AA76:
	tst.b	(CutScene+objoff_34).w
	beq.s	loc_AA8A
	addq.b	#2,routine(a0)
	move.w	y_vel(a0),x_vel(a0)
	clr.w	y_vel(a0)

loc_AA8A:
	jsrto	(ObjectMove).l, JmpTo2_ObjectMove
	tst.b	(CutScene+objoff_34).w
	beq.s	+
	cmpi.w	#-$20,x_pos(a0)
	blt.w	JmpTo3_DeleteObject
	jmpto	(DisplaySprite).l, JmpTo5_DisplaySprite
; ===========================================================================
+
	tst.w	y_pos(a0)
	bmi.w	JmpTo3_DeleteObject
	jmpto	(DisplaySprite).l, JmpTo5_DisplaySprite
; ===========================================================================
; ----------------------------------------------------------------------------
; Object CD - Birds from ending sequence
; ----------------------------------------------------------------------------
endingbird_delay	= objoff_3C	; delay before doing the next action
; Sprite_AAAE:
ObjCD:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjCD_Index(pc,d0.w),d1
	jmp	ObjCD_Index(pc,d1.w)
; ===========================================================================
; off_AABC:
ObjCD_Index:	offsetTable
		offsetTableEntry.w ObjCD_Init	; 0
		offsetTableEntry.w ObjCD_Main	; 2
; ===========================================================================
; loc_AAC0:
ObjCD_Init:
	lea	(Obj28_SubObjData).l,a1
	jsrto	(LoadSubObject_Part3).l, JmpTo_LoadSubObject_Part3
	move.l	(RNG_seed).w,d0
	ror.l	#3,d0
	move.l	d0,(RNG_seed).w
	move.l	d0,d1
	andi.w	#$7F,d0
	move.w	#-$A0,d2
	add.w	d0,d2
	move.w	d2,x_pos(a0)
	ror.l	#3,d1
	andi.w	#$FF,d1
	moveq	#8,d2
	add.w	d1,d2
	move.w	d2,y_pos(a0)
	move.w	#$100,x_vel(a0)
	moveq	#$20,d0
	cmpi.w	#$20,d1
	blo.s	+
	neg.w	d0
+
	move.w	d0,y_vel(a0)
	move.w	#$C0,endingbird_delay(a0)
	rts
; ===========================================================================
; loc_AB0E:
ObjCD_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjCD_Main_States(pc,d0.w),d1
	jsr	ObjCD_Main_States(pc,d1.w)
	jsrto	(ObjectMove).l, JmpTo2_ObjectMove
	lea	(Ani_objCD).l,a1
	jsrto	(AnimateSprite).l, JmpTo_AnimateSprite
	jmpto	(DisplaySprite).l, JmpTo5_DisplaySprite
; ===========================================================================
ObjCD_Main_States:	offsetTable
	offsetTableEntry.w loc_AB34	; 0
	offsetTableEntry.w loc_AB5C	; 2
	offsetTableEntry.w loc_AB8E	; 4
; ===========================================================================

loc_AB34:
	subq.w	#1,endingbird_delay(a0)
	bpl.s	+	; rts
	addq.b	#2,routine_secondary(a0)
	move.w	y_vel(a0),objoff_2E(a0)
	clr.w	x_vel(a0)
	move.w	y_pos(a0),objoff_32(a0)
	move.w	#$80,y_vel(a0)
	move.w	#$180,endingbird_delay(a0)
+
	rts
; ===========================================================================

loc_AB5C:
	subq.w	#1,endingbird_delay(a0)
	bmi.s	++
	move.w	y_pos(a0),d0
	moveq	#-4,d1
	cmp.w	objoff_32(a0),d0
	bhs.s	+
	neg.w	d1
+
	add.w	d1,y_vel(a0)
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#-$100,x_vel(a0)
	move.w	objoff_2E(a0),y_vel(a0)
	move.w	#$C0,endingbird_delay(a0)
	rts
; ===========================================================================

loc_AB8E:
	subq.w	#1,endingbird_delay(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.w	#4,sp

    if removeJmpTos
JmpTo3_DeleteObject 
    endif

	jmpto	(DeleteObject).l, JmpTo3_DeleteObject
; ===========================================================================

loc_AB9C:
	subq.w	#1,objoff_30(a0)
	bpl.s	+	; rts
	move.l	(RNG_seed).w,d0
	andi.w	#$1F,d0
	move.w	d0,objoff_30(a0)
	lea	(word_AD5E).l,a2
	jsrto	(LoadChildObject).l, JmpTo_LoadChildObject
+
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_ABBA:
	subq.w	#1,objoff_30(a0)
	bpl.s	+	; rts
	tst.b	objoff_35(a0)
	beq.s	+	; rts
	subq.b	#1,objoff_35(a0)
	move.l	(RNG_seed).w,d0
	andi.w	#$F,d0
	move.w	d0,objoff_30(a0)
	lea	(word_AD66).l,a2
	jsrto	(LoadChildObject).l, JmpTo_LoadChildObject
+	rts
; End of function sub_ABBA


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_ABE2:
EndingSequence_LoadCharacterArt:
	move.w	(Ending_Routine).w,d0
	move.w	EndingSequence_LoadCharacterArt_Characters(pc,d0.w),d0
	jmp	EndingSequence_LoadCharacterArt_Characters(pc,d0.w)
; End of function EndingSequence_LoadCharacterArt

; ===========================================================================
EndingSequence_LoadCharacterArt_Characters: offsetTable
	offsetTableEntry.w EndingSequence_LoadCharacterArt_Sonic	; 0
	offsetTableEntry.w EndingSequence_LoadCharacterArt_SuperSonic	; 2
	offsetTableEntry.w EndingSequence_LoadCharacterArt_Tails	; 4
; ===========================================================================
; loc_ABF4:
EndingSequence_LoadCharacterArt_Sonic:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_EndingCharacter),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingSonic).l,a0
	jmpto	(NemDec).l, JmpTo_NemDec
; ===========================================================================
; loc_AC08:
EndingSequence_LoadCharacterArt_SuperSonic:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_EndingCharacter),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingSuperSonic).l,a0
	jmpto	(NemDec).l, JmpTo_NemDec
; ===========================================================================
; loc_AC1C:
EndingSequence_LoadCharacterArt_Tails:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_EndingCharacter),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingTails).l,a0
	jmpto	(NemDec).l, JmpTo_NemDec

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_AC30:
EndingSequence_LoadFlickyArt:
	move.w	(Ending_Routine).w,d0
	move.w	EndingSequence_LoadFlickyArt_Flickies(pc,d0.w),d0
	jmp	EndingSequence_LoadFlickyArt_Flickies(pc,d0.w)
; End of function EndingSequence_LoadFlickyArt

; ===========================================================================
EndingSequence_LoadFlickyArt_Flickies: offsetTable
	offsetTableEntry.w EndingSequence_LoadFlickyArt_Bird	; 0
	offsetTableEntry.w EndingSequence_LoadFlickyArt_Eagle	; 2
	offsetTableEntry.w EndingSequence_LoadFlickyArt_Chicken	; 4
; ===========================================================================
; loc_AC42:
EndingSequence_LoadFlickyArt_Bird:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Animal_2),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Bird).l,a0
	jmpto	(NemDec).l, JmpTo_NemDec
; ===========================================================================
; loc_AC56:
EndingSequence_LoadFlickyArt_Eagle:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Animal_2),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Eagle).l,a0
	jmpto	(NemDec).l, JmpTo_NemDec
; ===========================================================================
; loc_AC6A:
EndingSequence_LoadFlickyArt_Chicken:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Animal_2),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Chicken).l,a0
	jmpto	(NemDec).l, JmpTo_NemDec
; ===========================================================================
Pal_AC7E:	BINCLUDE	"art/palettes/Ending Sonic.bin"
Pal_AC9E:	BINCLUDE	"art/palettes/Ending Sonic Far.bin"
Pal_ACDE:	BINCLUDE	"art/palettes/Ending Background.bin"
Pal_AD1E:	BINCLUDE	"art/palettes/Ending Photos.bin"
Pal_AD3E:	BINCLUDE	"art/palettes/Ending Super Sonic.bin"

word_AD5E:
	dc.w objoff_3E
	dc.b ObjID_EndingSeqClouds
	dc.b $00
word_AD62:
	dc.w objoff_3E
	dc.b ObjID_EndingSeqTrigger
	dc.b $00
word_AD66:
	dc.w objoff_3E
	dc.b ObjID_EndingSeqBird
	dc.b $00
word_AD6A:
	dc.w objoff_3E
	dc.b ObjID_EndingSeqSonic
	dc.b $00
word_AD6E:
	dc.w objoff_3E
	dc.b ObjID_TornadoHelixes
	dc.b $00

; off_AD72:
Obj28_SubObjData:
	subObjData Obj28_MapUnc_11E1C,make_art_tile(ArtTile_ArtNem_Animal_2,0,0),4,2,8,0

; animation script
; byte_AD7C
Ani_objCD:	offsetTable
		offsetTableEntry.w byte_AD7E	; 0
byte_AD7E:	dc.b   5,  0,  1,$FF

; animation script
; off_AD82
Ani_objCF:	offsetTable
		offsetTableEntry.w byte_AD88	; 0
		offsetTableEntry.w byte_AD8E	; 1
		offsetTableEntry.w byte_AD9E	; 2
byte_AD88:	dc.b   3,  0,  0,  1,$FA,  0
byte_AD8E:	dc.b   3,  1,  1,  1,  1,  1,  2,  2,  2,  2,  2,  3,  3,  4,$FA,  0
byte_AD9E:	dc.b   1,  5,  6,$FF
	even
; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjCF_MapUnc_ADA2:	BINCLUDE "mappings/sprite/objCF.bin"
; --------------------------------------------------------------------------------------
; Enigma compressed art mappings
; "Sonic the Hedgehog 2" mappings		; MapEng_B23A:
	even
MapEng_EndGameLogo:	BINCLUDE	"mappings/misc/Sonic 2 end of game logo.bin"
	even

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_B262
ShowCreditsScreen:
	lea	off_B2CA(pc),a1
	move.w	(CreditsScreenIndex).w,d0
	lsl.w	#2,d0
	move.l	(a1,d0.w),d0
	movea.l	d0,a1

loc_B272:
	move	#$2700,sr
	lea	(VDP_data_port).l,a6
-
	move.l	(a1)+,d0
	bmi.s	++
	movea.l	d0,a2
	move.w	(a1)+,d0
	bsr.s	sub_B29E
	move.l	d0,4(a6)
	move.b	(a2)+,d0
	lsl.w	#8,d0
-
	move.b	(a2)+,d0
	bmi.s	+
	move.w	d0,(a6)
	bra.s	-
; ===========================================================================
+	bra.s	--
; ===========================================================================
+
	move	#$2300,sr
	rts
; End of function ShowCreditsScreen


; ---------------------------------------------------------------------------
; Subroutine to convert a VRAM address into a 32-bit VRAM write command word
; Input:
;	d0	VRAM address (word)
; Output:
;	d0	32-bit VDP command word for a VRAM write to specified address.
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_B29E:
	andi.l	#$FFFF,d0
	lsl.l	#2,d0
	lsr.w	#2,d0
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d0
	swap	d0
	rts
; End of function sub_B29E

; ===========================================================================

; macro for declaring pointer/position structures for intro/credit text
vram_pnt := VRAM_Plane_A_Name_Table
creditsPtrs macro addr,pos
	if "addr"<>""
		dc.l addr
		dc.w vram_pnt + pos
		shift
		shift
		creditsPtrs ALLARGS
	else
		dc.w -1
	endif
    endm

textLoc function col,line,(($80 * line) + (2 * col))

; intro text pointers (one intro screen)
vram_pnt := VRAM_TtlScr_Plane_A_Name_Table
off_B2B0: creditsPtrs	byte_BD1A,textLoc($0F,$09), byte_BCEE,textLoc($11,$0C), \
			byte_BCF6,textLoc($03,$0F), byte_BCE9,textLoc($12,$12)

; credits screen pointer table
off_B2CA:
	dc.l off_B322, off_B336, off_B34A, off_B358	; 3
	dc.l off_B366, off_B374, off_B388, off_B3A8	; 7
	dc.l off_B3C2, off_B3DC, off_B3F0, off_B41C	; 11
	dc.l off_B436, off_B450, off_B45E, off_B490	; 15
	dc.l off_B4B0, off_B4C4, off_B4F0, off_B51C	; 19
	dc.l off_B548, -1				; 21

; credits text pointers for each screen of credits
vram_pnt := VRAM_Plane_A_Name_Table
off_B322: creditsPtrs	byte_BC46,textLoc($0E,$0B), byte_BC51,textLoc($18,$0B), byte_BC55,textLoc($02,$0F)
off_B336: creditsPtrs	byte_B55C,textLoc($03,$0B), byte_B56F,textLoc($16,$0B), byte_B581,textLoc($06,$0F)
off_B34A: creditsPtrs	byte_B56F,textLoc($0C,$0B), byte_B59F,textLoc($07,$0F)
off_B358: creditsPtrs	byte_B5BC,textLoc($0C,$0B), byte_B5CD,textLoc($06,$0F)
off_B366: creditsPtrs	byte_B5EB,textLoc($05,$0B), byte_B60C,textLoc($07,$0F)
off_B374: creditsPtrs	byte_B628,textLoc($08,$0A), byte_B642,textLoc($04,$0E), byte_B665,textLoc($0A,$10)
off_B388: creditsPtrs	byte_B67B,textLoc($04,$08), byte_B69C,textLoc($11,$0A), byte_B6A4,textLoc($09,$0C), byte_B6BC,textLoc($04,$10), byte_B6DE,textLoc($08,$12)
off_B3A8: creditsPtrs	byte_B6F8,textLoc($0B,$09), byte_B70B,textLoc($09,$0B), byte_B723,textLoc($0A,$0F), byte_B738,textLoc($03,$11)
off_B3C2: creditsPtrs	byte_B75C,textLoc($04,$09), byte_B642,textLoc($04,$0D), byte_B77E,textLoc($07,$0F), byte_B799,textLoc($07,$11)
off_B3DC: creditsPtrs	byte_B7B5,textLoc($08,$0A), byte_B75C,textLoc($04,$0C), byte_B799,textLoc($07,$10)
off_B3F0: creditsPtrs	byte_B7F2,textLoc($09,$06), byte_B6BC,textLoc($04,$0A), byte_B80B,textLoc($0A,$0C), byte_B821,textLoc($09,$0E), byte_B839,textLoc($07,$10), byte_B855,textLoc($0B,$12), byte_B869,textLoc($0B,$14)
off_B41C: creditsPtrs	byte_B7B5,textLoc($09,$09), byte_B87D,textLoc($0A,$0B), byte_B893,textLoc($0B,$0F), byte_B8A8,textLoc($07,$11)
off_B436: creditsPtrs	byte_B8C5,textLoc($06,$09), byte_B8E2,textLoc($05,$0D), byte_B902,textLoc($03,$0F), byte_B90F,textLoc($04,$11)
off_B450: creditsPtrs	byte_B932,textLoc($04,$0B), byte_B954,textLoc($05,$0F)
off_B45E: creditsPtrs	byte_B974,textLoc($04,$05), byte_B995,textLoc($0F,$09), byte_B9A1,textLoc($0F,$0B), byte_B9AD,textLoc($0F,$0D), byte_B9B8,textLoc($10,$0F), byte_B9C1,textLoc($11,$11), byte_B9C8,textLoc($11,$13), byte_B9D0,textLoc($0F,$15)
off_B490: creditsPtrs	byte_B9DB,textLoc($03,$08), byte_BA00,textLoc($08,$0C), byte_BA1B,textLoc($06,$0E), byte_BA3A,textLoc($09,$10), byte_BA52,textLoc($0A,$12)
off_B4B0: creditsPtrs	byte_BA69,textLoc($09,$0A), byte_BA81,textLoc($05,$0E), byte_B7CE,textLoc($03,$10)
off_B4C4: creditsPtrs	byte_B55C,textLoc($0B,$06), byte_BAA2,textLoc($0A,$08), byte_BAB8,textLoc($03,$0C), byte_BADC,textLoc($07,$0E), byte_BAF7,textLoc($05,$10), byte_BB16,textLoc($07,$12), byte_BB32,textLoc($02,$14)
off_B4F0: creditsPtrs	byte_BB58,textLoc($06,$06), byte_BB75,textLoc($12,$08), byte_BB7B,textLoc($06,$0C), byte_BC9F,textLoc($05,$0E), byte_BBD8,textLoc($08,$10), byte_BBF2,textLoc($08,$12), byte_BC0C,textLoc($09,$14)
off_B51C: creditsPtrs	byte_BB58,textLoc($06,$06), byte_BB75,textLoc($12,$08), byte_BB98,textLoc($03,$0C), byte_BBBC,textLoc($07,$0E), byte_BCBE,textLoc($07,$10), byte_BCD9,textLoc($0D,$12), byte_BC25,textLoc($04,$14)
off_B548: creditsPtrs	byte_BC7B,textLoc($0B,$09), byte_BC8F,textLoc($12,$0D), byte_BC95,textLoc($10,$11)

 ; temporarily remap characters to credit text format
 ; let's encode 2-wide characters like Aa, Bb, Cc, etc. and hide it with a macro
 charset '@',"\x3B\2\4\6\8\xA\xC\xE\x10\x12\x13\x15\x17\x19\x1B\x1D\x1F\x21\x23\x25\x27\x29\x2B\x2D\x2F\x31\x33"
 charset 'a',"\3\5\7\9\xB\xD\xF\x11\x12\x14\x16\x18\x1A\x1C\x1E\x20\x22\x24\x26\x28\x2A\x2C\x2E\x30\x32\x34"
 charset '!',"\x3D\x39\x3F\x36"
 charset '\H',"\x39\x37\x38"
 charset '9',"\x3E\x40\x41"
 charset '1',"\x3C\x35"
 charset '.',"\x3A"
 charset ' ',0

 ; macro for defining credit text in conjunction with the remapped character set
vram_src := ArtTile_ArtNem_CreditText_CredScr
creditText macro pal,ss
	if ((vram_src & $FF) <> $0) && ((vram_src & $FF) <> $1)
		fatal "The low byte of vram_src was $\{vram_src & $FF}, but it must be $00 or $01."
	endif
c := 0
	dc.b (make_art_tile(vram_src,pal,0) & $FF00) >> 8
	rept strlen(ss)
t := substr(ss,c,1)
	dc.b t
l := lowstring(t)
	if t="I"
	elseif l<>t
		dc.b l
	elseif t="1"
		dc.b "!"
	elseif t="2"
		dc.b "$"
	elseif t="9"
		dc.b "#"
	endif
c := c+1
	endm
	dc.b -1
	rev02even
    endm

; credits text data (palette index followed by a string)
vram_src := ArtTile_ArtNem_CreditText_CredScr
byte_B55C:	creditText 1,"EXECUTIVE"
byte_B56F:	creditText 1,"PRODUCER"
byte_B581:	creditText 0,"HAYAO  NAKAYAMA"
byte_B59F:	creditText 0,"SHINOBU  TOYODA"
byte_B5BC:	creditText 1,"DIRECTOR"
byte_B5CD:	creditText 0,"MASAHARU  YOSHII"
byte_B5EB:	creditText 1,"CHIEF  PROGRAMMER"
byte_B60C:	creditText 0,"YUJI  NAKA (YU2)"
byte_B628:	creditText 1,"GAME  PLANNER"
byte_B642:	creditText 0,"HIROKAZU  YASUHARA"
byte_B665:	creditText 0,"(CAROL  YAS)"
byte_B67B:	creditText 1,"CHARACTER  DESIGN"
byte_B69C:	creditText 1,"AND"
byte_B6A4:	creditText 1,"CHIEF  ARTIST"
byte_B6BC:	creditText 0,"YASUSHI  YAMAGUCHI"
byte_B6DE:	creditText 0,"(JUDY  TOTOYA)"
byte_B6F8:	creditText 1,"ASSISTANT"
byte_B70B:	creditText 1,"PROGRAMMERS"
byte_B723:	creditText 0,"BILL  WILLIS"
byte_B738:	creditText 0,"MASANOBU  YAMAMOTO"
byte_B75C:	creditText 1,"OBJECT  PLACEMENT"
byte_B77E:	creditText 0,"TAKAHIRO  ANTO"
byte_B799:	creditText 0,"YUTAKA  SUGANO"
byte_B7B5:	creditText 1,"SPECIALSTAGE"
byte_B7CE:	creditText 0,"CAROL  ANN  HANSHAW"
byte_B7F2:	creditText 1,"ZONE  ARTISTS"
byte_B80B:	creditText 0,"CRAIG  STITT"
byte_B821:	creditText 0,"BRENDA  ROSS"
byte_B839:	creditText 0,"JINA  ISHIWATARI"
byte_B855:	creditText 0,"TOM  PAYNE"
byte_B869:	creditText 0,"PHENIX  RIE"
byte_B87D:	creditText 1,"ART  AND  CG"
byte_B893:	creditText 0,"TIM  SKELLY"
byte_B8A8:	creditText 0,"PETER  MORAWIEC"
byte_B8C5:	creditText 1,"MUSIC  COMPOSER"
byte_B8E2:	creditText 0,"MASATO  NAKAMURA"
byte_B902:	creditText 0,"( @1992"
byte_B90F:	creditText 0,"DREAMS  COME  TRUE)"
byte_B932:	creditText 1,"SOUND  PROGRAMMER"
byte_B954:	creditText 0,"TOMOYUKI  SHIMADA"
byte_B974:	creditText 1,"SOUND  ASSISTANTS"
byte_B995:	creditText 0,"MACKY"
byte_B9A1:	creditText 0,"JIMITA"
byte_B9AD:	creditText 0,"MILPO"
byte_B9B8:	creditText 0,"IPPO"
byte_B9C1:	creditText 0,"S.O"
byte_B9C8:	creditText 0,"OYZ"
byte_B9D0:	creditText 0,"N.GEE"
byte_B9DB:	creditText 1,"PROJECT  ASSISTANTS"
byte_BA00:	creditText 0,"SYUICHI  KATAGI"
byte_BA1B:	creditText 0,"TAKAHIRO  HAMANO"
byte_BA3A:	creditText 0,"YOSHIKI  OOKA"
byte_BA52:	creditText 0,"STEVE  WOITA"
byte_BA69:	creditText 1,"GAME  MANUAL"
byte_BA81:	creditText 0,"YOUICHI  TAKAHASHI"
byte_BAA2:	creditText 1,"SUPPORTERS"
byte_BAB8:	creditText 0,"DAIZABUROU  SAKURAI"
byte_BADC:	creditText 0,"HISASHI  SUZUKI"
    if gameRevision=0
byte_BAF7:	creditText 0,"TOHMAS  KALINSKE"	; typo
    else
byte_BAF7:	creditText 0,"THOMAS  KALINSKE"
    endif
byte_BB16:	creditText 0,"FUJIO  MINEGISHI"
byte_BB32:	creditText 0,"TAKAHARU UTSUNOMIYA"
byte_BB58:	creditText 1,"SPECIAL  THANKS"
byte_BB75:	creditText 1,"TO"
byte_BB7B:	creditText 0,"CINDY  CLAVERAN"
byte_BB98:	creditText 0,"DEBORAH  MCCRACKEN"
byte_BBBC:	creditText 0,"TATSUO  YAMADA"
byte_BBD8:	creditText 0,"DAISUKE  SAITO"
byte_BBF2:	creditText 0,"KUNITAKE  AOKI"
byte_BC0C:	creditText 0,"TSUNEKO  AOKI"
byte_BC25:	creditText 0,"MASAAKI  KAWAMURA"
byte_BC46:	creditText 0,"SONIC"
byte_BC51:	creditText 1,"2"
byte_BC55:	creditText 0,"CAST  OF  CHARACTERS"
byte_BC7B:	creditText 0,"PRESENTED"
byte_BC8F:	creditText 0,"BY"
byte_BC95:	creditText 0,"SEGA"
byte_BC9F:	creditText 0,"FRANCE  TANTIADO"
byte_BCBE:	creditText 0,"RICK  MACARAEG"
byte_BCD9:	creditText 0,"LOCKY  P"

 charset ; have to revert character set before changing again

 ; temporarily remap characters to intro text format
 charset '@',"\x3A\1\3\5\7\9\xB\xD\xF\x11\x12\x14\x16\x18\x1A\x1C\x1E\x20\x22\x24\x26\x28\x2A\x2C\x2E\x30\x32"
 charset 'a',"\2\4\6\8\xA\xC\xE\x10\x11\x13\x15\x17\x19\x1B\x1D\x1F\x21\x23\x25\x27\x29\x2B\x2D\x2F\x31\x33"
 charset '!',"\x3C\x38\x3E\x35"
 charset '\H',"\x38\x36\x37"
 charset '9',"\x3D\x3F\x40"
 charset '1',"\x3B\x34"
 charset '.',"\x39"
 charset ' ',0

; intro text
vram_src := ArtTile_ArtNem_CreditText
byte_BCE9:	creditText   0,"IN"
byte_BCEE:	creditText   0,"AND"
byte_BCF6:	creditText   0,"MILES 'TAILS' PROWER"
byte_BD1A:	creditText   0,"SONIC"

 charset ; revert character set

	even

; -------------------------------------------------------------------------------
; Nemesis compressed art
; 64 blocks
; Standard font used in credits
; -------------------------------------------------------------------------------
; ArtNem_BD26:
ArtNem_CreditText:	BINCLUDE	"art/nemesis/Credit Text.bin"
	even
; ===========================================================================

    if ~~removeJmpTos
JmpTo5_DisplaySprite 
	jmp	(DisplaySprite).l
JmpTo3_DeleteObject 
	jmp	(DeleteObject).l
JmpTo2_PlaySound 
	jmp	(PlaySound).l
JmpTo_ObjB2_Animate_Pilot 
	jmp	(ObjB2_Animate_Pilot).l
JmpTo_AnimateSprite 
	jmp	(AnimateSprite).l
JmpTo_NemDec 
	jmp	(NemDec).l
JmpTo_EniDec 
	jmp	(EniDec).l
JmpTo_ClearScreen 
	jmp	(ClearScreen).l
JmpTo2_PlayMusic 
	jmp	(PlayMusic).l
JmpTo_LoadChildObject 
	jmp	(LoadChildObject).l
; JmpTo2_PlaneMapToVRAM_H40 
JmpTo2_PlaneMapToVRAM_H40 
	jmp	(PlaneMapToVRAM_H40).l
JmpTo2_ObjectMove 
	jmp	(ObjectMove).l
JmpTo_PalCycle_Load 
	jmp	(PalCycle_Load).l
JmpTo_LoadSubObject_Part3 
	jmp	(LoadSubObject_Part3).l

	align 4
    endif
