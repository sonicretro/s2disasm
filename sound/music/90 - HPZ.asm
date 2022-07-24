HPZ_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     HPZ_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $E0

	smpsHeaderDAC       HPZ_DAC
	smpsHeaderFM        HPZ_FM1,	$00, $06
	smpsHeaderFM        HPZ_FM2,	$0C, $10
	smpsHeaderFM        HPZ_FM3,	$00, $14
	smpsHeaderFM        HPZ_FM4,	$00, $0E
	smpsHeaderFM        HPZ_FM5,	$F4, $14
	smpsHeaderPSG       HPZ_PSG1,	$E8, $06, $00, $00
	smpsHeaderPSG       HPZ_PSG2,	$E8, $08, $00, fTone_08
	smpsHeaderPSG       HPZ_PSG3,	$F4, $08, $00, fTone_08

; FM5 Data
HPZ_FM5:
	smpsPan             panRight, $00
	smpsModSet          $18, $01, $FE, $04
	smpsSetvoice        $03
	smpsAlterNote       $02
	smpsJump            HPZ_Loop02

; FM4 Data
HPZ_FM4:
	smpsModSet          $0C, $01, $FD, $05
	smpsSetvoice        $00
	smpsAlterNote       $02
	dc.b	nRst, $06
	smpsJump            HPZ_Jump02

; PSG1 Data
HPZ_PSG1:
	smpsModSet          $0C, $01, $01, $04
	smpsJump            HPZ_Jump02

; PSG2 Data
HPZ_PSG2:
	smpsModSet          $0C, $01, $FF, $04
	smpsAlterNote       $FF
	dc.b	nRst, $06
	smpsJump            HPZ_Jump02

; FM1 Data
HPZ_FM1:
	smpsModSet          $0C, $01, $03, $05
	smpsSetvoice        $00

HPZ_Jump02:
	dc.b	nRst, $18

HPZ_Loop04:
	dc.b	nF4, $06, nG4, nA4, $18, nG4, $0C, nA4, $18, nC5, $0C, nB4
	dc.b	nA4, nG4, nA4, $18, nF4, $06, nG4, nA4, $18, nG4, $0C, nA4
	dc.b	$18, nC5, $0C, nD5, nB4, nG4, nA4, $18, nF4, $0C, nG4, $18
	dc.b	nF4, $0C, nG4, $18, nC5, $0C, nA4, $24, nG4, $18, nF4, $0C
	dc.b	nA4, $24, nB4, nC5, nB4, $18
	smpsLoop            $01, $02, HPZ_Loop04
	dc.b	smpsNoAttack, nB4, $0C, nF5, $24, $0C, nG5, nF5, nE5, $24, nCs5, $18
	smpsJump            HPZ_Loop04

; FM2 Data
HPZ_FM2:
	smpsSetvoice        $01

HPZ_Loop03:
	dc.b	nRst, $18, nA1, $0C, nD2, $06, nRst, $12, nA1, $0C

HPZ_Jump01:
	dc.b	nD2, $06, nRst, $12, nA1, $0C, nG1, $06, nRst, $12, nG1, $0C
	dc.b	nD2, $06, nRst, $12, nA1, $0C, nD2, $06, nRst, $12, nA1, $0C
	dc.b	nD2, $06, nRst, $12, nA1, $0C, nG1, $06, nRst, $12, nG1, $0C
	dc.b	nD2, $06, nRst, $12, nD2, $0C, nG1, $06, nRst, $12, nD2, $0C
	dc.b	nG1, $06, nRst, $12, nG1, $0C, nF1, $06, nRst, $12, nC2, $0C
	dc.b	nF1, $06, nRst, $12, nC2, $0C, nD2, $06, nRst, $12, nA1, $0C
	dc.b	nD2, $06, nRst, $12, nA1, $0C, nD2, $06, nRst, $12, nA1, $0C
	smpsLoop            $00, $02, HPZ_Loop03
	dc.b	nD2, $06, nRst, $12, nA1, $0C, nBb1, $18, $0C, $18, $0C, nC2
	dc.b	$18, $0C, nCs2, $18, nA1, $0C, nD2, $06, nRst, $12, nA1, $0C
	smpsJump            HPZ_Jump01

; FM3 Data
HPZ_FM3:
	smpsPan             panLeft, $00
	smpsAlterPitch      $F4
	smpsModSet          $18, $01, $02, $04
	smpsSetvoice        $02

HPZ_Loop02:
	dc.b	nD4, $0C, nA4, nF4

