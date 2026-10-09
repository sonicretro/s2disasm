; Sonic the Hedgehog 2 disassembled binary

; Nemesis,   2004: Created original disassembly for SNASM68K
; Aurochs,   2005: Translated to AS and annotated
; Xenowhirl, 2007: More annotation, overall cleanup, Z80 disassembly
; ---------------------------------------------------------------------------
; NOTES:
;
; Set your editor's tab width to 8 characters wide for viewing this file.
;
; It is highly suggested that you read the AS User's Manual before diving too
; far into this disassembly. At least read the section on nameless temporary
; symbols. Your brain may melt if you don't know how those work.
;
; See s2.notes.txt for more comments about this disassembly and other useful info.

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ASSEMBLY OPTIONS:
;
gameRevision = 1
;	| If 0, a REV00 ROM is built
;	| If 1, a REV01 ROM is built, which contains some fixes
;	| If 2, a (theoretical) REV02 ROM is built, which contains even more fixes
padToPowerOfTwo = 1
;	| If 1, pads the end of the ROM to the next power of two bytes (for real hardware)
;
fixBugs = 0
;	| If 1, enables all bug-fixes
;	| See also the 'FixDriverBugs' flag in 'src/sound/Z80 Sound Driver.asm'
;	| See also the 'FixMusicAndSFXDataBugs' flag in 'build.lua'
allOptimizations = 0
;	| If 1, enables all optimizations
;
skipChecksumCheck = 0
;	| If 1, disables the slow bootup checksum calculation
;
zeroOffsetOptimization = 0|allOptimizations
;	| If 1, makes a handful of zero-offset instructions smaller
;
removeJmpTos = 0|(gameRevision>=2)|allOptimizations
;	| If 1, many unnecessary JmpTos are removed, improving performance
;
addsubOptimize = 0|(gameRevision=2)|allOptimizations
;	| If 1, some add/sub instructions are optimized to addq/subq
;
relativeLea = 0|(gameRevision<2)|allOptimizations
;	| If 1, makes some instructions use pc-relative addressing, instead of absolute long
;
useFullWaterTables = 0
;	| If 1, zone offset tables for water levels cover all level slots instead of only slots 8-$F
;	| Set to 1 if you've shifted level IDs around or you want water in levels with a level slot below 8

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; AS-specific macros and assembler settings
	CPU 68000
	include "src/macrosetup.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Simplifying macros and functions
	include "src/macros.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equates section - Names for variables.
	include "src/constants.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Expressing SMPS bytecode in a portable and human-readable form
FixMusicAndSFXDataBugs = fixBugs
SonicDriverVer = 2 ; Tell SMPS2ASM that we are targetting Sonic 2's sound driver
	include "sound/_smps2asm_inc.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Expressing sprite mappings and DPLCs in a portable and human-readable form
SonicMappingsVer := 2
SonicDplcVer := 2
	include "mappings/MapMacros.asm"

; ---------------------------------------------------------------------------
; System: vectors, init, main loop, interrupts, hardware
; ---------------------------------------------------------------------------
	include "src/system/Vectors and Header.asm"
	include "src/system/Init.asm"
	include "src/system/Main Loop.asm"
	include "src/system/V_Int.asm"
	include "src/system/H_Int.asm"
	include "src/system/Joypad.asm"
	include "src/system/VDP.asm"
	include "src/system/Sound Calls.asm"
	include "src/system/Pause.asm"
	include "src/system/Plane Map.asm"

; ---------------------------------------------------------------------------
; DMA, decompression, PLCs and palettes
; ---------------------------------------------------------------------------
	include "src/system/DMA Queue.asm"
	include "src/compression/Nemesis Decompressor.asm"
	include "src/system/PLC Processing.asm"
	include "src/compression/Enigma Decompressor.asm"
	include "src/compression/Kosinski Decompressor.asm"
	include "src/palette/Palette Cycle.asm"
	include "src/palette/Palette Fade and Load.asm"
	include "src/palette/Palette Pointers.asm"

; ---------------------------------------------------------------------------
; Utilities
; ---------------------------------------------------------------------------
	include "src/system/WaitForVint.asm"
	include "src/objects/sub RandomNumber.asm"
	include "src/objects/sub CalcSine.asm"
	include "src/objects/sub CalcAngle.asm"

; ---------------------------------------------------------------------------
; Game modes: Sega screen and title screen
; ---------------------------------------------------------------------------
	include "src/modes/Sega Screen.asm"
	include "src/modes/Title Screen.asm"
	include "src/level/zone/Music List.asm"

; ---------------------------------------------------------------------------
; Game mode: level
; ---------------------------------------------------------------------------
	include "src/level/Level.asm"
	include "src/level/Water.asm"
	include "src/level/Wind Tunnels.asm"
	include "src/level/Slides.asm"
	include "src/level/MoveSonicInDemo.asm"
	include "src/level/Load Collision Index.asm"
	include "src/objects/sub OscillatingNumber.asm"
	include "src/level/Change Ring Frame.asm"
	include "src/level/Level End.asm"
	include "src/level/Load Zone Tiles.asm"

; ---------------------------------------------------------------------------
; Game mode: special stage
; ---------------------------------------------------------------------------
	include "src/special stage/Special Stage.asm"
	include "src/objects/5E Special Stage HUD.asm"
	include "src/objects/5F Special Stage Start Banner.asm"
	include "src/objects/87 Special Stage Rings Counter.asm"
	include "src/special stage/Act Setup.asm"

; ---------------------------------------------------------------------------
; Game mode: continue screen
; ---------------------------------------------------------------------------
	include "src/modes/Continue Screen.asm"
	include "src/objects/DA Continue Text.asm"
	include "src/objects/DB Continue Player.asm"
	jmpTos JmpTo_Adjust2PArtPointer2,JmpTo_Adjust2PArtPointer

