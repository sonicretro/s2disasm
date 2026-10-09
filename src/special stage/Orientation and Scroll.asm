; (!)
;loc_6C0A
SSTrackSetOrientation:
	move.b	(SS_Alternate_HorizScroll_Buf).w,(SS_Last_Alternate_HorizScroll_Buf).w
	moveq	#0,d1
	movea.l	(SSTrack_mappings_bitflags).w,a0				; Get frame mappings pointer
	cmpa.l	#MapSpec_Straight2,a0						; Is the track rising or one of the first straight frame?
	blt.s	+								; Branch if yes
	cmpa.l	#MapSpec_Straight3,a0						; Is it straight path frame 3 or higher?
	bge.s	+								; Branch if yes
	; We only get here for straight frame 2
	movea.l	(SS_CurrentLevelLayout).w,a5					; Get current level layout
	move.b	(SpecialStage_CurrentSegment).w,d1				; Get current segment
	move.b	(a5,d1.w),d1							; Get segment geometry
	bpl.s	+++								; Branch if not flipped
-
	st.b	(SSTrack_Orientation).w						; Mark as being flipped
	move.b	(SSTrack_drawing_index).w,d0					; Get drawing position
	cmp.b	(SS_player_anim_frame_timer).w,d0				; Is it lower than the player's frame?
	blt.w	return_6C9A							; Return if yes
	st.b	(SS_Alternate_HorizScroll_Buf).w				; Use the alternate horizontal scroll buffer
	rts
; ===========================================================================
+
	cmpa.l	#MapSpec_Rise14,a0						; Is the track one of the first 13 rising frames?
	blt.s	+								; Branch if yes
	cmpa.l	#MapSpec_Rise15,a0						; Is it rising frame 15 or higher?
	bge.s	+								; Branch if yes
	; We only get here for straight frame 14
	movea.l	(SS_CurrentLevelLayout).w,a5					; Get current level layout
	move.b	(SpecialStage_CurrentSegment).w,d1				; Get current segment
	move.b	(a5,d1.w),d1							; Get segment geometry
	bpl.s	++								; Branch if not flipped
	bra.s	-
; ===========================================================================
+
	cmpa.l	#MapSpec_Drop6,a0						; Is the track before drop frame 6?
	blt.s	return_6C9A							; Return is yes
	cmpa.l	#MapSpec_Drop7,a0						; Is it drop frame 7 or higher?
	bge.s	return_6C9A							; Return if yes
	; We only get here for straight frame 6
	movea.l	(SS_CurrentLevelLayout).w,a5					; Get current level layout
	move.b	(SpecialStage_CurrentSegment).w,d1				; Get current segment
	move.b	(a5,d1.w),d1							; Get segment geometry
	bmi.s	-								; Branch if flipped
+
	sf.b	(SSTrack_Orientation).w						; Mark as being unflipped
	move.b	(SSTrack_drawing_index).w,d0					; Get drawing position
	cmp.b	(SS_player_anim_frame_timer).w,d0				; Is it lower than the player's frame?
	blt.s	return_6C9A							; Return if yes
	sf.b	(SS_Alternate_HorizScroll_Buf).w				; Don't use the alternate horizontal scroll buffer

return_6C9A:
	rts
; End of function SSTrack_Draw


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Initialize the PNT and H scroll table buffers.

