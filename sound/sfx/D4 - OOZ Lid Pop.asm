Sound54_OOZLidPop_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     Sound54_OOZLidPop_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, Sound54_OOZLidPop_FM5,	$00, $00
	smpsHeaderSFXChannel cPSG3, Sound54_OOZLidPop_PSG3,	$00, $06

; FM5 Data
Sound54_OOZLidPop_FM5:
	smpsSetvoice        $00
	dc.b	nF4, $15
	smpsStop

; PSG3 Data
Sound54_OOZLidPop_PSG3:
	smpsPSGform         $E7
	smpsPSGvoice        fTone_04
	dc.b	nMaxPSG, $03, smpsNoAttack, nAb5, smpsNoAttack, nG5, smpsNoAttack, nFs5, smpsNoAttack, nF5, smpsNoAttack, nE5
	dc.b	smpsNoAttack, nEb5
	smpsStop

Sound54_OOZLidPop_Voices:
;	Voice $00
;	$07
;	$03, $03, $02, $00, 	$FF, $6F, $6F, $3F, 	$12, $11, $14, $0E
;	$1A, $03, $0A, $0D, 	$FF, $FF, $FF, $FF, 	$03, $07, $07, $80
	smpsVcAlgorithm     $07
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $02, $03, $03
	smpsVcRateScale     $00, $01, $01, $03
	smpsVcAttackRate    $3F, $2F, $2F, $3F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0E, $14, $11, $12
	smpsVcDecayRate2    $0D, $0A, $03, $1A
	smpsVcDecayLevel    $0F, $0F, $0F, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $07, $07, $03

