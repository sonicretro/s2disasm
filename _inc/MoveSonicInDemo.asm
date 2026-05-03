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
    if fixBugs
	; In REV00 of Sonic 1, this instruction was 'move.b (a0),d2'. The
	; purpose of this is to XOR the current frame's input with the
	; previous frame's input to determine which inputs had been pressed
	; on the current frame. The usage of '(a0)' for this is a problem
	; because it doesn't hold the *demo* inputs from the previous frame,
	; but rather the *player's* inputs from the *current* frame.
	; This meant that it was possible for the player to influence the
	; demos by pressing buttons on the joypad. In REV01 of Sonic 1, this
	; instruction was replaced with a 'moveq #0,d2', effectively
	; dummying-out the process of differentiating newly-pressed inputs
	; from old held inputs, causing every input to be treated as
	; newly-pressed on every frame. While this isn't a problem in this
	; game, it does become a problem if Sonic or Tails is given a
	; double-jump ability, as the ability will constantly be activated
	; when they shouldn't be. While not exactly the intended use for this
	; variable, 'Ctrl_1_Held_Logical' does happen to hold the inputs from
	; the previous frame, so we can use this here instead to fix this bug
	; properly.
	move.b	Ctrl_1_Held_Logical-Ctrl_1_Held(a0),d2
    else
	moveq	#0,d2
    endif
	eor.b	d2,d0	; determine which buttons differ between this frame and the last
	move.b	d1,(a0)+ ; save button press data from demo to Ctrl_1_Held
	and.b	d1,d0	; only keep the buttons that were pressed on this frame
	move.b	d0,(a0)+ ; save the same thing to Ctrl_1_Press
	subq.b	#1,(Demo_press_counter).w  ; decrement counter until next press
	bcc.s	MoveDemo_On_P2	   ; if it isn't 0 yet, branch
	move.b	3(a1),(Demo_press_counter).w ; reset counter to length of next press
	addq.w	#2,(Demo_button_index).w ; advance to next button press
; loc_4908:
MoveDemo_On_P2:
	cmpi.b	#emerald_hill_zone,(Current_Zone).w
	bne.s	MoveDemo_On_SkipP2 ; if it's not the EHZ demo, branch to skip player 2
	lea	(Demo_EHZ_Tails).l,a1

	; same as the corresponding remainder of MoveDemo_On_P1, but for player 2
	move.w	(Demo_button_index_2P).w,d0
	adda.w	d0,a1
	move.b	(a1),d0
	lea	(Ctrl_2_Held).w,a0
	move.b	d0,d1
    if fixBugs
	; In REV00 of Sonic 1, this instruction was 'move.b (a0),d2'. The
	; purpose of this is to XOR the current frame's input with the
	; previous frame's input to determine which inputs had been pressed
	; on the current frame. The usage of '(a0)' for this is a problem
	; because it doesn't hold the *demo* inputs from the previous frame,
	; but rather the *player's* inputs from the *current* frame.
	; This meant that it was possible for the player to influence the
	; demos by pressing buttons on the joypad. In REV01 of Sonic 1, this
	; instruction was replaced with a 'moveq #0,d2', effectively
	; dummying-out the process of differentiating newly-pressed inputs
	; from old held inputs, causing every input to be treated as
	; newly-pressed on every frame. While this isn't a problem in this
	; game, it does become a problem if Sonic or Tails is given a
	; double-jump ability, as the ability will constantly be activated
	; when they shouldn't be. While not exactly the intended use for this
	; variable, 'Ctrl_1_Held_Logical' does happen to hold the inputs from
	; the previous frame, so we can use this here instead to fix this bug
	; properly.
	move.b	Ctrl_1_Held_Logical-Ctrl_1_Held(a0),d2
    else
	moveq	#0,d2
    endif
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
	zoneTableEntry.l Demo_EHZ	; EHZ
	zoneTableEntry.l Demo_EHZ	; Zone 1
	zoneTableEntry.l Demo_EHZ	; WZ
	zoneTableEntry.l Demo_EHZ	; Zone 3
	zoneTableEntry.l Demo_EHZ	; MTZ1,2
	zoneTableEntry.l Demo_EHZ	; MTZ3
	zoneTableEntry.l Demo_EHZ	; WFZ
	zoneTableEntry.l Demo_EHZ	; HTZ
	zoneTableEntry.l Demo_EHZ	; HPZ
	zoneTableEntry.l Demo_EHZ	; Zone 9
	zoneTableEntry.l Demo_EHZ	; OOZ
	zoneTableEntry.l Demo_EHZ	; MCZ
	zoneTableEntry.l Demo_CNZ	; CNZ
	zoneTableEntry.l Demo_CPZ	; CPZ
	zoneTableEntry.l Demo_EHZ	; DEZ
	zoneTableEntry.l Demo_ARZ	; ARZ
	zoneTableEntry.l Demo_EHZ	; SCZ
    zoneTableEnd
; ---------------------------------------------------------------------------
; dword_498C:
EndingDemoScriptPointers:
	; Empty, since Sonic 2 doesn't have demos during its credits.
; ---------------------------------------------------------------------------
	; Leftover unused demo data from Sonic 1.
	; It involves Sonic slowly running right, jumping once,
	; then running at full speed for a few seconds.
	; Interestingly, this lines up with our knowledge of
	; the fabled Tokyo Game Show prototype.
	; See it in action: https://youtu.be/S8_IAfQbUu0
	demoinput ,	$8C
	demoinput R,	$38
	demoinput ,	$43
	demoinput R,	$5D
	demoinput ,	$6B
	demoinput R,	$60
	demoinput ,	$30
	demoinput R,	$2D
	demoinput ,	$22
	demoinput R,	4
	demoinput RC,	$31
	demoinput R,	9
	demoinput ,	$2F
	demoinput R,	$16
	demoinput ,	$10
	demoinput R,	$47
	demoinput ,	$1B
	demoinput R,	$100
	demoinput R,	$CB
	demoinput ,	1
	demoinput ,	1
	demoinput ,	1
	demoinput ,	1
	demoinput ,	1
