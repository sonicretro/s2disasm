Sound6E_MechaSonicBuzz_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound6E_MechaSonicBuzz_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, Sound6E_MechaSonicBuzz_FM5,	$00, $00
	smpsHeaderSFXChannel cPSG3, Sound6E_MechaSonicBuzz_PSG3,	$00, $00

; FM5 Data
Sound6E_MechaSonicBuzz_FM5:
	smpsSetvoice        $00
	dc.b	nA5, $24, smpsNoAttack

Sound6E_MechaSonicBuzz_Loop00:
	dc.b	nA5, $04, smpsNoAttack
	smpsAlterVol        $04
	smpsLoop            $00, $08, Sound6E_MechaSonicBuzz_Loop00
	smpsStop

; PSG3 Data
Sound6E_MechaSonicBuzz_PSG3:
	smpsPSGform         $E7
	dc.b	nBb5, $44
	smpsStop

Sound6E_MechaSonicBuzz_Voices:
;	Voice $00
;	$33
;	$00, $00, $10, $31, 	$1F, $1E, $1D, $0E, 	$00, $1D, $0C, $00
;	$00, $01, $00, $00, 	$0F, $0F, $0F, $0F, 	$08, $07, $06, $80
	smpsVcAlgorithm     $03
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $01, $00, $00
	smpsVcCoarseFreq    $01, $00, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0E, $1D, $1E, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $0C, $1D, $00
	smpsVcDecayRate2    $00, $00, $01, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $06, $07, $08

