Sound20_Jump_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoiceNull
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG1, Sound20_Jump_PSG1,	$F4, $00

; PSG1 Data
Sound20_Jump_PSG1:
	smpsPSGvoice        $00
	dc.b	nF2, $05
	smpsModSet          $02, $01, $F8, $65
	dc.b	nBb2, $15
	smpsStop
