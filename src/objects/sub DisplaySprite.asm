; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_164F4:
DisplaySprite:
	lea	(Object_Display_Lists).w,a1
	move.w	priority(a0),d0
	lsr.w	#8-object_display_list_size_bits,d0
	andi.w	#(1<<total_object_display_lists_bits-1)<<object_display_list_size_bits,d0
	adda.w	d0,a1
	cmpi.w	#object_display_list_size-2,(a1)
	bhs.s	.return
	addq.w	#2,(a1)
	adda.w	(a1),a1
	move.w	a0,(a1)

.return:
	rts
; End of function DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a1 is the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16512:
DisplaySprite2:
	lea	(Object_Display_Lists).w,a2
	move.w	priority(a1),d0
	lsr.w	#8-object_display_list_size_bits,d0
	andi.w	#(1<<total_object_display_lists_bits-1)<<object_display_list_size_bits,d0
	adda.w	d0,a2
	cmpi.w	#object_display_list_size-2,(a2)
	bhs.s	.return
	addq.w	#2,(a2)
	adda.w	(a2),a2
	move.w	a1,(a2)

.return:
	rts
; End of function DisplaySprite2

; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; and d0 is already priority*$80
; ---------------------------------------------------------------------------

; loc_16530:
DisplaySprite3:
	lea	(Object_Display_Lists).w,a1
	adda.w	d0,a1
	cmpi.w	#object_display_list_size-2,(a1)
	bhs.s	.return
	addq.w	#2,(a1)
	adda.w	(a1),a1
	move.w	a0,(a1)

.return:
	rts
