; ---------------------------------------------------------------------------
; Subroutine to initialize joypads
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_10EC:
JoypadInit:
	stopZ80
	moveq	#$40,d0
	move.b	d0,(HW_Port_1_Control).l	; init port 1 (joypad 1)
	move.b	d0,(HW_Port_2_Control).l	; init port 2 (joypad 2)
	move.b	d0,(HW_Expansion_Control).l	; init port 3 (expansion/extra)
	startZ80
	rts
; End of function JoypadInit

; ---------------------------------------------------------------------------
; Subroutine to read joypad input, and send it to the RAM
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_111C:
ReadJoypads:
	lea	(Ctrl_1).w,a0	; address where joypad states are written
	lea	(HW_Port_1_Data).l,a1	; first joypad port
	bsr.s	Joypad_Read		; do the first joypad
	addq.w	#2,a1			; do the second joypad

; sub_112A:
Joypad_Read:
	move.b	#0,(a1)
	nop
	nop
	move.b	(a1),d0
	lsl.b	#2,d0
	andi.b	#$C0,d0
	move.b	#$40,(a1)
	nop
	nop
	move.b	(a1),d1
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	move.b	(a0),d1
	eor.b	d0,d1
	move.b	d0,(a0)+
	and.b	d0,d1
	move.b	d1,(a0)+
	rts
; End of function Joypad_Read


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1158:
VDPSetupGame:
	lea	(VDP_control_port).l,a0
	lea	(VDP_data_port).l,a1
	lea	(VDPSetupArray).l,a2
	moveq	#bytesToWcnt(VDPSetupArray_End-VDPSetupArray),d7
; loc_116C:
VDP_Loop:
	move.w	(a2)+,(a0)
	dbf	d7,VDP_Loop	; set the VDP registers

	move.w	(VDPSetupArray+2).l,d0
	move.w	d0,(VDP_Reg1_val).w
	move.w	#$8A00+223,(Hint_counter_reserve).w	; H-INT every 224th scanline
	moveq	#0,d0

	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.w	d0,(a1)
	move.w	d0,(a1)

	move.l	#vdpComm($0000,CRAM,WRITE),(VDP_control_port).l

	move.w	#bytesToWcnt(palette_line_size*4),d7
; loc_11A0:
VDP_ClrCRAM:
	move.w	d0,(a1)
	dbf	d7,VDP_ClrCRAM	; clear	the CRAM

	clr.l	(Vscroll_Factor).w
	clr.l	(unk_F61A).w
	move.l	d1,-(sp)

	dmaFillVRAM 0,$0000,$10000	; fill entire VRAM with 0

	move.l	(sp)+,d1
	rts
; End of function VDPSetupGame

; ===========================================================================
; word_11E2:
VDPSetupArray:
	dc.w $8004		; H-INT disabled
	dc.w $8134		; Genesis mode, DMA enabled, VBLANK-INT enabled
	dc.w $8200|(VRAM_Plane_A_Name_Table/$400)	; PNT A base: $C000
	dc.w $8328		; PNT W base: $A000
	dc.w $8400|(VRAM_Plane_B_Name_Table/$2000)	; PNT B base: $E000
	dc.w $8500|(VRAM_Sprite_Attribute_Table/$200)	; Sprite attribute table base: $F800
	dc.w $8600
	dc.w $8700		; Background palette/color: 0/0
	dc.w $8800
	dc.w $8900
	dc.w $8A00		; H-INT every scanline
	dc.w $8B00		; EXT-INT off, V scroll by screen, H scroll by screen
	dc.w $8C81		; H res 40 cells, no interlace, S/H disabled
	dc.w $8D00|(VRAM_Horiz_Scroll_Table/$400)	; H scroll table base: $FC00
	dc.w $8E00
	dc.w $8F02		; VRAM pointer increment: $0002
	dc.w $9001		; Scroll table size: 64x32
	dc.w $9100		; Disable window
	dc.w $9200		; Disable window
VDPSetupArray_End:

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1208:
ClearScreen:
	stopZ80

	dmaFillVRAM 0,$0000,$40		; Fill first $40 bytes of VRAM with 0
	dmaFillVRAM 0,VRAM_Plane_A_Name_Table,VRAM_Plane_Table_Size	; Clear Plane A pattern name table
	dmaFillVRAM 0,VRAM_Plane_B_Name_Table,VRAM_Plane_Table_Size	; Clear Plane B pattern name table

	tst.w	(Two_player_mode).w
	beq.s	+

	dmaFillVRAM 0,VRAM_Plane_A_Name_Table_2P,VRAM_Plane_Table_Size
+
	clr.l	(Vscroll_Factor).w
	clr.l	(unk_F61A).w

	; Bug: These '+4's shouldn't be here; clearRAM accidentally clears an additional 4 bytes
	clearRAM Sprite_Table,Sprite_Table_End+4
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf_End+4

	startZ80
	rts
; End of function ClearScreen


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; JumpTo load the sound driver
; sub_130A:
JmpTo_SoundDriverLoad 
	nop
	jmp	(SoundDriverLoad).l
; End of function JmpTo_SoundDriverLoad
