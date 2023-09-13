; ===========================================================================
; ----------------------------------------------------------------------------
; Object 52 - HTZ boss
; ----------------------------------------------------------------------------
; Sprite_2FC50:
Obj52:
	moveq	#0,d0
	move.b	boss_subtype(a0),d0
	move.w	Obj52_Index(pc,d0.w),d1
	jmp	Obj52_Index(pc,d1.w)
; ===========================================================================
; off_2FC5E:
Obj52_Index:	offsetTable
		offsetTableEntry.w Obj52_Init			; 0
		offsetTableEntry.w Obj52_Mobile			; 2
		offsetTableEntry.w Obj52_FlameThrower	; 4
		offsetTableEntry.w Obj52_LavaBall		; 6
		offsetTableEntry.w loc_30210			; 8
; ===========================================================================
; loc_2FC68:
Obj52_Init:
	move.l	#Obj52_MapUnc_302BC,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Eggpod_2,0,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#$90,mainspr_width(a0)
    if ~~fixBugs
	; This instruction is pointless, as bit 4 of 'render_flags' is never
	; set anyway. Also, it clashes with 'boss_invulnerable_time', as they
	; use the same SST slot. Unlike the Casino Night Zone boss, this does
	; not result in any bugs, because 'boss_invulnerable_time' is cleared
	; right after this.
	move.b	#$90,mainspr_height(a0)
    endif
	move.b	#4,priority(a0)
	move.w	#$3040,x_pos(a0)
	move.w	#$580,y_pos(a0)
	move.b	#1,boss_defeated(a0)
	move.b	#1,mainspr_mapframe(a0)
	addq.b	#2,boss_subtype(a0)
	bset	#6,render_flags(a0)
	move.b	#$32,collision_flags(a0)
	move.b	#8,boss_hitcount2(a0)
	move.w	#-$E0,(Boss_Y_vel).w
	move.w	x_pos(a0),(Boss_X_pos).w
	move.w	y_pos(a0),(Boss_Y_pos).w
	clr.b	boss_invulnerable_time(a0)
	move.w	x_pos(a0),sub2_x_pos(a0)
	move.w	y_pos(a0),sub2_y_pos(a0)
	move.b	#2,sub2_mapframe(a0)
	bsr.w	loc_2FCEA
	rts
; ===========================================================================

loc_2FCEA:
	lea	(Boss_AnimationArray).w,a2
	move.b	#6,(a2)+
	move.b	#0,(a2)+
	move.b	#$10,(a2)+
	move.b	#0,(a2)+
	rts
; ===========================================================================

; loc_2FD00:
Obj52_Mobile:
	moveq	#0,d0
	move.b	boss_routine(a0),d0
	move.w	off_2FD0E(pc,d0.w),d1
	jmp	off_2FD0E(pc,d1.w)
; ===========================================================================
off_2FD0E:	offsetTable
		offsetTableEntry.w Obj52_Mobile_Raise			; 0
		offsetTableEntry.w Obj52_Mobile_Flamethrower	; 2
		offsetTableEntry.w Obj52_Mobile_BeginLower		; 4
		offsetTableEntry.w Obj52_Mobile_Lower			; 6
		offsetTableEntry.w Obj52_Mobile_Defeated				; 8
; ===========================================================================

; loc_2FD18:
Obj52_Mobile_Raise:
	move.b	#0,(Boss_CollisionRoutine).w
	bsr.w	Boss_MoveObject
	tst.b	boss_defeated(a0)
	bne.s	loc_2FD32
	cmpi.w	#$518,(Boss_Y_pos).w
	bgt.s	loc_2FD50
	bra.s	loc_2FD3A
; ===========================================================================

loc_2FD32:
	cmpi.w	#$4FC,(Boss_Y_pos).w
	bgt.s	loc_2FD50

loc_2FD3A:
	move.w	#0,(Boss_Y_vel).w
	move.b	#4,boss_sine_count(a0)
	addq.b	#2,boss_routine(a0)
	move.b	#60,objoff_3E(a0)

loc_2FD50:
	move.w	(Boss_Y_pos).w,y_pos(a0)
	bsr.w	loc_300A4

    if removeJmpTos
JmpTo36_DisplaySprite ; JmpTo
    endif

	jmpto	DisplaySprite, JmpTo36_DisplaySprite
; ===========================================================================

