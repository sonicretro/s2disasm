CNZ_2p_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     CNZ_2p_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $BD

	smpsHeaderDAC       CNZ_2p_DAC
	smpsHeaderFM        CNZ_2p_FM1,	$F4, $06
	smpsHeaderFM        CNZ_2p_FM2,	$F4, $0D
	smpsHeaderFM        CNZ_2p_FM3,	$F4, $10
	smpsHeaderFM        CNZ_2p_FM4,	$E8, $0E
	smpsHeaderFM        CNZ_2p_FM5,	$F4, $10
	smpsHeaderPSG       CNZ_2p_PSG1,	$D0, $04, $00, $00
	smpsHeaderPSG       CNZ_2p_PSG2,	$D0, $04, $00, $00
	smpsHeaderPSG       CNZ_2p_PSG3,	$C4, $05, $00, $00

; FM1 Data
CNZ_2p_FM1:
	smpsSetvoice        $00
	dc.b	nA3, $06, nRst, nA3, nRst, nB3, nRst, nB3, nRst, nC4, nRst, nC4
	dc.b	nRst, nCs4, nRst, nCs4, nRst

CNZ_2p_Loop0B:
	dc.b	nD3, $09, nA3, $03, nD4, $06, nRst, nC4, nRst, nB3, $0C, nC4
	dc.b	$06, nRst, $2A, nG3, $06, nRst, nG3, nRst, nA3, nRst, nA3, nRst
	dc.b	nBb3, nRst, $2A
	smpsLoop            $00, $02, CNZ_2p_Loop0B
	smpsCall            CNZ_2p_Call0C
	dc.b	nD3, $0C, nD4, $06, nRst, nC4, nRst, nD4, $0C, nD3, $03, nRst
	dc.b	$06, nD3, $03, nD4, $0C, nC4, nD4, nG3, $06, nRst, nG3, $0C
	dc.b	nA3, $06, nRst, nA3, $0C, nBb3, $06, nRst, $2A
	smpsCall            CNZ_2p_Call0C
	dc.b	nD3, $0C, nD4, $06, nRst, nC4, nRst, nD4, $0C, nD3, $03, nRst
	dc.b	$06, nD3, $03, nD4, $0C, nC4, nD4, $09, nA4, $03, nG3, $06
	dc.b	nRst, nG3, $0C, nA3, $06, nRst, nA3, $0C, nBb3, $06, nRst, $2A
	smpsAlterVol        $FE

CNZ_2p_Loop0C:
	dc.b	nC4, $06, nRst, nC4, nRst, nB3, nRst, nBb3, nRst, nA3, nRst, nA3
	dc.b	nRst, nE4, nRst, nA3, nRst, nD4, nRst, nA3, nRst, nC4, nRst, nCs4
	dc.b	nRst, nD4, $09, nD4, $03, nA3, $06, nRst, nC4, nRst, nD4, nRst
	smpsLoop            $00, $03, CNZ_2p_Loop0C
	dc.b	nC4, $06, nRst, nC4, nRst, nB3, nRst, nBb3, nRst, nA3, nRst, nA3
	dc.b	nRst, nE4, nRst, nA3, nRst, nRst, $09, nD3, $03, nD4, $0C, nD3
	dc.b	nD4, $06, nRst, $03, nD3, $06, nRst, $2D
	smpsAlterVol        $02
	smpsJump            CNZ_2p_Loop0B

CNZ_2p_Call0C:
	dc.b	nD3, $0C, nD4, $06, nRst, nC4, nRst, nD4, $0C, nD3, $03, nRst
	dc.b	$06, nD3, $03, nD4, $0C, nC4, nD4, $09, nA3, $03, nG3, $06
	dc.b	nRst, nG3, $0C, nA3, $06, nRst, nA3, $0C, nBb3, $06, nRst, $27
	dc.b	nC4, $03
	smpsReturn

; FM2 Data
CNZ_2p_FM2:
	smpsSetvoice        $01
	smpsCall            CNZ_2p_Call05

CNZ_2p_Loop08:
	smpsCall            CNZ_2p_Call06
	smpsLoop            $00, $02, CNZ_2p_Loop08
	smpsSetvoice        $03
	smpsAlterNote       $02
	smpsAlterVol        $07

CNZ_2p_Loop09:
	smpsCall            CNZ_2p_Call07
	smpsLoop            $00, $02, CNZ_2p_Loop09

CNZ_2p_Loop0A:
	smpsCall            CNZ_2p_Call08
	smpsLoop            $00, $02, CNZ_2p_Loop0A
	smpsSetvoice        $01
	smpsAlterNote       $00
	smpsAlterVol        $F9
	smpsCall            CNZ_2p_Call0A
	smpsCall            CNZ_2p_Call0B
	smpsJump            CNZ_2p_Loop08

