EHZ_2p_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     EHZ_2p_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $5B

	smpsHeaderDAC       EHZ_2p_DAC
	smpsHeaderFM        EHZ_2p_FM1,	$F4, $0A
	smpsHeaderFM        EHZ_2p_FM2,	$F4, $0F
	smpsHeaderFM        EHZ_2p_FM3,	$F4, $0A
	smpsHeaderFM        EHZ_2p_FM4,	$F4, $10
	smpsHeaderFM        EHZ_2p_FM5,	$E8, $10
	smpsHeaderPSG       EHZ_2p_PSG1,	$D0, $06, $00, $00
	smpsHeaderPSG       EHZ_2p_PSG2,	$D0, $06, $00, $00
	smpsHeaderPSG       EHZ_2p_PSG3,	$00, $05, $00, $00

; FM1 Data
EHZ_2p_FM1:
	smpsSetvoice        $04
	smpsAlterNote       $01
	dc.b	nG6, $06, nE6, nF6, nD6, nE6, nC6, nC6, nA5

EHZ_2p_Jump01:
	smpsCall            EHZ_2p_Call02
	smpsSetvoice        $03
	smpsAlterVol        $06
	dc.b	nG4, $06
	smpsNoteFill        $06
	dc.b	nA4, $03, nC5, nC5, nA4
	smpsSetvoice        $04
	smpsAlterVol        $FA
	smpsNoteFill        $00
	smpsCall            EHZ_2p_Call02
	dc.b	nRst, $12, nC6, $18, nA5, $0C, nC6, nBb5, nC6, $06, nD6, $0C
	dc.b	nC6, $06, nBb5, $0C, nC6, $18, nA5, $0C, nC6, nBb5, $06
	smpsSetvoice        $02
	smpsAlterVol        $06
	dc.b	nEb5, $06, nF5, nEb5, nRst, nEb5, nF5, nEb5
	smpsSetvoice        $04
	smpsAlterVol        $FA
	dc.b	nC6, $18, nA5, $0C, nC6, nBb5, nC6, $06, nD6, $0C, nC6, $06
	dc.b	nBb5, $0C, nA5, $18, nF5, $0C, nA5
	smpsSetvoice        $02
	smpsAlterVol        $06
	dc.b	nG5, $03, nRst, nG5, $06, nA5, $03, nG5, nA5, $06, nG5, $03
	dc.b	nRst, $15
	smpsSetvoice        $04
	smpsAlterVol        $FA
	smpsJump            EHZ_2p_Jump01

EHZ_2p_Call02:
	smpsSetvoice        $03
	smpsAlterVol        $06
	dc.b	nE5, $06
	smpsNoteFill        $06
	dc.b	nC5, $03, nA4, nC5, $06, nRst, nRst
	smpsSetvoice        $04
	smpsAlterVol        $FA
	smpsNoteFill        $00
	dc.b	nB4, $06, $09, $03
	smpsSetvoice        $03
	smpsAlterVol        $06
	smpsNoteFill        $06
	dc.b	nF5, $03, nF5, nRst, nF5, nRst, nF5
	smpsNoteFill        $00
	dc.b	nFs5, $06, nG5, nRst
	smpsNoteFill        $06
	dc.b	nG5, $03, $03, nA5, nG5
	smpsNoteFill        $00
	dc.b	nE5, $06
	smpsNoteFill        $06
	dc.b	nC5, $03, nA4, nC5, $06, nRst, nRst
	smpsNoteFill        $00
	smpsSetvoice        $04
	smpsAlterVol        $FA
	dc.b	nE5, nG5, nE5
	smpsSetvoice        $02
	smpsAlterVol        $06
	smpsNoteFill        $06
	dc.b	nF5, $03, nF5, nRst, nF5, nRst, nF5
	smpsNoteFill        $00
	dc.b	nFs5, $06, nG5, $03, nRst
	smpsSetvoice        $04
	smpsAlterVol        $FA
	smpsReturn

