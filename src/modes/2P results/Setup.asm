; loc_819A:
Setup2PResults_Act:
	move.w	#$1F2,d2
	moveq	#0,d0
	bsr.w	sub_8672
	move.w	#$216,d2
	moveq	#0,d1
	move.b	(Current_Act_2P).w,d1
	addq.b	#1,d1
	bsr.w	sub_86B0
	move.w	#$33E,d2
	move.l	(Score).w,d1
	bsr.w	sub_86F6
	move.w	#$352,d2
	move.l	(Score_2P).w,d1
	bsr.w	sub_86F6
	move.w	#$3DA,d2
	moveq	#0,d0
	move.w	(Timer_minute_word).w,d1
	bsr.w	sub_86B0
	move.w	#$3E0,d2
	moveq	#0,d1
	move.b	(Timer_second).w,d1
	bsr.w	sub_86B0
	move.w	#$3E6,d2
	moveq	#0,d1
	move.b	(Timer_frame).w,d1
	mulu.w	#$1B0,d1
	lsr.l	#8,d1
	bsr.w	sub_86B0
	move.w	#$3EE,d2
	moveq	#0,d0
	move.w	(Timer_minute_word_2P).w,d1
	bsr.w	sub_86B0
	move.w	#$3F4,d2
	moveq	#0,d1
	move.b	(Timer_second_2P).w,d1
	bsr.w	sub_86B0
	move.w	#$3FA,d2
	moveq	#0,d1
	move.b	(Timer_frame_2P).w,d1
	mulu.w	#$1B0,d1
	lsr.l	#8,d1
	bsr.w	sub_86B0
	move.w	#$486,d2
	moveq	#0,d0
	move.w	(Ring_count).w,d1
	bsr.w	sub_86B0
	move.w	#$49A,d2
	move.w	(Ring_count_2P).w,d1
	bsr.w	sub_86B0
	move.w	#$526,d2
	moveq	#0,d0
	move.w	(Rings_Collected).w,d1
	bsr.w	sub_86B0
	move.w	#$53A,d2
	move.w	(Rings_Collected_2P).w,d1
	bsr.w	sub_86B0
	move.w	#$5C6,d2
	moveq	#0,d0
	move.w	(Monitors_Broken).w,d1
	bsr.w	sub_86B0
	move.w	#$5DA,d2
	move.w	(Monitors_Broken_2P).w,d1
	bsr.w	sub_86B0
	bsr.w	sub_8476
	move.w	#$364,d2
	move.w	#$6000,d0
	move.l	(Score).w,d1
	sub.l	(Score_2P).w,d1
	bsr.w	sub_8652
	move.w	#$404,d2
	move.l	(Timer_2P).w,d1
	sub.l	(Timer).w,d1
	bsr.w	sub_8652
	move.w	#$4A4,d2
	moveq	#0,d1
	move.w	(Ring_count).w,d1
	sub.w	(Ring_count_2P).w,d1
	bsr.w	sub_8652
	move.w	#$544,d2
	moveq	#0,d1
	move.w	(Rings_Collected).w,d1
	sub.w	(Rings_Collected_2P).w,d1
	bsr.w	sub_8652
	move.w	#$5E4,d2
	moveq	#0,d1
	move.w	(Monitors_Broken).w,d1
	sub.w	(Monitors_Broken_2P).w,d1
	bsr.w	sub_8652
	move.w	#$706,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a4),d1
	bsr.w	sub_86B0
	move.w	#$70E,d2
	moveq	#0,d1
	move.b	1(a4),d1
	bsr.w	sub_86B0
	move.w	(a4),(SS_Total_Won).w
	rts
; ===========================================================================
; loc_82FA:
Setup2PResults_Zone:
	move.w	#$242,d2
	moveq	#0,d0
	bsr.w	sub_8672
	bsr.w	sub_84A4
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	move.w	#$398,d6
	bsr.w	sub_854A
	move.w	#$488,d6
	bsr.w	sub_854A
	move.w	#$618,d6
	bsr.w	sub_854A
	rts
