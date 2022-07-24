Title_screen_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Title_screen_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $CD

	smpsHeaderDAC       Title_screen_DAC
	smpsHeaderFM        Title_screen_FM1,	$F4, $0C
	smpsHeaderFM        Title_screen_FM2,	$F4, $0C
	smpsHeaderFM        Title_screen_FM3,	$F4, $0B
	smpsHeaderFM        Title_screen_FM4,	$F4, $0B
	smpsHeaderFM        Title_screen_FM5,	$F4, $0E
	smpsHeaderPSG       Title_screen_PSG1,	$00, $00, $00, fTone_03
	smpsHeaderPSG       Title_screen_PSG2,	$00, $02, $00, fTone_03
	smpsHeaderPSG       Title_screen_PSG3,	$00, $03, $00, fTone_04

; FM5 Data
Title_screen_FM5:
	smpsAlterNote       $03

; FM1 Data
Title_screen_FM1:
	smpsSetvoice        $00
	dc.b	nRst, $3C, nCs6, $15, nRst, $03, nCs6, $06, nRst, nD6, $0F, nRst
	dc.b	$03, nB5, $18, nRst, $06, nCs6, nRst, nCs6, nRst, nCs6, nRst, nA5
	dc.b	nRst, nG5, $0F, nRst, $03, nB5, $0C, nRst, $12, nA5, $06, nRst
	dc.b	nCs6, nRst, nA6, nRst, nE6, $0C, nRst, $06, nAb6, $12, nA6, $06
	dc.b	nRst, $72
	smpsStop

; FM2 Data
Title_screen_FM2:
	smpsSetvoice        $03
	smpsNop             $01
	dc.b	nRst, $30, nA3, $06, nRst, nA3, nRst, nE3, nRst, nE3, nRst, nG3
	dc.b	$12, nB3, nD4, $0C, nA3, $06, nRst, nA3, nRst, nE3, nRst, nE3
	dc.b	nRst, nD4, $12, nCs4, nB3, $0C, nRst, nA3, nRst, nA3, nRst, $06
	dc.b	nAb3, $12, nA3, $06, nRst
	smpsSetvoice        $01
	smpsAlterVol        $02
	dc.b	nA2, $6C
	smpsNop             $01
	smpsStop

; FM3 Data
Title_screen_FM3:
	smpsSetvoice        $02
	dc.b	nRst, $30, nE6, $06, nRst, nE6, nRst, nCs6, nRst, nCs6, nRst, nD6
	dc.b	$0F, nRst, $03, nD6, $18, nRst, $06, nE6, nRst, nE6, nRst, nCs6
	dc.b	nRst, nCs6, nRst, nG6, $0F, nRst, $03, nG6, $18, nRst, $06, nE6
	dc.b	$0C, nRst, nE6, nRst, nRst, $06, nEb6, $12, nE6, $0C
	smpsAlterVol        $FC
	smpsSetvoice        $01
	smpsAlterNote       $03
	dc.b	nA2, $6C
	smpsStop

; FM4 Data
Title_screen_FM4:
	smpsSetvoice        $02
	dc.b	nRst, $30, nCs6, $06, nRst, nCs6, nRst, nA5, nRst, nA5, nRst, nB5
	dc.b	$0F, nRst, $03, nB5, $18, nRst, $06, nCs6, nRst, nCs6, nRst, nA5
	dc.b	nRst, nA5, nRst, nD6, $0F, nRst, $03, nD6, $18, nRst, $06, nCs6
	dc.b	$0C, nRst, nCs6, nRst, nRst, $06, nC6, $12, nCs6, $0C
	smpsAlterVol        $FD
	smpsSetvoice        $01
	smpsModSet          $00, $01, $06, $04
	dc.b	nA2, $6C
	smpsStop

; PSG3 Data
Title_screen_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $30

