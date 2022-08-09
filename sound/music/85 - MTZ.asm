MTZ_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     MTZ_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $EA

	smpsHeaderDAC       MTZ_DAC
	smpsHeaderFM        MTZ_FM1,	$F4, $0E
	smpsHeaderFM        MTZ_FM2,	$18, $0A
	smpsHeaderFM        MTZ_FM3,	$0C, $14
	smpsHeaderFM        MTZ_FM4,	$0C, $16
	smpsHeaderFM        MTZ_FM5,	$0C, $16
	smpsHeaderPSG       MTZ_PSG1,	$E8, $06, $00, $00
	smpsHeaderPSG       MTZ_PSG2,	$DC, $08, $00, $00
	smpsHeaderPSG       MTZ_PSG3,	$00, $02, $00, fTone_03

; PSG1 Data
MTZ_PSG1:
	smpsJump            MTZ_Jump02

; PSG2 Data
MTZ_PSG2:
	smpsAlterPitch      $0C
	smpsJump            MTZ_Jump02

; FM1 Data
MTZ_FM1:
	dc.b	nRst, $30, nRst
	smpsLoop            $00, $04, MTZ_FM1

MTZ_Loop09:
	dc.b	nRst, $30, nRst
	smpsLoop            $00, $04, MTZ_Loop09
	smpsAlterPitch      $0C
	smpsSetvoice        $03
	smpsModSet          $01, $02, $01, $7F
	dc.b	nB2, $60
	smpsModSet          $01, $01, $08, $06
	dc.b	smpsNoAttack, nC3
	smpsAlterVol        $04
	dc.b	smpsNoAttack, $0C
	smpsAlterVol        $04
	dc.b	smpsNoAttack, $0C
	smpsAlterVol        $04
	dc.b	smpsNoAttack, $0C
	smpsAlterVol        $04
	dc.b	smpsNoAttack, $0C, nRst, $30
	smpsAlterVol        $F0
	smpsModSet          $0C, $01, $04, $04
	smpsSetvoice        $03

MTZ_Loop0A:
	dc.b	nRst, $30, nRst, $0C
	smpsModSet          $01, $01, $0C, $0C
	dc.b	nEb3, $0C
	smpsModOff
	dc.b	smpsNoAttack, nE3, $0C, nD3, $0C, nC3, $18
	smpsModSet          $01, $01, $10, $06
	dc.b	nEb3, $06
	smpsModOff
	dc.b	smpsNoAttack, nE3, $06, nRst, $30, nRst, $0C, nRst, $30, nRst, $0C, nE3
	dc.b	nF3, nE3
	smpsModSet          $01, $01, $06, $18
	dc.b	nFs3, $0C
	smpsModOff
	dc.b	smpsNoAttack, nG3, $0C
	smpsModSet          $01, $01, $06, $18
	dc.b	nEb3, $0C
	smpsModOff
	dc.b	smpsNoAttack, nE3, $0C
	smpsModSet          $01, $01, $05, $18
	dc.b	nB2, $0C
	smpsModOff
	dc.b	smpsNoAttack, nC3, $0C, nRst, $18
	smpsLoop            $00, $02, MTZ_Loop0A
	dc.b	nRst, $30, nRst, nRst, nRst, nRst, nRst
	smpsAlterPitch      $F4
	smpsModSet          $06, $01, $08, $04
	smpsSetvoice        $00
	smpsAlterVol        $0A
	dc.b	nG5, $0A, nRst, $02, nG5, $06, nRst
	smpsAlterVol        $FB
	smpsAlterPitch      $0C
	smpsSetvoice        $03
	dc.b	nG2, $06, nBb2, nC3, nEb3, $12, nC3, $05, nRst, $07, nBb2, $06
	dc.b	nC3, $08, nRst, $0A
	smpsAlterPitch      $F4
	smpsSetvoice        $00
	smpsAlterVol        $05
	dc.b	nG5, $0A, nRst, $02, nG5, $06, nRst
	smpsAlterVol        $FB
	smpsAlterPitch      $0C
	smpsSetvoice        $03
	dc.b	nG2, $06, nBb2, nC3, nEb3, $12, nC3, $06, nRst, nBb2, $06, nC3
	dc.b	$05, nRst, $0D, nRst, $30, nRst, nRst, nRst
	smpsAlterPitch      $F4
	smpsSetvoice        $00
	smpsAlterVol        $05
	dc.b	nG5, $0A, nRst, $02, nG5, $06, nRst
	smpsAlterVol        $FB
	smpsAlterPitch      $0C
	smpsSetvoice        $03
	dc.b	nG2, $06, nBb2, nC3, nEb3, $12, nC3, $06, nRst, nBb2, $06, nC3
	dc.b	$05, nRst, $0D
	smpsAlterVol        $FB
	smpsSetvoice        $03
	smpsModSet          $01, $04, $F4, $78
	dc.b	nG4, $30
	smpsAlterVol        $04
	dc.b	smpsNoAttack, $0C
	smpsAlterVol        $04
	dc.b	smpsNoAttack, $0C
	smpsAlterVol        $04
	dc.b	smpsNoAttack, $0C
	smpsAlterVol        $04
	dc.b	smpsNoAttack, $0C
	smpsAlterVol        $F0
	smpsModOff
	smpsAlterPitch      $F4
	smpsJump            MTZ_Loop09

