; frames of animation of the special stage track
; this chooses how objects curve along the track as well as which track frame to draw
; off_63DC:
Ani_SpecialStageTrack:	offsetTable
	offsetTableEntry.w SSTrackAni_TurnThenRise	; 0
	offsetTableEntry.w SSTrackAni_TurnThenDrop	; 1
	offsetTableEntry.w SSTrackAni_TurnThenStraight	; 2
	offsetTableEntry.w SSTrackAni_Straight		; 3
	offsetTableEntry.w SSTrackAni_StraightThenTurn	; 4
; byte_63E6:
SSTrackAni_TurnThenRise:
	dc.b $26,$27,$28,$29,$2A,$2B,$26 ; turning
	dc.b   0,  1,  2,  3,  4,  5,  6,  7,  8,  9, $A, $B, $C, $D, $E, $F,$10 ; rise
SSTrackAni_TurnThenRise_End:
; byte_63FE:
SSTrackAni_TurnThenDrop:
	dc.b $26,$27,$28,$29,$2A,$2B,$26 ; turning
	dc.b $15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,$20,$21,$22,$23,$24,$25 ; drop
SSTrackAni_TurnThenDrop_End:
; byte_6416:
SSTrackAni_TurnThenStraight:
	dc.b $26,$27,$28,$29,$2A,$2B,$26 ; turning
	dc.b $2C,$2D,$2E,$2F,$30 ; exit turn
SSTrackAni_TurnThenStraight_End:
; byte_6422:
SSTrackAni_Straight:
	dc.b $11,$12,$13,$14,$11,$12,$13,$14 ; straight
	dc.b $11,$12,$13,$14,$11,$12,$13,$14 ; straight
SSTrackAni_Straight_End:
; byte_6432:
SSTrackAni_StraightThenTurn:
	dc.b $11,$12,$13,$14 ; straight
	dc.b $31,$32,$33,$34,$35,$36,$37 ; enter turn
SSTrackAni_StraightThenTurn_End:

	even

; ===========================================================================
; pointers to the mappings for each frame of the special stage track
; indexed into by the numbers used in the above animations
;
; Format of each mappings file:
;	File is divided in 3 segments, with the same structure:
;	Segment structure:
;		4-byte unsigned length of segment (not counting the 4 bytes used for length);
;		the first 2 bytes of each length is ignored, and only the last 2 bytes are
;		actually used.
;		Rest of the segment is mappings data, as follows:
;	1st segment:
;		Mappings data is a bitstream indicating whether to draw a single tile at
;		a time using the uncompressed mappings (see 2nd segment) or a sequence of
;		tiles using the RLE mappings (see 3rd segment).
;	2nd segment:
;		Mappings data is a bitstream: the first bit in each cycle determines how
;		many bits from the stream are to be used as an index to the uncompressed
;		pattern name list SSPNT_UncLUT: if the first bit is set, 10 bits form an
;		index into SSPNT_UncLUT_Part2, otherwise 6 bits are used as an index into
;		SSPNT_UncLUT.
;		These tiles are drawn in palette line 3.
;	3nd segment:
;		Mappings data is a bitstream: the first bit in each cycle determines how
;		many bits from the stream are to be used as an index to the RLE-compressed
;		pattern name list SSPNT_RLELUT: if the first bit is set, 7 bits form an
;		index into SSPNT_RLELUT_Part2, otherwise 6 bits are used as an index into
;		SSPNT_RLELUT.
;		These tiles are drawn in palette line 3, with the high priority bit set.
; off_643E:
Map_SpecialStageTrack:
	dc.l MapSpec_Rise1		;   0
	dc.l MapSpec_Rise2		;   1
	dc.l MapSpec_Rise3		;   2
	dc.l MapSpec_Rise4		;   3
	dc.l MapSpec_Rise5		;   4
	dc.l MapSpec_Rise6		;   5
	dc.l MapSpec_Rise7		;   6
	dc.l MapSpec_Rise8		;   7
	dc.l MapSpec_Rise9		;   8
	dc.l MapSpec_Rise10		;   9
	dc.l MapSpec_Rise11		;  $A
	dc.l MapSpec_Rise12		;  $B
	dc.l MapSpec_Rise13		;  $C
	dc.l MapSpec_Rise14		;  $D	; This may flip the special stage's horizontal orientation
	dc.l MapSpec_Rise15		;  $E
	dc.l MapSpec_Rise16		;  $F
	dc.l MapSpec_Rise17		; $10
	dc.l MapSpec_Straight1		; $11
	dc.l MapSpec_Straight2		; $12	; This may flip the special stage's horizontal orientation
	dc.l MapSpec_Straight3		; $13
	dc.l MapSpec_Straight4		; $14
	dc.l MapSpec_Drop1		; $15
	dc.l MapSpec_Drop2		; $16
	dc.l MapSpec_Drop3		; $17
	dc.l MapSpec_Drop4		; $18
	dc.l MapSpec_Drop5		; $19
	dc.l MapSpec_Drop6		; $1A	; This may flip the special stage's horizontal orientation
	dc.l MapSpec_Drop7		; $1B
	dc.l MapSpec_Drop8		; $1C
	dc.l MapSpec_Drop9		; $1D
	dc.l MapSpec_Drop10		; $1E
	dc.l MapSpec_Drop11		; $1F
	dc.l MapSpec_Drop12		; $20
	dc.l MapSpec_Drop13		; $21
	dc.l MapSpec_Drop14		; $22
	dc.l MapSpec_Drop15		; $23
	dc.l MapSpec_Drop16		; $24
	dc.l MapSpec_Drop17		; $25
	dc.l MapSpec_Turning1		; $26
	dc.l MapSpec_Turning2		; $27
	dc.l MapSpec_Turning3		; $28
	dc.l MapSpec_Turning4		; $29
	dc.l MapSpec_Turning5		; $2A
	dc.l MapSpec_Turning6		; $2B
	dc.l MapSpec_Unturn1		; $2C
	dc.l MapSpec_Unturn2		; $2D
	dc.l MapSpec_Unturn3		; $2E
	dc.l MapSpec_Unturn4		; $2F
	dc.l MapSpec_Unturn5		; $30
	dc.l MapSpec_Turn1		; $31
	dc.l MapSpec_Turn2		; $32
	dc.l MapSpec_Turn3		; $33
	dc.l MapSpec_Turn4		; $34
	dc.l MapSpec_Turn5		; $35
	dc.l MapSpec_Turn6		; $36
	dc.l MapSpec_Turn7		; $37

