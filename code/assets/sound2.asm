; ----------------------------------------------------------------------------------
; Filler (free space)
; ----------------------------------------------------------------------------------
	; the PCM data has to line up with the end of the bank.
	cnop -Size_of_SEGA_sound, $8000

; -------------------------------------------------------------------------------
; Sega Intro Sound
; 8-bit unsigned raw audio at 16Khz
; -------------------------------------------------------------------------------
; loc_F1E8C:
Snd_Sega:	BINCLUDE	"sound/PCM/SEGA.pcm"
Snd_Sega_End:

	if Snd_Sega_End - Snd_Sega > $8000
		fatal "Sega sound must fit within $8000 bytes, but you have a $\{Snd_Sega_End-Snd_Sega} byte Sega sound."
	endif
	if Snd_Sega_End - Snd_Sega > Size_of_SEGA_sound
		fatal "Size_of_SEGA_sound = $\{Size_of_SEGA_sound}, but you have a $\{Snd_Sega_End-Snd_Sega} byte Sega sound."
	endif

; ------------------------------------------------------------------------------
; Music pointers
; ------------------------------------------------------------------------------
; loc_F8000:
MusicPoint2:	startBank
MusPtr_CNZ_2P:		rom_ptr_z80	Mus_CNZ_2P
MusPtr_EHZ:		rom_ptr_z80	Mus_EHZ
MusPtr_MTZ:		rom_ptr_z80	Mus_MTZ
MusPtr_CNZ:		rom_ptr_z80	Mus_CNZ
MusPtr_MCZ:		rom_ptr_z80	Mus_MCZ
MusPtr_MCZ_2P:		rom_ptr_z80	Mus_MCZ_2P
MusPtr_ARZ:		rom_ptr_z80	Mus_ARZ
MusPtr_DEZ:		rom_ptr_z80	Mus_DEZ
MusPtr_SpecStage:	rom_ptr_z80	Mus_SpecStage
MusPtr_Options:		rom_ptr_z80	Mus_Options
MusPtr_Ending:		rom_ptr_z80	Mus_Ending
MusPtr_EndBoss:		rom_ptr_z80	Mus_EndBoss
MusPtr_CPZ:		rom_ptr_z80	Mus_CPZ
MusPtr_Boss:		rom_ptr_z80	Mus_Boss
MusPtr_SCZ:		rom_ptr_z80	Mus_SCZ
MusPtr_OOZ:		rom_ptr_z80	Mus_OOZ
MusPtr_WFZ:		rom_ptr_z80	Mus_WFZ
MusPtr_EHZ_2P:		rom_ptr_z80	Mus_EHZ_2P
MusPtr_2PResult:	rom_ptr_z80	Mus_2PResult
MusPtr_SuperSonic:	rom_ptr_z80	Mus_SuperSonic
MusPtr_HTZ:		rom_ptr_z80	Mus_HTZ
MusPtr_ExtraLife:	rom_ptr_z80	Mus_ExtraLife
MusPtr_Title:		rom_ptr_z80	Mus_Title
MusPtr_EndLevel:	rom_ptr_z80	Mus_EndLevel
MusPtr_GameOver:	rom_ptr_z80	Mus_GameOver
MusPtr_Invincible:	rom_ptr_z80	Mus_Invincible
MusPtr_Emerald:		rom_ptr_z80	Mus_Emerald
MusPtr_HPZ:		rom_ptr_z80	Mus_HPZ
MusPtr_Drowning:	rom_ptr_z80	Mus_Drowning
MusPtr_Credits:		rom_ptr_z80	Mus_Credits