; ---------------------------------------------------------------------------
; Game mode: 2P results
; ---------------------------------------------------------------------------
	include "src/modes/2P results/Main.asm"
	include "src/objects/21 2P Results Display.asm"
	include "src/modes/2P results/Setup.asm"
	include "src/modes/2P results/Data.asm"

; ---------------------------------------------------------------------------
; Game modes: menus (2P level select, options, level select)
; ---------------------------------------------------------------------------
	include "src/modes/Menu Screen.asm"
	include "src/modes/Options.asm"
	include "src/modes/Level Select.asm"
	include "src/modes/Cheats and Menu Data.asm"

; ---------------------------------------------------------------------------
; Game mode: ending sequence and credits
; ---------------------------------------------------------------------------
	include "src/modes/Ending Sequence.asm"
	include "src/objects/CA Ending Cutscene.asm"
	include "src/objects/CC Ending Tornado Trigger.asm"
	include "src/objects/CE Ending Sonic and Tails.asm"
	include "src/objects/CF Ending Tornado Propeller.asm"
	include "src/objects/CB Ending Clouds.asm"
	include "src/objects/CD Ending Birds.asm"
	include "src/modes/Ending Sequence Data.asm"
	include "src/modes/credits/Main.asm"

; ---------------------------------------------------------------------------
; Level: size, start positions, camera, scrolling, drawing, events
; ---------------------------------------------------------------------------
	include "src/level/LevelSizeLoad.asm"
	include "src/level/zone/Start Locations.asm"
	include "src/level/Camera Init.asm"
	include "src/level/scrolling/Software Scrolling Manager.asm"
	include "src/level/Camera Scrolling.asm"
	include "src/level/Level Drawing.asm"
	include "src/level/LoadLevelLayout.asm" ; includes loadZoneBlockMaps
	include "src/level/events/DynamicLevelEvents.asm"
	include "src/level/Play Level Music.asm"

; ---------------------------------------------------------------------------
; Objects: common level objects
; ---------------------------------------------------------------------------
	include "src/objects/11 Bridge.asm"
	jmpTos JmpTo_AllocateObjectAfterCurrent,JmpTo_PlatformObject11_cont,JmpTo_CalcSine
	include "src/objects/15 ARZ Swinging Platform.asm"
	jmpTos JmpTo_PlatformObject2,JmpTo2_AllocateObjectAfterCurrent,JmpTo2_CalcSine,JmpTo_ObjCheckRightWallDist
	include "src/objects/17 Spiked Pole Helix.asm"
	jmpTos ; Empty
	include "src/objects/18 Platforms.asm"
	jmpTos JmpTo3_CalcSine,JmpTo_PlatformObject,JmpTo_SolidObject
	include "src/objects/1A & 1F Collapsing Floors.asm"
	jmpTos JmpTo_SlopedPlatform,JmpTo2_PlatformObject
	include "src/objects/1C Bridge Stake and Falling Oil.asm"
	include "src/objects/71 Bridge Stake and Pulsing Orb.asm"
	jmpTos ; Empty
	include "src/objects/2A MCZ Stomper.asm"
	include "src/objects/2D CPZ One Way Barrier.asm"
	jmpTos JmpTo2_SolidObject
	include "src/objects/28 Animals.asm"
	include "src/objects/29 Points.asm"
	jmpTos JmpTo_RandomNumber
	include "src/objects/25 & 37 Rings.asm" ; also includes the dead code for Sonic 1's Big Rings
	include "src/objects/DC CNZ Ring Prize.asm"
	jmpTos JmpTo4_CalcSine
	include "src/objects/26 Monitor.asm"
	include "src/objects/2E Monitor Contents.asm"
	jmpTos ; Empty

; ---------------------------------------------------------------------------
; Objects: title screen, title cards, results
; ---------------------------------------------------------------------------
	include "src/objects/0E Title Screen Animations.asm"
	include "src/objects/C9 Title Screen Palette Changing Handler.asm"
	include "src/modes/Title Screen Helpers.asm"
	include "src/objects/0F Title Screen Menu.asm"
	jmpTos0 JmpTo4_PlaySound,JmpTo4_PlayMusic
	include "src/objects/34 Title Cards.asm"
	include "src/objects/39 Game Over.asm"
	include "src/objects/3A Got Through Card.asm"
	include "src/level/zone/Level Order.asm"
	include "src/objects/6F Special Stage Results.asm"
	include "src/level/Title Cards.asm"

; ---------------------------------------------------------------------------
; Objects: spikes, rock, smashable wall
; ---------------------------------------------------------------------------
	include "src/objects/36 Spikes.asm"
	jmpTos ; Empty
	include "src/objects/3B Purple Rock.asm"
	jmpTos0 ; Empty
	include "src/objects/3C Smashable Wall.asm"

; ---------------------------------------------------------------------------
; Object engine: run, move, delete, display, animate, build sprites
; ---------------------------------------------------------------------------
	include "src/objects/sub RunObjects.asm"
	include "src/objects/Object Pointers.asm" ; also includes the null object
	include "src/objects/sub ObjectMove.asm" ; also ObjectMoveAndFall
	include "src/objects/sub DeleteObject.asm" ; also MarkObjGone
	include "src/objects/sub DisplaySprite.asm"
	include "src/objects/sub AnimateSprite.asm"
	include "src/objects/BuildSprites.asm" ; also DrawSprites and the 2P versions
	jmpTos JmpTo_BuildHUD,JmpTo_BuildHUD_P1,JmpTo_BuildHUD_P2

; ---------------------------------------------------------------------------
; Rings, CNZ bumpers and objects managers
; ---------------------------------------------------------------------------
	include "src/level/Rings Manager.asm"
	include "src/level/CNZ Bumpers.asm"
	include "src/level/zone/CNZ Bumpers Data.asm"
	jmpTos ; Empty
	include "src/objects/Objects Manager.asm"
	include "src/level/zone/CNZ 2P Object Layouts.asm"

