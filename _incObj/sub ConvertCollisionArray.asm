; ---------------------------------------------------------------------------
; This subroutine takes 'raw' bitmap-like collision block data as input and
; converts it into the proper collision arrays (ColArrayVertical and
; ColArrayHorizontal).
; Pointers to said raw data are dummied out.
; Curiously, an example of the original 'raw' data that this was intended
; to process can be found in the J2ME version of Sonic 1, in a file called
; 'blkcol.bct'.
; This subroutine exists in Sonic 1 as well, but was oddly changed in
; the S2 Nick Arcade prototype to just handle loading GHZ's collision
; instead (though it too is dummied out, hence collision being broken).
; ---------------------------------------------------------------------------

RawColBlocks		= ColArrayVertical
ConvRowColBlocks	= ColArrayVertical

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; return_1EAF0: FloorLog_Unk:
ConvertCollisionArray:
	rts
; ---------------------------------------------------------------------------
	; The raw format stores the collision data column by column for the normal collision array.
	; This makes a copy of the data, but stored row by row, for the rotated collision array.
	lea	(RawColBlocks).l,a1	; Source location of raw collision block data
	lea	(ConvRowColBlocks).l,a2	; Destinatation location for row-converted collision block data

	move.w	#$100-1,d3	; Number of blocks in collision data
.blockLoop:
	moveq	#16,d5		; Start on the 16th bit (the leftmost pixel)

	move.w	#16-1,d2	; Width of a block in pixels
.columnLoop:
	moveq	#0,d4

	move.w	#16-1,d1	; Height of a block in pixels
.rowLoop:
	move.w	(a1)+,d0	; Get row of collision bits
	lsr.l	d5,d0		; Push the selected bit of this row into the 'eXtend' flag
	addx.w	d4,d4		; Shift d4 to the left, and insert the selected bit into bit 0
	dbf	d1,.rowLoop	; Loop for each row of pixels in a block

	move.w	d4,(a2)+	; Store column of collision bits
	suba.w	#2*16,a1	; Back to the start of the block
	subq.w	#1,d5		; Get next bit in the row
	dbf	d2,.columnLoop	; Loop for each column of pixels in a block

	adda.w	#2*16,a1	; Next block
	dbf	d3,.blockLoop	; Loop for each block in the raw collision block data

	; This then converts the collision data into the final collision arrays
	lea	(ConvRowColBlocks).l,a1
	lea	(ColArrayHorizontal).l,a2	; Convert the row-converted collision block data into final rotated collision array
	bsr.s	.convertArrayToStandardFormat
	lea	(RawColBlocks).l,a1
	lea	(ColArrayVertical).l,a2		; Convert the raw collision block data into final normal collision array

; loc_1EB46: FloorLog_Unk2:
.convertArrayToStandardFormat:
	move.w	#$1000-1,d3	; Size of the collision array

.processCollisionArrayLoop:
	moveq	#0,d2
	move.w	#$F,d1
	move.w	(a1)+,d0	; Get current column of collision pixels
	beq.s	.noCollision	; Branch if there's no collision in this column
	bmi.s	.topPixelSolid	; Branch if top pixel of collision is solid

	; Here we count, starting from the bottom, how many pixels tall
	; the collision in this column is.
.processColumnLoop1:
	lsr.w	#1,d0
	bcc.s	.pixelNotSolid1
	addq.b	#1,d2
.pixelNotSolid1:
	dbf	d1,.processColumnLoop1

	bra.s	.columnProcessed
; ===========================================================================
.topPixelSolid:
	cmpi.w	#$FFFF,d0		; Is entire column solid?
	beq.s	.entireColumnSolid	; Branch if so

	; Here we count, starting from the top, how many pixels tall
	; the collision in this column is (the resulting number is negative).
.processColumnLoop2:
	lsl.w	#1,d0
	bcc.s	.pixelNotSolid2
	subq.b	#1,d2
.pixelNotSolid2:
	dbf	d1,.processColumnLoop2

	bra.s	.columnProcessed
; ===========================================================================
.entireColumnSolid:
	move.w	#16,d0

; loc_1EB78:
.noCollision:
	move.w	d0,d2

; loc_1EB7A:
.columnProcessed:
	move.b	d2,(a2)+	; Store column collision height
	dbf	d3,.processCollisionArrayLoop

	rts

; End of function ConvertCollisionArray
