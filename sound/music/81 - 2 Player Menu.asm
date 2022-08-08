Results_screen_2p_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Results_screen_2p_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $68

	smpsHeaderDAC       Results_screen_2p_DAC
	smpsHeaderFM        Results_screen_2p_FM1,	$F4, $10
	smpsHeaderFM        Results_screen_2p_FM2,	$F4, $0C
	smpsHeaderFM        Results_screen_2p_FM3,	$F4, $19
	smpsHeaderFM        Results_screen_2p_FM4,	$F4, $10
	smpsHeaderFM        Results_screen_2p_FM5,	$F4, $11
	smpsHeaderPSG       Results_screen_2p_PSG1,	$D0, $01, $00, $00
	smpsHeaderPSG       Results_screen_2p_PSG2,	$D0, $01, $00, $00
	smpsHeaderPSG       Results_screen_2p_PSG3,	$D0, $01, $00, $00

; FM1 Data
Results_screen_2p_FM1:
	smpsSetvoice        $04
	smpsModSet          $02, $01, $01, $01
	smpsPan             panRight, $00
	smpsAlterVol        $03
	dc.b	nRst, $02
	smpsCall            Results_screen_2p_Call03
	dc.b	nD6, $16
	smpsAlterVol        $FD
	smpsSetvoice        $05
	smpsPan             panRight, $00
	smpsAlterVol        $FB
	smpsCall            Results_screen_2p_Call01
	smpsCall            Results_screen_2p_Call01
	smpsAlterVol        $05
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	smpsCall            Results_screen_2p_Call05
	dc.b	nRst, $18, nD5, $03, nB4, nRst, nD5, nRst, $0C, nRst, $18, nCs5
	dc.b	$03, nCs5, nRst, nCs5, nA4, $06, nCs5
	smpsCall            Results_screen_2p_Call05
	dc.b	nRst, $0C, nB4, nRst, nCs5, nRst, nD5, nRst, nE5, nRst, $18, nD6
	dc.b	$0C, nCs6
	smpsJump            Results_screen_2p_FM1

Results_screen_2p_Call03:
	smpsCall            Results_screen_2p_Call0C
	dc.b	nA6, $06, nB6, nA6, $18
	smpsCall            Results_screen_2p_Call0C
	dc.b	nFs6, $06, nE6
	smpsReturn

Results_screen_2p_Call0C:
	dc.b	nB6, $0C, nCs7, $06, nD7, nA6, $0C, nFs6, $06, nD6, nG6, $0C
	smpsReturn

Results_screen_2p_Call01:
	smpsCall            Results_screen_2p_Call0B
	dc.b	nE6, nRst, nE6, nRst, nFs6, nFs6, nRst, nD6, nRst, $18
	smpsCall            Results_screen_2p_Call0B
	dc.b	nRst, $03, nG6, nRst, nFs6, nE6, nRst, nD6, nD6, nRst, $18
	smpsReturn

Results_screen_2p_Call0B:
	dc.b	nE6, $03, nRst, nE6, nRst, nFs6, nFs6, nRst, nD6, nRst, nD6, nRst
	dc.b	nA5, nB5, $06, nD6, $03, nRst
	smpsReturn

Results_screen_2p_Call05:
	dc.b	nRst, $18, nD5, $03, nB4, nRst, nD5, nRst, $0C, nRst, $18, nCs5
	dc.b	$03, nA4, nRst, nCs5, nRst, $0C
	smpsReturn

; FM2 Data
Results_screen_2p_FM2:
	smpsSetvoice        $00

Results_screen_2p_Loop01:
	dc.b	nD3, $06, nD4, $03, $03, nD3, $06, nD4
	smpsLoop            $00, $18, Results_screen_2p_Loop01
	smpsCall            Results_screen_2p_Call04

Results_screen_2p_Loop02:
	dc.b	nE3, nE4, $03, $03, nE3, $06, nE4
	smpsLoop            $00, $02, Results_screen_2p_Loop02