; ---------------------------------------------------------------------------
; Objects: springs and signpost
; ---------------------------------------------------------------------------
	include "src/objects/41 Springs.asm"
	jmpTos ; Empty
	include "src/objects/0D Signpost.asm"
	jmpTos ; Empty

; ---------------------------------------------------------------------------
; Object engine: solid objects and platforms
; ---------------------------------------------------------------------------
	include "src/objects/sub SolidObject.asm" ; also SlopedSolid
	include "src/objects/sub MvSonicOnPtfm.asm" ; also MvSonicOnSlope
	include "src/objects/sub PlatformObject.asm" ; also SlopedPlatform

; ---------------------------------------------------------------------------
; Players: Sonic, Tails and their effects
; ---------------------------------------------------------------------------
	include "src/objects/01 Sonic.asm"
	include "src/objects/sub LoadSonicDynPLC.asm"
	jmpTos0 JmpTo_KillCharacter
	include "src/objects/02 Tails.asm"
	include "src/objects/sub LoadTailsDynPLC.asm" ; also LoadTailsTailsDynPLC
	include "src/objects/05 Tails' Tails.asm"
	jmpTos JmpTo2_KillCharacter
	include "src/objects/0A Bubbles & Drowning Countdown.asm"
	include "src/objects/sub ResumeMusic.asm"
	include "src/objects/38 Shield.asm"
	include "src/objects/35 Invincibility Stars.asm"
	include "src/objects/08 Splash & Dust.asm"
	include "src/objects/7E Super Sonic's Stars.asm"
	jmpTos ; Empty

; ---------------------------------------------------------------------------
; Player collision: angle, floor and wall detection
; ---------------------------------------------------------------------------
	include "src/objects/Sonic AnglePos.asm"
	include "src/objects/sub FindTile.asm" ; also FindFloor and FindWall
	include "src/objects/sub ConvertCollisionArray.asm"
	jmpTos ; Empty
	include "src/objects/sub CalcRoom.asm" ; InFront and OverHead
	include "src/objects/sub CheckFloor.asm" ; also Walls and Ceilings

