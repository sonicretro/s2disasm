MCZ_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     MCZ_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $B6

	smpsHeaderDAC       MCZ_DAC
	smpsHeaderFM        MCZ_FM1,	$00, $0C
	smpsHeaderFM        MCZ_FM2,	$00, $0A
	smpsHeaderFM        MCZ_FM3,	$00, $0C
	smpsHeaderFM        MCZ_FM4,	$00, $10
	smpsHeaderFM        MCZ_FM5,	$00, $10
	smpsHeaderPSG       MCZ_PSG1,	$DC, $04, $00, fTone_0B
	smpsHeaderPSG       MCZ_PSG2,	$DC, $02, $00, fTone_01
	smpsHeaderPSG       MCZ_PSG3,	$00, $03, $00, fTone_02

MCZ_Call00:
	smpsSetvoice        $04
	dc.b	nA2, $14, nB2, $04, nC3, $04, nRst, $08, nE3, $04, nRst, $08
	dc.b	nEb3, $04, nRst, $08, nE3, $04, nRst, $08, nG3, $08, nE3, $10
	smpsSetvoice        $03
	smpsReturn

MCZ_Call03:
	smpsAlterPitch      $FE
	dc.b	nA5, $04, smpsNoAttack, nAb5, smpsNoAttack, nA5, $04, smpsNoAttack, nAb5, smpsNoAttack, nA5, smpsNoAttack
	dc.b	nAb5, smpsNoAttack, nA5, smpsNoAttack, nAb5
	smpsAlterPitch      $01
	dc.b	smpsNoAttack, nA5, smpsNoAttack, nAb5, smpsNoAttack, nA5, smpsNoAttack, nAb5, smpsNoAttack, nA5, smpsNoAttack, nAb5
	smpsAlterPitch      $01
	dc.b	smpsNoAttack, nA5, smpsNoAttack, nAb5, smpsNoAttack, nA5, smpsNoAttack, nAb5, smpsNoAttack, nA5, $05, smpsNoAttack
	dc.b	nAb5, smpsNoAttack, nA5, $05, smpsNoAttack, nAb5, nRst, $04
	smpsReturn

MCZ_Call04:
	smpsAlterPitch      $FD
	dc.b	nA5, $04, smpsNoAttack, nAb5, smpsNoAttack, nA5, smpsNoAttack, nAb5, smpsNoAttack, nA5, smpsNoAttack, nAb5
	dc.b	smpsNoAttack, nA5, smpsNoAttack, nAb5
	smpsAlterPitch      $FF
	dc.b	smpsNoAttack, nA5, smpsNoAttack, nAb5, smpsNoAttack, nA5, smpsNoAttack, nAb5
	smpsAlterPitch      $FF
	dc.b	smpsNoAttack, nA5, smpsNoAttack, nAb5, smpsNoAttack, nA5, smpsNoAttack, nAb5, smpsNoAttack, nA5, smpsNoAttack, nAb5
	smpsAlterPitch      $FF
	dc.b	smpsNoAttack, nA5, $05, smpsNoAttack, nAb5, smpsNoAttack, nA5, $05, smpsNoAttack, nAb5, nRst, $04
	smpsAlterPitch      $06
	smpsReturn

; FM5 Data
MCZ_FM5:
	smpsSetvoice        $01
	smpsPan             panLeft, $00
	dc.b	nRst, $01
	smpsCall            MCZ_Call00

