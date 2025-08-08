Supersonic_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Supersonic_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $FA

	smpsHeaderDAC       Supersonic_DAC
	smpsHeaderFM        Supersonic_FM1,	$F4, $13
	smpsHeaderFM        Supersonic_FM2,	$F4, $0A
	smpsHeaderFM        Supersonic_FM3,	$F4, $13
	smpsHeaderFM        Supersonic_FM4,	$F4, $13
	smpsHeaderFM        Supersonic_FM5,	$F4, $13
	smpsHeaderPSG       Supersonic_PSG1,	$D0, $01, $00, fTone_09
	smpsHeaderPSG       Supersonic_PSG2,	$D0, $03, $00, $00
	smpsHeaderPSG       Supersonic_PSG3,	$00, $03, $00, fTone_04

; FM1 Data
Supersonic_FM1:
	dc.b	nRst, $60, nRst
	smpsSetvoice        $00

Supersonic_Loop09:
	smpsCall            Supersonic_Call05
	smpsLoop            $00, $02, Supersonic_Loop09

Supersonic_Loop0A:
	smpsCall            Supersonic_Call01
	dc.b	nRst, nF6, nRst, nE6, nRst, nF6, nG6, $12
	smpsCall            Supersonic_Call01
	dc.b	nRst, nF6, $0C, nRst, $24
	smpsLoop            $00, $02, Supersonic_Loop0A
	smpsCall            Supersonic_Call02
	smpsJump            Supersonic_FM1

Supersonic_Call05:
	dc.b	nRst, $0C, nB5, $16, nRst, $02, nB5, $06, nRst, nC6, $12, nD6
	dc.b	nE6, $0C, nD6, $06, nRst, nD6, nRst, nD6, nRst, nB5, nRst, nC6
	dc.b	$12, nA5, $18, nRst, $06
	smpsReturn

Supersonic_Call01:
	dc.b	nRst, $09, nB6, $0F, nG6, $06, nRst, nD6
	smpsReturn

Supersonic_Call02:
	dc.b	nC6, $24, nA5, $06, nC6, nE6, $24, nC6, $06, nE6, nG6, $3C
	dc.b	nRst, $24
	smpsReturn

; FM3 Data
Supersonic_FM3:
	smpsSetvoice        $00
	dc.b	nB5, $12, nC6, nCs6, $0C, nC6, $12, nCs6, nD6, $0C, nCs6, $12
	dc.b	nD6, nEb6, $0C, nD6, $12, nEb6, nE6, $0C
	smpsSetvoice        $02
	smpsAlterNote       $03

Supersonic_Loop07:
	smpsCall            Supersonic_Call05
	smpsLoop            $00, $02, Supersonic_Loop07

Supersonic_Loop08:
	smpsSetvoice        $00
	smpsAlterNote       $00
	dc.b	nB5, $0C, nRst, nB5, nRst, nA5, nRst, nA5, nRst, nB5, $06, nRst
	dc.b	nB5, nRst, nA5, $0C, nB5, $06, nRst, $36
	smpsAlterPitch      $03
	smpsLoop            $00, $02, Supersonic_Loop08
	smpsAlterPitch      $FA
	dc.b	nC6, $18, nRst, nE6, nRst, nG6, nG6, nG6, nG6
	smpsJump            Supersonic_FM3

; FM4 Data
Supersonic_FM4:
	smpsSetvoice        $00

Supersonic_Jump01:
	dc.b	nG5, $12, nAb5, nA5, $0C, nAb5, $12, nA5, nBb5, $0C, nA5, $12
	dc.b	nBb5, nB5, $0C, nBb5, $12, nB5, nC6, $0C
	smpsSetvoice        $03

Supersonic_Loop05:
	smpsCall            Supersonic_Call04
	dc.b	nC6, nRst, nC6, nRst, nC6, nRst, nC6, nRst
	smpsCall            Supersonic_Call04
	dc.b	nA5, nRst, nA5, nRst, nA5, nRst, nA5, nRst
	smpsLoop            $00, $02, Supersonic_Loop05
	smpsSetvoice        $00

Supersonic_Loop06:
	dc.b	nG5, $0C, nRst, nG5, nRst, nF5, nRst, nF5, nRst, nG5, $06, nRst
	dc.b	nG5, nRst, nF5, $0C, nG5, $06, nRst, $36
	smpsAlterPitch      $04
	smpsLoop            $00, $02, Supersonic_Loop06
	smpsAlterPitch      $F8
	dc.b	nA5, $18, nRst, nC6, nRst, nE6, nE6, nE6, nE6
	smpsJump            Supersonic_Jump01

Supersonic_Call04:
	dc.b	nB5, $06, nRst, nB5, nRst, nB5, nRst, nB5, nRst
	smpsReturn

; FM2 Data
Supersonic_FM2:
	smpsSetvoice        $01

Supersonic_Jump00:
	dc.b	nCs3, $12, nD3, nEb3, $0C, nD3, $12, nEb3, nE3, $0C, nEb3, $12
	dc.b	nE3, nF3, $0C, nE3, $12, nF3, nFs3, $0C
	smpsSetvoice        $04

Supersonic_Loop03:
	smpsCall            Supersonic_Call03
	dc.b	nRst, $06, nE3, $0C
	smpsCall            Supersonic_Call03
	dc.b	nF3, $06, nE3, $0C
	smpsLoop            $00, $02, Supersonic_Loop03
	smpsSetvoice        $01

