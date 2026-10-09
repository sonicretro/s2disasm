; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_49BC:
LoadCollisionIndexes:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	lsl.w	#2,d0
	move.l	#Primary_Collision,(Collision_addr).w
	move.w	d0,-(sp)
	movea.l	Off_ColP(pc,d0.w),a0
	lea	(Primary_Collision).w,a1
	bsr.w	KosDec
	move.w	(sp)+,d0
	movea.l	Off_ColS(pc,d0.w),a0
	lea	(Secondary_Collision).w,a1
	bra.w	KosDec
; End of function LoadCollisionIndexes

; ===========================================================================
; ---------------------------------------------------------------------------
; Pointers to primary collision indexes

; Contains an array of pointers to the primary collision index data for each
; level. 1 pointer for each level, pointing the primary collision index.
; ---------------------------------------------------------------------------
Off_ColP: zoneOrderedTable 4,1
	zoneTableEntry.l ColP_EHZHTZ	; EHZ
	zoneTableEntry.l ColP_Invalid	; Zone 1
	zoneTableEntry.l ColP_WZ	; WZ
	zoneTableEntry.l ColP_Invalid	; Zone 3
	zoneTableEntry.l ColP_MTZ	; MTZ1,2
	zoneTableEntry.l ColP_MTZ	; MTZ3
	zoneTableEntry.l ColP_WFZSCZ	; WFZ
	zoneTableEntry.l ColP_EHZHTZ	; HTZ
	zoneTableEntry.l ColP_HPZ	; HPZ
	zoneTableEntry.l ColP_Invalid	; Zone 9
	zoneTableEntry.l ColP_OOZ	; OOZ
	zoneTableEntry.l ColP_MCZ	; MCZ
	zoneTableEntry.l ColP_CNZ	; CNZ
	zoneTableEntry.l ColP_CPZDEZ	; CPZ
	zoneTableEntry.l ColP_CPZDEZ	; DEZ
	zoneTableEntry.l ColP_ARZ	; ARZ
	zoneTableEntry.l ColP_WFZSCZ	; SCZ
    zoneTableEnd

; ---------------------------------------------------------------------------
; Pointers to secondary collision indexes

; Contains an array of pointers to the secondary collision index data for
; each level. 1 pointer for each level, pointing the secondary collision
; index.
; ---------------------------------------------------------------------------
Off_ColS: zoneOrderedTable 4,1
	zoneTableEntry.l ColS_EHZHTZ	; EHZ
	zoneTableEntry.l ColP_Invalid	; Zone 1
	zoneTableEntry.l ColP_WZ	; WZ
	zoneTableEntry.l ColP_Invalid	; Zone 3
	zoneTableEntry.l ColP_MTZ	; MTZ1,2
	zoneTableEntry.l ColP_MTZ	; MTZ3
	zoneTableEntry.l ColS_WFZSCZ	; WFZ
	zoneTableEntry.l ColS_EHZHTZ	; HTZ
	zoneTableEntry.l ColS_HPZ	; HPZ
	zoneTableEntry.l ColP_Invalid	; Zone 9
	zoneTableEntry.l ColP_OOZ	; OOZ
	zoneTableEntry.l ColP_MCZ	; MCZ
	zoneTableEntry.l ColS_CNZ	; CNZ
	zoneTableEntry.l ColS_CPZDEZ	; CPZ
	zoneTableEntry.l ColS_CPZDEZ	; DEZ
	zoneTableEntry.l ColS_ARZ	; ARZ
	zoneTableEntry.l ColS_WFZSCZ	; SCZ
    zoneTableEnd
