Sound27_Sparkle_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     Sound27_Sparkle_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM4, Sound27_Sparkle_FM4,	$0C, $1C

; FM4 Data
Sound27_Sparkle_FM4:
	smpsSetvoice        $00
	dc.b	nE5, $05, nG5, $05, nC6, $2B
	smpsStop

Sound27_Sparkle_Voices:
;	Voice $00
;	$07
;	$73, $33, $33, $73, 	$0F, $14, $19, $1A, 	$0A, $0A, $0A, $0A
;	$0A, $0A, $0A, $0A, 	$57, $57, $57, $57, 	$00, $00, $00, $00
	smpsVcAlgorithm     $07
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $03, $07
	smpsVcCoarseFreq    $03, $03, $03, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1A, $19, $14, $0F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0A, $0A, $0A
	smpsVcDecayRate2    $0A, $0A, $0A, $0A
	smpsVcDecayLevel    $05, $05, $05, $05
	smpsVcReleaseRate   $07, $07, $07, $07
	smpsVcTotalLevel    $00, $00, $00, $00

