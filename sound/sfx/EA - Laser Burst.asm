Sound6A_LaserBurst_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     Sound6A_6F_Laser_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound6A_LaserBurst_FM5,	$00, $04

; FM5 Data
Sound6A_LaserBurst_FM5:
	smpsSetvoice        $00
	dc.b	nBb7, $14
	smpsAlterVol        $18
	dc.b	$06
	smpsStop

Sound6A_6F_Laser_Voices:
;	Voice $00
;	$3D
;	$09, $34, $34, $28, 	$1F, $16, $16, $16, 	$00, $00, $00, $04
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$15, $02, $02, $00
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $02, $03, $03, $00
	smpsVcCoarseFreq    $08, $04, $04, $09
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $16, $16, $16, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $02, $02, $15

