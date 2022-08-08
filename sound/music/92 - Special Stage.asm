SpecStg_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     SpecStg_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $FF

	smpsHeaderDAC       SpecStg_DAC
	smpsHeaderFM        SpecStg_FM1,	$0C, $08
	smpsHeaderFM        SpecStg_FM2,	$00, $05
	smpsHeaderFM        SpecStg_FM3,	$00, $0E
	smpsHeaderFM        SpecStg_FM4,	$00, $0E
	smpsHeaderFM        SpecStg_FM5,	$00, $0F
	smpsHeaderPSG       SpecStg_PSG1,	$DC, $02, $00, fTone_0B
	smpsHeaderPSG       SpecStg_PSG2,	$DC, $04, $00, fTone_0B
	smpsHeaderPSG       SpecStg_PSG3,	$00, $01, $00, $00

; FM1 Data
SpecStg_FM1:
	smpsAlterVol        $08
	smpsAlterPitch      $E8
	smpsPan             panRight, $00
	smpsSetvoice        $02
	smpsCall            SpecStg_Call00
	smpsAlterPitch      $18
	smpsPan             panCenter, $00
	smpsAlterVol        $F8
	smpsSetvoice        $03

SpecStg_Loop0C:
	dc.b	nE2, $06, nE3, nAb1, $0C, nA1, nBb1, nG2, $06, nG3, nCs2, $0C
	dc.b	nD2, nEb2, nE2, $06, nE3, nAb1, $0C, nA1, nBb1, nG2, $06, nG3
	dc.b	nCs2, $0C, nD2, nEb2, nE2, $06, nE3, nAb1, $0C, nA1, nBb1, nG2
	dc.b	$06, nG3, nCs2, $0C, nD2, nEb2, nE2, $06, nE3, nAb1, $0C, nA1
	dc.b	nBb1, nB1, $06, nB2, nCs2, $0C, nD2, nEb2
	smpsLoop            $00, $07, SpecStg_Loop0C
	smpsJump            SpecStg_Loop0C

; FM2 Data
SpecStg_FM2:
	smpsSetvoice        $06
	smpsAlterVol        $0A
	smpsAlterPitch      $F4
	smpsPan             panLeft, $00
	smpsModSet          $06, $01, $02, $04
	smpsCall            SpecStg_Call00
	dc.b	nAb5, $06, nRst, $30, nRst, $2A
	smpsAlterPitch      $0C
	smpsAlterVol        $F6
	smpsPan             panCenter, $00
	dc.b	nRst, $30, $30
	smpsSetvoice        $05
	dc.b	nG4, $12, nAb4, nA4, $0C, nBb4, $12, nB4, nC5, $0C, nB4, $12
	dc.b	nC5, nCs5, $0C, nC5, $12, nCs5, nD5, $0C
	smpsAlterVol        $02

SpecStg_Loop0A:
	smpsSetvoice        $00
	smpsPan             panCenter, $00
	smpsModSet          $01, $01, $08, $04
	dc.b	nE5, $18, nAb5, $0C, nB5, $18, nA5, nAb5, $0C, smpsNoAttack, nAb5, nFs5
	dc.b	$18, nE5, nAb5, $0C
	smpsModSet          $18, $01, $10, $04
	dc.b	nFs5, nE5, nD5, $30, smpsNoAttack, $30
	smpsModSet          $01, $01, $08, $04
	dc.b	nRst, $30, nRst, nE5, $18, nAb5, $0C, nB5, $18, nA5, nAb5, $0C
	dc.b	smpsNoAttack, nAb5, nFs5, $18, nE5, nAb5, $0C
	smpsModSet          $18, $01, $10, $04
	dc.b	nFs5, nE5, nD6, $30, smpsNoAttack, $30, nRst, $30, nRst
	smpsLoop            $00, $02, SpecStg_Loop0A
	smpsAlterVol        $FE
	smpsPan             panRight, $00

SpecStg_Loop0B:
	smpsSetvoice        $05
	dc.b	nB4, $06, nRst, nB4, nRst, nCs5, nB4, $12, nE5, $0C, nRst, nE5
	dc.b	nRst, nB4, $06, nRst, nB4, nRst, nCs5, nB4, $12, nAb4, $18, nRst
	dc.b	nB4, $06, nRst, nB4, nRst, nCs5, nB4, $12, nE5, $06, nRst, nE5
	dc.b	nRst, nCs5, nE5, $12, nB4, $06, nRst, nB4, nRst, nCs5, nB4, $12
	dc.b	nAb4, $18, nRst
	smpsLoop            $00, $02, SpecStg_Loop0B
	smpsAlterVol        $02
	smpsJump            SpecStg_Loop0A

