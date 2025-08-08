Sound61_Rumbling2_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     Sound61_Rumbling2_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM4, Sound61_Rumbling2_FM4,	$00, $04

; FM4 Data
Sound61_Rumbling2_FM4:
	dc.b	nRst, $01
	smpsSetvoice        $00
	smpsModSet          $00, $01, $70, $06
	dc.b	nCs0, $06, nE0, $08, nD0, $01, nCs0, $05, nF0, $06, nAb0, $03
	dc.b	nCs0, $08, nG0, $04, nCs0, $06
	smpsAlterVol        $02
	dc.b	nE0, $08
	smpsAlterVol        $02
	dc.b	nD0, $01
	smpsAlterVol        $02
	dc.b	nCs0, $05
	smpsAlterVol        $02
	dc.b	nF0, $06
	smpsAlterVol        $02
	dc.b	nAb0, $03
	smpsAlterVol        $02
	dc.b	nCs0, $08
	smpsAlterVol        $02
	dc.b	nG0, $04
	smpsAlterVol        $02
	smpsStop

Sound61_Rumbling2_Voices:
;	Voice $00
;	$32
;	$30, $50, $30, $30, 	$1F, $19, $0E, $0E, 	$07, $15, $12, $09
;	$0A, $1D, $09, $06, 	$E8, $0A, $03, $17, 	$07, $00, $00, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $05, $03
	smpsVcCoarseFreq    $00, $00, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0E, $0E, $19, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $09, $12, $15, $07
	smpsVcDecayRate2    $06, $09, $1D, $0A
	smpsVcDecayLevel    $01, $00, $00, $0E
	smpsVcReleaseRate   $07, $03, $0A, $08
	smpsVcTotalLevel    $00, $00, $00, $07

