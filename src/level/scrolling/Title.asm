; loc_C51E:
SwScrl_Title:
	; Update the background's vertical scrolling.
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	; Automatically scroll the background.
	addq.w	#1,(Camera_X_pos).w

	; Calculate the background X position from the foreground X position.
	move.w	(Camera_X_pos).w,d2
	neg.w	d2
	asr.w	#2,d2

	; Update the background's (and foreground's) horizontal scrolling.
	lea	(Horiz_Scroll_Buf).w,a1

	; Do 160 lines that don't move.
	moveq	#0,d0
	move.w	#160-1,d1
-	move.l	d0,(a1)+
	dbf	d1,-

	; Do 32 lines that scroll with the camera.
	move.w	d2,d0
	move.w	#32-1,d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d0,d3
	; Make the 'ripple' animate every 8 frames.
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	move.w	(TempArray_LayerDef).w,d1
	andi.w	#$1F,d1
	lea	SwScrl_RippleData(pc),a2
	lea	(a2,d1.w),a2

	; Do 16 lines that scroll with the camera and 'ripple'.
	move.w	#16-1,d1
-	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,-

	; The remaining 16 lines are not set.

	rts
; ===========================================================================
