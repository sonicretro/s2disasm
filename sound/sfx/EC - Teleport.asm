Sound6C_Teleport_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     Sound6C_Teleport_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $04

	smpsHeaderSFXChannel cFM5, Sound6C_Teleport_FM5,	$00, $10
	smpsHeaderSFXChannel cFM4, Sound6C_Teleport_FM4,	$00, $10
	smpsHeaderSFXChannel cPSG3, Sound5F_6C_PSG3,	$00, $00
	smpsHeaderSFXChannel cPSG2, Sound5F_6C_PSG2,	$00, $00

; FM4 Data
Sound6C_Teleport_FM4:
	smpsAlterNote       $10

; FM5 Data
Sound6C_Teleport_FM5:
	smpsSetvoice        $01
	smpsModSet          $01, $01, $EC, $56
	dc.b	nEb5, $24
	smpsModOff
	smpsSetvoice        $00
	smpsAlterVol        $F0

Sound6C_Teleport_Loop00:
	dc.b	nBb4, $02, smpsNoAttack
	smpsAlterVol        $02
	smpsAlterPitch      $01
	smpsLoop            $00, $20, Sound6C_Teleport_Loop00
	smpsStop

Sound6C_Teleport_Voices:
;	Voice $00
;	$00
;	$53, $03, $30, $30, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$00, $00, $00, $0F, 	$0F, $23, $06, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $00, $05
	smpsVcCoarseFreq    $00, $00, $03, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $00, $00, $00
	smpsVcTotalLevel    $80, $06, $23, $0F

;	Voice $01
;	$3C
;	$72, $32, $32, $72, 	$14, $0F, $14, $0F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$02, $08, $02, $08, 	$35, $00, $14, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $03, $07
	smpsVcCoarseFreq    $02, $02, $02, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0F, $14, $0F, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $08, $02, $08, $02
	smpsVcTotalLevel    $00, $14, $00, $35

