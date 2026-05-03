; ----------------------------------------------------------------------------
; Object C2 - Rivet thing you bust to get into ship at the end of WFZ
; ----------------------------------------------------------------------------
; Sprite_3C328:
ObjC2:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC2_Index(pc,d0.w),d1
	jmp	ObjC2_Index(pc,d1.w)
; ===========================================================================
; off_3C336:
ObjC2_Index:	offsetTable
		offsetTableEntry.w ObjC2_Init	; 0
		offsetTableEntry.w ObjC2_Main	; 2
; ===========================================================================
; BranchTo10_LoadSubObject
ObjC2_Init:
	bra.w	LoadSubObject
; ===========================================================================
; loc_3C33E:
ObjC2_Main:
	move.b	(MainCharacter+anim).w,objoff_30(a0)
	move.w	x_pos(a0),-(sp)
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jsrto	JmpTo27_SolidObject
	btst	#p1_standing_bit,status(a0)
	bne.s	ObjC2_Bust
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; loc_3C366:
ObjC2_Bust:
	cmpi.b	#2,objoff_30(a0)
	bne.s	+
	move.w	#$2880,(Camera_Min_X_pos).w
	bclr	#p1_standing_bit,status(a0)
	_move.b	#ObjID_Explosion,id(a0) ; load 0bj27 (transform into explosion)
	move.b	#2,routine(a0)
	bset	#status.player.in_air,(MainCharacter+status).w
	bclr	#status.player.on_object,(MainCharacter+status).w
	lea	(Level_Layout+$850).w,a1	; alter the level layout
	move.l	#$8A707172,(a1)+
	move.w	#$7374,(a1)+
	lea	(Level_Layout+$950).w,a1
	move.l	#$6E787978,(a1)+
	move.w	#$787A,(a1)+
	move.b	#1,(Screen_redraw_flag).w
+
	jmpto	JmpTo39_MarkObjGone
; ===========================================================================
; off_3C3B8:
ObjC2_SubObjData:
	subObjData ObjC2_MapUnc_3C3C2,make_art_tile(ArtTile_ArtNem_WfzSwitch,1,1),1<<render_flags.level_fg,4,$10,0
