ARZ_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     ARZ_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $E0

	smpsHeaderDAC       ARZ_DAC
	smpsHeaderFM        ARZ_FM1,	$00, $0C
	smpsHeaderFM        ARZ_FM2,	$00, $0F
	smpsHeaderFM        ARZ_FM3,	$00, $13
	smpsHeaderFM        ARZ_FM4,	$00, $0F
	smpsHeaderFM        ARZ_FM5,	$00, $0C
	smpsHeaderPSG       ARZ_PSG1,	$D0, $04, $00, fTone_01
	smpsHeaderPSG       ARZ_PSG2,	$D0, $06, $00, fTone_01
	smpsHeaderPSG       ARZ_PSG3,	$00, $01, $00, fTone_02

ARZ_Call04:
	dc.b	nD5, $06, nC5, nD5, $12, nF5, nD5, $0C, nE5, nRst, $06
	dc.b	$12, nG5, $0C, nF5, $06, nRst, nC6, nA5, $30, smpsNoAttack, $0C
	smpsReturn

ARZ_Call05:
	dc.b	nC5, $12, nBb4, nG4, nC5, $06, nRst, nBb4, nC5, nRst, nBb4, nRst
	dc.b	nBb4, $12, nA4, nF4, nBb4, $06, nRst, nA4, nBb4, nRst, nA4, nRst
	dc.b	nA4, $12, nG4, nE4, nA4, $06, nRst, nG4, nA4, nRst, nG4, nRst
	smpsReturn

ARZ_Call03:
	dc.b	nBb5, $12, nC6, nD6, nD6, $06, nRst, nD6, nC6, nRst, nBb5, nRst
	dc.b	nA5, $30, nRst, $06, nC6, nRst, nC6, nBb5, nRst, nA5, nRst, nG5
	dc.b	$30, nRst, $06, nBb5, nRst, nBb5, nA5, nRst, nG5, nRst
	smpsReturn

ARZ_Call02:
	dc.b	nF5, $12, nG5, nA5, nG5, $06, nRst, nG5, nF5, nRst, nG5, nRst
	dc.b	nF5, $30, nRst, $06, nA5, nRst, nA5, nG5, nRst, nF5, nRst, nE5
	dc.b	$30, nRst, $06, nG5, nRst, nG5, nE5, nRst, nE5, nRst, $06
	smpsReturn

; FM1 Data
ARZ_FM1:
	smpsSetvoice        $00
	smpsModSet          $06, $02, $02, $02
	dc.b	nC2, $06, nD2

ARZ_Jump04:
	dc.b	nD1, $30, smpsNoAttack, $30, smpsNoAttack, nD1, nRst, $12, nA1, $06, nA1, nRst
	dc.b	nC2, nD2, nD1, $30, smpsNoAttack, $30, smpsNoAttack, nD1, nRst, $12, nA1, $06
	dc.b	nA1, nRst, $12, nRst, nG1, nBb1, $06, nRst, $18, nC2, $12, nG1
	dc.b	$06, nRst, nRst, $12, nF1, nA1, $06, nRst, $18, nBb1, $12, nF1
	dc.b	$06, nRst, nRst, $12, nE1, nG1, $06, nRst, $18, nA1, $12, nCs2
	dc.b	$06, nRst, nRst, $12, nD1, nFs1, $08, nRst, $16, nA1, $06, nE1
	dc.b	nF1, nG1, nA1, nRst, $12, nG1, nBb1, $08, nRst, $16, nC2, $12
	dc.b	nG1, $09, nRst, $03, nRst, $12, nF1, nA1, $06, nRst, $18, nBb1
	dc.b	$12, nF1, $07, nRst, $05, nRst, $12, nE2, nCs2, $08, nRst, $16
	dc.b	nA1, $12, nE2, $08, nRst, $04, nRst, $12, nD2, $06, $0C, nA1
	dc.b	$06, nRst, nA1, nA1, $0C, $06, nD2, nA1, $12, nG1, $0C, nRst
	dc.b	$06, nD2, $12, nG1, $0C, nG1, nRst, $06, nD2, $12, nG1, $0C
	dc.b	nF1, nRst, $06, nC2, $12, nF1, $0C, nF1, nRst, $06, nC2, $12
	dc.b	nF1, $0C, nE1, nRst, $06, nE2, $12, nCs2, $0C, nA1, nRst, $06
	dc.b	nE1, $12, nA1, $0C, nD2, nRst, $06, nA1, $12, nFs1, $0C, nRst
	dc.b	$08, nD1, nE1, nFs1, nG1, nA1, nG1, $0C, nRst, $06, nD2, $12
	dc.b	nG2, $0C, nRst, $06, nG2, nRst, nD2, $12, nG1, $0C, nF1, nRst
	dc.b	$06, nC2, $12, nF2, $0C, nF2, nRst, $06, nC2, $12, nA1, $0C
	dc.b	nE1, nRst, $06, nA1, $12, nCs2, $0C, nE2, $12, nCs2, nA1, $0C
	dc.b	nD2, $03, nRst, nD2, nRst, nD2, $06, nRst, $12, nD2, $03, nRst
	dc.b	$03, nD2, nRst, nD2, $06, nRst, $1E, nC2, $06, nD2
	smpsJump            ARZ_Jump04

