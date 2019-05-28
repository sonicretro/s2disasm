; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_6F8E:
SSSingleObjLoad:
	lea	(SS_Dynamic_Object_RAM).w,a1
	move.w	#(SS_Dynamic_Object_RAM_End-SS_Dynamic_Object_RAM)/object_size-1,d5

-	tst.b	id(a1)
	beq.s	+	; rts
	lea	next_object(a1),a1 ; a1=object
	dbf	d5,-
+
	rts
; End of function sub_6F8E

; ===========================================================================

;loc_6FA4:
SSSingleObjLoad2:
	movea.l	a0,a1
	move.w	#SS_Dynamic_Object_RAM_End,d5
	sub.w	a0,d5
    if object_size=$40
	lsr.w	#6,d5
    else
	divu.w	#object_size,d5
    endif
	subq.w	#1,d5
	bcs.s	+	; rts

-	tst.b	id(a1)
	beq.s	+	; rts
	lea	next_object(a1),a1
	dbf	d5,-

+	rts