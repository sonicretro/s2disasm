;---------------------------------------------------------------------------------------
; Player Assets
;---------------------------------------------------------------------------------------
ArtUnc_Sonic:			BINCLUDE	"art/uncompressed/Sonic's art.bin"

ArtUnc_Tails:			BINCLUDE	"art/uncompressed/Tails's art.bin"

MapUnc_Sonic:			include		"mappings/sprite/Sonic.asm"

MapRUnc_Sonic:			include		"mappings/spriteDPLC/Sonic.asm"

ArtNem_Shield:			BINCLUDE	"art/nemesis/Shield.nem"
	even
ArtNem_Invincible_stars:	BINCLUDE	"art/nemesis/Invincibility stars.nem"
	even
ArtUnc_SplashAndDust:		BINCLUDE	"art/uncompressed/Splash and skid dust.bin"

ArtNem_SuperSonic_stars:	BINCLUDE	"art/nemesis/Super Sonic stars.nem"
	even
MapUnc_Tails:			include		"mappings/sprite/Tails.asm"

MapRUnc_Tails:			include		"mappings/spriteDPLC/Tails.asm"

;---------------------------------------------------------------------------------------
; Sega Screen Assets
;---------------------------------------------------------------------------------------
ArtNem_SEGA:			BINCLUDE	"art/nemesis/SEGA.nem"
	even
ArtNem_IntroTrails:		BINCLUDE	"art/nemesis/Shaded blocks from intro.nem"
	even
MapEng_SEGA:			BINCLUDE	"mappings/misc/SEGA mappings.eni"
	even

;---------------------------------------------------------------------------------------
; Title Screen Assets
;---------------------------------------------------------------------------------------
MapEng_TitleScreen:		BINCLUDE	"mappings/misc/Mappings for title screen background.eni"
	even
MapEng_TitleBack:		BINCLUDE	"mappings/misc/Mappings for title screen background 2.eni" ; title screen background (smaller part, water/horizon)
	even
MapEng_TitleLogo:		BINCLUDE	"mappings/misc/Sonic the Hedgehog 2 title screen logo mappings.eni"
	even
ArtNem_Title:			BINCLUDE	"art/nemesis/Main patterns from title screen.nem"
	even
ArtNem_TitleSprites:		BINCLUDE	"art/nemesis/Sonic and Tails from title screen.nem"
	even
ArtNem_MenuJunk:		BINCLUDE	"art/nemesis/A few menu blocks.nem"
	even

;---------------------------------------------------------------------------------------
; General Level Assets
;---------------------------------------------------------------------------------------
ArtNem_Button:			BINCLUDE	"art/nemesis/Button.nem"
	even
ArtNem_VrtclSprng:		BINCLUDE	"art/nemesis/Vertical spring.nem"
	even
ArtNem_HrzntlSprng:		BINCLUDE	"art/nemesis/Horizontal spring.nem"
	even
ArtNem_DignlSprng:		BINCLUDE	"art/nemesis/Diagonal spring.nem"
	even
ArtNem_HUD:			BINCLUDE	"art/nemesis/HUD.nem" ; Score, Rings, Time
	even
ArtNem_Sonic_life_counter:	BINCLUDE	"art/nemesis/Sonic lives counter.nem"
	even
ArtNem_Ring:			BINCLUDE	"art/nemesis/Ring.nem"
	even
ArtNem_Powerups:		BINCLUDE	"art/nemesis/Monitor and contents.nem"
	even
ArtNem_Spikes:			BINCLUDE	"art/nemesis/Spikes.nem"
	even
ArtNem_Numbers:			BINCLUDE	"art/nemesis/Numbers.nem"
	even
ArtNem_Checkpoint:		BINCLUDE	"art/nemesis/Star pole.nem"
	even
ArtNem_Signpost:		BINCLUDE	"art/nemesis/Signpost.nem" ; For one-player mode.
	even
ArtUnc_Signpost:		BINCLUDE	"art/uncompressed/Signpost.bin" ; For two-player mode.
	even
ArtNem_LeverSpring:		BINCLUDE	"art/nemesis/Lever spring.nem"
	even
ArtNem_HorizSpike:		BINCLUDE	"art/nemesis/Long horizontal spike.nem"
	even
ArtNem_BigBubbles:		BINCLUDE	"art/nemesis/Bubble generator.nem" ; Bubble from underwater
	even
ArtNem_Bubbles:			BINCLUDE	"art/nemesis/Bubbles.nem" ; Bubbles from character
	even
ArtUnc_Countdown:		BINCLUDE	"art/uncompressed/Numbers for drowning countdown.bin"
	even
ArtNem_Game_Over:		BINCLUDE	"art/nemesis/Game and Time Over text.nem"
	even
ArtNem_Explosion:		BINCLUDE	"art/nemesis/Explosion.nem"
	even
ArtNem_MilesLife:		BINCLUDE	"art/nemesis/Miles life counter.nem"
	even
ArtNem_Capsule:			BINCLUDE	"art/nemesis/Egg Prison.nem"
	even