; FM2 Data
ARZ_FM2:
	dc.b	nRst, $0C

ARZ_Jump03:
	smpsSetvoice        $01
	smpsModSet          $04, $02, $03, $02
	dc.b	nD5, $12, nE5, nF5, $0C, nA5, $30, smpsNoAttack, $30, smpsNoAttack, $0C, nRst
	dc.b	$06, nCs5, nCs5, nRst, $12, nD5, nE5, nF5, $06, nD5, nA5, $30
	dc.b	smpsNoAttack, $30, smpsNoAttack, $0C, nRst, $06, nCs5, nCs5, nRst
	smpsSetvoice        $02
	smpsAlterVol        $06
	smpsCall            ARZ_Call04
	dc.b	nRst, $06, nA5, nRst, nBb5, $12, nA5, nG5, $06, nF5, nE5, $18
	dc.b	nG5, nFs5, $30, smpsNoAttack, $18, nRst, $0C
	smpsCall            ARZ_Call04
	dc.b	nRst, $06, $0C, nBb5, $12, nA5, nG5, $06, nF5, nE5, $18
	dc.b	nCs5, nD5, $30, smpsNoAttack, $18, nRst, $18
	smpsSetvoice        $01
	smpsAlterVol        $F8
	smpsCall            ARZ_Call05
	dc.b	nFs4, nRst, nFs4, nRst, nG4, nG4, nRst, nA4, $30, nRst, $06
	smpsCall            ARZ_Call05
	dc.b	nD4, $03, nRst, nD4, nRst, nD4, $06, nRst, $12, nD4, $03, nRst
	dc.b	$03, nD4, nRst, nD4, $06, nRst, $2A
	smpsAlterVol        $02
	smpsJump            ARZ_Jump03

; FM3 Data
ARZ_FM3:
	smpsSetvoice        $01
	smpsModSet          $04, $02, $03, $02
	dc.b	nRst, $0C
	smpsPan             panLeft, $00

ARZ_Jump02:
	dc.b	nRst, $07, nD5, $12, nE5, nF5, $0C, nA5, $30, smpsNoAttack, $30, smpsNoAttack
	dc.b	$0B, nG5, $06, nG5, nRst, $12, nRst, $07, nD5, $12, nE5, nF5
	dc.b	$06, nD5, nA5, $30, smpsNoAttack, $30, smpsNoAttack, $0B, nG5, $06, nG5, nRst
	dc.b	nRst, $07
	smpsSetvoice        $02
	smpsAlterVol        $06
	smpsCall            ARZ_Call04
	dc.b	nRst, $06, nA5, nRst, nBb5, $12, nA5, nG5, $06, nF5, nE5, $18
	dc.b	nG5, nFs5, $30, smpsNoAttack, $18, nRst, $0C
	smpsCall            ARZ_Call04
	dc.b	nRst, $06, $0C, nBb5, $12, nA5, nG5, $06, nF5, nE5, $18
	dc.b	nCs5, nD5, $30, smpsNoAttack, $18, nRst, $18
	smpsSetvoice        $01
	smpsAlterVol        $F8
	smpsCall            ARZ_Call05
	dc.b	nFs4, nRst, nFs4, nRst, nG4, nG4, nRst, nA4, $30, nRst, $06, nC5
	dc.b	$12, nBb4, nG4, nC5, $06, nRst, nBb4, nC5, nRst, nBb4, nRst, nBb4
	dc.b	$12, nA4, nF4, nBb4, $06, nRst, nA4, nBb4, nRst, nA4, nRst, nA4
	dc.b	$12, nG4, nE4, nA4, $06, nRst, nG4, nA4, nRst, nG4, $05
	smpsAlterVol        $FC
	dc.b	nF5, $03, nRst, nF5, nRst, nF5, $06, nRst, $12, nF5, $03, nRst
	dc.b	$03, nF5, nRst, nF5, $06, nRst, $2A
	smpsAlterVol        $06
	smpsJump            ARZ_Jump02

