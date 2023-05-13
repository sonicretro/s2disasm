Invincible_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Invincible_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $E8

	smpsHeaderDAC       Invincible_DAC
	smpsHeaderFM        Invincible_FM1,	$F4, $11
	smpsHeaderFM        Invincible_FM2,	$F4, $09
	smpsHeaderFM        Invincible_FM3,	$E8, $0F
	smpsHeaderFM        Invincible_FM4,	$E8, $0F
	smpsHeaderFM        Invincible_FM5,	$F4, $11
	smpsHeaderPSG       Invincible_PSG1,	$F4, $02, $00, fTone_08
	smpsHeaderPSG       Invincible_PSG2,	$DC, $05, $00, fTone_05
	smpsHeaderPSG       Invincible_PSG3,	$00, $03, $00, fTone_04

; FM5 Data
Invincible_FM5:
	smpsAlterNote       $03

; FM1 Data
Invincible_FM1:
	dc.b	nRst, $30
	smpsSetvoice        $00

Invincible_Loop07:
	dc.b	nRst, $0C, nCs6, $15, nRst, $03, nCs6, $06, nRst, nD6, $0F, nRst
	dc.b	$03, nB5, $18, nRst, $06, nCs6, $06, nRst, nCs6, nRst, nCs6, nRst
	dc.b	nA5, nRst, nG5, $0F, nRst, $03, nB5, $18, nRst, $06
	smpsLoop            $00, $02, Invincible_Loop07
	smpsAlterVol        $FD
	dc.b	nRst, $30, nRst, nA5, $04, nB5, nCs6, nD6, nE6, nFs6, nB5, nCs6
	dc.b	nEb6, nE6, nFs6, nAb6, nCs6, nEb6, nF6, nFs6, nAb6, nBb6, nF6, nFs6
	dc.b	nAb6, nBb6, nC7, nCs7
	smpsAlterVol        $03
	smpsJump            Invincible_Loop07

; FM2 Data
Invincible_FM2:
	smpsNop             $01
	smpsSetvoice        $01
	dc.b	nRst, $30

Invincible_Loop05:
	dc.b	nA3, $06, nRst, nA3, nRst, nE3, nRst, nE3, nRst, nG3, $12, nFs3
	dc.b	$0C, nG3, $06, nFs3, $0C, nA3, $06, nRst, nA3, nRst, nE3, nRst
	dc.b	nE3, nRst, nD4, $12, nCs4, $0C, nD4, $06, nCs4, $0C
	smpsLoop            $00, $02, Invincible_Loop05

Invincible_Loop06:
	dc.b	nB2, $06, nG2, $12, nA2, $06, nRst, nB2, nRst
	smpsLoop            $00, $02, Invincible_Loop06
	dc.b	nA2, $0C, nB2, nCs3, nEb3, nB2, $06, nCs3, nEb3, nF3, nCs3, nEb3
	dc.b	nF3, nFs3
	smpsNop             $01
	smpsJump            Invincible_Loop05

; FM3 Data
Invincible_FM3:
	smpsSetvoice        $00
	dc.b	nRst, $30

Invincible_Loop03:
	dc.b	nE6, $06, nRst, nE6, nRst, nCs6, nRst, nCs6, nRst, nD6, $12, nFs6
	dc.b	nA6, $0C, nE6, $06, nRst, nE6, nRst, nCs6, nRst, nCs6, nRst, nG6
	dc.b	$12, nG6, $1E
	smpsLoop            $00, $02, Invincible_Loop03

Invincible_Loop04:
	dc.b	nRst, $06, nG5, $12, nA5, $06, nRst, $12
	smpsLoop            $00, $04, Invincible_Loop04
	smpsJump            Invincible_Loop03

; FM4 Data
Invincible_FM4:
	smpsSetvoice        $00
	dc.b	nRst, $30

Invincible_Loop01:
	dc.b	nCs6, $06, nRst, nCs6, nRst, nA5, nRst, nA5, nRst, nB5, $12, nD6
	dc.b	nFs6, $0C, nCs6, $06, nRst, nCs6, nRst, nA5, nRst, nA5, nRst, nD6
	dc.b	$12, nD6, $1E
	smpsLoop            $00, $02, Invincible_Loop01

Invincible_Loop02:
	dc.b	nRst, $06, nB5, $12, nCs6, $06, nRst, $12
	smpsLoop            $00, $04, Invincible_Loop02
	smpsJump            Invincible_Loop01

; PSG1 Data
Invincible_PSG1:
; PSG2 Data
Invincible_PSG2:
	smpsStop

; PSG3 Data
Invincible_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $30

Invincible_Jump00:
	smpsNoteFill        $03
	dc.b	nMaxPSG, $0C
	smpsNoteFill        $0C
	dc.b	$0C
	smpsNoteFill        $03
	dc.b	$0C
	smpsNoteFill        $0C
	dc.b	$0C
	smpsJump            Invincible_Jump00

; DAC Data
Invincible_DAC:
	dc.b	dSnare, $06, dSnare, dKick, dKick, dSnare, dSnare, dSnare, dSnare

Invincible_Loop00:
	dc.b	dKick, $0C, dSnare, dKick, dSnare, dKick, $0C, dSnare, dKick, dSnare, dKick, $0C
	dc.b	dSnare, dKick, dSnare, dKick, $0C, dSnare, dKick, $04, nRst, dSnare, dSnare, $0C
	smpsLoop            $00, $02, Invincible_Loop00
	dc.b	dKick, $06, dSnare, $12, dKick, $0C, dSnare, dSnare, $06, dKick, $12, dKick
	dc.b	$0C, dSnare, dSnare, $06, dKick, $0C, dSnare, $06, dKick, $0C, dSnare, dSnare
	dc.b	$04, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare, dSnare
	smpsJump            Invincible_Loop00

	; Unreachable
	smpsStop

Invincible_Voices:
;	Voice $00
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

;	Voice $01
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

