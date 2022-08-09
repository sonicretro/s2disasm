MCZ_2p_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     MCZ_2p_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $EC

	smpsHeaderDAC       MCZ_2p_DAC
	smpsHeaderFM        MCZ_2p_FM1,	$00, $10
	smpsHeaderFM        MCZ_2p_FM2,	$18, $0D
	smpsHeaderFM        MCZ_2p_FM3,	$00, $12
	smpsHeaderFM        MCZ_2p_FM4,	$00, $18
	smpsHeaderFM        MCZ_2p_FM5,	$00, $18
	smpsHeaderPSG       MCZ_2p_PSG1,	$DC, $05, $00, fTone_0C
	smpsHeaderPSG       MCZ_2p_PSG2,	$E8, $04, $00, fTone_04
	smpsHeaderPSG       MCZ_2p_PSG3,	$DC, $04, $00, fTone_0C

MCZ_2p_Call01:
	dc.b	nG4, $08, nA4, nB4
	smpsReturn

MCZ_2p_Call02:
	dc.b	nF4, $30, smpsNoAttack, $30, smpsNoAttack, nF4, nRst, $18, nG4, $08, nA4, nB4
	dc.b	nF4, $30, smpsNoAttack, $30, smpsNoAttack, $30, smpsNoAttack, $24
	smpsReturn

MCZ_2p_Call00:
	dc.b	nRst, $30, nRst, nB4, $06, nC5, nB4, nG4, nA4, nF4, $0C, nG4
	dc.b	nD4, nD4, $06, nF4, $0C, nG4
	smpsReturn

MCZ_2p_Call03:
	dc.b	nB4, $30, smpsNoAttack, $30, nC5, $30, smpsNoAttack, $24, nB4, $06, nC5, nD5
	dc.b	$30, smpsNoAttack, $30, nB4, $30, smpsNoAttack, $30, nB4, $30, smpsNoAttack, $30, nC5
	dc.b	$30, smpsNoAttack, $24, nB4, $06, nC5, nD5, $30, smpsNoAttack, $30, nF5, $30
	dc.b	smpsNoAttack, $30, nG5, $24, nF5, nE5, $18, nF5, $24, nE5, nC5, $18
	smpsReturn

; FM2 Data
MCZ_2p_FM2:
	dc.b	nRst, $18
	smpsSetvoice        $00

MCZ_2p_Jump05:
	dc.b	nG1, $0C, nD1, nF1, nD1, $06, nG1, $05, nG1, $07, $06, nD1
	dc.b	$0C, nF1, nD1
	smpsJump            MCZ_2p_Jump05

; FM1 Data
MCZ_2p_FM1:
	smpsSetvoice        $02
	smpsAlterVol        $12
	smpsCall            MCZ_2p_Call01

MCZ_2p_Jump04:
	smpsCall            MCZ_2p_Call02
	smpsModSet          $24, $01, $03, $04
	dc.b	nRst, $0C
	smpsAlterVol        $E6
	smpsSetvoice        $03
	smpsCall            MCZ_2p_Call03
	dc.b	$24, nB4, nD5, $18, smpsNoAttack, $30, smpsNoAttack, $30, nB5, $24, nA5, nG5
	dc.b	$18, nA5, $24, nG5, nE5, $18, nE5, nF5, $0C, nD5, $30, smpsNoAttack
	dc.b	$0C, smpsNoAttack, $30, smpsNoAttack, $24, nRst, $0C, nRst, $30, nRst, nRst, nRst
	dc.b	nC5, $24, nE5, nG5, $18, nF5, $24, nD5, nB4, $18, nB4, nC5
	dc.b	$0C, nB4, $30, smpsNoAttack, $0C, smpsNoAttack, $30, smpsNoAttack, $18, nRst, $18, nC5
	dc.b	$24, nE5, nG5, $18, nF5, $24, nD5, nB4, $18, nB5, $30, smpsNoAttack
	dc.b	$30, smpsNoAttack, $30, smpsNoAttack, $0C, nRst, $0C
	smpsModOff
	smpsAlterVol        $1A
	smpsSetvoice        $02
	dc.b	nE4, $08, nF4, nG4
	smpsJump            MCZ_2p_Jump04

; PSG1 Data
MCZ_2p_PSG1:
	smpsAlterNote       $02
	dc.b	nRst, $1B

