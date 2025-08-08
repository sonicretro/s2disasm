Ending_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     Ending_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $97

	smpsHeaderDAC       Ending_DAC
	smpsHeaderFM        Ending_FM1,	$E8, $10
	smpsHeaderFM        Ending_FM2,	$F4, $09
	smpsHeaderFM        Ending_FM3,	$F4, $08
	smpsHeaderFM        Ending_FM4,	$F4, $0B
	smpsHeaderFM        Ending_FM5,	$F4, $0B
	smpsHeaderPSG       Ending_PSG1,	$D0, $06, $02, fTone_0C
	smpsHeaderPSG       Ending_PSG2,	$D0, $05, $00, fTone_05
	smpsHeaderPSG       Ending_PSG3,	$DC, $05, $02, fTone_0C

; FM1 Data
Ending_FM1:
	smpsSetvoice        $03
	smpsModSet          $02, $01, $04, $02
	smpsCall            Ending_Call04
	smpsAlterVol        $FC
	smpsCall            Ending_Call05
	smpsAlterVol        $04
	smpsCall            Ending_Call06
	smpsAlterVol        $10
	dc.b	nG5, $03
	smpsAlterVol        $FF
	dc.b	nA5
	smpsAlterVol        $FF
	dc.b	nB5
	smpsAlterVol        $FF
	dc.b	nC6
	smpsAlterVol        $FF
	dc.b	nB5
	smpsAlterVol        $FE
	dc.b	nC6
	smpsAlterVol        $FE
	dc.b	nD6
	smpsAlterVol        $FE
	dc.b	nE6
	smpsAlterVol        $FE
	dc.b	nD6
	smpsAlterVol        $FE
	dc.b	nE6
	smpsAlterVol        $FE
	dc.b	nF6
	smpsAlterVol        $FE
	dc.b	nG6
	smpsAlterVol        $FE
	dc.b	nF6
	smpsAlterVol        $FE
	dc.b	nG6
	smpsAlterVol        $FE
	dc.b	nA6
	smpsAlterVol        $FE
	dc.b	nB6
	smpsAlterVol        $09
	smpsCall            Ending_Call07
	dc.b	nBb6, $30
	smpsStop

Ending_Call05:
	dc.b	nE6, $12, nC6, $06, nF6, $12, nC6, $1E, nRst, $18, nE6, $12
	dc.b	nC6, $06, nF6, $12, nC6, $1E
	smpsReturn

Ending_Call04:
	dc.b	nC4, $1E, nG4, $06, nE4, nD4, nC4, $30, nAb3, $18, nBb3, $0C
	dc.b	nD4, nE4, $30, nEb4, $18, nF4, $0C, nD4, nE4, $12, nA3, $1E
	dc.b	nD4, $12, nG4, $1E, nA4, $12, nG4, $1E, nRst, $0C, nB4, nG4
	dc.b	$06, nD4, nG4, nAb4, nA4, $18
	smpsReturn

Ending_Call06:
	dc.b	nRst, $18, nF6, $0C, $06, nE6, nF6, nE6, $0C, nD6, nE6, $06
	dc.b	nF6, $0C, nE6, $30
	smpsReturn

Ending_Call07:
	dc.b	nG6, $18, nBb6, $0C, nEb6, nAb6, $15, nRst, $03, nC7, $06, nBb6
	dc.b	nG6, $03, nAb6, $09, nG6, $18, nBb6, $0C, nEb6, nAb6, $15, nC7
	dc.b	$03, $06, nBb6, nG6, $03, nAb6, $09, nC7, $15, $03, nB6, $06
	dc.b	$06, $03, $06, nBb6, $1B, nA6, $06, $06, $03, $09, nC7, $06
	dc.b	nBb6, nG6, nAb6, $18, nG6, $03, $03, nC7, $06, nBb6, nG6, nAb6
	dc.b	$12, nBb6, $0C, nCs7, $03, nC7, nBb6, nAb6, nCs7, nC7, nBb6, nAb6
	dc.b	nCs7, nC7, nBb6, nAb6, nCs7, nC7, nBb6, nAb6
	smpsReturn