; ===========================================================================
; loc_8328:
Setup2PResults_Game:
	lea	(Results_Data_2P).w,a5
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	move.w	#$208,d6
	bsr.w	sub_84C4
	move.w	#$258,d6
	bsr.w	sub_84C4
	move.w	#$2A8,d6
	bsr.w	sub_84C4
	move.w	#$348,d6
	bsr.w	sub_84C4
	move.w	#$398,d6
	bsr.w	sub_84C4
	move.w	#$3E8,d6
	bsr.w	sub_84C4
	move.w	#$488,d6
	bsr.w	sub_84C4
	move.w	#$4D8,d6
	bsr.w	sub_84C4
	move.w	#$528,d6
	bsr.w	sub_84C4
	move.w	#$5C8,d6
	bsr.w	sub_84C4
	move.w	#$618,d6
	bsr.w	sub_84C4
	move.w	#$668,d6
	bsr.w	sub_84C4
	move.w	#$70A,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a4),d1
	bsr.w	sub_86B0
	move.w	#$710,d2
	moveq	#0,d1
	move.b	1(a4),d1
	bsr.w	sub_86B0
	rts
; ===========================================================================
; loc_83B0:
Setup2PResults_SpecialAct:
	move.w	#$266,d2
	moveq	#0,d1
	move.b	(Current_Act_2P).w,d1
	addq.b	#1,d1
	bsr.w	sub_86B0
	move.w	#$4D6,d2
	moveq	#0,d0
	move.w	(SS2p_RingBuffer).w,d1		; P1 SS act 1 rings
	bsr.w	sub_86B0
	move.w	#$4E6,d2
	move.w	(SS2p_RingBuffer+2).w,d1	; P2 SS act 1 rings
	bsr.w	sub_86B0
	move.w	#$576,d2
	moveq	#0,d0
	move.w	(SS2p_RingBuffer+4).w,d1	; P1 SS act 2 rings
	bsr.w	sub_86B0
	move.w	#$586,d2
	move.w	(SS2p_RingBuffer+6).w,d1	; P2 SS act 2 rings
	bsr.w	sub_86B0
	move.w	#$616,d2
	moveq	#0,d0
	move.w	(SS2p_RingBuffer+8).w,d1	; P1 SS act 3 rings
	bsr.w	sub_86B0
	move.w	#$626,d2
	move.w	(SS2p_RingBuffer+$A).w,d1	; P2 SS act 3 rings
	bsr.w	sub_86B0
	bsr.w	sub_8476
	move.w	#$6000,d0
	move.w	#$4F0,d2
	moveq	#0,d1
	move.w	(SS2p_RingBuffer).w,d1		; P1 SS act 1 rings
	sub.w	(SS2p_RingBuffer+2).w,d1	; P2 SS act 1 rings
	bsr.w	sub_8652
	move.w	#$590,d2
	moveq	#0,d1
	move.w	(SS2p_RingBuffer+4).w,d1	; P1 SS act 2 rings
	sub.w	(SS2p_RingBuffer+6).w,d1	; P2 SS act 2 rings
	bsr.w	sub_8652
	move.w	#$630,d2
	moveq	#0,d1
	move.w	(SS2p_RingBuffer+8).w,d1	; P1 SS act 3 rings
	sub.w	(SS2p_RingBuffer+$A).w,d1	; P2 SS act 3 rings
	bsr.w	sub_8652
	move.w	(a4),(SS_Total_Won).w
	rts
; ===========================================================================
; loc_8452:
Setup2PResults_SpecialZone:
	bsr.w	sub_84A4
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	move.w	#$4D4,d6
	bsr.w	sub_85CE
	move.w	#$574,d6
	bsr.w	sub_85CE
	move.w	#$614,d6
	bsr.w	sub_85CE
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_8476:
	lea	(EHZ_Results_2P).w,a4
	move.b	(Current_Zone_2P).w,d0
	beq.s	+
	lea	(MCZ_Results_2P).w,a4
	subq.b	#1,d0
	beq.s	+
	lea	(CNZ_Results_2P).w,a4
	subq.b	#1,d0
	beq.s	+
	lea	(SS_Results_2P).w,a4