ArtNem_ContinueTails:		BINCLUDE	"art/nemesis/Tails on continue screen.nem"
	even
ArtNem_MiniSonic:		BINCLUDE	"art/nemesis/Sonic continue.nem"
	even
ArtNem_TailsLife:		BINCLUDE	"art/nemesis/Tails life counter.nem"
	even
ArtNem_MiniTails:		BINCLUDE	"art/nemesis/Tails continue.nem"
	even

;---------------------------------------------------------------------------------------
; Menu Assets
;---------------------------------------------------------------------------------------
ArtNem_FontStuff:		BINCLUDE	"art/nemesis/Standard font.nem"
	even
ArtNem_1P2PWins:		BINCLUDE	"art/nemesis/1P and 2P wins text from 2P mode.nem"
	even
MapEng_MenuBack:		BINCLUDE	"mappings/misc/Sonic and Miles animated background.eni"
	even
ArtUnc_MenuBack:		BINCLUDE	"art/uncompressed/Sonic and Miles animated background.bin"
	even
ArtNem_TitleCard:		BINCLUDE	"art/nemesis/Title card.nem"
	even
ArtNem_TitleCard2:		BINCLUDE	"art/nemesis/Font using large broken letters.nem"
	even
ArtNem_MenuBox:			BINCLUDE	"art/nemesis/A menu box with a shadow.nem"
	even
ArtNem_LevelSelectPics:		BINCLUDE	"art/nemesis/Pictures in level preview box from level select.nem"
	even
ArtNem_ResultsText:		BINCLUDE	"art/nemesis/End of level results text.nem" ; Text for Sonic or Tails Got Through Act and Bonus/Perfect
	even
ArtNem_SpecialStageResults:	BINCLUDE	"art/nemesis/Special stage results screen art and some emeralds.nem"
	even
ArtNem_Perfect:			BINCLUDE	"art/nemesis/Perfect text.nem"
	even

;---------------------------------------------------------------------------------------
; Small Animal Assets
;---------------------------------------------------------------------------------------
ArtNem_Flicky:			BINCLUDE	"art/nemesis/Flicky.nem"
	even
ArtNem_Squirrel:		BINCLUDE	"art/nemesis/Squirrel.nem" ; Ricky
	even
ArtNem_Mouse:			BINCLUDE	"art/nemesis/Mouse.nem"    ; Micky
	even
ArtNem_Chicken:			BINCLUDE	"art/nemesis/Chicken.nem"  ; Cucky
	even
ArtNem_Monkey:			BINCLUDE	"art/nemesis/Monkey.nem"   ; Wocky
	even
ArtNem_Eagle:			BINCLUDE	"art/nemesis/Eagle.nem"    ; Locky
	even
ArtNem_Pig:			BINCLUDE	"art/nemesis/Pig.nem"      ; Picky
	even
ArtNem_Seal:			BINCLUDE	"art/nemesis/Seal.nem"     ; Rocky
	even
ArtNem_Penguin:			BINCLUDE	"art/nemesis/Penguin.nem"  ; Pecky
	even
ArtNem_Turtle:			BINCLUDE	"art/nemesis/Turtle.nem"   ; Tocky
	even
ArtNem_Bear:			BINCLUDE	"art/nemesis/Bear.nem"     ; Becky
	even
ArtNem_Rabbit:			BINCLUDE	"art/nemesis/Rabbit.nem"   ; Pocky
	even

;---------------------------------------------------------------------------------------
; WFZ Assets
;---------------------------------------------------------------------------------------
ArtNem_WfzSwitch:		BINCLUDE	"art/nemesis/WFZ boss chamber switch.nem" ; Rivet thing that you bust to get inside the ship
	even
ArtNem_BreakPanels:		BINCLUDE	"art/nemesis/Breakaway panels from WFZ.nem"
	even

;---------------------------------------------------------------------------------------
; OOZ Assets
;---------------------------------------------------------------------------------------
ArtNem_SpikyThing:		BINCLUDE	"art/nemesis/Spiked ball from OOZ.nem"
	even
ArtNem_BurnerLid:		BINCLUDE	"art/nemesis/Burner Platform from OOZ.nem"
	even
ArtNem_StripedBlocksVert:	BINCLUDE	"art/nemesis/Striped blocks from CPZ.nem"
	even
ArtNem_Oilfall:			BINCLUDE	"art/nemesis/Cascading oil hitting oil from OOZ.nem"
	even
ArtNem_Oilfall2:		BINCLUDE	"art/nemesis/Cascading oil from OOZ.nem"
	even
ArtNem_BallThing:		BINCLUDE	"art/nemesis/Ball on spring from OOZ (beta holdovers).nem"
	even
ArtNem_LaunchBall:		BINCLUDE	"art/nemesis/Transporter ball from OOZ.nem"
	even
ArtNem_OOZPlatform:		BINCLUDE	"art/nemesis/OOZ collapsing platform.nem"
	even
ArtNem_PushSpring:		BINCLUDE	"art/nemesis/Push spring from OOZ.nem"
	even
ArtNem_OOZSwingPlat:		BINCLUDE	"art/nemesis/Swinging platform from OOZ.nem"
	even
