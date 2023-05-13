Sound59_LargeBumper_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     Sound59_LargeBumper_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $03

	smpsHeaderSFXChannel cFM4, Sound59_LargeBumper_FM4,	$00, $00
	smpsHeaderSFXChannel cFM3, Sound59_LargeBumper_FM3,	$00, $02
	smpsHeaderSFXChannel cFM5, Sound59_LargeBumper_FM5,	$00, $00

; FM4 Data
Sound59_LargeBumper_FM4:
	smpsSetvoice        $00
	smpsAlterNote       $0C
	dc.b	nE4, $14
	smpsStop

; FM3 Data
Sound59_LargeBumper_FM3:
	smpsSetvoice        $01
	dc.b	nCs2, $03
	smpsStop

; FM5 Data
Sound59_LargeBumper_FM5:
	smpsSetvoice        $00
	dc.b	nF4, $14
	smpsStop

Sound59_LargeBumper_Voices:
;	Voice $00
;	$32
;	$30, $40, $30, $70, 	$1F, $1F, $1F, $1F, 	$12, $01, $0A, $0D
;	$00, $01, $01, $0C, 	$00, $C3, $23, $F6, 	$08, $1C, $07, $03
	smpsVcAlgorithm     $02
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $04, $03
	smpsVcCoarseFreq    $00, $00, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0D, $0A, $01, $12
	smpsVcDecayRate2    $0C, $01, $01, $00
	smpsVcDecayLevel    $0F, $02, $0C, $00
	smpsVcReleaseRate   $06, $03, $03, $00
	smpsVcTotalLevel    $03, $07, $1C, $08

;	Voice $01
;	$05
;	$00, $00, $00, $00, 	$1F, $1F, $1F, $1F, 	$12, $0C, $0C, $0C
;	$12, $08, $08, $08, 	$1F, $5F, $5F, $5F, 	$07, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0C, $0C, $0C, $12
	smpsVcDecayRate2    $08, $08, $08, $12
	smpsVcDecayLevel    $05, $05, $05, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $80, $80, $07

