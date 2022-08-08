Sound53_Signpost2P_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     Sound53_Signpost2P_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound53_Signpost2P_FM5,	$F5, $03

; FM5 Data
Sound53_Signpost2P_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $46, $09
	dc.b	nD3, $14, smpsNoAttack, $14, smpsNoAttack
	smpsAlterVol        $04
	dc.b	$14, smpsNoAttack
	smpsAlterVol        $04
	dc.b	$14, smpsNoAttack
	smpsAlterVol        $04
	dc.b	$0A, smpsNoAttack
	smpsAlterVol        $04
	dc.b	$0A
	smpsStop

Sound53_Signpost2P_Voices:
;	Voice $00
;	$07
;	$0A, $0C, $0C, $0C, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$FF, $FF, $FF, $FF, 	$2A, $0F, $0F, $80
	smpsVcAlgorithm     $07
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $0C, $0C, $0C, $0A
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $0F, $0F, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $0F, $0F, $2A

