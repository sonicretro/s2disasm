; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_481E:
MoveSonicInDemo:
	tst.w	(Demo_mode_flag).w	; is demo mode on?
	bne.w	MoveDemo_On	; if yes, branch
	rts
; ---------------------------------------------------------------------------
; demo recording routine
; (unused/dead code, but obviously used during development)
; ---------------------------------------------------------------------------
; MoveDemo_Record: loc_4828:
	; calculate output location of recorded player 1 demo?
	lea	(DemoScriptPointers).l,a1
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	lsl.w	#2,d0
	movea.l	(a1,d0.w),a1
	move.w	(Demo_button_index).w,d0
	adda.w	d0,a1

	move.b	(Ctrl_1_Held).w,d0	; load input of player 1
	cmp.b	(a1),d0			; is same button held?
	bne.s	+			; if not, branch
	addq.b	#1,1(a1)		; increment press length counter
	cmpi.b	#$FF,1(a1)		; is button held too long?
	beq.s	+			; if yes, branch
	bra.s	MoveDemo_Record_P2	; go to player 2
; ===========================================================================
+
	move.b	d0,2(a1)		; store last button press
	move.b	#0,3(a1)		; reset hold length counter
	addq.w	#2,(Demo_button_index).w ; advance to next button press
	andi.w	#$3FF,(Demo_button_index).w ; wrap at max button press changes 1024
; loc_486A:
MoveDemo_Record_P2:
	cmpi.b	#emerald_hill_zone,(Current_Zone).w
	bne.s	++	; rts
	lea	($FEC000).l,a1		; output location of recorded player 2 demo? (unknown)
	move.w	(Demo_button_index_2P).w,d0
	adda.w	d0,a1
	move.b	(Ctrl_2_Held).w,d0	; load input of player 2
	cmp.b	(a1),d0			; is same button held?
	bne.s	+			; if not, branch
	addq.b	#1,1(a1)		; increment press length counter
	cmpi.b	#$FF,1(a1)		; is button held too long?
	beq.s	+			; if yes, branch
	bra.s	++			; if not, return
; ===========================================================================
+
	move.b	d0,2(a1)		; store last button press
	move.b	#0,3(a1)		; reset hold length counter
	addq.w	#2,(Demo_button_index_2P).w ; advance to next button press
	andi.w	#$3FF,(Demo_button_index_2P).w ; wrap at max button press changes 1024
+	rts
	; end of inactive recording code
; ===========================================================================
	; continue with MoveSonicInDemo:

; loc_48AA:
MoveDemo_On:
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0
	beq.s	+
	tst.w	(Demo_mode_flag).w
	bmi.s	+
	move.b	#GameModeID_TitleScreen,(Game_Mode).w ; => TitleScreen
+
	lea	(DemoScriptPointers).l,a1 ; load pointer to input data
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w ; special stage mode?
	bne.s	MoveDemo_On_P1		; if yes, branch
	moveq	#6,d0
; loc_48DA:
MoveDemo_On_P1:
	lsl.w	#2,d0
	movea.l	(a1,d0.w),a1

	move.w	(Demo_button_index).w,d0
	adda.w	d0,a1	; a1 now points to the current button press data
	move.b	(a1),d0	; load button press
	lea	(Ctrl_1_Held).w,a0
	move.b	d0,d1
	moveq	#0,d2 ; this was modified from (a0) to #0 in Rev01 of Sonic 1 to nullify the following line
	eor.b	d2,d0	; does nothing now (used to let you hold a button to prevent Sonic from jumping in demos)
	move.b	d1,(a0)+ ; save button press data from demo to Ctrl_1_Held
	and.b	d1,d0	; does nothing now
	move.b	d0,(a0)+ ; save the same thing to Ctrl_1_Press
	subq.b	#1,(Demo_press_counter).w  ; decrement counter until next press
	bcc.s	MoveDemo_On_P2	   ; if it isn't 0 yet, branch
	move.b	3(a1),(Demo_press_counter).w ; reset counter to length of next press
	addq.w	#2,(Demo_button_index).w ; advance to next button press
; loc_4908:
MoveDemo_On_P2:
    if emerald_hill_zone_act_1<$100 ; will it fit within a byte?
	cmpi.b	#emerald_hill_zone_act_1,(Current_Zone).w
    else
	cmpi.w #emerald_hill_zone_act_1,(Current_ZoneAndAct).w ; avoid a range overflow error
    endif
	bne.s	MoveDemo_On_SkipP2 ; if it's not the EHZ demo, branch to skip player 2
	lea	(Demo_EHZ_Tails).l,a1

	; same as the corresponding remainder of MoveDemo_On_P1, but for player 2
	move.w	(Demo_button_index_2P).w,d0
	adda.w	d0,a1
	move.b	(a1),d0
	lea	(Ctrl_2_Held).w,a0
	move.b	d0,d1
	moveq	#0,d2
	eor.b	d2,d0
	move.b	d1,(a0)+
	and.b	d1,d0
	move.b	d0,(a0)+
	subq.b	#1,(Demo_press_counter_2P).w
	bcc.s	+	; rts
	move.b	3(a1),(Demo_press_counter_2P).w
	addq.w	#2,(Demo_button_index_2P).w
+
	rts
; ===========================================================================
; loc_4940:
MoveDemo_On_SkipP2:
	move.w	#0,(Ctrl_2).w
	rts
; End of function MoveSonicInDemo

; ===========================================================================
; ---------------------------------------------------------------------------
; DEMO SCRIPT POINTERS

; Contains an array of pointers to the script controlling the players actions
; to use for each level.
; ---------------------------------------------------------------------------
; off_4948:
DemoScriptPointers: zoneOrderedTable 4,1
	zoneTableEntry.l Demo_EHZ	; $00
	zoneTableEntry.l Demo_EHZ	; $01
	zoneTableEntry.l Demo_EHZ	; $02
	zoneTableEntry.l Demo_EHZ	; $03
	zoneTableEntry.l Demo_EHZ	; $04
	zoneTableEntry.l Demo_EHZ	; $05
	zoneTableEntry.l Demo_EHZ	; $06
	zoneTableEntry.l Demo_EHZ	; $07
	zoneTableEntry.l Demo_EHZ	; $08
	zoneTableEntry.l Demo_EHZ	; $09
	zoneTableEntry.l Demo_EHZ	; $0A
	zoneTableEntry.l Demo_EHZ	; $0B
	zoneTableEntry.l Demo_CNZ	; $0C
	zoneTableEntry.l Demo_CPZ	; $0D
	zoneTableEntry.l Demo_EHZ	; $0E
	zoneTableEntry.l Demo_ARZ	; $0F
	zoneTableEntry.l Demo_EHZ	; $10
    zoneTableEnd
; ---------------------------------------------------------------------------
; dword_498C:
EndingDemoScriptPointers:
	; these values are invalid addresses, but they were used for the ending
	; demos, which aren't present in Sonic 2
	dc.l   $8B0837
	dc.l   $42085C	; 1
	dc.l   $6A085F	; 2
	dc.l   $2F082C	; 3
	dc.l   $210803	; 4
	dc.l $28300808	; 5
	dc.l   $2E0815	; 6
	dc.l	$F0846	; 7
	dc.l   $1A08FF	; 8
	dc.l  $8CA0000	; 9
	dc.l	     0	; 10
	dc.l	     0	; 11