+
	moveq	#0,d0
	move.b	(Current_Act_2P).w,d0
	add.w	d0,d0
	lea	(a4,d0.w),a4
	clr.w	(a4)
	rts
; End of function sub_8476


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_84A4:
	lea	(EHZ_Results_2P).w,a5
	move.b	(Current_Zone_2P).w,d0
	beq.s	+	; rts
	lea	(MCZ_Results_2P).w,a5
	subq.b	#1,d0
	beq.s	+	; rts
	lea	(CNZ_Results_2P).w,a5
	subq.b	#1,d0
	beq.s	+	; rts
	lea	(SS_Results_2P).w,a5
+
	rts
; End of function sub_84A4


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_84C4:
	move.w	(a5),d0
	bmi.s	+
	move.w	d6,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a5),d1
	bsr.w	sub_86B0
	addq.w	#8,d6
	move.w	d6,d2
	moveq	#0,d1
	move.b	1(a5),d1
	bsr.w	sub_86B0
	addi.w	#$12,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; ===========================================================================
+
	addq.w	#4,d6
	not.w	d0
	bne.s	+
	lea	(Text2P_NoGame).l,a1
	move.w	d6,d2
	bsr.w	loc_8698
	addi.w	#$16,d6
	move.w	d6,d2
	lea	(Text2P_Blank).l,a1
	bsr.w	loc_8698
	addq.w	#2,a5
	rts
; ===========================================================================
+
	moveq	#0,d0
	lea	(Text2P_GameOver).l,a1
	move.w	d6,d2
	bsr.w	loc_8698
	addi.w	#$16,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; End of function sub_84C4


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_854A:
	move.w	(a5),d0
	bmi.s	loc_8582
	move.w	d6,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a5),d1
	bsr.w	sub_86B0
	addq.w	#8,d6
	move.w	d6,d2
	moveq	#0,d1
	move.b	1(a5),d1
	bsr.w	sub_86B0
	addi.w	#$C,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; ===========================================================================

loc_8582:
	not.w	d0
	bne.s	loc_85A6
	lea	(Text2P_NoGame).l,a1
	move.w	d6,d2
	bsr.w	loc_8698
	addi.w	#$14,d6
	move.w	d6,d2
	lea	(Text2P_Blank).l,a1
	bsr.w	loc_8698
	addq.w	#2,a5
	rts
; ===========================================================================

loc_85A6:
	moveq	#0,d0
	lea	(Text2P_GameOver).l,a1
	move.w	d6,d2
	bsr.w	loc_8698
	addi.w	#$14,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; End of function sub_854A


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_85CE:
	move.w	(a5),d0
	bmi.s	+
	move.w	d6,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a5),d1
	bsr.w	sub_86B0
	addi.w	#$C,d6
	move.w	d6,d2
	moveq	#0,d1
	move.b	1(a5),d1
	bsr.w	sub_86B0
	addi.w	#$10,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; ===========================================================================
+
	not.w	d0
	bne.s	loc_862C
	lea	(Text2P_NoGame).l,a1
	move.w	d6,d2
	addq.w	#4,d2
	bsr.w	loc_8698
	addi.w	#$14,d6
	move.w	d6,d2
	lea	(Text2P_Blank).l,a1
	bsr.s	loc_8698
	addq.w	#2,a5
	rts
; ===========================================================================

loc_862C:
	moveq	#0,d0
	lea	(Text2P_GameOver).l,a1
	move.w	d6,d2
	bsr.s	loc_8698
	addi.w	#$14,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; End of function sub_85CE


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_8652:
	lea	(Text2P_Tied).l,a1
	beq.s	++
	bcs.s	+
	lea	(Text2P_1P).l,a1
	addq.b	#1,(a4)
	bra.s	++
; ===========================================================================
+
	lea	(Text2P_2P).l,a1
	addq.b	#1,1(a4)
+
	bra.s	loc_8698