; loc_F803C:
Mus_HPZ:	BINCLUDE	"sound/music/compressed/90 - HPZ.sax"
Mus_Drowning:	BINCLUDE	"sound/music/compressed/9F - Drowning.sax"
Mus_Invincible:	BINCLUDE	"sound/music/compressed/97 - Invincible.sax"
Mus_CNZ_2P:	BINCLUDE	"sound/music/compressed/88 - CNZ 2P.sax"
Mus_EHZ:	BINCLUDE	"sound/music/compressed/82 - EHZ.sax"
Mus_MTZ:	BINCLUDE	"sound/music/compressed/85 - MTZ.sax"
Mus_CNZ:	BINCLUDE	"sound/music/compressed/89 - CNZ.sax"
Mus_MCZ:	BINCLUDE	"sound/music/compressed/8B - MCZ.sax"
Mus_MCZ_2P:	BINCLUDE	"sound/music/compressed/83 - MCZ 2P.sax"
Mus_ARZ:	BINCLUDE	"sound/music/compressed/87 - ARZ.sax"
Mus_DEZ:	BINCLUDE	"sound/music/compressed/8A - DEZ.sax"
Mus_SpecStage:	BINCLUDE	"sound/music/compressed/92 - Special Stage.sax"
Mus_Options:	BINCLUDE	"sound/music/compressed/91 - Options.sax"
Mus_Ending:	BINCLUDE	"sound/music/compressed/95 - Ending.sax"
Mus_EndBoss:	BINCLUDE	"sound/music/compressed/94 - Final Boss.sax"
Mus_CPZ:	BINCLUDE	"sound/music/compressed/8E - CPZ.sax"
Mus_Boss:	BINCLUDE	"sound/music/compressed/93 - Boss.sax"
Mus_SCZ:	BINCLUDE	"sound/music/compressed/8D - SCZ.sax"
Mus_OOZ:	BINCLUDE	"sound/music/compressed/84 - OOZ.sax"
Mus_WFZ:	BINCLUDE	"sound/music/compressed/8F - WFZ.sax"
Mus_EHZ_2P:	BINCLUDE	"sound/music/compressed/8C - EHZ 2P.sax"
Mus_2PResult:	BINCLUDE	"sound/music/compressed/81 - 2 Player Menu.sax"
Mus_SuperSonic:	BINCLUDE	"sound/music/compressed/96 - Super Sonic.sax"
Mus_HTZ:	BINCLUDE	"sound/music/compressed/86 - HTZ.sax"
Mus_Title:	BINCLUDE	"sound/music/compressed/99 - Title Screen.sax"
Mus_EndLevel:	BINCLUDE	"sound/music/compressed/9A - End of Act.sax"

Mus_ExtraLife:	include		"sound/music/98 - Extra Life.asm"
Mus_GameOver:	include		"sound/music/9B - Game Over.asm"
Mus_Emerald:	include		"sound/music/9D - Got Emerald.asm"
Mus_Credits:	include		"sound/music/9E - Credits.asm"

; ------------------------------------------------------------------------------------------
; Sound effect pointers
; ------------------------------------------------------------------------------------------
; WARNING the sound driver treats certain sounds specially
; going by the ID of the sound.
; SndID_Ring, SndID_RingLeft, SndID_Gloop, SndID_SpindashRev
; are referenced by the sound driver directly.
; If needed you can change this in s2.sounddriver.asm


; NOTE: the exact order of this list determines the priority of each sound, since it determines the sound's SndID.
;       a sound can get dropped if a higher-priority sound is already playing.
;	see zSFXPriority for the priority allocation itself.
; loc_FEE91: SoundPoint:
SoundIndex:
SndPtr_Jump:		rom_ptr_z80	Sound20	; jumping sound
SndPtr_Checkpoint:	rom_ptr_z80	Sound21	; checkpoint ding-dong sound
SndPtr_SpikeSwitch:	rom_ptr_z80	Sound22	; spike switch sound
SndPtr_Hurt:		rom_ptr_z80	Sound23	; hurt sound
SndPtr_Skidding:	rom_ptr_z80	Sound24	; skidding sound
SndPtr_BlockPush:	rom_ptr_z80	Sound25	; block push sound
SndPtr_HurtBySpikes:	rom_ptr_z80	Sound26	; spiky impalement sound
SndPtr_Sparkle:		rom_ptr_z80	Sound27	; sparkling sound
SndPtr_Beep:		rom_ptr_z80	Sound28	; short beep
SndPtr_Bwoop:		rom_ptr_z80	Sound29	; bwoop (unused)
SndPtr_Splash:		rom_ptr_z80	Sound2A	; splash sound
SndPtr_Swish:		rom_ptr_z80	Sound2B	; swish
SndPtr_BossHit:		rom_ptr_z80	Sound2C	; boss hit
SndPtr_InhalingBubble:	rom_ptr_z80	Sound2D	; inhaling a bubble
SndPtr_ArrowFiring:
SndPtr_LavaBall:	rom_ptr_z80	Sound2E	; arrow firing
SndPtr_Shield:		rom_ptr_z80	Sound2F	; shield sound
SndPtr_LaserBeam:	rom_ptr_z80	Sound30	; laser beam
SndPtr_Zap:		rom_ptr_z80	Sound31	; zap (unused)
SndPtr_Drown:		rom_ptr_z80	Sound32	; drownage
SndPtr_FireBurn:	rom_ptr_z80	Sound33	; fire + burn
SndPtr_Bumper:		rom_ptr_z80	Sound34	; bumper bing
SndPtr_Ring:
SndPtr_RingRight:	rom_ptr_z80	Sound35	; ring sound
SndPtr_SpikesMove:	rom_ptr_z80	Sound36
SndPtr_Rumbling:	rom_ptr_z80	Sound37	; rumbling
			rom_ptr_z80	Sound38	; (unused)