MCZ_Jump03:
	dc.b	nRst, $2F, nRst, $1E
	smpsSetvoice        $06
	dc.b	nB2, $12, nC3, $06
	smpsSetvoice        $01
	dc.b	nRst, $30, nRst, $06, nC5, $08, nB4, $04, nBb4, $08, nA4, $04
	dc.b	nAb4, $08, nG4, $04, nRst, $30, nRst, $1E
	smpsSetvoice        $06
	dc.b	nB2, $12, nC3, $06
	smpsSetvoice        $01
	dc.b	nRst, $30, nRst, $06, nC5, $08, nB4, $04, nBb4, $08, nA4, $04
	dc.b	nAb4, $08, nG4, $04, nRst, $30, nRst, $1E
	smpsSetvoice        $06
	dc.b	nB2, $12, nC3, $06
	smpsSetvoice        $01
	dc.b	nRst, $30, nRst, $06, nC5, $08, nB4, $04, nBb4, $08, nA4, $04
	dc.b	nAb4, $08, nG4, $04, nRst, $30, nRst, $1E
	smpsSetvoice        $06
	dc.b	nB2, $12, nC3, $06
	smpsSetvoice        $01
	dc.b	nRst, $30, nRst, $06, nC5, $08, nB4, $04, nBb4, $08, nA4, $04
	dc.b	nAb4, $08, nG4, $04

MCZ_Loop05:
	dc.b	nRst, $0C, nE5, $06, nRst, $12, $06, nRst, $12, nE5, $06
	dc.b	nRst, $0C
	smpsSetvoice        $06
	dc.b	nB2, $12, nC3, $06, nRst
	smpsSetvoice        $01
	dc.b	nE5, $06, nRst, $12, $06, nRst, $12, nE5, $08, nEb5, $04
	dc.b	nE5, $08, nEb5, $04, nE5, $0C
	smpsLoop            $00, $04, MCZ_Loop05
	dc.b	nRst, $01
	smpsCall            MCZ_Call00
	dc.b	nRst, $0B, nA3, $08, nB3, $04, nC4, $08, nB3, $04, nA3, $0C
	dc.b	$08, nB3, $04, nC4, $08, nB3, $04, nA3, $06, nRst, $12, nRst
	dc.b	$01
	smpsCall            MCZ_Call00
	dc.b	nA2, $0C, nRst, nG2, nRst, nF2, nRst, nE2, nRst
	smpsCall            MCZ_Call00
	dc.b	nRst, $0B, nC4, $08, nD4, $04, nE4, $08, nD4, $04, nC4, $0C
	dc.b	$08, nD4, $04, nE4, $08, nD4, $04, nC4, $06, nRst, $12, nRst
	dc.b	$01
	smpsCall            MCZ_Call00
	dc.b	nA2, $0C, nA2, nE2, $08, nG2, $0C, nA2, $06, nRst, $2E
	smpsJump            MCZ_Jump03

MCZ_Call01:
	dc.b	nFs5, $01, smpsNoAttack, nG5, smpsNoAttack, nAb5, smpsNoAttack, nA5, $2D
	smpsReturn

MCZ_Call02:
	dc.b	smpsNoAttack, $24, smpsNoAttack, nAb5, $01, smpsNoAttack, nG5, smpsNoAttack, nFs5, smpsNoAttack, nF5, smpsNoAttack
	dc.b	nE5, smpsNoAttack, nEb5, smpsNoAttack, nD5, smpsNoAttack, nCs5, smpsNoAttack, nC5, smpsNoAttack, nB4, smpsNoAttack
	dc.b	nBb4, smpsNoAttack, nA4
	smpsReturn

; FM1 Data
MCZ_FM1:
	smpsSetvoice        $02
	smpsModSet          $18, $01, $0A, $04
	dc.b	nRst, $30, nRst

MCZ_Jump02:
	smpsCall            MCZ_Call01
	smpsAlterPitch      $02
	smpsCall            MCZ_Call01
	smpsAlterPitch      $01
	smpsCall            MCZ_Call01
	smpsAlterPitch      $FC
	smpsCall            MCZ_Call01
	smpsAlterPitch      $01
	smpsCall            MCZ_Call01
	dc.b	smpsNoAttack, $30, smpsNoAttack, $30
	smpsCall            MCZ_Call02
	smpsCall            MCZ_Call01
	smpsAlterPitch      $03
	smpsCall            MCZ_Call01
	smpsAlterPitch      $FF
	smpsCall            MCZ_Call01
	smpsAlterPitch      $FF
	smpsCall            MCZ_Call01
	smpsAlterPitch      $FF
	smpsCall            MCZ_Call01
	dc.b	smpsNoAttack, $30, smpsNoAttack, $24
	smpsCall            MCZ_Call02
	dc.b	nRst, $0C

