; ----------------------------------------------------------------------------
; custom dynamic pattern loading cues for special stage Sonic, Tails and
; Tails' tails
; The first $12 frames are for Sonic, and the next $12 frames are for Tails.
; The last $15 frames are for Tails' tails.
; The first $24 frames are almost normal dplcs -- the only difference being
; that the art tile to load is pre-shifted left by 4 bits.
; The same applies to the last $15 frames, but they have yet another difference:
; a small space optimization. These frames only have one dplc per frame ever,
; hence the two-byte dplc count is removed from each frame.
; ----------------------------------------------------------------------------
	pushv ,SonicDplcVer	; Backup previous value of SonicDplcVer
SonicDplcVer := 4		; Switch to custom DPLC format

Obj09_MapRUnc_345FA:	mappingsTable
	mappingsTableEntry.w	.sonic_0
	mappingsTableEntry.w	.sonic_1
	mappingsTableEntry.w	.sonic_2
	mappingsTableEntry.w	.sonic_3
	mappingsTableEntry.w	.sonic_4
	mappingsTableEntry.w	.sonic_5
	mappingsTableEntry.w	.sonic_6
	mappingsTableEntry.w	.sonic_7
	mappingsTableEntry.w	.sonic_8
	mappingsTableEntry.w	.sonic_9
	mappingsTableEntry.w	.sonic_10
	mappingsTableEntry.w	.sonic_11
	mappingsTableEntry.w	.sonic_12
	mappingsTableEntry.w	.sonic_13
	mappingsTableEntry.w	.sonic_14
	mappingsTableEntry.w	.sonic_15
	mappingsTableEntry.w	.sonic_16
	mappingsTableEntry.w	.sonic_17

	mappingsTableEntry.w	.tails_0
	mappingsTableEntry.w	.tails_1
	mappingsTableEntry.w	.tails_2
	mappingsTableEntry.w	.tails_3
	mappingsTableEntry.w	.tails_4
	mappingsTableEntry.w	.tails_5
	mappingsTableEntry.w	.tails_6
	mappingsTableEntry.w	.tails_7
	mappingsTableEntry.w	.tails_8
	mappingsTableEntry.w	.tails_9
	mappingsTableEntry.w	.tails_10
	mappingsTableEntry.w	.tails_11
	mappingsTableEntry.w	.tails_12
	mappingsTableEntry.w	.tails_13
	mappingsTableEntry.w	.tails_14
	mappingsTableEntry.w	.tails_15
	mappingsTableEntry.w	.tails_16
	mappingsTableEntry.w	.tails_17

	mappingsTableEntry.w	.tails_tails_0
	mappingsTableEntry.w	.tails_tails_1
	mappingsTableEntry.w	.tails_tails_2
	mappingsTableEntry.w	.tails_tails_3
	mappingsTableEntry.w	.tails_tails_4
	mappingsTableEntry.w	.tails_tails_5
	mappingsTableEntry.w	.tails_tails_6
	mappingsTableEntry.w	.tails_tails_7
	mappingsTableEntry.w	.tails_tails_8
	mappingsTableEntry.w	.tails_tails_9
	mappingsTableEntry.w	.tails_tails_10
	mappingsTableEntry.w	.tails_tails_11
	mappingsTableEntry.w	.tails_tails_12
	mappingsTableEntry.w	.tails_tails_13
	mappingsTableEntry.w	.tails_tails_14
	mappingsTableEntry.w	.tails_tails_15
	mappingsTableEntry.w	.tails_tails_16
	mappingsTableEntry.w	.tails_tails_17
	mappingsTableEntry.w	.tails_tails_18
	mappingsTableEntry.w	.tails_tails_19
	mappingsTableEntry.w	.tails_tails_20

.sonic_0:	dplcHeader
	dplcEntry	$10, 0
	dplcEntry	9, $10
	dplcEntry	2, $19
.sonic_0_End

.sonic_1:	dplcHeader
	dplcEntry	9, $1B
	dplcEntry	8, $24
	dplcEntry	4, $2C
.sonic_1_End

.sonic_2:	dplcHeader
	dplcEntry	$C, $30
	dplcEntry	8, $3C
	dplcEntry	6, $44
