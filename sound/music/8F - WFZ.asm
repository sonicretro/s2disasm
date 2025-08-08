WFZ_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     WFZ_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $88

	smpsHeaderDAC       WFZ_DAC
	smpsHeaderFM        WFZ_FM1,	$00, $08
	smpsHeaderFM        WFZ_FM2,	$00, $06
	smpsHeaderFM        WFZ_FM3,	$0C, $06
	smpsHeaderFM        WFZ_FM4,	$18, $08
	smpsHeaderFM        WFZ_FM5,	$00, $06
	smpsHeaderPSG       WFZ_PSG1,	$00, $00, $00, $00
	smpsHeaderPSG       WFZ_PSG2,	$00, $00, $00, $00
	smpsHeaderPSG       WFZ_PSG3,	$00, $00, $00, $00

; PSG1 Data
WFZ_PSG1:
; PSG2 Data
WFZ_PSG2:
; PSG3 Data
WFZ_PSG3:
	smpsStop

; FM5 Data
WFZ_FM5:
	smpsSetvoice        $00
	smpsAlterNote       $01
	dc.b	nRst, $12

WFZ_Jump05:
	smpsPan             panLeft, $00
	smpsAlterVol        $06

WFZ_Loop04:
	dc.b	nE5, $03, nE5, nCs5, nCs5, nA4, nA4, nCs5, nCs5, nA4, nA4, nE4
	dc.b	nE4
	smpsLoop            $00, $07, WFZ_Loop04
	dc.b	nE5, nE5, nCs5, nCs5, nA4, nA4
	smpsPan             panCenter, $00
	smpsAlterVol        $FA
	smpsAlterPitch      $F4
	dc.b	nCs4, $0C, nD4, $06, nE4, $12, nA4, $12, nAb4, $12, nFs4, $12
	dc.b	nE4, $12, nD4, $0C, nCs4, $06, nD4, $12, nD4, $0C, nE4, $06
	dc.b	nFs4, $12, nB4, nA4, nFs4, nFs4, $12, nAb4, $0C, nFs4, $06, nE4
	dc.b	$24
	smpsAlterPitch      $0C
	smpsPan             panLeft, $00
	smpsAlterVol        $06

WFZ_Loop05:
	dc.b	nBb4, $03, nA4
	smpsLoop            $00, $30, WFZ_Loop05
	smpsAlterPitch      $F4
	smpsAlterVol        $FA
	smpsPan             panCenter, $00
	dc.b	nB3, $12, nCs4, nD4, nE4, nFs4, nAb4, nA4, nB4, nCs4, nD4, nE4
	dc.b	nFs4, nAb4, nA4, nB4, nCs5, nD5, $48, nEb5, nFs5, $24, nE5, nA5
	dc.b	nAb5, $24
	smpsAlterPitch      $0C
	smpsJump            WFZ_Jump05

; FM1 Data
WFZ_FM1:
	smpsSetvoice        $00
	smpsAlterNote       $FF
	dc.b	nRst, $12

WFZ_Jump04:
	smpsPan             panRight, $00
	smpsAlterVol        $06

WFZ_Loop02:
	dc.b	nE5, $03, nE5, nCs5, nCs5, nA4, nA4, nCs5, nCs5, nA4, nA4, nE4
	dc.b	nE4
	smpsLoop            $00, $07, WFZ_Loop02
	dc.b	nE5, nE5, nCs5, nCs5, nA4, nA4
	smpsPan             panCenter, $00
	smpsAlterVol        $FA
	dc.b	nCs4, $0C, nD4, $06, nE4, $0C, nRst, $06, nA4, $0C, nRst, $06
	dc.b	nAb4, $09, nRst, nFs4, $0C, nRst, $06, nE4, $0C, nRst, $06, nD4
	dc.b	$0C, nCs4, $06, nD4, $0C, nRst, $06, nD4, $0C, nE4, $06, nFs4
	dc.b	$09, nRst, nB4, nRst, nA4, nRst, nFs4, nRst, nFs4, $12, nAb4, $0C
	dc.b	nFs4, $06, nE4, $24
	smpsPan             panRight, $00
	smpsAlterVol        $06