CNZ_2p_Call0A:
	dc.b	nRst, $09, nG6, $0F, nE6, $06, nRst, nC6, nRst, nF6, $18, nE6
	dc.b	nD6, $06, nRst, nD6, nRst, nC6, $09, nD6, $06, nRst, nA5, $33
	dc.b	nRst, $09, nG6, $0F, nE6, $06, nRst, nC6, nRst, nF6, $18, nE6
	dc.b	nRst, $0C, nD6, $06, nRst, nE6, $09, nD6, $06, nRst, nF6, $33
	smpsReturn

CNZ_2p_Call0B:
	dc.b	nRst, $09, nG6, $0F, nE6, $06, nRst, nC6, nRst, nF6, $18, nE6
	dc.b	nD6, $06, nRst, nD6, nRst, nC6, $09, nD6, $06, nRst, nA5, $33
	dc.b	nRst, $09, nG6, $0F, nE6, $06, nRst, nC6, nRst, nF6, $18, nE6
	dc.b	nRst, $09, nD6, $0F, nF6, $06, nRst, nE6, nRst, $03, nD6, $06
	dc.b	nRst, $2D
	smpsReturn

CNZ_2p_Call05:
	dc.b	nA6, $06, nRst, $12, nA6, $15, nE6, $03, nA6, $06, nRst, nG6
	dc.b	nRst, nF6, nRst, nE6, nRst
	smpsReturn

CNZ_2p_Call06:
	dc.b	nC6, $09, nD6, $06, nRst, nD6, nRst, nD6, $03, nC6, $0C, nF6
	dc.b	$06, nRst, nD6, $24, nRst, $60
	smpsReturn

; FM3 Data
CNZ_2p_FM3:
	smpsSetvoice        $02
	dc.b	nRst, $60

CNZ_2p_Loop06:
	dc.b	nRst, $60, $3C, nF6, $09, nE6, $03, nF6, $09, nE6, $03
	dc.b	nF6, $06, nRst
	smpsLoop            $00, $02, CNZ_2p_Loop06
	smpsAlterVol        $04
	smpsPan             panRight, $00

CNZ_2p_Loop07:
	dc.b	nRst, $60, $30, nA5, $06, nRst, nF5, $0C, nG5, $09, nF5
	dc.b	$03, nD5, $0C, nRst, $60, $30, nA5, $06, nRst, nF5, $0C
	dc.b	nG5, $09, nA5, $03, nRst, $0C
	smpsLoop            $00, $02, CNZ_2p_Loop07
	smpsAlterVol        $FC
	smpsPan             panCenter, $00
	smpsSetvoice        $01
	smpsAlterNote       $02
	smpsAlterPitch      $F4
	smpsAlterVol        $FF
	smpsCall            CNZ_2p_Call0A
	smpsCall            CNZ_2p_Call0B
	smpsSetvoice        $02
	smpsAlterNote       $00
	smpsAlterPitch      $0C
	smpsAlterVol        $01
	smpsJump            CNZ_2p_Loop06

; FM4 Data
CNZ_2p_FM4:
	smpsSetvoice        $01
	smpsAlterNote       $02
	smpsCall            CNZ_2p_Call05

CNZ_2p_Loop03:
	smpsCall            CNZ_2p_Call06
	smpsLoop            $00, $02, CNZ_2p_Loop03
	smpsSetvoice        $03
	smpsAlterNote       $00
	smpsAlterPitch      $0C
	smpsAlterVol        $04
	smpsModSet          $01, $01, $03, $03

CNZ_2p_Loop04:
	smpsCall            CNZ_2p_Call07
	smpsLoop            $00, $02, CNZ_2p_Loop04

CNZ_2p_Loop05:
	smpsCall            CNZ_2p_Call08
	smpsLoop            $00, $02, CNZ_2p_Loop05
	smpsSetvoice        $01
	smpsCall            CNZ_2p_Call09
	dc.b	nEb5, $03, smpsNoAttack, nE5, $2D, nEb5, $03, smpsNoAttack, nE5, $2D
	smpsPan             panLeft, $00
	dc.b	nRst, $0C, nF5, $06, nRst, nG5, $09, nF5, $06, nRst, nA5, $2D
	dc.b	nRst, $06
	smpsCall            CNZ_2p_Call09
	dc.b	nEb5, $03, smpsNoAttack, nE5, $2D, nEb5, $03, smpsNoAttack, nE5, $2D
	smpsPan             panLeft, $00
	dc.b	nRst, $09, nF5, nRst, $06, nF5, $09, nRst, $0C, nF5, $06, nRst
	dc.b	$2D
	smpsAlterNote       $02
	smpsAlterPitch      $F4
	smpsAlterVol        $FC
	smpsPan             panCenter, $00
	smpsModOff
	smpsJump            CNZ_2p_Loop03