MCZ_Loop04:
	dc.b	nRst, $30, nRst
	smpsLoop            $00, $09, MCZ_Loop04
	smpsCall            MCZ_Call03
	dc.b	nRst, $30, nRst
	smpsAlterPitch      $03
	smpsCall            MCZ_Call04
	dc.b	nRst, $30, nRst
	smpsAlterPitch      $FD
	smpsCall            MCZ_Call03
	dc.b	nRst, $30, nRst, nRst, nRst
	smpsJump            MCZ_Jump02

; PSG1 Data
MCZ_PSG1:
	dc.b	nRst, $04, nRst, $30, nRst

MCZ_Jump05:
	smpsCall            MCZ_Call01
	smpsAlterPitch      $02
	smpsCall            MCZ_Call01
	smpsAlterPitch      $01
	smpsCall            MCZ_Call01
	smpsAlterPitch      $FC
	smpsCall            MCZ_Call01
	smpsAlterPitch      $01
	smpsCall            MCZ_Call01
	dc.b	smpsNoAttack, $30, smpsNoAttack, $30
	smpsCall            MCZ_Call02
	smpsCall            MCZ_Call01
	smpsAlterPitch      $03
	smpsCall            MCZ_Call01
	smpsAlterPitch      $FF
	smpsCall            MCZ_Call01
	smpsAlterPitch      $FF
	smpsCall            MCZ_Call01
	smpsAlterPitch      $FF
	smpsCall            MCZ_Call01
	dc.b	smpsNoAttack, $30, smpsNoAttack, $24
	smpsCall            MCZ_Call02
	dc.b	nRst, $0C

MCZ_Loop08:
	dc.b	nRst, $30, nRst
	smpsLoop            $00, $09, MCZ_Loop08
	smpsCall            MCZ_Call03
	dc.b	nRst, $30, nRst
	smpsAlterPitch      $03
	smpsCall            MCZ_Call04
	dc.b	nRst, $30, nRst
	smpsAlterPitch      $FD
	smpsCall            MCZ_Call03
	dc.b	nRst, $30, nRst, nRst, nRst
	smpsJump            MCZ_Jump05

; PSG2 Data
MCZ_PSG2:
	dc.b	nRst, $30, nRst

MCZ_Loop06:
	dc.b	nRst, $30, nRst
	smpsLoop            $00, $08, MCZ_Loop06
	dc.b	nA5, $0C, nAb5, nG5, $08, nAb5, $04, nG5, $08, nFs5, $04, nF5
	dc.b	$08, $04, nE5, $0C, nEb5, $08, nD5, $10, nC5, $0C, nC5, nB4
	dc.b	$08, nC5, $0C, nE5, $06, nRst, $2E, nA5, $0C, nAb5, nG5, $08
	dc.b	nAb5, $04, nG5, $08, nFs5, $04, nF5, $08, $04, nE5, $0C, nEb5
	dc.b	$08, nD5, $10, nC5, $0C, nC5, nB4, $08, nC5, $0C, nA4, $06
	dc.b	nRst, $2E, nC6, $0C, nB5, nBb5, $08, nB5, $04, nBb5, $08, nA5
	dc.b	$04, nAb5, $08, $04, nG5, $0C, nFs5, $08, nF5, $10, nE5, $0C
	dc.b	nE5, nD5, $08, nE5, $0C, nG5, $06, nRst, $2E, nC6, $0C, nB5
	dc.b	nBb5, $08, nB5, $04, nBb5, $08, nA5, $04, nAb5, $08, $04, nG5
	dc.b	$0C, nFs5, $08, nF5, $10, nE5, $0C, nE5, nD5, $08, nE5, $0C
	dc.b	nC5, $06, nRst, $2E

MCZ_Loop07:
	dc.b	nA5, $0C, nE6, $08, nA5, $0C, nD6, nA5, $04, nC6, $0C, nA5
	dc.b	$08, nB5, $0C, nA5, $04, nC6, $0C
	smpsLoop            $00, $07, MCZ_Loop07
	dc.b	nA5, $0C, nE6, $08, nA5, $0C, nC6, nA5, $06, nRst, $2E
	smpsJump            MCZ_Loop06