SndPtr_Smash:		rom_ptr_z80	Sound39	; smash/breaking
			rom_ptr_z80	Sound3A	; nondescript ding (unused)
SndPtr_DoorSlam:	rom_ptr_z80	Sound3B	; door slamming shut
SndPtr_SpindashRelease:	rom_ptr_z80	Sound3C	; spindash unleashed
SndPtr_Hammer:		rom_ptr_z80	Sound3D	; slide-thunk
SndPtr_Roll:		rom_ptr_z80	Sound3E	; rolling sound
SndPtr_ContinueJingle:	rom_ptr_z80	Sound3F	; got continue
SndPtr_CasinoBonus:	rom_ptr_z80	Sound40	; short bonus ding
SndPtr_Explosion:	rom_ptr_z80	Sound41	; badnik bust
SndPtr_WaterWarning:	rom_ptr_z80	Sound42	; warning ding-ding
SndPtr_EnterGiantRing:	rom_ptr_z80	Sound43	; special stage ring flash (mostly unused)
SndPtr_BossExplosion:	rom_ptr_z80	Sound44	; thunk
SndPtr_TallyEnd:	rom_ptr_z80	Sound45	; cha-ching
SndPtr_RingSpill:	rom_ptr_z80	Sound46	; losing rings
			rom_ptr_z80	Sound47	; chain pull chink-chink (unused)
SndPtr_Flamethrower:	rom_ptr_z80	Sound48	; flamethrower
SndPtr_Bonus:		rom_ptr_z80	Sound49	; bonus pwoieeew (mostly unused)
SndPtr_SpecStageEntry:	rom_ptr_z80	Sound4A	; special stage entry
SndPtr_SlowSmash:	rom_ptr_z80	Sound4B	; slower smash/crumble
SndPtr_Spring:		rom_ptr_z80	Sound4C	; spring boing
SndPtr_Blip:		rom_ptr_z80	Sound4D	; selection blip
SndPtr_RingLeft:	rom_ptr_z80	Sound4E	; another ring sound (only plays in the left speaker?)
SndPtr_Signpost:	rom_ptr_z80	Sound4F	; signpost spin sound
SndPtr_CNZBossZap:	rom_ptr_z80	Sound50	; mosquito zapper
			rom_ptr_z80	Sound51	; (unused)
			rom_ptr_z80	Sound52	; (unused)