CNZ_2p_Call09:
	smpsPan             panCenter, $00
	dc.b	nEb5, $03, smpsNoAttack, nE5, $2D, nEb5, $03, smpsNoAttack, nE5, $2D
	smpsPan             panLeft, $00
	dc.b	nF5, $06, nRst, nF5, nRst, nE5, $09, nF5, $06, nRst, nF5, $0C
	dc.b	nE5, $03, nF5, $06, nRst, nE5, $09, nF5, $06, nRst, $09
	smpsPan             panCenter, $00
	smpsReturn

CNZ_2p_Call07:
	dc.b	nF6, $15, nE6, $03, nD6, $06, nRst, nC6, $0C, nE6, $06, nRst
	dc.b	nC6, $0C, nD6, $06, nRst, $12, nRst, $60
	smpsReturn

CNZ_2p_Call08:
	dc.b	nA6, $15, nG6, $03, nF6, $06, nRst, nE6, $0C, nG6, $06, nRst
	dc.b	nE6, $0C, nF6, $06, nRst, $12, nRst, $60
	smpsReturn

; FM5 Data
CNZ_2p_FM5:
	smpsSetvoice        $02
	dc.b	nRst, $60
	smpsPan             panRight, $00

CNZ_2p_Loop02:
	dc.b	nRst, $60, nRst, $3C, nD6, $09, nC6, $03, nD6, $09, nC6, $03
	dc.b	nD6, $06, nRst
	smpsLoop            $00, $02, CNZ_2p_Loop02
	smpsSetvoice        $04
	smpsPan             panCenter, $00
	dc.b	nRst, $60
	smpsCall            CNZ_2p_Call01
	dc.b	nRst, $60
	smpsCall            CNZ_2p_Call02
	smpsSetvoice        $03
	smpsAlterVol        $02
	smpsPan             panLeft, $00
	smpsModSet          $01, $01, $03, $03
	smpsCall            CNZ_2p_Call03
	smpsSetvoice        $04
	smpsAlterVol        $FC
	smpsPan             panCenter, $00
	smpsCall            CNZ_2p_Call01
	smpsSetvoice        $03
	smpsPan             panLeft, $00
	smpsAlterVol        $04
	smpsCall            CNZ_2p_Call03
	smpsSetvoice        $04
	smpsAlterVol        $FC
	smpsPan             panCenter, $00
	smpsCall            CNZ_2p_Call02
	smpsAlterVol        $04
	smpsSetvoice        $01
	smpsCall            CNZ_2p_Call04
	dc.b	nB4, $03, smpsNoAttack, nC5, $2D, nC5, $03, smpsNoAttack, nCs5, $2D
	smpsPan             panRight, $00
	dc.b	nRst, $0C, nD5, $06, nRst, nE5, $09, nD5, $03, nRst, $09, nF5
	dc.b	$2D, nRst, $06
	smpsCall            CNZ_2p_Call04
	dc.b	nB4, $03, smpsNoAttack, nC5, $2D, nC5, $03, smpsNoAttack, nCs5, $2D
	smpsPan             panRight, $00
	dc.b	nRst, $09, nD5, nRst, $06, nD5, $09, nRst, $0C, nD5, $06, nRst
	dc.b	$2D
	smpsSetvoice        $02
	smpsPan             panRight, $00
	smpsAlterVol        $FE
	smpsModOff
	smpsJump            CNZ_2p_Loop02

CNZ_2p_Call04:
	smpsPan             panCenter, $00
	dc.b	nB4, $03, smpsNoAttack, nC5, $2D, nC5, $03, smpsNoAttack, nCs5, $2D
	smpsPan             panRight, $00
	dc.b	nD5, $06, nRst, nD5, nRst, nC5, $09, nD5, $06, nRst, nD5, $0C
	dc.b	nC5, $03, nD5, $06, nRst, nC5, $09, nD5, $06, nRst, $09
	smpsPan             panCenter, $00
	smpsReturn

CNZ_2p_Call01:
	dc.b	nG3, $06, nRst, nG3, $0C, nA3, $06, nRst, nA3, $0C, nBb3, $06
	dc.b	nRst, $27, nC4, $03
	smpsReturn

CNZ_2p_Call03:
	dc.b	nF6, $15, nE6, $03, nD6, $06, nRst, nC6, $0C, nE6, $06, nRst
	dc.b	nC6, $0C, nD6, $06, nRst, $12
	smpsReturn

CNZ_2p_Call02:
	dc.b	nG3, $06, nRst, nG3, $0C, nA3, $06, nRst, nA3, $0C, nBb3, $06
	dc.b	nRst, $2A
	smpsReturn