Title_screen_Loop02:
	smpsNoteFill        $03
	dc.b	nMaxPSG, $0C
	smpsNoteFill        $0C
	dc.b	$0C
	smpsNoteFill        $03
	dc.b	$0C
	smpsNoteFill        $0C
	dc.b	$0C
	smpsLoop            $00, $05, Title_screen_Loop02
	smpsNoteFill        $03
	dc.b	$06
	smpsNoteFill        $0E
	dc.b	$12
	smpsNoteFill        $03
	dc.b	$0C
	smpsNoteFill        $0F
	dc.b	$0C
	smpsStop

; DAC Data
Title_screen_DAC:
	dc.b	dKick, $0C, dSnare, dSnare, dSnare, $08, dSnare, $04, dKick, $0C, dSnare, dKick
	dc.b	dSnare, dKick, dSnare, dKick, dSnare, dKick, dSnare, dKick, dSnare, dKick, dSnare, dKick
	dc.b	$06, nRst, $02, dSnare, dSnare, dSnare, $09, dSnare, $03, dKick, $0C, dSnare
	dc.b	dSnare, $04, dSnare, dSnare, dSnare, nRst, nRst, dSnare, $06, dSnare, $12, dSnare
	dc.b	$0C, dKick
	smpsStop

; PSG2 Data
Title_screen_PSG2:
	dc.b	nRst, $03

; PSG1 Data
Title_screen_PSG1:
	dc.b	nRst, $30
	smpsLoop            $00, $06, Title_screen_PSG1
	dc.b	nRst, $20

Title_screen_Loop00:
	dc.b	nD5, $03, nE5, nFs5
	smpsPSGAlterVol     $01
	smpsAlterPitch      $FF
	smpsLoop            $00, $05, Title_screen_Loop00

Title_screen_Loop01:
	dc.b	nD5, $03, nE5, nFs5
	smpsPSGAlterVol     $01
	smpsAlterPitch      $01
	smpsLoop            $00, $07, Title_screen_Loop01
	smpsStop

Title_screen_Voices:
;	Voice $00
;	$3A
;	$51, $08, $51, $02, 	$1E, $1E, $1E, $10, 	$1F, $1F, $1F, $0F
;	$00, $00, $00, $02, 	$0F, $0F, $0F, $1F, 	$18, $24, $22, $81
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $05, $00, $05
	smpsVcCoarseFreq    $02, $01, $08, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $10, $1E, $1E, $1E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0F, $1F, $1F, $1F
	smpsVcDecayRate2    $02, $00, $00, $00
	smpsVcDecayLevel    $01, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $01, $22, $24, $18

;	Voice $01
;	$20
;	$36, $35, $30, $31, 	$DF, $DF, $9F, $9F, 	$07, $06, $09, $06
;	$07, $06, $06, $08, 	$2F, $1F, $1F, $FF, 	$19, $37, $13, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $01, $00, $05, $06
	smpsVcRateScale     $02, $02, $03, $03
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $06, $09, $06, $07
	smpsVcDecayRate2    $08, $06, $06, $07
	smpsVcDecayLevel    $0F, $01, $01, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $13, $37, $19

;	Voice $02
;	$3A
;	$01, $07, $01, $01, 	$7D, $7D, $7D, $33, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$1F, $FF, $1F, $1F, 	$18, $20, $2F, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $00, $01, $01, $01
	smpsVcAttackRate    $33, $3D, $3D, $3D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $2F, $20, $18

;	Voice $03
;	$39
;	$06, $60, $30, $01, 	$3F, $3F, $5F, $5F, 	$11, $0F, $13, $09
;	$05, $04, $04, $03, 	$2F, $2F, $2F, $2F, 	$27, $2C, $97, $80
	smpsVcAlgorithm     $01
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $03, $06, $00
	smpsVcCoarseFreq    $01, $00, $00, $06
	smpsVcRateScale     $01, $01, $00, $00
	smpsVcAttackRate    $1F, $1F, $3F, $3F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $09, $13, $0F, $11
	smpsVcDecayRate2    $03, $04, $04, $05
	smpsVcDecayLevel    $02, $02, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $97, $2C, $27

