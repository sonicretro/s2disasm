Sound5A_Gloop_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     Sound5A_Gloop_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound5A_Gloop_FM5,	$00, $00

; FM5 Data
Sound5A_Gloop_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $7F, $F1
	dc.b	nF3, $0A
	smpsStop

Sound5A_Gloop_Voices:
;	Voice $00
;	$47
;	$03, $02, $02, $04, 	$5F, $5F, $5F, $5F, 	$0E, $11, $1A, $0A
;	$09, $0A, $0A, $0A, 	$4F, $3F, $3F, $3F, 	$7F, $80, $80, $A3
	smpsVcAlgorithm     $07
	smpsVcFeedback      $00
	smpsVcUnusedBits    $01
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $04, $02, $02, $03
	smpsVcRateScale     $01, $01, $01, $01
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $1A, $11, $0E
	smpsVcDecayRate2    $0A, $0A, $0A, $09
	smpsVcDecayLevel    $03, $03, $03, $04
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $A3, $80, $80, $7F