; These are pattern names. They get sent to either the pattern name table
; buffer or one region of one of the plane A name tables in the special stage.
; They are indexed by the second segment of the mappings in Map_SpecialStageTrack, above.
;word_651E
SSPNT_UncLUT:
	dc.w make_block_tile($0001,0,0,0,1), make_block_tile($0007,0,0,0,1), make_block_tile($002C,0,0,0,1), make_block_tile($000B,0,0,0,1)	; $00
	dc.w make_block_tile($0024,0,0,0,1), make_block_tile($0024,1,0,0,1), make_block_tile($0039,0,0,0,1), make_block_tile($002B,1,0,0,1)	; $04
	dc.w make_block_tile($005D,0,0,0,1), make_block_tile($005D,1,0,0,1), make_block_tile($002B,0,0,0,1), make_block_tile($004A,0,0,0,1)	; $08
	dc.w make_block_tile($0049,0,0,0,1), make_block_tile($0037,0,0,0,1), make_block_tile($0049,1,0,0,1), make_block_tile($0045,0,0,0,1)	; $0C
	dc.w make_block_tile($0045,1,0,0,1), make_block_tile($003A,1,0,0,1), make_block_tile($0048,0,0,0,1), make_block_tile($0050,1,0,0,1)	; $10
	dc.w make_block_tile($0036,0,0,0,1), make_block_tile($0037,1,0,0,1), make_block_tile($003A,0,0,0,1), make_block_tile($0050,0,0,0,1)	; $14
	dc.w make_block_tile($0042,1,0,0,1), make_block_tile($0042,0,0,0,1), make_block_tile($0015,1,0,0,1), make_block_tile($001D,0,0,0,1)	; $18
	dc.w make_block_tile($004B,0,0,0,1), make_block_tile($0017,1,0,0,1), make_block_tile($0048,1,0,0,1), make_block_tile($0036,1,0,0,1)	; $1C
	dc.w make_block_tile($0038,0,0,0,1), make_block_tile($004B,1,0,0,1), make_block_tile($0015,0,0,0,1), make_block_tile($0021,0,0,0,1)	; $20
	dc.w make_block_tile($0017,0,0,0,1), make_block_tile($0033,0,0,0,1), make_block_tile($001A,0,0,0,1), make_block_tile($002A,0,0,0,1)	; $24
	dc.w make_block_tile($005E,0,0,0,1), make_block_tile($0028,0,0,0,1), make_block_tile($0030,0,0,0,1), make_block_tile($0021,1,0,0,1)	; $28
	dc.w make_block_tile($0038,1,0,0,1), make_block_tile($001A,1,0,0,1), make_block_tile($0025,0,0,0,1), make_block_tile($005E,1,0,0,1)	; $2C
	dc.w make_block_tile($0025,1,0,0,1), make_block_tile($0033,1,0,0,1), make_block_tile($0003,0,0,0,1), make_block_tile($0014,1,0,0,1)	; $30
	dc.w make_block_tile($0014,0,0,0,1), make_block_tile($0004,0,0,0,1), make_block_tile($004E,0,0,0,1), make_block_tile($0003,1,0,0,1)	; $34
	dc.w make_block_tile($000C,0,0,0,1), make_block_tile($002A,1,0,0,1), make_block_tile($0002,0,0,0,1), make_block_tile($0051,0,0,0,1)	; $38
	dc.w make_block_tile($0040,0,0,0,1), make_block_tile($003D,0,0,0,1), make_block_tile($0019,0,0,0,1), make_block_tile($0052,0,0,0,1)	; $3C
