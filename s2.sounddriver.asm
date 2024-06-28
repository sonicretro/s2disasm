; Sonic the Hedgehog 2 disassembled Z80 sound driver

; Disassembled by Xenowhirl for AS
; Additional disassembly work by RAS Oct 2008
; RAS' work merged into SVN by Flamewing
; ---------------------------------------------------------------------------

FixDriverBugs = fixBugs
OptimiseDriver = 0

; ---------------------------------------------------------------------------
; NOTES:
;
; Set your editor's tab width to 8 characters wide for viewing this file.
;
; This code is compressed in the ROM, but you can edit it here as uncompressed
; and it will automatically be assembled and compressed into the correct place
; during the build process.
;
; This Z80 code can use labels and equates defined in the 68k code,
; and the 68k code can use the labels and equates defined in here.
; This is fortunate, as they contain references to each other's addresses.
;
; If you want to add significant amounts of extra code to this driver,
; try putting your code as far down as possible, after the function zDecEnd.
; That will make you less likely to run into space shortages from dislocated data alignment.
;
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Setup defines and macros

	; zComRange:	@ 1B80h
	; 	+00h	-- Priority of current SFX (cleared when 1-up song is playing)
	; 	+01h	-- tempo clock
	; 	+02h	-- current tempo
	; 	+03h	-- Pause/unpause flag: 7Fh for pause; 80h for unpause (set from 68K)
	; 	+04h	-- total volume levels to continue decreasing volume before fade out considered complete (starts at 28h, works downward)
	; 	+05h	-- delay ticker before next volume decrease
	; 	+06h	-- communication value
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
	; 	+14h	-- Speed shoes flag
	; 	+15h	-- If 80h, FM Channel 6 is NOT in use (DAC enabled)
	; 	+16h	-- value of which music bank to use (0 for MusicPoint1, $80 for MusicPoint2)
	; 	+17h	-- Pal mode flag
	;
	; ** zTracksSongStart starts @ +18h
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
zTrack STRUCT DOTS
	; 	"playback control"; bits:
	; 	1 (02h): track is at rest
	; 	2 (04h): SFX is overriding this track
	; 	3 (08h): modulation on
	; 	4 (10h): do not attack next note
	; 	7 (80h): track is playing
	PlaybackControl:	ds.b 1
	; 	"voice control"; bits:
	; 	2 (04h): If set, bound for part II, otherwise 0 (see zWriteFMIorII)
	; 		-- bit 2 has to do with sending key on/off, which uses this differentiation bit directly
	; 	7 (80h): PSG track
	VoiceControl:		ds.b 1
	TempoDivider:		ds.b 1	; Timing divisor; 1 = Normal, 2 = Half, 3 = Third...
	DataPointerLow:		ds.b 1	; Track's position low byte
	DataPointerHigh:	ds.b 1	; Track's position high byte
	Transpose:		ds.b 1	; Transpose (from coord flag E9)
	Volume:			ds.b 1	; Channel volume (only applied at voice changes)
	AMSFMSPan:		ds.b 1	; Panning / AMS / FMS settings
	VoiceIndex:		ds.b 1	; Current voice in use OR current PSG tone
	VolFlutter:		ds.b 1	; PSG flutter (dynamically affects PSG volume for decay effects)
	StackPointer:		ds.b 1	; "Gosub" stack position offset (starts at 2Ah, i.e. end of track, and each jump decrements by 2)
	DurationTimeout:	ds.b 1	; Current duration timeout; counting down to zero
	SavedDuration:		ds.b 1	; Last set duration (if a note follows a note, this is reapplied to 0Bh)
	;
	; 	; 0Dh / 0Eh change a little depending on track -- essentially they hold data relevant to the next note to play
	SavedDAC:			; DAC: Next drum to play
	FreqLow:		ds.b 1	; FM/PSG: frequency low byte
	FreqHigh:		ds.b 1	; FM/PSG: frequency high byte
	NoteFillTimeout:	ds.b 1	; Currently set note fill; counts down to zero and then cuts off note
	NoteFillMaster:		ds.b 1	; Reset value for current note fill
	ModulationPtrLow:	ds.b 1	; Low byte of address of current modulation setting
	ModulationPtrHigh:	ds.b 1	; High byte of address of current modulation setting
	ModulationWait:		ds.b 1	; Wait for ww period of time before modulation starts
	ModulationSpeed:	ds.b 1	; Modulation speed
	ModulationDelta:	ds.b 1	; Modulation change per mod. Step
	ModulationSteps:	ds.b 1	; Number of steps in modulation (divided by 2)
	ModulationValLow:	ds.b 1	; Current modulation value low byte
	ModulationValHigh:	ds.b 1	; Current modulation value high byte
	Detune:			ds.b 1	; Set by detune coord flag E1; used to add directly to FM/PSG frequency
	VolTLMask:		ds.b 1	; zVolTLMaskTbl value set during voice setting (value based on algorithm indexing zGain table)
	PSGNoise:		ds.b 1	; PSG noise setting
	VoicePtrLow:		ds.b 1	; Low byte of custom voice table (for SFX)
	VoicePtrHigh:		ds.b 1	; High byte of custom voice table (for SFX)
	TLPtrLow:		ds.b 1	; Low byte of where TL bytes of current voice begin (set during voice setting)
	TLPtrHigh:		ds.b 1	; High byte of where TL bytes of current voice begin (set during voice setting)
	LoopCounters:		ds.b $A	; Loop counter index 0
	;   ... open ...
	GoSubStack:			; start of next track, every two bytes below this is a coord flag "gosub" (F8h) return stack
	;
	;	The bytes between +20h and +29h are "open"; starting at +20h and going up are possible loop counters
	;	(for coord flag F7) while +2Ah going down (never AT 2Ah though) are stacked return addresses going
	;	down after calling coord flag F8h.  Of course, this does mean collisions are possible with either
	;	or other track memory if you're not careful with these!  No range checking is performed!
	;
	; 	All tracks are 2Ah bytes long
zTrack ENDSTRUCT

zVar STRUCT DOTS
	SFXPriorityVal:		ds.b 1
	TempoTimeout:		ds.b 1
	CurrentTempo:		ds.b 1	; Stores current tempo value here
	StopMusic:		ds.b 1	; Set to 7Fh to pause music, set to 80h to unpause. Otherwise 00h
	FadeOutCounter:		ds.b 1
	FadeOutDelay:		ds.b 1
	Communication:		ds.b 1	; Unused byte used to synchronise gameplay events with music
	DACUpdating:		ds.b 1	; Set to FFh while DAC is updating, then back to 00h
	QueueToPlay:		ds.b 1	; The head of the queue
	Queue0:			ds.b 1
	Queue1:			ds.b 1
	Queue2:			ds.b 1	; This slot was totally broken in Sonic 1's driver. It's mostly fixed here, but it's still a little broken (see 'zInitMusicPlayback').
	VoiceTblPtr:		ds.b 2	; Address of the voices
	FadeInFlag:		ds.b 1
	FadeInDelay:		ds.b 1
	FadeInCounter:		ds.b 1
	1upPlaying:		ds.b 1
	TempoMod:		ds.b 1
	TempoTurbo:		ds.b 1	; Stores the tempo if speed shoes are acquired (or 7Bh is played otherwise)
	SpeedUpFlag:		ds.b 1
	DACEnabled:		ds.b 1
	MusicBankNumber:	ds.b 1
	IsPalFlag:		ds.b 1	; Flags if the system is a PAL console
zVar ENDSTRUCT

; equates: standard (for Genesis games) addresses in the memory map
zYM2612_A0 =	$4000
zYM2612_D0 =	$4001
zYM2612_A1 =	$4002
zYM2612_D1 =	$4003
zBankRegister =	$6000
zPSG =		$7F11
zROMWindow =	$8000
; More equates: addresses specific to this program (besides labelled addresses)
zMusicData =	$1380		; don't change this unless you change all the pointers in the BINCLUDE'd music too...
zStack =	zMusicData+$800	; 1B80h

	phase zStack
zAbsVar:		zVar

zTracksSongStart:	; This is the beginning of all BGM track memory
zSongDACFMStart:
zSongDAC:		zTrack
zSongFMStart:
zSongFM1:		zTrack
zSongFM2:		zTrack
zSongFM3:		zTrack
zSongFM4:		zTrack
zSongFM5:		zTrack
zSongFM6:		zTrack
zSongFMEnd:
zSongDACFMEnd:
zSongPSGStart:
zSongPSG1:		zTrack
zSongPSG2:		zTrack
zSongPSG3:		zTrack
zSongPSGEnd:
zTracksSongEnd:

zTracksSFXStart:
zSFX_FMStart:
zSFX_FM3:		zTrack
zSFX_FM4:		zTrack
zSFX_FM5:		zTrack
zSFX_FMEnd:
zSFX_PSGStart:
zSFX_PSG1:		zTrack
zSFX_PSG2:		zTrack
zSFX_PSG3:		zTrack
zSFX_PSGEnd:
zTracksSFXEnd:

zTracksSaveStart:	; When extra life plays, it backs up a large amount of memory (all track data plus 36 bytes)
zSaveVar:		zVar
zSaveSongDAC:		zTrack
zSaveSongFM1:		zTrack
zSaveSongFM2:		zTrack
zSaveSongFM3:		zTrack
zSaveSongFM4:		zTrack
zSaveSongFM5:		zTrack
zSaveSongFM6:		zTrack
zSaveSongPSG1:		zTrack
zSaveSongPSG2:		zTrack
zSaveSongPSG3:		zTrack
zTracksSaveEnd:
; See the very end for another set of variables

	if *>$2000
		fatal "Z80 variables are \{*-$2000}h bytes past the end of Z80 RAM!"
	endif
	dephase

MUSIC_TRACK_COUNT = (zTracksSongEnd-zTracksSongStart)/zTrack.len
MUSIC_DAC_FM_TRACK_COUNT = (zSongDACFMEnd-zSongDACFMStart)/zTrack.len
MUSIC_FM_TRACK_COUNT = (zSongFMEnd-zSongFMStart)/zTrack.len
MUSIC_PSG_TRACK_COUNT = (zSongPSGEnd-zSongPSGStart)/zTrack.len

SFX_TRACK_COUNT = (zTracksSFXEnd-zTracksSFXStart)/zTrack.len
SFX_FM_TRACK_COUNT = (zSFX_FMEnd-zSFX_FMStart)/zTrack.len
SFX_PSG_TRACK_COUNT = (zSFX_PSGEnd-zSFX_PSGStart)/zTrack.len

    ; In what I believe is an unfortunate design choice in AS,
    ; both the phased and unphased PCs must be within the target processor's range,
    ; which means phase is useless here despite being designed to fix this problem...
    ; oh well, I set it up to fix this later when processing the .p file
    !org 0 ; Z80 code starting at address 0 has special meaning to s2p2bin.exe

    CPU Z80UNDOC
    listing purecode

; Macro to perform a bank switch... after using this,
; the start of zROMWindow points to the start of the given 68k address,
; rounded down to the nearest $8000 byte boundary
bankswitch macro addr68k
    if OptimiseDriver
	; Because why use a and e when you can use h and l?
	ld	hl,zBankRegister+1	; +1 so that 6000h becomes 6001h, which is still a valid bankswitch port
.cnt	:= 0
	rept 9
		; this is either ld (hl),h or ld (hl),l
		db 74h|(((addr68k)&(1<<(15+.cnt)))<>0)
.cnt		:= .cnt+1
	endm
    else
	xor	a	; a = 0
	ld	e,1	; e = 1
	ld	hl,zBankRegister
.cnt	:= 0
	rept 9
		; this is either ld (hl),a or ld (hl),e
		db 73h|((((addr68k)&(1<<(15+.cnt)))=0)<<2)
.cnt		:= .cnt+1
	endm
    endif
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

; Function to turn a 68k address into a word the Z80 can use to access it,
; assuming the correct bank has been switched to first
zmake68kPtr function addr,zROMWindow+(addr&7FFFh)

; Function to turn a sample rate into a djnz loop counter
pcmLoopCounterBase function sampleRate,baseCycles, 1+(53693175/15/(sampleRate)-(baseCycles)+(13/2))/13
pcmLoopCounter function sampleRate, pcmLoopCounterBase(sampleRate,146/2) ; 146 is the number of cycles zPlaySegaSound takes to deliver two samples.
dpcmLoopCounter function sampleRate, pcmLoopCounterBase(sampleRate,289/2) ; 289 is the number of cycles zWriteToDAC takes to deliver two samples.

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Z80 'ROM' start:
; zEntryPoint:
	di	; Disable interrupts
	ld	sp,zStack
	jp	zStartDAC
; ---------------------------------------------------------------------------
; zbyte_7:
zPalModeByte:
	db	0

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
    if ~~OptimiseDriver	; This is redundant: the Z80 is slow enough to not need to worry about this
	align	8
; zsub_8
zFMBusyWait:    rsttarget
	; Performs the annoying task of waiting for the FM to not be busy
	ld	a,(zYM2612_A0)
	add	a,a
	jr	c,zFMBusyWait
	ret
; End of function zFMBusyWait
    endif

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
	align	8
; zsub_10
zWriteFMIorII:    rsttarget
	bit	2,(ix+zTrack.VoiceControl)
	jr	z,zWriteFMI
	jr	zWriteFMII
; End of function zWriteFMIorII

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
	align	8
; zsub_18
zWriteFMI:    rsttarget
	; Write reg/data pair to part I; 'a' is register, 'c' is data
    if ~~OptimiseDriver
	push	af
	rst	zFMBusyWait ; 'rst' is like 'call' but only works for 8-byte aligned addresses <= 38h
	pop	af
    endif
	ld	(zYM2612_A0),a
	push	af
    if ~~OptimiseDriver
	rst	zFMBusyWait
    endif
	ld	a,c
	ld	(zYM2612_D0),a
	pop	af
	ret
; End of function zWriteFMI

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
	align	8
; zsub_28
zWriteFMII:    rsttarget
	; Write reg/data pair to part II; 'a' is register, 'c' is data
    if ~~OptimiseDriver
	push	af
	rst	zFMBusyWait
	pop	af
    endif
	ld	(zYM2612_A1),a
	push	af
    if ~~OptimiseDriver
	rst	zFMBusyWait
    endif
	ld	a,c
	ld	(zYM2612_D1),a
	pop	af
	ret
; End of function zWriteFMII

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
	org	38h
zVInt:    rsttarget
	; This is called every VBLANK (38h is the interrupt entry point,
	; and VBLANK is the only one Z80 is hooked up to.)

	push	af			; Save 'af'
	exx				; Effectively backs up 'bc', 'de', and 'hl'
	call	zBankSwitchToMusic	; Bank switch to the music
	xor	a			; Clear 'a'
	ld	(zDoSFXFlag),a		; Not updating SFX (updating music)
	ld	ix,zAbsVar		; ix points to zComRange
	ld	a,(zAbsVar.StopMusic)	; Get pause/unpause flag
	or	a			; Test 'a'
	jr	z,zUpdateEverything	; If zero, go to zUpdateEverything
	call	zPauseMusic
	jp	zUpdateDAC		; Now update the DAC
; ---------------------------------------------------------------------------

; zloc_51
zUpdateEverything:
	ld	a,(zAbsVar.FadeOutCounter)	; Are we fading out?
	or	a
	call	nz,zUpdateFadeout		; If so, update that

	ld	a,(zAbsVar.FadeInFlag)		; Are we fading in?
	or	a
	call	nz,zUpdateFadeIn		; If so, update that

	ld	a,(zAbsVar.Queue0)
	or	(ix+zVar.Queue1)
	or	(ix+zVar.Queue2)		; This was missing in Sonic 1's driver, breaking the third queue slot.
	call	nz,zCycleQueue			; If any of those are non-zero, cycle queue

	; Apparently if this is 80h, it does not play anything new,
	; otherwise it cues up the next play (flag from 68K for new item)
	ld	a,(zAbsVar.QueueToPlay)
	cp	80h
	call	nz,zPlaySoundByIndex		; If not 80h, we need to play something new!

	; Spindash update
	ld	a,(zSpindashPlayingCounter)
	or	a
	jr	z,.pal_timer			; If the spindash counter is already 0, jump
	dec	a				; Decrease the spindash sound playing counter
	ld	(zSpindashPlayingCounter),a

.pal_timer:
	; If the system is PAL, then this performs some timing adjustments
	; (i.e. you need to update 1.2x as much to keep up the same rate)
	ld	hl,zPalModeByte		; Get address of zPalModeByte
	ld	a,(zAbsVar.IsPalFlag)	; Get IsPalFlag -> 'a'
	and	(hl)			; 'And' them together
	jr	z,.not_pal		; If it comes out zero, do nothing
	ld	hl,zPALUpdTick
	dec	(hl)
	jr	nz,.not_pal
	ld	(hl),5			; Every 6 frames (0-5) you need to "double update" to sort of keep up
	call	zUpdateMusic

.not_pal:
	call	zUpdateMusic

	; Now all of the SFX tracks are updated in a similar manner to "zUpdateMusic"...
	bankswitch SoundIndex		; Bank switch to sound effects

	ld	a,80h
	ld	(zDoSFXFlag),a		; Set zDoSFXFlag = 80h (updating sound effects)

    if FixDriverBugs
	; A bugfix in zUpdateMusic prevents it from returning ix set to a convenient value, so set it explicitly here
	ld	ix,zTracksSFXStart-zTrack.len
    endif

	; FM SFX channels
	ld	b,SFX_FM_TRACK_COUNT		; Only 3 FM channels for SFX (FM3, FM4, FM5)

.fmloop:
	push	bc
	ld	de,zTrack.len			; Spacing between tracks
	add	ix,de				; Next track
	bit	7,(ix+zTrack.PlaybackControl)	; Is it playing?
	call	nz,zFMUpdateTrack		; If it is, go update it
	pop	bc
	djnz	.fmloop

	; PSG SFX channels
	ld	b,SFX_PSG_TRACK_COUNT		; All PSG channels available

.psgloop:
	push	bc
	ld	de,zTrack.len			; Spacing between tracks
	add	ix,de				; Next track
	bit	7,(ix+zTrack.PlaybackControl)	; Is it playing?
	call	nz,zPSGUpdateTrack		; If it is, go update it
	pop	bc
	djnz	.psgloop

	; Now we update the DAC... this only does anything if there's a new DAC
	; sound to be played.  This is called after updating the DAC track.
	; Otherwise it just mucks with the timing loop, forcing an update.
zUpdateDAC:
	bankswitch SndDAC_Start		; Bankswitch to the DAC data

	ld	a,(zCurDAC)		; Get currently playing DAC sound
	or	a
	jp	m,.dacqueued		; If one is queued (80h+), go to it!
	exx				; Otherwise restore registers from mirror regs
	ld	b,1			; b=1 (initial feed to the DAC "djnz" loops, i.e. UPDATE RIGHT AWAY)
	pop	af
	ei				; Enable interrupts
	ret

.dacqueued:
	; If you get here, it's time to start a new DAC sound...
	ld	a,80h
	ex	af,af'	;'
	ld	a,(zCurDAC)		; Get current DAC sound
	sub	81h			; Subtract 81h (first DAC index is 81h)
	ld	(zCurDAC),a		; Store that as current DAC sound
	; The following two instructions are dangerous: they discard the upper
	; two bits of zCurDAC, meaning you can only have 40h DAC samples.
	add	a,a
	add	a,a			; a *= 4 (each DAC entry is a pointer and length, 2+2)
	add	a,zDACPtrTbl&0FFh	; Get low byte into table -> 'a'
	ld	(zDACStartAddress+1),a	; Store into the instruction after zDACStartAddress (self-modifying code)
	add	a,zDACLenTbl-zDACPtrTbl	; How to offset to length versus pointer
	ld	(zDACStoreLength+2),a	; Store into the instruction after zDACStoreLength (self-modifying code)
	pop	af
	ld	hl,zWriteToDAC
	ex	(sp),hl			; Jump to zWriteToDAC

; zloc_104
zDACStartAddress:
	ld	hl,(zDACPtrTbl)		; Self-modified code: sets start address of DAC sample for zWriteToDAC

; zloc_107
zDACStoreLength:
	ld	de,(zDACLenTbl)		; Self-modified code: sets length of DAC sample for zWriteToDAC

;zloc_10B
zDACStoreDelay:
	ld	bc,100h			; Self-modified code: From zDACDataStore; sets b=1 (the 100h part of it) UPDATE RIGHT AWAY and c="data rate delay" for this DAC sample, the future 'b' setting
	ei				; Enable interrupts
	ret
; End of function zVInt


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Updates all tracks; queues notes and durations!

