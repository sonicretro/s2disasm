; ===========================================================================
; ----------------------------------------------------------------------------
; Object 5F - Start banner/"Ending controller" from Special Stage
; ----------------------------------------------------------------------------
; Sprite_70F0:
Obj5F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj5F_Index(pc,d0.w),d1
	jmp	Obj5F_Index(pc,d1.w)
; ===========================================================================
; off_70FE:
Obj5F_Index:	offsetTable
		offsetTableEntry.w Obj5F_Init	;  0
		offsetTableEntry.w Obj5F_Main	;  2
		offsetTableEntry.w loc_71B4	;  4
		offsetTableEntry.w loc_710A	;  6
		offsetTableEntry.w return_723E	;  8
		offsetTableEntry.w loc_7218	; $A
; ===========================================================================

loc_710A:
	moveq	#0,d0
	move.b	angle(a0),d0
	bsr.w	CalcSine
	muls.w	objoff_14(a0),d0
	muls.w	objoff_14(a0),d1
	asr.w	#8,d0
	asr.w	#8,d1
	add.w	d1,x_pos(a0)
	add.w	d0,y_pos(a0)
	cmpi.w	#0,x_pos(a0)
	blt.w	JmpTo_DeleteObject
	cmpi.w	#$100,x_pos(a0)
	bgt.w	JmpTo_DeleteObject
	cmpi.w	#0,y_pos(a0)
	blt.w	JmpTo_DeleteObject

    if removeJmpTos
JmpTo_DisplaySprite 
    endif

	jmpto	(DisplaySprite).l, JmpTo_DisplaySprite
; ===========================================================================

; loc_714A:
Obj5F_Init:
	tst.b	(SS_2p_Flag).w
	beq.s	+
	move.w	#8,d0
	jsrto	(Obj5A_PrintPhrase).l, JmpTo_Obj5A_PrintPhrase
+	move.w	#$80,x_pos(a0)
	move.w	#-$40,y_pos(a0)
	move.w	#$100,y_vel(a0)
	move.l	#Obj5F_MapUnc_7240,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialStart,0,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#1,priority(a0)
	move.b	#2,routine(a0)

; loc_718A:
Obj5F_Main:
	jsrto	(ObjectMove).l, JmpTo_ObjectMove
	cmpi.w	#$48,y_pos(a0)
	blt.w	JmpTo_DisplaySprite
	move.w	#0,y_vel(a0)
	move.w	#$48,y_pos(a0)
	move.b	#4,routine(a0)
	move.b	#$F,objoff_2A(a0)
	jmpto	(DisplaySprite).l, JmpTo_DisplaySprite
; ===========================================================================

loc_71B4:
	subi_.b	#1,objoff_2A(a0)
    if ~~removeJmpTos
	bne.w	JmpTo_DisplaySprite
    else
	bne.s	JmpTo_DisplaySprite
    endif
	moveq	#6,d6

; WARNING: the build script needs editing if you rename this label
word_728C_user: lea	(Obj5F_MapUnc_7240+$4C).l,a2 ; word_728C

	moveq	#2,d3
	move.w	#8,objoff_14(a0)
	move.b	#6,routine(a0)

-	bsr.w	SSSingleObjLoad
	bne.s	+
	moveq	#0,d0

	move.w	#bytesToLcnt(object_size),d1

-	move.l	(a0,d0.w),(a1,d0.w)
	addq.w	#4,d0
	dbf	d1,-
    if object_size&3
	move.w	(a0,d0.w),(a1,d0.w)
    endif

	move.b	d3,mapping_frame(a1)
	addq.w	#1,d3
	move.w	#-$28,d2
	move.w	8(a2),d1
	bsr.w	CalcAngle
	move.b	d0,angle(a1)
	lea	$A(a2),a2
+	dbf	d6,--

	move.b	#$A,routine(a0)
	move.w	#$1E,objoff_2A(a0)
	rts
; ===========================================================================

loc_7218:
	subi_.w	#1,objoff_2A(a0)
	bpl.s	+++	; rts
	tst.b	(SS_2p_Flag).w
	beq.s	+
	move.w	#$A,d0
	jsrto	(Obj5A_PrintPhrase).l, JmpTo_Obj5A_PrintPhrase
	bra.s	++
; ===========================================================================
+	jsrto	(Obj5A_CreateRingReqMessage).l, JmpTo_Obj5A_CreateRingReqMessage

+	st.b	(SpecialStage_Started).w
	jmpto	(DeleteObject).l, JmpTo_DeleteObject
; ===========================================================================

+	rts