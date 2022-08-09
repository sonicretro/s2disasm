Sound6B_LaserFloor_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     Sound6B_LaserFloor_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM4, Sound6B_LaserFloor_FM4,	$00, $02

; FM4 Data
Sound6B_LaserFloor_FM4:
	smpsSetvoice        $00
	dc.b	nC0, $04, nRst, $0C
	smpsStop

Sound6B_LaserFloor_Voices:
;	Voice $00
;	$3A
;	$30, $40, $30, $70, 	$1F, $1F, $1F, $1F, 	$12, $01, $0A, $07
;	$00, $01, $01, $03, 	$00, $C3, $23, $46, 	$08, $1C, $07, $03
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $04, $03
	smpsVcCoarseFreq    $00, $00, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $07, $0A, $01, $12
	smpsVcDecayRate2    $03, $01, $01, $00
	smpsVcDecayLevel    $04, $02, $0C, $00
	smpsVcReleaseRate   $06, $03, $03, $00
	smpsVcTotalLevel    $03, $07, $1C, $08