; FM4 Data
ARZ_FM4:
	dc.b	nRst, $0C

ARZ_Loop05:
	smpsSetvoice        $03
	smpsPan             panRight, $00
	dc.b	nD4, $0C, nF4, $06, nC4, nRst, nE4, nRst, nD4, $0C, nD4, $06
	dc.b	nRst, nF4, nC4, $0C, nE4, nD4, nF4, $06, nC4, $0C, nE4, $06
	dc.b	nRst, nD4, $18
	smpsSetvoice        $05
	dc.b	nA3, $06, nA3, nRst, $12
	smpsSetvoice        $03
	smpsLoop            $00, $02, ARZ_Loop05

ARZ_Loop06:
	dc.b	nBb3, $0C, nD4, $06, nF4, $0C, nBb3, nC4, $06, nRst, nC4, $0C
	dc.b	nE4, $06, nG4, $0C, nC4, $06, nRst, nF4, $0C, nA4, $06, nC4
	dc.b	$0C, nE4, nF4, nA4, $06, nRst, nA4, nBb3, $0C, nD4, nE4, nG4
	dc.b	$06, nCs4, $0C, nD4, nE4, nG4, $06, nRst, nG4, nCs4, $0C, nE4
	dc.b	nD4, nFs4, $06, nA3, $0C, nC4, nD4, nFs4, $06, nRst, nFs4, nA3
	dc.b	$0C, nC4
	smpsLoop            $00, $02, ARZ_Loop06
	smpsSetvoice        $01
	smpsAlterVol        $04
	smpsModSet          $02, $02, $01, $02
	smpsCall            ARZ_Call03
	dc.b	nA5, $06, nRst, nA5, nRst, nBb5, nBb5, nRst, nC6, nRst, nRst, $02
	dc.b	nFs5, $08, nG5, nA5, nBb5, nC6
	smpsCall            ARZ_Call03
	dc.b	nF5, nF5, nF5, nRst, $12, nF5, $06, nF5, nF5, nRst, $2A
	smpsAlterVol        $FC
	smpsJump            ARZ_Loop05

; FM5 Data
ARZ_FM5:
	dc.b	nRst, $0C

ARZ_Jump01:
	smpsModSet          $06, $01, $06, $05
	smpsAlterPitch      $F4
	smpsPan             panCenter, $00

ARZ_Loop04:
	dc.b	nRst, $30, nRst
	smpsSetvoice        $04
	dc.b	nD6, $06, nA6, nD6, nA6, nD6, $18, nRst, $12, nCs6, $06, nCs6
	dc.b	nRst, $12
	smpsLoop            $00, $02, ARZ_Loop04
	dc.b	nRst, $30, nRst, nRst, nF5, $06, nF5, nC6, nA5, $1E, nRst, $30
	dc.b	nRst, nRst, $06, nD6, nRst, nD6, nC6, nRst, nC6, nRst, nBb5, nRst
	dc.b	nBb5, nRst, nA5, $03, nRst, nA5, nRst, $09, nRst, $06, nRst, $30
	dc.b	nRst, nRst, nF5, $06, nF5, nC6, nA5, $1E, nRst, $30, nRst, nRst
	dc.b	$06, nD6, nRst, nD6, nD6, nRst, nC6, nRst, nD6, $0C, nC6, $06
	dc.b	nD6, $12, nC6, $02, nB5, nA5, nG5, nF5, nE5
	smpsAlterVol        $04
	smpsAlterPitch      $0C
	smpsSetvoice        $01
	smpsModSet          $02, $02, $01, $02
	smpsPan             panLeft, $00
	smpsCall            ARZ_Call02
	dc.b	nFs5, $06, nRst, nFs5, nRst, nG5, nG5, nRst, nA5, nRst, nRst, $02
	dc.b	nD5, $08, nE5, nFs5, nG5, nA5
	smpsCall            ARZ_Call02
	dc.b	nA5, $06, nA5, nA5, nRst, $12, nA5, $06, nA5, nA5, nRst, $2A
	smpsAlterVol        $FC
	smpsJump            ARZ_Jump01

