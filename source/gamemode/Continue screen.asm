; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Game Mode: Continue screen
; Objects: DA, DB

; ----------------------------------------------------------------------------
; loc_7870:
ContinueScreen:
	bsr.w	Pal_FadeToBlack
	move	#$2700,sr
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l
	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	bsr.w	ClearScreen

	clearRAM ContScr_Object_RAM,ContScr_Object_RAM_End

	bsr.w	ContinueScreen_LoadLetters
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_ContinueTails),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_ContinueTails).l,a0
	bsr.w	NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_MiniContinue),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_MiniSonic).l,a0
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	lea	(ArtNem_MiniTails).l,a0
+
	bsr.w	NemDec
	moveq	#$A,d1
	jsr	(ContScrCounter).l
	moveq	#PalID_SS1,d0
	bsr.w	PalLoad_ForFade
	move.w	#0,(Target_palette).w
	move.b	#MusID_Continue,d0
	bsr.w	PlayMusic
	move.w	#(11*60)-1,(Demo_Time_left).w	; 11 seconds minus 1 frame
	clr.b	(Level_started_flag).w
	clr.l	(Camera_X_pos_copy).w
	move.l	#$1000000,(Camera_Y_pos_copy).w
	move.b	#ObjID_ContinueChars,(MainCharacter+id).w ; load ObjDB (sonic on continue screen)
	move.b	#ObjID_ContinueChars,(Sidekick+id).w ; load ObjDB (tails on continue screen)
	move.b	#6,(Sidekick+routine).w ; => ObjDB_Tails_Init
	move.b	#ObjID_ContinueText,(ContinueText+id).w ; load ObjDA (continue screen text)
	move.b	#ObjID_ContinueIcons,(ContinueIcons+id).w ; load ObjDA (continue icons)
	move.b	#4,(ContinueIcons+routine).w ; => loc_7AD0
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromBlack
-
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	cmpi.b	#4,(MainCharacter+routine).w
	bhs.s	+
	move	#$2700,sr
	move.w	(Demo_Time_left).w,d1
	divu.w	#60,d1
	andi.l	#$F,d1
	jsr	(ContScrCounter).l
	move	#$2300,sr
+
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	cmpi.w	#$180,(Sidekick+x_pos).w
	bhs.s	+
	cmpi.b	#4,(MainCharacter+routine).w
	bhs.s	-
	tst.w	(Demo_Time_left).w
	bne.w	-
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ---------------------------------------------------------------------------
+
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	move.b	#3,(Life_count).w
	move.b	#3,(Life_count_2P).w
	moveq	#0,d0
	move.w	d0,(Ring_count).w
	move.l	d0,(Timer).w
	move.l	d0,(Score).w
	move.b	d0,(Last_star_pole_hit).w
	move.w	d0,(Ring_count_2P).w
	move.l	d0,(Timer_2P).w
	move.l	d0,(Score_2P).w
	move.b	d0,(Last_star_pole_hit_2P).w
	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w
	subq.b	#1,(Continue_count).w
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_7A04:
ContinueScreen_LoadLetters:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_TitleCard),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_TitleCard).l,a0
	bsr.w	NemDec
	lea	(Level_Layout).w,a4
	lea	(ArtNem_TitleCard2).l,a0
	bsr.w	NemDecToRAM
	lea	(ContinueScreen_AdditionalLetters).l,a0
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ContinueScreen_Additional),VRAM,WRITE),(VDP_control_port).l
	lea	(Level_Layout).w,a1
	lea	(VDP_data_port).l,a6
-
	moveq	#0,d0
	move.b	(a0)+,d0
	bmi.s	+	; rts
	lsl.w	#5,d0
	lea	(a1,d0.w),a2
	moveq	#0,d1
	move.b	(a0)+,d1
	lsl.w	#3,d1
	subq.w	#1,d1

-	move.l	(a2)+,(a6)
	dbf	d1,-

	bra.s	--
; ---------------------------------------------------------------------------
+	rts
; End of function ContinueScreen_LoadLetters

; ===========================================================================

 ; temporarily remap characters to title card letter format
 ; Characters are encoded as Aa, Bb, Cc, etc. through a macro
 charset 'A',0	; can't have an embedded 0 in a string
 charset 'B',"\4\8\xC\4\x10\x14\x18\x1C\x1E\x22\x26\x2A\4\4\x30\x34\x38\x3C\x40\x44\x48\x4C\x52\x56\4"
 charset 'a',"\4\4\4\4\4\4\4\4\2\4\4\4\6\4\4\4\4\4\4\4\4\4\6\4\4"
 charset '.',"\x5A"

