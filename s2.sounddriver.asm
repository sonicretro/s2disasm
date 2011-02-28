; Sonic the Hedgehog 2 disassembled Z80 sound driver

; Disassembled by Xenowhirl for AS
; ---------------------------------------------------------------------------
; NOTES:
;
; Set your editor's tab width to 8 characters wide for viewing this file.
;
; This code is compressed in the rom, but you can edit it here as uncompressed
; and it will automatically be assembled and compressed into the correct place
; during the build process.
;
; This Z80 code can use labels and equates defined in the 68k code,
; and the 68k code can use the labels and equates defined in here.
; This is fortunate, as they contain references to each other's addresses.
;
; If you want to add significant amounts of extra code to this driver,
; I suggest putting your code as far down as possible, after the function zloc_12FC.
; That will make you less likely to run into space shortages from dislocated data alignment.
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; setup defines and macros and stuff

    ; in what I believe is an unfortunate design choice in AS,
    ; both the phased and unphased PCs must be within the target processor's range,
    ; which means phase is useless here despite being designed to fix this problem...
    ; oh well, I set it up to fix this later when processing the .p file
    !org 0 ; Z80 code starting at address 0 has special meaning to s2p2bin.exe

    CPU Z80UNDOC
    listing off

; equates: standard (for Genesis games) addresses in the memory map
zYM2612_A0 =	4000h
zYM2612_D0 =	4001h
zYM2612_A1 =	4002h
zYM2612_D1 =	4003h
zBankRegister =	6000h
zPSG =		7F11h
z68kMemory =	8000h
; more equates: addresses specific to this program (besides labeled addresses)
zMusicData =	1380h ; don't change this unless you change all the pointers in the BINCLUDE'd music too...
zComRange =	zMusicData+800h ; 1B80h ; most communication between Z80 and 68k happens in here, among other things (like stack storage)
zSFXToPlay =	zComRange+9
zMusicToPlay =	zComRange+0Ch
; see the very end for another set of variables


; macro to perform a bank switch... after using this,
; the start of z68kMemory points to the start of the given 68k address,
; rounded down to the nearest $8000 byte boundary
bankswitch macro addr68k
	xor	a	; a = 0
	ld	e,1	; e = 1
	ld	hl,zBankRegister
cnt	:= 0
	rept 9
		; this is either ld (hl),a or ld (hl),e
		db (73h|((((addr68k)&(1<<(15+cnt)))==0)<<2))
cnt		:= (cnt+1)
	endm
    endm

; macro to make a certain error message clearer should you happen to get it...
rsttarget macro {INTLABEL}
	if ($&7)||($>38h)
		fatal "Function __LABEL__ is at 0\{$}h, but must be at a multiple of 8 bytes <= 38h to be used with the rst instruction."
	endif
	if "__LABEL__"<>""
__LABEL__ label $
	endif
    endm

; function to decide whether an offset's full range won't fit in one byte
offsetover1byte function from,maxsize, ((from&0FFh)>(100h-maxsize))

; macro to make sure that ($ & 0FF00h) == (($+maxsize) & 0FF00h)
ensure1byteoffset macro maxsize
	if offsetover1byte($,maxsize)
startpad := $
		align 100h
	    if MOMPASS=1
endpad := $
		if endpad-startpad>=1h
			; warn because otherwise you'd have no clue why you're running out of space so fast
			warning "had to insert \{endpad-startpad}h   bytes of padding before improperly located data at 0\{startpad}h in Z80 code"
		endif
	    endif
	endif
    endm

; function to turn a 68k address into a word the Z80 can use to access it,
; assuming the correct bank has been switched to first
zmake68kPtr function addr,z68kMemory+(addr&7FFFh)


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Z80 'ROM' start:
;zEntryPoint:
	di	; disable interrupts
	ld	sp,zComRange ; sp = zComRange
	jp	zloc_167
; ---------------------------------------------------------------------------
; zbyte_7:
zPalModeByte:
	db	0

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
	align	8
zsub_8:    rsttarget
	ld	a,(zYM2612_A0)
	add	a,a
	jr	c,zsub_8
	ret
; End of function zsub_8

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
	align	8
zsub_10:    rsttarget
	bit	2,(ix+1)
	jr	z,zsub_18
	jr	zsub_28
; End of function zsub_10

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
	align	8
zsub_18:    rsttarget
	push	af
	rst	zsub_8 ; 'rst' is like 'call' but only works for 8-byte aligned addresses <= 38h
	pop	af
	ld	(zYM2612_A0),a
	push	af
	rst	zsub_8
	ld	a,c
	ld	(zYM2612_D0),a
	pop	af
	ret
; End of function zsub_18

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
	align	8
zsub_28:    rsttarget
	push	af
	rst	zsub_8
	pop	af
	ld	(zYM2612_A1),a
	push	af
	rst	zsub_8
	ld	a,c
	ld	(zYM2612_D1),a
	pop	af
	ret
; End of function zsub_28

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
	align	8
zsub_38:    rsttarget
	push	af
	exx
	call	zBankSwitchToMusic
	xor	a
	ld	(zReadyFlag),a
	ld	ix,zComRange
	ld	a,(zComRange+3)
	or	a
	jr	z,zloc_51
	call	zsub_600
	jp	zloc_CC
; ---------------------------------------------------------------------------

zloc_51:
	ld	a,(zComRange+4)
	or	a
	call	nz,zsub_AD1
	ld	a,(zComRange+0Eh)
	or	a
	call	nz,zsub_BE8
	ld	a,(zSFXToPlay)
	or	(ix+0Ah)
	or	(ix+0Bh)
	call	nz,zsub_674
	ld	a,(zComRange+8)
	cp	80h
	call	nz,zPlaySoundByIndex
	ld	a,(zSpindashPlayingCounter)
	or	a
	jr	z,+ ; if the spindash counter is already 0, branch
	dec	a ; decrease the spindash sound playing counter
	ld	(zSpindashPlayingCounter),a
+
	ld	hl,zPalModeByte
	ld	a,(zComRange+17h)
	and	(hl)
	jr	z,+
	ld	hl,zbyte_12FE
	dec	(hl)
	jr	nz,+
	ld	(hl),5
	call	zsub_110
+
	call	zsub_110

	bankswitch SoundIndex

	ld	a,80h
	ld	(zReadyFlag),a
	ld	b,3

-	push	bc
	ld	de,2Ah
	add	ix,de
	bit	7,(ix+0)
	call	nz,zsub_237
	pop	bc
	djnz	-

	ld	b,3

-	push	bc
	ld	de,2Ah
	add	ix,de
	bit	7,(ix+0)
	call	nz,zsub_414
	pop	bc
	djnz	-

zloc_CC:

	bankswitch SndDAC_Start

	ld	a,(zCurDAC)
	or	a
	jp	m,+
	exx
	ld	b,1
	pop	af
	ei		; enable interrupts
	ret
+
	ld	a,80h
	ex	af,af'	;'
	ld	a,(zCurDAC)
	sub	81h
	ld	(zCurDAC),a
	add	a,a
	add	a,a
	add	a,zbyte_1233&0FFh
	ld	(zloc_104+1),a	; store into the instruction after zloc_104 (self-modifying code)
	add	a,zbyte_1235-zbyte_1233
	ld	(zloc_107+2),a	; store into the instruction after zloc_107 (self-modifying code)
	pop	af
	ld	hl,zloc_178
	ex	(sp),hl

zloc_104:
	ld	hl,(zbyte_1233)	; "self-modified code"

zloc_107:
	ld	de,(zbyte_1235)	; "self-modified code"

zloc_10B:
	ld	bc,100h ; "self-modified code"
	ei		; enable interrupts
	ret
; End of function zsub_38


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

zsub_110:
	call	zsub_14C
	ld	a,0FFh
	ld	(zComRange+7),a
	ld	ix,zComRange+18h
	bit	7,(ix+0)
	call	nz,zloc_1E3
	xor	a
	ld	(zComRange+7),a
	ld	b,6

-	push	bc
	ld	de,2Ah
	add	ix,de
	bit	7,(ix+0)
	call	nz,zsub_237
	pop	bc
	djnz	-

	ld	b,3

-	push	bc
	ld	de,2Ah
	add	ix,de
	bit	7,(ix+0)
	call	nz,zsub_414
	pop	bc
	djnz	-

	ret
; End of function zsub_110


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_14C:
	ld	ix,zComRange
	ld	a,(ix+2)
	add	a,(ix+1)
	ld	(ix+1),a
	ret	c
	ld	hl,zComRange+23h
	ld	de,2Ah
	ld	b,0Ah

-	inc	(hl)
	add	hl,de
	djnz	-
	
	ret
; End of function zsub_14C

; ---------------------------------------------------------------------------

zloc_167:
	im	1	; set interrupt mode 1
	call	zsub_B52
	ei		; enable interrupts
	ld	iy,zbyte_1B3
	ld	de,0

; zloc_174:
zWaitLoop:
	ld	a,d
	or	e
	jr	z,zWaitLoop

zloc_178:
	djnz	$

	di		; disable interrupts
	ld	a,2Ah
	ld	(zYM2612_A0),a
	ld	a,(hl)
	rlca
	rlca
	rlca
	rlca
	and	0Fh
	ld	(zloc_18B+2),a	; store into the instruction after zloc_18B (self-modifying code)
	ex	af,af'	;'