; ---------------------------------------------------------------------------
; Objects: level objects
; ---------------------------------------------------------------------------
	include "src/objects/79 Starpost.asm"
	include "src/objects/79 Starpost (Part 2).asm" ; Stars for Special Stage entrance
	jmpTos JmpTo_MarkObjGone,JmpTo2_AnimateSprite,JmpTo3_Adjust2PArtPointer
	include "src/objects/7D Hidden Bonuses.asm"
	jmpTos JmpTo4_Adjust2PArtPointer
	include "src/objects/44 Bumper.asm"
	jmpTos JmpTo2_MarkObjGone,JmpTo3_AnimateSprite,JmpTo5_Adjust2PArtPointer
	include "src/objects/24 ARZ Bubbles.asm"
	jmpTos JmpTo7_DisplaySprite,JmpTo15_DeleteObject,JmpTo6_Adjust2PArtPointer,JmpTo3_ObjectMove
	include "src/objects/03 Collision Switcher.asm"
	jmpTos JmpTo7_Adjust2PArtPointer
	include "src/objects/0B CPZ Pipe.asm"
	jmpTos JmpTo3_MarkObjGone,JmpTo8_Adjust2PArtPointer
	include "src/objects/0C Small Floating Platform.asm"
	jmpTos JmpTo4_MarkObjGone,JmpTo9_Adjust2PArtPointer,JmpTo5_CalcSine
	include "src/objects/12 HPZ Emerald.asm"
	jmpTos JmpTo8_DisplaySprite,JmpTo16_DeleteObject,JmpTo10_Adjust2PArtPointer
	include "src/objects/13 HPZ Waterfall.asm"
	jmpTos JmpTo9_DisplaySprite,JmpTo17_DeleteObject,JmpTo2_Adjust2PArtPointer2,JmpTo11_Adjust2PArtPointer
	include "src/objects/04 Water Surface.asm"
	include "src/objects/49 EHZ Waterfall.asm"
	include "src/objects/31 Lava Collision Maker.asm"
	include "src/objects/74 Invisible Solid Block.asm"
	include "src/objects/7C Pylon.asm"
	include "src/objects/27 Explosion.asm"
	include "src/objects/84 Pinball Mode Trigger.asm"
	include "src/objects/8B WFZ Cycling Palette Switcher.asm"
	jmpTos JmpTo10_DisplaySprite,JmpTo18_DeleteObject,JmpTo2_AllocateObject,JmpTo12_Adjust2PArtPointer
	include "src/objects/06 Corkscrew.asm" ; EHZ spiral path and MTZ rotating cylinder
	jmpTos JmpTo6_CalcSine
	include "src/objects/14 Seesaw.asm"
	jmpTos JmpTo3_AllocateObjectAfterCurrent,JmpTo13_Adjust2PArtPointer,JmpTo_ObjectMoveAndFall,JmpTo_MarkObjGone2
	include "src/objects/16 HTZ Diagonal Lift.asm"
	jmpTos JmpTo5_MarkObjGone,JmpTo4_AllocateObjectAfterCurrent,JmpTo14_Adjust2PArtPointer,JmpTo3_PlatformObject,JmpTo4_ObjectMove
	include "src/objects/19 Moving Platforms.asm"
	jmpTos JmpTo11_DisplaySprite,JmpTo20_DeleteObject,JmpTo15_Adjust2PArtPointer,JmpTo4_PlatformObject,JmpTo5_ObjectMove
	include "src/objects/1B CPZ Speed Booster.asm"
	jmpTos JmpTo6_MarkObjGone,JmpTo16_Adjust2PArtPointer
	include "src/objects/1D CPZ Blue Balls.asm"
	jmpTos JmpTo7_MarkObjGone,JmpTo5_AllocateObjectAfterCurrent,JmpTo3_Adjust2PArtPointer2,JmpTo6_ObjectMove
	include "src/objects/1E CPZ Spin Tube.asm"
	jmpTos JmpTo_MarkObjGone3
	include "src/objects/20 HTZ Boss Lava Bubble.asm"
	jmpTos JmpTo21_DeleteObject,JmpTo8_MarkObjGone,JmpTo6_AllocateObjectAfterCurrent,JmpTo4_AnimateSprite,JmpTo17_Adjust2PArtPointer,JmpTo7_ObjectMove
	include "src/objects/2F & 32 Smashable Ground & Blocks.asm"
	jmpTos JmpTo12_DisplaySprite,JmpTo22_DeleteObject,JmpTo3_AllocateObject,JmpTo9_MarkObjGone,JmpTo18_Adjust2PArtPointer,JmpTo_BreakObjectToPieces,JmpTo3_SolidObject,JmpTo8_ObjectMove
	include "src/objects/30 HTZ Quake Lava.asm"
	jmpTos JmpTo23_DeleteObject,JmpTo_Touch_ChkHurt,JmpTo2_MarkObjGone3,JmpTo_DropOnFloor,JmpTo_SolidObject_Always,JmpTo_SlopedSolid
	include "src/objects/33 OOZ Green Platform.asm"
	jmpTos JmpTo10_MarkObjGone,JmpTo7_AllocateObjectAfterCurrent,JmpTo4_SolidObject
	include "src/objects/43 OOZ Sliding Spikes.asm"
	jmpTos JmpTo8_AllocateObjectAfterCurrent,JmpTo19_Adjust2PArtPointer
	include "src/objects/07 Oil Ocean.asm"
	jmpTos JmpTo3_KillCharacter,JmpTo_PlatformObject_SingleCharacter
	include "src/objects/45 OOZ Pressure Spring.asm"
	include "src/objects/46 OOZ Ball.asm"
	jmpTos JmpTo25_DeleteObject,JmpTo4_AllocateObject,JmpTo11_MarkObjGone,JmpTo20_Adjust2PArtPointer,JmpTo5_SolidObject,JmpTo_SolidObject_Always_SingleCharacter,JmpTo_SolidObject45,JmpTo9_ObjectMove
	include "src/objects/47 Button.asm"
	jmpTos JmpTo12_MarkObjGone,JmpTo21_Adjust2PArtPointer,JmpTo6_SolidObject
	include "src/objects/3D OOZ Smashable Launcher Cap.asm"
	jmpTos JmpTo14_DisplaySprite,JmpTo26_DeleteObject,JmpTo13_MarkObjGone,JmpTo9_AllocateObjectAfterCurrent,JmpTo3_MarkObjGone3,JmpTo22_Adjust2PArtPointer,JmpTo2_BreakObjectToPieces,JmpTo7_SolidObject,JmpTo10_ObjectMove
	include "src/objects/48 OOZ Cannon.asm"
	jmpTos JmpTo15_DisplaySprite,JmpTo14_MarkObjGone,JmpTo23_Adjust2PArtPointer
	include "src/objects/22 ARZ Arrow Shooter.asm"
	jmpTos JmpTo27_DeleteObject,JmpTo5_AllocateObject,JmpTo15_MarkObjGone,JmpTo5_AnimateSprite,JmpTo24_Adjust2PArtPointer,JmpTo11_ObjectMove
	include "src/objects/23 ARZ Falling Pillar.asm"
	include "src/objects/2B ARZ Rising Pillar.asm"
	jmpTos JmpTo16_DisplaySprite,JmpTo28_DeleteObject,JmpTo16_MarkObjGone,JmpTo10_AllocateObjectAfterCurrent,JmpTo25_Adjust2PArtPointer,JmpTo8_SolidObject,JmpTo12_ObjectMove
	include "src/objects/2C ARZ Leaf Spawner.asm"
	jmpTos JmpTo17_DisplaySprite,JmpTo29_DeleteObject,JmpTo6_AllocateObject,JmpTo2_RandomNumber,JmpTo7_CalcSine
	include "src/objects/40 Springboard.asm"
	jmpTos JmpTo17_MarkObjGone,JmpTo6_AnimateSprite,JmpTo26_Adjust2PArtPointer,JmpTo_SlopedSolid_SingleCharacter
	include "src/objects/42 MTZ Steam Spring.asm"
	jmpTos JmpTo18_DisplaySprite,JmpTo30_DeleteObject,JmpTo7_AllocateObject,JmpTo18_MarkObjGone,JmpTo27_Adjust2PArtPointer,JmpTo2_SolidObject_Always_SingleCharacter
	include "src/objects/64 MTZ Twin Crusher.asm"
	jmpTos JmpTo28_Adjust2PArtPointer,JmpTo9_SolidObject
	include "src/objects/65 MTZ Long Moving Platform.asm"
	jmpTos JmpTo19_MarkObjGone,JmpTo11_AllocateObjectAfterCurrent,JmpTo29_Adjust2PArtPointer,JmpTo10_SolidObject
	include "src/objects/66 MTZ Spring Walls.asm"
    if gameRevision=0
	jmpTos JmpTo47_DisplaySprite,JmpTo33_DeleteObject,JmpTo30_Adjust2PArtPointer,JmpTo3_SolidObject_Always_SingleCharacter
    else
	jmpTos JmpTo33_DeleteObject,JmpTo30_Adjust2PArtPointer,JmpTo3_SolidObject_Always_SingleCharacter
    endif
	include "src/objects/67 MTZ Spin Tube.asm"
	jmpTos JmpTo19_DisplaySprite,JmpTo7_AnimateSprite,JmpTo4_MarkObjGone3
	include "src/objects/68 MTZ Harpoon Block.asm"
	include "src/objects/6D MTZ Floor Harpoon.asm"
	jmpTos JmpTo20_MarkObjGone,JmpTo12_AllocateObjectAfterCurrent,JmpTo31_Adjust2PArtPointer,JmpTo11_SolidObject,JmpTo2_MarkObjGone2
	include "src/objects/69 Nut.asm" ; BLAME THE DISCORD FOR THIS ONE
	jmpTos JmpTo21_MarkObjGone,JmpTo_ObjCheckFloorDist,JmpTo32_Adjust2PArtPointer,JmpTo12_SolidObject,JmpTo13_ObjectMove
	include "src/objects/6A MTZ Shifting Platform.asm"
	jmpTos JmpTo13_AllocateObjectAfterCurrent,JmpTo33_Adjust2PArtPointer,JmpTo13_SolidObject,JmpTo3_MarkObjGone2
	include "src/objects/6B MTZ Immobile Platform.asm"
	jmpTos JmpTo34_Adjust2PArtPointer,JmpTo14_SolidObject,JmpTo4_MarkObjGone2,JmpTo14_ObjectMove
	include "src/objects/6C MTZ Pulley Platform.asm"
	jmpTos JmpTo20_DisplaySprite,JmpTo34_DeleteObject,JmpTo8_AllocateObject,JmpTo35_Adjust2PArtPointer,JmpTo5_PlatformObject,JmpTo15_ObjectMove
	include "src/objects/6E MTZ Circular Platform.asm"
	jmpTos JmpTo36_Adjust2PArtPointer,JmpTo15_SolidObject
	include "src/objects/70 MTZ Giant Cog.asm"
	jmpTos JmpTo14_AllocateObjectAfterCurrent,JmpTo4_Adjust2PArtPointer2,JmpTo16_SolidObject
	include "src/objects/72 CNZ Conveyor.asm"
	jmpTos JmpTo5_MarkObjGone3
	include "src/objects/73 MCZ Rotating Platform (Unused).asm"
	jmpTos JmpTo21_DisplaySprite,JmpTo9_AllocateObject,JmpTo_DeleteObject2,JmpTo37_Adjust2PArtPointer,JmpTo17_SolidObject
	include "src/objects/75 MCZ Brick.asm"
	jmpTos JmpTo_DisplaySprite3,JmpTo22_DisplaySprite,JmpTo38_DeleteObject,JmpTo22_MarkObjGone,JmpTo2_DeleteObject2,JmpTo15_AllocateObjectAfterCurrent,JmpTo38_Adjust2PArtPointer,JmpTo8_CalcSine,JmpTo18_SolidObject
	include "src/objects/76 MCZ Sliding Spikes.asm"
	jmpTos JmpTo_Touch_ChkHurt2,JmpTo39_Adjust2PArtPointer,JmpTo19_SolidObject,JmpTo5_MarkObjGone2
	include "src/objects/77 MCZ Bridge.asm"
	jmpTos JmpTo23_MarkObjGone,JmpTo40_Adjust2PArtPointer,JmpTo20_SolidObject
	include "src/objects/78 Staircase.asm"
	jmpTos JmpTo16_AllocateObjectAfterCurrent,JmpTo5_Adjust2PArtPointer2,JmpTo21_SolidObject,JmpTo6_MarkObjGone2
	include "src/objects/7A CPZ Sliding Platform.asm"
	jmpTos JmpTo24_DisplaySprite,JmpTo17_AllocateObjectAfterCurrent,JmpTo41_Adjust2PArtPointer,JmpTo6_PlatformObject
	include "src/objects/7B CPZ Spring Lid.asm"
	jmpTos JmpTo25_DisplaySprite,JmpTo40_DeleteObject,JmpTo8_AnimateSprite,JmpTo42_Adjust2PArtPointer,JmpTo4_SolidObject_Always_SingleCharacter
	include "src/objects/7F MCZ Vine Switch.asm"
	jmpTos JmpTo24_MarkObjGone,JmpTo43_Adjust2PArtPointer
	include "src/objects/80 MCZ Moving Vine.asm"
	jmpTos JmpTo25_MarkObjGone,JmpTo44_Adjust2PArtPointer
	include "src/objects/81 MCZ Drawbridge.asm"
	jmpTos JmpTo2_DisplaySprite3,JmpTo26_DisplaySprite,JmpTo41_DeleteObject,JmpTo3_DeleteObject2,JmpTo18_AllocateObjectAfterCurrent,JmpTo45_Adjust2PArtPointer,JmpTo9_CalcSine,JmpTo22_SolidObject
	include "src/objects/82 ARZ Swinging Platform.asm"
	jmpTos JmpTo2_ObjCheckFloorDist,JmpTo46_Adjust2PArtPointer,JmpTo_ObjCheckCeilingDist,JmpTo23_SolidObject,JmpTo7_MarkObjGone2,JmpTo16_ObjectMove
	include "src/objects/83 ARZ Rotating Platform Triple.asm"
	jmpTos JmpTo3_DisplaySprite3,JmpTo27_DisplaySprite,JmpTo42_DeleteObject,JmpTo4_DeleteObject2,JmpTo19_AllocateObjectAfterCurrent,JmpTo47_Adjust2PArtPointer,JmpTo10_CalcSine,JmpTo7_PlatformObject,JmpTo8_MarkObjGone2
	include "src/objects/3F OOZ Fan.asm"
	jmpTos JmpTo26_MarkObjGone,JmpTo48_Adjust2PArtPointer
	include "src/objects/85 CNZ Pinball Plunger Spring.asm"
	jmpTos JmpTo4_DisplaySprite3,JmpTo43_DeleteObject,JmpTo49_Adjust2PArtPointer,JmpTo5_SolidObject_Always_SingleCharacter
	include "src/objects/86 CNZ Pinball Flipper.asm"
	jmpTos JmpTo27_MarkObjGone,JmpTo9_AnimateSprite,JmpTo50_Adjust2PArtPointer,JmpTo11_CalcSine,JmpTo6_SolidObject_Always_SingleCharacter,JmpTo2_SlopedSolid
	include "src/objects/D2 CNZ Snake Block.asm"
	jmpTos JmpTo6_MarkObjGone3,JmpTo51_Adjust2PArtPointer,JmpTo24_SolidObject,JmpTo9_MarkObjGone2
	include "src/objects/D3 CNZ Bomb Prize.asm"
	jmpTos JmpTo28_DisplaySprite,JmpTo44_DeleteObject
	include "src/objects/D4 CNZ Big Block.asm"
	jmpTos JmpTo52_Adjust2PArtPointer,JmpTo25_SolidObject,JmpTo10_MarkObjGone2,JmpTo17_ObjectMove
	include "src/objects/D5 CNZ Elevator.asm"
	jmpTos JmpTo28_MarkObjGone,JmpTo53_Adjust2PArtPointer,JmpTo_PlatformObjectD5,JmpTo18_ObjectMove
	include "src/objects/D6 CNZ Points Cage.asm"
	include "src/objects/sub SlotMachine.asm"
	jmpTos JmpTo10_AllocateObject,JmpTo29_MarkObjGone,JmpTo10_AnimateSprite,JmpTo6_Adjust2PArtPointer2,JmpTo54_Adjust2PArtPointer,JmpTo12_CalcSine,JmpTo7_SolidObject_Always_SingleCharacter
	include "src/objects/D7 CNZ Bumper.asm"
	jmpTos JmpTo30_DisplaySprite,JmpTo30_MarkObjGone,JmpTo11_AnimateSprite,JmpTo55_Adjust2PArtPointer
	include "src/objects/D8 CNZ Point Block.asm"
	jmpTos JmpTo46_DeleteObject,JmpTo11_AllocateObject,JmpTo31_MarkObjGone,JmpTo12_AnimateSprite,JmpTo56_Adjust2PArtPointer
	include "src/objects/D9 Invisible Hang Flag.asm"
	jmpTos JmpTo7_MarkObjGone3