; PSG1 Data
CNZ_2p_PSG1:
	dc.b	nRst, $60
	smpsNoteFill        $06

CNZ_2p_Loop10:
	dc.b	nRst, $0C, nF5, nRst, nF5, nRst, nF5, nRst, nF5, nRst, nD5, nRst
	dc.b	nD5, nRst, nD5, nRst, nD5
	smpsLoop            $00, $02, CNZ_2p_Loop10
	dc.b	nRst, $60, nRst, $0C, nF5, nRst, nF5, nRst, nF5, nRst, nF5, nRst
	dc.b	$60, nRst, $0C, nF5, nRst, nF5, nRst, nF5, $04, nRst, nF5, nRst
	dc.b	$0C, nF5

CNZ_2p_Loop11:
	dc.b	nRst, $60, nRst, $0C, nF5, nRst, nF5, nRst, nF5, nRst, nF5
	smpsLoop            $00, $02, CNZ_2p_Loop11

CNZ_2p_Loop12:
	dc.b	nRst, $0C, nC6, nRst, nC6, nRst, nCs6, nRst, nCs6, nRst, nD6, nRst
	dc.b	nD6, nRst, nD6, nRst, nD6
	smpsLoop            $00, $03, CNZ_2p_Loop12
	dc.b	nRst, $0C, nC6, nRst, nC6, nRst, nCs6, nRst, nCs6, nRst, $60
	smpsJump            CNZ_2p_Loop10

; PSG2 Data
CNZ_2p_PSG2:
	dc.b	nRst, $60
	smpsNoteFill        $06

CNZ_2p_Loop0D:
	dc.b	nRst, $0C, nD5, nRst, nD5, nRst, nD5, nRst, nD5, nRst, nBb4, nRst
	dc.b	nBb4, nRst, nBb4, nRst, nBb4
	smpsLoop            $00, $02, CNZ_2p_Loop0D
	dc.b	nRst, $60, nRst, $0C, nD5, nRst, nD5, nRst, nD5, nRst, nD5, nRst
	dc.b	$60, nRst, $0C, nD5, nRst, nD5, nRst, nD5, $04, nRst, nD5, nRst
	dc.b	$0C, nD5

CNZ_2p_Loop0E:
	dc.b	nRst, $60, nRst, $0C, nD5, nRst, nD5, nRst, nD5, nRst, nD5
	smpsLoop            $00, $02, CNZ_2p_Loop0E

CNZ_2p_Loop0F:
	dc.b	nRst, $0C, nA5, nRst, nA5, nRst, nA5, nRst, nA5, nRst, nA5, nRst
	dc.b	nA5, nRst, nA5, nRst, nA5
	smpsLoop            $00, $03, CNZ_2p_Loop0F
	dc.b	nRst, $0C, nA5, nRst, nA5, nRst, nA5, nRst, nA5, nRst, $60
	smpsJump            CNZ_2p_Loop0D

; PSG3 Data
CNZ_2p_PSG3:
	smpsJump            CNZ_2p_PSG1

; DAC Data
CNZ_2p_DAC:
	dc.b	nRst, $0C, dSnare, dKick, dSnare, dSnare, dSnare, dSnare, dSnare

CNZ_2p_Loop00:
	smpsCall            CNZ_2p_Call00
	smpsLoop            $00, $03, CNZ_2p_Loop00
	dc.b	dKick, $09, dKick, $03, $0C, dSnare, dKick, dKick, $15, dSnare, $03, $18

CNZ_2p_Loop01:
	smpsCall            CNZ_2p_Call00
	smpsLoop            $00, $0F, CNZ_2p_Loop01
	dc.b	nRst, $09, dKick, $0F, dSnare, $0C, dKick, $09, dSnare, $1B, $0C, $09
	dc.b	$03
	smpsJump            CNZ_2p_Loop00

CNZ_2p_Call00:
	dc.b	dKick, $09, dKick, $03, $0C, dSnare, dKick, dKick, $18, dSnare
	smpsReturn

CNZ_2p_Voices:
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

;	Voice $04
;	$20
;	$7A, $31, $00, $00, 	$9F, $D8, $DC, $DF, 	$10, $0A, $04, $04
;	$0F, $08, $08, $08, 	$5F, $5F, $BF, $BF, 	$14, $2B, $17, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $03, $07
	smpsVcCoarseFreq    $00, $00, $01, $0A
	smpsVcRateScale     $03, $03, $03, $02
	smpsVcAttackRate    $1F, $1C, $18, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $04, $0A, $10
	smpsVcDecayRate2    $08, $08, $08, $0F
	smpsVcDecayLevel    $0B, $0B, $05, $05
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $17, $2B, $14

