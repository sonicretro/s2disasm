; ===========================================================================
; ----------------------------------------------------------------------------
; Object 5E - HUD from Special Stage
; ----------------------------------------------------------------------------
; Sprite_6FC0:
Obj5E:
	move.b	routine(a0),d0
	bne.w	JmpTo_DisplaySprite
	move.l	#Obj5E_MapUnc_7070,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialHUD,0,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#0,priority(a0)
	move.b	#1,routine(a0)
	bset	#6,render_flags(a0)
	moveq	#0,d1
	tst.b	(SS_2p_Flag).w
	beq.s	+
	addq.w	#6,d1
	tst.b	(Graphics_Flags).w
	bpl.s	++
	addq.w	#1,d1
	bra.s	++
; ---------------------------------------------------------------------------
+	move.w	(Player_mode).w,d1
	andi.w	#3,d1
	tst.b	(Graphics_Flags).w
	bpl.s	+
	addq.w	#3,d1 ; set special stage tails name to "TAILS" instead of MILES
+
	add.w	d1,d1
	moveq	#0,d2
	moveq	#0,d3
	lea	(SSHUDLayout).l,a1
	lea	sub2_x_pos(a0),a2
	adda.w	(a1,d1.w),a1
	move.b	(a1)+,d3
	move.b	d3,mainspr_childsprites(a0)
	subq.w	#1,d3
	moveq	#0,d0
	move.b	(a1)+,d0

-	move.w	d0,(a2,d2.w)
	move.b	(a1)+,sub2_mapframe-sub2_x_pos(a2,d2.w)	; sub2_mapframe
	addq.w	#next_subspr,d2
	dbf	d3,-

	rts
; ===========================================================================
; off_7042:
SSHUDLayout:	offsetTable
		offsetTableEntry.w SSHUD_SonicMilesTotal	; 0
		offsetTableEntry.w SSHUD_Sonic			; 1
		offsetTableEntry.w SSHUD_Miles			; 2
		offsetTableEntry.w SSHUD_SonicTailsTotal	; 3
		offsetTableEntry.w SSHUD_Sonic_2		; 4
		offsetTableEntry.w SSHUD_Tails			; 5
		offsetTableEntry.w SSHUD_SonicMiles		; 6
		offsetTableEntry.w SSHUD_SonicTails		; 7

; byte_7052:
SSHUD_SonicMilesTotal:
	dc.b   3		; Sprite count
	dc.b   $80		; X-pos
	dc.b   0,  1,  3	; Sprite 1 frame, Sprite 2 frame, etc
; byte_7057:
SSHUD_Sonic:
	dc.b   1
	dc.b   $D4
	dc.b   0
; byte_705A:
SSHUD_Miles:
	dc.b   1
	dc.b   $38
	dc.b   1

; byte_705D:
SSHUD_SonicTailsTotal:
	dc.b   3
	dc.b   $80
	dc.b   0,  2,  3
; byte_7062:
SSHUD_Sonic_2:
	dc.b   1
	dc.b   $D4
	dc.b   0
; byte_7065:
SSHUD_Tails:
	dc.b   1
	dc.b   $38
	dc.b   2

; 2 player
; byte_7068:
SSHUD_SonicMiles:
	dc.b   2
	dc.b   $80
	dc.b   0,  1
; byte_706C:
SSHUD_SonicTails:
	dc.b   2
	dc.b   $80
	dc.b   0,  2