; ---------------------------------------------------------------------------
; Badniks: Octus, Aquis, Buzzer, Masher
; ---------------------------------------------------------------------------
	include "src/objects/4A Octus.asm"
	jmpTos0 JmpTo31_DisplaySprite,JmpTo47_DeleteObject,JmpTo32_MarkObjGone,JmpTo13_AnimateSprite,JmpTo2_ObjectMoveAndFall,JmpTo19_ObjectMove
	include "src/objects/50 Aquis.asm"
	jmpTos JmpTo32_DisplaySprite,JmpTo48_DeleteObject,JmpTo12_AllocateObject,JmpTo33_MarkObjGone,JmpTo14_AnimateSprite,JmpTo_Obj_GetOrientationToPlayer,JmpTo_Obj_CapSpeed,JmpTo_Obj_MoveStop,JmpTo20_ObjectMove
	include "src/objects/4B Buzzer.asm"
	jmpTos0 JmpTo49_DeleteObject,JmpTo20_AllocateObjectAfterCurrent,JmpTo15_AnimateSprite,JmpTo7_Adjust2PArtPointer2,JmpTo_MarkObjGone_P1,JmpTo57_Adjust2PArtPointer,JmpTo21_ObjectMove
	include "src/objects/5C Masher.asm"
	jmpTos0 JmpTo34_MarkObjGone,JmpTo16_AnimateSprite,JmpTo58_Adjust2PArtPointer,JmpTo22_ObjectMove