HPZ_Jump00:
	dc.b	nC5, $24, smpsNoAttack, nC5, nB4, nE5, $18, nA4, $0C, nC5, $24, smpsNoAttack
	dc.b	nC5, nB4, nD5, nRst, $0C, nG4, nA4, nB4, $18, nA4, $0C, nRst
	dc.b	nA4, nB4, nC5, nB4, nC5, nD5, $24, smpsNoAttack, $18, nE5, $0C, nD5
	dc.b	$24
	smpsLoop            $00, $02, HPZ_Loop02
	smpsAlterPitch      $0C
	dc.b	smpsNoAttack, nD4, $24, nD4, nBb3, $0C, nD4, nA4, nG4, $24
	smpsAlterPitch      $F4
	dc.b	nE4, $0C, nA4, nF4
	smpsJump            HPZ_Jump00

; PSG3 Data
HPZ_PSG3:
	dc.b	nRst, $24
	smpsNoteFill        $10

HPZ_Loop05:
	smpsAlterVol        $FE
	dc.b	nF4, $06
	smpsAlterVol        $02
	dc.b	nC5, nC5, nF4, nA4, nF4
	smpsAlterVol        $FE
	dc.b	nB4
	smpsAlterVol        $02
	dc.b	nF4, nC5, nF4, nB4, nF4
	smpsLoop            $01, $10, HPZ_Loop05

HPZ_Loop06:
	dc.b	nA5, $06, nF5, nE5, nD5
	smpsLoop            $01, $04, HPZ_Loop06
	dc.b	nA5, $06, nF5, nE5, nCs5, nA5, nG5, nE5, nCs5
	smpsJump            HPZ_Loop05

HPZ_Call00:
	dc.b	dKick, $12, dSnare, $06, dFloorTom, $0C, dKick, $0C, dSnare, $12, dFloorTom, $06
	smpsReturn

; DAC Data
HPZ_DAC:
	dc.b	dSnare, $06, dMidTom, $0C, dLowTom, $06, dFloorTom, $0C

HPZ_Loop00:
	smpsCall            HPZ_Call00
	smpsLoop            $00, $07, HPZ_Loop00
	dc.b	dKick, $12, dSnare, $06, dFloorTom, $0C, dKick, $06, dMidTom, $0C, dLowTom, $06
	dc.b	dKick, $0C

HPZ_Loop01:
	smpsCall            HPZ_Call00
	smpsLoop            $00, $08, HPZ_Loop01
	dc.b	dKick, $12, dSnare, $06, dKick, $0C, dKick, $0C, dKick, dSnare, dKick, $12
	dc.b	dSnare, $06, dKick, $0C
	smpsJump            HPZ_DAC

HPZ_Voices:
;	Voice $00
;	$3B
;	$01, $02, $13, $02, 	$5D, $5D, $5D, $4A, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$05, $05, $04, $0A, 	$1E, $1E, $28, $09
	smpsVcAlgorithm     $03
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $01, $00, $00
	smpsVcCoarseFreq    $02, $03, $02, $01
	smpsVcRateScale     $01, $01, $01, $01
	smpsVcAttackRate    $0A, $1D, $1D, $1D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0A, $04, $05, $05
	smpsVcTotalLevel    $09, $28, $1E, $1E

;	Voice $01
;	$3A
;	$22, $68, $71, $32, 	$12, $16, $14, $0C, 	$0A, $06, $0A, $04
;	$00, $00, $00, $00, 	$16, $26, $56, $06, 	$1F, $22, $1C, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $07, $06, $02
	smpsVcCoarseFreq    $02, $01, $08, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0C, $14, $16, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $0A, $06, $0A
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $05, $02, $01
	smpsVcReleaseRate   $06, $06, $06, $06
	smpsVcTotalLevel    $00, $1C, $22, $1F

;	Voice $02
;	$3B
;	$32, $32, $32, $72, 	$4F, $18, $1A, $11, 	$0E, $16, $0B, $00
;	$04, $00, $00, $00, 	$50, $10, $00, $0A, 	$1B, $1F, $1E, $00
	smpsVcAlgorithm     $03
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $03, $03
	smpsVcCoarseFreq    $02, $02, $02, $02
	smpsVcRateScale     $00, $00, $00, $01
	smpsVcAttackRate    $11, $1A, $18, $0F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $0B, $16, $0E
	smpsVcDecayRate2    $00, $00, $00, $04
	smpsVcDecayLevel    $00, $00, $01, $05
	smpsVcReleaseRate   $0A, $00, $00, $00
	smpsVcTotalLevel    $00, $1E, $1F, $1B

;	Voice $03
;	$38
;	$32, $52, $32, $72, 	$17, $18, $1A, $11, 	$17, $16, $0B, $00
;	$00, $00, $00, $00, 	$10, $10, $00, $0A, 	$20, $11, $21, $00
	smpsVcAlgorithm     $00
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $05, $03
	smpsVcCoarseFreq    $02, $02, $02, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $11, $1A, $18, $17
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $0B, $16, $17
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $01, $01
	smpsVcReleaseRate   $0A, $00, $00, $00
	smpsVcTotalLevel    $00, $21, $11, $20