zloc_18B:
	add	a,(iy+0)
	ld	(zYM2612_D0),a
	ex	af,af'	;'
	ld	b,c
	ei		; enable interrupts

	djnz	$

	di		; disable interrupts
	push	af
	pop	af
	ld	a,2Ah
	ld	(zYM2612_A0),a
	ld	b,c
	ld	a,(hl)
	inc	hl
	dec	de
	and	0Fh
	ld	(zloc_1A8+2),a	; store into the instruction after zloc_1A8 (self-modifying code)
	ex	af,af'	;'
zloc_1A8:
	add	a,(iy+0)
	ld	(zYM2612_D0),a
	ex	af,af'	;'
	ei		; enable interrupts
	jp	zWaitLoop

; ---------------------------------------------------------------------------
; unknown (DAC?) data
	ensure1byteoffset 10h
zbyte_1B3:
	db	   0,	 1,   2,   4,   8,  10h,  20h,  40h
	db	 80h,	-1,  -2,  -4,  -8, -10h, -20h, -40h
	ensure1byteoffset 10h
zbyte_1C3:
	db	 16h, 1Ch,    0,   0, 40h,  1Ch,  6Ah,  1Ch
	db	-42h, 1Ch, -18h, 1Ch, 12h,  1Dh,  12h,  1Dh
	ensure1byteoffset 10h
zbyte_1D3:
	db	 3Ch, 1Dh,    0,   0, 66h,  1Dh, -70h,  1Dh
	db	-46h, 1Dh, -1Ch, 1Dh, 0Eh,  1Eh,  0Eh,  1Eh
; ---------------------------------------------------------------------------

zloc_1E3:
	dec	(ix+0Bh)
	ret	nz
	ld	l,(ix+3)
	ld	h,(ix+4)

-	ld	a,(hl)
	inc	hl
	cp	0E0h
	jr	c,+
	call	zloc_C89
	jp	-
+
	or	a
	jp	p,zloc_20E
	ld	(ix+0Dh),a
	ld	a,(hl)
	or	a
	jp	p,zloc_20D
	ld	a,(ix+0Ch)
	ld	(ix+0Bh),a
	jr	zloc_211
; ---------------------------------------------------------------------------

zloc_20D:
	inc	hl

zloc_20E:
	call	zsub_2A9

zloc_211:
	ld	(ix+3),	l
	ld	(ix+4),	h
	bit	2,(ix+0)
	ret	nz
	ld	a,(ix+0Dh)
	cp	80h
	ret	z
	sub	81h
	add	a,a
	add	a,zDACMasterPlaylist&0FFh
	ld	(zloc_22A+2),a	; store into the instruction after zloc_22A (self-modifying code)
zloc_22A:
	ld	bc,(zDACMasterPlaylist)
	ld	a,c
	ld	(zCurDAC),a
	ld	a,b
	ld	(zloc_10B+1),a	; store into the instruction after zloc_10B (self-modifying code)
	ret

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_237:
	dec	(ix+0Bh)
	jr	nz,+
	res	4,(ix+0)
	call	zsub_258
	call	zloc_3E5
	call	zsub_C46
	call	zsub_2FB
	jp	zloc_3F5
+
	call	zsub_2E3
	call	zsub_2FB
	jp	zloc_3F5
; End of function zsub_237


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_258:
	ld	l,(ix+3)
	ld	h,(ix+4)
	res	1,(ix+0)

-	ld	a,(hl)
	inc	hl
	cp	0E0h
	jr	c,+
	call	zloc_C89
	jr	-
+
	push	af
	call	zsub_C56
	pop	af
	or	a
	jp	p,+
	call	zGetFrequency
	ld	a,(hl)
	or	a
	jp	m,zloc_2BA
	inc	hl
+
	call	zsub_2A9
	jp	zloc_2BA
; End of function zsub_258

; ---------------------------------------------------------------------------
; zloc_285:
zGetFrequency:
	sub	80h
	jr	z,zloc_29D
	add	a,(ix+5)
	add	a,a
	add	a,zFrequencies&0FFh
	ld	(zloc_292+2),a	; store into the instruction after zloc_292 (self-modifying code)
