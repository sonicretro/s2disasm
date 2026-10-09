; ---------------------------------------------------------------------------
; OBJECT POINTER ARRAY ; object pointers ; sprite pointers ; object list ; sprite list
;
; This array contains the pointers to all the objects used in the game.
; ---------------------------------------------------------------------------
Obj_Index: ; ObjPtrs: ; loc_1600C:
ObjPtr_Sonic:		dc.l Obj01	; Sonic
ObjPtr_Tails:		dc.l Obj02	; Tails
ObjPtr_PlaneSwitcher:	dc.l Obj03	; Collision plane/layer switcher
ObjPtr_WaterSurface:	dc.l Obj04	; Surface of the water
ObjPtr_TailsTails:	dc.l Obj05	; Tails' tails
ObjPtr_Spiral:		dc.l Obj06	; Rotating cylinder in MTZ, twisting spiral pathway in EHZ
ObjPtr_Oil:		dc.l Obj07	; Oil in OOZ
ObjPtr_SpindashDust:
ObjPtr_Splash:		dc.l Obj08	; Water splash in Aquatic Ruin Zone, Spindash dust
ObjPtr_SonicSS:		dc.l Obj09	; Sonic in Special Stage
ObjPtr_SmallBubbles:	dc.l Obj0A	; Small bubbles from Sonic's face while underwater
ObjPtr_TippingFloor:	dc.l Obj0B	; Section of pipe that tips you off from CPZ
			dc.l Obj0C	; Small floating platform (unused)
ObjPtr_Signpost:	dc.l Obj0D	; End of level signpost
ObjPtr_TitleIntro:	dc.l Obj0E	; Title screen intro animation
ObjPtr_TitleMenu:	dc.l Obj0F	; Title screen menu
ObjPtr_TailsSS:		dc.l Obj10	; Tails in Special Stage
ObjPtr_Bridge:		dc.l Obj11	; Bridge in Emerald Hill Zone and Hidden Palace Zone
ObjPtr_HPZEmerald:	dc.l Obj12	; Emerald from Hidden Palace Zone (unused)
ObjPtr_HPZWaterfall:	dc.l Obj13	; Waterfall in Hidden Palace Zone (unused)
ObjPtr_Seesaw:		dc.l Obj14	; Seesaw from Hill Top Zone
ObjPtr_SwingingPlatform:dc.l Obj15	; Swinging platform from Aquatic Ruin Zone
ObjPtr_HTZLift:		dc.l Obj16	; Diagonally moving lift from HTZ
			dc.l Obj17	; GHZ rotating log helix spikes (from Sonic 1, unused)
