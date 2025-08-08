Sound4A_SpecStageEntry_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound4A_SpecStageEntry_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound4A_SpecStageEntry_FM5,	$00, $02

; FM5 Data
Sound4A_SpecStageEntry_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $5B, $02
	dc.b	nEb6, $65
	smpsStop

Sound4A_SpecStageEntry_Voices:
;	Voice $00
;	$20
;	$36, $35, $30, $31, 	$41, $49, $3B, $4B, 	$09, $06, $09, $08
;	$01, $03, $02, $A9, 	$0F, $0F, $0F, $0F, 	$29, $27, $23, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $04
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $01, $00, $05, $06
	smpsVcRateScale     $01, $00, $01, $01
	smpsVcAttackRate    $0B, $3B, $09, $01
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $09, $06, $09
	smpsVcDecayRate2    $A9, $02, $03, $01
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $23, $27, $29

