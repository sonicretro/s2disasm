Sound5B_PreArrowFiring_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound5B_PreArrowFiring_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound5B_PreArrowFiring_FM5,	$00, $00

; FM5 Data
Sound5B_PreArrowFiring_FM5:
	smpsSetvoice        $00
	dc.b	nRst, $02, nC3, $01, smpsNoAttack

Sound5B_PreArrowFiring_Loop00:
	dc.b	$01, smpsNoAttack
	smpsAlterVol        $02
	smpsLoop            $00, $05, Sound5B_PreArrowFiring_Loop00
	smpsStop

Sound5B_PreArrowFiring_Voices:
;	Voice $00
;	$38
;	$0F, $0F, $0F, $0F, 	$1F, $1F, $1F, $0E, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $1F, 	$00, $00, $00, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $0F, $0F, $0F, $0F
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0E, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $00, $00, $00