MTZ_Jump02:
	smpsModSet          $06, $01, $02, $04

MTZ_Loop0B:
	dc.b	nRst, $30, nRst
	smpsLoop            $00, $04, MTZ_Loop0B

MTZ_Loop0C:
	dc.b	nRst, $30, nRst
	smpsLoop            $00, $07, MTZ_Loop0C

MTZ_Loop0D:
	dc.b	nRst, $30, nRst, $0C, nE3, $18, nD3, $0C, nC3, $18, nE3, $0C
	dc.b	nRst, $30, nRst, $0C, nRst, $30, nRst, $0C, nE3, nF3, nE3, nG3
	dc.b	$18, nE3, $18, nC3, $18, nRst, $18
	smpsLoop            $00, $02, MTZ_Loop0D

MTZ_Loop0E:
	dc.b	nRst, $30, nRst
	smpsLoop            $00, $09, MTZ_Loop0E
	smpsJump            MTZ_Loop0C

; FM3 Data
MTZ_FM3:
	smpsSetvoice        $01
	smpsAlterPitch      $F4
	dc.b	nRst, $30, nRst, nRst, nRst, nF3, $0C, smpsNoAttack

MTZ_Loop05:
	smpsModSet          $01, $01, $06, $08
	dc.b	nFs3, $04
	smpsModOff
	dc.b	smpsNoAttack, nG3, $08, smpsNoAttack
	smpsModSet          $01, $01, $FA, $08
	dc.b	nFs3, $04
	smpsModOff
	dc.b	smpsNoAttack, nF3, $08
	smpsLoop            $00, $06, MTZ_Loop05
	dc.b	nRst, $24
	smpsSetvoice        $00
	smpsAlterPitch      $0C

MTZ_Loop06:
	dc.b	nRst, $18, nG4, $0B, nRst, $0D, nA4, $0C, $0B, nRst, $19, nC5
	dc.b	$0C, $0B, nRst, $0D, nG4, $30, smpsNoAttack, $0C, nRst, $18, nG4, $0B
	dc.b	nRst, $0D, nA4, $0C, $0B, nRst, $19, nC5, $0C, $0B, nRst, $0D
	dc.b	nC5, $30, smpsNoAttack, $0C
	smpsLoop            $00, $04, MTZ_Loop06

MTZ_Loop07:
	dc.b	nD6, $06, nC6, nBb5, nA5
	smpsLoop            $00, $08, MTZ_Loop07
	dc.b	nC5, $0C, $06, nRst, $30, nRst, $12, nBb4, $0C, nC6, nC6, $06
	dc.b	nRst, $30, nRst, $1E