SpecStg_Call00:
	dc.b	nE5, $06
	smpsAlterVol        $10
	dc.b	$06, nRst, $0C
	smpsAlterVol        $F0
	dc.b	nAb5, $08, nE5, nAb5, nB5, $06
	smpsAlterVol        $10
	dc.b	$06, nRst, $0C
	smpsAlterVol        $F0
	dc.b	nA5, $06
	smpsAlterVol        $10
	dc.b	$06, nRst, $0C
	smpsAlterVol        $F0
	dc.b	nAb5, $24, nFs5, $06
	smpsAlterVol        $10
	dc.b	$06
	smpsAlterVol        $F0
	dc.b	nE5
	smpsAlterVol        $10
	dc.b	$06, nRst, $0C
	smpsAlterVol        $F0
	dc.b	nEb5, $18, smpsNoAttack, $30, smpsNoAttack, $24, nRst, $0C
	smpsReturn

; FM3 Data
SpecStg_FM3:
	smpsSetvoice        $02
	smpsAlterNote       $F8
	smpsPan             panLeft, $00
	smpsCall            SpecStg_Call00
	smpsPan             panCenter, $00
	smpsSetvoice        $05
	smpsAlterNote       $00
	dc.b	nAb5, $06, nRst, $30, nRst, $2A, nRst, $30, nRst, nG4, $12, nAb4
	dc.b	nA4, $0C, nBb4, $12, nB4, nC5, $0C, nB4, $12, nC5, nCs5, $0C
	dc.b	nC5, $12, nCs5, nD5, $0C

SpecStg_Loop08:
	dc.b	nRst, $30, nRst, nRst, nRst

SpecStg_Loop07:
	smpsPan             panRight, $00
	dc.b	nAb4, $06, nRst, $0C, nAb4, $06, nRst, $0C, nAb4, $06, nRst, nFs4
	dc.b	$12, nAb4, $06, nRst, $18
	smpsLoop            $01, $02, SpecStg_Loop07
	smpsPan             panCenter, $00
	dc.b	nRst, $30, nRst, nRst, nRst, nAb4, $06, nRst, $0C, $06, nRst
	dc.b	$0C, nAb4, $06, nRst, nAb4, nRst, $0C, $06, nRst, $0C, nAb4
	dc.b	$06, nRst, nAb4, nRst, $0C, $06, nRst, $0C, nAb4, $06, nRst
	dc.b	nAb4, nRst, $2A
	smpsLoop            $00, $02, SpecStg_Loop08
	smpsPan             panLeft, $00
	smpsAlterNote       $FE
	smpsAlterVol        $F8

SpecStg_Loop09:
	dc.b	nB4, $06, nRst, nB4, nRst, nCs5, nB4, $12, nE5, $0C, nRst, nE5
	dc.b	nRst, nB4, $06, nRst, nB4, nRst, nCs5, nB4, $12, nAb4, $18, nRst
	dc.b	nB4, $06, nRst, nB4, nRst, nCs5, nB4, $12, nE5, $06, nRst, nE5
	dc.b	nRst, nCs5, nE5, $12, nB4, $06, nRst, nB4, nRst, nCs5, nB4, $12
	dc.b	nAb4, $18, nRst
	smpsLoop            $00, $02, SpecStg_Loop09
	smpsAlterNote       $00
	smpsAlterVol        $08
	smpsJump            SpecStg_Loop08

; FM4 Data
SpecStg_FM4:
	smpsSetvoice        $06
	smpsAlterNote       $08
	smpsPan             panRight, $00
	smpsCall            SpecStg_Call00
	smpsPan             panCenter, $00
	smpsSetvoice        $05
	smpsAlterNote       $00
	dc.b	nE5, $06, nRst, $30, nRst, $2A, nRst, $30, nRst, nEb4, $12, nE4
	dc.b	nF4, $0C, nFs4, $12, nG4, nAb4, $0C, nG4, $12, nAb4, nA4, $0C
	dc.b	nAb4, $12, nA4, nBb4, $0C

SpecStg_Loop05:
	dc.b	nRst, $30, nRst, nRst, nRst