WFZ_Loop03:
	dc.b	nBb4, $03, nA4
	smpsLoop            $00, $30, WFZ_Loop03
	smpsPan             panCenter, $00
	smpsAlterVol        $FA
	dc.b	nB3, $12, nCs4, nD4, nE4, nFs4, nAb4, nA4, nB4, nCs4, nD4, nE4
	dc.b	nFs4, nAb4, nA4, nB4, nCs5, nD5, $48, nEb5, nFs5, $24, nE5, nA5
	dc.b	nAb5, $24
	smpsJump            WFZ_Jump04

; FM2 Data
WFZ_FM2:
	smpsSetvoice        $01
	dc.b	nRst, $12

WFZ_Jump03:
	dc.b	nRst, $5A
	smpsCall            WFZ_Call03
	dc.b	nRst, $5A
	smpsCall            WFZ_Call03
	dc.b	nRst, $12, nCs3, $03, nRst, nCs3, nRst, nCs3, nRst, nCs3, $0C, nRst
	dc.b	$06, nCs3, $0F, nRst, $15
	smpsCall            WFZ_Call04
	dc.b	nRst, $12
	smpsCall            WFZ_Call04
	dc.b	nRst, $12
	smpsCall            WFZ_Call04

WFZ_Loop01:
	dc.b	nB3, $06, nG3, $0C, nBb3, $06, nF3, $0C, nAb3, $06, nE3, $66
	smpsLoop            $00, $02, WFZ_Loop01
	dc.b	nRst, $12, nD3, $03, nRst, nD3, nRst, nD3, nRst, nD3, $24, nRst
	dc.b	$12, nD3, $03, nRst, nB2, nRst, nD3, nRst, nFs3, $24, nRst, $12
	dc.b	nE3, $03, nRst, nE3, nRst, nE3, nRst, nE3, $24, nRst, $12, nE3
	dc.b	$03, nRst, nCs3, nRst, nE3, nRst, nAb3, $24, nRst, $12, nFs3, $03
	dc.b	nRst, nFs3, nRst, nFs3, nRst, nFs3, $24, nRst, $12, nFs3, $03, nRst
	dc.b	nFs3, nRst, nFs3, nRst, nFs3, $24, nRst, $12, nA3, $03, nRst, nA3
	dc.b	nRst, nA3, nRst, nA3, $24, nB3, $0C, nRst, $06, nB3, $0C, nRst
	dc.b	$06, nB3, $0C, nRst, $06, nB3, $12
	smpsJump            WFZ_Jump03

WFZ_Call03:
	dc.b	nB2, $03, nRst, nCs3, nRst, nD3, nRst, nCs3, $24
	smpsReturn

WFZ_Call04:
	dc.b	nD3, $03, nRst, nD3, nRst, nD3, nRst, nD3, $09, nRst, nD3, $12
	smpsReturn

; FM3 Data
WFZ_FM3:
	smpsSetvoice        $02
	dc.b	nRst, $12

WFZ_Jump02:
	smpsAlterVol        $FC