ArtNem_StripedBlocksHoriz:	BINCLUDE	"art/nemesis/4 stripy blocks from OOZ.nem"
	even
ArtNem_OOZElevator:		BINCLUDE	"art/nemesis/Rising platform from OOZ.nem"
	even
ArtNem_OOZFanHoriz:		BINCLUDE	"art/nemesis/Fan from OOZ.nem"
	even
ArtNem_OOZBurn:			BINCLUDE	"art/nemesis/Green flame from OOZ burners.nem"
	even

;---------------------------------------------------------------------------------------
; CNZ Assets
;---------------------------------------------------------------------------------------
ArtNem_CNZSnake:		BINCLUDE	"art/nemesis/Caterpiller platforms from CNZ.nem" ; Patterns for appearing and disappearing string of platforms
	even
ArtNem_CNZBonusSpike:		BINCLUDE	"art/nemesis/Spikey ball from CNZ slots.nem"
	even
ArtNem_BigMovingBlock:		BINCLUDE	"art/nemesis/Moving block from CNZ and CPZ.nem"
	even
ArtNem_CNZElevator:		BINCLUDE	"art/nemesis/CNZ elevator.nem"
	even
ArtNem_CNZCage:			BINCLUDE	"art/nemesis/CNZ slot machine bars.nem"
	even
ArtNem_CNZHexBumper:		BINCLUDE	"art/nemesis/Hexagonal bumper from CNZ.nem"
	even
ArtNem_CNZRoundBumper:		BINCLUDE	"art/nemesis/Round bumper from CNZ.nem"
	even
ArtNem_CNZDiagPlunger:		BINCLUDE	"art/nemesis/Diagonal impulse spring from CNZ.nem"
	even
ArtNem_CNZVertPlunger:		BINCLUDE	"art/nemesis/Vertical impulse spring.nem"
	even
ArtNem_CNZMiniBumper:		BINCLUDE	"art/nemesis/Drop target from CNZ.nem" ; Weird blocks that you hit 3 times to get rid of
	even
ArtNem_CNZFlipper:		BINCLUDE	"art/nemesis/Flippers.nem"
	even
ArtNem_CPZElevator:		BINCLUDE	"art/nemesis/Large moving platform from CNZ.nem"
	even

;---------------------------------------------------------------------------------------
; CPZ Assets
;---------------------------------------------------------------------------------------
ArtNem_WaterSurface:		BINCLUDE	"art/nemesis/Top of water in HPZ and CNZ.nem"
	even
ArtNem_CPZBooster:		BINCLUDE	"art/nemesis/Speed booster from CPZ.nem"
	even
ArtNem_CPZDroplet:		BINCLUDE	"art/nemesis/CPZ worm enemy.nem"
	even
ArtNem_CPZMetalThings:		BINCLUDE	"art/nemesis/CPZ metal things.nem" ; Girder, cylinders
	even
ArtNem_CPZMetalBlock:		BINCLUDE	"art/nemesis/CPZ large moving platform blocks.nem"
	even
ArtNem_ConstructionStripes:	BINCLUDE	"art/nemesis/Stripy blocks from CPZ.nem"
	even
ArtNem_CPZAnimatedBits:		BINCLUDE	"art/nemesis/Small yellow moving platform from CPZ.nem"
	even
ArtNem_CPZStairBlock:		BINCLUDE	"art/nemesis/Moving block from CPZ.nem"
	even
ArtNem_CPZTubeSpring:		BINCLUDE	"art/nemesis/CPZ spintube exit cover.nem"
	even

;---------------------------------------------------------------------------------------
; ARZ Assets
;---------------------------------------------------------------------------------------
ArtNem_WaterSurface2:		BINCLUDE	"art/nemesis/Top of water in ARZ.nem"
	even
ArtNem_Leaves:			BINCLUDE	"art/nemesis/Leaves in ARZ.nem"
	even
ArtNem_ArrowAndShooter:		BINCLUDE	"art/nemesis/Arrow shooter and arrow from ARZ.nem"
	even
ArtNem_ARZBarrierThing:		BINCLUDE	"art/nemesis/One way barrier from ARZ.nem" ; Unused
	even

;---------------------------------------------------------------------------------------
; EHZ Badnik Assets (Part 1) (Why is this split?)
;---------------------------------------------------------------------------------------
ArtNem_Buzzer:			BINCLUDE	"art/nemesis/Buzzer enemy.nem"
	even

;---------------------------------------------------------------------------------------
; OOZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Octus:			BINCLUDE	"art/nemesis/Octopus badnik from OOZ.nem"
	even
ArtNem_Aquis:			BINCLUDE	"art/nemesis/Seahorse from OOZ.nem"
	even

;---------------------------------------------------------------------------------------
; EHZ Badnik Assets (Part 2) (Why?)
;---------------------------------------------------------------------------------------
ArtNem_Masher:			BINCLUDE	"art/nemesis/EHZ Pirahna badnik.nem"
	even