ObjPtr_ARZPlatform:
ObjPtr_EHZPlatform:	dc.l Obj18	; Stationary floating platform from ARZ and EHZ
ObjPtr_CPZPlatform:
ObjPtr_OOZMovingPform:
ObjPtr_WFZPlatform:	dc.l Obj19	; Platform from CPZ, OOZ and WFZ
ObjPtr_HPZCollapsPform:	dc.l Obj1A	; Collapsing platform from HPZ (and GHZ)
ObjPtr_SpeedBooster:	dc.l Obj1B	; Speed booster from from CPZ
ObjPtr_Scenery:
ObjPtr_BridgeStake:
ObjPtr_FallingOil:	dc.l Obj1C	; Bridge stake in Emerald Hill Zone and Hill Top Zone, falling oil in Oil Ocean Zone
ObjPtr_BlueBalls:	dc.l Obj1D	; Blue balls in CPZ (jumping droplets hazard)
ObjPtr_CPZSpinTube:	dc.l Obj1E	; Spin tube from CPZ
ObjPtr_CollapsPform:	dc.l Obj1F	; Collapsing platform from ARZ, MCZ and OOZ (and MZ, SLZ and SBZ)
ObjPtr_LavaBubble:	dc.l Obj20	; Lava bubble from Hill Top Zone (boss weapon)
ObjPtr_2PResults:	dc.l Obj21	; 2P results
ObjPtr_ArrowShooter:	dc.l Obj22	; Arrow shooter from ARZ
ObjPtr_FallingPillar:	dc.l Obj23	; Pillar that drops its lower part from ARZ
ObjPtr_ARZBubbles:	dc.l Obj24	; Bubbles in Aquatic Ruin Zone
ObjPtr_Ring:		dc.l Obj25	; A ring
ObjPtr_Monitor:		dc.l Obj26	; Monitor
ObjPtr_Explosion:	dc.l Obj27	; An explosion, giving off an animal and 100 points
ObjPtr_Animal:		dc.l Obj28	; Animal and the 100 points from a badnik
ObjPtr_Points:		dc.l Obj29	; "100 points" text
ObjPtr_Stomper:		dc.l Obj2A	; Stomper from MCZ
ObjPtr_RisingPillar:	dc.l Obj2B	; Rising pillar from ARZ
ObjPtr_LeavesGenerator:	dc.l Obj2C	; Sprite that makes leaves fly off when you hit it from ARZ
ObjPtr_Barrier:		dc.l Obj2D	; One way barrier from CPZ and DEZ
ObjPtr_MonitorContents:	dc.l Obj2E	; Monitor contents (code for power-up behavior and rising image)
ObjPtr_SmashableGround:	dc.l Obj2F	; Smashable ground in Hill Top Zone
ObjPtr_RisingLava:	dc.l Obj30	; Large rising lava during earthquake in HTZ
ObjPtr_LavaMarker:	dc.l Obj31	; Lava collision marker
ObjPtr_BreakableBlock:
ObjPtr_BreakableRock:	dc.l Obj32	; Breakable block/rock from CPZ and HTZ
ObjPtr_OOZPoppingPform:	dc.l Obj33	; Green platform from OOZ
ObjPtr_TitleCard:	dc.l Obj34	; level title card (screen with red, yellow, and blue)
ObjPtr_InvStars:	dc.l Obj35	; Invincibility Stars
ObjPtr_Spikes:		dc.l Obj36	; Vertical spikes
ObjPtr_LostRings:	dc.l Obj37	; Scattering rings (generated when Sonic is hurt and has rings)
ObjPtr_Shield:		dc.l Obj38	; Shield
ObjPtr_GameOver:
ObjPtr_TimeOver:	dc.l Obj39	; Game/Time Over text
ObjPtr_Results:		dc.l Obj3A	; End of level results screen
			dc.l Obj3B	; Purple rock (from Sonic 1, unused)
			dc.l Obj3C	; Breakable wall (leftover from S1) (mostly unused)
ObjPtr_OOZLauncher:	dc.l Obj3D	; Block thingy in OOZ that launches you into the round ball things
ObjPtr_EggPrison:	dc.l Obj3E	; Egg prison
ObjPtr_Fan:		dc.l Obj3F	; Fan from OOZ
ObjPtr_Springboard:	dc.l Obj40	; Pressure spring from CPZ, ARZ, and MCZ (the red "diving board" springboard)
ObjPtr_Spring:		dc.l Obj41	; Spring
ObjPtr_SteamSpring:	dc.l Obj42	; Steam Spring from MTZ
ObjPtr_SlidingSpike:	dc.l Obj43	; Sliding spike obstacle thing from OOZ
ObjPtr_RoundBumper:	dc.l Obj44	; Round bumper from Casino Night Zone
ObjPtr_OOZSpring:	dc.l Obj45	; Pressure spring from OOZ
ObjPtr_OOZBall:		dc.l Obj46	; Ball from OOZ (unused, beta leftover)
ObjPtr_Button:		dc.l Obj47	; Button
ObjPtr_LauncherBall:	dc.l Obj48	; Round ball thing from OOZ that fires you off in a different direction
ObjPtr_EHZWaterfall:	dc.l Obj49	; Waterfall from EHZ
ObjPtr_Octus:		dc.l Obj4A	; Octus (octopus badnik) from OOZ
ObjPtr_Buzzer:		dc.l Obj4B	; Buzzer (Buzz bomber) from EHZ
			dc.l ObjNull	; Used to be the "BBat" badnik from HPZ
			dc.l ObjNull	; Used to be the "Stego" badnik
			dc.l ObjNull	; Used to be the "Gator" badnik
			dc.l ObjNull	; Used to be the "Redz" badnik from HPZ
