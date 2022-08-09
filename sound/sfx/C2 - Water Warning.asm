Sound42_WaterWarning_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound3F_40_42_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound42_WaterWarning_FM5,	$0C, $08

; FM5 Data
Sound42_WaterWarning_FM5:
	smpsSetvoice        $00
	dc.b	nA4, $08, nA4, $25
	smpsStop