; FM2 Data
Ending_FM2:
	smpsSetvoice        $01
	smpsModSet          $01, $01, $02, $02
	dc.b	nRst, $06, nE5, $03, nF5, nE5, $24
	smpsCall            Ending_Call01
	smpsAlterVol        $02
	dc.b	nRst, $30

Ending_Loop0F:
	dc.b	nRst, $18, nG5, $02, nRst, $01, nC5, $02, nRst, $01, nE5, $02
	dc.b	nRst, $01, nC5, $02, nRst, $01, nG5, $02, nRst, $01, nC5, $02
	dc.b	nRst, $01, nE5, $02, nRst, $01, nC5, $02, nRst, $01, nRst, $18
	dc.b	nA5, $02, nRst, $01, nD5, $02, nRst, $01, nF5, $02, nRst, $01
	dc.b	nD5, $02, nRst, $01, nA5, $02, nRst, $01, nD5, $02, nRst, $01
	dc.b	nF5, $02, nRst, $01, nD5, $02, nRst, $01
	smpsLoop            $00, $02, Ending_Loop0F
	smpsAlterVol        $FE
	smpsCall            Ending_Call02
	dc.b	nRst, $06
	smpsAlterVol        $0A

Ending_Loop10:
	dc.b	nC6, $06
	smpsAlterVol        $FE
	smpsLoop            $00, $07, Ending_Loop10
	smpsAlterVol        $03
	smpsCall            Ending_Call03
	dc.b	nEb6, $30, smpsNoAttack, $30
	smpsStop

Ending_Call01:
	dc.b	nRst, $06, nC6, $02, nRst, $01, nC6, $02, nRst, $01, nC6, $06
	dc.b	nD6, $03, nF6, $09, nE6, $06, nD6, nC6, nEb6, nF6, $03, nC6
	dc.b	$24, nRst, $03
	smpsLoop            $01, $02, Ending_Call01
	dc.b	nRst, $18, nE6, $06, nC6, nE6, $03, nC6, $06, nD6, $1B, nE6
	dc.b	$06, nC6, nE6, $03, nC6, $06, nD6, $33
	smpsReturn

Ending_Call03:
	dc.b	nRst, $06, nEb6, $03, nD6, $09, nEb6, $03, nBb5, $09, nEb6, $03
	dc.b	nD6, $09, nEb6, $03, nC6, $15, nRst, $03, nAb6, $03, $06, nG6
	dc.b	nEb6, $03, nF6, $09
	smpsLoop            $01, $02, Ending_Call03
	dc.b	nG6, $15, $03, nF6, $06, nG6, nEb6, $03, nF6, $06, nG6, $1B
	dc.b	nF6, $06, nG6, nEb6, $03, $06, $03, nAb6, $06, nG6, nEb6, nF6
	dc.b	$18, nEb6, $03, $03, nAb6, $06, nG6, nEb6, nF6, $12, nEb6, $0C
	smpsReturn

Ending_Call02:
	dc.b	nRst, $06, nF6, $03, nG6, nA6, nRst, nF6, $03, nG6, nA6, $18
	dc.b	nRst, $06, nG6, $03, nA6, nB6, nRst, nG6, $03, nA6, nB6, $18
	dc.b	nRst, $06, nA6, $03, nB6, nC7, nRst, nA6, $03, nB6, nC7, $18
	smpsReturn

; FM3 Data
Ending_FM3:
	smpsSetvoice        $00
	dc.b	nRst, $24, nG3, $0C

