; loc_9746:
CheckCheats:	; This is called from 2 places: the options screen and the level select screen
	move.w	(Correct_cheat_entries).w,d0	; Get the number of correct sound IDs entered so far
	adda.w	d0,a0				; Skip to the next entry
	move.w	(Sound_test_sound).w,d0		; Get the current sound test sound
	cmp.b	(a0),d0				; Compare it to the cheat
	bne.s	+				; If they're different, branch
	addq.w	#1,(Correct_cheat_entries).w	; Add 1 to the number of correct entries
	tst.b	1(a0)				; Is the next entry 0?
	bne.s	++				; If not, branch
	move.w	#$101,(a1)			; Enable the cheat
	move.b	#SndID_Ring,d0			; Play the ring sound
	jsrto	JmpTo_PlaySound
+
	move.w	#0,(Correct_cheat_entries).w	; Clear the number of correct entries
+
	move.w	(Correct_cheat_entries_2).w,d0	; Do the same procedure with the other cheat
	adda.w	d0,a2
	move.w	(Sound_test_sound).w,d0
	cmp.b	(a2),d0
	bne.s	++
	addq.w	#1,(Correct_cheat_entries_2).w
	tst.b	1(a2)
	bne.s	+++	; rts
	tst.w	d2				; Test this to determine which cheat to enable
	bne.s	+				; If not 0, branch
	move.b	#$F,(Continue_count).w		; Give 15 continues
    if fixBugs
	; Fun fact: this was fixed in the version of Sonic 2 included in
	; Sonic Mega Collection.
	move.b	#SndID_ContinueJingle,d0	; Play the continue jingle
    else
	; The next line causes the bug where the OOZ music plays until reset.
	; Remove "&$7F" to fix the bug.
	move.b	#SndID_ContinueJingle&$7F,d0	; Play the continue jingle
    endif
	jsrto	JmpTo_PlayMusic
	bra.s	++
; ===========================================================================
+
	move.w	#7,(Got_Emerald).w		; Give 7 emeralds to the player
	move.b	#MusID_Emerald,d0		; Play the emerald jingle
	jsrto	JmpTo_PlayMusic
+
	move.w	#0,(Correct_cheat_entries_2).w	; Clear the number of correct entries
+
	rts
; ===========================================================================
level_select_cheat:
	; 17th September 1965, the birthdate of one of Sonic 2's developers,
	; Yuji Naka.
	dc.b $19, $65,   9, $17,   0
	rev02even
; byte_97B7
continues_cheat:
	; November 24th, which was Sonic 2's release date in the EU and US.
	dc.b   1,   1,   2,   4,   0
	rev02even
debug_cheat:
	; 24th November 1992 (also known as "Sonic 2sday"), which was
	; Sonic 2's release date in the EU and US.
	dc.b   1,   9,   9,   2,   1,   1,   2,   4,   0
	rev02even
; byte_97C5
super_sonic_cheat:
	; Book of Genesis, 41:26, which makes frequent reference to the
	; number 7. 7 happens to be the number of Chaos Emeralds.
	; The Mega Drive is known as the Genesis in the US.
	dc.b   4,   1,   2,   6,   0
	rev02even

	; set the character set for menu text
	charset '@',"\27\30\31\32\33\34\35\36\37\38\39\40\41\42\43\44\45\46\47\48\49\50\51\52\53\54\55"
	charset '0',"\16\17\18\19\20\21\22\23\24\25"
	charset '*',$1A
	charset ':',$1C
	charset '.',$1D
	charset ' ',0

	; options screen menu text

TextOptScr_PlayerSelect:	menutxt	"* PLAYER SELECT *"	; byte_97CA:
TextOptScr_SonicAndMiles:	menutxt	"SONIC AND MILES"	; byte_97DC:
TextOptScr_SonicAndTails:	menutxt	"SONIC AND TAILS"	; byte_97EC:
TextOptScr_SonicAlone:		menutxt	"SONIC ALONE    "	; byte_97FC:
TextOptScr_MilesAlone:		menutxt	"MILES ALONE    "	; byte_980C:
TextOptScr_TailsAlone:		menutxt	"TAILS ALONE    "	; byte_981C:
TextOptScr_VsModeItems:		menutxt	"* VS MODE ITEMS *"	; byte_982C:
TextOptScr_AllKindsItems:	menutxt	"ALL KINDS ITEMS"	; byte_983E:
TextOptScr_TeleportOnly:	menutxt	"TELEPORT ONLY  "	; byte_984E:
TextOptScr_SoundTest:		menutxt	"*  SOUND TEST   *"	; byte_985E:
TextOptScr_0:			menutxt	"      00       "	; byte_9870:

	charset ; reset character set

; level select picture palettes
; byte_9880:
Pal_LevelIcons:	BINCLUDE "art/palettes/Level Select Icons.bin"

; 2-player level select screen mappings (Enigma compressed)
; byte_9A60:
	even
MapEng_LevSel2P:	BINCLUDE "mappings/misc/Level Select 2P.eni"

; options screen mappings (Enigma compressed)
; byte_9AB2:
	even
MapEng_Options:	BINCLUDE "mappings/misc/Options Screen.eni"

; level select screen mappings (Enigma compressed)
; byte_9ADE:
	even
MapEng_LevSel:	BINCLUDE "mappings/misc/Level Select.eni"

; 1P and 2P level select icon mappings (Enigma compressed)
; byte_9C32:
	even
MapEng_LevSelIcon:	BINCLUDE "mappings/misc/Level Select Icons.eni"
	even

	jmpTos JmpTo_PlaySound,JmpTo_PlayMusic,JmpTo_PlaneMapToVRAM_H40,JmpTo2_Dynamic_Normal




; ===========================================================================
