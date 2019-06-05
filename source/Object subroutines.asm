; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; General routines for objects

; -------------------------------------------------------------------------------
; This runs the code of all the objects that are in Object_RAM
; -------------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_15F9C: ObjectsLoad:
RunObjects:
	tst.b	(Teleport_flag).w
	bne.s	RunObjects_End	; rts
	lea	(Object_RAM).w,a0 ; a0=object

	moveq	#(Dynamic_Object_RAM_End-Object_RAM)/object_size-1,d7 ; run the first $80 objects out of levels
	moveq	#0,d0
	cmpi.b	#GameModeID_Demo,(Game_Mode).w	; demo mode?
	beq.s	+	; if in a level in a demo, branch
	cmpi.b	#GameModeID_Level,(Game_Mode).w	; regular level mode?
	bne.s	RunObject ; if not in a level, branch to RunObject
+
	move.w	#(Object_RAM_End-Object_RAM)/object_size-1,d7	; run the first $90 objects in levels
	tst.w	(Two_player_mode).w
	bne.s	RunObject ; if in 2 player competition mode, branch to RunObject
	
	cmpi.b	#6,(MainCharacter+routine).w
	bhs.s	RunObjectsWhenPlayerIsDead ; if dead, branch
	; continue straight to RunObject
; ---------------------------------------------------------------------------

; -------------------------------------------------------------------------------
; This is THE place where each individual object's code gets called from
; -------------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_15FCC:
RunObject:
	move.b	id(a0),d0	; get the object's ID
	beq.s	RunNextObject ; if it's obj00, skip it

	add.w	d0,d0
	add.w	d0,d0	; d0 = object ID * 4
	movea.l	Obj_Index-4(pc,d0.w),a1	; load the address of the object's code
	jsr	(a1)	; dynamic call! to one of the the entries in Obj_Index
	moveq	#0,d0

; loc_15FDC:
RunNextObject:
	lea	next_object(a0),a0 ; load 0bj address
	dbf	d7,RunObject
; return_15FE4:
RunObjects_End:
	rts

; ---------------------------------------------------------------------------
; this skips certain objects to make enemies and things pause when Sonic dies
; loc_15FE6:
RunObjectsWhenPlayerIsDead:
	moveq	#(Reserved_Object_RAM_End-Reserved_Object_RAM)/object_size-1,d7
	bsr.s	RunObject	; run the first $10 objects normally
	moveq	#(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d7
	bsr.s	RunObjectDisplayOnly ; all objects in this range are paused
	moveq	#(LevelOnly_Object_RAM_End-LevelOnly_Object_RAM)/object_size-1,d7
	bra.s	RunObject	; run the last $10 objects normally

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_15FF2:
RunObjectDisplayOnly:
	moveq	#0,d0
	move.b	id(a0),d0	; get the object's ID
	beq.s	+	; if it's obj00, skip it
	tst.b	render_flags(a0)	; should we render it?
	bpl.s	+			; if not, skip it
	bsr.w	DisplaySprite
+
	lea	next_object(a0),a0 ; load 0bj address
	dbf	d7,RunObjectDisplayOnly
	rts
; End of function RunObjectDisplayOnly

; ===========================================================================
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
ObjPtr_IntroStars:	dc.l Obj0E	; Flashing stars from intro
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
ObjPtr_HUD:		dc.l Obj21	; Score/Rings/Time display (HUD)
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
			dc.l ObjNull	; Obj4C
			dc.l ObjNull	; Obj4D
			dc.l ObjNull	; Obj4E
			dc.l ObjNull	; Obj4F
ObjPtr_Aquis:		dc.l Obj50	; Aquis (seahorse badnik) from OOZ
ObjPtr_CNZBoss:		dc.l Obj51	; CNZ boss
ObjPtr_HTZBoss:		dc.l Obj52	; HTZ boss
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
ObjPtr_BreakablePlating:dc.l ObjC1	; Breakable plating from WFZ / what sonic hangs onto on the back of Robotnic's getaway ship
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

; ---------------------------------------------------------------------------
; Subroutine to make an object move and fall downward increasingly fast
; This moves the object horizontally and vertically
; and also applies gravity to its speed
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16380: ObjectFall:
ObjectMoveAndFall:
	move.l	x_pos(a0),d2	; load x position
	move.l	y_pos(a0),d3	; load y position
	move.w	x_vel(a0),d0	; load x speed
	ext.l	d0
	asl.l	#8,d0	; shift velocity to line up with the middle 16 bits of the 32-bit position
	add.l	d0,d2	; add x speed to x position	; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
	move.w	y_vel(a0),d0	; load y speed
	addi.w	#$38,y_vel(a0)	; increase vertical speed (apply gravity)
	ext.l	d0
	asl.l	#8,d0	; shift velocity to line up with the middle 16 bits of the 32-bit position
	add.l	d0,d3	; add old y speed to y position	; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
	move.l	d2,x_pos(a0)	; store new x position
	move.l	d3,y_pos(a0)	; store new y position
	rts
; End of function ObjectMoveAndFall
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; ---------------------------------------------------------------------------
; Subroutine translating object speed to update object position
; This moves the object horizontally and vertically
; but does not apply gravity to it
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_163AC: SpeedToPos:
ObjectMove:
	move.l	x_pos(a0),d2	; load x position
	move.l	y_pos(a0),d3	; load y position
	move.w	x_vel(a0),d0	; load horizontal speed
	ext.l	d0
	asl.l	#8,d0	; shift velocity to line up with the middle 16 bits of the 32-bit position
	add.l	d0,d2	; add to x-axis position	; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
	move.w	y_vel(a0),d0	; load vertical speed
	ext.l	d0
	asl.l	#8,d0	; shift velocity to line up with the middle 16 bits of the 32-bit position
	add.l	d0,d3	; add to y-axis position	; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
	move.l	d2,x_pos(a0)	; update x-axis position
	move.l	d3,y_pos(a0)	; update y-axis position
	rts