; loc_2FD5E:
Obj52_Mobile_Flamethrower:
	subi_.b	#1,objoff_3E(a0)
	bpl.s	Obj52_Mobile_Hover
	move.b	#1,(Boss_CollisionRoutine).w
	move.b	#1,mainspr_childsprites(a0)
	cmpi.b	#-$18,objoff_3E(a0)
	bne.s	Obj52_Mobile_Hover
	jsrto	AllocateObject, JmpTo13_AllocateObject
	bne.s	loc_2FDAA
	_move.b	#ObjID_HTZBoss,id(a1) ; load obj52
	move.b	#4,boss_subtype(a1)
	move.b	render_flags(a0),render_flags(a1)
	andi.b	#1,render_flags(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#$2F,objoff_3E(a0)

loc_2FDAA:
	bsr.w	loc_300A4
	bsr.w	loc_2FEDE
	lea	(Ani_obj52).l,a1
	bsr.w	AnimateBoss
	jmpto	DisplaySprite, JmpTo36_DisplaySprite
; ===========================================================================

; loc_2FDC0:
Obj52_Mobile_Hover:
	move.b	boss_sine_count(a0),d0
	jsr	(CalcSine).l
	asr.w	#7,d1
	add.w	(Boss_Y_pos).w,d1
	move.w	d1,y_pos(a0)
	addq.b	#4,boss_sine_count(a0)
	bra.s	loc_2FDAA
; ===========================================================================

; loc_2FDDA:
Obj52_Mobile_BeginLower:
	move.b	#0,(Boss_CollisionRoutine).w
	move.b	#0,mainspr_childsprites(a0)
	move.b	#$10,(Boss_AnimationArray+2).w
	move.b	#0,(Boss_AnimationArray+3).w
	subi_.b	#1,objoff_3E(a0)
	bne.w	Obj52_Mobile_Hover
	move.w	#$E0,(Boss_Y_vel).w
	addq.b	#2,boss_routine(a0)
	bsr.w	loc_2FEDE
	jmpto	DisplaySprite, JmpTo36_DisplaySprite
; ===========================================================================

; loc_2FE0E:
Obj52_Mobile_Lower:
	bsr.w	Boss_MoveObject
	tst.b	boss_defeated(a0)
	bne.s	loc_2FE22
	cmpi.w	#$538,(Boss_Y_pos).w
	blt.s	loc_2FE58
	bra.s	Obj52_CreateLavaBall
; ===========================================================================

loc_2FE22:
	cmpi.w	#$548,(Boss_Y_pos).w
	blt.s	loc_2FE58

; loc_2FE2A
Obj52_CreateLavaBall:
	tst.b	objoff_38(a0)
	bne.s	loc_2FE58
	st.b	objoff_38(a0)
	jsrto	AllocateObject, JmpTo13_AllocateObject
	bne.s	loc_2FE58
	move.b	#ObjID_HTZBoss,id(a1) ; load obj52
	move.b	#6,boss_subtype(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#SndID_LavaBall,d0
	jsrto	PlaySound, JmpTo7_PlaySound

loc_2FE58:
	tst.b	boss_defeated(a0)
	bne.s	loc_2FE6E
	cmpi.w	#$5A0,(Boss_Y_pos).w
	blt.s	loc_2FED0
	move.w	#$5A0,(Boss_Y_pos).w
	bra.s	loc_2FE7C
; ===========================================================================

loc_2FE6E:
	cmpi.w	#$580,(Boss_Y_pos).w
	blt.s	loc_2FED0
	move.w	#$580,(Boss_Y_pos).w

loc_2FE7C:
	move.w	#-$E0,(Boss_Y_vel).w
	move.b	#0,boss_routine(a0)
	sf	objoff_38(a0)
	move.w	(MainCharacter+x_pos).w,d0
	subi.w	#$2FC0,d0
	bmi.s	loc_2FEA8
	move.w	#$580,(Boss_Y_pos).w
	move.w	#$3040,x_pos(a0)
	st.b	boss_defeated(a0)
	bra.s	loc_2FEB8
; ===========================================================================

loc_2FEA8:
	move.w	#$2F40,x_pos(a0)
	move.w	#$5A0,(Boss_Y_pos).w
	sf	boss_defeated(a0)

