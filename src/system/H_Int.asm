; Start of H-INT code
H_Int:
	tst.w	(Hint_flag).w
	beq.w	H_Int_Done
	tst.w	(Two_player_mode).w
	beq.w	PalToCRAM
	move.w	#0,(Hint_flag).w
	move.l	a5,-(sp)
	move.l	d0,-(sp)

-	move.w	(VDP_control_port).l,d0	; loop start: Wait until we're in the H-blank region
	andi.w	#4,d0
	beq.s	-	; loop end


	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l		; Display disable

	move.w	#$8200|(VRAM_Plane_A_Name_Table_2P/$400),(VDP_control_port).l	; PNT A base: $A000

	; Update V-Scroll.
	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.l	(Vscroll_Factor_P2_HInt).w,(VDP_data_port).l

	stopZ80
    if fixBugs
	; Like in Sonic 3, the sprite tables are page-flipped in two-player mode.
	; This fixes a race-condition where incomplete sprite tables can be uploaded
	; to the VDP on lag frames.

	; Upload the front buffer.
	tst.b	(Current_sprite_table_page).w
	beq.s	+
	dma68kToVDP Sprite_Table_P2,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	bra.s	++
+
	dma68kToVDP Sprite_Table_P2_Alternate,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
+
    else
	dma68kToVDP Sprite_Table_P2,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
    endif
	startZ80

-	move.w	(VDP_control_port).l,d0 ; loop start: Wait until we're in the H-blank region
	andi.w	#4,d0
	beq.s	-	; loop end

	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l		; Display enable
	move.l	(sp)+,d0
	movea.l	(sp)+,a5

H_Int_Done:
	rte


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; game code

; ---------------------------------------------------------------------------
; loc_1000:
PalToCRAM:
	move	#$2700,sr
	move.w	#0,(Hint_flag).w
	movem.l	a0-a1,-(sp)
	lea	(VDP_data_port).l,a1
	lea	(Underwater_palette).w,a0 ; load palette from RAM
	move.l	#vdpComm($0000,CRAM,WRITE),VDP_control_port-VDP_data_port(a1)	; set VDP to write to CRAM address $00
    rept 32
	move.l	(a0)+,(a1)	; move palette to CRAM (all 64 colors at once)
    endm
	move.w	#$8A00|223,VDP_control_port-VDP_data_port(a1)	; Write %1101 %1111 to register 10 (interrupt every 224th line)
	movem.l	(sp)+,a0-a1
	tst.b	(Do_Updates_in_H_int).w
	bne.s	loc_1072
	rte
; ===========================================================================

loc_1072:
	clr.b	(Do_Updates_in_H_int).w
	movem.l	d0-a6,-(sp)
	bsr.w	Do_Updates
	movem.l	(sp)+,d0-a6
	rte

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Input our music/sound selection to the sound driver.

sndDriverInput:
	lea	(Sound_Queue&$00FFFFFF).l,a0
	lea	(Z80_RAM+zAbsVar).l,a1 ; $A01B80

	cmpi.b	#$80,zVar.QueueToPlay(a1)	; If this (zReadyFlag) isn't $80, the driver is processing a previous sound request.
	bne.s	.doSFX	; So we'll wait until at least the next frame before putting anything in there.

	; If there's something in the first music queue slot, then play it.
	_move.b	SoundQueue.Music0(a0),d0
	beq.s	.checkMusic2
	_clr.b	SoundQueue.Music0(a0)
	bra.s	.playMusic
; ---------------------------------------------------------------------------
; loc_10A4:
.checkMusic2:
	; If there's something in the second music queue slot, then play it.
	move.b	SoundQueue.Music1(a0),d0
	beq.s	.doSFX
	clr.b	SoundQueue.Music1(a0)
; loc_10AE:
.playMusic:
	; If this is 'MusID_Pause' or 'MusID_Unpause', then this isn't a real
	; sound ID, and it shouldn't be passed to the driver. Instead, it
	; should be used here to manually set the driver's pause flag.
	move.b	d0,d1
	subi.b	#MusID_Pause,d1
	bcs.s	.isNotPauseCommand
	addi.b	#$7F,d1
	move.b	d1,zVar.StopMusic(a1)
	bra.s	.doSFX
; ---------------------------------------------------------------------------
; loc_10C0:
.isNotPauseCommand:
	; Send the music's sound ID to the driver.
	move.b	d0,zVar.QueueToPlay(a1)
; loc_10C4:
.doSFX:
	; Process the SFX queue.
    if fixBugs
	moveq	#3-1,d1
    else
	; This is too high: there is only room for three bytes in the
	; driver's queue. This causes the first byte of 'VoiceTblPtr' to be
	; overwritten.
	moveq	#4-1,d1
    endif

.loop:
	; If there's no sound queued, skip this slot.
	move.b	SoundQueue.SFX0(a0,d1.w),d0
	beq.s	.skip
	; If this slot in the driver's queue is occupied, skip this slot.
	tst.b	zVar.Queue0(a1,d1.w)
	bne.s	.skip
	; Remove the sound from this queue, and put it in the driver's queue.
	clr.b	SoundQueue.SFX0(a0,d1.w)
	move.b	d0,zVar.Queue0(a1,d1.w)

.skip:
	dbf	d1,.loop

	rts
; End of function sndDriverInput

	jmpTos JmpTo_LoadTilesAsYouMove,JmpTo_SegaScr_VInt