; FM3 Data
MCZ_FM3:
	smpsModSet          $18, $01, $03, $04
	smpsSetvoice        $06
	dc.b	nA2, $14, nB2, $04, nC3, $04, nRst, $08, nE3, $04, nRst, $08
	dc.b	nEb3, $04, nRst, $08, nE3, $04, nRst, $08, nG3, $08, nE3, $10
	smpsPan             panRight, $00
	smpsSetvoice        $00

MCZ_Loop02:
	dc.b	nRst, $30, nRst
	smpsLoop            $00, $08, MCZ_Loop02
	dc.b	nA5, $0C, nAb5, nG5, $08, nAb5, $04, nG5, $08, nFs5, $04, nF5
	dc.b	$08, $04, nE5, $0C, nEb5, $08, nD5, $10, nC5, $0C, nC5, nB4
	dc.b	$08, nC5, $0C, nE5, $06, smpsNoAttack, $2E, nA5, $0C, nAb5, nG5, $08
	dc.b	nAb5, $04, nG5, $08, nFs5, $04, nF5, $08, $04, nE5, $0C, nEb5
	dc.b	$08, nD5, $10, nC5, $0C, nC5, nB4, $08, nC5, $0C, nA4, $06
	dc.b	smpsNoAttack, $2E, nA5, $0C, nAb5, nG5, $08, nAb5, $04, nG5, $08, nFs5
	dc.b	$04, nF5, $08, $04, nE5, $0C, nEb5, $08, nD5, $10, nC5, $0C
	dc.b	nC5, nB4, $08, nC5, $0C, nE5, $06, smpsNoAttack, $2E, nA5, $0C, nAb5
	dc.b	nG5, $08, nAb5, $04, nG5, $08, nFs5, $04, nF5, $08, $04, nE5
	dc.b	$0C, nEb5, $08, nD5, $10, nC5, $0C, nC5, nB4, $08, nC5, $0C
	dc.b	nA4, $06, smpsNoAttack, $2E
	smpsPan             panCenter, $00
	smpsAlterVol        $06

MCZ_Loop03:
	dc.b	nA5, $0C, nE6, nA5, $08, nD6, $0C, nA5, $04, nC6, $08, nA5
	dc.b	$0C, nB5, nA5, $04, nC6, $0C
	smpsLoop            $00, $07, MCZ_Loop03
	smpsAlterVol        $FA
	dc.b	nA5, $0C, nE6, $08, nA5, $0C, nC6, nA5, $06, nRst, $2E
	smpsPan             panRight, $00
	smpsJump            MCZ_Loop02

; FM2 Data
MCZ_FM2:
	smpsSetvoice        $05
	dc.b	nRst, $30, nRst

MCZ_Loop01:
	dc.b	nA2, $0C, nA3, nG3, $08, nA3, $04, nG3, $08, nE3, $04, nD3
	dc.b	$08, $04, nEb3, $0C, nE3, $08, nAb2, $10, nA2, $0C, nA3, nG3
	dc.b	$08, nA3, $04, nG3, $08, nE3, $04, nD3, $08, $04, nEb3, $08
	dc.b	nE3, $04, nRst, $18
	smpsLoop            $00, $08, MCZ_Loop01
	dc.b	nRst, $30, nRst, nA2, $08, $04, nB2, $0C, nC3, nD3, nEb3, nD3
	dc.b	nC3, nB2, nRst, $30, nRst, nA2, $0C, nRst, nG2, nRst, nF2, nRst
	dc.b	nE2, nRst, nRst, $30, nRst, nA2, $08, $04, nB2, $0C, nC3, nD3
	dc.b	nEb3, nD3, nC3, nB2, nRst, $30, nRst, nA2, $0C, nA2, nE2, $08
	dc.b	nG2, $0C, nA2, nA2, $04, nFs2, $0C, nG2, nAb2
	smpsJump            MCZ_Loop01