loc_2FEB8:
	move.w	x_pos(a0),d0
	cmp.w	(MainCharacter+x_pos).w,d0
	bgt.s	loc_2FECA
	bset	#0,render_flags(a0)
	bra.s	loc_2FED0
; ===========================================================================

loc_2FECA:
	bclr	#0,render_flags(a0)

loc_2FED0:
	move.w	(Boss_Y_pos).w,y_pos(a0)
	bsr.w	loc_300A4
	jmpto	DisplaySprite, JmpTo36_DisplaySprite
; ===========================================================================

loc_2FEDE:
	move.w	x_pos(a0),d0
	move.w	y_pos(a0),d1
	move.w	d0,sub2_x_pos(a0)
	move.w	d1,sub2_y_pos(a0)
	rts
; ===========================================================================

; loc_2FEF0:
Obj52_FlameThrower:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_2FEFE(pc,d0.w),d1
	jmp	off_2FEFE(pc,d1.w)
; ===========================================================================
off_2FEFE:	offsetTable
		offsetTableEntry.w loc_2FF02	; 0
		offsetTableEntry.w loc_2FF50	; 2
; ===========================================================================

loc_2FF02:
	move.l	#Obj52_MapUnc_302BC,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HTZBoss,0,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	addq.b	#2,routine_secondary(a0)
	move.b	#5,anim(a0)
	move.b	#$98,collision_flags(a0)
	subi.w	#$1C,y_pos(a0)
	move.w	#-$70,d0
	move.w	#-4,d1
	btst	#0,render_flags(a0)
	beq.s	loc_2FF46
	neg.w	d0
	neg.w	d1

loc_2FF46:
	add.w	d0,x_pos(a0)
	move.w	d1,x_vel(a0)
	rts
; ===========================================================================

loc_2FF50:
	move.w	x_vel(a0),d1
	add.w	d1,x_pos(a0)
	lea	(Ani_obj52).l,a1
	jsrto	AnimateSprite, JmpTo18_AnimateSprite
	jmpto	MarkObjGone, JmpTo37_MarkObjGone
; ===========================================================================

; loc_2FF66:
Obj52_LavaBall:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_2FF74(pc,d0.w),d1
	jmp	off_2FF74(pc,d1.w)
; ===========================================================================
off_2FF74:	offsetTable
		offsetTableEntry.w loc_2FF78	; 0
		offsetTableEntry.w loc_30008	; 2
; ===========================================================================

loc_2FF78:
	movea.l	a0,a1
	moveq	#0,d2
	moveq	#1,d1
	bra.s	loc_2FF94
; ===========================================================================

loc_2FF80:
	jsrto	AllocateObject, JmpTo13_AllocateObject
	bne.w	return_30006
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)

loc_2FF94:
	move.b	#ObjID_HTZBoss,id(a1) ; load obj52
	move.b	#6,boss_subtype(a1)
	move.l	#Obj52_MapUnc_302BC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_HTZBoss,0,0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#3,priority(a1)
	addq.b	#2,routine_secondary(a1)
	move.b	#7,anim(a1)
	move.b	#$8B,collision_flags(a1)
	move.b	d2,objoff_2E(a1)
	move.b	#8,y_radius(a1)
	move.b	#8,x_radius(a1)
	move.w	x_pos(a1),objoff_2A(a1)
	move.w	#$1C00,d0
	tst.w	d2
	bne.s	loc_2FFE8
	neg.w	d0

loc_2FFE8:
	move.w	d0,x_vel(a1)
	move.w	#-$5400,y_vel(a1)
	cmpi.w	#$2F40,x_pos(a1)
	beq.s	loc_30000
	move.w	#-$6400,y_vel(a1)

loc_30000:
	addq.w	#1,d2
	dbf	d1,loc_2FF80

return_30006:
	rts
; ===========================================================================

loc_30008:
	bsr.w	Obj52_LavaBall_Move
	jsrto	ObjCheckFloorDist, JmpTo4_ObjCheckFloorDist
	tst.w	d1
	bpl.s	loc_30064
	add.w	d1,y_pos(a0)
	move.b	#ObjID_LavaBubble,id(a0) ; load 0bj20
	move.b	#$A,routine(a0)
	move.b	#2,anim(a0)
	move.b	#4,mapping_frame(a0)
	move.w	#0,y_vel(a0)
	move.l	#Obj20_MapUnc_23294,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HtzFireball1,0,1),art_tile(a0)
	jsrto	Adjust2PArtPointer, JmpTo62_Adjust2PArtPointer
	move.b	#0,mapping_frame(a0)
	move.w	#9,objoff_32(a0)
	move.b	#3,objoff_36(a0)
	move.b	#SndID_FireBurn,d0
	jsrto	PlaySound, JmpTo7_PlaySound
	jmpto	Obj20, JmpTo_Obj20