; ---------------------------------------------------------------------------
; Bosses
; ---------------------------------------------------------------------------
	include "src/objects/58 Boss Explosions.asm"
	include "src/objects/sub BossCommon.asm" ; bunch of common stuff for bosses, like damage and animation
	jmpTos JmpTo33_DisplaySprite,JmpTo50_DeleteObject,JmpTo4_LoadPLC,JmpTo_AddPoints,JmpTo59_Adjust2PArtPointer
	include "src/objects/5D CPZ Boss.asm"
	jmpTos JmpTo34_DisplaySprite,JmpTo51_DeleteObject,JmpTo35_MarkObjGone,JmpTo5_PlaySound,JmpTo8_Adjust2PArtPointer2,JmpTo5_LoadPLC,JmpTo2_AddPoints,JmpTo60_Adjust2PArtPointer,JmpTo_PlayLevelMusic,JmpTo_LoadPLC_AnimalExplosion,JmpTo3_ObjectMoveAndFall,JmpTo23_ObjectMove
	include "src/objects/56 EHZ Boss.asm"
	jmpTos JmpTo35_DisplaySprite,JmpTo52_DeleteObject,JmpTo36_MarkObjGone,JmpTo5_DeleteObject2,JmpTo6_PlaySound,JmpTo21_AllocateObjectAfterCurrent,JmpTo17_AnimateSprite,JmpTo9_Adjust2PArtPointer2,JmpTo3_ObjCheckFloorDist,JmpTo6_LoadPLC,JmpTo3_AddPoints,JmpTo61_Adjust2PArtPointer,JmpTo2_PlayLevelMusic,JmpTo2_LoadPLC_AnimalExplosion,JmpTo4_ObjectMoveAndFall
	include "src/objects/52 HTZ Boss.asm"
	jmpTos0 JmpTo36_DisplaySprite,JmpTo53_DeleteObject,JmpTo13_AllocateObject,JmpTo37_MarkObjGone,JmpTo7_PlaySound,JmpTo18_AnimateSprite,JmpTo4_ObjCheckFloorDist,JmpTo7_LoadPLC,JmpTo_Obj20,JmpTo4_AddPoints,JmpTo62_Adjust2PArtPointer,JmpTo3_PlayLevelMusic,JmpTo3_LoadPLC_AnimalExplosion
	include "src/objects/89 ARZ Boss.asm"
	jmpTos JmpTo37_DisplaySprite,JmpTo55_DeleteObject,JmpTo14_AllocateObject,JmpTo8_PlaySound,JmpTo22_AllocateObjectAfterCurrent,JmpTo19_AnimateSprite,JmpTo3_RandomNumber,JmpTo8_LoadPLC,JmpTo5_AddPoints,JmpTo4_PlayLevelMusic,JmpTo4_LoadPLC_AnimalExplosion,JmpTo8_PlatformObject,JmpTo26_SolidObject
	include "src/objects/57 MCZ Boss.asm"
	jmpTos JmpTo38_DisplaySprite,JmpTo57_DeleteObject,JmpTo15_AllocateObject,JmpTo4_RandomNumber,JmpTo9_LoadPLC,JmpTo6_AddPoints,JmpTo5_PlayLevelMusic,JmpTo5_LoadPLC_AnimalExplosion,JmpTo5_ObjectMoveAndFall
	include "src/objects/51 CNZ Boss.asm"
	jmpTos JmpTo39_DisplaySprite,JmpTo59_DeleteObject,JmpTo16_AllocateObject,JmpTo9_PlaySound,JmpTo23_AllocateObjectAfterCurrent,JmpTo20_AnimateSprite,JmpTo10_LoadPLC,JmpTo7_AddPoints,JmpTo6_PlayLevelMusic,JmpTo6_LoadPLC_AnimalExplosion
	include "src/objects/53 & 54 MTZ Boss.asm" ; 54 is the boss, 53 are the shield orbs
	jmpTos0 JmpTo40_DisplaySprite,JmpTo61_DeleteObject,JmpTo17_AllocateObject,JmpTo10_PlaySound,JmpTo21_AnimateSprite,JmpTo11_LoadPLC,JmpTo8_AddPoints,JmpTo7_PlayLevelMusic,JmpTo7_LoadPLC_AnimalExplosion,JmpTo6_ObjectMoveAndFall,JmpTo24_ObjectMove
	include "src/objects/55 OOZ Boss.asm"
	jmpTos JmpTo41_DisplaySprite,JmpTo62_DeleteObject,JmpTo18_AllocateObject,JmpTo38_MarkObjGone,JmpTo11_PlaySound,JmpTo24_AllocateObjectAfterCurrent,JmpTo22_AnimateSprite,JmpTo5_RandomNumber,JmpTo63_Adjust2PArtPointer,JmpTo13_CalcSine,JmpTo8_PlayLevelMusic,JmpTo8_LoadPLC_AnimalExplosion,JmpTo25_ObjectMove