Ending_Loop0C:
	dc.b	nC4, $15, nG3, $03, nC4, $06, $0C, $03, nG3, nAb3, $15, nEb3
	dc.b	$03, nBb3, $06, $0C, $03, nB3
	smpsLoop            $00, $02, Ending_Loop0C
	dc.b	nA3, $15, nE3, $03, nA3, $06, $06, $03, nB3, nC4, nCs4, nD4
	dc.b	$15, nA3, $03, nD4, $06, $0C, $06, nG3, $15, nD3, $03, nG3
	dc.b	$06, $0C, nD4, $06, nG3, $15, nD3, $03, nG3, nD3, nG3, $0C
	dc.b	$03, nAb3, nA3, $15, nE3, $03, nA3, $06, $0C, $03, nE3, nBb3
	dc.b	$15, nF3, $03, nBb3, $06, $0C, $03, nF3, nA3, $15, nE3, $03
	dc.b	nA3, $06, nA3, nA3, $03, nE3, nA3, nE3, nBb3, $15, nF3, $03
	dc.b	nBb3, $06, $0C, $03, $03, nF3, $15, $03, $06, $0C, $03, nFs3
	dc.b	nG3, $15, nD3, $03, nG3, $06, $0C, $03, nAb3, nA3, $15, nE3
	dc.b	$03, nA3, $06, $0C, $03, $03, nRst, $06
	smpsAlterVol        $0A

Ending_Loop0D:
	dc.b	nG3
	smpsAlterVol        $FE
	smpsLoop            $00, $07, Ending_Loop0D
	smpsAlterVol        $03

Ending_Loop0E:
	dc.b	nEb4, $15, $03, nD4, $06, $0C, $03, nBb3, nAb3, $15, $03, nBb3
	dc.b	$06, $0C, nF4, $03, nBb3
	smpsLoop            $00, $02, Ending_Loop0E
	dc.b	nC4, $15, $03, nB3, $06, $12, nBb3, $15, $03, nA3, $06, $12
	dc.b	nAb3, nBb3, $18, nF4, $06, nAb3, $12, nBb3, nBb3, $06, nC4, nCs4
	dc.b	$15, nAb3, $03, nCs4, $06, $12, nEb3, $30
	smpsStop

; FM4 Data
Ending_FM4:
	smpsSetvoice        $02
	smpsPan             panRight, $00
	dc.b	nRst, $12, nG5, $03, nA5, nG5, $18

Ending_Loop08:
	dc.b	nG5, $30, nEb5, $18, nF5, $0C, nA5
	smpsLoop            $00, $02, Ending_Loop08
	dc.b	nE5, $12, nG5, nE5, $0C, nE5, $12, nG5, nE5, $0C, nF5, $12
	dc.b	nA5, nF5, $0C, nC6, $12, nA5, nF5, $0C

Ending_Loop09:
	dc.b	nE5, $03, $03, nD5, $06, nE5, nD5, $03, nE5, $1B, nF5, $03
	dc.b	$03, nE5, $06, nF5, nE5, $03, nF5, $1B
	smpsLoop            $00, $02, Ending_Loop09
	dc.b	nC5, $12, nA4, nC5, $0C, nB4, $12, nD5, nB4, $0C, nC5, $12
	dc.b	nE5, nC5, $0C, nRst, $06
	smpsAlterVol        $0A

Ending_Loop0A:
	dc.b	nF5
	smpsAlterVol        $FE
	smpsLoop            $00, $07, Ending_Loop0A
	smpsAlterVol        $03

Ending_Loop0B:
	dc.b	nBb5, $12, nG5, $03, nBb5, $0F, nG5, $0C, nC6, $18, nAb5, $06
	dc.b	$06, $03, nC6, $09
	smpsLoop            $00, $02, Ending_Loop0B
	dc.b	nC6, $06, nC5, $03, nEb5, nG5, $06, nC5, $03, nEb5, nB5, $18
	dc.b	nBb5, $06, nC5, $03, nEb5, nG5, $06, nC5, $03, nEb5, nA5, $18
	dc.b	nEb5, $12, nF5, $18, nG5, $03, nF5, nEb5, $12, nF5, nF5, $0C
	dc.b	nC5, $06, nEb5, $03, nC5, $06, nEb5, $03, nC6, $06, nG5, $03
	dc.b	$03, nEb5, nC5, $09, nG5, $03, nAb5, nG5, $30
	smpsStop

