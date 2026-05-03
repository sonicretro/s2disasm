; ----------------------------------------------------------------------------
; Object 5A - Messages/checkpoint from Special Stage
; ----------------------------------------------------------------------------
; Sprite_35554:
Obj5A:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj5A_Index(pc,d0.w),d1
	jmp	Obj5A_Index(pc,d1.w)
; ===========================================================================
; off_35562:
Obj5A_Index:	offsetTable
		offsetTableEntry.w Obj5A_Init               ;   0
		offsetTableEntry.w Obj5A_CheckpointRainbow  ;   2
		offsetTableEntry.w Obj5A_TextFlyoutInit     ;   4
		offsetTableEntry.w Obj5A_Handshake          ;   6
		offsetTableEntry.w Obj5A_TextFlyout         ;   8
		offsetTableEntry.w Obj5A_MostRingsWin       ;  $A
		offsetTableEntry.w Obj5A_RingCheckTrigger   ;  $C
		offsetTableEntry.w Obj5A_RingsNeeded        ;  $E
		offsetTableEntry.w Obj5A_FlashMessage       ; $10
		offsetTableEntry.w Obj5A_MoveAndFlash       ; $12
		offsetTableEntry.w Obj5A_FlashOnly          ; $14
; ===========================================================================
; loc_35578:
Obj5A_Init:
	tst.b	(SS_NoCheckpoint_flag).w
	bne.s	Obj5A_RingsMessageInit
	movea.l	(SSTrack_last_mappings_copy).w,a1
	cmpa.l	#MapSpec_Straight4,a1
	blt.s	++		; rts
	cmpa.l	#MapSpec_Drop1,a1
	bge.s	++		; rts
	moveq	#6,d0
	bsr.s	SSRainbowPaletteColors
	st.b	(SS_Checkpoint_Rainbow_flag).w
	moveq	#6,d0
-
	jsrto	JmpTo2_SSAllocateObject
	bne.s	+
	move.b	#ObjID_SSMessage,id(a1) ; load obj5A
	move.b	#2,routine(a1)	; => Obj5A_CheckpointRainbow
	move.l	#Obj5A_Obj5B_Obj60_MapUnc_3632A,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialRings,3,0),art_tile(a1)
	move.b	#1<<render_flags.level_fg,render_flags(a1)
	move.b	#5,priority(a1)
	move.b	d0,objoff_2A(a1)
	move.w	#0,objoff_30(a1)
	move.b	#-1,mapping_frame(a1)
+	dbf	d0,-

	jmpto	JmpTo63_DeleteObject
; ===========================================================================
+
	rts
; ===========================================================================
;loc_355E0
Obj5A_RingsMessageInit:
	sf.b	(SS_NoCheckpoint_flag).w
	tst.b	(SS_2p_Flag).w
	bne.w	JmpTo63_DeleteObject
	sf.b	(SS_HideRingsToGo).w
	sf.b	(SS_TriggerRingsToGo).w
	move.w	#0,(SS_NoRingsTogoLifetime).w
	move.b	#0,objoff_3A(a0)
	jmpto	JmpTo63_DeleteObject
; ===========================================================================
 ; temporarily remap characters to title card letter format
 ; Characters are encoded as Aa, Bb, Cc, etc. through a macro
 charset 'a','z','A'	; Convert to uppercase
 charset 'A',"\xD\x11\7\x11\1\x11"
 charset 'G',0	; can't have an embedded 0 in a string
 charset 'H',"\xB\4\x11\x11\9\xF\5\8\xC\x11\3\6\2\xA\x11\x10\x11\xE\x11"
 charset '!',"\x11"
 charset '.',"\x12"

specialText macro letters
	dc.b letters
	dc.b $FF	; output string terminator
    endm

Obj5A_RingsToGoText:
	specialText "RING"
	specialText "!OGOT"
	specialText "S"
	even

Obj5A_ToGoOffsets:
	dc.w   $C0	; 0
	dc.w   $B8	; 1
	dc.w   $B0	; 2
	dc.w   $A0	; 3
	dc.w   $98	; 4
	dc.w   $88	; 5

 charset ; revert character set