; FM4 Data
EHZ_2p_FM4:
	smpsSetvoice        $04
	smpsAlterVol        $FA
	dc.b	nRst, $03, nF6, $06, nD6, nE6, nC6, nD6, nB5, nB5, nG5, $03
	smpsAlterVol        $06

EHZ_2p_Loop05:
	smpsSetvoice        $01
	smpsPan             panRight, $00
	smpsAlterPitch      $F4
	smpsNoteFill        $06
	dc.b	nRst, $06, nE5, $03, $09, $0C, nG5, $03, $09, $06
	smpsSetvoice        $04
	smpsPan             panCenter, $00
	smpsAlterVol        $FA
	smpsNoteFill        $00
	dc.b	nA5
	smpsNoteFill        $06
	smpsAlterVol        $06
	smpsSetvoice        $01
	smpsPan             panRight, $00
	dc.b	nF5, $03, $09, $0C, nG5, $03, $09, $0C, nE5, $03, $09, $0C
	dc.b	nG5, $03, $09, $06
	smpsSetvoice        $02
	smpsPan             panCenter, $00
	smpsAlterPitch      $0C
	dc.b	nA5, $03, nA5, nRst, nA5, nRst, nA5
	smpsNoteFill        $00
	dc.b	nBb5, $06, nB5, $03
	smpsSetvoice        $01
	smpsPan             panRight, $00
	smpsAlterPitch      $F4
	smpsNoteFill        $06
	dc.b	nRst, nG5, $03, $09, $06
	smpsSetvoice        $02
	smpsPan             panCenter, $00
	smpsAlterPitch      $0C
	smpsNoteFill        $00
	smpsLoop            $00, $02, EHZ_2p_Loop05
	smpsSetvoice        $01
	smpsPan             panRight, $00
	smpsAlterPitch      $F4
	smpsNoteFill        $06
	dc.b	nRst, $06, nA5, $03, $09, $03, $09, $03, $09, $03, $03, nRst
	dc.b	$06, nG5, $03, $09, $03, $09, $03, $09, $03, $03, nRst, $06
	dc.b	nA5, $03, $09, $03, $09, $03, $09, $03, $03
	smpsSetvoice        $02
	smpsPan             panCenter, $00
	smpsAlterPitch      $0C
	smpsNoteFill        $00
	dc.b	nRst, $06, nG5, nA5, nG5, nRst, nG5, nA5, nG5
	smpsSetvoice        $01
	smpsPan             panRight, $00
	smpsAlterPitch      $F4
	smpsNoteFill        $06
	dc.b	nRst, $06, nA5, $03, $09, $03, $09, $03, $09, $03, $03, nRst
	dc.b	$06, nG5, $03, $09, $03, $09, $03, $09, $03, $03, nRst, $06
	dc.b	nF5, $03, $09, $03, $09, $03, $09, $03, $03
	smpsSetvoice        $02
	smpsPan             panCenter, $00
	smpsAlterPitch      $0C
	smpsNoteFill        $00
	dc.b	nB5, $03, nRst, nB5, $06, nC6, $03, nB5, nC6, $06, nB5, $03
	dc.b	nRst, $15
	smpsJump            EHZ_2p_Loop05

; FM3 Data
EHZ_2p_FM3:
	smpsSetvoice        $03
	smpsNoteFill        $06
	dc.b	nRst, $1E, nG5, $03, $03, nA5, nC6, nC6, nA5

