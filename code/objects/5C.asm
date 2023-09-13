; ===========================================================================
; ----------------------------------------------------------------------------
; Object 5C - Masher (jumping piranha fish badnik) from EHZ
; ----------------------------------------------------------------------------
; OST Variables:
Obj5C_initial_y_pos	= objoff_30	; word

; Sprite_2D394:
Obj5C:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj5C_Index(pc,d0.w),d1
	jsr	Obj5C_Index(pc,d1.w)
	jmpto	MarkObjGone, JmpTo34_MarkObjGone
; ===========================================================================
; off_2D3A6:
Obj5C_Index:	offsetTable
		offsetTableEntry.w Obj5C_Init	; 0
		offsetTableEntry.w Obj5C_Main	; 2
; ===========================================================================
; loc_2D3AA:
Obj5C_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj5C_MapUnc_2D442,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Masher,0,0),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo58_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#9,collision_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.w	#-$400,y_vel(a0)
	move.w	y_pos(a0),Obj5C_initial_y_pos(a0)	; set initial (and lowest) y position
; loc_2D3E4:
Obj5C_Main:
	lea	(Ani_obj5C).l,a1
	jsrto	AnimateSprite, JmpTo16_AnimateSprite
	jsrto	ObjectMove, JmpTo22_ObjectMove
	addi.w	#$18,y_vel(a0)	; apply gravity
	move.w	Obj5C_initial_y_pos(a0),d0
	cmp.w	y_pos(a0),d0	; has object reached its initial y position?
	bhs.s	+		; if not, branch
	move.w	d0,y_pos(a0)
	move.w	#-$500,y_vel(a0)	; jump
+
	move.b	#1,anim(a0)
	subi.w	#$C0,d0
	cmp.w	y_pos(a0),d0
	bhs.s	+	; rts
	move.b	#0,anim(a0)
	tst.w	y_vel(a0)	; is object falling?
	bmi.s	+	; rts	; if not, branch
	move.b	#2,anim(a0)	; use closed mouth animation
+
	rts
; ===========================================================================
; animation script
; off_2D430:
Ani_obj5C:	offsetTable
		offsetTableEntry.w byte_2D436	; 0
		offsetTableEntry.w byte_2D43A	; 1
		offsetTableEntry.w byte_2D43E	; 2
byte_2D436:	dc.b   7,  0,  1,$FF
byte_2D43A:	dc.b   3,  0,  1,$FF
byte_2D43E:	dc.b   7,  0,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj5C_MapUnc_2D442:	include "mappings/sprite/obj5C.asm"

    if ~~removeJmpTos
	align 4
    endif
; ===========================================================================

    if ~~removeJmpTos
JmpTo34_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo16_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo58_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
; loc_2D48E:
JmpTo22_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif
