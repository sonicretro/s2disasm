; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; loadZoneBlockMaps

; Loads block and bigblock mappings for the current Zone.

loadZoneBlockMaps:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	lea	(LevelArtPointers).l,a2
	lea	(a2,d0.w),a2
	move.l	a2,-(sp)
	addq.w	#4,a2
	move.l	(a2)+,d0
	andi.l	#$FFFFFF,d0	; pointer to block mappings
	movea.l	d0,a0
	lea	(Block_Table).w,a1
	jsrto	JmpTo_KosDec	; load block maps
	cmpi.b	#hill_top_zone,(Current_Zone).w
	bne.s	+
	lea	(Block_Table+$980).w,a1
	lea	(BM16_HTZ).l,a0
	jsrto	JmpTo_KosDec	; patch for Hill Top Zone block map
+
	tst.w	(Two_player_mode).w
	beq.s	+
	; In 2P mode, adjust the block table to halve the pattern index on each block
	lea	(Block_Table).w,a1

	move.w	#bytesToWcnt(Block_Table_End-Block_Table),d2
-	move.w	(a1),d0		; read an entry
	move.w	d0,d1
	andi.w	#$F800,d0	; filter for upper five bits
	andi.w	#$7FF,d1	; filter for lower eleven bits (patternIndex)
	lsr.w	#1,d1		; halve the pattern index
	or.w	d1,d0		; put the parts back together
	move.w	d0,(a1)+	; change the entry with the adjusted value
	dbf	d2,-
+
	move.l	(a2)+,d0
	andi.l	#$FFFFFF,d0	; pointer to chunk mappings
	movea.l	d0,a0
	lea	(Chunk_Table).l,a1
	jsrto	JmpTo_KosDec
	bsr.w	loadLevelLayout
	movea.l	(sp)+,a2	; zone specific pointer in LevelArtPointers
	addq.w	#4,a2
	moveq	#0,d0
	move.b	(a2),d0	; PLC2 ID
	beq.s	+
	jsrto	JmpTo_LoadPLC
+
	addq.w	#4,a2
	moveq	#0,d0
	move.b	(a2),d0	; palette ID
	jsrto	JmpTo_PalLoad_Now
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


loadLevelLayout:
	moveq	#0,d0
	move.w	(Current_ZoneAndAct).w,d0
	ror.b	#1,d0
	lsr.w	#6,d0
	lea	(Off_Level).l,a0
	move.w	(a0,d0.w),d0
	lea	(a0,d0.l),a0
	lea	(Level_Layout).w,a1
	jmpto	JmpTo_KosDec
; End of function loadLevelLayout

; ===========================================================================

;loadLevelLayout_Sonic1:
	; This loads level layout data in Sonic 1's format. Curiously, this
	; function has been changed since Sonic 1: in particular, it repeats
	; the rows of the source data to fill the rows of the destination
	; data, which provides some explanation for why so many of Sonic 2's
	; backgrounds are repeated in their layout data. This repeating is
	; needed to prevent Hidden Palace Zone's background from disappearing
	; when the player moves to the left.

	; Clear layout data.
	lea	(Level_Layout).w,a3
	move.w	#bytesToLcnt(Level_Layout_End-Level_Layout),d1
	moveq	#0,d0
-	move.l	d0,(a3)+
	dbf	d1,-

	; The rows of the foreground and background layouts are interleaved
	; in memory. This is done here:
	lea	(Level_Layout).w,a3	; Foreground.
	moveq	#0,d1			; Index into 'Off_Level' to get level foreground layout.
	bsr.w	.loadLayout
	lea	(Level_Layout+$80).w,a3	; Background.
	moveq	#2,d1			; Index into 'Off_Level' to get level background layout.

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E4A2:
.loadLayout:
	; This expects 'Off_Level' to be in the format that it was in
	; Sonic 1.
	moveq	#0,d0
	move.w	(Current_ZoneAndAct).w,d0
	ror.b	#1,d0
	lsr.w	#5,d0
	add.w	d1,d0
	lea	(Off_Level).l,a1
	move.w	(a1,d0.w),d0
	lea	(a1,d0.l),a1

	moveq	#0,d1
	move.w	d1,d2
	move.b	(a1)+,d1	; Layout width.
	move.b	(a1)+,d2	; Layout height.
	move.l	d1,d5
	addq.l	#1,d5
	moveq	#0,d3
	move.w	#$80,d3	; Size of layout row in memory.
	divu.w	d5,d3	; Get how many times to repeat the source row to fill the destination row.
	subq.w	#1,d3	; Turn into loop counter.