ssInitTableBuffers:
	lea	(SS_Horiz_Scroll_Buf_1).w,a1
	lea	(SS_Horiz_Scroll_Buf_2).w,a2
	moveq	#0,d0								; Scroll of 0 for PNTA and PNTB on lines 0 and 1 (normal) or lines 6 and 7 (flipped)
	moveq	#0,d1								; Scroll of 0 for PNTB on lines 2 and 3 (normal) or lines 4 and 5 (flipped)
	moveq	#0,d2								; Scroll of 0 for PNTB on lines 4 and 5 (normal) or lines 2 and 3 (flipped)
	moveq	#0,d3								; Scroll of 0 for PNTB on lines 6 and 7 (normal) or lines 0 and 1 (flipped)
	move.w	#-$100,d1							; Scroll of 3 screens for PNTA on lines 2 and 3 (normal) or lines 4 and 5 (flipped)
	move.w	#-$200,d2							; Scroll of 2 screens for PNTA on lines 4 and 5 (normal) or lines 2 and 3 (flipped)
	move.w	#-$300,d3							; Scroll of 1 screen for PNTA on lines 6 and 7 (normal) or lines 0 and 1 (flipped)
	swap	d1
	swap	d2
	swap	d3
	moveq	#bytesToXcnt(HorizontalScrollBuffer.len,4*8),d4

-	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d1,(a1)+
	move.l	d1,(a1)+
	move.l	d2,(a1)+
	move.l	d2,(a1)+
	move.l	d3,(a1)+
	move.l	d3,(a1)+
	move.l	d3,(a2)+
	move.l	d3,(a2)+
	move.l	d2,(a2)+
	move.l	d2,(a2)+
	move.l	d1,(a2)+
	move.l	d1,(a2)+
	move.l	d0,(a2)+
	move.l	d0,(a2)+
	dbf	d4,-

	rts
; End of function ssInitTableBuffers


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Load compressed special stage data into RAM, or VRAM for the art.

ssLdComprsdData:
	lea	(ArtKos_Special).l,a0
	lea	(Chunk_Table).l,a1
	bsr.w	KosDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_VRAM_Start),VRAM,WRITE),(VDP_control_port).l
	lea	(VDP_data_port).l,a1
	movea.l	#Chunk_Table,a0
	move.w	(a0)+,d0
	subq.w	#1,d0

-   rept tiles_to_longwords(1)-1
	move.l	(a0),(a1)
    endm
	move.l	(a0)+,(a1)
	dbf	d0,-

	lea	(MiscKoz_SpecialPerspective).l,a0
	lea	(SSRAM_MiscKoz_SpecialPerspective).l,a1
	bsr.w	KosDec
	lea	(MiscNem_SpecialLevelLayout).l,a0
	lea	(SSRAM_MiscNem_SpecialLevelLayout).w,a4
	bsr.w	NemDecToRAM
	lea	(MiscKoz_SpecialObjectLocations).l,a0
	lea	(SSRAM_MiscKoz_SpecialObjectLocations).w,a1
	bsr.w	KosDec
	rts
; End of function ssLdComprsdData


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_6D52
SSPlaneB_Background:
	move	#$2700,sr

	movea.l	#Chunk_Table+planeLoc(32,0,0),a1
	lea	(MapEng_SpecialBackBottom).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialBack,0,0),d0
	bsr.w	EniDec

	movea.l	#Chunk_Table+planeLoc(32,0,16),a1
	lea	(MapEng_SpecialBack).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialBack,0,0),d0
	bsr.w	EniDec

.c := 0
    rept 128/32
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_SS_Plane_B_Name_Table + planeLoc(128,32*.c,0),VRAM,WRITE),d0
	moveq	#32-1,d1
	moveq	#32-1,d2
    if removeJmpTos
	jsr	(PlaneMapToVRAM_H80_SpecialStage).l
    else
	bsr.w	PlaneMapToVRAM_H80_SpecialStage
    endif
.c := .c+1
    endm

	move	#$2300,sr
	rts
; End of function SSPlaneB_Background


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_6DD4
SSDecompressPlayerArt:
	lea	(ArtNem_SpecialSonicAndTails).l,a0
	lea	(SSRAM_ArtNem_SpecialSonicAndTails & $FFFFFF).l,a4
	bra.w	NemDecToRAM
; End of function SSDecompressPlayerArt


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_6DE4
SS_ScrollBG:
	bsr.w	SSPlaneB_SetHorizOffset
	bsr.w	SSTrack_SetVscroll
	rts