MTZ_Loop08:
	dc.b	nD6, $06, nC6, nBb5, nA5
	smpsLoop            $00, $08, MTZ_Loop08
	dc.b	nC6, $0C, $06, nRst, $30, nRst, $1E, nD5, $06, nFs5, nCs5, nF5
	dc.b	nC5, nE5, nB4, nEb5, nB4, nD5, nBb4, nD5, nA4, nCs5, nAb4, nC5
	smpsJump            MTZ_Loop06

; FM4 Data
MTZ_FM4:
	smpsSetvoice        $01
	smpsAlterPitch      $F4
	dc.b	nRst, $30, nRst, nRst, nRst, nBb3, $0C, smpsNoAttack

MTZ_Loop03:
	smpsModSet          $01, $01, $06, $08
	dc.b	nB3, $04
	smpsModOff
	dc.b	smpsNoAttack, nC4, $08, smpsNoAttack
	smpsModSet          $01, $01, $FA, $08
	dc.b	nB3, $04
	smpsModOff
	dc.b	smpsNoAttack, nBb3, $08
	smpsLoop            $00, $06, MTZ_Loop03
	dc.b	nRst, $24
	smpsAlterPitch      $0C
	smpsSetvoice        $00

MTZ_Loop04:
	dc.b	nRst, $18, nE4, $0B, nRst, $0D, nFs4, $0C, $0B, nRst, $19, nA4
	dc.b	$0C, $0B, nRst, $0D, nE4, $30, smpsNoAttack, $0C, nRst, $18, nE4, $0B
	dc.b	nRst, $0D, nFs4, $0C, $0B, nRst, $19, nA4, $0C, $0B, nRst, $0D
	dc.b	nG4, $30, smpsNoAttack, $0C
	smpsLoop            $00, $04, MTZ_Loop04
	smpsPan             panLeft, $00
	smpsAlterPitch      $F4
	smpsSetvoice        $02
	dc.b	nF3, $30, smpsNoAttack, $30, nA3, nF3
	smpsAlterPitch      $0C
	smpsSetvoice        $00
	dc.b	nC5, $0A, nRst, $02, nC5, $06, nRst, nRst, $30, nRst, $0C, nBb3
	dc.b	nC5, $0A, nRst, $02, nC5, $06, nRst, nRst, $30, nRst, $18
	smpsAlterPitch      $F4
	smpsSetvoice        $02
	dc.b	nF3, $30, smpsNoAttack, $30, nA3, nF3
	smpsAlterPitch      $0C
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	dc.b	nC5, $0A, nRst, $02, nC5, $06, nRst, nRst, $30, nRst, nRst, nRst
	dc.b	$18
	smpsJump            MTZ_Loop04

; FM5 Data
MTZ_FM5:
	smpsSetvoice        $00
	smpsModSet          $0C, $01, $FC, $04

MTZ_Loop01:
	dc.b	nRst, $60
	smpsLoop            $00, $04, MTZ_Loop01

MTZ_Loop02:
	dc.b	nRst, $18, nC4, $0B, nRst, $0D, nD4, $0C, $0B, nRst, $19, nF4
	dc.b	$0C, $0B, nRst, $0D, nC4, $30, smpsNoAttack, $0C, nRst, $18, nC4, $0B
	dc.b	nRst, $0D, nD4, $0C, $0B, nRst, $19, nF4, $0C, $0B, nRst, $0D
	dc.b	nE4, $30, smpsNoAttack, $0C
	smpsLoop            $00, $04, MTZ_Loop02
	smpsPan             panRight, $00
	smpsAlterPitch      $F4
	smpsSetvoice        $02
	dc.b	nBb3, $30, smpsNoAttack, $30, nD4, nBb3
	smpsAlterPitch      $0C
	smpsSetvoice        $00
	dc.b	nC4, $0A, nRst, $02, nC4, $06, nRst, nRst, $30, nRst, $0C, nBb3
	dc.b	nC4, $0A, nRst, $02, nC4, $06, nRst, nRst, $30, nRst, $18
	smpsAlterPitch      $F4
	smpsSetvoice        $02
	dc.b	nBb3, $30, smpsNoAttack, $30, nD4, nBb3
	smpsAlterPitch      $0C
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	dc.b	nC4, $0A, nRst, $02, nC4, $06, nRst, nRst, $30, nRst, $18, nRst
	dc.b	$30, nRst
	smpsJump            MTZ_Loop02