.nextRow:
	movea.l	a3,a0

	move.w	d3,d4
.repeatRow:
	move.l	a1,-(sp)

	move.w	d1,d0
.nextByte:
	move.b	(a1)+,(a0)+
	dbf	d0,.nextByte

	movea.l	(sp)+,a1
	dbf	d4,.repeatRow

	lea	(a1,d5.w),a1	; Next row in source data.
	lea	$100(a3),a3	; Next row in destination data.
	dbf	d2,.nextRow

	rts
; End of function .loadLayout

; ===========================================================================

;ConvertChunksFrom256x256To128x128:
	; This converts Sonic 1-style 256x256 chunks to Sonic 2-style 128x128
	; chunks.

	; Destination of 128x128 chunks.
	lea	($FE0000).l,a1
	lea	($FE0000+8*8*2).l,a2
	; Source of 256x256 chunks.
	lea	(Chunk_Table).l,a3

	move.w	#64-1,d1	; Process 64 256x256 chunks.
-	bsr.w	ConvertHalfOf256x256ChunkToTwo128x128Chunks
	bsr.w	ConvertHalfOf256x256ChunkToTwo128x128Chunks
	dbf	d1,-

	lea	($FE0000).l,a1
	lea	($FF0000).l,a2

	; Insert a blank chunk at the start of chunk table.
	move.w	#bytesToWcnt(8*8*2),d1
-	move.w	#0,(a2)+
	dbf	d1,-

	; Copy the actual chunks to after this blank chunk.
	move.w	#bytesToWcnt($8000-(8*8*2)),d1
-	move.w	(a1)+,(a2)+
	dbf	d1,-

	rts
; ===========================================================================

;EliminateChunkDuplicates:
	; This is a chunk de-duplicator.

	; Copy first chunk into 'Chunk_Table'.
	lea	($FE0000).l,a1
	lea	(Chunk_Table).l,a3

	moveq	#bytesToLcnt(8*8*2),d0
-	move.l	(a1)+,(a3)+
	dbf	d0,-

	moveq	#0,d7	; This holds how many chunks have been copied minus 1.
	lea	($FE0000).l,a1
	move.w	#$100-1,d5	; $100 chunks
;loc_E55A:
.nextChunk:
	lea	(Chunk_Table).l,a3
	move.w	d7,d6

.doNextComparison:
	movem.l	a1-a3,-(sp)

	; Compare chunks.
	move.w	#bytesToWcnt(8*8*2),d0
-	cmpm.w	(a1)+,(a3)+
	bne.s	+
	dbf	d0,-

	; The chunks match.
	movem.l	(sp)+,a1-a3
	adda.w	#8*8*2,a1
	dbf	d5,.nextChunk

	bra.s	++
; ===========================================================================
+
	; No match: check the next chunk.
	movem.l	(sp)+,a1-a3
	adda.w	#8*8*2,a3
	dbf	d6,.doNextComparison

	; Not a single match.

	; Add this chunk to the output.
	moveq	#bytesToLcnt(8*8*2),d0
-	move.l	(a1)+,(a3)+
	dbf	d0,-

	addq.l	#1,d7	; One more chunk has been added.
	dbf	d5,.nextChunk
/
	bra.s	-	; infinite loop

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_E59C:
ConvertHalfOf256x256ChunkToTwo128x128Chunks:
	moveq	#8-1,d0	 ; 8 rows.
-
	; Do a row of chunk 1 (a chunk is 8 blocks wide and tall).
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	; Do a row of chunk 2.
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	dbf	d0,-

	adda.w	#8*8*2,a1
	adda.w	#8*8*2,a2

	rts
; End of function ConvertHalfOf256x256ChunkToTwo128x128Chunks

; ===========================================================================

	jmpTos JmpTo_PalLoad_Now,JmpTo_LoadPLC,JmpTo_KosDec