; End of function SS_ScrollBG

; ===========================================================================
; special stage background vertical and horizontal scroll offsets
off_6DEE:	offsetTable
		offsetTableEntry.w byte_6E04	;  0
		offsetTableEntry.w byte_6E09	;  1
		offsetTableEntry.w byte_6E0E	;  2
		offsetTableEntry.w byte_6E13	;  3
		offsetTableEntry.w byte_6E18	;  4
		offsetTableEntry.w byte_6E1D	;  5
		offsetTableEntry.w byte_6E22	;  6
		offsetTableEntry.w byte_6E27	;  7
		offsetTableEntry.w byte_6E2C	;  8
		offsetTableEntry.w byte_6E31	;  9
		offsetTableEntry.w byte_6E36	; $A
byte_6E04:	dc.b   2,  2,  2,  2,  2
byte_6E09:	dc.b   4,  4,  5,  4,  5
byte_6E0E:	dc.b  $B, $B, $B, $B, $C
byte_6E13:	dc.b   0,  0,  1,  0,  0
byte_6E18:	dc.b   1,  1,  1,  1,  1
byte_6E1D:	dc.b   9,  9,  8,  9,  9
byte_6E22:	dc.b   9,  9,  9,  9, $A
byte_6E27:	dc.b   7,  7,  6,  7,  7
byte_6E2C:	dc.b   0,  1,  1,  1,  0
byte_6E31:	dc.b   4,  3,  3,  3,  4
byte_6E36:	dc.b   0,  0,$FF,  0,  0
	even

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_6E3C
SSPlaneB_SetHorizOffset:
	moveq	#0,d7
	moveq	#0,d6
	moveq	#0,d0
	move.b	(SSTrack_last_anim_frame).w,d2				; Get last track animation frame
	move.b	(SSTrack_anim).w,d0					; Get current track animation
	add.w	d0,d0							; Convert it to an index
	move.w	off_6E54(pc,d0.w),d0
	jmp	off_6E54(pc,d0.w)
; ===========================================================================
off_6E54:	offsetTable
		offsetTableEntry.w +	; 0		; Turn, then rise
		offsetTableEntry.w +	; 1		; Turn, then drop
		offsetTableEntry.w +	; 2		; Turn, then straight
		offsetTableEntry.w ++	; 3 ; rts	; Straight
		offsetTableEntry.w ++	; 4 ; rts	; Straight, then turn
; ===========================================================================
+
	moveq	#0,d1
	cmpi.b	#1,d2							; Was the last frame the first in this segment?
	blt.s	++							; Branch if yes
	moveq	#2,d1
	cmpi.b	#2,d2							; Was the last frame frame 1?
	blt.s	++							; Branch if yes
	moveq	#4,d1
	cmpi.b	#$A,d2							; Was the last frame less than $A?
	blt.s	++							; Branch if yes
	moveq	#2,d1
	cmpi.b	#$B,d2							; Was the last frame $A?
	blt.s	++							; Branch if yes
	moveq	#0,d1
	cmpi.b	#$C,d2							; Was the last frame $B?
	blt.s	++							; Branch if yes
+
	rts
; ===========================================================================
+
	moveq	#0,d0
	moveq	#0,d2
	move.b	(SSTrack_drawing_index).w,d0				; Get drawing position
	lea_	off_6DEE,a0						; a0 = pointer to background scroll data
	adda.w	(a0,d1.w),a0						; a0 = pointer to background scroll data for current animation frame
	move.b	(a0,d0.w),d2						; Get background offset for current frame duration
	tst.b	(SS_Last_Alternate_HorizScroll_Buf).w			; Was the alternate horizontal scroll buffer used last time?
	bne.s	+							; Branch if yes
	tst.b	(SS_Alternate_HorizScroll_Buf).w			; Is the alternate horizontal scroll buffer being used now?
	beq.s	+++							; Branch if not
	bra.s	++
