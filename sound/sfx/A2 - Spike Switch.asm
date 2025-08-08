Sound22_SpikeSwitch_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoiceNull
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound22_SpikeSwitch_PSG3,	$00, $00

; PSG3 Data
Sound22_SpikeSwitch_PSG3:
	smpsModSet          $01, $01, $F0, $08
	smpsPSGform         $E7
	dc.b	nEb5, $04, nCs6, $04

Sound22_SpikeSwitch_Loop00:
	dc.b	nEb5, $01
	smpsPSGAlterVol     $01
	smpsLoop            $00, $06, Sound22_SpikeSwitch_Loop00
	smpsStop