SndPtr_Signpost2P:	rom_ptr_z80	Sound53
SndPtr_OOZLidPop:	rom_ptr_z80	Sound54	; OOZ lid pop sound
SndPtr_SlidingSpike:	rom_ptr_z80	Sound55
SndPtr_CNZElevator:	rom_ptr_z80	Sound56
SndPtr_PlatformKnock:	rom_ptr_z80	Sound57
SndPtr_BonusBumper:	rom_ptr_z80	Sound58	; CNZ bonusy bumper sound
SndPtr_LargeBumper:	rom_ptr_z80	Sound59	; CNZ baaang bumper sound
SndPtr_Gloop:		rom_ptr_z80	Sound5A	; CNZ gloop / water droplet sound
SndPtr_PreArrowFiring:	rom_ptr_z80	Sound5B
SndPtr_Fire:		rom_ptr_z80	Sound5C
SndPtr_ArrowStick:	rom_ptr_z80	Sound5D	; chain clink
SndPtr_Helicopter:
SndPtr_WingFortress:	rom_ptr_z80	Sound5E	; helicopter
SndPtr_SuperTransform:	rom_ptr_z80	Sound5F
SndPtr_SpindashRev:	rom_ptr_z80	Sound60	; spindash charge
SndPtr_Rumbling2:	rom_ptr_z80	Sound61	; rumbling
SndPtr_CNZLaunch:	rom_ptr_z80	Sound62
SndPtr_Flipper:		rom_ptr_z80	Sound63	; CNZ blooing bumper
SndPtr_HTZLiftClick:	rom_ptr_z80	Sound64	; HTZ track click sound
SndPtr_Leaves:		rom_ptr_z80	Sound65	; kicking up leaves sound
SndPtr_MegaMackDrop:	rom_ptr_z80	Sound66	; leaf splash?
SndPtr_DrawbridgeMove:	rom_ptr_z80	Sound67
SndPtr_QuickDoorSlam:	rom_ptr_z80	Sound68	; door slamming quickly (unused)
SndPtr_DrawbridgeDown:	rom_ptr_z80	Sound69
SndPtr_LaserBurst:	rom_ptr_z80	Sound6A	; robotic laser burst
SndPtr_Scatter:
SndPtr_LaserFloor:	rom_ptr_z80	Sound6B	; scatter
SndPtr_Teleport:	rom_ptr_z80	Sound6C
SndPtr_Error:		rom_ptr_z80	Sound6D	; error sound
SndPtr_MechaSonicBuzz:	rom_ptr_z80	Sound6E	; Silver Sonic buzz saw
SndPtr_LargeLaser:	rom_ptr_z80	Sound6F
SndPtr_OilSlide:	rom_ptr_z80	Sound70
SndPtr__End:

Sound20:	include "sound/sfx/A0 - Jump.asm"
Sound21:	include "sound/sfx/A1 - Checkpoint.asm"
Sound22:	include "sound/sfx/A2 - Spike Switch.asm"
Sound23:	include "sound/sfx/A3 - Hurt.asm"
Sound24:	include "sound/sfx/A4 - Skidding.asm"
Sound25:	include "sound/sfx/A5 - Block Push.asm"
Sound26:	include "sound/sfx/A6 - Hurt by Spikes.asm"
Sound27:	include "sound/sfx/A7 - Sparkle.asm"
Sound28:	include "sound/sfx/A8 - Beep.asm"
Sound29:	include "sound/sfx/A9 - Special Stage Item (Unused).asm"
Sound2A:	include "sound/sfx/AA - Splash.asm"
Sound2B:	include "sound/sfx/AB - Swish.asm"
Sound2C:	include "sound/sfx/AC - Boss Hit.asm"
Sound2D:	include "sound/sfx/AD - Inhaling Bubble.asm"
Sound2E:	include "sound/sfx/AE - Lava Ball.asm"
Sound2F:	include "sound/sfx/AF - Shield.asm"
Sound30:	include "sound/sfx/B0 - Laser Beam.asm"
Sound31:	include "sound/sfx/B1 - Electricity (Unused).asm"
Sound32:	include "sound/sfx/B2 - Drown.asm"
Sound33:	include "sound/sfx/B3 - Fire Burn.asm"
Sound34:	include "sound/sfx/B4 - Bumper.asm"
Sound35:	include "sound/sfx/B5 - Ring.asm"
Sound36:	include "sound/sfx/B6 - Spikes Move.asm"
Sound37:	include "sound/sfx/B7 - Rumbling.asm"
Sound38:	include "sound/sfx/B8 - Unknown (Unused).asm"
Sound39:	include "sound/sfx/B9 - Smash.asm"
Sound3A:	include "sound/sfx/BA - Special Stage Glass (Unused).asm"
Sound3B:	include "sound/sfx/BB - Door Slam.asm"
Sound3C:	include "sound/sfx/BC - Spin Dash Release.asm"
Sound3D:	include "sound/sfx/BD - Hammer.asm"
Sound3E:	include "sound/sfx/BE - Roll.asm"
Sound3F:	include "sound/sfx/BF - Continue Jingle.asm"
Sound40:	include "sound/sfx/C0 - Casino Bonus.asm"
Sound41:	include "sound/sfx/C1 - Explosion.asm"
Sound42:	include "sound/sfx/C2 - Water Warning.asm"
Sound43:	include "sound/sfx/C3 - Enter Giant Ring (Unused).asm"
Sound44:	include "sound/sfx/C4 - Boss Explosion.asm"
Sound45:	include "sound/sfx/C5 - Tally End.asm"
Sound46:	include "sound/sfx/C6 - Ring Spill.asm"
Sound47:	include "sound/sfx/C7 - Chain Rise (Unused).asm"
Sound48:	include "sound/sfx/C8 - Flamethrower.asm"
Sound49:	include "sound/sfx/C9 - Hidden Bonus (Unused).asm"
Sound4A:	include "sound/sfx/CA - Special Stage Entry.asm"
Sound4B:	include "sound/sfx/CB - Slow Smash.asm"
Sound4C:	include "sound/sfx/CC - Spring.asm"
Sound4D:	include "sound/sfx/CD - Switch.asm"
Sound4E:	include "sound/sfx/CE - Ring Left Speaker.asm"
Sound4F:	include "sound/sfx/CF - Signpost.asm"
Sound50:	include "sound/sfx/D0 - CNZ Boss Zap.asm"
Sound51:	include "sound/sfx/D1 - Unknown (Unused).asm"
Sound52:	include "sound/sfx/D2 - Unknown (Unused).asm"
Sound53:	include "sound/sfx/D3 - Signpost 2P.asm"
Sound54:	include "sound/sfx/D4 - OOZ Lid Pop.asm"
Sound55:	include "sound/sfx/D5 - Sliding Spike.asm"
Sound56:	include "sound/sfx/D6 - CNZ Elevator.asm"
Sound57:	include "sound/sfx/D7 - Platform Knock.asm"
Sound58:	include "sound/sfx/D8 - Bonus Bumper.asm"
Sound59:	include "sound/sfx/D9 - Large Bumper.asm"
Sound5A:	include "sound/sfx/DA - Gloop.asm"
Sound5B:	include "sound/sfx/DB - Pre-Arrow Firing.asm"
Sound5C:	include "sound/sfx/DC - Fire.asm"
Sound5D:	include "sound/sfx/DD - Arrow Stick.asm"
Sound5E:	include "sound/sfx/DE - Helicopter.asm"
Sound5F:	include "sound/sfx/DF - Super Transform.asm"
Sound60:	include "sound/sfx/E0 - Spin Dash Rev.asm"
Sound61:	include "sound/sfx/E1 - Rumbling 2.asm"
Sound62:	include "sound/sfx/E2 - CNZ Launch.asm"
Sound63:	include "sound/sfx/E3 - Flipper.asm"
Sound64:	include "sound/sfx/E4 - HTZ Lift Click.asm"
Sound65:	include "sound/sfx/E5 - Leaves.asm"
Sound66:	include "sound/sfx/E6 - Mega Mack Drop.asm"
Sound67:	include "sound/sfx/E7 - Drawbridge Move.asm"
Sound68:	include "sound/sfx/E8 - Quick Door Slam.asm"
Sound69:	include "sound/sfx/E9 - Drawbridge Down.asm"
Sound6A:	include "sound/sfx/EA - Laser Burst.asm"
Sound6B:	include "sound/sfx/EB - Scatter.asm"
Sound6C:	include "sound/sfx/EC - Teleport.asm"
Sound6D:	include "sound/sfx/ED - Error.asm"
Sound6E:	include "sound/sfx/EE - Mecha Sonic Buzz.asm"
Sound6F:	include "sound/sfx/EF - Large Laser.asm"
Sound70:	include "sound/sfx/F0 - Oil Slide.asm"

	finishBank
