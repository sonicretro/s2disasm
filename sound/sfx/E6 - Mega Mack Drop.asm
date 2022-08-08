Sound66_MegaMackDrop_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound66_MegaMackDrop_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, Sound66_MegaMackDrop_FM5,	$EE, $08
	smpsHeaderSFXChannel cPSG3, Sound66_MegaMackDrop_PSG3,	$00, $00

; PSG3 Data
Sound66_MegaMackDrop_PSG3:
	smpsPSGform         $E7
	smpsPSGvoice        fTone_09
	dc.b	nMaxPSG, $36
	smpsStop

; FM5 Data
Sound66_MegaMackDrop_FM5:
	smpsSetvoice        $00
	dc.b	nRst, $01, nF1, $02, $02, $02, $30
	smpsStop

Sound66_MegaMackDrop_Voices:
;	Voice $00
;	$32
;	$33, $34, $17, $13, 	$0F, $1B, $0D, $17, 	$00, $02, $04, $0B
;	$08, $08, $00, $09, 	$6F, $4F, $5F, $6F, 	$05, $00, $00, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $01, $01, $03, $03
	smpsVcCoarseFreq    $03, $07, $04, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $17, $0D, $1B, $0F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0B, $04, $02, $00
	smpsVcDecayRate2    $09, $00, $08, $08
	smpsVcDecayLevel    $06, $05, $04, $06
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $00, $00, $05

