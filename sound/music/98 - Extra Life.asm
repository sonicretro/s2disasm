ExtraLife_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     ExtraLife_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $CD

	smpsHeaderDAC       ExtraLife_DAC
	smpsHeaderFM        ExtraLife_FM1,	$E8, $10
	smpsHeaderFM        ExtraLife_FM2,	$E8, $10
	smpsHeaderFM        ExtraLife_FM3,	$E8, $10
	smpsHeaderFM        ExtraLife_FM4,	$E8, $10
	smpsHeaderFM        ExtraLife_FM5,	$E8, $10
	smpsHeaderPSG       ExtraLife_PSG1,	$D0, $08, $00, fTone_05
	smpsHeaderPSG       ExtraLife_PSG2,	$DC, $08, $00, fTone_05
	smpsHeaderPSG       ExtraLife_PSG3,	$DC, $00, $00, fTone_04

; FM4 Data
ExtraLife_FM4:
	smpsAlterNote       $03
	smpsPan             panRight, $00
	smpsJump            ExtraLife_Jump01

; FM1 Data
ExtraLife_FM1:
	smpsPan             panLeft, $00

ExtraLife_Jump01:
	smpsSetvoice        $00
	smpsNoteFill        $06
	dc.b	nE7, $06, $03, $03, $06, $06
	smpsNoteFill        $00
	dc.b	nFs7, $09, nD7, nCs7, $06, nE7, $18
	smpsStop

; FM2 Data
ExtraLife_FM2:
	smpsSetvoice        $01
	smpsNoteFill        $06
	smpsNop             $01
	dc.b	nCs7, $06, $03, $03, $06, $06
	smpsNoteFill        $00
	dc.b	nD7, $09, nB6, nA6, $06, nCs7, $18
	smpsNop             $01
	smpsStop

; FM5 Data
ExtraLife_FM5:
	smpsAlterNote       $03
	smpsPan             panRight, $00
	smpsJump            ExtraLife_Jump00

; FM3 Data
ExtraLife_FM3:
	smpsPan             panLeft, $00

ExtraLife_Jump00:
	smpsSetvoice        $02
	dc.b	nA4, $0C, nRst, $06, nA4, nG4, nRst, $03, nG4, $06, nRst, $03
	dc.b	nG4, $06, nA4, $18
	smpsStop

; PSG1 Data
ExtraLife_PSG1:
	smpsNoteFill        $06
	dc.b	nCs7, $06, $03, $03, $06, $06
	smpsNoteFill        $00
	dc.b	nD7, $09, nB6, nA6, $06, nCs7, $18

; PSG2 Data
ExtraLife_PSG2:
; PSG3 Data
ExtraLife_PSG3:
	smpsStop

; DAC Data
ExtraLife_DAC:
	dc.b	dHiTimpani, $12, $06, dVLowTimpani, $09, $09, $06, dHiTimpani, $06, dLowTimpani, dHiTimpani, dLowTimpani
	dc.b	dHiTimpani, $0C
	smpsFade

ExtraLife_Voices:
;	Voice $00
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$1F, $FF, $1F, $0F, 	$18, $4E, $16, $80
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
	smpsVcTotalLevel    $00, $16, $4E, $18

;	Voice $01
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$1F, $FF, $1F, $0F, 	$18, $28, $27, $80
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
	smpsVcTotalLevel    $00, $27, $28, $18

;	Voice $02
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
	smpsVcTotalLevel    $00, $27, $28, $18