Results_screen_2p_Loop03:
	dc.b	nFs3, nFs4, $03, $03, nFs3, $06, nFs4
	smpsLoop            $00, $02, Results_screen_2p_Loop03
	smpsCall            Results_screen_2p_Call04
	dc.b	nE3, nE4, $03, $03, nE3, $06, nE4, nFs3, nFs4, $03, $03, nFs3
	dc.b	$06, nFs4, nG3, nG4, $03, $03, nG3, $06, nG4, nA3, nA4, $03
	dc.b	$03, nA3, $06, nA4, nA3, nA4, nA3, nA4, nA3, $0C, $0C
	smpsJump            Results_screen_2p_Loop01

Results_screen_2p_Call04:
	dc.b	nG3, nG4, $03, $03, nG3, $06, nG4
	smpsLoop            $01, $02, Results_screen_2p_Call04

Results_screen_2p_Loop04:
	dc.b	nFs3, nFs4, $03, $03, nFs3, $06, nFs4
	smpsLoop            $01, $02, Results_screen_2p_Loop04
	smpsReturn

; FM3 Data
Results_screen_2p_FM3:
	smpsSetvoice        $02
	smpsCall            Results_screen_2p_Call00
	smpsAlterVol        $F9
	dc.b	nRst, $1E, nA4, $03, nB4, nD5, nRst, $09, nRst, $1E, nE5, $03
	dc.b	nFs5, nD5, nRst, $09, nRst, $1E, nA4, $03, nB4, nD5, nRst, $09
	dc.b	nRst, $18, nFs5, $03, nFs5, nRst, nFs5, nE5, $06, nD5, nRst, $1E
	dc.b	nA4, $03, nB4, nD5, nRst, $09, nRst, $1E, nFs5, $06, nD5, $03
	dc.b	nRst, $09, nRst, $1E, nA4, $03, nB4, nD5, nRst, $09, nRst, $18
	dc.b	nG5, $03, nFs5, nG5, nAb5, nA5, nRst, nD6, nRst
	smpsAlterVol        $07
	smpsSetvoice        $01
	smpsAlterVol        $F2
	smpsPan             panRight, $00
	smpsCall            Results_screen_2p_Call02
	smpsPan             panCenter, $00
	smpsAlterVol        $0E
	smpsJump            Results_screen_2p_FM3

Results_screen_2p_Call02:
	dc.b	nD6, $1E, nB5, $03, nCs6, nD6, $06, nB5, $03, nRst, nCs6, $1B
	dc.b	nA5, $03, nRst, nB5, nCs6, $06, nA5, nB5, $1E, nA5, $03, nRst
	dc.b	nB5, $06, nA5, nCs6, $0C, nB5, $06, nA5, $12, nB5, $06, nCs6
	dc.b	nD6, $1E, nB5, $03, nCs6, nD6, nRst, nB5, $06, nCs6, $1E, nA5
	dc.b	$03, nB5, nCs6, nRst, nA5, $06, nB5, $12, nA5, $03, nB5, nCs6
	dc.b	$12, nB5, $03, nCs6, nD6, $12, nCs6, $03, nD6, nE6, $30, nFs6
	dc.b	$0C, nE6
	smpsReturn

Results_screen_2p_Call00:
	dc.b	nRst, $1E, nA4, $03, nB4, nD5, nRst, $09, nRst, $1E, nE5, $03
	dc.b	nFs5, nD5, nRst, $09, nRst, $1E, nA4, $03, nB4, nD5, nRst, $09
	dc.b	nRst, $18, nG5, $03, nFs5, nG5, nAb5, nA5, nD5, nRst, nD5, $03
	smpsReturn

; FM5 Data
Results_screen_2p_FM5:
	smpsSetvoice        $03
	smpsModSet          $02, $01, $01, $01

Results_screen_2p_Jump00:
	smpsPan             panLeft, $00
	smpsAlterVol        $02
	smpsCall            Results_screen_2p_Call03
	dc.b	nD6, $18
	smpsPan             panCenter, $00
	smpsAlterVol        $FE
	dc.b	nRst, $30, nRst, nRst, nRst, $2A
	smpsAlterVol        $03
	dc.b	nB5, $03, nCs6, nD6, $18, nCs6, nB5, nA5, nG5, nFs5, nRst, $03
	dc.b	nB5, $03, nRst, nA5, nG5, nRst, nFs5, nFs5, nRst, $18
	smpsAlterVol        $FD
	smpsAlterVol        $03

