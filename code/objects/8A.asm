; ===========================================================================
; ----------------------------------------------------------------------------
; Object 8A - Sonic Team Presents/Credits (leftover from S1) (seemingly unused)
; ----------------------------------------------------------------------------
; Sprite_3EAC8:
Obj8A: ; (screen-space obj)
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj8A_Index(pc,d0.w),d1
	jmp	Obj8A_Index(pc,d1.w)
; ===========================================================================
; off_3EAD6:
Obj8A_Index:	offsetTable
		offsetTableEntry.w Obj8A_Init
		offsetTableEntry.w Obj8A_Display
; ===========================================================================
; loc_3EADA:
Obj8A_Init:
	addq.b	#2,routine(a0)
	move.w	#$120,x_pixel(a0)
	move.w	#$F0,y_pixel(a0)
	move.l	#Obj8A_MapUnc_3EB4E,mappings(a0)
	move.w	#make_art_tile($05A0,0,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo65_Adjust2PArtPointer
	move.w	(Ending_demo_number).w,d0
	move.b	d0,mapping_frame(a0)
	move.b	#0,render_flags(a0)
	move.b	#0,priority(a0)
	cmpi.b	#GameModeID_TitleScreen,(Game_Mode).w	; title screen??
	bne.s	Obj8A_Display	; if not, branch
	move.w	#make_art_tile($0300,0,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo65_Adjust2PArtPointer
	move.b	#$A,mapping_frame(a0)
	tst.b	(S1_hidden_credits_flag).w
	beq.s	Obj8A_Display
	cmpi.b	#button_down_mask|button_B_mask|button_C_mask|button_A_mask,(Ctrl_1_Held).w
	bne.s	Obj8A_Display
	move.w	#$EEE,(Target_palette_line3).w
	move.w	#$880,(Target_palette_line3+2).w
	jmp	(DeleteObject).l
; ===========================================================================
; JmpTo46_DisplaySprite
Obj8A_Display:
	jmp	(DisplaySprite).l
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings (unused?)
; ----------------------------------------------------------------------------
Obj8A_MapUnc_3EB4E:	include "mappings/sprite/obj8A.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo65_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
