; ===========================================================================
; ----------------------------------------------------------------------------
; Object D3 - Bomb prize from CNZ
; ----------------------------------------------------------------------------
; Note: see object DC (ring prize) for SST entries (casino_prize_*)

; Sprite_2B84C:
ObjD3:
	moveq	#0,d1
	move.w	casino_prize_machine_x_pos(a0),d1
	swap	d1
	move.l	casino_prize_x_pos(a0),d0
	sub.l	d1,d0
	asr.l	#4,d0
	sub.l	d0,casino_prize_x_pos(a0)
	move.w	casino_prize_x_pos(a0),x_pos(a0)
	moveq	#0,d1
	move.w	casino_prize_machine_y_pos(a0),d1
	swap	d1
	move.l	casino_prize_y_pos(a0),d0
	sub.l	d1,d0
	asr.l	#4,d0
	sub.l	d0,casino_prize_y_pos(a0)
	move.w	casino_prize_y_pos(a0),y_pos(a0)
	subq.w	#1,casino_prize_display_delay(a0)
	bne.w	JmpTo28_DisplaySprite
	movea.l	objoff_2A(a0),a1
	subq.w	#1,(a1)
	cmpi.w	#5,(Bonus_Countdown_3).w
	blo.s	+
	clr.w	(Bonus_Countdown_3).w
	move.w	#SndID_HurtBySpikes,d0
	jsr	(PlaySound2).l
+
	tst.b	parent+1(a0)
	beq.s	++
	tst.w	(Ring_count_2P).w
	beq.s	+
	subq.w	#1,(Ring_count_2P).w
	ori.b	#$81,(Update_HUD_rings_2P).w
+
	tst.w	(Two_player_mode).w
	bne.s	BranchTo_JmpTo44_DeleteObject
+
	tst.w	(Ring_count).w
	beq.s	BranchTo_JmpTo44_DeleteObject
	subq.w	#1,(Ring_count).w
	ori.b	#$81,(Update_HUD_rings).w

BranchTo_JmpTo44_DeleteObject ; BranchTo
	jmpto	DeleteObject, JmpTo44_DeleteObject

    if removeJmpTos
JmpTo28_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
    endif
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjD3_MapUnc_2B8D4:	include "mappings/sprite/objD6_a.asm"
; ===========================================================================

    if ~~removeJmpTos
JmpTo28_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo44_DeleteObject ; JmpTo
	jmp	(DeleteObject).l

	align 4
    endif