;	ld	d,a
;	adc	a,(zFrequencies&0FF00h)>>8
;	sub	d
;	ld	(zloc_292+3),a	; this is how you could store the high byte of the pointer too (unnecessary if it's in the right range)
zloc_292:
	ld	de,(zFrequencies)
	ld	(ix+0Dh),e
	ld	(ix+0Eh),d
	ret
; ---------------------------------------------------------------------------

zloc_29D:
	set	1,(ix+0)
	xor	a
	ld	(ix+0Dh),a
	ld	(ix+0Eh),a
	ret

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_2A9:
	ld	c,a
	ld	b,(ix+2)

-	djnz	+
	ld	(ix+0Ch),a
	ld	(ix+0Bh),a
	ret
+
	add	a,c
	jp	-
; End of function zsub_2A9

; ---------------------------------------------------------------------------

zloc_2BA:
	ld	(ix+3),	l
	ld	(ix+4),	h
	ld	a,(ix+0Ch)
	ld	(ix+0Bh),a
	bit	4,(ix+0)
	ret	nz
	ld	a,(ix+10h)
	ld	(ix+0Fh),a
	ld	(ix+9),	0
	bit	3,(ix+0)
	ret	z
	ld	l,(ix+11h)
	ld	h,(ix+12h)
	jp	zloc_EBB

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_2E3:
	ld	a,(ix+0Fh)
	or	a
	ret	z
	dec	(ix+0Fh)
	ret	nz
	set	1,(ix+0)
	pop	de
	bit	7,(ix+1)
	jp	nz,zsub_526
	jp	zsub_C56
; End of function zsub_2E3


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_2FB:
	pop	de
	bit	1,(ix+0)
	ret	nz
	bit	3,(ix+0)
	ret	z
	ld	a,(ix+13h)
	or	a
	jr	z,+
	dec	(ix+13h)
	ret
+
	dec	(ix+14h)
	ret	nz
	ld	l,(ix+11h)
	ld	h,(ix+12h)
	inc	hl
	ld	a,(hl)
	ld	(ix+14h),a
	ld	a,(ix+16h)
	or	a
	jr	nz,+
	inc	hl
	inc	hl
	ld	a,(hl)
	ld	(ix+16h),a
	ld	a,(ix+15h)
	neg
	ld	(ix+15h),a
	ret
+
	dec	(ix+16h)
	ld	l,(ix+17h)
	ld	h,(ix+18h)
	ld	b,0
	ld	c,(ix+15h)
	bit	7,c
	jp	z,+
	ld	b,0FFh
+
	add	hl,bc
	ld	(ix+17h),l
	ld	(ix+18h),h
	ld	c,(ix+0Dh)
	ld	b,(ix+0Eh)
	add	hl,bc
	ex	de,hl
	jp	(hl)
; End of function zsub_2FB

; ---------------------------------------------------------------------------
; seems to be an array of values for the PSG
; the same array is found at $729CE in Sonic 1, and at $C9C44 in Ristar
; zword_359:
	ensure1byteoffset 8Ch
zPSGWaveArray:
	dw	356h,  326h, 2F9h, 2CEh, 2A5h, 280h, 25Ch, 23Ah
	dw	21Ah,  1FBh, 1DFh, 1C4h, 1ABh, 193h, 17Dh, 167h
	dw	153h,  140h, 12Eh, 11Dh, 10Dh, 0FEh, 0EFh, 0E2h
	dw	0D6h,  0C9h, 0BEh, 0B4h, 0A9h, 0A0h,  97h,  8Fh
	dw	 87h,   7Fh,  78h,  71h,  6Bh,  65h,  5Fh,  5Ah
	dw	 55h,   50h,  4Bh,  47h,  43h,  40h,  3Ch,  39h
	dw	 36h,   33h,  30h,  2Dh,  2Bh,  28h,  26h,  24h
	dw	 22h,   20h,  1Fh,  1Dh,  1Bh,  1Ah,  18h,  17h
	dw	 16h,   15h,  13h,  12h,  11h,    0
; ---------------------------------------------------------------------------

zloc_3E5:
	bit	1,(ix+0)
	ret	nz
	ld	e,(ix+0Dh)
	ld	d,(ix+0Eh)
	ld	a,d
	or	e
	jp	z,zloc_4C5

zloc_3F5:
	bit	2,(ix+0)
	ret	nz
	ld	h,0
	ld	l,(ix+19h)
	bit	7,l
	jr	z,+
	ld	h,0FFh
+
	add	hl,de
	ld	c,h
	ld	a,(ix+1)
	and	3
	add	a,0A4h
	rst	zsub_10
	ld	c,l
	sub	4
	rst	zsub_10
	ret

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_414:
	dec	(ix+0Bh)
	jr	nz,+
	res	4,(ix+0)
	call	zsub_438
	call	zsub_487
	call	zsub_4CF
	call	zsub_2FB
	jp	zloc_493
+
	call	zsub_2E3
	call	zsub_4CA
	call	zsub_2FB
	jp	zloc_493
; End of function zsub_414


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_438:
	ld	l,(ix+3)
	ld	h,(ix+4)
	res	1,(ix+0)

-	ld	a,(hl)
	inc	hl
	cp	0E0h
	jr	c,+
	call	zloc_C89
	jr	-
+
	or	a
	jp	p,+
	call	zloc_460
	ld	a,(hl)
	or	a
	jp	m,zloc_2BA
	inc	hl
+
	call	zsub_2A9
	jp	zloc_2BA
; End of function zsub_438

; ---------------------------------------------------------------------------

zloc_460:
	sub	81h ; a = a-$81
	jr	c,+
	add	a,(ix+5)
	add	a,a
	add	a,zPSGWaveArray&0FFh
	ld	(zloc_46D+2),a	; store into the instruction after zloc_46D (self-modifying code)
zloc_46D:
	ld	de,(zPSGWaveArray)
	ld	(ix+0Dh),e
	ld	(ix+0Eh),d
	ret
+
	set	1,(ix+0)
	ld	a,0FFh
	ld	(ix+0Dh),a
	ld	(ix+0Eh),a
	jp	zsub_526

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_487:
	bit	7,(ix+0Eh)
	jr	nz,zloc_4C5
	ld	e,(ix+0Dh)
	ld	d,(ix+0Eh)

zloc_493:
	ld	a,(ix+0)
	and	6
	ret	nz
	ld	h,0
	ld	l,(ix+19h)
	bit	7,l
	jr	z,+
	ld	h,0FFh
+
	add	hl,de
	ld	a,(ix+1)
	cp	0E0h
	jr	nz,+
	ld	a,0C0h
+
	ld	b,a
	ld	a,l
	and	0Fh
	or	b
	ld	(zPSG),a
	ld	a,l
	srl	h
	rra
	srl	h
	rra
	rra
	rra
	and	3Fh
	ld	(zPSG),a
	ret
; ---------------------------------------------------------------------------

zloc_4C5:
	set	1,(ix+0)
	ret
; End of function zsub_487


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_4CA:
	ld	a,(ix+8)
	or	a
	ret	z
; End of function zsub_4CA


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_4CF:
	ld	b,(ix+6)
	ld	a,(ix+8)
	or	a
	jr	z,zloc_4F9
	ld	hl,zPSG_Index
	dec	a
	add	a,a
	ld	e,a
	ld	d,0
	add	hl,de
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	add	a,(ix+9)
	ld	l,a
	adc	a,h
	sub	l
	ld	h,a
	ld	a,(hl)
	inc	(ix+9)
	or	a
	jp	p,+
	cp	80h
	jr	z,zloc_522
+
	add	a,b
	ld	b,a

zloc_4F9:
	ld	a,(ix+0)
	and	6
	ret	nz
	bit	4,(ix+0)
	jr	nz,zloc_515

zloc_505:
	ld	a,b
	cp	10h
	jr	c,+
	ld	a,0Fh
+
	or	(ix+1)
	or	10h
	ld	(zPSG),a
	ret
; ---------------------------------------------------------------------------

zloc_515:
	ld	a,(ix+10h)
	or	a
	jr	z,zloc_505
	ld	a,(ix+0Fh)
	or	a
	jr	nz,zloc_505
	ret
; ---------------------------------------------------------------------------

zloc_522:
	dec	(ix+9)
	ret
; End of function zsub_4CF


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_526:
	bit	2,(ix+0)
	ret	nz
	ld	a,(ix+1)
	or	1Fh
	ld	(zPSG),a
	ret
; End of function zsub_526

; ---------------------------------------------------------------------------
; lookup table of note frequencies for instruments and sound effects
	ensure1byteoffset 0C0h
; zbyte_534:
zFrequencies:
	dw   25Eh,  284h,  2ABh,  2D3h,  2FEh,  32Dh,  35Ch,  38Fh
	dw   3C5h,  3FFh,  43Ch,  47Ch, 0A5Eh, 0A84h, 0AABh, 0AD3h
	dw  0AFEh, 0B2Dh, 0B5Ch, 0B8Fh, 0BC5h, 0BFFh, 0C3Ch, 0C7Ch
	dw  125Eh, 1284h, 12ABh, 12D3h, 12FEh, 132Dh, 135Ch, 138Fh
	dw  13C5h, 13FFh, 143Ch, 147Ch, 1A5Eh, 1A84h, 1AABh, 1AD3h
	dw  1AFEh, 1B2Dh, 1B5Ch, 1B8Fh, 1BC5h, 1BFFh, 1C3Ch, 1C7Ch
	dw  225Eh, 2284h, 22ABh, 22D3h, 22FEh, 232Dh, 235Ch, 238Fh
	dw  23C5h, 23FFh, 243Ch, 247Ch, 2A5Eh, 2A84h, 2AABh, 2AD3h
	dw  2AFEh, 2B2Dh, 2B5Ch, 2B8Fh, 2BC5h, 2BFFh, 2C3Ch, 2C7Ch
	dw  325Eh, 3284h, 32ABh, 32D3h, 32FEh, 332Dh, 335Ch, 338Fh
	dw  33C5h, 33FFh, 343Ch, 347Ch, 3A5Eh, 3A84h, 3AABh, 3AD3h
	dw  3AFEh, 3B2Dh, 3B5Ch, 3B8Fh, 3BC5h, 3BFFh, 3C3Ch, 3C7Ch ; 96 entries


zloc_5F4:
	ld	hl,zPSG
	ld	(hl),9Fh
	ld	(hl),0BFh
	ld	(hl),0DFh
	ld	(hl),0FFh
	ret

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_600:
	jp	m,+
	ld	a,(zPaused)
	or	a
	ret	nz
	ld	a,0FFh
	ld	(zPaused),a
	call	zsub_B36
	jp	zloc_5F4
+
	push	ix
	ld	(ix+3),0
	xor	a
	ld	(zPaused),a
	ld	ix,zComRange+18h
	ld	b,7
	call	zsub_64D

	bankswitch MusicPoint2

	ld	a,0FFh
	ld	(zReadyFlag),a
	ld	ix,1D3Ch
	ld	b,3
	call	zsub_64D
	xor	a
	ld	(zReadyFlag),a
	call	zBankSwitchToMusic
	pop	ix
	ret
; End of function zsub_600


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_64D:
	bit	7,(ix+0)
	jr	z,+
	bit	2,(ix+0)
	jr	nz,+
	ld	c,(ix+7)
	ld	a,(ix+1)
	and	3
	add	a,0B4h
	rst	zsub_10
	push	bc
	ld	c,(ix+8)
	call	zsub_E12
	pop	bc
+
	ld	de,2Ah
	add	ix,de
	djnz	zsub_64D
	ret
; End of function zsub_64D


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_674:
	ld	a,(zComRange+8)
	cp	80h
	ret	nz
	ld	hl,zSFXToPlay
	ld	a,(zComRange)
	ld	c,a
	ld	b,3

zloc_683:
	ld	a,(hl)
	ld	e,a
	ld	(hl),0
	inc	hl	; hl = zSFXToPlay2
	cp	MusID__First
	jr	c,zloc_6AA
	cp	MusID_StopSFX
	jr	nc,zsub_6AD
	sub	SndID__First
	jr	c,zsub_6AD
	add	a,zbyte_FD8h&0FFh
	ld	l,a
	adc	a,(zbyte_FD8h&0FF00h)>>8
	sub	l
	ld	h,a
	ld	a,(hl)
	cp	c
	jr	c,+
	ld	c,a
	call	zsub_6AD
+
	ld	a,c
	or	a
	ret	m
	ld	(zComRange),a
	ret
; ---------------------------------------------------------------------------

zloc_6AA:
	djnz	zloc_683
	ret
; End of function zsub_674


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_6AD:
	ld	a,e
	ld	(zComRange+8),a
	ret
; End of function zsub_6AD


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; zsub_6B2:
zPlaySoundByIndex:
	or	a		; is it sound 00?
	jp	z,zsub_B52	; if yes, branch
    if MusID__First-1 == 80h
	ret	p		; return if id is lower than 80h
    else
	cp	MusID__First
	ret	c		; return if id is less than the first music id
    endif
	ld	(ix+8),80h
	cp	MusID__End	; is it music (less than index 20)?
	jp	c,zPlayMusic	; if yes, branch to play the music
	cp	SndID__First	; is it not a sound? (this check is redundant if MusID__End == SndID__First...)
	ret	c		; if it isn't a sound, return (do nothing)
	cp	SndID__End	; is it a regular sound (less than index 71)?
	jp	c,zPlaySound_CheckRing ; if yes, branch to play the sound
	cp	MusID_StopSFX	; is it after the last regular sound but before the first special sound command (between 71 and 78)?
	ret	c		; if yes, return (do nothing)
	cp	MusID_Pause	; is it sound 7E or 7F (pause all or resume all)?
	ret	nc		; if yes, return (those get handled elsewhere)
	sub	MusID_StopSFX	; convert index 78-7D to a lookup into the following jump table
	add	a,a
	add	a,a
	ld	(zloc_6D5+1),a	; store into the instruction after zloc_6D5 (self-modifying code)

	ensure1byteoffset 17h
zloc_6D5:
	jr	$
; ---------------------------------------------------------------------------
	jp	zStopSoundEffects ; sound test index 78
	nop
; ---------------------------------------------------------------------------
	jp	zFadeOutMusic ; 79
	nop
; ---------------------------------------------------------------------------
	jp	zPlaySegaSound ; 7A
	nop
; ---------------------------------------------------------------------------
	jp	zSpeedUpMusic ; 7B
	nop
; ---------------------------------------------------------------------------
	jp	zSlowDownMusic ; 7C
	nop
; ---------------------------------------------------------------------------
	jp	zStopSoundAndMusic ; 7D
	nop
; ---------------------------------------------------------------------------
; zloc_6EF:
zPlaySegaSound:
	ld	a,2Bh
	ld	c,80h
	rst	zsub_18

	bankswitch Snd_Sega

	ld	hl,zmake68kPtr(Snd_Sega) ; was: 9E8Ch
	ld	de,30BAh
	ld	a,2Ah
	ld	(zYM2612_A0),a
	ld	c,80h

zloc_710:
	ld	a,(hl)
	ld	(zYM2612_D0),a
	inc	hl
	nop
	ld	b,0Ch
	djnz	$

	nop
	ld	a,(zComRange+8)
	cp	c
	jr	nz,+
	ld	a,(hl)
	ld	(zYM2612_D0),a
	inc	hl
	nop
	ld	b,0Ch
	djnz	$
	
	nop
	dec	de
	ld	a,d
	or	e
	jp	nz,zloc_710
+
	call	zBankSwitchToMusic
	ld	a,(zComRange+15h)
	ld	c,a
	ld	a,2Bh
	rst	zsub_18
	ret
; ---------------------------------------------------------------------------
; zloc_73D:
zPlayMusic:
	push	af
	call	zStopSoundEffects
	pop	af
	ld	(zCurSong),a
	cp	MusID_ExtraLife
	jr	nz,zloc_784
	ld	a,(zComRange+11h)
	or	a
	jr	nz,zloc_78E
	ld	ix,zComRange+18h
	ld	de,2Ah
	ld	b,0Ah

-	res	2,(ix+0)
	add	ix,de
	djnz	-

	ld	ix,1D3Ch
	ld	b,6

-	res	7,(ix+0)
	add	ix,de
	djnz	-

	ld	de,1E38h
	ld	hl,zComRange
	ld	bc,1BCh
	ldir
	ld	a,80h
	ld	(zComRange+11h),a
	xor	a
	ld	(zComRange),a
	jr	zloc_78E
; ---------------------------------------------------------------------------

zloc_784:
	xor	a
	ld	(zComRange+11h),a
	ld	(zComRange+10h),a
	ld	(zComRange+4),a

zloc_78E:
	call	zsub_B78
	ld	a,(zCurSong)
	sub	MusID__First
	ld	e,a
	ld	d,0
	ld	hl,zbyte_1214
	add	hl,de
	ld	a,(hl)
	ld	(zComRange+13h),a
	ld	hl,zMasterPlaylist
	add	hl,de
	ld	a,(hl)
	ld	b,a
	and	80h
	ld	(zComRange+16h),a
	ld	a,b
	add	a,a
	add	a,a
	ld	c,a
	ccf
	sbc	a,a
	ld	(zComRange+17h),a
	ld	a,c
	add	a,a
	sbc	a,a
	push	af
	ld	a,b
	and	1Fh
	add	a,a
	ld	e,a
	ld	d,0
	ld	hl,z68kMemory
	add	hl,de
	push	hl
	call	zBankSwitchToMusic
	pop	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	pop	af
	or	a
	jr	nz,+
	ex	de,hl
	exx
	push	hl
	push	de
	push	bc
	exx
	call	zsub_1271
	exx
	pop	bc
	pop	de
	pop	hl
	exx
	ld	de,zMusicData
+
	push	de
	pop	ix
	ld	e,(ix+0)
	ld	d,(ix+1)
	ld	(zMusicToPlay),de
	ld	a,(ix+5)
	ld	(zComRange+12h),a
	ld	b,a
	ld	a,(zComRange+14h)
	or	a
	ld	a,b
	jr	z,+
	ld	a,(zComRange+13h)
+
	ld	(zComRange+2),a
	ld	(zComRange+1),a
	ld	a,5
	ld	(zbyte_12FE),a
	push	ix
	pop	hl
	ld	de,6
	add	hl,de
	ld	a,(ix+2)
	or	a
	jp	z,zloc_884
	ld	b,a
	push	iy
	ld	iy,zComRange+18h
	ld	c,(ix+4)
	ld	de,zbyte_916

-	ld	(iy+0),82h
	ld	a,(de)
	inc	de
	ld	(iy+1),a
	ld	(iy+2),c
	ld	(iy+0Ah),2Ah
	ld	(iy+7),0C0h
	ld	(iy+0Bh),1
	push	de
	push	bc
	ld	a,iyl
	add	a,3
	ld	e,a
	adc	a,iyu
	sub	e
	ld	d,a
	ldi
	ldi
	ldi
	ldi
	ld	de,2Ah
	add	iy,de
	pop	bc
	pop	de
	djnz	-

	pop	iy
	ld	a,(ix+2)
	cp	7
	jr	nz,+
	xor	a
	ld	c,a
	jr	zloc_87E
+
	ld	a,28h
	ld	c,6
	rst	zsub_18
	ld	a,42h
	ld	c,0FFh
	ld	b,4

-	rst	zsub_28
	add	a,4
	djnz	-

	ld	a,0B6h
	ld	c,0C0h
	rst	zsub_28
	ld	a,80h
	ld	c,a

zloc_87E:
	ld	(zComRange+15h),a
	ld	a,2Bh
	rst	zsub_18

zloc_884:
	ld	a,(ix+3)
	or	a
	jp	z,zloc_8D0
	ld	b,a
	push	iy
	ld	iy,1CBEh
	ld	c,(ix+4)
	ld	de,zbyte_91D

-	ld	(iy+0),82h
	ld	a,(de)
	inc	de
	ld	(iy+1),a
	ld	(iy+2),c
	ld	(iy+0Ah),2Ah
	ld	(iy+0Bh),1
	push	de
	push	bc
	ld	a,iyl
	add	a,3
	ld	e,a
	adc	a,iyu
	sub	e
	ld	d,a
	ldi
	ldi
	ldi
	ldi
	inc	hl
	ld	a,(hl)
	inc	hl
	ld	(iy+8),a
	ld	de,2Ah
	add	iy,de
	pop	bc
	pop	de
	djnz	-

	pop	iy

zloc_8D0:
	ld	ix,1D3Ch
	ld	b,6
	ld	de,2Ah

zloc_8D9:
	bit	7,(ix+0)
	jr	z,zloc_8FB
	ld	a,(ix+1)
	or	a
	jp	m,+
	sub	2
	add	a,a
	jr	zloc_8F1
+
	rra
	rra
	rra
	rra
	and	0Fh

zloc_8F1:
	add	a,zbyte_1C3&0FFh
	ld	(zloc_8F6+1),a	; store into the instruction after zloc_8F6 (self-modifying code)
zloc_8F6:
	ld	hl,(zbyte_1C3)
	res	2,(hl)

zloc_8FB:
	add	ix,de
	djnz	zloc_8D9
	ld	ix,1BC2h
	ld	b,6

-	call	zsub_C56
	add	ix,de
	djnz	-

	ld	b,3

-	call	zsub_526
	add	ix,de
	djnz	-

	ret

; ---------------------------------------------------------------------------
; unknown data
zbyte_916:
	db    6,   0,   1,   2,   4,   5,   6
; unknown
zbyte_91D:
	db  80h,0A0h,0C0h

; zloc_920:
zPlaySound_CheckRing:
	ld	c,a
	ld	a,(ix+11h)
	or	(ix+0Eh)
	jp	nz,zloc_A37
	xor	a
	ld	(zSpindashActiveFlag),a
	ld	a,c
	cp	SndID_Ring ; is this the ring sound?
	jr	nz,zPlaySound_CheckGloop ; if not, branch
	ld	a,(zRingSpeaker)
	or	a
	jr	nz,+
	ld	c,SndID_RingLeft ; do something different (probably speaker change)...
+
	cpl
	ld	(zRingSpeaker),a
	jp	zPlaySound ; now play the play the ring sound
; ---------------------------------------------------------------------------
; zloc_942:
zPlaySound_CheckGloop:
	ld	a,c
	cp	SndID_Gloop ; is this the bloop/gloop noise?
	jr	nz,zPlaySound_CheckSpindash ; if not, branch
	ld	a,(zGloopFlag)
	cpl
	ld	(zGloopFlag),a
	or	a
	ret	z ; sometimes don't play it
	jp	zPlaySound ; now play the play the gloop sound
; ---------------------------------------------------------------------------
; zloc_953:
zPlaySound_CheckSpindash:
	ld	a,c
	cp	SndID_SpindashRev ; is this the spindash rev sound playing?
	jr	nz,zPlaySound ; if not, branch

	ld	a,(zSpindashPlayingCounter)
	or	a
	ld	a,(zSpindashExtraFrequencyIndex)
	jr	nz,+ ; if the spindash sound is already playing, branch
	ld	a,-1 ; reset the extra frequency (becomes 0 on the next line)
+
	inc	a ; increase the frequency
	cp	0Ch
	jr	nc,+
	ld	(zSpindashExtraFrequencyIndex),a
+
	ld	a,3Ch
	ld	(zSpindashPlayingCounter),a
	ld	a,-1
	ld	(zSpindashActiveFlag),a

; zloc_975:
zPlaySound:

	bankswitch SoundIndex

	ld	hl,zmake68kPtr(SoundIndex) ; was: 0EE91h
	ld	a,c
	sub	SndID__First
	add	a,a
	ld	e,a
	ld	d,0
	add	hl,de ; now hl points to a pointer in the SoundIndex list (such as rom_ptr_z80 Sound20)
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a ; now hl points to a sound's data (such as Sound20: ...)
	ld	e,(hl)
	inc	hl
	ld	d,(hl) ; now de is the first two bytes of the sound data... which is either 0 or a pointer to somewhere else in the sound
	inc	hl
	ld	(zloc_A26+1),de	; store into the instruction after zloc_A26 (self-modifying code)
	ld	c,(hl)
	inc	hl
	ld	b,(hl) ; now bc is the second two bytes of the sound data
	inc	hl

zloc_99F:
	push	bc
	xor	a
	ld	(zloc_A1D+1),a ; store into the instruction after zloc_A1D (self-modifying code)
	push	hl
	inc	hl
	ld	a,(hl)
	or	a
	jp	m,+
	sub	2
	add	a,a
	jp	zloc_9CA
+
	ld	(zloc_A1D+1),a	; store into the instruction after zloc_A1D (self-modifying code)
	cp	0C0h
	jr	nz,+
	push	af
	or	1Fh
	ld	(zPSG),a
	xor	20h
	ld	(zPSG),a
	pop	af
+
	rra
	rra
	rra
	rra
	and	0Fh

zloc_9CA:
	add	a,zbyte_1C3&0FFh
	ld	(zloc_9CF+1),a	; store into the instruction after zloc_9CF (self-modifying code)
zloc_9CF:
	ld	hl,(zbyte_1C3) ; "self-modified code"
	set	2,(hl)
	add	a,zbyte_1D3-zbyte_1C3
	ld	(zloc_9D9+2),a	; store into the instruction after zloc_9D9 (self-modifying code)
zloc_9D9:
	ld	ix,(zbyte_1D3) ; "self-modified code"
	ld	e,ixl
	ld	d,ixu
	push	de
	ld	l,e
	ld	h,d
	ld	(hl),0
	inc	de
	ld	bc,29h
	ldir
	pop	de
	pop	hl
	ldi
	ldi
	pop	bc
	push	bc
	ld	(ix+2),c
	ld	(ix+0Bh),1
	ld	(ix+0Ah),2Ah
	ld	a,e
	add	a,1
	ld	e,a
	adc	a,d
	sub	e
	ld	d,a
	ldi
	ldi
	ldi
	ld	a,(zSpindashActiveFlag)
	or	a
	jr	z,+
	ld	a,(zSpindashExtraFrequencyIndex)
	dec	de
	ex	de,hl
	add	a,(hl)
	ex	de,hl
	ld	(de),a
	inc	de
+
	ldi
zloc_A1D:
	ld	a,0 ; "self-modified code"
	or	a
	jr	nz,+
	ld	(ix+7),0C0h
zloc_A26:
	ld	de,0 ; "self-modified code"
	ld	(ix+1Ch),e
	ld	(ix+1Dh),d
+
	pop	bc
	dec	b
	jp	nz,zloc_99F
	jp	zBankSwitchToMusic
; ---------------------------------------------------------------------------

zloc_A37:
	xor	a
	ld	(zComRange),a
	ret
; End of function zPlaySoundByIndex


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; zsub_A3C:
zStopSoundEffects:
	xor	a
	ld	(zComRange),a
	ld	ix,1D3Ch
	ld	b,6

zloc_A46:
	push	bc
	bit	7,(ix+0)
	jp	z,zloc_AB6
	res	7,(ix+0)
	res	4,(ix+0)
	ld	a,(ix+1)
	or	a
	jp	m,zloc_A89
	push	af
	call	zsub_C56
	pop	af
	push	ix
	sub	2
	add	a,a
	add	a,zbyte_1C3&0FFh
	ld	(zloc_A6C+2),a	; store into the instruction after zloc_A6C (self-modifying code)
zloc_A6C:
	ld	ix,(zbyte_1C3) ; "self-modified code"
	bit	2,(ix+0)
	jr	z,+
	res	2,(ix+0)
	set	1,(ix+0)
	ld	a,(ix+8)
	call	zsub_E21
+
	pop	ix
	jp	zloc_AB6
; ---------------------------------------------------------------------------

zloc_A89:
	push	af
	call	zsub_526
	pop	af
	push	ix
	rra
	rra
	rra
	rra
	and	0Fh
	add	a,zbyte_1C3&0FFh
	ld	(zloc_A9B+2),a	; store into the instruction after zloc_A9B (self-modifying code)
zloc_A9B:
	ld	ix,(zbyte_1C3) ; "self-modified code"
	res	2,(ix+0)
	set	1,(ix+0)
	ld	a,(ix+1)
	cp	0E0h
	jr	nz,+
	ld	a,(ix+1Bh)
	ld	(zPSG),a
+
	pop	ix

zloc_AB6:
	ld	de,2Ah
	add	ix,de
	pop	bc
	djnz	zloc_A46
	ret
; End of function zStopSoundEffects

; ---------------------------------------------------------------------------
; zloc_ABF:
zFadeOutMusic:
	ld	a,3
	ld	(zComRange+5),a
	ld	a,28h
	ld	(zComRange+4),a
	xor	a
	ld	(zComRange+18h),a
	ld	(zComRange+14h),a
	ret

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_AD1:
	ld	a,(zComRange+5)
	or	a
	jr	z,+
	dec	(ix+5)
	ret
+
	dec	(ix+4)
	jp	z,zsub_B52
	ld	(ix+5),3
	push	ix
	ld	ix,1BC2h
	ld	b,6

zloc_AED:
	bit	7,(ix+0)
	jr	z,zloc_B04
	inc	(ix+6)
	jp	p,+
	res	7,(ix+0)
	jr	zloc_B04
+
	push	bc
	call	zsub_E8A
	pop	bc

zloc_B04:
	ld	de,2Ah
	add	ix,de
	djnz	zloc_AED
	ld	b,3

zloc_B0D:
	bit	7,(ix+0)
	jr	z,zloc_B2C
	inc	(ix+6)
	ld	a,10h
	cp	(ix+6)
	jp	nc,+
	res	7,(ix+0)
	jr	zloc_B2C
+
	push	bc
	ld	b,(ix+6)
	call	zloc_4F9
	pop	bc

zloc_B2C:
	ld	de,2Ah
	add	ix,de
	djnz	zloc_B0D
	pop	ix
	ret
; End of function zsub_AD1


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_B36:
	ld	a,28h
	ld	b,3

-	ld	c,b
	dec	c
	rst	zsub_18
	set	2,c
	rst	zsub_18
	djnz	-

	ld	a,30h
	ld	c,0FFh
	ld	b,60h

-	rst	zsub_18
	rst	zsub_28
	inc	a
	djnz	-

	ret
; End of function zsub_B36

; ---------------------------------------------------------------------------
; zloc_B4E:
zStopSoundAndMusic:
	xor	a
	ld	(zComRange+3),a

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_B52:
	ld	a,2Bh
	ld	c,80h
	rst	zsub_18
	ld	a,c
	ld	(zComRange+15h),a
	ld	a,27h
	ld	c,0
	rst	zsub_18
	ld	hl,zComRange
	ld	de,zComRange+1
	ld	(hl),0
	ld	bc,2B7h
	ldir
	ld	a,80h
	ld	(zComRange+8),a
	call	zsub_B36
	jp	zloc_5F4
; End of function zsub_B52


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_B78:
	ld	ix,zComRange
	ld	b,(ix+0)
	ld	c,(ix+11h)
	push	bc
	ld	b,(ix+14h)
	ld	c,(ix+10h)
	push	bc
	ld	b,(ix+9)
	ld	c,(ix+0Ah)
	push	bc
	ld	hl,zComRange
	ld	de,zComRange+1
	ld	(hl),0
	ld	bc,1BBh
	ldir
	pop	bc
	ld	(ix+9),b
	ld	(ix+0Ah),c
	pop	bc
	ld	(ix+14h),b
	ld	(ix+10h),c
	pop	bc
	ld	(ix+0),b
	ld	(ix+11h),c
	ld	a,80h
	ld	(zComRange+8),a
	call	zsub_B36
	jp	zloc_5F4
; End of function zsub_B78

; ---------------------------------------------------------------------------
; zloc_BBE:
; increases the tempo of the music
zSpeedUpMusic:
	ld	b,80h
	ld	a,(zComRange+11h)
	or	a
	ld	a,(zComRange+13h)
	jr	z,zloc_BD8
	jr	zloc_BE0

; ===========================================================================
; zloc_BCB:
; returns the music tempo to normal
zSlowDownMusic:
	ld	b,0
	ld	a,(zComRange+11h)
	or	a
	ld	a,(zComRange+12h)
	jr	z,zloc_BD8
	jr	zloc_BE0

; ===========================================================================
; helper routines for changing the tempo
zloc_BD8:
	ld	(zComRange+2),a
	ld	a,b
	ld	(zComRange+14h),a
	ret
; ---------------------------------------------------------------------------
zloc_BE0:
	ld	(1E3Ah),a
	ld	a,b
	ld	(1E4Ch),a
	ret

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_BE8:
	ld	a,(zComRange+0Fh)
	or	a
	jr	z,+
	dec	(ix+0Fh)
	ret
+
	ld	a,(zComRange+10h)
	or	a
	jr	nz,+
	ld	a,(zComRange+18h)
	and	0FBh
	ld	(zComRange+18h),a
	xor	a
	ld	(zComRange+0Eh),a
	ret
+
	dec	(ix+10h)
	ld	(ix+0Fh),2
	push	ix
	ld	ix,1BC2h
	ld	b,6

-	bit	7,(ix+0)
	jr	z,+
	dec	(ix+6)
	push	bc
	call	zsub_E8A
	pop	bc
+
	ld	de,2Ah
	add	ix,de
	djnz	-

	ld	b,3

-	bit	7,(ix+0)
	jr	z,+
	dec	(ix+6)
	push	bc
	ld	b,(ix+6)
	call	zloc_4F9
	pop	bc
+
	ld	de,2Ah
	add	ix,de
	djnz	-

	pop	ix
	ret
; End of function zsub_BE8


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_C46:
	ld	a,(ix+0)
	and	6
	ret	nz
	ld	a,(ix+1)
	or	0F0h
	ld	c,a
	ld	a,28h
	rst	zsub_18
	ret
; End of function zsub_C46


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_C56:
	ld	a,(ix+0)
	and	14h
	ret	nz
	ld	a,28h
	ld	c,(ix+1)
	rst	zsub_18
	ret
; End of function zsub_C56


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; performs a bank switch to where the music for the current track is at
; (there are two possible bank locations for music)

; zsub_C63:
zBankSwitchToMusic:
	ld	a,(zComRange+16h)
	or	a
	jr	nz,+

	bankswitch MusicPoint1
	ret
+
	bankswitch MusicPoint2
	ret
; End of function zBankSwitchToMusic

; ---------------------------------------------------------------------------

zloc_C89:
	sub	0E0h
	add	a,a
	add	a,a
	ld	(zloc_C92+1),a ; store into the instruction after zloc_C92 (self-modifying code)
	ld	a,(hl)
	inc	hl

; seems to be a lookup table of specific routines for the FM instruments

	ensure1byteoffset 67h
zloc_C92:
	jr	$
; ---------------------------------------------------------------------------
	jp	zloc_CFC ; E0 (these seem to be coordination flag handlers)
	nop
; ---------------------------------------------------------------------------
	jp	zloc_D1A ; E1
	nop
; ---------------------------------------------------------------------------
	jp	zloc_D1E ; E2
	nop
; ---------------------------------------------------------------------------
	jp	zloc_D22 ; E3
	nop
; ---------------------------------------------------------------------------
	jp	zloc_D35 ; E4
	nop
; ---------------------------------------------------------------------------
	jp	zloc_DB7 ; E5
	nop
; ---------------------------------------------------------------------------
	jp	zloc_DBB ; E6
	nop
; ---------------------------------------------------------------------------
	jp	zloc_DC4 ; E7
	nop
; ---------------------------------------------------------------------------
	jp	zloc_DCA ; E8
	nop
; ---------------------------------------------------------------------------
	jp	zloc_DD1 ; E9
	nop
; ---------------------------------------------------------------------------
	jp	zloc_DD8 ; EA
	nop
; ---------------------------------------------------------------------------
	jp	zloc_DDC ; EB
	nop
; ---------------------------------------------------------------------------
	jp	zloc_DF9 ; EC
	nop
; ---------------------------------------------------------------------------
	jp	zlocret_E00 ; empty and unused
	nop
; ---------------------------------------------------------------------------
	jp	zloc_E01 ; EE
	nop
; ---------------------------------------------------------------------------
	jp	zloc_E03 ; EF
	nop
; ---------------------------------------------------------------------------
	jp	zloc_EB0 ; F0 - pitch bend?
	nop
; ---------------------------------------------------------------------------
	jp	zloc_EDE ; F1
	nop
; ---------------------------------------------------------------------------
	jp	zloc_EE4 ; F2 - sound script end?
	nop
; ---------------------------------------------------------------------------
	jp	zloc_F78 ; F3
	nop
; ---------------------------------------------------------------------------
	jp	zloc_F88 ; F4
	nop
; ---------------------------------------------------------------------------
	jp	zloc_F8E ; F5
	nop
; ---------------------------------------------------------------------------
	jp	zloc_F92 ; F6
	nop
; ---------------------------------------------------------------------------
	jp	zloc_F95 ; F7
	nop
; ---------------------------------------------------------------------------
	jp	zloc_FB3 ; F8
	nop
; ---------------------------------------------------------------------------
	jp	zloc_FCC ; F9
	nop
; ---------------------------------------------------------------------------

zloc_CFC:
	bit	7,(ix+1)
	ret	m
	bit	2,(ix+0)
	ret	nz
	ld	c,a
	ld	a,(ix+7)
	and	37h
	or	c
	ld	(ix+7),a
	ld	c,a
	ld	a,(ix+1)
	and	3
	add	a,0B4h
	rst	zsub_10
	ret
; ---------------------------------------------------------------------------

zloc_D1A:
	ld	(ix+19h),a
	ret
; ---------------------------------------------------------------------------

zloc_D1E:
	ld	(zComRange+6),a
	ret
; ---------------------------------------------------------------------------

zloc_D22:
	ld	c,(ix+0Ah)
	ld	b,0
	push	ix
	pop	hl
	add	hl,bc
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	inc	c
	inc	c
	ld	(ix+0Ah),c
	ret
; ---------------------------------------------------------------------------

zloc_D35:
	ld	hl,1E38h
	ld	de,zComRange
	ld	bc,1BCh
	ldir
	call	zBankSwitchToMusic
	ld	a,(zComRange+18h)
	or	4
	ld	(zComRange+18h),a
	ld	a,(zComRange+10h)
	ld	c,a
	ld	a,28h
	sub	c
	ld	c,a
	ld	b,6
	ld	ix,1BC2h

-	bit	7,(ix+0)
	jr	z,+
	set	1,(ix+0)
	ld	a,(ix+6)
	add	a,c
	ld	(ix+6),a
	bit	2,(ix+0)
	jr	nz,+
	push	bc
	ld	a,(ix+8)
	call	zsub_E21
	pop	bc
+
	ld	de,2Ah
	add	ix,de
	djnz	-

	ld	b,3

-	bit	7,(ix+0)
	jr	z,+
	set	1,(ix+0)
	call	zsub_526
	ld	a,(ix+6)
	add	a,c
	ld	(ix+6),a
+
	ld	de,2Ah
	add	ix,de
	djnz	-

	ld	a,80h
	ld	(zComRange+0Eh),a
	ld	a,28h
	ld	(zComRange+10h),a
	xor	a
	ld	(zComRange+11h),a
	ld	a,(zComRange+15h)
	ld	c,a
	ld	a,2Bh
	rst	zsub_18
	pop	bc
	pop	bc
	pop	bc
	jp	zloc_CC
; ---------------------------------------------------------------------------

zloc_DB7:
	ld	(ix+2),a
	ret
; ---------------------------------------------------------------------------

zloc_DBB:
	add	a,(ix+6)
	ld	(ix+6),a
	jp	zsub_E8A
; ---------------------------------------------------------------------------

zloc_DC4:
	set	4,(ix+0)
	dec	hl
	ret
; ---------------------------------------------------------------------------

zloc_DCA:
	ld	(ix+0Fh),a
	ld	(ix+10h),a
	ret
; ---------------------------------------------------------------------------

zloc_DD1:
	add	a,(ix+5)
	ld	(ix+5),a
	ret
; ---------------------------------------------------------------------------

zloc_DD8:
	ld	(zComRange+2),a
	ret
; ---------------------------------------------------------------------------

zloc_DDC:
	push	ix
	ld	ix,zComRange+18h
	ld	de,2Ah
	ld	b,0Ah

-	ld	(ix+2),a
	add	ix,de
	djnz	-

	pop	ix
	ret
; ---------------------------------------------------------------------------
; lower = louder, although this may not exactly be volume control
; zloc_DF1:
	ensure1byteoffset 8
zGain:
	db	  8,  8,  8,  8
	db	0Ch,0Eh,0Eh,0Fh
; ---------------------------------------------------------------------------

zloc_DF9:
	add	a,(ix+6)
	ld	(ix+6),a
	ret
; ---------------------------------------------------------------------------

zlocret_E00:
	ret
; ---------------------------------------------------------------------------

zloc_E01:
	dec	hl
	ret
; ---------------------------------------------------------------------------

zloc_E03:
	ld	(ix+8),a
	ld	c,a
	bit	2,(ix+0)
	ret	nz
	push	hl
	call	zsub_E12
	pop	hl
	ret

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_E12:
	ld	a,(zReadyFlag)
	or	a
	ld	a,c
	jr	z,zsub_E21
	ld	l,(ix+1Ch)
	ld	h,(ix+1Dh)
	jr	zloc_E24
; End of function zsub_E12


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_E21:
	ld	hl,(zMusicToPlay)

	; load ym2612 voice, apparently
zloc_E24:
	push	hl
	ld	c,a
	ld	b,0
	add	a,a
	ld	l,a
	ld	h,b
	add	hl,hl
	add	hl,hl
	ld	e,l
	ld	d,h
	add	hl,hl
	add	hl,de
	add	hl,bc
	pop	de
	add	hl,de
	ld	a,(hl)
	inc	hl
	ld	(zloc_E65+1),a ; store into the instruction after zloc_E65 (self-modifying code)
	ld	c,a
	ld	a,(ix+1)
	and	3
	add	a,0B0h
	rst	zsub_10
	sub	80h
	ld	b,4

-	ld	c,(hl)
	inc	hl
	rst	zsub_10
	add	a,4
	djnz	-

	push	af
	add	a,10h
	ld	b,10h

-	ld	c,(hl)
	inc	hl
	rst	zsub_10
	add	a,4
	djnz	-

	add	a,24h
	ld	c,(ix+7)
	rst	zsub_10
	ld	(ix+1Eh),l
	ld	(ix+1Fh),h

zloc_E65:
	ld	a,0 ; "self-modified code"
	and	7
	add	a,zGain&0FFh
	ld	e,a
	ld	d,(zGain&0FF00h)>>8
	ld	a,(de)
	ld	(ix+1Ah),a
	ld	e,a
	ld	d,(ix+6)
	pop	af

zloc_E77:
	ld	b,4

-	ld	c,(hl)
	inc	hl
	rr	e
	jr	nc,+
	push	af
	ld	a,d
	add	a,c
	ld	c,a
	pop	af
+
	rst	zsub_10
	add	a,4
	djnz	-

	ret
; End of function zsub_E21


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_E8A:
	bit	7,(ix+1)
	ret	nz
	bit	2,(ix+0)
	ret	nz
	ld	e,(ix+1Ah)
	ld	a,(ix+1)
	and	3
	add	a,40h
	ld	d,(ix+6)
	bit	7,d
	ret	nz
	push	hl
	ld	l,(ix+1Eh)
	ld	h,(ix+1Fh)
	call	zloc_E77
	pop	hl
	ret
; End of function zsub_E8A

; ---------------------------------------------------------------------------

zloc_EB0:
	set	3,(ix+0)
	dec	hl
	ld	(ix+11h),l
	ld	(ix+12h),h

zloc_EBB:
	ld	a,ixl
	add	a,13h
	ld	e,a
	adc	a,ixu
	sub	e
	ld	d,a
	ldi
	ldi
	ldi
	ld	a,(hl)
	inc	hl
	srl	a
	ld	(ix+16h),a
	bit	4,(ix+0)
	ret	nz
	xor	a
	ld	(ix+17h),a
	ld	(ix+18h),a
	ret
; ---------------------------------------------------------------------------

zloc_EDE:
	dec	hl
	set	3,(ix+0)
	ret
; ---------------------------------------------------------------------------

zloc_EE4:
	res	7,(ix+0)
	res	4,(ix+0)
	bit	7,(ix+1)
	jr	nz,zcall_zsub_526
	ld	a,(zComRange+7)
	or	a
	jp	m,zloc_F76
	call	zsub_C56
	jr	+

zcall_zsub_526:
	call	zsub_526
+
	ld	a,(zReadyFlag)
	or	a
	jp	p,zloc_F75
	xor	a
	ld	(zComRange),a
	ld	a,(ix+1)
	or	a
	jp	m,zloc_F4D
	push	ix
	sub	2
	add	a,a
	add	a,zbyte_1C3&0FFh
	ld	(zloc_F1D+2),a	; store into the instruction after zloc_F1D (self-modifying code)
zloc_F1D:
	ld	ix,(zbyte_1C3) ; "self-modified code"
	bit	2,(ix+0)
	jp	z,+
	call	zBankSwitchToMusic
	res	2,(ix+0)
	set	1,(ix+0)
	ld	a,(ix+8)
	call	zsub_E21

	bankswitch MusicPoint2
+
	pop	ix
	pop	bc
	pop	bc
	ret
; ---------------------------------------------------------------------------

zloc_F4D:
	push	ix
	rra
	rra
	rra
	rra
	and	0Fh
	add	a,zbyte_1C3&0FFh
	ld	(zloc_F5A+2),a	; store into the instruction after zloc_A5A (self-modifying code)
zloc_F5A:
	ld	ix,(zbyte_1C3) ; "self-modified code"
	res	2,(ix+0)
	set	1,(ix+0)
	ld	a,(ix+1)
	cp	0E0h
	jr	nz,+
	ld	a,(ix+1Bh)
	ld	(zPSG),a
+
	pop	ix

zloc_F75:
	pop	bc

zloc_F76:
	pop	bc
	ret
; ---------------------------------------------------------------------------

zloc_F78:
	ld	(ix+1),0E0h
	ld	(ix+1Bh),a
	bit	2,(ix+0)
	ret	nz
	ld	(zPSG),a
	ret
; ---------------------------------------------------------------------------

zloc_F88:
	dec	hl
	res	3,(ix+0)
	ret
; ---------------------------------------------------------------------------

zloc_F8E:
	ld	(ix+8),a
	ret
; ---------------------------------------------------------------------------

zloc_F92:
	ld	h,(hl)
	ld	l,a
	ret
; ---------------------------------------------------------------------------

zloc_F95:
	ld	c,(hl)
	inc	hl
	push	hl
	add	a,20h
	ld	l,a
	ld	h,0
	ld	e,ixl
	ld	d,ixu
	add	hl,de
	ld	a,(hl)
	or	a
	jr	nz,+
	ld	(hl),c
+
	dec	(hl)
	pop	hl
	jr	z,+
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ret
+
	inc	hl
	inc	hl
	ret
; ---------------------------------------------------------------------------

zloc_FB3:
	ld	c,a
	ld	a,(ix+0Ah)
	sub	2
	ld	(ix+0Ah),a
	ld	b,(hl)
	inc	hl
	ex	de,hl
	add	a,ixl
	ld	l,a
	adc	a,ixu
	sub	l
	ld	h,a
	ld	(hl),e
	inc	hl
	ld	(hl),d
	ld	h,b
	ld	l,c
	ret
; ---------------------------------------------------------------------------

zloc_FCC:
	ld	a,88h
	ld	c,0Fh
	rst	zsub_18
	ld	a,8Ch
	ld	c,0Fh
	rst	zsub_18
	dec	hl
	ret

; ---------------------------------------------------------------------------
zbyte_FD8h: ; unknown
	db	80h,70h,70h,70h,70h,70h,70h,70h,70h,70h,68h,70h,70h,70h,60h,70h
	db	70h,60h,70h,60h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,7Fh
	db	6Fh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,6Fh,70h,70h
	db	70h,60h,60h,70h,70h,70h,70h,70h,70h,70h,60h,62h,60h,60h,60h,70h
	db	70h,70h,70h,70h,60h,60h,60h,6Fh,70h,70h,6Fh,6Fh,70h,71h,70h,70h
	db	6Fh

; zoff_1029:
zPSG_Index:
	dw	byte_1043, byte_105A, byte_1061, byte_1072
	dw	byte_108C, byte_107D, byte_10B6, byte_10D2
	dw	byte_10FA, byte_110B, byte_1149, byte_1165
	dw	byte_11E5
byte_1043:
	db	0,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5
	db	5,5,6,6,6,7,80h
byte_105A:
	db	0,2,4,6,8,10h,80h
byte_1061:
	db	0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,80h
byte_1072:
	db	0,0,2,3,4,4,5,5,5,6,80h
byte_107D:
	db	3,3,3,2,2,2,2,1,1,1,0,0,0,0,80h
byte_108C:
	db	0,0,0,0,0,0,0,0,0,0,1,1
	db	1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2
	db	2,2,2,2,3,3,3,3,3,3,3,3,4,80h
byte_10B6:
	db	0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2
	db	3,3,3,4,4,4,5,5,5,6,7,80h
byte_10D2:
	db	0,0,0,0,0,1,1,1,1,1,2,2,2,2,2,2
	db	3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,6
	db	6,6,6,6,7,7,7,80h
byte_10FA:
	db	0,1,2,3,4,5,6,7,8,9,0Ah,0Bh,0Ch,0Dh,0Eh,0Fh,80h
byte_110B:
	db	0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1
	db	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db	1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2
	db	2,2,3,3,3,3,3,3,3,3,3,3,4,80h
byte_1149:
	db	4,4,4,3,3,3,2,2,2,1,1,1,1,1,1,1
	db	2,2,2,2,2,3,3,3,3,3,4,80h
byte_1165:
	db	4,4,3,3,2,2,1,1,1,1,1,1,1,1,1,1
	db	1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2
	db	2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3
	db	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	db	3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db	4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5
	db	5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6
	db	6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,80h
byte_11E5:
	db	0Eh,0Dh,0Ch,0Bh,0Ah,9,8,7,6,5,4,3,2,1,0,80h


; zbyte_11F5h:
zMasterPlaylist:

; Music IDs
offset :=	MusicPoint2
ptrsize :=	2
idstart :=	80h
; note: +20h means uncompressed, here

zMusIDPtr_2PResult:	db	id(MusPtr_2PResult)	; 92
zMusIDPtr_EHZ:		db	id(MusPtr_EHZ)		; 81
zMusIDPtr_MCZ_2P:	db	id(MusPtr_MCZ_2P)	; 85
zMusIDPtr_OOZ:		db	id(MusPtr_OOZ)		; 8F
zMusIDPtr_MTZ:		db	id(MusPtr_MTZ)		; 82
zMusIDPtr_HTZ:		db	id(MusPtr_HTZ)		; 94
zMusIDPtr_ARZ:		db	id(MusPtr_ARZ)		; 86
zMusIDPtr_CNZ_2P:	db	id(MusPtr_CNZ_2P)	; 80
zMusIDPtr_CNZ:		db	id(MusPtr_CNZ)		; 83
zMusIDPtr_DEZ:		db	id(MusPtr_DEZ)		; 87
zMusIDPtr_MCZ:		db	id(MusPtr_MCZ)		; 84
zMusIDPtr_EHZ_2P:	db	id(MusPtr_EHZ_2P)	; 91
zMusIDPtr_SCZ:		db	id(MusPtr_SCZ)		; 8E
zMusIDPtr_CPZ:		db	id(MusPtr_CPZ)		; 8C
zMusIDPtr_WFZ:		db	id(MusPtr_WFZ)		; 90
zMusIDPtr_HPZ:		db	id(MusPtr_HPZ)		; 9B
zMusIDPtr_Options:	db	id(MusPtr_Options)	; 89
zMusIDPtr_SpecStage:	db	id(MusPtr_SpecStage)	; 88
zMusIDPtr_Boss:		db	id(MusPtr_Boss)		; 8D
zMusIDPtr_EndBoss:	db	id(MusPtr_EndBoss)	; 8B
zMusIDPtr_Ending:	db	id(MusPtr_Ending)	; 8A
zMusIDPtr_SuperSonic:	db	id(MusPtr_SuperSonic)	; 93
zMusIDPtr_Invincible:	db	id(MusPtr_Invincible)	; 99
zMusIDPtr_ExtraLife:	db	id(MusPtr_ExtraLife)+20h; B5
zMusIDPtr_Title:	db	id(MusPtr_Title)	; 96
zMusIDPtr_EndLevel:	db	id(MusPtr_EndLevel)	; 97
zMusIDPtr_GameOver:	db	id(MusPtr_GameOver)+20h	; B8
zMusIDPtr_Continue:	db	(MusPtr_Continue-MusicPoint1)/ptrsize	; 0
zMusIDPtr_Emerald:	db	id(MusPtr_Emerald)+20h	; BA
zMusIDPtr_Credits:	db	id(MusPtr_Credits)+20h	; BD
zMusIDPtr_Countdown:	db	id(MusPtr_Drowning)+40h	; DC
zMusIDPtr__End:

; unknown
zbyte_1214:
	db	 68h,0BEh,0FFh,0F0h
	db	0FFh,0DEh,0FFh,0DDh
	db	 68h, 80h,0D6h, 7Bh
	db	 7Bh,0FFh,0A8h,0FFh
	db	 87h,0FFh,0FFh,0C9h
	db	 97h,0FFh,0FFh,0CDh
	db	0CDh,0AAh,0F2h,0DBh
	db	0D5h,0F0h, 80h

	; DAC sample pointers and lengths
	ensure1byteoffset 1Ch

zDACPtr_Index:
zbyte_1233:
zDACPtr_Sample1:	dw	zmake68kPtr(SndDAC_Sample1)
zbyte_1235:
			dw	SndDAC_Sample1_End-SndDAC_Sample1

zDACPtr_Sample2:	dw	zmake68kPtr(SndDAC_Sample2)
			dw	SndDAC_Sample2_End-SndDAC_Sample2

zDACPtr_Sample3:	dw	zmake68kPtr(SndDAC_Sample3)
			dw	SndDAC_Sample3_End-SndDAC_Sample3

zDACPtr_Sample4:	dw	zmake68kPtr(SndDAC_Sample4)
			dw	SndDAC_Sample4_End-SndDAC_Sample4

zDACPtr_Sample5:	dw	zmake68kPtr(SndDAC_Sample5)
			dw	SndDAC_Sample5_End-SndDAC_Sample5

zDACPtr_Sample6:	dw	zmake68kPtr(SndDAC_Sample6)
			dw	SndDAC_Sample6_End-SndDAC_Sample6

zDACPtr_Sample7:	dw	zmake68kPtr(SndDAC_Sample7)
			dw	SndDAC_Sample7_End-SndDAC_Sample7

	; something else for DAC sounds
	ensure1byteoffset 22h
; zbyte_124F:
zDACMasterPlaylist:

; DAC samples IDs
offset :=	zDACPtr_Index
ptrsize :=	2+2
idstart :=	81h

	db	id(zDACPtr_Sample1),17h
	db	id(zDACPtr_Sample2),1
	db	id(zDACPtr_Sample3),6
	db	id(zDACPtr_Sample4),8
	db	id(zDACPtr_Sample5),1Bh
	db	id(zDACPtr_Sample6),0Ah
	db	id(zDACPtr_Sample7),1Bh
	db	id(zDACPtr_Sample5),12h
	db	id(zDACPtr_Sample5),15h
	db	id(zDACPtr_Sample5),1Ch
	db	id(zDACPtr_Sample5),1Dh
	db	id(zDACPtr_Sample6),2
	db	id(zDACPtr_Sample6),5
	db	id(zDACPtr_Sample6),8
	db	id(zDACPtr_Sample7),8
	db	id(zDACPtr_Sample7),0Bh
	db	id(zDACPtr_Sample7),12h

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

zsub_1271:
	exx
	ld	bc,0
	ld	de,0
	exx
	ld	de,zMusicData
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	(zloc_12F3+1),hl ; store into the instruction after zloc_12F3 (self-modifying code)
	inc	bc
	ld	(zsub_12E8+1),bc ; store into the instruction after zloc_12E8 (self-modifying code)

zloc_1288:
	exx
	srl	c
	srl	b
	bit	0,b
	jr	nz,+
	call	zsub_12E8
	ld	c,a
	ld	b,0FFh
+
	bit	0,c
	exx
	jr	z,+
	call	zsub_12E8
	ld	(de),a
	inc	de
	exx
	inc	de
	exx
	jr	zloc_1288
+
	call	zsub_12E8
	ld	c,a
	call	zsub_12E8
	ld	b,a
	and	0Fh
	add	a,3
	push	af
	ld	a,b
	rlca
	rlca
	rlca
	rlca
	and	0Fh
	ld	b,a
	ld	a,c
	add	a,12h
	ld	c,a
	adc	a,b
	sub	c
	and	0Fh
	ld	b,a
	pop	af
	exx
	push	de
	ld	l,a
	ld	h,0
	add	hl,de
	ex	de,hl
	exx
	pop	hl
	or	a
	sbc	hl,bc
	jr	nc,+
	ex	de,hl
	ld	b,a

-	ld	(hl),0
	inc	hl
	djnz	-

	ex	de,hl
	jr	zloc_1288
+
	ld	hl,zMusicData
	add	hl,bc
	ld	c,a
	ld	b,0
	ldir
	jr	zloc_1288
; End of function zsub_1271


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


zsub_12E8:
	ld	hl,0 ; "self-modified code"
	dec	hl
	ld	(zsub_12E8+1),hl ; store into the instruction after zloc_12E8 (self-modifying code)
	ld	a,h
	or	l
	jr	z,+
zloc_12F3:
	ld	hl,0 ; "self-modified code"
	ld	a,(hl)
	inc	hl
	ld	(zloc_12F3+1),hl ; store into the instruction after zloc_12F3 (self-modifying code)
	ret
+
	pop	hl
	ret
; End of function zsub_12E8

; ---------------------------------------------------------------------------
	; space for a few global variables

zbyte_12FE:	db 0 ; zbyte_12FE ; unknown (music initialized flag?)
zCurDAC:	db 0 ; zbyte_12FF ; seems to indicate DAC sample playing status
zCurSong:	db 0 ; zbyte_1300 ; currently playing song index
zReadyFlag:	db 0 ; zbyte_1301 ; 0 = busy, 80h = ready
zRingSpeaker:	db 0 ; zbyte_1302 ; stereo alternation flag. 0 = next one plays on left, -1 = next one plays on right
zGloopFlag:	db 0 ; zbyte_1303 ; if -1, don't play the gloop sound next time
zSpindashPlayingCounter:	db 0 ; zbyte_1304
zSpindashExtraFrequencyIndex:	db 0 ; zbyte_1305
zSpindashActiveFlag:		db 0 ; zbyte_1306 ; -1 if spindash charge was the last sound that played
zPaused:	db 0 ; zbyte_1307 ; 0 = normal, -1 = pause all sound and music




; end of Z80 'ROM'
	if $>zMusicData
		fatal "Your Z80 code won't fit before the music.. It's \{$-zMusicData}h bytes past the start of music data \{zMusicData}h"
	endif
