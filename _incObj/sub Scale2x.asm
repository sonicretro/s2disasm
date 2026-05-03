; ---------------------------------------------------------------------------
; Subroutine to upscale graphics by a factor of 2x, based on given mappings
; data for correct positioning of tiles.
;
; This code is awfully structured and planned: whenever a 3-column sprite piece
; is scaled, it scales the next tiles that were copied to RAM as if the piece
; had 4 columns; this will then be promptly overwritten by the next piece. If
; this happens near the end of the buffer, you will get a buffer overrun.
; Moreover, when the number of rows in the sprite piece is also 3 or 4, the code
; will make an incorrect computation for the output of the next subpiece, which
; causes the output to overwrite art from the previous subpiece. Thus, this code
; fails if there is a 3x3 or a 3x4 sprite piece in the source mappings. Sadly,
; this issue is basically unfixable without rewriting the code entirely.
;
; Input:
; 	a1	Location of tiles to be enlarged
; 	a2	Destination buffer for enlarged tiles
; 	d0	Width-1 of sprite piece
; 	d1	Height-1 of sprite piece
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;loc_3E89E
Scale_2x:
	move.w	d1,d2					; Copy piece height-1
	andi.w	#1,d2					; Want only low bit -- this is 1 for Wx2 or Wx4 pieces, 0 otherwise
	addq.w	#1,d2					; Make it into 2 for Wx2 or Wx4 pieces, 1 otherwise
	lsl.w	#6,d2					; This is now $80 (4 tiles) for Wx2 or Wx4 pieces, $40 (2 tiles) otherwise
	swap	d2						; Save it to high word
	move.w	d1,d3					; Copy piece height-1 again
	lsr.w	#1,d3					; This time, want high bit (1 for Wx3 or Wx4, 0 for Wx2 or Wx1)
	addq.w	#1,d3					; Make it into 2 for Wx3 or Wx4 pieces, 1 otherwise
	lsl.w	#6,d3					; This is now $80 (4 tiles) for Wx3 or Wx4 pieces, $40 (2 tiles) otherwise
	swap	d3						; Save it to high word
	bsr.w	.upscale_part1				; Scale the first line???; sets a3 = ???, a5 = ???
	btst	#1,d0					; Is this a 1xH or a 2xH piece?
	beq.w	return_37A48				; Return if yes
	btst	#1,d1					; Is this a Wx3 or a Wx4 piece?
	bne.s	.set_dest				; Branch if yes
	movea.l	a3,a5					; Advance to next column instead

.set_dest:
	movea.l	a5,a2					; Set new output location

.upscale_part1:
	movea.l	a2,a4					; Copy destination to a4
	swap	d2					; Get height offset
	lea	(a2,d2.w),a3				; Output location for next tile
	swap	d2					; Save height offset again
	move.w	d1,d5					; Copy height-1
	andi.w	#1,d5					; How many tiles we want to do-1 -- this is 1 for Wx2 or Wx4 pieces, 0 otherwise
	bsr.w	Scale2x_SingleTile
	btst	#1,d1					; Are we upscaling a Wx3 or Wx4 piece?
	beq.s	.done_cols				; Branch if not
	swap	d2					; Get height offset
	move.w	d2,d4					; Copy it to d4
	swap	d2					; Save height offset again
	add.w	d4,d4					; This is now $100 (8 tiles) for Wx4 pieces, $80 (4 tiles) for Wx3 pieces
	move.w	d0,d3					; Copy piece width-1
	andi.w	#1,d3					; Want only low bit -- this is 1 for 2xH or 4xH pieces, 0 otherwise
	lsl.w	d3,d4					; This is now: $200 (16 tiles) for 2x4 or 4x4 pieces; $100 (8 tiles) for 2x3, 4x3, 1x4 or 3x4 pieces; $80 (4 tiles) for 1x3 or 3x3 pieces
	adda.w	d4,a4					; Advance to this location
	move.w	d1,d5					; Copy height-1
	lsr.w	#1,d5					; How many tiles we want to do-1 -- this is 1 for Wx4 pieces, 0 for Wx3 pieces
	swap	d3					; Get height offset
	lea	(a4,d3.w),a5				; Output location for next tile
	swap	d3					; Save height offset again
	bsr.w	Scale2x_SingleTile2

.done_cols:
	btst	#0,d0					; Is this a 1xH or 3xH piece?
	bne.s	.keep_upscaling				; Branch if not
	btst	#1,d0					; Was this a single column piece?
	beq.s	.done					; Return if so

.keep_upscaling:
	swap	d2					; Get height offset
	lea	(a2,d2.w),a2				; Output location for next tile
	lea	(a2,d2.w),a3				; Output location for next tile
	swap	d2					; Save height offset again
	move.w	d1,d5					; Copy height-1
	andi.w	#1,d5					; How many tiles we want to do -- this is 1 for Wx2 or Wx4 pieces, 0 otherwise
	bsr.w	Scale2x_SingleTile
	btst	#1,d1					; Are we upscaling a Wx3 or Wx4 piece?
	beq.s	.done					; Branch if not
	move.w	d1,d5					; Copy height-1
	lsr.w	#1,d5					; How many tiles we want to do-1 -- this is 1 for Wx4 or Wx3 pieces, 0 otherwise
	swap	d3					; Get height offset
	lea	(a4,d3.w),a4				; Output location for next tile
	lea	(a4,d3.w),a5				; Output location for next tile
	swap	d3					; Save height offset again
	bsr.w	Scale2x_SingleTile2

.done:
	rts
