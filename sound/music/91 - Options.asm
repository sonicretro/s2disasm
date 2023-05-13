Options_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     Options_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $87

	smpsHeaderDAC       Options_DAC
	smpsHeaderFM        Options_FM1,	$F4, $05
	smpsHeaderFM        Options_FM2,	$00, $07
	smpsHeaderFM        Options_FM3,	$E8, $0E
	smpsHeaderFM        Options_FM4,	$00, $13
	smpsHeaderFM        Options_FM5,	$00, $07
	smpsHeaderPSG       Options_PSG1,	$E8, $06, $00, fTone_03
	smpsHeaderPSG       Options_PSG2,	$DC, $05, $00, fTone_07
	smpsHeaderPSG       Options_PSG3,	$DC, $06, $00, fTone_07

; FM4 Data
Options_FM4:
	smpsSetvoice        $03
	smpsPan             panRight, $00
	smpsNoteFill        $05

Options_Loop00:
	dc.b	nC5, $06, nB4, nA4, nG4
	smpsLoop            $00, $04, Options_Loop00
	dc.b	nC5, nBb4, nAb4, nG4, nC5, nBb4, nAb4, nG4, nD5, nC5, nBb4, nAb4
	dc.b	nD5, nC5, nBb4, nAb4
	smpsJump            Options_Loop00

; FM3 Data
Options_FM3:
	smpsSetvoice        $04

Options_Jump01:
	dc.b	nRst, $0C, nC4, $06, nE4, nG4, $0C, nC4, $06, nE4, nG4, $18
	dc.b	smpsNoAttack, $18, nRst, $0C, nAb3, $06, nC4, nEb4, $18, nRst, $0C, nBb3
	dc.b	$06, nD4, nF4, $18
	smpsJump            Options_Jump01

; FM5 Data
Options_FM5:
	smpsSetvoice        $01
	smpsPan             panRight, $00
	smpsModSet          $02, $01, $02, $04
	dc.b	nRst, $02
	smpsJump            Options_Jump00

; FM2 Data
Options_FM2:
	smpsSetvoice        $01
	smpsPan             panLeft, $00
	smpsModSet          $12, $01, $02, $04

Options_Jump00:
	dc.b	nRst, $0C, nC5, $03, nRst, nC5, nRst, nC5, $0C, nD5, $03, nRst
	dc.b	nF5, $0C, nRst, $06, nE5, nRst, nD5, nRst, nC5, nRst, nEb5, $0C
	dc.b	nF5, $06, nC5, $06, smpsNoAttack, $18, smpsNoAttack, $18, smpsNoAttack, $18
	smpsJump            Options_Jump00

; FM1 Data
Options_FM1:
	smpsSetvoice        $02
	dc.b	nC3, $06, nRst, $12, nC3, $06, nRst, $12, nC3, $06, nRst, $12
	dc.b	nC3, $06, nRst, nG2, $0C, nAb2, $06, nRst, $12, nAb2, $06, nRst
	dc.b	nF2, $0C, nBb2, $06, nRst, $12, nBb2, $06, nRst, nG2, $0C
	smpsJump            Options_FM1

; PSG2 Data
Options_PSG2:
	dc.b	nRst, $02
	smpsJump            Options_Jump00

; PSG3 Data
Options_PSG3:
	smpsAlterNote       $01
	dc.b	nRst, $03
	smpsJump            Options_Jump00

; PSG1 Data
Options_PSG1:
	smpsAlterNote       $01
	smpsJump            Options_Jump01

; DAC Data
Options_DAC:
	dc.b	dSnare, $0C, $04, $04, $04, $0C, $04, $04, $04, $0C, $04, $04
	dc.b	$04, dMidTom, $06, dFloorTom, dMidTom, dFloorTom
	smpsJump            Options_DAC

Options_Voices:
;	Voice $00
;	$35
;	$3F, $31, $58, $51, 	$1F, $9E, $1F, $9E, 	$0F, $11, $0E, $12
;	$0E, $05, $08, $08, 	$5F, $0F, $6F, $0F, 	$25, $2D, $2F, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $05, $05, $03, $03
	smpsVcCoarseFreq    $01, $08, $01, $0F
	smpsVcRateScale     $02, $00, $02, $00
	smpsVcAttackRate    $1E, $1F, $1E, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $12, $0E, $11, $0F
	smpsVcDecayRate2    $08, $08, $05, $0E
	smpsVcDecayLevel    $00, $06, $00, $05
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $2F, $2D, $25

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
;	$61, $3C, $13, $32, 	$98, $D8, $9D, $DA, 	$05, $09, $05, $06
;	$03, $01, $04, $04, 	$1F, $0F, $0F, $AF, 	$21, $47, $31, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $01, $03, $06
	smpsVcCoarseFreq    $02, $03, $0C, $01
	smpsVcRateScale     $03, $02, $03, $02
	smpsVcAttackRate    $1A, $1D, $18, $18
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $06, $05, $09, $05
	smpsVcDecayRate2    $04, $04, $01, $03
	smpsVcDecayLevel    $0A, $00, $00, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $31, $47, $21

;	Voice $03
;	$3C
;	$01, $01, $00, $01, 	$CF, $0E, $CF, $0E, 	$00, $02, $00, $02
;	$00, $00, $00, $00, 	$02, $37, $02, $38, 	$1E, $80, $1F, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $00, $01, $01
	smpsVcRateScale     $00, $03, $00, $03
	smpsVcAttackRate    $0E, $0F, $0E, $0F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $02, $00, $02, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $03, $00, $03, $00
	smpsVcReleaseRate   $08, $02, $07, $02
	smpsVcTotalLevel    $80, $1F, $80, $1E

;	Voice $04
;	$3A
;	$14, $03, $05, $14, 	$8C, $58, $4E, $4E, 	$0A, $0D, $06, $06
;	$00, $00, $00, $01, 	$1F, $FF, $0F, $5F, 	$1F, $2E, $3B, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $01, $00, $00, $01
	smpsVcCoarseFreq    $04, $05, $03, $04
	smpsVcRateScale     $01, $01, $01, $02
	smpsVcAttackRate    $0E, $0E, $18, $0C
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $06, $06, $0D, $0A
	smpsVcDecayRate2    $01, $00, $00, $00
	smpsVcDecayLevel    $05, $00, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $3B, $2E, $1F