;---------------------------------------------------------------------------------------
; Boss Assets
;---------------------------------------------------------------------------------------
ArtNem_Eggpod:			BINCLUDE	"art/nemesis/Eggpod.nem" ; Robotnik's main ship
	even
ArtNem_CPZBoss:			BINCLUDE	"art/nemesis/CPZ boss.nem"
	even
ArtNem_FieryExplosion:		BINCLUDE	"art/nemesis/Large explosion.nem"
	even
ArtNem_EggpodJets:		BINCLUDE	"art/nemesis/Horizontal jet.nem"
	even
ArtNem_BossSmoke:		BINCLUDE	"art/nemesis/Smoke trail from CPZ and HTZ bosses.nem"
	even
ArtNem_EHZBoss:			BINCLUDE	"art/nemesis/EHZ boss.nem"
	even
ArtNem_EggChoppers:		BINCLUDE	"art/nemesis/Chopper blades for EHZ boss.nem"
	even
ArtNem_HTZBoss:			BINCLUDE	"art/nemesis/HTZ boss.nem"
	even
ArtNem_ARZBoss:			BINCLUDE	"art/nemesis/ARZ boss.nem"
	even
ArtNem_MCZBoss:			BINCLUDE	"art/nemesis/MCZ boss.nem"
	even
ArtNem_CNZBoss:			BINCLUDE	"art/nemesis/CNZ boss.nem"
	even
ArtNem_OOZBoss:			BINCLUDE	"art/nemesis/OOZ boss.nem"
	even
ArtNem_MTZBoss:			BINCLUDE	"art/nemesis/MTZ boss.nem"
	even
ArtUnc_FallingRocks:		BINCLUDE	"art/uncompressed/Falling rocks and stalactites from MCZ.bin"
	even

;---------------------------------------------------------------------------------------
; ARZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Whisp:			BINCLUDE	"art/nemesis/Blowfly from ARZ.nem"
	even
ArtNem_Grounder:		BINCLUDE	"art/nemesis/Grounder from ARZ.nem"
	even
ArtNem_ChopChop:		BINCLUDE	"art/nemesis/Shark from ARZ.nem"
	even

;---------------------------------------------------------------------------------------
; HTZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Rexon:			BINCLUDE	"art/nemesis/Rexxon (lava snake) from HTZ.nem"
	even
ArtNem_Spiker:			BINCLUDE	"art/nemesis/Driller badnik from HTZ.nem"
	even

;---------------------------------------------------------------------------------------
; SCZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Nebula:			BINCLUDE	"art/nemesis/Bomber badnik from SCZ.nem"
	even
ArtNem_Turtloid:		BINCLUDE	"art/nemesis/Turtle badnik from SCZ.nem"
	even

;---------------------------------------------------------------------------------------
; EHZ Badnik Assets (Part 3) (WTF???)
;---------------------------------------------------------------------------------------
ArtNem_Coconuts:		BINCLUDE	"art/nemesis/Coconuts badnik from EHZ.nem"
	even

;---------------------------------------------------------------------------------------
; MCZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Crawlton:		BINCLUDE	"art/nemesis/Snake badnik from MCZ.nem"
	even
ArtNem_Flasher:			BINCLUDE	"art/nemesis/Firefly from MCZ.nem"
	even

;---------------------------------------------------------------------------------------
; MTZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_MtzMantis:		BINCLUDE	"art/nemesis/Praying mantis badnik from MTZ.nem"
	even
ArtNem_Shellcracker:		BINCLUDE	"art/nemesis/Shellcracker badnik from MTZ.nem"
	even
ArtNem_MtzSupernova:		BINCLUDE	"art/nemesis/Exploding star badnik from MTZ.nem"
	even

;---------------------------------------------------------------------------------------
; CPZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_Spiny:			BINCLUDE	"art/nemesis/Weird crawling badnik from CPZ.nem"
	even
ArtNem_Grabber:			BINCLUDE	"art/nemesis/Spider badnik from CPZ.nem"
	even

;---------------------------------------------------------------------------------------
; WFZ Badnik Assets
;---------------------------------------------------------------------------------------
ArtNem_WfzScratch:		BINCLUDE	"art/nemesis/Scratch from WFZ.nem" ; Chicken badnik
	even
ArtNem_Balkrie:			BINCLUDE	"art/nemesis/Balkrie (jet badnik) from SCZ.nem" ; This SCZ badnik is here for some reason.
	even

;---------------------------------------------------------------------------------------
; WFZ/DEZ Assets
; It seems that these were haphazardly thrown together instead of neatly-split like the
; other zones' assets.
;---------------------------------------------------------------------------------------
ArtNem_SilverSonic:		BINCLUDE	"art/nemesis/Silver Sonic.nem"
	even
ArtNem_Tornado:			BINCLUDE	"art/nemesis/The Tornado.nem" ; Sonic's plane.
	even
ArtNem_WfzWallTurret:		BINCLUDE	"art/nemesis/Wall turret from WFZ.nem"
	even
ArtNem_WfzHook:			BINCLUDE	"art/nemesis/Hook on chain from WFZ.nem"
	even
ArtNem_WfzGunPlatform:		BINCLUDE	"art/nemesis/Retracting platform from WFZ.nem"
	even