; FM4 Data
MCZ_FM4:
	smpsSetvoice        $01
	smpsPan             panRight, $00
	smpsCall            MCZ_Call00

MCZ_Jump01:
	dc.b	nRst, $30, nRst, $1E
	smpsPan             panRight, $00
	smpsSetvoice        $06
	dc.b	nAb2, $12, nA2, $06
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	dc.b	nRst, $30, nRst, $06, nA4, $08, nAb4, $04, nG4, $08, nFs4, $04
	dc.b	nF4, $08, nE4, $04, nRst, $30, nRst, $1E
	smpsPan             panRight, $00
	smpsSetvoice        $06
	dc.b	nAb2, $12, nA2, $06
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	dc.b	nRst, $30, nRst, $06, nA4, $08, nAb4, $04, nG4, $08, nFs4, $04
	dc.b	nF4, $08, nE4, $04, nRst, $30, nRst, $1E
	smpsPan             panRight, $00
	smpsSetvoice        $06
	dc.b	nAb2, $12, nA2, $06
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	dc.b	nRst, $30, nRst, $06, nA4, $08, nAb4, $04, nG4, $08, nFs4, $04
	dc.b	nF4, $08, nE4, $04, nRst, $30, nRst, $1E
	smpsPan             panRight, $00
	smpsSetvoice        $06
	dc.b	nAb2, $12, nA2, $06
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	dc.b	nRst, $30, nRst, $06, nA4, $08, nAb4, $04, nG4, $08, nFs4, $04
	dc.b	nF4, $08, nE4, $04

MCZ_Loop00:
	dc.b	nRst, $0C, nC5, $06, nRst, $12, $06, nRst, $12, nC5, $06
	dc.b	nRst, $0C
	smpsSetvoice        $06
	dc.b	nAb2, $12, nA2, $06, nRst
	smpsSetvoice        $01
	dc.b	nC5, $06, nRst, $12, $06, nRst, $12, nC5, $08, nB4, $04
	dc.b	nC5, $08, nB4, $04, nC5, $0C
	smpsLoop            $00, $04, MCZ_Loop00
	smpsCall            MCZ_Call00
	smpsPan             panRight, $00
	smpsAlterPitch      $F4
	dc.b	nRst, $0C, nA3, $08, nB3, $04, nC4, $08, nB3, $04, nA3, $0C
	dc.b	$08, nB3, $04, nC4, $08, nB3, $04, nA3, $06, nRst, $12
	smpsPan             panCenter, $00
	smpsAlterPitch      $0C
	smpsCall            MCZ_Call00
	smpsPan             panRight, $00
	dc.b	nA2, $0C, nRst, nG2, nRst, nF2, nRst, nE2, nRst
	smpsPan             panCenter, $00
	smpsCall            MCZ_Call00
	smpsPan             panRight, $00
	dc.b	nRst, $0C, nA3, $08, nB3, $04, nC4, $08, nB3, $04, nA3, $0C
	dc.b	$08, nB3, $04, nC4, $08, nB3, $04, nA3, $06, nRst, $12
	smpsPan             panCenter, $00
	smpsCall            MCZ_Call00
	smpsPan             panRight, $00
	dc.b	nA2, $0C, nA2, nE2, $08, nG2, $0C, nA2, $06, nRst, $2E
	smpsPan             panCenter, $00
	smpsJump            MCZ_Jump01

; PSG3 Data
MCZ_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $30, nRst

MCZ_Jump04:
	dc.b	nMaxPSG, $0C, $08, $04
	smpsJump            MCZ_Jump04

; DAC Data
MCZ_DAC:
	dc.b	nRst, $30, nRst, $18, dKick, $0C, $08, $04

MCZ_Jump00:
	dc.b	dKick, $08, $0C, $04, dSnare, $0C, dKick, $08, $0C, dSnare, $04, dKick
	dc.b	$0C, dSnare, dKick, dKick, $08, $0C, $04, dSnare, $0C, dKick, $08, $0C
	dc.b	dSnare, $04, dKick, $0C, dSnare, dSnare, $08, $04
	smpsJump            MCZ_Jump00

