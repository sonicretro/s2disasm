; ===========================================================================
; ----------------------------------------------------------------------------
; Object DB - Sonic lying down or Tails nagging (on the continue screen)
; ----------------------------------------------------------------------------
; Sprite_7B82:
ObjDB:
	; a0=character
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjDB_Index(pc,d0.w),d1
	jsr	ObjDB_Index(pc,d1.w)
	jmp	(DisplaySprite).l
; ===========================================================================
; off_7B96: ObjDB_States:
ObjDB_Index:	offsetTable
		offsetTableEntry.w ObjDB_Sonic_Init	;  0
		offsetTableEntry.w ObjDB_Sonic_Wait	;  2
		offsetTableEntry.w ObjDB_Sonic_Run	;  4
		offsetTableEntry.w ObjDB_Tails_Init	;  6
		offsetTableEntry.w ObjDB_Tails_Wait	;  8
		offsetTableEntry.w ObjDB_Tails_Run	; $A
; ===========================================================================
; loc_7BA2:
ObjDB_Sonic_Init:
	addq.b	#2,routine(a0) ; => ObjDB_Sonic_Wait
	move.w	#$9C,x_pos(a0)
	move.w	#$19C,y_pos(a0)
	move.l	#Mapunc_Sonic,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtUnc_Sonic,0,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#2,priority(a0)
	move.b	#$20,anim(a0)

; loc_7BD2:
ObjDB_Sonic_Wait:
	tst.b	(Ctrl_1_Press).w	; is start pressed?
	bmi.s	ObjDB_Sonic_StartRunning ; if yes, branch
	jsr	(Sonic_Animate).l
	jmp	(LoadSonicDynPLC).l
; ---------------------------------------------------------------------------
; loc_7BE4:
ObjDB_Sonic_StartRunning:
	addq.b	#2,routine(a0) ; => ObjDB_Sonic_Run
	move.b	#$21,anim(a0)
	clr.w	inertia(a0)
	move.b	#SndID_SpindashRev,d0 ; super peel-out sound
	bsr.w	PlaySound

; loc_7BFA:
ObjDB_Sonic_Run:
	cmpi.w	#$800,inertia(a0)
	bne.s	+
	move.w	#$1000,x_vel(a0)
	bra.s	++
; ---------------------------------------------------------------------------
+
	addi.w	#$20,inertia(a0)
+
	jsr	(ObjectMove).l
	jsr	(Sonic_Animate).l
	jmp	(LoadSonicDynPLC).l
; ===========================================================================
; loc_7C22:
ObjDB_Tails_Init:
	addq.b	#2,routine(a0) ; => ObjDB_Tails_Wait
	move.w	#$B8,x_pos(a0)
	move.w	#$1A0,y_pos(a0)
	move.l	#ObjDA_MapUnc_7CB6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_ContinueTails,0,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#2,priority(a0)
	move.b	#0,anim(a0)

; loc_7C52:
ObjDB_Tails_Wait:
	tst.b	(Ctrl_1_Press).w	; is start pressed?
	bmi.s	ObjDB_Tails_StartRunning ; if yes, branch
	lea	(Ani_objDB).l,a1
	jmp	(AnimateSprite).l
; ---------------------------------------------------------------------------
; loc_7C64:
ObjDB_Tails_StartRunning:
	addq.b	#2,routine(a0) ; => ObjDB_Tails_Run
	move.l	#MapUnc_Tails,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtUnc_Tails,0,0),art_tile(a0)
	move.b	#0,anim(a0)
	clr.w	inertia(a0)
	move.b	#SndID_SpindashRev,d0 ; super peel-out sound
	bsr.w	PlaySound

; loc_7C88:
ObjDB_Tails_Run:
	cmpi.w	#$720,inertia(a0)
	bne.s	+
	move.w	#$1000,x_vel(a0)
	bra.s	++
; ---------------------------------------------------------------------------
+
	addi.w	#$18,inertia(a0)
+
	jsr	(ObjectMove).l
	jsr	(Tails_Animate).l
	jmp	(LoadTailsDynPLC).l