ArtNem_WfzConveyorBeltWheel:	BINCLUDE	"art/nemesis/Wheel for belt in WFZ.nem"
	even
ArtNem_WfzFloatingPlatform:	BINCLUDE	"art/nemesis/Moving platform from WFZ.nem"
	even
ArtNem_WfzVrtclLazer:		BINCLUDE	"art/nemesis/Unused vertical laser in WFZ.nem"
	even
ArtNem_Clouds:			BINCLUDE	"art/nemesis/Clouds.nem"
	even
ArtNem_WfzHrzntlLazer:		BINCLUDE	"art/nemesis/Red horizontal laser from WFZ.nem"
	even
ArtNem_WfzLaunchCatapult:	BINCLUDE	"art/nemesis/Catapult that shoots Sonic to the side from WFZ.nem"
	even
ArtNem_WfzBeltPlatform:		BINCLUDE	"art/nemesis/Platform on belt in WFZ.nem"
	even
ArtNem_WfzUnusedBadnik:		BINCLUDE	"art/nemesis/Unused badnik from WFZ.nem" ; This is not grouped with the zone's badniks, suggesting that it's not a badnik at all.
	even
ArtNem_WfzVrtclPrpllr:		BINCLUDE	"art/nemesis/Vertical spinning blades in WFZ.nem"
	even
ArtNem_WfzHrzntlPrpllr:		BINCLUDE	"art/nemesis/Horizontal spinning blades in WFZ.nem"
	even
ArtNem_WfzTiltPlatforms:	BINCLUDE	"art/nemesis/Tilting plaforms in WFZ.nem"
	even
ArtNem_WfzThrust:		BINCLUDE	"art/nemesis/Thrust from Robotnik's getaway ship in WFZ.nem"
	even
ArtNem_WFZBoss:			BINCLUDE	"art/nemesis/WFZ boss.nem"
	even
ArtNem_RobotnikUpper:		BINCLUDE	"art/nemesis/Robotnik's head.nem"
	even
ArtNem_RobotnikRunning:		BINCLUDE	"art/nemesis/Robotnik.nem"
	even
ArtNem_RobotnikLower:		BINCLUDE	"art/nemesis/Robotnik's lower half.nem"
	even
ArtNem_DEZWindow:		BINCLUDE	"art/nemesis/Window in back that Robotnik looks through in DEZ.nem"
	even
ArtNem_DEZBoss:			BINCLUDE	"art/nemesis/Eggrobo.nem"
	even
; This last-minute badnik addition was mistakenly included with the WFZ/DEZ assets instead of in its own 'CNZ Badnik Assets' section.
ArtNem_Crawl:			BINCLUDE	"art/nemesis/Bouncer badnik from CNZ.nem"
	even
ArtNem_TornadoThruster:		BINCLUDE	"art/nemesis/Rocket thruster for Tornado.nem"
	even

;---------------------------------------------------------------------------------------
; Ending Assets
;---------------------------------------------------------------------------------------
MapEng_Ending1:			BINCLUDE	"mappings/misc/End of game sequence frame 1.eni"
	even
MapEng_Ending2:			BINCLUDE	"mappings/misc/End of game sequence frame 2.eni"
	even
MapEng_Ending3:			BINCLUDE	"mappings/misc/End of game sequence frame 3.eni"
	even
MapEng_Ending4:			BINCLUDE	"mappings/misc/End of game sequence frame 4.eni"
	even
MapEng_EndingTailsPlane:	BINCLUDE	"mappings/misc/Closeup of Tails flying plane in ending sequence.eni"
	even
MapEng_EndingSonicPlane:	BINCLUDE	"mappings/misc/Closeup of Sonic flying plane in ending sequence.eni"
	even
; Strange unused mappings (duplicates of MapEng_EndGameLogo)
				BINCLUDE	"mappings/misc/Sonic 2 end of game logo.eni"
	even
				BINCLUDE	"mappings/misc/Sonic 2 end of game logo.eni"
	even
				BINCLUDE	"mappings/misc/Sonic 2 end of game logo.eni"
	even
				BINCLUDE	"mappings/misc/Sonic 2 end of game logo.eni"
	even
				BINCLUDE	"mappings/misc/Sonic 2 end of game logo.eni"
	even
				BINCLUDE	"mappings/misc/Sonic 2 end of game logo.eni"
	even
				BINCLUDE	"mappings/misc/Sonic 2 end of game logo.eni"
	even
				BINCLUDE	"mappings/misc/Sonic 2 end of game logo.eni"
	even
				BINCLUDE	"mappings/misc/Sonic 2 end of game logo.eni"
	even

ArtNem_EndingPics:		BINCLUDE	"art/nemesis/Movie sequence at end of game.nem"
	even
ArtNem_EndingFinalTornado:	BINCLUDE	"art/nemesis/Final image of Tornado with it and Sonic facing screen.nem"
	even
ArtNem_EndingMiniTornado:	BINCLUDE	"art/nemesis/Small pictures of Tornado in final ending sequence.nem"
	even