; ---------------------------------------------------------------------------
; Objects: special stage
; ---------------------------------------------------------------------------
	include "src/objects/09 Sonic in Special Stage.asm"
	include "src/objects/63 Special Stage Character Shadow.asm"
	jmpTos JmpTo42_DisplaySprite,JmpTo_SSAllocateObject
	include "src/objects/10 & 88 Tails in Special Stage.asm" ; 88 is Tails' tails
	jmpTos JmpTo43_DisplaySprite,JmpTo23_AnimateSprite
	include "src/objects/60 & 61 Special Stage Rings & Bombs.asm"
	include "src/objects/5B Special Stage Ring Loss.asm"
	include "src/objects/5A Special Stage Messages.asm"
	include "src/objects/59 Special Stage Chaos Emerald.asm"
	jmpTos0 JmpTo44_DisplaySprite,JmpTo63_DeleteObject,JmpTo24_AnimateSprite,JmpTo_SSStartNewAct,JmpTo_CalcAngle,JmpTo14_CalcSine,JmpTo7_ObjectMoveAndFall,JmpTo_SSAllocateObjectAfterCurrent,JmpTo2_SSAllocateObject

; ---------------------------------------------------------------------------
; Object engine: sub-object loading
; ---------------------------------------------------------------------------
	include "src/objects/sub LoadSubObject.asm"
	include "src/objects/sub ObjCommon.asm" ; Lots of common subroutines for objects in here

; ---------------------------------------------------------------------------
; Badniks
; ---------------------------------------------------------------------------
	include "src/objects/8C Whisp.asm"
	include "src/objects/8D, 8F & 90 Grounder in Wall.asm" ; 8F is the wall, 90 is the debris
	include "src/objects/91 Chop Chop.asm"
	include "src/objects/92 & 93 Spiker.asm" ; 93 is the drill it launches
	include "src/objects/95 Sol.asm"
	include "src/objects/94, 96 & 97 Rexon.asm" ; 97 is the head
	include "src/objects/98 Projectile With Gravity.asm"
	include "src/objects/99 Nebula.asm"
	include "src/objects/9A & 9B Turtloid.asm" ; 9B is the one riding on top
	include "src/objects/9C Balkiry's Jet.asm"
	include "src/objects/9D Coconuts.asm"
	include "src/objects/9E Crawltron.asm"
	include "src/objects/9F & A0 Shellcracker.asm" ; A0 is the claw
	include "src/objects/A1 & A2 Slicer.asm" ; A2 is the pincers
	include "src/objects/A3 Flasher.asm"
	include "src/objects/A4 Asteron.asm"
	include "src/objects/A5 & A6 Spiny.asm" ; A6 is the Spiny on a wall
	include "src/objects/A7, A8, A9, AA & AB Grabber.asm" ; A8 is the legs, A9 is the spool, AA is the string, AB is unused
	include "src/objects/AC Balkiry.asm"
	include "src/objects/AD & AE Clucker.asm" ; AD is the base it comes out of, AE is Clucker itself
	include "src/objects/AF Mecha Sonic.asm"

