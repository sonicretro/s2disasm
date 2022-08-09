Sound2E_LavaBall_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound2E_33_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, Sound2E_LavaBall_FM5,	$00, $00
	smpsHeaderSFXChannel cPSG3, Sound2E_LavaBall_PSG3,	$00, $00

; FM5 Data
Sound2E_LavaBall_FM5:
	smpsSetvoice        $00
	dc.b	nRst, $01
	smpsModSet          $01, $01, $40, $48
	dc.b	nD0, $06, nE0, $02
	smpsStop

; PSG3 Data
Sound2E_LavaBall_PSG3:
	smpsPSGvoice        $00
	dc.b	nRst, $0B
	smpsPSGform         $E7
	dc.b	nMaxPSG, $01, smpsNoAttack

Sound2E_LavaBall_Loop00:
	dc.b	$02
	smpsPSGAlterVol     $01
	dc.b	smpsNoAttack
	smpsLoop            $00, $10, Sound2E_LavaBall_Loop00
	smpsStop

Sound2E_33_Voices:
;	Voice $00
;	$FA
;	$02, $03, $00, $05, 	$12, $11, $0F, $13, 	$05, $18, $09, $02
;	$06, $0F, $06, $02, 	$1F, $2F, $4F, $2F, 	$2F, $1A, $0E, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $03
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $05, $00, $03, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $13, $0F, $11, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $02, $09, $18, $05
	smpsVcDecayRate2    $02, $06, $0F, $06
	smpsVcDecayLevel    $02, $04, $02, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $0E, $1A, $2F