ObjPtr_Aquis:		dc.l Obj50	; Aquis (seahorse badnik) from OOZ
ObjPtr_CNZBoss:		dc.l Obj51	; CNZ boss
ObjPtr_HTZBoss:		dc.l Obj52	; HTZ boss ; Used to be the "BFish" badnik
ObjPtr_MTZBossOrb:	dc.l Obj53	; Shield orbs that surround MTZ boss
ObjPtr_MTZBoss:		dc.l Obj54	; MTZ boss
ObjPtr_OOZBoss:		dc.l Obj55	; OOZ boss
ObjPtr_EHZBoss:		dc.l Obj56	; EHZ boss
ObjPtr_MCZBoss:		dc.l Obj57	; MCZ boss
ObjPtr_BossExplosion:	dc.l Obj58	; Boss explosion
ObjPtr_SSEmerald:	dc.l Obj59	; Emerald from Special Stage
ObjPtr_SSMessage:	dc.l Obj5A	; Messages/checkpoint from Special Stage
ObjPtr_SSRingSpill:	dc.l Obj5B	; Ring spray/spill in Special Stage
ObjPtr_Masher:		dc.l Obj5C	; Masher (jumping piranha fish badnik) from EHZ
ObjPtr_CPZBoss:		dc.l Obj5D	; CPZ boss
ObjPtr_SSHUD:		dc.l Obj5E	; HUD from Special Stage
ObjPtr_StartBanner:
ObjPtr_EndingController:dc.l Obj5F	; Start banner/"Ending controller" from Special Stage
ObjPtr_SSRing:		dc.l Obj60	; Rings from Special Stage
ObjPtr_SSBomb:		dc.l Obj61	; Bombs from Special Stage
			dc.l ObjNull	; Obj62
ObjPtr_SSShadow:	dc.l Obj63	; Character shadow from Special Stage
ObjPtr_MTZTwinStompers:	dc.l Obj64	; Twin stompers from MTZ
ObjPtr_MTZLongPlatform:	dc.l Obj65	; Long moving platform from MTZ
ObjPtr_MTZSpringWall:	dc.l Obj66	; Yellow spring walls from MTZ
ObjPtr_MTZSpinTube:	dc.l Obj67	; Spin tube from MTZ
ObjPtr_SpikyBlock:	dc.l Obj68	; Block with a spike that comes out of each side sequentially from MTZ
ObjPtr_Nut:		dc.l Obj69	; Nut from MTZ
ObjPtr_MCZRotPforms:
ObjPtr_MTZMovingPforms:	dc.l Obj6A	; Platform that moves when you walk off of it, from MTZ
ObjPtr_MTZPlatform:
ObjPtr_CPZSquarePform:	dc.l Obj6B	; Immobile platform from MTZ
ObjPtr_Conveyor:	dc.l Obj6C	; Small platform on pulleys (like at the start of MTZ2)
ObjPtr_FloorSpike:	dc.l Obj6D	; Floor spike from MTZ
ObjPtr_LargeRotPform:	dc.l Obj6E	; Platform moving in a circle (like at the start of MTZ3)
ObjPtr_SSResults:	dc.l Obj6F	; End of special stage results screen
ObjPtr_Cog:		dc.l Obj70	; Giant rotating cog from MTZ
ObjPtr_MTZLavaBubble:
ObjPtr_HPZBridgeStake:
ObjPtr_PulsingOrb:	dc.l Obj71	; Bridge stake and pulsing orb from Hidden Palace Zone
ObjPtr_CNZConveyorBelt:	dc.l Obj72	; Conveyor belt from CNZ
ObjPtr_RotatingRings:	dc.l Obj73	; Solid rotating ring thing from Mystic Cave Zone (mostly unused)
ObjPtr_InvisibleBlock:	dc.l Obj74	; Invisible solid block
ObjPtr_MCZBrick:	dc.l Obj75	; Brick from MCZ
ObjPtr_SlidingSpikes:	dc.l Obj76	; Spike block that slides out of the wall from MCZ
ObjPtr_MCZBridge:	dc.l Obj77	; Bridge from MCZ
ObjPtr_CPZStaircase:	dc.l Obj78	; Stairs from CPZ that move down to open the way
ObjPtr_Starpost:	dc.l Obj79	; Star pole / starpost / checkpoint
ObjPtr_SidewaysPform:	dc.l Obj7A	; Platform that moves back and fourth on top of water in CPZ
ObjPtr_PipeExitSpring:	dc.l Obj7B	; Warp pipe exit spring from CPZ
ObjPtr_CPZPylon:	dc.l Obj7C	; Big pylon in foreground of CPZ
			dc.l Obj7D	; Points that can be gotten at the end of an act (unused leftover from S1)
