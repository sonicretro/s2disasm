Sound5D_ArrowStick_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound5D_ArrowStick_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound5D_ArrowStick_FM5,	$00, $00

; FM5 Data
Sound5D_ArrowStick_FM5:
	smpsSetvoice        $00
	dc.b	nEb5, $04
	smpsStop

Sound5D_ArrowStick_Voices:
;	Voice $00
;	$28
;	$2F, $5F, $37, $2B, 	$1F, $1F, $1F, $1F, 	$15, $15, $15, $13
;	$13, $0C, $0D, $10, 	$2F, $2F, $3F, $2F, 	$00, $10, $1F, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $02, $03, $05, $02
	smpsVcCoarseFreq    $0B, $07, $0F, $0F
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $13, $15, $15, $15
	smpsVcDecayRate2    $10, $0D, $0C, $13
	smpsVcDecayLevel    $02, $03, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $1F, $10, $00