Results_screen_2p_Loop00:
	dc.b	nA6, $03, nG6, nFs6, nE6
	smpsLoop            $00, $18, Results_screen_2p_Loop00
	smpsAlterVol        $FD
	dc.b	nRst, $0C, nD6, nRst, nE6, nRst, nFs6, nRst, nG6, $18, nRst, $24
	smpsJump            Results_screen_2p_Jump00

; FM4 Data
Results_screen_2p_FM4:
	smpsSetvoice        $01
	smpsAlterVol        $FE
	smpsAlterNote       $02
	smpsCall            Results_screen_2p_Call00
	smpsAlterVol        $02
	smpsSetvoice        $01
	smpsPan             panLeft, $00
	smpsAlterVol        $FB
	smpsCall            Results_screen_2p_Call01
	smpsCall            Results_screen_2p_Call01
	smpsAlterVol        $05
	smpsAlterPitch      $F4
	smpsAlterVol        $FB
	smpsCall            Results_screen_2p_Call02
	smpsAlterPitch      $0C
	smpsAlterVol        $05
	smpsPan             panCenter, $00
	smpsJump            Results_screen_2p_FM4

; PSG1 Data
Results_screen_2p_PSG1:
	smpsPSGvoice        fTone_04
	smpsNoteFill        $0A

Results_screen_2p_Jump03:
	smpsCall            Results_screen_2p_Call09
	smpsPSGAlterVol     $01
	smpsCall            Results_screen_2p_Call09
	smpsCall            Results_screen_2p_Call09
	smpsCall            Results_screen_2p_Call0A
	dc.b	nRst, $03, nB5, $06, $03, $06, nG5, $09, nB5, $06, $03, $06
	dc.b	nG5, nRst, $03, nCs6, $06, $03, $06, nA5, $09, nCs6, $06, $09
	dc.b	nA5, $06
	smpsCall            Results_screen_2p_Call0A
	smpsCall            Results_screen_2p_Call08
	dc.b	nCs6, $03, nE6, $0C, $24
	smpsPSGAlterVol     $FF
	smpsJump            Results_screen_2p_Jump03

Results_screen_2p_Call08:
	dc.b	nB5, $03, nG5, nB5, nG5, nB5, nG5, nB5, nG5, nCs6, nA5, nCs6
	dc.b	nA5, nCs6, nA5, nCs6, nA5, nD6, nB5, nD6, nB5, nD6, nB5, nD6
	dc.b	nB5, nE6, nCs6, nE6, nCs6, nE6, nCs6, nE6
	smpsReturn

Results_screen_2p_Call09:
	dc.b	nB5, $09, $09, nA5, $1E, nG5, $09, $09, nA5, $1E, nB5, $09
	dc.b	$09, nA5, $1E, nG5, $09, nA5, nFs5, $1E
	smpsReturn

Results_screen_2p_Call0A:
	dc.b	nRst, $03, nD6, $06, $03, $06, nB5, $09, nD6, $06, $03, $06
	dc.b	nB5, nRst, $03, nCs6, $06, $03, $06, nA5, $09, nCs6, $06, $03
	dc.b	$06, nA5
	smpsReturn

; PSG2 Data
Results_screen_2p_PSG2:
	smpsPSGvoice        fTone_04
	smpsNoteFill        $0A

Results_screen_2p_Jump02:
	smpsCall            Results_screen_2p_Call06
	smpsPSGAlterVol     $01
	smpsCall            Results_screen_2p_Call06
	smpsCall            Results_screen_2p_Call06
	smpsCall            Results_screen_2p_Call07
	dc.b	nRst, $03, nG5, $06, $03, $06, nE5, $09, nG5, $06, $03, $06
	dc.b	nE5, nRst, $03, nA5, $06, $03, $06, nFs5, $09, nA5, $06, $09
	dc.b	nFs5, $06
	smpsCall            Results_screen_2p_Call07
	dc.b	nRst, $01
	smpsCall            Results_screen_2p_Call08
	dc.b	nCs6, $02, nCs6, $0C, $24
	smpsPSGAlterVol     $FF
	smpsJump            Results_screen_2p_Jump02

