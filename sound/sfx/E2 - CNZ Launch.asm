Sound62_CNZLaunch_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound62_CNZLaunch_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound62_CNZLaunch_FM5,	$FF, $00

; FM5 Data
Sound62_CNZLaunch_FM5:
	smpsSetvoice        $00
	dc.b	nCs3, $05
	smpsModSet          $01, $01, $E7, $40

Sound62_CNZLaunch_Loop00:
	dc.b	nG5, $02, smpsNoAttack
	smpsAlterVol        $01
	smpsLoop            $00, $12, Sound62_CNZLaunch_Loop00
	smpsStop

Sound62_CNZLaunch_Voices:
;	Voice $00
;	$34
;	$0C, $73, $10, $0C, 	$AF, $FF, $AC, $D5, 	$06, $02, $00, $01
;	$02, $04, $0A, $08, 	$BF, $BF, $BF, $BF, 	$00, $80, $08, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $01, $07, $00
	smpsVcCoarseFreq    $0C, $00, $03, $0C
	smpsVcRateScale     $03, $02, $03, $02
	smpsVcAttackRate    $15, $2C, $3F, $2F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $01, $00, $02, $06
	smpsVcDecayRate2    $08, $0A, $04, $02
	smpsVcDecayLevel    $0B, $0B, $0B, $0B
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $08, $00, $00