ARZ_Call00:
	dc.b	dKick, $0C, dSnare, $06, dKick, $12, dKick, $06, dKick, $12, dMidTom, $06
	dc.b	dSnare, $0C, dClap, $06, dKick, nRst
	smpsReturn

ARZ_Call01:
	dc.b	dKick, $0C, dSnare, $06, dKick, $12, dMidTom, $06, dMidTom
	smpsReturn

; DAC Data
ARZ_DAC:
	dc.b	dClap, $06, dClap

ARZ_Jump00:
	dc.b	dKick, $12, $1E, $12, $1E, $12, $1E, $12, dClap, $06, dSnare, nRst
	dc.b	nRst, $0C, dKick, $12, dKick, dMidTom, $06, dLowTom, dKick, $12, dKick, dLowTom
	dc.b	$06, dFloorTom, dKick, $12, $06, dMidTom, dMidTom, dLowTom, dLowTom, dFloorTom, dFloorTom, nRst
	dc.b	dSnare, $06, $0C, dKick

ARZ_Loop00:
	smpsCall            ARZ_Call00
	smpsLoop            $00, $03, ARZ_Loop00
	dc.b	dClap, $06, dSnare, dKick, dSnare, dSnare, nRst, dSnare, nRst, dSnare, nRst, dSnare
	dc.b	nRst, dSnare, dSnare, dClap, dClap

ARZ_Loop01:
	smpsCall            ARZ_Call00
	smpsLoop            $00, $03, ARZ_Loop01
	dc.b	dSnare, $04, dClap, dClap, dClap, dClap, dClap, dClap, $0C, $06, dClap, dClap
	dc.b	dClap, dClap, dClap, dClap, dClap, dClap, $0C

ARZ_Loop02:
	smpsCall            ARZ_Call01
	smpsLoop            $00, $06, ARZ_Loop02
	dc.b	dKick, $0C, dSnare, dKick, $06, dClap, $0C, $06, dKick, $08, dSnare, dSnare
	dc.b	dSnare, dSnare, dSnare

ARZ_Loop03:
	smpsCall            ARZ_Call01
	smpsLoop            $00, $06, ARZ_Loop03
	dc.b	dClap, $06, dSnare, dSnare, $18, dSnare, $06, dSnare, dSnare, $18, dKick, $0C
	dc.b	dClap, $06, dClap
	smpsJump            ARZ_Jump00

; PSG1 Data
ARZ_PSG1:
	dc.b	nRst, $0C

ARZ_Jump05:
	smpsAlterPitch      $0C

ARZ_Loop09:
	dc.b	nA3, $0C, nD4, $06, nG3, nRst, nC4, nRst, nA3, $0C, nA3, $06
	dc.b	nRst, nD4, nG3, $0C, nC4, nA3, nD4, $06, nG3, nRst, nC4, nRst
	dc.b	nA3, $18, nF3, $06, nF3, nRst, $12
	smpsLoop            $00, $02, ARZ_Loop09

ARZ_Loop0A:
	dc.b	nG3, $0C, nBb3, $06, nD4, $0C, nG3, nG3, $06, nRst, nG3, $0C
	dc.b	nBb3, $06, nE4, $0C, nG3, $06, nRst, $06, nC4, $0C, nF4, $06
	dc.b	nA3, $0C, nC4, nD4, nF4, $06, nRst, nF4, nF3, $0C, nBb3, nBb3
	dc.b	nE4, $06, nG3, $0C, nBb3, nCs4, nE4, $06, nRst, nE4, nA3, $0C
	dc.b	nCs4, nA3, nD4, $06, nG3, $0C, nA3, nA3, nD4, $06, nRst, nD4
	dc.b	nFs3, $0C, nA3
	smpsLoop            $00, $02, ARZ_Loop0A
	smpsAlterPitch      $F4
	dc.b	nG5, $0C, nBb5, $06, nD5, $0C, nF5, nG5, $06, nRst, nBb5, nRst
	dc.b	nD5, nF5, $0C, nG5, $06, nRst, nF5, $0C, nA5, $06, nC5, $0C
	dc.b	nE5, nF5, $06, nRst, nA5, nRst, nC5, nE5, $0C, nF5, $06, nRst
	dc.b	nE5, $0C, nG5, $06, nCs5, $0C, nD5, nE5, $06, nRst, nG5, nRst
	dc.b	nCs5, nD5, $0C, nE5, $06, nRst, nFs5, $0C, nA5, $06, nD5, $0C
	dc.b	nE5, nFs5, $06, nRst, nA5, nRst, nD5, nE5, $0C, nFs5, $06, nRst
	dc.b	nG5, $0C, nBb5, $06, nD5, $0C, nF5, nG5, nBb5, $06, nRst, nD5
	dc.b	nF5, $0C, nG5, $06, nRst, nF5, $0C, nA5, $06, nC5, $0C, nE5
	dc.b	nF5, nA5, $06, nRst, nC5, nE5, $0C, nF5, $06, nRst, nE5, $0C
	dc.b	nG5, $06, nCs5, $0C, nD5, nE5, nG5, $06, nRst, nCs5, nD5, $0C
	dc.b	nE5, $06, nRst, nA5, nA5, nA5, nRst, $12, nA5, $06, nA5, nA5
	dc.b	nRst, $2A
	smpsJump            ARZ_Jump05

	; Unreachable
	smpsStop