; Defines which letters load for the continue screen
; Each letter occurs only once, and  the letters ENOZ (i.e. ZONE) aren't loaded here
; However, this is hidden by the titleLetters macro, and normal titles can be used
; (the macro is defined near SpecialStage_ResultsLetters, which uses it before here)

; word_7A5E:
ContinueScreen_AdditionalLetters:
	titleLetters "CONTINUE"

 charset ; revert character set
; ===========================================================================
; ----------------------------------------------------------------------------
; Object DA - Continue text
; ----------------------------------------------------------------------------
; loc_7A68:
ObjDA: ; (screen-space obj)
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjDA_Index(pc,d0.w),d1
	jmp	ObjDA_Index(pc,d1.w)
; ===========================================================================
; Obj_DA_subtbl:
ObjDA_Index:	offsetTable
		offsetTableEntry.w ObjDA_Init		; 0
		offsetTableEntry.w JmpTo2_DisplaySprite	; 2
		offsetTableEntry.w loc_7AD0		; 4
		offsetTableEntry.w loc_7B46		; 6
; ===========================================================================
; loc_7A7E:
ObjDA_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjDA_MapUnc_7CB6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_ContinueText,0,1),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo_Adjust2PArtPointer
	move.b	#0,render_flags(a0)
	move.b	#$3C,width_pixels(a0)
	move.w	#$120,x_pixel(a0)
	move.w	#$C0,y_pixel(a0)

JmpTo2_DisplaySprite 
	jmp	(DisplaySprite).l
; ===========================================================================
; word_7AB2:
ObjDA_XPositions:
	dc.w  $116, $12A, $102,	$13E,  $EE, $152,  $DA,	$166
	dc.w   $C6, $17A,  $B2,	$18E,  $9E, $1A2,  $8A;	8
; ===========================================================================

loc_7AD0:
	movea.l	a0,a1
	lea_	ObjDA_XPositions,a2
	moveq	#0,d1
	move.b	(Continue_count).w,d1
	subq.b	#2,d1
	bcc.s	+
	jmp	(DeleteObject).l
; ===========================================================================
+
	moveq	#1,d3
	cmpi.b	#$E,d1
	blo.s	+
	moveq	#0,d3
	moveq	#$E,d1
+
	move.b	d1,d2
	andi.b	#1,d2

-	_move.b	#ObjID_ContinueIcons,id(a1) ; load objDA
	move.w	(a2)+,x_pixel(a1)
	tst.b	d2
	beq.s	+
	subi.w	#$A,x_pixel(a1)
+
	move.w	#$D0,y_pixel(a1)
	move.b	#4,mapping_frame(a1)
	move.b	#6,routine(a1)
	move.l	#ObjDA_MapUnc_7CB6,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_ContinueText_2,0,1),art_tile(a1)
	jsrto	(Adjust2PArtPointer2).l, JmpTo_Adjust2PArtPointer2
	move.b	#0,render_flags(a1)
	lea	next_object(a1),a1 ; load obj addr
	dbf	d1,-

	lea	-next_object(a1),a1 ; load obj addr
	move.b	d3,subtype(a1)

loc_7B46:
	tst.b	subtype(a0)
	beq.s	+
	cmpi.b	#4,(MainCharacter+routine).w
	blo.s	+
	move.b	(Vint_runcount+3).w,d0
	andi.b	#1,d0
	bne.s	+
	tst.w	(MainCharacter+x_vel).w
	bne.s	JmpTo2_DeleteObject
	rts
; ===========================================================================
+
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$F,d0
	bne.s	JmpTo3_DisplaySprite
	bchg	#0,mapping_frame(a0)

JmpTo3_DisplaySprite 
	jmp	(DisplaySprite).l
; ===========================================================================

JmpTo2_DeleteObject 
	jmp	(DeleteObject).l
; ===========================================================================
; ----------------------------------------------------------------------------
; Object DB - Sonic lying down or Tails nagging (on the continue screen)
; ----------------------------------------------------------------------------
; Sprite_7B82:
ObjDB:
	; a0=character
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjDB_Index(pc,d0.w),d1
	jsr	ObjDB_Index(pc,d1.w)
	jmp	(DisplaySprite).l