SpecStg_Loop04:
	dc.b	nE4, $06, nRst, $0C, nE4, $06, nRst, $0C, nE4, $06, nRst, nD4
	dc.b	$12, nE4, $06, nRst, $18
	smpsLoop            $01, $02, SpecStg_Loop04
	dc.b	nRst, $30, nRst, nRst, nRst, nE4, $06, nRst, $0C, $06, nRst
	dc.b	$0C, nE4, $06, nRst, nE4, nRst, $0C, $06, nRst, $0C, nE4
	dc.b	$06, nRst, nE4, nRst, $0C, $06, nRst, $0C, nE4, $06, nRst
	dc.b	nE4, nRst, $2A
	smpsLoop            $00, $02, SpecStg_Loop05

SpecStg_Loop06:
	dc.b	nAb4, $06, nRst, nAb4, nRst, nA4, nAb4, $12, nB4, $0C, nRst, nB4
	dc.b	nRst, nAb4, $06, nRst, nAb4, nRst, nA4, nAb4, $12, nE4, $18, nRst
	dc.b	nAb4, $06, nRst, nAb4, nRst, nA4, nAb4, $12, nB4, $06, nRst, nB4
	dc.b	nRst, nA4, nB4, $12, nAb4, $06, nRst, nAb4, nRst, nA4, nAb4, $12
	dc.b	nE4, $18, nRst
	smpsLoop            $00, $02, SpecStg_Loop06
	smpsJump            SpecStg_Loop05

; FM5 Data
SpecStg_FM5:
	smpsAlterPitch      $F4
	smpsPan             panCenter, $00
	smpsSetvoice        $06
	smpsAlterNote       $FA
	smpsCall            SpecStg_Call00
	smpsAlterPitch      $0C
	smpsSetvoice        $01
	smpsModSet          $06, $01, $02, $03

SpecStg_Loop03:
	smpsPan             panCenter, $00
	dc.b	nAb5, $0C, nE5
	smpsPan             panLeft, $00
	dc.b	nFs5, nD5, $06
	smpsPan             panCenter, $00
	dc.b	nAb5, $0C, $06
	smpsPan             panRight, $00
	dc.b	nE5, $0C, nFs5
	smpsPan             panCenter, $00
	dc.b	nD5
	smpsLoop            $00, $1C, SpecStg_Loop03
	smpsJump            SpecStg_Loop03

; PSG1 Data
SpecStg_PSG1:
	dc.b	nRst, $30, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	dc.b	nRst, nRst, nRst

SpecStg_Loop11:
	dc.b	nE5, $18, nAb5, $0C, nB5, $18, nA5, nAb5, $0C, smpsNoAttack, nAb5, nFs5
	dc.b	$18, nE5, nAb5, $0C, nFs5, nE5, nD5, $30, smpsNoAttack, $30, nRst, $30
	dc.b	nRst, nE5, $18, nAb5, $0C, nB5, $18, nA5, nAb5, $0C, smpsNoAttack, nAb5
	dc.b	nFs5, $18, nE5, nAb5, $0C, nFs5, nE5, nD6, $30, smpsNoAttack, $30, nRst
	dc.b	$30, nRst
	smpsLoop            $00, $02, SpecStg_Loop11
	dc.b	nRst, $30, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	smpsPSGAlterVol     $FF
	smpsAlterPitch      $F4
	dc.b	nB6, $06, nRst, nB6, nRst, nCs7, nB6, $12, nE7, $0C, nRst, nE7
	dc.b	nRst, nB6, $06, nRst, nB6, nRst, nCs7, nB6, $12, nAb6, $18, nRst
	dc.b	nB6, $06, nRst, nB6, nRst, nCs7, nB6, $12, nE7, $06, nRst, nE7
	dc.b	nRst, nCs7, nE7, $12, nB6, $06, nRst, nB6, nRst, nCs7, nB6, $12
	dc.b	nAb6, $18, nRst
	smpsAlterPitch      $0C
	smpsPSGAlterVol     $01
	smpsJump            SpecStg_Loop11

; PSG2 Data
SpecStg_PSG2:
	smpsAlterNote       $FF
	dc.b	nRst, $30, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	dc.b	nRst, nRst, nRst

