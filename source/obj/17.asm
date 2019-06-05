; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Object 17 - GHZ rotating log helix spikes (from Sonic 1, unused)
; the programming of this was modified somewhat between Sonic 1 and Sonic 2
; ----------------------------------------------------------------------------
; Sprite_10310:
Obj17:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj17_Index(pc,d0.w),d1
	jmp	Obj17_Index(pc,d1.w)
; ===========================================================================
; off_1031E:
Obj17_Index:	offsetTable
		offsetTableEntry.w Obj17_Init		; 0
		offsetTableEntry.w Obj17_Main		; 2
		offsetTableEntry.w Obj17_Display	; 4
; ===========================================================================
; loc_10324: Obj17_Main:
Obj17_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj17_MapUnc_10452,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_GHZ_Spiked_Log,2,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	move.b	#8,width_pixels(a0)
	move.w	y_pos(a0),d2
	move.w	x_pos(a0),d3
	_move.b	id(a0),d4
	lea	subtype(a0),a2	; move helix length to a2
	moveq	#0,d1
	move.b	(a2),d1	; move a2 to d1
	move.b	#0,(a2)+
	move.w	d1,d0
	lsr.w	#1,d0
	lsl.w	#4,d0
	sub.w	d0,d3
	subq.b	#2,d1
	bcs.s	Obj17_Main
	moveq	#0,d6
; loc_10372:
Obj17_MakeHelix:
	bsr.w	SingleObjLoad2
	bne.s	Obj17_Main
	addq.b	#1,subtype(a0)
	move.w	a1,d5
	subi.w	#Object_RAM,d5
    if object_size=$40
	lsr.w	#6,d5
    else
	divu.w	#object_size,d5
    endif
	andi.w	#$7F,d5
	move.b	d5,(a2)+
	move.b	#4,routine(a1)
	_move.b	d4,id(a1) ; load obj17
	move.w	d2,y_pos(a1)
	move.w	d3,x_pos(a1)
	move.l	mappings(a0),mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_GHZ_Spiked_Log,2,0),art_tile(a1)
	bsr.w	Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#3,priority(a1)
	move.b	#8,width_pixels(a1)
	move.b	d6,objoff_3E(a1)
	addq.b	#1,d6
	andi.b	#7,d6
	addi.w	#$10,d3
	cmp.w	x_pos(a0),d3
	bne.s	+
	move.b	d6,objoff_3E(a0)
	addq.b	#1,d6
	andi.b	#7,d6
	addi.w	#$10,d3
	addq.b	#1,subtype(a0)
+	dbf	d1,Obj17_MakeHelix ; repeat d1 times (helix length)

; loc_103E8: Obj17_Action:
Obj17_Main:
	bsr.w	Obj17_RotateSpike
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	Obj17_DelAll
	bra.w	DisplaySprite
; ===========================================================================
; loc_10404:
Obj17_DelAll:
	moveq	#0,d2
	lea	subtype(a0),a2	; move helix length to a2
	move.b	(a2)+,d2	; move a2 to d2
	subq.b	#2,d2
	bcs.s	BranchTo2_DeleteObject
; loc_10410:
Obj17_DelLoop:
	moveq	#0,d0
	move.b	(a2)+,d0
    if object_size=$40
	lsl.w	#6,d0
    else
	mulu.w	#object_size,d0
    endif
	addi.l	#Object_RAM,d0
	movea.l	d0,a1 ; a1=object
	bsr.w	DeleteObject2	; delete object
	dbf	d2,Obj17_DelLoop	; repeat d2 times (helix length)
; loc_10426:
BranchTo2_DeleteObject 
	bra.w	DeleteObject

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1042A:
Obj17_RotateSpike:
	move.b	(Logspike_anim_frame).w,d0
	move.b	#0,collision_flags(a0)	; make object harmless
	add.b	objoff_3E(a0),d0
	andi.b	#7,d0
	move.b	d0,mapping_frame(a0)	; change current frame
	bne.s	+	; rts
	move.b	#%10000100,collision_flags(a0)	; make object harmful
+
	rts
; End of function Obj17_RotateSpike

; ===========================================================================
; loc_1044A:
Obj17_Display:
	bsr.w	Obj17_RotateSpike
	bra.w	DisplaySprite
; ===========================================================================
; -----------------------------------------------------------------------------
; sprite mappings - helix of spikes on a pole (GHZ) (unused)
; -----------------------------------------------------------------------------
Obj17_MapUnc_10452:	BINCLUDE "mappings/sprite/obj17.bin"
; ===========================================================================

    if gameRevision<2
	nop
    endif