; ===========================================================================
; off_7B96: ObjDB_States:
ObjDB_Index:	offsetTable
		offsetTableEntry.w ObjDB_Sonic_Init	;  0
		offsetTableEntry.w ObjDB_Sonic_Wait	;  2
		offsetTableEntry.w ObjDB_Sonic_Run	;  4
		offsetTableEntry.w ObjDB_Tails_Init	;  6
		offsetTableEntry.w ObjDB_Tails_Wait	;  8
		offsetTableEntry.w ObjDB_Tails_Run	; $A
; ===========================================================================
; loc_7BA2:
ObjDB_Sonic_Init:
	addq.b	#2,routine(a0) ; => ObjDB_Sonic_Wait
	move.w	#$9C,x_pos(a0)
	move.w	#$19C,y_pos(a0)
	move.l	#Mapunc_Sonic,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtUnc_Sonic,0,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#2,priority(a0)
	move.b	#$20,anim(a0)

; loc_7BD2:
ObjDB_Sonic_Wait:
	tst.b	(Ctrl_1_Press).w	; is start pressed?
	bmi.s	ObjDB_Sonic_StartRunning ; if yes, branch
	jsr	(Sonic_Animate).l
	jmp	(LoadSonicDynPLC).l
; ---------------------------------------------------------------------------
; loc_7BE4:
ObjDB_Sonic_StartRunning:
	addq.b	#2,routine(a0) ; => ObjDB_Sonic_Run
	move.b	#$21,anim(a0)
	clr.w	inertia(a0)
	move.b	#SndID_SpindashRev,d0 ; super peel-out sound
	bsr.w	PlaySound

; loc_7BFA:
ObjDB_Sonic_Run:
	cmpi.w	#$800,inertia(a0)
	bne.s	+
	move.w	#$1000,x_vel(a0)
	bra.s	++
; ---------------------------------------------------------------------------
+
	addi.w	#$20,inertia(a0)
+
	jsr	(ObjectMove).l
	jsr	(Sonic_Animate).l
	jmp	(LoadSonicDynPLC).l
; ===========================================================================
; loc_7C22:
ObjDB_Tails_Init:
	addq.b	#2,routine(a0) ; => ObjDB_Tails_Wait
	move.w	#$B8,x_pos(a0)
	move.w	#$1A0,y_pos(a0)
	move.l	#ObjDA_MapUnc_7CB6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_ContinueTails,0,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#2,priority(a0)
	move.b	#0,anim(a0)

; loc_7C52:
ObjDB_Tails_Wait:
	tst.b	(Ctrl_1_Press).w	; is start pressed?
	bmi.s	ObjDB_Tails_StartRunning ; if yes, branch
	lea	(Ani_objDB).l,a1
	jmp	(AnimateSprite).l
; ---------------------------------------------------------------------------
; loc_7C64:
ObjDB_Tails_StartRunning:
	addq.b	#2,routine(a0) ; => ObjDB_Tails_Run
	move.l	#MapUnc_Tails,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtUnc_Tails,0,0),art_tile(a0)
	move.b	#0,anim(a0)
	clr.w	inertia(a0)
	move.b	#SndID_SpindashRev,d0 ; super peel-out sound
	bsr.w	PlaySound

; loc_7C88:
ObjDB_Tails_Run:
	cmpi.w	#$720,inertia(a0)
	bne.s	+
	move.w	#$1000,x_vel(a0)
	bra.s	++
; ---------------------------------------------------------------------------
+
	addi.w	#$18,inertia(a0)
+
	jsr	(ObjectMove).l
	jsr	(Tails_Animate).l
	jmp	(LoadTailsDynPLC).l
; ===========================================================================
; animation script for continue screen Tails nagging
; off_7CB0
Ani_objDB:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   9,  2,  3,$FF
	even
; -------------------------------------------------------------------------------
; Sprite mappings for text, countdown, stars, and Tails on the continue screen
; Art starts at $A000 in VRAM
; -------------------------------------------------------------------------------
ObjDA_MapUnc_7CB6:	BINCLUDE	"mappings/sprite/objDA.bin"

    if ~~removeJmpTos
JmpTo_Adjust2PArtPointer2 
	jmp	(Adjust2PArtPointer2).l
JmpTo_Adjust2PArtPointer 
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
