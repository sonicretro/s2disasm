; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; sub_C3D0:
DeformBgLayer:
	tst.b	(Deform_lock).w
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+
	clr.w	(Scroll_flags).w
	clr.w	(Scroll_flags_BG).w
	clr.w	(Scroll_flags_BG2).w
	clr.w	(Scroll_flags_BG3).w
	clr.w	(Scroll_flags_P2).w
	clr.w	(Scroll_flags_BG_P2).w
	clr.w	(Scroll_flags_BG2_P2).w
	clr.w	(Scroll_flags_BG3_P2).w
	clr.w	(Camera_X_pos_diff).w
	clr.w	(Camera_Y_pos_diff).w
	clr.w	(Camera_X_pos_diff_P2).w
	clr.w	(Camera_Y_pos_diff_P2).w

	; Sky Chase Zone handles scrolling manually, in 'SwScrl_SCZ'.
	cmpi.b	#sky_chase_zone,(Current_Zone).w
	bne.w	+
	tst.w	(Debug_placement_mode).w
	beq.w	loc_C4D0
+
	tst.b	(Scroll_lock).w
	bne.s	DeformBgLayerAfterScrollVert
	lea	(MainCharacter).w,a0 ; a0=character
	lea	(Camera_X_pos).w,a1
	lea	(Camera_Boundaries).w,a2
	lea	(Scroll_flags).w,a3
	lea	(Camera_X_pos_diff).w,a4
	lea	(Camera_Delay).w,a5
	lea	(Sonic_Pos_Record_Buf).w,a6
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	lea	(Camera_Delay_P2).w,a5
	lea	(Tails_Pos_Record_Buf).w,a6
+
	bsr.w	ScrollHoriz
	lea	(Horiz_block_crossed_flag).w,a2
	bsr.w	SetHorizScrollFlags
	lea	(Camera_Y_pos).w,a1
	lea	(Camera_Boundaries).w,a2
	lea	(Camera_Y_pos_diff).w,a4
	move.w	(Camera_Y_pos_bias).w,d3
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	move.w	(Camera_Y_pos_bias_P2).w,d3
+
	bsr.w	ScrollVerti
	lea	(Verti_block_crossed_flag).w,a2
	bsr.w	SetVertiScrollFlags

DeformBgLayerAfterScrollVert:
	tst.w	(Two_player_mode).w
	beq.s	loc_C4D0
	tst.b	(Scroll_lock_P2).w
	bne.s	loc_C4D0
	lea	(Sidekick).w,a0 ; a0=character
	lea	(Camera_X_pos_P2).w,a1
	lea	(Camera_Boundaries_P2).w,a2
	lea	(Scroll_flags_P2).w,a3
	lea	(Camera_X_pos_diff_P2).w,a4
	lea	(Camera_Delay_P2).w,a5
	lea	(Tails_Pos_Record_Buf).w,a6
	bsr.w	ScrollHoriz
	lea	(Horiz_block_crossed_flag_P2).w,a2
	bsr.w	SetHorizScrollFlags
	lea	(Camera_Y_pos_P2).w,a1
	lea	(Camera_Boundaries_P2).w,a2
	lea	(Camera_Y_pos_diff_P2).w,a4
	move.w	(Camera_Y_pos_bias_P2).w,d3
	bsr.w	ScrollVerti
	lea	(Verti_block_crossed_flag_P2).w,a2
	bsr.w	SetVertiScrollFlags

loc_C4D0:
	bsr.w	RunDynamicLevelEvents
	move.w	(Camera_Y_pos).w,(Vscroll_Factor_FG).w
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	move.l	(Camera_X_pos).w,(Camera_X_pos_copy).w
	move.l	(Camera_Y_pos).w,(Camera_Y_pos_copy).w
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	move.w	SwScrl_Index(pc,d0.w),d0
	jmp	SwScrl_Index(pc,d0.w)
; End of function DeformBgLayer

; ===========================================================================
; ---------------------------------------------------------------------------
; JUMP TABLE FOR SOFTWARE SCROLL MANAGERS
;
; "Software scrolling" is my term for what Nemesis (and by extension, the rest
; of the world) calls "rasterized layer deformation".* Software scroll managers
; are needed to achieve certain special camera effects - namely, locking the
; screen for a boss fight and defining the limits of said screen lock, or in
; the case of Sky Chase Zone ($10), moving the camera at a fixed rate through
; a predefined course.
; They are also used for things like controlling the parallax scrolling and
; water ripple effects in EHZ, and moving the clouds in HTZ and the stars in DEZ.
; ---------------------------------------------------------------------------
SwScrl_Index: zoneOrderedOffsetTable 2,1	; JmpTbl_SwScrlMgr
	zoneOffsetTableEntry.w SwScrl_EHZ	; EHZ
	zoneOffsetTableEntry.w SwScrl_Minimal	; Zone 1
	zoneOffsetTableEntry.w SwScrl_WZ	; WZ
	zoneOffsetTableEntry.w SwScrl_Minimal	; Zone 3
	zoneOffsetTableEntry.w SwScrl_MTZ	; MTZ1,2
	zoneOffsetTableEntry.w SwScrl_MTZ	; MTZ3
	zoneOffsetTableEntry.w SwScrl_WFZ	; WFZ
	zoneOffsetTableEntry.w SwScrl_HTZ	; HTZ
	zoneOffsetTableEntry.w SwScrl_HPZ	; HPZ
	zoneOffsetTableEntry.w SwScrl_Minimal	; Zone 9
	zoneOffsetTableEntry.w SwScrl_OOZ	; OOZ
	zoneOffsetTableEntry.w SwScrl_MCZ	; MCZ
	zoneOffsetTableEntry.w SwScrl_CNZ	; CNZ
	zoneOffsetTableEntry.w SwScrl_CPZ	; CPZ
	zoneOffsetTableEntry.w SwScrl_DEZ	; DEZ
	zoneOffsetTableEntry.w SwScrl_ARZ	; ARZ
	zoneOffsetTableEntry.w SwScrl_SCZ	; SCZ
    zoneTableEnd
; ===========================================================================
	include "src/level/scrolling/Title.asm"
	include "src/level/scrolling/EHZ.asm"
	include "src/level/scrolling/WZ.asm"
	include "src/level/scrolling/MTZ.asm"
	include "src/level/scrolling/WFZ.asm"
	include "src/level/scrolling/HTZ.asm"
	include "src/level/scrolling/HPZ.asm"
	include "src/level/scrolling/OOZ.asm"
	include "src/level/scrolling/MCZ.asm"
	include "src/level/scrolling/CNZ.asm"
	include "src/level/scrolling/CPZ.asm"
	include "src/level/scrolling/DEZ.asm"
	include "src/level/scrolling/ARZ.asm"
	include "src/level/scrolling/SCZ.asm"
	include "src/level/scrolling/Minimal.asm"
