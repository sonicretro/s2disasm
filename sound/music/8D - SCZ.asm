SCZ_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     SCZ_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $5B

	smpsHeaderDAC       SCZ_DAC
	smpsHeaderFM        SCZ_FM1,	$F4, $12
	smpsHeaderFM        SCZ_FM2,	$E8, $0E
	smpsHeaderFM        SCZ_FM3,	$F4, $09
	smpsHeaderFM        SCZ_FM4,	$F4, $10
	smpsHeaderFM        SCZ_FM5,	$DC, $24
	smpsHeaderPSG       SCZ_PSG1,	$F4, $0C, $00, $00
	smpsHeaderPSG       SCZ_PSG2,	$F9, $09, $00, $00
	smpsHeaderPSG       SCZ_PSG3,	$00, $04, $00, fTone_04

; FM4 Data
SCZ_FM4:
	smpsSetvoice        $03

SCZ_Loop03:
	smpsCall            SCZ_Call07
	smpsLoop            $00, $02, SCZ_Loop03

SCZ_Jump03:
	smpsPan             panRight, $00
	smpsAlterNote       $FE
	smpsAlterVol        $14
	smpsAlterPitch      $E8
	smpsSetvoice        $04
	smpsCall            SCZ_Call05
	smpsSetvoice        $03
	smpsAlterPitch      $18
	smpsAlterVol        $EC
	smpsAlterNote       $00
	smpsPan             panCenter, $00

SCZ_Loop04:
	smpsCall            SCZ_Call07
	smpsLoop            $00, $08, SCZ_Loop04
	smpsJump            SCZ_Jump03

SCZ_Call07:
	dc.b	nB6, $06, nG6, nA6, nD6, nB6, nG6, nA6, nD6
	smpsReturn

; FM5 Data
SCZ_FM5:
	smpsSetvoice        $04
	dc.b	nRst, $60

SCZ_Jump02:
	smpsPan             panLeft, $00
	smpsAlterNote       $02
	smpsCall            SCZ_Call05
	smpsAlterNote       $00
	smpsPan             panCenter, $00
	smpsAlterVol        $FB
	smpsCall            SCZ_Call06
	dc.b	nD6, $03, $03, $06, smpsNoAttack
	smpsAlterVol        $02
	dc.b	$02, smpsNoAttack
	smpsAlterVol        $02
	dc.b	$02, smpsNoAttack
	smpsAlterVol        $02
	dc.b	$02, nRst, $12, nC6, $06, nD6
	smpsAlterVol        $FA
	smpsCall            SCZ_Call06
	dc.b	nD6, $30
	smpsAlterVol        $05
	smpsJump            SCZ_Jump02

SCZ_Call05:
	dc.b	nG6, $30, nD6
	smpsLoop            $00, $04, SCZ_Call05
	smpsReturn

SCZ_Call06:
	dc.b	nG6, $03, $03, $06, smpsNoAttack
	smpsAlterVol        $02
	dc.b	$02, smpsNoAttack
	smpsAlterVol        $02
	dc.b	$02, smpsNoAttack
	smpsAlterVol        $02
	dc.b	$02, nRst, $1E
	smpsAlterVol        $FA
	dc.b	nD6, $03, $03, $06, smpsNoAttack
	smpsAlterVol        $02
	dc.b	$02, smpsNoAttack
	smpsAlterVol        $02
	dc.b	$02, smpsNoAttack
	smpsAlterVol        $02
	dc.b	$02, nRst, $1E
	smpsAlterVol        $FA
	dc.b	nC6, $03, $03, $06, smpsNoAttack
	smpsAlterVol        $02
	dc.b	$02, smpsNoAttack
	smpsAlterVol        $02
	dc.b	$02, smpsNoAttack
	smpsAlterVol        $02
	dc.b	$02, nRst, $1E
	smpsAlterVol        $FA
	smpsReturn

; FM1 Data
SCZ_FM1:
	smpsSetvoice        $06
	dc.b	nRst, $06, nG4, $03, nA4, nG4, $0C, nB4, $03, nC5, nB4, $0C
	dc.b	nD5, $03, nE5, nD5, $30