; ===========================================================================
;loc_3561E
Obj5A_CreateRingsToGoText:
	st.b	(SS_TriggerRingsToGo).w
	jsrto	JmpTo2_SSAllocateObject
	bne.w	return_356E4
	move.l	#Obj5F_MapUnc_72D2,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialHUD,2,0),art_tile(a1)
	move.b	#ObjID_SSMessage,id(a1) ; load obj5A
	move.b	#1<<render_flags.level_fg,render_flags(a1)
    if ~~fixBugs
	; Multi-sprite objects cannot use the 'priority' SST as it is
	; overwritten by 'sub3_y_pos'.
	move.b	#1,priority(a1)
    endif
	bset	#render_flags.multi_sprite,render_flags(a1)
	move.b	#0,mainspr_childsprites(a1)
	move.b	#$E,routine(a1)	; => Obj5A_RingsNeeded
	lea	subspr_data(a1),a2
	move.w	#$5A,d1
	move.w	#$38,d2
	moveq	#0,d0
	moveq	#2,d3

-	move.w	d1,(a2)+	; sub?_x_pos
	move.w	d2,(a2)+	; sub?_y_pos
	move.w	d0,(a2)+	; sub?_mapframe
	subq.w	#8,d1
	dbf	d3,-
	lea	Obj5A_RingsToGoText(pc),a3
	move.w	#$68,d1
	move.w	#$38,d2

-	move.b	(a3)+,d0
	bmi.s	+
	jsrto	JmpTo2_SSAllocateObject
	bne.s	return_356E4
	bsr.s	Init_Obj5A
	move.b	#$10,routine(a1)
	move.w	d1,x_pos(a1)
	move.w	d2,y_pos(a1)
	move.b	d0,mapping_frame(a1)
	addq.w	#8,d1
	bra.s	-
; ===========================================================================
+
	lea	Obj5A_ToGoOffsets(pc),a2

-	move.b	(a3)+,d0
	bmi.s	+
	jsrto	JmpTo2_SSAllocateObject
	bne.s	return_356E4
	bsr.s	Init_Obj5A
	move.b	#$12,routine(a1)	; => Obj5A_MoveAndFlash
	move.w	(a2)+,objoff_2A(a1)
	move.w	d2,y_pos(a1)
	move.b	d0,mapping_frame(a1)
	bra.s	-
; ===========================================================================
+
	move.b	(a3)+,d0
	jsrto	JmpTo2_SSAllocateObject
	bne.s	return_356E4
	bsr.s	Init_Obj5A
	move.b	#$14,routine(a1)	; => Obj5A_FlashOnly
	move.w	(a2)+,x_pos(a1)
	move.w	d2,y_pos(a1)
	move.b	d0,mapping_frame(a1)

return_356E4:
	rts
; ===========================================================================
;loc_356E6
Init_Obj5A:
	move.b	#ObjID_SSMessage,id(a1) ; load obj5A
	move.l	#Obj5A_MapUnc_35E1E,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialMessages,2,0),art_tile(a1)
	move.b	#1<<render_flags.level_fg,render_flags(a1)
    if ~~fixBugs
	; Multi-sprite objects cannot use the 'priority' SST as it is
	; overwritten by 'sub3_y_pos'. This object doesn't use the
	; multi-sprite system, but it does share display code with one, so
	; this might as well be removed since it won't be used.
	move.b	#1,priority(a1)
    endif
	rts
; ===========================================================================
;loc_35706
Obj5A_RingsNeeded:
	move.b	(SS_TriggerRingsToGo).w,(SS_HideRingsToGo).w
	bne.s	+
	bsr.s	++
	bra.w	Obj5A_FlashMessage
; ===========================================================================
+
	rts
; ===========================================================================
+
	move.w	(Ring_count).w,d0
	cmpi.w	#1,(Player_mode).w
	blt.s	+
	beq.s	++
	move.w	(Ring_count_2P).w,d0
	bra.s	++
; ===========================================================================
+
	add.w	(Ring_count_2P).w,d0
+
	sub.w	(SS_Ring_Requirement).w,d0
	neg.w	d0
	bgt.s	+
	moveq	#0,d0
	moveq	#1,d2
	addi_.w	#1,(SS_NoRingsTogoLifetime).w
	cmpi.w	#$C,(SS_NoRingsTogoLifetime).w
	blo.s	loc_3577A
	st.b	(SS_HideRingsToGo).w
	bra.s	loc_3577A
; ===========================================================================
+
	; This code converts the remaining rings into binary coded decimal format.
	moveq	#0,d1
	move.w	d0,d1
	moveq	#0,d0
	cmpi.w	#100,d1
	blt.s	+
    if fixBugs
	; The following code does a more complete binary coded decimal conversion:
-	addi.w	#$100,d0
	subi.w	#100,d1
	cmpi.w	#100,d1
	bge.s	-
    else
	; This code (the original) breaks when 101+ rings are needed:
-	addi.w	#$100,d0
	subi.w	#100,d1
	bgt.s	-
    endif
+
	divu.w	#10,d1
	lsl.w	#4,d1
	or.b	d1,d0
	swap	d1
	or.b	d1,d0
	move.w	#0,(SS_NoRingsTogoLifetime).w
	sf.b	(SS_HideRingsToGo).w

loc_3577A:
	moveq	#1,d2
	lea	subspr_data(a0),a1
	move.w	d0,(SS_RingsToGoBCD).w
	move.w	d0,d1
	andi.w	#$F,d1
	move.b	d1,sub2_mapframe-sub2_x_pos(a1)
	lsr.w	#4,d0
	beq.s	+
	addq.w	#1,d2
	move.w	d0,d1
	andi.w	#$F,d1
	move.b	d1,sub3_mapframe-sub2_x_pos(a1)
	lsr.w	#4,d0
	beq.s	+
	addq.w	#1,d2
	andi.w	#$F,d0
	move.b	d0,sub4_mapframe-sub2_x_pos(a1)
+
	move.b	d2,mainspr_childsprites(a0)
	rts
; ===========================================================================
;loc_357B2
Obj5A_FlashMessage:
	tst.b	(SS_NoCheckpointMsg_flag).w
	bne.w	+		; rts
	tst.b	(SS_HideRingsToGo).w
	bne.s	+		; rts
	move.b	(Vint_runcount+3).w,d0
	andi.b	#7,d0
	cmpi.b	#6,d0
    if fixBugs
	; Multi-sprite objects cannot use the 'priority' SST value, so they
	; must use 'DisplaySprite3' instead of 'DisplaySprite'.
	; This object's 'priority' is overwritten by 'sub3_y_pos', causing it
	; to display on the wrong layer.
	bhs.s	+
	move.w	#object_display_list_size*1,d0
	jmp	(DisplaySprite3).l
    else
	blo.w	JmpTo44_DisplaySprite
    endif
+
	rts
; ===========================================================================
;loc_357D2
Obj5A_MoveAndFlash:
	moveq	#0,d0
	cmpi.w	#2,(SS_RingsToGoBCD).w
	bhs.s	+
	moveq	#-8,d0
+
	add.w	objoff_2A(a0),d0
	move.w	d0,x_pos(a0)
	bra.s	Obj5A_FlashMessage
; ===========================================================================
;loc_357E8
Obj5A_FlashOnly:
	moveq	#0,d0
	cmpi.w	#2,(SS_RingsToGoBCD).w
	bhs.s	Obj5A_FlashMessage
	rts
; ===========================================================================
Obj5A_Rainbow_Frames:
	dc.b   0
	dc.b   1	; 1
	dc.b   1	; 2
	dc.b   1	; 3
	dc.b   2	; 4
	dc.b   4	; 5
	dc.b   6	; 6
	dc.b   8	; 7
	dc.b   9	; 8
	dc.b $FF	; 9
	even
; ===========================================================================
;loc_357FE
Obj5A_CheckpointRainbow:
	cmpi.b	#4,(SSTrack_drawing_index).w
	bne.s	+
	move.w	objoff_2C(a0),d0
	move.b	Obj5A_Rainbow_Frames(pc,d0.w),mapping_frame(a0)
	bmi.w	++
	addi_.w	#1,objoff_2C(a0)
	moveq	#0,d0
	move.b	objoff_2A(a0),d0
	add.w	d0,d0
	add.w	objoff_30(a0),d0
	move.b	Obj5A_Rainbow_Positions(pc,d0.w),1+x_pos(a0)
	move.b	Obj5A_Rainbow_Positions+1(pc,d0.w),1+y_pos(a0)
	addi.w	#$E,objoff_30(a0)
	jmpto	JmpTo44_DisplaySprite
; ===========================================================================
+
	tst.b	mapping_frame(a0)
	bpl.w	JmpTo44_DisplaySprite
	rts