ObjPtr_SuperSonicStars:	dc.l Obj7E	; Super Sonic's stars
ObjPtr_VineSwitch:	dc.l Obj7F	; Vine switch that you hang off in MCZ
ObjPtr_MovingVine:	dc.l Obj80	; Vine that you hang off and it moves down from MCZ
ObjPtr_MCZDrawbridge:	dc.l Obj81	; Long invisible vertical barrier
ObjPtr_SwingingPform:	dc.l Obj82	; Platform that is usually swinging, from ARZ
ObjPtr_ARZRotPforms:	dc.l Obj83	; 3 adjoined platforms from ARZ that rotate in a circle
ObjPtr_ForcedSpin:
ObjPtr_PinballMode:	dc.l Obj84	; Pinball mode enable/disable (CNZ)
ObjPtr_LauncherSpring:	dc.l Obj85	; Spring from CNZ that you hold jump on to pull back further
ObjPtr_Flipper:		dc.l Obj86	; Flipper from CNZ
ObjPtr_SSNumberOfRings:	dc.l Obj87	; Number of rings in Special Stage
ObjPtr_SSTailsTails:	dc.l Obj88	; Tails' tails in Special Stage
ObjPtr_ARZBoss:		dc.l Obj89	; ARZ boss
			dc.l Obj8A	; Sonic Team Presents/Credits (seemingly unused leftover from S1)