; End of function ObjectMove
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; ---------------------------------------------------------------------------
; Routines to mark an enemy/monitor/ring/platform as destroyed
; ---------------------------------------------------------------------------

; ===========================================================================
; input: a0 = the object
; loc_163D2:
MarkObjGone:
	tst.w	(Two_player_mode).w	; is it two player mode?
	beq.s	+			; if not, branch
	bra.w	DisplaySprite
+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$80+320+$40+$80,d0	; This gives an object $80 pixels of room offscreen before being unloaded (the $40 is there to round up 320 to a multiple of $80)
	bhi.w	+
	bra.w	DisplaySprite

+	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,2(a2,d0.w)
+
	bra.w	DeleteObject
; ===========================================================================
; input: d0 = the object's x position
; loc_1640A:
MarkObjGone2:
	tst.w	(Two_player_mode).w
	beq.s	+
	bra.w	DisplaySprite
+
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$80+320+$40+$80,d0	; This gives an object $80 pixels of room offscreen before being unloaded (the $40 is there to round up 320 to a multiple of $80)
	bhi.w	+
	bra.w	DisplaySprite
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,2(a2,d0.w)
+
	bra.w	DeleteObject
; ===========================================================================
; input: a0 = the object
; does nothing instead of calling DisplaySprite in the case of no deletion
; loc_1643E:
MarkObjGone3:
	tst.w	(Two_player_mode).w
	beq.s	+
	rts
+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$80+320+$40+$80,d0	; This gives an object $80 pixels of room offscreen before being unloaded (the $40 is there to round up 320 to a multiple of $80)
	bhi.w	+
	rts
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,2(a2,d0.w)
+
	bra.w	DeleteObject
; ===========================================================================
; input: a0 = the object
; loc_16472:
MarkObjGone_P1:
	tst.w	(Two_player_mode).w
	bne.s	MarkObjGone_P2
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$80+320+$40+$80,d0	; This gives an object $80 pixels of room offscreen before being unloaded (the $40 is there to round up 320 to a multiple of $80)
	bhi.w	+
	bra.w	DisplaySprite
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,2(a2,d0.w)
+
	bra.w	DeleteObject
; ---------------------------------------------------------------------------
; input: a0 = the object
; loc_164A6:
MarkObjGone_P2:
	move.w	x_pos(a0),d0
	andi.w	#$FF00,d0
	move.w	d0,d1
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$300,d0
	bhi.w	+
	bra.w	DisplaySprite
+
	sub.w	(Camera_X_pos_coarse_P2).w,d1
	cmpi.w	#$300,d1
	bhi.w	+
	bra.w	DisplaySprite
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,2(a2,d0.w)
+
	bra.w	DeleteObject ; useless branch...

; ---------------------------------------------------------------------------
; Subroutine to delete an object
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; freeObject:
DeleteObject:
	movea.l	a0,a1

; sub_164E8:
DeleteObject2:
	moveq	#0,d1

	moveq	#bytesToLcnt(next_object),d0 ; we want to clear up to the next object
	; delete the object by setting all of its bytes to 0
-	move.l	d1,(a1)+
	dbf	d0,-
    if object_size&3
	move.w	d1,(a1)+
    endif

	rts
; End of function DeleteObject2




; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_164F4:
DisplaySprite:
	lea	(Sprite_Table_Input).w,a1
	move.w	priority(a0),d0
	lsr.w	#1,d0
	andi.w	#$380,d0
	adda.w	d0,a1
	cmpi.w	#$7E,(a1)
	bhs.s	return_16510
	addq.w	#2,(a1)
	adda.w	(a1),a1
	move.w	a0,(a1)

return_16510:
	rts
; End of function DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a1 is the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16512:
DisplaySprite2:
	lea	(Sprite_Table_Input).w,a2
	move.w	priority(a1),d0
	lsr.w	#1,d0
	andi.w	#$380,d0
	adda.w	d0,a2
	cmpi.w	#$7E,(a2)
	bhs.s	return_1652E
	addq.w	#2,(a2)
	adda.w	(a2),a2
	move.w	a1,(a2)

return_1652E:
	rts
; End of function DisplaySprite2

; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; and d0 is already (priority/2)&$380
; ---------------------------------------------------------------------------

; loc_16530:
DisplaySprite3:
	lea	(Sprite_Table_Input).w,a1
	adda.w	d0,a1
	cmpi.w	#$7E,(a1)
	bhs.s	return_16542
	addq.w	#2,(a1)
	adda.w	(a1),a1
	move.w	a0,(a1)

return_16542:
	rts

; ---------------------------------------------------------------------------
; Subroutine to animate a sprite using an animation script
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16544:
AnimateSprite:
	moveq	#0,d0
	move.b	anim(a0),d0		; move animation number to d0
	cmp.b	next_anim(a0),d0	; is animation set to change?
	beq.s	Anim_Run		; if not, branch
	move.b	d0,next_anim(a0)	; set next anim to current current
	move.b	#0,anim_frame(a0)	; reset animation
	move.b	#0,anim_frame_duration(a0)	; reset frame duration
; loc_16560:
Anim_Run:
	subq.b	#1,anim_frame_duration(a0)	; subtract 1 from frame duration
	bpl.s	Anim_Wait	; if time remains, branch
	add.w	d0,d0
	adda.w	(a1,d0.w),a1	; calculate address of appropriate animation script
	move.b	(a1),anim_frame_duration(a0)	; load frame duration
	moveq	#0,d1
	move.b	anim_frame(a0),d1	; load current frame number
	move.b	1(a1,d1.w),d0		; read sprite number from script
	bmi.s	Anim_End_FF		; if animation is complete, branch