.sonic_2_End

.sonic_3:	dplcHeader
	dplcEntry	9, $1B
	dplcEntry	8, $4A
	dplcEntry	6, $52
.sonic_3_End

.sonic_4:	dplcHeader
	dplcEntry	9, 0
	dplcEntry	4, 9
	dplcEntry	2, $D
	dplcEntry	$C, $F
.sonic_4_End

.sonic_5:	dplcHeader
	dplcEntry	6, $1B
	dplcEntry	2, $21
	dplcEntry	8, $23
	dplcEntry	8, $2B
	dplcEntry	1, $33
.sonic_5_End

.sonic_6:	dplcHeader
	dplcEntry	2, $34
	dplcEntry	$C, $36
	dplcEntry	3, $42
	dplcEntry	6, $45
	dplcEntry	4, $4B
.sonic_6_End

.sonic_7:	dplcHeader
	dplcEntry	2, $4F
	dplcEntry	$10, $51
	dplcEntry	3, $61
	dplcEntry	1, $64
	dplcEntry	4, $65
.sonic_7_End

.sonic_8:	dplcHeader
	dplcEntry	4, $69
	dplcEntry	4, $6D
	dplcEntry	$C, $71
	dplcEntry	4, $7D
.sonic_8_End

.sonic_9:	dplcHeader
	dplcEntry	4, $81
	dplcEntry	3, $85
	dplcEntry	8, $88
	dplcEntry	8, $90
	dplcEntry	1, $98
.sonic_9_End

.sonic_10:	dplcHeader
	dplcEntry	6, $99
	dplcEntry	2, $9F
	dplcEntry	8, $A1
	dplcEntry	8, $A9
	dplcEntry	1, $B1
.sonic_10_End

.sonic_11:	dplcHeader
	dplcEntry	1, $B2
	dplcEntry	8, $B3
	dplcEntry	1, $BB
	dplcEntry	2, $BC
	dplcEntry	8, $BE
	dplcEntry	6, $C6
.sonic_11_End

.sonic_12:	dplcHeader
	dplcEntry	6, 0
	dplcEntry	1, 6
	dplcEntry	$10, 7
.sonic_12_End

.sonic_13:	dplcHeader
	dplcEntry	6, $17
	dplcEntry	4, $1D
	dplcEntry	$C, $21
.sonic_13_End

.sonic_14:	dplcHeader
	dplcEntry	3, $2D
	dplcEntry	3, $30
	dplcEntry	$10, $33
.sonic_14_End

.sonic_15:	dplcHeader
	dplcEntry	6, $43
	dplcEntry	4, $49
	dplcEntry	$C, $21
.sonic_15_End

.sonic_16:	dplcHeader
	dplcEntry	8, 0
	dplcEntry	2, 8
.sonic_16_End

.sonic_17:	dplcHeader
	dplcEntry	8, $A
	dplcEntry	2, 8
.sonic_17_End

.tails_0:	dplcHeader
	dplcEntry	9, 0
	dplcEntry	6, 9
	dplcEntry	1, $F
.tails_0_End

.tails_1:	dplcHeader
	dplcEntry	4, $10
	dplcEntry	6, $14
	dplcEntry	4, $1A
	dplcEntry	4, $1E
.tails_1_End

.tails_2:	dplcHeader
	dplcEntry	4, $22
	dplcEntry	6, $26
	dplcEntry	4, $2C
	dplcEntry	4, $30
.tails_2_End

.tails_3:	dplcHeader
	dplcEntry	4, $10
	dplcEntry	6, $14
	dplcEntry	4, $34
	dplcEntry	4, $38
	dplcEntry	1, $3C
.tails_3_End

.tails_4:	dplcHeader
	dplcEntry	4, 0
	dplcEntry	8, 4
	dplcEntry	8, $C
.tails_4_End

.tails_5:	dplcHeader
	dplcEntry	2, $14
	dplcEntry	8, $16
	dplcEntry	9, $1E
	dplcEntry	2, $27
.tails_5_End

.tails_6:	dplcHeader
	dplcEntry	1, $29
	dplcEntry	3, $2A
	dplcEntry	8, $2D
	dplcEntry	1, $35
	dplcEntry	6, $36