; zsub_110
zUpdateMusic:
    if ~~FixDriverBugs
	; Calling this function here is bad, because it can cause the
	; first note of a newly-started song to be delayed for a frame.
	; The vanilla driver resorts to a workaround to prevent such a
	; delay from having side-effects, but it's better to just fix
	; the problem directly, and move this call to the proper place.
	call	TempoWait
    endif

	; DAC updates
	ld	a,0FFh
	ld	(zAbsVar.DACUpdating),a		; Store FFh to DACUpdating
	ld	ix,zTracksSongStart			; Point "ix" to zTracksSongStart
	bit	7,(ix+zTrack.PlaybackControl)	; Is bit 7 (80h) set on playback control byte? (means "is playing")
	call	nz,zDACUpdateTrack		; If so, zDACUpdateTrack
	xor	a				; Clear a
	ld	(zAbsVar.DACUpdating),a		; Store 0 to DACUpdating
	ld	b,MUSIC_FM_TRACK_COUNT		; Loop 6 times (FM)...

.fmloop:
	push	bc
	ld	de,zTrack.len			; Space between tracks
	add	ix,de				; Go to next track
	bit	7,(ix+zTrack.PlaybackControl)	; Is bit 7 (80h) set on playback control byte? (means "is playing")
	call	nz,zFMUpdateTrack		; If so...
	pop	bc
	djnz	.fmloop

	ld	b,MUSIC_PSG_TRACK_COUNT		; Loop 3 times (PSG)...

.psgloop:
	push	bc
	ld	de,zTrack.len			; Space between tracks
	add	ix,de				; Go to next track
	bit	7,(ix+zTrack.PlaybackControl)	; Is this track playing?
	call	nz,zPSGUpdateTrack		; If so...
	pop	bc
	djnz	.psgloop

    if ~~FixDriverBugs
	; See above. Removing this instruction will cause this
	; subroutine to fall-through to TempoWait.
	ret
    endif
; End of function zUpdateMusic


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_14C
TempoWait:
	; Tempo works as divisions of the 60Hz clock (there is a fix supplied for
	; PAL that "kind of" keeps it on track.)  Every time the internal music clock
	; overflows, it will update.  So a tempo of 80h will update every other
	; frame, or 30 times a second.

	ld	ix,zAbsVar			; ix points to zComRange
	ld	a,(ix+zVar.CurrentTempo)	; tempo value
	add	a,(ix+zVar.TempoTimeout)	; Adds previous value to
	ld	(ix+zVar.TempoTimeout),a	; Store this as new
	ret	c				; If addition overflowed (answer greater than FFh), return

	; So if adding tempo value did NOT overflow, then we add 1 to all durations
	ld	hl,zTracksSongStart+zTrack.DurationTimeout	; Start at first track's delay counter (counting up to delay)
	ld	de,zTrack.len				; Offset between tracks
	ld	b,MUSIC_TRACK_COUNT			; Loop for all tracks

.tempoloop:
	inc	(hl)	; Increasing delay tick counter to target
	add	hl,de	; Next track...
	djnz	.tempoloop

	ret
; End of function TempoWait

; ---------------------------------------------------------------------------

; zloc_167
zStartDAC:
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
	ld	a,d			; 4
	or	e			; 4
	jr	z,zWaitLoop		; 7	; As long as 'de' (length of sample) = 0, wait...

	; 'hl' is the pointer to the sample, 'de' is the length of the sample,
	; and 'iy' points to the translation table; let's go...

	; The "djnz $" loops control the playback rate of the DAC
	; (the higher the 'b' value, the slower it will play)


	; As for the actual encoding of the data, it is described by jman2050:

	; "As for how the data is compressed, lemme explain that real quick:
	; First, it is a lossy compression. So if you recompress a PCM sample this way,
	; you will lose precision in data. Anyway, what happens is that each compressed data
	; is separated into nybbles (1 4-bit section of a byte). This first nybble of data is
	; read, and used as an index to a table containing the following data:
	; 0,1,2,4,8,$10,$20,$40,$80,$FF,$FE,$FC,$F8,$F0,$E0,$C0."   [zDACDecodeTbl / zbyte_1B3]
	; "So if the nybble were equal to F, it'd extract $C0 from the table. If it were 8,
	; it would extract $80 from the table. ... Anyway, there is also another byte of data
	; that we'll call 'd'. At the start of decompression, d is $80. What happens is that d
	; is then added to the data extracted from the table using the nybble. So if the nybble
	; were 4, the 8 would be extracted from the table, then added to d, which is $80,
	; resulting in $88. This result is then put back into d, then fed into the YM2612 for
	; processing. Then the next nybble is read, the data is extracted from the table, then
	; is added to d (remember, d is now changed because of the previous operation), then is
	; put back into d, then is fed into the YM2612. This process is repeated until the number
	; of bytes as defined in the table above are read and decompressed."

	; In our case, the so-called 'd' value is shadow register 'a'

zWriteToDAC:
	djnz	$			; 8	; Busy wait for specific amount of time in 'b'

	di				; 4	; disable interrupts (while updating DAC)
	ld	a,2Ah			; 7	; DAC port
	ld	(zYM2612_A0),a		; 13	; Set DAC port register
	ld	a,(hl)			; 7	; Get next DAC byte
	rlca				; 4
	rlca				; 4
	rlca				; 4
	rlca				; 4
	and	0Fh			; 7	; UPPER 4-bit offset into zDACDecodeTbl
	ld	(.highnybble+2),a	; 13	; store into the instruction after .highnybble (self-modifying code)
	ex	af,af'			; 4	; shadow register 'a' is the 'd' value for 'jman2050' encoding

; zloc_18B
.highnybble:
	add	a,(iy+0)		; 19	; Get byte from zDACDecodeTbl (self-modified to proper index)
	ld	(zYM2612_D0),a		; 13	; Write this byte to the DAC
	ex	af,af'			; 4	; back to regular registers
	ld	b,c			; 4	; reload 'b' with wait value
	ei				; 4	; enable interrupts (done updating DAC, busy waiting for next update)

	djnz	$			; 8	; Busy wait for specific amount of time in 'b'

	di				; 4	; disable interrupts (while updating DAC)
	push	af			; 11
	pop	af			; 11
	ld	a,2Ah			; 7	; DAC port
	ld	(zYM2612_A0),a		; 13	; Set DAC port register
	ld	b,c			; 4	; reload 'b' with wait value
	ld	a,(hl)			; 7	; Get next DAC byte
	inc	hl			; 6	; Next byte in DAC stream...
	dec	de			; 6	; One less byte
	and	0Fh			; 7	; LOWER 4-bit offset into zDACDecodeTbl
	ld	(.lownybble+2),a	; 13	; store into the instruction after .lownybble (self-modifying code)
	ex	af,af'			; 4	; shadow register 'a' is the 'd' value for 'jman2050' encoding

; zloc_1A8
.lownybble:
	add	a,(iy+0)		; 19	; Get byte from zDACDecodeTbl (self-modified to proper index)
	ld	(zYM2612_D0),a		; 13	; Write this byte to the DAC
	ex	af,af'			; 4	; back to regular registers
	ei				; 4	; enable interrupts (done updating DAC, busy waiting for next update)
	jp	zWaitLoop		; 10	; Back to the wait loop; if there's more DAC to write, we come back down again!
					; 289
	; 289 cycles for two samples. dpcmLoopCounter should use 289 divided by 2.
; ---------------------------------------------------------------------------
; 'jman2050' DAC decode lookup table
; zbyte_1B3
zDACDecodeTbl:
	db	   0,    1,   2,   4,   8,  10h,  20h,  40h
	db	 80h,   -1,  -2,  -4,  -8, -10h, -20h, -40h

	; The following two tables are used for when an SFX terminates
	; its track to properly restore the music track it temporarily took
	; over.  Note that an important rule here is that no SFX may use
	; DAC, FM Channel 1, FM Channel 2, or FM Channel 6, period.
	; Thus there's also only SFX tracks starting at FM Channel 3.

	; The zeroes appear after FM 3 because it calculates the offsets into
	; these tables by their channel assignment, where between Channel 3
	; and Channel 4 there is a gap numerically.

	ensure1byteoffset 10h
; zbyte_1C3
zMusicTrackOffs:
	; These are offsets to different music tracks starting with FM3
	dw	zSongFM3,      0000h,  zSongFM4,  zSongFM5	; FM3, 0, FM4, FM5
	dw	zSongPSG1, zSongPSG2, zSongPSG3, zSongPSG3	; PSG1, PSG2, PSG3, PSG3 (noise alternate)

	ensure1byteoffset 10h
; zbyte_1D3
zSFXTrackOffs:
	; These are offsets to different sound effect tracks starting with FM3
	dw	zSFX_FM3,      0000h,  zSFX_FM4,  zSFX_FM5	; FM3, 0, FM4, FM5
	dw	zSFX_PSG1, zSFX_PSG2, zSFX_PSG3, zSFX_PSG3	; PSG1, PSG2, PSG3, PSG3 (noise alternate)
; ---------------------------------------------------------------------------
zDACUpdateTrack:
	dec	(ix+zTrack.DurationTimeout)
	ret	nz
	ld	l,(ix+zTrack.DataPointerLow)
	ld	h,(ix+zTrack.DataPointerHigh)

.sampleloop:
	ld	a,(hl)		; Get next byte from DAC Track
	inc	hl		; Move to next position...
	cp	0E0h		; Check if is coordination flag
	jr	c,.notcoord	; Not coord flag?  Skip ahead
	call	zCoordFlag	; Handle coordination flag
	jp	.sampleloop	; Loop back around...

.notcoord:
	or	a			; Test 'a' for 80h not set, which is a note duration
	jp	p,.gotduration		; If note duration, jump ahead (note that "hl" is already incremented)
	ld	(ix+zTrack.SavedDAC),a	; This is a note; store it here
	ld	a,(hl)			; Get next byte...
	or	a			; Test 'a' for 80h not set, which is a note duration
	jp	p,.repeatduration	; Is this a duration this time??  If so, jump ahead (only difference is to increment "hl")
	; Note followed by a note... apparently recycles the previous duration
	ld	a,(ix+zTrack.SavedDuration)	; Current DAC note ticker goal value -> 'a'
	ld	(ix+zTrack.DurationTimeout),a	; Use it again
	jr	zDACAfterDur			; Jump to after duration subroutine...
; ---------------------------------------------------------------------------

; zloc_20D
.repeatduration:
	inc	hl	; Goes to next byte (after duration byte)

; zloc_20E
.gotduration:
	call	zSetDuration

