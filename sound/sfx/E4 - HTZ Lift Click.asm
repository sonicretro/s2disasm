Sound64_HTZLiftClick_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound64_HTZLiftClick_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound64_HTZLiftClick_FM5,	$11, $00

; FM5 Data
Sound64_HTZLiftClick_FM5:
	smpsSetvoice        $00
	dc.b	nBb5, $02
	smpsStop

Sound64_HTZLiftClick_Voices:
;	Voice $00
;	$24
;	$2A, $05, $02, $01, 	$1A, $10, $1F, $1F, 	$0F, $1F, $1F, $1F
;	$0C, $11, $0D, $11, 	$0C, $09, $09, $0F, 	$0E, $80, $04, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $02
	smpsVcCoarseFreq    $01, $02, $05, $0A
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $10, $1A
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1F, $0F
	smpsVcDecayRate2    $11, $0D, $11, $0C
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $09, $09, $0C
	smpsVcTotalLevel    $00, $04, $00, $0E