; PSG2 Data
ARZ_PSG2:
	dc.b	nRst, $0C
	smpsModSet          $03, $02, $01, $05

ARZ_Loop08:
	dc.b	nRst, $30, nRst
	smpsPSGvoice        fTone_0A
	dc.b	nA5, $06, nE6, nA5, nE6, nA5, $18, nRst, $12, nF5, $06, nF5
	dc.b	nRst, $12
	smpsLoop            $00, $02, ARZ_Loop08
	dc.b	nRst, $30, nRst, nRst, nC5, $06, nD5, nA5, nF5, $1E, nRst, $30
	dc.b	nRst, nRst, $06, nA5, nRst, nA5, nG5, nRst, nG5, nRst, nFs5, nRst
	dc.b	nFs5, nRst, nD5, $03, nRst, nD5, nRst, $09, nRst, $06, nRst, $30
	dc.b	nRst, nRst, nC5, $06, nD5, nA5, nF5, $1E, nRst, $30, nRst, nRst
	dc.b	$06, nA5, nRst, nG5, nA5, nRst, nG5, nRst, nA5, $0C, nG5, $06
	dc.b	nA5, $12, nG5, $02, nF5, nE5, nD5, nC5, nB4
	smpsPSGvoice        fTone_01
	smpsAlterVol        $FE
	dc.b	nD5, $0C, nG5, $06, nBb4, $0C, nD5, nD5, $06, nRst, nF5, nRst
	dc.b	nG4, nD5, $0C, nD5, $06, nRst, nC5, $0C, nF5, $06, nA4, $0C
	dc.b	nC5, nC5, $06, nRst, nF5, nRst, nA4, nC5, $0C, nC5, $06, nRst
	dc.b	nCs5, $0C, nE5, $06, nA4, $0C, nBb4, nCs5, $06, nRst, nE5, nRst
	dc.b	nA4, nA4, $0C, nA4, $06, nRst, nD5, $0C, nFs5, $06, nA4, $0C
	dc.b	nC5, nD5, $06, nRst, nFs5, nRst, nA4, nC5, $0C, nD5, $06, nRst
	dc.b	nD5, $0C, nG5, $06, nBb4, $0C, nD5, nD5, nF5, $06, nRst, nG4
	dc.b	nD5, $0C, nD5, $06, nRst, nC5, $0C, nF5, $06, nA4, $0C, nC5
	dc.b	nC5, nF5, $06, nRst, nA4, nC5, $0C, nC5, $06, nRst, nCs5, $0C
	dc.b	nE5, $06, nA4, $0C, nBb4, nCs5, nE5, $06, nRst, nA4, nA4, $0C
	dc.b	nA4, $06, nRst, nE5, nE5, nE5, nRst, $12, nE5, $06, nE5, nE5
	dc.b	nRst, $2A
	smpsAlterVol        $02
	smpsJump            ARZ_Loop08

; PSG3 Data
ARZ_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $0C
	smpsPSGvoice        fTone_02

ARZ_Loop07:
	dc.b	nRst, $0C, nMaxPSG, $06, nRst, $07, nMaxPSG, $06, nRst, $11, nMaxPSG, $0C
	dc.b	nRst, $06, nMaxPSG, $0C, nRst, $06, nMaxPSG, nRst
	smpsLoop            $00, $13, ARZ_Loop07
	dc.b	nMaxPSG, $06, nMaxPSG, nMaxPSG, nRst, $12, nMaxPSG, $06, nMaxPSG, nMaxPSG, nRst, $2A
	smpsJump            ARZ_Loop07

