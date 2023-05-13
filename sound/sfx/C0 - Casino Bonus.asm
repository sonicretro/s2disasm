Sound40_CasinoBonus_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound3F_40_42_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, Sound40_CasinoBonus_FM5,	$00, $08
	smpsHeaderSFXChannel cFM4, Sound40_CasinoBonus_FM4,	$00, $08

; FM4 Data
Sound40_CasinoBonus_FM4:
	smpsAlterNote       $03
	dc.b	nRst, $02

; FM5 Data
Sound40_CasinoBonus_FM5:
	smpsSetvoice        $00
	dc.b	nG5, $16
	smpsStop
