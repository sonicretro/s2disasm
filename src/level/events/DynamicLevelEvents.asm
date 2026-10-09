; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; screen resizing, earthquakage, etc

; sub_E5D0:
RunDynamicLevelEvents:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	move.w	DynamicLevelEventIndex(pc,d0.w),d0
	jsr	DynamicLevelEventIndex(pc,d0.w)
	moveq	#2,d1
	move.w	(Camera_Max_Y_pos_target).w,d0
	sub.w	(Camera_Max_Y_pos).w,d0
	beq.s	++	; rts
	bcc.s	+++
	neg.w	d1
	move.w	(Camera_Y_pos).w,d0
	cmp.w	(Camera_Max_Y_pos_target).w,d0
	bls.s	+
	move.w	d0,(Camera_Max_Y_pos).w
	andi.w	#$FFFE,(Camera_Max_Y_pos).w
+
	add.w	d1,(Camera_Max_Y_pos).w
	move.b	#1,(Camera_Max_Y_Pos_Changing).w
+
	rts
; ===========================================================================
+
	move.w	(Camera_Y_pos).w,d0
	addi_.w	#8,d0
	cmp.w	(Camera_Max_Y_pos).w,d0
	blo.s	+
	btst	#status.player.in_air,(MainCharacter+status).w
	beq.s	+
	add.w	d1,d1
	add.w	d1,d1
+
	add.w	d1,(Camera_Max_Y_pos).w
	move.b	#1,(Camera_Max_Y_Pos_Changing).w
	rts
; End of function RunDynamicLevelEvents

; ===========================================================================
; off_E636:
DynamicLevelEventIndex: zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w LevEvents_EHZ	; EHZ
	zoneOffsetTableEntry.w LevEvents_001	; Zone 1
	zoneOffsetTableEntry.w LevEvents_WZ	; WZ
	zoneOffsetTableEntry.w LevEvents_003	; Zone 3
	zoneOffsetTableEntry.w LevEvents_MTZ	; MTZ1,2
	zoneOffsetTableEntry.w LevEvents_MTZ3	; MTZ3
	zoneOffsetTableEntry.w LevEvents_WFZ	; WFZ
	zoneOffsetTableEntry.w LevEvents_HTZ	; HTZ
	zoneOffsetTableEntry.w LevEvents_HPZ	; HPZ
	zoneOffsetTableEntry.w LevEvents_009	; Zone 9
	zoneOffsetTableEntry.w LevEvents_OOZ	; OOZ
	zoneOffsetTableEntry.w LevEvents_MCZ	; MCZ
	zoneOffsetTableEntry.w LevEvents_CNZ	; CNZ
	zoneOffsetTableEntry.w LevEvents_CPZ	; CPZ
	zoneOffsetTableEntry.w LevEvents_DEZ	; DEZ
	zoneOffsetTableEntry.w LevEvents_ARZ	; ARZ
	zoneOffsetTableEntry.w LevEvents_SCZ	; SCZ
    zoneTableEnd
; ===========================================================================
	include "src/level/events/EHZ.asm"
	include "src/level/events/Unused and WZ.asm"
	include "src/level/events/MTZ.asm"
	include "src/level/events/WFZ.asm"
	include "src/level/events/HTZ.asm"
	include "src/level/events/HPZ.asm"
	include "src/level/events/OOZ.asm"
	include "src/level/events/MCZ.asm"
	include "src/level/events/CNZ.asm"
	include "src/level/events/CPZ.asm"
	include "src/level/events/DEZ.asm"
	include "src/level/events/ARZ.asm"
	include "src/level/events/SCZ.asm"
; ===========================================================================