ArtNem_EndingSonic:		BINCLUDE	"art/nemesis/Small pictures of Sonic and final image of Sonic.nem"
	even
ArtNem_EndingSuperSonic:	BINCLUDE	"art/nemesis/Small pictures of Sonic and final image of Sonic in Super Sonic mode.nem"
	even
ArtNem_EndingTails:		BINCLUDE	"art/nemesis/Final image of Tails.nem"
	even
ArtNem_EndingTitle:		BINCLUDE	"art/nemesis/Sonic the Hedgehog 2 image at end of credits.nem"
	even


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; LEVEL ART AND BLOCK MAPPINGS (16x16 and 128x128)
;
; #define BLOCK_TBL_LEN  // table length unknown
; #define BIGBLOCK_TBL_LEN // table length unknown
; typedef uint16_t uword
;
; struct blockMapElement {
;  uword unk : 5;    // u
;  uword patternIndex : 11; };  // i
; // uuuu uiii iiii iiii
;
; blockMapElement (*blockMapTable)[BLOCK_TBL_LEN][4] = 0xFFFF9000
;
; struct bigBlockMapElement {
;  uword : 4
;  uword blockMapIndex : 12; };  //I
; // 0000 IIII IIII IIII
;
; bigBlockMapElement (*bigBlockMapTable)[BIGBLOCK_TBL_LEN][64] = 0xFFFF0000
;
; /*
; This data determines how the level blocks will be constructed graphically. There are
; two kinds of block mappings: 16x16 and 128x128.
;
; 16x16 blocks are made up of four cells arranged in a square (thus, 16x16 pixels).
; Two bytes are used to define each cell, so the block is 8 bytes long. It can be
; represented by the bitmap blockMapElement, of which the members are:
;
; unk
;  These bits have to do with pattern orientation. I do not know their exact
;  meaning.
; patternIndex
;  The pattern's address divided by $20. Otherwise said: an index into the
;  pattern array.
;
; Each mapping can be expressed as an array of four blockMapElements, while the
; whole table is expressed as a two-dimensional array of blockMapElements (blockMapTable).
; The maps are read in left-to-right, top-to-bottom order.
;
; 128x128 maps are basically lists of indices into blockMapTable. The levels are built
; out of these "big blocks", rather than the "small" 16x16 blocks. bigBlockMapTable is,
; predictably, the table of big block mappings.
; Each big block is 8 16x16 blocks, or 16 cells, square. This produces a total of 16
; blocks or 64 cells.
; As noted earlier, each element of the table provides 'i' for blockMapTable[i][j].
; */

; All of these are compressed in the Kosinski format.

BM16_EHZ:	BINCLUDE	"mappings/16x16/EHZ.kos"
ArtKos_EHZ:	BINCLUDE	"art/kosinski/EHZ_HTZ.kos"
BM16_HTZ:	BINCLUDE	"mappings/16x16/HTZ.kos"
ArtKos_HTZ:	BINCLUDE	"art/kosinski/HTZ_Supp.kos" ; HTZ pattern suppliment to EHZ level patterns
BM128_EHZ:	BINCLUDE	"mappings/128x128/EHZ_HTZ.kos"

BM16_MTZ:	BINCLUDE	"mappings/16x16/MTZ.kos"
ArtKos_MTZ:	BINCLUDE	"art/kosinski/MTZ.kos"
BM128_MTZ:	BINCLUDE	"mappings/128x128/MTZ.kos"

BM16_HPZ:	;BINCLUDE	"mappings/16x16/HPZ.kos"
ArtKos_HPZ:	;BINCLUDE	"art/kosinski/HPZ.kos"
BM128_HPZ:	;BINCLUDE	"mappings/128x128/HPZ.kos"

BM16_OOZ:	BINCLUDE	"mappings/16x16/OOZ.kos"
ArtKos_OOZ:	BINCLUDE	"art/kosinski/OOZ.kos"
BM128_OOZ:	BINCLUDE	"mappings/128x128/OOZ.kos"

BM16_MCZ:	BINCLUDE	"mappings/16x16/MCZ.kos"
ArtKos_MCZ:	BINCLUDE	"art/kosinski/MCZ.kos"
BM128_MCZ:	BINCLUDE	"mappings/128x128/MCZ.kos"

BM16_CNZ:	BINCLUDE	"mappings/16x16/CNZ.kos"
ArtKos_CNZ:	BINCLUDE	"art/kosinski/CNZ.kos"
BM128_CNZ:	BINCLUDE	"mappings/128x128/CNZ.kos"

BM16_CPZ:	BINCLUDE	"mappings/16x16/CPZ_DEZ.kos"
ArtKos_CPZ:	BINCLUDE	"art/kosinski/CPZ_DEZ.kos"
BM128_CPZ:	BINCLUDE	"mappings/128x128/CPZ_DEZ.kos"

; This file contains $320 blocks, overflowing the 'Block_table' buffer. This causes
; 'TempArray_LayerDef' to be overwritten with (empty) block data.
; If only 'fixBugs' could fix this...
BM16_ARZ:	BINCLUDE	"mappings/16x16/ARZ.kos"
ArtKos_ARZ:	BINCLUDE	"art/kosinski/ARZ.kos"
BM128_ARZ:	BINCLUDE	"mappings/128x128/ARZ.kos"