;word_659E
SSPNT_UncLUT_Part2:
	dc.w make_block_tile($0009,0,0,0,1), make_block_tile($005A,0,0,0,1), make_block_tile($0030,1,0,0,1), make_block_tile($004E,1,0,0,1)	; $40
	dc.w make_block_tile($0052,1,0,0,1), make_block_tile($0051,1,0,0,1), make_block_tile($0009,1,0,0,1), make_block_tile($0040,1,0,0,1)	; $44
	dc.w make_block_tile($002F,0,0,0,1), make_block_tile($005A,1,0,0,1), make_block_tile($0018,1,0,0,1), make_block_tile($0034,0,0,0,1)	; $48
	dc.w make_block_tile($0019,1,0,0,1), make_block_tile($002F,1,0,0,1), make_block_tile($003D,1,0,0,1), make_block_tile($003E,0,0,0,1)	; $4C
	dc.w make_block_tile($0018,0,0,0,1), make_block_tile($000C,1,0,0,1), make_block_tile($0012,0,0,0,1), make_block_tile($0004,1,0,0,1)	; $50
	dc.w make_block_tile($0026,0,0,0,1), make_block_tile($0034,1,0,0,1), make_block_tile($0005,1,0,0,1), make_block_tile($003B,0,0,0,1)	; $54
	dc.w make_block_tile($003E,1,0,0,1), make_block_tile($003B,1,0,0,1), make_block_tile($0000,0,0,0,1), make_block_tile($0002,1,0,0,1)	; $58
	dc.w make_block_tile($0005,0,0,0,1), make_block_tile($000D,0,0,0,1), make_block_tile($0055,0,0,0,1), make_block_tile($00AF,0,0,0,1)	; $5C
	dc.w make_block_tile($001C,0,0,0,1), make_block_tile($001B,0,0,0,1), make_block_tile($000D,1,0,0,1), make_block_tile($0016,0,0,0,1)	; $60
	dc.w make_block_tile($0012,1,0,0,1), make_block_tile($001F,0,0,0,1), make_block_tile($0032,1,0,0,1), make_block_tile($0013,0,0,0,1)	; $64
	dc.w make_block_tile($0092,0,0,0,1), make_block_tile($0026,1,0,0,1), make_block_tile($0010,0,0,0,1), make_block_tile($004D,0,0,0,1)	; $68
	dc.w make_block_tile($0047,0,0,0,1), make_block_tile($0092,1,0,0,1), make_block_tile($0000,1,0,0,1), make_block_tile($0062,0,0,0,1)	; $6C
	dc.w make_block_tile($0066,0,0,0,1), make_block_tile($0090,0,0,0,1), make_block_tile($0008,0,0,0,1), make_block_tile($007C,1,0,0,1)	; $70
	dc.w make_block_tile($0067,1,0,0,1), make_block_tile($00F7,1,0,0,1), make_block_tile($000E,0,0,0,1), make_block_tile($0060,0,0,0,1)	; $74
	dc.w make_block_tile($0032,0,0,0,1), make_block_tile($0094,0,0,0,1), make_block_tile($001C,1,0,0,1), make_block_tile($0105,1,0,0,1)	; $78
	dc.w make_block_tile($00B0,1,0,0,1), make_block_tile($0059,0,0,0,1), make_block_tile($000F,0,0,0,1), make_block_tile($0067,0,0,0,1)	; $7C
	dc.w make_block_tile($0068,0,0,0,1), make_block_tile($0094,1,0,0,1), make_block_tile($007C,0,0,0,1), make_block_tile($00B0,0,0,0,1)	; $80
	dc.w make_block_tile($00B1,0,0,0,1), make_block_tile($0006,0,0,0,1), make_block_tile($0041,1,0,0,1), make_block_tile($0087,0,0,0,1)	; $84
	dc.w make_block_tile($0093,0,0,0,1), make_block_tile($00CC,0,0,0,1), make_block_tile($001F,1,0,0,1), make_block_tile($0068,1,0,0,1)	; $88
	dc.w make_block_tile($0041,0,0,0,1), make_block_tile($008F,0,0,0,1), make_block_tile($0090,1,0,0,1), make_block_tile($00C2,0,0,0,1)	; $8C
	dc.w make_block_tile($0013,1,0,0,1), make_block_tile($00C2,1,0,0,1), make_block_tile($005C,0,0,0,1), make_block_tile($0064,0,0,0,1)	; $90
	dc.w make_block_tile($00D8,0,0,0,1), make_block_tile($001B,1,0,0,1), make_block_tile($00CC,1,0,0,1), make_block_tile($0011,1,0,0,1)	; $94
	dc.w make_block_tile($0055,1,0,0,1), make_block_tile($00E2,1,0,0,1), make_block_tile($00F3,1,0,0,1), make_block_tile($0044,0,0,0,1)	; $98
	dc.w make_block_tile($00D8,1,0,0,1), make_block_tile($0085,0,0,0,1), make_block_tile($00A1,0,0,0,1), make_block_tile($00C1,0,0,0,1)	; $9C
	dc.w make_block_tile($0119,0,0,0,1), make_block_tile($0089,1,0,0,1), make_block_tile($000A,1,0,0,1), make_block_tile($0022,1,0,0,1)	; $A0
	dc.w make_block_tile($003F,0,0,0,1), make_block_tile($005B,0,0,0,1), make_block_tile($007F,0,0,0,1), make_block_tile($0086,1,0,0,1)	; $A4
	dc.w make_block_tile($0008,1,0,0,1), make_block_tile($0080,0,0,0,1), make_block_tile($0066,1,0,0,1), make_block_tile($00E0,1,0,0,1)	; $A8
	dc.w make_block_tile($00C1,1,0,0,1), make_block_tile($0020,0,0,0,1), make_block_tile($0022,0,0,0,1), make_block_tile($0054,0,0,0,1)	; $AC
	dc.w make_block_tile($00D2,0,0,0,1), make_block_tile($0059,1,0,0,1), make_block_tile($00B1,1,0,0,1), make_block_tile($0060,1,0,0,1)	; $B0
	dc.w make_block_tile($0119,1,0,0,1), make_block_tile($00A4,1,0,0,1), make_block_tile($008F,1,0,0,1), make_block_tile($000A,0,0,0,1)	; $B4
	dc.w make_block_tile($0061,0,0,0,1), make_block_tile($0075,0,0,0,1), make_block_tile($0095,0,0,0,1), make_block_tile($00B6,0,0,0,1)	; $B8
	dc.w make_block_tile($00E0,0,0,0,1), make_block_tile($0010,1,0,0,1), make_block_tile($0098,1,0,0,1), make_block_tile($005B,1,0,0,1)	; $BC
	dc.w make_block_tile($00D2,1,0,0,1), make_block_tile($0016,1,0,0,1), make_block_tile($0053,0,0,0,1), make_block_tile($0091,0,0,0,1)	; $C0
	dc.w make_block_tile($0096,0,0,0,1), make_block_tile($00A4,0,0,0,1), make_block_tile($00DD,0,0,0,1), make_block_tile($00E6,0,0,0,1)	; $C4
	dc.w make_block_tile($007A,1,0,0,1), make_block_tile($004D,1,0,0,1), make_block_tile($00E6,1,0,0,1), make_block_tile($0011,0,0,0,1)	; $C8
	dc.w make_block_tile($0057,0,0,0,1), make_block_tile($007A,0,0,0,1), make_block_tile($0086,0,0,0,1), make_block_tile($009E,0,0,0,1)	; $CC
	dc.w make_block_tile($00DA,0,0,0,1), make_block_tile($0058,0,0,0,1), make_block_tile($00DC,0,0,0,1), make_block_tile($00E3,0,0,0,1)	; $D0
	dc.w make_block_tile($0063,1,0,0,1), make_block_tile($003C,0,0,0,1), make_block_tile($0056,0,0,0,1), make_block_tile($0069,0,0,0,1)	; $D4
	dc.w make_block_tile($007E,0,0,0,1), make_block_tile($00AE,0,0,0,1), make_block_tile($00B5,0,0,0,1), make_block_tile($00B8,0,0,0,1)	; $D8
	dc.w make_block_tile($00CD,0,0,0,1), make_block_tile($00FB,0,0,0,1), make_block_tile($00FF,0,0,0,1), make_block_tile($005C,1,0,0,1)	; $DC
	dc.w make_block_tile($00CD,1,0,0,1), make_block_tile($0074,1,0,0,1), make_block_tile($00EA,1,0,0,1), make_block_tile($00FF,1,0,0,1)	; $E0
	dc.w make_block_tile($00B5,1,0,0,1), make_block_tile($0043,0,0,0,1), make_block_tile($006C,0,0,0,1), make_block_tile($0074,0,0,0,1)	; $E4
	dc.w make_block_tile($0077,0,0,0,1), make_block_tile($0089,0,0,0,1), make_block_tile($0097,0,0,0,1), make_block_tile($009F,0,0,0,1)	; $E8
	dc.w make_block_tile($00A0,0,0,0,1), make_block_tile($0113,0,0,0,1), make_block_tile($011B,0,0,0,1), make_block_tile($0078,1,0,0,1)	; $EC
	dc.w make_block_tile($000F,1,0,0,1), make_block_tile($00E1,1,0,0,1), make_block_tile($00FB,1,0,0,1), make_block_tile($0128,1,0,0,1)	; $F0
	dc.w make_block_tile($0063,0,0,0,1), make_block_tile($0084,0,0,0,1), make_block_tile($008D,0,0,0,1), make_block_tile($00CB,0,0,0,1)	; $F4
	dc.w make_block_tile($00D7,0,0,0,1), make_block_tile($00E9,0,0,0,1), make_block_tile($0128,0,0,0,1), make_block_tile($0138,0,0,0,1)	; $F8
	dc.w make_block_tile($00AE,1,0,0,1), make_block_tile($00EC,1,0,0,1), make_block_tile($0031,0,0,0,1), make_block_tile($004C,0,0,0,1)	; $FC
	dc.w make_block_tile($00E2,0,0,0,1), make_block_tile($00EA,0,0,0,1), make_block_tile($0064,1,0,0,1), make_block_tile($0029,0,0,0,1)	; $100
	dc.w make_block_tile($002D,0,0,0,1), make_block_tile($006D,0,0,0,1), make_block_tile($0078,0,0,0,1), make_block_tile($0088,0,0,0,1)	; $104
	dc.w make_block_tile($00B4,0,0,0,1), make_block_tile($00BE,0,0,0,1), make_block_tile($00CF,0,0,0,1), make_block_tile($00E1,0,0,0,1)	; $108
	dc.w make_block_tile($00E4,0,0,0,1), make_block_tile($0054,1,0,0,1), make_block_tile($00D6,1,0,0,1), make_block_tile($00D7,1,0,0,1)	; $10C
	dc.w make_block_tile($0061,1,0,0,1), make_block_tile($012B,1,0,0,1), make_block_tile($0047,1,0,0,1), make_block_tile($0035,0,0,0,1)	; $110
	dc.w make_block_tile($006A,0,0,0,1), make_block_tile($0072,0,0,0,1), make_block_tile($0073,0,0,0,1), make_block_tile($0098,0,0,0,1)	; $114
	dc.w make_block_tile($00D5,0,0,0,1), make_block_tile($00D6,0,0,0,1), make_block_tile($0116,0,0,0,1), make_block_tile($011E,0,0,0,1)	; $118
	dc.w make_block_tile($0126,0,0,0,1), make_block_tile($0127,0,0,0,1), make_block_tile($012F,0,0,0,1), make_block_tile($015D,0,0,0,1)	; $11C
	dc.w make_block_tile($0069,1,0,0,1), make_block_tile($0088,1,0,0,1), make_block_tile($0075,1,0,0,1), make_block_tile($0097,1,0,0,1)	; $120
	dc.w make_block_tile($00B4,1,0,0,1), make_block_tile($00D1,1,0,0,1), make_block_tile($00D4,1,0,0,1), make_block_tile($00D5,1,0,0,1)	; $124
	dc.w make_block_tile($00CB,1,0,0,1), make_block_tile($00E4,1,0,0,1), make_block_tile($0091,1,0,0,1), make_block_tile($0062,1,0,0,1)	; $128
	dc.w make_block_tile($0006,1,0,0,1), make_block_tile($00B8,1,0,0,1), make_block_tile($0065,0,0,0,1), make_block_tile($006E,0,0,0,1)	; $12C
	dc.w make_block_tile($0071,0,0,0,1), make_block_tile($007D,0,0,0,1), make_block_tile($00D1,0,0,0,1), make_block_tile($00E7,0,0,0,1)	; $130
	dc.w make_block_tile($00F9,0,0,0,1), make_block_tile($0108,0,0,0,1), make_block_tile($012E,0,0,0,1), make_block_tile($014B,0,0,0,1)	; $134
	dc.w make_block_tile($0081,1,0,0,1), make_block_tile($0085,1,0,0,1), make_block_tile($0077,1,0,0,1), make_block_tile($007E,1,0,0,1)	; $138
	dc.w make_block_tile($0095,1,0,0,1), make_block_tile($00DF,1,0,0,1), make_block_tile($0087,1,0,0,1), make_block_tile($006C,1,0,0,1)	; $13C
	dc.w make_block_tile($00F5,1,0,0,1), make_block_tile($0108,1,0,0,1), make_block_tile($0079,1,0,0,1), make_block_tile($006D,1,0,0,1)	; $140
	dc.w make_block_tile($012A,1,0,0,1), make_block_tile($00AA,1,0,0,1), make_block_tile($001E,0,0,0,1), make_block_tile($0027,0,0,0,1)	; $144
	dc.w make_block_tile($0046,0,0,0,1), make_block_tile($005F,0,0,0,1), make_block_tile($0070,0,0,0,1), make_block_tile($0079,0,0,0,1)	; $148
	dc.w make_block_tile($009A,0,0,0,1), make_block_tile($00AA,0,0,0,1), make_block_tile($00C3,0,0,0,1), make_block_tile($00D3,0,0,0,1)	; $14C
	dc.w make_block_tile($00D4,0,0,0,1), make_block_tile($00DE,0,0,0,1), make_block_tile($00DF,0,0,0,1), make_block_tile($00F8,0,0,0,1)	; $150
	dc.w make_block_tile($0100,0,0,0,1), make_block_tile($0101,0,0,0,1), make_block_tile($012B,0,0,0,1), make_block_tile($0133,0,0,0,1)	; $154
	dc.w make_block_tile($0136,0,0,0,1), make_block_tile($0143,0,0,0,1), make_block_tile($0151,0,0,0,1), make_block_tile($002E,1,0,0,1)	; $158
	dc.w make_block_tile($009E,1,0,0,1), make_block_tile($0099,1,0,0,1), make_block_tile($00D3,1,0,0,1), make_block_tile($00DD,1,0,0,1)	; $15C
	dc.w make_block_tile($00DE,1,0,0,1), make_block_tile($00E9,1,0,0,1), make_block_tile($00EF,1,0,0,1), make_block_tile($00F0,1,0,0,1)	; $160
	dc.w make_block_tile($00F8,1,0,0,1), make_block_tile($0127,1,0,0,1), make_block_tile($00BE,1,0,0,1), make_block_tile($0096,1,0,0,1)	; $164
	dc.w make_block_tile($004F,0,0,0,1), make_block_tile($006F,0,0,0,1), make_block_tile($0081,0,0,0,1), make_block_tile($008B,0,0,0,1)	; $168
	dc.w make_block_tile($008E,0,0,0,1), make_block_tile($009C,0,0,0,1), make_block_tile($00A3,0,0,0,1), make_block_tile($00B3,0,0,0,1)	; $16C
	dc.w make_block_tile($00C0,0,0,0,1), make_block_tile($00CE,0,0,0,1), make_block_tile($00F0,0,0,0,1), make_block_tile($00F1,0,0,0,1)	; $170
	dc.w make_block_tile($00F5,0,0,0,1), make_block_tile($00F7,0,0,0,1), make_block_tile($0102,0,0,0,1), make_block_tile($0104,0,0,0,1)	; $174
	dc.w make_block_tile($0105,0,0,0,1), make_block_tile($0109,0,0,0,1), make_block_tile($010C,0,0,0,1), make_block_tile($0114,0,0,0,1)	; $178
	dc.w make_block_tile($0118,0,0,0,1), make_block_tile($0120,0,0,0,1), make_block_tile($0124,0,0,0,1), make_block_tile($0125,0,0,0,1)	; $17C
	dc.w make_block_tile($012A,0,0,0,1), make_block_tile($0130,0,0,0,1), make_block_tile($0132,0,0,0,1), make_block_tile($0137,0,0,0,1)	; $180
	dc.w make_block_tile($0159,0,0,0,1), make_block_tile($0165,0,0,0,1), make_block_tile($003F,1,0,0,1), make_block_tile($006B,1,0,0,1)	; $184
	dc.w make_block_tile($0080,1,0,0,1), make_block_tile($0053,1,0,0,1), make_block_tile($00C6,1,0,0,1), make_block_tile($00CF,1,0,0,1)	; $188
	dc.w make_block_tile($00D9,1,0,0,1), make_block_tile($00DC,1,0,0,1), make_block_tile($0056,1,0,0,1), make_block_tile($00B6,1,0,0,1)	; $18C
	dc.w make_block_tile($00F9,1,0,0,1), make_block_tile($0102,1,0,0,1), make_block_tile($0104,1,0,0,1), make_block_tile($0115,1,0,0,1)	; $190
	dc.w make_block_tile($006A,1,0,0,1), make_block_tile($0113,1,0,0,1), make_block_tile($0072,1,0,0,1), make_block_tile($0035,1,0,0,1)	; $194
	dc.w make_block_tile($0138,1,0,0,1), make_block_tile($015D,1,0,0,1), make_block_tile($0143,1,0,0,1), make_block_tile($0023,0,0,0,1)	; $198
	dc.w make_block_tile($0076,0,0,0,1), make_block_tile($007B,0,0,0,1), make_block_tile($008A,0,0,0,1), make_block_tile($009D,0,0,0,1)	; $19C
	dc.w make_block_tile($00A6,0,0,0,1), make_block_tile($00A8,0,0,0,1), make_block_tile($00AC,0,0,0,1), make_block_tile($00B2,0,0,0,1)	; $1A0
	dc.w make_block_tile($00B7,0,0,0,1), make_block_tile($00BB,0,0,0,1), make_block_tile($00BC,0,0,0,1), make_block_tile($00BD,0,0,0,1)	; $1A4
	dc.w make_block_tile($00C6,0,0,0,1), make_block_tile($00E5,0,0,0,1), make_block_tile($00E8,0,0,0,1), make_block_tile($00EE,0,0,0,1)	; $1A8
	dc.w make_block_tile($00F4,0,0,0,1), make_block_tile($010A,0,0,0,1), make_block_tile($010D,0,0,0,1), make_block_tile($0111,0,0,0,1)	; $1AC
	dc.w make_block_tile($0115,0,0,0,1), make_block_tile($011A,0,0,0,1), make_block_tile($011F,0,0,0,1), make_block_tile($0122,0,0,0,1)	; $1B0
	dc.w make_block_tile($0123,0,0,0,1), make_block_tile($0139,0,0,0,1), make_block_tile($013A,0,0,0,1), make_block_tile($013C,0,0,0,1)	; $1B4
	dc.w make_block_tile($0142,0,0,0,1), make_block_tile($0144,0,0,0,1), make_block_tile($0147,0,0,0,1), make_block_tile($0148,0,0,0,1)	; $1B8
	dc.w make_block_tile($015E,0,0,0,1), make_block_tile($015F,0,0,0,1), make_block_tile($0163,0,0,0,1), make_block_tile($0168,0,0,0,1)	; $1BC
	dc.w make_block_tile($016A,0,0,0,1), make_block_tile($016C,0,0,0,1), make_block_tile($0170,0,0,0,1), make_block_tile($00E5,1,0,0,1)	; $1C0
	dc.w make_block_tile($00CE,1,0,0,1), make_block_tile($00EE,1,0,0,1), make_block_tile($00F1,1,0,0,1), make_block_tile($0084,1,0,0,1)	; $1C4
	dc.w make_block_tile($00FD,1,0,0,1), make_block_tile($0100,1,0,0,1), make_block_tile($00B9,1,0,0,1), make_block_tile($0117,1,0,0,1)	; $1C8
	dc.w make_block_tile($0071,1,0,0,1), make_block_tile($0109,1,0,0,1), make_block_tile($010D,1,0,0,1), make_block_tile($0065,1,0,0,1)	; $1CC
	dc.w make_block_tile($0125,1,0,0,1), make_block_tile($0122,1,0,0,1), make_block_tile($0031,1,0,0,1), make_block_tile($003C,1,0,0,1)	; $1D0
	dc.w make_block_tile($010F,1,0,0,1), make_block_tile($00C5,1,0,0,1), make_block_tile($0133,1,0,0,1), make_block_tile($0137,1,0,0,1)	; $1D4
	dc.w make_block_tile($011F,1,0,0,1), make_block_tile($002E,0,0,0,1), make_block_tile($006B,0,0,0,1), make_block_tile($0082,0,0,0,1)	; $1D8
	dc.w make_block_tile($0083,0,0,0,1), make_block_tile($008C,0,0,0,1), make_block_tile($0099,0,0,0,1), make_block_tile($009B,0,0,0,1)	; $1DC
	dc.w make_block_tile($00A2,0,0,0,1), make_block_tile($00A5,0,0,0,1), make_block_tile($00A7,0,0,0,1), make_block_tile($00A9,0,0,0,1)	; $1E0
	dc.w make_block_tile($00AB,0,0,0,1), make_block_tile($00AD,0,0,0,1), make_block_tile($00B9,0,0,0,1), make_block_tile($00BA,0,0,0,1)	; $1E4
	dc.w make_block_tile($00BF,0,0,0,1), make_block_tile($00C4,0,0,0,1), make_block_tile($00C5,0,0,0,1), make_block_tile($00C7,0,0,0,1)	; $1E8
	dc.w make_block_tile($00C8,0,0,0,1), make_block_tile($00C9,0,0,0,1), make_block_tile($00CA,0,0,0,1), make_block_tile($00D0,0,0,0,1)	; $1EC
	dc.w make_block_tile($00D9,0,0,0,1), make_block_tile($00DB,0,0,0,1), make_block_tile($00EB,0,0,0,1), make_block_tile($00EC,0,0,0,1)	; $1F0
	dc.w make_block_tile($00ED,0,0,0,1), make_block_tile($00EF,0,0,0,1), make_block_tile($00F2,0,0,0,1), make_block_tile($00F3,0,0,0,1)	; $1F4
	dc.w make_block_tile($00F6,0,0,0,1), make_block_tile($00FA,0,0,0,1), make_block_tile($00FC,0,0,0,1), make_block_tile($00FD,0,0,0,1)	; $1F8
	dc.w make_block_tile($00FE,0,0,0,1), make_block_tile($0103,0,0,0,1), make_block_tile($0106,0,0,0,1), make_block_tile($0107,0,0,0,1)	; $2FC
	dc.w make_block_tile($010B,0,0,0,1), make_block_tile($010E,0,0,0,1), make_block_tile($010F,0,0,0,1), make_block_tile($0110,0,0,0,1)	; $200
	dc.w make_block_tile($0112,0,0,0,1), make_block_tile($0117,0,0,0,1), make_block_tile($011C,0,0,0,1), make_block_tile($011D,0,0,0,1)	; $204
	dc.w make_block_tile($0121,0,0,0,1), make_block_tile($0129,0,0,0,1), make_block_tile($012C,0,0,0,1), make_block_tile($012D,0,0,0,1)	; $208
	dc.w make_block_tile($0131,0,0,0,1), make_block_tile($0134,0,0,0,1), make_block_tile($0135,0,0,0,1), make_block_tile($013B,0,0,0,1)	; $20C
	dc.w make_block_tile($013D,0,0,0,1), make_block_tile($013E,0,0,0,1), make_block_tile($013F,0,0,0,1), make_block_tile($0140,0,0,0,1)	; $210
	dc.w make_block_tile($0141,0,0,0,1), make_block_tile($0145,0,0,0,1), make_block_tile($0146,0,0,0,1), make_block_tile($0149,0,0,0,1)	; $214
	dc.w make_block_tile($014A,0,0,0,1), make_block_tile($014C,0,0,0,1), make_block_tile($014D,0,0,0,1), make_block_tile($014E,0,0,0,1)	; $218
	dc.w make_block_tile($014F,0,0,0,1), make_block_tile($0150,0,0,0,1), make_block_tile($0152,0,0,0,1), make_block_tile($0153,0,0,0,1)	; $21C
	dc.w make_block_tile($0154,0,0,0,1), make_block_tile($0155,0,0,0,1), make_block_tile($0156,0,0,0,1), make_block_tile($0157,0,0,0,1)	; $220
	dc.w make_block_tile($0158,0,0,0,1), make_block_tile($015A,0,0,0,1), make_block_tile($015B,0,0,0,1), make_block_tile($015C,0,0,0,1)	; $224
	dc.w make_block_tile($0160,0,0,0,1), make_block_tile($0161,0,0,0,1), make_block_tile($0162,0,0,0,1), make_block_tile($0164,0,0,0,1)	; $228
	dc.w make_block_tile($0166,0,0,0,1), make_block_tile($0167,0,0,0,1), make_block_tile($0169,0,0,0,1), make_block_tile($016B,0,0,0,1)	; $22C
	dc.w make_block_tile($016D,0,0,0,1), make_block_tile($016E,0,0,0,1), make_block_tile($016F,0,0,0,1), make_block_tile($0171,0,0,0,1)	; $230
	dc.w make_block_tile($0172,0,0,0,1), make_block_tile($0173,0,0,0,1), make_block_tile($006E,1,0,0,1), make_block_tile($007D,1,0,0,1)	; $234
	dc.w make_block_tile($00C3,1,0,0,1), make_block_tile($00DB,1,0,0,1), make_block_tile($00E7,1,0,0,1), make_block_tile($00E8,1,0,0,1)	; $238
	dc.w make_block_tile($00EB,1,0,0,1), make_block_tile($00ED,1,0,0,1), make_block_tile($00F2,1,0,0,1), make_block_tile($00F6,1,0,0,1)	; $23C
	dc.w make_block_tile($00FA,1,0,0,1), make_block_tile($00FC,1,0,0,1), make_block_tile($00FE,1,0,0,1), make_block_tile($002D,1,0,0,1)	; $240
	dc.w make_block_tile($0103,1,0,0,1), make_block_tile($0106,1,0,0,1), make_block_tile($0107,1,0,0,1), make_block_tile($010B,1,0,0,1)	; $244
	dc.w make_block_tile($0073,1,0,0,1), make_block_tile($009A,1,0,0,1), make_block_tile($0129,1,0,0,1), make_block_tile($012C,1,0,0,1)	; $248
	dc.w make_block_tile($012D,1,0,0,1), make_block_tile($0111,1,0,0,1), make_block_tile($013C,1,0,0,1), make_block_tile($0120,1,0,0,1)	; $24C
	dc.w make_block_tile($0146,1,0,0,1), make_block_tile($00A9,1,0,0,1), make_block_tile($009C,1,0,0,1), make_block_tile($0116,1,0,0,1)	; $250
	dc.w make_block_tile($014F,1,0,0,1), make_block_tile($014C,1,0,0,1), make_block_tile($006F,1,0,0,1), make_block_tile($0158,1,0,0,1)	; $254
	dc.w make_block_tile($0156,1,0,0,1), make_block_tile($0159,1,0,0,1), make_block_tile($015A,1,0,0,1), make_block_tile($0161,1,0,0,1)	; $258
	dc.w make_block_tile($007B,1,0,0,1), make_block_tile($0166,1,0,0,1), make_block_tile($011C,1,0,0,1), make_block_tile($0118,1,0,0,1)	; $25C
	dc.w make_block_tile($00A0,1,0,0,1), make_block_tile($00A3,1,0,0,1), make_block_tile($0167,1,0,0,1), make_block_tile($00A1,1,0,0,1)	; $260