; ===========================================================================
Obj5A_Rainbow_Positions:
	;      x,  y
	dc.b $F6,$F6
	dc.b $70,$5E	; 2
	dc.b $76,$58	; 4
	dc.b $7E,$56	; 6
	dc.b $88,$58	; 8
	dc.b $8E,$5E	; 10
	dc.b $F6,$F6	; 12
	dc.b $F6,$F6	; 14
	dc.b $6D,$5A	; 16
	dc.b $74,$54	; 18
	dc.b $7E,$50	; 20
	dc.b $8A,$54	; 22
	dc.b $92,$5A	; 24
	dc.b $F6,$F6	; 26
	dc.b $F6,$F6	; 28
	dc.b $6A,$58	; 30
	dc.b $72,$50	; 32
	dc.b $7E,$4C	; 34
	dc.b $8C,$50	; 36
	dc.b $94,$58	; 38
	dc.b $F6,$F6	; 40
	dc.b $F6,$F6	; 42
	dc.b $68,$56	; 44
	dc.b $70,$4C	; 46
	dc.b $7E,$48	; 48
	dc.b $8E,$4C	; 50
	dc.b $96,$56	; 52
	dc.b $F6,$F6	; 54
	dc.b $62,$5E	; 56
	dc.b $66,$50	; 58
	dc.b $70,$46	; 60
	dc.b $7E,$42	; 62
	dc.b $8E,$46	; 64
	dc.b $98,$50	; 66
	dc.b $9C,$5E	; 68
	dc.b $5C,$5A	; 70
	dc.b $62,$4A	; 72
	dc.b $70,$3E	; 74
	dc.b $7E,$38	; 76
	dc.b $8E,$3E	; 78
	dc.b $9C,$4A	; 80
	dc.b $A2,$5A	; 82
	dc.b $54,$54	; 84
	dc.b $5A,$3E	; 86
	dc.b $6A,$30	; 88
	dc.b $7E,$2A	; 90
	dc.b $94,$30	; 92
	dc.b $A4,$3E	; 94
	dc.b $AA,$54	; 96
	dc.b $42,$4A	; 98
	dc.b $4C,$28	; 100
	dc.b $62,$12	; 102
	dc.b $7E, $A	; 104
	dc.b $9C,$12	; 106
	dc.b $B2,$28	; 108
	dc.b $BC,$4A	; 110
	dc.b $16,$26	; 112
	dc.b $28,$FC	; 114
	dc.b $EC,$EC	; 116
	dc.b $EC,$EC	; 118
	dc.b $EC,$EC	; 120
	dc.b $D6,$FC	; 122
	dc.b $E8,$26	; 124
; ===========================================================================
+
	cmpi.w	#$E8,x_pos(a0)
	bne.w	JmpTo63_DeleteObject
	moveq	#0,d0
	bsr.w	SSRainbowPaletteColors
	sf.b	(SS_Checkpoint_Rainbow_flag).w
	st.b	(SS_NoCheckpointMsg_flag).w
	tst.b	(SS_2p_Flag).w			; Is it VS mode?
	beq.w	loc_35978					; Branch if not
	move.w	#SndID_Checkpoint,d0
	jsr	(PlaySound).l
	addi.b	#$10,(SS_2P_BCD_Score).w
	moveq	#0,d6
	addi_.b	#1,(Current_Special_Act).w
	move.w	#$C,d0
	move.w	(Ring_count).w,d2
	cmp.w	(Ring_count_2P).w,d2
	bgt.s	++
	beq.s	+++
	subi.b	#$10,(SS_2P_BCD_Score).w
	addi_.b	#1,(SS_2P_BCD_Score).w
	move.w	#$E,d0
	tst.b	(Graphics_Flags).w
	bpl.s	+
	move.w	#$14,d0
+
	move.w	#palette_line_1,d6
+
	move.w	#$80,d3
	bsr.w	Obj5A_CreateCheckpointWingedHand
	add.w	d6,art_tile(a1)
	add.w	d6,art_tile(a2)
	bsr.w	Obj5A_PrintPhrase
	jmpto	JmpTo63_DeleteObject
; ===========================================================================
+
	subi.b	#$10,(SS_2P_BCD_Score).w
	move.w	#$10,d0
	bsr.w	Obj5A_PrintPhrase
	cmpi.b	#3,(Current_Special_Act).w
	beq.s	+
	move.w	#$46,objoff_2A(a0)
	move.b	#$A,routine(a0)
	rts
; ===========================================================================
+
	bsr.w	Obj5A_VSReset
	move.w	#$46,objoff_2A(a0)
	move.b	#$C,routine(a0)
	rts
; ===========================================================================