; zloc_211
zDACAfterDur:
	ld	(ix+zTrack.DataPointerLow),l	; Stores "hl" to the DAC track pointer memory
	ld	(ix+zTrack.DataPointerHigh),h
	bit	2,(ix+zTrack.PlaybackControl)	; Is SFX overriding this track?
	ret	nz				; If so, we're done
	ld	a,(ix+zTrack.SavedDAC)		; Check next note to play
	cp	80h				; Is it a rest?
	ret	z				; If so, quit
	sub	81h				; Otherwise, transform note into an index... (we're selecting which drum to play!)
	add	a,a				; Multiply by 2...
	add	a,zDACMasterPlaylist&0FFh	; Offset into list
	ld	(zDACDataStore+2),a		; store into the following instruction (self-modifying code)

; zloc_22A
zDACDataStore:
	ld	bc,(zDACMasterPlaylist)		; Load appropriate drum info -> bc
	ld	a,c				; DAC sample number (81h base) -> 'a'
	ld	(zCurDAC),a			; Store current DAC sound to play
	ld	a,b				; Data rate delay -> 'b'
	ld	(zDACStoreDelay+1),a		; store into the instruction after zDACStoreDelay (self-modifying code)
	ret

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_237
zFMUpdateTrack:
	dec	(ix+zTrack.DurationTimeout)	; Decrement duration
	jr	nz,.notegoing			; If not time-out yet, go do updates only
	res	4,(ix+zTrack.PlaybackControl)	; When duration over, clear "do not attack" bit 4 (0x10) of track's play control
	call	zFMDoNext			; Handle coordination flags, get next note and duration
	call	zFMPrepareNote			; Prepares to play next note
	call	zFMNoteOn			; Actually key it (if allowed)
	call	zDoModulation			; Update modulation (if modulation doesn't change, we do not return here)
	jp	zFMUpdateFreq			; Applies frequency update from modulation

.notegoing:
	call	zNoteFillUpdate			; Applies "note fill" (time until cut-off); NOTE: Will not return here if "note fill" expires
	call	zDoModulation			; Update modulation (if modulation doesn't change, we do not return here)
	jp	zFMUpdateFreq			; Applies frequency update from modulation
; End of function zFMUpdateTrack


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_258
zFMDoNext:
	ld	l,(ix+zTrack.DataPointerLow)	; Load track position low byte
	ld	h,(ix+zTrack.DataPointerHigh)	; Load track position high byte
	res	1,(ix+zTrack.PlaybackControl)	; Clear bit 1 (02h) "track is rest" from track

.noteloop:
	ld	a,(hl)
	inc	hl		; Increment track to next byte
	cp	0E0h		; Is it a control byte / "coordination flag"?
	jr	c,.gotnote	; If not, jump over
	call	zCoordFlag	; Handle coordination flag
	jr	.noteloop	; Go around, get next byte

.gotnote:
	push	af
	call	zFMNoteOff		; Send key off
	pop	af
	or	a			; Test 'a' for 80h not set, which is a note duration
	jp	p,.gotduration		; If duration, jump to .gotduration
	call	zFMSetFreq		; Otherwise, this is a note; call zFMSetFreq
	ld	a,(hl)			; Get next byte
	or	a			; Test 'a' for 80h set, which is a note
	jp	m,zFinishTrackUpdate	; If this is a note, jump to zFinishTrackUpdate
	inc	hl			; Otherwise, go to next byte; a duration

.gotduration:
	call	zSetDuration
	jp	zFinishTrackUpdate	; Either way, jumping to zFinishTrackUpdate...
; End of function zFMDoNext

; ---------------------------------------------------------------------------
; zloc_285 zGetFrequency
zFMSetFreq:
	; 'a' holds a note to get frequency for
	sub	80h
	jr	z,zFMDoRest		; If this is a rest, jump to zFMDoRest
	add	a,(ix+zTrack.Transpose)	; Add current channel transpose (coord flag E9)
	add	a,a			; Offset into Frequency table...
    if OptimiseDriver
	ld	d,12*2			; 12 notes per octave
	ld	c,0			; Clear c (will hold octave bits)

.loop:
	sub	d			; Subtract 1 octave from the note
	jr	c,.getoctave		; If this is less than zero, we are done
	inc	c			; One octave up
	jr	.loop

.getoctave:
	add	a,d			; Add 1 octave back (so note index is positive)
	sla	c
	sla	c
	sla	c			; Multiply octave value by 8, to get final octave bits
    endif
	add	a,zFrequencies&0FFh
	ld	(.storefreq+2),a		; Store into the instruction after .storefreq (self-modifying code)
;	ld	d,a
;	adc	a,(zFrequencies&0FF00h)>>8
;	sub	d
;	ld	(.storefreq+3),a		; This is how you could store the high byte of the pointer too (unnecessary if it's in the right range)

; zloc_292
.storefreq:
	ld	de,(zFrequencies)	; Stores frequency into "de"
	ld	(ix+zTrack.FreqLow),e	; Frequency low byte   -> trackPtr + 0Dh
    if OptimiseDriver
	ld	a,d
	or	c
	ld	(ix+zTrack.FreqHigh),a	; Frequency high byte  -> trackPtr + 0Eh
    else
	ld	(ix+zTrack.FreqHigh),d	; Frequency high byte  -> trackPtr + 0Eh
    endif
	ret
; ---------------------------------------------------------------------------

; zloc_29D
zFMDoRest:
	set	1,(ix+zTrack.PlaybackControl)	; Set bit 1 (track is at rest)
	xor	a				; Clear 'a'
	ld	(ix+zTrack.FreqLow),a		; Zero out FM Frequency
	ld	(ix+zTrack.FreqHigh),a		; Zero out FM Frequency
	ret

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_2A9
zSetDuration:
	ld	c,a				; 'a' = current duration
	ld	b,(ix+zTrack.TempoDivider)	; Divisor; causes multiplication of duration for every number higher than 1

.multloop:
	djnz	.multloop_outer
	ld	(ix+zTrack.SavedDuration),a	; Store new duration into ticker goal of this track (this is reused if a note follows a note without a new duration)
	ld	(ix+zTrack.DurationTimeout),a	; Sets it on ticker (counts to zero)
	ret

.multloop_outer:
	add	a,c				; Will multiply duration based on 'b'
	jp	.multloop
; End of function zSetDuration

; ---------------------------------------------------------------------------

; zloc_2BA
zFinishTrackUpdate:
	; Common finish-up routine used by FM or PSG
	ld	(ix+zTrack.DataPointerLow),l	; Stores "hl" to the track pointer memory
	ld	(ix+zTrack.DataPointerHigh),h
	ld	a,(ix+zTrack.SavedDuration)	; Last set duration
	ld	(ix+zTrack.DurationTimeout),a	; ... put into ticker
	bit	4,(ix+zTrack.PlaybackControl)	; Is bit 4 (10h) "do not attack next note" set on playback?
	ret	nz				; If so, quit
	ld	a,(ix+zTrack.NoteFillMaster)	; Master "note fill" value -> a
	ld	(ix+zTrack.NoteFillTimeout),a	; Reset 0Fh "note fill" value to master
	ld	(ix+zTrack.VolFlutter),0	; Reset PSG flutter byte
	bit	3,(ix+zTrack.PlaybackControl)	; is modulation turned on?
	ret	z				; if not, quit
	ld	l,(ix+zTrack.ModulationPtrLow)	; Otherwise, get address of modulation setting
	ld	h,(ix+zTrack.ModulationPtrHigh)
	jp	zSetModulation	; ... and go do it!

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_2E3
zNoteFillUpdate:
	ld	a,(ix+zTrack.NoteFillTimeout)	; Get current note fill value
	or	a
	ret	z				; If zero, return!
	dec	(ix+zTrack.NoteFillTimeout)	; Decrement note fill
	ret	nz				; If not zero, return
	set	1,(ix+zTrack.PlaybackControl)	; Set bit 1 (track is at rest)
	pop	de				; return address -> 'de' (will not return to zUpdateTrack function!!)
	bit	7,(ix+zTrack.VoiceControl)	; Is this a PSG track?
	jp	nz,zPSGNoteOff			; If so, jump to zPSGNoteOff
	jp	zFMNoteOff			; Else, jump to zFMNoteOff
; End of function zNoteFillUpdate


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_2FB
zDoModulation:
	pop	de				; keep return address -> de (MAY not return to caller)

	bit	1,(ix+zTrack.PlaybackControl)	; Is "track in rest"?
	ret	nz				; If so, quit
	bit	3,(ix+zTrack.PlaybackControl)	; Is modulation on?
	ret	z				; If not, quit
	ld	a,(ix+zTrack.ModulationWait)	; 'ww' period of time before modulation starts
	or	a
	jr	z,.waitdone			; if zero, go to it!
	dec	(ix+zTrack.ModulationWait)	; Otherwise, decrement timer
	ret					; return if decremented (does NOT return to zUpdateTrack!!)

.waitdone:
	dec	(ix+zTrack.ModulationSpeed)	; Decrement modulation speed counter
	ret	nz				; Return if not yet zero
	ld	l,(ix+zTrack.ModulationPtrLow)
	ld	h,(ix+zTrack.ModulationPtrHigh)	; 'hl' points to modulation setting
	inc	hl				; skip passed 'ww' period of time
	ld	a,(hl)				; Get modulation speed
	ld	(ix+zTrack.ModulationSpeed),a	; Restore speed counter
	ld	a,(ix+zTrack.ModulationSteps)	; Get number of steps in modulation
	or	a
	jr	nz,.calcfreq			; If not zero, skip to .calcfreq

	; If steps have reached zero...
	inc	hl				; passed mod speed
	inc	hl				; passed mod change per mod step
	ld	a,(hl)				; get number of steps in modulation
	ld	(ix+zTrack.ModulationSteps),a	; restore modulation steps
	ld	a,(ix+zTrack.ModulationDelta)	; get modulation change per mod step
	neg					; flip it negative
	ld	(ix+zTrack.ModulationDelta),a	; store negated value
	ret

.calcfreq:
	dec	(ix+zTrack.ModulationSteps)	; Decrement the step
	ld	l,(ix+zTrack.ModulationValLow)
	ld	h,(ix+zTrack.ModulationValHigh)	; Get 16-bit modulation value

	; This is a 16-bit sign extension for 'bc'
    if OptimiseDriver
	ld	a,(ix+zTrack.ModulationDelta)	; Get current modulation change per step -> 'a'
	ld	c,a
	rla					; Carry contains sign of delta
	sbc	a,a				; a = 0 or -1 if carry is 0 or 1
	ld	b,a				; bc = sign extension of delta
    else
	ld	b,0
	ld	c,(ix+zTrack.ModulationDelta)	; Get current modulation change per step -> 'c'
	bit	7,c
	jp	z,.nosignextend
	ld	b,0FFh				; Sign extend if negative

.nosignextend:
    endif
	add	hl,bc				; Add to current modulation value
	ld	(ix+zTrack.ModulationValLow),l
	ld	(ix+zTrack.ModulationValHigh),h	; Store new 16-bit modulation value
	ld	c,(ix+zTrack.FreqLow)		; frequency low byte -> c
	ld	b,(ix+zTrack.FreqHigh)		; frequency high byte -> b
	add	hl,bc				; Add modulation value
	ex	de,hl
	jp	(hl)				; WILL return to zUpdateTrack
; End of function zDoModulation

; ---------------------------------------------------------------------------
; This the note -> frequency setting lookup
; the same array is found at $729CE in Sonic 1, and at $C9C44 in Ristar
; zword_359:
	ensure1byteoffset 8Ch
zPSGFrequencies:
	dw	356h, 326h, 2F9h, 2CEh, 2A5h, 280h, 25Ch, 23Ah, 21Ah, 1FBh, 1DFh, 1C4h
	dw	1ABh, 193h, 17Dh, 167h, 153h, 140h, 12Eh, 11Dh, 10Dh, 0FEh, 0EFh, 0E2h
	dw	0D6h, 0C9h, 0BEh, 0B4h, 0A9h, 0A0h,  97h,  8Fh,  87h,  7Fh,  78h,  71h
	dw	 6Bh,  65h,  5Fh,  5Ah,  55h,  50h,  4Bh,  47h,  43h,  40h,  3Ch,  39h
	dw	 36h,  33h,  30h,  2Dh,  2Bh,  28h,  26h,  24h,  22h,  20h,  1Fh,  1Dh
	dw	 1Bh,  1Ah,  18h,  17h,  16h,  15h,  13h,  12h,  11h,    0
; ---------------------------------------------------------------------------

; zloc_3E5
zFMPrepareNote:
	bit	1,(ix+zTrack.PlaybackControl)	; Is track in rest?
	ret	nz				; If so, quit
	ld	e,(ix+zTrack.FreqLow)		; Get frequency low
	ld	d,(ix+zTrack.FreqHigh)		; Get frequency high
	ld	a,d
	or	e
	jp	z,zSetRest			; If de == 0, go to zSetRest

; zloc_3F5
zFMUpdateFreq:
	bit	2,(ix+zTrack.PlaybackControl)	; Is SFX overriding this track?
	ret	nz				; If so, quit!
	; This is a 16-bit sign extension of (ix+19h)
    if OptimiseDriver
	ld	a,(ix+zTrack.Detune)		; Get detune value
	ld	l,a
	rla					; Carry contains sign of detune
	sbc	a,a				; a = 0 or -1 if carry is 0 or 1
	ld	h,a				; hl = sign extension of detune
    else
	ld	h,0				; h = 0
	ld	l,(ix+zTrack.Detune)		; Get detune value
	bit	7,l				; Did prior value have 80h set?
	jr	z,.nosignextend			; If not, skip next step
	ld	h,0FFh				; h = FFh

.nosignextend:
    endif
	add	hl,de				; Alter frequency just a tad
	ld	c,h				; Upper part of frequency as data to FM ('c')
	ld	a,(ix+zTrack.VoiceControl)	; "voice control" byte -> 'a'
	and	3				; Strip to only channel assignment
	add	a,0A4h				; Change to proper register
	rst	zWriteFMIorII			; Write it!
	ld	c,l				; lower part of frequency
	sub	4				; A0h+ register
	rst	zWriteFMIorII			; Write it!
	ret

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_414
zPSGUpdateTrack:
	dec	(ix+zTrack.DurationTimeout)	; decrement current duration timeout..
	jr	nz,.notegoing			; If not time-out yet, go do updates only
	res	4,(ix+zTrack.PlaybackControl)	; Reset "do not attack next note" bit
	call	zPSGDoNext			; Handle coordination flags, get next note and duration
	call	zPSGDoNoteOn			; Actually key it (if allowed)
	call	zPSGDoVolFX			; This applies PSG volume as well as its special volume-based effects that I call "flutter"
	call	zDoModulation			; Update modulation (if modulation doesn't change, we do not return here)
	jp	zPSGUpdateFreq

.notegoing:
	call	zNoteFillUpdate			; Applies "note fill" (time until cut-off); NOTE: Will not return here if "note fill" expires
	call	zPSGUpdateVolFX			; Update volume effects
	call	zDoModulation			; Update modulation (if modulation doesn't change, we do not return here)
	jp	zPSGUpdateFreq
; End of function zPSGUpdateTrack


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_438
zPSGDoNext:
	ld	l,(ix+zTrack.DataPointerLow)	; Load track position low byte
	ld	h,(ix+zTrack.DataPointerHigh)	; Load track position high byte
	res	1,(ix+zTrack.PlaybackControl)	; Clear bit 1 (02h) "track is rest" from track

.noteloop:
	ld	a,(hl)
	inc	hl				; Increment track to next byte
	cp	0E0h				; Is it a control byte / "coordination flag"?
	jr	c,.gotnote			; If not, jump over
	call	zCoordFlag			; Handle coordination flag
	jr	.noteloop			; Go around, get next byte

.gotnote:
	or	a				; Test 'a' for 80h not set, which is a note duration
	jp	p,.gotduration			; If note duration, jump to .gotduration
	call	zPSGSetFreq			; Get frequency for this note
	ld	a,(hl)				; Get next byte
	or	a				; Test 'a' for 80h set, which is a note
	jp	m,zFinishTrackUpdate		; If this is a note, jump to zFinishTrackUpdate
	inc	hl				; Otherwise, go to next byte; a duration

.gotduration:
	call	zSetDuration
	jp	zFinishTrackUpdate		; Either way, jumping to zFinishTrackUpdate...
; End of function zPSGDoNext

; ---------------------------------------------------------------------------

; zloc_460
zPSGSetFreq:
	sub	81h				; a = a-$81 (zero-based index from lowest note)
	jr	c,.restpsg			; If carry (only time that happens if 80h because of earlier logic) this is a rest!
	add	a,(ix+zTrack.Transpose)		; Add current channel transpose (coord flag E9)
	add	a,a				; Multiply note value by 2
	add	a,zPSGFrequencies&0FFh		; Point to proper place in table
	ld	(.storefreq+2),a		; store into the following instruction (self-modifying code)

; zloc_46D
.storefreq:
	ld	de,(zPSGFrequencies)		; Gets appropriate frequency setting -> 'de'
	ld	(ix+zTrack.FreqLow),e		; Frequency low byte   -> trackPtr + 0Dh
	ld	(ix+zTrack.FreqHigh),d		; Frequency high byte  -> trackPtr + 0Eh
	ret

.restpsg:
	; If you get here, we're doing a PSG rest
	set	1,(ix+zTrack.PlaybackControl)	; Set "track in rest" bit
	ld	a,0FFh
	ld	(ix+zTrack.FreqLow),a		; Frequency low byte = FFh
	ld	(ix+zTrack.FreqHigh),a		; Frequency hight byte = FFh
	jp	zPSGNoteOff			; Send PSG Note Off

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_487
zPSGDoNoteOn:
	bit	7,(ix+zTrack.FreqHigh)		; If track is at rest (frequency was set to FFh)...
	jr	nz,zSetRest			; jump to zSetRest
	ld	e,(ix+zTrack.FreqLow)		; Frequency low byte -> e
	ld	d,(ix+zTrack.FreqHigh)		; Frequency high byte -> d

; zloc_493
zPSGUpdateFreq:
	ld	a,(ix+zTrack.PlaybackControl)	; Get playback control byte
	and	6
	ret	nz				; If either bit 1 ("track in rest") and 2 ("SFX overriding this track"), quit!
	; This is a 16-bit sign extension of (ix+19h) -> 'hl'
    if OptimiseDriver
	ld	a,(ix+zTrack.Detune)	; Get detune value
	ld	l,a
	rla				; Carry contains sign of detune
	sbc	a,a			; a = 0 or -1 if carry is 0 or 1
	ld	h,a			; hl = sign extension of detune
    else
	ld	h,0
	ld	l,(ix+zTrack.Detune)	; hl = detune value (coord flag E9)
	bit	7,l			; Did prior value have 80h set?
	jr	z,.nosignextend		; If not, skip next step
	ld	h,0FFh			; sign extend negative value

.nosignextend:
    endif
	add	hl,de			; Alter frequency just a tad
	; This picks out the reg to write to the PSG
	ld	a,(ix+zTrack.VoiceControl)	; Get "voice control" byte...
	cp	0E0h			; Is it E0h?
	jr	nz,.notnoise		; If not, skip next step
	ld	a,0C0h			; a = C0h instead of E0h

.notnoise:
	ld	b,a			; 'a' -> 'b'
	ld	a,l			; Frequency low byte -> 'a'
	and	0Fh			; Keep only lower four bits (first PSG reg write only applies d0-d3 of freq)
	or	b			; Apply register bits
	ld	(zPSG),a		; Write it to PSG!
	ld	a,l			; Get frequency low byte -> 'a'
	srl	h			; (h >> 1); lowest bit into carry
	rra				; (a >> 1); carry from 'h' applied at end
	srl	h			; ... and so on ...
	rra
	rra
	rra				; in C, basically (hl >> 4) (except possible garbage from the rotation in upper bits)
	and	3Fh			; keep only lower 6 bits (PSG d4-d9)
	ld	(zPSG),a		; Write other frequency byte to PSG!
	ret
; ---------------------------------------------------------------------------

; zloc_4C5
zSetRest:
	set	1,(ix+zTrack.PlaybackControl)	; Set "track at rest" bit
	ret
; End of function zPSGDoNoteOn


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_4CA
zPSGUpdateVolFX:
	ld	a,(ix+zTrack.VoiceIndex)	; Get current PSG tone
	or	a				; Test if it's zero
	ret	z				; If it is, return!
	; Otherwise, fall into zPSGDoVolFX...


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_4CF
zPSGDoVolFX:
	ld	b,(ix+zTrack.Volume)		; Channel volume -> 'b'
	ld	a,(ix+zTrack.VoiceIndex)	; Current PSG tone -> 'a'
	or	a				; Test it
	jr	z,zPSGUpdateVol			; If tone is zero, jump to zPSGUpdateVol
	ld	hl,zPSG_EnvTbl			; hl points to PSG envelope table
	dec	a				; a--
	add	a,a				; a *= 2
	ld	e,a
	ld	d,0				; de = a
	add	hl,de				; Offset into pointer table...
	ld	a,(hl)				; Get low byte -> 'a'
	inc	hl				; Next byte
	ld	h,(hl)				; Get high byte into 'h'
	add	a,(ix+zTrack.VolFlutter)	; Apply PSG flutter (provides dynamic volume for special effects)
	ld	l,a
	adc	a,h
	sub	l
	ld	h,a			; Basically, hl = (hl+(ix+zTrack.VolFlutter))
	ld	a,(hl)			; Get byte from this location
	inc	(ix+zTrack.VolFlutter)	; Increment PSG flutter value
	or	a			; test byte from before
	jp	p,.gotflutter		; Is it a positive value?
	cp	80h			; Check if it's 80h (terminator to the "flutter" list)
	jr	z,zVolEnvHold		; If it is, then jump to zVolEnvHold (which just keeps at this flutter value, i.e. no more changes in volume)

.gotflutter:
	add	a,b			; Apply this "flutter" to channel volume -> 'a'
	ld	b,a			; a -> 'b'

; zloc_4F9
zPSGUpdateVol:
	ld	a,(ix+zTrack.PlaybackControl)	; get playback control byte
	and	6				; Checks bits 1 ("track at rest") and 2 ("SFX overriding this track")
	ret	nz				; If either bit is set, quit!
	bit	4,(ix+zTrack.PlaybackControl)	; Is "do not attack next note" set?
	jr	nz,zPSGCheckNoteFill		; If so, jump to zPSGCheckNoteFill

; zloc_505
zPSGSendVol:
	ld	a,b				; 'b' -> 'a'
	cp	10h				; Did the level get pushed below silence level? (i.e. a > 0Fh)
	jr	c,.abovesilence
	ld	a,0Fh				; If so, fix it!

.abovesilence:
	or	(ix+zTrack.VoiceControl)	; Apply channel info (which PSG to set!)
	or	10h				; This bit marks it as an attenuation level assignment (along with channel info just above)
	ld	(zPSG),a			; Write to PSG!!
	ret
; ---------------------------------------------------------------------------

; zloc_515
zPSGCheckNoteFill:				; If you get here, then "do not attack next note" was set...
	ld	a,(ix+zTrack.NoteFillMaster)	; Get master "note fill" value
	or	a				; test it
	jr	z,zPSGSendVol			; If it's zero, then just process normally
	ld	a,(ix+zTrack.NoteFillTimeout)	; Otherwise, get current "note fill" value
	or	a				; Test it
	jr	nz,zPSGSendVol			; If it's not zero, then just process normally
	ret
; ---------------------------------------------------------------------------
; zloc_522
zVolEnvHold:
	; This just decrements the flutter to keep it in place; no more volume changes in this list
    if FixDriverBugs
	dec	(ix+zTrack.VolFlutter)
	dec	(ix+zTrack.VolFlutter)	; Put index back (before final volume value)
	jr	zPSGDoVolFX		; Loop back and update volume
    else
	; DANGER! This effectively halts all future volume updates, breaking fades.
	dec	(ix+zTrack.VolFlutter)	; Put index back (before flag 80h)
	ret				; Return and don't update volume on this frame (!!!)
    endif
; End of function zPSGDoVolFX


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_526
zPSGNoteOff:
	bit	2,(ix+zTrack.PlaybackControl)	; Is "SFX override" bit set?
	ret	nz				; If so, quit!
	ld	a,(ix+zTrack.VoiceControl)	; Get "voice control" byte (loads upper bits which specify attenuation setting)

	;                 |a| |1Fh|
	; VOL1    0x90	= 100 1xxxx	vol 4b xxxx = attenuation value
	; VOL2    0xb0	= 101 1xxxx	vol 4b
	; VOL3    0xd0	= 110 1xxxx	vol 4b

	or	1Fh		; Attenuation Off
	ld	(zPSG),a
    if FixDriverBugs
	; Without zInitMusicPlayback forcefully muting all channels, there's the
	; risk of music accidentally playing noise because it can't detect if
	; the PSG4/noise channel needs muting, on track initialisation.
	; This bug can be heard be playing the End of Level music in CNZ, whose
	; music uses the noise channel. S&K's driver contains a fix just like this.
	cp	0DFh		; Are we stopping PSG3?
	ret	nz
	ld	a,0FFh		; If so, stop noise channel while we're at it
	ld	(zPSG),a	; Stop noise channel
    endif
	ret
; End of function zPSGNoteOff

; ---------------------------------------------------------------------------
; lookup table of FM note frequencies for instruments and sound effects
    if OptimiseDriver
	ensure1byteoffset 18h
    else
	ensure1byteoffset 0C0h
    endif
; zbyte_534
zFrequencies:
	dw 025Eh,0284h,02ABh,02D3h,02FEh,032Dh,035Ch,038Fh,03C5h,03FFh,043Ch,047Ch
    if ~~OptimiseDriver	; We will calculate these, instead, which will save space
	dw 0A5Eh,0A84h,0AABh,0AD3h,0AFEh,0B2Dh,0B5Ch,0B8Fh,0BC5h,0BFFh,0C3Ch,0C7Ch
	dw 125Eh,1284h,12ABh,12D3h,12FEh,132Dh,135Ch,138Fh,13C5h,13FFh,143Ch,147Ch
	dw 1A5Eh,1A84h,1AABh,1AD3h,1AFEh,1B2Dh,1B5Ch,1B8Fh,1BC5h,1BFFh,1C3Ch,1C7Ch
	dw 225Eh,2284h,22ABh,22D3h,22FEh,232Dh,235Ch,238Fh,23C5h,23FFh,243Ch,247Ch
	dw 2A5Eh,2A84h,2AABh,2AD3h,2AFEh,2B2Dh,2B5Ch,2B8Fh,2BC5h,2BFFh,2C3Ch,2C7Ch
	dw 325Eh,3284h,32ABh,32D3h,32FEh,332Dh,335Ch,338Fh,33C5h,33FFh,343Ch,347Ch
	dw 3A5Eh,3A84h,3AABh,3AD3h,3AFEh,3B2Dh,3B5Ch,3B8Fh,3BC5h,3BFFh,3C3Ch,3C7Ch ; 96 entries
    endif

; zloc_5F4
zPSGSilenceAll:
	ld	hl,zPSG		; PSG reg
	ld	(hl),9Fh	; Stop channel 0
	ld	(hl),0BFh	; Stop channel 1
	ld	(hl),0DFh	; Stop channel 2
	ld	(hl),0FFh	; Stop noise channel
	ret

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; zsub_600
zPauseMusic:
	jp	m,.unpause	; If we are to unpause music, jump
	ld	a,(zPaused)	; Get paused flag
	or	a		; Are we paused already?
	ret	nz		; If so, return
	ld	a,0FFh		; a = 0FFh
	ld	(zPaused),a	; Set paused flag
	call	zFMSilenceAll
	jp	zPSGSilenceAll

.unpause:
    if OptimiseDriver
	xor	a			; a = 0
	ld	(zAbsVar.StopMusic),a	; Clear pause/unpause flag
    else
	push	ix			; Save ix (nothing uses this, beyond this point...)
	ld	(ix+zVar.StopMusic),0	; Clear pause/unpause flag
	xor	a			; a = 0
    endif
	ld	(zPaused),a		; Clear paused flag
	ld	ix,zSongDACFMStart	; ix = pointer to track RAM
	ld	b,MUSIC_DAC_FM_TRACK_COUNT	; 1 DAC + 6 FM
	call	zResumeTrack

	bankswitch SoundIndex		; Now for SFX

	ld	a,0FFh			; a = 0FFH
	ld	(zDoSFXFlag),a		; Set flag to say we are updating SFX
	ld	ix,zSFX_FMStart		; ix = pointer to SFX track RAM
	ld	b,SFX_FM_TRACK_COUNT	; 3 FM
    if OptimiseDriver
	; Fall-through to zResumeTrack...
    else
	call	zResumeTrack
	; None of this is necessary...
	xor	a			; a = 0
	ld	(zDoSFXFlag),a		; Clear SFX updating flag
	call	zBankSwitchToMusic	; Back to music (Pointless: music isn't updated until the next frame)
	pop	ix			; Restore ix (nothing uses this, beyond this point...)
	ret
    endif
; End of function zPauseMusic


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; zsub_64D
zResumeTrack:
	bit	7,(ix+zTrack.PlaybackControl)	; Is track playing?
	jr	z,.nexttrack			; If not, jump
	bit	2,(ix+zTrack.PlaybackControl)	; Is SFX overriding track?
	jr	nz,.nexttrack			; If yes, jump
    if ~~OptimiseDriver
	; cfSetVoiceCont already does this
	ld	c,(ix+zTrack.AMSFMSPan)		; AMS/FMS/panning flags
	ld	a,(ix+zTrack.VoiceControl)	; Get voice control bits...
	and	3				; ... the FM portion of them
	add	a,0B4h				; Command to select AMS/FMS/panning register
	rst	zWriteFMIorII
    endif
	push	bc				; Save bc
	ld	c,(ix+zTrack.VoiceIndex)	; Current track FM instrument
	call	cfSetVoiceCont
	pop	bc				; Restore bc

.nexttrack:
	ld	de,zTrack.len		; de = Track size
	add	ix,de			; Advance to next track
	djnz	zResumeTrack		; loop
	ret
; End of function zResumeTrack


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; zsub_674
zCycleQueue:
	ld	a,(zAbsVar.QueueToPlay)		; Check if a sound request was made zComRange+08h
	cp	80h				; Is queue slot equal to 80h?
	ret	nz				; If not, return
	ld	hl,zAbsVar.Queue0		; Get address of next sound
    if OptimiseDriver
	ld	c,(ix+zVar.SFXPriorityVal)	; Get current SFX priority
    else
	ld	a,(zAbsVar.SFXPriorityVal)	; Get current SFX priority
	ld	c,a				; a -> c
    endif
	ld	b,3				; 3, for Queue0, Queue1, and Queue2

zInputLoop:
	ld	a,(hl)				; Get sound to play -> 'a'
	ld	e,a				; 'a' -> 'e'
	ld	(hl),0				; Clear it back to zero (we got it)
	inc	hl				; hl = pointer to next queue item
	cp	MusID__First			; Is it before first music?
	jr	c,zQueueNext			; If so, jump
	cp	CmdID__First			; Is it a special command?
	jr	nc,zQueueItem			; If so, jump
	sub	SndID__First			; Subtract first SFX index
	jr	c,zQueueItem			; If it was music, jump
	add	a,zSFXPriority&0FFh		; a = low byte of pointer to SFX priority
	ld	l,a				; l = low byte of pointer to SFX priority
	adc	a,(zSFXPriority&0FF00h)>>8	; a = low byte of pointer to SFX priority + high byte of same pointer
	sub	l				; a = high byte of pointer to SFX priority
	ld	h,a				; hl = pointer to SFX priority
	ld	a,(hl)				; Get SFX priority
	cp	c				; Is the new SFX of a higher priority?
	jr	c,.nextinput			; If not, jump
	ld	c,a				; Save new priority
	call	zQueueItem			; Queue the new SFX

.nextinput:
	ld	a,c				; Get back SFX priority
	or	a				; Is it negative (jumping sound)?
	ret	m				; Return if so
	ld	(zAbsVar.SFXPriorityVal),a	; Store the new priority
	ret
; ---------------------------------------------------------------------------
zQueueNext:
	djnz	zInputLoop
	ret
; ---------------------------------------------------------------------------
zQueueItem:
    if OptimiseDriver
	ld	(ix+zVar.QueueToPlay),e	; Put it as the next item to play
    else
	ld	a,e			; restore a to be the last queue item read
	ld	(zAbsVar.QueueToPlay),a	; Put it as the next item to play
    endif
	ret
; End of function zCycleQueue


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; zsub_6B2
zPlaySoundByIndex:
	or	a				; is it sound 00?
	jp	z,zClearTrackPlaybackMem	; if yes, jump to RESET EVERYTHING!!
    if MusID__First-1 = 80h
	ret	p				; return if it was (invalidates 00h-7Fh; maybe we don't want that someday?)
    else
	cp	MusID__First
	ret	c				; return if id is less than the first music id
    endif

	ld	(ix+zVar.QueueToPlay),80h	; Rewrite zComRange+8 flag so we know nothing new is coming in
	cp	MusID__End			; is it music (less than index 20)?
	jp	c,zPlayMusic			; if yes, play it
	cp	SndID__First			; is it not a sound effect? (this check is redundant if MusID__End == SndID__First...)
	ret	c				; if not, return (do nothing)
	cp	SndID__End			; is it a sound effect (less than index 71)?
	jp	c,zPlaySound_CheckRing		; if yes, play it
	cp	CmdID__First			; is it after the last regular sound but before the first special sound command (between 71 and 78)?
	ret	c				; if yes, return (do nothing)
	cp	MusID_Pause			; is it sound 7E or 7F (pause all or resume all)
	ret	nc				; if yes, return (those get handled elsewhere)
	; Otherwise, this is a special command to the music engine...
	sub	CmdID__First			; convert index 78-7D to a lookup into the following jump table
	add	a,a
	add	a,a
	ld	(.commandjump+1),a			; store into the following instruction (self-modifying code)

; zloc_6D5
.commandjump:
	jr	$
; ---------------------------------------------------------------------------
zCommandIndex:

CmdPtr_StopSFX:		jp	zStopSoundEffects ; sound test index 78
			db	0
CmdPtr_FadeOut:		jp	zFadeOutMusic ; 79
			db	0
CmdPtr_SegaSound:	jp	zPlaySegaSound ; 7A
			db	0
CmdPtr_SpeedUp:		jp	zSpeedUpMusic ; 7B
			db	0
CmdPtr_SlowDown:	jp	zSlowDownMusic ; 7C
			db	0
CmdPtr_Stop:		jp	zStopSoundAndMusic ; 7D
			db	0
CmdPtr__End:
; ---------------------------------------------------------------------------
; zloc_6EF
zPlaySegaSound:
    if FixDriverBugs
	; reset panning (don't want Sega sound playing on only one speaker)
	ld	a,0B6h		; Set Panning / AMS / FMS
	ld	c,0C0h		; default Panning / AMS / FMS settings (only stereo L/R enabled)
	rst	zWriteFMII	; Set it!
    endif

	ld	a,2Bh		; DAC enable/disable register
	ld	c,80h		; Command to enable DAC
	rst	zWriteFMI

	bankswitch Snd_Sega	; We want the Sega sound

	ld	hl,zmake68kPtr(Snd_Sega) ; was: 9E8Ch
	ld	de,(Snd_Sega_End - Snd_Sega)/2	; was: 30BAh
	ld	a,2Ah			; DAC data register
	ld	(zYM2612_A0),a		; Select it
	ld	c,80h			; If QueueToPlay is not this, stops Sega PCM

.loop:
	ld	a,(hl)				; 7	; Get next PCM byte
	ld	(zYM2612_D0),a			; 13	; Send to DAC
	inc	hl				; 6	; Advance pointer
	nop					; 4
	ld	b,pcmLoopCounter(16500)	; 7	; Sega PCM pitch
	djnz	$				; 8	; Delay loop

	nop					; 4
	ld	a,(zAbsVar.QueueToPlay)		; 13	; Get next item to play
	cp	c				; 4	; Is it 80h?
	jr	nz,.stop			; 7	; If not, stop Sega PCM
	ld	a,(hl)				; 7	; Get next PCM byte
	ld	(zYM2612_D0),a			; 13	; Send to DAC
	inc	hl				; 6	; Advance pointer
	nop					; 4
	ld	b,pcmLoopCounter(16500)	; 7	; Sega PCM pitch
	djnz	$				; 8	; Delay loop

	nop					; 4
	dec	de				; 6	; 2 less bytes to play
	ld	a,d				; 4	; a = d
	or	e				; 4	; Is de zero?
	jp	nz,.loop			; 10	; If not, loop
						; 146
	; Two samples per 146 cycles, meaning that pcmLoopCounter should used 146 divided by 2.

.stop:
	call	zBankSwitchToMusic
    if OptimiseDriver
	ld	c,(ix+zVar.DACEnabled)
    else
	ld	a,(zAbsVar.DACEnabled)	; DAC status
	ld	c,a			; c = DAC status
    endif
	ld	a,2Bh			; DAC enable/disable register
	rst	zWriteFMI
	ret
; ---------------------------------------------------------------------------
; zloc_73D
zPlayMusic:
    if ~~FixDriverBugs
	; This is a workaround for a bug, where playing a new song will distort any SFX that were already playing
	push	af
	call	zStopSoundEffects	; Stop all sounds before starting BGM
	pop	af
    endif
	ld	(zCurSong),a		; Get current BGM
	cp	MusID_ExtraLife		; If NOT 1-up sound...
	jr	nz,.bgmnot1up		; ...skip over the following code
	; The following code disables all sound (technically for duration of 1-up)
	ld	a,(zAbsVar.1upPlaying)	; Check if 1-up sound is already playing
	or	a			; Test it
	jr	nz,zBGMLoad		; If it is, then just reload it! Otherwise, the track would play over and over again...
	ld	ix,zTracksSongStart		; Starting at beginning of all tracks...
	ld	de,zTrack.len		; Each track size
	ld	b,MUSIC_TRACK_COUNT	; All 10 (DAC, 6FM, 3PSG) tracks

.clearsfxloop:
	res	2,(ix+zTrack.PlaybackControl)	; Clear "SFX is overriding" bit (no SFX are allowed!)
	add	ix,de				; Next track
	djnz	.clearsfxloop

	ld	ix,zTracksSFXStart		; 'ix' points to start of SFX track memory (10 prior tracks were DAC, 6 FM, 3 PSG)
	ld	b,SFX_TRACK_COUNT		; 6 SFX tracks total (3FM, 3PSG)

.cleartrackplayloop:
	res	7,(ix+zTrack.PlaybackControl)	; Clear "is playing" bit!  (No SFX allowed!)
	add	ix,de				; Next track
	djnz	.cleartrackplayloop

    if FixDriverBugs
	; This was in Sonic 1's driver, but this driver foolishly removed it.
	xor	a
	ld	(zAbsVar.SFXPriorityVal),a	; Clears SFX priority
    endif

	; This performs a "massive" backup of all of the current track positions
	; for restoration after 1-up BGM completes
	ld	de,zTracksSaveStart		; Backup memory address
	ld	hl,zAbsVar			; Starts from zComRange
	ld	bc,zTracksSaveEnd-zTracksSaveStart	; for this many bytes
	ldir					; Go!

	ld	a,80h
	ld	(zAbsVar.1upPlaying),a		; Set 1-up song playing flag

    if ~~FixDriverBugs
	; This is done in the wrong place: it should have been done before
	; the variables are backed-up. Because of this, SFXPriorityVal will
	; be set back to a non-zero value when the 1-up jingle is over,
	; preventing lower-priority sounds from being able to play until a
	; high-priority sound is played.
	xor	a
	ld	(zAbsVar.SFXPriorityVal),a	; Clears SFX priority
    endif

	jr	zBGMLoad			; Now load 1-up BGM
; ---------------------------------------------------------------------------

; zloc_784
.bgmnot1up:
	xor	a
	ld	(zAbsVar.1upPlaying),a		; clear 1-up is playing flag (it isn't)
	ld	(zAbsVar.FadeInCounter),a	; clear fade-in frame count
    if ~~OptimiseDriver
	; zInitMusicPlayback already does this.
	ld	(zAbsVar.FadeOutCounter),a	; clear fade-out frame count
    endif

; zloc_78E
zBGMLoad:
	call	zInitMusicPlayback
	ld	a,(zCurSong)			; So, let's take your desired song, put it into 'a'
	sub	MusID__First			; Make it a zero-based entry ...
	ld	e,a				; Transform 'a' into 16-bit de
	ld	d,0
	ld	hl,zSpedUpTempoTable		; Load 'hl' of "sped up" tempos [I think]
	add	hl,de				; Offset by 16-bit version of song index to proper tempo
	ld	a,(hl)				; Get value at this location -> 'a'
	ld	(zAbsVar.TempoTurbo),a		; Store 'a' here (provides an alternate tempo or something for speed up mode)
	ld	hl,zMasterPlaylist		; Get address of the zMasterPlaylist
	add	hl,de				; Add the 16-bit offset here
	ld	a,(hl)				; Get "fixed" index
	ld	b,a				; 'a' -> 'b'
	; The following instructions enable a bankswitch routine
	and	80h				; Get only 'bank' bit
	ld	(zAbsVar.MusicBankNumber),a	; Store this (use to enable alternate bank)
	ld	a,b				; Restore 'a'
	add	a,a				; Adding a+a causes a possible overflow and a multiplication by 2
	add	a,a				; Now multiplied by 4 and another possible overflow
	ld	c,a				; Result -> 'c'
	ccf					; Invert carry flag...
	sbc	a,a				; ... so that this sets a to FFh if bit 6 of original a was clear (allow PAL double-update), zero otherwise (do not allow PAL double-update)
	ld	(zAbsVar.IsPalFlag),a		; Set IsPalFlag
	ld	a,c				; Put prior multiply result back in
	add	a,a				; Now multiplied by 8!
	sbc	a,a				; This is FFh if bit 5 of original a was set (uncompressed song), zero otherwise (compressed song)
	push	af				; Backing up result...?
	ld	a,b				; Put 80h based index -> 'a'
	and	1Fh				; Strip the flag bits
	add	a,a				; multiply by 2; now 'a' is offset into music table, save for the $8000
	ld	e,a
	ld	d,0				; de = a
	ld	hl,zROMWindow
	add	hl,de				; "hl" now contains 2-byte offset for music address table lookup
	push	hl				; Save 'hl' (will be damaged by bank switch)
	call	zBankSwitchToMusic		; Bank switch to start of music in ROM!
	pop	hl				; Restore 'hl'
	ld	e,(hl)
	inc	hl
	ld	d,(hl)				; Getting offset within bank to music -> de

	; If we bypass the Saxman decompressor, the Z80 engine starts
	; with the assumption that we're already decompressed with 'de' pointing
	; at the decompressed data (which just so happens to be the ROM window)
	pop	af
	or	a		; Was the uncompressed song flag set?
	jr	nz,.nodecomp	; Bypass the Saxman decompressor if so

	; This begins a call to the Saxman decompressor:
	ex	de,hl
	exx
	push	hl
	push	de
	push	bc
    if ~~OptimiseDriver
	exx
    endif
	call	zSaxmanDec
	exx
	pop	bc
	pop	de
	pop	hl
	exx
	ld	de,zMusicData	; Saxman compressed songs start at zMusicData (1380h)

.nodecomp:
	; Begin common track init code
	push	de
	pop	ix				; ix = de (BGM's starting address)
	ld	e,(ix+0)			; Get voice table pointer low byte -> 'e'
	ld	d,(ix+1)			; Get voice table pointer high byte -> 'd'
	ld	(zAbsVar.VoiceTblPtr),de	; Set master copy of this value in local memory
	ld	a,(ix+5)			; Get main tempo value
	ld	(zAbsVar.TempoMod),a		; Store it at (zComRange+12h)
	ld	b,a				; tempo -> 'b'
	ld	a,(zAbsVar.SpeedUpFlag)		; Get found speed shoe flag (zComRange+14h) (preloaded before this)
	or	a				; test it
	ld	a,b				; Restore normal song tempo
	jr	z,.nospeedshoes			; if the speed shoe flag was zero, skip this step
	ld	a,(zAbsVar.TempoTurbo)		; Put the corresponding speed shoe tempo for song

.nospeedshoes:
	ld	(zAbsVar.CurrentTempo),a	; Current tempo for TempoWait
	ld	(zAbsVar.TempoTimeout),a	; Tempo accumulator for TempoWait
	ld	a,5
	ld	(zPALUpdTick),a			; reset PAL update tick to 5 (update immediately)
	push	ix
	pop	hl				; hl = ix (BGM's starting address)
	ld	de,6
	add	hl,de				; +06h (to DAC pointer)
	ld	a,(ix+2)			; Get number of FM+DAC channels this BGM has
	or	a				; Test it
	jp	z,zInitBGMPSG			; If zero, then don't init any
	ld	b,a				; 'a' -> 'b' (num FM+DAC channels this song, for loop)
	push	iy				; Save 'iy'
	ld	iy,zTracksSongStart			; 'iy' points to start of track memory
	ld	c,(ix+4)			; Get tempo divider -> 'c'
    if ~~FixDriverBugs
	; The bugfix in zInitMusicPlayback does this, already
	ld	de,zFMDACInitBytes		; 'de' points to zFMDACInitBytes
    endif

.bgm_fmloadloop:
    if FixDriverBugs
	; Enabling the 'track at rest' bit was a workaround for a bug that is no longer necessary (see zUpdateMusic)
	ld	(iy+zTrack.PlaybackControl),80h	; Set "track is playing" bit
    else
	ld	(iy+zTrack.PlaybackControl),82h	; Set "track is playing" bit and "track at rest" bit
    endif
    if ~~FixDriverBugs
	; The bugfix in zInitMusicPlayback does this, already
	ld	a,(de)				; Get current byte from zFMDACInitBytes -> 'a'
	inc	de				; will get next byte from zFMDACInitBytes next time
	ld	(iy+zTrack.VoiceControl),a			; Store this byte to "voice control" byte
    endif
	ld	(iy+zTrack.TempoDivider),c			; Store timing divisor from header for this track
	ld	(iy+zTrack.StackPointer),zTrack.GoSubStack	; set "gosub" (coord flag F8h) stack init value (starts at end of this track's memory)
	ld	(iy+zTrack.AMSFMSPan),0C0h			; default Panning / AMS / FMS settings (only stereo L/R enabled)
	ld	(iy+zTrack.DurationTimeout),1			; set current duration timeout to 1 (should expire next update, play first note, etc.)
    if ~~FixDriverBugs
	; The bugfix in zInitMusicPlayback does this, already
	push	de				; saving zFMDACInitBytes pointer
    endif
	push	bc				; saving number of channels and tempo divider ('bc' gets needlessly damaged by 'ldi' instructions coming up)
	ld	a,iyl				; current track pointer low byte -> 'a'
	add	a,zTrack.DataPointerLow
	ld	e,a
	adc	a,iyu
	sub	e
	ld	d,a			; de = iy + 3 ('de' is pointing to track offset address)
    if OptimiseDriver
	ld	bc,4
	ldir				; while (bc-- > 0) *de++ = *hl++; (copy track address, default key offset, default volume)
    else
	ldi				; *de++ = *hl++ (copy track address low byte from header to track's copy of this value)
	ldi				; *de++ = *hl++ (copy track address high byte from header to track's copy of this value)
	ldi				; *de++ = *hl++ (default key offset, typically 0, can be set later by coord flag E9)
	ldi				; *de++ = *hl++ (track default volume)
    endif
	ld	de,zTrack.len		; size of all tracks -> 'de'
	add	iy,de			; offset to next track!
	pop	bc			; restore 'bc' (number of channels and tempo divider)
    if ~~FixDriverBugs
	; The bugfix in zInitMusicPlayback does this, already
	pop	de			; restore 'de' (zFMDACInitBytes current pointer)
    endif
	djnz	.bgm_fmloadloop		; loop for all tracks we're init'ing...
	; End of FM+DAC track init loop

	pop	iy			; restore 'iy'
	ld	a,(ix+2)		; 'ix' still points to start of BGM; get number of FM+DAC -> 'a'
	cp	7			; Does it equal 7?  (6 FM channels)
	jr	nz,.silencefm6		; If not, skip this next part
	xor	a			; Clear 'a'
    if ~~OptimiseDriver
	ld	c,a			; c = 0
    endif
	jr	.writesilence		; jump to .writesilence

.silencefm6:
	; Silence FM Channel 6 specifically if it's not in use
    if ~~OptimiseDriver
	; A later call to zFMNoteOff does this, already
	ld	a,28h			; Key on/off FM register
	ld	c,6			; FM channel 6
	rst	zWriteFMI		; All operators off
    endif
    if ~~FixDriverBugs
	; The added zFMSilenceChannel does this, already
	ld	a,42h			; Starting at FM Channel 6 Operator 1 Total Level register
	ld	c,0FFh			; Silence value
	ld	b,4			; Write to all four FM Channel 6 operators

	; Set all TL values to silence!
.silencefm6loop:
	rst	zWriteFMII
	add	a,4			; Next operator
	djnz	.silencefm6loop
    endif

	; Panning isn't normally set until zSetVoice.
	; This is a problem for the DAC track since it never uses zSetVoice
	; (or at least it shouldn't), so we reset the panning here.
	ld	a,0B6h			; Set Panning / AMS / FMS
	ld	c,0C0h			; default Panning / AMS / FMS settings (only stereo L/R enabled)
	rst	zWriteFMII		; Set it!
	ld	a,80h			; FM Channel 6 is NOT in use (will enable DAC)
    if ~~OptimiseDriver
	ld	c,a			; Set this as value to be used in FM register write coming up...
    endif

; zloc_87E
.writesilence:
    if OptimiseDriver
	ld	c,a
    endif
	ld	(zAbsVar.DACEnabled),a	; Note whether FM Channel 6 is in use (enables DAC if not)
	ld	a,2Bh			; Set DAC Enable appropriately
	rst	zWriteFMI		; Set it!

	; End of DAC/FM init, begin PSG init

; zloc_884
zInitBGMPSG:
	ld	a,(ix+3)		; Get number of PSG tracks
	or	a			; Test it
	jp	z,zInitSFX		; If zero, skip this part!
	ld	b,a			; 'a' -> 'b' (num PSG tracks this song, for loop)
	push	iy			; Save 'iy'
	ld	iy,zSongPSG1		; 'iy' points to start of PSG track memory (7 prior tracks were DAC and 6 FM)
	ld	c,(ix+4)		; Get tempo divider -> 'c'
    if ~~FixDriverBugs
	; The bugfix in zInitMusicPlayback does this, already
	ld	de,zPSGInitBytes	; 'de' points to zPSGInitBytes
    endif

.bgm_psgloadloop:
    if FixDriverBugs
	; Enabling the 'track at rest' bit was a workaround for a bug that is no longer necessary (see zUpdateMusic)
	ld	(iy+zTrack.PlaybackControl),80h	; Set "track is playing" bit
    else
	ld	(iy+zTrack.PlaybackControl),82h	; Set "track is playing" bit and "track at rest" bit
    endif
    if ~~FixDriverBugs
	; The bugfix in zInitMusicPlayback does this, already
	ld	a,(de)				; Get current byte from zPSGInitBytes -> 'a'
	inc	de				; will get next byte from zPSGInitBytes next time
	ld	(iy+zTrack.VoiceControl),a	; Store this byte to "voice control" byte
    endif
	ld	(iy+zTrack.TempoDivider),c	; Store timing divisor from header for this track
	ld	(iy+zTrack.StackPointer),zTrack.GoSubStack	; "gosub" stack init value
	ld	(iy+zTrack.DurationTimeout),1	; set current duration timeout to 1 (should expire next update, play first note, etc.)
    if ~~FixDriverBugs
	; The bugfix in zInitMusicPlayback does this, already
	push	de				; saving zPSGInitBytes pointer
    endif
	push	bc				; saving number of channels and tempo divider ('bc' gets needlessly damaged by 'ldi' instructions coming up)
	ld	a,iyl				; current track pointer low byte -> 'a'
	add	a,zTrack.DataPointerLow
	ld	e,a
	adc	a,iyu
	sub	e
	ld	d,a				; de = iy + 3 ('de' is pointing to track offset address)
    if OptimiseDriver
	ld	bc,4
	ldir					; while (bc-- > 0) *de++ = *hl++; (copy track address, default key offset, default volume)
    else
	ldi					; *de++ = *hl++ (copy track address low byte from header to track's copy of this value)
	ldi					; *de++ = *hl++ (copy track address high byte from header to track's copy of this value)
	ldi					; *de++ = *hl++ (default key offset, typically 0, can be set later by coord flag E9)
	ldi					; *de++ = *hl++ (track default volume)
    endif
	inc	hl				; Get default PSG tone
	ld	a,(hl)				; -> 'a'
	inc	hl				; This byte is usually the same as the prior, unused
	ld	(iy+zTrack.VoiceIndex),a	; Store current PSG tone
	ld	de,zTrack.len			; size of all tracks -> 'de'
	add	iy,de				; offset to next track!
	pop	bc				; restore 'bc' (number of channels and tempo divider)
    if ~~FixDriverBugs
	; The bugfix in zInitMusicPlayback does this, already
	pop	de				; restore 'de' (zPSGInitBytes current pointer)
    endif
	djnz	.bgm_psgloadloop		; loop for all tracks we're init'ing...

	pop	iy				; restore 'iy'
	; End of PSG tracks init, begin SFX tracks init

; zloc_8D0
zInitSFX:
	ld	ix,zTracksSFXStart		; 'ix' points to start of SFX track memory (10 prior tracks were DAC, 6 FM, 3 PSG)
	ld	b,SFX_TRACK_COUNT		; 6 SFX tracks total (3FM, 3PSG)
	ld	de,zTrack.len			; size between tracks

; zloc_8D9
zInitSFXLoop:
	bit	7,(ix+zTrack.PlaybackControl)	; Is this track currently playing?
	jr	z,zSFXFinishSetup		; If not, jump ahead (no work to do!)
	ld	a,(ix+zTrack.VoiceControl)	; Get "voice control" byte...
	or	a				; Test it
	jp	m,.sfxpsgchannel		; If this is a PSG track, jump to .sfxpsgchannel
	sub	2				; Otherwise, subtract 2...
	add	a,a				; ... multiply by 2 (preparing to index starting from FM 3 only)
	jr	.dosetup			; Jump ahead (general track setup)

.sfxpsgchannel:
	rra
	rra
	rra
	rra
	and	0Fh			; for PSG, just shift it down by 4 and we have its index!

; zloc_8F1
.dosetup:
	add	a,zMusicTrackOffs&0FFh	; get offset into appropriate music track...
	ld	(.trackstore+1),a	; store into the following instruction (self-modifying code)

; zloc_8F6
.trackstore:
	ld	hl,(zMusicTrackOffs)	; This loads address of corresponding MUSIC track (the track that this SFX track would normally play over)
    if FixDriverBugs
	set	2,(hl)			; Set the "SFX override" bit
    else
	res	2,(hl)			; Clear the "SFX override" bit (Why??? According to S1's driver, this should be a 'set')
    endif

; zloc_8FB
zSFXFinishSetup:
	add	ix,de			; Next track..
	djnz	zInitSFXLoop		; Loop for all tracks
	; End of SFX tracks init...

	ld	ix,zSongFMStart		; 'ix' points to first FM music track
	ld	b,MUSIC_FM_TRACK_COUNT	; For all 6 of those...

.fmnoteoffloop:
    if FixDriverBugs
	; zFMNoteOff isn't enough to silence the entire channel:
	; For added measure, we set Total Level and Release Rate, too.
	push	bc
	bit	2,(ix+zTrack.PlaybackControl)	; Is bit 2 (SFX overriding) set?
	call	z,zFMSilenceChannel		; If not, jump
	add	ix,de				; Next track
	pop	bc
    else
	call	zFMNoteOff		; Send Key Off
	add	ix,de			; Next track
    endif
	djnz	.fmnoteoffloop
	
	ld	b,MUSIC_PSG_TRACK_COUNT	; For all 3 PSG tracks...

.psgnoteoffloop:
	call	zPSGNoteOff		; Send Note Off
	add	ix,de			; Next track
	djnz	.psgnoteoffloop

	ret

    if FixDriverBugs
zFMSilenceChannel:
	call	zSetMaxRelRate
	ld	a,(ix+zTrack.VoiceControl)	; Get voice control byte
	and	3				; Channels only!
	add	a,40h				; Set total level...
	ld	c,7Fh				; ... to minimum envelope amplitude...
	call	zFMOperatorWriteLoop		; ... for all operators of this track's channel
	jp	zFMNoteOff

zSetMaxRelRate:
	ld	a,(ix+zTrack.VoiceControl)	; Get voice control byte
	and	3				; Channels only!
	add	a,80h				; Add register 80, set D1L to minimum and RR to maximum...
	ld	c,0FFh				; ... for all operators on this track's channel

zFMOperatorWriteLoop:
	ld	b,4		; Loop 4 times

.loop:
	rst	zWriteFMIorII	; Write to part I or II, as appropriate
	add	a,4		; a += 4
	djnz	.loop		; Loop
	ret
    endif

; ---------------------------------------------------------------------------
; FM channel assignment bits
; zbyte_916
zFMDACInitBytes:
	db    6,   0,   1,   2,   4,   5,   6	; first byte is for DAC; then notice the 0, 1, 2 then 4, 5, 6; this is the gap between parts I and II for YM2612 port writes

; Default values for PSG tracks
; zbyte_91D
zPSGInitBytes:
	db  80h,0A0h,0C0h	; Specifically, these configure writes to the PSG port for each channel

; zloc_920
zPlaySound_CheckRing:
	ld	c,a				; Store sound index -> 'c'
	ld	a,(ix+zVar.1upPlaying)		; Get "is 1-up playing" flag...
	or	(ix+zVar.FadeInFlag)		; Or it with fading in flag
	jp	nz,zKillSFXPrio			; If either is set, SFX cannot be played!!
	xor	a
	ld	(zSpindashActiveFlag),a		; Clear spindash sound flag
	ld	a,c				; Sound index -> 'a'
	cp	SndID_Ring			; is this the ring sound?
	jr	nz,zPlaySound_CheckGloop	; if not, jump
	; This is the ring sound...
	ld	a,(zRingSpeaker)		; 0 plays left, FFh plays right
	or	a				; Test it
	jr	nz,.ringchange			; If it's not zero, we skip this next step
	ld	c,SndID_RingLeft		; do something different (probably speaker change)...

.ringchange:
	cpl					; If it was 0, it's now FFh, or vice versa
	ld	(zRingSpeaker),a		; Store new ring speaker value (other side)
	jp	zPlaySound			; now play the play the ring sound
; ---------------------------------------------------------------------------
; zloc_942:
zPlaySound_CheckGloop:
    if ~~OptimiseDriver
	ld	a,c
    endif
	cp	SndID_Gloop			; Is this the bloop/gloop noise?
	jr	nz,zPlaySound_CheckSpindash	; if not, jump
	ld	a,(zGloopFlag)
	cpl
	ld	(zGloopFlag),a
	or	a
	ret	z		; Sometimes don't play it
	jp	zPlaySound	; Now play the gloop sound
; ---------------------------------------------------------------------------
; zloc_953:
zPlaySound_CheckSpindash:
    if ~~OptimiseDriver
	ld	a,c
    endif
	cp	SndID_SpindashRev	; is this the spindash rev sound playing?
	jr	nz,zPlaySound		; if not, jump

	ld	a,(zSpindashPlayingCounter)
	or	a
	ld	a,(zSpindashExtraFrequencyIndex)
	jr	nz,.incfreq	; if the spindash sound is already playing, jump
	ld	a,-1		; reset the extra frequency (becomes 0 on the next line)

.incfreq:
	inc	a	; increase the frequency
	cp	0Ch
	jr	nc,.maxfreq
	ld	(zSpindashExtraFrequencyIndex),a

.maxfreq:
	ld	a,3Ch
	ld	(zSpindashPlayingCounter),a
	ld	a,-1
	ld	(zSpindashActiveFlag),a

; zloc_975:
zPlaySound:
	bankswitch SoundIndex			; Switch to SFX banks

	ld	hl,zmake68kPtr(SoundIndex)	; 'hl' points to beginning of SFX bank in ROM window
	ld	a,c				; 'c' -> 'a'
	sub	SndID__First			; Bring 'a' down to index value
	add	a,a				; Multiply it by 2
	ld	e,a
	ld	d,0		; de = a
	add	hl,de		; now hl points to a pointer in the SoundIndex list (such as rom_ptr_z80 Sound20)
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a		; now hl points to a sound's data (such as Sound20: ...)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)		; 'de' points to custom voice table (if any; otherwise is 0000h)
	inc	hl
	ld	(.voiceptr+1),de	; Store into the instruction after .voiceptr (self-modifying code)
	ld	c,(hl)		; Timing divisor -> 'c'
	inc	hl
	ld	b,(hl)		; Total channels used -> 'b'
	inc	hl

; zloc_99F
.sfx_loadloop:
	push	bc		; Backup divisor/channel usage
	xor	a		; a = 0 (will end up being NO CUSTOM VOICE TABLE!)
	ld	(.is_psg+1),a	; Store into the instruction after .bgmchannel (self-modifying code)
	push	hl		; Save current position within sound (offset 04h)
	inc	hl		; Next byte...

	ld	a,(hl)		; Track sound def -> 'a' (if 80h set, it's PSG, otherwise it's FM) -- note this also tells what channel it's on (80, A0, C0 for PSG, FM channel assignments otherwise)
	or	a		; Test it
	jp	m,.sfxinitpsg	; If bit 7 (80h) set (meaning PSG track), skip next part...
	sub	2		; Subtract 2 from this value
	add	a,a		; Multiply it by 2
	jp	.sfxinitfm	; This is an FM sound track...

.sfxinitpsg:
	; This is a PSG track!
	; Always ends up writing zero to voice table pointer?
	ld	(.is_psg+1),a	; Store into the instruction after .bgmchannel (self-modifying code)
	cp	0C0h		; Is this PSG3?
	jr	nz,.getindex	; If not, skip this part
	push	af
	or	1Fh		; Set silence on PSG!
	ld	(zPSG),a
	xor	20h
	ld	(zPSG),a
	pop	af

.getindex:
	rra
	rra
	rra
	rra
	and	0Fh			; For PSG, just shift it down by 4 and we have its index!

; zloc_9CA
.sfxinitfm:
	add	a,zMusicTrackOffs&0FFh		; Offset to corresponding music track
	ld	(.bgm_to_override+1),a		; Store into the instruction after .bgm_to_override (self-modifying code)

; zloc_9CF
.bgm_to_override:
	ld	hl,(zMusicTrackOffs)		; Self-modified code: 'hl' is now start of corresponding music track
	set	2,(hl)				; Set "SFX is overriding this track!" bit
	add	a,zSFXTrackOffs-zMusicTrackOffs	; Jump to corresponding SFX track
	ld	(.bgm_to_sfx+2),a		; Store into the instruction after .bgm_to_sfx (self-modifying code)

; zloc_9D9
.bgm_to_sfx:
	ld	ix,(zSFXTrackOffs)		; 'ix' is now start of corresponding SFX track

	; Little bit busy there, but basically for a given 'a' value, where a == 0
	; means first SFX track (FM3), 'hl' now points to the music track and 'ix' points
	; to the SFX track that both correspond to track 'a'

	; Now we're going to clear this SFX track...
	ld	e,ixl
	ld	d,ixu			; de = ix
	push	de			; Save 'de'
	ld	l,e			; hl = de (start of SFX track)
	ld	h,d
	ld	(hl),0			; Store 00h on first byte of track
	inc	de			; Next byte...
	ld	bc,zTrack.len-1		; For all bytes in the track, minus 1 (since we're copying 00h from first byte)
	ldir				; Clear track memory!
	pop	de			; Restore 'de' (start of SFX track yet again)
	pop	hl			; Get 'hl' back from way before (offset of sound in ROM + 04h)
;	ld	a,e
;	add	a,zTrack.PlaybackControl
;	ld	e,a
;	adc	a,d
;	sub	e
;	ld	d,a
	ldi				; *de++ = *hl++ (write playback control byte) (... not really sure why this is used)
	ldi				; *de++ = *hl++ (write voice control byte) (sets whether is PSG or what)
	pop	bc			; Restore 'bc'...
	push	bc						; ...and back it up again!
	ld	(ix+zTrack.TempoDivider),c			; Set timing divisor of SFX track
	ld	(ix+zTrack.DurationTimeout),1			; Current duration timeout to 1 (will expire immediately and thus update)
	ld	(ix+zTrack.StackPointer),zTrack.GoSubStack	; Reset track "gosub" stack
	ld	a,e
	add	a,zTrack.DataPointerLow-zTrack.TempoDivider
	ld	e,a
	adc	a,d
	sub	e
	ld	d,a	; de += 1 (skip timing divisor; already set)
    if OptimiseDriver
	ld	bc,3
	ldir		; while (bc-- > 0) *de++ = *hl++; (copy track address, default key offset)
    else
	ldi		; *de++ = *hl++ (track position low byte)
	ldi		; *de++ = *hl++ (track position high byte)
	ldi		; *de++ = *hl++ (key offset)
    endif

	; If spindash active, the following block updates its frequency specially:
	ld	a,(zSpindashActiveFlag)
	or	a
	jr	z,.notspindash				; If spindash not last sound played, skip this
	ld	a,(zSpindashExtraFrequencyIndex)	; Get current frequency index
	dec	de					; Go back to key offset
	ex	de,hl					; hl <=> de
	add	a,(hl)					; Add spindash key offset!
	ex	de,hl					; de <=> hl (just done because we wanted add a,(hl))
	ld	(de),a					; Store it!
	inc	de					; Go passed key offset again

.notspindash:
	ldi						; *de++ = *hl++ (channel volume)

; zloc_A1D
.is_psg:	; Modified way back within .sfx_loadloop
	ld	a,0				; Self-modified code
	or	a				; Test it
	jr	nz,.sfxpsginitdone		; Jump, if this is a PSG track
	; Do some more FM-related initialisation
	ld	(ix+zTrack.AMSFMSPan),0C0h	; Default panning / AMS / FMS settings (just L/R Stereo enabled)

; zloc_A26
.voiceptr:
	ld	de,0				; Self-modified code: This will be modified to custom voice table address (possibly still 0000h)
	ld	(ix+zTrack.VoicePtrLow),e	; Low byte of custom voice table (for SFX)
	ld	(ix+zTrack.VoicePtrHigh),d	; High byte of custom voice table (for SFX)

.sfxpsginitdone:
	pop	bc				; Restore divisor (c) and channel counts (b0)
	dec	b				; One less FM channel
	jp	nz,.sfx_loadloop		; If more to go, loop!

	jp	zBankSwitchToMusic		; Otherwise, prepare to do music...
; ---------------------------------------------------------------------------
; zloc_KillSFXPrio
zKillSFXPrio:
	xor	a
	ld	(zAbsVar.SFXPriorityVal),a	; Reset SFX priority
	ret
; End of function zPlaySoundByIndex


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; zsub_A3C
zStopSoundEffects:
	xor	a
	ld	(zAbsVar.SFXPriorityVal),a	; Reset SFX priority
	ld	ix,zTracksSFXStart		; 'ix' points to start of SFX track memory (10 prior tracks were DAC, 6 FM, 3 PSG)
	ld	b,SFX_TRACK_COUNT		; All 6 SFX tracks...

; zloc_A46
.trackloop:
	push	bc				; Save 'bc'
	bit	7,(ix+zTrack.PlaybackControl)	; Check if this track was playing
	jp	z,.nexttrack			; If not
	res	7,(ix+zTrack.PlaybackControl)	; You're not playing anymore!
	res	4,(ix+zTrack.PlaybackControl)	; Not not attacking, either
	ld	a,(ix+zTrack.VoiceControl)	; Get "voice control" byte
	or	a				; Test it
	jp	m,.trackpsg			; If 80h set (PSG track) jump to .trackpsg
	push	af
	call	zFMNoteOff			; FM key off
	pop	af
	push	ix
	sub	2				; Determine proper corresponding music track (starting on FM3, so subtract 2 from channel assignment)
	add	a,a				; Multiply by 2 (each index 2 bytes)
	add	a,zMusicTrackOffs&0FFh		; Get offset -> 'a'
	ld	(.fmpointer+2),a		; Store into the instruction after .fmpointer (self-modifying code)

; zloc_A6C
.fmpointer:
	ld	ix,(zMusicTrackOffs)		; Self-modified code: will load appropriate corresponding music track address
	bit	2,(ix+zTrack.PlaybackControl)	; Was this music track is overridden by an SFX track?
	jr	z,.notoverridden		; If not, do nothing
	res	2,(ix+zTrack.PlaybackControl)	; Otherwise, tell it is is no longer!
	set	1,(ix+zTrack.PlaybackControl)	; Set track to rest
	ld	a,(ix+zTrack.VoiceIndex)	; Get current voice
	call	zSetVoiceMusic			; Reset FM voice

.notoverridden:
	pop	ix
	jp	.nexttrack			; Jump down to loop
; ---------------------------------------------------------------------------

; zloc_A89
.trackpsg:
	push	af
	call	zPSGNoteOff	; PSG Note off
	pop	af
	push	ix
	rra
	rra
	rra
	rra
	and	0Fh				; 'a' is now 08, 0A, 0C, or 0E
	add	a,zMusicTrackOffs&0FFh
	ld	(.psgpointer+2),a		; Store into the instruction after .psgpointer (self-modifying code)

; zloc_A9B
.psgpointer:
	ld	ix,(zMusicTrackOffs)		; Self-modified code from just above: 'ix' points to corresponding Music PSG track
	res	2,(ix+zTrack.PlaybackControl)	; Tell this track it is is no longer overridden by SFX!
	set	1,(ix+zTrack.PlaybackControl)	; Set track to rest
	ld	a,(ix+zTrack.VoiceControl)	; Get voice control
	cp	0E0h				; Is this a PSG 3 noise (not tone) track?
	jr	nz,.nexttrackpop		; If it isn't, don't do next part (non-PSG Noise doesn't restore)
	ld	a,(ix+zTrack.PSGNoise)		; Get PSG noise setting
	ld	(zPSG),a			; Write it to PSG

.nexttrackpop:
	pop	ix

; zloc_AB6
.nexttrack:
	ld	de,zTrack.len
	add	ix,de		; Got to next track
	pop	bc		; Restore 'bc'
	djnz	.trackloop	; Loop around...
	ret
; End of function zStopSoundEffects

; ---------------------------------------------------------------------------
; zloc_ABF
zFadeOutMusic:
    if OptimiseDriver
	ld	(ix+zVar.FadeOutDelay),3	; Set delay ticker to 3
	ld	(ix+zVar.FadeOutCounter),28h	; Set total frames to decrease volume over
    else
	ld	a,3
	ld	(zAbsVar.FadeOutDelay),a	; Set delay ticker to 3
	ld	a,28h
	ld	(zAbsVar.FadeOutCounter),a	; Set total frames to decrease volume over
    endif
	xor	a
	ld	(zSongDAC.PlaybackControl),a	; Stop DAC track (can't fade it)
	ld	(zAbsVar.SpeedUpFlag),a		; No speed shoe tempo?
	ret

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_AD1
zUpdateFadeout:
	ld	a,(zAbsVar.FadeOutDelay)	; Get current tick count before next volume decrease
	or	a
	jr	z,.continuefade			; If not yet zero...
	dec	(ix+zVar.FadeOutDelay)		; Just decrement it
	ret

.continuefade:
	dec	(ix+zVar.FadeOutCounter)	; Otherwise, decrement fadeout!
	jp	z,zClearTrackPlaybackMem	; If it hits zero, clear everything!
	ld	(ix+zVar.FadeOutDelay),3	; Otherwise, reload tick count with 3
	push	ix
	ld	ix,zSongFMStart			; 'ix' points to first FM music track
	ld	b,MUSIC_FM_TRACK_COUNT		; 6 FM tracks to follow...

; zloc_AED
.fmloop:
	bit	7,(ix+zTrack.PlaybackControl)	; Is this track playing?
	jr	z,.nextfm			; If not, do nothing
	inc	(ix+zTrack.Volume)		; Increment channel volume (remember -- higher is quieter!)
	jp	p,.sendfmtl			; Don't let it overflow
	res	7,(ix+zTrack.PlaybackControl)	; Otherwise, stop playing this track
	jr	.nextfm				; Just loop

.sendfmtl:
	push	bc
	call	zSetChanVol			; We need to update volume
	pop	bc

; zloc_B04
.nextfm:
	ld	de,zTrack.len
	add	ix,de				; Next track
	djnz	.fmloop				; Keep going for all FM tracks...
	ld	b,MUSIC_PSG_TRACK_COUNT		; 3 PSG tracks to follow...

; zloc_B0D
.psgloop:
	bit	7,(ix+zTrack.PlaybackControl)	; Is this track playing?
	jr	z,.nextpsg			; If not, do nothing
	inc	(ix+zTrack.Volume)		; increment channel volume (remember -- higher is quieter!)
	ld	a,10h
	cp	(ix+zTrack.Volume)		; Don't let volume go over 0Fh on PSG tracks!
	jp	nc,.sendpsgvol
	res	7,(ix+zTrack.PlaybackControl)	; Otherwise, stop playing this track
	jr	.nextpsg

.sendpsgvol:
	push	bc
	ld	b,(ix+zTrack.Volume)		; Channel volume -> 'b'
    if FixDriverBugs
	ld	a,(ix+zTrack.VoiceIndex)
	or	a				; Is this track using volume envelope 0 (no envelope)?
	call	z,zPSGUpdateVol			; If so, update volume (this code is only run on envelope 1+, so we need to do it here for envelope 0)
    else
	; DANGER! This code ignores volume envelopes, breaking fade on envelope-using tracks.
	; (It's also a part of the envelope-processing code, so calling it here is redundant)
	; This is only useful for envelope 0 (no envelope).
	call	zPSGUpdateVol			; Update volume (ignores current envelope!!!)
    endif
	pop	bc

; zloc_B2C
.nextpsg:
	ld	de,zTrack.len
	add	ix,de		; Next track
	djnz	.psgloop	; Keep going for all PSG tracks...
	pop	ix
	ret
; End of function zUpdateFadeout


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_B36
zFMSilenceAll:
	ld	a,28h		; Start at FM KEY ON/OFF register
	ld	b,3		; Three key on/off per part

.noteoffloop:
	ld	c,b		; Current key off -> 'c
	dec	c		; c--
	rst	zWriteFMI	; Write key off for part I
	set	2,c		; Set part II select
	rst	zWriteFMI	; Write key off for part II
	djnz	.noteoffloop

	ld	a,30h		; Starting at FM register 30h...
	ld	c,0FFh		; Write dummy kill-all values
	ld	b,60h		; ...up to register 90h

.channelloop:
	rst	zWriteFMI	; ...on part I
	rst	zWriteFMII	; ...and part II
	inc	a		; Next register!
	djnz	.channelloop

	ret
; End of function zFMSilenceAll

; ---------------------------------------------------------------------------
; zloc_B4E
zStopSoundAndMusic:
	xor	a
	ld	(zAbsVar.StopMusic),a

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_B52
zClearTrackPlaybackMem:
	; This totally wipes out the track memory and resets playback hardware
	ld	a,2Bh			; DAC Enable register
	ld	c,80h			; Enable DAC
	rst	zWriteFMI		; Write it!
	ld	a,c			; 80h -> 'a'
	ld	(zAbsVar.DACEnabled),a	; Store that to DAC Enabled byte
	ld	a,27h			; Channel 3 special settings
	ld	c,0			; All clear
	rst	zWriteFMI		; Write it!
	; This performs a full clear across all track/playback memory
	ld	hl,zAbsVar
	ld	de,zAbsVar+1
	ld	(hl),0				; Starting byte is 00h
	ld	bc,(zTracksSFXEnd-zAbsVar)-1	; For 695 bytes...
	ldir					; 695 bytes of clearing! (Because it will keep copying the byte prior to the byte after; thus 00h repeatedly)
	ld	a,80h
	ld	(zAbsVar.QueueToPlay),a		; Nothing is queued
	call	zFMSilenceAll			; Silence FM
	jp	zPSGSilenceAll			; Silence PSG
; End of function zClearTrackPlaybackMem


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_B78
zInitMusicPlayback:
	; This function saves some of the queue/flag items and
	; otherwise resets all music-related playback memory and
	; silences the hardware.  Used prior to playing a new song.
	; Very similar to zClearTrackPlaybackMem except that it is
	; specific to the music tracks...

	; Save some queues/flags:
	ld	ix,zAbsVar
	ld	b,(ix+zVar.SFXPriorityVal)
	ld	c,(ix+zVar.1upPlaying)		; 1-up playing flag
	push	bc
	ld	b,(ix+zVar.SpeedUpFlag)		; Speed shoe flag
	ld	c,(ix+zVar.FadeInCounter)	; Fade in frames
	push	bc
	ld	b,(ix+zVar.Queue0)
	ld	c,(ix+zVar.Queue1)
	push	bc
    if FixDriverBugs
	; Queue2 isn't backed up! This was a bug in Sonic 1's driver as well.
	ld	b,(ix+zVar.Queue2)
	push	bc
    endif
	; The following clears all playback memory and non-SFX tracks
	ld	hl,zAbsVar
	ld	de,zAbsVar+1
	ld	(hl),0
	ld	bc,(zTracksSongEnd-zAbsVar)-1	; This many bytes (from start of zComRange to just short of end of PSG3 music track)
	ldir
	; Restore those queue/flags:
	pop	bc
	ld	(ix+zVar.Queue0),b
	ld	(ix+zVar.Queue1),c
    if FixDriverBugs
	; Ditto.
	pop	bc
	ld	(ix+zVar.Queue2),b
    endif
	pop	bc
	ld	(ix+zVar.SpeedUpFlag),b		; Speed shoe flag
	ld	(ix+zVar.FadeInCounter),c	; Fade in frames
	pop	bc
	ld	(ix+zVar.SFXPriorityVal),b
	ld	(ix+zVar.1upPlaying),c		; 1-up playing flag
    if OptimiseDriver
	ld	(ix+zVar.QueueToPlay),80h
    else
	ld	a,80h
	ld	(zAbsVar.QueueToPlay),a
    endif

    if FixDriverBugs
	; If a music file's header doesn't define each and every channel, they
	; won't be silenced by zSFXFinishSetup, because their tracks aren't properly
	; initialised. This can cause hanging notes. So, we'll set them up
	; properly here.
	ld	ix,zTracksSongStart			; Start at the first music track...
	ld	b,MUSIC_TRACK_COUNT		; ...and continue to the last
	ld	de,zTrack.len
	ld	hl,zFMDACInitBytes		; This continues into zPSGInitBytes

.loop:
	ld	a,(hl)
	inc	hl
	ld	(ix+zTrack.VoiceControl),a	; Set channel type while we're at it, so subroutines understand what the track is
	add	ix,de				; Next track
	djnz	.loop				; Loop for all channels

	ret
    else
	; This silences all channels, even those being used by SFX!
	; zSFXFinishSetup does the same thing, only better (it doesn't affect SFX channels)
	call	zFMSilenceAll
	jp	zPSGSilenceAll
    endif
; End of function zInitMusicPlayback

    if OptimiseDriver
; ---------------------------------------------------------------------------
; zloc_BBE
; increases the tempo of the music
zSpeedUpMusic:
	ld	b,80h
	ld	c,(ix+zVar.TempoTurbo)
	jr	+

; ===========================================================================
; zloc_BCB
; returns the music tempo to normal
zSlowDownMusic:
	ld	b,0
	ld	c,(ix+zVar.TempoMod)
	;jr	+
+
	ld	a,(zAbsVar.1upPlaying)
	or	a
	jr	z,+
	ld	ix,zSaveVar
+
	ld	(ix+zVar.CurrentTempo),c	; Store new tempo value
	ld	(ix+zVar.SpeedUpFlag),b
	ret
    else
; ---------------------------------------------------------------------------
; zloc_BBE
; increases the tempo of the music
zSpeedUpMusic:
	ld	b,80h
	ld	a,(zAbsVar.1upPlaying)
	or	a
	ld	a,(zAbsVar.TempoTurbo)
	jr	z,zSetTempo
	jr	zSetTempo_1up

; ===========================================================================
; zloc_BCB
; returns the music tempo to normal
zSlowDownMusic:
	ld	b,0
	ld	a,(zAbsVar.1upPlaying)
	or	a
	ld	a,(zAbsVar.TempoMod)
	jr	z,zSetTempo
	jr	zSetTempo_1up

; ===========================================================================
; helper routines for changing the tempo
zSetTempo:
	ld	(zAbsVar.CurrentTempo),a	; Store new tempo value
	ld	a,b
	ld	(zAbsVar.SpeedUpFlag),a
	ret
; ---------------------------------------------------------------------------
; zloc_BE0
zSetTempo_1up:
	ld	(zSaveVar.CurrentTempo),a	; Store new tempo value
	ld	a,b
	ld	(zSaveVar.SpeedUpFlag),a
	ret
    endif

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_BE8
zUpdateFadeIn:
	ld	a,(zAbsVar.FadeInDelay)		; Get current tick count before next volume increase
	or	a
	jr	z,.continuefade			; If not yet zero...
	dec	(ix+zVar.FadeInDelay)		; Just decrement it
	ret

.continuefade:
	ld	a,(zAbsVar.FadeInCounter)	; Get current fade out frame count
	or	a
	jr	nz,.fadenotdone			; If fadeout hasn't reached zero yet, skip this
	ld	a,(zSongDAC.PlaybackControl)	; Get DAC's playback control byte
	and	0FBh				; Clear "SFX is overriding" bit
	ld	(zSongDAC.PlaybackControl),a	; Set that
	xor	a
	ld	(zAbsVar.FadeInFlag),a		; Done fading-in, SFX can play now
	ret

.fadenotdone:
	dec	(ix+zVar.FadeInCounter)		; Otherwise, we decrement fadein!
	ld	(ix+zVar.FadeInDelay),2		; Otherwise, reload tick count with 2 (little faster than fadeout)
	push	ix
	ld	ix,zSongFMStart			; 'ix' points to first FM music track
	ld	b,MUSIC_FM_TRACK_COUNT		; 6 FM tracks to follow...

.fmloop:
	bit	7,(ix+zTrack.PlaybackControl)	; Is this track playing?
	jr	z,.nextfm			; If not, do nothing
	dec	(ix+zTrack.Volume)		; Decrement channel volume (remember -- lower is louder!)
	push	bc
	call	zSetChanVol			; We need to update volume
	pop	bc

.nextfm:
	ld	de,zTrack.len
	add	ix,de				; Next track
	djnz	.fmloop				; Keep going for all FM tracks...

	ld	b,MUSIC_PSG_TRACK_COUNT		; 3 PSG tracks to follow...

.psgloop:
	bit	7,(ix+zTrack.PlaybackControl)	; Is this track playing?
	jr	z,.nextpsg			; If not, do nothing
	dec	(ix+zTrack.Volume)		; Decrement channel volume (remember -- lower is louder!)
	push	bc
	ld	b,(ix+zTrack.Volume)		; Channel volume -> 'b'
    if FixDriverBugs
	ld	a,(ix+zTrack.VoiceIndex)
	or	a				; Is this track using volume envelope 0 (no envelope)?
	call	z,zPSGUpdateVol			; If so, update volume (this code is only run on envelope 1+, so we need to do it here for envelope 0)
    else
	; DANGER! This code ignores volume envelopes, breaking fade on envelope-using tracks.
	; (It's also a part of the envelope-processing code, so calling it here is redundant)
	; This is only useful for envelope 0 (no envelope).
	call	zPSGUpdateVol	; Update volume (ignores current envelope!!!)
    endif
	pop	bc

.nextpsg:
	ld	de,zTrack.len
	add	ix,de		; Next track
	djnz	.psgloop	; Keep going for all PSG tracks...

	pop	ix
	ret
; End of function zUpdateFadeIn


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_C46
zFMNoteOn:
	ld	a,(ix+zTrack.PlaybackControl)	; Get playback control byte
	and	6
	ret	nz				; If either bit 1 ("track in rest") and 2 ("SFX overriding this track"), quit!
	ld	a,(ix+zTrack.VoiceControl)	; Get "voice control" byte
	or	0F0h				; Turn on ALL operators
	ld	c,a				; Set as data to write to FM
	ld	a,28h				; Write to KEY ON/OFF port (key ON in this case)
	rst	zWriteFMI			; Do it!
	ret
; End of function zFMNoteOn


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_C56
zFMNoteOff:
	ld	a,(ix+zTrack.PlaybackControl)	; Load this track's playback control byte
	and	14h				; Are bits 4 (no attack) or 2 (SFX overriding) set?
	ret	nz				; If they are, return
	ld	a,28h				; Otherwise, send a KEY ON/OFF
	ld	c,(ix+zTrack.VoiceControl)	; Track's data for this key operation

	; Format of key on/off:
	; 4321 .ccc
	; Where 4321 are the bits for which operator,
	; and ccc is which channel (0-2 for channels 1-3, 4-6 for channels 4-6 WATCH BIT GAP)

	rst	zWriteFMI	; Write to part I (note this particular register is ALWAYS sent to part I)
	ret
; End of function zFMNoteOff


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Performs a bank switch to where the music for the current track is at
; (there are two possible bank locations for music)

; zsub_C63:
zBankSwitchToMusic:
	ld	a,(zAbsVar.MusicBankNumber)
	or	a
	jr	nz,zSwitchToBank2

	bankswitch MusicPoint1
	ret

zSwitchToBank2:
	bankswitch MusicPoint2
	ret
; End of function zBankSwitchToMusic

; ---------------------------------------------------------------------------

; zloc_C89
zCoordFlag:
	sub	0E0h
    if OptimiseDriver
	ld	c,a	; Multiply by 3; this lets us remove padding that was
	add	a,a	; left over from Sonic 1's sound driver, which used
	add	a,c	; 4 byte-long instructions for each entry
    else
	add	a,a	; Multiply by 4, skipping past padding
	add	a,a
    endif
	ld	(coordflagLookup+1),a	; store into the instruction after coordflagLookup (self-modifying code)
	ld	a,(hl)
	inc	hl

; This is the lookup for Coordination flag routines

; zloc_C92
coordflagLookup:
	jr	$
; ---------------------------------------------------------------------------
	jp	cfPanningAMSFMS		; E0
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfDetune		; E1
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfSetCommunication	; E2
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfJumpReturn		; E3
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfFadeInToPrevious	; E4
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfSetTempoDivider	; E5
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfChangeFMVolume	; E6
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfPreventAttack		; E7
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfNoteFill		; E8
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfChangeTransposition	; E9
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfSetTempo		; EA
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfSetTempoMod		; EB
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfChangePSGVolume	; EC
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfClearPush		; ED
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfStopSpecialFM4	; EE
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfSetVoice		; EF
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfModulation		; F0
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfEnableModulation	; F1
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfStopTrack		; F2
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfSetPSGNoise		; F3
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfDisableModulation	; F4
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfSetPSGTone		; F5
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfJumpTo		; F6
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfRepeatAtPos		; F7
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfJumpToGosub		; F8
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------
	jp	cfOpF9			; F9
    if ~~OptimiseDriver
	db	0
    endif
; ---------------------------------------------------------------------------

; (via Saxman's doc): panning, AMS, FMS
; zloc_CFC
cfPanningAMSFMS:
	;Panning, AMS, FMS
    ;* xx - Value (reg a)
    ;      o Bit 7 - Left channel status
    ;      o Bit 6 - Right channel Status
    ;      o Bit 5-3 - AMS
    ;      o Bit 2 - 0
    ;      o Bit 1-0 - FMS

	; Note that the AMS and FMS bits are saved; this command was only meant to
	; change the panning of a given channel.

	bit	7,(ix+zTrack.VoiceControl)	; Is this a PSG track?
	ret	m				; If so, quit!
    if ~~FixDriverBugs
	; This check is in the wrong place.
	; If this flag is triggered by a music track while it's being overridden
	; by an SFX, it will use the old panning when the SFX ends.
	; This is because zTrack.AMSFMSPan doesn't get updated.
	bit	2,(ix+zTrack.PlaybackControl)	; If "SFX overriding" bit set...
	ret	nz				; return
    endif
	ld	c,a				; input val 'a' -> c
	ld	a,(ix+zTrack.AMSFMSPan)		; old PAF value
	and	37h				; retains AMS and FMS bits
	or	c				; OR'd with new settings
	ld	(ix+zTrack.AMSFMSPan),a		; new PAF value
    if FixDriverBugs
	; The check should only stop hardware access, like this.
	bit	2,(ix+zTrack.PlaybackControl)	; If "SFX overriding" bit set...
	ret	nz				; return
    endif
	ld	c,a				; a -> c (YM2612 data write)
	ld	a,(ix+zTrack.VoiceControl)	; Get voice control byte
	and	3				; Channels only!
	add	a,0B4h				; Add register B4, stereo output control and LFO sensitivity
	rst	zWriteFMIorII			; Depends on bit 2 of (ix+zTrack.VoiceControl)
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): Alter note values by xx
; More or less a pitch bend; this is applied to the frequency as a signed value
; zloc_D1A cfAlterNotesUNK cfAlterNotes
cfDetune:
	ld	(ix+zTrack.Detune),a	; set new detune value
	ret
; ---------------------------------------------------------------------------

; Set otherwise unused communication byte to parameter
; Used for triggering a boss' attacks in Ristar
; zloc_D1E cfUnknown1
cfSetCommunication:
	ld	(zAbsVar.Communication),a
	ret
; ---------------------------------------------------------------------------

; Return (Sonic 1 & 2)
; zloc_D22
cfJumpReturn:
	ld	c,(ix+zTrack.StackPointer)	; Get current stack offset -> 'c'
	ld	b,0				; b = 0
	push	ix
	pop	hl				; hl = ix
	add	hl,bc				; hl += bc (latest item on "gosub" stack)
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a				; hl = address from "gosub" stack
	inc	c
	inc	c
	ld	(ix+zTrack.StackPointer),c	; add 2 to "gosub" stack offset (pop)
	ret
; ---------------------------------------------------------------------------

; Fade-in to previous song (needed on DAC channel, Sonic 1 & 2)
; zloc_D35
cfFadeInToPrevious:
	; This performs a "massive" restoration of all of the current
	; track positions as they were prior to 1-up BGM
	ld	hl,zTracksSaveStart	; Backup memory address
	ld	de,zAbsVar		; Ends at zComRange
	ld	bc,zTracksSaveEnd-zTracksSaveStart	; for this many bytes
	ldir					; Go!

	call	zBankSwitchToMusic
	ld	a,(zSongDAC.PlaybackControl)	; Get DAC's playback bit
	or	4
	ld	(zSongDAC.PlaybackControl),a	; Set "SFX is overriding" on it (not normal, but will work for this purpose)
	ld	a,(zAbsVar.FadeInCounter)	; Get current count of many frames to continue bringing volume up
	ld	c,a
	ld	a,28h
	sub	c				; a = 28h - c (don't overlap fade-ins?)
	ld	c,a				; 'a' -> 'c'
	ld	b,MUSIC_FM_TRACK_COUNT		; 6 FM tracks to follow...
	ld	ix,zSongFMStart			; 'ix' points to first FM music track

.fmloop:
	bit	7,(ix+zTrack.PlaybackControl)	; Is this track playing?
	jr	z,.nextfm			; If not, do nothing
	set	1,(ix+zTrack.PlaybackControl)	; Mark track at rest
	ld	a,(ix+zTrack.Volume)		; Get channel volume
	add	a,c				; Apply current fade value
	ld	(ix+zTrack.Volume),a		; Store it back
    if ~~OptimiseDriver
	; This bit is always cleared (see zPlayMusic)
	bit	2,(ix+zTrack.PlaybackControl)	; Is track being overridden by SFX?
	jr	nz,.nextfm			; If so, skip next part
    endif
	push	bc
	ld	a,(ix+zTrack.VoiceIndex)	; Get voice
	call	zSetVoiceMusic			; Update voice (and set volume)
	pop	bc

.nextfm:
	ld	de,zTrack.len
	add	ix,de				; Next track
	djnz	.fmloop				; Keep going for all FM tracks...

	ld	b,MUSIC_PSG_TRACK_COUNT		; 3 PSG tracks to follow...

.psgloop:
	bit	7,(ix+zTrack.PlaybackControl)	; Is this track playing?
	jr	z,.nextpsg			; If not, do nothing
	set	1,(ix+zTrack.PlaybackControl)	; Set track at rest
	call	zPSGNoteOff			; Shut off PSG
	ld	a,(ix+zTrack.Volume)		; Get channel volume
	add	a,c				; Apply current fade value
	ld	(ix+zTrack.Volume),a		; Store it back
    if FixDriverBugs
	; Restore PSG noise type
	ld	a,(ix+zTrack.VoiceControl)
	cp	0E0h				; Is this the noise channel?
	jr	nz,.nextpsg			; If not, jump
	ld	a,(ix+zTrack.PSGNoise)
	ld	(zPSG),a			; Restore Noise setting
    endif

.nextpsg:
	ld	de,zTrack.len
	add	ix,de				; Next track
	djnz	.psgloop			; Keep going for all PSG tracks...

	ld	a,80h
	ld	(zAbsVar.FadeInFlag),a		; Stop any SFX during fade-in
	ld	a,28h
	ld	(zAbsVar.FadeInCounter),a	; Fade in for 28h frames
	xor	a
	ld	(zAbsVar.1upPlaying),a		; Set to zero; 1-up ain't playin' no more
	ld	a,(zAbsVar.DACEnabled)		; DAC not yet enabled...
	ld	c,a
	ld	a,2Bh
	rst	zWriteFMI			; Tell hardware his DAC ain't enabled yet either
	pop	bc
	pop	bc
	pop	bc				; These screw with the return address to make sure DAC doesn't run any further
	jp	zUpdateDAC			; But we update DAC regardless
; ---------------------------------------------------------------------------

; Change tempo divider to xx
; zloc_DB7
cfSetTempoDivider:
	ld	(ix+zTrack.TempoDivider),a	; Set tempo divider on this track only
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): Change channel volume BY xx; xx is signed
; zloc_DBB cfSetVolume
cfChangeFMVolume:
	add	a,(ix+zTrack.Volume)	; Add to current volume
	ld	(ix+zTrack.Volume),a	; Update volume
	jp	zSetChanVol		; Immediately set this new volume
; ---------------------------------------------------------------------------

; (via Saxman's doc): prevent next note from attacking
; zloc_DC4
cfPreventAttack:
	set	4,(ix+zTrack.PlaybackControl)	; Set bit 4 (10h) on playback control; do not attack next note
	dec	hl				; Takes no argument, so just put it back
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): set note fill amount to xx
; zloc_DCA
cfNoteFill:
	ld	(ix+zTrack.NoteFillTimeout),a	; Note fill value (modifiable)
	ld	(ix+zTrack.NoteFillMaster),a	; Note fill value (master copy, rewrites +0Fh when necessary)
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): add xx to channel key
; zloc_DD1 cfAddKey
cfChangeTransposition:
	add	a,(ix+zTrack.Transpose)	; Add to current transpose value
	ld	(ix+zTrack.Transpose),a	; Store updated transpose value
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): set music tempo to xx
; zloc_DD8
cfSetTempo:
	ld	(zAbsVar.CurrentTempo),a	; Set tempo
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): Change tempo modifier to xx for ALL channels
; zloc_DDC
cfSetTempoMod:
	push	ix			; Save 'ix'
	ld	ix,zTracksSongStart		; Start at beginning of track memory
	ld	de,zTrack.len		; Track size
	ld	b,MUSIC_TRACK_COUNT	; All 10 tracks

.trackloop:
	ld	(ix+zTrack.TempoDivider),a	; Sets the timing divisor for ALL tracks; this can result in total half-speed, quarter-speed, etc.
	add	ix,de
	djnz	.trackloop

	pop	ix	; Restore 'ix'
	ret
; ---------------------------------------------------------------------------
; This controls which TL registers are set for a particular
; algorithm; it actually makes more sense to look at a zVolTLMaskTbl entry as a bitfield.
; Bit 0-4 set which TL operators are actually effected for setting a volume;
; this table helps implement the following from the Sega Tech reference:
; "To make a note softer, only change the TL of the slots (the output operators).
; Changing the other operators will affect the flavor of the note."
; zloc_DF1
	ensure1byteoffset 8
zVolTLMaskTbl:
	db	  8,  8,  8,  8
	db	0Ch,0Eh,0Eh,0Fh
; ---------------------------------------------------------------------------

; Alters a channel's volume by xx. This is only meant to be used by PSG channels. 
; zloc_DF9 cfChangeVolume
cfChangePSGVolume:
	add	a,(ix+zTrack.Volume)	; Add to channel volume
	ld	(ix+zTrack.Volume),a	; Store updated volume
	ret
; ---------------------------------------------------------------------------

; Unused command EDh
; This used to be Sonic 1's cfClearPush. The whole Push SFX feature
; was retained when the driver was ported to Z80, but eventually removed in Beta 5.
; This broken code is all that's left of it.
; zlocret_E00 cfUnused cfUnused1
cfClearPush:
    if (~~OptimiseDriver)&&(~~FixDriverBugs)
	; Dangerous!  It doesn't put back the byte read, meaning one gets skipped!
	ret
    endif
; ---------------------------------------------------------------------------

; Unused command EEh
; This used to be Sonic 1's cfStopSpecialFM4. But the Special SFX function hasn't been ported...
; zloc_E01 cfVoiceUNK cfUnused2
cfStopSpecialFM4:
	dec	hl	; Put back byte; does nothing
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): set voice selection to xx
; zloc_E03
cfSetVoice:
	ld	(ix+zTrack.VoiceIndex),a	; Set current voice
	ld	c,a				; a -> c (saving for later, if we go to cfSetVoiceCont)
	bit	2,(ix+zTrack.PlaybackControl)	; If "SFX is overriding this track" bit set...
	ret	nz				; ...return!
	push	hl				; Save 'hl'
	call	cfSetVoiceCont			; Set the new voice!
	pop	hl				; Restore 'hl'
	ret

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_E12
cfSetVoiceCont:
	ld	a,(zDoSFXFlag)			; Check SFX flag 0 = updating music, anything else means updating SFX (use custom voice table)
	or	a				; Test
	ld	a,c				; c -> a (restored 'a')
	jr	z,zSetVoiceMusic		; If not busy, jump to zSetVoiceMusic (set 'hl' to VoiceTblPtr)
	ld	l,(ix+zTrack.VoicePtrLow)	; Get low byte of custom voice table
	ld	h,(ix+zTrack.VoicePtrHigh)	; Get high byte of custom voice table
	jr	zSetVoice			; Do not set 'hl' to VoiceTblPtr
; End of function cfSetVoiceCont


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_E21
zSetVoiceMusic:
	; Set 'hl' to normal voice table pointer
	ld	hl,(zAbsVar.VoiceTblPtr)

; zloc_E24
zSetVoice:
	; This does the actual setting of the FM registers for the specific voice
	; 'a' is the voice index to set
	; 'hl' is set to the address of the voice table pointer (can be substituted, probably mainly for SFX)

    if OptimiseDriver
	or	a
	jr	z,.havevoiceptr
	ld	de,25

	ld	b,a

.voicemultiply:
	add	hl,de
	djnz	.voicemultiply

.havevoiceptr:
    else
	push	hl	; push 'hl' for the end of the following block...

	; The following is a crazy block designed to 'multiply' our target voice value by 25...
	; Where a single voice is 25 bytes long
	ld	c,a	; a -> c
	ld	b,0	; b = 0 (so only low byte of 'bc' is set, basically voice to set)
	add	a,a	; a *= 2 (indexing something...)
	ld	l,a	; low byte of 'hl' set to 'a'
	ld	h,b	; high byte = 0
	add	hl,hl	; hl *= 2
	add	hl,hl	; hl *= 2 (total hl * 4!!)
	ld	e,l
	ld	d,h	; de = hl
	add	hl,hl	; hl *= 2
	add	hl,de	; hl += de
	add	hl,bc	; hl += bc (waaah!)
	pop	de	; old 'hl' value -> 'de'
	add	hl,de	; hl += de (Adds address from the very beginning)
	; End crazy multiply-by-25 block
    endif

	; Sets up a value for future total level setting...
	ld	a,(hl)				; Get feedback/algorithm -> a
	inc	hl				; Next byte of voice...
	ld	(.a_backup+1),a			; Self-modified code: basically enables 'a' restored to its current value later
	ld	c,a				; a -> c (will be data to YM2612)
	ld	a,(ix+zTrack.VoiceControl)	; Get "voice control" byte
	and	3				; Only keep bits 0-2 (bit 2 specifies which chip to write to)
	add	a,0B0h				; Add to get appropriate feedback/algorithm register
	rst	zWriteFMIorII			; Write new value to appropriate part

	; detune/coarse freq, all channels
	sub	80h		; Subtract 80h from 'a' (Detune/coarse frequency of operator 1 register)
	ld	b,4		; Do next 4 bytes (operator 1, 2, 3, and 4)

.detuneloop:
	ld	c,(hl)		; Get next detune/coarse freq
	inc	hl		; Next voice byte
	rst	zWriteFMIorII	; Write this detune/coarse freq
	add	a,4		; Next detune/coarse freq register
	djnz	.detuneloop

	push	af		; Daving 'a' for much later... will be restored when time to "Total Level"

	; other regs up to just before "total level", all channels
	add	a,10h		; We're at 40h+, now at 50h+ (RS/AR of operator 1 register)
	ld	b,10h		; Perform 16 writes (basically goes through RS/AR, AM/D1R, D2R, D1L)

.registerloop:
	ld	c,(hl)		; Get next reg data value
	inc	hl		; Next voice byte
	rst	zWriteFMIorII	; Write to FM
	add	a,4		; Next register
	djnz	.registerloop

	; Now going to set "stereo output control and LFO sensitivity"
	add	a,24h				; Sets to reg B4h+ (stereo output control and LFO sensitivity)
	ld	c,(ix+zTrack.AMSFMSPan)		; Panning / AMS / FMS settings from track
	rst	zWriteFMIorII			; Write it!
	ld	(ix+zTrack.TLPtrLow),l		; Save current position (TL bytes begin)
	ld	(ix+zTrack.TLPtrHigh),h		; ...for updating volume correctly later later

; zloc_E65
.a_backup:
	ld	a,0				; Self-modified code: 'a' will actually be set to the feedback/algorithm byte
	and	7				; Only keeping the "algorithm" part of it
	add	a,zVolTLMaskTbl&0FFh		; Adds offset to zVolTLMaskTbl table (low byte only)
	ld	e,a				; Puts this low byte into 'e'
	ld	d,(zVolTLMaskTbl&0FF00h)>>8	; Get high byte -> 'd'
	ld	a,(de)				; Get this zVolTLMaskTbl value by algorithm
	ld	(ix+zTrack.VolTLMask),a		; Store this zVolTLMaskTbl value into (ix+1Ah)
	ld	e,a				; Store zVolTLMaskTbl value -> 'e'
	ld	d,(ix+zTrack.Volume)		; Store channel volume -> 'd'
	pop	af				; Restore 'a'; it's now back at appropriate 40h+ register for Total Level setting!

	; Set "total levels" (general volume control)
zSetFMTLs:
	ld	b,4		; Loop 4 times (for each total level register on this channel)

.loop:
	ld	c,(hl)		; Get next TL byte -> c
	inc	hl		; Next voice byte...
	rr	e		; zVolTLMaskTbl value is rotated right; if the bit 0 of this value prior to the rotate was reset (0)...
	jr	nc,.write	; ...then we make the jump here (just write the TL value directly, don't modify it)

	; Otherwise, apply channel volume to TL here
	; It's not appropriate to alter ALL TL values, only
	; the ones which are "slots" (output operators)
	push	af				; Save 'a'
    if FixDriverBugs
	set	7,c
    endif
	ld	a,d		; Channel volume -> d
	add	a,c		; Add it to the TL value
    if FixDriverBugs
	; Prevent attenuation overflow (volume underflow)
	ld	c,a
	sbc	a,a
	or	c
    endif
	ld	c,a		; Modified value -> c
	pop	af		; Restore 'a'

.write:
	rst	zWriteFMIorII	; Write TL value
	add	a,4		; Next TL reg...
	djnz	.loop

	ret
; End of function zSetVoiceMusic


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; zsub_E8A
zSetChanVol:
	bit	7,(ix+zTrack.VoiceControl)	; Is this a PSG track?
	ret	nz				; If so, quit!
	bit	2,(ix+zTrack.PlaybackControl)	; If playback control byte "SFX is overriding this track" bit set...
	ret	nz				; ...then quit!
	ld	e,(ix+zTrack.VolTLMask)		; zVolTLMaskTbl value from last voice setting (marks which specific TL operators need updating)
	ld	a,(ix+zTrack.VoiceControl)	; Load current voice control byte
	and	3				; Keep only bits 0-2
	add	a,40h				; Add 40h -- appropriate TL register
	ld	d,(ix+zTrack.Volume)		; Get channel volume
	bit	7,d				; If bit 7 (80h) is set...
	ret	nz				; ...then quit!
	push	hl				; Save 'hl'
	ld	l,(ix+zTrack.TLPtrLow)		; Low byte of where TL bytes begin (set during last voice setting)
	ld	h,(ix+zTrack.TLPtrHigh)		; High byte of where TL bytes begin (set during last voice setting)
	call	zSetFMTLs			; Set the appropriate Total Levels
	pop	hl				; Restore 'hl'
	ret
; End of function zSetChanVol

; ---------------------------------------------------------------------------

; (via Saxman's doc): F0wwxxyyzz - modulation
; o	ww - Wait for this period of time before modulation starts
; o	xx - Modulation speed
; o	yy - Modulation change per mod. step
; o	zz - Number of steps in modulation
; zloc_EB0
cfModulation:
	set	3,(ix+zTrack.PlaybackControl)	; Set bit 3 (08h) of "playback control" byte (modulation on)
	dec	hl				; Move 'hl' back one...
	ld	(ix+zTrack.ModulationPtrLow),l	; Back up modulation setting address into (ix+11h), (ix+12h)
	ld	(ix+zTrack.ModulationPtrHigh),h

; zloc_EBB
zSetModulation:
	; Sets up modulation for this track; expects 'hl' to point to modulation
	; configuration info...
	ld	a,ixl			; Get lower byte of current track address (ew :P)
	add	a,zTrack.ModulationWait	; ... and add 19 bytes to it
	ld	e,a			; put that into 'e'
	adc	a,ixu			; If carry occurred, add that to upper part of address
	sub	e			; subtract 'e'
	ld	d,a			; Basically, 'd' is now the appropriate upper byte of the address, completing de = (ix + 19)
					; Copying next three bytes
    if OptimiseDriver
	ld	bc,3
	ldir				; while (bc-- > 0) *de++ = *hl++; (wait, modulation speed, modulation change)
    else
	ldi				; *(de)++ = *(hl)++		(Wait for ww period of time before modulation starts)
	ldi				; *(de)++ = *(hl)++		(Modulation Speed)
	ldi				; *(de)++ = *(hl)++		(Modulation change per Mod. Step)
    endif
	ld	a,(hl)				; Get Number of steps in modulation
	inc	hl				; Next byte...
	srl	a				; divide number of steps by 2
	ld	(ix+zTrack.ModulationSteps),a	; Store this step count into trackPtr+16h
	bit	4,(ix+zTrack.PlaybackControl)	; Is bit 4 "do not attack next note" (10h) set?
	ret	nz				; If so, quit!
	xor	a				; Clear 'a'
	ld	(ix+zTrack.ModulationValLow),a	; Clear modulation value low byte
	ld	(ix+zTrack.ModulationValHigh),a	; Clear modulation value high byte
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): Turn on modulation
; zloc_EDE
cfEnableModulation:
	dec	hl
	set	3,(ix+zTrack.PlaybackControl)	; Playback byte bit 3 (08h) -- modulation on
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): stop the track
; zloc_EE4
cfStopTrack:
	res	7,(ix+zTrack.PlaybackControl)	; Clear playback byte bit 7 (80h) -- currently playing (not anymore)
	res	4,(ix+zTrack.PlaybackControl)	; Clear playback byte bit 4 (10h) -- do not attack
	bit	7,(ix+zTrack.VoiceControl)	; Is voice control bit 7 (80h) a PSG track set?
	jr	nz,zStopPSGTrack		; If so, skip this next part...
	ld	a,(zAbsVar.DACUpdating)		; Is DAC updating?  (FF if so)
	or	a				; test it
	jp	m,zDACStopTrack			; If DAC is updating, go here (we're in a DAC track)
	call	zFMNoteOff			; Otherwise, stop this FM track
	jr	zStoppedChannel

; zcall_zsub_526
zStopPSGTrack:
	call	zPSGNoteOff

zStoppedChannel:	; General stop track continues here...
	ld	a,(zDoSFXFlag)			; Check if we're an SFX track
	or	a				; test it
	jp	p,zStopMusicTrack		; if not, jump
	xor	a				; a = 0
	ld	(zAbsVar.SFXPriorityVal),a	; Reset SFX priority
	ld	a,(ix+zTrack.VoiceControl)	; Load "voice control" byte
	or	a				; test it..
	jp	m,zStopPSGSFXTrack		; If this is a PSG SFX track, jump
	push	ix				; save 'ix'
	; This is an FM SFX track that's trying to stop
	sub	2				; Take channel assignment - 2 (since SFX never use FM 1 or FM 2)
	add	a,a				; a *= 2 (each table entry is 2 bytes wide)
	add	a,zMusicTrackOffs&0FFh		; Get low byte value from zMusicTrackOffs
	ld	(.fmtrackoffs+2),a		; Store into the instruction after .fmtrackoffs (self-modifying code)

; zloc_F1D:
.fmtrackoffs:
	ld	ix,(zMusicTrackOffs)		; Self-modified code from just above: 'ix' points to corresponding Music FM track
	bit	2,(ix+zTrack.PlaybackControl)	; If "SFX is overriding this track" is not set...
	jp	z,zNoVoiceUpdate		; Skip this part (i.e. if SFX was not overriding this track, then nothing to restore)
	call	zBankSwitchToMusic		; Bank switch back to music track
	res	2,(ix+zTrack.PlaybackControl)	; Clear SFX is overriding this track from playback control
	set	1,(ix+zTrack.PlaybackControl)	; Set track as resting bit
	ld	a,(ix+zTrack.VoiceIndex)	; Get voice this track was using
	call	zSetVoiceMusic			; And set it! (takes care of volume too)

	bankswitch SoundIndex

zNoVoiceUpdate:
	pop	ix	; restore 'ix'
	pop	bc	; removing return address from stack; will not return to coord flag loop
	pop	bc	; removing return address from stack; will not return to zUpdateTrack function
	ret
; ---------------------------------------------------------------------------

zStopPSGSFXTrack:
	push	ix	; save 'ix'

	; Keep in mind that we just entered with a PSG "voice control" byte
	; which is one of the following values (PSG1-3/3N) -- 80h, A0h, C0h, E0h
	rra
	rra
	rra
	rra				; in effect, ">> 4"
	and	0Fh			; 'a' is now 08, 0A, 0C, or 0E
	add	a,zMusicTrackOffs&0FFh
	ld	(.psgtrackoffs+2),a	; store into the instruction after .psgtrackoffs (self-modifying code)

; zloc_F5A
.psgtrackoffs:
	ld	ix,(zMusicTrackOffs)		; Self-modified code from just above: 'ix' points to corresponding Music PSG track
	res	2,(ix+zTrack.PlaybackControl)	; Clear SFX is overriding this track from playback control
	set	1,(ix+zTrack.PlaybackControl)	; Set track as resting bit
	ld	a,(ix+zTrack.VoiceControl)	; Get voice control byte
	cp	0E0h				; Is this a PSG 3 noise (not tone) track?
	jr	nz,.exit			; If it isn't, don't do next part (non-PSG Noise doesn't restore)
	ld	a,(ix+zTrack.PSGNoise)		; Get PSG noise setting
	ld	(zPSG),a			; Write it to PSG

.exit:
	pop	ix		; restore 'ix'

; zloc_F75
zStopMusicTrack:
	pop	bc		; removing return address from stack; will not return to coord flag loop

; zloc_F76
zDACStopTrack:
	pop	bc		; removing return address from stack; will not return to zUpdateTrack function (anything other than DAC) or not to coord flag loop (if DAC)
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): Change current PSG noise to xx (For noise channel, E0-E7)
; zloc_F78
cfSetPSGNoise:
	ld	(ix+zTrack.VoiceControl),0E0h	; This is a PSG noise track now!
	ld	(ix+zTrack.PSGNoise),a		; Save PSG noise setting for restoration if SFX overrides it
	bit	2,(ix+zTrack.PlaybackControl)	; If SFX is currently overriding it, don't actually set it!
	ret	nz
	ld	(zPSG),a	; Otherwise, please do
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): Turn off modulation
; zloc_F88
cfDisableModulation:
	dec	hl				; No parameters used, must back up a byte
	res	3,(ix+zTrack.PlaybackControl)	; Clear "modulation on" bit setting
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): Change current PSG tone to xx
; zloc_F8E
cfSetPSGTone:
	ld	(ix+zTrack.VoiceIndex),a	; Set current PSG tone
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): jump to position yyyy
; zloc_F92
cfJumpTo:
	ld	h,(hl)	; Get hight byte of jump destination (since pointer advanced to it)
	ld	l,a	; Put low byte (already retrieved)
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): $F7xxyyzzzz - repeat section of music
;    * xx - loop index, for loops within loops without confusing the engine.
;          o EXAMPLE: Some notes, then a section that is looped twice, then some more notes, and finally the whole thing is looped three times.
;            The "inner" loop (the section that is looped twice) would have an xx of 01, looking something along the lines of F70102zzzz, whereas the "outside" loop (the whole thing loop) would have an xx of 00, looking something like F70003zzzz.
;    * yy - number of times to repeat
;          o NOTE: This includes the initial encounter of the F7 flag, not number of times to repeat AFTER hitting the flag.
;    * zzzz - position to loop back to
; zloc_F95
cfRepeatAtPos:
					; Loop index is in 'a'
	ld	c,(hl)			; Get next byte (number of repeats) -> 'c'
	inc	hl			; Next byte...
	push	hl			; Save 'hl'
	add	a,zTrack.LoopCounters	; Add to make loop index offset (starts at 20h in track memory)
	ld	l,a			; Set hl = offset index
	ld	h,0
	ld	e,ixl		; Set 'de' to beginning of track
	ld	d,ixu
	add	hl,de		; hl is now pointing to track memory offset for this loop
	ld	a,(hl)		; Get loop count at this address
	or	a		; Test it
	jr	nz,.loopexists	; If not zero, then skip next step (i.e. we're currently looping)
	ld	(hl),c		; Otherwise, set it to the new number of repeats

.loopexists:
	dec	(hl)		; One less loop
	pop	hl		; Restore 'hl' (now at the position)
	jr	z,.noloop	; If counted to zero, skip the rest of this (hence start loop count of 1 terminates the loop without ever looping)
	ld	a,(hl)		; Get low byte of jump address
	inc	hl		; Next byte
	ld	h,(hl)		; Get high byte of jump address -> 'h'
	ld	l,a		; Put low byte of jump address -> 'l'

	; Note then that this loop command only works AFTER the section you mean to loop
	ret

.noloop:
	; If you get here, the loop terminated; just bypass the loop jump address
	inc	hl
	inc	hl
	ret
; ---------------------------------------------------------------------------

; (via Saxman's doc): jump to position yyyy (keep previous position in memory for returning)
; zloc_FB3
cfJumpToGosub:
	ld	c,a				; a -> c
	ld	a,(ix+zTrack.StackPointer)	; Get current "stack" offset (starts at 2Ah, i.e. beginning of next track)
	sub	2				; Move back by two (we need to store a new return address)
	ld	(ix+zTrack.StackPointer),a	; Set current stack offset
	ld	b,(hl)		; Get high byte of jump position -> 'b'
	inc	hl		; Next byte...
	ex	de,hl		; hl <=> de
	add	a,ixl		; Add low byte of current track pointer to stack offset (low byte of stack location)
	ld	l,a		; Keep this in 'l'
	adc	a,ixu		; Update high byte, if necessary
	sub	l		; Fixup
	ld	h,a		; a -> 'h' (Simply, we just did hl = ix + stack_offset)
	ld	(hl),e		; Store current address low byte (just after jump) into stack
	inc	hl		; Next byte
	ld	(hl),d		; Store current address high byte (just after jump) into stack
	ld	h,b
	ld	l,c		; hl = bc (current location is where you wanted to jump to)
	ret
; ---------------------------------------------------------------------------

; Leftover from Sonic 1: was used in Spring Yard Zone's music.
; zloc_FCC
cfOpF9:
	ld	a,88h		; D1L/RR of Operator 3
	ld	c,0Fh		; Loaded with fixed value (max RR, 1TL)
	rst	zWriteFMI	; Written to part I
	ld	a,8Ch		; D1L/RR of Operator 4
	ld	c,0Fh		; Loaded with fixed value (max RR, 1TL)
	rst	zWriteFMI	; Written to part I
	dec	hl		; Doesn't take an arg, so put back one byte
	ret

; ---------------------------------------------------------------------------
; zbyte_FD8h
zSFXPriority:
	db	80h,70h,70h,70h,70h,70h,70h,70h,70h,70h,68h,70h,70h,70h,60h,70h
	db	70h,60h,70h,60h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,7Fh
	db	6Fh,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,70h,6Fh,70h,70h
	db	70h,60h,60h,70h,70h,70h,70h,70h,70h,70h,60h,62h,60h,60h,60h,70h
	db	70h,70h,70h,70h,60h,60h,60h,6Fh,70h,70h,6Fh,6Fh,70h,71h,70h,70h
	db	6Fh

; zoff_1029 zPSG_Index zPSG_FlutterTbl
zPSG_EnvTbl:
	; Basically, for any tone 0-11, dynamic volume adjustments are applied to produce a pseudo-decay,
	; or sometimes a ramp up for "soft" sounds, or really any other volume effect you might want!

	; Remember on PSG that the higher the value, the quieter it gets (it's attenuation, not volume);
	; 0 is thus loudest, and increasing values decay, until level $F (silent)

	dw	zPSG_Env1, zPSG_Env2, zPSG_Env3, zPSG_Env4
	dw	zPSG_Env5, zPSG_Env6, zPSG_Env7, zPSG_Env8
	dw	zPSG_Env9, zPSG_Env10, zPSG_Env11, zPSG_Env12
	dw	zPSG_Env13

; byte_1043
zPSG_Env1:
	db	0,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5
	db	5,5,6,6,6,7,80h

; byte_105A
zPSG_Env2:
	db	0,2,4,6,8,10h,80h

; byte_1061
zPSG_Env3:
	db	0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,80h

; byte_1072
zPSG_Env4:
	db	0,0,2,3,4,4,5,5,5,6,80h

; The next two envelopes appear in a different order than in the list above.

; byte_107D
zPSG_Env6:
	db	3,3,3,2,2,2,2,1,1,1,0,0,0,0,80h

; byte_108C
zPSG_Env5:
	db	0,0,0,0,0,0,0,0,0,0,1,1
	db	1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2
	db	2,2,2,2,3,3,3,3,3,3,3,3,4,80h

; byte_10B6
zPSG_Env7:
	db	0,0,0,0,0,0,1,1,1,1,1,2,2,2,2,2
	db	3,3,3,4,4,4,5,5,5,6,7,80h

; byte_10D2
zPSG_Env8:
	db	0,0,0,0,0,1,1,1,1,1,2,2,2,2,2,2
	db	3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,6
	db	6,6,6,6,7,7,7,80h

; byte_10FA
zPSG_Env9:
	db	0,1,2,3,4,5,6,7,8,9,0Ah,0Bh,0Ch,0Dh,0Eh,0Fh,80h

; byte_110B
zPSG_Env10:
	db	0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1
	db	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db	1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2
	db	2,2,3,3,3,3,3,3,3,3,3,3,4,80h

; byte_1149
zPSG_Env11:
	db	4,4,4,3,3,3,2,2,2,1,1,1,1,1,1,1
	db	2,2,2,2,2,3,3,3,3,3,4,80h

; byte_1165
zPSG_Env12:
	db	4,4,3,3,2,2,1,1,1,1,1,1,1,1,1,1
	db	1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2
	db	2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3
	db	3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
	db	3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db	4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5
	db	5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6
	db	6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,80h

; byte_11E5
zPSG_Env13:
	db	0Eh,0Dh,0Ch,0Bh,0Ah,9,8,7,6,5,4,3,2,1,0,80h

;	END of zPSG_EnvTbl -------------------------------

; zbyte_11F5h
zMasterPlaylist:

; Music IDs
; bank         - Which bank that the song is in.
; pal          - Whether the song should play slower on PAL consoles.
; uncompressed - Whether the song data is uncompressed or not.
; label        - The location of the song data's pointer.
music_metadata macro bank,pal,uncompressed,label
    if bank
.base = MusicPoint2
    else
.base = MusicPoint1
    endif
	db	(bank<<7)|(pal<<6)|(uncompressed<<5)|((label-.base)/2)
    endm

zMusIDPtr_2PResult:	music_metadata 1,0,0,MusPtr_2PResult
zMusIDPtr_EHZ:		music_metadata 1,0,0,MusPtr_EHZ
zMusIDPtr_MCZ_2P:	music_metadata 1,0,0,MusPtr_MCZ_2P
zMusIDPtr_OOZ:		music_metadata 1,0,0,MusPtr_OOZ
zMusIDPtr_MTZ:		music_metadata 1,0,0,MusPtr_MTZ
zMusIDPtr_HTZ:		music_metadata 1,0,0,MusPtr_HTZ
zMusIDPtr_ARZ:		music_metadata 1,0,0,MusPtr_ARZ
zMusIDPtr_CNZ_2P:	music_metadata 1,0,0,MusPtr_CNZ_2P
zMusIDPtr_CNZ:		music_metadata 1,0,0,MusPtr_CNZ
zMusIDPtr_DEZ:		music_metadata 1,0,0,MusPtr_DEZ
zMusIDPtr_MCZ:		music_metadata 1,0,0,MusPtr_MCZ
zMusIDPtr_EHZ_2P:	music_metadata 1,0,0,MusPtr_EHZ_2P
zMusIDPtr_SCZ:		music_metadata 1,0,0,MusPtr_SCZ
zMusIDPtr_CPZ:		music_metadata 1,0,0,MusPtr_CPZ
zMusIDPtr_WFZ:		music_metadata 1,0,0,MusPtr_WFZ
zMusIDPtr_HPZ:		music_metadata 1,0,0,MusPtr_HPZ
zMusIDPtr_Options:	music_metadata 1,0,0,MusPtr_Options
zMusIDPtr_SpecStage:	music_metadata 1,0,0,MusPtr_SpecStage
zMusIDPtr_Boss:		music_metadata 1,0,0,MusPtr_Boss
zMusIDPtr_EndBoss:	music_metadata 1,0,0,MusPtr_EndBoss
zMusIDPtr_Ending:	music_metadata 1,0,0,MusPtr_Ending
zMusIDPtr_SuperSonic:	music_metadata 1,0,0,MusPtr_SuperSonic
zMusIDPtr_Invincible:	music_metadata 1,0,0,MusPtr_Invincible
zMusIDPtr_ExtraLife:	music_metadata 1,0,1,MusPtr_ExtraLife
zMusIDPtr_Title:	music_metadata 1,0,0,MusPtr_Title
zMusIDPtr_EndLevel:	music_metadata 1,0,0,MusPtr_EndLevel
zMusIDPtr_GameOver:	music_metadata 1,0,1,MusPtr_GameOver
zMusIDPtr_Continue:	music_metadata 0,0,0,MusPtr_Continue
zMusIDPtr_Emerald:	music_metadata 1,0,1,MusPtr_Emerald
zMusIDPtr_Credits:	music_metadata 1,0,1,MusPtr_Credits
zMusIDPtr_Countdown:	music_metadata 1,1,0,MusPtr_Drowning
zMusIDPtr__End:

; Tempo with speed shoe tempo for each song
; zbyte_1214
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

; zDACPtr_Index zbyte_1233
zDACPtrTbl:
zDACPtr_Kick:		dw	zmake68kPtr(SndDAC_Kick)
; zbyte_1235
zDACLenTbl:
			dw	SndDAC_Kick_End-SndDAC_Kick

zDACPtr_Snare:		dw	zmake68kPtr(SndDAC_Snare)
			dw	SndDAC_Snare_End-SndDAC_Snare

zDACPtr_Clap:		dw	zmake68kPtr(SndDAC_Clap)
			dw	SndDAC_Clap_End-SndDAC_Clap

zDACPtr_Scratch:	dw	zmake68kPtr(SndDAC_Scratch)
			dw	SndDAC_Scratch_End-SndDAC_Scratch

zDACPtr_Timpani:	dw	zmake68kPtr(SndDAC_Timpani)
			dw	SndDAC_Timpani_End-SndDAC_Timpani

zDACPtr_Tom:		dw	zmake68kPtr(SndDAC_Tom)
			dw	SndDAC_Tom_End-SndDAC_Tom

zDACPtr_Bongo:		dw	zmake68kPtr(SndDAC_Bongo)
			dw	SndDAC_Bongo_End-SndDAC_Bongo

	; something else for DAC sounds
	; First byte selects one of the DAC samples. The number that
	; follows it is a wait time between each nibble written to the DAC
	; (thus higher = slower)
	ensure1byteoffset 22h
; zbyte_124F
zDACMasterPlaylist:

; DAC samples IDs
offset :=	zDACPtrTbl
ptrsize :=	2+2
idstart :=	81h

dac_sample_metadata macro label,sampleRate
	db	id(label),dpcmLoopCounter(sampleRate)
    endm

	dac_sample_metadata zDACPtr_Kick,    8250	; 81h
	dac_sample_metadata zDACPtr_Snare,  24000	; 82h
	dac_sample_metadata zDACPtr_Clap,   17000	; 83h
	dac_sample_metadata zDACPtr_Scratch,15000	; 84h
	dac_sample_metadata zDACPtr_Timpani, 7500	; 85h
	dac_sample_metadata zDACPtr_Tom,    14000	; 86h
	dac_sample_metadata zDACPtr_Bongo,   7500	; 87h
	dac_sample_metadata zDACPtr_Timpani, 9750	; 88h
	dac_sample_metadata zDACPtr_Timpani, 8750	; 89h
	dac_sample_metadata zDACPtr_Timpani, 7250	; 8Ah
	dac_sample_metadata zDACPtr_Timpani, 7000	; 8Bh
	dac_sample_metadata zDACPtr_Tom,    23000	; 8Ch
	dac_sample_metadata zDACPtr_Tom,    18000	; 8Dh
	dac_sample_metadata zDACPtr_Tom,    15000	; 8Eh
	dac_sample_metadata zDACPtr_Bongo,  15000	; 8Fh
	dac_sample_metadata zDACPtr_Bongo,  13000	; 90h
	dac_sample_metadata zDACPtr_Bongo,   9750	; 91h

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; zsub_1271
zSaxmanDec:
    if OptimiseDriver
	xor	a
	ld	b,a
	ld	d,a
	ld	e,a
    else
	exx
	ld	bc,0
	ld	de,0
    endif
	exx
	ld	de,zMusicData
	ld	c,(hl)
	inc	hl
	ld	b,(hl)			; bc = (hl) i.e. "size of song"
	inc	hl
	ld	(zGetNextByte+1),hl	; modify inst. @ zGetNextByte -- set to beginning of decompression stream
    if ~~OptimiseDriver
	inc	bc
    endif
	ld	(zDecEndOrGetByte+1),bc	; modify inst. @ zDecEndOrGetByte -- set to length of song, +1

; zloc_1288
zSaxmanReadLoop:
	exx				; shadow reg set
    if OptimiseDriver
	srl	b			; b >> 1 (just a mask that lets us know when we need to reload)
	jr	c,.skip_fetching_descriptor	; if next bit of 'b' is set, we still have bits left in 'c', so continue
	; If you get here, we're out of bits in 'c'!
	call	zDecEndOrGetByte	; get next byte -> 'a'
	ld	c,a			; a -> 'c'
	ld	b,7Fh			; b = 7Fh (7 new bits in 'c')

.skip_fetching_descriptor:
	srl	c			; test next bit of 'c'
	exx				; normal reg set
	jr	nc,.is_dictionary_reference	; if bit not set, it's a compression bit; jump accordingly
    else
	srl	c			; c >> 1 (active control byte)
	srl	b			; b >> 1 (just a mask that lets us know when we need to reload)
	bit	0,b			; test next bit of 'b'
	jr	nz,.skip_fetching_descriptor	; if it's set, we still have bits left in 'c', so continue
	; If you get here, we're out of bits in 'c'!
	call	zDecEndOrGetByte	; get next byte -> 'a'
	ld	c,a			; a -> 'c'
	ld	b,0FFh			; b = FFh (8 new bits in 'c')

.skip_fetching_descriptor:
	bit	0,c			; test next bit of 'c'
	exx				; normal reg set
	jr	z,.is_dictionary_reference	; if bit not set, it's a compression bit; jump accordingly
    endif
	; If you get here, there's a non-compressed byte
	call	zDecEndOrGetByte	; get next byte -> 'a'
	ld	(de),a			; store it directly to the target memory address
	inc	de			; de++
	exx				; shadow reg set
	inc	de			; Also increase shadow-side 'de'... relative pointer only, does not point to output Z80_RAM
	exx				; normal reg set
	jr	zSaxmanReadLoop		; loop back around...

.is_dictionary_reference:
	call	zDecEndOrGetByte	; get next byte -> 'a'
	ld	c,a			; a -> 'c' (low byte of target address)
	call	zDecEndOrGetByte	; get next byte -> 'a'
	ld	b,a			; a -> 'b' (high byte of target address + count)
	and	0Fh			; keep only lower four bits...
	add	a,3			; add 3 (minimum 3 bytes are to be read in this mode)
	push	af			; save 'a'...
	ld	a,b			; b -> 'a' (low byte of target address)
	rlca
	rlca
	rlca
	rlca
	and	0Fh			; basically (b >> 4) & 0xF (upper four bits now exclusively as lower four bits)
	ld	b,a			; a -> 'b' (only upper four bits of value make up part of the address)
	ld	a,c
	add	a,12h
	ld	c,a
	adc	a,b
	sub	c
	and	0Fh
	ld	b,a			; bc += 12h
	pop	af			; restore 'a' (byte count to read; no less than 3)
	exx				; shadow reg set
	push	de			; keep current 'de' (relative pointer) value...
	ld	l,a			; how many bytes we will read -> 'hl'
	ld	h,0
	add	hl,de			; add current relative pointer...
	ex	de,hl			; effectively, de += a
	exx				; normal reg set
	pop	hl			; shadow 'de' -> 'hl' (relative pointer, prior to all bytes read, relative)
	or	a			; Clear carry
	sbc	hl,bc			; hl -= bc
	jr	nc,.is_not_zero_fill	; if result positive, jump ahead
	ex	de,hl			; current output pointer -> 'hl'
	ld	b,a			; how many bytes to load -> 'b'

.fill_zero_loop:
	ld	(hl),0			; fill in zeroes that many times
	inc	hl
	djnz	.fill_zero_loop

	ex	de,hl			; output pointer updated
	jr	zSaxmanReadLoop		; loop back around...

.is_not_zero_fill:
	ld	hl,zMusicData		; point at beginning of decompression point
	add	hl,bc			; move ahead however many bytes
	ld	c,a
	ld	b,0
	ldir
	jr	zSaxmanReadLoop
; End of function zSaxmanDec


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; This is an ugly countdown to zero implemented in repeatedly modifying code!!
; But basically, it starts at the full length of the song +1 (so it can decrement)
; and waits until 'hl' decrements to zero
; zsub_12E8
zDecEndOrGetByte:
	ld	hl,0			; Self-modified code: starts at full length of song +1, waits until it gets to 1...
    if OptimiseDriver
	ld	a,h
	or	l
	jr	z,zDecEnd		; If 'h' and 'l' both equal zero, we quit!!
    endif
	dec	hl			; ...where this will be zero
	ld	(zDecEndOrGetByte+1),hl	; Self-modified code: update the count in case it's not zero
    if ~~OptimiseDriver
	ld	a,h
	or	l
	jr	z,zDecEnd		; If 'h' and 'l' both equal zero, we quit!!
    endif

; zloc_12F3
zGetNextByte:
	ld	hl,0			; Self-modified code: get address of next compressed byte
	ld	a,(hl)			; put it into -> 'a'
	inc	hl			; next byte...
	ld	(zGetNextByte+1),hl	; change inst @ zGetNextByte so it loads next compressed byte
	ret				; still going...

; zloc_12FC
zDecEnd:
	pop	hl			; throws away return address to this function call so that next 'ret' exits decompressor (we're done!)
	ret				; Exit decompressor
; End of function zDecEndOrGetByte

; ---------------------------------------------------------------------------
	; space for a few global variables

zPALUpdTick:	db 0 ; zbyte_12FE ; This counts from 0 to 5 to periodically "double update" for PAL systems (basically every 6 frames you need to update twice to keep up)
zCurDAC:	db 0 ; zbyte_12FF ; seems to indicate DAC sample playing status
zCurSong:	db 0 ; zbyte_1300 ; currently playing song index
zDoSFXFlag:	db 0 ; zbyte_1301 ; flag to indicate we're updating SFX (and thus use custom voice table); set to anything but 0 while doing SFX, 0 when not.
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
