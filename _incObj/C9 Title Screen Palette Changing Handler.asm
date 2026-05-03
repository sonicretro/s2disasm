; ----------------------------------------------------------------------------
; Object C9 - "Palette changing handler" from title screen
; ----------------------------------------------------------------------------
ttlscrpalchanger_fadein_time_left = objoff_30
ttlscrpalchanger_fadein_time = objoff_31
ttlscrpalchanger_fadein_amount = objoff_32
ttlscrpalchanger_start_offset = objoff_34
ttlscrpalchanger_length = objoff_36
ttlscrpalchanger_codeptr = objoff_3A

; Sprite_132F0:
ObjC9:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC9_Index(pc,d0.w),d1
	jmp	ObjC9_Index(pc,d1.w)
; ===========================================================================
ObjC9_Index:	offsetTable
		offsetTableEntry.w ObjC9_Init	; 0
		offsetTableEntry.w ObjC9_Main	; 2
; ===========================================================================

ObjC9_Init:
	addq.b	#2,routine(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lea	(PaletteChangerDataIndex).l,a1
	adda.w	(a1,d0.w),a1
	move.l	(a1)+,ttlscrpalchanger_codeptr(a0)
	movea.l	(a1)+,a2
	move.b	(a1)+,d0
	move.w	d0,ttlscrpalchanger_start_offset(a0)
	lea	(Target_palette).w,a3
	adda.w	d0,a3
	move.b	(a1)+,d0
	move.w	d0,ttlscrpalchanger_length(a0)

-	move.w	(a2)+,(a3)+
	dbf	d0,-

	move.b	(a1)+,d0
	move.b	d0,ttlscrpalchanger_fadein_time_left(a0)
	move.b	d0,ttlscrpalchanger_fadein_time(a0)
	move.b	(a1)+,ttlscrpalchanger_fadein_amount(a0)
	rts
; ===========================================================================

ObjC9_Main:
	subq.b	#1,ttlscrpalchanger_fadein_time_left(a0)
	bpl.s	+
	move.b	ttlscrpalchanger_fadein_time(a0),ttlscrpalchanger_fadein_time_left(a0)
	subq.b	#1,ttlscrpalchanger_fadein_amount(a0)
	bmi.w	DeleteObject
	movea.l	ttlscrpalchanger_codeptr(a0),a2
	movea.l	a0,a3
	move.w	ttlscrpalchanger_length(a0),d0
	move.w	ttlscrpalchanger_start_offset(a0),d1
	lea	(Normal_palette).w,a0
	adda.w	d1,a0
	lea	(Target_palette).w,a1
	adda.w	d1,a1

-	jsr	(a2)	; dynamic call! to Pal_FadeFromBlack.UpdateColour, loc_1344C, or loc_1348A, assuming the PaletteChangerData pointers haven't been changed
	dbf	d0,-

	movea.l	a3,a0
+
	rts
; ===========================================================================
; off_1337C:
PaletteChangerDataIndex: offsetTable
	offsetTableEntry.w off_1338C	;  0
	offsetTableEntry.w off_13398	;  2
	offsetTableEntry.w off_133A4	;  4
	offsetTableEntry.w off_133B0	;  6
	offsetTableEntry.w off_133BC	;  8
	offsetTableEntry.w off_133C8	; $A
	offsetTableEntry.w off_133D4	; $C
	offsetTableEntry.w off_133E0	; $E

C9PalInfo macro codeptr,dataptr,loadtoOffset,length,fadeinTime,fadeinAmount
	dc.l codeptr, dataptr
	dc.b loadtoOffset, length, fadeinTime, fadeinAmount
    endm

off_1338C:	C9PalInfo Pal_FadeFromBlack.UpdateColour, Pal_1342C, $60, $F,2,$15
off_13398:	C9PalInfo                      loc_1344C, Pal_1340C, $40, $F,4,7
off_133A4:	C9PalInfo                      loc_1344C,  Pal_AD1E,   0, $F,8,7
off_133B0:	C9PalInfo                      loc_1348A,  Pal_AD1E,   0, $F,8,7
off_133BC:	C9PalInfo                      loc_1344C,  Pal_AC7E,   0,$1F,4,7
off_133C8:	C9PalInfo                      loc_1344C,  Pal_ACDE, $40,$1F,4,7
off_133D4:	C9PalInfo                      loc_1344C,  Pal_AD3E,   0, $F,4,7
off_133E0:	C9PalInfo                      loc_1344C,  Pal_AC9E,   0,$1F,4,7

Pal_133EC:	BINCLUDE "art/palettes/Title Sonic.bin"
Pal_1340C:	BINCLUDE "art/palettes/Title Background.bin"
Pal_1342C:	BINCLUDE "art/palettes/Title Emblem.bin"

; ===========================================================================

loc_1344C:

	move.b	(a1)+,d2
	andi.b	#$E,d2
	move.b	(a0),d3
	cmp.b	d2,d3
	bls.s	loc_1345C
	subq.b	#2,d3
	move.b	d3,(a0)

loc_1345C:
	addq.w	#1,a0
	move.b	(a1)+,d2
	move.b	d2,d3
	andi.b	#$E0,d2
	andi.b	#$E,d3
	move.b	(a0),d4
	move.b	d4,d5
	andi.b	#$E0,d4
	andi.b	#$E,d5
	cmp.b	d2,d4
	bls.s	loc_1347E
	subi.b	#$20,d4

loc_1347E:
	cmp.b	d3,d5
	bls.s	loc_13484
	subq.b	#2,d5

loc_13484:
	or.b	d4,d5
	move.b	d5,(a0)+
	rts
; ===========================================================================

loc_1348A:
	moveq	#$E,d2
	move.b	(a0),d3
	and.b	d2,d3
	cmp.b	d2,d3
	bhs.s	loc_13498
	addq.b	#2,d3
	move.b	d3,(a0)

loc_13498:
	addq.w	#1,a0
	move.b	(a0),d3
	move.b	d3,d4
	andi.b	#$E0,d3
	andi.b	#$E,d4
	cmpi.b	#-$20,d3
	bhs.s	loc_134B0
	addi.b	#$20,d3

loc_134B0:
	cmp.b	d2,d4
	bhs.s	loc_134B6
	addq.b	#2,d4

loc_134B6:
	or.b	d3,d4
	move.b	d4,(a0)+
	rts