; FM2 Data
MTZ_FM2:
	smpsSetvoice        $04
	dc.b	nRst, $30, nRst, nRst, nRst, nRst, nRst
	smpsAlterVol        $FC
	dc.b	nRst, nRst, $0C, nA0, nBb0, nB0
	smpsAlterVol        $04

MTZ_Jump00:
	smpsNoteFill        $09
	dc.b	nC1, $0C, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1
	dc.b	nC1
	smpsNoteFill        $00
	dc.b	nC1, nA0, nBb0, nB0
	smpsNoteFill        $09
	dc.b	nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1
	dc.b	nC1, $06, nC2
	smpsNoteFill        $00
	dc.b	nA0, $0C, nBb0, nB0
	smpsNoteFill        $09
	dc.b	nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1
	smpsNoteFill        $00
	dc.b	nC1, nA0, nBb0, nB0
	smpsNoteFill        $09
	dc.b	nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1
	smpsNoteFill        $00
	dc.b	nC1, nEb1, nD1, nCs1
	smpsNoteFill        $09
	dc.b	nC1, nC1, nC1, nC1, nC1, nC1, nC1, $0C, nC1, $06, nC1, $06
	dc.b	$0C, nC1, nC1, nC1
	smpsNoteFill        $00
	dc.b	nC1, nA0, nBb0, nB0
	smpsNoteFill        $09
	dc.b	nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1
	dc.b	nC1, $06, nC2
	smpsNoteFill        $00
	dc.b	nA0, $0C, nBb0, nB0
	smpsNoteFill        $09
	dc.b	nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1
	smpsNoteFill        $00
	dc.b	nC1, nA0, nBb0, nB0
	smpsNoteFill        $09
	dc.b	nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1, nC1
	smpsNoteFill        $00
	dc.b	nC1, nEb1, nD1, nCs1, nBb0, nBb0, nBb0, nBb0, nBb0, nBb0, nBb0, nBb0
	dc.b	nD1, nD1, nD1, nD1, nBb0, nBb0, nBb0, nBb0, nC1, nC1, $06
	smpsSetvoice        $05
	dc.b	nRst, $06, nG2, $06, nBb2, nC3, nEb3, $12, nC3, $06, nRst, nBb2
	dc.b	$06, nC3, $05, nRst, $01
	smpsSetvoice        $04
	dc.b	nBb0, $06, nB0, nC1, nRst, nC1, nRst
	smpsSetvoice        $05
	dc.b	nG2, $06, nBb2, nC3, nEb3, $12, nC3, $06, nRst, nBb2, $06, nC3
	dc.b	$05, nRst, $01
	smpsSetvoice        $04
	dc.b	nB0, $0C, nBb0, nBb0, nBb0, nBb0, nBb0, nBb0, nBb0, nBb0, nD1, nD1
	dc.b	nD1, nD1, nBb0, nBb0, nBb0, nBb0, nC1, nC1, $06
	smpsSetvoice        $05
	dc.b	nRst, $06, nG2, $06, nBb2, nC3, nEb3, $12, nC3, $06, nRst, nBb2
	dc.b	$06, nC3, $05, nRst, $01
	smpsSetvoice        $04
	dc.b	nBb0, $06, nB0, nC1, $06, nRst, $30, nRst, $2A
	smpsJump            MTZ_Jump00

MTZ_Call00:
	dc.b	dKick, $0C, dLowTom, dSnare, dKick, dKick, dFloorTom, dSnare, dScratch, $04, $06, $02
	dc.b	dKick, $0C, dLowTom, dSnare, dKick, dKick, dFloorTom, dSnare, dClap
	smpsReturn

; DAC Data
MTZ_DAC:
	smpsCall            MTZ_Call00
	smpsLoop            $00, $02, MTZ_DAC

