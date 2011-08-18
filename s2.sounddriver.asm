; Sonic the Hedgehog 2 disassembled Z80 sound driver

; Disassembled by Xenowhirl for AS
; Additional disassembly work by RAS Oct 2008
; RAS' work merged into SVN by Flamewing
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

	; Okay, I spent a freakin' weekend trying to figure out this Z80 engine
	; (cause I just love it so much ;) ), and this is pretty much everything I've
	; got; it's probably about 95% figured out.
	;	- I didn't do 68K queueing completely... it's in there, I'm just a little fuzzy right now

	; I briefly touched the Saxman decoder though I'm not using it; I figured someone
	; else can play with that.  I think playing music out of ROM is just dandy, 
	; even if it does require a little post-processing to work.  And actually, with
	; some tweaks, I think I can get this beast on relative addresses... heheheh

	; LOTS of decoding work and relabeling of unknowns!  This is a much more complete disasm ;)

	; zComRange:	@ 1B80h
	; 	+00h	-- Priority of current SFX (cleared when 1-up song is playing)
	; 	+01h	-- tempo clock
	; 	+02h	-- current tempo
	; 	+03h	-- Pause/unpause flag (set from 68K)
	; 	+04h	-- total volume levels to continue decreasing volume before fade out considered complete (starts at 28h, works downward)
	; 	+05h	-- delay ticker before next volume decrease
	; 
	; 	+07h	-- "DAC is updating" flag (set to FFh until completion of DAC track change)
	; 	+08h	-- When NOT set to 80h, 68K request new sound index to play
	; 	+09h	-- SFX to Play queue slot
	; 	+0Ah	-- Play stereo sound queue slot
	; 	+0Bh	-- Unknown SFX Queue slot
	; 	+0Ch	-- Address to table of voices
	; 
	; 	+0Eh	-- Set to 80h while fading in (disabling SFX) then 00h
	; 	+0Fh	-- Same idea as +05h, except for fade IN
	; 	+10h	-- Same idea as +04h, except for fade IN
	; 	+11h	-- 80h set indicating 1-up song is playing (stops other sounds)
	; 	+12h	-- main tempo value
	; 	+13h	-- original tempo for speed shoe restore
	; 	+14h	-- speed shoe tempo?
	; 	+15h	-- If 80h, FM Channel 6 is NOT in use (DAC enabled)
	; 	+16h	-- deleted index hold that enabled the secondary bank
	; 	+17h	-- Pal mode flag
	; 
	; ** zTracksStart starts @ +18h
	; 
	; 	1B98 base
	; 	Track 1 = DAC 
	; 	Then 6 FM
	; 	Then 3 PSG
	; 
	; 
	; 	1B98 = DAC
	; 	1BC2 = FM 1
	; 	1BEC = FM 2
	; 	1C16 = FM 3
	; 	1C40 = FM 4
	; 	1C6A = FM 5
	; 	1C94 = FM 6
	; 	1CBE = PSG 1
	; 	1CE8 = PSG 2
	; 	1D12 = PSG 3 (tone or noise)
	; 
	; 	1D3C = SFX FM 3
	; 	1D66 = SFX FM 4
	; 	1D90 = SFX FM 5
	; 	1DBA = SFX PSG 1
	; 	1DE4 = SFX PSG 2
	; 	1E0E = SFX PSG 3 (tone or noise)
	; 
	; 
	; 	+00h	"playback control"; bits: 
	; 		1 (02h): seems to be "track is at rest"
	; 		2 (04h): SFX is overriding this track
	; 		3 (08h): modulation on
	; 		4 (10h): do not attack next note
	; 		7 (80h): track is playing 
	; 
	; 	+01h	"voice control"; bits:
	; 		2 (04h): If set, bound for part II, otherwise 0 (see zWriteFMIorII)
	; 			-- bit 2 has to do with sending key on/off, which uses this differentiation bit directly
	; 		7 (80h): PSG Track
	; 
	; 	+02h	-- timing divisor; 1 = Normal, 2 = Half, 3 = Third...
	; 	+03h	-- Track's position low byte
	; 	+04h	-- Track's position high byte
	; 	+05h	-- Key offset (from coord flag E9)
	; 	+06h	-- channel volume (only ap plied at voice changes)
	; 	+07h	-- Panning / AMS / FMS settings
	; 	+08h	-- Current voice in use OR current PSG tone
	; 	+09h	-- PSG flutter (dynamically effects PSG volume for decay effects)
	; 	+0Ah	-- "Gosub" stack position offset (starts at 2Ah, i.e. end of track, and each jump decrements by 2)
	; 	+0Bh	-- current duration timeout; counting down to zero
	; 	+0Ch	-- last set duration (if a note follows a note, this is reapplied to 0Bh)
	; 
	; 	; 0Dh / 0Eh change a little depending on track -- essentially they hold data relevant to the next note to play
	; 	+0Dh	-- DAC: Next drum to play 
	; 		-- FM/PSG: frequency low byte
	; 	+0Eh	-- DAC: playback rate ??
	; 		-- FM/PSG: frequency high byte
	; 	+0Fh	-- Currently set note fill; counts down to zero and then cuts off note
	; 	+10h	-- Reset value for current note fill
	; 	+11h	-- low byte of address of current modulation setting
	; 	+12h	-- high byte of address of current modulation setting
	; 	+13h	-- Wait for ww period of time before modulation starts
	; 	+14h	-- Modulation Speed
	; 	+15h	-- Modulation change per Mod. Step
	; 	+16h	-- Number of steps in modulation (divided by 2)
	;	+17h	-- Current modulation value low byte
	;	+18h	-- Current modulation value high byte
	; 	+19h	-- Set by "alter notes" coord flag E1; used to add directly to FM/PSG frequency
	; 	+1Ah	-- zVolTLMaskTbl value set during voice setting (value based on algorithm indexing zGain table)
	; 	+1Bh	-- PSG noise setting
	; 	+1Ch	-- low byte of custom voice table (for SFX)
	; 	+1Dh	-- high byte of custom voice table (for SFX)
	; 	+1Eh	-- low byte of where TL bytes of current voice begin (set during voice setting)
	; 	+1Fh	-- high byte of where TL bytes of current voice begin (set during voice setting)
	; 	+20h	-- Loop counter index 0
	;   ... open ...
	; 	+2Ah	-- start of next track, every two bytes below this is a coord flag "gosub" (F8h) return stack
	;
	;	The bytes between +20h and +29h are "open"; starting at +20h and going up are possible loop counters
	;	(for coord flag F7) while +2Ah going down (never AT 2Ah though) are stacked return addresses going 
	;	down after calling coord flag F8h.  Of course, this does mean collisions are possible with either
	;	or other track memory if you're not careful with these!  No range checking is performed!
	; 
	; 	All tracks are 2Ah bytes long

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
zROMWindow =	8000h
; more equates: addresses specific to this program (besides labeled addresses)
zMusicData =	1380h ; don't change this unless you change all the pointers in the BINCLUDE'd music too...
zComRange =	zMusicData+800h ; 1B80h ; most communication between Z80 and 68k happens in here, among other things (like stack storage)
zCurrentTempo = zComRange+2	; Stores current tempo value here
zTempoTurbo = zComRange+13h	; Stores the tempo if speed shoes are acquired (or 7Bh is played anywho)
zDACUpdating = zComRange+7 ; Set to FFh while DAC is updating, then back to 00h
zQueueToPlay =  zComRange+8	; if NOT set to 80h, means new index was requested by 68K
zSFXToPlay =	zComRange+9	; When Genesis wants to play "normal" sound, it writes it here
zSFXStereoToPlay = zComRange+0Ah	; When Genesis wants to play alternating stereo sound, it writes it here
zSFXUnknown = zComRange+0Bh ; Unknown type of sound queue, but it's in Genesis code like it was once used
zVoiceTblPtr =	zComRange+0Ch	; address of the voices
zIsPalFlag = zComRange+17h	; I think this flags if system is PAL
zTracksStart = zComRange+18h	; This is the beginning of all BGM track memory
zTrackSz = 2Ah				; Size of all tracks

z1upBackup = 1E38h			; When extra life plays, it backs up a large amount of memory (all track data plus 36 bytes)
z1upBackupSz = 10*zTrackSz+18h		; ... specifically, this value

zFirstSound = 20h			; Index of very first sound (as opposed to BGM)
; see the very end for another set of variables


; macro to perform a bank switch... after using this,
; the start of zROMWindow points to the start of the given 68k address,
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
zmake68kPtr function addr,zROMWindow+(addr&7FFFh)


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
;zsub_8
zFMBusyWait:    rsttarget
	; Performs the annoying task of waiting for the FM to not be busy
	ld	a,(zYM2612_A0)
	add	a,a
	jr	c,zFMBusyWait
	ret
; End of function zFMBusyWait

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
	align	8
;zsub_10
zWriteFMIorII:    rsttarget
	bit	2,(ix+1)
	jr	z,zWriteFMI
	jr	zWriteFMII
; End of function zWriteFMIorII

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
	align	8
;zsub_18
zWriteFMI:    rsttarget
	; Write reg/data pair to part I; 'a' is register, 'c' is data
	push	af
	rst	zFMBusyWait ; 'rst' is like 'call' but only works for 8-byte aligned addresses <= 38h
	pop	af
	ld	(zYM2612_A0),a
	push	af
	rst	zFMBusyWait
	ld	a,c
	ld	(zYM2612_D0),a
	pop	af
	ret
; End of function zWriteFMI

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
	align	8
;zsub_28
zWriteFMII:    rsttarget
	; Write reg/data pair to part II; 'a' is register, 'c' is data
	push	af
	rst	zFMBusyWait
	pop	af
	ld	(zYM2612_A1),a
	push	af
	rst	zFMBusyWait
	ld	a,c
	ld	(zYM2612_D1),a
	pop	af
	ret
; End of function zWriteFMII

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
	align	8
zVInt:    rsttarget
	; This is called every VBLANK (38h is the interrupt entry point,
	; and VBLANK is the only one Z80 is hooked up to.)

	push	af					; Save 'af'
	exx							; Effectively backs up 'bc', 'de', and 'hl'
	call	zBankSwitchToMusic	; Bank switch to the music (depending on which BGM is playing in my version)
	xor	a						; Clear 'a'
	ld	(zDoSFXFlag),a			; Not updating SFX (updating music)
	ld	ix,zComRange			; ix points to zComRange
	ld	a,(zComRange+3)			; Get pause/unpause flag
	or	a						; test 'a'
	jr	z,zUpdateEverything		; If zero, go to zUpdateEverything
	call	zPauseMusic
	jp	zUpdateDAC				; Now update the DAC
; ---------------------------------------------------------------------------

;zloc_51
zUpdateEverything:
	ld	a,(zComRange+4)			; are we fading out?
	or	a
	call	nz,zUpdateFadeout	; If so, update that
	ld	a,(zComRange+0Eh)		; are we fading in?
	or	a
	call	nz,zUpdateFadeIn	; If so, update that
	ld	a,(zSFXToPlay)			; zComRange+09h -- play normal sound
	or	(ix+0Ah)				; zComRange+0Ah (zSFXStereoToPlay) -- play stereo sound (alternating speakers)
	or	(ix+0Bh)				; zComRange+0Bh (zSFXUnknown) -- "unknown" slot
	call	nz,zCycleQueue		; If any of those are non-zero, cycle queue
	
	; Apparently if this is 80h, it does not play anything new,
	; otherwise it cues up the next play (flag from 68K for new item)
	ld	a,	(zQueueToPlay)
	cp		80h
	call	nz,zPlaySoundByIndex	; If not 80h, we need to play something new!
	
	; Spindash update
	ld	a,(zSpindashPlayingCounter)
	or	a
	jr	z,+ ; if the spindash counter is already 0, branch
	dec	a ; decrease the spindash sound playing counter
	ld	(zSpindashPlayingCounter),a
+
	; If the system is PAL, then this performs some timing adjustments
	; (i.e. you need to update 1.2x as much to keep up the same rate)
	ld	hl,zPalModeByte		; Get address of zPalModeByte
	ld	a,(zIsPalFlag)		; Get zIsPalFlag -> 'a'
	and	(hl)				; 'And' them together
	jr	z,+					; If it comes out zero, do nothing
	ld	hl,zPALUpdTick
	dec	(hl)
	jr	nz,+
	ld	(hl),5				; every 6 frames (0-5) you need to "double update" to sort of keep up
	call	zUpdateMusic
+
	call	zUpdateMusic

	; Now all of the SFX tracks are updated in a similar manner to "zUpdateMusic"...
	bankswitch SoundIndex		; Bank switch to sound effects

	ld	a,80h
	ld	(zDoSFXFlag),a			; Set zDoSFXFlag = 80h (updating sound effects)

	; FM SFX channels
	ld	b,3						; Only 3 FM channels for SFX (FM3, FM4, FM5)

-	push	bc	
	ld	de,zTrackSz				; Spacing between tracks
	add	ix,de					; Next track
	bit	7,(ix+0)				; Is it playing?
	call	nz,zFMUpdateTrack	; If it is, go update it
	pop	bc
	djnz	-

	; PSG SFX channels
	ld	b,3						; All PSG channels available

-	push	bc
	ld	de,zTrackSz				; Spacing between tracks
	add	ix,de					; Next track
	bit	7,(ix+0)				; Is it playing?
	call	nz,zPSGUpdateTrack	; If it is, go update it
	pop	bc
	djnz	-

	; Now we update the DAC... this only does anything if there's a new DAC 
	; sound to be played.  This is called after updating the DAC track.
	; Otherwise it just mucks with the timing loop, forcing an update.
zUpdateDAC:

	bankswitch SndDAC_Start		; Bankswitch to the DAC data

	ld	a,(zCurDAC)				; Get currently playing DAC sound
	or	a
	jp	m,+						; If one is queued (80h+), go to it!
	exx							; Otherwise restore registers from mirror regs
	ld	b,1						; b=1 (initial feed to the DAC "djnz" loops, i.e. UPDATE RIGHT AWAY)
	pop	af
	ei		; enable interrupts
	ret
+
	; If you get here, it's time to start a new DAC sound...
	ld	a,80h
	ex	af,af'	;'
	ld	a,(zCurDAC)			; Get current DAC sound
	sub	81h					; Subtract 81h (first DAC index is 81h)
	ld	(zCurDAC),a			; Store that as current DAC sound
	add	a,a
	add	a,a					; a *= 4 (each DAC entry is a pointer and length, 2+2)
	add	a,zDACPtrTbl&0FFh	; Get low byte into table -> 'a'
	ld	(zloc_104+1),a		; store into the instruction after zloc_104 (self-modifying code)
	add	a,zDACLenTbl-zDACPtrTbl		; How to offset to length versus pointer
	ld	(zloc_107+2),a		; store into the instruction after zloc_107 (self-modifying code)
	pop	af
	ld	hl,zWriteToDAC
	ex	(sp),hl				; Jump to zWriteToDAC

zloc_104:
	ld	hl,(zDACPtrTbl)	; "self-modified code" -- sets start address of DAC sample for zWriteToDAC

zloc_107:
	ld	de,(zDACLenTbl)	; "self-modified code" -- sets length of DAC sample for zWriteToDAC

zloc_10B:
	ld	bc,100h ; "self-modified code" -- From zloc_22A; sets b=1 (the 100h part of it) UPDATE RIGHT AWAY and c="data rate delay" for this DAC sample, the future 'b' setting
	ei		; enable interrupts
	ret
; End of function zVInt


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Updates all tracks; queues notes and durations!

;zsub_110
zUpdateMusic:
	call	TempoWait		; This is a tempo waiting function
	
	; DAC updates
	ld	a,0FFh
	ld	(zDACUpdating),a		; Store FFh to zDACUpdating
	ld	ix,zTracksStart		; Point "ix" to zTracksStart
	bit	7,(ix+0)			; Is bit 7 (80h) set on playback control byte? (means "is playing")
	call	nz,zDACUpdateTrack		; If so, zDACUpdateTrack
	xor	a					; Clear A
	ld	(zDACUpdating),a		; Store 0 to zDACUpdating
	ld	b,6				; Loop 6 times (FM)...