; ---------------------------------------------------------------------------
; Objects: Sega screen, Tornado, SCZ, WFZ and DEZ
; ---------------------------------------------------------------------------
	include "src/objects/B0 & B1 Sonic on Sega Screen.asm" ; B1 is the trademark hider for JP regions
	include "src/modes/Sega Screen VInt.asm"
	include "src/objects/B2 Tornado.asm"
	include "src/objects/B3 Clouds.asm"
	include "src/objects/B4 WFZ Vertical Propeller.asm"
	include "src/objects/B5 WFZ Horizontal Propeller.asm"
	include "src/objects/B6 WFZ Tilting Platform.asm"
	include "src/objects/B7 WFZ Huge Laser.asm"
	include "src/objects/B8 WFZ Wall Turret.asm"
	include "src/objects/B9 WFZ Cutscene Laser.asm"
	include "src/objects/BA WFZ Wheel.asm"
	include "src/objects/BB Deleted Object.asm"
	include "src/objects/BC WFZ Escape Jet.asm"
	include "src/objects/BD WFZ Platforms.asm"
	include "src/objects/BE WFZ Lateral Cannon Platform.asm"
	include "src/objects/BF WFZ Destructible Pole.asm"
	include "src/objects/C0 WFZ Launcher.asm"
	include "src/objects/C1 WFZ Breakable Plating.asm" ; animation script is embedded in the code
	include "src/objects/C2 WFZ Rivet Switch.asm"
	include "src/objects/C3 & C4 WFZ Cutscene Smoke.asm"
	include "src/objects/C5 WFZ Boss.asm"
	include "src/objects/C6 Eggman.asm"
	include "src/objects/C8 Crawl.asm"
	include "src/objects/C7 Death Egg Robot.asm" ; Contains macros for a custom animation format, might need more splitting?
	include "src/objects/sub Scale2x.asm"
	jmpTos0 JmpTo5_DisplaySprite3,JmpTo45_DisplaySprite,JmpTo65_DeleteObject,JmpTo19_AllocateObject,JmpTo39_MarkObjGone,JmpTo6_DeleteObject2,JmpTo12_PlaySound,JmpTo25_AllocateObjectAfterCurrent,JmpTo25_AnimateSprite,JmpTo_PlaySoundLocal,JmpTo6_RandomNumber,JmpTo2_MarkObjGone_P1,JmpTo_Pal_FadeToWhite.UpdateColour,JmpTo_LoadTailsDynPLC_Part2,JmpTo_LoadSonicDynPLC_Part2,JmpTo8_MarkObjGone3,JmpTo64_Adjust2PArtPointer,JmpTo5_PlayMusic,JmpTo_Boss_LoadExplosion,JmpTo9_PlatformObject,JmpTo27_SolidObject,JmpTo8_ObjectMoveAndFall,JmpTo26_ObjectMove

; ---------------------------------------------------------------------------
; Objects: credits and prison capsule
; ---------------------------------------------------------------------------
	include "src/objects/8A Credits.asm"
	jmpTos JmpTo65_Adjust2PArtPointer
	include "src/objects/3E Prison Capsule.asm"
	jmpTos JmpTo66_DeleteObject,JmpTo20_AllocateObject

; ---------------------------------------------------------------------------
; Object engine: touch response
; ---------------------------------------------------------------------------
	include "src/objects/sub TouchResponse.asm" ; includes HurtCharacter, KillCharacter, and Boss damage stuff. Maybe split better??
	jmpTos JmpTo_Sonic_ResetOnFloor_Part2,JmpTo_Check_CNZ_bumpers,JmpTo_Touch_Rings

; ---------------------------------------------------------------------------
; Level: animated art, HUD, debug mode
; ---------------------------------------------------------------------------
	include "src/level/Animate Level Graphics.asm"
	jmpTos JmpTo2_NemDecToRAM
	include "src/level/HUD Update.asm"
	jmpTos JmpTo_DrawSprite_2P_Loop,JmpTo_DrawSprite_Loop
	include "src/level/Debug Mode.asm"
	include "src/level/Debug Lists.asm"
	jmpTos JmpTo66_Adjust2PArtPointer

; ---------------------------------------------------------------------------
; Level data: headers, PLCs, collision, layouts
; ---------------------------------------------------------------------------
	include "src/level/zone/Level Headers.asm"
	include "src/level/zone/Pattern Load Cues.asm"
	include "src/level/zone/Collision.asm"
	include "src/level/zone/Layouts.asm"

; ---------------------------------------------------------------------------
; Art
; ---------------------------------------------------------------------------
	include "src/art/Animated Level Art.asm"
	include "src/art/Player.asm"
	include "src/art/Sega and Title Screen.asm"
	include "src/art/General Level.asm"
	include "src/art/Menu.asm"
	include "src/art/Animals.asm"
	include "src/art/Zone Objects.asm"
	include "src/art/Bosses.asm"
	include "src/art/Badniks.asm"
	include "src/art/Ending.asm"

; ---------------------------------------------------------------------------
; Level data: blocks, chunks and tiles
; ---------------------------------------------------------------------------
	include "src/level/zone/Blocks, Chunks and Tiles.asm"

; ---------------------------------------------------------------------------
; Special stage art and data
; ---------------------------------------------------------------------------
	include "src/art/Special Stage.asm"
	include "src/special stage/Data.asm"

; ---------------------------------------------------------------------------
; Level data: rings and object layouts
; ---------------------------------------------------------------------------
	include "src/level/zone/Rings.asm"
	include "src/level/zone/Object Layouts.asm"

; ---------------------------------------------------------------------------
; Sound
; ---------------------------------------------------------------------------
	include "src/sound/Sound Driver Load.asm"
	include "src/compression/Saxman Decompressor.asm"
	include "src/sound/Sound Driver and DAC.asm"
	include "src/sound/Music Bank 1.asm"
	include "src/sound/Music Bank 2.asm"
	include "src/sound/Sound Effects.asm"
; end of 'ROM'
	if padToPowerOfTwo && (*-StartOfRom)&(*-StartOfRom-1)
		cnop	-1,2<<lastbit(*-StartOfRom-1)
		dc.b	$00
paddingSoFar	:= paddingSoFar+1
	else
		even
	endif
EndOfRom:
	if MOMPASS=2
		; "About" because it will be off by the same amount that Size_of_Snd_driver_guess is incorrect (if you changed it), and because I may have missed a small amount of internal padding somewhere
		message "ROM size is $\{EndOfRom-StartOfRom} bytes (\{(EndOfRom-StartOfRom)/1024.0} KiB). About $\{paddingSoFar} bytes are padding. "
	endif
	; share these symbols externally (WARNING: don't rename, move or remove these labels!)
	shared movewZ80CompSize
	END