; loc_1657C:
Anim_Next:
	andi.b	#$7F,d0			; clear sign bit
	move.b	d0,mapping_frame(a0)	; load sprite number
	move.b	status(a0),d1		;* match the orientaion dictated by the object
	andi.b	#3,d1			;* with the orientation used by the object engine
	andi.b	#$FC,render_flags(a0)	;*
	or.b	d1,render_flags(a0)	;*
	addq.b	#1,anim_frame(a0)	; next frame number
; return_1659A:
Anim_Wait:
	rts
; ===========================================================================
; loc_1659C:
Anim_End_FF:
	addq.b	#1,d0		; is the end flag = $FF ?
	bne.s	Anim_End_FE	; if not, branch
	move.b	#0,anim_frame(a0)	; restart the animation
	move.b	1(a1),d0	; read sprite number
	bra.s	Anim_Next
; ===========================================================================
; loc_165AC:
Anim_End_FE:
	addq.b	#1,d0	; is the end flag = $FE ?
	bne.s	Anim_End_FD	; if not, branch
	move.b	2(a1,d1.w),d0	; read the next byte in the script
	sub.b	d0,anim_frame(a0)	; jump back d0 bytes in the script
	sub.b	d0,d1
	move.b	1(a1,d1.w),d0	; read sprite number
	bra.s	Anim_Next
; ===========================================================================
; loc_165C0:
Anim_End_FD:
	addq.b	#1,d0		; is the end flag = $FD ?
	bne.s	Anim_End_FC	; if not, branch
	move.b	2(a1,d1.w),anim(a0)	; read next byte, run that animation
	rts
; ===========================================================================
; loc_165CC:
Anim_End_FC:
	addq.b	#1,d0	; is the end flag = $FC ?
	bne.s	Anim_End_FB	; if not, branch
	addq.b	#2,routine(a0)	; jump to next routine
	move.b	#0,anim_frame_duration(a0)
	addq.b	#1,anim_frame(a0)
	rts
; ===========================================================================
; loc_165E0:
Anim_End_FB:
	addq.b	#1,d0	; is the end flag = $FB ?
	bne.s	Anim_End_FA	; if not, branch
	move.b	#0,anim_frame(a0)	; reset animation
	clr.b	routine_secondary(a0)	; reset 2nd routine counter
	rts
; ===========================================================================
; loc_165F0:
Anim_End_FA:
	addq.b	#1,d0	; is the end flag = $FA ?
	bne.s	Anim_End_F9	; if not, branch
	addq.b	#2,routine_secondary(a0)	; jump to next routine
	rts
; ===========================================================================
; loc_165FA:
Anim_End_F9:
	addq.b	#1,d0	; is the end flag = $F9 ?
	bne.s	Anim_End	; if not, branch
	addq.b	#2,objoff_2A(a0)
; return_16602:
Anim_End:
	rts
; End of function AnimateSprite


; ---------------------------------------------------------------------------
; Subroutine to convert mappings (etc) to proper Megadrive sprites
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16604:
BuildSprites:
	tst.w	(Two_player_mode).w
	bne.w	BuildSprites_2P
	lea	(Sprite_Table).w,a2
	moveq	#0,d5
	moveq	#0,d4
	tst.b	(Level_started_flag).w
	beq.s	+
	jsrto	(BuildHUD).l, JmpTo_BuildHUD
	bsr.w	BuildRings
+
	lea	(Sprite_Table_Input).w,a4
	moveq	#7,d7	; 8 priority levels
; loc_16628:
BuildSprites_LevelLoop:
	tst.w	(a4)	; does this level have any objects?
	beq.w	BuildSprites_NextLevel	; if not, check the next one
	moveq	#2,d6
; loc_16630:
BuildSprites_ObjLoop:
	movea.w	(a4,d6.w),a0 ; a0=object

    if gameRevision=0
	; the additional check prevents a crash triggered by placing an object in debug mode while dead
	; unfortunately, the code it branches *to* causes a crash of its own
	tst.b	id(a0)			; is this object slot occupied?
	beq.w	BuildSprites_Unknown	; if not, branch
	tst.l	mappings(a0)		; does this object have any mappings?
	beq.w	BuildSprites_Unknown	; if not, branch
    else
	; REV01 uses a better branch, but removed the useful check
	tst.b	id(a0)			; is this object slot occupied?
	beq.w	BuildSprites_NextObj	; if not, check next one
    endif

	andi.b	#$7F,render_flags(a0)	; clear on-screen flag
	move.b	render_flags(a0),d0
	move.b	d0,d4
	btst	#6,d0	; is the multi-draw flag set?
	bne.w	BuildSprites_MultiDraw	; if it is, branch
	andi.w	#$C,d0	; is this to be positioned by screen coordinates?
	beq.s	BuildSprites_ScreenSpaceObj	; if it is, branch
	lea	(Camera_X_pos_copy).w,a1
	moveq	#0,d0
	move.b	width_pixels(a0),d0
	move.w	x_pos(a0),d3
	sub.w	(a1),d3
	move.w	d3,d1
	add.w	d0,d1	; is the object right edge to the left of the screen?
	bmi.w	BuildSprites_NextObj	; if it is, branch
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1	; is the object left edge to the right of the screen?
	bge.w	BuildSprites_NextObj	; if it is, branch
	addi.w	#128,d3
	btst	#4,d4		; is the accurate Y check flag set?
	beq.s	BuildSprites_ApproxYCheck	; if not, branch
	moveq	#0,d0
	move.b	y_radius(a0),d0
	move.w	y_pos(a0),d2
	sub.w	4(a1),d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.s	BuildSprites_NextObj	; if the object is above the screen
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.s	BuildSprites_NextObj	; if the object is below the screen
	addi.w	#128,d2
	bra.s	BuildSprites_DrawSprite