MCZ_2p_Jump08:
	dc.b	nRst, $30, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	smpsCall            MCZ_2p_Call03
	dc.b	$24, nB4, nD5, $18, smpsNoAttack, $30, smpsNoAttack, $30, nB5, $24, nA5, nG5
	dc.b	$18, nA5, $24, nG5, nE5, $18, nE5, nF5, $0C, nD5, $30, smpsNoAttack
	dc.b	$0C, smpsNoAttack, $30, smpsNoAttack, $24, nRst, $0C, nRst, $30, nRst, nRst, nRst
	dc.b	nC5, $24, nE5, nG5, $18, nF5, $24, nD5, nB4, $18, nB4, nC5
	dc.b	$0C, nB4, $30, smpsNoAttack, $0C, smpsNoAttack, $30, smpsNoAttack, $18, nRst, $18, nC5
	dc.b	$24, nE5, nG5, $18, nF5, $24, nD5, nB4, $18, nB5, $30, smpsNoAttack
	dc.b	$30, smpsNoAttack, $30, smpsNoAttack, $0C, nRst, $24
	smpsJump            MCZ_2p_Jump08

; PSG3 Data
MCZ_2p_PSG3:
	dc.b	nRst, $18

MCZ_2p_Jump07:
	dc.b	nRst, $30, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	smpsCall            MCZ_2p_Call03
	dc.b	$24, nB4, nD5, $18, smpsNoAttack, $30, smpsNoAttack, $30
	smpsAlterVol        $FE
	dc.b	nG5, $24, nF5, nE5, $18, nF5, $24, nE5, nC5, $18, nC5, nD5
	dc.b	$0C, nB4, $30, smpsNoAttack, $0C, smpsNoAttack, $30, smpsNoAttack, $24, nRst, $0C, nRst
	dc.b	$30, nRst, nRst, nRst, nA4, $24, nC5, nE5, $18, nD5, $24, nB4
	dc.b	nG4, $18, nF4, nD4, $0C, nG4, $30, smpsNoAttack, $0C, smpsNoAttack, $30, smpsNoAttack
	dc.b	$18, nRst, $18, nA4, $24, nC5, nE5, $18, nD5, $24, nB4, nG4
	dc.b	$18, nG5, $30, smpsNoAttack, $30, smpsNoAttack, $30, smpsNoAttack, $0C, nRst, $24
	smpsAlterVol        $02
	smpsJump            MCZ_2p_Jump07

; FM4 Data
MCZ_2p_FM4:
	smpsSetvoice        $02
	smpsAlterNote       $02
	smpsPan             panLeft, $00
	smpsCall            MCZ_2p_Call01

MCZ_2p_Jump03:
	smpsCall            MCZ_2p_Call02
	smpsAlterNote       $00
	smpsSetvoice        $01
	smpsAlterVol        $F2
	smpsAlterPitch      $F4
	dc.b	nA3, $0C, nB3, $06, nRst, $30, nRst, $2A, nRst, $30, nRst, $24
	dc.b	nC4, $0C, nB3, $06, nRst, $30, nRst, $2A, nRst, $30, nRst, $24
	dc.b	nA3, $0C, nB3, $06, nRst, $30, nRst, $2A, nRst, $30, nRst, $24
	dc.b	nC4, $0C, nB3, $06, nRst, $30, nRst, $2A, nRst, $30, nRst, nRst
	dc.b	nRst, nG4, $24, nF4, nE4, $18, nF4, $24, nE4, nC4, $18, $24
	dc.b	nB3, nD4, $18, smpsNoAttack, $30, smpsNoAttack, $30, nB4, $24, nA4, nG4, $18
	dc.b	nA4, $24, nG4, nE4, $18, nE4, nF4, $0C, nD4, $24
	smpsAlterVol        $0E
	smpsAlterPitch      $0C
	smpsSetvoice        $02
	smpsCall            MCZ_2p_Call01
	dc.b	nF4, $30, smpsNoAttack, $30, smpsNoAttack, $30, smpsNoAttack, $18, nRst, $18
	smpsAlterVol        $F2
	smpsAlterPitch      $F4
	smpsSetvoice        $01
	dc.b	nRst, $30, nRst, nRst, nRst, $24, nG4, $06, nF4, nG4, $0C, nG4
	dc.b	nF4, $06, nG4, $0C, $06, nRst, $24, $06, nF4, nG4, $0C
	dc.b	nG4, nF4, $06, nG4, $0C, $06, nRst, $30, nRst, $30, nRst, nRst
	dc.b	nRst, $24, $06, nF4, nG4, $0C, nG4, nF4, $06, nG4, $0C
	dc.b	$06, nRst, $24, $06, nF4, nG4, $0C, nG4, nF4, $06, nG4
	dc.b	$0C, $06, nRst, $18
	smpsAlterVol        $0E
	smpsAlterPitch      $0C
	smpsSetvoice        $02
	smpsCall            MCZ_2p_Call01
	smpsJump            MCZ_2p_Jump03

