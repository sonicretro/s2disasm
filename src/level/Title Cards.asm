;loc_15584: ; level title card drawing function called from Vint
DrawLevelTitleCard:
	lea	(VDP_data_port).l,a6
	tst.w	(TitleCard_ZoneName+titlecard_leaveflag).w
	bne.w	loc_15670
	moveq	#$3F,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6
	tst.w	(Two_player_mode).w
	beq.s	loc_155A8
	moveq	#$1F,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6

loc_155A8:
	lea	(TitleCard_Background+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)

loc_155AE:
	move.w	(a0)+,d0
	beq.s	loc_155C6
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d5,d4

loc_155C0:
	move.l	d6,(a6)
	dbf	d4,loc_155C0

loc_155C6:
	dbf	d7,loc_155AE
	moveq	#$26,d1
	sub.w	(TitleCard_Bottom+titlecard_split_point).w,d1
	lsr.w	#1,d1
	subq.w	#1,d1
	moveq	#7,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6
	tst.w	(Two_player_mode).w
	beq.s	loc_155EA
	moveq	#3,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6

loc_155EA:
	lea	(TitleCard_Bottom+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)

loc_155F0:
	move.w	(a0)+,d0
	beq.s	loc_15614
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	move.w	d5,d4

loc_155FE:
	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d1,d3

loc_15604:
	move.l	d6,(a6)
	dbf	d3,loc_15604
	addi.l	#vdpCommDelta(gameplay_plane_width/tile_width*2),d0
	dbf	d4,loc_155FE

loc_15614:
	dbf	d7,loc_155F0
	move.w	(TitleCard_Left+titlecard_split_point).w,d1 ; horizontal draw from left until this position
	subq.w	#1,d1
	moveq	#$D,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$58,0,0,0,1),d6 ; VRAM location of graphic to fill on left side
	tst.w	(Two_player_mode).w
	beq.s	loc_15634
	moveq	#6,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$58,0,0,0,1),d6 ; VRAM location of graphic to fill on left side (2p)

loc_15634:
	lea	(TitleCard_Left+titlecard_vram_dest).w,a0 ; obj34 red title card left side part
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)
	move.w	#$8F80,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0080

loc_15640:
	move.w	(a0)+,d0
	beq.s	loc_15664
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	move.w	d1,d4

loc_1564E:
	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d5,d3

loc_15654:
	move.l	d6,(a6)
	dbf	d3,loc_15654
	addi.l	#vdpCommDelta($0002),d0
	dbf	d4,loc_1564E

loc_15664:
	dbf	d7,loc_15640
	move.w	#$8F02,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0002
	rts
; ===========================================================================

loc_15670:
	moveq	#9,d3
	moveq	#3,d4
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6
	tst.w	(Two_player_mode).w
	beq.s	+
	moveq	#4,d3
	moveq	#1,d4
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6
+
	lea	(TitleCard_Left+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)
	move.w	#$8F80,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0080

loc_156A2:
	move.w	(a0)+,d0
	beq.s	loc_156CE
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	moveq	#3,d2

loc_156B0:
	move.l	d0,VDP_control_port-VDP_data_port(a6)

	move.w	d3,d1
-	move.l	d5,(a6)
	dbf	d1,-

	move.w	d4,d1
-	move.l	d6,(a6)
	dbf	d1,-

	addi.l	#vdpCommDelta($0002),d0
	dbf	d2,loc_156B0

loc_156CE:
	dbf	d7,loc_156A2
	move.w	#$8F02,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0002
	moveq	#7,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6
	tst.w	(Two_player_mode).w
	beq.s	+
	moveq	#3,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6
+
	lea	(TitleCard_Bottom+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)

loc_156F4:
	move.w	(a0)+,d0
	beq.s	loc_15714
	clr.w	-2(a0)
	jsr	sub_15792(pc)

	move.w	d5,d4
