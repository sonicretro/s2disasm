; ---------------------------------------------------------------------------
; Tails' Tails pattern loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1D184:
LoadTailsTailsDynPLC:
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	cmp.b	(TailsTails_LastLoadedDPLC).w,d0
	beq.s	return_1D1FE
	move.b	d0,(TailsTails_LastLoadedDPLC).w
	lea	(MapRUnc_Tails).l,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d5
	subq.w	#1,d5
	bmi.s	return_1D1FE
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_Tails_Tails),d4
	bra.s	TPLC_ReadEntry

; ---------------------------------------------------------------------------
; Tails pattern loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1D1AC:
LoadTailsDynPLC:
	moveq	#0,d0
	move.b	mapping_frame(a0),d0	; load frame number
; loc_1D1B2:
LoadTailsDynPLC_Part2:
	cmp.b	(Tails_LastLoadedDPLC).w,d0
	beq.s	return_1D1FE
	move.b	d0,(Tails_LastLoadedDPLC).w
	lea	(MapRUnc_Tails).l,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d5
	subq.w	#1,d5
	bmi.s	return_1D1FE
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_Tails),d4
; loc_1D1D2:
TPLC_ReadEntry:
	moveq	#0,d1
	move.w	(a2)+,d1
	move.w	d1,d3
	lsr.w	#8,d3
	andi.w	#$F0,d3
	addi.w	#$10,d3
	andi.w	#$FFF,d1
	lsl.l	#5,d1
	addi.l	#ArtUnc_Tails,d1
	move.w	d4,d2
	add.w	d3,d4
	add.w	d3,d4
	jsr	(QueueDMATransfer).l
	dbf	d5,TPLC_ReadEntry	; repeat for number of entries

return_1D1FE:
	rts