SpecStg_Jump00:
	dc.b	nRst, $12, nE5, $18, nAb5, $0C, nB5, $18, nA5, nAb5, $0C, smpsNoAttack
	dc.b	nAb5, nFs5, $18, nE5, nAb5, $0C, nFs5, nE5, nD5, $30, smpsNoAttack, $30
	dc.b	nRst, $30, nRst, nE5, $18, nAb5, $0C, nB5, $18, nA5, nAb5, $0C
	dc.b	smpsNoAttack, nAb5, nFs5, $18, nE5, nAb5, $0C, nFs5, nE5, nD6, $30, smpsNoAttack
	dc.b	$30, nRst, $30, nRst, $1E
	smpsPSGAlterVol     $FC
	dc.b	nAb5, $18, nB5, $0C, nEb6, $18, nCs6, nB5, $0C, smpsNoAttack, nB5, nA5
	dc.b	$18, nAb5, nB5, $0C, nA5, nAb5, nFs5, $30, smpsNoAttack, $30, nRst, $30
	dc.b	nRst, nAb5, $18, nB5, $0C, nEb6, $18, nCs6, nB5, $0C, smpsNoAttack, nB5
	dc.b	nA5, $18, nAb5, nB5, $0C, nA5, nAb5, nFs6, $30, smpsNoAttack, $30, nRst
	dc.b	$30, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	smpsAlterPitch      $E8
	dc.b	nAb6, $06, nRst, nAb6, nRst, nA6, nAb6, $12, nB6, $0C, nRst, nB6
	dc.b	nRst, nAb6, $06, nRst, nAb6, nRst, nA6, nAb6, $12, nE6, $18, nRst
	dc.b	nAb6, $06, nRst, nAb6, nRst, nA6, nAb6, $12, nB6, $06, nRst, nB6
	dc.b	nRst, nA6, nB6, $12, nAb6, $06, nRst, nAb6, nRst, nA6, nAb6, $12
	dc.b	nE6, $18, nRst
	smpsPSGAlterVol     $04
	smpsAlterPitch      $18
	smpsJump            SpecStg_Jump00

; DAC Data
SpecStg_DAC:
	dc.b	nRst, $30, nRst, nRst, nRst, nRst, nRst

SpecStg_Loop00:
	dc.b	dKick, $18, dKick, dKick, dKick, $0C, dSnare
	smpsLoop            $00, $03, SpecStg_Loop00
	dc.b	dKick, $18, dKick, dKick, dKick, $0C, dSnare, $06, dKick

SpecStg_Loop01:
	dc.b	dKick, $18, dSnare, dKick, dSnare, dKick, dSnare, dKick, dSnare, dKick, dSnare, $12
	dc.b	dSnare, dKick, $0C, dSnare, $18, dKick, $0C, dKick, dSnare, $12, dSnare, dKick
	dc.b	$0C, dSnare, dKick, $06, dKick
	smpsLoop            $00, $04, SpecStg_Loop01

SpecStg_Loop02:
	dc.b	dKick, $18, dSnare, $12, $06, dKick, $18, dSnare, dKick, dSnare, $12, dSnare
	dc.b	dKick, $0C, dSnare, $18, dKick, dSnare, $12, $06, dKick, $18, dSnare, dKick
	dc.b	dSnare, $12, dSnare, dKick, $0C, dSnare, $18
	smpsLoop            $00, $02, SpecStg_Loop02
	smpsJump            SpecStg_Loop01

; PSG3 Data
SpecStg_PSG3:
	smpsPSGform         $E7
	smpsPSGvoice        fTone_04
	smpsNoteFill        $03
	dc.b	nRst, $30, nRst, nRst, nRst, nRst, nRst

SpecStg_Loop0D:
	dc.b	nMaxPSG, $0C, $06, nMaxPSG, nMaxPSG, nMaxPSG, $0C, nMaxPSG, nMaxPSG, $06, nMaxPSG, nMaxPSG
	dc.b	nMaxPSG, $0C, nMaxPSG
	smpsLoop            $00, $03, SpecStg_Loop0D
	dc.b	nMaxPSG, $0C, $06, nMaxPSG, nMaxPSG, nMaxPSG, $0C, nMaxPSG, nMaxPSG, $06, nMaxPSG, nMaxPSG
	dc.b	nMaxPSG, $0C, nMaxPSG