loc_35978:
	move.w	#6,d1
	move.w	#SndID_Error,d0
	move.w	(Ring_count).w,d2
	add.w	(Ring_count_2P).w,d2
	cmp.w	(SS_Ring_Requirement).w,d2
	blt.s	+
	move.w	#4,d1
	move.w	#SndID_Checkpoint,d0
+
	jsr	(PlaySound).l
	move.w	d1,d0
	bsr.w	Obj5A_PrintCheckpointMessage
	jmpto	JmpTo63_DeleteObject
; ===========================================================================
;loc_359A6
Obj5A_MostRingsWin:
	subi_.w	#1,objoff_2A(a0)
	beq.s	+
	rts
; ===========================================================================
+
	move.w	#$A,d0			; MOST RINGS WINS
	bsr.w	Obj5A_PrintPhrase
	jmpto	JmpTo63_DeleteObject
; ===========================================================================
;loc_359BC
Obj5A_RingCheckTrigger:
	subi_.w	#1,objoff_2A(a0)
	beq.s	+
	rts
; ===========================================================================
+
	st.b	(SS_Check_Rings_flag).w
	bra.w	SSClearObjs
; ===========================================================================
;loc_359CE
Obj5A_Handshake:
	cmpi.b	#$15,mapping_frame(a0)		; Is this the hand?
	bne.s	++							; if not, branch
	move.w	objoff_30(a0),d0			; Target y position for handshake
	tst.b	objoff_2E(a0)
	bne.s	+
	subi_.w	#1,y_pos(a0)
	subi_.w	#4,d0
	cmp.w	y_pos(a0),d0
	blt.s	++
	addi_.w	#1,d0
	move.w	d0,y_pos(a0)
	st.b	objoff_2E(a0)
	bra.s	++
; ===========================================================================
+
	addi_.w	#1,y_pos(a0)
	addi_.w	#4,d0
	cmp.w	y_pos(a0),d0
	bgt.s	+
	subi_.w	#1,d0
	move.w	d0,y_pos(a0)
	sf.b	objoff_2E(a0)
+
	subi_.w	#1,objoff_2A(a0)
	bne.w	JmpTo44_DisplaySprite
	tst.b	objoff_2F(a0)
	beq.s	+
-
	move.w	#MusID_FadeOut,d0
	jsr	(PlayMusic).l
	move.w	#$30,objoff_2A(a0)
	move.b	#$C,routine(a0)	; => Obj5A_RingCheckTrigger
	rts
; ===========================================================================
+
	cmpi.b	#$15,mapping_frame(a0)		; Is this the hand?
	bne.w	JmpTo63_DeleteObject		; Branch if not
	tst.w	objoff_30(a0)
	beq.w	JmpTo63_DeleteObject
	tst.b	(SS_2p_Flag).w			; Is this VS mode?
	beq.s	+							; Branch if not
	bsr.w	Obj5A_VSReset
	cmpi.b	#3,(Current_Special_Act).w
	beq.s	-
	move.w	#$A,d0
	bsr.w	Obj5A_PrintPhrase
	jmpto	JmpTo63_DeleteObject
; ===========================================================================
+
	bsr.w	Obj5A_CreateRingReqMessage
	jmpto	JmpTo63_DeleteObject
; ===========================================================================
;loc_35A7A
Obj5A_VSReset:
	lea	(SS2p_RingBuffer).w,a3
	moveq	#0,d0
	move.b	(Current_Special_Act).w,d0
	subq.w	#1,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	(Ring_count).w,(a3,d0.w)
	move.w	(Ring_count_2P).w,2(a3,d0.w)
	move.w	#0,(Ring_count).w
	move.w	#0,(Ring_count_2P).w
	moveq	#0,d0
	move.w	d0,(MainCharacter+ss_rings_base).w
	move.b	d0,(MainCharacter+ss_rings_units).w
	move.w	d0,(Sidekick+ss_rings_base).w
	move.b	d0,(Sidekick+ss_rings_units).w
	rts
; ===========================================================================
;loc_35AB6
Obj5A_CreateCheckpointWingedHand:
	move.w	#$48,d4
	tst.b	(SS_2p_Flag).w		; Is this VS mode?
	beq.s	+						; Branch if not
	move.w	#$1C,d4