ARZ_Voices:
;	Voice $00
;	$18
;	$37, $32, $31, $31, 	$9E, $DC, $1C, $9C, 	$0D, $06, $04, $01
;	$08, $0A, $03, $05, 	$B6, $B6, $36, $28, 	$2C, $22, $14, $00
	smpsVcAlgorithm     $00
	smpsVcFeedback      $03
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $01, $01, $02, $07
	smpsVcRateScale     $02, $00, $03, $02
	smpsVcAttackRate    $1C, $1C, $1C, $1E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $01, $04, $06, $0D
	smpsVcDecayRate2    $05, $03, $0A, $08
	smpsVcDecayLevel    $02, $03, $0B, $0B
	smpsVcReleaseRate   $08, $06, $06, $06
	smpsVcTotalLevel    $00, $14, $22, $2C

;	Voice $01
;	$3A
;	$01, $01, $01, $02, 	$8D, $07, $07, $52, 	$09, $00, $00, $03
;	$01, $02, $02, $00, 	$52, $02, $02, $28, 	$18, $22, $18, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $01, $01, $01
	smpsVcRateScale     $01, $00, $00, $02
	smpsVcAttackRate    $12, $07, $07, $0D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $00, $00, $09
	smpsVcDecayRate2    $00, $02, $02, $01
	smpsVcDecayLevel    $02, $00, $00, $05
	smpsVcReleaseRate   $08, $02, $02, $02
	smpsVcTotalLevel    $80, $18, $22, $18

;	Voice $02
;	$3D
;	$01, $02, $02, $02, 	$10, $50, $50, $50, 	$07, $08, $08, $08
;	$01, $00, $00, $00, 	$24, $18, $18, $18, 	$1C, $82, $82, $82
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $02, $02, $01
	smpsVcRateScale     $01, $01, $01, $00
	smpsVcAttackRate    $10, $10, $10, $10
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $08, $08, $07
	smpsVcDecayRate2    $00, $00, $00, $01
	smpsVcDecayLevel    $01, $01, $01, $02
	smpsVcReleaseRate   $08, $08, $08, $04
	smpsVcTotalLevel    $82, $82, $82, $1C

;	Voice $03
;	$32
;	$71, $0D, $33, $01, 	$5F, $99, $5F, $94, 	$05, $05, $05, $07
;	$02, $02, $02, $02, 	$11, $11, $11, $72, 	$23, $2D, $26, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $03, $00, $07
	smpsVcCoarseFreq    $01, $03, $0D, $01
	smpsVcRateScale     $02, $01, $02, $01
	smpsVcAttackRate    $14, $1F, $19, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $07, $05, $05, $05
	smpsVcDecayRate2    $02, $02, $02, $02
	smpsVcDecayLevel    $07, $01, $01, $01
	smpsVcReleaseRate   $02, $01, $01, $01
	smpsVcTotalLevel    $80, $26, $2D, $23

;	Voice $04
;	$3A
;	$32, $01, $52, $31, 	$1F, $1F, $1F, $18, 	$01, $1F, $00, $00
;	$00, $0F, $00, $00, 	$5A, $0F, $03, $1A, 	$3B, $30, $4F, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $05, $00, $03
	smpsVcCoarseFreq    $01, $02, $01, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $18, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $1F, $01
	smpsVcDecayRate2    $00, $00, $0F, $00
	smpsVcDecayLevel    $01, $00, $00, $05
	smpsVcReleaseRate   $0A, $03, $0F, $0A
	smpsVcTotalLevel    $00, $4F, $30, $3B

;	Voice $05
;	$32
;	$71, $0D, $33, $01, 	$5F, $99, $5F, $94, 	$05, $05, $05, $07
;	$02, $02, $02, $02, 	$11, $11, $11, $77, 	$23, $2D, $26, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $03, $00, $07
	smpsVcCoarseFreq    $01, $03, $0D, $01
	smpsVcRateScale     $02, $01, $02, $01
	smpsVcAttackRate    $14, $1F, $19, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $07, $05, $05, $05
	smpsVcDecayRate2    $02, $02, $02, $02
	smpsVcDecayLevel    $07, $01, $01, $01
	smpsVcReleaseRate   $07, $01, $01, $01
	smpsVcTotalLevel    $80, $26, $2D, $23

