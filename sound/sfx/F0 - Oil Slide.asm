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
    if FixMusicAndSFXDataBugs
	smpsPSGAlterVol     $01
    else
	; This command is for FM, not PSG!
	; This works fine in Sonic 2's driver, but not other drivers!
	smpsAlterVol        $01
    endif
	smpsLoop            $00, $08, Sound70_OilSlide_Loop00
	smpsStop