SpecStg_Loop0E:
	dc.b	nMaxPSG, $12, nMaxPSG, $06, nMaxPSG, nMaxPSG, nMaxPSG, nMaxPSG, $0C, $06, $0C, $06
	dc.b	$0C, $06, $0C, nMaxPSG, $06, nMaxPSG, nMaxPSG, $0C, $06, $0C, $06, $0C
	dc.b	$06, $0C, $06, $0C, nMaxPSG, nMaxPSG, nMaxPSG, nMaxPSG, $24, nMaxPSG, $0C, nMaxPSG
	dc.b	$06, nMaxPSG, nMaxPSG, $0C, nMaxPSG, nMaxPSG, nMaxPSG, $18, nMaxPSG, $0C, nMaxPSG
	smpsLoop            $00, $04, SpecStg_Loop0E

SpecStg_Loop0F:
	dc.b	nMaxPSG, $18, $06, nMaxPSG, $0C, nMaxPSG, nMaxPSG, $06, nMaxPSG, $0C, nMaxPSG, nMaxPSG
	smpsLoop            $00, $04, SpecStg_Loop0F

SpecStg_Loop10:
	dc.b	nMaxPSG, $0C, $06, nMaxPSG, nMaxPSG, nMaxPSG, $0C, nMaxPSG, nMaxPSG, $06, nMaxPSG, nMaxPSG
	dc.b	nMaxPSG, $0C, nMaxPSG
	smpsLoop            $00, $04, SpecStg_Loop10
	smpsJump            SpecStg_Loop0E

SpecStg_Voices:
;	Voice $00
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $00
;	$00, $00, $00, $04, 	$1F, $FF, $1F, $0F, 	$18, $28, $27, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $0E, $0E, $0E
	smpsVcDecayRate2    $04, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $27, $28, $18

;	Voice $01
;	$3A
;	$07, $06, $02, $01, 	$5F, $5F, $5F, $9F, 	$02, $02, $0A, $07
;	$02, $03, $03, $06, 	$52, $72, $A2, $B5, 	$1A, $1C, $23, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $02, $06, $07
	smpsVcRateScale     $02, $01, $01, $01
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $07, $0A, $02, $02
	smpsVcDecayRate2    $06, $03, $03, $02
	smpsVcDecayLevel    $0B, $0A, $07, $05
	smpsVcReleaseRate   $05, $02, $02, $02
	smpsVcTotalLevel    $80, $23, $1C, $1A

;	Voice $02
;	$3D
;	$01, $21, $51, $01, 	$12, $14, $14, $0F, 	$0A, $05, $05, $05
;	$00, $00, $00, $00, 	$2B, $2B, $2B, $1B, 	$19, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $05, $02, $00
	smpsVcCoarseFreq    $01, $01, $01, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0F, $14, $14, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $05, $05, $0A
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $02, $02, $02
	smpsVcReleaseRate   $0B, $0B, $0B, $0B
	smpsVcTotalLevel    $80, $80, $80, $19

;	Voice $03
;	$38
;	$3A, $30, $30, $30, 	$1F, $1F, $5F, $5F, 	$12, $0E, $0A, $0A
;	$00, $04, $04, $03, 	$26, $26, $26, $26, 	$24, $2D, $12, $00
	smpsVcAlgorithm     $00
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $00, $00, $00, $0A
	smpsVcRateScale     $01, $01, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0A, $0E, $12
	smpsVcDecayRate2    $03, $04, $04, $00
	smpsVcDecayLevel    $02, $02, $02, $02
	smpsVcReleaseRate   $06, $06, $06, $06
	smpsVcTotalLevel    $00, $12, $2D, $24

;	Voice $04
;	$3D
;	$01, $21, $50, $01, 	$12, $14, $14, $0F, 	$0A, $05, $05, $05
;	$00, $00, $00, $00, 	$26, $28, $28, $18, 	$19, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $05, $02, $00
	smpsVcCoarseFreq    $01, $00, $01, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0F, $14, $14, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $05, $05, $0A
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $02, $02, $02
	smpsVcReleaseRate   $08, $08, $08, $06
	smpsVcTotalLevel    $80, $80, $80, $19

;	Voice $05
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $07, 	$1F, $FF, $1F, $0F, 	$18, $28, $27, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $07, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $27, $28, $18

;	Voice $06
;	$3A
;	$31, $37, $31, $31, 	$8D, $8D, $8E, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$13, $FA, $13, $0A, 	$17, $28, $26, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0E, $0D, $0D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0A, $03, $0A, $03
	smpsVcTotalLevel    $00, $26, $28, $17