+
	jsrto	JmpTo2_SSAllocateObject
	bne.w	+		; rts
	move.b	#ObjID_SSMessage,id(a1) ; load obj5A
	move.b	#6,routine(a1)	; => Obj5A_Handshake
	move.l	#Obj5A_MapUnc_35E1E,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialMessages,1,0),art_tile(a1)
	move.b	#1<<render_flags.level_fg,render_flags(a1)
	move.b	#1,priority(a1)
	move.w	d3,x_pos(a1)
	move.w	d4,y_pos(a1)
	move.w	#$46,objoff_2A(a1)
	move.b	#$14,mapping_frame(a1)		; Checkpoint wings
	movea.l	a1,a2
	jsrto	JmpTo2_SSAllocateObject
	bne.s	+		; rts
	move.b	#ObjID_SSMessage,id(a1) ; load obj5A
	move.b	#6,routine(a1)	; => Obj5A_Handshake
	move.l	#Obj5A_MapUnc_35E1E,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialMessages,1,0),art_tile(a1)
	move.b	#1<<render_flags.level_fg,render_flags(a1)
	move.b	#0,priority(a1)
	move.w	d3,x_pos(a1)
	move.w	d4,y_pos(a1)
	move.w	d4,objoff_30(a1)			; Target y position for handshake
	move.w	#$46,objoff_2A(a1)
	move.b	#$15,mapping_frame(a1)		; Checkpoint hand
	cmpi.w	#6,d0						; Does player have enough rings?
	bne.s	+							; If yes, return
	st.b	objoff_2F(a1)				; Flag for failed checkpoint
	bset	#render_flags.y_flip,render_flags(a1)			; Point thumb down
+
	rts
; ===========================================================================
;loc_35B5A
Obj5A_TextFlyoutInit:
	subi_.w	#1,objoff_2A(a0)
	bne.w	JmpTo44_DisplaySprite
	cmpi.b	#$13,mapping_frame(a0)		; Is this the hand or wings?
	bgt.w	JmpTo63_DeleteObject		; If yes, branch
	move.b	#8,routine(a0)			; Obj5A_TextFlyout
	move.w	#8,objoff_14(a0)
	move.w	x_pos(a0),d1
	subi.w	#$80,d1
	move.w	y_pos(a0),d2
	subi.w	#$70,d2
	jsrto	JmpTo_CalcAngle
	move.b	d0,angle(a0)
	jmpto	JmpTo44_DisplaySprite
; ===========================================================================
; this makes special stage messages like "most rings wins!" fly off the screen
;loc_35B96
Obj5A_TextFlyout:
	moveq	#0,d0
	move.b	angle(a0),d0
	jsrto	JmpTo14_CalcSine
	muls.w	objoff_14(a0),d0
	muls.w	objoff_14(a0),d1
	asr.w	#8,d0
	asr.w	#8,d1
	add.w	d1,x_pos(a0)
	add.w	d0,y_pos(a0)
	cmpi.w	#0,x_pos(a0)
	blt.w	JmpTo63_DeleteObject
	cmpi.w	#$100,x_pos(a0)
	bgt.w	JmpTo63_DeleteObject
	cmpi.w	#0,y_pos(a0)
	blt.w	JmpTo63_DeleteObject
	jmpto	JmpTo44_DisplaySprite
; ===========================================================================
;loc_35BD6
Obj5A_PrintNumber:
	jsrto	JmpTo_SSAllocateObjectAfterCurrent
	bne.s	+		; rts
	move.b	d0,mapping_frame(a1)
	move.l	#Obj5F_MapUnc_72D2,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialHUD,2,0),art_tile(a1)
	move.b	#ObjID_SSMessage,id(a1) ; load obj5A
	move.b	#4,routine(a1)			; Obj5A_TextFlyoutInit
	move.b	#1<<render_flags.level_fg,render_flags(a1)
	move.b	#1,priority(a1)
	move.w	d1,x_pos(a1)
	move.w	d2,y_pos(a1)
	move.w	#$46,objoff_2A(a1)
+
	rts
; ===========================================================================
; Subroutine to draw checkpoint or message text
; d0 = text ID
; d1 = x position of first letter
; d2 = y position
;loc_35C14
Obj5A_PrintWord:
	lea	SSMessage_TextFrames(pc),a3
	adda.w	(a3,d0.w),a3

