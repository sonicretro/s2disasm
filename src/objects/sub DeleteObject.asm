; ---------------------------------------------------------------------------
; Routines to mark an enemy/monitor/ring/platform as destroyed
; ---------------------------------------------------------------------------

; ===========================================================================
; input: a0 = the object
; loc_163D2:
MarkObjGone:
	tst.w	(Two_player_mode).w	; is it two player mode?
	beq.s	+			; if not, branch
	bra.w	DisplaySprite
+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$80+roundToNextMultiple(screen_width,$80)+$80,d0	; This gives an object $80 pixels of room offscreen before being unloaded
	bhi.w	+
	bra.w	DisplaySprite

+	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
+
	bra.w	DeleteObject
; ===========================================================================
; input: d0 = the object's x position
; loc_1640A:
MarkObjGone2:
	tst.w	(Two_player_mode).w
	beq.s	+
	bra.w	DisplaySprite
+
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$80+roundToNextMultiple(screen_width,$80)+$80,d0	; This gives an object $80 pixels of room offscreen before being unloaded
	bhi.w	+
	bra.w	DisplaySprite
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
+
	bra.w	DeleteObject
; ===========================================================================
; input: a0 = the object
; does nothing instead of calling DisplaySprite in the case of no deletion
; loc_1643E:
MarkObjGone3:
	tst.w	(Two_player_mode).w
	beq.s	+
	rts
+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$80+roundToNextMultiple(screen_width,$80)+$80,d0	; This gives an object $80 pixels of room offscreen before being unloaded
	bhi.w	+
	rts
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
+
	bra.w	DeleteObject
; ===========================================================================
; input: a0 = the object
; loc_16472:
MarkObjGone_P1:
	tst.w	(Two_player_mode).w
	bne.s	MarkObjGone_P2
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$80+roundToNextMultiple(screen_width,$80)+$80,d0	; This gives an object $80 pixels of room offscreen before being unloaded
	bhi.w	+
	bra.w	DisplaySprite
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
+
	bra.w	DeleteObject
; ---------------------------------------------------------------------------
; input: a0 = the object
; loc_164A6:
MarkObjGone_P2:
	move.w	x_pos(a0),d0
	andi.w	#$FF00,d0
	move.w	d0,d1
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$300,d0
	bhi.w	+
	bra.w	DisplaySprite
+
	sub.w	(Camera_X_pos_coarse_P2).w,d1
	cmpi.w	#$300,d1
	bhi.w	+
	bra.w	DisplaySprite
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,Obj_respawn_data-Object_Respawn_Table(a2,d0.w)
+
	bra.w	DeleteObject ; useless branch...

; ---------------------------------------------------------------------------
; Subroutine to delete an object
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; freeObject:
DeleteObject:
	movea.l	a0,a1

; sub_164E8:
DeleteObject2:
	moveq	#0,d1

	moveq	#bytesToLcnt(next_object),d0 ; we want to clear up to the next object
	; delete the object by setting all of its bytes to 0
-	move.l	d1,(a1)+
	dbf	d0,-
    if object_size&3
	move.w	d1,(a1)+
    endif

	rts
; End of function DeleteObject2