; ===========================================================================

loc_30064:
	lea	(Ani_obj52).l,a1
	jsrto	AnimateSprite, JmpTo18_AnimateSprite
	jmpto	MarkObjGone, JmpTo37_MarkObjGone
; ===========================================================================

; loc_30072:
Obj52_LavaBall_Move:
	move.l	objoff_2A(a0),d2
	move.l	y_pos(a0),d3
	move.w	x_vel(a0),d0
	ext.l	d0
	asl.l	#4,d0
	add.l	d0,d2
	move.w	y_vel(a0),d0
	addi.w	#$380,y_vel(a0)
	ext.l	d0
	asl.l	#4,d0
	add.l	d0,d3
	move.l	d2,objoff_2A(a0)
	move.l	d3,y_pos(a0)
	move.w	objoff_2A(a0),x_pos(a0)
	rts
; ===========================================================================

loc_300A4:
	cmpi.b	#8,boss_routine(a0)
	bhs.s	return_300EA
	tst.b	boss_hitcount2(a0)
	beq.s	Obj52_Defeat
	tst.b	collision_flags(a0)
	bne.s	return_300EA
	tst.b	boss_invulnerable_time(a0)
	bne.s	loc_300CE
	move.b	#32,boss_invulnerable_time(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l

loc_300CE:
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	loc_300DC
	move.w	#$EEE,d0

loc_300DC:
	move.w	d0,(a1)
	subq.b	#1,boss_invulnerable_time(a0)
	bne.s	return_300EA
	move.b	#$32,collision_flags(a0)

return_300EA:
	rts
; ===========================================================================

; loc_300EC:
Obj52_Defeat:
	moveq	#100,d0
	jsrto	AddPoints, JmpTo4_AddPoints
	move.w	#$B3,(Boss_Countdown).w
	move.b	#8,boss_routine(a0)
	moveq	#PLCID_Capsule,d0
	jsrto	LoadPLC, JmpTo7_LoadPLC
	rts
; ===========================================================================

; loc_30106:
Obj52_Mobile_Defeated:
	move.b	#0,mainspr_childsprites(a0)
	subi_.w	#1,(Boss_Countdown).w
	bmi.s	loc_30142
	cmpi.w	#$1E,(Boss_Countdown).w
	bgt.s	Obj52_Mobile_UpdateExplosion
	move.b	#$10,mainspr_mapframe(a0)
	bsr.w	Boss_LoadExplosion
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.w	JmpTo36_DisplaySprite
	bsr.w	Obj52_CreateSmoke
	jmpto	DisplaySprite, JmpTo36_DisplaySprite
; ===========================================================================

; loc_3013A:
Obj52_Mobile_UpdateExplosion:
	bsr.w	Boss_LoadExplosion
	jmpto	DisplaySprite, JmpTo36_DisplaySprite
; ===========================================================================

loc_30142:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.w	Obj52_Mobile_Flee
	bsr.w	Obj52_CreateSmoke

; loc_30152:
Obj52_Mobile_Flee:
	cmpi.w	#-$3C,(Boss_Countdown).w
	bgt.w	JmpTo36_DisplaySprite
	tst.b	(Boss_defeated_flag).w
	bne.s	loc_30170
	jsrto	PlayLevelMusic, JmpTo3_PlayLevelMusic
	jsrto	LoadPLC_AnimalExplosion, JmpTo3_LoadPLC_AnimalExplosion
	move.b	#1,(Boss_defeated_flag).w

loc_30170:
	addq.w	#2,y_pos(a0)
	cmpi.w	#$3160,(Camera_Max_X_pos).w
	bhs.s	loc_30182
	addq.w	#2,(Camera_Max_X_pos).w
	bra.s	BranchTo_JmpTo36_DisplaySprite
; ===========================================================================

loc_30182:
	tst.b	render_flags(a0)
	bpl.s	loc_301AA
	tst.b	boss_defeated(a0)
	bne.s	loc_3019C
	cmpi.w	#$578,y_pos(a0)
	bgt.w	loc_301AA
	jmpto	DisplaySprite, JmpTo36_DisplaySprite
