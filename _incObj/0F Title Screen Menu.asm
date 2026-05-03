; ----------------------------------------------------------------------------
; Object 0F - Title screen menu
; ----------------------------------------------------------------------------
; Sprite_13600:
Obj0F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj0F_Index(pc,d0.w),d1
	jsr	Obj0F_Index(pc,d1.w)
	bra.w	DisplaySprite
; ===========================================================================
; off_13612: Obj0F_States:
Obj0F_Index:	offsetTable
		offsetTableEntry.w Obj0F_Init	; 0
		offsetTableEntry.w Obj0F_Main	; 2
; ===========================================================================
; loc_13616:
Obj0F_Init:
	addq.b	#2,routine(a0) ; => Obj0F_Main
	move.w	#spriteScreenPositionXCentered(8),x_pixel(a0)
	move.w	#spriteScreenPositionYCentered(92),y_pixel(a0)
	move.l	#Obj0F_MapUnc_13B70,mappings(a0)
	move.w	#make_art_tile(ArtTile_VRAM_Start,0,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	andi.b	#1,(Title_screen_option).w
	move.b	(Title_screen_option).w,mapping_frame(a0)

; loc_13644:
Obj0F_Main:
	moveq	#0,d2
	move.b	(Title_screen_option).w,d2
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	btst	#button_up,d0
	beq.s	+
	subq.b	#1,d2
	bcc.s	+
	move.b	#2,d2
+
	btst	#button_down,d0
	beq.s	+
	addq.b	#1,d2
	cmpi.b	#3,d2
	blo.s	+
	moveq	#0,d2
+
	move.b	d2,mapping_frame(a0)
	move.b	d2,(Title_screen_option).w
	andi.b	#button_up_mask|button_down_mask,d0
	beq.s	+	; rts
	moveq	#signextendB(SndID_Blip),d0 ; selection blip sound
	jsrto	JmpTo4_PlaySound
+
	rts