; These are run-length encoded pattern names. They get sent to either the
; pattern name table buffer or one region of one of the plane A name tables
; in the special stage.
; They are indexed by the third segment of the mappings in Map_SpecialStageTrack, above.
; Format: PNT,count
;word_69E6
SSPNT_RLELUT:
	dc.w	make_block_tile($0007,0,0,0,0),$0001,	make_block_tile($0001,0,0,0,0),$0001	; $00
	dc.w	make_block_tile($004A,0,0,0,0),$0001,	make_block_tile($0039,0,0,0,0),$0003	; $02
	dc.w	make_block_tile($0001,0,0,0,0),$0005,	make_block_tile($0028,0,0,0,0),$0007	; $04
	dc.w	make_block_tile($002C,0,0,0,0),$0001,	make_block_tile($0001,0,0,0,0),$0002	; $06
	dc.w	make_block_tile($0028,0,0,0,0),$0005,	make_block_tile($0039,0,0,0,0),$0001	; $08
	dc.w	make_block_tile($0028,0,0,0,0),$0009,	make_block_tile($0001,0,0,0,0),$0004	; $0A
	dc.w	make_block_tile($0028,0,0,0,0),$0006,	make_block_tile($0028,0,0,0,0),$0003	; $0C
	dc.w	make_block_tile($004A,0,0,0,0),$0002,	make_block_tile($0001,0,0,0,0),$0003	; $0E
	dc.w	make_block_tile($0028,0,0,0,0),$0004,	make_block_tile($0039,0,0,0,0),$0002	; $10
	dc.w	make_block_tile($0039,0,0,0,0),$0004,	make_block_tile($0001,0,0,0,0),$0006	; $12
	dc.w	make_block_tile($0007,0,0,0,0),$0002,	make_block_tile($002C,0,0,0,0),$0002	; $14
	dc.w	make_block_tile($0028,0,0,0,0),$0001,	make_block_tile($001D,0,0,0,0),$0001	; $16
	dc.w	make_block_tile($0028,0,0,0,0),$0008,	make_block_tile($0028,0,0,0,0),$0002	; $18
	dc.w	make_block_tile($0007,0,0,0,0),$0003,	make_block_tile($0001,0,0,0,0),$0007	; $1A
	dc.w	make_block_tile($0028,0,0,0,0),$000B,	make_block_tile($0039,0,0,0,0),$0005	; $1C
	dc.w	make_block_tile($001D,0,0,0,0),$0003,	make_block_tile($001D,0,0,0,0),$0004	; $1E
	dc.w	make_block_tile($001D,0,0,0,0),$0002,	make_block_tile($001D,0,0,0,0),$0005	; $20
	dc.w	make_block_tile($0028,0,0,0,0),$000D,	make_block_tile($000B,0,0,0,0),$0001	; $22
	dc.w	make_block_tile($0028,0,0,0,0),$000A,	make_block_tile($0039,0,0,0,0),$0006	; $24
	dc.w	make_block_tile($0039,0,0,0,0),$0007,	make_block_tile($002C,0,0,0,0),$0003	; $26
	dc.w	make_block_tile($001D,0,0,0,0),$0009,	make_block_tile($004A,0,0,0,0),$0003	; $28
	dc.w	make_block_tile($001D,0,0,0,0),$0007,	make_block_tile($0028,0,0,0,0),$000F	; $2A
	dc.w	make_block_tile($001D,0,0,0,0),$000B,	make_block_tile($001D,0,0,0,0),$0011	; $2C
	dc.w	make_block_tile($001D,0,0,0,0),$000D,	make_block_tile($001D,0,0,0,0),$0008	; $2E
	dc.w	make_block_tile($0028,0,0,0,0),$0011,	make_block_tile($001D,0,0,0,0),$0006	; $30
	dc.w	make_block_tile($000B,0,0,0,0),$0002,	make_block_tile($001D,0,0,0,0),$0015	; $32
	dc.w	make_block_tile($0028,0,0,0,0),$000C,	make_block_tile($001D,0,0,0,0),$000A	; $34
	dc.w	make_block_tile($0028,0,0,0,0),$000E,	make_block_tile($0001,0,0,0,0),$0008	; $36
	dc.w	make_block_tile($001D,0,0,0,0),$000F,	make_block_tile($0028,0,0,0,0),$0010	; $38
	dc.w	make_block_tile($0007,0,0,0,0),$0006,	make_block_tile($001D,0,0,0,0),$0013	; $3A
	dc.w	make_block_tile($004A,0,0,0,0),$0004,	make_block_tile($001D,0,0,0,0),$0017	; $3C
	dc.w	make_block_tile($0007,0,0,0,0),$0004,	make_block_tile($000B,0,0,0,0),$0003	; $3E
