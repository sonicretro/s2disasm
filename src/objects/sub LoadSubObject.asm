; ---------------------------------------------------------------------------
; LoadSubObject
; loads information from a sub-object into this object a0
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_365F4:
LoadSubObject:
	moveq	#0,d0
	move.b	subtype(a0),d0
; loc_365FA:
LoadSubObject_Part2:
	move.w	SubObjData_Index(pc,d0.w),d0
	lea	SubObjData_Index(pc,d0.w),a1
; loc_36602:
LoadSubObject_Part3:
	move.l	(a1)+,mappings(a0)
	move.w	(a1)+,art_tile(a0)
	jsr	(Adjust2PArtPointer).l
	move.b	(a1)+,d0
	or.b	d0,render_flags(a0)
	move.b	(a1)+,priority(a0)
	move.b	(a1)+,width_pixels(a0)
	move.b	(a1),collision_flags(a0)
	addq.b	#2,routine(a0)
	rts

; ===========================================================================
; table that maps from the subtype ID to which address to load the data from
; the format of the data there is
;	dc.l Pointer_To_Sprite_Mappings
;	dc.w VRAM_Location
;	dc.b render_flags, priority, width_pixels, collision_flags
;
; for whatever reason, only Obj8C and later have entries in this table

; off_36628:
SubObjData_Index: offsetTable
	offsetTableEntry.w Obj8C_SubObjData	; $0
	offsetTableEntry.w Obj8D_SubObjData	; $2
	offsetTableEntry.w Obj90_SubObjData	; $4
	offsetTableEntry.w Obj90_SubObjData2	; $6
	offsetTableEntry.w Obj91_SubObjData	; $8
	offsetTableEntry.w Obj92_SubObjData	; $A
	offsetTableEntry.w Invalid_SubObjData	; $C
	offsetTableEntry.w Obj94_SubObjData	; $E
	offsetTableEntry.w Obj94_SubObjData2	; $10
	offsetTableEntry.w Obj99_SubObjData2	; $12
	offsetTableEntry.w Obj99_SubObjData	; $14
	offsetTableEntry.w Obj9A_SubObjData	; $16
	offsetTableEntry.w Obj9B_SubObjData	; $18
	offsetTableEntry.w Obj9C_SubObjData	; $1A
	offsetTableEntry.w Obj9A_SubObjData2	; $1C
	offsetTableEntry.w Obj9D_SubObjData	; $1E
	offsetTableEntry.w Obj9D_SubObjData2	; $20
	offsetTableEntry.w Obj9E_SubObjData	; $22
	offsetTableEntry.w Obj9F_SubObjData	; $24
	offsetTableEntry.w ObjA0_SubObjData	; $26
	offsetTableEntry.w ObjA1_SubObjData	; $28
	offsetTableEntry.w ObjA2_SubObjData	; $2A
	offsetTableEntry.w ObjA3_SubObjData	; $2C
	offsetTableEntry.w ObjA4_SubObjData	; $2E
	offsetTableEntry.w ObjA4_SubObjData2	; $30
	offsetTableEntry.w ObjA5_SubObjData	; $32
	offsetTableEntry.w ObjA6_SubObjData	; $34
	offsetTableEntry.w ObjA7_SubObjData	; $36
	offsetTableEntry.w ObjA7_SubObjData2	; $38
	offsetTableEntry.w ObjA8_SubObjData	; $3A
	offsetTableEntry.w ObjA8_SubObjData2	; $3C
	offsetTableEntry.w ObjA7_SubObjData3	; $3E
	offsetTableEntry.w ObjAC_SubObjData	; $40
	offsetTableEntry.w ObjAD_SubObjData	; $42
	offsetTableEntry.w ObjAD_SubObjData2	; $44
	offsetTableEntry.w ObjAD_SubObjData3	; $46
	offsetTableEntry.w ObjAF_SubObjData2	; $48
	offsetTableEntry.w ObjAF_SubObjData	; $4A
	offsetTableEntry.w ObjB0_SubObjData	; $4C
	offsetTableEntry.w ObjB1_SubObjData	; $4E
	offsetTableEntry.w ObjB2_SubObjData	; $50
	offsetTableEntry.w ObjB2_SubObjData	; $52
	offsetTableEntry.w ObjB2_SubObjData	; $54
	offsetTableEntry.w ObjBC_SubObjData2	; $56
	offsetTableEntry.w ObjBC_SubObjData2	; $58
	offsetTableEntry.w ObjB3_SubObjData	; $5A
	offsetTableEntry.w ObjB2_SubObjData2	; $5C
	offsetTableEntry.w ObjB3_SubObjData	; $5E
	offsetTableEntry.w ObjB3_SubObjData	; $60
	offsetTableEntry.w ObjB3_SubObjData	; $62
	offsetTableEntry.w ObjB4_SubObjData	; $64
	offsetTableEntry.w ObjB5_SubObjData	; $66
	offsetTableEntry.w ObjB5_SubObjData	; $68
	offsetTableEntry.w ObjB6_SubObjData	; $6A
	offsetTableEntry.w ObjB6_SubObjData	; $6C
	offsetTableEntry.w ObjB6_SubObjData	; $6E
	offsetTableEntry.w ObjB6_SubObjData	; $70
	offsetTableEntry.w ObjB7_SubObjData	; $72
	offsetTableEntry.w ObjB8_SubObjData	; $74
	offsetTableEntry.w ObjB9_SubObjData	; $76
	offsetTableEntry.w ObjBA_SubObjData	; $78
	offsetTableEntry.w ObjBB_SubObjData	; $7A
	offsetTableEntry.w ObjBC_SubObjData2	; $7C
	offsetTableEntry.w ObjBD_SubObjData	; $7E
	offsetTableEntry.w ObjBD_SubObjData	; $80
	offsetTableEntry.w ObjBE_SubObjData	; $82
	offsetTableEntry.w ObjBE_SubObjData2	; $84
	offsetTableEntry.w ObjC0_SubObjData	; $86
	offsetTableEntry.w ObjC1_SubObjData	; $88
	offsetTableEntry.w ObjC2_SubObjData	; $8A
	offsetTableEntry.w Invalid_SubObjData2	; $8C
	offsetTableEntry.w ObjB8_SubObjData2	; $8E
	offsetTableEntry.w ObjC3_SubObjData	; $90
	offsetTableEntry.w ObjC5_SubObjData	; $92
	offsetTableEntry.w ObjC5_SubObjData2	; $94
	offsetTableEntry.w ObjC5_SubObjData3	; $96
	offsetTableEntry.w ObjC5_SubObjData3	; $98
	offsetTableEntry.w ObjC5_SubObjData3	; $9A
	offsetTableEntry.w ObjC5_SubObjData3	; $9C
	offsetTableEntry.w ObjC5_SubObjData3	; $9E
	offsetTableEntry.w ObjC6_SubObjData2	; $A0
	offsetTableEntry.w ObjC5_SubObjData4	; $A2
	offsetTableEntry.w ObjAF_SubObjData3	; $A4
	offsetTableEntry.w ObjC6_SubObjData3	; $A6
	offsetTableEntry.w ObjC6_SubObjData4	; $A8
	offsetTableEntry.w ObjC6_SubObjData	; $AA
	offsetTableEntry.w ObjC8_SubObjData	; $AC
