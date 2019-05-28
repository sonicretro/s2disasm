; ===========================================================================
; ----------------------------------------------------------------------------
; Object 21 - Score/Rings/Time display (in 2P results)
; ----------------------------------------------------------------------------
; Sprite_80BE:
Obj21: ; (screen-space obj)
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj21_Index(pc,d0.w),d1
	jmp	Obj21_Index(pc,d1.w)
; ===========================================================================
; JmpTbl_80CC: Obj21_States:
Obj21_Index:	offsetTable
		offsetTableEntry.w Obj21_Init	; 0
		offsetTableEntry.w Obj21_Main	; 2
; ---------------------------------------------------------------------------
; word_80D0:
Obj21_PositionTable:
	;      x,    y
	dc.w $F0, $148
	dc.w $F0, $130
	dc.w $E0, $148
	dc.w $F0, $148
	dc.w $F0, $148
; ===========================================================================
; loc_80E4:
Obj21_Init:
	addq.b	#2,routine(a0) ; => Obj21_Main
	move.w	(Results_Screen_2P).w,d0
	add.w	d0,d0
	add.w	d0,d0
	move.l	Obj21_PositionTable(pc,d0.w),x_pixel(a0) ; and y_pixel(a0)
	move.l	#Obj21_MapUnc_8146,mappings(a0)
 	move.w	#make_art_tile(ArtTile_ArtNem_1P2PWins,0,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo2_Adjust2PArtPointer
	move.b	#0,render_flags(a0)
	move.b	#0,priority(a0)
	moveq	#2,d1
	move.b	(SS_Total_Won).w,d0	; d0 = SS_Total_Won_1P
	sub.b	(SS_Total_Won+1).w,d0	;    - SS_Total_Won_2P
	beq.s	++
	bcs.s	+
	moveq	#0,d1
	bra.s	++
; ---------------------------------------------------------------------------
+
	moveq	#1,d1
+
	move.b	d1,mapping_frame(a0)

; loc_812C:
Obj21_Main:
	andi.w	#tile_mask,art_tile(a0)
	btst	#3,(Vint_runcount+3).w
	beq.s	JmpTo4_DisplaySprite
	ori.w	#palette_line_1,art_tile(a0)