SCZ_Jump01:
	dc.b	nRst, $12, nE6, $03, nFs6, nG6, $06, nFs6, nE6, nD6, nB5, $30
	dc.b	nRst, $12, nE6, $03, nG6, nA6, $06, nG6, nFs6, nE6, nD6, $03
	dc.b	nE6, nD6, nB5, $27, nRst, $12, nE6, $03, nG6, nFs6, $06, nD6
	dc.b	nB5, nE6, nD6, $30, nRst, $12, nE6, $03, nG6, nA6, $06, nG6
	dc.b	nFs6, nE6, nD6, $03, nE6, nD6, nB5, $27
	smpsSetvoice        $00
	smpsCall            SCZ_Call04
	dc.b	nB4, $0C, nG4, nA4, nG4, $06, nA4
	smpsCall            SCZ_Call04
	dc.b	nB4, $30
	smpsJump            SCZ_Jump01

SCZ_Call04:
	dc.b	nB4, $0C, nG4, nA4, nD4
	smpsLoop            $00, $03, SCZ_Call04
	smpsReturn

; FM3 Data
SCZ_FM3:
	smpsAlterNote       $02
	smpsSetvoice        $01
	dc.b	nRst, $06, nB4, $03, nC5, nB4, $0C, nD5, $03, nE5, nD5, $0C
	dc.b	nG5, $03, nA5, nG5, $30

SCZ_Jump00:
	smpsSetvoice        $05
	smpsAlterVol        $12
	dc.b	nRst, $12, nE6, $03, nFs6, nG6, $06, nFs6, nE6, nD6, nB5, $18
	smpsSetvoice        $01
	smpsAlterVol        $EE
	smpsNoteFill        $0B
	dc.b	nG5, $06, nD5, nE5, $03, nG5, $06
	smpsNoteFill        $00
	dc.b	$15
	smpsSetvoice        $05
	smpsAlterVol        $12
	dc.b	nE6, $03, nG6, nA6, $06, nG6, nFs6, nE6, nD6, $03, nE6, nD6
	dc.b	nB5, $0F
	smpsSetvoice        $01
	smpsAlterVol        $EE
	dc.b	nA5, $0C, nB5, nG5, $12
	smpsSetvoice        $05
	smpsAlterVol        $12
	dc.b	nE6, $03, nG6, nFs6, $06, nD6, nB5, nE6, nD6, $18
	smpsSetvoice        $01
	smpsAlterVol        $EE
	smpsNoteFill        $0B
	dc.b	nG5, $06, nD5, nE5, $03, nG5, $06
	smpsNoteFill        $00
	dc.b	$15
	smpsSetvoice        $05
	smpsAlterVol        $12
	dc.b	nE6, $03, nG6, nA6, $06, nG6, nFs6, nE6, nD6, $03, nE6
	smpsSetvoice        $01
	smpsAlterVol        $EE
	dc.b	nB4, $03, nC5, nB4, $0C, nD5, $03, nE5, nD5, $0C, nG5, $03
	dc.b	nA5
	smpsAlterVol        $FC
	smpsCall            SCZ_Call03
	dc.b	nG5, $2A, nA5, $03, nB5, $33
	smpsCall            SCZ_Call03
	dc.b	nG5, $24, nA5, $0C, nG5, $30
	smpsAlterVol        $04
	smpsJump            SCZ_Jump00

SCZ_Call03:
	dc.b	nRst, $12, nG5, $03, nA5, nB5, $0C, nC6, $03, nB5, nC6, nD6
	dc.b	$27, nE6, $0C
	smpsReturn

; FM2 Data
SCZ_FM2:
	smpsSetvoice        $02
	dc.b	nRst, $51, nG3, $03, nA3, $06, nB3