; ===========================================================================

loc_3019C:
	cmpi.w	#$588,y_pos(a0)
	bgt.w	loc_301AA

BranchTo_JmpTo36_DisplaySprite ; BranchTo
	jmpto	DisplaySprite, JmpTo36_DisplaySprite
; ===========================================================================

loc_301AA:
	move.w	#$3160,(Camera_Max_X_pos).w

    if removeJmpTos
JmpTo53_DeleteObject ; JmpTo
    endif

	jmpto	DeleteObject, JmpTo53_DeleteObject
; ===========================================================================

; loc_301B4:
Obj52_CreateSmoke
	jsrto	AllocateObject, JmpTo13_AllocateObject
	bne.s	return_3020E
	move.b	#ObjID_HTZBoss,id(a1) ; load obj52
	move.b	#8,boss_subtype(a1)
	move.l	#Obj52_MapUnc_30258,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_BossSmoke_2,0,0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#1,priority(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	x_pos(a0),objoff_2A(a1)
	subi.w	#$28,y_pos(a1)
	move.w	#-$60,x_vel(a1)
	move.w	#-$C0,y_vel(a1)
	move.b	#0,mapping_frame(a1)
	move.b	#$11,anim_frame_duration(a1)

return_3020E:
	rts
; ===========================================================================

loc_30210:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	loc_3022A
	move.b	#$11,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#4,mapping_frame(a0)
	beq.w	JmpTo53_DeleteObject

loc_3022A:
	move.l	objoff_2A(a0),d2
	move.l	y_pos(a0),d3
	move.w	x_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d2
	move.w	y_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d2,objoff_2A(a0)
	move.w	objoff_2A(a0),x_pos(a0)
	move.l	d3,y_pos(a0)
	jmpto	DisplaySprite, JmpTo36_DisplaySprite
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_BossSmoke
; ----------------------------------------------------------------------------
Obj52_MapUnc_30258:	include "mappings/sprite/obj52_a.asm"

; animation script
; off_30288:
Ani_obj52:	offsetTable
		offsetTableEntry.w byte_30298	; 0
		offsetTableEntry.w byte_3029D	; 1
		offsetTableEntry.w byte_302A2	; 2
		offsetTableEntry.w byte_302A7	; 3
		offsetTableEntry.w byte_302AC	; 4
		offsetTableEntry.w byte_302B0	; 5
		offsetTableEntry.w byte_302B4	; 6
		offsetTableEntry.w byte_302B7	; 7
byte_30298:	dc.b   1,  2,  3,$FD,  1
	rev02even
byte_3029D:	dc.b   2,  4,  5,$FD,  2
	rev02even
byte_302A2:	dc.b   3,  6,  7,$FD,  3
	rev02even
byte_302A7:	dc.b   4,  8,  9,$FD,  4
	rev02even
byte_302AC:	dc.b   5, $A, $B,$FE
	rev02even
byte_302B0:	dc.b   3, $C, $D,$FF
	rev02even
byte_302B4:	dc.b  $F,  1,$FF
	rev02even
byte_302B7:	dc.b   3, $E, $F,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_Eggpod + ?
; ----------------------------------------------------------------------------
Obj52_MapUnc_302BC:	include "mappings/sprite/obj52_b.asm"

    if ~~removeJmpTos
	align 4
    endif
; ===========================================================================

    if ~~removeJmpTos
JmpTo36_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo53_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo13_AllocateObject ; JmpTo
	jmp	(AllocateObject).l
JmpTo37_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo7_PlaySound ; JmpTo
	jmp	(PlaySound).l
JmpTo18_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo4_ObjCheckFloorDist ; JmpTo
	jmp	(ObjCheckFloorDist).l
JmpTo7_LoadPLC ; JmpTo
	jmp	(LoadPLC).l
JmpTo_Obj20 ; JmpTo
	jmp	(Obj20).l
JmpTo4_AddPoints ; JmpTo
	jmp	(AddPoints).l
JmpTo62_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo3_PlayLevelMusic ; JmpTo
	jmp	(PlayLevelMusic).l
JmpTo3_LoadPLC_AnimalExplosion ; JmpTo
	jmp	(LoadPLC_AnimalExplosion).l

	align 4
    endif