; FM5 Data
Ending_FM5:
	smpsSetvoice        $02
	smpsPan             panLeft, $00
	dc.b	nRst, $01, nRst, $12, nG5, $03, nA5, nG5, $17

Ending_Loop04:
	dc.b	nE5, $30, nC5, $18, nD5, $0C, nF5
	smpsLoop            $00, $02, Ending_Loop04
	dc.b	nC5, $12, nE5, nC5, $0C, nC5, $12, nE5, nC5, $0C, nD5, $12
	dc.b	nF5, nD5, $0C, nA5, $12, nF5, nD5, $0C

Ending_Loop05:
	dc.b	nC5, $03, $03, nB4, $06, nC5, nB4, $03, nC5, $1B, nD5, $03
	dc.b	$03, nC5, $06, nD5, nC5, $03, nD5, $1B
	smpsLoop            $00, $02, Ending_Loop05
	dc.b	nA4, $12, nF4, nA4, $0C, nG4, $12, nB4, nG4, $0C, nA4, $12
	dc.b	nC5, nA4, $0C, nRst, $06
	smpsAlterVol        $0A

Ending_Loop06:
	dc.b	nD5, $06
	smpsAlterVol        $FE
	smpsLoop            $00, $07, Ending_Loop06
	smpsAlterVol        $03

Ending_Loop07:
	dc.b	nG5, $12, nEb5, $03, nG5, $0F, nEb5, $0C, nAb5, $18, nF5, $06
	dc.b	$06, $03, nAb5, $09
	smpsLoop            $00, $02, Ending_Loop07
	dc.b	nRst, $01, nC6, $06, nC5, $03, nEb5, nG5, $06, nC5, $03, nEb5
	dc.b	$02, nG5, $18, nRst, $01, nBb5, $06, nC5, $03, nEb5, nG5, $06
	dc.b	nC5, $03, nEb5, $02, nG5, $18, nC5, $12, nD5, $18, nEb5, $03
	dc.b	nD5, nC5, $12, nD5, nD5, $0C, nAb4, $06, nC5, $03, nAb4, $06
	dc.b	nC5, $03, nG5, $06, nEb5, $03, $03, nC5, nAb4, $09, nEb5, $03
	dc.b	nF5, nEb5, $30
	smpsStop

; PSG1 Data
Ending_PSG1:
	smpsAlterNote       $01
	dc.b	nRst, $02

; PSG2 Data
Ending_PSG2:
	dc.b	nRst, $01, nRst, $06, nE5, $03, nF5, nE5, $24
	smpsCall            Ending_Call01
	dc.b	nRst, $30, nRst, $18
	smpsPSGAlterVol     $02
	smpsCall            Ending_Call05
	smpsPSGAlterVol     $FE
	dc.b	nRst, $06, nF6, $02, nRst, $01, nG6, $02, nRst, $01, nA6, $02
	dc.b	nRst, $01, nRst, $03, nF6, $02, nRst, $01, nG6, $02, nRst, $01
	dc.b	nA6, $14, nRst, $04, nRst, $06, nG6, $02, nRst, $01, nA6, $02
	dc.b	nRst, $01, nB6, $02, nRst, $01, nRst, $03, nG6, $02, nRst, $01
	dc.b	nA6, $02, nRst, $01, nB6, $14, nRst, $04, nRst, $06, nA6, $02
	dc.b	nRst, $01, nB6, $02, nRst, $01, nC7, $02, nRst, $01, nRst, $03
	dc.b	nA6, $02, nRst, $01, nB6, $02, nRst, $01, nC7, $14, nRst, $04
	smpsCall            Ending_Call08
	smpsCall            Ending_Call03
	dc.b	nEb6, $30, smpsNoAttack, $18, nRst, $18
	smpsStop