SCZ_Loop02:
	dc.b	nC4, $03, $0F, $03, $0C, nG4, $03, nA4, $06, nG4, nG3, $03
	dc.b	$0F, $0F, nD4, $03, nE4, $06, nD4
	smpsLoop            $00, $04, SCZ_Loop02
	smpsCall            SCZ_Call02
	dc.b	nA3, $03, $0F, $0C, $09, $09, nG3, $03, $0F, $0C, $06, nA3
	dc.b	nB3
	smpsCall            SCZ_Call02
	dc.b	nA3, $03, $0F, $0C, $06, nB3, nA3, nG3, $30
	smpsJump            SCZ_Loop02

SCZ_Call02:
	dc.b	nC4, $03, $0F, $0C, $09, $09, nB3, $03, nB3, $0F, $0C, $06
	dc.b	nC4, nB3
	smpsReturn

; DAC Data
SCZ_DAC:
	smpsCall            SCZ_Call00
	smpsLoop            $00, $02, SCZ_DAC

SCZ_Loop00:
	smpsCall            SCZ_Call00
	smpsLoop            $00, $03, SCZ_Loop00
	smpsCall            SCZ_Call01
	smpsLoop            $01, $03, SCZ_Loop00

SCZ_Loop01:
	smpsCall            SCZ_Call00
	smpsLoop            $00, $03, SCZ_Loop01
	dc.b	dKick, $0C, nRst, nRst, dSnare, $06, dSnare, $03, dSnare
	smpsJump            SCZ_Loop00

SCZ_Call00:
	dc.b	dKick, $03, dKick, nRst, $06, dSnare, dKick, nRst, dKick, dSnare, $03, dKick
	dc.b	$09
	smpsReturn

SCZ_Call01:
	dc.b	dKick, $03, dKick, nRst, $06, dSnare, dKick, nRst, dKick, dSnare, dSnare, $03
	dc.b	dSnare
	smpsReturn

; PSG1 Data
SCZ_PSG1:
	dc.b	nRst, $60

SCZ_Loop05:
	dc.b	nG4, $30, nFs4
	smpsLoop            $00, $04, SCZ_Loop05
	smpsAlterVol        $FE
	dc.b	nG4, $03, $03, $06, nRst, $24, nFs4, $03, $03, $06, nRst, $24
	dc.b	nE4, $03, $03, $06, nRst, $24, nD4, $03, $03, $06, nRst, $18
	dc.b	nE4, $06, nFs4, nG4, $03, $03, $06, nRst, $24, nFs4, $03, $03
	dc.b	$06, nRst, $24, nE4, $03, $03, $06, nRst, $24, nFs4, $30
	smpsAlterVol        $02
	smpsJump            SCZ_Loop05

; PSG2 Data
SCZ_PSG2:
	dc.b	nRst, $60
	smpsPSGvoice        fTone_08

SCZ_Jump05:
	dc.b	nRst, $12, nD6, $03, nD6, nD6, $06, nD6, nD6, nD6, nD6, $30
	dc.b	nRst, $12, nD6, $03, nD6, nD6, $06, nD6, nD6, nD6, nD6, $03
	dc.b	nD6, nD6, nD6, $27, nRst, $12, nD6, $03, nD6, nD6, $06, nD6
	dc.b	nD6, nD6, nD6, $30, nRst, $12, nD6, $03, nD6, nD6, $06, nD6
	dc.b	nD6, nD6, nD6, $03, nD6, nD6, nD6, $27
	smpsAlterVol        $01
	dc.b	nB4, $03, $03, $06, nRst, $24, nA4, $03, $03, $06, nRst, $24
	dc.b	nG4, $03, $03, $06, nRst, $24, nFs4, $03, $03, $06, nRst, $18
	dc.b	nG4, $06, nA4, nB4, $03, $03, $06, nRst, $24, nA4, $03, $03
	dc.b	$06, nRst, $24, nG4, $03, $03, $06, nRst, $24, nD4, $30
	smpsAlterVol        $FF
	smpsJump            SCZ_Jump05

; PSG3 Data
SCZ_PSG3:
	smpsPSGform         $E7
	smpsNoteFill        $09

SCZ_Jump04:
	dc.b	nMaxPSG, $0C
	smpsJump            SCZ_Jump04