-	move.b	(a3)+,d0
	bmi.s	+		; rts
	jsrto	JmpTo_SSAllocateObjectAfterCurrent
	bne.s	+		; rts
	move.b	d0,mapping_frame(a1)
	move.l	#Obj5A_MapUnc_35E1E,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialMessages,2,0),art_tile(a1)
	move.b	#ObjID_SSMessage,id(a1) ; load obj5A
	move.b	#4,routine(a1)			; Obj5A_TextFlyoutInit
	move.b	#1<<render_flags.level_fg,render_flags(a1)
	move.b	#1,priority(a1)
	move.w	d1,x_pos(a1)
	move.w	d2,y_pos(a1)
	move.w	#$46,objoff_2A(a1)
	addq.w	#8,d1
	bra.s	-
; ===========================================================================
+
	rts
; ===========================================================================
 ; temporarily remap characters to title card letter format
 ; Characters are encoded as Aa, Bb, Cc, etc. through a macro
 charset 'a','z','A'	; Convert to uppercase
 charset 'A',"\xD\x11\7\x11\1\x11"
 charset 'G',0	; can't have an embedded 0 in a string
 charset 'H',"\xB\4\x11\x11\9\xF\5\8\xC\x11\3\6\2\xA\x11\x10\x11\xE\x11"
 charset '!',"\x11"
 charset '.',"\x12"

; Text words
;off_35C62
SSMessage_TextFrames:	offsetTable
		offsetTableEntry.w byte_35C86	;  0
		offsetTableEntry.w byte_35C8A	;  2
		offsetTableEntry.w byte_35C90	;  4
		offsetTableEntry.w byte_35C96	;  6
		offsetTableEntry.w byte_35C9A	;  8
		offsetTableEntry.w byte_35CA1	; $A
		offsetTableEntry.w byte_35CA8	; $C
		offsetTableEntry.w byte_35CAD	; $E
		offsetTableEntry.w byte_35CB3	;$10
		offsetTableEntry.w byte_35CB9	;$12
		offsetTableEntry.w byte_35CBF	;$14
		offsetTableEntry.w byte_35CC4	;$16
		offsetTableEntry.w byte_35CC8	;$18
		offsetTableEntry.w byte_35CCE	;$1A
		offsetTableEntry.w byte_35CD3	;$1C
		offsetTableEntry.w byte_35CD5	;$1E
		offsetTableEntry.w byte_35CD9	;$20
		offsetTableEntry.w byte_35CDB	;$22
byte_35C86:	specialText "GET"
	rev02even
byte_35C8A:	specialText "RINGS"
	rev02even
byte_35C90:	specialText "COOL!"
	rev02even
byte_35C96:	specialText "NOT"
	rev02even
byte_35C9A:	specialText "ENOUGH"
	rev02even
byte_35CA1:	specialText "PLAYER"
	rev02even
byte_35CA8:	specialText "MOST"
	rev02even
byte_35CAD:	specialText "WINS!"
	rev02even
byte_35CB3:	specialText "SONIC"
	rev02even
byte_35CB9:	specialText "MILES"
	rev02even
byte_35CBF:	specialText "TIE!"
	rev02even
byte_35CC4:	specialText "WIN"
	rev02even
byte_35CC8:	specialText "TWICE"
	rev02even
byte_35CCE:	specialText "ALL!"
	rev02even
byte_35CD3:	specialText "!"
	rev02even
byte_35CD5:	specialText "..."
	rev02even
byte_35CD9:	dc.b $13,$FF						; VS
	rev02even
byte_35CDB:	specialText "TAILS"
	even

 charset ; revert character set

; ===========================================================================
;loc_35CE2
Obj5A_CreateRingReqMessage:
	moveq	#0,d0				; GET
	move.w	#$54,d1				; x
	move.w	#$6C,d2				; y
	bsr.w	Obj5A_PrintWord
	jsrto	JmpTo_SSStartNewAct
	move.w	d1,d4				; Binary coded decimal ring requirements
	move.w	d2,d5				; Digit count - 1 (minumum 2 digits)
	movea.w	d2,a3				; Copy of above, but in a3.
	move.w	#$80,d1				; x position of least digit
	cmpi.w	#2,d2				; Do we need hundreds digit?
	beq.s	+					; if yes, branch
	subi_.w	#8,d1				; Otherwise, move digits to the left

+	move.w	#$6C,d2				; y position of digits