BM16_WFZ:	BINCLUDE	"mappings/16x16/WFZ_SCZ.kos"
ArtKos_SCZ:	BINCLUDE	"art/kosinski/WFZ_SCZ.kos"
ArtKos_WFZ:	BINCLUDE	"art/kosinski/WFZ_Supp.kos" ; WFZ pattern suppliment to SCZ tiles
BM128_WFZ:	BINCLUDE	"mappings/128x128/WFZ_SCZ.kos"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;-----------------------------------------------------------------------------------
; Special Stage Assets
;-----------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------
; Exit curve + slope up
;-----------------------------------------------------------------------------------
MapSpec_Rise1:		BINCLUDE	"mappings/special stage/Slope up - Frame 1.bin"
MapSpec_Rise2:		BINCLUDE	"mappings/special stage/Slope up - Frame 2.bin"
MapSpec_Rise3:		BINCLUDE	"mappings/special stage/Slope up - Frame 3.bin"
MapSpec_Rise4:		BINCLUDE	"mappings/special stage/Slope up - Frame 4.bin"
MapSpec_Rise5:		BINCLUDE	"mappings/special stage/Slope up - Frame 5.bin"
MapSpec_Rise6:		BINCLUDE	"mappings/special stage/Slope up - Frame 6.bin"
MapSpec_Rise7:		BINCLUDE	"mappings/special stage/Slope up - Frame 7.bin"
MapSpec_Rise8:		BINCLUDE	"mappings/special stage/Slope up - Frame 8.bin"
MapSpec_Rise9:		BINCLUDE	"mappings/special stage/Slope up - Frame 9.bin"
MapSpec_Rise10:		BINCLUDE	"mappings/special stage/Slope up - Frame 10.bin"
MapSpec_Rise11:		BINCLUDE	"mappings/special stage/Slope up - Frame 11.bin"
MapSpec_Rise12:		BINCLUDE	"mappings/special stage/Slope up - Frame 12.bin"
MapSpec_Rise13:		BINCLUDE	"mappings/special stage/Slope up - Frame 13.bin"
MapSpec_Rise14:		BINCLUDE	"mappings/special stage/Slope up - Frame 14.bin"
MapSpec_Rise15:		BINCLUDE	"mappings/special stage/Slope up - Frame 15.bin"
MapSpec_Rise16:		BINCLUDE	"mappings/special stage/Slope up - Frame 16.bin"
MapSpec_Rise17:		BINCLUDE	"mappings/special stage/Slope up - Frame 17.bin"

;-----------------------------------------------------------------------------------
; Straight path
;-----------------------------------------------------------------------------------
MapSpec_Straight1:	BINCLUDE	"mappings/special stage/Straight path - Frame 1.bin"
MapSpec_Straight2:	BINCLUDE	"mappings/special stage/Straight path - Frame 2.bin"
MapSpec_Straight3:	BINCLUDE	"mappings/special stage/Straight path - Frame 3.bin"
MapSpec_Straight4:	BINCLUDE	"mappings/special stage/Straight path - Frame 4.bin"

;-----------------------------------------------------------------------------------
; Exit curve + slope down
;-----------------------------------------------------------------------------------
MapSpec_Drop1:		BINCLUDE	"mappings/special stage/Slope down - Frame 1.bin"
MapSpec_Drop2:		BINCLUDE	"mappings/special stage/Slope down - Frame 2.bin"
MapSpec_Drop3:		BINCLUDE	"mappings/special stage/Slope down - Frame 3.bin"
MapSpec_Drop4:		BINCLUDE	"mappings/special stage/Slope down - Frame 4.bin"
MapSpec_Drop5:		BINCLUDE	"mappings/special stage/Slope down - Frame 5.bin"
MapSpec_Drop6:		BINCLUDE	"mappings/special stage/Slope down - Frame 6.bin"
MapSpec_Drop7:		BINCLUDE	"mappings/special stage/Slope down - Frame 7.bin"
MapSpec_Drop8:		BINCLUDE	"mappings/special stage/Slope down - Frame 8.bin"
MapSpec_Drop9:		BINCLUDE	"mappings/special stage/Slope down - Frame 9.bin"
MapSpec_Drop10:		BINCLUDE	"mappings/special stage/Slope down - Frame 10.bin"
MapSpec_Drop11:		BINCLUDE	"mappings/special stage/Slope down - Frame 11.bin"
MapSpec_Drop12:		BINCLUDE	"mappings/special stage/Slope down - Frame 12.bin"
MapSpec_Drop13:		BINCLUDE	"mappings/special stage/Slope down - Frame 13.bin"
MapSpec_Drop14:		BINCLUDE	"mappings/special stage/Slope down - Frame 14.bin"
MapSpec_Drop15:		BINCLUDE	"mappings/special stage/Slope down - Frame 15.bin"
MapSpec_Drop16:		BINCLUDE	"mappings/special stage/Slope down - Frame 16.bin"
MapSpec_Drop17:		BINCLUDE	"mappings/special stage/Slope down - Frame 17.bin"