-	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.l	d6,(a6)
	move.l	d6,(a6)
	addi.l	#vdpCommDelta(gameplay_plane_width/tile_width*2),d0
	dbf	d4,-

loc_15714:
	dbf	d7,loc_156F4
	move.w	(TitleCard_Background+titlecard_vram_dest).w,d4
	beq.s	loc_1578C
	; Initialize plane A for both players; we have to do this here as otherwise
	; it will appear corrupted when the title card leaves.
	lea	VDP_control_port-VDP_data_port(a6),a5
	tst.w	(Two_player_mode).w
	beq.s	loc_15758
	lea	(Camera_X_pos_P2).w,a3
	lea	(Level_Layout).w,a4
	move.w	#vdpComm(VRAM_Plane_A_Name_Table_2P,VRAM,WRITE)>>16,d2

	moveq	#1,d6
-	movem.l	d4-d6,-(sp)
	moveq	#-$10,d5
	move.w	d4,d1
	bsr.w	CalculateVRAMAddressOfBlockForPlayer2
	move.w	d1,d4
	moveq	#-$10,d5
	moveq	#$1F,d6
	bsr.w	DrawBlockRow_CustomWidth
	movem.l	(sp)+,d4-d6
	addi.w	#$10,d4
	dbf	d6,-

loc_15758:
	lea	(Camera_X_pos).w,a3
	lea	(Level_Layout).w,a4
	move.w	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE)>>16,d2
	move.w	(TitleCard_Background+titlecard_vram_dest).w,d4

	moveq	#2-1,d6 ; Do two rows
-	movem.l	d4-d6,-(sp)
	moveq	#-16,d5
	move.w	d4,d1
	bsr.w	CalculateVRAMAddressOfBlockForPlayer1
	move.w	d1,d4
	moveq	#-16,d5
	moveq	#64/2-1,d6
	bsr.w	DrawBlockRow_CustomWidth
	movem.l	(sp)+,d4-d6
	addi.w	#16,d4
	dbf	d6,-

loc_1578C:
	clr.w	(TitleCard_Background+titlecard_vram_dest).w
	rts
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to convert a VRAM address into a 32-bit VRAM write command word
; Input:
;	d0	VRAM address (word)
; Output:
;	d0	32-bit VDP command word for a VRAM write to specified address.
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_15792:
	andi.l	#$FFFF,d0
	lsl.l	#2,d0
	lsr.w	#2,d0
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d0
	swap	d0
	rts
; End of function sub_15792

; ===========================================================================

;loc_157A4
LoadTitleCardSS:
	movem.l	d0/a0,-(sp)
	bsr.s	LoadTitleCard0
	movem.l	(sp)+,d0/a0
	bra.s	loc_157EC

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_157B0:
LoadTitleCard0:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_TitleCard),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_TitleCard).l,a0
	jsrto	JmpTo2_NemDec
	lea	(Level_Layout).w,a4
	lea	(ArtNem_TitleCard2).l,a0
	jmpto	JmpTo_NemDecToRAM
; ===========================================================================
; loc_157D2:
LoadTitleCard:
	bsr.s	LoadTitleCard0
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	move.b	Off_TitleCardLetters(pc,d0.w),d0
	lea	TitleCardLetters(pc),a0
	lea	(a0,d0.w),a0
	move.l	#vdpComm(tiles_to_bytes(ArtTile_LevelName),VRAM,WRITE),d0

loc_157EC:
	move	#$2700,sr
	lea	(Level_Layout).w,a1
	lea	(VDP_data_port).l,a6
	move.l	d0,4(a6)

loc_157FE:
	moveq	#0,d0
	move.b	(a0)+,d0
	bmi.s	loc_1581A
	lsl.w	#5,d0
	lea	(a1,d0.w),a2
	moveq	#0,d1
	move.b	(a0)+,d1
	lsl.w	#3,d1
	subq.w	#1,d1