-	move.w	d4,d6				; Copy BCD reuirements
	lsr.w	#4,d4				; Next BCD digit
	andi.w	#$F,d6				; Extract least digit
	move.b	d6,d0
	swap	d5
	bsr.w	Obj5A_PrintNumber
	subi_.w	#8,d1				; Set position for next digit
	swap	d5
	dbf	d5,-

	moveq	#2,d0				; RINGS!
	lea	(SSMessage_TextPhrases).l,a2
	adda.w	(a2,d0.w),a2
	move.w	#$6C,d2				; y
	move.w	#$84,d1				; x
	cmpa.w	#2,a3				; Do we need space for hundreds digit?
	bne.s	+					; Branch if not
	addi_.w	#8,d1				; Move digits to right

/	moveq	#0,d0
	move.b	(a2)+,d0
	bmi.s	+
	bsr.w	Obj5A_PrintWord
	bra.s	-
; ===========================================================================
+
	rts
; ===========================================================================
;loc_35D52
Obj5A_PrintCheckpointMessage:
	move.w	#$80,d3				; x
	bsr.w	Obj5A_CreateCheckpointWingedHand
	cmpi.w	#1,(Player_mode).w
	ble.s	loc_35D6E
	addi.w	#palette_line_1,art_tile(a1)
	addi.w	#palette_line_1,art_tile(a2)

loc_35D6E:
	move.w	#$74,d1				; x
	move.w	#$68,d2				; y
	lea	(SSMessage_TextPhrases).l,a2
	adda.w	(a2,d0.w),a2		; Fetch phrase
	cmpi.b	#4,d0				; Is it 'COOL!'?
	beq.s	+					; Branch if yes
	move.w	#$5E,d1				; Move text otherwise

/	moveq	#0,d0
	move.b	(a2)+,d0
	bmi.s	++			; rts
	cmpi.b	#2,d0
	bne.s	+
	move.w	#$5E,d1				; x
	move.w	#$7E,d2				; y
+
	bsr.w	Obj5A_PrintWord
	addi_.w	#8,d1
	bra.s	-
; ===========================================================================
+
	rts
; ===========================================================================
;loc_35DAA
Obj5A_PrintPhrase:
	move.w	d0,d3
	subq.w	#8,d3
	lsr.w	#1,d3
	moveq	#0,d1
	move.b	byte_35DD6(pc,d3.w),d1
	move.w	#$48,d2
	lea	(SSMessage_TextPhrases).l,a2
	adda.w	(a2,d0.w),a2

-	moveq	#0,d0
	move.b	(a2)+,d0
	bmi.s	+			; rts
	bsr.w	Obj5A_PrintWord
	addi_.w	#8,d1
	bra.s	-
; ===========================================================================
+
	rts
; ===========================================================================
byte_35DD6:
	dc.b $48
	dc.b $44	; 1
	dc.b $58	; 2
	dc.b $58	; 3
	dc.b $74	; 4
	dc.b $3C	; 5
	dc.b $58	; 6
	even

; Text phrases
;off_35DDE
SSMessage_TextPhrases:	offsetTable
		offsetTableEntry.w byte_35DF6	;  0
		offsetTableEntry.w byte_35DF7	;  2
		offsetTableEntry.w byte_35DFA	;  4
		offsetTableEntry.w byte_35DFC	;  6
		offsetTableEntry.w byte_35E01	;  8
		offsetTableEntry.w byte_35E05	; $A
		offsetTableEntry.w byte_35E09	; $C
		offsetTableEntry.w byte_35E0C	; $E
		offsetTableEntry.w byte_35E0F	;$10
		offsetTableEntry.w byte_35E11	;$12
		offsetTableEntry.w byte_35E16	;$14
		offsetTableEntry.w byte_35E19	;$16
byte_35DF6:	dc.b $FF					; (empty)
byte_35DF7:	dc.b   2,$1C,$FF			; RINGS!
byte_35DFA:	dc.b   4,$FF				; COOL!
byte_35DFC:	dc.b   6,  8,  2,$1E,$FF	; NOT ENOUGH RINGS...
byte_35E01:	dc.b  $A,$20, $A,$FF		; PLAYER VS PLAYER
byte_35E05:	dc.b  $C,  2, $E,$FF		; MOST RINGS WINS
byte_35E09:	dc.b $10, $E,$FF			; SONIC WINS
byte_35E0C:	dc.b $12, $E,$FF			; MILES WINS
byte_35E0F:	dc.b $14,$FF				; TIE!
byte_35E11:	dc.b $16,$18,$16,$1A,$FF	; WIN TWICE WIN ALL!
byte_35E16:	dc.b $22, $E,$FF			; TAILS WINS
byte_35E19:	dc.b   2,$24,$26,$1C,$FF	; RINGS ?? ?? !
	even