WFZ_Loop00:
	dc.b	nA3, $06, nRst, $03, nA3, nA3, nRst, nA3, nRst, nE3, nRst, nA3
	dc.b	nRst, nCs4, nRst, nB3, nRst, nA3, nRst, nB3, nRst, nCs4, nRst, nD4
	dc.b	nRst, nCs4, $48
	smpsLoop            $00, $02, WFZ_Loop00
	smpsAlterVol        $04
	dc.b	nRst, $12, nE3, $03, nRst, nE3, nRst, nE3, nRst, nE3, $09, nRst
	dc.b	nE3, $0F, nRst, $15, nFs3, $03, nRst, nFs3, nRst, nFs3, nRst, nFs3
	dc.b	$09, nRst, nFs3, $0F, nRst, $15, nFs3, $03, nRst, nFs3, nRst, nFs3
	dc.b	nRst, nFs3, $09, nRst, nFs3, $0F, nRst, $15, nAb3, $03, nRst, nAb3
	dc.b	nRst, nAb3, nRst, nAb3, $09, nRst, nAb3, $0C, nRst, $60, nRst, nRst
	dc.b	nRst, $18, nB3, $03, nRst, nB3, nRst, nB3, nRst, nB3, $24, nRst
	dc.b	$12, nB3, $03, nRst, nFs3, nRst, nB3, nRst, nD4, $24, nRst, $12
	dc.b	nCs4, $03, nRst, nCs4, nRst, nCs4, nRst, nCs4, $24, nRst, $12, nCs4
	dc.b	$03, nRst, nAb3, nRst, nCs4, nRst, nE4, $24, nRst, $12, nD4, $03
	dc.b	nRst, nD4, nD4, nD4, nRst, nD4, nRst, nA3, nRst, nB3, nRst, nD4
	dc.b	$15, nRst, $0F, nEb4, $03, nRst, nEb4, nEb4, nEb4, nRst, nEb4, nRst
	dc.b	nA3, nRst, nB3, nRst, nEb4, $15, nRst, $0F, nE4, $03, nRst, nE4
	dc.b	$09, nRst, $03, nE4, nRst, nE4, nRst, nE4, nRst, nE4, nRst, nE4
	dc.b	nRst, nE4, nRst, nE4, $12, nE4, $0C, nRst, $06, nE4, $0C, nRst
	dc.b	$06, nE4, $12
	smpsJump            WFZ_Jump02

; DAC Data
WFZ_DAC:
	dc.b	dVLowTimpani, $06, dVLowTimpani, dVLowTimpani

WFZ_Jump00:
	smpsCall            WFZ_Call00
	dc.b	dMidTimpani, $06
	smpsCall            WFZ_Call00
	dc.b	dVLowTimpani, $06, dVLowTimpani, $36, dMidTimpani, $12, dVLowTimpani, $36, dMidTimpani, $12, dVLowTimpani, $36
	dc.b	dMidTimpani, $06, dMidTimpani, dMidTimpani, dVLowTimpani, $36, dVLowTimpani, $06, dVLowTimpani, dVLowTimpani, $60
	smpsCall            WFZ_Call01
	dc.b	dVLowTimpani, $5A
	smpsCall            WFZ_Call01
	dc.b	dVLowTimpani, $36, dVLowTimpani, $06, dVLowTimpani, dVLowTimpani, dMidTimpani, $36, dMidTimpani, $12, dVLowTimpani, $36
	dc.b	dMidTimpani, $06, dMidTimpani, dMidTimpani, dVLowTimpani, $36, dMidTimpani, $06, dVLowTimpani, dMidTimpani, dVLowTimpani, $36
	dc.b	dVLowTimpani, $06, dVLowTimpani, dVLowTimpani, dMidTimpani, $36, dMidTimpani, $06, dVLowTimpani, $0C, dMidTimpani, $12
	dc.b	dVLowTimpani, dMidTimpani, dVLowTimpani, dMidTimpani, $09, dVLowTimpani, dMidTimpani, dVLowTimpani, dMidTimpani, dVLowTimpani, dMidTimpani, dVLowTimpani
	dc.b	$09
	smpsJump            WFZ_Jump00

WFZ_Call00:
	dc.b	dMidTimpani, $5A, dMidTimpani, $06, dVLowTimpani, dMidTimpani, dVLowTimpani, dMidTimpani, dVLowTimpani, dMidTimpani, dVLowTimpani
	smpsReturn

WFZ_Call01:
	dc.b	dMidTimpani, $06, dVLowTimpani, dMidTimpani, dVLowTimpani, dMidTimpani, dVLowTimpani, dMidTimpani, dVLowTimpani, dMidTimpani
	smpsReturn

