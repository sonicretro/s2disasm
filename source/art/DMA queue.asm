; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; DMA queue

; ---------------------------------------------------------------------------
; Subroutine for queueing VDP commands (seems to only queue transfers to VRAM),
; to be issued the next time ProcessDMAQueue is called.
; Can be called a maximum of 18 times before the buffer needs to be cleared
; by issuing the commands (this subroutine DOES check for overflow)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_144E: DMA_68KtoVRAM: QueueCopyToVRAM: QueueVDPCommand: Add_To_DMA_Queue:
QueueDMATransfer:
	movea.l	(VDP_Command_Buffer_Slot).w,a1
	cmpa.w	#VDP_Command_Buffer_Slot,a1
	beq.s	QueueDMATransfer_Done ; return if there's no more room in the buffer

	; piece together some VDP commands and store them for later...
	move.w	#$9300,d0 ; command to specify DMA transfer length & $00FF
	move.b	d3,d0
	move.w	d0,(a1)+ ; store command

	move.w	#$9400,d0 ; command to specify DMA transfer length & $FF00
	lsr.w	#8,d3
	move.b	d3,d0
	move.w	d0,(a1)+ ; store command

	move.w	#$9500,d0 ; command to specify source address & $0001FE
	lsr.l	#1,d1
	move.b	d1,d0
	move.w	d0,(a1)+ ; store command

	move.w	#$9600,d0 ; command to specify source address & $01FE00
	lsr.l	#8,d1
	move.b	d1,d0
	move.w	d0,(a1)+ ; store command

	move.w	#$9700,d0 ; command to specify source address & $FE0000
	lsr.l	#8,d1
	;andi.b	#$7F,d1		; this instruction safely allows source to be in RAM; S3K added this
	move.b	d1,d0
	move.w	d0,(a1)+ ; store command

	andi.l	#$FFFF,d2 ; command to specify destination address and begin DMA
	lsl.l	#2,d2
	lsr.w	#2,d2
	swap	d2
	ori.l	#vdpComm($0000,VRAM,DMA),d2 ; set bits to specify VRAM transfer
	move.l	d2,(a1)+ ; store command

	move.l	a1,(VDP_Command_Buffer_Slot).w ; set the next free slot address
	cmpa.w	#VDP_Command_Buffer_Slot,a1
	beq.s	QueueDMATransfer_Done ; return if there's no more room in the buffer
	move.w	#0,(a1) ; put a stop token at the end of the used part of the buffer
; return_14AA:
QueueDMATransfer_Done:
	rts
; End of function QueueDMATransfer


; ---------------------------------------------------------------------------
; Subroutine for issuing all VDP commands that were queued
; (by earlier calls to QueueDMATransfer)
; Resets the queue when it's done
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_14AC: CopyToVRAM: IssueVDPCommands: Process_DMA: Process_DMA_Queue:
ProcessDMAQueue:
	lea	(VDP_control_port).l,a5
	lea	(VDP_Command_Buffer).w,a1
; loc_14B6:
ProcessDMAQueue_Loop:
	move.w	(a1)+,d0
	beq.s	ProcessDMAQueue_Done ; branch if we reached a stop token
	; issue a set of VDP commands...
	move.w	d0,(a5)		; transfer length
	move.w	(a1)+,(a5)	; transfer length
	move.w	(a1)+,(a5)	; source address
	move.w	(a1)+,(a5)	; source address
	move.w	(a1)+,(a5)	; source address
	move.w	(a1)+,(a5)	; destination
	move.w	(a1)+,(a5)	; destination
	cmpa.w	#VDP_Command_Buffer_Slot,a1
	bne.s	ProcessDMAQueue_Loop ; loop if we haven't reached the end of the buffer
; loc_14CE:
ProcessDMAQueue_Done:
	move.w	#0,(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	rts
; End of function ProcessDMAQueue
