Sound6D_Error_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     Sound6D_Error_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound6D_Error_FM5,	$00, $04

; FM5 Data
Sound6D_Error_FM5:
	smpsSetvoice        $00
	dc.b	nB3, $06, nRst, $06, nB3, $18
	smpsStop

Sound6D_Error_Voices:
;	Voice $00
;	$38
;	$00, $00, $00, $00, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$1F, $17, $0C, $00
	smpsVcAlgorithm     $00
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $0C, $17, $1F