;-----------------------------------------------------------------------------------
; Curved path
;-----------------------------------------------------------------------------------
MapSpec_Turning1:	BINCLUDE	"mappings/special stage/Curve right - Frame 1.bin"
MapSpec_Turning2:	BINCLUDE	"mappings/special stage/Curve right - Frame 2.bin"
MapSpec_Turning3:	BINCLUDE	"mappings/special stage/Curve right - Frame 3.bin"
MapSpec_Turning4:	BINCLUDE	"mappings/special stage/Curve right - Frame 4.bin"
MapSpec_Turning5:	BINCLUDE	"mappings/special stage/Curve right - Frame 5.bin"
MapSpec_Turning6:	BINCLUDE	"mappings/special stage/Curve right - Frame 6.bin"

;-----------------------------------------------------------------------------------
; Exit curve
;-----------------------------------------------------------------------------------
MapSpec_Unturn1:	BINCLUDE	"mappings/special stage/Curve right - Frame 7.bin"
MapSpec_Unturn2:	BINCLUDE	"mappings/special stage/Curve right - Frame 8.bin"
MapSpec_Unturn3:	BINCLUDE	"mappings/special stage/Curve right - Frame 9.bin"
MapSpec_Unturn4:	BINCLUDE	"mappings/special stage/Curve right - Frame 10.bin"
MapSpec_Unturn5:	BINCLUDE	"mappings/special stage/Curve right - Frame 11.bin"

;-----------------------------------------------------------------------------------
; Enter curve
;-----------------------------------------------------------------------------------
MapSpec_Turn1:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 1.bin"
MapSpec_Turn2:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 2.bin"
MapSpec_Turn3:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 3.bin"
MapSpec_Turn4:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 4.bin"
MapSpec_Turn5:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 5.bin"
MapSpec_Turn6:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 6.bin"
MapSpec_Turn7:		BINCLUDE	"mappings/special stage/Begin curve right - Frame 7.bin"

;--------------------------------------------------------------------------------------
; Special stage level patterns
; Note: Only one line of each tile is stored in this archive. The other 7 lines are
;  the same as this one line, so to get the full tiles, each line needs to be
;  duplicated 7 times over.					; ArtKoz_DCA38:
;--------------------------------------------------------------------------------------
ArtKos_Special:			BINCLUDE	"art/kosinski/SpecStag.kos"
	even

ArtNem_SpecialBack:		BINCLUDE	"art/nemesis/Background art for special stage.nem"
	even
MapEng_SpecialBack:		BINCLUDE	"mappings/misc/Main background mappings for special stage.eni"
	even
MapEng_SpecialBackBottom:	BINCLUDE	"mappings/misc/Lower background mappings for special stage.eni"
	even
ArtNem_SpecialHUD:		BINCLUDE	"art/nemesis/Sonic and Miles number text from special stage.nem"
	even
ArtNem_SpecialStart:		BINCLUDE	"art/nemesis/Start text from special stage.nem" ; Also includes checkered flag
	even
ArtNem_SpecialStars:		BINCLUDE	"art/nemesis/Stars in special stage.nem"
	even
ArtNem_SpecialPlayerVSPlayer:	BINCLUDE	"art/nemesis/Special stage Player VS Player text.nem"
	even
ArtNem_SpecialRings:		BINCLUDE	"art/nemesis/Special stage ring art.nem"
	even
ArtNem_SpecialFlatShadow:	BINCLUDE	"art/nemesis/Horizontal shadow from special stage.nem"
	even
ArtNem_SpecialDiagShadow:	BINCLUDE	"art/nemesis/Diagonal shadow from special stage.nem"
	even
ArtNem_SpecialSideShadow:	BINCLUDE	"art/nemesis/Vertical shadow from special stage.nem"
	even
ArtNem_SpecialExplosion:	BINCLUDE	"art/nemesis/Explosion from special stage.nem"
	even
ArtNem_SpecialBomb:		BINCLUDE	"art/nemesis/Bomb from special stage.nem"
	even
ArtNem_SpecialEmerald:		BINCLUDE	"art/nemesis/Emerald from special stage.nem"
	even
ArtNem_SpecialMessages:		BINCLUDE	"art/nemesis/Special stage messages and icons.nem"
	even
ArtNem_SpecialSonicAndTails:	BINCLUDE	"art/nemesis/Sonic and Tails animation frames in special stage.nem" ; [fixBugs] In this file, Tails' arms are tan instead of orange.
	even
ArtNem_SpecialTailsText:	BINCLUDE	"art/nemesis/Tails text patterns from special stage.nem"
	even
MiscKoz_SpecialPerspective:	BINCLUDE	"misc/Special stage object perspective data.kos"
	even
MiscNem_SpecialLevelLayout:	BINCLUDE	"misc/Special stage level layouts.nem"
	even
MiscKoz_SpecialObjectLocations:	BINCLUDE	"misc/Special stage object location lists.kos"
	even
