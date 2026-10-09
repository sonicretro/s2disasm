; loc_9C7C:
EndingSequence:
	clearRAM Object_RAM,Object_RAM_End
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
	st.b	(Super_Sonic_flag).w
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
	jsrto	JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_EndingPics),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingPics).l,a0
	jsrto	JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_EndingMiniTornado),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingMiniTornado).l,a0
	jsrto	JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Tornado),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Tornado).l,a0
	jsrto	JmpTo_NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Clouds),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Clouds).l,a0
	jsrto	JmpTo_NemDec
	move.w	#death_egg_zone_act_1,(Current_ZoneAndAct).w
	move	#$2300,sr
	moveq	#signextendB(MusID_Ending),d0
	jsrto	JmpTo2_PlayMusic
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
	move.w	d0,(Level_frame_counter).w
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

    if fixBugs
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len
    else
	; The '+4' shouldn't be here; clearRAM accidentally clears an additional 4 bytes
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len+4
    endif

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
	addq.w	#1,(Level_frame_counter).w
	jsr	(RandomNumber).l
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	tst.b	(Ending_PalCycle_flag).w
	beq.s	+
	jsrto	JmpTo_PalCycle_Load
+
	bsr.w	EndgameCredits
	tst.w	(Level_Inactive_flag).w
	beq.w	-
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_9EF4
EndgameCredits:
	tst.b	(Credits_Trigger).w
	beq.w	.return
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
	jsrto	JmpTo_ClearScreen

	clearRAM Object_Display_Lists,Object_Display_Lists_End
	clearRAM Object_RAM,Object_RAM_End
	clearRAM Misc_Variables,Misc_Variables_End
	clearRAM Camera_RAM,Camera_RAM_End

	clr.b	(Screen_Shaking_Flag).w
	moveq	#0,d0
	move.w	d0,(Level_Inactive_flag).w
	move.w	d0,(Level_frame_counter).w
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

    if fixBugs
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len
    else
	; The '+4' shouldn't be here; clearRAM accidentally clears an additional 4 bytes
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf+HorizontalScrollBuffer.len+4
    endif

	moveq	#signextendB(MusID_Credits),d0
	jsrto	JmpTo2_PlaySound
	clr.w	(Target_palette).w
	move.w	#$EEE,(Target_palette+$C).w
	move.w	#$EE,(Target_palette_line2+$C).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_CreditText_CredScr),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_CreditText).l,a0
	jsrto	JmpTo_NemDec
	clr.w	(CreditsScreenIndex).w
-
	jsrto	JmpTo_ClearScreen
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
	jsrto	JmpTo_ClearScreen
	move.l	#vdpComm($0000,VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingTitle).l,a0
	jsrto	JmpTo_NemDec
	lea	(MapEng_EndGameLogo).l,a0
	lea	(Chunk_Table).l,a1
	move.w	#0,d0
	jsrto	JmpTo_EniDec
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_A_Name_Table+planeLoc(64,12,11),VRAM,WRITE),d0
	moveq	#16-1,d1
	moveq	#6-1,d2
	jsrto	JmpTo2_PlaneMapToVRAM_H40
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
	st.b	(Level_Inactive_flag).w
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen

.return:
	rts
; End of function EndgameCredits


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_A0C0
EndgameLogoFlash:
	lea	(Normal_palette+2).w,a2
	move.w	(CreditsScreenIndex).w,d0
	cmpi.w	#$24,d0
	bhs.s	EndgameCredits.return
	btst	#0,d0
	bne.s	EndgameCredits.return
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
	even

; palette cycle for the end-of-game logo
pal_A0FE:	BINCLUDE	"art/palettes/Ending Cycle.bin"

; ===========================================================================