-	push	bc
	ld	de,zTrackSz		; Space between tracks
	add	ix,de			; Go to next track
	bit	7,(ix+0)		; Is bit 7 (80h) set on playback control byte? (means "is playing")
	call	nz,zFMUpdateTrack	; If so...
	pop	bc
	djnz	-

	ld	b,3				; Loop 3 times (PSG)...

-	push	bc
	ld	de,zTrackSz		; Space between tracks
	add	ix,de			; Go to next track
	bit	7,(ix+0)		; Is this track playing?
	call	nz,zPSGUpdateTrack	; If so...
	pop	bc
	djnz	-

	ret
; End of function zUpdateMusic


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_14C
TempoWait:
	; Tempo works as divisions of the 60Hz clock (there is a fix supplied for
	; PAL that "kind of" keeps it on track.)  Every time the internal music clock
	; overflows, it will update.  So a tempo of 80h will update every other
	; frame, or 30 times a second.

	ld	ix,zComRange		; ix points to zComRange
	ld	a,(ix+2)			; tempo value
	add	a,(ix+1)			; Adds previous value to (ix+1)
	ld	(ix+1),a			; Store this as new (ix+1)
	ret	c					; If addition overflowed (answer greater than FFh), return
	
	; So if adding tempo value did NOT overflow, then we add 1 to all durations
	ld	hl,zTracksStart+0Bh	; Start at first track's delay counter (counting up to delay)
	ld	de,zTrackSz			; Offset between tracks 
	ld	b,0Ah				; Loop for all tracks

-	inc	(hl)				; Increasing delay tick counter to target
	add	hl,de				; Next track...
	djnz	-
	
	ret
; End of function TempoWait

; ---------------------------------------------------------------------------

zloc_167:
	im	1	; set interrupt mode 1
	call	zClearTrackPlaybackMem
	ei		; enable interrupts
	ld	iy,zDACDecodeTbl
	ld	de,0
	; This controls the update rate for the DAC...
	; My speculation for the rate at which the DAC updates:
	;	Z80 clock = 3.57954MHz = 3579540Hz (not sure?)
	;	zWaitLoop (immediately below) is waiting for someone to set 
	;		'de' (length of DAC sample) to non-zero
	
	; The DAC code is sync'ed with VBLANK somehow, but I haven't quite got that
	; one figure out yet ... tests on emulator seem to confirm it though.
	; Next, there are "djnz" loops which do busy-waits.  (Two of them, which is
	; where the '2' comes from in my guess equation.)  The DACMasterPlaylist 
	; appears to use '1' as the lowest input value to these functions.  (Which,
	; given the djnz, would be the fastest possible value.)
	; The rate seems to be calculated by 3579540Hz / (60Hz + (speed * 4)) / 2

	; This "waitLoop" waits if the DAC has no data, or else it drops out!
; zloc_174:
zWaitLoop:
	ld	a,d
	or	e
	jr	z,zWaitLoop		; As long as 'de' (length of sample) = 0, wait...

	; 'hl' is the pointer to the sample, 'de' is the length of the sample,
	; and 'iy' points to the translation table; let's go...

	; The "djnz $" loops control the playback rate of the DAC
	; (the higher the 'b' value, the slower it will play)
	
	
	; As for the actual encoding of the data, it is described by jman2050:
	
	; "As for how the data is compressed, lemme explain that real quick: 
	; First, it is a lossy compression. So if you recompress a PCM sample this way, 
	; you will lose precision in data. Anyway, what happens is that each compressed data 
	; is seperated into nybbles (1 4-bit section of a byte). This first nybble of data is 
	; read, and used as an index to a table containing the following data: 
	; 0,1,2,4,8,$10,$20,$40,$80,$FF,$FE,$FC,$F8,$F0,$E0,$C0."   [zDACDecodeTbl / zbyte_1B3]
	; "So if the nybble were equal to F, it'd extract $C0 from the tale. If it were 8, 
	; it would extract $80 from the table. ... Anyway, there is also another byte of data 
	; that we'll call 'd'. At the start of decompression, d is $80. What happens is that d 
	; is then added to the data extracted from the table using the nybble. So if the nybble 
	; were 4, the 8 would be extracted from the table, then added to d, which is $80, 
	; resulting in $88. This result is then put bank into d, then fed into the YM2612 for 
	; processing. Then the next nybble is read, the data is extracted from the table, then 
	; is added to d (remember, d is now changed because of the previous operation), then is 
	; put bank into d, then is fed into the YM2612. This process is repeated until the number 
	; of bytes as defined in the table above are read and decompressed."
	
	; In our case, the so-called 'd' value is shadow register 'a'
		
zWriteToDAC:
	djnz	$				; Busy wait for specific amount of time in 'b'

	di		; disable interrupts (while updating DAC)
	ld	a,2Ah				; DAC port
	ld	(zYM2612_A0),a		; Set DAC port register
	ld	a,(hl)				; Get next DAC byte
	rlca
	rlca
	rlca
	rlca
	and	0Fh					; UPPER 4-bit offset into zDACDecodeTbl
	ld	(zloc_18B+2),a	; store into the instruction after zloc_18B (self-modifying code)
	ex	af,af'				; shadow register 'a' is the 'd' value for 'jman2050' encoding
zloc_18B:
	add	a,(iy+0)			; Get byte from zDACDecodeTbl (self-modified to proper index)
	ld	(zYM2612_D0),a		; Write this byte to the DAC
	ex	af,af'				; back to regular registers
	ld	b,c					; reload 'b' with wait value
	ei						; enable interrupts (done updating DAC, busy waiting for next update)

	djnz	$				; Busy wait for specific amount of time in 'b'

	di		; disable interrupts (while updating DAC)
	push	af
	pop	af
	ld	a,2Ah				; DAC port
	ld	(zYM2612_A0),a		; Set DAC port register
	ld	b,c					; reload 'b' with wait value
	ld	a,(hl)				; Get next DAC byte
	inc	hl					; Next byte in DAC stream...
	dec	de					; One less byte
	and	0Fh					; LOWER 4-bit offset into zDACDecodeTbl
	ld	(zloc_1A8+2),a	; store into the instruction after zloc_1A8 (self-modifying code)
	ex	af,af'				; shadow register 'a' is the 'd' value for 'jman2050' encoding
zloc_1A8:
	add	a,(iy+0)			; Get byte from zDACDecodeTbl (self-modified to proper index)
	ld	(zYM2612_D0),a		; Write this byte to the DAC
	ex	af,af'				; back to regular registers
	ei						; enable interrupts (done updating DAC, busy waiting for next update)
	jp	zWaitLoop			; Back to the wait loop; if there's more DAC to write, we come back down again!

; ---------------------------------------------------------------------------
; 'jman2050' DAC decode lookup table
	ensure1byteoffset 10h
;zbyte_1B3
zDACDecodeTbl:
	db	   0,	 1,   2,   4,   8,  10h,  20h,  40h
	db	 80h,	-1,  -2,  -4,  -8, -10h, -20h, -40h
	
	; The following two tables are used for when an SFX terminates
	; its track to properly restore the music track it temporarily took
	; over.  Note that an important rule here is that no SFX may use
	; DAC, FM Channel 1, FM Channel 2, or FM Channel 6, period.
	; Thus there's also only SFX tracks starting at FM Channel 3.
	
	; The zeroes appear after FM 3 because it calculates the offsets into
	; these tables by their channel assignment, where between Channel 3
	; and Channel 4 there is a gap numerically.
	
	ensure1byteoffset 10h
;zbyte_1C3
zMusicTrackOffs:
	; These are offsets to different music tracks starting with FM3
	dw	zTracksStart+zTrackSz*3,                   0000h, zTracksStart+zTrackSz*4, zTracksStart+zTrackSz*5	; FM3, 0, FM4, FM5
	dw	zTracksStart+zTrackSz*7, zTracksStart+zTrackSz*8, zTracksStart+zTrackSz*9, zTracksStart+zTrackSz*9	; PSG1, PSG2, PSG3, PSG3 (noise alternate)
	
	ensure1byteoffset 10h
;zbyte_1D3
zSFXTrackOffs:
	; These are offsets to different sound effect tracks starting with FM3
	dw	zTracksStart+zTrackSz*10,                    0000h, zTracksStart+zTrackSz*11, zTracksStart+zTrackSz*12	; FM3, 0, FM4, FM5
	dw	zTracksStart+zTrackSz*13, zTracksStart+zTrackSz*14, zTracksStart+zTrackSz*15, zTracksStart+zTrackSz*15	; PSG1, PSG2, PSG3, PSG3 (noise alternate)
; ---------------------------------------------------------------------------