Ending_Call08:
	smpsPSGAlterVol     $07
	dc.b	nG5, $03, nA5
	smpsPSGAlterVol     $FF
	dc.b	nB5, $03, nC6
	smpsPSGAlterVol     $FF
	dc.b	nB5, $03, nC6
	smpsPSGAlterVol     $FF
	dc.b	nD6, $03, nE6
	smpsPSGAlterVol     $FF
	dc.b	nD6, $03, nE6
	smpsPSGAlterVol     $FF
	dc.b	nF6, $03, nG6
	smpsPSGAlterVol     $FF
	dc.b	nF6, $03, nG6
	smpsPSGAlterVol     $FF
	dc.b	nA6, $03, nB6
	smpsReturn

; PSG3 Data
Ending_PSG3:
	dc.b	nRst, $02
	smpsCall            Ending_Call04
	smpsAlterPitch      $F4
	smpsCall            Ending_Call05
	smpsCall            Ending_Call06
	smpsCall            Ending_Call08
	smpsCall            Ending_Call07
	dc.b	nBb6, $18, nRst, $18
	smpsStop

; DAC Data
Ending_DAC:
	smpsCall            Ending_Call00

Ending_Loop00:
	dc.b	dKick, $15, dKick, $03, $06, $06, dSnare, $0C
	smpsLoop            $00, $07, Ending_Loop00
	smpsCall            Ending_Call00

Ending_Loop01:
	dc.b	dKick, $0C, dSnare, $09, dKick, $03, $06, $06, dSnare, $0C
	smpsLoop            $00, $07, Ending_Loop01
	dc.b	dKick, $06, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare, $03, dSnare

Ending_Loop02:
	dc.b	dKick, $0C, dSnare, $09, dKick, $03, $06, $06, dSnare, $0C, dKick, $0C
	dc.b	dSnare, $09, dKick, $03, $06, $06, dSnare, $06, $03, $03
	smpsLoop            $00, $03, Ending_Loop02

Ending_Loop03:
	dc.b	dKick, $0C, dSnare, $06, dKick, $0C, dSnare, $06, $06, $03, $03
	smpsLoop            $00, $02, Ending_Loop03
	dc.b	dKick, $0C, dSnare, $09, dKick, $03, $06, $06, dSnare, $0C, dKick, $30
	smpsStop

Ending_Call00:
	dc.b	dKick, $15, dKick, $03, $06, $06, dSnare, dSnare, $03, $03
	smpsReturn

Ending_Voices:
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
	smpsVcTotalLevel    $80, $13, $30, $25

;	Voice $01
;	$3D
;	$01, $08, $01, $01, 	$90, $8D, $8F, $53, 	$0E, $0E, $0E, $05
;	$02, $03, $02, $04, 	$1F, $FF, $1F, $0F, 	$16, $28, $27, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $08, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0F, $0D, $10
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $0E, $0E, $0E
	smpsVcDecayRate2    $04, $02, $03, $02
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $27, $28, $16

;	Voice $02
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
	smpsVcTotalLevel    $80, $3B, $2E, $20

;	Voice $03
;	$23
;	$6E, $34, $26, $74, 	$0E, $0E, $0E, $0D, 	$08, $07, $05, $05
;	$02, $02, $03, $12, 	$1F, $2F, $2F, $2F, 	$29, $9F, $24, $82
	smpsVcAlgorithm     $03
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $02, $03, $06
	smpsVcCoarseFreq    $04, $06, $04, $0E
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0D, $0E, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $05, $07, $08
	smpsVcDecayRate2    $12, $03, $02, $02
	smpsVcDecayLevel    $02, $02, $02, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $82, $24, $9F, $29