EHZ_2p_Jump00:
	smpsCall            EHZ_2p_Call00
	smpsSetvoice        $01
	smpsPan             panRight, $00
	smpsAlterPitch      $F4
	smpsNoteFill        $06
	smpsAlterVol        $06
	dc.b	nRst, $06, nF5, $03, $09, $06
	smpsSetvoice        $03
	smpsPan             panCenter, $00
	smpsAlterPitch      $0C
	smpsNoteFill        $00
	smpsAlterVol        $FA
	dc.b	nRst, nG5
	smpsNoteFill        $06
	dc.b	nA5, $03, nC6, nC6, nA5
	smpsCall            EHZ_2p_Call00
	smpsSetvoice        $01
	smpsPan             panRight, $00
	smpsAlterPitch      $F4
	smpsNoteFill        $06
	smpsAlterVol        $06
	dc.b	nRst, $06, nF5, $03, $09, $06, nRst, nG5, $03, $09, $06
	smpsSetvoice        $03
	smpsPan             panCenter, $00
	smpsAlterPitch      $0C
	smpsNoteFill        $00
	smpsAlterVol        $FA
	smpsCall            EHZ_2p_Call01
	dc.b	nRst, $30
	smpsCall            EHZ_2p_Call01
	smpsSetvoice        $01
	smpsPan             panRight, $00
	smpsAlterPitch      $F4
	smpsNoteFill        $06
	smpsAlterVol        $06
	dc.b	nRst, $06, nG5, $03, $09, $03, $09, $03, $09, $03, $03
	smpsSetvoice        $03
	smpsPan             panCenter, $00
	smpsAlterPitch      $0C
	smpsNoteFill        $00
	smpsAlterVol        $FA
	smpsCall            EHZ_2p_Call01
	dc.b	nRst, $30, nD6, $0C, nE6, nF6, nFs6, nG6, $06
	smpsSetvoice        $01
	smpsPan             panRight, $00
	smpsAlterPitch      $F4
	smpsNoteFill        $06
	smpsAlterVol        $06
	dc.b	nB5, $03, $09, $03, $03
	smpsSetvoice        $03
	smpsPan             panCenter, $00
	smpsAlterPitch      $0C
	smpsNoteFill        $00
	smpsAlterVol        $FA
	smpsNoteFill        $00
	dc.b	nRst, $06, nG5
	smpsNoteFill        $06
	dc.b	nA5, $03, nC6, nC6, nA5
	smpsJump            EHZ_2p_Jump00

EHZ_2p_Call01:
	smpsNoteFill        $06
	dc.b	nRst, $06, nA5, nF5, $03, nC5, $06, $03, nF5, $06, nA5, nBb5
	dc.b	$03
	smpsNoteFill        $00
	dc.b	nA5, $09
	smpsReturn

EHZ_2p_Call00:
	smpsNoteFill        $00
	dc.b	nE6, $06
	smpsNoteFill        $06
	dc.b	nC6, $03, nA5, nC6, $06, nRst, nRst, $09
	smpsSetvoice        $04
	smpsNoteFill        $00
	dc.b	nC5, nA4, $06
	smpsNoteFill        $06
	smpsSetvoice        $03
	dc.b	nF6, $03, nF6, nRst, nF6, nRst, nF6
	smpsNoteFill        $00
	dc.b	nFs6, $06, nG6, nRst
	smpsNoteFill        $06
	dc.b	nG6, $03, $03, nA6, nG6
	smpsNoteFill        $00
	dc.b	nE6, $06
	smpsNoteFill        $06
	dc.b	nC6, $03, nA5, nC6, $06
	smpsNoteFill        $00
	smpsSetvoice        $04
	dc.b	nRst, $0F, nF5, $06, nF5, nC5, $03
	smpsReturn

; FM5 Data
EHZ_2p_FM5:
	smpsPan             panLeft, $01
	smpsSetvoice        $01
	dc.b	nRst, $30

EHZ_2p_Loop03:
	smpsNoteFill        $06
	dc.b	nRst, $06, nG5, $03, $09, $0C, nB5, $03, $09, $06, nRst, nA5
	dc.b	$03, $09, $0C, nB5, $03, $09, $06
	smpsLoop            $00, $04, EHZ_2p_Loop03