zDACUpdateTrack:
	dec	(ix+0Bh)		; Subtract 1 from (zTracksStart+0Bh) [Track 1's delay start]
	ret	nz				; Return if not zero yet
	ld	l,(ix+3)		; Low byte of DAC track current address (zTracksStart+3)
	ld	h,(ix+4)		; High byte of DAC track current address (zTracksStart+4)

-	ld	a,(hl)			; Get next byte from DAC Track
	inc	hl				; Move to next position...
	cp	0E0h			; Check if is coordination flag
	jr	c,+				; Not coord flag?  Skip to '+'
	call	zCoordFlag	; Handle coordination flag
	jp	-				; Loop back around...
+
	or	a				; Test 'a' for 80h not set, which is a note duration
	jp	p,zloc_20E		; If note duration, jump to zloc_20E (note that "hl" is already incremented)
	ld	(ix+0Dh),a		; This is a note; store it here 
	ld	a,(hl)			; Get next byte...
	or	a				; Test 'a' for 80h not set, which is a note duration
	jp	p,zloc_20D		; Is this a duration this time??  If so, jump to zloc_20D (only difference is to increment "hl")
	; Note followed a note... apparently recycles the previous duration
	ld	a,(ix+0Ch)		; Current DAC note ticker goal value -> 'a'
	ld	(ix+0Bh),a		; Use it again
	jr	zDACAfterDur	; Jump to after duration subroutine...
; ---------------------------------------------------------------------------

zloc_20D:
	inc	hl				; Goes to next byte (after duration byte)

zloc_20E:
	call	zSetDuration

;zloc_211
zDACAfterDur:
	ld	(ix+3),	l		; Stores "hl" to the DAC track pointer memory
	ld	(ix+4),	h
	bit	2,(ix+0)		; Is bit 2 (0x04) set on zTracksStart?
	ret	nz				; If so, we're done
	ld	a,(ix+0Dh)		; Check next note to play
	cp	80h				; Is it a rest?
	ret	z				; If so, quit
	sub	81h				; Otherwise, transform note into an index... (we're selecting which drum to play!)
	add	a,a				; Multiply by 2...
	add	a,zDACMasterPlaylist&0FFh	; Offset into list
	ld	(zloc_22A+2),a	; store into the instruction after zloc_22A (self-modifying code)
zloc_22A:
	ld	bc,(zDACMasterPlaylist)		; Load appropriate drum info -> bc
	ld	a,c							; DAC sample number (81h base) -> 'a'
	ld	(zCurDAC),a					; Store current DAC sound to play
	ld	a,b							; Data rate delay -> 'b'
	ld	(zloc_10B+1),a	; store into the instruction after zloc_10B (self-modifying code)
	ret

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_237
zFMUpdateTrack:
	dec	(ix+0Bh)					; Decrement duration
	jr	nz,+						; If not time-out yet, go do updates only
	res	4,(ix+0)					; When duration over, clear "do not attack" bit 4 (0x10) of track's play control
	call	zFMDoNext				; Handle coordination flags, get next note and duration
	call	zFMPrepareNote			; Prepares to play next note
	call	zFMNoteOn				; Actually key it (if allowed)
	call	zDoModulation			; Update modulation (if modulation doesn't change, we do not return here)
	jp		zFMUpdateFreq			; Applies frequency update from modulation
+
	call	zNoteFillUpdate			; Applies "note fill" (time until cut-off); NOTE: Will not return here if "note fill" expires
	call	zDoModulation			; Update modulation (if modulation doesn't change, we do not return here)
	jp		zFMUpdateFreq			; Applies frequency update from modulation
; End of function zFMUpdateTrack


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_258
zFMDoNext:
	ld	l,(ix+3)		; Load track position low byte
	ld	h,(ix+4)		; Load track position high byte
	res	1,(ix+0)		; Clear bit 1 (02h) "track is rest" from track

-	ld	a,(hl)
	inc	hl				; Increment track to next byte
	cp	0E0h			; Is it a control byte / "coordination flag"?
	jr	c,+				; If not, jump over
	call	zCoordFlag	; Handle coordination flag
	jr	-				; Go around, get next byte
+
	push	af
	call	zFMNoteOff	; Send key off
	pop	af
	or	a				; Test 'a' for 80h not set, which is a note duration
	jp	p,+				; If duration, jump to '+'
	call	zFMSetFreq	; Otherwise, this is a note; call zFMSetFreq
	ld	a,(hl)			; Get next byte
	or	a				; Test 'a' for 80h set, which is a note
	jp	m,zFinishTrackUpdate		; If this is a note, jump to zFinishTrackUpdate
	inc	hl				; Otherwise, go to next byte; a duration
+
	call	zSetDuration
	jp	zFinishTrackUpdate		; Either way, jumping to zFinishTrackUpdate...
; End of function zFMDoNext

; ---------------------------------------------------------------------------
; zloc_285:
;zGetFrequency
zFMSetFreq:
	; 'a' holds a note to get frequency for
	sub	80h
	jr	z,zFMDoRest		; If this is a rest, jump to zFMDoRest
	add	a,(ix+5)		; Add current channel key offset (coord flag E9)
	add	a,a				; Offset into Frequency table...
	add	a,zFrequencies&0FFh
	ld	(zloc_292+2),a	; store into the instruction after zloc_292 (self-modifying code)
;	ld	d,a
;	adc	a,(zFrequencies&0FF00h)>>8
;	sub	d
;	ld	(zloc_292+3),a	; this is how you could store the high byte of the pointer too (unnecessary if it's in the right range)
zloc_292:
	ld	de,(zFrequencies)	; Stores frequency into "de"
	ld	(ix+0Dh),e		; Frequency low byte   -> trackPtr + 0Dh
	ld	(ix+0Eh),d		; Frequency high byte  -> trackPtr + 0Eh
	ret
; ---------------------------------------------------------------------------

;zloc_29D
zFMDoRest:
	set	1,(ix+0)		; Set bit 1 (track is at rest)
	xor	a				; Clear 'a'
	ld	(ix+0Dh),a		; Zero out FM Frequency
	ld	(ix+0Eh),a		; Zero out FM Frequency
	ret

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_2A9
zSetDuration:
	ld	c,a				; 'a' = current duration
	ld	b,(ix+2)		; Divisor; causes multiplication of duration for every number higher than 1

-	djnz	+
	ld	(ix+0Ch),a		; Store new duration into ticker goal of this track (this is reused if a note follows a note without a new duration)
	ld	(ix+0Bh),a		; Sets it on ticker (counts to zero)
	ret
+
	add	a,c				; Will multiply duration based on 'b'
	jp	-
; End of function zSetDuration

; ---------------------------------------------------------------------------

;zloc_2BA
zFinishTrackUpdate:
	; Common finish-up routine used by FM or PSG
	ld	(ix+3),	l		; Stores "hl" to the track pointer memory
	ld	(ix+4),	h
	ld	a,(ix+0Ch)		; Last set duration
	ld	(ix+0Bh),a		; ... put into ticker
	bit	4,(ix+0)		; Is bit 4 (10h) "do not attack next note" set on playback?
	ret	nz				; If so, quit
	ld	a,(ix+10h)		; Master "note fill" value -> a
	ld	(ix+0Fh),a		; Reset 0Fh "note fill" value to master
	ld	(ix+9),	0		; Reset PSG flutter byte
	bit	3,(ix+0)		; is modulation turned on?
	ret	z				; if not, quit
	ld	l,(ix+11h)		; Otherwise, get address of modulation setting
	ld	h,(ix+12h)
	jp	zSetModulation	; ... and go do it!

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_2E3
zNoteFillUpdate:
	ld	a,(ix+0Fh)		; Get current note fill value
	or	a
	ret	z				; If zero, return!
	dec	(ix+0Fh)		; Decrement note fill
	ret	nz				; If not zero, return
	set	1,(ix+0)		; Set bit 1 (track is at rest)
	pop	de				; return address -> 'de' (will not return to z*UpdateTrack function!!)
	bit	7,(ix+1)		; Is this a PSG track?
	jp	nz,zPSGNoteOff	; If so, jump to zPSGNoteOff
	jp	zFMNoteOff		; Else, jump to zFMNoteOff
; End of function zNoteFillUpdate


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_2FB
zDoModulation:
	pop	de				; keep return address -> de (MAY not return to caller)
	
	bit	1,(ix+0)		; Is "track in rest"?
	ret	nz				; If so, quit
	bit	3,(ix+0)		; Is modulation on?
	ret	z				; If not, quit
	ld	a,(ix+13h)		; 'ww' period of time before modulation starts
	or	a
	jr	z,+				; if zero, go to it!
	dec	(ix+13h)		; Otherwise, decrement timer
	ret					; return if decremented (does NOT return to z*UpdateTrack!!)
+
	dec	(ix+14h)		; Decrement modulation speed counter
	ret	nz				; Return if not yet zero
	ld	l,(ix+11h)
	ld	h,(ix+12h)		; 'hl' points to modulation setting
	inc	hl				; skip passed 'ww' period of time
	ld	a,(hl)			; Get modulation speed
	ld	(ix+14h),a		; Restore speed counter
	ld	a,(ix+16h)		; Get number of steps in modulation
	or	a
	jr	nz,+			; If not zero, skip to '+'
	
	; If steps have reached zero...
	inc	hl				; passed mod speed
	inc	hl				; passed mod change per mod step
	ld	a,(hl)			; get number of steps in modulation
	ld	(ix+16h),a		; restore modulation steps
	ld	a,(ix+15h)		; get modulation change per mod step
	neg					; flip it negative
	ld	(ix+15h),a		; store negated value
	ret
+
	dec	(ix+16h)		; Decrement the step
	ld	l,(ix+17h)		
	ld	h,(ix+18h)		; Get 16-bit modulation value
	
	; This is a 16-bit sign extension for 'bc'
	ld	b,0
	ld	c,(ix+15h)		; Get current modulation change per step -> 'c'
	bit	7,c				
	jp	z,+
	ld	b,0FFh			; Sign extend if negative
+
	add	hl,bc			; Add to current modulation value
	ld	(ix+17h),l
	ld	(ix+18h),h		; Store new 16-bit modulation value
	ld	c,(ix+0Dh)		; frequency low byte -> c
	ld	b,(ix+0Eh)		; frequency high byte -> b
	add	hl,bc			; Add modulation value
	ex	de,hl
	jp	(hl)			; WILL return to z*UpdateTrack
; End of function zDoModulation

; ---------------------------------------------------------------------------
; This the note -> frequency setting lookup
; the same array is found at $729CE in Sonic 1, and at $C9C44 in Ristar
; zword_359:
	ensure1byteoffset 8Ch
zPSGFrequencies:
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

;zloc_3E5
zFMPrepareNote:
	bit	1,(ix+0)		; Is track in rest?
	ret	nz				; If so, quit
	ld	e,(ix+0Dh)		; Get frequency low
	ld	d,(ix+0Eh)		; Get frequency high
	ld	a,d
	or	e
	jp	z,zloc_4C5		; If de == 0, go to zloc_4C5

;zloc_3F5
zFMUpdateFreq:
	bit	2,(ix+0)		; Is SFX overriding this track?
	ret	nz				; If so, quit!
	ld	h,0				; h = 0
	ld	l,(ix+19h)		; Get frequency adjust value
	; This is a 16-bit sign extension of (ix+19h)
	bit	7,l				; Did prior value have 80h set?
	jr	z,+				; If not, skip next step
	ld	h,0FFh			; h = FFh
+
	add	hl,de			; Alter frequency just a tad
	ld	c,h				; Upper part of frequency as data to FM ('c')
	ld	a,(ix+1)		; "playback control" byte -> 'a'
	and	3				; Strip to only channel assignment 
	add	a,0A4h			; Change to proper register
	rst	zWriteFMIorII	; Write it!
	ld	c,l				; lower part of frequency
	sub	4				; A0h+ register
	rst	zWriteFMIorII	; Write it!
	ret

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_414
zPSGUpdateTrack:
	dec	(ix+0Bh)					; decrement current duration timeout..
	jr	nz,+						; If not time-out yet, go do updates only
	res		4,(ix+0)				; Reset "do not attack next note" bit
	call	zPSGDoNext				; Handle coordination flags, get next note and duration
	call	zPSGDoNoteOn			; Actually key it (if allowed)
	call	zPSGDoVolFX				; This applies PSG volume as well as its special volume-based effects that I call "flutter"
	call	zDoModulation			; Update modulation (if modulation doesn't change, we do not return here)
	jp	zPSGUpdateFreq
+
	call	zNoteFillUpdate			; Applies "note fill" (time until cut-off); NOTE: Will not return here if "note fill" expires
	call	zPSGUpdateVolFX			; Update volume effects
	call	zDoModulation			; Update modulation (if modulation doesn't change, we do not return here)
	jp	zPSGUpdateFreq
; End of function zPSGUpdateTrack


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_438
zPSGDoNext:
	ld	l,(ix+3)		; Load track position low byte
	ld	h,(ix+4)		; Load track position high byte
	res	1,(ix+0)		; Clear bit 1 (02h) "track is rest" from track

-	ld	a,(hl)
	inc	hl				; Increment track to next byte
	cp	0E0h			; Is it a control byte / "coordination flag"?
	jr	c,+				; If not, jump over
	call	zCoordFlag	; Handle coordination flag
	jr	-				; Go around, get next byte
+
	or	a				; Test 'a' for 80h not set, which is a note duration
	jp	p,+				; If note duration, jump to '+'
	call	zPSGSetFreq	; Get frequency for this note
	ld	a,(hl)			; Get next byte
	or	a				; Test 'a' for 80h set, which is a note
	jp	m,zFinishTrackUpdate		; If this is a note, jump to zFinishTrackUpdate
	inc	hl				; Otherwise, go to next byte; a duration
+
	call	zSetDuration
	jp	zFinishTrackUpdate		; Either way, jumping to zFinishTrackUpdate...
; End of function zPSGDoNext

; ---------------------------------------------------------------------------

;zloc_460
zPSGSetFreq:
	sub	81h				; a = a-$81 (zero-based index from lowest note)
	jr	c,+				; If carry (only time that happens if 80h because of earlier logic) this is a rest!
	add	a,(ix+5)		; Add current channel key offset (coord flag E9)
	add	a,a				; Multiply note value by 2
	add	a,zPSGFrequencies&0FFh	; Point to proper place in table
	ld	(zloc_46D+2),a	; store into the instruction after zloc_46D (self-modifying code)
zloc_46D:
	ld	de,(zPSGFrequencies)	; Gets appropriate frequency setting -> 'de'
	ld	(ix+0Dh),e		; Frequency low byte   -> trackPtr + 0Dh
	ld	(ix+0Eh),d		; Frequency high byte  -> trackPtr + 0Eh
	ret
+
	; If you get here, we're doing a PSG rest
	set	1,(ix+0)		; Set "track in rest" bit
	ld	a,0FFh
	ld	(ix+0Dh),a		; Frequency low byte = FFh
	ld	(ix+0Eh),a		; Frequency hight byte = FFh
	jp	zPSGNoteOff		; Send PSG Note Off

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_487
zPSGDoNoteOn:
	bit	7,(ix+0Eh)		; If track is at rest (frequency was set to FFh)...
	jr	nz,zloc_4C5		; jump to zloc_4C5
	ld	e,(ix+0Dh)		; Frequency low byte -> e
	ld	d,(ix+0Eh)		; Frequency high byte -> d

;zloc_493
zPSGUpdateFreq:
	ld	a,(ix+0)		; Get playback control byte
	and	6
	ret	nz				; If either bit 1 ("track in rest") and 2 ("SFX overriding this track"), quit!
	; This is a 16-bit sign extension of (ix+19h) -> 'hl'
	ld	h,0
	ld	l,(ix+19h)		; hl = "alter notes" value (coord flag E9)
	bit	7,l				; Did prior value have 80h set?
	jr	z,+				; If not, skip next step
	ld	h,0FFh			; sign extend negative value
+
	add	hl,de			; Alter frequency just a tad
	; This picks out the reg to write to the PSG
	ld	a,(ix+1)		; Get "voice control" byte...
	cp	0E0h			; Is it E0h?
	jr	nz,+			; If not, skip next step
	ld	a,0C0h			; a = C0h instead of E0h
+
	ld	b,a				; 'a' -> 'b'
	ld	a,l				; Frequency low byte -> 'a'
	and	0Fh				; Keep only lower four bits (first PSG reg write only applies d0-d3 of freq)
	or	b				; Apply register bits
	ld	(zPSG),a		; Write it to PSG!
	ld	a,l				; Get frequency low byte -> 'a'
	srl	h				; (h >> 1); lowest bit into carry
	rra					; (a >> 1); carry from 'h' applied at end
	srl	h				; ... and so on ...
	rra
	rra
	rra					; in C, basically (hl >> 4) (except possible garbage from the rotation in upper bits)
	and	3Fh				; keep only lower 6 bits (PSG d4-d9)
	ld	(zPSG),a		; Write other frequency byte to PSG!
	ret
; ---------------------------------------------------------------------------

zloc_4C5:
	set	1,(ix+0)		; Set "track at rest" bit
	ret
; End of function zPSGDoNoteOn


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_4CA
zPSGUpdateVolFX:
	ld	a,(ix+8)		; Get current PSG tone
	or	a				; Test if it's zero
	ret	z				; If it is, return!
	; Otherwise, fall into zPSGDoVolFX...


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_4CF
zPSGDoVolFX:
	ld	b,(ix+6)		; Channel volume -> 'b'
	ld	a,(ix+8)		; Current PSG tone -> 'a'
	or	a				; Test it
	jr	z,zPSGUpdateVol		; If tone is zero, jump to zPSGUpdateVol
	ld	hl,zPSG_FlutterTbl	; hl points to zPSG_FlutterTbl table
	dec	a				; a--
	add	a,a				; a *= 2
	ld	e,a
	ld	d,0				; de = a
	add	hl,de			; Offset into pointer table...
	ld	a,(hl)			; Get low byte -> 'a'
	inc	hl				; Next byte
	ld	h,(hl)			; Get high byte into 'h'
	add	a,(ix+9)		; Apply PSG flutter (provides dynamic volume for special effects)
	ld	l,a
	adc	a,h
	sub	l
	ld	h,a				; Basically, hl = (hl+(ix+9))
	ld	a,(hl)			; Get byte from this location
	inc	(ix+9)			; Increment PSG flutter value
	or	a				; test byte from before
	jp	p,+				; Is it a positive value?
	cp	80h				; Check if it's 80h (terminator to the "flutter" list)
	jr	z,zloc_522		; If it is, then jump to zloc_522 (which just keeps at this flutter value, i.e. no more changes in volume)
+
	add	a,b				; Apply this "flutter" to channel volume -> 'a'
	ld	b,a				; a -> 'b'

;zloc_4F9
zPSGUpdateVol:
	ld	a,(ix+0)		; get playback control byte
	and	6
	ret	nz				; If either bit 1 ("track in rest") and 2 ("SFX overriding this track"), quit!
	bit	4,(ix+0)		; is "do not attack next note" set?
	jr	nz,zloc_515		; If so, jump to zloc_515

zloc_505:
	ld	a,b				; 'b' -> 'a'
	cp	10h				; Did the level get pushed below silence level? (i.e. a > 0Fh)
	jr	c,+
	ld	a,0Fh			; If so, fix it!
+
	or	(ix+1)			; Apply channel info (which PSG to set!)
	or	10h				; This bit marks it as an attenuation level assignment (along with channel info just above)
	ld	(zPSG),a		; Write to PSG!!
	ret
; ---------------------------------------------------------------------------

zloc_515:				; If you get here, then "do not attack next note" was set...
	ld	a,(ix+10h)		; Get master "note fill" value
	or	a				; test it
	jr	z,zloc_505		; If it's zero, then just process normally
	ld	a,(ix+0Fh)		; Otherwise, get current "note fill" value
	or	a				; Test it
	jr	nz,zloc_505		; If it's not zero, then just process normally
	ret
; ---------------------------------------------------------------------------

zloc_522:
	; This just decrements the flutter to keep it in place; no more volume changes in this list
	dec	(ix+9)
	ret
; End of function zPSGDoVolFX


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_526
zPSGNoteOff:
	bit	2,(ix+0)		; Is "SFX override" bit set?
	ret	nz				; If so, quit!
	ld	a,(ix+1)		; Get "voice control" byte (loads upper bits which specify attenuation setting)

	;                 |a| |1Fh|
	; VOL1    0x90	= 100 1xxxx	vol 4b xxxx = attenuation value
	; VOL2    0xb0	= 101 1xxxx	vol 4b
	; VOL3    0xd0	= 110 1xxxx	vol 4b
		
	or	1Fh				; Attenuation Off
	ld	(zPSG),a
	ret
; End of function zPSGNoteOff

; ---------------------------------------------------------------------------
; lookup table of FM note frequencies for instruments and sound effects
	ensure1byteoffset 0C0h
; zbyte_534:
zFrequencies:
	dw 025Eh,0284h,02ABh,02D3h,02FEh,032Dh,035Ch,038Fh,03C5h,03FFh,043Ch,047Ch
	dw 0A5Eh,0A84h,0AABh,0AD3h,0AFEh,0B2Dh,0B5Ch,0B8Fh,0BC5h,0BFFh,0C3Ch,0C7Ch
	dw 125Eh,1284h,12ABh,12D3h,12FEh,132Dh,135Ch,138Fh,13C5h,13FFh,143Ch,147Ch
	dw 1A5Eh,1A84h,1AABh,1AD3h,1AFEh,1B2Dh,1B5Ch,1B8Fh,1BC5h,1BFFh,1C3Ch,1C7Ch
	dw 225Eh,2284h,22ABh,22D3h,22FEh,232Dh,235Ch,238Fh,23C5h,23FFh,243Ch,247Ch
	dw 2A5Eh,2A84h,2AABh,2AD3h,2AFEh,2B2Dh,2B5Ch,2B8Fh,2BC5h,2BFFh,2C3Ch,2C7Ch
	dw 325Eh,3284h,32ABh,32D3h,32FEh,332Dh,335Ch,338Fh,33C5h,33FFh,343Ch,347Ch
	dw 3A5Eh,3A84h,3AABh,3AD3h,3AFEh,3B2Dh,3B5Ch,3B8Fh,3BC5h,3BFFh,3C3Ch,3C7Ch ; 96 entries


;zloc_5F4
zPSGSilenceAll:
	ld	hl,zPSG		; PSG reg
	ld	(hl),9Fh	; Stop channel 0
	ld	(hl),0BFh	; Stop channel 1
	ld	(hl),0DFh	; Stop channel 2
	ld	(hl),0FFh	; Stop noise channel
	ret

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
;zsub_600
zPauseMusic:
	jp	m,+		; If we are to unpause music, branch
	ld	a,(zPaused)		; Get paused flag
	or	a				; Are we paused already?
	ret	nz				; If so, return
	ld	a,0FFh			; a = 0FFh
	ld	(zPaused),a		; Set paused flag
	call	zFMSilenceAll
	jp	zPSGSilenceAll
+
	push	ix			; Save ix
	ld	(ix+3),0		; Clear pause/unpause flag
	xor	a				; a = 0
	ld	(zPaused),a		; Clear paused flag
	ld	ix,zTracksStart	; ix = pointer to track RAM
	ld	b,7				; 1 DAC + 6 FM
	call	zResumeTrack

	bankswitch SoundIndex	; Now for SFX

	ld	a,0FFh			; a = 0FFH
	ld	(zDoSFXFlag),a	; Set flag to say we are updating SFX
	ld	ix,zTracksStart+zTrackSz*10	; ix = pointer to SFX track RAM
	ld	b,3				; 3 FM
	call	zResumeTrack
	xor	a				; a = 0
	ld	(zDoSFXFlag),a	; Clear SFX updating flag
	call	zBankSwitchToMusic	; Back to music
	pop	ix				; Restore ix
	ret
; End of function zPauseMusic


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
;zsub_64D
zResumeTrack:
	bit	7,(ix+0)		; Is track playing?
	jr	z,+				; Branch if not
	bit	2,(ix+0)		; Is SFX overriding track?
	jr	nz,+			; Branch if not
	ld	c,(ix+7)		; AMS/FMS/panning flags
	ld	a,(ix+1)		; Get voice control bits...
	and	3				; ... the FM portion of them
	add	a,0B4h			; Command to select AMS/FMS/panning register
	rst	zWriteFMIorII
	push	bc			; Save bc
	ld	c,(ix+8)		; Current track FM instrument
	call	cfSetVoiceCont
	pop	bc				; Restore bc
+
	ld	de,zTrackSz		; de = Track size
	add	ix,de			; Advance to next track
	djnz	zResumeTrack	; loop
	ret
; End of function zResumeTrack


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
;zsub_674
zCycleQueue:
	ld	a,(zQueueToPlay)	; Check if a sound request was made zComRange+08h
	cp	80h					; Is queue slot equal to 80h?
	ret	nz					; If not, return
	ld	hl,zSFXToPlay		; Get address of next sound
	ld	a,(zComRange)		; Get current SFX priority
	ld	c,a					; a -> c
	ld	b,3					; b = 3

-	ld	a,(hl)				; Get sound to play -> 'a'
	ld	e,a					; 'a' -> 'e'
	ld	(hl),0				; Clear it back to zero (we got it)
	inc	hl					; hl = pointer to next queue item
	cp	MusID__First		; Is it before first music?
	jr	c,zlocQueueNext		; if so, branch
	cp	MusID_StopSFX		; Is it a special command?
	jr	nc,zlocQueueItem	; If so, branch
	sub	SndID__First		; Subtract first SFX index
	jr	c,zlocQueueItem		; If it was music, branch
	add	a,zSFXPriority&0FFh	; a = low byte of pointer to SFX priority
	ld	l,a					; l = low byte of pointer to SFX priority
	adc	a,(zSFXPriority&0FF00h)>>8	; a = low byte of pointer to SFX priority + high byte of same pointer
	sub	l					; a = high byte of pointer to SFX priority
	ld	h,a					; hl = pointer to SFX priority
	ld	a,(hl)				; Get SFX priority
	cp	c					; Is the new SFX of a higher priority?
	jr	c,+					; Branch if not
	ld	c,a					; Save new priotity
	call	zlocQueueItem	; Queue the new SFX
+
	ld	a,c					; Get back SFX priority
	or	a					; Is it negative (jumping sound)?
	ret	m					; Return if so
	ld	(zComRange),a		; Store the new priority
	ret
; ---------------------------------------------------------------------------
zlocQueueNext:
	djnz	-
	ret
; ---------------------------------------------------------------------------
zlocQueueItem:
	ld	a,e				; restore a to be the last queue item read
	ld	(zQueueToPlay),a	; Put it as the next item to play
	ret
; End of function zCycleQueue


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; zsub_6B2:
zPlaySoundByIndex:
	or	a							; is it sound 00?
	jp	z,zClearTrackPlaybackMem	; if yes, branch to RESET EVERYTHING!!
    if MusID__First-1 == 80h
	ret	p							; return if it was (invalidates 00h-7Fh; maybe we don't want that someday?)
    else
	cp	MusID__First
	ret	c		; return if id is less than the first music id
    endif
	
	ld	(ix+8),80h					; Rewrite zComRange+8 flag so we know nothing new is coming in 
	cp	MusID__End					; is it music (less than index 20)?
	jp	c,zPlayMusic				; if yes, branch to play the music
	cp	SndID__First				; is it not a sound? (this check is redundant if MusID__End == SndID__First...)
	ret	c							; if it isn't a sound, return (do nothing)
	cp	SndID__End					; is it a sound (less than index 71)?
	jp	c,zPlaySound_CheckRing		; if yes, branch to play the sound
	cp	MusID_StopSFX				; is it after the last regular sound but before the first special sound command (between 71 and 78)?
	ret	c							; if yes, return (do nothing)
	cp	MusID_Pause					; is it sound 7E or 7F (pause all or resume all)
	ret	nc							; if yes, return (those get handled elsewhere)
	; Otherwise, this is a special command to the music engine...
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
	ld	a,2Bh			; DAC enable/disable register
	ld	c,80h			; Command to enable DAC
	rst	zWriteFMI

	bankswitch Snd_Sega	; Want Sega sound

	ld	hl,zmake68kPtr(Snd_Sega) ; was: 9E8Ch
	ld	de,(Snd_Sega_End - Snd_Sega)/2	; was: 30BAh
	ld	a,2Ah			; DAC data register
	ld	(zYM2612_A0),a	; Select it
	ld	c,80h			; If zQueueToPlay is not this, stops Sega PCM

-	ld	a,(hl)			; Get next PCM byte
	ld	(zYM2612_D0),a	; Send to DAC
	inc	hl				; Advance pointer
	nop
	ld	b,0Ch			; Sega PCM pitch
	djnz	$			; Delay loop

	nop
	ld	a,(zQueueToPlay)	; Get next item to play
	cp	c				; Is it 80h?
	jr	nz,+			; If not, stop Sega PCM
	ld	a,(hl)			; Get next PCM byte
	ld	(zYM2612_D0),a	; Send to DAC
	inc	hl				; Advance pointer
	nop
	ld	b,0Ch			; Sega PCM pitch
	djnz	$			; Delay loop
	
	nop
	dec	de				; 2 less bytes to play
	ld	a,d				; a = d
	or	e				; Is de zero?
	jp	nz,-			; If not, loop
+
	call	zBankSwitchToMusic
	ld	a,(zComRange+15h)	; DAC status
	ld	c,a				; c = DAC status
	ld	a,2Bh			; DAC enable/disable register
	rst	zWriteFMI
	ret
; ---------------------------------------------------------------------------
; zloc_73D:
zPlayMusic:
	push	af
	call	zStopSoundEffects		; Stop all sounds before starting BGM
	pop	af
	ld	(zCurSong),a				; Get current BGM
	cp	MusID_ExtraLife				; If NOT 1-up sound...
	jr	nz,zloc_784					; ... skip over the following code
	; The following code disables all sound (technically for duration of 1-up)
	ld	a,(zComRange+11h)			; Check if 1-up sound is already playing
	or	a							; Test it
	jr	nz,zBGMLoad					; If it is, then just reload it!  (I suppose a humorous restore-to-1up could happen otherwise... with no good results after that)
	ld	ix,zTracksStart				; Starting at beginning of all tracks...
	ld	de,zTrackSz					; Each track size
	ld	b,0Ah						; All 10 (DAC, 6FM, 3PSG) tracks

-	res	2,(ix+0)					; Clear "SFX is overriding" bit (no SFX are allowed!)
	add	ix,de						; Next track
	djnz	-

	ld	ix,zTracksStart+zTrackSz*10		; 'ix' points to start of SFX track memory (10 prior tracks were DAC, 6 FM, 3 PSG)
	ld	b,6							; 6 SFX tracks total (3FM, 3PSG)

-	res	7,(ix+0)					; Clear "is playing" bit!  (No SFX allowed!)
	add	ix,de						; Next track
	djnz	-

	; This performs a "massive" backup of all of the current track positions 
	; for restoration after 1-up BGM completes
	ld	de,z1upBackup		; Backup memory address
	ld	hl,zComRange		; Starts from zComRange
	ld	bc,z1upBackupSz		; for this many bytes
	ldir					; Go!
	ld	a,80h
	ld	(zComRange+11h),a	; Set 1-up song playing flag
	xor	a
	ld	(zComRange),a		; Clears SFX priority
	jr	zBGMLoad			; Now load 1-up BGM
; ---------------------------------------------------------------------------

zloc_784:
	xor	a
	ld	(zComRange+11h),a	; clear 1-up is playing flag (it isn't)
	ld	(zComRange+10h),a	; clear fade-in frame count
	ld	(zComRange+4),a		; clear fade-out frame count

;zloc_78E
zBGMLoad:
	call	zInitMusicPlayback
	ld	a,(zCurSong)			; So, let's take your desired song, put it into 'a'
	sub	MusID__First			; Make it a zero-based entry ...
	ld	e,a						; Transform 'a' into 16-bit de
	ld	d,0
	ld	hl,zSpedUpTempoTable			; Load 'hl' of "sped up" tempos [I think]
	add	hl,de					; Offset by 16-bit version of song index to proper tempo
	ld	a,(hl)					; Get value at this location -> 'a'
	ld	(zTempoTurbo),a		; Store 'a' here (provides an alternate tempo or something for speed up mode)
	ld	hl,zMasterPlaylist		; Get address of the zMasterPlaylist
	add	hl,de					; Add the 16-bit offset here
	ld	a,(hl)					; Get "fixed" index
	ld	b,a						; 'a' -> 'b'
	; The following instructions enable a bankswitch routine
	and	80h						; Clear 'a' back to an index
	ld	(zComRange+16h),a		; Store this ??? (Was used to enable alternate bank)
	ld	a,b						; Restore 'a' to +80h version
	add	a,a						; Adding a+a+a causes an overflow and a multiplication by 2
	add	a,a						; Now multiplied by 4
	ld	c,a						; Result -> 'c'
	ccf							; Clear carry flag...
	sbc	a,a						; ... reverse subtract with carry that was set to zero ... umm.. a=0 in a funny way?
	ld	(zIsPalFlag),a			; Clear zIsPalFlag?
	ld	a,c						; Put prior multiply result back in
	add	a,a						; Now multiplied by 8!
	sbc	a,a						; This is nonzero if bit 5 of original a is set, zero otherwise (uncompressed song flag)
	push	af					; Backing up result...?
	ld	a,b						; Put 80h based index -> 'a'
	and	zFirstSound-1			; Caps maximum number of BGMs; Used to be 1Fh, but I figure this enables easier extension if I want any
	add	a,a		; multiply by 2; now 'a' is offset into music table, save for the $8000	
	ld	e,a
	ld	d,0		; de = a
	ld	hl,zROMWindow
	add	hl,de	; "hl" now contains 2-byte offset for music address table lookup
	push	hl	; Save 'hl' (will be damaged by bank switch)
	call	zBankSwitchToMusic	; Bank switch to start of music in ROM!
	pop	hl		; Restore 'hl'
	ld	e,(hl)
	inc	hl
	ld	d,(hl)	; Getting offset within bank to music -> de

	; If we bypass the Saxman decompressor, the Z80 engine starts
	; with the assumption that we're already decompressed with 'de' pointing
	; at the decompressed data (which just so happens to be the ROM window)
	pop	af
	or	a		; Was the uncompressed song flag set?
	jr	nz,+	; Bypass the Saxman decompressor if so

	; This begins a call to the Saxman decompressor:
	ex	de,hl
	exx
	push	hl
	push	de
	push	bc
	exx
	call	zSaxmanDec
	exx
	pop	bc
	pop	de
	pop	hl
	exx
	ld	de,zMusicData	; Saxman compressed songs start at zMusicData (1380h)
+
	; Begin common track init code
	push	de
	pop	ix					; ix = de (BGM's starting address)
	ld	e,(ix+0)			; Get voice table pointer low byte -> 'e'
	ld	d,(ix+1)			; Get voice table pointer high byte -> 'd'
	ld	(zVoiceTblPtr),de	; Set master copy of this value in local memory
	ld	a,(ix+5)			; Get main tempo value
	ld	(zComRange+12h),a	; Store it at (zComRange+12h)
	ld	b,a					; tempo -> 'b'
	ld	a,(zComRange+14h)	; Get found speed shoe flag (zComRange+14h) (preloaded before this)
	or	a					; test it
	ld	a,b					; Restore normal song tempo
	jr	z,+					; if the speed shoe flag was zero, skip this step
	ld	a,(zTempoTurbo)		; Put the corresponding speed shoe tempo for song
+
	ld	(zComRange+2),a		; Current tempo for TempoWait
	ld	(zComRange+1),a		; Tempo accumulator for TempoWait
	ld	a,5
	ld	(zPALUpdTick),a		; reset PAL update tick to 5 (update immediately)
	push	ix
	pop	hl					; hl = ix (BGM's starting address)
	ld	de,6
	add	hl,de				; +06h (to DAC pointer)
	ld	a,(ix+2)			; Get number of FM+DAC channels this BGM has
	or	a					; Test it
	jp	z,zloc_884			; If zero, then don't init any
	ld	b,a					; 'a' -> 'b' (num FM+DAC channels this song, for loop)
	push	iy				; Save 'iy'
	ld	iy,zTracksStart		; 'iy' points to start of track memory
	ld	c,(ix+4)			; Get tempo divider -> 'c'
	ld	de,zFMDACInitBytes	; 'de' points to zFMDACInitBytes

-	ld	(iy+0),82h			; At "playback control" byte of this track, set "track is playing" bit and "SFX is overriding" (?) bit (I think just to keep it from playing until init is done)
	ld	a,(de)				; Get current byte from zFMDACInitBytes -> 'a'
	inc	de					; will get next byte from zFMDACInitBytes next time
	ld	(iy+1),a			; Store this byte to "voice control" byte
	ld	(iy+2),c			; Store timing divisor from header for this track
	ld	(iy+0Ah),zTrackSz	; set "gosub" (coord flag F8h) stack init value (starts at end of this track's memory)
	ld	(iy+7),0C0h			; default Panning / AMS / FMS settings (only stereo L/R enabled)
	ld	(iy+0Bh),1			; set current duration timeout to 1 (should expire next update, play first note, etc.)
	push	de				; saving zFMDACInitBytes pointer
	push	bc				; saving number of channels and tempo divider ('bc' gets needlessly damaged by 'ldi' instructions coming up)
	ld	a,iyl				; current track pointer low byte -> 'a'
	add	a,3
	ld	e,a
	adc	a,iyu
	sub	e
	ld	d,a					; de = iy + 3 ('de' is pointing to track offset address)
	ldi						; *de++ = *hl++ (copy track address low byte from header to track's copy of this value)
	ldi						; *de++ = *hl++ (copy track address high byte from header to track's copy of this value)
	ldi						; *de++ = *hl++ (default key offset, typically 0, can be set later by coord flag E9)
	ldi						; *de++ = *hl++ (track default volume)
	ld	de,zTrackSz			; size of all tracks -> 'de'
	add	iy,de				; offset to next track!
	pop	bc					; restore 'bc' (number of channels and tempo divider)
	pop	de					; restore 'de' (zFMDACInitBytes current pointer)
	djnz	-				; loop for all tracks we're init'ing...
	; End of FM+DAC track init loop

	pop	iy					; restore 'iy'
	ld	a,(ix+2)			; 'ix' still points to start of BGM; get number of FM+DAC -> 'a'
	cp	7					; Does it equal 7?  (6 FM channels)
	jr	nz,+				; If not, skip this next part
	xor	a					; Clear 'a'
	ld	c,a					; c = 0
	jr	zloc_87E			; jump to zloc_87E
+
	; Silence FM Channel 6 specifically if it's not in use
	ld	a,28h				; Key on/off FM register
	ld	c,6					; FM channel 6
	rst	zWriteFMI			; All operators off
	ld	a,42h				; Starting at FM Channel 6 Operator 1 Total Level register
	ld	c,0FFh				; Silence value
	ld	b,4					; Write to all four FM Channel 6 operators

	; Set all TL values to silence!
-	rst	zWriteFMII
	add	a,4					; Next operator
	djnz	-

	ld	a,0B6h				; Set Panning / AMS / FMS
	ld	c,0C0h				; default Panning / AMS / FMS settings (only stereo L/R enabled)
	rst	zWriteFMII			; Set it!
	ld	a,80h				; FM Channel 6 is NOT in use (will enable DAC)
	ld	c,a					; Set this as value to be used in FM register write coming up...

zloc_87E:
	ld	(zComRange+15h),a	; Note whether FM Channel 6 is in use (enables DAC if not)
	ld	a,2Bh				; Set DAC Enable appropriately
	rst	zWriteFMI			; Set it!

	; End of DAC/FM init, begin PSG init
	
zloc_884:
	ld	a,(ix+3)			; Get number of PSG tracks
	or	a					; Test it
	jp	z,zloc_8D0			; If zero, skip this part!
	ld	b,a					; 'a' -> 'b' (num PSG tracks this song, for loop)
	push	iy				; Save 'iy'
	ld	iy,zTracksStart+zTrackSz*7		; 'iy' points to start of PSG track memory (7 prior tracks were DAC and 6 FM)
	ld	c,(ix+4)			; Get tempo divider -> 'c'
	ld	de,zPSGInitBytes	; 'de' points to zPSGInitBytes

-	ld	(iy+0),82h			; At "playback control" byte of this track, set "track is playing" bit and "SFX is overriding" (?) bit (I think just to keep it from playing until init is done)
	ld	a,(de)				; Get current byte from zPSGInitBytes -> 'a'
	inc	de					; will get next byte from zPSGInitBytes next time
	ld	(iy+1),a			; Store this byte to "voice control" byte
	ld	(iy+2),c			; Store timing divisor from header for this track
	ld	(iy+0Ah),zTrackSz	; "gosub" stack init value
	ld	(iy+0Bh),1			; set current duration timeout to 1 (should expire next update, play first note, etc.)
	push	de				; saving zPSGInitBytes pointer
	push	bc				; saving number of channels and tempo divider ('bc' gets needlessly damaged by 'ldi' instructions coming up)
	ld	a,iyl				; current track pointer low byte -> 'a'
	add	a,3
	ld	e,a
	adc	a,iyu
	sub	e
	ld	d,a					; de = iy + 3 ('de' is pointing to track offset address)
	ldi						; *de++ = *hl++ (copy track address low byte from header to track's copy of this value)
	ldi						; *de++ = *hl++ (copy track address high byte from header to track's copy of this value)
	ldi						; *de++ = *hl++ (default key offset, typically 0, can be set later by coord flag E9)
	ldi						; *de++ = *hl++ (track default volume)
	inc	hl					; Get default PSG tone
	ld	a,(hl)				; -> 'a'
	inc	hl					; This byte is usually the same as the prior, unused
	ld	(iy+8),a			; Store current PSG tone
	ld	de,zTrackSz			; size of all tracks -> 'de'
	add	iy,de				; offset to next track!
	pop	bc					; restore 'bc' (number of channels and tempo divider)
	pop	de					; restore 'de' (zPSGInitBytes current pointer)
	djnz	-				; loop for all tracks we're init'ing...

	pop	iy					; restore 'iy'
	; End of PSG tracks init, begin SFX tracks init

zloc_8D0:
	ld	ix,zTracksStart+zTrackSz*10		; 'ix' points to start of SFX track memory (10 prior tracks were DAC, 6 FM, 3 PSG)
	ld	b,6					; 6 SFX tracks total (3FM, 3PSG)
	ld	de,zTrackSz			; size between tracks

zloc_8D9:
	bit	7,(ix+0)			; Is this track currently playing?
	jr	z,zloc_8FB			; If not, jump to zloc_8FB (no work to do!)
	ld	a,(ix+1)			; Get "voice control" byte...
	or	a					; Test it
	jp	m,+					; If this is a PSG track, jump to '+'
	sub	2					; Otherwise, subtract 2...
	add	a,a					; ... multiply by 2 (preparing to index starting from FM 3 only)
	jr	zloc_8F1			; Jump to zloc_8F1 (general track setup)
+
	rra
	rra
	rra
	rra
	and	0Fh					; for PSG, just shift it down by 4 and we have its index!

zloc_8F1:
	add	a,zMusicTrackOffs&0FFh	; get offset into appropriate music track...
	ld	(zloc_8F6+1),a			; store into the instruction after zloc_8F6 (self-modifying code)
zloc_8F6:
	ld	hl,(zMusicTrackOffs)	; This loads address of coorresponding MUSIC track (the track that this SFX track would normally play over)
	res	2,(hl)				; Clear the "SFX override" bit; this SFX track isn't overriding that music track now

zloc_8FB:
	add	ix,de				; Next track..
	djnz	zloc_8D9		; Loop for all tracks
	; End of SFX tracks init...

	ld	ix,zTracksStart+zTrackSz*1	; 'ix' points to first FM music track
	ld	b,6							; For all 6 of those...

-	call	zFMNoteOff				; Send Key Off
	add	ix,de						; Next track
	djnz	-

	ld	b,3							; For all 3 PSG tracks...

-	call	zPSGNoteOff				; Send Note Off
	add	ix,de						; Next track
	djnz	-

	ret

; ---------------------------------------------------------------------------
; FM channel assignment bits
;zbyte_916
zFMDACInitBytes:
	db    6,   0,   1,   2,   4,   5,   6		; first byte is for DAC; then notice the 0, 1, 2 then 4, 5, 6; this is the gap between parts I and II for YM2612 port writes

; Default values for PSG tracks
;zbyte_91D
zPSGInitBytes:
	db  80h,0A0h,0C0h	; Specifically, these configure writes to the PSG port for each channel

; zloc_920:
zPlaySound_CheckRing:
	ld	c,a								; Store sound index -> 'c'
	ld	a,(ix+11h)						; Get "is 1-up playing" flag...
	or	(ix+0Eh)						; Or it with fading in flag
	jp	nz,zloc_KillSFXPrio				; If either is set, SFX cannot be played!!
	xor	a
	ld	(zSpindashActiveFlag),a			; Clear spindash sound flag
	ld	a,c								; Sound index -> 'a'
	cp	SndID_Ring						; is this the ring sound?
	jr	nz,zPlaySound_CheckGloop		; if not, branch
	; This is the ring sound...
	ld	a,(zRingSpeaker)				; 0 plays left, FFh plays right
	or	a								; Test it
	jr	nz,+							; If it's not zero, we skip this next step
	ld	c,SndID_RingLeft				; do something different (probably speaker change)...
+
	cpl									; If it was 0, it's now FFh, or vice versa
	ld	(zRingSpeaker),a				; Store new ring speaker value (other side)
	jp	zPlaySound						; now play the play the ring sound
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

	bankswitch SoundIndex				; Switch to SFX banks

	ld	hl,zmake68kPtr(SoundIndex)		; 'hl' points to beginning of SFX bank in ROM window
	ld	a,c								; 'c' -> 'a'
	sub	SndID__First					; Bring 'a' down to index value
	add	a,a								; Multiply it by 2
	ld	e,a
	ld	d,0								; de = a
	add	hl,de							; now hl points to a pointer in the SoundIndex list (such as rom_ptr_z80 Sound20)
	ld	a,(hl)	
	inc	hl
	ld	h,(hl)
	ld	l,a								; now hl points to a sound's data (such as Sound20: ...)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)							; 'de' points to custom voice table (if any; otherwise is 0000h)
	inc	hl
	ld	(zloc_A26+1),de	; store into the instruction after zloc_A26 (self-modifying code)
	ld	c,(hl)							; Timing divisor -> 'c'
	inc	hl
	ld	b,(hl)							; Total channels used -> 'b'
	inc	hl

zloc_99F:
	push	bc							; backup divisor/channel usage
	xor	a								; a = 0 (will end up being NO CUSTOM VOICE TABLE!)
	ld	(zloc_A1D+1),a ; store into the instruction after zloc_A1D (self-modifying code) (Kind of pointless, always sets it to zero... maybe PSG would've had custom "flutter" tables?)
	push	hl							; save current position within sound (offset 04h)
	inc	hl								; next byte...
	
	ld	a,(hl)							; Track sound def -> 'a' (if 80h set, it's PSG, otherwise it's FM) -- note this also tells what channel it's on (80, A0, C0 for PSG, FM channel assignments otherwise)
	or	a								; test it
	jp	m,+								; if bit 7 (80h) set (meaning PSG track), skip next part...
	sub	2								; Subtract 2 from this value
	add	a,a								; Multiply it by 2
	jp	zloc_9CA						; This is an FM sound track...
+
	; This is a PSG track!
	; Always ends up writing zero to voice table pointer?
	ld	(zloc_A1D+1),a	; store into the instruction after zloc_A1D (self-modifying code)
	cp	0C0h							; Is this PSG3?
	jr	nz,+							; If not, skip this part
	push	af
	or	1Fh								; Set silence on PSG!
	ld	(zPSG),a
	xor	20h
	ld	(zPSG),a
	pop	af
+
	rra
	rra
	rra
	rra
	and	0Fh					; for PSG, just shift it down by 4 and we have its index!

zloc_9CA:
	add	a,zMusicTrackOffs&0FFh			; Offset to cooresponding music track
	ld	(zloc_9CF+1),a	; store into the instruction after zloc_9CF (self-modifying code)
zloc_9CF:
	ld	hl,(zMusicTrackOffs)			; 'hl' is now start of cooresponding music track 
	set	2,(hl)							; Set "SFX is overriding this track!" bit
	add	a,zSFXTrackOffs-zMusicTrackOffs	; Jump to cooresponding SFX track
	ld	(zloc_9D9+2),a	; store into the instruction after zloc_9D9 (self-modifying code)
zloc_9D9:
	ld	ix,(zSFXTrackOffs)				; 'ix' is now start of corresponding SFX track
	
	; Little bit busy there, but basically for a given 'a' value, where a == 0
	; means first SFX track (FM3), 'hl' now points to the music track and 'ix' points
	; to the SFX track that both coorespond to track 'a'
	
	; Now we're going to clear this SFX track...
	ld	e,ixl
	ld	d,ixu							; de = ix
	push	de							; save 'de'
	ld	l,e								; hl = de (start of SFX track)
	ld	h,d
	ld	(hl),0							; store 00h on first byte of track
	inc	de								; next byte...
	ld	bc,zTrackSz-1					; For all bytes in the track, minus 1 (since we're copying 00h from first byte)
	ldir								; Clear track memory!
	pop	de								; Restore 'de' (start of SFX track yet again)
	pop	hl								; Get 'hl' back from way before (offset of sound in ROM + 04h)
	ldi									; *de++ = *hl++ (write playback control byte) (... not really sure why this is used)
	ldi									; *de++ = *hl++ (write voice control byte) (sets whether is PSG or what)
	pop	bc								; restore 'bc'...
	push	bc							; ... Um, back it up again!
	ld	(ix+2),c						; Set timing divisor of SFX track
	ld	(ix+0Bh),1						; current duration timeout to 1 (will expire immediately and thus update)
	ld	(ix+0Ah),zTrackSz				; Reset track "gosub" stack
	ld	a,e
	add	a,1
	ld	e,a
	adc	a,d
	sub	e
	ld	d,a								; de += 1 (skip timing divisor; already set)
	ldi									; *de++ = *hl++ (track position low byte)
	ldi									; *de++ = *hl++ (track position high byte)
	ldi									; *de++ = *hl++ (key offset)
	
	; If spindash active, the following block updates its frequency specially:
	ld	a,(zSpindashActiveFlag)
	or	a
	jr	z,+									; If spindash not last sound played, skip this
	ld	a,(zSpindashExtraFrequencyIndex)	; Get current frequency index
	dec	de									; Go back to key offset
	ex	de,hl								; hl <=> de
	add	a,(hl)								; Add spindash key offset!
	ex	de,hl								; de <=> hl (just done because we wanted add a,(hl))
	ld	(de),a								; Store it!
	inc	de									; Go passed key offset again
+
	ldi									; *de++ = *hl++ (channel volume)
zloc_A1D:	; Modified way back within zloc_99F
	ld	a,0								; "self-modified code"; if 00h, no custom voice table defined for this track
	or	a								; Test it
	jr	nz,+							; If not zero, skip next part...
	ld	(ix+7),0C0h						; Default panning / AMS / FMS settings (just L/R Stereo enabled)
zloc_A26:
	ld	de,0 ; "self-modified code"		; This will be modified to custom voice table address (possibly still 0000h)
	ld	(ix+1Ch),e						; low byte of custom voice table (for SFX)
	ld	(ix+1Dh),d						; high byte of custom voice table (for SFX)
+
	pop	bc								; restore divisor (c) and channel counts (b0)
	dec	b								; One less FM channel
	jp	nz,zloc_99F						; If more to go, loop!
	
	jp	zBankSwitchToMusic				; Otherwise, prepare to do music...
; ---------------------------------------------------------------------------

zloc_KillSFXPrio:
	xor	a
	ld	(zComRange),a					; Reset SFX priority
	ret
; End of function zPlaySoundByIndex


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; zsub_A3C:
zStopSoundEffects:
	xor	a
	ld	(zComRange),a					; Reset SFX priority
	ld	ix,zTracksStart+zTrackSz*10		; 'ix' points to start of SFX track memory (10 prior tracks were DAC, 6 FM, 3 PSG)
	ld	b,6								; All 6 SFX tracks...

zloc_A46:
	push	bc							; Save 'bc'
	bit	7,(ix+0)						; Check if this track was playing
	jp	z,zloc_AB6						; If not 
	res	7,(ix+0)						; You're not playing anymore!
	res	4,(ix+0)						; Not not attacking, either
	ld	a,(ix+1)						; Get "voice control" byte
	or	a								; Test it
	jp	m,zloc_A89						; If 80h set (PSG Track) jump to zloc_A89
	push	af
	call	zFMNoteOff					; FM Key off
	pop	af
	push	ix
	sub	2								; Determine proper cooresponding music track (starting on FM3, so subtract 2 from channel assignment)
	add	a,a								; Multiply by 2 (each index 2 bytes)
	add	a,zMusicTrackOffs&0FFh			; Get offset -> 'a'
	ld	(zloc_A6C+2),a	; store into the instruction after zloc_A6C (self-modifying code)
zloc_A6C:
	ld	ix,(zMusicTrackOffs) ; "self-modified code"; will load appropriate cooresponding music track address
	bit	2,(ix+0)						; Was this music track is overridden by an SFX track?
	jr	z,+								; If not, do nothing
	res	2,(ix+0)						; Otherwise, tell it is is no longer!
	set	1,(ix+0)						; Set track to rest
	ld	a,(ix+8)						; Get current voice
	call	zSetVoiceMusic				; Reset FM voice
+
	pop	ix
	jp	zloc_AB6						; jump down to loo
; ---------------------------------------------------------------------------

zloc_A89:
	push	af
	call	zPSGNoteOff					; PSG Note off
	pop	af
	push	ix
	rra
	rra
	rra
	rra
	and	0Fh		; 'a' is now 08, 0A, 0C, or 0E
	add	a,zMusicTrackOffs&0FFh
	ld	(zloc_A9B+2),a	; store into the instruction after zloc_A9B (self-modifying code)
zloc_A9B:
	ld	ix,(zMusicTrackOffs) ; self-modified code from just above; 'ix' points to cooresponding Music PSG track
	res	2,(ix+0)						; tell this track it is is no longer overridden by SFX!
	set	1,(ix+0)						; Set track to rest
	ld	a,(ix+1)						; Get playback control
	cp	0E0h							; Is this a PSG 3 noise (not tone) track?
	jr	nz,+							; If it isn't, don't do next part (non-PSG Noise doesn't restore)
	ld	a,(ix+1Bh)						; Get PSG noise setting
	ld	(zPSG),a						; Write it to PSG
+
	pop	ix

zloc_AB6:
	ld	de,zTrackSz
	add	ix,de				; Got to next track
	pop	bc					; Restore 'bc'
	djnz	zloc_A46		; Loop around...
	ret
; End of function zStopSoundEffects

; ---------------------------------------------------------------------------
; zloc_ABF:
zFadeOutMusic:
	ld	a,3
	ld	(zComRange+5),a			; Set delay ticker to 3
	ld	a,28h
	ld	(zComRange+4),a			; Set total frames to decrease volume over
	xor	a
	ld	(zTracksStart),a		; Stop DAC track (can't fade it)
	ld	(zComRange+14h),a		; No speed shoe tempo?
	ret

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_AD1
zUpdateFadeout:
	ld	a,(zComRange+5)				; Get current tick count before next volume decrease
	or	a
	jr	z,+							; If not yet zero...
	dec	(ix+5)						; Just decrement it
	ret
+
	dec	(ix+4)						; Otherwise, decrement fadeout!
	jp	z,zClearTrackPlaybackMem	; If it hits zero, clear everything!
	ld	(ix+5),3					; Otherwise, reload tick count with 3
	push	ix
	ld	ix,zTracksStart+zTrackSz*1	; 'ix' points to first FM music track
	ld	b,6							; 6 FM tracks to follow...

zloc_AED:
	bit	7,(ix+0)					; Is this track playing?
	jr	z,zloc_B04					; If not, do nothing
	inc	(ix+6)						; increment channel volume (remember -- higher is quieter!)
	jp	p,+							; don't let it overflow
	res	7,(ix+0)					; otherwise, stop playing this track
	jr	zloc_B04					; just loop
+
	push	bc
	call	zSetChanVol				; need to update volume
	pop	bc

zloc_B04:
	ld	de,zTrackSz	
	add	ix,de						; Next track
	djnz	zloc_AED				; Keep going for all FM tracks...
	ld	b,3							; 3 PSG tracks to follow...

zloc_B0D:
	bit	7,(ix+0)					; Is this track playing?
	jr	z,zloc_B2C					; If not, do nothing
	inc	(ix+6)						; increment channel volume (remember -- higher is quieter!)
	ld	a,10h
	cp	(ix+6)						; don't let volume go over 0Fh on PSG tracks!
	jp	nc,+
	res	7,(ix+0)					; Otherwise, stop playing this track
	jr	zloc_B2C
+
	push	bc
	ld	b,(ix+6)					; Channel volume -> 'b'
	call	zPSGUpdateVol			; Update volume
	pop	bc

zloc_B2C:
	ld	de,zTrackSz
	add	ix,de						; Next track
	djnz	zloc_B0D				; Keep going for all PSG tracks...
	pop	ix
	ret
; End of function zUpdateFadeout


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_B36
zFMSilenceAll:
	ld	a,28h			; Start at FM KEY ON/OFF register
	ld	b,3				; Three key on/off per part

-	ld	c,b				; Current key off -> 'c'
	dec	c				; c--
	rst	zWriteFMI		; Write key off for part I 
	set	2,c				; Set part II select
	rst	zWriteFMI		; Write key off for part II
	djnz	-

	ld	a,30h			; Starting at FM register 30h...
	ld	c,0FFh			; Write dummy kill-all values
	ld	b,60h			; ... up to register 90h

-	rst	zWriteFMI		; ... on part I
	rst	zWriteFMII		; ... and part II
	inc	a				; Next register!
	djnz	-

	ret
; End of function zFMSilenceAll

; ---------------------------------------------------------------------------
; zloc_B4E:
zStopSoundAndMusic:
	xor	a
	ld	(zComRange+3),a

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_B52
zClearTrackPlaybackMem:
	; This totally wipes out the track memory and resets playback hardware
	ld	a,2Bh						; DAC Enable register
	ld	c,80h						; Enable DAC
	rst	zWriteFMI					; Write it!
	ld	a,c							; 80h -> 'a'
	ld	(zComRange+15h),a			; Store that to DAC Enabled byte
	ld	a,27h						; Channel 3 special settings
	ld	c,0							; All clear
	rst	zWriteFMI					; Write it!
	; This performs a full clear across all track/playback memory
	ld	hl,zComRange
	ld	de,zComRange+1
	ld	(hl),0						; Starting byte is 00h
	ld	bc,2B7h						; For 695 bytes...
	ldir							; 695 bytes of clearing!  (Because it will keep copying the byte prior to the byte after; thus 00h repeatedly)
	ld	a,80h
	ld	(zQueueToPlay),a			; Nothing is queued
	call	zFMSilenceAll			; Silence FM
	jp	zPSGSilenceAll				; Silence PSG
; End of function zClearTrackPlaybackMem


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_B78
zInitMusicPlayback:
	; This function saves some of the queue/flag items and
	; otherwise resets all music-related playback memory and
	; silences the hardware.  Used prior to playing a new song.
	; Very similar to zClearTrackPlaybackMem except that it is
	; specific to the music tracks...

	; Save some queues/flags:
	ld	ix,zComRange
	ld	b,(ix+0)
	ld	c,(ix+11h)		; 1-up playing flag
	push	bc
	ld	b,(ix+14h)		; speed shoe tempo
	ld	c,(ix+10h)		; fade in frames
	push	bc
	ld	b,(ix+9)		; SFX queue slot
	ld	c,(ix+0Ah)		; Stereo SFX queue slot
	push	bc
	; The following clears all playback memory and non-SFX tracks
	ld	hl,zComRange
	ld	de,zComRange+1
	ld	(hl),0
	ld	bc,z1upBackupSz-1			; this many bytes (from start of zComRange to just short of end of PSG3 music track)
	ldir
	; Restore those queue/flags:
	pop	bc
	ld	(ix+9),b		; SFX queue slot
	ld	(ix+0Ah),c		; Stereo SFX queue slot
	pop	bc
	ld	(ix+14h),b		; speed shoe tempo
	ld	(ix+10h),c		; fade in frames
	pop	bc
	ld	(ix+0),b
	ld	(ix+11h),c		; 1-up playing flag
	ld	a,80h
	ld	(zQueueToPlay),a
	; Silence hardware!
	call	zFMSilenceAll
	jp	zPSGSilenceAll
; End of function zInitMusicPlayback

; ---------------------------------------------------------------------------
; zloc_BBE:
; increases the tempo of the music
zSpeedUpMusic:
	ld	b,80h
	ld	a,(zComRange+11h)
	or	a
	ld	a,(zTempoTurbo)
	jr	z,zSetTempo
	jr	zloc_BE0

; ===========================================================================
; zloc_BCB:
; returns the music tempo to normal
zSlowDownMusic:
	ld	b,0
	ld	a,(zComRange+11h)
	or	a
	ld	a,(zComRange+12h)
	jr	z,zSetTempo
	jr	zloc_BE0

; ===========================================================================
; helper routines for changing the tempo
zSetTempo:
	ld	(zCurrentTempo),a		; Store new tempo value 
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


;zsub_BE8
zUpdateFadeIn:
	ld	a,(zComRange+0Fh)			; Get current tick count before next volume increase
	or	a
	jr	z,+							; If not yet zero...
	dec	(ix+0Fh)					; Just decrement it
	ret
+
	ld	a,(zComRange+10h)			; Get current fade out frame count
	or	a
	jr	nz,+						; If fadeout hasn't reached zero yet, skip this
	ld	a,(zTracksStart)			; Get DAC's playback control byte
	and	0FBh						; Clear "SFX is overriding" bit
	ld	(zTracksStart),a			; Set that
	xor	a
	ld	(zComRange+0Eh),a			; Done fading-in, SFX can play now 
	ret
+
	dec	(ix+10h)					; Otherwise, we decrement fadein!
	ld	(ix+0Fh),2					; Otherwise, reload tick count with 2 (little faster than fadeout)
	push	ix
	ld	ix,zTracksStart+zTrackSz*1	; 'ix' points to first FM music track
	ld	b,6							; 6 FM tracks to follow...

-	bit	7,(ix+0)					; Is this track playing?
	jr	z,+							; If not, do nothing
	dec	(ix+6)						; decrement channel volume (remember -- lower is louder!)
	push	bc
	call	zSetChanVol				; need to update volume
	pop	bc
+
	ld	de,zTrackSz
	add	ix,de						; Next track
	djnz	-						; Keep going for all FM tracks...

	ld	b,3							; 3 PSG tracks to follow...

-	bit	7,(ix+0)					; Is this track playing?
	jr	z,+							; If not, do nothing
	dec	(ix+6)						; decrement channel volume (remember -- lower is louder!)
	push	bc
	ld	b,(ix+6)					; Channel volume -> 'b'
	call	zPSGUpdateVol			; Update volume
	pop	bc
+
	ld	de,zTrackSz
	add	ix,de						; Next track
	djnz	-						; Keep going for all PSG tracks...

	pop	ix
	ret
; End of function zUpdateFadeIn


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_C46
zFMNoteOn:
	ld	a,(ix+0)		; Get playback control byte
	and	6
	ret	nz				; If either bit 1 ("track in rest") and 2 ("SFX overriding this track"), quit!
	ld	a,(ix+1)		; Get "voice control" byte
	or	0F0h			; Turn on ALL operators
	ld	c,a				; Set as data to write to FM
	ld	a,28h			; Write to KEY ON/OFF port (key ON in this case)
	rst	zWriteFMI		; do it!
	ret
; End of function zFMNoteOn


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_C56
zFMNoteOff:
	ld	a,(ix+0)		; Load this track's playback control byte
	and	14h				; Are bits 4 (0x10) or 2 (0x4) set?
	ret	nz				; If they are, return
	ld	a,28h			; Otherwise, send a KEY ON/OFF
	ld	c,(ix+1)		; Track's data for this key operation
	
	; Format of key on/off:
	; 4321 .ccc
	; Where 4321 are the bits for which operator,
	; and ccc is which channel (0-2 for channels 1-3, 4-6 for channels 4-6 WATCH BIT GAP)
	
	rst	zWriteFMI		; Write to part I (Note this particular register is ALWAYS sent to part I)
	ret
; End of function zFMNoteOff


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

;zloc_C89
zCoordFlag:
	sub	0E0h
	add	a,a
	add	a,a
	ld	(coordflagLookup+1),a ; store into the instruction after coordflagLookup (self-modifying code)
	ld	a,(hl)
	inc	hl

; This is the lookup for Coordination flag routines

	ensure1byteoffset 67h
;zloc_C92
coordflagLookup:
	jr	$
; ---------------------------------------------------------------------------
	jp	cfPanningAMSFMS ; E0
	nop
; ---------------------------------------------------------------------------
	jp	cfAlterNotesUNK ; E1
	nop
; ---------------------------------------------------------------------------
	jp	cfUnknown1 ; E2
	nop
; ---------------------------------------------------------------------------
	jp	cfJumpReturn ; E3
	nop
; ---------------------------------------------------------------------------
	jp	cfFadeInToPrevious ; E4
	nop
; ---------------------------------------------------------------------------
	jp	cfSetTempoDivider ; E5
	nop
; ---------------------------------------------------------------------------
	jp	cfSetVolume ; E6
	nop
; ---------------------------------------------------------------------------
	jp	cfPreventAttack ; E7
	nop
; ---------------------------------------------------------------------------
	jp	cfNoteFill ; E8
	nop
; ---------------------------------------------------------------------------
	jp	cfAddKey ; E9
	nop
; ---------------------------------------------------------------------------
	jp	cfSetTempo ; EA
	nop
; ---------------------------------------------------------------------------
	jp	cfSetTempoMod ; EB
	nop
; ---------------------------------------------------------------------------
	jp	cfChangeVolume ; EC
	nop
; ---------------------------------------------------------------------------
	jp	cfUnused ; empty and unused
	nop
; ---------------------------------------------------------------------------
	jp	cfVoiceUNK ; EE
	nop
; ---------------------------------------------------------------------------
	jp	cfSetVoice ; EF
	nop
; ---------------------------------------------------------------------------
	jp	cfModulation ; F0
	nop
; ---------------------------------------------------------------------------
	jp	cfEnableModulation ; F1
	nop
; ---------------------------------------------------------------------------
	jp	cfStopTrack ; F2
	nop
; ---------------------------------------------------------------------------
	jp	cfSetPSGNoise ; F3
	nop
; ---------------------------------------------------------------------------
	jp	cfDisableModulation ; F4
	nop
; ---------------------------------------------------------------------------
	jp	cfSetPSGTone ; F5
	nop
; ---------------------------------------------------------------------------
	jp	cfJumpTo ; F6
	nop
; ---------------------------------------------------------------------------
	jp	cfRepeatAtPos ; F7
	nop
; ---------------------------------------------------------------------------
	jp	cfJumpToGosub ; F8
	nop
; ---------------------------------------------------------------------------
	jp	cfOpF9 ; F9
	nop
; ---------------------------------------------------------------------------

; (via Saxman's doc): panning, AMS, FMS  
;zloc_CFC
cfPanningAMSFMS:
	;Panning, AMS, FMS
    ;* xx - Value (reg a)
    ;      o Bit 7 - Left channel status
    ;      o Bit 6 - Right channel Status
    ;      o Bit 5-3 - AMS
    ;      o Bit 2 - 0
    ;      o Bit 1-0 - FMS 

	; Subject to verification, but even though you COULD set
	; AMS/FMS values, it does not appear that's what they intended
	; here; instead it appears they only meant for panning control.
	; I say this because it retains prior AMS/FMS settings ("and 37h")
		
	bit	7,(ix+1)		; a PSG track
	ret	m				; If so, quit!
	bit	2,(ix+0)		; If "do not attack next note" bit set...
	ret	nz				; return
	ld	c,a				; input val 'a' -> c
	ld	a,(ix+7)		; old PAF value
	and	37h				; retains bits 0-2, 3-4?
	or	c				; OR'd with new settings
	ld	(ix+7),a		; new PAF value
	ld	c,a				; a -> c (YM2612 data write)
	ld	a,(ix+1)		; Get voice control byte
	and	3				; Channels only!
	add	a,0B4h			; Add register B4, stereo output control and LFO sensitivity 
	rst	zWriteFMIorII	; depends on bit 2 of (ix+1)
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): Alter note values by xx 
; More or less a pitch bend; this is applied to the frequency as a signed value
;zloc_D1A
cfAlterNotesUNK:
	ld	(ix+19h),a		; set new frequency adjust
	ret
; ---------------------------------------------------------------------------

; Fade-in on Sonic 3, but here ... I dunno?  Maybe dead code?
;zloc_D1E
cfUnknown1:
	ld	(zComRange+6),a
	ret
; ---------------------------------------------------------------------------

; Return (Sonic 1 & 2)
;zloc_D22
cfJumpReturn:
	ld	c,(ix+0Ah)		; Get current stack offset -> 'c'
	ld	b,0				; b = 0
	push	ix
	pop	hl				; hl = ix
	add	hl,bc			; hl += bc (latest item on "gosub" stack)
	ld	a,(hl)			
	inc	hl
	ld	h,(hl)
	ld	l,a				; hl = address from "gosub" stack
	inc	c
	inc	c
	ld	(ix+0Ah),c		; add 2 to "gosub" stack offset (pop)
	ret
; ---------------------------------------------------------------------------

; Fade-in to previous song (needed on DAC channel, Sonic 1 & 2)
;zloc_D35
cfFadeInToPrevious:
	; This performs a "massive" restoration of all of the current 
	; track positions as they were prior to 1-up BGM
	ld	hl,z1upBackup		; Backup memory address
	ld	de,zComRange		; Ends at zComRange
	ld	bc,z1upBackupSz		; for this many bytes
	ldir					; Go!
	
	call	zBankSwitchToMusic
	ld	a,(zTracksStart)	; Get DAC's playback bit
	or	4
	ld	(zTracksStart),a	; Set "SFX is overriding" on it (not normal, but will work for this purpose)
	ld	a,(zComRange+10h)	; Get current count of many frames to continue bringing volume up
	ld	c,a					; 
	ld	a,28h				; 
	sub	c					; a = 28h - c (don't overlap fade-ins?)
	ld	c,a					; 'a' -> 'c'
	ld	b,6							; 6 FM tracks to follow...
	ld	ix,zTracksStart+zTrackSz*1	; 'ix' points to first FM music track

-	bit	7,(ix+0)			; Is this track playing?
	jr	z,+					; If not, do nothing
	set	1,(ix+0)			; Mark track at rest
	ld	a,(ix+6)			; Get channel volume
	add	a,c					; Apply current fade value
	ld	(ix+6),a			; Store it back
	bit	2,(ix+0)			; Is track being overridden by SFX?
	jr	nz,+				; If so, skip next part
	push	bc
	ld	a,(ix+8)			; Get voice
	call	zSetVoiceMusic	; Update voice (and set volume)
	pop	bc
+
	ld	de,zTrackSz
	add	ix,de				; Next track
	djnz	-				; Keep going for all FM tracks...

	ld	b,3					; 3 PSG tracks to follow...

-	bit	7,(ix+0)			; Is this track playing?
	jr	z,+					; If not, do nothing
	set	1,(ix+0)			; Set track at rest
	call	zPSGNoteOff		; Shut off PSG
	ld	a,(ix+6)			; Get channel volume
	add	a,c					; Apply current fade value
	ld	(ix+6),a			; Store it back
+
	ld	de,zTrackSz
	add	ix,de				; Next track
	djnz	-				; Keep going for all FM tracks...

	ld	a,80h
	ld	(zComRange+0Eh),a	; Stop any SFX during fade-in
	ld	a,28h
	ld	(zComRange+10h),a	; Fade in for 28h frames
	xor	a
	ld	(zComRange+11h),a	; Set to zero; 1-up ain't playin' no more
	ld	a,(zComRange+15h)	; DAC not yet enabled...
	ld	c,a
	ld	a,2Bh
	rst	zWriteFMI			; Tell hardware his DAC ain't enabled yet either
	pop	bc
	pop	bc
	pop	bc					; These screw with the return address to make sure DAC doesn't run any further
	jp	zUpdateDAC			; But we update DAC regardless
; ---------------------------------------------------------------------------

; Change tempo divider to xx
;zloc_DB7
cfSetTempoDivider:
	ld	(ix+2),a		; Set tempo divider on this track only
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): Change channel volume BY xx; xx is signed 
;zloc_DBB
cfSetVolume:
	add	a,(ix+6)		; Add to current volume
	ld	(ix+6),a		; Update volume
	jp	zSetChanVol		; Immediately set this new volume
; ---------------------------------------------------------------------------

; (via Saxman's doc): prevent next note from attacking 
;zloc_DC4
cfPreventAttack:
	set	4,(ix+0)		; Set bit 4 (10h) on playback control; do not attack next note
	dec	hl				; Takes no arguement, so just put it back
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): set note fill amount to xx 
;zloc_DCA
cfNoteFill:
	ld	(ix+0Fh),a		; Note fill value (modifiable)
	ld	(ix+10h),a		; Note fill value (master copy, rewrites +0Fh when necessary)
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): add xx to channel key 
;zloc_DD1
cfAddKey:
	add	a,(ix+5)	; Add to current transpose value
	ld	(ix+5),a	; Store updated transpose value
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): set music tempo to xx 
;zloc_DD8
cfSetTempo:
	ld	(zComRange+2),a		; Set tempo
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): Change Tempo Modifier to xx for ALL channels 
;zloc_DDC
cfSetTempoMod:
	push	ix			; Save 'ix'
	ld	ix,zTracksStart	; Start at beginning of track memory
	ld	de,zTrackSz		; Track size
	ld	b,0Ah			; All 10 tracks

-	ld	(ix+2),a		; Sets the timing divisor for ALL tracks; this can result in total half-speed, quarter-speed, etc.
	add	ix,de
	djnz	-

	pop	ix				; Restore 'ix'
	ret
; ---------------------------------------------------------------------------
; This controls which TL registers are set for a particular
; algorithm; it actually makes more sense to look at a zVolTLMaskTbl entry as a bitfield.
; Bit 0-4 set which TL operators are actually effected for setting a volume;
; this table helps implement the following from the Sega Tech reference:
; "To make a note softer, only change the TL of the slots (the output operators).  
; Changing the other operators will affect the flavor of the note."
; zloc_DF1:
	ensure1byteoffset 8
zVolTLMaskTbl:
	db	  8,  8,  8,  8
	db	0Ch,0Eh,0Eh,0Fh
; ---------------------------------------------------------------------------

; (via Saxman's doc): Change channel volume TO xx; xx is signed (Incorrect, see below)
; However, I've noticed this is incorrect; first of all, you'll notice
; it's still doing an addition, not a forced set.  Furthermore, it's
; not actually altering the FM yet; basically, until the next voice
; switch, this volume change will not come into effect.  Maybe a better
; description of it is "change volume by xx when voice changes", which
; makes sense given some voices are quieter/louder than others, and a
; volume change at voice may be necessary... or my guess anyway.

; Alternatively, just think of it as a volume setting optimized for PSG :P
;zloc_DF9
cfChangeVolume:
	add	a,(ix+6)	; Add to channel volume
	ld	(ix+6),a	; Store updated volume
	ret
; ---------------------------------------------------------------------------

; Unused command EDh
;zlocret_E00
cfUnused:
	; Dangerous!  It doesn't put back the byte read, meaning one gets skipped!
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): "Something with Voice Selection" 
; But actually, this doesn't do anything but put back the next byte read, so...
;zloc_E01
cfVoiceUNK:
	dec	hl		; Put back byte; does nothing
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): set voice selection to xx 
;zloc_E03
cfSetVoice:
	ld	(ix+8),a			; Set current voice
	ld	c,a					; a -> c (saving for later, if we go to cfSetVoiceCont)
	bit	2,(ix+0)			; If "SFX is overriding this track" bit set...
	ret	nz					; .. return!
	push	hl				; Save 'hl'
	call	cfSetVoiceCont	; Set the new voice!
	pop	hl					; Restore 'hl'
	ret

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_E12
cfSetVoiceCont:
	ld	a,(zDoSFXFlag)		; Check SFX flag 0 = updating music, 80h means busy (don't supply me a sound, plz), FFh set means updating SFX (use custom voice table)
	or	a					; test
	ld	a,c					; c -> a (restored 'a')
	jr	z,zSetVoiceMusic	; If not busy, jump to zSetVoiceMusic (set 'hl' to zVoiceTblPtr)
	ld	l,(ix+1Ch)			; get low byte of custom voice table
	ld	h,(ix+1Dh)			; get high byte of custom voice table
	jr	zSetVoice			; Do not set 'hl' to zVoiceTblPtr
; End of function cfSetVoiceCont


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_E21
zSetVoiceMusic:
	; Set 'hl' to normal voice table pointer
	ld	hl,(zVoiceTblPtr)

;zloc_E24
zSetVoice:
	; This does the actual setting of the FM registers for the specific voice
	; 'a' is the voice index to set
	; 'hl' is set to the address of the voice table pointer (can be substituted, probably mainly for SFX)

	push	hl				; push 'hl' for the end of the following block...
	
	; The following is a crazy block designed to 'multiply' our target voice value by 25...
	; Where a single voice is 25 bytes long
	ld	c,a					; a -> c
	ld	b,0					; b = 0 (so only low byte of 'bc' is set, basically voice to set)
	add	a,a					; a *= 2 (indexing something...)
	ld	l,a					; low byte of 'hl' set to 'a'
	ld	h,b					; high byte = 0
	add	hl,hl				; hl *= 2
	add	hl,hl				; hl *= 2 (total hl * 4!!)
	ld	e,l	
	ld	d,h					; de = hl
	add	hl,hl				; hl *= 2
	add	hl,de				; hl += de
	add	hl,bc				; hl += bc (waaah!)
	pop	de					; old 'hl' value -> 'de'
	add	hl,de				; hl += de (Adds address from the very beginning)
	; End crazy multiply-by-25 block
	
	; Sets up a value for future Total Level setting...
	ld	a,(hl)				; Get feedback/algorithm -> a
	inc	hl					; next byte of voice...
	ld	(zloc_E65+1),a		; self-modifying code; basically enables 'a' restored to its current value later
	ld	c,a					; a -> c (will be data to YM2612)
	ld	a,(ix+1)			; Get "voice control" byte
	and	3					; only keep bits 0-2 (bit 2 specifies which chip to write to)
	add	a,0B0h				; add to get appropriate feedback/algorithm register
	rst	zWriteFMIorII		; Write new value to appropriate part

	; detune/coarse freq, all channels
	sub	80h					; Subtract 80h from 'a' (Detune/coarse frequency of operator 1 register)
	ld	b,4					; Do next 4 bytes (operator 1, 2, 3, and 4)

-	ld	c,(hl)				; Get next detune/coarse freq
	inc	hl					; next voice byte
	rst	zWriteFMIorII		; Write this detune/coarse freq
	add	a,4					; Next detune/coarse freq register
	djnz	-

	push	af				; saving 'a' for much later... will be restored when time to "Total Level"
	
	; other regs up to just before "Total Level", all channels
	add	a,10h				; we're at 40h+, now at 50h+ (RS/AR of operator 1 register)
	ld	b,10h				; Perform 16 writes (basically goes through RS/AR, AM/D1R, D2R, D1L)

-	ld	c,(hl)				; Get next reg data value
	inc	hl					; next voice byte
	rst	zWriteFMIorII		; Write to FM
	add	a,4					; Next register
	djnz	-

	; Now going to set "stereo output control and LFO sensitivity"
	add	a,24h				; Sets to reg B4h+ (stereo output control and LFO sensitivity)
	ld	c,(ix+7)			; Panning / AMS / FMS settings from track
	rst	zWriteFMIorII		; Write it!
	ld	(ix+1Eh),l			; Save current position (TL bytes begin) 
	ld	(ix+1Fh),h			;	... for updating volume correctly later later

zloc_E65:
	ld	a,0 ; "self-modified code" -- 'a' will actually be set to the feedback/algorithm byte
	and	7					; Only keeping the "algorithm" part of it
	add	a,zVolTLMaskTbl&0FFh		; Adds offset to zVolTLMaskTbl table (low byte only)
	ld	e,a					; Puts this low byte into 'e'
	ld	d,(zVolTLMaskTbl&0FF00h)>>8	; Get high byte -> 'd'
	ld	a,(de)				; Get this zVolTLMaskTbl value by algorithm
	ld	(ix+1Ah),a			; Store this zVolTLMaskTbl value into (ix+1Ah)
	ld	e,a					; Store zVolTLMaskTbl value -> 'e'
	ld	d,(ix+6)			; Store channel volume -> 'd'
	pop	af					; Restore 'a'; it's now back at appropriate 40h+ register for Total Level setting!

	; Set "Total Levels" (general volume control)
zSetFMTLs:
	ld	b,4					; Loop 4 times (for each Total Level register on this channel)

-	ld	c,(hl)				; Get next TL byte -> c
	inc	hl					; Next voice byte...
	rr	e					; zVolTLMaskTbl value is rotated right; if the bit 0 of this value prior to the rotate was reset (0)...
	jr	nc,+				; ... then we make the jump here (just write the TL value directly, don't modify it)
	
	; Otherwise, apply channel volume to TL here
	; It's not appropriate to alter ALL TL values, only
	; the ones which are "slots" (output operators)
	push	af				; Save 'a'
	ld	a,d					; Channel volume -> d
	add	a,c					; Add it to the TL value
	ld	c,a					; Modified value -> c
	pop	af					; Restore 'a'
+
	rst	zWriteFMIorII		; Write TL value
	add	a,4					; Next TL reg...
	djnz	-

	ret
; End of function zSetVoiceMusic


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


;zsub_E8A
zSetChanVol:
	bit	7,(ix+1)		; a PSG track
	ret	nz				; If so, quit!
	bit	2,(ix+0)		; If playback control byte "SFX is overriding this track" bit set...
	ret	nz				; ... then quit!
	ld	e,(ix+1Ah)		; zVolTLMaskTbl value from last voice setting (marks which specific TL operators need updating)
	ld	a,(ix+1)		; Load current voice control byte
	and	3				; Keep only bits 0-2
	add	a,40h			; Add 40h -- appropriate TL register
	ld	d,(ix+6)		; Get channel volume
	bit	7,d				; If bit 7 (80h) is set...
	ret	nz				; ... then quit!
	push	hl			; Save 'hl'
	ld	l,(ix+1Eh)		; low byte of where TL bytes begin (set during last voice setting)
	ld	h,(ix+1Fh)		; high byte of where TL bytes begin (set during last voice setting)
	call	zSetFMTLs	; Set the appropriate Total Levels
	pop	hl				; Restore 'hl'
	ret
; End of function zSetChanVol

; ---------------------------------------------------------------------------

; (via Saxman's doc): F0wwxxyyzz - modulation 
;							o	ww - Wait for ww period of time before modulation starts 
;							o	xx - Modulation Speed 
;							o	yy - Modulation change per Mod. Step 
;							o	zz - Number of steps in modulation 
;zloc_EB0
cfModulation:
	set	3,(ix+0)		; Set bit 3 (08h) of "playback control" byte (modulation on)
	dec	hl				; Move 'hl' back one...
	ld	(ix+11h),l		; Back up modulation setting address into (ix+11h), (ix+12h)
	ld	(ix+12h),h

;zloc_EBB
zSetModulation:
	; Sets up modulation for this track; expects 'hl' to point to modulation
	; configuration info...
	
	; Heh, using some undoc instructions here...
	ld	a,ixl			; Get lower byte of current track address (ew :P)
	add	a,13h			; ... and add 19 bytes to it
	ld	e,a				; put that into 'e'
	adc	a,ixu			; If carry occured, add that to upper part of address
	sub	e				; subtract 'e'
	ld	d,a				; Basically, 'd' is now the appropriate upper byte of the address, completing de = (ix + 19)
						; Copying next three bytes 
	ldi					; *(de)++ = *(hl)++		(Wait for ww period of time before modulation starts)
	ldi					; *(de)++ = *(hl)++		(Modulation Speed)
	ldi					; *(de)++ = *(hl)++		(Modulation change per Mod. Step)
	ld	a,(hl)			; Get Number of steps in modulation 
	inc	hl				; Next byte...
	srl	a				; divide number of steps by 2
	ld	(ix+16h),a		; Store this step count into trackPtr+16h
	bit	4,(ix+0)		; Is bit 4 "do not attack next note" (10h) set? 
	ret	nz				; If so, quit!
	xor	a				; Clear 'a'
	ld	(ix+17h),a		; Clear modulation value low byte
	ld	(ix+18h),a		; Clear modulation value high byte
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): Turn on modulation 
;zloc_EDE
cfEnableModulation:
	dec	hl
	set	3,(ix+0)		; Playback byte bit 3 (08h) -- modulation on
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): stop the track 
;zloc_EE4
cfStopTrack:
	res	7,(ix+0)			; Clear playback byte bit 7 (80h) -- currently playing (not anymore)
	res	4,(ix+0)			; Clear playback byte bit 4 (10h) -- do not attack
	bit	7,(ix+1)			; Is voice control bit 7 (80h) a PSG track set?
	jr	nz,zStopPSGTrack	; If so, skip this next part...
	ld	a,(zDACUpdating)	; Is DAC updating?  (FF if so)
	or	a					; test it
	jp	m,zDACStopTrack		; If DAC is updating, go here (we're in a DAC track)
	call	zFMNoteOff		; Otherwise, stop this FM track
	jr	+

;zcall_zsub_526
zStopPSGTrack:
	call	zPSGNoteOff
+
	; General stop track continues here...

	ld	a,(zDoSFXFlag)		; Check if we're an SFX track
	or	a					; test it
	jp	p,zStopMusicTrack	; If not, jump to zStopMusicTrack
	xor	a					; a = 0
	ld	(zComRange),a		; Reset SFX priority
	ld	a,(ix+1)			; Load "voice control" byte
	or	a					; test it..
	jp	m,zStopPSGSFXTrack	; If this is PSG SFX track, jump to zStopPSGSFXTrack
	push	ix				; save 'ix'
	; This is an FM SFX track that's trying to stop
	sub	2					; Take channel assignment - 2 (since SFX never use FM 1 or FM 2)
	add	a,a					; a *= 2 (each table entry is 2 bytes wide)
	add	a,zMusicTrackOffs&0FFh	; Get low byte value from zMusicTrackOffs
	ld	(zloc_F1D+2),a			; store into the instruction after zloc_F1D (self-modifying code)
zloc_F1D:
	ld	ix,(zMusicTrackOffs)	; self-modified code from just above; 'ix' points to cooresponding Music FM track
	bit	2,(ix+0)				; If "SFX is overriding this track" is not set...
	jp	z,+						; Skip this part (i.e. if SFX was not overriding this track, then nothing to restore)
	call	zBankSwitchToMusic	; Bank switch back to music track
	res	2,(ix+0)				; Clear SFX is overriding this track from playback control
	set	1,(ix+0)				; Set track as resting bit
	ld	a,(ix+8)				; Get voice this track was using
	call	zSetVoiceMusic		; And set it!  (takes care of volume too)

	bankswitch SoundIndex
+
	pop	ix						; restore 'ix'
	pop	bc						; removing return address from stack; will not return to coord flag loop
	pop	bc						; removing return address from stack; will not return to z*UpdateTrack function
	ret
; ---------------------------------------------------------------------------

zStopPSGSFXTrack:
	push	ix					; save 'ix'
	
	; Keep in mind that we just entered with a PSG "voice control" byte
	; which is one of the following values (PSG1-3/3N) -- 80h, A0h, C0h, E0h
	rra
	rra
	rra
	rra			; in effect, ">> 4"
	and	0Fh		; 'a' is now 08, 0A, 0C, or 0E
	add	a,zMusicTrackOffs&0FFh
	ld	(zloc_F5A+2),a	; store into the instruction after zloc_A5A (self-modifying code)
zloc_F5A:
	ld	ix,(zMusicTrackOffs) ; self-modified code from just above; 'ix' points to cooresponding Music PSG track
	res	2,(ix+0)	; Clear SFX is overriding this track from playback control
	set	1,(ix+0)	; Set track as resting bit
	ld	a,(ix+1)	; Get voice control byte
	cp	0E0h		; Is this a PSG 3 noise (not tone) track?
	jr	nz,+		; If it isn't, don't do next part (non-PSG Noise doesn't restore)
	ld	a,(ix+1Bh)	; Get PSG noise setting
	ld	(zPSG),a	; Write it to PSG
+
	pop	ix						; restore 'ix'

;zloc_F75
zStopMusicTrack:
	pop	bc						; removing return address from stack; will not return to coord flag loop

;zloc_F76
zDACStopTrack:
	pop	bc						; removing return address from stack; will not return to z*UpdateTrack function (anything othat than DAC) or not to coord flag loop (if DAC)
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): Change current PSG noise to xx (For noise channel, E0-E7) 
;zloc_F78
cfSetPSGNoise:
	ld	(ix+1),0E0h		; This is a PSG noise track now!
	ld	(ix+1Bh),a		; Save PSG noise setting for restoration if SFX override sit
	bit	2,(ix+0)		; If SFX is currently overriding it, don't actually set it!
	ret	nz
	ld	(zPSG),a		; Otherwise, please do
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): Turn off modulation 
;zloc_F88
cfDisableModulation:
	dec	hl				; No parameters used, must back up a byte
	res	3,(ix+0)		; Clear "modulation on" bit setting
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): Change current PSG tone to xx 
;zloc_F8E
cfSetPSGTone:
	ld	(ix+8),a		; Set current PSG tone
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): jump to position yyyy 
;zloc_F92
cfJumpTo:
	ld	h,(hl)			; Get hight byte of jump destination (since pointer advanced to it)
	ld	l,a				; Put low byte (already retrieved)
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): $F7xxyyzzzz - repeat section of music
;    * xx - loop index, for loops within loops without confusing the engine.
;          o EXAMPLE: Some notes, then a section that is looped twice, then some more notes, and finally the whole thing is looped three times.
;            The "inner" loop (the section that is looped twice) would have an xx of 01, looking something along the lines of F70102zzzz, whereas the "outside" loop (the whole thing loop) would have an xx of 00, looking something like F70003zzzz. 
;    * yy - number of times to repeat
;          o NOTE: This includes the initial encounter of the F7 flag, not number of times to repeat AFTER hitting the flag. 
;    * zzzz - position to loop back to   
;zloc_F95
cfRepeatAtPos:
					; Loop index is in 'a'
	ld	c,(hl)		; Get next byte (number of repeats) -> 'c'
	inc	hl			; Next byte...
	push	hl		; Save 'hl'
	add	a,20h		; Add to make loop index offset (starts at 20h in track memory)
	ld	l,a			; Set hl = offset index
	ld	h,0
	ld	e,ixl		; Set 'de' to beginning of track
	ld	d,ixu
	add	hl,de		; hl is now pointing to track memory offset for this loop
	ld	a,(hl)		; Get loop count at this address
	or	a			; Test it
	jr	nz,+		; If not zero, then skip next step (i.e. we're currently looping)
	ld	(hl),c		; Otherwise, set it to the new number of repeats
+
	dec	(hl)		; One less loop
	pop	hl			; Restore 'hl' (now at the position)
	jr	z,+			; If counted to zero, skip the rest of this (hence start loop count of 1 terminates the loop without ever looping)
	ld	a,(hl)		; Get low byte of jump address
	inc	hl			; Next byte
	ld	h,(hl)		; Get high byte of jump address -> 'h'
	ld	l,a			; Put low byte of jump address -> 'l'
	
	; Note then that this loop command only works AFTER the section you mean to loop
	
	ret
+
	; If you get here, the loop terminated; just bypass the loop jump address
	inc	hl
	inc	hl
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): jump to position yyyy (keep previous position in memory for returning) 
;zloc_FB3
cfJumpToGosub:
	ld	c,a			; a -> c
	ld	a,(ix+0Ah)	; Get current "stack" offset (starts at 2Ah, i.e. beginning of next track)
	sub	2			; Move back by two (we need to store a new return address)
	ld	(ix+0Ah),a	; Set current stack offset
	ld	b,(hl)		; Get high byte of jump position -> 'b'
	inc	hl			; Next byte...
	ex	de,hl		; hl <=> de
	add	a,ixl		; Add low byte of current track pointer to stack offset (low byte of stack location)
	ld	l,a			; Keep this in 'l'
	adc	a,ixu		; Update high byte, if necessary
	sub	l			; Fixup
	ld	h,a			; a -> 'h' (Simply, we just did hl = ix + stack_offset)
	ld	(hl),e		; Store current address low byte (just after jump) into stack
	inc	hl			; Next byte
	ld	(hl),d		; Store current address high byte (just after jump) into stack
	ld	h,b	
	ld	l,c			; hl = bc (current location is where you wanted to jump to)
	ret
; ---------------------------------------------------------------------------

; This is not listed as a valid Sonic 2 coord flag, and it just looks weird:
; (It might be dead code?)
;zloc_FCC
cfOpF9:
	ld	a,88h		; D1L/RR of Operator 3
	ld	c,0Fh		; Loaded with fixed value (max RR, 1TL?)
	rst	zWriteFMI	; Written to part I
	ld	a,8Ch		; D1L/RR of Operator 4
	ld	c,0Fh		; Loaded with fixed value (max RR, 1TL?)
	rst	zWriteFMI	; Written to part I
	dec	hl			; Doesn't take an arg, so put back one byte
	ret

; ---------------------------------------------------------------------------
;zbyte_FD8h
zSFXPriority:
	db	80h,70h,70h,70h,70h,70h,70h,70h,70h,70h,68h,70h,70h,70h,60h,70h
	db	70h,60h,70h,60h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,7Fh
	db	6Fh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,6Fh,70h,70h
	db	70h,60h,60h,70h,70h,70h,70h,70h,70h,70h,60h,62h,60h,60h,60h,70h
	db	70h,70h,70h,70h,60h,60h,60h,6Fh,70h,70h,6Fh,6Fh,70h,71h,70h,70h
	db	6Fh

; zoff_1029:
;zPSG_Index
zPSG_FlutterTbl:
	; Basically, for any tone 0-11, dynamic volume adjustments are applied to produce a pseudo-decay,
	; or sometimes a ramp up for "soft" sounds, or really any other volume effect you might want!
	
	; Remember on PSG that the higher the value, the quieter it gets (it's attenuation, not volume); 
	; 0 is thus loudest, and increasing values decay, until level $F (silent)

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

;	END of zPSG_FlutterTbl ---------------------------

; zbyte_11F5h:
zMasterPlaylist:

; Music IDs
offset :=	MusicPoint2
ptrsize :=	2
idstart :=	80h
; note: +20h means uncompressed, here
; +40h is an (ignored) flag, possibly to force PAL mode on/off

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

; Tempo with speed shoe tempo for each song
;zbyte_1214
zSpedUpTempoTable:
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

;zDACPtr_Index:
;zbyte_1233:
zDACPtrTbl:
zDACPtr_Sample1:	dw	zmake68kPtr(SndDAC_Sample1)
;zbyte_1235
zDACLenTbl:
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
	; First byte selects one of the DAC samples.  The number that 
	; follows it is a wait time between each nibble written to the DAC 
	; (thus higher = slower)
	ensure1byteoffset 22h
; zbyte_124F:
zDACMasterPlaylist:

; DAC samples IDs
offset :=	zDACPtrTbl
ptrsize :=	2+2
idstart :=	81h

	db	id(zDACPtr_Sample1),17h		; 81h
	db	id(zDACPtr_Sample2),1		; 82h
	db	id(zDACPtr_Sample3),6		; 83h
	db	id(zDACPtr_Sample4),8		; 84h
	db	id(zDACPtr_Sample5),1Bh		; 85h
	db	id(zDACPtr_Sample6),0Ah		; 86h
	db	id(zDACPtr_Sample7),1Bh		; 87h
	db	id(zDACPtr_Sample5),12h		; 88h
	db	id(zDACPtr_Sample5),15h		; 89h
	db	id(zDACPtr_Sample5),1Ch		; 8Ah
	db	id(zDACPtr_Sample5),1Dh		; 8Bh
	db	id(zDACPtr_Sample6),2		; 8Ch
	db	id(zDACPtr_Sample6),5		; 8Dh
	db	id(zDACPtr_Sample6),8		; 8Eh
	db	id(zDACPtr_Sample7),8		; 8Fh
	db	id(zDACPtr_Sample7),0Bh		; 90h
	db	id(zDACPtr_Sample7),12h		; 91h

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

;zsub_1271
zSaxmanDec:
	exx
	ld	bc,0
	ld	de,0
	exx
	ld	de,zMusicData
	ld	c,(hl)
	inc	hl
	ld	b,(hl)					; bc = (hl) i.e. "size of song"
	inc	hl
	ld	(zGetNextByte+1),hl		; modify inst. @ zGetNextByte -- set to beginning of decompression stream
	inc	bc
	ld	(zDecEndOrGetByte+1),bc ; modify inst. @ zDecEndOrGetByte -- set to length of song, +1

;zloc_1288
zSaxmanReadLoop:
	
	exx							; shadow reg set
	srl	c						; c >> 1 (active control byte)
	srl	b						; b >> 1 (just a mask that lets us know when we need to reload)
	bit	0,b						; test next bit of 'b'
	jr	nz,+					; if it's set, we still have bits left in 'c'; jump to '+'
	; If you get here, we're out of bits in 'c'!
	call	zDecEndOrGetByte	; get next byte -> 'a'
	ld	c,a						; a -> 'c'
	ld	b,0FFh					; b = FFh (8 new bits in 'c')
+
	bit	0,c						; test next bit of 'c'
	exx							; normal reg set
	jr	z,+						; if bit not set, it's a compression bit; jump to '+'
	; If you get here, there's a non-compressed byte
	call	zDecEndOrGetByte	; get next byte -> 'a'	
	ld	(de),a					; store it directly to the target memory address
	inc	de						; de++
	exx							; shadow reg set
	inc	de						; Also increase shadow-side 'de'... relative pointer only, does not point to output Z80_RAM
	exx							; normal reg set
	jr	zSaxmanReadLoop			; loop back around...
+
	call	zDecEndOrGetByte	; get next byte -> 'a'
	ld	c,a						; a -> 'c' (low byte of target address)
	call	zDecEndOrGetByte	; get next byte -> 'a'
	ld	b,a						; a -> 'b' (high byte of target address + count)
	and	0Fh						; keep only lower four bits...
	add	a,3						; add 3 (minimum 3 bytes are to be read in this mode)
	push	af					; save 'a'...
	ld	a,b						; b -> 'a' (low byte of target address)
	rlca
	rlca
	rlca
	rlca
	and	0Fh						; basically (b >> 4) & 0xF (upper four bits now exclusively as lower four bits)
	ld	b,a						; a -> 'b' (only upper four bits of value make up part of the address)
	ld	a,c	
	add	a,12h
	ld	c,a
	adc	a,b
	sub	c
	and	0Fh
	ld	b,a						; bc += 12h
	pop	af						; restore 'a' (byte count to read; no less than 3)
	exx							; shadow reg set
	push	de					; keep current 'de' (relative pointer) value...
	ld	l,a						; how many bytes we will read -> 'hl'
	ld	h,0
	add	hl,de					; add current relative pointer...
	ex	de,hl					; effectively, de += a
	exx							; normal reg set
	pop	hl						; shadow 'de' -> 'hl' (relative pointer, prior to all bytes read, relative)
	or	a
	sbc	hl,bc					; hl -= bc ?
	jr	nc,+					; if result positive, jump to '+'
	ex	de,hl					; current output pointer -> 'hl'
	ld	b,a						; how many bytes to load -> 'b'

-	ld	(hl),0					; fill in zeroes that many times
	inc	hl
	djnz	-

	ex	de,hl					; output pointer updated
	jr	zSaxmanReadLoop			; loop back around...
+
	ld	hl,zMusicData			; point at beginning of decompression point
	add	hl,bc					; move ahead however many bytes
	ld	c,a
	ld	b,0
	ldir
	jr	zSaxmanReadLoop
; End of function zSaxmanDec


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


	; This is an ugly countdown to zero implemented in repeatedly modifying code!!
	; But basically, it starts at the full length of the song +1 (so it can decrement)
	; and waits until 'hl' decrements to zero
;zsub_12E8
zDecEndOrGetByte:
	ld	hl,0					; "self-modified code" -- starts at full length of song +1, waits until it gets to 1...
	dec	hl						; ... where this will be zero
	ld	(zDecEndOrGetByte+1),hl	; "self-modifying code" -- update the count in case it's not zero
	ld	a,h	
	or	l
	jr	z,+						; If 'h' and 'l' both equal zero, we quit!!
;zloc_12F3
zGetNextByte:
	ld	hl,0				; "self-modified code" -- get address of next compressed byte
	ld	a,(hl)				; put it into -> 'a'
	inc	hl					; next byte...
	ld	(zGetNextByte+1),hl	; change inst @ zGetNextByte so it loads next compressed byte
	ret						; still going...
+
	pop	hl					; throws away return address to this function call so that next 'ret' exits decompressor (we're done!)
	ret						; Exit decompressor
; End of function zDecEndOrGetByte

; ---------------------------------------------------------------------------
	; space for a few global variables

zPALUpdTick:	db 0 ; zbyte_12FE ; This counts from 0 to 5 to periodically "double update" for PAL systems (basically every 6 frames you need to update twice to keep up)
zCurDAC:	db 0 ; zbyte_12FF ; seems to indicate DAC sample playing status
zCurSong:	db 0 ; zbyte_1300 ; currently playing song index
zDoSFXFlag:	db 0 ; zbyte_1301;	Flag to indicate we're updating SFX (and thus use custom voice table); set to FFh while doing SFX, 0 when not.
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