; ===========================================================================
+
	tst.b	(SS_Alternate_HorizScroll_Buf).w			; Is the alternate horizontal scroll buffer still being used?
	bne.s	++							; Branch if yes
	lea	(SS_Horiz_Scroll_Buf_1 + 2).w,a1			; Load horizontal scroll buffer for PNT B
	bra.s	+++
; ===========================================================================
+
	lea	(SS_Horiz_Scroll_Buf_2 + 2).w,a1			; Load alternate horizontal scroll buffer for PNT B
	neg.w	d2							; Change the sign of the background offset
	bra.s	++
; ===========================================================================
+
	lea	(SS_Horiz_Scroll_Buf_1 + 2).w,a1			; Load horizontal scroll buffer for PNT B
	tst.b	(SS_Alternate_HorizScroll_Buf).w			; Is the alternate horizontal scroll buffer being used now?
	beq.s	+							; Branch if not
	lea	(SS_Horiz_Scroll_Buf_2 + 2).w,a1			; Load alternate horizontal scroll buffer for PNT B
	neg.w	d2							; Change the sign of the background offset
+
	move.w	#bytesToLcnt(HorizontalScrollBuffer.len),d0		; 256 lines
-	sub.w	d2,(a1)+						; Change current line's offset
	adda_.l	#2,a1							; Skip PNTA entry
	dbf	d0,-

	rts
; End of function SSPlaneB_SetHorizOffset

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_6EE0
SSTrack_SetVscroll:
	move.w	(Vscroll_Factor_BG).w,(SSTrack_LastVScroll).w		; Save last vertical scroll value
	moveq	#0,d7							; Set flag to decrease vertical scroll
	moveq	#0,d0
	moveq	#0,d2
	move.b	(SSTrack_last_anim_frame).w,d2				; Get last track animation frame
	move.b	(SSTrack_anim).w,d0					; Get current track animation
	add.w	d0,d0							; Convert it to index
	move.w	off_6EFE(pc,d0.w),d0
	jmp	off_6EFE(pc,d0.w)
; ===========================================================================
off_6EFE:	offsetTable
		offsetTableEntry.w loc_6F0A	; 0		; Turn, then rise
		offsetTableEntry.w loc_6F2A	; 1		; Turn, then drop
		offsetTableEntry.w +		; 2 ; rts	; Turn, then straight
		offsetTableEntry.w loc_6F4C	; 3		; Straight
		offsetTableEntry.w +		; 4 ; rts	; Straight, then turn
; ===========================================================================
+
	rts
; ===========================================================================

loc_6F0A:
	move.b	+(pc,d2.w),d1							; Get current frame's vertical scroll offset
	bpl.s	SSTrack_ApplyVscroll						; Branch if positive
	rts
; ===========================================================================
; Special stage vertical scroll index for 'turn, then rise' animation
+
	dc.b  -1
	dc.b  -1	; 1
	dc.b  -1	; 2
	dc.b  -1	; 3
	dc.b  -1	; 4
	dc.b  -1	; 5
	dc.b  -1	; 6
	dc.b  -1	; 7
	dc.b  -1	; 8
	dc.b  -1	; 9
	dc.b   8	; 10
	dc.b   8	; 11
	dc.b   2	; 12
	dc.b   4	; 13
	dc.b   4	; 14
	dc.b   4	; 15
	dc.b   4	; 16
	dc.b   4	; 17
	dc.b   4	; 18
	dc.b  $A	; 19
	dc.b  $C	; 20
	dc.b  $E	; 21
	dc.b $12	; 22
	dc.b $10	; 23
	even
; ===========================================================================

loc_6F2A:
	st.b	d7								; Set flag to increase vertical scroll
	move.b	+(pc,d2.w),d1							; Get current frame's vertical scroll offset
	bpl.s	SSTrack_ApplyVscroll						; Branch if positive
	rts