; FM5 Data
MCZ_2p_FM5:
	dc.b	nRst, $01
	smpsSetvoice        $02
	smpsAlterNote       $FE
	smpsPan             panRight, $00
	smpsCall            MCZ_2p_Call01

MCZ_2p_Jump02:
	smpsCall            MCZ_2p_Call02
	smpsAlterNote       $FA
	smpsAlterVol        $F2
	smpsAlterPitch      $F4
	smpsSetvoice        $01
	dc.b	nF3, $0B, nG3, $06, nRst, $30, nRst, $2A, nRst, $30, nRst, $24
	dc.b	nA3, $0C, nG3, $06, nRst, $30, nRst, $2A, nRst, $30, nRst, $24
	dc.b	nF3, $0C, nG3, $06, nRst, $30, nRst, $2A, nRst, $30, nRst, $24
	dc.b	nA3, $0C, nG3, $06, nRst, $30, nRst, $2A, nRst, $30, nRst, nRst
	dc.b	nRst, nG4, $24, nF4, nE4, $18, nF4, $24, nE4, nC4, $18, $24
	dc.b	nB3, nD4, $18, smpsNoAttack, $30, smpsNoAttack, $30, nG4, $24, nF4, nE4, $18
	dc.b	nF4, $24, nE4, nC4, $18, nC4, nD4, $0C, nB3, $24
	smpsAlterVol        $0E
	smpsAlterPitch      $0C
	smpsSetvoice        $02
	smpsCall            MCZ_2p_Call01
	dc.b	nF4, $30, smpsNoAttack, $30, smpsNoAttack, $30, smpsNoAttack, $18, nRst, $18
	smpsAlterVol        $F2
	smpsAlterPitch      $F4
	smpsSetvoice        $01
	dc.b	nRst, $30, nRst, $30, nRst, $30, nRst, $24, nD4, $06, nC4, nD4
	dc.b	$0C, nD4, nC4, $06, nD4, $0C, $06, nRst, $24, $06, nC4
	dc.b	nD4, $0C, nD4, nC4, $06, nD4, $0C, $06, nRst, $30, nRst, $30
	dc.b	nRst, nRst, nRst, $24, $06, nC4, nD4, $0C, nD4, nC4, $06
	dc.b	nD4, $0C, $06, nRst, $24, $06, nC4, nD4, $0C, nD4, nD4
	dc.b	$06, nC4, $0C, $06, nRst, $19
	smpsAlterVol        $0E
	smpsAlterPitch      $0C
	smpsSetvoice        $02
	smpsCall            MCZ_2p_Call01
	smpsJump            MCZ_2p_Jump02

; FM3 Data
MCZ_2p_FM3:
	smpsSetvoice        $04
	dc.b	nRst, $18

MCZ_2p_Jump01:
	smpsAlterVol        $FC
	smpsCall            MCZ_2p_Call00
	smpsCall            MCZ_2p_Call00
	smpsAlterVol        $04

MCZ_2p_Loop00:
	dc.b	nB4, $0C, nB4, nB4, $06, nRst, $12, nA4, $0C, nA4, nB4, $06
	dc.b	nRst, $12, $0C, $06, nB4, $0C, nB4, nB4, $06, nA4
	dc.b	$0C, nC5, nB4, $06, nRst, $12
	smpsLoop            $00, $09, MCZ_2p_Loop00

MCZ_2p_Loop01:
	dc.b	nA4, $0C, nA4, nA4, $06, nRst, $12, nG4, $0C, nG4, nA4, $06
	dc.b	nRst, $12, nG4, $0C, $06, nG4, $0C, nG4, nG4, $06, nG4, $0C
	dc.b	nE4, nG4, $06, nRst, $12, nB4, $0C, nB4, nB4, $06, nRst, $12
	dc.b	nA4, $0C, nA4, nB4, $06, nRst, $12, $0C, $06, nB4
	dc.b	$0C, nB4, nB4, $06, nA4, $0C, nC5, nB4, $06, nRst, $12
	smpsLoop            $00, $02, MCZ_2p_Loop01
	smpsJump            MCZ_2p_Jump01

; PSG2 Data
MCZ_2p_PSG2:
	smpsNoteFill        $08
	dc.b	nRst, $18

MCZ_2p_Jump06:
	smpsCall            MCZ_2p_Call00
	smpsCall            MCZ_2p_Call00

