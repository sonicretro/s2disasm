Sound70_OilSlide_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoiceNull
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound70_OilSlide_PSG3,	$00, $00

; PSG3 Data
Sound70_OilSlide_PSG3:
	smpsPSGform         $E7
	dc.b	nMaxPSG, $18

Sound70_OilSlide_Loop00:
	dc.b	smpsNoAttack, $03
	smpsAlterVol        $01
	smpsLoop            $00, $08, Sound70_OilSlide_Loop00
	smpsStop
