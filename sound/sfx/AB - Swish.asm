Sound2B_Swish_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoiceNull
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound2B_Swish_PSG3,	$00, $00

; PSG3 Data
Sound2B_Swish_PSG3:
	smpsPSGvoice        $00
	smpsPSGform         $E7
	dc.b	nMaxPSG, $03, nRst, $03, nMaxPSG, $01, smpsNoAttack

Sound2B_Swish_Loop00:
	dc.b	$01
	smpsPSGAlterVol     $01
	dc.b	smpsNoAttack
	smpsLoop            $00, $15, Sound2B_Swish_Loop00
	smpsStop
