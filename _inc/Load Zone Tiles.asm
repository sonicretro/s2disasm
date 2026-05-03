; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||



;sub_4E98:
LoadZoneTiles:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	lea	(LevelArtPointers).l,a2
	lea	(a2,d0.w),a2
	move.l	(a2)+,d0
	andi.l	#$FFFFFF,d0	; 8x8 tile pointer
	movea.l	d0,a0
	lea	(Chunk_Table).l,a1
	bsr.w	KosDec
	move.w	a1,d3
	cmpi.b	#hill_top_zone,(Current_Zone).w
	bne.s	+
	lea	(ArtKos_HTZ).l,a0
	lea	(Chunk_Table+tiles_to_bytes(ArtTile_ArtKos_NumTiles_HTZ_Main)).l,a1
	bsr.w	KosDec	; patch for HTZ
	move.w	#tiles_to_bytes(ArtTile_ArtKos_NumTiles_HTZ),d3
+
	cmpi.b	#wing_fortress_zone,(Current_Zone).w
	bne.s	+
	lea	(ArtKos_WFZ).l,a0
	lea	(Chunk_Table+tiles_to_bytes(ArtTile_ArtKos_NumTiles_WFZ_Main)).l,a1
	bsr.w	KosDec	; patch for WFZ
	move.w	#tiles_to_bytes(ArtTile_ArtKos_NumTiles_WFZ),d3
+
	cmpi.b	#death_egg_zone,(Current_Zone).w
	bne.s	+
	move.w	#tiles_to_bytes(ArtTile_ArtKos_NumTiles_DEZ),d3
+
	move.w	d3,d7
	andi.w	#$FFF,d3
	lsr.w	#1,d3
	rol.w	#4,d7
	andi.w	#$F,d7

-	move.w	d7,d2
	lsl.w	#7,d2
	lsl.w	#5,d2
	move.l	#$FFFFFF,d1
	move.w	d2,d1
	jsr	(QueueDMATransfer).l
	move.w	d7,-(sp)
	move.b	#VintID_TitleCard,(Vint_routine).w
	bsr.w	WaitForVint
	bsr.w	RunPLC_RAM
	move.w	(sp)+,d7
	move.w	#$800,d3
	dbf	d7,-

	rts
; End of function LoadZoneTiles

; ===========================================================================

	jmpTos JmpTo_loadZoneBlockMaps,JmpTo_DeformBgLayer,JmpTo_AniArt_Load,JmpTo_DrawInitialBG