; ===========================================================================
; Upscales the given tile to the pair of tiles on the output pointers.
;
; Input:
; 	a1	Pixel source
; 	d5	Number of tiles-1 to upscale
; 	a2	Location of output tiles for left pixels
; 	a3	Location of output tiles for right pixels
; Output:
; 	a1	Pixel source after processed tiles
; 	a2	Location of output tiles for left pixels after scaled tiles
; 	a3	Location of output tiles for right pixels after scaled tiles
;loc_3E944
Scale2x_SingleTile:
	moveq	#7,d6					; 8 rows per tile

.loop:
	bsr.w	Scale_2x_LeftPixels			; Upscale pixels 0-3 of current row
	addq.w	#4,a2					; Advance write destination by one row (8 pixels)
	bsr.w	Scale_2x_RightPixels			; Upscale pixels 4-7 of current row
	addq.w	#4,a3					; Advance write destination by one row (8 pixels)
	dbf	d6,.loop

	dbf	d5,Scale2x_SingleTile

	rts
; ===========================================================================
; Upscales the given tile to the pair of tiles on the output pointers.
;
; Input:
; 	a1	Pixel source
; 	d5	Number of tiles-1 to upscale
; 	a4	Location of output tiles for left pixels
; 	a5	Location of output tiles for right pixels
; Output:
; 	a1	Pixel source after processed tiles
; 	a4	Location of output tiles for left pixels after scaled tiles
; 	a5	Location of output tiles for right pixels after scaled tiles
;loc_3E95C
Scale2x_SingleTile2:
	moveq	#7,d6					; 8 rows per tile

.loop:
	bsr.w	Scale_2x_LeftPixels2			; Upscale pixels 0-3 of current row
	addq.w	#4,a4					; Advance write destination by one row (8 pixels)
	bsr.w	Scale_2x_RightPixels2			; Upscale pixels 4-7 of current row
	addq.w	#4,a5					; Advance write destination by one row (8 pixels)
	dbf	d6,.loop

	dbf	d5,Scale2x_SingleTile2

	rts
; ===========================================================================
; Upscales the leftmost 4 pixels on the current row into the corresponding two
; rows of the output tile
;loc_3E974
Scale_2x_LeftPixels:
	bsr.w	.upscale_pixel_pair

.upscale_pixel_pair:
	move.b	(a1)+,d2				; Read two pixels
	move.b	d2,d3					; Save them
	andi.b	#$F0,d2					; Get left pixel
	move.b	d2,d4					; Copy it...
	lsr.b	#4,d4					; ...shift it down into place...
	or.b	d2,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a2)+				; Save to top tile, both on one row...
	move.b	d4,3(a2)				; ...and on the row below
	andi.b	#$F,d3					; Get saved right pixel
	move.b	d3,d4					; Copy it...
	lsl.b	#4,d4					; ...shift it up into place...
	or.b	d3,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a2)+				; Save to top tile, both on one row...
	move.b	d4,3(a2)				; ...and on the row below
	rts
; ===========================================================================
; Upscales the rightmost 4 pixels on the current row into the corresponding two
; rows of the output tile
;loc_3E99E
Scale_2x_RightPixels:
	bsr.w	.upscale_pixel_pair

.upscale_pixel_pair:
	move.b	(a1)+,d2				; Read two pixels
	move.b	d2,d3					; Save them
	andi.b	#$F0,d2					; Get left pixel
	move.b	d2,d4					; Copy it...
	lsr.b	#4,d4					; ...shift it down into place...
	or.b	d2,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a3)+				; Save to bottom tile, both on one row...
	move.b	d4,3(a3)				; ...and on the row below
	andi.b	#$F,d3					; Get saved right pixel
	move.b	d3,d4					; Copy it...
	lsl.b	#4,d4					; ...shift it up into place...
	or.b	d3,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a3)+				; Save to bottom tile, both on one row...
	move.b	d4,3(a3)				; ...and on the row below
	rts
; ===========================================================================
; Upscales the leftmost 4 pixels on the current row into the corresponding two
; rows of the output tile
;loc_3E9C8
Scale_2x_LeftPixels2:
	bsr.w	.upscale_pixel_pair

.upscale_pixel_pair:
	move.b	(a1)+,d2				; Read two pixels
	move.b	d2,d3					; Save them
	andi.b	#$F0,d2					; Get left pixel
	move.b	d2,d4					; Copy it...
	lsr.b	#4,d4					; ...shift it down into place...
	or.b	d2,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a4)+				; Save to top tile, both on one row...
	move.b	d4,3(a4)				; ...and on the row below
	andi.b	#$F,d3					; Get saved right pixel
	move.b	d3,d4					; Copy it...
	lsl.b	#4,d4					; ...shift it up into place...
	or.b	d3,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a4)+				; Save to top tile, both on one row...
	move.b	d4,3(a4)				; ...and on the row below
	rts
; ===========================================================================
; Upscales the rightmost 4 pixels on the current row into the corresponding two
; rows of the output tile
;loc_3E9F2
Scale_2x_RightPixels2:
	bsr.w	.upscale_pixel_pair

.upscale_pixel_pair:
	move.b	(a1)+,d2				; Read two pixels
	move.b	d2,d3					; Save them
	andi.b	#$F0,d2					; Get left pixel
	move.b	d2,d4					; Copy it...
	lsr.b	#4,d4					; ...shift it down into place...
	or.b	d2,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a5)+				; Save to bottom tile, both on one row...
	move.b	d4,3(a5)				; ...and on the row below
	andi.b	#$F,d3					; Get saved right pixel
	move.b	d3,d4					; Copy it...
	lsl.b	#4,d4					; ...shift it up into place...
	or.b	d3,d4					; ...and make it into two pixels of the same color
	move.b	d4,(a5)+				; Save to bottom tile, both on one row...
	move.b	d4,3(a5)				; ...and on the row below
	rts