; ===========================================================================
; loc_166A6:
BuildSprites_ScreenSpaceObj:
	move.w	y_pixel(a0),d2
	move.w	x_pixel(a0),d3
	bra.s	BuildSprites_DrawSprite
; ===========================================================================
; loc_166B0:
BuildSprites_ApproxYCheck:
	move.w	y_pos(a0),d2
	sub.w	4(a1),d2
	addi.w	#128,d2
	andi.w	#$7FF,d2
	cmpi.w	#-32+128,d2	; assume Y radius to be 32 pixels
	blo.s	BuildSprites_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_NextObj
; loc_166CC:
BuildSprites_DrawSprite:
	movea.l	mappings(a0),a1
	moveq	#0,d1
	btst	#5,d4	; is the static mappings flag set?
	bne.s	+	; if it is, branch
	move.b	mapping_frame(a0),d1
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1	; get number of pieces
	bmi.s	++	; if there are 0 pieces, branch
+
	bsr.w	DrawSprite	; draw the sprite
+
	ori.b	#$80,render_flags(a0)	; set on-screen flag
; loc_166F2:
BuildSprites_NextObj:
	addq.w	#2,d6	; load next object
	subq.w	#2,(a4)	; decrement object count
	bne.w	BuildSprites_ObjLoop	; if there are objects left, repeat
; loc_166FA:
BuildSprites_NextLevel:
	lea	$80(a4),a4	; load next priority level
	dbf	d7,BuildSprites_LevelLoop	; loop
	move.b	d5,(Sprite_count).w
	cmpi.b	#80,d5	; was the sprite limit reached?
	beq.s	+	; if it was, branch
	move.l	#0,(a2)	; set link field to 0
	rts
+
	move.b	#0,-5(a2)	; set link field to 0
	rts
; ===========================================================================
    if gameRevision=0
BuildSprites_Unknown:
	; In the Simon Wai beta, this was a simple BranchTo, but later builds have this mystery line.
	; This may have possibly been a debugging function, for helping the devs detect when an object
	; tried to display with a blank ID or mappings pointer.
	; The latter was actually an issue that plagued Sonic 1, but is (almost) completely absent in this game.
	move.w	(1).w,d0	; causes a crash on hardware because of the word operation at an odd address
	bra.s	BuildSprites_NextObj
    endif
; loc_1671C:
BuildSprites_MultiDraw:
	move.l	a4,-(sp)
	lea	(Camera_X_pos).w,a4
	movea.w	art_tile(a0),a3
	movea.l	mappings(a0),a5
	moveq	#0,d0
	
	; check if object is within X bounds
	move.b	mainspr_width(a0),d0	; load pixel width
	move.w	x_pos(a0),d3
	sub.w	(a4),d3
	move.w	d3,d1
	add.w	d0,d1
	bmi.w	BuildSprites_MultiDraw_NextObj
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1
	bge.w	BuildSprites_MultiDraw_NextObj
	addi.w	#128,d3
	
	; check if object is within Y bounds
	btst	#4,d4
	beq.s	+
	moveq	#0,d0
	move.b	mainspr_height(a0),d0	; load pixel height
	move.w	y_pos(a0),d2
	sub.w	4(a4),d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.w	BuildSprites_MultiDraw_NextObj
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.w	BuildSprites_MultiDraw_NextObj
	addi.w	#128,d2
	bra.s	++
+
	move.w	y_pos(a0),d2
	sub.w	4(a4),d2
	addi.w	#128,d2
	andi.w	#$7FF,d2
	cmpi.w	#-32+128,d2
	blo.s	BuildSprites_MultiDraw_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_MultiDraw_NextObj
+
	moveq	#0,d1
	move.b	mainspr_mapframe(a0),d1	; get current frame
	beq.s	+
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	move.w	d4,-(sp)
	bsr.w	ChkDrawSprite	; draw the sprite
	move.w	(sp)+,d4
+
	ori.b	#$80,render_flags(a0)	; set onscreen flag
	lea	sub2_x_pos(a0),a6
	moveq	#0,d0
	move.b	mainspr_childsprites(a0),d0	; get child sprite count
	subq.w	#1,d0		; if there are 0, go to next object
	bcs.s	BuildSprites_MultiDraw_NextObj

-	swap	d0
	move.w	(a6)+,d3	; get X pos
	sub.w	(a4),d3
	addi.w	#128,d3
	move.w	(a6)+,d2	; get Y pos
	sub.w	4(a4),d2
	addi.w	#128,d2
	andi.w	#$7FF,d2
	addq.w	#1,a6
	moveq	#0,d1
	move.b	(a6)+,d1	; get mapping frame
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	move.w	d4,-(sp)
	bsr.w	ChkDrawSprite
	move.w	(sp)+,d4
+
	swap	d0
	dbf	d0,-	; repeat for number of child sprites
; loc_16804:
BuildSprites_MultiDraw_NextObj:
	movea.l	(sp)+,a4
	bra.w	BuildSprites_NextObj
; End of function BuildSprites


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1680A:
ChkDrawSprite:
	cmpi.b	#80,d5		; has the sprite limit been reached?
	blo.s	DrawSprite_Cont	; if it hasn't, branch
	rts	; otherwise, return
; End of function ChkDrawSprite


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16812:
DrawSprite:
	movea.w	art_tile(a0),a3
	cmpi.b	#80,d5
	bhs.s	DrawSprite_Done
; loc_1681C:
DrawSprite_Cont:
	btst	#0,d4	; is the sprite to be X-flipped?
	bne.s	DrawSprite_FlipX	; if it is, branch
	btst	#1,d4	; is the sprite to be Y-flipped?
	bne.w	DrawSprite_FlipY	; if it is, branch