ObjPtr_WFZPalSwitcher:	dc.l Obj8B	; Cycling palette switcher from Wing Fortress Zone
ObjPtr_Whisp:		dc.l Obj8C	; Whisp (blowfly badnik) from ARZ
ObjPtr_GrounderInWall:	dc.l Obj8D	; Grounder in wall, from ARZ
ObjPtr_GrounderInWall2:	dc.l Obj8D	; Obj8E = Obj8D
ObjPtr_GrounderWall:	dc.l Obj8F	; Wall behind which Grounder hides, from ARZ
ObjPtr_GrounderRocks:	dc.l Obj90	; Rocks thrown by Grounder behind wall, from ARZ
ObjPtr_ChopChop:	dc.l Obj91	; Chop Chop (piranha/shark badnik) from ARZ
ObjPtr_Spiker:		dc.l Obj92	; Spiker (drill badnik) from HTZ
ObjPtr_SpikerDrill:	dc.l Obj93	; Drill thrown by Spiker from HTZ
ObjPtr_Rexon:		dc.l Obj94	; Rexon (lava snake badnik), from HTZ
ObjPtr_Sol:		dc.l Obj95	; Sol (fireball-throwing orbit badnik) from HTZ
ObjPtr_Rexon2:		dc.l Obj94	; Obj96 = Obj94
ObjPtr_RexonHead:	dc.l Obj97	; Rexon's head, from HTZ
ObjPtr_Projectile:	dc.l Obj98	; Projectile with optional gravity (EHZ coconut, CPZ spiny, etc.)
ObjPtr_Nebula:		dc.l Obj99	; Nebula (bomber badnik) from SCZ
ObjPtr_Turtloid:	dc.l Obj9A	; Turtloid (turtle badnik) from Sky Chase Zone
ObjPtr_TurtloidRider:	dc.l Obj9B	; Turtloid rider from Sky Chase Zone
ObjPtr_BalkiryJet:	dc.l Obj9C	; Balkiry's jet from Sky Chase Zone
ObjPtr_Coconuts:	dc.l Obj9D	; Coconuts (monkey badnik) from EHZ
ObjPtr_Crawlton:	dc.l Obj9E	; Crawlton (snake badnik) from MCZ
ObjPtr_Shellcracker:	dc.l Obj9F	; Shellcraker (crab badnik) from MTZ
ObjPtr_ShellcrackerClaw:dc.l ObjA0	; Shellcracker's claw from MTZ
ObjPtr_Slicer:		dc.l ObjA1	; Slicer (praying mantis dude) from MTZ
ObjPtr_SlicerPincers:	dc.l ObjA2	; Slicer's pincers from MTZ
ObjPtr_Flasher:		dc.l ObjA3	; Flasher (firefly/glowbug badnik) from MCZ
ObjPtr_Asteron:		dc.l ObjA4	; Asteron (exploding starfish badnik) from MTZ
ObjPtr_Spiny:		dc.l ObjA5	; Spiny (crawling badnik) from CPZ
ObjPtr_SpinyOnWall:	dc.l ObjA6	; Spiny (on wall) from CPZ
ObjPtr_Grabber:		dc.l ObjA7	; Grabber (spider badnik) from CPZ
ObjPtr_GrabberLegs:	dc.l ObjA8	; Grabber's legs from CPZ
ObjPtr_GrabberBox:	dc.l ObjA9	; The little hanger box thing a Grabber's string comes out of
ObjPtr_GrabberString:	dc.l ObjAA	; The thin white string a Grabber hangs from
			dc.l ObjAB	; Unknown (maybe unused?)
