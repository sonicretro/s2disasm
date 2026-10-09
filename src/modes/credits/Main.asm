MapEng_EndGameLogo:	BINCLUDE	"mappings/misc/Sonic 2 end of game logo.eni"
	even

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_B262
ShowCreditsScreen:
	lea	off_B2CA(pc),a1
	move.w	(CreditsScreenIndex).w,d0
	lsl.w	#2,d0
	move.l	(a1,d0.w),d0
	movea.l	d0,a1

loc_B272:
	move	#$2700,sr
	lea	(VDP_data_port).l,a6
-
	move.l	(a1)+,d0
	bmi.s	++
	movea.l	d0,a2
	move.w	(a1)+,d0
	bsr.s	sub_B29E
	move.l	d0,4(a6)
	move.b	(a2)+,d0
	lsl.w	#8,d0
-
	move.b	(a2)+,d0
	bmi.s	+
	move.w	d0,(a6)
	bra.s	-
; ===========================================================================
+	bra.s	--
; ===========================================================================
+
	move	#$2300,sr
	rts
; End of function ShowCreditsScreen


; ---------------------------------------------------------------------------
; Subroutine to convert a VRAM address into a 32-bit VRAM write command word
; Input:
;	d0	VRAM address (word)
; Output:
;	d0	32-bit VDP command word for a VRAM write to specified address.
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_B29E:
	andi.l	#$FFFF,d0
	lsl.l	#2,d0
	lsr.w	#2,d0
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d0
	swap	d0
	rts
; End of function sub_B29E

	include "src/modes/credits/Text.asm"

; -------------------------------------------------------------------------------
; Nemesis compressed art
; 64 blocks
; Standard font used in credits
; -------------------------------------------------------------------------------
; ArtNem_BD26:
ArtNem_CreditText:	BINCLUDE	"art/nemesis/Credit Text.nem"
	even
; ===========================================================================

	jmpTos JmpTo5_DisplaySprite,JmpTo3_DeleteObject,JmpTo2_PlaySound,JmpTo_ObjB2_Animate_Pilot,JmpTo_AnimateSprite,JmpTo_NemDec,JmpTo_EniDec,JmpTo_ClearScreen,JmpTo2_PlayMusic,JmpTo_LoadChildObject,JmpTo2_PlaneMapToVRAM_H40,JmpTo2_ObjectMove,JmpTo_PalCycle_Load,JmpTo_LoadSubObject_Part3
