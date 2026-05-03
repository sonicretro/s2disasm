; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_7650
SSSetGeometryOffsets:
	move.b	(SSTrack_drawing_index).w,d0					; Get drawing position
	cmp.b	(SS_player_anim_frame_timer).w,d0				; Compare to player frame duration
	beq.s	+												; If both are equal, branch
	rts
; ===========================================================================
+
	moveq	#0,d0
	move.b	(SSTrack_mapping_frame).w,d0					; Get current track mapping frame
	add.w	d0,d0											; Convert to index
	lea	SSCurveOffsets(pc,d0.w),a2							; Load current curve offsets into a2
	move.b	(a2)+,d0										; Get x offset
	tst.b	(SSTrack_Orientation).w							; Is track flipped?
	beq.s	+												; Branch if not
	neg.b	d0												; Change sign of offset
+
	ext.w	d0												; Extend to word
	addi.w	#$80,d0											; Add 128 (why?)
	move.w	d0,(SS_Offset_X).w								; Set X geometry offset
	move.b	(a2),d0											; Get y offset
	ext.w	d0												; Extend to word
	addi.w	#$36,d0											; Add $36 (why?)
	move.w	d0,(SS_Offset_Y).w								; Set Y geometry offset
	rts
; End of function SSSetGeometryOffsets

; ===========================================================================
; Position offsets to sort-of rotate the plane Sonic/Tails are in
; when the special stage track is curving, so they follow it better.
; Each word seems to be (x_offset, y_offset)
; See also Ani_SpecialStageTrack.
SSCurveOffsets: ; word_768A:
	dc.b $13,   0,   $13,   0,   $13,   0,   $13,   0	; $00
	dc.b   9, -$A,     0,-$1C,     0,-$1C,     0,-$20	; $04
	dc.b   0,-$24,     0,-$2A,     0,-$10,     0,   6	; $08
	dc.b   0,  $E,     0, $10,     0, $12,     0, $12	; $0C
	dc.b   9, $12                                    	; $10; upward curve
	dc.b   0,   0,     0,   0,     0,   0,     0,   0	; $11; straight
	dc.b $13,   0,   $13,   0,   $13,   0,   $13,   0	; $15
	dc.b  $B,  $C,     0,  $C,     0, $12,     0,  $A	; $19
	dc.b   0,   8,     0,   2,     0, $10,     0,-$20	; $1D
	dc.b   0,-$1F,     0,-$1E,     0,-$1B,     0,-$18	; $21
	dc.b   0, -$E                                    	; $25; downward curve
	dc.b $13,   0,   $13,   0,   $13,   0,   $13,   0	; $26
	dc.b $13,   0,   $13,   0                        	; $2B; turning
	dc.b $13,   0,   $13,   0,   $13,   0,   $13,   0	; $2C
	dc.b  $B,   0                                    	; $30; exit turn
	dc.b   0,   0,     0,   0,     0,   0,     0,   0	; $31
	dc.b   0,   0,     0,   0,     3,   0            	; $35; straight
; ===========================================================================
; Subroutine to advance to the next act and get an encoded version
; of the ring requirements.
; Output:
; 	d0, d1: Binary coded decimal version of ring requirements (maximum of 299 rings)
; 	d2: Number of digits in the ring requirements - 1 (minimum 2 digits)
;loc_76FA
SSStartNewAct:
	moveq	#0,d1
	moveq	#1,d2
	move.w	(Current_Special_StageAndAct).w,d0
	move.b	d0,d1
	lsr.w	#8,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d1,d0
	tst.w	(Player_mode).w
	bne.s	+
	move.b	SpecialStage_RingReq_Team(pc,d0.w),d1
	bra.s	++
; ===========================================================================
+
	move.b	SpecialStage_RingReq_Alone(pc,d0.w),d1
+
	move.w	d1,(SS_Ring_Requirement).w
	moveq	#0,d0
	cmpi.w	#100,d1
	blt.s	+
	addq.w	#1,d2
    if fixBugs
	; The following code does a more complete binary coded decimal conversion:
-	addi.w	#$100,d0
	subi.w	#100,d1
	cmpi.w	#100,d1
	bge.s	-
    else
	; This code (the original) is limited to 299 rings:
	subi.w	#100,d1
	move.w	#$100,d0
	cmpi.w	#100,d1
	blt.s	+
	subi.w	#100,d1
	addi.w	#$100,d0
    endif
+
	divu.w	#10,d1
	lsl.w	#4,d1
	or.b	d1,d0
	swap	d1
	or.b	d1,d0
	move.w	d0,d1
	addi_.w	#1,(Current_Special_StageAndAct).w
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Ring requirement values for Sonic and Tails games
;
; This array stores the number of rings you need to get to complete each round
; of each special stage, while playing with both Sonic and Tails. 4 bytes per
; stage, corresponding to the four possible parts of the level. Last part is unused.
; ----------------------------------------------------------------------------
; Misc_7756:
SpecialStage_RingReq_Team:
	dc.b  40, 80,140,120	; 4
	dc.b  50,100,140,150	; 8
	dc.b  60,110,160,170	; 12
	dc.b  40,100,150,160	; 16
	dc.b  55,110,200,200	; 20
	dc.b  80,140,220,220	; 24
	dc.b 100,190,210,210	; 28
	even