SCZ_Voices:
;	Voice $00
;	$02
;	$62, $01, $34, $01, 	$59, $59, $59, $51, 	$04, $04, $04, $07
;	$01, $01, $01, $01, 	$12, $12, $12, $17, 	$1E, $19, $25, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $03, $00, $06
	smpsVcCoarseFreq    $01, $04, $01, $02
	smpsVcRateScale     $01, $01, $01, $01
	smpsVcAttackRate    $11, $19, $19, $19
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $07, $04, $04, $04
	smpsVcDecayRate2    $01, $01, $01, $01
	smpsVcDecayLevel    $01, $01, $01, $01
	smpsVcReleaseRate   $07, $02, $02, $02
	smpsVcTotalLevel    $00, $25, $19, $1E

;	Voice $01
;	$3A
;	$11, $1A, $00, $11, 	$89, $59, $4F, $4F, 	$0A, $0D, $06, $09
;	$00, $00, $00, $01, 	$1F, $FF, $0F, $5F, 	$20, $2E, $3B, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $01, $00, $01, $01
	smpsVcCoarseFreq    $01, $00, $0A, $01
	smpsVcRateScale     $01, $01, $01, $02
	smpsVcAttackRate    $0F, $0F, $19, $09
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $09, $06, $0D, $0A
	smpsVcDecayRate2    $01, $00, $00, $00
	smpsVcDecayLevel    $05, $00, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $3B, $2E, $20

;	Voice $02
;	$3D
;	$01, $42, $02, $22, 	$1F, $1F, $1F, $1F, 	$07, $00, $00, $00
;	$00, $0E, $0E, $0E, 	$24, $0F, $0F, $0F, 	$1C, $89, $89, $89
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $02, $00, $04, $00
	smpsVcCoarseFreq    $02, $02, $02, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $07
	smpsVcDecayRate2    $0E, $0E, $0E, $00
	smpsVcDecayLevel    $00, $00, $00, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $04
	smpsVcTotalLevel    $09, $09, $09, $1C

;	Voice $03
;	$04
;	$57, $07, $74, $54, 	$1F, $1B, $1F, $1F, 	$00, $00, $00, $00
;	$06, $0A, $00, $0D, 	$00, $0F, $00, $0F, 	$1A, $98, $25, $8F
	smpsVcAlgorithm     $04
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $05, $07, $00, $05
	smpsVcCoarseFreq    $04, $04, $07, $07
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1B, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $0D, $00, $0A, $06
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $00, $0F, $00
	smpsVcTotalLevel    $0F, $25, $18, $1A

;	Voice $04
;	$07
;	$06, $7C, $75, $0A, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$80, $80, $80, $80
	smpsVcAlgorithm     $07
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $07, $07, $00
	smpsVcCoarseFreq    $0A, $05, $0C, $06
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $00, $00, $00

;	Voice $05
;	$01
;	$05, $03, $05, $01, 	$0F, $0E, $CE, $10, 	$05, $02, $0B, $09
;	$08, $03, $00, $0A, 	$FF, $3F, $0F, $FF, 	$23, $1A, $21, $83
	smpsVcAlgorithm     $01
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $05, $03, $05
	smpsVcRateScale     $00, $03, $00, $00
	smpsVcAttackRate    $10, $0E, $0E, $0F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $09, $0B, $02, $05
	smpsVcDecayRate2    $0A, $00, $03, $08
	smpsVcDecayLevel    $0F, $00, $03, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $03, $21, $1A, $23

;	Voice $06
;	$3C
;	$01, $02, $01, $02, 	$CF, $0D, $CF, $0C, 	$00, $08, $00, $08
;	$00, $02, $00, $02, 	$02, $27, $02, $28, 	$1E, $80, $1F, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $01, $02, $01
	smpsVcRateScale     $00, $03, $00, $03
	smpsVcAttackRate    $0C, $0F, $0D, $0F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $00, $08, $00
	smpsVcDecayRate2    $02, $00, $02, $00
	smpsVcDecayLevel    $02, $00, $02, $00
	smpsVcReleaseRate   $08, $02, $07, $02
	smpsVcTotalLevel    $00, $1F, $00, $1E

