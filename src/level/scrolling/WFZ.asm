; loc_C82A:
SwScrl_WFZ:
	; Set the flags to dynamically load the background as it moves.
	move.w	(Camera_BG_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#8,d4
	moveq	#scroll_flag_bg1_left,d6
	bsr.w	SetHorizScrollFlagsBG

	; Ditto.
	move.w	(Camera_BG_Y_pos_diff).w,d5
	ext.l	d5
	lsl.l	#8,d5
	moveq	#scroll_flag_bg1_up_whole_row_2,d6
	bsr.w	SetVertiScrollFlagsBG

	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Update the background's (and foreground's) horizontal scrolling.
	move.l	(Camera_BG_X_pos).w,d0
	; This can be removed if the getaway ship's entry uses d0 instead.
	move.l	d0,d1
	lea	(TempArray_LayerDef).w,a2
	move.l	d0,(a2)+				; Static parts of BG (generally no clouds in them)
	move.l	d1,(a2)+				; Eggman's getaway ship
    if fixBugs
	moveq	#0,d5
	move.w	(Camera_X_pos_diff).w,d5	; get camera x-diff
	ext.l	d5
	asl.l	#5,d5
	add.l	d5,(a2)				; add to high word of accumulation
	addi.l	#$8000,(a2)+			; larger clouds
	add.l	d5,(a2)
	addi.l	#$4000,(a2)+			; medium clouds
	add.l	d5,(a2)
	addi.l	#$2000,(a2)+			; small clouds
    else
	; This tallies only the cloud speeds. It works fine if you are standing
	; still, but makes the clouds move faster when going right and slower when
	; going left. This is exactly the opposite of what should happen.
	addi.l	#$8000,(a2)+			; larger clouds
	addi.l	#$4000,(a2)+			; medium clouds
	addi.l	#$2000,(a2)+			; small clouds
    endif
	lea	(SwScrl_WFZ_Transition_Array).l,a3
	cmpi.w	#$2700,(Camera_X_pos).w
	bhs.s	.got_array
	lea	(SwScrl_WFZ_Normal_Array).l,a3

.got_array:
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	andi.w	#$7FF,d1
	moveq	#0,d0
	moveq	#0,d3

	; Find the first visible scrolling section
.seg_loop:
	move.b	(a3)+,d0		; Number of lines in this segment
	addq.w	#1,a3			; Skip index
	sub.w	d0,d1			; Does this segment have any visible lines?
	bcc.s	.seg_loop		; Branch if not

	neg.w	d1			; d1 = number of lines to draw in this segment
	move.w	#screen_height-1,d2		; Number of rows in hscroll buffer
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.b	-1(a3),d3		; Fetch TempArray_LayerDef index
	move.w	(a2,d3.w),d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP

.row_loop:
	move.l	d0,(a1)+
	subq.w	#1,d1			; Has the current segment finished?
	bne.s	.next_row		; Branch if not
	move.b	(a3)+,d1		; Fetch a new line count
	move.b	(a3)+,d3		; Fetch TempArray_LayerDef index
	move.w	(a2,d3.w),d0		; Fetch scroll value for this row...
	neg.w	d0			; ...and flip sign for VDP

.next_row:
	dbf	d2,.row_loop

	rts
; ===========================================================================
; WFZ BG scrolling data
; Each pair of bytes corresponds to one scrolling segment of the BG, and
; the bytes have the following meaning:
; 	number of lines, index into TempArray_LayerDef
; byte_C8CA
SwScrl_WFZ_Transition_Array:
	dc.b $C0,  0
	dc.b $C0,  0
	dc.b $80,  0
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $80,  4
	dc.b $80,  4
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $C0,  0
	dc.b $C0,  0
	dc.b $80,  0
;byte_C916
SwScrl_WFZ_Normal_Array:
	dc.b $C0,  0
	dc.b $C0,  0
	dc.b $80,  0
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
	dc.b $C0,  0
	dc.b $C0,  0
	dc.b $80,  0
; This array is missing data for the last $80 lines compared to the transition array.
; This causes the lower clouds to read data from the start of SwScrl_HTZ.
; These are the missing entries:
    if fixBugs
	dc.b $20,  8
	dc.b $30, $C
	dc.b $30,$10
    endif
; ===========================================================================
