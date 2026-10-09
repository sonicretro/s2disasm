; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_ABBA:
	subq.w	#1,objoff_30(a0)
	bpl.s	+	; rts
	tst.b	objoff_35(a0)
	beq.s	+	; rts
	subq.b	#1,objoff_35(a0)
	move.l	(RNG_seed).w,d0
	andi.w	#$F,d0
	move.w	d0,objoff_30(a0)
	lea	(ChildObject_AD66).l,a2
	jsrto	JmpTo_LoadChildObject
+	rts
; End of function sub_ABBA


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_ABE2:
EndingSequence_LoadCharacterArt:
	move.w	(Ending_Routine).w,d0
	move.w	EndingSequence_LoadCharacterArt_Characters(pc,d0.w),d0
	jmp	EndingSequence_LoadCharacterArt_Characters(pc,d0.w)
; End of function EndingSequence_LoadCharacterArt

; ===========================================================================
EndingSequence_LoadCharacterArt_Characters: offsetTable
	offsetTableEntry.w EndingSequence_LoadCharacterArt_Sonic	; 0
	offsetTableEntry.w EndingSequence_LoadCharacterArt_SuperSonic	; 2
	offsetTableEntry.w EndingSequence_LoadCharacterArt_Tails	; 4
; ===========================================================================
; loc_ABF4:
EndingSequence_LoadCharacterArt_Sonic:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_EndingCharacter),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingSonic).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
; loc_AC08:
EndingSequence_LoadCharacterArt_SuperSonic:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_EndingCharacter),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingSuperSonic).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
; loc_AC1C:
EndingSequence_LoadCharacterArt_Tails:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_EndingCharacter),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_EndingTails).l,a0
	jmpto	JmpTo_NemDec

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


; sub_AC30:
EndingSequence_LoadFlickyArt:
	move.w	(Ending_Routine).w,d0
	move.w	EndingSequence_LoadFlickyArt_Flickies(pc,d0.w),d0
	jmp	EndingSequence_LoadFlickyArt_Flickies(pc,d0.w)
; End of function EndingSequence_LoadFlickyArt

; ===========================================================================
EndingSequence_LoadFlickyArt_Flickies: offsetTable
	offsetTableEntry.w EndingSequence_LoadFlickyArt_Flicky	; 0
	offsetTableEntry.w EndingSequence_LoadFlickyArt_Eagle	; 2
	offsetTableEntry.w EndingSequence_LoadFlickyArt_Chicken	; 4
; ===========================================================================
; loc_AC42:
EndingSequence_LoadFlickyArt_Flicky:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Animal_2),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Flicky).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
; loc_AC56:
EndingSequence_LoadFlickyArt_Eagle:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Animal_2),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Eagle).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
; loc_AC6A:
EndingSequence_LoadFlickyArt_Chicken:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_Animal_2),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_Chicken).l,a0
	jmpto	JmpTo_NemDec
; ===========================================================================
Pal_AC7E:	BINCLUDE	"art/palettes/Ending Sonic.bin"
Pal_AC9E:	BINCLUDE	"art/palettes/Ending Tails.bin"
Pal_ACDE:	BINCLUDE	"art/palettes/Ending Background.bin"
Pal_AD1E:	BINCLUDE	"art/palettes/Ending Photos.bin"
Pal_AD3E:	BINCLUDE	"art/palettes/Ending Super Sonic.bin"

ChildObject_AD5E:	childObjectData objoff_3E, ObjID_EndingSeqClouds, $00
ChildObject_AD62:	childObjectData objoff_3E, ObjID_EndingSeqTrigger, $00
ChildObject_AD66:	childObjectData objoff_3E, ObjID_EndingSeqBird, $00
ChildObject_AD6A:	childObjectData objoff_3E, ObjID_EndingSeqSonic, $00
ChildObject_AD6E:	childObjectData objoff_3E, ObjID_TornadoHelixes, $00

; off_AD72:
ObjCD_SubObjData:
    if fixBugs
	subObjData Obj28_MapUnc_11E1C,make_art_tile(ArtTile_ArtNem_Animal_2,0,0),1<<render_flags.level_fg,1,8,0
    else
	; This should use priority 1, not 2. As-is, it causes the birds to
	; overlap the Tornado but appear behind Sonic.
	subObjData Obj28_MapUnc_11E1C,make_art_tile(ArtTile_ArtNem_Animal_2,0,0),1<<render_flags.level_fg,2,8,0
    endif
	include "src/anim/Ending Birds.asm"
	include "src/anim/Ending Propeller.asm"

; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjCF_MapUnc_ADA2:	include "mappings/sprite/objCF.asm"
; --------------------------------------------------------------------------------------
; Enigma compressed art mappings
; "Sonic the Hedgehog 2" mappings		; MapEng_B23A:
	even