MCZ_Voices:
;	Voice $00
;	$04
;	$35, $72, $54, $46, 	$1F, $1F, $1F, $1F, 	$07, $0A, $07, $0D
;	$00, $0B, $00, $0B, 	$1F, $0F, $1F, $0F, 	$23, $14, $1D, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $04, $05, $07, $03
	smpsVcCoarseFreq    $06, $04, $02, $05
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0D, $07, $0A, $07
	smpsVcDecayRate2    $0B, $00, $0B, $00
	smpsVcDecayLevel    $00, $01, $00, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $1D, $14, $23

;	Voice $01
;	$3A
;	$01, $01, $01, $02, 	$8D, $07, $07, $52, 	$09, $00, $00, $03
;	$01, $02, $02, $00, 	$5F, $0F, $0F, $2F, 	$18, $22, $18, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $01, $01, $01
	smpsVcRateScale     $01, $00, $00, $02
	smpsVcAttackRate    $12, $07, $07, $0D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $00, $00, $09
	smpsVcDecayRate2    $00, $02, $02, $01
	smpsVcDecayLevel    $02, $00, $00, $05
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $18, $22, $18

;	Voice $02
;	$3C
;	$42, $41, $32, $41, 	$12, $12, $12, $12, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$06, $08, $06, $08, 	$24, $08, $24, $08
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $04, $03, $04, $04
	smpsVcCoarseFreq    $01, $02, $01, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $12, $12, $12, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $08, $06, $08, $06
	smpsVcTotalLevel    $08, $24, $08, $24

;	Voice $03
;	$3C
;	$51, $51, $11, $11, 	$12, $14, $11, $0F, 	$0A, $05, $05, $05
;	$00, $00, $00, $00, 	$A6, $1A, $56, $1A, 	$13, $00, $0D, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $01, $01, $05, $05
	smpsVcCoarseFreq    $01, $01, $01, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0F, $11, $14, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $05, $05, $0A
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $05, $01, $0A
	smpsVcReleaseRate   $0A, $06, $0A, $06
	smpsVcTotalLevel    $00, $0D, $00, $13

;	Voice $04
;	$24
;	$70, $74, $30, $38, 	$12, $1F, $1F, $1F, 	$05, $03, $05, $03
;	$05, $03, $05, $03, 	$36, $2C, $26, $2C, 	$0A, $08, $06, $08
	smpsVcAlgorithm     $04
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $08, $00, $04, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $05, $03, $05
	smpsVcDecayRate2    $03, $05, $03, $05
	smpsVcDecayLevel    $02, $02, $02, $03
	smpsVcReleaseRate   $0C, $06, $0C, $06
	smpsVcTotalLevel    $08, $06, $08, $0A

;	Voice $05
;	$31
;	$34, $35, $30, $31, 	$DF, $DF, $9F, $9F, 	$0C, $07, $0C, $09
;	$07, $07, $07, $08, 	$2F, $1F, $1F, $2F, 	$17, $32, $14, $80
	smpsVcAlgorithm     $01
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $01, $00, $05, $04
	smpsVcRateScale     $02, $02, $03, $03
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $09, $0C, $07, $0C
	smpsVcDecayRate2    $08, $07, $07, $07
	smpsVcDecayLevel    $02, $01, $01, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $14, $32, $17

;	Voice $06
;	$3D
;	$01, $01, $01, $01, 	$10, $50, $50, $50, 	$07, $08, $08, $08
;	$01, $00, $00, $00, 	$20, $1A, $1A, $1A, 	$19, $84, $84, $84
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $01, $01
	smpsVcRateScale     $01, $01, $01, $00
	smpsVcAttackRate    $10, $10, $10, $10
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $08, $08, $07
	smpsVcDecayRate2    $00, $00, $00, $01
	smpsVcDecayLevel    $01, $01, $01, $02
	smpsVcReleaseRate   $0A, $0A, $0A, $00
	smpsVcTotalLevel    $84, $84, $84, $19