; FM4 Data
WFZ_FM4:
	smpsSetvoice        $03
	smpsCall            WFZ_Call02

WFZ_Jump01:
	dc.b	nA1, $78, nRst, $06
	smpsCall            WFZ_Call02
	dc.b	nA1, $78, nRst, $06
	smpsCall            WFZ_Call02
	dc.b	nA1, $36, nBb1, $12, nB1, $36, nFs1, $12, nB1, $36, nFs1, $12
	dc.b	nE1, $3C, nRst, $0C, nE1, $06, nF1, nG1, nA1, nG1, nF1, nE1
	dc.b	$36, nD1, $06, nE1, nF1, nE1, $1E, nRst, $06, nE1, nF1, nG1
	dc.b	nA1, nG1, nF1, nE1, $36, nB1, $06, nAb1, nF1, nE1, $0C, nRst
	dc.b	$06
	smpsCall            WFZ_Call02
	dc.b	nB1, $36, nFs1, $03, nRst, nFs1, nRst, nFs1, nRst, nB1, $36, nB1
	dc.b	$03, nRst, nFs1, nRst, nB1, nRst, nCs2, $36, nAb1, $03, nRst, nAb1
	dc.b	nRst, nAb1, nRst, nCs2, $36, nCs2, $03, nRst, nAb1, nRst, nCs2, nRst
	dc.b	nD1, $36, nD1, $03, nRst, nD1, nRst, nD1, nRst, nEb1, $36, nEb1
	dc.b	$03, nRst, nD1, nRst, nEb1, nRst, nE1, $36, nB1, $03, nRst, nAb1
	dc.b	nRst, nFs1, nRst, nE1, $36
	smpsCall            WFZ_Call02
	smpsJump            WFZ_Jump01

WFZ_Call02:
	dc.b	nE1, $06, nE1, nE1
	smpsReturn

WFZ_Voices:
;	Voice $00
;	$3A
;	$01, $02, $01, $02, 	$8E, $8E, $8D, $89, 	$0E, $0E, $0E, $16
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$1E, $20, $26, $88
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $01, $02, $01
	smpsVcRateScale     $02, $02, $02, $02
	smpsVcAttackRate    $09, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $16, $0E, $0E, $0E
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $08, $26, $20, $1E

;	Voice $01
;	$3D
;	$01, $01, $02, $01, 	$4C, $0F, $50, $12, 	$0B, $05, $01, $02
;	$01, $00, $00, $00, 	$20, $24, $24, $14, 	$1D, $84, $88, $8A
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $02, $01, $01
	smpsVcRateScale     $00, $01, $00, $01
	smpsVcAttackRate    $12, $10, $0F, $0C
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $02, $01, $05, $0B
	smpsVcDecayRate2    $00, $00, $00, $01
	smpsVcDecayLevel    $01, $02, $02, $02
	smpsVcReleaseRate   $04, $04, $04, $00
	smpsVcTotalLevel    $0A, $08, $04, $1D

;	Voice $02
;	$3A
;	$01, $01, $01, $01, 	$8E, $8E, $8D, $50, 	$0E, $0E, $0E, $00
;	$0B, $00, $00, $00, 	$04, $04, $04, $04, 	$17, $28, $27, $8A
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $01, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $10, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $0E, $0E, $0E
	smpsVcDecayRate2    $00, $00, $00, $0B
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $04, $04, $04, $04
	smpsVcTotalLevel    $0A, $27, $28, $17

;	Voice $03
;	$3A
;	$20, $23, $60, $01, 	$1E, $1F, $1F, $1F, 	$0A, $0A, $0B, $0A
;	$05, $07, $0A, $08, 	$AF, $8F, $9F, $7F, 	$21, $25, $28, $82
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $06, $02, $02
	smpsVcCoarseFreq    $01, $00, $03, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0B, $0A, $0A
	smpsVcDecayRate2    $08, $0A, $07, $05
	smpsVcDecayLevel    $07, $09, $08, $0A
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $02, $28, $25, $21

