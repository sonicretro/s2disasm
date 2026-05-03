; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Handles the decompression of the sound driver (Saxman compression, an LZSS variant)
; https://segaretro.org/Saxman_compression

; a4 == start of decompressed data (used for dictionary match offsets)
; a5 == current address of end of decompressed data
; a6 == current address in compressed sound driver
; d3 == length of match minus 1
; d4 == offset into decompressed data of dictionary match
; d5 == number of bytes decompressed so far
; d6 == descriptor field
; d7 == bytes left to decompress

; Interestingly, this appears to be a direct translation of the Z80 version in the sound driver
; (or maybe the Z80 version is a direct translation of this...)

; loc_EC04A:
DecompressSoundDriver:
	lea	Snd_Driver(pc),a6
; WARNING: the build script needs editing if you rename this label
movewZ80CompSize:	move.w	#Snd_Driver_End-Snd_Driver,d7 ; patched (by build.lua) after compression since the exact size can't be known beforehand
	moveq	#0,d6	; The decompressor knows it's run out of descriptor bits when it starts reading 0's in bit 8
	lea	(Z80_RAM).l,a5
	moveq	#0,d5
	lea	(Z80_RAM).l,a4
; loc_EC062:
SaxDec_Loop:
	lsr.w	#1,d6	; Next descriptor bit
	btst	#8,d6	; Check if we've run out of bits
	bne.s	+	; (lsr 'shifts in' 0's)
	jsr	SaxDec_GetByte(pc)
	move.b	d0,d6
	ori.w	#$FF00,d6	; These set bits will disappear from the high byte as the register is shifted
+
	btst	#0,d6
	beq.s	SaxDec_ReadCompressed

; SaxDec_ReadUncompressed:
	jsr	SaxDec_GetByte(pc)
	move.b	d0,(a5)+
	addq.w	#1,d5
	bra.w	SaxDec_Loop
; ---------------------------------------------------------------------------
; loc_EC086:
SaxDec_ReadCompressed:
	jsr	SaxDec_GetByte(pc)
	moveq	#0,d4
	move.b	d0,d4
	jsr	SaxDec_GetByte(pc)
	move.b	d0,d3
	andi.w	#$F,d3
	addq.w	#2,d3	; d3 is the length of the match minus 1
	andi.w	#$F0,d0
	lsl.w	#4,d0
	add.w	d0,d4
	addi.w	#$12,d4
	andi.w	#$FFF,d4	; d4 is the offset into the current $1000-byte window
	; This part is a little tricky. You see, d4 currently contains the low three nibbles of an offset into the decompressed data,
	; where the dictionary match lies. The way the high nibble is decided is first by taking it from d5 - the offset of the end
	; of the decompressed data so far. Then, we see if the resulting offset in d4 is somehow higher than d5.
	; If it is, then it's invalid... *unless* you subtract $1000 from it, in which case it refers to data in the previous $1000 block of bytes.
	; This is all just a really gimmicky way of having an offset with a range of $1000 bytes from the end of the decompressed data.
	; If, however, we cannot subtract $1000 because that would put the pointer before the start of the decompressed data, then
	; this is actually a 'zero-fill' match, which encodes a series of zeroes.
	move.w	d5,d0
	andi.w	#$F000,d0
	add.w	d0,d4
	cmp.w	d4,d5
	bhs.s	SaxDec_IsDictionaryReference
	subi.w	#$1000,d4
	bcc.s	SaxDec_IsDictionaryReference

; SaxDec_IsSequenceOfZeroes:
	add.w	d3,d5
	addq.w	#1,d5

-	move.b	#0,(a5)+
	dbf	d3,-

	bra.w	SaxDec_Loop
; ---------------------------------------------------------------------------
; loc_EC0CC:
SaxDec_IsDictionaryReference:
	add.w	d3,d5
	addq.w	#1,d5

-	move.b	(a4,d4.w),(a5)+
	addq.w	#1,d4
	dbf	d3,-

	bra.w	SaxDec_Loop
; End of function DecompressSoundDriver


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_EC0DE:
SaxDec_GetByte:
	move.b	(a6)+,d0
	subq.w	#1,d7	; Decrement remaining number of bytes
	bne.s	+
	addq.w	#4,sp	; Exit the decompressor by meddling with the stack
+
	rts
; End of function SaxDec_GetByte
