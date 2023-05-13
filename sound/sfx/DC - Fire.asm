Sound5C_Fire_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound5C_Fire_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM4, Sound5C_Fire_FM4,	$00, $0E
	smpsHeaderSFXChannel cPSG3, Sound5C_Fire_PSG3,	$00, $00

; FM4 Data
Sound5C_Fire_FM4:
	smpsSetvoice        $00
	dc.b	nE0, $40

Sound5C_Fire_Loop00:
	dc.b	smpsNoAttack, $04
	smpsAlterVol        $04
	smpsLoop            $00, $0A, Sound5C_Fire_Loop00
	smpsStop

; PSG3 Data
Sound5C_Fire_PSG3:
	smpsPSGvoice        $00
	smpsPSGform         $E7
	dc.b	nD3, $40

Sound5C_Fire_Loop01:
	dc.b	smpsNoAttack, $08
	smpsAlterVol        $01
	smpsLoop            $00, $05, Sound5C_Fire_Loop01
	smpsStop

Sound5C_Fire_Voices:
;	Voice $00
;	$FA
;	$12, $01, $01, $01, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$81, $14, $8E, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $03
	smpsVcDetune        $00, $00, $00, $01
	smpsVcCoarseFreq    $01, $01, $01, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $8E, $14, $81