ObjPtr_Balkiry:		dc.l ObjAC	; Balkiry (jet badnik) from SCZ
ObjPtr_CluckerBase:	dc.l ObjAD	; Clucker's base from WFZ
ObjPtr_Clucker:		dc.l ObjAE	; Clucker (chicken badnik) from WFZ
ObjPtr_MechaSonic:	dc.l ObjAF	; Mecha Sonic / Silver Sonic from DEZ
ObjPtr_SonicOnSegaScr:	dc.l ObjB0	; Sonic on the Sega screen
ObjPtr_SegaHideTM:	dc.l ObjB1	; Object that hides TM symbol on JP region
ObjPtr_Tornado:		dc.l ObjB2	; The Tornado (Tails' plane)
ObjPtr_Cloud:		dc.l ObjB3	; Clouds (placeable object) from SCZ
ObjPtr_VPropeller:	dc.l ObjB4	; Vertical propeller from WFZ
ObjPtr_HPropeller:	dc.l ObjB5	; Horizontal propeller from WFZ
ObjPtr_TiltingPlatform:	dc.l ObjB6	; Tilting platform from WFZ
ObjPtr_VerticalLaser:	dc.l ObjB7	; Unused huge vertical laser from WFZ
ObjPtr_WallTurret:	dc.l ObjB8	; Wall turret from WFZ
ObjPtr_Laser:		dc.l ObjB9	; Laser from WFZ that shoots down the Tornado
ObjPtr_WFZWheel:	dc.l ObjBA	; Wheel from WFZ
			dc.l ObjBB	; Unknown
ObjPtr_WFZShipFire:	dc.l ObjBC	; Fire coming out of Robotnik's ship in WFZ
ObjPtr_SmallMetalPform:	dc.l ObjBD	; Ascending/descending metal platforms from WFZ
ObjPtr_LateralCannon:	dc.l ObjBE	; Lateral cannon (temporary platform that pops in/out) from WFZ
ObjPtr_WFZStick:	dc.l ObjBF	; Rotaty-stick badnik from WFZ
ObjPtr_SpeedLauncher:	dc.l ObjC0	; Speed launcher from WFZ
ObjPtr_BreakablePlating:dc.l ObjC1	; Breakable plating from WFZ / what Sonic hangs onto on the back of Robotnik's getaway ship
ObjPtr_Rivet:		dc.l ObjC2	; Rivet thing you bust to get into ship at the end of WFZ
ObjPtr_TornadoSmoke:	dc.l ObjC3	; Plane's smoke from WFZ
ObjPtr_TornadoSmoke2:	dc.l ObjC3 	; ObjC4 = ObjC3
ObjPtr_WFZBoss:		dc.l ObjC5	; WFZ boss
ObjPtr_Eggman:		dc.l ObjC6	; Eggman
ObjPtr_Eggrobo:		dc.l ObjC7	; Eggrobo (final boss) from Death Egg
ObjPtr_Crawl:		dc.l ObjC8	; Crawl (shield badnik) from CNZ
ObjPtr_TtlScrPalChanger:dc.l ObjC9	; "Palette changing handler" from title screen
ObjPtr_CutScene:	dc.l ObjCA	; Cut scene at end of game
ObjPtr_EndingSeqClouds:	dc.l ObjCB	; Background clouds from ending sequence
ObjPtr_EndingSeqTrigger:dc.l ObjCC	; Trigger for rescue plane and birds from ending sequence
ObjPtr_EndingSeqBird:	dc.l ObjCD	; Birds from ending sequence
ObjPtr_EndingSeqSonic:
ObjPtr_EndingSeqTails:	dc.l ObjCE	; Sonic and Tails jumping off the plane from ending sequence
ObjPtr_TornadoHelixes:	dc.l ObjCF	;"Plane's helixes" from ending sequence
			dc.l ObjNull	; ObjD0
			dc.l ObjNull	; ObjD1
ObjPtr_CNZRectBlocks:	dc.l ObjD2	; Flashing blocks that appear and disappear in a rectangular shape that you can walk across, from CNZ
ObjPtr_BombPrize:	dc.l ObjD3	; Bomb prize from CNZ
ObjPtr_CNZBigBlock:	dc.l ObjD4	; Big block from CNZ that moves back and fourth
ObjPtr_Elevator:	dc.l ObjD5	; Elevator from CNZ
ObjPtr_PointPokey:	dc.l ObjD6	; Pokey that gives out points from CNZ
ObjPtr_Bumper:		dc.l ObjD7	; Bumper from Casino Night Zone
ObjPtr_BonusBlock:	dc.l ObjD8	; Block thingy from CNZ that disappears after 3 hits
ObjPtr_Grab:		dc.l ObjD9	; Invisible sprite that you can hang on to, like the blocks in WFZ
ObjPtr_ContinueText:
ObjPtr_ContinueIcons:	dc.l ObjDA	; Continue text
ObjPtr_ContinueChars:	dc.l ObjDB	; Sonic lying down or Tails nagging (continue screen)
ObjPtr_RingPrize:	dc.l ObjDC	; Ring prize from Casino Night Zone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 4C, 4D, 4E, 4F, 62, D0, and D1

; Object removed from the game. All it does is deallocate its array.
; ----------------------------------------------------------------------------

ObjNull: ;;
	bra.w	DeleteObject
