Sound60_SpindashRev_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     Sound60_SpindashRev_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound60_SpindashRev_FM5,	$FE, $00

; FM5 Data
Sound60_SpindashRev_FM5:
	smpsSetvoice        $00
	smpsModSet          $00, $01, $20, $F6
	dc.b	nG5, $16, smpsNoAttack
	smpsModOff
	dc.b	nG6, $18, smpsNoAttack

Sound60_SpindashRev_Loop00:
	dc.b	$04, smpsNoAttack
	smpsAlterVol        $03
	smpsLoop            $00, $10, Sound60_SpindashRev_Loop00
	smpsStop

Sound60_SpindashRev_Voices:
;	Voice $00
;	$34
;	$00, $0C, $03, $09, 	$9F, $8F, $8C, $95, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$00, $00, $1D, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $09, $03, $0C, $00
	smpsVcRateScale     $02, $02, $02, $02
	smpsVcAttackRate    $15, $0C, $0F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $1D, $00, $00

