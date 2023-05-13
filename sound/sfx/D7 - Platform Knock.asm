Sound57_PlatformKnock_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     Sound57_PlatformKnock_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound57_PlatformKnock_FM5,	$00, $00

; FM5 Data
Sound57_PlatformKnock_FM5:
	smpsSetvoice        $00
	dc.b	nCs6, $15
	smpsStop

Sound57_PlatformKnock_Voices:
;	Voice $00
;	$04
;	$09, $00, $70, $30, 	$1C, $DF, $1F, $1F, 	$15, $0B, $12, $0F
;	$0C, $00, $0D, $0D, 	$07, $FA, $2F, $FA, 	$00, $00, $29, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $07, $00, $00
	smpsVcCoarseFreq    $00, $00, $00, $09
	smpsVcRateScale     $00, $00, $03, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1C
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0F, $12, $0B, $15
	smpsVcDecayRate2    $0D, $0D, $00, $0C
	smpsVcDecayLevel    $0F, $02, $0F, $00
	smpsVcReleaseRate   $0A, $0F, $0A, $07
	smpsVcTotalLevel    $00, $29, $00, $00

