; ---------------------------------------------------------------------------
; Subroutine to load level boundaries and start locations
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_BFBC:
LevelSizeLoad:
	clr.w	(Scroll_flags).w
	clr.w	(Scroll_flags_BG).w
	clr.w	(Scroll_flags_BG2).w
	clr.w	(Scroll_flags_BG3).w
	clr.w	(Scroll_flags_P2).w
	clr.w	(Scroll_flags_BG_P2).w
	clr.w	(Scroll_flags_BG2_P2).w
	clr.w	(Scroll_flags_BG3_P2).w
	clr.w	(Scroll_flags_copy).w
	clr.w	(Scroll_flags_BG_copy).w
	clr.w	(Scroll_flags_BG2_copy).w
	clr.w	(Scroll_flags_BG3_copy).w
	clr.w	(Scroll_flags_copy_P2).w
	clr.w	(Scroll_flags_BG_copy_P2).w
	clr.w	(Scroll_flags_BG2_copy_P2).w
	clr.w	(Scroll_flags_BG3_copy_P2).w
	clr.b	(Deform_lock).w
	clr.b	(Screen_Shaking_Flag_HTZ).w
	clr.b	(Screen_Shaking_Flag).w
	clr.b	(Scroll_lock).w
	clr.b	(Scroll_lock_P2).w
	moveq	#0,d0
	move.b	d0,(Dynamic_Resize_Routine).w ; load level boundaries
    if gameRevision>=2
	move.w	d0,(WFZ_LevEvent_Subrout).w
	move.w	d0,(WFZ_BG_Y_Speed).w
	move.w	d0,(Camera_BG_X_offset).w
	move.w	d0,(Camera_BG_Y_offset).w
    endif
	move.w	(Current_ZoneAndAct).w,d0
	ror.b	#1,d0
	lsr.w	#4,d0
	lea	LevelSize(pc,d0.w),a0
	move.l	(a0)+,d0
	move.l	d0,(Camera_Min_X_pos).w		; Also sets Camera_Max_X_pos.
	move.l	d0,(Camera_Min_X_pos_target).w	; Also sets Camera_Max_X_pos_target.
	move.l	d0,(Tails_Min_X_pos).w		; Also sets Tails_Max_X_pos.
	move.l	(a0)+,d0
	move.l	d0,(Camera_Min_Y_pos).w		; Also sets Camera_Max_Y_pos.
	move.l	d0,(Camera_Min_Y_pos_target).w	; Also sets Camera_Max_Y_pos_target.
	move.l	d0,(Tails_Min_Y_pos).w		; Also sets Tails_Max_Y_pos.
	move.w	#$1010,(Horiz_block_crossed_flag).w
	move.w	#(screen_height/2)-16,(Camera_Y_pos_bias).w
	move.w	#(screen_height/2)-16,(Camera_Y_pos_bias_P2).w
	bra.w	+
; ===========================================================================
; ----------------------------------------------------------------------------
; LEVEL SIZE ARRAY

; This array defines the screen boundaries for each act in the game.
; ----------------------------------------------------------------------------
;				xstart	xend	ystart	yend	; ZID ; Zone
LevelSize: zoneOrderedTable 2,8	; WrdArr_LvlSize
	; EHZ
	zoneTableEntry.w	$0,	$29A0,	$0,	$320	; Act 1
	zoneTableEntry.w	$0,	$2940,	$0,	$420	; Act 2
	; Zone 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; WZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; Zone 3
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; MTZ
	zoneTableEntry.w	$0,	$2280,	-$100,	$800	; Act 1
	zoneTableEntry.w	$0,	$1E80,	-$100,	$800	; Act 2
	; MTZ
	zoneTableEntry.w	$0,	$2A80,	-$100,	$800	; Act 3
	zoneTableEntry.w	$0,	$3FFF,	-$100,	$800	; Act 4
	; WFZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; HTZ
	zoneTableEntry.w	$0,	$2800,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3280,	$0,	$720	; Act 2
	; HPZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; Zone 9
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
	; OOZ
	zoneTableEntry.w	$0,	$2F80,	$0,	$680	; Act 1
	zoneTableEntry.w	$0,	$2D00,	$0,	$680	; Act 2
	; MCZ
	zoneTableEntry.w	$0,	$2380,	$3C0,	$720	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$60,	$720	; Act 2
	; CNZ
	zoneTableEntry.w	$0,	$27A0,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$2A80,	$0,	$720	; Act 2
	; CPZ
	zoneTableEntry.w	$0,	$2780,	$0,	$720	; Act 1
	zoneTableEntry.w	$0,	$2A80,	$0,	$720	; Act 2
	; DEZ
	zoneTableEntry.w	$0,	$1000,	$C8,	 $C8	; Act 1
	zoneTableEntry.w	$0,	$1000,  $C8,	 $C8	; Act 2
	; ARZ
	zoneTableEntry.w	$0,	$28C0,	$200,	$600	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$180,	$710	; Act 2
	; SCZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$000	; Act 1
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; Act 2
    zoneTableEnd

; ===========================================================================
+
	tst.b	(Last_star_pole_hit).w		; was a star pole hit yet?
	beq.s	+				; if not, branch
	jsr	(Obj79_LoadData).l		; load the previously saved data
	move.w	(MainCharacter+x_pos).w,d1
	move.w	(MainCharacter+y_pos).w,d0
	bra.s	++
; ===========================================================================
+	; Put the character at the start location for the level
	move.w	(Current_ZoneAndAct).w,d0
	ror.b	#1,d0
	lsr.w	#5,d0
	lea	StartLocations(pc,d0.w),a1
	moveq	#0,d1
	move.w	(a1)+,d1
	move.w	d1,(MainCharacter+x_pos).w
	moveq	#0,d0
	move.w	(a1),d0
	move.w	d0,(MainCharacter+y_pos).w
+
	subi.w	#$A0,d1
	bcc.s	+
	moveq	#0,d1
+
	move.w	(Camera_Max_X_pos).w,d2
	cmp.w	d2,d1
	blo.s	+
	move.w	d2,d1
+
	move.w	d1,(Camera_X_pos).w
	move.w	d1,(Camera_X_pos_P2).w
	subi.w	#$60,d0
	bcc.s	+
	moveq	#0,d0
+
	cmp.w	(Camera_Max_Y_pos).w,d0
	blt.s	+
	move.w	(Camera_Max_Y_pos).w,d0
+
	move.w	d0,(Camera_Y_pos).w
	move.w	d0,(Camera_Y_pos_P2).w
	bsr.w	InitCameraValues
	rts
; End of function LevelSizeLoad