EHZ_2p_Loop04:
	dc.b	nRst, $06, nC6, $03, $09, $03, $09, $03, $09, $03, $03, nRst
	dc.b	$06, nBb5, $03, $09, $03, $09, $03, $09, $03, $03
	smpsLoop            $00, $03, EHZ_2p_Loop04
	dc.b	nRst, $06, nA5, $03, $09, $03, $09, $03, $09, $03, $03, nRst
	dc.b	$06, nD6, $03, $09, $03, $1B
	smpsJump            EHZ_2p_Loop03

; FM2 Data
EHZ_2p_FM2:
	smpsSetvoice        $03
	smpsNoteFill        $06
	dc.b	nRst, $1E, nG4, $03, $03, nA4, nC5, nC5, nA4
	smpsSetvoice        $00
	smpsAlterVol        $FA

EHZ_2p_Loop01:
	smpsNoteFill        $00
	dc.b	nRst, $06, nC4, nA3, $03, $03, nG3, $06, nRst, nB3, nA3, $03
	dc.b	$03, nG3, $06, nRst, nA3, nG3, $03, $03, nF3, $06, nRst, nG3
	dc.b	$06, $03, $03, nA3, nG3, nRst, $06, nC4, nA3, $03, $03, nG3
	dc.b	$06, nRst, nB3, nA3, $03, $03, nG3, $06
	smpsSetvoice        $04
	dc.b	nC5
	smpsSetvoice        $00
	dc.b	nA3, nG3, $03, $03, nF3, $06, nRst, nG3, $06, $03, $03, nA3
	dc.b	nG3
	smpsLoop            $00, $02, EHZ_2p_Loop01

EHZ_2p_Loop02:
	dc.b	nRst, $06, nF4, $03, $03, nD4, nD4, nC4, nC4, nRst, $06, nF4
	dc.b	$03, $03, nD4, nD4, nC4, nC4, nRst, $06, nEb4, $03, $03, nC4
	dc.b	nC4, nBb3, nBb3, nRst, $06, nEb4, $03, $03, nC4, nC4, nBb3, nBb3
	smpsLoop            $00, $03, EHZ_2p_Loop02
	dc.b	nRst, $06, nD4, $03, $03, nC4, nC4, nA3, nA3, nRst, $06, nD4
	dc.b	$03, $03, nC4, nC4, nA3, nA3, nG3, $06, $06, nA3, $03, nG3
	dc.b	nA3, $06, nG3, $18
	smpsJump            EHZ_2p_Loop01

; DAC Data
EHZ_2p_DAC:
	dc.b	dMidTom, $03, dMidTom, dMidTom, $06, dLowTom, $03, dLowTom, dLowTom, $06, dFloorTom, $03
	dc.b	dFloorTom, dFloorTom, $06, dLowTom, dFloorTom

EHZ_2p_Loop00:
	dc.b	dKick, dKick, dFloorTom, nRst, dKick, dKick, dFloorTom, nRst
	smpsLoop            $00, $0F, EHZ_2p_Loop00
	dc.b	dKick, dKick, dFloorTom, nRst, dMidTom, $03, dMidTom, dMidTom, $06, dLowTom, dFloorTom
	smpsJump            EHZ_2p_Loop00

; PSG1 Data
EHZ_2p_PSG1:
	dc.b	nRst, $02
	smpsPSGvoice        fTone_08
	smpsAlterVol        $04
	dc.b	nG6, $03, nF6, nE6, nD6, nF6, nE6, nD6, nC6, nE6, nD6, nC6
	dc.b	nB5, nC6, nB5, nA5, nG5, $01
	smpsAlterVol        $FC
	smpsAlterPitch      $04
	smpsJump            EHZ_2p_Loop06

; PSG2 Data
EHZ_2p_PSG2:
	dc.b	nRst, $30