; ===========================================================================
; Special stage vertical scroll index for 'turn, then drop' animation
+
	dc.b  -1
	dc.b  -1	; 1
	dc.b  -1	; 2
	dc.b  -1	; 3
	dc.b  -1	; 4
	dc.b  -1	; 5
	dc.b  -1	; 6
	dc.b  -1	; 7
	dc.b  -1	; 8
	dc.b  -1	; 9
	dc.b  -1	; 10
	dc.b $10	; 11
	dc.b $12	; 12
	dc.b  $E	; 13
	dc.b  $C	; 14
	dc.b  $A	; 15
	dc.b   4	; 16
	dc.b   4	; 17
	dc.b   4	; 18
	dc.b   4	; 19
	dc.b   4	; 20
	dc.b   4	; 21
	dc.b   2	; 22
	dc.b   0	; 23
	even
; ===========================================================================

loc_6F4C:
	tst.b	(SS_Pause_Only_flag).w						; Is the game paused?
	bne.s	+	; rts							; Return if yes
	move.b	++(pc,d2.w),d1							; Get current frame's vertical scroll offset
	bpl.s	SSTrack_ApplyVscroll						; Branch if positive
+
	rts
; ===========================================================================
; Special stage vertical scroll index for 'straight' animation -- bobbing up and down
+
    rept 4
	dc.b   6
	dc.b   6
	dc.b $14
	dc.b $14
    endm
; ===========================================================================
;loc_6F6A
SSTrack_ApplyVscroll:
	moveq	#0,d0
	moveq	#0,d2
	move.b	(SSTrack_drawing_index).w,d0					; Get drawing position
	lea_	off_6DEE,a0							; a0 = pointer to background scroll data
	adda.w	(a0,d1.w),a0							; a0 = pointer to background scroll data for current animation frame
	move.b	(a0,d0.w),d2							; Get background offset for current frame duration
	tst.b	d7								; Are we supposed to increase the vertical scroll?
	bpl.s	+								; Branch if not
	add.w	d2,(Vscroll_Factor_BG).w					; Increase vertical scroll
	rts
; ===========================================================================
+
	sub.w	d2,(Vscroll_Factor_BG).w					; Decrease vertical scroll
	rts
; End of function SSTrack_SetVscroll

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_6F8E: SSSingleObjLoad:
SSAllocateObject:
	lea	(SS_Dynamic_Object_RAM).w,a1
	move.w	#(SS_Dynamic_Object_RAM_End-SS_Dynamic_Object_RAM)/object_size-1,d5

-	tst.b	id(a1)
	beq.s	+	; rts
	lea	next_object(a1),a1 ; a1=object
	dbf	d5,-
+
	rts
; End of function sub_6F8E

; ===========================================================================

;loc_6FA4: SSSingleObjLoad2:
SSAllocateObjectAfterCurrent:
	movea.l	a0,a1
	move.w	#SS_Dynamic_Object_RAM_End,d5
	sub.w	a0,d5

    if object_size=$40
	lsr.w	#object_size_bits,d5
	subq.w	#1,d5
	bcs.s	+	; rts
    else
	lsr.w	#6,d5			; divide by $40
	move.b	++(pc,d5.w),d5		; load the right number of objects from table
	bmi.s	+			; if negative, we have failed!
    endif

-	tst.b	id(a1)
	beq.s	+	; rts
	lea	next_object(a1),a1
	dbf	d5,-

+	rts

    if object_size<>$40
+
.a	set	Object_RAM
.b	set	SS_Dynamic_Object_RAM_End
.c	set	.b			; begin from bottom of array and decrease backwards
	rept	(.b-.a+$40-1)/$40	; repeat for all slots, minus exception
.c	set	.c-$40			; address for previous $40 (also skip last part)
	dc.b	(.b-.c-1)/object_size-1	; write possible slots according to object_size division + hack + dbf hack
	endm
	even
    endif