MTZ_Loop00:
	smpsCall            MTZ_Call00
	smpsLoop            $00, $0B, MTZ_Loop00
	dc.b	dKick, $0C, dLowTom, dSnare, dKick, dKick, dFloorTom, dSnare, dScratch, $04, $06, $02
	dc.b	dKick, $0C, nRst, nRst, nRst, nRst, nRst, nRst, dClap
	smpsJump            MTZ_Loop00

; PSG3 Data
MTZ_PSG3:
	smpsPSGform         $E7

MTZ_Jump01:
	dc.b	nRst, $30, nRst, nRst, nRst, $24, nAb5, $0C
	smpsJump            MTZ_Jump01

MTZ_Voices:
;	Voice $00
;	$3C
;	$31, $52, $50, $30, 	$52, $53, $52, $53, 	$08, $00, $08, $00
;	$04, $00, $04, $00, 	$10, $0B, $10, $0D, 	$19, $80, $0B, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $05, $05, $03
	smpsVcCoarseFreq    $00, $00, $02, $01
	smpsVcRateScale     $01, $01, $01, $01
	smpsVcAttackRate    $13, $12, $13, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $08, $00, $08
	smpsVcDecayRate2    $00, $04, $00, $04
	smpsVcDecayLevel    $00, $01, $00, $01
	smpsVcReleaseRate   $0D, $00, $0B, $00
	smpsVcTotalLevel    $80, $0B, $80, $19

;	Voice $01
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $01, 	$1F, $FF, $1F, $0F, 	$17, $28, $27, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $01, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $27, $28, $17

;	Voice $02
;	$3A
;	$01, $40, $01, $31, 	$1F, $1F, $1F, $1F, 	$0B, $04, $04, $04
;	$02, $04, $03, $02, 	$5F, $1F, $5F, $2F, 	$18, $05, $11, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $00, $04, $00
	smpsVcCoarseFreq    $01, $01, $00, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $04, $04, $0B
	smpsVcDecayRate2    $02, $03, $04, $02
	smpsVcDecayLevel    $02, $05, $01, $05
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $11, $05, $18

;	Voice $03
;	$29
;	$16, $14, $58, $54, 	$1F, $1F, $DF, $1F, 	$00, $00, $01, $00
;	$00, $00, $03, $00, 	$06, $06, $06, $0A, 	$1B, $1C, $16, $00
	smpsVcAlgorithm     $01
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $05, $05, $01, $01
	smpsVcCoarseFreq    $04, $08, $04, $06
	smpsVcRateScale     $00, $03, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $01, $00, $00
	smpsVcDecayRate2    $00, $03, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0A, $06, $06, $06
	smpsVcTotalLevel    $00, $16, $1C, $1B

;	Voice $04
;	$08
;	$09, $70, $30, $00, 	$1F, $1F, $5F, $5F, 	$12, $0E, $0A, $0A
;	$00, $04, $04, $03, 	$2F, $2F, $2F, $2F, 	$25, $30, $0E, $84
	smpsVcAlgorithm     $00
	smpsVcFeedback      $01
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $03, $07, $00
	smpsVcCoarseFreq    $00, $00, $00, $09
	smpsVcRateScale     $01, $01, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0A, $0E, $12
	smpsVcDecayRate2    $03, $04, $04, $00
	smpsVcDecayLevel    $02, $02, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $84, $0E, $30, $25

;	Voice $05
;	$08
;	$09, $70, $30, $00, 	$1F, $1F, $5F, $5F, 	$12, $0E, $0A, $0A
;	$00, $04, $04, $03, 	$2F, $2F, $2F, $2F, 	$25, $30, $13, $84
	smpsVcAlgorithm     $00
	smpsVcFeedback      $01
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $03, $07, $00
	smpsVcCoarseFreq    $00, $00, $00, $09
	smpsVcRateScale     $01, $01, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0A, $0E, $12
	smpsVcDecayRate2    $03, $04, $04, $00
	smpsVcDecayLevel    $02, $02, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $84, $13, $30, $25