EHZ_2p_Loop06:
	smpsNoteFill        $06
	dc.b	nRst, $06, nC5, $03, $09, $0C, nG5, $03, $09, $06, nRst, nF5
	dc.b	$03, $09, $0C, nG5, $03, $09, $06
	smpsLoop            $00, $04, EHZ_2p_Loop06
	smpsNoteFill        $00
	smpsPSGvoice        fTone_0B
	dc.b	nF5, $18, nF5, $0C, nF5, nEb5, nF5, $06, nEb5, $0C, nF5, $06
	dc.b	nEb5, $0C, nF5, $18, nF5, $0C, nF5, nEb5, $30, nF5, $18, nF5
	dc.b	$0C, nF5, nEb5, nF5, $06, nEb5, $0C, nF5, $06, nEb5, $0C, nF5
	dc.b	$18, nF5, $0C, nF5, nG5, $06, nRst, $2A
	smpsJump            EHZ_2p_Loop06

; PSG3 Data
EHZ_2p_PSG3:
	dc.b	nRst, $30

EHZ_2p_Jump02:
	smpsPSGvoice        fTone_04
	smpsPSGform         $E7
	smpsModSet          $00, $01, $01, $01
	dc.b	nMaxPSG, $03, nMaxPSG, nMaxPSG, $06
	smpsJump            EHZ_2p_Jump02

EHZ_2p_Voices:
;	Voice $00
;	$20
;	$66, $65, $60, $60, 	$DF, $DF, $9F, $1F, 	$00, $06, $09, $0C
;	$07, $06, $06, $08, 	$2F, $1F, $1F, $FF, 	$1C, $3A, $16, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $06, $06, $06, $06
	smpsVcCoarseFreq    $00, $00, $05, $06
	smpsVcRateScale     $00, $02, $03, $03
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0C, $09, $06, $00
	smpsVcDecayRate2    $08, $06, $06, $07
	smpsVcDecayLevel    $0F, $01, $01, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $16, $3A, $1C

;	Voice $01
;	$0D
;	$32, $08, $06, $01, 	$1F, $19, $19, $19, 	$0A, $05, $05, $05
;	$00, $02, $02, $02, 	$3F, $2F, $2F, $2F, 	$28, $80, $86, $8D
	smpsVcAlgorithm     $05
	smpsVcFeedback      $01
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $03
	smpsVcCoarseFreq    $01, $06, $08, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $19, $19, $19, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $05, $05, $0A
	smpsVcDecayRate2    $02, $02, $02, $00
	smpsVcDecayLevel    $02, $02, $02, $03
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $0D, $06, $00, $28

;	Voice $02
;	$3A
;	$61, $08, $51, $02, 	$5D, $5D, $5D, $50, 	$04, $0F, $1F, $1F
;	$00, $00, $00, $00, 	$1F, $5F, $0F, $0F, 	$22, $1E, $22, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $05, $00, $06
	smpsVcCoarseFreq    $02, $01, $08, $01
	smpsVcRateScale     $01, $01, $01, $01
	smpsVcAttackRate    $10, $1D, $1D, $1D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $0F, $04
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $05, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $22, $1E, $22

;	Voice $03
;	$02
;	$01, $55, $02, $04, 	$92, $8D, $8E, $54, 	$0D, $0C, $00, $03
;	$00, $00, $00, $00, 	$FF, $2F, $0F, $5F, 	$16, $2A, $1D, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $05, $00
	smpsVcCoarseFreq    $04, $02, $05, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $14, $0E, $0D, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $00, $0C, $0D
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $05, $00, $02, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $1D, $2A, $16

;	Voice $04
;	$02
;	$75, $71, $73, $31, 	$1F, $58, $96, $9F, 	$01, $1B, $03, $08
;	$01, $04, $01, $05, 	$FF, $2F, $3F, $2F, 	$24, $29, $30, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $07, $07, $07
	smpsVcCoarseFreq    $01, $03, $01, $05
	smpsVcRateScale     $02, $02, $01, $00
	smpsVcAttackRate    $1F, $16, $18, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $03, $1B, $01
	smpsVcDecayRate2    $05, $01, $04, $01
	smpsVcDecayLevel    $02, $03, $02, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $30, $29, $24