;word_6AE6
SSPNT_RLELUT_Part2:
	dc.w	make_block_tile($001D,0,0,0,0),$001B,	make_block_tile($004A,0,0,0,0),$0006	; $40
	dc.w	make_block_tile($001D,0,0,0,0),$001D,	make_block_tile($004A,0,0,0,0),$0005	; $42
	dc.w	make_block_tile($0001,0,0,0,0),$0009,	make_block_tile($0007,0,0,0,0),$0005	; $44
	dc.w	make_block_tile($001D,0,0,0,0),$001E,	make_block_tile($001D,0,0,0,0),$0019	; $46
	dc.w	make_block_tile($0001,0,0,0,0),$0011,	make_block_tile($001D,0,0,0,0),$000C	; $48
	dc.w	make_block_tile($001D,0,0,0,0),$007F,	make_block_tile($002C,0,0,0,0),$0004	; $4A
	dc.w	make_block_tile($001D,0,0,0,0),$000E,	make_block_tile($001D,0,0,0,0),$001C	; $4C
	dc.w	make_block_tile($004A,0,0,0,0),$000A,	make_block_tile($001D,0,0,0,0),$001A	; $4E
	dc.w	make_block_tile($004A,0,0,0,0),$0007,	make_block_tile($001D,0,0,0,0),$0018	; $50
	dc.w	make_block_tile($000B,0,0,0,0),$0004,	make_block_tile($001D,0,0,0,0),$0012	; $52
	dc.w	make_block_tile($001D,0,0,0,0),$0010,	make_block_tile($0001,0,0,0,0),$000F	; $54
	dc.w	make_block_tile($000B,0,0,0,0),$0005,	make_block_tile($0001,0,0,0,0),$000D	; $56
	dc.w	make_block_tile($0001,0,0,0,0),$0013,	make_block_tile($004A,0,0,0,0),$0009	; $58
	dc.w	make_block_tile($004A,0,0,0,0),$000B,	make_block_tile($004A,0,0,0,0),$000C	; $5A
	dc.w	make_block_tile($002C,0,0,0,0),$0005,	make_block_tile($001D,0,0,0,0),$0014	; $5C
	dc.w	make_block_tile($000B,0,0,0,0),$0007,	make_block_tile($001D,0,0,0,0),$0016	; $5E
	dc.w	make_block_tile($0001,0,0,0,0),$000C,	make_block_tile($0001,0,0,0,0),$000E	; $60
	dc.w	make_block_tile($004A,0,0,0,0),$0008,	make_block_tile($001D,0,0,0,0),$005F	; $62
	dc.w	make_block_tile($0001,0,0,0,0),$000A,	make_block_tile($000B,0,0,0,0),$0006	; $64
	dc.w	make_block_tile($000B,0,0,0,0),$0008,	make_block_tile($000B,0,0,0,0),$000A	; $66
	dc.w	make_block_tile($0039,0,0,0,0),$0008,	make_block_tile($000B,0,0,0,0),$0009	; $68
	dc.w	make_block_tile($002C,0,0,0,0),$0006,	make_block_tile($0001,0,0,0,0),$0010	; $6A
	dc.w	make_block_tile($000B,0,0,0,0),$000C,	make_block_tile($0001,0,0,0,0),$000B	; $6C
	dc.w	make_block_tile($0001,0,0,0,0),$0012,	make_block_tile($0007,0,0,0,0),$0007	; $6E
	dc.w	make_block_tile($001D,0,0,0,0),$001F,	make_block_tile($0028,0,0,0,0),$0012	; $70
	dc.w	make_block_tile($000B,0,0,0,0),$000B,	make_block_tile($002C,0,0,0,0),$0007	; $72
	dc.w	make_block_tile($002C,0,0,0,0),$000B,	make_block_tile($001D,0,0,0,0),$0023	; $74
	dc.w	make_block_tile($0001,0,0,0,0),$0015,	make_block_tile($002C,0,0,0,0),$0008	; $76
	dc.w	make_block_tile($001D,0,0,0,0),$002E,	make_block_tile($001D,0,0,0,0),$003F	; $78
	dc.w	make_block_tile($0001,0,0,0,0),$0014,	make_block_tile($000B,0,0,0,0),$000D	; $7A
	dc.w	make_block_tile($002C,0,0,0,0),$0009,	make_block_tile($002C,0,0,0,0),$000A	; $7C
	dc.w	make_block_tile($001D,0,0,0,0),$0025,	make_block_tile($001D,0,0,0,0),$0055	; $7E
	dc.w	make_block_tile($001D,0,0,0,0),$0071,	make_block_tile($001D,0,0,0,0),$007C	; $80
	dc.w	make_block_tile($004A,0,0,0,0),$000D,	make_block_tile($002C,0,0,0,0),$000C	; $82
	dc.w	make_block_tile($002C,0,0,0,0),$000F,	make_block_tile($002C,0,0,0,0),$0010	; $84
;unknown
;byte_6BFE:
	dc.w -5,-5,-6,-6,-6,-6
; ===========================================================================