MCZ_2p_Loop02:
	dc.b	nG4, $0C, nG4, nG4, $06, nRst, $12, nF4, $0C, nF4, nG4, $06
	dc.b	nRst, $12, $0C, $06, nG4, $0C, nG4, nG4, $06, nF4
	dc.b	$0C, nA4, nG4, $06, nRst, $12
	smpsLoop            $00, $09, MCZ_2p_Loop02

MCZ_2p_Loop03:
	dc.b	nF4, $0C, nF4, nF4, $06, nRst, $12, nE4, $0C, nE4, nF4, $06
	dc.b	nRst, $12, nE4, $0C, $06, nE4, $0C, nE4, nE4, $06, nE4, $0C
	dc.b	nC4, nE4, $06, nRst, $12, nG4, $0C, nG4, nG4, $06, nRst, $12
	dc.b	nF4, $0C, nF4, nG4, $06, nRst, $12, $0C, $06, nG4
	dc.b	$0C, nG4, nG4, $06, nF4, $0C, nA4, nG4, $06, nRst, $12
	smpsLoop            $00, $02, MCZ_2p_Loop03
	smpsJump            MCZ_2p_Jump06

; DAC Data
MCZ_2p_DAC:
	dc.b	nRst, $18

MCZ_2p_Jump00:
	dc.b	dKick, $0C, dHiClap, $06, dMidClap, dSnare, $0C, dMidClap, $06, dLowClap, dKick, $0C
	dc.b	dHiClap, $06, dLowClap, dSnare, $0C, dHiClap, $06, dLowClap
	smpsJump            MCZ_2p_Jump00

MCZ_2p_Voices:
;	Voice $00
;	$3A
;	$69, $70, $50, $60, 	$1C, $18, $1A, $18, 	$10, $0C, $02, $09
;	$08, $06, $06, $03, 	$F9, $56, $06, $06, 	$28, $15, $14, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $06, $05, $07, $06
	smpsVcCoarseFreq    $00, $00, $00, $09
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $18, $1A, $18, $1C
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $09, $02, $0C, $10
	smpsVcDecayRate2    $03, $06, $06, $08
	smpsVcDecayLevel    $00, $00, $05, $0F
	smpsVcReleaseRate   $06, $06, $06, $09
	smpsVcTotalLevel    $00, $14, $15, $28

;	Voice $01
;	$3A
;	$02, $04, $02, $02, 	$8E, $8E, $8D, $53, 	$0E, $0B, $0E, $0D
;	$01, $00, $00, $00, 	$13, $FA, $13, $0A, 	$19, $19, $29, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $02, $04, $02
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0D, $0E, $0B, $0E
	smpsVcDecayRate2    $00, $00, $00, $01
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0A, $03, $0A, $03
	smpsVcTotalLevel    $00, $29, $19, $19

;	Voice $02
;	$3D
;	$00, $01, $02, $01, 	$4C, $0F, $50, $12, 	$0C, $02, $00, $05
;	$01, $00, $00, $00, 	$28, $29, $2A, $19, 	$1A, $00, $06, $00
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $02, $01, $00
	smpsVcRateScale     $00, $01, $00, $01
	smpsVcAttackRate    $12, $10, $0F, $0C
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $00, $02, $0C
	smpsVcDecayRate2    $00, $00, $00, $01
	smpsVcDecayLevel    $01, $02, $02, $02
	smpsVcReleaseRate   $09, $0A, $09, $08
	smpsVcTotalLevel    $00, $06, $00, $1A

;	Voice $03
;	$06
;	$62, $23, $13, $71, 	$0D, $0D, $6D, $0E, 	$09, $06, $06, $06
;	$00, $00, $00, $00, 	$1F, $2F, $2F, $2F, 	$10, $94, $97, $80
	smpsVcAlgorithm     $06
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $01, $02, $06
	smpsVcCoarseFreq    $01, $03, $03, $02
	smpsVcRateScale     $00, $01, $00, $00
	smpsVcAttackRate    $0E, $2D, $0D, $0D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $06, $06, $06, $09
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $02, $02, $02, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $97, $94, $10

;	Voice $04
;	$2C
;	$71, $71, $31, $31, 	$1F, $16, $1F, $16, 	$00, $0F, $00, $0F
;	$00, $0F, $00, $0F, 	$00, $FA, $00, $FA, 	$15, $00, $14, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $01, $01, $01, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $16, $1F, $16, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0F, $00, $0F, $00
	smpsVcDecayRate2    $0F, $00, $0F, $00
	smpsVcDecayLevel    $0F, $00, $0F, $00
	smpsVcReleaseRate   $0A, $00, $0A, $00
	smpsVcTotalLevel    $00, $14, $00, $15