Supersonic_Loop04:
	dc.b	nRst, $60, nRst, $3C, nBb3, $06, nB3, nG3, $0C, nFs3
	smpsLoop            $00, $02, Supersonic_Loop04
	dc.b	nF4, $18, nF3, nF4, nF3, nF4, $0C, nF3, nF4, nF3, nF4, nF3
	dc.b	nF4, nF3
	smpsJump            Supersonic_Jump00

Supersonic_Call03:
	dc.b	nG3, $06, nRst, nG3, $0C, nD3, $06, nRst, nD3, $0C, nF3, $06
	dc.b	nRst, nF3, $0C, nE3, $06
	smpsReturn

; FM5 Data
Supersonic_FM5:
	smpsSetvoice        $03
	smpsPan             panRight, $00
	dc.b	nRst, $60, nRst

Supersonic_Loop01:
	smpsCall            Supersonic_Call00
	dc.b	nE6, nRst, nE6, nRst, nE6, nRst, nE6, nRst
	smpsCall            Supersonic_Call00
	dc.b	nC6, nRst, nC6, nRst, nC6, nRst, nC6, nRst
	smpsLoop            $00, $02, Supersonic_Loop01

Supersonic_Loop02:
	smpsSetvoice        $02
	smpsAlterNote       $03
	smpsPan             panLeft, $00
	smpsCall            Supersonic_Call01
	dc.b	nRst, $06, nF6, nRst, nE6, nRst, nF6, nG6, $12
	smpsCall            Supersonic_Call01
	dc.b	nRst, $06, nF6, $0C
	smpsSetvoice        $03
	smpsAlterNote       $00
	smpsPan             panCenter, $00
	dc.b	nCs4, $06, nD4, nB3, $0C, nG3
	smpsLoop            $00, $02, Supersonic_Loop02
	smpsSetvoice        $02
	smpsAlterNote       $02
	smpsCall            Supersonic_Call02
	smpsAlterNote       $00
	smpsJump            Supersonic_FM5

Supersonic_Call00:
	dc.b	nD6, $06, nRst, nD6, nRst, nD6, nRst, nD6, nRst
	smpsReturn

; PSG1 Data
Supersonic_PSG1:
	dc.b	nRst, $60
	smpsLoop            $00, $0A, Supersonic_PSG1
	dc.b	nRst, $18
	smpsCall            Supersonic_Call06
	dc.b	nD6, nRst, $15, nC7, $03, nB6, nBb6, nA6, nAb6, nG6, nFs6, nF6
	smpsCall            Supersonic_Call06
	dc.b	nCs6, nC7, nB6, nA6, nAb6, nG6, nFs6, nF6, nE7, nEb7, nD7, nCs7
	dc.b	nC7, nB6, nBb6, nA6, nG6, nFs6, nF6, nE6, nEb6, nD6, nCs6, nB5
	smpsJump            Supersonic_PSG1

Supersonic_Call06:
	dc.b	nA6, $03, nAb6, nG6, nFs6, nF6, nE6, nEb6, nD6
	smpsReturn

; PSG2 Data
Supersonic_PSG2:
	smpsStop

; PSG3 Data
Supersonic_PSG3:
	smpsStop

; DAC Data
Supersonic_DAC:
	dc.b	dKick, $0C, dSnare, $06, dKick, $12, dSnare, $0C
	smpsLoop            $00, $03, Supersonic_DAC
	dc.b	dKick, $0C, dSnare, $06, dKick, $0C, dSnare, $06, $0C

Supersonic_Loop00:
	dc.b	dKick, $0C, dSnare
	smpsLoop            $00, $07, Supersonic_Loop00
	dc.b	dKick, $06, dSnare, dSnare, $0C
	smpsLoop            $01, $05, Supersonic_Loop00
	smpsJump            Supersonic_DAC

Supersonic_Voices:
;	Voice $00
;	$3A
;	$02, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$1F, $FF, $1F, $0F, 	$19, $4E, $15, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $07, $02
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $15, $4E, $19

;	Voice $01
;	$08
;	$0A, $70, $30, $00, 	$1F, $1F, $5F, $5F, 	$12, $0E, $0A, $0A
;	$00, $04, $04, $03, 	$2F, $2F, $2F, $2F, 	$22, $2E, $13, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $01
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $03, $07, $00
	smpsVcCoarseFreq    $00, $00, $00, $0A
	smpsVcRateScale     $01, $01, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0A, $0E, $12
	smpsVcDecayRate2    $03, $04, $04, $00
	smpsVcDecayLevel    $02, $02, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $13, $2E, $22

;	Voice $02
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$1F, $FF, $1F, $0F, 	$17, $28, $27, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $27, $28, $17

;	Voice $03
;	$2C
;	$71, $72, $33, $33, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$1E, $80, $23, $82
	smpsVcAlgorithm     $04
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $03, $03, $02, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $02, $23, $00, $1E

;	Voice $04
;	$3A
;	$61, $3C, $14, $31, 	$9C, $DB, $9C, $DA, 	$04, $09, $04, $03
;	$03, $01, $03, $00, 	$1F, $0F, $0F, $AF, 	$21, $47, $31, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $01, $03, $06
	smpsVcCoarseFreq    $01, $04, $0C, $01
	smpsVcRateScale     $03, $02, $03, $02
	smpsVcAttackRate    $1A, $1C, $1B, $1C
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $04, $09, $04
	smpsVcDecayRate2    $00, $03, $01, $03
	smpsVcDecayLevel    $0A, $00, $00, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $31, $47, $21

