Sound48_Flamethrower_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoiceNull
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound48_Flamethrower_PSG3,	$00, $00

; PSG3 Data
Sound48_Flamethrower_PSG3:
	smpsPSGvoice        $00
	smpsPSGform         $E7
	dc.b	nD3, $25
	smpsStop