; End of function sub_8652


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_8672:
	lea	(Text2P_EmeraldHill).l,a1
	move.b	(Current_Zone_2P).w,d1
	beq.s	loc_8698
	lea	(Text2P_MysticCave).l,a1
	subq.b	#1,d1
	beq.s	loc_8698
	lea	(Text2P_CasinoNight).l,a1
	subq.b	#1,d1
	beq.s	loc_8698
	lea	(Text2P_SpecialStage).l,a1

loc_8698:
	lea	(Chunk_Table).l,a2
	lea	(a2,d2.w),a2
	moveq	#0,d1

	move.b	(a1)+,d1
-	move.b	(a1)+,d0
	move.w	d0,(a2)+
	dbf	d1,-

	rts
; End of function sub_8672


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_86B0:
	lea	(Chunk_Table).l,a2
	lea	(a2,d2.w),a2
	lea	(word_86F0).l,a3
	moveq	#0,d2

	moveq	#2,d5
-	moveq	#0,d3
	move.w	(a3)+,d4

-	sub.w	d4,d1
	bcs.s	+
	addq.w	#1,d3
	bra.s	-
; ---------------------------------------------------------------------------
+
	add.w	d4,d1
	tst.w	d5
	beq.s	++
	tst.w	d3
	beq.s	+
	moveq	#1,d2
+
	tst.w	d2
	beq.s	++
+
	addi.b	#$10,d3
	move.b	d3,d0
	move.w	d0,(a2)
+
	addq.w	#2,a2
	dbf	d5,--

	rts
; End of function sub_86B0

; ===========================================================================
word_86F0:
	dc.w   100
	dc.w	10	; 1
	dc.w	 1	; 2

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_86F6:
	lea	(Chunk_Table).l,a2
	lea	(a2,d2.w),a2
	lea	(dword_8732).l,a3
	moveq	#0,d2

	moveq	#5,d5
-	moveq	#0,d3
	move.l	(a3)+,d4

-	sub.l	d4,d1
	bcs.s	+
	addq.w	#1,d3
	bra.s	-
; ===========================================================================
+
	add.l	d4,d1
	tst.w	d3
	beq.s	+
	moveq	#1,d2
+
	tst.w	d2
	beq.s	+
	addi.b	#$10,d3
	move.b	d3,d0
	move.w	d0,(a2)
+
	addq.w	#2,a2
	dbf	d5,--

	rts
; End of function sub_86F6

; ===========================================================================
dword_8732:
	dc.l 100000
	dc.l  10000
	dc.l   1000
	dc.l    100
	dc.l     10
	dc.l      1

	; set the character set for menu text
	charset '@',"\27\30\31\32\33\34\35\36\37\38\39\40\41\42\43\44\45\46\47\48\49\50\51\52\53\54\55"
	charset '0',"\16\17\18\19\20\21\22\23\24\25"
	charset '*',$1A
	charset ':',$1C
	charset '.',$1D
	charset ' ',0

	; Menu text
Text2P_EmeraldHill:	menutxt	"EMERALD HILL"	; byte_874A:
Text2P_MysticCave:	menutxt	" MYSTIC CAVE"	; byte_8757:
Text2P_CasinoNight:	menutxt	"CASINO NIGHT"	; byte_8764:
Text2P_SpecialStage:	menutxt	"SPECIAL STAGE"	; byte_8771:
Text2P_Special:		menutxt	"   SPECIAL  "	; byte_877F:
Text2P_Zone:		menutxt	"ZONE "		; byte_878C:
Text2P_Stage:		menutxt	"STAGE"		; byte_8792:
Text2P_GameOver:	menutxt	"GAME OVER"	; byte_8798:
Text2P_TimeOver:	menutxt	"TIME OVER"
Text2P_NoGame:		menutxt	"NO GAME"	; byte_87AC:
Text2P_Tied:		menutxt	"TIED"		; byte_87B4:
Text2P_1P:		menutxt	" 1P"		; byte_87B9:
Text2P_2P:		menutxt	" 2P"		; byte_87BD:
Text2P_Blank:		menutxt	"    "		; byte_87C1:

	charset ; reset character set