loc_15812:
	move.l	(a2)+,(a6)
	dbf	d1,loc_15812
	bra.s	loc_157FE
; ===========================================================================

loc_1581A:
	move	#$2300,sr
	rts
; ===========================================================================
; byte_15820:
Off_TitleCardLetters: zoneOrderedTable 1,1
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; EHZ
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; Zone 1
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; WZ
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; Zone 3
	zoneTableEntry.b TitleCardLetters_MTZ - TitleCardLetters	; MTZ1,2
	zoneTableEntry.b TitleCardLetters_MTZ - TitleCardLetters	; MTZ3
	zoneTableEntry.b TitleCardLetters_WFZ - TitleCardLetters	; WFZ
	zoneTableEntry.b TitleCardLetters_HTZ - TitleCardLetters	; HTZ
	zoneTableEntry.b TitleCardLetters_HPZ - TitleCardLetters	; HPZ
	zoneTableEntry.b TitleCardLetters_EHZ - TitleCardLetters	; Zone 9
	zoneTableEntry.b TitleCardLetters_OOZ - TitleCardLetters	; OOZ
	zoneTableEntry.b TitleCardLetters_MCZ - TitleCardLetters	; MCZ
	zoneTableEntry.b TitleCardLetters_CNZ - TitleCardLetters	; CNZ
	zoneTableEntry.b TitleCardLetters_CPZ - TitleCardLetters	; CPZ
	zoneTableEntry.b TitleCardLetters_DEZ - TitleCardLetters	; DEZ
	zoneTableEntry.b TitleCardLetters_ARZ - TitleCardLetters	; ARZ
	zoneTableEntry.b TitleCardLetters_SCZ - TitleCardLetters	; SCZ
    zoneTableEnd
	even

 ; temporarily remap characters to title card letter format
 ; Characters are encoded as Aa, Bb, Cc, etc. through a macro
 charset 'A',0	; can't have an embedded 0 in a string
 charset 'B',"\4\8\xC\4\x10\x14\x18\x1C\x1E\x22\x26\x2A\4\4\x30\x34\x38\x3C\x40\x44\x48\x4C\x52\x56\4"
 charset 'a',"\4\4\4\4\4\4\4\4\2\4\4\4\6\4\4\4\4\4\4\4\4\4\6\4\4"
 charset '.',"\x5A"

; Defines which letters load for the continue screen
; Each letter occurs only once, and the letters ENOZ (i.e. ZONE) aren't loaded here
; However, this is hidden by the titleLetters macro, and normal titles can be used
; (the macro is defined near SpecialStage_ResultsLetters, which uses it before here)
; The actual mappings for zone title cards are found at MapUnc_TitleCards

; word_15832:
TitleCardLetters:

TitleCardLetters_EHZ:
	titleLetters	"EMERALD HILL"
TitleCardLetters_MTZ:
	titleLetters	"METROPOLIS"
TitleCardLetters_HTZ:
	titleLetters	"HILL TOP"
TitleCardLetters_HPZ:
	titleLetters	"HIDDEN PALACE"
TitleCardLetters_OOZ:
	titleLetters	"OIL OCEAN"
TitleCardLetters_MCZ:
	titleLetters	"MYSTIC CAVE"
TitleCardLetters_CNZ:
	titleLetters	"CASINO NIGHT"
TitleCardLetters_CPZ:
	titleLetters	"CHEMICAL PLANT"
TitleCardLetters_ARZ:
	titleLetters	"AQUATIC RUIN"
TitleCardLetters_SCZ:
	titleLetters	"SKY CHASE"
TitleCardLetters_WFZ:
	titleLetters	"WING FORTRESS"
TitleCardLetters_DEZ:
	titleLetters	"DEATH EGG"

 charset ; revert character set

; ===========================================================================

	jmpTos JmpTo2_NemDec,JmpTo_NemDecToRAM,JmpTo3_LoadPLC,JmpTo_sub_8476

; ===========================================================================
