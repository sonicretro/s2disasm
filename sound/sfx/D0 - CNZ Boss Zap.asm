Sound50_CNZBossZap_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound50_CNZBossZap_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound50_CNZBossZap_FM5,	$F4, $00

; FM5 Data
Sound50_CNZBossZap_FM5:
	smpsSetvoice        $00
	dc.b	nD4, $04, nRst, $01

Sound50_CNZBossZap_Loop00:
	dc.b	nEb4, $04, nRst, $01
	smpsLoop            $00, $04, Sound50_CNZBossZap_Loop00
	smpsStop

Sound50_CNZBossZap_Voices:
;	Voice $00
;	$83
;	$12, $10, $13, $1E, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$02, $02, $02, $02, 	$2F, $2F, $FF, $3F, 	$06, $10, $34, $87
	smpsVcAlgorithm     $03
	smpsVcFeedback      $00
	smpsVcUnusedBits    $02
	smpsVcDetune        $01, $01, $01, $01
	smpsVcCoarseFreq    $0E, $03, $00, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $02, $02, $02, $02
	smpsVcDecayLevel    $03, $0F, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $07, $34, $10, $06

