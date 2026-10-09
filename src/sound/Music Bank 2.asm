; ------------------------------------------------------------------------------
; Music pointers
; ------------------------------------------------------------------------------
; loc_F8000:
MusicPoint2:	startBank
		music_ptr	Mus_CNZ_2P
		music_ptr	Mus_EHZ
		music_ptr	Mus_MTZ
		music_ptr	Mus_CNZ
		music_ptr	Mus_MCZ
		music_ptr	Mus_MCZ_2P
		music_ptr	Mus_ARZ
		music_ptr	Mus_DEZ
		music_ptr	Mus_SpecStage
		music_ptr	Mus_Options
		music_ptr	Mus_Ending
		music_ptr	Mus_EndBoss
		music_ptr	Mus_CPZ
		music_ptr	Mus_Boss
		music_ptr	Mus_SCZ
		music_ptr	Mus_OOZ
		music_ptr	Mus_WFZ
		music_ptr	Mus_EHZ_2P
		music_ptr	Mus_2PResult
		music_ptr	Mus_SuperSonic
		music_ptr	Mus_HTZ
		music_ptr	Mus_ExtraLife
		music_ptr	Mus_Title
		music_ptr	Mus_EndLevel
		music_ptr	Mus_GameOver
		music_ptr	Mus_Invincible
		music_ptr	Mus_Emerald
		music_ptr	Mus_HPZ
		music_ptr	Mus_Drowning
		music_ptr	Mus_Credits

; loc_F803C:
Mus_HPZ:	include	"sound/music/generated/90 - HPZ.inc"
Mus_Drowning:	include	"sound/music/generated/9F - Drowning.inc"
Mus_Invincible:	include	"sound/music/generated/97 - Invincible.inc"
Mus_CNZ_2P:	include	"sound/music/generated/88 - CNZ 2P.inc"
Mus_EHZ:	include	"sound/music/generated/82 - EHZ.inc"
Mus_MTZ:	include	"sound/music/generated/85 - MTZ.inc"
Mus_CNZ:	include	"sound/music/generated/89 - CNZ.inc"
Mus_MCZ:	include	"sound/music/generated/8B - MCZ.inc"
Mus_MCZ_2P:	include	"sound/music/generated/83 - MCZ 2P.inc"
Mus_ARZ:	include	"sound/music/generated/87 - ARZ.inc"
Mus_DEZ:	include	"sound/music/generated/8A - DEZ.inc"
Mus_SpecStage:	include	"sound/music/generated/92 - Special Stage.inc"
Mus_Options:	include	"sound/music/generated/91 - Options.inc"
Mus_Ending:	include	"sound/music/generated/95 - Ending.inc"
Mus_EndBoss:	include	"sound/music/generated/94 - Final Boss.inc"
Mus_CPZ:	include	"sound/music/generated/8E - CPZ.inc"
Mus_Boss:	include	"sound/music/generated/93 - Boss.inc"
Mus_SCZ:	include	"sound/music/generated/8D - SCZ.inc"
Mus_OOZ:	include	"sound/music/generated/84 - OOZ.inc"
Mus_WFZ:	include	"sound/music/generated/8F - WFZ.inc"
Mus_EHZ_2P:	include	"sound/music/generated/8C - EHZ 2P.inc"
Mus_2PResult:	include	"sound/music/generated/81 - 2 Player Menu.inc"
Mus_SuperSonic:	include	"sound/music/generated/96 - Super Sonic.inc"
Mus_HTZ:	include	"sound/music/generated/86 - HTZ.inc"
Mus_Title:	include	"sound/music/generated/99 - Title Screen.inc"
Mus_EndLevel:	include	"sound/music/generated/9A - End of Act.inc"
Mus_ExtraLife:	include	"sound/music/generated/98 - Extra Life.inc"
Mus_GameOver:	include	"sound/music/generated/9B - Game Over.inc"
Mus_Emerald:	include	"sound/music/generated/9D - Got Emerald.inc"
Mus_Credits:	include	"sound/music/generated/9E - Credits.inc"
