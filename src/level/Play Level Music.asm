; loc_F626:
PlayLevelMusic:
	move.w	(Level_Music).w,d0
	jmpto	JmpTo3_PlayMusic
; ===========================================================================

; loc_F62E:
LoadPLC_AnimalExplosion:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	lea	(Animal_PLCTable).l,a2
	move.b	(a2,d0.w),d0
	jsrto	JmpTo2_LoadPLC
	moveq	#PLCID_Explosion,d0
	jsrto	JmpTo2_LoadPLC
	rts
; ===========================================================================

	jmpTos JmpTo_AllocateObject,JmpTo3_PlaySound,JmpTo2_PalLoad_Now,JmpTo2_LoadPLC,JmpTo3_PlayMusic

; ===========================================================================