; loc__1682A:
DrawSprite_Loop:
	move.b	(a1)+,d0
	ext.w	d0
	add.w	d2,d0
	move.w	d0,(a2)+	; set Y pos
	move.b	(a1)+,(a2)+	; set sprite size
	addq.b	#1,d5
	move.b	d5,(a2)+	; set link field
	move.w	(a1)+,d0
	add.w	a3,d0
	move.w	d0,(a2)+	; set art tile and flags
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0	; avoid activating sprite masking
+
	move.w	d0,(a2)+	; set X pos
	dbf	d1,DrawSprite_Loop	; repeat for next sprite
; return_16852:
DrawSprite_Done:
	rts
; ===========================================================================
; loc_16854:
DrawSprite_FlipX:
	btst	#1,d4	; is it to be Y-flipped as well?
	bne.w	DrawSprite_FlipXY	; if it is, branch

-	move.b	(a1)+,d0
	ext.w	d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4	; store size for later use
	move.b	d4,(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$800,d0	; toggle X flip flag
	move.w	d0,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	neg.w	d0	; negate X offset
	move.b	CellOffsets_XFlip(pc,d4.w),d4
	sub.w	d4,d0	; subtract sprite size
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,-

	rts
; ===========================================================================
; offsets for horizontally mirrored sprite pieces
CellOffsets_XFlip:
	dc.b   8,  8,  8,  8	; 4
	dc.b $10,$10,$10,$10	; 8
	dc.b $18,$18,$18,$18	; 12
	dc.b $20,$20,$20,$20	; 16
; offsets for vertically mirrored sprite pieces
CellOffsets_YFlip:
	dc.b   8,$10,$18,$20	; 4
	dc.b   8,$10,$18,$20	; 8
	dc.b   8,$10,$18,$20	; 12
	dc.b   8,$10,$18,$20	; 16
; ===========================================================================
; loc_168B4:
DrawSprite_FlipY:
	move.b	(a1)+,d0
	move.b	(a1),d4
	ext.w	d0
	neg.w	d0
	move.b	CellOffsets_YFlip(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d2,d0
	move.w	d0,(a2)+	; set Y pos
	move.b	(a1)+,(a2)+	; set size
	addq.b	#1,d5
	move.b	d5,(a2)+	; set link field
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$1000,d0	; toggle Y flip flag
	move.w	d0,(a2)+	; set art tile and flags
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+	; set X pos
	dbf	d1,DrawSprite_FlipY
	rts
; ===========================================================================
; offsets for vertically mirrored sprite pieces
CellOffsets_YFlip2:
	dc.b   8,$10,$18,$20	; 4
	dc.b   8,$10,$18,$20	; 8
	dc.b   8,$10,$18,$20	; 12
	dc.b   8,$10,$18,$20	; 16
; ===========================================================================
; loc_168FC:
DrawSprite_FlipXY:
	move.b	(a1)+,d0
	move.b	(a1),d4
	ext.w	d0
	neg.w	d0
	move.b	CellOffsets_YFlip2(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4
	move.b	d4,(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$1800,d0	; toggle X and Y flip flags
	move.w	d0,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	neg.w	d0
	move.b	CellOffsets_XFlip2(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,DrawSprite_FlipXY
	rts
; End of function DrawSprite

; ===========================================================================
; offsets for horizontally mirrored sprite pieces
CellOffsets_XFlip2:
	dc.b   8,  8,  8,  8	; 4
	dc.b $10,$10,$10,$10	; 8
	dc.b $18,$18,$18,$18	; 12
	dc.b $20,$20,$20,$20	; 16
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to convert mappings (etc) to proper Megadrive sprites
; for 2-player (split screen) mode
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1694E:
BuildSprites_2P:
	lea	(Sprite_Table).w,a2
	moveq	#2,d5
	moveq	#0,d4
	move.l	#$1D80F01,(a2)+	; mask all sprites
	move.l	#1,(a2)+
	move.l	#$1D80F02,(a2)+	; from 216px to 248px
	move.l	#0,(a2)+
	tst.b	(Level_started_flag).w
	beq.s	+
	jsrto	(BuildHUD_P1).l, JmpTo_BuildHUD_P1
	bsr.w	BuildRings_P1
+
	lea	(Sprite_Table_Input).w,a4
	moveq	#7,d7
; loc_16982:
BuildSprites_P1_LevelLoop:
	move.w	(a4),d0	; does this priority level have any objects?
	beq.w	BuildSprites_P1_NextLevel	; if not, check next one
	move.w	d0,-(sp)
	moveq	#2,d6
; loc_1698C:
BuildSprites_P1_ObjLoop:
	movea.w	(a4,d6.w),a0 ; a0=object
	tst.b	id(a0)
	beq.w	BuildSprites_P1_NextObj
	andi.b	#$7F,render_flags(a0)
	move.b	render_flags(a0),d0
	move.b	d0,d4
	btst	#6,d0
	bne.w	BuildSprites_P1_MultiDraw
	andi.w	#$C,d0
	beq.s	BuildSprites_P1_ScreenSpaceObj
	lea	(Camera_X_pos).w,a1
	moveq	#0,d0
	move.b	width_pixels(a0),d0
	move.w	x_pos(a0),d3
	sub.w	(a1),d3
	move.w	d3,d1
	add.w	d0,d1
	bmi.w	BuildSprites_P1_NextObj
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1
	bge.s	BuildSprites_P1_NextObj
	addi.w	#128,d3
	btst	#4,d4
	beq.s	BuildSprites_P1_ApproxYCheck
	moveq	#0,d0
	move.b	y_radius(a0),d0
	move.w	y_pos(a0),d2
	sub.w	4(a1),d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.s	BuildSprites_P1_NextObj
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.s	BuildSprites_P1_NextObj
	addi.w	#256,d2
	bra.s	BuildSprites_P1_DrawSprite
; ===========================================================================
; loc_16A00:
BuildSprites_P1_ScreenSpaceObj:
	move.w	y_pixel(a0),d2
	move.w	x_pixel(a0),d3
	addi.w	#128,d2
	bra.s	BuildSprites_P1_DrawSprite
; ===========================================================================
; loc_16A0E:
BuildSprites_P1_ApproxYCheck:
	move.w	y_pos(a0),d2
	sub.w	4(a1),d2
	addi.w	#128,d2
	cmpi.w	#-32+128,d2
	blo.s	BuildSprites_P1_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_P1_NextObj
	addi.w	#128,d2
; loc_16A2A:
BuildSprites_P1_DrawSprite:
	movea.l	mappings(a0),a1
	moveq	#0,d1
	btst	#5,d4
	bne.s	+
	move.b	mapping_frame(a0),d1
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	++
+
	bsr.w	DrawSprite_2P
+
	ori.b	#$80,render_flags(a0)
; loc_16A50:
BuildSprites_P1_NextObj:
	addq.w	#2,d6
	subq.w	#2,(sp)
	bne.w	BuildSprites_P1_ObjLoop
	addq.w	#2,sp
; loc_16A5A:
BuildSprites_P1_NextLevel:
	lea	$80(a4),a4
	dbf	d7,BuildSprites_P1_LevelLoop
	move.b	d5,(Sprite_count).w
	cmpi.b	#80,d5
	bhs.s	+
	move.l	#0,(a2)
	bra.s	BuildSprites_P2
+
	move.b	#0,-5(a2)

; build sprites for player 2

; loc_16A7A:
BuildSprites_P2:
	tst.w	(Hint_flag).w	; has H-int occured yet?
	bne.s	BuildSprites_P2	; if not, wait
	lea	(Sprite_Table_2).w,a2
	moveq	#0,d5
	moveq	#0,d4
	tst.b	(Level_started_flag).w
	beq.s	+
	jsrto	(BuildHUD_P2).l, JmpTo_BuildHUD_P2
	bsr.w	BuildRings_P2
+
	lea	(Sprite_Table_Input).w,a4
	moveq	#7,d7
; loc_16A9C:
BuildSprites_P2_LevelLoop:
	move.w	(a4),d0
	beq.w	BuildSprites_P2_NextLevel
	move.w	d0,-(sp)
	moveq	#2,d6
; loc_16AA6:
BuildSprites_P2_ObjLoop:
	movea.w	(a4,d6.w),a0 ; a0=object
	tst.b	id(a0)
	beq.w	BuildSprites_P2_NextObj
	move.b	render_flags(a0),d0
	move.b	d0,d4
	btst	#6,d0
	bne.w	BuildSprites_P2_MultiDraw
	andi.w	#$C,d0
	beq.s	BuildSprites_P2_ScreenSpaceObj
	lea	(Camera_X_pos_P2).w,a1
	moveq	#0,d0
	move.b	width_pixels(a0),d0
	move.w	x_pos(a0),d3
	sub.w	(a1),d3
	move.w	d3,d1
	add.w	d0,d1
	bmi.w	BuildSprites_P2_NextObj
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1
	bge.s	BuildSprites_P2_NextObj
	addi.w	#128,d3
	btst	#4,d4
	beq.s	BuildSprites_P2_ApproxYCheck
	moveq	#0,d0
	move.b	y_radius(a0),d0
	move.w	y_pos(a0),d2
	sub.w	4(a1),d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.s	BuildSprites_P2_NextObj
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.s	BuildSprites_P2_NextObj
	addi.w	#256+224,d2
	bra.s	BuildSprites_P2_DrawSprite
; ===========================================================================
; loc_16B14:
BuildSprites_P2_ScreenSpaceObj:
	move.w	y_pixel(a0),d2
	move.w	x_pixel(a0),d3
	addi.w	#$160,d2
	bra.s	BuildSprites_P2_DrawSprite
; ===========================================================================
; loc_16B22:
BuildSprites_P2_ApproxYCheck:
	move.w	y_pos(a0),d2
	sub.w	4(a1),d2
	addi.w	#128,d2
	cmpi.w	#-32+128,d2
	blo.s	BuildSprites_P2_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_P2_NextObj
	addi.w	#128+224,d2
; loc_16B3E:
BuildSprites_P2_DrawSprite:
	movea.l	mappings(a0),a1
	moveq	#0,d1
	btst	#5,d4
	bne.s	+
	move.b	mapping_frame(a0),d1
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	++
+
	bsr.w	DrawSprite_2P
+
	ori.b	#$80,render_flags(a0)
; loc_16B64:
BuildSprites_P2_NextObj:
	addq.w	#2,d6
	subq.w	#2,(sp)
	bne.w	BuildSprites_P2_ObjLoop
	addq.w	#2,sp
	tst.b	(Teleport_flag).w
	bne.s	BuildSprites_P2_NextLevel
	move.w	#0,(a4)
; loc_16B78:
BuildSprites_P2_NextLevel:
	lea	$80(a4),a4
	dbf	d7,BuildSprites_P2_LevelLoop
	move.b	d5,(Sprite_count).w
	cmpi.b	#80,d5
	beq.s	+
	move.l	#0,(a2)
	rts
+
	move.b	#0,-5(a2)
	rts
; ===========================================================================
; loc_16B9A:
BuildSprites_P1_MultiDraw:
	move.l	a4,-(sp)
	lea	(Camera_X_pos).w,a4
	movea.w	art_tile(a0),a3
	movea.l	mappings(a0),a5
	moveq	#0,d0
	move.b	mainspr_width(a0),d0
	move.w	x_pos(a0),d3
	sub.w	(a4),d3
	move.w	d3,d1
	add.w	d0,d1
	bmi.w	BuildSprites_P1_MultiDraw_NextObj
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1
	bge.w	BuildSprites_P1_MultiDraw_NextObj
	addi.w	#128,d3
	btst	#4,d4
	beq.s	+
	moveq	#0,d0
	move.b	mainspr_height(a0),d0
	move.w	y_pos(a0),d2
	sub.w	4(a4),d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.w	BuildSprites_P1_MultiDraw_NextObj
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.w	BuildSprites_P1_MultiDraw_NextObj
	addi.w	#256,d2
	bra.s	++
+
	move.w	y_pos(a0),d2
	sub.w	4(a4),d2
	addi.w	#128,d2
	cmpi.w	#-32+128,d2
	blo.s	BuildSprites_P1_MultiDraw_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_P1_MultiDraw_NextObj
	addi.w	#128,d2
+
	moveq	#0,d1
	move.b	mainspr_mapframe(a0),d1
	beq.s	+
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	move.w	d4,-(sp)
	bsr.w	ChkDrawSprite_2P
	move.w	(sp)+,d4
+
	ori.b	#$80,render_flags(a0)
	lea	sub2_x_pos(a0),a6
	moveq	#0,d0
	move.b	mainspr_childsprites(a0),d0
	subq.w	#1,d0
	bcs.s	BuildSprites_P1_MultiDraw_NextObj

-	swap	d0
	move.w	(a6)+,d3
	sub.w	(a4),d3
	addi.w	#128,d3
	move.w	(a6)+,d2
	sub.w	4(a4),d2
	addi.w	#256,d2
	addq.w	#1,a6
	moveq	#0,d1
	move.b	(a6)+,d1
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	move.w	d4,-(sp)
	bsr.w	ChkDrawSprite_2P
	move.w	(sp)+,d4
+
	swap	d0
	dbf	d0,-
; loc_16C7E:
BuildSprites_P1_MultiDraw_NextObj:
	movea.l	(sp)+,a4
	bra.w	BuildSprites_P1_NextObj
; ===========================================================================
; loc_16C84:
BuildSprites_P2_MultiDraw:
	move.l	a4,-(sp)
	lea	(Camera_X_pos_P2).w,a4
	movea.w	art_tile(a0),a3
	movea.l	mappings(a0),a5
	moveq	#0,d0
	move.b	mainspr_width(a0),d0
	move.w	x_pos(a0),d3
	sub.w	(a4),d3
	move.w	d3,d1
	add.w	d0,d1
	bmi.w	BuildSprites_P2_MultiDraw_NextObj
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1
	bge.w	BuildSprites_P2_MultiDraw_NextObj
	addi.w	#128,d3
	btst	#4,d4
	beq.s	+
	moveq	#0,d0
	move.b	mainspr_height(a0),d0
	move.w	y_pos(a0),d2
	sub.w	4(a4),d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.w	BuildSprites_P2_MultiDraw_NextObj
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.w	BuildSprites_P2_MultiDraw_NextObj
	addi.w	#256+224,d2
	bra.s	++
+
	move.w	y_pos(a0),d2
	sub.w	4(a4),d2
	addi.w	#128,d2
	cmpi.w	#-32+128,d2
	blo.s	BuildSprites_P2_MultiDraw_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_P2_MultiDraw_NextObj
	addi.w	#128+224,d2
+
	moveq	#0,d1
	move.b	mainspr_mapframe(a0),d1
	beq.s	+
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	move.w	d4,-(sp)
	bsr.w	ChkDrawSprite_2P
	move.w	(sp)+,d4
+
	ori.b	#$80,render_flags(a0)
	lea	sub2_x_pos(a0),a6
	moveq	#0,d0
	move.b	mainspr_childsprites(a0),d0
	subq.w	#1,d0
	bcs.s	BuildSprites_P2_MultiDraw_NextObj

-	swap	d0
	move.w	(a6)+,d3
	sub.w	(a4),d3
	addi.w	#128,d3
	move.w	(a6)+,d2
	sub.w	4(a4),d2
	addi.w	#256+224,d2
	addq.w	#1,a6
	moveq	#0,d1
	move.b	(a6)+,d1
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	move.w	d4,-(sp)
	bsr.w	ChkDrawSprite_2P
	move.w	(sp)+,d4
+
	swap	d0
	dbf	d0,-
; loc_16D68:
BuildSprites_P2_MultiDraw_NextObj:
	movea.l	(sp)+,a4
	bra.w	BuildSprites_P2_NextObj

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; adjust art pointer of object at a0 for 2-player mode
; sub_16D6E:
Adjust2PArtPointer:
	tst.w	(Two_player_mode).w
	beq.s	+ ; rts
	move.w	art_tile(a0),d0
	andi.w	#tile_mask,d0
	lsr.w	#1,d0
	andi.w	#nontile_mask,art_tile(a0)
	add.w	d0,art_tile(a0)
+
	rts
; End of function Adjust2PArtPointer


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; adjust art pointer of object at a1 for 2-player mode
; sub_16D8A:
Adjust2PArtPointer2:
	tst.w	(Two_player_mode).w
	beq.s	+ ; rts
	move.w	art_tile(a1),d0
	andi.w	#tile_mask,d0
	lsr.w	#1,d0
	andi.w	#nontile_mask,art_tile(a1)
	add.w	d0,art_tile(a1)
+
	rts
; End of function Adjust2PArtPointer2


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16DA6:
ChkDrawSprite_2P:
	cmpi.b	#80,d5
	blo.s	DrawSprite_2P_Loop
	rts
; End of function ChkDrawSprite_2P


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; copy sprite art to VRAM, in 2-player mode

; sub_16DAE:
DrawSprite_2P:
	movea.w	art_tile(a0),a3
	cmpi.b	#80,d5
	bhs.s	DrawSprite_2P_Done
	btst	#0,d4
	bne.s	DrawSprite_2P_FlipX
	btst	#1,d4
	bne.w	DrawSprite_2P_FlipY
; loc_16DC6:
DrawSprite_2P_Loop:
	move.b	(a1)+,d0
	ext.w	d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4
	move.b	SpriteSizes_2P(pc,d4.w),(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	a3,d0
	move.w	d0,(a2)+
	move.w	(a1)+,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,DrawSprite_2P_Loop
; return_16DF2:
DrawSprite_2P_Done:
	rts
; ===========================================================================
; cells are double the height in 2P mode, so halve the number of rows

;byte_16DF4:
SpriteSizes_2P:
	dc.b   0,0
	dc.b   1,1
	dc.b   4,4
	dc.b   5,5
	dc.b   8,8
	dc.b   9,9
	dc.b  $C,$C
	dc.b  $D,$D
; ===========================================================================
; loc_16E04:
DrawSprite_2P_FlipX:
	btst	#1,d4
	bne.w	DrawSprite_2P_FlipXY

-	move.b	(a1)+,d0
	ext.w	d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4
	move.b	SpriteSizes_2P(pc,d4.w),(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$800,d0
	move.w	d0,(a2)+
	move.w	(a1)+,d0
	neg.w	d0
	move.b	byte_16E46(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,-

	rts
; ===========================================================================
; offsets for horizontally mirrored sprite pieces (2P)
byte_16E46:
	dc.b   8,  8,  8,  8	; 4
	dc.b $10,$10,$10,$10	; 8
	dc.b $18,$18,$18,$18	; 12
	dc.b $20,$20,$20,$20	; 16
; offsets for vertically mirrored sprite pieces (2P)
byte_16E56:
	dc.b   8,$10,$18,$20	; 4
	dc.b   8,$10,$18,$20	; 8
	dc.b   8,$10,$18,$20	; 12
	dc.b   8,$10,$18,$20	; 16
; ===========================================================================
; loc_16E66:
DrawSprite_2P_FlipY:
	move.b	(a1)+,d0
	move.b	(a1),d4
	ext.w	d0
	neg.w	d0
	move.b	byte_16E56(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4
	move.b	SpriteSizes_2P_2(pc,d4.w),(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$1000,d0
	move.w	d0,(a2)+
	move.w	(a1)+,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,DrawSprite_2P_FlipY
	rts
; ===========================================================================
; cells are double the height in 2P mode, so halve the number of rows

; byte_16EA2:
SpriteSizes_2P_2:
	dc.b   0,0
	dc.b   1,1	; 2
	dc.b   4,4	; 4
	dc.b   5,5	; 6
	dc.b   8,8	; 8
	dc.b   9,9	; 10
	dc.b  $C,$C	; 12
	dc.b  $D,$D	; 14
; offsets for vertically mirrored sprite pieces (2P)
byte_16EB2:
	dc.b   8,$10,$18,$20	; 4
	dc.b   8,$10,$18,$20	; 8
	dc.b   8,$10,$18,$20	; 12
	dc.b   8,$10,$18,$20	; 16
; ===========================================================================
; loc_16EC2:
DrawSprite_2P_FlipXY:
	move.b	(a1)+,d0
	move.b	(a1),d4
	ext.w	d0
	neg.w	d0
	move.b	byte_16EB2(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4
	move.b	SpriteSizes_2P_2(pc,d4.w),(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$1800,d0
	move.w	d0,(a2)+
	move.w	(a1)+,d0
	neg.w	d0
	move.b	byte_16F06(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,DrawSprite_2P_FlipXY
	rts
; End of function DrawSprite_2P

; ===========================================================================
; offsets for horizontally mirrored sprite pieces (2P)
byte_16F06:
	dc.b   8,  8,  8,  8	; 4
	dc.b $10,$10,$10,$10	; 8
	dc.b $18,$18,$18,$18	; 12
	dc.b $20,$20,$20,$20	; 16

; ===========================================================================
; loc_16F16: ; unused/dead code? ; a0=object
	move.w	x_pos(a0),d0
	sub.w	(Camera_X_pos).w,d0
	bmi.s	+
	cmpi.w	#320,d0
	bge.s	+
	move.w	y_pos(a0),d1
	sub.w	(Camera_Y_pos).w,d1
	bmi.s	+
	cmpi.w	#$E0,d1
	bge.s	+
	moveq	#0,d0
	rts
+	moveq	#1,d0
	rts
; ===========================================================================
; loc_16F3E: ; unused/dead code? ; a0=object
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	move.w	x_pos(a0),d0
	sub.w	(Camera_X_pos).w,d0
	add.w	d1,d0
	bmi.s	+
	add.w	d1,d1
	sub.w	d1,d0
	cmpi.w	#320,d0
	bge.s	+
	move.w	y_pos(a0),d1
	sub.w	(Camera_Y_pos).w,d1
	bmi.s	+
	cmpi.w	#$E0,d1
	bge.s	+
	moveq	#0,d0
	rts
+	moveq	#1,d0
	rts
; ===========================================================================

    if gameRevision=1
	nop
    endif

    if ~~removeJmpTos
JmpTo_BuildHUD 
	jmp	(BuildHUD).l
JmpTo_BuildHUD_P1 
	jmp	(BuildHUD_P1).l
JmpTo_BuildHUD_P2 
	jmp	(BuildHUD_P2).l

	align 4
    endif
