Sound55_SlidingSpike_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound55_SlidingSpike_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound55_SlidingSpike_FM5,	$00, $00

; FM5 Data
Sound55_SlidingSpike_FM5:
	smpsSetvoice        $00
	dc.b	nF3, $07, nF4, $15
	smpsStop

Sound55_SlidingSpike_Voices:
;	Voice $00
;	$42
;	$20, $0F, $0E, $0F, 	$1F, $1F, $1F, $1F, 	$1F, $1F, $1F, $1F
;	$0F, $0F, $0E, $0E, 	$0F, $0F, $0F, $0F, 	$2E, $20, $80, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $00
	smpsVcUnusedBits    $01
	smpsVcDetune        $00, $00, $00, $02
	smpsVcCoarseFreq    $0F, $0E, $0F, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1F, $1F
	smpsVcDecayRate2    $0E, $0E, $0F, $0F
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $80, $20, $2E

