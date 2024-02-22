Sound6F_LargeLaser_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     Sound6A_6F_Laser_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $03

	smpsHeaderSFXChannel cFM5, Sound6F_LargeLaser_FM5,	$00, $0B
	smpsHeaderSFXChannel cFM4, Sound6F_LargeLaser_FM4,	$00, $12
	smpsHeaderSFXChannel cPSG3, Sound6F_LargeLaser_PSG3,	$00, $00

; FM4 Data
Sound6F_LargeLaser_FM4:
	smpsAlterNote       $02
	dc.b	nRst, $02

; FM5 Data
Sound6F_LargeLaser_FM5:
	smpsSetvoice        $00
	smpsAlterVol        $0C
	dc.b	nBb7, $06, smpsNoAttack
	smpsAlterVol        $F4
	dc.b	$06, smpsNoAttack
	smpsAlterVol        $F4
	dc.b	$12, smpsNoAttack
	smpsAlterVol        $0C
	dc.b	$06, smpsNoAttack
	smpsAlterVol        $0C
	dc.b	$06
	smpsStop

; PSG3 Data
Sound6F_LargeLaser_PSG3:
	smpsPSGform         $E7
	dc.b	nMaxPSG, $04, nEb5, nA4, nEb4, nA3
    if FixMusicAndSFXDataBugs
	smpsPSGAlterVol     $01
    else
	; This command is for FM, not PSG!
	; This works fine in Sonic 2's driver, but not other drivers!
	smpsAlterVol        $01
    endif
	dc.b	nA3
    if FixMusicAndSFXDataBugs
	smpsPSGAlterVol     $01
    else
	; This command is for FM, not PSG!
	; This works fine in Sonic 2's driver, but not other drivers!
	smpsAlterVol        $01
    endif
	dc.b	nA3
    if FixMusicAndSFXDataBugs
	smpsPSGAlterVol     $01
    else
	; This command is for FM, not PSG!
	; This works fine in Sonic 2's driver, but not other drivers!
	smpsAlterVol        $01
    endif
	dc.b	nA3
	smpsStop
