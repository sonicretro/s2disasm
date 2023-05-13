Sound69_DrawbridgeDown_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound69_DrawbridgeDown_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, Sound69_DrawbridgeDown_FM5,	$F4, $00
	smpsHeaderSFXChannel cPSG3, Sound69_DrawbridgeDown_PSG3,	$00, $00

; FM5 Data
Sound69_DrawbridgeDown_FM5:
	smpsSetvoice        $00
	dc.b	nD2, $03, nEb3, $06, nF2, $08
	smpsStop

; PSG3 Data
Sound69_DrawbridgeDown_PSG3:
	smpsPSGvoice        fTone_04
	smpsPSGform         $E7
	dc.b	nMaxPSG, $03, nMaxPSG, $06, nMaxPSG, $08
	smpsStop

Sound69_DrawbridgeDown_Voices:
;	Voice $00
;	$3C
;	$00, $00, $00, $00, 	$1F, $1F, $1F, $1F, 	$00, $16, $0F, $0F
;	$00, $00, $00, $00, 	$0F, $AF, $FF, $FF, 	$00, $80, $0A, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0F, $0F, $16, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $0F, $0A, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $0A, $00, $00