; ----------------------------------------------------------------------------
; Ring requirement values for Sonic or Tails alone games
;
; This array stores the number of rings you need to get to complete each round
; of each special stage, while playing with either Sonic or Tails. 4 bytes per
; stage, corresponding to the four possible parts of the level. Last part is unused.
; ----------------------------------------------------------------------------
; Misc_7772:
SpecialStage_RingReq_Alone:
	dc.b  30, 70,130,110	; 4
	dc.b  50,100,140,140	; 8
	dc.b  50,110,160,160	; 12
	dc.b  40,110,150,150	; 16
	dc.b  50, 90,160,160	; 20
	dc.b  80,140,210,210	; 24
	dc.b 100,150,190,190	; 28
	even

; special stage palette table
; word_778E:
SpecialStage_Palettes:
	dc.w   PalID_SS1
	dc.w   PalID_SS2
	dc.w   PalID_SS3
	dc.w   PalID_SS4
	dc.w   PalID_SS5
	dc.w   PalID_SS6
	dc.w   PalID_SS7
	dc.w   PalID_SS1_2p
	dc.w   PalID_SS2_2p
	dc.w   PalID_SS3_2p

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_77A2
SSInitPalAndData:
	clr.b	(Current_Special_Act).w
	move.b	#-1,(SpecialStage_LastSegment2).w
	move.w	#0,(Ring_count).w
	move.w	#0,(Ring_count_2P).w
	move.b	#0,(Perfect_rings_flag).w
	move.b	#0,(Got_Emerald).w
	move.b	#4,(SS_Star_color_2).w
	lea	(SS2p_RingBuffer).w,a2
	moveq	#0,d0
	move.w	d0,(a2)+
	move.w	d0,(a2)+
	move.w	d0,(a2)+
	move.w	d0,(a2)+
	move.w	d0,(a2)+
	move.w	d0,(a2)+
	moveq	#PalID_SS,d0
	bsr.w	PalLoad_ForFade
	lea_	SpecialStage_Palettes,a1
	moveq	#0,d0
	move.b	(Current_Special_Stage).w,d0
	add.w	d0,d0
	move.w	d0,d1
	tst.b	(SS_2p_Flag).w
	beq.s	+
	cmpi.b	#4,d0
	blo.s	+
	addi_.w	#6,d0
+
	move.w	(a1,d0.w),d0
	bsr.w	PalLoad_ForFade
	lea	(SSRAM_MiscKoz_SpecialObjectLocations).w,a0
	adda.w	(a0,d1.w),a0
	move.l	a0,(SS_CurrentLevelObjectLocations).w
	lea	(SSRAM_MiscNem_SpecialLevelLayout).w,a0
	adda.w	(a0,d1.w),a0
	move.l	a0,(SS_CurrentLevelLayout).w
	rts
; End of function SSInitPalAndData

; ===========================================================================

 ; temporarily remap characters to title card letter format
 ; Characters are encoded as Aa, Bb, Cc, etc. through a macro
 charset 'A',0	; can't have an embedded 0 in a string
 charset 'B',"\4\8\xC\4\x10\x14\x18\x1C\x1E\x22\x26\x2A\4\4\x30\x34\x38\x3C\x40\x44\x48\x4C\x52\x56\4"
 charset 'a',"\4\4\4\4\4\4\4\4\2\4\4\4\6\4\4\4\4\4\4\4\4\4\6\4\4"
 charset '.',"\x5A"

; letter lookup string
llookup	:= "ABCDEFGHIJKLMNOPQRSTUVWXYZ ."

; macro for defining title card letters in conjunction with the remapped character set
titleLetters macro letters
     ;  ". ZYXWVUTSRQPONMLKJIHGFEDCBA"
used := %0110000000000110000000010000	; set to initial state
    irpc char,letters
	if ~~(used&1<<strstr(llookup,"char"))	; has the letter been used already?
used := used|1<<strstr(llookup,"char")	; if not, mark it as used
	dc.b "char"			; output letter code
	if "char"=="."
	dc.b 2			; output character size
	else
	dc.b lowstring("char")	; output letter size
	endif
	endif
    endm
	dc.w $FFFF	; output string terminator
    endm

;word_7822:
SpecialStage_ResultsLetters:
	titleLetters	"ACDGHILMPRSTUW."

 charset ; revert character set

; ===========================================================================

	jmpTos JmpTo_DisplaySprite,JmpTo_LoadTitleCardSS,JmpTo_DeleteObject,JmpTo_Obj5A_CreateRingReqMessage,JmpTo_Obj5A_PrintPhrase,JmpTo_ObjectMove,JmpTo_Hud_Base