.tails_6_End

.tails_7:	dplcHeader
	dplcEntry	1, $3C
	dplcEntry	$10, $3D
	dplcEntry	1, $4D
	dplcEntry	2, $4E
.tails_7_End

.tails_8:	dplcHeader
	dplcEntry	4, $50
	dplcEntry	4, $54
	dplcEntry	8, $58
	dplcEntry	6, $60
.tails_8_End

.tails_9:	dplcHeader
	dplcEntry	1, $66
	dplcEntry	8, $67
	dplcEntry	1, $6F
	dplcEntry	8, $70
	dplcEntry	2, $78
.tails_9_End

.tails_10:	dplcHeader
	dplcEntry	1, $7A
	dplcEntry	$C, $7B
	dplcEntry	1, $87
	dplcEntry	4, $88
	dplcEntry	2, $8C
.tails_10_End

.tails_11:	dplcHeader
	dplcEntry	1, $8E
	dplcEntry	$C, $8F
	dplcEntry	1, $9B
	dplcEntry	8, $9C
.tails_11_End

.tails_12:	dplcHeader
	dplcEntry	9, 0
	dplcEntry	8, 9
.tails_12_End

.tails_13:	dplcHeader
	dplcEntry	4, $11
	dplcEntry	1, $15
	dplcEntry	$C, $16
.tails_13_End

.tails_14:	dplcHeader
	dplcEntry	2, $22
	dplcEntry	$10, $24
.tails_14_End

.tails_15:	dplcHeader
	dplcEntry	3, $34
	dplcEntry	3, $37
	dplcEntry	$C, $16
.tails_15_End

.tails_16:	dplcHeader
	dplcEntry	8, 0
.tails_16_End

.tails_17:	dplcHeader
	dplcEntry	8, 8
.tails_17_End

.tails_tails_0:	;dplcHeader
	dplcEntry	6, 0
.tails_tails_0_End

.tails_tails_1:	;dplcHeader
	dplcEntry	9, 6
.tails_tails_1_End

.tails_tails_2:	;dplcHeader
	dplcEntry	6, $F
.tails_tails_2_End

.tails_tails_3:	;dplcHeader
	dplcEntry	6, $15
.tails_tails_3_End

.tails_tails_4:	;dplcHeader
	dplcEntry	8, $1B
.tails_tails_4_End

.tails_tails_5:	;dplcHeader
	dplcEntry	9, $23
.tails_tails_5_End

.tails_tails_6:	;dplcHeader
	dplcEntry	9, $2C
.tails_tails_6_End

.tails_tails_7:	;dplcHeader
	dplcEntry	9, 0
.tails_tails_7_End

.tails_tails_8:	;dplcHeader
	dplcEntry	6, 9
.tails_tails_8_End

.tails_tails_9:	;dplcHeader
	dplcEntry	6, $F
.tails_tails_9_End

.tails_tails_10:	;dplcHeader
	dplcEntry	8, $15
.tails_tails_10_End

.tails_tails_11:	;dplcHeader
	dplcEntry	$C, $1D
.tails_tails_11_End

.tails_tails_12:	;dplcHeader
	dplcEntry	9, $29
.tails_tails_12_End

.tails_tails_13:	;dplcHeader
	dplcEntry	9, $32
.tails_tails_13_End

.tails_tails_14:	;dplcHeader
	dplcEntry	6, 0
.tails_tails_14_End

.tails_tails_15:	;dplcHeader
	dplcEntry	9, 6
.tails_tails_15_End

.tails_tails_16:	;dplcHeader
	dplcEntry	6, $F
.tails_tails_16_End

.tails_tails_17:	;dplcHeader
	dplcEntry	6, $15
.tails_tails_17_End

.tails_tails_18:	;dplcHeader
	dplcEntry	8, $1B
.tails_tails_18_End

.tails_tails_19:	;dplcHeader
	dplcEntry	9, $23
.tails_tails_19_End

.tails_tails_20:	;dplcHeader
	dplcEntry	9, $2C
.tails_tails_20_End

	even

	popv ,SonicDplcVer	; Switch back to the previous DPLC format