Results_screen_2p_Call06:
	dc.b	nG5, $09, $09, nFs5, $1E, nE5, $09, $09, nFs5, $1E, nG5, $09
	dc.b	$09, nFs5, $1E, nE5, $09, nFs5, nD5, $1E
	smpsReturn

Results_screen_2p_Call07:
	dc.b	nRst, $03, nB5, $06, $03, $06, nG5, $09, nB5, $06, $03, $06
	dc.b	nG5, nRst, $03, nA5, $06, $03, $06, nFs5, $09, nA5, $06, $03
	dc.b	nCs6, $06, nFs5
	smpsReturn

; PSG3 Data
Results_screen_2p_PSG3:
	smpsPSGvoice        fTone_02
	smpsNoteFill        $04

Results_screen_2p_Jump01:
	dc.b	nF6, $06, nD6, $03, $03, nF6, nRst, nD6, nRst
	smpsJump            Results_screen_2p_Jump01

; DAC Data
Results_screen_2p_DAC:
	dc.b	dKick, $06, nRst, $03, dKick, dKick, $06, dMidTom, dKick, $06, nRst, $03
	dc.b	dKick, dKick, $06, dMidTom, dKick, $06, nRst, $03, dKick, dKick, $06, dMidTom
	dc.b	dKick, $03, $06, $03, $06, dMidTom, $06
	smpsLoop            $00, $0A, Results_screen_2p_DAC
	dc.b	dKick, $06, dMidTom, $06, $06, $06, $0C, $0C
	smpsJump            Results_screen_2p_DAC

Results_screen_2p_Voices:
;	Voice $00
;	$08
;	$09, $70, $30, $00, 	$1F, $1F, $5F, $5F, 	$12, $0E, $0A, $0A
;	$00, $04, $04, $03, 	$2F, $2F, $2F, $2F, 	$25, $30, $13, $80
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
	smpsVcTotalLevel    $00, $13, $30, $25

;	Voice $01
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

;	Voice $02
;	$3A
;	$03, $08, $03, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$1F, $FF, $1F, $0F, 	$17, $28, $20, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $03, $08, $03
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $20, $28, $17

;	Voice $03
;	$3D
;	$61, $34, $03, $72, 	$0E, $0C, $8D, $0D, 	$08, $05, $05, $05
;	$00, $00, $00, $00, 	$1F, $2F, $2F, $2F, 	$19, $99, $9E, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $00, $03, $06
	smpsVcCoarseFreq    $02, $03, $04, $01
	smpsVcRateScale     $00, $02, $00, $00
	smpsVcAttackRate    $0D, $0D, $0C, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $05, $05, $08
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $02, $02, $02, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $1E, $19, $19

;	Voice $04
;	$3C
;	$31, $02, $72, $03, 	$0F, $4D, $0F, $0D, 	$00, $02, $00, $02
;	$00, $00, $00, $00, 	$0F, $3F, $0F, $3F, 	$19, $80, $29, $8A
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $07, $00, $03
	smpsVcCoarseFreq    $03, $02, $02, $01
	smpsVcRateScale     $00, $00, $01, $00
	smpsVcAttackRate    $0D, $0F, $0D, $0F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $02, $00, $02, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $03, $00, $03, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $0A, $29, $00, $19

;	Voice $05
;	$3A
;	$51, $05, $51, $02, 	$1E, $1E, $1E, $10, 	$1F, $1F, $1F, $0F
;	$00, $00, $00, $02, 	$0F, $0F, $0F, $1F, 	$18, $24, $22, $81
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $05, $00, $05
	smpsVcCoarseFreq    $02, $01, $05, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $10, $1E, $1E, $1E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0F, $1F, $1F, $1F
	smpsVcDecayRate2    $02, $00, $00, $00
	smpsVcDecayLevel    $01, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $01, $22, $24, $18

